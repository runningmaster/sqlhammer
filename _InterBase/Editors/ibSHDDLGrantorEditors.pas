unit ibSHDDLGrantorEditors;

interface

uses
  SysUtils, Classes, DesignIntf, TypInfo,
  SHDesignIntf, ibSHDesignIntf, ibSHCommonEditors;

type
  // -> Property Editors
  TibSHDDLGrantorPropEditor = class(TibBTPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
  end;


  IibSHDDLGrantorPrivilegesForPropEditor = interface
  ['{13851CEB-3890-43A2-9AA5-92A4D7F6455D}']
  end;
  IibSHDDLGrantorGrantsOnPropEditor = interface
  ['{CE03EE87-4D51-42EB-9B91-FDC1BFC76F79}']
  end;
  IibSHDDLGrantorDisplayPropEditor = interface
  ['{E12D36F9-66FF-40E1-9B7F-8E35677CBB9B}']
  end;

  TibSHDDLGrantorPrivilegesForPropEditor = class(TibSHDDLGrantorPropEditor, IibSHDDLGrantorPrivilegesForPropEditor);
  TibSHDDLGrantorGrantsOnPropEditor = class(TibSHDDLGrantorPropEditor, IibSHDDLGrantorGrantsOnPropEditor);
  TibSHDDLGrantorDisplayPropEditor = class(TibSHDDLGrantorPropEditor, IibSHDDLGrantorDisplayPropEditor);

implementation

uses
  ibSHConsts, ibSHValues;

{ TibSHDDLGrantorPropEditor }

function TibSHDDLGrantorPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes;
  if Supports(Self, IibSHDDLGrantorPrivilegesForPropEditor) then Result := [paValueList];
  if Supports(Self, IibSHDDLGrantorGrantsOnPropEditor) then Result := [paValueList];
  if Supports(Self, IibSHDDLGrantorDisplayPropEditor) then Result := [paValueList];
end;

function TibSHDDLGrantorPropEditor.GetValue: string;
begin
  Result := inherited GetValue;
  if Supports(Self, IibSHDDLGrantorPrivilegesForPropEditor) then ;
  if Supports(Self, IibSHDDLGrantorGrantsOnPropEditor) then ;
  if Supports(Self, IibSHDDLGrantorDisplayPropEditor) then ;
end;

procedure TibSHDDLGrantorPropEditor.GetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
  if Supports(Self, IibSHDDLGrantorPrivilegesForPropEditor) then AValues.Text := GetPrivilegesFor;
  if Supports(Self, IibSHDDLGrantorGrantsOnPropEditor) then AValues.Text := GetGrantsOn;
  if Supports(Self, IibSHDDLGrantorDisplayPropEditor) then AValues.Text := GetDisplayGrants;
end;

procedure TibSHDDLGrantorPropEditor.SetValue(const Value: string);
begin
  inherited SetValue(Value);
  if Supports(Self, IibSHDDLGrantorPrivilegesForPropEditor) then
    if Designer.CheckPropValue(Value, GetPrivilegesFor) then
      inherited SetStrValue(Value);
  if Supports(Self, IibSHDDLGrantorGrantsOnPropEditor) then
    if Designer.CheckPropValue(Value, GetGrantsOn) then
      inherited SetStrValue(Value);
  if Supports(Self, IibSHDDLGrantorDisplayPropEditor) then
    if Designer.CheckPropValue(Value, GetDisplayGrants) then
      inherited SetStrValue(Value);
end;

procedure TibSHDDLGrantorPropEditor.Edit;
begin
  inherited Edit;
  if Supports(Self, IibSHDDLGrantorPrivilegesForPropEditor) then ;
  if Supports(Self, IibSHDDLGrantorGrantsOnPropEditor) then ;
  if Supports(Self, IibSHDDLGrantorDisplayPropEditor) then ;
end;

end.
