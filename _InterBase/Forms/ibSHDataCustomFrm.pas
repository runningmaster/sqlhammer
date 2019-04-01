unit ibSHDataCustomFrm;

interface

uses
  SHDesignIntf, SHOptionsIntf, ibSHDesignIntf, ibSHComponentFrm,
  ibSHDriverIntf,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, SynEdit, pSHSynEdit, Grids, DBGrids,
  DBGridEh, DbUtilsEh, ImgList, DB, DBCtrls, ActnList, AppEvnts, PrnDbgeh, TypInfo,
  Menus, StdCtrls, ToolCtrlsEh,GridsEh;

type
  IIDBGridSupport = interface
  ['{7BEF024D-B6A4-4373-A344-A493EB926506}']
    function GetDBGrid: TDBGridEh;
    procedure SetDBGrid(Value: TDBGridEh);
    property DBGrid: TDBGridEh read GetDBGrid write SetDBGrid;
  end;

  TibSHDataCustomForm = class(TibBTComponentForm, IibSHDataCustomForm,
    IibDRVDatasetNotification,
    IIDBGridSupport
    )
  private
    { Private declarations }
    // Common
    FDataIntf: IibSHData;
    FSQLEditorIntf: IibSHSQLEditor;
    FStatisticsIntf: IibSHStatistics;
    FSHCLDatabaseIntf: IibSHDatabase;
    FDBGrid: TDBGridEh;
    FEnabledFetchEvent: Boolean;
    // For Draw Grid
    FToolTips: Boolean;
    FStriped: Boolean;
    FCurrentRowColor: TColor;
    FOddRowColor: TColor;
    FNullValueColor: TColor;
    FGridFormatOptionsIntf: ISHDBGridFormatOptions;
    FResultEdit: TpSHSynEdit;
    FLoading: Boolean;
    FFiltered: Boolean;

    FWideEditor:TControl;
    function GetDBGrid: TDBGridEh;
    procedure SetDBGrid(Value: TDBGridEh);

    { DBGrid Events }
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
      Column: TColumnEh; State: TGridDrawState);
    procedure DBGridGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  protected
    { Protected declarations }

    procedure ShowMessages; virtual;
    procedure HideMessages; virtual;
    procedure ClearMessages; virtual;
    procedure CatchRunTimeOptionsDemon;
    procedure ApplyGridFormatOptions(ADBGrid: TDBGridEh); virtual;
    procedure DoFitDisplayWidths(ADBGrid: TDBGridEh);
    function ConfirmEndTransaction: Boolean;
    procedure EditorMsgVisible(AShow: Boolean = True); override;
    function GetEditorMsgVisible: Boolean; override;
    procedure DoRefresh(AClearMessages: Boolean); virtual;

    {IibSHDataCustomForm}
    function GetImageStreamFormat(AStream: TStream): TibSHImageFormat;
    function GetCanFilter: Boolean;
    function GetFiltered: Boolean;
    procedure SetFiltered(Value: Boolean);
    function GetAutoCommit: Boolean;

    procedure AddToResultEdit(AText: string; DoClear: Boolean = True); virtual;
    procedure SetDBGridOptions(ADBGrid: TComponent); virtual;

    {IibDRVDatasetNotification}
    procedure AfterOpen(ADataset: IibSHDRVDataset); virtual;
    procedure OnFetchRecord(ADataset: IibSHDRVDataset); virtual;
    procedure OnError(ADataset: IibSHDRVDataset);
    {ISHRunCommands}
    function GetCanRun: Boolean; override;
    function GetCanPause: Boolean; override;
    function GetCanCommit: Boolean; override;
    function GetCanRollback: Boolean; override;
    function GetCanRefresh: Boolean; override;

    procedure Pause; override;
    procedure Commit; override;
    procedure Rollback; override;
    procedure Refresh; override;
    {End ISHRunCommands}

    function GetGridWideEditor:TControl;
    {ISHEditCommands}
    function InternalGetCanCut: Boolean;     
    function GetCanCut: Boolean; override;
    function GetCanCopy: Boolean; override;
    function GetCanPaste: Boolean; override;

    procedure Cut; override;
    procedure Copy; override;
    procedure Paste; override;
    
    {End ISHEditCommands}
    
    function DoOnOptionsChanged: Boolean; override;

    procedure DoUpdateStatusBar; virtual;


    procedure CommitWithRefresh(ADoRefresh: Boolean = False);
    procedure RollbackWithRefresh(ADoRefresh: Boolean = False);

    function GetCanDestroy: Boolean; override;
    procedure SetStatusBar(Value: TStatusBar); override;
    procedure FillPopupMenu; override;
    procedure DoOnPopup(Sender: TObject); override;
    procedure ShowProperties; override;

    property ToolTips: Boolean read FToolTips write FToolTips;
    property Striped: Boolean read FStriped write FStriped;
    property CurrentRowColor: TColor read FCurrentRowColor write FCurrentRowColor;
    property OddRowColor: TColor read FOddRowColor write FOddRowColor;
    property NullValueColor: TColor read FNullValueColor write FNullValueColor;
    property GridFormatOptions: ISHDBGridFormatOptions read FGridFormatOptionsIntf;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure BringToTop; override;
    procedure ShowResult(AEnableFetchEvent: Boolean = True); virtual;

    property Data: IibSHData read FDataIntf;
    property SQLEditor: IibSHSQLEditor read FSQLEditorIntf;
    property Statistics: IibSHStatistics read FStatisticsIntf;
    property SHCLDatabase: IibSHDatabase read FSHCLDatabaseIntf;
    property AutoCommit: Boolean read GetAutoCommit;
    property EnabledFetchEvent: Boolean read FEnabledFetchEvent write FEnabledFetchEvent;
    property ResultEdit: TpSHSynEdit read FResultEdit write FResultEdit;
    property Loading: Boolean read FLoading write FLoading;
  published
    { Published declarations }  // на случай получения через GetObjectProp()
    property DBGrid: TDBGridEh read GetDBGrid write SetDBGrid;
  end;

  TibSHDatasetFeaturesEh = class(TDatasetFeaturesEh)
  public
    procedure ApplySorting(Sender: TObject; DataSet: TDataSet;
      IsReopen: Boolean); override;
    procedure ApplyFilter(Sender: TObject; DataSet: TDataSet;
      IsReopen: Boolean); override;
  end;

  TibSHDataCustomToolbarAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDataCustomToolbarAction_Refresh = class(TibSHDataCustomToolbarAction)
  end;
  TibSHDataCustomToolbarAction_Commit = class(TibSHDataCustomToolbarAction)
  end;
  TibSHDataCustomToolbarAction_Rollback = class(TibSHDataCustomToolbarAction)
  end;
  TibSHDataCustomToolbarAction_Filter = class(TibSHDataCustomToolbarAction)
  end;
  TibSHDataCustomToolbarAction_Pause = class(TibSHDataCustomToolbarAction)
  end;
  TibSHDataCustomToolbarAction_BackToQuery = class(TibSHDataCustomToolbarAction)
  end;
  TibSHDataCustomToolbarAction_Save = class(TibSHDataCustomToolbarAction)
  end;
  TibSHDataCustomToolbarAction_Open = class(TibSHDataCustomToolbarAction)
  end;

  TibSHDataCustomToolbarAction_Export2Excel = class(TibSHDataCustomToolbarAction)
  end;

  TibSHDataCustomToolbarAction_Export2OO = class(TibSHDataCustomToolbarAction)
  end;


implementation

uses
  ibSHConsts, ibSHSQLs, ibSHValues, ibSHStrUtil, ibSHMessages,  pBTGridEhExt,pBTGridToExcel,
  DBGridToOO,OpenOfficeWrapper

  ;

{ TibSHDataCustomForm }

