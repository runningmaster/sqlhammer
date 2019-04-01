unit ibSHDMLHistoryFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm, ibSHConsts,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, SynEdit, pSHSynEdit, SynEditTypes,
  VirtualTrees, Contnrs, ImgList, AppEvnts, ActnList, StrUtils, Menus,
  pSHSqlTxtRtns,
  ibSHValues;

type
  TibSHDMLHistoryForm = class(TibBTComponentForm, IibSHDMLHistoryForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    pSHSynEdit1: TpSHSynEdit;
    Tree: TVirtualStringTree;
    SaveDialog1: TSaveDialog;
    ImageList1: TImageList;
    procedure pSHSynEdit1DblClick(Sender: TObject);
    procedure TreeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pSHSynEdit1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FTopLine: Integer;
    FSQLParser: TSQLParser;
    FTreePopupMenu: TPopupMenu;
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
    procedure TreeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TreeDblClick(Sender: TObject);
    function CalcImageIndex(ASQLKind: TSQLKind): Integer;
    procedure SelectTopLineBlock(ATopLine: Integer);
    procedure DoOnEnter;
    function GetDMLHistory: IibSHDMLHistory;
  protected
    procedure FillPopupMenu; override;
    procedure DoOnPopup(Sender: TObject); override;
    procedure DoOnPopupTreeMenu(Sender: TObject);
    //Popup menu methods
    procedure mnSendToSQLEditorFromEditorClick(Sender: TObject);
    procedure mnSendToSQLEditorFromTreeClick(Sender: TObject);
    procedure mnDeleteStatementFromTreeClick(Sender: TObject);

    procedure FillTree(AStatementNo: Integer);
    { IibSHDMLHistoryForm }
    function GetRegionVisible: Boolean;
    procedure FillEditor;
    procedure ChangeNotification(AOldItem: Integer; Operation: TOperation);
    function GetCanSendToSQLEditor: Boolean;
    procedure IibSHDMLHistoryForm.SendToSQLEditor = ISendToSQLEditor;
    procedure ISendToSQLEditor;
    { ISHFileCommands }
    function GetCanSave: Boolean; override;
    procedure Save; override;
    procedure SaveAs; override;
    { ISHEditCommands }
    function GetCanClearAll: Boolean; override;
    procedure ClearAll; override;
    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanPause: Boolean; override;
    function GetCanRefresh: Boolean; override;
    procedure Run; override;
    procedure Pause; override;
    procedure Refresh; override;
    procedure ShowHideRegion(AVisible: Boolean); override;

    procedure SinhronizeTreeByEditor;
    procedure SendToSQLEditorFromTree;
    procedure SendToSQLEditor(const AStatementNo: Integer);
    function DoOnOptionsChanged: Boolean; override;
    procedure DoOnSpecialLineColors(Sender: TObject;
      Line: Integer; var Special: Boolean; var FG, BG: TColor); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    property DMLHistory: IibSHDMLHistory read GetDMLHistory;
    property TopLine: Integer read FTopLine write FTopLine;
  end;

var
  ibSHDMLHistoryForm: TibSHDMLHistoryForm;

implementation

uses
  ibSHMessages;

{$R *.dfm}

const
  img_select  = 6;
  img_update  = 7;
  img_insert  = 4;
  img_delete  = 8;
  img_execute = 5;
  img_other   = 3;

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    FirstWord: string;
    ExecutedAt: string;
    SQLKind: TSQLKind;
    TopLine: Integer;
    StatementNo: Integer;

    ExecuteTime: Cardinal;
    PrepareTime: Cardinal;
    FetchTime: Cardinal;
    IndexedReads: Cardinal;
    NonIndexedReads: Cardinal;
    Inserts: Cardinal;
    Updates: Cardinal;
    Deletes: Cardinal;

    ImageIndex: Integer;
  end;


{ TibSHDMLHistoryForm }

constructor TibSHDMLHistoryForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  FTreePopupMenu := TPopupMenu.Create(Self);
  FTreePopupMenu.OnPopup := DoOnPopupTreeMenu;
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
  FocusedControl := Editor;
  RegisterEditors;

  ShowHideRegion(False);
  DoOnOptionsChanged;

  Tree.OnGetNodeDataSize := TreeGetNodeDataSize;
  Tree.OnFreeNode := TreeFreeNode;
  Tree.OnGetImageIndex := TreeGetImageIndex;
  Tree.OnGetText := TreeGetText;
  Tree.OnDblClick := TreeDblClick;
  Tree.OnKeyDown := TreeKeyDown;
  Tree.PopupMenu := FTreePopupMenu;
  FSQLParser := TSQLParser.Create;
  FillEditor;
  CurrentFile := DMLHistory.GetHistoryFileName;
end;

destructor TibSHDMLHistoryForm.Destroy;
begin
  FTreePopupMenu.Free;
  FSQLParser.Free;
  inherited Destroy;
end;

function TibSHDMLHistoryForm.CalcImageIndex(ASQLKind: TSQLKind): Integer;
begin
  case ASQLKind of
    skUnknown, skDDL: Result := img_other;
    skSelect: Result := img_select;
    skUpdate: Result := img_update;
    skInsert: Result := img_insert;
    skDelete: Result := img_delete;
    skExecuteProc: Result := img_execute;
    skExecuteBlock: Result := img_execute;//!!!
    else
      Result := img_other;
  end;
end;

procedure TibSHDMLHistoryForm.SelectTopLineBlock(ATopLine: Integer);
var
  BlockBegin, BlockEnd: TBufferCoord;
begin
//  Editor.CaretY := ATopLine;
//  Editor.EnsureCursorPosVisibleEx(True);
  Editor.BeginUpdate;
  Editor.TopLine := ATopLine + 1;
  BlockBegin.Char := 1;
  BlockBegin.Line := ATopLine + 1;
  BlockEnd.Char := 0;
  BlockEnd.Line := ATopLine + 2;
  Editor.CaretXY := BlockBegin;
  Editor.BlockBegin := BlockBegin;
  Editor.BlockEnd := BlockEnd;
  Editor.LeftChar := 1;
  Editor.EndUpdate;
end;

procedure TibSHDMLHistoryForm.DoOnEnter;
var
  Data: PTreeRec;
begin
  if Assigned(Tree.FocusedNode) then
  begin
    Data := Tree.GetNodeData(Tree.FocusedNode);
    SelectTopLineBlock(Data.TopLine);
  end;
end;

function TibSHDMLHistoryForm.GetDMLHistory: IibSHDMLHistory;
begin
  Supports(Component, IibSHDMLHistory, Result);
end;

procedure TibSHDMLHistoryForm.FillPopupMenu;
begin
  if Assigned(EditorPopupMenu) then
  begin
    AddMenuItem(EditorPopupMenu.Items, SSendToSQLEditor,
      mnSendToSQLEditorFromEditorClick, ShortCut(VK_RETURN, [ssShift]));
    AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, -2);
  end;

  if Assigned(FTreePopupMenu) then
  begin
    AddMenuItem(FTreePopupMenu.Items, SSendToSQLEditor,
      mnSendToSQLEditorFromTreeClick, ShortCut(VK_RETURN, [ssShift]));

    AddMenuItem(FTreePopupMenu.Items, '-', nil, 0, -3);

    AddMenuItem(FTreePopupMenu.Items, SDeleteCurrentHistoryStatement,
      mnDeleteStatementFromTreeClick);
  end;
  inherited FillPopupMenu;
