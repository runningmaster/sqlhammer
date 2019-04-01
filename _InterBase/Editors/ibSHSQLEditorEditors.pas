unit ibSHSQLEditorEditors;

interface

uses
  SysUtils, Classes, DesignIntf, TypInfo, Dialogs,
  SHDesignIntf, ibSHDesignIntf, ibSHCommonEditors, ibSHMessages;

type
  TibSHSQLEditorPropEditor = class(TibBTPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
  end;

  IibSHAfterExecutePropEditor = interface
  ['{23EC5612-5932-4C6D-9BDB-A409CDA50EDE}']
  end;

  TibBTAfterExecutePropEditor = class(TibSHSQLEditorPropEditor, IibSHAfterExecutePropEditor)
  end;

  IibSHResultTypePropEditor =  interface
  ['{6E492333-06B9-4580-90A1-89348C7F51FB}']
  end;

  TibBTResultTypePropEditor = class(TibSHSQLEditorPropEditor, IibSHResultTypePropEditor)
  end;

  IibSHIsolationLevelPropEditor =  interface
  ['{2143B246-BB04-475F-A3FB-8739A5F5CDC0}']
  end;

  TibBTIsolationLevelPropEditor = class(TibSHSQLEditorPropEditor, IibSHIsolationLevelPropEditor)
  end;



implementation

uses
  ibSHConsts, ibSHValues;

{ TibSHSQLEditorPropEditor }

function TibSHSQLEditorPropEditor.GetAttributes: TPropertyAttributes;
begin
//  if Supports(Self, IibSHSQLPropEditor) or
//     Supports(Self, IibSHDDLPropEditor) then Result := [paReadOnly, paDialog];

  if Supports(Self, IibSHAfterExecutePropEditor) or
     Supports(Self, IibSHResultTypePropEditor) or
     Supports(Self, IibSHIsolationLevelPropEditor) then Result := [paValueList];
end;

function TibSHSQLEditorPropEditor.GetValue: string;
begin
  Result := inherited GetValue;
//  if Supports(Self, IibSHSQLPropEditor) or
//     Supports(Self, IibSHDDLPropEditor) then Result := ResultTypes[1];
end;

procedure TibSHSQLEditorPropEditor.GetValues(AValues: TStrings);
begin
  if Supports(Self, IibSHAfterExecutePropEditor) then AValues.Text := GetAfterExecute;
  if Supports(Self, IibSHResultTypePropEditor) then AValues.Text := GetResultType;
  if Supports(Self, IibSHIsolationLevelPropEditor) then AValues.Text := GetIsolationLevel;
end;

procedure TibSHSQLEditorPropEditor.SetValue(const Value: string);
begin
  if Supports(Self, IibSHAfterExecutePropEditor) then
    if Designer.CheckPropValue(Value, GetAfterExecute) then inherited SetStrValue(Value);
  if Supports(Self, IibSHResultTypePropEditor) then
    if Designer.CheckPropValue(Value, GetResultType) then inherited SetStrValue(Value);
  if Supports(Self, IibSHIsolationLevelPropEditor) then
    if Designer.CheckPropValue(Value, GetIsolationLevel) then inherited SetStrValue(Value);
end;

procedure TibSHSQLEditorPropEditor.Edit;
begin
  inherited Edit;
//  if Supports(Self, IibSHSQLPropEditor) then
//    Designer.ChangeNotification(Component, SCallSQL, opInsert)
//  else
//    if Supports(Self, IibSHDDLPropEditor) then
//      Designer.ChangeNotification(Component, SCallDDL, opInsert);
end;


end.
