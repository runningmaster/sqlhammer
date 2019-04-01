unit ibSHFieldOrderFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, ImgList, ActnList, AppEvnts,
  SynEdit, pSHSynEdit, VirtualTrees, Menus;

type
  TibSHFieldOrderForm = class(TibBTComponentForm, IibSHFieldOrderForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Tree: TVirtualStringTree;
    pSHSynEdit1: TpSHSynEdit;
    Panel3: TPanel;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  private
    { Private declarations }
    FDBTableIntf: IibSHTable;
    FIsMoved: Boolean;
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
    procedure DoOnGetData;
    { IibSHFieldOrderForm }
    function GetCanMoveUp: Boolean;
    function GetCanMoveDown: Boolean;
    procedure MoveUp;
    procedure MoveDown;
  protected
    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanRefresh: Boolean; override;

    procedure Run; override;
    procedure Refresh; override;

    function DoOnOptionsChanged: Boolean; override;
    function GetCanDestroy: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure RefreshData;

    property DBTable: IibSHTable read FDBTableIntf;
    property IsMoved: Boolean read FIsMoved write FIsMoved;
  end;

  TibSHFieldOrderFormAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHFieldOrderFormAction_Run = class(TibSHFieldOrderFormAction_)
  end;
  TibSHFieldOrderFormAction_MoveUp = class(TibSHFieldOrderFormAction_)
  end;
  TibSHFieldOrderFormAction_MoveDown = class(TibSHFieldOrderFormAction_)
  end;
  TibSHFieldOrderFormAction_Refresh = class(TibSHFieldOrderFormAction_)
  end;

var
  ibSHFieldOrderForm: TibSHFieldOrderForm;

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
  end;

procedure Register;
begin
  SHRegisterImage(TibSHFieldOrderFormAction_Run.ClassName,       'Button_Run.bmp');
  SHRegisterImage(TibSHFieldOrderFormAction_MoveUp.ClassName,    'Button_Arrow_Top.bmp');
  SHRegisterImage(TibSHFieldOrderFormAction_MoveDown.ClassName,  'Button_Arrow_Down.bmp');
  SHRegisterImage(TibSHFieldOrderFormAction_Refresh.ClassName,   'Button_Refresh.bmp');

  SHRegisterActions([
    TibSHFieldOrderFormAction_Run,
    TibSHFieldOrderFormAction_MoveUp,
    TibSHFieldOrderFormAction_MoveDown,
    TibSHFieldOrderFormAction_Refresh]);
end;

{ TibSHFieldOrderForm }

constructor TibSHFieldOrderForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHTable, FDBTableIntf);

  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
//  Editor.Lines.AddStrings(DBObject.Description);
  FocusedControl := Tree;
  SetTreeEvents(Tree);

  DoOnOptionsChanged;
  RefreshData;
end;

destructor TibSHFieldOrderForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHFieldOrderForm.RefreshData;
begin
  try
    Screen.Cursor := crHourGlass;
    DoOnGetData;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TibSHFieldOrderForm.SetTreeEvents(ATree: TVirtualStringTree);
begin
  ATree.Images := Designer.ImageList;
  ATree.OnGetNodeDataSize := TreeGetNodeDataSize;
  ATree.OnFreeNode := TreeFreeNode;
  ATree.OnGetImageIndex := TreeGetImageIndex;
  ATree.OnGetText := TreeGetText;
  ATree.OnIncrementalSearch := TreeIncrementalSearch;
  ATree.OnDblClick := TreeDblClick;
  ATree.OnKeyDown := TreeKeyDown;
  ATree.OnGetPopupMenu := TreeGetPopupMenu;
  ATree.OnCompareNodes := TreeCompareNodes;
  ATree.OnFocusChanged := TreeFocusChanged;
end;

procedure TibSHFieldOrderForm.DoOnGetData;
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

function TibSHFieldOrderForm.GetCanMoveUp: Boolean;
begin
  Result := Assigned(Tree.FocusedNode) and Assigned(Tree.FocusedNode.PrevSibling);
end;

function TibSHFieldOrderForm.GetCanMoveDown: Boolean;
begin
  Result := Assigned(Tree.FocusedNode) and Assigned(Tree.FocusedNode.NextSibling);
end;

procedure TibSHFieldOrderForm.MoveUp;
begin
  Tree.MoveTo(Tree.FocusedNode, Tree.FocusedNode.PrevSibling, amInsertBefore, False);
  IsMoved := True;
end;

procedure TibSHFieldOrderForm.MoveDown;
begin
  Tree.MoveTo(Tree.FocusedNode, Tree.FocusedNode.NextSibling, amInsertAfter, False);
  IsMoved := True;  
end;

function TibSHFieldOrderForm.GetCanRun: Boolean;
begin
  Result := IsMoved;
end;

function TibSHFieldOrderForm.GetCanRefresh: Boolean;
begin
  Result := True;
end;

procedure TibSHFieldOrderForm.Run;
var
  I: Integer;
  OldStatement: Boolean;
  SQL, SQLRun, SQLRunned: string;
  Node: PVirtualNode;
  NodeData: PTreeRec;

  function GetNormalizeName(const ACaption: string): string;
  var
    vCodeNormalizer: IibSHCodeNormalizer;
  begin
    Result := ACaption;
    if Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer) then
      Result := vCodeNormalizer.MetadataNameToSourceDDL(DBTable.BTCLDatabase, Result);
  end;
