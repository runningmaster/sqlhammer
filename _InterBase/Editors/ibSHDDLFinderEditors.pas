unit ibSHDDLFinderEditors;

interface

uses
  SysUtils, Classes, DesignIntf,
  SHDesignIntf, ibSHDesignIntf, ibSHCommonEditors;

type
  TibSHDDLFinderPropEditor = class(TibBTPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
  end;

  IibSHLookInPropEditor = interface
  ['{122B3B9B-1BB7-4880-A160-D9A0A67CE41B}']
  end;

  TibBTLookInPropEditor = class(TibSHDDLFinderPropEditor, IibSHLookInPropEditor)
  end;

implementation

{ TibSHDDLFinderPropEditor }

function TibSHDDLFinderPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes;
end;

function TibSHDDLFinderPropEditor.GetValue: string;
var
  DDLFinder: IibSHDDLFinder;
begin
  Result := inherited GetValue;
  if Supports(Self, IibSHLookInPropEditor) and Supports(Component, IibSHDDLFinder, DDLFinder) then
  begin
    Result := EmptyStr;

    if DDLFinder.LookIn.Domains then Result := Format('%s, %s', [Result, 'Domains']);
    if DDLFinder.LookIn.Tables then Result := Format('%s, %s', [Result, 'Tables']);
    if DDLFinder.LookIn.Constraints then Result := Format('%s, %s', [Result, 'Constraints']);
    if DDLFinder.LookIn.Indices then Result := Format('%s, %s', [Result, 'Indices']);
    if DDLFinder.LookIn.Views then Result := Format('%s, %s', [Result, 'Views']);
    if DDLFinder.LookIn.Procedures then Result := Format('%s, %s', [Result, 'Procedures']);
    if DDLFinder.LookIn.Triggers then Result := Format('%s, %s', [Result, 'Triggers']);
    if DDLFinder.LookIn.Generators then Result := Format('%s, %s', [Result, 'Generators']);
    if DDLFinder.LookIn.Exceptions then Result := Format('%s, %s', [Result, 'Exceptions']);
    if DDLFinder.LookIn.Functions then Result := Format('%s, %s', [Result, 'Functions']);
    if DDLFinder.LookIn.Filters then Result := Format('%s, %s', [Result, 'Filters']);
    if DDLFinder.LookIn.Roles then Result := Format('%s, %s', [Result, 'Roles']);
    if Pos(', ', Result) = 1 then Result := Copy(Result, 3, MaxInt);
    if Length(Result) = 0 then Result := '< none >';
  end;
end;

procedure TibSHDDLFinderPropEditor.GetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
end;

procedure TibSHDDLFinderPropEditor.SetValue(const Value: string);
begin
  inherited SetValue(Value);
end;

procedure TibSHDDLFinderPropEditor.Edit;
begin
  inherited Edit;
end;

end.
