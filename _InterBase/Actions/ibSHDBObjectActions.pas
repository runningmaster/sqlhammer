unit ibSHDBObjectActions;

interface

uses
  SysUtils, Classes, Controls, StrUtils, DesignIntf, TypInfo, Dialogs, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHDDLObjectPaletteAction = class(TSHAction)
  private
    function GetClassIID: TGUID;
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;

    property ClassIID: TGUID read GetClassIID;
  end;

  TibSHDDLObjectFormAction = class(TSHAction)
  private
    function GetCallString: string;
    function GetComponentFormClass: TSHComponentFormClass;

    procedure RegisterComponentForm(const AClassIID: TGUID);
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;

    property CallString: string read GetCallString;
    property ComponentFormClass: TSHComponentFormClass read GetComponentFormClass;
  end;

  TibSHDDLObjectEditorAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  // Component Palette

  TibSHDomainPaletteAction = class(TibSHDDLObjectPaletteAction)
  end;
  TibSHTablePaletteAction = class(TibSHDDLObjectPaletteAction)
  end;
  TibSHIndexPaletteAction = class(TibSHDDLObjectPaletteAction)
  end;
  TibSHViewPaletteAction = class(TibSHDDLObjectPaletteAction)
  end;
  TibSHProcedurePaletteAction = class(TibSHDDLObjectPaletteAction)
  end;
  TibSHTriggerPaletteAction = class(TibSHDDLObjectPaletteAction)
  end;
  TibSHGeneratorPaletteAction = class(TibSHDDLObjectPaletteAction)
  end;
  TibSHExceptionPaletteAction = class(TibSHDDLObjectPaletteAction)
  end;
  TibSHFunctionPaletteAction = class(TibSHDDLObjectPaletteAction)
  end;
  TibSHFilterPaletteAction = class(TibSHDDLObjectPaletteAction)
  end;
  TibSHRolePaletteAction = class(TibSHDDLObjectPaletteAction)
  end;

  // Forms

  TibSHDDLObjectFormAction_CreateDDL = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_SourceDDL = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_AlterDDL = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_DropDDL = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_RecreateDDL = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_Description = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_Dependencies = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_Fields = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_Constraints = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_Indices = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_Triggers = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_Data = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_DataBLOB = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_DataForm = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_FieldDescr = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_FieldOrder = class(TibSHDDLObjectFormAction)
  end;
  TibSHDDLObjectFormAction_ParamDescr = class(TibSHDDLObjectFormAction)
  end;

  // Editors

  TibSHDDLObjectEditorAction_FindInScheme = class(TibSHDDLObjectEditorAction)
  end;
  TibSHDDLObjectEditorAction_CreateNew = class(TibSHDDLObjectEditorAction)
  end;
  TibSHDDLObjectEditorAction_RecordCount = class(TibSHDDLObjectEditorAction)
  end;
  TibSHDDLObjectEditorAction_ChangeCount = class(TibSHDDLObjectEditorAction)
  end;
  TibSHDDLObjectEditorAction_SetSatatistics = class(TibSHDDLObjectEditorAction)
  end;

implementation

uses
  ibSHConsts,
  ibSHDDLFrm, ibSHDataGridFrm, ibSHDataBlobFrm, ibSHDataVCLFrm,
  {ibSHDDLGeneratorFrm,} ibSHFieldsFrm, ibSHConstraintsFrm,
  ibSHIndicesFrm, ibSHTriggersFrm, ibSHDependenciesFrm,
  ibSHDescriptionFrm, ibSHFieldOrderFrm, ibSHFieldDescrFrm,
  ibSHDDLGenerator, ibSHDDLCompiler, ibSHDependencies, ibSHQuery;

{ TibSHDDLObjectPaletteAction }

