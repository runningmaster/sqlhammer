unit ibSHDDLFinderActions;

interface

uses
  SysUtils, Classes, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHDDLFinderPaletteAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDDLFinderFormAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDDLFinderToolbarAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDDLFinderToolbarAction_Run = class(TibSHDDLFinderToolbarAction_)
  end;
  TibSHDDLFinderToolbarAction_Pause = class(TibSHDDLFinderToolbarAction_)
  end;
  TibSHDDLFinderToolbarAction_NextResult = class(TibSHDDLFinderToolbarAction_)
  end;
  TibSHDDLFinderToolbarAction_PrevResult = class(TibSHDDLFinderToolbarAction_)
  end;


implementation

uses
  ibSHConsts,
  ibSHDDLFinderFrm, ActnList;

{ TibSHDDLFinderPaletteAction }

constructor TibSHDDLFinderPaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Category := Format('%s', ['Tools']);
  Caption := Format('%s', ['DDL Finder']);

  ShortCut := TextToShortCut('Shift+Ctrl+F');
end;

function TibSHDDLFinderPaletteAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHDDLFinderPaletteAction.EventExecute(Sender: TObject);
begin
  Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, IibSHDDLFinder, EmptyStr);
end;

procedure TibSHDDLFinderPaletteAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLFinderPaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentDatabase) and
            (Designer.CurrentDatabase as ISHRegistration).Connected and
             SupportComponent(Designer.CurrentDatabase.BranchIID);
end;

{ TibSHDDLFinderFormAction }

constructor TibSHDDLFinderFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;

  Caption := SCallSearchResults;
  SHRegisterComponentForm(IibSHDDLFinder, Caption, TibSHDDLFinderForm);
end;

function TibSHDDLFinderFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDDLFinder);
end;

procedure TibSHDDLFinderFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, Caption, opInsert);
end;

procedure TibSHDDLFinderFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLFinderFormAction.EventUpdate(Sender: TObject);
begin
  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(Designer.CurrentComponentForm.CallString, Caption);
end;

{ TibSHDDLFinderToolbarAction_ }

constructor TibSHDDLFinderToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  if Self is TibSHDDLFinderToolbarAction_Run then Tag := 1;
  if Self is TibSHDDLFinderToolbarAction_Pause then Tag := 2;
  if Self is TibSHDDLFinderToolbarAction_NextResult then Tag := 3;
  if Self is TibSHDDLFinderToolbarAction_PrevResult then Tag := 4;

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
    3: Caption := Format('%s', ['Next Result']);
    4: Caption := Format('%s', ['Previous Result']);
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibSHDDLFinderToolbarAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDDLFinder);
end;

procedure TibSHDDLFinderToolbarAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Pause
    2: (Designer.CurrentComponentForm as ISHRunCommands).Pause;
    // Next Result
    3: (Designer.CurrentComponentForm as IibSHDDLFinderForm).ShowNextResult;
    // Previous Result
    4: (Designer.CurrentComponentForm as IibSHDDLFinderForm).ShowPrevResult;
  end;
end;

procedure TibSHDDLFinderToolbarAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLFinderToolbarAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallSearchResults) then
  begin
    Visible := True;
    case Tag of
      // Separator
      0: ;
      // Run
      1: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRun;
      // Pause
      2: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanPause;
      // Next Result
      3: Enabled := (Designer.CurrentComponentForm as IibSHDDLFinderForm).CanShowNextResult;
      // Previous Result
      4: Enabled := (Designer.CurrentComponentForm as IibSHDDLFinderForm).CanShowPrevResult;
    end;
  end else
    Visible := False;
end;

end.
 
 
 
