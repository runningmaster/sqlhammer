unit ibSHDependenciesFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, ComCtrls, ToolWin, VirtualTrees, Menus, Contnrs,
  SynEdit, pSHSynEdit, ActnList, AppEvnts;

type
  TibBTDependenciesForm = class(TibBTComponentForm)
    ImageList1: TImageList;
    Panel1: TPanel;
    Panel2: TPanel;
    pSHSynEdit1: TpSHSynEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel5: TPanel;
    ActionList1: TActionList;
    actClear: TAction;
    actExtractDependencies: TAction;
    Tree: TVirtualStringTree;
    actShowSource: TAction;
    ApplicationEvents1: TApplicationEvents;
    actRefreshDependencies: TAction;
    actCheckDependencies: TAction;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure Panel1Resize(Sender: TObject);
  private
    { Private declarations }
    FDependencies: TComponent;
    FDDLGenerator: TComponent;
    FUsesList: TObjectList;
    function GetDependencies: IibSHDependencies;
    function GetDDLGenerator: IibSHDDLGenerator;
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
    procedure TreeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TreeDblClick(Sender: TObject);
    procedure TreeGetPopupMenu(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
      var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure TreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
      Column: TColumnIndex; var Result: Integer);
    procedure TreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);

    procedure SetTreeEvents(ATree: TVirtualStringTree);
    procedure GutterDrawNotify(Sender: TObject; ALine: Integer; var ImageIndex: Integer);
    function CreateUsesArea: TVirtualStringTree;
    procedure InitUsesArea(const AClassIID: TGUID; const ACaption, AOwnerCaption: string; ATree: TVirtualStringTree);
//    procedure ShowMessageWindow;
    procedure HideMessageWindow;
    procedure ShowSource;
    procedure JumpToSource;

    procedure ShowDependencies;
    procedure ClearDependencies;
    procedure ExtractDependencies;
    procedure RefreshDependencies;
//    procedure CheckDependencies;
  protected
  protected
    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanRefresh: Boolean; override;

    procedure Run; override;
    procedure Refresh; override;

    function DoOnOptionsChanged: Boolean; override;
    procedure DoOnIdle; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    function InsertNew(const AClassIID: TGUID; const ACaption: string; AParent: PVirtualNode): PVirtualNode;

    property Dependencies: IibSHDependencies read GetDependencies;
    property DDLGenerator: IibSHDDLGenerator read GetDDLGenerator;
  end;

  TibBTDependenciesFormAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibBTDependenciesFormAction_Run = class(TibBTDependenciesFormAction_)
  end;
  TibBTDependenciesFormAction_Refresh = class(TibBTDependenciesFormAction_)
  end;

var
  ibBTDependenciesForm: TibBTDependenciesForm;

procedure Register;

implementation

uses
  ibSHConsts, ibSHValues;

{$R *.dfm}

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    NormalText: string;
    StaticText: string;
    ClassIID: TGUID;
    ImageIndex: Integer;
    IsEmpty: Integer;
    U: Integer; {0 None | 1 Used By| 2 Uses}
  end;

var
  NodeIDGenerator: Integer;

procedure Register;
begin
  SHRegisterImage(TibBTDependenciesFormAction_Run.ClassName,     'Button_Run.bmp');
  SHRegisterImage(TibBTDependenciesFormAction_Refresh.ClassName, 'Button_Refresh.bmp');

  SHRegisterActions([
    TibBTDependenciesFormAction_Run,
    TibBTDependenciesFormAction_Refresh]);
end;

{ TibBTDependencesForm }

constructor TibBTDependenciesForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  vComponentClass: TSHComponentClass;
begin
  FUsesList := TObjectList.Create;
  inherited Create(AOwner, AParent, AComponent, ACallString);
  FocusedControl := Tree;
  SetTreeEvents(Tree);

  vComponentClass := Designer.GetComponent(IibSHDependencies);
  if Assigned(vComponentClass) then FDependencies := vComponentClass.Create(nil);

  vComponentClass := Designer.GetComponent(IibSHDDLGenerator);
  if Assigned(vComponentClass) then  FDDLGenerator := vComponentClass.Create(nil);

  ClearDependencies;

  Panel2.Height := Trunc(Self.Height * 5/9);
  Editor := pSHSynEdit1;
  Editor.OnGutterDraw := GutterDrawNotify;
  Editor.GutterDrawer.ImageList := ImageList1;
  Editor.GutterDrawer.Enabled := True;  
  RegisterEditors;
  DoOnOptionsChanged;
  HideMessageWindow;
