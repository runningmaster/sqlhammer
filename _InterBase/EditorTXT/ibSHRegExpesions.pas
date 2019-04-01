unit ibSHRegExpesions;

interface

uses Classes, Graphics, SysUtils,Types,
     pSHRegExpr, pSHStrUtil, pSHSqlTxtRtns, pSHQStrings;

const
//  rePlayerExpr1 = '((CONNECT([\x20\x0D\x0A\x09])+(["]|[''])[\/\\\:\*\?\"\<\>\|]+(["]|['']))|';
  rePlayerExpr1 = 'CONNECT([\x20\x0D\x0A\x09])+(["]|[''])[^\/\\\:\*\?\"\<\>\|]+(["]|[''])|';
  rePlayerExpr2 = 'CREATE([\x20\x0D\x0A\x09])+DATABASE([\x20\x0D\x0A\x09])+(["]|[''])[^\/\\\:\*\?\"\<\>\|]+(["]|[''])|';
  rePlayerExpr3 = '\bCREATE([\x20\esx0D\x0A\x09])+(DOMAIN|TABLE|VIEW|PROCEDURE|TRIGGER|GENERATOR|EXCEPTION|EXTERNAL([\x20\x0D\x0A\x09])+FUNCTION|ROLE|INDEX)([\x20\x0D\x0A\x09])+\b([_a-zA-Z][_a-zA-Z\d]+|["][^"]+["])\b|';
  rePlayerExpr4 = '\bALTER([\x20\x0D\x0A\x09])+(DATABASE|DOMAIN|TABLE|VIEW|PROCEDURE|TRIGGER|GENERATOR|EXCEPTION|EXTERNAL([\x20\x0D\x0A\x09])+FUNCTION|ROLE|INDEX)([\x20\x0D\x0A\x09])+\b([_a-zA-Z][_a-zA-Z\d]+|["][^"]+["])\b|';
  rePlayerExpr5 = '\bDROP([\x20\x0D\x0A\x09])+(DATABASE|DOMAIN|TABLE|VIEW|PROCEDURE|TRIGGER|GENERATOR|EXCEPTION|EXTERNAL([\x20\x0D\x0A\x09])+FUNCTION|ROLE|INDEX)([\x20\x0D\x0A\x09])+\b([_a-zA-Z][_a-zA-Z\d]+|["][^"]+["])\b|';
  rePlayerExpr6 = 'SET([\x20\x0D\x0A\x09])+GENERATOR([\x20\x0D\x0A\x09])+\b([_a-zA-Z][_a-zA-Z\d]+|["][^"]+["])\b';

  rePlayerExpr = rePlayerExpr1 + rePlayerExpr2 + rePlayerExpr3 + rePlayerExpr4 + rePlayerExpr5 + rePlayerExpr6;

  reIndexRetrieveFromPlanExpr = '\((?i)RDB\$?[A-Za-z\$_\d]+';

  reErrorLineColInformation = '(?-i)Token\x20unknown\x20\-\x20line\x20\d+,\x20char\x20\d+\.';
  reErrorLineInformation = '(?-i)Token\x20unknown\x20\-\x20line\x20\d+';
  reErrorColInformation = '(?-i),\x20char\x20\d+';


  procedure ParseProcParams(AText, AInputList, AOutPutList, ALocalList: TStrings);

implementation

(*const
  reProcDataType1 = '\b(SMALLINT\b|INTEGER\b|FLOAT\b|DOUBLE PRECISION\b|(DECIMAL\b|NUMERIC\b)(\x20)?\((\d)+(,(\d)+)?\)|DATE\b|TIME\b|TIMESTAMP\b|(CHAR\b|CHARACTER\b|VARCHAR\b|CHARACTER VARYING\b)(\x20)?\((\d)+\)|(NCHAR|NATIONAL CHARACTER|NATIONAL CHAR)\x20VARYING\b';
  reProcDataType2 = '(\x20)?\((\d)+\)|BLOB\b((\x20SUB_TYPE\x20(\d+|\w{1,}))(\x20SEGMENT\x20SIZE\x20(\d)+)?|\((\d)+(,(\d)+)?\))?(\x20CHARACTER\x20SET\x20(.){4,})?|INT64\b|LARGEINT\b|BIGINT\b|BOOLEAN\b)';
  reProcDefParamValues='((\x20)?=(\x20)?((NULL)|([\''][^'']*[\'']|(\-)?(\d)+(\.(\d)+)?)))?';
  reProcDataType = reProcDataType1 + reProcDataType2+reProcDefParamValues;

  reProcParam = '(\b[_a-zA-Z][$_a-zA-Z\d]*\x20|["][^"]+["](\x20)?)' + reProcDataType;
