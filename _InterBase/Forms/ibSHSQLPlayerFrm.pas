unit ibSHSQLPlayerFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDriverIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, SynEdit, SynEditTypes, VirtualTrees,
  ImgList, AppEvnts, ActnList, Menus, 
  pSHSynEdit, pSHSqlTxtRtns, pSHStrUtil;

type

  TParserThreaded = class;

  TibSHSQLPlayerForm = class(TibBTComponentForm, IibSHSQLPlayerForm,
    IibSHDRVSQLParserNotification, IibSHDRVPlayerNotification,
    IibSHDRVTransactionNotification)
    Panel2: TPanel;
    ImageList1: TImageList;
    tmLaunchParsing: TTimer;
    Panel4: TPanel;
    pSHSynEdit2: TpSHSynEdit;
    Splitter2: TSplitter;
    Splitter1: TSplitter;
    pSHSynEdit1: TpSHSynEdit;
    Tree: TVirtualStringTree;
    PopupMenuMessage: TPopupMenu;
    pmiHideMessage: TMenuItem;
    Panel1: TPanel;
    Bevel1: TBevel;
    Image1: TImage;
    Bevel2: TBevel;
    Panel6: TPanel;
    Panel7: TPanel;
    ProgressBar1: TProgressBar;
    odScript: TOpenDialog;
    procedure tmLaunchParsingTimer(Sender: TObject);
    procedure pSHSynEdit2DblClick(Sender: TObject);
    procedure pmiHideMessageClick(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure pSHSynEdit1Change(Sender: TObject);
  private
    { Private declarations }
    FImageIndeces: TList;
    FParserThread: TParserThreaded;
    FWasErrors: Boolean;
    FRunning: Boolean;                             
    FTreeVisible: Boolean;

    FIntDRVDatabaseComponent: TSHComponent;
    FIntDRVTransactionComponent: TSHComponent;
    FDRVPlayer: TSHComponent;

    FUserTerminated: Boolean;
    FMakeConnection: Boolean;
    FRunningFromFile: Boolean;
    FProgressBarPriorPosition: Integer;

    FChangeNameList: TList;
    FHasConnectStatements: Boolean;
    FWasSelectedColor: TColor;
    FTracedLine: Integer;

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
    procedure TreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
      Column: TColumnIndex; var Result: Integer);

    procedure CreateDRV(ANeedDatabase: Boolean);
    procedure FreeDRV;
    procedure GutterDrawNotify(Sender: TObject; ALine: Integer; var ImageIndex: Integer);
    procedure ClearMessages;
    procedure DoOnEnter;
    function GetDRVDatabaseIntf: IibSHDRVDatabase;
    function GetDRVTransactionIntf: IibSHDRVTransaction;
    function GetDRVPlayer: IibSHDRVPlayer;
    function GetSQLPlayer: IibSHSQLPlayer;
    function GetIsTraceMode: Boolean;
  protected
    function FillTo80(const ASource: string): string;
    procedure EditorMsgVisible(AShow: Boolean = True); override;
    procedure RegisterEditors; override;
    procedure DoOnSpecialLineColors(Sender: TObject;
      Line: Integer; var Special: Boolean; var FG, BG: TColor); override;

    { IibSHDRVPlayerNotification }
    procedure IibSHDRVPlayerNotification.OnParse = PlayerOnParse;
    procedure IibSHDRVPlayerNotification.OnError = PlayerOnError;
    procedure IibSHDRVPlayerNotification.AfterExecute = PlayerAfterExecute;

    procedure PlayerOnParse(APlayer: IibSHDRVPlayer;const  ASQLText: string;
      ALineIndex: Integer);
    procedure PlayerOnError(APlayer: IibSHDRVPlayer; const AError: string;
      const ASQLText: string; ALineIndex: Integer; var DoAbort: Boolean;
      var DoRollbackOnError: Boolean);
    procedure PlayerAfterExecute(APlayer: IibSHDRVPlayer; ATokens: TStrings;
     const  ASQLText: string);

    procedure BeforeExecuteStmnt(APlayer: IibSHDRVPlayer;
     StmntNo:integer;AScriptLine: Integer
    );

    { IibSHDRVTransactionNotification }
    procedure AfterEndTransaction(ATransaction: IibSHDRVTransaction;
      ATransactionAction: TibSHTransactionAction);
    { IibSHDRVSQLParserNotification }
    procedure IibSHDRVSQLParserNotification.OnParse = ParserOnParse;

    procedure ParserOnParse(ASQLParser: IibSHDRVSQLParser);
    { ISHFileCommands }
    function GetCanOpen: Boolean; override;
    function GetCanSave: Boolean; override;
    function GetCanSaveAs: Boolean; override;

    { ISHEditCommands }
    procedure ClearAll; override;
    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanPause: Boolean; override;
    function GetCanRefresh: Boolean; override;
    procedure Run; override;
    procedure DoRun(ARunFromFile: Boolean = False);
    procedure Pause; override;
    procedure Refresh; override;
    procedure ShowHideRegion(AVisible: Boolean); override;

    { IibSHSQLPlayerForm }
    function GetCanRunCurrent: Boolean;
    function GetCanRunFromCurrent: Boolean;
    function GetCanRunFromFile: Boolean;
    function GetRegionVisible: Boolean;


    function ChangeNotification: Boolean;
    procedure InsertScript(AText: string);
    procedure CheckAll;
    procedure UnCheckAll;
    procedure RunCurrent;
    procedure RunFromCurrent;
    procedure RunFromFile;

    procedure ParseScript;

    function PrepareTraceMode: Boolean;
    procedure UnPrepareTraceMode;

    function DoOnOptionsChanged: Boolean; override;
    procedure DoAfterLoadFile; override;
    function GetCanDestroy: Boolean; override;
    procedure SetStatusBar(Value: TStatusBar); override;

    procedure SetTopLineForStatement(AStatementRect: TRect);
    procedure SelectStatement(ANode: PVirtualNode);

    procedure ClearChangeNameList;
    property IsTraceMode: Boolean read GetIsTraceMode;
    property TracedLine: Integer read FTracedLine write FTracedLine;
    property HasConnectStatements: Boolean read FHasConnectStatements
      write FHasConnectStatements;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure BringToTop; override;
    function ReceiveEvent(AEvent: TSHEvent): Boolean; override;

    property SQLPlayer: IibSHSQLPlayer read GetSQLPlayer;
    property DRVPlayer: IibSHDRVPlayer read GetDRVPlayer;
    property DRVDatabase: IibSHDRVDatabase read GetDRVDatabaseIntf;
    property DRVTransaction: IibSHDRVTransaction read GetDRVTransactionIntf;
  end;

  TParserThreaded = class(TThread)
//  TParserThreaded = class(TComponent)
  private
    { Private declarations }

    FDRVParser: TSHComponent;
    FEditorForm: TibSHSQLPlayerForm;
    FFocusedNode: TRect;
    FExpandedNodes: TList;

    FNeedReparsing:boolean;
    FStopFillTree :boolean;
    function GetDRVParser: IibSHDRVSQLParser;
    procedure SetEditorForm(const Value: TibSHSQLPlayerForm);
    procedure SetNeedReparsing(const Value: boolean);

  protected
    { Protected declarations }
    procedure ClearExpandedNodes;
    procedure SaveExpandedNodes;
    procedure RestoreExpandedNodes;
    procedure LoadScript;
    procedure DoWork;
    procedure Execute; override;
//    procedure Execute;
    procedure FillTree;
    procedure ProgressOn;
    procedure ProgressOff;

    property DRVParser: IibSHDRVSQLParser read GetDRVParser;
  public
    constructor Create(CreateSuspended: Boolean);
//    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property EditorForm: TibSHSQLPlayerForm read FEditorForm write SetEditorForm;
    property NeedReparsing:boolean write SetNeedReparsing;
  end;

  PChangeNameListRecord = ^TChangeNameListRecord;
  TChangeNameListRecord = record
    ObjectType: TGUID;
    ObjectName: string;
    Operation: TOperation;
  end;

var
  ibSHSQLPlayerForm: TibSHSQLPlayerForm;

implementation

uses
  ibSHConsts, ibSHMessages, ibSHValues;

{$R *.dfm}

const
  img_statement = 14;
  img_error = 9;
  img_info = 6;
  img_attention = 7;
  img_time = 17;

  fmt_datetime = 'dd.mm.yyyy hh:nn:ss.zzz';

  // Из ресурсов лучше перечитать сразу.
  cStateSQL:string=SStateSQL;
  cStateCreate:string=SStateCreate;
  cStateConnect:string=SStateConnect;
  cStateReConnect:string=SStateReConnect;
  cStateDisConnect:string=SStateDisConnect;
  cStateAlter     :string=SStateAlter;
  cStateDrop:string=SStateDrop;
  cStateRecreate:string=SStateRecreate;
  cStateGrant   :string=SStateGrant;
  cComment:string=SComment;
  cUnknown:string=SUnknown;
  cDML:string=SDML;
type

  PScriptNode = ^TScriptNode;
  TScriptNode = packed record
//    IsCommented: Boolean;
    StatementNo: Integer;
    StatementPos: TRect;
    ImageIndex: Integer;
    Caption: string;
    ExecutionResult: string;
  end;

{ TibBTSQLScriptForm }

constructor TibSHSQLPlayerForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  vComponentClass: TSHComponentClass;

  procedure CopyImage(AGUID: TGUID);
  var
    I: Integer;
  begin
    I := Designer.GetImageIndex(AGUID);
    if I > -1 then
      FImageIndeces.Add(pointer(ImageList1.AddImage(Designer.ImageList, I)))
    else
      FImageIndeces.Add(pointer(-1));
  end;
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Tree.Clear;
//  EditorMsgVisible(False);
//  Supports(Component, IibSHSQLPlayer, FSQLPlayerIntf);
  EditorMsg := pSHSynEdit2;
  EditorMsg.OnGutterDraw := GutterDrawNotify;
  EditorMsg.GutterDrawer.ImageList := ImageList1;
  EditorMsg.GutterDrawer.Enabled := True;

  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
  FocusedControl := Editor;

  RegisterEditors;

  DoOnOptionsChanged;

  Tree.OnGetNodeDataSize := TreeGetNodeDataSize;
  Tree.OnFreeNode := TreeFreeNode;
  Tree.OnGetImageIndex := TreeGetImageIndex;
  Tree.OnGetText := TreeGetText;
  Tree.OnPaintText := TreePaintText;
  Tree.OnIncrementalSearch := TreeIncrementalSearch;
  Tree.OnDblClick := TreeDblClick;
  Tree.OnKeyDown := TreeKeyDown;
