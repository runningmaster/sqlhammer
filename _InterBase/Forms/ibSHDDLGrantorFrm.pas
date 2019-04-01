unit ibSHDDLGrantorFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, VirtualTrees, Menus, AppEvnts,
  ActnList, ImgList, StdCtrls;

type
  TibSHDDLGrantorForm = class(TibBTComponentForm, IibSHDDLGrantorForm)
    Panel3: TPanel;
    Panel4: TPanel;
    Panel1: TPanel;
    PrivilegesForTree: TVirtualStringTree;
    Splitter1: TSplitter;
    Panel2: TPanel;
    GrantsOnTree: TVirtualStringTree;
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    RadioGroup2: TRadioGroup;
    CheckBoxSelect: TCheckBox;
    CheckBoxDelete: TCheckBox;
    CheckBoxUpdate: TCheckBox;
    CheckBoxInsert: TCheckBox;
    CheckBoxReference: TCheckBox;
    CheckBoxExecute: TCheckBox;
    CheckBoxGrantOption: TCheckBox;
    Bevel1: TBevel;
    Panel7: TPanel;
    ProgressBar1: TProgressBar;
    Panel5: TPanel;
    Bevel2: TBevel;
    procedure Panel7Resize(Sender: TObject);
  private
    { Private declarations }
    FDDLGrantorIntf: IibSHDDLGrantor;
    FDDLGenerator: TComponent;
    FDDLGeneratorIntf: IibSHDDLGenerator;
    FImgGrant: Integer;
    FImgGrantWGO: Integer;
    FCtrlDown: Boolean;
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
    procedure TreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeDblClick(Sender: TObject);
    procedure TreeGetPopupMenu(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
      var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure TreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
      Column: TColumnIndex; var Result: Integer);
    procedure TreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure TreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
    procedure TreeExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
    procedure TreeCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);

    function GetWGO(const AClassIID: TGUID): Boolean;
    procedure DoOnDblClick(AIndex: Integer);
    procedure SetTreeEvents(ATree: TVirtualStringTree);
    procedure RebuildPrivilegesForTree; overload;
    procedure RebuildPrivilegesForTree(AClassIID: TGUID); overload;
    procedure RebuildGrantsOnTree; overload;
    procedure RebuildGrantsOnTree(AClassIID: TGUID); overload;
    procedure ExtractGrants;
    function ConvertImageIndex(const AIndex: Integer): Integer;
    procedure ExtractFields(ParentNode: PVirtualNode);
    procedure FreeFields(ParentNode: PVirtualNode);
    //IibSHGrantManagerForm
    procedure RefreshPrivilegesForTree;
    procedure RefreshGrantsOnTree;
  protected
    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanRefresh: Boolean; override;
    procedure Run; override;
    procedure Refresh; override;

    procedure SetStatusBar(Value: TStatusBar); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure ServeNode(ANode: PVirtualNode);

    property DDLGrantor: IibSHDDLGrantor read FDDLGrantorIntf;
    property DDLGenerator: IibSHDDLGenerator read FDDLGeneratorIntf;
  end;

var
  ibSHDDLGrantorForm: TibSHDDLGrantorForm;

implementation

uses
  ibSHConsts, ibSHValues;

{$R *.dfm}

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    NormalText: string;
    StaticText: string;
    ClassIID: TGUID;
    ImageIndex: Integer;
  end;

{ TibSHDDLGrantorForm }

constructor TibSHDDLGrantorForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  FImgGrant := Designer.GetImageIndex(IibSHGrant);
  FImgGrantWGO := Designer.GetImageIndex(IibSHGrantWGO);
  Supports(Component, IibSHDDLGrantor, FDDLGrantorIntf);
  vComponentClass := Designer.GetComponent(IibSHDDLGenerator);
  if Assigned(vComponentClass) then
  begin
    FDDLGenerator := vComponentClass.Create(nil);
    Supports(FDDLGenerator, IibSHDDLGenerator, FDDLGeneratorIntf);
  end;
  Panel7.Visible := False;
  SetTreeEvents(PrivilegesForTree);
  SetTreeEvents(GrantsOnTree);
  Refresh;
  FocusedControl := PrivilegesForTree;
end;

destructor TibSHDDLGrantorForm.Destroy;
begin
  FDDLGeneratorIntf := nil;
  FDDLGenerator.Free;
  inherited Destroy;
end;

function TibSHDDLGrantorForm.GetWGO(const AClassIID: TGUID): Boolean;
begin
  Result := False;
  if IsEqualGUID(AClassIID, IibSHRole) or IsEqualGUID(AClassIID, IibSHUser) then
    Result := FCtrlDown;
end;

procedure TibSHDDLGrantorForm.DoOnDblClick(AIndex: Integer);
var
  HT: THitInfo;
  P: TPoint;
  DataP, DataG, DataGParent: PTreeRec;
