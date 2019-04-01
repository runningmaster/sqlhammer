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

unit ideSHTxtRtns;

(* BT {$I FIBPlus.inc} *)

interface
uses
 {$IFDEF MSWINDOWS}
  Windows,SysUtils,Classes,(* BT StrUtil *) ideSHStrUtil,
  (* BT {$IFDEF D6+}*) Variants (* BT {$ENDIF} *)
;

 {$ENDIF}
 {$IFDEF LINUX}
  Types, SysUtils, Classes, StrUtil
  , Variants;
 {$ENDIF}


type
  TSQLKind=(skUnknown,skSelect,skUpdate,skInsert,skDelete,skExecute,skDDL);
  TParserState =(sNormal,sQuote,sComment,sFBComment);
  TOnScanSQLText = procedure(Position:integer;var StopScan:boolean) of object;
  TChars = set of Char;

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
   FTables     :TStrings;
   FBracketOpenedBeforeScan:integer;
   procedure   SetSQLText(const Value: string);
   function    IsClause(Position:integer;const Clause:string):boolean;
   function    GetSQLKind:TSQLKind;
  protected
    procedure  IsOrderBegin(Position:integer;var Yes:boolean);
    procedure  IsByBegin(Position:integer;var Yes:boolean);
    procedure  IsMainOrderBegin(Position:integer;var Yes:boolean);
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

    function   IsSelect(Position:integer):boolean;
    function   IsUpdate(Position:integer):boolean;
    function   IsDelete(Position:integer):boolean;
    function   IsInsert(Position:integer):boolean;
    function   IsExecute(Position:integer):boolean;
    function   IsDDL(Position:integer):boolean;
  public
   constructor Create; overload;
   constructor Create(const aSQLText:string); overload;
   destructor  Destroy; override;
   procedure   ScanText(FromPosition:integer;Proc:TOnScanSQLText);

   function    DispositionMainFrom:TPoint;
   function    MainFrom:string;
   function    ModifiedTables:string;

   function    OrderText(var StartPos,EndPos:integer):string;
   function    OrderClause:string;
   function    SetOrderClause(const Value:string):string;
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
   function    GetAllTables:TStrings;
  public
   property    SQLText:string read FSQLText write SetSQLText;
   property    Len :integer read FLen write FLen;
   property    FirstPos   :integer read FFirstPos;
   property    MainPlanClause:string   read GetMainPlan ;
   property    SQLKind :TSQLKind read FSQLKind;
  end;

const
   space='    ';
   ForceNewStr=#13#10+space;
   QuotMarks=#39;


 procedure Test(SQLText:string;DebagStrings:TStrings);
 function  DispositionFrom(const SQLText:string):TPoint;
 procedure AllSQLTables(SQLText:string;FTables:TStrings);
 procedure AllTables(const SQLText:string;FTables:Tstrings);

 function  TableByAlias(const SQLText,Alias:string):string;
 function  AliasForTable(const SQLText,TableName:string):string;

 function  FullFieldName(const SQLText,aFieldName:string):string;
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

