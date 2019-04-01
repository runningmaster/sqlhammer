unit ibSHUserManagerFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, VirtualTrees, Menus, ImgList,
  AppEvnts, ActnList;

type
  TibSHUserManagerForm = class(TibBTComponentForm)
    Tree: TVirtualStringTree;
  private
    { Private declarations }
    FUserManagerIntf: IibSHUserManager;
    FIntUser: TSHComponent;
    FIntUserIntf: IibSHUser;
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
    procedure TreeGetPopupMenu(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
      var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure TreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
      Column: TColumnIndex; var Result: Integer);

    procedure SetTreeEvents(ATree: TVirtualStringTree);
    procedure DoOnGetData;
  protected
    { ISHRunCommands }
    function GetCanCreate: Boolean; override;
    function GetCanAlter: Boolean; override;
    function GetCanDrop: Boolean; override;
    function GetCanRefresh: Boolean; override;

    procedure ICreate; override;
    procedure Alter; override;
    procedure Drop; override;
    procedure Refresh; override;

    procedure SetStatusBar(Value: TStatusBar); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure RefreshData;

    property UserManager: IibSHUserManager read FUserManagerIntf;
  end;

var
  ibSHUserManagerForm: TibSHUserManagerForm;

implementation

uses
  ibSHConsts, ibSHMessages, ibSHValues;

{$R *.dfm}

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    NormalText: string;
    StaticText: string;
    ClassIID: TGUID;
    ImageIndex: Integer;
    Number: string;
    UserName: string;
    FirstName: string;
    MiddleName: string;
    LastName: string;
    AC: string;
  end;

{ TibSHUserManagerForm }

constructor TibSHUserManagerForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHUserManager, FUserManagerIntf);
  FocusedControl := Tree;
  SetTreeEvents(Tree);
  RefreshData;
  if not Assigned(UserManager.BTCLDatabase) then
    Tree.Header.Columns[5].Options := Tree.Header.Columns[5].Options - [coVisible];

  vComponentClass := Designer.GetComponent(IibSHUser);
  if Assigned(vComponentClass) then
  begin
    FIntUser := vComponentClass.Create(Self);
    Supports(FIntUser, IibSHUser, FIntUserIntf);
  end;
end;

destructor TibSHUserManagerForm.Destroy;
begin
  FIntUserIntf := nil;
  FreeAndNil(FIntUser);
  inherited Destroy;
end;

procedure TibSHUserManagerForm.SetTreeEvents(ATree: TVirtualStringTree);
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
end;

procedure TibSHUserManagerForm.DoOnGetData;
var
  I: Integer;
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Tree.BeginUpdate;
  Tree.Clear;
  if Assigned(UserManager) then
  begin
    UserManager.DisplayUsers;
    for I := 0 to Pred(UserManager.GetUserCount) do
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.ImageIndex := Designer.GetImageIndex(IibSHUser);
      NodeData.NormalText := UserManager.GetUserName(I);
      NodeData.Number := IntToStr(I + 1);
      NodeData.UserName := UserManager.GetUserName(I);
      NodeData.FirstName := UserManager.GetFirstName(I);
      NodeData.MiddleName := UserManager.GetMiddleName(I);
      NodeData.LastName := UserManager.GetLastName(I);
      NodeData.AC := IntToStr(UserManager.GetConnectCount(NodeData.UserName));
    end;
  end;

  Node := Tree.GetFirst;
  if Assigned(Node) then
  begin
    Tree.FocusedNode := Node;
    Tree.Selected[Tree.FocusedNode] := True;
  end;
  Tree.EndUpdate;
end;

procedure TibSHUserManagerForm.RefreshData;
begin
  try
    Screen.Cursor := crHourGlass;
    DoOnGetData;
    Designer.UpdateObjectInspector;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function TibSHUserManagerForm.GetCanCreate: Boolean;
begin
  Result := True;
end;

function TibSHUserManagerForm.GetCanAlter: Boolean;
begin
  Result := Assigned(Tree.FocusedNode);
end;

function TibSHUserManagerForm.GetCanDrop: Boolean;
begin
  Result := GetCanAlter;
end;

function TibSHUserManagerForm.GetCanRefresh: Boolean;
begin
  Result := True;
end;

