unit ibSHWizardTriggerFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDDLWizardCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, StdCtrls, ExtCtrls, ComCtrls, StrUtils;

type
  TibSHWizardTriggerForm = class(TibSHDDLWizardCustomForm)
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
    ComboBox1: TComboBox;
    Label3: TLabel;
    ComboBox2: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Edit2: TEdit;
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure GetDataType;
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
  ibSHWizardTriggerForm: TibSHWizardTriggerForm;

implementation

{$R *.dfm}

uses
  ibSHConsts, ibSHValues;

{ TibSHWizardTriggerForm }

constructor TibSHWizardTriggerForm.Create(AOwner: TComponent; AParent: TWinControl;
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
    if (Components[I] is TComboBox) then (Components[I] as TComboBox).Text := EmptyStr;
    if (Components[I] is TEdit) then (Components[I] as TEdit).Text := EmptyStr;
  end;

  GetDataType;

  Edit1.Text := DBObject.Caption;
  ComboBox1.ItemIndex := ComboBox1.Items.IndexOf((DBObject as IibSHTrigger).TableName);
  ComboBox2.ItemIndex := ComboBox2.Items.IndexOf('ACTIVE');
  ComboBox3.ItemIndex := ComboBox3.Items.IndexOf('BEFORE');
  ComboBox4.ItemIndex := ComboBox4.Items.IndexOf('INSERT');
  Edit2.Text := '0';
  if DBState <> csCreate then
  begin
    ComboBox2.ItemIndex := ComboBox2.Items.IndexOf((DBObject as IibSHTrigger).Status);
    ComboBox3.ItemIndex := ComboBox3.Items.IndexOf((DBObject as IibSHTrigger).TypePrefix);
    ComboBox4.ItemIndex := ComboBox4.Items.IndexOf((DBObject as IibSHTrigger).TypeSuffix);
    Edit2.Text := IntToStr((DBObject as IibSHTrigger).Position);
  end;

  Edit1.Enabled := not (DBState = csAlter);
  ComboBox1.Enabled := not (DBState = csAlter);
end;

destructor TibSHWizardTriggerForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHWizardTriggerForm.SetTMPDefinitions;
var
  S: string;
begin
  TMPObject.Caption := NormalizeCaption(Trim(Edit1.Text));
  (TMPObject as IibSHTrigger).TableName := NormalizeCaption(Trim(ComboBox1.Text));
  (TMPObject as IibSHTrigger).Status := Trim(ComboBox2.Text);
  (TMPObject as IibSHTrigger).TypePrefix := Trim(ComboBox3.Text);
  (TMPObject as IibSHTrigger).TypeSuffix := Trim(ComboBox4.Text);
  if Length(Trim(Edit2.Text)) > 0 then
    (TMPObject as IibSHTrigger).Position := StrToInt(Trim(Edit2.Text));
  (TMPObject as IibSHTrigger).BodyText.Assign((DBObject as IibSHTrigger).BodyText);

  if DBState = csAlter then
  begin
    S := DDLForm.DDLText.Text;
    S := System.Copy(S, AnsiPos('AS', AnsiUpperCase(S)), MaxInt);
    S := ReverseString(S);
    S := System.Copy(S, AnsiPos(ReverseString('END'), AnsiUpperCase(S)), MaxInt);
    S := ReverseString(S);
    Designer.TextToStrings(S, (TMPObject as IibSHTrigger).BodyText, True);
  end;
end;

procedure TibSHWizardTriggerForm.GetDataType;
var
  S: string;
  I: Integer;
begin
  S := DBObject.BTCLDatabase.BTCLServer.Version;
  for I := 0 to Pred(DBObject.BTCLDatabase.GetObjectNameList(IibSHTable).Count) do
    ComboBox1.Items.Add(DBObject.BTCLDatabase.GetObjectNameList(IibSHTable)[I]);
  for I := 0 to Pred(DBObject.BTCLDatabase.GetObjectNameList(IibSHView).Count) do
    ComboBox1.Items.Add(DBObject.BTCLDatabase.GetObjectNameList(IibSHView)[I]);
  ComboBox1.Sorted := True;
  ComboBox2.Items.Text := GetStatus;
  if AnsiContainsText(S, SFirebird21) then
  begin
   ComboBox3.Items.Text := GetTypePrefixFB21;
   ComboBox4.Items.Text := GetTypeSuffixFB21;
  end
  else
  begin
    ComboBox3.Items.Text := GetTypePrefix;
    if AnsiContainsText(S, SFirebird15) or AnsiContainsText(S, SFirebird20) then
      ComboBox4.Items.Text := GetTypeSuffixFB
    else
      ComboBox4.Items.Text := GetTypeSuffixIB;
  end
end;

procedure TibSHWizardTriggerForm.Edit2KeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'.. '9']) then Key := #0;
end;

end.
