unit ibSHPSQLDebuggerTokenScaner;

interface

uses Classes, Types;

type

  TdtsRange = (rUnknown, rComments, rString, rNumeric, rStatements, rD3Identifier);
  TdtsTokenType = (ttUnknown, ttString, ttNumeric, ttIdentifier, ttD3Identifier, ttSymbol);
//  TdtsTokenCoord = TRect;
  TdtsTokenCoord = packed record
    case Integer of
      0: (TopLeftChar, TopLine, BottomRightChar, BottomLine: Longint);
      1: (TopLeftPoint, BottomRightPoint: TPoint);
  end;

  TibSHPSQLDebuggerTokenScaner = class(TComponent)
  private
    FCurrentPoint: TPoint;
    FDDLText: TStrings;
    FRange: TdtsRange;
    FToken: string;
    FTokenCoord: TdtsTokenCoord;
    FTokenNumber: Integer;
    FTokenType: TdtsTokenType;

    FCurrentLine: string;
    FUpperToken : string;

    function GetCurrentPoint: TPoint;
    procedure SetCurrentPoint(const Value: TPoint);
    function GetDDLText: TStrings;
    procedure SetDDLText(const Value: TStrings);
    function GetRange: TdtsRange;
    function GetToken: string;
    function GetTokenBegin: TPoint;
    function GetTokenEnd: TPoint;
    function GetTokenCoord: TdtsTokenCoord;
    function GetTokenNumber: Integer;
    function GetTokenType: TdtsTokenType;
    procedure SetToken(const Value: string);
  protected
    function AppendNextLine: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Reset;
    function Next: Boolean;
    procedure MoveBack;

    property DDLText: TStrings read GetDDLText write SetDDLText;
    property Range: TdtsRange read GetRange;
    property Token: string read GetToken write SetToken;
    property UpperToken: string read FUpperToken;
    property TokenBegin: TPoint read GetTokenBegin;
    property TokenEnd: TPoint read GetTokenEnd;
    property TokenCoord: TdtsTokenCoord read GetTokenCoord;
    property TokenNumber: Integer read GetTokenNumber;
    property TokenType: TdtsTokenType read GetTokenType;

    property CurrentPoint: TPoint read GetCurrentPoint write SetCurrentPoint;

  end;

implementation

uses SysUtils;

const
  CorrectIndentifierChars = ['_', 'a'..'z', 'A'..'Z', '0', '1'..'9', '$'];
  CorrectNumericChars = ['.', '0', '1'..'9'];

{ TibSHPSQLDebuggerTokenScaner }

constructor TibSHPSQLDebuggerTokenScaner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDDLText := TStringList.Create;
  Reset;
end;

destructor TibSHPSQLDebuggerTokenScaner.Destroy;
begin
  FDDLText.Free;
  inherited;
end;

function TibSHPSQLDebuggerTokenScaner.GetCurrentPoint: TPoint;
begin
  Result := FCurrentPoint;
end;

procedure TibSHPSQLDebuggerTokenScaner.SetCurrentPoint(
  const Value: TPoint);
begin
  FCurrentPoint := Value;
end;

function TibSHPSQLDebuggerTokenScaner.GetDDLText: TStrings;
begin
  Result := FDDLText;
end;

procedure TibSHPSQLDebuggerTokenScaner.SetDDLText(const Value: TStrings);
begin
  FDDLText.Assign(Value);
end;

function TibSHPSQLDebuggerTokenScaner.GetRange: TdtsRange;
begin
  Result := FRange;
end;

function TibSHPSQLDebuggerTokenScaner.GetToken: string;
begin
  Result := FToken;
end;

function TibSHPSQLDebuggerTokenScaner.GetTokenBegin: TPoint;
begin
  Result := FTokenCoord.TopLeftPoint;
end;

function TibSHPSQLDebuggerTokenScaner.GetTokenEnd: TPoint;
begin
  Result := FTokenCoord.BottomRightPoint;
