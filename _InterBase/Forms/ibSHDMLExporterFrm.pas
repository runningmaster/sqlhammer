unit ibSHDMLExporterFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ExtCtrls, ToolWin,
  VirtualTrees, StdCtrls, ActnList, AppEvnts,
  SynEditSearch, SynEdit, SynEditTypes,Math,

  pSHSynEdit, pSHQStrings,

  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm;

const
  WM_STARTEDITING = WM_USER + 778;
  WM_DMLDUMPER_CHECKTREE = WM_USER + 101;

type
  TibSHDMLExporterForm = class(TibBTComponentForm, IibSHDMLExporterForm)
    ImageList1: TImageList;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Tree: TVirtualStringTree;
    Panel4: TPanel;
    pSHSynEdit1: TpSHSynEdit;
    ApplicationEvents1: TApplicationEvents;
    SaveDialog1: TSaveDialog;
    Panel1: TPanel;
    Bevel1: TBevel;
    Image1: TImage;
    Bevel2: TBevel;
    Panel6: TPanel;
    Panel7: TPanel;
    ProgressBar1: TProgressBar;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure Panel1Resize(Sender: TObject);
  private
    { Private declarations }
    FDMLExporterIntf: IibSHDMLExporter;
    FTableList: TStrings;
    FStartTime: TDateTime;
    FFileName: string;
    FFileStream: TFileStream;
    FBlobFileName: string;
    FIsBlobFileTemporary: Boolean;
    FCurrentObjectName: string;
    FCurrentRecNo: Integer;

    FDDLGeneratorComponent: TSHComponent;
    FDDLGeneratorIntf: IibSHDDLGenerator;

    FDBTableComponent: TSHComponent;
    FQueryComponent: TSHComponent;
    FDBTableIntf: IibSHTable;
    FDBQueryIntf: IibSHQuery;

    { Tree }
    procedure TreeAfterCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure TreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
    procedure TreeClick(Sender: TObject);
    procedure TreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure TreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
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
    procedure TreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure TreeIncrementalSearch(Sender: TBaseVirtualTree;
      Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
    procedure TreeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TreeDblClick(Sender: TObject);
    procedure TreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
      Column: TColumnIndex; var Result: Integer);
    procedure TreeExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var Allowed: Boolean);

    procedure CheckTree;
    procedure SetTreeEvents(ATree: TVirtualStringTree);
    procedure BuildTree;
    procedure BuildChildNodes(AParent: PVirtualNode);
    procedure WriteToEditor(AText: string; WithLineBreak: Boolean = True);
    procedure FlashFileStream;
    procedure InsertInEditor(AText: string; Index: Integer; WithLineBreak: Boolean = True);
    procedure RemoveTemporaryBlobFile;

    procedure DisplayScriptHeader;
    procedure DisplayScriptFooter;
    procedure DisplayDialect;
    procedure DisplayNames;
    procedure DisplayConnect;
    procedure DisplayCommitWork(ATableName: string = ''; ARecordCount: Integer = 0);

    function GetNewTempFile: string;

    procedure RegisterSubEditor(AEditor: TpSHSynEdit);
    procedure WMStartEditing(var Message: TMessage); message WM_STARTEDITING;
    procedure WMCheckTree(var Message: TMessage); message WM_DMLDUMPER_CHECKTREE;
    procedure Pending;
  protected
    procedure RegisterEditors; override;

    { ISHFileCommands }
    function GetCanSaveAs: Boolean; override;
    procedure SaveAs; override;

    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanPause: Boolean; override;
    function GetCanRefresh: Boolean; override;

    procedure Run; override;
    procedure Pause; override;
    procedure Refresh; override;
    procedure ShowHideRegion(AVisible: Boolean); override;

    procedure DoOnIdle; override;
    function GetCanDestroy: Boolean; override;
    procedure SetStatusBar(Value: TStatusBar); override;

    { IibSHDMLExporterForm }
    function GetCanMoveDown: Boolean;
    function GetCanMoveUp: Boolean;

    procedure UpdateTree;
    procedure CheckAll;
    procedure UnCheckAll;
    procedure MoveDown;
    procedure MoveUp;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;
    procedure BringToTop; override;
    property DMLExporter: IibSHDMLExporter read FDMLExporterIntf;
    property DDLGenerator: IibSHDDLGenerator read FDDLGeneratorIntf;
    property DBTable: IibSHTable read FDBTableIntf;
    property DBQuery: IibSHQuery read FDBQueryIntf;
    property TableList: TStrings read FTableList;
  end;

var
  ibSHDMLExporterForm: TibSHDMLExporterForm;

implementation

uses
  DB,
  ibSHConsts, ibSHValues, ibSHMessages,
  ibSHDMLExporterTreeEditors,
  pSHSqlTxtRtns, pSHStrUtil, Types;

{$R *.dfm}

{ TibBTDMLExporterForm }

constructor TibSHDMLExporterForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  vComponentClass: TSHComponentClass;
begin
  FTableList := TStringList.Create;
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHDMLExporter, FDMLExporterIntf);
  Assert(DMLExporter <> nil, 'DMLExporter = nil');
  Assert(DMLExporter.BTCLDatabase <> nil, 'DMLExporter.BTCLDatabase = nil');
  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
  FocusedControl := Tree;

  RegisterEditors;
  SetTreeEvents(Tree);
//  BuildTree;
  PostMessage(Self.Handle, WM_DMLDUMPER_CHECKTREE, 0, 0);
  //CheckTree;
  DoOnOptionsChanged;
  Panel6.Caption := EmptyStr;
  Panel1.Visible := False;
  FBlobFileName := EmptyStr;

  vComponentClass := Designer.GetComponent(IibSHDDLGenerator);
  if Assigned(vComponentClass) then
  begin
    FDDLGeneratorComponent := vComponentClass.Create(nil);
    Supports(FDDLGeneratorComponent, IibSHDDLGenerator, FDDLGeneratorIntf);
  end;
  Assert(DDLGenerator <> nil, 'DDLGenerator = nil');

  vComponentClass := Designer.GetComponent(IibSHTable);
  if Assigned(vComponentClass) then
  begin
    FDBTableComponent := vComponentClass.Create(nil);
    FDBTableComponent.OwnerIID := DMLExporter.OwnerIID;
    Supports(FDBTableComponent, IibSHTable, FDBTableIntf);
    Designer.Components.Remove(FDBTableComponent);
  end;
  Assert(DBTable <> nil, 'DBTable = nil');
  DBTable.State := csSource;

  vComponentClass := Designer.GetComponent(IibSHQuery);
  if Assigned(vComponentClass) then
  begin
    FQueryComponent := vComponentClass.Create(nil);
    FQueryComponent.OwnerIID := DMLExporter.OwnerIID;
    Supports(FQueryComponent, IibSHQuery, FDBQueryIntf);
    Designer.Components.Remove(FQueryComponent);
  end;
  Assert(DBQuery <> nil, 'Query = nil');
  DBQuery.State := csSource;

  EditorMsg := pSHSynEdit1;
  ShowHideRegion(False);
end;

destructor TibSHDMLExporterForm.Destroy;
begin
  RemoveTemporaryBlobFile;
  FTableList.Free;
  Designer.Components.Remove(FDDLGeneratorComponent);
  FDBTableIntf := nil;
  FDDLGeneratorIntf := nil;
  FDDLGeneratorComponent.Free;
  FDBTableComponent.Free;
  inherited Destroy;
end;

procedure TibSHDMLExporterForm.BringToTop;
begin
  inherited BringToTop;
  if Assigned(StatusBar) then StatusBar.Top := Self.Height;
