unit ibSHDDLFinderFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, ImgList, StdCtrls, SynEdit, SynEditTypes,
  Menus, pSHSynEdit, VirtualTrees, ActnList, AppEvnts;

type
  TibSHDDLFinderForm = class(TibBTComponentForm, IibSHDDLFinderForm)
    ImageList1: TImageList;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    Panel4: TPanel;
    ComboBox1: TComboBox;
    Tree: TVirtualStringTree;
    pSHSynEdit1: TpSHSynEdit;
    Panel9: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Image1: TImage;
    Panel6: TPanel;
    Panel7: TPanel;
    ProgressBar1: TProgressBar;
    procedure ComboBox1Enter(Sender: TObject);
    procedure Panel9Resize(Sender: TObject);
  private
    { Private declarations }
    FDDLFinderIntf: IibSHDDLFinder;
    FResultList: TStrings;
    FResultIndex: Integer;
    FCanServerSideSearch:boolean;
    function GetSaveFile: string;
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
    procedure TreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);

    procedure SetTreeEvents(ATree: TVirtualStringTree);
    procedure FindIn(const AClassIID: TGUID);
    procedure FillTree(const AClassIID: TGUID; const ACaption: string);
    procedure GutterDrawNotify(Sender: TObject; ALine: Integer; var ImageIndex: Integer);
    procedure ShowSource;
    procedure JumpToSource;

    procedure SelectTopLineBlock(ATopLine: Integer);
    function  CanServerSideSearch(var NeedUTFEncode:boolean):boolean;
  protected
    procedure RegisterEditors; override;
    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanPause: Boolean; override;
    procedure Run; override;
    procedure Pause; override;

    { IibSHDDLFinderForm }
    function GetCanShowNextResult: Boolean;
    function GetCanShowPrevResult: Boolean;
    procedure ShowNextResult;
    procedure ShowPrevResult;

    function DoOnOptionsChanged: Boolean; override;
    procedure DoOnSpecialLineColors(Sender: TObject;
      Line: Integer; var Special: Boolean; var FG, BG: TColor); override;
    function GetCanDestroy: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    property DDLFinder: IibSHDDLFinder read FDDLFinderIntf;
  end;

var
  ibSHDDLFinderForm: TibSHDDLFinderForm;

implementation

uses
  ibSHConsts, ibSHValues, ibSHDDLFinder;

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

{ TibSHDDLFinderForm }

constructor TibSHDDLFinderForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHDDLFinder, FDDLFinderIntf);
  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
  Editor.OnGutterDraw := GutterDrawNotify;
  Editor.GutterDrawer.ImageList := ImageList1;
  Editor.GutterDrawer.Enabled := True;
  FocusedControl := Editor;

  RegisterEditors;
  SetTreeEvents(Tree);
  DoOnOptionsChanged;

  if FileExists(GetSaveFile) then ComboBox1.Items.LoadFromFile(GetSaveFile);
  ComboBox1.Text := SEnterYourSearchCriteria;
  Panel6.Caption := EmptyStr;
  Panel9.Visible := False;
  FResultList := TStringList.Create;
  FResultIndex := -1;
end;

destructor TibSHDDLFinderForm.Destroy;
begin
  FResultList.Free;
  inherited Destroy;
end;

function TibSHDDLFinderForm.GetSaveFile: string;
begin
  Result := Format('%s%s', [DDLFinder.BTCLDatabase.DataRootDirectory, SDDLFinderFile]);
  if not SysUtils.DirectoryExists(ExtractFilePath(Result)) then
    ForceDirectories(ExtractFilePath(Result));
end;

procedure TibSHDDLFinderForm.SetTreeEvents(ATree: TVirtualStringTree);
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
  ATree.OnFocusChanged := TreeFocusChanged;
end;

procedure TibSHDDLFinderForm.FindIn(const AClassIID: TGUID);
var
  I, Count: Integer;
  LimList:TStrings;
