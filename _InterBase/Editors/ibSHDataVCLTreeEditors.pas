unit ibSHDataVCLTreeEditors;

interface

uses
  Windows, Classes, Controls, Types, Messages, StdCtrls, DB, SysUtils,
  Graphics, Buttons, ExtCtrls, DBCtrls, StrUtils, DBGridEh,
  VirtualTrees, Forms,

  SHDesignIntf, SHOptionsIntf, ibSHDesignIntf, ibSHDriverIntf,TntStdCtrls;

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    FieldNo: Integer;
    Nullable: Boolean;
    Computed: Boolean;
    DefaultExpression: string;
    CheckConstraint: string;
    DataSource: TDataSource;
    Field: TField;
    DataType: string;
    FieldDescription: string;
    ImageIndex: Integer;
    NodeHeight: Integer;
    IsPicture: Boolean;
    IsMultiLine: Boolean;
    Component: TSHComponent;
    FKFields: string;
    ReferenceTable: string;
    ReferenceFields: string;
  end;

  ISHTreeEditor = interface
  ['{088E9377-7BAD-438F-A145-85E8323C6829}']
    function GetEditor: TWinControl; stdcall;
  end;

  TDataVCLFieldEditLink = class(TInterfacedObject, IVTEditLink, ISHTreeEditor)
  private
    FEdit: TWinControl;        // One of the property editor classes.
