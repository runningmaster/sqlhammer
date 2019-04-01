unit ibSHDDLExtractorFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ExtCtrls, SynEdit, pSHSynEdit,
  VirtualTrees, StdCtrls, ActnList, AppEvnts,ibSHDriverIntf,ibSHSQLs;

type
(*  IBTRegionForms = interface
  ['{524B6ACC-3EF3-460E-B606-B9FED5F6C8F8}']
    function  CanWorkWithRegion: Boolean;
    procedure ShowHideRegion(AVisible: Boolean);
    function  GetRegionVisible: Boolean;
    property  RegionVisible: Boolean read GetRegionVisible;
  end;
*)
  TibSHDDLExtractorForm = class(TibBTComponentForm,iBTRegionForms)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Tree: TVirtualStringTree;
    Panel4: TPanel;
    pSHSynEdit1: TpSHSynEdit;
    ApplicationEvents1: TApplicationEvents;
    Panel5: TPanel;
    Image1: TImage;
    Panel6: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Panel7: TPanel;
    ProgressBar1: TProgressBar;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure Panel5Resize(Sender: TObject);
  private
    { Private declarations }
    FDDLExtractorIntf: IibSHDDLExtractor;

    FDomainList: TStrings;
    FTableList: TStrings;
    FIndexList: TStrings;
    FViewList: TStrings;
    FProcedureList: TStrings;
    FTriggerList: TStrings;
    FTriggerForViews:TStrings;
    FGeneratorList: TStrings;
    FExceptionList: TStrings;
    FFunctionList: TStrings;
    FFilterList: TStrings;
    FRoleList: TStrings;
    FScript  : TStrings;
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

    procedure SetTreeEvents(ATree: TVirtualStringTree);
    procedure BuildTree;
    procedure Prepare;
    procedure FillTriggersForView;
    procedure Extract(const AClassIID: TGUID; ASource: TStrings; Flag: Integer = -1);
    procedure ExtractBreakable(SourceList: TStrings; AType: string);
    procedure OnTextNotify(Sender: TObject; const Text: String);
  protected
    procedure RegisterEditors; override;

    { ISHFileCommands }
    function GetCanSaveAs: Boolean; override;
    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanPause: Boolean; override;
    function GetCanRefresh: Boolean; override;

    procedure Run; override;
    procedure Pause; override;
    procedure Refresh; override;
//IBTRegionForms
    procedure ShowHideRegion(AVisible: Boolean); override;
    function  CanWorkWithRegion: Boolean;
    function  GetRegionVisible: Boolean;
//    
    procedure DoOnIdle; override;
    function GetCanDestroy: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    property DDLExtractor: IibSHDDLExtractor read FDDLExtractorIntf;
    property DomainList: TStrings read FDomainList;
    property TableList: TStrings read FTableList;
    property IndexList: TStrings read FIndexList;
    property ViewList: TStrings read FViewList;
    property ProcedureList: TStrings read FProcedureList;
    property TriggerList: TStrings read FTriggerList;
    property GeneratorList: TStrings read FGeneratorList;
    property ExceptionList: TStrings read FExceptionList;
    property FunctionList: TStrings read FFunctionList;
    property FilterList: TStrings read FFilterList;
    property RoleList: TStrings read FRoleList;
  end;

var
  ibSHDDLExtractorForm: TibSHDDLExtractorForm;

implementation

uses
  ibSHConsts, ibSHValues;

{$R *.dfm}

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    NormalText: string;
    StaticText: string;
    Component: TSHComponent;
    ClassIID: TGUID;
    ImageIndex: Integer;
    Source: string;
  end;

{ TibSHDDLExtractorForm }

