{$I .inc}
unit ideSHRegistrationFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TRegistrationForm = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RegistrationForm: TRegistrationForm;

implementation

{$IFDEF USE_ASPROTECT}
uses
  aspr_api;
{$ENDIF}

{$R *.dfm}

procedure TRegistrationForm.Button1Click(Sender: TObject);
begin
{$IFDEF USE_ASPROTECT}
  If CheckKeyAndDecrypt(PChar(Edit2.Text), PChar(Edit1.Text), True) then
  begin
    MessageBox(Handle, 'Thank you for your registration!', 'Registration', MB_ICONINFORMATION);
    Close;
  end else
    MessageBox(Handle, 'Key is not valid, please contact manufacture!','Registration', MB_ICONWARNING);
{$ENDIF}    
end;

procedure TRegistrationForm.Button2Click(Sender: TObject);
begin
  Close;
end;

end.
