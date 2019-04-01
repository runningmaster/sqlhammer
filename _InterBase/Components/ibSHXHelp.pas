unit ibSHXHelp;

interface

uses
  SysUtils, Classes, StrUtils,
  SHDesignIntf,
  ibSHDesignIntf;

procedure Register;

implementation

uses
  ibSHConsts,
  ibSHXHelpActions;

procedure Register;
begin
{
  SHRegisterImage(SCallXHelp, 'Button_Help.bmp');
  SHRegisterImage(TibSHXHelpFormAction.ClassName, 'Button_Help.bmp');
  SHRegisterImage(TibSHXHelpToolbarAction_GB.ClassName,  'Button_Flag_GB.bmp');
  SHRegisterImage(TibSHXHelpToolbarAction_RU.ClassName,  'Button_Flag_RU.bmp');

  SHRegisterActions([
    // Forms
    TibSHXHelpFormAction,
    // Toolbar
    TibSHXHelpToolbarAction_GB,
    TibSHXHelpToolbarAction_RU]);
}    
end;

initialization

  Register;

end.



