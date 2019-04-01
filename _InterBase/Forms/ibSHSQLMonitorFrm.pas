unit ibSHSQLMonitorFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, SynEdit, pSHSynEdit, SynEditTypes,
  VirtualTrees, Contnrs, ImgList, AppEvnts, ActnList, StrUtils, Menus;

type
  TEventDescr = class
  private
    FNumber: Integer;
    FApplicationName: string;
    FOperationName: string;
    FObjectName: string;
    FLongTime: string;
    FShortTime: string;
    FSQLText: string;
  public
    property Number: Integer read FNumber write FNumber;
    property ApplicationName: string read FApplicationName write FApplicationName;
    property OperationName: string read FOperationName write FOperationName;
    property ObjectName: string read FObjectName write FObjectName;
    property LongTime: string read FLongTime write FLongTime;
    property ShortTime: string read FShortTime write FShortTime;
    property SQLText: string read FSQLText write FSQLText;
  end;

  TibSHSQLMonitorForm = class(TibBTComponentForm, IibSHSQLMonitorForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    pSHSynEdit1: TpSHSynEdit;
    Panel4: TPanel;
    Bevel1: TBevel;
    HeaderControl1: THeaderControl;
    pSHSynEdit2: TpSHSynEdit;
    Splitter2: TSplitter;
    Tree: TVirtualStringTree;
    ImageList1: TImageList;
    ApplicationEvents1: TApplicationEvents;
    SaveDialog1: TSaveDialog;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure pSHSynEdit1DblClick(Sender: TObject);
  private
    { Private declarations }
    FSQLMonitorIntf: IibSHSQLMonitor;
    FEventList: TObjectList;
    FTopLine: Integer;
    FBTCLServerIntf: IibSHServer;
    FBTCLDatabase: TComponent;
    FBTCLDatabaseIntf: IibSHDatabase;
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

    procedure ShowMessages;
    procedure HideMessages;
    procedure OnEvent(ApplicationName, OperationName, ObjectName, LongTime, ShortTime, SQLText: string);
    function CalcImageIndex(OperationName: string): Integer;
    procedure FillTree(EventDescr: TEventDescr);
    procedure FillEditor(EventDescr: TEventDescr);
    procedure GutterDrawNotify(Sender: TObject; ALine: Integer; var ImageIndex: Integer);
    procedure WriteInfoLine(S: string);
    procedure WritePropsLine;
    procedure SelectTopLineBlock(ATopLine: Integer);
    procedure DoOnEnter;
  protected
    procedure RegisterEditors; override;
    { ISHFileCommands }
    function GetCanSave: Boolean; override;
    procedure Save; override;
    { ISHEditCommands }
    function GetCanClearAll: Boolean; override;
    procedure ClearAll; override;
    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanPause: Boolean; override;
    procedure Run; override;
    procedure Pause; override;
    procedure ShowHideRegion(AVisible: Boolean); override;
    { IibSHSQLMonitorForm }
    function CanJumpToApplication: Boolean;
    procedure JumpToApplication;

    procedure DoOnIdle; override;
    function DoOnOptionsChanged: Boolean; override;
    procedure DoOnSpecialLineColors(Sender: TObject;
      Line: Integer; var Special: Boolean; var FG, BG: TColor); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    property SQLMonitor: IibSHSQLMonitor read FSQLMonitorIntf;
    property EventList: TObjectList read FEventList;
    property TopLine: Integer read FTopLine write FTopLine;
    property BTCLServer: IibSHServer read FBTCLServerIntf;
    property BTCLDatabase: IibSHDatabase read FBTCLDatabaseIntf;
  end;

var
  ibSHSQLMonitorForm: TibSHSQLMonitorForm;

implementation

uses
  ibSHMessages;

{$R *.dfm}

const
  img_dac_engine  = 3;
  img_application = 4;
  img_connect     = 5; // Connect, Disconnect
  img_transact    = 6; // Start, Commit, Rollback
  img_prepare     = 7; // Prepare
  img_execute     = 8; // Execute
  img_fetch       = 9; // Fetch
  img_other       = 10; // Other

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    NormalText: string;
    StaticText: string;

    Number: string;
    ApplicationName: string;
    OperationName: string;
    ObjectName: string;
    ShortTime: string;

    TopLine: Integer;
    ImageIndex: Integer;
  end;

{ TibBTSQLMonitorForm }

constructor TibSHSQLMonitorForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  FEventList := TObjectList.Create;
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHSQLMonitor, FSQLMonitorIntf);
  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
  Editor.OnGutterDraw := GutterDrawNotify;
  Editor.GutterDrawer.ImageList := ImageList1;
  Editor.GutterDrawer.Enabled := True;
  FocusedControl := Editor;

  RegisterEditors;

  if Assigned(SQLMonitor) then SQLMonitor.OnEvent := OnEvent;
  if Assigned(SQLMonitor) then SQLMonitor.Active := False;
  ShowHideRegion(False);
  ShowMessages;
  HideMessages;
  DoOnOptionsChanged;

  Tree.OnGetNodeDataSize := TreeGetNodeDataSize;
  Tree.OnFreeNode := TreeFreeNode;
  Tree.OnGetImageIndex := TreeGetImageIndex;
  Tree.OnGetText := TreeGetText;
  Tree.OnPaintText := TreePaintText;
  Tree.OnIncrementalSearch := TreeIncrementalSearch;
  Tree.OnDblClick := TreeDblClick;
  Tree.OnKeyDown := TreeKeyDown;
  Tree.OnGetPopupMenu := TreeGetPopupMenu;
  Tree.OnCompareNodes := TreeCompareNodes;

  Run;
