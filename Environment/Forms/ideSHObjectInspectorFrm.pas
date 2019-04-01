unit ideSHObjectInspectorFrm;

interface

uses
  SHDesignIntf, SHEvents, ideSHDesignIntf, ideSHObject,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, Grids, TypInfo, ELPropInsp, StdCtrls, ExtCtrls,
  ToolWin, ComCtrls, Menus, ActnList, ImgList, Buttons, pSHNetscapeSplitter;

type
  TObjectInspectorForm = class(TSHComponentForm, ISHEventReceiver)
    Panel2: TPanel;         
    Panel3: TPanel;
    Tree: TVirtualStringTree;
    Panel5: TPanel;
    PropInspector: TELPropertyInspector;
    Panel4: TPanel;
    pSHNetscapeSplitter1: TpSHNetscapeSplitter;
    Panel1: TPanel;
    procedure PropInspectorFilterProp(Sender: TObject;
      AInstance: TPersistent; APropInfo: PPropInfo;
      var AIncludeProp: Boolean);
    procedure PropInspectorGetEditorClass(Sender: TObject;
      AInstance: TPersistent; APropInfo: PPropInfo;
      var AEditorClass: TELPropEditorClass);
    procedure pSHNetscapeSplitter1Moved(Sender: TObject);
  private
    { Private declarations }
    procedure DoShowProps(AInspector: TELPropertyInspector; APersistent: TPersistent);

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
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); reintroduce; overload; virtual;

    function ReceiveEvent(AEvent: TSHEvent): Boolean; override;

    procedure AddAction(AAction: TSHAction);
    procedure UpdateNodes;
  end;

//var
//  ObjectInspectorForm: TObjectInspectorForm;

implementation

uses
  ideSHConsts, ideSHSystem, ideSHSysUtils, ideSHProxiPropEditors, Math;

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

{ TInspectorForm }

constructor TObjectInspectorForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);

  DoShowProps(PropInspector, AComponent);

  SetTreeEvents(Tree);
  if Assigned(SystemOptionsIntf) then Panel5.Height := SystemOptionsIntf.IDE3Height;  
end;

procedure TObjectInspectorForm.DoShowProps(AInspector: TELPropertyInspector;
  APersistent: TPersistent);
var
  AList: TList;
begin
  AList := TList.Create;
  try
    if Assigned(AInspector) then
      with AInspector do
      begin
        BeginUpdate;
        if Assigned(APersistent) then
        begin
          AList.Add(APersistent);
          Objects.SetObjects(AList);
        end else
          Objects.Clear;
        EndUpdate;
      end;
  finally
    AList.Free;
  end;
end;

function TObjectInspectorForm.ReceiveEvent(AEvent: TSHEvent): Boolean;
begin
  Result := True;
  if Result then
    case AEvent.Event of
      SHE_REFRESH_OBJECT_INSPECTOR: PropInspector.UpdateItems;
    end;
end;

procedure TObjectInspectorForm.AddAction(AAction: TSHAction);
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Tree.BeginUpdate;
  try
    Node := Tree.AddChild(nil);
    NodeData := Tree.GetNodeData(Node);
    if Assigned(NodeData) then
    begin
      if Assigned(AAction) then
      begin
        NodeData.NormalText := AAction.Caption;
        NodeData.Action := AAction;
        NodeData.ImageIndex := AAction.ImageIndex;
        NodeData.NodeType := ntObject;
        NodeData.StaticText := Format('%s', [ShortCutToText(AAction.ShortCut)]);
      end else
      begin
        NodeData.NormalText := '';
        NodeData.Action := AAction;
        NodeData.ImageIndex := -1;
        NodeData.NodeType := ntFolder;
        Node.States := Node.States + [vsDisabled];
      end;
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

procedure TObjectInspectorForm.UpdateNodes;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
  SHAction: ISHAction;
begin
  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    NodeData := Tree.GetNodeData(Node);
    if Assigned(NodeData) and Assigned(NodeData.Action) and (NodeData.NodeType = ntObject) then
    begin
      NodeData.Action.Update;
      if Supports(NodeData.Action, ISHAction, SHAction) then SHAction.EnableShortCut;

      if NodeData.Action.Visible then
        Node.States := Node.States + [vsVisible]
      else
        Node.States := Node.States - [vsVisible];

      if NodeData.Action.Enabled then
        Node.States := Node.States - [vsDisabled]
      else
        Node.States := Node.States + [vsDisabled];
    end;
    Node := Tree.GetNext(Node);
  end;

  Tree.Refresh;
