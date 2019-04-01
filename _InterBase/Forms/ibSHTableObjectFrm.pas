unit ibSHTableObjectFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ToolWin, ComCtrls, ImgList, ActnList, StrUtils,
  SynEdit, pSHSynEdit,  AppEvnts, Menus, VirtualTrees, TypInfo;

type
  TibSHTableForm = class(TibBTComponentForm, IibSHTableForm, IibSHDDLForm)
  private
    { Private declarations }
    FDBObjectIntf: IibSHDBObject;
    FDBTableIntf: IibSHTable;
    FDBViewIntf: IibSHView;
    FDBComponent: TSHComponent;
    FDBFieldIntf: IibSHField;
    FDBConstraintIntf: IibSHConstraint;
    FDBIndexIntf: IibSHIndex;
    FDBTriggerIntf: IibSHTrigger;
    FDDLForm: TForm;
    FDDLFormIntf: IibSHDDLForm;
    FDBState: TSHDBComponentState;
    FMsgPanel: TPanel;
    FMsgPanelHeight: Integer;
    FMsgSplitter: TSplitter;
    FTree: TVirtualStringTree;

    FTMPNameList: TStrings;

    procedure SetTree(Value: TVirtualStringTree);
  protected
    procedure RefreshData; virtual;
    procedure DoOnGetData; virtual;
    procedure ClearDBComponent; virtual;
    procedure AssignDBComponent; virtual;
    procedure AfterCommit(Sender: TObject); virtual;
    procedure ShowDBComponent(AState: TSHDBComponentState); virtual;

    function GetCanDestroy: Boolean; override;

    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanPause: Boolean; override;
    function GetCanCreate: Boolean; override;
    function GetCanAlter: Boolean; override;
    function GetCanDrop: Boolean; override;
    function GetCanRecreate: Boolean; override;
    function GetCanCommit: Boolean; override;
    function GetCanRollback: Boolean; override;
    function GetCanRefresh: Boolean; override;

    procedure Run; override;
    procedure Pause; override;
    procedure ICreate; override;
    procedure Alter; override;
    procedure Drop; override;
    procedure Recreate; override;
    procedure Commit; override;
    procedure Rollback; override;
    procedure Refresh; override;

    { IibSHTableForm }
    function GetDBComponent: TSHComponent;

    { IibSHDDLForm }
    function GetDDLText: TStrings;
    procedure SetDDLText(Value: TStrings);
    function GetOnAfterRun: TNotifyEvent;
    procedure SetOnAfterRun(Value: TNotifyEvent);
    function GetOnAfterCommit: TNotifyEvent;
    procedure SetOnAfterCommit(Value: TNotifyEvent);
    function GetOnAfterRollback: TNotifyEvent;
    procedure SetOnAfterRollback(Value: TNotifyEvent);

    procedure PrepareControls;
    procedure ShowDDLText;

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
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure CreateDDLForm;

    property DBObject: IibSHDBObject read FDBObjectIntf;
    property DBTable: IibSHTable read FDBTableIntf;
    property DBView: IibSHView read FDBViewIntf;
    property DBField: IibSHField read FDBFieldIntf;
    property DBConstraint: IibSHConstraint read FDBConstraintIntf;
    property DBIndex: IibSHIndex read FDBIndexIntf;
    property DBTrigger: IibSHTrigger read FDBTriggerIntf;
    property DDLForm: IibSHDDLForm read FDDLFormIntf;
    property DBComponent: TSHComponent read FDBComponent;
    property DBState: TSHDBComponentState read FDBState write FDBState;
    property MsgPanel: TPanel read FMsgPanel write FMsgPanel;
    property MsgPanelHeight: Integer read FMsgPanelHeight write FMsgPanelHeight;
    property MsgSplitter: TSplitter read FMsgSplitter write FMsgSplitter;

    property Tree: TVirtualStringTree read FTree write SetTree;
  end;

  TibSHTableFormAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHTableFormAction_Run = class(TibSHTableFormAction_)
  end;
  TibSHTableFormAction_Pause = class(TibSHTableFormAction_)
  end;
  TibSHTableFormAction_Commit = class(TibSHTableFormAction_)
  end;
  TibSHTableFormAction_Rollback = class(TibSHTableFormAction_)
  end;
  TibSHTableFormAction_Create = class(TibSHTableFormAction_)
  end;
  TibSHTableFormAction_Alter = class(TibSHTableFormAction_)
  end;
  TibSHTableFormAction_Recreate = class(TibSHTableFormAction_)
  end;
  TibSHTableFormAction_Drop = class(TibSHTableFormAction_)
  end;
  TibSHTableFormAction_Refresh = class(TibSHTableFormAction_)
  end;

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    Number: string;
    ImageIndex: Integer;
    Name: string;
    // Field
    Constraints: string;
    DataType: string;
    Domain: string;
    DefaultExpression: string;
    NullType: string;
    Charset: string;
    Collate: string;
    ArrayDim: string;
    DomainCheck: string;
    ComputedSource: string;
    // Constraint
    ConstraintType: string;
    Fields: string;
    RefTable: string;
    RefFields: string;
    OnDelete: string;
    OnUpdate: string;
    IndexName: string;
    IndexSorting: string;
    // Index
    {Fields: string;} // redeclared
    Status: string;
    IndexType: string;
    Sorting: string;
    Statistics: string;
    Expression: string;
    // Trigger
    {Status: string;} // redeclared
    TypePrefix: string;
    TypeSuffix: string;
    Position: string;

    Description: string;
    Source: string;

    OverloadDefault: Boolean;
    OverloadNullType: Boolean;
    OverloadCollate: Boolean;
  end;

