unit ibSHDDLCommentatorFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, AppEvnts, ActnList, ImgList,
  SynEdit, pSHSynEdit, VirtualTrees, Menus, StdCtrls;

type
  TFilterRule=(frAll,frHaveDescrOnly);

  TibSHDDLCommentatorForm = class(TibBTComponentForm)
    ApplicationEvents1: TApplicationEvents;
    Panel1: TPanel;
    Tree: TVirtualStringTree;
    Splitter1: TSplitter;
    Panel2: TPanel;
    pSHSynEdit1: TpSHSynEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    chOnlyExistComment: TCheckBox;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure chOnlyExistCommentClick(Sender: TObject);
  private
    { Private declarations }
    FDDLCommentatorIntf: IibSHDDLCommentator;
    FDDLGenerator: TComponent;
    FDDLGeneratorIntf: IibSHDDLGenerator;

    FTMPDomain: TComponent;
    FTMPTable: TComponent;
    FTMPIndex: TComponent;
    FTMPView: TComponent;
    FTMPProcedure: TComponent;
    FTMPTrigger: TComponent;
    FTMPException: TComponent;
    FTMPFunction: TComponent;
    FTMPFilter: TComponent;
    FTMPField: TComponent;
    FTMPProcParam: TComponent;

    FTMPDomainIntf: IibSHDomain;
    FTMPTableIntf: IibSHTable;
    FTMPIndexIntf: IibSHIndex;
    FTMPViewIntf: IibSHView;
    FTMPProcedureIntf: IibSHProcedure;
    FTMPTriggerIntf: IibSHTrigger;
    FTMPExceptionIntf: IibSHException;
    FTMPFunctionIntf: IibSHFunction;
    FTMPFilterIntf: IibSHFilter;
    FTMPFieldIntf: IibSHField;
    FTMPProcParamIntf: IibSHProcParam;
    FFilterRule:TFilterRule;

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
    procedure TreeExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
    procedure TreeCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreeChangeFilter;
  private
 //  IibBTDataBaseExt
    FDomainsWithComment:TStrings;
    FTablesWithComment:TStrings;

    FViewsWithComment:TStrings;
    FTriggersWithComment:TStrings;
    FProceduresWithComment:TStrings;
    FFunctionsWithComment:TStrings;
    FExceptionsWithComment:TStrings;                
    FFieldsWithComment:TStrings;
    FProcParamsWithComment:TStrings;


    function  GetListObjectsWithComments(const ClassObject: TGUID):TStrings;

    procedure CreateTMPcomponents;
    procedure DestroyTMPcomponents;
    procedure SetTreeEvents(ATree: TVirtualStringTree);
    procedure FillTree(const AClassIID: TGUID);
    procedure FreeFields(ParentNode: PVirtualNode);
    procedure ExtractFields(ParentNode: PVirtualNode);
    procedure DoOnGetData;
    procedure ShowSource;
    procedure JumpToSource;
    procedure InternalRun(ANode: PVirtualNode);
    procedure GetNextNodeForDescr(ANode: PVirtualNode);
  protected
    { Protected declarations }
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

    property DDLCommentator: IibSHDDLCommentator read FDDLCommentatorIntf;
    property DDLGenerator: IibSHDDLGenerator read FDDLGeneratorIntf;

    property TMPDomain: IibSHDomain read FTMPDomainIntf;
    property TMPTable: IibSHTable read FTMPTableIntf;
    property TMPIndex: IibSHIndex read FTMPIndexIntf;
    property TMPView: IibSHView read FTMPViewIntf;
    property TMPProcedure: IibSHProcedure read FTMPProcedureIntf;
    property TMPTrigger: IibSHTrigger read FTMPTriggerIntf;
    property TMPException: IibSHException read FTMPExceptionIntf;
    property TMPFunction: IibSHFunction read FTMPFunctionIntf;
    property TMPFilter: IibSHFilter read FTMPFilterIntf;

    property TMPField: IibSHField read FTMPFieldIntf;
    property TMPProcParam: IibSHProcParam read FTMPProcParamIntf;
  end;

var
  ibSHDDLCommentatorForm: TibSHDDLCommentatorForm;

implementation

uses
  ibSHConsts, ibSHValues;

