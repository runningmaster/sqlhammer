unit RuleFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TRuleForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ledFrom: TLabeledEdit;
    ledTo: TLabeledEdit;
    chbWholeWords: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RuleForm: TRuleForm;

function GetRuleDef(var _From, _To: String; var _WholeWords: Boolean): Boolean;

implementation

{$R *.dfm}

function GetRuleDef(var _From, _To: String; var _WholeWords: Boolean): Boolean;
begin
  Result := False;
  RuleForm := TRuleForm.Create(Application);
  try
    if RuleForm.ShowModal = mrOk then
    begin
      Result := True;
      _From := RuleForm.ledFrom.Text;
      _To := RuleForm.ledTo.Text;
      _WholeWords := RuleForm.chbWholeWords.Checked;
    end;
  finally
    RuleForm.Free;
  end;
end;


procedure TRuleForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    if Trim(ledFrom.Text) = '' then
    begin
      Action := caNone;
      raise Exception.Create('Enter FROM template !');
    end;
end;

end.
