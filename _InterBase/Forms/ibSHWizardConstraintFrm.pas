unit ibSHWizardConstraintFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDDLWizardCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, StdCtrls, ExtCtrls, ComCtrls, CheckLst,
  Buttons, StrUtils;

type
  TibSHWizardConstraintForm = class(TibSHDDLWizardCustomForm)
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
    GroupBox1: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckListBox1: TCheckListBox;
    ListBox1: TListBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Label4: TLabel;
    ComboBox3: TComboBox;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label8: TLabel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    CheckListBox2: TCheckListBox;
    ListBox2: TListBox;
    ComboBox4: TComboBox;
    Label9: TLabel;
    ComboBox5: TComboBox;
    Label10: TLabel;
    CheckPanel: TPanel;
    pSHSynEdit2: TpSHSynEdit;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    ComboBox6: TComboBox;
    Edit2: TEdit;
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure CheckListBox1DblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure CheckListBox2ClickCheck(Sender: TObject);
    procedure CheckListBox2DblClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private declarations }
    procedure GetDataType;
    procedure ChangeConstraintType;
    procedure GetFields;
    procedure GetReferenceFields;
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
  ibSHWizardConstraintForm: TibSHWizardConstraintForm;

implementation

{$R *.dfm}

uses
  ibSHConsts, ibSHValues;

{ TibSHWizardConstraintForm }

constructor TibSHWizardConstraintForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  I: Integer;
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  InitPageCtrl(PageControl1);
  InitDescrEditor(pSHSynEdit1);
  SetFormSize(540, 525);

  Editor := pSHSynEdit2;
  Editor.Lines.Clear;
  RegisterEditors;

  PageCtrl.Pages[1].TabVisible := False;

  CheckPanel.Left := 4;
  CheckPanel.Top := 92;
  CheckPanel.Height := 390;
  CheckPanel.Width := 500;

  for I := 0 to Pred(ComponentCount) do
  begin
    if (Components[I] is TComboBox) then (Components[I] as TComboBox).Text := EmptyStr;
    if (Components[I] is TEdit) then (Components[I] as TEdit).Text := EmptyStr;
  end;
  CheckListBox1.Items.Clear;
  ListBox1.Items.Clear;
  CheckListBox2.Items.Clear;
  ListBox2.Items.Clear;
  
  GetDataType;

  
  Edit1.Text := DBObject.Caption;
  ComboBox1.ItemIndex := ComboBox1.Items.IndexOf((DBObject as IibSHConstraint).TableName);
  ComboBox6.ItemIndex := ComboBox6.Items.IndexOf('ASCENDING');
  if DBState <> csCreate then
  begin
    ComboBox2.ItemIndex := ComboBox2.Items.IndexOf((DBObject as IibSHConstraint).ConstraintType);
    ComboBox3.ItemIndex := ComboBox3.Items.IndexOf((DBObject as IibSHConstraint).ReferenceTable);
    ComboBox4.ItemIndex := ComboBox4.Items.IndexOf((DBObject as IibSHConstraint).OnUpdateRule);
    ComboBox5.ItemIndex := ComboBox5.Items.IndexOf((DBObject as IibSHConstraint).OnDeleteRule);
//    ComboBox4.ItemIndex := ComboBox4.Items.IndexOf((DBObject as IibSHIndex).Sorting);
    Editor.Lines.Assign((DBObject as IibSHConstraint).CheckSource);
    Edit2.Text := (DBObject as IibSHConstraint).IndexName;
    ComboBox6.ItemIndex := ComboBox6.Items.IndexOf((DBObject as IibSHConstraint).IndexSorting);
  end;
  ChangeConstraintType;


  ComboBox1Change(ComboBox1);
  ComboBox3Change(ComboBox3);

  Edit1.Enabled := not (DBState = csAlter);
end;

destructor TibSHWizardConstraintForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHWizardConstraintForm.SetTMPDefinitions;
var
  I: Integer;
