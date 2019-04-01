unit ibSHFilter;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;

type
  TibBTFilter = class(TibBTDBObject, IibSHFilter)
  private
    FInputType: Integer;
    FOutputType: Integer;
    FEntryPoint: string;
    FModuleName: string;
    function GetInputType: Integer;
    procedure SetInputType(Value: Integer);
    function GetOutputType: Integer;
    procedure SetOutputType(Value: Integer);
    function GetEntryPoint: string;
    procedure SetEntryPoint(Value: string);
    function GetModuleName: string;
    procedure SetModuleName(Value: string);
  published
    property Description;
    property InputType: Integer read GetInputType {write SetInputType};
    property OutputType: Integer read GetOutputType {write SetOutputType};
    property EntryPoint: string read GetEntryPoint {write SetEntryPoint};
    property ModuleName: string read GetModuleName {write SetModuleName};
  end;

implementation

uses
  ibSHConsts, ibSHSQLs;

{ TibBTFilter }

function TibBTFilter.GetInputType: Integer;
begin
  Result := FInputType;
end;

procedure TibBTFilter.SetInputType(Value: Integer);
begin
  FInputType := Value;
end;

function TibBTFilter.GetOutputType: Integer;
begin
  Result := FOutputType;
end;

procedure TibBTFilter.SetOutputType(Value: Integer);
begin
  FOutputType := Value;
end;

function TibBTFilter.GetEntryPoint: string;
begin
  Result := FEntryPoint;
end;

procedure TibBTFilter.SetEntryPoint(Value: string);
begin
  FEntryPoint := Value;
end;

function TibBTFilter.GetModuleName: string;
begin
  Result := FModuleName;
end;

procedure TibBTFilter.SetModuleName(Value: string);
begin
  FModuleName := Value;
end;

end.