end;

procedure TibSHDMLExporterForm.CheckTree;
begin
  if DMLExporter.Mode = EmptyStr then
    if Assigned(DMLExporter.Data) then
      DMLExporter.Mode := DMLExporterModes[1]
    else
      DMLExporter.Mode := DMLExporterModes[0];

  if DMLExporter.Mode = DMLExporterModes[1] then
    Tree.Header.Columns[2].Options := Tree.Header.Columns[2].Options - [coVisible];

  if not DMLExporter.Active then
    if (Tree.RootNodeCount = 0) then
      BuildTree;
end;

procedure TibSHDMLExporterForm.SetTreeEvents(ATree: TVirtualStringTree);
begin
  ATree.OnAfterCellPaint := TreeAfterCellPaint;
  ATree.OnBeforeCellPaint := TreeBeforeCellPaint;
  ATree.OnClick := TreeClick;
  ATree.OnCreateEditor := TreeCreateEditor;
  ATree.OnEditing := TreeEditing;
  ATree.OnExpanding := TreeExpanding;
  ATree.Images := Designer.ImageList;
  ATree.OnGetNodeDataSize := TreeGetNodeDataSize;
  ATree.OnFreeNode := TreeFreeNode;
  ATree.OnGetImageIndex := TreeGetImageIndex;
  ATree.OnGetText := TreeGetText;
  ATree.OnInitNode := TreeInitNode;
  ATree.OnIncrementalSearch := TreeIncrementalSearch;
  ATree.OnDblClick := TreeDblClick;
  ATree.OnKeyDown := TreeKeyDown;
  ATree.OnCompareNodes := TreeCompareNodes;
end;

procedure TibSHDMLExporterForm.BuildTree;
var
  I: Integer;
  vCenterViewNode: PVirtualNode;
  function BuildRootNode(const ATableName: string): PVirtualNode;
  var
    vDummyNode: PVirtualNode;
    NodeData: PTreeRec;
    vQueryTablesList: TStringList;
  begin
    Result := Tree.AddChild(nil);
    Result.CheckType := ctTriStateCheckBox;
    Result.States := Result.States + [vsHasChildren];
    if DMLExporter.Mode = DMLExporterModes[0] then
    begin
      if DMLExporter.TablesForDumping.IndexOf(ATableName) > -1 then
      begin
        Result.CheckState := csCheckedNormal;
        if not Assigned(vCenterViewNode) then
          vCenterViewNode := Result;
      end
      else
        Result.CheckState := csUnCheckedNormal;
    end
    else
      Result.CheckState := csCheckedNormal;
    NodeData := Tree.GetNodeData(Result);
    if DMLExporter.Mode = DMLExporterModes[1] then
    begin
      NodeData.ObjectName := DMLExporterModes[1];
      if Assigned(DMLExporter.Data) then
      begin
        vQueryTablesList := TStringList.Create;
        try
          AllSQLTables(DMLExporter.Data.Dataset.SelectSQL.Text, vQueryTablesList);
          if vQueryTablesList.Count > 0 then
            NodeData.DestinationTable := vQueryTablesList[0];
        finally
          vQueryTablesList.Free;
        end;
      end;
      NodeData.ImageIndex  := Designer.GetImageIndex(IibSHView);
    end
    else
    begin
      NodeData.ObjectName := ATableName;
      NodeData.DestinationTable := ATableName;
      NodeData.ImageIndex  := Designer.GetImageIndex(IibSHTable);
    end;
    NodeData.Description := EmptyStr;
    NodeData.IsDummy := False;
    vDummyNode := Tree.AddChild(Result);
    NodeData := Tree.GetNodeData(vDummyNode);
    NodeData.IsDummy := True;
  end;
begin
  if DMLExporter.Active then Exit;
  Screen.Cursor := crHourGlass;
  DMLExporter.Active := True;
  Tree.Clear;
  Designer.UpdateActions;
  try
    if (DMLExporter.Mode = DMLExporterModes[0]) then
    begin
      if DMLExporter.BTCLDatabase.GetObjectNameList(IibSHTable).Count > 0 then
      begin
        ProgressBar1.Position := 0;
        ProgressBar1.Max := DMLExporter.BTCLDatabase.GetObjectNameList(IibSHTable).Count;
        Panel6.Caption := SLoadingTables;
        Panel1.Visible := True;
        Application.ProcessMessages;

        vCenterViewNode := nil;
        Tree.BeginUpdate;
        Tree.Clear;
        try
          for I := 0 to Pred(DMLExporter.BTCLDatabase.GetObjectNameList(IibSHTable).Count) do
          begin
            BuildRootNode(
              DMLExporter.BTCLDatabase.GetObjectNameList(IibSHTable)[I]);
            ProgressBar1.Position := ProgressBar1.Position + 1;
            Application.ProcessMessages;
            DoOnIdle;
            if not DMLExporter.Active then Break;
          end;
        finally
          Panel6.Caption := EmptyStr;
          Panel1.Visible := False;
          Tree.EndUpdate;
        end
      end;
    end
    else
    begin
      if Assigned(DMLExporter.Data) then
      begin
        vCenterViewNode := BuildRootNode('Query');
        BuildChildNodes(vCenterViewNode);
        Tree.Expanded[vCenterViewNode] := True;
      end;
    end;
    if Assigned(vCenterViewNode) then
    begin
      Tree.ScrollIntoView(vCenterViewNode, True);
      Tree.FocusedNode := vCenterViewNode;
      Tree.Selected[Tree.FocusedNode] := True;
      Tree.Expanded[Tree.FocusedNode] := True;
    end
    else
      if Tree.RootNodeCount > 0 then
      begin
        Tree.FocusedNode := Tree.GetFirst;
        Tree.Selected[Tree.FocusedNode] := True;
      end;
  finally
    Screen.Cursor := crDefault;
    DMLExporter.Active := False;
    Designer.UpdateActions;
  end;
end;

procedure TibSHDMLExporterForm.BuildChildNodes(AParent: PVirtualNode);
var
  Node: PVirtualNode;
  NodeData, ParentData: PTreeRec;
  I: Integer;
  vFieldImageIndex: Integer;

  vPrimaryKeyConstraint: IibSHConstraint;

  vDummyNode: PVirtualNode;