constructor TibSHDDLObjectPaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Caption := '-'; // separator
  Category := Format('%s', ['Meta']);

  if IsEqualGUID(ClassIID, IibSHDomain) then Caption := Format('%s', ['Domain']) else
  if IsEqualGUID(ClassIID, IibSHTable) then Caption := Format('%s', ['Table']) else
  if IsEqualGUID(ClassIID, IibSHIndex) then Caption := Format('%s', ['Index']) else
  if IsEqualGUID(ClassIID, IibSHView) then Caption := Format('%s', ['View']) else
  if IsEqualGUID(ClassIID, IibSHProcedure) then Caption := Format('%s', ['Procedure']) else
  if IsEqualGUID(ClassIID, IibSHTrigger) then Caption := Format('%s', ['Trigger']) else
  if IsEqualGUID(ClassIID, IibSHGenerator) then Caption := Format('%s', ['Generator']) else
  if IsEqualGUID(ClassIID, IibSHException) then Caption := Format('%s', ['Exception']) else
  if IsEqualGUID(ClassIID, IibSHFunction) then Caption := Format('%s', ['Function']) else
  if IsEqualGUID(ClassIID, IibSHFilter) then Caption := Format('%s', ['Filter']) else
  if IsEqualGUID(ClassIID, IibSHRole) then Caption := Format('%s', ['Role']);


  if IsEqualGUID(ClassIID, IibSHDomain) then ShortCut := TextToShortCut('Shift+Alt+D');
  if IsEqualGUID(ClassIID, IibSHTable) then ShortCut := TextToShortCut('Shift+Alt+T');
  if IsEqualGUID(ClassIID, IibSHIndex) then ShortCut := TextToShortCut('Shift+Alt+I');
  if IsEqualGUID(ClassIID, IibSHView) then ShortCut := TextToShortCut('Shift+Alt+V');
  if IsEqualGUID(ClassIID, IibSHProcedure) then ShortCut := TextToShortCut('Shift+Alt+P');
  if IsEqualGUID(ClassIID, IibSHTrigger) then ShortCut := TextToShortCut('Shift+Alt+M');
  if IsEqualGUID(ClassIID, IibSHGenerator) then ShortCut := TextToShortCut('Shift+Alt+G');
  if IsEqualGUID(ClassIID, IibSHException) then ShortCut := TextToShortCut('Shift+Alt+E');
  if IsEqualGUID(ClassIID, IibSHFunction) then ShortCut := TextToShortCut('Shift+Alt+F');
  if IsEqualGUID(ClassIID, IibSHFilter) then ShortCut := TextToShortCut('Shift+Alt+L');
  if IsEqualGUID(ClassIID, IibSHRole) then ShortCut := TextToShortCut('Shift+Alt+R');
end;

function TibSHDDLObjectPaletteAction.GetClassIID: TGUID;
begin
  Result := IUnknown;
  if Self is TibSHDomainPaletteAction then Result := IibSHDomain else
  if Self is TibSHTablePaletteAction then Result := IibSHTable else
  if Self is TibSHIndexPaletteAction then Result := IibSHIndex else
  if Self is TibSHViewPaletteAction then Result := IibSHView else
  if Self is TibSHProcedurePaletteAction then Result := IibSHProcedure else
  if Self is TibSHTriggerPaletteAction then Result := IibSHTrigger else
  if Self is TibSHGeneratorPaletteAction then Result := IibSHGenerator else
  if Self is TibSHExceptionPaletteAction then Result := IibSHException else
  if Self is TibSHFunctionPaletteAction then Result := IibSHFunction else
  if Self is TibSHFilterPaletteAction then Result := IibSHFilter else
  if Self is TibSHRolePaletteAction then Result := IibSHRole;
end;

function TibSHDDLObjectPaletteAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHDDLObjectPaletteAction.EventExecute(Sender: TObject);
//var
//  vComponent: TSHComponent;
begin
  Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, ClassIID, EmptyStr);
//  vComponent := Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, ClassIID, EmptyStr);
//  if Assigned(vComponent) then
//    Designer.ShowModal(vComponent, Format('DDL_WIZARD.%s', [AnsiUpperCase(vComponent.Association)]));
end;

procedure TibSHDDLObjectPaletteAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLObjectPaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentDatabase) and
             (Designer.CurrentDatabase as ISHRegistration).Connected and
             SupportComponent(Designer.CurrentDatabase.BranchIID);
end;

{ TibSHDDLObjectFormAction }