begin
  if Assigned(DDLFinder) and DDLFinder.Active then
  begin
    Image1.Canvas.Brush.Color := clBtnFace;
    Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
    Designer.ImageList.Draw(Image1.Canvas, (Image1.Canvas.ClipRect.Left + Image1.Canvas.ClipRect.Right - 16) div 2, (Image1.Canvas.ClipRect.Top + Image1.Canvas.ClipRect.Bottom - 16) div 2, Designer.GetImageIndex(AClassIID));
    Panel6.Caption := Format('Searching in %s...', [GUIDToName(AClassIID, 1)]);
    if (FCanServerSideSearch) and   Supports(DDLFinder,IibServerSideSearch)
     and (DDLFinder as IibServerSideSearch).FindOnServerSide(AClassIID,LimList)
    then
    begin
      Count := LimList.Count;
      for I := 0 to Pred(Count) do
      begin
        if DDLFinder.FindIn(AClassIID, LimList[I]) then
          FillTree(AClassIID, LimList[I]);
        ProgressBar1.Position := 100 * I div Count;
        Application.ProcessMessages;
        if not DDLFinder.Active then Break;
      end;
    end
    else
    begin
      if not FCanServerSideSearch then
       if IsEqualGUID(AClassIID,IibSHTable) or
          IsEqualGUID(AClassIID,IibSHGenerator) or
          IsEqualGUID(AClassIID,IibSHFunction) 
       then
          Exit;

      Count := DDLFinder.BTCLDatabase.GetObjectNameList(AClassIID).Count;
      for I := 0 to Pred(Count) do
      begin
        if DDLFinder.FindIn(AClassIID, DDLFinder.BTCLDatabase.GetObjectNameList(AClassIID)[I]) then
          FillTree(AClassIID, DDLFinder.BTCLDatabase.GetObjectNameList(AClassIID)[I]);
        ProgressBar1.Position := 100 * I div Count;
        Application.ProcessMessages;
        if not DDLFinder.Active then Break;
      end;
    end
  end;
end;

procedure TibSHDDLFinderForm.FillTree(const AClassIID: TGUID; const ACaption: string);
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Tree.BeginUpdate;
  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    NodeData := Tree.GetNodeData(Node);
    if IsEqualGUID(NodeData.ClassIID, AClassIID) then Break;
    Node := Tree.GetNextSibling(Node);
  end;

  if not Assigned(Node) then
  begin
    Node := Tree.AddChild(nil);
    NodeData := Tree.GetNodeData(Node);
    NodeData.NormalText := GUIDToName(AClassIID, 1);
    NodeData.StaticText := EmptyStr;
    NodeData.ClassIID := AClassIID;
    NodeData.ImageIndex := Designer.GetImageIndex(AClassIID);
    NodeData.Source := EmptyStr;

    Node := Tree.AddChild(Node);
    NodeData := Tree.GetNodeData(Node);
    NodeData.NormalText := ACaption;
    NodeData.StaticText := EmptyStr;
    NodeData.ClassIID := AClassIID;
    NodeData.ImageIndex := Designer.GetImageIndex(AClassIID);
    NodeData.Source := DDLFinder.LastSource;
  end else
  begin
    Node := Tree.AddChild(Node);
    NodeData := Tree.GetNodeData(Node);
    NodeData.NormalText := ACaption;
    NodeData.StaticText := EmptyStr;
    NodeData.ClassIID := AClassIID;
    NodeData.ImageIndex := Designer.GetImageIndex(AClassIID);
    NodeData.Source := DDLFinder.LastSource
  end;

  Tree.EndUpdate;
  Node := Tree.GetFirst;
  if Assigned(Node) then
  begin
    Tree.FocusedNode := Tree.GetFirst;
    Tree.Selected[Tree.FocusedNode] := True;
    Tree.Repaint;
    Tree.Invalidate;
  end;
end;

procedure TibSHDDLFinderForm.GutterDrawNotify(Sender: TObject; ALine: Integer;
  var ImageIndex: Integer);
begin
  ImageIndex := Integer(Editor.Lines.Objects[ALine]);
  if ImageIndex <> 1 then ImageIndex := -1;
end;

procedure TibSHDDLFinderForm.ShowSource;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
  I: Integer;
begin
  Node := Tree.FocusedNode;
  NodeData := Tree.GetNodeData(Node);
  if Assigned(NodeData) and Assigned(Editor) then
  begin
    Editor.BeginUpdate;
    Editor.Lines.Clear;
    Editor.Lines.Text := NodeData.Source;
    Editor.EndUpdate;

    FResultList.Clear;
    FResultIndex := -1;
    for I := 0 to Pred(Editor.Lines.Count) do
      if DDLFinder.Find(Editor.Lines[I]) then
      begin
        FResultList.Add(IntToStr(I));
        Editor.Lines.Objects[I] := TObject(1);
      end;

    if FResultList.Count <> 0 then
    begin
      FResultIndex := 0;
      SelectTopLineBlock(StrToInt(FResultList[FResultIndex]));
      if Assigned(StatusBar) and (StatusBar.Panels.Count > 3) then
        StatusBar.Panels[3].Text := Format('  %d Entries', [FResultList.Count]);
    end else
    begin
     if not DDLFinder.Active then
       if Assigned(StatusBar) and (StatusBar.Panels.Count > 3) then
         StatusBar.Panels[3].Text := EmptyStr;
    end;
  end;