{$R *.dfm}

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    ClassIID: TGUID;
    Name: string;
    ImageIndex: Integer;
    Description: string;
    Input: Boolean;
    IsObject: Boolean;
    IsDescription: Boolean;
    IsField      : Boolean;
  end;

{ TibSHDDLCommentatorForm }

constructor TibSHDDLCommentatorForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHDDLCommentator, FDDLCommentatorIntf);

  vComponentClass := Designer.GetComponent(IibSHDDLGenerator);
  if Assigned(vComponentClass) then
  begin
    FDDLGenerator := vComponentClass.Create(nil);
    Supports(FDDLGenerator, IibSHDDLGenerator, FDDLGeneratorIntf);
  end;

  CreateTMPcomponents;

  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
//  Editor.Lines.AddStrings(DBObject.Description);
  FocusedControl := Tree;
  SetTreeEvents(Tree);

  DoOnOptionsChanged;


  RefreshData;
end;

destructor TibSHDDLCommentatorForm.Destroy;
begin
  if GetCanRun then Run;
  DestroyTMPcomponents;


  inherited Destroy;
end;

procedure TibSHDDLCommentatorForm.RefreshData;
begin
  try
    Screen.Cursor := crHourGlass;
    DoOnGetData;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TibSHDDLCommentatorForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  DoOnIdle;
end;

procedure TibSHDDLCommentatorForm.CreateTMPComponents;
begin
  FTMPDomain := Designer.GetComponent(IibSHDomain).Create(nil);
  FTMPTable := Designer.GetComponent(IibSHTable).Create(nil);
  FTMPIndex := Designer.GetComponent(IibSHIndex).Create(nil);
  FTMPView := Designer.GetComponent(IibSHView).Create(nil);
  FTMPProcedure := Designer.GetComponent(IibSHProcedure).Create(nil);
  FTMPTrigger := Designer.GetComponent(IibSHTrigger).Create(nil);
  FTMPException := Designer.GetComponent(IibSHException).Create(nil);
  FTMPFunction := Designer.GetComponent(IibSHFunction).Create(nil);
  FTMPFilter := Designer.GetComponent(IibSHFilter).Create(nil);
  FTMPField := Designer.GetComponent(IibSHField).Create(nil);
  FTMPProcParam := Designer.GetComponent(IibSHProcParam).Create(nil);

  Designer.Components.Remove(FTMPDomain);
  Designer.Components.Remove(FTMPTable);
  Designer.Components.Remove(FTMPIndex);
  Designer.Components.Remove(FTMPView);
  Designer.Components.Remove(FTMPProcedure);
  Designer.Components.Remove(FTMPTrigger);
  Designer.Components.Remove(FTMPException);
  Designer.Components.Remove(FTMPFunction);
  Designer.Components.Remove(FTMPFilter);
  Designer.Components.Remove(FTMPField);
  Designer.Components.Remove(FTMPProcParam);

  (FTMPDomain as TSHComponent).OwnerIID := DDLCommentator.OwnerIID;
  (FTMPTable as TSHComponent).OwnerIID := DDLCommentator.OwnerIID;
  (FTMPIndex as TSHComponent).OwnerIID := DDLCommentator.OwnerIID;
  (FTMPView as TSHComponent).OwnerIID := DDLCommentator.OwnerIID;
  (FTMPProcedure as TSHComponent).OwnerIID := DDLCommentator.OwnerIID;
  (FTMPTrigger as TSHComponent).OwnerIID := DDLCommentator.OwnerIID;
  (FTMPException as TSHComponent).OwnerIID := DDLCommentator.OwnerIID;
  (FTMPFunction as TSHComponent).OwnerIID := DDLCommentator.OwnerIID;
  (FTMPFilter as TSHComponent).OwnerIID := DDLCommentator.OwnerIID;
  (FTMPField as TSHComponent).OwnerIID := DDLCommentator.OwnerIID;
  (FTMPProcParam as TSHComponent).OwnerIID := DDLCommentator.OwnerIID;

  Supports(FTMPDomain, IibSHDomain, FTMPDomainIntf);
  Supports(FTMPTable, IibSHTable, FTMPTableIntf);
  Supports(FTMPIndex, IibSHIndex, FTMPIndexIntf);
  Supports(FTMPView, IibSHView, FTMPViewIntf);
  Supports(FTMPProcedure, IibSHProcedure, FTMPProcedureIntf);
  Supports(FTMPTrigger, IibSHTrigger, FTMPTriggerIntf);
  Supports(FTMPException, IibSHException, FTMPExceptionIntf);
  Supports(FTMPFunction, IibSHFunction, FTMPFunctionIntf);
  Supports(FTMPFilter, IibSHFilter, FTMPFilterIntf);
  Supports(FTMPField, IibSHField, FTMPFieldIntf);
  Supports(FTMPProcParam, IibSHProcParam, FTMPProcParamIntf);

  FDomainsWithComment:=TStringList.Create;
  FTablesWithComment:=TStringList.Create;

  FViewsWithComment:=TStringList.Create;
  FTriggersWithComment:=TStringList.Create;
  FProceduresWithComment:=TStringList.Create;
  FFunctionsWithComment:=TStringList.Create;
  FExceptionsWithComment:=TStringList.Create;
  FFieldsWithComment    :=TStringList.Create;
  FProcParamsWithComment:=TStringList.Create;
