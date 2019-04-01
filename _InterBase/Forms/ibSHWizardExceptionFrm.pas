unit ibSHWizardExceptionFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDDLWizardCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, SynEdit, pSHSynEdit, StdCtrls;

type
  TibSHWizardExceptionForm = class(TibSHDDLWizardCustomForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Panel1: TPanel;
    Panel2: TPanel;
    pSHSynEdit1: TpSHSynEdit;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Panel3: TPanel;
    pSHSynEdit2: TpSHSynEdit;
  private
    { Private declarations }
    FDBExceptionIntf: IibSHException;
    FTMPExceptionIntf: IibSHException;
  protected
    { Protected declarations }
    procedure SetTMPDefinitions; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    property DBException: IibSHException read FDBExceptionIntf;
    property TMPException: IibSHException read FTMPExceptionIntf;
  end;

var
  ibSHWizardExceptionForm: TibSHWizardExceptionForm;

implementation

uses ibSHComponentFrm;

{$R *.dfm}

{ TibSHWizardExceptionForm }

constructor TibSHWizardExceptionForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(DBObject, IibSHException, FDBExceptionIntf);
  Supports(TMPObject, IibSHException, FTMPExceptionIntf);
    
  InitPageCtrl(PageControl1);
  InitDescrEditor(pSHSynEdit1);
  InitDescrEditor(pSHSynEdit2, False);
  SetFormSize(250, 400);

  Edit1.Text := DBObject.Caption;
  Designer.TextToStrings(DBException.Text, pSHSynEdit2.Lines, True);

  Edit1.Enabled := not (DBState = csAlter);
end;

destructor TibSHWizardExceptionForm.Destroy;
begin
  FDBExceptionIntf := nil;
  FTMPExceptionIntf := nil;
  inherited Destroy;
end;

procedure TibSHWizardExceptionForm.SetTMPDefinitions;
begin
  TMPException.Caption := NormalizeCaption(Trim(Edit1.Text));
  TMPException.Text := TrimRight(pSHSynEdit2.Lines.Text);
end;

end.
