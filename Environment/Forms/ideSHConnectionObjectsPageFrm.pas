unit ideSHConnectionObjectsPageFrm;

interface

uses
  SHDesignIntf, ideSHDesignIntf, ideSHObject,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, VirtualTrees, ExtCtrls, Menus, StdCtrls, ToolWin, TypInfo,
  ImgList, AppEvnts, StrUtils, Grids, ELPropInsp;

type
  TideSHSchemeMode = (smAll, smSystem, smFilter);

  TideSHSchemeFilter = class(TComponent)
  private
    FActive: Boolean;
    FCombo: TComboBox;
    FTree: TVirtualStringTree;
    procedure SetActive(Value: Boolean);
    procedure SetCombo(Value: TComboBox);

    procedure ComboChange(Sender: TObject);
    procedure ComboKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure Apply;
    procedure Cancel;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Match(const ASource: string): Boolean;

    property Active: Boolean read FActive write SetActive;
    property Combo: TComboBox read FCombo write SetCombo;
    property Tree: TVirtualStringTree read FTree write FTree;
  end;


  TConnectionObjectsPageForm = class(TSHComponentForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    tsScheme: TTabSheet;
    Bevel1: TBevel;
    Panel2: TPanel;
    VirtualStringTree1: TVirtualStringTree;
    tsSystem: TTabSheet;
    Bevel2: TBevel;
    Panel3: TPanel;
    VirtualStringTree2: TVirtualStringTree;
    tsFilter: TTabSheet;
    Bevel3: TBevel;
    Panel4: TPanel;
    VirtualStringTree3: TVirtualStringTree;
    ToolBar1: TToolBar;
    ComboBox1: TComboBox;
    Bevel7: TBevel;
    PopupMenu1: TPopupMenu;
    est1: TMenuItem;
    ImageList1: TImageList;
    ToolBar2: TToolBar;
    Bevel8: TBevel;
    ToolBar3: TToolBar;
    Bevel9: TBevel;
    Timer1: TTimer;
    tsInfo: TTabSheet;
    Panel8: TPanel;
    PropInspector: TELPropertyInspector;
    Bevel12: TBevel;
    procedure ToolBar1Resize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PropInspectorFilterProp(Sender: TObject;
      AInstance: TPersistent; APropInfo: PPropInfo;
      var AIncludeProp: Boolean);
    procedure PropInspectorGetEditorClass(Sender: TObject;
      AInstance: TPersistent; APropInfo: PPropInfo;
      var AEditorClass: TELPropEditorClass);
  private
    { Private declarations }
    FPageFlatness: TideBTObject;
    FSchemeFilter: TideSHSchemeFilter;
    FSchemeNameList: TStrings;
    FSystemNameList: TStrings;
    function GetItemIndex: Integer;
    procedure SetItemIndex(Value: Integer);
    function GetConnection: ISHRegistration;

    procedure PageCtrlChange(Sender: TObject);
    procedure SetPageCtrl(APageCtrl: TPageControl);

    procedure DoShowProps(AInspector: TELPropertyInspector; APersistent: TPersistent);

    procedure SaveCurrentName(ASchemeMode: TideSHSchemeMode);
    procedure LoadCurrentName(ASchemeMode: TideSHSchemeMode; const AClassIID: TGUID);

    procedure ButtonSchemeFilterClick(Sender: TObject);
    procedure ButtonSystemFilterClick(Sender: TObject);
    procedure ButtonSchemeExpandClick(Sender: TObject);
    procedure ButtonSystemExpandClick(Sender: TObject);
    procedure ButtonSchemeArrowClick(Sender: TObject);
    procedure ButtonSystemArrowClick(Sender: TObject);

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
    procedure TreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeDblClick(Sender: TObject);
    procedure TreeGetPopupMenu(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
      var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure TreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure TreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
      Column: TColumnIndex; var Result: Integer);
    procedure TreeGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
    procedure TreeDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);

  protected
    procedure DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure BringToTop; override;

    procedure PrepareControls;
    procedure PrepareInfo;

    procedure LoadSchemeObjectsFromConnection(ASchemeMode: TideSHSchemeMode = smAll; BuildButtons: Boolean = True);
    procedure LoadObjectInIDE;
    function SynchronizeObjects(const AClassIID: TGUID;
      const ACaption: string; Operation: TOperation): Boolean;

    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property Connection: ISHRegistration read GetConnection;
    property SchemeFilter: TideSHSchemeFilter read FSchemeFilter;
  end;

var
  ConnectionObjectsPageForm: TConnectionObjectsPageForm;

implementation

uses
  ideSHConsts, ideSHSystem, ideSHSysUtils, ideSHStrUtil, ideSHProxiPropEditors;

{$R *.dfm}

type
  TNodeType = (ntFolder, ntServer, ntDatabase, ntObject);
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    NormalText: string;
    StaticText: string;
    Component: TSHComponent;
    ImageIndex: Integer;
    NodeType: TNodeType;
    ClassIID: TGUID;
    FavoriteObjectColor: TColor;
  end;
{
type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    NormalText: string;
    StaticText: string;

    ComponentClass: TSHComponentClass;
    Component: TSHComponent;
    ImageIndex: Integer;
    FilterCount: Integer;
  end;
}