constructor TibSHDataCustomForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHData, FDataIntf);
  Supports(Component, IibSHSQLEditor, FSQLEditorIntf);
  Supports(Component, IibSHStatistics, FStatisticsIntf);
  Supports(Component, IibSHDatabase, FSHCLDatabaseIntf);
  Loading := True;
  FFiltered := False;
end;

destructor TibSHDataCustomForm.Destroy;
begin
  FDataIntf := nil;
  FSQLEditorIntf := nil;
  FStatisticsIntf := nil;
  inherited Destroy;
end;

procedure TibSHDataCustomForm.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent.IsImplementorOf(GridFormatOptions) then
      FGridFormatOptionsIntf := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

function TibSHDataCustomForm.GetDBGrid: TDBGridEh;
begin
  Result := FDBGrid;
end;

procedure TibSHDataCustomForm.SetDBGrid(Value: TDBGridEh);
begin
  FDBGrid := Value;
  if Assigned(FDBGrid) then
  begin
    FDBGrid.OnDrawColumnCell := DBGridDrawColumnCell;
    FDBGrid.OnGetCellParams := DBGridGetCellParams;
    FDBGrid.OnKeyDown := DBGridKeyDown;
    FDBGrid.OnKeyUp := DBGridKeyUp;
    FDBGrid.OnMouseDown := DBGridMouseDown;
    FDBGrid.OnMouseUp := DBGridMouseUp;
    FDBGrid.PopupMenu := EditorPopupMenu;
    PrepareDBGridEh(Value)
  end;
end;

procedure TibSHDataCustomForm.ShowMessages;
begin
end;

procedure TibSHDataCustomForm.HideMessages;
begin
end;

procedure TibSHDataCustomForm.ClearMessages;
begin
  if Assigned(ResultEdit) then
    Designer.TextToStrings(EmptyStr, ResultEdit.Lines, True);
end;

procedure TibSHDataCustomForm.CatchRunTimeOptionsDemon;
begin
  if not Assigned(FGridFormatOptionsIntf) then
  begin
    if Supports(Designer.GetDemon(ISHDBGridFormatOptions), ISHDBGridFormatOptions, FGridFormatOptionsIntf) then
      ReferenceInterface(FGridFormatOptionsIntf, opInsert);
  end;
end;

procedure TibSHDataCustomForm.ApplyGridFormatOptions(ADBGrid: TDBGridEh);
var
  I: Integer;
  
{  procedure DoFitDisplayWidths;
  var
    J, dw, tw, MAX_COLUMN_WIDTH: Integer;
    TM: TTextMetric;
  begin
    if Assigned(GridFormatOptions) then
      MAX_COLUMN_WIDTH := GridFormatOptions.DisplayFormats.StringFieldWidth
    else
      MAX_COLUMN_WIDTH := 100;
    GetTextMetrics(ADBGrid.Canvas.Handle, TM);
    for J := 0 to Pred(ADBGrid.Columns.Count) do
    begin

      dw := ADBGrid.Columns[J].Field.DisplayWidth * (ADBGrid.Canvas.TextWidth('0') - TM.tmOverhang) + TM.tmOverhang + 4;
      if dw > MAX_COLUMN_WIDTH then
        dw := MAX_COLUMN_WIDTH;
      tw := ADBGrid.Canvas.TextWidth(ADBGrid.Columns[J].Title.Caption + 'W');
      if dw < tw then
        dw := tw;
      ADBGrid.Columns[J].Width := dw;

    end;
  end;}
begin
  if Assigned(ADBGrid) and
    Assigned(GridFormatOptions) and
    Assigned(ADBGrid.DataSource) and
    Assigned(ADBGrid.DataSource.DataSet) and
    (ADBGrid.DataSource.DataSet.FieldCount > 0) then
  begin
      for I := 0 to Pred(ADBGrid.Columns.Count) do
      begin
        if Assigned(SHCLDatabase) and
          SHCLDatabase.DatabaseAliasOptions.DML.UseDB_KEY and
          (not SHCLDatabase.DatabaseAliasOptions.DML.ShowDB_KEY) and
          (ADBGrid.Columns[I].FieldName = 'DB_KEY') then
          ADBGrid.Columns[I].Visible := False
        else
        begin
          ADBGrid.Columns[I].ToolTips := ToolTips;
          if (ADBGrid.Columns[I].Field is TIntegerField) or (ADBGrid.Columns[I].Field is TLargeintField) then
          begin
            TIntegerField(ADBGrid.Columns[I].Field).DisplayFormat := GridFormatOptions.DisplayFormats.IntegerField;
            TIntegerField(ADBGrid.Columns[I].Field).EditFormat := GridFormatOptions.EditFormats.IntegerField;
          end else
          if ADBGrid.Columns[I].Field is TFloatField then
          begin
            TFloatField(ADBGrid.Columns[I].Field).DisplayFormat := GridFormatOptions.DisplayFormats.FloatField;
            TFloatField(ADBGrid.Columns[I].Field).EditFormat := GridFormatOptions.EditFormats.FloatField;
          end
          else
          if ADBGrid.Columns[I].Field is TDateField then
            TDateField(ADBGrid.Columns[I].Field).DisplayFormat := GridFormatOptions.DisplayFormats.DateField
          else
          if ADBGrid.Columns[I].Field is TTimeField then
            TTimeField(ADBGrid.Columns[I].Field).DisplayFormat := GridFormatOptions.DisplayFormats.TimeField
          else
          if ADBGrid.Columns[I].Field is TDateTimeField then
            TDateTimeField(ADBGrid.Columns[I].Field).DisplayFormat := GridFormatOptions.DisplayFormats.DateTimeField
        end;
      end;
  end;
end;

procedure TibSHDataCustomForm.DoFitDisplayWidths(ADBGrid: TDBGridEh);
var
  J, dw, tw, MAX_COLUMN_WIDTH: Integer;
  TM: TTextMetric;
begin
  if Assigned(ADBGrid) and
    Assigned(ADBGrid.DataSource) and
    Assigned(ADBGrid.DataSource.DataSet) and
    ADBGrid.DataSource.DataSet.Active then
  begin
    if Assigned(GridFormatOptions) then
      MAX_COLUMN_WIDTH := GridFormatOptions.DisplayFormats.StringFieldWidth
    else
      MAX_COLUMN_WIDTH := 100;
    GetTextMetrics(ADBGrid.Canvas.Handle, TM);
    for J := 0 to Pred(ADBGrid.Columns.Count) do
    if Assigned(ADBGrid.Columns[J].Field) then
    begin
      if not (ADBGrid.Columns[J].Field.DataType in ftNumberFieldTypes) then
      begin
        dw := ADBGrid.Columns[J].Field.DisplayWidth * (ADBGrid.Canvas.TextWidth('0') - TM.tmOverhang) + TM.tmOverhang + 4;
        if dw > MAX_COLUMN_WIDTH then
          dw := MAX_COLUMN_WIDTH;
        tw := ADBGrid.Canvas.TextWidth(ADBGrid.Columns[J].Title.Caption + 'W');
        if dw < tw then
          dw := tw;
        ADBGrid.Columns[J].Width := dw;
      end;  
    end;
  end;
end;

function TibSHDataCustomForm.ConfirmEndTransaction: Boolean;
begin
  Result := Assigned(SHCLDatabase) and
            Assigned(Data) and
            (
             (SameText(SHCLDatabase.DatabaseAliasOptions.DML.ConfirmEndTransaction, ConfirmEndTransactions[0]) and
             Data.Dataset.DataModified)
             or
             (SameText(SHCLDatabase.DatabaseAliasOptions.DML.ConfirmEndTransaction, ConfirmEndTransactions[1]))
            );
end;