procedure Register;

implementation

uses
  ibSHConsts, ibSHSQLs, ibSHValues, ibSHStrUtil;

procedure Register;
begin
  SHRegisterImage(TibSHTableFormAction_Run.ClassName,      'Button_Run.bmp');
  SHRegisterImage(TibSHTableFormAction_Pause.ClassName,    'Button_Stop.bmp');
  SHRegisterImage(TibSHTableFormAction_Commit.ClassName,   'Button_TrCommit.bmp');
  SHRegisterImage(TibSHTableFormAction_Rollback.ClassName, 'Button_TrRollback.bmp');
  SHRegisterImage(TibSHTableFormAction_Create.ClassName,   'Button_Create.bmp');
  SHRegisterImage(TibSHTableFormAction_Alter.ClassName,    'Button_Alter.bmp');
  SHRegisterImage(TibSHTableFormAction_Recreate.ClassName, 'Button_Recreate.bmp');
  SHRegisterImage(TibSHTableFormAction_Drop.ClassName,     'Button_Drop.bmp');
  SHRegisterImage(TibSHTableFormAction_Refresh.ClassName,  'Button_Refresh.bmp');

  SHRegisterActions([
    TibSHTableFormAction_Run,
    TibSHTableFormAction_Pause,
    TibSHTableFormAction_Commit,
    TibSHTableFormAction_Rollback,
    TibSHTableFormAction_Create,
    TibSHTableFormAction_Alter,
    TibSHTableFormAction_Recreate,
    TibSHTableFormAction_Drop,
    TibSHTableFormAction_Refresh]);
end;

{ TibSHTableForm }

constructor TibSHTableForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHDBObject, FDBObjectIntf);
  Supports(Component, IibSHTable, FDBTableIntf);
  Supports(Component, IibSHView, FDBViewIntf);

  FTMPNameList := TStringList.Create;
end;

destructor TibSHTableForm.Destroy;
begin
  FDDLFormIntf := nil;
  FDDLForm.Free;

  FDBFieldIntf := nil;
  FDBConstraintIntf := nil;
  FDBIndexIntf := nil;
  FDBTriggerIntf := nil;
  FDBComponent.Free;

  FTMPNameList.Free;
  inherited Destroy;
end;

procedure TibSHTableForm.CreateDDLForm;
var
  vClassIID: TGUID;
  vComponentClass: TSHComponentClass;
  vComponentFormClass: TSHComponentFormClass;
begin
  vClassIID := IUnknown;

  if Assigned(DBTable) then
  begin
    if AnsiSameText(CallString, SCallFields) then vClassIID := IibSHField else
    if AnsiSameText(CallString, SCallConstraints) then vClassIID := IibSHConstraint else
    if AnsiSameText(CallString, SCallIndices) then vClassIID := IibSHIndex else
    if AnsiSameText(CallString, SCallTriggers) then vClassIID := IibSHTrigger;
  end;

  if Assigned(DBView) then
  begin
    if AnsiSameText(CallString, SCallTriggers) then vClassIID := IibSHTrigger;
  end;

  if not IsEqualGUID(vClassIID, IUnknown) then
  begin
    vComponentClass := Designer.GetComponent(vClassIID);
    if Assigned(vComponentClass) then
    begin
      FDBComponent := vComponentClass.Create(nil);
      Designer.Components.Remove(FDBComponent);
    end;
    Supports(DBComponent, IibSHField, FDBFieldIntf);
    Supports(DBComponent, IibSHConstraint, FDBConstraintIntf);
    Supports(DBComponent, IibSHIndex, FDBIndexIntf);
    Supports(DBComponent, IibSHTrigger, FDBTriggerIntf);

    if Assigned(DBComponent) then
    begin
      (DBComponent as IibSHDBObject).OwnerIID := DBObject.OwnerIID;
      (DBComponent as IibSHDBObject).State := csSource;
      (DBComponent as IibSHDBObject).Embedded := True;

      vComponentFormClass := Designer.GetComponentForm(VClassIID, SCallSourceDDL);
      if Assigned(vComponentFormClass) then
        FDDLForm := vComponentFormClass.Create(MsgPanel, MsgPanel, DBComponent, SCallSourceDDL);
      if Assigned(FDDLForm) then
      begin
        Supports(FDDLForm, IibSHDDLForm, FDDLFormIntf);
        DDLForm.OnAfterCommit := AfterCommit;
        FDDLForm.Show;
        Editor := GetObjectProp(FDDLForm, 'Editor') as TpSHSynEdit;
      end;
    end;
  end else
  begin
    MsgPanel.Visible := False;
    MsgSplitter.Visible := False;
  end;

  RefreshData;

  if Assigned(DBField) then MsgPanel.Height := 80;
  if Assigned(DBConstraint) then MsgPanel.Height := 100;
  if Assigned(DBIndex) then MsgPanel.Height := 100;
  if Assigned(DBTrigger) then MsgPanel.Height := MsgPanel.Parent.ClientHeight div 2;
end;

procedure TibSHTableForm.RefreshData;
begin
  try
    Screen.Cursor := crHourGlass;
    DoOnGetData;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TibSHTableForm.DoOnGetData;
