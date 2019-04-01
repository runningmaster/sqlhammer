unit ibSHDDLWizard;

interface

uses
  SysUtils, Classes,
  SHDesignIntf, ibSHDesignIntf;

procedure Register;

implementation

uses
  ibSHDDLWizardActions;

procedure Register;
begin
  SHRegisterImage(TibSHDDLWizardToolbarAction_.ClassName, 'Button_Wizard.bmp');
  SHRegisterActions([TibSHDDLWizardToolbarAction_]);
end;

initialization

  Register;

end.
 
