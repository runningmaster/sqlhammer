unit ibSHSQLMonitorEditors;

interface

uses
  SysUtils, Classes, DesignIntf, TypInfo, StrUtils,
  SHDesignIntf, ibSHDesignIntf, ibSHCommonEditors;

type
  TibSHSQLMonitorPropEditor = class(TibBTPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
  end;

  IibSHSQLMonitorFilterPropEditor = interface
  ['{B9B660B1-9DFE-4546-A796-94F71CE90F6B}']
  end;

  TibSHSQLMonitorFilterPropEditor = class(TibSHSQLMonitorPropEditor, IibSHSQLMonitorFilterPropEditor);

implementation

uses
  ibSHConsts, ibSHValues;

{ TibSHSQLMonitorPropEditor }

function TibSHSQLMonitorPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes;
end;

function TibSHSQLMonitorPropEditor.GetValue: string;
var
  SQLMonitor: IibSHSQLMonitor;
begin
  Result := inherited GetValue;
  if Supports(Self, IibSHSQLMonitorFilterPropEditor) and Supports(Component, IibSHSQLMonitor, SQLMonitor) then
  begin
    Result := Trim(SQLMonitor.Filter.CommaText);
    Result := AnsiReplaceStr(Result, '"', '');
    Result := AnsiReplaceStr(Result, ',', ', ');
  end;
end;

procedure TibSHSQLMonitorPropEditor.GetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
end;

procedure TibSHSQLMonitorPropEditor.SetValue(const Value: string);
begin
 inherited SetValue(Value);
end;

procedure TibSHSQLMonitorPropEditor.Edit;
begin
  inherited Edit;
end;

end.
