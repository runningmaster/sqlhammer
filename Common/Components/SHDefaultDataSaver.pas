unit SHDefaultDataSaver;

interface

uses
  Classes,DB,
  DBGridEh, DBGridEhImpExp,
  // SQLHammer
  SHDesignIntf;

type
  TBTDataSaver = class(TSHComponent, ISHDataSaver, ISHDemon)
  private
    FSupportsExtentions: TStringList;
    FExtentionDescriptions: TStringList;
  protected
    function SupportsExtentions: TStrings;
    function ExtentionDescriptions: TStrings;
    procedure SaveToFile(AComponent, ADataset, AGrid: TComponent; AFileName: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure Register();

implementation

uses SysUtils;

var
  CXlsBof: array[0..5] of Word = ($809, 8, 0, $10, 0, 0);
  CXlsEof: array[0..1] of Word = ($0A, 00);
  CXlsLabel: array[0..5] of Word = ($FF, 0, 0, 0, 0, 0);
  CXlsNumber: array[0..4] of Word = ($203, 14, 0, 0, 0);
  CXlsRk: array[0..4] of Word = ($27E, 10, 0, 0, 0);
  CXlsBlank: array[0..4] of Word = ($201, 6, 0, 0, $17);


 type THackXLSExporter=class(TDBGridEhExport)
      private
          FCol, FRow: Word;
      end;

      TBTGridToXLSFile=class(TDBGridEhExportAsXLS)
      private
        procedure WriteWideStringCell(const AValue: WideString);
        procedure IncColRow;
      protected
        procedure WriteDataCell(Column: TColumnEh; FColCellParamsEh: TColCellParamsEh); override;
      end;

procedure StreamWriteWordArray(Stream: TStream; wr: array of Word);
var
  i: Integer;
begin
  for i := 0 to Length(wr)-1 do
{$IFDEF CIL}
    Stream.Write(wr[i]);
{$ELSE}
    Stream.Write(wr[i], SizeOf(wr[i]));
{$ENDIF}
end;

procedure StreamWriteWideString(Stream: TStream; S: WideString);
begin
    Stream.Write(PWideChar(S)^, (Length(s)) * SizeOf(WideChar));
end;

procedure StreamWriteString(Stream: TStream; S: String);
begin
    Stream.Write(PChar(S)^, (Length(s)));
end;

procedure TBTGridToXLSFile.WriteWideStringCell(const AValue: WideString);
var
  L: Word;
begin
  L := Length(aValue);
  CXlsLabel[1] := 8 + L*SizeOf(WideChar);
  CXlsLabel[2] := THackXLSExporter(Self).FRow;
  CXlsLabel[3] := THackXLSExporter(Self).FCol;
  CXlsLabel[5] := L*SizeOf(WideChar);
  StreamWriteWordArray(Stream, CXlsLabel);
//  Stream.WriteBuffer(CXlsLabel, SizeOf(CXlsLabel));
  StreamWriteWideString(Stream, AValue);
//  StreamWriteString(Stream, S);
//  Stream.WriteBuffer(Pointer(AValue)^, L);
  IncColRow;
end;

procedure TBTGridToXLSFile.WriteDataCell(Column: TColumnEh; FColCellParamsEh: TColCellParamsEh);
begin
  if True or(Column.Field = nil) or not(Column.Field is TWideStringField) then
   inherited
  else
   WriteWideStringCell(TWideStringField(Column.Field).Value)
   // Не получилось. Там формат какой-то другой.
end;

procedure TBTGridToXLSFile.IncColRow;
begin
 with THackXLSExporter(Self) do
 begin
  if FCol = ExpCols.Count - 1 then
  begin
    Inc(FRow);
    FCol := 0;
  end else
    Inc(FCol);
 end
end;

procedure Register();
begin
  SHRegisterComponents([TBTDataSaver]);
end;

{ TBTDataSaver }

function TBTDataSaver.SupportsExtentions: TStrings;
begin
  Result := FSupportsExtentions;
end;

function TBTDataSaver.ExtentionDescriptions: TStrings;
begin
  Result := FExtentionDescriptions;
end;

procedure TBTDataSaver.SaveToFile(AComponent, ADataset, AGrid: TComponent;
  AFileName: string);
var
  vExpClass: TDBGridEhExportClass;
  vExt: string;
begin
  if AGrid.InheritsFrom(TDBGridEh) then
  begin
    vExt := ExtractFileExt(AFileName);
    case FSupportsExtentions.IndexOf(vExt) of
      0: vExpClass := TDBGridEhExportAsText;
      1: vExpClass := TDBGridEhExportAsCSV;
      2: vExpClass := TDBGridEhExportAsHTML;
      3: vExpClass := TDBGridEhExportAsRTF;
//      4: vExpClass := TDBGridEhExportAsXLS;
      4: vExpClass := TBTGridToXLSFile;
      else
        vExpClass := nil;
    end;
    if vExpClass <> nil then
    begin
      if TDBGridEh(AGrid).Selection.SelectionType = gstNon then
        SaveDBGridEhToExportFile(vExpClass, TDBGridEh(AGrid), AFileName, True)
      else
        SaveDBGridEhToExportFile(vExpClass, TDBGridEh(AGrid), AFileName, False);
    end;
  end;
end;

constructor TBTDataSaver.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSupportsExtentions := TStringList.Create;
  FExtentionDescriptions := TStringList.Create;
  FSupportsExtentions.Add('.txt');
  FSupportsExtentions.Add('.csv');
  FSupportsExtentions.Add('.htm');
  FSupportsExtentions.Add('.rtf');
  FSupportsExtentions.Add('.xls');

  FExtentionDescriptions.Add('Text files');
  FExtentionDescriptions.Add('Comma separated values');
  FExtentionDescriptions.Add('HTML file');
  FExtentionDescriptions.Add('Rich Text Format');
  FExtentionDescriptions.Add('Microsoft Excel Workbook');
end;

destructor TBTDataSaver.Destroy;
begin
  FSupportsExtentions.Free;
  FExtentionDescriptions.Free;
  inherited;
end;

initialization

  Register();

end.