begin
// override
end;

procedure TibSHTableForm.ClearDBComponent;
begin
  (DBComponent as ISHDBComponent).Caption := EmptyStr;
  (DBComponent as ISHDBComponent).ObjectName := EmptyStr;

  (DBComponent as ISHDBComponent).SourceDDL.Clear;
  (DBComponent as ISHDBComponent).AlterDDL.Clear;
  (DBComponent as ISHDBComponent).DropDDL.Clear;
  (DBComponent as ISHDBComponent).RecreateDDL.Clear;

  (DBComponent as IibSHDBObject).Fields.Clear;
  (DBComponent as IibSHDBObject).BodyText.Clear;

  if Assigned(DBField) then
  begin
    DBField.FieldTypeID := 0;
    DBField.SubTypeID := 0;
    DBField.CharsetID := 0;
    DBField.CollateID := 0;
    DBField.ArrayDimID := 0;

    DBField.DataType := EmptyStr;
    DBField.DataTypeExt := EmptyStr;
    DBField.DataTypeField := EmptyStr;
    DBField.DataTypeFieldExt := EmptyStr;
    DBField.Length := 0;
    DBField.Precision := 0;
    DBField.Scale := 0;
    DBField.NotNull := False;
    DBField.NullType := EmptyStr;
    DBField.SubType := EmptyStr;
    DBField.SegmentSize := 0;
    DBField.Charset := EmptyStr;
    DBField.Collate := EmptyStr;
    DBField.DefaultExpression.Clear;
    DBField.CheckConstraint.Clear;
    DBField.ArrayDim := EmptyStr;
    // For Fields
    DBField.Domain := EmptyStr;
    DBField.TableName := EmptyStr;
    DBField.FieldDefault.Clear;
    DBField.FieldNotNull := False;
    DBField.FieldNullType := EmptyStr;
    DBField.FieldCollateID := 0;
    DBField.FieldCollate := EmptyStr;
    DBField.ComputedSource.Clear;
    // Other (for ibSHDDLGenerator)
    DBField.UseCustomValues := False;
    DBField.NameWasChanged := False;
    DBField.DataTypeWasChanged := False;
    DBField.DefaultWasChanged := False;
    DBField.CheckWasChanged := False;
    DBField.NullTypeWasChanged := False;
    DBField.CollateWasChanged := False;

    // NEW
    DBField.Caption := 'NEW_FIELD';
    DBField.ObjectName := DBField.Caption;
    DBField.TableName := DBTable.Caption;
    DBField.DataType := Format('%s', [DataTypes[0, 1]]);
    DBField.DataTypeExt := DBField.DataType;
    DBField.DataTypeField := DBField.DataType;
    DBField.DataTypeFieldExt := DBField.DataType;
  end;

  if Assigned(DBConstraint) then
  begin
    DBConstraint.ConstraintType := EmptyStr;
    DBConstraint.TableName := EmptyStr;
    DBConstraint.ReferenceTable := EmptyStr;
    DBConstraint.ReferenceFields.Clear;
    DBConstraint.OnUpdateRule := EmptyStr;
    DBConstraint.OnDeleteRule := EmptyStr;
    DBConstraint.IndexName := EmptyStr;
    DBConstraint.IndexSorting := EmptyStr;
    DBConstraint.CheckSource.Clear;

    // NEW
    DBConstraint.Caption := 'NEW_CONSTRAINT';
    DBConstraint.ObjectName := DBConstraint.Caption;
    DBConstraint.TableName := DBTable.Caption;
  end;

  if Assigned(DBIndex) then
  begin
    DBIndex.IndexTypeID := 0;
    DBIndex.SortingID := 0;
    DBIndex.StatusID := 0;

    DBIndex.IndexType := EmptyStr;
    DBIndex.Sorting := EmptyStr;
    DBIndex.TableName := EmptyStr;
    DBIndex.Expression.Clear;
    DBIndex.Status := EmptyStr;
    DBIndex.Statistics := EmptyStr;

    // NEW
    DBIndex.Caption := 'NEW_INDEX';
    DBIndex.ObjectName := DBIndex.Caption;
    DBIndex.TableName := DBTable.Caption;
  end;

  if Assigned(DBTrigger) then
  begin
    DBTrigger.TableName := EmptyStr;
    DBTrigger.Status := EmptyStr;
    DBTrigger.TypePrefix := EmptyStr;
    DBTrigger.TypeSuffix := EmptyStr;
    DBTrigger.Position := 0;

    // NEW
    DBTrigger.Caption := 'NEW_TRIGGER';
    DBTrigger.ObjectName := DBTrigger.Caption;
    if Assigned(DBTable) then DBTrigger.TableName := DBTable.Caption;
    if Assigned(DBView) then DBTrigger.TableName := DBView.Caption;
  end;
end;

procedure TibSHTableForm.AssignDBComponent;
var
  I: Integer;
