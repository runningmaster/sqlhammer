unit ideSHWindowListFrm;

interface

uses
  SHDesignIntf,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ideSHBaseDialogFrm, StdCtrls, ExtCtrls, VirtualTrees, AppEvnts,
  ImgList, ToolWin, ComCtrls;

type
  TWindowListForm = class(TBaseDialogForm)
    Panel1: TPanel;
    Tree: TVirtualStringTree;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    Edit1: TEdit;
    Bevel4: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure TreeGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure TreeFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure TreeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure FormShow(Sender: TObject);
    procedure TreeDblClick(Sender: TObject);
    procedure TreeIncrementalSearch(Sender: TBaseVirtualTree;
      Node: PVirtualNode; const SearchText: WideString;
      var Result: Integer);
    procedure TreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure Edit1Change(Sender: TObject);
    procedure ToolBar1Resize(Sender: TObject);
  private
    { Private declarations }
    procedure RecreateWindowList;
    procedure FindObject(const S: string);    
  public
    { Public declarations }
    procedure DoShowWindow;
  end;

//var
//  WindowListForm: TWindowListForm;

procedure ShowWindowListForm;

implementation

uses
  ideSHConsts, ideSHSystem;

{$R *.dfm}

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    NormalText: string;
    StaticText: string;
    Instance: Integer;
    ImageIndex: Integer;
  end;

procedure ShowWindowListForm;
var
  WindowListForm: TWindowListForm;
begin
  WindowListForm := TWindowListForm.Create(Application);
  try
    if IsPositiveResult(WindowListForm.ShowModal) then
      WindowListForm.DoShowWindow;
  finally
    FreeAndNil(WindowListForm);
  end;
end;

{ TWindowListForm }

procedure TWindowListForm.FormCreate(Sender: TObject);
begin
  SetFormSize(540, 340);
  Position := poScreenCenter;
  inherited;
  Caption := Format('%s', [SCaptionDialogWindowList]);
end;

procedure TWindowListForm.FormShow(Sender: TObject);
begin
  inherited;
  RecreateWindowList;
  if Assigned(Tree.FocusedNode) then
  begin
    Edit1.Text := DesignerIntf.CurrentComponent.Caption;
    FindObject(Edit1.Text);
  end;
end;

procedure TWindowListForm.RecreateWindowList;
var
  I, J: Integer;
  NodeData: PTreeRec;
  FirstNode, SecondNode, ThirdNode: PVirtualNode;
  CallStrings: TStrings;
begin
  Tree.Images := DesignerIntf.ImageList;
  CallStrings := TStringList.Create;
  try
    Screen.Cursor := crHourGlass;
    Tree.BeginUpdate;
    Tree.Clear;
    FirstNode := nil;

    for I := 0 to Pred(ObjectEditorIntf.PageCtrl.PageCount) do
    begin
      SecondNode := Tree.AddChild(FirstNode);
      NodeData := Tree.GetNodeData(SecondNode);
      NodeData.NormalText := Format('%s', [ObjectEditorIntf.GetComponent(I).CaptionExt]);
      NodeData.Instance := Integer(ObjectEditorIntf.GetComponent(I));
      NodeData.ImageIndex := DesignerIntf.GetImageIndex(ObjectEditorIntf.GetComponent(I).ClassIID);
      CallStrings.Assign(ObjectEditorIntf.GetCallStrings(I));
      for J := 0 to Pred(CallStrings.Count) do
      begin
        ThirdNode := Tree.AddChild(SecondNode);
        NodeData := Tree.GetNodeData(ThirdNode);
        NodeData.NormalText := Format('%s', [CallStrings.Strings[J]]);
        NodeData.Instance := Integer(ObjectEditorIntf.GetComponent(I));
        NodeData.ImageIndex := DesignerIntf.GetImageIndex(CallStrings.Strings[J]);
      end;
//      Tree.Expanded[SecondNode] := True;
    end;
    Tree.FocusedNode := Tree.GetFirst;
    Tree.Selected[Tree.FocusedNode] := True;
  finally
    Tree.EndUpdate;
    Screen.Cursor := crDefault;
    CallStrings.Free;
  end;
end;

procedure TWindowListForm.FindObject(const S: string);
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Node := Tree.GetFirst;
  if Assigned(Node) then
  begin
    while Assigned(Node) do
    begin
      NodeData := Tree.GetNodeData(Node);
      if Pos(AnsiUpperCase(S), AnsiUpperCase(NodeData.NormalText)) = 1 then
      begin
        Tree.FocusedNode := Node;
        Tree.Selected[Tree.FocusedNode] := True;
        Break;
      end else
      Node := Tree.GetNext(Node);
    end;
    if not Assigned(Node) then
    begin
      Tree.FocusedNode := Tree.GetFirst;
      Tree.Selected[Tree.FocusedNode] := True;
    end;
  end;
end;

procedure TWindowListForm.DoShowWindow;
var
  Data: PTreeRec;
begin
  if Assigned(Tree.FocusedNode) and Assigned(MainIntf) then
  begin
    Data := Tree.GetNodeData(Tree.FocusedNode);
    case Tree.GetNodeLevel(Tree.FocusedNode) of
      0: if Data.Instance <> 0 then MegaEditorIntf.Add(TSHComponent(Data.Instance), EmptyStr);
      1: if Data.Instance <> 0 then MegaEditorIntf.Add(TSHComponent(Data.Instance), Data.NormalText);
    end;
  end;
end;

{ Tree }

procedure TWindowListForm.TreeGetNodeDataSize(
  Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TWindowListForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TWindowListForm.TreeGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  Data := Tree.GetNodeData(Node);
  if (Kind = ikNormal) or (Kind = ikSelected) then
    ImageIndex := Data.ImageIndex;
end;

procedure TWindowListForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
begin
  Data := Tree.GetNodeData(Node);
  case TextType of
    ttNormal: CellText := Data.NormalText;
    ttStatic: ;
  end;
end;

procedure TWindowListForm.TreeDblClick(Sender: TObject);
begin
  if Assigned(Tree.FocusedNode) then ModalResult := mrOK;
end;

procedure TWindowListForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Tree.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.NormalText)) <> 1 then
    Result := 1;
end;

procedure TWindowListForm.TreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PTreeRec;
begin
  Data := nil;
  case Tree.GetNodeLevel(Node) of
    0: Data := Tree.GetNodeData(Node);
    1: Data := Tree.GetNodeData(Node.Parent);
  end;
  if Assigned(Data) and (Screen.ActiveControl = Sender) then
    Edit1.Text := Data.NormalText;
end;

procedure TWindowListForm.Edit1Change(Sender: TObject);
begin
  if Screen.ActiveControl = Sender then FindObject(Edit1.Text);
end;

procedure TWindowListForm.ToolBar1Resize(Sender: TObject);
begin
  Edit1.Width := Edit1.Parent.ClientWidth;
end;

end.