begin
  TMPObject.Caption := NormalizeCaption(Trim(Edit1.Text));
  (TMPObject as IibSHConstraint).TableName := NormalizeCaption(Trim(ComboBox1.Text));
  (TMPObject as IibSHConstraint).ConstraintType := Trim(ComboBox2.Text);

//  if ComboBox3.ItemIndex <> 0 then
//    (TMPObject as IibSHIndex).IndexType := Trim(ComboBox3.Text);
//  (TMPObject as IibSHIndex).Sorting := Trim(ComboBox4.Text);
  for I := 0 to Pred(ListBox1.Items.Count) do
    (TMPObject as IibSHConstraint).Fields.Add(NormalizeCaption(Trim(ListBox1.Items[I])));

  (TMPObject as IibSHConstraint).ReferenceTable := NormalizeCaption(Trim(ComboBox3.Text));
  (TMPObject as IibSHConstraint).OnUpdateRule := Trim(ComboBox4.Text);
  (TMPObject as IibSHConstraint).OnDeleteRule := Trim(ComboBox5.Text);

  for I := 0 to Pred(ListBox2.Items.Count) do
    (TMPObject as IibSHConstraint).ReferenceFields.Add(NormalizeCaption(Trim(ListBox2.Items[I])));

  (TMPObject as IibSHConstraint).CheckSource.Assign(Editor.Lines);
  (TMPObject as IibSHConstraint).IndexName := Trim(Edit2.Text);
  (TMPObject as IibSHConstraint).IndexSorting := Trim(ComboBox6.Text);
end;

procedure TibSHWizardConstraintForm.GetDataType;
var
  I: Integer;
begin
  for I := 0 to Pred(DBObject.BTCLDatabase.GetObjectNameList(IibSHTable).Count) do
  begin
    ComboBox1.Items.Add(DBObject.BTCLDatabase.GetObjectNameList(IibSHTable)[I]);
    ComboBox3.Items.Add(DBObject.BTCLDatabase.GetObjectNameList(IibSHTable)[I]);
  end;
  ComboBox2.Items.Text := GetConstraintType;
  ComboBox4.Items.Text := GetConstraintRule;
  ComboBox5.Items.Text := GetConstraintRule;
  ComboBox6.Items.Text := GetSorting;
end;

procedure TibSHWizardConstraintForm.ChangeConstraintType;
var
  I: Integer;
  S: string;
begin
  S := DBObject.BTCLDatabase.BTCLServer.Version;

  for I := 0 to Pred(ComponentCount) do
  begin
    if (Components[I] is TCheckListBox) then (Components[I] as TCheckListBox).Enabled := True;
    if (Components[I] is TCheckListBox) then (Components[I] as TCheckListBox).Color := clWindow;
    if (Components[I] is TListBox) then (Components[I] as TListBox).Enabled := True;
    if (Components[I] is TListBox) then (Components[I] as TListBox).Color := clWindow;
    if (Components[I] is TComboBox) then (Components[I] as TComboBox).Enabled := True;
    if (Components[I] is TComboBox) then (Components[I] as TComboBox).Color := clWindow;
    if (Components[I] is TComboBox) then (Components[I] as TComboBox).Enabled := True;
    if (Components[I] is TComboBox) then (Components[I] as TComboBox).Color := clWindow;
    if (Components[I] is TEdit) then (Components[I] as TEdit).Enabled := True;
    if (Components[I] is TEdit) then (Components[I] as TEdit).Color := clWindow;
  end;

  GroupBox1.Visible := True;
  GroupBox2.Visible := True;
  GroupBox3.Visible :=
   AnsiContainsText(S, SFirebird15) or AnsiContainsText(S, SFirebird20) or AnsiContainsText(S, SFirebird21) ;
  ComboBox3.Visible := True;
  ComboBox4.Visible := True;
  ComboBox5.Visible := True;

  CheckPanel.Visible := False;

  case ComboBox2.ItemIndex of
   -1: begin
         CheckListBox1.Enabled := False;
         CheckListBox1.Color := clBtnFace;
         CheckListBox1.Clear;
         ListBox1.Enabled := False;
         ListBox1.Color := clBtnFace;
         ListBox1.Clear;
         ComboBox3.Enabled := False;
         ComboBox3.Color := clBtnFace;
         ComboBox3.ItemIndex := -1;
         ComboBox4.Enabled := False;
         ComboBox4.Color := clBtnFace;
         ComboBox4.ItemIndex := -1;
         ComboBox5.Enabled := False;
         ComboBox5.Color := clBtnFace;
         ComboBox5.ItemIndex := -1;
         CheckListBox2.Enabled := False;
         CheckListBox2.Color := clBtnFace;
         CheckListBox2.Clear;
         ListBox2.Enabled := False;
         ListBox2.Color := clBtnFace;
         ListBox2.Clear;
         Edit2.Enabled := False;
         Edit2.Color := clBtnFace;
         Edit2.Text := EmptyStr;
         ComboBox6.Enabled := False;
         ComboBox6.Color := clBtnFace;