//  reProcLocalVar = '((DECLARE VARIABLE)|(DECLARE)) ' + reProcParam + '(\x20)?;';
  reProcLocalVar = '(((DECLARE VARIABLE)|(DECLARE)) ' + reProcParam +'(\x20)?);';
*)

// Разочарован регулярными выражениями.
// Неустойчиво к нововведениям абсолютно

{$DEFINE BUZZ}

{$IFDEF BUZZ}

type

TState = (sNormal,sInQuote,sInDoubleQuote,sInComment);
TSection =(scCREATE,scInput,scOutPut,scVariables,scWaitInput,scWaitOutPut,scWaitVariables,scUnknown,scEnd);


{$DEFINE PREPARE_MEM}

procedure ParseProcParams(AText, AInputList, AOutPutList, ALocalList: TStrings);
var
  I,J: Integer;
  OpBr: Integer;
  LineTxt:string;
  LineLen:integer;
  State:TState;
  Section:TSection;
  vTemp:string;

  Allocated:integer;
  CurPos   :integer;
  FirstSpace:boolean;

procedure SetCharToTmpStr(OverChar:Char);
begin
{$IFNDEF PREPARE_MEM}
  if (Section in [scInput,scOutPut,scVariables]) and (State<>sInComment)  then
     vTemp:=vTemp+PStr^[j];
{$ELSE}
 if (Section in [scInput,scOutPut,scVariables]) and (State<>sInComment)  then
  begin
   Inc(CurPos);
   if CurPos>Allocated then
   begin
    Inc(Allocated,21);
    SetLength(vTemp,Allocated);
   end;
{   if OverChar=#0 then
    OverChar:=LineTxt[j];}
   case State of
    sNormal:
     if (OverChar=' ') and((CurPos=1)  or (CurPos>1) and  (vTemp[CurPos-1]=' ')) then
      Dec(CurPos)
     else
     if (OverChar=' ') and FirstSpace  then
     begin
      vTemp[CurPos]:='=';
      FirstSpace:=False
     end
     else
      vTemp[CurPos]:=OverChar
   else
    vTemp[CurPos]:=OverChar
   end
  end;
{$ENDIF}
end;

procedure AddToList (List:TStrings; var ParString:string);
var
   vStrToAdd:string;
begin
{$IFDEF PREPARE_MEM}
 vStrToAdd:=ParString;
 SetLength(vStrToAdd,CurPos);
 List.Add(vStrToAdd);
 CurPos:=0;
 FirstSpace:=True;
{$ELSE}
 ParString:='';
{$ENDIF}
end;

