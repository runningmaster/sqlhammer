unit pSHCompletionProposal;

{$I SynEdit.inc}

interface

uses Classes, Controls, Messages, Windows, Graphics, Forms, StdCtrls,
     SynCompletionProposal, SynEdit, SynEditTypes,
     pSHIntf,pSHSqlTxtRtns;


type

  TpSHCompletionProposal = class(TSynCompletionProposal)
  private
    FNeedObjectType: TpSHNeedObjectType;
    FCompletionProposalWndProc: TWndMethod;
    FCompletionProposalOptions: IpSHCompletionProposalOptions;
    procedure CompletionProposalWndProc(var Message: TMessage);
    procedure WindowClose(Sender: TObject);
  protected
    function NeedHint(var ATextHeight, ATextWidth: Integer; var AHint: string; var AMousePos: TPoint): boolean;
    procedure DoAfterCodeCompletion(Sender: TObject; const Value: string;
     Shift: TShiftState; Index: Integer; EndToken: Char);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExecuteEx(s: string; x, y: integer; Kind: SynCompletionType
      {$IFDEF SYN_COMPILER_4_UP} = ctCode {$ENDIF}); override;
    procedure ActivateCompletion(AEditor: TSynEdit); overload;
    property CompletionProposalOptions: IpSHCompletionProposalOptions
      read FCompletionProposalOptions write FCompletionProposalOptions; 
    property NeedObjectType: TpSHNeedObjectType read FNeedObjectType
      write FNeedObjectType;
  published

  end;

  TpSHCompletionProposalHintWnd = class(THintWindow)
  private
    FActivating: Boolean;
    FCompletionProposal: TpSHCompletionProposal;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    procedure Paint; override;
  public
    function CalcHintRect(MaxWidth: Integer; const AHint: string;
      AData: Pointer): TRect; override;
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
    procedure ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer); override;
  end;

  TpSHCompletionProposalHintWndClass = class of TpSHCompletionProposalHintWnd;

implementation

uses SynEditHighlighter, pSHSynEdit, pSHHighlighter, SysUtils,
  pSHStrUtil, StrUtils;

{ TBTCompletionProposal }

procedure TpSHCompletionProposal.CompletionProposalWndProc(var Message: TMessage);
var
  vMousePos: TPoint;
  vTextHeight: Integer;
  vTextWidth: Integer;
  s: string;
begin
  FCompletionProposalWndProc(Message);
  with Message do
    case Msg of
      CM_HINTSHOWPAUSE:
        with TCMHintShowPause(Message) do
        begin
          if NeedHint(vTextHeight, vTextWidth, s, vMousePos) then
            Pause^ := 0
          else
            Pause^ := Application.HintPause;
        end;
      CM_HINTSHOW:
        with TCMHintShow(Message), PHintInfo(TCMHintShow(Message).HintInfo)^ do
        begin
          if NeedHint(vTextHeight, vTextWidth, HintStr, vMousePos) then
          begin
            HintWindowClass := TpSHCompletionProposalHintWnd;
            HintPos.X := Form.Left + 3;
            HintPos.Y := Form.Top + ((vMousePos.Y - 3) div vTextHeight) * vTextHeight + 2;
            CursorRect := Rect(HintPos.X, HintPos.Y, HintPos.X + vTextWidth, HintPos.Y + vTextHeight);
            HintMaxWidth := vTextWidth + 1;
            ReshowTimeout := 10000;
            HideTimeout := 0;
            HintData := Self;
            Result := 0;
          end
          else
            Result := -1;
        end;
    end;
end;

procedure TpSHCompletionProposal.WindowClose(Sender: TObject);
begin
  if Assigned(FCompletionProposalOptions) then
  begin
    FCompletionProposalOptions.LinesCount := NbLinesInWindow;
    FCompletionProposalOptions.Width := Width;
  end;
end;

function TpSHCompletionProposal.NeedHint(var ATextHeight, ATextWidth: Integer;
  var AHint: string; var AMousePos: TPoint): boolean;