end;

destructor TibSHSQLMonitorForm.Destroy;
begin
  if Assigned(SQLMonitor) then SQLMonitor.Active := False;
  FEventList.Free;
  inherited Destroy;
end;

procedure TibSHSQLMonitorForm.ShowMessages;
begin
  Panel4.Visible := True;
  Splitter2.Visible := True;
  HeaderControl1.Repaint;
  HeaderControl1.Invalidate;
end;

procedure TibSHSQLMonitorForm.HideMessages;
begin
  Panel4.Visible := False;
  Splitter2.Visible := False;
end;

procedure TibSHSQLMonitorForm.OnEvent(ApplicationName, OperationName, ObjectName, LongTime, ShortTime, SQLText: string);
var
  vEventDescr: TEventDescr;
begin
  vEventDescr := TEventDescr.Create;
  vEventDescr.ApplicationName := ApplicationName;
  vEventDescr.OperationName := OperationName;
  vEventDescr.ObjectName := ObjectName;
  vEventDescr.LongTime := LongTime;
  vEventDescr.ShortTime := ShortTime;
  vEventDescr.SQLText := SQLText;
  EventList.Add(vEventDescr);
  vEventDescr.Number := EventList.Count;
  if Assigned(SQLMonitor) then
  begin
    if Length(Trim(SQLMonitor.Filter.Text)) > 0 then
      if SQLMonitor.Filter.IndexOf(ObjectName) = -1 then Exit;
  end;
  FillEditor(vEventDescr);
  Application.ProcessMessages;
end;

function TibSHSQLMonitorForm.CalcImageIndex(OperationName: string): Integer;
begin
  if (Pos('Connect', OperationName) = 1) then Result := img_connect else
  if (Pos('Disconnect', OperationName) = 1) then Result := img_connect else
  if (Pos('Start', OperationName) = 1) then Result := img_transact else
  if (Pos('Commit', OperationName) = 1) then Result := img_transact else
  if (Pos('Rollback', OperationName) = 1) then Result := img_transact else
  if (Pos('Prepare', OperationName) = 1) then Result := img_prepare else
  if (Pos('Execute', OperationName) = 1) then Result := img_execute else
  if (Pos('Fetch', OperationName) = 1) then Result := img_fetch else
    Result := img_other;
end;