begin
  if not Assigned(DMLExporter) then Exit;

  if (AParent.ChildCount = 1) then
  begin
    vDummyNode := AParent.FirstChild;
    if Assigned(vDummyNode) then
    begin
      NodeData := Tree.GetNodeData(vDummyNode);
      if NodeData.IsDummy then
        Tree.DeleteChildren(AParent)
      else
        Exit;  
    end;
  end
  else
    Exit;  

  vFieldImageIndex := Designer.GetImageIndex(IibSHField);
  ParentData := Tree.GetNodeData(AParent);
  if DMLExporter.Mode = DMLExporterModes[0] then
  begin
    if Assigned(ParentData) then
    begin
      FDBTableComponent.Caption := ParentData.ObjectName;
      DDLGenerator.GetDDLText(DBTable);
      vPrimaryKeyConstraint := nil;
      for I := 0 to Pred(DBTable.Constraints.Count) do
      begin
        if CompareStr(DBTable.GetConstraint(I).ConstraintType, ConstraintTypes[0]) = 0 then
        begin
          vPrimaryKeyConstraint := DBTable.GetConstraint(I);
          Break;
        end;
      end;

      for I := 0 to Pred(DBTable.Fields.Count) do
      begin
        if DBTable.Fields[I] = 'DB_KEY' then Continue;
        Node := Tree.AddChild(AParent);
        Node.CheckType := ctTriStateCheckBox;
        NodeData := Tree.GetNodeData(Node);
        if Assigned(NodeData) then
        begin
          NodeData.ObjectName := DBTable.Fields[I];
          NodeData.Description := DBTable.GetField(I).DataTypeExt;
          if Length(DBTable.GetField(I).ComputedSource.Text) > 0 then
          begin
            NodeData.Description := NodeData.Description  + ' (computed)';
            Node.CheckState := csUncheckedNormal;
          end
          else
            Node.CheckState := AParent.CheckState;
          NodeData.UseAsUpdateField := False;
          if Assigned(vPrimaryKeyConstraint) then
          begin
            NodeData.UseAsUpdateField :=
              vPrimaryKeyConstraint.Fields.IndexOf(DBTable.Fields[I]) > -1;
            if NodeData.UseAsUpdateField and (CompareStr(DMLExporter.StatementType, ExtractorStatementType[1]) = 0)  then
              Node.CheckState := csUncheckedNormal;
          end;
          NodeData.ImageIndex := vFieldImageIndex;
          NodeData.IsDummy := False;
        end;
      end;
    end;
  end
  else
  begin
    if Assigned(ParentData) and Assigned(DMLExporter.Data) then
    begin
      DBQuery.Data := DMLExporter.Data;
      DDLGenerator.GetDDLText(DBQuery);

      for I := 0 to Pred(DBQuery.Fields.Count) do
      begin
        Node := Tree.AddChild(AParent);
        Node.CheckType := ctTriStateCheckBox;
        NodeData := Tree.GetNodeData(Node);
        if Assigned(NodeData) then
        begin
          NodeData.ObjectName := DBQuery.Fields[I];
          NodeData.Description := DBQuery.GetField(I).DataTypeExt;
          Node.CheckState := AParent.CheckState;
          NodeData.UseAsUpdateField := False;
          NodeData.ImageIndex := vFieldImageIndex;
          NodeData.IsDummy := False;
        end;
      end;
    end;
  end;
end;


procedure TibSHDMLExporterForm.WriteToEditor(AText: string; WithLineBreak: Boolean = True);
var
  S: string;
begin

  if DMLExporter.Output = ExtractorOutputs[0] then
  begin
    if Assigned(Editor) then
    begin
      if WithLineBreak then Editor.Lines.Add(EmptyStr);

      if Length(AText) > 0 then
        Designer.TextToStrings(AText, Editor.Lines)
//       ^^^ Блядство
      else
        Editor.Lines.Add(AText);

      Editor.CaretY := Pred(Editor.Lines.Count);
//      Panel6.Caption := Format('%s : %d records exported', [FCurrentObjectName, FCurrentRecNo]);
      if StatusBar.Panels.Count >= 5 then
        StatusBar.Panels[4].Text := Format('%s : %d records exported', [FCurrentObjectName, FCurrentRecNo]);

      Application.ProcessMessages;
    end;
  end
  else
  begin
    S := SLineBreak;
    if not Assigned(FFileStream) then
      FFileStream := TFileStream.Create(FFileName, fmCreate	or fmShareDenyWrite);
    if WithLineBreak then
    begin
      FFileStream.WriteBuffer(S[1], 2);
    end;
    if Length(AText) > 0 then
      FFileStream.WriteBuffer(AText[1], Length(AText));
    FFileStream.WriteBuffer(S[1], 2);
//    Panel6.Caption := Format('%s : %d', [FCurrentObjectName, FCurrentRecNo]);
    if StatusBar.Panels.Count >= 5 then
      StatusBar.Panels[4].Text := Format('%s : %d records exported', [FCurrentObjectName, FCurrentRecNo]);
    Application.ProcessMessages;
  end;

end;

procedure TibSHDMLExporterForm.FlashFileStream;
begin
  if Assigned(DMLExporter) and (DMLExporter.Output = ExtractorOutputs[1]) and Assigned(FFileStream) then
    FreeAndNil(FFileStream);
end;

procedure TibSHDMLExporterForm.InsertInEditor(AText: string; Index: Integer;
  WithLineBreak: Boolean);
begin
  if DMLExporter.Output = ExtractorOutputs[0] then
  begin
    if Assigned(Editor) then
    begin
      if WithLineBreak then Editor.Lines.Insert(Index, EmptyStr);

      if Length(AText) > 0 then
        Editor.Lines.Insert(Index, AText)
      else
        Editor.Lines.Insert(Index, AText);
    end;
  end
  else
    WriteToEditor(AText, WithLineBreak);
end;

procedure TibSHDMLExporterForm.RemoveTemporaryBlobFile;
begin
  if FIsBlobFileTemporary and (Length(FBlobFileName) > 0) and FileExists(FBlobFileName)  then
    DeleteFile(FBlobFileName);
end;

procedure TibSHDMLExporterForm.DisplayScriptHeader;
var
  vText: string;
