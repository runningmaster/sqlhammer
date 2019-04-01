unit ibSHTXTLoaderEditors;

interface

uses
  SysUtils, Classes, DesignIntf, TypInfo,
  SHDesignIntf, ibSHDesignIntf, ibSHCommonEditors;

type
  // -> Property Editors
  TibSHTXTLoaderPropEditor = class(TibBTPropertyEditor)
  private
    FTXTLoader: IibSHTXTLoader;
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

    property TXTLoader: IibSHTXTLoader read FTXTLoader;
  end;

  IibSHTXTLoaderDelimiterPropEditor  = interface
  ['{030422C2-B39F-4A43-B9EF-AD15560D447D}']
  end;

  TibSHTXTLoaderDelimiterPropEditor = class(TibSHTXTLoaderPropEditor, IibSHTXTLoaderDelimiterPropEditor);

implementation

uses
  ibSHConsts, ibSHValues;

{ TibSHTXTLoaderPropEditor }

constructor TibSHTXTLoaderPropEditor.Create(APropertyEditor: TObject);
begin
  inherited Create(APropertyEditor);
  Supports(Component, IibSHTXTLoader, FTXTLoader);
  Assert(TXTLoader <> nil, 'TXTLoader = nil');
  Prepare;
end;

destructor TibSHTXTLoaderPropEditor.Destroy;
begin
  FTXTLoader := nil;
  inherited Destroy;
end;

procedure TibSHTXTLoaderPropEditor.Prepare;
begin
  if Supports(Self, IibSHTXTLoaderDelimiterPropEditor) then
    FValues := FormatProps(Delimiters);
end;

function TibSHTXTLoaderPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes;
  Result := [paValueList];
end;

function TibSHTXTLoaderPropEditor.GetValue: string;
begin
  Result := inherited GetValue;
end;

procedure TibSHTXTLoaderPropEditor.GetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
  AValues.Text := FValues;
end;

procedure TibSHTXTLoaderPropEditor.SetValue(const Value: string);
begin
  inherited SetValue(Value);
//  if Designer.CheckPropValue(Value, FValues) then
//      inherited SetStrValue(Value);
end;

procedure TibSHTXTLoaderPropEditor.Edit;
begin
  inherited Edit;
end;

end.
