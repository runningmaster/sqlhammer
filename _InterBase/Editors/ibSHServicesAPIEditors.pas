unit ibSHServicesAPIEditors;

interface

uses
  SysUtils, Classes, DesignIntf, TypInfo, Dialogs,
  SHDesignIntf, ibSHDesignIntf, ibSHCommonEditors;

type
  // -> Component Editors
  // -> Property Editors
  TibSHServicesPropEditor = class(TibBTPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
  end;

  IibSHServicesStopAfterPropEditor = interface
  ['{B7A20BFE-350B-4972-B472-027FB4492539}']
  end;
  IibSHServicesShutdownModePropEditor = interface
  ['{FFB34663-CA86-44F5-AAE9-7BC3BB15FAE4}']
  end;
  IibSHServicesPageSizePropEditor = interface
  ['{A94C6151-583F-48C7-B586-43E776D12CEB}']
  end;
  IibSHServicesCharsetPropEditor = interface
  ['{7F24E38C-205B-4295-9188-2AF44625B79A}']
  end;
  IibSHServicesSQLDialectPropEditor = interface
  ['{C24552AF-5CDE-481B-B552-2D167353D735}']
  end;
  IibSHServicesGlobalActionPropEditor = interface
  ['{BE59E863-BC79-4586-BF7F-F944372D60BE}']
  end;
  IibSHServicesFixLimboPropEditor = interface
  ['{3B153E64-1353-41A0-955E-15B83608F947}']
  end;

  TibSHServicesStopAfterPropEditor = class(TibSHServicesPropEditor, IibSHServicesStopAfterPropEditor);
  TibSHServicesShutdownModePropEditor = class(TibSHServicesPropEditor, IibSHServicesShutdownModePropEditor);
  TibSHServicesPageSizePropEditor = class(TibSHServicesPropEditor, IibSHServicesPageSizePropEditor);
  TibSHServicesCharsetPropEditor = class(TibSHServicesPropEditor, IibSHServicesCharsetPropEditor);
  TibSHServicesSQLDialectPropEditor = class(TibSHServicesPropEditor, IibSHServicesSQLDialectPropEditor);
  TibSHServicesGlobalActionPropEditor = class(TibSHServicesPropEditor, IibSHServicesGlobalActionPropEditor);
  TibSHServicesFixLimboPropEditor = class(TibSHServicesPropEditor, IibSHServicesFixLimboPropEditor);

implementation

uses
  ibSHConsts, ibSHValues;

{ TibSHServicesPropEditor }

function TibSHServicesPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes;
  if Supports(Self, IibSHServicesStopAfterPropEditor) then Result := [paValueList];
  if Supports(Self, IibSHServicesShutdownModePropEditor) then Result := [paValueList];
  if Supports(Self, IibSHServicesPageSizePropEditor) then
    if not Supports(Component, IibSHDatabaseProps) then Result := [paValueList];
  if Supports(Self, IibSHServicesCharsetPropEditor) then Result := [paReadOnly];
  if Supports(Self, IibSHServicesSQLDialectPropEditor) then Result := [paValueList];
  if Supports(Self, IibSHServicesGlobalActionPropEditor) then Result := [paValueList];
  if Supports(Self, IibSHServicesFixLimboPropEditor) then Result := [paReadOnly, paDialog];
end;

function TibSHServicesPropEditor.GetValue: string;
begin
  Result := inherited GetValue;
  if Supports(Self, IibSHServicesStopAfterPropEditor) then ;
  if Supports(Self, IibSHServicesShutdownModePropEditor) then ;
  if Supports(Self, IibSHServicesPageSizePropEditor) then ;
  if Supports(Self, IibSHServicesCharsetPropEditor) then ;
  if Supports(Self, IibSHServicesSQLDialectPropEditor) then ;
  if Supports(Self, IibSHServicesGlobalActionPropEditor) then ;
  if Supports(Self, IibSHServicesFixLimboPropEditor) then Result := '>>';
end;

procedure TibSHServicesPropEditor.GetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
  if Supports(Self, IibSHServicesStopAfterPropEditor) then  AValues.Text := GetStopAfter;
  if Supports(Self, IibSHServicesShutdownModePropEditor) then  AValues.Text := GetShutdownMode;
  if Supports(Self, IibSHServicesPageSizePropEditor) then
    if not Supports(Component, IibSHDatabaseProps) then AValues.Text := GetPageSize;
  if Supports(Self, IibSHServicesCharsetPropEditor) then ;
  if Supports(Self, IibSHServicesSQLDialectPropEditor) then AValues.Text := GetDialect(True);
  if Supports(Self, IibSHServicesGlobalActionPropEditor) then AValues.Text := GetGlobalAction;
  if Supports(Self, IibSHServicesFixLimboPropEditor) then ;
end;

procedure TibSHServicesPropEditor.SetValue(const Value: string);
begin
  inherited SetValue(Value);
  if Supports(Self, IibSHServicesStopAfterPropEditor) then
    if Designer.CheckPropValue(Value, GetStopAfter) then
      inherited SetStrValue(Value);
  if Supports(Self, IibSHServicesShutdownModePropEditor) then
    if Designer.CheckPropValue(Value, GetShutdownMode) then
      inherited SetStrValue(Value);
  if Supports(Self, IibSHServicesPageSizePropEditor) then
    if Designer.CheckPropValue(Value, GetPageSize) then
      inherited SetStrValue(Value);
  if Supports(Self, IibSHServicesCharsetPropEditor) then ;
  if Supports(Self, IibSHServicesSQLDialectPropEditor) then
    if Designer.CheckPropValue(Value, GetDialect(True)) then
      inherited SetStrValue(Value);
  if Supports(Self, IibSHServicesGlobalActionPropEditor) then
    if Designer.CheckPropValue(Value, GetGlobalAction) then
      inherited SetStrValue(Value);
end;

procedure TibSHServicesPropEditor.Edit;
begin
  inherited Edit;
  if Supports(Self, IibSHServicesStopAfterPropEditor) then ;
  if Supports(Self, IibSHServicesShutdownModePropEditor) then ;
  if Supports(Self, IibSHServicesFixLimboPropEditor) then
    Designer.ShowMsg(Format('No pending transactions were found', []), mtInformation);
end;

end.
