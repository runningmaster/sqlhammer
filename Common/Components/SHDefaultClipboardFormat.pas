unit SHDefaultClipboardFormat;

interface

uses
  Windows, SysUtils,Classes, Clipbrd,DB,
  DBGridEh, DBGridEhImpExp,
  SHDesignIntf;

type
  TBTClipboardFormat = class(TSHComponent, ISHClipboardFormat, ISHDemon)
  private
  protected
    procedure CutToClipboard(AComponent, ADataset, AGrid: TComponent);
    procedure CopyToClipboard(AComponent, ADataset, AGrid: TComponent);
    function PasteFromClipboard(AComponent, ADataset, AGrid: TComponent): Boolean;
  end;

  TDBGridEhExportAsTextWithNulls = class(TDBGridEhExportAsText)
  private
   FirstCell:boolean;
   FirstRec :boolean;
  protected
    procedure CheckFirstCell; override;
    procedure CheckFirstRec; override;
    procedure WriteRecord(ColumnsList: TColumnsEhList); override;
    procedure WriteTitle(ColumnsList: TColumnsEhList); override;
    procedure WriteDataCell(Column: TColumnEh; FColCellParamsEh: TColCellParamsEh); override;
  end;

procedure Register();

implementation

var
 IsWinNT:boolean;

procedure Register();
begin
  SHRegisterComponents([TBTClipboardFormat]);
end;

{ TBTClipboardFormat }

procedure TBTClipboardFormat.CutToClipboard(AComponent, ADataset,
  AGrid: TComponent);
begin
  CopyToClipboard(AComponent, ADataset, AGrid);
end;

procedure SaveClipboard ;
var
  Data: THandle;
  s:WideString;

  ms: TMemoryStream;

begin
 with ClipBoard do
 begin
  Open;
  Data := GetClipboardData(CF_UNICODETEXT);
  try
    if Data <> 0 then
      s:= PWideChar(GlobalLock(Data))
    else
      s:= '';
  finally
    if Data <> 0 then GlobalUnlock(Data);
    Close;
  end;
 end;
 ms := TMemoryStream.Create;
 ms.WriteBuffer(PWideChar(S)^, (Length(s) + 1) * SizeOf(WideChar));
 ms.SaveToFile('d:\ccc.txt');
 ms.Free
end;

procedure TBTClipboardFormat.CopyToClipboard(AComponent, ADataset,
  AGrid: TComponent);
var
  ms: TMemoryStream;

  procedure Clipboard_PutFromStream(Format: Word; ms: TMemoryStream);
  var
    Data: THandle;
    DataPtr: Pointer;
    Buffer: Pointer;
  begin
//    ms.SaveToFile('d:\Clip.txt');
    Buffer := ms.Memory;
    ClipBoard.Open;
    try
      Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, ms.Size);
      try
        DataPtr := GlobalLock(Data);
        try
          Move(Buffer^, DataPtr^, ms.Size);
          ClipBoard.SetAsHandle(Format, Data);
        finally
          GlobalUnlock(Data);
        end;
      except
        GlobalFree(Data);
        raise;
      end;
    finally
      ClipBoard.Close;
    end;
  end;
begin
//  SaveClipboard;
  if AGrid.InheritsFrom(TDBGridEh) then
  begin
    Clipboard.Open;
    TDBGridEh(AGrid).DataSource.DataSet.DisableControls;
    ms := TMemoryStream.Create;
    try
       WriteDBGridEhToExportStream(TDBGridEhExportAsTextWithNulls, TDBGridEh(AGrid), ms, False);
       ms.WriteBuffer(PChar('')^, 1);
       if IsWinNT then
        Clipboard_PutFromStream(CF_UNICODETEXT , ms)
       else
        Clipboard_PutFromStream(CF_TEXT , ms);
      ms.Clear;
    finally
      ms.Free;
      Clipboard.Close;
      TDBGridEh(AGrid).DataSource.DataSet.EnableControls;
    end;
//    DBGridEh_DoCopyAction(TDBGridEh(AGrid), False);
  end;
end;

function TBTClipboardFormat.PasteFromClipboard(AComponent, ADataset,
  AGrid: TComponent): Boolean;
begin
  Result := False;
  if AGrid.InheritsFrom(TDBGridEh) then
  begin
    DBGridEh_DoPasteAction(TDBGridEh(AGrid), False);
  end;
end;

{ TDBGridEhExportAsTextWithNulls }

procedure TDBGridEhExportAsTextWithNulls.CheckFirstCell;
var s: WideString;
begin
  if IsWinNT then
  begin
    if FirstCell = False then
    begin
      s := #09;
     Stream.Write(PWideChar(s)^, (Length(s)) * SizeOf(WideChar));
    end else
      FirstCell := False;
  end
  else
   inherited
end;

procedure TDBGridEhExportAsTextWithNulls.CheckFirstRec;
var
  s: WideString;
begin
  if IsWinNT then
  begin
    if FirstRec = False then
    begin
      s := #13#10;
      Stream.Write(PWideChar(s)^, (Length(s)) * SizeOf(WideChar));
    end
    else
      FirstRec := False;
  end
  else
   inherited;
end;

procedure TDBGridEhExportAsTextWithNulls.WriteDataCell(Column: TColumnEh;
  FColCellParamsEh: TColCellParamsEh);
var
 ws:WideString;

begin
  if IsWinNT then
  begin
   CheckFirstCell;
   if Assigned(Column) and Assigned(Column.Field) and Column.Field.IsNull then
   begin
    ws:='NULL';
    Stream.Write(PWideChar(ws)^, (Length(ws)) * SizeOf(WideChar));
   end
   else
   begin
    if Assigned(Column) and Assigned(Column.Field) and (Column.Field is TWideStringField) then
     ws:=TWideStringField(Column.Field).Value
    else
     ws := FColCellParamsEh.Text;
    Stream.Write(PWideChar(ws)^, (Length(ws)) * SizeOf(WideChar));
   end
  end
  else
  if Assigned(Column) and Assigned(Column.Field) and Column.Field.IsNull then
  begin
    CheckFirstCell;
    Stream.Write('NULL' , 4);
  end
  else
    inherited WriteDataCell(Column, FColCellParamsEh);
end;

procedure TDBGridEhExportAsTextWithNulls.WriteRecord(
  ColumnsList: TColumnsEhList);
begin
   FirstCell := True;
   inherited;
end;

procedure TDBGridEhExportAsTextWithNulls.WriteTitle(
  ColumnsList: TColumnsEhList);
var i: Integer;
   ws:WideString;
begin
  CheckFirstRec;
  for i := 0 to ColumnsList.Count - 1 do
  begin
    if IsWinNT then
    begin
      ws := ColumnsList[i].Title.Caption;
      if i <> ColumnsList.Count - 1 then
      begin
        Stream.Write(PWideChar(ws)^, (Length(ws)) * SizeOf(WideChar));
        ws :=  #09;
        Stream.Write(PWideChar(ws)^, (Length(ws)) * SizeOf(WideChar));
      end;
    end
    else
    inherited WriteTitle(ColumnsList)
  end;
end;

initialization

  Register();
  IsWinNT := (Win32Platform and VER_PLATFORM_WIN32_NT) <> 0;
end.