//  ShowMessageWindow;
end;

destructor TibBTDependenciesForm.Destroy;
begin
  FUsesList.Free;
  FDependencies.Free;
  FDDLGenerator.Free;
  inherited Destroy;
end;

function TibBTDependenciesForm.GetDependencies: IibSHDependencies;
begin
  Supports(FDependencies, IibSHDependencies, Result);
end;

function TibBTDependenciesForm.GetDDLGenerator: IibSHDDLGenerator;
begin
  Supports(FDDLGenerator, IibSHDDLGenerator, Result);
end;

function TibBTDependenciesForm.GetCanRun: Boolean;
begin
  Result := Assigned(Tree.FocusedNode) and
      Assigned(TVirtualStringTree(FUsesList[Tree.FocusedNode.Dummy]).FocusedNode) and
     (TVirtualStringTree(FUsesList[Tree.FocusedNode.Dummy]).GetNodeLevel(TVirtualStringTree(FUsesList[Tree.FocusedNode.Dummy]).FocusedNode) > 1);
end;

function TibBTDependenciesForm.GetCanRefresh: Boolean;
begin
  Result := True;
end;

procedure TibBTDependenciesForm.Run;
begin
  ExtractDependencies;
end;

procedure TibBTDependenciesForm.Refresh;
begin
  RefreshDependencies;
end;

function TibBTDependenciesForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
  if Result then Editor.ReadOnly := True;
end;

procedure TibBTDependenciesForm.DoOnIdle;
begin
//  actClear.Enabled := True;
//  actExtractDependencies.Enabled := Assigned(Tree.FocusedNode) and
//    Assigned(TVirtualStringTree(FUsesList[Tree.FocusedNode.Dummy]).FocusedNode) and
//    (TVirtualStringTree(FUsesList[Tree.FocusedNode.Dummy]).GetNodeLevel(TVirtualStringTree(FUsesList[Tree.FocusedNode.Dummy]).FocusedNode) > 1);
end;

procedure TibBTDependenciesForm.SetTreeEvents(ATree: TVirtualStringTree);
begin
  ATree.Images := Designer.ImageList;
  ATree.OnGetNodeDataSize := TreeGetNodeDataSize;
  ATree.OnFreeNode := TreeFreeNode;
  ATree.OnGetImageIndex := TreeGetImageIndex;
  ATree.OnGetText := TreeGetText;
  ATree.OnPaintText := TreePaintText;
  ATree.OnIncrementalSearch := TreeIncrementalSearch;
  ATree.OnDblClick := TreeDblClick;
  ATree.OnKeyDown := TreeKeyDown;
  ATree.OnGetPopupMenu := TreeGetPopupMenu;
  ATree.OnCompareNodes := TreeCompareNodes;
  ATree.OnFocusChanged := TreeFocusChanged;
end;

procedure TibBTDependenciesForm.GutterDrawNotify(Sender: TObject; ALine: Integer;
  var ImageIndex: Integer);
begin
  if ALine = 0 then ImageIndex := 0;
end;

function TibBTDependenciesForm.CreateUsesArea: TVirtualStringTree;
begin
  Result := TVirtualStringTree.Create(nil);
  Result.BorderStyle := bsNone;
  Result.Align := alClient;
  Result.Tag := 1;
  Result.Parent := Panel5;

  Result.ButtonFillMode := fmShaded;
  Result.HintAnimation := hatNone;
  Result.HintMode := hmTooltip;
  Result.IncrementalSearch := isAll;
  Result.Indent := 12;
  Result.ShowHint := True;
  Result.TreeOptions.MiscOptions := [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning];
  Result.TreeOptions.PaintOptions := [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection];
  Result.TreeOptions.SelectionOptions := [toFullRowSelect, toRightClickSelect];
  Result.TreeOptions.StringOptions := [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange];

  Result.Header.Options := [hoAutoResize, hoColumnResize, hoDrag, hoVisible];
  Result.Header.Style := hsFlatButtons;
  Result.Header.Columns.Add.Text := Format('%s', [STypeAndObjects]);
  Result.Header.Font.Name := 'Tahoma';
  Result.BringToFront;
  SetTreeEvents(Result);
  FUsesList.Add(Result);
end;

