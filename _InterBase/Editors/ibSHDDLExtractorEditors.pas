unit ibSHDDLExtractorEditors;

interface

uses
  SysUtils, Classes, DesignIntf, TypInfo,
  SHDesignIntf, ibSHDesignIntf, ibSHCommonEditors;

type
  // -> Property Editors
  TibSHDDLExtractorPropEditor = class(TibBTPropertyEditor)
  private
    FDDLExtractor: IibSHDDLExtractor;
    FValues: string;
    procedure Prepare;
  public
    constructor Create(APropertyEditor: TObject); override;
    destructor Destroy; override;

    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;

    property DDLExtractor: IibSHDDLExtractor read FDDLExtractor;
  end;

  IibSHDDLExtractorModePropEditor  = interface
  ['{030422C2-B39F-4A43-B9EF-AD15560D447D}']
  end;
  IibSHDDLExtractorHeaderPropEditor = interface
  ['{A13FA874-A4EA-4D2E-8CF5-BE89FF026A7B}']
  end;

  TibSHDDLExtractorModePropEditor = class(TibSHDDLExtractorPropEditor, IibSHDDLExtractorModePropEditor);
  TibSHDDLExtractorHeaderPropEditor = class(TibSHDDLExtractorPropEditor, IibSHDDLExtractorHeaderPropEditor);

implementation

uses
  ibSHConsts, ibSHValues;

{ TibSHDDLExtractorPropEditor }

constructor TibSHDDLExtractorPropEditor.Create(APropertyEditor: TObject);
begin
  inherited Create(APropertyEditor);
  Supports(Component, IibSHDDLExtractor, FDDLExtractor);
  Assert(DDLExtractor <> nil, 'DDLExtractor = nil');
  Prepare;
end;

destructor TibSHDDLExtractorPropEditor.Destroy;
begin
  FDDLExtractor := nil;
  inherited Destroy;
end;

procedure TibSHDDLExtractorPropEditor.Prepare;
begin
  if Supports(Self, IibSHDDLExtractorModePropEditor) then
    FValues := FormatProps(ExtractModes);
  if Supports(Self, IibSHDDLExtractorHeaderPropEditor) then
    FValues := FormatProps(ExtractHeaders);
end;

function TibSHDDLExtractorPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes;
  Result := [paValueList];
end;

function TibSHDDLExtractorPropEditor.GetValue: string;
begin
  Result := inherited GetValue;
end;

procedure TibSHDDLExtractorPropEditor.GetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
  AValues.Text := FValues;
end;

procedure TibSHDDLExtractorPropEditor.SetValue(const Value: string);
begin
  inherited SetValue(Value);
  if Designer.CheckPropValue(Value, FValues) then
      inherited SetStrValue(Value);
end;

procedure TibSHDDLExtractorPropEditor.Edit;
begin
  inherited Edit;
end;

end.

