unit ideSHEnvironmentConfiguratorFrm;

interface

{$I .inc}

uses
  SHDesignIntf, ideSHObject,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ideSHBaseDialogFrm, AppEvnts, StdCtrls, ExtCtrls, ComCtrls,
  VirtualTrees, ImgList;

type
  TPageType = (ptPackage, ptLibrary, ptModule);

  TEnvironmentConfiguratorForm = class(TBaseDialogForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnAdd: TButton;
    btnRemove: TButton;
    Panel3: TPanel;
    Bevel4: TBevel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    OpenDialog1: TOpenDialog;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Panel7: TPanel;
    PackageTree: TVirtualStringTree;
    Panel8: TPanel;
    LibraryTree: TVirtualStringTree;
    Panel9: TPanel;
    ModuleTree: TVirtualStringTree;
    ImageList1: TImageList;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FConfigurator: TideBTObject;
    { Tree }
    procedure TreeGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure TreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreePaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure TreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure TreeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);

    function GetPageType: TPageType;
    procedure RecreateTree(APageType: TPageType);
  protected
    procedure DoOnIdle; override;
  public
    { Public declarations }

    procedure Add;
    procedure Remove;

    property PageType: TPageType read GetPageType;
  end;

var
  EnvironmentConfiguratorForm: TEnvironmentConfiguratorForm;

implementation

uses
  ideSHConsts, ideSHMessages, ideSHSysUtils, ideSHSystem, ideSHMainFrm
  , sysSHVersionInfo;


{$R *.dfm}


type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    NormalText: string;
    StaticText: string;
    ImageIndex: Integer;
    FileName: string;
    FileVersion:string;
  end;

var
//  ContainsNode,
  RequiresNode, TimeNode: PVirtualNode;
  FileName: string;


procedure Info_PackageInfoProc(const Name: string; NameType: TNameType; Flags: Byte; Param: Pointer);
var
  NodeData: PTreeRec;
  UnitNode: PVirtualNode;
  S, UnitName: string;
begin
  S := EmptyStr;
  UnitName := Name;
  if (Flags and ufMainUnit) <> 0 then
  begin
    if Length(S) > 0 then S := Format('%s, ', [S]);
    S := S + 'Main';
  end;

  if (Flags and ufPackageUnit) <> 0 then
  begin
    if Length(S) > 0 then S := Format('%s, ', [S]);
    S := S + 'Package';
  end;

  if (Flags and ufWeakUnit) <> 0 then
  begin
    if Length(S) > 0 then S := Format('%s, ', [S]);
    S := S + 'Weak';
  end;

  if (Flags and ufOrgWeakUnit) <> 0 then
  begin
    if Length(S) > 0 then S := Format('%s, ', [S]);
    S := S + 'OrgWeak';
  end;

  if (Flags and ufImplicitUnit) <> 0 then
  begin
    if Length(S) > 0 then S := Format('%s, ', [S]);
    S := S + 'Implicit';
  end;

  if (Flags and ufWeakPackageUnit) <> 0 then
  begin
    if Length(S) > 0 then S := Format('%s, ', [S]);
    S := S + 'WeakPackage';
  end;

  if Length(S) > 0 then S := Format('%s %s', [S, 'Unit']);

  case NameType of
    ntContainsUnit:
      begin
{        UnitNode := EnvironmentConfiguratorForm.ModuleTree.AddChild(ContainsNode);
        NodeData := EnvironmentConfiguratorForm.ModuleTree.GetNodeData(UnitNode);
        NodeData.NormalText := UnitName;
        NodeData.StaticText := S;
        NodeData.ImageIndex := 3;
        NodeData.FileName := FileName;}
      end;
    ntRequiresPackage:
      begin
        UnitNode := EnvironmentConfiguratorForm.ModuleTree.AddChild(RequiresNode);
        NodeData := EnvironmentConfiguratorForm.ModuleTree.GetNodeData(UnitNode);
        NodeData.NormalText := UnitName;
        NodeData.StaticText := S;
        NodeData.ImageIndex := 0;
        NodeData.FileName := FileName;
      end;
    ntDcpBpiName: ;
  end;
end;

function Info_EnumModuleProc(HInstance: Longint; Data: Pointer): Boolean;
type
  TPackageLoad = procedure;
