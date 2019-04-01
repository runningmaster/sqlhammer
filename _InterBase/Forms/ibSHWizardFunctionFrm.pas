unit ibSHWizardFunctionFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDDLWizardCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, StdCtrls, ExtCtrls, ComCtrls, StrUtils,
  AppEvnts;

type
  TibSHWizardFunctionForm = class(TibSHDDLWizardCustomForm)
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
    GroupBox2: TGroupBox;
    Label2: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ComboBox6: TComboBox;
    Label8: TLabel;
    ComboBox7: TComboBox;
    Label9: TLabel;
    ComboBox8: TComboBox;
    Label10: TLabel;
    ComboBox9: TComboBox;
    Label11: TLabel;
    ComboBox10: TComboBox;
    Label12: TLabel;
    Edit4: TEdit;
    Label13: TLabel;
    Edit5: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    ComboBox11: TComboBox;
    ComboBox12: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    GroupBox3: TGroupBox;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    ApplicationEvents1: TApplicationEvents;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  private
    { Private declarations }
    FUseByDescriptor: Boolean;
    procedure GetDataType(AStrings: TStrings);
    function IsByValue(const S: string): Boolean;
    function IsFreeIt(const S: string): Boolean;
    function IsByDescriptor(const S: string): Boolean;
    function DelByValue(const S: string): string;
    function DelFreeIt(const S: string): string;
    function DelByDescriptor(const S: string): string;
    procedure ReverseParam(const AIndex: Integer; const AParam: string);
    procedure ReverseReturn(const AReturn: string);
    procedure FormatParams;
    procedure FormatReturns;
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
  ibSHWizardFunctionForm: TibSHWizardFunctionForm;

implementation

{$R *.dfm}

uses
  ibSHConsts, ibSHValues;

{ TibSHWizardFunctionForm }

constructor TibSHWizardFunctionForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  I: Integer;
begin
  FUseByDescriptor := True;
  inherited Create(AOwner, AParent, AComponent, ACallString);
  InitPageCtrl(PageControl1);
  InitDescrEditor(pSHSynEdit1);
  SetFormSize(400, 560);

  FUseByDescriptor := AnsiContainsText(DBObject.BTCLDatabase.BTCLServer.Version, 'Firebird');

  for I := 0 to Pred(ComponentCount) do
  begin
    if (Components[I] is TComboBox) then
    begin
      (Components[I] as TComboBox).Text := EmptyStr;
      if (Components[I] as TComboBox).Tag = 0 then GetDataType((Components[I] as TComboBox).Items);
    end;
    if (Components[I] is TEdit) then (Components[I] as TEdit).Text := EmptyStr;
  end;

  Edit1.Text := DBObject.Caption;
  if DBState <> csCreate then
  begin
    for I := 0 to Pred((DBObject as IibSHFunction).Params.Count) do
      ReverseParam(I, (DBObject as IibSHFunction).Params[I]);
    ReverseReturn((DBObject as IibSHFunction).Returns[0]);
    Edit4.Text := (DBObject as IibSHFunction).EntryPoint;
    Edit5.Text := (DBObject as IibSHFunction).ModuleName;
  end;

  Edit1.Enabled := not (DBState = csAlter);

  if FUseByDescriptor then GroupBox1.Caption := Format('%s%s ', [GroupBox1.Caption, '(By Desciptor params must be checked)']);
end;

destructor TibSHWizardFunctionForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHWizardFunctionForm.SetTMPDefinitions;
begin
  TMPObject.Caption := NormalizeCaption(Trim(Edit1.Text));
  FormatParams;
  FormatReturns;
  (TMPObject as IibSHFunction).EntryPoint := Trim(Edit4.Text);
  (TMPObject as IibSHFunction).ModuleName := Trim(Edit5.Text);
end;

procedure TibSHWizardFunctionForm.GetDataType(AStrings: TStrings);
var
  S: string;
  Dialect: Integer;
