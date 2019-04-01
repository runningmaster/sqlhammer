{***************************************************************}
{ FIBPlus - component library for direct access to Firebird and }
{ Interbase databases                                           }
{                                                               }
{    FIBPlus is based in part on the product                    }
{    Free IB Components, written by Gregory H. Deatz for        }
{    Hoagland, Longo, Moran, Dunst & Doukas Company.            }
{    mailto:gdeatz@hlmdd.com                                    }
{                                                               }
{    Copyright (c) 1998-2001 Serge Buzadzhy                     }
{    Contact: buzz@devrace.com                                  }
{                                                               }
{ ------------------------------------------------------------- }
{    FIBPlus home page      : http://www.fibplus.net/           }
{    FIBPlus support e-mail : fibplus@devrace.com               }
{ ------------------------------------------------------------- }
{                                                               }
{  Please see the file License.txt for full license information }
{***************************************************************}

unit pSHSqlTxtRtns;

(* {$I FIBPlus.inc} *)

interface
uses
 SysUtils,Classes,(* BT StrUtil *) pSHStrUtil,
// {$IFDEF WINDOWS}
  Windows (* BT {$IFDEF D6+} *), Variants (* BT {$ENDIF} *)
  ;

// {$ENDIF}
// {$IFDEF LINUX}
//  Types , Variants;
// {$ENDIF}


type
  TSQLKind=(skUnknown,skSelect,skUpdate,skInsert,skDelete,skExecuteProc,skDDL,skExecuteBlock);
  TParserState =(sNormal,sQuote,sComment,sFBComment,sQuoteSingle);
  TOnScanSQLText = procedure(Position:integer;var StopScan:boolean) of object;
  TChars = set of Char;

  TSQLSection = (stUnknown,stSelect, stFields,
    stUpdate,stInsert,stDelete,stExecute, stSet, stComment,
    stFrom, stWhere, stGroupBy, stHaving,
    stUnion,    stPlan, stOrderBy, stForUpdate,
    stInto,stValues,stReturning,stReturningValues,stException,
    stProcedure,stNeedReturningValues,stDDLBegin, stDeclareVariables
  );

  TBlockPosition= record
   X:integer;
   Y:integer;
   X1:TPoint;
   Y1:TPoint;
   Level:integer;
  end;
  
  TBlocksPositions = array of TBlockPosition;
  TSQLSections = array of TSQLSection;

  TSQLParser  = class
  private
   FState  :TParserState;
   FCurPos :integer;
   FResultPos:integer;
   FBracketOpened:integer;
   FSQLText:string;
   FLen: integer;
   FReserved : integer;
   FReserved1: integer;
   FScanInBrackets:boolean;
   FFirstPos   :integer;
   FSQLKind    :TSQLKind;
   FCanParamsCheck:boolean;
   FTables     :TStrings;
   FBracketOpenedBeforeScan:integer;

   procedure   SetSQLText(const Value: string);
   function    IsClause(Position:integer;const Clause:string):boolean;
   function    GetSQLKind:TSQLKind;
    function IsInto(Position: integer): boolean;
    function IsValues(Position: integer): boolean;
    function IsProcedure(Position: integer): boolean;
  protected
    procedure  IsOrderBegin(Position:integer;var Yes:boolean);
    procedure  IsGroupBegin(Position:integer;var Yes:boolean);
    procedure  IsByBegin(Position:integer;var Yes:boolean);
    procedure  IsHaving(Position:integer;var Yes:boolean);
    procedure  IsMainOrderBegin(Position:integer;var Yes:boolean);
    procedure  IsMainGroupBegin(Position:integer;var Yes:boolean);    
    procedure  IsFromBegin(Position:integer;var Yes:boolean);
    procedure  IsWhereBegin(Position:integer;var Yes:boolean);
    procedure  IsWhereEnd(Position:integer;var Yes:boolean);

    procedure  IsMainWhereBegin(Position:integer;var Yes:boolean);
    procedure  IsMainFromBegin(Position:integer;var Yes:boolean);
    procedure  IsFromEnd(Position:integer;var Yes:boolean);
    procedure  IsPlanBegin(Position:integer;var Yes:boolean);
    procedure  IsPlanEnd(Position:integer;var Yes:boolean);
    procedure  IsSetBegin(Position:integer;var Yes:boolean);
    procedure  IsIntoBegin(Position:integer;var Yes:boolean);
    procedure  IsUpdateBegin(Position:integer;var Yes:boolean);

    function   IsDDLBegin(Position:integer):boolean;
    function   IsAs(Position:integer):boolean;    
    function   IsSelect(Position:integer):boolean;
    function   IsWith(Position:integer):boolean;    
    function   IsUpdate(Position:integer):boolean;
    function   IsSet(Position:integer):boolean;
    function   IsDelete(Position:integer):boolean;
    function   IsInsert(Position:integer):boolean;
    function   IsReturning(Position:integer):boolean;
    function   IsReturningValues(Position:integer):boolean;
    function   IsExecute(Position:integer):boolean;
    function   IsException(Position:integer):boolean;    
    function   IsExecuteProc(Position:integer):boolean;
    function   IsExecuteBlock(Position:integer):boolean;


    function   IsBegin(Position:integer):boolean;
    function   IsCase(Position:integer):boolean;
    function   IsEnd(Position:integer):boolean;

    function   IsDDL:boolean;
    procedure  FillMainTables(WithSP:boolean=False);
  public
   constructor Create; overload;
   constructor Create(const aSQLText:string); overload;
   destructor  Destroy; override;
   procedure   ScanText(FromPosition:integer;Proc:TOnScanSQLText);

   function    BeginSimpleStatementForPos(Position:integer):integer;
   function    PosInSections(Position:integer):TSQLSections; overload;
   function    PosInSections(ScanFrom,Position:integer; var EndScan:integer):TSQLSections; overload;

   function    DispositionMainFrom:TPoint;
   function    MainFrom:string;
   function    ModifiedTables:string;

   function    OrderText(var StartPos,EndPos:integer):string;
   function    OrderClause:string;
   function    SetOrderClause(const Value:string):string;
   function    GetOrderInfo:Variant;
   function    GroupByText(var StartPos,EndPos:integer):string;
   function    GroupByClause:string;
   function    SetGroupClause(const Value:string):string;

   function    GetFieldsClause:string;
   function    SetFieldsClause(const NewFields:string):string;

   function    WhereClause(N:integer;var  StartPos,EndPos:integer):string;
   function    SetWhereClause(N:Integer;const Value:string):string;
   function    SetMainWhereClause(const Value:string):string;
   function    MainWhereClause(var  StartPos,EndPos:integer):string;
   function    WhereCount:integer;
   function    MainWhereIndex:integer;
   function    AddToMainWhere(const NewClause:string;ForceCLRF:boolean = True):string;

   function    PlanCount:integer;
   function    PlanText(N:integer;var  StartPos,EndPos:integer):string;

   function    MainPlanIndex:integer;
   function    MainPlanText(var  StartPos,EndPos:integer):string;
   function    SetMainPlan(const Text:string):string;
   function    GetMainPlan:string;

   function    RecCountSQLText:string;
   function    GetAllTables(WithSP:boolean=False):TStrings;
   function    GetBlocksPositions(FromPosition:integer; var EndPosition:integer; aLevel:integer=1;
    BeginLine:integer=1;BeginChar:integer=1

   ): TBlocksPositions ;
  public
   property    SQLText:string read FSQLText write SetSQLText;
   property    Len :integer read FLen write FLen;
   property    FirstPos   :integer read FFirstPos;
   property    MainPlanClause:string   read GetMainPlan ;
   property    SQLKind :TSQLKind read FSQLKind;
   property    CanParamsCheck:boolean read FCanParamsCheck;
  end;

const
   SpaceStr='    ';
   ForceNewStr=#13#10+SpaceStr;
   QuotMarks=#39;

 function  DispositionFrom(const SQLText:string):TPoint;
 procedure AllSQLTables(SQLText:string;aTables:TStrings; WithSP:boolean=False
 ;WithAliases:boolean =False
 );
 procedure AllTables(const SQLText:string;aTables:TStrings; WithSP:boolean =False
  ;WithAliases:boolean =False
 );

 function  TableByAlias(const SQLText,Alias:string):string;
 function  AliasForTable(const SQLText,TableName:string):string;

 function  FullFieldName(const SQLText,aFieldName:string):string;
 function  FieldNameFromSelect(const SQLText, FieldName: String):String;
 function  AddToWhereClause(const SQLText,NewClause:string;
  ForceCLRF:boolean  = True
 ):string;
 function  GetWhereClause(const SQLText:string;N:integer;var
   StartPos,EndPos:integer
 ):string;
 function  WhereCount(SQLText:string):integer;
 function  MainWhereIndex(const SQLText:string):integer;
 function  MainFrom(const SQLText:string):string;
 function  MainWhereClause(const SQLText:string):string;
 function  GetOrderInfo(const SQLText:string):variant;
 function  OrderStringTxt(const SQLText:string;
  var StartPos,EndPos:integer
 ):String;

 procedure SetOrderString(SQLText:TStrings;const OrderTxt:string);
//

 function  PrepareConstraint(Src:Tstrings):string;

 procedure NormalizeSQLText(const SQL: string;MacroChar:Char;
  var NSQL:string
 );


 function  CountSelect(const SrcSQL:string):string;
 function  GetModifyTable(const SQLText:string;WithAlias:boolean=False):string;
 function  GetSQLKind(const SQLText:string):TSQLKind;
//

 function  GetLinkFieldName(const SQLText,ParamName: string): string;
 function  GetFieldByAlias(const SQLText,FieldName:string):string;
 function  IsWhereBeginPos(const SQLText:string;Position:integer):boolean;
 function  IsWhereEndPos(const SQLText:string;Position:integer):boolean;
 function  PosInSections(const SQLText:string;Position:integer):TSQLSections;

 function  InvertOrderClause(const OrderText:string):string;
 function  IsEquelSQLNames(const Name1,Name2:string):boolean;

 function CutTableName(const SQLString:string;AliasPosition:integer=0):string;
 function CutAlias(const SQLString:string;AliasPosition:integer=0):string;
 function PosAlias(const SQLString:string):integer;
 function FieldNameForSQL(const TableAlias,FieldName:string):string;

const
  CharsAfterClause =[' ',#13,#9,#10,#0,';','(','/','-'];
  CharsBeforeClause=[' ',#10,')',#9,#13,';'];
  endLexem=['+',')','(','*','/','|',',','=','>','<','-','!','^','~',',',';'];
  IBStdCharSetsCount=61;
  UnknownStr='UNKNOWN';

 IBStdCharacterSets:array [0..IBStdCharSetsCount-1] of string =
  ('NONE','OCTETS','ASCII','UNICODE_FSS',UnknownStr,'SJIS_0208',
   'EUCJ_0208',UnknownStr,UnknownStr,
   'DOS737','DOS437','DOS850','DOS865','DOS860',
   'DOS863', 'DOS775','DOS858','DOS862','DOS864','NEXT',UnknownStr,'ISO8859_1',
   'ISO8859_2','ISO8859_3',
    UnknownStr,UnknownStr,UnknownStr,UnknownStr,UnknownStr,UnknownStr,
    UnknownStr,UnknownStr,UnknownStr,UnknownStr,
   'ISO8859_4','ISO8859_5','ISO8859_6',
   'ISO8859_7','ISO8859_8','ISO8859_9','ISO8859_13',
   UnknownStr,UnknownStr,UnknownStr,
   'KSC_5601','DOS852','DOS857','DOS861','DOS866',
   'DOS869','CYRL','WIN1250','WIN1251','WIN1252','WIN1253',
   'WIN1254','BIG_5','GB_2312','WIN1255','WIN1256','WIN1257'
);

function ParseMacroString(const MacroString:string; aMacroChar:Char;var DefValue:string):string ;
function PosClause(const Clause,SQLText:string):integer;

const
  BeginWhere =' WHERE ';

implementation

uses Types;


procedure SkipCommentsAndBlanks(const SQLText:string;Len:integer; var Position:integer);
begin
 while (Position<Len) and
  (SQLText[Position] in CharsAfterClause) do
 begin
    while (Position<=Len) and(SQLText[Position] in (CharsAfterClause -['/','-']) ) do
      Inc(Position);
    if (Position<Len) and (SQLText[Position]='-')    then
    if (SQLText[Position+1]='-') then
    begin
     while (Position<=Len) and not(SQLText[Position] in [#13,#10]) do
      Inc(Position);
    end
    else
     Break;
    if (Position<Len) and(SQLText[Position]='/') then
    if(SQLText[Position+1]='*') then
    begin
     Inc(Position,2);
     while (Position<Len) and not((SQLText[Position]='*') and (SQLText[Position+1]='/')) do
      Inc(Position);
     Inc(Position,2);
    end
    else
     Break;
 end;
end;


function ParseMacroString(const MacroString:string; aMacroChar:Char;var DefValue:string):string ;
var
    PosDef:integer;
begin
// For FIBPlus Macro
   PosDef:=PosCh('%',MacroString);
   if PosDef=0 then
   begin
    if MacroString[1]=aMacroChar then
     Result:=MacroString
    else
     Result:=aMacroChar+MacroString;
   end
   else
   begin
     DoCopy(MacroString,Result,1,PosDef-1);
     DoCopy(MacroString,DefValue,PosDef+1,Length(MacroString)-PosDef);
     if MacroString[1] <> aMacroChar then Result := aMacroChar + Result
   end;
end;

function PosClause(const Clause,SQLText:string):integer;
begin
 Result:=PosExtCI(Clause,SQLText,CharsBeforeClause,CharsAfterClause,False);
end;

function IsEquelSQLNames(const Name1,Name2:string):boolean;
begin
  if (Length(Name1)>0) and (Length(Name2)>0) then
  begin
   case Name1[1] of
       '"':
       if Name2[1]<>'"' then
       begin
        Result:=FastCopy(Name1,2,Length(Name1)-2)=FastUpperCase(Name2)
       end
       else
        Result:=Name1=Name2
   else // else case
       if Name2[1]='"' then
        Result:= ('"'+Name1+'"'=Name2) or
        ('"'+FastUpperCase(Name1)+'"'=Name2)
       else
//  авычек нет нигде
        Result:=FastUpperCase(Name1)=FastUpperCase(Name2)
   end
  end
  else
    Result := True; // Unknown
end;


procedure NormalizeSQLText(const SQL: string;MacroChar:Char;
  var NSQL:string
);

var i,j:integer;
    InQuote:boolean;
    InComment:boolean;
    InFBComment:boolean;
    PredChar:Char;
    QuoteChar:Char;
    l:integer;
    InMacroValue,IsMacroVer1,InMacro:boolean;

function EndMacro:boolean;
begin
 if IsMacroVer1 then
  if InMacroValue then
   Result:=(SQL[i] in  [#13,' ',#9])
  else
   Result:=(SQL[i] in  [#13,' ']+endLexem)
 else
  Result:=(SQL[i]=MacroChar) and (SQL[i-1]<>MacroChar)
end;

function StringInUnceasing(const c1,c2:Char):boolean;
begin
{
const
 aUnceasing:array [0..12] of string  = ('||','<>','<=','>=','!=','!<','!>',
  '^=','~=','^>','~>','^<','~<'
 );
}

  case c1 of
    '|': Result:=c2='|';
    '<': Result:=c2 in ['>','='];
    '>': Result:=c2 ='=';
    '!','^','~': Result:=c2 in ['>','=','<'];
  else
    Result := False;
  end;
end;

procedure AdjustComparison;
begin
   if  (PredChar in ['!','^','~']) then
     case SQL[i] of
     '=': begin
           NSQL[j-1] :='<';
           NSQL[j]   :='>';
          end;
     '>': begin
           NSQL[j-1] :='<';
           NSQL[j]   :='=';
          end;
     '<': begin
           NSQL[j-1] :='>';
           NSQL[j]   :='=';
          end;
     else
       NSQL[j]:=SQL[i];
     end
   else
       NSQL[j]:=SQL[i];
end;

begin
 InQuote:=False;  InComment:=False; InFBComment:=False;
 PredChar:=#0;    QuoteChar:='"';
 l:=Length(SQL);  InMacro  :=False;
 if l=0 then
 begin
  NSQL:='';  Exit;
 end ;
 if SQL[1]=' ' then
 begin
  SetLength(NSQL,l);
  j:=1;
 end
 else
 begin
  SetLength(NSQL,l+1);
  NSQL[1]:=' ';
  j:=2;
  //¬сегда начинаем с пробела
 end;
 IsMacroVer1:=False;
 for i:=1 to l do
 begin
  if not InQuote then
  begin
    if not InFBComment then
     if InComment then
      InComment:=not ((SQL[i-1]='/')and (i>2) and (SQL[i-2]='*'))
     else
      InComment:=(SQL[i]='/')and (i<l) and (SQL[i+1]='*');
    if not InComment then
     if InFBComment then
      InFBComment:=(SQL[i-1]<>#13)
     else
      InFBComment:=(SQL[i]='-')and (i<L) and (SQL[i+1]='-');
  end;

  if not InComment and not InFBComment then
  if not InQuote then
  begin
   InQuote:= (SQL[i] in ['''','"']);
   if InQuote then QuoteChar:=SQL[i];
  end
  else
   InQuote:= (SQL[i] <> QuoteChar);
  if InComment or InFBComment then
   // InComment
   Continue
  else
  if InQuote then
  begin
   //InQuote
    NSQL[j]:= SQL[i];
    Inc(j);
  end
  else
  if (SQL[i] in endLexem) and not InMacro then
  begin
   if (PredChar<>' ') then
   begin
    if not StringInUnceasing(PredChar,SQL[i]) then
    begin
     NSQL[j]:=' ';
     Inc(j)
    end;
     if SQL[i]=':' then
      NSQL[j]:='?'
     else
      AdjustComparison;
    if (i<>l) and (SQL[i+1]<>' ') and
     not StringInUnceasing(SQL[i],SQL[i+1])  then
    begin
     Inc(j);
     NSQL[j]:=' ';
    end;
    Inc(j);
   end
   else
   begin
    NSQL[j]:=SQL[i];
    Inc(j);
   end;
  end
  else
  if (SQL[i] in ['?',':',MacroChar]) and (PredChar in EndLexem+[' '])
  then
  begin
   // Start Macro or Param
   InMacroValue:=False;
   if NSQL[j-1]<>' ' then
   begin
     NSQL[j]:=' ';
     if SQL[i]=':' then
      NSQL[j+1]:='?'
     else
      NSQL[j+1]:=SQL[i];
     Inc(j,2);
   end
   else
   begin
     if SQL[i]=':' then
      NSQL[j]:='?'
     else
      AdjustComparison;
    Inc(j,1);
   end;
   InMacro    :=SQL[i]=MacroChar;
   if InMacro and (i<l) then
    IsMacroVer1:=SQL[i+1]<>MacroChar;
  end
  else
  if InMacro then
  begin
    InMacro    :=not EndMacro;
    if InMacro then
    begin
      InMacroValue:=InMacroValue or (IsMacroVer1 and (SQL[i]='%'));
      NSQL[j]:=SQL[i];
      Inc(j);
    end
    else
    begin
      if IsMacroVer1 then
      begin
        NSQL[j]:=' ';
       if not (SQL[i] in CharsAfterClause) then
//       if not (SQL[i] in [' ',#13,#10,#9]) then
       begin
        Inc(j);
        NSQL[j]:=SQL[i];
        Inc(j);
        NSQL[j]:=' ';
       end;
      end
      else
       if SQL[i]=':' then
        NSQL[j]:='?'
       else
        AdjustComparison;
      Inc(j);
    end;
  end
  else
  if  (SQL[i] in CharsAfterClause) then
//  if (SQL[i] in [' ',#13,#10,#9]) then
  begin
   // Pack space
//   if (j>1) and (NSQL[j-1]<>' ') then
   if (j>1) and not (NSQL[j-1] in [' ','?']) then
   begin
    NSQL[j]:=' ';
    Inc(j);
    InMacro    :=False;
   end
  end
  else
  begin
     if SQL[i]=':' then
      NSQL[j]:='?'
     else
     if (SQL[i]>='a') and (SQL[i]<='z') then
      NSQL[j]:=Chr(Byte(SQL[i])-32)
     else
      NSQL[j]:=SQL[i];
    Inc(j);
  end;
  PredChar:=NSQL[j-1] ;
  if j>=l then SetLength(NSQL,j+10);
 end;
 SetLength(NSQL,j-1);
end;


function RemoveSP(const FromStr:string; OnlyArguments:boolean = False ):string;
var pBrIn,pBrOut:integer;
    cBrIn,cBrOut:integer;
    l:integer;
begin
 Result:=FromStr;
 pBrIn:=PosCh('(',FromStr);
 if pBrIn=0 then Exit;
 l:=Length(FromStr);
 while pBrIn >0 do
 begin
  pBrOut:=pBrIn+1;
  cBrIn :=1;     cBrOut:=0;
  while (cBrOut<cBrIn)  do
  begin
   if Result[pBrOut]=')' then Inc(cBrOut)
   else
   if Result[pBrOut]='(' then Inc(cBrIn);
   Inc(pBrOut);
   if pBrOut>l then Exit;
  end;
  if not OnlyArguments then
  begin
   while (pBrIn>1) and not (Result[pBrIn] in [',']) do
    Dec(pBrIn);
   while (pBrOut<=Length(Result)) and not (Result[pBrOut] in [',']) do
    Inc(pBrOut);
  end;
  System.Delete(Result,pBrIn,pBrOut-pBrIn);
  pBrIn:=PosCh('(',Result);
 end;
end;


(*
function  OpenBracketCount(const Txt:string;Len:integer):integer;
var j:integer;
    State:TParserState;
begin
 result:=0; State:=sNormal;
 for j := 1 to Len do
 begin
  case Txt[j] of
    '(':if (State=sNormal) then
          Inc(Result);
    ')': if (State=sNormal) then
          Dec(result);
    '"': case State of
          sNormal: State:=sQuote;
          sQuote : State:=sNormal;
         end;
    '''':case State of
          sNormal      : State:=sQuoteSingle;
          sQuoteSingle : State:=sNormal;
         end;
    '*': case State of
          sNormal:
           if (j>1) and (Txt[j-1]='/') then
             State:=sComment;
          sComment:
            if (j<len) and (Txt[j+1]='/') then
              State:=sNormal
         end;
    '-': case State of
          sNormal:
           if (j>1) and (Txt[j-1]='-') then
             State:=sFBComment;
         end;
    #13,#10:
     if State=sFBComment then
       State:=sNormal
  end;
 end;
end;
*)
function RemoveComments(const SQLText:string):string;
var
 Len:integer;
 Position,RLen:integer;
 State:TParserState;

procedure WriteResultChar;
begin
  Inc(RLen);
  Result[RLen]:=SQLText[Position];
end;

begin
 Len:=Length(SQLText);
 Position:=1; RLen:=0;
 SetLength(Result,Len);
 State:=sNormal;

 while (Position<=Len)do
 begin
    case State of
     sNormal:
     begin
      case SQLText[Position] of
       '"':
        begin
         State:=sQuote;
         WriteResultChar;
        end;
       '''':
        begin
         State:=sQuoteSingle;
         WriteResultChar;
        end;
       '-':
        begin
          if (Position<Len) and (SQLText[Position+1]='-') then
           State:=sFBComment
          else
           WriteResultChar;
        end;
       '/':
        begin
          if (Position<Len) and (SQLText[Position+1]='*') then
           State:=sComment
          else
           WriteResultChar;
        end;
      else
         WriteResultChar;
      end;
     end;
     sQuote:
      begin
       WriteResultChar;
       if (SQLText[Position]='"') then
         State:=sNormal;
      end;
     sQuoteSingle:
      begin
        WriteResultChar;
        if (SQLText[Position]='''') then
         State:=sNormal;
      end;
     sComment:
      if (SQLText[Position]='*') then
      begin
        if (Position<Len) and (SQLText[Position+1]='/') then
        begin
         State:=sNormal;
         Inc(Position);
        end;
      end;
     sFBComment:
      if (SQLText[Position]=#13) then
      begin
        State:=sNormal;
        if (Position<Len) and (SQLText[Position+1]=#10) then
         Inc(Position);
      end;
    end;
    Inc(Position);
 end;
 SetLength(Result,RLen);
end;

function RemoveJoins(const FromStr:string):string;
var pON,pComa,pJOIN:integer;
    tmpStr:string;
begin
 Result:=FromStr;
 pJOIN:=PosClause('JOIN',Result);
 if pJOIN=0 then
  Exit;
 Result:=FastCopy(Result,1,pJOIN-1)+', '+FastCopy(Result,PJOIN+5,MaxInt);
 Result:=ReplaceCIStr(Result, ' LEFT ' , ' ',False);
 Result:=ReplaceCIStr(Result, ' RIGHT ', ' ',False);
 Result:=ReplaceCIStr(Result, ' FULL ' , ' ',False);
 Result:=ReplaceCIStr(Result, ' INNER ', ' ',False);
 Result:=ReplaceCIStr(Result, ' OUTER ', ' ',False);
 Result:=ReplaceCIStr(Result, ' JOIN ', ' , ',False);
 pON:=PosClause('ON',Result);
 tmpStr:='';
 while pOn >0 do
 begin
  DoCopy(Result,tmpStr,pOn+2,MaxInt);
  pComa:=PosCh(',',tmpStr);
  SetLength(Result,pOn-1);
  if pComa>0 then
  begin
   Result:=Result+FastCopy(tmpStr,pComa,MaxInt)
  end;
  pON:=PosClause('ON',Result);
 end;
end;

function DispositionFrom(const SQLText:string):TPoint;
var
   Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
    Result := Parser.DispositionMainFrom;
  finally
   Parser.Free
  end
end;

function  CountSelect(const SrcSQL:string):string;
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SrcSQL);
  try
   Result:=Parser.RecCountSQLText;
  finally
   Parser.Free
  end;
end;

function  GetModifyTable(const SQLText:string;WithAlias:boolean=False):string;
var
  StartCut,EndCut,L:integer;
  Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
    Result:=FastTrim(Parser.ModifiedTables);
    L:=Length(Result);
    if not WithAlias and (L>0) then
    begin
      StartCut:=1;
      if Result[StartCut]='"' then
      begin
        Inc(StartCut);
        EndCut:=StartCut+1;
        while EndCut<=L do
        begin
          if Result[EndCut]='"' then
          begin
            Dec(EndCut); Break
          end
          else
           Inc(EndCut);
        end;
        Result:=FastCopy( Result,StartCut,EndCut-StartCut+1);
      end
      else
      begin
        EndCut:=StartCut;
        while EndCut<L do
        begin
          if Result[EndCut+1] in CharsAfterClause then
          begin
            Break
          end
          else
           Inc(EndCut);
        end;
       if L>EndCut then
        SetLength(Result,EndCut);
       Result:=FastUpperCase(Result);
      end;
    end;
  finally
   Parser.Free
  end;
end;

function PosAlias(const SQLString:string):integer;
var
   i:integer;
   InQuote1,InQuote2:boolean;
begin
  Result:=0;
  InQuote1:=False;
  InQuote2:=False;
  for i:=1 to Length(SQLString) do
  begin
      case SQLString[i] of
       ' ',#10,#13,#9:
        if not InQuote1 and not InQuote2 then
        begin
          Result:=i;
          Break;
        end;
       '"':
         if not InQuote2 then
           InQuote1:=not InQuote1;
       '''':
          if not InQuote1 then
           InQuote2:=not InQuote2;
      end;
  end;
  if Result>0 then
   while (Result<Length(SQLString)) and (SQLString[Result] in [' ',#13,#9,#10,#0]) do
    Inc(Result);
    
end;

function FieldNameForSQL(const TableAlias,FieldName:string):string;
begin
  if Length(TableAlias) > 0 then
   Result:=FormatIdentifier(3,TableAlias)+'.'+
    FormatIdentifier(3,FieldName)
  else
   Result:=FormatIdentifier(3,FieldName);
end;


function CutTableName(const SQLString:string; AliasPosition:integer=0):string;
var
  p:integer;
begin
  if AliasPosition=0 then
   p:=PosAlias(SQLString)
  else
   p:=AliasPosition;
  if p=0 then
   Result:=FastTrim(SQLString)
  else
   Result:=FastTrim(FastCopy(SQLString,1,p-1));
  if Length(Result)>0 then
   if Result[1]<>'"' then
   begin
     p:=PosCh('(',Result);
     if (p>0) and (PosCh(')',Result)>0) then // SP
      SetLength(Result,p-1);

   end
end;

function CutAlias(const SQLString:string; AliasPosition:integer=0):string;
var
  p:integer;
  inQ:boolean;
begin
  if AliasPosition=0 then
   p:=PosAlias(SQLString)
  else
   p:=AliasPosition;
  if p+2<=Length(SQLString) then
   if (SQLString[p] in ['A','a']) and (SQLString[p+1] in ['S','s']) then
    Inc(p,2);
  if p=0 then
   Result:=FastTrim(SQLString)
  else
   Result:=FastTrim(FastCopy(SQLString,p,MaxInt));
//  p:=PosAlias(Result);
  p:=1; inQ:=False;
  while (p<=Length(Result)) do
  begin
   case Result[p] of
    '"':  if (p=1) then
            inQ:=True
          else
            inQ:=False;

   else
    if not inQ and (Result[p] in CharsAfterClause+endLexem) then
    begin
     Dec(p);
     Break
    end;
   end;
   Inc(p)
  end;
  if p<Length(Result) then
    SetLength(Result,p)
end;

procedure RemoveAliases(ListOfTables:TStrings);
var
 i:integer;
begin
  for i := 0 to ListOfTables.Count - 1 do
  begin
    ListOfTables[i]:=CutTableName(ListOfTables[i]);
  end
end;

procedure AllTables(const SQLText:string;aTables:TStrings; WithSP:boolean =False
;WithAliases:boolean =False
 );
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  with Parser do
  try
   FillMainTables(WithSP);
   aTables.Assign(FTables);
   if not WithAliases then
     RemoveAliases(aTables);
  finally
   Parser.Free
  end;
end;

procedure AllSQLTables(SQLText:string;aTables:TStrings; WithSP:boolean=False
;WithAliases:boolean =False
);
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  with Parser do
  try
   GetAllTables(WithSP);
   aTables.Assign(FTables);
   if not WithAliases then
     RemoveAliases(aTables);

  finally
   Parser.Free
  end;
end;

function  AliasForTable(const SQLText,TableName:string):string;
var ts:TStrings;
    i,p:integer;
    tmpStr:string;
begin
 Result:=TableName;
 ts:=TStringList.Create;
 try
  AllTables(SQLText,ts,True,True);
  for i:=0 to Pred(ts.Count) do
  begin
   p:=PosAlias(ts[i]);
   if p>0 then
    tmpStr:=CutTableName(ts[i],p)
   else
    tmpStr:=FastTrim(ts[i]);

   if IsEquelSQLNames(tmpStr,TableName) then
   begin
     Result:=CutAlias(ts[i],p);
     Exit;
   end;
  end;
 finally
  ts.Free
 end;
end;

function  TableByAlias(const SQLText,Alias:string):string;
var ts:TStrings;
    i,p:integer;
    tmpStr:string;
    tmpStr1:string;
begin
 Result:='';
 ts:=TStringList.Create;
 tmpStr1:='';
 try
  AllTables(SQLText,ts, True,True);
  for i:=0 to Pred(ts.Count) do
  begin
   p:=PosAlias(ts[i]);
   if p>0 then
    tmpStr:=CutAlias(ts[i],p)
   else
    tmpStr:=FastTrim(ts[i]);

   if IsEquelSQLNames(tmpStr,Alias) then
   begin
     Result:=CutTableName(ts[i],p);
     Break;
   end
   else
   if Length(tmpStr1) = 0 then
   begin
    tmpStr1:=CutTableName(ts[i],p);
    if not IsEquelSQLNames(Alias,tmpStr1) then
     tmpStr1:='';
   end;
  end;
  if (Length(Result) = 0) and (Length(tmpStr1) > 0) then
   Result:=tmpStr1
 finally
  ts.Free
 end;
end;

function FullFieldName(const SQLText,aFieldName:string):string;
var
   p:integer;
   TableName:string;
   FieldName:string;
begin
 p:=PosCh('.',aFieldName);
 if p=0 then
  Result:=aFieldName
 else
 begin
  TableName:= TableByAlias(SQLText,FastCopy(aFieldName,1,p-1));
  if (Length(TableName)=0) then
   Result:=aFieldName
  else
  if (Length(TableName)=0) then
   Result:=aFieldName
  else
  begin
    FieldName:=FastTrim(FastCopy(aFieldName,p+1,MaxInt));
    if (Length(FieldName) > 0) then
     if FieldName[1]='"' then
      FieldName:=FastCopy(FieldName,2,Length(FieldName)-2)
     else
      DoUpperCase(FieldName);

    if (TableName[1]<>'"') then
     Result:=FastUpperCase(TableName)+'.'+FieldName
    else
     Result:=FastCopy(TableName,2,Length(TableName)-2)+'.'+FieldName
  end;
 end;
end;


function FieldNameFromSelect(const SQLText, FieldName: String):String;
var
  p,pb,pe : integer;
begin
  if Length(FieldName) = 0 then
   Result := FieldName
  else
  if PosCh('.', FieldName) > 0  then
   Result := FieldName
  else
  begin
      if FieldName[1]='"' then
       p:=PosInSubstrExt(FieldName, SQLText,
                     1,Length(SQLText),
             endLexem+CharsAfterClause+['.'],endLexem+CharsAfterClause
         )
      else
       p:=PosInSubstrCIExt(FieldName, SQLText,
                     1,Length(SQLText),
             endLexem+CharsAfterClause+['.'],endLexem+CharsAfterClause
         );

      if p > 0 then
      begin
       pb:=p-1;
       while (pb > 0) and ((SQLText[pb] in [' ',#10,#9,#13])) do
         Dec(pb);
       if (pb>0) and (SQLText[pb]='.') then
       begin
         pe:=pb-1;
         while (pe > 0) and (SQLText[pe] in [' ',#10,#9,#13]) do
          Dec(pe);
         if pe>0 then
         begin
           pb:=pe;
           while (pb > 0) and not (SQLText[pb] in ['(',' ',#10,#9,#13]) do
            Dec(pb);
          Inc(pb);
          Result :=FastCopy(SQLText, pb, pe-pb+1)+
           '.'+FastCopy(SQLText, p, Length(FieldName));
         end
         else
          Result := FastCopy(SQLText, p, Length(FieldName));
       end
       else
        Result := FastCopy(SQLText, p, Length(FieldName));
      end
      else
       Result := FieldName;
    end;
end;


function  MainWhereIndex(const SQLText:string):integer;
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
   Result:=Parser.MainWhereIndex;
  finally
   Parser.Free
  end;
end;

function  MainFrom(const SQLText:string):string;
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
   Result:=Parser.MainFrom;
  finally
   Parser.Free
  end;
end;

function  MainWhereClause(const SQLText:string):string;
var
    Parser:TSQLParser;
    i,j:integer;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
   Result:=Parser.MainWhereClause(i,j);
  finally
   Parser.Free
  end;
end;

function WhereCount(SQLText:string):integer;
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
   Result:=Parser.WhereCount;
  finally
   Parser.Free
  end;
end;

function  OrderStringTxt(const SQLText:string;
 var StartPos,EndPos:integer):String;
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
    Result:=Parser.OrderText(StartPos,EndPos);
  finally
   Parser.Free
  end
end;


function  GetSQLKind(const SQLText:string):TSQLKind;
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
    Result:=Parser.SQLKind;
  finally
   Parser.Free
  end
end;

function    TSQLParser.GetOrderInfo:Variant;
var
  StartPos, EndPos: integer;
  vOrderText:string;
  i,wc,p,L:integer;
  bufStr:string;
  TName,FName:string;
  wc1:integer;
begin
 vOrderText:=FastTrim(RemoveComments(OrderText(StartPos, EndPos)));
 wc:=WordCount(vOrderText,[',']);
 if wc<1 then
  Result:=null
 else
 begin
  Result:=VarArrayCreate([0,wc-1,0,2],varVariant);
  for i:=1 to wc do
  begin
    bufStr:=FastTrim(ExtractWord(i,vOrderText,[',']));
    if WordCount(bufStr,['.'])>1 then
    begin
     TName:=ExtractWord(1,bufStr,['.']);
     if Length(TName) > 0 then
      if TName[1]<>'"' then
       TName:=FastUpperCase(TName);
     FName:=FastTrim(ExtractWord(2,bufStr,['.']));
     if Length(FName) > 0 then
      if FName[1]<>'"' then
       FName:=FastUpperCase(FName);
     bufStr:=TName+ '.'+FName;
    end;


    wc1:=WordCount(bufStr,CharsAfterClause);
    if wc1>0 then
    begin

      p:=PosClause('NULLS',bufStr);
      if p>0 then
      begin
       wc1:=p;
       Inc(p,5);
       L:=Length(bufStr);
       while (p<=L) and (bufStr[p] in CharsAfterClause) do
        Inc(p);
       if p<L then
         Result[i-1,2]:= bufStr[p] in ['F','f']; // NULLS FIRST
       SetLength(bufStr,wc1-1);
      end
      else
       Result[i-1,2]:=False; // NULLS LAST


      p:=PosClause('DESC',bufStr);
      if p=0 then
       p:=PosClause('DESCENDING',bufStr);
      Result[i-1,1]:=p=0;
      if p>0 then
       SetLength(bufStr,p-1)
      else
      begin
       p:=PosClause('ASC',bufStr);
       if p=0 then
        p:=PosClause('ASCENDING',bufStr);
       if p>0 then
        SetLength(bufStr,p-1);
      end;
      p:=PosClause('COLLATE',bufStr);
      if p>0 then
       SetLength(bufStr,p-1);
      Result[i-1,0]:=FastTrim(bufStr);
    end;  
  end;
 end;
end;

function  GetOrderInfo(const SQLText:string):variant;
var 
    Parser:TSQLParser;
begin
 Parser:=TSQLParser.Create(SQLText);
 try
  Result:=Parser.GetOrderInfo;
 finally
  Parser.Free;
 end;
end;


procedure SetOrderString(SQLText:TStrings;const OrderTxt:string);
var
    StartPos,EndPos:integer;
    Old :string;
    OldTxt:string;
begin
  with SQLText do
  begin
   OldTxt:=Text;
   Old:=pSHSqlTxtRtns.OrderStringTxt(OldTxt, StartPos,EndPos);
   if StartPos>0 then
    Text:=ReplaceStrInSubstr(OldTxt, Old,' '+ OrderTxt+' ',
              StartPos,EndPos
    )
   else
    Text:=OldTxt+' ORDER BY '+OrderTxt
  end;
end;


function  GetWhereClause(const SQLText:string;N:integer;var
 StartPos,EndPos:integer
):string;
var
  Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
    Result:=Parser.WhereClause(N,StartPos,EndPos);
  finally
   Parser.Free
  end
end;

function AddToWhereClause(const SQLText,NewClause:string;ForceCLRF:boolean  = True):string;
var
  Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
    Result:=Parser.AddToMainWhere(NewClause,ForceCLRF);
  finally
   Parser.Free
  end;
end;

function PrepareConstraint(Src:Tstrings):string;
var i,pos_no: integer;
begin
// ѕриведение текстов констрэнтов к единому виду
// дл€ облегчени€ последующей обработки
// ¬ременно не используетс€
    Result := FastTrim(Src.Text);
    pos_no := PosCh('(',Result)+1;
    Result:=FastCopy(Result,Pos_no,Length(Result));
    pos_no :=-1;
    for i := Length(Result) downto 1 do
     if Result[i]=')' then begin pos_no := i; Break; end;
    SetLength(Result,Pos_no-1);
    Result:=
     ReplaceStr(FastCopy(Result,Pos_no,Length(Result)-Pos_no), '"',QuotMarks)
end;


{ TSQLParser }


constructor TSQLParser.Create;
begin
 FTables     :=TStringList.Create;
 FFirstPos :=1;
 inherited Create;
end;

constructor TSQLParser.Create(const aSQLText: string);
begin
 Create;
 SQLText:=aSQLText; 
end;

destructor TSQLParser.Destroy;
begin
  FTables.Free;
  inherited;
end;

procedure TSQLParser.IsFromEnd(Position: integer; var Yes: boolean);
var p:integer;
begin
   if FBracketOpenedBeforeScan<FBracketOpened then
   begin
     Yes := False; Exit;
   end;

   p   := Position;
   Yes := p=Len;
   if Yes then  Exit;
   if P>Len then Exit;
   if (SQLText[P] in [' ',#9,#13,#10]) then
   begin
    if (Len-P)>1 then
    case SQLText[P+1] of
    'F','f': // FOR UPDATE
     begin
       Yes := ((Len-P)>=3) and
           (SQLText[P+2] in ['O','o']) and
           (SQLText[P+3] in ['R','r']) ;
       if Yes and ((Len-P)>3) then
        Yes:=   (SQLText[P+4] in CharsAfterClause);
     end;
    'G','g': //GROUP BY
     begin
       Yes :=((Len-P)>=5) and
           (SQLText[P+2] in ['R','r']) and
           (SQLText[P+3] in ['O','o']) and
           (SQLText[P+4] in ['U','u']) and
           (SQLText[P+5] in ['P','p']) ;
       if Yes and ((Len-P)>5) then
        Yes:= (SQLText[P+6] in [' ',#9,#13,#10]);
     end;
    'H','h': //HAVING
     begin
       Yes :=  ((Len-P)>=6)    and
           (SQLText[P+2] in ['A','a']) and
           (SQLText[P+3] in ['V','v']) and
           (SQLText[P+4] in ['I','i']) and
           (SQLText[P+5] in ['N','n']) and
           (SQLText[P+6] in ['G','g']) ;
       if Yes and ((Len-P)>6) then
        Yes:=   (SQLText[P+7] in CharsAfterClause);
     end;
    'O','o'://ORDER BY
     begin
       Yes :=((Len-P)>=5) and
           (SQLText[P+2] in ['R','r']) and
           (SQLText[P+3] in ['D','d']) and
           (SQLText[P+4] in ['E','e']) and
           (SQLText[P+5] in ['R','r']) ;
       if Yes and ((Len-P)>5) then
        Yes:=  (SQLText[P+6] in CharsAfterClause);
     end;
    'P','p': // PLAN
     begin
       Yes :=((Len-P)>=4) and
           (SQLText[P+2] in ['L','l']) and
           (SQLText[P+3] in ['A','a']) and
           (SQLText[P+4] in ['N','n']) ;
       if Yes and ((Len-P)>4) then
        Yes:= (SQLText[P+5] in CharsAfterClause);
     end;
    'U','u': //UNION
     begin
       Yes :=((Len-P)>=5) and
           (SQLText[P+2] in ['N','n']) and
           (SQLText[P+3] in ['I','i']) and
           (SQLText[P+4] in ['O','o']) and
           (SQLText[P+5] in ['N','n']) ;
       if Yes and ((Len-P)>5) then
        Yes:= (SQLText[P+6] in CharsAfterClause);
     end;
    'W','w': //WHERE
     begin
       Yes :=((Len-P)>=5) and
           (SQLText[P+2] in ['H','h']) and
           (SQLText[P+3] in ['E','e']) and
           (SQLText[P+4] in ['R','r']) and
           (SQLText[P+5] in ['E','e']) ;
       if Yes and ((Len-P)>5) then
        Yes:= (SQLText[P+6] in CharsAfterClause);
     end
    end;
  end
end;

procedure TSQLParser.IsFromBegin(Position:integer;var Yes:boolean);
begin
 Yes:=
         (Position>1) and (Len-Position>=3)  and
         (SQLText[Position] in ['F','f'])   and
         (SQLText[Position+1] in ['R','r']) and
         (SQLText[Position+2] in ['O','o']) and
         (SQLText[Position+3] in ['M','m']) and
         (SQLText[Position-1] in CharsBeforeClause);
if Yes and (Len-Position>3) then
 Yes:= (SQLText[Position+4] in CharsAfterClause) ;
end;



procedure TSQLParser.IsMainFromBegin(Position:integer;var Yes:boolean);
begin
 Yes:=  (FBracketOpened=0);
 if Yes then
  IsFromBegin(Position,Yes);
end;

procedure  TSQLParser.IsSetBegin(Position:integer;var Yes:boolean);
begin
  Yes:=(Position>1) and (Len-Position>=4)
   and (SQLText[Position]   in ['S','s'])
   and (SQLText[Position+1] in ['E','e'])
   and (SQLText[Position+2] in ['T','t'])
   and (SQLText[Position-1] in CharsBeforeClause)
   and (SQLText[Position+3] in CharsAfterClause);
end;

procedure  TSQLParser.IsUpdateBegin(Position:integer;var Yes:boolean);
begin
  Yes:=IsUpdate(Position);
end;

procedure  TSQLParser.IsIntoBegin(Position:integer;var Yes:boolean);
begin
  Yes:=(Position>1) and (Len-Position>=4)
   and (SQLText[Position]   in ['I','i'])
   and (SQLText[Position+1] in ['N','n'])
   and (SQLText[Position+2] in ['T','t'])
   and (SQLText[Position+3] in ['O','o'])
   and (SQLText[Position-1] in CharsBeforeClause)
   and (SQLText[Position+4] in CharsAfterClause);
end;

procedure  TSQLParser.IsPlanBegin(Position:integer;var Yes:boolean);
begin
  Yes:=(Position>1) and (Len-Position>=5)
   and (SQLText[Position]   in ['P','p'])
   and (SQLText[Position+1] in ['L','l'])
   and (SQLText[Position+2] in ['A','a'])
   and (SQLText[Position+3] in ['N','n'])
   and (SQLText[Position-1] in CharsBeforeClause)
   and (SQLText[Position+4] in CharsAfterClause);
  if Yes  and (FReserved>0) then
  begin
   Inc(FReserved1);
   Yes:=FReserved1=FReserved
  end;
end;

procedure TSQLParser.IsPlanEnd(Position:integer;var Yes:boolean);
var p:integer;
begin
   if FBracketOpenedBeforeScan<FBracketOpened then
   begin
     Yes := False; Exit;
   end;
   p   := Position;
   Yes := p=Len;
   if Yes then  Exit;
   if P>Len then Exit;
   if (SQLText[P] in [' ',#9,#13,#10]) then
   begin
    if (Len-P)>1 then
    case SQLText[P+1] of
    'O','o'://ORDER BY
       Yes :=((Len-P)>=6) and
           (SQLText[P+2] in ['R','r']) and
           (SQLText[P+3] in ['D','d']) and
           (SQLText[P+4] in ['E','e']) and
           (SQLText[P+5] in ['R','r']) and
           (SQLText[P+6] in CharsAfterClause);
    end;
   end
end;

procedure TSQLParser.IsWhereBegin(Position: integer; var Yes: boolean);
begin
  Yes:=IsWhereBeginPos(SQLText,Position);
  if Yes  and (FReserved>0) then
  begin
   Inc(FReserved1);
   Yes:=FReserved1=FReserved
  end;
end;

procedure  TSQLParser.IsWhereEnd(Position:integer;var Yes:boolean);
begin
   if FBracketOpenedBeforeScan<FBracketOpened then
   begin
     Yes := False; Exit;
   end;
   Yes :=IsWhereEndPos(SQLText,Position)
end;

procedure  TSQLParser.IsMainWhereBegin(Position:integer;var Yes:boolean);
begin
  Yes:= FBracketOpened=0;
  if Yes then
   IsWhereBegin(Position,Yes)
end;

procedure TSQLParser.ScanText(FromPosition: integer; Proc: TOnScanSQLText);
var      j  :integer;
    StopScan:boolean;
begin
 if not Assigned(Proc) then Exit;
 FState:=sNormal;
 FResultPos:=0; FBracketOpenedBeforeScan:=FBracketOpened;
 for j := FromPosition to Len do
 begin
  FCurPos:=j;
  case SQLText[j] of
    '(': if not (FState in [sComment,sFBComment,sQuote,sQuoteSingle]) then
         begin
           Inc(FBracketOpened);
         end;
    ')': if not (FState in [sComment,sFBComment,sQuote,sQuoteSingle]) then
         begin
           if (FScanInBrackets  and (FBracketOpened-1<FBracketOpenedBeforeScan))
           then
           begin
              FResultPos:=j;
              Break
           end
           else
            Dec(FBracketOpened);
         end;
    '"':  if not (FState in [sComment,sFBComment,sQuoteSingle]) then
          if  FState=sQuote then
           FState:=sNormal
          else
           FState:=sQuote;
    '''': if not (FState in [sComment,sFBComment,sQuote]) then
          if  FState=sQuoteSingle then
           FState:=sNormal
          else
           FState:=sQuoteSingle;
    '*': if not (FState in [sQuote,sQuoteSingle]) then
         begin
          if FState=sComment then
          begin
            if (j<Len) and (FSQLText[j+1]='/') then
              FState:=sNormal
          end
          else
            if (j>1) and (FSQLText[j-1]='/') then
              FState:=sComment
         end;
     '-': if FState=sNormal then
          begin
           if (j<Len) and (FSQLText[j+1]='-') then
              FState:=sFBComment
          end;
  else
   case FState of
    sNormal:
     begin
      StopScan:=False;
      Proc(j,StopScan);
      if StopScan then
      begin
        FResultPos:=j;
        Break
      end;
     end;
    sFBComment:
     if FSQLText[j]=#13 then
      FState:=sNormal
   end
  end;
 end;

 if (FResultPos=0) and (FState=sNormal) then
 begin
  StopScan:=False;
  Proc(Len,StopScan);
  if StopScan then
  begin
    FResultPos:=Len;
  end;
 end;
 FReserved:=0;
end;

procedure TSQLParser.SetSQLText(const Value: string);
begin
  FSQLText := Value;
  FTables.Clear;
  FLen:=Length(FSQLText);
  FFirstPos:=1;
  SkipCommentsAndBlanks(FSQLText,FLen,FFirstPos);
  FSQLKind :=GetSQLKind;
end;

{
procedure  TSQLParser.GetMainFields(OutList:TStrings);
var
   Position:integer;
   EndPos :integer;
   tmpStr :string;
   vState  :TParserState;
begin
  OutList.Clear;
  case SQLKind of
   skInsert:;
   skUpdate:
    begin
     FResultPos:=0;
     ScanText(FFirstPos,IsSetBegin);
    end;
  else
    Exit;
  end;
   if FResultPos>0 then
   begin
     Position:=FResultPos+3;
     SkipCommentsAndBlanks(SQLText,Len,Position);
     ScanText(FFirstPos,IsMainFromBegin);
     if FResultPos>0 then
      EndPos :=FResultPos
     else
      EndPos :=Len;
     vState:=FState;
     tmpStr:='';
     while (Position<=EndPos) do
     begin
      case SQLText[Position] of
       '''':
        case vState of
         sQuoteSingle:
         begin
          tmpStr:=tmpStr+SQLText[Position];
          vState:=sNormal;
         end;
         sNormal:
         begin
          tmpStr:=tmpStr+SQLText[Position];
          vState:=sQuoteSingle;
         end;
         sQuote:
          tmpStr:=tmpStr+SQLText[Position]
        end;
      '"':
        case vState of
         sQuote:
         begin
          tmpStr:=tmpStr+SQLText[Position];
          vState:=sNormal;
         end;
         sNormal:
         begin
          tmpStr:=tmpStr+SQLText[Position];
          vState:=sQuote;
         end;
         sQuoteSingle:
          tmpStr:=tmpStr+SQLText[Position]
        end;
       '-':
        case vState of
         sNormal:
          if (Position<Len) and (SQLText[Position]='-') then
          begin
            OutList.Add(tmpStr);
            tmpStr:='';
            vState:=sFBComment
          end
          else
           tmpStr:=tmpStr+SQLText[Position];
         sQuoteSingle,sQuote:
          tmpStr:=tmpStr+SQLText[Position];
        end;
        #13:
        case vState of
           sNormal:
           begin
            OutList.Add(tmpStr);
            tmpStr:='';
           end;
           sFBComment:
            vState:=sNormal;
        end;
        ',','=':
        case vState of
           sNormal:
           begin
            OutList.Add(tmpStr);
            tmpStr:='';
           end;
           sQuoteSingle,sQuote:
            tmpStr:=tmpStr+SQLText[Position];
        end;

      end;
      Inc(Position);
     end;
   end;
end;   }

procedure TSQLParser.IsOrderBegin(Position: integer; var Yes: boolean);
begin
 Yes:=  (Position>1) and (Len-Position>=5) and
        (SQLText[Position]   in ['O','o']) and
        (SQLText[Position+1] in ['R','r']) and
        (SQLText[Position+2] in ['D','d']) and
        (SQLText[Position+3] in ['E','e']) and
        (SQLText[Position+4] in ['R','r']) and
        (SQLText[Position+5] in CharsAfterClause) and
        (SQLText[Position-1] in CharsBeforeClause)
end;


procedure TSQLParser.IsMainOrderBegin(Position: integer; var Yes: boolean);
begin
 Yes:=FBracketOpened=0;
 if Yes then
  IsOrderBegin(Position, Yes)
end;


procedure TSQLParser.IsGroupBegin(Position: integer; var Yes: boolean);
begin
 Yes:=  (Position>1) and (Len-Position>=5) and
        (SQLText[Position]   in ['G','g']) and
        (SQLText[Position+1] in ['R','r']) and
        (SQLText[Position+2] in ['O','o']) and
        (SQLText[Position+3] in ['U','u']) and
        (SQLText[Position+4] in ['P','p']) and
        (SQLText[Position+5] in CharsAfterClause) and
        (SQLText[Position-1] in CharsBeforeClause)

end;

procedure TSQLParser.IsMainGroupBegin(Position:integer;var Yes:boolean);
begin
 Yes:=FBracketOpened=0;
 if Yes then
  IsGroupBegin(Position, Yes)
end;

function TSQLParser.IsClause(Position: integer;
  const Clause: string): boolean;
var
   LenClause :integer;
begin
 LenClause :=Length(Clause);
 Result:=  (Position>1) and (Len-Position>=LenClause) and
        (SQLText[Position+LenClause] in CharsAfterClause) and
        (SQLText[Position-1] in CharsBeforeClause);
 if Result then
  Result:=Clause=FastUpperCase(FastCopy(SQLText,Position,LenClause))
end;

procedure TSQLParser.IsByBegin(Position: integer; var Yes: boolean);
begin
 Yes:=  IsClause(Position,'BY')
end;

procedure  TSQLParser.IsHaving(Position:integer;var Yes:boolean);
begin
 Yes:=  IsClause(Position,'HAVING')
end;

function TSQLParser.DispositionMainFrom: TPoint;
begin
   // от и до
    Result.X:=0;
    Result.Y:=0;
    ScanText(FFirstPos,IsMainFromBegin);
    if FResultPos=0 then
     Exit;
    Result.X:=FResultPos;
    ScanText(Result.X+5,IsFromEnd);
    if FResultPos=0 then
     Result.Y:=Len
    else
     Result.Y:=FResultPos;
end;

function TSQLParser.MainFrom:string;
var
 p:TPoint;
begin
  p:=DispositionMainFrom;
  if p.X>0 then
   if p.Y=Length(SQLText) then
    Result:=FastCopy(SQLText,p.X+5,MaxInt)
   else
    Result:=FastCopy(SQLText,p.X+5,p.Y-p.X-5)
  else
   Result:=''
end;

function    TSQLParser.PosInSections(Position:integer):TSQLSections;
var
  temp:integer;
begin
  Result:=PosInSections(1,Position,temp)
end;

function  TSQLParser.BeginSimpleStatementForPos(Position:integer):integer;
var
    CurPos:integer;
begin
 Result:=1;
 if SQLKind in [skSelect,skUpdate,skInsert,skDelete] then
  Exit
 else
 begin
   CurPos:=1;
    while (CurPos<Position) do
    begin
     case SQLText[CurPos] of
      'b','B': if ((Length(SQLText)-CurPos)>=5)  and
                (SQLText[CurPos+1] in ['e','E']) and
                (SQLText[CurPos+2] in ['g','G']) and
                (SQLText[CurPos+3] in ['i','I']) and
                (SQLText[CurPos+4] in ['n','N']) and
                (SQLText[CurPos+5] in CharsAfterClause)
               then
               begin
                 Inc(CurPos,5);
                 Result:=CurPos;
               end
               else
                 Inc(CurPos);
      'd','D':
              if ((Length(SQLText)-CurPos)>=2)  and
                (SQLText[CurPos+1] in ['o','O']) and
                (SQLText[CurPos+2] in CharsAfterClause)
               then
               begin
                 Inc(CurPos,3);
                 Result:=CurPos;
               end
               else
                 Inc(CurPos);
      'e','E': if ((Length(SQLText)-CurPos)>=4)  and
                (SQLText[CurPos+1] in ['l','L']) and
                (SQLText[CurPos+2] in ['s','S']) and
                (SQLText[CurPos+3] in ['e','E']) and
                (SQLText[CurPos+4] in CharsAfterClause)
               then
               begin
                 Inc(CurPos,5);
                 Result:=CurPos;
               end
               else
               if ((Length(SQLText)-CurPos)>=3)  and
                (SQLText[CurPos+1] in ['n','N']) and
                (SQLText[CurPos+2] in ['d','D']) and
                (SQLText[CurPos+3] in CharsAfterClause)
               then
               begin
                 Inc(CurPos,4);
                 Result:=CurPos;
               end
               else
                 Inc(CurPos);
      'f','F': if ((Length(SQLText)-CurPos)>=3)  and
                (SQLText[CurPos+1] in ['o','O']) and
                (SQLText[CurPos+2] in ['r','R']) and
                (SQLText[CurPos+3] in CharsAfterClause)
               then
               begin
                 Inc(CurPos,3);
                 Result:=CurPos;
               end
               else
                 Inc(CurPos);

      't','T': if ((Length(SQLText)-CurPos)>=4)  and
                (SQLText[CurPos+1] in ['h','H']) and
                (SQLText[CurPos+2] in ['e','E']) and
                (SQLText[CurPos+3] in ['n','N']) and
                (SQLText[CurPos+4] in CharsAfterClause)
               then
               begin
                 Inc(CurPos,4);
                 Result:=CurPos;
               end
               else
                 Inc(CurPos);
      ';':
      begin
       Inc(CurPos);
       Result:=CurPos;
      end;
      '-': if SQLText[CurPos+1]='-' then
            SkipCommentsAndBlanks(SQLText,Position,CurPos)
           else
            Inc(CurPos);

      '/': if SQLText[CurPos+1]='*' then
            SkipCommentsAndBlanks(SQLText,Position,CurPos)
           else
            Inc(CurPos);
     else
      Inc(CurPos)
     end;
    end;
 end;
 SkipCommentsAndBlanks(SQLText,Position,Result);
end;

function  TSQLParser.PosInSections(ScanFrom,Position:integer; var EndScan:integer):TSQLSections;
var
  i: Integer;


  MayBe1:TSQLSections;
  vBracketOpenedBeforeScan:integer;
  b:boolean;

procedure AddArray(NewArray:TSQLSections);
var
   j,k:integer;
begin
  SetLength( Result ,Length(Result)+Length(NewArray));
  k:=1;
  for j:=Length(NewArray)-1 downto 0 do
  begin
   Result[Length(Result)-k]:=NewArray[j];
   Inc(k);
  end;
end;

begin
  FState:=sNormal;
  SetLength(MayBe1,0);
  SetLength( Result ,0);

  if ScanFrom=1 then
  begin
   FBracketOpened:=0;
   vBracketOpenedBeforeScan:=0
  end
  else
   vBracketOpenedBeforeScan:=FBracketOpened;

  i:=ScanFrom;
  while i<=Position do
  begin
    case SQLText[i] of
      '(': if not (FState in [sComment,sFBComment,sQuote,sQuoteSingle]) then
           begin
             Inc(FBracketOpened);
               if (Length(Result)>0) and (Result[Length(Result)-1]=stInto) then
                  Result[Length(Result)-1]:=stFields
               else
               begin
                 MayBe1:=PosInSections(i+1,Position,EndScan);
                 if EndScan>=Position then
                 begin
                  if Length(MayBe1)>0 then
                   AddArray(MayBe1)
                  else
                  if (Length(Result)>0) and (Result[Length(Result)-1]=stProcedure) then
                   if (Length(Result)=1) or (Result[Length(Result)-2]<>stDDLbegin) then
                     Result[Length(Result)-1]:=stNeedReturningValues; // “реба returning_values


                  Exit
                 end
                 else
                 begin
                   i:=EndScan;
                   Continue;
                 end;
               end;
           end;
      ')': if not (FState in [sComment,sFBComment,sQuote,sQuoteSingle]) then
           begin
              Dec(FBracketOpened);
              if (FBracketOpened<=vBracketOpenedBeforeScan) then
              begin
                if (Length(Result)<2) or (Result[0]<>stInsert) or
                 (Result[1]<>stFields)
                then
                begin
                 EndScan:=i+1;
                 Exit;
                end
              end
           end;
      '"':  if not (FState in [sComment,sFBComment,sQuoteSingle]) then
            if  FState=sQuote then
             FState:=sNormal
            else
             FState:=sQuote;
      '''': if not (FState in [sComment,sFBComment,sQuote]) then
            if  FState=sQuoteSingle then
             FState:=sNormal
            else
             FState:=sQuoteSingle;
      '*': if not (FState in [sQuote,sQuoteSingle]) then
           begin
            if FState=sComment then
            begin
              if (i<Len) and (FSQLText[i+1]='/') then
                FState:=sNormal
            end
            else
              if (i>1) and (FSQLText[i-1]='/') then
                FState:=sComment
           end;
       '-': if FState=sNormal then
            begin
             if (i<Len) and (FSQLText[i+1]='-') then
                FState:=sFBComment
            end;
    else
     if FState<>sNormal then
     begin
      Inc(i);
      EndScan:=i;
      Continue
     end;
     if IsAs(i) and (Length(Result)>0) and (Result[Length(Result)-1]=stDDLBegin) then
     begin
        Result[Length(Result)-1]:=stDeclareVariables;
        Inc(i,3);        
     end
     else
     if IsDDLBegin(i) then
     begin
       SetLength( Result ,Length(Result)+1);
       Result[Length(Result)-1]:=stDDLBegin;
       Inc(i,5);
     end
     else
     if IsSelect(i) then
     begin
       SetLength( Result ,Length(Result)+2);
       Result[Length(Result)-2]:=stSelect;
       Result[Length(Result)-1]:=stFields;
       Inc(i,5);
     end
     else
     if IsUpdate(i) then
     begin
      SetLength(Result,Length(Result)+1);
      Result[Length(Result)-1]:=stUpdate;
      Inc(i,5)
     end
     else
     if IsSet(i) then
     begin
      SetLength(Result,Length(Result)+1);
      Result[Length(Result)-1]:=stSet;
      Inc(i,3)
     end
     else
     if IsDelete(i) then
     begin
       SetLength(Result,Length(Result)+2);
       Result[Length(Result)-2]:=stDelete;
       Result[Length(Result)-1]:=stFrom;
       Inc(i,5);
     end
     else
     if IsInsert(i)  then
     begin
      SetLength(Result,Length(Result)+1);
      Result[Length(Result)-1]:=stInsert;
      Inc(i,5);
     end
     else
     if IsInto(i)  then
     begin
      SetLength(Result,Length(Result)+1);
      Result[Length(Result)-1]:=stInto;
      Inc(i,3);
     end
     else
     if IsValues(i)  then
     begin
      if Length(Result)=0 then
         SetLength(Result,1);
      Result[Length(Result)-1]:=stValues;
      Inc(i,5);
     end
     else
     if IsReturning(i)  then
     begin
      if Length(Result)=0 then
         SetLength(Result,1);
      Result[Length(Result)-1]:=stReturning;
      Inc(i,8);
     end
     else
     if IsExecute(i) then
     begin
      SetLength(Result,Length(Result)+1);
      Result[Length(Result)-1]:=stExecute;
      Inc(i,6);
     end
     else
     if IsProcedure(i) then
     begin
      if Length(Result)=0 then
         SetLength(Result,1);

      if Result[Length(Result)-1]<>stDDLBegin then
       Result[Length(Result)-1]:=stProcedure;
      Inc(i,9);
     end
     else
     if IsException(i) then
     begin
      SetLength(Result,Length(Result)+1);
      Result[Length(Result)-1]:=stException;
      Inc(i,9);
     end
     else
     if IsReturningValues(i) then
     begin
      if Length(Result)=0 then
         SetLength(Result,1);
      Result[Length(Result)-1]:=stReturningValues;
      Inc(i,16);
     end
     else
     begin
      b:=False;
      IsFromBegin(i,b);
      if b then
      begin
        if Length(Result)=0 then
         SetLength(Result,1);
        Result[Length(Result)-1]:=stFrom;
        Inc(i,3);
      end
      else
      begin
       IsWhereBegin(i,b);
       if b then
       begin
          if Length(Result)=0 then
           SetLength(Result,1);
          Result[Length(Result)-1]:=stWhere;
         Inc(i,4);
       end
       else
       begin
         IsOrderBegin(i,b);
         if b then
         begin
            if Length(Result)=0 then
             SetLength(Result,1);
            Result[Length(Result)-1]:=stOrderBy;
            Inc(i,4);
         end
         else
         begin
           IsPlanBegin(i,b);
           if b then
           begin
             if Length(Result)=0 then
               SetLength(Result,1);
             Result[Length(Result)-1]:=stPlan;
             Inc(i,3);
           end
           else
           if IsClause(i,'GROUP') then
           begin
             if Length(Result)=0 then
               SetLength(Result,1);
             Result[Length(Result)-1]:=stGroupBy;
             Inc(i,5);
           end;
         end
       end;
      end;
     end;


    end;
    Inc(i);
    EndScan:=i
  end;
end;


function  TSQLParser.ModifiedTables:string;
var
   Start:Integer;
   L:integer;
   tmpStr:string;

procedure CutTable;
var
  p:integer;
  InQuote:boolean;
begin
 L:=0;
 InQuote:=False;
 SkipCommentsAndBlanks(SQLText,Len,Start);
 for p:=Start to Len do
 begin
   case SQLText[p] of
   '-','/':
    if InQuote then
      Inc(L)
    else
      Break;
   '"':
    begin
      InQuote:=not InQuote;
      Inc(L);
      if not InQuote then
       Break
    end;
   '(':
     if InQuote then
      Inc(L)
     else
      Break;
   else
     if InQuote or not (SQLText[p] in CharsAfterClause) then
        Inc(L)
     else
       Break;
   end; //end case
 end;
  Result:=FastCopy(SQLText,Start,L);
end;

begin
   case SQLKind of
    skUpdate:
    begin
      Start:=FFirstPos+6;
      CutTable;
      tmpStr:= Result;
      Start:=Start+L;
      CutTable;
      if FastUpperCase(Result)<>'SET' then
        Result:= tmpStr+' '+Result
      else
        Result:=tmpStr;
    end;
    skInsert:
    begin
     ScanText(FFirstPos+7,IsIntoBegin);
     if FResultPos>0 then
     begin
       Start:=FResultPos+5;
       CutTable;
     end
     else
      Result:='Unknown'
    end;   // skInsert
    skDelete:
    begin
     ScanText(FFirstPos,IsFromBegin);
     if FResultPos>0 then
     begin
      Start:=FResultPos+4;
      CutTable;
      tmpStr:= Result;
      Start := Start+L;
      CutTable;
      if FastUpperCase(Result)<>'WHERE' then
        Result:= tmpStr+' '+Result
      else
        Result:=tmpStr;
     end
     else
      Result:='Unknown';

//      Result:=MainFrom
   end
  else
    Result:='Unknown';  
  end;
end;

function TSQLParser.OrderText(var StartPos, EndPos: integer): string;
begin
  Result:='';StartPos:=0;EndPos:=0;
  ScanText(FFirstPos,IsMainOrderBegin);
  if FResultPos=0 then Exit;
  StartPos:=FResultPos;
  ScanText(FResultPos+5,IsByBegin);
  if FResultPos=0 then
   Exit;
  Result:=FastCopy(SQLText,FResultPos+2,MaxInt);
  EndPos:=Length(SQLText);
end;


function  TSQLParser.OrderClause:string;
var
  StartPos, EndPos: integer;
begin
  Result:=OrderText(StartPos, EndPos)
end;

function TSQLParser.SetOrderClause(const Value:string):string;
var
  StartPos, EndPos: integer;
begin
 OrderText(StartPos, EndPos);
 if StartPos=0 then
 begin
   if FastTrim(Value)='' then
    Result := SQLText
   else
    Result := FastTrim(SQLText)+CLRF+ 'ORDER BY '+Value;
 end
 else
 begin
   if FastTrim(Value)='' then
    Result := FastCopy(SQLText,1,StartPos-1)
   else
    if SQLText[StartPos-1]<>#10 then
     Result := FastCopy(SQLText,1,StartPos-1)+CLRF+ 'ORDER BY '+Value
    else
     Result := FastCopy(SQLText,1,StartPos-1)+ 'ORDER BY '+Value
 end;
end;

function    TSQLParser.GroupByText(var StartPos,EndPos:integer):string;
var
  byPos:integer;
begin
  Result:='';StartPos:=0;EndPos:=0;
  ScanText(FFirstPos,IsMainGroupBegin);
  if FResultPos=0 then
   Exit;
  StartPos:=FResultPos;
  ScanText(FResultPos+5,IsByBegin);
  if FResultPos=0 then
   Exit;
  byPos:=FResultPos;
  ScanText(StartPos,IsHaving);
  if FResultPos=0 then
   ScanText(StartPos,IsPlanBegin);
  if FResultPos=0 then
   ScanText(StartPos,IsOrderBegin);


  if FResultPos=0 then
  begin
   Result:=FastCopy(SQLText,byPos+2,MaxInt);
   EndPos:=Length(SQLText);
  end
  else
  begin
   Result:=FastCopy(SQLText,byPos+2,FResultPos-byPos-2);
   EndPos:=FResultPos-1;
  end;
end;

function    TSQLParser.GroupByClause:string;
var
  StartPos, EndPos: integer;
begin
 Result:=GroupByText(StartPos, EndPos);
end;

function    TSQLParser.SetGroupClause(const Value:string):string;
var
  StartPos, EndPos: integer;
  StartPosO, EndPosO: integer;
begin
 GroupByText(StartPos, EndPos);
 if StartPos=0 then
 begin
   if FastTrim(Value)='' then
    Result := SQLText
   else
   begin
     ScanText(FFirstPos,IsHaving);
     if FResultPos<>0 then
      StartPosO:=FResultPos
     else
     begin
      MainPlanText(StartPosO, EndPosO);
      if StartPosO=0 then
       OrderText(StartPosO, EndPosO);
     end;
     if StartPosO=0 then
      Result := FastTrim(SQLText)+CLRF+ 'GROUP BY '+Value
     else
      Result := FastTrim(FastCopy(SQLText,1,StartPosO-1))+CLRF+
       'GROUP BY '+Value+  CLRF+FastCopy(SQLText,StartPosO,MaxInt)
   end;
 end
 else
 if FastTrim(Value)='' then
   Result := FastCopy(SQLText,1,StartPos-1)+FastCopy(SQLText,EndPos+1,MaxInt)
 else
 begin
   if SQLText[StartPos-1]<>#10 then
     Result := FastCopy(SQLText,1,StartPos-1)+CLRF+ 'GROUP BY '+Value
   else
     Result := FastCopy(SQLText,1,StartPos-1)+ 'GROUP BY '+Value
 end;
end;

function TSQLParser.GetFieldsClause:string;
var
    pb:integer;
    pe:integer;
begin
  if SQLKind<>skSelect then
   Result := ''
  else
  begin
    pe:=DispositionMainFrom.X-1;
    pb:=FFirstPos+6;
    while (pb<=Length(SQLText)) and (SQLText[pb] in [#13,#10,#9,' ']) do
     Inc(pb);
    while (pe>=1) and (SQLText[pe] in [#13,#10,#9,' ']) do
     Dec(pe);
    Result:=FastCopy(SQLText,pb,pe-pb+1);
  end;
end;

function    TSQLParser.SetFieldsClause(const NewFields:string):string;
var
    pb:integer;
    pe:integer;
begin
  if SQLKind<>skSelect then
   Result:=SQLText
  else
  begin
    pe:=DispositionMainFrom.X;
    pb:=FFirstPos+5;
    Result:=FastCopy(SQLText,1,pb)+CLRF+NewFields+CLRF+FastCopy(SQLText,pe,MaxInt);
  end;
end;

function TSQLParser.WhereClause(N: integer; var StartPos,
  EndPos: integer): string;
var StartPos1:integer;  
begin
    if N<0 then
    begin
      Result:=''; StartPos:=0;EndPos:=0;Exit;
    end;

    FReserved :=N; // N- number where clause
    FReserved1:=0;
    ScanText(FFirstPos,IsWhereBegin);
    if FResultPos>0 then
    begin
     StartPos :=FResultPos;
     StartPos1:=FResultPos+5;
     FScanInBrackets:=FBracketOpened>0;
     while (StartPos1<=Len) and (SQLText[StartPos1] in (CharsAfterClause - ['(','/'])) do
      Inc(StartPos1);
     ScanText(StartPos1,IsWhereEnd);
     EndPos:=FResultPos;
     if EndPos>0 then
     begin
       if EndPos<>Length(SQLText) then
        Dec(EndPos);
       while (EndPos>0) and (SQLText[EndPos] in (CharsAfterClause - ['(','/'])) do
        Dec(EndPos);
       Result:= FastCopy(SQLText,StartPos1,EndPos-StartPos1+1);
     end
     else
      StartPos:=0;
    end;
end;

function  TSQLParser.SetWhereClause(N:Integer;const Value:string):string;
var
  StartPos, EndPos: integer;
begin
  WhereClause(N,StartPos, EndPos);
  if StartPos=0 then
   Result := SQLText
  else
  begin
   if FastTrim(Value)='' then
    Result:=FastCopy(SQLText,1,StartPos-1)+CLRF + FastCopy(SQLText,EndPos+1,MaxInt)
   else
   begin
    if SQLText[StartPos-1]<>#10 then
     Result:=FastCopy(SQLText,1,StartPos-1)+CLRF+ 'WHERE ' + Value
    else
     Result:=FastCopy(SQLText,1,StartPos-1)+'WHERE ' +Value ;
    if SQLText[EndPos+1]<>#13 then
     Result:=Result + CLRF + FastCopy(SQLText,EndPos+1,MaxInt)
    else
     Result:=Result +  FastCopy(SQLText,EndPos+1,MaxInt)    ;
   end;
  end;
end;

function TSQLParser.SetMainWhereClause(const Value:string):string;
var p:integer;
begin
 p:=MainWhereIndex;
 if p>0 then
  Result:=SetWhereClause(p,Value)
 else
  Result:=AddToMainWhere(Value,False);
end;

function TSQLParser.WhereCount: integer;
begin
   Result:=0;
   FReserved:=0;
   repeat
    ScanText(FResultPos+5,IsWhereBegin);
    if FResultPos>0 then  Inc(Result);
   until FResultPos=0;
end;

function TSQLParser.PlanCount:integer;
begin
   Result:=0;
   FReserved:=0;
   repeat
    ScanText(FResultPos+5,IsPlanBegin);
    if FResultPos>0 then  Inc(Result);
   until FResultPos=0;
end;

function TSQLParser.PlanText(N:integer;var  StartPos,EndPos:integer):string;
begin
    if N<0 then
    begin
      Result:=''; StartPos:=0;EndPos:=0;Exit;
    end;

    FReserved1:=0;
    FResultPos:=0;
    FReserved :=N; // N- number plan clause
    ScanText(FFirstPos,IsPlanBegin);
    if FResultPos>0 then
    begin
     StartPos:=FResultPos+5;
     FScanInBrackets:=FBracketOpened>0;
     while (StartPos<=Len) and (SQLText[StartPos] in CharsAfterClause) do
      Inc(StartPos);
     ScanText(StartPos,IsPlanEnd);
     EndPos:=FResultPos;
     if EndPos>0 then
     begin
       Dec(EndPos);
       while (EndPos>0) and (SQLText[EndPos] in CharsAfterClause) do
        Dec(EndPos);
       Result:= FastCopy(SQLText,StartPos,EndPos-StartPos+1)
     end
     else
      StartPos:=0;
    end;
end;

function  TSQLParser.MainPlanIndex:integer;
var
    p:integer;
begin
  p:=0; Result:=-1;
  FReserved :=0;
  FReserved1:=0;
  FResultPos:=FFirstPos;
  repeat
    ScanText(FResultPos+5,IsPlanBegin);
    if FResultPos>0 then
    begin
      Inc(p);
      if FBracketOpened=0 then
      begin
        Result:=p;
        Exit;
      end;
    end;
  until FResultPos=0;
end;

function  TSQLParser.MainPlanText(var  StartPos,EndPos:integer):string;
begin
 Result:=PlanText(MainPlanIndex,StartPos,EndPos)
end;

function  TSQLParser.SetMainPlan(const Text:string):string;
var
    StartPos,EndPos:integer;
begin
  MainPlanText(StartPos,EndPos);
  if StartPos>0 then
  begin
    if FastTrim(Text)<>'' then
     Result:=FastCopy(SQLText,1,StartPos-1)+Text+FastCopy(SQLText,EndPos+1,MaxInt)
    else
     Result:=FastCopy(SQLText,1,StartPos-6)+FastCopy(SQLText,EndPos+1,MaxInt)
  end
  else
  if FastTrim(Text)='' then
   Result:=SQLText
  else
  begin
    OrderText(StartPos,EndPos);
    if StartPos>0 then
    begin
      Result:=FastCopy(SQLText,1,StartPos-1);
      if Result[Length(Result)]<>#10 then Result:=Result+CLRF;
      Result:=Result+'PLAN '+Text+ CLRF+
       FastCopy(SQLText,StartPos,MaxInt)
    end
    else
    if SQLText[Length(SQLText)]<>#10 then
     Result:=SQLText+CLRF+'PLAN '+Text
    else
     Result:=SQLText+'PLAN '+Text
  end;
end;

function    TSQLParser.GetMainPlan:string;
var
    StartPos,EndPos:integer;
begin
  Result:=MainPlanText(StartPos,EndPos)
end;

function TSQLParser.MainWhereIndex: integer;
var
    p:integer;
begin
  p:=0; Result:=-1;
  FResultPos:=0;
  repeat
    ScanText(FResultPos+5,IsWhereBegin);
    if FResultPos>0 then
    begin
      Inc(p);
      if FBracketOpened=0 then
      begin
        Result:=p;
        Exit;
      end;
    end;
  until FResultPos=0;
end;

function TSQLParser.AddToMainWhere(const NewClause: string;
  ForceCLRF: boolean): string;
var p:integer;
    StartPos,EndPos:integer;
    CLRF :string;
begin
  CLRF :=iifStr(ForceCLRF,ForceNewStr,'');
  if IsBlank(NewClause) then
  begin
    Result:=SQLText;  Exit
  end;
  p:=MainWhereIndex;
  if p>=0 then
  begin
   WhereClause(p, StartPos,EndPos);
   Result:=
     FastCopy(SQLText,1,StartPos+4)+
      '( '+FastCopy(SQLText,StartPos+5,EndPos-StartPos-4)+CLRF+
      ' ) and ( '+NewClause+' )'+CLRF+
      FastCopy(SQLText,EndPos+1,MaxInt);
  end
  else
  begin
    p     :=DispositionMainFrom.Y;
    Result:=
      FastCopy(SQLText,1,p)+#13#10+BeginWhere+CLRF+NewClause+#13#10+FastCopy(SQLText,p+1,MaxInt)
  end
end;

function   TSQLParser.IsWith(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=3)  and
         (SQLText[Position]   in ['W','w'])   and
         (SQLText[Position+1] in ['I','i'])   and
         (SQLText[Position+2] in ['T','t'])   and
         (SQLText[Position+3] in ['H','h']);
 if Result and (Len-Position>3) then
   Result:= (SQLText[Position+4] in CharsAfterClause)
end ;

function   TSQLParser.IsSelect(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=5)  and
         (SQLText[Position]   in ['S','s'])   and
         (SQLText[Position+1] in ['E','e'])   and
         (SQLText[Position+2] in ['L','l'])   and
         (SQLText[Position+3] in ['E','e'])   and
         (SQLText[Position+4] in ['C','c'])   and
         (SQLText[Position+5] in ['T','t']);
 if Result and (Len-Position>5) then
   Result:= (SQLText[Position+6] in CharsAfterClause)
end;

function   TSQLParser.IsAs(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=2)  and
         (SQLText[Position]   in ['A','a'])   and
         (SQLText[Position+1] in ['S','s'])   ;
 if Result and (Len-Position>1) then
   Result:= (SQLText[Position+2] in CharsAfterClause)
end;

function   TSQLParser.IsDDLBegin(Position:integer):boolean;
begin
 Result:=False;
 if  ((Position=1) or (SQLText[Position-1] in CharsBeforeClause)) then
 case SQLText[Position] of
  'A','a': if (Len-Position>=4)  then
           begin
            Result:=(SQLText[Position+1] in ['L','l'])   and
                 (SQLText[Position+2] in ['T','t'])   and
                 (SQLText[Position+3] in ['E','e'])   and
                 (SQLText[Position+4] in ['R','r'])   ;
             if Result and (Len-Position>4) then
              Result:= (SQLText[Position+5] in CharsAfterClause)
           end;
  'C','c': if (Len-Position>=5)  then
           begin
            Result:=(SQLText[Position+1] in ['R','r'])   and
                 (SQLText[Position+2] in ['E','e'])   and
                 (SQLText[Position+3] in ['A','a'])   and
                 (SQLText[Position+4] in ['T','t'])  and
                 (SQLText[Position+5] in ['E','e'])

                  ;
             if Result and (Len-Position>5) then
              Result:= (SQLText[Position+6] in CharsAfterClause)
           end;
  'R','r': if (Len-Position>=7)  then
           begin
            Result:=(SQLText[Position+1] in ['E','e'])   and
                 (SQLText[Position+2] in ['C','c'])   and
                 (SQLText[Position+3] in ['R','r'])   and
                 (SQLText[Position+4] in ['E','e'])   and
                 (SQLText[Position+5] in ['A','a'])   and
                 (SQLText[Position+6] in ['T','t'])  and
                 (SQLText[Position+7] in ['E','e'])

                  ;
             if Result and (Len-Position>7) then
              Result:= (SQLText[Position+8] in CharsAfterClause)
           end;

 end
end;

function   TSQLParser.IsProcedure(Position:integer):boolean;
begin
Ftables.Add('SELECT RDB$RELATION_NAME FROM RDB$RELATIONS WHERE RDB$RELATION_NAME = ''MY_TABLE_NAME''');
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=8)  and
         (SQLText[Position]   in ['P','p'])   and
         (SQLText[Position+1] in ['R','r'])   and
         (SQLText[Position+2] in ['O','o'])   and
         (SQLText[Position+3] in ['C','c'])   and
         (SQLText[Position+4] in ['E','e'])   and
         (SQLText[Position+5] in ['D','d'])   and
         (SQLText[Position+6] in ['U','u'])   and
         (SQLText[Position+7] in ['R','r'])   and
         (SQLText[Position+8] in ['E','e'])
         ;
 if Result and (Len-Position>8) then
   Result:= (SQLText[Position+9] in CharsAfterClause)
end;

//stProcedure
function   TSQLParser.IsSet(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=2)  and
         (SQLText[Position]   in ['S','s'])   and
         (SQLText[Position+1] in ['E','e'])   and
         (SQLText[Position+2] in ['T','t'])   ;
 if Result and (Len-Position>2) then
  Result:= (SQLText[Position+3] in CharsAfterClause)
end;

function   TSQLParser.IsUpdate(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=5)  and
         (SQLText[Position]   in ['U','u'])   and
         (SQLText[Position+1] in ['P','p'])   and
         (SQLText[Position+2] in ['D','d'])   and
         (SQLText[Position+3] in ['A','a'])   and
         (SQLText[Position+4] in ['T','t'])   and
         (SQLText[Position+5] in ['E','e'])   ;
 if Result and (Len-Position>5) then
  Result:= (SQLText[Position+6] in CharsAfterClause)
end;


function   TSQLParser.IsDelete(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=5)  and
         (SQLText[Position]   in ['D','d'])   and
         (SQLText[Position+1] in ['E','e'])   and
         (SQLText[Position+2] in ['L','l'])   and
         (SQLText[Position+3] in ['E','e'])   and
         (SQLText[Position+4] in ['T','t'])   and
         (SQLText[Position+5] in ['E','e'])   ;
  if Result and (Len-Position>5) then
   Result :=  (SQLText[Position+6] in CharsAfterClause)
end;

function   TSQLParser.IsInsert(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=5)  and
         (SQLText[Position]   in ['I','i'])   and
         (SQLText[Position+1] in ['N','n'])   and
         (SQLText[Position+2] in ['S','s'])   and
         (SQLText[Position+3] in ['E','e'])   and
         (SQLText[Position+4] in ['R','r'])   and
         (SQLText[Position+5] in ['T','t'])   ;
  if Result and (Len-Position>5) then
   Result := (SQLText[Position+6] in CharsAfterClause)
end;

function   TSQLParser.IsReturning(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=8)  and
         (SQLText[Position]   in ['R','r'])   and
         (SQLText[Position+1] in ['E','e'])   and
         (SQLText[Position+2] in ['T','t'])   and
         (SQLText[Position+3] in ['U','u'])   and
         (SQLText[Position+4] in ['R','r'])   and
         (SQLText[Position+5] in ['N','n'])   and
         (SQLText[Position+6] in ['I','i'])   and
         (SQLText[Position+7] in ['N','n'])   and
         (SQLText[Position+8] in ['G','g'])   ;
  if Result and (Len-Position>8) then
   Result := (SQLText[Position+9] in CharsAfterClause)
end;

function   TSQLParser.IsReturningValues(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=15)  and
         (SQLText[Position]   in ['R','r'])   and
         (SQLText[Position+1] in ['E','e'])   and
         (SQLText[Position+2] in ['T','t'])   and
         (SQLText[Position+3] in ['U','u'])   and
         (SQLText[Position+4] in ['R','r'])   and
         (SQLText[Position+5] in ['N','n'])   and
         (SQLText[Position+6] in ['I','i'])   and
         (SQLText[Position+7] in ['N','n'])   and
         (SQLText[Position+8] in ['G','g'])   and
         (SQLText[Position+9]  = '_'      )   and
         (SQLText[Position+10]in ['V','v'])   and
         (SQLText[Position+11]in ['A','a'])   and
         (SQLText[Position+12]in ['L','l'])   and
         (SQLText[Position+13]in ['U','u'])   and
         (SQLText[Position+14]in ['E','e'])   and
         (SQLText[Position+15]in ['S','s'])   ;

  if Result and (Len-Position>15) then
   Result := (SQLText[Position+16] in CharsAfterClause)
end;

function   TSQLParser.IsInto(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=3)  and
         (SQLText[Position]   in ['I','i'])   and
         (SQLText[Position+1] in ['N','n'])   and
         (SQLText[Position+2] in ['T','t'])   and
         (SQLText[Position+3] in ['O','o'])   ;
  if Result and (Len-Position>3) then
   Result:= (SQLText[Position+4] in CharsAfterClause)
end;

function   TSQLParser.IsValues(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=5)  and
         (SQLText[Position]   in ['V','v'])   and
         (SQLText[Position+1] in ['A','a'])   and
         (SQLText[Position+2] in ['L','l'])   and
         (SQLText[Position+3] in ['U','u'])   and
         (SQLText[Position+4] in ['E','e'])   and
         (SQLText[Position+5] in ['S','s'])   ;
         ;
  if Result and (Len-Position>5) then
   Result:= (SQLText[Position+6] in CharsAfterClause)
end;


function TSQLParser.IsExecute(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=6)  and
         (SQLText[Position]   in ['E','e'])   and
         (SQLText[Position+1] in ['X','x'])   and
         (SQLText[Position+2] in ['E','e'])   and
         (SQLText[Position+3] in ['C','c'])   and
         (SQLText[Position+4] in ['U','u'])   and
         (SQLText[Position+5] in ['T','t'])   and
         (SQLText[Position+6] in ['E','e'])   ;
  if Result and (Len-Position>6) then
   Result:= (SQLText[Position+7] in CharsAfterClause)

end;


function   TSQLParser.IsException(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=8)  and
         (SQLText[Position]   in ['E','e'])   and
         (SQLText[Position+1] in ['X','x'])   and
         (SQLText[Position+2] in ['C','c'])   and
         (SQLText[Position+3] in ['E','e'])   and
         (SQLText[Position+4] in ['P','p'])   and
         (SQLText[Position+5] in ['T','t'])   and
         (SQLText[Position+6] in ['I','i'])   and
         (SQLText[Position+7] in ['O','o'])   and
         (SQLText[Position+8] in ['N','n'])   ;

  if Result and (Len-Position>8) then
   Result:= (SQLText[Position+9] in CharsAfterClause)

end;

function   TSQLParser.IsExecuteBlock(Position:integer):boolean;
var
  vPosition:integer;
begin
 if not IsExecute(Position) then
  Result := False
 else
 begin
    vPosition:=Position+7;
    SkipCommentsAndBlanks(SQLText,Len,vPosition);
    Result:=
         (Len-vPosition>=5)  and
         (SQLText[vPosition]   in ['B','b'])   and
         (SQLText[vPosition+1] in ['L','l'])   and
         (SQLText[vPosition+2] in ['O','o'])   and
         (SQLText[vPosition+3] in ['C','c'])   and
         (SQLText[vPosition+4] in ['K','k'])   and
         (SQLText[vPosition+5] in CharsAfterClause)
 end;
end;

function   TSQLParser.IsBegin(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=4)  and
         (SQLText[Position]   in ['B','b'])   and
         (SQLText[Position+1] in ['E','e'])   and
         (SQLText[Position+2] in ['G','g'])   and
         (SQLText[Position+3] in ['I','i'])   and
         (SQLText[Position+4] in ['N','n'])   ;

  if Result and (Len-Position>4) then
   Result := (SQLText[Position+5] in CharsAfterClause)
end;

function   TSQLParser.IsCase(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause+['(']))and
         (Len-Position>=3)  and
         (SQLText[Position]   in ['C','c'])   and
         (SQLText[Position+1] in ['A','a'])   and
         (SQLText[Position+2] in ['S','s'])   and
         (SQLText[Position+3] in ['E','e'])   ;


  if Result and (Len-Position>3) then
   Result := (SQLText[Position+4] in CharsAfterClause)
end;

function   TSQLParser.IsEnd(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause+[')']))and
         (Len-Position>=2)  and
         (SQLText[Position]   in ['E','e'])   and
         (SQLText[Position+1] in ['N','n'])   and
         (SQLText[Position+2] in ['D','d'])   ;

  if Result and (Len-Position>2) then
   Result := (SQLText[Position+3] in CharsAfterClause+[')',',','^'])
end;

function   TSQLParser.IsExecuteProc(Position:integer):boolean;
var
  vPosition:integer;
begin
 if not IsExecute(Position) then
  Result := False
 else
 begin
    vPosition:=Position+7;
    SkipCommentsAndBlanks(SQLText,Len,vPosition);
    Result:=
         (Len-Position>=9)  and
         (SQLText[vPosition]   in ['P','p'])   and
         (SQLText[vPosition+1] in ['R','r'])   and
         (SQLText[vPosition+2] in ['O','o'])   and
         (SQLText[vPosition+3] in ['C','c'])   and
         (SQLText[vPosition+4] in ['E','e'])   and
         (SQLText[vPosition+5] in ['D','d'])   and
         (SQLText[vPosition+6] in ['U','u'])   and
         (SQLText[vPosition+7] in ['R','r'])   and
         (SQLText[vPosition+8] in ['E','e'])   and
         (SQLText[vPosition+9] in CharsAfterClause)
 end;   
end;

function TSQLParser.IsDDL:boolean;
var
  vPosition: Integer;


begin
  Result:= (Len>0) and  ((FFirstPos=1) or (SQLText[FFirstPos-1] in CharsBeforeClause));
  if Result then
  case SQLText[FFirstPos] of
    'A','a':
      begin
       Result:=
          (Len-FFirstPos>=5)  and
          (SQLText[FFirstPos+1] in ['L','l'])   and
          (SQLText[FFirstPos+2] in ['T','t'])   and
          (SQLText[FFirstPos+3] in ['E','e'])   and
          (SQLText[FFirstPos+4] in ['R','r'])   and
          (SQLText[FFirstPos+5] in CharsAfterClause);
      end;
    'C','c':
     begin
        Result:=
          (Len-FFirstPos>=6)  and
          (SQLText[FFirstPos+1] in ['R','r'])   and
          (SQLText[FFirstPos+2] in ['E','e'])   and
          (SQLText[FFirstPos+3] in ['A','a'])   and
          (SQLText[FFirstPos+4] in ['T','t'])   and
          (SQLText[FFirstPos+5] in ['E','e'])   and
          (SQLText[FFirstPos+6] in CharsAfterClause);
     end;
    'D','d':
     begin
      Result:=
          (Len-FFirstPos>=4)  and
          (SQLText[FFirstPos+1] in ['R','r'])   and
          (SQLText[FFirstPos+2] in ['O','o'])   and
          (SQLText[FFirstPos+3] in ['P','p'])   and
          (SQLText[FFirstPos+4] in CharsAfterClause);
     end;
    'G', 'g': Result:=
              (Len-FFirstPos>=5)  and
              (SQLText[FFirstPos+1] in ['R','r'])   and
              (SQLText[FFirstPos+2] in ['A','a'])   and
              (SQLText[FFirstPos+3] in ['N','n'])   and
              (SQLText[FFirstPos+4] in ['T','t'])   and
              (SQLText[FFirstPos+5] in CharsAfterClause);
    'R','r':
    begin
         Result:=
          (Len-FFirstPos>=8)  and
          (SQLText[FFirstPos+1] in ['E','e'])   and
          (SQLText[FFirstPos+2] in ['C','c'])   and
          (SQLText[FFirstPos+3] in ['R','r'])   and
          (SQLText[FFirstPos+4] in ['E','e'])   and
          (SQLText[FFirstPos+5] in ['A','a'])   and
          (SQLText[FFirstPos+6] in ['T','t'])   and
          (SQLText[FFirstPos+7] in ['E','e'])   and
          (SQLText[FFirstPos+8] in CharsAfterClause);
    end;
    'S', 's':
    begin
        if
             (Len-FFirstPos>=3)  and
             (SQLText[FFirstPos+1] in ['E','e'])   and
             (SQLText[FFirstPos+2] in ['T','t'])   and
             (SQLText[FFirstPos+3] in CharsAfterClause) then
            begin
             vPosition := FFirstPos+4;
             while (vPosition <= Len) and (SQLText[vPosition] in CharsBeforeClause) do
              Inc(vPosition);
             Result:=
              (Len-vPosition>=9)  and
              (SQLText[vPosition] in ['G','g'])   and
              (SQLText[vPosition+1] in ['E','e'])   and
              (SQLText[vPosition+2] in ['N','n'])   and
              (SQLText[vPosition+3] in ['E','e'])   and
              (SQLText[vPosition+4] in ['R','r'])   and
              (SQLText[vPosition+5] in ['A','a'])   and
              (SQLText[vPosition+6] in ['T','t'])   and
              (SQLText[vPosition+7] in ['O','o'])   and
              (SQLText[vPosition+8] in ['R','r'])   and
              (SQLText[vPosition+9] in CharsAfterClause);
            end;

    end;
  else
   Result:=False;
  end;
end;

function TSQLParser.GetSQLKind: TSQLKind;
begin
 if IsSelect(FFirstPos)  then
  Result:=skSelect
 else
 if IsUpdate(FFirstPos)  then
  Result:=skUpdate
 else
 if IsDelete(FFirstPos)  then
  Result:=skDelete
 else
 if IsInsert(FFirstPos)  then
  Result:=skInsert
 else
 if IsExecuteProc(FFirstPos) then
  Result:=skExecuteProc
 else
 if IsExecuteBlock(FFirstPos) then
  Result:=skExecuteBlock
 else
 if IsDDL    then
  Result:=skDDL
 else
 if IsWith(FFirstPos) then
   Result:=skSelect
 else
  Result:=skUnknown;
// FCanParamsCheck:=not (Result in [skDDL,skUnknown]);
 FCanParamsCheck:=not (Result in [skDDL]);
end;


function TSQLParser.RecCountSQLText: string;
var fr:TPoint;
    StartWhere,EndWhere:integer;
    wh:string;
begin
 Result:='';
 if SQLKind<>skSelect then
  Exit;
 fr:=DispositionMainFrom;
 if fr.x=0 then Exit;
 Result:='Select Count(*) '+FastCopy(SQLText,fr.x,fr.y-fr.x+1);
 wh:=MainWhereClause(StartWhere,EndWhere);
 if wh<>'' then
  Result:=Result+#13#10+BeginWhere+wh;
end;

function TSQLParser.MainWhereClause(var StartPos, EndPos: integer): string;
begin
 FResultPos:=0;
 Result:=WhereClause(MainWhereIndex,StartPos,EndPos)
end;

procedure TSQLParser.FillMainTables(WithSP:boolean=False);
var
    FromPos:TPoint;
    FromTxt:string;
    i,p,p1:integer;
    tmpStr:string;
    wc:integer;
    InQuote:boolean;
begin
   FTables.Clear;
   FromPos:=DispositionMainFrom;
   if FromPos.X>0 then
     if FromPos.Y=Length(SQLText) then
      FromTxt:=FastCopy(SQLText,FromPos.X+5,MaxInt)
     else
      FromTxt:=FastCopy(SQLText,FromPos.X+5,FromPos.Y-FromPos.X-5)
   else
    FromTxt:='';
   if Length(FromTxt)= 0 then
    Exit;
   FromTxt:=RemoveComments(FromTxt);
   i:=1; p:=0;
   SetLength(tmpStr,Length(FromTxt));
   InQuote:=False;
   while i<=Length(FromTxt) do
   begin
    if not InQuote and (FromTxt[i] in CharsAfterClause-['(']) then
    begin
      if p=0 then
       Inc(i)
      else
      if FromTxt[i-1] in CharsAfterClause -['('] then
       Inc(i)
      else
      begin
        Inc(p);
        tmpStr[p]:=' ';
        Inc(i);
      end;
    end
    else
    begin
      Inc(p);
      tmpStr[p]:=FromTxt[i];
      Inc(i);
      if tmpStr[p] = '"' then
       InQuote:= not InQuote;
    end;
   end;
   if tmpStr[p]=' ' then
    Dec(p);
   SetLength(tmpStr,p);
   FromTxt:=tmpStr;
   FromTxt:=RemoveJoins(FromTxt);
   if PosCh('(',FromTxt)>0 then
    FromTxt:=RemoveSP(FromTxt,WithSP);
   wc:=WordCount(FromTxt,[',']);
   for  i:=1  to wc do
   begin
    tmpStr:=ExtractWord(i, FromTxt,[',']);
    DoTrim(tmpStr);
    if Length(tmpStr) > 0 then
    begin
     p:=PosCh1('"',tmpStr,2);
     if p=0 then
       DoUpperCase(tmpStr)
     else
     begin
       p1:=PosCh1('"',tmpStr,p+1);
       case tmpStr[1]   of
        '"':
        begin
          if p1=0 then
          begin
            DoUpperCase(tmpStr,p+1,MaxInt);
          end;
        end;
       else
        DoUpperCase(tmpStr,1,p-1);
        if p1=0 then
        begin
          DoUpperCase(tmpStr,p+1,MaxInt);
        end;
       end;
     end;
     FTables.Add(tmpStr);
    end;
   end;
end;

function TSQLParser.GetAllTables(WithSP:boolean=False): TStrings;
begin
 if FTables.Count=0 then
 begin
   case SQLKind of    //
     skSelect:
     begin
       FillMainTables(WithSP);
     end;
   else
     FTables.Text:=ModifiedTables;
   end;
 end;
 Result:=FTables
end;



function  GetFieldByAlias(const SQLText,FieldName:string):string;
var
  p:integer;
  cBracket:integer;
  Step:byte;
begin
  p:=PosExtCI(FieldName,SQLText,CharsBeforeClause,CharsAfterClause+[',']);
  if p=0 then
   p:=PosExtCI('"'+FieldName+'"',SQLText,CharsBeforeClause,CharsAfterClause+[',']);

  Dec(p);
  if p<=0 then
  begin
    Result:='';
    Exit;
  end
  else
  if SQLText[p]='"' then
   Dec(p);

  while (p>0) and (SQLText[p] in CharsAfterClause) do
   Dec(p);

  if (p=0) or (SQLText[p]=',') then
  begin
    Result:=FieldName;
    Exit;
  end;
  if p>3 then
  begin
    if SQLText[p] in ['S','s'] then
     if SQLText[p-1] in ['A','a'] then
      if SQLText[p-2] in CharsAfterClause+[')'] then
       Dec(p,2);
  end;
  while (p>0) and (SQLText[p] in CharsAfterClause+[#10]) do
   Dec(p);
  if (p=0) or (SQLText[p]=',') then
  begin
    Result:=FieldName;
    Exit;
  end;
  if SQLText[p]<>')' then
   begin
    Result := '';
    Step:=1;
(* Step
   1 - Ќакапливаем им€ пол€ и ожидаем точку
   2 - ожидаем точку
   3 - точку дождались , пропускаем пробелы после имени таблицы
   4 - накапливаем им€ таблицы, ждем пробелов чтоб завершитьс€

*)

    while (p>0) do
    begin
       case SQLText[p] of
        ',': Break;
        '.':
        begin
         if Step in[1,2] then
          Step:=3;
         Result := SQLText[p]+Result;
        end;
       else
        if  not (SQLText[p] in CharsAfterClause)  then
        begin
         case Step of
          2: Break;        // “очки не дождались выходим
          3: Step:=4
         end;
         Result := SQLText[p]+Result;
        end
        else
        case Step of
         1: Step:=2;
         4: Break
        end
       end;
       Dec(p);
    end;
   end
  else
   begin
     cBracket:=1;
     Result:='';
     Dec(p);
     while (cBracket>0) and (p>0) do
     begin
       if SQLText[p]='(' then Dec(cBracket);
       if SQLText[p]=')' then Inc(cBracket);
       if (cBracket>0)then
        Result:=SQLText[p]+ Result ;
       Dec(p);
     end;
     while (p>0) and (SQLText[p] in CharsAfterClause+[#10]) do
      Dec(p);
     while (p>0) and not (SQLText[p] in CharsAfterClause+[',']) do
     begin
       Result := SQLText[p]+Result;
       Dec(p);
     end;
   end;
   case Length(Result) of
    2: if (Result[1] in ['O','o']) and (Result[2] in ['R','r']) then
        Result:='';
    3: if (Result[1] in ['A','a']) and (Result[2] in ['N','n']) and (Result[3] in ['D','d']) then
        Result:='';
   end;
end;

function  GetLinkFieldName(const SQLText,ParamName: string): string;
var Ind:integer;
    Wh:string;
    StartPos,EndPos:integer;
    c,p:integer;
begin
  Result:='';
  c:=WhereCount(SQLText);
  Ind:=1;
  while Ind<=c do
  begin
   Wh:=GetWhereClause(SQLText,Ind,StartPos,EndPos);
   p:=PosExtCI(':'+ParamName,Wh,
    CharsBeforeClause+endLexem,CharsAfterClause+endLexem
   )-1;
   while (p>0) and (wh[p] in CharsBeforeClause+endLexem+[':',#13]) do
    Dec(p);
   if p>0 then
   begin
    while (p>0) and not (wh[p] in CharsBeforeClause+endLexem+[':']) do
    begin
     Result:=wh[p]+Result;
     Dec(p);
    end;
    Exit;
   end;

   p:=PosExtCI('?'+ParamName,Wh,
    CharsBeforeClause+endLexem,CharsAfterClause+endLexem
   )-1;
   while (p>0) and (wh[p] in CharsBeforeClause+endLexem+['?',#13]) do Dec(p);
   if p>0 then
   begin
    while (p>0) and not (wh[p] in CharsBeforeClause+endLexem+['?']) do
    begin
     Result:=wh[p]+Result;
     Dec(p);
    end;
    Exit;
   end;
   Inc(Ind);
  end;  
end;

 function  IsWhereBeginPos(const SQLText:string;Position:integer):boolean;
 var Len:integer;
 begin
  Len:=Length(SQLText);
  Result:=(Position>1) and (Len-Position>=4)
   and (SQLText[Position]   in ['W','w'])
   and (SQLText[Position+1] in ['H','h'])
   and (SQLText[Position+2] in ['E','e'])
   and (SQLText[Position+3] in ['R','r'])
   and (SQLText[Position+4] in ['E','e'])
   and (SQLText[Position-1] in CharsBeforeClause);
  if Result and (Len-Position>4) then
   Result:=(SQLText[Position+5] in ['(']+CharsAfterClause);
 end;

function  IsWhereEndPos(const SQLText:string;Position:integer):boolean;
var
    p:integer;
    Len:integer;
begin
   Len:=Length(SQLText);
   p:=Position;
   Result := p=Len;
   if Result then  Exit;
   if (Len>P)and (P>1) and (SQLText[P-1] in CharsBeforeClause) then
   begin
    if (Len-P)>1 then
    case SQLText[P] of
    'F','f': // FOR UPDATE
     begin
      Result:=((Len-P)>=2) and
           (SQLText[P+1] in ['O','o']) and
           (SQLText[P+2] in ['R','r']) ;
      if Result and  ((Len-P)>2) then
       Result :=(SQLText[P+3] in CharsAfterClause);
     end;

    'G','g': //GROUP BY
    begin
      Result:=((Len-P)>=4) and
           (SQLText[P+1] in ['R','r']) and
           (SQLText[P+2] in ['O','o']) and
           (SQLText[P+3] in ['U','u']) and
           (SQLText[P+4] in ['P','p']) ;
      if Result and  ((Len-P)>4) then
       Result:= (SQLText[P+5] in CharsAfterClause);
    end;
    'H','h': //HAVING
     begin
      Result:=((Len-P)>=5)    and
           (SQLText[P+1] in ['A','a']) and
           (SQLText[P+2] in ['V','v']) and
           (SQLText[P+3] in ['I','i']) and
           (SQLText[P+4] in ['N','n']) and
           (SQLText[P+5] in ['G','g']) ;
      if Result and  ((Len-P)>5) then
       Result:=  (SQLText[P+6] in CharsAfterClause+['(']);
     end;
    'O','o'://ORDER BY
     begin
      Result:=((Len-P)>=4) and
           (SQLText[P+1] in ['R','r']) and
           (SQLText[P+2] in ['D','d']) and
           (SQLText[P+3] in ['E','e']) and
           (SQLText[P+4] in ['R','r']) ;
      if Result and  ((Len-P)>4) then
       Result:= (SQLText[P+5] in CharsAfterClause);
     end;
    'P','p': // PLAN
     begin
      Result:=((Len-P)>=3) and
           (SQLText[P+1] in ['L','l']) and
           (SQLText[P+2] in ['A','a']) and
           (SQLText[P+3] in ['N','n']) ;
      if Result and  ((Len-P)>3) then
       Result:=   (SQLText[P+4] in CharsAfterClause+['(']);
     end;
    'S','s':
     begin
      Result:=((Len-P)>=4) and
           (SQLText[P+1] in ['T','t']) and
           (SQLText[P+2] in ['A','a']) and
           (SQLText[P+3] in ['R','r']) and
           (SQLText[P+4] in ['T','t']) ;
      if Result and  ((Len-P)>4) then
       Result:=(SQLText[P+5] in CharsAfterClause);
     end; 

    'U','u':
     begin
      Result:=((Len-P)>=4) and
           (SQLText[P+1] in ['N','n']) and
           (SQLText[P+2] in ['I','i']) and
           (SQLText[P+3] in ['O','o']) and
           (SQLText[P+4] in ['N','n']) ;
      if Result and  ((Len-P)>4) then
       Result:=   (SQLText[P+5] in CharsAfterClause)
     end
    end;
  end
end;

 function  PosInSections(const SQLText:string;Position:integer):TSQLSections;
 var
    SQLPars:TSQLParser;
 begin
   SQLPars:=TSQLParser.Create(SQLText);
   try
    Result:=SQLPars.PosInSections(Position)
   finally
     SQLPars.Free
   end;
 end;


function  InvertOrderClause(const OrderText:string):string;
var
  I: Integer;
  State:byte; //0 - накапливаем им€ ,1 ждем ASC или DESC, 2 - ждем имени, 3 - collate
//0 - накапливаем им€ ,1 ждем ASC или DESC, 2 - ждем имени, 3,4 - collate,5 - закавыченное им€ пол€
  CurAsc:boolean ;
begin
   Result := '';
   if Length(OrderText) = 0 then
     Exit;
   I:=1;
   while (I<=Length(OrderText))  and (OrderText[I] in [' ',#13,#9,#10])  do
    Inc(I);

   State  :=0;
   CurAsc:=True;

   while I<=Length(OrderText)  do
   begin
     case State of
      0:
      begin
        case OrderText[I] of
         ' ',#13,#9,#10: State:=1;
         ',' :
         begin
           if CurAsc then
            Result:= Result +' desc,'
           else
            Result:= Result +',';
           while (I<Length(OrderText))  and (OrderText[I+1] in [' ',#13,#9,#10])  do
            Inc(I);
         end;
         '"':
         begin
          Result:=Result+'"';
          State:=5;
         end
        else
          Result := Result+ OrderText[I];
        end;
        Inc(I);
      end;
      1:
      begin
       case OrderText[I] of
          'A','a': Inc(I,2);
          'C','c':
          begin
           Result:=Result+OrderText[I-1]+OrderText[I];
           State:=3;
          end;
          'D','d':
          begin
           CurAsc:=False;
           Inc(I,3);
          end;
          ',':
          begin
            if CurAsc then
             Result:= Result +' desc,'
            else
             Result:= Result +',';
           State:=2;
           CurAsc:=True;
          end;
       end;
       Inc(I);
      end;
      2:
        if  (OrderText[I] in [' ',#13,#10,#9]) then
         Inc(I)
        else
         State:=0;
      3:
      while (I<=Length(OrderText))  do
      begin
       Result:=Result+OrderText[I];
       if  (OrderText[I] in [' ',#13,#10,#9]) then
       begin
        if State=3 then
        begin
         State:=4
        end
        else
        begin
          State:=1;
          Break;
        end;
       end;
       Inc(I);
      end;
      5:
      begin
        Result := Result+ OrderText[I];
        if OrderText[I]='"' then
         State:=0;
       Inc(I);
      end;
     end;
   end;
   if CurAsc then
     Result:= Result +' desc';
end;

function TSQLParser.GetBlocksPositions(FromPosition:integer; var EndPosition:integer; aLevel:integer=1;
    BeginLine:integer=1;BeginChar:integer=1
): TBlocksPositions;
var
   InBegin:boolean;
   Temp:TBlocksPositions;
   TempIndex:integer;
   CurIndex:integer;
   vEndLine:integer;
   vEndChar:integer;
begin
 FState:=sNormal;
 InBegin:=False;
 SetLength(Result,0);
{ vEndLine:=BeginLine+1;
 vEndChar:=BeginChar+1;}
 while FromPosition <Len do
 begin
  case SQLText[FromPosition] of
   '/': if (SQLText[FromPosition+1] ='*') and (FState = sNormal) then
        begin
         FState:=sComment;
         Inc(FromPosition);
//         Inc(vEndChar);
        end;
   '*': if (SQLText[FromPosition+1] ='/') and (FState = sComment) then
        begin
         FState:=sNormal;
         Inc(FromPosition);
//         Inc(vEndChar);
        end;
   '-': if (SQLText[FromPosition+1] ='-') and (FState = sNormal) then
        begin
         FState:=sFBComment;
         Inc(FromPosition);
        end;
   #13,#10 : begin
              if (FState = sFBComment) then
              begin
               FState:=sNormal;
              end;
//              else
              if SQLText[FromPosition]=#13 then
              begin
                if not InBegin then
                begin
                  BeginChar:=1;
                  Inc(BeginLine);
//                  vEndLine:=BeginLine;
                  Inc(FromPosition);
                  Continue;
                end
                else
                begin
                 Inc(vEndLine);
                 vEndChar:=1;
                 Inc(FromPosition);
                 Continue;

                end
              end
              else
              begin
               Inc(FromPosition);
               Continue;
              end;
             end;
   'B','b','C','c': if FState=sNormal then
              if IsBegin(FromPosition) or IsCase(FromPosition) then
               if InBegin then
               begin
                Temp:=GetBlocksPositions(FromPosition,FromPosition,aLevel+1,vEndLine,vEndChar);
                TempIndex:=Length(Result)-1;
                if Length(Temp)>0 then
                begin
                 vEndLine:=Temp[0].Y1.Y;
                 vEndChar:=Temp[0].Y1.X;
                 SetLength(Result,TempIndex+1+Length(Temp));
                 Move(Temp[0],Result[TempIndex+1],Length(Temp)*SizeOf(TBlockPosition))
                end
               end
               else
               begin
                 InBegin:=True;
                 CurIndex:=Length(Result);
                 SetLength(Result,Length(Result)+1);
                 Result[CurIndex].X:=FromPosition;
                 Result[CurIndex].Level:=aLevel;
                 Result[CurIndex].X1:=Point(BeginChar+1,BeginLine);

                 Inc(FromPosition,4);
                 vEndLine:=BeginLine;
                 vEndChar:=BeginChar+4;
                 Continue
               end;
    'E','e':if FState=sNormal then
             if InBegin then
              if IsEnd(FromPosition) then
               begin
                Result[CurIndex].Y:=FromPosition;
                Result[CurIndex].Y1:=Point(vEndChar+1,vEndLine);

                Result[CurIndex].Level:=aLevel;
                EndPosition:=FromPosition;

                BeginChar:=vEndChar;
                BeginLine:=vEndLine;
                if aLevel>1 then
                 Break
                else
                  InBegin:=False;
//                Inc(FromPosition,3)
               end

  end;
  Inc(FromPosition);
  if not InBegin then
  begin
    Inc(BeginChar);
  end
  else
   Inc(vEndChar)
 end;
end;

end.

