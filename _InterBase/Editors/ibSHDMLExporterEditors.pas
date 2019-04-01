unit ibSHDMLExporterEditors;

interface

uses
  Classes, SysUtils, DesignIntf,
  SHDesignIntf, ibSHDesignIntf, ibSHCommonEditors;

type
  // -> Property Editors
  TibSHDMLExporterModePropEditor = class(TibBTPropertyEditor)
  private
    FValues: string;
    procedure Prepare;
  public
    constructor Create(APropertyEditor: TObject); override;

    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;

  end deprecated;

  TibSHDMLExporterOutputPropEditor = class(TibBTPropertyEditor)
  private
    FValues: string;
    procedure Prepare;
  public
    constructor Create(APropertyEditor: TObject); override;

    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;

  end;

  TibSHDMLExporterStatementTypePropEditor = class(TibBTPropertyEditor)
  private
    FValues: string;
    procedure Prepare;
  public
    constructor Create(APropertyEditor: TObject); override;

    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;

  end;

implementation

uses
  ibSHConsts, ibSHValues;

{ TibBTDMLExporterModePropEditor }

constructor TibSHDMLExporterModePropEditor.Create(APropertyEditor: TObject);
begin
  inherited Create(APropertyEditor);
  Prepare;
end;

procedure TibSHDMLExporterModePropEditor.Prepare;
begin
  FValues := FormatProps(DMLExporterModes);
end;

function TibSHDMLExporterModePropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibSHDMLExporterModePropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := FValues;
end;

procedure TibSHDMLExporterModePropEditor.SetValue(const Value: string);
begin
  if Designer.CheckPropValue(Value, FValues) then
    inherited SetStrValue(Value);
end;

{ TibSHDMLExporterOutputPropEditor }

constructor TibSHDMLExporterOutputPropEditor.Create(
  APropertyEditor: TObject);
begin
  inherited Create(APropertyEditor);
  Prepare;
end;

function TibSHDMLExporterOutputPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibSHDMLExporterOutputPropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := FValues;
end;

procedure TibSHDMLExporterOutputPropEditor.Prepare;
begin
  FValues := FormatProps(ExtractorOutputs);
end;

procedure TibSHDMLExporterOutputPropEditor.SetValue(const Value: string);
begin
  if Designer.CheckPropValue(Value, FValues) then
    inherited SetStrValue(Value);
end;

{ TibBTDMLExporterExportAsPropEditor }

constructor TibSHDMLExporterStatementTypePropEditor.Create(
  APropertyEditor: TObject);
begin
  inherited Create(APropertyEditor);
  Prepare;
end;

procedure TibSHDMLExporterStatementTypePropEditor.Prepare;
begin
  FValues := FormatProps(ExtractorStatementType);
end;

function TibSHDMLExporterStatementTypePropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibSHDMLExporterStatementTypePropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := FValues;
end;

procedure TibSHDMLExporterStatementTypePropEditor.SetValue(const Value: string);
begin
  if Designer.CheckPropValue(Value, FValues) then
    inherited SetStrValue(Value);
end;

end.




