unit ibSHDMLExporter;

interface

uses
  SysUtils, Classes, Dialogs, ExtCtrls,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibSHDMLExporter = class(TibBTTool, IibSHDMLExporter, IibSHBranch, IfbSHBranch)
  private
    FData: IibSHData;
    FOutput: string;
    FMode: string;
    FTablesForDumping: TStringList;
    FActive: Boolean;
    FExportAs: string;
    FHeader: Boolean;
    FPassword: Boolean;
    FCommitAfter: Integer;
    FCommitEachTable: Boolean;
    FDateFormat: string;
    FTimeFormat: string;
    FUseDateTimeANSIPrefix: Boolean;
    FNonPrintChar2Space: Boolean;
    FUseExecuteBlock: Boolean;

  protected
    { IibSHDMLExporter }
    function GetData: IibSHData;
    procedure SetData(Value: IibSHData);
    function GetMode: string;
    procedure SetMode(Value: string);
    function GetTablesForDumping: TStrings;
    procedure SetTablesForDumping(Value: TStrings);
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetOutput: string;
    procedure SetOutput(Value: string);
    function GetStatementType: string;
    procedure SetStatementType(Value: string);
    function GetHeader: Boolean;
    procedure SetHeader(Value: Boolean);
    function GetPassword: Boolean;
    procedure SetPassword(Value: Boolean);
    function GetCommitAfter: Integer;
    procedure SetCommitAfter(Value: Integer);
    function GetCommitEachTable: Boolean;
    procedure SetCommitEachTable(Value: Boolean);
    function GetDateFormat: string;
    procedure SetDateFormat(Value: string);
    function GetTimeFormat: string;
    procedure SetTimeFormat(Value: string);
    function GetUseDateTimeANSIPrefix: Boolean;
    procedure SetUseDateTimeANSIPrefix(Value: Boolean);
    function GetNonPrintChar2Space: Boolean;
    procedure SetNonPrintChar2Space(Value: Boolean);
    function  GetUseExecuteBlock:boolean;
    procedure SetUseExecuteBlock(Value:boolean);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    property Mode: string read GetMode write SetMode;

  published
    property StatementType: string read GetStatementType write SetStatementType;
    property Header: Boolean read GetHeader write SetHeader;
    property Password: Boolean read GetPassword write SetPassword;
    property CommitAfter: Integer read GetCommitAfter write SetCommitAfter;
    property CommitEachTable: Boolean read GetCommitEachTable write SetCommitEachTable;

    property DateFormat: string read GetDateFormat write SetDateFormat;
    property TimeFormat: string read GetTimeFormat write SetTimeFormat;
    property UseDateTimeANSIPrefix: Boolean read GetUseDateTimeANSIPrefix
      write SetUseDateTimeANSIPrefix;
    property NonPrintChar2Space: Boolean read GetNonPrintChar2Space
      write SetNonPrintChar2Space;
    property Output: string read GetOutput write SetOutput;
    property UseExecuteBlock:boolean  read GetUseExecuteBlock write SetUseExecuteBlock;
  end;

  TibSHDMLExporterFactory = class(TibBTToolFactory, IibSHDMLExporterFactory)
  private
    FData: IibSHData;
    FMode: string;
    FTablesForDumping: TStringList;
    FSuspendedTimer: TTimer;
    FComponentForSuspendedDestroy: TSHComponent;
    procedure SuspendedTimerEvent(Sender: TObject);
  protected
    {IibSHDMLExporterFactory}
    function GetData: IibSHData;
    procedure SetData(Value: IibSHData);
    function GetMode: string;
    procedure SetMode(Value: string);
    function GetTablesForDumping: TStrings;
    procedure SetTablesForDumping(Value: TStrings);

    procedure SuspendedDestroyComponent(AComponent: TSHComponent);

    procedure DoBeforeChangeNotification(var ACallString: string; AComponent: TSHComponent); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function SupportComponent(const AClassIID: TGUID): Boolean; override;
  end;

procedure Register();

implementation

uses
  ibSHConsts, ibSHDMLExporterFrm,
  ibSHDMLExporterActions,
  ibSHDMLExporterEditors,
  ibSHComponent;