//  Tree.OnGetPopupMenu := TreeGetPopupMenu;
  Tree.OnCompareNodes := TreeCompareNodes;

  FImageIndeces := TList.Create;
  CopyImage(IibSHDatabase);
  CopyImage(IibSHDomain);
  CopyImage(IibSHTable);
  CopyImage(IibSHView);
  CopyImage(IibSHProcedure);
  CopyImage(IibSHTrigger);
  CopyImage(IibSHGenerator);
  CopyImage(IibSHException);
  CopyImage(IibSHFunction);
  CopyImage(IibSHRole);
  CopyImage(IibSHIndex);

  CopyImage(IibSHGrant); //11
  CopyImage(IibSHDMLHistory); //12
  FImageIndeces.Add(pointer(15)); //13

  vComponentClass := Designer.GetComponent(SQLPlayer.BTCLServer.DRVNormalize(IibSHDRVPlayer));
  if Assigned(vComponentClass) then FDRVPlayer := vComponentClass.Create(nil);
  DRVPlayer.Paused := True;
  DRVPlayer.PlayerNotification := Self as IibSHDRVPlayerNotification;

  FRunning := False;
  Panel6.Caption := EmptyStr;
  Panel1.Visible := False;
  FChangeNameList := TList.Create;

  ShowHideRegion(False);
  FIntDRVTransactionComponent := nil;
  FIntDRVDatabaseComponent := nil;

  if Assigned(SQLPlayer.BTCLDatabase) then
  begin
    Designer.TextToStrings(
      Format('SQL Player is using opened connection to database'#13#10'"%s"'#13#10'Use CREATE or CONNECT statement for work with another databases.',
        [SQLPlayer.BTCLDatabase.ConnectPath]),
      EditorMsg.Lines, True);
    Panel4.Height := 68;
    EditorMsgVisible(True);
  end
  else
    EditorMsgVisible(False);

//--  FParserThread := TParserThreaded.Create(True);
  FParserThread := TParserThreaded.Create(True);
  FParserThread.EditorForm := Self;
  FParserThread.Priority:= tpIdle;
  FParserThread.Resume;
//--  FParserThread.Priority := tpIdle;
    
end;

destructor TibSHSQLPlayerForm.Destroy;
begin
//--  if not FParserThread.Suspended then
//--  begin
//--    FParserThread.Terminate;
//--    while not FParserThread.Terminated do
//--      Application.ProcessMessages;
//--  end;

//  FParserThread.DRVParser.SQLParserNotification := nil;
//  FParserThread.EditorForm := nil;
  FParserThread.FNeedReparsing:=False;
  FParserThread.FStopFillTree:=True;
  FParserThread.Terminate;
  FreeDRV;

  ClearChangeNameList;
  FChangeNameList.Free;
  Tree.Clear;
  FreeAndNil(FParserThread);
  if Assigned(FDRVPlayer) then
  begin
//    DRVPlayer.Database := nil;
//    DRVPlayer.Transaction := nil;
//    DRVPlayer.PlayerNotification := nil;
    FreeAndNil(FDRVPlayer);
  end;
  FImageIndeces.Free;
//  FSQLPlayerIntf := nil;
//  Editor := nil;
//  EditorMsg := nil;
//  FreeDRV;
  inherited Destroy;
end;

function TibSHSQLPlayerForm.ReceiveEvent(AEvent: TSHEvent): Boolean;
begin
  Result := inherited ReceiveEvent(AEvent);
  if Result then
  begin
  end;
end;

procedure TibSHSQLPlayerForm.CreateDRV(ANeedDatabase: Boolean);
var
  vComponentClass: TSHComponentClass;
begin
//  Exit;
  if ANeedDatabase then
  begin
    vComponentClass := Designer.GetComponent(SQLPlayer.BTCLServer.DRVNormalize(IibSHDRVDatabase));
    if Assigned(vComponentClass) then
    begin
       FIntDRVDatabaseComponent := vComponentClass.Create(nil);
      if DRVDatabase <> nil then
        DRVDatabase.ClientLibrary := SQLPlayer.BTCLServer.ClientLibrary;
    end;
  end
  else
    FIntDRVDatabaseComponent := nil;

  vComponentClass := Designer.GetComponent(SQLPlayer.BTCLServer.DRVNormalize(IibSHDRVTransaction));
  if Assigned(vComponentClass) then
  begin
     FIntDRVTransactionComponent := vComponentClass.Create(nil);
    if DRVTransaction <> nil then
    begin
      DRVTransaction.Params.Text := TRWriteParams;
      DRVTransaction.TransactionNotification := Self as IibSHDRVTransactionNotification;
    end;
  end;
end;

procedure TibSHSQLPlayerForm.FreeDRV;
//var
//  vDummy: TSHComponent;
//  vDummy: TObject;
begin
  if FIntDRVTransactionComponent <> nil then
  begin
    FreeAndNil(FIntDRVTransactionComponent);
  end;
  if FIntDRVDatabaseComponent <> nil then
  begin
    FreeAndNil(FIntDRVDatabaseComponent);
  end;
end;

procedure TibSHSQLPlayerForm.GutterDrawNotify(Sender: TObject;
  ALine: Integer; var ImageIndex: Integer);
begin
  if Assigned(EditorMsg) and (ALine >= 0) and (ALine < EditorMsg.Lines.Count) then
  begin
    if Pos(SErrorMessagesHeader, EditorMsg.Lines[ALine]) > 0 then
      ImageIndex := img_error
    else
//    if Pos(SPlayerExecutedWithErrorsAt, EditorMsg.Lines[ALine]) > 0 then
//      ImageIndex := img_error
//    else
    if Pos(SPlayerTerminatedAt, EditorMsg.Lines[ALine]) > 0 then
      ImageIndex := img_attention
    else
    if Pos(SPlayerSuccessfulyExecutedAt, EditorMsg.Lines[ALine]) > 0 then
      ImageIndex := img_info
    else
    if Pos(SPlayerStartedAt, EditorMsg.Lines[ALine]) > 0 then
      ImageIndex := img_info;
    if Pos(SElapsedTime, EditorMsg.Lines[ALine]) > 0 then
      ImageIndex := img_time;
  end;
end;

procedure TibSHSQLPlayerForm.ClearMessages;
begin
  Designer.TextToStrings(EmptyStr, EditorMsg.Lines, True);
end;

procedure TibSHSQLPlayerForm.DoOnEnter;
var
  P: TPoint;
  HT: THitInfo;
begin
  GetCursorPos(P);
  P := Tree.ScreenToClient(P);
  with Tree do
  begin
    GetHitTestInfoAt(P.X, P.Y, True, HT);
    if (HT.HitNode = FocusedNode) and (hiOnItemLabel in HT.HitPositions) then
    begin
      if IsTraceMode then
      begin
        pSHSynEdit1.Invalidate;
        SelectStatement(FocusedNode)
      end
      else
      begin
        if (GetNodeLevel(FocusedNode) = 1) then
        begin
          if (FocusedNode.ChildCount > 0) and Assigned(FocusedNode.FirstChild) then
            SelectStatement(FocusedNode.FirstChild)
          else
           SelectStatement(FocusedNode); // Для Unknown  и DML
        end
        else
          if (GetNodeLevel(FocusedNode) = 2) then
          begin
            if Assigned(FocusedNode) then
              SelectStatement(FocusedNode)
          end;
      end;
    end;
  end;
end;

function TibSHSQLPlayerForm.GetDRVDatabaseIntf: IibSHDRVDatabase;
begin
  Supports(FIntDRVDatabaseComponent, IibSHDRVDatabase, Result);
end;

function TibSHSQLPlayerForm.GetDRVTransactionIntf: IibSHDRVTransaction;
begin
  Supports(FIntDRVTransactionComponent, IibSHDRVTransaction, Result);
end;

function TibSHSQLPlayerForm.GetDRVPlayer: IibSHDRVPlayer;
begin
  Supports(FDRVPlayer, IibSHDRVPlayer, Result);
end;

function TibSHSQLPlayerForm.GetSQLPlayer: IibSHSQLPlayer;
begin
  Supports(Component, IibSHSQLPlayer, Result);
end;

function TibSHSQLPlayerForm.GetIsTraceMode: Boolean;
begin
  Result := AnsiSameText(SQLPlayer.Mode, PlayerModes[1]);
end;

function TibSHSQLPlayerForm.FillTo80(const ASource: string): string;
begin
  if (Length(ASource)>=80) or (Length(ASource)=0) then
   Result := ASource
  else
  begin
   SetLength(Result,80);
   FillChar(Result[1],80-Length(ASource),' ');
   Move(ASource[1],Result[80-Length(ASource)+1],Length(ASource));
{  Ахренеть
    while Length(Result) < 80 do
    Insert(' ', Result, Length(Result) - 1);}
  end
end;

procedure TibSHSQLPlayerForm.EditorMsgVisible(AShow: Boolean = True);
begin
  Panel4.Visible := AShow;
  Splitter2.Visible := AShow;
  if AShow then
  begin
    if Assigned(StatusBar) then
    begin
      if Panel1.Visible then Panel1.Top := Panel4.Top + Panel4.Height + 1;
      Application.ProcessMessages;
    end;
  end;
  if Assigned(StatusBar) then
    StatusBar.Top := Self.Height;
end;

procedure TibSHSQLPlayerForm.RegisterEditors;
var
  vEditorRegistrator: IibSHEditorRegistrator;
begin
  if Supports(Designer.GetDemon(IibSHEditorRegistrator), IibSHEditorRegistrator, vEditorRegistrator) then
    vEditorRegistrator.RegisterEditor(Editor, SQLPlayer.BTCLServer, SQLPlayer.BTCLDatabase);
end;

procedure TibSHSQLPlayerForm.PlayerOnParse(APlayer: IibSHDRVPlayer;
 const  ASQLText: string; ALineIndex: Integer);