constructor TibSHDDLExtractorForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  FScript  := TStringList.Create;
  FDomainList := TStringList.Create;
  FTableList := TStringList.Create;
  FIndexList := TStringList.Create;
  FViewList := TStringList.Create;
  FProcedureList := TStringList.Create;
  FTriggerList := TStringList.Create;
  FGeneratorList := TStringList.Create;
  FExceptionList := TStringList.Create;
  FFunctionList := TStringList.Create;
  FFilterList := TStringList.Create;
  FRoleList := TStringList.Create;
  FTriggerForViews:=TStringList.Create;
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHDDLExtractor, FDDLExtractorIntf);
  Assert(DDLExtractor <> nil, 'DDLExtractor = nil');
  Assert(DDLExtractor.BTCLDatabase <> nil, 'DDLExtractor.BTCLDatabase = nil');

  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
  FocusedControl := Editor;
  
  RegisterEditors;
  SetTreeEvents(Tree);
  BuildTree;
  ShowHideRegion(False);
  DoOnOptionsChanged;
  Panel6.Caption := EmptyStr;
  DDLExtractor.OnTextNotify := OnTextNotify;
end;

destructor TibSHDDLExtractorForm.Destroy;
begin
  FScript.Free;
  FDomainList.Free;
  FTableList.Free;
  FIndexList.Free;
  FViewList.Free;
  FProcedureList.Free;
  FTriggerList.Free;
  FGeneratorList.Free;
  FExceptionList.Free;
  FFunctionList.Free;
  FFilterList.Free;
  FRoleList.Free;
  FTriggerForViews.Free;
  inherited Destroy;
end;

procedure TibSHDDLExtractorForm.SetTreeEvents(ATree: TVirtualStringTree);
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
  ATree.OnCompareNodes := TreeCompareNodes;
end;

procedure TibSHDDLExtractorForm.BuildTree;

  function BuildRootNode(const AClassIID: TGUID): PVirtualNode;
  var
    NodeData: PTreeRec;
  begin
    Result := Tree.AddChild(nil);
    Result.CheckType := ctTriStateCheckBox;
    NodeData := Tree.GetNodeData(Result);
    NodeData.NormalText := GUIDToName(AClassIID, 1);
    NodeData.StaticText := EmptyStr;
    NodeData.ClassIID := AClassIID;
    NodeData.ImageIndex  := Designer.GetImageIndex(AClassIID);
  end;

  procedure BuildRootNodes(const AClassIID: TGUID; AParent: PVirtualNode);
  var
    Node: PVirtualNode;
    NodeData, ParentData: PTreeRec;
    I: Integer;
  begin
    ParentData := Tree.GetNodeData(AParent);
    for I := 0 to Pred(DDLExtractor.BTCLDatabase.GetObjectNameList(AClassIID).Count) do
    begin
      Node := Tree.AddChild(AParent);
      Node.CheckType := ctTriStateCheckBox;
      NodeData := Tree.GetNodeData(Node);
      NodeData.NormalText := DDLExtractor.BTCLDatabase.GetObjectNameList(AClassIID)[I];
      NodeData.StaticText := EmptyStr;
      NodeData.ClassIID := AClassIID;
      NodeData.ImageIndex := ParentData.ImageIndex;
    end;
    Tree.Sort(AParent, 0, sdAscending);
  end;

begin
  try
    Tree.BeginUpdate;
    Tree.Clear;

    if DDLExtractor.BTCLDatabase.GetObjectNameList(IibSHDomain).Count > 0 then
      BuildRootNodes(IibSHDomain, BuildRootNode(IibSHDomain));

    if DDLExtractor.BTCLDatabase.GetObjectNameList(IibSHTable).Count > 0 then
      BuildRootNodes(IibSHTable, BuildRootNode(IibSHTable));

    if DDLExtractor.BTCLDatabase.GetObjectNameList(IibSHIndex).Count > 0 then
      BuildRootNodes(IibSHIndex, BuildRootNode(IibSHIndex));

    if DDLExtractor.BTCLDatabase.GetObjectNameList(IibSHView).Count > 0 then
      BuildRootNodes(IibSHView, BuildRootNode(IibSHView));

    if DDLExtractor.BTCLDatabase.GetObjectNameList(IibSHProcedure).Count > 0 then
      BuildRootNodes(IibSHProcedure, BuildRootNode(IibSHProcedure));

    if DDLExtractor.BTCLDatabase.GetObjectNameList(IibSHTrigger).Count > 0 then
      BuildRootNodes(IibSHTrigger, BuildRootNode(IibSHTrigger));

    if DDLExtractor.BTCLDatabase.GetObjectNameList(IibSHGenerator).Count > 0 then
      BuildRootNodes(IibSHGenerator, BuildRootNode(IibSHGenerator));

    if DDLExtractor.BTCLDatabase.GetObjectNameList(IibSHException).Count > 0 then
      BuildRootNodes(IibSHException, BuildRootNode(IibSHException));

    if DDLExtractor.BTCLDatabase.GetObjectNameList(IibSHFunction).Count > 0 then
      BuildRootNodes(IibSHFunction, BuildRootNode(IibSHFunction));

    if DDLExtractor.BTCLDatabase.GetObjectNameList(IibSHFilter).Count > 0 then
      BuildRootNodes(IibSHFilter, BuildRootNode(IibSHFilter));

    if DDLExtractor.BTCLDatabase.GetObjectNameList(IibSHRole).Count > 0 then
      BuildRootNodes(IibSHRole, BuildRootNode(IibSHRole));

    if Tree.RootNodeCount > 0 then
    begin
      Tree.FocusedNode := Tree.GetFirst;
      Tree.Selected[Tree.FocusedNode] := True;
    end;
  finally
    Tree.EndUpdate;
  end;
