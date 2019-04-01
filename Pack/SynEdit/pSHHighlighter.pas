unit pSHHighlighter;

{$I SynEdit.inc}

interface

uses
{$IFDEF SYN_CLX}
  Types,
  QGraphics,
  QSynEditTypes,
  QSynEditHighlighter,
  QSynHighlighterHashEntries,
{$ELSE}
  Graphics,
  Registry,
  SynEditTypes,
  SynEditHighlighter,
  SynHighlighterHashEntries,
{$ENDIF}
  SysUtils,
  Classes,
  pSHIntf;

const

  SYNS_AttrWrongSymbol = 'Wrong Symbol';                                        //pavel

type

  PIdentifierTable = ^TIdentifierTable;
  TIdentifierTable = array[Char] of ByteBool;

  PHashTable = ^THashTable;
  THashTable = array[Char] of Integer;


type
  TpSHHighlighter = class(TSynCustomHighlighter)
  private
    fRange: TRangeState;
    fLine: PChar;
    fLineNumber: Integer;
    fProcTable: array[#0..#255] of TProcTableProc;
    Run: LongInt;
    fStringLen: Integer;
    fToIdent: PChar;
    fTokenPos: Integer;
    fTokenID: TtkTokenKind;
    fKeywords: TSynHashEntryList;
    fDialect: TSQLDialect;
    fSubDialect: TSQLSubDialect;
    fCommentAttri: TSynHighlighterAttributes;
    fDataTypeAttri: TSynHighlighterAttributes;
    fDefaultPackageAttri: TSynHighlighterAttributes;                            // DJLP 2000-08-11
    fExceptionAttri: TSynHighlighterAttributes;
    fFunctionAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fPLSQLAttri: TSynHighlighterAttributes;                                     // DJLP 2000-08-11
    fSpaceAttri: TSynHighlighterAttributes;
    fSQLPlusAttri: TSynHighlighterAttributes;                                   // DJLP 2000-09-05
    fStringAttri: TSynHighlighterAttributes;
    fSymbolAttri: TSynHighlighterAttributes;
    fTableNameAttri: TSynHighlighterAttributes;
    fVariableAttri: TSynHighlighterAttributes;
    fWrongSymbolAttri: TSynHighlighterAttributes;                               //pavel
    fIdentifiersPtr: PIdentifierTable;
    fmHashTablePtr: PHashTable;
    FObjectNamesManager: IpSHObjectNamesManager;
    FKeywordsManager: IpSHKeywordsManager;
    fCustomStringsAttri: TSynHighlighterAttributes;                                  //pavel
    function KeyHash(ToHash: PChar): Integer;
    function KeyComp(const aKey: string): Boolean;
    procedure AndSymbolProc;
    procedure AsciiCharProc;
    procedure CRProc;
    procedure EqualProc;
    procedure GreaterProc;
    procedure IdentProc;
    procedure LFProc;
    procedure LowerProc;
    procedure MinusProc;
    procedure NullProc;
    procedure NumberProc;
    procedure OrSymbolProc;
    procedure PlusProc;
    procedure SlashProc;
    procedure SpaceProc;
    procedure StringProc;
    procedure SymbolProc;
    procedure SymbolAssignProc;
    procedure VariableProc;
    procedure UnknownProc;
    procedure AnsiCProc;
    function IdentKind(MayBe: PChar): TtkTokenKind;
    procedure MakeMethodTables;
    procedure DoAddKeyword(AKeyword: string; AKind: integer);
    procedure EnumerateKeywordsInternal(AKind: integer; KeywordList: string);
    procedure SetDialect(Value: TSQLDialect);
    procedure InitializeKeywordLists;
    procedure SetSubDialect(const Value: TSQLSubDialect);
    procedure SetKeywordsManager(const Value: IpSHKeywordsManager);
  protected
    function GetIdentChars: TSynIdentChars; override;
    function GetSampleSource : String; override;
  public
    {$IFNDEF SYN_CPPB_1} class {$ENDIF}
    function GetLanguageName: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes;
      override;
    function GetEol: Boolean; override;
    function GetRange: Pointer; override;
    function GetToken: string; override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenID: TtkTokenKind;
    function GetTokenKind: integer; override;
    function GetTokenPos: Integer; override;
    procedure Next; override;
    procedure ResetRange; override;
    procedure SetLine(NewValue: string; LineNumber: Integer); override;
    procedure SetRange(Value: Pointer); override;
    property ObjectNamesManager: IpSHObjectNamesManager
      read FObjectNamesManager write FObjectNamesManager;
    property KeywordsManager: IpSHKeywordsManager read FKeywordsManager
      write SetKeywordsManager;
  published
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri
      write fCommentAttri;
    property CustomStringsAttri: TSynHighlighterAttributes read fCustomStringsAttri
      write fCustomStringsAttri;
    property DataTypeAttri: TSynHighlighterAttributes read fDataTypeAttri
      write fDataTypeAttri;
    property DefaultPackageAttri: TSynHighlighterAttributes                     // DJLP 2000-08-11
      read fDefaultPackageAttri write fDefaultPackageAttri;
    property ExceptionAttri: TSynHighlighterAttributes read fExceptionAttri
      write fExceptionAttri;
    property FunctionAttri: TSynHighlighterAttributes read fFunctionAttri
      write fFunctionAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri
      write fIdentifierAttri;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri
      write fNumberAttri;
    property PLSQLAttri: TSynHighlighterAttributes read fPLSQLAttri             // DJLP 2000-08-11
      write fPLSQLAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri
      write fSpaceAttri;
    property SQLPlusAttri: TSynHighlighterAttributes read fSQLPlusAttri         // DJLP 2000-09-05
      write fSQLPlusAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri
      write fStringAttri;
    property SymbolAttri: TSynHighlighterAttributes read fSymbolAttri
      write fSymbolAttri;
    property TableNameAttri: TSynHighlighterAttributes read fTableNameAttri
      write fTableNameAttri;
    property WrongSymbolAttri: TSynHighlighterAttributes read fWrongSymbolAttri //pavel
      write fWrongSymbolAttri;                                                  //pavel
    property VariableAttri: TSynHighlighterAttributes read fVariableAttri
      write fVariableAttri;
    property SQLDialect: TSQLDialect read fDialect write SetDialect;
    property SQLSubDialect: TSQLSubDialect read fSubDialect write SetSubDialect;
  end;

implementation

uses
{$IFDEF SYN_CLX}
  QSynEditStrConst;
{$ELSE}
  SynEditStrConst;
{$ENDIF}

var
  Identifiers: TIdentifierTable;
  mHashTable: THashTable;

  IdentifiersMSSQL7: TIdentifierTable;
  mHashTableMSSQL7: THashTable;

procedure MakeIdentTable;
var
  c: char;
begin
  FillChar(Identifiers, SizeOf(Identifiers), 0);
  for c := 'a' to 'z' do
    Identifiers[c] := TRUE;
  for c := 'A' to 'Z' do
    Identifiers[c] := TRUE;
  for c := '0' to '9' do
    Identifiers[c] := TRUE;
  Identifiers['_'] := TRUE;
//  Identifiers['#'] := TRUE;  //Pavel - для интербэйса это не так, правка в KeyHash   // DJLP 2000-09-05
  Identifiers['$'] := TRUE;                                                     // DJLP 2000-09-05

  FillChar(mHashTable, SizeOf(mHashTable), 0);
  mHashTable['_'] := 1;
  for c := 'a' to 'z' do
    mHashTable[c] := 2 + Ord(c) - Ord('a');
  for c := 'A' to 'Z' do
    mHashTable[c] := 2 + Ord(c) - Ord('A');

  Move(Identifiers, IdentifiersMSSQL7, SizeOf(Identifiers));
  Move(mHashTable, mHashTableMSSQL7, SizeOf(mHashTable));
  IdentifiersMSSQL7['@'] := TRUE;
  mHashTableMSSQL7['@'] := mHashTableMSSQL7['Z'] + 1;
end;

function TpSHHighlighter.KeyHash(ToHash: PChar): Integer;
begin
  Result := 0;
  while fIdentifiersPtr[ToHash^] or ((SQLDialect <> sqlInterbase) and (ToHash^ = '#')) do   begin
//  эта правка была уместна, когда использовалось свойство TableNames
//    or ((SQLDialect = sqlInterbase6) and (ToHash^ = ' ') and                  //pavel
//      (fTokenID = tkString))) do                                              //pavel
{$IFOPT Q-}
    Result := 2 * Result + fmHashTablePtr[ToHash^];
{$ELSE}
    Result := (2 * Result + fmHashTablePtr[ToHash^]) and $FFFFFF;
{$ENDIF}
    inc(ToHash);
  end;
  Result := Result and $FF; // 255
  fStringLen := ToHash - fToIdent;
end;

function TpSHHighlighter.KeyComp(const aKey: string): Boolean;
var
  i: integer;
  pKey1, pKey2: PChar;
begin
  pKey1 := fToIdent;
  // Note: fStringLen is always > 0 !
  pKey2 := pointer(aKey);
  for i := 1 to fStringLen do
  begin
//    if mHashTable[pKey1^] <> mHashTable[pKey2^] then
    if fmHashTablePtr[pKey1^] <> fmHashTablePtr[pKey2^] then                            //pavel - непонятка, однако
    begin
      Result := FALSE;
      exit;
    end;
    Inc(pKey1);
    Inc(pKey2);
  end;
  Result := TRUE;
end;

procedure TpSHHighlighter.AndSymbolProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if fLine[Run] in ['=', '&'] then Inc(Run);
end;

procedure TpSHHighlighter.AsciiCharProc;
begin
  // Oracle SQL allows strings to go over multiple lines
  if fLine[Run] = #0 then
    NullProc
  else begin
    fTokenID := tkString;
    // else it's end of multiline string
    if SQLDialect <> sqlMySql then begin
      if (Run > 0) or (fRange <> rsString) or (fLine[Run] <> #39) then begin
        fRange := rsString;
        repeat
          Inc(Run);
        until fLine[Run] in [#0, #10, #13, #39];
      end;
      if fLine[Run] = #39 then begin
        Inc(Run);
        fRange := rsUnknown;
      end;
    end
    else begin
      if (Run > 0) or (fRange <> rsString) or ((fLine[Run] <> #39) and (fLine[Run-1] <> '\')) then begin
        fRange := rsString;
        repeat
          if (fLine[Run] <> '\') and (fLine[Run+1] = #39) then begin
            Inc(Run);
            break;
          end;
          Inc(Run);
        until fLine[Run] in [#0, #10, #13];
      end;
      if (fLine[Run] = #39) and not(fLine[Run-1] = '\') then begin
        Inc(Run);
        fRange := rsUnknown;
      end;
    end;
  end;
end;

procedure TpSHHighlighter.CRProc;
begin
  fTokenID := tkSpace;
  Inc(Run);
  if fLine[Run] = #10 then Inc(Run);
end;

procedure TpSHHighlighter.EqualProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if fLine[Run] in ['=', '>'] then Inc(Run);
end;

procedure TpSHHighlighter.GreaterProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if fLine[Run] in ['=', '>'] then Inc(Run);
end;

procedure TpSHHighlighter.IdentProc;
begin
  fTokenID := IdentKind((fLine + Run));
  if (Run > 0) and ((fLine + Run - 1)^ = '.' ) then
    fTokenID := tkIdentifier;  
  inc(Run, fStringLen);

{begin}                                                                         // DJLP 2000-08-11
{
//  какое-то явное даунение тов. DJLP                                           //pavel
  if fTokenID = tkComment then begin
    while not (fLine[Run] in [#0, #10, #13]) do
      Inc(Run);
  end else
}
{end}                                                                           // DJLP 2000-08-11
    while fIdentifiersPtr[fLine[Run]] do inc(Run);
end;

procedure TpSHHighlighter.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end;

procedure TpSHHighlighter.LowerProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  case fLine[Run] of
    '=': Inc(Run);
    '<': begin
           Inc(Run);
           if fLine[Run] = '=' then Inc(Run);
         end;
  end;
end;

procedure TpSHHighlighter.MinusProc;
begin
  Inc(Run);
  if fLine[Run] = '-' then begin
    fTokenID := tkComment;
    repeat
      Inc(Run);
    until fLine[Run] in [#0, #10, #13];
  end else
    fTokenID := tkSymbol;
end;

procedure TpSHHighlighter.NullProc;
begin
  fTokenID := tkNull;
end;

procedure TpSHHighlighter.NumberProc;
begin
  inc(Run);
  fTokenID := tkNumber;
  while FLine[Run] in ['0'..'9', '.', '-'] do begin
    case FLine[Run] of
      '.':
        if FLine[Run + 1] = '.' then break;
    end;
    inc(Run);
  end;
end;

procedure TpSHHighlighter.OrSymbolProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if fLine[Run] in ['=', '|'] then Inc(Run);
end;

procedure TpSHHighlighter.PlusProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if fLine[Run] in ['=', '+'] then Inc(Run);
end;

procedure TpSHHighlighter.SlashProc;
begin
  Inc(Run);
  case fLine[Run] of
    '*':
      begin
        fRange := rsComment;
        fTokenID := tkComment;
        repeat
          Inc(Run);
          if (fLine[Run] = '*') and (fLine[Run + 1] = '/') then begin
            fRange := rsUnknown;
            Inc(Run, 2);
            break;
          end;
        until fLine[Run] in [#0, #10, #13];
      end;
    '=':
      begin
        Inc(Run);
        fTokenID := tkSymbol;
      end;
    else
      fTokenID := tkSymbol;
  end;
end;

procedure TpSHHighlighter.SpaceProc;
begin
  fTokenID := tkSpace;
  repeat
    Inc(Run);
  until (fLine[Run] > #32) or (fLine[Run] in [#0, #10, #13]);
end;

procedure TpSHHighlighter.StringProc;
begin
  fTokenID := tkString;
  Inc(Run);
  while not (fLine[Run] in [#0, #10, #13]) do begin
    case fLine[Run] of
      '\': if fLine[Run + 1] = #34 then
             Inc(Run);
      #34: if fLine[Run + 1] <> #34 then
           begin
             Inc(Run);
             break;
           end;
    end;
    Inc(Run);
  end;
  if (SQLDialect = sqlInterbase) and (SQLSubDialect >= ibdInterBase6) then
    if Assigned(FObjectNamesManager) then
      FObjectNamesManager.LinkSearchNotify(self, fLine + fTokenPos,
        fTokenPos, Run - fTokenPos, fTokenID);
end;

procedure TpSHHighlighter.SymbolProc;
begin
  Inc(Run);
  fTokenID := tkSymbol;
end;

procedure TpSHHighlighter.SymbolAssignProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if fLine[Run] = '=' then Inc(Run);
end;

procedure TpSHHighlighter.VariableProc;
var
  i: integer;
begin
  // MS SQL 7 uses @@ to indicate system functions/variables
  if (SQLDialect = sqlMSSQL) and (fLine[Run] = '@') and (fLine[Run + 1] = '@')
  then
    IdentProc
{begin}                                                                         //JDR 2000-25-2000
  else if (SQLDialect in [sqlMySql, sqlOracle, sqlInterbase]) and (fLine[Run] = '@') then //pavel
    SymbolProc
{end}                                                                           //JDR 2000-25-2000
  // Oracle uses the ':' character to indicate bind variables
{begin}                                                                         //JJV 2000-11-16
  // Ingres II also uses the ':' character to indicate variables
  // Interbase also uses the ':' character to indicate variables in SP          //pavel
  else
    if not (SQLDialect in [sqlOracle, sqlIngres, sqlInterbase]) and             //pavel
       (fLine[Run] = ':') then                                                  //pavel
{end}                                                                           //JJV 2000-11-16
    SymbolProc
  else begin
    fTokenID := tkVariable;
    i := Run;
    repeat
      Inc(i);
    until not (fIdentifiersPtr[fLine[i]]);
    Run := i;
  end;
end;

procedure TpSHHighlighter.UnknownProc;
begin
  if (SQLDialect = sqlMySql) and (fLine[Run] = '#') and (Run = 0) then          //DDH Changes from Tonci Grgin for MYSQL
  begin
    fTokenID := tkComment;
    fRange := rsComment;
  end else begin
  {$IFDEF SYN_MBCSSUPPORT}
    if FLine[Run] in LeadBytes then
      Inc(Run,2)
    else
  {$ENDIF}
    inc(Run);
    fTokenID := tkUnknown;
  end;
end;

procedure TpSHHighlighter.AnsiCProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
    else begin
      fTokenID := tkComment;
      if (SQLDialect = sqlMySql) and (fLine[Run] = '#') then begin              //DDH Changes from Tonci Grgin for MYSQL
        repeat
          Inc(Run);
        until fLine[Run] in [#0, #10, #13];
        fRange := rsUnknown;
      end
      else begin

        repeat
          if (fLine[Run] = '*') and (fLine[Run + 1] = '/') then begin
            fRange := rsUnknown;
            Inc(Run, 2);
            break;
          end;
          Inc(Run);
        until fLine[Run] in [#0, #10, #13];
      end;
    end;
  end;
end;

function TpSHHighlighter.IdentKind(MayBe: PChar): TtkTokenKind;
var
  Entry: TSynHashEntry;
begin
  fToIdent := MayBe;
  Entry := fKeywords[KeyHash(MayBe)];
  while Assigned(Entry) do begin
    if Entry.KeywordLen > fStringLen then
      break
    else if Entry.KeywordLen = fStringLen then
      if KeyComp(Entry.Keyword) then begin
        Result := TtkTokenKind(Entry.Kind);
        exit;
      end;
    Entry := Entry.Next;
  end;
  Result := tkIdentifier;                                                       //pavel
  if Assigned(FObjectNamesManager) then                                         //pavel
    FObjectNamesManager.LinkSearchNotify(self, MayBe, Run,                      //pavel
      fStringLen, Result);                                                      //pavel
//  Result := tkIdentifier;                                                     //pavel
end;

procedure TpSHHighlighter.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
       #0: fProcTable[I] := NullProc;
      #10: fProcTable[I] := LFProc;
      #13: fProcTable[I] := CRProc;
      #39: fProcTable[I] := AsciiCharProc;
      '=': fProcTable[I] := EqualProc;
      '>': fProcTable[I] := GreaterProc;
      '<': fProcTable[I] := LowerProc;
      '-': fProcTable[I] := MinusProc;
      '|': fProcTable[I] := OrSymbolProc;
      '+': fProcTable[I] := PlusProc;
      '/': fProcTable[I] := SlashProc;
      '&': fProcTable[I] := AndSymbolProc;
      #34: fProcTable[I] := StringProc;
      ':', '@':
        fProcTable[I] := VariableProc;
      'A'..'Z', 'a'..'z', '_':
        fProcTable[I] := IdentProc;
      '0'..'9':
        fProcTable[I] := NumberProc;
      #1..#9, #11, #12, #14..#32:
        fProcTable[I] := SpaceProc;
      '^', '%', '*', '!':
        fProcTable[I] := SymbolAssignProc;
      '{', '}', ',','.',';', '?', '(', ')', '[', ']', '~', '#':
        fProcTable[I] := SymbolProc;
      else
        fProcTable[I] := UnknownProc;
    end;
end;

procedure TpSHHighlighter.DoAddKeyword(AKeyword: string; AKind: integer);
var
  HashValue: integer;
begin
  HashValue := KeyHash(PChar(AKeyword));
  fKeywords[HashValue] := TSynHashEntry.Create(AKeyword, AKind);
end;

procedure TpSHHighlighter.EnumerateKeywordsInternal(AKind: integer;
  KeywordList: string);
begin
  EnumerateKeywords(AKind, KeywordList, IdentChars + [' '], DoAddKeyword);
end;

procedure TpSHHighlighter.SetDialect(Value: TSQLDialect);
begin
  if (Value <> fDialect) then
  begin
    fDialect := Value;
    InitializeKeywordLists;
  end;
end;

procedure TpSHHighlighter.InitializeKeywordLists;
begin
  fKeywords.Clear;
  if (fDialect in [sqlMSSQL, sqlMSSQL2K]) then
  begin
    fIdentifiersPtr := @IdentifiersMSSQL7;
    fmHashTablePtr := @mHashTableMSSQL7;
  end else begin
    fIdentifiersPtr := @Identifiers;
    fmHashTablePtr := @mHashTable;
  end;
  if KeywordsManager <> nil then
  begin
    KeywordsManager.InitializeKeywordLists(Self, SQLSubDialect,
      EnumerateKeywordsInternal);
  end;
  DefHighlightChange(Self);
end;

procedure TpSHHighlighter.SetSubDialect(const Value: TSQLSubDialect);
begin
  if (Value <> fSubDialect) then
  begin
    fSubDialect := Value;
    InitializeKeywordLists;
  end;
end;

procedure TpSHHighlighter.SetKeywordsManager(
  const Value: IpSHKeywordsManager);
begin
  if (FKeywordsManager <> Value) then
  begin
    if Assigned(FKeywordsManager) then
      FKeywordsManager.RemoveHighlighter(Self);
    FKeywordsManager := Value;
    if Assigned(FKeywordsManager) then
      FKeywordsManager.AddHighlighter(Self);    
    InitializeKeywordLists;
  end;
end;

function TpSHHighlighter.GetIdentChars: TSynIdentChars;
begin
  Result := TSynValidStringChars;
  if (fDialect = sqlMSSQL) or (fDialect = sqlMSSQL2K) then
    Include(Result, '@')
{begin}                                                                         // DJLP 2000-08-11
  else if fDialect = sqlOracle then begin
    Include(Result, '#');
    Include(Result, '$');
  end
  else if fDialect = sqlInterbase then begin                                    //pavel
    Include(Result, '$');
  end;
{end}                                                                           // DJLP 2000-08-11
end;

function TpSHHighlighter.GetSampleSource: String;
begin
  Result:= '';
  case fDialect of
    sqlStandard:
      Result := '-- ansi sql sample source'#13#10 +
        'select name , region'#13#10 +
        'from cia'#13#10 +
        'where area < 2000'#13#10 +
        'and gdp > 5000000000';
    sqlInterbase:
      Result := '/* Interbase sample source */'#13#10 +
        'SET TERM !! ;'#13#10 +
        #13#10 +
        'CREATE PROCEDURE HelloWorld(P_MSG VARCHAR(80)) AS'#13#10 +
        'BEGIN'#13#10 +
        '  EXECUTE PROCEDURE WRITELN(:P_MSG);'#13#10 +
        'END !!'#13#10 +
        #13#10 +
        'SET TERM ; !!';
    sqlMySQL:
      Result := '/* MySQL sample source*/'#13#10 +
        'SET @variable= { 1 }'#13#10 +
        #13#10 +
        'CREATE TABLE sample ('#13#10 +
        '        id INT NOT NULL,'#13#10 +
        '        first_name CHAR(30) NOT NULL,'#13#10 +
        '        PRIMARY KEY (id),'#13#10 +
        '        INDEX name (first_name));'#13#10 +
        #13#10 +
        'SELECT DATE_ADD("1997-12-31 23:59:59",'#13#10 +
        '        INTERVAL 1 SECOND);'#13#10 +
        #13#10 +
        '# End of sample';
    sqlOracle:
      Result := 'PROMPT Oracle sample source'#13#10 +
        'declare'#13#10 +
        '  x varchar2(2000);'#13#10 +
        'begin   -- Show some text here'#13#10 +
        '  select to_char(count(*)) into x'#13#10 +
        '  from tab;'#13#10 +
        #13#10 +
        '  dbms_output.put_line(''Hello World: '' || x);'#13#10 +
        'exception'#13#10 +
        '  when others then'#13#10 +
        '    null;'#13#10 +
        'end;';
    sqlSybase:
      Result := '/* SyBase example source */'#13#10 +
        'declare @Integer        int'#13#10 +
        #13#10 +
        '/* Good for positive numbers only. */'#13#10 +
        'select @Integer = 1000'#13#10 +
        #13#10 +
        'select "Positives Only" ='#13#10 +
        '  right(replicate("0",12) + '#13#10 +
        '    convert(varchar, @Integer),12)'#13#10 +
        #13#10 +
        '/* Good for positive and negative numbers. */'#13#10 +
        'select @Integer = -1000'#13#10 +
        #13#10 +
        'select "Both Signs" ='#13#10 +
        '  substring( "- +", (sign(@Integer) + 2), 1) +'#13#10 +
        '  right(replicate("0",12) + '#13#10 +
        '    convert(varchar, abs(@Integer)),12)'#13#10 +
        #13#10 +
        'select @Integer = 1000'#13#10 +
        #13#10 +
        'select "Both Signs" ='#13#10 +
        '  substring( "- +", (sign(@Integer) + 2), 1) +'#13#10 +
        '  right(replicate("0",12) + '#13#10 +
        '    convert(varchar, abs(@Integer)),12)'#13#10 +
        #13#10 +
        'go';
    sqlIngres:
      Result := '/* Ingres example source */'#13#10 +
        'DELETE'#13#10 +
        'FROM t1'#13#10 +
        'WHERE EXISTS'#13#10 +
        '(SELECT t2.column1, t2.column2'#13#10 +
        'FROM t2'#13#10 +
        'WHERE t1.column1 = t2.column1 and'#13#10 +
        't1.column2 = t2.column2)';
    sqlMSSQL:
      Result := '/* SQL Server 7 example source */'#13#10 +
        'SET QUOTED_IDENTIFIER OFF'#13#10 +
        'GO'#13#10 +
        'SET ANSI_NULLS OFF'#13#10 +
        'GO'#13#10 +
        #13#10 +
        '/* Object:  Stored Procedure dbo.sp_PPQInsertOrder */'#13#10 +
        'CREATE PROCEDURE sp_PPQInsertOrder'#13#10 +
        '  @Name    varchar(25),'#13#10 +
        '  @Address varchar(255),'#13#10 +
        '  @ZipCode varchar(15)'#13#10 +
        'As'#13#10 +
        '  INSERT INTO PPQOrders(Name, Address, ZipCode, OrderDate)'#13#10 +
        '  VALUES (@Name, @Address, @ZipCode, GetDate())'#13#10 +
        #13#10 +
        '  SELECT SCOPE_IDENTITY()'#13#10 +
        'GO';
    sqlMSSQL2K:
      Result := '/* SQL Server2000 example source */'#13#10 +
        'SET QUOTED_IDENTIFIER OFF'#13#10 +
        'GO'#13#10 +
        'SET ANSI_NULLS OFF'#13#10 +
        'GO'#13#10 +
        #13#10 +
        '/* Object:  Stored Procedure dbo.sp_PPQInsertOrder */'#13#10 +
        'CREATE PROCEDURE sp_PPQInsertOrder'#13#10 +
        '  @Name    varchar(25),'#13#10 +
        '  @Address varchar(255),'#13#10 +
        '  @ZipCode varchar(15)'#13#10 +
        'As'#13#10 +
        '  INSERT INTO PPQOrders(Name, Address, ZipCode, OrderDate)'#13#10 +
        '  VALUES (@Name, @Address, @ZipCode, GetDate())'#13#10 +
        #13#10 +
        '  SELECT SCOPE_IDENTITY()'#13#10 +
        'GO';
  end;
end;

{$IFNDEF SYN_CPPB_1} class {$ENDIF}
function TpSHHighlighter.GetLanguageName: string;
begin
  Result := SYNS_LangSQL;
end;

constructor TpSHHighlighter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fKeywords := TSynHashEntryList.Create;
  fCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrComment);
  fCommentAttri.Style := [fsItalic];
  AddAttribute(fCommentAttri);
  fCustomStringsAttri := TSynHighlighterAttributes.Create(SYNS_AttrDataType);
  fCustomStringsAttri.Style := [fsBold];

  fDataTypeAttri := TSynHighlighterAttributes.Create(SYNS_AttrDataType);
  fDataTypeAttri.Style := [fsBold];
  AddAttribute(fDataTypeAttri);
{begin}                                                                         // DJLP 2000-08-11
  fDefaultPackageAttri :=
    TSynHighlighterAttributes.Create(SYNS_AttrDefaultPackage);
  fDefaultPackageAttri.Style := [fsBold];
  AddAttribute(fDefaultPackageAttri);
{end}                                                                           // DJLP 2000-08-11
  fExceptionAttri := TSynHighlighterAttributes.Create(SYNS_AttrException);
  fExceptionAttri.Style := [fsItalic];
  AddAttribute(fExceptionAttri);
  fFunctionAttri := TSynHighlighterAttributes.Create(SYNS_AttrFunction);
  fFunctionAttri.Style := [fsBold];
  AddAttribute(fFunctionAttri);
  fIdentifierAttri := TSynHighlighterAttributes.Create(SYNS_AttrIdentifier);
  AddAttribute(fIdentifierAttri);
  fKeyAttri := TSynHighlighterAttributes.Create(SYNS_AttrReservedWord);
  fKeyAttri.Style := [fsBold];
  AddAttribute(fKeyAttri);
  fNumberAttri := TSynHighlighterAttributes.Create(SYNS_AttrNumber);
  AddAttribute(fNumberAttri);
{begin}                                                                         // DJLP 2000-08-11
  fPLSQLAttri := TSynHighlighterAttributes.Create(SYNS_AttrPLSQL);
  fPLSQLAttri.Style := [fsBold];
  AddAttribute(fPLSQLAttri);
{end}                                                                           // DJLP 2000-08-11
  fSpaceAttri := TSynHighlighterAttributes.Create(SYNS_AttrSpace);
  AddAttribute(fSpaceAttri);
{begin}                                                                         // DJLP 2000-09-05
  fSQLPlusAttri:=TSynHighlighterAttributes.Create(SYNS_AttrSQLPlus);
  fSQLPlusAttri.Style := [fsBold];
  AddAttribute(fSQLPlusAttri);
{end}                                                                           // DJLP 2000-09-05
  fStringAttri := TSynHighlighterAttributes.Create(SYNS_Attrstring);
  AddAttribute(fStringAttri);
  fSymbolAttri := TSynHighlighterAttributes.Create(SYNS_AttrSymbol);
  AddAttribute(fSymbolAttri);
  fTableNameAttri := TSynHighlighterAttributes.Create(SYNS_AttrTableName);
  AddAttribute(fTableNameAttri);
  fWrongSymbolAttri := TSynHighlighterAttributes.Create(SYNS_AttrWrongSymbol);  //pavel
  AddAttribute(fWrongSymbolAttri);                                              //pavel
  fVariableAttri := TSynHighlighterAttributes.Create(SYNS_AttrVariable);
  AddAttribute(fVariableAttri);

  SetAttributesOnChange(DefHighlightChange);
  MakeMethodTables;
  fDefaultFilter := SYNS_FilterSQL;
  fRange := rsUnknown;
  fDialect := sqlStandard;
  SQLDialect := sqlSybase;
end;

destructor TpSHHighlighter.Destroy;
begin
  fKeywords.Free;
  inherited Destroy;
end;

procedure TpSHHighlighter.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if (Source is TpSHHighlighter) then
    SQLDialect := TpSHHighlighter(Source).SQLDialect;
end;

function TpSHHighlighter.GetDefaultAttribute(Index: integer):
  TSynHighlighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT: Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER: Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD: Result := fKeyAttri;
    SYN_ATTR_STRING: Result := fStringAttri;
    SYN_ATTR_WHITESPACE: Result := fSpaceAttri;
    SYN_ATTR_SYMBOL: Result := fSymbolAttri;
  else
    Result := nil;
  end;
end;

function TpSHHighlighter.GetEol: Boolean;
begin
  Result := fTokenID = tkNull
end;

function TpSHHighlighter.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

function TpSHHighlighter.GetToken: string;
var
  Len: LongInt;
begin
  Len := Run - fTokenPos;
  SetString(Result, (FLine + fTokenPos), Len);
end;

function TpSHHighlighter.GetTokenAttribute: TSynHighlighterAttributes;
begin
  case GetTokenID of
    tkComment: Result := fCommentAttri;
    tkDatatype: Result := fDataTypeAttri;
    tkDefaultPackage: Result := fDefaultPackageAttri;                           // DJLP 2000-08-11
    tkException: Result := fExceptionAttri;
    tkFunction: Result := fFunctionAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkNumber: Result := fNumberAttri;
    tkPLSQL: Result := fPLSQLAttri;                                             // DJLP 2000-08-11
    tkSpace: Result := fSpaceAttri;
    tkSQLPlus: Result := fSQLPlusAttri;                                         // DJLP 2000-08-11
    tkString: Result := fStringAttri;
    tkSymbol: Result := fSymbolAttri;
    tkTableName: Result := fTableNameAttri;
    tkVariable: Result := fVariableAttri;
    tkUnknown: Result := fWrongSymbolAttri;                                     //pavel
    tkCustomStrings: Result := fCustomStringsAttri;
  else
    Result := nil;
  end;
end;

function TpSHHighlighter.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TpSHHighlighter.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

function TpSHHighlighter.GetTokenPos: Integer;
begin
  Result := fTokenPos;
end;

procedure TpSHHighlighter.Next;
begin
  fTokenPos := Run;
  case fRange of
    rsComment:
      AnsiCProc;
    rsString:
      AsciiCharProc;
  else
    fProcTable[fLine[Run]];
  end;
end;

procedure TpSHHighlighter.ResetRange;
begin
  fRange := rsUnknown;
end;

procedure TpSHHighlighter.SetLine(NewValue: string; LineNumber: Integer);
begin
  fLine := PChar(NewValue);
  Run := 0;
  fLineNumber := LineNumber;
  Next;
end;

procedure TpSHHighlighter.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

initialization
  MakeIdentTable;
{$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TpSHHighlighter);
{$ENDIF}
end.