begin
  I := Tree.FocusedNode.Index;

  if Assigned(DBField) then
  begin
    DBField.Caption := DBTable.GetField(I).Caption;
    DBField.ObjectName := DBTable.GetField(I).ObjectName;

    DBField.SourceDDL.Assign(DBTable.GetField(I).SourceDDL);
    DBField.AlterDDL.Assign(DBTable.GetField(I).AlterDDL);
    DBField.DropDDL.Assign(DBTable.GetField(I).DropDDL);
    DBField.RecreateDDL.Assign(DBTable.GetField(I).RecreateDDL);

    DBField.FieldTypeID := DBTable.GetField(I).FieldTypeID;
    DBField.SubTypeID := DBTable.GetField(I).SubTypeID;
    DBField.CharsetID := DBTable.GetField(I).CharsetID;
    DBField.CollateID := DBTable.GetField(I).CollateID;
    DBField.ArrayDimID := DBTable.GetField(I).ArrayDimID;

    DBField.DataType := DBTable.GetField(I).DataType;
    DBField.DataTypeExt := DBTable.GetField(I).DataTypeExt;
    DBField.DataTypeField := DBTable.GetField(I).DataTypeField;
    DBField.DataTypeFieldExt := DBTable.GetField(I).DataTypeFieldExt;
    DBField.Length := DBTable.GetField(I).Length;
    DBField.Precision := DBTable.GetField(I).Precision;
    DBField.Scale := DBTable.GetField(I).Scale;
    DBField.NotNull := DBTable.GetField(I).NotNull;
    DBField.NullType := DBTable.GetField(I).NullType;
    DBField.SubType := DBTable.GetField(I).SubType;
    DBField.SegmentSize := DBTable.GetField(I).SegmentSize;
    DBField.Charset := DBTable.GetField(I).Charset;
    DBField.Collate := DBTable.GetField(I).Collate;
    DBField.DefaultExpression.Assign(DBTable.GetField(I).DefaultExpression);
    DBField.CheckConstraint.Assign(DBTable.GetField(I).CheckConstraint);
    DBField.ArrayDim := DBTable.GetField(I).ArrayDim;
    // For Fields
    DBField.Domain := DBTable.GetField(I).Domain;
    DBField.TableName := DBTable.GetField(I).TableName;
    DBField.FieldDefault.Assign(DBTable.GetField(I).FieldDefault);
    DBField.FieldNotNull := DBTable.GetField(I).FieldNotNull;
    DBField.FieldNullType := DBTable.GetField(I).FieldNullType;
    DBField.FieldCollateID := DBTable.GetField(I).FieldCollateID;
    DBField.FieldCollate := DBTable.GetField(I).FieldCollate;
    DBField.ComputedSource.Assign(DBTable.GetField(I).ComputedSource);
    // Other (for ibSHDDLGenerator)
    DBField.UseCustomValues := DBTable.GetField(I).UseCustomValues;
    DBField.NameWasChanged := DBTable.GetField(I).NameWasChanged;
    DBField.DataTypeWasChanged := DBTable.GetField(I).DataTypeWasChanged;
    DBField.DefaultWasChanged := DBTable.GetField(I).DefaultWasChanged;
    DBField.CheckWasChanged := DBTable.GetField(I).CheckWasChanged;
    DBField.NullTypeWasChanged := DBTable.GetField(I).NullTypeWasChanged;
    DBField.CollateWasChanged := DBTable.GetField(I).CollateWasChanged;
  end;

  if Assigned(DBConstraint) then
  begin
    DBConstraint.Caption := DBTable.GetConstraint(I).Caption;
    DBConstraint.ObjectName := DBTable.GetConstraint(I).ObjectName;

    DBConstraint.SourceDDL.Assign(DBTable.GetConstraint(I).SourceDDL);
    DBConstraint.AlterDDL.Assign(DBTable.GetConstraint(I).AlterDDL);
    DBConstraint.DropDDL.Assign(DBTable.GetConstraint(I).DropDDL);
    DBConstraint.RecreateDDL.Assign(DBTable.GetConstraint(I).RecreateDDL);

    DBConstraint.ConstraintType := DBTable.GetConstraint(I).ConstraintType;
    DBConstraint.TableName := DBTable.GetConstraint(I).TableName;
    DBConstraint.ReferenceTable := DBTable.GetConstraint(I).ReferenceTable;
    DBConstraint.ReferenceFields.Assign(DBTable.GetConstraint(I).ReferenceFields);
    DBConstraint.OnUpdateRule := DBTable.GetConstraint(I).OnUpdateRule;
    DBConstraint.OnDeleteRule := DBTable.GetConstraint(I).OnDeleteRule;
    DBConstraint.IndexName := DBTable.GetConstraint(I).IndexName;
    DBConstraint.IndexSorting := DBTable.GetConstraint(I).IndexSorting;
    DBConstraint.CheckSource.Assign(DBTable.GetConstraint(I).CheckSource);

    DBConstraint.Fields.Assign(DBTable.GetConstraint(I).Fields);
  end;

  if Assigned(DBIndex) then
  begin
    DBIndex.Caption := DBTable.GetIndex(I).Caption;
    DBIndex.ObjectName := DBTable.GetIndex(I).ObjectName;

    DBIndex.SourceDDL.Assign(DBTable.GetIndex(I).SourceDDL);
    DBIndex.AlterDDL.Assign(DBTable.GetIndex(I).AlterDDL);
    DBIndex.DropDDL.Assign(DBTable.GetIndex(I).DropDDL);
    DBIndex.RecreateDDL.Assign(DBTable.GetIndex(I).RecreateDDL);

    DBIndex.IndexTypeID := DBTable.GetIndex(I).IndexTypeID;
    DBIndex.SortingID := DBTable.GetIndex(I).SortingID;
    DBIndex.StatusID := DBTable.GetIndex(I).StatusID;

    DBIndex.IndexType := DBTable.GetIndex(I).IndexType;
    DBIndex.Sorting := DBTable.GetIndex(I).Sorting;
    DBIndex.TableName := DBTable.GetIndex(I).TableName;
    DBIndex.Expression.Assign(DBTable.GetIndex(I).Expression);
    DBIndex.Status := DBTable.GetIndex(I).Status;
    DBIndex.Statistics := DBTable.GetIndex(I).Statistics;

    DBIndex.Fields.Assign(DBTable.GetIndex(I).Fields);
  end;

  if Assigned(DBTrigger) then
  begin
    if Assigned(DBTable) then
    begin
      DBTrigger.Caption := DBTable.GetTrigger(I).Caption;
      DBTrigger.ObjectName := DBTable.GetTrigger(I).ObjectName;

      DBTrigger.SourceDDL.Assign(DBTable.GetTrigger(I).SourceDDL);
      DBTrigger.AlterDDL.Assign(DBTable.GetTrigger(I).AlterDDL);
      DBTrigger.DropDDL.Assign(DBTable.GetTrigger(I).DropDDL);
      DBTrigger.RecreateDDL.Assign(DBTable.GetTrigger(I).RecreateDDL);

      DBTrigger.TableName := DBTable.GetTrigger(I).TableName;
      DBTrigger.Status := DBTable.GetTrigger(I).Status;
      DBTrigger.TypePrefix := DBTable.GetTrigger(I).TypePrefix;
      DBTrigger.TypeSuffix := DBTable.GetTrigger(I).TypeSuffix;
      DBTrigger.Position := DBTable.GetTrigger(I).Position;

      DBTrigger.BodyText.Assign(DBTable.GetTrigger(I).BodyText);
    end;

    if Assigned(DBView) then
    begin
      DBTrigger.Caption := DBView.GetTrigger(I).Caption;
      DBTrigger.ObjectName := DBView.GetTrigger(I).ObjectName;

      DBTrigger.SourceDDL.Assign(DBView.GetTrigger(I).SourceDDL);
      DBTrigger.AlterDDL.Assign(DBView.GetTrigger(I).AlterDDL);
      DBTrigger.DropDDL.Assign(DBView.GetTrigger(I).DropDDL);
      DBTrigger.RecreateDDL.Assign(DBView.GetTrigger(I).RecreateDDL);

      DBTrigger.TableName := DBView.GetTrigger(I).TableName;
      DBTrigger.Status := DBView.GetTrigger(I).Status;
      DBTrigger.TypePrefix := DBView.GetTrigger(I).TypePrefix;
      DBTrigger.TypeSuffix := DBView.GetTrigger(I).TypeSuffix;
      DBTrigger.Position := DBView.GetTrigger(I).Position;

      DBTrigger.BodyText.Assign(DBView.GetTrigger(I).BodyText);
    end;
  end;