begin
  AInputList.Clear;
  AOutPutList.Clear;
  ALocalList .Clear;

  Allocated:=100;
{$IFDEF PREPARE_MEM}
  SetLength(vTemp,Allocated);
  CurPos:=0;
  FirstSpace:=True;  
{$ELSE}
  vTemp:='';
{$ENDIF}


    if AText.Count > 0 then
    begin
      State:=sNormal;
      Section:=scCREATE;
      OpBr:=0;
      for i:=0 to Pred(AText.Count) do
      begin
        if Section=scEnd then
          Exit;
       SetCharToTmpStr(' ');
       LineTxt:=AText[I]; //  Вроде без копирования данных обходится
       LineLen:=Length(LineTxt);
       j:=1;

       while j<=LineLen do
       begin
        if Section=scEnd then  Exit;

        case LineTxt[j] of
         ',':  case State of
                 sNormal:
                 if OpBr>1 then
                 begin
                  SetCharToTmpStr(LineTxt[j])
                 end
                 else
                 begin
                  case Section of
                   scInput :
                   begin
                      AddToList(AInputList,vTemp);
                   end;
                   scOutPut:
                   begin
                      AddToList(AOutputList,vTemp);
                   end;
                   scVariables:
                    SetCharToTmpStr(LineTxt[j]);                   
                  end
                 end;
                 sInQuote,sInDoubleQuote:
                 begin
                  SetCharToTmpStr(LineTxt[j])
                 end;
               end;
         ';' :
          case State of
                 sNormal:
                 begin
                  case Section of
                   scVariables :
                   begin
                      AddToList(ALocalList,vTemp);
                   end;
                  end
                 end;
                 sInQuote,sInDoubleQuote:
                 begin
                  SetCharToTmpStr(LineTxt[j])
                 end;
               end;
         '''': case State of
                sNormal  :
                begin
                 SetCharToTmpStr(LineTxt[j]);
                 State:=sInQuote;
                end;
                sInQuote :
                begin
                 SetCharToTmpStr(LineTxt[j]);
                 State:=sNormal;
                end
               end;
         '"':  case State of
                sNormal        :
                begin
                 SetCharToTmpStr(LineTxt[j]);
                 State:=sInDoubleQuote;
                end;
                sInDoubleQuote :
                begin
                 SetCharToTmpStr(LineTxt[j]);
                 State:=sNormal;
                end
               end;
         '-': if State=sNormal then
               if (j<LineLen) and (LineTxt[j+1]='-') then
                 Break; // FB Comment
         '/': case State of
               sNormal:
                if (j<LineLen) and (LineTxt[j+1]='*') then
                 State:=sInComment
                else
                 SetCharToTmpStr(LineTxt[j]);

               sInComment:
                if (j>1) and (LineTxt[j-1]='*') then
                 State:=sNormal
                else
                 SetCharToTmpStr(LineTxt[j]);

              else
                 SetCharToTmpStr(LineTxt[j]);
              end;
         'B','b':
          begin
              if (State=sNormal)  and (Section=scVariables) then
               if (j=1) or (LineTxt[j-1] in CharsBeforeClause+[';']) then
               if (LineLen=5) or ((LineLen>5) and (LineTxt[j+5] in CharsAfterClause)) then
                if UpperCase(Copy(LineTxt,j+1,4))='EGIN' then
                 begin
                   Section:=scEnd;
                   Break
                 end;
             SetCharToTmpStr(LineTxt[j]);
          end;
         'D','d':
          begin
              if (State=sNormal)  and (Section=scVariables)
               and ((j=1) or (LineTxt[j-1] in CharsBeforeClause)) and
                ((LineLen=7) or ((LineLen>7) and (LineTxt[j+7] in CharsAfterClause)))
              and (UpperCase(Copy(LineTxt,j+1,6))='ECLARE') then
              begin
                   Inc(j,7);
              end
              else
               SetCharToTmpStr(LineTxt[j]);
          end;

         ')':
          begin
            if  (State in [sInQuote,sInDoubleQuote])  then
            begin
               SetCharToTmpStr(LineTxt[j]);
            end
            else
            if (State=sNormal)  then
            begin
             Dec(OpBr);
             if OpBr>0 then
             begin
              SetCharToTmpStr(LineTxt[j]);
             end
             else
             if OpBr=0 then
             begin
                case Section of
                 scInput    :
                 begin
                  Section:=scWaitOutPut;
                  AddToList(AInputList,vTemp);
                 end;
                 scOutPut   :
                 begin
                  Section:=scWaitVariables;;
                  AddToList(AOutPutList,vTemp);
                 end;
                 scVariables:
                  SetCharToTmpStr(LineTxt[j]);
                end; //case section
             end;
            end
          end;
         '(':
          begin
              SetCharToTmpStr(LineTxt[j]);
              if (State=sNormal)  then
              begin
                case Section of
                 scWaitInput : Section:=scInput;
                 scWaitOutPut: Section:=scOutPut;
                end;
                Inc(OpBr);
              end
          end;
         'A','a':
         begin
            SetCharToTmpStr(LineTxt[j]);
            if (State=sNormal)  and (Section in [scWaitVariables,scWaitInput,scWaitOutPut]) then
               if (j=1) or (LineTxt[j-1] in [' ',#10,#9,#13,'/']) then
               if (LineLen=j+1) or ((LineLen>j+1) and (LineTxt[j+2] in [' ',#9,#13,#10])) then
//                if UpperCase(Copy(LineTxt,j,2))='AS' then
                 if   LineTxt[j+1] in ['S','s'] then
                 begin
                   Section:=scVariables;
                   Inc(j,2)
                 end;
          end;
         'P','p':
         begin
             SetCharToTmpStr(LineTxt[j]);
             if (State=sNormal)  and (Section=scCREATE) then
               if (j=1) or (LineTxt[j-1] in [' ',#10,#9,#13,'/']) then
               if (LineLen=j+8) or ((LineLen>j+8) and (LineTxt[j+9] in [' ',#9,#13,#10])) then
                if UpperCase(Copy(LineTxt,j+1,8))='ROCEDURE' then
                 begin
                   Section:=scWaitInput;
                   Inc(j,9)
                 end;
         end;
         'R','r':
         begin
             SetCharToTmpStr(LineTxt[j]);
             if (State=sNormal)  and (Section in [scWaitInput,scWaitOutPut]) then
               if (j=1) or (LineTxt[j-1] in [' ',#10,#9,#13,'/',')']) then
               if (LineLen=j+6) or ((LineLen>j+6) and (LineTxt[j+7] in [' ',#9,#13,#10,'('])) then
                if UpperCase(Copy(LineTxt,j+1,6))='ETURNS' then
                 begin
                   Section:=scWaitOutPut;
                   Inc(j,7)
                 end;
          end;
         'T','t':
          begin
             SetCharToTmpStr(LineTxt[j]);
             if (State=sNormal)  and (Section=scCREATE) then
               if (j=1) or (LineTxt[j-1] in [' ',#10,#9,#13,'/']) then
               if (LineLen=j+6) or ((LineLen>j+6) and (LineTxt[j+7] in [' ',#9,#13,#10])) then
                if UpperCase(Copy(LineTxt,j+1,6))='RIGGER' then
                 begin
                   Section:=scWaitVariables;
                   Inc(j,7)
                 end;
          end;
         'V','v':
          begin
              if (State=sNormal)  and (Section=scVariables)
               and ((j=1) or (LineTxt[j-1] in CharsBeforeClause)) and
                ((LineLen=j+7) or ((LineLen>J+7) and (LineTxt[j+8] in CharsAfterClause)))
              and (UpperCase(Copy(LineTxt,j+1,7))='ARIABLE') then
              begin
                   Inc(j,8);
              end
              else
               SetCharToTmpStr(LineTxt[j]);
          end;

        else {Case}
          SetCharToTmpStr(LineTxt[j]);
        end;
       Inc(j);
      end
     end;
end;
end;

{$ENDIF}

{$IFNDEF BUZZ}
//Buzz:??????!!!!! Нема слов
// За такие процедуры надо расстреливать на месте
function PrepareText(const AText: TStrings; var AInputParams, AOutPutParams, ALocalParams: string): Boolean;
var
  vText: TStringList;
  vPosBodyBegin: Integer;
  vTemp: string;
  I: Integer;
  OpBr: Integer;
  PosBracket, PosReturns, PosAs: Integer;
begin
  AInputParams := '';
  AOutPutParams := '';
  ALocalParams := '';
  Result := True;
  vText := TStringList.Create;
  try
    vText.AddStrings(AText);
    if vText.Count > 0 then
    begin
//      vText.Delete(0); //при условии представления процедур принятом в БТ
      //удаляем закомментированные строки
      for I := vText.Count - 1 downto 0 do
        if Pos('--', vText[I]) = 1 then
          vText.Delete(I);

      vTemp := vText.Text;
      //удаляем коментарии
      I := 1;
      while I <= Length(vTemp) do
      begin
        case vTemp[I] of
          '/':
            begin
              if (((I + 1) <= Length(vTemp)) and (vTemp[I + 1] = '*')) then
              begin
                Inc(I, 2);
                while ((I + 1) <= Length(vTemp)) and (vTemp[I] <> '*') and (vTemp[I + 1] <> '/') do
                  Delete(vTemp, I, 1);
                Dec(I, 2);
                Delete(vTemp, I, 4);
              end
              else
                Inc(I);
            end;
          else
            Inc(I);
        end;
      end;
      vPosBodyBegin := PosExtCI('BEGIN', vTemp, CharsBeforeClause, CharsAfterClause);
      if vPosBodyBegin = 0 then
        vPosBodyBegin := PosExtCI('END', vTemp, CharsBeforeClause, CharsAfterClause) //на всякий случай, может пригодиться
      else
        vPosBodyBegin := vPosBodyBegin - 1; //отрезаем BEGIN
      if vPosBodyBegin = 0 then
        vPosBodyBegin := Length(vTemp); //когда совсем плохо
      if vPosBodyBegin > 0 then
      begin
        vTemp := copy(vTemp, 1, vPosBodyBegin);
        //убираем нафиг табуляции, переносы строк и двойные пробелы по рекомендации Соколова
        vTemp := Q_ReplaceStr(vTemp, #9, ' ');
        vTemp := Q_ReplaceStr(vTemp, #13#10, ' ');
        while Pos('  ', vTemp) > 0 do
          vTemp := Q_ReplaceStr(vTemp, '  ', ' ');
        vTemp := Trim(vTemp);
        I := 1;
        OpBr := 0;

        PosBracket := Pos('(', vTemp);
        PosReturns := PosExtCI('RETURNS', vTemp, CharsBeforeClause, CharsAfterClause);
        PosAs := PosExtCI('AS', vTemp, CharsBeforeClause, CharsAfterClause);

        if (Length(vTemp) > 0) and
           (PosBracket > 0) and
           ((PosBracket < PosReturns) or (PosReturns = 0)) and
           (PosBracket < PosAs) then
//        if ((Length(vTemp) > 0) and (vTemp[1] = '(')) then
        begin
          //получаем входные параметры
          Delete(vTemp, 1, PosBracket - 1);
          while I <= Length(vTemp) do
          begin
            //грохаем пробелы в скобках после CHAR и иже с ними
            case vTemp[I] of
              '(':
                begin
                  Inc(OpBr);
                  if OpBr = 1 then
                    Delete(vTemp, I, 1)
                  else
                    Inc(I);
                end;
              ')':
                begin
                  Dec(OpBr);
                  if OpBr = 0 then
                  begin
                   //конец входных параметров - вываливаемся
                    Delete(vTemp, I, 1);
                    AInputParams := copy(vTemp, 1, I - 1);
                    vTemp := copy(vTemp, I, MaxInt);
                    break;
                  end
                  else
                    Inc(I);
                end;
              ' ':
                begin
                  if OpBr > 1 then
                    Delete(vTemp, I, 1)
                  else
                    Inc(I);
                end;
              else Inc(I);
            end;          
            if (I > 6) and (PosExtCI('RETURNS', vTemp, CharsBeforeClause, CharsAfterClause) = (I - 6)) then
            begin
            //если юзер не закрыл скобку, то придем сюда, Х. не приходит :)
              AInputParams := copy(vTemp, 1, I - 7);
              vTemp := copy(vTemp, I - 6, MaxInt);
              break;
            end
            else
              if (I > 1) and (PosExtCI('AS', vTemp, CharsBeforeClause, CharsAfterClause) = (I - 1)) then
              begin
              //если юзер не закрыл скобку, то придем сюда, Х. не приходит :)
                AInputParams := copy(vTemp, 1, I - 2);
                vTemp := copy(vTemp, I - 1, MaxInt);
                break;
              end;
          end; //получаем входные параметры while I <= Length(vTemp) do

          if (AInputParams = '') and (OpBr = 1) and
             (PosExtCI('SELECT', vTemp, CharsBeforeClause, CharsAfterClause) = 0) and
             (PosExtCI('UPDATE', vTemp, CharsBeforeClause, CharsAfterClause) = 0) and
             (PosExtCI('INSERT', vTemp, CharsBeforeClause, CharsAfterClause) = 0) and
             (PosExtCI('DELETE', vTemp, CharsBeforeClause, CharsAfterClause) = 0) then
           begin
             AInputParams := vTemp;
             exit;
           end;
          //обработать возможный мусор перед RETURNS и AS
        end;
//RETURNS
        vTemp := Trim(vTemp);
        I := 1;
        OpBr := 0;
        PosReturns:=PosExtCI('RETURNS', vTemp, CharsBeforeClause, CharsAfterClause);
        if //(Length(vTemp) > 0) and
           (PosReturns > 0) then
        begin
{          while (PosExtCI('RETURNS', vTemp, CharsBeforeClause, CharsAfterClause) <> 1) do
            Delete(vTemp, 1, 1);}
          Delete(vTemp, 1, PosReturns+6);
          //получаем выходные параметры
          while I <= Length(vTemp) do
          begin
            //грохаем пробелы в скобках после CHAR и иже с ними
            case vTemp[I] of
              '(':
                begin
                  Inc(OpBr);
                  if OpBr = 1 then
                    Delete(vTemp, I, 1)
                  else
                    Inc(I);
                end;
              ')':
                begin
                  Dec(OpBr);
                  if OpBr = 0 then
                  begin
                   //конец выходные параметров - вываливаемся
                    Delete(vTemp, I, 1);
                    AOutPutParams := copy(vTemp, 1, I - 1);
                    vTemp := copy(vTemp, I, MaxInt);
                    break;
                  end
                  else
                    Inc(I);
                end;
              ' ':
                begin
                  if OpBr > 1 then
                    Delete(vTemp, I, 1)
                  else
                    Inc(I);
                end;
              else Inc(I);
            end;
            if (I > 1) and (PosExtCI('AS', vTemp, CharsBeforeClause, CharsAfterClause,False) = (I - 1)) then
            begin
            //если юзер не закрыл скобку, то придем сюда, Х. не приходит :)
              AOutPutParams := copy(vTemp, 1, I - 2);
              vTemp := copy(vTemp, I - 1, MaxInt);
              break;
            end;
          end; //получаем выходные параметры while I <= Length(vTemp) do

          if (AOutPutParams = '') and (OpBr = 1) and
             (PosExtCI('SELECT', vTemp, CharsBeforeClause, CharsAfterClause) = 0) and
             (PosExtCI('UPDATE', vTemp, CharsBeforeClause, CharsAfterClause) = 0) and
             (PosExtCI('INSERT', vTemp, CharsBeforeClause, CharsAfterClause) = 0) and
             (PosExtCI('DELETE', vTemp, CharsBeforeClause, CharsAfterClause) = 0) then
           begin
             AOutPutParams := vTemp;
             exit;
           end;
          //обработать возможный мусор перед RETURNS и AS
        end;
//RETURNS

//Local vars
        vTemp := Trim(vTemp);
{        I := 1;
        OpBr := 0;}
        PosAs:=PosExtCI('AS', vTemp, CharsBeforeClause, CharsAfterClause);
        if (Length(vTemp) > 0) and
           (PosAs > 0) then
        begin
          Delete(vTemp, 1, PosAs+2);

          //получаем локальные переменные
(*          while I <= Length(vTemp) do
          begin
            //грохаем пробелы в скобках после CHAR и иже с ними
            case vTemp[I] of
              '(':
                begin
                  Inc(OpBr);
                  Inc(I);
                end;
              ')':
                begin
                  Dec(OpBr);
                  Inc(I);
                end;
              ' ':
                begin
                  if OpBr > 0 then
                    Delete(vTemp, I, 1)
                  else
                    Inc(I);
                end;
              else Inc(I);
            end;
          end; //while I <= Length(vTemp) do}
*)          
          ALocalParams := vTemp;
        end;
//Local vars
      end;
    end;
  finally
    vText.Free;
  end;
end;

procedure ParseProcParams(AText, AInputList, AOutPutList, ALocalList: TStringList);
var
  vI, vO, vL: string;
  i,Start:integer;
  InQuote:boolean;
  OpenBr:integer;
  S :string;
begin
  PrepareText(AText, vI, vO, vL);
  if Length(vI)>0 then
  begin
    InQuote:=False;
    Start:=1;
    vI:=vI+',';
    OpenBr:=0;
    for i:=1 to Length(vI) do
    case vI[I] of

     '"': InQuote:=not InQuote;
     ',': if not InQuote and (OpenBr=0) then
          begin
//           AInputList.Add(Trim(Copy(vI,Start,i-Start)));
           S:=Trim(Copy(vI,Start,i-Start));
           S:=ReplaceCIStr(S,'=TYPE=','=TYPE ',False);
           S:=ReplaceCIStr(S,' OF=',' OF ',False);
           AInputList.Add(S);
           Start:=i+1;
          end;
      ' ': if not InQuote then
            if i=Start then
             Start:=Start+1
            else
            if (OpenBr=0) and  not (vI[i+1]in [',',' ','='])and not (vI[i-1]='=')  then
             vI[i]:='=';
      '(': if not InQuote then
            Inc(OpenBr);
       ')':if not InQuote then
            Dec(OpenBr);
    end;
  end;
  if Length(vO)>0 then
  begin
    OpenBr:=0;
    InQuote:=False;
    Start:=1;
    vO:=vO+',';
    for i:=1 to Length(vO) do
    case vO[i] of
     '"': InQuote:=not InQuote;
     ',': if not InQuote and (OpenBr=0) then
          begin
           S:=Trim(Copy(vO,Start,i-Start));
           S:=ReplaceCIStr(S,'=TYPE=','=TYPE ',False);
           S:=ReplaceCIStr(S,' OF=',' OF ',False);

           AOutputList.Add(S);
           Start:=i+1;
          end;
      ' ': if not InQuote then
            if i=Start then
             Start:=Start+1
            else
            if OpenBr=0 then
            if not (vO[i+1]in [',',' ','=']) and not (vO[i-1]='=') then
             vO[i]:='=';
      '(': if not InQuote then
            Inc(OpenBr);
       ')':if not InQuote then
            Dec(OpenBr);

    end;
  end;


  if Length(vL)>0 then
  begin
    OpenBr:=0;
    InQuote:=False;
    Start:=1;
    i:=1;
    while i<= Length(vL) do
    begin
      case vL[i] of
       'D','d': if not InQuote then
                if (i=Start) or ((i>1) and (vL[i-1]=' ')) then
                if UpperCase(Copy(vL,i+1,7))='ECLARE ' then
                begin
                 Inc(i,7);
                 Start:=i;
                end;
       'V','v': if not InQuote then
                if (i>1) and (vL[i-1]=' ') then
                if UpperCase(Copy(vL,i+1,8))='ARIABLE ' then
                begin
                 Inc(i,8);
                 Start:=i;
                end;
       '"': InQuote:=not InQuote;
       ';': if not InQuote and (OpenBr=0) then
            begin
             S:=Trim(Copy(vL,Start,i-Start));
             S:=ReplaceCIStr(S,'=TYPE=','=TYPE ',False);
             S:=ReplaceCIStr(S,' OF=',' OF ',False);
//             S:=ReplaceCIStr(S,'=CURSOR=',' CURSOR=',False);
             S:=ReplaceCIStr(S,'=FOR=',' FOR ',False);
             S:=ReplaceCIStr(S,'=FOR(',' FOR (',False);
             ALocalList.Add(S);
             Start:=i+1;
            end;
        ' ': if not InQuote then
              if i=Start then
               Start:=Start+1
              else
              if OpenBr=0 then
              if not (vL[i+1]in [';',' ','=']) and not (vL[i-1]='=') then
               vL[i]:='=';
      '(': if not InQuote then
            Inc(OpenBr);
       ')':if not InQuote then
            Dec(OpenBr);
      end;
      Inc(i)
    end
  end

end;
{$ENDIF}
(*

//Не канает потому как теперь тип переменной может быть доменом.

procedure ParseProcParams(ALines, AInputList, AOutPutList, ALocalList: TStrings);
var
  vRegExpr: TRegExpr;
  vRegExprParam: TRegExpr;
  vI, vO, vL, s{, vInsert}: string;
begin
  PrepareText(ALines, vI, vO, vL);
  vRegExpr := TRegExpr.Create;
  vRegExprParam := TRegExpr.Create;
  vRegExprParam.WordChars := vRegExprParam.WordChars + '$'; 
  try
    vRegExpr.ModifierI := True;
    vRegExpr.Expression := reProcParam;
    vRegExprParam.ModifierI := True;
    vRegExprParam.Expression := reProcDataType;

    if vRegExpr.Exec(vI) then
    begin
      repeat
        s := vRegExpr.Match[0];
        {
        if vRegExprParam.Exec(s) then
        begin
          vInsert := Trim(copy(s, 1, vRegExprParam.MatchPos[0] - 1));
          Insert(#9, s, vRegExprParam.MatchPos[0])
        end
        else
          vInsert := s;
        s := #2 + IntToHex(AInputCl, 6) + 'Input '#4#9 + s;
        AItemList.Add(s);
        AInsertList.Add(vInsert);
        }
        if vRegExprParam.Exec(s) then
        begin
//          vInsert := Trim(copy(s, 1, vRegExprParam.MatchPos[0] - 1));
          Insert('=', s, vRegExprParam.MatchPos[0])
        end
        else
          s := s + '=';
        AInputList.Add(s);
      until not vRegExpr.ExecNext;
    end;
    if vRegExpr.Exec(vO) then
    begin
      repeat
        s := vRegExpr.Match[0];
        {if vRegExprParam.Exec(s) then
        begin
          vInsert := Trim(copy(s, 1, vRegExprParam.MatchPos[0] - 1));
          Insert(#9, s, vRegExprParam.MatchPos[0])
        end
        else
          vInsert := s;
        s := #2 + IntToHex(AOutputCl, 6) + 'Output '#4#9 + s;
        AItemList.Add(s);
        AInsertList.Add(vInsert);}
        if vRegExprParam.Exec(s) then
          Insert('=', s, vRegExprParam.MatchPos[0])
        else
          s := s + '=';
        AOutPutList.Add(s);
      until not vRegExpr.ExecNext;
    end;
    vRegExpr.Expression := reProcLocalVar;
    if vRegExpr.Exec(vL) then
    begin
      repeat
        s := vRegExpr.Match[0];
        if UpperCase(Copy(s,1,16))='DECLARE VARIABLE' then
         s := Trim(copy(s, 18, Length(s) - 18))
        else
         s := Trim(copy(s, 8, Length(s) - 8));        
        {if vRegExprParam.Exec(s) then
        begin
          vInsert := Trim(copy(s, 1, vRegExprParam.MatchPos[0] - 1));
          Insert(#9, s, vRegExprParam.MatchPos[0])
        end
        else
          vInsert := s;
        s := #2 + IntToHex(ALocalCl, 6) + 'Local '#4#9 + s;
        AItemList.Add(s);
        AInsertList.Add(vInsert);}
        if vRegExprParam.Exec(s) then
          Insert('=', s, vRegExprParam.MatchPos[0])
        else
          s := s + '=';
        ALocalList.Add(s);
      until not vRegExpr.ExecNext;
    end;
  finally
    vRegExpr.Free;
    vRegExprParam.Free;
  end;
end;
 *)
end.