end;

procedure TibSHDMLHistoryForm.DoOnPopup(Sender: TObject);
var
  vCurrentMenuItem: TMenuItem;
begin
  vCurrentMenuItem := MenuItemByName(EditorPopupMenu.Items, SSendToSQLEditor);
  if Assigned(vCurrentMenuItem) then
  begin
    vCurrentMenuItem.Visible := GetCanSendToSQLEditor;
    vCurrentMenuItem.Enabled := GetCanSendToSQLEditor;
  end;
  vCurrentMenuItem := MenuItemByName(EditorPopupMenu.Items, '-', -2);
  if Assigned(vCurrentMenuItem) then
    vCurrentMenuItem.Visible := GetCanSendToSQLEditor;

  inherited DoOnPopup(Sender);
end;

procedure TibSHDMLHistoryForm.DoOnPopupTreeMenu(Sender: TObject);
var
  vCurrentMenuItem: TMenuItem;
begin
  vCurrentMenuItem := MenuItemByName(FTreePopupMenu.Items, SSendToSQLEditor);
  if Assigned(vCurrentMenuItem) then
  begin
    vCurrentMenuItem.Visible := GetCanSendToSQLEditor and Assigned(Tree.FocusedNode);
    vCurrentMenuItem.Enabled := GetCanSendToSQLEditor and Assigned(Tree.FocusedNode);
  end;
  vCurrentMenuItem := MenuItemByName(FTreePopupMenu.Items, '-', -2);
  if Assigned(vCurrentMenuItem) then
    vCurrentMenuItem.Visible := GetCanSendToSQLEditor and Assigned(Tree.FocusedNode);
  //Delete
  vCurrentMenuItem := MenuItemByName(FTreePopupMenu.Items, SDeleteCurrentHistoryStatement);
  if Assigned(vCurrentMenuItem) then
  begin
    vCurrentMenuItem.Visible := GetCanSendToSQLEditor and Assigned(Tree.FocusedNode);
    vCurrentMenuItem.Enabled := GetCanSendToSQLEditor and Assigned(Tree.FocusedNode);
  end;
  vCurrentMenuItem := MenuItemByName(FTreePopupMenu.Items, '-', -3);
  if Assigned(vCurrentMenuItem) then
    vCurrentMenuItem.Visible := GetCanSendToSQLEditor and Assigned(Tree.FocusedNode);
