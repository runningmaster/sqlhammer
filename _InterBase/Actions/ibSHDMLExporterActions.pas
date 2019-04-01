unit ibSHDMLExporterActions;

interface

uses
  SysUtils, Classes, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHDMLExporterPaletteAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDMLExporterFormAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDMLExporterToolbarAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDMLExporterEditorAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDMLExporterToolbarAction_Run = class(TibSHDMLExporterToolbarAction_)
  end;
  TibSHDMLExporterToolbarAction_Pause = class(TibSHDMLExporterToolbarAction_)
  end;
  TibSHDMLExporterToolbarAction_Region = class(TibSHDMLExporterToolbarAction_)
  end;
  TibSHDMLExporterToolbarAction_Refresh = class(TibSHDMLExporterToolbarAction_)
  end;
  TibSHDMLExporterToolbarAction_SaveAs = class(TibSHDMLExporterToolbarAction_)
  end;
  TibSHDMLExporterToolbarAction_CheckAll = class(TibSHDMLExporterToolbarAction_)
  end;
  TibSHDMLExporterToolbarAction_UnCheckAll = class(TibSHDMLExporterToolbarAction_)
  end;
  TibSHDMLExporterToolbarAction_MoveDown = class(TibSHDMLExporterToolbarAction_)
  end;
  TibSHDMLExporterToolbarAction_MoveUp = class(TibSHDMLExporterToolbarAction_)
  end;

  TibSHDMLExporterEditorAction_ExportIntoScript = class(TibSHDMLExporterEditorAction)
  end;

implementation

uses
  ibSHConsts,
  ibSHDMLExporterFrm;

{ TibSHDMLExporterPaletteAction }

constructor TibSHDMLExporterPaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Category := Format('%s', ['Tools']);
  Caption := Format('%s', ['DML Exporter']);
  ShortCut := TextToShortCut('Shift+Ctrl+D');  
end;

function TibSHDMLExporterPaletteAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHDMLExporterPaletteAction.EventExecute(Sender: TObject);
begin
  Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, IibSHDMLExporter, EmptyStr);
end;

procedure TibSHDMLExporterPaletteAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDMLExporterPaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentDatabase) and
            (Designer.CurrentDatabase as ISHRegistration).Connected and
             SupportComponent(Designer.CurrentDatabase.BranchIID);
end;

{ TibSHDMLExporterFormAction }

constructor TibSHDMLExporterFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;

  Caption := SCallTargetScript;
  SHRegisterComponentForm(IibSHDMLExporter, Caption, TibSHDMLExporterForm);
end;

function TibSHDMLExporterFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDMLExporter);
end;

procedure TibSHDMLExporterFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, Caption, opInsert);
end;

procedure TibSHDMLExporterFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDMLExporterFormAction.EventUpdate(Sender: TObject);
begin
  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(Designer.CurrentComponentForm.CallString, Caption);
end;

{ TibSHDMLExporterToolbarAction_ }

constructor TibSHDMLExporterToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  if Self is TibSHDMLExporterToolbarAction_Run then Tag := 1;
  if Self is TibSHDMLExporterToolbarAction_Pause then Tag := 2;
  if Self is TibSHDMLExporterToolbarAction_Region then Tag := 3;
  if Self is TibSHDMLExporterToolbarAction_Refresh then Tag := 4;
  if Self is TibSHDMLExporterToolbarAction_SaveAs then Tag := 5;
  if Self is TibSHDMLExporterToolbarAction_CheckAll then Tag := 6;
  if Self is TibSHDMLExporterToolbarAction_UnCheckAll then Tag := 7;
  if Self is TibSHDMLExporterToolbarAction_MoveDown then Tag := 8;
  if Self is TibSHDMLExporterToolbarAction_MoveUp then Tag := 9;

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
    3: Caption := Format('%s', ['Editor']);
    4:
    begin
      Caption := Format('%s', ['Refresh']);
      ShortCut := TextToShortCut('F5');
    end;
    5:
    begin
      Caption := Format('%s', ['Save As']);
      ShortCut := TextToShortCut('Ctrl+S');
    end;
    6: Caption := Format('%s', ['Check All']);
    7: Caption := Format('%s', ['UnCheck All']);
    8:
    begin
      Caption := Format('%s', ['Move Down']);
      ShortCut := TextToShortCut('Alt+Down');
    end;
    9:
    begin
      Caption := Format('%s', ['Move Up']);
      ShortCut := TextToShortCut('Alt+Up');
    end;
  end;

  if Tag <> 0 then Hint := Caption;

  AutoCheck := Tag = 3; // Editor
end;

function TibSHDMLExporterToolbarAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDMLExporter);
end;