const
  CharsAfterClause =[' ',#13,#9,#10];
  CharsBeforeClause=[' ',#10,')',#9,#13];
  endLexem=['+',')','(','*','/','|',',','=','>','<','-','!','^','~',',',';'];
  
function ParseMacroString(const MacroString:string; aMacroChar:Char;var DefValue:string):string ;

const
  BeginWhere =' WHERE ';
  
implementation



procedure Test(SQLText:string;DebagStrings:TStrings);
var
   Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
//   DebagStrings.Text:=Parser.SetMainPlan('MERGE(DEPARTMENT NATURAL)');
    DebagStrings.Text:=Parser.MainFrom
{   DebagStrings.Add(Parser.PlanText(1,StartPos,EndPos));
   if StartPos>0 then
   begin

    DebagStrings.Add(IntToStr(StartPos)+' '+SQLText[StartPos+1]);
    DebagStrings.Add(IntToStr(EndPos)+' '+SQLText[EndPos-1]);
   end;}
  finally
   Parser.Free
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

{
function ParseMacroString1(const MacroString:string; aMacroChar:Char;var DefValue:string):string ;
var j,l,d:integer;
    InQuote:boolean;
begin
// For FIBPlus Macro
   j:=Pos('%',MacroString);
   if j=0 then
   begin
    if MacroString[1]=aMacroChar then
     Result:=Copy(MacroString,2,1000)
    else
     Result:=MacroString;
    exit;
   end;
   d:=0;
   l:= Length(MacroString);
   SetLength(Result,l);
   InQuote:=False;
   for j := 1 to l do
   begin
    if InQuote then
     InQuote:=MacroString[j]<>'"'
    else
     InQuote:=MacroString[j]='"';
    if (InQuote) then
     Result[j-d]:=MacroString[j]
    else
    if  (MacroString[j]<>'%') then
    begin
     if (j=1) and (MacroString[j]=aMacroChar) then
      d:=1
     else
      Result[j-d]:=MacroString[j];
    end
    else
    begin
      SetLength(Result,j-1-d);
      DefValue:=Copy(MacroString,j+1,L);
      Exit;
    end;
   end;
   DefValue:='';
   Result:=aMacroChar+MacroString;
end;
}

function PosOrderBy(const SQLText:string):integer;
begin
 Result:=PosExtCI('ORDER',SQLText,CharsBeforeClause,CharsAfterClause);
end;

function PosClause(const Clause,SQLText:string):integer;
begin
 Result:=PosExtCI(Clause,SQLText,CharsBeforeClause,CharsAfterClause);
end;


procedure NormalizeSQLText(const SQL: string;MacroChar:Char;
  var NSQL:string
);
const

 aUnceasing:array [0..12] of string  = ('||','<>','>=','<=','!=','!<','!>',
  '^=','~=','^>','~>','^<','~<'
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
  //Всегда начинаем с пробела
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
    NSQL[j]:= SQL[i];Inc(j);
  end
  else
  if (SQL[i] in endLexem) and not InMacro then
  begin
   if (PredChar<>' ') then
   begin
    if not (StringInArray(PredChar+SQL[i],aUnceasing)) then
    begin
     NSQL[j]:=' ';
     Inc(j)
    end;
     if SQL[i]=':' then
      NSQL[j]:='?'
     else
      if  (PredChar in ['!','^','~']) and (SQL[i]='=') then
      begin
       NSQL[j-1] :='<';
       NSQL[j]   :='>';
      end
      else
       NSQL[j]:=SQL[i];
    if (i<>l) and (SQL[i+1]<>' ') and
     not StringInArray(SQL[i]+SQL[i+1],aUnceasing)  then
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
      if  (PredChar in ['!','^','~']) and (SQL[i]='=') then
      begin
       NSQL[j-1] :='<';
       NSQL[j]   :='>';
      end
      else
       NSQL[j]:=SQL[i];
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
       if not (SQL[i] in [' ',#13,#10,#9]) then
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
        if  (PredChar in ['!','^','~']) and (SQL[i]='=') then
        begin
         NSQL[j-1] :='<';
         NSQL[j]   :='>';
        end
        else
        NSQL[j]:=SQL[i];
      Inc(j);
    end;
  end
  else
  if (SQL[i] in [' ',#13,#10,#9]) then
  begin
   // Pack space
   if (j>1) and (NSQL[j-1]<>' ') then
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


function RemoveSP(const FromStr:string):string;
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
  while (pBrIn>1) and not (Result[pBrIn] in [',']) do Dec(pBrIn);
  while (pBrOut<=Length(Result)) and not (Result[pBrOut] in [',']) do Inc(pBrOut);
  System.Delete(Result,pBrIn,pBrOut-pBrIn);
  pBrIn:=PosCh('(',Result);
 end;
end;

function RemoveJoins(const FromStr:string):string;
var pON,pComa,pJOIN:integer;
    tmpStr:string;
begin
 Result:=FromStr;
 pJOIN:=PosClause('JOIN',Result);
 if pJOIN=0 then Exit;
 Result:=Copy(Result,1,pJOIN-1)+', '+Copy(Result,PJOIN+5,MaxInt);
 Result:=ReplaceCIStr(Result, ' LEFT ' , ' ');
 Result:=ReplaceCIStr(Result, ' RIGHT ', ' ');
 Result:=ReplaceCIStr(Result, ' FULL ' , ' ');
 Result:=ReplaceCIStr(Result, ' INNER ', ' ');
 Result:=ReplaceCIStr(Result, ' OUTER ', ' ');
 Result:=ReplaceCIStr(Result, ' JOIN ', ' , ');
 pON:=PosClause('ON',Result);
 tmpStr:='';
 while pOn >0 do
 begin
  DoCopy(Result,tmpStr,pOn+2,MaxInt);
  pComa:=PosCh(',',tmpStr);
  SetLength(Result,pOn-1);
  if pComa>0 then
  begin
   Result:=Result+Copy(tmpStr,pComa,MaxInt)
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
    Result:=Trim(Parser.ModifiedTables);
    L:=Length(Result);
    if not WithAlias and (L>0) then
    begin
      StartCut:=1;
      if Result[StartCut]='"' then Inc(StartCut);
      EndCut:=StartCut+1;
      while EndCut<=L do
      begin
        if Result[EndCut] in ['"',' ',#13,#10,#9] then
        begin
          Dec(EndCut); Break
        end
        else
         Inc(EndCut);
      end;
      Result:=Copy( Result,StartCut,EndCut-StartCut+1);
    end;
  finally
   Parser.Free
  end;
end;

procedure AllSQLTables(SQLText:string;FTables:TStrings);
var i,j:integer;
begin
 NormalizeSQLText(SQLText,'@',SQLText);
 FTables.Text:=GetModifyTable(SQLText);
 if FTables.Count=0 then
 begin
  AllTables(SQLText,FTables);
  for i:=0 to Pred(FTables.Count) do
  if PosCh('"',FTables[i])=0 then
   FTables[i]:= ExtractWord(1,FTables[i],[' '])
  else
  begin
   for j:=Length(FTables[i]) downto 1 do
   if FTables[i][j]='"' then Break;
   FTables[i]:=Copy(FTables[i],1,j);
  end;
 end;
end;


procedure AllTables(const SQLText:string;FTables:Tstrings);
var s,FromText:string;
      i,p,p1  :integer;
      DFrom   :TPoint;
      NSQL    :string;
begin
 FTables.Clear;
 if IsBlank(SQLText) then Exit;
 NormalizeSQLText(SQLText,'@',NSQL);
 DFrom:=DispositionFrom(NSQL);
 DoCopy(NSQL,FromText,DFrom.X+4,DFrom.Y-DFrom.X-3);
 FromText:=ReplaceStr(Trim(FromText),#13#10,'  ');
 if FromText='' then Exit;
 if PosClause('JOIN',FromText) >0 then FromText:=RemoveJoins(FromText);
 if PosCh('(',FromText)>0 then FromText:=RemoveSP(FromText);
 p:=WordCount(FromText,[',']);
 for  i:=1  to p do
 begin
  s:=ExtractWord(i, FromText,[',']);
  p1 := PosClause('AS',s);
  if p1>0 then
   Delete(s,p1,3);
  DoTrim(s);
  FTables.Add(s);
 end;
end;

function  AliasForTable(const SQLText,TableName:string):string;
var ts:TStrings;
    i,p:integer;
begin
 Result:=TableName;
 ts:=TStringList.Create;
 try
  AllTables(SQLText,ts);
  for i:=0 to Pred(ts.Count) do
  begin
   p:=PosCI(TableName,ts[i]);
   if p>0 then
   begin
     p:=PosCh(' ',ts[i]);
     DoCopy(ts[i],Result,p+1,MaxInt);
     DoTrim(Result);
     Exit
   end;
  end;
 finally
  ts.Free
 end;
end;

function  TableByAlias(const SQLText,Alias:string):string;
var ts:TStrings;
    i,p:integer;
begin
 Result:=Alias;
 ts:=TStringList.Create;
 try
  AllTables(SQLText,ts);
  for i:=0 to Pred(ts.Count) do
  begin
   p:=PosCI(' '+Alias,ts[i]);
   if p>0 then
   begin
     DoCopy(ts[i],Result,1,p-1);
     DoTrim(Result);
     Exit
   end;
  end;
 finally
  ts.Free
 end;
end;

function FullFieldName(const SQLText,aFieldName:string):string;
var
   p:integer;
   s:string;
begin
 p:=PosCh('.',aFieldName);
 if p=0 then
  Result:=aFieldName
 else
 begin
  s:= TableByAlias(SQLText,Copy(aFieldName,1,p-1));
  if (Length(s)=0) then
   Result:=aFieldName
  else
  if (Length(s)>0) and (s[1]<>'"') then
   Result:=s+Copy(aFieldName,p,MaxInt)
  else
   Result:=Copy(s,2,Length(s)-2)+Copy(aFieldName,p,MaxInt)
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

function  GetOrderInfo(const SQLText:string):variant;
var p,i:integer;
    wc:integer;
    bufStr,s:string;
    NSQL:string;
begin
 Result:=null;
 NSQL:=SQLText;
 NormalizeSQLText(SQLText,'@',NSQL);
 p:=PosOrderBy(NSQL);
 if p=0 then Exit;
 Delete(NSQL,1,p+5);
 p:=PosClause('BY',NSQL);
 if p=0 then Exit;
 Delete(NSQL,1,p+2);
 wc:=WordCount(NSQL,[',']);
 if wc<1 then Exit;
 Result:=VarArrayCreate([0,wc-1,0,1],varVariant);
 for i:=1 to wc do
 begin
   bufStr:=ExtractWord(i,NSQL,[',']);
   if WordCount(bufStr,['.'])>1 then
   s:=ExtractWord(1,bufStr,['.'])+ '.'+
    Trim(ExtractWord(2,bufStr,['.']))
  else
   s:=bufStr;

  s:=ReplaceStr(s,'"','');
  p:=PosClause('COLLATE',s);
  if p>0 then
   SetLength(s,p-1);
  p:=PosClause('DESC',s);
  Result[i-1,1]:=p=0;
  if p>0 then
    SetLength(s,p-1)
  else
  begin
   p:=PosClause('ASC',s);
   if p>0 then
    SetLength(s,p-1);
  end;
  Result[i-1,0]:=Trim(s);
 end;
end;

procedure SetOrderString(SQLText:TStrings;const OrderTxt:string);
var StartPos,EndPos:integer;
    Old :string;
    OldTxt:string;
begin
  with SQLText do
  begin
   OldTxt:=Text;
   Old:=ideSHTxtRtns.OrderStringTxt(OldTxt, StartPos,EndPos); (*BT*)
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
// Приведение текстов констрэнтов к единому виду
// для облегчения последующей обработки
// Временно не используется
    Result := Trim(Src.Text);
    pos_no := PosCh('(',Result)+1;
    Result:=Copy(Result,Pos_no,Length(Result));
    pos_no :=-1;
    for i := Length(Result) downto 1 do
     if Result[i]=')' then begin pos_no := i; Break; end;
    SetLength(Result,Pos_no-1);
    Result:=
     ReplaceStr(Copy(Result,Pos_no,Length(Result)-Pos_no), '"',QuotMarks)
end;


{ TSQLParser }

constructor TSQLParser.Create;
begin
 FTables     :=TStringList.Create;
 FResultPos:=0;
 FReserved :=0;
 FReserved1:=0;
 FScanInBrackets:=False;
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
       Yes := ((Len-P)>=4) and
           (SQLText[P+2] in ['O','o']) and
           (SQLText[P+3] in ['R','r']) and
           (SQLText[P+4] in [' ',#9,#13,#10]);

    'G','g': //GROUP BY
       Yes :=((Len-P)>=6) and
           (SQLText[P+2] in ['R','r']) and
           (SQLText[P+3] in ['O','o']) and
           (SQLText[P+4] in ['U','u']) and
           (SQLText[P+5] in ['P','p']) and
           (SQLText[P+6] in [' ',#9,#13,#10]);
    'H','h': //HAVING
       Yes :=  ((Len-P)>=7)    and
           (SQLText[P+2] in ['A','a']) and
           (SQLText[P+3] in ['V','v']) and
           (SQLText[P+4] in ['I','i']) and
           (SQLText[P+5] in ['N','n']) and
           (SQLText[P+6] in ['G','g']) and
           (SQLText[P+7] in ['(']+CharsAfterClause);

    'O','o'://ORDER BY
       Yes :=((Len-P)>=6) and
           (SQLText[P+2] in ['R','r']) and
           (SQLText[P+3] in ['D','d']) and
           (SQLText[P+4] in ['E','e']) and
           (SQLText[P+5] in ['R','r']) and
           (SQLText[P+6] in CharsAfterClause);
    'P','p': // PLAN
       Yes :=((Len-P)>=5) and
           (SQLText[P+2] in ['L','l']) and
           (SQLText[P+3] in ['A','a']) and
           (SQLText[P+4] in ['N','n']) and
           (SQLText[P+5] in ['(']+CharsAfterClause);
    'U','u': //UNION
       Yes :=((Len-P)>=6) and
           (SQLText[P+2] in ['N','n']) and
           (SQLText[P+3] in ['I','i']) and
           (SQLText[P+4] in ['O','o']) and
           (SQLText[P+5] in ['N','n']) and
           (SQLText[P+6] in CharsAfterClause);
    'W','w': //WHERE
       Yes :=((Len-P)>=6) and
           (SQLText[P+2] in ['H','h']) and
           (SQLText[P+3] in ['E','e']) and
           (SQLText[P+4] in ['R','r']) and
           (SQLText[P+5] in ['E','e']) and
           (SQLText[P+6] in ['(']+CharsAfterClause);
    end;
  end
end;

procedure TSQLParser.IsFromBegin(Position:integer;var Yes:boolean);
begin
 Yes:=
         (Position>1) and (Len-Position>=4)  and
         (SQLText[Position] in ['F','f'])   and
         (SQLText[Position+1] in ['R','r']) and
         (SQLText[Position+2] in ['O','o']) and
         (SQLText[Position+3] in ['M','m']) and
         (SQLText[Position+4] in CharsAfterClause) and
         (SQLText[Position-1] in CharsBeforeClause)
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
    '(': if not (FState in [sComment,sFBComment,sQuote]) then
         begin
           Inc(FBracketOpened);
         end;
    ')': if not (FState in [sComment,sFBComment,sQuote]) then
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
    '"': if not (FState in [sComment,sFBComment]) then
          if  FState=sQuote then
           FState:=sNormal
          else
           FState:=sQuote;
    '*': if FState<>sQuote then
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
end;

procedure TSQLParser.SetSQLText(const Value: string);
begin
  FSQLText := Value;
  FTables.Clear;
  FLen:=Length(FSQLText);
  FFirstPos:=1;
  while (FFirstPos<=FLen) and  (FSQLText[FFirstPos] in CharsAfterClause)  do
  begin
    Inc(FFirstPos);
  end;
  if (FFirstPos<FLen) and (FSQLText[FFirstPos]='/') and (FSQLText[FFirstPos+1]='*') then
  begin
    Inc(FFirstPos,2);
    while (FFirstPos<FLen) and  ((FSQLText[FFirstPos]<>'*') or (FSQLText[FFirstPos+1]<>'/'))
    do Inc(FFirstPos);
    Inc(FFirstPos,2);
    while (FFirstPos<=FLen) and  (FSQLText[FFirstPos] in CharsAfterClause)  do
    begin
      Inc(FFirstPos);
    end;
  end;
  FSQLKind :=GetSQLKind;   
end;

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

// Yes:=  IsClause(Position,'ORDER')
end;

procedure TSQLParser.IsMainOrderBegin(Position: integer; var Yes: boolean);
begin
 Yes:=FBracketOpened=0;
 if Yes then
  IsOrderBegin(Position, Yes)
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
  Result:=Clause=FastUpperCase(Copy(SQLText,Position,LenClause))
end;

procedure TSQLParser.IsByBegin(Position: integer; var Yes: boolean);
begin
 Yes:=  IsClause(Position,'BY')
end;

function TSQLParser.DispositionMainFrom: TPoint;
begin
    Result.X:=0;Result.Y:=0;
    ScanText(FFirstPos,IsMainFromBegin);
    if FResultPos=0 then Exit;
    Result.X:=FResultPos;
    ScanText(Result.X+5,IsFromEnd);
    if FResultPos=0 then Result.X:=0;
    Result.Y:=FResultPos;
end;

function TSQLParser.MainFrom:string;
var p:TPoint;
begin
  p:=DispositionMainFrom;
  if p.X>0 then
   if p.Y=Length(SQLText) then
    Result:=Copy(SQLText,p.X+5,MaxInt)
   else
    Result:=Copy(SQLText,p.X+5,p.Y-p.X-5)
  else
   Result:=''
end;

function  TSQLParser.ModifiedTables:string;
var
   p:integer;
begin
   case SQLKind of
    skUpdate:
    begin
     ScanText(FFirstPos+7,IsSetBegin);
     if FResultPos>0 then
      Result:=Copy(SQLText,FFirstPos+7,FResultPos-8-FFirstPos)
     else
      Result:=Copy(SQLText,FFirstPos+7,MaxInt)
    end;
    skInsert:
    begin
     ScanText(FFirstPos+7,IsIntoBegin);
     if FResultPos>0 then
     begin
       for p:=FResultPos+5 to Len do
       begin
         case SQLText[p] of
         '(':
          begin
             Result:=Copy(SQLText,FResultPos+5,p-6-FResultPos);
             Exit;
          end;
         'S','s':
          if (Len-p)>=6 then
          if (SQLText[p+1] in ['E','e']) and
             (SQLText[p+2] in ['L','l']) and
             (SQLText[p+3] in ['E','e']) and
             (SQLText[p+4] in ['C','c']) and
             (SQLText[p+5] in ['T','t'])
          then
          begin
             Result:=Copy(SQLText,FResultPos+5,p-6-FResultPos);
             Exit;
          end;
         'V','v':
          if (Len-p)>=6 then
          if (SQLText[p+1] in ['A','a']) and
             (SQLText[p+2] in ['L','l']) and
             (SQLText[p+3] in ['U','u']) and
             (SQLText[p+4] in ['E','e']) and
             (SQLText[p+5] in ['S','s'])
          then
          begin
             Result:=Copy(SQLText,FResultPos+5,p-6-FResultPos);
             Exit;
          end;
         end;
       end;
     end
     else
      Result:='Unknown'
    end;   // skInsert
    skDelete:
      Result:=MainFrom
   end;
end;

function TSQLParser.OrderText(var StartPos, EndPos: integer): string;
begin
  Result:='';StartPos:=0;EndPos:=0;
  ScanText(FFirstPos,IsMainOrderBegin);
  if FResultPos=0 then Exit;
  StartPos:=FResultPos;
  ScanText(FResultPos+5,IsByBegin);
  if FResultPos=0 then Exit;
  Result:=Copy(SQLText,FResultPos+2,MaxInt);
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
   if Trim(Value)='' then
    Result := SQLText
   else
    Result := Trim(SQLText)+CLRF+ 'ORDER BY '+Value;
 end
 else
 begin
   if Trim(Value)='' then
    Result := Copy(SQLText,1,StartPos-1)
   else
    if SQLText[StartPos-1]<>#10 then
     Result := Copy(SQLText,1,StartPos-1)+CLRF+ 'ORDER BY '+Value
    else
     Result := Copy(SQLText,1,StartPos-1)+ 'ORDER BY '+Value
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
     while (StartPos1<=Len) and (SQLText[StartPos1] in CharsAfterClause) do
      Inc(StartPos1);
     ScanText(StartPos1,IsWhereEnd);
     EndPos:=FResultPos;
     if EndPos>0 then
     begin
       if EndPos<>Length(SQLText) then
        Dec(EndPos);
       while (EndPos>0) and (SQLText[EndPos] in CharsAfterClause) do
        Dec(EndPos);
       Result:= Copy(SQLText,StartPos1,EndPos-StartPos1+1);
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
   if Trim(Value)='' then
    Result:=Copy(SQLText,1,StartPos-1)+CLRF + Copy(SQLText,EndPos+1,MaxInt)
   else
   begin
    if SQLText[StartPos-1]<>#10 then
     Result:=Copy(SQLText,1,StartPos-1)+CLRF+ 'WHERE ' + Value
    else
     Result:=Copy(SQLText,1,StartPos-1)+'WHERE ' +Value ;
    if SQLText[EndPos+1]<>#13 then
     Result:=Result + CLRF + Copy(SQLText,EndPos+1,MaxInt)
    else
     Result:=Result +  Copy(SQLText,EndPos+1,MaxInt)    ;
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
      
    FReserved :=N; // N- number plan clause
    FReserved1:=0;
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
       Result:= Copy(SQLText,StartPos,EndPos-StartPos+1)
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
    if Trim(Text)<>'' then
     Result:=Copy(SQLText,1,StartPos-1)+Text+Copy(SQLText,EndPos+1,MaxInt)
    else
     Result:=Copy(SQLText,1,StartPos-6)+Copy(SQLText,EndPos+1,MaxInt)
  end
  else
  if Trim(Text)='' then
   Result:=SQLText
  else
  begin
    OrderText(StartPos,EndPos);
    if StartPos>0 then
    begin
      Result:=Copy(SQLText,1,StartPos-1);
      if Result[Length(Result)]<>#10 then Result:=Result+CLRF;
      Result:=Result+'PLAN '+Text+ CLRF+
       Copy(SQLText,StartPos,MaxInt)
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
     Copy(SQLText,1,StartPos+4)+
      '( '+Copy(SQLText,StartPos+5,EndPos-StartPos-4)+' )'+CLRF+
      'and ( '+NewClause+' )'+CLRF+
      Copy(SQLText,EndPos+1,MaxInt);
  end
  else
  begin
    p     :=DispositionMainFrom.Y;
    Result:=
      Copy(SQLText,1,p)+BeginWhere+CLRF+NewClause+#13#10+Copy(SQLText,p+1,MaxInt)
  end
end;

function   TSQLParser.IsSelect(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=6)  and
         (SQLText[Position]   in ['S','s'])   and
         (SQLText[Position+1] in ['E','e'])   and
         (SQLText[Position+2] in ['L','l'])   and
         (SQLText[Position+3] in ['E','e'])   and
         (SQLText[Position+4] in ['C','c'])   and
         (SQLText[Position+5] in ['T','t'])   and
         (SQLText[Position+6] in CharsAfterClause)
end;


function   TSQLParser.IsUpdate(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=6)  and
         (SQLText[Position]   in ['U','u'])   and
         (SQLText[Position+1] in ['P','p'])   and
         (SQLText[Position+2] in ['D','d'])   and
         (SQLText[Position+3] in ['A','a'])   and
         (SQLText[Position+4] in ['T','t'])   and
         (SQLText[Position+5] in ['E','e'])   and
         (SQLText[Position+6] in CharsAfterClause)
end;


function   TSQLParser.IsDelete(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=6)  and
         (SQLText[Position]   in ['D','d'])   and
         (SQLText[Position+1] in ['E','e'])   and
         (SQLText[Position+2] in ['L','l'])   and
         (SQLText[Position+3] in ['E','e'])   and
         (SQLText[Position+4] in ['T','t'])   and
         (SQLText[Position+5] in ['E','e'])   and
         (SQLText[Position+6] in CharsAfterClause)
end;
function   TSQLParser.IsInsert(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=6)  and
         (SQLText[Position]   in ['I','i'])   and
         (SQLText[Position+1] in ['N','n'])   and
         (SQLText[Position+2] in ['S','s'])   and
         (SQLText[Position+3] in ['E','e'])   and
         (SQLText[Position+4] in ['R','r'])   and
         (SQLText[Position+5] in ['T','t'])   and
         (SQLText[Position+6] in CharsAfterClause)
end;

function TSQLParser.IsExecute(Position:integer):boolean;
begin
 Result:=   ((Position=1) or (SQLText[Position-1] in CharsBeforeClause))and
         (Len-Position>=7)  and
         (SQLText[Position]   in ['E','e'])   and
         (SQLText[Position+1] in ['X','x'])   and
         (SQLText[Position+2] in ['E','e'])   and
         (SQLText[Position+3] in ['C','c'])   and
         (SQLText[Position+4] in ['U','u'])   and
         (SQLText[Position+5] in ['T','t'])   and
         (SQLText[Position+6] in ['E','e'])   and
         (SQLText[Position+7] in CharsAfterClause)
end;

function TSQLParser.IsDDL(Position:integer):boolean;
begin
  Result:= (Len>0) and  ((Position=1) or (SQLText[Position-1] in CharsBeforeClause));
  if Result then
  case SQLText[Position] of
    'A': Result:=
          (Len-Position>=5)  and
          (SQLText[Position+1] in ['L','l'])   and
          (SQLText[Position+2] in ['T','t'])   and
          (SQLText[Position+3] in ['E','e'])   and
          (SQLText[Position+4] in ['R','r'])   and
          (SQLText[Position+5] in CharsAfterClause);
    'C': Result:=
          (Len-Position>=6)  and
          (SQLText[Position+1] in ['R','r'])   and
          (SQLText[Position+2] in ['E','e'])   and
          (SQLText[Position+3] in ['A','a'])   and
          (SQLText[Position+4] in ['T','t'])   and
          (SQLText[Position+5] in ['E','e'])   and
          (SQLText[Position+6] in CharsAfterClause);

    'D': Result:=
          (Len-Position>=4)  and
          (SQLText[Position+1] in ['R','r'])   and
          (SQLText[Position+2] in ['O','o'])   and
          (SQLText[Position+3] in ['P','p'])   and
          (SQLText[Position+4] in CharsAfterClause);
    'R':
         Result:=
          (Len-Position>=8)  and
          (SQLText[Position+1] in ['E','e'])   and
          (SQLText[Position+2] in ['C','c'])   and
          (SQLText[Position+3] in ['R','r'])   and
          (SQLText[Position+4] in ['E','e'])   and
          (SQLText[Position+5] in ['A','a'])   and
          (SQLText[Position+6] in ['T','t'])   and
          (SQLText[Position+7] in ['E','e'])   and
          (SQLText[Position+8] in CharsAfterClause);
  end;
end;

function TSQLParser.GetSQLKind: TSQLKind;
begin
 if IsSelect(FFirstPos)  then  Result:=skSelect
 else
 if IsUpdate(FFirstPos)  then  Result:=skUpdate
 else
 if IsDelete(FFirstPos)  then  Result:=skDelete
 else
 if IsInsert(FFirstPos)  then  Result:=skInsert
 else
 if IsExecute(FFirstPos) then  Result:=skExecute
 else
 if IsDDL(FFirstPos)     then  Result:=skDDL
 else
  Result:=skUnknown;
end;


function TSQLParser.RecCountSQLText: string;
var fr:TPoint;
    StartWhere,EndWhere:integer;
    wh:string;
begin
 Result:='';
 if SQLKind<>skSelect then Exit;
 fr:=DispositionMainFrom;
 if fr.x=0 then Exit;
 Result:='Select Count(*) '+Copy(SQLText,fr.x,fr.y-fr.x+1);
 wh:=MainWhereClause(StartWhere,EndWhere);
 if wh<>'' then
  Result:=Result+#13#10+BeginWhere+wh;
end;

function TSQLParser.MainWhereClause(var StartPos, EndPos: integer): string;
begin
 FResultPos:=0;
 Result:=WhereClause(MainWhereIndex,StartPos,EndPos)
end;


function TSQLParser.GetAllTables: TStrings;
var
      ns  :string;
      i,p :integer;

begin
 if FTables.Count=0 then
 begin
   case SQLKind of    //
     skSelect:
     begin
       AllTables(SQLText,FTables)
     end;
   else
     NormalizeSQLText(SQLText,'@',ns);
     case SQLKind of
      skUpdate: FTables.Text:=Copy(ns,9,MaxInt);
      skInsert: FTables.Text:=Copy(ns,14,MaxInt);
      skDelete: FTables.Text:=Copy(ns,14,MaxInt);
     end;
     for I := 0 to FTables.Count - 1   do
     begin
       if FTables[i][1]<>'"' then
        p:=PosCh( ' ',FTables[i])-1
       else
       begin
        p:=PosInRight('"',FTables[i],2);
       end;
       if p>0 then
        FTables[i]:=Copy(FTables[i],1,p);
     end;
   end;
 end;
 Result:=FTables
end;


function  GetFieldByAlias(const SQLText,FieldName:string):string;
var
  p:integer;
  cBracket:integer;
begin
  p:=PosExtCI(FieldName,SQLText,CharsBeforeClause,CharsAfterClause+[',']);
  Dec(p);
  if p<=0 then
  begin
    Result:='';
    Exit;
  end;
  while (p>0) and (SQLText[p] in CharsAfterClause) do  Dec(p);

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
  while (p>0) and (SQLText[p] in CharsAfterClause+[#10]) do  Dec(p);
  if (p=0) or (SQLText[p]=',') then
  begin
    Result:=FieldName;
    Exit;
  end;
  if SQLText[p]<>')' then
   begin
     Result := '';
     while (p>0) and not (SQLText[p] in CharsAfterClause+[',']) do
     begin
       Result := SQLText[p]+Result;
       Dec(p);
     end;
   end
  else
   begin
     cBracket:=1;
     Result:=SQLText[p];
     Dec(p);
     while (cBracket<>0) and (p<>0) do
     begin
       Result:=SQLText[p]+ Result ;
       if SQLText[p]='(' then Dec(cBracket);
       if SQLText[p]=')' then Inc(cBracket);         
       Dec(p);
     end;
     while (p>0) and not (SQLText[p] in CharsAfterClause+[',']) do
     begin
       Result := SQLText[p]+Result;
       Dec(p);
     end;
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
  Ind:=0;
  while Ind<c do
  begin
   Wh:=GetWhereClause(SQLText,Ind,StartPos,EndPos);
   p:=PosExtCI(ParamName,Wh,
    CharsBeforeClause+endLexem+[':'],CharsAfterClause+endLexem
   )-1;
   while (p>0) and (wh[p] in CharsBeforeClause+endLexem+[':',#13]) do Dec(p);
   if p>0 then
   begin
    while (p>0) and not (wh[p] in CharsBeforeClause+endLexem+[':']) do
    begin
     Result:=wh[p]+Result;
     Dec(p);
    end;
    Exit;
   end;

   p:=PosExtCI(ParamName,Wh,
    CharsBeforeClause+endLexem+['?'],CharsAfterClause+endLexem
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
  Result:=(Position>1) and (Len-Position>=5)
   and (SQLText[Position]   in ['W','w'])
   and (SQLText[Position+1] in ['H','h'])
   and (SQLText[Position+2] in ['E','e'])
   and (SQLText[Position+3] in ['R','r'])
   and (SQLText[Position+4] in ['E','e'])
   and (SQLText[Position-1] in CharsBeforeClause)
   and (SQLText[Position+5] in ['(']+CharsAfterClause);
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
      Result:=((Len-P)>=3) and
           (SQLText[P+1] in ['O','o']) and
           (SQLText[P+2] in ['R','r']) and
           (SQLText[P+3] in CharsAfterClause);

    'G','g': //GROUP BY
      Result:=((Len-P)>=5) and
           (SQLText[P+1] in ['R','r']) and
           (SQLText[P+2] in ['O','o']) and
           (SQLText[P+3] in ['U','u']) and
           (SQLText[P+4] in ['P','p']) and
           (SQLText[P+5] in CharsAfterClause);
    'H','h': //HAVING
      Result:=((Len-P)>=6)    and
           (SQLText[P+1] in ['A','a']) and
           (SQLText[P+2] in ['V','v']) and
           (SQLText[P+3] in ['I','i']) and
           (SQLText[P+4] in ['N','n']) and
           (SQLText[P+5] in ['G','g']) and
           (SQLText[P+6] in CharsAfterClause+['(']);

    'O','o'://ORDER BY
      Result:=((Len-P)>=5) and
           (SQLText[P+1] in ['R','r']) and
           (SQLText[P+2] in ['D','d']) and
           (SQLText[P+3] in ['E','e']) and
           (SQLText[P+4] in ['R','r']) and
           (SQLText[P+5] in CharsAfterClause);
    'P','p': // PLAN
      Result:=((Len-P)>=4) and
           (SQLText[P+1] in ['L','l']) and
           (SQLText[P+2] in ['A','a']) and
           (SQLText[P+3] in ['N','n']) and
           (SQLText[P+4] in CharsAfterClause+['(']);
    'U','u':
      Result:=((Len-P)>=6) and
           (SQLText[P+1] in ['N','n']) and
           (SQLText[P+2] in ['I','i']) and
           (SQLText[P+3] in ['O','o']) and
           (SQLText[P+4] in ['N','n']) and
           (SQLText[P+5] in CharsAfterClause);
    end;
  end
end;



end.

