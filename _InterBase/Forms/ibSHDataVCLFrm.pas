unit ibSHDataVCLFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDriverIntf, ibSHDataCustomFrm, ibSHConsts,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, DBCtrls, ToolWin, ComCtrls, ExtCtrls, DB, ImgList,
  jpeg, Menus, SynEdit, TypInfo, StdCtrls, Clipbrd,
  pSHSynEdit, Grids, PrnDbgeh, DBGrids,DBGridEh, GridsEh,TntStdCtrls ;

type
  TibSHDataVCLForm = class(TibSHDataCustomForm, IibSHDataVCLForm)
    Panel6: TPanel;
    ToolBar1: TToolBar;
    DBNavigator1: TDBNavigator;
    Panel3: TPanel;
    Tree: TVirtualStringTree;
    dsTreeEditors: TDataSource;
    ImageList1: TImageList;
    Panel7: TPanel;
    pSHSynEdit2: TpSHSynEdit;
    Splitter3: TSplitter;
    PopupMenuMessage: TPopupMenu;
    pmiHideMessage: TMenuItem;
    ImageList2: TImageList;
    Panel1: TPanel;
    DBGridEh1: TDBGridEh;
    Splitter1: TSplitter;
    sdGrid: TSaveDialog;
    PrintDBGridEh1: TPrintDBGridEh;
    procedure dsTreeEditorsDataChange(Sender: TObject; Field: TField);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure pmiHideMessageClick(Sender: TObject);
    function IsDBGridSelected: Boolean;
  private
    { Private declarations }
    FQueryComponent: TSHComponent;
    FDBQueryIntf: IibSHQuery;
    FFieldExparationNotificationList: TList;

    FDDLGeneratorComponent: TSHComponent;
    FDDLGeneratorIntf: IibSHDDLGenerator;
    FCurrentField: TField;
    FAutoAdjustNodeHeight: Boolean;
    FIsCurrentNodeMultyline: Boolean;

    procedure ClearEditor;
    procedure BuildTree;
    procedure SetTreeEvents;
    procedure SetDataLinks;
    procedure GetObjects;
    function SafeDrawPicture(AField: TField; ACanvas: TCanvas; ARect: TRect): Boolean;
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
    procedure TreeEdited(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure TreeGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure TreeFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure TreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure TreeInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure TreeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TreeMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure TreePaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure TreeIncrementalSearch(Sender: TBaseVirtualTree;
      Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
    procedure TreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
      Column: TColumnIndex; var Result: Integer);
    procedure GutterDrawNotify(Sender: TObject; ALine: Integer; var ImageIndex: Integer);
    function GetTreeEditor: TWinControl;
  protected
    { Protected declarations }
    procedure ShowMessages; override;
    procedure HideMessages; override;

    { IibSHDataVCLForm }
    function GetAutoAdjustNodeHeight: Boolean;
    procedure SetAutoAdjustNodeHeight(Value: Boolean);
    function GetCanSelectNextField: Boolean;
    function GetCanSelectPreviousField: Boolean;

    procedure SelectNextField;
    procedure SelectPreviouField;

    { ISHFileCommands }
    function GetCanSave: Boolean; override;
    function GetCanSaveAs: Boolean; override;
    function GetCanPrint: Boolean; override;

    procedure Save; override;
    procedure SaveAs; override;
    procedure Print; override;

    { ISHEditCommands }
    function GetCanUndo: Boolean; override;
    function GetCanCut: Boolean; override;
    function GetCanCopy: Boolean; override;
    function GetCanPaste: Boolean; override;
    function GetCanSelectAll: Boolean; override;
    function GetCanClearAll: Boolean; override;

    procedure Undo; override;
    procedure Cut; override;
    procedure Copy; override;
    procedure Paste; override;
    procedure SelectAll; override;
    procedure ClearAll; override;

    procedure SetDBGridOptions(ADBGrid: TComponent); override;

    {ISHRunCommands}

    {ISHRunCommands}
    procedure Commit; override;
    procedure Rollback; override;
    {End ISHRunCommands}

    procedure DoRefresh(AClearMessages: Boolean); override;

    procedure DoUpdateStatusBar; override;

    {IibDRVDatasetNotification}
    procedure OnFetchRecord(ADataset: IibSHDRVDataset); override;

    function DoOnOptionsChanged: Boolean; override;
    function GetCanDestroy: Boolean; override;
    property TreeEditor: TWinControl read GetTreeEditor;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure BringToTop; override;
    property DDLGenerator: IibSHDDLGenerator read FDDLGeneratorIntf;
    property DBQuery: IibSHQuery read FDBQueryIntf;
  end;

  TibSHDataVCLToolbarAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDataVCLToolbarAction_AutoAdjustNodeHeight = class(TibSHDataVCLToolbarAction)
  end;
  TibSHDataVCLToolbarAction_NextField = class(TibSHDataVCLToolbarAction)
  end;
  TibSHDataVCLToolbarAction_PreviousField = class(TibSHDataVCLToolbarAction)
  end;

procedure Register();

var
  ibSHDataVCLForm: TibSHDataVCLForm;

implementation

uses ibSHDataVCLTreeEditors, Types, SHOptionsIntf, ActnList, ibSHMessages

;

procedure Register();
begin
  SHREgisterImage(TibSHDataVCLToolbarAction_AutoAdjustNodeHeight.ClassName, 'Button_AutoAdjustNodeHeight.bmp');
  SHREgisterImage(TibSHDataVCLToolbarAction_NextField.ClassName,            'Button_Arrow_Down.bmp');
  SHREgisterImage(TibSHDataVCLToolbarAction_PreviousField.ClassName,        'Button_Arrow_Top.bmp');
  
  SHRegisterActions([
    // Toolbar
    TibSHDataVCLToolbarAction_NextField,
    TibSHDataVCLToolbarAction_PreviousField
    {TibSHDataVCLToolbarAction_AutoAdjustNodeHeight}]);
end;

{$R *.dfm}

{ TibSHDataVCLForm }

constructor TibSHDataVCLForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  FAutoAdjustNodeHeight := True;
  DBGrid := DBGridEh1;
  ResultEdit := pSHSynEdit2;
  ResultEdit.Lines.Clear;
  ResultEdit.OnGutterDraw := GutterDrawNotify;
  ResultEdit.GutterDrawer.ImageList := ImageList2;
  ResultEdit.GutterDrawer.Enabled := True;
  HideMessages;
  CatchRunTimeOptionsDemon;
  FFieldExparationNotificationList := TList.Create;
  GetObjects;
  SetDataLinks;
  SetTreeEvents;
  CatchRunTimeOptionsDemon;
  DoOnOptionsChanged;
  BuildTree;
  FocusedControl := DBGrid;
end;

destructor TibSHDataVCLForm.Destroy;
begin
  FFieldExparationNotificationList.Free;
  FFieldExparationNotificationList:=nil;
  inherited Destroy;
end;

procedure TibSHDataVCLForm.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  if Assigned(FFieldExparationNotificationList) then
//^^^^^^^^^^^^ Необходимо!
  begin
   I:=FFieldExparationNotificationList.IndexOf(AComponent);
   if I>-1 then
     ClearEditor;
  end;
end;

procedure TibSHDataVCLForm.BringToTop;
begin
  if Assigned(Data) then
    Data.Dataset.DatasetNotification := Self as IibDRVDatasetNotification;
  inherited BringToTop;
  if FFieldExparationNotificationList.Count = 0 then
    BuildTree;
  if (Tree.TreeStates * [tsEditing] = [tsEditing]) then
    Tree.CancelEditNode;
end;

procedure TibSHDataVCLForm.dsTreeEditorsDataChange(Sender: TObject;
  Field: TField);
begin
  Tree.CancelEditNode;
  if Self.ComponentState * [csDestroying] = [] then
    Tree.Invalidate;
  if Assigned(dsTreeEditors.DataSet) then
    DoUpdateStatusBar;  
end;

procedure TibSHDataVCLForm.DBNavigator1Click(Sender: TObject;
  Button: TNavigateBtn);
begin
  if (Button = nbCancel) and (Tree.TreeStates * [tsEditing] = [tsEditing]) then
    Tree.CancelEditNode;
end;

procedure TibSHDataVCLForm.pmiHideMessageClick(Sender: TObject);
begin
  HideMessages;
end;

function TibSHDataVCLForm.IsDBGridSelected: Boolean;
var
  FEdit:TControl;
begin
 with DBGrid do
 begin
  FEdit:=GetGridWideEditor;
  Result := Focused or
            (Assigned(InplaceEditor) and InplaceEditor.Visible)
            or
            ((FEdit<>nil) and TWinControl(FEdit).Focused)
  end
            ;
end;

procedure TibSHDataVCLForm.ClearEditor;
begin
  Tree.EndEditNode;
  Tree.Clear;
  FFieldExparationNotificationList.Clear;
end;

procedure TibSHDataVCLForm.BuildTree;
var
  I: Integer;
  Node: PVirtualNode;
  NodeData: PTreeRec;
  vExcludingDB_KEY: Integer;
  vDBTable: IibSHTable;
  vFieldNo: Integer;
  procedure FillFKInfo;
  var
    I: Integer;
  begin
    for I := 0 to Pred(vDBTable.Constraints.Count) do
    begin
      if AnsiSameText(vDBTable.GetConstraint(I).ConstraintType, ConstraintTypes[2]) then
      begin
        if vDBTable.GetConstraint(I).Fields.IndexOf(NodeData.Field.FieldName) > -1 then
        begin
          NodeData.ReferenceTable := vDBTable.GetConstraint(I).ReferenceTable;
          NodeData.FKFields := vDBTable.GetConstraint(I).Fields.Text;
          NodeData.ReferenceFields := vDBTable.GetConstraint(I).ReferenceFields.Text;
          Break;
        end;
      end;
    end;
  end;
begin
  if Assigned(Data) then
  begin
    Tree.BeginUpdate;
    try
      vExcludingDB_KEY := 0;
      ClearEditor;
      DBQuery.Data := Data;
      DDLGenerator.GetDDLText(DBQuery);
      vFieldNo := 1;
      for I := 0 to Pred(Data.Dataset.Dataset.FieldCount) do
      begin
        FCurrentField := Data.Dataset.Dataset.Fields[I];
        if FCurrentField.FieldName = 'DB_KEY' then
        begin
          if Assigned(SHCLDatabase) and
            SHCLDatabase.DatabaseAliasOptions.DML.UseDB_KEY and
            (not SHCLDatabase.DatabaseAliasOptions.DML.ShowDB_KEY) then
          begin
            //vExcludingDB_KEY := 1;
            Continue;
          end;
        end;
        if FCurrentField.IsBlob or (Pos(#13#10, Trim(DBQuery.GetField(I + vExcludingDB_KEY).Description.Text)) > 0) then
          FIsCurrentNodeMultyline := True
        else
          FIsCurrentNodeMultyline := False;

        Node := Tree.AddChild(nil);
        NodeData := Tree.GetNodeData(Node);
        NodeData.DataSource := dsTreeEditors;
        NodeData.Field := Data.Dataset.Dataset.Fields[I];
        NodeData.FieldNo := vFieldNo;
        Inc(vFieldNo);
        FreeNotification(NodeData.Field);
        FFieldExparationNotificationList.Add(NodeData.Field);
        if FIsCurrentNodeMultyline then
          NodeData.IsMultiLine := True;
        NodeData.DataType := DBQuery.GetField(I + vExcludingDB_KEY).DataTypeExt;
        NodeData.DefaultExpression := Trim(DBQuery.GetField(I + vExcludingDB_KEY).DefaultExpression.Text);
        NodeData.CheckConstraint := Trim(DBQuery.GetField(I + vExcludingDB_KEY).CheckConstraint.Text);
        if FCurrentField.FieldName = 'DB_KEY' then
          NodeData.Nullable := False
        else
        begin
          NodeData.Nullable :=
           (not DBQuery.GetField(I + vExcludingDB_KEY).FieldNotNull) and
           (not DBQuery.GetField(I + vExcludingDB_KEY).NotNull){ and
           (not (FCurrentField.DataType = ftArray))};
        end;
        NodeData.Computed := Length(Trim(DBQuery.GetField(I + vExcludingDB_KEY).ComputedSource.Text)) > 0;
        NodeData.FieldDescription := Trim(DBQuery.GetField(I + vExcludingDB_KEY).Description.Text);

        {if (Length(NodeData.FieldDescription) > 0) or
           (Length(NodeData.DefaultExpression) > 0) or
           (Length(NodeData.CheckConstraint) > 0) then
        }
        if (Pos(#13#10, NodeData.FieldDescription) > 0) or
           (Pos(#13#10, NodeData.DefaultExpression) > 0) or
           (Pos(#13#10, NodeData.CheckConstraint) > 0) then
        begin
          Node.States := Node.States + [vsMultiline];
          NodeData.IsMultiLine := True;
        end;
        NodeData.Component := Component;
        if Supports(Component, IibSHTable, vDBTable) then FillFKInfo;
      end;
      FCurrentField := nil;
      Node := Tree.GetFirst;
      if Assigned(Node) then
      begin
        Tree.FocusedNode := Node;
        Tree.Selected[Tree.FocusedNode] := True;
      end;
    finally
      Tree.EndUpdate;
      Tree.Invalidate;
    end;
  end;
end;

procedure TibSHDataVCLForm.SetTreeEvents;
begin
  Tree.Images := Designer.ImageList;
  Tree.OnAfterCellPaint := TreeAfterCellPaint;
  Tree.OnBeforeCellPaint := TreeBeforeCellPaint;
  Tree.OnClick := TreeClick;
  Tree.OnCreateEditor := TreeCreateEditor;
  Tree.OnEditing := TreeEditing;
  Tree.OnEdited := TreeEdited;
  Tree.OnGetNodeDataSize := TreeGetNodeDataSize;
  Tree.OnFreeNode := TreeFreeNode;
  Tree.OnGetText := TreeGetText;
  Tree.OnInitNode := TreeInitNode;
  Tree.OnKeyDown := TreeKeyDown;
  Tree.OnMeasureItem := TreeMeasureItem;
  Tree.OnPaintText := TreePaintText;
  Tree.OnIncrementalSearch := TreeIncrementalSearch;
  Tree.OnCompareNodes := TreeCompareNodes;
end;

procedure TibSHDataVCLForm.SetDataLinks;
begin
  dsTreeEditors.DataSet := Data.Dataset.Dataset;
  DBNavigator1.DataSource := dsTreeEditors;
  if Assigned(DBGrid) then
    DBGrid.DataSource := dsTreeEditors;  
end;

procedure TibSHDataVCLForm.GetObjects;
var
  vComponentClass: TSHComponentClass;
begin
  vComponentClass := Designer.GetComponent(IibSHDDLGenerator);
  if Assigned(vComponentClass) then
  begin
    FDDLGeneratorComponent := vComponentClass.Create(nil);
    Supports(FDDLGeneratorComponent, IibSHDDLGenerator, FDDLGeneratorIntf);
  end;
  Assert(DDLGenerator <> nil, 'DDLGenerator = nil');

  vComponentClass := Designer.GetComponent(IibSHQuery);
  if Assigned(vComponentClass) then
  begin
    FQueryComponent := vComponentClass.Create(nil);
    FQueryComponent.OwnerIID := Component.OwnerIID;
    Supports(FQueryComponent, IibSHQuery, FDBQueryIntf);
    Designer.Components.Remove(FQueryComponent);
  end;
  Assert(DBQuery <> nil, 'Query = nil');
  DBQuery.State := csSource;
end;

function TibSHDataVCLForm.SafeDrawPicture(AField: TField;
  ACanvas: TCanvas; ARect: TRect): Boolean;
var
  BlobStream: TStream;
  vImageFormat: TibSHImageFormat;
  vPicture: TPicture;
  vJPEGSource: TJpegImage;
  function GetStretchedRect: TRect;
  var
    vRatioNode, vRatioGraphic: double;
  begin
    if (ARect.Bottom - ARect.Top = 0) or (vPicture.Graphic.Height = 0) then
      Result := ARect
    else
    begin
      Result.Left := ARect.Left;
      Result.Top := ARect.Top;
      vRatioNode := (ARect.Right - ARect.Left) / (ARect.Bottom - ARect.Top);
      vRatioGraphic := vPicture.Graphic.Width / vPicture.Graphic.Height;
      if vRatioNode > vRatioGraphic then
      begin
        Result.Bottom := ARect.Bottom;
        Result.Right := ARect.Left + Round((Result.Bottom - Result.Top) * vRatioGraphic);
      end
      else
      begin
        Result.Right := ARect.Right;
        Result.Bottom := ARect.Top + Round((Result.Right - Result.Left) / vRatioGraphic);
      end;
    end;
  end;
begin
  Result := False;
  if Assigned(AField) and
     AField.DataSet.Active and
     AField.IsBlob then
  begin
    BlobStream := AField.DataSet.CreateBlobStream(AField, bmRead);
    vPicture := TPicture.Create;
    try
      vImageFormat := GetImageStreamFormat(BlobStream);
      Result := vImageFormat <> imUnknown;
      if Result then
      begin
        case vImageFormat of
          imBitmap: vPicture.Bitmap.LoadFromStream(BlobStream);
          imJPEG:
            begin
              vJPEGSource := TJpegImage.Create; //Разрушиться при vPicture.Free;
              vJPEGSource.LoadFromStream(BlobStream);
              vPicture.Graphic := vJPEGSource;
            end;
          imWMF, imEMF: vPicture.Metafile.LoadFromStream(BlobStream);
          imICO: vPicture.Icon.LoadFromStream(BlobStream);
        end;
        ACanvas.StretchDraw(GetStretchedRect, vPicture.Graphic);// Draw(0,0,vPicture);
      end;
    finally
      BlobStream.Free;
      vPicture.Free;
    end;
  end;
end;

procedure TibSHDataVCLForm.TreeAfterCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
//var
//  NewRect: TRect;
//  NodeData: PTreeRec;
begin
  {
  case Column of
    0: ;
    4:
      begin
        NodeData := Tree.GetNodeData(Node);
        if NodeData.Field.FieldName <> 'DB_KEY' then
        begin
          NewRect := CellRect;
          NewRect.Left := CellRect.Left + ((CellRect.Right - CellRect.Left) div 2) - 5;
          if (Node.States * [vsMultiline] = [vsMultiline]) then
          begin
            NewRect.Top := CellRect.Top + 2;
          end
          else
          begin
            NewRect.Top := CellRect.Top + ((CellRect.Bottom - CellRect.Top) div 2) - 8;
          end;
          if Assigned(NodeData) then
          begin
            if NodeData.Field.IsNull then
              ImageList1.Draw(TargetCanvas, NewRect.Left, NewRect.Top, 1)
            else
              ImageList1.Draw(TargetCanvas, NewRect.Left, NewRect.Top, 0);
          end;
        end;
      end;
  end;
  }
end;

procedure TibSHDataVCLForm.TreeBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var
  NodeData: PTreeRec;
  IsReadOnly: Boolean;
begin
  case Column of
    0,1,2,3,4,7:
      begin
        TargetCanvas.Brush.Color := RGB(247, 247, 247);
        TargetCanvas.FillRect(CellRect);
      end;
    5:
      begin
        NodeData := Sender.GetNodeData(Node);
        if NodeData.Field.IsBlob then
          NodeData.IsPicture := SafeDrawPicture(NodeData.Field, TargetCanvas, CellRect)
        else
        begin
          IsReadOnly :=
            NodeData.Field.ReadOnly or
            (NodeData.Field.FieldName = 'DB_KEY') or
            (NodeData.Field.DataType in (ftNonTextTypes - [ftBlob, ftMemo, ftGraphic, ftFmtMemo])) or
            NodeData.Computed;
          if IsReadOnly then
          begin
            TargetCanvas.Brush.Color := RGB(247, 247, 247);
            TargetCanvas.FillRect(CellRect);
          end;
        end;
      end;
    6:
      begin
        NodeData := Sender.GetNodeData(Node);
        IsReadOnly :=
          NodeData.Field.ReadOnly or
          (NodeData.Field.FieldName = 'DB_KEY') or
          (NodeData.Field.DataType in (ftNonTextTypes - [ftBlob, ftMemo, ftGraphic, ftFmtMemo])) or
          NodeData.Computed;
        if IsReadOnly or (not NodeData.Nullable) then
        begin
          TargetCanvas.Brush.Color := RGB(247, 247, 247);
          TargetCanvas.FillRect(CellRect);
        end;
      end;
  end;
end;

procedure TibSHDataVCLForm.TreeClick(Sender: TObject);
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

procedure TibSHDataVCLForm.TreeCreateEditor(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
var
  vEditLink: TDataVCLFieldEditLink;
begin
  vEditLink := TDataVCLFieldEditLink.Create;
  Supports(vEditLink, IVTEditLink, EditLink);
end;

procedure TibSHDataVCLForm.TreeEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  NodeData: PTreeRec;
begin
  with Sender do
  begin
    NodeData := Tree.GetNodeData(Node);
    Allowed :=
      (not NodeData.Field.ReadOnly) and
      (NodeData.Field.FieldName <> 'DB_KEY') and
      (not (NodeData.Field.DataType in (ftNonTextTypes - [ftBlob, ftMemo, ftGraphic, ftFmtMemo]))) and
      (not NodeData.Computed) and
      (((Column = 6) and NodeData.Nullable)
       or
       ((Column = 5) and (not NodeData.IsPicture))
      );
  end;
end;

procedure TibSHDataVCLForm.TreeEdited(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  if Sender.ComponentState * [csDestroying] = [] then
    Sender.Invalidate;
end;

procedure TibSHDataVCLForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHDataVCLForm.TreeFreeNode(Sender: TBaseVirtualTree;
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

procedure TibSHDataVCLForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  NodeData: PTreeRec;
  IsReadOnly: Boolean;
begin
  NodeData := Sender.GetNodeData(Node);
  if Assigned(NodeData) then
    case Column of
      0: if TextType = ttNormal then CellText := IntToStr(NodeData.FieldNo);
      1: if TextType = ttNormal then CellText := NodeData.Field.FieldName;
      2: if TextType = ttNormal then CellText := NodeData.DataType;
      3: if TextType = ttNormal then CellText := NodeData.DefaultExpression;
      4: if TextType = ttNormal then CellText := NodeData.CheckConstraint;
      5:
        if ttNormal = ttNormal then
        begin
          if NodeData.Field.IsBlob and NodeData.IsPicture then
            CellText := EmptyStr
          else
          if NodeData.Field.IsNull then
            CellText := GridFormatOptions.DisplayFormats.NullValue
          else
          if (NodeData.Field.DataType in ftNonTextTypes) and
            (not (NodeData.Field.DataType in [ftBlob, ftMemo, ftGraphic, ftFmtMemo])) then
            CellText := NodeData.Field.DisplayText
          else
          begin
            if not Assigned(GridFormatOptions) then
              CellText := NodeData.Field.AsString
            else
            begin
              if NodeData.Field is TIntegerField then
                CellText := FormatFloat(GridFormatOptions.DisplayFormats.IntegerField, NodeData.Field.AsInteger)
              else
              if NodeData.Field is TFloatField then
                CellText := FormatFloat(GridFormatOptions.DisplayFormats.FloatField, NodeData.Field.AsFloat)
              else
              if NodeData.Field is TTimeField then
                CellText := FormatDateTime(GridFormatOptions.DisplayFormats.TimeField, NodeData.Field.AsDateTime)
              else
              if NodeData.Field is TDateField then
                CellText := FormatDateTime(GridFormatOptions.DisplayFormats.DateField, NodeData.Field.AsDateTime)
              else
              if NodeData.Field is TDateTimeField then
                CellText := FormatDateTime(GridFormatOptions.DisplayFormats.DateTimeField, NodeData.Field.AsDateTime)
              else
              if NodeData.Field is TWideStringField then
               CellText := TWideStringField(NodeData.Field).Value
              else
                CellText := NodeData.Field.AsString;
            end;
          end;
        end;
      6: if TextType = ttNormal then
         begin
           IsReadOnly :=
             NodeData.Field.ReadOnly or
             (NodeData.Field.FieldName = 'DB_KEY') or
             (NodeData.Field.DataType in (ftNonTextTypes - [ftBlob, ftMemo, ftGraphic, ftFmtMemo])) or
             NodeData.Computed;
           if NodeData.Nullable then
           begin
             if NodeData.Field.IsNull or IsReadOnly then
               CellText := EmptyStr
             else
               CellText := Format('%s', ['[...]'])
           end
           else
             CellText := Format('%s', ['NOT NULL']);
         end;
      7: if TextType = ttNormal then CellText := NodeData.FieldDescription;
    end;
end;

procedure TibSHDataVCLForm.TreeInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  NodeData: PTreeRec;
begin
  NodeData := Sender.GetNodeData(Node);
  if NodeData.IsMultiLine then
  begin
    if NodeData.Field.IsBlob then
      Tree.NodeHeight[Node] := 100
    else
      Tree.NodeHeight[Node] := 42;
    Include(InitialStates, ivsMultiline);
  end
  else
    Tree.NodeHeight[Node] := 21;
end;

procedure TibSHDataVCLForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
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

procedure TibSHDataVCLForm.TreeMeasureItem(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
var
  NodeData: PTreeRec;
begin
    if Sender.MultiLine[Node] then
    begin
      if FAutoAdjustNodeHeight then
      begin
        NodeData := Sender.GetNodeData(Node);
        if NodeData.Field.IsBlob then
          NodeHeight := 100
        else
          NodeHeight := 42;
      end
      else
        NodeHeight := 100;
    end
    else
    begin
      NodeHeight := 21;
    end;
end;

procedure TibSHDataVCLForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  NodeData: PTreeRec;
begin
  if Assigned(Node) then
    case Column of
      5:
        if TextType = ttNormal then
          if Sender.Focused and (vsSelected in Node.States) then
            TargetCanvas.Font.Color := clWindow
          else
          begin
            NodeData := Sender.GetNodeData(Node);
            if NodeData.Field.IsNull then
              TargetCanvas.Font.Color := NullValueColor;
          end;
    end;
end;

procedure TibSHDataVCLForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.Field.FieldName)) <> 1 then Result := 1;
end;

procedure TibSHDataVCLForm.TreeCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  Result := CompareStr(Data1.Field.FieldName, Data2.Field.FieldName);
end;

procedure TibSHDataVCLForm.GutterDrawNotify(Sender: TObject;
  ALine: Integer; var ImageIndex: Integer);
begin
  if ALine = 0 then ImageIndex := 1;
end;

function TibSHDataVCLForm.GetTreeEditor: TWinControl;
var
  vTreeEditor: ISHTreeEditor;
begin
  if Supports(Tree.EditLink, ISHTreeEditor, vTreeEditor) then
    Result := vTreeEditor.GetEditor
  else
    Result := nil;
end;

procedure TibSHDataVCLForm.ShowMessages;
begin
  Panel7.Visible := True;
  Splitter3.Visible := True;
end;

procedure TibSHDataVCLForm.HideMessages;
begin
  Panel7.Visible := False;
  Splitter3.Visible := False;
end;

function TibSHDataVCLForm.GetAutoAdjustNodeHeight: Boolean;
begin
  Result := FAutoAdjustNodeHeight;
end;

procedure TibSHDataVCLForm.SetAutoAdjustNodeHeight(Value: Boolean);
begin
  FAutoAdjustNodeHeight := Value;
  Tree.ReinitNode(nil, True);
  Tree.Invalidate;
end;

function TibSHDataVCLForm.GetCanSelectNextField: Boolean;
begin
  Result := Assigned(Tree.FocusedNode) and
    Assigned(Tree.FocusedNode.NextSibling);
end;

function TibSHDataVCLForm.GetCanSelectPreviousField: Boolean;
begin
  Result := Assigned(Tree.FocusedNode) and
    Assigned(Tree.FocusedNode.PrevSibling);
end;

procedure TibSHDataVCLForm.SelectNextField;
begin
  if GetCanSelectNextField then
  begin
    Tree.FocusedNode := Tree.FocusedNode.NextSibling;
    Tree.Selected[Tree.FocusedNode] := True;
  end;
end;

procedure TibSHDataVCLForm.SelectPreviouField;
begin
  if GetCanSelectPreviousField then
  begin
    Tree.FocusedNode := Tree.FocusedNode.PrevSibling;
    Tree.Selected[Tree.FocusedNode] := True;
  end;
end;

function TibSHDataVCLForm.GetCanSave: Boolean;
begin
  Result := IsDBGridSelected and
    Assigned(SHCLDatabase) and (not SHCLDatabase.WasLostConnect) and
    Assigned(Data) and Data.Dataset.Active;
end;

function TibSHDataVCLForm.GetCanSaveAs: Boolean;
begin
  Result := GetCanSave;
end;

function TibSHDataVCLForm.GetCanPrint: Boolean;
begin
  Result := IsDBGridSelected and GetCanSave;
end;

procedure TibSHDataVCLForm.Save;
begin
  SaveAs;
end;

procedure TibSHDataVCLForm.SaveAs;
var
  // For grid saving
  vDataSaver: ISHDataSaver;
  vServerOptions: IibSHServerOptions;
  I, J: Integer;
  vFilter: string;
  vFileName: string;
  vInputExt: string;
  vExt: TStringList;
  vSaved: Boolean;
begin
  if GetCanSaveAs then
    if IsDBGridSelected then
    begin
      vFilter := '';
      vExt := TStringList.Create;
      try
        for I := Pred(Designer.Components.Count) downto 0 do
          if Supports(Designer.Components[I], ISHDataSaver, vDataSaver) then
            for J := 0 to Pred(vDataSaver.SupportsExtentions.Count) do
            begin
              if vExt.IndexOf(vDataSaver.SupportsExtentions[J]) = -1 then
              begin
                vExt.Add(vDataSaver.SupportsExtentions[J]);
                vFilter := vFilter +
                  Format(SExportExtentionTemplate,
                    [vDataSaver.ExtentionDescriptions[J],
                     vDataSaver.SupportsExtentions[J],
                     vDataSaver.SupportsExtentions[J]]) + '|';
              end;
            end;

        if Length(vFilter) > 0 then
        begin
          Delete(vFilter, Length(vFilter), 1);
          sdGrid.Filter := vFilter;
    (* dk: заремил 27.06.2004 по причине сноса проперти DatabaseAliaOptions.Paths
          if Supports(Designer.GetOptions(ISHSystemOptions), ISHSystemOptions, vSystemOptions) then
            sdGrid.InitialDir := BTCLDatabase.DatabaseAliasOptions.Paths.ForExtracts;
    *)
          if IsEqualGUID(Component.BranchIID, IibSHBranch) then
            Supports(Designer.GetOptions(IibSHServerOptions), IibSHServerOptions, vServerOptions)
          else
          if IsEqualGUID(Component.BranchIID, IfbSHBranch) then
            Supports(Designer.GetOptions(IfbSHServerOptions), IibSHServerOptions, vServerOptions);
          if Assigned(vServerOptions) then
            sdGrid.FilterIndex := vServerOptions.SaveResultFilterIndex;

          if sdGrid.Execute then
          begin
            vFileName := sdGrid.FileName;
            vInputExt := ExtractFileExt(sdGrid.FileName);
            if not SameText(vInputExt, vExt[sdGrid.FilterIndex - 1]) then
              vFileName := ChangeFileExt(vFileName, vExt[sdGrid.FilterIndex - 1]);
            vSaved := False;
            for I := Pred(Designer.Components.Count) downto 0 do
              if Supports(Designer.Components[I], ISHDataSaver, vDataSaver) then
              begin
                if vDataSaver.SupportsExtentions.IndexOf(vInputExt) <> -1 then
                begin
                  vDataSaver.SaveToFile(Component, Data.Dataset.Dataset, DBGridEh1, vFileName);
                  vSaved := True;
                  Break;
                end;
              end;
            if vSaved and Assigned(vServerOptions) then
            begin
              vServerOptions.SaveResultFilterIndex := sdGrid.FilterIndex;
            end;
          end;
        end
        else
          Designer.ShowMsg(SNoExportersRegisted, mtWarning);
      finally
        vExt.Free;
      end;
    end
end;

procedure TibSHDataVCLForm.Print;
begin
  if GetCanPrint then
    if IsDBGridSelected then
      PrintDBGridEh1.Preview;
end;

function TibSHDataVCLForm.GetCanUndo: Boolean;
begin
  if IsDBGridSelected then
    Result := False
  else
    Result := Assigned(TreeEditor) and (TreeEditor.InheritsFrom(TCustomEdit)) and
      (TreeEditor as TCustomEdit).CanUndo;
end;

function TibSHDataVCLForm.GetCanCut: Boolean;
var
  NodeData: PTreeRec;
begin
  if IsDBGridSelected then
  begin
    Result:=inherited GetCanCut;
  end
  else
  begin
    Result := ([tsEditing, tsEditPending] * Tree.TreeStates <> []) and
      Assigned(TreeEditor) and (TreeEditor.InheritsFrom(TCustomEdit)) and
      (Length((TreeEditor as TCustomEdit).SelText) > 0) and
      Assigned(Tree.FocusedNode);
    if Result then
    begin
      NodeData := Tree.GetNodeData(Tree.FocusedNode);
      Result := Assigned(NodeData) and (not NodeData.Field.ReadOnly);
    end;
  end;
end;

function TibSHDataVCLForm.GetCanCopy: Boolean;
begin
  if IsDBGridSelected then
  begin
    Result:= inherited GetCanCopy
  end
  else
  begin
    Result := Assigned(TreeEditor) and (TreeEditor.InheritsFrom(TCustomEdit)) and
      (Length((TreeEditor as TCustomEdit).SelText) > 0);
  end;
end;

function TibSHDataVCLForm.GetCanPaste: Boolean;
var
  NodeData: PTreeRec;

begin

  try
//    Result := Length(Clipboard.AsText) > 0;
//    if Result then
      if IsDBGridSelected then
      begin
        Result:= inherited GetCanPaste
      end
      else
      begin
        Result := ([tsEditing, tsEditPending] * Tree.TreeStates <> []) and
          Assigned(TreeEditor) and (TreeEditor.InheritsFrom(TCustomEdit)) and
          Assigned(Tree.FocusedNode);
        if Result then
        begin
          NodeData := Tree.GetNodeData(Tree.FocusedNode);
          Result := Assigned(NodeData) and (not NodeData.Field.ReadOnly);
          Result := Result and IsClipboardFormatAvailable(CF_TEXT);
        end;
      end;
  except
    Result := False;
  end;
end;

function TibSHDataVCLForm.GetCanSelectAll: Boolean;
begin
  if IsDBGridSelected then
    Result := (Assigned(SHCLDatabase) and (not SHCLDatabase.WasLostConnect) and
              Assigned(Data) and Data.Dataset.Active)
  else
    Result := Assigned(TreeEditor) and (TreeEditor.InheritsFrom(TCustomEdit));
end;

function TibSHDataVCLForm.GetCanClearAll: Boolean;
var
  NodeData: PTreeRec;
begin
  if IsDBGridSelected then
    Result := False
  else
  begin
    Result := ([tsEditing, tsEditPending] * Tree.TreeStates <> []) and
      Assigned(TreeEditor) and (TreeEditor.InheritsFrom(TCustomEdit)) and
      Assigned(Tree.FocusedNode);
    if Result then
    begin
      NodeData := Tree.GetNodeData(Tree.FocusedNode);
      Result := Assigned(NodeData) and (not NodeData.Field.ReadOnly);
    end;
  end;
end;

procedure TibSHDataVCLForm.Undo;
begin
  if GetCanUndo then
    if IsDBGridSelected then
      DBGrid.InplaceEditor.Undo
    else
      (TreeEditor as TCustomEdit).Undo;
end;

procedure TibSHDataVCLForm.Cut;
begin
  if GetCanCut then
    if IsDBGridSelected then
    begin
      inherited
    end
    else
      TreeEditor.Perform(WM_CUT, 0, 0);
end;

procedure TibSHDataVCLForm.Copy;
begin
  if GetCanCopy then
    if IsDBGridSelected then
    begin
      inherited;
    end
    else
      TreeEditor.Perform(WM_COPY, 0, 0);
end;

procedure TibSHDataVCLForm.Paste;
begin
  if GetCanPaste then
    if IsDBGridSelected then
     inherited 
    else
     TreeEditor.Perform(WM_PASTE, 0, 0);
end;

procedure TibSHDataVCLForm.SelectAll;
begin
  if GetCanSelectAll then
    if IsDBGridSelected then
    begin
      if Assigned(DBGrid) and Assigned(DBGrid.InplaceEditor) and DBGrid.InplaceEditor.Visible then
        DBGrid.InplaceEditor.SelectAll
      else
        DBGridEh1.Selection.SelectAll;
    end
    else
      (TreeEditor as TCustomEdit).SelectAll;
end;

procedure TibSHDataVCLForm.ClearAll;
begin
  if GetCanClearAll then
    (TreeEditor as TCustomEdit).Clear;
end;

procedure TibSHDataVCLForm.SetDBGridOptions(ADBGrid: TComponent);
var
  vDBGrid: TDBGridEh;
begin
  inherited SetDBGridOptions(ADBGrid);
  if Assigned(ADBGrid) then
  begin
    if ADBGrid is TDBGridEh then
    begin
      vDBGrid := TDBGridEh(ADBGrid);
      vDBGrid.Options := vDBGrid.Options - [dgCancelOnExit];
    end;
  end;
end;

procedure TibSHDataVCLForm.Commit;
begin
  Tree.EndEditNode;
  inherited Commit;
end;

procedure TibSHDataVCLForm.Rollback;
begin
  Tree.EndEditNode;
  inherited Rollback;
end;

procedure TibSHDataVCLForm.DoRefresh(AClearMessages: Boolean);
begin
  ClearEditor;
  inherited DoRefresh(AClearMessages);
  BuildTree;
end;


procedure TibSHDataVCLForm.DoUpdateStatusBar;
begin
  if Assigned(StatusBar) and (StatusBar.Panels.Count > 1) then
  begin
    if Assigned(SHCLDatabase) and (not SHCLDatabase.WasLostConnect) then
    begin
      if Assigned(dsTreeEditors.DataSet) then
      begin
        StatusBar.Panels[0].Text := ' ' + GetEnumName(TypeInfo(TDataSetState), Integer(dsTreeEditors.DataSet.State));
        if dsTreeEditors.DataSet.State = dsBrowse then
          StatusBar.Panels[1].Text :=
          Format(' Records fetched: %s; Current record: %s',
            [FormatFloat('###,###,###,##0', dsTreeEditors.DataSet.RecordCount),
             FormatFloat('###,###,###,##0', dsTreeEditors.DataSet.RecNo)]);
      end;
    end
    else
    begin
      StatusBar.Panels[0].Text := '';
      StatusBar.Panels[1].Text := '';
    end;
  end;
end;

procedure TibSHDataVCLForm.OnFetchRecord(ADataset: IibSHDRVDataset);
begin
  if EnabledFetchEvent then
  begin
    if Assigned(SHCLDatabase) and (not SHCLDatabase.WasLostConnect) then
    begin
      DoUpdateStatusBar;
      Application.ProcessMessages;
      Designer.UpdateActions;
      if Assigned(SHCLDatabase) and (SHCLDatabase.WasLostConnect) then
      begin
        Data.Dataset.IsFetching := False;
        Exit;
      end;
    end
    else
      if Assigned(SHCLDatabase) and (SHCLDatabase.WasLostConnect) then
        Data.Dataset.IsFetching := False;
  end;
end;

function TibSHDataVCLForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
  if Result then
    ApplyGridFormatOptions(nil);
  if Self.ComponentState * [csDestroying] = [] then
    Tree.Invalidate;
end;

function TibSHDataVCLForm.GetCanDestroy: Boolean;
begin
  Tree.EndEditNode;
  Result := True;
  if Supports(Component, IibSHSQLEditor) then
  begin
    if (not Designer.ExistsComponent(Component, SCallQueryResults)) and
      (not Designer.ExistsComponent(Component, SCallDataBLOB)) then
      Result := inherited GetCanDestroy;
  end
  else
  begin
    if (not Designer.ExistsComponent(Component, SCallData)) and
      (not Designer.ExistsComponent(Component, SCallDataBLOB)) then
      Result := inherited GetCanDestroy;
  end;
end;

{ TibSHDataVCLToolbarAction }

constructor TibSHDataVCLToolbarAction.Create(AOwner: TComponent);
begin
//IibSHDataVCLForm
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  if Self.InheritsFrom(TibSHDataVCLToolbarAction_AutoAdjustNodeHeight) then Tag := 1;
  if Self.InheritsFrom(TibSHDataVCLToolbarAction_NextField) then Tag := 2;
  if Self.InheritsFrom(TibSHDataVCLToolbarAction_PreviousField) then Tag := 3;

  case Tag of
    1:
      begin
        Caption := Format('%s', ['Auto Adjust Node Height']);
        AutoCheck := True;
      end;
    2:
      begin
        Caption := Format('%s', ['Next Field']);
        ShortCut := TextToShortCut('Alt+Down')
      end;
    3:
      begin
        Caption := Format('%s', ['Previous Field']);
        ShortCut := TextToShortCut('Alt+Up')
      end;
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibSHDataVCLToolbarAction.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHTable) or
            IsEqualGUID(AClassIID, IibSHSystemTable) or
            IsEqualGUID(AClassIID, IibSHView) or
            IsEqualGUID(AClassIID, IibSHSQLEditor);
end;

procedure TibSHDataVCLToolbarAction.EventExecute(Sender: TObject);
begin
  case Tag of
    // AutoAdjustNodeHeight
    1: (Designer.CurrentComponentForm as IibSHDataVCLForm).AutoAdjustNodeHeight := Checked;
    2: (Designer.CurrentComponentForm as IibSHDataVCLForm).SelectNextField;
    3: (Designer.CurrentComponentForm as IibSHDataVCLForm).SelectPreviouField;
  end;
end;

procedure TibSHDataVCLToolbarAction.EventHint(var HintStr: String;
  var CanShow: Boolean);
begin
end;

procedure TibSHDataVCLToolbarAction.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallDataForm) then
  begin
    case Tag of
      // Separator
      0: ;
      // AutoAdjustNodeHeight
      1:
        begin
          Checked := (Designer.CurrentComponentForm as IibSHDataVCLForm).AutoAdjustNodeHeight;
          Visible := True;
        end;
      2:
        begin
          Enabled := (Designer.CurrentComponentForm as IibSHDataVCLForm).CanSelectNextField;
          Visible := True;
        end;
      3:
        begin
          Enabled := (Designer.CurrentComponentForm as IibSHDataVCLForm).CanSelectPreviousField;
          Visible := True;
        end;
    end;
  end else
    Visible := False;
end;


initialization

  Register();
finalization

end.

