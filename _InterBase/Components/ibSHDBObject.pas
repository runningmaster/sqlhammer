unit ibSHDBObject;

interface

uses
  SysUtils, Classes, Contnrs, Dialogs, StrUtils, ExtCtrls, Forms,
  SHDesignIntf, SHEvents, SHOptionsIntf,
  ibSHDesignIntf, ibSHDriverIntf, ibSHComponent;

type
  TibBTDBObject = class(TibBTComponent, IibSHDBObject, ISHDBComponent,
    IibSHDDLInfo, IibSHBranch, IfbSHBranch)
  private
    FBTCLDatabaseIntf: IibSHDatabase;
    FDDLGenerator: TComponent;
    FDDLGeneratorIntf: IibSHDDLGenerator;

    FSystem: Boolean;
    FReadOnly: Boolean;
    FState: TSHDBComponentState;
    FEmbedded: Boolean;

    FObjectName: string;
    FDescription: TStrings;
    FSourceDDL: TStrings;
    FCreateDDL: TStrings;
    FAlterDDL: TStrings;
    FDropDDL: TStrings;
    FRecreateDDL: TStrings;
    FScriptDDL: TStrings;
    FOwnerName: string;
    FParams: TStrings;
    FReturns: TStrings;
    FBodyText: TStrings;
    FBLR: TStrings;
    FFields: TStrings;
    FConstraints: TStrings;
    FIndices: TStrings;
    FTriggers: TStrings;
    FGrants: TStrings;
    FTRParams: TStrings;
    FDDLHistory: IibSHDDLHistory;
    function GetDDLHistory: IibSHDDLHistory;
  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
    function GetBTCLDatabase: IibSHDatabase;

    function GetBranchIID: TGUID; override;
    function GetCaption: string; override;
    function GetCaptionExt: string; override;
    procedure SetOwnerIID(Value: TGUID); override;

    function GetSystem: Boolean;
    procedure SetSystem(Value: Boolean);
    function GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    function GetState: TSHDBComponentState;
    procedure SetState(Value: TSHDBComponentState);
    function GetEmbedded: Boolean;
    procedure SetEmbedded(Value: Boolean);

    function GetObjectName: string;
    procedure SetObjectName(Value: string);
    function GetDescription: TStrings;
    function GetSourceDDL: TStrings;
    function GetCreateDDL: TStrings;
    function GetAlterDDL: TStrings;
    function GetDropDDL: TStrings;
    function GetRecreateDDL: TStrings;
    function GetScriptDDL: TStrings;
    function GetOwnerName: string;
    procedure SetOwnerName(Value: string);
    function GetParams: TStrings;
    function GetReturns: TStrings;
    function GetBodyText: TStrings;
    function GetBLR: TStrings;
    function GetFields: TStrings;
    function GetConstraints: TStrings;
    function GetIndices: TStrings;
    function GetTriggers: TStrings;
    function GetGrants: TStrings;
    function GetTRParams: TStrings;

    function GetDDL: TStrings;
    function CreateParam(AOwner: TComponentList; const AClassIID: TGUID; Index: Integer): TComponent;
    property DDLHistory: IibSHDDLHistory read GetDDLHistory;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    class function GetHintClassFnc: string; override;
    class function GetAssociationClassFnc: string; override;

    procedure Refresh; virtual;

    function GetDescriptionText: string;
    function GetDescriptionStatement(AsParam: Boolean): string;
    procedure SetDescription;
    procedure FormGrants;

    { properties }
    property BTCLDatabase: IibSHDatabase read GetBTCLDatabase;
    property DDLGenerator: IibSHDDLGenerator read FDDLGeneratorIntf;

    property System: Boolean read GetSystem write SetSystem;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property State: TSHDBComponentState read GetState write SetState;
    property Embedded: Boolean read GetEmbedded write SetEmbedded;
    
    property ObjectName: string read GetObjectName {write SetObjectName};
    property Description: TStrings read GetDescription;
    property SourceDDL: TStrings read GetSourceDDL;
    property CreateDDL: TStrings read GetCreateDDL;
    property AlterDDL: TStrings read GetAlterDDL;
    property DropDDL: TStrings read GetDropDDL;
    property RecreateDDL: TStrings read GetRecreateDDL;
    property ScriptDDL: TStrings read GetScriptDDL;
    property OwnerName: string read GetOwnerName {write SetOwnerName};
    property Params: TStrings read GetParams;
    property Returns: TStrings read GetReturns;
    property BodyText: TStrings read GetBodyText;
    property BLR: TStrings read GetBLR;
    property Fields: TStrings read GetFields;
    property Constraints: TStrings read GetConstraints;
    property Indices: TStrings read GetIndices;
    property Triggers: TStrings read GetTriggers;
    property Grants: TStrings read GetGrants;
    property TRParams: TStrings read GetTRParams;
  end;

  TibBTDBObjectFactory = class(TibBTComponentFactory, IibSHDBObjectFactory)
  private
    FSuspendedTimer: TTimer;
    FSuspendedOldComponent: TSHComponent;
    FSuspendedNewOwnerIID: TGUID;
    FSuspendedNewClassIID: TGUID;
    FSuspendedNewCaption: string;
    FSuspendedDescr: TStrings;
    procedure SuspendedTimerEvent(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SuspendedDestroyCreateComponent(OldComponent: TSHComponent;
      const NewOwnerIID, NewClassIID: TGUID; const NewCaption: string);

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    function CreateComponent(const AOwnerIID, AClassIID: TGUID; const ACaption: string): TSHComponent; override;
  end;

procedure Register();

implementation

uses
  ibSHConsts, ibSHMessages, ibSHSQLs, ibSHValues,
  ibSHDomain, ibSHTable, ibSHIndex, ibSHView, ibSHProcedure, ibSHTrigger,
  ibSHGenerator, ibSHException, ibSHFunction, ibSHFilter, ibSHRole, ibSHShadow,
  ibSHConstraint,
  ibSHDBObjectActions, ibSHDBObjectEditors,
  ibSHDDLFrm, ibSHDataGridFrm, ibSHDataBlobFrm,
  {ibSHDDLGeneratorFrm, }ibSHFieldsFrm, ibSHConstraintsFrm,
  ibSHIndicesFrm, ibSHTriggersFrm, {ibSHDataGridFrm,} ibSHDependenciesFrm,
  ibSHDescriptionFrm, ibSHFieldOrderFrm, ibSHFieldDescrFrm,
  ibSHDDLGenerator, ibSHDDLCompiler, ibSHDependencies, ibSHQuery;

procedure Register();
begin
  // Картинки

  SHRegisterImage(GUIDToString(IibSHDomain),         'Domain.bmp');
  SHRegisterImage(GUIDToString(IibSHsystemDomain),   'SysDomain.bmp');
  SHRegisterImage(GUIDToString(IibSHTable),          'Table.bmp');
  SHRegisterImage(GUIDToString(IibSHsystemTable),    'SysTable.bmp');
  SHRegisterImage(GUIDToString(IibSHsystemTableTmp), 'SysTableTmp.bmp');
  SHRegisterImage(GUIDToString(IibSHField),          'Field.bmp');
  SHRegisterImage(GUIDToString(IibSHConstraint),     'Constraint.bmp');
  SHRegisterImage(GUIDToString(IibSHIndex),          'Index.bmp');
  SHRegisterImage(GUIDToString(IibSHView),           'View.bmp');
  SHRegisterImage(GUIDToString(IibSHProcedure),      'Procedure.bmp');
  SHRegisterImage(GUIDToString(IibSHTrigger),        'Trigger.bmp');
  SHRegisterImage(GUIDToString(IibSHGenerator),      'Generator.bmp');
  SHRegisterImage(GUIDToString(IibSHException),      'Exception.bmp');
  SHRegisterImage(GUIDToString(IibSHFunction),       'Function.bmp');
  SHRegisterImage(GUIDToString(IibSHFilter),         'Filter.bmp');
  SHRegisterImage(GUIDToString(IibSHRole),           'Role.bmp');

  SHRegisterImage(SCallFields,       'Field.bmp');
  SHRegisterImage(SCallConstraints,  'Constraint.bmp');
  SHRegisterImage(SCallIndices,      'Index.bmp');
  SHRegisterImage(SCallTriggers,     'Trigger.bmp');
  SHRegisterImage(SCallDescription,  'Form_Description.bmp');
  SHRegisterImage(SCallDescriptions, 'Form_Description.bmp');
  SHRegisterImage(SCallDependencies, 'Form_Dependencies.bmp');
  SHRegisterImage(SCallFieldDescr,   'Form_Field_Description.bmp');
  SHRegisterImage(SCallParamDescr,   'Form_Field_Description.bmp');
  SHRegisterImage(SCallFieldOrder,   'Form_Field_Order.bmp');

  SHRegisterImage(SCallSourceDDL,   'Form_SourceDDL.bmp');
  SHRegisterImage(SCallAlterDDL,    'Form_AlterDDL.bmp');
  SHRegisterImage(SCallDropDDL,     'Form_DropDDL.bmp');
  SHRegisterImage(SCallRecreateDDL, 'Form_RecreateDDL.bmp');
  SHRegisterImage(SCallCreateDDL,   'Form_CreateDDL.bmp');

  SHRegisterImage(TibSHDomainPaletteAction.ClassName,    'Domain.bmp');
  SHRegisterImage(TibSHTablePaletteAction.ClassName,     'Table.bmp');
  SHRegisterImage(TibSHIndexPaletteAction.ClassName,     'Index.bmp');
  SHRegisterImage(TibSHViewPaletteAction.ClassName,      'View.bmp');
  SHRegisterImage(TibSHProcedurePaletteAction.ClassName, 'Procedure.bmp');
  SHRegisterImage(TibSHTriggerPaletteAction.ClassName,   'Trigger.bmp');
  SHRegisterImage(TibSHGeneratorPaletteAction.ClassName, 'Generator.bmp');
  SHRegisterImage(TibSHExceptionPaletteAction.ClassName, 'Exception.bmp');
  SHRegisterImage(TibSHFunctionPaletteAction.ClassName,  'Function.bmp');
  SHRegisterImage(TibSHFilterPaletteAction.ClassName,    'Filter.bmp');
  SHRegisterImage(TibSHRolePaletteAction.ClassName,      'Role.bmp');

  SHRegisterImage(TibSHDDLObjectFormAction_CreateDDL.ClassName,    'Form_CreateDDL.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_SourceDDL.ClassName,    'Form_SourceDDL.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_AlterDDL.ClassName,     'Form_AlterDDL.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_DropDDL.ClassName,      'Form_DropDDL.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_RecreateDDL.ClassName,  'Form_RecreateDDL.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_Description.ClassName,  'Form_Description.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_Dependencies.ClassName, 'Form_Dependencies.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_Fields.ClassName,       'Field.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_Constraints.ClassName,  'Constraint.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_Indices.ClassName,      'Index.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_Triggers.ClassName,     'Trigger.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_Data.ClassName,         'Form_Data_Grid.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_DataBLOB.ClassName,     'Form_Data_Blob.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_DataForm.ClassName,     'Form_Data_VCL.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_FieldDescr.ClassName,   'Form_Field_Description.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_FieldOrder.ClassName,   'Form_Field_Order.bmp');
  SHRegisterImage(TibSHDDLObjectFormAction_ParamDescr.ClassName,   'Form_Field_Description.bmp');

  SHRegisterImage(TibSHProcedureToolbarAction_Execute.ClassName, 'Button_ExecuteProcedure.bmp');

  // На палитру
  SHRegisterActions([
    TibSHDomainPaletteAction,
    TibSHTablePaletteAction,
    TibSHIndexPaletteAction,
    TibSHViewPaletteAction,
    TibSHProcedurePaletteAction,
    TibSHTriggerPaletteAction,
    TibSHGeneratorPaletteAction,
    TibSHExceptionPaletteAction,
    TibSHFunctionPaletteAction,
    TibSHFilterPaletteAction,
    TibSHRolePaletteAction]);

  // Компоненты
  SHRegisterComponents([
     TibBTDomain,
     TibBTTable,
     TibBTIndex,
     TibBTView,
     TibBTProcedure,
     TibBTTrigger,
     TibBTGenerator,
     TibBTException,
     TibBTFunction,
     TibBTFilter,
     TibBTRole,

     TibBTConstraint,
     TibBTSystemDomain,
     TibBTSystemTable,
     TibBTSystemTableTmp,
     TibBTField,
     TibBTProcParam,
     TibSHQuery,

     TibBTDBObjectFactory,
     TibBTDDLGenerator,
     TibBTDDLCompiler,
     TibBTDependencies]);

  // Формы (вызов)
  SHRegisterActions([
    TibSHDDLObjectFormAction_CreateDDL,
    TibSHDDLObjectFormAction_SourceDDL,
    TibSHDDLObjectFormAction_AlterDDL,
    TibSHDDLObjectFormAction_DropDDL,
    TibSHDDLObjectFormAction_RecreateDDL,
    TibSHDDLObjectFormAction_Description,
    TibSHDDLObjectFormAction_Dependencies,
    TibSHDDLObjectFormAction_Fields,
    TibSHDDLObjectFormAction_Constraints,
    TibSHDDLObjectFormAction_Indices,
    TibSHDDLObjectFormAction_Triggers,
    TibSHDDLObjectFormAction_Data,
    TibSHDDLObjectFormAction_DataForm,
    TibSHDDLObjectFormAction_DataBLOB,
    TibSHDDLObjectFormAction_FieldDescr,
    TibSHDDLObjectFormAction_FieldOrder,
    TibSHDDLObjectFormAction_ParamDescr]);

  // Редакторы
  SHRegisterActions([
    TibSHDDLObjectEditorAction_FindInScheme,
    TibSHDDLObjectEditorAction_CreateNew,
    TibSHDDLObjectEditorAction_RecordCount,
    TibSHDDLObjectEditorAction_ChangeCount,
    TibSHDDLObjectEditorAction_SetSatatistics]);

  SHRegisterActions([
    TibSHProcedureToolbarAction_Execute]);

// IibSHField
  SHRegisterComponentForm(IibSHField, SCallCreateDDL, TibBTDDLForm);
  SHRegisterComponentForm(IibSHField, SCallSourceDDL, TibBTDDLForm);
  SHRegisterComponentForm(IibSHField, SCallAlterDDL, TibBTDDLForm);
  SHRegisterComponentForm(IibSHField, SCallDropDDL, TibBTDDLForm);
  SHRegisterComponentForm(IibSHField, SCallRecreateDDL, TibBTDDLForm);
  SHRegisterComponentForm(IibSHField, SCallDescription, TibBTDescriptionForm);

////////////////////////////////////////////////////////////////////////////////

  SHRegisterPropertyEditor(IibSHDBObject, SCallDescription, TibBTDBDescriptionProp);
//  SHRegisterPropertyEditor(IibSHDBObject, SCallSourceDDL, TibBTDBSourceDDLProp);
  SHRegisterPropertyEditor(IibSHDBObject, SCallParams, TibBTDBParams);
  SHRegisterPropertyEditor(IibSHDBObject, SCallReturns, TibBTDBReturns);
  SHRegisterPropertyEditor(IibSHDBObject, SCallFields, TibBTDBFields);
  SHRegisterPropertyEditor(IibSHDBObject, SCallConstraints, TibBTDBConstraints);
  SHRegisterPropertyEditor(IibSHDBObject, SCallIndices, TibBTDBIndices);
  SHRegisterPropertyEditor(IibSHDBObject, SCallTriggers, TibBTDBTriggers);
  SHRegisterPropertyEditor(IibSHDBObject, SCallGrants, TibBTDBGrants);
//  SHRegisterPropertyEditor(IibSHDBObject, SCallBLR, TibBTDBBLR);
  SHRegisterPropertyEditor(IibSHDBObject, SCallReferenceFields, TibBTDBReferenceFields);
  SHRegisterPropertyEditor(IibSHDBObject, SCallCheckSource, TibBTDBCheckSource);

  SHRegisterPropertyEditor(IibSHDBObject, SCallDefaultExpression, TibBTDBDefaultExpression);
  SHRegisterPropertyEditor(IibSHDBObject, SCallCheckConstraint, TibBTDBCheckConstraint);
  SHRegisterPropertyEditor(IibSHDBObject, SCallComputedSource, TibBTComputedSource);

(*
  SHRegisterPropertyEditor(IibSHDBObject, SCallTableName, TibBTTableNamePropEditor);
  SHRegisterPropertyEditor(IibSHDBObject, SCallStatus, TibBTStatusPropEditor);
  SHRegisterPropertyEditor(IibSHDBObject, SCallTypePrefix, TibBTTypePrefixPropEditor);
  SHRegisterPropertyEditor(IibSHDBObject, SCallTypeSuffix, TibBTTypeSuffixPropEditor);

  SHRegisterPropertyEditor(IibSHDBObject, SCallRecordCount, TibBTRecordCountEditor);
  SHRegisterPropertyEditor(IibSHDBObject, SCallChangeCount, TibBTChangeCountPropEditor);

  SHRegisterPropertyEditor(IibSHDBObject, SCallDataType, TibBTDataTypePropEditor);
  SHRegisterPropertyEditor(IibSHDBObject, SCallCollate, TibBTCollatePropEditor);
  SHRegisterPropertyEditor(IibSHDBObject, SCallBlobSubType, TibBTBlobSubTypePropEditor);
  SHRegisterPropertyEditor(IibSHDBObject, SCallPrecision, TibBTPrecisionPropEditor);
  SHRegisterPropertyEditor(IibSHDBObject, SCallScale, TibBTScalePropEditor);
  SHRegisterPropertyEditor(IibSHDBObject, SCallMechanism, TibBTMechanismPropEditor);
*)
end;

{ TibBTDBObject }

constructor TibBTDBObject.Create(AOwner: TComponent);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner);
  FDescription := TStringList.Create;
  FSourceDDL := TStringList.Create;
  FCreateDDL := TStringList.Create;
  FAlterDDL := TStringList.Create;
  FDropDDL := TStringList.Create;
  FRecreateDDL := TStringList.Create;
  FScriptDDL := TStringList.Create;
  FParams := TStringList.Create;
  FReturns := TStringList.Create;
  FBodyText := TStringList.Create;
  FBLR := TStringList.Create;
  FFields := TStringList.Create;
  FConstraints := TStringList.Create;
  FIndices := TStringList.Create;
  FTriggers := TStringList.Create;
  FGrants := TStringList.Create;
  FTRParams := TStringList.Create;

  vComponentClass := Designer.GetComponent(IibSHDDLGenerator);
  if Assigned(vComponentClass) then
  begin
    FDDLGenerator := vComponentClass.Create(nil);
    Supports(FDDLGenerator, IibSHDDLGenerator, FDDLGeneratorIntf);
  end;
end;

destructor TibBTDBObject.Destroy;
begin
  FDescription.Free;
  FSourceDDL.Free;
  FCreateDDL.Free;
  FAlterDDL.Free;
  FDropDDL.Free;
  FRecreateDDL.Free;
  FScriptDDL.Free;
  FParams.Free;
  FReturns.Free;
  FBodyText.Free;
  FBLR.Free;
  FFields.Free;
  FConstraints.Free;
  FIndices.Free;
  FTriggers.Free;
  FGrants.Free;
  FTRParams.Free;

  FBTCLDatabaseIntf := nil;
  FDDLGeneratorIntf := nil;
  FDDLGenerator.Free;

  inherited Destroy;
end;

procedure TibBTDBObject.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent.IsImplementorOf(FDDLHistory) then FDDLHistory := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

class function TibBTDBObject.GetHintClassFnc: string;
begin
  Result := inherited GetHintClassFnc;

  if Supports(Self, IibSHDomain) then Result := SClassHintDomain;
  if Supports(Self, IibSHTable) then Result := SClassHintTable;
  if Supports(Self, IibSHConstraint) then Result := SClassHintConstraint;
  if Supports(Self, IibSHIndex) then Result := SClassHintIndex;
  if Supports(Self, IibSHView) then Result := SClassHintView;
  if Supports(Self, IibSHProcedure) then Result := SClassHintProcedure;
  if Supports(Self, IibSHTrigger) then Result := SClassHintTrigger;
  if Supports(Self, IibSHGenerator) then Result := SClassHintGenerator;
  if Supports(Self, IibSHException) then Result := SClassHintException;
  if Supports(Self, IibSHFunction) then Result := SClassHintFunction;
  if Supports(Self, IibSHFilter) then Result := SClassHintFilter;
  if Supports(Self, IibSHRole) then Result := SClassHintRole;
  if Supports(Self, IibSHShadow) then Result := SClassHintShadow;
  { System }
  if Supports(Self, IibSHSystemDomain) then Result := SClassHintSystemDomain;
  if Supports(Self, IibSHSystemGeneratedDomain) then Result := SClassHintSystemGeneratedDomain;
  if Supports(Self, IibSHSystemTable) then Result := SClassHintSystemTable;
  if Supports(Self, IibSHSystemGeneratedTrigger) then Result := SClassHintSystemGeneratedTrigger;
  if Supports(Self, IibSHSystemGeneratedConstraint) then Result := SClassHintSystemGeneratedConstraint;
end;

class function TibBTDBObject.GetAssociationClassFnc: string;
begin
  Result := inherited GetAssociationClassFnc;

  if Supports(Self, IibSHDomain) then Result := SClassAssocDomain;
  if Supports(Self, IibSHTable) then Result := SClassAssocTable;
  if Supports(Self, IibSHConstraint) then Result := SClassAssocConstraint;
  if Supports(Self, IibSHIndex) then Result := SClassAssocIndex;
  if Supports(Self, IibSHView) then Result := SClassAssocView;
  if Supports(Self, IibSHProcedure) then Result := SClassAssocProcedure;
  if Supports(Self, IibSHTrigger) then Result := SClassAssocTrigger;
  if Supports(Self, IibSHGenerator) then Result := SClassAssocGenerator;
  if Supports(Self, IibSHException) then Result := SClassAssocException;
  if Supports(Self, IibSHFunction) then Result := SClassAssocFunction;
  if Supports(Self, IibSHFilter) then Result := SClassAssocFilter;
  if Supports(Self, IibSHRole) then Result := SClassAssocRole;
  if Supports(Self, IibSHShadow) then Result := SClassAssocShadow;
  { System }
  if Supports(Self, IibSHSystemDomain) then Result := SClassAssocSystemDomain;
  if Supports(Self, IibSHSystemGeneratedDomain) then Result := SClassAssocSystemGeneratedDomain;
  if Supports(Self, IibSHSystemTable) then Result := SClassAssocSystemTable;
  if Supports(Self, IibSHSystemGeneratedTrigger) then Result := SClassAssocSystemGeneratedTrigger;
  if Supports(Self, IibSHSystemGeneratedConstraint) then Result := SClassAssocSystemGeneratedConstraint;
end;

function TibBTDBObject.GetDDLHistory: IibSHDDLHistory;
var
  vHistoryComponent: TSHComponent;
  vHistoryComponentClass: TSHComponentClass;
  vSHSystemOptions: ISHSystemOptions;
begin
  if not Assigned(FDDLHistory) then
  begin
    if not Supports(Designer.FindComponent(OwnerIID, IibSHDDLHistory), IibSHDDLHistory, FDDLHistory) then
    begin
      vHistoryComponentClass := Designer.GetComponent(IibSHDDLHistory);
      if Assigned(vHistoryComponentClass) then
      begin
        vHistoryComponent := vHistoryComponentClass.Create(nil);
        vHistoryComponent.OwnerIID := OwnerIID;
        if Supports(vHistoryComponent, IibSHDDLHistory, FDDLHistory) then
        begin
          if Assigned(FDDLHistory.BTCLDatabase) and
            Supports(Designer.GetOptions(ISHSystemOptions), ISHSystemOptions, vSHSystemOptions) and
            (not vSHSystemOptions.UseWorkspaces) then
            vHistoryComponent.Caption := Format('%s for %s', [Designer.GetComponent(IibSHDDLHistory).GetHintClassFnc, FDDLHistory.BTCLDatabase.Alias])
          else
            vHistoryComponent.Caption := Designer.GetComponent(IibSHDDLHistory).GetHintClassFnc;
        end;
      end;
    end;
    ReferenceInterface(FDDLHistory, opInsert);
  end;
  Result := FDDLHistory;
end;

function TibBTDBObject.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if IsEqualGUID(IID, IibSHDatabase) then
  begin
    IInterface(Obj) := FBTCLDatabaseIntf;
    if Pointer(Obj) <> nil then
      Result := S_OK
    else
      Result := E_NOINTERFACE;
  end
  else
    Result := inherited QueryInterface(IID, Obj);
end;

function TibBTDBObject.GetBTCLDatabase: IibSHDatabase;
begin
  Result := FBTCLDatabaseIntf;
end;

function TibBTDBObject.GetBranchIID: TGUID;
begin
  Result := inherited GetBranchIID;
  if Assigned(BTCLDatabase) then Result := BTCLDatabase.BranchIID;
end;

function TibBTDBObject.GetCaption: string;
begin
  Result := inherited GetCaption;
end;

function TibBTDBObject.GetCaptionExt: string;
var
  SHSystemOptions: ISHSystemOptions;
begin
  Result := Format('%s', [Caption]);
  Supports(Designer.GetOptions(ISHSystemOptions), ISHSystemOptions, SHSystemOptions);
  if Assigned(BTCLDatabase) and Assigned(SHSystemOptions) and not SHSystemOptions.UseWorkspaces then
    Result := Format('%s : %s', [Result, BTCLDatabase.Alias]);
  SHSystemOptions := nil;
end;

procedure TibBTDBObject.SetOwnerIID(Value: TGUID);
begin
  if not IsEqualGUID(OwnerIID, Value) and
         Supports(Designer.FindComponent(Value), IibSHDatabase, FBTCLDatabaseIntf) then
    inherited SetOwnerIID(Value);
end;

function TibBTDBObject.GetSystem: Boolean;
begin
  Result := FSystem;
end;

procedure TibBTDBObject.SetSystem(Value: Boolean);
begin
  FSystem := Value;
end;

function TibBTDBObject.GetReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

procedure TibBTDBObject.SetReadOnly(Value: Boolean);
begin
  FReadOnly := Value;
end;

function TibBTDBObject.GetState: TSHDBComponentState;
begin
  Result := FState;
end;

procedure TibBTDBObject.SetState(Value: TSHDBComponentState);
begin
  FState := Value;
end;

function TibBTDBObject.GetEmbedded: Boolean;
begin
  Result := FEmbedded;
end;

procedure TibBTDBObject.SetEmbedded(Value: Boolean);
begin
  FEmbedded := Value;
end;

function TibBTDBObject.GetObjectName: string;
begin
  Result := FObjectName;
end;

procedure TibBTDBObject.SetObjectName(Value: string);
begin
  FObjectName := Value;
end;

function TibBTDBObject.GetDescription: TStrings;
begin
  Result := FDescription;
end;

function TibBTDBObject.GetSourceDDL: TStrings;
begin
  Result := FSourceDDL;
end;

function TibBTDBObject.GetCreateDDL: TStrings;
begin
  Result := FCreateDDL;
end;

function TibBTDBObject.GetAlterDDL: TStrings;
begin
  Result := FAlterDDL;
end;

function TibBTDBObject.GetDropDDL: TStrings;
begin
  Result := FDropDDL;
end;

function TibBTDBObject.GetRecreateDDL: TStrings;
begin
  Result := FRecreateDDL;
end;

function TibBTDBObject.GetScriptDDL: TStrings;
begin
  Result := FScriptDDL;
end;

function TibBTDBObject.GetOwnerName: string;
begin
  Result := FOwnerName;
end;

procedure TibBTDBObject.SetOwnerName(Value: string);
begin
  FOwnerName := Value;
end;

function TibBTDBObject.GetParams: TStrings;
begin
  Result := FParams;
end;

function TibBTDBObject.GetReturns: TStrings;
begin
  Result := FReturns;
end;

function TibBTDBObject.GetBodyText: TStrings;
begin
  Result := FBodyText;
end;

function TibBTDBObject.GetBLR: TStrings;
begin
  Result := FBLR;
end;

function TibBTDBObject.GetFields: TStrings;
begin
  Result := FFields;
end;

function TibBTDBObject.GetConstraints: TStrings;
begin
  Result := FConstraints;
end;

function TibBTDBObject.GetIndices: TStrings;
begin
  Result := FIndices;
end;

function TibBTDBObject.GetTriggers: TStrings;
begin
  Result := FTriggers;
end;

function TibBTDBObject.GetGrants: TStrings;
begin
  Result := FGrants;
end;

function TibBTDBObject.GetTRParams: TStrings;
begin
  Result := FTRParams;
end;

function TibBTDBObject.GetDDL: TStrings;
begin
  Result := SourceDDL;
  case State of
    csCreate: Result := CreateDDL;
    csAlter: Result := AlterDDL;
    csDrop: Result := DropDDL;
    csRecreate: Result := RecreateDDL;
  end;
end;

function TibBTDBObject.CreateParam(AOwner: TComponentList; const AClassIID: TGUID; Index: Integer): TComponent;
var
  vComponentClass: TSHComponentClass;
  vComponent: TSHComponent;
begin
  Result := nil;
  if Index > Pred(AOwner.Count) then
  begin
    vComponentClass := Designer.GetComponent(AClassIID);
    if Assigned(vComponentClass) then
    begin
      vComponent := vComponentClass.Create(nil);
      vComponent.OwnerIID := Self.OwnerIID;
      Designer.Components.Remove(vComponent);
      AOwner.Add(vComponent);
      Result := vComponent;
    end;
  end else
    Result := AOwner[Index];
end;

procedure TibBTDBObject.Refresh;
var
  vState: TSHDBComponentState;
begin
  Description.Clear;
  Params.Clear;
  Returns.Clear;
  BodyText.Clear;
  BLR.Clear;
  Fields.Clear;
  Constraints.Clear;
  Indices.Clear;
  Triggers.Clear;
  Grants.Clear;

  vState := State;
  try
    if State<>csRelatedSource then
     State := csSource;
    SourceDDL.Clear;
    SourceDDL.Text := DDLGenerator.GetDDLText(Self as IibSHDBObject);
    Designer.UpdateObjectInspector;
  finally
    State := vState;
  end;
end;

function TibBTDBObject.GetDescriptionText: string;
var
  SQL: string;
begin
  Result := EmptyStr;
  if Supports(Self, IibSHDomain) then SQL := FormatSQL(SQL_GET_COMMENT_DOMAIN);
  if Supports(Self, IibSHTable) then SQL := FormatSQL(SQL_GET_COMMENT_TABLE);
  if Supports(Self, IibSHIndex) then SQL := FormatSQL(SQL_GET_COMMENT_INDEX);
  if Supports(Self, IibSHView) then SQL := FormatSQL(SQL_GET_COMMENT_VIEW);
  if Supports(Self, IibSHProcedure) then SQL := FormatSQL(SQL_GET_COMMENT_PROCEDURE);
  if Supports(Self, IibSHTrigger) then SQL := FormatSQL(SQL_GET_COMMENT_TRIGGER);
  if Supports(Self, IibSHException) then SQL := FormatSQL(SQL_GET_COMMENT_EXCEPTION);
  if Supports(Self, IibSHFunction) then SQL := FormatSQL(SQL_GET_COMMENT_FUNCTION);
  if Supports(Self, IibSHFilter) then SQL := FormatSQL(SQL_GET_COMMENT_FILTER);
  SQL := Format(SQL, [Self.Caption]);
  if Supports(Self, IibSHField) or Supports(Self, IibSHProcParam) then
  begin
    if Supports(Self, IibSHField) then SQL := FormatSQL(SQL_GET_COMMENT_FIELD);
    if Supports(Self, IibSHProcParam) then SQL := FormatSQL(SQL_GET_COMMENT_PROC_PARAM);
    SQL := Format(SQL, [Self.ObjectName, (Self as IibSHDomain).TableName]);
  end;

  try
    if BTCLDatabase.DRVQuery.ExecSQL(SQL, [], False) then
      Result := TrimRight(BTCLDatabase.DRVQuery.GetFieldStrValue('DESCRIPTION'));
  finally
    BTCLDatabase.DRVQuery.Transaction.Commit;
  end;
end;

function TibBTDBObject.GetDescriptionStatement(AsParam: Boolean): string;
var
  SQL: string;
begin
  if AsParam then
  begin
    if Supports(Self, IibSHDomain) then SQL := FormatSQL(SQL_SET_COMMENT_DOMAIN_AS_PARAM)
    else
    if Supports(Self, IibSHTable) then SQL := FormatSQL(SQL_SET_COMMENT_TABLE_AS_PARAM)
    else
    if Supports(Self, IibSHIndex) then SQL := FormatSQL(SQL_SET_COMMENT_INDEX_AS_PARAM)
    else
    if Supports(Self, IibSHView) then SQL := FormatSQL(SQL_SET_COMMENT_VIEW_AS_PARAM)
    else
    if Supports(Self, IibSHProcedure) then SQL := FormatSQL(SQL_SET_COMMENT_PROCEDURE_AS_PARAM)
    else
    if Supports(Self, IibSHTrigger) then SQL := FormatSQL(SQL_SET_COMMENT_TRIGGER_AS_PARAM)
    else
    if Supports(Self, IibSHException) then SQL := FormatSQL(SQL_SET_COMMENT_EXCEPTION_AS_PARAM)
    else
    if Supports(Self, IibSHFunction) then SQL := FormatSQL(SQL_SET_COMMENT_FUNCTION_AS_PARAM)
    else
    if Supports(Self, IibSHFilter) then SQL := FormatSQL(SQL_SET_COMMENT_FILTER_AS_PARAM);

    SQL := Format(SQL, [Self.Caption]);
    if Supports(Self, IibSHField) or Supports(Self, IibSHProcParam) then
    begin
      if Supports(Self, IibSHField) then SQL := FormatSQL(SQL_SET_COMMENT_FIELD_AS_PARAM);
      if Supports(Self, IibSHProcParam) then SQL := FormatSQL(SQL_SET_COMMENT_PROC_PARAM_AS_PARAM);
      SQL := Format(SQL, [Self.ObjectName, (Self as IibSHDomain).TableName]);
    end;
  end else
  begin
    if Supports(Self, IibSHDomain) then SQL := FormatSQL(SQL_SET_COMMENT_DOMAIN)
    else
    if Supports(Self, IibSHTable) then SQL := FormatSQL(SQL_SET_COMMENT_TABLE)
    else
    if Supports(Self, IibSHIndex) then SQL := FormatSQL(SQL_SET_COMMENT_INDEX)
    else
    if Supports(Self, IibSHView) then SQL := FormatSQL(SQL_SET_COMMENT_VIEW)
    else
    if Supports(Self, IibSHProcedure) then SQL := FormatSQL(SQL_SET_COMMENT_PROCEDURE)
    else
    if Supports(Self, IibSHTrigger) then SQL := FormatSQL(SQL_SET_COMMENT_TRIGGER)
    else
    if Supports(Self, IibSHException) then SQL := FormatSQL(SQL_SET_COMMENT_EXCEPTION)
    else
    if Supports(Self, IibSHFunction) then SQL := FormatSQL(SQL_SET_COMMENT_FUNCTION)
    else
    if Supports(Self, IibSHFilter) then SQL := FormatSQL(SQL_SET_COMMENT_FILTER);
    
    SQL := Format(SQL, [TrimRight(Description.Text), Self.Caption]);
    if Supports(Self, IibSHField) or Supports(Self, IibSHProcParam) then
    begin
      if Supports(Self, IibSHField) then SQL := FormatSQL(SQL_SET_COMMENT_FIELD);
      if Supports(Self, IibSHProcParam) then SQL := FormatSQL(SQL_SET_COMMENT_PROC_PARAM);
      SQL := Format(SQL, [TrimRight(AnsiReplaceText(Description.Text, '''', '''''')), Self.ObjectName, (Self as IibSHDomain).TableName]);
    end;
  end;

  Result := SQL;

end;

procedure TibBTDBObject.SetDescription;
var
  vSQLText: string;
begin
  try
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRWriteParams;
    vSQLText := GetDescriptionStatement(True);
    if BTCLDatabase.DRVQuery.ExecSQL(vSQLText, [TrimRight(Description.Text)], True) then
    begin
      if Assigned(DDLHistory) then
      begin
//        DDLHistory.AddStatement(vSQLText);
        DDLHistory.AddStatement(GetDescriptionStatement(False));
        DDLHistory.CommitNewStatements;
      end;
    end else
      Designer.ShowMsg(BTCLDatabase.DRVQuery.ErrorText, mtError);
  finally
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRReadParams;
  end;
end;

procedure TibBTDBObject.FormGrants;
var
  SQL: string;
  Grant: string;
  TmpList: TStrings;
  OldUserName, NewUserName: string;

  function GetNormalizeName(const ACaption: string): string;
  var
    vCodeNormalizer: IibSHCodeNormalizer;
  begin
    Result := ACaption;
    if Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer) then
      Result := vCodeNormalizer.MetadataNameToSourceDDL(BTCLDatabase, Result);
  end;

begin
  TmpList := TStringList.Create;
  Grants.Clear;
  if Supports(Self, IibSHTable) then SQL := FormatSQL(SQL_GET_GRANTS_FOR_TABLE);
  if Supports(Self, IibSHView) then SQL := FormatSQL(SQL_GET_GRANTS_FOR_TABLE);
  if Supports(Self, IibSHProcedure) then SQL := FormatSQL(SQL_GET_GRANTS_FOR_PROCEDURE);
  if Supports(Self, IibSHRole) then SQL := FormatSQL(SQL_GET_GRANTS_FOR_ROLE);
  SQL := Format(SQL, [Self.Caption]);
  if Length(SQL) = 0 then Exit;

  try
    if BTCLDatabase.DRVQuery.ExecSQL(SQL, [], False) then
      while not BTCLDatabase.DRVQuery.Eof do
      begin
        Grant := EmptyStr;
        if Supports(Self, IibSHTable) or Supports(Self, IibSHView) then
        begin
          if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'S' then Grant := 'SELECT';
          if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'D' then Grant := 'DELETE';
          if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'I' then Grant := 'INSERT';
          if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'U' then Grant := 'UPDATE';
          if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'R' then Grant := 'REFERENCES';

//          if Grant = 'SELECT, DELETE, INSERT, UPDATE, REFERENCE' then Grant := 'ALL PRIVILEGES';

          Grant := Format('GRANT %s ON TABLE %s TO', [Grant, GetNormalizeName(Self.Caption)]);
          case BTCLDatabase.DRVQuery.GetFieldIntValue('USER_TYPE') of
            1: Grant := Format('%s VIEW %s', [Grant, GetNormalizeName(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'))]);
            2: Grant := Format('%s TRIGGER %s', [Grant, GetNormalizeName(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'))]);
            5: Grant := Format('%s PROCEDURE %s', [Grant, GetNormalizeName(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'))]);
            8: if AnsiUpperCase(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME')) <> 'PUBLIC' then
                 Grant := Format('%s USER %s', [Grant, GetNormalizeName(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'))])
               else
                 Grant := Format('%s PUBLIC', [Grant]);
            13: Grant := Format('%s ROLE %s', [Grant, GetNormalizeName(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'))]);
          end;

          if BTCLDatabase.DRVQuery.GetFieldIntValue('GRANT_OPTION') = 1 then
            Grant := Format('%s WITH GRANT OPTION', [Grant]);
          Grant := Format('%s;', [Grant]);
        end;


        if Supports(Self, IibSHProcedure) then
        begin

          if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'X' then
          begin
            Grant := Format('GRANT EXECUTE ON PROCEDURE %s TO', [GetNormalizeName(Self.Caption)]);
            case BTCLDatabase.DRVQuery.GetFieldIntValue('USER_TYPE') of
              1: Grant := Format('%s VIEW %s', [Grant, GetNormalizeName(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'))]);
              2: Grant := Format('%s TRIGGER %s', [Grant, GetNormalizeName(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'))]);
              5: Grant := Format('%s PROCEDURE %s', [Grant, GetNormalizeName(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'))]);
              8: if AnsiUpperCase(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME')) <> 'PUBLIC' then
                   Grant := Format('%s USER %s', [Grant, GetNormalizeName(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'))])
                 else
                   Grant := Format('%s PUBLIC', [Grant]);
              13: Grant := Format('%s ROLE %s', [Grant, GetNormalizeName(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'))]);
            end;
          end;

          if BTCLDatabase.DRVQuery.GetFieldIntValue('GRANT_OPTION') = 1 then
            Grant := Format('%s WITH GRANT OPTION', [Grant]);
          Grant := Format('%s;', [Grant]);
        end;

        if Supports(Self, IibSHRole) then
        begin
          if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'M' then
          begin
            Grant := Format('GRANT %s TO', [GetNormalizeName(Self.Caption)]);
            case BTCLDatabase.DRVQuery.GetFieldIntValue('USER_TYPE') of
              8: if AnsiUpperCase(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME')) <> 'PUBLIC' then
                   Grant := Format('%s USER %s', [Grant, GetNormalizeName(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'))])
                 else
                   Grant := Format('%s PUBLIC', [Grant]);
              13: Grant := Format('%s ROLE %s', [Grant, GetNormalizeName(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'))]);
            end;
          end;

          if BTCLDatabase.DRVQuery.GetFieldIntValue('GRANT_OPTION') > 0 then
            Grant := Format('%s WITH ADMIN OPTION', [Grant]);
          Grant := Format('%s;', [Grant]);
        end;

        if Length(Grant) > 0 then Grants.Add(Grant);
        BTCLDatabase.DRVQuery.Next;
      end;

  finally
    BTCLDatabase.DRVQuery.Transaction.Commit;
    TmpList.Free;
  end;
end;

{ TibBTDBObjectFactory }

constructor TibBTDBObjectFactory.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSuspendedTimer := TTimer.Create(nil);
  FSuspendedTimer.Enabled := False;
  FSuspendedTimer.Interval := 1;
  FSuspendedTimer.OnTimer := SuspendedTimerEvent;
  FSuspendedDescr := TStringList.Create;
end;

destructor TibBTDBObjectFactory.Destroy;
begin
  FSuspendedTimer.Free;
  FSuspendedDescr.Free;
  inherited Destroy;
end;

procedure TibBTDBObjectFactory.SuspendedTimerEvent(Sender: TObject);
var
  I: Integer;
  SHComponent: TSHComponent;
  SHConstraint: IibSHConstraint;
  SHIndex: IibSHIndex;
  SHTrigger: IibSHTrigger;
  TableName: string;
  TableForm: string;
  Table: TSHComponent;
  RunCommands: ISHRunCommands;
begin
  SHComponent := nil;
  TableName := EmptyStr;
  TableForm := EmptyStr;
(*
    FSuspendedTimer: TTimer;
    FSuspendedOldComponent: TSHComponent;
    FSuspendedNewOwnerIID: TGUID;
    FSuspendedNewClassIID: TGUID;
    FSuspendedNewCaption: string;
*)
  FSuspendedTimer.Enabled := False;
  try
    if Assigned(FSuspendedOldComponent) then
      if DestroyComponent(FSuspendedOldComponent) then
        if not IsEqualGUID(FSuspendedNewOwnerIID, IUnknown) then
        begin
          SHComponent := CreateComponent(FSuspendedNewOwnerIID, FSuspendedNewClassIID, FSuspendedNewCaption);
          if Length(Trim(FSuspendedDescr.Text)) > 0 then
          begin
            (SHComponent as IibSHDBObject).Description.Assign(FSuspendedDescr);
            (SHComponent as IibSHDBObject).SetDescription;
            Designer.UpdateObjectInspector;
          end;
        end;
  finally
    FSuspendedOldComponent := nil;
    FSuspendedNewOwnerIID := IUnknown;
    FSuspendedNewClassIID := IUnknown;
    FSuspendedNewCaption := EmptyStr;
    FSuspendedDescr.Clear;
  end;
  //
  // Синхронизация ограничений, индексов и триггеров с оной таблицей
  //
  if Assigned(SHComponent) then
  begin
    Supports(SHComponent, IibSHConstraint, SHConstraint);
    Supports(SHComponent, IibSHIndex, SHIndex );
    Supports(SHComponent, IibSHTrigger, SHTrigger);
    if Assigned(SHConstraint) then
    begin
      TableName := SHConstraint.TableName;
      TableForm := SCallConstraints;
    end;

    if Assigned(SHIndex ) then
    begin
      TableName := SHIndex.TableName;
      TableForm := SCallIndices;
    end;

    if Assigned(SHTrigger) then
    begin
      TableName := SHTrigger.TableName;
      TableForm := SCallTriggers;
    end;

    if Length(TableName) > 0 then
    begin
      Table := Designer.FindComponent(SHComponent.OwnerIID, IibSHTable, TableName);
      if not Assigned(Table) and Assigned(SHTrigger) then
        Table := Designer.FindComponent(SHComponent.OwnerIID, IibSHView, TableName);

      if Assigned(Table) then
        for I := 0 to Pred(Table.ComponentForms.Count) do
        begin
          RunCommands := nil;
          Supports(Table.ComponentForms[I], ISHRunCommands, RunCommands);
          if AnsiSameText(TSHComponentForm(Table.ComponentForms[I]).CallString, TableForm) then
            if Assigned(RunCommands) and RunCommands.CanRefresh then RunCommands.Refresh;
        end;
    end;
  end;
end;

procedure TibBTDBObjectFactory.SuspendedDestroyCreateComponent(OldComponent: TSHComponent;
  const NewOwnerIID, NewClassIID: TGUID; const NewCaption: string);
begin
  FSuspendedOldComponent := OldComponent;
  FSuspendedNewOwnerIID := NewOwnerIID;
  FSuspendedNewClassIID := NewClassIID;
  FSuspendedNewCaption := NewCaption;
  FSuspendedTimer.Enabled := True;
  FSuspendedDescr.Assign((OldComponent as IibSHDBObject).Description);
end;

function TibBTDBObjectFactory.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result :=
    IsEqualGUID(AClassIID, IibSHDBObject) or
    IsEqualGUID(AClassIID, IibSHDomain) or
    IsEqualGUID(AClassIID, IibSHSystemDomain) or
    IsEqualGUID(AClassIID, IibSHSystemGeneratedDomain) or
//      IsEqualGUID(AClassIID, IibSHField) or
    IsEqualGUID(AClassIID, IibSHConstraint) or
//      IsEqualGUID(AClassIID, IibSHSystemGeneratedConstraint) or
    IsEqualGUID(AClassIID, IibSHTable) or
    IsEqualGUID(AClassIID, IibSHSystemTable) or
    IsEqualGUID(AClassIID, IibSHSystemTableTmp) or
    IsEqualGUID(AClassIID, IibSHIndex) or
    IsEqualGUID(AClassIID, IibSHView) or
    IsEqualGUID(AClassIID, IibSHProcedure) or
    IsEqualGUID(AClassIID, IibSHTrigger) or
    IsEqualGUID(AClassIID, IibSHSystemGeneratedTrigger) or
    IsEqualGUID(AClassIID, IibSHGenerator) or
    IsEqualGUID(AClassIID, IibSHException) or
    IsEqualGUID(AClassIID, IibSHFunction) or
    IsEqualGUID(AClassIID, IibSHFilter) or
    IsEqualGUID(AClassIID, IibSHRole) or
    IsEqualGUID(AClassIID, IibSHShadow);
end;

function TibBTDBObjectFactory.CreateComponent(const AOwnerIID, AClassIID: TGUID; const ACaption: string): TSHComponent;
var
  I: Integer;
  OldCaption, NewCaption: string;
  DBObject: IibSHDBObject;
  BTCLDatabase: IibSHDatabase;
  vCallString: string;
begin
  Supports(Designer.CurrentDatabase, IibSHDatabase, BTCLDatabase);
  if not Assigned(BTCLDatabase) and IsEqualGUID(AOwnerIID, IUnknown) and (Length(ACaption) = 0) then
    Designer.AbortWithMsg(Format('%s', [SDatabaseIsNotInterBase]));

  Result := inherited CreateComponent(AOwnerIID, AClassIID, ACaption);

  if Assigned(Result) then
  begin
    Supports(Result,  IibSHDBObject, DBObject);
    if Length(ACaption) > 0 then
    begin
      Result.OwnerIID := AOwnerIID;
      Result.Caption := ACaption;
      if not Designer.ExistsComponent(Result) then
      begin
        Designer.ChangeNotification(Result, SCallSourceDDL, opInsert);
        Application.ProcessMessages;
        if Supports(Result, IibSHDomain) then vCallString := DBObject.BTCLDatabase.DatabaseAliasOptions.DDL.StartDomainForm;
        if Supports(Result, IibSHTable) then vCallString := DBObject.BTCLDatabase.DatabaseAliasOptions.DDL.StartTableForm;
        if Supports(Result, IibSHIndex) then vCallString := DBObject.BTCLDatabase.DatabaseAliasOptions.DDL.StartIndexForm;
        if Supports(Result, IibSHView) then vCallString := DBObject.BTCLDatabase.DatabaseAliasOptions.DDL.StartViewForm;
        if Supports(Result, IibSHProcedure) then vCallString := DBObject.BTCLDatabase.DatabaseAliasOptions.DDL.StartProcedureForm;
        if Supports(Result, IibSHTrigger) then vCallString := DBObject.BTCLDatabase.DatabaseAliasOptions.DDL.StartTriggerForm;
        if Supports(Result, IibSHGenerator) then vCallString := DBObject.BTCLDatabase.DatabaseAliasOptions.DDL.StartGeneratorForm;
        if Supports(Result, IibSHException) then vCallString := DBObject.BTCLDatabase.DatabaseAliasOptions.DDL.StartExceptionForm;
        if Supports(Result, IibSHFunction) then vCallString := DBObject.BTCLDatabase.DatabaseAliasOptions.DDL.StartFunctionForm;
        if Supports(Result, IibSHFilter) then vCallString := DBObject.BTCLDatabase.DatabaseAliasOptions.DDL.StartFilterForm;
        if Supports(Result, IibSHRole) then vCallString := DBObject.BTCLDatabase.DatabaseAliasOptions.DDL.StartRoleForm;

        Designer.ChangeNotification(Result, vCallString, opInsert);
      end else
        Designer.ChangeNotification(Result, opInsert)
//      else
//        Designer.ChangeNotification(Result, SCallSourceDDL, opInsert);
        (* отремить, если надо, чтобы процедуры и триггера стартовали с AlterDDL
        if Supports(Result, IibSHProcedure) or Supports(Result, IibSHTrigger) then
          Designer.ChangeNotification(Result, SCallAlterDDL, opInsert);
        *)
//        if Assigned(DBObject) and (not DBObject.CommitObject or DBObject.BTCLDatabase.WasLostConnect) then
//          FreeAndNil(Result);
    end else
    begin
      if IsEqualGUID(AOwnerIID, IUnknown) then
        Result.OwnerIID := Designer.CurrentDatabase.InstanceIID
      else
        Result.OwnerIID := AOwnerIID;
      // получение названия
      I := 1;
      if not IsEqualGUID(IibSHShadow, AClassIID) then
        OldCaption := Format('NEW_%s_', [UpperCase({GetHintLeftPart(}Designer.GetComponent(AClassIID).GetHintClassFnc{)})])
      else
        OldCaption := EmptyStr;
      NewCaption := Format('%s%d', [OldCaption, I]);
      while Assigned(Designer.FindComponent(Result.OwnerIID, AClassIID, NewCaption)) do
      begin
        Inc(I);
        NewCaption := Format('%s%d', [OldCaption, I]);
      end;
      Result.Caption := {UpperCase(}NewCaption{)}; // <- Dialect 3 ? See old code for CorrectInputObjectName()

      Designer.ChangeNotification(Result, SCallCreateDDL, opInsert);
//      if Assigned(DBObject) and not DBObject.CreateObject then
//        FreeAndNil(Result);
    end;
  end;
end;

initialization

  Register;

end.
 
