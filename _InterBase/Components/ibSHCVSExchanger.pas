unit ibSHCVSExchanger;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibBTCVSExchanger = class(TibBTTool, IibSHCVSExchanger, IfbBTBranch, IibSHBranch)
  end;

  TibBTCVSExchangerFactory = class(TibBTToolFactory)
  end;

procedure Register();

implementation

uses
  ibSHConsts;

procedure Register();
begin
end;

{ TibBTCVSExchanger }

initialization

  Register;

end.