begin
  if not IsTraceMode then
  begin
    Editor.BeginUpdate;
    Editor.CaretY :=  ALineIndex + 1;
    Editor.TopLine := ALineIndex + 1;
    Editor.EnsureCursorPosVisibleEx(True);
    Editor.BlockBegin := TBufferCoord(Point(1, ALineIndex + 1));
    Editor.BlockEnd := TBufferCoord(Point(1, ALineIndex + 2));
    Editor.EndUpdate;
  end;
  Screen.Cursor := crDefault;
  if FRunningFromFile then
  begin
    if Pred(DRVPlayer.InputStringCount) > 0 then
      ProgressBar1.Max := Pred(DRVPlayer.InputStringCount);
    ProgressBar1.Position := DRVPlayer.LineProceeding;
    if StatusBar.Panels.Count > 4 then
      StatusBar.Panels[4].Text := Format('Lines proceeded: %d/%d', [DRVPlayer.LineProceeding, DRVPlayer.InputStringCount]);
  end
  else
   ProgressBar1.Position := DRVPlayer.LineProceeding;
  //  ProgressBar1.Position := ProgressBar1.Position + 1;
  Designer.UpdateActions;
  Application.ProcessMessages;
end;

procedure TibSHSQLPlayerForm.PlayerOnError(APlayer: IibSHDRVPlayer;const  AError,
 ASQLText: string; ALineIndex: Integer; var DoAbort: Boolean;
  var DoRollbackOnError: Boolean);
var
  vLogText: string;
  vLineToShow: Integer;
  vError: string;
  vLineIndex: Integer;
begin
  vLineToShow := EditorMsg.Lines.Count;
  vError := Trim(AError);
  if Pos(':', vError) = 1 then
  begin
    Delete(vError, 1, 1);
    vError := Trim(vError);
  end;

  if IsTraceMode then
    vLineIndex := ALineIndex + TracedLine + 1
  else
    vLineIndex := ALineIndex + 1;
  vLogText := Format(SErrorMessagesHeader + SErrorMessagesHeaderSuf,
    [vLineIndex, vError]);

  Designer.TextToStrings(vLogText, EditorMsg.Lines);
  EditorMsg.Lines.Add('-------- In Statement------- ');
  Designer.TextToStrings(ASQLText, EditorMsg.Lines);
  
  if SQLPlayer.SignScript then
    Designer.TextToStrings(FillTo80(Format('/* BT: %s*/', [vLogText])), Editor.Lines);
  EditorMsgVisible;

  DoAbort := SQLPlayer.AbortOnError;
  DoRollbackOnError := AnsiSameText(SQLPlayer.AfterError, PlayerAfterErrors[1]);
  FWasErrors := True;
//  if vLineToShow > EditorMsg.Lines.Count then
  if vLineToShow < EditorMsg.Lines.Count then
    EditorMsg.TopLine := vLineToShow;
end;

procedure TibSHSQLPlayerForm.PlayerAfterExecute(
  APlayer: IibSHDRVPlayer; ATokens: TStrings;const  ASQLText: string);
var
  vObjectType: TGUID;
  function GetObjectType: TGUID;
  var
    vToken: string;
  begin
    Result := IUnknown;
    vToken := UpperCase(ATokens[1]);
    if vToken = 'DOMAIN' then Result := IibSHDomain else
    if vToken = 'TABLE' then Result := IibSHTable else
//    if vToken = 'INDEX' then Result := IibSHIndex else
    if vToken = 'VIEW' then Result := IibSHView else
    if vToken = 'PROCEDURE' then Result := IibSHProcedure else
    if vToken = 'TRIGGER' then Result := IibSHTrigger else
    if vToken = 'GENERATOR' then Result := IibSHGenerator else
    if vToken = 'EXCEPTION' then Result := IibSHException else
//    if vToken = 'FUNCTION' then Result := IibSHFunction else
    if vToken = 'EXTERNAL' then Result := IibSHFunction else
    if vToken = 'FILTER' then Result := IibSHFilter else
    if vToken = 'ROLE' then Result := IibSHRole; {else
    if vToken = 'SHADOW' then Result := IibSHShadow else
    if vToken = 'DATABASE' then Result := IibSHDatabase;}
  end;
  procedure AddToChangeNameList(AOperation: TOperation);
  var
    vRecord: PChangeNameListRecord;
  begin
    System.New(vRecord);
    vRecord.ObjectType := vObjectType;
    if IsEqualGUID(vObjectType, IibSHFunction) then
    begin
      if ATokens.Count > 3 then
        vRecord.ObjectName := ATokens[3]
      else
      begin
        Dispose(vRecord);
        Exit;
      end;
    end
    else
      vRecord.ObjectName := ATokens[2];
    vRecord.Operation := AOperation;
    FChangeNameList.Add(vRecord);
  end;
begin
  if not FMakeConnection then
  begin
    if ATokens.Count > 2 then
    begin
      vObjectType := GetObjectType;
      if not IsEqualGUID(vObjectType, IUnknown) then
        if UpperCase(ATokens[0]) = 'DROP' then AddToChangeNameList(opRemove) else
        if ((UpperCase(ATokens[0]) = 'CREATE') or
            (UpperCase(ATokens[0]) = 'DECLARE')) then AddToChangeNameList(opInsert);
    end;
  end;
end;

procedure TibSHSQLPlayerForm.AfterEndTransaction(
  ATransaction: IibSHDRVTransaction;
  ATransactionAction: TibSHTransactionAction);
var
  I: Integer;
  vCodeNormalizer: IibSHCodeNormalizer;
  vRecord: PChangeNameListRecord;
  function GetNormalizeName(const ACaption: string): string;
  begin
    Result := ACaption;
    if Assigned(vCodeNormalizer) or Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer) then
      Result := vCodeNormalizer.InputValueToMetadata(SQLPlayer.BTCLDatabase, Result);
  end;
begin
  vCodeNormalizer := nil;
  if not FMakeConnection then
  begin
    if ATransactionAction = shtaCommit then
    begin
      for I := 0 to Pred(FChangeNameList.Count) do
      begin
        vRecord := PChangeNameListRecord(FChangeNameList[I]);
        SQLPlayer.BTCLDatabase.ChangeNameList(vRecord.ObjectType, GetNormalizeName(vRecord.ObjectName), vRecord.Operation);
      end;
    end;
    ClearChangeNameList;
  end;
end;

procedure TibSHSQLPlayerForm.ParserOnParse(
  ASQLParser: IibSHDRVSQLParser);
var
  vProgressBarPriorPosition: Integer;
begin
  if Assigned(Editor) and Assigned(ASQLParser) and (ASQLParser.Count > 0) then
  begin
    vProgressBarPriorPosition := ASQLParser.StatementsCoord(Pred(ASQLParser.Count)).Top div 100;
    if vProgressBarPriorPosition > FProgressBarPriorPosition then
    begin
      FProgressBarPriorPosition := vProgressBarPriorPosition;
      ProgressBar1.Position := ASQLParser.StatementsCoord(Pred(ASQLParser.Count)).Top;
    end;

//--    if ProgressBar1.Position mod 1000 = 0 then
//--      Application.ProcessMessages;
  end;
end;

function TibSHSQLPlayerForm.GetCanOpen: Boolean;
begin
  Result :=  Assigned(Editor) and (not FRunning);
end;

function TibSHSQLPlayerForm.GetCanSave: Boolean;
begin
//  Result := Assigned(Editor) and (Length(CurrentFile) > 0);
  Result := inherited GetCanSave and (not FRunning);
end;

function TibSHSQLPlayerForm.GetCanSaveAs: Boolean;
begin
  Result := GetCanSave;
end;

procedure TibSHSQLPlayerForm.ClearAll;
begin
  inherited ClearAll;
  Tree.Clear;
end;

function TibSHSQLPlayerForm.GetCanRun: Boolean;
begin
  Result := Assigned(SQLPlayer) and GetCanClearAll and (not FRunning);// FParserThread.DRVPlayer.Paused;
end;

function TibSHSQLPlayerForm.GetCanPause: Boolean;
begin
  Result := Assigned(SQLPlayer) and FRunning;// and (not FParserThread.DRVPlayer.Paused);
end;

function TibSHSQLPlayerForm.GetCanRefresh: Boolean;
begin
  Result := Assigned(Editor) and (not Editor.IsEmpty) and FTreeVisible and (not FRunning);
end;

procedure TibSHSQLPlayerForm.Run;
begin
//  try
  if IsTraceMode then
  begin
    if GetCanRunFromCurrent then
      RunFromCurrent
  end    
  else
    DoRun;
//  except
//  end;
end;

procedure TibSHSQLPlayerForm.DoRun(ARunFromFile: Boolean = False);
var
  Node: PVirtualNode;
  vRunTime: Cardinal;
  vSignString: string;
  S: string;
  vDummyBool: Boolean;
  vDummyBool2: Boolean;
  IsUserModified: Boolean;
begin
  if ARunFromFile then
  begin
    FMakeConnection := True;
    FRunningFromFile := True;
    if Editor.Modified and GetCanSave then
      if Designer.ShowMsg(SFileModified, mtConfirmation) then Save;
    if odScript.Execute then
    begin
      ClearAll;
      CurrentFile := EmptyStr;
      ShowFileName;
      Designer.TextToStrings(Format('INPUT ''%s'';', [odScript.FileName]), Editor.Lines, True);
    end
    else
      Exit;
    IsUserModified := False;
  end
  else
  begin
    FMakeConnection := not Assigned(SQLPlayer.BTCLDatabase);
    FRunningFromFile := False;
    IsUserModified := Editor.Modified;
  end;
  FProgressBarPriorPosition := 0;
  ClearChangeNameList;
  EditorMsgVisible(False);
  ClearMessages;
  vRunTime := GetTickCount;
  FUserTerminated := False;
  FWasSelectedColor := Editor.SelectedColor.Background;
  Editor.SelectedColor.Background := RGB(140,170, 210);
  FRunning := True;
  Designer.UpdateActions;
  //Для прогресс бара, а также при not FMakeConnection
  Application.ProcessMessages;
  try
    Tree.TreeOptions.SelectionOptions := Tree.TreeOptions.SelectionOptions +
      [toCenterScrollIntoView];

{    if not FMakeConnection then
    begin
      Node := Tree.GetFirst;
      if Assigned(Node) then
      begin
        if (Node.ChildCount > 0) and Assigned(SQLPlayer.BTCLDatabase) then
        begin
          FMakeConnection := True;
        end;
      end;
    end;         }