end;

procedure TibSHDMLHistoryForm.mnSendToSQLEditorFromEditorClick(
  Sender: TObject);
begin
  SinhronizeTreeByEditor;
  SendToSQLEditorFromTree;
end;

procedure TibSHDMLHistoryForm.mnSendToSQLEditorFromTreeClick(
  Sender: TObject);
begin
  SendToSQLEditorFromTree;
end;

procedure TibSHDMLHistoryForm.mnDeleteStatementFromTreeClick(
  Sender: TObject);
var
  NodeData: PTreeRec;
begin
  if Assigned(Tree.FocusedNode) then
  begin
    NodeData := Tree.GetNodeData(Tree.FocusedNode);
    DMLHistory.DeleteStatement(NodeData.StatementNo);
  end;
end;

procedure TibSHDMLHistoryForm.FillTree(AStatementNo: Integer);
var
  StatementNode: PVirtualNode;
  NodeData: PTreeRec;
  vItem: string;
  vPos: Integer;
  vStatistics: TStringList;
  function GetFirstWord: string;
  var
    I: Integer;
    vSQLText: string;
  begin
    I := FSQLParser.FirstPos;
    vSQLText := DMLHistory.Statement(AStatementNo);
    while (I < Length(vSQLText)) and (not (vSQLText[I] in CharsAfterClause)) do Inc(I);
    Result := Trim(AnsiUpperCase(System.Copy(vSQLText, FSQLParser.FirstPos, I - FSQLParser.FirstPos + 1)));
  end;
begin
  Tree.BeginUpdate;
  StatementNode := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(StatementNode);
  vItem := DMLHistory.Item(AStatementNo);
  vPos := Pos('*/', vItem);
  if vPos > 0 then
  begin
    NodeData.ExecutedAt := Trim(System.Copy(vItem, Length(sHistorySQLHeader) + 1, vPos - Length(sHistorySQLHeader) - 1));
  end
  else
    NodeData.ExecutedAt := DateTimeToStr(Now);
  FSQLParser.SQLText := DMLHistory.Statement(AStatementNo);
  NodeData.SQLKind := FSQLParser.SQLKind;
  NodeData.ImageIndex := CalcImageIndex(NodeData.SQLKind);

  NodeData.TopLine := Editor.Lines.Count;
  NodeData.StatementNo := AStatementNo;
  NodeData.FirstWord := GetFirstWord;

  vStatistics := TStringList.Create;
  try
    vStatistics.Text := DMLHistory.Statistics(AStatementNo);
    if vStatistics.Count > 0 then
    begin
      NodeData.ExecuteTime := StrToIntDef(vStatistics.Values[SHistoryExecute], 0);
      NodeData.PrepareTime := StrToIntDef(vStatistics.Values[SHistoryPrepare], 0);
      NodeData.FetchTime := StrToIntDef(vStatistics.Values[SHistoryFetch], 0);
      NodeData.IndexedReads := StrToIntDef(vStatistics.Values[SHistoryIndexedReads], 0);
      NodeData.NonIndexedReads := StrToIntDef(vStatistics.Values[SHistoryNonIndexedReads], 0);
      NodeData.Inserts := StrToIntDef(vStatistics.Values[SHistoryInserts], 0);
      NodeData.Updates := StrToIntDef(vStatistics.Values[SHistoryUpdates], 0);
      NodeData.Deletes := StrToIntDef(vStatistics.Values[SHistoryDeletes], 0);
    end;
  finally
    vStatistics.Free;
  end;
  Tree.EndUpdate;