end;

procedure TibSHTableForm.AfterCommit(Sender: TObject);
var
  I: Integer;
  RunCommands: ISHRunCommands;
  Node: PVirtualNode;
  NodeData: PTreeRec;
  NodeIndex: Cardinal;
begin
  Pause;
//  Node := nil;
//  NodeData := nil;
  NodeIndex := 0;
  if Assigned(Tree.FocusedNode) then NodeIndex := Tree.FocusedNode.Index;

  FTMPNameList.Clear;
  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    NodeData := Tree.GetNodeData(Node);
    FTMPNameList.Add(NodeData.Name);
    Node := Tree.GetNextSibling(Node);
  end;
  (FTMPNameList as TStringList).Sort;

  for I := 0 to Pred(Component.ComponentForms.Count) do
  begin
    RunCommands := nil;
    Supports(Component.ComponentForms[I], ISHRunCommands, RunCommands);
    if AnsiSameText(TSHComponentForm(Component.ComponentForms[I]).CallString, SCallSourceDDL) then
      if Assigned(RunCommands) and RunCommands.CanRefresh then RunCommands.Refresh;
  end;

  RefreshData;

  case DBState of
    csCreate, csRecreate:
      if Assigned(DBField) then
      begin
        Node := Tree.GetLast(nil);
      end else
      begin
        Node := Tree.GetFirst;
        while Assigned(Node) do
        begin
          NodeData := Tree.GetNodeData(Node);
          if FTMPNameList.IndexOf(NodeData.Name) = -1 then Break;
          Node := Tree.GetNextSibling(Node);
        end;
      end;
    csAlter, csDrop:
      begin
        if DBState = csDrop then NodeIndex  := Pred(NodeIndex);
        Node := Tree.GetFirst;
        while Assigned(Node) do
        begin
          if Node.Index = NodeIndex then Break;
          Node := Tree.GetNextSibling(Node);
        end;
      end;
  end;

  if Assigned(Node) then
  begin
    Tree.FocusedNode := Node;
    Tree.Selected[Tree.FocusedNode] := True;
    if Tree.CanFocus then Tree.SetFocus;
  end;

  DDLForm.PrepareControls;
  MsgPanel.Height := FMsgPanelHeight;
end;