procedure TibSHSQLMonitorForm.FillTree(EventDescr: TEventDescr);
var
(*
  EngineNode, AppicationNode, StatementNode: PVirtualNode;
  NodeData: PTreeRec;
*)
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
(*
  // Engines
  Tree.BeginUpdate;
  EngineNode := Tree.GetFirst;
  while Assigned(EngineNode) do
  begin
    NodeData := Tree.GetNodeData(EngineNode);
    if AnsiSameText(NodeData.NormalText, EventDescr.EngineName) = 0 then Break;
    EngineNode := Tree.GetNextSibling(EngineNode);
  end;
  if not Assigned(EngineNode) then
  begin
    EngineNode := Tree.AddChild(nil);
    NodeData := Tree.GetNodeData(EngineNode);
    NodeData.NormalText := EventDescr.EngineName;
    NodeData.StaticText := EmptyStr;
    NodeData.ImageIndex := img_dac_engine;
  end;
  // Applications
  AppicationNode := EngineNode.FirstChild;
  while Assigned(AppicationNode) do
  begin
    NodeData := Tree.GetNodeData(AppicationNode);
    if AnsiSameText(NodeData.NormalText, EventDescr.AppName) = 0 then Break;
    AppicationNode := Tree.GetNextSibling(AppicationNode);
  end;
  if not Assigned(AppicationNode) then
  begin
    AppicationNode := Tree.AddChild(EngineNode);
    NodeData := Tree.GetNodeData(AppicationNode);
    NodeData.NormalText := EventDescr.AppName;
    NodeData.StaticText := EmptyStr;
    NodeData.ImageIndex := img_application;
  end;
  // Statements
  StatementNode := Tree.AddChild(AppicationNode);
  NodeData := Tree.GetNodeData(StatementNode);
  NodeData.NormalText := Format('%s %s', [EventDescr.ShortTime, EventDescr.OperationName]);
  NodeData.StaticText := EventDescr.ObjectName;
  NodeData.TopLine := TopLine;
  NodeData.ImageIndex := CalcImageIndex(EventDescr.OperationName);

  Tree.EndUpdate;

  if not Tree.Expanded[EngineNode] then Tree.Expanded[EngineNode] := True;
  if not Tree.Expanded[AppicationNode] then Tree.Expanded[AppicationNode] := True;
  Tree.FocusedNode := StatementNode;
  Tree.Selected[Tree.FocusedNode] := True;
*)

  Node := Tree.AddChild(nil);
  NodeData := Tree.GetNodeData(Node);
//  NodeData.NormalText := Format('%s %s', [EventDescr.ShortTime, EventDescr.OperationName]);
//  NodeData.StaticText := EventDescr.ObjectName;

  NodeData.Number := IntToStr(EventDescr.Number);
  NodeData.ApplicationName := EventDescr.ApplicationName;
  NodeData.OperationName := EventDescr.OperationName;
  NodeData.ObjectName := EventDescr.ObjectName;
  NodeData.ShortTime := EventDescr.ShortTime;

  NodeData.TopLine := TopLine;
  NodeData.ImageIndex := CalcImageIndex(EventDescr.OperationName);

  Tree.EndUpdate;
  Tree.FocusedNode := Node;
  Tree.Selected[Tree.FocusedNode] := True;
end;

