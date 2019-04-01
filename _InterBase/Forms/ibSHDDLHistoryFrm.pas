unit ibSHDDLHistoryFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm, ibSHConsts,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, SynEdit, pSHSynEdit, SynEditTypes,
  VirtualTrees, Contnrs, ImgList, AppEvnts, ActnList, StrUtils, Menus,
  pSHSqlTxtRtns, pSHStrUtil,
  ibSHValues;

type
  TibSHDDLHistoryForm = class(TibBTComponentForm, IibSHDDLHistoryForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    pSHSynEdit1: TpSHSynEdit;
    Tree: TVirtualStringTree;
    SaveDialog1: TSaveDialog;
    ImageList1: TImageList;
    procedure pSHSynEdit1DblClick(Sender: TObject);
  private
    { Private declarations }
    FTopLine: Integer;
    FSQLParser: TSQLParser;
    FTreePopupMenu: TPopupMenu;
    FFirstWord: string;
    FStatementsLoaded: Integer;
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
    function GetDDLHistory: IibSHDDLHistory;
  protected
    function GetCurrentFile: string; override;
    procedure FillPopupMenu; override;
    procedure DoOnPopup(Sender: TObject); override;
    //Popup menu methods
    procedure mnSendToSQLPlayerClick(Sender: TObject);

    procedure DoFindOperation(Position:integer;var StopScan:boolean);
    procedure FillTree(AStatementNo: Integer);
    { IibSHDDLHistoryForm }
    function GetRegionVisible: Boolean;
    procedure FillEditor;
    procedure ChangeNotification;
    function GetCanSendToSQLPlayer: Boolean;
    procedure SendToSQLPlayer;
    function GetCanSendToSQLEditor: Boolean;
    procedure SendToSQLEditor;
    { ISHFileCommands }
    function GetCanSave: Boolean; override;

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
    function DoOnOptionsChanged: Boolean; override;
    procedure DoOnSpecialLineColors(Sender: TObject;
      Line: Integer; var Special: Boolean; var FG, BG: TColor); override;

    function GetCanDestroy: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    property DDLHistory: IibSHDDLHistory read GetDDLHistory;
    property TopLine: Integer read FTopLine write FTopLine;
  end;

var
  ibSHDDLHistoryForm: TibSHDDLHistoryForm;

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

  img_grant  = 6;
  img_alter  = 7;
  img_create  = 4;
  img_drop  = 8;

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    FirstWord: string;
    ExecutedAt: string;
    SQLKind: TSQLKind;
    TopLine: Integer;
    StatementNo: Integer;

    ImageIndex: Integer;
  end;

{ TibBTSQLMonitorForm }

constructor TibSHDDLHistoryForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  FTreePopupMenu := TPopupMenu.Create(Self);
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
  FocusedControl := Editor;

  RegisterEditors;
//  with TGutterMarkDrawPlugin.Create(pSHSynEdit1) do ImageList := ImageList1;
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
end;

destructor TibSHDDLHistoryForm.Destroy;
begin
  FTreePopupMenu.Free;
  FSQLParser.Free;
  inherited Destroy;
end;

function TibSHDDLHistoryForm.CalcImageIndex(ASQLKind: TSQLKind): Integer;
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

procedure TibSHDDLHistoryForm.SelectTopLineBlock(ATopLine: Integer);
var
  BlockBegin, BlockEnd: TBufferCoord;
begin
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

procedure TibSHDDLHistoryForm.DoOnEnter;
var
  Data: PTreeRec;
begin
  if Assigned(Tree.FocusedNode) then
  begin
    Data := Tree.GetNodeData(Tree.FocusedNode);
    SelectTopLineBlock(Data.TopLine);
  end;
end;

function TibSHDDLHistoryForm.GetDDLHistory: IibSHDDLHistory;
begin
  Supports(Component, IibSHDDLHistory, Result);
end;

function TibSHDDLHistoryForm.GetCurrentFile: string;
begin
  if Assigned(DDLHistory) then
    Result := DDLHistory.GetHistoryFileName
  else
    Result := EmptyStr;
end;

procedure TibSHDDLHistoryForm.FillPopupMenu;
begin
  if Assigned(EditorPopupMenu) then
  begin
    AddMenuItem(EditorPopupMenu.Items, SSendToSQLPlayer,
      mnSendToSQLPlayerClick, ShortCut(VK_RETURN, [ssShift]));
    AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, -2);
  end;
  if Assigned(FTreePopupMenu) then
  begin
    AddMenuItem(FTreePopupMenu.Items, SSendToSQLPlayer,
      mnSendToSQLPlayerClick, ShortCut(VK_RETURN, [ssShift]));
  end;
  inherited FillPopupMenu;
