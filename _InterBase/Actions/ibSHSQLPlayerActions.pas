unit ibSHSQLPlayerActions;

interface

uses
  SysUtils, Classes, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHSQLPlayerPaletteAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHSQLPlayerFormAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHSQLPlayerToolbarAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHSQLPlayerEditorAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHSQLPlayerToolbarAction_Run = class(TibSHSQLPlayerToolbarAction_)
  end;
  TibSHSQLPlayerToolbarAction_Pause = class(TibSHSQLPlayerToolbarAction_)
  end;
  TibSHSQLPlayerToolbarAction_Region = class(TibSHSQLPlayerToolbarAction_)
  end;
  TibSHSQLPlayerToolbarAction_Refresh = class(TibSHSQLPlayerToolbarAction_)
  end;
  TibSHSQLPlayerToolbarAction_Open = class(TibSHSQLPlayerToolbarAction_)
  end;
  TibSHSQLPlayerToolbarAction_Save = class(TibSHSQLPlayerToolbarAction_)
  end;
  TibSHSQLPlayerToolbarAction_SaveAs = class(TibSHSQLPlayerToolbarAction_)
  end;
  TibSHSQLPlayerToolbarAction_RunCurrent = class(TibSHSQLPlayerToolbarAction_)
  end;
  TibSHSQLPlayerToolbarAction_RunFromCurrent = class(TibSHSQLPlayerToolbarAction_)
  end;
  TibSHSQLPlayerToolbarAction_RunFromFile = class(TibSHSQLPlayerToolbarAction_)
  end;
  TibSHSQLPlayerEditorAction_SendToSQLPlayer = class(TibSHSQLPlayerEditorAction)
  end;

  TibSHSQLPlayerEditorAction_CheckAll = class(TibSHSQLPlayerToolbarAction_)
  end;
  TibSHSQLPlayerEditorAction_UnCheckAll = class(TibSHSQLPlayerToolbarAction_)
  end;

implementation

uses
  ibSHConsts,
  ibSHSQLPlayerFrm, ActnList;

{ TibSHSQLPlayerPaletteAction }

constructor TibSHSQLPlayerPaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Category := Format('%s', ['Tools']);
  Caption := Format('%s', ['SQL Player']);
  ShortCut := TextToShortCut('Shift+Ctrl+F12');  
end;

function TibSHSQLPlayerPaletteAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHSQLPlayerPaletteAction.EventExecute(Sender: TObject);
begin
//  Designer.CreateComponent(Designer.CurrentBranch.InstanceIID, IibSHSQLPlayer, EmptyStr);
  if Assigned(Designer.CurrentDatabase) and Designer.CurrentDatabaseInUse then
    Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, IibSHSQLPlayer, EmptyStr)
  else
    if Assigned(Designer.CurrentServer) then
      Designer.CreateComponent(Designer.CurrentServer.InstanceIID, IibSHSQLPlayer, EmptyStr)
    else
      Designer.CreateComponent(Designer.CurrentBranch.InstanceIID, IibSHSQLPlayer, EmptyStr);
end;

procedure TibSHSQLPlayerPaletteAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHSQLPlayerPaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentServer) and
             SupportComponent(Designer.CurrentServer.BranchIID);
end;

{ TibSHSQLPlayerFormAction }

constructor TibSHSQLPlayerFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;

  Caption := SCallSQLStatements;
  SHRegisterComponentForm(IibSHSQLPlayer, Caption, TibSHSQLPlayerForm);
end;

function TibSHSQLPlayerFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHSQLPlayer);
end;

procedure TibSHSQLPlayerFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, Caption, opInsert);
end;

procedure TibSHSQLPlayerFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHSQLPlayerFormAction.EventUpdate(Sender: TObject);
begin
  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(Designer.CurrentComponentForm.CallString, Caption);
end;

{ TibSHSQLPlayerToolbarAction_ }

