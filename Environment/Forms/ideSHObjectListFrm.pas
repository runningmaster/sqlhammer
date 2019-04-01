unit ideSHObjectListFrm;

interface

uses
  SHDesignIntf,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ideSHBaseDialogFrm, StdCtrls, ExtCtrls, AppEvnts, VirtualTrees,
  ToolWin, ComCtrls, StrUtils;

type
  TObjectListForm = class(TBaseDialogForm)
    Panel1: TPanel;
    Tree: TVirtualStringTree;
    ToolBar1: TToolBar;
    Edit1: TEdit;
    Bevel4: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure ToolBar1Resize(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure FindObject(const S: string);
    { Tree }
    procedure TreeGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure TreeFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure TreeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure TreePaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure TreeIncrementalSearch(Sender: TBaseVirtualTree;
      Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
    procedure TreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeDblClick(Sender: TObject);
    procedure TreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
      Column: TColumnIndex; var Result: Integer);
    procedure TreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
  public
    { Public declarations }
    procedure Prepare;
    procedure DoOnModalResult;
  end;

//var
//  ObjectListForm: TObjectListForm;

procedure ShowObjectListForm;

implementation

uses
  ideSHConsts, ideSHSystem, ideSHSysUtils;

{$R *.dfm}

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    NormalText: string;
    StaticText: string;
    Component: TSHComponent;
    ClassIID: TGUID;
    ImageIndex: Integer;
  end;

{ TObjectListForm }

procedure ShowObjectListForm;
var
  ObjectListForm: TObjectListForm;
begin
  try
    ObjectListForm := TObjectListForm.Create(Application);
    ObjectListForm.Prepare;
    if IsPositiveResult(ObjectListForm.ShowModal) then
      ObjectListForm.DoOnModalResult;
  finally
    FreeAndNil(ObjectListForm);
  end;
end;

procedure TObjectListForm.FormCreate(Sender: TObject);
begin
  SetFormSize(540, 340);
  Position := poScreenCenter;
  inherited;
  Caption := Format('%s', [SCaptionDialogObjectList]);
  Tree.Images := MainIntf.ImageList;

  Tree.OnGetNodeDataSize := TreeGetNodeDataSize;
  Tree.OnFreeNode := TreeFreeNode;
  Tree.OnGetImageIndex := TreeGetImageIndex;
  Tree.OnGetText := TreeGetText;
  Tree.OnPaintText := TreePaintText;
  Tree.OnIncrementalSearch := TreeIncrementalSearch;
  Tree.OnKeyDown := TreeKeyDown;
  Tree.OnDblClick := TreeDblClick;
  Tree.OnCompareNodes := TreeCompareNodes;
  Tree.OnFocusChanged := TreeFocusChanged;
end;

procedure TObjectListForm.Prepare;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
  DatabaseIntf: ISHDatabase;
  I, J, ImageIndex: Integer;
  ClassIID: TGUID;
  S: string;
begin
  if Assigned(NavigatorIntf) and Supports(NavigatorIntf.CurrentDatabase, ISHDatabase, DatabaseIntf) then
  begin
    Caption := Format('%s\%s', [DatabaseIntf.Caption, Caption]);
    Screen.Cursor := crHourGlass;
    Tree.BeginUpdate;
    try
      for I := 0 to Pred(DatabaseIntf.GetSchemeClassIIDList.Count) do
      begin
        ClassIID := StringToGUID(GetHintLeftPart(DatabaseIntf.GetSchemeClassIIDList[I]));
        ImageIndex := DesignerIntf.GetImageIndex(ClassIID);
        if not Assigned(RegistryIntf.GetRegComponent(ClassIID)) then Continue;
        S := RegistryIntf.GetRegComponent(ClassIID).GetAssociationClassFnc;
        for J := 0 to Pred(DatabaseIntf.GetObjectNameList(ClassIID).Count) do
        begin
          Node := Tree.AddChild(nil);
          NodeData := Tree.GetNodeData(Node);
          NodeData.NormalText := DatabaseIntf.GetObjectNameList(ClassIID)[J];
          NodeData.StaticText := S;
          NodeData.Component := nil; // Component
          NodeData.ClassIID := ClassIID;
          NodeData.ImageIndex := ImageIndex;
        end;
      end;
      Tree.Sort(nil, 0, sdAscending);
      Tree.FocusedNode := Tree.GetFirst;
      Tree.Selected[Tree.FocusedNode] := True;
    finally
      Tree.EndUpdate;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TObjectListForm.DoOnModalResult;
var
  Data: PTreeRec;
begin
  if Assigned(Tree.FocusedNode) then
  begin
    Data := Tree.GetNodeData(Tree.FocusedNode);
    if Assigned(NavigatorIntf) and Assigned(NavigatorIntf.CurrentDatabase) then
    ComponentFactoryIntf.CreateComponent(NavigatorIntf.CurrentDatabase.InstanceIID, Data.ClassIID, Data.NormalText);
  end;
end;

procedure TObjectListForm.FindObject(const S: string);
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Tree.TreeOptions.SelectionOptions := Tree.TreeOptions.SelectionOptions + [toCenterScrollIntoView];
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

procedure TObjectListForm.ToolBar1Resize(Sender: TObject);
begin
  Edit1.Width := Edit1.Parent.ClientWidth;
end;

procedure TObjectListForm.Edit1Change(Sender: TObject);
begin
  if Screen.ActiveControl = Sender then FindObject(Edit1.Text);
end;

{ Tree }

procedure TObjectListForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TObjectListForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TObjectListForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if (Kind = ikNormal) or (Kind = ikSelected) then
  begin
    case Column of
      0: ImageIndex := Data.ImageIndex;
      1: ImageIndex := -1;
    end;
  end;
end;

procedure TObjectListForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  case Column of
    0: case TextType of
         ttNormal: CellText := Data.NormalText;
         ttStatic: ;
       end;
    1: case TextType of
         ttNormal: CellText := Data.StaticText;
         ttStatic: ;
       end;
  end;
end;

procedure TObjectListForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if (Column = 1) and (TextType = ttNormal) then
    if Sender.Focused and (vsSelected in Node.States) then
      TargetCanvas.Font.Color := clWindow
    else
      TargetCanvas.Font.Color := clGray;
end;

procedure TObjectListForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  (Sender as TVirtualStringTree).TreeOptions.SelectionOptions := (Sender as TVirtualStringTree).TreeOptions.SelectionOptions + [toCenterScrollIntoView];
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.NormalText)) <> 1 then
    Result := 1;
end;

procedure TObjectListForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  (Sender as TVirtualStringTree).TreeOptions.SelectionOptions := (Sender as TVirtualStringTree).TreeOptions.SelectionOptions - [toCenterScrollIntoView];
end;

procedure TObjectListForm.TreeDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TObjectListForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Tree.GetNodeData(Node1);
  Data2 := Tree.GetNodeData(Node2);

  Result := CompareStr(Data1.NormalText, Data2.NormalText);
end;

procedure TObjectListForm.TreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PTreeRec;
begin
  if Column = 0  then
  begin
    Data := Tree.GetNodeData(Node);
    if Assigned(Data) and (Screen.ActiveControl = Sender) then
      Edit1.Text := Data.NormalText;
  end;
end;

procedure TObjectListForm.FormShow(Sender: TObject);
begin
  inherited;
  if Assigned(Tree.FocusedNode) and Supports(DesignerIntf.CurrentComponent, ISHDBComponent) then
  begin
    Edit1.Text := DesignerIntf.CurrentComponent.Caption;
    FindObject(Edit1.Text);
  end;
end;

end.