end;

function TibSHDMLHistoryForm.GetRegionVisible: Boolean;
begin
  Result := Panel1.Visible;
end;

procedure TibSHDMLHistoryForm.FillEditor;
var
  I: Integer;
begin
  if Assigned(DMLHistory) then
  begin
    Tree.Clear;
    Editor.Clear;
    for I := 0 to Pred(DMLHistory.Count) do
    begin
      FillTree(I);
      Designer.TextToStrings(DMLHistory.Item(I), Editor.Lines);
    end;
    Editor.CaretY := Editor.Lines.Count;
    SinhronizeTreeByEditor;
    DoOnEnter;
  end;
//  Editor.Lines.Objects[Editor.Lines.Count - 1] := TObject(CalcImageIndex(EventDescr.OperationName));

//  SelectTopLineBlock(TopLine);
end;

procedure TibSHDMLHistoryForm.ChangeNotification(AOldItem: Integer; Operation: TOperation);
  procedure DeleteItem(AStatementNo: Integer);
  var
    Node: PVirtualNode;
    NextNode: PVirtualNode;
    NodeData: PTreeRec;
    vTopLine: Integer;
    I: Integer;
    vLinesDeleted: Integer;
  begin
    if AStatementNo > -1 then
    begin
      Node := Tree.GetLast;
      NextNode := nil;
      vTopLine := -1;
      //Удаляем старый нод
      while Assigned(Node) do
      begin
        NodeData := Tree.GetNodeData(Node);
        if NodeData.StatementNo = AStatementNo then
        begin
          vTopLine := NodeData.TopLine;
          NextNode := Tree.GetNextSibling(Node);
          Tree.DeleteNode(Node);
          Break;
        end
        else
          Node := Tree.GetPreviousSibling(Node);
      end;
      //Удаляем старый текст из эдитора
      vLinesDeleted := 0;
      if vTopLine > -1 then
      begin
        if vTopLine < Editor.Lines.Count then
          Editor.Lines.Delete(vTopLine);
        Inc(vLinesDeleted);  
        while (vTopLine < Editor.Lines.Count) and
          (Pos(sHistorySQLHeader, Editor.Lines[vTopLine]) = 0) do
        begin
          Inc(vLinesDeleted);
          Editor.Lines.Delete(vTopLine);
        end;
      end;
      //Переиндексируем все ноды после удаленного
      I := AStatementNo;
      while Assigned(NextNode) do
      begin
        NodeData := Tree.GetNodeData(NextNode);
        NodeData.StatementNo := I;
        NodeData.TopLine := NodeData.TopLine - vLinesDeleted;
        Inc(I);
        NextNode := Tree.GetNextSibling(NextNode);
      end;
    end;
  end;
begin
  if Assigned(DMLHistory) then
  begin
    if Operation = opInsert then
    begin
      DeleteItem(AOldItem);
      FillTree(DMLHistory.Count - 1);
      Designer.TextToStrings(DMLHistory.Item(DMLHistory.Count - 1), Editor.Lines);
      Editor.CaretY := Editor.Lines.Count;
      SinhronizeTreeByEditor;
      DoOnEnter;
    end
    else
    begin
      DeleteItem(AOldItem);
    end;
  end;
end;

function TibSHDMLHistoryForm.GetCanSendToSQLEditor: Boolean;
begin
   Result := Assigned(Designer.GetComponent(IibSHSQLEditor)) and
     Assigned(DMLHistory) and (DMLHistory.Count > 0) and
     DMLHistory.BTCLDatabase.Connected;
end;

procedure TibSHDMLHistoryForm.ISendToSQLEditor;
begin
  SinhronizeTreeByEditor;
  SendToSQLEditorFromTree;
end;