end;

type TViewDependence = record
      ViewName:string;
      UsedViewName:string;
     end;


procedure TibSHDDLExtractorForm.Prepare;
  procedure PrepareList(const AClassIID: TGUID; ASource: TStrings);
  var
    Node: PVirtualNode;
    NodeData: PTreeRec;
  begin
    ASource.Clear;
    if DDLExtractor.Mode = ExtractModes[0] then
    begin
     ASource.AddStrings(DDLExtractor.BTCLDatabase.GetObjectNameList(AClassIID));
    end
    else
    begin
      Node := Tree.GetFirst;
      while Assigned(Node) do
      begin
        NodeData := Tree.GetNodeData(Node);
        if Assigned(NodeData) and IsEqualGUID(NodeData.ClassIID, AClassIID) and
          (Tree.GetNodeLevel(Node) = 1) and (Node.CheckState = csCheckedNormal) then
          ASource.Add(NodeData.NormalText);
        Node := Tree.GetNext(Node);
      end;
    end;
  end;

var
  ViewDependencies:array of TViewDependence;


  procedure PrepareViewDependencies;
  var
    q:IibSHDRVQuery;
    i,L,L1:integer;
    tmp:TViewDependence;
      s:string;
  function FindCurUsed(const aViewName:string; FromPos:integer):integer;
  var j:integer;
  begin
   Result:=-1;
   for j:=FromPos to L1-1 do
   if ViewDependencies[j].ViewName=aViewName then
   begin
    Result:=j; Break
   end
  end;

  begin
  // Готовим список зависимостей вьюх от вьюх
   L:=200;
   L1:=0;
   SetLength(ViewDependencies,L);
   q:=DDLExtractor.BTCLDatabase.DRVQuery;
   if Assigned(q) then
   begin
    q.Close;
    q.SQL.Text:=SQL_VIEWS_DEPENDENCIES;
    if not q.Transaction.InTransaction then
     q.Transaction.StartTransaction;
    q.Execute;
    while not q.Eof do
    begin
      if L1>L then
      begin
       L:=L+50;
       SetLength(ViewDependencies,L);
      end;
      ViewDependencies[L1].ViewName:=q.GetFieldStrValue(0);
      ViewDependencies[L1].UsedViewName:=q.GetFieldStrValue(1);
      Inc(L1);
      q.Next
    end;
    q.Close;
    q.Transaction.Commit;
   end;
   SetLength(ViewDependencies,L1);
   // Сортируем список в правильном порядке.

   i:=0;
   while i<L1 do
   begin
    L:=FindCurUsed(ViewDependencies[i].UsedViewName,i+1);
    if L>i then
    begin
     tmp:=ViewDependencies[i];
     ViewDependencies[i]:=ViewDependencies[L];
     ViewDependencies[L]:=tmp
    end
    else
     Inc(i)
   end;


   i:=L1-1;
   while i>0 do
   begin
    L:=FindCurUsed(ViewDependencies[i].ViewName,0);
    if L<>i then
    begin
     ViewDependencies[L].ViewName:='';
     ViewDependencies[L].UsedViewName:='';
{     Move(ViewDependencies[L+1],  ViewDependencies[L],
      SizeOf(ViewDependencies[L])*(L1-L-1)
     );
     SetLength(ViewDependencies,L1-1);
     Dec(L1)}
    end;
    Dec(i)
   end;

   // Теперь нужно изменить порядок во ViewList

   i:=0 ;
   while i<Pred(ViewList.Count) do
   begin
    if  FindCurUsed(ViewList[i],0)>-1 then
     ViewList.Delete(i)
    else
     Inc(i)
   end;

   s:='';
   for i:=0 to L1-1 do
    if (Length(ViewDependencies[i].ViewName)>0) and(ViewDependencies[i].ViewName<>s)
    then
    begin
     s:=ViewDependencies[i].ViewName;
     ViewList.Add(s)
    end
  end;
