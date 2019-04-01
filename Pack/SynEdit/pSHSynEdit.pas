unit pSHSynEdit;

{$I SynEdit.inc}

interface

uses Types, Controls, Classes, Menus, Windows, Forms, Dialogs, Graphics, 
     SynEdit, SynEditTextBuffer, SynCompletionProposal, SynEditKeyCmds,
     SynEditMiscClasses, SynEditSearch, SynEditRegexSearch, SynEditTypes,
     pSHIntf, pSHFindTextFrm, pSHReplaceTextFrm, pSHConsts;

const
  ecDublicateBlock    = ecUserFirst + 1;
  ecSelectWord        = ecUserFirst + 2;
  ecSearchIncremental = ecUserFirst + 3;
//  ecCtrlEnter         = ecUserFirst + 4;
//  ecPrepareStatement  = ecUserFirst + 5;
  ecCommentBlock      = ecUserFirst + 6;
  ecCommentLine       = ecUserFirst + 7;
  ecShowDomains       = ecUserFirst + 8;
  ecShowTables        = ecUserFirst + 9;
  ecShowViews         = ecUserFirst + 10;
  ecShowTriggers      = ecUserFirst + 11;
  ecShowProcedures    = ecUserFirst + 12;
  ecShowGenerators    = ecUserFirst + 13;
  ecShowExceptions    = ecUserFirst + 14;
  ecShowFunctions     = ecUserFirst + 15;
  ecShowRoles         = ecUserFirst + 16;
  ecFind              = ecUserFirst + 17;
  ecSearchAgain       = ecUserFirst + 18;
  ecReplace           = ecUserFirst + 19;
  ecGoToLineNumber    = ecUserFirst + 20;
  ecHyperJump         = ecUserFirst + 21;
  ecQuaterWord        = ecUserFirst + 22;

  ecpSHUserFirst    = ecQuaterWord + 1;

type

  TFindTextChangeNotify = procedure(Sender: TObject;
    AIsSearchIncremental: Boolean; const AText: string) of object;

  TGutterDrawNotify = procedure(Sender: TObject;
    ALine: Integer; var ImageIndex: Integer) of object;

  TpSHGutterDrawer = class;
  TpSHDrawerBlocks = class;

  TpSHSynEdit = class(TSynEdit)
  private
    FHyperLinkRule: TpSHHyperLinkRule;
//    FUserOnMouseCursor: TMouseCursorEvent;
    FEventsSaved: Boolean;
    FCompletionProposal: TSynCompletionProposal;
//    FExecutableCommandManager: IpSHExecutableCommandManager;
    FIsSearchIncremental: Boolean;
    FAutoComplete: TSynAutoComplete;
    FSearchIncrementalBuffer: string;
//    FSearchIncrementalStartPos: TPoint;
    FSearchIncrementalStartPos: TBufferCoord;
    FFindText: string;
    FOnFindTextChange: TFindTextChangeNotify;
    FParametersHint: TSynCompletionProposal;
    FReplaceText: string;
    FFindTextOptions: TBTFindTextOptions;
    FUserInputHistory: IpSHUserInputHistory;
    FBottomEdgeVisible: Boolean;
    FBottomEdgeColor: TColor;
    FGutterDrawer: TpSHGutterDrawer;
    FDrawerBlocks:TpSHDrawerBlocks;
    FOnGutterDraw: TGutterDrawNotify;
    FDrawerBlocksPrepared:boolean;
    FDrawerNeedEasyReprepare:boolean;
    FShowBeginEndRegions:boolean;
    function GetKeywordsManager: IpSHKeywordsManager;
    procedure SetCompletionProposal(const Value: TSynCompletionProposal);
    procedure SetParametersHint(const Value: TSynCompletionProposal);
    function GetObjectNamesManager: IpSHObjectNamesManager;
    procedure SetIsSearchIncremental(const Value: Boolean);
    procedure SetAutoComplete(const Value: TSynAutoComplete);
    procedure SetSearchIncrementalBuffer(const Value: string);
    procedure SetFindText(const Value: string);
//    procedure SetExecutableCommandManager(
//      const Value: IpSHExecutableCommandManager);
    procedure SetUserInputHistory(const Value: IpSHUserInputHistory);
    procedure SetFindTextOptions(const Value: TBTFindTextOptions);
    function GetFindTextOptions: TBTFindTextOptions;
    function CreateSearchEngine(ACurrentSearchEngine: TSynEditSearchCustom;
      UseRegExpr: Boolean): TSynEditSearchCustom;
    procedure SetShowBeginEndRegions(const Value: boolean);
  protected
    vLeftOffsetBeforeChangeRow:integer;
    vLengthRowBeforeChange:integer;
    vBeginEndExistBeforeChangeRow:boolean;
    vLinesCount:integer;
    procedure Loaded; override;
//    procedure MouseCursorInternalEvent(Sender: TObject; const aLineCharPos: TBufferCoord;
//        var aCursor: TCursor);
    procedure DoOnProcessCommand(var Command: TSynEditorCommand;
      var AChar: char; Data: pointer); override;
    procedure FindReplaceTextFirst(DoReplace: Boolean);
    function DoFindReplaceText(DoReplace: Boolean): Boolean;
    procedure DoOnPaintTransientEx(TransientType: TTransientType; Lock: Boolean); override;
    procedure LinesChanged(Sender: TObject); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure DblClick; override;
    procedure DoOnReplace(Sender: TObject; const ASearch, AReplace:
       string; Line, Column: integer; var Action: TSynReplaceAction);
    procedure PaintTextLines(AClip: TRect; const aFirstRow, aLastRow,
      FirstCol, LastCol: integer); override;

    procedure Resize; override;      
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;


//Buzz

    procedure ExecuteCommand(Command: TSynEditorCommand; AChar: char;
      Data: pointer); override;

    function WordAtCaret:string;
    function GetMatchingBracketEx(const APoint: TBufferCoord): TBufferCoord; override;
    function GetTokenAt(XY: TBufferCoord; var TokenKind: Integer): string;
    function GetTokenPos(ALineNo, Ident: Integer;const AFindToken: string): Integer;
    function CanJump(var Token: string; Caret: TBufferCoord): Boolean;
    function CanJumpAtCursor: Boolean;
    function CanJumpAt(AAt: TDisplayCoord): Boolean;
    function IsIdentifiresEqual(const AIdentifire1, AIdentifire2: string): Boolean;
    function IsEmpty: Boolean;
    //User Commands
    procedure CommentSelected;
    procedure UnCommentSelected;
    procedure CommentUncomment;
    procedure CommentUncommentLine;
    function GetMatchingOperator(var APoint: TBufferCoord; ASearchEnd: Boolean): Boolean;
    //Search

    {->ISHSearchCommands = interface}

    procedure Find;
    procedure Replace;
    procedure SearchAgain;
    procedure SearchIncremental;
    procedure GoToLineNumber;

    {<-ISHSearchCommands = interface}

    //Managers and satillites
    property KeywordsManager: IpSHKeywordsManager read GetKeywordsManager;
    property ObjectNamesManager: IpSHObjectNamesManager read GetObjectNamesManager;

    property CompletionProposal: TSynCompletionProposal read FCompletionProposal
      write SetCompletionProposal;
    property AutoComplete: TSynAutoComplete read FAutoComplete
      write SetAutoComplete;
    property ParametersHint: TSynCompletionProposal read FParametersHint
      write SetParametersHint;

//    property ExecutableCommandManager: IpSHExecutableCommandManager
//      read FExecutableCommandManager write SetExecutableCommandManager;
    property UserInputHistory: IpSHUserInputHistory
      read FUserInputHistory write SetUserInputHistory;
    //properties
    property FindTextOptions: TBTFindTextOptions read GetFindTextOptions
      write SetFindTextOptions;
    property FindText: string read FFindText write SetFindText;
    property ReplaceText: string read FReplaceText write FReplaceText;


    property SearchIncrementalBuffer: string read FSearchIncrementalBuffer
      write SetSearchIncrementalBuffer;
    property IsSearchIncremental: Boolean read FIsSearchIncremental
      write SetIsSearchIncremental;
    property OnFindTextChange: TFindTextChangeNotify read FOnFindTextChange
      write FOnFindTextChange;
    property GutterDrawer: TpSHGutterDrawer read FGutterDrawer;
    property OnGutterDraw: TGutterDrawNotify read FOnGutterDraw
      write FOnGutterDraw;
  published

    property HyperLinkRule: TpSHHyperLinkRule read FHyperLinkRule
      write FHyperLinkRule default hlrSingleClick;

    property BottomEdgeVisible: Boolean read FBottomEdgeVisible
      write FBottomEdgeVisible;
    property BottomEdgeColor: TColor read FBottomEdgeColor
      write FBottomEdgeColor;
    property ShowBeginEndRegions:boolean read FShowBeginEndRegions
     write SetShowBeginEndRegions
    ;

//    property

