program BlazeTop32;

uses
  Forms,
  ideSHSysInit in 'System\ideSHSysInit.pas',
  ideSHMainFrm in 'Forms\ideSHMainFrm.pas' {MainForm},
  ideSHRegistry in 'System\ideSHRegistry.pas',
  ideSHMain in 'System\ideSHMain.pas',
  ideSHSysUtils in 'System\ideSHSysUtils.pas',
  ideSHSystem in 'System\ideSHSystem.pas',
  ideSHMessages in 'Common\ideSHMessages.pas',
  ideSHConsts in 'Common\ideSHConsts.pas',
  ideSHObjectEditor in 'System\ideSHObjectEditor.pas',
  ideSHBaseDialogFrm in 'Forms\ideSHBaseDialogFrm.pas' {BaseDialogForm},
  ideSHAboutFrm in 'Forms\ideSHAboutFrm.pas' {AboutForm},
  ideSHEnvironmentOptionsFrm in 'Forms\ideSHEnvironmentOptionsFrm.pas' {EnvironmentOptionsForm},
  ideSHObjectListFrm in 'Forms\ideSHObjectListFrm.pas' {ObjectListForm},
  ideSHWindowListFrm in 'Forms\ideSHWindowListFrm.pas' {WindowListForm},
  ideSHDesignIntf in 'Intf\ideSHDesignIntf.pas',
  ideSHProxiPropEditors in 'Common\ideSHProxiPropEditors.pas',
  ideSHSystemOptions in 'Common\ideSHSystemOptions.pas',
  ideSHSystemOptionsFrm in 'Forms\ideSHSystemOptionsFrm.pas' {SystemOptionsForm},
  ideSHDesigner in 'Common\ideSHDesigner.pas',
  ideSHComponentFactory in 'System\ideSHComponentFactory.pas',
  ideSHObject in 'System\ideSHObject.pas',
  ideSHStrUtil in 'Common\ideSHStrUtil.pas',
  ideSHTxtRtns in 'Common\ideSHTxtRtns.pas',
  ideSHEditorOptions in 'Common\ideSHEditorOptions.pas',
  ideSHDBGridOptions in 'Common\ideSHDBGridOptions.pas',
  ideSHRestoreConnectionFrm in 'Forms\ideSHRestoreConnectionFrm.pas' {RestoreConnectionForm},
  ideSHRegExpr in 'Common\ideSHRegExpr.pas',
  ideSHEnvironmentConfiguratorFrm in 'Forms\ideSHEnvironmentConfiguratorFrm.pas' {EnvironmentConfiguratorForm},
  ideSHComponentPageFrm in 'Forms\ideSHComponentPageFrm.pas' {ComponentPageForm},
  ideSHObjectInspectorFrm in 'Forms\ideSHObjectInspectorFrm.pas' {ObjectInspectorForm},
  ideSHMegaEditor in 'System\ideSHMegaEditor.pas',
  ideSHNavigator in 'System\ideSHNavigator.pas',
  ideSHConnectionPageFrm in 'Forms\ideSHConnectionPageFrm.pas' {ConnectionPageForm},
  ideSHConnectionObjectsPageFrm in 'Forms\ideSHConnectionObjectsPageFrm.pas' {ConnectionObjectsPageForm},
  ideSHToolboxFrm in 'Forms\ideSHToolboxFrm.pas' {ToolboxForm},
  ideSHSplashFrm in 'Forms\ideSHSplashFrm.pas' {SplashForm},
  ideSHRegistrationFrm in 'Forms\ideSHRegistrationFrm.pas' {RegistrationForm},
  sysSHVersionInfo in 'Common\sysSHVersionInfo.pas',
  aspr_api in 'ASProtect\aspr_api.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.HelpFile := 'BlazeTop32.hlp';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

