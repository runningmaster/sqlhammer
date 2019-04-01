unit ibSHReportManager;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibBTReportManager = class(TibBTTool, IibSHReportManager)
  end;

  TibBTReportManagerFactory = class(TibBTToolFactory)
  end;

procedure Register();

implementation

uses
  ibSHConsts;

procedure Register();
begin
end;

{ TibBTReportManager }

initialization

  Register;

end.