{ TideSHSchemeFilter }

constructor TideSHSchemeFilter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TideSHSchemeFilter.Destroy;
var
  NavigatorNotify: ISHNavigatorNotify;
  I: Integer;
begin
  if Supports((Owner as TConnectionObjectsPageForm).Connection, ISHNavigatorNotify, NavigatorNotify) then
  begin
    NavigatorNotify.FilterList.Clear;
    for I := 0 to Pred(Combo.Items.Count) do
    begin
      NavigatorNotify.FilterList.Add(Combo.Items[I]);
      if NavigatorNotify.FilterList.Count = 15 then Break;
    end;
  end;
  inherited Destroy;
end;

procedure TideSHSchemeFilter.SetActive(Value: Boolean);
begin
  FActive := Value;
  if FActive then
  begin
    if Length(Combo.Text) > 0 then Apply else Cancel;
  end else
    Cancel;
end;

procedure TideSHSchemeFilter.SetCombo(Value: TComboBox);
var
  NavigatorNotify: ISHNavigatorNotify;
begin
  FCombo := Value;
  if Assigned(FCombo) then
  begin
    FCombo.ItemIndex := -1;
    FCombo.Text := EmptyStr;
    FCombo.OnChange := ComboChange;
    FCombo.OnKeyDown := ComboKeyDown;
    if Supports((Owner as TConnectionObjectsPageForm).Connection, ISHNavigatorNotify, NavigatorNotify) then
      Combo.Items.Assign(NavigatorNotify.FilterList);
    if Combo.Items.Count = 0 then Combo.Items.Add('%');
  end;
end;

procedure TideSHSchemeFilter.ComboChange(Sender: TObject);
begin
  if Length(Combo.Text) > 0 then Combo.Color := clInfoBk else Cancel;
end;

procedure TideSHSchemeFilter.ComboKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN: Active := True;
    VK_ESCAPE: Active := False;
  end;
end;

procedure TideSHSchemeFilter.Apply;
var
  S: string;
begin
  (Owner as TConnectionObjectsPageForm).LoadSchemeObjectsFromConnection(smFilter);

  if Assigned(Combo) then
  begin
    Combo.Color := clSkyBlue;
    S := Combo.Text;
    if Length(S) = 0 then
    begin
      Combo.Color := clWindow;
      Exit;
    end;
    if Combo.Items.IndexOf(S) <> -1 then Combo.Items.Delete(Combo.Items.IndexOf(S));
    Combo.Text := S;
    Combo.Items.Insert(0, S);
    Combo.Color := clSkyBlue;
  end;

  if (Owner as TConnectionObjectsPageForm).VirtualStringTree3.CanFocus then
    (Owner as TConnectionObjectsPageForm).VirtualStringTree3.SetFocus;
end;

procedure TideSHSchemeFilter.Cancel;
begin
  if Assigned(Combo) then
  begin
    Combo.Color := clWindow;  
    Combo.ItemIndex := -1;
    Combo.Text := EmptyStr;
  end;
  if Assigned(Tree) then Tree.Clear;
end;

function TideSHSchemeFilter.Match(const ASource: string): Boolean;
begin
  Result := Active;
  if Result then
  begin
    if AnsiContainsText(AnsiUpperCase(Combo.Text), '%') then
      Result := ideSHStrUtil.SQLMaskCompare(AnsiUpperCase(ASource), AnsiUpperCase(Combo.Text))
    else
      Result := AnsiStartsText(AnsiUpperCase(Combo.Text), AnsiUpperCase(ASource));
  end;
end;

{ TConnectionObjectsPageForm }

constructor TConnectionObjectsPageForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);

  SetPageCtrl(PageControl1);

  SetTreeEvents(VirtualStringTree1);
  SetTreeEvents(VirtualStringTree2);
  SetTreeEvents(VirtualStringTree3);

  FSchemeFilter := TideSHSchemeFilter.Create(Self);
  FSchemeFilter.Combo := ComboBox1;
  FSchemeFilter.Tree := VirtualStringTree3;
  FSchemeNameList := TStringList.Create;
  FSystemNameList := TStringList.Create;
  (FSchemeNameList as TStringList).Sorted := True;
  (FSystemNameList as TStringList).Sorted := True;

  PrepareControls;
  
  if Assigned(ModalForm) then
  begin
    Caption := Format(ACallString, [Component.Caption]);
    ModalForm.OnAfterModalClose := DoOnAfterModalClose;
    LoadSchemeObjectsFromConnection;
  end;
end;

destructor TConnectionObjectsPageForm.Destroy;
begin
  FSchemeFilter.Free;
  FSchemeNameList.Free;
  FSystemNameList.Free;
  inherited Destroy;
end;

procedure TConnectionObjectsPageForm.BringToTop;
begin
  BringToFront;
  ItemIndex := ItemIndex;
end;

procedure TConnectionObjectsPageForm.DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult);
begin
  if ModalResult = mrOK then LoadObjectInIDE;
end;

function TConnectionObjectsPageForm.GetItemIndex: Integer;
begin
  Result := PageControl1.ActivePageIndex;
