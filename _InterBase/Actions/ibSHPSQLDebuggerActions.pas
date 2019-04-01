unit ibSHPSQLDebuggerActions;

interface

uses
  SysUtils, Classes, Menus,
  SHDesignIntf, ibSHDesignIntf, ibSHConsts;

type
  TibSHPSQLDebuggerPaletteAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHPSQLDebuggerFormAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHPSQLDebuggerToolbarAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHSendToPSQLDebuggerToolbarAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHPSQLDebuggerEditorAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  //Toolbar Actions
  TibSHPSQLDebuggerToolbarAction_TraceInto = class(TibSHPSQLDebuggerToolbarAction) end;
  TibSHPSQLDebuggerToolbarAction_StepOver = class(TibSHPSQLDebuggerToolbarAction) end;
  TibSHPSQLDebuggerToolbarAction_ToggleBreakpoint = class(TibSHPSQLDebuggerToolbarAction) end;
  TibSHPSQLDebuggerToolbarAction_Reset = class(TibSHPSQLDebuggerToolbarAction) end;
  TibSHPSQLDebuggerToolbarAction_SetParameters = class(TibSHPSQLDebuggerToolbarAction) end;
  TibSHPSQLDebuggerToolbarAction_Run = class(TibSHPSQLDebuggerToolbarAction) end;
  TibSHPSQLDebuggerToolbarAction_Pause = class(TibSHPSQLDebuggerToolbarAction) end;
  TibSHPSQLDebuggerToolbarAction_SkipStatement = class(TibSHPSQLDebuggerToolbarAction) end;
  TibSHPSQLDebuggerToolbarAction_RunToCursor = class(TibSHPSQLDebuggerToolbarAction) end;
  TibSHPSQLDebuggerToolbarAction_AddWatch = class(TibSHPSQLDebuggerToolbarAction) end;
  TibSHPSQLDebuggerToolbarAction_ModifyVarValues = class(TibSHPSQLDebuggerToolbarAction) end;

  //Editor Actions


implementation

uses ibSHPSQLDebuggerFrm, ActnList;

{ TibSHPSQLDebuggerPaletteAction }

constructor TibSHPSQLDebuggerPaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Category := Format('%s', ['Tools']);
  Caption := Format('%s', ['PSQL Debugger']);
//  ShortCut := TextToShortCut('');
end;

function TibSHPSQLDebuggerPaletteAction.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHPSQLDebuggerPaletteAction.EventExecute(Sender: TObject);
begin
  Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, IibSHPSQLDebugger, EmptyStr);
end;

procedure TibSHPSQLDebuggerPaletteAction.EventHint(var HintStr: String;
  var CanShow: Boolean);
begin
end;

procedure TibSHPSQLDebuggerPaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentDatabase) and
            (Designer.CurrentDatabase as ISHRegistration).Connected and
             SupportComponent(Designer.CurrentDatabase.BranchIID);
end;

{ TibSHPSQLDebuggerFormAction }

constructor TibSHPSQLDebuggerFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;

  Caption := SCallTracing;
  SHRegisterComponentForm(IibSHPSQLDebugger, Caption, TibSHPSQLDebuggerForm);
end;

function TibSHPSQLDebuggerFormAction.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHPSQLDebugger, AClassIID);
end;

procedure TibSHPSQLDebuggerFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, Caption, opInsert);
end;

procedure TibSHPSQLDebuggerFormAction.EventHint(var HintStr: String;
  var CanShow: Boolean);
begin
end;

procedure TibSHPSQLDebuggerFormAction.EventUpdate(Sender: TObject);
begin
  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(Designer.CurrentComponentForm.CallString, Caption);
end;

{ TibSHPSQLDebuggerToolbarAction }

constructor TibSHPSQLDebuggerToolbarAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  if Self is TibSHPSQLDebuggerToolbarAction_TraceInto then Tag := 1;
  if Self is TibSHPSQLDebuggerToolbarAction_StepOver then Tag := 2;
  if Self is TibSHPSQLDebuggerToolbarAction_ToggleBreakpoint then Tag := 3;
  if Self is TibSHPSQLDebuggerToolbarAction_Reset then Tag := 4;
  if Self is TibSHPSQLDebuggerToolbarAction_SetParameters then Tag := 5;
  if Self is TibSHPSQLDebuggerToolbarAction_Run then
  begin
   Tag := 6;
  end;
  if Self is TibSHPSQLDebuggerToolbarAction_Pause then
  begin
   Tag := 7;
  end;
  if Self is TibSHPSQLDebuggerToolbarAction_SkipStatement then Tag := 8;
  if Self is TibSHPSQLDebuggerToolbarAction_RunToCursor then Tag := 9;
  if Self is TibSHPSQLDebuggerToolbarAction_AddWatch then Tag := 10;
  if Self is TibSHPSQLDebuggerToolbarAction_ModifyVarValues then Tag := 11;




  case Tag of
    1:
    begin
      Caption := Format('%s', ['Trace Into']);
      ShortCut := TextToShortCut('F7');
    end;
    2:
    begin
      Caption := Format('%s', ['Step Over']);
      ShortCut := TextToShortCut('F8');
    end;
    3:
    begin
      Caption := Format('%s', ['Toggle Breakpoint']);
      ShortCut := TextToShortCut('F5');
    end;
    4:
    begin
      Caption := Format('%s', ['Reset Tracing']);
      ShortCut := TextToShortCut('Ctrl+F2');
    end;
    5:
    begin
      Caption := Format('%s', ['Set Input Parameters']);
      ShortCut := TextToShortCut('Ctrl+F4');
    end;
    6:
    begin
      Caption := Format('%s', ['Run from Current Position']);
      ShortCut := TextToShortCut('Ctrl+Enter');
      SecondaryShortCuts.Add('F9');
    end;
    7:
    begin
      Caption := Format('%s', ['Stop']);
      ShortCut := TextToShortCut('Ctrl+Bksp');
    end;
    8:
    begin
      Caption := Format('%s', ['Skip Statement']);
      ShortCut := TextToShortCut('Shift+F8');
    end;
    9:
    begin
      Caption := Format('%s', ['Run To Cursor']);
      ShortCut := TextToShortCut('F4');
    end;
    10:
    begin
      Caption := Format('%s', ['Add Watch at Cursor']);
      ShortCut := TextToShortCut('Ctrl+F5');
    end;
    11:
    begin
      Caption := Format('%s', ['Evaluate/Modify']);
      ShortCut := TextToShortCut('Ctrl+F7');
    end;
  end;

  if Tag <> 0 then Hint := Caption;

end;

function TibSHPSQLDebuggerToolbarAction.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHPSQLDebugger, AClassIID);
end;

procedure TibSHPSQLDebuggerToolbarAction.EventExecute(Sender: TObject);
begin
  with (Designer.CurrentComponentForm as IibSHPSQLDebuggerForm) do
  case Tag of
    // Trace Into
    1: TraceInto;
    // Step Over
    2: StepOver;
    // Toggle Breakpoint
    3: ToggleBreakpoint;
    // Reset Tracing
    4: Reset;
    // Set Input Parameters
    5: SetParameters;
    // Run from Current Position
    6: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Pause
    7: (Designer.CurrentComponentForm as ISHRunCommands).Pause;
    // Skip Statement
    8: SkipStatement;
    // Run To Cursor
    9: RunToCursor;
    // Add Watch at Cursor
    10:AddWatch;
    11:ModifyVarValues
  end;
end;

procedure TibSHPSQLDebuggerToolbarAction.EventHint(var HintStr: String;
  var CanShow: Boolean);
begin
end;

