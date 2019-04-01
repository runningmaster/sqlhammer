unit ibSHWizardFieldFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDDLWizardCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, StdCtrls, ExtCtrls, ComCtrls, StrUtils;

type
  TibSHFieldBasedOn = (fboDomain, fboDataType, fboComputed);

  TibSHWizardFieldForm = class(TibSHDDLWizardCustomForm)
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
    Label3: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    DomainPanel: TPanel;
    DatatypePanel: TPanel;
    ComputedPanel: TPanel;
    pSHSynEdit2: TpSHSynEdit;
    Label4: TLabel;
    ComboBox3: TComboBox;
    Label5: TLabel;
    Panel3: TPanel;
    pSHSynEdit3: TpSHSynEdit;
    Label13: TLabel;
    Label11: TLabel;
    Label9: TLabel;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    Label6: TLabel;
    ComboBox7: TComboBox;
    Label7: TLabel;
    Edit2: TEdit;
    Label8: TLabel;
    ComboBox8: TComboBox;
    Label10: TLabel;
    ComboBox9: TComboBox;
    Label12: TLabel;
    ComboBox10: TComboBox;
    Label14: TLabel;
    Edit3: TEdit;
    Label15: TLabel;
    Edit4: TEdit;
    Label16: TLabel;
    ComboBox11: TComboBox;
    Label17: TLabel;
    ComboBox12: TComboBox;
    Label18: TLabel;
    ComboBox13: TComboBox;
    Label19: TLabel;
    ComboBox14: TComboBox;
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox7Change(Sender: TObject);
    procedure ComboBox11Change(Sender: TObject);
  private
    { Private declarations }
    FLoading: Boolean;
    FFieldBasedOn: TibSHFieldBasedOn;
    FDomainCharset: string;
    vCodeNormalizer: IibSHCodeNormalizer;    
    procedure SetFieldBasedOn(Value: TibSHFieldBasedOn);

    procedure InitPanel(APanel: TPanel);

    procedure GetDataType;
    procedure GetDomainSource;
    procedure GetDefaults(AStrings: TStrings);
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

    property FieldBasedOn: TibSHFieldBasedOn read FFieldBasedOn write SetFieldBasedOn;
  end;

var
  ibSHWizardFieldForm: TibSHWizardFieldForm;

implementation

{$R *.dfm}

uses
  ibSHConsts, ibSHValues;

{ TibSHWizardFieldForm }

constructor TibSHWizardFieldForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  I: Integer;
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  if not Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer) then
   vCodeNormalizer:=nil;

  InitPageCtrl(PageControl1);
  InitDescrEditor(pSHSynEdit1);
  SetFormSize(420, 400);

  InitPanel(DomainPanel);
  InitPanel(DatatypePanel);
  InitPanel(ComputedPanel);
  ComputedPanel.BevelInner := bvLowered;
  ComputedPanel.Top := 88;
  ComputedPanel.Height := 226;
  
  Editor := pSHSynEdit2;
  Editor.Lines.Clear;
  RegisterEditors;

  Editor := pSHSynEdit3;
  Editor.Lines.Clear;
  RegisterEditors;
  pSHSynEdit3.Color := clBtnFace;
  pSHSynEdit3.ActiveLineColor := clNone;
  pSHSynEdit3.Gutter.Width := 4;
  pSHSynEdit3.Gutter.Color := pSHSynEdit3.Color;
  pSHSynEdit3.BottomEdgeVisible := False;


  for I := 0 to Pred(ComponentCount) do
  begin
    if (Components[I] is TComboBox) then (Components[I] as TComboBox).Text := EmptyStr;
    if (Components[I] is TEdit) then (Components[I] as TEdit).Text := EmptyStr;
  end;

  GetDataType;
  GetDefaults(ComboBox5.Items);
  ComboBox5.Sorted := True;
  GetDefaults(ComboBox14.Items);
  ComboBox14.Sorted := True;

  Edit1.Text := DBObject.Caption;
  if Assigned(vCodeNormalizer)  then
   ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(
    vCodeNormalizer.MetadataNameToSourceDDL(DBObject.BTCLDatabase,(DBObject as IibSHDomain).TableName)
   )
  else
   ComboBox1.ItemIndex := ComboBox1.Items.IndexOf((DBObject as IibSHDomain).TableName);
  ComboBox2.ItemIndex := 0;
  ComboBox2Change(ComboBox2);

  ComboBox7.ItemIndex := ComboBox7.Items.IndexOf((DBObject as IibSHDomain).DataType);