//    FEditButton: TEditButtonControlEh;
    FTree: TVirtualStringTree; // A back reference to the tree calling.
    FNode: PVirtualNode;       // The node being edited.
    FColumn: Integer;          // The column of the node being edited.

  protected
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoOnSetNULL(Sender: TObject);
  public
    destructor Destroy; override;

    { IVTEditLink }
    function BeginEdit: Boolean; stdcall;
    function CancelEdit: Boolean; stdcall;
    function EndEdit: Boolean; stdcall;
    function GetBounds: TRect; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); stdcall;

    { ISHTreeEditor }
    function GetEditor: TWinControl; stdcall;

  end;

  TibSHEditForeignKeyPicker = class;

  TibSHEditForeignKeyPickerForm = class(TCustomForm)
  private
    FTopPanel: TPanel;
    FBottomPanel: TPanel;
    FBtnOk: TButton;
    FBtnCancel: TButton;
    FDBGrid: TDBGridEh;
    function GetEditForeignKeyPicker: TibSHEditForeignKeyPicker;
    procedure WMActivate (var Message: TWMActivate); message WM_ACTIVATE;
  protected
    procedure Resize; override;
    procedure CreateParams(var Params: TCreateParams); override;

    procedure DoOnFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property EditForeignKeyPicker: TibSHEditForeignKeyPicker
      read GetEditForeignKeyPicker;
  end;

  TibSHEditForeignKeyPicker = class(TCustomPanel)
  private
    FEditButton: TSpeedButton;
    FInputEdit: TEdit;
    FReferenceTable: string;
    FFields: TStrings;
    FReferenceFields: TStrings;
    FDataIntf: IibSHData;
    FForm: TibSHEditForeignKeyPickerForm;
    FDataSource: TDataSource;
    FDRVDataset: TSHComponent;
    FFieldName: string;
    FSHCLDatabase: IibSHDatabase;
    procedure SetFields(const Value: TStrings);
    procedure SetReferenceFields(const Value: TStrings);
    procedure SetReferenceTable(const Value: string);
    procedure SetDataIntf(const Value: IibSHData);
    procedure SetFormPos;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure CreateDRV;
    procedure FreeDRV;
    function GetDRVDataset: IibSHDRVDataset;

  protected
    procedure Resize; override;
    procedure VisibleChanging; override;
    procedure ApplyGridFormatOptions(ADBGrid: TDBGridEh);
    procedure DropDownGridPanel(Sender: TObject);
    procedure DoOnOk(Sender: TObject);
    procedure DoOnCancel(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property DataIntf: IibSHData read FDataIntf write SetDataIntf;
    property DRVDataset: IibSHDRVDataset read GetDRVDataset;
    property FieldName: string read FFieldName write FFieldName;
    property Fields: TStrings read FFields write SetFields;
    property InputEdit: TEdit read FInputEdit;
    property ReferenceFields: TStrings read FReferenceFields write SetReferenceFields;
    property ReferenceTable: string read FReferenceTable
      write SetReferenceTable;
    property SHCLDatabase: IibSHDatabase read FSHCLDatabase write FSHCLDatabase;
  end;


implementation

uses ComCtrls;

{ TDataVCLFieldEditLink }

destructor TDataVCLFieldEditLink.Destroy;
begin

  inherited;
end;

procedure TDataVCLFieldEditLink.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN,
    VK_DOWN,
    VK_UP:
      begin
        if (Shift = []) and (not (FEdit is TMemo)) then
        begin
          // Forward the keypress to the tree. It will asynchronously change the focused node.
          PostMessage(FTree.Handle, WM_KEYDOWN, Key, 0);
          Key := 0;
        end;
      end;
  end;
end;

procedure TDataVCLFieldEditLink.DoOnSetNULL(Sender: TObject);
var
  Data: PTreeRec;
  vTree: TVirtualStringTree;
  vNode: PVirtualNode;
begin
  if Assigned(FTree) and Assigned(FNode) then
  begin
    vTree := FTree;
    vNode := FNode;
    Data := FTree.GetNodeData(FNode);
    Data.DataSource.DataSet.Edit;
    Data.Field.Clear;
    vTree.InvalidateNode(vNode);
  end;
end;

function TDataVCLFieldEditLink.BeginEdit: Boolean;
begin
  Result := True;
  FEdit.Show;
  FEdit.SetFocus;
end;

function TDataVCLFieldEditLink.CancelEdit: Boolean;
begin
  Result := True;
  FEdit.Hide;
//  if FColumn = 1 then
//    FTree.InvalidateNode(FNode);
end;

function TDataVCLFieldEditLink.EndEdit: Boolean;
var
  Data: PTreeRec;
//  Buffer: array[0..1024] of Char;
//  S: WideString;
  ResultDate: TDateTime;
  ResultText: WideString;
  IsTextResult: Boolean;
  IsResult: Boolean;
  vPriorValue: Variant;
  vDataCustomForm: IibSHDataCustomForm;
  function FormatErrorMessage(const E: string): string;
  const
    SignalStr = ':' + sLineBreak;
  var
    I: Integer;
  begin
    I := Pos(SignalStr, E);
    Result := E;
    if I > 0 then
      Delete(Result, 1, I + Length(SignalStr) - 1);
    Result := AnsiReplaceText(Result, SignalStr, '');
    if Pos('can''t format message', Result) > 0 then
    begin
      I := Pos('not found', Result);
      Result := Copy(Result, I + Length('not found.'), MaxInt);
    end;
  end;
begin
  Result := True;
  IsResult := False;
  IsTextResult := True;
  ResultDate := Now;
  case FColumn of
    {
    1:
      begin
        Data := FTree.GetNodeData(FNode);
        with FEdit as TCheckBox do
        begin
          if Assigned(Data) and Assigned(Data.Field) then
          begin
            if (Checked <> Data.Field.IsNull) and (not Data.Field.ReadOnly) then
            begin
              if Checked then
              begin
                if not (Data.Field.DataSet.State in [dsEdit, dsInsert]) then
                  Data.Field.DataSet.Edit;
                Data.Field.Clear;
              end;
            end;
          end;
        end;
      end;
    }
    5:
      begin
        Data := FTree.GetNodeData(FNode);
        if Assigned(Data) and Assigned(Data.Field) then
        begin
          if FEdit is TDateTimePicker then
          begin
            IsTextResult := False;
            IsResult := True;
            ResultDate := TDateTimePicker(FEdit).DateTime;
          end
          else
//          if FEdit is TEdit then
          if FEdit is TTntEdit then
          begin
            ResultText := TTntEdit(FEdit).Text;
            IsResult := True;
          end
          else
          if FEdit is TMemo then
          begin
            ResultText := TMemo(FEdit).Lines.Text;
            IsResult := True;
          end
          else
          if FEdit is TibSHEditForeignKeyPicker then
          begin
            ResultText := TibSHEditForeignKeyPicker(FEdit).InputEdit.Text;
            IsResult := True;
          end;
        end;
      end;
  end;
  FEdit.Hide;
  FTree.SetFocus;
  if IsResult then
  begin
    if Data.Field.DataSet.Active then
    begin
      if IsTextResult then
      begin
        if Data.Field is TWideStringField then
         IsResult := TWideStringField(Data.Field).Value<>ResultText
        else
         IsResult := Data.Field.AsString <> ResultText
      end
      else
        IsResult := Data.Field.AsDateTime <> ResultDate;
      if IsResult then
      begin
        Data.Field.DataSet.Edit;
        vPriorValue := Data.Field.Value;
        try
          if IsTextResult then
          begin
            if Data.Field is TWideStringField then
             TWideStringField(Data.Field).Value:= ResultText
            else
             Data.Field.AsString := ResultText
          end
          else
            Data.Field.AsDateTime := ResultDate;
        except
          on E: Exception do
          begin
            Data.Field.Value := vPriorValue;
            if Data.Component.GetComponentFormIntf(IibSHDataCustomForm, vDataCustomForm) then
              vDataCustomForm.AddToResultEdit(FormatErrorMessage(E.Message))
            else
              raise;
          end;
        end;
      end;
    end;    
  end;
end;

function TDataVCLFieldEditLink.GetBounds: TRect;
begin
  Result := FEdit.BoundsRect;
end;

function TDataVCLFieldEditLink.PrepareEdit(Tree: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex): Boolean;
var
  Data: PTreeRec;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;

  // determine what edit type actually is needed
  FEdit.Free;
  FEdit := nil;
  Data := FTree.GetNodeData(Node);
  case FColumn of
    5:
      begin
        if Data.Field.IsBlob then
        begin
          if Data.IsPicture then
            Result := False
          else
          begin
            FEdit := TMemo.Create(nil);
            with FEdit as TMemo do
            begin
              TabStop := True;
              WantTabs := True;
              Visible := False;
              Parent := Tree;
              Lines.Text := Data.Field.AsString;
              OnKeyDown := EditKeyDown;
            end;
          end;
        end
        else
        begin
          if Data.Field.DataType in [ftDate, ftDateTime, ftTimeStamp] then
          begin
            FEdit := TDateTimePicker.Create(nil);
            with FEdit as TDateTimePicker do
            begin
              TabStop := True;

              Visible := False;
              Parent := Tree;

              CalColors.MonthBackColor := clWindow;
              CalColors.TextColor := clBlack;
              CalColors.TitleBackColor := clBtnShadow;
              CalColors.TitleTextColor := clBlack;
              CalColors.TrailingTextColor := clBtnFace;

              DateTime := Data.Field.AsDateTime;
              OnKeyDown := EditKeyDown;
            end;
          end
          else
          begin
            if Length(Data.ReferenceTable) > 0 then
            begin
              FEdit := TibSHEditForeignKeyPicker.Create(nil);
              with FEdit as TibSHEditForeignKeyPicker do
              begin
                InputEdit.TabStop := True;
                Parent := Tree;
                Visible := False;
                InputEdit.Text := Data.Field.AsString;
                InputEdit.OnKeyDown := EditKeyDown;

                if Supports(Data.Component, IibSHData) and
                  Supports(Data.Component, IibSHDatabase) then
                begin
                  SHCLDatabase := Data.Component as IibSHDatabase;
                  DataIntf := Data.Component as IibSHData;
                  ReferenceTable := Data.ReferenceTable;
                  Fields.Text := Data.FKFields;
                  ReferenceFields.Text := Data.ReferenceFields;
                  FieldName := Data.Field.FieldName;
                end;
              end;

              //Data.DBTable.GetConstraint().
            end
            else
            begin
{ TODO -oBuzz -cУникода суппорт : Вот тута добавить уникодную срань для редактирования дерева }
               FEdit := TTntEdit.Create(nil);
               with FEdit as TTntEdit do
               begin
                TabStop := True;
                Visible := False;
                Parent := Tree;
                if Data.Field is TWideStringField then
                 Text := TWideStringField(Data.Field).Value
                else
                 Text := Data.Field.AsString;
                OnKeyDown := EditKeyDown;
               end;
{              FEdit := TEdit.Create(nil);
              with FEdit as TEdit do
              begin
                TabStop := True;
                Visible := False;
                Parent := Tree;
                Text := Data.Field.AsString;
                OnKeyDown := EditKeyDown;
              end;}
            end;
          end;
        end;
      end;
    6:
      begin
        FEdit := TButton.Create(nil);
        with FEdit as TButton do
        begin
          TabStop := True;
          Visible := False;
          Parent := Tree;
          Caption := 'SET NULL';
          Height := 21;
          OnKeyDown := EditKeyDown;
          OnClick := DoOnSetNULL;
          {
          if (not Data.Field.ReadOnly) then
          begin
            FEdit.Perform(WM_LBUTTONDOWN, MK_LBUTTON, 1 shl 16 + 1);
            FEdit.Perform(WM_LBUTTONUP, MK_LBUTTON, 1 shl 16 + 1);
          end;
          }
        end;
        {
        FEdit := TCheckBox.Create(nil);
        with FEdit as TCheckBox do
        begin
          TabStop := True;
          Visible := False;
          Parent := Tree;
          Checked := Data.Field.IsNull;
          OnKeyDown := EditKeyDown;
          if (not Data.Field.ReadOnly) then
          begin
            FEdit.Perform(WM_LBUTTONDOWN, MK_LBUTTON, 1 shl 16 + 1);
            FEdit.Perform(WM_LBUTTONUP, MK_LBUTTON, 1 shl 16 + 1);
            if not (Data.DataSource.DataSet.State in [dsEdit, dsInsert]) then
              Data.DataSource.DataSet.Edit;
            if Checked then
              Data.Field.Clear;
          end;
          FTree.InvalidateNode(FNode);
        end;
        }
      end;
    else
      Result := False;
  end;
end;

procedure TDataVCLFieldEditLink.ProcessMessage(var Message: TMessage);
begin
  FEdit.WindowProc(Message);
end;

procedure TDataVCLFieldEditLink.SetBounds(R: TRect);
var
  Dummy: Integer;
//  NewRect: TRect;
begin
  // Since we don't want to activate grid extensions in the tree (this would influence how the selection is drawn)
  // we have to set the edit's width explicitly to the width of the column.
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  case FColumn of
    {
    0, 3:;
    1:
      begin
        NewRect := R;
        NewRect.Bottom := NewRect.Top + 20;
        NewRect.Left := R.Left + ((R.Right - R.Left) div 2) - 6;
        FEdit.BoundsRect := NewRect;
      end;
    }
    5, 6:
      begin
        //FEdit.BoundsRect := R;
//        FEdit.BoundsRect.Top := R.
        R.Bottom := R.Top + (FEdit.BoundsRect.Bottom - FEdit.BoundsRect.Top);
        FEdit.BoundsRect := R;
      end;
  end;
end;

function TDataVCLFieldEditLink.GetEditor: TWinControl;
begin
  Result := FEdit;
end;

{ TibSHEditForeignKeyPickerForm }

constructor TibSHEditForeignKeyPickerForm.Create(AOwner: TComponent);
  function CreatePanel(AOwner: TWinControl): TPanel;
  begin
    Result := TPanel.Create(AOwner);
    with Result do
    begin
      Parent := AOwner;
      BorderStyle := bsNone;
      BevelInner := bvNone;
      BevelOuter := bvNone;
      Caption := EmptyStr;
    end;
  end;
begin
  CreateNew(AOwner);
  Width := 300;
  Height := 250;
  FTopPanel := CreatePanel(Self);
  with FTopPanel do
  begin
    Align := alTop;
    Height := 24;
  end;
  with TDBNavigator.Create(FTopPanel) do
  begin
    Parent := FTopPanel;
    Flat := True;
    Align := alLeft;
    DataSource := EditForeignKeyPicker.FDataSource;
    Top := 1;
    Left := 1;
    VisibleButtons := [nbFirst, nbPrior, nbNext, nbLast];
    Width := Width div 2;
  end;
  FDBGrid := TDBGridEh.Create(Self);
  with FDBGrid do
  begin
    Parent := Self;
    Align := alClient;
    DataSource := EditForeignKeyPicker.FDataSource;
    Flat := True;
    ReadOnly := True;
    OnDblClick := EditForeignKeyPicker.DoOnOk;
  end;
  FBottomPanel := CreatePanel(Self);
  with FBottomPanel do
  begin
    Align := alBottom;
    Height := 26;
  end;
  FBtnOk := TButton.Create(FBottomPanel);
  with FBtnOk do
  begin
    Parent := FBottomPanel;
    Width := 60;
    Height := 22;
    Caption := 'Ok';
    OnClick := EditForeignKeyPicker.DoOnOk;
    Default := True;
    Top := 2;
    Left := FBottomPanel.Width - 124;
    ModalResult := mrOk;
  end;
  FBtnCancel := TButton.Create(FBottomPanel);
  with FBtnCancel do
  begin
    Parent := FBottomPanel;
    Width := 60;
    Height := 22;
    Caption := 'Cancel';
    OnClick := EditForeignKeyPicker.DoOnCancel;
    Top := 2;
    Left := FBottomPanel.Width - 62;
    ModalResult := mrCancel;
  end;
  KeyPreview := True;
  OnKeyDown := DoOnFormKeyDown;
end;

destructor TibSHEditForeignKeyPickerForm.Destroy;
begin
  inherited Destroy;
end;

function TibSHEditForeignKeyPickerForm.GetEditForeignKeyPicker: TibSHEditForeignKeyPicker;
begin
  Result := TibSHEditForeignKeyPicker(Owner);
end;

procedure TibSHEditForeignKeyPickerForm.WMActivate(
  var Message: TWMActivate);
begin
  if csDesigning in ComponentState then begin
    inherited;
    Exit;
  end;
  if Application.MainForm.HandleAllocated then
    SendMessage(Application.MainForm.Handle, WM_NCACTIVATE, Ord(Message.Active <> WA_INACTIVE), 0);
end;

procedure TibSHEditForeignKeyPickerForm.Resize;
begin
  inherited Resize;
  FBtnOk.Top := 2;
  FBtnOk.Left := FBottomPanel.Width - 124;
  FBtnCancel.Top := 2;
  FBtnCancel.Left := FBottomPanel.Width - 62;
end;

procedure TibSHEditForeignKeyPickerForm.CreateParams(
  var Params: TCreateParams);
const
  CS_DROPSHADOW = $20000;
begin
  inherited;
  with Params do
  begin
    Style := WS_POPUP;
    ExStyle := WS_EX_TOOLWINDOW;
    if ((Win32Platform and VER_PLATFORM_WIN32_NT) <> 0)
      and (Win32MajorVersion > 4)
      and (Win32MinorVersion > 0) {Windows XP} then
      Params.WindowClass.style := Params.WindowClass.style or CS_DROPSHADOW;
    Style := Style or WS_THICKFRAME
  end;
end;

procedure TibSHEditForeignKeyPickerForm.DoOnFormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN: FBtnOk.Click;
    VK_ESCAPE: FBtnCancel.Click;
  end;
end;

{ TibSHEditForeignKeyPicker }

constructor TibSHEditForeignKeyPicker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := EmptyStr;
  BorderStyle := bsNone;
  BevelInner := bvNone;
//  BevelOuter := bvNone;
  BevelOuter := bvLowered;
  FEditButton := TSpeedButton.Create(Self);
  FEditButton.Parent := Self;
  FEditButton.Align := alRight;
  FEditButton.Caption := 'FK';
  FEditButton.OnClick := DropDownGridPanel;
  FInputEdit := TEdit.Create(Self);
  FInputEdit.Parent := Self;
  Height := FInputEdit.Height;
  FInputEdit.Width := Width - Height;
  FEditButton.Width := Height;
  FFields := TStringList.Create;
  FReferenceFields := TStringList.Create;

  FDataSource := TDataSource.Create(Self);
  FForm := TibSHEditForeignKeyPickerForm.Create(Self);
  FForm.BorderStyle := bsNone;
  FForm.Visible := False;
end;

destructor TibSHEditForeignKeyPicker.Destroy;
begin
  FreeDRV;
  FFields.Free;
  FReferenceFields.Free;
  inherited Destroy;
end;

procedure TibSHEditForeignKeyPicker.SetFields(const Value: TStrings);
begin
  FFields.Assign(Value);
end;

procedure TibSHEditForeignKeyPicker.SetReferenceFields(
  const Value: TStrings);
begin
  FReferenceFields.Assign(Value);
end;

procedure TibSHEditForeignKeyPicker.SetReferenceTable(const Value: string);
begin
  FReferenceTable := Value;
  if Assigned(DataIntf) then
  begin
    if DRVDataset.Active then
      DRVDataset.Close;
    DRVDataset.SelectSQL.Text := Format('SELECT * FROM %s', [FReferenceTable]);
  end;
end;

procedure TibSHEditForeignKeyPicker.SetDataIntf(const Value: IibSHData);
begin
  FDataIntf := Value;
  if Assigned(FDataIntf) then
  begin
    CreateDRV;
    FDataSource.DataSet := DRVDataset.Dataset;
  end
  else
    FreeDRV;
end;

procedure TibSHEditForeignKeyPicker.SetFormPos;
var
  vLeftTop: TPoint;

begin
  vLeftTop := ClientToScreen(Point(0, Height));
  if vLeftTop.X + FForm.Width > Screen.Width then
    FForm.Left := vLeftTop.X + FInputEdit.Width - FForm.Width
  else
    FForm.Left := vLeftTop.X;
  if vLeftTop.Y + FForm.Height > Screen.Height then
    FForm.Top := vLeftTop.Y - FInputEdit.Height - FForm.Height
  else
    FForm.Top := vLeftTop.Y;
end;

procedure TibSHEditForeignKeyPicker.WMWindowPosChanged(
  var Message: TWMWindowPosChanged);
begin
  inherited;
  SetFormPos;
end;


procedure TibSHEditForeignKeyPicker.CreateDRV;
var
  vDesigner: ISHDesigner;
  vComponentClass: TSHComponentClass;
begin
  if SHSupports(ISHDesigner, vDesigner) and Assigned(SHCLDatabase) then
  begin
    vComponentClass := vDesigner.GetComponent(SHCLDatabase.BTCLServer.DRVNormalize(IibSHDRVDataset));
    if Assigned(vComponentClass) then
    begin
      FDRVDataset := vComponentClass.Create(Self);
      DRVDataset.Database := DataIntf.Transaction.Database;
      DRVDataset.ReadTransaction := DataIntf.Transaction;
    end;
  end;
end;

procedure TibSHEditForeignKeyPicker.FreeDRV;
begin

end;

function TibSHEditForeignKeyPicker.GetDRVDataset: IibSHDRVDataset;
begin
  Supports(FDRVDataset, IibSHDRVDataset, Result);
end;


procedure TibSHEditForeignKeyPicker.Resize;
begin
  inherited Resize;
  FInputEdit.Left := 0;
  FInputEdit.Top := 0;
  FInputEdit.Width := Width - Height;
  FInputEdit.Height := Height;
  FEditButton.Width := Height;
end;

procedure TibSHEditForeignKeyPicker.VisibleChanging;
begin
  if Visible then
    FForm.Hide;
  inherited VisibleChanging;
end;

procedure TibSHEditForeignKeyPicker.ApplyGridFormatOptions(
  ADBGrid: TDBGridEh);
var
  I: Integer;
  vGridFormatOptions: ISHDBGridFormatOptions;
  vDesigner: ISHDesigner;
  procedure DoFitDisplayWidths;
  var
    J, dw, tw, MAX_COLUMN_WIDTH: Integer;
    TM: TTextMetric;
  begin
    if Assigned(vGridFormatOptions) then
      MAX_COLUMN_WIDTH := vGridFormatOptions.DisplayFormats.StringFieldWidth
    else
      MAX_COLUMN_WIDTH := 100;
    GetTextMetrics(ADBGrid.Canvas.Handle, TM);
    for J := 0 to Pred(ADBGrid.Columns.Count) do
    begin

      dw := ADBGrid.Columns[J].Field.DisplayWidth * (ADBGrid.Canvas.TextWidth('0') - TM.tmOverhang) + TM.tmOverhang + 4;
      if dw > MAX_COLUMN_WIDTH then
        dw := MAX_COLUMN_WIDTH;
      tw := ADBGrid.Canvas.TextWidth(ADBGrid.Columns[J].Title.Caption + 'W');
      if dw < tw then
        dw := tw;
      ADBGrid.Columns[J].Width := dw;

    end;
  end;
begin
  if SHSupports(ISHDesigner, vDesigner) and
    Supports(vDesigner.GetDemon(ISHDBGridFormatOptions), ISHDBGridFormatOptions, vGridFormatOptions) and
    Assigned(ADBGrid) and
    Assigned(ADBGrid.DataSource) and
    Assigned(ADBGrid.DataSource.DataSet) and
    (ADBGrid.DataSource.DataSet.FieldCount > 0) then
  begin
      for I := 0 to Pred(ADBGrid.Columns.Count) do
      begin
        if Assigned(SHCLDatabase) and
          SHCLDatabase.DatabaseAliasOptions.DML.UseDB_KEY and
          (not SHCLDatabase.DatabaseAliasOptions.DML.ShowDB_KEY) and
          (ADBGrid.Columns[I].FieldName = 'DB_KEY') then
          ADBGrid.Columns[I].Visible := False;

        ADBGrid.Columns[I].ToolTips := True;
        if ADBGrid.Columns[I].Field is TIntegerField then
        begin
          TIntegerField(ADBGrid.Columns[I].Field).DisplayFormat := vGridFormatOptions.DisplayFormats.IntegerField;
          TIntegerField(ADBGrid.Columns[I].Field).EditFormat := vGridFormatOptions.EditFormats.IntegerField;
        end;
        if ADBGrid.Columns[I].Field is TFloatField then
        begin
          TFloatField(ADBGrid.Columns[I].Field).DisplayFormat := vGridFormatOptions.DisplayFormats.FloatField;
          TFloatField(ADBGrid.Columns[I].Field).EditFormat := vGridFormatOptions.EditFormats.FloatField;
        end;
// Шо  за дубляж кода???        
        if ADBGrid.Columns[I].Field is TDateTimeField then
          TDateTimeField(ADBGrid.Columns[I].Field).DisplayFormat := vGridFormatOptions.DisplayFormats.DateTimeField;
        if ADBGrid.Columns[I].Field is TDateField then
          TDateField(ADBGrid.Columns[I].Field).DisplayFormat := vGridFormatOptions.DisplayFormats.DateField;
        if ADBGrid.Columns[I].Field is TTimeField then
          TTimeField(ADBGrid.Columns[I].Field).DisplayFormat := vGridFormatOptions.DisplayFormats.TimeField;
      end;
  end;
end;

procedure TibSHEditForeignKeyPicker.DropDownGridPanel(Sender: TObject);
var
  I: Integer;
  S: string;
  vIndex: Integer;
  vDesigner: ISHDesigner;
  vFormater: IibSHDataCustomForm;
begin
  try
    if Assigned(DRVDataset) then
    begin
      DRVDataset.Open;
      vIndex := Fields.IndexOf(FieldName);
      if vIndex > -1 then
      begin
        S := ReferenceFields[vIndex];
        for I := 0 to Pred(FForm.FDBGrid.Columns.Count) do
          if FForm.FDBGrid.Columns[I].FieldName = S then
          begin
            FForm.FDBGrid.Columns[I].Title.Font.Style :=
              FForm.FDBGrid.Columns[I].Title.Font.Style + [fsBold];
            Break;
          end;
      end;
      SetFormPos;
      if SHSupports(ISHDesigner, vDesigner) and
        Supports(vDesigner.CurrentComponentForm, IibSHDataCustomForm, vFormater) then
        vFormater.SetDBGridOptions(FForm.FDBGrid);
      ApplyGridFormatOptions(FForm.FDBGrid);
      FForm.Show;
    end;
  except
    FForm.Hide;
  end;
end;

procedure TibSHEditForeignKeyPicker.DoOnOk(Sender: TObject);
var
  I: Integer;
begin
  FForm.Hide;
  DataIntf.Dataset.Dataset.Edit;
  for I := 0 to Pred(Fields.Count) do
  begin
    DataIntf.Dataset.Dataset.FieldByName(Fields[I]).Value :=
      DRVDataset.Dataset.FieldByName(ReferenceFields[I]).Value;
    if AnsiSameText(Fields[I], FFieldName) then
      InputEdit.Text := DataIntf.Dataset.Dataset.FieldByName(Fields[I]).AsString;
  end;
end;

procedure TibSHEditForeignKeyPicker.DoOnCancel(Sender: TObject);
begin
  FForm.Hide;
end;

end.
