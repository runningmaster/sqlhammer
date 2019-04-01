unit ibSHIndicesFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHTableObjectFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ToolWin, ComCtrls, ImgList, ActnList, Menus,
  StrUtils, SynEdit, pSHSynEdit, AppEvnts, VirtualTrees;

type
  TibBTIndicesForm = class(TibSHTableForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    TreeObjects: TVirtualStringTree;
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure DoOnGetData; override;
    { ISHRunCommands }
    function GetCanAlter: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;
  end;

var
  ibBTIndicesForm: TibBTIndicesForm;

implementation

{$R *.dfm}

{ TibBTIndicesForm }

constructor TibBTIndicesForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  MsgPanel := Panel2;
  MsgSplitter := Splitter1;
  Tree := TreeObjects;
  CreateDDLForm;
end;

destructor TibBTIndicesForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibBTIndicesForm.DoOnGetData;
var
  I, J: Integer;
  S, Source: string;
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Tree.BeginUpdate;
  Tree.Indent := 0;
  Tree.Clear;
  if Assigned(Editor) then Editor.Clear;
  if Assigned(DBTable) then
  begin
    for I := 0 to Pred(DBTable.Indices.Count) do
    begin
      Source := Trim(DBTable.GetIndex(I).SourceDDL.Text);
      for J := 0 to Pred(DBTable.Constraints.Count) do
        if AnsiSameText(DBTable.GetConstraint(J).IndexName, DBTable.Indices[I]) then
        begin
          if SameText(DBTable.GetConstraint(J).ConstraintType, 'PRIMARY KEY') then
           S := 'PRIMARY KEY'
          else
          if SameText(DBTable.GetConstraint(J).ConstraintType, 'UNIQUE') then
           S := 'UNIQUE'
          else
          if SameText(DBTable.GetConstraint(J).ConstraintType, 'FOREIGN KEY') then
           S := 'FOREIGN KEY';
          Source := Format('/* Created by %s constraint */%s%s', [S, SLineBreak, Trim(DBTable.GetConstraint(J).SourceDDL.Text)]);
        end;
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.Number := IntToStr(I + 1);
      NodeData.ImageIndex := -1; // Designer.GetImageIndex(IibSHIndex);
      NodeData.Name := DBTable.Indices[I];
      NodeData.Fields := AnsiReplaceStr(AnsiReplaceStr(DBTable.GetIndex(I).Fields.CommaText, '"', ''), ',',', ');
      NodeData.Status := DBTable.GetIndex(I).Status;
      NodeData.IndexType := DBTable.GetIndex(I).IndexType;
      NodeData.Sorting := DBTable.GetIndex(I).Sorting;
      NodeData.Statistics := DBTable.GetIndex(I).Statistics;
      NodeData.Description := EmptyStr;
      NodeData.Source := Source;
      NodeData.Expression:=TrimRight(DBTable.GetIndex(I).Expression.Text);
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

function TibBTIndicesForm.GetCanAlter: Boolean;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Result := False;
  Node := Tree.FocusedNode;
  if Assigned(Node) then
  begin
    NodeData := Tree.GetNodeData(Node);
    Result := Assigned(NodeData) and
              ((Pos('RDB$', NodeData.Name) = 0) and
              (Pos('Created by', NodeData.Source) = 0)) and
               not GetCanPause;
  end;
end;

end.