procedure TibSHTableForm.ShowDBComponent(AState: TSHDBComponentState);
begin
  DBState := AState;

  case DBState of
    csSource: Exit;
    csCreate: ClearDBComponent;
    csAlter, csDrop, csRecreate: AssignDBComponent;
  end;

  Tree.Enabled := False;

  MsgPanelHeight := MsgPanel.Height;
  if MsgPanel.Height <= (MsgPanel.Parent.ClientHeight div 2) then
    MsgPanel.Height := Trunc(MsgPanel.Parent.ClientHeight * 7/9);

  if Assigned(StatusBar) then StatusBar.Top := Self.Height;

  (DBComponent as ISHDBComponent).State := DBState;
  DDLForm.DDLText.Clear;
  (DDLForm as ISHRunCommands).Refresh;
  DDLForm.PrepareControls;

  Editor.Modified := True;
  if Editor.CanFocus then Editor.SetFocus;

//  if DBState = csCreate then
//    Designer.ShowModal(DBComponent , Format('DDL_WIZARD.%s', [AnsiUpperCase(DBComponent.Association)]));
end;

function TibSHTableForm.GetCanDestroy: Boolean;
begin
  Result := True;
  if Assigned(DDLForm) then Result := DDLForm.CanDestroy;
end;

{ ISHRunCommands }

function TibSHTableForm.GetCanRun: Boolean;
begin
  Result := Assigned(DDLForm) and (DDLForm as ISHRunCommands).CanRun;
end;

function TibSHTableForm.GetCanPause: Boolean;
begin
  Result := Assigned(DBComponent) and
            ((DBComponent as ISHDBComponent).State <> csSource);
end;

function TibSHTableForm.GetCanCreate: Boolean;
begin
  Result := Assigned(DBComponent) and Assigned(DBComponent) and
            ((DBComponent as ISHDBComponent).State = csSource);
end;

function TibSHTableForm.GetCanAlter: Boolean;
begin
  Result := Assigned(DBComponent) and Assigned(DBComponent) and Assigned(Tree.FocusedNode) and
            ((DBComponent as ISHDBComponent).State = csSource) and not GetCanPause;

  if Assigned(DBConstraint) then Result := False;
  if Assigned(DBIndex) then {override};
end;

function TibSHTableForm.GetCanDrop: Boolean;
begin
  Result := GetCanAlter;
  if Assigned(DBConstraint) then Result := Assigned(Tree.FocusedNode) and not GetCanPause;
end;

function TibSHTableForm.GetCanRecreate: Boolean;
begin
  Result := GetCanDrop;
end;

function TibSHTableForm.GetCanCommit: Boolean;
begin
  Result := Assigned(DDLForm) and (DDLForm as ISHRunCommands).CanCommit;
end;

function TibSHTableForm.GetCanRollback: Boolean;
begin
  Result := Assigned(DDLForm) and (DDLForm as ISHRunCommands).CanRollback;
end;

function TibSHTableForm.GetCanRefresh: Boolean;
begin
  Result := True;
  if Assigned(DBComponent) then Result := (DBComponent as ISHDBComponent).State = csSource;
end;

procedure TibSHTableForm.Run;
begin
  (DDLForm as ISHRunCommands).Run;
end;

procedure TibSHTableForm.Pause;
begin
  Tree.Enabled := True;
  (DBComponent as ISHDBComponent).State := csSource;
  DDLForm.PrepareControls;
  if MsgPanelHeight <> 0 then MsgPanel.Height := MsgPanelHeight;
  TreeFocusChanged(Tree, Tree.FocusedNode, 0);
end;

procedure TibSHTableForm.ICreate;
begin
  ShowDBComponent(csCreate);
end;

procedure TibSHTableForm.Alter;
begin
  ShowDBComponent(csAlter);
end;

procedure TibSHTableForm.Drop;
begin
  ShowDBComponent(csDrop);
end;

procedure TibSHTableForm.Recreate;
begin
  ShowDBComponent(csRecreate);
end;

procedure TibSHTableForm.Commit;
begin
  if Assigned(DDLForm) then (DDLForm as ISHRunCommands).Commit;
end;

procedure TibSHTableForm.Rollback;
begin
  if Assigned(DDLForm) then (DDLForm as ISHRunCommands).Rollback;
end;

procedure TibSHTableForm.Refresh;
begin
  if Assigned(DBObject) then
  begin
    DBObject.Refresh;
    RefreshData;
  end;
end;

function TibSHTableForm.GetDBComponent: TSHComponent;
begin
  Result := FDBComponent;
end;

function TibSHTableForm.GetDDLText: TStrings;
begin
  Result := nil;
  if Assigned(DDLForm) then Result := DDLForm.DDLText;
end;

procedure TibSHTableForm.SetDDLText(Value: TStrings);
begin
  if Assigned(DDLForm) then DDLForm.DDLText.Assign(Value);
end;

function TibSHTableForm.GetOnAfterRun: TNotifyEvent;
begin
end;

procedure TibSHTableForm.SetOnAfterRun(Value: TNotifyEvent);
begin
end;

function TibSHTableForm.GetOnAfterCommit: TNotifyEvent;
begin
end;

procedure TibSHTableForm.SetOnAfterCommit(Value: TNotifyEvent);
begin
end;

function TibSHTableForm.GetOnAfterRollback: TNotifyEvent;
begin
end;

procedure TibSHTableForm.SetOnAfterRollback(Value: TNotifyEvent);
begin
end;

procedure TibSHTableForm.PrepareControls;
begin
end;

procedure TibSHTableForm.ShowDDLText;
begin
  if Assigned(DDLForm) then DDLForm.ShowDDLText;
end;

{ Tree }

