unit OpenOfficeWrapper;

interface

{$IFDEF VER150}
  {$DEFINE D7+}
{$ENDIF}

{$IFDEF VER170}
  {$DEFINE D7+}
  {$DEFINE D9+}
{$ENDIF}

{$IFDEF D7+}
 {$WARN UNSAFE_TYPE OFF}
 {$WARN UNSAFE_CODE OFF}
 {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses
   Windows, Messages, SysUtils, Classes, StdCtrls, ComObj, Graphics,Variants,ActiveX;

type
   TOODocumentType=(odtUnknown,odtWriter,odtCalc);


   TOODocument =class
   private
     FDocument:Variant;
     FLocale  :Variant;
     FNumberFormats:Variant;
     FUsedFormats  :TStringList;
     procedure   SetVisible(Value:boolean);
     function    GetVisible:boolean;
   public
     constructor Create(aDoc:Variant);
     destructor  Destroy; override;
     function    DocType:TOODocumentType; virtual;
     function    GetNumberFormat(const FormatStr:string):Integer;
     procedure   DisableScreenUpdating;
     procedure   EnableScreenUpdating;
     property    Visible:boolean read GetVisible write SetVisible;
   end;

   TOOCalcDoc=class(TOODocument)
   public
     function    DocType:TOODocumentType; override;

     {Sheet Operations}
     function    Sheet(SheetNum:integer):Variant; overload;
     function    Sheet(const SheetName:string):Variant; overload;
     function    SheetName(SheetNum:integer):string;
     function    SheetNumber(const aSheetName:string):Integer;
     function    SheetCount:integer;
     function    AppendSheet(const aName:String):Variant;
     function    InsertSheet(const aName:String; Index:integer):Variant;
     procedure   RenameSheet(const OldName,NewName:string);
     {End Sheet Operations}
     {Cell Operations}
     function    Cell(SheetNum,X,Y:integer):Variant;
     procedure   SetCellAsString(SheetNum:integer; X,Y:integer; const Value:string);
     procedure   SetCellAsNumber(SheetNum:integer; X,Y:integer; Value:Extended);
     procedure   SetCellFormula(SheetNum:integer; X,Y:integer; const Formula:string);
     procedure   SetRangeDataArray(Range:variant; DataArray:Variant); overload;

     function    GetCellAsString(SheetNum:integer; X,Y:integer):string;
     function    GetCellAsNumber(SheetNum:integer; X,Y:integer):Extended;
     function    GetCellFormula(SheetNum:integer; X,Y:integer):string;
     {End Cell Operations}
      function    GetRange(SheetNum:integer; Top,Left,Bottom,Right:integer):variant;
      procedure   SetRangeBackColor(Range:variant;Color:TColor);
      procedure   SetRangeFont(Range:variant;Font:TFont);
      procedure   SetRangeAlignment(Range:variant;Al:TAlignment);            
     {Columns }
      function   ColumnNameToIndex(const ColName:string):integer;
      function   ColumnIndexToName(ColIndex:integer):string;
      procedure  SetColumnWidth(ColIndex:integer;nWidth:Extended);      
     {End Columns}
     function    GetNumberFormats:Variant;
   end;

   TOOWriterDoc=class(TOODocument)
   public
     function    DocType:TOODocumentType; override;
   end;

   TOODocClass = class of TOODocument;

   TOpenOfficeManager = class
   private
      FStarOffice: Variant;
      FDocuments : TList;
   public
     constructor Create;
     destructor  Destroy; override;
     function  OpenOfficeRegistered:boolean;
     function  Connect: boolean;
     procedure Disconnect;
     procedure CheckConnected;
     function  CreateDocument(DocType:TOODocumentType; DoShow:boolean=True): TOODocument;
     function  OpenDocument(DocType:TOODocumentType;
      const FileName:string;   DoShow:boolean=True; asTemplate:boolean=False): TOODocument;
     function  CreateCalcDoc( DoShow:boolean=True): TOOCalcDoc;

     function  DocumentsCount:integer;
     function  Document(Index:integer):TOODocument;
     function  CreateUnoStruct(const structName: String; indexMax: Integer= -1): Variant;
     function  MakePropertyValue(const PropName:string;PropValue:variant):variant;
     function  MakeCellBorderLine(nColor, nInnerLineWidth, nOuterLineWidth, nLineDistance:integer):variant;
   end;

   EOpenOfficeError= class(Exception);

var
    OpenOfficeManager:TOpenOfficeManager;
    ExistOpenOffice  :boolean;
const
//constants group FontWeight
    fwThin=50;
    fwUltraLight=60;
    fwLight=75;
    fwSemiLight=90;
    fwNormal=100;
    fwSemiBold=110;
    fwBold=150;
    fwUltraBold=175;
    fwBlack=200;
//:: com :: sun :: star :: awt ::
//enum FontSlant
    fslNone=0;
    fslOblique=1;
    fslItalic=2;
    fslDontKnow=3;
    fslReverseOblique=4;
    fslReverseItalic=5;

function TransformRGB(Color:Integer):integer;


implementation

{ TOpenOfficeManager }

const
   CLSID='com.sun.star.ServiceManager';
   DesktopID='com.sun.star.frame.Desktop';

function TransformRGB(Color:Integer):integer;
begin
 Color:=ColorToRGB(Color);
 Result:=RGB(GetBValue(Color),GetGValue(Color),GetRValue(Color)) ;
end;

procedure TOpenOfficeManager.CheckConnected;
begin
  if VarIsEmpty(FStarOffice) then
   raise EOpenOfficeError.Create('Haven''t connect to OpenOffice');
end;

function  TOpenOfficeManager.OpenOfficeRegistered:boolean;
var
   G:TGUID;
begin
 Result:=
  CLSIDFromProgID(PWideChar(WideString(CLSID)), G)=S_OK

end;

function TOpenOfficeManager.Connect: boolean;
begin
   try
    if VarIsEmpty(FStarOffice) then
      FStarOffice := CreateOleObject(CLSID);
   except
   end;
   Result := not (VarIsEmpty(FStarOffice) or VarIsNull(FStarOffice));
   if not Result then
     ExistOpenOffice:=False
end;

constructor TOpenOfficeManager.Create;
begin
  inherited Create;
  FStarOffice:=Unassigned;
  FDocuments:=TList.Create;
end;

function TOpenOfficeManager.CreateCalcDoc( DoShow:boolean=True): TOOCalcDoc;
begin
 Result:= TOOCalcDoc(CreateDocument(odtCalc,DoShow))
end;

function TOpenOfficeManager.CreateDocument(
  DocType: TOODocumentType;DoShow:boolean=True): TOODocument;
var
   DTypeID:string;
   StarDesktop: Variant;
   v:Variant;
   vDocument:Variant;
   CurClass:TOODocClass;
begin
  CheckConnected;
  case DocType of
   odtWriter:
   begin
    DTypeID:='private:factory/swriter';
    CurClass:=TOOWriterDoc;
   end;
   odtCalc  :
   begin
    DTypeID:='private:factory/scalc';
    CurClass:=TOOCalcDoc;
   end;
  else
   Result := nil;
   Exit;
  end;

  StarDesktop := FStarOffice.CreateInstance(DesktopID);
  v:=VarArrayCreate([0, 0], varVariant);
  v[0]:=MakePropertyValue('Hidden', not DoShow);
  vDocument :=
   StarDesktop.LoadComponentFromURL( DTypeID, '_blank', 0,V);
  Result:=CurClass.Create(vDocument);
  FDocuments.Add(Result);
end;


destructor TOpenOfficeManager.Destroy;
begin
  Disconnect;
  FDocuments.Free;
  inherited;
end;


procedure TOpenOfficeManager.Disconnect;
var
   i:integer;
begin
   for i:=0 to FDocuments.Count-1 do
    TOODocument(FDocuments[i]).Free;
   FDocuments.Clear;
   FStarOffice := Unassigned;
end;

function TOpenOfficeManager.Document(Index: integer): TOODocument;
begin
  Result:=TOODocument(FDocuments[Index]);
end;

function TOpenOfficeManager.DocumentsCount: integer;
begin
 Result:=FDocuments.Count
end;

function TOpenOfficeManager.MakeCellBorderLine(nColor, nInnerLineWidth,
  nOuterLineWidth, nLineDistance: integer): variant;
begin
  CheckConnected;
  Result := FStarOffice.Bridge_GetStruct('com.sun.star.table.BorderLine');

  Result.Color  :=TransformRGB(nColor);
  Result.InnerLineWidth:=nInnerLineWidth;
  Result.OuterLineWidth:=nOuterLineWidth;
  Result.LineDistance  :=nLineDistance;
end;


function TOpenOfficeManager.MakePropertyValue(const PropName:string;
  PropValue: variant): variant;
begin
    CheckConnected;
    Result := FStarOffice.Bridge_GetStruct('com.sun.star.beans.PropertyValue');
    Result.Name := PropName;
    Result.Value := PropValue;
end;

function TOpenOfficeManager.CreateUnoStruct(const structName: String; indexMax: Integer= -1): Variant;
var
 d: Integer;
begin
  CheckConnected;
  if indexMax < 0 then
   Result:= FStarOffice.Bridge_GetStruct(structName)
  else
  begin
    Result:= VarArrayCreate([0, indexMax], varVariant);
    for d:= 0 to indexMax do
     Result[d]:=FStarOffice.Bridge_GetStruct(structName);
  end;
end;

function TOpenOfficeManager.OpenDocument(DocType: TOODocumentType;
  const FileName: string; DoShow, asTemplate: boolean): TOODocument;
begin
 Result := nil;
end;

{ TOODocument }

constructor TOODocument.Create(aDoc: Variant);
begin
 inherited Create;
 FDocument:=aDoc;
 FLocale  :=aDoc.CharLocale;
 FNumberFormats:=aDoc.GetNumberFormats;
 FUsedFormats  :=TStringList.Create;
 FUsedFormats  .Sorted:=True;
end;

destructor TOODocument.Destroy;
begin
  FLocale       :=Unassigned;
  FNumberFormats:=Unassigned;
  FDocument     :=Unassigned;
  FUsedFormats.Free;
  inherited;
end;

procedure TOODocument.DisableScreenUpdating;
begin
  FDocument.LockControllers;
  FDocument.AddActionLock
end;

function TOODocument.DocType: TOODocumentType;
begin
  Result:=odtUnknown
end;

procedure TOODocument.EnableScreenUpdating;
begin
  FDocument.UnLockControllers;
  FDocument.RemoveActionLock

end;

function TOODocument.GetNumberFormat(const FormatStr: string): Integer;
begin
 if FUsedFormats.Find(FormatStr,Result) then
  Result:=Integer(FUsedFormats.Objects[Result])
 else
 begin
   Result:=FNumberFormats.QueryKey(UpperCase(FormatStr), FLocale,  False);
   if Result=-1 then
   begin
     Result:=FNumberFormats.AddNew(UpperCase(FormatStr), FLocale);
   end;
   FUsedFormats.AddObject(FormatStr,TObject(Result))
 end;
end;


function TOODocument.GetVisible: boolean;
begin
 Result:=
   FDocument.getCurrentController.getFrame.getContainerWindow.GetVisible
  and
   FDocument.getCurrentController.getFrame.getComponentWindow.GetVisible
end;

procedure TOODocument.SetVisible(Value: boolean);
begin
 FDocument.getCurrentController.getFrame.getContainerWindow.SetVisible(Value);
 FDocument.getCurrentController.getFrame.getComponentWindow.SetVisible(Value);
end;

{ TOOCalcDoc }

function TOOCalcDoc.DocType: TOODocumentType;
begin
  Result:=odtCalc
end;

procedure TOOCalcDoc.SetCellAsString(SheetNum, X, Y: integer;
  const Value: string);
begin
 Cell(SheetNum,X,Y).SetString(Value)
end;

procedure TOOCalcDoc.SetCellAsNumber(SheetNum, X, Y: integer;
  Value:Extended);
begin
 Cell(SheetNum,X,Y).SetValue(Value)
end;

procedure TOOCalcDoc.SetCellFormula(SheetNum, X, Y: integer;
  const Formula: string);
begin
 Cell(SheetNum,X,Y).SetFormula(Formula)
end;

procedure TOOCalcDoc.SetRangeDataArray(Range:variant; DataArray:Variant);
begin
  Range.SetDataArray(DataArray);
end;

function TOOCalcDoc.Cell(SheetNum,X, Y: integer): Variant;
begin
 Result:= Sheet(SheetNum).GetCellByPosition(X,Y)
end;


function TOOCalcDoc.Sheet(SheetNum: integer): Variant;
begin
 Result:=  FDocument.GetSheets.GetByIndex(SheetNum);
end;

function TOOCalcDoc.Sheet(const SheetName: string): Variant;
begin
 try
  Result:=  FDocument.GetSheets.GetByName(SheetName)
 except
  Result:= Unassigned
 end;
end;

function TOOCalcDoc.SheetCount: integer;
begin
 Result:=  FDocument.GetSheets.GetCount;
end;

function TOOCalcDoc.SheetName(SheetNum:integer):string;
begin
 Result:= Sheet(SheetNum).Name
end;

function    TOOCalcDoc.SheetNumber(const aSheetName:string):Integer;
var
  Names:array of String;
  i:integer;
begin
  Names:=FDocument.GetSheets.GetElementNames;
  Result:=-1;
  for i:=0 to Length(Names)-1 do
   if Names[i]=aSheetName then
   begin
    Result:=i;
    Exit;
   end;
end;

function    TOOCalcDoc.AppendSheet(const aName:String):Variant;
var
    Index:integer;
begin
  Index:=SheetCount;
  FDocument.GetSheets.InsertNewByName(aName,Index);
  Result:=Sheet(Index)
end;

function    TOOCalcDoc.InsertSheet(const aName:String; Index:integer):Variant;
begin
  FDocument.GetSheets.InsertNewByName(aName,Index);
  Result:=Sheet(Index)
end;

procedure  TOOCalcDoc.RenameSheet(const OldName,NewName:string);
var
   sh:Variant;
begin
  sh:= Sheet(OldName);
  if not VarIsEmpty(sh) then
   sh.Name:=NewName
end;


function TOOCalcDoc.GetNumberFormats: Variant;
begin
 Result:=FDocument.GetNumberFormats
end;

{Columns }
function TOOCalcDoc.ColumnNameToIndex(const ColName: string): integer;
var
   Cols:variant;
begin
   Cols:=Sheet(0).GetColumns;
   Result:=Cols.GetByName(ColName).GetRangeAddress.StartColumn;
end;


function TOOCalcDoc.ColumnIndexToName(ColIndex: integer): string;
var
   Cols:variant;
begin
   Cols:=Sheet(0).GetColumns;
   Result:=Cols.GetByIndex(ColIndex).GetName
end;

procedure  TOOCalcDoc.SetColumnWidth(ColIndex:integer;nWidth:Extended);
var
   Cols:variant;
begin
// nWidth in inch
   Cols:=Sheet(0).GetColumns;
   Cols.GetByIndex(ColIndex).Width:=nWidth*2540 // 2.54 cm inch
end;
{End Columns}

function TOOCalcDoc.GetCellAsNumber(SheetNum, X, Y: integer): Extended;
begin
 Result:= Cell(SheetNum,X,Y).GetValue
end;

function TOOCalcDoc.GetCellAsString(SheetNum, X, Y: integer): string;
begin
 Result:= Cell(SheetNum,X,Y).GetString 
end;

function TOOCalcDoc.GetCellFormula(SheetNum, X, Y: integer): string;
begin
 Result:= Cell(SheetNum,X,Y).GetFormula
end;

function  TOOCalcDoc.GetRange(SheetNum:integer; Top,Left,Bottom,Right:integer):variant;
var
   cRangeName:string;
begin
 cRangeName:=ColumnIndexToName(Left-1)+IntToStr(Top+1)+':'+ColumnIndexToName(Right-1)+IntToStr(Bottom+1);
 Result:=Sheet(SheetNum).GetCellRangeByName(cRangeName)
end;

procedure   TOOCalcDoc.SetRangeBackColor(Range:variant;Color:TColor);
begin
 Range.CellBackColor:=TransformRGB(Color)
end;

procedure   TOOCalcDoc.SetRangeFont(Range:variant;Font:TFont);
var
  F:variant;
begin
   F:=Range.CharWeight;
   Range.SetPropertyValues(
     VarArrayOf(['CharColor','CharFontName','CharHeight']),
     VarArrayOf([TransformRGB(Font.Color),Font.Name,Font.Size])
   );
   Range.CharStrikeout:=fsStrikeOut in Font.Style;
   Range.CharUnderline:=fsUnderline in Font.Style;
   if fsBold in Font.Style then
    Range.CharWeight:=fwBold
   else
    Range.CharWeight:=fwNormal;

   if fsItalic in Font.Style then
    Range.CharPosture:= fslReverseItalic
   else
    Range.CharPosture:= fslNone
end;

procedure   TOOCalcDoc.SetRangeAlignment(Range:variant;Al:TAlignment);
begin
  case Al of
   taLeftJustify : Range.HoriJustify:=1;
   taRightJustify: Range.HoriJustify:=3;
   taCenter      : Range.HoriJustify:=2;
  end
end;
{ TOOWriterDoc }

function TOOWriterDoc.DocType: TOODocumentType;
begin
  Result:=odtWriter
end;

initialization
 OpenOfficeManager:=TOpenOfficeManager.Create;
 ExistOpenOffice:= OpenOfficeManager.OpenOfficeRegistered;
finalization
 OpenOfficeManager.Free
end.
