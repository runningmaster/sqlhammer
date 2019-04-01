unit ibSHSQLMonitorActions;

interface

uses
  SysUtils, Classes, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHSQLMonitorPaletteAction = class(TSHAction)
  private
    function GetClassIID: TGUID;
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;

    property ClassIID: TGUID read GetClassIID;
  end;

  TibSHSQLMonitorPaletteAction_FIB = class(TibSHSQLMonitorPaletteAction)
  end;
  TibSHSQLMonitorPaletteAction_IBX = class(TibSHSQLMonitorPaletteAction)
  end;

  TibSHSQLMonitorFormAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;


  TibSHSQLMonitorToolbarAction_ = class(TSHAction)
  private
    FFIBTreeChecked: Boolean;
    FIBXTreeChecked: Boolean;
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;


  TibSHSQLMonitorToolbarAction_Run = class(TibSHSQLMonitorToolbarAction_)
  end;
  TibSHSQLMonitorToolbarAction_Pause = class(TibSHSQLMonitorToolbarAction_)
  end;
  TibSHSQLMonitorToolbarAction_Region = class(TibSHSQLMonitorToolbarAction_)
  end;
  TibSHSQLMonitorToolbarAction_2App = class(TibSHSQLMonitorToolbarAction_)
  end;

implementation

uses
  ibSHConsts,
  ibSHSQLMonitorFrm, ActnList;

{ TibSHSQLMonitorPaletteAction }

constructor TibSHSQLMonitorPaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Category := Format('%s', ['Tools']);
  Caption := Format('%s', ['SQL Monitor']);
  
  if IsEqualGUID(ClassIID, IibSHFIBMonitor) then Caption := Format('%s', ['FIB Monitor']) else
  if IsEqualGUID(ClassIID, IibSHIBXMonitor) then Caption := Format('%s', ['IBX Monitor']);

  if IsEqualGUID(ClassIID, IibSHFIBMonitor) then ShortCut := TextToShortCut('Shift+Ctrl+M');
  if IsEqualGUID(ClassIID, IibSHIBXMonitor) then ;
end;

function TibSHSQLMonitorPaletteAction.GetClassIID: TGUID;
begin
  Result := IUnknown;
  if Self is TibSHSQLMonitorPaletteAction_FIB then Result := IibSHFIBMonitor else
  if Self is TibSHSQLMonitorPaletteAction_IBX then Result := IibSHIBXMonitor;
end;

function TibSHSQLMonitorPaletteAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHSQLMonitorPaletteAction.EventExecute(Sender: TObject);
begin
//  Designer.CreateComponent(Designer.CurrentServer.InstanceIID, ClassIID, EmptyStr);
  Designer.CreateComponent(Designer.CurrentBranch.InstanceIID, ClassIID, EmptyStr);
end;

procedure TibSHSQLMonitorPaletteAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHSQLMonitorPaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentServer) and
             SupportComponent(Designer.CurrentServer.BranchIID);
end;

{ TibSHSQLMonitorFormAction }

constructor TibSHSQLMonitorFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;
  Caption := '-'; // separator

  SHRegisterComponentForm(IibSHFIBMonitor, SCallFIBTrace, TibSHSQLMonitorForm);
  SHRegisterComponentForm(IibSHIBXMonitor, SCallIBXTrace, TibSHSQLMonitorForm);
end;

function TibSHSQLMonitorFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHFIBMonitor) or IsEqualGUID(AClassIID, IibSHIBXMonitor);
end;

procedure TibSHSQLMonitorFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, Caption, opInsert);
end;

procedure TibSHSQLMonitorFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHSQLMonitorFormAction.EventUpdate(Sender: TObject);
begin
  if Supports(Designer.CurrentComponent, IibSHFIBMonitor) then Caption := SCallFIBTrace else
  if Supports(Designer.CurrentComponent, IibSHIBXMonitor) then Caption := SCallIBXTrace;
  
  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(Designer.CurrentComponentForm.CallString, Caption);
end;

{ TibSHSQLMonitorToolbarAction_ }

constructor TibSHSQLMonitorToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  if Self is TibSHSQLMonitorToolbarAction_Run then Tag := 1;
  if Self is TibSHSQLMonitorToolbarAction_Pause then Tag := 2;
  if Self is TibSHSQLMonitorToolbarAction_Region then Tag := 3;
  if Self is TibSHSQLMonitorToolbarAction_2App then Tag := 4;

  case Tag of
    1:
    begin
      Caption := Format('%s', ['Run']);
      ShortCut := TextToShortCut('Ctrl+Enter');
      SecondaryShortCuts.Add('F9');
    end;
    2:
    begin
      Caption := Format('%s', ['Stop']);
      ShortCut := TextToShortCut('Ctrl+BkSp');
    end;
    3: Caption := Format('%s', ['Tree']);
    4: Caption := Format('%s', ['Application']);
  end;

  if Tag <> 0 then Hint := Caption;

//  AutoCheck := Tag = 3; // Tree
end;

function TibSHSQLMonitorToolbarAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHFIBMonitor) or IsEqualGUID(AClassIID, IibSHIBXMonitor)
end;

procedure TibSHSQLMonitorToolbarAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Pause
    2: (Designer.CurrentComponentForm as ISHRunCommands).Pause;
    // Tree
    3: begin
         if AnsiSameText(Designer.CurrentComponentForm.CallString, SCallFIBTrace) then
           FFIBTreeChecked := not Checked;
         if AnsiSameText(Designer.CurrentComponentForm.CallString, SCallIBXTrace) then
           FIBXTreeChecked := not Checked;

         (Designer.CurrentComponentForm as ISHRunCommands).ShowHideRegion(not Checked);
       end;
    // Application
    4: (Designer.CurrentComponentForm as IibSHSQLMonitorForm).JumpToApplication;
  end;
end;

procedure TibSHSQLMonitorToolbarAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHSQLMonitorToolbarAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     (AnsiSameText(Designer.CurrentComponentForm.CallString, SCallFIBTrace) or
      AnsiSameText(Designer.CurrentComponentForm.CallString, SCallIBXTrace))then
  begin
    Visible := True;
    case Tag of
      // Separator
      0: ;
      // Run
      1: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRun;
      // Pause
      2: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanPause;
      // Tree
      3: begin
           if AnsiSameText(Designer.CurrentComponentForm.CallString, SCallFIBTrace) then
             Checked := FFIBTreeChecked;
           if AnsiSameText(Designer.CurrentComponentForm.CallString, SCallIBXTrace) then
             Checked := FIBXTreeChecked;
         (Designer.CurrentComponentForm as ISHRunCommands).ShowHideRegion(Checked);
//           EventExecute(Sender)
         end;
      // Application
      4: (Designer.CurrentComponentForm as IibSHSQLMonitorForm).CanJumpToApplication;
    end;
  end else
    Visible := False;
end;

end.


