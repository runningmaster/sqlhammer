unit ideSHConnectionPageFrm;

interface

uses
  SHDesignIntf, ideSHDesignIntf, ideSHObject,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, VirtualTrees, ToolWin, Menus, Grids, TypInfo, ELPropInsp,
  Buttons, StdCtrls, ActnList, Contnrs, ExtCtrls, pSHNetscapeSplitter;

type
  TConnectionPageForm = class(TSHComponentForm, IideSHConnection)
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    PopupMenu1: TPopupMenu;
    Bevel1: TBevel;
    ActionList1: TActionList;
    est1: TMenuItem;
    Panel0: TPanel;
    Panel2: TPanel;
    Panel1: TPanel;
    Tree: TVirtualStringTree;
    PopupMenu2: TPopupMenu;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    pSHNetscapeSplitter1: TpSHNetscapeSplitter;
    Bevel2: TBevel;
    Panel3: TPanel;
    procedure PropInspectorChange(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure pSHNetscapeSplitter1Moved(Sender: TObject);
  private
    { Private declarations }
    FServerList: TObjectList;
    FDatabaseList: TObjectList;
    FFormList: TObjectList;
    FLoadingFromFile: Boolean;
    FRegPopup: TPopupMenu;
    FRunPopup: TPopupMenu;

    FServerNode: PVirtualNode;
    FDatabaseNode: PVirtualNode;
    FActiveNode: PVirtualNode;

    FCurrentComponent: TSHComponent;

    procedure SetCurrentComponent(Value: TSHComponent);
    function GetCurrentRegistration: ISHRegistration;

    procedure InitServerNode;
    procedure InitDatabaseNode;
    procedure InitActiveNode;
    procedure LoadActions(AClassIID: TGUID; ACallType: TSHActionCallType);
    procedure RegMenuPopup(Sender: TObject);
    procedure RunMenuPopup(Sender: TObject);
    procedure RefreshTrees;

    { IideSHConnection }
    function GetCanConnect: Boolean;
    function GetCanReconnect: Boolean;
    function GetCanDisconnect: Boolean;
    function GetCanDisconnectAll: Boolean;
    function GetCanRefresh: Boolean;
    function GetCanMoveUp: Boolean;
    function GetCanMoveDown: Boolean;
    function GetLoadingFromFile: Boolean;

    function GetCurrentServer: TSHComponent;
    function GetCurrentDatabase: TSHComponent;
    function GetCurrentServerInUse: Boolean;
    function GetCurrentDatabaseInUse: Boolean;
    function GetServerCount: Integer;
    function GetDatabaseCount: Integer;

    procedure Connect;
    procedure Reconnect;
    procedure Disconnect;
    function DisconnectAll: Boolean;
    procedure Refresh;
    procedure MoveUp;
    procedure MoveDown;

    function FindConnectionNode(AConnection: TSHComponent): PVirtualNode;
    function FindConnection(AConnection: TSHComponent): Boolean;
    function RegisterConnection(AConnection: TSHComponent): Boolean;
    function UnregisterConnection(AConnection: TSHComponent): Boolean;
    function DestroyConnection(AConnection: TSHComponent): Boolean;

    function ActiveFindConnectionNode(AConnection: TSHComponent): PVirtualNode;
    function ActiveFindConnection(AConnection: TSHComponent): Boolean;
    function ActiveRegisterConnection(AConnection: TSHComponent): Boolean;
    function ActiveUnregisterConnection(AConnection: TSHComponent): Boolean;

    procedure _NavCreateForm(AConnection: TSHComponent);
    function _NavFindForm(AConnection: TSHComponent): TSHComponentForm;
    procedure _NavDestroyForm(AConnection: TSHComponent);
    procedure _NavHideForm(AConnection: TSHComponent);
    procedure _NavShowForm(AConnection: TSHComponent);
    procedure _NavRefreshForm(AConnection: TSHComponent);
    procedure _NavPrepareForm(AConnection: TSHComponent);

    function ConnectTo(AConnection: TSHComponent): Boolean;
    function ReconnectTo(AConnection: TSHComponent): Boolean;
    function DisconnectFrom(AConnection: TSHComponent): Boolean;
    procedure RefreshConnection(AConnection: TSHComponent);
    procedure ActivateConnection(AConnection: TSHComponent);
    function SynchronizeConnection(AConnection: TSHComponent;
      const AClassIID: TGUID; const ACaption: string; Operation: TOperation): Boolean;

    procedure SetRegistrationMenuItems(AMenuItem: TMenuItem);
    procedure SetConnectionMenuItems(AMenuItem: TMenuItem);

    procedure SaveToFile; overload;
    procedure SaveToFile(const Section: string); overload;
    procedure LoadFromFile; overload;
    procedure LoadFromFile(const Section: string); overload;

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
    procedure TreeFocusChanging(Sender: TBaseVirtualTree;
      OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure TreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure TreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
      Column: TColumnIndex; var Result: Integer);
    procedure TreeGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure BringToTop; override;

    property ServerNode: PVirtualNode read FServerNode;
    property DatabaseNode: PVirtualNode read FDatabaseNode;
    property ActiveNode: PVirtualNode read FActiveNode write FActiveNode;

    property CurrentComponent: TSHComponent read FCurrentComponent write SetCurrentComponent;
    property CurrentRegistration: ISHRegistration read GetCurrentRegistration;
    property CurrentServer: TSHComponent read GetCurrentServer;
    property CurrentDatabase: TSHComponent read GetCurrentDatabase;
    property CurrentServerInUse: Boolean read GetCurrentServerInUse;
    property CurrentDatabaseInUse: Boolean read GetCurrentDatabaseInUse;
    property ServerCount: Integer read GetServerCount;
    property DatabaseCount: Integer read GetDatabaseCount;
  end;

var
  ConnectionPageForm: TConnectionPageForm;

implementation

uses ideSHMainFrm,
     ideSHConsts, ideSHSystem, ideSHSysUtils,
     ideSHConnectionObjectsPageFrm;

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
    Hint: string;
  end;

{ TConnectionPageForm }

constructor TConnectionPageForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  FRegPopup := PopupMenu1;
  FRunPopup := PopupMenu2;
  FRegPopup.OnPopup := RegMenuPopup;
  FRunPopup.OnPopup := RunMenuPopup;

  SetTreeEvents(Tree);

  InitServerNode;
  InitDatabaseNode;
  FActiveNode := nil;

  FServerList := TObjectList.Create;
  FDatabaseList := TObjectList.Create;
  FFormList := TObjectList.Create;

  if Assigned(SystemOptionsIntf) then Panel1.Height := SystemOptionsIntf.IDE1Height;
end;

destructor TConnectionPageForm.Destroy;
begin
  FFormList.Free;
  FDatabaseList.Free;
  FServerList.Free;
  inherited Destroy;
end;

procedure TConnectionPageForm.BringToTop;
begin
  if Tree.CanFocus then Tree.SetFocus;
end;

procedure TConnectionPageForm.SetCurrentComponent(Value: TSHComponent);
begin
  if FCurrentComponent <> Value then FCurrentComponent := Value;
end;

function TConnectionPageForm.GetCurrentRegistration: ISHRegistration;
begin
  Supports(CurrentComponent, ISHRegistration, Result);
end;

function TConnectionPageForm.GetCanConnect: Boolean;
begin
  Result := Assigned(CurrentRegistration) and CurrentRegistration.CanConnect;
end;

function TConnectionPageForm.GetCanReconnect: Boolean;
begin
  Result := Assigned(CurrentRegistration) and CurrentRegistration.CanReconnect;
end;

function TConnectionPageForm.GetCanDisconnect: Boolean;
begin
  Result := Assigned(CurrentRegistration) and CurrentRegistration.CanDisconnect;
end;

function TConnectionPageForm.GetCanDisconnectAll: Boolean;
begin
  Result := Assigned(ActiveNode);
end;

function TConnectionPageForm.GetCanRefresh: Boolean;
begin
  Result := Assigned(CurrentRegistration) and CurrentRegistration.CanDisconnect;
end;

function TConnectionPageForm.GetCanMoveUp: Boolean;
begin
  Result := False;
end;

function TConnectionPageForm.GetCanMoveDown: Boolean;
begin
  Result := False;
end;

function TConnectionPageForm.GetLoadingFromFile: Boolean;
begin
  Result := FLoadingFromFile;
end;

function TConnectionPageForm.GetCurrentServer: TSHComponent;
begin
  Result := nil;
  if Assigned(CurrentComponent) then
  begin
    if Supports(CurrentComponent, ISHServer) then
      Result := CurrentComponent
    else
      Result := Designer.FindComponent(CurrentComponent.OwnerIID);
  end;
end;

function TConnectionPageForm.GetCurrentDatabase: TSHComponent;
begin
  Result := nil;
  if Supports(CurrentComponent, ISHDatabase) then Result := CurrentComponent;
end;

function TConnectionPageForm.GetCurrentServerInUse: Boolean;
var
  I: Integer;
begin
  Result := Assigned(CurrentServer);
  if Result then
  begin
    Result := False;
    for I := 0 to Pred(FDatabaseList.Count) do
      if IsEqualGUID(TSHComponent(FDatabaseList[I]).OwnerIID, CurrentServer.InstanceIID) and
         (TSHComponent(FDatabaseList[I]) as ISHRegistration).Connected then
      begin
        Result := True;
        Break;
      end;
  end;
end;

function TConnectionPageForm.GetCurrentDatabaseInUse: Boolean;
begin
  Result := Assigned(CurrentDatabase) and (CurrentDatabase as ISHRegistration).Connected;
end;

function TConnectionPageForm.GetServerCount: Integer;
begin
  Result := FServerList.Count;
end;

function TConnectionPageForm.GetDatabaseCount: Integer;
begin
  Result := FDatabaseList.Count;
end;

procedure TConnectionPageForm.Connect;
begin
  if Assigned(CurrentRegistration) and not CurrentRegistration.Connected then
    ConnectTo(CurrentComponent);
end;

procedure TConnectionPageForm.Reconnect;
begin
  ReconnectTo(CurrentComponent);
end;

procedure TConnectionPageForm.Disconnect;
begin
  DisconnectFrom(CurrentComponent);
end;

function TConnectionPageForm.DisconnectAll: Boolean;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Result := True;
  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    NodeData := Tree.GetNodeData(Node);
    if Assigned(NodeData) and Assigned(NodeData.Component) then
    begin
      Result := DisconnectFrom(NodeData.Component);
      if not Result then Break;
    end;
    Node := Tree.GetNext(Node);
  end;
  RefreshTrees;
end;

procedure TConnectionPageForm.Refresh;
begin
  RefreshConnection(CurrentComponent);
end;

procedure TConnectionPageForm.MoveUp;
begin
end;

procedure TConnectionPageForm.MoveDown;
begin
end;

function TConnectionPageForm.FindConnectionNode(AConnection: TSHComponent): PVirtualNode;
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
      if Assigned(NodeData.Component) and (NodeData.Component = AConnection) then
        Result := Node;
    end;
    Node := Tree.GetNext(Node);
  end;
end;

function TConnectionPageForm.FindConnection(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(FindConnectionNode(AConnection));
end;

function TConnectionPageForm.RegisterConnection(AConnection: TSHComponent): Boolean;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Result := FindConnection(AConnection);
  if not Result then
  begin
    if Supports(AConnection, ISHServer) then
    begin
      Node := Tree.AddChild(ServerNode);
      if Assigned(Node) then
      begin
        NodeData := Tree.GetNodeData(Node);
        if Assigned(NodeData) then
        begin
          NodeData.Component := AConnection;
          NodeData.NormalText := AConnection.Caption;
          NodeData.StaticText := EmptyStr;
          NodeData.NodeType := ntServer;
          NodeData.ImageIndex := IMG_SERVER;
        end;
      end;

      if not FLoadingFromFile then
      begin
        Tree.FocusedNode := Node;
        Tree.Selected[Tree.FocusedNode] := True;
      end;
      FServerList.Add(AConnection);
    end; // server

    if Supports(AConnection, ISHDatabase) then
    begin
      Node := Tree.AddChild(FindConnectionNode(Designer.FindComponent(AConnection.OwnerIID)));
      if Assigned(Node) then
      begin
        NodeData := Tree.GetNodeData(Node);
        if Assigned(NodeData) then
        begin
          NodeData.Component := AConnection;
          NodeData.NormalText := AConnection.Caption;
          NodeData.StaticText := EmptyStr;
          NodeData.NodeType := ntDatabase;
          NodeData.ImageIndex := IMG_DATABASE;
        end;
      end;

      Node := Tree.AddChild(DatabaseNode);
      if Assigned(Node) then
      begin
        NodeData := Tree.GetNodeData(Node);
        if Assigned(NodeData) then
        begin
          NodeData.Component := AConnection;
          NodeData.NormalText := AConnection.Caption;
          NodeData.StaticText := EmptyStr;
          NodeData.NodeType := ntDatabase;
          NodeData.ImageIndex := IMG_DATABASE;
        end;
      end;

      if not FLoadingFromFile then
      begin
        Tree.FocusedNode := Node;
        Tree.Selected[Tree.FocusedNode] := True;
      end;
      FDatabaseList.Add(AConnection);
    end; // database

    _NavCreateForm(AConnection);
    _NavPrepareForm(AConnection);
    if not FLoadingFromFile then _NavShowForm(AConnection);
    Result := True;
  end;
end;

function TConnectionPageForm.UnregisterConnection(AConnection: TSHComponent): Boolean;
var
  Node, NextNode: PVirtualNode;
  I: Integer;
begin
  Result := False;
  Node := nil;
  NextNode := nil;

  Node := FindConnectionNode(AConnection);

  if Assigned(Node) then
  begin
    if Supports(AConnection, ISHServer) then
    begin
      for I := Pred(FDatabaseList.Count) downto 0 do
        if IsEqualGUID(TSHComponent(FDatabaseList[I]).OwnerIID, AConnection.InstanceIID) then
        begin
          UnregisterConnection(TSHComponent(FDatabaseList[I]));
          DestroyConnection(TSHComponent(FDatabaseList[I]));
        end;

      NextNode := Node.PrevSibling;
      if not Assigned(NextNode) then NextNode := Node.Parent;
      Tree.DeleteNode(Node);
      _NavDestroyForm(AConnection);
    end;


    if Supports(AConnection, ISHDatabase) then
    begin
      NextNode := Node.PrevSibling;
      if not Assigned(NextNode) then NextNode := Node.Parent;
      Tree.DeleteNode(Node);

      Node := FindConnectionNode(AConnection);
      if Assigned(Node) then Tree.DeleteNode(Node);
      _NavDestroyForm(AConnection);
    end;

    Result := True;
    Tree.FocusedNode := NextNode;
    Tree.Selected[Tree.FocusedNode] := True;
  end;
end;

function TConnectionPageForm.DestroyConnection(AConnection: TSHComponent): Boolean;
begin
  Result := False;

  if Supports(AConnection, ISHServer) then
  begin
    FServerList.Remove(AConnection);
    Result := True;
    Exit;
  end;

  if Supports(AConnection, ISHDatabase) then
  begin
    FDatabaseList.Remove(AConnection);
    Result := True;
    Exit;
  end;
end;

function TConnectionPageForm.ActiveFindConnectionNode(AConnection: TSHComponent): PVirtualNode;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Result := nil;
  Node:= ActiveNode;
  while not Assigned(Result) and Assigned(Node) do
  begin
    NodeData := Tree.GetNodeData(Node);
    if Assigned(NodeData) then
    begin
      if Assigned(NodeData.Component) and (NodeData.Component = AConnection) then
        Result := Node;
    end;
    Node := Tree.GetNext(Node);
  end;
end;

function TConnectionPageForm.ActiveFindConnection(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(ActiveFindConnectionNode(AConnection));
end;

function TConnectionPageForm.ActiveRegisterConnection(AConnection: TSHComponent): Boolean;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Result := ActiveFindConnection(AConnection);

  if not Result then
  begin
    // добавление в нод
    if not Assigned(ActiveNode) then InitActiveNode;
    if Assigned(ActiveNode) then
    begin
      Node := Tree.AddChild(ActiveNode);
      if Assigned(Node) then
      begin
        NodeData := Tree.GetNodeData(Node);
        if Assigned(NodeData) then
        begin
          NodeData.Component := AConnection;
          NodeData.NormalText := AConnection.Caption;
          NodeData.StaticText := EmptyStr;
          NodeData.NodeType := ntDatabase;
          NodeData.ImageIndex := IMG_DATABASE;
        end;
      end;
    end;

    Result := True;
  end;
end;

function TConnectionPageForm.ActiveUnregisterConnection(AConnection: TSHComponent): Boolean;
var
  Node, NextNode: PVirtualNode;
//  NodeData: PTreeRec;
begin
  Result := False;
  Node := nil;
  NextNode := nil;

  Node := ActiveFindConnectionNode(AConnection);

  if Assigned(Node) then
  begin
    // удаление из нода
    if Assigned(ActiveNode) then
    begin
      Node := nil;
      Node := ActiveFindConnectionNode(AConnection);
      if Assigned(Node) then Tree.DeleteNode(Node);
      if ActiveNode.ChildCount = 0 then
      begin
        Tree.DeleteNode(ActiveNode);
        ActiveNode := nil;
      end;
    end;
    Result := True;
  end;
end;

procedure TConnectionPageForm._NavCreateForm(AConnection: TSHComponent);
begin
  FFormList.Add(TConnectionObjectsPageForm.Create(Panel2, Panel2, AConnection, 'NAVIGATOR'));
end;

function TConnectionPageForm._NavFindForm(AConnection: TSHComponent): TSHComponentForm;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(FFormList.Count) do
  begin
    if TSHComponentForm(FFormList[I]).Component = AConnection then
    begin
      Result := TSHComponentForm(FFormList[I]);
      Break;
    end;
  end;
end;

procedure TConnectionPageForm._NavDestroyForm(AConnection: TSHComponent);
var
  Form: TForm;
begin
  Form := _NavFindForm(AConnection);
  if Assigned(Form) then FFormList.Remove(Form);
end;

procedure TConnectionPageForm._NavHideForm(AConnection: TSHComponent);
var
  Form: TForm;
begin
  Form := _NavFindForm(AConnection);
  if Assigned(Form) then Form.Hide;
end;

procedure TConnectionPageForm._NavShowForm(AConnection: TSHComponent);
var
  Form: TForm;
  WindowLocked: Boolean;
begin
  Form := _NavFindForm(AConnection);
  WindowLocked := LockWindowUpdate(GetDesktopWindow);
  try
    if Assigned(Form) then Form.Show;
    if Assigned(Form) and (Form is TConnectionObjectsPageForm) then
      (Form as TConnectionObjectsPageForm).PrepareInfo;
  finally
    if WindowLocked then LockWindowUpdate(0);
  end;
end;

procedure TConnectionPageForm._NavRefreshForm(AConnection: TSHComponent);
var
  Form: TForm;
begin
  Form := _NavFindForm(AConnection);
  if Assigned(Form) and (Form is TConnectionObjectsPageForm) then
  begin
    (Form as TConnectionObjectsPageForm).LoadSchemeObjectsFromConnection;
    (Form as TConnectionObjectsPageForm).PrepareInfo;
  end;
end;

procedure TConnectionPageForm._NavPrepareForm(AConnection: TSHComponent);
var
  Form: TForm;
begin
  Form := _NavFindForm(AConnection);
  if Assigned(Form) and (Form is TConnectionObjectsPageForm) then
    (Form as TConnectionObjectsPageForm).PrepareControls;
  if Assigned(NavigatorIntf) then NavigatorIntf.RefreshPalette;
end;

function TConnectionPageForm.ConnectTo(AConnection: TSHComponent): Boolean;
var
  RegistrationIntf: ISHRegistration;
begin
  Screen.Cursor := crHourGlass;
  try
    Result := Supports(AConnection, ISHRegistration, RegistrationIntf) and RegistrationIntf.Connect;
    if Assigned(RegistrationIntf) and RegistrationIntf.Connected then
    begin
      ActiveRegisterConnection(AConnection);
      _NavPrepareForm(AConnection);
      _NavRefreshForm(AConnection);
    end;
  finally
    RegistrationIntf := nil;
    Screen.Cursor := crDefault;
    RefreshTrees;
  end;
end;

function TConnectionPageForm.ReconnectTo(AConnection: TSHComponent): Boolean;
var
  RegistrationIntf: ISHRegistration;
begin
  Screen.Cursor := crHourGlass;
  try
    Result := Supports(AConnection, ISHRegistration, RegistrationIntf) and RegistrationIntf.Reconnect;
  finally
    RegistrationIntf := nil;
    Screen.Cursor := crDefault;
    RefreshTrees;
  end;
end;

function TConnectionPageForm.DisconnectFrom(AConnection: TSHComponent): Boolean;
var
  I: Integer;
  RegistrationIntf: ISHRegistration;
begin
  Result := False;
  Supports(AConnection, ISHRegistration, RegistrationIntf);

  if Assigned(RegistrationIntf) then
  begin
    for I := Pred(DesignerIntf.Components.Count) downto 0 do
    begin
      if IsEqualGUID(TSHComponent(DesignerIntf.Components[I]).OwnerIID, AConnection.InstanceIID) and
         DesignerIntf.ExistsComponent(TSHComponent(DesignerIntf.Components[I])) then
      begin
        if not ComponentFactoryIntf.DestroyComponent(TSHComponent(DesignerIntf.Components[I])) then
        begin
          Result := False;
          Exit;
        end;
      end;
    end;

    try
      Screen.Cursor := crHourGlass;
      Result := RegistrationIntf.Disconnect;
    finally
      Screen.Cursor := crDefault;
    end;

    if not RegistrationIntf.Connected then
    begin
      ActiveUnregisterConnection(AConnection);
      _NavPrepareForm(AConnection);
    end;
  end;

  RegistrationIntf := nil;
  RefreshTrees;
end;

procedure TConnectionPageForm.RefreshConnection(AConnection: TSHComponent);
var
  RegistrationIntf: ISHRegistration;
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Node := nil;
  Screen.Cursor := crHourGlass;
  try
    if Supports(AConnection, ISHRegistration, RegistrationIntf) then
    begin
      RegistrationIntf.Refresh;
      Node := ActiveFindConnectionNode(AConnection);
      if Assigned(Node) then
      begin
        NodeData := Tree.GetNodeData(Node);
        _NavRefreshForm(AConnection);
      end;
    end;
  finally
    RegistrationIntf := nil;
    Screen.Cursor := crDefault;
    RefreshTrees;
  end;
end;

procedure TConnectionPageForm.ActivateConnection(AConnection: TSHComponent);
var
  Node: PVirtualNode;
begin
  Node := ActiveFindConnectionNode(AConnection);
  if Assigned(Node) then
  begin
    Tree.FocusedNode := Node;
    Tree.Selected[Tree.FocusedNode] := True;
  end;

//  ActiveRegisterConnection(AConnection);
end;

function TConnectionPageForm.SynchronizeConnection(AConnection: TSHComponent;
  const AClassIID: TGUID; const ACaption: string; Operation: TOperation): Boolean;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Result := False;
  Node := ActiveFindConnectionNode(AConnection);
  if Assigned(Node) then
  begin
    NodeData := Tree.GetNodeData(Node);
    TConnectionObjectsPageForm(_NavFindForm(AConnection)).SynchronizeObjects(AClassIID, ACaption, Operation);
  end;
end;

procedure TConnectionPageForm.SetRegistrationMenuItems(AMenuItem: TMenuItem);
var
  I: Integer;
  NewItem: TMenuItem;
begin
  for I := 0 to Pred(DesignerIntf.ActionList.ActionCount) do
    if Supports(DesignerIntf.ActionList.Actions[I], ISHAction) and
       ((DesignerIntf.ActionList.Actions[I] as ISHAction).CallType = actCallRegister) and
       (DesignerIntf.ActionList.Actions[I] as ISHAction).SupportComponent(Component.ClassIID) then
  begin
    DesignerIntf.ActionList.Actions[I].Update;
    NewItem := TMenuItem.Create(nil);
    NewItem.Action := DesignerIntf.ActionList.Actions[I];
    NewItem.Default := (DesignerIntf.ActionList.Actions[I] as ISHAction).Default;
    AMenuItem.Add(NewItem);
  end;
end;

procedure TConnectionPageForm.SetConnectionMenuItems(AMenuItem: TMenuItem);
var
  I: Integer;
  NewItem: TMenuItem;
begin
  if Assigned(CurrentComponent) then
  begin
    for I := 0 to Pred(DesignerIntf.ActionList.ActionCount) do
      if Supports(DesignerIntf.ActionList.Actions[I], ISHAction) and
         ((DesignerIntf.ActionList.Actions[I] as ISHAction).CallType = actCallEditor) and
         (DesignerIntf.ActionList.Actions[I] as ISHAction).SupportComponent(CurrentComponent.ClassIID) then
    begin
      DesignerIntf.ActionList.Actions[I].Update;
      NewItem := TMenuItem.Create(nil);
      NewItem.Action := DesignerIntf.ActionList.Actions[I];
      NewItem.Default := (DesignerIntf.ActionList.Actions[I] as ISHAction).Default;
      AMenuItem.Add(NewItem);
    end;
  end else
  begin
    NewItem := TMenuItem.Create(nil);
    NewItem.Caption := Format('%s', [SNothingSelected]);
    AMenuItem.Add(NewItem);
  end;
end;

procedure TConnectionPageForm.SaveToFile;
begin
  SaveToFile(Format('%s %s', [Component.Caption, SSectionRegistries]));
end;

procedure TConnectionPageForm.SaveToFile(const Section: string);
var
  TmpList: TStringList;
  I, J: Integer;
  Node, ChildNode: PVirtualNode;
  NodeData: PTreeRec;
begin
  TmpList := TStringList.Create;
  try
    I := 0;
    Node:= Tree.GetFirst;
    while Assigned(Node) do
    begin
      NodeData := Tree.GetNodeData(Node);
      if Assigned(NodeData) and Assigned(NodeData.Component) and Supports(NodeData.Component, ISHServer) then
      begin
        GetPropValues(NodeData.Component, Format('Host%d.%s', [I, NodeData.Component.ClassName]), TmpList);
        TmpList.Add(Format('Host%d.DatabaseCount=%d', [I, Node.ChildCount]));
        if Node.ChildCount > 0 then
        begin
          J := 0;
          ChildNode := Node.FirstChild;
          while Assigned(ChildNode) do
          begin
            NodeData := Tree.GetNodeData(ChildNode);
            if Assigned(NodeData) and Assigned(NodeData.Component) and Supports(NodeData.Component, ISHDatabase) then
            begin
              GetPropValues(NodeData.Component, Format('Host%d.Database%d.%s', [I, J, NodeData.Component.ClassName]), TmpList);
              Inc(J);
            end;
            ChildNode := ChildNode.NextSibling;
          end;
        end;
        Inc(I);
      end;
      Node := Tree.GetNext(Node);
    end;
    TmpList.Insert(0, Format('HostCount=%d', [I]));
    SaveStringsToFile(GetFilePath(SFileAliases), Section, TmpList,True);
  finally
    TmpList.Free;
  end;
end;

procedure TConnectionPageForm.LoadFromFile;
begin
  FLoadingFromFile := True;
  try
    LoadFromFile(Format('%s %s', [Component.Caption, SSectionRegistries]));

//    if DatabaseNode.ChildCount > 0 then
//      Tree.FocusedNode := DatabaseNode
//    else
      Tree.FocusedNode := ServerNode;

    Tree.Expanded[Tree.FocusedNode] := True;
    Tree.Selected[Tree.FocusedNode] := True;
  finally
    FLoadingFromFile := False;
  end;
end;

procedure TConnectionPageForm.LoadFromFile(const Section: string);
var
  TmpList: TStringList;
  I, J: Integer;
  BTServer, BTDatabase: TSHComponent;
begin
  TmpList := TStringList.Create;
  try
    if FileExists(GetFilePath(SFileAliases)) then
    begin
      LoadStringsFromFile(GetFilePath(SFileAliases), Section, TmpList);
      if TmpList.IndexOfName('HostCount') = -1 then Exit;
      for I := 0 to Pred(StrToInt(TmpList.ValueFromIndex[TmpList.IndexOfName('HostCount')])) do
      begin
        BTServer := ComponentFactoryIntf.CreateComponent(Component.InstanceIID, ISHServer, GUIDToString(Component.BranchIID));
        if not Assigned(BTServer) then Continue;
        SetPropValues(BTServer, Format('Host%d.%s', [I, BTServer.ClassName]), TmpList);
        (BTServer as ISHRegistration).IDELoadFromFileNotify;;

        if TmpList.IndexOfName(Format('Host%d.DatabaseCount',[I])) = -1 then Continue;

        for J := 0 to Pred(StrToInt(TmpList.ValueFromIndex[TmpList.IndexOfName(Format('Host%d.DatabaseCount',[I]))])) do
        begin
          BTDatabase := ComponentFactoryIntf.CreateComponent(BTServer.InstanceIID, ISHDatabase, GUIDToString(Component.BranchIID));
          if not Assigned(BTDatabase) then Continue;
          SetPropValues(BTDatabase, Format('Host%d.Database%d.%s', [I, J, BTDatabase.ClassName]), TmpList);
          (BTDatabase as ISHRegistration).IDELoadFromFileNotify;;
        end;
      end;
    end;
  finally
    TmpList.Free;
  end;
end;

procedure TConnectionPageForm.InitServerNode;
var
  NodeData: PTreeRec;
begin
  FServerNode := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(FServerNode);
  if Assigned(NodeData) then
  begin
    NodeData.Component := nil;
    NodeData.NormalText := Format('%s', ['Servers']);
    NodeData.StaticText := EmptyStr;
    NodeData.ImageIndex := 25;
    NodeData.NodeType := ntFolder;
  end;
end;

procedure TConnectionPageForm.InitDatabaseNode;
var
  NodeData: PTreeRec;
begin
  FDatabaseNode := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(FDatabaseNode);
  if Assigned(NodeData) then
  begin
    NodeData.Component := nil;
    NodeData.NormalText := Format('%s', ['Databases']);
    NodeData.StaticText := EmptyStr;
    NodeData.ImageIndex := 25;
    NodeData.NodeType := ntFolder;
  end;
end;

procedure TConnectionPageForm.InitActiveNode;
var
  NodeData: PTreeRec;
begin
  FActiveNode := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(FActiveNode);
  if Assigned(NodeData) then
  begin
    NodeData.Component := nil;
    NodeData.NormalText := Format('%s', ['Connections']);
    NodeData.StaticText := EmptyStr;
    NodeData.ImageIndex := 25;
    NodeData.NodeType := ntFolder;
  end;
end;

procedure TConnectionPageForm.LoadActions(AClassIID: TGUID; ACallType: TSHActionCallType);
var
  I: Integer;
  TmpPopup: TPopupMenu;
  NewItem: TMenuItem;
begin
  TmpPopup := nil;

  case ACallType of
    actCallRegister: TmpPopup := FRegPopup;
    actCallEditor: TmpPopup := FRunPopup;
  end;

  if Assigned(TmpPopup) then
  begin
    while TmpPopup.Items.Count > 0 do TmpPopup.Items.Delete(0);

    for I := 0 to Pred(DesignerIntf.ActionList.ActionCount) do
      if Supports(DesignerIntf.ActionList.Actions[I], ISHAction) and
         ((DesignerIntf.ActionList.Actions[I] as ISHAction).CallType = ACallType) and
         (DesignerIntf.ActionList.Actions[I] as ISHAction).SupportComponent(AClassIID) then
    begin
      DesignerIntf.ActionList.Actions[I].Update;
      NewItem := TMenuItem.Create(Self);
      NewItem.Action := DesignerIntf.ActionList.Actions[I];
      NewItem.Default := (DesignerIntf.ActionList.Actions[I] as ISHAction).Default;
      TmpPopup.Items.Add(NewItem);
    end;
  end;
end;

procedure TConnectionPageForm.RegMenuPopup(Sender: TObject);
begin
  LoadActions(Component.BranchIID, actCallRegister);
end;

procedure TConnectionPageForm.RunMenuPopup(Sender: TObject);
begin
  LoadActions(CurrentComponent.ClassIID, actCallEditor);
end;

procedure TConnectionPageForm.RefreshTrees;
begin
  if Tree.CanFocus then Tree.SetFocus;
  Tree.Invalidate;
  Tree.Refresh;
end;

procedure TConnectionPageForm.PropInspectorChange(Sender: TObject);
begin
  RefreshTrees;
end;

procedure TConnectionPageForm.ToolButton1Click(Sender: TObject);
begin
  if Assigned(CurrentRegistration) then
    CurrentRegistration.ShowRegistrationInfo
  else
    (Sender as TToolButton).CheckMenuDropdown;
end;

procedure TConnectionPageForm.pSHNetscapeSplitter1Moved(Sender: TObject);
begin
  if Assigned(SystemOptionsIntf) then SystemOptionsIntf.IDE1Height := Panel1.Height;
end;

{ Tree }

procedure TConnectionPageForm.SetTreeEvents(ATree: TVirtualStringTree);
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
  ATree.OnFocusChanging := TreeFocusChanging;
  ATree.OnFocusChanged := TreeFocusChanged;
  ATree.OnCompareNodes := TreeCompareNodes;
  ATree.OnGetHint := TreeGetHint;
end;

procedure TConnectionPageForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TConnectionPageForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);
  if Assigned(NodeData) then Finalize(NodeData^);
end;

procedure TConnectionPageForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
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

procedure TConnectionPageForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);

  if Assigned(NodeData) then
  begin
    case TextType of
      ttNormal:
        if NodeData.NodeType = ntFolder then
        begin
          CellText := NodeData.NormalText;
          NodeData.Hint := NodeData.NormalText;
        end else
        begin
          CellText := NodeData.Component.Caption;
          NodeData.Hint := NodeData.Component.Caption;
        end;

      ttStatic:
        begin
          if Node.ChildCount > 0 then
            CellText := Format('%d', [Node.ChildCount])
          else
            CellText := EmptyStr;

          if Assigned(NodeData.Component) and Supports(NodeData.Component, ISHDatabase) then
          begin
            if Node.Parent = DatabaseNode then
            begin
              CellText := (DesignerIntf.FindComponent(NodeData.Component.OwnerIID) as ISHRegistration).Alias;
              NodeData.Hint := NodeData.Hint + ' [' + CellText + ']';
            end;
            
            if (Node.Parent = ActiveNode) or (Sender.Tag = 1) then
            begin
              CellText := NodeData.Component.CaptionExt;
              NodeData.Hint := NodeData.Hint + ' [' + CellText + ']';
            end;
          end;
        end;
    end;
  end;
end;

procedure TConnectionPageForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  NodeData: PTreeRec;
  Registration: ISHRegistration;
begin
  NodeData := Sender.GetNodeData(Node);

  if Assigned(NodeData) then
  begin
    case TextType of
      ttNormal: if Node.ChildCount <> 0 then TargetCanvas.Font.Style := [fsBold];
      ttStatic: if Sender.Focused and (vsSelected in Node.States) then
                  TargetCanvas.Font.Color := clWindow
                else
                  TargetCanvas.Font.Color := clGray;
    end;

    if Assigned(NodeData.Component) then
    begin
      if Supports(NodeData.Component, ISHRegistration, Registration) and Registration.Connected then
        case TextType of
         ttNormal: begin
                     if Sender.Focused and (vsSelected in Node.States) then
                       TargetCanvas.Font.Color := clWindow
                     else
                       TargetCanvas.Font.Color := clRed;
                     TargetCanvas.Font.Style := [fsBold];
                   end;
         ttStatic:
        end;
    end;
  end;
end;

procedure TConnectionPageForm.TreeIncrementalSearch(
  Sender: TBaseVirtualTree; Node: PVirtualNode;
  const SearchText: WideString; var Result: Integer);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);

  if Assigned(NodeData) then
  begin
    if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(NodeData.NormalText)) <> 1 then
      Result := 1;
  end;
