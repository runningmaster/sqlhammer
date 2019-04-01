unit ideSHComponentPageFrm;

interface

uses
  SHDesignIntf, ideSHDesignIntf, 
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ToolWin, ComCtrls, Contnrs, VirtualTrees,
  Menus, ActnList;

type
  TComponentPageForm = class(TSHComponentForm)
    PopupMenu1: TPopupMenu;
    CreateInstance1: TMenuItem;
    Panel1: TPanel;
    Tree: TVirtualStringTree;
    Panel2: TPanel;
    procedure CreateInstance1Click(Sender: TObject);
  private
    { Private declarations }
    function FindCategoryNode(const ACategory: string): PVirtualNode;

   { Tree }
    procedure SetTreeEvents(ATree: TVirtualStringTree);

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
    procedure TreeIncrementalSearch(
      Sender: TBaseVirtualTree; Node: PVirtualNode;
      const SearchText: WideString; var Result: Integer);
    procedure TreeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TreeDblClick(Sender: TObject);
    procedure TreeGetPopupMenu(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
      var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure TreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
      Column: TColumnIndex; var Result: Integer);
//    procedure TreeGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
//      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
//      var HintText: WideString);
  protected
    procedure DoOnEnter;
    function GetTreePopup: TPopupMenu;
    procedure DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure BringToTop; override;
    procedure ReloadComponents;
  end;

//var
//  PaletteForm: TPaletteForm;

implementation

uses
  ideSHConsts, ideSHSystem, ideSHSysUtils;

{$R *.dfm}

type
  TNodeType = (ntFolder, ntServer, ntDatabase, ntObject);
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    NormalText: string;
    StaticText: string;
    Action: TSHAction;
    NodeType: TNodeType;
    ImageIndex: Integer;
  end;

{ TPaletteForm }

constructor TComponentPageForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  if Assigned(ModalForm) then
  begin
    Caption := Format(ACallString, [Component.Caption]);
    ModalForm.OnAfterModalClose := DoOnAfterModalClose;
    Panel1.BevelInner := bvLowered;
    Panel2.Visible := False;
    Tree.Color := clWindow;
  end;

  SetTreeEvents(Tree);
end;

destructor TComponentPageForm.Destroy;
begin
  inherited Destroy;
end;

procedure TComponentPageForm.BringToTop;
begin
  if Tree.CanFocus then Tree.SetFocus;
end;

procedure TComponentPageForm.ReloadComponents;
var
  I: Integer;
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Tree.BeginUpdate;
  Tree.Clear;
  try

    for I := 0 to Pred(DesignerIntf.ActionList.ActionCount) do
      if Supports(DesignerIntf.ActionList.Actions[I], ISHAction) and
         ((DesignerIntf.ActionList.Actions[I] as ISHAction).CallType = actCallPalette) and
          (DesignerIntf.ActionList.Actions[I] as ISHAction).SupportComponent(Component.ClassIID) then
    begin
      DesignerIntf.ActionList.Actions[I].Update;
      Node := FindCategoryNode(DesignerIntf.ActionList.Actions[I].Category);
      if not Assigned(Node) then
      begin
        Node := Tree.AddChild(nil);
        NodeData := Tree.GetNodeData(Node);
        if Assigned(NodeData) then
        begin
          NodeData.NormalText := DesignerIntf.ActionList.Actions[I].Category;
          NodeData.ImageIndex := IMG_PACKAGE;
          NodeData.NodeType := ntFolder;
        end;
      end;

      Node := Tree.AddChild(Node);
      NodeData := Tree.GetNodeData(Node);
      if Assigned(NodeData) then
      begin
        NodeData.NormalText := TAction(DesignerIntf.ActionList.Actions[I]).Caption;
        NodeData.Action := TSHAction(DesignerIntf.ActionList.Actions[I]);
        NodeData.ImageIndex := TAction(DesignerIntf.ActionList.Actions[I]).ImageIndex;
        NodeData.NodeType := ntObject;
        NodeData.StaticText := Format('%s', [ShortCutToText(TAction(DesignerIntf.ActionList.Actions[I]).ShortCut)]);
        if NodeData.StaticText = '()' then NodeData.StaticText := EmptyStr;
      end;
      if Assigned(ModalForm) then
        if Assigned(Node.Parent) then Tree.Expanded[Node.Parent] := True;
    end;

  finally
    Tree.EndUpdate;
    if Tree.GetFirst <> nil then
    begin
      Tree.FocusedNode := Tree.GetFirst;
      Tree.Selected[Tree.FocusedNode] := True;
    end;
  end;
end;

function TComponentPageForm.FindCategoryNode(const ACategory: string): PVirtualNode;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Result := nil;
  Node:= Tree.GetFirst;
  while not Assigned(Result) and Assigned(Node) do
  begin
    NodeData := Tree.GetNodeData(Node);
    if Assigned(NodeData) then
    begin
      if (NodeData.NodeType = ntFolder) and AnsiSameText(NodeData.NormalText, ACategory) then
        Result := Node;
    end;
    Node := Tree.GetNextSibling(Node);
  end;
end;

procedure TComponentPageForm.DoOnEnter;
var
  NodeData: PTreeRec;
begin
  if Assigned(Tree.FocusedNode) then
  begin
    NodeData := Tree.GetNodeData(Tree.FocusedNode);
    if Assigned(NodeData) and (NodeData.NodeType = ntObject) and
       Assigned(NodeData.Action) and (NodeData.Action.Enabled) then
      NodeData.Action.Execute;
  end;
