unit ibSHException;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;

type
  TibBTException = class(TibBTDBObject, IibSHException)
  private
    FText: string;
    FNumber: Integer;
    function GetText: string;
    procedure SetText(Value: string);
    function GetNumber: Integer;
    procedure SetNumber(Value: Integer);
  published
    property Description;
    property Text: string read GetText {write SetText};
    property Number: Integer read GetNumber {write SetNumber};
  end;

implementation

uses
  ibSHConsts, ibSHSQLs;

{ TibBTException }

function TibBTException.GetText: string;
begin
  Result := FText;
end;

procedure TibBTException.SetText(Value: string);
begin
  FText := Value;
end;

function TibBTException.GetNumber: Integer;
begin
  Result := FNumber;
end;

procedure TibBTException.SetNumber(Value: Integer);
begin
  FNumber := Value;
end;

end.

