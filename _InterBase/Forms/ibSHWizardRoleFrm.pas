unit ibSHWizardRoleFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDDLWizardCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, StdCtrls, ExtCtrls, ComCtrls;

type
  TibSHWizardRoleForm = class(TibSHDDLWizardCustomForm)
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
  ibSHWizardRoleForm: TibSHWizardRoleForm;

implementation

{$R *.dfm}

{ TibSHWizardRoleForm }

constructor TibSHWizardRoleForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  InitPageCtrl(PageControl1);
  InitDescrEditor(pSHSynEdit1);
  SetFormSize(250, 400);

  PageCtrl.Pages[1].TabVisible := False;

  Edit1.Text := DBObject.Caption;
  Edit1.Enabled := not (DBState = csAlter);
end;

destructor TibSHWizardRoleForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHWizardRoleForm.SetTMPDefinitions;
begin
  TMPObject.Caption := NormalizeCaption(Trim(Edit1.Text));
end;

end.
