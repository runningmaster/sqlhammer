unit ibSHRegisterEditors;

interface

uses
  SysUtils, Classes, Controls, Dialogs, DesignIntf, TypInfo, StrUtils,
  SHDesignIntf, ibSHDesignIntf;

type
  // -> Property Editors
  TibSHDatabaseAliasOptionsPropEditor = class(TSHPropertyEditor)
  public
    function GetValue: string; override;
  end;

  TibBTHostPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

  TibSHServerVersionPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTClientLibraryPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TibBTProtocolPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTPasswordPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;

  TibSHServerPropEditor = class(TSHPropertyEditor)
  private
    FValueList: TStrings;
    FOwnerList: TStrings;
    procedure Prepare;
  public
    constructor Create(APropertyEditor: TObject); override;
    destructor Destroy; override;

    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;

    property ValueList: TStrings read FValueList;
    property OwnerList: TStrings read FOwnerList;
  end;

  TibSHDatabasePropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TibBTIsolationLevelPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTCharsetPropEditor = class(TSHPropertyEditor)
  private
    FValueList: TStrings;
    procedure Prepare;
  public
    constructor Create(APropertyEditor: TObject); override;
    destructor Destroy; override;

    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;

    property ValueList: TStrings read FValueList;
  end;

  TibBTPageSizePropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTSQLDialectPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTStartFromPropEditor = class(TSHPropertyEditor)
  private
    function GetCallStrings: string;
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTConfirmEndTransaction = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTDefaultTransactionAction = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibBTSQLLogPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TibBTAdditionalConnectParamsPropEditor = class(TSHPropertyEditor)
  public
    function GetValue: string; override;
  end;

implementation

uses
  ibSHConsts, ibSHValues;

{ TibSHDatabaseAliasOptionsPropEditor }

function TibSHDatabaseAliasOptionsPropEditor.GetValue: string;
begin
  Result := '::';
end;

{ TibBTHostPropEditor }

function TibBTHostPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes;
//  if AnsiSameText(Value, SLocalhost) = 0 then Result := Result + [paReadOnly];
end;

{ TibSHServerVersionPropEditor }

function TibSHServerVersionPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibSHServerVersionPropEditor.GetValues(AValues: TStrings);
begin
  if Supports(Component, IibSHServerOptions) then
  begin
    // для опций
    if Supports(Component, IibSHBranch) then AValues.Text := GetServerVersionIB;
    if Supports(Component, IfbSHBranch) then AValues.Text := GetServerVersionFB;
  end else
  begin
    if IsEqualGUID(Component.BranchIID, IibSHBranch) then
      AValues.Text := GetServerVersionIB;
    if IsEqualGUID(Component.BranchIID, IfbSHBranch) then
      AValues.Text := GetServerVersionFB;
  end;
end;

procedure TibSHServerVersionPropEditor.SetValue(const Value: string);
begin
  if Supports(Component, IibSHServerOptions) then
  begin
    // для опций
    if Supports(Component, IibSHBranch) and
       Designer.CheckPropValue(Value, GetServerVersionIB) then
    begin
      inherited SetStrValue(Value);
      Designer.UpdateObjectInspector;
    end;

    if Supports(Component, IfbSHBranch) and
       Designer.CheckPropValue(Value, GetServerVersionFB) then
    begin
      inherited SetStrValue(Value);
      Designer.UpdateObjectInspector;
    end;
  end else
  begin
    if IsEqualGUID(Component.BranchIID, IibSHBranch) and
       Designer.CheckPropValue(Value, GetServerVersionIB) then
    begin
      inherited SetStrValue(Value);
      Designer.UpdateObjectInspector;
    end;

    if IsEqualGUID(Component.BranchIID, IfbSHBranch) and
       Designer.CheckPropValue(Value, GetServerVersionFB) then
    begin
      inherited SetStrValue(Value);
      Designer.UpdateObjectInspector;
    end;
  end;
end;

{ TibBTClientLibraryPropEditor }

function TibBTClientLibraryPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TibBTClientLibraryPropEditor.Edit;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := Format('%s', [SOpenDialogClientLibraryFilter]);
    if OpenDialog.Execute then SetStrValue(OpenDialog.FileName);
  finally
    FreeAndNil(OpenDialog);
  end;
end;

{ TibBTProtocolPropEditor }

function TibBTProtocolPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTProtocolPropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetProtocol;
end;

procedure TibBTProtocolPropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetProtocol) then
    inherited SetStrValue(Value);
end;

{ TibBTPasswordPropEditor }

function TibBTPasswordPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TibBTPasswordPropEditor.GetValue: string;
begin
  Result := Format('%s', [SPasswordMask]);