procedure TibBTDependenciesForm.InitUsesArea(const AClassIID: TGUID; const ACaption, AOwnerCaption: string; ATree: TVirtualStringTree);
var
  ObjectList, FieldList: TStrings;
  Node: PVirtualNode;
  Node0, Node1: PVirtualNode;
  NodeData: PTreeRec;
  vU: Integer;

  function DoInitNode(const AIID: TGUID; const AText: string; AParent: PVirtualNode): PVirtualNode;
  begin
    Result := ATree.AddChild(AParent);
    NodeData := ATree.GetNodeData(Result);
    NodeData.NormalText := AText;
    NodeData.ClassIID := AIID;
    NodeData.ImageIndex := Designer.GetImageIndex(AIID);
    NodeData.IsEmpty := -1;
    NodeData.U := vU;
  end;

  procedure DoInitObjects(const AIID: TGUID; AParent: PVirtualNode);
  var
    I, J: Integer;
  begin
    ObjectList.Assign(Dependencies.GetObjectNames(AIID));
    if ObjectList.Count > 0 then
    begin
      Node0 := DoInitNode(AIID, Format('%s', [GUIDToName(AIID, 1)]), AParent);
      for I := 0 to Pred(ObjectList.Count) do
      begin
        Node1 := DoInitNode(AIID, ObjectList[I], Node0);
        FieldList.Assign(Dependencies.GetObjectNames(AIID, ObjectList[I]));
        if FieldList.Count > 0 then
          for J := 0 to Pred(FieldList.Count) do
            DoInitNode(IibSHField, FieldList[J], Node1);
      end;
    end;
  end;
begin
  if not Assigned(Dependencies) then Exit;
  if ATree.RootNodeCount <> 0 then
   Exit;
  ObjectList := TStringList.Create;
  FieldList := TStringList.Create;
  try
    ATree.BeginUpdate;

    vU := 1;
    Dependencies.Execute(dtUsedBy, (Component as IibSHDBObject).BTCLDatabase, AClassIID, ACaption, AOwnerCaption);
    if not Dependencies.IsEmpty then
    begin
      Node := DoInitNode(IUnknown, 'Used By', nil);
      DoInitObjects(IibSHTable, Node);
      DoInitObjects(IibSHConstraint, Node);
      DoInitObjects(IibSHIndex, Node);
      DoInitObjects(IibSHView, Node);
      DoInitObjects(IibSHProcedure, Node);
      DoInitObjects(IibSHTrigger, Node);
      DoInitObjects(IibSHGenerator, Node);
      DoInitObjects(IibSHException, Node);
      DoInitObjects(IibSHFunction, Node);
      DoInitObjects(IibSHFilter, Node);
      if Node.ChildCount <> 0 then ATree.Expanded[Node] := True;
    end;
    
    vU := 2;
    Dependencies.Execute(dtUses, (Component as IibSHDBObject).BTCLDatabase, AClassIID, ACaption,AOwnerCaption);
    if not Dependencies.IsEmpty then
    begin
      Node := DoInitNode(IUnknown, 'Uses', nil);
      DoInitObjects(IibSHDomain, Node);      
      DoInitObjects(IibSHTable, Node);
      DoInitObjects(IibSHConstraint, Node);
      DoInitObjects(IibSHIndex, Node);
      DoInitObjects(IibSHView, Node);
      DoInitObjects(IibSHProcedure, Node);
      DoInitObjects(IibSHTrigger, Node);
      DoInitObjects(IibSHGenerator, Node);
      DoInitObjects(IibSHException, Node);
      DoInitObjects(IibSHFunction, Node);
      DoInitObjects(IibSHFilter, Node);
      if Node.ChildCount <> 0 then ATree.Expanded[Node] := True;
    end;

  finally
    ATree.EndUpdate;
    ObjectList.Free;
    FieldList.Free;
  end;

  Node := ATree.GetFirst;
  if not Assigned(Node) then
  begin
    Node := ATree.AddChild(nil);
    NodeData := ATree.GetNodeData(Node);
    NodeData.NormalText := '< none >';
    NodeData.ImageIndex := -1;
    NodeData.IsEmpty := -1;
  end;

  if Assigned(Node) then
  begin
    ATree.FocusedNode := Node;
    ATree.Selected[ATree.FocusedNode] := True;
    ATree.Repaint;
    ATree.Invalidate;
  end;
end;

