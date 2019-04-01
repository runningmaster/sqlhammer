unit ibSHUserManagerEditors;

interface

uses
  SysUtils, Classes, DesignIntf, TypInfo,
  SHDesignIntf;

type
  TibBTAccessModePropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

implementation

uses
  ibSHConsts, ibSHValues;

{ TibBTAccessModePropEditor }

function TibBTAccessModePropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibBTAccessModePropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetAccessMode;
end;

procedure TibBTAccessModePropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetAccessMode) then
    inherited SetStrValue(Value);
end;

end.