end;

procedure TConnectionObjectsPageForm.SetItemIndex(Value: Integer);
begin
  if FPageFlatness.PageCtrl.ActivePageIndex <> Value then
    FPageFlatness.PageCtrl.ActivePageIndex := Value;

  case FPageFlatness.PageCtrl.ActivePageIndex of
    0: if VirtualStringTree1.CanFocus then VirtualStringTree1.SetFocus;
    1: if VirtualStringTree2.CanFocus then VirtualStringTree2.SetFocus;
    2: if VirtualStringTree3.CanFocus then VirtualStringTree3.SetFocus;
    3: ;
  end;
end;

function TConnectionObjectsPageForm.GetConnection: ISHRegistration;
begin
  Supports(Component, ISHRegistration, Result);
end;

procedure TConnectionObjectsPageForm.PageCtrlChange(Sender: TObject);
begin
  ItemIndex := (Sender as TPageControl).ActivePageIndex;
end;

procedure TConnectionObjectsPageForm.SetPageCtrl(APageCtrl: TPageControl);
begin
  FPageFlatness := TideBTObject.Create(Self);
  FPageFlatness.PageCtrl := APageCtrl;
  FPageFlatness.Flat := True;
  FPageFlatness.PageCtrl.OnChange := PageCtrlChange;
end;

