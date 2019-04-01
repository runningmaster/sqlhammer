unit ibSHConstraintsFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHTableObjectFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ToolWin, ComCtrls, ImgList, ActnList,
  StrUtils, SynEdit, pSHSynEdit, AppEvnts, Menus, VirtualTrees;

type
  TibBTConstraintsForm = class(TibSHTableForm)
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
  ibBTConstraintsForm: TibBTConstraintsForm;

implementation

{$R *.dfm}

{ TibBTConstraintsForm }

constructor TibBTConstraintsForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  MsgPanel := Panel2;
  MsgSplitter := Splitter1;
  Tree := TreeObjects;
  CreateDDLForm;
end;

destructor TibBTConstraintsForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibBTConstraintsForm.DoOnGetData;
var
  I: Integer;
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Tree.BeginUpdate;
  Tree.Indent := 0;
  Tree.Clear;
  if Assigned(Editor) then Editor.Clear;
  if Assigned(DBTable) then
  begin
    for I := 0 to Pred(DBTable.Constraints.Count) do
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.Number := IntToStr(I + 1);
      NodeData.ImageIndex := -1; // Designer.GetImageIndex(IibSHConstraint);
      NodeData.Name := DBTable.Constraints[I];
      NodeData.ConstraintType := DBTable.GetConstraint(I).ConstraintType;
      if NodeData.ConstraintType <> 'CHECK' then
        NodeData.Fields := AnsiReplaceStr(AnsiReplaceStr(DBTable.GetConstraint(I).Fields.CommaText, '"', ''), ',',', ')
      else
        NodeData.Fields := Trim(DBTable.GetConstraint(I).CheckSource.Text);
      NodeData.RefTable := DBTable.GetConstraint(I).ReferenceTable;
      NodeData.RefFields := AnsiReplaceStr(AnsiReplaceStr(DBTable.GetConstraint(I).ReferenceFields.CommaText, '"', ''), ',',', ');
      NodeData.OnDelete := DBTable.GetConstraint(I).OnDeleteRule;
      NodeData.OnUpdate := DBTable.GetConstraint(I).OnUpdateRule;
      NodeData.IndexName := DBTable.GetConstraint(I).IndexName;
      NodeData.IndexSorting := DBTable.GetConstraint(I).IndexSorting;
      NodeData.Description := EmptyStr;
      NodeData.Source := Trim(DBTable.GetConstraint(I).SourceDDL.Text);
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