begin
  Editor.Lines.Clear;
  SQLRunned := EmptyStr;

  OldStatement := AnsiSameText(DBTable.BTCLDatabase.BTCLServer.Version, SInterBase4x) or
                  AnsiSameText(DBTable.BTCLDatabase.BTCLServer.Version, SInterBase5x);

  if OldStatement then
    SQL := FormatSQL(SQL_SET_FIELD_POSITION1)
  else
    SQL := FormatSQL(SQL_SET_FIELD_POSITION3);

  try
    DBTable.BTCLDatabase.DRVQuery.Transaction.Params.Text := TRWriteParams;

    Node := Tree.GetFirst;
    while Assigned(Node) do
    begin
      NodeData := Tree.GetNodeData(Node);
      if Assigned(NodeData) then
      begin
        if OldStatement then
          SQLRun := Format(SQL, [Node.Index + 1, DBTable.Caption, NodeData.Name])
        else
          SQLRun := Format(SQL, [GetNormalizeName(DBTable.Caption), GetNormalizeName(NodeData.Name), Node.Index + 1]);
        DBTable.BTCLDatabase.DRVQuery.ExecSQL(SQLRun, [], False);
        SQLRunned := Format(SQLRunned + '%s%s', [SQLRun, SLineBreak]);
      end;
      Node := Tree.GetNext(Node);
    end;
  finally
    DBTable.BTCLDatabase.DRVQuery.Transaction.Commit;
    DBTable.BTCLDatabase.DRVQuery.Transaction.Params.Text := TRReadParams;
  end;

  IsMoved := False;
  for I := 0 to Pred(Component.ComponentForms.Count) do
  begin
    if Supports(Component.ComponentForms[I], ISHRunCommands) and
       (Component.ComponentForms[I] as ISHRunCommands).CanRefresh then
      (Component.ComponentForms[I] as ISHRunCommands).Refresh;
  end;
  if GetCanRefresh then Refresh;
  Editor.Lines.Add(Format('/* BT: Reorder fields for table "%s": */', [DBTable.Caption]));
  Editor.Lines.Add('');
  Designer.TextToStrings(SQLRunned, Editor.Lines);
  Editor.CaretY := Pred(Editor.Lines.Count);
  Editor.Lines.Add(Format('/* BT: complete */', []));
end;

procedure TibSHFieldOrderForm.Refresh;
begin
  if Assigned(DBTable) then
  begin
    DBTable.Refresh;
    RefreshData;
  end;
end;

function TibSHFieldOrderForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
  if Result then
  begin
    Editor.ReadOnly := True;
    Editor.Options := Editor.Options + [eoScrollPastEof];
//    Editor.Highlighter := nil;
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

function TibSHFieldOrderForm.GetCanDestroy: Boolean;
begin
  Result := inherited GetCanDestroy;
  if DBTable.BTCLDatabase.WasLostConnect then Exit;

  if IsMoved then
    case Designer.ShowMsg(Format('The order of fields has been changed. Apply changes?', [])) of
      IDCANCEL: IsMoved := True;
      IDYES: Run;
      IDNO: IsMoved := False;
    end;

  Result := not IsMoved;
end;

procedure TibSHFieldOrderForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
end;

{ Tree }

procedure TibSHFieldOrderForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHFieldOrderForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibSHFieldOrderForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
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

procedure TibSHFieldOrderForm.TreeGetText(Sender: TBaseVirtualTree;
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

procedure TibSHFieldOrderForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.Name)) <> 1 then
    Result := 1;
end;

procedure TibSHFieldOrderForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_UP) and (ssShift in Shift) and (ssCtrl in Shift) and GetCanMoveUp then MoveUp;
  if (Key = VK_DOWN) and (ssShift in Shift) and (ssCtrl in Shift) and GetCanMoveDown then MoveDown;
end;

procedure TibSHFieldOrderForm.TreeDblClick(Sender: TObject);
begin
//  ShowConstraint(csSource);
end;

procedure TibSHFieldOrderForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
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

procedure TibSHFieldOrderForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);
  Result := CompareStr(Data1.Name, Data2.Name);
end;

procedure TibSHFieldOrderForm.TreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
//  ShowSource;
end;

{ TibSHFieldOrderFormAction_ }

constructor TibSHFieldOrderFormAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;

  if Self is TibSHFieldOrderFormAction_Run then Tag := 1;
  if Self is TibSHFieldOrderFormAction_MoveUp then Tag := 2;
  if Self is TibSHFieldOrderFormAction_MoveDown then Tag := 3;
  if Self is TibSHFieldOrderFormAction_Refresh then Tag := 4;

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
      Caption := Format('%s', ['Move Up']);
      ShortCut := TextToShortCut('Ctrl+Up');
    end;
    3:
    begin
      Caption := Format('%s', ['Move Down']);
      ShortCut := TextToShortCut('Ctrl+Down');
    end;
    4:
    begin
      Caption := Format('%s', ['Refresh']);
    end;
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibSHFieldOrderFormAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHTable);
end;

procedure TibSHFieldOrderFormAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Move Up
    2: (Designer.CurrentComponentForm as IibSHFieldOrderForm).MoveUp;
    // Move Down
    3: (Designer.CurrentComponentForm as IibSHFieldOrderForm).MoveDown;
    // Refresh
    4: (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
  end;
end;

procedure TibSHFieldOrderFormAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHFieldOrderFormAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     Supports(Designer.CurrentComponentForm, IibSHFieldOrderForm) then
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
      // Move Up
      2:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as IibSHFieldOrderForm).CanMoveUp;
      end;
      // Move Down
      3:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as IibSHFieldOrderForm).CanMoveDown;
      end;
      // Refresh
      4:
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