end;

procedure TibBTPasswordPropEditor.Edit;
var
  S: string;
begin
  S := GetPropValue(Component, 'Password');
  inherited SetStrValue(Designer.InputBox(Format('%s', [SInputPassword]), Format('%s', [SPassword]), S, True, '*'));
  Designer.UpdateObjectInspector;
end;

{ TibSHServerPropEditor }

constructor TibSHServerPropEditor.Create(APropertyEditor: TObject);
begin
  inherited Create(APropertyEditor);
  FValueList := TStringList.Create;
  FOwnerList := TStringList.Create;
  Prepare;
end;

destructor TibSHServerPropEditor.Destroy;
begin
  FValueList.Free;
  FOwnerList.Free;
  inherited Destroy;
end;

function TibSHServerPropEditor.GetAttributes: TPropertyAttributes;
begin
  if Component.Tag = 4 then
    Result := [paReadOnly]
  else
    Result := [paValueList, paSortList];
end;

procedure TibSHServerPropEditor.Prepare;
var
  I: Integer;
begin
  ValueList.Clear;
  OwnerList.Clear;
  for I := 0 to Pred(Designer.Components.Count) do
    if Supports(Designer.Components[I], ISHServer) and
       IsEqualGUID(TSHComponent(Designer.Components[I]).BranchIID, Designer.CurrentBranch.ClassIID) then
    begin
      ValueList.Add(Format('%s (%s)  ', [TSHComponent(Designer.Components[I]).Caption, TSHComponent(Designer.Components[I]).CaptionExt]));
      OwnerList.Add(GUIDToString(TSHComponent(Designer.Components[I]).InstanceIID));
    end;
end;

procedure TibSHServerPropEditor.GetValues(AValues: TStrings);
begin
  AValues.Assign(ValueList);
end;

procedure TibSHServerPropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Assigned(Component) and Designer.CheckPropValue(Value, ValueList.Text) then
  begin
    if ValueList.IndexOf(Value) <> -1 then
    begin
      inherited SetStrValue(Value);
      Component.OwnerIID := StringToGUID(OwnerList.Strings[ValueList.IndexOf(Value)]);
      Designer.UpdateObjectInspector;
    end;
  end;
end;

{ TibSHDatabasePropEditor }

function TibSHDatabasePropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TibSHDatabasePropEditor.Edit;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := Format('%s', [SOpenDialogDatabaseFilter]);
    if OpenDialog.Execute then SetStrValue(OpenDialog.FileName);
  finally
    FreeAndNil(OpenDialog);
  end;
end;

{ TibBTIsolationLevelPropEditor }

function TibBTIsolationLevelPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTIsolationLevelPropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetIsolationLevel;
end;

procedure TibBTIsolationLevelPropEditor.SetValue(const Value: string);
begin
  inherited SetStrValue(Value);
end;

{ TibBTCharsetPropEditor }

constructor TibBTCharsetPropEditor.Create(APropertyEditor: TObject);
begin
  inherited Create(APropertyEditor);
  FValueList := TStringList.Create;
  Prepare;
end;

destructor TibBTCharsetPropEditor.Destroy;
begin
  FValueList.Free;
  inherited Destroy;
end;

procedure TibBTCharsetPropEditor.Prepare;
var
  ibBTServerIntf: IibSHServer;
  ibBTDatabaseIntf: IibSHDatabase;
  ibBTDBObjectIntf: IibSHDBObject;
  vServerVersion:string;
begin
  if Assigned(Component) then
  begin
    if Supports(Component, IibSHDatabase, ibBTDatabaseIntf) then
      ibBTServerIntf := ibBTDatabaseIntf.BTCLServer;
    if Supports(Component, IibSHDBObject, ibBTDBObjectIntf) then
      ibBTServerIntf := ibBTDBObjectIntf.BTCLDatabase.BTCLServer;
  end;

  if Assigned(ibBTServerIntf) then
  begin
    vServerVersion:=ibBTServerIntf.Version;
    if AnsiSameText(vServerVersion, SFirebird15) then
      ValueList.Text := GetCharsetFB15
    else
    if AnsiSameText(vServerVersion, SFirebird20) then
      ValueList.Text := GetCharsetFB20
    else
    if AnsiSameText(vServerVersion, SInterBase71) then
      ValueList.Text := GetCharsetIB71
    else  
    if AnsiSameText(vServerVersion, SInterBase75) then
      ValueList.Text := GetCharsetIB75
    else
    if AnsiSameText(vServerVersion, SFirebird21) then
      ValueList.Text := GetCharsetFB21
  end;

  if ValueList.Count = 0 then
    ValueList.Text := GetCharsetFB10;

  if Supports(Component, IibSHServerOptions) then
  begin
    // для опций
    if Supports(Component, IibSHBranch) then ValueList.Text := GetCharsetIB71;
    if Supports(Component, IfbSHBranch) then ValueList.Text := GetCharsetFB20;
  end;
