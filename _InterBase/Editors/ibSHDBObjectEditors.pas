unit ibSHDBObjectEditors;

interface

uses
  SysUtils, Classes, Controls, StrUtils, DesignIntf, TypInfo, Dialogs,
  SHDesignIntf,
  ibSHDesignIntf, ibSHCommonEditors;

type
  // -> Property Editors
  TibBTDBObjectPropEditor = class(TibBTPropertyEditor)
  private
    FDBObject: IibSHDBObject;
  public
    constructor Create(APropertyEditor: TObject); override;
    destructor Destroy; override;

    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;

    property DBObject: IibSHDBObject read FDBObject;
  end;

  IibSHDBDescriptionProp  = interface
  ['{39E8022F-8802-443C-BED2-A0988C3654AE}']
  end;

//  IibSHDBSourceDDLProp = interface
//  ['{B166E696-1544-4C92-AD52-667301F335A5}']
//  end;

  IibSHDBParams = interface
  ['{D6F62758-DFEA-4F6B-A1E1-311647463458}']
  end;

  IibSHDBReturns = interface
  ['{251C3DFE-EDDD-4147-8B11-E770956C5C02}']
  end;

  IibSHDBFields = interface
  ['{7ACECF5B-BF40-4AC9-9510-4967B4D8FB30}']
  end;

  IibSHDBReferenceFields = interface
  ['{476159EF-22D0-43C8-A255-F779890E79AB}']
  end;

  IibSHDBConstraints = interface
  ['{40BB81AE-6B71-4E9E-AF90-19E45C42ABD9}']
  end;

  IibSHDBIndices = interface
  ['{43D2B734-110B-48CC-9361-E5F1DE31FB4C}']
  end;

  IibSHDBTriggers = interface
  ['{1CE8C3F7-BFA6-413C-A9EF-1E7B7E092C0E}']
  end;

  IibSHDBGrants = interface
  ['{BDF6C39E-C7E8-42CA-99E5-5B2600BFF7D5}']
  end;

  IibSHDBTRParams = interface
  ['{C30DC65E-B8F7-4BE9-9542-9AC299443D50}']
  end;

//  IibSHDBBLR = interface
//  ['{1D2ABDF1-52D8-4809-AC62-B3877D1A0FE0}']
//  end;

  IibSHDBDefaultExpression = interface
  ['{65F0AE3C-897C-4258-952A-5116B676E438}']
  end;

  IibSHDBCheckConstraint = interface
  ['{96C53198-F13B-47B6-8317-77D9B24CF5AA}']
  end;

  IibSHDBCheckSource = interface
  ['{02D5347D-B9A3-46EC-9FD7-AF3916FECEDF}']
  end;

  IibSHComputedSource = interface
  ['{F9D83140-04F8-4D61-AB71-B6839EFF0BFE}']
  end;

  TibBTDBDescriptionProp = class(TibBTDBObjectPropEditor, IibSHDBDescriptionProp);
//  TibBTDBSourceDDLProp = class(TibBTDBObjectPropEditor, IibSHDBSourceDDLProp);
  TibBTDBParams = class(TibBTDBObjectPropEditor, IibSHDBParams);
  TibBTDBReturns = class(TibBTDBObjectPropEditor, IibSHDBReturns);
  TibBTDBFields = class(TibBTDBObjectPropEditor, IibSHDBFields);
  TibBTDBReferenceFields = class(TibBTDBObjectPropEditor, IibSHDBReferenceFields);
  TibBTDBConstraints = class(TibBTDBObjectPropEditor, IibSHDBConstraints);
  TibBTDBIndices = class(TibBTDBObjectPropEditor, IibSHDBIndices);
  TibBTDBTriggers = class(TibBTDBObjectPropEditor, IibSHDBTriggers);
  TibBTDBGrants = class(TibBTDBObjectPropEditor, IibSHDBGrants);
  TibBTDBTRParams = class(TibBTDBObjectPropEditor, IibSHDBTRParams);
//  TibBTDBBLR = class(TibBTDBObjectPropEditor, IibSHDBBLR);
  TibBTDBDefaultExpression = class(TibBTDBObjectPropEditor, IibSHDBDefaultExpression);
  TibBTDBCheckConstraint = class(TibBTDBObjectPropEditor, IibSHDBCheckConstraint);
  TibBTDBCheckSource = class(TibBTDBObjectPropEditor, IibSHDBCheckSource);
  TibBTComputedSource = class(TibBTDBObjectPropEditor, IibSHComputedSource);

  TibBTTableNamePropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTStatusPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTTypePrefixPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTTypeSuffixPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTRecordCountEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TibBTChangeCountPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TibBTDataTypePropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTCollatePropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTBlobSubTypePropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTMechanismPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTPrecisionPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTScalePropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

implementation

uses
  ibSHConsts, ibSHValues;

{ TibBTDBObjectPropEditor }

constructor TibBTDBObjectPropEditor.Create(APropertyEditor: TObject);
begin
  inherited Create(APropertyEditor);
  Supports(Component, IibSHDBObject, FDBObject);
