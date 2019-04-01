unit pSHAutoComplete;

{$I SynEdit.inc}

interface

uses Classes, SysUtils, Contnrs, Menus, Clipbrd, Types,
     SynEdit, SynEditKeyCmds, SynEditTextBuffer, SynEditTypes,
     SynCompletionProposal, Windows,
     pSHIntf, pSHCommon;

type

  TpSHAutoComplete = class(TComponent)
  private
    FEditors: TList;
//    FFieldListRetrievers: TList;
//    FFieldListRetrievers: TInterfaceList;
    FFieldListRetrievers: TComponentList;
    FCaseSQLCode: TpSHCaseCode;
    FShortCut: TShortCut;
    FNoNextKey : Boolean;
    FEndOfTokenChr: string;
    FTemplatesList: TStringList;
    FCommentsList: TStringList;
    FCodeList: TStringList;

    function GetEditor(I: Integer): TCustomSynEdit;
    procedure SetTemplatesList(Value: TStringList);
    procedure SetCodeList(const Value: TStringList);
    procedure SetCommentsList(const Value: TStringList);
    procedure SetShortCut(const Value: TShortCut);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    procedure EditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
      virtual;
    procedure EditorKeyPress(Sender: TObject; var Key: Char); virtual;
    procedure Execute(AToken: string; Editor: TCustomSynEdit; AFieldListRetriever: IpSHFieldListRetriever);
    function GetPreviousToken(Editor: TCustomSynEdit): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    procedure AddEditor(AEditor: TCustomSynEdit; AFieldListRetriever: IInterface = nil);
    function RemoveEditor(AEditor: TCustomSynEdit): Boolean;
    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const AFileName: string);
    procedure AddCompletion(const ATemplate, AComment, ACode: string);
    function EditorsCount: Integer;
    property Editors[I: Integer]: TCustomSynEdit read GetEditor;
  published
    property TemplatesList: TStringList read FTemplatesList
      write SetTemplatesList;
    property CommentsList: TStringList read FCommentsList
      write SetCommentsList;
    property CodeList: TStringList read FCodeList
      write SetCodeList;
    property CaseSQLCode: TpSHCaseCode read FCaseSQLCode
      write FCaseSQLCode default ccUpper;
    property EndOfTokenChr: string read FEndOfTokenChr write FEndOfTokenChr;
    property ShortCut: TShortCut read FShortCut write SetShortCut;
  end;

implementation

uses TypInfo;

{ TpSHAutoComplete }

function TpSHAutoComplete.GetEditor(I: Integer): TCustomSynEdit;
begin
  if (I < 0) or (I >= EditorsCount) then
    Result := nil
  else
    Result := FEditors[I];
end;

procedure TpSHAutoComplete.SetTemplatesList(Value: TStringList);
begin
  FTemplatesList.Assign(Value);
end;

procedure TpSHAutoComplete.SetCodeList(const Value: TStringList);
begin
  FCodeList.Assign(Value);
end;

procedure TpSHAutoComplete.SetCommentsList(const Value: TStringList);
begin
  FCommentsList.Assign(Value);
end;

procedure TpSHAutoComplete.SetShortCut(const Value: TShortCut);
begin
  FShortCut := Value;
end;

procedure TpSHAutoComplete.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent is TCustomSynEdit then
      RemoveEditor(TCustomSynEdit(AComponent));
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TpSHAutoComplete.EditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ShortCutKey   : Word;
  ShortCutShift : TShiftState;
  I: Integer;
  vFieldListRetriever: IpSHFieldListRetriever;
begin
  I := FEditors.IndexOf(Sender);
  if (I <> -1) and (not (Sender as TCustomSynEdit).ReadOnly) then
  begin
    ShortCutToKey(FShortCut, ShortCutKey, ShortCutShift);
    if (Shift = ShortCutShift) and (Key = ShortCutKey) then
    begin
//      if Assigned(FFieldListRetrievers) and Assigned(FFieldListRetrievers[I]) then
      if Assigned(FFieldListRetrievers) then
      begin
        Supports(TObject(FFieldListRetrievers[I]), IpSHFieldListRetriever, vFieldListRetriever);
        Execute(GetPreviousToken(Sender as TCustomSynEdit),
                (Sender as TCustomSynEdit), vFieldListRetriever);
      end;          
//      FNoNextKey := True;
//      if FNoNextKey then
//        Key := 0;
    end;
  end;  
end;

procedure TpSHAutoComplete.EditorKeyPress(Sender: TObject;
  var Key: Char);
begin
  if FNoNextKey then
  begin
    FNoNextKey := False;
    Key := #0;
  end;
end;

procedure TpSHAutoComplete.Execute(AToken: string;
  Editor: TCustomSynEdit; AFieldListRetriever: IpSHFieldListRetriever);
