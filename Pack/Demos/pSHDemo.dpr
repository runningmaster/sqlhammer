program pSHDemo;

uses
  Forms,
  pSHDemoMain in 'pSHDemoMain.pas' {pSHDemoMainForm},
  ibBTObjectNamesManager in 'ibBTObjectNamesManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TpSHDemoMainForm, pSHDemoMainForm);
  Application.Run;
end.