end;

procedure TibSHDDLFinderForm.JumpToSource;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Node := Tree.FocusedNode;
  NodeData := nil;
  case Tree.GetNodeLevel(Node) of
    1: NodeData := Tree.GetNodeData(Node);
  end;
  if Assigned(NodeData) then
    Designer.JumpTo(Component.InstanceIID, NodeData.ClassIID, NodeData.NormalText);
end;

procedure TibSHDDLFinderForm.SelectTopLineBlock(ATopLine: Integer);
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

procedure TibSHDDLFinderForm.RegisterEditors;
var
  vEditorRegistrator: IibSHEditorRegistrator;
begin
  if Assigned(DDLFinder) and Supports(Designer.GetDemon(IibSHEditorRegistrator), IibSHEditorRegistrator, vEditorRegistrator) then
    vEditorRegistrator.RegisterEditor(Editor, DDLFinder.BTCLDatabase.BTCLServer, DDLFinder.BTCLDatabase);
end;

function TibSHDDLFinderForm.GetCanRun: Boolean;
begin
  Result := not DDLFinder.Active and
            not AnsiSameText(ComboBox1.Text, SEnterYourSearchCriteria) and
            (Length(ComboBox1.Text) > 0);
end;

function TibSHDDLFinderForm.GetCanPause: Boolean;
begin
  Result := DDLFinder.Active;
end;

procedure TibSHDDLFinderForm.Run;
var
    NeedUTF8:boolean;
begin
  if Assigned(DDLFinder) then
  begin
    Editor.Lines.Clear;
    Tree.Clear;
    FCanServerSideSearch:=CanServerSideSearch(NeedUTF8);
    if Supports(DDLFinder, IibServerSideSearch) then
     (DDLFinder as IibServerSideSearch).SetNeedUTFEncode(NeedUTF8);

    DDLFinder.FindString := ComboBox1.Text;

    if ComboBox1.Items.IndexOf(DDLFinder.FindString) <> -1 then
      ComboBox1.Items.Delete(ComboBox1.Items.IndexOf(DDLFinder.FindString));
    ComboBox1.Items.Insert(0, DDLFinder.FindString);
    ComboBox1.Text := DDLFinder.FindString;
    ComboBox1.Items.SaveToFile(GetSaveFile);
    DDLFinder.Active := True;
    Panel9.Visible := True;
    Designer.UpdateActions;
    DoOnIdle;

    try
      if DDLFinder.LookIn.Domains then FindIn(IibSHDomain);
      if DDLFinder.LookIn.Tables then FindIn(IibSHTable);
//      if DDLFinder.LookIn.Constraints then FindIn(IibSHConstraint);
      if DDLFinder.LookIn.Indices then FindIn(IibSHIndex);
      if DDLFinder.LookIn.Views then FindIn(IibSHView);
      if DDLFinder.LookIn.Procedures then FindIn(IibSHProcedure);
      if DDLFinder.LookIn.Triggers then FindIn(IibSHTrigger);
      if DDLFinder.LookIn.Generators then FindIn(IibSHGenerator);
      if DDLFinder.LookIn.Exceptions then FindIn(IibSHException);
      if DDLFinder.LookIn.Functions then FindIn(IibSHFunction);
      if DDLFinder.LookIn.Filters then FindIn(IibSHFilter);
      if DDLFinder.LookIn.Roles then FindIn(IibSHRole);
    finally
      DDLFinder.Active := False;
      Panel6.Caption := EmptyStr;
      Panel9.Visible := False;
    end;
  end;
end;

procedure TibSHDDLFinderForm.Pause;
begin
  if Assigned(DDLFinder) then
  begin
    DDLFinder.Active := False;
    Panel6.Caption := EmptyStr;
    Panel9.Visible := False;
  end;
end;

function TibSHDDLFinderForm.GetCanShowNextResult: Boolean;
begin
  Result := (FResultList.Count > 0) and (FResultIndex <> Pred(FResultList.Count));
end;

function TibSHDDLFinderForm.GetCanShowPrevResult: Boolean;
begin
  Result := (FResultList.Count > 0) and (FResultIndex <> 0);
end;

procedure TibSHDDLFinderForm.ShowNextResult;
begin
  if FResultIndex <> -1 then
  begin
    Inc(FResultIndex);
    SelectTopLineBlock(StrToInt(FResultList[FResultIndex]));
  end;