end;

procedure TibSHDDLHistoryForm.DoOnPopup(Sender: TObject);
var
  vCurrentMenuItem: TMenuItem;
  vIsSQLScriptInstalled: Boolean;
begin
  inherited DoOnPopup(Sender);
  vIsSQLScriptInstalled := Assigned(Designer.GetComponent(IibSHSQLPlayer)) ;
  vCurrentMenuItem := MenuItemByName(FTreePopupMenu.Items, SSendToSQLPlayer);
  if Assigned(vCurrentMenuItem) then
  begin
    vCurrentMenuItem.Visible := vIsSQLScriptInstalled and (not Editor.IsEmpty);
    vCurrentMenuItem.Enabled := vIsSQLScriptInstalled and (not Editor.IsEmpty);
  end;
  vCurrentMenuItem := MenuItemByName(FTreePopupMenu.Items, '-', -2);
  if Assigned(vCurrentMenuItem) then
    vCurrentMenuItem.Visible := vIsSQLScriptInstalled and (not Editor.IsEmpty);
end;

procedure TibSHDDLHistoryForm.mnSendToSQLPlayerClick(Sender: TObject);
begin
  SendToSQLPlayer;
end;

procedure TibSHDDLHistoryForm.DoFindOperation(Position: integer;
  var StopScan: boolean);
begin
  StopScan := False;
  if ( not (FSQLParser.SQLText[Position] in CharsAfterClause)) then
    FFirstWord := FFirstWord + FSQLParser.SQLText[Position]
  else
  begin
    if (Length(FFirstWord) > 1) and
       (not SameText(FFirstWord, 'SET')) and
       (not SameText(FFirstWord, 'TERM')) then
    begin
      if SameText(FFirstWord, 'GENERATOR') then
        FFirstWord := 'SET';
      StopScan := True
    end
    else
      FFirstWord := EmptyStr;
  end;
end;

procedure TibSHDDLHistoryForm.FillTree(AStatementNo: Integer);
var
  StatementNode: PVirtualNode;
  NodeData: PTreeRec;
  vItem: string;
  vPos: Integer;
  function GetFirstWord: string;
  begin
    FFirstWord := EmptyStr;
    FSQLParser.ScanText(FSQLParser.FirstPos, DoFindOperation);
    Result := AnsiUpperCase(FFirstWord);
    if Length(Result) = 0 then
      Result := 'SQL';
  end;
begin
  Tree.BeginUpdate;
  StatementNode := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(StatementNode);
  vItem := DDLHistory.Item(AStatementNo);
  vPos := Pos('*/', vItem);
  if vPos > 0 then
  begin
    NodeData.ExecutedAt := Trim(System.Copy(vItem, Length(sHistorySQLHeader) + 1, vPos - Length(sHistorySQLHeader) - 1));
  end
  else
    NodeData.ExecutedAt := DateTimeToStr(Now);
  FSQLParser.SQLText := DDLHistory.Statement(AStatementNo);
  NodeData.SQLKind := FSQLParser.SQLKind;
  NodeData.ImageIndex := CalcImageIndex(NodeData.SQLKind);
  NodeData.TopLine := Editor.Lines.Count;
  NodeData.StatementNo := AStatementNo;
  NodeData.FirstWord := GetFirstWord;
  if AnsiCompareStr(NodeData.FirstWord, 'CREATE') = 0 then
    NodeData.ImageIndex := img_create else
  if AnsiCompareStr(NodeData.FirstWord, 'ALTER') = 0 then
    NodeData.ImageIndex := img_alter else
  if AnsiCompareStr(NodeData.FirstWord, 'DROP') = 0 then
    NodeData.ImageIndex := img_drop else
  if AnsiCompareStr(NodeData.FirstWord, 'GRANT') = 0 then
    NodeData.ImageIndex := img_grant;
  Tree.EndUpdate;
