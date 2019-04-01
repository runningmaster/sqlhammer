unit ibSHDMLExporterTreeEditors;

interface

uses
  SHDesignIntf,
  Windows, Classes, Controls, Types, Messages, StdCtrls,
  VirtualTrees,
  pSHSynEdit;

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    ObjectName: string;
    Description: string;
    DestinationTable: string;
    WhereClause: string;
    UseAsUpdateField: Boolean;

    Changed: Boolean;
    ImageIndex: Integer;
    IsDummy: Boolean;
  end;

  TNotifyRegistrationEditor = procedure(AEditor: TpSHSynEdit) of object;

  TDMLExporterObjectEditLink = class(TInterfacedObject, IVTEditLink)
  private
    FEdit: TWinControl;        // One of the property editor classes.
    FTree: TVirtualStringTree; // A back reference to the tree calling.
    FNode: PVirtualNode;       // The node being edited.
    FColumn: Integer;          // The column of the node being edited.

    FOnRegistryEditor: TNotifyRegistrationEditor;
    procedure SetOnRegistryEditor(const Value: TNotifyRegistrationEditor);
  protected
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    destructor Destroy; override;

    function BeginEdit: Boolean; stdcall;
    function CancelEdit: Boolean; stdcall;
    function EndEdit: Boolean; stdcall;
    function GetBounds: TRect; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); stdcall;

    property OnRegistryEditor: TNotifyRegistrationEditor read FOnRegistryEditor
      write SetOnRegistryEditor;
  end;


implementation

uses SynEdit;

{ TPropertyEditLink }

destructor TDMLExporterObjectEditLink.Destroy;
begin
  FEdit.Free;
  inherited;
end;

procedure TDMLExporterObjectEditLink.SetOnRegistryEditor(
  const Value: TNotifyRegistrationEditor);
begin
  FOnRegistryEditor := Value;
end;

procedure TDMLExporterObjectEditLink.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN,
    VK_DOWN,
    VK_UP:
      begin
        if (Shift = []) then
        begin
          // Forward the keypress to the tree. It will asynchronously change the focused node.
          PostMessage(FTree.Handle, WM_KEYDOWN, Key, 0);
          Key := 0;
        end;
      end;
  end;
end;

function TDMLExporterObjectEditLink.BeginEdit: Boolean;
begin
  Result := True;
  FEdit.Show;
  FEdit.SetFocus;
end;

function TDMLExporterObjectEditLink.CancelEdit: Boolean;
begin
  Result := True;
  FEdit.Hide;
end;

function TDMLExporterObjectEditLink.EndEdit: Boolean;
var
  Data: PTreeRec;
  Buffer: array[0..1024] of Char;
  S: WideString;
begin
  Result := True;
  Data := FTree.GetNodeData(FNode);
  case FColumn of
    0, 1:;
    2:
      begin
        with FEdit as TCheckBox do
        begin
          if Checked <> Data.UseAsUpdateField then
          begin
            Data.UseAsUpdateField := Checked;
            Data.Changed := True;
            FTree.InvalidateNode(FNode);
          end;
        end;
      end;
    3:
      begin
        GetWindowText(FEdit.Handle, Buffer, 1024);
        S := Buffer;
        if S <> Data.WhereClause then
        begin
          Data.WhereClause := S;
          Data.Changed := True;
          FTree.InvalidateNode(FNode);
        end;
      end;
    4:
      begin
        GetWindowText(FEdit.Handle, Buffer, 1024);
        S := Buffer;
        if S <> Data.DestinationTable then
        begin
          Data.DestinationTable := S;
          Data.Changed := True;
          FTree.InvalidateNode(FNode);
        end;
      end;
  end;
  FEdit.Hide;
  FTree.SetFocus;
end;

function TDMLExporterObjectEditLink.GetBounds: TRect;
begin
  Result := FEdit.BoundsRect;
end;

function TDMLExporterObjectEditLink.PrepareEdit(Tree: TBaseVirtualTree;
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
    0, 1: Result := False;
    2:
      begin
        FEdit := TCheckBox.Create(nil);
        with FEdit as TCheckBox do
        begin
          Visible := False;
          Parent := Tree;
          Checked := Data.UseAsUpdateField;
          OnKeyDown := EditKeyDown;
          FEdit.Perform(WM_LBUTTONDOWN, MK_LBUTTON, 1 shl 16 + 1);
          FEdit.Perform(WM_LBUTTONUP, MK_LBUTTON, 1 shl 16 + 1);
        end;
      end;
    3:
      begin
        FEdit := TpSHSynEdit.Create(nil);
        if Assigned(FOnRegistryEditor) then
          FOnRegistryEditor(TpSHSynEdit(FEdit));
        with FEdit as TpSHSynEdit do
        begin
          Visible := False;
          Parent := Tree;
          Lines.Text := Data.WhereClause;
          OnKeyDown := EditKeyDown;
        end;
      end;
    4:
      begin
        FEdit := TEdit.Create(nil);
        with FEdit as TEdit do
        begin
          Visible := False;
          Parent := Tree;
          Text := Data.DestinationTable;
          OnKeyDown := EditKeyDown;
        end;
      end;
  end;
end;

procedure TDMLExporterObjectEditLink.ProcessMessage(var Message: TMessage);
begin
  FEdit.WindowProc(Message);
end;

procedure TDMLExporterObjectEditLink.SetBounds(R: TRect);
var
  Dummy: Integer;
  NewRect: TRect;
begin
  // Since we don't want to activate grid extensions in the tree (this would influence how the selection is drawn)
  // we have to set the edit's width explicitly to the width of the column.
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  case FColumn of
    0, 1:;
    2:
      begin
        // CheckBox for UPDATE StatementType
        NewRect := R;
        NewRect.Left := R.Left + ((R.Right - R.Left) div 2) - 6;
        FEdit.BoundsRect := NewRect;
      end;
    3:
      begin
        // Editor (SynEdit) for Additional Conditions
        NewRect := R;
        NewRect.Bottom := (R.Bottom - R.Top) * 5 + R.Top;
        NewRect.Right := FTree.ClientRect.Right;
        if NewRect.Bottom > FTree.ClientRect.Bottom then
        begin
          NewRect.Top := NewRect.Top - (NewRect.Bottom - FTree.ClientRect.Bottom);
          NewRect.Bottom:= FTree.ClientRect.Bottom;
        end;
        FEdit.BoundsRect := NewRect;
      end;
    4: FEdit.BoundsRect := R;
  end;
end;

end.