end;

procedure TibSHDDLCommentatorForm.DestroyTMPcomponents;
begin
  FTMPDomainIntf := nil;
  FTMPTableIntf := nil;
  FTMPIndexIntf := nil;
  FTMPViewIntf := nil;
  FTMPProcedureIntf := nil;
  FTMPTriggerIntf := nil;
  FTMPExceptionIntf := nil;
  FTMPFunctionIntf := nil;
  FTMPFilterIntf := nil;
  FTMPFieldIntf := nil;
  FTMPProcParamIntf := nil;

  FTMPDomain.Free;
  FTMPTable.Free;
  FTMPIndex.Free;
  FTMPView.Free;
  FTMPProcedure.Free;
  FTMPTrigger.Free;
  FTMPException.Free;
  FTMPFunction.Free;
  FTMPFilter.Free;
  FTMPField.Free;
  FTMPProcParam.Free;

  FDomainsWithComment.Free;
  FTablesWithComment.Free;

  FViewsWithComment.Free;
  FTriggersWithComment.Free;
  FProceduresWithComment.Free;
  FFunctionsWithComment.Free ;
  FExceptionsWithComment.Free ;
  FFieldsWithComment.Free;
  FProcParamsWithComment.Free;

end;

procedure TibSHDDLCommentatorForm.SetTreeEvents(ATree: TVirtualStringTree);
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
  ATree.OnExpanding := TreeExpanding;
  ATree.OnCollapsed := TreeCollapsed;
end;

procedure TibSHDDLCommentatorForm.FillTree(const AClassIID: TGUID);
var
  I: Integer;
  Node, ParentNode: PVirtualNode;
  NodeData: PTreeRec;
  ImageIndex: Integer;
begin
  ParentNode := nil;
  ImageIndex := Designer.GetImageIndex(AClassIID);

  Tree.Indent := 0;

  if DDLCommentator.Mode = CommentModes[0] then
  begin
    ParentNode := Tree.AddChild(ParentNode);
    NodeData := Tree.GetNodeData(ParentNode);
    NodeData.ClassIID := IUnknown;
    NodeData.Name := GUIDToName(AClassIID, 1);
    NodeData.ImageIndex := ImageIndex;
    NodeData.Description := EmptyStr;
    Tree.Indent := 12;
  end;

  for I := 0 to Pred(DDLCommentator.BTCLDatabase.GetObjectNameList(AClassIID).Count) do
  begin
    Node := Tree.AddChild(ParentNode);
    NodeData := Tree.GetNodeData(Node);
    NodeData.ClassIID := AClassIID;
    NodeData.Name := DDLCommentator.BTCLDatabase.GetObjectNameList(AClassIID)[I];
    NodeData.ImageIndex := ImageIndex;
    NodeData.IsObject := True;

    if IsEqualGUID(AClassIID, IibSHTable) or
       IsEqualGUID(AClassIID, IibSHView) or
       IsEqualGUID(AClassIID, IibSHProcedure) then
    begin
      Tree.AddChild(Node);
      Tree.Indent := 12;
    end;
  end;
end;

