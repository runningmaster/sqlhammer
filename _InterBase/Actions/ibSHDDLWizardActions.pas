unit ibSHDDLWizardActions;

interface

uses
  SysUtils, Classes, Controls, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHDDLWizardToolbarAction_ = class(TSHAction)
  private
    procedure ShowChangedWizard;
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;


implementation

uses
  ibSHConsts,
  ibSHDDLWizardEditors,
  ibSHWizardChangeFrm,
  ibSHWizardDomainFrm,
  ibSHWizardTableFrm,
  ibSHWizardFieldFrm,
  ibSHWizardIndexFrm,
  ibSHWizardConstraintFrm,
  ibSHWizardViewFrm,
  ibSHWizardProcedureFrm,
  ibSHWizardTriggerFrm,
  ibSHWizardGeneratorFrm,
  ibSHWizardExceptionFrm,
  ibSHWizardFunctionFrm,
  ibSHWizardFilterFrm,
  ibSHWizardRoleFrm;


{ TibSHDDLWizardToolbarAction_ }

constructor TibSHDDLWizardToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := Format('%s', ['DDL Wizard...']);
  Hint := Caption;
  ShortCut := TextToShortCut('Ctrl+W');

  SHRegisterComponentForm(IibSHDomain,     'DDL_WIZARD.DOMAIN', TibSHWizardDomainForm);
//  SHRegisterComponentForm(IibSHTable,      'DDL_WIZARD.TABLE', TibSHWizardTableForm);
  SHRegisterComponentForm(IibSHTable,      'DDL_WIZARD.TABLE', TibSHWizardTableForm);
  SHRegisterComponentForm(IibSHIndex,      'DDL_WIZARD.INDEX', TibSHWizardIndexForm);
  SHRegisterComponentForm(IibSHField,      'DDL_WIZARD.FIELD', TibSHWizardFieldForm);
  SHRegisterComponentForm(IibSHConstraint, 'DDL_WIZARD.CONSTRAINT', TibSHWizardConstraintForm);
  SHRegisterComponentForm(IibSHView,       'DDL_WIZARD.VIEW', TibSHWizardViewForm);
  SHRegisterComponentForm(IibSHProcedure,  'DDL_WIZARD.PROCEDURE', TibSHWizardProcedureForm);
  SHRegisterComponentForm(IibSHTrigger,    'DDL_WIZARD.TRIGGER', TibSHWizardTriggerForm);
  SHRegisterComponentForm(IibSHGenerator,  'DDL_WIZARD.GENERATOR', TibSHWizardGeneratorForm);
  SHRegisterComponentForm(IibSHException,  'DDL_WIZARD.EXCEPTION', TibSHWizardExceptionForm);
  SHRegisterComponentForm(IibSHFunction,   'DDL_WIZARD.FUNCTION', TibSHWizardFunctionForm);
  SHRegisterComponentForm(IibSHFilter,     'DDL_WIZARD.FILTER', TibSHWizardFilterForm);
  SHRegisterComponentForm(IibSHRole,       'DDL_WIZARD.ROLE', TibSHWizardRoleForm);

  SHRegisterComponentForm(IibSHSQLEditor,  'DDL_WIZARD.CHANGE', TibSHWizardChangeForm);
//  SHRegisterComponentForm(IibSHSQLPlayer, 'DDL_WIZARD.CHANGE', TibSHWizardChangeForm);

  Visible := False;
end;

function TibSHDDLWizardToolbarAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result :=
    IsEqualGUID(AClassIID, IibSHDomain) or
    IsEqualGUID(AClassIID, IibSHTable) or // Если закомментить то пропадут визарды на поля
    IsEqualGUID(AClassIID, IibSHField) or
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

    IsEqualGUID(AClassIID, IibSHSQLEditor) or
    IsEqualGUID(AClassIID, IibSHSQLPlayer);
end;

procedure TibSHDDLWizardToolbarAction_.EventExecute(Sender: TObject);
begin
  if Supports(Designer.CurrentComponent, IibSHDBObject) then
  begin
    if AnsiSameText(Designer.CurrentComponentForm.CallString, SCallFields) or
       AnsiSameText(Designer.CurrentComponentForm.CallString, SCallConstraints) or
       AnsiSameText(Designer.CurrentComponentForm.CallString, SCallIndices) or
       AnsiSameText(Designer.CurrentComponentForm.CallString, SCallTriggers) then
      Designer.ShowModal((Designer.CurrentComponentForm as IibSHTableForm).DBComponent , Format('DDL_WIZARD.%s', [AnsiUpperCase((Designer.CurrentComponentForm as IibSHTableForm).DBComponent.Association)]))
    else
    begin
      if Supports(Designer.CurrentComponent, IibSHTable) then
        Designer.UnderConstruction
      else
        Designer.ShowModal(Designer.CurrentComponent, Format('DDL_WIZARD.%s', [AnsiUpperCase(Designer.CurrentComponent.Association)]));
    end;
  end;

  if Supports(Designer.CurrentComponent, IibSHSQLEditor) {or Supports(Component, IibSHSQLPlayer)} then
  begin
    try
      if Designer.ShowModal(Designer.CurrentComponent, 'DDL_WIZARD.CHANGE') = mrOK then
        ShowChangedWizard;
    finally
      Designer.CurrentComponent.Tag := 0;
    end;
  end;