end;

function TibSHDDLHistoryForm.GetRegionVisible: Boolean;
begin
  Result := Panel1.Visible; 
end;

procedure TibSHDDLHistoryForm.FillEditor;
var
  I: Integer;
begin
  if Assigned(DDLHistory) then
  begin
    Tree.Clear;
    Editor.Clear;
    for I := 0 to Pred(DDLHistory.Count) do
    begin
      FillTree(I);
      Designer.TextToStrings(DDLHistory.Item(I), Editor.Lines);
    end;
    FStatementsLoaded := DDLHistory.Count;
    Editor.CaretY := Editor.Lines.Count;
    SinhronizeTreeByEditor;
    DoOnEnter;
  end;
end;

procedure TibSHDDLHistoryForm.ChangeNotification;
var
  I: Integer;
begin
  if Assigned(DDLHistory) and Assigned(Editor) then
  begin
    if Editor.Modified then
    begin
      for I := FStatementsLoaded to Pred(DDLHistory.Count) do
        Designer.TextToStrings(DDLHistory.Item(I), Editor.Lines);
      Save;
      Refresh;
    end
    else
    begin
      for I := FStatementsLoaded to Pred(DDLHistory.Count) do
      begin
        FillTree(I);
        Designer.TextToStrings(DDLHistory.Item(I), Editor.Lines);
      end;
      FStatementsLoaded := DDLHistory.Count;
      Save;
      Editor.CaretY := Editor.Lines.Count;
      SinhronizeTreeByEditor;
      DoOnEnter;
    end;
  end;
end;

function TibSHDDLHistoryForm.GetCanSendToSQLPlayer: Boolean;
begin
   Result := Assigned(Designer.GetComponent(IibSHSQLPlayer)) and
     Assigned(DDLHistory) and (DDLHistory.Count > 0) and
     DDLHistory.BTCLDatabase.Connected;
end;

procedure TibSHDDLHistoryForm.SendToSQLPlayer;
var
  vComponent: TSHComponent;
  vSQLPlayerForm: IibSHSQLPlayerForm;
begin
  if GetCanSendToSQLPlayer then
  begin
    vComponent := Designer.CreateComponent(Component.OwnerIID, IibSHSQLPlayer, '');
    if Assigned(vComponent) then
      if vComponent.GetComponentFormIntf(IibSHSQLPlayerForm, vSQLPlayerForm) then
      begin
        vSQLPlayerForm.InsertScript(Editor.Lines.Text);
        Designer.JumpTo(Component.InstanceIID, IibSHSQLPlayer, vComponent.Caption);
        Designer.ChangeNotification(vComponent, SCallSQLStatements, opInsert);
      end;
  end;
end;

function TibSHDDLHistoryForm.GetCanSendToSQLEditor: Boolean;
begin
   Result := Assigned(Designer.GetComponent(IibSHSQLEditor)) and
     Assigned(DDLHistory) and (DDLHistory.Count > 0) and
     DDLHistory.BTCLDatabase.Connected;
end;

procedure TibSHDDLHistoryForm.SendToSQLEditor;
var
  vDDLInfo: IibSHDDLInfo;
  vComponent: TSHComponent;
  vDDLForm: IibSHDDLForm;
  NodeData: PTreeRec;
begin
  SinhronizeTreeByEditor;
  if Assigned(Tree.FocusedNode) then
  begin
    NodeData := Tree.GetNodeData(Tree.FocusedNode);
    if Assigned(DDLHistory) and (NodeData.StatementNo >= 0) and
      (NodeData.StatementNo < DDLHistory.Count) then
    begin
      vComponent := Designer.FindComponent(Component.OwnerIID, IibSHSQLEditor);
      if not Assigned(vComponent) then
        vComponent := Designer.CreateComponent(Component.OwnerIID, IibSHSQLEditor, '');
      if Assigned(vComponent) and Supports(vComponent, IibSHDDLInfo, vDDLInfo) then
      begin
        vDDLInfo.DDL.Text := Trim(DDLHistory.Statement(NodeData.StatementNo));
        Designer.JumpTo(Component.InstanceIID, IibSHSQLEditor, vComponent.Caption);
        Designer.ChangeNotification(vComponent, SCallDDLText, opInsert);
        if vComponent.GetComponentFormIntf(IibSHDDLForm, vDDLForm) then
          vDDLForm.ShowDDLText;
      end;
    end;
  end;    