begin
  PrepareList(IibSHDomain, DomainList);
  PrepareList(IibSHTable, TableList);
  PrepareList(IibSHIndex, IndexList);
  PrepareList(IibSHView, ViewList);
  if DDLExtractor.Mode = ExtractModes[0] then
   PrepareViewDependencies;
  PrepareList(IibSHProcedure, ProcedureList);
  PrepareList(IibSHTrigger, TriggerList);
  if DDLExtractor.Mode = ExtractModes[0] then
   FillTriggersForView;

  PrepareList(IibSHGenerator, GeneratorList);
  PrepareList(IibSHException, ExceptionList);
  PrepareList(IibSHFunction, FunctionList);
  PrepareList(IibSHFilter, FilterList);
  PrepareList(IibSHRole, RoleList);
end;

procedure TibSHDDLExtractorForm.FillTriggersForView;
var
   i:integer;
begin
   i:=0;
   while i<FTriggerList.Count do
   begin
    if Integer(FTriggerList.Objects[i])<>1 then
     Inc(i)
    else
    begin
     FTriggerForViews.Add(FTriggerList[i]);
     FTriggerList.Delete(i);
    end
   end;
end;

procedure TibSHDDLExtractorForm.Extract(const AClassIID: TGUID; ASource: TStrings; Flag: Integer = -1);
var
  I, Count: Integer;
begin
  if DDLExtractor.Active then
  begin
    Image1.Canvas.Brush.Color := clBtnFace;
    Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
    Designer.ImageList.Draw(Image1.Canvas, (Image1.Canvas.ClipRect.Left + Image1.Canvas.ClipRect.Right - 16) div 2, (Image1.Canvas.ClipRect.Top + Image1.Canvas.ClipRect.Bottom - 16) div 2, Designer.GetImageIndex(AClassIID));
    Panel6.Caption := Format('Extracting %s...', [GUIDToName(AClassIID, 1)]);
    Count := ASource.Count;
    for I := 0 to Pred(Count) do
    begin
      DDLExtractor.DisplayDBObject(AClassIID, ASource[I], Flag);
      ProgressBar1.Position := 100 * I div Count;
      Application.ProcessMessages;
      if not DDLExtractor.Active then Break;
    end;
  end;
end;

procedure TibSHDDLExtractorForm.ExtractBreakable(SourceList: TStrings; AType: string);
var
  I, Count: Integer;
  vClassIID: TGUID;