end;

destructor TibBTDBObjectPropEditor.Destroy;
begin
  inherited Destroy;
end;

function TibBTDBObjectPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [];

  if Supports(Self, IibSHDBParams) or
     Supports(Self, IibSHDBReturns) or
     Supports(Self, IibSHDBDefaultExpression) or
     Supports(Self, IibSHDBCheckConstraint) or
     Supports(Self, IibSHDBCheckSource) or
     Supports(Self, IibSHComputedSource) then
    Result := Result + [paReadOnly];

  if Supports(Self, IibSHDBDescriptionProp) or
//     Supports(Self, IibSHDBSourceDDLProp) or
     Supports(Self, IibSHDBGrants) or
     Supports(Self, IibSHDBTRParams) or
//     Supports(Self, IibSHDBBLR) or
     Supports(Self, IibSHDBFields) or
     Supports(Self, IibSHDBReferenceFields) or
     Supports(Self, IibSHDBConstraints) or
     Supports(Self, IibSHDBIndices) or
     Supports(Self, IibSHDBTriggers) then
    Result := Result + [paReadOnly, paDialog];

  if (Supports(DBObject, IibSHIndex) or Supports(DBObject, IibSHConstraint)) and
     Supports(Self, IibSHDBFields) then
    Result := Result - [paDialog];

  if Supports(DBObject, IibSHConstraint) and
     Supports(Self, IibSHDBReferenceFields) then
    Result := Result - [paDialog];

end;

function TibBTDBObjectPropEditor.GetValue: string;
begin
  Result := inherited GetValue;
  if Supports(Self, IibSHDBDescriptionProp) then
    Result := TrimRight(DBObject.Description.Text);

//  if Supports(Self, IibSHDBSourceDDLProp) or
//     Supports(Self, IibSHDBBLR) then
//    Result := 'Text';

  if Supports(Self, IibSHDBParams) or
     Supports(Self, IibSHDBReturns) or
     Supports(Self, IibSHDBFields) or
     Supports(Self, IibSHDBReferenceFields) or
     Supports(Self, IibSHDBConstraints) or
     Supports(Self, IibSHDBIndices) or
     Supports(Self, IibSHDBTriggers) or
     Supports(Self, IibSHDBTRParams) then
  begin
    if Supports(Self, IibSHDBParams) then Result := Trim(DBObject.Params.CommaText);
    if Supports(Self, IibSHDBReturns) then Result := Trim(DBObject.Returns.CommaText);
    if Supports(Self, IibSHDBFields) then Result := Trim(DBObject.Fields.CommaText);
    if Supports(Self, IibSHDBReferenceFields) then Result := Trim((DBObject as IibSHConstraint).ReferenceFields.CommaText);
    if Supports(Self, IibSHDBConstraints) then Result := Trim(DBObject.Constraints.CommaText);
    if Supports(Self, IibSHDBIndices) then Result := Trim(DBObject.Indices.CommaText);
    if Supports(Self, IibSHDBTriggers) then Result := Trim(DBObject.Triggers.CommaText);
    if Supports(Self, IibSHDBTRParams) then Result := Trim(DBObject.TRParams.CommaText);
    Result := AnsiReplaceStr(Result, '"', '');
    Result := AnsiReplaceStr(Result, ',', ', '{ + SLineBreak});
  end;

  if Supports(Self, IibSHDBDefaultExpression) then
    Result := Trim((DBObject as IibSHDomain).DefaultExpression.Text);
  if Supports(Self, IibSHDBCheckConstraint) then
    Result := Trim((DBObject as IibSHDomain).CheckConstraint.Text);
  if Supports(Self, IibSHDBCheckSource) then
    Result := Trim((DBObject as IibSHConstraint).CheckSource.Text);
  if Supports(Self, IibSHComputedSource) then
    Result := Trim((DBObject as IibSHField).ComputedSource.Text);


  if Supports(Self, IibSHDBGrants) then Result := 'Show';
end;

procedure TibBTDBObjectPropEditor.GetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
end;

procedure TibBTDBObjectPropEditor.SetValue(const Value: string);
begin
  inherited SetValue(Value);
end;

procedure TibBTDBObjectPropEditor.Edit;
begin
  if Supports(Self, IibSHDBParams) or
     Supports(Self, IibSHDBReturns) or
     Supports(Self, IibSHDBTRParams) then
  begin
    if IsPositiveResult(Designer.ShowModal(Component, PropName)) then Designer.UpdateObjectInspector;
    Exit;
  end;

//  if Supports(Self, IibSHDBSourceDDLProp) then
//  begin
//    if Designer.ExistsComponent(Component, SCallSourceDDL) then
//      Designer.ChangeNotification(Component, SCallSourceDDL, opInsert)
//    else
//      DBObject.CommitObject;
//    Exit;
//  end;

