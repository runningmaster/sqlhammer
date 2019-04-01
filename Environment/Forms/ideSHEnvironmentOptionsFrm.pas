unit ideSHEnvironmentOptionsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ideSHBaseDialogFrm, StdCtrls, ExtCtrls, AppEvnts, VirtualTrees,
  TypInfo, SHDesignIntf, SHOptionsIntf, SHEvents, Menus;

type
  TEnvironmentOptionsForm = class(TBaseDialogForm)
    Panel1: TPanel;
    Tree: TVirtualStringTree;
    Splitter1: TSplitter;
    pnlComponentForm: TPanel;
    PopupMenu1: TPopupMenu;
    RestoreDefaults1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure TreeGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure TreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure TreePaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure TreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure TreeGetPopupMenu(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
      var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure RestoreDefaults1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FComponentForm: TSHComponentForm;
    procedure OnChangeNode;
    procedure Expand;

    procedure FindNodeProc(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Data: Pointer; var Abort: Boolean);
    function FindNode(Node: PVirtualNode; AName: string): PVirtualNode;
  public
    { Public declarations }
    procedure RecreateOptionList(const IID: TGUID);

    property ComponentForm: TSHComponentForm read FComponentForm write FComponentForm;
  end;

var
  EnvironmentOptionsForm: TEnvironmentOptionsForm;

implementation

uses
  ideSHSystem, ideSHConsts;

{$R *.dfm}

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    NormalText: string;
    StaticText: string;
    Component: TSHComponent;
    ImageIndex: Integer;
  end;

var
  OldNode: PVirtualNode;

{ TEnvironmentOptionsForm }

procedure TEnvironmentOptionsForm.FormCreate(Sender: TObject);
begin
  SetFormSize(540, 640);
  Position := poScreenCenter;
  inherited;
  Caption := Format('%s', [SCaptionDialogOptions]);
  CaptionOK := Format('%s', [SCaptionButtonSave]);
  pnlComponentForm.Caption := Format('%s', [SSubentryFrom]);
  if Assigned(MainIntf) then
    Tree.Images := MainIntf.ImageList;
   RegistryIntf.SaveOptionsToList;
end;

procedure TEnvironmentOptionsForm.FormShow(Sender: TObject);
begin
  inherited;
  OnChangeNode;
end;

procedure TEnvironmentOptionsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  Event: TSHEvent;
begin
  inherited;
  if Assigned(RegistryIntf) then
  begin
    try
      Screen.Cursor := crHourGlass;
      if (ModalResult = mrOK) and Assigned(DesignerIntf) then
      begin
        RegistryIntf.SaveOptionsToFile;
        Event.Event := SHE_OPTIONS_CHANGED;
        DesignerIntf.SendEvent(Event);
      end else
        RegistryIntf.LoadOptionsFromList;

    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TEnvironmentOptionsForm.FormDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FComponentForm) then  FComponentForm.Free;
end;

procedure TEnvironmentOptionsForm.RecreateOptionList(const IID: TGUID);
var
  I: Integer;
  Data: PTreeRec;
  ParentNode, ChildNode: PVirtualNode;
  ComponentOptionsIntf: ISHComponentOptions;
  ParentCategory: string;

  procedure Test(S: string);
  var
    I: Integer;
  begin
    for I := 0 to Pred(RegistryIntf.RegDemonCount) do
      if Supports(RegistryIntf.GetRegDemon(I), ISHComponentOptions, ComponentOptionsIntf) and
        ComponentOptionsIntf.Visible and (ComponentOptionsIntf.ParentCategory = S) then
      begin
        ParentNode := FindNode(nil, ComponentOptionsIntf.ParentCategory);
        if not Assigned(ParentNode) then
        begin
          ParentNode := Tree.AddChild(nil);
          Data := Tree.GetNodeData(ParentNode);
        end else
        begin
          ChildNode := Tree.AddChild(ParentNode);
          Data := Tree.GetNodeData(ChildNode);
        end;
        Data.NormalText := ComponentOptionsIntf.Category;
        Data.Component := RegistryIntf.GetRegDemon(I);
        Data.ImageIndex := DesignerIntf.GetImageIndex(RegistryIntf.GetRegDemon(I).ClassIID);
        Test(Data.NormalText);
      end;
  end;