var
  I, J: integer;
//  StartOfBlock: TPoint;
  StartOfBlock: TBufferCoord;
  ChangedIndent   : Boolean;
  ChangedTrailing : Boolean;
  TmpOptions : TSynEditorOptions;
  OrigOptions: TSynEditorOptions;
  BeginningSpaceCount : Integer;
  Spacing: string;
  InRepeatableGroup: Boolean;
  RepeatableGroupI: Integer;
  vObjectName: string;
  FieldList: TStringList;
  function LogonUserName: string;
  var
    P: PChar;
    vSize: Cardinal;
  begin
    P := StrAlloc(255);
    if GetUserName(P, vSize) then
      SetString(Result, P, vSize)
    else
      Result := EmptyStr;
    StrDispose(P);  
  end;
  procedure ProcessString(AString: string);
  var
    J, K: Integer;
    GroupStart, GroupEnd: Integer;
    Group: string;
    CurrentField: string;
    vString: string;
    SpacesFromLineBegin: Integer;
    IsLineBegin: Boolean;
    S: string;
  begin
    J := 1;
    vString := AString;
    SpacesFromLineBegin := 0;
    IsLineBegin := True;
    while J <= Length(vString) do
    begin
      case vString[J] of
        #9: Editor.CommandProcessor(ecTab, vString[J], nil);
        #13: begin
               if (J < Length(vString)) and (vString[J + 1] = #10) then
               begin
                 IsLineBegin := True;
                 SpacesFromLineBegin := 0;
                 Inc(J);
                 Editor.CommandProcessor (ecLineBreak, ' ', nil);
                 for K := 1 to Length(Spacing) do
                   if (Spacing[K]=#9) then
                     Editor.CommandProcessor(ecTab,#9,nil)
                   else
                     Editor.CommandProcessor (ecChar, ' ', nil);
               end;
             end;
        '|': StartOfBlock := Editor.CaretXY;
        '#':
             if ((Length(vString) - J) >= Length('Author')) and
                AnsiSameText(Copy(vString, J + 1, Length('Author')), 'Author') then
             begin
               Inc(J, Length('Author'));
               ProcessString(LogonUserName);
             end
             else
             if ((Length(vString) - J) >= Length('Date')) and
                AnsiSameText(Copy(vString, J + 1, Length('Date')), 'Date') then
             begin
               Inc(J, Length('Date'));
               ProcessString(DateToStr(Now));
             end
             else
             if ((Length(vString) - J) >= Length('Time')) and
                AnsiSameText(Copy(vString, J + 1, Length('Time')), 'Time') then
             begin
               Inc(J, Length('Time'));
               ProcessString(TimeToStr(Time));
             end
             else
             if not InRepeatableGroup then
               Editor.PasteFromClipboard
             else
             begin
               CurrentField := FieldList[RepeatableGroupI];
               ProcessString(CurrentField);
             end;
        '^': begin
               S := Copy(Editor.LineText, 1, Editor.CaretX - 1);
               if S = Spacing then
                 Editor.CaretX := 1;
               if Editor.CaretX = 0 then
               begin
                 Editor.CaretY := Editor.CaretY - 1;
                 Editor.CaretX := Length(Editor.LineText);
               end
               else
                 Editor.CommandProcessor(ecDeleteLastChar, ' ', nil);
             end;
        ' ': begin
               if IsLineBegin then
                 Inc(SpacesFromLineBegin);
               Editor.CommandProcessor(ecChar, vString[J], nil);
             end;
        '~': begin
               if (J < Length(vString)) and (vString[J + 1] = '{') then
               begin
                 Inc(J, 2);
                 GroupStart := J;
                 while (J <= Length(vString)) and (vString[J] <> '}') do
                   Inc(J);
                 GroupEnd := J;
//                 Inc(J);
                 if Assigned(AFieldListRetriever) and
                    (not InRepeatableGroup) then
                 begin
                   vObjectName := Clipboard.AsText;
                   FieldList := TStringList.Create;
                   try
                     AFieldListRetriever.GetFieldList(vObjectName, FieldList);
                     if FieldList.Count > 0 then
                     begin
                       Group := Copy(vString, GroupStart, GroupEnd - GroupStart);
                       InRepeatableGroup := True;
                       for K := 0 to FieldList.Count - 1 do
                       begin
                         RepeatableGroupI := K;
                         if K = 0 then
                           ProcessString(Group)
                         else
                           ProcessString(StringOfChar(' ',SpacesFromLineBegin) + Group);
                        end;
                       InRepeatableGroup := False;
                     end;
                   finally
                     FieldList.Free;
                   end;
                 end;
               end
               else
                 Editor.CommandProcessor(ecChar, vString[J], nil);
             end;
        else
        begin
          Editor.CommandProcessor(ecChar, vString[J], nil);
          IsLineBegin := False;
          SpacesFromLineBegin := 0;
        end;
      end;
      Inc(J);
    end;
  end;
begin
  I := TemplatesList.IndexOf(AToken);
    if (I <> -1) then
  begin
    TmpOptions := Editor.Options;
    OrigOptions:= Editor.Options;
    ChangedIndent   := eoAutoIndent in TmpOptions;
    ChangedTrailing := eoTrimTrailingSpaces in TmpOptions;

    if ChangedIndent then Exclude(TmpOptions, eoAutoIndent);
    if ChangedTrailing then Exclude(TmpOptions, eoTrimTrailingSpaces);

    if ChangedIndent or ChangedTrailing then
      Editor.Options := TmpOptions;

    Editor.UndoList.AddChange(crAutoCompleteBegin, StartOfBlock, StartOfBlock, '',
      smNormal);

    FNoNextKey := True;
    for J := 1 to Length(AToken) do
      Editor.CommandProcessor(ecDeleteLastChar, ' ', nil);
    BeginningSpaceCount := Editor.DisplayX - 1;
    if (not (eoTabsToSpaces in Editor.Options)) and
            (BeginningSpaceCount >= Editor.TabWidth) then
      Spacing:=StringOfChar(#9,BeginningSpaceCount div Editor.TabWidth)+StringOfChar(' ',BeginningSpaceCount mod Editor.TabWidth)
    else
      Spacing:=StringOfChar(' ',BeginningSpaceCount);

    StartOfBlock.Char := -1;
    StartOfBlock.Line := -1;

    InRepeatableGroup := False;

    ProcessString(DoCaseCode(TrimRight(CodeList[I]), CaseSQLCode));

    if (StartOfBlock.Char <> -1) and (StartOfBlock.Line <> -1) then
      Editor.CaretXY := StartOfBlock;

    if ChangedIndent or ChangedTrailing then Editor.Options := OrigOptions;

    Editor.UndoList.AddChange(crAutoCompleteEnd, StartOfBlock, StartOfBlock, '',
      smNormal);
    FNoNextKey := False;
  end;
end;

function TpSHAutoComplete.GetPreviousToken(
  Editor: TCustomSynEdit): string;
var
  S: string;
  I: integer;
begin
  Result := '';
  if Editor <> nil then begin
    S := Editor.LineText;
    I := Editor.CaretX - 1;
    if I <= Length (s) then begin
      while (I > 0) and (S[I] > ' ') and (pos(S[I], FEndOfTokenChr) = 0) do
        Dec(i);
      Result := copy(S, I + 1, Editor.CaretX - I - 1);
    end;
  end
end;

constructor TpSHAutoComplete.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEditors := TList.Create;
//  FFieldListRetrievers := TList.Create;
//  FFieldListRetrievers := TInterfaceList.Create;
  FFieldListRetrievers := TComponentList.Create;
  FFieldListRetrievers.OwnsObjects := True;
  FTemplatesList := TStringList.Create;
  FTemplatesList.CaseSensitive := False;
//  FTemplatesList.Sorted := True;
//  FTemplatesList.Duplicates := dupIgnore;
  FCommentsList := TStringList.Create;
  FCodeList := TStringList.Create;
//  FEndOfTokenChr := DefaultEndOfTokenChr;
  FEndOfTokenChr := ' ';
  FNoNextKey := False;
{$IFDEF SYN_CLX}
  FShortCut := QMenus.ShortCut(Ord('J'), [ssCtrl]);
{$ELSE}
//  FShortCut := Menus.ShortCut(Ord(' '), [ssShift]);
  FShortCut := Menus.ShortCut(Ord('J'), [ssCtrl]);
{$ENDIF}
end;

destructor TpSHAutoComplete.Destroy;
begin
  while FEditors.Count <> 0 do
    RemoveEditor(TCustomSynEdit(FEditors.Last));
//  inherited;
  FEditors.Free;
  FFieldListRetrievers.Free;
//  FFieldListRetrievers := nil;
  FTemplatesList.Free;
  FCommentsList.Free;
  FCodeList.Free;
  inherited;
end;

procedure TpSHAutoComplete.Clear;
begin
  FTemplatesList.Clear;
  FCommentsList.Clear;
  FCodeList.Clear;
end;

procedure TpSHAutoComplete.AddEditor(AEditor: TCustomSynEdit; AFieldListRetriever: IInterface = nil);
var
  I: Integer;
//  vFieldListRetriever: IpSHFieldListRetriever;
  vComponentReference: IInterfaceComponentReference;
begin
//  Supports(AFieldListRetriever, IpSHFieldListRetriever, vFieldListRetriever);
  I := FEditors.IndexOf(AEditor);
  if I = -1 then
  begin
    AEditor.FreeNotification(Self);
    FEditors.Add(AEditor);
//    FFieldListRetrievers.Add(pointer(vFieldListRetriever));
//    FFieldListRetrievers.Add(vFieldListRetriever);
    if Supports(AFieldListRetriever, IInterfaceComponentReference, vComponentReference) then
      FFieldListRetrievers.Add(vComponentReference.GetComponent)
    else
      FFieldListRetrievers.Add(nil);
    AEditor.AddKeyDownHandler(EditorKeyDown);
    AEditor.AddKeyPressHandler(EditorKeyPress);
  end
  else
  begin
//    if FFieldListRetrievers[I] <> pointer(vFieldListRetriever) then
    if Supports(AFieldListRetriever, IInterfaceComponentReference, vComponentReference) then
    begin
      if (FFieldListRetrievers[I] <> vComponentReference.GetComponent) then
  //      FFieldListRetrievers[I] := pointer(vFieldListRetriever);
        FFieldListRetrievers[I] := vComponentReference.GetComponent;
    end
    else
      FFieldListRetrievers[I] := nil;
  end;
end;

function TpSHAutoComplete.RemoveEditor(AEditor: TCustomSynEdit): Boolean;
var
  I: Integer;
begin
  I := FEditors.Remove(AEditor);
  Result := I <> -1;
  if Result then
  begin
    FFieldListRetrievers.Delete(I);
    AEditor.RemoveKeyDownHandler(EditorKeyDown);
    AEditor.RemoveKeyPressHandler(EditorKeyPress);
    RemoveFreeNotification(AEditor);
  end;
end;

procedure TpSHAutoComplete.LoadFromFile(const AFileName: string);
var
  vTemplates: TStringList;
  I: Integer;
  vHeader: string;
  vPos: Integer;
  vTemplate, vCode, vComment: string;
  function SkipEmptyStrings: Boolean;
  begin
    while (I < vTemplates.Count) and
          ((Length(Trim(vTemplates[I])) = 0) or (vTemplates[I][1] = ';')) do
      Inc(I);
    Result := I < vTemplates.Count;
  end;
begin
  if FileExists(AFileName) then
  begin
    Clear;
    I := 0;
    vTemplates := TStringList.Create;
    try
      vTemplates.LoadFromFile(AFileName);
      while (I < vTemplates.Count) do
      begin
        if not SkipEmptyStrings then Break;
        vHeader := Trim(vTemplates[I]);
        if (vHeader[1] = '[') and (vHeader[Length(vHeader)] = ']') then
        begin
          vPos := Pos(' | ', vHeader);
          if vPos > 0 then
          begin
            vTemplate := Trim(Copy(vHeader, 2, vPos - 2));
            vComment := Trim(Copy(vHeader, vPos + 3, Length(vHeader) - 3 - vPos));
          end
          else
          begin
            vTemplate := Trim(Copy(vHeader, 2, Length(vHeader) - 2));
            vComment := '';
          end;
          Inc(I);
          if not SkipEmptyStrings then Break;
          vCode := '';
          while (I < vTemplates.Count) do
          begin
            if not ((Length(vTemplates[I]) = 0) or (vTemplates[I][1] = ';')) then
            begin
              if vTemplates[I][1] = '[' then Break;
              vCode := vCode + vTemplates[I] + sLineBreak;
            end;
            Inc(I)
          end;
          if Length(vCode) > 0 then
            Delete(vCode, Length(vCode) - 1, 2);
          AddCompletion(vTemplate, vComment, vCode);
        end;
      end;
    finally
      vTemplates.Free;
    end;
  end;
end;

procedure TpSHAutoComplete.SaveToFile(const AFileName: string);
const
  SHeader = '[%s | %s]';
var
  I: Integer;
  vTemplates: TStringList;
begin
  if FTemplatesList.Count > 0 then
  begin
    vTemplates := TStringList.Create;
    try
      for I := 0 to FTemplatesList.Count - 1 do
      begin
        vTemplates.Add(Format(SHeader, [FTemplatesList[I], FCommentsList[I]]));
        vTemplates.Add(FCodeList[I]);
        vTemplates.Add('');
      end;
      vTemplates.SaveToFile(AFileName);
    finally
      vTemplates.Free;
    end;
  end;  
end;

procedure TpSHAutoComplete.AddCompletion(const ATemplate, AComment,
  ACode: string);
begin
  FTemplatesList.Add(ATemplate);
  FCommentsList.Add(AComment);
  FCodeList.Add(ACode);
end;

function TpSHAutoComplete.EditorsCount: Integer;
begin
  Result := FEditors.Count;
end;

end.
