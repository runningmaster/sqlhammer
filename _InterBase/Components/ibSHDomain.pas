unit ibSHDomain;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;

type
  TibBTDomain = class(TibBTDBObject, IibSHDomain, IibSHFuncParam)
  private
//    FExistsPrecision: Boolean;
    FFieldTypeID: Integer;
    FSubTypeID: Integer;
    FCharsetID: Integer;
    FCollateID: Integer;
    FArrayDimID: Integer;

    FDomain: string;
    FDataType: string;
    FDataTypeExt: string;
    FDataTypeField: string;
    FDataTypeFieldExt: string;
    FLength: Integer;
    FPrecision: Integer;
    FScale: Integer;
    FNotNull: Boolean;
    FNullType: string;
    FSubType: string;
    FSegmentSize: Integer;
    FCharset: string;
    FCollate: string;
    FDefaultExpression: TStrings;
    FCheckConstraint: TStrings;
    FArrayDim: string;

    FTableName: string;
    FFieldDefault: TStrings;
    FFieldNotNull: Boolean;
    FFieldNullType: string;
    FFieldCollateID: Integer;
    FFieldCollate: string;
    FComputedSource: TStrings;
    FUseCustomValues: Boolean;
    FNameWasChanged: Boolean;
    FDataTypeWasChanged: Boolean;
    FDefaultWasChanged: Boolean;
    FCheckWasChanged: Boolean;
    FNullTypeWasChanged: Boolean;
    FCollateWasChanged: Boolean;
  protected
    function GetFieldTypeID: Integer;
    procedure SetFieldTypeID(Value: Integer);
    function GetSubTypeID: Integer;
    procedure SetSubTypeID(Value: Integer);
    function GetCharsetID: Integer;
    procedure SetCharsetID(Value: Integer);
    function GetCollateID: Integer;
    procedure SetCollateID(Value: Integer);
    function GetArrayDimID: Integer;
    procedure SetArrayDimID(Value: Integer);

    function GetDomain: string;
    procedure SetDomain(Value: string);
    function GetDataType: string;
    procedure SetDataType(Value: string);
    function GetDataTypeExt: string;
    procedure SetDataTypeExt(Value: string);
    function GetDataTypeField: string;
    procedure SetDataTypeField(Value: string);
    function GetDataTypeFieldExt: string;
    procedure SetDataTypeFieldExt(Value: string);
    function GetLength: Integer;
    procedure SetLength(Value: Integer);
    function GetPrecision: Integer;
    procedure SetPrecision(Value: Integer);
    function GetScale: Integer;
    procedure SetScale(Value: Integer);
    function GetNotNull: Boolean;
    procedure SetNotNull(Value: Boolean);
    function GetNullType: string;
    procedure SetNullType(Value: string);
    function GetSubType: string;
    procedure SetSubType(Value: string);
    function GetSegmentSize: Integer;
    procedure SetSegmentSize(Value: Integer);
    function GetCharset: string;
    procedure SetCharset(Value: string);
    function GetCollate: string;
    procedure SetCollate(Value: string);
    function GetDefaultExpression: TStrings;
    procedure SetDefaultExpression(Value: TStrings);
    function GetCheckConstraint: TStrings;
    procedure SetCheckConstraint(Value: TStrings);
    function GetArrayDim: string;
    procedure SetArrayDim(Value: string);

    function GetTableName: string;
    procedure SetTableName(Value: string);
    function GetFieldDefault: TStrings;
    procedure SetFieldDefault(Value: TStrings);
    function GetFieldNotNull: Boolean;
    procedure SetFieldNotNull(Value: Boolean);
    function GetFieldNullType: string;
    procedure SetFieldNullType(Value: string);
    function GetFieldCollateID: Integer;
    procedure SetFieldCollateID(Value: Integer);
    function GetFieldCollate: string;
    procedure SetFieldCollate(Value: string);
    function GetComputedSource: TStrings;
    procedure SetComputedSource(Value: TStrings);

    function GetUseCustomValues: Boolean;
    procedure SetUseCustomValues(Value: Boolean);
    function GetNameWasChanged: Boolean;
    procedure SetNameWasChanged(Value: Boolean);
    function GetDataTypeWasChanged: Boolean;
    procedure SetDataTypeWasChanged(Value: Boolean);
    function GetDefaultWasChanged: Boolean;
    procedure SetDefaultWasChanged(Value: Boolean);
    function GetCheckWasChanged: Boolean;
    procedure SetCheckWasChanged(Value: Boolean);
    function GetNullTypeWasChanged: Boolean;
    procedure SetNullTypeWasChanged(Value: Boolean);
    function GetCollateWasChanged: Boolean;
    procedure SetCollateWasChanged(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property FieldTypeID: Integer read GetFieldTypeID write SetFieldTypeID;
    property SubTypeID: Integer read GetSubTypeID write SetSubTypeID;
    property CharsetID: Integer read GetCharsetID write SetCharsetID;
    property CollateID: Integer read GetCollateID write SetCollateID;
    property ArrayDimID: Integer read GetArrayDimID write SetArrayDimID;

    property DataTypeExt: string read GetDataTypeExt write SetDataTypeExt;
    property DataTypeField: string read GetDataTypeField write SetDataTypeField;
    property DataTypeFieldExt: string read GetDataTypeFieldExt write SetDataTypeFieldExt;
    property NotNull: Boolean read GetNotNull write SetNotNull;
    property TableName: string read GetTableName write SetTableName;
    property FieldDefault: TStrings read GetFieldDefault write SetFieldDefault;
    property FieldNotNull: Boolean read GetFieldNotNull write SetFieldNotNull;
    property FieldNullType: string read GetFieldNullType write SetFieldNullType;
    property FieldCollateID: Integer read GetFieldCollateID write SetFieldCollateID;
    property FieldCollate: string read GetFieldCollate write SetFieldCollate;
    // Other (for ibSHDDLGenerator)
    property UseCustomValues: Boolean read GetUseCustomValues write SetUseCustomValues;
    property NameWasChanged: Boolean read GetNameWasChanged write SetNameWasChanged;
    property DataTypeWasChanged: Boolean read GetDataTypeWasChanged write SetDataTypeWasChanged;
    property DefaultWasChanged: Boolean read GetDefaultWasChanged write SetDefaultWasChanged;
    property CheckWasChanged: Boolean read GetCheckWasChanged write SetCheckWasChanged;
    property NullTypeWasChanged: Boolean read GetNullTypeWasChanged write SetNullTypeWasChanged;
    property CollateWasChanged: Boolean read GetCollateWasChanged write SetCollateWasChanged;
  published
    property Description;
    property Domain: string read GetDomain {write SetDomain};
    property DataType: string read GetDataType {write SetDataType};
    property Length: Integer read GetLength {write SetLength};
    property Precision: Integer read GetPrecision {write SetPrecision};
    property Scale: Integer read GetScale {write SetScale};
    property SubType: string read GetSubType {write SetSubType};
    property SegmentSize: Integer read GetSegmentSize {write SetSegmentSize};
    property ArrayDim: string read GetArrayDim {write SetArrayDim};
    property Charset: string read GetCharset {write SetCharset};
    property Collate: string read GetCollate {write SetCollate};
    property NullType: string read GetNullType {write SetNullType};
    property DefaultExpression: TStrings read GetDefaultExpression {write SetDefaultExpression};
    property CheckConstraint: TStrings read GetCheckConstraint {write SetCheckConstraint};
    property ComputedSource: TStrings read GetComputedSource {write SetComputedSource};
  end;

  TibBTSystemDomain = class(TibBTDomain, IibSHSystemDomain)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TibBTSystemGeneratedDomain = class(TibBTDomain, IibSHSystemGeneratedDomain)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TibBTField = class(TibBTDomain, IibSHField)
  public
    class function GetAssociationClassFnc: string; override;
  end;

  TibBTProcParam = class(TibBTDomain, IibSHProcParam)
  public
    class function GetAssociationClassFnc: string; override;
  end;

implementation

uses
  ibSHConsts, ibSHSQLs;

{ TibBTDomain }

constructor TibBTDomain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDefaultExpression := TStringList.Create;
  FCheckConstraint := TStringList.Create;
  FFieldDefault := TStringList.Create;
  FComputedSource := TStringList.Create;

  FPrecision := 15;
  FScale := 2;
  FDataType := Format('%s', [DataTypes[0, 1]]);

  // Domain и ComputedSource это дл€ Field, посему здесь пр€чем от показа в ќ»
  MakePropertyInvisible('Domain');
  MakePropertyInvisible('ComputedSource');
end;

destructor TibBTDomain.Destroy;
begin
  FDefaultExpression.Free;
  FCheckConstraint.Free;
  FFieldDefault.Free;
  FComputedSource.Free;
  inherited Destroy;
end;

function TibBTDomain.GetFieldTypeID: Integer;
begin
  Result := FFieldTypeID;
end;

procedure TibBTDomain.SetFieldTypeID(Value: Integer);
begin
  FFieldTypeID := Value;
end;

function TibBTDomain.GetSubTypeID: Integer;
begin
  Result := FSubTypeID;
end;

procedure TibBTDomain.SetSubTypeID(Value: Integer);
begin
  FSubTypeID := Value;
end;

function TibBTDomain.GetCharsetID: Integer;
begin
  Result := FCharsetID;
end;

procedure TibBTDomain.SetCharsetID(Value: Integer);
begin
  FCharsetID := Value;
end;

function TibBTDomain.GetCollateID: Integer;
begin
  Result := FCollateID;
end;

procedure TibBTDomain.SetCollateID(Value: Integer);
begin
  FCollateID := Value;
end;

function TibBTDomain.GetArrayDimID: Integer;
begin
  Result := FArrayDimID;
end;

procedure TibBTDomain.SetArrayDimID(Value: Integer);
begin
  FArrayDimID := Value;
end;

function TibBTDomain.GetDomain: string;
begin
  Result := FDomain;
end;

procedure TibBTDomain.SetDomain(Value: string);
begin
  FDomain := Value;
end;

function TibBTDomain.GetDataType: string;
begin
  Result := FDataType;
end;

procedure TibBTDomain.SetDataType(Value: string);
begin
  FDataType := Value;
end;

function TibBTDomain.GetDataTypeExt: string;
begin
  Result := FDataTypeExt;
end;

procedure TibBTDomain.SetDataTypeExt(Value: string);
begin
  FDataTypeExt := Value;
end;

function TibBTDomain.GetDataTypeField: string;
begin
  Result := FDataTypeField;
end;

procedure TibBTDomain.SetDataTypeField(Value: string);
begin
  FDataTypeField := Value;
end;

function TibBTDomain.GetDataTypeFieldExt: string;
begin
  Result := FDataTypeFieldExt;
end;

procedure TibBTDomain.SetDataTypeFieldExt(Value: string);
begin
  FDataTypeFieldExt := Value;
end;

function TibBTDomain.GetLength: Integer;
begin
  Result := FLength;
end;

procedure TibBTDomain.SetLength(Value: Integer);
begin
  FLength := Value;
end;

function TibBTDomain.GetPrecision: Integer;
begin
  Result := FPrecision;
end;

procedure TibBTDomain.SetPrecision(Value: Integer);
begin
  FPrecision := Value;
end;

function TibBTDomain.GetScale: Integer;
begin
  Result := FScale;
end;

procedure TibBTDomain.SetScale(Value: Integer);
begin
  FScale := Value;
end;

function TibBTDomain.GetNotNull: Boolean;
begin
  Result := FNotNull;
end;

procedure TibBTDomain.SetNotNull(Value: Boolean);
begin
  FNotNull := Value;
end;

function TibBTDomain.GetNullType: string;
begin
  Result := FNullType;
end;

procedure TibBTDomain.SetNullType(Value: string);
begin
  FNullType := Value;
end;

function TibBTDomain.GetSubType: string;
begin
  Result := FSubType;
end;

procedure TibBTDomain.SetSubType(Value: string);
begin
  FSubType := Value;
end;

function TibBTDomain.GetSegmentSize: Integer;
begin
  Result := FSegmentSize;
end;

procedure TibBTDomain.SetSegmentSize(Value: Integer);
begin
  FSegmentSize := Value;
end;

function TibBTDomain.GetCharset: string;
begin
  Result := FCharset;
end;

procedure TibBTDomain.SetCharset(Value: string);
begin
  FCharset := Value;
end;

function TibBTDomain.GetCollate: string;
begin
  Result := FCollate;
end;

procedure TibBTDomain.SetCollate(Value: string);
begin
  FCollate := Value;
end;

function TibBTDomain.GetDefaultExpression: TStrings;
begin
  Result := FDefaultExpression;
end;

procedure TibBTDomain.SetDefaultExpression(Value: TStrings);
begin
  FDefaultExpression.Assign(Value);
end;

function TibBTDomain.GetCheckConstraint: TStrings;
begin
  Result := FCheckConstraint;
end;

procedure TibBTDomain.SetCheckConstraint(Value: TStrings);
begin
  FCheckConstraint.Assign(Value);
end;

function TibBTDomain.GetArrayDim: string;
begin
  Result := FArrayDim;
end;

procedure TibBTDomain.SetArrayDim(Value: string);
begin
  FArrayDim := Value;
end;

function TibBTDomain.GetTableName: string;
begin
  Result := FTableName;
end;

procedure TibBTDomain.SetTableName(Value: string);
begin
  FTableName := Value;
end;

function TibBTDomain.GetFieldDefault: TStrings;
begin
  Result := FFieldDefault;
end;

procedure TibBTDomain.SetFieldDefault(Value: TStrings);
begin
  FFieldDefault.Assign(Value);
end;

function TibBTDomain.GetFieldNotNull: Boolean;
begin
  Result := FFieldNotNull;
end;

procedure TibBTDomain.SetFieldNotNull(Value: Boolean);
begin
  FFieldNotNull := Value;
end;

function TibBTDomain.GetFieldNullType: string;
begin
  Result := FFieldNullType;
end;

procedure TibBTDomain.SetFieldNullType(Value: string);
begin
  FFieldNullType := Value;
end;

function TibBTDomain.GetFieldCollateID: Integer;
begin
  Result := FFieldCollateID;
end;

procedure TibBTDomain.SetFieldCollateID(Value: Integer);
begin
  FFieldCollateID := Value;
end;

function TibBTDomain.GetFieldCollate: string;
begin
  Result := FFieldCollate;
end;

procedure TibBTDomain.SetFieldCollate(Value: string);
begin
  FFieldCollate := Value;
end;

function TibBTDomain.GetComputedSource: TStrings;
begin
  Result := FComputedSource;
end;

procedure TibBTDomain.SetComputedSource(Value: TStrings);
begin
  FComputedSource.Assign(Value);
end;

function TibBTDomain.GetUseCustomValues: Boolean;
begin
  Result := FUseCustomValues;
end;

procedure TibBTDomain.SetUseCustomValues(Value: Boolean);
begin
  FUseCustomValues := Value;
end;

function TibBTDomain.GetNameWasChanged: Boolean;
begin
  Result := FNameWasChanged;
end;

procedure TibBTDomain.SetNameWasChanged(Value: Boolean);
begin
  FNameWasChanged := Value;
end;

function TibBTDomain.GetDataTypeWasChanged: Boolean;
begin
  Result := FDataTypeWasChanged;
end;

procedure TibBTDomain.SetDataTypeWasChanged(Value: Boolean);
begin
  FDataTypeWasChanged := Value;
end;

function TibBTDomain.GetDefaultWasChanged: Boolean;
begin
  Result := FDefaultWasChanged;
end;

procedure TibBTDomain.SetDefaultWasChanged(Value: Boolean);
begin
  FDefaultWasChanged := Value;
end;

function TibBTDomain.GetCheckWasChanged: Boolean;
begin
  Result := FCheckWasChanged;
end;

procedure TibBTDomain.SetCheckWasChanged(Value: Boolean);
begin
  FCheckWasChanged := Value;
end;

function TibBTDomain.GetNullTypeWasChanged: Boolean;
begin
  Result := FNullTypeWasChanged;
end;

procedure TibBTDomain.SetNullTypeWasChanged(Value: Boolean);
begin
  FNullTypeWasChanged := Value;
end;

function TibBTDomain.GetCollateWasChanged: Boolean;
begin
  Result := FCollateWasChanged;
end;

procedure TibBTDomain.SetCollateWasChanged(Value: Boolean);
begin
  FCollateWasChanged := Value;
end;

{ TibBTSystemDomain }

constructor TibBTSystemDomain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  System := True;
end;

{ TibBTSystemGeneratedDomain }

constructor TibBTSystemGeneratedDomain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  System := True;
end;

{ TibBTField }

class function TibBTField.GetAssociationClassFnc: string;
begin
  Result := SClassAssocField;
end;

{ TibBTProcParam }

class function TibBTProcParam.GetAssociationClassFnc: string;
begin
  Result := 'Parameter';
end;

end.