constructor TibSHDDLObjectFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;
  Caption := '-'; // separator

  Caption := CallString;

  RegisterComponentForm(IibSHDomain);
  RegisterComponentForm(IibSHTable);
  RegisterComponentForm(IibSHConstraint);
  RegisterComponentForm(IibSHIndex);
  RegisterComponentForm(IibSHView);
  RegisterComponentForm(IibSHProcedure);
  RegisterComponentForm(IibSHTrigger);
  RegisterComponentForm(IibSHGenerator);
  RegisterComponentForm(IibSHException);
  RegisterComponentForm(IibSHFunction);
  RegisterComponentForm(IibSHFilter);
  RegisterComponentForm(IibSHRole);
  RegisterComponentForm(IibSHSystemDomain);
  RegisterComponentForm(IibSHSystemTable);
  RegisterComponentForm(IibSHSystemTableTmp);

  if Self is TibSHDDLObjectFormAction_CreateDDL then ShortCut := TextToShortCut('');
  if Self is TibSHDDLObjectFormAction_SourceDDL then ShortCut := TextToShortCut('');
  if Self is TibSHDDLObjectFormAction_AlterDDL then ShortCut := TextToShortCut('F4');
  if Self is TibSHDDLObjectFormAction_DropDDL then ShortCut := TextToShortCut('Shift+Alt+Del');
  if Self is TibSHDDLObjectFormAction_RecreateDDL then ShortCut := TextToShortCut('Shift+Alt+F4');
end;

function TibSHDDLObjectFormAction.GetCallString: string;
begin
  Result := EmptyStr;

  if Self is TibSHDDLObjectFormAction_CreateDDL then Result := SCallCreateDDL else
  if Self is TibSHDDLObjectFormAction_SourceDDL then Result := SCallSourceDDL else
  if Self is TibSHDDLObjectFormAction_AlterDDL then Result := SCallAlterDDL else
  if Self is TibSHDDLObjectFormAction_DropDDL then Result := SCallDropDDL else
  if Self is TibSHDDLObjectFormAction_RecreateDDL then Result := SCallRecreateDDL else
  if Self is TibSHDDLObjectFormAction_Description then Result := SCallDescription else
  if Self is TibSHDDLObjectFormAction_Dependencies then Result := SCallDependencies else
  if Self is TibSHDDLObjectFormAction_Fields  then Result := SCallFields else
  if Self is TibSHDDLObjectFormAction_Constraints  then Result := SCallConstraints else
  if Self is TibSHDDLObjectFormAction_Indices  then Result := SCallIndices else
  if Self is TibSHDDLObjectFormAction_Triggers  then Result := SCallTriggers else
  if Self is TibSHDDLObjectFormAction_Data  then Result := SCallData else
  if Self is TibSHDDLObjectFormAction_DataBLOB then Result := SCallDataBLOB else
  if Self is TibSHDDLObjectFormAction_DataForm then Result := SCallDataForm else
  if Self is TibSHDDLObjectFormAction_FieldDescr  then Result := SCallFieldDescr else
  if Self is TibSHDDLObjectFormAction_FieldOrder  then Result := SCallFieldOrder else
  if Self is TibSHDDLObjectFormAction_ParamDescr  then Result := SCallParamDescr;
end;

function TibSHDDLObjectFormAction.GetComponentFormClass: TSHComponentFormClass;
begin
  Result := nil;

  if AnsiSameText(CallString, SCallCreateDDL) then Result := TibBTDDLForm else
  if AnsiSameText(CallString, SCallSourceDDL) then Result := TibBTDDLForm else
  if AnsiSameText(CallString, SCallAlterDDL) then Result := TibBTDDLForm else
  if AnsiSameText(CallString, SCallDropDDL) then Result := TibBTDDLForm else
  if AnsiSameText(CallString, SCallRecreateDDL) then Result := TibBTDDLForm else
  if AnsiSameText(CallString, SCallDescription) then Result := TibBTDescriptionForm else
  if AnsiSameText(CallString, SCallDependencies) then Result := TibBTDependenciesForm else
  if AnsiSameText(CallString, SCallFields) then Result := TibSHFieldsForm else
  if AnsiSameText(CallString, SCallConstraints) then Result := TibBTConstraintsForm else
  if AnsiSameText(CallString, SCallIndices) then Result := TibBTIndicesForm else
  if AnsiSameText(CallString, SCallTriggers) then Result := TibBTTriggersForm else
  if AnsiSameText(CallString, SCallData) then Result := TibSHDataGridForm else
  if AnsiSameText(CallString, SCallDataBLOB) then Result := TibSHDataBlobForm else
  if AnsiSameText(CallString, SCallDataForm) then Result := TibSHDataVCLForm else
  if AnsiSameText(CallString, SCallFieldDescr) then Result := TibSHFieldDescrForm else
  if AnsiSameText(CallString, SCallFieldOrder) then Result := TibSHFieldOrderForm else
  if AnsiSameText(CallString, SCallParamDescr) then Result := TibSHFieldDescrForm;
