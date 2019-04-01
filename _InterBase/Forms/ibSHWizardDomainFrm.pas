unit ibSHWizardDomainFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDDLWizardCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, StdCtrls, ExtCtrls, ComCtrls, StrUtils;

type
  TibSHWizardDomainForm = class(TibSHDDLWizardCustomForm)
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
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit2: TEdit;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Edit3: TEdit;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    Edit4: TEdit;
    ComboBox7: TComboBox;
    Panel3: TPanel;
    pSHSynEdit2: TpSHSynEdit;
    ComboBox8: TComboBox;
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
  private
    { Private declarations }
    FLoading: Boolean;
    procedure GetDataType;
    procedure GetDefaults;
    procedure GetCollates;
    function GetCollateID: Integer;
    procedure GetControls;
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
  ibSHWizardDomainForm: TibSHWizardDomainForm;

implementation

{$R *.dfm}

uses
  ibSHConsts, ibSHValues;

{ TibSHWizardDomainForm }

constructor TibSHWizardDomainForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  I: Integer;
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  InitPageCtrl(PageControl1);
  InitDescrEditor(pSHSynEdit1);
  SetFormSize(420, 400);

  Editor := pSHSynEdit2;
  Editor.Lines.Clear;
  RegisterEditors;

  for I := 0 to Pred(ComponentCount) do
  begin
    if (Components[I] is TComboBox) then (Components[I] as TComboBox).Text := EmptyStr;
    if (Components[I] is TEdit) then (Components[I] as TEdit).Text := EmptyStr;
  end;

  GetDataType;
  GetDefaults;

  Edit1.Text := DBObject.Caption;
  ComboBox1.ItemIndex := ComboBox1.Items.IndexOf((DBObject as IibSHDomain).DataType);
  if DBState <> csCreate then
  begin
    Edit2.Text := IntToStr((DBObject as IibSHDomain).Length);
    ComboBox2.ItemIndex := ComboBox2.Items.IndexOf(IntToStr((DBObject as IibSHDomain).Precision));
    ComboBox3.ItemIndex := ComboBox3.Items.IndexOf(IntToStr((DBObject as IibSHDomain).Scale));
    ComboBox4.ItemIndex := ComboBox4.Items.IndexOf((DBObject as IibSHDomain).SubType);
    Edit3.Text := IntToStr((DBObject as IibSHDomain).SegmentSize);
    Edit4.Text := (DBObject as IibSHDomain).ArrayDim;
    ComboBox5.ItemIndex := ComboBox5.Items.IndexOf((DBObject as IibSHDomain).Charset);
    GetCollates;
    ComboBox6.ItemIndex := ComboBox6.Items.IndexOf((DBObject as IibSHDomain).Collate);
    ComboBox7.ItemIndex := ComboBox7.Items.IndexOf((DBObject as IibSHDomain).NullType);
    ComboBox8.Text := TrimRight((DBObject as IibSHDomain).DefaultExpression.Text);
    Editor.Lines.Assign((DBObject as IibSHDomain).CheckConstraint);
  end;

  FLoading := True;
  try
    GetControls;
  finally
    FLoading := False;
  end;
end;

