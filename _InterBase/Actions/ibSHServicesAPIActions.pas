unit ibSHServicesAPIActions;

interface

uses
  SysUtils, Classes, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHServicePaletteAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHServerLogPaletteAction = class(TibSHServicePaletteAction)
  end;
  TibSHServerPropsPaletteAction = class(TibSHServicePaletteAction)
  end;
  TibSHDatabasePropsPaletteAction = class(TibSHServicePaletteAction)
  end;
  TibSHDatabaseStatisticsPaletteAction = class(TibSHServicePaletteAction)
  end;
  TibSHDatabaseShutdownPaletteAction = class(TibSHServicePaletteAction)
  end;
  TibSHDatabaseOnlinePaletteAction = class(TibSHServicePaletteAction)
  end;
  TibSHDatabaseBackupPaletteAction = class(TibSHServicePaletteAction)
  end;
  TibSHDatabaseRestorePaletteAction = class(TibSHServicePaletteAction)
  end;
  TibSHDatabaseValidationPaletteAction = class(TibSHServicePaletteAction)
  end;
  TibSHDatabaseSweepPaletteAction = class(TibSHServicePaletteAction)
  end;
  TibSHDatabaseMendPaletteAction = class(TibSHServicePaletteAction)
  end;
  TibSHTransactionRecoveryPaletteAction = class(TibSHServicePaletteAction)
  end;

  TibSHServiceFormAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHServiceToolbarAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;


  TibSHServiceToolbarAction_Run = class(TibSHServiceToolbarAction_)
  end;
  TibSHServiceToolbarAction_Open = class(TibSHServiceToolbarAction_)
  end;
  TibSHServiceToolbarAction_Save = class(TibSHServiceToolbarAction_)
  end;

implementation

uses
  ibSHConsts,
  ibSHServicesAPIFrm;

{ TibSHServicePaletteAction }

constructor TibSHServicePaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Category := Format('%s', ['Services']);
  Caption := Format('%s', ['Service']);

  if Self is TibSHServerLogPaletteAction then Tag := 1;
  if Self is TibSHServerPropsPaletteAction then Tag := 2;
  if Self is TibSHDatabasePropsPaletteAction then Tag := 3;
  if Self is TibSHDatabaseStatisticsPaletteAction then Tag := 4;
  if Self is TibSHDatabaseShutdownPaletteAction then Tag := 5;
  if Self is TibSHDatabaseOnlinePaletteAction then Tag := 6;
  if Self is TibSHDatabaseBackupPaletteAction then Tag := 7;
  if Self is TibSHDatabaseRestorePaletteAction then Tag := 8;
  if Self is TibSHDatabaseValidationPaletteAction then Tag := 9;
  if Self is TibSHDatabaseSweepPaletteAction then Tag := 10;
  if Self is TibSHDatabaseMendPaletteAction then Tag := 11;
  if Self is TibSHTransactionRecoveryPaletteAction then Tag := 12;

  case Tag of
    1: Caption := Format('%s', ['Server Log']);
    2: Caption := Format('%s', ['Server Properties']);
    3: Caption := Format('%s', ['Database Properties']);
    4: Caption := Format('%s', ['Database Statistics']);
    5: Caption := Format('%s', ['Database Shutdown']);
    6: Caption := Format('%s', ['Database Online']);
    7: Caption := Format('%s', ['Database Backup']);
    8: Caption := Format('%s', ['Database Restore']);
    9: Caption := Format('%s', ['Database Validation']);
   10: Caption := Format('%s', ['Database Sweep']);
   11: Caption := Format('%s', ['Database Mend']);
   12: Caption := Format('%s', ['Transaction Recovery']);
  end;
end;

function TibSHServicePaletteAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHServicePaletteAction.EventExecute(Sender: TObject);
var
  vClassIID: TGUID;
begin
  case Tag of
    1: vClassIID := IibSHServerLog;
    2: vClassIID := IibSHServerProps;
    3: vClassIID := IibSHDatabaseProps;
    4: vClassIID := IibSHDatabaseStatistics;
    5: vClassIID := IibSHDatabaseShutdown;
    6: vClassIID := IibSHDatabaseOnline;
    7: vClassIID := IibSHDatabaseBackup;
    8: vClassIID := IibSHDatabaseRestore;
    9: vClassIID := IibSHDatabaseValidation;
   10: vClassIID := IibSHDatabaseSweep;
   11: vClassIID := IibSHDatabaseMend;
   12: vClassIID := IibSHTransactionRecovery;
  end;
  if Assigned(Designer.CurrentServer) then
    Designer.CreateComponent(Designer.CurrentServer.InstanceIID, vClassIID, EmptyStr);
end;

procedure TibSHServicePaletteAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHServicePaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentServer) and
             SupportComponent(Designer.CurrentServer.BranchIID);
end;

{ TibSHServiceFormAction }

