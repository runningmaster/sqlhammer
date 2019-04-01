unit ibSHDMLHistoryActions;

interface

uses
  SysUtils, Classes, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHDMLHistoryPaletteAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDMLHistoryFormAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDMLHistoryToolbarAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDMLHistoryEditorAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;


  TibSHDMLHistoryToolbarAction_Run = class(TibSHDMLHistoryToolbarAction_)
  end;
  TibSHDMLHistoryToolbarAction_Pause = class(TibSHDMLHistoryToolbarAction_)
  end;
  TibSHDMLHistoryToolbarAction_Region = class(TibSHDMLHistoryToolbarAction_)
  end;
  TibSHDMLHistoryToolbarAction_Refresh = class(TibSHDMLHistoryToolbarAction_)
  end;
//  TibSHDMLHistoryToolbarAction_Save = class(TibSHDMLHistoryToolbarAction_)
//  end;
  // Editors
  TibSHDMLHistoryEditorAction_SendToSQLEditor = class(TibSHDMLHistoryEditorAction)
  end;
  TibSHDMLHistoryEditorAction_ShowDMLHistory = class(TibSHDMLHistoryEditorAction)
  end;

implementation

uses
  ibSHConsts,
  ibSHDMLHistoryFrm, ActnList;

{ TibSHDMLHistoryPaletteAction }

constructor TibSHDMLHistoryPaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Category := Format('%s', ['Tools']);
  Caption := Format('%s', ['DML History']);
  ShortCut := TextToShortCut('Shift+Ctrl+F10');  
end;

function TibSHDMLHistoryPaletteAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHDMLHistoryPaletteAction.EventExecute(Sender: TObject);
begin
  Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, IibSHDMLHistory, EmptyStr);
end;

procedure TibSHDMLHistoryPaletteAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDMLHistoryPaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentDatabase) and
//            (Designer.CurrentDatabase as ISHRegistration).Connected and
             SupportComponent(Designer.CurrentDatabase.BranchIID);
end;

{ TibSHDMLHistoryFormAction }

constructor TibSHDMLHistoryFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;

  Caption := SCallDMLStatements;
  SHRegisterComponentForm(IibSHDMLHistory, Caption, TibSHDMLHistoryForm);
end;

function TibSHDMLHistoryFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDMLHistory);
end;

procedure TibSHDMLHistoryFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, Caption, opInsert);
end;

procedure TibSHDMLHistoryFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDMLHistoryFormAction.EventUpdate(Sender: TObject);
begin
  FDefault := Assigned(Designer.CurrentComponentForm) and
//              Supports(Designer.CurrentComponentForm, IibSHDMLHistoryForm);
              AnsiSameText(Designer.CurrentComponentForm.CallString, Caption);
end;

{ TibSHDMLHistoryToolbarAction_ }

constructor TibSHDMLHistoryToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  if Self is TibSHDMLHistoryToolbarAction_Run then Tag := 1;
  if Self is TibSHDMLHistoryToolbarAction_Pause then Tag := 2;
  if Self is TibSHDMLHistoryToolbarAction_Region then Tag := 3;
//  if Self is TibSHDMLHistoryToolbarAction_Refresh then Tag := 4;
//  if Self is TibSHDMLHistoryToolbarAction_Save then Tag := 5;

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
//    4: Caption := Format('%s', ['Refresh']);
//    5: Caption := Format('%s', ['Save']);
  end;

  if Tag <> 0 then Hint := Caption;

  AutoCheck := Tag = 3; // Tree
end;

function TibSHDMLHistoryToolbarAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDMLHistory);
end;

procedure TibSHDMLHistoryToolbarAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Pause
    2: (Designer.CurrentComponentForm as ISHRunCommands).Pause;
    // Tree
    3: (Designer.CurrentComponentForm as ISHRunCommands).ShowHideRegion(Checked);
    // Refresh
//    4: (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
    // Save
//    5: (Designer.CurrentComponentForm as ISHFileCommands).Save;
  end;
end;

procedure TibSHDMLHistoryToolbarAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDMLHistoryToolbarAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallDMLStatements) and
     Supports(Designer.CurrentComponentForm, IibSHDMLHistoryForm) then
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
      3: Checked := (Designer.CurrentComponentForm as IibSHDMLHistoryForm).RegionVisible;
      // Refsreh
//      4: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRefresh;
      // Save
//      5: Enabled := (Designer.CurrentComponentForm as ISHFileCommands).CanSave;
    end;
  end else
    Visible := False;
end;

{ TibSHDMLHistoryEditorAction }

constructor TibSHDMLHistoryEditorAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallEditor;

  if Self is TibSHDMLHistoryEditorAction_SendToSQLEditor then Tag := 1;
  if Self is TibSHDMLHistoryEditorAction_ShowDMLHistory then Tag := 2;


  case Tag of
    0: Caption := '-'; // separator
    1: Caption := SSendToSQLEditor;
    2: Caption := SShowDMLHistory;
  end;
end;

function TibSHDMLHistoryEditorAction.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  case Tag of
    1: Result := IsEqualGUID(AClassIID, IibSHDMLHistory);
    2: Result := IsEqualGUID(AClassIID, IibSHSQLEditor);
  else
    Result := False;
  end;
end;

procedure TibSHDMLHistoryEditorAction.EventExecute(Sender: TObject);
var
  vDMLHistoryForm: IibSHDMLHistoryForm;
  vBTCLDatabase: IibSHDatabase;
begin
  if Assigned(Designer.CurrentComponentForm) then
  case Tag of
    1:
    if Supports(Designer.CurrentComponentForm, IibSHDMLHistoryForm, vDMLHistoryForm) then
      vDMLHistoryForm.SendToSQLEditor;
    2:
      begin
        if (Assigned(Designer.CurrentComponent) and
          Supports(Designer.CurrentComponent, IibSHDatabase, vBTCLDatabase) and
          vBTCLDatabase.Connected) then
        begin
          Designer.JumpTo(Designer.CurrentComponent.InstanceIID, IibSHDMLHistory, '')
        end;  
      end;
  end;
end;

procedure TibSHDMLHistoryEditorAction.EventHint(var HintStr: String;
  var CanShow: Boolean);
begin
end;

procedure TibSHDMLHistoryEditorAction.EventUpdate(Sender: TObject);
var
  vDMLHistoryForm: IibSHDMLHistoryForm;
  vBTCLDatabase: IibSHDatabase;
begin
  if Assigned(Designer.CurrentComponentForm) then
  case Tag of
    1:
      if Supports(Designer.CurrentComponentForm, IibSHDMLHistoryForm, vDMLHistoryForm) then
        Enabled := vDMLHistoryForm.GetCanSendToSQLEditor;
    2:
      Enabled := (Assigned(Designer.CurrentComponent) and
        Supports(Designer.CurrentComponent, IibSHDatabase, vBTCLDatabase) and
        vBTCLDatabase.Connected)
    else
      Enabled := False;
  end;
end;

end.