//Buzz  - в случае коннекта - или создания базы скриптер по любому вытолкнет присвоенный датабэйс    
    FreeDRV;
    CreateDRV(FMakeConnection);
    if FMakeConnection then
    begin
      DRVTransaction.Database := DRVDatabase;
      DRVPlayer.Database := DRVDatabase;
    end
    else
    begin
      DRVTransaction.Database := SQLPlayer.BTCLDatabase.DRVDatabase;
      DRVPlayer.Database := SQLPlayer.BTCLDatabase.DRVDatabase;
    end;

    DRVPlayer.Transaction := DRVTransaction;
    DRVPlayer.AutoDDL :=  SQLPlayer.AutoDDL;
    DRVPlayer.Terminator := ';';

    DRVPlayer.Script.Assign(Editor.Lines);
    DRVPlayer.SQLDialect := SQLPlayer.DefaultSQLDialect;

    FWasErrors := False;
    S := Format(SPlayerStartedAt + '%s', [FormatDateTime(fmt_datetime, Now)]);
    Designer.TextToStrings(S, EditorMsg.Lines);
    Panel4.Height := 30;
//    EditorMsgVisible;
    Panel6.Caption := SRuningScript;
    ProgressBar1.Position := 0;
    if ARunFromFile then
    begin
      if Pred(DRVPlayer.InputStringCount) > 0 then
        ProgressBar1.Max := Pred(DRVPlayer.InputStringCount);
    end
    else
    begin
{      if Pred(FParserThread.DRVParser.Count) > 0 then
        ProgressBar1.Max := Pred(FParserThread.DRVParser.Count);
 }
     ProgressBar1.Max :=Editor.Lines.Count   
    end;
    Panel1.Visible := True;
    EditorMsgVisible;
    Application.ProcessMessages;
    vSignString := sLineBreak + sLineBreak + FillTo80('/* BT: ' + S + ' */') + sLineBreak;
    try
      DRVPlayer.Execute;
    except
      FWasErrors := True;
    end;
    if not FWasErrors and (Length(DRVPlayer.ErrorText) > 0) then
    begin
      FWasErrors := True;
      PlayerOnError(DRVPlayer, DRVPlayer.ErrorText, EmptyStr, Editor.CaretY - 1, vDummyBool, vDummyBool2);
    end;
    if DRVTransaction.InTransaction then
      if Designer.ShowMsg(SUncommitedChanges, mtConfirmation) then
        DRVTransaction.Commit
      else
        DRVTransaction.Rollback;
    if FMakeConnection then
      DRVPlayer.Database.Disconnect;
    Panel4.Height := 160;
    if FUserTerminated then
    begin
      Designer.TextToStrings(Format(SPlayerTerminatedAt + '%s', [FormatDateTime(fmt_datetime, Now)]), EditorMsg.Lines);
      Designer.TextToStrings(Format(SElapsedTime + '%s', [msToStr(GetTickCount - vRunTime)]), EditorMsg.Lines);
      EditorMsgVisible;
    end
    else
      if FWasErrors then
      begin
        S := Format(SPlayerExecutedWithErrorsAt + '%s', [FormatDateTime(fmt_datetime, Now)]);
        Designer.TextToStrings(S, EditorMsg.Lines);
        if SQLPlayer.SignScript then
        begin
          S := FillTo80(Format('/* BT: %s */', [S]));
          Designer.TextToStrings(S, Editor.Lines);
        end;
        S := Format(SElapsedTime + '%s', [msToStr(GetTickCount - vRunTime)]);
        Designer.TextToStrings(S, EditorMsg.Lines);
        if SQLPlayer.SignScript then
        begin
          S := FillTo80(Format('/* BT: %s */', [S]));
          Designer.TextToStrings(S, Editor.Lines);
        end;
        EditorMsgVisible;
      end else
      begin
        S := Format(SPlayerSuccessfulyExecutedAt + '%s', [FormatDateTime(fmt_datetime, Now)]);
        Designer.TextToStrings(S, EditorMsg.Lines);
        vSignString := vSignString + FillTo80('/* BT: ' + S + ' */') + sLineBreak;
        S := Format(SElapsedTime + '%s', [msToStr(GetTickCount - vRunTime)]);
        Designer.TextToStrings(S, EditorMsg.Lines);
        vSignString := vSignString + FillTo80('/* BT: ' + S + ' */');
        EditorMsgVisible;
        if SQLPlayer.SignScript then
        begin
          Designer.TextToStrings(vSignString, Editor.Lines);
          if not Editor.Modified then
            Editor.Modified := True;
        end;
      end;
  finally
    DRVPlayer.Terminator := ';';
    Tree.TreeOptions.SelectionOptions := Tree.TreeOptions.SelectionOptions -
      [toCenterScrollIntoView];
    ProgressBar1.Position := 0;
    Panel6.Caption := EmptyStr;
    Panel1.Visible := False;
    FRunning := False;
    Editor.SelectedColor.Background := FWasSelectedColor;
    Editor.EnsureCursorPosVisibleEx(True);
//    Screen.Cursor := crDefault;
    Editor.Invalidate;
    DRVPlayer.Database := nil;
    DRVPlayer.Transaction := nil;
    if Assigned(DRVTransaction) then
      DRVTransaction.Database := nil;
    if ARunFromFile then
      ShowFileName;
    FRunningFromFile := False;
  end;

  if SQLPlayer.SignScript and (not ARunFromFile) and (Length(CurrentFile) > 0) and
    (not IsUserModified) then Save;
end;

procedure TibSHSQLPlayerForm.Pause;
begin
  try
    Screen.Cursor := crHourGlass;
    if not IsTraceMode then
      DRVPlayer.Paused := True;
    FUserTerminated := True;
    FRunning := False;
    { do stop execute }
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TibSHSQLPlayerForm.Refresh;
begin
  if GetCanRefresh then
  begin
    FParserThread.NeedReparsing:=True;
    FProgressBarPriorPosition := 0;
    ParseScript;
  end;
end;

procedure TibSHSQLPlayerForm.ShowHideRegion(AVisible: Boolean);
begin
  FTreeVisible := AVisible; // FTreeVisible юзается по коду, как флаг

  Tree.Visible := AVisible;
  Splitter1.Visible := AVisible;
  if AVisible then
  begin
    Refresh;
    Splitter1.Left := Tree.Left + Tree.Width + 1;
  end;
end;

function TibSHSQLPlayerForm.GetCanRunCurrent: Boolean;
begin
  Result := Assigned(Tree.FocusedNode) and IsTraceMode and
    (Tree.FocusedNode.CheckState = csCheckedNormal) and
    (not FRunning);
end;

function TibSHSQLPlayerForm.GetCanRunFromCurrent: Boolean;
begin
  Result := Assigned(Tree.FocusedNode) and IsTraceMode and (not FRunning);
end;

function TibSHSQLPlayerForm.GetRegionVisible: Boolean;
begin
  Result := FTreeVisible;
end;

function TibSHSQLPlayerForm.GetCanRunFromFile: Boolean;
begin
  Result := Assigned(SQLPlayer) and (not FRunning);
end;

function TibSHSQLPlayerForm.ChangeNotification: Boolean;
var
  vFirstNode: PVirtualNode;
begin
  Result := True;
  if IsTraceMode then
  begin
    Editor.ReadOnly := True;
    Tree.Header.Options := Tree.Header.Options - [hoAutoResize];
    Tree.Header.Columns[0].Text := Format('%s', ['Trace List']);
    Tree.TreeOptions.MiscOptions := Tree.TreeOptions.MiscOptions + [toCheckSupport];
    Tree.TreeOptions.PaintOptions := Tree.TreeOptions.PaintOptions + [toFullVertGridLines];
    Tree.TreeOptions.PaintOptions := Tree.TreeOptions.PaintOptions + [toShowVertGridLines];
    Tree.Header.Columns[1].Options := Tree.Header.Columns[1].Options + [coVisible];
    Tree.Header.Columns[1].Width := 85;
    ShowHideRegion(True);
    vFirstNode := Tree.GetFirst;
    if Assigned(vFirstNode) then
    begin
      Tree.FocusedNode := vFirstNode;
      Tree.Selected[vFirstNode] := True;
      SelectStatement(vFirstNode);
    end;
    Result := PrepareTraceMode;
  end
  else
  begin
    UnPrepareTraceMode;
    Editor.ReadOnly := False;
    Tree.Header.Options := Tree.Header.Options + [hoAutoResize];
    Tree.Header.Columns[0].Text := Format('%s', ['Tree']);
    Tree.TreeOptions.MiscOptions := Tree.TreeOptions.MiscOptions - [toCheckSupport];
    Tree.TreeOptions.PaintOptions := Tree.TreeOptions.PaintOptions - [toFullVertGridLines];
    Tree.TreeOptions.PaintOptions := Tree.TreeOptions.PaintOptions - [toShowVertGridLines];
    Tree.Header.Columns[1].Options := Tree.Header.Columns[1].Options - [coVisible];
    Refresh;
  end;
  if Assigned(StatusBar) then
    StatusBar.Top := Self.Height;
end;

procedure TibSHSQLPlayerForm.InsertScript(AText: string);
begin
  Editor.Clear;
  Editor.Text := AText;
  Refresh;
end;

procedure TibSHSQLPlayerForm.CheckAll;
var
  Node: PVirtualNode;
begin
  if IsTraceMode then
  begin
    Node := Tree.GetFirst;
    while Assigned(Node) do
    begin
      Node.CheckState := csCheckedNormal;
      Node := Tree.GetNextSibling(Node);
    end;
    Tree.Invalidate;
  end;
end;

procedure TibSHSQLPlayerForm.UnCheckAll;
var
  Node: PVirtualNode;
begin
  if IsTraceMode then
  begin
    Node := Tree.GetFirst;
    while Assigned(Node) do
    begin
      Node.CheckState := csUnCheckedNormal;
      Node := Tree.GetNextSibling(Node);
    end;
    Tree.Invalidate;
  end;
end;

procedure TibSHSQLPlayerForm.RunCurrent;
var
  Node: PVirtualNode;
  Data: PScriptNode;
  vDummyBool: Boolean;
  vDummyBool2: Boolean;
  S: string;