//         ComboBox6.ItemIndex := -1;
       end;
    0,
    1: begin
         CheckListBox1.Enabled := True;
         CheckListBox1.Color := clWindow;
         CheckListBox1.Clear;
         ListBox1.Enabled := True;
         ListBox1.Color := clWindow;
         ListBox1.Clear;
         ComboBox3.Enabled := False;
         ComboBox3.Color := clBtnFace;
         ComboBox3.ItemIndex := -1;
         ComboBox4.Enabled := False;
         ComboBox4.Color := clBtnFace;
         ComboBox4.ItemIndex := -1;
         ComboBox5.Enabled := False;
         ComboBox5.Color := clBtnFace;
         ComboBox5.ItemIndex := -1;
         CheckListBox2.Enabled := False;
         CheckListBox2.Color := clBtnFace;
         CheckListBox2.Clear;
         ListBox2.Enabled := False;
         ListBox2.Color := clBtnFace;
         ListBox2.Clear;
       end;
    2: begin
{
         CheckListBox1.Enabled := True;
         CheckListBox1.Color := clWindow;
         CheckListBox1.Clear;
         ListBox1.Enabled := True;
         ListBox1.Color := clWindow;
         ListBox1.Clear;
         ComboBox3.Enabled := False;
         ComboBox3.Color := clBtnFace;
         ComboBox3.ItemIndex := -1;
         ComboBox4.Enabled := False;
         ComboBox4.Color := clBtnFace;
         ComboBox4.ItemIndex := -1;
         ComboBox5.Enabled := False;
         ComboBox5.Color := clBtnFace;
         ComboBox5.ItemIndex := -1;
         CheckListBox2.Enabled := False;
         CheckListBox2.Color := clBtnFace;
         CheckListBox2.Clear;
         ListBox2.Enabled := False;
         ListBox2.Color := clBtnFace;
         ListBox2.Clear;
         ComboBox6.Enabled := False;
         ComboBox6.Color := clBtnFace;
         ComboBox6.ItemIndex := -1;
         ComboBox7.Enabled := False;
         ComboBox7.Color := clBtnFace;
         ComboBox7.ItemIndex := -1;
         Editor.Lines.Clear;
}
       end;
    3: begin
         GroupBox1.Visible := False;
         GroupBox2.Visible := False;
         GroupBox3.Visible := False;
         ComboBox3.Visible := False;
         ComboBox4.Visible := False;
         ComboBox5.Visible := False;
         CheckPanel.Visible := True;
       end;
  end;
end;

procedure TibSHWizardConstraintForm.GetFields;
var
  I: Integer;
  Table: TSHComponent;
  TableClass: TSHComponentClass;
  TableName: string;
  DBTable: IibSHTable;