procedure TibSHDDLCommentatorForm.FreeFields(ParentNode: PVirtualNode);
var
  NodeData :PTreeRec;
begin
  NodeData := Tree.GetNodeData(ParentNode);
  if Assigned(NodeData) and NodeData.IsObject then
    Tree.DeleteChildren(ParentNode);
end;

procedure TibSHDDLCommentatorForm.ExtractFields(ParentNode: PVirtualNode);
var
  I: Integer;
  Node: PVirtualNode;
  NodeData: PTreeRec;
  ImageIndex: Integer;
  vComponentClass: TSHComponentClass;
  vComponent: TSHComponent;
  DBObject: IibSHDBObject;
  DBTable: IibSHTable;
  DBView: IibSHView;
  DBProcedure: IibSHProcedure;
begin
  vComponent := nil;
  Screen.Cursor := crHourGlass;
  Tree.BeginUpdate;
  try
    NodeData := Tree.GetNodeData(ParentNode);
    vComponentClass := Designer.GetComponent(NodeData.ClassIID);
    if Assigned(vComponentClass) then vComponent := vComponentClass.Create(nil);
    Supports(vComponent, IibSHDBObject, DBObject);
    Supports(vComponent, IibSHTable, DBTable);
    Supports(vComponent, IibSHView, DBView);
    Supports(vComponent, IibSHProcedure, DBProcedure);
    
    if Assigned(DBObject) and Assigned(DDLGenerator) then
    begin
      DBObject.Caption := NodeData.Name;
      DBObject.OwnerIID := DDLCommentator.OwnerIID;
      DBObject.State := csSource;
      DDLGenerator.GetDDLText(DBObject);
      if Assigned(DBTable) or Assigned(DBView) then
      begin
        ImageIndex := Designer.GetImageIndex(IibSHField);
        for I := 0 to Pred(DBObject.Fields.Count) do
        begin
          Node := Tree.AddChild(ParentNode);
          NodeData := Tree.GetNodeData(Node);
          NodeData.ClassIID := IibSHField;
          NodeData.Name := DBObject.Fields[I];
          NodeData.ImageIndex := ImageIndex;
          NodeData.IsField    := True;
//          NodeData.IsObject   := True;
//          if Assigned(DBTable) then
//            NodeData.Description := TrimRight(DBTable.GetField(I).Description.Text);
//          if Assigned(DBView) then
//            NodeData.Description := TrimRight(DBView.GetField(I).Description.Text);
        end;
      end;

      if Assigned(DBProcedure) then
      begin
        ImageIndex := Designer.GetImageIndex(IibSHField);
        if DBProcedure.Params.Count > 0 then
        begin
          Node := Tree.AddChild(ParentNode);
          NodeData := Tree.GetNodeData(Node);
          NodeData.ClassIID := IUnknown;
          NodeData.ImageIndex := -1;
          NodeData.Name := 'Input parameters';
        end;
        for I := 0 to Pred(DBProcedure.Params.Count) do
        begin
          Node := Tree.AddChild(ParentNode);
          NodeData := Tree.GetNodeData(Node);
          NodeData.ClassIID := IibSHProcParam;
          NodeData.Name := DBProcedure.Params[I];
          NodeData.ImageIndex := ImageIndex;
          NodeData.IsField    := True;
//          NodeData.Description := TrimRight(DBProcedure.GetParam(I).Description.Text);
          NodeData.Input := True;
        end;

        ImageIndex := Designer.GetImageIndex(IibSHField);
        if DBProcedure.Returns.Count > 0 then
        begin
          Node := Tree.AddChild(ParentNode);
          NodeData := Tree.GetNodeData(Node);
          NodeData.ClassIID := IUnknown;
          NodeData.ImageIndex := -1;
          NodeData.Name := 'Output parameters';
        end;
        for I := 0 to Pred(DBProcedure.Returns.Count) do
        begin
          Node := Tree.AddChild(ParentNode);
          NodeData := Tree.GetNodeData(Node);
          NodeData.ClassIID := IibSHProcParam;
          NodeData.Name := DBProcedure.Returns[I];
          NodeData.ImageIndex := ImageIndex;
          NodeData.IsField    := True;