begin
  S := DBObject.BTCLDatabase.BTCLServer.Version;
  Dialect := DBObject.BTCLDatabase.SQLDialect;

  if AnsiContainsText(S, SFirebird15) or
   AnsiContainsText(S, SFirebird20) or AnsiContainsText(S, SFirebird21)
  then
  begin
    case Dialect of
      1: AStrings.Text := GetDataTypeD1;
      3: AStrings.Text := GetDataTypeFB15;
    end;
    AStrings.Add('CSTRING');
    Exit;
  end;

  if AnsiContainsText(S, SInterBase70) or
     AnsiContainsText(S, SInterBase71) or
     AnsiContainsText(S, SInterBase75) or
     AnsiContainsText(S, SInterBase2007) 
  then
  begin
    case Dialect of
      1: AStrings.Text := GetDataTypeD1;
      3: AStrings.Text := GetDataTypeIB70;
    end;
    AStrings.Add('CSTRING');
    Exit;
  end;

  if AnsiContainsText(S, SFirebird1x) or
     AnsiContainsText(S, SInterBase6x) or AnsiContainsText(S, SInterBase65) then
  begin
    case Dialect of
      1: AStrings.Text := GetDataTypeD1;
      3: AStrings.Text := GetDataTypeD3;
    end;
    AStrings.Add('CSTRING');
    Exit;
  end;

  AStrings.Text := GetDataTypeD1;
  AStrings.Add('CSTRING');
end;

function TibSHWizardFunctionForm.IsByValue(const S: string): Boolean;
begin
  Result := AnsiContainsText(S, 'BY VALUE');
end;

function TibSHWizardFunctionForm.IsFreeIt(const S: string): Boolean;
begin
  Result := AnsiContainsText(S, 'FREE_IT');
end;

function TibSHWizardFunctionForm.IsByDescriptor(const S: string): Boolean;
begin
  Result := AnsiContainsText(S, 'BY DESCRIPTOR');
end;

function TibSHWizardFunctionForm.DelByValue(const S: string): string;
begin
  Result := Trim(AnsiReplaceText(S, 'BY VALUE', EmptyStr));
end;

function TibSHWizardFunctionForm.DelFreeIt(const S: string): string;
begin
  Result := Trim(AnsiReplaceText(S, 'FREE_IT', EmptyStr));
end;

function TibSHWizardFunctionForm.DelByDescriptor(const S: string): string;
begin
  Result := Trim(AnsiReplaceText(S, 'BY DESCRIPTOR', EmptyStr));
end;

procedure TibSHWizardFunctionForm.ReverseParam(const AIndex: Integer; const AParam: string);
var
  S: string;
  B: Boolean;
begin
  S := AParam;
  B := False;

  if IsByDescriptor(AParam) then
  begin
    S := DelByDescriptor(S);
    B := True;
  end;

  case AIndex of
    0: ComboBox1.Text := S;
    1: ComboBox2.Text := S;
    2: ComboBox3.Text := S;
    3: ComboBox4.Text := S;
    4: ComboBox5.Text := S;
    5: ComboBox6.Text := S;
    6: ComboBox7.Text := S;
    7: ComboBox8.Text := S;
    8: ComboBox9.Text := S;
    9: ComboBox10.Text := S;
  end;

  case AIndex of
    0: CheckBox1.Checked := B;
    1: CheckBox2.Checked := B;
    2: CheckBox3.Checked := B;
    3: CheckBox4.Checked := B;
    4: CheckBox5.Checked := B;
    5: CheckBox6.Checked := B;
    6: CheckBox7.Checked := B;
    7: CheckBox8.Checked := B;
    8: CheckBox9.Checked := B;
    9: CheckBox10.Checked := B;
  end;
end;

procedure TibSHWizardFunctionForm.ReverseReturn(const AReturn: string);
var
  S: string;
begin
  S := AReturn;
  if (DBObject as IibSHFunction).ReturnsArgument = 0 then
  begin
    RadioButton1.Checked := True;
    if IsByValue(S) then
    begin
      ComboBox11.Text := DelByValue(S);
      RadioButton3.Checked := True;
      Exit;
    end;
    if IsFreeIt(S) then
    begin
      ComboBox11.Text := DelFreeIt(S);
      RadioButton4.Checked := True;
      Exit;
    end;
    if IsByDescriptor(S) then
    begin
      ComboBox11.Text := DelByDescriptor(S);
      RadioButton5.Checked := True;
      Exit;
    end;
    ComboBox11.Text := S;
  end else
  begin
    RadioButton2.Checked := True;
    ComboBox12.ItemIndex := Pred((DBObject as IibSHFunction).ReturnsArgument);
  end;
end;

procedure TibSHWizardFunctionForm.FormatParams;
var
  S: string;