//    property OnJumpTo: TBTJumpNotify read FOnJumpTo write FOnJumpTo;
  end;

  TPaintAction=(paMoveTo,paLineTo);


  TPaintPoint= record
    PointCoord:TDisplayCoord;
    Action:TPaintAction;
    Color :TColor;
    XOffset:integer;
    YOffset:integer;
    EndBlockPoint:integer;
    IsFirstPoint :boolean;
  end;

  TPaintScenario=Array of TPaintPoint;
  TLengths= record
   LengthStr:integer;
   LeftOffSet:integer;
  end;

  TLengthsArray  = array of TLengths;

  TpSHDrawerBlocks = class(TSynEditPlugin)
  private
    FScenario:TPaintScenario;
    FWordWrapped:boolean;
    FLinesLengths:TLengthsArray;
    function CharIndexToRowCol(Index: integer): TBufferCoord;
    function PrepareBlock(TempCoord1,TempCoord2:TDisplayCoord;BegBlockIndex:integer;CurColor:TColor):boolean;
    procedure EasyRePrepare;
    procedure EasyPrepareDeletedAddedLine(FirstLine,Count:integer;Deleted:boolean=True);
    procedure Prepare;
    procedure PaintBlock(BegBlockIndex:integer);
  protected
    procedure AfterPaint(ACanvas: TCanvas; const AClip: TRect;
      FirstLine, LastLine: integer); override;
    procedure LinesInserted(FirstLine, Count: integer); override;
    procedure LinesDeleted(FirstLine, Count: integer); override;
  public
  end;

  TpSHGutterDrawer = class(TSynEditPlugin)
  private
    FEnabled: Boolean;
    FImageList: TImageList;
  protected
    procedure AfterPaint(ACanvas: TCanvas; const AClip: TRect;
      FirstLine, LastLine: integer); override;
    procedure LinesInserted(FirstLine, Count: integer); override;
    procedure LinesDeleted(FirstLine, Count: integer); override;
  public
    property Enabled: Boolean read FEnabled write FEnabled;
    property ImageList: TImageList read FImageList write FImageList;
  end;

implementation

uses SysUtils,
     SynEditHighlighter,
     pSHHighlighter, pSHCompletionProposal, pSHAutoComplete,
     pSHConfirmReplaceFrm, pSHGotoLineNumberFrm,
     pSHSqlTxtRtns
     ;

function GetLeftTrimPos(const Str:string):integer;
begin
 Result:=1;
 while (Result <= Length(Str)) and (Str[Result] <= ' ') do
  Inc(Result);
 Dec(Result)
end;

{ TpSHSynEdit }

function TpSHSynEdit.GetKeywordsManager: IpSHKeywordsManager;
begin
  if Assigned(Highlighter) then
    Result := TpSHHighlighter(Highlighter).KeywordsManager
  else
    Result := nil;
end;

procedure TpSHSynEdit.SetCompletionProposal(
  const Value: TSynCompletionProposal);
begin
  if FCompletionProposal <> Value then
  begin
    if Assigned(Value) then
    begin
      if Assigned(FCompletionProposal) then
        FCompletionProposal.RemoveEditor(Self);
      FCompletionProposal := Value;
      FCompletionProposal.AddEditor(Self);
    end
    else
    begin
      if Assigned(FCompletionProposal) then
        FCompletionProposal.RemoveEditor(Self);
      FCompletionProposal := Value;
    end;
  end;
end;

procedure TpSHSynEdit.SetParametersHint(
  const Value: TSynCompletionProposal);
begin
  if FParametersHint <> Value then
  begin
    if Assigned(Value) then
    begin
      if Assigned(FParametersHint) then
        FParametersHint.RemoveEditor(Self);
      FParametersHint := Value;
      FParametersHint.AddEditor(Self);
    end
    else
    begin
      if Assigned(FParametersHint) then
        FParametersHint.RemoveEditor(Self);
      FParametersHint := Value;
    end;
  end;
end;

function TpSHSynEdit.GetObjectNamesManager: IpSHObjectNamesManager;
begin
  if Assigned(Highlighter) then
    Result := TpSHHighlighter(Highlighter).ObjectNamesManager
  else
    Result := nil;
end;

procedure TpSHSynEdit.SetIsSearchIncremental(const Value: Boolean);
begin
  if FIsSearchIncremental <> Value then
  begin
    FIsSearchIncremental := Value;
    SearchIncrementalBuffer := '';
    if Value then
    begin
      FSearchIncrementalStartPos := CaretXY;
      FindText := '';
    end
    else
    begin
      FindText := FindText;
      if SelAvail then
        BlockEnd := BlockBegin;
    end;
  end;
  if Assigned(CompletionProposal) then
    CompletionProposal.CancelCompletion;
  if Assigned(ParametersHint) then
    ParametersHint.CancelCompletion;
end;

procedure TpSHSynEdit.SetAutoComplete(const Value: TSynAutoComplete);
begin
  if FAutoComplete <> Value then
  begin
    FAutoComplete := Value;
    if Assigned(FAutoComplete) then
      TpSHAutoComplete(FAutoComplete).AddEditor(Self)
    else
      TpSHAutoComplete(FAutoComplete).RemoveEditor(Self);
  end;
end;

procedure TpSHSynEdit.SetSearchIncrementalBuffer(const Value: string);
begin
  if IsSearchIncremental then
  begin
    if Assigned(CompletionProposal) then
      CompletionProposal.CancelCompletion;
    if Assigned(ParametersHint) then
      ParametersHint.CancelCompletion;
    FindText := Value;
    if (Length(Value) = 0) and (Length(FSearchIncrementalBuffer) = 1) then
    begin
      if SelAvail then
        BlockBegin := BlockEnd;
      CaretXY := FSearchIncrementalStartPos;
    end
    else
      if SelAvail then
        CaretXY := BlockBegin;

    if (Length(Value) = 0) or DoFindReplaceText(False) then
      FSearchIncrementalBuffer := Value
    else
      FindText := FSearchIncrementalBuffer;
  end;
end;

procedure TpSHSynEdit.SetFindText(const Value: string);
begin
  FFindText := Value;
  if Assigned(FOnFindTextChange) then
    FOnFindTextChange(Self, IsSearchIncremental, FFindText);
end;

procedure TpSHSynEdit.SetUserInputHistory(
  const Value: IpSHUserInputHistory);
begin
  ReferenceInterface(FUserInputHistory, opRemove);
  FUserInputHistory := Value;
  ReferenceInterface(FUserInputHistory, opInsert);
end;

procedure TpSHSynEdit.SetFindTextOptions(
  const Value: TBTFindTextOptions);
begin
  FFindTextOptions := Value;
  if Assigned(UserInputHistory) then
    UserInputHistory.PromtOnReplace := (ftoPromptOnReplace in FFindTextOptions);
end;

function TpSHSynEdit.GetFindTextOptions: TBTFindTextOptions;
begin
  Result := FFindTextOptions;
  if Assigned(UserInputHistory) then
    if UserInputHistory.PromtOnReplace then
      Include(Result, ftoPromptOnReplace)
    else
      Exclude(Result, ftoPromptOnReplace);
end;

function TpSHSynEdit.CreateSearchEngine(
  ACurrentSearchEngine: TSynEditSearchCustom;
  UseRegExpr: Boolean): TSynEditSearchCustom;
begin
  Result := ACurrentSearchEngine;
  if Assigned(Result) then
    if (UseRegExpr and (Result.ClassName <> TSynEditRegexSearch.ClassName)) or
       ((not UseRegExpr) and (Result.ClassName <> TSynEditSearch.ClassName)) then
      FreeAndNil(Result);
  if not Assigned(Result) then
    if UseRegExpr then
      Result := TSynEditRegexSearch.Create(Self)
    else
      Result := TSynEditSearch.Create(Self);
end;

procedure TpSHSynEdit.Loaded;
begin
  inherited Loaded;
//  if (not (csLoading in ComponentState)) and (not FEventsSaved) then
//  begin
//    if Assigned(OnMouseCursor) then
//      FUserOnMouseCursor := OnMouseCursor;
//    OnMouseCursor := MouseCursorInternalEvent;
//    FEventsSaved := True;
//  end;
end;

//procedure TpSHSynEdit.MouseCursorInternalEvent(Sender: TObject;
//  const aLineCharPos: TBufferCoord; var aCursor: TCursor);
//begin
//  if Assigned(FUserOnMouseCursor) then
//    FUserOnMouseCursor(Sender, aLineCharPos, aCursor);
//end;

procedure TpSHSynEdit.DoOnProcessCommand(var Command: TSynEditorCommand;
  var AChar: char; Data: pointer);
var
  S: string;
//  vP: TPoint;
  vP: TBufferCoord;
  vWordAtCursor: string;
  vTokenKind: Integer;
//  vPos: TPoint;
  vPos: TBufferCoord;
  vLeftQuaterPresent, vRigthQuaterPresent: Boolean;
  vSaveCurretX: Integer;
  vBlockBegin, vBlockEnd: TBufferCoord;
  procedure GotoPoint(APoint: TBufferCoord);
  begin
    CaretXY := APoint;
    EnsureCursorPosVisibleEx(True);
  end;