//          NodeData.Description := TrimRight(DBProcedure.GetReturn(I).Description.Text);
        end;
      end;
    end;
  finally
    DBObject := nil;
    DBTable := nil;
    DBView := nil;
    DBProcedure := nil;
    FreeAndNil(vComponent);
    Tree.EndUpdate;
    Screen.Cursor := crDefault;
    TreeChangeFilter
  end;
end;

function  TibSHDDLCommentatorForm.GetListObjectsWithComments(const ClassObject: TGUID):TStrings;
begin
 Result:=nil;
 if IsEqualGUID(ClassObject,IibSHDomain) then
   Result:=FDomainsWithComment
 else
 if IsEqualGUID(ClassObject,IibSHField) then
  Result:=FFieldsWithComment
 else
 if IsEqualGUID(ClassObject,IibSHTable) then
   Result:=FTablesWithComment
 else
 if IsEqualGUID(ClassObject,IibSHView) then
  Result:= FViewsWithComment
 else
 if IsEqualGUID(ClassObject,IibSHTrigger) then
   Result:= FTriggersWithComment
 else
 if IsEqualGUID(ClassObject,IibSHProcedure) then
    Result:= FProceduresWithComment
 else
 if IsEqualGUID(ClassObject,IibSHFunction) then
     Result:= FFunctionsWithComment
 else
 if IsEqualGUID(ClassObject,IibSHException) then
     Result:= FExceptionsWithComment
 else
 if IsEqualGUID(ClassObject,IibSHProcParam) then
     Result:= FProcParamsWithComment

end;

procedure TibSHDDLCommentatorForm.DoOnGetData;
var
  Node: PVirtualNode;
  vClassIID: TGUID;
  vDB:IibBTDataBaseExt;
begin
  if DDLCommentator.Mode = CommentModes[0] then vClassIID := IUnknown;        // All Objects
  if DDLCommentator.Mode = CommentModes[1] then vClassIID := IibSHDomain;     // Domains
  if DDLCommentator.Mode = CommentModes[2] then vClassIID := IibSHTable;      // Tables
  if DDLCommentator.Mode = CommentModes[3] then vClassIID := IibSHIndex;      // Indices
  if DDLCommentator.Mode = CommentModes[4] then vClassIID := IibSHView;       // Views
  if DDLCommentator.Mode = CommentModes[5] then vClassIID := IibSHProcedure;  // Procedures
  if DDLCommentator.Mode = CommentModes[6] then vClassIID := IibSHTrigger;    // Triggers
  if DDLCommentator.Mode = CommentModes[7] then vClassIID := IibSHException;  // Exceptions
  if DDLCommentator.Mode = CommentModes[8] then vClassIID := IibSHFunction;   // Functions
  if DDLCommentator.Mode = CommentModes[9] then vClassIID := IibSHFilter;     // Filters

  Tree.BeginUpdate;
  Tree.Clear;
  Editor.Clear;

  if IsEqualGUID(vClassIID, IUnknown) then
  begin
    FillTree(IibSHDomain);
    FillTree(IibSHTable);
    FillTree(IibSHIndex);
    FillTree(IibSHView);
    FillTree(IibSHProcedure);
    FillTree(IibSHTrigger);
    FillTree(IibSHException);
    FillTree(IibSHFunction);
    FillTree(IibSHFilter);
  end else
    FillTree(vClassIID);

  if Supports(DDLCommentator.BTCLDatabase,IibBTDataBaseExt,vDB) then
  begin
    if IsEqualGUID(vClassIID, IUnknown) then
    begin
      vDB.GetObjectsHaveComment(IibSHDomain,FDomainsWithComment);
      vDB.GetObjectsHaveComment(IibSHTable,FTablesWithComment);
      vDB.GetObjectsHaveComment(IibSHProcedure,FProceduresWithComment);
      vDB.GetObjectsHaveComment(IibSHTrigger,FTriggersWithComment);
      vDB.GetObjectsHaveComment(IibSHException,FExceptionsWithComment);
      vDB.GetObjectsHaveComment(IibSHView,FViewsWithComment);
      vDB.GetObjectsHaveComment(IibSHFunction,FFunctionsWithComment);
      vDB.GetObjectsHaveComment(IibSHField,FFieldsWithComment);
      vDB.GetObjectsHaveComment(IibSHProcParam,FProcParamsWithComment);

    end
    else
     vDB.GetObjectsHaveComment(vClassIID,GetListObjectsWithComments(vClassIID));
  end

     ;

  Node := Tree.GetFirst;
  if Assigned(Node) then
  begin
    Tree.FocusedNode := Node;
    Tree.Selected[Tree.FocusedNode] := True;
  end;
  Tree.EndUpdate;
  TreeChangeFilter  