begin
  if GetCanRunCurrent then
  begin
    try
      EditorMsgVisible(False);
      ClearMessages;
      FRunning := True;
      FWasErrors := False;
      SelectStatement(Tree.FocusedNode);
      Data := Tree.GetNodeData(Tree.FocusedNode);
      TracedLine := Data.StatementPos.Top;
  //    DRVPlayer.Script.Text := FParserThread.DRVParser.Statements[Data.StatementNo];
      DRVPlayer.Script.Text := Editor.SelText;
//      Screen.Cursor := crDefault;
      try
        DRVPlayer.Execute;
      except
        FWasErrors := True;
      end;
      S := EmptyStr;
      if not FWasErrors and (Length(DRVPlayer.ErrorText) > 0) then
      begin
        FWasErrors := True;
        PlayerOnError(DRVPlayer, DRVPlayer.ErrorText, EmptyStr, Editor.CaretY - 1, vDummyBool, vDummyBool2);
        S := DRVPlayer.ErrorText;
      end;
      if FWasErrors then
      begin
        Data.ExecutionResult := Format('Error: %s', [S]);
        S := Format(SPlayerStatementExecutedWithErrorsAt + '%s', [FormatDateTime(fmt_datetime, Now)]);
        Designer.TextToStrings(S, EditorMsg.Lines);
        EditorMsgVisible;
        Tree.InvalidateNode(Tree.FocusedNode);
      end else
      begin
        Data.ExecutionResult := Format('Success', []);
        Tree.InvalidateNode(Tree.FocusedNode);
        Node := Tree.GetNextSibling(Tree.FocusedNode);
        while Assigned(Node) do
        begin
          if (Node.CheckState = csCheckedNormal) then Break;
          Node := Tree.GetNextSibling(Node);
        end;
  //      if not Assigned(Node) then
  //        Node := Tree.GetFirst;
        if Assigned(Node) then
        begin
          Tree.FocusedNode := Node;
          Tree.Selected[Node] := True;
          pSHSynEdit1.Invalidate;
          SelectStatement(Node);
        end
        else
          DRVPlayer.Terminator := ';';
      end;
    finally
      FRunning := False;
      Designer.UpdateActions;
    end;
  end;
end;

procedure TibSHSQLPlayerForm.RunFromCurrent;
var
  Node: PVirtualNode;
  Data: PScriptNode;
  vDummyBool: Boolean;
  vDummyBool2: Boolean;
  S: string;
begin
  if GetCanRunFromCurrent then
  begin
    try
      Tree.TreeOptions.SelectionOptions := Tree.TreeOptions.SelectionOptions +
        [toCenterScrollIntoView];
      EditorMsgVisible(False);
      ClearMessages;
      FRunning := True;
      FWasErrors := False;

      Node := Tree.FocusedNode;
      while Assigned(Node) do
      begin
        if (Node.CheckState = csCheckedNormal) then Break;
        Node := Tree.GetNextSibling(Node);
      end;
      if Assigned(Node) then
      begin
        Tree.FocusedNode := Node;
        Tree.Selected[Node] := True;
      end;

      while Assigned(Node) and FRunning do
      begin
        SelectStatement(Node);
        Data := Tree.GetNodeData(Node);
        TracedLine := Data.StatementPos.Top;
        DRVPlayer.Script.Text := Editor.SelText;
        Screen.Cursor := crDefault;
        try
          DRVPlayer.Execute;
        except
          FWasErrors := True;
        end;
        S := EmptyStr;
        if not FWasErrors and (Length(DRVPlayer.ErrorText) > 0) then
        begin
          FWasErrors := True;
          PlayerOnError(DRVPlayer, DRVPlayer.ErrorText, EmptyStr, Editor.CaretY - 1, vDummyBool, vDummyBool2);
          S := DRVPlayer.ErrorText;
        end;
        if FWasErrors then
        begin
          Data.ExecutionResult := Format('Error: %s', [S]);
          S := Format(SPlayerStatementExecutedWithErrorsAt + '%s', [FormatDateTime(fmt_datetime, Now)]);
          Designer.TextToStrings(S, EditorMsg.Lines);
          EditorMsgVisible;
          Tree.InvalidateNode(Tree.FocusedNode);
          if SQLPlayer.AbortOnError then
          begin
            if AnsiSameText(SQLPlayer.AfterError, PlayerAfterErrors[1]) then
              DRVTransaction.Rollback
            else
              DRVTransaction.Commit;
            Break;
          end;  
        end else
        begin
          Data.ExecutionResult := Format('Success', []);
          Tree.InvalidateNode(Tree.FocusedNode);
        end;

        Node := Tree.GetNextSibling(Tree.FocusedNode);
        while Assigned(Node) do
        begin
          if (Node.CheckState = csCheckedNormal) then Break;
          Node := Tree.GetNextSibling(Node);
        end;
        if Assigned(Node) then
        begin
          Tree.FocusedNode := Node;
          Tree.Selected[Node] := True;
        end;
      end;
    finally
      DRVPlayer.Terminator := ';';
      Tree.TreeOptions.SelectionOptions := Tree.TreeOptions.SelectionOptions -
        [toCenterScrollIntoView];
      FRunning := False;
      Designer.UpdateActions;
    end;
  end;
end;

procedure TibSHSQLPlayerForm.RunFromFile;
begin
  DoRun(True);
end;

procedure TibSHSQLPlayerForm.ParseScript;
var
  vTerminator: string;
begin
  tmLaunchParsing.Enabled := False;
  if FTreeVisible and {--FParserThread.Suspended and }(Editor.Modified ) then
  begin
    vTerminator := DRVPlayer.Terminator;
    DRVPlayer.Terminator := ';';
    FParserThread.NeedReparsing:=True;
    DRVPlayer.Terminator := vTerminator;
  end;
end;

function TibSHSQLPlayerForm.PrepareTraceMode: Boolean;
var
//  vSignString: string;
  S: string;
begin
//  Result := False;
  FMakeConnection := not Assigned(SQLPlayer.BTCLDatabase);
  FreeDRV;
  FRunningFromFile := False;

//  FProgressBarPriorPosition := 0;
  ClearChangeNameList;
  EditorMsgVisible(False);
  ClearMessages;
  FUserTerminated := False;
  FWasSelectedColor := Editor.SelectedColor.Background;
  Editor.SelectedColor.Background := RGB(140,170, 210);
//  FRunning := True;
  Designer.UpdateActions;
  //Для прогресс бара, а также при not FMakeConnection
  Application.ProcessMessages;
  try
    if not FMakeConnection then
    begin
      if HasConnectStatements then
      begin
        FMakeConnection := True;
        //if not Designer.ShowMsg(SPlayerContainsDatabaseStats, mtConfirmation) then
        //begin
        //  FMakeConnection := False;
        //  Exit;
        //end;
      end;
    end;
    CreateDRV(FMakeConnection);
    if FMakeConnection then
    begin
      DRVTransaction.Database := DRVDatabase;
      DRVPlayer.Database := DRVDatabase;
    end
    else
    begin
      DRVTransaction.Database := SQLPlayer.BTCLDatabase.DRVDatabase;
      DRVPlayer.Database := SQLPlayer.BTCLDatabase.DRVDatabase;
    end;
    DRVPlayer.Transaction := DRVTransaction;
    DRVPlayer.AutoDDL :=  SQLPlayer.AutoDDL;
    DRVPlayer.Terminator := ';';
    DRVPlayer.SQLDialect := SQLPlayer.DefaultSQLDialect;

    FWasErrors := False;
    S := Format(SPlayerTraceModeStartedAt + '%s', [FormatDateTime(fmt_datetime, Now)]);
    Designer.TextToStrings(S, EditorMsg.Lines);
    Panel4.Height := 30;
    EditorMsgVisible;
    Application.ProcessMessages;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TibSHSQLPlayerForm.UnPrepareTraceMode;
var
 iDB:IibSHDRVDatabase;
 iTr:IibSHDRVTransaction;
begin
  ClearMessages;
  EditorMsgVisible(False);

  DRVPlayer.Database := nil;
  DRVPlayer.Transaction := nil;

  iTr:=DRVTransaction;
  if Assigned(iTr) then
  begin
    if iTr.InTransaction then
      if Designer.ShowMsg(SUncommitedChanges, mtConfirmation) then
        iTr.Commit
      else
        iTr.Rollback;
  end;
//  if FMakeConnection and Assigned(DRVPlayer.Database) then
//    DRVPlayer.Database.Disconnect;
  iDB:=DRVDatabase;
  if FMakeConnection and Assigned(iDB) then
    iDB.Disconnect;

  Editor.SelectedColor.Background := FWasSelectedColor;
  iDB:=nil;
  iTr:=nil;
  FreeDRV;
end;

function TibSHSQLPlayerForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
  if Result then
  begin
  end;
end;

procedure TibSHSQLPlayerForm.DoAfterLoadFile;
begin
  Screen.Cursor := crHourGlass;
  try
    if IsTraceMode then
     UnPrepareTraceMode;
    Editor.Modified:=True;
    ParseScript;
    if IsTraceMode then
     PrepareTraceMode;
  finally
    Editor.Modified:=False;  
    Screen.Cursor := crDefault;
  end;
end;

function TibSHSQLPlayerForm.GetCanDestroy: Boolean;
begin
  Result := inherited GetCanDestroy;
  if Result then
  begin
    if FRunning then
    begin
      Designer.ShowMsg(Format('Script is running...', []), mtInformation);
      Result := False;
    end else
    begin
      if Assigned(Editor) and Editor.Modified then
      begin
//        case Designer.ShowMsg(SFileModified) of
        case Designer.ShowMsg(STextModified) of
          IDCANCEL: Result := False;
          IDYES:    Save;
        end;
      end
    end

  end;
end;

procedure TibSHSQLPlayerForm.SetStatusBar(Value: TStatusBar);
begin
  inherited SetStatusBar(Value);
  {
  if Assigned(StatusBar) then
  begin
    StatusBar.Panels.Clear;
    StatusBar.SimplePanel := False;
    if Assigned(Editor) then
    begin
      with StatusBar.Panels do
      begin
        with Add do
        begin
          Alignment := taCenter;
          Width := 85;
        end;
        with Add do Width := 75;
        with Add do Width := 75;
        with Add do Width := 150;
        with Add do Alignment := taLeftJustify;
      end;
    end;
  end;
  }
end;

procedure TibSHSQLPlayerForm.SetTopLineForStatement(AStatementRect: TRect);
var
  vStatHeigth: Integer;
  vTopLine: Integer;