var
  NodeData: PTreeRec;
  MainNode: PVirtualNode;
  ModuleName, ModuleDescr, PathName: string;
  Flags: Integer;
  PackageLoad: TPackageLoad;
  I: Integer;
begin
  @PackageLoad := GetProcAddress(HInstance, 'Initialize'); //Do not localize
  SetLength(ModuleName, 255);
  GetModuleFileName(HInstance, PChar(ModuleName), Length(ModuleName));
  ModuleName := PChar(ModuleName);
  FileName := ModuleName;
  ModuleDescr := GetPackageDescription(PChar(ModuleName));
  if Length(ModuleDescr) = 0 then ModuleDescr := '< None >';
  PathName := ExtractFilePath(ModuleName);
  ModuleName := ExtractFileName(ModuleName);
  if not Assigned(PackageLoad) then
  begin
    if Assigned(RegistryIntf) then
      for I := 0 to Pred(RegistryIntf.GetRegLibraryCount) do
        if AnsiSameText(RegistryIntf.GetRegLibraryName(I), ModuleName) then
          ModuleDescr := RegistryIntf.GetRegLibraryDescription(I);


{    if ModuleName = 'BlazeTop32.exe' then
    begin
     ModuleDescr := 'BlazeTop IDE'
    end} 
  end;

  with EnvironmentConfiguratorForm.ModuleTree do
  begin
    BeginUpdate;
    try
      MainNode := AddChild(nil);
      if ModuleName = 'BlazeTop32.exe' then
       MoveTo(MainNode,EnvironmentConfiguratorForm.ModuleTree,amAddChildFirst,False);
      NodeData := GetNodeData(MainNode);
      NodeData.NormalText := ModuleDescr;
      NodeData.StaticText := ModuleName;
      NodeData.FileVersion:= VersionString(FileName);
      if Pos('BlazeTop', NodeData.NormalText) = 1 then
        NodeData.ImageIndex := 1
      else
        NodeData.ImageIndex := 0;
      NodeData.FileName := FileName;

{      ContainsNode := AddChild(MainNode);
      NodeData := GetNodeData(ContainsNode);
      NodeData.NormalText := 'Contains';
      NodeData.StaticText := EmptyStr;
      NodeData.ImageIndex := 2;
      NodeData.FileName := FileName;}

      RequiresNode := AddChild(MainNode);
      NodeData := GetNodeData(RequiresNode);
      NodeData.NormalText := 'Requires';
      NodeData.StaticText := EmptyStr;
      NodeData.ImageIndex := 2;
      NodeData.FileName := FileName;

      GetPackageInfo(HInstance, nil, Flags, Info_PackageInfoProc);

      TimeNode := InsertNode(MainNode, amAddChildFirst);
      NodeData := GetNodeData(TimeNode);
      NodeData.StaticText := PathName;
      NodeData.ImageIndex := 4;
      NodeData.FileName := FileName;
      if (Flags and pfDesignOnly) = pfDesignOnly then
        NodeData.NormalText := 'Design-time package'
      else
        if (Flags and pfRunOnly) = pfRunOnly then
          NodeData.NormalText := 'Run-time package'
        else
          if (Flags and pfExeModule) = pfExeModule then
          begin
            if not Assigned(PackageLoad) then
            begin
               if Pos('.exe', ModuleName) > 0 then
                 NodeData.NormalText := 'Executable file'
               //if (Flags and pfLibraryModule) = pfLibraryModule then
               else
                 NodeData.NormalText := 'Dynamic-link library';
            end else
              NodeData.NormalText := 'Design-time and Run-time package';
          end;
    finally
      EndUpdate;
    end;
    FocusedNode := GetFirst;
    Selected[FocusedNode] := True;
  end;
  Result := True;
end;

{ EnvironmentConfiguratorForm }

function TEnvironmentConfiguratorForm.GetPageType: TPageType;
begin
  Result := ptPackage;
  if Assigned(FConfigurator) and Assigned(FConfigurator.PageCtrl) then
    Result := TPageType(FConfigurator.PageCtrl.ActivePageIndex);
end;

