unit ibSHDriver_UIB;

interface

uses
  // Native Modules
  SysUtils, Classes, StrUtils, Types,
  // SQLHammer Modules
  SHDesignIntf, ibSHDesignIntf, ibSHDriverIntf,
  // UIB Modules
  JvUIBSQLParser;

type
  TibBTDriver = class(TSHComponent, IibSHDRV)
  private
    FNativeDAC: TObject;
    FErrorText: string;
    function GetNativeDAC: TObject;
    procedure SetNativeDAC(Value: TObject);
    function GetErrorText: string;
    procedure SetErrorText(Value: string);
  public
    property NativeDAC: TObject read GetNativeDAC write SetNativeDAC;
    property ErrorText: string read GetErrorText write SetErrorText;
  end;

  TibBTDRVSQLParser = class(TibBTDriver, IibSHDRVSQLParser)
  private
    FLexer: TUIBLexer;
    FGrammar: TUIBGrammar;
    FSource: TStringStream;
    FDDLTokenList: TStrings;

    FErrorLine: Integer;
    FErrorColumn: Integer;
    FStatements: TStrings;
    FNameCreatedList: TStrings;
    FNameAlteredList: TStrings;
    FNameDroppedList: TStrings;
    function GetErrorLine: Integer;
    function GetErrorColumn: Integer;
    function GetStatementCount: Integer;
    function GetNameCreatedList: TStrings;
    function GetNameAlteredList: TStrings;
    function GetNameDroppedList: TStrings;

    procedure ExtractNameFromSQLNode(const DDLText: string; ASQLNode: TSQLNode);
    procedure OnGrammarError(Sender: TObject; const Msg: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function GetClassIIDClassFnc: TGUID; override;

    {IibSHDRVSQLParser}
    function GetScript: TStrings;
    function GetCount: Integer;
//    function GetStatements: TStrings;
    function GetStatements(Index: Integer): string;
    function GetTerminator: string;
    procedure SetTerminator(const Value: string);
    function GetSQLParserNotification: IibSHDRVSQLParserNotification;
    procedure SetSQLParserNotification(Value: IibSHDRVSQLParserNotification);
    function Parse(const SQLText: string): Boolean; overload;
    function Parse: Boolean; overload;
    function StatementState(const Index: Integer): TSHDBComponentState;
    function StatementObjectType(const Index: Integer): TGUID;
    function StatementObjectName(const Index: Integer): string;
    function StatementsCoord(Index: Integer): TRect;
    function IsDataSQL(Index: Integer): Boolean;

    property ErrorLine: Integer read GetErrorLine;
    property ErrorColumn: Integer read GetErrorColumn;
//    property Statements: TStrings read GetStatements;
    property StatementCount: Integer read GetStatementCount;
    property NameCreatedList: TStrings read GetNameCreatedList;
    property NameAlteredList: TStrings read GetNameAlteredList;
    property NameDroppedList: TStrings read GetNameDroppedList;
  end;

implementation

const
  DDLTokens: array[0..22] of string = (
    'CREATE', 'DECLARE', 'ALTER', 'RECREATE', 'DROP',
    'DOMAIN', 'TABLE', 'INDEX', 'VIEW', 'PROCEDURE', 'TRIGGER', 'GENERATOR',
    'EXCEPTION', 'FUNCTION', 'FILTER', 'ROLE', 'SHADOW',
    'EXTERNAL', 'UNIQUE', 'ASC', 'ASCENDING', 'DESC', 'DESCENDING');
const
  WD = [' ', #13, #10, #9, '(', '''', ';'];

type
  TCharSet = set of Char;

{ TibBTDriver }

function TibBTDriver.GetNativeDAC: TObject;
begin
  Result := FNativeDAC;
end;

procedure TibBTDriver.SetNativeDAC(Value: TObject);
begin
  FNativeDAC := Value;
end;

function TibBTDriver.GetErrorText: string;
begin
  Result := FErrorText;
end;

procedure TibBTDriver.SetErrorText(Value: string);
  function FormatErrorMessage(const E: string): string;
  begin
    Result := AnsiReplaceText(E, ':' + sLineBreak, '');
    Result := AnsiReplaceText(Result, sLineBreak, '');
  end;
begin
  FErrorText := FormatErrorMessage(Value);
end;

{ TibBTDRVSQLParser }

constructor TibBTDRVSQLParser.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);
  NativeDAC := nil;
  FDDLTokenList := TStringList.Create;
  for I := Low(DDLTokens) to High(DDLTokens) do
    FDDLTokenList.Add(DDLTokens[I]);
  TStringList(FDDLTokenList).CaseSensitive := False;
  TStringList(FDDLTokenList).Sorted := True;

  FStatements := TStringList.Create;
  FNameCreatedList := TStringList.Create;
  FNameAlteredList := TStringList.Create;
  FNameDroppedList := TStringList.Create;
end;

destructor TibBTDRVSQLParser.Destroy;
begin
  FDDLTokenList.Free;
  FStatements.Free;
  FNameCreatedList.Free;
  FNameAlteredList.Free;
  FNameDroppedList.Free;
  NativeDAC := nil;
  if Assigned(FLexer) then FreeAndNil(FLexer);
  if Assigned(FGrammar) then FreeAndNil(FGrammar);
  if Assigned(FSource) then FreeAndNil(FSource);
  inherited Destroy;
end;

class function TibBTDRVSQLParser.GetClassIIDClassFnc: TGUID;
begin
//  Result := IibSHDRVSQLParser_IBX;
  Result := IibSHDRVSQLParser_FIBPlus;
end;

function TibBTDRVSQLParser.GetErrorLine: Integer;
begin
  Result := FErrorLine;
end;

function TibBTDRVSQLParser.GetErrorColumn: Integer;
begin
  Result := FErrorColumn;
end;

function TibBTDRVSQLParser.GetStatementCount: Integer;
begin
  Result := FStatements.Count;
end;

function TibBTDRVSQLParser.GetNameCreatedList: TStrings;
begin
  Result := FNameCreatedList;
end;

function TibBTDRVSQLParser.GetNameAlteredList: TStrings;
begin
  Result := FNameAlteredList;
end;

function TibBTDRVSQLParser.GetNameDroppedList: TStrings;
begin
  Result := FNameDroppedList;
end;

// From FIBPlus unit StrUtil;
function ExtractWord(Num:integer;const Str: string;const  WordDelims: TCharSet):string;
var
  SLen, I: Cardinal;
  wc: Integer;
begin
  Result := '';
  I := 1; wc:=0;
  SLen := Length(Str);
  while I <= SLen do
  begin
    while (I <= SLen) and (Str[I] in WordDelims) do Inc(I);
    if I <= SLen then Inc(wc);
    if wc=Num then Break;
    while (I <= SLen) and not(Str[I] in WordDelims) do Inc(I);
  end;
  if (wc=0) and (Num=1) then Result:=Str
  else
  if wc<>0 then
  begin
     while (I <= SLen) and not (Str[I] in WordDelims) do
     begin
       Result:=Result+Str[I];
       Inc(I);
     end;
  end;
end;

function ExtractLastWord(const Str: string;const  WordDelims:TCharSet):string;
var
  SLen, I: Cardinal;
begin
  Result := '';
  SLen := Length(Str);
  while (Str[SLen] in WordDelims) and (SLen>0) do Dec(SLen);
  for i:= SLen downTo 1 do
  begin
    if not(Str[I] in WordDelims) then
     Result := Str[I]+Result
    else
     Exit
  end;
end;

function WordCount(const S: string; const WordDelims: TCharSet): Integer;
var
  SLen, I: Cardinal;
begin
  Result := 0;
  I := 1;
  SLen := Length(S);
  while I <= SLen do
  begin
    while (I <= SLen) and (S[I] in WordDelims) do Inc(I);
    if I <= SLen then Inc(Result);
    while (I <= SLen) and not(S[I] in WordDelims) do Inc(I);
  end;
end;

procedure TibBTDRVSQLParser.ExtractNameFromSQLNode(const DDLText: string; ASQLNode: TSQLNode);
var
  S, Word: string;
  I: Integer;
begin
  S := DDLText;
  S := AnsiReplaceText(S, '/*', ' /*');
  while Pos('/*', S) > 0 do Delete(S, Pos('/*', S), Pos('*/', S) - Pos('/*', S) + 2);

  for I := 1 to WordCount(S, WD) do
  begin
    Word := ExtractWord(I, S, WD);
    if Pos('"', Word) > 0 then Word := Copy(S, Pos('"', S) + 1, PosEx('"', S, Pos('"', S) + 1) - Pos('"', S) - 1);
    if (Length(Word) > 0) and (FDDLTokenList.IndexOf(Word) = -1) then
    begin
      S := Word;
      Break;
    end;
  end;

  case ASQLNode.NodeType of
    NodeAlterTable: FNameAlteredList.Add(Format('%s=%s', [GUIDToString(IibSHTable), S]));
    NodeAlterTrigger: FNameAlteredList.Add(Format('%s=%s', [GUIDToString(IibSHTrigger), S]));
    NodeAlterProcedure: FNameAlteredList.Add(Format('%s=%s', [GUIDToString(IibSHProcedure), S]));
    NodeAlterDomain: FNameAlteredList.Add(Format('%s=%s', [GUIDToString(IibSHDomain), S]));
    NodeAlterIndex: FNameAlteredList.Add(Format('%s=%s', [GUIDToString(IibSHIndex), S]));

    NodeCreateException: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHException), S]));
    NodeCreateIndex: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHIndex), S]));
    NodeCreateProcedure: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHProcedure), S]));
    NodeCreateTable: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHTable), S]));
    NodeCreateTrigger: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHTrigger), S]));
    NodeCreateView: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHView), S]));
    NodeCreateGenerator: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHGenerator), S]));
    NodeCreateDomain: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHDomain), S]));
    NodeCreateShadow: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHShadow), S]));
    NodeCreateRole: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHRole), S]));
    NodeDeclareFilter: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHFilter), S]));
    NodeDeclareFunction: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHFunction), S]));

    NodeDropException: FNameDroppedList.Add(Format('%s=%s', [GUIDToString(IibSHException), S]));
    NodeDropIndex: FNameDroppedList.Add(Format('%s=%s', [GUIDToString(IibSHIndex), S]));
    NodeDropProcedure: FNameDroppedList.Add(Format('%s=%s', [GUIDToString(IibSHProcedure), S]));
    NodeDropTable: FNameDroppedList.Add(Format('%s=%s', [GUIDToString(IibSHTable), S]));
    NodeDropTrigger: FNameDroppedList.Add(Format('%s=%s', [GUIDToString(IibSHTrigger), S]));
    NodeDropView: FNameDroppedList.Add(Format('%s=%s', [GUIDToString(IibSHView), S]));
    NodeDropFilter: FNameDroppedList.Add(Format('%s=%s', [GUIDToString(IibSHFilter), S]));
    NodeDropDomain: FNameDroppedList.Add(Format('%s=%s', [GUIDToString(IibSHDomain), S]));
    NodeDropExternal: FNameDroppedList.Add(Format('%s=%s', [GUIDToString(IibSHFunction), S]));
    NodeDropShadow: FNameDroppedList.Add(Format('%s=%s', [GUIDToString(IibSHShadow), S]));
    NodeDropRole: FNameDroppedList.Add(Format('%s=%s', [GUIDToString(IibSHRole), S]));
    NodeDropGenerator: FNameDroppedList.Add(Format('%s=%s', [GUIDToString(IibSHGenerator), S]));

    NodeRecreateProcedure: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHProcedure), S]));
    NodeRecreateTable: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHTable), S]));
    NodeRecreateView: FNameCreatedList.Add(Format('%s=%s', [GUIDToString(IibSHView), S]));
  end;