end;

procedure TibSHDDLObjectFormAction.RegisterComponentForm(const AClassIID: TGUID);
begin
  if SupportComponent(AClassIID) then
    SHRegisterComponentForm(AClassIID, CallString, ComponentFormClass);
end;

function TibSHDDLObjectFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  { »дем по пор€дку CallString и выдаем √”»ƒы, на которые регистритс€ форма }
  Result := False;

  if AnsiSameText(CallString, SCallCreateDDL) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHDomain) or
              IsEqualGUID(AClassIID, IibSHTable) or
              //IsEqualGUID(AClassIID, IibSHConstraint) or
              IsEqualGUID(AClassIID, IibSHIndex) or
              IsEqualGUID(AClassIID, IibSHView) or
              IsEqualGUID(AClassIID, IibSHProcedure) or
              IsEqualGUID(AClassIID, IibSHTrigger) or
              IsEqualGUID(AClassIID, IibSHGenerator) or
              IsEqualGUID(AClassIID, IibSHException) or
              IsEqualGUID(AClassIID, IibSHFunction) or
              IsEqualGUID(AClassIID, IibSHFilter) or
              IsEqualGUID(AClassIID, IibSHRole);// or
              //IsEqualGUID(AClassIID, IibSHSystemDomain) or
              //IsEqualGUID(AClassIID, IibSHSystemTable) or
              //IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallSourceDDL) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHDomain) or
              IsEqualGUID(AClassIID, IibSHTable) or
              IsEqualGUID(AClassIID, IibSHConstraint) or
              IsEqualGUID(AClassIID, IibSHIndex) or
              IsEqualGUID(AClassIID, IibSHView) or
              IsEqualGUID(AClassIID, IibSHProcedure) or
              IsEqualGUID(AClassIID, IibSHTrigger) or
              IsEqualGUID(AClassIID, IibSHGenerator) or
              IsEqualGUID(AClassIID, IibSHException) or
              IsEqualGUID(AClassIID, IibSHFunction) or
              IsEqualGUID(AClassIID, IibSHFilter) or
              IsEqualGUID(AClassIID, IibSHRole) or
              IsEqualGUID(AClassIID, IibSHSystemDomain) or
              IsEqualGUID(AClassIID, IibSHSystemTable) or
              IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallAlterDDL) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHDomain) or
              IsEqualGUID(AClassIID, IibSHTable) or
              //IsEqualGUID(AClassIID, IibSHConstraint) or
              IsEqualGUID(AClassIID, IibSHIndex) or
              //IsEqualGUID(AClassIID, IibSHView) or
              IsEqualGUID(AClassIID, IibSHProcedure) or
              IsEqualGUID(AClassIID, IibSHTrigger) or
              IsEqualGUID(AClassIID, IibSHGenerator) or
              IsEqualGUID(AClassIID, IibSHException);// or
              //IsEqualGUID(AClassIID, IibSHFunction) or
              //IsEqualGUID(AClassIID, IibSHFilter) or
              //IsEqualGUID(AClassIID, IibSHRole) or
              //IsEqualGUID(AClassIID, IibSHSystemDomain) or
              //IsEqualGUID(AClassIID, IibSHSystemTable) or
              //IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallDropDDL) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHDomain) or
              IsEqualGUID(AClassIID, IibSHTable) or
              //IsEqualGUID(AClassIID, IibSHConstraint) or
              IsEqualGUID(AClassIID, IibSHIndex) or
              IsEqualGUID(AClassIID, IibSHView) or
              IsEqualGUID(AClassIID, IibSHProcedure) or
              IsEqualGUID(AClassIID, IibSHTrigger) or
              IsEqualGUID(AClassIID, IibSHGenerator) or
              IsEqualGUID(AClassIID, IibSHException) or
              IsEqualGUID(AClassIID, IibSHFunction) or
              IsEqualGUID(AClassIID, IibSHFilter) or
              IsEqualGUID(AClassIID, IibSHRole);// or
              //IsEqualGUID(AClassIID, IibSHSystemDomain) or
              //IsEqualGUID(AClassIID, IibSHSystemTable) or
              //IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallRecreateDDL) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHDomain) or
              IsEqualGUID(AClassIID, IibSHTable) or
              //IsEqualGUID(AClassIID, IibSHConstraint) or
              IsEqualGUID(AClassIID, IibSHIndex) or
              IsEqualGUID(AClassIID, IibSHView) or
              IsEqualGUID(AClassIID, IibSHProcedure) or
              IsEqualGUID(AClassIID, IibSHTrigger) or
              IsEqualGUID(AClassIID, IibSHGenerator) or
              IsEqualGUID(AClassIID, IibSHException) or
              IsEqualGUID(AClassIID, IibSHFunction) or
              IsEqualGUID(AClassIID, IibSHFilter) or
              IsEqualGUID(AClassIID, IibSHRole);// or
              //IsEqualGUID(AClassIID, IibSHSystemDomain) or
              //IsEqualGUID(AClassIID, IibSHSystemTable) or
              //IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallDescription) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHDomain) or
              IsEqualGUID(AClassIID, IibSHTable) or
              //IsEqualGUID(AClassIID, IibSHConstraint) or
              IsEqualGUID(AClassIID, IibSHIndex) or
              IsEqualGUID(AClassIID, IibSHView) or
              IsEqualGUID(AClassIID, IibSHProcedure) or
              IsEqualGUID(AClassIID, IibSHTrigger) or
              //IsEqualGUID(AClassIID, IibSHGenerator) or
              IsEqualGUID(AClassIID, IibSHException) or
              IsEqualGUID(AClassIID, IibSHFunction) or
              IsEqualGUID(AClassIID, IibSHFilter) or
              IsEqualGUID(AClassIID, IibSHRole) or
              //IsEqualGUID(AClassIID, IibSHSystemDomain) or
              IsEqualGUID(AClassIID, IibSHSystemTable) or
              IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallDependencies) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHDomain) or
              IsEqualGUID(AClassIID, IibSHTable) or
              //IsEqualGUID(AClassIID, IibSHConstraint) or
              //IsEqualGUID(AClassIID, IibSHIndex) or
              IsEqualGUID(AClassIID, IibSHView) or
              IsEqualGUID(AClassIID, IibSHProcedure) or
              IsEqualGUID(AClassIID, IibSHTrigger) or
              IsEqualGUID(AClassIID, IibSHGenerator) or
              IsEqualGUID(AClassIID, IibSHException) or
              IsEqualGUID(AClassIID, IibSHFunction) or
              IsEqualGUID(AClassIID, IibSHFilter) or
              //IsEqualGUID(AClassIID, IibSHRole) or
              IsEqualGUID(AClassIID, IibSHSystemDomain) or
              IsEqualGUID(AClassIID, IibSHSystemTable) or
              IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else
                                 
  if AnsiSameText(CallString, SCallFields) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHTable) or
              IsEqualGUID(AClassIID, IibSHView) or
              IsEqualGUID(AClassIID, IibSHSystemTable) or
              IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallConstraints) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHTable) or
              IsEqualGUID(AClassIID, IibSHSystemTable) or
              IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallIndices) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHTable) or
              IsEqualGUID(AClassIID, IibSHSystemTable) or
              IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallTriggers) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHTable) or
              IsEqualGUID(AClassIID, IibSHView) or
              IsEqualGUID(AClassIID, IibSHSystemTable) or
              IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallData) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHTable) or
              IsEqualGUID(AClassIID, IibSHView) or
              IsEqualGUID(AClassIID, IibSHSystemTable) or
              IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallDataBLOB) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHTable) or
              IsEqualGUID(AClassIID, IibSHView) or
              IsEqualGUID(AClassIID, IibSHSystemTable) or
              IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallDataForm) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHTable) or
              IsEqualGUID(AClassIID, IibSHView) or
              IsEqualGUID(AClassIID, IibSHSystemTable) or
              IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallFieldDescr) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHTable) or
              IsEqualGUID(AClassIID, IibSHView) or
              IsEqualGUID(AClassIID, IibSHSystemTable) or
              IsEqualGUID(AClassIID, IibSHSystemTableTmp);
  end else

  if AnsiSameText(CallString, SCallFieldOrder) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHTable);
  end else

  if AnsiSameText(CallString, SCallParamDescr) then
  begin
    Result := IsEqualGUID(AClassIID, IibSHProcedure);
  end;
