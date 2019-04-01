unit pBTGridToExcel;

interface
 uses
   Windows, SysUtils, Variants, Classes, ComObj,Graphics,DB,Dialogs,DBGridEh;

type
  TCallBackGridToExcelProc=
   procedure (Row:integer; var  Stop:boolean) of object;

function  GridToExcel(Grid:TDBGridEh;MsExcel,Sheet:Variant;
 const BegRow,BegCol:integer;CreateTitle:boolean; CallBack:TCallBackGridToExcelProc=nil ):integer; overload;

function  GridToExcel2(Grid:TDBGridEh;const SheetName:string;
 const BegRow,BegCol:integer; CallBack:TCallBackGridToExcelProc=nil;CreateTitle:boolean=True):integer; overload;

function  GridToExcel1(Grid:TDBGridEh;const FileName,SheetName:string;
 const BegRow,BegCol:integer;var LastRow:integer; CreateTitle:boolean=True ):variant;

function  ExecExcel(const SheetName:string =''):variant;
function  FieldToVariant(Field: TField): OLEVariant;
function  ExcelNumericFormat(MSExcel:Variant;const DelphiFormat:string):string;
function  ExcelFileOpen(const FileName,SheetName:string;DoVisible:boolean ):variant;
function  XLSGetCell(MSExcel:variant;Row,Col:integer):Variant;
function  XLSGetCellByName(MSExcel:variant;const Name:string):Variant;
procedure XLSSetCell(MSExcel:variant;Row,Col:integer;Value:variant);
procedure XLSSetFormula(MSExcel:variant;BegRow,BegCol,EndRow,EndCol:integer;const Value:string);
procedure XLSInsertRow(MSExcel:variant;BegRow,EndRow:integer);

procedure XLSSetRowsSize(MSExcel:variant;RowNum:integer; Size:Extended);
procedure XLSSetColsSize(MSExcel:variant;ColNum:integer; Size:Extended);
procedure XLSSetColsAutoFit(MSExcel:variant;ColNum:integer);

procedure XLSSetColor(MSExcel:variant;BegRow,BegCol,EndRow,EndCol:integer;
 Value:integer
);


procedure XLSSetFontColor(MSExcel:variant;BegRow,BegCol,EndRow,EndCol:integer;
 Value:integer
);

procedure XLSSetFontStyle(MSExcel:variant;BegRow,BegCol,EndRow,EndCol:integer;
 aStyle:TFontStyles
);

procedure XLSSetFont(Range:Variant;SourceFont:TFont);

procedure XLSSetBorder(MSExcel:variant;BegRow,BegCol,EndRow,EndCol:integer;
 Value:integer
);

implementation

const
  RowCountLimit=65530;
//  RowCountLimit=11;
  xlNone       =-4142;
var
  DefaultLCID: Integer;
  SysDecimalSeparator:Char;
  SysThousandSeparator:Char;

function ExcelNumericFormat(MSExcel:Variant;const DelphiFormat:string):string;
var
   ExcelVer:variant;
   b:Boolean;
begin
  ExcelVer:=MSExcel.Version;
  if DecimalSeparator='.' then
   ExcelVer:=StrToFloat(Copy(ExcelVer,1,2))
  else
   if Pos('.',ExcelVer)=0 then
    ExcelVer:=StrToFloat(Copy(ExcelVer,1,2))
   else
    ExcelVer:=StrToFloat(Copy(ExcelVer,1,1));
  b:=(ExcelVer>=10);
  if b then
   b:=not MSExcel.UseSystemSeparators;
  if b then
  begin
    Result:=StringReplace(DelphiFormat,',', MSExcel.ThousandsSeparator,[rfReplaceAll]);
    Result:=StringReplace(Result,'.',MSExcel.DecimalSeparator,[rfReplaceAll]);
  end
  else
  begin
   Result:=StringReplace(DelphiFormat,',', SysThousandSeparator,[rfReplaceAll]);
   Result:=StringReplace(Result,'.',SysDecimalSeparator,[rfReplaceAll]);
  end;
end;

