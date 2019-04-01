unit ibSHXHelpActions;

interface

uses
  SysUtils, Classes, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHXHelpFormAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHXHelpToolbarAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHXHelpToolbarAction_GB = class(TibSHXHelpToolbarAction_)
  end;
  TibSHXHelpToolbarAction_RU = class(TibSHXHelpToolbarAction_)
  end;

implementation

uses
  ibSHConsts,
  ibSHXHelpFrm;

{ TibSHXHelpFormAction }

constructor TibSHXHelpFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;

  Caption := SCallXHelp;

  SHRegisterComponentForm(IibSHDomain, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHTable, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHIndex, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHView, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHProcedure, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHTrigger, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHGenerator, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHException, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHFunction, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHFilter, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHRole, Caption, TibSHXHelpForm);

  SHRegisterComponentForm(IibSHSQLEditor, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDMLHistory, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDDLHistory, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDDLCommentator, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDDLGrantor, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDDLFinder, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDDLExtractor, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHTXTLoader, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDMLExporter, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHSQLPlayer, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHFIBMonitor, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHIBXMonitor, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHUserManager, Caption, TibSHXHelpForm);

  SHRegisterComponentForm(IibSHServerProps, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHServerLog, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHServerConfig, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHServerLicense, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDatabaseShutdown, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDatabaseOnline, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDatabaseBackup, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDatabaseRestore, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDatabaseStatistics, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDatabaseProps, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDatabaseValidation, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDatabaseSweep, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHDatabaseMend, Caption, TibSHXHelpForm);
  SHRegisterComponentForm(IibSHTransactionRecovery, Caption, TibSHXHelpForm);
end;

function TibSHXHelpFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result :=
    IsEqualGUID(AClassIID, IibSHDomain) or
    IsEqualGUID(AClassIID, IibSHTable) or
    IsEqualGUID(AClassIID, IibSHIndex) or
    IsEqualGUID(AClassIID, IibSHView) or
    IsEqualGUID(AClassIID, IibSHProcedure) or
    IsEqualGUID(AClassIID, IibSHTrigger) or
    IsEqualGUID(AClassIID, IibSHGenerator) or
    IsEqualGUID(AClassIID, IibSHException) or
    IsEqualGUID(AClassIID, IibSHFunction) or
    IsEqualGUID(AClassIID, IibSHFilter) or
    IsEqualGUID(AClassIID, IibSHRole) or

    IsEqualGUID(AClassIID, IibSHSQLEditor) or
    IsEqualGUID(AClassIID, IibSHDMLHistory) or
    IsEqualGUID(AClassIID, IibSHDDLHistory) or
    IsEqualGUID(AClassIID, IibSHDDLCommentator) or
    IsEqualGUID(AClassIID, IibSHDDLGrantor) or
    IsEqualGUID(AClassIID, IibSHDDLFinder) or
    IsEqualGUID(AClassIID, IibSHDDLExtractor) or
    IsEqualGUID(AClassIID, IibSHTXTLoader) or
    IsEqualGUID(AClassIID, IibSHDMLExporter) or
    IsEqualGUID(AClassIID, IibSHSQLPlayer) or
    IsEqualGUID(AClassIID, IibSHFIBMonitor) or
    IsEqualGUID(AClassIID, IibSHIBXMonitor) or
    IsEqualGUID(AClassIID, IibSHUserManager) or

    IsEqualGUID(AClassIID, IibSHServerProps) or
    IsEqualGUID(AClassIID, IibSHServerLog) or
    IsEqualGUID(AClassIID, IibSHServerConfig) or
    IsEqualGUID(AClassIID, IibSHServerLicense) or
    IsEqualGUID(AClassIID, IibSHDatabaseShutdown) or
    IsEqualGUID(AClassIID, IibSHDatabaseOnline) or
    IsEqualGUID(AClassIID, IibSHDatabaseBackup) or
    IsEqualGUID(AClassIID, IibSHDatabaseRestore) or
    IsEqualGUID(AClassIID, IibSHDatabaseStatistics) or
    IsEqualGUID(AClassIID, IibSHDatabaseProps) or
    IsEqualGUID(AClassIID, IibSHDatabaseValidation) or
    IsEqualGUID(AClassIID, IibSHDatabaseSweep) or
    IsEqualGUID(AClassIID, IibSHDatabaseMend) or
    IsEqualGUID(AClassIID, IibSHTransactionRecovery);