procedure TibSHTableForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHTableForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibSHTableForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
//var
//  Data: PTreeRec;
begin
//  Data := Sender.GetNodeData(Node);
//  if  (Kind = ikNormal) or (Kind = ikSelected) then
//  begin
//    case Column of
//      1: if Sender.GetNodeLevel(Node) = 0 then ImageIndex := Data.ImageIndex else ImageIndex := -1;
//      else
//         ImageIndex := -1;
//    end;
//  end;
end;

procedure TibSHTableForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if TextType = ttNormal then
  begin
    if Assigned(DBField) or Assigned(DBView) then
      case Column of
        0: CellText := Data.Number;
        1: CellText := Data.Name;
        2: CellText := Data.Constraints;
        3: CellText := Data.DataType;
        4: CellText := Data.Domain;
        5: CellText := Data.DefaultExpression;
        6: CellText := Data.NullType;
        7: CellText := Data.Charset;
        8: CellText := Data.Collate;
        9: CellText := Data.ArrayDim;
        10: CellText := Data.ComputedSource;
        11: CellText := Data.DomainCheck;
        12: CellText := Data.Description;
      end;

    if Assigned(DBConstraint) then
      case Column of
        0: CellText := Data.Number;
        1: CellText := Data.Name;
        2: CellText := Data.ConstraintType;
        3: CellText := Data.Fields;
        4: CellText := Data.RefTable;
        5: CellText := Data.RefFields;
        6: CellText := Data.OnDelete;
        7: CellText := Data.OnUpdate;
        8: CellText := Data.IndexName;
        9: CellText := Data.IndexSorting;
      end;

    if Assigned(DBIndex) then
      case Column of
        0: CellText := Data.Number;
        1: CellText := Data.Name;
        2:
        begin
         if Length(Data.Fields)>0 then
          CellText := Data.Fields
         else
          CellText := Data.Expression
        end;
        3: CellText := Data.Status;
        4: CellText := Data.IndexType;
        5: CellText := Data.Sorting;
        6: CellText := Data.Statistics;
      end;

    if Assigned(DBTrigger) and (Assigned(DBTable) or Assigned(DBView)) then
      case Column of
        0: CellText := Data.Number;
        1: CellText := Data.Name;
        2: CellText := Data.Status;
        3: CellText := Data.TypePrefix;
        4: CellText := Data.TypeSuffix;
        5: CellText := Data.Position;
        6: CellText := Data.Description;
      end;
  end;
end;

procedure TibSHTableForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if TextType = ttNormal then
  begin
    if Assigned(DBField) or Assigned(DBView) then
      case Column of
        0: ;// Data.Number;
        1: ;// Data.Name;
        2:;
        3: if not IsSystemDomain(Data.Domain) then
             if Sender.Focused and (vsSelected in Node.States) then
               TargetCanvas.Font.Color := clWindow
             else
               TargetCanvas.Font.Color := clGray;
        4: if IsSystemDomain(Data.Domain) then
             if Sender.Focused and (vsSelected in Node.States) then
               TargetCanvas.Font.Color := clWindow
             else
               TargetCanvas.Font.Color := clGray;
        5: if not Data.OverloadDefault then
             if Sender.Focused and (vsSelected in Node.States) then
               TargetCanvas.Font.Color := clWindow
             else
               TargetCanvas.Font.Color := clGray;
        6: if not Data.OverloadNullType then
             if Sender.Focused and (vsSelected in Node.States) then
               TargetCanvas.Font.Color := clWindow
             else
               TargetCanvas.Font.Color := clGray;
        7: if not IsSystemDomain(Data.Domain) then
             if Sender.Focused and (vsSelected in Node.States) then
               TargetCanvas.Font.Color := clWindow
             else
               TargetCanvas.Font.Color := clGray;
        8: if not Data.OverloadCollate then
             if Sender.Focused and (vsSelected in Node.States) then
               TargetCanvas.Font.Color := clWindow
             else
               TargetCanvas.Font.Color := clGray;
        9: ;// Data.ArrayDim;
        10: ;// Data.ComputedSource;
        11: if Sender.Focused and (vsSelected in Node.States) then
             TargetCanvas.Font.Color := clWindow
           else
             TargetCanvas.Font.Color := clGray;
        12: ;// Data.Description;
      end;
  end;
end;

procedure TibSHTableForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.Name)) <> 1 then
    Result := 1;
end;

procedure TibSHTableForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  if Key = VK_RETURN then ShowDBComponent(csSource);
end;

procedure TibSHTableForm.TreeDblClick(Sender: TObject);
begin
//  ShowDBComponent(csSource);
end;

procedure TibSHTableForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
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

procedure TibSHTableForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);
  Result := CompareStr(Data1.Name, Data2.Name);
end;