procedure TibSHDataCustomForm.EditorMsgVisible(AShow: Boolean);
begin
  if AShow then
    ShowMessages
  else
    HideMessages;
end;

function TibSHDataCustomForm.GetEditorMsgVisible: Boolean;
begin
  if Assigned(ResultEdit) then
    Result := ResultEdit.Visible and Assigned(ResultEdit.Parent) and
      ResultEdit.Parent.Visible
  else
    Result := False;
end;

procedure TibSHDataCustomForm.DoRefresh(AClearMessages: Boolean);
var
  vRetrieveStatistics: Boolean;
  vSQLEditorForm: IibSHSQLEditorForm;
  I: Integer;
begin
  if AClearMessages then
  begin
    HideMessages;
    ClearMessages;
  end;  
  Screen.Cursor := crHourGlass;
  EnabledFetchEvent := False;
  try
    Data.Dataset.Close;
    vRetrieveStatistics := Assigned(SQLEditor) and Assigned(Statistics) and SQLEditor.RetrieveStatistics;
    if vRetrieveStatistics then
      Statistics.StartCollection;
    if Supports(Component, IibSHSQLEditor) then
      Data.Open;
    EnabledFetchEvent := False;
    ShowResult(False);
    if vRetrieveStatistics then
    begin
      Statistics.CalculateStatistics;
      if Supports(SQLEditor, ISHComponentFormCollection) then
        for I := 0 to Pred((SQLEditor as ISHComponentFormCollection).ComponentForms.Count) do
          if Supports((SQLEditor as ISHComponentFormCollection).ComponentForms[I], IibSHSQLEditorForm, vSQLEditorForm) then
          begin
            if Supports(Data.Dataset, IibSHDRVExecTimeStatistics) then
              Statistics.DRVTimeStatistics := Data.Dataset as IibSHDRVExecTimeStatistics;
            vSQLEditorForm.ShowStatistics;
            Break;
          end;
    end;
  finally
    EnabledFetchEvent := True;
    Screen.Cursor := crDefault;
  end;
end;



type // From DB
  TGraphicHeader = record
    Count: Word;                { Fixed at 1 }
    HType: Word;                { Fixed at $0100 }
    Size: Longint;              { Size not including header }
  end;


function TibSHDataCustomForm.GetImageStreamFormat(
  AStream: TStream): TibSHImageFormat;
var
  vSize: Longint;
  Header: TGraphicHeader;

  function IsBitmap: Boolean;
  var
    Bmf: TBitmapFileHeader;
  begin
    Result := False;
    if vSize > SizeOf(Bmf) then
    begin
      AStream.ReadBuffer(Bmf, SizeOf(Bmf));
      Result := Bmf.bfType = $4D42;
      AStream.Seek(-SizeOf(Bmf), soFromCurrent);
    end;
  end;
  function IsEMF: Boolean;
  var
    Header: TEnhMetaHeader;
  begin
    Result := False;
    if vSize > SizeOf(Header) then
    begin
      AStream.Read(Header, Sizeof(Header));
      Result := (Header.iType = EMR_HEADER) and (Header.dSignature = ENHMETA_SIGNATURE);
      AStream.Seek(-Sizeof(Header), soFromCurrent);
    end;
  end;
  function IsWMF: Boolean;
  const
    WMFKey = Integer($9AC6CDD7);
    WMFWord = $CDD7;
  type
    PMetafileHeader = ^TMetafileHeader;
    TMetafileHeader = packed record
      Key: Longint;
      Handle: SmallInt;
      Box: TSmallRect;
      Inch: Word;
      Reserved: Longint;
      CheckSum: Word;
    end;
    function ComputeAldusChecksum(var WMF: TMetafileHeader): Word;
    type
      PWord = ^Word;
    var
      pW: PWord;
      pEnd: PWord;
    begin
      Result := 0;
      pW := @WMF;
      pEnd := @WMF.CheckSum;
      while Longint(pW) < Longint(pEnd) do
      begin
        Result := Result xor pW^;
        Inc(Longint(pW), SizeOf(Word));
      end;
    end;
  var
    WMF: TMetafileHeader;
  begin
    Result := False;
    if vSize > SizeOf(WMF) then
    begin
      AStream.Read(WMF, Sizeof(WMF));
      Result := (WMF.Key = WMFKEY) and (ComputeAldusChecksum(WMF) = WMF.CheckSum);
      AStream.Seek(-Sizeof(WMF), soFromCurrent);
    end;
  end;
  function IsJPEG: Boolean;
  const
    JPG_HEADER = $D8FF;
//    JPG_HEADER = $FFD8;
//    JPG_HEADER = 55551;
  var
    Header: word;
  begin
    Result := False;
    if vSize > SizeOf(Header) then
    begin
      AStream.Read(Header, Sizeof(Header));
      Result := (Header = JPG_HEADER);
      AStream.Seek(-Sizeof(Header), soFromCurrent);
    end;
  end;
  function IsICO: Boolean;
  var
    CI: TCursorOrIcon;
  begin
    Result := False;
    if vSize > SizeOf(CI) then
    begin
      AStream.Read(CI, Sizeof(CI));
      Result := (CI.wType in [RC3_STOCKICON, RC3_ICON]);
      AStream.Seek(-Sizeof(CI), soFromCurrent);
    end;
  end;
begin
  Result := imUnknown;
  vSize := AStream.Size;
  AStream.Read(Header, SizeOf(Header));
  if (Header.Count <> 1) or (Header.HType <> $0100) or
        (Header.Size <> AStream.Size - SizeOf(Header)) then
    AStream.Position:=0;
    if IsBitmap then
     Result := imBitmap
    else
    if IsEMF then
     Result := imEMF
    else
    if IsWMF then Result := imWMF
    else
    if IsJPEG then Result := imJPEG
    else
    if IsICO then Result := imICO;
end;

function TibSHDataCustomForm.GetCanFilter: Boolean;
begin
  Result := Assigned(Data) and
            Data.Dataset.Active and
            Assigned(DBGrid) and
            Assigned(DBGrid.STFilter);
end;

function TibSHDataCustomForm.GetFiltered: Boolean;
begin
  Result := FFiltered;
end;

procedure TibSHDataCustomForm.SetFiltered(Value: Boolean);
begin
  if GetCanFilter then
    if Value <> FFiltered then
    begin
      FFiltered := Value;
      DBGrid.STFilter.Visible := FFiltered;
      if not FFiltered then
        Data.Dataset.Filter := EmptyStr;
    end;
end;

function TibSHDataCustomForm.GetAutoCommit: Boolean;
begin
  if Assigned(SQLEditor) then
    Result := SQLEditor.AutoCommit
  else
    Result := SHCLDatabase.DatabaseAliasOptions.DML.AutoCommit;
end;

procedure TibSHDataCustomForm.AddToResultEdit(AText: string; DoClear: Boolean = True);
begin
  if Assigned(ResultEdit) then
  begin
    ClearMessages;
    if (Length(AText) > 0) and (Length(ResultEdit.Lines.Text) > 0) then
      Designer.TextToStrings(sLineBreak, ResultEdit.Lines);
    Designer.TextToStrings(AText, ResultEdit.Lines);
    if Length(AText) > 0 then
      ShowMessages;
  end;
end;

procedure TibSHDataCustomForm.SetDBGridOptions(ADBGrid: TComponent);
var
  vGridGeneralOptions: ISHDBGridGeneralOptions;
  vGridDisplayOptions: ISHDBGridDisplayOptions;
  vGridColorOptions: ISHDBGridColorOptions;
  vDBGrid: TDBGridEh;