end;

function TibBTCharsetPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
  if Supports(Component, IibSHDBObject) then Result := [paReadOnly];
end;

procedure TibBTCharsetPropEditor.GetValues(AValues: TStrings);
begin
  AValues.Assign(ValueList);
end;

procedure TibBTCharsetPropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, ValueList.Text) then
  begin
    inherited SetStrValue(Value);
    Designer.UpdateObjectInspector;
  end;
end;

{ TibBTPageSizePropEditor }

function TibBTPageSizePropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTPageSizePropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetPageSize;
end;

procedure TibBTPageSizePropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetPageSize) then
    inherited SetStrValue(Value);
end;

{ TibBTSQLDialectPropEditor }

function TibBTSQLDialectPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTSQLDialectPropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetDialect;
end;

procedure TibBTSQLDialectPropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetDialect) then
    inherited SetOrdValue(StrToInt(Value));
end;

{ TibBTStartFromPropEditor }

function TibBTStartFromPropEditor.GetCallStrings: string;
var
  I: Integer;
  vClassIID: TGUID;
  vCallString: string;
begin
  if AnsiSameText(PropName, 'StartDomainForm') then vClassIID := IibSHDomain else
  if AnsiSameText(PropName, 'StartTableForm') then vClassIID := IibSHTable else
  if AnsiSameText(PropName, 'StartIndexForm') then vClassIID := IibSHIndex else
  if AnsiSameText(PropName, 'StartViewForm') then vClassIID := IibSHView else
  if AnsiSameText(PropName, 'StartProcedureForm') then vClassIID := IibSHProcedure else
  if AnsiSameText(PropName, 'StartTriggerForm') then vClassIID := IibSHTrigger else
  if AnsiSameText(PropName, 'StartGeneratorForm') then vClassIID := IibSHGenerator else
  if AnsiSameText(PropName, 'StartExceptionForm') then vClassIID := IibSHException else
  if AnsiSameText(PropName, 'StartFunctionForm') then vClassIID := IibSHFunction else
  if AnsiSameText(PropName, 'StartFilterForm') then vClassIID := IibSHFilter else
  if AnsiSameText(PropName, 'StartRoleForm') then vClassIID := IibSHRole;

  if not IsEqualGUID(vClassIID, IUnknown) then
  begin
    for I := Pred(Designer.GetCallStrings(vClassIID).Count) downto 0 do
    begin
      vCallString := Designer.GetCallStrings(vClassIID)[I];
      Result := Result + SLineBreak + vCallString;
    end;
  end;
  Result := Trim(Result);
end;

function TibBTStartFromPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTStartFromPropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetCallStrings;
end;

procedure TibBTStartFromPropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetCallStrings) then
    inherited SetStrValue(Value);
end;

{ TibBTConfirmEndTransaction }

function TibBTConfirmEndTransaction.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTConfirmEndTransaction.GetValues(AValues: TStrings);
begin
  AValues.Text := GetConfirmEndTransaction;
end;

procedure TibBTConfirmEndTransaction.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetConfirmEndTransaction) then
    inherited SetStrValue(Value);
end;

{ TibBTDefaultTransactionAction }

function TibBTDefaultTransactionAction.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTDefaultTransactionAction.GetValues(AValues: TStrings);
begin
  AValues.Text := GetDefaultTransactionAction;
end;

procedure TibBTDefaultTransactionAction.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetDefaultTransactionAction) then
    inherited SetStrValue(Value);
end;

{ TibBTSQLLogPropEditor }

function TibBTSQLLogPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TibBTSQLLogPropEditor.Edit;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := Format('%s', [SOpenDialogSQLLogFilter]);
    if OpenDialog.Execute then SetStrValue(OpenDialog.FileName);
  finally
    FreeAndNil(OpenDialog);
  end;
end;

{ TibBTAdditionalConnectParamsPropEditor }

function TibBTAdditionalConnectParamsPropEditor.GetValue: string;
begin
  Result := Trim((Component as IibSHDatabase).AdditionalConnectParams.Text);
  if Length(Result) > 0 then
    Result := AnsiReplaceStr(Trim((Component as IibSHDatabase).AdditionalConnectParams.CommaText), ',', ', ');
end;

end.