end;

function TibSHPSQLDebuggerTokenScaner.GetTokenCoord: TdtsTokenCoord;
begin
  Result := FTokenCoord;
end;

function TibSHPSQLDebuggerTokenScaner.GetTokenNumber: Integer;
begin
  Result := FTokenNumber;
end;

function TibSHPSQLDebuggerTokenScaner.GetTokenType: TdtsTokenType;
begin
  Result := FTokenType;
end;

function TibSHPSQLDebuggerTokenScaner.AppendNextLine: Boolean;
begin
  Result := False;
  while FCurrentPoint.Y < Pred(FDDLText.Count) do
  begin
    Inc(FCurrentPoint.Y);
    FCurrentLine := TrimRight(FDDLText[FCurrentPoint.Y]);
    if Length(TrimLeft(FCurrentLine)) > 0 then
    begin
      Result := True;
      FCurrentPoint.X := 0;
      Break;
    end;
  end;
end;

procedure TibSHPSQLDebuggerTokenScaner.Reset;
begin
  FCurrentPoint := Point(0, -1);
  FRange := rUnknown;
  Token := EmptyStr;
  FTokenCoord := TdtsTokenCoord(Rect(0, -1, 0, -1));
  FTokenNumber := 0;
  FTokenType := ttUnknown;
  FCurrentLine := EmptyStr;
end;

function TibSHPSQLDebuggerTokenScaner.Next: Boolean;
  procedure RememberToPoint(var APoint: TPoint);
  begin
    APoint.X := FCurrentPoint.X;
    APoint.Y := FCurrentPoint.Y;
  end;
  procedure SetSymbolResult;
  begin
    Inc(FTokenNumber);
    RememberToPoint(FTokenCoord.TopLeftPoint);
    RememberToPoint(FTokenCoord.BottomRightPoint);
    FTokenType := ttSymbol;
    Token := FCurrentLine[FCurrentPoint.X];
    FRange := rUnknown;
  end;
  procedure CopyToken;
  var
    I: Integer;
    S: string;
  begin
    Inc(FTokenNumber);
    if FTokenCoord.TopLine = FTokenCoord.BottomLine then
    begin
      Token := Copy(FDDLText[FTokenCoord.TopLine],
        FTokenCoord.TopLeftChar, FTokenCoord.BottomRightChar - FTokenCoord.TopLeftChar + 1);
    end
    else
    begin
      for I := FTokenCoord.TopLine to FTokenCoord.BottomLine do
      begin
        if I = FTokenCoord.TopLine then
          S := Copy(FDDLText[I], FTokenCoord.TopLeftChar, Length(FDDLText[I]) - FTokenCoord.TopLeftChar + 1)
        else
        if I = FTokenCoord.BottomLine then
          S := Copy(FDDLText[I], 1, FTokenCoord.BottomRightChar)
        else
          S := FDDLText[I];
        if Length(FToken) = 0 then
          Token := S
        else
          Token := FToken + #13#10 + S;
      end;
    end;
  end;
  function CircleAvalible: Boolean;
  begin
    case FRange of
      rUnknown, rComments, rString, rD3Identifier:
        begin
          Result := FCurrentPoint.X < Length(FCurrentLine);
          if not Result then
            Result := AppendNextLine and (FCurrentPoint.X < Length(FCurrentLine));
        end;
      rStatements, rNumeric:
        begin
          Result := FCurrentPoint.X < Length(FCurrentLine);
          if not Result then
          begin
            RememberToPoint(FTokenCoord.BottomRightPoint);
            FRange := rUnknown;
            CopyToken;
          end;  
        end;
      else
        Result := False;
    end;
  end;