begin
  if DDLExtractor.Active and Assigned(SourceList) then
  if Length(AType)>0 then
  begin
    case AType[1] of
     'C','c':
      if SameText(AType, 'CHECK') then
      begin
        Panel6.Caption := 'Extracting checks...';
        vClassIID := IibSHConstraint;
      end
      else
      if SameText(AType, 'CONSTRAINTS') then
      begin
        Panel6.Caption := Format('Extracting %s...', [GUIDToName(IibSHConstraint, 1)]);
        vClassIID := IibSHConstraint;
      end
      else
      if SameText(AType, 'COMPUTED BY') then
      begin
        Panel6.Caption := Format('Extracting %s...', [GUIDToName(IibSHField, 1)]);
        vClassIID := IibSHField;
      end;
     'D','d':
      if SameText(AType, 'DESCRIPTIONS') then
      begin
        Panel6.Caption := 'Extracting descriptions...';
        vClassIID := ISHBranch;
      end;

     'F','f':
      if SameText(AType, 'FOREIGN KEY') then
      begin
        Panel6.Caption := 'Extracting foreign keys...';
        vClassIID := IibSHConstraint;
      end;
     'G','g':
      if SameText(AType, 'GRANTS') then
      begin
        Panel6.Caption := 'Extracting grants...';
        vClassIID := IibSHGrantWGO;
      end;
     'I','i':
      if SameText(AType, 'INDICES') then
      begin
        Panel6.Caption := Format('Extracting %s...', [GUIDToName(IibSHIndex, 1)]);
        vClassIID := IibSHIndex;
      end;
     'P','p':
      if SameText(AType, 'PRIMARY KEY') then
      begin
        Panel6.Caption := 'Extracting primary keys...';
        vClassIID := IibSHConstraint;
      end;
     'T','t':
      if SameText(AType, 'TRIGGERS') then
      begin
        Panel6.Caption := Format('Extracting %s...', [GUIDToName(IibSHTrigger, 1)]);
        vClassIID := IibSHTrigger;
      end;
     'U','u':
      if SameText(AType, 'UNIQUE') then
      begin
        Panel6.Caption := 'Extracting unique keys...';
        vClassIID := IibSHConstraint;
      end;

    end;

    Image1.Canvas.Brush.Color := clBtnFace;
    Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
    Designer.ImageList.Draw(Image1.Canvas, (Image1.Canvas.ClipRect.Left + Image1.Canvas.ClipRect.Right - 16) div 2, (Image1.Canvas.ClipRect.Top + Image1.Canvas.ClipRect.Bottom - 16) div 2, Designer.GetImageIndex(vClassIID));
    Count := SourceList.Count;
    for I := 0 to Pred(Count) do
    begin
      if not SameText(AType, 'GRANTS') then OnTextNotify(Self, EmptyStr);
      OnTextNotify(Self, SourceList[I]);
      ProgressBar1.Position := 100 * I div Count;
      Application.ProcessMessages;
      if not DDLExtractor.Active then Break;
    end;
   end;
end;

procedure TibSHDDLExtractorForm.OnTextNotify(Sender: TObject; const Text: String);
begin
  // Buzz: Совать прямо в синэдит - слишком тормозно
{  if Length(Text) > 0 then
    Designer.TextToStrings(Text, Editor.Lines)
  else
    Editor.Lines.Add(Text);

  Editor.CaretY := Pred(Editor.Lines.Count);}

  if Length(Text) > 0 then
    Designer.TextToStrings(Text, FScript)
  else  
    FScript.Add(Text);

  Application.ProcessMessages;
end;

procedure TibSHDDLExtractorForm.RegisterEditors;
var
  vEditorRegistrator: IibSHEditorRegistrator;
begin
  if Supports(Designer.GetDemon(IibSHEditorRegistrator), IibSHEditorRegistrator, vEditorRegistrator) then
    vEditorRegistrator.RegisterEditor(Editor, DDLExtractor.BTCLDatabase.BTCLServer, DDLExtractor.BTCLDatabase);
end;

function TibSHDDLExtractorForm.GetCanSaveAs: Boolean;
begin
  Result := not DDLExtractor.Active;
end;

function TibSHDDLExtractorForm.GetCanRun: Boolean;
begin
  Result := not DDLExtractor.Active;
end;

function TibSHDDLExtractorForm.GetCanPause: Boolean;
begin
  Result := DDLExtractor.Active;
end;

function TibSHDDLExtractorForm.GetCanRefresh: Boolean;
begin
  Result := Tree.CanFocus;
end;

procedure TibSHDDLExtractorForm.Run;
var
  OldShowBeginEndRegions:boolean;
