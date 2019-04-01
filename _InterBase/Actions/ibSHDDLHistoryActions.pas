unit ibSHDDLHistoryActions;

interface

uses
  SysUtils, Classes, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHDDLHistoryPaletteAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDDLHistoryFormAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDDLHistoryToolbarAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDDLHistoryEditorAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDDLHistoryToolbarAction_Run = class(TibSHDDLHistoryToolbarAction_)
  end;
  TibSHDDLHistoryToolbarAction_Pause = class(TibSHDDLHistoryToolbarAction_)
  end;
  TibSHDDLHistoryToolbarAction_Region = class(TibSHDDLHistoryToolbarAction_)
  end;
  TibSHDDLHistoryToolbarAction_Refresh = class(TibSHDDLHistoryToolbarAction_)
  end;
  TibSHDDLHistoryToolbarAction_Save = class(TibSHDDLHistoryToolbarAction_)
  end;

  TibSHDDLHistoryEditorAction_SendToSQLEditor = class(TibSHDDLHistoryEditorAction)
  end;
  TibSHDDLHistoryEditorAction_ShowDDLHistory = class(TibSHDDLHistoryEditorAction)
  end;

implementation

uses
  ibSHConsts,
  ibSHDDLHistoryFrm;

{ TibSHDDLHistoryPaletteAction }

constructor TibSHDDLHistoryPaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Category := Format('%s', ['Tools']);
  Caption := Format('%s', ['DDL History']);
  ShortCut := TextToShortCut('Shift+Ctrl+F11');
end;

function TibSHDDLHistoryPaletteAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHDDLHistoryPaletteAction.EventExecute(Sender: TObject);
begin
  Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, IibSHDDLHistory, EmptyStr);
end;

procedure TibSHDDLHistoryPaletteAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLHistoryPaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentDatabase) and
//            (Designer.CurrentDatabase as ISHRegistration).Connected and
             SupportComponent(Designer.CurrentDatabase.BranchIID);
end;

{ TibSHDDLHistoryFormAction }

constructor TibSHDDLHistoryFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;

  Caption := SCallDDLStatements;
  SHRegisterComponentForm(IibSHDDLHistory, Caption, TibSHDDLHistoryForm);
end;

function TibSHDDLHistoryFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDDLHistory);
end;

procedure TibSHDDLHistoryFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, Caption, opInsert);
end;

procedure TibSHDDLHistoryFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLHistoryFormAction.EventUpdate(Sender: TObject);
begin
  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(Designer.CurrentComponentForm.CallString, Caption);
end;

{ TibSHDDLHistoryToolbarAction_ }

constructor TibSHDDLHistoryToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  if Self is TibSHDDLHistoryToolbarAction_Run then Tag := 1;
  if Self is TibSHDDLHistoryToolbarAction_Pause then Tag := 2;
  if Self is TibSHDDLHistoryToolbarAction_Region then Tag := 3;
  if Self is TibSHDDLHistoryToolbarAction_Refresh then Tag := 4;
  if Self is TibSHDDLHistoryToolbarAction_Save then Tag := 5;

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
    4:
    begin
      Caption := Format('%s', ['Refresh']);
      ShortCut := TextToShortCut('F5');
    end;
    5:
    begin
      Caption := Format('%s', ['Save']);
      ShortCut := TextToShortCut('Ctrl+S');
    end;
  end;

  if Tag <> 0 then Hint := Caption;

  AutoCheck := Tag = 3; // Tree
end;

function TibSHDDLHistoryToolbarAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDDLHistory);
end;

procedure TibSHDDLHistoryToolbarAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Pause
    2: (Designer.CurrentComponentForm as ISHRunCommands).Pause;
    // Tree
    3: (Designer.CurrentComponentForm as ISHRunCommands).ShowHideRegion(Checked);
    // Refresh
    4: (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
    // Save
    5: (Designer.CurrentComponentForm as ISHFileCommands).Save;
  end;
end;

procedure TibSHDDLHistoryToolbarAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLHistoryToolbarAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallDDLStatements) then
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
      3: Checked := (Designer.CurrentComponentForm as IibSHDDLHistoryForm).RegionVisible;
      // Refresh
      4: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRefresh;
      // Save
      5: Enabled := (Designer.CurrentComponentForm as ISHFileCommands).CanSave;
    end;
  end else
    Visible := False;
