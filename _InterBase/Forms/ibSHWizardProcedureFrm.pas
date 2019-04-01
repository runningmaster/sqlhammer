unit ibSHWizardProcedureFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDDLWizardCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, StdCtrls, ExtCtrls, ComCtrls, StrUtils;

type
  TibSHWizardProcedureForm = class(TibSHDDLWizardCustomForm)
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
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
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
  ibSHWizardProcedureForm: TibSHWizardProcedureForm;

implementation

{$R *.dfm}

{ TibSHWizardProcedureForm }

constructor TibSHWizardProcedureForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  InitPageCtrl(PageControl1);
  InitDescrEditor(pSHSynEdit1);
  SetFormSize(250, 400);

  Edit1.Text := DBObject.Caption;
  Edit1.Enabled := not (DBState = csAlter);

  CheckBox1.Checked := (DBObject as IibSHProcedure).Params.Count <> 0;
  CheckBox2.Checked := (DBObject as IibSHProcedure).Returns.Count <> 0;
  CheckBox3.Checked := AnsiContainsText(AnsiUpperCase((DBObject as IibSHProcedure).BodyText.Text), ' VARIABLE ');

  CheckBox1.Enabled := DBState = csCreate;
  CheckBox2.Enabled := DBState = csCreate;
  CheckBox3.Enabled := DBState = csCreate;
end;

destructor TibSHWizardProcedureForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHWizardProcedureForm.SetTMPDefinitions;
begin
  TMPObject.Caption := NormalizeCaption(Trim(Edit1.Text));
  (TMPObject as IibSHProcedure).Params.Assign((DBObject as IibSHProcedure).Params);
  (TMPObject as IibSHProcedure).Returns.Assign((DBObject as IibSHProcedure).Returns);
  (TMPObject as IibSHProcedure).ParamsExt.Assign((DBObject as IibSHProcedure).ParamsExt);
  (TMPObject as IibSHProcedure).ReturnsExt.Assign((DBObject as IibSHProcedure).ReturnsExt);
  (TMPObject as IibSHProcedure).BodyText.Assign((DBObject as IibSHProcedure).BodyText);

  if DBState = csCreate then
  begin
    if CheckBox1.Checked then (TMPObject as IibSHProcedure).ParamsExt.Add('INPUT_PARAM INTEGER');
    if CheckBox2.Checked then (TMPObject as IibSHProcedure).ReturnsExt.Add('OUTPUT_PARAM INTEGER');
    if CheckBox3.Checked then (TMPObject as IibSHProcedure).BodyText.Insert(0, '  DECLARE VARIABLE VAR_PARAM INTEGER;');
  end;
end;

end.