end;

procedure TibSHDDLFinderForm.ShowPrevResult;
begin
  if FResultIndex <> -1 then
  begin
    Dec(FResultIndex);
    SelectTopLineBlock(StrToInt(FResultList[FResultIndex]));
  end;
end;

function TibSHDDLFinderForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
  if Result then
  begin
    Editor.ReadOnly := True;
//    Editor.RightEdge := 0;
//    Editor.BottomEdgeVisible := False;
  end;
end;

procedure TibSHDDLFinderForm.DoOnSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
begin
  Special := False;
  if Integer(Editor.Lines.Objects[Line - 1]) <> 0 then
  begin
    Special := True;
    BG := RGB(235, 235, 235);
  end;
end;

function TibSHDDLFinderForm.GetCanDestroy: Boolean;
begin
  Result := inherited GetCanDestroy;
  if DDLFinder.BTCLDatabase.WasLostConnect then Exit;

  if DDLFinder.Active then Designer.ShowMsg(Format('Search process is running...', []), mtInformation);
  Result := Assigned(DDLFinder) and not DDLFinder.Active;
end;

procedure TibSHDDLFinderForm.ComboBox1Enter(Sender: TObject);
begin
  if AnsiSameText(ComboBox1.Text, SEnterYourSearchCriteria) then
  begin
    ComboBox1.Text := ' ';
    ComboBox1.Text := EmptyStr;
    ComboBox1.Invalidate;
    ComboBox1.Repaint;
  end;
end;

procedure TibSHDDLFinderForm.Panel9Resize(Sender: TObject);
begin
  ComboBox1.Width := ComboBox1.Parent.ClientWidth - 24;
  ProgressBar1.Width := ProgressBar1.Parent.ClientWidth - 8;
end;

{ Tree }

procedure TibSHDDLFinderForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHDDLFinderForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TibSHDDLFinderForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if (Kind = ikNormal) or (Kind = ikSelected) then
    ImageIndex := Data.ImageIndex;
end;

procedure TibSHDDLFinderForm.TreeGetText(Sender: TBaseVirtualTree;
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

procedure TibSHDDLFinderForm.TreePaintText(Sender: TBaseVirtualTree;
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

procedure TibSHDDLFinderForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.NormalText)) <> 1 then
    Result := 1;
end;

procedure TibSHDDLFinderForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then JumpToSource;
end;

procedure TibSHDDLFinderForm.TreeDblClick(Sender: TObject);
var
  HT: THitInfo;
  P: TPoint;
begin
  GetCursorPos(P);
  P := Tree.ScreenToClient(P);
  Tree.GetHitTestInfoAt(P.X, P.Y, True, HT);
  if not (hiOnItemButton in HT.HitPositions) then JumpToSource;
end;

procedure TibSHDDLFinderForm.TreeGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
begin
end;

procedure TibSHDDLFinderForm.TreeCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  Result := CompareStr(Data1.NormalText, Data2.NormalText);
end;

procedure TibSHDDLFinderForm.TreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  ShowSource;
end;

function TibSHDDLFinderForm.CanServerSideSearch(var NeedUTFEncode:boolean): boolean;
var
  i:integer;
  v:integer;
  v1:integer;
  s:string;
begin
  if DDLFinder.BTCLDatabase.DRVDatabase.IsFirebirdConnect then
  begin
  s:=DDLFinder.BTCLDatabase.DRVDatabase.ODSVersion;
  i:=Pos('.',s);
  v:=StrToInt(System.Copy(s,1,i-1));
  v1:=StrToInt(System.Copy(s,i+1,MaxInt));
  NeedUTFEncode:=(v>=11) and (v1>0);
  if NeedUTFEncode or not DDLFinder.CaseSensitive then
   Result:=True
  else
  begin
    s:=ComboBox1.Text;
    Result:=Length(s)>0;
    if Result then
    for i:=Length(s) downto 1 do
    begin
      if Ord(s[i])>127 then
      begin
       // no 7 bit symbol
        Result:=False;
        Exit
      end
    end;
  end;
  end
  else
  begin
   Result:=False;
   NeedUTFEncode:=False
  end

{  s:=ComboBox1.Text;
  Result:=Length(s)>0;
  if Result then
  for i:=Length(s) downto 1 do
  begin
    if Ord(s[i])>127 then
    begin
     // no 7 bit symbol
      Result:=False;
      Exit
    end
  end;}
end;

end.

