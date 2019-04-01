unit ibSHDBDesigner;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibBTDBDesigner = class(TibBTTool, IibSHDBDesigner)
  end;

  TibBTDBDesignerFactory = class(TibBTToolFactory)
  end;

procedure Register();

implementation

uses
  ibSHConsts;

procedure Register();
begin
end;

{ TibBTDBDesigner }

initialization

  Register;

end.
