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


{*******************************************************}
{                                                       }
{ This unit based on  StrUtils.pas from RX Library      }
{ and SoWldStr.pas from SOHOLIB                         }
{                                                       }
{*******************************************************}

unit ibSHStrUtil;

interface
(* BT {$I FIBPlus.inc} *)
uses
 {$IFDEF MSWINDOWS}
   SysUtils,Classes;
 {$ENDIF}
 {$IFDEF LINUX}
   SysUtils,Classes;
 {$ENDIF}

type
 TCharSet= Set of Char;
 
const
     CLRF=#13#10;
 // from RX
function MakeStr(C: Char; N: Integer): string;
function StrAsFloat(S:string):double;

function ToClientDateFmt(D:string;caseFmt:byte):string;
function ExtractWord(Num:integer;const Str: string;const  WordDelims:TCharSet):string;
function ExtractLastWord(const Str: string;const  WordDelims:TCharSet):string;
function WordCount(const S: string; const WordDelims: TCharSet): Integer;
//from SOHOLIB

function WildStringCompare( FirstString,SecondString : string ) : boolean;
function MaskCompare(const aString,Mask : string ) : boolean;
function SQLMaskCompare(const aString,Mask : string ) : boolean;

function WldIndexOf(ts:TStrings;const Value:string;CaseSensitive:boolean):integer;

//from Me

function TrimCLRF(const s:string): string;

procedure CopyChars(const Src:string; var  Dest:string;
 StartInSrc,StartInDest,Count:integer
);
function ReplaceStr(const S, Srch, Replace: string): string;

function ReplaceStrInSubstr(const Source :string;const Srch, Replace: string;
            BeginPos,EndPos:integer
): string;
function ReplaceCIStr(const S, Srch, Replace: string): string;
function ReplaceStrCIInSubstr(const Source :string;const Srch, Replace:string; 
            BeginPos,EndPos:integer
): string;

function FastUpperCase(const S: string): string;
function EquelStrings(const s,s1:string; CaseSensitive:boolean):boolean;

function iifStr(Condition:boolean;const Str1,Str2:string ):string;
function iifVariant(Condition:boolean;const Var1,Var2:Variant ):Variant;
function StrOnMask(const StrIn, MaskIn, MaskOut: string):string;
function EasyLikeStr(Str1,Str2:string) :boolean; // Only Russian texts
function StrIsInteger(const Str:string):boolean;

function FormatIdentifierValue(Dialect: Integer; const Value: string): string;
function FormatIdentifier(Dialect: Integer; const Value: string): string;
function EasyFormatIdentifier(Dialect: Integer; const Value: string;DoEasy:boolean ): string;

function EquelNames(CI:boolean; const Value,Value1: string): boolean;
function NeedQuote(const Name:string):boolean;
function EasyNeedQuote(const Name:string):boolean;
function PosCh(aCh:Char; const s:string):integer;
function PosCh1(aCh:Char; const s:string; StartPos:integer):integer;
function PosCI(const Substr,Str:string):integer;
function PosExt(const Substr,Str:string;BegSub,EndSub:TCharSet):integer;
function PosExtCI(const Substr,Str:string;BegSub,EndSub:TCharSet):integer;

function PosInSubstr(const SearchStr,Str:string;
                     BeginPos,EndPos:integer
         ):integer;
function PosInRight(const SearchStr,Str:string;BeginPos:integer):integer;

function PosInSubstrCI(const SearchStr,Str:string;
                     BeginPos,EndPos:integer
         ):integer;

function PosInSubstrExt(const SearchStr:string;Str:string;
                     BeginPos,EndPos:integer;
             BegSub,EndSub:TCharSet
         ):integer;


function PosInSubstrCIExt(const SearchStr:string;Str:string;
                     BeginPos,EndPos:integer;
             BegSub,EndSub:TCharSet
         ):integer;

function FirstPos(Search:array of char ; const InString:string):integer;

function LastChar(const Str:string):Char;

function QuotedStr(const S: string): string;
function CutQuote(const S: string): string;

function  StringInArray(const s:string; const a:array of string):boolean;
function  IsBlank(const Str:string) : boolean;

// string procedures
procedure DoLowerCase(var Str:string);
procedure DoTrim(var Str:string);

procedure DoTrimTo(const Source:string ;var Dest:string);
procedure DoTrimRight(var Str:string);
procedure DoCopy(const Source:string; var Dest:string; Index, Count: Integer);
function  StrTrimmedLen(Str:PChar):integer;      
// TStringList functions

procedure SLDifference(ASL,BSL:TStringList;ResultSL:TStrings);
function  EmptyStrings(SL:TStrings):boolean;
procedure DeleteEmptyStr(Src:TStrings);
function NonAnsiSortCompareStrings(SL: TStringList; Index1, Index2: Integer):Integer;
function  FindInDiapazon(SL:TStringList;const S: string;const StartIndex,EndIndex:integer;
 AnsiCompare:boolean;
 var Index: Integer
):boolean;

procedure GetNameAndValue(const s:string; var Name,Value:string);

function  StrToDateFmt(const ADate,Fmt:string):TDateTime;
function  DateToSQLStr(const ADate:TDateTime):string;
function  ValueFromStr(const Str:string):string;


function Q_StrLen(P: PChar): Cardinal;

function IsOldParamName(const ParamName:string):boolean;
function IsNewParamName(const ParamName:string):boolean;
function IsMasParamName(const ParamName:string):boolean;

implementation



function IsOldParamName(const ParamName:string):boolean;
begin
  Result:=
   (Length(ParamName)>4) and
   (ParamName[1] in ['O','o']) and (ParamName[4]='_') and
   (ParamName[2] in ['L','l']) and (ParamName[3] in ['D','d'])
end;

function IsNewParamName(const ParamName:string):boolean;
begin
  Result:=
   (Length(ParamName)>4) and
   (ParamName[1] in ['N','n']) and (ParamName[4]='_') and
   (ParamName[2] in ['E','e']) and (ParamName[3] in ['W','w'])
