unit ibSHQuery;

interface

uses
  SysUtils, Classes, Controls, Contnrs, Forms,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;

type
  TibSHQuery = class(TibBTDBObject, IibSHQuery)
  private
    FData: IibSHData;
    FFieldList: TComponentList;

    { IibSHQuery }
    function GetData: IibSHData;
    procedure SetData(Value: IibSHData);
    function GetField(Index: Integer): IibSHField;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure Refresh; override;
  end;

implementation

{ TibSHQuery }

constructor TibSHQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFieldList := TComponentList.Create;
  State := csSource; 
end;

destructor TibSHQuery.Destroy;
begin
  FFieldList.Free;
  inherited Destroy;
end;

function TibSHQuery.GetData: IibSHData;
begin
  Result := FData;
end;

procedure TibSHQuery.SetData(Value: IibSHData);
begin
  if FData <> Value then
  begin
    ReferenceInterface(FData, opRemove);
    FData := Value;
    ReferenceInterface(FData, opInsert);
  end;
end;

function TibSHQuery.GetField(Index: Integer): IibSHField;
begin
  Assert(Index <= Pred(Fields.Count), 'Index out of bounds');
  Supports(CreateParam(FFieldList, IibSHField, Index), IibSHField, Result);
end;

procedure TibSHQuery.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent.IsImplementorOf(FData) then
      FData := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TibSHQuery.Refresh;
begin
  FFieldList.Clear;
  inherited Refresh;
end;

end.