end;

procedure TibBTDRVSQLParser.OnGrammarError(Sender: TObject; const Msg: string);
begin
//
end;

function TibBTDRVSQLParser.GetScript: TStrings;
begin
  Result := nil;
end;

function TibBTDRVSQLParser.GetCount: Integer;
begin
  Result := 0;
end;

function TibBTDRVSQLParser.GetStatements(Index: Integer): string;
begin
//  Result := FStatements;
end;

function TibBTDRVSQLParser.GetTerminator: string;
begin
  Result := ';';//Затычка
end;

procedure TibBTDRVSQLParser.SetTerminator(const Value: string);
begin
//Затычка
end;

function TibBTDRVSQLParser.GetSQLParserNotification: IibSHDRVSQLParserNotification;
begin
//
end;

procedure TibBTDRVSQLParser.SetSQLParserNotification(
  Value: IibSHDRVSQLParserNotification);
begin
//
end;

function TibBTDRVSQLParser.Parse(const SQLText: string): Boolean;
var
  I: Integer;
  PosFrom, PosTo: TPosition;
begin
  ErrorText := EmptyStr;
  FErrorLine := -1;
  FErrorColumn := -1;
  FStatements.Clear;

  FNameCreatedList.Clear;
  FNameAlteredList.Clear;
  FNameDroppedList.Clear;

  if Assigned(FLexer) then FreeAndNil(FLexer);
  if Assigned(FGrammar) then FreeAndNil(FGrammar);
  if Assigned(FSource) then FreeAndNil(FSource);

  FSource := TStringStream.Create(SQLText);
  FLexer := TUIBLexer.Create(FSource);
  FGrammar := TUIBGrammar.Create(FLexer);
  FGrammar.OnMessage := OnGrammarError;

  if FGrammar.yyparse = 0 then
  begin
    if Assigned(FGrammar.RootNode) then
      for I := 0 to Pred(FGrammar.RootNode.NodesCount) do
      begin
        PosFrom := FGrammar.RootNode.Nodes[I].PosFrom;
        PosTo := FGrammar.RootNode.Nodes[I].PosTo;
        FSource.Seek(PosFrom.Pos, soFromBeginning);
        if Length(FGrammar.RootNode.Nodes[I].Value) = 0 then
        begin
          FStatements.Add(Trim(FSource.ReadString(PosTo.Pos - PosFrom.Pos)));
          ExtractNameFromSQLNode(FStatements[Pred(FStatements.Count)], FGrammar.RootNode.Nodes[I]);
        end;
      end;
  end else
  begin
    FErrorLine := FLexer.yylineno;
    FErrorColumn := FLexer.yycolno;
    ErrorText := Format('Parsing error: line %d, column %d', [FErrorLine, FErrorColumn]);
  end;

  Result := Length(ErrorText) = 0;
end;

function TibBTDRVSQLParser.Parse: Boolean;
begin
  Result := False;
end;

function TibBTDRVSQLParser.StatementState(const Index: Integer): TSHDBComponentState;
begin
  Result := csUnknown;
end;

function TibBTDRVSQLParser.StatementObjectType(const Index: Integer): TGUID;
begin
  Result := IUnknown;
end;

function TibBTDRVSQLParser.StatementObjectName(const Index: Integer): string;
begin
  Result := EmptyStr;
end;

function TibBTDRVSQLParser.StatementsCoord(Index: Integer): TRect;
begin
//
end;

function TibBTDRVSQLParser.IsDataSQL(Index: Integer): Boolean;
begin
  Result := True;
end;


initialization

//  BTRegisterComponents([TibBTDRVSQLParser]);

end.
