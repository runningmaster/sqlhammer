unit ibSHWizardIndexFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDDLWizardCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, StdCtrls, ExtCtrls, ComCtrls, Buttons,
  CheckLst;

type
  TibSHWizardIndexForm = class(TibSHDDLWizardCustomForm)
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
    GroupBox1: TGroupBox;
    Label4: TLabel;
    ComboBox3: TComboBox;
    Label5: TLabel;
    ComboBox4: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label6: TLabel;
    Label7: TLabel;
    CheckListBox1: TCheckListBox;
    ListBox1: TListBox;
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure CheckListBox1DblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
    procedure GetDataType;
    procedure GetFields;
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
  ibSHWizardIndexForm: TibSHWizardIndexForm;

implementation

{$R *.dfm}

uses
  ibSHConsts, ibSHValues;

{ TibSHWizardIndexForm }

constructor TibSHWizardIndexForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  I: Integer;
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  InitPageCtrl(PageControl1);
  InitDescrEditor(pSHSynEdit1);
  SetFormSize(380, 525);

  for I := 0 to Pred(ComponentCount) do
  begin
    if (Components[I] is TComboBox) then (Components[I] as TComboBox).Text := EmptyStr;
    if (Components[I] is TEdit) then (Components[I] as TEdit).Text := EmptyStr;
  end;
  CheckListBox1.Items.Clear;
  ListBox1.Items.Clear;

  GetDataType;

  Edit1.Text := DBObject.Caption;
  ComboBox1.ItemIndex := ComboBox1.Items.IndexOf((DBObject as IibSHIndex).TableName);
  ComboBox2.ItemIndex := ComboBox2.Items.IndexOf('ACTIVE');
  ComboBox3.ItemIndex := ComboBox3.Items.IndexOf(' ');
  ComboBox4.ItemIndex := ComboBox4.Items.IndexOf('ASCENDING');
  if DBState <> csCreate then
  begin
    ComboBox2.ItemIndex := ComboBox2.Items.IndexOf((DBObject as IibSHIndex).Status);
    ComboBox3.ItemIndex := ComboBox3.Items.IndexOf((DBObject as IibSHIndex).IndexType);
    ComboBox4.ItemIndex := ComboBox4.Items.IndexOf((DBObject as IibSHIndex).Sorting);
  end;

  if ComboBox1.ItemIndex <> -1 then GetFields;

  Edit1.Enabled := not (DBState = csAlter);
  ComboBox1.Enabled := not (DBState = csAlter);
  ComboBox2.Enabled := DBState = csAlter;
  ComboBox3.Enabled := not (DBState = csAlter);
  ComboBox4.Enabled := not (DBState = csAlter);
  CheckListBox1.Enabled := not (DBState = csAlter);
  ListBox1.Enabled := not (DBState = csAlter);
end;

destructor TibSHWizardIndexForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHWizardIndexForm.SetTMPDefinitions;
var
  I: Integer;
begin
  TMPObject.Caption := NormalizeCaption(Trim(Edit1.Text));
  (TMPObject as IibSHIndex).TableName := NormalizeCaption(Trim(ComboBox1.Text));
  (TMPObject as IibSHIndex).Status := Trim(ComboBox2.Text);
  if ComboBox3.ItemIndex <> 0 then
    (TMPObject as IibSHIndex).IndexType := Trim(ComboBox3.Text);
  (TMPObject as IibSHIndex).Sorting := Trim(ComboBox4.Text);
  for I := 0 to Pred(ListBox1.Items.Count) do
    (TMPObject as IibSHIndex).Fields.Add(NormalizeCaption(Trim(ListBox1.Items[I])));
end;

procedure TibSHWizardIndexForm.GetDataType;
var
  S: string;
  I: Integer;
begin
  S := DBObject.BTCLDatabase.BTCLServer.Version;
  for I := 0 to Pred(DBObject.BTCLDatabase.GetObjectNameList(IibSHTable).Count) do
    ComboBox1.Items.Add(DBObject.BTCLDatabase.GetObjectNameList(IibSHTable)[I]);
  ComboBox2.Items.Text := GetStatus;
  ComboBox3.Items.Text := GetIndexType;
  ComboBox4.Items.Text := GetSorting;
end;

procedure TibSHWizardIndexForm.GetFields;
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
    if ComboBox1.Text = (DBObject as IibSHIndex).TableName then
      for I := 0 to Pred((DBObject as IibSHIndex).Fields.Count) do
        ListBox1.Items.Add((DBObject as IibSHIndex).Fields[I]);
    for I := 0 to Pred(ListBox1.Items.Count) do
      if CheckListBox1.Items.IndexOf(ListBox1.Items[I]) <> -1 then
        CheckListBox1.Checked[CheckListBox1.Items.IndexOf(ListBox1.Items[I])] := True;
  end;
end;

procedure TibSHWizardIndexForm.CheckListBox1ClickCheck(Sender: TObject);
begin
  if CheckListBox1.Checked[CheckListBox1.ItemIndex] then
    ListBox1.Items.Add(CheckListBox1.Items[CheckListBox1.ItemIndex])
  else
    ListBox1.Items.Delete(ListBox1.Items.IndexOf(CheckListBox1.Items[CheckListBox1.ItemIndex]));
end;

procedure TibSHWizardIndexForm.CheckListBox1DblClick(Sender: TObject);
begin
  CheckListBox1.Checked[CheckListBox1.ItemIndex] := not CheckListBox1.Checked[CheckListBox1.ItemIndex];
  CheckListBox1ClickCheck(CheckListBox1);
end;

procedure TibSHWizardIndexForm.BitBtn1Click(Sender: TObject);
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

procedure TibSHWizardIndexForm.BitBtn2Click(Sender: TObject);
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

procedure TibSHWizardIndexForm.ComboBox1Change(Sender: TObject);
begin
  GetFields;
end;

end.
