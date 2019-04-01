unit ibSHDDLGrantorActions;

interface

uses
  SysUtils, Classes, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHDDLGrantorPaletteAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDDLGrantorFormAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDDLGrantorToolbarAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;


  TibSHDDLGrantorToolbarAction_Run = class(TibSHDDLGrantorToolbarAction_)
  end;
  TibSHDDLGrantorToolbarAction_Pause = class(TibSHDDLGrantorToolbarAction_)
  end;
  TibSHDDLGrantorToolbarAction_Refresh = class(TibSHDDLGrantorToolbarAction_)
  end;

implementation

uses
  ibSHConsts,
  ibSHDDLGrantorFrm;

{ TibSHDDLGrantorPaletteAction }

constructor TibSHDDLGrantorPaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Category := Format('%s', ['Tools']);
  Caption := Format('%s', ['DDL Grantor']);
  ShortCut := TextToShortCut('Shift+Ctrl+G');  
end;

function TibSHDDLGrantorPaletteAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHDDLGrantorPaletteAction.EventExecute(Sender: TObject);
begin
  Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, IibSHDDLGrantor, EmptyStr);
end;

procedure TibSHDDLGrantorPaletteAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLGrantorPaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentDatabase) and
            (Designer.CurrentDatabase as ISHRegistration).Connected and
             SupportComponent(Designer.CurrentDatabase.BranchIID);
end;


{ TibSHDDLGrantorFormAction }

constructor TibSHDDLGrantorFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;

  Caption := SCallPrivileges;
  SHRegisterComponentForm(IibSHDDLGrantor, Caption, TibSHDDLGrantorForm);
end;

function TibSHDDLGrantorFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDDLGrantor);
end;

procedure TibSHDDLGrantorFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, Caption, opInsert);
end;

procedure TibSHDDLGrantorFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLGrantorFormAction.EventUpdate(Sender: TObject);
begin
  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(Designer.CurrentComponentForm.CallString, Caption);
end;

{ TibSHDDLGrantorToolbarAction_ }

constructor TibSHDDLGrantorToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;

  if Self is TibSHDDLGrantorToolbarAction_Run then Tag := 1;
  if Self is TibSHDDLGrantorToolbarAction_Pause then Tag := 2;
  if Self is TibSHDDLGrantorToolbarAction_Refresh then Tag := 3;

  case Tag of
    0: Caption := '-';
    1:
    begin
      Caption := Format('%s', ['Run']);
      ShortCut := TextToShortCut('Ctrl+Enter');
    end;
    2:
    begin
      Caption := Format('%s', ['Stop']);
      ShortCut := TextToShortCut('Ctrl+BkSp');
    end;
    3:
    begin
      Caption := Format('%s', ['Refresh']);
      ShortCut := TextToShortCut('F5');
    end;
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibSHDDLGrantorToolbarAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDDLGrantor);
end;

procedure TibSHDDLGrantorToolbarAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Pause
    2: (Designer.CurrentComponentForm as ISHRunCommands).Pause;
    // Refresh
    3: (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
  end;
end;

procedure TibSHDDLGrantorToolbarAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLGrantorToolbarAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallPrivileges) then
  begin
    Visible := True;
    case Tag of
      // Separator
      0: ;
      // Run
      1: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRun;
      // Pause
      2: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanPause;
      // Refresh
      3: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRefresh;
    end;
  end else
    Visible := False;
end;

end.
 