procedure TibSHSQLMonitorForm.FillEditor(EventDescr: TEventDescr);
begin
  if Editor.Lines.Count = 0 then
  begin
    WriteInfoLine(Format('/* -> %s | Continue monitoring... [Running] */', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', Now)]));
    WritePropsLine;
  end;

  TopLine := Editor.Lines.Count;

  FillTree(EventDescr);

  if Length(EventDescr.ObjectName) > 0 then
    Editor.Lines.Add(Format('/* %d >> %s | %s | %s | %s */', [EventList.Count, EventDescr.ApplicationName, EventDescr.LongTime, EventDescr.OperationName, EventDescr.ObjectName]))
  else
    Editor.Lines.Add(Format('/* %d >> %s | %s | %s */', [EventList.Count, EventDescr.ApplicationName, EventDescr.LongTime, EventDescr.OperationName]));

  Editor.Lines.Objects[Editor.Lines.Count - 1] := TObject(CalcImageIndex(EventDescr.OperationName));

  Designer.TextToStrings(EventDescr.SQLText, Editor.Lines);
  Editor.Lines.Add('');
  SelectTopLineBlock(TopLine);
end;

procedure TibSHSQLMonitorForm.GutterDrawNotify(Sender: TObject; ALine: Integer;
  var ImageIndex: Integer);
begin
  ImageIndex := Integer(Editor.Lines.Objects[ALine]);
  if ImageIndex = 0 then ImageIndex := -1;
end;

procedure TibSHSQLMonitorForm.WriteInfoLine(S: string);
begin
  TopLine := Editor.Lines.Count;
  Editor.Lines.Add(S);
  Editor.Lines.Add('');
  SelectTopLineBlock(TopLine);
end;

procedure TibSHSQLMonitorForm.WritePropsLine;
var
  Result, S: string;
begin
  Result := EmptyStr;
  if Assigned(SQLMonitor) then
  begin
    if SQLMonitor.Prepare then S := Format('%s, %s', [S, 'Prepare']);
    if SQLMonitor.Execute then S := Format('%s, %s', [S, 'Execute']);
    if SQLMonitor.Fetch then S := Format('%s, %s', [S, 'Fetch']);
    if SQLMonitor.Connect then S := Format('%s, %s', [S, 'Connect']);
    if SQLMonitor.Transact then S := Format('%s, %s', [S, 'Transact']);
    if SQLMonitor.Service then S := Format('%s, %s', [S, 'Service']);
    if SQLMonitor.Stmt then S := Format('%s, %s', [S, 'Stmt']);
    if SQLMonitor.Error then S := Format('%s, %s', [S, 'Error']);
    if SQLMonitor.Blob then S := Format('%s, %s', [S, 'Blob']);
    if SQLMonitor.Misc then S := Format('%s, %s', [S, 'Misc']);
    if Pos(',', S) = 1 then Delete(S, 1, 2);
    Result := Format('Trace Flags: %s', [S]);
    if SQLMonitor.Filter.Count > 0 then
    begin
      Result := Format('%s; Trace Filter: %s', [Result, AnsiReplaceText(SQLMonitor.Filter.CommaText, ',', ', ')]);
    end;

    Result := Format('/* -> %s */', [Result]);

    Editor.Lines.Delete(Pred(Editor.Lines.Count));
    Editor.Lines.Add(Result);
    Editor.Lines.Add('');
    SelectTopLineBlock(TopLine);
  end;
end;

procedure TibSHSQLMonitorForm.SelectTopLineBlock(ATopLine: Integer);
var
  BlockBegin, BlockEnd: TBufferCoord;
begin
  Editor.BeginUpdate;
  Editor.TopLine := ATopLine + 1;
  BlockBegin.Char := 1;
  BlockBegin.Line := ATopLine + 1;
  BlockEnd.Char := 0;
  BlockEnd.Line := ATopLine + 2;
  Editor.BlockBegin := BlockBegin;
  Editor.BlockEnd := BlockEnd;
  Editor.EndUpdate;
end;

procedure TibSHSQLMonitorForm.DoOnEnter;
var
  Data: PTreeRec;
begin
  if Assigned(Tree.FocusedNode) then
  begin
    Data := Tree.GetNodeData(Tree.FocusedNode);
    SelectTopLineBlock(Data.TopLine);
  end;
end;

procedure TibSHSQLMonitorForm.RegisterEditors;
var
  vEditorRegistrator: IibSHEditorRegistrator;
begin
  if Supports(Designer.GetDemon(IibSHEditorRegistrator), IibSHEditorRegistrator, vEditorRegistrator) then
    vEditorRegistrator.RegisterEditor(Editor, BTCLServer, BTCLDatabase);
end;

function TibSHSQLMonitorForm.GetCanSave: Boolean;
begin
  Result := Assigned(Editor) and not Editor.IsEmpty;
end;

procedure TibSHSQLMonitorForm.Save;
begin
  SaveDialog1.InitialDir := Designer.GetApplicationPath;
  if SaveDialog1.Execute then Editor.Lines.SaveToFile(SaveDialog1.FileName);
end;

function TibSHSQLMonitorForm.GetCanClearAll: Boolean;
begin
  Result := Assigned(Editor) and not Editor.IsEmpty;
end;

procedure TibSHSQLMonitorForm.ClearAll;
begin
  try
    Screen.Cursor := crHourGlass;
    inherited ClearAll;
    EventList.Clear;
    Editor.Lines.Clear;
    Tree.Clear;
    TopLine := 0;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function TibSHSQLMonitorForm.GetCanRun: Boolean;
begin
  Result := Assigned(SQLMonitor) and not SQLMonitor.Active;
end;

function TibSHSQLMonitorForm.GetCanPause: Boolean;
begin
  Result := not GetCanRun;
end;

procedure TibSHSQLMonitorForm.Run;
begin
  try
    Screen.Cursor := crHourGlass;
    SQLMonitor.Active := True;
    WriteInfoLine(Format('/* -> %s | Start monitoring... [Running] */', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', Now)]));
    WritePropsLine;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TibSHSQLMonitorForm.Pause;
begin
  try
    Screen.Cursor := crHourGlass;
    SQLMonitor.Active := False;
    WriteInfoLine(Format('/* <- %s | Stop monitoring... [Pause] */', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', Now)]));
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TibSHSQLMonitorForm.ShowHideRegion(AVisible: Boolean);
begin
 if AVisible<>Panel1.Visible then
 begin
  Panel1.Visible := AVisible;
  Splitter1.Visible := AVisible;
  if AVisible then Splitter1.Left := Panel1.Left + Panel1.Width + 1;
 end 
end;

function TibSHSQLMonitorForm.CanJumpToApplication: Boolean;
begin
  Result := EventList.Count > 0;
end;

procedure TibSHSQLMonitorForm.JumpToApplication;
var
  NodeData: PTreeRec;
  WH: THandle;
begin
  NodeData := Tree.GetNodeData(Tree.FocusedNode);
  if not Assigned(NodeData) or AnsiSameText(NodeData.ApplicationName, 'BlazeTop32') then Exit;
  WH := FindWindow(nil, PChar(NodeData.ApplicationName));
  if WH <> 0 then
  begin
    BringWindowToTop(WH);
    FlashWindow(WH, True);
  end else
    Designer.ShowMsg(Format(SApplicationNotFound,[NodeData.NormalText]), mtWarning);
end;

procedure TibSHSQLMonitorForm.DoOnIdle;
begin
  if FBTCLDatabase <> Designer.CurrentDatabase then
  begin
    FBTCLDatabase := Designer.CurrentDatabase;
    if Assigned(FBTCLDatabase) then
    begin
      Supports(FBTCLDatabase, IibSHDatabase, FBTCLDatabaseIntf);
      FBTCLServerIntf := FBTCLDatabaseIntf.BTCLServer;
      RegisterEditors;
    end else
    begin
      FBTCLServerIntf := nil;
      FBTCLDatabaseIntf := nil;
      RegisterEditors;
    end;
  end;
end;

function TibSHSQLMonitorForm.DoOnOptionsChanged: Boolean;
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

procedure TibSHSQLMonitorForm.DoOnSpecialLineColors(Sender: TObject;
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
      FG := RGB(140, 170, 210);
    end else
      if (Pos('>>', pSHSynEdit1.Lines[Line - 1]) > 0) then
      begin
        Special := True;
        BG := RGB(235, 235, 235);
        FG := RGB(140, 170, 210);
      end;
end;

procedure TibSHSQLMonitorForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  DoOnIdle;
end;

procedure TibSHSQLMonitorForm.pSHSynEdit1DblClick(Sender: TObject);
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  if EventList.Count = 0 then Exit;

  Node := Tree.GetLast;
  NodeData := Tree.GetNodeData(Node);
  while Assigned(Node) and (NodeData.TopLine > (Editor.CaretY - 1)) do
  begin
    NodeData := Tree.GetNodeData(Node);
    Node := Tree.GetPrevious(Node);
  end;

  if Node = Tree.GetLast then Tree.FocusedNode := Node;
  if Node = Tree.GetFirst then Tree.FocusedNode := Node;
//  if Node = Tree.GetLast.Parent then Tree.FocusedNode := Tree.GetLast.Parent.FirstChild else
//  if Assigned(Node) then
//  begin
    Tree.FocusedNode := Node.NextSibling;
    Tree.Selected[Tree.FocusedNode] := True;
//  end;
end;

{ Tree }

procedure TibSHSQLMonitorForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHSQLMonitorForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibSHSQLMonitorForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  ImageIndex := -1;
  if (Kind = ikNormal) or (Kind = ikSelected) then
    if Column = 2 then ImageIndex := Data.ImageIndex;
end;

procedure TibSHSQLMonitorForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if TextType = ttNormal then
    case Column of
      0: CellText := Data.Number;
      1: CellText := Data.ApplicationName;
      2: CellText := Data.OperationName;
      3: CellText := Data.ShortTime;
      4: CellText := Data.ObjectName;
    end;
end;

procedure TibSHSQLMonitorForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
(*
  case TextType of
    ttNormal: ;
    ttStatic: if Sender.Focused and (vsSelected in Node.States) then
                TargetCanvas.Font.Color := clWindow
              else
                TargetCanvas.Font.Color := clGray;
  end;
*)
end;

procedure TibSHSQLMonitorForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.NormalText)) <> 1 then
    Result := 1;
end;

procedure TibSHSQLMonitorForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then DoOnEnter;
end;

procedure TibSHSQLMonitorForm.TreeDblClick(Sender: TObject);
begin
  DoOnEnter;
end;

procedure TibSHSQLMonitorForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
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
    Data := Sender.GetNodeData(Sender.FocusedNode);
    Sender.GetHitTestInfoAt(P.X, P.Y, True, HT);
    if Assigned(Data) and (Sender.GetNodeLevel(Sender.FocusedNode) = 0) and
    (HT.HitNode = Sender.FocusedNode) and not (hiOnItemButton in HT.HitPositions) then ;
//      PopupMenu := MainForm.PopupMenuCE;
  end;
end;

procedure TibSHSQLMonitorForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  Result := AnsiCompareText(Data1.NormalText, Data2.NormalText);
end;

end.