function TibBTDependenciesForm.InsertNew(const AClassIID: TGUID; const ACaption: string; AParent: PVirtualNode): PVirtualNode;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  CreateUsesArea;
  Node := Tree.AddChild(AParent);
  Node.Dummy := NodeIDGenerator;
  Inc(NodeIDGenerator);
  NodeData := Tree.GetNodeData(Node);
  NodeData.NormalText := ACaption;
  NodeData.StaticText := EmptyStr;
  NodeData.ClassIID := AClassIID;
  NodeData.ImageIndex := Designer.GetImageIndex(AClassIID);
  Result := Node;
  if Assigned(AParent) then Node := Tree.GetFirst;
  if Assigned(Node) then
  begin
//    if Assigned(AParent) and (AParent.ChildCount <> 0) then Tree.Expanded[AParent] := True;
    Tree.FocusedNode := Node;
    Tree.Selected[Tree.FocusedNode] := True;
  end;
end;

//procedure TibBTDependenciesForm.ShowMessageWindow;
//begin
//  Panel2.Visible := True;
//  Splitter1.Visible := True;
//end;

procedure TibBTDependenciesForm.HideMessageWindow;
begin
  Panel2.Visible := False;
  Splitter1.Visible := False;
end;

procedure TibBTDependenciesForm.ShowSource;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
  vTree: TVirtualStringTree;
  vComponentClass: TSHComponentClass;
  vComponent: TSHComponent;
  vSource: string;
  vDBObject: IibSHDBObject;
begin
  Node := nil;
  if Panel2.Visible then Node := Tree.FocusedNode;
  if Assigned(Node) and not Tree.Focused and (FUsesList.Count > 0) then
    vTree := TVirtualStringTree(FUsesList[Node.Dummy])
  else
    vTree := Tree;

  if Assigned(Editor) then Editor.Lines.Clear;
  if Assigned(vTree) then
  begin
    Node := vTree.FocusedNode;
    NodeData := nil;
    case vTree.Tag of
      0:;
      1: case vTree.GetNodeLevel(Node) of
           2: NodeData := vTree.GetNodeData(Node);
           3: NodeData := vTree.GetNodeData(Node.Parent);
         end;
    end;

    if Assigned(NodeData) then
    begin
      vComponentClass := Designer.GetComponent(NodeData.ClassIID);
      if Assigned(vComponentClass) then vComponent := vComponentClass.Create(nil);

      if Assigned(vComponent) and Supports(vComponent, IibSHDBObject, vDBObject) then
      begin
        try
          vDBObject.Caption := NodeData.NormalText;
          vDBObject.OwnerIID := Component.OwnerIID;
          vDBObject.State := csSource;
          if Assigned(DDLGenerator) then vSource := DDLGenerator.GetDDLText(vDBObject);
        finally
          if Assigned(vDBObject) then vDBObject := nil;
          FreeAndNil(vComponent);
        end;
      end;

      if Assigned(Editor) then
      begin
        Editor.BeginUpdate;
        Editor.Lines.Clear;
        Editor.Lines.Text := vSource;
        Editor.EndUpdate;
      end;
    end;
  end;
end;

procedure TibBTDependenciesForm.JumpToSource;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
  vTree: TVirtualStringTree;
begin
  vTree := nil;
  Node := Tree.FocusedNode;
  if Assigned(Node) then vTree := TVirtualStringTree(FUsesList[Node.Dummy]);
  if Assigned(vTree) then
  begin
    Node := vTree.FocusedNode;
    NodeData := nil;

    case vTree.GetNodeLevel(Node) of
      2: NodeData := vTree.GetNodeData(Node);
      3: NodeData := vTree.GetNodeData(Node.Parent);
    end;

    if Assigned(NodeData) then
      Designer.JumpTo(Component.InstanceIID, NodeData.ClassIID, NodeData.NormalText);
  end;
end;

procedure TibBTDependenciesForm.ShowDependencies;
var
  Node: PVirtualNode;
  NodeData, NodeDataOwner: PTreeRec;
  vTree: TVirtualStringTree;
  S: string;
begin
  Node := Tree.FocusedNode;
  NodeData := Tree.GetNodeData(Node);
  vTree := nil;
  if Assigned(Node) then vTree := TVirtualStringTree(FUsesList[Node.Dummy]);
  if Assigned(NodeData) then
  begin
    if IsEqualGUID(NodeData.ClassIID, IibSHField) then
    begin
      NodeDataOwner := Tree.GetNodeData(Node.Parent);
      S := NodeDataOwner.NormalText;
    end;
    try
      Screen.Cursor := crHourGlass;
      InitUsesArea(NodeData.ClassIID, NodeData.NormalText, S, vTree);
      vTree.BringToFront;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TibBTDependenciesForm.ClearDependencies;