begin
  if (Command > ecUserFirst) and (Command < ecpSHUserFirst) then
  begin
    case Command of
      ecDublicateBlock:
        begin
          if not SelAvail then
          begin
            BlockBegin := TBufferCoord(Point(1, CaretY));
            BlockEnd := TBufferCoord(Point(1, CaretY + 1));
          end;
          S := SelText;
          BlockBegin := BlockEnd;
          CaretXY := BlockEnd;
          vP := CaretXY;
          SelText := S;
          BlockBegin := vP;
          BlockEnd := CaretXY;
        end;
      ecSelectWord: SetSelWord;
      {
      ecCtrlEnter:
        begin
          if SelAvail then
          begin
            if Assigned(ExecutableCommandManager) then
              ExecutableCommandManager.RunQuery(SelText);
          end
          else
            if CanJump(S, CaretXY) and Assigned(ObjectNamesManager) then
              ObjectNamesManager.FindDeclaration(S)
            else
            begin
              if Assigned(ExecutableCommandManager) then
                ExecutableCommandManager.RunQuery(Text);
            end
        end;
      ecPrepareStatement:
        begin
          if SelAvail then
          begin
            if Assigned(ExecutableCommandManager) then
              ExecutableCommandManager.PrepareQuery(SelText);
          end
          else
            if Assigned(ExecutableCommandManager) then
              ExecutableCommandManager.PrepareQuery(Text);
        end;
      }
      ecCommentBlock: CommentUncomment;
      ecCommentLine: CommentUncommentLine;
      ecSearchIncremental: IsSearchIncremental := not IsSearchIncremental;
      ecShowDomains:
        if Assigned(CompletionProposal) then
          with TpSHCompletionProposal(CompletionProposal) do
          begin
            NeedObjectType := ntDomain;
            ActivateCompletion(Self);
          end;
      ecShowTables:
        if Assigned(CompletionProposal) then
          with TpSHCompletionProposal(CompletionProposal) do
          begin
            NeedObjectType := ntTable;
            ActivateCompletion(Self);
          end;
      ecShowViews:
        if Assigned(CompletionProposal) then
          with TpSHCompletionProposal(CompletionProposal) do
          begin
            NeedObjectType := ntView;
            ActivateCompletion(Self);
          end;
      ecShowTriggers:
        if Assigned(CompletionProposal) then
          with TpSHCompletionProposal(CompletionProposal) do
          begin
            NeedObjectType := ntTrigger;
            ActivateCompletion(Self);
          end;
      ecShowProcedures:
        if Assigned(CompletionProposal) then
          with TpSHCompletionProposal(CompletionProposal) do
          begin
            NeedObjectType := ntProcedure;
            ActivateCompletion(Self);
          end;
      ecShowGenerators:
        if Assigned(CompletionProposal) then
          with TpSHCompletionProposal(CompletionProposal) do
          begin
            NeedObjectType := ntGenerator;
            ActivateCompletion(Self);
          end;
      ecShowExceptions:
        if Assigned(CompletionProposal) then
          with TpSHCompletionProposal(CompletionProposal) do
          begin
            NeedObjectType := ntException;
            ActivateCompletion(Self);
          end;
      ecShowFunctions:
        if Assigned(CompletionProposal) then
          with TpSHCompletionProposal(CompletionProposal) do
          begin
            NeedObjectType := ntFunction;
            ActivateCompletion(Self);
          end;
      ecShowRoles:
        if Assigned(CompletionProposal) then
          with TpSHCompletionProposal(CompletionProposal) do
          begin
            NeedObjectType := ntRole;
            ActivateCompletion(Self);
          end;
      ecFind: Find;
      ecSearchAgain: SearchAgain;
      ecReplace: Replace;
      ecGoToLineNumber: GoToLineNumber;
      ecHyperJump:
        if CanJump(S, CaretXY) and Assigned(ObjectNamesManager) then
          ObjectNamesManager.FindDeclaration(S);
      ecQuaterWord:
        begin
          vSaveCurretX := CaretX;
          SetSelWord;
          if (Length(SelText) > 0) then
          begin
            vLeftQuaterPresent := False;
            vRigthQuaterPresent := False;
            if (BlockBegin.Char > 1) then
            begin
              S := Copy(Lines[BlockBegin.Line - 1], BlockBegin.Char - 1, 1);
              vLeftQuaterPresent := S = '"';
            end;
            if (BlockEnd.Char <= Length(Lines[BlockEnd.Line - 1])) then
            begin
              S := Copy(Lines[BlockEnd.Line - 1], BlockEnd.Char, 1);
              vRigthQuaterPresent := S = '"';
            end;
            S := SelText;
            if vLeftQuaterPresent and vRigthQuaterPresent then
            begin
              vBlockBegin := BlockBegin;
              vBlockEnd := BlockEnd;
              Dec(vBlockBegin.Char);
              Inc(vBlockEnd.Char);
              BlockBegin := vBlockBegin;
              BlockEnd := vBlockEnd;
              Dec(vSaveCurretX);
            end
            else
            begin
              if not vLeftQuaterPresent then
              begin
                S := '"' + S;
                Inc(vSaveCurretX);
              end;
              if not vRigthQuaterPresent then
                S := S + '"';
            end;
            SelText := S;
            CaretX := vSaveCurretX;
          end;
        end;
    end;
  end
  else
  begin
    inherited DoOnProcessCommand(Command, AChar, Data);
    case Command of
      ecMatchBracket:
        begin
          vWordAtCursor := UpperCase(WordAtCursor);
          if vWordAtCursor = 'BEGIN' then
          begin
            vPos := WordEnd;
            if GetMatchingOperator(vPos, True) then
              GotoPoint(vPos);
            Command := ecNone;
          end
          else
          if vWordAtCursor = 'CASE' then
          begin
            GetTokenAt(CaretXY, vTokenKind);
            if vTokenKind = Ord(tkKey) then
            begin
              vPos := WordEnd;
              if GetMatchingOperator(vPos, True) then
                GotoPoint(vPos);
              Command := ecNone;
            end;
          end
          else
          if vWordAtCursor = 'END' then
          begin
            vPos := WordStart;
            if GetMatchingOperator(vPos, False) then
              GotoPoint(vPos);
            Command := ecNone;
          end;
        end;
    end;
  end;
end;

procedure TpSHSynEdit.FindReplaceTextFirst(DoReplace: Boolean);
var
  DialogForm: TpSHFindTextForm;
  vDialogResult: Integer;
begin
  //Создаем окно настроек поиска.
  if DoReplace then
    DialogForm := TpSHReplaceTextForm.Create(Application)
  else
    DialogForm := TpSHFindTextForm.Create(Application);
  try
    DialogForm.FindReplaceHistory := UserInputHistory;
    //Если выделено - то ставим искать по выделенному
    if SelAvail then
    begin
      Include(FFindTextOptions, ftoFindInSelectedText);
      Include(FFindTextOptions, ftoEntireScopOrigin);
      DialogForm.FindText := SelText;
    end
    else
    begin
      Exclude(FFindTextOptions, ftoFindInSelectedText);
      Exclude(FFindTextOptions, ftoEntireScopOrigin);
//      DialogForm.FindText := GetWordAtRowCol(CaretXY);
      DialogForm.FindText := WordAtCursor;
    end;
    //Ловим слово для поиска
{
    if SelAvail and (BlockBegin.Line = BlockEnd.Line)
    then
      FindText := SelText
    else
      if SelAvail then
        DialogForm.FindText := GetWordAtRowCol(BlockBegin)
      else
        DialogForm.FindText := GetWordAtRowCol(CaretXY);
}
    //Передаем окну настройки поиска/замены
    DialogForm.FindTextOptions := FindTextOptions;
    if DoReplace then
      (DialogForm as TpSHReplaceTextForm).ReplaceText := ReplaceText;
    vDialogResult := DialogForm.ShowModal;
    if vDialogResult in [mrOK, mrYesToAll] then
    begin
      //Возвратка от окна
      FindTextOptions := DialogForm.FindTextOptions;
      if vDialogResult = mrYesToAll then
        Include(FFindTextOptions, ftoReplaceAll);
      FindText := DialogForm.FindText;
      if DoReplace then
        ReplaceText := (DialogForm as TpSHReplaceTextForm).ReplaceText;
      //Поехали
      if Length(FindText) > 0 then
      begin
        DoFindReplaceText(DoReplace);
        Exclude(FFindTextOptions, ftoEntireScopOrigin);
      end;
    end
  finally
    DialogForm.Free;
  end;
end;

function TpSHSynEdit.DoFindReplaceText(DoReplace: Boolean): Boolean;
var
  Options: TSynSearchOptions;
//  vCarret: TPoint;
    vHighlighter:TSynCustomHighlighter;
begin
  Options := [];
  if DoReplace then
  begin
    Options := [ssoReplace];
    if ftoReplaceAll in FindTextOptions then
      Include(Options, ssoReplaceAll);
    if ftoPromptOnReplace in FindTextOptions then
      Include(Options, ssoPrompt);
  end
  else
    Options := [];
  if ftoBackwardDirection in FindTextOptions then
    Include(Options, ssoBackwards);
  if ftoCaseSencitive in FindTextOptions then
    Include(Options, ssoMatchCase);
  if ftoEntireScopOrigin in FindTextOptions then
    Include(Options, ssoEntireScope);
  if ftoFindInSelectedText in FindTextOptions then
    Include(Options, ssoSelectedOnly);
  if ftoWholeWordsOnly in FindTextOptions then
    Include(Options, ssoWholeWord);

  SearchEngine := CreateSearchEngine(SearchEngine,
//    ftoPromptOnReplace in FindTextOptions);
    ftoRegularExpressions in FindTextOptions);
  vHighlighter:=Highlighter;
  if ([ssoReplace, ssoReplaceAll]*Options<>[]) and not (ssoPrompt in Options) then
   Highlighter:=nil;
  try
    if SearchReplace(FindText, ReplaceText, Options) = 0 then
    begin

      Result := False;
  //    if ssoBackwards in Options then
  //      BTSynEdit1.BlockEnd := BTSynEdit1.BlockBegin
  //    else
  //      BTSynEdit1.BlockBegin := BTSynEdit1.BlockEnd;
  //    BTSynEdit1.CaretXY := vCarret;
      if (not DoReplace) and (not IsSearchIncremental) then
        MessageDlg(Format(SNoMoreStringFound, [FindText]), mtInformation, [mbOK], 0);
    end
    else
      Result := True;
    if Assigned(pSHConfirmReplaceForm) then
      pSHConfirmReplaceForm.Free;
   finally
     Highlighter:=vHighlighter;
   end;   
end;

procedure TpSHSynEdit.DoOnPaintTransientEx(TransientType: TTransientType; Lock: Boolean);
type
  TptOperatorType = (otBegin, otCase, otEnd);
const AllBrackets = ['(',')'];
    OpenChar: Char = '(';
    CloseChar: Char = ')';
var P: TBufferCoord;
    Pix: TPoint;
    D     : TDisplayCoord;
    S: string;
