unit ibSHFunction;

interface

uses
  SysUtils, Classes, Contnrs,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;

type
  TibBTFunction = class(TibBTDBObject, IibSHFunction)
  private
    FParamList: TComponentList;
    FEntryPoint: string;
    FModuleName: string;
    FReturnsArgument: Integer;
    function GetParam(Index: Integer): IibSHFuncParam;
    function GetEntryPoint: string;
    procedure SetEntryPoint(Value: string);
    function GetModuleName: string;
    procedure SetModuleName(Value: string);
    function GetReturnsArgument: Integer;
    procedure SetReturnsArgument(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Refresh; override;
  published
    property Description;
    property Params;
    property Returns;
    property EntryPoint: string read GetEntryPoint {write SetEntryPoint};
    property ModuleName: string read GetModuleName {write SetModuleName};
  end;

implementation

uses
  ibSHConsts, ibSHSQLs;

{ TibBTFunction }

constructor TibBTFunction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParamList := TComponentList.Create;
end;

destructor TibBTFunction.Destroy;
begin
  FParamList.Free;
  inherited Destroy;
end;

procedure TibBTFunction.Refresh;
begin
  FParamList.Clear;
  inherited Refresh;
end;

function TibBTFunction.GetParam(Index: Integer): IibSHFuncParam;
begin
  if FReturnsArgument = 0 then
    Assert(Index <= Params.Count, 'Index out of bounds')
  else
    Assert(Index <= Pred(Params.Count), 'Index out of bounds');
  Supports(CreateParam(FParamList, IibSHDomain, Index), IibSHFuncParam, Result);
end;

function TibBTFunction.GetEntryPoint: string;
begin
  Result := FEntryPoint;
end;

procedure TibBTFunction.SetEntryPoint(Value: string);
begin
  FEntryPoint := Value;
end;

function TibBTFunction.GetModuleName: string;
begin
  Result := FModuleName;
end;

procedure TibBTFunction.SetModuleName(Value: string);
begin
  FModuleName := Value;
end;

function TibBTFunction.GetReturnsArgument: Integer;
begin
  Result := FReturnsArgument;
end;

procedure TibBTFunction.SetReturnsArgument(Value: Integer);
begin
  FReturnsArgument := Value;
end;

end.