begin
  if Assigned(ADBGrid) then
  begin
    if ADBGrid is TDBGridEh then
    begin
      vDBGrid := TDBGridEh(ADBGrid);
      if Supports(Designer.GetDemon(ISHDBGridGeneralOptions), ISHDBGridGeneralOptions, vGridGeneralOptions) then
      begin
        vDBGrid.AllowedOperations := [];
        if vGridGeneralOptions.AllowedOperations.Insert then
          vDBGrid.AllowedOperations := vDBGrid.AllowedOperations +  [alopInsertEh];
        if vGridGeneralOptions.AllowedOperations.Update then
          vDBGrid.AllowedOperations := vDBGrid.AllowedOperations +  [alopUpdateEh];
        if vGridGeneralOptions.AllowedOperations.Delete then
          vDBGrid.AllowedOperations := vDBGrid.AllowedOperations +  [alopDeleteEh];
        if vGridGeneralOptions.AllowedOperations.Append then
          vDBGrid.AllowedOperations := vDBGrid.AllowedOperations +  [alopAppendEh];
        vDBGrid.AllowedSelections := [];
        if vGridGeneralOptions.AllowedSelections.RecordBookmarks then
          vDBGrid.AllowedSelections := vDBGrid.AllowedSelections +  [gstRecordBookmarks];
        if vGridGeneralOptions.AllowedSelections.Rectangle then
          vDBGrid.AllowedSelections := vDBGrid.AllowedSelections +  [gstRectangle];
        if vGridGeneralOptions.AllowedSelections.Columns then
          vDBGrid.AllowedSelections := vDBGrid.AllowedSelections +  [gstColumns];
        if vGridGeneralOptions.AllowedSelections.All then
          vDBGrid.AllowedSelections := vDBGrid.AllowedSelections +  [gstAll];
        vDBGrid.AutoFitColWidths := vGridGeneralOptions.AutoFitColWidths;
        vDBGrid.DrawMemoText := vGridGeneralOptions.DrawMemoText;
        vDBGrid.FrozenCols := vGridGeneralOptions.FrozenCols;
        vDBGrid.HorzScrollBar.Tracking :=
          vGridGeneralOptions.HorzScrollBar.Tracking;
        vDBGrid.HorzScrollBar.Visible :=
          vGridGeneralOptions.HorzScrollBar.Visible;
        case vGridGeneralOptions.HorzScrollBar.VisibleMode of
          Always: vDBGrid.HorzScrollBar.VisibleMode := sbAlwaysShowEh;
          Never: vDBGrid.HorzScrollBar.VisibleMode := sbNeverShowEh;
          Auto: vDBGrid.HorzScrollBar.VisibleMode := sbAutoShowEh;
        end;
        vDBGrid.MinAutoFitWidth := vGridGeneralOptions.MinAutoFitWidth;
        vDBGrid.Options := [];
        vDBGrid.OptionsEh := [dghDblClickOptimizeColWidth,dghAutoSortMarking,dghMultiSortMarking];
        if vGridGeneralOptions.Options.AlwaysShowEditor then
          vDBGrid.Options := vDBGrid.Options + [dgAlwaysShowEditor];
        if vGridGeneralOptions.Options.AlwaysShowSelection then
          vDBGrid.Options := vDBGrid.Options + [dgAlwaysShowSelection];
        if vGridGeneralOptions.Options.CancelOnExit then
          vDBGrid.Options := vDBGrid.Options + [dgCancelOnExit];
        if vGridGeneralOptions.Options.ClearSelection then
          vDBGrid.OptionsEh := vDBGrid.OptionsEh + [dghClearSelection];
        if vGridGeneralOptions.Options.ColLines then
          vDBGrid.Options := vDBGrid.Options + [dgColLines];
        if vGridGeneralOptions.Options.ColumnResize then
          vDBGrid.Options := vDBGrid.Options + [dgColumnResize];
        if vGridGeneralOptions.Options.ConfirmDelete then
          vDBGrid.Options := vDBGrid.Options + [dgConfirmDelete];
        if vGridGeneralOptions.Options.Data3D then
          vDBGrid.OptionsEh := vDBGrid.OptionsEh + [dghData3D];
        if vGridGeneralOptions.Options.Editing then
          vDBGrid.Options := vDBGrid.Options + [dgEditing];
        if vGridGeneralOptions.Options.EnterAsTab then
          vDBGrid.OptionsEh := vDBGrid.OptionsEh + [dghEnterAsTab];
        if vGridGeneralOptions.Options.IncSearch then
          vDBGrid.OptionsEh := vDBGrid.OptionsEh + [dghIncSearch];
        if vGridGeneralOptions.Options.Indicator then
          vDBGrid.Options := vDBGrid.Options + [dgIndicator];
        if vGridGeneralOptions.Options.FitRowHeightToText then
          vDBGrid.OptionsEh := vDBGrid.OptionsEh + [dghFitRowHeightToText];
        if vGridGeneralOptions.Options.Fixed3D then
          vDBGrid.OptionsEh := vDBGrid.OptionsEh + [dghFixed3D];
        if vGridGeneralOptions.Options.Frozen3D then
          vDBGrid.OptionsEh := vDBGrid.OptionsEh + [dghFrozen3D];
        if vGridGeneralOptions.Options.HighlightFocus then
          vDBGrid.OptionsEh := vDBGrid.OptionsEh + [dghHighlightFocus];
        if vGridGeneralOptions.Options.MultiSelect then
          vDBGrid.Options := vDBGrid.Options + [dgMultiSelect];
        if vGridGeneralOptions.Options.PreferIncSearch then
          vDBGrid.OptionsEh := vDBGrid.OptionsEh + [dghPreferIncSearch];
        if vGridGeneralOptions.Options.ResizeWholeRightPart then
          vDBGrid.OptionsEh := vDBGrid.OptionsEh + [dghResizeWholeRightPart];
        if vGridGeneralOptions.Options.RowHighlight then
          vDBGrid.OptionsEh := vDBGrid.OptionsEh + [dghRowHighlight];
        if vGridGeneralOptions.Options.RowLines then
          vDBGrid.Options := vDBGrid.Options + [dgRowLines];
        if vGridGeneralOptions.Options.RowSelect then
          vDBGrid.Options := vDBGrid.Options + [dgRowSelect];
        if vGridGeneralOptions.Options.Tabs then
          vDBGrid.Options := vDBGrid.Options + [dgTabs];
        if vGridGeneralOptions.Options.Titles then
          vDBGrid.Options := vDBGrid.Options + [dgTitles];
        if vGridGeneralOptions.Options.TraceColSizing then
          vDBGrid.OptionsEh := vDBGrid.OptionsEh + [dghTraceColSizing];
        vDBGrid.RowHeight := vGridGeneralOptions.RowHeight;
        vDBGrid.RowLines := vGridGeneralOptions.RowLines;
        vDBGrid.RowSizingAllowed := vGridGeneralOptions.RowSizingAllowed;
        vDBGrid.TitleHeight := vGridGeneralOptions.TitleHeight;
        ToolTips := vGridGeneralOptions.ToolTips;
        vDBGrid.ShowHint := ToolTips;
        vDBGrid.VertScrollBar.Tracking :=
          vGridGeneralOptions.VertScrollBar.Tracking;
        vDBGrid.VertScrollBar.Visible :=
          vGridGeneralOptions.VertScrollBar.Visible;
        case vGridGeneralOptions.VertScrollBar.VisibleMode of
          Always: vDBGrid.VertScrollBar.VisibleMode := sbAlwaysShowEh;
          Never: vDBGrid.VertScrollBar.VisibleMode := sbNeverShowEh;
          Auto: vDBGrid.VertScrollBar.VisibleMode := sbAutoShowEh;
        end;
        vGridGeneralOptions := nil;
      end;

      if Supports(Designer.GetDemon(ISHDBGridDisplayOptions), ISHDBGridDisplayOptions, vGridDisplayOptions) then
      begin
        DBGridEhDefaultStyle.LuminateSelection := vGridDisplayOptions.LuminateSelection;
        Striped := vGridDisplayOptions.Striped;
        vDBGrid.Font.Assign(vGridDisplayOptions.Font);
        vDBGrid.TitleFont.Assign(vGridDisplayOptions.TitleFont);
        vGridDisplayOptions := nil;
      end;

      if Supports(Designer.GetDemon(ISHDBGridColorOptions), ISHDBGridColorOptions,  vGridColorOptions) then
      begin
        vDBGrid.Color := vGridColorOptions.Background;
        vDBGrid.FixedColor := vGridColorOptions.Fixed;
        CurrentRowColor := vGridColorOptions.CurrentRow;
        OddRowColor := vGridColorOptions.OddRow;
        NullValueColor := vGridColorOptions.NullValue;
        vGridColorOptions := nil;
      end;
      ApplyGridFormatOptions(vDBGrid);
      DoFitDisplayWidths(vDBGrid);
    end;
  end
  else
  begin
    if Supports(Designer.GetDemon(ISHDBGridGeneralOptions), ISHDBGridGeneralOptions, vGridGeneralOptions) then
    begin
      ToolTips := vGridGeneralOptions.ToolTips;
      vGridGeneralOptions := nil;
    end;
    if Supports(Designer.GetDemon(ISHDBGridDisplayOptions), ISHDBGridDisplayOptions, vGridDisplayOptions) then
    begin
      Striped := vGridDisplayOptions.Striped;
      vGridDisplayOptions := nil;
    end;
    if Supports(Designer.GetDemon(ISHDBGridColorOptions), ISHDBGridColorOptions,  vGridColorOptions) then
    begin
      CurrentRowColor := vGridColorOptions.CurrentRow;
      OddRowColor := vGridColorOptions.OddRow;
      NullValueColor := vGridColorOptions.NullValue;
      vGridColorOptions := nil;
    end;
    ApplyGridFormatOptions(nil);
    DoFitDisplayWidths(nil);
  end;