begin
  CheckListBox1.Items.Clear;
  ListBox1.Items.Clear;
  
  TableName := ComboBox1.Text;
  TableClass := nil;
  Table := Designer.FindComponent(DBObject.OwnerIID, IibSHTable, TableName);
  Supports(Table, IibSHTable, DBTable);
  if not Assigned(Table) then
  begin
    TableClass := Designer.GetComponent(IibSHTable);
    if Assigned(TableClass) then
    begin
      Table := TableClass.Create(nil);
      Supports(Table, IibSHTable, DBTable);
      DBTable.Caption := TableName;
      DBTable.OwnerIID := DBObject.OwnerIID;
      DBTable.State := csSource;
      try
        Screen.Cursor := crHourGlass;
        DDLGenerator.GetDDLText(DBTable);
      finally
        Screen.Cursor := crDefault;
      end;
    end;
  end;

  if Assigned(Table) then
  begin
    for I := 0 to Pred(DBTable.Fields.Count) do
      CheckListBox1.Items.Add(DBTable.Fields[I]);
  end;



  DBTable := nil;
  if Assigned(TableClass) then FreeAndNil(Table);

  if DBState <> csCreate then
  begin
    if ComboBox1.Text = (DBObject as IibSHConstraint).TableName then
      for I := 0 to Pred((DBObject as IibSHConstraint).Fields.Count) do
        ListBox1.Items.Add((DBObject as IibSHConstraint).Fields[I]);
    for I := 0 to Pred(ListBox1.Items.Count) do
      if CheckListBox1.Items.IndexOf(ListBox1.Items[I]) <> -1 then
        CheckListBox1.Checked[CheckListBox1.Items.IndexOf(ListBox1.Items[I])] := True;
  end;
end;

procedure TibSHWizardConstraintForm.GetReferenceFields;
var
  I: Integer;
  Table: TSHComponent;
  TableClass: TSHComponentClass;
  TableName: string;
  DBTable: IibSHTable;
begin
  CheckListBox2.Items.Clear;
  ListBox2.Items.Clear;

  TableName := ComboBox3.Text;
  TableClass := nil;
  Table := Designer.FindComponent(DBObject.OwnerIID, IibSHTable, TableName);
  Supports(Table, IibSHTable, DBTable);
  if not Assigned(Table) then
  begin
    TableClass := Designer.GetComponent(IibSHTable);
    if Assigned(TableClass) then
    begin
      Table := TableClass.Create(nil);
      Supports(Table, IibSHTable, DBTable);
      DBTable.Caption := TableName;
      DBTable.OwnerIID := DBObject.OwnerIID;
      DBTable.State := csSource;
      try
        Screen.Cursor := crHourGlass;
        DDLGenerator.GetDDLText(DBTable);
      finally
        Screen.Cursor := crDefault;
      end;
    end;
  end;

  if Assigned(Table) then
  begin
    for I := 0 to Pred(DBTable.Fields.Count) do
      CheckListBox2.Items.Add(DBTable.Fields[I]);
  end;

  DBTable := nil;
  if Assigned(TableClass) then FreeAndNil(Table);

  if DBState <> csCreate then
  begin
    if ComboBox3.Text = (DBObject as IibSHConstraint).ReferenceTable then
      for I := 0 to Pred((DBObject as IibSHConstraint).ReferenceFields.Count) do
        ListBox2.Items.Add((DBObject as IibSHConstraint).ReferenceFields[I]);
    for I := 0 to Pred(ListBox2.Items.Count) do
      if CheckListBox2.Items.IndexOf(ListBox2.Items[I]) <> -1 then
        CheckListBox2.Checked[CheckListBox2.Items.IndexOf(ListBox2.Items[I])] := True;
  end;

  if DBState = csCreate then
  begin
    ComboBox4.ItemIndex := 0;
    ComboBox5.ItemIndex := 0;
  end;
end;