end;

{ TibSHDDLHistoryEditorAction }

constructor TibSHDDLHistoryEditorAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallEditor;

  if Self is TibSHDDLHistoryEditorAction_SendToSQLEditor then Tag := 1;
  if Self is TibSHDDLHistoryEditorAction_ShowDDLHistory then Tag := 2;

  case Tag of
    0: Caption := '-'; // separator
    1: Caption := SSendToSQLEditor;
    2: Caption := SShowDDLHistory;
  end;
end;

function TibSHDDLHistoryEditorAction.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  case Tag of
    1: Result := IsEqualGUID(AClassIID, IibSHDDLHistory);
    2: Result := IsEqualGUID(AClassIID, IibSHSQLEditor) or IsEqualGUID(AClassIID, IibSHSQLPlayer);
  else
    Result := False;
  end;
end;

procedure TibSHDDLHistoryEditorAction.EventExecute(Sender: TObject);
var
  vDDLHistoryForm: IibSHDDLHistoryForm;
  SQLPlayer: IibSHSQLPlayer;
  vComponent: TSHComponent;
  vCurrentComponent: TSHComponent;
begin
  if Assigned(Designer.CurrentComponentForm) then
    case Tag of
      1:
      if Supports(Designer.CurrentComponentForm, IibSHDDLHistoryForm, vDDLHistoryForm) then
        vDDLHistoryForm.SendToSQLEditor;
      2:
        begin
          if (Assigned(Designer.CurrentComponent) and
           Supports(Designer.CurrentComponent, IibSHSQLPlayer, SQLPlayer) and
           Assigned(SQLPlayer.BTCLDatabase) and
           SQLPlayer.BTCLDatabase.Connected) then
          begin
            vCurrentComponent := Designer.CurrentComponent;
            vComponent := Designer.CreateComponent(SQLPlayer.BTCLDatabase.InstanceIID, IibSHDDLHistory, '');
            Designer.JumpTo(vCurrentComponent.InstanceIID, IibSHDDLHistory, vComponent.Caption);
          end
          else
          if Assigned(Designer.CurrentDatabase) then
          begin
            if Assigned(Designer.CurrentComponent) then
            begin
              Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, IibSHDDLHistory, '');
//              vCurrentComponent := Designer.CurrentComponent;
//              vComponent := Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, IibSHDDLHistory, '');
//              Designer.JumpTo(vCurrentComponent.InstanceIID, IibSHDDLHistory, vComponent.Caption);
            end;  
          end;
        end;
    end;
end;

procedure TibSHDDLHistoryEditorAction.EventHint(var HintStr: String;
  var CanShow: Boolean);
begin
end;

procedure TibSHDDLHistoryEditorAction.EventUpdate(Sender: TObject);
var
  vDDLHistoryForm: IibSHDDLHistoryForm;
  SQLPlayer: IibSHSQLPlayer;
begin
  if Assigned(Designer.CurrentComponentForm) then
  case Tag of
    1:
    if Supports(Designer.CurrentComponentForm, IibSHDDLHistoryForm, vDDLHistoryForm) then
      Enabled := vDDLHistoryForm.GetCanSendToSQLEditor;
    2: Enabled := Assigned(Designer.CurrentDatabase) or
       {Enabled :=} (Assigned(Designer.CurrentComponent) and
       Supports(Designer.CurrentComponent, IibSHSQLPlayer, SQLPlayer) and
       Assigned(SQLPlayer.BTCLDatabase) and
       SQLPlayer.BTCLDatabase.Connected);
    else
      Enabled := False;
  end;
end;

end.



