unit ibSHTriggersFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHTableObjectFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ToolWin, ComCtrls,  Menus, ImgList, ActnList, SynEdit,
  pSHSynEdit, AppEvnts, VirtualTrees, StrUtils;

type
  TibBTTriggersForm = class(TibSHTableForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    TreeObjects: TVirtualStringTree;
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure DoOnGetData; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;
  end;

var
  ibBTTriggersForm: TibBTTriggersForm;

implementation

{$R *.dfm}

{ TibBTTriggersForm }

constructor TibBTTriggersForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  MsgPanel := Panel2;
  MsgSplitter := Splitter1;
  Tree := TreeObjects;
  CreateDDLForm;
end;

destructor TibBTTriggersForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibBTTriggersForm.DoOnGetData;
var
  I, J: Integer;
  Node, Node2: PVirtualNode;
  NodeData, NodeData2: PTreeRec;
begin
  J := 0;
  Tree.BeginUpdate;
  Tree.Indent := 0;
  Tree.Clear;
  if Assigned(Editor) then Editor.Clear;
  if Assigned(DBTable) then
  begin
    for I := 0 to Pred(DBTable.Triggers.Count) do
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.Number := IntToStr(I + 1);
      NodeData.ImageIndex := -1; // Designer.GetImageIndex(IibSHTrigger);
      NodeData.Name := DBTable.Triggers[I];
      NodeData.Status := DBTable.GetTrigger(I).Status;
      NodeData.TypePrefix := DBTable.GetTrigger(I).TypePrefix;
      NodeData.TypeSuffix := DBTable.GetTrigger(I).TypeSuffix;
      NodeData.Position := IntToStr(DBTable.GetTrigger(I).Position);
      NodeData.Description := Trim(DBTable.GetTrigger(I).Description.Text);
      NodeData.Source := Trim(DBTable.GetTrigger(I).SourceDDL.Text);
      if Length(NodeData.Description) > 0 then
      begin
        Tree.Indent := 12;
        Node2 := Tree.AddChild(Node);
        NodeData2 := Tree.GetNodeData(Node2);
        NodeData2.Name := DBTable.GetTrigger(I).Description[J];
        NodeData2.Source := NodeData.Source;
//        for J := 0 to Pred(DBTable.GetTrigger(I).Description.Count) do
//        begin
//          Node2 := Tree.AddChild(Node);
//          NodeData2 := Tree.GetNodeData(Node2);
//          NodeData2.Name := DBTable.GetTrigger(I).Description[J];
//          NodeData2.Source := NodeData.Source;
//        end;
      end;
    end;
  end;

  if Assigned(DBView) then
  begin
    for I := 0 to Pred(DBView.Triggers.Count) do
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.Number := IntToStr(I + 1);
      NodeData.ImageIndex := -1; // Designer.GetImageIndex(IibSHTrigger);
      NodeData.Name := DBView.Triggers[I];
      NodeData.Status := DBView.GetTrigger(I).Status;
      NodeData.TypePrefix := DBView.GetTrigger(I).TypePrefix;
      NodeData.TypeSuffix := DBView.GetTrigger(I).TypeSuffix;
      NodeData.Position := IntToStr(DBView.GetTrigger(I).Position);
      NodeData.Description := Trim(DBView.GetTrigger(I).Description.Text);
      NodeData.Source := Trim(DBView.GetTrigger(I).SourceDDL.Text);
      if Length(NodeData.Description) > 0 then
      begin
        Tree.Indent := 12;
        for J := 0 to Pred(DBView.GetTrigger(I).Description.Count) do
        begin
          Node2 := Tree.AddChild(Node);
          NodeData2 := Tree.GetNodeData(Node2);
          NodeData2.Name := DBView.GetTrigger(I).Description[J];
          NodeData2.Source := NodeData.Source;
        end;
      end;      
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

end.