constructor TibSHSQLPlayerToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  if Self is TibSHSQLPlayerToolbarAction_Run then Tag := 1;
  if Self is TibSHSQLPlayerToolbarAction_Pause then Tag := 2;
  if Self is TibSHSQLPlayerToolbarAction_Region then Tag := 3;
  if Self is TibSHSQLPlayerToolbarAction_Refresh then Tag := 4;
  if Self is TibSHSQLPlayerToolbarAction_Open then Tag := 5;
  if Self is TibSHSQLPlayerToolbarAction_Save then Tag := 6;
  if Self is TibSHSQLPlayerToolbarAction_SaveAs then Tag := 7;
  if Self is TibSHSQLPlayerToolbarAction_RunFromFile then Tag := 8;
  if Self is TibSHSQLPlayerToolbarAction_RunCurrent then Tag := 9;
  if Self is TibSHSQLPlayerToolbarAction_RunFromCurrent then Tag := 10;
  if Self is TibSHSQLPlayerEditorAction_CheckAll then Tag := 11;
  if Self is TibSHSQLPlayerEditorAction_UnCheckAll then Tag := 12;


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
    3: begin
        Caption := Format('%s', ['Tree']);
        ShortCut := TextToShortCut('Ctrl+T');
       end;
    4:
    begin
      Caption := Format('%s', ['Refresh']);
      ShortCut := TextToShortCut('F5');
    end;
    5:
    begin
      Caption := Format('%s', ['Open']);
      ShortCut := TextToShortCut('Ctrl+O');
    end;
    6:
    begin
      Caption := Format('%s', ['Save']);
      ShortCut := TextToShortCut('Ctrl+S');
    end;
    7: Caption := Format('%s', ['Save As']);
    8: Caption := Format('%s', ['Run From File']);
    9:
    begin
      Caption := Format('%s', ['Run Current Statement']);
      ShortCut := TextToShortCut('F8');
    end;
    10:
    begin
      Caption := Format('%s', ['Run From Current Statement']);
      ShortCut := TextToShortCut('F9');
    end;
    11: Caption := Format('%s', ['Check All']);
    12: Caption := Format('%s', ['UnCheck All']);
  end;

  if Tag <> 0 then Hint := Caption;

  AutoCheck := Tag = 3; // Tree  
end;

function TibSHSQLPlayerToolbarAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHSQLPlayer);
end;

procedure TibSHSQLPlayerToolbarAction_.EventExecute(Sender: TObject);
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
    // Open
    5: (Designer.CurrentComponentForm as ISHFileCommands).Open;
    // Save
    6: (Designer.CurrentComponentForm as ISHFileCommands).Save;
    // Save As
    7: (Designer.CurrentComponentForm as ISHFileCommands).SaveAs;
    // RunFromFile
    8: (Designer.CurrentComponentForm as IibSHSQLPlayerForm).RunFromFile;
    9: (Designer.CurrentComponentForm as IibSHSQLPlayerForm).RunCurrent;
    10: (Designer.CurrentComponentForm as IibSHSQLPlayerForm).RunFromCurrent;
    11: (Designer.CurrentComponentForm as IibSHSQLPlayerForm).CheckAll;
    12: (Designer.CurrentComponentForm as IibSHSQLPlayerForm).UnCheckAll;
  end;
end;

procedure TibSHSQLPlayerToolbarAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHSQLPlayerToolbarAction_.EventUpdate(Sender: TObject);
var
  vPlayerComponent: IibSHSQLPlayer;
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallSQLStatements) and
     Assigned(Designer.CurrentComponent) and
     Supports(Designer.CurrentComponent, IibSHSQLPlayer, vPlayerComponent) then
  begin
    case Tag of
      // Separator
      0:
        begin
          Visible := True;
          Enabled := True;
        end;
      // Run
      1:
        begin
          Visible :=  AnsiSameText(vPlayerComponent.Mode, PlayerModes[0]);
          Enabled := Visible and (Designer.CurrentComponentForm as ISHRunCommands).CanRun;
        end;
      // Pause
      2:
        begin
          Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanPause;
          Visible := True;
        end;
      // Tree
      3:
        begin
          Checked := (Designer.CurrentComponentForm as IibSHSQLPlayerForm).RegionVisible;
          Visible := True;
          Enabled := True;
        end;
      // Refresh
      4:
        begin
          Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRefresh;
          Visible := True;
        end;
      // Open
      5:
        begin
          Enabled := (Designer.CurrentComponentForm as ISHFileCommands).CanOpen;
          Visible := True;
        end;
      // Save
      6:
        begin
          Enabled := (Designer.CurrentComponentForm as ISHFileCommands).CanSave;
          Visible := True;
        end;
      // Save As
      7:
        begin
          Enabled := (Designer.CurrentComponentForm as ISHFileCommands).CanSaveAs;
          Visible := True;
        end;
      // RunFromFile
      8:
        begin
          Visible :=  AnsiSameText(vPlayerComponent.Mode, PlayerModes[0]);
          Enabled := Visible and (Designer.CurrentComponentForm as IibSHSQLPlayerForm).CanRunFromFile;
        end;
      9:
        begin
          Visible :=  AnsiSameText(vPlayerComponent.Mode, PlayerModes[1]);
          Enabled := Visible and (Designer.CurrentComponentForm as IibSHSQLPlayerForm).CanRunCurrent;
        end;
      10:
        begin
          Visible :=  AnsiSameText(vPlayerComponent.Mode, PlayerModes[1]);
          Enabled := Visible and (Designer.CurrentComponentForm as IibSHSQLPlayerForm).CanRunFromCurrent;
        end;
      //CheckAll
      11:
        begin
          Visible :=  AnsiSameText(vPlayerComponent.Mode, PlayerModes[1]) and
            (not (Designer.CurrentComponentForm as ISHRunCommands).CanPause);
          Enabled := Visible;
        end;
      //UnCheckAll
      12:
        begin
          Visible :=  AnsiSameText(vPlayerComponent.Mode, PlayerModes[1]) and
            (not (Designer.CurrentComponentForm as ISHRunCommands).CanPause);
          Enabled := Visible;
        end;
    end;
  end else
  begin
    Visible := False;
    Enabled := False;
  end;
end;

{ TibSHSQLPlayerEditorAction }

constructor TibSHSQLPlayerEditorAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallEditor;

  if Self is TibSHSQLPlayerEditorAction_SendToSQLPlayer then Tag := 1;

  case Tag of
    0: Caption := '-'; // separator
    1: Caption := SSendToSQLPlayer;
  end;
end;

function TibSHSQLPlayerEditorAction.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  case Tag of
    1: Result := IsEqualGUID(AClassIID, IibSHDDLHistory);
  else
    Result := False;
  end;
end;

procedure TibSHSQLPlayerEditorAction.EventExecute(Sender: TObject);
var
  vDDLHistoryForm: IibSHDDLHistoryForm;
begin
  if Assigned(Designer.CurrentComponentForm) then
    case Tag of
      1:
      if Supports(Designer.CurrentComponentForm, IibSHDDLHistoryForm, vDDLHistoryForm) then
        vDDLHistoryForm.SendToSQLPlayer;
    end;
end;

procedure TibSHSQLPlayerEditorAction.EventHint(var HintStr: String;
  var CanShow: Boolean);
begin
end;

procedure TibSHSQLPlayerEditorAction.EventUpdate(Sender: TObject);
var
  vDDLHistoryForm: IibSHDDLHistoryForm;
begin
  if Assigned(Designer.CurrentComponentForm) then
    case Tag of
      1:
      if Supports(Designer.CurrentComponentForm, IibSHDDLHistoryForm, vDDLHistoryForm) then
        Enabled := vDDLHistoryForm.GetCanSendToSQLPlayer;
    end;
end;

end.