end;

procedure TibSHDataCustomForm.AfterOpen(ADataset: IibSHDRVDataset);
begin
  ApplyGridFormatOptions(DBGrid);
  DoFitDisplayWidths(DBGrid);
  DoUpdateStatusBar;
  if Assigned(DBGrid) and Assigned(DBGrid.Parent) and
    (DBGrid.Parent is TWinControl) then
    (DBGrid.Parent as TWinControl).Width := (DBGrid.Parent as TWinControl).Width + 1;
end;

procedure TibSHDataCustomForm.OnFetchRecord(ADataset: IibSHDRVDataset);
begin
end;

procedure TibSHDataCustomForm.OnError(ADataset: IibSHDRVDataset);
begin
//  Exit;
  AddToResultEdit(ADataset.ErrorText);
end;

function TibSHDataCustomForm.GetCanRun: Boolean;
begin
  Result := False;
end;

function TibSHDataCustomForm.GetCanPause: Boolean;
begin
  Result := Assigned(SHCLDatabase) and (not SHCLDatabase.WasLostConnect) and
    Assigned(Data) and Data.Dataset.IsFetching;
end;

function TibSHDataCustomForm.GetCanCommit: Boolean;
begin
  Result := Assigned(SHCLDatabase) and
            (not SHCLDatabase.WasLostConnect) and
            Assigned(Data) and
            (not Data.Dataset.IsFetching) and
            Data.Transaction.InTransaction;
end;

function TibSHDataCustomForm.GetCanRollback: Boolean;
begin
  Result := GetCanCommit;
end;

function TibSHDataCustomForm.GetCanRefresh: Boolean;
begin
  Result := Assigned(SHCLDatabase) and
            (not SHCLDatabase.WasLostConnect) and
            Assigned(SHCLDatabase) and
            Assigned(Data) and
            (not Data.Dataset.IsFetching) and
            (Length(Data.Dataset.SelectSQL.Text) > 0);
end;

procedure TibSHDataCustomForm.Pause;
begin
  if GetCanPause then
  begin
    Data.Dataset.IsFetching := False;
    Application.ProcessMessages;
    if Assigned(DBGrid) then
      if DBGrid.CanFocus then
        DBGrid.SetFocus;
  end;
end;

procedure TibSHDataCustomForm.Commit;
begin
  CommitWithRefresh(True);
end;

procedure TibSHDataCustomForm.Rollback;
begin
  RollbackWithRefresh(True);
end;

procedure TibSHDataCustomForm.Refresh;
begin
  if GetCanRefresh then
    DoRefresh(True);
end;

function TibSHDataCustomForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
  if Result then
    SetDBGridOptions(DBGrid);
end;

procedure TibSHDataCustomForm.DoUpdateStatusBar;
begin
  if Assigned(StatusBar) and Assigned(DBGrid) and (StatusBar.Panels.Count > 1) then
  begin
    if Assigned(SHCLDatabase) and (not SHCLDatabase.WasLostConnect) then
    begin
      if Assigned(DBGrid.DataSource) and Assigned(DBGrid.DataSource.DataSet) then
      begin
        StatusBar.Panels[0].Text := ' ' + GetEnumName(TypeInfo(TDataSetState), Integer(DBGrid.DataSource.DataSet.State));
        if DBGrid.DataSource.DataSet.State = dsBrowse then
          StatusBar.Panels[1].Text := Format(' Records fetched: %s', [FormatFloat('###,###,###,##0', DBGrid.DataSource.DataSet.RecordCount)]);
      end;
    end
    else
    begin
      StatusBar.Panels[0].Text := '';
      StatusBar.Panels[1].Text := '';
    end;
  end;
end;

procedure TibSHDataCustomForm.CommitWithRefresh(ADoRefresh: Boolean);
var
  I: Integer;
  vSQLEditorForm: IibSHSQLEditorForm;
  vWasError: Boolean;
begin
  if GetCanCommit then
  begin
    HideMessages;
    ClearMessages;
    vWasError := False;
    Pause;
    if Data.Dataset.Dataset.State in [dsInsert, dsEdit] then
      try
        Data.Dataset.Dataset.Post;
      except
        on E:Exception do
        begin
          AddToResultEdit(E.Message);
          vWasError := True;
        end;
      end;
    Data.Transaction.Commit;
    if Length(Data.Transaction.ErrorText) > 0 then
    begin
      AddToResultEdit(Data.Transaction.ErrorText, False);
      vWasError := True;
    end else
      if Assigned(SQLEditor) then
        for I := 0 to Pred((SQLEditor as ISHComponentFormCollection).ComponentForms.Count) do
          if Supports((SQLEditor as ISHComponentFormCollection).ComponentForms[I], IibSHSQLEditorForm, vSQLEditorForm) then
          begin
            vSQLEditorForm.ShowTransactionCommited;
            Break;
          end;
    if not Assigned(SQLEditor) then
    begin
      if ADoRefresh then
        DoRefresh(not vWasError);
    end
    else
      Designer.ChangeNotification(Component, SCallSQLText, opInsert);
  end;
end;

procedure TibSHDataCustomForm.RollbackWithRefresh(ADoRefresh: Boolean);
var
  I: Integer;
  vSQLEditorForm: IibSHSQLEditorForm;
  vWasError: Boolean;
