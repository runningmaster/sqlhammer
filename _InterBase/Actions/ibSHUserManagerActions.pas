unit ibSHUserManagerActions;

interface

uses
  SysUtils, Classes, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHUserManagerPaletteAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHUserManagerFormAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHUserManagerToolbarAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHUserManagerToolbarAction_Create = class(TibSHUserManagerToolbarAction_)
  end;
  TibSHUserManagerToolbarAction_Alter = class(TibSHUserManagerToolbarAction_)
  end;
  TibSHUserManagerToolbarAction_Drop = class(TibSHUserManagerToolbarAction_)
  end;
  TibSHUserManagerToolbarAction_Refresh = class(TibSHUserManagerToolbarAction_)
  end;

implementation

uses
  ibSHConsts,
  ibSHUserManagerFrm,
  ibSHUserFrm, ActnList;

{ TibSHUserManagerPaletteAction }

constructor TibSHUserManagerPaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Category := Format('%s', ['Services']);
  Caption := Format('%s', ['User Manager']);
  ShortCut := TextToShortCut('Shift+Ctrl+F2');  
end;

function TibSHUserManagerPaletteAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHUserManagerPaletteAction.EventExecute(Sender: TObject);
begin
  Designer.CreateComponent(Designer.CurrentServer.InstanceIID, IibSHUserManager, EmptyStr);
end;

procedure TibSHUserManagerPaletteAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHUserManagerPaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentServer) and
             SupportComponent(Designer.CurrentServer.BranchIID);
end;

{ TibSHUserManagerFormAction }

constructor TibSHUserManagerFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;

  Caption := SCallUsers;
  SHRegisterComponentForm(IibSHUserManager, Caption, TibSHUserManagerForm);
  SHRegisterComponentForm(IibSHDummy, SCallUser, TibSHUserForm);
end;

function TibSHUserManagerFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHUserManager);
end;

procedure TibSHUserManagerFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, Caption, opInsert);
end;

procedure TibSHUserManagerFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHUserManagerFormAction.EventUpdate(Sender: TObject);
begin
  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(Designer.CurrentComponentForm.CallString, Caption);
end;

{ TibSHUserManagerToolbarAction_ }

constructor TibSHUserManagerToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  if Self is TibSHUserManagerToolbarAction_Create then Tag := 1;
  if Self is TibSHUserManagerToolbarAction_Alter then Tag := 2;
  if Self is TibSHUserManagerToolbarAction_Drop then Tag := 3;
  if Self is TibSHUserManagerToolbarAction_Refresh then Tag := 4;

  case Tag of
    1:
    begin
      Caption := Format('%s', ['Create']);
      ShortCut := TextToShortCut('Shift+F4');
    end;
    2:
    begin
      Caption := Format('%s', ['Alter']);
      ShortCut := TextToShortCut('F4');
    end;
    3:
    begin
      Caption := Format('%s', ['Drop']);
      ShortCut := TextToShortCut('Shift+Alt+Del');
    end;
    4:
    begin
      Caption := Format('%s', ['Refresh']);
      ShortCut := TextToShortCut('F5');
    end;
  end;


  if Tag <> 0 then Hint := Caption;
end;

function TibSHUserManagerToolbarAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHUserManager);
end;

procedure TibSHUserManagerToolbarAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Create
    1: (Designer.CurrentComponentForm as ISHRunCommands).Create;
    // Alter
    2: (Designer.CurrentComponentForm as ISHRunCommands).Alter;
    // Drop
    3: (Designer.CurrentComponentForm as ISHRunCommands).Drop;
    // Refresh
    4: (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
  end;
end;

procedure TibSHUserManagerToolbarAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHUserManagerToolbarAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallUsers) then
  begin
    Visible := True;
    case Tag of
      // Separator
      0: ;
      // Create
      1: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanCreate;
      // Alter
      2: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanAlter;
      // Drop
      3: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanDrop;
      // Refresh
      4: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRefresh;
    end;
  end else
    Visible := False;
end;

end.
 
