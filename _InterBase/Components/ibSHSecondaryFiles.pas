unit ibSHSecondaryFiles;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibBTSecondaryFiles = class(TibBTTool, IibSHSecondaryFiles)
  end;

  TibBTSecondaryFilesFactory = class(TibBTToolFactory)
  end;

procedure Register();

implementation

uses
  ibSHConsts;

procedure Register();
begin
end;

{ TibBTSecondaryFiles }

initialization

  Register;

end.