begin
  vStatHeigth := AStatementRect.Bottom - AStatementRect.Top;
  if (vStatHeigth < Editor.LinesInWindow) then
  begin
    vTopLine := ((Editor.LinesInWindow - vStatHeigth) div 2);
    if vTopLine < 4 then vTopLine := 4;
    Editor.TopLine := AStatementRect.Top - vTopLine;
  end
  else
    Editor.TopLine := AStatementRect.Top - 4;
end;

procedure TibSHSQLPlayerForm.SelectStatement(ANode: PVirtualNode);
var
  Data: PScriptNode;
  vStatementRect: TRect;
begin
  with Tree do
  begin
    Data := GetNodeData(ANode);
    if Assigned(Data) then
    begin
      vStatementRect := Data.StatementPos;
      if (vStatementRect.Bottom <> 0) or
         (vStatementRect.Right <> 0) then
      begin
        Inc(vStatementRect.Top, 1);
        Inc(vStatementRect.Bottom, 1);
        Inc(vStatementRect.Right, 1);
        Editor.BeginUpdate;
        SetTopLineForStatement(vStatementRect);
        Editor.BlockBegin := TBufferCoord(vStatementRect.TopLeft);
        Editor.BlockEnd := TBufferCoord(vStatementRect.BottomRight);
        Editor.EndUpdate;
      end;
    end;
  end;
end;

procedure TibSHSQLPlayerForm.ClearChangeNameList;
var
  I: Integer;
begin
  for I := 0 to Pred(FChangeNameList.Count) do
    Dispose(PChangeNameListRecord(FChangeNameList[I]));
  FChangeNameList.Clear;
end;

procedure TibSHSQLPlayerForm.BringToTop;
begin
  if Assigned(StatusBar) then
  begin
    DoUpdateStatusBarByState([scCaretX, scCaretY, scAll, scModified, scReadOnly, scInsertMode]);
    DoOnFindTextChange(Editor, Editor.IsSearchIncremental, Editor.FindText);
  end;
  if Assigned(FocusedControl) and FocusedControl.CanFocus then FocusedControl.SetFocus;
end;

procedure TibSHSQLPlayerForm.tmLaunchParsingTimer(Sender: TObject);
begin
  FParserThread.NeedReparsing:=True;
  tmLaunchParsing.Enabled:=False;
end;

procedure TibSHSQLPlayerForm.pSHSynEdit2DblClick(Sender: TObject);
var
  vCurrentLine: Integer;
  vTopMessageLine: Integer;
  vBottomMessageLine: Integer;
  S: string;
  vTopStatementLine: Integer;
  vErrorCoord: TBufferCoord;
begin
  vCurrentLine := EditorMsg.CaretY - 1;
  while (vCurrentLine >= 0) and
    (Pos(SErrorMessagesHeader, EditorMsg.Lines[vCurrentLine]) = 0) do Dec(vCurrentLine);
  S := System.Copy(EditorMsg.Lines[vCurrentLine], Length(SErrorMessagesHeader) + 1, MaxInt);
  S := Trim(System.Copy(S, 1, Pos(' ', S)));
  vTopStatementLine := StrToIntDef(S, 1) - 1;
  Inc(vCurrentLine);
  vTopMessageLine := vCurrentLine;
  while (vCurrentLine < EditorMsg.Lines.Count) and
    (Pos(SErrorMessagesHeader, EditorMsg.Lines[vCurrentLine]) = 0) do Inc(vCurrentLine);
  Dec(vCurrentLine);
  vBottomMessageLine := vCurrentLine;
  EditorMsg.BeginUpdate;
  EditorMsg.BlockBegin := TBufferCoord(Point(1, vTopMessageLine + 1));
  EditorMsg.BlockEnd := TBufferCoord(Point(Length(EditorMsg.Lines[vBottomMessageLine]) + 1, vBottomMessageLine + 1));
  S := EditorMsg.SelText;
  EditorMsg.EndUpdate;
  vErrorCoord := GetErrorCoord(S);
  if vErrorCoord.Line = -1 then vErrorCoord.Line := 1;
  Inc(vErrorCoord.Line, vTopStatementLine);
  ErrorCoord := vErrorCoord;
end;

procedure TibSHSQLPlayerForm.pmiHideMessageClick(Sender: TObject);
begin
  EditorMsgVisible(False);
end;

{ Tree }

procedure TibSHSQLPlayerForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TScriptNode);
end;

procedure TibSHSQLPlayerForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PScriptNode;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibSHSQLPlayerForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PScriptNode;
begin
  Data := Sender.GetNodeData(Node);
  case Column of
    0: if (Kind = ikNormal) or (Kind = ikSelected) then ImageIndex := Data.ImageIndex;
    1: ImageIndex := -1;
  end;
end;

procedure TibSHSQLPlayerForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PScriptNode;
  vChildCount: Integer;
begin
  Data := Sender.GetNodeData(Node);
  vChildCount := Node.ChildCount;
  case Column of
    0: case TextType of
         ttNormal: CellText := Data.Caption;
         ttStatic:
           if (Node.ChildCount > 0) then
             CellText := '(' + IntToStr(vChildCount) + ')';
       end;
    1: case TextType of
         ttNormal: CellText := Data.ExecutionResult;
         ttStatic: CellText := EmptyStr;
       end;
  end;
end;

procedure TibSHSQLPlayerForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  case TextType of
    ttNormal: ;
    ttStatic: if Sender.Focused and (vsSelected in Node.States) then
                TargetCanvas.Font.Color := clWindow
              else
                TargetCanvas.Font.Color := clGray;
  end;
end;

procedure TibSHSQLPlayerForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PScriptNode;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.Caption)) <> 1 then
    Result := 1;
end;

procedure TibSHSQLPlayerForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then DoOnEnter;
end;

procedure TibSHSQLPlayerForm.TreeDblClick(Sender: TObject);
begin
  DoOnEnter;
end;

procedure TibSHSQLPlayerForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PScriptNode;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  Result := AnsiCompareText(Data1.Caption, Data2.Caption);
end;

{ TParserThreaded }

//--constructor TParserThreaded.Create(CreateSuspended: Boolean);
//--begin
//--  inherited Create(CreateSuspended);
//--  FForceExecute := False;
//--  FExpandedNodes := TList.Create;
//--end;

constructor TParserThreaded.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FExpandedNodes := TList.Create;
end;

destructor TParserThreaded.Destroy;
begin
  ClearExpandedNodes;
  FExpandedNodes.Free;
  if Assigned(FDRVParser) then
  begin
    FreeAndNil(FDRVParser);
  end;
  inherited Destroy;
end;

function TParserThreaded.GetDRVParser: IibSHDRVSQLParser;
begin
  Supports(FDRVParser, IibSHDRVSQLParser, Result);
end;

procedure TParserThreaded.SetEditorForm(const Value: TibSHSQLPlayerForm);
var
  vComponentClass: TSHComponentClass;
  vDesigner: ISHDesigner;
begin
  if FEditorForm <> Value then
  begin
    FEditorForm := Value;
    if Assigned(FDRVParser) then
      FreeAndNil(FDRVParser);
    if Assigned(FEditorForm) then
    begin
      if SHSupports(ISHDesigner, vDesigner) then
      begin
        vComponentClass := vDesigner.GetComponent(EditorForm.SQLPlayer.BTCLServer.DRVNormalize(IibSHDRVSQLParser));
        if Assigned(vComponentClass) then
        begin
          FDRVParser := vComponentClass.Create(nil);
          DRVParser.SQLParserNotification := EditorForm as IibSHDRVSQLParserNotification;
        end;
      end;
    end;
  end;
end;

procedure TParserThreaded.ClearExpandedNodes;
var
  I: Integer;
begin
  for I := 0 to FExpandedNodes.Count - 1 do
    Dispose(PPoint(FExpandedNodes[I]));
  FExpandedNodes.Clear;
end;

procedure TParserThreaded.SaveExpandedNodes;
var
  vCurrent: PVirtualNode;
  vLevel: Cardinal;
  vPoint: PPoint;
begin
  ClearExpandedNodes;
  FFocusedNode := Rect(-1,-1,-1,-1);
  with EditorForm.Tree do
  begin
    vCurrent := GetFirst;
    while Assigned(vCurrent) do
    begin
      vLevel := GetNodeLevel(vCurrent);
      if vLevel <= 1 then
      begin
        if Expanded[vCurrent] then
        begin
          New(vPoint);
          if vLevel = 0 then
          begin
            vPoint.X := vCurrent.Index;
            vPoint.Y := -1;
          end
          else
          begin
            vPoint.X := vCurrent.Parent.Index;
            vPoint.Y := vCurrent.Index;
          end;
          FExpandedNodes.Add(vPoint);
        end;
      end;
      if (FocusedNode = vCurrent) then
      begin
        case vLevel of
          0:  begin
                FFocusedNode.Left := vCurrent.Index;
              end;
          1:  begin
                FFocusedNode.Left := vCurrent.Parent.Index;
                FFocusedNode.Top := vCurrent.Index;
              end;
          2:  begin
                FFocusedNode.Left := vCurrent.Parent.Parent.Index;
                FFocusedNode.Top := vCurrent.Parent.Index;
                FFocusedNode.Right := vCurrent.Index;
              end;
        end;
      end;
      vCurrent := GetNext(vCurrent);
    end;
  end;
end;

procedure TParserThreaded.RestoreExpandedNodes;
var
  I: Integer;
  procedure DebugS(N: PVirtualNode);
  var
    Data: PScriptNode;
    S: string;
  begin
    if Assigned(N) then
    begin
      Data := EditorForm.Tree.GetNodeData(N);
      S := Data.Caption;
      if true then ;
    end;
  end;
  function GetNodeByLC(APoint: TRect): PVirtualNode;
    function GetChild(ANode: PVirtualNode; AIndex: Integer): PVirtualNode;
    var
      vNode: PVirtualNode;
      I: Integer;
    begin
      Result := nil;
      if Assigned(ANode) and (AIndex > -1) then
      begin
        I := 0;
        vNode := ANode.FirstChild;
        while (I < AIndex) do
        begin
          if Assigned(vNode) then
            vNode := vNode.NextSibling
          else
            break;
          Inc(I);
        end;
        Result := vNode;
        DebugS(Result);
      end;
    end;
  begin
    Result := EditorForm.Tree.RootNode;
    Result := GetChild(Result, APoint.Left);
    if Assigned(Result) and (APoint.Top > -1) then
    begin
      Result := GetChild(Result, APoint.Top);
      if Assigned(Result) and (APoint.Right > -1) then
        Result := GetChild(Result, APoint.Right);
    end;
    DebugS(Result);
  end;