function TibSHDMLHistoryForm.GetCanSave: Boolean;
begin
  Result := Assigned(DMLHistory);
end;

procedure TibSHDMLHistoryForm.Save;
begin
  if GetCanSave then
    DMLHistory.SaveToFile;
end;

procedure TibSHDMLHistoryForm.SaveAs;
begin
  if GetCanSaveAs then
  begin
    FSaveDialog.FileName := DoOnGetInitialDir + DMLHistory.BTCLDatabase.Alias + ' ' + Component.Caption;
    if FSaveDialog.Execute then
    begin
      Screen.Cursor := crHourGlass;
      try
        DoSaveToFile(FSaveDialog.FileName);
      finally
        Screen.Cursor := crDefault;
      end;
    end;
    ShowFileName;
  end;
end;

function TibSHDMLHistoryForm.GetCanClearAll: Boolean;
begin
  Result := Assigned(DMLHistory) and (DMLHistory.Count > 0);
end;

procedure TibSHDMLHistoryForm.ClearAll;
begin
  if GetCanClearAll and
    Designer.ShowMsg(Format(SClearDMLHistoryWorning,
      [DMLHistory.BTCLDatabase.Alias]), mtConfirmation) then
  begin
    DMLHistory.Clear;
  end;
end;

function TibSHDMLHistoryForm.GetCanRun: Boolean;
begin
  Result := Assigned(DMLHistory) and not DMLHistory.Active;
end;

function TibSHDMLHistoryForm.GetCanPause: Boolean;
begin
  Result := Assigned(DMLHistory) and DMLHistory.Active;
end;

function TibSHDMLHistoryForm.GetCanRefresh: Boolean;
begin
  Result := Assigned(DMLHistory) and Assigned(Editor) and Editor.Modified;
end;

procedure TibSHDMLHistoryForm.Run;
begin
  if Assigned(DMLHistory) then
  begin
    DMLHistory.Active := True;
    Designer.UpdateObjectInspector;
  end;
end;

procedure TibSHDMLHistoryForm.Pause;
begin
  if Assigned(DMLHistory) then
  begin
    DMLHistory.Active := False;
    Designer.UpdateObjectInspector;
  end;
end;

procedure TibSHDMLHistoryForm.Refresh;
begin
  if GetCanRefresh then
  begin
    Save;
    DMLHistory.LoadFromFile;
    FillEditor;
  end;
end;

procedure TibSHDMLHistoryForm.ShowHideRegion(AVisible: Boolean);
begin
  Panel1.Visible := AVisible;
  Splitter1.Visible := AVisible;
  if AVisible then Splitter1.Left := Panel1.Left + Panel1.Width + 1;
end;

procedure TibSHDMLHistoryForm.SinhronizeTreeByEditor;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Node := Tree.GetLast;
  if Assigned(Node) then
  begin
    NodeData := Tree.GetNodeData(Node);
    while Assigned(Node) and (NodeData.TopLine > (Editor.CaretY - 1)) do
    begin
      Node := Tree.GetPrevious(Node);
      NodeData := Tree.GetNodeData(Node);
    end;
    if Assigned(Node) then
      Tree.FocusedNode := Node
    else
      Tree.FocusedNode := Tree.GetLast;
    Tree.Selected[Tree.FocusedNode] := True;
  end;
end;

procedure TibSHDMLHistoryForm.SendToSQLEditorFromTree;
var
  NodeData: PTreeRec;
begin
  if Assigned(Tree.FocusedNode) then
  begin
    NodeData := Tree.GetNodeData(Tree.FocusedNode);
    SendToSQLEditor(NodeData.StatementNo);
  end;
end;

procedure TibSHDMLHistoryForm.SendToSQLEditor(const AStatementNo: Integer);
var
  vComponent: TSHComponent;
  vSQLEditorForm: IibSHSQLEditorForm;
  function TrimLeftEpmtyStr(AString: string): string;
  var
    vStrList: TStringList;
  begin
    vStrList := TStringList.Create;
    Result := AString;
    try
      vStrList.Text := AString;
      while (vStrList.Count > 0) and (Length(vStrList[0]) = 0) do
        vStrList.Delete(0);
      Result := TrimRight(vStrList.Text);
    finally
      vStrList.Free;
    end;
  end;