end;

procedure TibSHDDLObjectFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, CallString, opInsert);
end;

procedure TibSHDDLObjectFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLObjectFormAction.EventUpdate(Sender: TObject);
begin
  Visible := Assigned(Designer.CurrentComponent) and
             Supports(Designer.CurrentComponent, ISHDBComponent) and
             not ((Designer.CurrentComponent as ISHDBComponent).State = csCreate);

  if AnsiSameText(CallString, SCallCreateDDL) then
    Visible := Assigned(Designer.CurrentComponent) and
               Supports(Designer.CurrentComponent, ISHDBComponent) and
               ((Designer.CurrentComponent as ISHDBComponent).State = csCreate);

  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(CallString, Designer.CurrentComponentForm.CallString);
  Enabled := True;            
end;

{ TibSHDDLObjectEditorAction }

constructor TibSHDDLObjectEditorAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallEditor;

  if Self is TibSHDDLObjectEditorAction_FindInScheme then Tag := 1;
  if Self is TibSHDDLObjectEditorAction_CreateNew then Tag := 2;
  if Self is TibSHDDLObjectEditorAction_RecordCount then Tag := 3;
  if Self is TibSHDDLObjectEditorAction_ChangeCount then Tag := 4;
  if Self is TibSHDDLObjectEditorAction_SetSatatistics then Tag := 5;

  case Tag of
    0: Caption := '-'; // separator
    1: Caption := SCallFindInScheme;
    2:
    begin
      Caption := SCallCreateNew;
      ShortCut := TextToShortCut('Shift+F4');
    end;
    3: Caption := SCallRecordCount;
    4: Caption := SCallChangeCount;
    5: Caption := SCallSetSatatistics;
  end;