end;

procedure TObjectInspectorForm.DoOnEnter;
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

function TObjectInspectorForm.GetTreePopup: TPopupMenu;
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

{ Inspector }

procedure TObjectInspectorForm.PropInspectorFilterProp(Sender: TObject;
  AInstance: TPersistent; APropInfo: PPropInfo; var AIncludeProp: Boolean);
var
  DBComponentIntf: ISHDBComponent;
begin
  AIncludeProp := Assigned(Component) and Component.CanShowProperty(APropInfo.Name);
  if AIncludeProp then
  begin
    if Supports(Component, ISHDBComponent, DBComponentIntf) then
      if DBComponentIntf.State = csCreate then AIncludeProp := False;
  end;
end;

procedure TObjectInspectorForm.PropInspectorGetEditorClass(Sender: TObject;
  AInstance: TPersistent; APropInfo: PPropInfo;
  var AEditorClass: TELPropEditorClass);
begin
  AEditorClass := BTGetProxiEditorClass(TELPropertyInspector(Sender),
    AInstance, APropInfo);
end;

{ Tree }

procedure TObjectInspectorForm.SetTreeEvents(ATree: TVirtualStringTree);
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

procedure TObjectInspectorForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TObjectInspectorForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);
  if Assigned(NodeData) then Finalize(NodeData^);
end;

procedure TObjectInspectorForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData: PTreeRec;
begin
  ImageIndex := -1;
  NodeData := Sender.GetNodeData(Node);

  if Assigned(NodeData) then
  begin
    if (Kind = ikNormal) or (Kind = ikSelected) then
      ImageIndex := NodeData.ImageIndex;
  end;
end;

procedure TObjectInspectorForm.TreeGetText(Sender: TBaseVirtualTree;
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
      ttStatic: CellText := NodeData.StaticText;
    end;
  end;
  (*
  if Assigned(NodeData) and Assigned(NodeData.Action) then
  begin
    if (NodeData.Action.CallType = actCallForm) and NodeData.Action.Default then
    begin
      case TextType of
        ttNormal: CellText := Format('>>> %s', [NodeData.NormalText]);
        ttStatic: ;
      end;
    end;
  end;
  *)
end;

procedure TObjectInspectorForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);

  case TextType of
    ttNormal: if Node.ChildCount <> 0 then TargetCanvas.Font.Style := [fsBold];
    ttStatic: if Sender.Focused and (vsSelected in Node.States) then
                TargetCanvas.Font.Color := clWindow
              else
                TargetCanvas.Font.Color := clGray;
  end;

  if Assigned(NodeData) and Assigned(NodeData.Action) then
  begin
    if (NodeData.Action.CallType = actCallForm) and NodeData.Action.Default then
    begin
      case TextType of
        ttNormal: TargetCanvas.Font.Style := [fsBold];
        ttStatic: ;//if Sender.Focused and (vsSelected in Node.States) then
                //TargetCanvas.Font.Color := clWindow
              //else
              //  TargetCanvas.Font.Color := clGray;
      end;
    end;
  end;
end;

procedure TObjectInspectorForm.TreeIncrementalSearch(
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

procedure TObjectInspectorForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(Tree.FocusedNode) and (Key = VK_RETURN) then DoOnEnter;
end;

procedure TObjectInspectorForm.TreeDblClick(Sender: TObject);
var
  HT: THitInfo;
  P: TPoint;
begin
  GetCursorPos(P);
  if Assigned(Tree.FocusedNode) then
  begin
    P := Tree.ScreenToClient(P);
    Tree.GetHitTestInfoAt(P.X, P.Y, True, HT);
    if (HT.HitNode = Tree.FocusedNode) and not (hiOnItemButton in HT.HitPositions) then
      DoOnEnter;
  end;
end;

procedure TObjectInspectorForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
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

procedure TObjectInspectorForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  Result := CompareStr(Data1.NormalText, Data2.NormalText);
end;

//procedure TObjectInspectorForm.TreeGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
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

procedure TObjectInspectorForm.pSHNetscapeSplitter1Moved(Sender: TObject);
begin
  if Assigned(SystemOptionsIntf) then SystemOptionsIntf.IDE3Height := Panel5.Height;
end;

end.