procedure TEnvironmentConfiguratorForm.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  FConfigurator := TideBTObject.Create(Self);
  FConfigurator.PageCtrl := PageControl1;
  FConfigurator.Flat := True;
  SetFormSize(540, 640);
  Position := poScreenCenter;
  inherited;
  Caption := Format('%s', [SCaptionDialogConfigurator]);
  ButtonsMode := bmOK;
  CaptionOK := Format('%s', [SCaptionButtonClose]);
  btnRemove.Enabled := False;
  Memo1.Lines.Text := EmptyStr;

  PackageTree.OnGetNodeDataSize := TreeGetNodeDataSize;
  PackageTree.OnFreeNode := TreeFreeNode;
  PackageTree.OnPaintText := TreePaintText;
  PackageTree.OnGetText := TreeGetText;
  PackageTree.OnGetImageIndex := TreeGetImageIndex;
  PackageTree.OnFocusChanged := TreeFocusChanged;

  LibraryTree.OnGetNodeDataSize := TreeGetNodeDataSize;
  LibraryTree.OnFreeNode := TreeFreeNode;
  LibraryTree.OnPaintText := TreePaintText;
  LibraryTree.OnGetText := TreeGetText;
  LibraryTree.OnGetImageIndex := TreeGetImageIndex;
  LibraryTree.OnFocusChanged := TreeFocusChanged;

  ModuleTree.OnGetNodeDataSize := TreeGetNodeDataSize;
  ModuleTree.OnFreeNode := TreeFreeNode;
  ModuleTree.OnPaintText := TreePaintText;
  ModuleTree.OnGetText := TreeGetText;
  ModuleTree.OnGetImageIndex := TreeGetImageIndex;
  ModuleTree.OnFocusChanged := TreeFocusChanged;
end;

procedure TEnvironmentConfiguratorForm.FormShow(Sender: TObject);
begin
  inherited;
  RecreateTree(ptPackage);
  PackageTree.FocusedNode := PackageTree.GetFirst;
  if Assigned(PackageTree.FocusedNode) then
    PackageTree.Selected[PackageTree.FocusedNode] := True;
end;

procedure TEnvironmentConfiguratorForm.RecreateTree(APageType: TPageType);
var
  I, Count, ImageIndex: Integer;
  MainNode: PVirtualNode;
  NodeData: PTreeRec;
begin
  try
    Screen.Cursor := crHourGlass;
    case APageType of
      ptPackage:
        begin
          Count := RegistryIntf.RegPackageCount;
          ImageIndex := 1;
          PackageTree.Clear;
          for I := 0 to Pred(Count) do
          begin
            PackageTree.BeginUpdate;
            try
              MainNode := PackageTree.AddChild(nil);
              NodeData := PackageTree.GetNodeData(MainNode);
              NodeData.NormalText := RegistryIntf.GetRegPackageDescription(I);
              NodeData.StaticText := ExtractFileName(RegistryIntf.GetRegPackageFileName(I));
              NodeData.FileName := RegistryIntf.GetRegPackageFileName(I);
              NodeData.FileVersion:= VersionString(NodeData.FileName);
              NodeData.ImageIndex := ImageIndex;
            finally
              PackageTree.EndUpdate;
            end;
          end;
        end;
      ptLibrary:
        begin
          Count := RegistryIntf.RegLibraryCount;
          ImageIndex := 1;
          LibraryTree.Clear;
          for I := 0 to Pred(Count) do
          begin
            LibraryTree.BeginUpdate;
            try
              MainNode := LibraryTree.AddChild(nil);
              NodeData := LibraryTree.GetNodeData(MainNode);
              NodeData.NormalText := RegistryIntf.GetRegLibraryDescription(I);
              NodeData.StaticText := ExtractFileName(RegistryIntf.GetRegLibraryFileName(I));
              NodeData.FileName   := RegistryIntf.GetRegLibraryFileName(I);
              NodeData.FileVersion:= VersionString(NodeData.FileName);
              NodeData.ImageIndex := ImageIndex;
            finally
              LibraryTree.EndUpdate;
            end;
          end;
        end;
      ptModule:
        begin
          if ModuleTree.RootNodeCount = 0 then
          begin
            ModuleTree.Clear;
            EnumModules(Info_EnumModuleProc, nil);
          end;
        end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TEnvironmentConfiguratorForm.DoOnIdle;
