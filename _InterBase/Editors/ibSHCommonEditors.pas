unit ibSHCommonEditors;

interface

uses
  SysUtils, Classes, DesignIntf, TypInfo,
  SHDesignIntf;

type
  TibBTPropertyEditor = class(TSHPropertyEditor)
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

implementation

uses
  ibSHConsts;

{ TibBTPropertyEditor }

function TibBTPropertyEditor.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then Result := S_OK else Result := E_NOINTERFACE;
end;

function TibBTPropertyEditor._AddRef: Integer;
begin
  Result := -1;
end;

function TibBTPropertyEditor._Release: Integer;
begin
  Result := -1;
end;

end.