procedure Register();
begin
  SHRegisterImage(GUIDToString(IibSHDMLExporter), 'DMLExporter.bmp');

  SHRegisterImage(TibSHDMLExporterPaletteAction.ClassName,            'DMLExporter.bmp');
  SHRegisterImage(TibSHDMLExporterFormAction.ClassName,               'Form_DDLText.bmp');
  SHRegisterImage(TibSHDMLExporterToolbarAction_Run.ClassName,        'Button_Run.bmp');
  SHRegisterImage(TibSHDMLExporterToolbarAction_Pause.ClassName,      'Button_Stop.bmp');
  SHRegisterImage(TibSHDMLExporterToolbarAction_Region.ClassName,     'Button_Tree.bmp');
  SHRegisterImage(TibSHDMLExporterToolbarAction_Refresh.ClassName,    'Button_Refresh.bmp');
  SHRegisterImage(TibSHDMLExporterToolbarAction_SaveAs.ClassName,     'Button_SaveAs.bmp');
  SHRegisterImage(TibSHDMLExporterToolbarAction_CheckAll.ClassName,   'Button_Check.bmp');
  SHRegisterImage(TibSHDMLExporterToolbarAction_UnCheckAll.ClassName, 'Button_UnCheck.bmp');
  SHREgisterImage(TibSHDMLExporterToolbarAction_MoveDown.ClassName,   'Button_Arrow_Down.bmp');
  SHREgisterImage(TibSHDMLExporterToolbarAction_MoveUp.ClassName,     'Button_Arrow_Top.bmp');

  SHRegisterImage(SCallTargetScript, 'Form_DDLText.bmp');

  SHRegisterComponents([
    TibSHDMLExporter,
    TibSHDMLExporterFactory]);

  SHRegisterActions([
    // Palette
    TibSHDMLExporterPaletteAction,
    // Forms
    TibSHDMLExporterFormAction,
    // Toolbar
    TibSHDMLExporterToolbarAction_Run,
    TibSHDMLExporterToolbarAction_Pause,
//    TibSHDMLExporterToolbarAction_Region,
    TibSHDMLExporterToolbarAction_Refresh,
    TibSHDMLExporterToolbarAction_CheckAll,
    TibSHDMLExporterToolbarAction_UnCheckAll,
    TibSHDMLExporterToolbarAction_MoveDown,
    TibSHDMLExporterToolbarAction_MoveUp,
    TibSHDMLExporterToolbarAction_SaveAs,
    // Editors
    TibSHDMLExporterEditorAction_ExportIntoScript]);

  SHRegisterPropertyEditor(IibSHDMLExporter, 'StatementType', TibSHDMLExporterStatementTypePropEditor);
  SHRegisterPropertyEditor(IibSHDMLExporter, 'Output', TibSHDMLExporterOutputPropEditor);
end;

{ TibBTDMLExporter }

constructor TibSHDMLExporter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTablesForDumping := TStringList.Create;
  FTablesForDumping.Sorted := True;
  FTablesForDumping.CaseSensitive := True;
  FActive := False;
  FOutput := ExtractorOutputs[0];
  FMode := EmptyStr;
  FExportAs := ExtractorStatementType[0];
  FHeader := False;
  FPassword := False;
  FCommitAfter := 500;
  FDateFormat := 'YYYY-MM-DD';
  FTimeFormat := 'HH:NN:SS.ZZZ';
  FUseDateTimeANSIPrefix := False;
  FNonPrintChar2Space := False;
end;

destructor TibSHDMLExporter.Destroy;
begin
  FTablesForDumping.Free;
  inherited;
end;

function TibSHDMLExporter.GetData: IibSHData;
begin
  Result := FData;
end;

procedure TibSHDMLExporter.SetData(Value: IibSHData);
begin
  if FData <> Value then
  begin
    ReferenceInterface(FData, opRemove);
    FData := Value;
    ReferenceInterface(FData, opInsert);
    if Assigned(FData) then
      Mode := DMLExporterModes[1]
    else
      Mode := DMLExporterModes[0];
  end;
end;

function TibSHDMLExporter.GetMode: string;
begin
  Result := FMode;
end;

procedure TibSHDMLExporter.SetMode(Value: string);
begin
  FMode := Value;
end;

function TibSHDMLExporter.GetTablesForDumping: TStrings;
begin
  Result := FTablesForDumping;
end;

procedure TibSHDMLExporter.SetTablesForDumping(Value: TStrings);
begin
  FTablesForDumping.Assign(Value);
end;

function TibSHDMLExporter.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure TibSHDMLExporter.SetActive(Value: Boolean);
begin
  FActive := Value;
end;

function TibSHDMLExporter.GetOutput: string;
begin
  Result := FOutput;
end;

procedure TibSHDMLExporter.SetOutput(Value: string);
begin
  FOutput := Value;
end;

function TibSHDMLExporter.GetStatementType: string;
begin
  Result := FExportAs;
end;

procedure TibSHDMLExporter.SetStatementType(Value: string);
var
  vDMLExporterFormIntf: IibSHDMLExporterForm;
begin
  if CompareStr(FExportAs, Value) <> 0 then
  begin
    FExportAs := Value;
    if GetComponentFormIntf(IibSHDMLExporterForm, vDMLExporterFormIntf) then
      vDMLExporterFormIntf.UpdateTree;
  end;
end;

function TibSHDMLExporter.GetHeader: Boolean;
begin
  Result := FHeader;
end;

procedure TibSHDMLExporter.SetHeader(Value: Boolean);
begin
  FHeader := Value;