begin
  if GetCanRollback then
  begin
    HideMessages;
    ClearMessages;
    vWasError := False;
    Pause;
    if Data.Dataset.Dataset.State in [dsInsert, dsEdit] then
      Data.Dataset.Dataset.Cancel;  
    Data.Transaction.Rollback;
    if Length(Data.Transaction.ErrorText) > 0 then
    begin
      AddToResultEdit(Data.Transaction.ErrorText);
      vWasError := True;
    end else
      if Assigned(SQLEditor) then
        for I := 0 to Pred((SQLEditor as ISHComponentFormCollection).ComponentForms.Count) do
          if Supports((SQLEditor as ISHComponentFormCollection).ComponentForms[I], IibSHSQLEditorForm, vSQLEditorForm) then
          begin
            vSQLEditorForm.ShowTransactionRolledBack;
            Break;
          end;
    if not Assigned(SQLEditor) then
    begin
      if ADoRefresh then
        DoRefresh(not vWasError)
    end
    else
      Designer.ChangeNotification(Component, SCallSQLText, opInsert);
  end;
end;

function TibSHDataCustomForm.GetCanDestroy: Boolean;
var
  vMsgText: string;
  procedure DoTransactionAction;
  begin
    if Data.Transaction.InTransaction then
    begin
      if SameText(SHCLDatabase.DatabaseAliasOptions.DML.DefaultTransactionAction, DefaultTransactionActions[0]) then
        CommitWithRefresh(False)
      else
        RollbackWithRefresh(False);
    end;
  end;
  procedure DoTransactionInvertAction;
  begin
    if Data.Transaction.InTransaction then
    begin
      if SameText(SHCLDatabase.DatabaseAliasOptions.DML.DefaultTransactionAction, DefaultTransactionActions[1]) then
        CommitWithRefresh(False)
      else
        RollbackWithRefresh(False);
    end;
  end;
begin
  Result := inherited GetCanDestroy;
  if (not Assigned(SHCLDatabase)) or SHCLDatabase.WasLostconnect then Exit;
  if Result and Assigned(Data) then
  begin
    if Data.Dataset.Active and Data.Dataset.IsFetching then
    begin
      Result := False;
      Designer.ShowMsg(SDataFetching, mtInformation);
      Exit;
    end;
    if Data.Dataset.Dataset.State in [dsEdit, dsInsert] then
      Data.Dataset.Dataset.Cancel;
    if not AutoCommit then
    begin
      if Data.Transaction.InTransaction then
      begin
        if ConfirmEndTransaction then
        begin
          if SameText(SHCLDatabase.DatabaseAliasOptions.DML.DefaultTransactionAction, DefaultTransactionActions[0]) then
            vMsgText := SCommitTransaction
          else
            vMsgText := SRollbackTransaction;
          case Designer.ShowMsg(vMsgText) of
            ID_YES: DoTransactionAction;
            ID_NO: DoTransactionInvertAction;
            else
              Result := False;
          end;
        end
        else
          DoTransactionAction;
      end;
    end
    else
      CommitWithRefresh(False);
  end;
end;

procedure TibSHDataCustomForm.SetStatusBar(Value: TStatusBar);
begin
  inherited SetStatusBar(Value);

  if Assigned(StatusBar) then
  begin
    StatusBar.Panels.Clear;
    StatusBar.SimplePanel := False;
    with StatusBar.Panels do
    begin
      with Add do Width := 100;
      with Add do ;
    end;
  end;
end;

procedure TibSHDataCustomForm.FillPopupMenu;
var
  vCurrentItem: TMenuItem;
begin
  AddMenuItem(FEditorPopupMenu.Items, SSaveToFile, mnSaveToFileClick, ShortCut(Ord('S'), [ssCtrl]));
  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 21);
  AddMenuItem(FEditorPopupMenu.Items, SCut, mnCut, ShortCut(Ord('X'), [ssCtrl]));
  AddMenuItem(FEditorPopupMenu.Items, SCopy, mnCopy, ShortCut(Ord('C'), [ssCtrl]));
  AddMenuItem(FEditorPopupMenu.Items, SPaste, mnPaste, ShortCut(Ord('V'), [ssCtrl]));

  vCurrentItem := AddMenuItem(FEditorPopupMenu.Items, SOtherEdit);
    AddMenuItem(vCurrentItem, SUndo, mnUndo, ShortCut(Ord('Z'), [ssCtrl]));
    AddMenuItem(vCurrentItem, SRedo, mnRedo, ShortCut(Ord('Z'), [ssShift, ssCtrl]));
    AddMenuItem(vCurrentItem, '-', nil, 0, 23);
    AddMenuItem(vCurrentItem, SSelectAll, mnSelectAll, ShortCut(Ord('A'), [ssCtrl]));
  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 7);

  AddMenuItem(FEditorPopupMenu.Items, SPrint, mnPrintClick, ShortCut(Ord('P'), [ssCtrl]));
  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 8);


  AddMenuItem(FEditorPopupMenu.Items, SShowMessages, mnShowHideMessagesClick);
  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 9);
  AddMenuItem(FEditorPopupMenu.Items, SProperties, mnShowPropertiesClick);
end;

procedure TibSHDataCustomForm.DoOnPopup(Sender: TObject);
var
  vCurrentMenuItem: TMenuItem;
  I: Integer;
begin
  if Assigned(DBGrid) then
  begin
    MenuItemByName(FEditorPopupMenu.Items, SSaveToFile).Enabled := GetCanSave;
    MenuItemByName(FEditorPopupMenu.Items, SCut).Enabled := GetCanCut;
    MenuItemByName(FEditorPopupMenu.Items, SCopy).Enabled := GetCanCopy;
    MenuItemByName(FEditorPopupMenu.Items, SPaste).Enabled := GetCanPaste;
    vCurrentMenuItem := MenuItemByName(FEditorPopupMenu.Items, SOtherEdit);
      MenuItemByName(vCurrentMenuItem, SUndo).Enabled := GetCanUndo;
      MenuItemByName(vCurrentMenuItem, SRedo).Enabled := GetCanRedo;
      MenuItemByName(vCurrentMenuItem, SSelectAll).Enabled := GetCanSelectAll;

    MenuItemByName(FEditorPopupMenu.Items, SPrint).Enabled := GetCanPrint;

    vCurrentMenuItem := MenuItemByName(FEditorPopupMenu.Items, SShowMessages);
    if not Assigned(vCurrentMenuItem) then
      vCurrentMenuItem := MenuItemByName(FEditorPopupMenu.Items, SHideMessages);

    if Assigned(vCurrentMenuItem) then
    begin
      if Assigned(ResultEdit) then
      begin
        if GetEditorMsgVisible then
          vCurrentMenuItem.Caption := SHideMessages
        else
          vCurrentMenuItem.Caption := SShowMessages;
      end
      else
      begin
        vCurrentMenuItem.Visible := False;
        vCurrentMenuItem := MenuItemByName(FEditorPopupMenu.Items, '-', 7);
        if Assigned(vCurrentMenuItem) then
          vCurrentMenuItem.Visible := False;
      end;
    end;

    for I := 0 to FEditorPopupMenu.Items.Count - 1 do
      FEditorPopupMenu.Items[I].RethinkHotkeys;
  end;
end;

procedure TibSHDataCustomForm.ShowProperties;
begin
  if Assigned(DBGrid) then
    Designer.ShowEnvironmentOptions(ISHDBGridGeneralOptions);
end;

{ DBGrid }

procedure TibSHDataCustomForm.DBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  with TDBGridEh(Sender), TDBGridEh(Sender).Canvas, Rect do
  begin
    if Assigned(DataSource) and Assigned(DataSource.DataSet) and
      {(not DRVDataset.IsFetching) and }(not Data.Dataset.IsEmpty) then
    begin
      if dgRowSelect in Options then
      begin
        if (gdSelected in State) then
          Canvas.Brush.Color := CurrentRowColor;
        DefaultDrawColumnCell(Rect, DataCol, Column, State);
      end;
      if Assigned(Column.Field) and (Column.Field.IsNull) then
      begin
        FillRect(Rect);
        if not (gdFocused in State) then
          Canvas.Font.Color := NullValueColor
        else
          Canvas.Font.Color := clHighlightText;
        if Assigned(GridFormatOptions) then
          Canvas.TextOut(Rect.Left + 2, Rect.Top, GridFormatOptions.DisplayFormats.NullValue)
        else
          Canvas.TextOut(Rect.Left + 2, Rect.Top, '<null>')
      end;
    end;
  end;
