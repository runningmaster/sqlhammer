program ReplaceUtl;

uses
  Forms,
  ReplaceUtlForm in 'ReplaceUtlForm.pas' {Form1},
  RuleFrm in 'RuleFrm.pas' {RuleForm},
  FilesList in 'FilesList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'AutoReplace';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