procedure TConnectionObjectsPageForm.DoShowProps(AInspector: TELPropertyInspector;
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

procedure TConnectionObjectsPageForm.SaveCurrentName(ASchemeMode: TideSHSchemeMode);
var
  Tree: TVirtualStringTree;
  Node: PVirtualNode;
  NodeData: PTreeRec;
  S: string;
  I: Integer;
  NameList: TStrings;
begin
  Tree := nil;
  NameList := nil;

  case ASchemeMode of
    smAll: Tree := VirtualStringTree1;
    smSystem: Tree := VirtualStringTree1;
  end;

  case ASchemeMode of
    smAll: NameList := FSchemeNameList;
    smSystem: NameList := FSystemNameList;
  end;

  if Assigned(Tree) then
  begin
    Node := Tree.FocusedNode;
    if Assigned(Node) then NodeData := Tree.GetNodeData(Node);
    if Assigned(NodeData) and (NodeData.NodeType = ntObject) then
      S := Format('%s=%s', [GUIDToString(NodeData.ClassIID), NodeData.NormalText])
    else
      Exit;
  end;
  
  if Assigned(NameList) then
  begin
    I := NameList.IndexOfName(GUIDToString(NodeData.ClassIID));
    if I <> -1 then NameList.Delete(I);
    NameList.Add(S);
  end;
end;

procedure TConnectionObjectsPageForm.LoadCurrentName(ASchemeMode: TideSHSchemeMode;
  const AClassIID: TGUID);
var
  Tree: TVirtualStringTree;
  Node: PVirtualNode;
  NodeData: PTreeRec;
  S: string;
  I: Integer;
  NameList: TStrings;
begin
  Tree := nil;
  NameList := nil;

  case ASchemeMode of
    smAll: Tree := VirtualStringTree1;
    smSystem: Tree := VirtualStringTree1;
  end;

  case ASchemeMode of
    smAll: NameList := FSchemeNameList;
    smSystem: NameList := FSystemNameList;
  end;

  if Assigned(NameList) then
  begin
    S := Format('%s', [GUIDToString(AClassIID)]);
    I := NameList.IndexOfName(S);
    if I <> -1 then S := NameList.ValueFromIndex[I];
  end;

  if Assigned(Tree) then
  begin
    Node := Tree.GetFirst;
    while Assigned(Node) do
    begin
      if Node.ChildCount > 0 then Tree.Expanded[Node] := False;
      Node := Tree.GetNextSibling(Node);
    end;

    Node := Tree.GetFirst;
    while Assigned(Node) do
    begin
      NodeData := Tree.GetNodeData(Node);
      if Assigned(NodeData) and AnsiSameStr(NodeData.NormalText, S) and
        (NodeData.NodeType = ntObject) then
      begin
        Tree.FocusedNode := Node;
        if Assigned(Tree.FocusedNode) then Tree.Selected[Tree.FocusedNode] := True;
  //      Tree.Expanded[Tree.FocusedNode] := True;
        Break;
      end;
      Node := Tree.GetNext(Node);
    end;
  end;
end;

procedure TConnectionObjectsPageForm.ButtonSchemeFilterClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
  Node: PVirtualNode;
  NodeData: PTreeRec;
  I: Integer;
  vClassIID: TGUID;
  NavigatorNotifyIntf: ISHNavigatorNotify;
begin
  Tree := VirtualStringTree1;
  Tree.Indent := 2;
  Supports(Connection, ISHNavigatorNotify, NavigatorNotifyIntf);
  vClassIID := StringToGUID((Sender as TToolButton).HelpKeyword);
  SaveCurrentName(smAll);
//  Tree := VirtualStringTree2;
//  SchemeObjects.Assign(Connection.GetSchemeClassIIDList(True));

  try
    Tree.BeginUpdate;
    Tree.Clear;
    for I := 0 to Pred(Connection.GetObjectNameList(vClassIID).Count) do
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.NormalText := Connection.GetObjectNameList(vClassIID)[I];
      NodeData.StaticText := EmptyStr; // Description?
      NodeData.ClassIID := vClassIID;
      NodeData.ImageIndex := Designer.GetImageIndex(vClassIID);
      NodeData.NodeType := ntObject;
      NodeData.FavoriteObjectColor := Tree.Font.Color;
      if Assigned(NavigatorNotifyIntf) and
         (NavigatorNotifyIntf.FavoriteObjectNames.IndexOf(NodeData.NormalText) <> -1) then
         NodeData.FavoriteObjectColor := NavigatorNotifyIntf.FavoriteObjectColor;
    end;
    Tree.Sort(Node, 0, sdAscending);
  finally
    Tree.EndUpdate;
  end;

  Tree.FocusedNode := Tree.GetFirst;
  if Assigned(Tree.FocusedNode) then Tree.Selected[Tree.FocusedNode] := True;
  LoadCurrentName(smAll, vClassIID);
  if Tree.CanFocus then Tree.SetFocus;
end;

procedure TConnectionObjectsPageForm.ButtonSystemFilterClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
  Node: PVirtualNode;
  NodeData: PTreeRec;
  I: Integer;
  vClassIID: TGUID;
  NavigatorNotifyIntf: ISHNavigatorNotify;
begin
  Tree := VirtualStringTree2;
  Tree.Indent := 2;
  Supports(Connection, ISHNavigatorNotify, NavigatorNotifyIntf);
  vClassIID := StringToGUID((Sender as TToolButton).HelpKeyword);
  SaveCurrentName(smSystem);
  try
    Tree.BeginUpdate;
    Tree.Clear;
    for I := 0 to Pred(Connection.GetObjectNameList(vClassIID).Count) do
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.NormalText := Connection.GetObjectNameList(vClassIID)[I];
      NodeData.StaticText := EmptyStr; // Description?
      NodeData.ClassIID := vClassIID;
      NodeData.ImageIndex := Designer.GetImageIndex(vClassIID);
      NodeData.NodeType := ntObject;
      NodeData.FavoriteObjectColor := Tree.Font.Color;
      if Assigned(NavigatorNotifyIntf) and
         (NavigatorNotifyIntf.FavoriteObjectNames.IndexOf(NodeData.NormalText) <> -1) then
         NodeData.FavoriteObjectColor := NavigatorNotifyIntf.FavoriteObjectColor;
    end;
    Tree.Sort(Node, 0, sdAscending);
  finally
    Tree.EndUpdate;
  end;

  Tree.FocusedNode := Tree.GetFirst;
  if Assigned(Tree.FocusedNode) then Tree.Selected[Tree.FocusedNode] := True;
  LoadCurrentName(smSystem, vClassIID);
  if Tree.CanFocus then Tree.SetFocus;
end;

procedure TConnectionObjectsPageForm.ButtonSchemeExpandClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Tree := VirtualStringTree1;
  Node := Tree.GetFirst;

  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    if Node.ChildCount > 0 then Tree.Expanded[Node] := False;
    Node := Tree.GetNextSibling(Node);
  end;
  
  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    NodeData := Tree.GetNodeData(Node);
    if Assigned(NodeData) and AnsiSameStr(NodeData.NormalText, (Sender as TToolButton).Caption) and
      (NodeData.NodeType = ntFolder) then
    begin
      Tree.FocusedNode := Node;
      if Assigned(Tree.FocusedNode) then Tree.Selected[Tree.FocusedNode] := True;
      Tree.Expanded[Tree.FocusedNode] := True;
      Break;
    end;
    Node := Tree.GetNextSibling(Node);
  end;
  if Tree.CanFocus then Tree.SetFocus;
end;

procedure TConnectionObjectsPageForm.ButtonSystemExpandClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Tree := VirtualStringTree2;
  Node := Tree.GetFirst;

  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    if Node.ChildCount > 0 then Tree.Expanded[Node] := False;
    Node := Tree.GetNextSibling(Node);
  end;

  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    NodeData := Tree.GetNodeData(Node);
    if Assigned(NodeData) and AnsiSameStr(NodeData.NormalText, (Sender as TToolButton).Caption) and
      (NodeData.NodeType = ntFolder) then
    begin
      Tree.FocusedNode := Node;
      if Assigned(Tree.FocusedNode) then Tree.Selected[Tree.FocusedNode] := True;
      Tree.Expanded[Tree.FocusedNode] := True;
      Break;
    end;
    Node := Tree.GetNextSibling(Node);
  end;
  if Tree.CanFocus then Tree.SetFocus;  
end;

procedure TConnectionObjectsPageForm.ButtonSchemeArrowClick(Sender: TObject);
var
  I: Integer;
  ToolButton: TToolButton;
  ToolBar: TToolBar;
begin
  ToolButton := Sender as TToolButton;
  ToolBar := ToolButton.Parent as TToolbar;
  for I := 0 to Pred(ToolBar.ButtonCount) do
    if ToolButton <> ToolBar.Buttons[I] then
      if ToolButton.Down then
      begin
        ToolBar.Buttons[I].Grouped := True;
        ToolBar.Buttons[I].Style := tbsCheck;
        ToolBar.Buttons[I].Hint := Format('Show Only %s', [ToolBar.Buttons[I].Caption]);
        ToolBar.Buttons[I].OnClick := ButtonSchemeFilterClick;
      end else
      begin
        ToolBar.Buttons[I].Down := False;
        ToolBar.Buttons[I].Grouped := False;
        ToolBar.Buttons[I].Style := tbsButton;
        ToolBar.Buttons[I].Hint := Format('Expand %s Node', [ToolBar.Buttons[I].Caption]);
        ToolBar.Buttons[I].OnClick := ButtonSchemeExpandClick;
      end;

  FSchemeNameList.Clear;
  Timer1.Enabled := True;
end;

procedure TConnectionObjectsPageForm.ButtonSystemArrowClick(Sender: TObject);
var
  I: Integer;
  ToolButton: TToolButton;
  ToolBar: TToolBar;
begin
  ToolButton := Sender as TToolButton;
  ToolBar := ToolButton.Parent as TToolbar;
  for I := 0 to Pred(ToolBar.ButtonCount) do
    if ToolButton <> ToolBar.Buttons[I] then
      if ToolButton.Down then
      begin
        ToolBar.Buttons[I].Grouped := True;
        ToolBar.Buttons[I].Style := tbsCheck;
        ToolBar.Buttons[I].Hint := Format('Show Only %s', [ToolBar.Buttons[I].Caption]);
        ToolBar.Buttons[I].OnClick := ButtonSystemFilterClick;
      end else
      begin
        ToolBar.Buttons[I].Down := False;
        ToolBar.Buttons[I].Grouped := False;
        ToolBar.Buttons[I].Style := tbsButton;
        ToolBar.Buttons[I].Hint := Format('Expand %s Node', [ToolBar.Buttons[I].Caption]);
        ToolBar.Buttons[I].OnClick := ButtonSystemExpandClick;
      end;

  FSystemNameList.Clear;
  Timer1.Enabled := True;
end;

procedure TConnectionObjectsPageForm.PrepareControls;
begin
  if Supports(Component, ISHServer) then
  begin
    tsScheme.TabVisible := False;
    tsSystem.TabVisible := False;
    tsFilter.TabVisible := False;
    tsInfo.TabVisible := True;
  end;

  if Supports(Component, ISHDatabase) then
  begin
    tsScheme.TabVisible := Connection.Connected;
    tsSystem.TabVisible := Connection.Connected;
    tsFilter.TabVisible := Connection.Connected;
    tsInfo.TabVisible := True;
  end;

  if Connection.Connected then
  begin
    if Supports(Component, ISHDatabase) then
      ItemIndex := 0;
  end else
  begin
    while ToolBar2.ButtonCount <> 0 do ToolBar2.Buttons[0].Free;
    while ToolBar3.ButtonCount <> 0 do ToolBar3.Buttons[0].Free;
    VirtualStringTree1.Clear;
    VirtualStringTree2.Clear;
    VirtualStringTree3.Clear;
  end;
end;

procedure TConnectionObjectsPageForm.PrepareInfo;
begin
  DoShowProps(PropInspector, Component);
end;

procedure TConnectionObjectsPageForm.LoadSchemeObjectsFromConnection(ASchemeMode: TideSHSchemeMode = smAll; BuildButtons: Boolean = True);
var
  Tree: TVirtualStringTree;
  Node, Node2: PVirtualNode;
  NodeData, NodeData2: PTreeRec;
  I, J: Integer;

  CurrentNode: PVirtualNode;
  CurrentNodeData: PTreeRec;
  CurrentClassIID: TGUID;
  CurrentName: string;

  SchemeObjects: TStrings;

  NavigatorNotifyIntf: ISHNavigatorNotify;
begin
  Tree := VirtualStringTree1;
  Tree.Indent := 12;
  SchemeObjects := TStringList.Create;
  SchemeObjects.Assign(Connection.GetSchemeClassIIDList);

  if ASchemeMode = smSystem then
  begin
    Tree := VirtualStringTree2;
    Tree.Indent := 12;
    SchemeObjects.Assign(Connection.GetSchemeClassIIDList(True));
  end;

  if ASchemeMode = smFilter then
  begin
    Tree := VirtualStringTree3;
    SchemeObjects.Assign(Connection.GetSchemeClassIIDList);
  end;


  CurrentNode := Tree.FocusedNode;
  if Assigned(CurrentNode) then
  begin
    CurrentNodeData := Tree.GetNodeData(CurrentNode);
    if Assigned(CurrentNodeData) then
    begin
      CurrentClassIID := CurrentNodeData.ClassIID;
      CurrentName := CurrentNodeData.NormalText;
    end;
  end;

  Supports(Connection, ISHNavigatorNotify, NavigatorNotifyIntf);

  if BuildButtons then
  begin
    ToolBar2.Images := Designer.ImageList;
    ToolBar3.Images := Designer.ImageList;

    if ASchemeMode <> smSystem then
      while ToolBar2.ButtonCount <> 0 do ToolBar2.Buttons[0].Free;
    if ASchemeMode = smSystem then
      while ToolBar3.ButtonCount <> 0 do ToolBar3.Buttons[0].Free;

    for I := Pred(SchemeObjects.Count) downto 0 do
    begin
      if ASchemeMode <> smSystem then
        with TToolButton.Create(ToolBar2) do
        begin
          Parent := ToolBar2;
          Caption := GetHintRightPart(SchemeObjects[I]);
          Grouped := True;
          Style := tbsCheck;
          Hint := Format('Show Only %s', [Caption]);
          ImageIndex := Designer.GetImageIndex(StringToGUID(GetHintLeftPart(SchemeObjects[I])));
          ShowHint := True;
          HelpKeyword := GetHintLeftPart(SchemeObjects[I]);
          OnClick := ButtonSchemeFilterClick;
        end;

      if ASchemeMode = smSystem then
        with TToolButton.Create(ToolBar3) do
        begin
          Parent := ToolBar3;
          Caption := GetHintRightPart(SchemeObjects[I]);
          Grouped := True;
          Style := tbsCheck;
          Hint := Format('Show Only %s', [Caption]);
          ImageIndex := Designer.GetImageIndex(StringToGUID(GetHintLeftPart(SchemeObjects[I])));
          ShowHint := True;
          HelpKeyword := GetHintLeftPart(SchemeObjects[I]);
          OnClick := ButtonSystemFilterClick;
        end;
    end;

    if ASchemeMode <> smSystem then
    begin
      with TToolButton.Create(ToolBar2) do
      begin
        Parent := ToolBar2;
        Hint := Format('%s', ['Filter Mode']);
        ImageIndex := 27;
        AllowAllUp := True;
        Style := tbsCheck;
        Down := True;
        ShowHint := True;
        OnClick := ButtonSchemeArrowClick;
      end;
    end;

    if ASchemeMode = smSystem then
    begin
      with TToolButton.Create(ToolBar3) do
      begin
        Parent := ToolBar3;
        Hint := Format('%s', ['Filter Mode']);
        ImageIndex := 27;
        AllowAllUp := True;
        Style := tbsCheck;
        Down := True;
        ShowHint := True;
        OnClick := ButtonSystemArrowClick;
      end;
    end;
  end;

  try
    Tree.BeginUpdate;
    Tree.Clear;
    for I := 0 to Pred(SchemeObjects.Count) do
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.NormalText := GetHintRightPart(SchemeObjects[I]);
      NodeData.StaticText := EmptyStr;
      NodeData.ClassIID := StringToGUID(GetHintLeftPart(SchemeObjects[I]));
      NodeData.ImageIndex  := Designer.GetImageIndex(NodeData.ClassIID);
      NodeData.NodeType := ntFolder;
      NodeData.FavoriteObjectColor := Tree.Font.Color;
      for J := 0 to Pred(Connection.GetObjectNameList(NodeData.ClassIID).Count) do
      begin
        if (ASchemeMode = smFilter) and not SchemeFilter.Match(Connection.GetObjectNameList(NodeData.ClassIID)[J]) then Continue;
        Node2 := Tree.AddChild(Node);
        NodeData2 := Tree.GetNodeData(Node2);
        NodeData2.NormalText := Connection.GetObjectNameList(NodeData.ClassIID)[J];
        NodeData2.StaticText := EmptyStr; // Description?
        NodeData2.ClassIID := NodeData.ClassIID;
        NodeData2.ImageIndex := NodeData.ImageIndex;
        NodeData2.NodeType := ntObject;
        NodeData2.FavoriteObjectColor := Tree.Font.Color;
        if Assigned(NavigatorNotifyIntf) and
           (NavigatorNotifyIntf.FavoriteObjectNames.IndexOf(NodeData2.NormalText) <> -1) then
           NodeData2.FavoriteObjectColor := NavigatorNotifyIntf.FavoriteObjectColor;
      end;
      Tree.Sort(Node, 0, sdAscending);
    end;
  finally
    Tree.EndUpdate;
    SchemeObjects.Free;
  end;

  if ASchemeMode = smFilter then
  begin
    Node := Tree.GetFirst;
    while Assigned(Node) do
    begin
      NodeData := Tree.GetNodeData(Node);
      if Assigned(NodeData) and (NodeData.NodeType = ntFolder) then
        Tree.IsVisible[Node] := (Node.ChildCount > 0);
      Node := Tree.GetNextSibling(Node);
    end;
  end;

  if Assigned(CurrentNode) then
  begin
    Node := Tree.GetFirst;
    while Assigned(Node) do
    begin
      NodeData := Tree.GetNodeData(Node);
      if Assigned(NodeData) then
      begin
        if IsEqualGUID(NodeData.ClassIID, CurrentClassIID) and (NodeData.NormalText = CurrentName) then
          Break;
      end;
      Node := Tree.GetNext(Node);
    end;

    if Assigned(Node) then
    begin
      if Assigned(Node.Parent) then Tree.Expanded[Node.Parent] := True;
      Tree.FocusedNode := Node;
    end;
  end else
    Tree.FocusedNode := Tree.GetFirst;

  if Assigned(Tree.FocusedNode) then Tree.Selected[Tree.FocusedNode] := True;

  if ASchemeMode = smAll then
  begin
    LoadSchemeObjectsFromConnection(smSystem);
    if SchemeFilter.Active then LoadSchemeObjectsFromConnection(smFilter);
  end;

  if Tree.CanFocus then Tree.SetFocus;
end;

procedure TConnectionObjectsPageForm.LoadObjectInIDE;
var
  Tree: TVirtualStringTree;
  NodeData: PTreeRec;
begin
  Tree := nil;
  case ItemIndex of
    0: Tree := VirtualStringTree1;
    1: Tree := VirtualStringTree2;
    2: Tree := VirtualStringTree3;
  end;
  if Assigned(Tree) then
  begin
    NodeData := Tree.GetNodeData(Tree.FocusedNode);
    if Assigned(NodeData) and (NodeData.NodeType = ntObject) then
      Designer.CreateComponent(Component.InstanceIID, NodeData.ClassIID, NodeData.NormalText);
  end;
end;

function TConnectionObjectsPageForm.SynchronizeObjects(const AClassIID: TGUID;
  const ACaption: string; Operation: TOperation): Boolean;
var
  Tree: TVirtualStringTree;
  Node, NodeNew: PVirtualNode;
  NodeData, NodeDataNew: PTreeRec;
begin
  Tree := VirtualStringTree1;
  Result := False;
  case Operation of
    opInsert:
      begin
        Node := Tree.GetFirst;
        while Assigned(Node) do
        begin
          NodeData := Tree.GetNodeData(Node);
          if Assigned(NodeData) and IsEqualGUID(NodeData.ClassIID, AClassIID) and
            (CompareStr(NodeData.NormalText, ACaption) = 0) and (NodeData.NodeType = ntObject) then
          begin
            Result := True;
            Tree.FocusedNode := Node;
            if Assigned(Tree.FocusedNode) then Tree.Selected[Tree.FocusedNode] := True;
            Break;
          end;
          Node := Tree.GetNext(Node);
        end;

        Node := Tree.GetFirst;
        if not Result then
        begin
          while Assigned(Node) do
          begin
            NodeData := Tree.GetNodeData(Node);
            if Assigned(NodeData) and IsEqualGUID(NodeData.ClassIID, AClassIID) and
               (NodeData.NodeType = ntFolder) then
            begin
              NodeNew := Tree.AddChild(Node);
              NodeDataNew := Tree.GetNodeData(NodeNew);
              NodeDataNew.NormalText := ACaption;
              NodeDataNew.StaticText := EmptyStr;
              NodeDataNew.ClassIID := AClassIID;
              NodeDataNew.ImageIndex := NodeData.ImageIndex;
              NodeDataNew.NodeType := ntObject;
              Tree.Sort(Node, 0, sdAscending);
              Result := True;
              Break;
            end;
            Node := Tree.GetNext(Node);
          end;
        end;
      end;
    opRemove:
      begin
        Node := Tree.GetFirst;
        while Assigned(Node) do
        begin
          NodeData := Tree.GetNodeData(Node);
          if Assigned(NodeData) and IsEqualGUID(NodeData.ClassIID, AClassIID) and
            (CompareStr(NodeData.NormalText, ACaption) = 0) and (NodeData.NodeType = ntObject) then
          begin
            if Tree.FocusedNode = Node then
            begin
              NodeNew := Node.PrevSibling;
              if not Assigned(NodeNew) then NodeNew := Node.Parent;
            end;
            Tree.DeleteNode(Node);
            Result := True;
            Break;
          end;
          Node := Tree.GetNext(Node);
        end;
      end;
  end;
end;

procedure TConnectionObjectsPageForm.ToolBar1Resize(Sender: TObject);
begin
  ComboBox1.Width := ComboBox1.Parent.ClientWidth;
end;

procedure TConnectionObjectsPageForm.Timer1Timer(Sender: TObject);
begin
  try
    case ItemIndex of
      0: LoadSchemeObjectsFromConnection(smAll, False);
      1: LoadSchemeObjectsFromConnection(smSystem, False);
    end;
  finally
    (Sender as TTimer).Enabled := False;
  end;
end;

{ Tree }

procedure TConnectionObjectsPageForm.SetTreeEvents(ATree: TVirtualStringTree);
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
  ATree.OnFocusChanged := TreeFocusChanged;
  ATree.OnCompareNodes := TreeCompareNodes;
  ATree.OnGetHint := TreeGetHint;
  ATree.OnDragAllowed := TreeDragAllowed
end;

procedure TConnectionObjectsPageForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TConnectionObjectsPageForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);
  if Assigned(NodeData) then Finalize(NodeData^);