end;

function TibSHDDLHistoryForm.GetCanSave: Boolean;
begin
  Result := Assigned(DDLHistory);
end;

procedure TibSHDDLHistoryForm.SaveAs;
begin
  if GetCanSaveAs then
  begin
    FSaveDialog.FileName := DoOnGetInitialDir + DDLHistory.BTCLDatabase.Alias + ' ' + Component.Caption;
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

function TibSHDDLHistoryForm.GetCanClearAll: Boolean;
begin
  Result := Assigned(DDLHistory) and (DDLHistory.Count > 0);
end;

procedure TibSHDDLHistoryForm.ClearAll;
begin
  if GetCanClearAll and
    Designer.ShowMsg(Format(SClearDDLHistoryWorning,
      [DDLHistory.BTCLDatabase.Alias]), mtConfirmation) then
  begin
    inherited ClearAll;
    DDLHistory.Clear;
  end;
end;

function TibSHDDLHistoryForm.GetCanRun: Boolean;
begin
  Result := Assigned(DDLHistory) and not DDLHistory.Active;
end;

function TibSHDDLHistoryForm.GetCanPause: Boolean;
begin
  Result := Assigned(DDLHistory) and DDLHistory.Active;
end;

function TibSHDDLHistoryForm.GetCanRefresh: Boolean;
begin
  Result := Assigned(DDLHistory) and Assigned(Editor);// and Editor.Modified;  
end;

procedure TibSHDDLHistoryForm.Run;
begin
  if Assigned(DDLHistory) then
  begin
    DDLHistory.Active := True;
    Designer.UpdateObjectInspector;
  end;
end;

procedure TibSHDDLHistoryForm.Pause;
begin
  if Assigned(DDLHistory) then
  begin
    DDLHistory.Active := False;
    Designer.UpdateObjectInspector;
  end;
end;

procedure TibSHDDLHistoryForm.Refresh;
begin
  if GetCanRefresh then
  begin
//    Save;
    DDLHistory.LoadFromFile;
    FillEditor;
  end;
end;

procedure TibSHDDLHistoryForm.ShowHideRegion(AVisible: Boolean);
begin
  Panel1.Visible := AVisible;
  Splitter1.Visible := AVisible;
  if AVisible then Splitter1.Left := Panel1.Left + Panel1.Width + 1;
end;

procedure TibSHDDLHistoryForm.SinhronizeTreeByEditor;
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

function TibSHDDLHistoryForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
  if Result then
  begin
    Editor.Options := Editor.Options + [eoScrollPastEof];
  end;
end;

procedure TibSHDDLHistoryForm.DoOnSpecialLineColors(Sender: TObject;
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

procedure TibSHDDLHistoryForm.pSHSynEdit1DblClick(Sender: TObject);
begin
  SinhronizeTreeByEditor;
end;

{ Tree }

procedure TibSHDDLHistoryForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHDDLHistoryForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibSHDDLHistoryForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  if (Kind = ikNormal) or (Kind = ikSelected) then
  begin
    ImageIndex := -1;
    if Assigned(Node) then
    begin
      Data := Sender.GetNodeData(Node);
      if (Tree.Header.Columns[Column].Tag = 0) and Assigned(Data) then
        ImageIndex := Data.ImageIndex;
    end;
  end;
end;

procedure TibSHDDLHistoryForm.TreeGetText(Sender: TBaseVirtualTree;
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
          0: CellText := Data.FirstWord;
          1: CellText := Data.ExecutedAt;
        end;
      end;
  end;
end;

procedure TibSHDDLHistoryForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then DoOnEnter;
end;

procedure TibSHDDLHistoryForm.TreeDblClick(Sender: TObject);
begin
  DoOnEnter;
end;

function TibSHDDLHistoryForm.GetCanDestroy: Boolean;
begin
  Save;
  Result := inherited GetCanDestroy;
end;

end.