end;

function TibSHDDLObjectEditorAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := False;

  case Tag of
    // SCallFindInScheme
    1:
    Result := IsEqualGUID(AClassIID, IibSHDomain) or
       IsEqualGUID(AClassIID, IibSHTable) or
       //IsEqualGUID(AClassIID, IibSHConstraint) or
       IsEqualGUID(AClassIID, IibSHIndex) or
       IsEqualGUID(AClassIID, IibSHView) or
       IsEqualGUID(AClassIID, IibSHProcedure) or
       IsEqualGUID(AClassIID, IibSHTrigger) or
       IsEqualGUID(AClassIID, IibSHGenerator) or
       IsEqualGUID(AClassIID, IibSHException) or
       IsEqualGUID(AClassIID, IibSHFunction) or
       IsEqualGUID(AClassIID, IibSHFilter) or
       IsEqualGUID(AClassIID, IibSHRole);// or
       //IsEqualGUID(AClassIID, IibSHSystemDomain) or
       //IsEqualGUID(AClassIID, IibSHSystemTable) or
       //IsEqualGUID(AClassIID, IibSHSystemTableTmp);

    // SCallCreateNew
    2:
    Result := IsEqualGUID(AClassIID, IibSHDomain) or
      IsEqualGUID(AClassIID, IibSHTable) or
      //IsEqualGUID(AClassIID, IibSHConstraint) or
      IsEqualGUID(AClassIID, IibSHIndex) or
      IsEqualGUID(AClassIID, IibSHView) or
      IsEqualGUID(AClassIID, IibSHProcedure) or
      IsEqualGUID(AClassIID, IibSHTrigger) or
      IsEqualGUID(AClassIID, IibSHGenerator) or
      IsEqualGUID(AClassIID, IibSHException) or
      IsEqualGUID(AClassIID, IibSHFunction) or
      IsEqualGUID(AClassIID, IibSHFilter) or
      IsEqualGUID(AClassIID, IibSHRole);// or
      //IsEqualGUID(AClassIID, IibSHSystemDomain) or
      //IsEqualGUID(AClassIID, IibSHSystemTable) or
      //IsEqualGUID(AClassIID, IibSHSystemTableTmp);

    // SCallRecordCount
    3:
    Result := IsEqualGUID(AClassIID, IibSHTable) or
      IsEqualGUID(AClassIID, IibSHView) or
      IsEqualGUID(AClassIID, IibSHSystemTable) or
      IsEqualGUID(AClassIID, IibSHSystemTableTmp);

    // SCallChangeCount
    4:
    Result := IsEqualGUID(AClassIID, IibSHTable) or
      IsEqualGUID(AClassIID, IibSHSystemTable) or
      IsEqualGUID(AClassIID, IibSHSystemTableTmp);
    // SCallSetSatatistics
    5:
    Result := IsEqualGUID(AClassIID, IibSHIndex);
  end;