//  if Supports(Self, IibSHDBBLR) then
//  begin
//    Designer.UnderConstruction;
//    Exit;
//  end;

  if Supports(Self, IibSHDBDescriptionProp) then
  begin
    Designer.ChangeNotification(Component, SCallDescription, opInsert);
    Exit;
  end;

  if Supports(Self, IibSHDBFields) then
  begin
    Designer.ChangeNotification(Component, SCallFields, opInsert);
    Exit;
  end;

  if Supports(Self, IibSHDBConstraints) then
  begin
    Designer.ChangeNotification(Component, SCallConstraints, opInsert);
    Exit;
  end;

  if Supports(Self, IibSHDBIndices) then
  begin
    Designer.ChangeNotification(Component, SCallIndices, opInsert);
    Exit;
  end;

  if Supports(Self, IibSHDBTriggers) then
  begin
    Designer.ChangeNotification(Component, SCallTriggers, opInsert);
    Exit;
  end;
end;

{ TibBTTableNamePropEditor }

function TibBTTableNamePropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTTableNamePropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetTableList;
end;

procedure TibBTTableNamePropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetTableList) then
    inherited SetStrValue(Value);
end;

{ TibBTStatusPropEditor }

function TibBTStatusPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTStatusPropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetStatus;
end;

procedure TibBTStatusPropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetStatus) then
    inherited SetStrValue(Value);
end;

{ TibBTTypePrefixPropEditor }

function TibBTTypePrefixPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTTypePrefixPropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetTypePrefix;
end;

procedure TibBTTypePrefixPropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetTypePrefix) then
    inherited SetStrValue(Value);
end;

{ TibBTTypeSuffixPropEditor }

function TibBTTypeSuffixPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTTypeSuffixPropEditor.GetValues(AValues: TStrings);
begin
  // TODO проверить Component на версию сервера GetTypeSuffixIB или GetTypeSuffixFB
  AValues.Text := GetTypeSuffixFB;
end;

procedure TibBTTypeSuffixPropEditor.SetValue(const Value: string);
begin
  // TODO проверить Component на версию сервера GetTypeSuffixYA или GetTypeSuffixFB
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetTypeSuffixFB) then
    inherited SetStrValue(Value);
end;

{ TibBTRecordCountEditor }

function TibBTRecordCountEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paNotNestable, paReadOnly];
end;

procedure TibBTRecordCountEditor.Edit;
var
  ibBTTableIntf: IibSHTable;
  ibBTViewIntf: IibSHView;
begin
  if Assigned(Component) and Assigned(Designer) then
  begin
    if Supports(Component, IibSHTable, ibBTTableIntf) then ibBTTableIntf.SetRecordCount;
    if Supports(Component, IibSHView, ibBTViewIntf) then ibBTViewIntf.SetRecordCount;
    Designer.UpdateObjectInspector;
  end;
end;

{ TibBTChangeCountPropEditor }

function TibBTChangeCountPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paNotNestable, paReadOnly];
end;

procedure TibBTChangeCountPropEditor.Edit;
var
  ibBTTableIntf: IibSHTable;
begin
  if Assigned(Component) and Assigned(Designer) then
  begin
    if Supports(Component, IibSHTable, ibBTTableIntf) then ibBTTableIntf.SetChangeCount;
    Designer.UpdateObjectInspector;
  end;
end;

{ TibBTDataTypePropEditor }

function TibBTDataTypePropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTDataTypePropEditor.GetValues(AValues: TStrings);
begin
  // TODO деребанится по версии сервера и диалекта
  AValues.Text := GetDataTypeFB15;
end;

procedure TibBTDataTypePropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetDataTypeFB15) then
  begin
    inherited SetStrValue(Value);
    Designer.UpdateObjectInspector;
  end;
end;

{ TibBTCollatePropEditor }

function TibBTCollatePropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TibBTCollatePropEditor.GetValues(AValues: TStrings);
begin
  // TODO from ServerVersions and ID
  AValues.Text := GetCollateFB15;
end;

procedure TibBTCollatePropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetCollateFB15) then
    inherited SetStrValue(Value);
end;

{ TibBTBlobSubTypePropEditor }

function TibBTBlobSubTypePropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTBlobSubTypePropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetBlobSubType;
end;

procedure TibBTBlobSubTypePropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetBlobSubType) then
    inherited SetStrValue(Value);
end;

{ TibBTMechanismPropEditor }

function TibBTMechanismPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTMechanismPropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetMechanism;
end;

procedure TibBTMechanismPropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetMechanism) then
    inherited SetStrValue(Value);
end;


{ TibBTPrecisionPropEditor }

function TibBTPrecisionPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

function TibBTPrecisionPropEditor.GetValue: string;
begin
  Result := IntToStr(GetOrdValue(0));
end;

procedure TibBTPrecisionPropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetPrecision;
end;

procedure TibBTPrecisionPropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetPrecision) then
    inherited SetOrdValue(StrToInt(Value));
end;

{ TibBTScalePropEditor }

function TibBTScalePropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

function TibBTScalePropEditor.GetValue: string;
begin
  Result := IntToStr(GetOrdValue(0));
end;

procedure TibBTScalePropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetScale;
end;

procedure TibBTScalePropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetScale) then
    inherited SetOrdValue(StrToInt(Value));
end;

end.