begin
  // 1
  S := Trim(ComboBox1.Text);
  if (Length(S) > 0) and CheckBox1.Checked then S := Format('%s BY DESCRIPTOR', [S]);
  if Length(S) > 0 then (TMPObject as IibSHFunction).Params.Add(S);
  // 2
  S := Trim(ComboBox2.Text);
  if (Length(S) > 0) and CheckBox2.Checked then S := Format('%s BY DESCRIPTOR', [S]);
  if Length(S) > 0 then (TMPObject as IibSHFunction).Params.Add(S);
  // 3
  S := Trim(ComboBox3.Text);
  if (Length(S) > 0) and CheckBox3.Checked then S := Format('%s BY DESCRIPTOR', [S]);
  if Length(S) > 0 then (TMPObject as IibSHFunction).Params.Add(S);
  // 4
  S := Trim(ComboBox4.Text);
  if (Length(S) > 0) and CheckBox4.Checked then S := Format('%s BY DESCRIPTOR', [S]);
  if Length(S) > 0 then (TMPObject as IibSHFunction).Params.Add(S);
  // 5
  S := Trim(ComboBox5.Text);
  if (Length(S) > 0) and CheckBox5.Checked then S := Format('%s BY DESCRIPTOR', [S]);
  if Length(S) > 0 then (TMPObject as IibSHFunction).Params.Add(S);
  // 6
  S := Trim(ComboBox6.Text);
  if (Length(S) > 0) and CheckBox6.Checked then S := Format('%s BY DESCRIPTOR', [S]);
  if Length(S) > 0 then (TMPObject as IibSHFunction).Params.Add(S);
  // 7
  S := Trim(ComboBox7.Text);
  if (Length(S) > 0) and CheckBox7.Checked then S := Format('%s BY DESCRIPTOR', [S]);
  if Length(S) > 0 then (TMPObject as IibSHFunction).Params.Add(S);
  // 8
  S := Trim(ComboBox8.Text);
  if (Length(S) > 0) and CheckBox8.Checked then S := Format('%s BY DESCRIPTOR', [S]);
  if Length(S) > 0 then (TMPObject as IibSHFunction).Params.Add(S);
  // 9
  S := Trim(ComboBox9.Text);
  if (Length(S) > 0) and CheckBox9.Checked then S := Format('%s BY DESCRIPTOR', [S]);
  if Length(S) > 0 then (TMPObject as IibSHFunction).Params.Add(S);
  // 10
  S := Trim(ComboBox10.Text);
  if (Length(S) > 0) and CheckBox10.Checked then S := Format('%s BY DESCRIPTOR', [S]);
  if Length(S) > 0 then (TMPObject as IibSHFunction).Params.Add(S);
end;

procedure TibSHWizardFunctionForm.FormatReturns;
var
  S: string;
begin
  if RadioButton1.Checked then
  begin
    S := Trim(ComboBox11.Text);
    if RadioButton3.Checked then S := Format('%s BY VALUE', [S]);
    if RadioButton4.Checked then S := Format('%s FREE_IT', [S]);
    if RadioButton5.Checked then S := Format('%s BY DESCRIPTOR', [S]);
  end else
    S := Format('PARAMETER %s', [ComboBox12.Text]);

  (TMPObject as IibSHFunction).Returns.Add(S);
end;

procedure TibSHWizardFunctionForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  CheckBox1.Visible := FUseByDescriptor;
  CheckBox2.Visible := FUseByDescriptor;
  CheckBox3.Visible := FUseByDescriptor;
  CheckBox4.Visible := FUseByDescriptor;
  CheckBox5.Visible := FUseByDescriptor;
  CheckBox6.Visible := FUseByDescriptor;
  CheckBox7.Visible := FUseByDescriptor;
  CheckBox8.Visible := FUseByDescriptor;
  CheckBox9.Visible := FUseByDescriptor;
  CheckBox10.Visible := FUseByDescriptor;
  RadioButton5.Visible := FUseByDescriptor;

  ComboBox11.Enabled := RadioButton1.Checked;
  RadioButton3.Enabled := RadioButton1.Checked and not AnsiContainsText(ComboBox11.Text, 'CSTRING');
  RadioButton4.Enabled := RadioButton1.Checked and AnsiContainsText(ComboBox11.Text, 'CSTRING');
  RadioButton5.Enabled := RadioButton1.Checked and not AnsiContainsText(ComboBox11.Text, 'CSTRING');

  ComboBox12.Enabled := RadioButton2.Checked;
end;

end.