begin
  FStartTime := Now;
  vText := Format('/* BT: DML Exporter started at %s                          */', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', FStartTime)]);
  WriteToEditor(vText, False);
  WriteToEditor(EmptyStr, False);
end;

procedure TibSHDMLExporterForm.DisplayScriptFooter;
var
  vText: string;
begin
  vText := Format('/* BT: DML Exporter ended at %s                            */',
              [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', Now)]
           );
  WriteToEditor(vText);
  vText := Format('/* BT: Elapsed time %s                                              */',
            [FormatDateTime('hh:nn:ss.zzz', Now - FStartTime)]
           );
  WriteToEditor(vText, False);
  WriteToEditor(EmptyStr);
end;

procedure TibSHDMLExporterForm.DisplayDialect;
var
  vText: string;
begin
  if Assigned(DMLExporter.BTCLDatabase) then
  begin
    Assert(DMLExporter.BTCLDatabase.DRVDatabase <> nil, 'DMLExporter.BTCLDatabase.DRVDatabase = nil');
    vText := Format('SET SQL DIALECT %d;', [DMLExporter.BTCLDatabase.DRVDatabase.SQLDialect]);
    WriteToEditor(vText);
  end;
end;

procedure TibSHDMLExporterForm.DisplayNames;
var
  vText: string;
begin
  if Assigned(DMLExporter.BTCLDatabase) then
  begin
    Assert(DMLExporter.BTCLDatabase.DRVDatabase <> nil, 'DMLExporter.BTCLDatabase.DRVDatabase = nil');
    vText := Format('SET NAMES %s;', [DMLExporter.BTCLDatabase.DRVDatabase.Charset]);
    WriteToEditor(vText);
  end;
end;

procedure TibSHDMLExporterForm.DisplayConnect;
var
  vText: string;
  ConnectPath, UserName, UserPassword: string;
begin
  if Assigned(DMLExporter.BTCLDatabase) then
  begin
    ConnectPath := DMLExporter.BTCLDatabase.ConnectPath;
    UserName := DMLExporter.BTCLDatabase.UserName;
    if DMLExporter.Password then UserPassword := DMLExporter.BTCLDatabase.Password else UserPassword := 'Enter your password here';
    vText := Format('CONNECT ''%s'' USER ''%s'' PASSWORD ''%s'';', [ConnectPath, UserName, UserPassword]);
    WriteToEditor(vText);
    WriteToEditor(EmptyStr, False);
  end;
end;

procedure TibSHDMLExporterForm.DisplayCommitWork(ATableName: string = ''; ARecordCount: Integer = 0);
begin
  if ARecordCount = 0 then
    WriteToEditor('COMMIT WORK;')
  else
    WriteToEditor(Format('COMMIT WORK; /* %s: %s records */', [ATableName, FormatFloat('###,###,###,###', ARecordCount)]));
  WriteToEditor(EmptyStr, False);
end;

function TibSHDMLExporterForm.GetNewTempFile: string;
var
  TempSysDir: PChar;
  NewTempFile: PChar;
begin
  TempSysDir := StrAlloc(MAX_PATH + 1);
  NewTempFile := StrAlloc(MAX_PATH + 1);
  GetTempPath(MAX_PATH, TempSysDir);
  GetTempFilename(TempSysDir, PChar('sh_'), 0, NewTempFile);
  SetString(Result, NewTempFile, StrLen(NewTempFile));
  StrDispose(TempSysDir);
  StrDispose(NewTempFile);
end;

procedure TibSHDMLExporterForm.RegisterSubEditor(AEditor: TpSHSynEdit);
var
  vEditorRegistrator: IibSHEditorRegistrator;
begin
  if Supports(Designer.GetDemon(IibSHEditorRegistrator), IibSHEditorRegistrator, vEditorRegistrator) then
    vEditorRegistrator.RegisterEditor(AEditor, DMLExporter.BTCLDatabase.BTCLServer, DMLExporter.BTCLDatabase);
end;

procedure TibSHDMLExporterForm.WMStartEditing(var Message: TMessage);
var
  Node: PVirtualNode;
begin
  Node := Pointer(Message.WParam);
  Tree.EditNode(Node, Message.LParam);
end;

procedure TibSHDMLExporterForm.WMCheckTree(var Message: TMessage);
begin
  CheckTree;
end;

procedure TibSHDMLExporterForm.Pending;
var
  vDMLExporterFactory: IibSHDMLExporterFactory;
begin
  if Supports(Designer.GetDemon(IibSHDMLExporterFactory), IibSHDMLExporterFactory, vDMLExporterFactory) then
    vDMLExporterFactory.SuspendedDestroyComponent(Component);
end;

procedure TibSHDMLExporterForm.RegisterEditors;
var
  vEditorRegistrator: IibSHEditorRegistrator;
begin
  if Supports(Designer.GetDemon(IibSHEditorRegistrator), IibSHEditorRegistrator, vEditorRegistrator) then
    vEditorRegistrator.RegisterEditor(Editor, DMLExporter.BTCLDatabase.BTCLServer, DMLExporter.BTCLDatabase);
end;

function TibSHDMLExporterForm.GetCanSaveAs: Boolean;
begin
  Result := not DMLExporter.Active and Panel4.Visible;
end;

procedure TibSHDMLExporterForm.SaveAs;
var
  vSavedPath: string;
  vSavedName: string;
  vSavedExt: string;
  vNewBLOBFileName: string;
  pSavedName: PChar;
  pNewBLOBFileName: PChar;
begin
  inherited SaveAs;
  if (Length(CurrentFile) > 0) and (Length(FBlobFileName) > 0) then
  begin
    vSavedPath := ExtractFilePath(CurrentFile);
    vSavedName := ExtractFileName(CurrentFile);
    vSavedExt := ExtractFileExt(CurrentFile);
    Delete(vSavedName, Length(vSavedName) - Length(vSavedExt) + 1, Length(vSavedExt));
    vNewBLOBFileName := vSavedPath + vSavedName + '.blob';
    pNewBLOBFileName := StrAlloc(Length(vNewBLOBFileName) + 1);
    pNewBLOBFileName := StrPCopy(pNewBLOBFileName, vNewBLOBFileName);

    pSavedName := StrAlloc(Length(FBlobFileName) + 1);
    pSavedName := StrPCopy(pSavedName, FBlobFileName);
    try
      MoveFile(pSavedName, pNewBLOBFileName);
    finally
      StrDispose(pNewBLOBFileName);
      StrDispose(pSavedName);
    end;

    if Assigned(Editor.SearchEngine) and
      (Editor.SearchEngine.ClassName <> TSynEditSearch.ClassName) then
    begin
      Editor.SearchEngine.Free;
      Editor.SearchEngine := nil;
    end;
    if not Assigned(Editor.SearchEngine) then
      Editor.SearchEngine := TSynEditSearch.Create(Editor);
    Editor.SearchReplace('SET BLOBFILE ''' + FBlobFileName + ''';', 'SET BLOBFILE ''' + vNewBLOBFileName + ''';', [ssoEntireScope, ssoReplaceAll]);
    Editor.SearchReplace(SExtractorTmpBLOBFileUserNotification, '', [ssoEntireScope, ssoReplaceAll]);
    FBlobFileName := vNewBLOBFileName;
    Save;
    FIsBlobFileTemporary := False;
    CurrentFile := EmptyStr;
  end;
end;

function TibSHDMLExporterForm.GetCanRun: Boolean;
begin
  Result := not DMLExporter.Active;
end;

function TibSHDMLExporterForm.GetCanPause: Boolean;
begin
  Result := DMLExporter.Active;
end;

function TibSHDMLExporterForm.GetCanRefresh: Boolean;
begin
//  Result := Tree.CanFocus and Assigned(DMLExporter) and ((DMLExporter.Mode = DMLExporterModes[0]) or (DMLExporter.Mode = DMLExporterModes[1])) ;
  Result := Assigned(DMLExporter) and not DMLExporter.Active;
end;

procedure TibSHDMLExporterForm.Run;
const
  EnShortMonthNames: array[1..12] of string = ('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC');
var
  Node: PVirtualNode;
//  NodeData: PTreeRec;
//  Data: IibSHData;
  vDecimalSeparator: Char;
  vFormatSettings: TFormatSettings;

  vBlobFile: TFileStream;
  vCodeNormalizer: IibSHCodeNormalizer;

  vBlobFileCreated: Boolean;
  vExistBlobFields:boolean;  
  vSavedPath: string;
  vSavedName: string;
  vSavedExt: string;

  function PrepareString(Value: string): string;
  const
    NonPrintChars = [#1..#31];
  begin
    Result := Q_ReplaceStr(Value, #39, #39#39);
    if DMLExporter.NonPrintChar2Space then
      Q_ReplaceCharsByOneChar(Result, NonPrintChars, #32);
  end;
  function NormalizeName(Value: string): string;
  begin
    if Assigned(vCodeNormalizer) then
      Result := vCodeNormalizer.MetadataNameToSourceDDL(DMLExporter.BTCLDatabase, Value)
    else
      Result := Value;
  end;
  function NormalizeNameCase(Value: string): string;
  begin
    if Assigned(vCodeNormalizer) then
      Result := vCodeNormalizer.MetadataNameToSourceDDLCase(
        DMLExporter.BTCLDatabase, vCodeNormalizer.InputValueToMetadata(DMLExporter.BTCLDatabase, Value))
    else
      Result := Value;
  end;
//  procedure ScriptOut(AData: IibSHData; FieldList: TStrings; ATableName: string; AWhereClause: string);
  procedure ScriptOut(AData: IibSHData; ANode: PVirtualNode; AllFields: Boolean = True);
  type
   TExecState=(esNoInBlock,esInBlock);
  var
    vCommitCounter: Integer;
    vFieldsCommaText: string;
    vTableName: string;
    vDestinationTableName: string;
    vWhereClause: string;
    vSQLText: string;
    Node: PVirtualNode;
    NodeData: PTreeRec;
    vCurrentField: TField;
    I: Integer;
    vMainClause: string;
    vDestinationWhereClause: string;
    vValuesClause: string;
    vIsUpdateMode: Boolean;
    vFieldList: TStringList;
    vFieldNormalizedList: TStringList;
    vFieldExtractList: TStringList;
    vUpdateFieldList: TStringList;

    vSourceBlob: TStream;
    len, lo: Integer;
//    S: string;
    vDataComponentClass: TSHComponentClass;
    vDataComponent: TSHComponent;
    vData: IibSHData;

    vTimeANSIPrefix, vDateANSIPrefix, vDateTimeANSIPrefix: string;

    vPending: Boolean;
    vBLOBNitificationStringIndex: Integer;
    vFloatValue: double;
    // For ExecuteBlock
    vContextCount:integer;
    vBytesInExecBlock:Integer;
    vExecState:TExecState;
    CurStr:string;

    procedure MakeValueStr(const AFieldName, AFieldNormalizedName, Value: string;  AIsNull: Boolean);
    begin
      if vIsUpdateMode then
      begin
        if vFieldExtractList.IndexOf(AFieldName) > -1 then
        begin
          if AIsNull then
            vValuesClause := vValuesClause + Format('  %s = NULL,'#13#10, [AFieldNormalizedName])
          else
            vValuesClause := vValuesClause + Format('  %s = %s,'#13#10, [AFieldNormalizedName, Value]);
        end;
        if vUpdateFieldList.IndexOf(AFieldName) > -1 then
        begin
          if AIsNull then
            vDestinationWhereClause := vDestinationWhereClause +
              Format(#13#10'  %s IS NULL AND', [AFieldNormalizedName])
          else
            vDestinationWhereClause := vDestinationWhereClause +
              Format(#13#10'  %s = %s AND', [AFieldNormalizedName, Value]);
        end;
      end
      else
      begin
        if AIsNull then
          vValuesClause := vValuesClause + 'NULL, '
        else
          vValuesClause := vValuesClause + Value + ', ';
      end;
    end;

    procedure WriteBeginBlock;
    begin
     if DMLExporter.UseExecuteBlock and not vExistBlobFields    then
     if (vContextCount=0) and (vExecState=esNoInBlock) then
     begin
      WriteToEditor('SET TERM ^ ;');
      WriteToEditor('EXECUTE BLOCK',False);
      WriteToEditor('AS',False);
      WriteToEditor('BEGIN');
      vBytesInExecBlock:=12+13+2+5+4*2;
      vExecState:=esInBlock
     end;
    end;

    procedure WriteEndBlock;
    begin
     if DMLExporter.UseExecuteBlock and not vExistBlobFields
     and  (vExecState=esInBlock) then
     begin
      WriteToEditor('END ^',False);
      WriteToEditor('SET TERM ; ^');
      vBytesInExecBlock:=0;
      vContextCount:=0;
      vExecState:=esNoInBlock
     end;
    end;

    procedure CheckStrForBlock(const CurStr:string);
    begin
      if DMLExporter.UseExecuteBlock and not vExistBlobFields then
      begin
        if (vContextCount=255) or vData.Dataset.Dataset.Eof
          or   ((vBytesInExecBlock+Length(CurStr))>65450) //65536 - ограничение длины сиквела
        then
        begin
          WriteEndBlock;
          if not vData.Dataset.Dataset.Eof then
           WriteBeginBlock;
        end;
        if Length(CurStr)>0 then
        begin
         Inc(vContextCount);
         Inc(vBytesInExecBlock,Length(CurStr)+2); //+2 - переход строки
        end
      end;
    end;


  begin
    vExecState:=esNoInBlock;
    vExistBlobFields:=False;
    vPending := False;
    if Assigned(AData) then
      vData := AData
    else
    begin
      vDataComponentClass := Designer.GetComponent(IibSHData);
      if Assigned(vDataComponentClass) then
      begin
        vDataComponent := vDataComponentClass.Create(Component);
        Supports(vDataComponent, IibSHData, vData);
      end;
    end;
    vDataComponent := nil;
    if DMLExporter.UseDateTimeANSIPrefix then
    begin
      vTimeANSIPrefix := 'time ';
      vDateANSIPrefix := 'date ';
      vDateTimeANSIPrefix := 'timestamp ';
    end
    else
    begin
      vTimeANSIPrefix := EmptyStr;
      vDateANSIPrefix := EmptyStr;
      vDateTimeANSIPrefix := EmptyStr;
    end;
    vFieldList := TStringList.Create;
    vUpdateFieldList := TStringList.Create;
    vFieldExtractList := TStringList.Create;
    vFieldNormalizedList := TStringList.Create;
    StatusBar.Visible := True;
    try
      if Assigned(vData) then
      begin
        vCommitCounter := 0;
        NodeData := Tree.GetNodeData(ANode);
        vTableName := NodeData.ObjectName;
        FCurrentObjectName := vTableName;
        FCurrentRecNo := 0;
        vDestinationTableName := NodeData.DestinationTable;
        vWhereClause := NodeData.WhereClause;
        if ANode.ChildCount = 1 then
          BuildChildNodes(ANode);
        Node := ANode.FirstChild;
        if SameText(DMLExporter.StatementType, ExtractorStatementType[1]) or
          SameText(DMLExporter.StatementType, ExtractorStatementType[2]) then
        begin
          while Assigned(Node) and (Node.Parent = ANode) do
          begin
            NodeData := Tree.GetNodeData(Node);
            if (Node.CheckState = csCheckedNormal) or NodeData.UseAsUpdateField then
            begin
              vFieldNormalizedList.Add(NormalizeName(NodeData.ObjectName));
              vFieldList.Add(NodeData.ObjectName);
            end;
            if (Node.CheckState = csCheckedNormal) then
              vFieldExtractList.Add(NodeData.ObjectName);
            if NodeData.UseAsUpdateField then
              vUpdateFieldList.Add(NodeData.ObjectName);
            Node := Node.NextSibling;
          end;
        end
        else
        begin
          while Assigned(Node) and (Node.Parent = ANode) do
          begin
            NodeData := Tree.GetNodeData(Node);
            if Node.CheckState = csCheckedNormal then
            begin
              vFieldNormalizedList.Add(NormalizeName(NodeData.ObjectName));
              vFieldList.Add(NodeData.ObjectName);
            end;
            Node := Node.NextSibling;
          end;
        end;
        vFieldsCommaText := EmptyStr;
        for I := 0 to Pred(vFieldNormalizedList.Count) do
          vFieldsCommaText := vFieldsCommaText + vFieldNormalizedList[I] + ', ';
        SetLength(vFieldsCommaText,Length(vFieldsCommaText) - 2);
//        Delete(vFieldsCommaText, Length(vFieldsCommaText) - 1, 2);
        if Assigned(AData) and (not (AData.Dataset.Active)) then
        begin
          // Датасет для экспорта закрылся
          Pending;
          SysUtils.Abort;
        end;
        if not vData.Dataset.Active then
        begin
          if not AllFields then
            vSQLText := Format('SELECT %s FROM %s', [vFieldsCommaText, NormalizeName(vTableName)])
          else
            vSQLText := Format('SELECT * FROM %s', [NormalizeName(vTableName)]);;
          if Length(vWhereClause) > 0 then
          begin
            vWhereClause := TrimLeft(vWhereClause);
            if PosExtCI('WHERE', vWhereClause, CharsBeforeClause, CharsAfterClause) = 1 then
              Delete(vWhereClause, 1, 5);
            vSQLText := AddToWhereClause(vSQLText, vWhereClause);
          end;
          vData.Dataset.CrearAllSQLs;
          vData.Dataset.SelectSQL.Text := vSQLText;
          vMainClause := EmptyStr;
          vData.Transaction.StartTransaction;
          if Supports(vData.Dataset,IBTDynamicMethod) then
            (vData.Dataset as IBTDynamicMethod).DynMethodExec('SETUNIDIRECTIONAL',[True]);
          vData.Dataset.Open;
          if Length(vData.Dataset.ErrorText) > 0 then
          begin
            Designer.ShowMsg(vData.Dataset.ErrorText, mtError);
            Abort;
          end;
        end;
        vData.Dataset.Dataset.DisableControls;
        try
          vData.Dataset.Dataset.First;
          if CompareStr(DMLExporter.StatementType, ExtractorStatementType[0]) = 0 then
          begin
            vMainClause := Format('INSERT INTO %s (%s)', [NormalizeNameCase(vDestinationTableName), vFieldsCommaText]);
            vIsUpdateMode := False;
          end
          else
          if CompareStr(DMLExporter.StatementType, ExtractorStatementType[1]) = 0 then
          begin
            vMainClause := Format('UPDATE %s SET'#13#10, [NormalizeNameCase(vDestinationTableName)]);
            vIsUpdateMode := True;
          end
          else
          if CompareStr(DMLExporter.StatementType, ExtractorStatementType[2]) = 0 then
          begin
            vMainClause := Format('DELETE FROM %s', [NormalizeNameCase(vDestinationTableName)]);
            vIsUpdateMode := True;
          end
          else
          if CompareStr(DMLExporter.StatementType, ExtractorStatementType[3]) = 0 then
          begin
            vMainClause := Format('EXECUTE PROCEDURE %s', [NormalizeNameCase(vDestinationTableName)]);
            vIsUpdateMode := False;
          end;

          vBytesInExecBlock:=0;
          vContextCount:=0;


          while (not vData.Dataset.Dataset.Eof) and DMLExporter.Active do
          begin

            vValuesClause := EmptyStr;
            vDestinationWhereClause := 'WHERE';
            for I := 0 to Pred(vFieldList.Count) do
            begin
              vCurrentField := vData.Dataset.Dataset.FieldByName(vFieldList[I]);
              case vCurrentField.DataType of
                ftMemo, ftFmtMemo, ftBlob, ftGraphic, ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor:
                  begin
                    vExistBlobFields:=True;
                    if not vBlobFileCreated {Length(FBlobFileName) = 0} then
                    begin
                      vBLOBNitificationStringIndex := 1;
                      if Length(FBlobFileName) = 0 then
                      begin
                        FBlobFileName := GetNewTempFile;
                        InsertInEditor(Format(SExtractorTmpBLOBFileUserNotification, []), vBLOBNitificationStringIndex);
                        Inc(vBLOBNitificationStringIndex);
                      end;
                      if FileExists(FBlobFileName) then DeleteFile(FBlobFileName);
                      vBlobFile := TFileStream.Create(FBlobFileName, fmCreate	or fmShareDenyWrite);
                      vBlobFileCreated := True;
                      //S := 'BT 01';
                      //vBlobFile.WriteBuffer(S[1], 5);
                      InsertInEditor(Format('SET BLOBFILE ''%s'';', [FBlobFileName]), vBLOBNitificationStringIndex);
                    end;
//                    lo := vBlobFile.Position + 1; //запас для отрицательного смещения
                    lo := vBlobFile.Position; //запас для отрицательного смещения
                    if vCurrentField.IsNull then
                    begin
//                      len := 0;
//                      S := '1';
//                      vBlobFile.WriteBuffer(S[1], 1);
                      MakeValueStr(vFieldList[I], vFieldNormalizedList[I], EmptyStr, True);
                    end
                    else
                    begin
                      //S := '0';
                      //vBlobFile.WriteBuffer(S[1], 1);
                      vSourceBlob := vData.Dataset.Dataset.CreateBlobStream(vCurrentField, bmRead);
                      len := vSourceBlob.Size;
                      try
                        vBlobFile.CopyFrom(vSourceBlob, 0);
                      finally
                        vSourceBlob.Free;
                      end;
                      MakeValueStr(vFieldList[I], vFieldNormalizedList[I], ':h' + IntToHex(lo, 8) + '_' + IntToHex(Len, 8), False)
                    end;
                  end;

                ftDate:
                  MakeValueStr(vFieldList[I], vFieldNormalizedList[I],
                    Format('%s''%s''', [vDateANSIPrefix, FormatDateTime(DMLExporter.DateFormat, vCurrentField.AsDateTime, vFormatSettings)]),
                    vCurrentField.IsNull);
                ftTime:
                  MakeValueStr(vFieldList[I], vFieldNormalizedList[I],
                    Format('%s''%s''', [vTimeANSIPrefix, FormatDateTime(DMLExporter.TimeFormat, vCurrentField.AsDateTime, vFormatSettings)]),
                    vCurrentField.IsNull);
                ftDateTime, ftTimeStamp:
                  MakeValueStr(vFieldList[I], vFieldNormalizedList[I],
                    Format('%s''%s''', [vDateTimeANSIPrefix, FormatDateTime(DMLExporter.DateFormat + ' ' + DMLExporter.TimeFormat, vCurrentField.AsDateTime, vFormatSettings)]),
                    vCurrentField.IsNull);
                ftString, ftWideString:
                  MakeValueStr(vFieldList[I], vFieldNormalizedList[I],
                    Format('''%s''', [PrepareString(vCurrentField.AsString)]),
                    vCurrentField.IsNull);
                ftFloat:
                begin
                  vFloatValue:=RoundTo(vCurrentField.AsFloat,-15);
                  // Иначе может бить какие нибудь E-3333
                  MakeValueStr(vFieldList[I], vFieldNormalizedList[I],
                    FloatToStr(vFloatValue),
                    vCurrentField.IsNull);
                end;
                ftUnknown,  ftSmallint, ftInteger, ftWord,
                ftBoolean,  ftCurrency, ftBCD,
                ftBytes, ftVarBytes, ftAutoInc,
                ftFixedChar,    ftLargeint,
                ftVariant, ftGuid, ftFMTBcd:
                  MakeValueStr(vFieldList[I], vFieldNormalizedList[I],
                    vCurrentField.AsString,
                    vCurrentField.IsNull);
                ftADT, ftArray, ftReference, ftDataSet, ftOraBlob, ftOraClob, ftInterface, ftIDispatch:
                  Exception.Create('Not supported');
    //                vValuesClause := vValuesClause + ''', '; //NotSupported
              end;
            end;
            Inc(FCurrentRecNo);
            WriteBeginBlock;

            if CompareStr(DMLExporter.StatementType, ExtractorStatementType[0]) = 0 then
            begin
              Delete(vValuesClause, Length(vValuesClause) - 1, 2);
              CurStr:=Format('%s VALUES(%s);', [vMainClause, vValuesClause]);
              CheckStrForBlock(CurStr);
              WriteToEditor(CurStr, False);
            end
            else
            if CompareStr(DMLExporter.StatementType, ExtractorStatementType[1]) = 0 then
            begin
              Delete(vValuesClause, Length(vValuesClause) - 2, 3);
              if vDestinationWhereClause <> 'WHERE ' then
                Delete(vDestinationWhereClause, Length(vDestinationWhereClause) - 3, 4);
              CurStr:=Format('%s%s'#13#10'%s;'#13#10#13#10, [vMainClause, vValuesClause, vDestinationWhereClause]);
              WriteToEditor(CurStr, False);
            end
            else
            if CompareStr(DMLExporter.StatementType, ExtractorStatementType[2]) = 0 then
            begin
              Delete(vValuesClause, Length(vValuesClause) - 2, 3);
              if vDestinationWhereClause <> 'WHERE ' then
                Delete(vDestinationWhereClause, Length(vDestinationWhereClause) - 3, 4);
              CurStr:=Format('%s'#13#10'%s;'#13#10#13#10, [vMainClause, vDestinationWhereClause]);
              CheckStrForBlock(CurStr);
              WriteToEditor(CurStr , False);
            end
            else
            if CompareStr(DMLExporter.StatementType, ExtractorStatementType[3]) = 0 then
            begin
              Delete(vValuesClause, Length(vValuesClause) - 1, 2);
              CurStr:=Format('%s(%s);', [vMainClause, vValuesClause]);
              CheckStrForBlock(CurStr);
              WriteToEditor(CurStr, False);
            end;
            vPending := not Assigned(DMLExporter) or ((not DMLExporter.Active) and Assigned(AData) and (not Assigned(DMLExporter.Data)));
            if vPending then Break;
            Inc(vCommitCounter);
            vData.Dataset.Dataset.Next;
            if vCommitCounter = DMLExporter.CommitAfter then
            begin
              WriteEndBlock;
              DisplayCommitWork(vDestinationTableName, FCurrentRecNo);
              vCommitCounter := 0;
            end
            else
             CheckStrForBlock(''); // Проверка на Eof?
          end;
          if DMLExporter.CommitEachTable then
          begin
            DisplayCommitWork(vDestinationTableName, FCurrentRecNo);
          end;
          if not vPending then
            if not Assigned(AData) then
            begin
              vData.Close;
              vData.Rollback;
            end;
        finally
          if not vPending then
            vData.Dataset.Dataset.EnableControls;
        end;
      end;

    finally
      vExistBlobFields:=False;
      vFieldList.Free;
      vFieldNormalizedList.Free;
      vUpdateFieldList.Free;
      vFieldExtractList.Free;
      if Supports(vData.Dataset,IBTDynamicMethod) then
         (vData.Dataset as IBTDynamicMethod).DynMethodExec('SETUNIDIRECTIONAL',[False]);

      vData := nil;
      if Assigned(vDataComponent) then
        vDataComponent.Free;
    end;
  end;
  procedure FillFormatSettinges;
  var
    I: Integer;
  begin
    with vFormatSettings do
    begin
      CurrencyFormat := SysUtils.CurrencyFormat;
      NegCurrFormat := SysUtils.NegCurrFormat;
      ThousandSeparator := SysUtils.ThousandSeparator;
      DecimalSeparator := '.';
      CurrencyDecimals := SysUtils.CurrencyDecimals;
      DateSeparator := '-';
      TimeSeparator := ':';
      ListSeparator := '.';
      CurrencyString := SysUtils.CurrencyString;
      ShortDateFormat := DMLExporter.DateFormat;
      LongDateFormat := DMLExporter.DateFormat;
      TimeAMString := 'AM';
      TimePMString := 'PM';
      ShortTimeFormat := DMLExporter.TimeFormat;
      LongTimeFormat := DMLExporter.TimeFormat;
      for I := 1 to 12 do
        ShortMonthNames[I] := EnShortMonthNames[I];
      for I := 1 to 12 do
        LongMonthNames[I] := EnShortMonthNames[I];
      TwoDigitYearCenturyWindow := SysUtils.TwoDigitYearCenturyWindow;
    end;
  end;
begin
  if StatusBar.Panels.Count >= 5 then
  begin
    StatusBar.Panels[4].Text := EmptyStr;
    StatusBar.Panels[3].Text := 'Processing'
  end;
  if tsEditing in Tree.TreeStates then
    Tree.EndEditNode;
  RemoveTemporaryBlobFile;
  FCurrentObjectName := EmptyStr;
  vBlobFileCreated := False;
  if DMLExporter.Output = ExtractorOutputs[0] then
  begin
    ShowHideRegion(True);
    Editor.Lines.Clear;
    FFileName := EmptyStr;
    FBlobFileName := EmptyStr;
  end
  else
  begin
    ShowHideRegion(False);
    SaveDialog1.InitialDir := DoOnGetInitialDir;
    if SaveDialog1.Execute then
    begin
      FFileName := SaveDialog1.FileName;
      vSavedPath := ExtractFilePath(FFileName);
      vSavedName := ExtractFileName(FFileName);
      vSavedExt := ExtractFileExt(FFileName);
      Delete(vSavedName, Length(vSavedName) - Length(vSavedExt) + 1, Length(vSavedExt));
      FBlobFileName := vSavedPath + vSavedName + '.blob';
    end
    else
      Exit;
  end;
  DMLExporter.Active := True;
  Designer.UpdateActions;
  DoOnIdle;
  Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer);
  DisplayScriptHeader;
  if DMLExporter.Header then
  begin
    DisplayDialect;
    DisplayNames;
    DisplayConnect;
  end;
  vDecimalSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  FillFormatSettinges;
  vBlobFile := nil;
  try
    Node := Tree.GetFirst;
    while Assigned(Node) and DMLExporter.Active do
    begin
      if Node.CheckState <> csUncheckedNormal then
        ScriptOut(DMLExporter.Data, Node, Node.CheckState = csCheckedNormal);
      Node := Node.NextSibling;
      if not Assigned(DMLExporter) then Break;
    end;
    if Assigned(DMLExporter) then
    begin
      if not DMLExporter.CommitEachTable then
        DisplayCommitWork;
      if not DMLExporter.Active then
      begin
        Editor.Lines.Add(EmptyStr);
        Editor.Lines.Add(Format('/* BT: DML Exporter stopped by user at %s                  */', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', Now)]));
      end else
        DisplayScriptFooter;
    end;
  finally
    if Assigned(DMLExporter) then
    begin
      DMLExporter.Active := False;
      if DMLExporter.Output = ExtractorOutputs[0] then
        FIsBlobFileTemporary := True
      else
        FIsBlobFileTemporary := False;
    end;
    DecimalSeparator := vDecimalSeparator;
    if Assigned(vBlobFile) then vBlobFile.Free;
    FlashFileStream;
    Panel6.Caption := EmptyStr;
    Designer.UpdateActions;
    if StatusBar.Panels.Count >= 5 then
    begin
      StatusBar.Panels[4].Text := EmptyStr;
      StatusBar.Panels[3].Text := EmptyStr;
    end
  end;
end;

procedure TibSHDMLExporterForm.Pause;
begin
  DMLExporter.Active := False;
  Panel6.Caption := EmptyStr;
end;

procedure TibSHDMLExporterForm.Refresh;
begin
  BuildTree;
end;

procedure TibSHDMLExporterForm.ShowHideRegion(AVisible: Boolean);
begin
  Panel4.Visible := AVisible;
  Splitter1.Visible := AVisible;
  if Assigned(StatusBar) then StatusBar.Visible := AVisible;
  if AVisible then Splitter1.Left := Panel1.Left + Panel1.Width + 1;
end;


procedure TibSHDMLExporterForm.DoOnIdle;
begin
  if Assigned(DMLExporter) and Assigned(DMLExporter.Data) and (not (DMLExporter.Data.Dataset.Active)) then
  begin
    // Датасет для экспорта закрылся
    Pending;
  end;
end;

function TibSHDMLExporterForm.GetCanDestroy: Boolean;
begin
  Result := inherited GetCanDestroy;
  if Assigned(DMLExporter) then
  begin
    if DMLExporter.BTCLDatabase.WasLostConnect then Exit;
    if DMLExporter.Active then Designer.ShowMsg(Format('Dumping process is running...', []), mtInformation);
    Result := Assigned(DMLExporter) and not DMLExporter.Active;
  end;
end;

procedure TibSHDMLExporterForm.SetStatusBar(Value: TStatusBar);
begin
  inherited SetStatusBar(Value);
  ShowHideRegion(False);
end;

function TibSHDMLExporterForm.GetCanMoveDown: Boolean;
begin
  Result := Assigned(Tree.FocusedNode) and
            (Tree.FocusedNode <> Tree.GetLast) and
            Assigned(Tree.GetNextSibling(Tree.FocusedNode));
end;

function TibSHDMLExporterForm.GetCanMoveUp: Boolean;
begin
  Result := Assigned(Tree.FocusedNode) and
            (Tree.FocusedNode <> Tree.GetFirst) and
            Assigned(Tree.GetPreviousSibling(Tree.FocusedNode));
end;

procedure TibSHDMLExporterForm.UpdateTree;
begin
  if SameText(DMLExporter.StatementType, ExtractorStatementType[1]) or
    SameText(DMLExporter.StatementType, ExtractorStatementType[2]) then
  begin
    if (Tree.Header.Columns[2].Options * [coVisible] = []) then
      Tree.Header.Columns[2].Options := Tree.Header.Columns[2].Options + [coVisible];
  end
  else
  begin
    if (Tree.Header.Columns[2].Options * [coVisible] = [coVisible]) then
      Tree.Header.Columns[2].Options := Tree.Header.Columns[2].Options - [coVisible];
  end;
end;

procedure TibSHDMLExporterForm.CheckAll;
var
  Node: PVirtualNode;
begin
  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    Node.CheckState := csCheckedNormal;
    Node := Tree.GetNextSibling(Node);
  end;
  Tree.Invalidate;
end;

procedure TibSHDMLExporterForm.UnCheckAll;
var
  Node: PVirtualNode;
begin
  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    Node.CheckState := csUnCheckedNormal;
    Node := Tree.GetNextSibling(Node);
  end;
  Tree.Invalidate;
end;

procedure TibSHDMLExporterForm.MoveDown;
begin
  if GetCanMoveDown then
    Tree.MoveTo(Tree.FocusedNode, Tree.GetNextSibling(Tree.FocusedNode), amInsertAfter, False);
end;

procedure TibSHDMLExporterForm.MoveUp;
begin
  if GetCanMoveUp then
    Tree.MoveTo(Tree.FocusedNode, Tree.GetPreviousSibling(Tree.FocusedNode), amInsertBefore, False);
end;

procedure TibSHDMLExporterForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  DoOnIdle;
end;

procedure TibSHDMLExporterForm.Panel1Resize(Sender: TObject);
begin
  ProgressBar1.Width := ProgressBar1.Parent.ClientWidth - 16;
end;

{ Tree }

procedure TibSHDMLExporterForm.TreeAfterCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var
  NewRect: TRect;
  NodeData: PTreeRec;
begin
  if (Column = 2) and (Tree.GetNodeLevel(Node) = 1) then
  begin
    NewRect := CellRect;
    NewRect.Left := CellRect.Left + ((CellRect.Right - CellRect.Left) div 2) - 5;
    NewRect.Top := CellRect.Top + ((CellRect.Bottom - CellRect.Top) div 2) - 8;
    NodeData := Tree.GetNodeData(Node);
    if Assigned(NodeData) then
    begin
      if NodeData.UseAsUpdateField then
        ImageList1.Draw(TargetCanvas, NewRect.Left, NewRect.Top, 4)
      else
        ImageList1.Draw(TargetCanvas, NewRect.Left, NewRect.Top, 3);
    end;

  end;
end;

procedure TibSHDMLExporterForm.TreeBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
//var
//  Data: PTreeRec;
begin
  if (Column in [3,4]) and (Sender.GetNodeLevel(Node) = 1) then
  begin
    TargetCanvas.Brush.Color := RGB(247, 247, 247);
    TargetCanvas.FillRect(CellRect);
  end;
end;

procedure TibSHDMLExporterForm.TreeClick(Sender: TObject);
var
  Pt: TPoint;
  vHitInfo: THitInfo;
begin
  GetCursorPos(Pt);
  Pt := Tree.ScreenToCLient(Pt);
  Tree.GetHitTestInfoAt(Pt.X, Pt.Y, True, vHitInfo);
  if Assigned(vHitInfo.HitNode) and (vHitInfo.HitColumn > 0) then
  begin
    Tree.EditNode(vHitInfo.HitNode, vHitInfo.HitColumn);
  end;
end;

procedure TibSHDMLExporterForm.TreeCreateEditor(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
var
  vEditLink: TDMLExporterObjectEditLink;
begin
  vEditLink := TDMLExporterObjectEditLink.Create;
  Supports(vEditLink, IVTEditLink, EditLink);
  vEditLink.OnRegistryEditor := RegisterSubEditor;
end;

procedure TibSHDMLExporterForm.TreeEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  with Sender do
  begin
    Allowed := //(Node.Parent <> RootNode) and
      (((Column = 3) and (DMLExporter.Mode = DMLExporterModes[0])) or (Column = 4)) and (Tree.GetNodeLevel(Node) = 0)
      or
      ((Column = 2) and (Tree.GetNodeLevel(Node) = 1));
  end;
end;

procedure TibSHDMLExporterForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHDMLExporterForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
  begin
    Finalize(Data^);
  end;
end;

procedure TibSHDMLExporterForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    case Column of
      0: if (Kind = ikNormal) or (Kind = ikSelected) then ImageIndex := Data.ImageIndex;
    end;
end;

procedure TibSHDMLExporterForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    case Column of
      0: if TextType = ttNormal then CellText := Data.ObjectName;
      1: if TextType = ttNormal then
             CellText := Data.Description;
      2: if TextType = ttNormal then CellText := EmptyStr;
      3: if TextType = ttNormal then CellText := Data.WhereClause;
      4: if TextType = ttNormal then CellText := Data.DestinationTable;
    end;
end;

procedure TibSHDMLExporterForm.TreeInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
begin
  if ParentNode = nil then
    InitialStates := InitialStates + [ivsHasChildren];
end;

procedure TibSHDMLExporterForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.ObjectName)) <> 1 then Result := 1;
end;

procedure TibSHDMLExporterForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  if Key = VK_RETURN then JumpToSource;
  if (Key = VK_RETURN) and (Shift = []) then
  begin
    if [tsEditing, tsEditPending] * Tree.TreeStates <> [] then
      Tree.EndEditNode
    else
    begin
      if Assigned(Tree.FocusedNode) then
        Tree.EditNode(Tree.FocusedNode, Tree.FocusedColumn);
    end;
  end;
end;

procedure TibSHDMLExporterForm.TreeDblClick(Sender: TObject);
var
  HT: THitInfo;
  P: TPoint;
  NodeData: PTreeRec;
begin
  if DMLExporter.Mode = DMLExporterModes[0] then
  begin
    GetCursorPos(P);
    P := Tree.ScreenToClient(P);
    Tree.GetHitTestInfoAt(P.X, P.Y, True, HT);
    if Assigned(HT.HitNode) and
      (Tree.GetNodeLevel(HT.HitNode) = 0) and
      ([hiOnItemButton, hiOnItemCheckbox] * HT.HitPositions = []) then
    begin
      NodeData := Tree.GetNodeData(HT.HitNode);
      if Assigned(NodeData) then
        Designer.JumpTo(Component.InstanceIID, IibSHTable, NodeData.ObjectName);
    end;
  end;
end;

procedure TibSHDMLExporterForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  Result := CompareStr(Data1.ObjectName, Data2.ObjectName);
end;

procedure TibSHDMLExporterForm.TreeExpanding(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var Allowed: Boolean);
begin
  if Assigned(Node) and (vsHasChildren in Node.States) then
    BuildChildNodes(Node);
end;

end.







