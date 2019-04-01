unit ibSHTXTLoaderActions;

interface

uses
  SysUtils, Classes, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHTXTLoaderPaletteAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHTXTLoaderFormAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHTXTLoaderToolbarAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHTXTLoaderToolbarAction_Run = class(TibSHTXTLoaderToolbarAction_)
  end;
  TibSHTXTLoaderToolbarAction_Pause = class(TibSHTXTLoaderToolbarAction_)
  end;
  TibSHTXTLoaderToolbarAction_Commit = class(TibSHTXTLoaderToolbarAction_)
  end;
  TibSHTXTLoaderToolbarAction_Rollback = class(TibSHTXTLoaderToolbarAction_)
  end;
  TibSHTXTLoaderToolbarAction_Open = class(TibSHTXTLoaderToolbarAction_)
  end;

implementation

uses
  ibSHConsts,
  ibSHTXTLoaderFrm;

{ TibSHTXTLoaderPaletteAction }

constructor TibSHTXTLoaderPaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Category := Format('%s', ['Tools']);
  Caption := Format('%s', [SCallTXTLoader]);
  ShortCut := TextToShortCut(EmptyStr);
end;

function TibSHTXTLoaderPaletteAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHTXTLoaderPaletteAction.EventExecute(Sender: TObject);
begin
  Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, IibSHTXTLoader, EmptyStr);
end;

procedure TibSHTXTLoaderPaletteAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHTXTLoaderPaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentDatabase) and
            (Designer.CurrentDatabase as ISHRegistration).Connected and
            SupportComponent(Designer.CurrentDatabase.BranchIID);
end;

{ TibSHTXTLoaderFormAction }

constructor TibSHTXTLoaderFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;

  Caption := SCallDMLStatement;
  SHRegisterComponentForm(IibSHTXTLoader, Caption, TibSHTXTLoaderForm);
end;

function TibSHTXTLoaderFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHTXTLoader);
end;

procedure TibSHTXTLoaderFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, Caption, opInsert);
end;

procedure TibSHTXTLoaderFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHTXTLoaderFormAction.EventUpdate(Sender: TObject);
begin
  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(Designer.CurrentComponentForm.CallString, Caption);
end;

{ TibSHTXTLoaderToolbarAction_ }

constructor TibSHTXTLoaderToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';
  
  if Self is TibSHTXTLoaderToolbarAction_Run then Tag := 1;
  if Self is TibSHTXTLoaderToolbarAction_Pause then Tag := 2;
  if Self is TibSHTXTLoaderToolbarAction_Commit then Tag := 3;
  if Self is TibSHTXTLoaderToolbarAction_Rollback then Tag := 4;
  if Self is TibSHTXTLoaderToolbarAction_Open then Tag := 5;

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
    3:
    begin
      Caption := Format('%s', ['Commit']);
      ShortCut := TextToShortCut('Shift+Ctrl+C');
    end;
    4:
    begin
      Caption := Format('%s', ['Rollback']);
      ShortCut := TextToShortCut('Shift+Ctrl+R');
    end;
    5:
    begin
      Caption := Format('%s', ['Open']);
      ShortCut := TextToShortCut('Ctrl+O');
    end;
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibSHTXTLoaderToolbarAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHTXTLoader);
end;

procedure TibSHTXTLoaderToolbarAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Pause
    2: (Designer.CurrentComponentForm as ISHRunCommands).Pause;
    // Commit
    3: (Designer.CurrentComponentForm as ISHRunCommands).Commit;
    // Rollback
    4: (Designer.CurrentComponentForm as ISHRunCommands).Rollback;
    // Open
    5: (Designer.CurrentComponentForm as ISHFileCommands).Open;
  end;
end;

procedure TibSHTXTLoaderToolbarAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHTXTLoaderToolbarAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallDMLStatement) and
     Supports(Designer.CurrentComponent, IibSHTXTLoader) then
  begin
    case Tag of
      // Separator
      0:
      begin
        Visible := True;
      end;
      // Run
      1:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRun;
      end;
      // Pause
      2:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanPause;
      end;
      // Commit
      3:
      begin
        Visible := not (Designer.CurrentComponent as IibSHTXTLoader).CommitEachLine;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanCommit and
                   (Designer.CurrentComponentForm as ISHRunCommands).CanRun;
      end;
      // Rollback
      4:
      begin
        Visible := not (Designer.CurrentComponent as IibSHTXTLoader).CommitEachLine;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRollback and
                   (Designer.CurrentComponentForm as ISHRunCommands).CanRun;
      end;
      // Open
      5:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHFileCommands).CanOpen;
      end;
    end;
  end else
    Visible := False;
end;

end.