begin
  case PageType of
    ptPackage:
      begin
        OpenDialog1.Filter := 'Package (*.bpl)|*.bpl'; {do not localize}
        btnAdd.Enabled := True;
        btnRemove.Enabled := Assigned(RegistryIntf) and (RegistryIntf.RegPackageCount > 0);
      end;
    ptLibrary:
      begin
        OpenDialog1.Filter := 'Library (*.dll)|*.dll'; {do not localize}
        btnAdd.Enabled := True;
        btnRemove.Enabled := Assigned(RegistryIntf) and (RegistryIntf.RegLibraryCount > 0);
      end;
    ptModule:
      begin
        btnAdd.Enabled := False;
        btnRemove.Enabled := False;
      end;
  end;
{$IFNDEF ENTERPRISE_EDITION}
  btnAdd.Enabled := False;
  btnRemove.Enabled := False;
{$ENDIF}
end;

procedure TEnvironmentConfiguratorForm.Add;
var
  I: Integer;
begin
  with OpenDialog1 do
  begin
    case PageType of
      ptPackage:
        begin
          InitialDir := GetDirPath(SDirBin);
          if Execute then
          begin
            ModuleTree.Clear;
            for I := Pred(Files.Count) downto 0 do
              if not RegistryIntf.ExistsPackage(Files[I]) then
              begin
                RegistryIntf.RegisterPackage(Files[I]);
                RegistryIntf.SavePackagesToFile;
                RecreateTree(ptPackage);
                PackageTree.FocusedNode := PackageTree.GetLast;
                if Assigned(PackageTree.FocusedNode) then
                  PackageTree.Selected[PackageTree.FocusedNode] := True;
                if Assigned(NavigatorIntf) then NavigatorIntf.RecreatePalette;
              end else
                ShowMsg(Format(SPackageExists, [ExtractFileName(Files[I])]), mtWarning);
          end;
        end;
      ptLibrary:
        begin
          InitialDir := GetDirPath(SDirBin);
          if Execute then
          begin
            ModuleTree.Clear;
            for I := Pred(Files.Count) downto 0 do
              if not RegistryIntf.ExistsLibrary(Files[I]) then
              begin
                RegistryIntf.RegisterLibrary(Files[I]);
                RegistryIntf.SaveLibrariesToFile;
                RecreateTree(ptLibrary);
                LibraryTree.FocusedNode := LibraryTree.GetLast;
                if Assigned(LibraryTree.FocusedNode) then
                  LibraryTree.Selected[LibraryTree.FocusedNode] := True;
              end else
                ShowMsg(Format(SLibraryExists, [ExtractFileName(Files[I])]), mtWarning);
          end;
        end;
    end;
  end;
end;

procedure TEnvironmentConfiguratorForm.Remove;
var
  Data: PTreeRec;
  NextNode: PVirtualNode;
begin
  case PageType of
    ptPackage:
      begin
        if Assigned(PackageTree.FocusedNode) then
        begin
          Data := PackageTree.GetNodeData(PackageTree.FocusedNode);
          if ShowMsg(Format(SPackageRemoveQuestion + sLineBreak + SPackageRemoveWarning, [Data.FileName]), mtConfirmation) then
          begin
            RegistryIntf.UnRegisterPackage(Data.FileName);
            RegistryIntf.SavePackagesToFile;
            NextNode := PackageTree.FocusedNode.NextSibling;
            if not Assigned(NextNode) then NextNode := PackageTree.FocusedNode.PrevSibling;
            PackageTree.DeleteNode(PackageTree.FocusedNode);
            if Assigned(NextNode) then
            begin
              PackageTree.FocusedNode := PackageTree.GetLast;
              PackageTree.Selected[PackageTree.FocusedNode] := True;
            end;
          end;
        end;
      end;
    ptLibrary:
      begin
        if Assigned(LibraryTree.FocusedNode) then
        begin
          Data := LibraryTree.GetNodeData(LibraryTree.FocusedNode);
          if ShowMsg(Format(SLibraryRemoveQuestion + sLineBreak + SLibraryRemoveWarning, [Data.FileName]), mtConfirmation) then
          begin
            RegistryIntf.UnRegisterLibrary(Data.FileName);
            RegistryIntf.SaveLibrariesToFile;
            NextNode := LibraryTree.FocusedNode.NextSibling;
            if not Assigned(NextNode) then NextNode := LibraryTree.FocusedNode.PrevSibling;
            LibraryTree.DeleteNode(LibraryTree.FocusedNode);
            if Assigned(NextNode) then
            begin
              LibraryTree.FocusedNode := LibraryTree.GetLast;
              LibraryTree.Selected[LibraryTree.FocusedNode] := True;
            end;
          end;
        end;
      end;
  end;