constructor TibSHServiceFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;

  Caption := SCallServiceOutputs;
  SHRegisterComponentForm(IibSHDatabaseProps, Caption, TibSHServicesAPIForm);
  SHRegisterComponentForm(IibSHDatabaseStatistics, Caption, TibSHServicesAPIForm);
  SHRegisterComponentForm(IibSHServerProps, Caption, TibSHServicesAPIForm);
  SHRegisterComponentForm(IibSHServerLog, Caption, TibSHServicesAPIForm);
  SHRegisterComponentForm(IibSHDatabaseShutdown, Caption, TibSHServicesAPIForm);
  SHRegisterComponentForm(IibSHDatabaseOnline, Caption, TibSHServicesAPIForm);
  SHRegisterComponentForm(IibSHDatabaseBackup, Caption, TibSHServicesAPIForm);
  SHRegisterComponentForm(IibSHDatabaseRestore, Caption, TibSHServicesAPIForm);
  SHRegisterComponentForm(IibSHDatabaseValidation, Caption, TibSHServicesAPIForm);
  SHRegisterComponentForm(IibSHDatabaseSweep, Caption, TibSHServicesAPIForm);
  SHRegisterComponentForm(IibSHDatabaseMend, Caption, TibSHServicesAPIForm);
  SHRegisterComponentForm(IibSHTransactionRecovery, Caption, TibSHServicesAPIForm);
end;

function TibSHServiceFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result :=
    IsEqualGUID(AClassIID, IibSHServerLog) or
    IsEqualGUID(AClassIID, IibSHServerProps) or
    IsEqualGUID(AClassIID, IibSHDatabaseProps) or
    IsEqualGUID(AClassIID, IibSHDatabaseStatistics) or
    IsEqualGUID(AClassIID, IibSHDatabaseShutdown) or
    IsEqualGUID(AClassIID, IibSHDatabaseOnline) or
    IsEqualGUID(AClassIID, IibSHDatabaseBackup) or
    IsEqualGUID(AClassIID, IibSHDatabaseRestore) or
    IsEqualGUID(AClassIID, IibSHDatabaseValidation) or
    IsEqualGUID(AClassIID, IibSHDatabaseSweep) or
    IsEqualGUID(AClassIID, IibSHDatabaseMend) or
    IsEqualGUID(AClassIID, IibSHTransactionRecovery);
end;

procedure TibSHServiceFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, Caption, opInsert);
end;

procedure TibSHServiceFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHServiceFormAction.EventUpdate(Sender: TObject);
begin
  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(Designer.CurrentComponentForm.CallString, Caption);
end;

{ TibSHServiceToolbarAction_ }

constructor TibSHServiceToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  if Self is TibSHServiceToolbarAction_Run then Tag := 1;
  if Self is TibSHServiceToolbarAction_Open then Tag := 2;
  if Self is TibSHServiceToolbarAction_Save then Tag := 3;

  case Tag of
    1:
    begin
      Caption := Format('%s', ['Run']);
      ShortCut := TextToShortCut('Ctrl+Enter');
      SecondaryShortCuts.Add('F9');
    end;
    2:
    begin
      Caption := Format('%s', ['Open']);
      ShortCut := TextToShortCut('Ctrl+O');
    end;
    3:
    begin
      Caption := Format('%s', ['Save']);
      ShortCut := TextToShortCut('Ctrl+S');
    end;
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibSHServiceToolbarAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result :=
    IsEqualGUID(AClassIID, IibSHServerLog) or
    IsEqualGUID(AClassIID, IibSHServerProps) or
    IsEqualGUID(AClassIID, IibSHDatabaseProps) or
    IsEqualGUID(AClassIID, IibSHDatabaseStatistics) or
    IsEqualGUID(AClassIID, IibSHDatabaseShutdown) or
    IsEqualGUID(AClassIID, IibSHDatabaseOnline) or
    IsEqualGUID(AClassIID, IibSHDatabaseBackup) or
    IsEqualGUID(AClassIID, IibSHDatabaseRestore) or
    IsEqualGUID(AClassIID, IibSHDatabaseValidation) or
    IsEqualGUID(AClassIID, IibSHDatabaseSweep) or
    IsEqualGUID(AClassIID, IibSHDatabaseMend) or
    IsEqualGUID(AClassIID, IibSHTransactionRecovery);
end;

procedure TibSHServiceToolbarAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Open
    2: (Designer.CurrentComponentForm as ISHFileCommands).Open;
    // Save
    3: (Designer.CurrentComponentForm as ISHFileCommands).Save;
  end;
end;

procedure TibSHServiceToolbarAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHServiceToolbarAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallServiceOutputs) then
  begin

    case Tag of
      // Separator
      0: ;
      // Run
      1:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRun;
      end;
      // Open
      2:
      begin
        Visible :=
          Supports(Designer.CurrentComponent, IibSHDatabaseProps) or
          Supports(Designer.CurrentComponent, IibSHDatabaseStatistics) or
          Supports(Designer.CurrentComponent, IibSHDatabaseShutdown) or
          Supports(Designer.CurrentComponent, IibSHDatabaseOnline) or
          Supports(Designer.CurrentComponent, IibSHDatabaseBackup) or
          Supports(Designer.CurrentComponent, IibSHDatabaseRestore) or
          Supports(Designer.CurrentComponent, IibSHDatabaseValidation) or
          Supports(Designer.CurrentComponent, IibSHDatabaseSweep) or
          Supports(Designer.CurrentComponent, IibSHDatabaseMend);

        Enabled := (Designer.CurrentComponentForm as ISHFileCommands).CanOpen;
      end;
      // Save
      3:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHFileCommands).CanSave;
      end;
    end;
  end else
    Visible := False;
end;

end.
 
