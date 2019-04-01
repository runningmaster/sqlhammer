unit DBGridToOO;

interface

{$DEFINE EhGrid}
uses SysUtils,Forms,DB,Graphics,Variants,Dialogs,ActiveX,
    {$IFDEF EhGrid}DBGridEh{$ELSE} DBGrids{$ENDIF}
;

{$IFDEF EhGrid}
 procedure  DBGridToOOCalcFile(Grid:TDBGridEh;const SheetName:string; BeginRow,BeginCol:integer);
{$ELSE}
 procedure  DBGridToOOCalcFile(Grid:TDBGrid;const SheetName:string;  BeginRow,BeginCol:integer);
{$ENDIF}

implementation

uses OpenOfficeWrapper;


type
    TArrData = array [1..1] of variant;
    PArrData =^TArrData;


function FieldToVariant(Field: TField): OLEVariant;
begin
  Result := '';
  if Field.IsNull then
   Result:= ''
  else
  case Field.DataType of
    ftString, ftFixedChar,  ftMemo, ftFmtMemo:
     Result := Field.AsString;
    ftWideString:
     Result := TWideStringField(Field).Value;
    ftSmallint, ftInteger, ftWord,  ftAutoInc:
     Result := Field.AsInteger;
    ftLargeint:
//     Result := TLargeintField(Field).AsLargeInt;
     Result := TLargeintField(Field).asString; // Падла не понимает инт64
    ftFloat, ftCurrency, ftBCD: Result := Field.AsFloat;
    ftBoolean: Result := Field.AsBoolean;
    ftDate, ftTime, ftDateTime: Result := Field.AsFloat;
  end;
end;
    

{$IFDEF EhGrid}
 procedure  DBGridToOOCalcFile(Grid:TDBGridEh;const SheetName:string;  BeginRow,BeginCol:integer);
{$ELSE}
 procedure  DBGridToOOCalcFile(Grid:TDBGrid;const SheetName:string;  BeginRow,BeginCol:integer);
{$ENDIF}

var
   D:TOOCalcDoc;
   v:Variant;
   x:integer;
   y:integer;
   DS:TDataSet;
   vBorderLine:variant;
   Col:Variant;
   Format:string;
   DataArray:OLEVariant;
   rc,ColCount:integer;
   R:Variant;
   BM:TBookMark;
   ArrData:PArrData;
   i, NonVisibleCount:integer;