end;

function TibSHDMLExporter.GetPassword: Boolean;
begin
  Result := FPassword;
end;

procedure TibSHDMLExporter.SetPassword(Value: Boolean);
begin
  FPassword := Value;
end;

function TibSHDMLExporter.GetCommitAfter: Integer;
begin
  Result := FCommitAfter;
end;

procedure TibSHDMLExporter.SetCommitAfter(Value: Integer);
begin
  FCommitAfter := Value;
end;

function TibSHDMLExporter.GetCommitEachTable: Boolean;
begin
  Result := FCommitEachTable;
end;

procedure TibSHDMLExporter.SetCommitEachTable(Value: Boolean);
begin
  FCommitEachTable := Value;
end;

function TibSHDMLExporter.GetDateFormat: string;
begin
  Result := FDateFormat;
end;

procedure TibSHDMLExporter.SetDateFormat(Value: string);
begin
  FDateFormat := Value;
end;

function TibSHDMLExporter.GetTimeFormat: string;
begin
  Result := FTimeFormat;
end;

procedure TibSHDMLExporter.SetTimeFormat(Value: string);
begin
  FTimeFormat := Value;
end;

function TibSHDMLExporter.GetUseDateTimeANSIPrefix: Boolean;
begin
  Result := FUseDateTimeANSIPrefix;
end;

procedure TibSHDMLExporter.SetUseDateTimeANSIPrefix(Value: Boolean);
begin
  FUseDateTimeANSIPrefix := Value;
end;

function TibSHDMLExporter.GetNonPrintChar2Space: Boolean;
begin
  Result := FNonPrintChar2Space;
end;

procedure TibSHDMLExporter.SetNonPrintChar2Space(Value: Boolean);
begin
  FNonPrintChar2Space := Value;
end;

procedure TibSHDMLExporter.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  vDMLExporterFactory: IibSHDMLExporterFactory;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if AComponent.IsImplementorOf(FData) then
    begin
      FActive := False;
      FData := nil;
      if Supports(Designer.GetDemon(IibSHDMLExporterFactory), IibSHDMLExporterFactory, vDMLExporterFactory) then
        vDMLExporterFactory.SuspendedDestroyComponent(Self);
    end;
  end;
end;

{ TibSHDMLExporterFactory }

constructor TibSHDMLExporterFactory.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTablesForDumping := TStringList.Create;
  FSuspendedTimer := TTimer.Create(nil);
  FSuspendedTimer.Enabled := False;
  FSuspendedTimer.Interval := 1;
  FSuspendedTimer.OnTimer := SuspendedTimerEvent;
end;

destructor TibSHDMLExporterFactory.Destroy;
begin
  FTablesForDumping.Free;
  inherited Destroy;
end;

procedure TibSHDMLExporterFactory.SuspendedTimerEvent(Sender: TObject);
begin
  FSuspendedTimer.Enabled := False;
  if Assigned(FComponentForSuspendedDestroy) then
  begin
    DestroyComponent(FComponentForSuspendedDestroy);
    FComponentForSuspendedDestroy := nil;
  end;
end;

function TibSHDMLExporterFactory.GetData: IibSHData;
begin
  Result := FData;
end;

procedure TibSHDMLExporterFactory.SetData(Value: IibSHData);
begin
  FData := Value;
end;

function TibSHDMLExporterFactory.GetMode: string;
begin
  Result := FMode;
end;

procedure TibSHDMLExporterFactory.SetMode(Value: string);
begin
  FMode := Value;
end;

function TibSHDMLExporterFactory.GetTablesForDumping: TStrings;
begin
  Result := FTablesForDumping;
end;

procedure TibSHDMLExporterFactory.SetTablesForDumping(Value: TStrings);
begin
  FTablesForDumping.Assign(Value);
end;

procedure TibSHDMLExporterFactory.SuspendedDestroyComponent(
  AComponent: TSHComponent);
begin
  if Assigned(AComponent) then
  begin
    FComponentForSuspendedDestroy := AComponent;
    FSuspendedTimer.Enabled := True;
  end;
end;

procedure TibSHDMLExporterFactory.DoBeforeChangeNotification(
  var ACallString: string; AComponent: TSHComponent);
var
  DMLExporter: IibSHDMLExporter;
begin
  if Supports(AComponent, IibSHDMLExporter, DMLExporter) then
  begin
    DMLExporter.Data := FData;
    DMLExporter.Mode := FMode;
    DMLExporter.TablesForDumping := FTablesForDumping;
  end;
end;

function TibSHDMLExporterFactory.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDMLExporter);
end;

function TibSHDMLExporter.GetUseExecuteBlock: boolean;
begin
 Result:=FUseExecuteBlock
end;

procedure TibSHDMLExporter.SetUseExecuteBlock(Value: boolean);
begin
 FUseExecuteBlock:=Value
end;

initialization

  Register;

end.




