unit ibSHDBComparer;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibBTDBComparer = class(TibBTTool, IibSHDBComparer)
  end;

  TibBTDBComparerFactory = class(TibBTToolFactory)
  end;

procedure Register();

implementation

uses
  ibSHConsts;

procedure Register();
begin
end;

{ TibBTDBComparer }

initialization

  Register;

end.
