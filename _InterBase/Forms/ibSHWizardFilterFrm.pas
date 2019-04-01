unit ibSHWizardFilterFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDDLWizardCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, StdCtrls, ExtCtrls, ComCtrls;

type
  TibSHWizardFilterForm = class(TibSHDDLWizardCustomForm)
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
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
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
  ibSHWizardFilterForm: TibSHWizardFilterForm;

implementation

{$R *.dfm}

{ TibSHWizardFilterForm }

constructor TibSHWizardFilterForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  I: Integer;  
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  InitPageCtrl(PageControl1);
  InitDescrEditor(pSHSynEdit1);
  SetFormSize(250, 400);

  for I := 0 to Pred(ComponentCount) do
  begin
//   if (Components[I] is TComboBox) then (Components[I] as TComboBox).Text := EmptyStr;
    if (Components[I] is TEdit) then (Components[I] as TEdit).Text := EmptyStr;
  end;

  Edit1.Text := DBObject.Caption;
  if DBState <> csCreate then
  begin
    Edit2.Text := IntToStr((DBObject as IibSHFilter).InputType);
    Edit3.Text := IntToStr((DBObject as IibSHFilter).OutputType);
    Edit4.Text := (DBObject as IibSHFilter).EntryPoint;
    Edit5.Text := (DBObject as IibSHFilter).ModuleName;
  end;
  Edit1.Enabled := not (DBState = csAlter);
end;

destructor TibSHWizardFilterForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHWizardFilterForm.SetTMPDefinitions;
begin
  TMPObject.Caption := NormalizeCaption(Trim(Edit1.Text));
  if Length(Trim(Edit2.Text)) > 0 then
    (TMPObject as IibSHFilter).InputType := StrToInt(Trim(Edit2.Text));
  if Length(Trim(Edit3.Text)) > 0 then
    (TMPObject as IibSHFilter).OutputType := StrToInt(Trim(Edit3.Text));
  (TMPObject as IibSHFilter).EntryPoint := Trim(Edit4.Text);
  (TMPObject as IibSHFilter).ModuleName := Trim(Edit5.Text);
end;

procedure TibSHWizardFilterForm.Edit2KeyPress(Sender: TObject;
  var Key: Char);
begin
  if not ((Key in ['0'.. '9']) or (Key = '-')) then Key := #0;
end;

end.
