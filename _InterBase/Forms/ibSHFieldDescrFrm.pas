unit ibSHFieldDescrFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, ImgList, ActnList, AppEvnts,
  SynEdit, pSHSynEdit, VirtualTrees, Menus;

type
  TibSHFieldDescrForm = class(TibBTComponentForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Tree: TVirtualStringTree;
    pSHSynEdit1: TpSHSynEdit;
    Panel3: TPanel;
    ApplicationEvents1: TApplicationEvents;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  private
    { Private declarations }
    FDBTableIntf: IibSHTable;
    FDBViewIntf: IibSHView;
    FDBProcedureIntf: IibSHProcedure;
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
    procedure TreeFocusChanging(Sender: TBaseVirtualTree;
      OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure TreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);

    procedure SetTreeEvents(ATree: TVirtualStringTree);
    procedure DoOnGetData;
    procedure ShowSource;
    procedure InternalRun(ANode: PVirtualNode);
  protected
    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanRefresh: Boolean; override;

    procedure Run; override;
    procedure Refresh; override;

    procedure DoOnIdle; override;
    function DoOnOptionsChanged: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure RefreshData;

    property DBTable: IibSHTable read FDBTableIntf;
    property DBView: IibSHView read FDBViewIntf;
    property DBProcedure: IibSHProcedure read FDBProcedureIntf;
  end;

  TibSHFieldDescrFormAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHFieldDescrFormAction_Run = class(TibSHFieldDescrFormAction_)
  end;
  TibSHFieldDescrFormAction_Refresh = class(TibSHFieldDescrFormAction_)
  end;

var
  ibSHFieldDescrForm: TibSHFieldDescrForm;

procedure Register;

implementation

uses
  ibSHConsts, ibSHSQLs, ibSHValues, ibSHStrUtil;

{$R *.dfm}

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    Number: string;
    ImageIndex: Integer;
    Name: string;
    Description: string;
    Input: Boolean;
  end;

procedure Register;
begin
  SHRegisterImage(TibSHFieldDescrFormAction_Run.ClassName,       'Button_Run.bmp');
  SHRegisterImage(TibSHFieldDescrFormAction_Refresh.ClassName,   'Button_Refresh.bmp');

  SHRegisterActions([
    TibSHFieldDescrFormAction_Run,
    TibSHFieldDescrFormAction_Refresh]);
end;

{ TibSHFieldDescrForm }

constructor TibSHFieldDescrForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHTable, FDBTableIntf);
  Supports(Component, IibSHView, FDBViewIntf);
  Supports(Component, IibSHProcedure, FDBProcedureIntf);

  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
//  Editor.Lines.AddStrings(DBObject.Description);
  FocusedControl := Tree;
  SetTreeEvents(Tree);

  DoOnOptionsChanged;
  
  RefreshData;
end;

destructor TibSHFieldDescrForm.Destroy;
begin
  if GetCanRun then Run;
  inherited Destroy;
end;

procedure TibSHFieldDescrForm.RefreshData;
begin
  try
    Screen.Cursor := crHourGlass;
    DoOnGetData;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TibSHFieldDescrForm.SetTreeEvents(ATree: TVirtualStringTree);
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
  ATree.OnFocusChanging := TreeFocusChanging;
  ATree.OnFocusChanged := TreeFocusChanged;
end;

