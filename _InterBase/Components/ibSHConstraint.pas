unit ibSHConstraint;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;
  
type
  TibBTConstraint = class(TibBTDBObject, IibSHConstraint)
  private
    FTableName: string;
    FConstraintType: string;
    FReferenceTable: string;
    FReferenceFields: TStrings;
    FOnUpdateRule: string;
    FOnDeleteRule: string;
    FIndexName: string;
    FIndexSorting: string;
    FCheckSource: TStrings;

    function GetConstraintType: string;
    procedure SetConstraintType(Value: string);
    function GetTableName: string;
    procedure SetTableName(Value: string);
    function GetReferenceTable: string;
    procedure SetReferenceTable(Value: string);
    function GetReferenceFields: TStrings;
    procedure SetReferenceFields(Value: TStrings);
    function GetOnUpdateRule: string;
    procedure SetOnUpdateRule(Value: string);
    function GetOnDeleteRule: string;
    procedure SetOnDeleteRule(Value: string);
    function GetIndexName: string;
    procedure SetIndexName(Value: string);
    function GetIndexSorting: string;
    procedure SetIndexSorting(Value: string);
    function GetCheckSource: TStrings;
    procedure SetCheckSource(Value: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
 published
    property ConstraintType: string read GetConstraintType {write SetConstraintType};
    property TableName: string read GetTableName {write SetTableName};
    property Fields;
    property ReferenceTable: string read GetReferenceTable {write SetReferenceTable};
    property ReferenceFields: TStrings read GetReferenceFields {write SetReferenceFields};
    property OnUpdateRule: string read GetOnUpdateRule {write SetOnUpdateRule};
    property OnDeleteRule: string read GetOnDeleteRule {write SetOnDeleteRule};
    property IndexName: string read GetIndexName {write SetIndexName};
    property IndexSorting: string read GetIndexSorting {write SetIndexSorting};
    property CheckSource: TStrings read GetCheckSource {write SetCheckSource};
  end;

implementation

{ TibBTConstraint }

constructor TibBTConstraint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FReferenceFields := TStringList.Create;
  FCheckSource := TStringList.Create;
end;

destructor TibBTConstraint.Destroy;
begin
  FReferenceFields.Free;
  FCheckSource.Free;
  inherited Destroy;
end;

function TibBTConstraint.GetTableName: string;
begin
  Result := FTableName;
end;

procedure TibBTConstraint.SetTableName(Value: string);
begin
  FTableName := Value;
end;

function TibBTConstraint.GetConstraintType: string;
begin
  Result := FConstraintType;
end;

procedure TibBTConstraint.SetConstraintType(Value: string);
begin
  FConstraintType := Value;
end;

function TibBTConstraint.GetReferenceTable: string;
begin
  Result := FReferenceTable;
end;

procedure TibBTConstraint.SetReferenceTable(Value: string);
begin
  FReferenceTable := Value;
end;

function TibBTConstraint.GetReferenceFields: TStrings;
begin
  Result := FReferenceFields;
end;

procedure TibBTConstraint.SetReferenceFields(Value: TStrings);
begin
  FReferenceFields.Assign(Value);
end;

function TibBTConstraint.GetOnUpdateRule: string;
begin
  Result := FOnUpdateRule;
end;

procedure TibBTConstraint.SetOnUpdateRule(Value: string);
begin
  FOnUpdateRule := Value;
end;

function TibBTConstraint.GetOnDeleteRule: string;
begin
  Result := FOnDeleteRule;
end;

procedure TibBTConstraint.SetOnDeleteRule(Value: string);
begin
  FOnDeleteRule := Value;
end;

function TibBTConstraint.GetIndexName: string;
begin
  Result := FIndexName;
end;

procedure TibBTConstraint.SetIndexName(Value: string);
begin
  FIndexName := Value;
end;

function TibBTConstraint.GetIndexSorting: string;
begin
  Result := FIndexSorting;
end;

procedure TibBTConstraint.SetIndexSorting(Value: string);
begin
  FIndexSorting := Value;
end;

function TibBTConstraint.GetCheckSource: TStrings;
begin
  Result := FCheckSource;
end;

procedure TibBTConstraint.SetCheckSource(Value: TStrings);
begin
  FCheckSource.Assign(Value);
end;

end.
