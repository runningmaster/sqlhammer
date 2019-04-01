unit ibSHShadow;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;

type
  TibBTShadow = class(TibBTDBObject, IibSHShadow)
  private
    FShadowMode: string;
    FShadowType: string;
    FFileName: string;
    FSecondaryFiles: string;
    function GetShadowMode: string;
    procedure SetShadowMode(Value: string);
    function GetShadowType: string;
    procedure SetShadowType(Value: string);
    function GetFileName: string;
    procedure SetFileName(Value: string);
    function GetSecondaryFiles: string;
    procedure SetSecondaryFiles(Value: string);
  published
    property ObjectName;
    property ShadowMode: string read GetShadowMode write SetShadowMode;
    property ShadowType: string read GetShadowType write SetShadowType;
    property FileName: string read GetFileName write SetFileName;
    property SecondaryFiles: string read GetSecondaryFiles write SetSecondaryFiles;
  end;

implementation

{ TibBTShadow }

function TibBTShadow.GetShadowMode: string;
begin
  Result := FShadowMode;
end;

procedure TibBTShadow.SetShadowMode(Value: string);
begin
  FShadowMode := Value;
end;

function TibBTShadow.GetShadowType: string;
begin
  Result := FShadowType;
end;

procedure TibBTShadow.SetShadowType(Value: string);
begin
  FShadowType := Value;
end;

function TibBTShadow.GetFileName: string;
begin
  Result := FFileName;
end;

procedure TibBTShadow.SetFileName(Value: string);
begin
  FFileName := Value;
end;

function TibBTShadow.GetSecondaryFiles: string;
begin
  Result := FSecondaryFiles;
end;

procedure TibBTShadow.SetSecondaryFiles(Value: string);
begin
  FSecondaryFiles := Value;
end;

end.