procedure TibSHFieldDescrForm.DoOnGetData;
var
  I: Integer;
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Tree.BeginUpdate;
  Tree.Clear;
  Editor.Clear;

  if Assigned(DBTable) then
  begin
    for I := 0 to Pred(DBTable.Fields.Count) do
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.Number := IntToStr(I + 1);
      NodeData.ImageIndex := -1; // Designer.GetImageIndex(IibSHField);
      NodeData.Name := DBTable.Fields[I];
      NodeData.Description := TrimRight(DBTable.GetField(I).Description.Text);
    end;
  end;

  if Assigned(DBView) then
  begin
    for I := 0 to Pred(DBView.Fields.Count) do
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.Number := IntToStr(I + 1);
      NodeData.ImageIndex := -1; // Designer.GetImageIndex(IibSHField);
      NodeData.Name := DBView.Fields[I];
      NodeData.Description := TrimRight(DBView.GetField(I).Description.Text);
    end;
  end;

  if Assigned(DBProcedure) then
  begin
    if DBProcedure.Params.Count > 0 then
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.Number := '';
      NodeData.ImageIndex := -1;
      NodeData.Name := 'Input parameters';
    end;
    for I := 0 to Pred(DBProcedure.Params.Count) do
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.Number := IntToStr(I + 1);
      NodeData.ImageIndex := -1; //Designer.GetImageIndex(IibSHField);
      NodeData.Name := DBProcedure.Params[I];
      NodeData.Description := TrimRight(DBProcedure.GetParam(I).Description.Text);
      NodeData.Input := True;
    end;

    if DBProcedure.Returns.Count > 0 then
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.Number := '';
      NodeData.ImageIndex := -1;
      NodeData.Name := 'Output parameters';
    end;
    for I := 0 to Pred(DBProcedure.Returns.Count) do
    begin
      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.Number := IntToStr(I + 1);
      NodeData.ImageIndex := -1; // Designer.GetImageIndex(IibSHField);
      NodeData.Name := DBProcedure.Returns[I];
      NodeData.Description := TrimRight(DBProcedure.GetReturn(I).Description.Text);
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

procedure TibSHFieldDescrForm.ShowSource;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Node := Tree.FocusedNode;
  NodeData := Tree.GetNodeData(Node);
  if Assigned(Editor) and Assigned(NodeData) then
  begin
    Editor.BeginUpdate;
    Editor.Lines.Clear;
    Editor.Lines.Text := NodeData.Description;
    Editor.EndUpdate;
    Editor.Visible := Length(NodeData.Number) > 0; 
  end;
end;

procedure TibSHFieldDescrForm.InternalRun(ANode: PVirtualNode);
var
  NodeData: PTreeRec;
begin
  NodeData := Tree.GetNodeData(ANode);
  if Assigned(Editor) and Editor.Modified and Assigned(NodeData) then
  begin
    NodeData.Description := Editor.Lines.Text;

    if Assigned(DBTable) then
    begin
      DBTable.GetField(Pred(StrToInt(NodeData.Number))).Description.Assign(Editor.Lines);
      DBTable.GetField(Pred(StrToInt(NodeData.Number))).SetDescription;
    end;

    if Assigned(DBView) then
    begin
      DBView.GetField(Pred(StrToInt(NodeData.Number))).Description.Assign(Editor.Lines);
      DBView.GetField(Pred(StrToInt(NodeData.Number))).SetDescription;
    end;

    if Assigned(DBProcedure) then
    begin
      if NodeData.Input then
      begin
        DBProcedure.GetParam(Pred(StrToInt(NodeData.Number))).Description.Assign(Editor.Lines);
        DBProcedure.GetParam(Pred(StrToInt(NodeData.Number))).SetDescription;
      end else
      begin
        DBProcedure.GetReturn(Pred(StrToInt(NodeData.Number))).Description.Assign(Editor.Lines);
        DBProcedure.GetReturn(Pred(StrToInt(NodeData.Number))).SetDescription;
      end;
    end;

    Editor.Modified := False;
    Tree.Invalidate;
    Tree.Repaint;
  end;
end;

function TibSHFieldDescrForm.GetCanRun: Boolean;
begin
  Result := Assigned(Editor) and Editor.Modified;
end;

function TibSHFieldDescrForm.GetCanRefresh: Boolean;
begin
  Result := True;
end;

procedure TibSHFieldDescrForm.Run;
begin
  InternalRun(Tree.FocusedNode);
end;

procedure TibSHFieldDescrForm.Refresh;
begin
  if Assigned(DBTable) then DBTable.Refresh;
  if Assigned(DBView) then DBView.Refresh;
  if Assigned(DBProcedure) then DBProcedure.Refresh;
  RefreshData;
end;

procedure TibSHFieldDescrForm.DoOnIdle;
begin
  Editor.ReadOnly := not Assigned(Tree.FocusedNode);
