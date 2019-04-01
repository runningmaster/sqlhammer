unit ibSHSQLPlan;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibBTSQLPlan = class(TibBTTool, IibSHSQLPlan)
  end;

  TibBTSQLPlanFactory = class(TibBTToolFactory)
  end;

procedure Register();

implementation

uses
  ibSHConsts;

procedure Register();
begin
end;

{ TibBTSQLPlan }

initialization

  Register;

end.