end;

procedure TibSHDataCustomForm.DBGridGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  with TDBGridEh(Sender) do
  begin
    if Striped and Assigned(DataSource) and
       Assigned(DataSource.Dataset) and
       (not DataSource.Dataset.ControlsDisabled) then
      if DataSource.Dataset.RecNo mod 2 <> 1 then
        Background := OddRowColor;
  end;
end;

procedure TibSHDataCustomForm.DBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(Data.Dataset) and (not Data.Dataset.IsFetching) then
  begin
    if not (([ssCtrl] = Shift) or (Key = VK_END)) then EnabledFetchEvent := False;
  end else
  begin
    if Assigned(Data) then Data.Dataset.IsFetching := False;
  end;
end;

procedure TibSHDataCustomForm.DBGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  EnabledFetchEvent := True;
end;

procedure TibSHDataCustomForm.DBGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(Data.Dataset) and (not Data.Dataset.IsFetching) then
  begin
    EnabledFetchEvent := False
  end else
  begin
    if Assigned(Data) then Data.Dataset.IsFetching := False;
  end;
end;

procedure TibSHDataCustomForm.DBGridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  EnabledFetchEvent := True;
end;

procedure TibSHDataCustomForm.BringToTop;
begin
  inherited BringToTop;
  if Loading then
  begin
    try
      ShowResult;
    finally
      Loading := False;
    end;
  end;
  ApplyGridFormatOptions(DBGrid);
  DoUpdateStatusBar;
  {
  if Assigned(DBGrid) and Assigned(DBGrid.Parent) and
    (DBGrid.Parent is TWinControl) then
    (DBGrid.Parent as TWinControl).Width := (DBGrid.Parent as TWinControl).Width + 1;
  }
end;

procedure TibSHDataCustomForm.ShowResult(AEnableFetchEvent: Boolean = True);
begin
//  HideMessages;
//  ClearMessages;
  if Assigned(Data) and Assigned(SHCLDatabase) then
  begin
    if SHCLDatabase.WasLostConnect then Exit;
    EnabledFetchEvent := AEnableFetchEvent;
    if not Supports(Component, IibSHSQLEditor) then
    begin
      if not Data.Dataset.Active then
        if (not Data.Open) and (Length(Data.ErrorText) > 0) then
          if Assigned(ResultEdit) then
            AddToResultEdit(Data.ErrorText);
      if Data.Dataset.Active then
      begin
        ApplyGridFormatOptions(DBGrid);
        DoFitDisplayWidths(DBGrid);
      end;
    end
    else
    begin
      ApplyGridFormatOptions(DBGrid);
      DoFitDisplayWidths(DBGrid);
    end;
  end;
end;



{ TibBTDatasetFeaturesEh }

procedure TibSHDatasetFeaturesEh.ApplySorting(Sender: TObject;
  DataSet: TDataSet; IsReopen: Boolean);
var vFields: array of TVarRec ;
    vOrderings : array of boolean;
    I: Integer;
    J: Integer;
    vGrid : TCustomDBGridEh;
    vDataset: IibSHDRVDataset;
begin
  if (Sender is TCustomDBGridEh) and
    Supports(DataSet, IibSHDRVDataset, vDataset) then
  begin
    vGrid := TCustomDBGridEh(Sender);
    J := vGrid.SortMarkedColumns.Count;
    SetLength(vFields, J);
    SetLength(vOrderings, J);
    for I:=0 to Pred(J) do
    begin
     vFields[I].VType := vtAnsiString;
     string(vFields[I].VString) := vGrid.SortMarkedColumns[i].FieldName;
     vOrderings[I] := vGrid.SortMarkedColumns[i].Title.SortMarker = smDownEh;
    end;
    vDataset.DoSort(vFields, vOrderings);
  end;
end;

procedure TibSHDatasetFeaturesEh.ApplyFilter(Sender: TObject;
  DataSet: TDataSet; IsReopen: Boolean);
var
  vDataset: IibSHDRVDataset;
  s:string;

begin
  if (Sender is TCustomDBGridEh) and
    Supports(DataSet, IibSHDRVDataset, vDataset) then
  begin
   s:=GetExpressionAsFilterString(TDBGridEh(Sender),
      GetOneExpressionAsLocalFilterString, nil,False,True);
{   p:=Pos(' NOT LIKE ',UpperCase(s));
   while p>0 do
   begin
    s:=
   end;}
   vDataset.Filter := s
  end;
end;


function TibSHDataCustomForm.GetGridWideEditor:TControl;
begin
 if FWideEditor=nil then
 begin
  if Assigned(FDBGrid) then
    FWideEditor:=DBGrid.FindChildControl('WideEditor');
 end;   
 Result:=FWideEditor
end;

{ISHEditCommands}
procedure TibSHDataCustomForm.Copy;
var
  I: Integer;
  vClipboardFormat: ISHClipboardFormat;

  FEdit:TControl;
begin
  FEdit:=GetGridWideEditor;

  if GetCanCopy then
    if (FDBGrid.Selection.SelectionType <> gstNon) then
    begin
      for I := Pred(Designer.Components.Count) downto 0 do
        if Supports(Designer.Components[I], ISHClipboardFormat, vClipboardFormat) then
        begin
          try
            Screen.Cursor := crHourGlass;
            vClipboardFormat.CopyToClipboard(Component, Data.Dataset.Dataset, FDBGrid);
          finally
            Screen.Cursor := crDefault;
          end;
        end;
    end
    else
      if ((FEdit<>nil) and TWinControl(FEdit).Focused) then
                     (TCustomEdit(FEdit).Perform(WM_COPY, 0, 0))
      else
      if Assigned(FDBGrid.InplaceEditor) then
        FDBGrid.InplaceEditor.Perform(WM_COPY, 0, 0)

end;

procedure TibSHDataCustomForm.Cut;
begin
  if GetCanCut then
    if ((GetGridWideEditor<>nil) and TWinControl(GetGridWideEditor).Focused) then
        TCustomEdit(GetGridWideEditor).Perform(WM_CUT, 0, 0)
    else
    if Assigned(FDBGrid.InplaceEditor) then
     FDBGrid.InplaceEditor.Perform(WM_CUT, 0, 0)
end;

function TibSHDataCustomForm.GetCanCopy: Boolean;
begin
 Result:= InternalGetCanCut;
 if not Result then
  Result:= GetCanSave and
            Assigned(FDBGrid) and
            (FDBGrid.Selection.SelectionType <> gstNon)
end;

function TibSHDataCustomForm.InternalGetCanCut: Boolean;
begin
  Result := GetCanSave and
            Assigned(FDBGrid) and
            (
             Assigned(FDBGrid.InplaceEditor) and FDBGrid.InplaceEditor.Visible and
             (Length(FDBGrid.InplaceEditor.SelText) > 0)
             or

             (GetGridWideEditor<>nil) and ( TWinControl(GetGridWideEditor).Focused)
              and
              (TCustomEdit(GetGridWideEditor).SelLength>0)
            )
             and
            (FDBGrid.Columns.Count > 0) and
            (FDBGrid.SelectedIndex < FDBGrid.Columns.Count) and
            FDBGrid.Columns[DBGrid.SelectedIndex].CanModify(False);
end;

function TibSHDataCustomForm.GetCanCut: Boolean;
begin
 Result:=InternalGetCanCut;
end;

