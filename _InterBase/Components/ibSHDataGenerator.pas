unit ibSHDataGenerator;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibBTDataGenerator = class(TibBTTool, IibSHDataGenerator)
  end;

  TibBTDataGeneratorFactory = class(TibBTToolFactory)
  end;

procedure Register();

implementation

uses
  ibSHConsts;

procedure Register();
begin
end;

{ TibBTDataGenerator }

initialization

  Register;

end.