function FieldToVariant(Field: TField): OLEVariant;
begin
  Result := '';
  if Field.IsNull then
  begin
    Result:=NULL; Exit;
  end;    
  case Field.DataType of
    ftWideString:
//    Result := '''' + TWideStringField(Field).Value;
    if (Field.AsString<>'') and (Field.AsString[1] in ['0'..'9']) then
     Result := '''' + TWideStringField(Field).Value
    else
      Result := TWideStringField(Field).Value;
    ftString, ftFixedChar, ftMemo, ftFmtMemo:
    if (Field.AsString<>'') and (Field.AsString[1] in ['0'..'9']) then
     Result := '''' + Field.AsString
    else
     Result := Field.AsString;
    ftSmallint, ftInteger, ftWord, ftLargeint, ftAutoInc: Result := Field.AsInteger;
    ftFloat, ftCurrency, ftBCD: Result := Field.AsFloat;
    ftBoolean: Result := Field.AsBoolean;
    ftDate, ftTime, ftDateTime: Result := Field.AsDateTime;
  end;
end;

function ExcelFileOpen(const FileName,SheetName:string;DoVisible:boolean ):variant;
var s:string;
   Sheet : variant;
begin
// Открывает файл и переименовывает страницу.
 try
  Result:= CreateOleObject('excel.application');
 except
  raise Exception.Create('Не могу запустить MS Excel!.');
 end;
 try
  Result.WorkBooks.Open(FileName);
  if Trim(SheetName)<>'' then
  begin
   Sheet:= Result.ActiveSheet;  
   s:=StringReplace(SheetName,':','-',[]);
   s:=StringReplace(s,'/','-',[]);
   s:=StringReplace(s,'\','-',[]);
   s:=StringReplace(s,'*','-',[]);
   s:=StringReplace(s,'?','-',[]);
   if Length(SheetName)<=31 then
    Sheet.Name:=s
   else
    Sheet.Name:=Copy(s,1,28)+'...';
  end;
 finally
  Result.Visible := DoVisible;
 end
end;

procedure XLSSetCell(MSExcel:variant;Row,Col:integer;Value:variant);
var
   Sheet : variant;
begin
  Sheet:= MSExcel.ActiveSheet;
  Sheet.Cells[Row,Col]:=Value
end;


function  XLSGetCellByName(MSExcel:variant;const Name:string):Variant;
var
   Sheet : variant;
begin
  Sheet:= MSExcel.ActiveSheet;
  Result:= Sheet.Range[Name].Value
end;

function  XLSGetCell(MSExcel:variant;Row,Col:integer):Variant;
var
   Sheet : variant;
begin
  Sheet:= MSExcel.ActiveSheet;
  Result:= Sheet.Cells[Row,Col].Value
end;

procedure XLSSetFormula(MSExcel:variant;BegRow,BegCol,EndRow,EndCol:integer;const Value:string);
var
   Sheet : variant;
   Range : variant;
begin
  Sheet:= MSExcel.ActiveSheet;
  Range:=Sheet.Range[Sheet.Cells[BegRow,BegCol], Sheet.Cells[EndRow,EndCol]];
  Range.Formula := '='+Value
//  Sheet.Cells[Row,Col].Formula := '='+Value
end;

procedure XLSInsertRow(MSExcel:variant;BegRow,EndRow:integer);
var
   Sheet : variant;
begin
  Sheet:= MSExcel.ActiveSheet;
//  Sheet.Range['A' + IntToStr(BegRow) + ':GZ' +IntToStr(EndRow)].Insert;
  Sheet.Rows[IntToStr(BegRow)+':'+IntToStr(EndRow)].Insert;
end;

procedure XLSSetRowsSize(MSExcel:variant;RowNum:integer; Size:Extended);
var
   Sheet : variant;
begin
  Sheet:= MSExcel.ActiveSheet;
  Sheet.Rows[RowNum].RowHeight := Size;
end;

procedure XLSSetColsSize(MSExcel:variant;ColNum:integer; Size:Extended);
var
   Sheet : variant;
begin
  Sheet:= MSExcel.ActiveSheet;
  Sheet.Columns[ColNum].ColumnWidth := Size;
end;

procedure XLSSetColsAutoFit(MSExcel:variant;ColNum:integer);
var
   Sheet : variant;
begin
  Sheet:= MSExcel.ActiveSheet;
  Sheet.Columns[ColNum].AutoFit
end;

procedure XLSSetColor(MSExcel:variant;BegRow,BegCol,EndRow,EndCol:integer;
Value:integer
);
var
   Sheet : variant;
   Range : variant;
   RGB:LongInt;
begin
  Sheet:= MSExcel.ActiveSheet;
  Range:=Sheet.Range[Sheet.Cells[BegRow,BegCol], Sheet.Cells[EndRow,EndCol]];
  case Value of
   clNone: Range.Interior.ColorIndex:=xlNone;
  else
   RGB:=ColorToRGB(Value);
   Range.Interior.Color:=RGB;
  end;
end;

procedure XLSSetFontColor(MSExcel:variant;BegRow,BegCol,EndRow,EndCol:integer;
 Value:integer
);
var
   Sheet : variant;
   Range : variant;
begin
// Value : TColor
  Sheet:= MSExcel.ActiveSheet;
  Range:=Sheet.Range[Sheet.Cells[BegRow,BegCol], Sheet.Cells[EndRow,EndCol]];
  Range.Font.Color:=Value;
end;


procedure XLSSetFontStyle(MSExcel:variant;BegRow,BegCol,EndRow,EndCol:integer;
 aStyle:TFontStyles
);
var
   Sheet : variant;
   Range : variant;
begin
// Value : TColor
  Sheet:= MSExcel.ActiveSheet;
  Range:=Sheet.Range[Sheet.Cells[BegRow,BegCol], Sheet.Cells[EndRow,EndCol]];
  Range.Font.Bold:=fsBold in aStyle;
  Range.Font.Italic:=fsItalic in aStyle;
  if fsUnderline in aStyle then
   Range.Font.Underline:=2
  else
   Range.Font.Underline:=1
end;

procedure XLSSetFont(Range:Variant;SourceFont:TFont);
begin
  Range.Font.Bold:=fsBold in SourceFont.Style;
  Range.Font.Italic:=fsItalic in SourceFont.Style;
  if fsUnderline in SourceFont.Style then
   Range.Font.Underline:=2
  else
   Range.Font.Underline:=1;

  Range.Font.Color:=ColorToRGB(SourceFont.Color);
  Range.Font.Name :=SourceFont.Name;
  Range.Font.Size :=SourceFont.Size;
end;

procedure XLSSetBorder(MSExcel:variant;BegRow,BegCol,EndRow,EndCol:integer;
 Value:integer
);
var
   Sheet : variant;
   Range : variant;
begin
  Sheet:= MSExcel.ActiveSheet;
  Range:=Sheet.Range[Sheet.Cells[BegRow,BegCol], Sheet.Cells[EndRow,EndCol]];
// Недоделано. Надоело.

end;

function ExecExcel(const SheetName:string =''):variant;
var
   Sheet : variant;
   s     :string;
begin
 try
  Result := CreateOleObject('excel.application');
 except
  raise Exception.Create('Не могу запустить MS Excel!.');
 end;
 if SheetName<>'' then
 try
   Result.WorkBooks.Add.Activate;
  // MsExcel.ActiveWorkBook.Activate;
   Sheet:= Result.ActiveSheet;
   s:=StringReplace(SheetName,':','-',[]);
   s:=StringReplace(s,'/','-',[]);
   s:=StringReplace(s,'\','-',[]);
   s:=StringReplace(s,'*','-',[]);
   s:=StringReplace(s,'?','-',[]);
   if Length(SheetName)<=31 then
    Sheet.Name:=s
   else
    Sheet.Name:=Copy(s,1,28)+'...';
 except
 end;
end;

function  GridToExcel2(Grid:TDBGridEh;const SheetName:string;
 const BegRow,BegCol:integer; CallBack:TCallBackGridToExcelProc=nil;CreateTitle:boolean=True):integer;
var
   MSExcel: variant;
begin
 MsExcel := ExecExcel(SheetName);
 Result:=GridToExcel(Grid,MSExcel,MsExcel.ActiveSheet, BegRow,BegCol,CreateTitle,CallBack);
end;

function  GridToExcel1(Grid:TDBGridEh;const FileName,SheetName:string;
 const BegRow,BegCol:integer; var LastRow:integer;CreateTitle:boolean=True ):variant; overload;
begin
 Result:= ExcelFileOpen(FileName,SheetName,False);
 LastRow:=GridToExcel(Grid,Result,Result.ActiveSheet, BegRow,BegCol,CreateTitle);
 Result.Visible:=True
end;

type
    TArrData = array [1..1] of variant;
    PArrData =^TArrData;

function GridToExcel(Grid:TDBGridEh;MSExcel,Sheet:Variant;
 const BegRow,BegCol:integer;CreateTitle:boolean ; CallBack:TCallBackGridToExcelProc=nil):integer;
var
    verStr:string;
    i,j,sc : integer;
    BM:TBookMark;
    ColH:string;
    BegRowStr :string;
    CurObject : variant;
    TitleRange,DataRange: variant;
    Arr: OLEVariant;
    rc :integer;
    vRowCount,ColCount:integer;
    Row1,Column:integer;
    EndCol,RowData    :integer;
    Stop:boolean;
    FrmtStr:string;
    ArrData:PArrData;
    Sheet1:Variant;
    shName:string;
    TitleCreated:boolean;
    v:Variant;
procedure DoTitle;
begin
if CreateTitle and not TitleCreated then
     begin
      TitleRange.Interior.ColorIndex:= 15;
      TitleRange.Interior.Pattern   := 1 ; //xlSolid
      TitleRange.Interior.PatternColorIndex := -4105 ;// xlAutomatic;}
      CurObject:=TitleRange.Font;

      CurObject.Name           := 'Arial Cyr';
      CurObject.Size           := 11;
      CurObject.Strikethrough  := False;
      CurObject.Superscript    := False;
      CurObject.OutlineFont    := False;
      CurObject.Shadow         := True;
      CurObject.Underline      := -4142; //xlUnderlineStyleNone
      CurObject.ColorIndex     := -4105 ;// xlAutomatic;}
      TitleRange.HorizontalAlignment:=3; // center
      if StrToInt(verStr)>=8 then
      begin
       TitleRange.Borders[5{xlDiagonalDown}].LineStyle := xlNone;//xlNone;
       TitleRange.Borders[6{xlDiagonalUp}].LineStyle   := xlNone;//xlNone;

       TitleRange.Borders[7{xlEdgeLeft}].LineStyle := 1;     //xlContinuous
       TitleRange.Borders[7{xlEdgeLeft}].Weight    := 2;     // xlThin
       TitleRange.Borders[7{xlEdgeLeft}].ColorIndex:=-4105 ; // xlAutomatic;

       TitleRange.Borders[8{xlEdgeTop}].LineStyle := 1;     //xlContinuous
       TitleRange.Borders[8{xlEdgeTop}].Weight    := 2;     // xlThin
       TitleRange.Borders[8{xlEdgeTop}].ColorIndex:=-4105 ; // xlAutomatic;

       TitleRange.Borders[9{xlEdgeBottom}].LineStyle := 1;     //xlContinuous
       TitleRange.Borders[9{xlEdgeBottom}].Weight    := 2;     // xlThin
       TitleRange.Borders[9{xlEdgeBottom}].ColorIndex:=-4105 ; // xlAutomatic;

       TitleRange.Borders[10{xlEdgeRight}].LineStyle := 1;     //xlContinuous
       TitleRange.Borders[10{xlEdgeRight}].Weight    := 2;     // xlThin
       TitleRange.Borders[10{xlEdgeRight}].ColorIndex:=-4105 ; // xlAutomatic;
       XLSSetFont(TitleRange,Grid.TitleFont);
      end
      else
      begin
       // Если Excel 5.0
       TitleRange.BorderAround(1, 2{xlThin}, -4105{xlAutomatic},0);
      end;
     end;
     Sheet.Columns.Autofit;     
end  ;

begin
  MsExcel.ScreenUpdating:=false;
  MsExcel.Application.EnableEvents := False;
  Result:=BegRow;
  Arr:=Null;
  shName:=Sheet.Name;
try
 verStr:=MsExcel.Version;
 BegRowStr:=IntToStr(BegRow);
 i:=Pos('.',VerStr);
 if i>0 then
  Delete(verStr,i,MaxInt);

 ColCount:=0;
 with Grid do
 for i := 0 to Grid.Columns.Count - 1 do
 begin
  if (not Columns[i].Visible) or (not Assigned(Columns[i].Field))then Continue;
  if CreateTitle then
   Sheet.Cells(BegRow,BegCol+ColCount) := Columns[i].Title.Caption;
  Inc(ColCount);
 end;
 if ColCount=0  then Exit;
 EndCol:=BegCol+ColCount-1;

 TitleRange:= Sheet.Range[Sheet.Cells[BegRow,BegCol], Sheet.Cells[BegRow,EndCol]];
 TitleCreated:=False;


 with Grid,Grid.DataSource.DataSet do
 begin
   BM:=GetBookmark;
   DisableControls;
   Last;  // Fetch all
   rc  := RecordCount;
   if rc=0 then
   begin
     Next;
     rc  := RecordCount;
   end;
   if rc>0 then
   begin
    if rc+BegRow<=RowCountLimit then
    begin
     vRowCount:=rc;
    end
    else
    begin
     vRowCount:=RowCountLimit-BegRow;
    end;
    Arr := VarArrayCreate([1, vRowCount,1, ColCount], varVariant);
    ArrData:=VarArrayLock(Arr) ;
   end
   else
   begin
     DoTitle;
     ArrData:=nil;
     Exit;
   end;
   try
      First;
      Row1:=1;
      RowData  :=0;
     if (BegRow+rc<=RowCountLimit) then
     begin
      XLSInsertRow(MsExcel,BegRow+1,BegRow+rc);
      DataRange:=
       Sheet.Range[Sheet.Cells[BegRow+1,BegCol], Sheet.Cells[BegRow+rc,EndCol]]
     end
     else
     begin
      XLSInsertRow(MsExcel,BegRow+1,RowCountLimit);
      DataRange:=
       Sheet.Range[Sheet.Cells[BegRow+1,BegCol], Sheet.Cells[RowCountLimit,EndCol]];
     end;
      sc:=1;



      while not EOF  do
      begin
        Column:=0;
        for i := 0 to Columns.Count - 1  do
        begin
          if (not Columns[i].Visible) or (not Assigned(Columns[i].Field))then
           Continue;
          PArrData(ArrData)^[Row1+vRowCount*Column]:=FieldToVariant(Columns[i].Field);
          v:=Arr[Row1,Column+1];
          Inc(Column)
        end;
        Inc(Row1);
        if Assigned(CallBack) then
        begin
         Stop:=False;
//         CallBack(Row1+RowData-BegRow,Stop);
         if Stop then Break;
        end;
        if Row1>RowCountLimit-BegRow then
        begin
         VarArrayUnLock(Arr);
         DataRange.Value:=Arr;
         XLSSetFont(DataRange,Grid.Font);         
         if rc-RowData-BegRow>RowCountLimit then
          vRowCount:=RowCountLimit-BegRow
         else
          vRowCount:=rc-RowData-BegRow;
         if vRowCount<=0 then
         begin
          ArrData:= VarArrayLock(Arr) ;
          Break;
         end;
         RowData:=RowData+Row1;

         Arr:= VarArrayCreate([1, vRowCount ,1, ColCount], varVariant);
         ArrData:=VarArrayLock(Arr) ;

         Row1:=1;
         MSExcel.Sheets.Add.Activate;
         if Length(shName+IntToStr(sc))<=31 then
          MSExcel.ActiveSheet.Name:=shName+IntToStr(sc)
         else
          MSExcel.ActiveSheet.Name:=Copy(shName,1,28)+IntToStr(sc);
         Inc(sc);
         Sheet1:=MSExcel.ActiveSheet;
         Sheet.Activate;
         Sheet.Move(Sheet1);
         Sheet1.Activate;
         DoTitle;
         TitleRange.Copy(Sheet1.Range[Sheet1.Cells[BegRow,BegCol], Sheet1.Cells[BegRow,EndCol]]);
         Sheet:=Sheet1;
         DataRange:=
            Sheet.Range[Sheet.Cells[BegRow+1,BegCol], Sheet.Cells[vRowCount,EndCol]];
        end;
        Next;
      end;
      VarArrayUnLock(Arr);
      if (Row1=rc) and (RecordCount>1) then
      begin
       RowData:=RowData+rc;
       DataRange.Value:=Arr;
       XLSSetFont(DataRange,Grid.Font);
      end
      else
      if (Row1<>1) then
      begin
       DataRange.Value:=Arr;
       XLSSetFont(DataRange,Grid.Font);       
      end;
     Result:=RowData;
     if vRowCount<=0 then
      Exit;

     ColH:=Chr(Ord('A')+BegCol-1);
     j:=0;
     for i := 0 to Grid.Columns.Count - 1 do
     begin
      if (not Columns[i].Visible) or not Assigned(Columns[i].Field)  then
       Continue;

      case Columns[i].Alignment of    //
        taLeftJustify :
         Sheet.Range[Sheet.Cells[BegRow,BegCol+j], Sheet.Cells[vRowCount+BegRow,BegCol+j]]
          .HorizontalAlignment:=2;

        taRightJustify:
         Sheet.Range[Sheet.Cells[BegRow,BegCol+j], Sheet.Cells[vRowCount+BegRow,BegCol+j]]
         .HorizontalAlignment:=4;
        taCenter      :
         Sheet.Range[Sheet.Cells[BegRow,BegCol+j], Sheet.Cells[vRowCount+BegRow,BegCol+j]]
         .HorizontalAlignment:=3;
      end;

      if Columns[i].Field is TNumericField then
       if TNumericField(Columns[i].Field).DisplayFormat<>'' then
       begin

        FrmtStr:=ExcelNumericFormat(MSExcel,TNumericField(Columns[i].Field).DisplayFormat);
        Sheet.Range[Sheet.Cells[BegRow,BegCol+j], Sheet.Cells[vRowCount+BegRow,BegCol+j]]
        .NumberFormat:=FrmtStr;
       end;
      Inc(j);
      if CreateTitle then
      begin
        CurObject:=Sheet.Range[ColH+BegRowStr].Borders[10{xlEdgeRight}];
        CurObject.LineStyle := 1;     //xlContinuous
        CurObject.Weight    := 2;     // xlThin
        CurObject.ColorIndex:=-4105 ; // xlAutomatic;
      end;
      if ColH[Length(ColH)]<'Z' then
        ColH[Length(ColH)]:=Chr(Ord(ColH[Length(ColH)])+1)
      else
      begin
        ColH[Length(ColH)]:='A';
        ColH:=ColH+'A';
      end;
     end;
     DoTitle;
   finally
     GotoBookMark(BM);
     FreeBookMark(BM);
     EnableControls
   end;
 end;
finally

 MsExcel.Application.EnableEvents := True;
 MsExcel.ScreenUpdating:=true;
 MsExcel.WindowState:=-4137;//XlMaximazied;
 MsExcel.Visible := True;
// VarArrayUnLock(Arr);
 Arr:=null;
 MsExcel:=null;
end 
// MsExcel.ActiveWorkbook.SaveAs('c:\3.xls', -4143{xlNormal},'','', false, false);

end;

initialization
  DefaultLCID := GetThreadLocale;
{$WARNINGS OFF}
  SysThousandSeparator := GetLocaleChar(DefaultLCID, LOCALE_STHOUSAND, ',');
  SysDecimalSeparator := GetLocaleChar(DefaultLCID, LOCALE_SDECIMAL, '.');
{$WARNINGS ON}
end.
