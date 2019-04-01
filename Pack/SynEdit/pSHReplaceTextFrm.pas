unit pSHReplaceTextFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pSHFindTextFrm, Menus, ExtCtrls, StdCtrls, Buttons,
  pSHIntf;

type
  TpSHReplaceTextForm = class(TpSHFindTextForm)
    cbPromtOnReplace: TCheckBox;
    cbReplaceText: TComboBox;
    Label1: TLabel;
    Button1: TButton;
  private
    function GetReplaceText: string;
    procedure SetReplaceText(const Value: string);
    { Private declarations }
  protected
    function GetFindTextOptions: TBTFindTextOptions; override;
    procedure SetFindTextOptions(const Value: TBTFindTextOptions); override;
    procedure DoSaveSettings; override;
    procedure DoRestoreSettings; override;
  public
    { Public declarations }
    property ReplaceText: string read GetReplaceText write SetReplaceText;
  end;

var
  pSHReplaceTextForm: TpSHReplaceTextForm;

implementation

{$R *.dfm}

{ TpSHReplaceTextForm }

function TpSHReplaceTextForm.GetReplaceText: string;
begin
  Result := cbReplaceText.Text;
end;

procedure TpSHReplaceTextForm.SetReplaceText(const Value: string);
begin
  cbReplaceText.Text := Value;
end;

function TpSHReplaceTextForm.GetFindTextOptions: TBTFindTextOptions;
begin
  Result := inherited GetFindTextOptions;
  if cbPromtOnReplace.Checked then
    Include(Result, ftoPromptOnReplace);
end;

procedure TpSHReplaceTextForm.SetFindTextOptions(
  const Value: TBTFindTextOptions);
begin
  inherited SetFindTextOptions(Value);
  if ftoPromptOnReplace in Value then
    cbPromtOnReplace.Checked := True
  else
    cbPromtOnReplace.Checked := False;
end;

procedure TpSHReplaceTextForm.DoSaveSettings;
begin
  inherited;
  if ((ModalResult = mrOk) or (ModalResult = mrYesToAll)) and
    Assigned(FindReplaceHistory) then
    FindReplaceHistory.AddToReplaceHistory(ReplaceText);
end;

procedure TpSHReplaceTextForm.DoRestoreSettings;
begin
  inherited;
  if Assigned(FindReplaceHistory) then
    cbReplaceText.Items.Text := FindReplaceHistory.ReplaceHistory.Text
end;

end.
