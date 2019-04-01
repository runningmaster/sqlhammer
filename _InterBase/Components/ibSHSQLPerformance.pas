unit ibSHSQLPerformance;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibBTSQLPerformance = class(TibBTTool, IibSHSQLPerformance)
  end;

  TibBTSQLPerformanceFactory = class(TibBTToolFactory)
  end;

procedure Register();

implementation

uses
  ibSHConsts;

procedure Register();
begin
end;

{ TibBTSQLPerformance }

initialization

  Register;

end.
