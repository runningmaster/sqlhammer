unit ibSHSQLPlayerEditors;

interface

uses
  SysUtils, Classes, DesignIntf, TypInfo,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHDefaultSQLDialectPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
  end;

  TibSHSQLPlayerModePropEditor = class(TSHPropertyEditor)
  private
    FValues: string;
    procedure Prepare;
  public
    constructor Create(APropertyEditor: TObject); override;
    destructor Destroy; override;

    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;

//    property DDLExtractor: IibSHDDLExtractor read FDDLExtractor;
  end;

  TibSHSQLPlayerAfterErrorPropEditor = class(TSHPropertyEditor)
  private
    FValues: string;
    procedure Prepare;
  public
    constructor Create(APropertyEditor: TObject); override;
    destructor Destroy; override;

    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;

//    property DDLExtractor: IibSHDDLExtractor read FDDLExtractor;
  end;

implementation

uses
  ibSHConsts, ibSHValues, ibSHMessages;

{ TibBTDefaultSQLDialectPropEditor }

function TibSHDefaultSQLDialectPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibSHDefaultSQLDialectPropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := GetDefaultSQLDialect;
end;

procedure TibSHDefaultSQLDialectPropEditor.SetValue(const Value: string);
begin
  if Assigned(Designer) and Designer.CheckPropValue(Value, GetDefaultSQLDialect) then
    inherited SetOrdValue(StrToInt(Value));
end;

{ TibSHSQLPlayerModePropEditor }

constructor TibSHSQLPlayerModePropEditor.Create(
  APropertyEditor: TObject);
begin
  inherited Create(APropertyEditor);
  Prepare;
end;

destructor TibSHSQLPlayerModePropEditor.Destroy;
begin
  inherited;
end;

procedure TibSHSQLPlayerModePropEditor.Prepare;
begin
  FValues := FormatProps(PlayerModes);
end;

function TibSHSQLPlayerModePropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibSHSQLPlayerModePropEditor.GetValues(AValues: TStrings);
begin
  AValues.Text := FValues;
end;

procedure TibSHSQLPlayerModePropEditor.SetValue(const Value: string);
begin
//  inherited SetValue(Value);
  if Designer.CheckPropValue(Value, FValues) then
    inherited SetStrValue(Value);
end;

{ TibSHSQLPlayerAfterErrorPropEditor }

constructor TibSHSQLPlayerAfterErrorPropEditor.Create(
  APropertyEditor: TObject);
begin
  inherited Create(APropertyEditor);
  Prepare;
end;

destructor TibSHSQLPlayerAfterErrorPropEditor.Destroy;
begin
  inherited;
end;

procedure TibSHSQLPlayerAfterErrorPropEditor.Prepare;
begin
  FValues := FormatProps(PlayerAfterErrors);
end;

function TibSHSQLPlayerAfterErrorPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TibSHSQLPlayerAfterErrorPropEditor.GetValues(
  AValues: TStrings);
begin
  AValues.Text := FValues;
end;

procedure TibSHSQLPlayerAfterErrorPropEditor.SetValue(
  const Value: string);
begin
  if Designer.CheckPropValue(Value, FValues) then
    inherited SetStrValue(Value);
end;

end.