begin
  with EditorForm.Tree do
  begin
    for I := 0 to FExpandedNodes.Count - 1 do
      Expanded[GetNodeByLC(Rect(PPoint(FExpandedNodes[I]).X, PPoint(FExpandedNodes[I]).Y, -1, -1))] := True;
    FocusedNode := GetNodeByLC(FFocusedNode);
    Selected[FocusedNode] := True;
    ScrollIntoView(FocusedNode, toCenterScrollIntoView in TreeOptions.SelectionOptions );    
  end;
end;

procedure TParserThreaded.LoadScript;
begin
//  Screen.Cursor := crHourGlass;
  try
    if Assigned(EditorForm) and Assigned(EditorForm.Editor) then
      DRVParser.Script.Assign(EditorForm.Editor.Lines)
    else
      DRVParser.Script.Clear
  finally
//    Screen.Cursor := crDefault;
  end;
end;

procedure TParserThreaded.DoWork;
var
  vTerminator: string;
begin
  if Assigned(DRVParser) then
  begin
    vTerminator := DRVParser.Terminator;
    DRVParser.Terminator := ';';
    if DRVParser.Parse then
    begin
      //is anything to do?
    end;
    DRVParser.Terminator := vTerminator;
  end;
end;

procedure TParserThreaded.Execute;
var
  c:Cardinal;
begin
 while True and not Terminated do
 begin
  if FNeedReparsing then
  try
    LoadScript;
    DoWork;
    FStopFillTree:=False;
    EditorForm.Tree.BeginUpdate;
    FillTree;
    Synchronize(EditorForm.Tree.EndUpdate)
    // Synchronize ушел сюда чтоб "длинная" операция FillTree не тормозила основной тред

  finally
   FNeedReparsing:=False
  end;
 end;

 //  Screen.Cursor := crHourGlass;
{
  if not Terminated then
  begin
    Priority := tpNormal;
    Synchronize(LoadScript);
  end;
  if not Terminated then
  begin
    if FForceExecute then
    begin
      Screen.Cursor := crHourGlass;
      Synchronize(ProgressOn);
      try
        Synchronize(DoWork)
      finally
        Synchronize(ProgressOff);
        Screen.Cursor := crDefault;
      end;
    end
    else
    begin
      Priority := tpIdle;
      DRVParser.SQLParserNotification := nil;
      try
        DoWork;
      finally
        DRVParser.SQLParserNotification := EditorForm as IibSHDRVSQLParserNotification;
      end;
    end;
  end;
  if not Terminated then
  begin
    Priority := tpNormal;
    Synchronize(FillTree);
  end;
}
end;


function IsEqualGUID(const guid1, guid2: TGUID): Boolean;
var
  a, b: PIntegerArray;
begin
  a := PIntegerArray(@guid1);
  b := PIntegerArray(@guid2);
  Result := (a^[0] = b^[0]) and (a^[1] = b^[1]) and (a^[2] = b^[2]) and (a^[3] = b^[3]);
end;

procedure TParserThreaded.FillTree;
var
  I: Integer;
//  J: Integer;
  vObjectTypeId: Integer;
  vRootNodes: TStringList;
  S: string;
  vPos: Integer;

  vNodeDatabases: PVirtualNode;
  vNodeDomains: PVirtualNode;
  vNodeTables: PVirtualNode;
  vNodeViews: PVirtualNode;
  vNodeProcedures: PVirtualNode;
  vNodeTriggers: PVirtualNode;
  vNodeGenerators: PVirtualNode;
  vNodeExceptions: PVirtualNode;
  vNodeFunctions: PVirtualNode;
  vNodeRoles: PVirtualNode;
  vNodeIndices: PVirtualNode;
  vNodeDML: PVirtualNode;
  vNodeUnknown: PVirtualNode;
  //Filter, Shadow
  vCurrentObjectList: TStringList;
  vCurrentObjectNodeIndex: Integer;
  vCurrentObjectNode: PVirtualNode;

  vCurIntfGuid      :TGUID;
  objName           :string;
  c:integer;
  vNode: PVirtualNode;
  NodeData: PScriptNode;
  
  function AddObjList: TStringList;
  begin
    Result := TStringList.Create;
    Result.CaseSensitive:=True;
    Result.Sorted := True;
    Result.Capacity:=1000;
  end;
begin
  if Assigned(EditorForm) then
  begin
    EditorForm.HasConnectStatements := False;
    if EditorForm.IsTraceMode then
    begin
      EditorForm.Tree.Clear;