//    vS: string;
    Attri: TSynHighlighterAttributes;
    TmpCharA, TmpCharB: Char;
    vOperatorType: TptOperatorType;
    vStyles: TFontStyles;
  function CharToPixels(P: TBufferCoord): TPoint;
  begin
    Result:=RowColumnToPixels(BufferToDisplayPos(P));
  end;
  
  function InterGetWordAt(APoint: TBufferCoord): string;
  var
    I: Integer;
    IdentChars:TSynIdentChars;
  begin
    I := APoint.Char;
    Result := EmptyStr;
    IdentChars:=Highlighter.IdentChars;
    while I <= Length(Lines[APoint.Line - 1]) do
    begin
      if Lines[P.Line - 1][I] in IdentChars then
      begin
        Result := Result + Lines[P.Line - 1][I];
        Inc(I);
      end
      else
        Break;  
    end;
  end;
  procedure SetFontAttr(IsCurrent: Boolean);
  begin
    Canvas.Brush.Style := bsSolid;//Clear;
    Canvas.Font.Assign(Font);
    Canvas.Font.Style := Attri.Style;
    Canvas.Font.Color := Attri.Foreground;
    if IsCurrent then
      Canvas.Brush.Color := ActiveLineColor
    else
      Canvas.Brush.Color := Attri.Background;
    vStyles := Canvas.Font.Style;
    if (TransientType = ttAfter) then
    begin
      Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];

    end;

    if Canvas.Font.Color = clNone then
      Canvas.Font.Color := Font.Color;
    if Canvas.Brush.Color = clNone then
      Canvas.Brush.Color := Color;
  end;
begin
  inherited DoOnPaintTransientEx(TransientType, Lock);
  if SelAvail or (not Assigned(Highlighter)) then exit;
  Canvas.Font.Assign(Font);
  Canvas.Brush.Color := Color;
  HideCaret;
  try
    P := CaretXY;
    D := DisplayXY;


// Уфф бред. Text - очень тормозная проперть. Выделяет строку размером с весь текст
{    Start := SelStart;
    if (Start > 0) and (Start <= Length(Text)) then
      TmpCharA := Text[Start]
    else TmpCharA := #0;

    if (Start < length(Text)) then
      TmpCharB := Text[Start + 1]
    else TmpCharB := #0;
    S := TmpCharB;
}
/// Замена вышеприведенного бреда
    if Length(LineText)>0 then
    begin
      if P.Char-1<=Length(LineText) then
        TmpCharA :=LineText[P.Char-1]
      else
        TmpCharA :=#13;

      if P.Char<=Length(LineText) then
        TmpCharB := LineText[P.Char]
      else
        TmpCharB :=#13;

      if not(TmpCharB in AllBrackets) then
      begin
        P.Char := P.Char - 1;
        S := TmpCharA;
      end;
     if (TmpCharA in AllBrackets) or (TmpCharB in AllBrackets) then
     begin
        GetHighlighterAttriAtRowCol(P, S, Attri);
        if (Highlighter.SymbolAttribute = Attri) then
        begin
          //раскрашиваем скобки
          if (S = OpenChar) or (S = CloseChar) then
          begin
            Pix := CharToPixels(P);

            SetFontAttr(True);

            Canvas.TextOut(Pix.X, Pix.Y, S);
            P := inherited GetMatchingBracketEx(P);

            if (P.Char > 0) and (P.Line > 0) then
            begin
              Pix := CharToPixels(P);
              if Pix.X > Gutter.Width then
              begin
                SetFontAttr(P.Line = CaretY);
                if S = OpenChar then
                  Canvas.TextOut(Pix.X, Pix.Y, CloseChar)
                else Canvas.TextOut(Pix.X, Pix.Y, OpenChar);
              end;
            end;
            Canvas.Font.Style := vStyles;
          end; //if
          Canvas.Brush.Style := bsSolid;
        end
      end
    else
 //   if (Highlighter.KeywordAttribute = Attri) then
 // ^^^ Пользоваться этим дороже чем прочитать слово.
    begin
      P := WordStart;
      S := InterGetWordAt(P);
      if Length(S)=0 then
       Exit
      else
      case S[1] of
      'B','b':
         if UpperCase(S) = 'BEGIN' then vOperatorType := otBegin else Exit;
      'C','c':
          if UpperCase(S) = 'CASE' then vOperatorType := otCase else Exit;
      'E','e':
         if UpperCase(S) = 'END' then vOperatorType := otEnd else Exit;
      else
       Exit
      end;
      GetHighlighterAttriAtRowCol(P, S, Attri);      
      if (Highlighter.KeywordAttribute <> Attri) then
       Exit;     
      Pix := CharToPixels(P);

      SetFontAttr(True);

      Canvas.TextOut(Pix.X, Pix.Y, S);
      GetMatchingOperator(P, vOperatorType <> otEnd);
      if (P.Char > 0) and (P.Line > 0) then
      begin
        Pix := CharToPixels(P);
        if Pix.X > Gutter.Width then
        begin
          SetFontAttr(P.Line = CaretY);
          S := GetWordAtRowCol(P);
          Canvas.TextOut(Pix.X, Pix.Y, S)
        end;
      end;
      Canvas.Font.Style := vStyles;
    end;
   end 
  finally
    ShowCaret;
  end;

end;

procedure TpSHSynEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  vCurrentWord: string;
  S: string;