end;

procedure TConnectionObjectsPageForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);
  ImageIndex := -1;

  if Assigned(NodeData) then
  begin
    if (Kind = ikNormal) or (Kind = ikSelected) then
      ImageIndex := NodeData.ImageIndex;
  end;
end;

procedure TConnectionObjectsPageForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);

  if Assigned(NodeData) then
  begin
    case TextType of
      ttNormal: if Assigned(NodeData.Component) then
                  CellText := NodeData.Component.Caption
                else
                  CellText := NodeData.NormalText;
      ttStatic: if Node.ChildCount > 0 then
                  CellText := Format('%d', [Node.ChildCount])
                else
                  CellText := EmptyStr;
    end;
  end;
end;

procedure TConnectionObjectsPageForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);

  if Assigned(NodeData) then
  begin
    case TextType of
      ttNormal: begin
                  if Node.ChildCount <> 0 then TargetCanvas.Font.Style := [fsBold];

                  case ItemIndex of
                    0, 1: begin
                           if Sender.Focused and (vsSelected in Node.States) then
                             TargetCanvas.Font.Color := clWindow
                           else
                             TargetCanvas.Font.Color := NodeData.FavoriteObjectColor;
                          end;
                    2:;
                  end;
                end;
      ttStatic: if Sender.Focused and (vsSelected in Node.States) then
                  TargetCanvas.Font.Color := clWindow
                else
                  TargetCanvas.Font.Color := clGray;
    end;
  end;