end;

procedure TConnectionPageForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    case TBaseVirtualTree(Sender).Tag of
      0: Connect;
      1: Refresh;
    end;
end;

procedure TConnectionPageForm.TreeDblClick(Sender: TObject);
var
  HT: THitInfo;
  P: TPoint;
begin
  GetCursorPos(P);
  if Assigned(TBaseVirtualTree(Sender).FocusedNode) then
  begin
    P := TBaseVirtualTree(Sender).ScreenToClient(P);
    TBaseVirtualTree(Sender).GetHitTestInfoAt(P.X, P.Y, True, HT);
    if (HT.HitNode = TBaseVirtualTree(Sender).FocusedNode) and
       not (hiOnItemButton in HT.HitPositions) then Connect;
  end;
end;

procedure TConnectionPageForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
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

    if (HT.HitNode = Sender.FocusedNode) then
    begin
     if Assigned(CurrentComponent) then PopupMenu := FRunPopup;
     if (Node = ServerNode) or (Node = DatabaseNode) then PopupMenu := FRegPopup;
    end;
    if not Assigned(PopupMenu) then
      Exit;
  end;
end;

procedure TConnectionPageForm.TreeFocusChanging(Sender: TBaseVirtualTree;
  OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
var
  NodeData: PTreeRec;
  OldComponent: TSHComponent;
begin
  OldComponent := nil;
  
  if OldNode <> NewNode then
  begin
    NodeData := Sender.GetNodeData(NewNode);
    if Assigned(NodeData) and Assigned(NodeData.Component) then
    begin
      _NavShowForm(NodeData.Component);
      OldComponent := NodeData.Component;
    end;

    NodeData := Sender.GetNodeData(OldNode);
    if Assigned(NodeData) and Assigned(NodeData.Component) then
    begin
      if OldComponent <> NodeData.Component then
        _NavHideForm(NodeData.Component);
    end;
  end;
end;

procedure TConnectionPageForm.TreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);
  if Assigned(NodeData) then
  begin
    CurrentComponent := NodeData.Component;
//    if Assigned(NodeData.Form) then TSHComponentForm(NodeData.Form).BringToTop;
    if Assigned(NavigatorIntf) then NavigatorIntf.RefreshPalette;
  end;
end;

procedure TConnectionPageForm.TreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);
  if Assigned(Data1) and Assigned(Data2) then
    Result := CompareStr(Data1.NormalText, Data2.NormalText);
end;

procedure TConnectionPageForm.TreeGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
  var HintText: WideString);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);
  if Assigned(NodeData) then HintText := NodeData.Hint;
end;

end.