//      EditorForm.Tree.BeginUpdate;
      try
        with EditorForm.Tree do
        begin
          for I := 0 to Pred(DRVParser.Count) do
          begin
            if FStopFillTree then
              Exit;
            vCurIntfGuid:=DRVParser.StatementObjectType(I);
            if IsEqualGUID(vCurIntfGuid, IibSHDomain) then
             vObjectTypeId := 1
            else
            if IsEqualGUID(vCurIntfGuid, IibSHTable) then
             vObjectTypeId := 2
            else
            if IsEqualGUID(vCurIntfGuid, IibSHView) then
             vObjectTypeId := 3
            else
            if IsEqualGUID(vCurIntfGuid, IibSHProcedure) then
             vObjectTypeId := 4
            else
            if IsEqualGUID(vCurIntfGuid, IibSHTrigger) then
             vObjectTypeId := 5
            else
            if IsEqualGUID(vCurIntfGuid, IibSHGenerator) then
             vObjectTypeId := 6
            else
            if IsEqualGUID(vCurIntfGuid, IibSHException) then
             vObjectTypeId := 7
            else
            if IsEqualGUID(vCurIntfGuid, IibSHFunction) then
             vObjectTypeId := 8
            else
            if IsEqualGUID(vCurIntfGuid, IibSHRole) then
             vObjectTypeId := 9
            else
            if IsEqualGUID(vCurIntfGuid, IibSHIndex) then
             vObjectTypeId := 10
            else
            if IsEqualGUID(vCurIntfGuid, IibSHDatabase) then
            begin
              vObjectTypeId := 0;
              EditorForm.HasConnectStatements := True;
            end
            else
            if IsEqualGUID(vCurIntfGuid, IibSHGrant) then
             vObjectTypeId := 11
            else
             vObjectTypeId := 12;
            vNode := AddChild(nil);
            vNode.CheckType := ctTriStateCheckBox;
            vNode.CheckState := csCheckedNormal;
            NodeData := GetNodeData(vNode);
            S := DRVParser.Statements[I];
            vPos := Pos(#13#10, S);
            if vPos > 0 then
              NodeData.Caption := Copy(S, 1, vPos - 1) + '...'
            else
              NodeData.Caption := S;
            NodeData.StatementNo := I;
            NodeData.StatementPos := DRVParser.StatementsCoord(I);
            NodeData.ImageIndex := Integer(EditorForm.FImageIndeces[vObjectTypeId]);
            NodeData.ExecutionResult := Format('Not executed', []);
          end;
        end;
      finally
//        Screen.Cursor := crDefault;
        EditorForm.Tree.EndUpdate;
      end;
    end
    else
    begin
      SaveExpandedNodes;
      EditorForm.Tree.Clear;
//      EditorForm.Tree.BeginUpdate;
      vRootNodes := TStringList.Create;
      vRootNodes.AddObject(SDatabases, AddObjList);   //0
      vRootNodes.AddObject(SDomains, AddObjList);     //1
      vRootNodes.AddObject(STables, AddObjList);      //2
      vRootNodes.AddObject(SViews, AddObjList);       //3
      vRootNodes.AddObject(SProcedures, AddObjList);  //4
      vRootNodes.AddObject(STriggers, AddObjList);    //5
      vRootNodes.AddObject(SGenerators, AddObjList);  //6
      vRootNodes.AddObject(SExceptions, AddObjList);  //7
      vRootNodes.AddObject(SFunctions, AddObjList);   //8
      vRootNodes.AddObject(SRoles, AddObjList);       //9
      vRootNodes.AddObject(SIndices, AddObjList);     //10
      vRootNodes.AddObject(cDML, AddObjList);     //11
      vRootNodes.AddObject(cUnknown, AddObjList);     //12
//      Screen.Cursor := crHourGlass;
      try
        with EditorForm.Tree do
        begin
          vNodeDatabases := nil;
          vNodeDomains := nil;
          vNodeTables := nil;
          vNodeViews := nil;
          vNodeProcedures := nil;
          vNodeTriggers := nil;
          vNodeGenerators := nil;
          vNodeExceptions := nil;
          vNodeFunctions := nil;
          vNodeRoles := nil;
          vNodeIndices := nil;
          vNodeDML:=nil;
          vNodeUnknown:=nil;
          for I := 0 to 12 do
          begin
            if FStopFillTree then
              Exit;

            vNode := AddChild(nil);
            NodeData := GetNodeData(vNode);
            NodeData.Caption := vRootNodes[I];
            NodeData.StatementNo := -1;
            NodeData.StatementPos := Rect(0,0,0,0);
            case I of
             11: NodeData.ImageIndex := Integer(EditorForm.FImageIndeces[I])+1;
             12: NodeData.ImageIndex := 7; //Unknown
            else
             NodeData.ImageIndex := Integer(EditorForm.FImageIndeces[I])
            end ;
            case I of
              0: vNodeDatabases := vNode;
              1: vNodeDomains := vNode;
              2: vNodeTables := vNode;
              3: vNodeViews := vNode;
              4: vNodeProcedures := vNode;
              5: vNodeTriggers := vNode;
              6: vNodeGenerators := vNode;
              7: vNodeExceptions := vNode;
              8: vNodeFunctions := vNode;
              9: vNodeRoles := vNode;
             10: vNodeIndices := vNode;
             11: vNodeDML:= vNode;
             12: vNodeUnknown:= vNode;
            end;//case
          end;
          c:=Pred(DRVParser.Count);
          for I := 0 to c do
          begin
            if FStopFillTree then
              Exit;

            vCurIntfGuid:=DRVParser.StatementObjectType(I);

            if IsEqualGUID(vCurIntfGuid, IibSHDomain) then
             vObjectTypeId := 1
            else
            if IsEqualGUID(vCurIntfGuid, IibSHTable) then
             vObjectTypeId := 2
            else
            if IsEqualGUID(vCurIntfGuid, IibSHView) then
             vObjectTypeId := 3
            else
            if IsEqualGUID(vCurIntfGuid, IibSHProcedure) then
             vObjectTypeId := 4
            else
            if IsEqualGUID(vCurIntfGuid, IibSHTrigger) then
             vObjectTypeId := 5
            else
            if IsEqualGUID(vCurIntfGuid, IibSHGenerator) then
             vObjectTypeId := 6
            else
            if IsEqualGUID(vCurIntfGuid, IibSHException) then
             vObjectTypeId := 7
            else
            if IsEqualGUID(vCurIntfGuid, IibSHFunction) then
             vObjectTypeId := 8
            else
            if IsEqualGUID(vCurIntfGuid, IibSHRole) then
             vObjectTypeId := 9
            else
            if IsEqualGUID(vCurIntfGuid, IibSHIndex) then
             vObjectTypeId := 10
            else
            if IsEqualGUID(vCurIntfGuid, IibSHDatabase) then
            begin
              vObjectTypeId := 0;
              EditorForm.HasConnectStatements := True;
            end
            else
            begin
              S:=DRVParser.StatementOperationName(I);
              if S='GRANT' then
              begin
                objName:=DRVParser.StatementObjectName(I);
                if TStringList(vRootNodes.Objects[2]).Find(objName, vCurrentObjectNodeIndex) then
                 vObjectTypeId := 2
                else
                if TStringList(vRootNodes.Objects[3]).Find(objName, vCurrentObjectNodeIndex) then
                 vObjectTypeId := 3
                else
                if TStringList(vRootNodes.Objects[4]).Find(objName, vCurrentObjectNodeIndex) then
                 vObjectTypeId := 4;
              end
              else
              if S='DML' then
                vObjectTypeId := 11
              else
                vObjectTypeId := 12;
//               Continue;
            end; 
// 1        
            objName:=DRVParser.StatementObjectName(I);
            vCurrentObjectList := TStringList(vRootNodes.Objects[vObjectTypeId]);
            if (vObjectTypeId = 0) and (objName = 'DATABASE') then
            begin
              vCurrentObjectNodeIndex := Pred(vCurrentObjectList.Count);
              if vCurrentObjectNodeIndex = -1 then Continue;
            end
            else
             if not vCurrentObjectList.Find(objName, vCurrentObjectNodeIndex) then
              vCurrentObjectNodeIndex := -1;



            if vCurrentObjectNodeIndex = -1 then
            begin
              vCurrentObjectNode := nil;
              case vObjectTypeId of
                0: vCurrentObjectNode := vNodeDatabases;
                1: vCurrentObjectNode := vNodeDomains;
                2: vCurrentObjectNode := vNodeTables;
                3: vCurrentObjectNode := vNodeViews;
                4: vCurrentObjectNode := vNodeProcedures;
                5: vCurrentObjectNode := vNodeTriggers;
                6: vCurrentObjectNode := vNodeGenerators;
                7: vCurrentObjectNode := vNodeExceptions;
                8: vCurrentObjectNode := vNodeFunctions;
                9: vCurrentObjectNode := vNodeRoles;
                10: vCurrentObjectNode := vNodeIndices;
                11: vCurrentObjectNode := vNodeDML;
                12:
                begin
                 S:=DRVParser.StatementOperationName(I);
                 if (S='SET') or (S='COMMIT') or (S='ROLLBACK') then
                 else
                  vCurrentObjectNode := vNodeUnknown;
                end;
              end;

              if vCurrentObjectNode=nil then
               Continue;
             if not (vObjectTypeId in [11,12]) then
             begin
              vNode := AddChild(vCurrentObjectNode);
              NodeData := GetNodeData(vNode);
              NodeData.Caption := objName;
              NodeData.StatementNo := -1;
              NodeData.StatementPos := Rect(0,0,0,0);
              NodeData.ImageIndex := Integer(EditorForm.FImageIndeces[vObjectTypeId]);
              vCurrentObjectNodeIndex := vCurrentObjectList.AddObject(objName, pointer(vNode));
             end;
            end;
            if not (vObjectTypeId in [11,12]) then
            begin
             vCurrentObjectNode := PVirtualNode(vCurrentObjectList.Objects[vCurrentObjectNodeIndex]);
            end;
            vNode := AddChild(vCurrentObjectNode);
            NodeData := GetNodeData(vNode);



            case DRVParser.StatementState(I) of
              csUnknown:           NodeData.Caption := cStateSQL;
              csSource, csCreate:  NodeData.Caption := cStateCreate;
              csAlter:
                if vObjectTypeId = 0 then
                begin
                  S := AnsiUpperCase(ExtractWord(1, DRVParser.Statements[I], CharsAfterClause));
                  if S = 'CONNECT' then NodeData.Caption := cStateConnect else
                  if S = 'RECONNECT' then NodeData.Caption := cStateReConnect else
                  if S = 'DISCONNECT' then NodeData.Caption := cStateDisConnect else
                   NodeData.Caption := cStateSQL;
                end
                else
                  NodeData.Caption := cStateAlter;
              csDrop:              NodeData.Caption := cStateDrop;
              csRecreate:          NodeData.Caption := cStateRecreate;
            end;

            NodeData.StatementNo := I;
            NodeData.StatementPos := DRVParser.StatementsCoord(I);
            S:=DRVParser.StatementOperationName(I);
            if S='GRANT' then
            begin
             NodeData.Caption := cStateGrant;
             NodeData.ImageIndex := 11
            end
            else
            if S='COMMENT' then
            begin
             NodeData.Caption := cComment;
             NodeData.ImageIndex := 15
            end
            else
            if S='COMMIT' then
            begin
             NodeData.Caption := 'Commit';
             NodeData.ImageIndex := img_statement;
            end
            else
            if DRVParser.StatementState(I) =csUnknown then
            begin
              NodeData.Caption := Copy(DRVParser.Statements[I],1,21)+'...';
              NodeData.ImageIndex := img_statement;
            end
            else
            if S='ROLLBACK' then
            begin
             NodeData.Caption := 'Rollback';
             NodeData.ImageIndex := img_statement;
            end
            else
             NodeData.ImageIndex := img_statement;


          end;
        end; //with Tree

        RestoreExpandedNodes;
      finally
//        EditorForm.Tree.EndUpdate;
        for I := 0 to vRootNodes.Count - 1 do
          TStringList(vRootNodes.Objects[I]).Free;
        vRootNodes.Free;
      end;
    end;
  end;
end;

procedure TParserThreaded.ProgressOn;
var
  vProgressBarMax: Integer;
begin
  if Assigned(EditorForm) then
  begin
    EditorForm.Panel6.Caption := SParsingScript;
    if EditorForm.FRunningFromFile then
    begin
      if Pred(EditorForm.DRVPlayer.InputStringCount) > 0 then
        EditorForm.ProgressBar1.Max := Pred(EditorForm.DRVPlayer.InputStringCount);
    end
    else
    begin
      vProgressBarMax := Pred(EditorForm.Editor.Lines.Count);
      if vProgressBarMax > 0 then
        EditorForm.ProgressBar1.Max := vProgressBarMax;
    end;
    EditorForm.Panel1.Visible := True;
    Application.ProcessMessages;
  end;
end;

procedure TParserThreaded.ProgressOff;
begin
  if Assigned(EditorForm) then
  begin
    EditorForm.Panel1.Visible := False;
    EditorForm.Panel6.Caption := EmptyStr;
  end;
end;

procedure TibSHSQLPlayerForm.Panel1Resize(Sender: TObject);
begin
  ProgressBar1.Width := ProgressBar1.Parent.ClientWidth - 16;
end;

procedure TibSHSQLPlayerForm.BeforeExecuteStmnt(APlayer: IibSHDRVPlayer;
  StmntNo, AScriptLine: Integer);
begin
  if not IsTraceMode then
  begin
    Editor.BeginUpdate;
    Editor.CaretY :=  AScriptLine;
    Editor.TopLine := AScriptLine;
    Editor.EnsureCursorPosVisibleEx(True);
    Editor.BlockBegin := TBufferCoord(Point(1, AScriptLine));
    Editor.BlockEnd := TBufferCoord(Point(1, AScriptLine + 1));
    Editor.EndUpdate;
  end;
  Screen.Cursor := crDefault;
  if not FRunningFromFile then
   ProgressBar1.Position :=AScriptLine
  else
  begin
    if StatusBar.Panels.Count > 4 then
      StatusBar.Panels[4].Text := Format('Statement proceeded: %d, Line: %d ', [StmntNo,AScriptLine]);
  end;
{  if FRunningFromFile then
  begin
    if Pred(DRVPlayer.InputStringCount) > 0 then
      ProgressBar1.Max := Pred(DRVPlayer.InputStringCount);
    ProgressBar1.Position := DRVPlayer.LineProceeding;
    if StatusBar.Panels.Count > 4 then
      StatusBar.Panels[4].Text := Format('Lines proceeded: %d/%d', [DRVPlayer.LineProceeding, DRVPlayer.InputStringCount]);
  end
  else
   ProgressBar1.Position := DRVPlayer.LineProceeding;}
  //  ProgressBar1.Position := ProgressBar1.Position + 1;
  Designer.UpdateActions;
  Application.ProcessMessages;
end;

procedure TibSHSQLPlayerForm.pSHSynEdit1Change(Sender: TObject);
begin
 if Tree.Visible then
 begin
  tmLaunchParsing.Enabled:=False;
  tmLaunchParsing.Enabled:=True;
 end
end;

procedure TParserThreaded.SetNeedReparsing(const Value: boolean);
begin
    FNeedReparsing:=Value;
    if Value then
     FStopFillTree :=True
end;

procedure TibSHSQLPlayerForm.DoOnSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  Data: PScriptNode;
  vTracedLine:integer;
begin
  inherited;
  if IsTraceMode  then
  begin
   Data := Tree.GetNodeData(Tree.FocusedNode);
   if Data<>nil then
   begin
     vTracedLine := Data.StatementPos.Top;
     if (vTracedLine+1= Line) then
     begin
       FG:=clWhite;
       BG:=clNavy;
       Special := True;
     end
   end
  end;
end;

end.