end;

{ PageControl }

procedure TEnvironmentConfiguratorForm.PageControl1Change(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0: TreeFocusChanged(PackageTree, PackageTree.FocusedNode, 0);
    1: if LibraryTree.RootNodeCount = 0 then
       begin
         RecreateTree(ptLibrary);
         LibraryTree.FocusedNode := LibraryTree.GetFirst;
         if Assigned(LibraryTree.FocusedNode) then
           LibraryTree.Selected[LibraryTree.FocusedNode] := True;
         TreeFocusChanged(LibraryTree, LibraryTree.FocusedNode, 0);
       end;
    2: if ModuleTree.RootNodeCount = 0 then
       begin
         RecreateTree(ptModule);
         TreeFocusChanged(ModuleTree, ModuleTree.FocusedNode, 0);
       end;

  end;
end;

{ Buttons }

procedure TEnvironmentConfiguratorForm.btnAddClick(Sender: TObject);
begin
  Add;
end;

procedure TEnvironmentConfiguratorForm.btnRemoveClick(Sender: TObject);
begin
  Remove;
end;

{ Tree }

procedure TEnvironmentConfiguratorForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TEnvironmentConfiguratorForm.TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then Finalize(Data^);
end;

procedure TEnvironmentConfiguratorForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if Sender.Tag = 2 then
    case Column of
      0: case TextType of
           ttNormal: {if Pos('BlazeTop', Data.NormalText) = 1 then
                       TargetCanvas.Font.Style := Canvas.Font.Style + [fsBold]};
           ttStatic: TargetCanvas.Font.Color := clGray;
         end;
      1: case TextType of
           ttNormal: ;
           ttStatic: ;
         end;
      2: case TextType of
           ttNormal: ;
           ttStatic: ;
         end;

    end;
end;

procedure TEnvironmentConfiguratorForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
  NodeLevel: Integer;
begin
  Data := Sender.GetNodeData(Node);
  NodeLevel := Sender.GetNodeLevel(Node);
  if Sender.Tag = 2 then
  begin
    case Column of
      0: case TextType of
           ttNormal: CellText := Data.NormalText;
           ttStatic: if NodeLevel > 0 then
                       CellText := Data.StaticText;
         end;
      1: case TextType of
           ttNormal: if NodeLevel = 0 then
                       CellText := Data.StaticText
                     else
                       CellText := EmptyStr;
           ttStatic: CellText := EmptyStr;
         end;
      2: case TextType of
           ttNormal: if NodeLevel = 0 then
                       CellText := Data.FileVersion
                     else
                       CellText := EmptyStr;
           ttStatic: CellText := EmptyStr;
         end;
    end;
  end else
  begin
    case Column of
      0: case TextType of
           ttNormal: CellText := Data.NormalText;
           ttStatic: ;
         end;
      1: case TextType of
           ttNormal: CellText := Data.StaticText;
           ttStatic: ;
         end;
      2: case TextType of
           ttNormal: CellText := Data.FileVersion;
           ttStatic: ;
         end;

    end;
  end;
end;

procedure TEnvironmentConfiguratorForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if (Kind = ikNormal) or (Kind = ikSelected) then
    case Column of
      0: ImageIndex := Data.ImageIndex;
      1: ImageIndex := -1;
      2: ImageIndex := -1;
    end;
end;

procedure TEnvironmentConfiguratorForm.TreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PTreeRec;
begin
  if Assigned(Sender.FocusedNode) then
  begin
    Data := Sender.GetNodeData(Node);
    Memo1.Lines.Text := Data.FileName;
  end else
    Memo1.Lines.Text := EmptyStr;
end;

end.
