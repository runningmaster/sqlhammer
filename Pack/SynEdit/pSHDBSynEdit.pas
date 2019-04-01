unit pSHDBSynEdit;

interface

uses Windows, Classes, Controls, DBCtrls, DB, Messages, SysUtils,
     SynEditKeyCmds,
     pSHSynEdit;

type
  TpSHDBSynEdit = class(TpSHSynEdit)
  private
    FDataLink: TFieldDataLink;
    FFocused: Boolean;
    FMemoLoaded: Boolean;
//    FPaintControl: TPaintControl;
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    function GetDataField: string;
    procedure SetDataField(const Value: string);
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function GetField: TField;

    procedure SetFocused(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMUndo(var Message: TMessage); message WM_UNDO;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    function GetReadOnly: Boolean; override;
    procedure SetReadOnly(Value: Boolean); override;
    procedure DoChange; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    procedure ExecuteCommand(Command: TSynEditorCommand; AChar: char;
      Data: pointer); override;
    procedure LoadMemo; virtual;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;
    property Field: TField read GetField;
  published
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

implementation

uses SynEdit;

{ TpSHDBSynEdit }

constructor TpSHDBSynEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  inherited ReadOnly := True;
end;

destructor TpSHDBSynEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TpSHDBSynEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TpSHDBSynEdit.DataChange(Sender: TObject);
begin
  if not Assigned(FDataLink) then Exit;
  if FDataLink.Field <> nil then
    if FDataLink.Field.IsBlob then
    begin
      FMemoLoaded := False;
      LoadMemo;
    end else
    begin
      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else
        Text := FDataLink.Field.DisplayText;
      FMemoLoaded := True;
    end
  else
  begin
    if csDesigning in ComponentState then Text := Name else Text := '';
    FMemoLoaded := False;
  end;
//  Invalidate;
//  if HandleAllocated then
//    RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_FRAME);
end;

procedure TpSHDBSynEdit.EditingChange(Sender: TObject);
begin
//  inherited ReadOnly := not (FDataLink.Editing and FMemoLoaded);
  inherited ReadOnly := not FMemoLoaded;
end;

function TpSHDBSynEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TpSHDBSynEdit.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TpSHDBSynEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TpSHDBSynEdit.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TpSHDBSynEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TpSHDBSynEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if not Assigned(FDataLink.Field) or not FDataLink.Field.IsBlob then
      FDataLink.Reset;
  end;
end;

procedure TpSHDBSynEdit.UpdateData(Sender: TObject);
begin
  FDataLink.Field.AsString := Text;
end;

procedure TpSHDBSynEdit.WMCut(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TpSHDBSynEdit.WMPaste(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TpSHDBSynEdit.WMUndo(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TpSHDBSynEdit.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
  if SysLocale.FarEast and FDataLink.CanModify then
    inherited ReadOnly := False;
end;

procedure TpSHDBSynEdit.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  SetFocused(False);
  inherited;
end;

procedure TpSHDBSynEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TpSHDBSynEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TpSHDBSynEdit.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TpSHDBSynEdit.DoChange;
begin
  if FMemoLoaded then FDataLink.Modified;
  FMemoLoaded := True;
  inherited DoChange;
end;

procedure TpSHDBSynEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if FMemoLoaded then
  begin
    if (Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift)) then
      FDataLink.Edit;
  end;
end;

procedure TpSHDBSynEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if FMemoLoaded then
  begin
    if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
      not FDataLink.Field.IsValidChar(Key) then
    begin
      MessageBeep(0);
      Key := #0;
    end;
    case Key of
      ^H, ^I, ^J, ^M, ^V, ^X, #32..#255:
        FDataLink.Edit;
      #27:
        FDataLink.Reset;
    end;
  end else
  begin
    if Key = #13 then LoadMemo;
    Key := #0;
  end;
end;

procedure TpSHDBSynEdit.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

function TpSHDBSynEdit.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

procedure TpSHDBSynEdit.DragDrop(Source: TObject; X, Y: Integer);
begin
  FDataLink.Edit;
  inherited DragDrop(Source, X, Y);
end;

procedure TpSHDBSynEdit.ExecuteCommand(Command: TSynEditorCommand;
  AChar: char; Data: pointer);
begin
  // cancel on [ESC]
  if (Command = ecChar) and (AChar = #27) then
    FDataLink.Reset
  // set editing state if editor command
  else begin
    if (Command >= ecEditCommandFirst) and (Command <= ecEditCommandLast) then
      FDataLink.Edit;
  end;
  inherited ExecuteCommand(Command, AChar, Data);
end;

procedure TpSHDBSynEdit.LoadMemo;
var
  BlobStream: TStream;
begin
  if not FMemoLoaded and Assigned(FDataLink.Field) and FDataLink.Field.IsBlob then
  begin
    try
      BlobStream := FDataLink.DataSet.CreateBlobStream(FDataLink.Field, bmRead);

      Lines.BeginUpdate;
      Lines.LoadFromStream(BlobStream);
      Lines.EndUpdate;
      BlobStream.Free;
      Modified := false;
      ClearUndo;
      FMemoLoaded := True;
    except
      { Memo too large }
      on E: EInvalidOperation do
        Lines.Text := Format('(%s)', [E.Message]);
    end;
    EditingChange(Self);
  end;
end;

function TpSHDBSynEdit.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

function TpSHDBSynEdit.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment(Self, Field);
end;

end.