function TibSHDataCustomForm.GetCanPaste: Boolean;
begin
  try
    Result := GetCanSave and
              Assigned(FDBGrid) and
              (
               Assigned(FDBGrid.InplaceEditor) and  FDBGrid.InplaceEditor.Visible
               or
               (GetGridWideEditor<>nil) and TWinControl(GetGridWideEditor).Focused
              )

               and
              (FDBGrid.Columns.Count > 0) and
              (FDBGrid.SelectedIndex < FDBGrid.Columns.Count) and
              FDBGrid.Columns[FDBGrid.SelectedIndex].CanModify(False);
    Result := Result and IsClipboardFormatAvailable(CF_TEXT);
  except
    Result := False;
  end;
end;

procedure TibSHDataCustomForm.Paste;
var
 FEdit:TControl;
begin
  if GetCanPaste then
  begin
   FEdit:=GetGridWideEditor;
   if Assigned(FDBGrid.InplaceEditor) and FDBGrid.InplaceEditor.Focused then
    FDBGrid.InplaceEditor.Perform(WM_PASTE, 0, 0)
   else
    if ((FEdit<>nil) and TWinControl(FEdit).Focused) then
        (TCustomEdit(FEdit).Perform(WM_PASTE,0, 0))
 end;
end;
{End ISHEditCommands}

{ TibSHDataCustomToolbarAction }

constructor TibSHDataCustomToolbarAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  if Self.InheritsFrom(TibSHDataCustomToolbarAction_Refresh) then Tag := 1;
  if Self.InheritsFrom(TibSHDataCustomToolbarAction_Commit) then Tag := 2;
  if Self.InheritsFrom(TibSHDataCustomToolbarAction_Rollback) then Tag := 3;
  if Self.InheritsFrom(TibSHDataCustomToolbarAction_Filter) then Tag := 4;
  if Self.InheritsFrom(TibSHDataCustomToolbarAction_Pause) then Tag := 5;
  if Self.InheritsFrom(TibSHDataCustomToolbarAction_BackToQuery) then Tag := 6;
  if Self.InheritsFrom(TibSHDataCustomToolbarAction_Save) then Tag := 7;
  if Self.InheritsFrom(TibSHDataCustomToolbarAction_Open) then Tag := 8;
  if Self.InheritsFrom(TibSHDataCustomToolbarAction_Export2Excel) then Tag := 9;
  if Self.InheritsFrom(TibSHDataCustomToolbarAction_Export2OO) then Tag := 10;

  case Tag of
    1:
    begin
      Caption := Format('%s', ['Refresh']);
      ShortCut := TextToShortCut('F5');      
    end;
    2:
    begin
      Caption := Format('%s', ['Commit']);
      ShortCut := TextToShortCut('Shift+Ctrl+C');
    end;
    3:
    begin
      Caption := Format('%s', ['Rollback']);
      ShortCut := TextToShortCut('Shift+Ctrl+R');
    end;
    4:
    begin
      Caption := Format('%s', ['Filter']);
    end;
    5:
    begin
      Caption := Format('%s', ['Stop']);
      ShortCut := TextToShortCut('Ctrl+BkSp');
    end;
    6:
    begin
      Caption := Format('%s', ['Back To Query']);
      ShortCut := TextToShortCut('Ctrl+Enter');
    end;
    7:
    begin
      Caption := Format('%s', ['Save']);
      ShortCut := TextToShortCut('Ctrl+S');
    end;
    8:
    begin
      Caption := Format('%s', ['Open']);
      ShortCut := TextToShortCut('Ctrl+O');
    end;
    9:
    begin
      Caption := Format('%s', ['Export to Excel']);
      ShortCut := TextToShortCut('Ctrl+E');
    end;
    10:
    begin
      Caption := Format('%s', ['Export to Open Office']);
//      ShortCut := TextToShortCut('Ctrl+E');
    end;
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibSHDataCustomToolbarAction.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHTable) or
            IsEqualGUID(AClassIID, IibSHSystemTable) or
            IsEqualGUID(AClassIID, IibSHView) or
            IsEqualGUID(AClassIID, IibSHSQLEditor);
end;

procedure TibSHDataCustomToolbarAction.EventExecute(Sender: TObject);
begin
  case Tag of
    // Refresh
    1: (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
    // Commit
    2: (Designer.CurrentComponentForm as ISHRunCommands).Commit;
    // Rollback
    3: (Designer.CurrentComponentForm as ISHRunCommands).Rollback;
    // Filtered
    4: with (Designer.CurrentComponentForm as IibSHDataCustomForm) do
         Filtered := not Filtered;
    // Pause
    5: (Designer.CurrentComponentForm as ISHRunCommands).Pause;
    // Back To Query
    6: Designer.ChangeNotification(Designer.CurrentComponent, SCallSQLText, opInsert);
    //Save
    7: (Designer.CurrentComponentForm as ISHFileCommands).Save;
    8: (Designer.CurrentComponentForm as ISHFileCommands).Open;
    9: if Supports(Designer.CurrentComponentForm,IIDBGridSupport) then
        GridToExcel2((Designer.CurrentComponentForm as IIDBGridSupport).DBGrid,
        'Sheet'
        ,1,1);
   10:
   if Supports(Designer.CurrentComponentForm,IIDBGridSupport) then
        DBGridToOOCalcFile((Designer.CurrentComponentForm as IIDBGridSupport).DBGrid,
        'Sheet'
        ,1,1);

  end;
end;

procedure TibSHDataCustomToolbarAction.EventHint(var HintStr: String;
  var CanShow: Boolean);
begin
end;

procedure TibSHDataCustomToolbarAction.EventUpdate(Sender: TObject);
var
  vIsDataBlob: Boolean;
begin
  if Assigned(Designer.CurrentComponentForm) and
     (AnsiSameText(Designer.CurrentComponentForm.CallString, SCallQueryResults) or
      AnsiSameText(Designer.CurrentComponentForm.CallString, SCallDataBLOB) or
      AnsiSameText(Designer.CurrentComponentForm.CallString, SCallDataForm) or
      AnsiSameText(Designer.CurrentComponentForm.CallString, SCallData)) then
  begin
    case Tag of
      // Separator
      0: ;
      // Refresh
      1:
        begin
          Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRefresh;
          Visible := True;
        end;
      // Commit
      2:
        begin
          Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanCommit;
          Visible := not (Designer.CurrentComponentForm as IibSHDataCustomForm).AutoCommit;
        end;
      // Rollback
      3:
        begin
          Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRollback;
          Visible := not (Designer.CurrentComponentForm as IibSHDataCustomForm).AutoCommit;
        end;
      // Filter
      4:
        begin
          Enabled := (Designer.CurrentComponentForm as IibSHDataCustomForm).CanFilter;
          Checked := (Designer.CurrentComponentForm as IibSHDataCustomForm).Filtered;
          Visible := True;
        end;
      // Pause
      5:
        begin
          Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanPause;
          Visible := True;
        end;
      // Back To Query
      6:
        begin
          Enabled := True;
          Visible := Supports(Designer.CurrentComponent, IibSHSQLEditor);
        end;
      // Save
      7:
        begin
          Enabled := (Designer.CurrentComponentForm as ISHFileCommands).CanSave;
          Visible := True;
        end;
      8:
        begin
          vIsDataBlob := AnsiSameText(Designer.CurrentComponentForm.CallString, SCallDataBLOB);
          Enabled := vIsDataBlob and (Designer.CurrentComponentForm as ISHFileCommands).CanOpen;
          Visible := vIsDataBlob;
        end;
      9: begin
          Visible := True;
          Enabled := True
         end;
     10: begin
          Visible := ExistOpenOffice;
          Enabled := True
         end;    
    end;
  end else
  begin
    Visible := False;
    Enabled := False;
  end;
end;

initialization

  RegisterDatasetFeaturesEh(TibSHDatasetFeaturesEh, TDataSet);

end.
