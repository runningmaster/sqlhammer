unit ibSHGenerator;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;

type
  TibBTGenerator = class(TibBTDBObject, IibSHGenerator)
  private
    FShowSetClause: Boolean;
    FValue: Integer;
    function GetShowSetClause: Boolean;
    procedure SetShowSetClause(Value: Boolean);
    function GetValue: Integer;
    procedure SetValue(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    property ShowSetClause: Boolean read GetShowSetClause write SetShowSetClause;  
  published
    property Value: Integer read GetValue {write SetValue};
  end;

implementation

uses
  ibSHConsts, ibSHSQLs;

{ TibBTGenerator }

constructor TibBTGenerator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowSetClause := True;
end;

function TibBTGenerator.GetShowSetClause: Boolean;
begin
  Result := FShowSetClause;
end;

procedure TibBTGenerator.SetShowSetClause(Value: Boolean);
begin
  FShowSetClause := Value;
end;

function TibBTGenerator.GetValue: Integer;
begin
  Result := FValue;
end;

procedure TibBTGenerator.SetValue(Value: Integer);
begin
  FValue := Value;
end;

end.