var
  vHintItem: Integer;
  vScrollBar: TScrollBar;
  vItmList: TStrings;
  function FindScrollBar(AComponent: TComponent): TScrollBar;
  var
    I: Integer;
  begin
    Result := nil;
    for I := 0 to AComponent.ComponentCount - 1 do
    begin
      if AComponent.Components[I].ClassType = TScrollBar then
      begin
        Result := TScrollBar(AComponent.Components[I]);
        break;
      end;
    end;
  end;
begin
  Result := False;
  if (DisplayType = ctCode) then
  begin
    GetCursorPos(AMousePos);
    ScreenToClient(Form.Handle, AMousePos);
    vScrollBar := FindScrollBar(Form);
    if Assigned(vScrollBar) then
    begin
      ATextHeight := Form.Canvas.TextHeight('W') + 3;
      vHintItem := ((AMousePos.Y - 3) div ATextHeight) + vScrollBar.Position;
      if scoLimitToMatchedText in Options then
        vItmList := Form.AssignedList
      else
        vItmList := ItemList;
      if ((vHintItem >= 0) and (vHintItem < vItmList.Count)) then
      begin
        AHint := vItmList[vHintItem];
        ATextWidth := FormattedTextWidth(Form.Canvas, AHint, Form.Columns, Images);
        Result := ATextWidth > (Form.Width - 7 - vScrollBar.Width);
      end;
    end;
  end;
end;

procedure TpSHCompletionProposal.DoAfterCodeCompletion(Sender: TObject; const Value: string;
     Shift: TShiftState; Index: Integer; EndToken: Char);
begin
  if Length(Value)>2 then
   if (Value[Length(Value)]=')') and (Value[Length(Value)-1]='(') then
        with Form.CurrentEditor do
         CaretX:=CaretX-1    
end;

constructor TpSHCompletionProposal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DefaultType := ctCode;
  FNeedObjectType := ntAll;
  Form.ShowHint := True;
  Form.ItemHeight := Form.Canvas.TextHeight('W') + 3;
  FCompletionProposalWndProc := Form.WindowProc;
  Form.WindowProc := CompletionProposalWndProc;
  OnClose := WindowClose;
//  EndOfTokenChr := EndOfTokenChr + '=';
  EndOfTokenChr := '()[]= ';
  OnAfterCodeCompletion:=DoAfterCodeCompletion;

  Options := Options + [scoConsiderWordBreakChars];
end;

destructor TpSHCompletionProposal.Destroy;
begin
  Form.WindowProc := FCompletionProposalWndProc;
  inherited;
end;


procedure TpSHCompletionProposal.ExecuteEx(s: string; x, y: integer;
  Kind: SynCompletionType);