procedure TibSHDMLExporterToolbarAction_.EventExecute(Sender: TObject);
begin
  if Supports(Designer.CurrentComponentForm, ISHRunCommands) and
     Supports(Designer.CurrentComponentForm, ISHFileCommands) and
     Supports(Designer.CurrentComponentForm, IibSHDMLExporterForm) then
    case Tag of
      // Run
      1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
      // Pause
      2: (Designer.CurrentComponentForm as ISHRunCommands).Pause;
      // Editor
      3: (Designer.CurrentComponentForm as ISHRunCommands).ShowHideRegion(Checked);
      // Refresh
      4: (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
      // Save As
      5: (Designer.CurrentComponentForm as ISHFileCommands).SaveAs;
      6: (Designer.CurrentComponentForm as IibSHDMLExporterForm).CheckAll;
      7: (Designer.CurrentComponentForm as IibSHDMLExporterForm).UnCheckAll;
      8: (Designer.CurrentComponentForm as IibSHDMLExporterForm).MoveDown;
      9: (Designer.CurrentComponentForm as IibSHDMLExporterForm).MoveUp;
    end;
end;

procedure TibSHDMLExporterToolbarAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDMLExporterToolbarAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallTargetScript) then
  begin
    Visible := True;
    case Tag of
      // Separator
      0: ;
      // Run
      1: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRun;
      // Pause
      2: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanPause;
      // Editor
      3:;
      // Refresh
      4: Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRefresh;
      // Save As
      5: Enabled := (Designer.CurrentComponentForm as ISHFileCommands).CanSaveAs;
      6, 7: Enabled := True;
      8: Enabled := (Designer.CurrentComponentForm as IibSHDMLExporterForm).CanMoveDown;
      9: Enabled := (Designer.CurrentComponentForm as IibSHDMLExporterForm).CanMoveUp;
    end;
  end else
    Visible := False;
end;

{ TibSHDMLExporterEditorAction }

constructor TibSHDMLExporterEditorAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallEditor;

  if Self is TibSHDMLExporterEditorAction_ExportIntoScript then Tag := 1;

  case Tag of
    0: Caption := '-'; // separator
    1: Caption := SExportIntoScript;
  end;
end;

function TibSHDMLExporterEditorAction.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  case Tag of
    1: Result := IsEqualGUID(AClassIID, IibSHTable) or
      IsEqualGUID(AClassIID, IibSHSQLEditor);
  else
    Result := False;
  end;
end;

procedure TibSHDMLExporterEditorAction.EventExecute(Sender: TObject);
var
  vDMLExporterFactory: IibSHDMLExporterFactory;
  vData: IibSHData;
  vInstanceIID: TGUID;
  vCaption: string;
begin
  if Assigned(Designer.CurrentComponentForm) then
    case Tag of
      1:
      begin
        if Supports(Designer.CurrentComponent, IibSHData, vData) and
          Supports(Designer.GetDemon(IibSHDMLExporterFactory), IibSHDMLExporterFactory, vDMLExporterFactory) then
        begin
          vInstanceIID := Designer.CurrentComponent.InstanceIID;
          with vDMLExporterFactory do
          begin
            if vData.Dataset.Active then
            begin
              Mode := DMLExporterModes[1];
              Data := vData;
              vCaption := Designer.CreateComponent(Designer.CurrentComponent.OwnerIID, IibSHDMLExporter, EmptyStr).Caption;
              Designer.JumpTo(vInstanceIID, IibSHDMLExporter, vCaption);
              Mode := EmptyStr;
              Data := nil;
            end
            else
            begin
              //Только таблица
              Mode := DMLExporterModes[0];
              TablesForDumping.Clear;
              TablesForDumping.Add(Designer.CurrentComponent.Caption);
              vCaption := Designer.CreateComponent(Designer.CurrentComponent.OwnerIID, IibSHDMLExporter, EmptyStr).Caption;
              Designer.JumpTo(vInstanceIID, IibSHDMLExporter, vCaption);
              Mode := EmptyStr;
              TablesForDumping.Clear;
            end;
            vDMLExporterFactory := nil;
          end;
        end;
      end;
    end;
end;

procedure TibSHDMLExporterEditorAction.EventHint(var HintStr: String;
  var CanShow: Boolean);
begin
end;

procedure TibSHDMLExporterEditorAction.EventUpdate(Sender: TObject);
var
  vData: IibSHData;
begin
  if Assigned(Designer.CurrentComponentForm) then
  case Tag of
    1:
    begin
      Enabled := Assigned(Designer.CurrentComponent) and
        (Supports(Designer.CurrentComponent, IibSHTable) or
        (
         Supports(Designer.CurrentComponent, IibSHSQLEditor) and
         Supports(Designer.CurrentComponent, IibSHData, vData) and vData.Dataset.Active)
        );
      Visible := Supports(Designer.CurrentComponent, IibSHSQLEditor) or
                 (Supports(Designer.CurrentComponent, ISHDBComponent) and
                  ((Designer.CurrentComponent as ISHDBComponent).State <> csCreate)
                 );
    end;
    else
      Enabled := False;
  end;
end;

end.









