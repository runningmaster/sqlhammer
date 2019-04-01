unit ibSHWizardGeneratorFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDDLWizardCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, StdCtrls, ExtCtrls, ComCtrls;

type
  TibSHWizardGeneratorForm = class(TibSHDDLWizardCustomForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Bevel1: TBevel;
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    TabSheet2: TTabSheet;
    Bevel2: TBevel;
    Panel2: TPanel;
    pSHSynEdit1: TpSHSynEdit;
    Label2: TLabel;
    Edit2: TEdit;
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure SetTMPDefinitions; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;
  end;

var
  ibSHWizardGeneratorForm: TibSHWizardGeneratorForm;

implementation

{$R *.dfm}

{ TibSHWizardGeneratorForm }

constructor TibSHWizardGeneratorForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  InitPageCtrl(PageControl1);
  InitDescrEditor(pSHSynEdit1);
  SetFormSize(250, 400);

  PageCtrl.Pages[1].TabVisible := False;

  Edit1.Text := DBObject.Caption;
  Edit2.Text := IntToStr((DBObject as IibSHGenerator).Value);

  Edit1.Enabled := not (DBState = csAlter);
end;

destructor TibSHWizardGeneratorForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHWizardGeneratorForm.SetTMPDefinitions;
begin
  TMPObject.Caption := NormalizeCaption(Trim(Edit1.Text));
  if Length(Trim(Edit2.Text)) > 0 then
    (TMPObject as IibSHGenerator).Value := StrToInt(Trim(Edit2.Text));
end;

procedure TibSHWizardGeneratorForm.Edit2KeyPress(Sender: TObject;
  var Key: Char);
begin
  if not ((Key in ['0'.. '9']) or (Key = '-')) then Key := #0;
end;

end.