var
  I: Integer;
begin
  NodeIDGenerator := 0;
  try
    Panel5.Visible := False;
    Tree.Clear;
    FUsesList.Clear;
    InsertNew(Component.ClassIID, Component.Caption, nil);
    if Supports(Component, IibSHTable) then
      for I := 0 to Pred((Component as IibSHTable).Fields.Count) do
        InsertNew(IibSHField, (Component as IibSHTable).Fields[I], Tree.GetFirst);
  finally
    Panel5.Visible := True;
  end;
  ShowDependencies;      
end;

procedure TibBTDependenciesForm.ExtractDependencies;
var
  Node: PVirtualNode;
  NodeData, NodeData2: PTreeRec;
  vTree: TVirtualStringTree;
begin
  vTree := nil;
  Node := Tree.FocusedNode;

  if Assigned(Node) then vTree := TVirtualStringTree(FUsesList[Node.Dummy]);
  if Assigned(vTree) then
  begin
    Node := vTree.FocusedNode;
    NodeData := nil;

    case vTree.GetNodeLevel(Node) of
      2: NodeData := vTree.GetNodeData(Node);
      3: NodeData := vTree.GetNodeData(Node.Parent);
    end;

    if Assigned(NodeData) then
    begin
      Node := Tree.FocusedNode.FirstChild;
      while Assigned(Node) do
      begin
        NodeData2 := Tree.GetNodeData(Node);
        if IsEqualGUID(NodeData2.ClassIID, NodeData.ClassIID) and
           (CompareStr(NodeData2.NormalText, NodeData.NormalText) = 0) then Break;
        Node := Tree.GetNextSibling(Node);
      end;
      if not Assigned(Node) then
      begin
        Tree.Expanded[Tree.FocusedNode] := True;
        Node := InsertNew(NodeData.ClassIID, NodeData.NormalText, Tree.FocusedNode);
        NodeData2 := Tree.GetNodeData(Node);
        NodeData2.U := NodeData.U;
      end;
      if Assigned(Node) then
      begin
        Tree.FocusedNode := Node;
        Tree.Selected[Tree.FocusedNode] := True;
        ShowDependencies;
      end;
    end;
  end;
end;

procedure TibBTDependenciesForm.RefreshDependencies;
begin
  TVirtualStringTree(FUsesList[Tree.FocusedNode.Dummy]).Clear;
  ShowDependencies;
end;
(*
procedure TibBTDependenciesForm.CheckDependencies;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
  vTree: TVirtualStringTree;
begin
  vTree := nil;
  try
    Screen.Cursor := crHourGlass;
    vTree := TVirtualStringTree(FUsesList[Tree.FocusedNode.Dummy]);
    Node := vTree.GetFirst;
    while Assigned(Node) do
    begin
      if vTree.GetNodeLevel(Node) = 2 then
      begin
        NodeData := vTree.GetNodeData(Node);
        Dependencies.Execute(dtUsedBy, (Component as IibSHDBObject).BTCLDatabase, NodeData.ClassIID, NodeData.NormalText);
        if Dependencies.IsEmpty then NodeData.IsEmpty := 1;
        Dependencies.Execute(dtUses, (Component as IibSHDBObject).BTCLDatabase, NodeData.ClassIID, NodeData.NormalText);
        if Dependencies.IsEmpty then NodeData.IsEmpty := 1;
      end;
      Node := vTree.GetNext(Node);
    end;
  finally
    Screen.Cursor := crDefault;
    if Assigned(vTree) then vTree.Invalidate;
  end;
end;
*)

procedure TibBTDependenciesForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  DoOnIdle;
end;

{ Tree }

procedure TibBTDependenciesForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibBTDependenciesForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibBTDependenciesForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if (Kind = ikNormal) or (Kind = ikSelected) then ImageIndex := Data.ImageIndex;
end;

procedure TibBTDependenciesForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  case TextType of
    ttNormal: CellText := Data.NormalText;
    ttStatic:
      begin
        if (Sender.Tag = 0) then
          case Data.U of
            0: CellText := '';
            1: CellText := 'Used By';
            2: CellText := 'Uses';
          end;
        if (Sender.Tag = 1) and (Node.ChildCount > 0) then CellText := Format('%d', [Node.ChildCount]);
      end;
  end;