begin


  S:=UpperCase(Lines[CaretY-1]);
  vLengthRowBeforeChange:=Length(s);
  vLeftOffsetBeforeChangeRow:=GetLeftTrimPos(s);
  vBeginEndExistBeforeChangeRow:=(Pos('BEGIN',s)>0) or
   (Pos('END',s)>0) or (Pos('CASE',s)>0) or (Pos('/*',s)>0) or (Pos('*/',s)>0)
  ;

  if (ssCtrl in Shift) and (Key = vk_Return) then
  begin
    vCurrentWord := WordAtCursor;
    if CanJump(vCurrentWord, CaretXY) and Assigned(ObjectNamesManager) then
       ObjectNamesManager.FindDeclaration(vCurrentWord);
  end
  else
    if ((ssCtrl in Shift) and (FHyperLinkRule = hlrCtrlClick)) then
      if CanJumpAtCursor then
         Cursor := crHandPoint;
  if IsSearchIncremental then
  begin
    if Key = 8 then
    begin
      S := SearchIncrementalBuffer;
      if Length(S) > 0 then
      begin
        System.Delete(S, Length(S), 1);
        SearchIncrementalBuffer := S;
      end;
      Key := Ord(#0);
    end;
  end;
  inherited;
end;

procedure TpSHSynEdit.KeyUp(var Key: Word; Shift: TShiftState);
var
  Pt: TPoint;
begin
  if (ssShift in Shift) and (Key  in  [VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN]) then
  begin
   if (ssAlt in Shift) then
   if (eoAltSetsColumnMode in Options) and (SelectionMode <> smLine) then
   if Length(SelText)<2 then
   begin
    if SelectionMode=smNormal then
     SelectionMode := smColumn
    else
     SelectionMode := smNormal;
    Exit;
   end;
  end;
  
  if ((FHyperLinkRule = hlrCtrlClick) and (Cursor = crHandPoint)) then
  begin
      GetCursorPos(Pt);
      Pt := ScreenToCLient(Pt);
      if Pt.X > Gutter.Width then Cursor := crIBeam
      else Cursor := crArrow;
  end;
  if IsSearchIncremental and (Shift = []) and
    (Key in [VK_TAB..VK_RETURN, VK_ESCAPE, VK_PRIOR..VK_HELP, VK_LWIN..VK_F24]) then
    IsSearchIncremental := False;
  inherited;  
end;

procedure TpSHSynEdit.KeyPress(var Key: Char);
begin
  if IsSearchIncremental then
  begin
    case Key of
      #8: Key := #0;
      #0, #27: ;
      else
        begin
          SearchIncrementalBuffer := SearchIncrementalBuffer + Key;
          Key := #0;
        end;
    end;
  end;
  inherited KeyPress(Key);
end;

procedure TpSHSynEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  vCurrentWord: string;
begin
  inherited;
  if Button = mbLeft then
    if ((FHyperLinkRule = hlrSingleClick) or ((FHyperLinkRule = hlrCtrlClick) and
        (ssCtrl in Shift))) then
    begin
      vCurrentWord := WordAtCursor;
      if CanJump(vCurrentWord, TBufferCoord(PixelsToRowColumn(X, Y))) and
         Assigned(ObjectNamesManager) then
         ObjectNamesManager.FindDeclaration(vCurrentWord);
    end;
end;

procedure TpSHSynEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if CanJumpAtCursor then
    Cursor := crHandPoint
  else
  begin
    if X > Gutter.Width then Cursor := crIBeam
    else Cursor := crArrow;
  end;
  inherited;
end;

procedure TpSHSynEdit.DblClick;
var
  vCurrentWord: string;
begin
  if FHyperLinkRule = hlrDblClick then
  begin
    if CanJump(vCurrentWord, CaretXY) and
       Assigned(ObjectNamesManager) then
       ObjectNamesManager.FindDeclaration(vCurrentWord)
    else
      inherited;
  end
  else
    inherited;
end;

procedure TpSHSynEdit.DoOnReplace(Sender: TObject; const ASearch,
  AReplace: string; Line, Column: integer; var Action: TSynReplaceAction);
var
  APos: TDisplayCoord;
  EditRect: TRect;
begin
//  if Action = raSkip then
//  begin
    if ASearch = AReplace then
      Action := raSkip
    else begin
      APos := TDisplayCoord(Point(Column, Line));
      APos := TDisplayCoord(ClientToScreen(RowColumnToPixels(APos)));
      EditRect := ClientRect;
      EditRect.TopLeft := ClientToScreen(EditRect.TopLeft);
      EditRect.BottomRight := ClientToScreen(EditRect.BottomRight);

      if pSHConfirmReplaceForm = nil then
        pSHConfirmReplaceForm := TpSHConfirmReplaceForm.Create(Application);
      pSHConfirmReplaceForm.PrepareShow(EditRect, APos.Column, APos.Row,
        APos.Row + LineHeight, ASearch);
      case pSHConfirmReplaceForm.ShowModal of
        mrYes: Action := raReplace;
        mrYesToAll: Action := raReplaceAll;
        mrNo: Action := raSkip;
        else Action := raCancel;
      end;
    end;
//  end;
end;

procedure TpSHSynEdit.PaintTextLines(AClip: TRect; const aFirstRow, aLastRow,
      FirstCol, LastCol: integer);
var
  vBottomEdge: Integer;
begin
  inherited PaintTextLines(AClip, aFirstRow, aLastRow, FirstCol, LastCol);
  if FBottomEdgeVisible then
    if aLastRow = Lines.Count then
    begin
      vBottomEdge := (Lines.Count - TopLine + 1) * LineHeight + 2;
      Canvas.Pen.Color := FBottomEdgeColor;
      Windows.MoveToEx(Canvas.Handle, AClip.Left, vBottomEdge, nil);
      Windows.LineTo(Canvas.Handle, AClip.Right, vBottomEdge);
    end;
end;

constructor TpSHSynEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEventsSaved := False;
  FBottomEdgeVisible := True;
  FBottomEdgeColor := RightEdgeColor;
  OnReplaceText := DoOnReplace;
  if not (csDesigning  in ComponentState) then
    with Keystrokes do
    begin
      AddKey(ecDublicateBlock, Ord('D'), [ssCtrl]);
      AddKey(ecSelectWord, Ord('W'), [ssCtrl]);
      AddKey(ecSearchIncremental, Ord('E'), [ssCtrl]);
//      AddKey(ecCtrlEnter, VK_RETURN, [ssCtrl]);
//      AddKey(ecPrepareStatement, VK_F9, [ssCtrl]);
      AddKey(ecCommentBlock, Ord('/'), [ssCtrl, ssShift]);
      AddKey(ecCommentLine, Ord('/'), [ssCtrl]);

      //Сделано так, а не через AddKeyPressHandler(); чтобы
      //все команды находились в одном месте
      AddKey(ecShowDomains, Ord('D'), [ssCtrl, ssAlt]);
      AddKey(ecShowTables, Ord('T'), [ssCtrl, ssAlt]);
      AddKey(ecShowViews, Ord('V'), [ssCtrl, ssAlt]);
      AddKey(ecShowTriggers, Ord('M'), [ssCtrl, ssAlt]);
      AddKey(ecShowProcedures, Ord('P'), [ssCtrl, ssAlt]);
      AddKey(ecShowGenerators, Ord('G'), [ssCtrl, ssAlt]);
      AddKey(ecShowExceptions, Ord('E'), [ssCtrl, ssAlt]);
      AddKey(ecShowFunctions, Ord('F'), [ssCtrl, ssAlt]);
      AddKey(ecShowRoles, Ord('R'), [ssCtrl, ssAlt]);

      AddKey(ecFind, Ord('F'), [ssCtrl]);
      AddKey(ecSearchAgain, VK_F3, []);
      AddKey(ecReplace, Ord('R'), [ssCtrl]);
      AddKey(ecGoToLineNumber, Ord('G'), [ssAlt]);
      AddKey(ecHyperJump, VK_RETURN, [ssCtrl, ssShift]);
      AddKey(ecQuaterWord, Ord('Q'), [ssCtrl, ssShift]);
    end;

  FGutterDrawer := TpSHGutterDrawer.Create(Self);
  FDrawerBlocks := TpSHDrawerBlocks.Create(Self);
end;

destructor TpSHSynEdit.Destroy;
begin
  FGutterDrawer.Free;
  FDrawerBlocks.Free;
//  if FEventsSaved then
//  begin
//    OnMouseCursor := FUserOnMouseCursor;
//    FEventsSaved := False;
//  end;
  inherited Destroy;
end;

procedure TpSHSynEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if CompletionProposal = AComponent then
      CompletionProposal := nil;
    if ParametersHint = AComponent then
      ParametersHint := nil;
    if AutoComplete = AComponent then
      AutoComplete := nil;

//    if Assigned(FExecutableCommandManager) and
//      AComponent.IsImplementorOf(FExecutableCommandManager) then
//      FExecutableCommandManager := nil;
    if Assigned(FUserInputHistory) and
      AComponent.IsImplementorOf(FUserInputHistory) then
      FUserInputHistory := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

function TpSHSynEdit.WordAtCaret:string;
begin
//WordAtCursor  глючит если стать за пределами строки или за пределами текста.
  if CaretY>=Lines.Count then
   Result:=''
  else
  if CaretX>(Length(Lines[CaretY - 1])+1) then
   Result:=''
  else
   Result:=WordAtCursor
end;

function TpSHSynEdit.GetMatchingBracketEx(
  const APoint: TBufferCoord): TBufferCoord;
var
  vInputCaret: TBufferCoord;
begin
  vInputCaret := APoint;
  Result := inherited GetMatchingBracketEx(APoint);
  if (Result.Line = 0) and (Result.Char = 0) then
    Result := vInputCaret;
end;

function TpSHSynEdit.GetTokenAt(XY: TBufferCoord; var TokenKind: Integer): string;
var
  vAtttr: TSynHighlighterAttributes;
  I: Integer;
begin
  if not GetHighlighterAttriAtRowColEx(XY, Result, TokenKind, I,vAtttr) then
    Result := '';
end;

function TpSHSynEdit.GetTokenPos(ALineNo, Ident: Integer; const AFindToken: string): Integer;
var
  PosX, PosY: integer;
  Line: string;
  Token: string;
  Start: Integer;
begin
  //идея содрана с GetHighlighterAttriAtRowColEx
  PosY := ALineNo - 1;
  if Assigned(Highlighter) and (PosY >= 0) and (PosY < Lines.Count) then
  begin
    Line := Lines[PosY];
    if PosY = 0 then
      Highlighter.ResetRange
    else
      Highlighter.SetRange(TSynEditStringList(Lines).Ranges[PosY - 1]);
    Highlighter.SetLine(Line, PosY);
    PosX := Ident;
    if (PosX > 0) and (PosX <= Length(Line)) then
      while not Highlighter.GetEol do
      begin
        Start := Highlighter.GetTokenPos + 1;
        Token := Highlighter.GetToken;
        if (PosX < Start + Length(Token)) and
          IsIdentifiresEqual(Token, AFindToken) then
        begin
          Result := Start;
          exit;
        end;
        Highlighter.Next;
      end;
  end;
  Result := 0;
end;

function TpSHSynEdit.CanJump(var Token: string; Caret: TBufferCoord): Boolean;
var
  vTokenKind: Integer;
begin
  Token := GetTokenAt(Caret, vTokenKind);
  Result := TtkTokenKind(vTokenKind) = tkTableName;
end;

function TpSHSynEdit.CanJumpAtCursor: Boolean;
var
  Pt: TPoint;
  vDisplayCoord: TDisplayCoord;
begin
  GetCursorPos(Pt);
  Pt := ScreenToCLient(Pt);
  vDisplayCoord := PixelsToRowColumn(Pt.X, Pt.Y);
  Result := CanJumpAt(vDisplayCoord);
end;

function TpSHSynEdit.CanJumpAt(AAt: TDisplayCoord): Boolean;
var
  vCurrentWord: string;
begin
  Result := CanJump(vCurrentWord, TBufferCoord(AAt));
end;

function TpSHSynEdit.IsIdentifiresEqual(const AIdentifire1,
  AIdentifire2: string): Boolean;
begin
  if Assigned(ObjectNamesManager) then
    Result := ObjectNamesManager.IsIdentifiresEqual(Self, AIdentifire1, AIdentifire2)
  else
    Result := AnsiSameText(AIdentifire1, AIdentifire2);
end;

function TpSHSynEdit.IsEmpty: Boolean;
var
  I: Integer;
begin
  Result := Lines.Count = 0;
  if not Result then
  begin
    for I := 0 to Lines.Count - 1 do
      if Length(Lines[I]) > 0 then
        Exit;
    Result := True;    
  end;
end;

procedure TpSHSynEdit.CommentSelected;
begin
  SelText := '/*' + SelText + '*/';
end;

procedure TpSHSynEdit.UnCommentSelected;
var
  S: string;
  I: Integer;
  L: Integer;
begin
  S := SelText;
  I := 1;
  L := Length(S) - 1;
  if L > 1 then
  begin
    while (I < L) and (S[I] in [' ', #9, #13, #10]) do Inc(I);
    if (S[I] = '/') and (S[I + 1] = '*') then
      System.Delete(S, I, 2);
  end;
  L := Length(S);
  I := L;
  if L > 1 then
  begin
    while (I > 2) and (S[I] in [' ', #9, #13, #10]) do Dec(I);
    if (S[I] = '/') and (S[I - 1] = '*') then
      System.Delete(S, I - 1, 2);
  end;
  SelText := S;
end;


procedure TpSHSynEdit.CommentUncomment;
var
  S: string;
  L: Integer;
begin
  if SelAvail then
  begin
    S := Trim(SelText);
    L := Length(S);
    if L >= 4 then
    begin
      if (Pos('/*', S) = 1) and
         (S[L] = '/') and
         (S[L-1] = '*') then
        UnCommentSelected
      else
        CommentSelected;
    end;
  end;
end;

procedure TpSHSynEdit.CommentUncommentLine;
var
  S: string;
  PriorCaret: TBufferCoord;
begin
  S := Lines[CaretY-1];
  if Length(S) > 0 then
  begin
    PriorCaret := CaretXY;
    BeginUpdate;
    CaretX := 1;
    BlockBegin := TBufferCoord(Point(1, CaretY));
    if Pos('--', S) = 1 then
    begin
      BlockEnd := TBufferCoord(Point(3, CaretY));
      SelText := '';
    end
    else
    begin
      BlockEnd := TBufferCoord(Point(1, CaretY));
      SelText := '--';
    end;
    EndUpdate;
    CaretXY := PriorCaret;
  end;
  CaretY := CaretY + 1;
end;

function TpSHSynEdit.GetMatchingOperator(var APoint: TBufferCoord;
  ASearchEnd: Boolean): Boolean;
var
  vCurrent: TBufferCoord;
  S: string;
  NumOperators: Integer;
  vTokens: TStringList;
  vPositions: TList;
  I: Integer;
  function InRange: Boolean;
  begin
    if vCurrent.Line = APoint.Line then
    begin
      if ASearchEnd then
        Result := Highlighter.GetTokenPos > (vCurrent.Char - 1)
      else
        Result := Highlighter.GetTokenPos < (vCurrent.Char - 1);
    end
    else
      Result := True;
  end;
  function IsKeyword: Boolean;
  begin
    Result := Highlighter.GetTokenAttribute = Highlighter.KeywordAttribute; 
//    Result := Highlighter.GetTokenAttribute = Highlighter.IdentifierAttribute;
  end;
begin
  Result := False;
  if Assigned(Highlighter) then
  begin
    vCurrent := APoint;
    NumOperators := 1;
    if ASearchEnd then
    begin
      repeat
        if Result then
          Break;
        Highlighter.SetLine(Lines[vCurrent.Line - 1], vCurrent.Line - 1);
        while not Highlighter.GetEol do
        begin
          if InRange and IsKeyword then
          begin
            S := UpperCase(Highlighter.GetToken);
            if (Length(S)>0) then
            case S[1] of
            'B': if S= 'BEGIN' then
                  Inc(NumOperators);
            'C':if S= 'CASE' then
                  Inc(NumOperators);
            'E':if S= 'END' then
                  Dec(NumOperators);
            end;

            if NumOperators = 0 then
            begin
              Result := True;
              vCurrent.Char := Highlighter.GetTokenPos;
              APoint.Char := vCurrent.Char + 1;
              APoint.Line := vCurrent.Line;
              Break;
            end;
          end;
          Highlighter.Next;
        end;
        Inc(vCurrent.Line);
      until vCurrent.Line > Lines.Count;
    end
    else
    begin
      vTokens := TStringList.Create;
      vPositions := TList.Create;
      try
        repeat
          if Result then
            Break;
          vTokens.Clear;
          vPositions.Clear;
          Highlighter.SetLine(Lines[vCurrent.Line - 1], vCurrent.Line - 1);
          while not Highlighter.GetEol do
          begin
            if InRange and IsKeyword then
            begin
              vTokens.Add(Highlighter.GetToken);
              vPositions.Add(pointer(Highlighter.GetTokenPos));
            end;
            Highlighter.Next;
          end;
          for I := vTokens.Count - 1 downto 0 do
          begin
            S := UpperCase(vTokens[I]);
            if (Length(S)>0) then
            case S[1] of
            'B': if S= 'BEGIN' then
                  Dec(NumOperators);
            'C': if S= 'CASE' then
                  Dec(NumOperators);
            'E': if S= 'END' then
                  Inc(NumOperators);
            end;
            if NumOperators = 0 then
            begin
              vCurrent.Char := Integer(vPositions[I]);
              Result := True;
              APoint.Char := vCurrent.Char + 1;
              APoint.Line := vCurrent.Line;
              Break;
            end;
          end;
          Dec(vCurrent.Line);
        until vCurrent.Line  = 0;
      finally
        vTokens.Free;
        vPositions.Free;
      end;
    end;
  end;
end;

procedure TpSHSynEdit.Find;
begin
  FindReplaceTextFirst(False);
end;

procedure TpSHSynEdit.Replace;
begin
  FindReplaceTextFirst(True);
end;

procedure TpSHSynEdit.SearchAgain;
begin
  Exclude(FFindTextOptions, ftoFindInSelectedText);
  DoFindReplaceText(False);
end;

procedure TpSHSynEdit.SearchIncremental;
begin
  IsSearchIncremental := True;
end;

procedure TpSHSynEdit.GoToLineNumber;
var
  DialogForm: TpSHGotoLineNumberForm;
begin
  DialogForm := TpSHGotoLineNumberForm.Create(Self);
  try
    DialogForm.MaxLineNumber := Lines.Count;
    DialogForm.GotoLineNumberHistory := UserInputHistory;
    if IsPositiveResult(DialogForm.ShowModal) then
    begin
      CaretY := DialogForm.GotoLineNumberValue;
      EnsureCursorPosVisibleEx(True);
    end;
  finally
    DialogForm.Free;
  end;
end;

procedure TpSHSynEdit.LinesChanged(Sender: TObject);
var
  s:string;
begin
 inherited;
 if FShowBeginEndRegions then
 begin
   s:=UpperCase(Lines[CaretY-1]);
//   if (vLinesCount<>Lines.Count)or   vBeginEndExistBeforeChangeRow
//  if Lines.Count=vLinesCount then
   if vBeginEndExistBeforeChangeRow or (Lines.Count>vLinesCount+1) or
    (vLinesCount-Lines.Count>1)
    or(Pos('BEGIN',s)>0) or (Pos('END',s)>0) or (Pos('CASE',s)>0)
    or (Pos('/*',s)>0) or (Pos('*/',s)>0)
   then
   begin
    FDrawerBlocksPrepared:=False;
    Invalidate;
   end
   else
   if (vLeftOffsetBeforeChangeRow<>GetLeftTrimPos(s)) or
    ((vLengthRowBeforeChange=0) and (Length(s)<>0))
   then
   begin
    FDrawerNeedEasyReprepare:=True;
    
//    Invalidate;    
   end;
   vLinesCount:=Lines.Count
 end;
end;

procedure TpSHSynEdit.SetShowBeginEndRegions(const Value: boolean);
begin
  FShowBeginEndRegions := Value;
  Invalidate
end;

procedure TpSHSynEdit.Resize;
begin
  FDrawerBlocksPrepared:=False;
  inherited;
end;

procedure TpSHSynEdit.ExecuteCommand(Command: TSynEditorCommand;
  AChar: char; Data: pointer);
var
    vHighlighter:TSynCustomHighlighter;
    OldShowBlocks:boolean;
begin
  case Command of
  ecPaste,ecCut,ecUndo,ecRedo:
    begin
       vHighlighter:=Highlighter;
       Highlighter:=nil;
       OldShowBlocks:=FShowBeginEndRegions;
       try
        inherited
       finally
        FShowBeginEndRegions:=OldShowBlocks;
        Highlighter:=vHighlighter;
       end;
   end
  else
   inherited;
  end 
end;

{ TpSHGutterDrawer }

procedure TpSHGutterDrawer.AfterPaint(ACanvas: TCanvas; const AClip: TRect;
  FirstLine, LastLine: Integer);
var
  LH, X, Y: integer;
  ImgIndex: integer;
begin
  X := 8;

  if Enabled and Assigned(ImageList) and Editor.Gutter.Visible and (Editor.Gutter.Width >= 25) then
  begin
    LH := Editor.LineHeight;
    Y := (LH - ImageList.Height) div 2 + LH * (FirstLine - Editor.TopLine);

    while FirstLine <= LastLine do
    begin
      ImgIndex := -1;
      if Assigned((Editor as TpSHSynEdit).OnGutterDraw) then
        (Editor as TpSHSynEdit).OnGutterDraw(Editor, FirstLine - 1, ImgIndex);

      if ImgIndex >= 0 then ImageList.Draw(ACanvas, X, Y, ImgIndex);

      Inc(FirstLine);
      Inc(Y, LH);
    end;
  end;
end;

procedure TpSHGutterDrawer.LinesInserted(FirstLine, Count: integer);
begin
end;

procedure TpSHGutterDrawer.LinesDeleted(FirstLine, Count: integer);
begin
end;

{ TpSHDrawerBlocks }

function ExistBeginEnd(TS:TStrings;FirstLine,Count:integer):boolean;
var
 s:string;
 i:integer;
begin
 Result:=False;
 i:=FirstLine;
 while not Result and (i<FirstLine+Count) do
 begin
  s:=UpperCase(TS[i]);
  Inc(i);
  Result:= (Pos('BEGIN',s)>0) or
     (Pos('END',s)>0) or (Pos('CASE',s)>0) or (Pos('/*',s)>0) or (Pos('*/',s)>0)
 end;
end;

procedure TpSHDrawerBlocks.EasyPrepareDeletedAddedLine(FirstLine,Count:integer;Deleted:boolean=True);
var
   I:integer;
begin
  if Editor.WordWrap {or ExistBeginEnd(Editor.Lines,FirstLine,Count) }then
   Prepare
  else
  begin
   I:=0;
   if not Deleted then
    Dec(FirstLine,Count);
    
   while I<Length(FScenario) do
   begin
     if
      (FScenario[FScenario[I].EndBlockPoint].PointCoord.Row>FirstLine)
     then
     begin
      if Deleted then
      begin
       if FScenario[I].PointCoord.Row>FirstLine then
        Dec(FScenario[I].PointCoord.Row,Count);
       Dec(FScenario[FScenario[I].EndBlockPoint].PointCoord.Row,Count);
      end
      else
      begin
       if FScenario[I].PointCoord.Row>FirstLine then
        Inc(FScenario[I].PointCoord.Row,Count);
       Inc(FScenario[FScenario[I].EndBlockPoint].PointCoord.Row,Count);
      end;

      if
       PrepareBlock(FScenario[I].PointCoord,FScenario[FScenario[I].EndBlockPoint].PointCoord,
         I,FScenario[I].Color
       )
      then
       Editor.InvalidateLines(FScenario[I].PointCoord.Row,
        FScenario[FScenario[I].EndBlockPoint].PointCoord.Row
       )
     end;
     I:=FScenario[I].EndBlockPoint+1;     
   end
  end;
end;

procedure TpSHDrawerBlocks.EasyRePrepare;
var
   I:integer;
begin
  if not Editor.WordWrap then
  begin
 // Попали сюда по причине того что сменился оффсет у текущей строки

  SetLength(FLinesLengths,Editor.Lines.Count);
  for I:=0 to Pred(Editor.Lines.Count) do
  begin
   FLinesLengths[I].LengthStr:=Length(Editor.Lines[I]);
   FLinesLengths[I].LeftOffSet:=GetLeftTrimPos(Editor.Lines[I])
  end;

   I:=0;
   while I<Length(FScenario) do
   begin
     if (FScenario[I].PointCoord.Row<=Editor.CaretY) and
      (FScenario[FScenario[I].EndBlockPoint].PointCoord.Row>=Editor.CaretY)
     then
     begin
      if
       PrepareBlock(FScenario[I].PointCoord,FScenario[FScenario[I].EndBlockPoint].PointCoord,
         I,FScenario[I].Color
       )
      then 
       Editor.InvalidateLines(FScenario[I].PointCoord.Row,
        FScenario[FScenario[I].EndBlockPoint].PointCoord.Row
       )

     end;
     I:=FScenario[I].EndBlockPoint+1;
   end
 //  Prepare;
  end;
{  if not Editor.WordWrap then
     Prepare;}
 TpSHSynEdit(Editor).FDrawerNeedEasyReprepare:=False
end;

function TpSHDrawerBlocks.CharIndexToRowCol(Index: integer): TBufferCoord;
{ Index is 0-based; Result.x and Result.y are 1-based }
var
  x, y, Chars: integer;
begin
  x := 0;
  y := 0;
  Chars := 0;
  while y < Length(FLinesLengths) do
  begin
    x := FLinesLengths[y].LengthStr;
    if Chars + x + 2 > Index then
    begin
      x := Index - Chars;
      break;
    end;
    Inc(Chars, x + 2);
    x := 0;
    Inc(y);
  end;
  Result.Char := x + 1;
  Result.Line := y + 1;
end;

function  TpSHDrawerBlocks.PrepareBlock(TempCoord1,TempCoord2:TDisplayCoord;BegBlockIndex:integer;
CurColor:TColor
):boolean;
var
 TempCoord3:TDisplayCoord;
   J:integer;
   CurLeft:integer;
   LeftOffset:integer;
   LastLeftOffset:integer;
   CurRow:integer;
begin
 Result:=False;
 with Editor do
 begin
    if TempCoord1.Row<> TempCoord2.Row then
    begin
     Result:=Result or (FScenario[BegBlockIndex].PointCoord.Column <>TempCoord1.Column);
     FScenario[BegBlockIndex].PointCoord:=TempCoord1;
     FScenario[BegBlockIndex].Action    :=paMoveTo;
     FScenario[BegBlockIndex].Color     :=CurColor;
     FScenario[BegBlockIndex].XOffset   :=0;
     FScenario[BegBlockIndex].YOffset   :=0;
     FScenario[BegBlockIndex].EndBlockPoint:=BegBlockIndex+12;
     FScenario[BegBlockIndex].IsFirstPoint :=True;

     FScenario[BegBlockIndex+1].PointCoord:=TempCoord1;
     FScenario[BegBlockIndex+1].Action    :=paLineTo;
     FScenario[BegBlockIndex+1].Color     :=CurColor;
     FScenario[BegBlockIndex+1].XOffSet   :=-CharWidth-3;
     FScenario[BegBlockIndex+1].YOffset   :=0;
     FScenario[BegBlockIndex+1].EndBlockPoint:=BegBlockIndex+12;
     FScenario[BegBlockIndex+1].IsFirstPoint :=False;

     FScenario[BegBlockIndex+2].PointCoord:=TempCoord1;
     FScenario[BegBlockIndex+2].Action    :=paLineTo;
     FScenario[BegBlockIndex+2].Color     :=CurColor;
     FScenario[BegBlockIndex+2].XOffSet   :=-CharWidth-3;
     FScenario[BegBlockIndex+2].YOffset     :=LineHeight;
     FScenario[BegBlockIndex+2].EndBlockPoint:=BegBlockIndex+12;
     FScenario[BegBlockIndex+2].IsFirstPoint :=False;

     FScenario[BegBlockIndex+3].PointCoord:=TempCoord1;
     FScenario[BegBlockIndex+3].Action    :=paLineTo;
     FScenario[BegBlockIndex+3].Color     :=CurColor;
     FScenario[BegBlockIndex+3].XOffSet   :=0;
     FScenario[BegBlockIndex+3].YOffset     :=LineHeight;
     FScenario[BegBlockIndex+3].EndBlockPoint:=BegBlockIndex+12;
     FScenario[BegBlockIndex+3].IsFirstPoint :=False;

     FScenario[BegBlockIndex+4].PointCoord:=TempCoord1;
     FScenario[BegBlockIndex+4].Action    :=paMoveTo;
     FScenario[BegBlockIndex+4].Color     :=CurColor;
     FScenario[BegBlockIndex+4].XOffSet   :=-CharWidth-3;
     FScenario[BegBlockIndex+4].YOffset   :=LineHeight;
     FScenario[BegBlockIndex+4].EndBlockPoint:=BegBlockIndex+12;
     FScenario[BegBlockIndex+4].IsFirstPoint :=False;
     
    // Пытаемся вычислить самую левую строку
//     LeftOffset:=MaxInt;

   if Editor.WordWrap then
   begin
    if TempCoord2.Column>TempCoord1.Column then
     TempCoord3.Column:=TempCoord1.Column
    else
      TempCoord3.Column:=TempCoord2.Column;
    LastLeftOffset:=TempCoord3.Column-2;
   end
   else
   begin
     CurRow:=TempCoord1.Row;
     LeftOffset:=TempCoord1.Column;
     for J:=TempCoord1.Row+1 to TempCoord2.Row do
     if Length(Trim(Lines[J-1]))>0 then
     begin
      if Length(FLinesLengths)=0 then
       CurLeft:=GetLeftTrimPos(Lines[J-1])
      else
       CurLeft:=FLinesLengths[J-1].LeftOffSet;
      if CurLeft<LeftOffset then
      begin
       LeftOffset:=CurLeft;
       CurRow:=J;
      end
     end;
     LastLeftOffset:=GetLeftTrimPos(Lines[TempCoord2.Row-1]);
     TempCoord3:=BufferToDisplayPos(BufferCoord(LeftOffset+2,CurRow));
   end;
     Result:=Result or (FScenario[BegBlockIndex+5].PointCoord.Column <>TempCoord3.Column);
     FScenario[BegBlockIndex+5].PointCoord:= DisplayCoord(TempCoord3.Column,TempCoord1.Row);
     FScenario[BegBlockIndex+5].Action    :=paLineTo;
     FScenario[BegBlockIndex+5].Color     :=CurColor;
     FScenario[BegBlockIndex+5].XOffSet   :=-CharWidth-3;
     FScenario[BegBlockIndex+5].YOffset   :=LineHeight;
     FScenario[BegBlockIndex+5].EndBlockPoint:=BegBlockIndex+12;
     FScenario[BegBlockIndex+5].IsFirstPoint :=False;

     FScenario[BegBlockIndex+6].PointCoord:= DisplayCoord(TempCoord3.Column,TempCoord2.Row);
     FScenario[BegBlockIndex+6].Action    :=paLineTo;
     FScenario[BegBlockIndex+6].Color     :=CurColor;
     FScenario[BegBlockIndex+6].XOffSet   :=-CharWidth-3;
     FScenario[BegBlockIndex+6].YOffset   :=0;
     FScenario[BegBlockIndex+6].EndBlockPoint:=BegBlockIndex+12;
     FScenario[BegBlockIndex+6].IsFirstPoint :=False;

     FScenario[BegBlockIndex+7].PointCoord:= DisplayCoord(LastLeftOffSet+2,TempCoord2.Row);
     FScenario[BegBlockIndex+7].Action    :=paLineTo;
     FScenario[BegBlockIndex+7].Color     :=CurColor;
     FScenario[BegBlockIndex+7].XOffSet   :=-CharWidth-3;
     FScenario[BegBlockIndex+7].YOffset   :=0;
     FScenario[BegBlockIndex+7].EndBlockPoint:=BegBlockIndex+12;
     FScenario[BegBlockIndex+7].IsFirstPoint :=False;

     FScenario[BegBlockIndex+8].PointCoord:= DisplayCoord(LastLeftOffSet+2,TempCoord2.Row);
     FScenario[BegBlockIndex+8].Action    :=paLineTo;
     FScenario[BegBlockIndex+8].Color     :=CurColor;
     FScenario[BegBlockIndex+8].XOffSet   :=-CharWidth-3;
     FScenario[BegBlockIndex+8].YOffset   :=LineHeight;
     FScenario[BegBlockIndex+8].EndBlockPoint:=BegBlockIndex+12;
     FScenario[BegBlockIndex+8].IsFirstPoint :=False;


     FScenario[BegBlockIndex+9].PointCoord:= TempCoord2;
     FScenario[BegBlockIndex+9].Action    :=paLineTo;
     FScenario[BegBlockIndex+9].Color     :=CurColor;
     FScenario[BegBlockIndex+9].XOffSet   :=0;
     FScenario[BegBlockIndex+9].YOffset   :=LineHeight;
     FScenario[BegBlockIndex+9].EndBlockPoint:=BegBlockIndex+12;
     FScenario[BegBlockIndex+9].IsFirstPoint :=False;

     FScenario[BegBlockIndex+10].PointCoord:= TempCoord2;
     FScenario[BegBlockIndex+10].Action    :=paMoveTo;
     FScenario[BegBlockIndex+10].Color     :=CurColor;
     FScenario[BegBlockIndex+10].XOffSet   :=-CharWidth-3;
     FScenario[BegBlockIndex+10].YOffset   :=LineHeight;
     FScenario[BegBlockIndex+10].EndBlockPoint:=BegBlockIndex+12;
     FScenario[BegBlockIndex+10].IsFirstPoint :=False;

     FScenario[BegBlockIndex+11].PointCoord:= TempCoord2;
     FScenario[BegBlockIndex+11].Action    :=paLineTo;
     FScenario[BegBlockIndex+11].Color     :=CurColor;
     FScenario[BegBlockIndex+11].XOffSet   :=-CharWidth-3;
     FScenario[BegBlockIndex+11].YOffset   :=0;
     FScenario[BegBlockIndex+11].EndBlockPoint:=BegBlockIndex+12;
     FScenario[BegBlockIndex+11].IsFirstPoint :=False;

     Result:=Result or (FScenario[BegBlockIndex+12].PointCoord.Column <>TempCoord2.Column);
     FScenario[BegBlockIndex+12].PointCoord:= TempCoord2;
     FScenario[BegBlockIndex+12].Action    :=paLineTo;
      FScenario[BegBlockIndex+12].Color     :=CurColor;
     FScenario[BegBlockIndex+12].XOffSet   :=0;
     FScenario[BegBlockIndex+12].YOffset   :=0;
     FScenario[BegBlockIndex+12].EndBlockPoint:=BegBlockIndex+12;
     FScenario[BegBlockIndex+12].IsFirstPoint :=False;
    end
    else
    begin
     Result:=Result or (FScenario[BegBlockIndex].PointCoord.Column <>TempCoord1.Column);    
     FScenario[BegBlockIndex].PointCoord:= TempCoord1;
     FScenario[BegBlockIndex].Action    :=paMoveTo;
     FScenario[BegBlockIndex].Color     :=CurColor;
     FScenario[BegBlockIndex].XOffSet   :=-CharWidth-3;
     FScenario[BegBlockIndex].YOffset   :=(LineHeight div 2);
     FScenario[BegBlockIndex].EndBlockPoint:=BegBlockIndex+3;
     FScenario[BegBlockIndex].IsFirstPoint :=True;

     FScenario[BegBlockIndex+1].PointCoord:= TempCoord1;
     FScenario[BegBlockIndex+1].Action    :=paLineTo;
     FScenario[BegBlockIndex+1].Color     :=CurColor;
     FScenario[BegBlockIndex+1].XOffSet   :=-CharWidth-3;
     FScenario[BegBlockIndex+1].YOffset   :=LineHeight ;
     FScenario[BegBlockIndex+1].IsFirstPoint :=False;

     FScenario[BegBlockIndex+2].PointCoord:=DisplayCoord(TempCoord2.Column,TempCoord1.Row);
     FScenario[BegBlockIndex+2].Action    :=paLineTo;
     FScenario[BegBlockIndex+2].Color     :=CurColor;
     FScenario[BegBlockIndex+2].XOffSet   :=CharWidth*2;
     FScenario[BegBlockIndex+2].YOffset   :=LineHeight ;
     FScenario[BegBlockIndex+2].IsFirstPoint :=False;

     Result:=Result or (FScenario[BegBlockIndex+3].PointCoord.Column <>TempCoord2.Column);
     FScenario[BegBlockIndex+3].PointCoord:=DisplayCoord(TempCoord2.Column,TempCoord1.Row);
     FScenario[BegBlockIndex+3].Action    :=paLineTo;
     FScenario[BegBlockIndex+3].Color     :=CurColor;
     FScenario[BegBlockIndex+3].XOffSet   :=CharWidth*2;
     FScenario[BegBlockIndex+3].YOffset   :=LineHeight div 2  ;
     FScenario[BegBlockIndex+3].IsFirstPoint :=False;
    end
   end;
end;

procedure TpSHDrawerBlocks.Prepare;
var
   Blocks:TBlocksPositions;
   Parser:TSQLParser;
   I,L,L1:integer;
   TempCoord1,TempCoord2:TDisplayCoord;
   CurColor:TColor;
   BegBlockIndex:integer;
begin
  FWordWrapped:=Editor.WordWrap;
   Parser:=TSQLParser.Create(Editor.Lines.Text);
   try
    I:=1;
    Blocks:=Parser.GetBlocksPositions(I,I)  ;
   finally
    Parser.Free;
   end;

  SetLength(FLinesLengths,Editor.Lines.Count);
  for I:=0 to Pred(Editor.Lines.Count) do
  begin
   FLinesLengths[I].LengthStr:=Length(Editor.Lines[I]);
   FLinesLengths[I].LeftOffSet:=GetLeftTrimPos(Editor.Lines[I])
  end;
   

  L1:=Length(Blocks);
  SetLength(FScenario,L1*13);
  L:=0;
  for I:=0 to Pred(L1) do
   if (Blocks[i].X<>0) and (Blocks[i].Y<>0) then
   with Editor do
   begin
    case Blocks[i].Level mod 6 of
     0: CurColor:=clNavy;
     1: CurColor:=clRed;
     2: CurColor:=clGreen;
     3: CurColor:=clBlue;
     4: CurColor:=clMaroon;
     5: CurColor:=clLime;
    else
      CurColor:=clBlack
    end;


// Родимый CharIndexToRowCol тормозит до жутиков.
{


   TempCoord1:=BufferToDisplayPos(Self.CharIndexToRowCol(Blocks[i].X));
    TempCoord2:=BufferToDisplayPos(Self.CharIndexToRowCol(Blocks[i].Y));
}

    TempCoord1:=BufferToDisplayPos(TBufferCoord(Blocks[i].X1));
    TempCoord2:=BufferToDisplayPos(TBufferCoord(Blocks[i].Y1));

    BegBlockIndex:=L;
    if TempCoord1.Row<> TempCoord2.Row then
      Inc(L,13)
    else
      Inc(L,4);
     PrepareBlock(TempCoord1,TempCoord2,BegBlockIndex,CurColor);
   end;

   SetLength(FScenario,L);
   SetLength(FLinesLengths,0);
   if (Editor is TpSHSynEdit) then
   begin
     TpSHSynEdit(Editor).FDrawerBlocksPrepared:=True;
     TpSHSynEdit(Editor).FDrawerNeedEasyReprepare:=False;
   end
end;

procedure TpSHDrawerBlocks.PaintBlock(BegBlockIndex:integer);
var
 Finish:TPoint;
 curEndBlock:integer;
 I:integer;
 ACanvas: TCanvas;
begin
 I:=BegBlockIndex;
 CurEndBlock:=FScenario[I].EndBlockPoint;
 ACanvas:=Editor.Canvas;
 while I<= CurEndBlock do
 begin
   if FScenario[I].IsFirstPoint and
    ((FScenario[I].PointCoord.Row>Editor.TopLine+Editor.LinesInWindow) or
    (FScenario[CurEndBlock].PointCoord.Row<Editor.TopLine-1))
   then
   begin
    i:=CurEndBlock+1; // первый в блоке
   end
   else
   begin
      Finish:=Editor.RowColumnToPixels(FScenario[I].PointCoord);
      Finish.X:=Finish.X+FScenario[I].XOffset;
      Finish.Y:=Finish.Y+FScenario[I].YOffset;
      if FScenario[I].IsFirstPoint then
        ACanvas.Pen.Color:=FScenario[I].Color;
      if FScenario[I].Action=paMoveTo then
         ACanvas.MoveTo(Finish.X, Finish.Y)
      else
         ACanvas.LineTo(Finish.X, Finish.Y);
    Inc(I)
   end;
 end;

end;

procedure TpSHDrawerBlocks.AfterPaint(ACanvas: TCanvas; const AClip: TRect;
  FirstLine, LastLine: integer);
var
 I:integer;
begin
 if not (Editor is TpSHSynEdit) or
  not TpSHSynEdit(Editor).FShowBeginEndRegions then
   Exit;


 if not TpSHSynEdit(Editor).FDrawerBlocksPrepared
  or    (FWordWrapped xor Editor.WordWrap)
 then
   Prepare
 else
 if TpSHSynEdit(Editor).FDrawerNeedEasyReprepare then
   EasyRePrepare;
 i:=0;
 while I< Length(FScenario) do
 begin
   PaintBlock(I);
   I:=FScenario[I].EndBlockPoint+1
 end;
end;


procedure TpSHDrawerBlocks.LinesDeleted(FirstLine, Count: integer);
begin
if (Count=1) then
 EasyPrepareDeletedAddedLine(FirstLine, Count,True);
//^^^ воспользоваться в общем случае не удается, потому что неизвестно в удаляемых строках были
// бегин энды или нет
end;

procedure TpSHDrawerBlocks.LinesInserted(FirstLine, Count: integer);
begin
 if (Count=1) then
  EasyPrepareDeletedAddedLine(FirstLine, Count,False);
end;

end.