end;

procedure TibSHDDLObjectEditorAction.EventExecute(Sender: TObject);
var
  vComponent: TSHComponent;
begin
  case Tag of
    // SCallFindInScheme
    1:
    begin
      Designer.SynchronizeConnection(
        Designer.FindComponent(Designer.CurrentComponent.OwnerIID),
        Designer.CurrentComponent.ClassIID,
        Designer.CurrentComponent.Caption, opInsert);
    end;
    // SCallCreateNew
    2:
    begin
      vComponent := Designer.CreateComponent(
                      Designer.CurrentComponent.OwnerIID,
                      Designer.CurrentComponent.ClassIID,
                      EmptyStr);
      if Assigned(vComponent) then ;
      //  Designer.ShowModal(vComponent, Format('DDL_WIZARD.%s', [AnsiUpperCase(vComponent.Association)]));
    end;
    // SCallRecordCount
    3:
    begin
      if Supports(Designer.CurrentComponent, IibSHTable) then
        (Designer.CurrentComponent as IibSHTable).SetRecordCount;
      if Supports(Designer.CurrentComponent, IibSHView) then
        (Designer.CurrentComponent as IibSHView).SetRecordCount;

      if Supports(Designer.CurrentComponent, IibSHTable) and
        (Length((Designer.CurrentComponent as IibSHTable).RecordCountFrmt) > 0) then
        Designer.ShowMsg(Format('%s Record Count: %s',
          [Designer.CurrentComponent.Caption,
          (Designer.CurrentComponent as IibSHTable).RecordCountFrmt]), mtInformation);

      if Supports(Designer.CurrentComponent, IibSHView) and
        (Length((Designer.CurrentComponent as IibSHView).RecordCountFrmt) > 0) then
        Designer.ShowMsg(Format('%s Record Count: %s',
          [Designer.CurrentComponent.Caption,
          (Designer.CurrentComponent as IibSHView).RecordCountFrmt]), mtInformation);
    end;
    // SCallChangeCount
    4:
    begin
      if Supports(Designer.CurrentComponent, IibSHTable) then
        (Designer.CurrentComponent as IibSHTable).SetChangeCount;
      if Supports(Designer.CurrentComponent, IibSHTable) and
        (Length((Designer.CurrentComponent as IibSHTable).ChangeCountFrmt) > 0) then
        Designer.ShowMsg(Format('%s Change Count: %s',
          [Designer.CurrentComponent.Caption,
          (Designer.CurrentComponent as IibSHTable).ChangeCountFrmt]), mtInformation);
    end;
    // SCallSetSatatistics
    5:
    begin
      if Supports(Designer.CurrentComponent, IibSHIndex) then
        (Designer.CurrentComponent as IibSHIndex).RecountStatistics;
    end;
  end;
end;

procedure TibSHDDLObjectEditorAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLObjectEditorAction.EventUpdate(Sender: TObject);
begin
  Visible := Assigned(Designer.CurrentComponent) and
             Supports(Designer.CurrentComponent, ISHDBComponent) and
             not ((Designer.CurrentComponent as ISHDBComponent).State = csCreate);

  case Tag of
    // SCallFindInScheme
    1:
    begin
      Enabled := True;
    end;
    // SCallCreateNew
    2:
    begin
      Visible := True;
      Enabled := True;
      if Assigned(Designer.CurrentComponent) then
        Caption := Format('%s %s...', [SCallCreateNew, Designer.CurrentComponent.Association]);
    end;
    // SCallRecordCount
    3:
    begin
      Enabled := True;
    end;
    // SCallChangeCount
    4:
    begin
      Enabled := True;
    end;
    // SCallSetSatatistics
    5:
    begin
      Enabled := True;    
    end;
  end;
end;

end.




