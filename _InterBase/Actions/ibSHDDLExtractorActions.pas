unit ibSHDDLExtractorActions;

interface

uses
  SysUtils, Classes, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHDDLExtractorPaletteAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDDLExtractorFormAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDDLExtractorToolbarAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDDLExtractorToolbarAction_Run = class(TibSHDDLExtractorToolbarAction_)
  end;
  TibSHDDLExtractorToolbarAction_Pause = class(TibSHDDLExtractorToolbarAction_)
  end;
  TibSHDDLExtractorToolbarAction_SaveAs = class(TibSHDDLExtractorToolbarAction_)
  end;

  TibSHDDLExtractorToolbarAction_Region = class(TibSHDDLExtractorToolbarAction_)
  end;

implementation

uses
  ibSHConsts,
  ibSHDDLExtractorFrm;

{ TibSHDDLExtractorPaletteAction }

constructor TibSHDDLExtractorPaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Category := Format('%s', ['Tools']);
  Caption := Format('%s', ['DDL Extractor']);
  ShortCut := TextToShortCut('Shift+Ctrl+E');  
end;

function TibSHDDLExtractorPaletteAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHDDLExtractorPaletteAction.EventExecute(Sender: TObject);
begin
  Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, IibSHDDLExtractor, EmptyStr);
end;

procedure TibSHDDLExtractorPaletteAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLExtractorPaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentDatabase) and
            (Designer.CurrentDatabase as ISHRegistration).Connected and
            SupportComponent(Designer.CurrentDatabase.BranchIID);
end;

{ TibSHDDLExtractorFormAction }

constructor TibSHDDLExtractorFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;

  Caption := SCallTargetScript;
  SHRegisterComponentForm(IibSHDDLExtractor, Caption, TibSHDDLExtractorForm);
end;

function TibSHDDLExtractorFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDDLExtractor);
end;

procedure TibSHDDLExtractorFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, Caption, opInsert);
end;

procedure TibSHDDLExtractorFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLExtractorFormAction.EventUpdate(Sender: TObject);
begin
  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(Designer.CurrentComponentForm.CallString, Caption);
end;

{ TibSHDDLExtractorToolbarAction_ }

constructor TibSHDDLExtractorToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';
  
  if Self is TibSHDDLExtractorToolbarAction_Run then Tag := 1;
  if Self is TibSHDDLExtractorToolbarAction_Pause then Tag := 2;
  if Self is TibSHDDLExtractorToolbarAction_SaveAs then Tag := 3;
  if Self is TibSHDDLExtractorToolbarAction_Region then Tag := 4;

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
      Caption := Format('%s', ['Save As']);
      ShortCut := TextToShortCut('Ctrl+S');
    end;
    4:
    begin
      Caption := Format('%s', ['Tree']);
      ShortCut := TextToShortCut('Ctrl+T');
    end;
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibSHDDLExtractorToolbarAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDDLExtractor);
end;

procedure TibSHDDLExtractorToolbarAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Pause
    2: (Designer.CurrentComponentForm as ISHRunCommands).Pause;
    // Save As
    3: (Designer.CurrentComponentForm as ISHFileCommands).SaveAs;
    4:
    begin
      Checked:=Not Checked;
     (Designer.CurrentComponentForm as ISHRunCommands).ShowHideRegion(Checked);
    end;
  end;
end;

procedure TibSHDDLExtractorToolbarAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLExtractorToolbarAction_.EventUpdate(Sender: TObject);
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
      // Save As
      3: Enabled := (Designer.CurrentComponentForm as ISHFileCommands).CanSaveAs;
      4: begin
          Enabled :=  True;
          Checked:=(Designer.CurrentComponentForm as iBTRegionForms).RegionVisible
         end;
    end;
  end else
    Visible := False;
end;

end.