end;

procedure TibSHDDLCommentatorForm.ShowSource;
var
  Node: PVirtualNode;
  NodeData, ParentNodeData: PTreeRec;
begin
  Node := Tree.FocusedNode;
  if Assigned(Node) then NodeData := Tree.GetNodeData(Node);
  if Assigned(Editor) and Assigned(NodeData) and
   not NodeData.IsDescription
  then
  begin
    if IsEqualGUID(NodeData.ClassIID, IibSHDomain) then
    begin
      TMPDomain.Caption := NodeData.Name;
      NodeData.Description := TrimRight(TMPDomain.GetDescriptionText);
      NodeData.IsDescription := True;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHTable) then
    begin
      TMPTable.Caption := NodeData.Name;
      NodeData.Description := TrimRight(TMPTable.GetDescriptionText);
      NodeData.IsDescription := True;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHIndex) then
    begin
      TMPIndex.Caption := NodeData.Name;
      NodeData.Description := TrimRight(TMPIndex.GetDescriptionText);
      NodeData.IsDescription := True;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHView) then
    begin
      TMPView.Caption := NodeData.Name;
      NodeData.Description := TrimRight(TMPView.GetDescriptionText);
      NodeData.IsDescription := True;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHProcedure) then
    begin
      TMPProcedure.Caption := NodeData.Name;
      NodeData.Description := TrimRight(TMPProcedure.GetDescriptionText);
      NodeData.IsDescription := True;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHTrigger) then
    begin
      TMPTrigger.Caption := NodeData.Name;
      NodeData.Description := TrimRight(TMPTrigger.GetDescriptionText);
      NodeData.IsDescription := True;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHException) then
    begin
      TMPException.Caption := NodeData.Name;
      NodeData.Description := TrimRight(TMPException.GetDescriptionText);
      NodeData.IsDescription := True;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHFunction) then
    begin
      TMPFunction.Caption := NodeData.Name;
      NodeData.Description := TrimRight(TMPFunction.GetDescriptionText);
      NodeData.IsDescription := True;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHFilter) then
    begin
      TMPFilter.Caption := NodeData.Name;
      NodeData.Description := TrimRight(TMPFilter.GetDescriptionText);
      NodeData.IsDescription := True;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHField) then
    begin
      TMPField.ObjectName := NodeData.Name;
      ParentNodeData := Tree.GetNodeData(Node.Parent);
      TMPField.TableName := ParentNodeData.Name;
      NodeData.Description := TrimRight(TMPField.GetDescriptionText);
      NodeData.IsDescription := True;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHProcParam) then
    begin
      TMPProcParam.ObjectName := NodeData.Name;
      ParentNodeData := Tree.GetNodeData(Node.Parent);
      TMPProcParam.TableName := ParentNodeData.Name;
      NodeData.Description := TrimRight(TMPProcParam.GetDescriptionText);
      NodeData.IsDescription := True;
    end;
  end;

if Assigned(Editor) and Assigned(NodeData)  then
begin
    Editor.BeginUpdate;
    Editor.Lines.Clear;
    Editor.Lines.Text := NodeData.Description;
    Editor.EndUpdate;
    Editor.Visible := not IsEqualGUID(NodeData.ClassIID, IUnknown);
end
end;

procedure TibSHDDLCommentatorForm.JumpToSource;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Node := Tree.FocusedNode;
  if Assigned(Node) then
  begin
    NodeData := Tree.GetNodeData(Node);
    if Assigned(NodeData) and NodeData.IsObject then
      Designer.JumpTo(Component.InstanceIID, NodeData.ClassIID, NodeData.Name);
  end;
end;

procedure TibSHDDLCommentatorForm.InternalRun(ANode: PVirtualNode);
var
  NodeData, ParentNodeData: PTreeRec;
