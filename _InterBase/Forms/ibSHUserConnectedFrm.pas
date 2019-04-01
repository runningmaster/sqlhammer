unit ibSHUserConnectedFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, ExtCtrls;

type
  TibSHUserConnectedForm = class(TibBTComponentForm)
    Panel1: TPanel;
    Tree: TVirtualStringTree;
  private
    { Private declarations }
    FUserNames: TStrings;
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

    procedure BuildTree;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;
  end;

var
  ibSHUserConnectedForm: TibSHUserConnectedForm;

implementation

uses
  ibSHConsts;

{$R *.dfm}

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    NormalText: string;
    StaticText: string;
    ImageIndex: Integer;
  end;

{ TibSHUserConnectedForm }

constructor TibSHUserConnectedForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  FUserNames := TStringList.Create;
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Caption := Format(ACallString, []);
  if Assigned(ModalForm) then ModalForm.ButtonsMode := bmOK;
  Tree.Images := Designer.ImageList;
  Tree.OnGetNodeDataSize := TreeGetNodeDataSize;
  Tree.OnFreeNode := TreeFreeNode;
  Tree.OnGetImageIndex := TreeGetImageIndex;
  Tree.OnGetText := TreeGetText;

  BuildTree;
end;

destructor TibSHUserConnectedForm.Destroy;
begin
  FUserNames.Free;
  inherited Destroy;
end;

procedure TibSHUserConnectedForm.BuildTree;
var
  I: Integer;
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  if Supports(Component, IibSHDatabase) then
    FUserNames.Assign((Component as IibSHDatabase).DRVQuery.Database.UserNames);

  for I := 0 to Pred(FUserNames.Count) do
  begin
    Node := Tree.AddChild(nil);
    NodeData := Tree.GetNodeData(Node);
    NodeData.NormalText := FUserNames[I];
    NodeData.ImageIndex := Designer.GetImageIndex(IibSHUser);
  end;

  Node := Tree.GetFirst;
  if Assigned(Node) then
  begin
    Tree.FocusedNode := Node;
    Tree.Selected[Tree.FocusedNode] := True;
  end;

  Caption := Format('%s: %d users connected', [Caption, FUserNames.Count]);
end;

{ Tree }

procedure TibSHUserConnectedForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHUserConnectedForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibSHUserConnectedForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if (Kind = ikNormal) or (Kind = ikSelected) then ImageIndex := Data.ImageIndex;
end;

procedure TibSHUserConnectedForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  case TextType of
    ttNormal: CellText := Data.NormalText;
    ttStatic: CellText := Data.StaticText;
  end;
end;

end.
