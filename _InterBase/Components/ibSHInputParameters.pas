unit ibSHInputParameters;

interface

uses
  StdCtrls, Contnrs, ExtCtrls, SysUtils, Graphics, Controls, Forms, Dialogs,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDriverIntf, ibSHConsts;

type
  TibBTInputParameters = class(TSHComponent, IibSHInputParameters)
  private
    FParams: IibSHDRVParams;
  protected
    function GetParams: IibSHDRVParams;
    function InputParameters(AParams: IibSHDRVParams): Boolean;
  end;


procedure Register();

implementation

uses ibSHInputParametersFrm;

procedure Register();
begin
  SHRegisterComponents([TibBTInputParameters]);
  SHRegisterComponentForm(IibSHInputParameters, SCallInputParameters, TibBTInputParametersForm);
end;

{ TibBTInputParameters }

function TibBTInputParameters.GetParams: IibSHDRVParams;
begin
  Result := FParams;
end;

function TibBTInputParameters.InputParameters(
  AParams: IibSHDRVParams): Boolean;
begin
  Result := True;
  if (not Assigned(AParams)) or (AParams.ParamCount = 0) then Exit;
  FParams := AParams;
  Result := Designer.ShowModal(Self, SCallInputParameters) = mrOk;
  FParams := nil;
end;

initialization

  Register;

end.