begin
  ArrData:=nil;
  OpenOfficeManager.Connect;
  DS:=Grid.DataSource.DataSet;
  D:=OpenOfficeManager.CreateCalcDoc(False);
  D.Visible:=False;
  D.DisableScreenUpdating;
  D.RenameSheet(D.SheetName(0),SheetName);
  try
    DS.DisableControls;
    BM:=DS.GetBookmark;
    DS.Last;
    rc:=DS.RecordCount;

    DS.First;
    try
      ColCount:=Grid.Columns.Count;
      NonVisibleCount:=0;
      for x:=0 to Pred(ColCount) do
       if Grid.Columns[x].Visible then
        D.SetCellAsString(0,x+BeginCol-NonVisibleCount,BeginRow,Grid.Columns[x].Title.Caption)
       else
        Inc(NonVisibleCount);
      y:=1;
      DataArray:=VarArrayCreate([1, ColCount-NonVisibleCount,1, rc], varVariant);
      if rc>0 then
       ArrData:=VarArrayLock(DataArray);
      while not  DS.Eof do
      begin
       i:=0;
       for x:=0 to Pred(ColCount) do
       begin
        if Grid.Columns[x].Visible then
          if Grid.Columns[x].Field<>nil then
          begin
           PArrData(ArrData)^[x+1-i+(y-1)*(ColCount-NonVisibleCount)]:=FieldToVariant(Grid.Columns[x].Field);
          end
          else
           PArrData(ArrData)^[x+1-i+(y-1)*(ColCount-NonVisibleCount)]:=VarAsType(Grid.Columns[x].DisplayText,varOleStr )
        else
         Inc(i)  
       end;

       DS.Next;                                   
       Inc(y)
      end;
      R:=D.GetRange(0,1+BeginRow,BeginCol+1,rc+BeginRow,BeginCol+ColCount-NonVisibleCount);
      D.SetRangeDataArray(R,DataArray);
      // Formats
      i:=0;
      for x:=0 to Pred(Grid.Columns.Count) do
      if not Grid.Columns[x].Visible then
       Inc(i)
      else 
      begin
        D.SetColumnWidth(x+BeginCol-i,Grid.Columns[x].Width/(Screen.PixelsPerInch-6));
        Col:=D.Sheet(0).GetColumns.GetByIndex(x+BeginCol-i);
        D.SetRangeFont(Col,Grid.Columns[x].Font);
        D.SetRangeAlignment(Col,Grid.Columns[x].Alignment);

        D.SetRangeBackColor(D.GetRange(0,BeginCol+1,x+BeginRow+1,BeginCol+y-1,x+BeginRow+1),  Grid.Columns[x].Color);
        Col:=D.Cell(0,x+BeginCol-i,BeginRow);
        D.SetRangeBackColor(Col, Grid.Columns[x].Title.Color);
        D.SetRangeFont(Col,Grid.Columns[x].Title.Font);
        D.SetRangeAlignment(Col,Grid.Columns[x].Title.Alignment);

        with Grid.Columns[x] do
        if (Field<>nil) then
         if Field is TDateTimeField then
         begin
          if TDateTimeField(Field).DisplayFormat<>'' then
           D.Sheet(0).GetColumns.GetByIndex(x+BeginCol-i).NumberFormat:=
            D.GetNumberFormat(TDateTimeField(Field).DisplayFormat)
          else
           if Field is TDateField then
            D.Sheet(0).GetColumns.GetByIndex(x+BeginCol-i).NumberFormat:=36
           else
            D.Sheet(0).GetColumns.GetByIndex(x+BeginCol-i).NumberFormat:=
             D.GetNumberFormat('DD.MM.YYYY HH:MM:SS')
         end
         else
         if (Field is TNumericField) then
         begin
            if TNumericField(Field).DisplayFormat<>'' then
            begin
             Format:=StringReplace(TNumericField(Field).DisplayFormat,',',' ',[rfReplaceAll]);
             D.Sheet(0).GetColumns.GetByIndex(x+BeginCol-i).NumberFormat:=
              D.GetNumberFormat(
               StringReplace(Format,'.',',',[rfReplaceAll])
              )
            end
         end;
      end;


      vBorderLine:=OpenOfficeManager.MakeCellBorderLine(ColorToRGB(clBlack),0,75,0);
      v:=D.GetRange(0,BeginRow,BeginCol+1,BeginRow,BeginCol+Grid.Columns.Count-NonVisibleCount);
      v.SetPropertyValues(
        VarArrayOf(['LeftBorder','TopBorder', 'RightBorder','BottomBorder']),
        VarArrayOf([vBorderLine,vBorderLine,vBorderLine,vBorderLine])
      );


      v:=D.GetRange(0,BeginRow+1,BeginCol+1,BeginRow+y-1,BeginCol+Grid.Columns.Count-NonVisibleCount);
      vBorderLine.OuterLineWidth:=35;
      v.SetPropertyValues(
        VarArrayOf(['LeftBorder','TopBorder', 'RightBorder','BottomBorder']),
        VarArrayOf([vBorderLine,vBorderLine,vBorderLine,vBorderLine])
      );

    finally
     if ArrData<>nil then
      VarArrayUnLock(DataArray);
     DS.GotoBookmark(BM);
     DS.EnableControls;
    end;
  finally
   D.EnableScreenUpdating;  
   D.Visible:=True;
   OpenOfficeManager.Disconnect
  end;
end;


end.
