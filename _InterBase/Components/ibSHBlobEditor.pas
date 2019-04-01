unit ibSHBlobEditor;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibBTBlobEditor = class(TibBTTool, IibSHBlobEditor)
  end;

  TibBTBlobEditorFactory = class(TibBTToolFactory)
  end;

procedure Register();

implementation

uses
  ibSHConsts;

procedure Register();
begin
end;

{ TibBTBlobEditor }

initialization

  Register;
end.
 