procedure TibSHPSQLDebuggerToolbarAction.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallTracing) then
  begin
    case Tag of
      // Separator
      0: ;
      // Trace Into
      1:
        begin
          Enabled := (Designer.CurrentComponentForm as IibSHPSQLDebuggerForm).CanTraceInto;
          Visible := Enabled;
        end;
      // Step Over
      2:
        begin
          Enabled := (Designer.CurrentComponentForm as IibSHPSQLDebuggerForm).CanStepOver;
          Visible := True
        end;
      // Toggle Breakpoint
      3:
        begin
          Enabled := (Designer.CurrentComponentForm as IibSHPSQLDebuggerForm).CanToggleBreakpoint;
          Visible := True
        end;
      // Reset Tracing
      4:
        begin
          Enabled := (Designer.CurrentComponentForm as IibSHPSQLDebuggerForm).CanReset;
          Visible := True
        end;
      // Set Input Parameters
      5:
        begin
          Enabled := (Designer.CurrentComponentForm as IibSHPSQLDebuggerForm).CanSetParameters;
          Visible := True
        end;
      // Run from Current Position
      6:
        begin
          Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRun;
          Visible := True;
        end;
      // Pause
      7:
        begin
          Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanPause;
          Visible := True;
        end;
      // Skip Statement
      8:
        begin
          Enabled := (Designer.CurrentComponentForm as IibSHPSQLDebuggerForm).CanSkipStatement;
          Visible := Enabled;
        end;
      // Run To Cursor
      9:
        begin
          Enabled := (Designer.CurrentComponentForm as IibSHPSQLDebuggerForm).CanRunToCursor;
          Visible := True
        end;
      // Add Watch at Cursor
      10:
        begin
          Enabled := (Designer.CurrentComponentForm as IibSHPSQLDebuggerForm).CanAddWatch;
          Visible := True
        end;
      11:
        begin
          Enabled := (Designer.CurrentComponentForm as IibSHPSQLDebuggerForm).GetCanModifyVarValues;
          Visible := True
        end;

    end;
  end else
  begin
    Enabled := False;
    Visible := Enabled;
    //DisableShortCut
  end;
end;

{ TibSHSendToPSQLDebuggerToolbarAction }

constructor TibSHSendToPSQLDebuggerToolbarAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  Caption := Format('%s', ['Debug Object']);
  ShortCut := TextToShortCut('F7');
  Hint := Caption;
end;

function TibSHSendToPSQLDebuggerToolbarAction.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHProcedure, AClassIID) or
            IsEqualGUID(IibSHTrigger, AClassIID){ or
            IsEqualGUID(IibSHSQLEditor, AClassIID)};
end;

procedure TibSHSendToPSQLDebuggerToolbarAction.EventExecute(
  Sender: TObject);
var
  vCurrentComponent: TSHComponent;
  vPSQLDebugger: IibSHPSQLDebugger;
begin
  vCurrentComponent := Designer.CurrentComponent;
  if Assigned(vCurrentComponent) then
  begin
    if Supports(Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, IibSHPSQLDebugger, EmptyStr),
         IibSHPSQLDebugger, vPSQLDebugger) then
      vPSQLDebugger.Debug(nil, vCurrentComponent.ClassIID, vCurrentComponent.Caption);
  end;
end;

procedure TibSHSendToPSQLDebuggerToolbarAction.EventHint(
  var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHSendToPSQLDebuggerToolbarAction.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     (AnsiSameText(Designer.CurrentComponentForm.CallString, SCallSourceDDL) or
      AnsiSameText(Designer.CurrentComponentForm.CallString, SCallAlterDDL)) then
  begin
    Enabled := True;
    Visible := Enabled;
  end else
  begin
    Enabled := False;
    Visible := Enabled;
    //DisableShortCut
  end;
end;

{ TibSHPSQLDebuggerEditorAction }

constructor TibSHPSQLDebuggerEditorAction.Create(AOwner: TComponent);
begin
  inherited;
end;

function TibSHPSQLDebuggerEditorAction.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHProcedure, AClassIID) or
            IsEqualGUID(IibSHTrigger, AClassIID){ or
            IsEqualGUID(IibSHSQLEditor, AClassIID)};
end;

procedure TibSHPSQLDebuggerEditorAction.EventExecute(Sender: TObject);
begin
  inherited;

end;

procedure TibSHPSQLDebuggerEditorAction.EventHint(var HintStr: String;
  var CanShow: Boolean);
begin
  inherited;

end;

procedure TibSHPSQLDebuggerEditorAction.EventUpdate(Sender: TObject);
begin
  inherited;

end;

end.