destructor TibSHWizardDomainForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHWizardDomainForm.SetTMPDefinitions;
begin
  TMPObject.Caption := NormalizeCaption(Trim(Edit1.Text));
  (TMPObject as IibSHDomain).DataType := Trim(ComboBox1.Text);
  if Length(Trim(Edit2.Text)) > 0 then
    (TMPObject as IibSHDomain).Length := StrToInt(Trim(Edit2.Text));
  if Length(Trim(ComboBox2.Text)) > 0 then
    (TMPObject as IibSHDomain).Precision := StrToInt(Trim(ComboBox2.Text));
  if Length(Trim(ComboBox3.Text)) > 0 then
    (TMPObject as IibSHDomain).Scale := StrToInt(Trim(ComboBox3.Text));
  (TMPObject as IibSHDomain).SubType := Trim(ComboBox4.Text);
  if Length(Trim(Edit3.Text)) > 0 then
    (TMPObject as IibSHDomain).SegmentSize := StrToInt(Trim(Edit3.Text));
  (TMPObject as IibSHDomain).ArrayDimID := Length(Trim(Edit4.Text));
  (TMPObject as IibSHDomain).ArrayDim := Trim(Edit4.Text);
  (TMPObject as IibSHDomain).Charset := Trim(ComboBox5.Text);
  (TMPObject as IibSHDomain).Collate := Trim(ComboBox6.Text);
  (TMPObject as IibSHDomain).NullType := Trim(ComboBox7.Text);
  (TMPObject as IibSHDomain).DefaultExpression.Text := Trim(ComboBox8.Text);
  if AnsiContainsText(ComboBox1.Text, 'CHAR') or
     AnsiContainsText(ComboBox1.Text, 'VARCHAR') then
  begin
    if (Length((TMPObject as IibSHDomain).DefaultExpression.Text) > 0) and
       (Pos('''', (TMPObject as IibSHDomain).DefaultExpression.Text) = 0) and
       not IsKeyword(Trim((TMPObject as IibSHDomain).DefaultExpression.Text)) then
      (TMPObject as IibSHDomain).DefaultExpression.Text := Format('''%s''', [Trim((TMPObject as IibSHDomain).DefaultExpression.Text)]);
  end;
  (TMPObject as IibSHDomain).CheckConstraint.Assign(Editor.Lines);

  (TMPObject as IibSHDomain).UseCustomValues := True;

  if DBState = csAlter then
  begin
    (TMPObject as IibSHDomain).NameWasChanged := not AnsiSameStr((TMPObject as IibSHDomain).Caption, (DBObject as IibSHDomain).Caption);
    (TMPObject as IibSHDomain).DataTypeWasChanged := not AnsiSameText((TMPObject as IibSHDomain).DataType, (DBObject as IibSHDomain).DataType);
    (TMPObject as IibSHDomain).DefaultWasChanged := not AnsiSameText((TMPObject as IibSHDomain).DefaultExpression.Text, (DBObject as IibSHDomain).DefaultExpression.Text);
    (TMPObject as IibSHDomain).CheckWasChanged := not AnsiSameText((TMPObject as IibSHDomain).CheckConstraint.Text, (DBObject as IibSHDomain).CheckConstraint.Text);
    (TMPObject as IibSHDomain).NullTypeWasChanged := not AnsiSameText((TMPObject as IibSHDomain).NullType, (DBObject as IibSHDomain).NullType);
    (TMPObject as IibSHDomain).CollateWasChanged := not AnsiSameText((TMPObject as IibSHDomain).Collate, (DBObject as IibSHDomain).Collate);
    (TMPObject as IibSHDomain).CollateID := GetCollateID;
    if not (TMPObject as IibSHDomain).DataTypeWasChanged then
    begin
      if AnsiContainsText(ComboBox1.Text, 'NUMERIC') or
         AnsiContainsText(ComboBox1.Text, 'DECIMAL') then
        (TMPObject as IibSHDomain).DataTypeWasChanged :=
          ((TMPObject as IibSHDomain).Precision <> (DBObject as IibSHDomain).Precision) or
          ((TMPObject as IibSHDomain).Scale <> (DBObject as IibSHDomain).Scale);

      if AnsiContainsText(ComboBox1.Text, 'CHAR') or
         AnsiContainsText(ComboBox1.Text, 'VARCHAR') then
        (TMPObject as IibSHDomain).DataTypeWasChanged :=
          ((TMPObject as IibSHDomain).Length <> (DBObject as IibSHDomain).Length) or
          ((TMPObject as IibSHDomain).CharSet <> (DBObject as IibSHDomain).CharSet);

      if AnsiContainsText(ComboBox1.Text, 'BLOB') then
        (TMPObject as IibSHDomain).DataTypeWasChanged :=
          ((TMPObject as IibSHDomain).SubType <> (DBObject as IibSHDomain).SubType) or
          ((TMPObject as IibSHDomain).SegmentSize <> (DBObject as IibSHDomain).SegmentSize) or
          ((TMPObject as IibSHDomain).CharSet <> (DBObject as IibSHDomain).CharSet);
    end;
  end;
end;

procedure TibSHWizardDomainForm.GetDataType;
var
  S: string;
  Dialect: Integer;
begin
  S := DBObject.BTCLDatabase.BTCLServer.Version;
  Dialect := DBObject.BTCLDatabase.SQLDialect;
  //
  // NOT NULL
  //
  ComboBox7.Items.Text := GetNullType;
  //
  // Precision and Scale
  //
  if Dialect = 1 then
  begin
    ComboBox2.Items.Delete(ComboBox2.Items.IndexOf('16'));
    ComboBox2.Items.Delete(ComboBox2.Items.IndexOf('17'));
    ComboBox2.Items.Delete(ComboBox2.Items.IndexOf('18'));

    ComboBox3.Items.Delete(ComboBox3.Items.IndexOf('16'));
    ComboBox3.Items.Delete(ComboBox3.Items.IndexOf('17'));
    ComboBox3.Items.Delete(ComboBox3.Items.IndexOf('18'));
  end;
  //
  // Charset and Collate
  //
  ComboBox5.Items.Text := GetCharsetFB10;
  ComboBox5.Sorted := True;
  //
  // Data Type
  //
  case Dialect of
   1:  ComboBox1.Items.Text := GetDataTypeD1;
  else
    if AnsiContainsText(S, SFirebird15) then
    begin
     ComboBox1.Items.Text := GetDataTypeFB15;
     ComboBox5.Items.Text := GetCharsetFB15
    end
    else
    if AnsiContainsText(S, SFirebird20) then
    begin
     ComboBox1.Items.Text := GetDataTypeFB15;
     ComboBox5.Items.Text := GetCharsetFB20
    end
    else
    if AnsiContainsText(S, SFirebird21) then
    begin
     ComboBox1.Items.Text := GetDataTypeFB15;
     ComboBox5.Items.Text := GetCharsetFB21
    end
    else
    if AnsiContainsText(S, SInterBase70) or
       AnsiContainsText(S, SInterBase71) or
       AnsiContainsText(S, SInterBase75) or
       AnsiContainsText(S, SInterBase2007) 
    then
    begin
      case Dialect of
        1: ComboBox1.Items.Text := GetDataTypeD1;
        3: ComboBox1.Items.Text := GetDataTypeIB70;
      end;
      if AnsiContainsText(S, SInterBase70) then
       ComboBox5.Items.Text := GetCharsetIB70;
      if AnsiContainsText(S, SInterBase71) then
       ComboBox5.Items.Text := GetCharsetIB71;
      if AnsiContainsText(S, SInterBase75) then
       ComboBox5.Items.Text := GetCharsetIB75;
    end
    else
    if AnsiContainsText(S, SFirebird1x) or
     AnsiContainsText(S, SInterBase6x) or AnsiContainsText(S, SInterBase65) then
    begin
      case Dialect of
        1: ComboBox1.Items.Text := GetDataTypeD1;
        3: ComboBox1.Items.Text := GetDataTypeD3;
      end;
    end;
  end;
  ComboBox5.Sorted := True;
end;

procedure TibSHWizardDomainForm.GetDefaults;
var
  S: string;
  Dialect: Integer;
begin
  S := DBObject.BTCLDatabase.BTCLServer.Version;
  Dialect := DBObject.BTCLDatabase.SQLDialect;

  ComboBox8.Items.Add('0');
  ComboBox8.Items.Add('''''');
  ComboBox8.Items.Add('''NOW''');
  ComboBox8.Items.Add('''TODAY''');
  ComboBox8.Items.Add('''TOMORROW''');
  ComboBox8.Items.Add('''YESTERDAY''');
  ComboBox8.Items.Add('NULL');
  ComboBox8.Items.Add('USER');
  if Dialect = 3 then
  begin
    ComboBox8.Items.Add('CURRENT_DATE');
    ComboBox8.Items.Add('CURRENT_TIME');
    ComboBox8.Items.Add('CURRENT_TIMESTAMP');
  end;
  if AnsiContainsText(S, 'Firebird') then
  begin
    ComboBox8.Items.Add('CURRENT_USER');
    ComboBox8.Items.Add('CURRENT_ROLE');
    if AnsiContainsText(S, SFirebird15) or AnsiContainsText(S, SFirebird20) or AnsiContainsText(S, SFirebird21)  then
    begin
      ComboBox8.Items.Add('CURRENT_CONNECTION');
      ComboBox8.Items.Add('CURRENT_TRANSACTION');
    end;
  end;
  ComboBox8.Sorted := True;
end;

procedure TibSHWizardDomainForm.GetCollates;
var
  S: string;
begin
  S := DBObject.BTCLDatabase.BTCLServer.Version;
  if ComboBox5.ItemIndex = -1 then Exit;

  if AnsiContainsText(S, SFirebird15)  then
  begin
    ComboBox6.Items.Text := GetCollateFromIDFB15(GetIDFromCharsetFB15(ComboBox5.Text));
    ComboBox6.Sorted := True;
    Exit;
  end;

  if AnsiContainsText(S, SFirebird20)  then
  begin
    ComboBox6.Items.Text := GetCollateFromIDFB20(GetIDFromCharsetFB20(ComboBox5.Text));
    ComboBox6.Sorted := True;
    Exit;
  end;

  if AnsiContainsText(S, SFirebird21)  then
  begin
    ComboBox6.Items.Text := GetCollateFromIDFB21(GetIDFromCharsetFB21(ComboBox5.Text));
    ComboBox6.Sorted := True;
    Exit;
  end;

  if AnsiContainsText(S, SInterBase70) then
  begin
    ComboBox6.Items.Text := GetCollateFromIDIB70(GetIDFromCharsetIB70(ComboBox5.Text));
    ComboBox6.Sorted := True;
    Exit;
  end;

  if AnsiContainsText(S, SInterBase71) then
  begin
    ComboBox6.Items.Text := GetCollateFromIDIB71(GetIDFromCharsetIB71(ComboBox5.Text));
    ComboBox6.Sorted := True;
    Exit;
  end;

  if AnsiContainsText(S, SInterBase75) or AnsiContainsText(S, SInterBase2007) then
  begin
    ComboBox6.Items.Text := GetCollateFromIDIB75(GetIDFromCharsetIB75(ComboBox5.Text));
    ComboBox6.Sorted := True;
    Exit;
  end;

  ComboBox6.Items.Text := GetCollateFromIDFB10(GetIDFromCharsetFB10(ComboBox5.Text));
  ComboBox6.Sorted := True;
end;

function TibSHWizardDomainForm.GetCollateID: Integer;
var
  S: string;
begin
  S := DBObject.BTCLDatabase.BTCLServer.Version;

  if AnsiContainsText(S, SFirebird15) then
  begin
    Result := GetIDFromCollateFB15(ComboBox5.Text, ComboBox6.Text);
    Exit;
  end;

  if AnsiContainsText(S, SFirebird20) then
  begin
    Result := GetIDFromCollateFB20(ComboBox5.Text, ComboBox6.Text);
    Exit;
  end;

  if AnsiContainsText(S, SFirebird21) then
  begin
    Result := GetIDFromCollateFB21(ComboBox5.Text, ComboBox6.Text);
    Exit;
  end;

  if AnsiContainsText(S, SInterBase70) then
  begin
    Result := GetIDFromCollateIB70(ComboBox5.Text, ComboBox6.Text);
    Exit;
  end;

  if AnsiContainsText(S, SInterBase71) then
  begin
    Result := GetIDFromCollateIB71(ComboBox5.Text, ComboBox6.Text);
    Exit;
  end;

  if AnsiContainsText(S, SInterBase75) or AnsiContainsText(S, SInterBase2007) then
  begin
    Result := GetIDFromCollateIB75(ComboBox5.Text, ComboBox6.Text);
    Exit;
  end;

  Result := GetIDFromCollateIB75(ComboBox5.Text, ComboBox6.Text);
end;

procedure TibSHWizardDomainForm.GetControls;
var
  I: Integer;
begin
  for I := 0 to Pred(ComponentCount) do
  begin
    if (Components[I] is TComboBox) then (Components[I] as TComboBox).Enabled := True;
    if (Components[I] is TComboBox) then (Components[I] as TComboBox).Color := clWindow;
    if (Components[I] is TEdit) then (Components[I] as TEdit).Enabled := True;
    if (Components[I] is TEdit) then (Components[I] as TEdit).Color := clWindow;
  end;

  if AnsiContainsText(ComboBox1.Text, 'SMALLINT') or
     AnsiContainsText(ComboBox1.Text, 'INTEGER') or
     AnsiContainsText(ComboBox1.Text, 'BOOLEAN') or
     AnsiContainsText(ComboBox1.Text, 'BIGINT') or
     AnsiContainsText(ComboBox1.Text, 'FLOAT') or
     AnsiContainsText(ComboBox1.Text, 'DOUBLE PRECISION') or
     AnsiContainsText(ComboBox1.Text, 'DATE') or
     AnsiContainsText(ComboBox1.Text, 'TIME') or
     AnsiContainsText(ComboBox1.Text, 'TIMESTAMP') then
  begin

    Edit2.Enabled := False;      // Length
    Edit2.Color := clBtnFace;
    Edit2.Text := EmptyStr;
    ComboBox2.Enabled := False;  // Precision
    ComboBox2.ItemIndex := -1;
    ComboBox2.Color := clBtnFace;
    ComboBox3.Enabled := False;  // Scale
    ComboBox3.ItemIndex := -1;
    ComboBox3.Color := clBtnFace;
    ComboBox4.Enabled := False;  // SubType
    ComboBox4.ItemIndex := -1;
    ComboBox4.Color := clBtnFace;
    Edit3.Enabled := False;      // SegmentSize
    Edit3.Color := clBtnFace;
    Edit3.Text := EmptyStr;
    ComboBox5.Enabled := False;  // Charset
    ComboBox5.ItemIndex := -1;
    ComboBox5.Color := clBtnFace;
    ComboBox6.Enabled := False;  // Collate
    ComboBox6.ItemIndex := -1;
    ComboBox6.Color := clBtnFace;
  end;

  if AnsiContainsText(ComboBox1.Text, 'NUMERIC') or
     AnsiContainsText(ComboBox1.Text, 'DECIMAL') then
  begin
    if not FLoading then
    begin
      ComboBox2.ItemIndex := ComboBox2.Items.IndexOf('15');
      ComboBox3.ItemIndex := ComboBox3.Items.IndexOf('2');
    end;

    Edit2.Enabled := False;      // Length
    Edit2.Color := clBtnFace;
    Edit2.Text := EmptyStr;
    ComboBox4.Enabled := False;  // SubType
    ComboBox4.ItemIndex := -1;
    ComboBox4.Color := clBtnFace;
    Edit3.Enabled := False;      // SegmentSize
    Edit3.Color := clBtnFace;
    Edit3.Text := EmptyStr;
    ComboBox5.Enabled := False;  // Charset
    ComboBox5.ItemIndex := -1;
    ComboBox5.Color := clBtnFace;
    ComboBox6.Enabled := False;  // Collate
    ComboBox6.ItemIndex := -1;
    ComboBox6.Color := clBtnFace;
  end;

  if AnsiContainsText(ComboBox1.Text, 'CHAR') or
     AnsiContainsText(ComboBox1.Text, 'VARCHAR') then
  begin
    if not FLoading then
    begin
      Edit2.Text := '30';
    end;

    ComboBox2.Enabled := False;  // Precision
    ComboBox2.ItemIndex := -1;
    ComboBox2.Color := clBtnFace;
    ComboBox3.Enabled := False;  // Scale
    ComboBox3.ItemIndex := -1;
    ComboBox3.Color := clBtnFace;
    ComboBox4.Enabled := False;  // SubType
    ComboBox4.ItemIndex := -1;
    ComboBox4.Color := clBtnFace;
    Edit3.Enabled := False;      // SegmentSize
    Edit3.Color := clBtnFace;
    Edit3.Text := EmptyStr;
  end;

  if AnsiContainsText(ComboBox1.Text, 'BLOB') then
  begin
    if not FLoading and not (Screen.ActiveControl = ComboBox4) then
    begin
      ComboBox4.ItemIndex := ComboBox4.Items.IndexOf('BINARY');
      Edit3.Text := '100';
    end;

    Edit2.Enabled := False;      // Length
    Edit2.Color := clBtnFace;
    Edit2.Text := EmptyStr;
    ComboBox2.Enabled := False;  // Precision
    ComboBox2.ItemIndex := -1;
    ComboBox2.Color := clBtnFace;
    ComboBox3.Enabled := False;  // Scale
    ComboBox3.ItemIndex := -1;
    ComboBox3.Color := clBtnFace;
    Edit4.Enabled := False;      // ArrayDim
    Edit4.Color := clBtnFace;
    Edit4.Text := EmptyStr;
    if AnsiContainsText(ComboBox4.Text, 'BINARY') then
    begin
      ComboBox5.Enabled := False;  // Charset
      ComboBox5.ItemIndex := -1;
      ComboBox5.Color := clBtnFace;
    end;
    ComboBox6.Enabled := False;  // Collate
    ComboBox6.ItemIndex := -1;
    ComboBox6.Color := clBtnFace;
  end;

  if DBState = csAlter then
  begin
    Edit4.Enabled := False;      // ArrayDim
    Edit4.Color := clBtnFace;
  end;
end;

procedure TibSHWizardDomainForm.Edit2KeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'.. '9']) then Key := #0;
end;

procedure TibSHWizardDomainForm.ComboBox1Change(Sender: TObject);
begin
  GetControls;
end;

procedure TibSHWizardDomainForm.ComboBox5Change(Sender: TObject);
begin
  GetCollates;
end;

end.