begin
  DataP := nil;
  DataG := nil;
  DataGParent := nil;

  if Assigned(PrivilegesForTree.FocusedNode) then
    DataP := PrivilegesForTree.GetNodeData(PrivilegesForTree.FocusedNode);

  if Assigned(GrantsOnTree.FocusedNode) then
  begin
    DataG := GrantsOnTree.GetNodeData(GrantsOnTree.FocusedNode);
    if Assigned(GrantsOnTree.FocusedNode.Parent) then
      DataGParent := GrantsOnTree.GetNodeData(GrantsOnTree.FocusedNode.Parent);
  end;

  if (AIndex = 0) and Assigned(DataP) then
  begin
    GetCursorPos(P);
    P := PrivilegesForTree.ScreenToClient(P);
    PrivilegesForTree.GetHitTestInfoAt(P.X, P.Y, True, HT);
    if not IsEqualGUID(DataP.ClassIID, IibSHUser) then
      Designer.JumpTo(Component.InstanceIID, DataP.ClassIID, DataP.NormalText);
  end;

  if (AIndex = 1) and Assigned(DataP) and Assigned(DataG) then
  begin
    GetCursorPos(P);
    P := GrantsOnTree.ScreenToClient(P);
    GrantsOnTree.GetHitTestInfoAt(P.X, P.Y, True, HT);
    case GrantsOnTree.GetNodeLevel(GrantsOnTree.FocusedNode) of
      0: begin
           case HT.HitColumn of
             0: if not (hiOnItemButton in HT.HitPositions) then
                  Designer.JumpTo(Component.InstanceIID, DataG.ClassIID, DataG.NormalText);
             1: if not IsEqualGUID(DataG.ClassIID, IibSHProcedure) then
                  case DDLGrantor.GetGrantSelectIndex(DataG.NormalText) of
                   -1: DDLGrantor.GrantTable(DataP.ClassIID, 'SELECT', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                    0: if FCtrlDown then
                       begin
                         DDLGrantor.RevokeTable(DataP.ClassIID, 'SELECT', DataG.NormalText, DataP.NormalText, False);
                         if IsEqualGUID(DataP.ClassIID, IibSHRole) or IsEqualGUID(DataP.ClassIID, IibSHUser) then
                           DDLGrantor.GrantTable(DataP.ClassIID, 'SELECT', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                       end else
                         DDLGrantor.RevokeTable(DataP.ClassIID, 'SELECT', DataG.NormalText, DataP.NormalText, False);
                    1: DDLGrantor.RevokeTable(DataP.ClassIID, 'SELECT', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                  end;
             2: if not IsEqualGUID(DataG.ClassIID, IibSHProcedure) then
                  case DDLGrantor.GetGrantDeleteIndex(DataG.NormalText) of
                   -1: DDLGrantor.GrantTable(DataP.ClassIID, 'DELETE', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                    0: if FCtrlDown then
                       begin
                         DDLGrantor.RevokeTable(DataP.ClassIID, 'DELETE', DataG.NormalText, DataP.NormalText, False);
                         if IsEqualGUID(DataP.ClassIID, IibSHRole) or IsEqualGUID(DataP.ClassIID, IibSHUser) then
                           DDLGrantor.GrantTable(DataP.ClassIID, 'DELETE', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                       end else
                         DDLGrantor.RevokeTable(DataP.ClassIID, 'DELETE', DataG.NormalText, DataP.NormalText, False);
                    1: DDLGrantor.RevokeTable(DataP.ClassIID, 'DELETE', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                  end;
             3: if not IsEqualGUID(DataG.ClassIID, IibSHProcedure) then
                  case DDLGrantor.GetGrantInsertIndex(DataG.NormalText) of
                   -1: DDLGrantor.GrantTable(DataP.ClassIID, 'INSERT', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                    0: if FCtrlDown then
                       begin
                         DDLGrantor.RevokeTable(DataP.ClassIID, 'INSERT', DataG.NormalText, DataP.NormalText, False);
                         if IsEqualGUID(DataP.ClassIID, IibSHRole) or IsEqualGUID(DataP.ClassIID, IibSHUser) then
                           DDLGrantor.GrantTable(DataP.ClassIID, 'INSERT', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                       end else
                         DDLGrantor.RevokeTable(DataP.ClassIID, 'INSERT', DataG.NormalText, DataP.NormalText, False);
                    1: DDLGrantor.RevokeTable(DataP.ClassIID, 'INSERT', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                  end;
             4: if not IsEqualGUID(DataG.ClassIID, IibSHProcedure) then
                  case DDLGrantor.GetGrantUpdateIndex(DataG.NormalText) of
                   -1: DDLGrantor.GrantTable(DataP.ClassIID, 'UPDATE', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                    0: if FCtrlDown then
                       begin
                         DDLGrantor.RevokeTable(DataP.ClassIID, 'UPDATE', DataG.NormalText, DataP.NormalText, False);
                         if IsEqualGUID(DataP.ClassIID, IibSHRole) or IsEqualGUID(DataP.ClassIID, IibSHUser) then
                           DDLGrantor.GrantTable(DataP.ClassIID, 'UPDATE', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                       end else
                         DDLGrantor.RevokeTable(DataP.ClassIID, 'UPDATE', DataG.NormalText, DataP.NormalText, False);
                    1: DDLGrantor.RevokeTable(DataP.ClassIID, 'UPDATE', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                  end;
             5: if not IsEqualGUID(DataG.ClassIID, IibSHProcedure) then
                  case DDLGrantor.GetGrantReferenceIndex(DataG.NormalText) of
                   -1: DDLGrantor.GrantTable(DataP.ClassIID, 'REFERENCES', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                    0: if FCtrlDown then
                       begin
                         DDLGrantor.RevokeTable(DataP.ClassIID, 'REFERENCES', DataG.NormalText, DataP.NormalText, False);
                         if IsEqualGUID(DataP.ClassIID, IibSHRole) or IsEqualGUID(DataP.ClassIID, IibSHUser) then
                           DDLGrantor.GrantTable(DataP.ClassIID, 'REFERENCES', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                       end else
                         DDLGrantor.RevokeTable(DataP.ClassIID, 'REFERENCES', DataG.NormalText, DataP.NormalText, False);
                    1: DDLGrantor.RevokeTable(DataP.ClassIID, 'REFERENCES', DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                  end;
             6: if IsEqualGUID(DataG.ClassIID, IibSHProcedure) then
                  case DDLGrantor.GetGrantExecuteIndex(DataG.NormalText) of
                   -1: DDLGrantor.GrantProcedure(DataP.ClassIID, DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                    0: if FCtrlDown then
                       begin
                         DDLGrantor.RevokeProcedure(DataP.ClassIID, DataG.NormalText, DataP.NormalText, False);
                         if IsEqualGUID(DataP.ClassIID, IibSHRole) or IsEqualGUID(DataP.ClassIID, IibSHUser) then
                           DDLGrantor.GrantProcedure(DataP.ClassIID, DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                       end else
                         DDLGrantor.RevokeProcedure(DataP.ClassIID, DataG.NormalText, DataP.NormalText, False);
                    1: DDLGrantor.RevokeProcedure(DataP.ClassIID, DataG.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                  end;
           end;
         end;
      1: begin
           if not Assigned(DataGParent) then Exit;
           case HT.HitColumn of
             0, 1, 2, 3: ;
             4: if not IsEqualGUID(DataG.ClassIID, IibSHProcedure) then
                  case DDLGrantor.GetGrantUpdateIndex(DataGParent.NormalText + '.' + DataG.NormalText) of
                   -1: DDLGrantor.GrantTableField(DataP.ClassIID, 'UPDATE', DataG.NormalText, DataGParent.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                    0: if FCtrlDown then
                       begin
                         DDLGrantor.RevokeTableField(DataP.ClassIID, 'UPDATE', DataG.NormalText, DataGParent.NormalText, DataP.NormalText, False);
                         if IsEqualGUID(DataP.ClassIID, IibSHRole) or IsEqualGUID(DataP.ClassIID, IibSHUser) then
                           DDLGrantor.GrantTableField(DataP.ClassIID, 'UPDATE', DataG.NormalText, DataGParent.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                       end else
                         DDLGrantor.RevokeTableField(DataP.ClassIID, 'UPDATE', DataG.NormalText, DataGParent.NormalText, DataP.NormalText, False);
                    1: DDLGrantor.RevokeTableField(DataP.ClassIID, 'UPDATE', DataG.NormalText, DataGParent.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                  end;
             5: if not IsEqualGUID(DataG.ClassIID, IibSHProcedure) then
                  case DDLGrantor.GetGrantReferenceIndex(DataGParent.NormalText + '.' + DataG.NormalText) of
                   -1: DDLGrantor.GrantTableField(DataP.ClassIID, 'REFERENCES', DataG.NormalText, DataGParent.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                    0: if FCtrlDown then
                       begin
                         DDLGrantor.RevokeTableField(DataP.ClassIID, 'REFERENCES', DataG.NormalText, DataGParent.NormalText, DataP.NormalText, False);
                         if IsEqualGUID(DataP.ClassIID, IibSHRole) or IsEqualGUID(DataP.ClassIID, IibSHUser) then
                           DDLGrantor.GrantTableField(DataP.ClassIID, 'REFERENCES', DataG.NormalText, DataGParent.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                       end else
                         DDLGrantor.RevokeTableField(DataP.ClassIID, 'REFERENCES', DataG.NormalText, DataGParent.NormalText, DataP.NormalText, False);
                    1: DDLGrantor.RevokeTableField(DataP.ClassIID, 'REFERENCES', DataG.NormalText, DataGParent.NormalText, DataP.NormalText, GetWGO(DataP.ClassIID));
                  end;
             6:;
           end;
         end;
    end;
    GrantsOnTree.Repaint;
    GrantsOnTree.Invalidate;
  end;
end;

procedure TibSHDDLGrantorForm.SetTreeEvents(ATree: TVirtualStringTree);
begin
  ATree.Images := Designer.ImageList;
  ATree.DefaultText := EmptyStr;
  ATree.OnGetNodeDataSize := TreeGetNodeDataSize;
  ATree.OnFreeNode := TreeFreeNode;
  ATree.OnGetImageIndex := TreeGetImageIndex;
  ATree.OnGetText := TreeGetText;
  ATree.OnPaintText := TreePaintText;
  ATree.OnIncrementalSearch := TreeIncrementalSearch;
  ATree.OnDblClick := TreeDblClick;
  ATree.OnKeyDown := TreeKeyDown;
  ATree.OnKeyUp := TreeKeyUp;
  ATree.OnGetPopupMenu := TreeGetPopupMenu;
  ATree.OnCompareNodes := TreeCompareNodes;
  ATree.OnFocusChanged := TreeFocusChanged;
  ATree.OnBeforeCellPaint := TreeBeforeCellPaint;
  ATree.OnExpanding := TreeExpanding;
  ATree.OnCollapsed := TreeCollapsed;
end;

procedure TibSHDDLGrantorForm.RebuildPrivilegesForTree;
var
  Node: PVirtualNode;
begin
  if not Assigned(DDLGrantor) then Exit;
  PrivilegesForTree.BeginUpdate;
  PrivilegesForTree.Clear;
  if DDLGrantor.PrivilegesFor = PrivilegeTypes[0] then RebuildPrivilegesForTree(IibSHView);
  if DDLGrantor.PrivilegesFor = PrivilegeTypes[1] then RebuildPrivilegesForTree(IibSHProcedure);
  if DDLGrantor.PrivilegesFor = PrivilegeTypes[2] then RebuildPrivilegesForTree(IibSHTrigger);
  if DDLGrantor.PrivilegesFor = PrivilegeTypes[3] then RebuildPrivilegesForTree(IibSHRole);
  if DDLGrantor.PrivilegesFor = PrivilegeTypes[4] then RebuildPrivilegesForTree(IibSHUser);
  PrivilegesForTree.EndUpdate;
  PrivilegesForTree.Header.Columns[0].Text := Format('Privileges for %s', [DDLGrantor.PrivilegesFor]);
  Node := PrivilegesForTree.GetFirst;
  if Assigned(Node) then
  begin
    PrivilegesForTree.FocusedNode := PrivilegesForTree.GetFirst;
    PrivilegesForTree.Selected[PrivilegesForTree.FocusedNode] := True;
    PrivilegesForTree.Repaint;
    PrivilegesForTree.Invalidate;
  end;
end;

procedure TibSHDDLGrantorForm.RebuildPrivilegesForTree(AClassIID: TGUID);
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
  I: Integer;
begin
  if IsEqualGUID(AClassIID, IibSHUser) then
  begin
    for I := 0 to Pred(DDLGrantor.GetUnionUsers.Count) do
    begin
      Node := PrivilegesForTree.AddChild(nil);
      NodeData := PrivilegesForTree.GetNodeData(Node);
      NodeData.NormalText := DDLGrantor.GetUnionUsers[I];
      NodeData.StaticText := EmptyStr;
      NodeData.ClassIID := AClassIID;
      NodeData.ImageIndex := Designer.GetImageIndex(AClassIID);
    end;
  end else
  begin
    for I := 0 to Pred(DDLGrantor.BTCLDatabase.GetObjectNameList(AClassIID).Count) do
    begin
      Node := PrivilegesForTree.AddChild(nil);
      NodeData := PrivilegesForTree.GetNodeData(Node);
      NodeData.NormalText := DDLGrantor.BTCLDatabase.GetObjectNameList(AClassIID)[I];
      NodeData.StaticText := EmptyStr;
      NodeData.ClassIID := AClassIID;
      NodeData.ImageIndex := Designer.GetImageIndex(AClassIID);
    end;
  end;
end;

procedure TibSHDDLGrantorForm.RebuildGrantsOnTree;
var
  Node: PVirtualNode;
begin
  if not Assigned(DDLGrantor) then Exit;
  GrantsOnTree.BeginUpdate;
  GrantsOnTree.Clear;
  if DDLGrantor.GrantsOn = GrantTypes[0] then
  begin
    RebuildGrantsOnTree(IibSHTable);
    if DDLGrantor.ShowSystemTables then
    begin
      RebuildGrantsOnTree(IibSHSystemTable);
      if AnsiSameText(DDLGrantor.BTCLDatabase.BTCLServer.Version, SInterBase70) or
         AnsiSameText(DDLGrantor.BTCLDatabase.BTCLServer.Version, SInterBase71) or
         AnsiSameText(DDLGrantor.BTCLDatabase.BTCLServer.Version, SInterBase75) then
        RebuildGrantsOnTree(IibSHSystemTableTmp);
    end;
    RebuildGrantsOnTree(IibSHView);
    RebuildGrantsOnTree(IibSHProcedure);
    GrantsOnTree.Sort(nil, 0, sdAscending);
  end;
  if DDLGrantor.GrantsOn = GrantTypes[1] then
  begin
    RebuildGrantsOnTree(IibSHTable);
    if DDLGrantor.ShowSystemTables then
    begin
      RebuildGrantsOnTree(IibSHSystemTable);
      if AnsiSameText(DDLGrantor.BTCLDatabase.BTCLServer.Version, SInterBase70) or
         AnsiSameText(DDLGrantor.BTCLDatabase.BTCLServer.Version, SInterBase71) or
         AnsiSameText(DDLGrantor.BTCLDatabase.BTCLServer.Version, SInterBase75) then
        RebuildGrantsOnTree(IibSHSystemTableTmp);
    end;
  end;
  if DDLGrantor.GrantsOn = GrantTypes[2] then RebuildGrantsOnTree(IibSHView);
  if DDLGrantor.GrantsOn = GrantTypes[3] then RebuildGrantsOnTree(IibSHProcedure);
  GrantsOnTree.EndUpdate;
  GrantsOnTree.Header.Columns[0].Text := Format('Grants on %s', [DDLGrantor.GrantsOn]);
  Node := GrantsOnTree.GetFirst;
  if Assigned(Node) then
  begin
    GrantsOnTree.FocusedNode := GrantsOnTree.GetFirst;
    GrantsOnTree.Selected[GrantsOnTree.FocusedNode] := True;
    GrantsOnTree.Repaint;
    GrantsOnTree.Invalidate;
  end;
end;

procedure TibSHDDLGrantorForm.RebuildGrantsOnTree(AClassIID: TGUID);
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
  I: Integer;
  DoIt: Boolean;
begin
  for I := 0 to Pred(DDLGrantor.BTCLDatabase.GetObjectNameList(AClassIID).Count) do
  begin
    DoIt := False;
    // 'All'
    if DDLGrantor.Display = DisplayGrants[0] then DoIt := True;
    //'Granted'
    if (DDLGrantor.Display = DisplayGrants[1]) and
       DDLGrantor.IsGranted(DDLGrantor.BTCLDatabase.GetObjectNameList(AClassIID)[I]) then DoIt := True;
    // 'Non-Granted'
    if (DDLGrantor.Display = DisplayGrants[2]) and not
       DDLGrantor.IsGranted(DDLGrantor.BTCLDatabase.GetObjectNameList(AClassIID)[I]) then DoIt := True;

    if DoIt then
    begin
      Node := GrantsOnTree.AddChild(nil);
      NodeData := GrantsOnTree.GetNodeData(Node);
      NodeData.NormalText := DDLGrantor.BTCLDatabase.GetObjectNameList(AClassIID)[I];
      NodeData.StaticText := EmptyStr;
      NodeData.ClassIID := AClassIID;
      NodeData.ImageIndex := Designer.GetImageIndex(AClassIID);

      if DDLGrantor.IncludeFields and (
           IsEqualGUID(AClassIID, IibSHTable) or
           IsEqualGUID(AClassIID, IibSHSystemTable) or
           IsEqualGUID(AClassIID, IibSHSystemTableTmp) or
           IsEqualGUID(AClassIID, IibSHView)) then
        GrantsOnTree.AddChild(Node);
    end;
  end;
end;

procedure TibSHDDLGrantorForm.ExtractGrants;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Node := PrivilegesForTree.FocusedNode;
  NodeData := nil;
  if Assigned(Node) then
    NodeData := PrivilegesForTree.GetNodeData(Node);
  if Assigned(DDLGrantor) and Assigned(NodeData) then
  begin
    Screen.Cursor := crHourGlass;
    try
      DDLGrantor.ExtractGrants(NodeData.ClassIID, NodeData.NormalText);
      GrantsOnTree.Invalidate;
      GrantsOnTree.Repaint;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

function TibSHDDLGrantorForm.ConvertImageIndex(const AIndex: Integer): Integer;
begin
  Result := -1;
  case AIndex of
   0: Result := FImgGrant;
   1: Result := FImgGrantWGO;
  end;
end;

procedure TibSHDDLGrantorForm.ExtractFields(ParentNode: PVirtualNode);
var
  I: Integer;
  Node: PVirtualNode;
  NodeData: PTreeRec;
  vComponentClass: TSHComponentClass;
  vComponent: TSHComponent;
  DBObject: IibSHDBObject;
  DBTable: IibSHTable;
  DBView: IibSHView;
begin
  vComponent := nil;
  Screen.Cursor := crHourGlass;
  GrantsOnTree.BeginUpdate;
  try
    NodeData := GrantsOnTree.GetNodeData(ParentNode);
    vComponentClass := Designer.GetComponent(NodeData.ClassIID);
    if Assigned(vComponentClass) then vComponent := vComponentClass.Create(nil);
    Supports(vComponent, IibSHDBObject, DBObject);
    Supports(vComponent, IibSHTable, DBTable);
    Supports(vComponent, IibSHView, DBView);
    if Assigned(DBObject) and Assigned(DDLGenerator) then
    begin
      DBObject.Caption := NodeData.NormalText;
      DBObject.OwnerIID := DDLGrantor.OwnerIID;
      DBObject.State := csSource;
      DDLGenerator.GetDDLText(DBObject);
      for I := 0 to Pred(DBObject.Fields.Count) do
      begin
        Node := GrantsOnTree.AddChild(ParentNode);
        NodeData := GrantsOnTree.GetNodeData(Node);
        NodeData.NormalText := DBObject.Fields[I];
        NodeData.StaticText := EmptyStr;
        NodeData.ClassIID := IibSHField;
        NodeData.ImageIndex := Designer.GetImageIndex(IibSHField);
      end;
    end;
  finally
    DBObject := nil;
    DBTable := nil;
    DBView := nil;
    FreeAndNil(vComponent);
    GrantsOnTree.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TibSHDDLGrantorForm.FreeFields(ParentNode: PVirtualNode);
begin
  GrantsOnTree.DeleteChildren(ParentNode);
end;

procedure TibSHDDLGrantorForm.RefreshPrivilegesForTree;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Screen.Cursor := crHourGlass;
  try
    RebuildPrivilegesForTree;
    Node := PrivilegesForTree.FocusedNode;
    NodeData := nil;
    if Assigned(Node) then NodeData := PrivilegesForTree.GetNodeData(Node);
    if Assigned(NodeData) then
    begin
      if not (IsEqualGUID(NodeData.ClassIID, IibSHRole) or IsEqualGUID(NodeData.ClassIID, IibSHUser)) then
      begin
        CheckBoxGrantOption.Checked := False;
        CheckBoxGrantOption.Enabled := False;
      end else
        CheckBoxGrantOption.Enabled := True;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TibSHDDLGrantorForm.RefreshGrantsOnTree;
begin
  Screen.Cursor := crHourGlass;
  try
    RebuildGrantsOnTree;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function TibSHDDLGrantorForm.GetCanRun: Boolean;
begin
  Result := (PrivilegesForTree.RootNodeCount <> 0) and (GrantsOnTree.RootNodeCount <> 0);
end;

function TibSHDDLGrantorForm.GetCanRefresh: Boolean;
begin
  Result := True;
end;

procedure TibSHDDLGrantorForm.ServeNode(ANode: PVirtualNode);
var
  NodeData, DataP: PTreeRec;
begin
  DataP := nil;

  if Assigned(PrivilegesForTree.FocusedNode) then
    DataP := PrivilegesForTree.GetNodeData(PrivilegesForTree.FocusedNode);

  if Assigned(ANode) and Assigned(DataP) then
  begin
    NodeData := GrantsOnTree.GetNodeData(ANode);
    if Assigned(NodeData) then
    begin
      case RadioGroup1.ItemIndex of
       0: begin
            if not IsEqualGUID(NodeData.ClassIID, IibSHProcedure) then
            begin
              if CheckBoxSelect.Checked then
              begin
                if DDLGrantor.GetGrantSelectIndex(NodeData.NormalText) <> -1 then DDLGrantor.RevokeTable(DataP.ClassIID, 'SELECT', NodeData.NormalText, DataP.NormalText, False);
                DDLGrantor.GrantTable(DataP.ClassIID, 'SELECT', NodeData.NormalText, DataP.NormalText, CheckBoxGrantOption.Checked);
              end;
              if CheckBoxDelete.Checked then
              begin
                if DDLGrantor.GetGrantDeleteIndex(NodeData.NormalText) <> -1 then DDLGrantor.RevokeTable(DataP.ClassIID, 'DELETE', NodeData.NormalText, DataP.NormalText, False);
                DDLGrantor.GrantTable(DataP.ClassIID, 'DELETE', NodeData.NormalText, DataP.NormalText, CheckBoxGrantOption.Checked);
              end;
              if CheckBoxInsert.Checked then
              begin
                if DDLGrantor.GetGrantInsertIndex(NodeData.NormalText) <> -1 then DDLGrantor.RevokeTable(DataP.ClassIID, 'INSERT', NodeData.NormalText, DataP.NormalText, False);
                DDLGrantor.GrantTable(DataP.ClassIID, 'INSERT', NodeData.NormalText, DataP.NormalText, CheckBoxGrantOption.Checked);
              end;
              if CheckBoxUpdate.Checked then
              begin
                if DDLGrantor.GetGrantUpdateIndex(NodeData.NormalText) <> -1 then DDLGrantor.RevokeTable(DataP.ClassIID, 'UPDATE', NodeData.NormalText, DataP.NormalText, False);
                DDLGrantor.GrantTable(DataP.ClassIID, 'UPDATE', NodeData.NormalText, DataP.NormalText, CheckBoxGrantOption.Checked);
              end;
              if CheckBoxReference.Checked then
              begin
                if DDLGrantor.GetGrantReferenceIndex(NodeData.NormalText) <> -1 then DDLGrantor.RevokeTable(DataP.ClassIID, 'REFERENCES', NodeData.NormalText, DataP.NormalText, False);
                DDLGrantor.GrantTable(DataP.ClassIID, 'REFERENCES', NodeData.NormalText, DataP.NormalText, CheckBoxGrantOption.Checked);
              end;
            end else
            begin
              if CheckBoxExecute.Checked then
              begin
                if DDLGrantor.GetGrantExecuteIndex(NodeData.NormalText) <> -1 then DDLGrantor.RevokeProcedure(DataP.ClassIID, NodeData.NormalText, DataP.NormalText, False);
                DDLGrantor.GrantProcedure(DataP.ClassIID, NodeData.NormalText, DataP.NormalText, CheckBoxGrantOption.Checked);
              end;
            end;
          end;
       1: begin
            if not IsEqualGUID(NodeData.ClassIID, IibSHProcedure) then
            begin
              if CheckBoxSelect.Checked then
                DDLGrantor.RevokeTable(DataP.ClassIID, 'SELECT', NodeData.NormalText, DataP.NormalText, CheckBoxGrantOption.Checked);
              if CheckBoxDelete.Checked then
                DDLGrantor.RevokeTable(DataP.ClassIID, 'DELETE', NodeData.NormalText, DataP.NormalText, CheckBoxGrantOption.Checked);
              if CheckBoxInsert.Checked then
                DDLGrantor.RevokeTable(DataP.ClassIID, 'INSERT', NodeData.NormalText, DataP.NormalText, CheckBoxGrantOption.Checked);
              if CheckBoxUpdate.Checked then
                DDLGrantor.RevokeTable(DataP.ClassIID, 'UPDATE', NodeData.NormalText, DataP.NormalText, CheckBoxGrantOption.Checked);
              if CheckBoxReference.Checked then
                DDLGrantor.RevokeTable(DataP.ClassIID, 'REFERENCES', NodeData.NormalText, DataP.NormalText, CheckBoxGrantOption.Checked);
            end else
            begin
              if CheckBoxExecute.Checked then
                DDLGrantor.RevokeProcedure(DataP.ClassIID, NodeData.NormalText, DataP.NormalText, CheckBoxGrantOption.Checked);
            end;
          end;
      end;
    end;
  end;
end;

procedure TibSHDDLGrantorForm.Run;
var
  Node: PVirtualNode;
  I, Count: Integer;
begin
  I := 0;
  Count := GrantsOnTree.RootNodeCount;
  Application.ProcessMessages;
  case RadioGroup2.ItemIndex of
    0: begin
         Screen.Cursor := crHourGlass;
         Panel7.Visible := True;
         Panel7.Top := Height;
         Application.ProcessMessages;
         try
           Node := GrantsOnTree.GetFirst;
           while Assigned(Node) do
           begin
             ServeNode(Node);
             ProgressBar1.Position := 100 * I div Count;
             Inc(I);
             Node := GrantsOnTree.GetNextSibling(Node);
           end;
         finally
           Panel7.Visible := False;
           Screen.Cursor := crDefault;
         end;
       end;
    1: begin
         ServeNode(GrantsOnTree.FocusedNode);
       end;
  end;
  GrantsOnTree.Repaint;
  GrantsOnTree.Invalidate;
end;

procedure TibSHDDLGrantorForm.Refresh;
begin
  Screen.Cursor := crHourGlass;
  try
    RebuildPrivilegesForTree;
    RebuildGrantsOnTree;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TibSHDDLGrantorForm.SetStatusBar(Value: TStatusBar);
begin
  inherited SetStatusBar(Value);
  if Assigned(StatusBar) then StatusBar.Visible := False;
end;

procedure TibSHDDLGrantorForm.Panel7Resize(Sender: TObject);
begin
  ProgressBar1.Width := ProgressBar1.Parent.ClientWidth - 16;
end;

{ Tree }

procedure TibSHDDLGrantorForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHDDLGrantorForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibSHDDLGrantorForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data, DataParent: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  DataParent := nil;
  if Sender.GetNodeLevel(Node) = 1 then
    DataParent := Sender.GetNodeData(Node.Parent);
  if Column = 0 then
    if (Kind = ikNormal) or (Kind = ikSelected) then ImageIndex := Data.ImageIndex;
  if Sender.Tag = 1 then
    if (Kind = ikNormal) or (Kind = ikSelected) then
    begin
      case Sender.GetNodeLevel(Node) of
        0: begin
             case Column of
               1: ImageIndex := ConvertImageIndex(DDLGrantor.GetGrantSelectIndex(Data.NormalText));
               2: ImageIndex := ConvertImageIndex(DDLGrantor.GetGrantDeleteIndex(Data.NormalText));
               3: ImageIndex := ConvertImageIndex(DDLGrantor.GetGrantInsertIndex(Data.NormalText));
               4: ImageIndex := ConvertImageIndex(DDLGrantor.GetGrantUpdateIndex(Data.NormalText));
               5: ImageIndex := ConvertImageIndex(DDLGrantor.GetGrantReferenceIndex(Data.NormalText));
               6: ImageIndex := ConvertImageIndex(DDLGrantor.GetGrantExecuteIndex(Data.NormalText));
             end;
           end;
        1: begin
             case Column of
               4: ImageIndex := ConvertImageIndex(DDLGrantor.GetGrantUpdateIndex(DataParent.NormalText + '.' + Data.NormalText));
               5: ImageIndex := ConvertImageIndex(DDLGrantor.GetGrantReferenceIndex(DataParent.NormalText + '.' + Data.NormalText));
             end;
           end;
      end;
    end;
end;

procedure TibSHDDLGrantorForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Column = 0 then
    case TextType of
      ttNormal: CellText := Data.NormalText;
      ttStatic: ;
    end;
end;

procedure TibSHDDLGrantorForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  case TextType of
    ttNormal: if IsEqualGUID(Data.ClassIID, IibSHUser) then
              begin
                if DDLGrantor.GetAbsentUsers.IndexOf(Data.NormalText) <> -1 then
                begin
                  if Sender.Focused and (vsSelected in Node.States) then
                    TargetCanvas.Font.Color := clWindow
                  else
                    TargetCanvas.Font.Color := clGray;
                end;
              end;
    ttStatic: if Sender.Focused and (vsSelected in Node.States) then
                TargetCanvas.Font.Color := clWindow
              else
                TargetCanvas.Font.Color := clGray;
  end;
end;

procedure TibSHDDLGrantorForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.NormalText)) <> 1 then
    Result := 1;
end;

procedure TibSHDDLGrantorForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FCtrlDown := ssCtrl in Shift;
  if Key = VK_RETURN then ;//JumpToSource;
end;

procedure TibSHDDLGrantorForm.TreeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FCtrlDown := False;
end;

procedure TibSHDDLGrantorForm.TreeDblClick(Sender: TObject);
begin
  if Assigned(PrivilegesForTree.FocusedNode) and Assigned(GrantsOnTree.FocusedNode) and (Sender is TComponent) then
  begin
    try
      DoOnDblClick(TComponent(Sender).Tag)
    finally
      FCtrlDown := False;
    end;
  end;
end;

procedure TibSHDDLGrantorForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
begin
end;

procedure TibSHDDLGrantorForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  Result := CompareStr(Data1.NormalText, Data2.NormalText);
end;

procedure TibSHDDLGrantorForm.TreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  case Sender.Tag of
    0: begin
         ExtractGrants;
         if DDLGrantor.Display <> DisplayGrants[0] then RebuildGrantsOnTree;
       end;
    1:
  end;
end;

procedure TibSHDDLGrantorForm.TreeBeforeCellPaint(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; CellRect: TRect);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Sender.Tag = 1 then
  begin
    if IsEqualGUID(Data.ClassIID, IibSHProcedure) then
    begin
      case Column of
        1, 2, 3, 4, 5: TargetCanvas.Brush.Color := RGB(247, 247, 247);
      end;
    end else
    begin
      case Sender.GetNodeLevel(Node) of
        0: case Column of
             6: TargetCanvas.Brush.Color := RGB(247, 247, 247);
           end;
        1: case Column of
             1, 2, 3, 6: TargetCanvas.Brush.Color := RGB(247, 247, 247);
           end;
      end;
    end;
    TargetCanvas.FillRect(CellRect);
  end;
end;

procedure TibSHDDLGrantorForm.TreeExpanding(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var Allowed: Boolean);
begin
  if (Sender.Tag = 1) and (vsHasChildren in Node.States) then
  begin
    FreeFields(Node);
    ExtractFields(Node);
  end;
end;

procedure TibSHDDLGrantorForm.TreeCollapsed(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  if (Sender.Tag = 1) and (vsHasChildren in Node.States) then
    FreeFields(Node);
end;

end.