end;

function TibSHFieldDescrForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
  if Result and Assigned(Editor) then
  begin
//    Editor.ReadOnly := True;
//    Editor.Options := Editor.Options + [eoScrollPastEof];
    Editor.Highlighter := nil;
    // Принудительная установка фонта
    Editor.Font.Charset := 1;
    Editor.Font.Color := clWindowText;
    Editor.Font.Height := -13;
    Editor.Font.Name := 'Courier New';
    Editor.Font.Pitch := fpDefault;
    Editor.Font.Size := 10;
    Editor.Font.Style := [];
  end;
end;

procedure TibSHFieldDescrForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  DoOnIdle;
end;

{ Tree }

procedure TibSHFieldDescrForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHFieldDescrForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibSHFieldDescrForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
//var
//  Data: PTreeRec;
begin
//  Data := Sender.GetNodeData(Node);
//  if  (Kind = ikNormal) or (Kind = ikSelected) then
//  begin
//    case Column of
//      1: ImageIndex := Data.ImageIndex;
//      else
//         ImageIndex := -1;
//    end;
//  end;
end;

procedure TibSHFieldDescrForm.TreeGetText(Sender: TBaseVirtualTree;
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
      1: CellText := Data.Name;
    end;
  end;
end;

procedure TibSHFieldDescrForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if TextType = ttNormal then
  begin
    case Column of
      0: ;// Data.Number;
      1: if (Length(Data.Description) = 0) and (Length(Data.Number) > 0) then
           if Sender.Focused and (vsSelected in Node.States) then
             TargetCanvas.Font.Color := clWindow
           else
             TargetCanvas.Font.Color := clGray;
    end;
  end;
end;

procedure TibSHFieldDescrForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.Name)) <> 1 then
    Result := 1;
end;

procedure TibSHFieldDescrForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  if Key = VK_RETURN then ShowConstraint(csSource);
end;

procedure TibSHFieldDescrForm.TreeDblClick(Sender: TObject);
begin
//  ShowConstraint(csSource);
end;

procedure TibSHFieldDescrForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
var
  HT: THitInfo;
  Data: PTreeRec;
begin
  if not Enabled then Exit;
  PopupMenu := nil;
  if Assigned(Sender.FocusedNode) then
  begin
    Sender.GetHitTestInfoAt(P.X, P.Y, True, HT);
    Data := Sender.GetNodeData(Sender.FocusedNode);
    if Assigned(Data) and (Sender.GetNodeLevel(Sender.FocusedNode) = 0) and (HT.HitNode = Sender.FocusedNode) and (hiOnItemLabel in HT.HitPositions) then
  end;
end;

procedure TibSHFieldDescrForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);
  Result := CompareStr(Data1.Name, Data2.Name);
end;

procedure TibSHFieldDescrForm.TreeFocusChanging(Sender: TBaseVirtualTree;
  OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
begin
  InternalRun(OldNode);
end;

procedure TibSHFieldDescrForm.TreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  ShowSource;
end;


{ TibSHFieldDescrFormAction_ }

constructor TibSHFieldDescrFormAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;

  if Self is TibSHFieldDescrFormAction_Run then Tag := 1;
  if Self is TibSHFieldDescrFormAction_Refresh then Tag := 2;

  case Tag of
    0: Caption := '-'; // separator
    1:
    begin
      Caption := Format('%s', ['Run']);
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

function TibSHFieldDescrFormAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHTable) or
            IsEqualGUID(AClassIID, IibSHView) or
            IsEqualGUID(AClassIID, IibSHSystemTable) or
            IsEqualGUID(AClassIID, IibSHSystemTableTmp) or
            IsEqualGUID(AClassIID, IibSHProcedure);
end;

procedure TibSHFieldDescrFormAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Refresh
    2: (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
  end;
end;

procedure TibSHFieldDescrFormAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHFieldDescrFormAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     (AnsiSameText(Designer.CurrentComponentForm.CallString, SCallFieldDescr) or
      AnsiSameText(Designer.CurrentComponentForm.CallString, SCallParamDescr)) then
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

end.
