unit ibSHDataGridFrm;

interface

uses
  SHDesignIntf, SHOptionsIntf,
  ibSHDesignIntf, ibSHDriverIntf, ibSHDataCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, SynEdit, pSHSynEdit, Grids, DBGrids,
  DBGridEh, DbUtilsEh, ImgList, DB, DBCtrls, ActnList, AppEvnts, PrnDbgeh, TypInfo,
  Menus, StdCtrls, GridsEh;

type
  TibSHDataGridForm = class(TibSHDataCustomForm)
    Panel1: TPanel;
    Panel2: TPanel;
    pSHSynEdit2: TpSHSynEdit;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    DataSource1: TDataSource;
    sdGrid: TSaveDialog;
    PrintDBGridEh1: TPrintDBGridEh;
    PopupMenuMessage: TPopupMenu;
    pmiHideMessage: TMenuItem;
    DBGridEh1: TDBGridEh;
    ApplicationEvents1: TApplicationEvents;
    Panel3: TPanel;
    ToolBar1: TToolBar;
    DBNavigator1: TDBNavigator;
    procedure ControlBar1Resize(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure DataSource1StateChange(Sender: TObject);
    procedure pmiHideMessageClick(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);

  private
    procedure GutterDrawNotify(Sender: TObject; ALine: Integer; var ImageIndex: Integer);
    { Private declarations }
  protected
    procedure ShowMessages; override;
    procedure HideMessages; override;
    {IibDRVDatasetNotification}
    procedure OnFetchRecord(ADataset: IibSHDRVDataset); override;

    {ISHFileCommands}
    function GetCanSave: Boolean; override;
    function GetCanSaveAs: Boolean; override;
    function GetCanPrint: Boolean; override;

    procedure Save; override;
    procedure SaveAs; override;
    procedure Print; override;

    {End ISHFileCommands}

    { ISHSearchCommands }
    function GetCanFind: Boolean; override;
    function GetCanReplace: Boolean; override;
    function GetCanSearchAgain: Boolean; override;
    function GetCanSearchIncremental: Boolean; override;
    function GetCanGoToLineNumber: Boolean; override;

    procedure Find; override;
    procedure Replace; override;
    procedure SearchAgain; override;
    procedure SearchIncremental; override;

    {ISHEditCommands}
    function GetCanUndo: Boolean; override;
    function GetCanRedo: Boolean; override;
    function GetCanSelectAll: Boolean; override;
    function GetCanClearAll: Boolean; override;

    procedure Undo; override;
//    procedure Redo;
    procedure SelectAll; override;
    {End ISHEditCommands}

    procedure DoOnIdle; override;
    function GetCanDestroy: Boolean; override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure BringToTop; override;
  end;

  TibSHDataGridToolbarAction_Refresh = class(TibSHDataCustomToolbarAction_Refresh)
  end;
  TibSHDataGridToolbarAction_Commit = class(TibSHDataCustomToolbarAction_Commit)
  end;
  TibSHDataGridToolbarAction_Rollback = class(TibSHDataCustomToolbarAction_Rollback)
  end;
  TibSHDataGridToolbarAction_Filter = class(TibSHDataCustomToolbarAction_Filter)
  end;
  TibSHDataGridToolbarAction_Pause = class(TibSHDataCustomToolbarAction_Pause)
  end;
  TibSHDataGridToolbarAction_BackToQuery = class(TibSHDataCustomToolbarAction_BackToQuery)
  end;
  TibSHDataGridToolbarAction_Open = class(TibSHDataCustomToolbarAction_Open)
  end;  
  TibSHDataGridToolbarAction_Save = class(TibSHDataCustomToolbarAction_Save)
  end;
  TibSHDataGridToolbarAction_ExportToExcel = class(TibSHDataCustomToolbarAction_Export2Excel)
  end;
  TibSHDataGridToolbarAction_ExportToOOCalc = class(TibSHDataCustomToolbarAction_Export2OO)
  end;



procedure Register();

var
  ibSHDataGridForm: TibSHDataGridForm;

implementation

uses
  ibSHConsts, ibSHValues, ibSHMessages, Clipbrd;

procedure Register();
begin
  SHREgisterImage(TibSHDataGridToolbarAction_Refresh.ClassName,     'Button_Refresh.bmp');
  SHREgisterImage(TibSHDataGridToolbarAction_Commit.ClassName,      'Button_TrCommit.bmp');
  SHREgisterImage(TibSHDataGridToolbarAction_Rollback.ClassName,    'Button_TrRollback.bmp');
  SHREgisterImage(TibSHDataGridToolbarAction_Filter.ClassName,      'Button_RunFilter.bmp');
  SHREgisterImage(TibSHDataGridToolbarAction_Pause.ClassName,       'Button_Stop.bmp');
  SHREgisterImage(TibSHDataGridToolbarAction_BackToQuery.ClassName, 'Button_Query_Prev.bmp');
  SHREgisterImage(TibSHDataGridToolbarAction_Open.ClassName,        'Button_Open.bmp');
  SHREgisterImage(TibSHDataGridToolbarAction_Save.ClassName,        'Button_Save.bmp');
  SHREgisterImage(TibSHDataGridToolbarAction_ExportToExcel.ClassName,'Button_Excel.bmp');
  SHREgisterImage(TibSHDataGridToolbarAction_ExportToOOCalc.ClassName,'Button_scalc.bmp');



  SHRegisterActions([
    // Toolbar
    TibSHDataGridToolbarAction_BackToQuery,
    TibSHDataGridToolbarAction_Pause,
    TibSHDataGridToolbarAction_Commit,
    TibSHDataGridToolbarAction_Rollback,
    TibSHDataGridToolbarAction_Filter,
    TibSHDataGridToolbarAction_Refresh,
    TibSHDataGridToolbarAction_Open,
    TibSHDataGridToolbarAction_Save,
    TibSHDataGridToolbarAction_ExportToExcel,
    TibSHDataGridToolbarAction_ExportToOOCalc
    ]);
end;

{$R *.dfm}

{ TibBTDataForm }

constructor TibSHDataGridForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  DBGrid := DBGridEh1;
  FocusedControl := DBGridEh1;
  ResultEdit := pSHSynEdit2;
  ResultEdit.Lines.Clear;
  ResultEdit.OnGutterDraw := GutterDrawNotify;
  ResultEdit.GutterDrawer.ImageList := ImageList1;
  ResultEdit.GutterDrawer.Enabled := True;
  HideMessages;
  CatchRunTimeOptionsDemon;
  DoOnOptionsChanged;

  if Assigned(Data) and Assigned(SHCLDatabase) then
    DataSource1.DataSet := Data.Dataset.Dataset;
end;

destructor TibSHDataGridForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHDataGridForm.ControlBar1Resize(Sender: TObject);
begin
  ToolBar1.Width := ToolBar1.Parent.ClientWidth;
end;

procedure TibSHDataGridForm.DataSource1DataChange(Sender: TObject;
  Field: TField);
begin
  if Assigned(DataSource1.DataSet) then
    DoUpdateStatusBar;
end;

procedure TibSHDataGridForm.DataSource1StateChange(Sender: TObject);
begin
  if Assigned(DataSource1.DataSet) then
    DoUpdateStatusBar;
end;

procedure TibSHDataGridForm.GutterDrawNotify(Sender: TObject; ALine: Integer;
  var ImageIndex: Integer);
begin
  if ALine = 0 then ImageIndex := 1;
end;

procedure TibSHDataGridForm.ShowMessages;
begin
  Panel2.Visible := True;
  Splitter1.Visible := True;
end;

procedure TibSHDataGridForm.HideMessages;
begin
  Panel2.Visible := False;
  Splitter1.Visible := False;
end;

procedure TibSHDataGridForm.OnFetchRecord(ADataset: IibSHDRVDataset);
begin
  if EnabledFetchEvent then
  begin
    if Assigned(SHCLDatabase) and (not SHCLDatabase.WasLostConnect) then
    begin
      DoUpdateStatusBar;
      Application.ProcessMessages;
      Designer.UpdateActions;
      if Assigned(SHCLDatabase) and (SHCLDatabase.WasLostConnect) then
      begin
        Data.Dataset.IsFetching := False;
        Exit;
      end;
    end
    else
      if Assigned(SHCLDatabase) and (SHCLDatabase.WasLostConnect) then
        Data.Dataset.IsFetching := False;
  end;
end;

function TibSHDataGridForm.GetCanSave: Boolean;
begin
  Result := Assigned(SHCLDatabase) and (not SHCLDatabase.WasLostConnect) and
            Assigned(Data) and Data.Dataset.Active;
end;

function TibSHDataGridForm.GetCanSaveAs: Boolean;
begin
  Result := GetCanSave and (ActiveControl is TDBGridEh);
end;

function TibSHDataGridForm.GetCanPrint: Boolean;
begin
  Result := GetCanSave;
end;

procedure TibSHDataGridForm.Save;
var
  vDataSaver: ISHDataSaver;
  vServerOptions: IibSHServerOptions;
  I, J: Integer;
  vFilter: string;
  vFileName: string;
  vInputExt: string;
  vExt: TStringList;
  vSaved: Boolean;
begin
  vFilter := '';
  vExt := TStringList.Create;
  try
    for I := Pred(Designer.Components.Count) downto 0 do
      if Supports(Designer.Components[I], ISHDataSaver, vDataSaver) then
        for J := 0 to Pred(vDataSaver.SupportsExtentions.Count) do
        begin
          if vExt.IndexOf(vDataSaver.SupportsExtentions[J]) = -1 then
          begin
            vExt.Add(vDataSaver.SupportsExtentions[J]);
            vFilter := vFilter +
              Format(SExportExtentionTemplate,
                [vDataSaver.ExtentionDescriptions[J],
                 vDataSaver.SupportsExtentions[J],
                 vDataSaver.SupportsExtentions[J]]) + '|';
          end;
        end;

    if Length(vFilter) > 0 then
    begin
      Delete(vFilter, Length(vFilter), 1);
      sdGrid.Filter := vFilter;
(* dk: заремил 27.06.2004 по причине сноса проперти DatabaseAliaOptions.Paths
      if Supports(Designer.GetOptions(ISHSystemOptions), ISHSystemOptions, vSystemOptions) then
        sdGrid.InitialDir := BTCLDatabase.DatabaseAliasOptions.Paths.ForExtracts;
*)
      if IsEqualGUID(Component.BranchIID, IibSHBranch) then
        Supports(Designer.GetOptions(IibSHServerOptions), IibSHServerOptions, vServerOptions)
      else
      if IsEqualGUID(Component.BranchIID, IfbSHBranch) then
        Supports(Designer.GetOptions(IfbSHServerOptions), IibSHServerOptions, vServerOptions);
      if Assigned(vServerOptions) then
        sdGrid.FilterIndex := vServerOptions.SaveResultFilterIndex;

      if sdGrid.Execute then
      begin
        vFileName := sdGrid.FileName;
        vInputExt := ExtractFileExt(sdGrid.FileName);
        if not SameText(vInputExt, vExt[sdGrid.FilterIndex - 1]) then
          vFileName := ChangeFileExt(vFileName, vExt[sdGrid.FilterIndex - 1]);
        vSaved := False;
        for I := Pred(Designer.Components.Count) downto 0 do
          if Supports(Designer.Components[I], ISHDataSaver, vDataSaver) then
          begin
            if vDataSaver.SupportsExtentions.IndexOf(vInputExt) <> -1 then
            begin
              vDataSaver.SaveToFile(Component, Data.Dataset.Dataset, DBGridEh1, vFileName);
              vSaved := True;
              Break;
            end;
          end;
        if vSaved and Assigned(vServerOptions) then
        begin
          vServerOptions.SaveResultFilterIndex := sdGrid.FilterIndex;
        end;
      end;
    end
    else
      Designer.ShowMsg(SNoExportersRegisted, mtWarning);
  finally
    vExt.Free;
  end;
end;

procedure TibSHDataGridForm.SaveAs;
begin
  Save;
end;

procedure TibSHDataGridForm.Print;
begin
  if GetCanPrint then
    PrintDBGridEh1.Preview;
end;

function TibSHDataGridForm.GetCanFind: Boolean;
begin
  Result := False;
end;

function TibSHDataGridForm.GetCanReplace: Boolean;
begin
  Result := False;
end;

function TibSHDataGridForm.GetCanSearchAgain: Boolean;
begin
  Result := False;
end;

function TibSHDataGridForm.GetCanSearchIncremental: Boolean;
begin
  Result := False;
end;

function TibSHDataGridForm.GetCanGoToLineNumber: Boolean;
begin
  Result := False;
end;

procedure TibSHDataGridForm.Find;
begin
  //
end;

procedure TibSHDataGridForm.Replace;
begin
  //
end;

procedure TibSHDataGridForm.SearchAgain;
begin
  //
end;

procedure TibSHDataGridForm.SearchIncremental;
begin
  //
end;

function TibSHDataGridForm.GetCanUndo: Boolean;
begin
  Result := GetCanSave and
            Assigned(DBGrid) and
            Assigned(DBGrid.InplaceEditor) and
            DBGrid.InplaceEditor.Visible and
            DBGrid.InplaceEditor.CanUndo;
end;

function TibSHDataGridForm.GetCanRedo: Boolean;
begin
  Result := False;
end;

function TibSHDataGridForm.GetCanSelectAll: Boolean;
begin
  Result := GetCanSave
   or
            (Assigned(DBGrid) and
            Assigned(DBGrid.InplaceEditor) and
            DBGrid.InplaceEditor.Visible);
end;

function TibSHDataGridForm.GetCanClearAll: Boolean;
begin
  Result := False;
end;

procedure TibSHDataGridForm.Undo;
begin
  if GetCanUndo then
    DBGrid.InplaceEditor.Undo;
end;

procedure TibSHDataGridForm.SelectAll;
begin
  if GetCanSelectAll then
    if Assigned(DBGrid) and Assigned(DBGrid.InplaceEditor) and DBGrid.InplaceEditor.Visible then
      DBGrid.InplaceEditor.SelectAll
    else
      DBGridEh1.Selection.SelectAll;
end;

procedure TibSHDataGridForm.DoOnIdle;
begin
  inherited DoOnIdle;
  DoUpdateStatusBar;
end;

function TibSHDataGridForm.GetCanDestroy: Boolean;
begin
  Result := True;
  if (not Designer.ExistsComponent(Component, SCallDataBLOB)) and
      (not Designer.ExistsComponent(Component, SCallDataForm)) then
    Result := inherited GetCanDestroy;
end;

procedure TibSHDataGridForm.BringToTop;
begin
  if Assigned(Data) then
    Data.Dataset.DatasetNotification := Self as IibDRVDatasetNotification;
  inherited BringToTop;
end;

procedure TibSHDataGridForm.pmiHideMessageClick(Sender: TObject);
begin
  HideMessages;
end;

procedure TibSHDataGridForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  DoOnIdle;
end;

initialization

  Register();

end.