(*
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

*)

  FLoading := True;
  try
    GetControls;
  finally
    FLoading := False;
  end;
end;

destructor TibSHWizardFieldForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHWizardFieldForm.SetTMPDefinitions;
begin
  TMPObject.Caption := NormalizeCaption(Trim(Edit1.Text));
  (TMPObject as IibSHDomain).TableName := NormalizeCaption(Trim(ComboBox1.Text));

  case FieldBasedOn of
    fboDomain:
      begin
        (TMPObject as IibSHDomain).Domain := Trim(ComboBox3.Text);
        (TMPObject as IibSHDomain).FieldNullType := Trim(ComboBox4.Text);
        (TMPObject as IibSHDomain).FieldDefault.Text := Trim(ComboBox5.Text);
        if Length(FDomainCharset) > 0 then
        begin
          if (Length((TMPObject as IibSHDomain).FieldDefault.Text) > 0) and
             (Pos('''', (TMPObject as IibSHDomain).FieldDefault.Text) = 0) and
             not IsKeyword(Trim((TMPObject as IibSHDomain).FieldDefault.Text)) then
            (TMPObject as IibSHDomain).FieldDefault.Text := Format('''%s''', [Trim((TMPObject as IibSHDomain).FieldDefault.Text)]);
        end;
        (TMPObject as IibSHDomain).FieldCollate := Trim(ComboBox6.Text);
      end;
    fboDataType:
      begin
        (TMPObject as IibSHDomain).DataType := Trim(ComboBox7.Text);
        if Length(Trim(Edit2.Text)) > 0 then
          (TMPObject as IibSHDomain).Length := StrToInt(Trim(Edit2.Text));
        if Length(Trim(ComboBox8.Text)) > 0 then
          (TMPObject as IibSHDomain).Precision := StrToInt(Trim(ComboBox8.Text));
        if Length(Trim(ComboBox9.Text)) > 0 then
          (TMPObject as IibSHDomain).Scale := StrToInt(Trim(ComboBox9.Text));
        (TMPObject as IibSHDomain).SubType := Trim(ComboBox10.Text);
        if Length(Trim(Edit3.Text)) > 0 then
          (TMPObject as IibSHDomain).SegmentSize := StrToInt(Trim(Edit3.Text));
        (TMPObject as IibSHDomain).ArrayDimID := Length(Trim(Edit4.Text)); 
        (TMPObject as IibSHDomain).ArrayDim := Trim(Edit4.Text);
        (TMPObject as IibSHDomain).Charset := Trim(ComboBox11.Text);
        (TMPObject as IibSHDomain).Collate := Trim(ComboBox12.Text);
        (TMPObject as IibSHDomain).NullType := Trim(ComboBox13.Text);
        (TMPObject as IibSHDomain).DefaultExpression.Text := Trim(ComboBox14.Text);
        if AnsiContainsText(ComboBox7.Text, 'CHAR') or
           AnsiContainsText(ComboBox7.Text, 'VARCHAR') then
        begin
          if (Length((TMPObject as IibSHDomain).DefaultExpression.Text) > 0) and
             (Pos('''', (TMPObject as IibSHDomain).DefaultExpression.Text) = 0) and
             not IsKeyword(Trim((TMPObject as IibSHDomain).DefaultExpression.Text)) then
            (TMPObject as IibSHDomain).DefaultExpression.Text := Format('''%s''', [Trim((TMPObject as IibSHDomain).DefaultExpression.Text)]);
        end;
//        (TMPObject as IibSHDomain).CheckConstraint.Assign(Editor.Lines);

      (*
        if DBState = csAlter then
        begin
          (TMPObject as IibSHDomain).NameWasChanged := CompareStr((TMPObject as IibSHDomain).Caption, (DBObject as IibSHDomain).Caption) <> 0;
          (TMPObject as IibSHDomain).DataTypeWasChanged := AnsiSameText((TMPObject as IibSHDomain).DataType, (DBObject as IibSHDomain).DataType) <> 0;
          (TMPObject as IibSHDomain).DefaultWasChanged := AnsiSameText((TMPObject as IibSHDomain).DefaultExpression.Text, (DBObject as IibSHDomain).DefaultExpression.Text) <> 0;
          (TMPObject as IibSHDomain).CheckWasChanged := AnsiSameText((TMPObject as IibSHDomain).CheckConstraint.Text, (DBObject as IibSHDomain).CheckConstraint.Text) <> 0;
          (TMPObject as IibSHDomain).NullTypeWasChanged := AnsiSameText((TMPObject as IibSHDomain).NullType, (DBObject as IibSHDomain).NullType) <> 0;
          (TMPObject as IibSHDomain).CollateWasChanged := AnsiSameText((TMPObject as IibSHDomain).Collate, (DBObject as IibSHDomain).Collate) <> 0;
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
      *)
      end;
    fboComputed:
      begin
        (TMPObject as IibSHDomain).DataType := EmptyStr;
        (TMPObject as IibSHDomain).ComputedSource.Assign(pSHSynEdit2.Lines);
      end;
  end;

  (TMPObject as IibSHDomain).UseCustomValues := True;
end;

procedure TibSHWizardFieldForm.SetFieldBasedOn(Value: TibSHFieldBasedOn);
begin
  FFieldBasedOn := Value;

  DomainPanel.Visible := False;
  DatatypePanel.Visible := False;
  ComputedPanel.Visible := False;

  case FFieldBasedOn of
    fboDomain: DomainPanel.Visible := True;
    fboDataType: DatatypePanel.Visible := True;
    fboComputed: ComputedPanel.Visible := True;
  end;

  GetControls;
end;

procedure TibSHWizardFieldForm.InitPanel(APanel: TPanel);
begin
  APanel.Left := 4;
  APanel.Top := 84;
  APanel.Height := 230;
  APanel.Width := 350;
  APanel.BevelOuter := bvNone;
  APanel.Visible := False;
end;

procedure TibSHWizardFieldForm.GetDataType;
var
  S: string;
  I: Integer;
  Dialect: Integer;

begin

  Dialect := DBObject.BTCLDatabase.SQLDialect;
  //
  // Список таблиц
  //
  for I := 0 to Pred(DBObject.BTCLDatabase.GetObjectNameList(IibSHTable).Count) do
  begin
   S:=DBObject.BTCLDatabase.GetObjectNameList(IibSHTable)[I];
   if Assigned(vCodeNormalizer)  then
    ComboBox1.Items.Add(vCodeNormalizer.MetadataNameToSourceDDL(DBObject.BTCLDatabase,S))
   else
    ComboBox1.Items.Add(S);
  end;
  //
  // Список доменов
  //
  for I := 0 to Pred(DBObject.BTCLDatabase.GetObjectNameList(IibSHDomain).Count) do
    ComboBox3.Items.Add(DBObject.BTCLDatabase.GetObjectNameList(IibSHDomain)[I]);
  //
  // NOT NULL
  //
  ComboBox4.Items.Text := GetNullType;
  ComboBox13.Items.Text := GetNullType;
  S := DBObject.BTCLDatabase.BTCLServer.Version;  
  //
  // Precision and Scale
  //
  if Dialect = 1 then
  begin
    ComboBox8.Items.Delete(ComboBox8.Items.IndexOf('16'));
    ComboBox8.Items.Delete(ComboBox8.Items.IndexOf('17'));
    ComboBox8.Items.Delete(ComboBox8.Items.IndexOf('18'));

    ComboBox9.Items.Delete(ComboBox9.Items.IndexOf('16'));
    ComboBox9.Items.Delete(ComboBox9.Items.IndexOf('17'));
    ComboBox9.Items.Delete(ComboBox9.Items.IndexOf('18'));
  end;
  //
  // Charset and Collate
  //
  ComboBox11.Items.Text := GetCharsetFB10;
  ComboBox11.Sorted := True;
  //
  // Data Type
  //
  if AnsiContainsText(S, SFirebird15) or AnsiContainsText(S, SFirebird20) or AnsiContainsText(S, SFirebird21)  then
  begin
    case Dialect of
      1: ComboBox7.Items.Text := GetDataTypeD1;
      3: ComboBox7.Items.Text := GetDataTypeFB15;
    end;
    if AnsiContainsText(S, SFirebird21) then
     ComboBox11.Items.Text := GetCharsetFB21
    else
    if AnsiContainsText(S, SFirebird20) then
     ComboBox11.Items.Text := GetCharsetFB20
    else
     ComboBox11.Items.Text := GetCharsetFB15;
    ComboBox11.Sorted := True;
    Exit;
  end;

  if AnsiContainsText(S, SInterBase70) or
     AnsiContainsText(S, SInterBase71) or
     AnsiContainsText(S, SInterBase75) or
     AnsiContainsText(S, SInterBase2007)
  then
  begin
    case Dialect of
      1: ComboBox7.Items.Text := GetDataTypeD1;
      3: ComboBox7.Items.Text := GetDataTypeIB70;
    end;
    if AnsiContainsText(S, SInterBase70) then ComboBox11.Items.Text := GetCharsetIB70;
    if AnsiContainsText(S, SInterBase71) then ComboBox11.Items.Text := GetCharsetIB71;
    if AnsiContainsText(S, SInterBase75)or  AnsiContainsText(S, SInterBase2007)
     then ComboBox11.Items.Text := GetCharsetIB75;
    ComboBox11.Sorted := True;
    Exit;
  end;

  if AnsiContainsText(S, SFirebird1x) or
     AnsiContainsText(S, SInterBase6x) or AnsiContainsText(S, SInterBase65) then
  begin
    case Dialect of
      1: ComboBox7.Items.Text := GetDataTypeD1;
      3: ComboBox7.Items.Text := GetDataTypeD3;
    end;
    Exit;
  end;

  ComboBox7.Items.Text := GetDataTypeD1;
end;

procedure TibSHWizardFieldForm.GetDomainSource;
var
  Domain: TSHComponent;
  DBDomain: IibSHDomain;
begin
  pSHSynEdit3.Clear;

  Domain := Designer.GetComponent(IibSHDomain).Create(nil);
  Supports(Domain, IibSHDomain, DBDomain);
  DBDomain.Caption := ComboBox3.Text;
  DBDomain.OwnerIID := DBObject.OwnerIID;
  DBDomain.State := csSource;
  
  try
    Screen.Cursor := crHourGlass;
    Designer.TextToStrings(DDLGenerator.GetDDLText(DBDomain), pSHSynEdit3.Lines, True);
    if AnsiContainsText(DBDomain.DataType, 'CHAR') or
       AnsiContainsText(DBDomain.DataType, 'VARCHAR') then
    begin
      FDomainCharset := DBDomain.Charset;
      ComboBox6.Text := EmptyStr;
      ComboBox6.Enabled := True;
      ComboBox6.Color := clWindow;
      GetCollates;
    end else
    begin
      FDomainCharset := EmptyStr;
      ComboBox6.Text := EmptyStr;
      ComboBox6.Enabled := False;
      ComboBox6.Color := clBtnFace;
    end;
  finally
    Screen.Cursor := crDefault;
    DBDomain := nil;
    FreeAndNil(Domain);
  end;
end;

procedure TibSHWizardFieldForm.GetDefaults(AStrings: TStrings);
var
  S: string;
  Dialect: Integer;
begin
  S := DBObject.BTCLDatabase.BTCLServer.Version;
  Dialect := DBObject.BTCLDatabase.SQLDialect;

  AStrings.Add('0');
  AStrings.Add('''''');
  AStrings.Add('''NOW''');
  AStrings.Add('''TODAY''');
  AStrings.Add('''TOMORROW''');
  AStrings.Add('''YESTERDAY''');
  AStrings.Add('NULL');
  AStrings.Add('USER');
  if Dialect = 3 then
  begin
    AStrings.Add('CURRENT_DATE');
    AStrings.Add('CURRENT_TIME');
    AStrings.Add('CURRENT_TIMESTAMP');
  end;
  if AnsiContainsText(S, 'Firebird') then
  begin
    AStrings.Add('CURRENT_USER');
    AStrings.Add('CURRENT_ROLE');
    if AnsiContainsText(S, SFirebird15) or AnsiContainsText(S, SFirebird20)
     or AnsiContainsText(S, SFirebird21)
    then
    begin
      AStrings.Add('CURRENT_CONNECTION');
      AStrings.Add('CURRENT_TRANSACTION');
    end;
  end;
end;

procedure TibSHWizardFieldForm.GetCollates;
var
  S: string;
  vCombo: TComboBox;
  vCharset: string;
begin
  S := DBObject.BTCLDatabase.BTCLServer.Version;
  vCombo := nil;
  
  case FieldBasedOn of
    fboDomain:
      begin
        vCombo := ComboBox6;
        vCharset := FDomainCharset;
      end;
    fboDataType:
      begin
        if ComboBox11.ItemIndex = -1 then Exit;
        vCombo := ComboBox12;
        vCharset := ComboBox11.Text;
      end;
    fboComputed:;
  end;

  if not Assigned(vCombo) then Exit;
  
  if AnsiContainsText(S, SFirebird15) then
  begin
    vCombo.Items.Text := GetCollateFromIDFB15(GetIDFromCharsetFB15(vCharset));
    vCombo.Items.Insert(0, ' ');
    vCombo.Sorted := True;
    Exit;
  end;

  if AnsiContainsText(S, SFirebird20) then
  begin
    vCombo.Items.Text := GetCollateFromIDFB20(GetIDFromCharsetFB20(vCharset));
    vCombo.Items.Insert(0, ' ');
    vCombo.Sorted := True;
    Exit;
  end;

  if AnsiContainsText(S, SFirebird21) then
  begin
    vCombo.Items.Text := GetCollateFromIDFB21(GetIDFromCharsetFB21(vCharset));
    vCombo.Items.Insert(0, ' ');
    vCombo.Sorted := True;
    Exit;
  end;

  if AnsiContainsText(S, SInterBase70) then
  begin
    vCombo.Items.Text := GetCollateFromIDIB70(GetIDFromCharsetIB70(vCharset));
    vCombo.Items.Insert(0, ' ');
    vCombo.Sorted := True;
    Exit;
  end;

  if AnsiContainsText(S, SInterBase71) then
  begin
    vCombo.Items.Text := GetCollateFromIDIB71(GetIDFromCharsetIB71(vCharset));
    vCombo.Items.Insert(0, ' ');
    vCombo.Sorted := True;
    Exit;
  end;

  if AnsiContainsText(S, SInterBase75) or AnsiContainsText(S, SInterBase2007)  then
  begin
    vCombo.Items.Text := GetCollateFromIDIB75(GetIDFromCharsetIB71(vCharset));
    vCombo.Items.Insert(0, ' ');
    vCombo.Sorted := True;
    Exit;
  end;

  vCombo.Items.Text := GetCollateFromIDFB10(GetIDFromCharsetFB10(vCharset));
  vCombo.Items.Insert(0, ' ');
  vCombo.Sorted := True;
end;

function TibSHWizardFieldForm.GetCollateID: Integer;
var
  S: string;
begin
  S := DBObject.BTCLDatabase.BTCLServer.Version;

  if AnsiContainsText(S, SFirebird15) then
  begin
    Result := GetIDFromCollateFB15(ComboBox11.Text, ComboBox12.Text);
    Exit;
  end;

  if AnsiContainsText(S, SFirebird20) then
  begin
    Result := GetIDFromCollateFB20(ComboBox11.Text, ComboBox12.Text);
    Exit;
  end;

  if AnsiContainsText(S, SFirebird21) then
  begin
    Result := GetIDFromCollateFB21(ComboBox11.Text, ComboBox12.Text);
    Exit;
  end;

  if AnsiContainsText(S, SInterBase70) then
  begin
    Result := GetIDFromCollateIB70(ComboBox11.Text, ComboBox12.Text);
    Exit;
  end;

  if AnsiContainsText(S, SInterBase71) then
  begin
    Result := GetIDFromCollateIB71(ComboBox11.Text, ComboBox12.Text);
    Exit;
  end;

  if AnsiContainsText(S, SInterBase75) or AnsiContainsText(S, SInterBase2007) then
  begin
    Result := GetIDFromCollateIB75(ComboBox11.Text, ComboBox12.Text);
    Exit;
  end;

  Result := GetIDFromCollateIB75(ComboBox11.Text, ComboBox12.Text);
end;

procedure TibSHWizardFieldForm.GetControls;
var
  I: Integer;
begin
  ComboBox6.Text := EmptyStr;
  ComboBox6.Enabled := False;
  ComboBox6.Color := clBtnFace;

  for I := 0 to Pred(ComponentCount) do
  begin
    if (Components[I] is TWinControl) and ((Components[I] as TWinControl).Parent = DatatypePanel) then
    begin
      if (Components[I] is TComboBox) then (Components[I] as TComboBox).Enabled := True;
      if (Components[I] is TComboBox) then (Components[I] as TComboBox).Color := clWindow;
      if (Components[I] is TEdit) then (Components[I] as TEdit).Enabled := True;
      if (Components[I] is TEdit) then (Components[I] as TEdit).Color := clWindow;
    end;
  end;

  if AnsiContainsText(ComboBox7.Text, 'SMALLINT') or
     AnsiContainsText(ComboBox7.Text, 'INTEGER') or
     AnsiContainsText(ComboBox7.Text, 'BOOLEAN') or
     AnsiContainsText(ComboBox7.Text, 'BIGINT') or
     AnsiContainsText(ComboBox7.Text, 'FLOAT') or
     AnsiContainsText(ComboBox7.Text, 'DOUBLE PRECISION') or
     AnsiContainsText(ComboBox7.Text, 'DATE') or
     AnsiContainsText(ComboBox7.Text, 'TIME') or
     AnsiContainsText(ComboBox7.Text, 'TIMESTAMP') then
  begin
    Edit2.Enabled := False;      // Length
    Edit2.Color := clBtnFace;
    Edit2.Text := EmptyStr;
    ComboBox8.Enabled := False;  // Precision
    ComboBox8.ItemIndex := -1;
    ComboBox8.Color := clBtnFace;
    ComboBox9.Enabled := False;  // Scale
    ComboBox9.ItemIndex := -1;
    ComboBox9.Color := clBtnFace;
    ComboBox10.Enabled := False;  // SubType
    ComboBox10.ItemIndex := -1;
    ComboBox10.Color := clBtnFace;
    Edit3.Enabled := False;      // SegmentSize
    Edit3.Color := clBtnFace;
    Edit3.Text := EmptyStr;
    ComboBox11.Enabled := False;  // Charset
    ComboBox11.ItemIndex := -1;
    ComboBox11.Color := clBtnFace;
    ComboBox12.Enabled := False;  // Collate
    ComboBox12.ItemIndex := -1;
    ComboBox12.Color := clBtnFace;
  end;

  if AnsiContainsText(ComboBox7.Text, 'NUMERIC') or
     AnsiContainsText(ComboBox7.Text, 'DECIMAL') then
  begin
    if not FLoading then
    begin
      ComboBox8.ItemIndex := ComboBox8.Items.IndexOf('15');
      ComboBox9.ItemIndex := ComboBox9.Items.IndexOf('2');
    end;

    Edit2.Enabled := False;      // Length
    Edit2.Color := clBtnFace;
    Edit2.Text := EmptyStr;
    ComboBox10.Enabled := False;  // SubType
    ComboBox10.ItemIndex := -1;
    ComboBox10.Color := clBtnFace;
    Edit3.Enabled := False;      // SegmentSize
    Edit3.Color := clBtnFace;
    Edit3.Text := EmptyStr;
    ComboBox11.Enabled := False;  // Charset
    ComboBox11.ItemIndex := -1;
    ComboBox11.Color := clBtnFace;
    ComboBox12.Enabled := False;  // Collate
    ComboBox12.ItemIndex := -1;
    ComboBox12.Color := clBtnFace;
  end;

  if AnsiContainsText(ComboBox7.Text, 'CHAR') or
     AnsiContainsText(ComboBox7.Text, 'VARCHAR') then
  begin
    if not FLoading then
    begin
      Edit2.Text := '30';
    end;

    ComboBox8.Enabled := False;  // Precision
    ComboBox8.ItemIndex := -1;
    ComboBox8.Color := clBtnFace;
    ComboBox9.Enabled := False;  // Scale
    ComboBox9.ItemIndex := -1;
    ComboBox9.Color := clBtnFace;
    ComboBox10.Enabled := False;  // SubType
    ComboBox10.ItemIndex := -1;
    ComboBox10.Color := clBtnFace;
    Edit3.Enabled := False;      // SegmentSize
    Edit3.Color := clBtnFace;
    Edit3.Text := EmptyStr;
  end;

  if AnsiContainsText(ComboBox7.Text, 'BLOB') then
  begin
    if not FLoading and not (Screen.ActiveControl = ComboBox10) then
    begin
      ComboBox10.ItemIndex := ComboBox10.Items.IndexOf('BINARY');
      Edit3.Text := '100';
    end;

    Edit2.Enabled := False;      // Length
    Edit2.Color := clBtnFace;
    Edit2.Text := EmptyStr;
    ComboBox8.Enabled := False;  // Precision
    ComboBox8.ItemIndex := -1;
    ComboBox8.Color := clBtnFace;
    ComboBox9.Enabled := False;  // Scale
    ComboBox9.ItemIndex := -1;
    ComboBox9.Color := clBtnFace;
    Edit4.Enabled := False;      // ArrayDim
    Edit4.Color := clBtnFace;
    Edit4.Text := EmptyStr;
    if AnsiContainsText(ComboBox10.Text, 'BINARY') then
    begin
      ComboBox11.Enabled := False;  // Charset
      ComboBox11.ItemIndex := -1;
      ComboBox11.Color := clBtnFace;
    end;
    ComboBox12.Enabled := False;  // Collate
    ComboBox12.ItemIndex := -1;
    ComboBox12.Color := clBtnFace;
  end;

  if DBState = csAlter then
  begin
    Edit4.Enabled := False;      // ArrayDim
    Edit4.Color := clBtnFace;
  end;
end;

procedure TibSHWizardFieldForm.ComboBox2Change(Sender: TObject);
begin
  FieldBasedOn := TibSHFieldBasedOn(ComboBox2.ItemIndex);
end;

procedure TibSHWizardFieldForm.ComboBox3Change(Sender: TObject);
begin
  GetDomainSource;
end;

procedure TibSHWizardFieldForm.Edit2KeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'.. '9']) then Key := #0;
end;

procedure TibSHWizardFieldForm.ComboBox7Change(Sender: TObject);
begin
  GetControls;
end;

procedure TibSHWizardFieldForm.ComboBox11Change(Sender: TObject);
begin
  GetCollates;
end;

end.