const
  CharsAfterClause =[' ',#13,#9,'(',',',';'];
  CharsBeforeClause=[' ',#10,')',#9];
var vHiAttr: TSynHighlighterAttributes;
    vToken: string;
    vTokenStart: Integer;
    vTokenKind: Integer;
    lookup: string;
    TmpYUp, TmpYDown: Integer;
    vCurrentCaretX: Integer;
    vCurrentCaretY: Integer;
    NeedObjectNameSearch: Boolean;
    CanExecute: Boolean;
    TmpLine: string;

    function FindFullLineUp(var Y: Integer): Boolean;//перескакиваем вверх на полную строку
    var
      vLLLength: Integer;
    begin
      Result := False;
      with TpSHSynEdit(Form.CurrentEditor) do
      begin
        while Y > 0 do
        begin
          vLLLength := Length(Lines[Y - 1]);
          if vLLLength > 0 then
          begin
            vCurrentCaretX := length(Lines[Y - 1]);
            Result := True;
            Break;
          end
          else
            Dec(Y);
        end;
      end;
    end;

    procedure SkipSpaces(var ALineNo: Integer);
    var
      vBufferCoord: TBufferCoord;
    begin
      vTokenKind := Ord(tkSpace);
      while ((vTokenKind = Ord(tkSpace)) or (vTokenKind = Ord(tkNull))) and
        (ALineNo > 0) do
      begin

        if vCurrentCaretX > 1 then
          Dec(vCurrentCaretX)
        else
        begin
//          repeat
          while (vCurrentCaretX <= 1) and (ALineNo > 1) do
          begin
            Dec(ALineNo);
            vCurrentCaretX :=
              Length(TpSHSynEdit(Form.CurrentEditor).Lines[ALineNo - 1]);
          end;    
//          until (vCurrentCaretX > 1) or (ALineNo = 1);
        end;
        if (vCurrentCaretX > 1) and
           (vCurrentCaretX <= Length(TpSHSynEdit(Form.CurrentEditor).Lines[ALineNo - 1])) and
           (TpSHSynEdit(Form.CurrentEditor).Lines[ALineNo - 1][vCurrentCaretX] = ')') then
        begin
          repeat
            {
            if vCurrentCaretX = 0 then
            begin
              if ALineNo = 1 then Break;
              Dec(ALineNo);
              vCurrentCaretX :=
                Length(TpSHSynEdit(Form.CurrentEditor).Lines[ALineNo - 1]);
            end
            else
              Dec(vCurrentCaretX);
            }
            Dec(vCurrentCaretX);
            while (vCurrentCaretX = 0) do
            begin
              if ALineNo = 1 then Break;
              Dec(ALineNo);
              vCurrentCaretX :=
                Length(TpSHSynEdit(Form.CurrentEditor).Lines[ALineNo - 1]);
            end;
            if ALineNo = 1 then
            begin
              vCurrentCaretX := 1;
              Break;
            end;
          until (TpSHSynEdit(Form.CurrentEditor).Lines[ALineNo - 1][vCurrentCaretX] = '(' );
          Dec(vCurrentCaretX);
        end;
        vBufferCoord.Char := vCurrentCaretX;
        vBufferCoord.Line := ALineNo;
        TpSHSynEdit(Form.CurrentEditor).GetHighlighterAttriAtRowColEx(
          vBufferCoord, vToken, vTokenKind,
          vTokenStart, vHiAttr);
        if (vCurrentCaretX <= 1) and (ALineNo = 1) then Break;
      end;
    end;

    function FindObjectAtLine(var ALineNo: Integer): Boolean;
    var
      vLookUp: string;
      vLineNo: Integer;
    begin
      vLineNo := ALineNo;
      Result := False;
      with TpSHSynEdit(Form.CurrentEditor) do
      begin
        if ((ALineNo <= 0) or (ALineNo > Lines.Count)) then exit;
        if Assigned(Highlighter) then
        begin
//          vCurrentCaretX := GetTokenPos(vLineNo, 1, lookup);
          vCurrentCaretX := PosExtCI(lookup, Lines[vLineNo - 1], CharsBeforeClause,CharsAfterClause);
//          vIdent := Length(Lines[vLineNo - 1]) - (Length(lookup) + 1);
//          vCurrentCaretX := GetTokenPos(vLineNo, vIdent, lookup);

          if (vCurrentCaretX = 1) and (vLineNo > 0) then
          begin
            Dec(vLineNo);
            vCurrentCaretX := Length(Lines[vLineNo - 1]) + 1;
          end;
          if vCurrentCaretX > 0 then
//          while (vIdent > 0) and (not Result) do
          begin
            SkipSpaces(vLineNo);
            if vCurrentCaretX > 0 then
            begin
              vlookup := GetTokenAt(TBufferCoord(Point(vCurrentCaretX, vLineNo)), vTokenKind);
              Result := vTokenKind = Ord(tkTableName);
              if Result then
                lookup := vlookup;
            end;
          end;
        end;
      end;
    end;

//Buzz
procedure  GetObjectTypeFromText(CaretX,CaretY:integer) ;
var
 p:TSQLParser;
 SQLText:string;
 PosInText:integer;
 PosIn:TSQLSections;
 bgStatement:integer;
// vSQLKind:TSQLKind;
begin
 SQLText:=TpSHSynEdit(Form.CurrentEditor).Lines.Text;
 p:=TSQLParser.Create(SQLText);
 with TpSHSynEdit(Form.CurrentEditor) do
 try
{ TODO -oBuzz -cProposal : Добиться правильного распарсивания DDL (триггеров процедур) }
//  vSQLKind:=p.SQLKind;
  PosInText:=(CaretX-Length(Lines[CaretY-1]));
  if PosInText>0 then
     PosInText:=SelStart-PosInText+1
  else
    PosInText:=SelStart ;
  bgStatement:= p.BeginSimpleStatementForPos(PosInText);
  if bgStatement<>1 then
  begin
   Dec(PosInText,bgStatement-1);
   p.SQLText:=Copy(p.SQLText,bgStatement,MaxInt);
  end;
  PosIn:=p.PosInSections(PosInText);
  if Length(PosIn)>0 then
  case PosIn[Length(PosIn)-1] of
   stFields:
          if (Length(PosIn)=1) or (PosIn[Length(PosIn)-2]<>stInsert) then
            NeedObjectType :=ntFieldOrVariableOrFunction
          else
            NeedObjectType :=ntField;
   stUpdate:
            NeedObjectType:=ntTableOrView;
   stSet:
            NeedObjectType:=ntField;
   stFrom:
       if (Length(PosIn)>1) then
       begin
         if (PosIn[Length(PosIn)-2]=stDelete) then
            NeedObjectType :=ntTableOrView
         else
            NeedObjectType :=ntTableOrViewOrProcedure;
       end
       else
            NeedObjectType :=ntTableOrViewOrProcedure;
   stWhere:
            NeedObjectType :=ntFieldOrVariableOrFunction;
   stInto:
      if (Length(PosIn)>1) and (PosIn[Length(PosIn)-2]=stInsert) then
         NeedObjectType :=ntTableOrView
      else
         NeedObjectType :=ntVariable;
   stValues:
     NeedObjectType :=ntFieldOrVariableOrFunction;
   stReturning:
     NeedObjectType :=ntField;
   stReturningValues:
     NeedObjectType :=ntVariable;
   stException:
     NeedObjectType :=ntException;
   stExecute:
     NeedObjectType :=ntExecutable;
   stProcedure:
    NeedObjectType :=ntProcedure;
   stNeedReturningValues:
    NeedObjectType :=ntReturningValues;
   stDeclareVariables:
    NeedObjectType :=ntDeclareVariables;
  end;
 finally
  p.Free
 end;
end;

function GetFirstTableName:string;
var
 p:TSQLParser;
 SQLText:string;
 PosInText:integer;
 bgStatement:integer;
begin
 SQLText:=TpSHSynEdit(Form.CurrentEditor).Lines.Text;
 p:=TSQLParser.Create(SQLText);
 try
   case p.SQLKind of
    skSelect: Result:=p.MainFrom;
    skUpdate,skInsert,skDelete:
     Result:=p.ModifiedTables;
   else
    with TpSHSynEdit(Form.CurrentEditor) do
    begin
      PosInText:=(CaretX-Length(Lines[CaretY-1]));
      if PosInText>0 then
         PosInText:=SelStart-PosInText+1
      else
        PosInText:=SelStart ;

      bgStatement:= p.BeginSimpleStatementForPos(PosInText);
      if bgStatement<>1 then
      begin
       p.SQLText:=Copy(p.SQLText,bgStatement,MaxInt);
      end;
      case p.SQLKind of
        skSelect:
        begin
         Result:=CutTableName(p.MainFrom);
        end;
        skUpdate,skInsert,skDelete:
         Result:=p.ModifiedTables;
      else
        Result:=''
      end;
     end  
   end
 finally
  p.Free
 end
end;

//end Buzz
begin

  with TpSHSynEdit(Form.CurrentEditor) do
  begin
    //данная прелюдия к вызову наследованного метода обусловлена необходимостью
    //определить, что нужно пропосалу - все, поля к таблице (с вычислением ее
    //имени по псевдониму, поля таблице в триггере, переменные процедуры



    NeedObjectNameSearch := False;

    if Assigned(Highlighter) and (Kind = ctCode) then
      //если не насильственный вызов пропосала на определенный тип объектов
      if not (NeedObjectType in [ntDomain..ntBuildInFunctions]) then
      begin
        vCurrentCaretX := CaretX - 1;
        vCurrentCaretY := CaretY;
        vToken := GetTokenAt(TBufferCoord(Point(vCurrentCaretX, CaretY)), vTokenKind);
//Buzz
        GetObjectTypeFromText(vCurrentCaretX, CaretY);
//End Buzz

        case TtkTokenKind(vTokenKind) of
          tkVariable: NeedObjectType := ntVariable;
          tkSymbol:
            if vToken = '.' then
              NeedObjectNameSearch := True
            else
            begin
              if (TpSHHighlighter(Highlighter).SQLDialect = sqlSybase) and
                (vToken = '@') then
                NeedObjectType := ntVariable
              else
              if (TpSHHighlighter(Highlighter).SQLDialect in
                [sqlOracle, sqlIngres, sqlInterbase]) and
                (vToken = ':') then
                NeedObjectType := ntVariable;
            end;
          tkString:
            if TpSHHighlighter(Highlighter).SQLDialect = sqlInterbase then
            begin
              vCurrentCaretX := CaretX;
              SkipSpaces(vCurrentCaretY);
              vCurrentCaretX := vTokenStart;
              SkipSpaces(vCurrentCaretY);
              NeedObjectNameSearch := (TtkTokenKind(vTokenKind) = tkSymbol) and
                (vToken = '.');
            end;
          else
            if (TtkTokenKind(vTokenKind) <> tkSpace) and (Length(vToken) > 0) then
            begin
              vCurrentCaretX := CaretX;
              SkipSpaces(vCurrentCaretY);
              vCurrentCaretX := vTokenStart;
              SkipSpaces(vCurrentCaretY);
              NeedObjectNameSearch := (TtkTokenKind(vTokenKind) = tkSymbol) and
                (vToken = '.');
            end;

        end;
        //если поле таблицы/триггера
        if NeedObjectNameSearch then
        begin

//          CompletionStart := vCurrentCaretX + 1; заремлено после исправления бага от Воинова - отремлено Options := Options + [scoConsiderWordBreakChars]; в Create
          SkipSpaces(vCurrentCaretY);
          //вычисляем, что до точки, если вобще что-то там есть
          //если нет - работаем по стандартной схеме, х.з., что в голове у
          //юзеров разных серверов :)
          if TtkTokenKind(vTokenKind) = tkKey then
          begin
            if TpSHHighlighter(Highlighter).SQLDialect = sqlInterbase then
            begin
              if (AnsiUpperCase(vToken) = 'NEW') or
                (AnsiUpperCase(vToken) = 'OLD') then
                NeedObjectType := ntField;
            end;
          end
          else
          if TtkTokenKind(vTokenKind) <> tkTableName then
          begin
          //если нам подсунули псевдоним - придется поработать
            TmpYUp := vCurrentCaretY;
            Inc(vCurrentCaretY);
            TmpYDown := vCurrentCaretY;
            vCurrentCaretX := vTokenStart - 1;
            lookup := vToken;
            //пока не найдем эту гребанную таблицу
            while ((TmpYUp > 0) or (TmpYDown <= Lines.Count)) do
            begin
              //если есть выше или ниже
              if FindObjectAtLine(TmpYUp) or FindObjectAtLine(TmpYDown) then
              begin
                vToken := lookup;
                NeedObjectType := ntField;
                Break;
              end
              else
              //если не нашли расширяемся в обе стороны
              begin
                if (TmpYDown < vCurrentCaretY) then
                  TmpYDown := vCurrentCaretY + 1;
                vCurrentCaretY := TmpYDown;
                if TmpYUp > 0 then Dec(TmpYUp);
                //пропускаем пустые строки
                while ((TmpYUp > 0) and
                  (Length(Lines[TmpYUp - 1]) = 0)) do Dec(TmpYUp);
                if TmpYDown <= Lines.Count then Inc(TmpYDown);
                while ((TmpYDown <= Lines.Count) and
                  (Length(Lines[TmpYDown - 1]) = 0)) do Inc(TmpYDown);
              end;
            end;
          end
          else
            NeedObjectType := ntField;
        end
        else
        begin
          vToken := s;
          if NeedObjectType in [ntField,ntFieldOrFunction,ntFieldOrVariableOrFunction] then
          begin

//           vToken:=CutTableName(GetFirstTableName);
           vToken:=GetFirstTableName;
           if vToken='' then
            NeedObjectType :=ntAll
          end
        end;
      end;
    CanExecute := True;
    //Обрабатываем возможное наличие кавычки для сдвига CompletionStart
    if (Form.CurrentEditor.Lines.Count > 0) and (Form.CurrentEditor.CaretY <= Form.CurrentEditor.Lines.Count) then
    begin
      TmpLine := Form.CurrentEditor.Lines[Form.CurrentEditor.CaretY - 1];
      if (CompletionStart > 1) and (CompletionStart - 1 <= Length(TmpLine)) and (TmpLine[CompletionStart - 1] = '"') then
        CompletionStart := CompletionStart - 1;
    end;

    if Assigned(Form.CurrentEditor.Highlighter) and
       Assigned(TpSHHighlighter(Form.CurrentEditor.Highlighter).ObjectNamesManager) then
      TpSHHighlighter(Form.CurrentEditor.Highlighter).ObjectNamesManager.ExecuteNotify(Ord(Kind), Self, vToken, x, y, CanExecute);

    ResetAssignedList;
    Form.CurrentString := vToken;
{
    if CanExecute and (Form.AssignedList.Count > 0) then
    begin
      if Assigned(FCompletionProposalOptions) then
      begin
        NbLinesInWindow := FCompletionProposalOptions.LinesCount;
        Self.Width := FCompletionProposalOptions.Width;
      end;
      inherited ExecuteEx(vToken, x, y, Kind);
    end;
}
    if (not CanExecute) or (Form.AssignedList.Count = 0) then
    begin
      ItemList.Clear;
      InsertList.Clear;
    end;
    if Assigned(FCompletionProposalOptions) then
    begin
      NbLinesInWindow := FCompletionProposalOptions.LinesCount;
      Self.Width := FCompletionProposalOptions.Width;
    end;

   if vToken<>'.' then
    vToken :=s;
    inherited ExecuteEx(vToken, x, y, Kind);

    if Kind = ctCode then
      NeedObjectType := ntAll;
  end;
end;

procedure TpSHCompletionProposal.ActivateCompletion(AEditor: TSynEdit);
begin
  DoExecute(AEditor);
end;

{ TpSHCompletionProposalHintWnd }

procedure TpSHCompletionProposalHintWnd.CMTextChanged(
  var Message: TMessage);
begin
  inherited;
  { Avoid flicker when calling ActivateHint }
  if FActivating then Exit;
  if Assigned(FCompletionProposal) then
  begin
    Width := FormattedTextWidth(Canvas, Caption, FCompletionProposal.Columns, FCompletionProposal.Images) + 6;
    Height := Height + 3; 
  end;
end;

procedure TpSHCompletionProposalHintWnd.Paint;
var
  R: TRect;
begin
  if Assigned(FCompletionProposal) then
  begin
    R := ClientRect;
    Inc(R.Left, 1);
    Inc(R.Top, 1);
//    Canvas.Rectangle(-1,-1, Width, Height);
  //  Canvas.Font.Color := clInfoText;
    FormattedTextOut(Canvas, R, Caption, False, FCompletionProposal.Columns, FCompletionProposal.Images);
  end
  else
    inherited;
end;

function TpSHCompletionProposalHintWnd.CalcHintRect(MaxWidth: Integer;
  const AHint: string; AData: Pointer): TRect;
var
  vMousePos: TPoint;
  vTextHeight: Integer;
  vTextWidth: Integer;
  s: string;
begin
  if Assigned(AData) and TpSHCompletionProposal(AData).NeedHint(vTextHeight, vTextWidth, s, vMousePos) then
  begin
    Result := Rect(0, 0, vTextWidth, vTextHeight);
    Inc(Result.Right, 6);
    Dec(Result.Bottom, 1);
  end
  else
    Result := inherited CalcHintRect(MaxWidth, AHint, AData);
end;

procedure TpSHCompletionProposalHintWnd.ActivateHint(Rect: TRect;
  const AHint: string);
begin
  FActivating := True;
  try
    inherited;
  finally
    FActivating := False;
  end;
end;

procedure TpSHCompletionProposalHintWnd.ActivateHintData(Rect: TRect;
  const AHint: string; AData: Pointer);
begin
  if AData <> nil then
  begin
    FCompletionProposal := TpSHCompletionProposal(AData);
    Canvas.Font.Assign(FCompletionProposal.Form.Canvas.Font);
    Canvas.Font.Style := Canvas.Font.Style - [fsBold];
  end
  else
    FCompletionProposal := nil;
  inherited;
end;

end.