procedure TibSHTableForm.TreeFocusChanging(Sender: TBaseVirtualTree;
  OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
begin
  if Assigned(DBComponent) and (Tree.GetNodeLevel(NewNode) = 0) then
  begin
    Allowed := Assigned(DDLForm) and DDLForm.CanDestroy;
    if not Allowed then
    begin
      Tree.FocusedNode := OldNode;
      Tree.Selected[Tree.FocusedNode] := True;
    end else
      Pause;
  end;
end;

procedure TibSHTableForm.TreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PTreeRec;
begin
  Data := nil;
  if Assigned(Node) then
    case Tree.GetNodeLevel(Node) of
      0: Data := Tree.GetNodeData(Node);
      1: Data := Tree.GetNodeData(Node.Parent);
    end;

  if Assigned(DBComponent) and Assigned(Editor) then
  begin
    Editor.BeginUpdate;
    Editor.Lines.Clear;
    if Assigned(Data) then Editor.Lines.Text := Data.Source;
    Editor.EndUpdate;
  end;
end;

procedure TibSHTableForm.SetTree(Value: TVirtualStringTree);
begin
  FTree := Value;
  if Assigned(FTree) then
  begin
    FocusedControl := FTree;

    FTree.Images := Designer.ImageList;
    FTree.OnGetNodeDataSize := TreeGetNodeDataSize;
    FTree.OnFreeNode := TreeFreeNode;
    FTree.OnGetImageIndex := TreeGetImageIndex;
    FTree.OnGetText := TreeGetText;
    FTree.OnPaintText := TreePaintText;
    FTree.OnIncrementalSearch := TreeIncrementalSearch;
    FTree.OnDblClick := TreeDblClick;
    FTree.OnKeyDown := TreeKeyDown;
    FTree.OnGetPopupMenu := TreeGetPopupMenu;
    FTree.OnCompareNodes := TreeCompareNodes;
    FTree.OnFocusChanging := TreeFocusChanging;
    FTree.OnFocusChanged := TreeFocusChanged;
  end;
end;

{ TibSHTableFormAction_ }

constructor TibSHTableFormAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;

  if Self is TibSHTableFormAction_Run then Tag := 1;
  if Self is TibSHTableFormAction_Pause then Tag := 2;
  if Self is TibSHTableFormAction_Commit then Tag := 3;
  if Self is TibSHTableFormAction_Rollback then Tag := 4;
  if Self is TibSHTableFormAction_Create then Tag := 5;
  if Self is TibSHTableFormAction_Alter then Tag := 6;
  if Self is TibSHTableFormAction_Recreate then Tag := 7;
  if Self is TibSHTableFormAction_Drop then Tag := 8;
  if Self is TibSHTableFormAction_Refresh then Tag := 9;

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
      Caption := Format('%s', ['Stop']);
      ShortCut := TextToShortCut('Ctrl+BkSp');
    end;
    3:
    begin
      Caption := Format('%s', ['Commit']);
      ShortCut := TextToShortCut('Shift+Ctrl+C');
    end;
    4:
    begin
      Caption := Format('%s', ['Rollback']);
      ShortCut := TextToShortCut('Shift+Ctrl+R');
    end;
    5:
    begin
      Caption := Format('%s', ['Create New']);
      ShortCut := TextToShortCut('');
    end;
    6:
    begin
      Caption := Format('%s', ['Alter']);
      ShortCut := TextToShortCut('');
    end;
    7:
    begin
      Caption := Format('%s', ['Recreate']);
      ShortCut := TextToShortCut('');
    end;
    8:
    begin
      Caption := Format('%s', ['Drop']);
      ShortCut := TextToShortCut('');
    end;
    9:
    begin
      Caption := Format('%s', ['Refresh']);
      ShortCut := TextToShortCut('F5');
    end;
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibSHTableFormAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHTable) or
            IsEqualGUID(AClassIID, IibSHView) or
            IsEqualGUID(AClassIID, IibSHSystemTable) or
            IsEqualGUID(AClassIID, IibSHSystemTableTmp);
end;

procedure TibSHTableFormAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Pause
    2: (Designer.CurrentComponentForm as ISHRunCommands).Pause;
    // Commit
    3: (Designer.CurrentComponentForm as ISHRunCommands).Commit;
    // Rollback
    4: (Designer.CurrentComponentForm as ISHRunCommands).Rollback;
    // Create New
    5: (Designer.CurrentComponentForm as ISHRunCommands).Create;
    // Alter
    6: (Designer.CurrentComponentForm as ISHRunCommands).Alter;
    // Recreate
    7: (Designer.CurrentComponentForm as ISHRunCommands).Recreate;
    // Drop
    8: (Designer.CurrentComponentForm as ISHRunCommands).Drop;
    // Refresh
    9: (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
  end;
end;

procedure TibSHTableFormAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHTableFormAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     Supports(Designer.CurrentComponent, IibSHDDLInfo) and
     Supports(Designer.CurrentComponentForm, IibSHDDLForm) and
     (
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallFields) or
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallConstraints) or
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallIndices) or
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallTriggers)
     ) then
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
      // Pause
      2:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanPause;
      end;
      // Commit
      3:
      begin
        Visible := ((Designer.CurrentComponent as IibSHDDLInfo).State <> csSource) and
                   not (Designer.CurrentComponent as IibSHDDLInfo).BTCLDatabase.DatabaseAliasOptions.DDL.AutoCommit;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanCommit;
      end;
      // Rollback
      4:
      begin
        Visible := ((Designer.CurrentComponent as IibSHDDLInfo).State <> csSource) and
                   not (Designer.CurrentComponent as IibSHDDLInfo).BTCLDatabase.DatabaseAliasOptions.DDL.AutoCommit;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRollback;
      end;
      // Create New
      5:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanCreate;
      end;
      // Alter
      6:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanAlter;
      end;
      // Recreate
      7:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRecreate;
      end;
      // Drop
      8:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanDrop;
      end;
      // Refresh
      9:
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

