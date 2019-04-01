unit ibSHWizardViewFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDDLWizardCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, StdCtrls, ExtCtrls, ComCtrls, StrUtils;

type
  TibSHWizardViewForm = class(TibSHDDLWizardCustomForm)
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
  ibSHWizardViewForm: TibSHWizardViewForm;

implementation

{$R *.dfm}

{ TibSHWizardViewForm }

constructor TibSHWizardViewForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  InitPageCtrl(PageControl1);
  InitDescrEditor(pSHSynEdit1);
  SetFormSize(250, 400);

  Edit1.Text := DBObject.Caption;
  Edit1.Enabled := not (DBState = csAlter);
end;

destructor TibSHWizardViewForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHWizardViewForm.SetTMPDefinitions;
begin
  TMPObject.Caption := NormalizeCaption(Trim(Edit1.Text));
  (TMPObject as IibSHView).Fields.Assign((DBObject as IibSHView).Fields);
  (TMPObject as IibSHView).BodyText.Assign((DBObject as IibSHView).BodyText);  
end;

end.