end;

procedure TConnectionObjectsPageForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);
  (Sender as TVirtualStringTree).TreeOptions.SelectionOptions := (Sender as TVirtualStringTree).TreeOptions.SelectionOptions + [toCenterScrollIntoView];
  if Assigned(NodeData) then
  begin
    if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(NodeData.NormalText)) <> 1 then
      Result := 1;
  end;
end;

procedure TConnectionObjectsPageForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  (Sender as TVirtualStringTree).TreeOptions.SelectionOptions := (Sender as TVirtualStringTree).TreeOptions.SelectionOptions - [toCenterScrollIntoView];
  if Key = VK_RETURN then LoadObjectInIDE;
end;

procedure TConnectionObjectsPageForm.TreeDblClick(Sender: TObject);
var
  HT: THitInfo;
  P: TPoint;
  NodeData: PTreeRec;
begin
  GetCursorPos(P);
  if Assigned(TBaseVirtualTree(Sender).FocusedNode) then
  begin
    NodeData := TBaseVirtualTree(Sender).GetNodeData(TBaseVirtualTree(Sender).FocusedNode);
    P := TBaseVirtualTree(Sender).ScreenToClient(P);
    TBaseVirtualTree(Sender).GetHitTestInfoAt(P.X, P.Y, True, HT);
    if (HT.HitNode = TBaseVirtualTree(Sender).FocusedNode) and not (hiOnItemButton in HT.HitPositions) then
    begin
      if Assigned(ModalForm) then
      begin
        if Assigned(NodeData) and (NodeData.NodeType = ntObject) then
          ModalForm.ModalResultCode := mrOK
      end else
        LoadObjectInIDE
    end;
  end;