begin
  Panel5.Visible := True;
  Editor.Lines.Clear;
  DDLExtractor.Active := True;
  Designer.UpdateActions;
  DoOnIdle;
  Application.ProcessMessages;
  FScript.Clear;
  OldShowBeginEndRegions:=TpSHSynEdit(Editor).ShowBeginEndRegions;
  if OldShowBeginEndRegions then
    TpSHSynEdit(Editor).ShowBeginEndRegions:=False;

  try
    DDLExtractor.Prepare;
    DDLExtractor.DisplayScriptHeader;

    DDLExtractor.DisplayDialect;
    DDLExtractor.DisplayNames;

    if DDLExtractor.Active and (DDLExtractor.Header <> ExtractHeaders[2]) {None} then
    begin
      FScript.Add(EmptyStr);
      Editor.Lines.Add(EmptyStr);
      FScript.Add('/* < == Extracting database header... ===================================== > */');
      FScript.Add('/* < ====================================================================== > */');
      Editor.Lines.Add('/* < == Extracting database header... ===================================== > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      if DDLExtractor.Header = ExtractHeaders[0] {Create} then

       DDLExtractor.DisplayDatabase;
      if DDLExtractor.Header = ExtractHeaders[1] {Connect} then DDLExtractor.DisplayConnect;
    end;

    if DDLExtractor.Active then Prepare;

    if DDLExtractor.Active and (FunctionList.Count > 0) then
    begin

      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting functions... =========================================== > */' );
      FScript.Add('/* < ====================================================================== > */');
      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting functions... =========================================== > */' );
      Editor.Lines.Add('/* < ====================================================================== > */');
      Extract(IibSHFunction, FunctionList);
    end;

    if DDLExtractor.Active and (FilterList.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting filters... ============================================= > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting filters... ============================================= > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      Extract(IibSHFilter, FilterList);
    end;

    if DDLExtractor.Active and (DomainList.Count > 0) then
    begin

      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting domains... ============================================= > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting domains... ============================================= > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      Extract(IibSHDomain, DomainList);
    end;

    if DDLExtractor.Active and (ExceptionList.Count > 0) then
    begin

      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting exceptions... ========================================== > */');
      FScript.Add('/* < ====================================================================== > */');
      
      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting exceptions... ========================================== > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      Extract(IibSHException, ExceptionList);
    end;

    if DDLExtractor.Active and (GeneratorList.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting generators... ========================================== > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting generators... ========================================== > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      Extract(IibSHGenerator, GeneratorList);
    end;

    if DDLExtractor.Active and (ProcedureList.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting procedure headers... =================================== > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting procedure headers... =================================== > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      DDLExtractor.DisplayTerminatorStart;
      Extract(IibSHProcedure, ProcedureList, 0); // only headers
      DDLExtractor.DisplayTerminatorEnd;
    end;

    if DDLExtractor.Active and (TableList.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting tables... ============================================== > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting tables... ============================================== > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      Extract(IibSHTable, TableList);
    end;

    if DDLExtractor.Active and (DDLExtractor.ComputedSeparately) then
    begin
      if DDLExtractor.GetComputedList.Count > 0 then
      begin

        FScript.Add(EmptyStr);
        FScript.Add('/* < == Extracting computed fields... ===================================== > */');
        FScript.Add('/* < ====================================================================== > */');

        Editor.Lines.Add(EmptyStr);
        Editor.Lines.Add('/* < == Extracting computed fields... ===================================== > */');
        Editor.Lines.Add('/* < ====================================================================== > */');
        ExtractBreakable(DDLExtractor.GetComputedList, 'COMPUTED BY');
      end;
    end;

    if DDLExtractor.Active and (ViewList.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting views... =============================================== > */' );
      FScript.Add('/* < ====================================================================== > */' );

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting views... =============================================== > */' );
      Editor.Lines.Add('/* < ====================================================================== > */' );
      Extract(IibSHView, ViewList);
    end;

    if DDLExtractor.Active and (DDLExtractor.GetPrimaryList.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting constraints (PRIMARY KEY)... =========================== > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting constraints (PRIMARY KEY)... =========================== > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      ExtractBreakable(DDLExtractor.GetPrimaryList, 'PRIMARY KEY');
    end;

    if DDLExtractor.Active and (DDLExtractor.GetUniqueList.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting constraints (UNIQUE)... ================================ > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting constraints (UNIQUE)... ================================ > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      ExtractBreakable(DDLExtractor.GetUniqueList, 'UNIQUE');
    end;

    if DDLExtractor.Active and (DDLExtractor.GetForeignList.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting constraints (FOREIGN KEY)... =========================== > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting constraints (FOREIGN KEY)... =========================== > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      ExtractBreakable(DDLExtractor.GetForeignList, 'FOREIGN KEY');
    end;

    if DDLExtractor.Active and (DDLExtractor.GetCheckList.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting constraints (CHECK)... ================================= > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting constraints (CHECK)... ================================= > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      ExtractBreakable(DDLExtractor.GetCheckList, 'CHECK');
    end;

    if DDLExtractor.Active and (IndexList.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting indices... ============================================= > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting indices... ============================================= > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      Extract(IibSHIndex, IndexList);
    end;

    if DDLExtractor.Active and (FTriggerForViews.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting triggers for Views... ============================================ > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting triggers  for Views... ============================================ > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      DDLExtractor.DisplayTerminatorStart;
      Extract(IibSHTrigger, FTriggerForViews,0);
      DDLExtractor.DisplayTerminatorEnd;
    end;

    if DDLExtractor.Active and (FTriggerForViews.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting triggers for Views... ============================================ > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting triggers  for Views... ============================================ > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      DDLExtractor.DisplayTerminatorStart;
      Extract(IibSHTrigger, FTriggerForViews,1);
      DDLExtractor.DisplayTerminatorEnd;
    end;

    if DDLExtractor.Active and (FTriggerList.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting triggers... ============================================ > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting triggers... ============================================ > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      DDLExtractor.DisplayTerminatorStart;
      Extract(IibSHTrigger, FTriggerList);
      DDLExtractor.DisplayTerminatorEnd;
    end;

    if DDLExtractor.Active and (ProcedureList.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting procedures... ========================================== > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting procedures... ========================================== > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      DDLExtractor.DisplayTerminatorStart;
      Extract(IibSHProcedure, ProcedureList);
      DDLExtractor.DisplayTerminatorEnd;
    end;


    if DDLExtractor.Active and (RoleList.Count > 0) then
    begin
      FScript.Add(EmptyStr);
      FScript.Add('/* < == Extracting roles... =============================================== > */');
      FScript.Add('/* < ====================================================================== > */');

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add('/* < == Extracting roles... =============================================== > */');
      Editor.Lines.Add('/* < ====================================================================== > */');
      Extract(IibSHRole, RoleList);
    end;

    {TODO: Privileges}
    if DDLExtractor.Active and DDLExtractor.Grants then
    begin
      if DDLExtractor.GetGrantList.Count > 0 then
      begin
        FScript.Add(EmptyStr);
        FScript.Add('/* < == Extracting grants... ============================================== > */');
        FScript.Add('/* < ====================================================================== > */');

        Editor.Lines.Add(EmptyStr);
        Editor.Lines.Add('/* < == Extracting grants... ============================================== > */');
        Editor.Lines.Add('/* < ====================================================================== > */');
        Editor.Lines.Add(EmptyStr);
        ExtractBreakable(DDLExtractor.GetGrantList, 'GRANTS');
      end;
    end;

    if DDLExtractor.Active and DDLExtractor.Descriptions then
    begin
      if DDLExtractor.GetDescriptionList.Count > 0 then
      begin
        FScript.Add(EmptyStr);
        FScript.Add('/* < == Extracting descriptions... ======================================== > */');
        FScript.Add('/* < ====================================================================== > */');

        Editor.Lines.Add(EmptyStr);
        Editor.Lines.Add('/* < == Extracting descriptions... ======================================== > */');
        Editor.Lines.Add('/* < ====================================================================== > */');
        ExtractBreakable(DDLExtractor.GetDescriptionList, 'DESCRIPTIONS');
      end;
    end;

    if DDLExtractor.Active and DDLExtractor.FinalCommit then DDLExtractor.DisplayCommitWork;

    if not DDLExtractor.Active then
    begin
      FScript.Add(EmptyStr);
      FScript.Add(Format('/* BT: DDL Extractor stopped by user at %s               */', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', Now)]));

      Editor.Lines.Add(EmptyStr);
      Editor.Lines.Add(Format('/* BT: DDL Extractor stopped by user at %s               */', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', Now)]));
    end else
      DDLExtractor.DisplayScriptFooter;
  finally
    Editor.Lines.Assign(FScript);
    DDLExtractor.Active := False;
    Panel6.Caption := EmptyStr;
    Panel5.Visible := False;
   if OldShowBeginEndRegions then
    TpSHSynEdit(Editor).ShowBeginEndRegions:=True;

  end;
end;

procedure TibSHDDLExtractorForm.Pause;
begin
  DDLExtractor.Active := False;
  Panel6.Caption := EmptyStr;
  Panel5.Visible := False;
end;

procedure TibSHDDLExtractorForm.Refresh;
begin
  BuildTree;
end;

procedure TibSHDDLExtractorForm.ShowHideRegion(AVisible: Boolean);
begin
  if AVisible then
   DDLExtractor.Mode:=ExtractModes[1]
  else
   DDLExtractor.Mode:=ExtractModes[0];
  if GetRegionVisible then
  begin
    Panel3.Visible := True;
    Splitter1.Visible := True;
  end else
  begin
    Splitter1.Visible := False;
    Panel3.Visible := False;
  end;
end;              

procedure TibSHDDLExtractorForm.DoOnIdle;
begin
  ShowHideRegion(GetRegionVisible); // Говно но пока сойдет
end;

function TibSHDDLExtractorForm.GetCanDestroy: Boolean;
begin
  Result := inherited GetCanDestroy;
  if DDLExtractor.BTCLDatabase.WasLostConnect then Exit;

  if DDLExtractor.Active then Designer.ShowMsg('Extract process is running...', mtInformation);
  Result := Assigned(DDLExtractor) and not DDLExtractor.Active;
end;

procedure TibSHDDLExtractorForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  DoOnIdle;
end;

procedure TibSHDDLExtractorForm.Panel5Resize(Sender: TObject);
begin
  ProgressBar1.Width := ProgressBar1.Parent.ClientWidth - 8;
end;

{ Tree }

procedure TibSHDDLExtractorForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHDDLExtractorForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibSHDDLExtractorForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if (Kind = ikNormal) or (Kind = ikSelected) then ImageIndex := Data.ImageIndex;
end;

procedure TibSHDDLExtractorForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  case TextType of
    ttNormal: CellText := Data.NormalText;
    ttStatic: case Sender.GetNodeLevel(Node) of
                0: CellText := Format('%d', [Node.ChildCount]);
              end;
  end;
end;

procedure TibSHDDLExtractorForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
//var
//  Data: PTreeRec;
begin
//  Data := Sender.GetNodeData(Node);
  case TextType of
    ttNormal: ;
    ttStatic: if Sender.Focused and (vsSelected in Node.States) then
                TargetCanvas.Font.Color := clWindow
              else
                TargetCanvas.Font.Color := clGray;
  end;
end;

procedure TibSHDDLExtractorForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.NormalText)) <> 1 then Result := 1;
end;

procedure TibSHDDLExtractorForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  if Key = VK_RETURN then JumpToSource;
end;

procedure TibSHDDLExtractorForm.TreeDblClick(Sender: TObject);
var
  HT: THitInfo;
  P: TPoint;
begin
  GetCursorPos(P);
  P := Tree.ScreenToClient(P);
  Tree.GetHitTestInfoAt(P.X, P.Y, True, HT);
//  if not (hiOnItemButton in HT.HitPositions) then JumpToSource;
end;

procedure TibSHDDLExtractorForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  Result := CompareStr(Data1.NormalText, Data2.NormalText);
end;

function TibSHDDLExtractorForm.CanWorkWithRegion: Boolean;
begin
 Result:=True
end;

function TibSHDDLExtractorForm.GetRegionVisible: Boolean;
begin
 Result:=DDLExtractor.Mode=ExtractModes[1]
end;

end.