begin
  if Assigned(DMLHistory) and (AStatementNo >= 0) and
    (AStatementNo < DMLHistory.Count) then
  begin
    vComponent := Designer.FindComponent(Component.OwnerIID, IibSHSQLEditor);
    if not Assigned(vComponent) then
      vComponent := Designer.CreateComponent(Component.OwnerIID, IibSHSQLEditor, '');
    if Assigned(vComponent) then
    begin
      Designer.ChangeNotification(vComponent, SCallSQLText, opInsert);
      if vComponent.GetComponentFormIntf(IibSHSQLEditorForm, vSQLEditorForm) then
      begin
        vSQLEditorForm.InsertStatement(TrimLeftEpmtyStr(DMLHistory.Statement(AStatementNo)));
        Designer.JumpTo(Component.InstanceIID, IibSHSQLEditor, vComponent.Caption);
//        Designer.ChangeNotification(vComponent, SCallSQLText, opInsert);
      end;
    end;  
  end;
end;

function TibSHDMLHistoryForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
  if Result then
  begin
    Editor.ReadOnly := True;
    Editor.Options := Editor.Options + [eoScrollPastEof];
//    Editor.RightEdge := 0;
//    Editor.BottomEdgeVisible := False;
  end;
end;

procedure TibSHDMLHistoryForm.DoOnSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
begin
  Special := False;
  if (Pos('->', pSHSynEdit1.Lines[Line - 1]) > 0) then
  begin
    Special := True;
    FG := RGB(130, 220, 160);
  end else
    if (Pos('<-', pSHSynEdit1.Lines[Line - 1]) > 0) then
    begin
      Special := True;
      FG := RGB(140,170, 210);
    end else
      if (Pos('>>', pSHSynEdit1.Lines[Line - 1]) > 0) then
      begin
        Special := True;
        BG := RGB(235, 235, 235);
        FG := RGB(140, 170, 210);
      end;
end;

procedure TibSHDMLHistoryForm.pSHSynEdit1DblClick(Sender: TObject);
begin
  SinhronizeTreeByEditor;
end;

procedure TibSHDMLHistoryForm.TreeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (ssCtrl in Shift) then
    SendToSQLEditorFromTree;
end;

procedure TibSHDMLHistoryForm.pSHSynEdit1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (ssCtrl in Shift) then
  begin
    SinhronizeTreeByEditor;
    SendToSQLEditorFromTree;
  end;
end;

{ Tree }

procedure TibSHDMLHistoryForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHDMLHistoryForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibSHDMLHistoryForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
//  ImageIndex := -1;
//  Data := Sender.GetNodeData(Node);
//  if Tree.Header.Columns[Column].Tag = 9 then
//    ImageIndex := CalcImageIndex(Data.SQLKind)
//  else
//    ImageIndex := -1;
//  if (Kind = ikNormal) or (Kind = ikSelected) then ImageIndex := CalcImageIndex(Data.SQLKind);
  if (Kind = ikNormal) or (Kind = ikSelected) then
  begin
    ImageIndex := -1;
    if (Tree.Header.Columns[Column].Tag = 9) and Assigned(Node) then
    begin
      Data := Sender.GetNodeData(Node);
      if Assigned(Data) then
        ImageIndex := Data.ImageIndex;
    end;
  end;  
end;

procedure TibSHDMLHistoryForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  case TextType of
    ttNormal:
      begin
        case Tree.Header.Columns[Column].Tag of
          0: CellText := Data.ExecutedAt;
          1: CellText := msToStr(Data.ExecuteTime);
          2: CellText := msToStr(Data.PrepareTime);
          3: CellText := msToStr(Data.FetchTime);
          4: CellText := FormatFloat('###,###,###,##0', Data.IndexedReads);
          5: CellText := FormatFloat('###,###,###,##0', Data.NonIndexedReads);
          6: CellText := FormatFloat('###,###,###,##0', Data.Inserts);
          7: CellText := FormatFloat('###,###,###,##0', Data.Updates);
          8: CellText := FormatFloat('###,###,###,##0', Data.Deletes);
          9: CellText := Data.FirstWord;
        end;
      end;
  end;
end;

procedure TibSHDMLHistoryForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then DoOnEnter;
end;

procedure TibSHDMLHistoryForm.TreeDblClick(Sender: TObject);
begin
  DoOnEnter;
end;

end.