procedure TibSHWizardConstraintForm.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex <> - 1 then
    case ComboBox2.ItemIndex of
      0, 1, 2: GetFields;
    end
end;

procedure TibSHWizardConstraintForm.ComboBox2Change(Sender: TObject);
begin
  ChangeConstraintType;
  ComboBox1Change(ComboBox1);
end;

procedure TibSHWizardConstraintForm.ComboBox3Change(Sender: TObject);
begin
  if ComboBox2.ItemIndex = 2 then GetReferenceFields;
end;

procedure TibSHWizardConstraintForm.CheckListBox1ClickCheck(
  Sender: TObject);
begin
  if CheckListBox1.Checked[CheckListBox1.ItemIndex] then
    ListBox1.Items.Add(CheckListBox1.Items[CheckListBox1.ItemIndex])
  else
    ListBox1.Items.Delete(ListBox1.Items.IndexOf(CheckListBox1.Items[CheckListBox1.ItemIndex]));
end;

procedure TibSHWizardConstraintForm.CheckListBox1DblClick(Sender: TObject);
begin
  CheckListBox1.Checked[CheckListBox1.ItemIndex] := not CheckListBox1.Checked[CheckListBox1.ItemIndex];
  CheckListBox1ClickCheck(CheckListBox1);
end;

procedure TibSHWizardConstraintForm.BitBtn1Click(Sender: TObject);
var
  I: Integer;
begin
  I := ListBox1.ItemIndex;
  if (DBState <> csAlter) and (I <> -1) and (I <> 0) then
  begin
    ListBox1.Items.Move(I, I - 1);
    ListBox1.ItemIndex := I - 1;
    if ListBox1.CanFocus then ListBox1.SetFocus;
  end;
end;

procedure TibSHWizardConstraintForm.BitBtn2Click(Sender: TObject);
var
  I: Integer;
begin
  I := ListBox1.ItemIndex;
  if (DBState <> csAlter) and (I <> -1) and (I <> Pred(ListBox1.Items.Count)) then
  begin
    ListBox1.Items.Move(I, I + 1);
    ListBox1.ItemIndex := I + 1;
    if ListBox1.CanFocus then ListBox1.SetFocus;
  end;
end;

procedure TibSHWizardConstraintForm.CheckListBox2ClickCheck(
  Sender: TObject);
begin
  if CheckListBox2.Checked[CheckListBox2.ItemIndex] then
    ListBox2.Items.Add(CheckListBox2.Items[CheckListBox2.ItemIndex])
  else
    ListBox2.Items.Delete(ListBox2.Items.IndexOf(CheckListBox2.Items[CheckListBox2.ItemIndex]));
end;

procedure TibSHWizardConstraintForm.CheckListBox2DblClick(Sender: TObject);
begin
  CheckListBox2.Checked[CheckListBox2.ItemIndex] := not CheckListBox2.Checked[CheckListBox2.ItemIndex];
  CheckListBox2ClickCheck(CheckListBox2);
end;

procedure TibSHWizardConstraintForm.BitBtn3Click(Sender: TObject);
var
  I: Integer;
begin
  I := ListBox2.ItemIndex;
  if (DBState <> csAlter) and (I <> -1) and (I <> 0) then
  begin
    ListBox2.Items.Move(I, I - 1);
    ListBox2.ItemIndex := I - 1;
    if ListBox2.CanFocus then ListBox2.SetFocus;
  end;
end;

procedure TibSHWizardConstraintForm.BitBtn4Click(Sender: TObject);
var
  I: Integer;
begin
  I := ListBox2.ItemIndex;
  if (DBState <> csAlter) and (I <> -1) and (I <> Pred(ListBox2.Items.Count)) then
  begin
    ListBox2.Items.Move(I, I + 1);
    ListBox2.ItemIndex := I + 1;
    if ListBox2.CanFocus then ListBox2.SetFocus;
  end;
end;

end.
