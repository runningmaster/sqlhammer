unit ibSHDDLDocumentor;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibBTDDLDocumentor = class(TibBTTool, IibSHDDLDocumentor)
  end;

  TibBTDDLDocumentorFactory = class(TibBTToolFactory)
  end;

procedure Register();

implementation

uses
  ibSHConsts;

procedure Register();
begin
end;

{ TibBTDDLDocumentor }

initialization

  Register;

end.
