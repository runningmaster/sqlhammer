unit pSHParametersHint;

interface

uses Classes, SysUtils, Graphics, Types, Forms,
     SynEditTypes,
     SynCompletionProposal,
     pSHIntf;

type

  TpSHParametersHint  = class(TSynCompletionProposal)
  private
    FProcedureOutPutNeeded: Boolean;
    FProposalHintRetriever: IpSHProposalHintRetriever;
    procedure SetProposalHintRetriever(
      const Value: IpSHProposalHintRetriever);
  protected
    procedure PaintItem(Sender: TObject; Index: Integer; TargetCanvas: TCanvas;
      ItemRect: TRect; var CustomDraw: Boolean);
  {
    procedure DoOnExecute(Kind: SynCompletionType; Sender: TObject;
      var AString: string; var x, y: Integer; var CanExecute: Boolean); override;
    procedure ExecuteEx(s: string; x, y: integer; Kind: SynCompletionType
      {$IFDEF SYN_COMPILER_4_UP}// = ctCode {$ENDIF}); override;
//  }
  public
    constructor Create(AOwner: TComponent); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ExecuteEx(s: string; x, y: integer; Kind: SynCompletionType
      {$IFDEF SYN_COMPILER_4_UP} = ctCode {$ENDIF}); override;
    property ProposalHintRetriever: IpSHProposalHintRetriever
      read FProposalHintRetriever write SetProposalHintRetriever;  

  published

  end;


implementation

uses pSHSynEdit, pSHHighlighter;

{ TpSHParametersHint }

{
procedure TpSHParametersHint.DoOnExecute(Kind: SynCompletionType;
  Sender: TObject; var AString: string; var x, y: Integer;
  var CanExecute: Boolean);

begin
}
  {


  }
{
это пример, что писать в OnExecute
  if CanExecute then
  begin
    TSynCompletionProposal(Sender).Form.CurrentIndex := TmpLocation;
    if Lookup <> TSynCompletionProposal(Sender).PreviousWord then
    begin
      TSynCompletionProposal(Sender).ItemList.Clear;

      if Lookup = 'TESTFUNCTION' then
      begin
        TSynCompletionProposal(Sender).ItemList.Add('FirstParam integer');
        TSynCompletionProposal(Sender).ItemList.Add('SecondParam integer');
        TSynCompletionProposal(Sender).ItemList.Add('ThirdParam string');
      end else if Lookup = 'MIN' then
      begin
        TSynCompletionProposal(Sender).ItemList.Add('A:integer, B:integer');
      end else if Lookup = 'MAX' then
      begin
        TSynCompletionProposal(Sender).ItemList.Add('A integer');
        TSynCompletionProposal(Sender).ItemList.Add('B integer');
      end;
    end;
  end else TSynCompletionProposal(Sender).ItemList.Clear;

  inherited DoOnExecute(Kind, Self, AString, x, y, CanExecute);

end;
}

{ TpSHParametersHint }

procedure TpSHParametersHint.SetProposalHintRetriever(
  const Value: IpSHProposalHintRetriever);
begin
  if FProposalHintRetriever <> Value then
  begin
    ReferenceInterface(FProposalHintRetriever, opRemove);
    FProposalHintRetriever := Value;
    ReferenceInterface(FProposalHintRetriever, opInsert);
  end;
end;

function FormatParamList(const S: String; CurrentIndex: Integer): string;
var
  i: Integer;
  List: TStrings;
begin
  Result := '';
  List := TStringList.Create;
  try
    List.CommaText := S;
    for i := 0 to List.Count - 1 do
    begin
      if i = CurrentIndex then
        Result := Result + '\style{~B}' + List[i] + '\style{~B}'
      else
        Result := Result + List[i];

      if i < List.Count - 1 then
//        Result := Result + ', ';
        Result := Result + ' ';
    end;
  finally
    List.Free;
  end;
end;

procedure TpSHParametersHint.PaintItem(Sender: TObject; Index: Integer;
  TargetCanvas: TCanvas; ItemRect: TRect; var CustomDraw: Boolean);
var
  ParamInStrNo: Integer;
  NewIndex: Integer;
  ParamsProceded: Integer;
  CurrentLine: string;
  CommaPos: Integer;
  TmpString: string;
begin
  NewIndex := -1;
  if Form.AssignedList.Count <= 1 then
    CustomDraw := False
  else
  begin
    CustomDraw := True;
    ParamInStrNo := 0;
    ParamsProceded := -1;
    //¬ычисл€ем строку и положение параметра в многострочной подсказке 
    while (ParamInStrNo < Form.AssignedList.Count) and (ParamsProceded < Form.CurrentIndex) do
    begin
      CurrentLine := Form.AssignedList[ParamInStrNo];
      NewIndex := -1;
      while (Length(CurrentLine) > 0) and (ParamsProceded < Form.CurrentIndex) do
      begin
        CommaPos := Pos(', ", ', CurrentLine);
        if CommaPos > 0 then
        begin
          Inc(NewIndex);
          Inc(ParamsProceded);
          CurrentLine := Copy(CurrentLine, CommaPos + 5, MaxInt);
        end
        else
        begin
          Inc(NewIndex);
          Inc(ParamsProceded);
          CurrentLine := EmptyStr;        
          Break;
        end;
      end;
      if ParamsProceded < Form.CurrentIndex then
        Inc(ParamInStrNo);
    end;
    if ParamInStrNo = Index then
      TmpString := FormatParamList(Form.AssignedList[Index], NewIndex)
    else
      TmpString := FormatParamList(Form.AssignedList[Index], -1);
    FormattedTextOut(TargetCanvas,
      Rect(Form.Margin + ItemRect.Left, ItemRect.Top, ItemRect.Right, ItemRect.Bottom),
      TmpString, False, nil, Form.Images);
  end;
end;

constructor TpSHParametersHint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DefaultType := ctParams;
  FProcedureOutPutNeeded := False;
  EndOfTokenChr := '()[]. ';
  TriggerChars := '(';
  Options := [scoLimitToMatchedText,scoUsePrettyText,scoUseBuiltInTimer];
  TimerInterval := 1000;
  Form.OnPaintItem := PaintItem;
end;

procedure TpSHParametersHint.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent.IsImplementorOf(FProposalHintRetriever) then
      FProposalHintRetriever := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TpSHParametersHint.ExecuteEx(s: string; x, y: integer;
  Kind: SynCompletionType);
var
    CanExecute: Boolean;
    locline: string;
    lookup: string;
    TmpX: Integer;
    savepos, StartX, StartY,
    ParenCounter,
    TmpLocation    : Integer;
    FoundMatch     : Boolean;
    TmpY: Integer;
    vHint: string;
    ShortedHint: string;
    ShortedItem: string;
    CommaPos: Integer;
    ItemsIncluded: Integer;
    function FindFullLine: Boolean;//перескакиваем вверх на полную строку
    var
      vLLLength: Integer;
    begin
      locline := '';
      Result := False;
      with TpSHSynEdit(Form.CurrentEditor) do
      begin
        while TmpY > 0 do
        begin
          vLLLength := Length(Lines[TmpY - 1]);
          if vLLLength > 0 then
          begin
            locline := Lines[TmpY - 1];
            TmpX := length(locLine);
            Result := True;
            Break;
          end
          else
            Dec(TmpY);
        end;
      end;
    end;
    function SafeDecTmpX: Boolean;
    begin
      Result := True;
      if TmpX > 0 then
        Dec(TmpX);
      if TmpX <= 0 then
      begin
        Dec(TmpY);
        if not FindFullLine then
        begin
          Result := False;
          CanExecute := False;
        end;
      end;
    end;
    procedure HideHint;
    begin
      if Form.Visible then
        Form.Visible := False;
    end;
begin
  if not Assigned(FProposalHintRetriever) then
  begin
    HideHint;
    Exit;
  end;
  with TpSHSynEdit(Form.CurrentEditor) do
  begin
    if Assigned(Highlighter) and
      (TpSHHighlighter(Highlighter).SQLDialect in [sqlInterbase]) then
    begin
      //go back from the cursor and find the first open paren
      TmpX := CaretX;
      TmpY := CaretY;
      FoundMatch := False;
      TmpLocation := 0;
      FProcedureOutPutNeeded := False;
      if (TmpX = 1) and (TmpY > 1) then Dec(TmpY);
      if not FindFullLine then
      begin
        CanExecute := False;
        HideHint;
        exit;
      end;
      if ((CaretX <> 1) and (Length(LineText) > 0)) then
      begin
        TmpX := CaretX;
        if TmpX > length(locLine) then
          TmpX := length(locLine)
        else dec(TmpX);
      end;

      while (TmpX > 0) and not(FoundMatch) do
      begin
        if LocLine[TmpX] = ',' then
        begin
         if not FProcedureOutPutNeeded then
            inc(TmpLocation);
          dec(TmpX);
        end
        else
        if LocLine[TmpX] = ')' then
        begin
          //We found a close, go till it's opening paren   ѕропуск вложенных скобок
          ParenCounter := 1;
          if not SafeDecTmpX then
          begin
            HideHint;
            Exit;
          end;
          while (TmpX > 0) and (ParenCounter > 0) do
          begin
            if LocLine[TmpX] = ')' then inc(ParenCounter)
              else
              if LocLine[TmpX] = '(' then
                dec(ParenCounter);
            if not SafeDecTmpX then
            begin
              HideHint;
              Exit;
            end;
          end;
          if not SafeDecTmpX then
          begin
            HideHint;
            Exit;
          end;
        end
        else
          if locLine[TmpX] = '(' then
          begin
            //we have a valid open paren, lets see what the word before it is
            StartX := TmpX;
            StartY := TmpY;
            while (TmpX > 0) and not(locLine[TmpX] in (TSynValidStringChars + ['$'])) do //пропуск невалидных символов
              if not SafeDecTmpX then
              begin
                HideHint;
                Exit;
              end;
            if TmpX > 0 then
            begin
              SavePos := TmpX;
              While (TmpX > 0) and (locLine[TmpX] in (TSynValidStringChars + ['$'])) do
                dec(TmpX);
              inc(TmpX);
              lookup := AnsiUpperCase(Copy(LocLine, TmpX, SavePos - TmpX + 1));
              if (lookup = 'RETURNING_VALUES') or (lookup = 'VALUES') then
              begin
                FProcedureOutPutNeeded := True;
                if not SafeDecTmpX then
                begin
                  HideHint;
                  Exit;
                end;
                while LocLine[TmpX] <> ')' do
                  if not SafeDecTmpX then
                  begin
                    HideHint;
                    Exit;
                  end;
                if not SafeDecTmpX then
                begin
                  HideHint;
                  Exit;
                end;
                continue;
              end;
              FoundMatch := CanJumpAt(TDisplayCoord(Point(TmpX, TmpY)));
              if not(FoundMatch) then
              begin
                TmpX := StartX;
                TmpY := StartY;
                if not SafeDecTmpX then
                begin
                  HideHint;
                  Exit;
                end;
              end;
            end;
          end
          else
            if not SafeDecTmpX then
            begin
              HideHint;
              Exit;
            end;
      end;

      CanExecute := FoundMatch;
      if CanExecute then
      begin
        if FProposalHintRetriever.GetHint(lookup, vHint, FProcedureOutPutNeeded) then
        begin
          ShortedHint := '';
          ItemList.Clear;
          ItemsIncluded := 0;
          while Length(vHint) > 0 do
          begin
            while ((Form.Margin + Form.Canvas.TextWidth(ShortedHint)) < Screen.Width) do
            begin
              CommaPos := Pos(', ", ', vHint);
              if CommaPos > 0 then
              begin
                ShortedItem := Copy(vHint, 1, CommaPos + 4);
                vHint := Copy(vHint, CommaPos + 5, MaxInt);
                ShortedHint := ShortedHint + ShortedItem;
              end
              else
              begin
                ShortedItem := vHint;
                vHint := EmptyStr;
                ShortedHint := ShortedHint + ShortedItem;
                Break;
              end;
              Inc(ItemsIncluded);
            end;
            if ((Form.Margin + Form.Canvas.TextWidth(ShortedHint)) >= Screen.Width) and (ItemsIncluded > 1) then
            begin
              ShortedHint := Copy(ShortedHint, 1, Length(ShortedHint) - Length(ShortedItem));
              vHint := ShortedItem + vHint;
            end;
            ItemList.Add(ShortedHint);
            ShortedHint := EmptyStr;
            ItemsIncluded := 0;
          end;
          Form.CurrentIndex := TmpLocation;
          inherited ExecuteEx(lookup, x, y, ctParams);
        end
        else
          HideHint;
      end
      else
        HideHint;

    end;
  end;
end;

end.
