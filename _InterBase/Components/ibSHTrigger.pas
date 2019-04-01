unit ibSHTrigger;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;

type
  TibBTTrigger = class(TibBTDBObject, IibSHTrigger)
  private
    FTableName: string;
    FStatus: string;
    FTypePrefix: string;
    FTypeSuffix: string;
    FPosition: Integer;
    function GetTableName: string;
    procedure SetTableName(Value: string);
    function GetStatus: string;
    procedure SetStatus(Value: string);
    function GetTypePrefix: string;
    procedure SetTypePrefix(Value: string);
    function GetTypeSuffix: string;
    procedure SetTypeSuffix(Value: string);
    function GetPosition: Integer;
    procedure SetPosition(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Description;
    property TableName: string read GetTableName {write SetTableName};
    property Status: string read GetStatus {write SetStatus};
    property TypePrefix: string read GetTypePrefix {write SetTypePrefix};
    property TypeSuffix: string read GetTypeSuffix {write SetTypeSuffix};
    property Position: Integer read GetPosition {write SetPosition};
  end;

  TibBTSystemGeneratedTrigger = class(TibBTTrigger, IibSHSystemGeneratedTrigger)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  ibSHConsts, ibSHSQLs;

{ TibBTTrigger }

constructor TibBTTrigger.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStatus := Format('%s', [Statuses[0]]);
  FTypePrefix := Format('%s', [TypePrefixes[0]]);
  FTypeSuffix := Format('%s', [TypeSuffixesIB[0]]);
end;

function TibBTTrigger.GetTableName: string;
begin
  Result := FTableName;
end;

procedure TibBTTrigger.SetTableName(Value: string);
begin
  FTableName := Value;
end;

function TibBTTrigger.GetStatus: string;
begin
  Result := FStatus;
end;

procedure TibBTTrigger.SetStatus(Value: string);
begin
  FStatus := Value;
end;

function TibBTTrigger.GetTypePrefix: string;
begin
  Result := FTypePrefix;
end;

procedure TibBTTrigger.SetTypePrefix(Value: string);
begin
  FTypePrefix := Value;
end;

function TibBTTrigger.GetTypeSuffix: string;
begin
  Result := FTypeSuffix;
end;

procedure TibBTTrigger.SetTypeSuffix(Value: string);
begin
  FTypeSuffix := Value;
end;

function TibBTTrigger.GetPosition: Integer;
begin
  Result := FPosition;
end;

procedure TibBTTrigger.SetPosition(Value: Integer);
begin
  FPosition := Value;
end;

{ TibBTSystemGeneratedTrigger }

constructor TibBTSystemGeneratedTrigger.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  System := True;
end;

end.