end;

procedure TConnectionObjectsPageForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
var
  HT: THitInfo;
begin
  AskParent := False;
  PopupMenu := nil;
  if Assigned(Sender.FocusedNode) then
  begin
    Sender.GetHitTestInfoAt(P.X, P.Y, True, HT);
//    if (HT.HitNode = Sender.FocusedNode) and Assigned(CurrentComponent) then
//      PopupMenu := FRunPopup;
//    if not Assigned(PopupMenu) then
//      Exit;
  end;
end;

procedure TConnectionObjectsPageForm.TreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);
  if Assigned(NodeData) then
  begin
  end;
end;

procedure TConnectionObjectsPageForm.TreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);
  if Assigned(Data1) and Assigned(Data2) then
    Result := CompareStr(Data1.NormalText, Data2.NormalText);
end;

procedure TConnectionObjectsPageForm.TreeGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
  var HintText: WideString);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);
  if Assigned(NodeData) then
  begin
//    if NodeData.NodeType = ntFolder then
      HintText := NodeData.NormalText;
//    else
//      if Assigned(NodeData.Component) then HintText := NodeData.Component.Caption;
  end;
end;

procedure TConnectionObjectsPageForm.PropInspectorFilterProp(
  Sender: TObject; AInstance: TPersistent; APropInfo: PPropInfo;
  var AIncludeProp: Boolean);
begin
  AIncludeProp := Assigned(Component) and Component.CanShowProperty(APropInfo.Name);
end;

procedure TConnectionObjectsPageForm.PropInspectorGetEditorClass(
  Sender: TObject; AInstance: TPersistent; APropInfo: PPropInfo;
  var AEditorClass: TELPropEditorClass);
begin
  AEditorClass := BTGetProxiEditorClass(TELPropertyInspector(Sender), AInstance, APropInfo);
end;

procedure TConnectionObjectsPageForm.TreeDragAllowed(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var Allowed: Boolean);
var
  NodeData: PTreeRec;
begin
  LastDragObject.ObjectName:='';
  Allowed:=False;
  if Assigned(Node) then
  begin
   NodeData := Sender.GetNodeData(Node);
   if  Assigned(NodeData) then
   begin
    Allowed:=NodeData^.NodeType = ntObject;
    if Allowed then
    begin
     LastDragObject.ObjectName :=NodeData.NormalText;
     LastDragObject.ObjectClass:=NodeData.ClassIID;
     LastDragObject.DragType   :=dtObject;
    end
   end;
  end
end;

end.