end;

function TComponentPageForm.GetTreePopup: TPopupMenu;
var
  NodeData: PTreeRec;
begin
  Result := nil;
  if Assigned(Tree.FocusedNode) then
  begin
    NodeData := Tree.GetNodeData(Tree.FocusedNode);
    if Assigned(NodeData) then ;
  end;
end;

procedure TComponentPageForm.DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult);
begin
  if ModalResult = mrOK then DoOnEnter;
end;

procedure TComponentPageForm.CreateInstance1Click(Sender: TObject);
begin
  DoOnEnter;
end;

{ Tree }

procedure TComponentPageForm.SetTreeEvents(ATree: TVirtualStringTree);
begin
  ATree.Images := Designer.ImageList;

  ATree.OnGetNodeDataSize := TreeGetNodeDataSize;
  ATree.OnFreeNode := TreeFreeNode;
  ATree.OnGetImageIndex := TreeGetImageIndex;
  ATree.OnGetText := TreeGetText;
  ATree.OnPaintText := TreePaintText;
  ATree.OnIncrementalSearch := TreeIncrementalSearch;
  ATree.OnKeyDown := TreeKeyDown;
  ATree.OnDblClick := TreeDblClick;
  ATree.OnGetPopupMenu := TreeGetPopupMenu;
  ATree.OnCompareNodes := TreeCompareNodes;
//  ATree.OnGetHint := TreeGetHint;
end;

procedure TComponentPageForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TComponentPageForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);
  if Assigned(NodeData) then Finalize(NodeData^);
end;

procedure TComponentPageForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData: PTreeRec;
begin
  ImageIndex := -1;
  NodeData := Sender.GetNodeData(Node);

  if Assigned(NodeData) then
  begin
    if Assigned(NodeData.Action) then
    begin
      NodeData.Action.Update;
      if NodeData.Action.Enabled then
        Node.States := Node.States - [vsDisabled]
      else
        Node.States := Node.States + [vsDisabled];
    end;

    if (Kind = ikNormal) or (Kind = ikSelected) then
      ImageIndex := NodeData.ImageIndex;
  end;
end;

procedure TComponentPageForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);

  if Assigned(NodeData) then
  begin
    case TextType of
      ttNormal: CellText := NodeData.NormalText;
      ttStatic:
      begin
        if Node.ChildCount > 0 then
          CellText := Format('%d', [Node.ChildCount])
        else
          CellText := EmptyStr;

        if Assigned(NodeData.Action) and not Assigned(ModalForm) then
          CellText := NodeData.StaticText;
      end;
    end;
  end;
end;

procedure TComponentPageForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  case TextType of
    ttNormal: if Node.ChildCount <> 0 then TargetCanvas.Font.Style := [fsBold];
    ttStatic: if Sender.Focused and (vsSelected in Node.States) then
                  TargetCanvas.Font.Color := clWindow
                else
                  TargetCanvas.Font.Color := clGray;
  end;
end;

procedure TComponentPageForm.TreeIncrementalSearch(
  Sender: TBaseVirtualTree; Node: PVirtualNode;
  const SearchText: WideString; var Result: Integer);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);
  if Assigned(NodeData) then
    if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(NodeData.NormalText)) <> 1 then
      Result := 1;
end;

procedure TComponentPageForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(Tree.FocusedNode) and (Key = VK_RETURN) then DoOnEnter;
end;

procedure TComponentPageForm.TreeDblClick(Sender: TObject);
var
  HT: THitInfo;
  P: TPoint;
  NodeData: PTreeRec;
begin
  GetCursorPos(P);
  if Assigned(Tree.FocusedNode) then
  begin
    NodeData := Tree.GetNodeData(Tree.FocusedNode);
    P := Tree.ScreenToClient(P);
    Tree.GetHitTestInfoAt(P.X, P.Y, True, HT);
    if (HT.HitNode = Tree.FocusedNode) and not (hiOnItemButton in HT.HitPositions) then
    begin
      if Assigned(ModalForm) then
      begin
        if Assigned(NodeData) and (NodeData.NodeType = ntObject) then
          ModalForm.ModalResultCode := mrOK
      end else
        DoOnEnter;
    end;
  end;
end;

procedure TComponentPageForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
var
  HT: THitInfo;
begin
  AskParent := False;
  PopupMenu := nil;
  if Assigned(Tree.FocusedNode) then
  begin
    Tree.GetHitTestInfoAt(P.X, P.Y, True, HT);
    if HT.HitNode = Sender.FocusedNode then PopupMenu := GetTreePopup;
    if not Assigned(PopupMenu) then Exit;
  end;
end;

procedure TComponentPageForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  Result := CompareStr(Data1.NormalText, Data2.NormalText);
end;

//procedure TComponentPageForm.TreeGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
//  Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
//  var HintText: WideString);
//var
//  NodeData: PTreeRec;
//begin
//  NodeData := Sender.GetNodeData(Node);
//  if Assigned(NodeData) and (NodeData.NodeType = ntObject) then
//    if Length(NodeData.StaticText) > 0 then
//      HintText := Format('%s (%s)', [NodeData.NormalText, NodeData.StaticText])
//    else
//      HintText := Format('%s', [NodeData.NormalText]);
//end;

end.