procedure TibSHUserManagerForm.ICreate;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  FIntUserIntf.UserName := Format('%s', ['NEW_USER']);
  FIntUserIntf.Password := Format('%s', [SDefaultPassword]);
  FIntUserIntf.FirstName := Format('%s', [EmptyStr]);
  FIntUserIntf.MiddleName := Format('%s', [EmptyStr]);
  FIntUserIntf.LastName := Format('%s', [EmptyStr]);
  FIntUser.MakePropertyVisible('UserName');
  if IsPositiveResult(Designer.ShowModal(FIntUser, SCallUser)) then
  begin
    if UserManager.AddUser(   
         FIntUserIntf.UserName,
         FIntUserIntf.Password,
         FIntUserIntf.FirstName,
         FIntUserIntf.MiddleName,
         FIntUserIntf.LastName) then
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.ImageIndex := Designer.GetImageIndex(IibSHUser);
      NodeData.NormalText := FIntUserIntf.UserName;
      NodeData.Number := IntToStr(Tree.RootNodeCount);
      NodeData.UserName := FIntUserIntf.UserName;
      NodeData.FirstName := FIntUserIntf.FirstName;
      NodeData.MiddleName := FIntUserIntf.MiddleName;
      NodeData.LastName := FIntUserIntf.LastName;
      NodeData.AC := IntToStr(UserManager.GetConnectCount(NodeData.UserName));

      Tree.FocusedNode := Node;
      Tree.Selected[Tree.FocusedNode] := True;
      if Tree.CanFocus then Tree.SetFocus;
    end;
  end;
end;

procedure TibSHUserManagerForm.Alter;
var
  NodeData: PTreeRec;
begin
  NodeData := nil;
  if Assigned(Tree.FocusedNode) then NodeData := Tree.GetNodeData(Tree.FocusedNode);
  if Assigned(NodeData) then
  begin
    FIntUserIntf.UserName := NodeData.UserName;
    FIntUserIntf.Password := Format('%s', [SDefaultPassword]);
    FIntUserIntf.FirstName := NodeData.FirstName;
    FIntUserIntf.MiddleName := NodeData.MiddleName;
    FIntUserIntf.LastName := NodeData.LastName;
    FIntUser.MakePropertyInvisible('UserName');
    if IsPositiveResult(Designer.ShowModal(FIntUser, SCallUser)) then
    begin
      if UserManager.ModifyUser(
           FIntUserIntf.UserName,
           FIntUserIntf.Password,
           FIntUserIntf.FirstName,
           FIntUserIntf.MiddleName,
           FIntUserIntf.LastName) then
      begin
        NodeData.FirstName := FIntUserIntf.FirstName;
        NodeData.MiddleName := FIntUserIntf.MiddleName;
        NodeData.LastName := FIntUserIntf.LastName;
      end;
    end;
  end;
end;

procedure TibSHUserManagerForm.Drop;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  NodeData := nil;
  if Assigned(Tree.FocusedNode) then NodeData := Tree.GetNodeData(Tree.FocusedNode);
  if Assigned(NodeData) then
  begin
    FIntUserIntf.UserName := NodeData.UserName;
    if Designer.ShowMsg(Format(SDeleteUser, [FIntUserIntf.UserName]), mtConfirmation) then
    begin
      if UserManager.DeleteUser(FIntUserIntf.UserName) then
      begin
        Node := Tree.FocusedNode.NextSibling;
        if not Assigned(Node) then Node := Tree.FocusedNode.PrevSibling;
        Tree.DeleteNode(Tree.FocusedNode);
        if Assigned(Node) then
        begin
          Tree.FocusedNode := Node;
          Tree.Selected[Tree.FocusedNode] := True;
          if Tree.CanFocus then Tree.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TibSHUserManagerForm.Refresh;
begin
  RefreshData;
end;

procedure TibSHUserManagerForm.SetStatusBar(Value: TStatusBar);
begin
  inherited SetStatusBar(Value);
  if Assigned(StatusBar) then StatusBar.Visible := False;
end;

{ Tree }

procedure TibSHUserManagerForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHUserManagerForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibSHUserManagerForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  ImageIndex := -1;
  if  (Kind = ikNormal) or (Kind = ikSelected) then
  begin
    case Column of
      1: ImageIndex := Data.ImageIndex;
      else
         ImageIndex := -1;
    end;
  end;
end;

procedure TibSHUserManagerForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if TextType = ttNormal then
  begin
    case Column of
      0: CellText := Data.Number;
      1: CellText := Data.UserName;
      2: CellText := Data.FirstName;
      3: CellText := Data.MiddleName;
      4: CellText := Data.LastName;
      5: CellText := Data.AC;
    end;
  end;
end;

procedure TibSHUserManagerForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
//var
//  Data: PTreeRec;
begin
//  Data := Sender.GetNodeData(Node);
end;

procedure TibSHUserManagerForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.NormalText)) <> 1 then
    Result := 1;
end;

procedure TibSHUserManagerForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Alter;
end;

procedure TibSHUserManagerForm.TreeDblClick(Sender: TObject);
begin
  Alter;
end;

procedure TibSHUserManagerForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
begin
//
end;

procedure TibSHUserManagerForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  Result := CompareStr(Data1.NormalText, Data2.NormalText);
end;

end.
