unit ibSHDDLCommentatorEditors;

interface

uses
  SysUtils, Classes, DesignIntf, TypInfo,
  SHDesignIntf, ibSHDesignIntf, ibSHCommonEditors;

type
  // -> Property Editors
  TibSHDDLCommentatorModePropEditor = class(TibBTPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

implementation

uses
  ibSHConsts, ibSHValues;

{ TibSHDDLCommentatorModePropEditor }

function TibSHDDLCommentatorModePropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibSHDDLCommentatorModePropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := FormatProps(CommentModes);
end;

procedure TibSHDDLCommentatorModePropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, FormatProps(CommentModes)) then
    inherited SetStrValue(Value);
end;

end.