end;

procedure TibSHDDLWizardToolbarAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHDDLWizardToolbarAction_.EventUpdate(Sender: TObject);
begin
{ TODO -oBuzz : Разобраться таки как обрубить на хер визард на таблицу }
  if Assigned(Designer.CurrentComponentForm) and
     Supports(Designer.CurrentComponent, IibSHDDLInfo) and
     Supports(Designer.CurrentComponentForm, IibSHDDLForm) and
     (

//     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallSourceDDL) or
   ((  AnsiSameText(Designer.CurrentComponentForm.CallString, SCallCreateDDL) or
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallAlterDDL) or
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallRecreateDDL)
    ) and   (Designer.CurrentComponent.Association<>SClassHintTable)  ) or
//     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallDropDDL) or

     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallFields) or
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallConstraints) or
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallIndices) or
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallTriggers) or

     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallDDLText)
     )
  then
  begin
    Visible := True;
  end
  else
    Visible := False;

  if Visible then
    if AnsiSameText(Designer.CurrentComponentForm.CallString, SCallFields) or
       AnsiSameText(Designer.CurrentComponentForm.CallString, SCallConstraints) or
       AnsiSameText(Designer.CurrentComponentForm.CallString, SCallIndices) or
       AnsiSameText(Designer.CurrentComponentForm.CallString, SCallTriggers) then
      Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanPause
    else
      Enabled := True;

end;

procedure TibSHDDLWizardToolbarAction_.ShowChangedWizard;
var
  vClassIID: TGUID;
  vComponentClass: TSHComponentClass;
  vComponent, vDDLGenerator: TSHComponent;
  vDBObjectIntf: IibSHDBObject;
  vDDLGeneratorIntf: IibSHDDLGenerator;
begin
  case Designer.CurrentComponent.Tag of
   -1: Exit;
    0: vClassIID := IibSHDomain;
    1: Designer.UnderConstruction;//vClassIID := IibSHTable;
//    1: vClassIID := IibSHTable;
    2: vClassIID := IibSHField;
    3: vClassIID := IibSHConstraint;
    4: vClassIID := IibSHIndex;
    5: vClassIID := IibSHView;
    6: vClassIID := IibSHProcedure;
    7: vClassIID := IibSHTrigger;
    8: vClassIID := IibSHGenerator;
    9: vClassIID := IibSHException;
    10: vClassIID := IibSHFunction;
    11: vClassIID := IibSHFilter;
    12: vClassIID := IibSHRole;
  end;

  try
    //
    //
    //
    vComponentClass := Designer.GetComponent(IibSHDDLGenerator);
    if Assigned(vComponentClass) then
    begin
      vDDLGenerator := vComponentClass.Create(nil);
      Supports(vDDLGenerator, IibSHDDLGenerator, vDDLGeneratorIntf);
    end;
    Assert(vDDLGeneratorIntf <> nil, 'DDLGenerator = nil');

    //
    // 
    //
    vComponentClass := Designer.GetComponent(vClassIID);
    if Assigned(vComponentClass) then vComponent := vComponentClass.Create(nil);
    if Assigned(vComponent) then
    begin
      Supports(vComponent, IibSHDBObject, vDBObjectIntf);
      vDBObjectIntf.OwnerIID := Designer.CurrentComponent.OwnerIID;
      vDBObjectIntf.State := csCreate;
      vDBObjectIntf.Caption := Format('NEW_%s', [UpperCase(vComponent.Association)]);
      if Supports(Designer.CurrentComponent, IibSHSQLEditor) then vComponent.Tag := 100;
//      if Supports(Component, IibSHSQLPlayer) then vComponent.Tag := 200;
   //   vDDLGeneratorIntf.UseFakeValues := False;
   //   Designer.TextToStrings(vDDLGeneratorIntf.GetDDLText(vDBObjectIntf), vDBObjectIntf.CreateDDL);
      Designer.ShowModal(vComponent, Format('DDL_WIZARD.%s', [AnsiUpperCase(vComponent.Association)]));
    end;
  finally
    vDDLGeneratorIntf := nil;
    FreeAndNil(vDDLGenerator);
    vDBObjectIntf := nil;
    FreeAndNil(vComponent);
  end;
end;

end.