end;

procedure TibBTDependenciesForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  case TextType of
    ttNormal: if Sender.Focused and (vsSelected in Node.States) then
                TargetCanvas.Font.Color := clWindow
              else
                if Data.IsEmpty = 1 then TargetCanvas.Font.Color := clGreen;
    ttStatic: if Sender.Focused and (vsSelected in Node.States) then
                TargetCanvas.Font.Color := clWindow
              else
                TargetCanvas.Font.Color := clGray;
  end;
end;

procedure TibBTDependenciesForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.NormalText)) <> 1 then
    Result := 1;
end;

procedure TibBTDependenciesForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    if TComponent(Sender).Tag = 1 then JumpToSource;
end;

procedure TibBTDependenciesForm.TreeDblClick(Sender: TObject);
var
  HT: THitInfo;
  P: TPoint;
begin
  GetCursorPos(P);
  P := Tree.ScreenToClient(P);
  Tree.GetHitTestInfoAt(P.X, P.Y, True, HT);
  if not (hiOnItemButton in HT.HitPositions) then
    if TComponent(Sender).Tag = 1 then JumpToSource;
end;

procedure TibBTDependenciesForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
var
  HT: THitInfo;
  Data: PTreeRec;
begin
  if not Enabled then Exit;
  PopupMenu := nil;
  Data := Sender.GetNodeData(Sender.FocusedNode);
  Sender.GetHitTestInfoAt(P.X, P.Y, True, HT);
  if Assigned(Data) and (Sender.GetNodeLevel(Sender.FocusedNode) = 0) and (HT.HitNode = Sender.FocusedNode) and (hiOnItemLabel in HT.HitPositions) then
    ;
end;

procedure TibBTDependenciesForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  Result := CompareStr(Data1.NormalText, Data2.NormalText);
end;

procedure TibBTDependenciesForm.TreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  ShowDependencies;
  ShowSource;
end;

procedure TibBTDependenciesForm.Panel1Resize(Sender: TObject);
begin
  Tree.Width := Tree.Parent.ClientWidth div 2;
end;

{ TibBTDependenciesFormAction_ }

constructor TibBTDependenciesFormAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;

  if Self is TibBTDependenciesFormAction_Run then Tag := 1;
  if Self is TibBTDependenciesFormAction_Refresh then Tag := 2;

  case Tag of
    0: Caption := '-'; // separator
    1:
    begin
      Caption := Format('%s', ['Run (Extract Dependencies)']);
      ShortCut := TextToShortCut('Ctrl+Enter');
      SecondaryShortCuts.Add('F9');      
    end;
    2:
    begin
      Caption := Format('%s', ['Refresh']);
      ShortCut := TextToShortCut('F5');
    end;
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibBTDependenciesFormAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDomain) or
            IsEqualGUID(AClassIID, IibSHTable) or
            //IsEqualGUID(AClassIID, IibSHConstraint) or
            //IsEqualGUID(AClassIID, IibSHIndex) or
            IsEqualGUID(AClassIID, IibSHView) or
            IsEqualGUID(AClassIID, IibSHProcedure) or
            IsEqualGUID(AClassIID, IibSHTrigger) or
            IsEqualGUID(AClassIID, IibSHGenerator) or
            IsEqualGUID(AClassIID, IibSHException) or
            IsEqualGUID(AClassIID, IibSHFunction) or
            IsEqualGUID(AClassIID, IibSHFilter) or
            //IsEqualGUID(AClassIID, IibSHRole) or
            IsEqualGUID(AClassIID, IibSHSystemDomain) or
            IsEqualGUID(AClassIID, IibSHSystemTable) or
            IsEqualGUID(AClassIID, IibSHSystemTableTmp);
end;

procedure TibBTDependenciesFormAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Refresh
    2: (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
  end;
end;

procedure TibBTDependenciesFormAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibBTDependenciesFormAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallDependencies) then
  begin
    case Tag of
      // Separator
      0:
      begin
        Visible := True;
      end;
      // Run
      1:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRun;
      end;
      // Refresh
      2:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRefresh;
      end;
    end;
  end else
    Visible := False;
end;

initialization

  Register;

(*
  if actShowSource.Checked then
  begin
    ShowMessageWindow;
    ShowSource;
  end else
    HideMessageWindow;
*)

end.