end;

function IsMasParamName(const ParamName:string):boolean;
begin
  Result:=
   (Length(ParamName)>4) and
   (ParamName[1] in ['M','m']) and (ParamName[4]='_') and
   (ParamName[2] in ['A','a']) and (ParamName[3] in ['S','s'])
end;

function StrToDateFmt(const ADate,Fmt:string):TDateTime;
var OldShortDateFormat:string;
begin
  OldShortDateFormat:=ShortDateFormat;
  try
   ShortDateFormat:=Fmt;
   Result:=StrToDateTime(ADate);
  finally
   ShortDateFormat:=OldShortDateFormat;
  end
end;

function  DateToSQLStr(const ADate:TDateTime):string;
var
 Year, Month, Day: Word;
begin
 DecodeDate(ADate,Year, Month, Day);
 Result:=IntToStr(Day)+'.'+IntToStr(Month)+'.'+IntToStr(Year)
end;

function  ValueFromStr(const Str:string):string;
var p:Integer;
begin
 p:=PosCh('=',Str);
 if p=0 then
  Result:=''
 else
  Result:=Copy(Str,p+1,MaxInt)
end;


function IsBlank(const Str:string) : boolean;
var
  L: Integer;
begin
  L := Length(Str);
  while (L > 0) and (Str[L] <= ' ') do Dec(L);
  result := L = 0;
end;

procedure DoLowerCase(var Str:string);
var i:integer;
begin
 for i:=Length(Str) downto 1 do
  if (Str[i] >= 'A') and (Str[i] <= 'Z') then
   Inc(Str[i],32)
end;

procedure TrimPositions(const Str:string; var Left,Right:integer);
begin
 Right:=Length(Str);
 if Right>0 then
 begin
   Left :=1;
   while Str[Right] <= ' ' do Dec(Right);
   while (Left <= Right) and (Str[Left] <= ' ') do Inc(Left);
 end;  
end;

procedure DoTrim(var Str:string);
var Left,Right:integer;
begin
 TrimPositions(Str,Left,Right);
 if Right<Length(Str) then SetLength(Str,Right);
 if Left >1 then Delete(Str,1,Left-1);
end;


procedure DoTrimTo(const Source:string ;var Dest:string);
var Left,Right:integer;
begin
 TrimPositions(Source,Left,Right);
 if (Left=1) and (Length(Source)=Right) then
  Dest:=Source
 else
 begin
  DoCopy(Source,Dest,Left,Right-Left+1);
 end;
end;

procedure DoTrimRight(var Str:string);
var
  I: Integer;
begin
  I := Length(Str);
  while (I > 0) and (Str[I] <= ' ') do Dec(I);
  if I< Length(Str) then  SetLength(Str,I)
end;

procedure DoCopy(const Source:string; var Dest:string; Index, Count: Integer);
var L:integer;
begin
  L:=Length(Source)-Index+1;
  if L>Count then L:=Count;
  if L<=0 then
   Dest:=''
  else
  begin
   if Length(Dest)<> L then SetLength(Dest,L);
   Move(Source[Index],Dest[1],L);
  end;
end;