begin
  try
    Tree.BeginUpdate;
    if not IsEqualGUID(IUnknown, IID) then
      for I := 0 to Pred(RegistryIntf.RegDemonCount) do
        if Supports(RegistryIntf.GetRegDemon(I), ISHComponentOptions, ComponentOptionsIntf) and
          ComponentOptionsIntf.Visible and Supports(RegistryIntf.GetRegDemon(I), IID) then
        begin
          ParentCategory := ComponentOptionsIntf.Category;
          ParentNode := Tree.AddChild(nil);
          Data := Tree.GetNodeData(ParentNode);
          Data.NormalText := ComponentOptionsIntf.Category;
          Data.Component := RegistryIntf.GetRegDemon(I);
          Data.ImageIndex := DesignerIntf.GetImageIndex(RegistryIntf.GetRegDemon(I).ClassIID);
        end;

    Test(ParentCategory);
    Expand;
    Tree.FocusedNode := Tree.GetFirst;
    Tree.Selected[Tree.FocusedNode] := True;
  finally
    Tree.EndUpdate;
  end;
end;

procedure TEnvironmentOptionsForm.OnChangeNode;
var
  Data: PTreeRec;
  ComponentOptionsIntf: ISHComponentOptions;
  ComponentFormClass: TSHComponentFormClass;
begin
  if Assigned(Tree.FocusedNode) and Assigned(RegistryIntf) then
  begin
    Data := Tree.GetNodeData(Tree.FocusedNode);
    if Assigned(ComponentForm) then
    begin
      ComponentForm.Free;
      ComponentForm := nil;
    end;

    Supports(Data.Component,  ISHComponentOptions, ComponentOptionsIntf);
    if ComponentOptionsIntf.UseDefaultEditor then
      ComponentFormClass := RegistryIntf.GetRegComponentForm(ISHSystemOptions, SSystem)
    else
      ComponentFormClass := RegistryIntf.GetRegComponentForm(Data.Component.ClassIID, Data.NormalText);

    if Assigned(ComponentFormClass) then
    begin
      ComponentForm := ComponentFormClass.Create(Application, pnlComponentForm, Data.Component, Data.NormalText);
      ComponentForm.Show;
    end;
  end;
end;

procedure TEnvironmentOptionsForm.Expand;
var
  Node: PVirtualNode;
begin
  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    if Node.ChildCount > 0 then Tree.Expanded[Node] := True;
    Node := Tree.GetNext(Node);
  end;
end;

procedure TEnvironmentOptionsForm.FindNodeProc(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Data: Pointer; var Abort: Boolean);
var
  NodeData: PTreeRec;
begin
  NodeData := nil;
  if Assigned(Node) then
    NodeData := Sender.GetNodeData(Node);
  Abort := (not Assigned(NodeData)) or (NodeData.NormalText = String(Data));
end;

function TEnvironmentOptionsForm.FindNode(Node: PVirtualNode; AName: string): PVirtualNode;
begin
  Result := Tree.IterateSubtree(Node, FindNodeProc, Pointer(AName), []);
end;

procedure TEnvironmentOptionsForm.RestoreDefaults1Click(Sender: TObject);
var
  Data: PTreeRec;
  ComponentOptionsIntf: ISHComponentOptions;
  Event: TSHEvent;
begin
  Event.Event := SHE_OPTIONS_DEFAULTS_RESTORED;
  if Assigned(Tree.FocusedNode) then
  begin
    Data := Tree.GetNodeData(Tree.FocusedNode);
    if Supports(Data.Component, ISHComponentOptions, ComponentOptionsIntf) then
    begin
      ComponentOptionsIntf.RestoreDefaults;
      DesignerIntf.SendEvent(Event);
    end;
  end;
end;

{ Tree }

procedure TEnvironmentOptionsForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TEnvironmentOptionsForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TEnvironmentOptionsForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  Data := Tree.GetNodeData(Node);
  if (Kind = ikNormal) or (Kind = ikSelected) then
    ImageIndex := Data.ImageIndex;
end;

procedure TEnvironmentOptionsForm.TreeGetText(Sender: TBaseVirtualTree;
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

procedure TEnvironmentOptionsForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
//
end;

procedure TEnvironmentOptionsForm.TreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  if OldNode <> Tree.FocusedNode then
    OnChangeNode;
  OldNode := Tree.FocusedNode;
end;

procedure TEnvironmentOptionsForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
var
  HT: THitInfo;
begin
  PopupMenu := nil;
  Tree.GetHitTestInfoAt(P.X, P.Y, True, HT);
  if (HT.HitNode = Tree.FocusedNode) and not (hiOnItemButton in HT.HitPositions) then
    if Assigned(FComponentForm) then
      PopupMenu := PopupMenu1;
end;

end.
