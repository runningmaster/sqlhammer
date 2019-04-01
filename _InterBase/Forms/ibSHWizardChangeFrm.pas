unit ibSHWizardChangeFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TibSHWizardChangeForm = class(TibBTComponentForm, ISHDDLWizard)
    RadioGroup1: TRadioGroup;
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure DoOnBeforeModalClose(Sender: TObject; var ModalResult: TModalResult;
      var Action: TCloseAction); override;
    procedure DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;
  end;

var
  ibSHWizardChangeForm: TibSHWizardChangeForm;

implementation

{$R *.dfm}

{ TibSHWizardChangeForm }

constructor TibSHWizardChangeForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  SetFormSize(250, 400);
  Caption := Format('Change DDL Generator', []);
end;

destructor TibSHWizardChangeForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHWizardChangeForm.DoOnBeforeModalClose(Sender: TObject; var ModalResult: TModalResult;
  var Action: TCloseAction);
begin
  if ModalResult = mrOK then Component.Tag := RadioGroup1.ItemIndex;
end;

procedure TibSHWizardChangeForm.DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult);
begin
  inherited DoOnAfterModalClose(Sender, ModalResult);
end;

procedure TibSHWizardChangeForm.RadioGroup1Click(Sender: TObject);
begin
  if Assigned(ModalForm) and (RadioGroup1.ItemIndex <> -1) then
    ModalForm.ModalResultCode := mrOK;
end;

end.