{
function  StrTrimmedLen1(Str:PChar):integer;
var i:integer;
begin
 i:=0;
 Result:=0;
 while (Str[i]<>#0) do
 begin
  if (Str[i]<=' ') then
  begin
   if ((i=0) or (Str[i-1]>' '))then
     Result:=i
  end
  else
   Result:=i;
  Inc(i);
 end;
 Inc(Result);
end;
}
function  StrTrimmedLen(Str:PChar):integer;
begin
 Result:=StrLen(Str)-1;
 while (Result>=0) and (Str[Result]<=' ') do  Dec(Result);
 Inc(Result);
end;

function StringInArray(const s:string; const a:array of string):boolean;
var i:integer;
begin
  Result:=False;
  for i:=Low(a) to High(a) do
  begin
    Result:= EquelNames(false,s,a[i]);
    if  Result then Exit;
  end;
end;


function FormatIdentifierValue(Dialect: Integer;const Value: string): string;
begin
  if Dialect = 1 then
    Result := FastUpperCase(Trim(Value))
  else
    Result := Value;
end;

function EquelNames(CI:boolean; const Value,Value1: string): boolean;
begin
 if Length(Value)<>Length(Value1) then
  Result:=False
 else
 begin
  if CI then
    Result:=AnsiCompareText(Value,Value1)=0
  else
    Result:=Value=Value1
 end;
end;

function EasyFormatIdentifier(Dialect: Integer;  const Value: string;DoEasy:boolean): string;
var b :boolean;
begin
  if Dialect = 1 then
    Result := FastUpperCase(Trim(Value))
  else
  begin
    if DoEasy then
     b :=EasyNeedQuote(Value)
    else
     b :=NeedQuote(Value);
    if b then
     if (Length(Value)>0) and (Value[1]<>'"')  then
      Result := '"'+Value+'"'
     else
      Result :=Value
    else
      Result := FastUpperCase(Value)
  end;
end;

function FormatIdentifier(Dialect: Integer;const Value: string): string;
begin
  if Dialect = 1 then
    Result := FastUpperCase(Trim(Value))
  else
  if NeedQuote(Value) then
    Result := '"'+Value+'"'
  else
    Result := Value
end;


function PosCh(aCh:Char; const s:string):integer;
var
   i:integer;
begin
   for i :=1  to Length(S) do
   if (s[i]=aCh) then
   begin
     Result:=i; Exit
   end;
   Result:=0;
end;

function PosCh1(aCh:Char; const s:string; StartPos:integer):integer;
var
   i:integer;
begin
   for i :=StartPos  to Length(S) do
   if (s[i]=aCh) then
   begin
     Result:=i; Exit
   end;
   Result:=0;
end;

function PosCI(const Substr,Str:string):integer;
begin
 Result:=Pos(FastUpperCase(Substr),FastUpperCase(Str));
end;

function PosExt(const Substr,Str:string;BegSub,EndSub:TCharSet):integer;
var p,l,l1:integer;
begin
  Result:=0;
  p:=Pos(Substr,Str);
  l:=Length(Str);l1:=Length(Substr);
  while p>0 do
  begin
   if   ((p=1) or (Str[p-1] in BegSub)  )
    and ((Str[p+l1] in EndSub) or (p+l1>l))
   then
   begin
    Result:=p;    Exit;
   end;
   p:=PosInSubstr(Substr,Str,p+l1,l)
  end;
end;

function PosExtCI(const Substr,Str:string;BegSub,EndSub:TCharSet):integer;
begin
 Result:=PosExt(AnsiUpperCase(Substr),AnsiUpperCase(Str),BegSub,EndSub)
end;


function PosInRight(const SearchStr,Str:string;BeginPos:integer):integer;
var P:PChar;
begin
 P:=Pointer(Str);
 Inc(p,BeginPos-1);
 Result:=Integer(StrPos(p,PChar(SearchStr)));
 if Result>0 then
   Result:=Result-Integer(Pointer(Str))+1
end;

function PosInSubstr(const SearchStr,Str:string;
                     BeginPos,EndPos:integer
         ):integer;
begin
 if EndPos>=Length(Str) then
 begin
  Result:=PosInRight(SearchStr,Str,BeginPos)
 end
 else
 begin
   if BeginPos<1 then BeginPos:=1;
   Result:=Pos(SearchStr,Copy(Str,BeginPos,EndPos));
   if Result>0 then   Inc(Result,BeginPos-1)
 end;
end;
           
function PosInSubstrExt(const SearchStr:string;Str:string;
                     BeginPos,EndPos:integer;
             BegSub,EndSub:TCharSet
         ):integer;
var p,l,l1:integer;
begin
  Result:=0;
  p:=PosInSubstr(SearchStr,Str,BeginPos,EndPos);
  l:=Length(Str);l1:=Length(SearchStr);
  while p>0 do
  begin
   if   ((p=1) or (Str[p-1] in BegSub)  )
    and ((Str[p+l1] in EndSub) or (p+l1=l))
   then
   begin
    Result:=p;    Exit;
   end;
   p:=PosInSubstr(SearchStr,Str,p+l1,EndPos)
  end;
end;

function PosInSubstrCIExt(const SearchStr:string;Str:string;
                     BeginPos,EndPos:integer;
             BegSub,EndSub:TCharSet
         ):integer;
begin
 Result:=PosInSubstrExt(AnsiUpperCase(SearchStr),
  AnsiUpperCase(Str),BeginPos,EndPos,BegSub,EndSub
 )
end;

function PosInSubstrCI(const SearchStr,Str:string;
                     BeginPos,EndPos:integer
         ):integer;
begin
 Result:=PosInSubstr(AnsiUpperCase(SearchStr),
                      AnsiUpperCase(Str),
                      BeginPos,EndPos
                     )
end;

function MakeStr(C: Char; N: Integer): string;
begin
  if N < 1 then Result := ''
  else
  begin
    SetLength(Result, N);
    FillChar(Result[1], Length(Result), C);
  end;
end;

function StrAsFloat(S:string):double;
var  i:integer;
     AlterChar:Char;
begin
 if DecimalSeparator='.' then AlterChar:=',' else AlterChar:='.';
 for  i:= 1 to Length(S)  do
 begin
   if s[i] =AlterChar then s[i]:=DecimalSeparator
 end;
 Result:=StrToFloat(s)
end;

function StrDDMMMYYYY(const D:string):string;
begin
 Result:=ReplaceStr(D,'-',DateSeparator);
 if Pos('JAN',Result)<>0 then
   Result:=ReplaceStr(Result,'JAN','01')
 else
 if Pos('FEB',Result)<>0 then
   Result:=ReplaceStr(Result,'FEB','02')
 else
 if Pos('MAR',Result)<>0 then
   Result:=ReplaceStr(Result,'MAR','03')
 else
 if Pos('APR',Result)<>0 then
   Result:=ReplaceStr(Result,'APR','04')
 else
 if Pos('MAY',Result)<>0 then
   Result:=ReplaceStr(Result,'MAY','05')
 else
 if Pos('JUN',Result)<>0 then
   Result:=ReplaceStr(Result,'JUN','06')
 else
 if Pos('JUL',Result)<>0 then
   Result:=ReplaceStr(Result,'JUL','07')
 else
 if Pos('AUG',Result)<>0 then
   Result:=ReplaceStr(Result,'AUG','08')
 else
 if Pos('SEP',Result)<>0 then
   Result:=ReplaceStr(Result,'SEP','09')
 else
 if Pos('OCT',Result)<>0 then
   Result:=ReplaceStr(Result,'OCT','10')
 else
 if Pos('NOV',Result)<>0 then
   Result:=ReplaceStr(Result,'NOV','11')
 else
 if Pos('DEC',Result)<>0 then
   Result:=ReplaceStr(Result,'DEC','12')

end;

{$WARNINGS OFF}
function ToClientDateFmt( D:string;caseFmt:byte):string;
var
   Client_dateseparator,   Client_timeseparator  :Char;
   Client_LongDateFormat,
   Client_shortdateformat,Client_ShortTimeFormat :string;
   vD:TDateTime;
   IsKeyWord:boolean;


begin
  if IsBlank(D) then
  begin
    Result:=''; Exit;
  end;
    
  Client_dateseparator   := DateSeparator;
  Client_shortdateformat := ShortDateFormat;
  Client_timeseparator   := TimeSeparator;
  Client_ShortTimeFormat := ShortTimeFormat;
  Client_LongDateFormat  := LongDateFormat;

  IsKeyWord:=false;       Result:='';
  try
   if caseFmt<2 then
    if Pos('.',D)<>0 then
    begin
      DateSeparator   := '.';
      ShortDateFormat := 'dd.mm.yyyy';
    end
    else
    if Pos('/',D)<>0 then
    begin
     DateSeparator   := '/';
     ShortDateFormat := 'mm/dd/yyyy';
    end
    else
    if Pos('-',D)<>0 then
    begin
     D :=StrDDMMMYYYY(D);
     ShortDateFormat := 'dd.mm.yyyy';

    end
    else
    begin
     IsKeyWord:=true;
     Result:=UpperCase(D);
     Exit;
    end;
    TimeSeparator   := ':';
    ShortTimeFormat := 'h:m:s';
    case caseFmt of
      0: vD              := StrToDateTime(D);
      1: vD              := StrToDate(D);
      2: vD              := StrToTime(D);
    end;
  finally
   LongDateFormat  := Client_LongDateFormat;
   dateseparator   := Client_DateSeparator;
   ShortDateFormat := Client_ShortDateFormat;
   timeseparator   := Client_TimeSeparator;
   ShortTimeFormat := Client_ShortTimeFormat;

   if not IsKeyWord then
   case caseFmt of
     0: Result          := DateTimeToStr(vD);
     1: Result          := DateToStr(vD);
     2: Result          := TimeToStr(vD);
   end
 end;
end;
{$WARNINGS ON}

function TrimCLRF(const s:string): string;
var p,p1:integer;
begin
  p :=1;
  p1:=Length(s);
  while (s[p] in [' ',#13,#10,#9]) and (p<p1) do Inc(p);
  while (s[p1] in [' ',#13,#10,#9]) and (p1>0) do Dec(p1);
  if (p1<Length(s)) or (p>1) then
   DoCopy(s,Result,p,p1-p+1)
  else
   Result:=s;
end;

procedure CopyChars(const Src:string; var  Dest:string;
 StartInSrc,StartInDest,Count:integer );
var i:integer;
begin
 for i:=Count-1 downto 0 do
  Dest[StartInDest+i]:=Src[StartInSrc+i]
end;

function InternalReplaceStr(const S,S1, Srch, Replace: string): string;
var
  I,K,J,L,LR: Integer;
  LastLen:integer;
  Diff :integer;
  PosInResult:integer;
  RCount:integer;
label Again;

procedure DoReplace(const Src:string; var PosInResult:integer);
begin
 if K=0 then
 begin
   if Diff<>0 then
    CopyChars(Src,Result,J,1,I-1);
   CopyChars(Replace,Result,1,I,LR);
   PosInResult:=I-1+LR;
   Inc(RCount);
 end
 else
 begin
   if Diff>0 then
   begin
    Inc(LastLen,Diff);
    SetLength(Result,LastLen);
   end
   else
    Inc(RCount);
   if Diff<>0 then
    CopyChars(Src,Result,J,PosInResult+1,I-K-L);
   CopyChars(Replace,Result,1,PosInResult+I-K-L+1,LR);
   Inc(PosInResult,I-K-L+LR)
 end;

end;

begin
  I := Pos(Srch, S1);
  if I=0 then
   Result := S
  else
  begin
    L :=Length(Srch);
    LR:=Length(Replace);
    Diff :=LR-L;
    K:=0;
    LastLen:=Length(S);
    if Diff=0 then
     Result:=S
    else
    begin
      if Diff<=0 then
       RCount:=0
      else
       Inc(LastLen,Diff);
      SetString(Result,nil,LastLen);
    end;

    J:=1;
    DoReplace(S,PosInResult);
    J:=I+L;

Again:
      k:=i;
      I := PosInRight(Srch, S1,J);
      if I > 0 then
      begin
       DoReplace(S,PosInResult);
       J:=I+L;
goto Again;
      end;
   if Diff<>0 then
    CopyChars(S,Result,J,PosInResult+1,Length(S)-J+1);
   if Diff<0 then
     SetLength(Result,Length(S)+Diff*RCount);
  end;
end;

function ReplaceCIStr(const S, Srch, Replace: string): string;
begin
 Result:=InternalReplaceStr(S,AnsiUpperCase(S), AnsiUpperCase(Srch), Replace)
end;


function ReplaceStr(const S, Srch, Replace: string): string;
begin
 Result:=InternalReplaceStr(S,S, Srch, Replace)
end;



function ReplaceStrCIInSubstr(const Source :string;const Srch, Replace:string;
            BeginPos,EndPos:integer
): string;
var
  S:string;
begin
  S :=ReplaceCIStr(Copy(Source,BeginPos,EndPos-BeginPos+1),  Srch, Replace);
  Result := Copy(Source,1,BeginPos-1)+s+Copy(Source,EndPos+1,MaxInt);
end;


function ReplaceStrInSubstr(const Source :string;const Srch, Replace: string;
            BeginPos,EndPos:integer
): string;
var
  S:string;
begin
  S:=ReplaceStr(Copy(Source,BeginPos,EndPos-BeginPos+1), Srch, Replace);
  Result := Copy(Source,1,BeginPos-1)+s+Copy(Source,EndPos+1,MaxInt);
end;

function FastUpperCase(const S: string): string;
var
  L: Integer;
  Source, Dest: PChar;
begin
  L := Length(S);
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);
  while L <> 0 do
  begin
    if (Source^ >= 'a') and (Source^ <= 'z') then
     Dest^ := Chr(Byte(Source^)-32)
    else
     Dest^ := Source^;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

function EquelStrings(const s,s1:string; CaseSensitive:boolean):boolean;
var
  L: Integer;
  Source, Dest: PChar;
begin
  if CaseSensitive then
  begin
    Result:=s=s1; Exit; 
  end;    
  L := Length(S);
  if L<>Length(S1) then
  begin
   Result:=False;Exit;
  end;
  Source := Pointer(S);
  Dest   := Pointer(S1);
  while L <> 0 do
  begin
    if Source^>Dest^ then
    begin
      if (Byte(Source^)-32)<>Byte(Dest^) then
      begin
       Result:=False;Exit;
      end;
    end
    else
    if Source^<Dest^ then
    begin
      if (Byte(Source^)+32)<>Byte(Dest^) then
      begin
       Result:=False;Exit;
      end;
    end;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
  Result:=True;
end;

function ExtractWord(Num:integer;const Str: string;const  WordDelims:TCharSet):string;
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

function iifStr(Condition:boolean;const Str1,Str2:string ):string;
begin
 if Condition then Result:=Str1 else Result:=Str2
end;


function iifVariant(Condition:boolean;const Var1,Var2:Variant ):Variant;
begin
 if Condition then Result:=Var1 else Result:=Var2
end;


function FirstPos(Search:array of char ; const InString:string):integer;
var i:integer;
    p1:integer;
begin
 Result:=0;
 for i:=Low(Search) to High(Search) do
 begin
   p1:=PosCh(Search[i],InString);
   if (p1<>0) then
    if (p1<Result) or (Result=0) then
     Result:=p1
 end;
end;





function DoResultLine (const aLine : string ) : string;
var i,j : integer;
    L   : integer;
begin
  if aLine='' then
  begin
   Result:=''; Exit;
  end;
  L := Length(aLine);
  if L=1 then
  begin
   Result:=aLine; Exit;
  end;

  i := 1; j:=0;
  SetLength(Result,L);
  while i <= L do
  begin
   if ((i<L) or (aLine[i]<>'*'))  or ((j>0) and (Result[j]<>'*'))
   then
   begin
    Inc(j);
    Result[j]:= aLine[i];
   end;

   case aLine[i]  of
    '*': repeat
          Inc(i);
         until not (aLine[i] in ['*','?']) or (i = L);
   else
      Inc(i);
   end;

  end;
  SetLength(Result,j);
end;


function WildStringCompare( FirstString,SecondString : string ) : boolean;
function WildCompare (const FLine,SLine : string;OnlyOne:boolean ) : boolean;
var k : integer;
    l1,l2:integer;
    p1,p2:integer;

function Different (const FLine,SLine : string ;L1,L2:integer) : boolean;
begin
// ≈сли результат = тру => строки различны
// фальсе  =>  ничего путного сказать не можем
  if (l1>0) and (l2>0) then
  begin
    Result := (SLine[1]<>'*') and (SLine[1]<>'?')
       and (FLine[1]<>SLine[1])
       and (FLine[1]<>'*') and (FLine[1]<>'?');

  end
  else
  begin
    Result := ((l1=0) and (SLine<>'*'))
     or ((l2=0) and (FLine<>'*'));
  end;
end;

function Identical (const FLine,SLine : string) : boolean;
begin
  Result := (SLine = '*') or (FLine = '*') or (FLine=SLine)
end;

begin
  if Identical(FLine,SLine) then
  begin
    Result := true;
    exit;
  end;
  Result := False;

  l1:=Length(FLine);
  l2:=Length(SLine);
  if Different(FLine,SLine,l1,l2) then Exit;

  if not (SLine[1] in ['*','?']) and not (FLine[1] in ['*','?'])  then
  begin
   p1:= FirstPos(['?','*'],FLine);
   if p1=0 then p1:=l1+1;
   p2:= FirstPos(['?','*'],SLine);
   if p2=0 then p2:=l2+1;
   if p2<p1 then p1:=p2;
    if (Copy(FLine,1,p1-1)<>Copy(SLine,1,p1-1)) then
     Result:=False
    else
     Result := WildCompare(Copy(FLine,p1,l1),   Copy(SLine,p1,l2),OnlyOne);
   Exit;
  end;


  if (FLine[1]='*') then
  begin
   for k := 1 to l2 do
     if (SLine[k] in ['*',FLine[2],'?']) then
     begin
       Result := WildCompare(Copy(FLine,2,l1-1),Copy(SLine,k,l2-k+1),OnlyOne);
       if Result  then Exit
     end;
  end;

  if (SLine[1]='*') then
   for k := 1 to l1 do
    if (FLine[k] in ['*',SLine[2],'?']) then
    begin
     Result :=  WildCompare(Copy(FLine,k,l1-k+1), Copy(SLine,2,l2-1),OnlyOne);
     if Result then Exit
    end;


  if    (SLine[1]<>'*') and ((FLine[1]<>'*') )
   and  ((FLine[1] = SLine[1]) or((SLine[1]='?') or ((FLine[1]='?') )))
  then
       Result := WildCompare(Copy(FLine,2,l1-1),   Copy(SLine,2,l2-1),OnlyOne);
end;



begin
  FirstString       := DoResultLine(FirstString);
  SecondString      := DoResultLine(SecondString);
  Result            := WildCompare(FirstString,SecondString,false);
end;



function DoMaskCompare(const aString,Mask : string ;MaskChars: array of Char) : boolean;

    function WildCompare1 (const FLine,Mask : string) : boolean;
    var k : integer;
        l1,l2:integer;
        p1:integer;

    function Different (const FLine,Mask : string ;L1,L2:integer) : boolean;
    begin
    // ≈сли результат = тру => строки различны
    // фальсе  =>  ничего путного сказать не можем
      if (l1>0) and (l2>0) then
      begin
        Result := not (Mask[1] in [MaskChars[0],MaskChars[1]]) and (FLine[1]<>Mask[1])
      end
      else
      begin
        Result := ((l1=0) and (Mask<>MaskChars[0])) or (l2=0)
      end;
    end;
    
    function Identical (const FLine,Mask : string) : boolean;
    begin
      Result := (Mask = MaskChars[0]) or (FLine=Mask)
    end;

    begin
      if Identical(FLine,Mask) then
      begin
        Result := true;
        exit;
      end;
      Result := False;
    
      l1:=Length(FLine);
      l2:=Length(Mask);
      if Different(FLine,Mask,l1,l2) then Exit;
    
      if not (Mask[1] in [MaskChars[0],MaskChars[1]]) then
      begin
       p1:= FirstPos([MaskChars[0],MaskChars[1]],Mask);
       if p1=0 then
       begin
         Result:=FLine=Mask
       end
       else
       if (Copy(FLine,1,p1-1)<>Copy(Mask,1,p1-1)) then
         Result:=False
       else
         Result := WildCompare1(Copy(FLine,p1,l1),   Copy(Mask,p1,l2));
       Exit;
      end;
    
      if (Mask[1]=MaskChars[0]) then
       for k := 1 to l1 do
        if (FLine[k] =Mask[2]) then
        begin
         Result :=  WildCompare1(Copy(FLine,k,l1-k+1), Copy(Mask,2,l2-1));
         if Result then Exit
        end;


      if    (Mask[1]<>MaskChars[0])  and  ((FLine[1] = Mask[1]) or(Mask[1]=MaskChars[1]) )
      then
           Result := WildCompare1(Copy(FLine,2,l1-1),   Copy(Mask,2,l2-1));
    end;

begin //MaskCompare
  Result            := WildCompare1(aString,DoResultLine(Mask));
end;

function SQLMaskCompare(const aString,Mask : string ) : boolean;
begin
 Result:=DoMaskCompare(aString,Mask,['%','%']) ;
end;

function MaskCompare(const aString,Mask : string ) : boolean;
begin
 Result:=DoMaskCompare(aString,Mask,['*','?']) ;
end;

//
function WldIndexOf(ts:TStrings;const Value:string;CaseSensitive:boolean):integer;
var i:integer;
begin
 Result:=-1;
 for i:=0 to Pred(ts.Count) do
  if WildStringCompare( iifStr(CaseSensitive, ts[i],AnsiUpperCase(ts[i])),
   iifStr(CaseSensitive, Value,AnsiUpperCase(Value))
  ) then
  begin
   Result:=i; Exit
  end;
end;

//


function StrOnMask(const StrIn, MaskIn, MaskOut: string):string;
var  k,j,len:integer;
begin
  len:=Length(StrIn);
  Result:='';
  for j:=1 to Len do
  begin
    k:=PosCh(StrIn[j],MaskIn);
    if k = 0 then
     Result:=Result+StrIn[j]
    else
     if Length(MaskOut)>k then      Result:=Result+MaskOut[k]
  end;
end;

function StrIsInteger(const Str:string):boolean;
var L,i:integer;
begin
  L:=Length(Str); Result:=false;
  for i :=1  to l do
  begin
    Result:=Str[i] in ['0','1'..'9'];
    if Result then Exit;
  end;
end;

function EasyLikeStr( Str1,Str2:string) :boolean; // Only Russian texts

procedure DoSpoilString(var str:string);
const
 MaskSymbols=['A'..'Z','0'..'9','ј'..'я'];
 IgnoreSymbols=['№','Џ'];
var i:integer;
    bufStr:string;
    LastChar:char;
begin
 bufStr:='';
 lastChar:=#0;
 for i:=1 to Length(Str) do
  if     (Str[i] in MaskSymbols)
     and not (Str[i] in IgnoreSymbols)
     and (Str[i]<>LastChar)
   then   begin
    bufStr:=bufStr+Str[i];
    lastChar:=Str[i]
   end;
  Str:=StrOnMask(bufStr,'«Ѕ»…јЁџ√ёƒ∆„','—ѕ≈≈ќќE ”“ЎЎ');
 // Ўипим
end;


begin
 Str1:=AnsiUpperCase(Str1); Str2:=AnsiUpperCase(Str2);
 if (Length(Str1)>8) and (Length(Str2)>8) then
 begin
 // ƒавим гласные
  Str1:= StrOnMask(Str1,'”≈џјќЁя»ё…','          ');
  Str2:= StrOnMask(Str2,'”≈џјќЁя»ё…','          ');
 end;
 DoSpoilString(Str1); DoSpoilString(Str2);
 Result:=(Pos(Str2,Str1)>0) or (Pos(Str1,Str2)>0)
end;

function LastChar(const Str:string):Char;
var
  l:integer;
begin
 l:=Length(Str);
 if l>0 then
  Result:=Str[l]
 else
  Result:=#0;
end;

function QuotedStr(const S: string): string;
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do
    if Result[I] = '''' then Insert('''', Result, I);
  Result := '''' + Result + '''';
end;

function CutQuote(const S: string): string;
var
  I: Integer;
  QuoteChar:Char;
  LastPos:integer;
begin
  Result := S;
  QuoteChar:='&';
  LastPos:=-1;
  for I := Length(Result) downto 1 do
   case Result[I] of
   '''','"':
    begin
     QuoteChar:=Result[I];
     LastPos:=I;
     Break;
    end;
   ' ',#9,#13,#10:;
   else
      Exit;
   end;
  for I := 1 to LastPos-1 do
  case Result[I] of
   '''','"':
   if Result[I]=QuoteChar then     
   begin
     Result:=Copy( Result,i+1,LastPos-i-1); Exit;
   end;
   ' ',#9,#13,#10:;
   else
      Exit;
  end;
end;


function  EmptyStrings(SL:TStrings):boolean;
var i,l:integer;
begin
 Result:= SL.Count=0;
 if not Result then
 begin
  l:=SL.Count-1;
  for i :=0  to l do
  begin
   Result:=SL[i]='';
   if not Result then exit;
  end;
 end;
end;


procedure DeleteEmptyStr(Src:TStrings);
var I:integer;
begin
 i:=0;
 while i<Src.Count do
  if Src[i]='' then Src.Delete(i)
  else Inc(i)
end;


function NonAnsiSortCompareStrings(SL: TStringList; Index1, Index2: Integer):Integer;
begin
{$IFDEF D6+}
  if SL.CaseSensitive then
    Result := CompareStr(SL[Index1], SL[Index2])
  else
{$ENDIF}
    Result := CompareText(SL[Index1], SL[Index2]);
end;


function  FindInDiapazon(SL:TStringList;const S: string;const StartIndex,EndIndex:integer;
 AnsiCompare:boolean; var Index: Integer
):boolean;
var
  L, H, I, C: Integer;
function CompareStrings(const S1, S2: string): Integer;
begin
  if AnsiCompare then
  begin
{$IFDEF D6+}
   if SL.CaseSensitive then
     Result := AnsiCompareStr(S1, S2)
   else
{$ENDIF}
     Result := AnsiCompareText(S1, S2);
  end
  else
  begin
{$IFDEF D6+}
    if SL.CaseSensitive then
      Result := CompareStr(S1, S2)
    else
{$ENDIF}    
      Result := CompareText(S1, S2);
  end;
end;

begin
  Result := False;
  with SL do
  begin
    if StartIndex<0 then
     L := 0
    else
     L :=StartIndex;     
    if EndIndex>=Count then
     H := Count - 1
    else
     H :=EndIndex;
    while L <= H do
    begin
      I := (L + H) shr 1;
      C := CompareStrings(Strings[I], S);
      if C < 0 then L := I + 1 else
      begin
        H := I - 1;
        if C = 0 then
        begin
          Result := True;
          if Duplicates <> dupAccept then L := I;
        end;
      end;
    end;
    Index := L;
  end;

end;

procedure SLDifference(ASL,BSL:TStringList;ResultSL:TStrings);
var i,c,j:integer;
begin
 ResultSL.Clear;
 c:=Pred(ASL.Count);
 if not BSL.Sorted then
  for i:=0 to c do
  begin
    if BSL.IndexOf(ASL[i])=-1 then ResultSL.AddObject(ASL[i],ASL.Objects[i])
  end
 else
  for i:=0 to c do
  begin
    if not BSL.Find(ASL[i],j) then
      ResultSL.AddObject(ASL[i],ASL.Objects[i])
  end
end;

procedure GetNameAndValue(const s:string; var Name,Value:string);
var pEq:integer;
begin
    pEq:=PosCh('=', s);
    if pEq=0 then
    begin
     Name  :=s;
     Value :=''
    end
    else
    begin
     Name  := Copy(s,1, pEq - 1);
     Value := Copy(s, pEq + 1, Length(s))
    end;
end;

var
      KeyWordsIndexes: array['A'..'Z','A'..'Z',0..1] of word;
      KeyWords :TStringList;
const
   NonQuotedChars=['_', '$','%','#'];


function InternalNeedQuote(const Name:string; Easy:boolean):boolean;
var
     I,L:integer;
     Ch1,Ch2:Char;
begin
 Result:=Name<>'';
 if not Result then Exit;
 Result:=Name[1]='"';
 if Result then Exit;
 L:=Length(Name);
 for i:=1 to L do
 begin
  Result:=
   ((Name[i] <'A') or (Name[i]>'Z')) and
   ((Name[i] <'0') or (Name[i]>'9')) and
   not (Name[i] in NonQuotedChars);
  if Result and (Easy and (Name[i] >='a') and (Name[i]<='z')) then
    Result := False;
  if Result then Exit;
 end;

 if L>0 then
 begin
   Ch1:=Name[1];
   if (Ch1>='0') and (Ch1<='9') then
   begin
    Result := True; Exit;
   end;
   if L>1 then
   begin
    Ch2:=Name[2];
    if (Ch2>='0') and (Ch2<='9') then
    begin
      Result := False; Exit;
    end;

    if Easy then
    begin
     if (Ch1 >= 'a') and (Ch1 <= 'z') then    Dec(Ch1,32);
     if (Ch2 >= 'a') and (Ch2 <= 'z') then    Dec(Ch2,32);
    end;
    Result:=FindInDiapazon(KeyWords,
     Name,KeyWordsIndexes[Ch1,Ch2,0],KeyWordsIndexes[Ch1,Ch2,1], False,i
    )
   end;

 end;
end;

function NeedQuote(const Name:string):boolean;
begin
 Result:= InternalNeedQuote(Name,False);
end;


function EasyNeedQuote(const Name:string):boolean;
begin
 Result:= InternalNeedQuote(Name,True);
end;


function Q_StrLen(P: PChar): Cardinal; assembler;
asm
        TEST    EAX,EAX
        JE      @@qt
        PUSH    EBX
        LEA     EDX,[EAX+1]
@L1:    MOV     EBX,[EAX]
        ADD     EAX,4
        LEA     ECX,[EBX-$01010101]
        NOT     EBX
        AND     ECX,EBX
        AND     ECX,$80808080
        JZ      @L1
        TEST    ECX,$00008080
        JZ      @L2
        SHL     ECX,16
        SUB     EAX,2
@L2:    SHL     ECX,9
        SBB     EAX,EDX
        POP     EBX
@@qt:
end;

const
  InternalFunctionCount = 10;
  DefKeywordsCount = 276;
  DefTypesCount = 17;

  InternalFunctions: array [0..InternalFunctionCount-1] of string =
   ('AVG',    'CAST',    'COUNT',    'GEN_ID',
    'MAX',    'MIN',     'SUM',      'UPPER',
//Additional FB and YA
    'IIF',    'SUBSTRING'
   );
  DefKeywords: array [0..DefKeywordsCount-1] of string = ('ACTIVE','ADD','AFTER','ALL','ALTER','AND','ANY',
    'AS','ASC','ASCENDING','AT','AUTO','AUTODDL','BASED','BASENAME','BASE_NAME','BEFORE',
    'BEGIN','BETWEEN',
    'BLOBEDIT','BUFFER','BY','CASE','CACHE','CHARACTER_LENGTH','CHAR_LENGTH','CHECK',
    'CHECK_POINT_LEN','CHECK_POINT_LENGTH','COLLATE','COLLATION','COLUMN','COMMIT',
    'COMMITED','COMPILETIME','COMPUTED','CLOSE','CONDITIONAL','CONNECT','CONSTRAINT',
    'CONTAINING','CONTINUE','CREATE','CURRENT','CURRENT_DATE','CURRENT_TIME',
    'CURRENT_TIMESTAMP','CURSOR','DATABASE','DAY','DB_KEY','DEBUG','DEC','DECLARE','DEFAULT',
    'DELETE','DESC','DESCENDING','DESCRIBE','DESCRIPTOR','DISCONNECT','DISTINCT','DO',
    'DOMAIN','DROP','ECHO','EDIT','ELSE','END','ENTRY_POINT','ESCAPE','EVENT','EXCEPTION',
    'EXECUTE','EXISTS','EXIT','EXTERN','EXTERNAL',
    'EXTRACT',   'FALSE',
    'FETCH','FILE','FILTER','FOR',
    'FOREIGN','FOUND','FROM','FULL', 
    'FUNCTION','GDSCODE','GENERATOR','GLOBAL','GOTO','GRANT',
    'GROUP',
    'GROUP_COMMIT_WAIT','GROUP_COMMIT_WAIT_TIME',  
    'HAVING','HELP','HOUR','IF',
    'IMMEDIATE','IN','INACTIVE','INDEX',  
    'INDICATOR','INIT','INNER',
    'INPUT','INPUT_TYPE',
    'INSERT','INT','INTO','IS','ISOLATION','ISQL','JOIN',
    'KEY','LC_MESSAGES','LC_TYPE','LEFT',
    'LENGTH','LEV','LEVEL','LIKE','LOGFILE','LOG_BUFFER_SIZE','LOG_BUF_SIZE','LONG','MANUAL', 
    'MAXIMUM','MAXIMUM_SEGMENT','MAX_SEGMENT','MERGE','MESSAGE','MINIMUM','MINUTE',
    'MODULE_NAME','MONTH','NAMES','NATIONAL','NATURAL','NCHAR','NO','NOAUTO','NOT','NULL',
    'NUM_LOG_BUFFS','NUM_LOG_BUFFERS','OCTET_LENGTH','OF','ON','ONLY','OPEN','OPTION','OR',
    'ORDER','OUTER','OUTPUT','OUTPUT_TYPE','OVERFLOW',
    'PAGE','PAGELENGTH','PAGES','PAGE_SIZE','PARAMETER','PASSWORD',                  
    'PLAN',
    'POSITION','POST_EVENT','PRECISION','PREPARE','PROCEDURE',
    'PROTECTED','PRIMARY','PRIVILEGES','PUBLIC','QUIT','RAW_PARTITIONS','READ','REAL',
    'RECORD_VERSION','REFERENCES','RELEASE','RESERV','RESERVING','RETAIN','RETURN',
    'RETURNING_VALUES','RETURNS','REVOKE','RIGHT',
    'ROLLBACK','RUNTIME','SAVEPOINT','SCHEMA','SECOND',
    'SEGMENT','SELECT',
    'SET','SHADOW','SHARED','SHELL','SHOW','SINGULAR','SIZE','SNAPSHOT','SOME',   
    'SORT','SQL','SQLCODE','SQLERROR','SQLWARNING','STABILITY','STARTING','STARTS',
    'STATEMENT','STATIC','STATISTICS','SUB_TYPE','SUSPEND','TABLE','TERMINATOR','THEN','TO',
    'TRANSACTION','TRANSLATE','TRANSLATION','TRIGGER','TRIM','TRUE','TYPE','UNCOMMITTED',
    'UNION', 'UNIQUE','UNKNOWN','UPDATE','USER','USING','VALUE','VALUES',
    'VARIABLE','VARYING','VERSION','VIEW',
    'WAIT','WEEKDAY','WHEN','WHENEVER','WHERE ','WHILE','WITH',
    'WORK','WRITE','YEAR','YEARDAY',
//Additional
    'FIRST','SKIP','RECREATE','CURRENT_USER',
    'CURRENT_ROLE','PLANONLY','LIMIT','SECONDS',
    'ROWS',
    'PERCENT','TIES','NEW','OLD',       
    'CURRENT_CONNECTION', 'CURRENT_TRANSACTION',

    'INSERTING','UPDATING','DELETING','ROW_COUNT','FREE_IT'
    );

  DefTypes: array [0..DefTypesCount-1] of string =
  ('BLOB','CHAR','CHARACTER','DATE','DECIMAL','DOUBLE','FLOAT','INTEGER',
    'NUMERIC','SMALLINT','TIME','TIMESTAMP','VARCHAR',
//Additional
    'INT64', 'BIGINT', 'BOOLEAN', 'CSTRING');

var
   I: Integer;
   OldChar:Char;
   OldChar1:Char;



initialization
 KeyWords       :=TStringList.Create;
 for I := 0 to InternalFunctionCount - 1 do
 begin
   KeyWords.Add(InternalFunctions[I])
 end;
   ;
 for I := 0 to DefKeywordsCount - 1 do
 begin
   KeyWords.Add(DefKeywords[I]);
 end;

 for I := 0 to DefTypesCount - 1 do
 begin
   KeyWords.Add(DefTypes[I]);
 end;
 KeyWords.CustomSort(NonAnsiSortCompareStrings);
 OldChar:='A'; OldChar1:='A';
 KeyWordsIndexes['A','A',0]:=0;
 for I := 0 to KeyWords.Count - 1 do
  if (OldChar<>KeyWords[I][1]) or (OldChar1<>KeyWords[I][2]) then
  begin
    KeyWordsIndexes[OldChar,OldChar1,1]:=I-1;
    KeyWordsIndexes[KeyWords[I][1],KeyWords[I][2],0]:=I;
    OldChar :=KeyWords[I][1];
    OldChar1:=KeyWords[I][2];
  end;
  KeyWordsIndexes[OldChar,OldChar1,1]:=KeyWords.Count-1;
finalization
 KeyWords.Free
end.