end;

procedure TibSHXHelpFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, Caption, opInsert);
end;

procedure TibSHXHelpFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHXHelpFormAction.EventUpdate(Sender: TObject);
begin
  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(Designer.CurrentComponentForm.CallString, Caption);
end;

{ TibSHXHelpToolbarAction_ }

constructor TibSHXHelpToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';
  
  if Self is TibSHXHelpToolbarAction_GB then Tag := 1;
  if Self is TibSHXHelpToolbarAction_RU then Tag := 2;

  case Tag of
    1: Caption := Format('%s', ['English']);
    2: Caption := Format('%s', ['Russian']);
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibSHXHelpToolbarAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result :=
    IsEqualGUID(AClassIID, IibSHDomain) or
    IsEqualGUID(AClassIID, IibSHTable) or
    IsEqualGUID(AClassIID, IibSHIndex) or
    IsEqualGUID(AClassIID, IibSHView) or
    IsEqualGUID(AClassIID, IibSHProcedure) or
    IsEqualGUID(AClassIID, IibSHTrigger) or
    IsEqualGUID(AClassIID, IibSHGenerator) or
    IsEqualGUID(AClassIID, IibSHException) or
    IsEqualGUID(AClassIID, IibSHFunction) or
    IsEqualGUID(AClassIID, IibSHFilter) or
    IsEqualGUID(AClassIID, IibSHRole) or

    IsEqualGUID(AClassIID, IibSHSQLEditor) or
    IsEqualGUID(AClassIID, IibSHDMLHistory) or
    IsEqualGUID(AClassIID, IibSHDDLHistory) or
    IsEqualGUID(AClassIID, IibSHDDLCommentator) or
    IsEqualGUID(AClassIID, IibSHDDLGrantor) or
    IsEqualGUID(AClassIID, IibSHDDLFinder) or
    IsEqualGUID(AClassIID, IibSHDDLExtractor) or
    IsEqualGUID(AClassIID, IibSHTXTLoader) or
    IsEqualGUID(AClassIID, IibSHDMLExporter) or
    IsEqualGUID(AClassIID, IibSHSQLPlayer) or
    IsEqualGUID(AClassIID, IibSHFIBMonitor) or
    IsEqualGUID(AClassIID, IibSHIBXMonitor) or
    IsEqualGUID(AClassIID, IibSHUserManager) or

    IsEqualGUID(AClassIID, IibSHServerProps) or
    IsEqualGUID(AClassIID, IibSHServerLog) or
    IsEqualGUID(AClassIID, IibSHServerConfig) or
    IsEqualGUID(AClassIID, IibSHServerLicense) or
    IsEqualGUID(AClassIID, IibSHDatabaseShutdown) or
    IsEqualGUID(AClassIID, IibSHDatabaseOnline) or
    IsEqualGUID(AClassIID, IibSHDatabaseBackup) or
    IsEqualGUID(AClassIID, IibSHDatabaseRestore) or
    IsEqualGUID(AClassIID, IibSHDatabaseStatistics) or
    IsEqualGUID(AClassIID, IibSHDatabaseProps) or
    IsEqualGUID(AClassIID, IibSHDatabaseValidation) or
    IsEqualGUID(AClassIID, IibSHDatabaseSweep) or
    IsEqualGUID(AClassIID, IibSHDatabaseMend) or
    IsEqualGUID(AClassIID, IibSHTransactionRecovery);
end;

procedure TibSHXHelpToolbarAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // GB
    1: ;
    // RU
    2: ;
  end;
end;

procedure TibSHXHelpToolbarAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHXHelpToolbarAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallXHelp) then
  begin
    Visible := True;
    case Tag of
      // Separator
      0: ;
      // GB
      1: ;
      // RU
      2: ;
    end;
  end else
    Visible := False;
end;

end.