begin
  NodeData := Tree.GetNodeData(ANode);
  if Assigned(Editor) and Editor.Modified and Assigned(NodeData) and not IsEqualGUID(NodeData.ClassIID, IUnknown) then
  begin
    NodeData.Description := Editor.Lines.Text;

    if IsEqualGUID(NodeData.ClassIID, IibSHDomain) then
    begin
      TMPDomain.Caption := NodeData.Name;
      TMPDomain.Description.Assign(Editor.Lines);
      TMPDomain.SetDescription;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHTable) then
    begin
      TMPTable.Caption := NodeData.Name;
      TMPTable.Description.Assign(Editor.Lines);
      TMPTable.SetDescription;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHIndex) then
    begin
      TMPIndex.Caption := NodeData.Name;
      TMPIndex.Description.Assign(Editor.Lines);
      TMPIndex.SetDescription;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHView) then
    begin
      TMPView.Caption := NodeData.Name;
      TMPView.Description.Assign(Editor.Lines);
      TMPView.SetDescription;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHProcedure) then
    begin
      TMPProcedure.Caption := NodeData.Name;
      TMPProcedure.Description.Assign(Editor.Lines);
      TMPProcedure.SetDescription;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHTrigger) then
    begin
      TMPTrigger.Caption := NodeData.Name;
      TMPTrigger.Description.Assign(Editor.Lines);
      TMPTrigger.SetDescription;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHException) then
    begin
      TMPException.Caption := NodeData.Name;
      TMPException.Description.Assign(Editor.Lines);
      TMPException.SetDescription;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHFunction) then
    begin
      TMPFunction.Caption := NodeData.Name;
      TMPFunction.Description.Assign(Editor.Lines);
      TMPFunction.SetDescription;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHFilter) then
    begin
      TMPFilter.Caption := NodeData.Name;
      TMPFilter.Description.Assign(Editor.Lines);
      TMPFilter.SetDescription;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHField) then
    begin
      TMPField.ObjectName := NodeData.Name;
      ParentNodeData := Tree.GetNodeData(ANode.Parent);
      TMPField.TableName := ParentNodeData.Name;
      TMPField.Description.Assign(Editor.Lines);
      TMPField.SetDescription;
    end;

    if IsEqualGUID(NodeData.ClassIID, IibSHProcParam) then
    begin
      TMPProcParam.ObjectName := NodeData.Name;
      ParentNodeData := Tree.GetNodeData(ANode.Parent);
      TMPProcParam.TableName := ParentNodeData.Name;
      TMPProcParam.Description.Assign(Editor.Lines);
      TMPProcParam.SetDescription;
    end;

    Editor.Modified := False;
  end;
end;

procedure TibSHDDLCommentatorForm.GetNextNodeForDescr(ANode: PVirtualNode);
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Node := ANode;
  NodeData := nil;
  if Assigned(Node) and DDLCommentator.GoNext then
  begin
    repeat
      if Node.ChildCount > 0 then Tree.Expanded[Node] := True;
      Node := Tree.GetNext(Node);
      if not Assigned(Node) then Break;
      
      Tree.FocusedNode := Node;
      Tree.Selected[Node] := True;
      NodeData := Tree.GetNodeData(Node);
    until Assigned(NodeData) and NodeData.IsDescription
  end;
end;

function TibSHDDLCommentatorForm.GetCanRun: Boolean;
begin
  Result := Assigned(Editor) and Editor.Modified;
end;

function TibSHDDLCommentatorForm.GetCanRefresh: Boolean;
begin
  Result := True;
end;

procedure TibSHDDLCommentatorForm.Run;
begin
  InternalRun(Tree.FocusedNode);
  GetNextNodeForDescr(Tree.FocusedNode);
end;

procedure TibSHDDLCommentatorForm.Refresh;
begin
  RefreshData;
end;

procedure TibSHDDLCommentatorForm.DoOnIdle;
begin
  Editor.ReadOnly := not Assigned(Tree.FocusedNode);
end;

function TibSHDDLCommentatorForm.DoOnOptionsChanged: Boolean;
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

{ Tree }

procedure TibSHDDLCommentatorForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHDDLCommentatorForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibSHDDLCommentatorForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if  (Kind = ikNormal) or (Kind = ikSelected) then ImageIndex := Data.ImageIndex;
end;

procedure TibSHDDLCommentatorForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if TextType = ttNormal then CellText := Data.Name;
end;

procedure TibSHDDLCommentatorForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
//var
//  Data: PTreeRec;
begin
//  Data := Sender.GetNodeData(Node);
//  if TextType = ttNormal then
//  begin
//    if (Length(Data.Description) = 0) and not IsEqualGUID(Data.ClassIID, IUnknown) then
//      if Sender.Focused and (vsSelected in Node.States) then
//        TargetCanvas.Font.Color := clWindow
//      else
//        TargetCanvas.Font.Color := clGray;
//  end;
end;

procedure TibSHDDLCommentatorForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.Name)) <> 1 then
    Result := 1;
end;

procedure TibSHDDLCommentatorForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then JumpToSource;
end;

procedure TibSHDDLCommentatorForm.TreeDblClick(Sender: TObject);
var
  HT: THitInfo;
  P: TPoint;
begin
  GetCursorPos(P);
  P := Tree.ScreenToClient(P);
  Tree.GetHitTestInfoAt(P.X, P.Y, True, HT);
  if not (hiOnItemButton in HT.HitPositions) then JumpToSource;
end;

procedure TibSHDDLCommentatorForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
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

procedure TibSHDDLCommentatorForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);
  Result := CompareStr(Data1.Name, Data2.Name);
end;

procedure TibSHDDLCommentatorForm.TreeFocusChanging(Sender: TBaseVirtualTree;
  OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
begin
  InternalRun(OldNode);
end;

procedure TibSHDDLCommentatorForm.TreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  ShowSource;
end;

procedure TibSHDDLCommentatorForm.TreeExpanding(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var Allowed: Boolean);
var
  Data: PTreeRec;
begin
  Data := Tree.GetNodeData(Node);
  if (vsHasChildren in Node.States) and not IsEqualGUID(Data.ClassIID, IUnknown) then
  begin
    FreeFields(Node);
    ExtractFields(Node);
  end;
end;

procedure TibSHDDLCommentatorForm.TreeCollapsed(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  if vsHasChildren in Node.States then
    FreeFields(Node);
end;

procedure TibSHDDLCommentatorForm.TreeChangeFilter;
var
   CurNode:PVirtualNode;
   NodeData:PTreeRec;
   ParentNodeData:PTreeRec;
   vHaveNodeList:TStrings;
begin
 with  Tree do
 begin
  BeginUpdate;
  try
   CurNode:=GetFirst;
   while CurNode<>nil do
   begin
    if (FFilterRule=frAll)  then
     IsVisible[CurNode]:=True
    else
    begin
     NodeData:=GetNodeData(CurNode);
     if not NodeData.IsObject and not NodeData.IsField then
       IsVisible[CurNode]:=True
     else
     if NodeData.IsDescription and (Length(NodeData.Description)>0) then
     //Т.е. учитываем последние изменения
       IsVisible[CurNode]:=True
     else
     begin
     // Учитываем то что отрефрешено с базы
      vHaveNodeList:=GetListObjectsWithComments(NodeData.ClassIID);
      if vHaveNodeList=nil then
        IsVisible[CurNode]:=False
      else
      if (vHaveNodeList<>FFieldsWithComment) and (vHaveNodeList<>FProcParamsWithComment)  then
        IsVisible[CurNode]:=vHaveNodeList.IndexOf(NodeData.Name)>-1
      else
      begin
        ParentNodeData := GetNodeData(CurNode.Parent);
        if Assigned(ParentNodeData) then
         IsVisible[CurNode]:=vHaveNodeList.IndexOf(
          ParentNodeData.Name+'#BT#'+NodeData.Name)>-1
      end;
     end
//     or  (CurNode.Parent=Tree.RootNode)
    end;
    CurNode:=GetNext(CurNode);
   end;
  finally
   EndUpdate;
   Invalidate
  end
 end
end;

procedure TibSHDDLCommentatorForm.chOnlyExistCommentClick(Sender: TObject);
begin
 if chOnlyExistComment.Checked then
   FFilterRule:=frHaveDescrOnly
 else
   FFilterRule:=frAll ;

 TreeChangeFilter
end;

end.