begin
  if (Length(FCurrentLine) = 0) or (FCurrentPoint.X = Length(FCurrentLine)) then
    Result := AppendNextLine
  else
    Result := True;
  if Result then
  begin
    Token := EmptyStr;
    while CircleAvalible do
    begin
      Inc(FCurrentPoint.X);
      case FRange of
        //TdtsRange = (rUnknown, rComments, rString, rStatements, rD3Identifier);
        rUnknown:
          case FCurrentLine[FCurrentPoint.X] of
            '"':
              begin
                FRange := rD3Identifier;
                FTokenType := ttD3Identifier;
                RememberToPoint(FTokenCoord.TopLeftPoint);
              end;
            '''':
              begin
                FRange := rString;
                FTokenType := ttString;
                RememberToPoint(FTokenCoord.TopLeftPoint);
              end;
            '_', 'a'..'z', 'A'..'Z', ':':
              begin
                FRange := rStatements;
                FTokenType := ttIdentifier;
                RememberToPoint(FTokenCoord.TopLeftPoint);
              end;
            '/':
              if (FCurrentPoint.X < Length(FCurrentLine)) and
                (FCurrentLine[FCurrentPoint.X + 1] = '*') then
              begin
                FRange := rComments;
                RememberToPoint(FTokenCoord.TopLeftPoint);
                Inc(FCurrentPoint.X);
              end
              else
              begin
                SetSymbolResult;
                Break;
              end;              
            '-':
              if (FCurrentPoint.X < Length(FCurrentLine)) and
                (FCurrentLine[FCurrentPoint.X + 1] = '-') then
              begin
                FCurrentPoint.X := Length(FCurrentLine);
              end
              else
              begin
                SetSymbolResult;
                Break;
              end;
            '=', '>', '<', '|', '+', '&',
            '^', '%', '*', '!',
            '{', '}', ',','.',';', '?', '(', ')', '[', ']', '~', '#':
              begin
                SetSymbolResult;
                Break;
              end;
            '0', '1'..'9':
              begin
                FRange := rNumeric;
                FTokenType := ttNumeric;
                RememberToPoint(FTokenCoord.TopLeftPoint);
              end;
          end;
        rComments:
          case FCurrentLine[FCurrentPoint.X] of
            '*':
              if (FCurrentPoint.X < Length(FCurrentLine)) and
                (FCurrentLine[FCurrentPoint.X + 1] = '/') then
              begin
                Inc(FCurrentPoint.X);
                RememberToPoint(FTokenCoord.BottomRightPoint);
                FRange := rUnknown;
                //CopyToken;
                //Break;
              end;
          end;
        rString:
          if FCurrentLine[FCurrentPoint.X] = '''' then
          begin
            RememberToPoint(FTokenCoord.BottomRightPoint);
            FRange := rUnknown;
            CopyToken;
            Break;
          end;
        rNumeric:
          if not (FCurrentLine[FCurrentPoint.X] in CorrectNumericChars) then
          begin
            Dec(FCurrentPoint.X);
            RememberToPoint(FTokenCoord.BottomRightPoint);
            FRange := rUnknown;
            CopyToken;
            Break;
          end;
        rStatements:
          if not (FCurrentLine[FCurrentPoint.X] in CorrectIndentifierChars+['.']) then 
          begin
            Dec(FCurrentPoint.X);
            RememberToPoint(FTokenCoord.BottomRightPoint);
            FRange := rUnknown;
            CopyToken;
            Break;
          end;
        rD3Identifier:
          if FCurrentLine[FCurrentPoint.X] = '"' then
          begin
            RememberToPoint(FTokenCoord.BottomRightPoint);
            FRange := rUnknown;
            CopyToken;
            Break;
          end;
      end;
    end;
  end;
end;

procedure TibSHPSQLDebuggerTokenScaner.MoveBack;
begin
  Dec(FTokenNumber);
  FCurrentPoint := TokenBegin;
  Dec(FCurrentPoint.X);
  Token := EmptyStr;
end;

procedure TibSHPSQLDebuggerTokenScaner.SetToken(const Value: string);
begin
  FToken:=Value;
  FUpperToken:=UpperCase(FToken)
end;

end.
