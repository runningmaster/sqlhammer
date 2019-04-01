unit ibSHDataBlobFrm;

interface

uses
  SHDesignIntf, ibSHDriverIntf, ibSHDesignIntf, ibSHDataCustomFrm, ibSHConsts,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls, ComCtrls, DBCtrls, ToolWin,
  VirtualTrees, ImgList, DB, SynEdit, pSHSynEdit, pSHDBSynEdit, PrnDbgeh,
  AppEvnts, ActnList, ExtDlgs, Clipbrd, Jpeg, Menus, DBGrids,

  SHOptionsIntf, DBGridEh, GridsEh;

type
  TibSHBLOBEditorType = (betTEXT, betRTF, betSQL, betBMP, betNone);

  TibSHDataBlobForm = class(TibSHDataCustomForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    DBGridEh1: TDBGridEh;
    Panel3: TPanel;
    Splitter2: TSplitter;
    Panel4: TPanel;
    TEXTPanel: TPanel;
    RTFPanel: TPanel;
    SQLPanel: TPanel;
    Panel5: TPanel;
    Tree: TVirtualStringTree;
    dsTextControl: TDataSource;
    TextControl: TDBMemo;
    RTFControl: TDBRichEdit;
    SQLControl: TpSHDBSynEdit;
    dsGrid: TDataSource;
    dsRTFControl: TDataSource;
    dsSQLControl: TDataSource;
    ImageList1: TImageList;
    ApplicationEvents1: TApplicationEvents;
    sdGrid: TSaveDialog;
    PrintDBGridEh1: TPrintDBGridEh;
    PrintDBGridEh2: TPrintDBGridEh;
    dsImageControl: TDataSource;
    odText: TOpenDialog;
    odRTF: TOpenDialog;
    odImage: TOpenPictureDialog;
    ImagePanel: TScrollBox;
    sdText: TSaveDialog;
    sdRTF: TSaveDialog;
    sdImage: TSavePictureDialog;
    ImageControl: TImage;
    Panel6: TPanel;
    ToolBar1: TToolBar;
    DBNavigator1: TDBNavigator;
    ToolButton1: TToolButton;
    ComboBox1: TComboBox;
    Panel7: TPanel;
    pSHSynEdit2: TpSHSynEdit;
    Splitter3: TSplitter;
    PopupMenuMessage: TPopupMenu;
    pmiHideMessage: TMenuItem;
    procedure ControlBar1Resize(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure AnyControlChange(Sender: TObject);
    procedure dsImageControlDataChange(Sender: TObject; Field: TField);
    procedure pmiHideMessageClick(Sender: TObject);
  private
    { Private declarations }
    FBLOBEditorType: TibSHBLOBEditorType;
    FFieldImageIndex: Integer;
    FCurrentField: TField;
    FJPEGSource: TJpegImage;
    FImageFormat: TibSHImageFormat;
    FBlobPopupMenu: TPopupMenu;
    procedure SetBLOBEditorType(Value: TibSHBLOBEditorType);
    procedure BuildTree;
    procedure SetTreeEvents;
    procedure SetDataLinks;
    procedure SetDataField;
    procedure SafeShowPicture;
    procedure ClearEditor;

    { Tree }
    procedure TreeClick(Sender: TObject);
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
    procedure TreeDblClick(Sender: TObject);
    procedure TreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
      Column: TColumnIndex; var Result: Integer);
    procedure GutterDrawNotify(Sender: TObject; ALine: Integer; var ImageIndex: Integer);
    function IsDBGridSelected: Boolean;
  protected
    { Protected declarations }
    procedure ShowMessages; override;
    procedure HideMessages; override;
    { ISHFileCommands }
    function GetCanOpen: Boolean; override;
    function GetCanSave: Boolean; override;
    function GetCanSaveAs: Boolean; override;
    function GetCanPrint: Boolean; override;

    procedure Open; override;
    procedure Save; override;
    procedure SaveAs; override;
    procedure Print; override;

    { ISHEditCommands }
    function GetCanUndo: Boolean; override;
    function GetCanRedo: Boolean; override;
    function GetCanCut: Boolean; override;
    function GetCanCopy: Boolean; override;
    function GetCanPaste: Boolean; override;
    function GetCanSelectAll: Boolean; override;
    function GetCanClearAll: Boolean; override;

    procedure Undo; override;
    procedure Redo; override;
    procedure Cut; override;
    procedure Copy; override;
    procedure Paste; override;
    procedure SelectAll; override;
    procedure ClearAll; override;

    { ISHSearchCommands }
    function GetCanFind: Boolean; override;
    function GetCanReplace: Boolean; override;
    function GetCanSearchAgain: Boolean; override;
    function GetCanSearchIncremental: Boolean; override;
    function GetCanGoToLineNumber: Boolean; override;

    procedure Find; override;
    procedure Replace; override;
    procedure SearchAgain; override;
    procedure SearchIncremental; override;
    procedure GoToLineNumber; override;

    procedure SetDBGridOptions(ADBGrid: TComponent); override;

    {IibDRVDatasetNotification}
    procedure DoOnPopupBlobMenu(Sender: TObject);
    procedure FillBlobPopupMenu;
    procedure OnFetchRecord(ADataset: IibSHDRVDataset); override;

    procedure DoUpdateStatusBarByState(Changes: TSynStatusChanges); override;
    procedure DoUpdateStatusBar; override;

    procedure DoOnIdle; override;
    function DoOnOptionsChanged: Boolean; override;
    function GetCanDestroy: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure BringToTop; override;
    procedure ShowResult(AEnableFetchEvent: Boolean = True); override;

    property BLOBEditorType: TibSHBLOBEditorType read FBLOBEditorType write SetBLOBEditorType;
  end;

var
  ibSHDataBlobForm: TibSHDataBlobForm;

implementation

uses ibSHComponentFrm, ibSHMessages;

type
  PTreeRec = ^TTreeRec;
  TTreeRec = record
    FieldName: string;
  end;

{$R *.dfm}

{ TibSHDataBlobForm }

constructor TibSHDataBlobForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  FCurrentField := nil;
  FBLOBEditorType := betNone;
  DBGrid := DBGridEh1;
//  EditorMsg := pSHSynEdit2;
  ResultEdit := pSHSynEdit2;
  ResultEdit.Lines.Clear;
  ResultEdit.OnGutterDraw := GutterDrawNotify;
  ResultEdit.GutterDrawer.ImageList := ImageList1;
  ResultEdit.GutterDrawer.Enabled := True;
  HideMessages;

  TEXTPanel.Align := alClient;
  RTFPanel.Align := alClient;
  SQLPanel.Align := alClient;
  ImagePanel.Align := alClient;
  ComboBox1.ItemIndex := 0;
  BLOBEditorType := betTEXT;

  Editor := SQLControl;
  RegisterEditors;
  CatchRunTimeOptionsDemon;
  DoOnOptionsChanged;
  SetTreeEvents;
  SetDataLinks;
//  BuildTree;

  FFieldImageIndex := Designer.GetImageIndex(IibSHField);

  TextControl.Font.Charset := RUSSIAN_CHARSET;

  FJPEGSource := TJpegImage.Create;
  FocusedControl := DBGrid;

  FBlobPopupMenu := TPopupMenu.Create(nil);
  FBlobPopupMenu.OnPopup := DoOnPopupBlobMenu;
  FillBlobPopupMenu;
  TextControl.PopupMenu := FBlobPopupMenu;
  RTFControl.PopupMenu := FBlobPopupMenu;
  SQLControl.PopupMenu := FBlobPopupMenu;
  ImageControl.PopupMenu := FBlobPopupMenu;

end;

destructor TibSHDataBlobForm.Destroy;
begin
  FBlobPopupMenu.Free;
  FJPEGSource.Free;
  inherited Destroy;
end;

procedure TibSHDataBlobForm.ControlBar1Resize(Sender: TObject);
begin
  ToolBar1.Width := ToolBar1.Parent.ClientWidth;
end;

procedure TibSHDataBlobForm.ComboBox1Change(Sender: TObject);
begin
  BLOBEditorType := TibSHBLOBEditorType(ComboBox1.ItemIndex);
end;

procedure TibSHDataBlobForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  DoOnIdle;
end;

procedure TibSHDataBlobForm.AnyControlChange(Sender: TObject);
begin
  if Assigned(StatusBar) and (StatusBar.Panels.Count >= 3) then
  begin
    if FBLOBEditorType = betText then
    begin
      StatusBar.Panels[0].Text := IntToStr(TextControl.CaretPos.Y) + ':  ' + IntToStr(TextControl.CaretPos.X); //Позиция курсора
      if TextControl.Modified then
        StatusBar.Panels[1].Text := Format(' Modified', [])                  //First space required!
      else
        StatusBar.Panels[1].Text := EmptyStr;
      if TextControl.ReadOnly then
        StatusBar.Panels[2].Text := Format(' Read only', [])                 //First space required!
      else
        StatusBar.Panels[2].Text := EmptyStr;
    end
    else
    if FBLOBEditorType = betRTF then
    begin
      StatusBar.Panels[0].Text := IntToStr(RTFControl.CaretPos.Y) + ':  ' + IntToStr(RTFControl.CaretPos.X); //Позиция курсора
      if RTFControl.Modified then
        StatusBar.Panels[1].Text := Format(' Modified', [])                  //First space required!
      else
        StatusBar.Panels[1].Text := EmptyStr;
      if RTFControl.ReadOnly then
        StatusBar.Panels[2].Text := Format(' Read only', [])                 //First space required!
      else
        StatusBar.Panels[2].Text := EmptyStr;
    end
    else
    if FBLOBEditorType = betBMP then //betSQL,
    begin
      StatusBar.Panels[0].Text := EmptyStr;
      StatusBar.Panels[1].Text := EmptyStr;
      case FImageFormat of
        imBitmap: StatusBar.Panels[2].Text := ' Bitmap';
        imJPEG: StatusBar.Panels[2].Text := ' JPEG';
        imWMF: StatusBar.Panels[2].Text := ' WMF';
        imEMF: StatusBar.Panels[2].Text := ' EMF';
        imICO: StatusBar.Panels[2].Text := ' ICO';
        else
          StatusBar.Panels[2].Text := EmptyStr;
      end;
//      Format(' Read only', [])                 //First space required!

    end;
  end;
end;

procedure TibSHDataBlobForm.SetBLOBEditorType(Value: TibSHBLOBEditorType);
begin
  if FBLOBEditorType <> Value then
  begin
    FBLOBEditorType := Value;
    TEXTPanel.Visible := False;
    RTFPanel.Visible := False;
    SQLPanel.Visible := False;
    ImagePanel.Visible := False;
    case FBLOBEditorType of
      betTEXT: TEXTPanel.Visible := True;
      betRTF: RTFPanel.Visible := True;
      betSQL: SQLPanel.Visible := True;
      betBMP: ImagePanel.Visible := True;
    end;
    SetDataField;
    AnyControlChange(nil);
  end;  
end;

procedure TibSHDataBlobForm.BuildTree;
var
  I: Integer;
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  if Assigned(Data) then
  begin
    Tree.BeginUpdate;
    try
      Tree.Clear;
      for I := 0 to Pred(Data.Dataset.Dataset.FieldCount) do
      begin
        if Data.Dataset.Dataset.Fields[I].DataType in [ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftOraBlob] then
        begin
          Node := Tree.AddChild(nil);
          NodeData := Tree.GetNodeData(Node);
          NodeData.FieldName := Data.Dataset.Dataset.Fields[I].FieldName;
        end;
      end;
      Node := Tree.GetFirst;
      if Assigned(Node) then
      begin
        Tree.FocusedNode := Node;
        Tree.Selected[Tree.FocusedNode] := True;
        SetDataField;
      end;
    finally
      Tree.EndUpdate;
    end;
  end;
end;

procedure TibSHDataBlobForm.SetTreeEvents;
begin
   Tree.Images := Designer.ImageList;
   Tree.OnClick := TreeClick;
   Tree.OnGetNodeDataSize := TreeGetNodeDataSize;
   Tree.OnFreeNode := TreeFreeNode;
   Tree.OnGetImageIndex := TreeGetImageIndex;
   Tree.OnGetText := TreeGetText;
   Tree.OnPaintText := TreePaintText;
   Tree.OnIncrementalSearch := TreeIncrementalSearch;
   Tree.OnDblClick := TreeDblClick;
   Tree.OnCompareNodes := TreeCompareNodes;
end;

procedure TibSHDataBlobForm.SetDataLinks;
begin
  dsGrid.DataSet := Data.Dataset.Dataset;
  dsTextControl.DataSet := Data.Dataset.Dataset;
  dsRTFControl.DataSet := Data.Dataset.Dataset;
  dsSQLControl.DataSet := Data.Dataset.Dataset;
  dsImageControl.DataSet := Data.Dataset.Dataset;
  DBNavigator1.DataSource := dsGrid;
end;

procedure TibSHDataBlobForm.SetDataField;
var
  Node: PVirtualNode;
  NodeData: PTreeRec;
begin
  Node := Tree.FocusedNode;
  if Assigned(Node) then
  begin
    NodeData := Tree.GetNodeData(Node);
    if Assigned(NodeData) then
    begin
      FCurrentField := Data.Dataset.Dataset.FindField(NodeData.FieldName);
      if Assigned(FCurrentField) then
        FCurrentField.FreeNotification(Self);
      TextControl.DataField := EmptyStr;
      RTFControl.DataField := EmptyStr;
      SQLControl.DataField := EmptyStr;
      case FBLOBEditorType of
        betTEXT:
          begin
            TextControl.DataField := NodeData.FieldName;
            TEXTPanel.Visible := True;
          end;
        betRTF:
          begin
            RTFControl.DataField := NodeData.FieldName;
            RTFPanel.Visible := True;
          end;
        betSQL:
          begin
            SQLControl.DataField := NodeData.FieldName;
            SQLPanel.Visible := True;
          end;
        betBMP:
          begin
            SafeShowPicture;
            ImagePanel.Visible := True;
          end;
      end;
    end;
  end
  else
  begin
    TEXTPanel.Visible := False;
    RTFPanel.Visible := False;
    SQLPanel.Visible := False;
    ImagePanel.Visible := False;

    TextControl.DataField := EmptyStr;
    RTFControl.DataField := EmptyStr;
    SQLControl.DataField := EmptyStr;
    if Assigned(FCurrentField) then
      RemoveFreeNotification(FCurrentField);
    FCurrentField := nil;
    SafeShowPicture;
  end;
end;

procedure TibSHDataBlobForm.SafeShowPicture;
var
  BlobStream: TStream;
begin
  if Assigned(dsImageControl.DataSet) and
     dsImageControl.DataSet.Active and
     Assigned(FCurrentField) and
     (FBLOBEditorType = betBMP) then
  begin
    BlobStream := dsImageControl.DataSet.CreateBlobStream(FCurrentField, bmRead);
    try
      ImageControl.Visible := False;
      ImagePanel.Width := 0;
      ImagePanel.Height := 0;
      ImagePanel.HorzScrollBar.Range := 0;
      ImagePanel.VertScrollBar.Range := 0;
      FImageFormat := GetImageStreamFormat(BlobStream);
      case FImageFormat of
        imBitmap: ImageControl.Picture.Bitmap.LoadFromStream(BlobStream);
        imJPEG:
          begin
            FJPEGSource.LoadFromStream(BlobStream);
            ImageControl.Picture.Graphic := FJPEGSource;
          end;
        imWMF, imEMF: ImageControl.Picture.Metafile.LoadFromStream(BlobStream);
        imICO: ImageControl.Picture.Icon.LoadFromStream(BlobStream);
      end;
      if FImageFormat <> imUnknown then
      begin
        ImagePanel.Width := ImageControl.Picture.Width + 2;
        ImagePanel.Height := ImageControl.Picture.Height + 2;
        ImagePanel.HorzScrollBar.Range := ImageControl.Picture.Width + 2;
        ImagePanel.VertScrollBar.Range := ImageControl.Picture.Height + 2;
        ImageControl.Visible := True;
      end;
    finally
      BlobStream.Free;
    end;
    AnyControlChange(nil);
  end;
end;

procedure TibSHDataBlobForm.ClearEditor;
begin
  Tree.Clear;
  if Assigned(ImageControl.Picture.Graphic) then
    ImageControl.Picture.Graphic := nil;
  ImageControl.Visible := False;  
  SetDataField;
end;

{ Tree }

procedure TibSHDataBlobForm.TreeClick(Sender: TObject);
begin
  SetDataField;
end;

procedure TibSHDataBlobForm.TreeGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeRec);
end;

procedure TibSHDataBlobForm.TreeFreeNode(Sender: TBaseVirtualTree;
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

procedure TibSHDataBlobForm.TreeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    case Column of
      0: if (Kind = ikNormal) or (Kind = ikSelected) then ImageIndex := FFieldImageIndex;
    end;
end;

procedure TibSHDataBlobForm.TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    case Column of
      0:
        case TextType of
          ttNormal: CellText := Data.FieldName;
          ttStatic: CellText := EmptyStr;
                    (*case Sender.GetNodeLevel(Node) of
                      0: ;
                      1: CellText := Data.Description;
                    end;*)
        end;
    end;
end;

procedure TibSHDataBlobForm.TreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if Assigned(Node) then
    case Column of
      0:
        case TextType of
          ttNormal: ;
          ttStatic: if Sender.Focused and (vsSelected in Node.States) then
                      TargetCanvas.Font.Color := clWindow
                    else
                      TargetCanvas.Font.Color := clGray;
        end;
    end;
end;

procedure TibSHDataBlobForm.TreeIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
  Data: PTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.FieldName)) <> 1 then Result := 1;
end;

procedure TibSHDataBlobForm.TreeDblClick(Sender: TObject);
begin

end;

procedure TibSHDataBlobForm.TreeCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PTreeRec;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  Result := CompareStr(Data1.FieldName, Data2.FieldName);
end;

procedure TibSHDataBlobForm.GutterDrawNotify(Sender: TObject;
  ALine: Integer; var ImageIndex: Integer);
begin
  if ALine = 0 then ImageIndex := 1;
end;

function TibSHDataBlobForm.IsDBGridSelected: Boolean;
begin
  Result := DBGrid.Focused or
            (Assigned(DBGrid.InplaceEditor) and
             DBGrid.InplaceEditor.Visible)
            or
            ((GetGridWideEditor<>nil) and TWinControl(GetGridWideEditor).Focused)

             ;
end;

procedure TibSHDataBlobForm.ShowMessages;
begin
  Panel7.Visible := True;
  Splitter3.Visible := True;
end;

procedure TibSHDataBlobForm.HideMessages;
begin
  Panel7.Visible := False;
  Splitter3.Visible := False;
end;

{ ISHFileCommands }

function TibSHDataBlobForm.GetCanOpen: Boolean;
begin
  Result := False;
  if Assigned(Data) and
     Assigned(Data.Dataset) and
     Data.Dataset.Active and
     Assigned(FCurrentField) then
  begin
    case FBLOBEditorType of
      betTEXT: Result := True;
      betRTF: Result := True;
      betSQL: Result := inherited GetCanOpen;
      betBMP: Result := True;
    end;
  end;
end;

function TibSHDataBlobForm.GetCanSave: Boolean;
begin
  Result := False;
  if IsDBGridSelected then
  begin
    Result := Assigned(SHCLDatabase) and (not SHCLDatabase.WasLostConnect) and
              Assigned(Data) and Data.Dataset.Active;
  end
  else
    if Assigned(Data) and
       Assigned(Data.Dataset) and
       Data.Dataset.Active and
       Assigned(FCurrentField) then
    begin
      case FBLOBEditorType of
        betTEXT: Result := True;
        betRTF: Result := True;
        betSQL: Result := inherited GetCanSave;
        betBMP: Result := Assigned(FCurrentField) and (not FCurrentField.IsNull);
      end;
    end;
end;

function TibSHDataBlobForm.GetCanSaveAs: Boolean;
begin
  Result := GetCanSave;
end;

function TibSHDataBlobForm.GetCanPrint: Boolean;
begin
  Result := False;
  if IsDBGridSelected then
  begin
    Result := GetCanSave
  end
  else
    if Assigned(Data) and
       Assigned(Data.Dataset) and
       Data.Dataset.Active and
       Assigned(FCurrentField) then
    begin
      case FBLOBEditorType of
        betTEXT: Result := False;
        betRTF: Result := True;
        betSQL: Result := inherited GetCanPrint;
        betBMP: Result := False;
      end;
    end;
end;

procedure TibSHDataBlobForm.Open;
var
  vFileStream: TFileStream;
  vBLOBStream: TStream;
begin
  if GetCanOpen then
  begin
    case FBLOBEditorType of
      betTEXT:
        begin
          if odText.Execute then
          begin
            if not (Data.Dataset.Dataset.State in [dsEdit, dsInsert]) then
              Data.Dataset.Dataset.Edit;
            try
              TextControl.Lines.LoadFromFile(odText.FileName);
            except
              Designer.ShowMsg(Format('%s', ['Cannot load from file.']), mtError);
            end;
          end;
        end;
      betRTF:
        begin
          if odRTF.Execute then
          begin
            try
              vFileStream := TFileStream.Create(odRTF.FileName, fmOpenRead);
              if not (Data.Dataset.Dataset.State in [dsEdit, dsInsert]) then
                Data.Dataset.Dataset.Edit;
              vBLOBStream := Data.Dataset.Dataset.CreateBlobStream(RTFControl.Field, bmWrite);
              try
                try
                  vBLOBStream.CopyFrom(vFileStream, vFileStream.Size);
                except
                  Designer.ShowMsg(Format('%s', ['Cannot load from RTF stream.']), mtError);
                end;
                RTFControl.LoadMemo;
              finally
                vFileStream.Free;
                vBLOBStream.Free;
              end;
            except
              Designer.ShowMsg(Format('%s', ['Cannot load from file.']), mtError);
            end;
          end;
        end;
      betSQL: inherited Open;
      betBMP:
        begin
          if odImage.Execute then
          begin
            try
              vFileStream := TFileStream.Create(odImage.FileName, fmOpenRead);
              if not (Data.Dataset.Dataset.State in [dsEdit, dsInsert]) then
                Data.Dataset.Dataset.Edit;
              vBLOBStream := Data.Dataset.Dataset.CreateBlobStream(FCurrentField, bmWrite);
              try
                try
                  vBLOBStream.CopyFrom(vFileStream, vFileStream.Size);
                except
                  Designer.ShowMsg(Format('%s', ['Cannot load from stream.']), mtError);
                end;
                SafeShowPicture;
              finally
                vFileStream.Free;
                vBLOBStream.Free;
              end;
            except
              Designer.ShowMsg(Format('%s', ['Cannot load from file.']), mtError);
            end;
          end;
        end;
    end;
  end;
end;

procedure TibSHDataBlobForm.Save;
begin
  SaveAs;
end;

procedure TibSHDataBlobForm.SaveAs;
var
  vFileStream: TFileStream;
  vBLOBStream: TStream;
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
  begin
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
    else
    case FBLOBEditorType of
      betTEXT:
        begin
          if sdText.Execute then
          begin
            try
              TextControl.Lines.SaveToFile(sdText.FileName);
            except
              Designer.ShowMsg(Format('%s', ['Cannot save file.']), mtError);
            end;
          end;
        end;
      betRTF:
        begin
          if sdRTF.Execute then
          begin
            try
              vFileStream := TFileStream.Create(sdRTF.FileName, fmCreate);
              vBLOBStream := Data.Dataset.Dataset.CreateBlobStream(RTFControl.Field, bmRead);
              try
                try
                  vFileStream.CopyFrom(vBLOBStream, vBLOBStream.Size);
                except
                  Designer.ShowMsg(Format('%s', ['Cannot load from BLOB stream.']), mtError);
                end;
              finally
                vFileStream.Free;
                vBLOBStream.Free;
              end;
            except
              Designer.ShowMsg(Format('%s', ['Cannot save file.']), mtError);
            end;
          end;
        end;
      betSQL: inherited SaveAs;
      betBMP:
        begin
          if sdImage.Execute then
          begin
            try
              vFileStream := TFileStream.Create(sdImage.FileName, fmCreate);
              vBLOBStream := Data.Dataset.Dataset.CreateBlobStream(FCurrentField, bmRead);
              try
                try
                  vFileStream.CopyFrom(vBLOBStream, vBLOBStream.Size);
                except
                  Designer.ShowMsg(Format('%s', ['Cannot load from BLOB stream.']), mtError);
                end;
              finally
                vFileStream.Free;
                vBLOBStream.Free;
              end;
            except
              Designer.ShowMsg(Format('%s', ['Cannot save file.']), mtError);
            end;
          end;
        end;
    end;
  end;
end;

procedure TibSHDataBlobForm.Print;
begin
  if GetCanPrint then
  begin
    if IsDBGridSelected then
    begin
      PrintDBGridEh1.Preview;
    end
    else
    case FBLOBEditorType of
      betTEXT: ;
      betRTF: RTFControl.Print(Format('%s', [RTFControl.Field.FieldName]));
      betSQL: inherited Print;
      betBMP: ;
    end;
  end;
end;

function TibSHDataBlobForm.GetCanUndo: Boolean;
begin
  if IsDBGridSelected then
  begin
    Result := GetCanSave and
              Assigned(DBGrid) and
              Assigned(DBGrid.InplaceEditor) and
              DBGrid.InplaceEditor.Visible and
              DBGrid.InplaceEditor.CanUndo;
  end
  else
  begin
    Result := Assigned(FCurrentField);
    if Result then
      case FBLOBEditorType of
        betTEXT: Result := TextControl.CanUndo;
        betRTF: Result := RTFControl.CanUndo;
        betSQL: inherited GetCanUndo;
        betBMP: ;
      end;
  end;
end;

function TibSHDataBlobForm.GetCanRedo: Boolean;
begin
  if IsDBGridSelected then
    Result := False
  else
  begin
    Result := Assigned(FCurrentField);
    if Result then
      case FBLOBEditorType of
        betTEXT: ;
        betRTF: ;
        betSQL: inherited GetCanRedo;
        betBMP: ;
      end;
  end;    
end;

function TibSHDataBlobForm.GetCanCut: Boolean;
begin
  if IsDBGridSelected then
  begin
    Result := inherited GetCanCut
  end
  else
  begin
    Result := GetCanCopy;
    if Result then
      case FBLOBEditorType of
        betTEXT: Result := not TextControl.Field.ReadOnly;
        betRTF: Result := not RTFControl.Field.ReadOnly;
        betSQL: Result := not  SQLControl.Field.ReadOnly;
        betBMP: Result := GetCanCopy and GetCanClearAll;
      end;
  end;    
end;

function TibSHDataBlobForm.GetCanCopy: Boolean;
begin
  if IsDBGridSelected then
  begin
    Result := inherited GetCanCopy
  end
  else
  begin
    Result := Assigned(FCurrentField);
    if Result then
      if GetCanSave then
        case FBLOBEditorType of
          betTEXT: Result := Length(TextControl.SelText) > 0;
          betRTF: Result := Length(RTFControl.SelText) > 0;
//          betSQL: Result := inherited GetCanCopy;
          betSQL: Result := Length(SQLControl.SelText) > 0;
          betBMP: Result := Assigned(ImageControl.Picture.Graphic);
        end;
  end;      
end;

function TibSHDataBlobForm.GetCanPaste: Boolean;
begin
  try
    if IsDBGridSelected then
    begin
      Result := inherited GetCanPaste
    end
    else
    begin
      Result := Assigned(FCurrentField);
      if Result then
        case FBLOBEditorType of
          betTEXT: Result := not TextControl.Field.ReadOnly and IsClipboardFormatAvailable(CF_TEXT);
          betRTF: Result := not RTFControl.Field.ReadOnly and IsClipboardFormatAvailable(CF_TEXT);
          betSQL: Result := not SQLControl.Field.ReadOnly and IsClipboardFormatAvailable(CF_TEXT);

//          betSQL: Result := inherited GetCanPaste;
          betBMP: Result := Assigned(FCurrentField) and (not FCurrentField.ReadOnly) and IsClipboardFormatAvailable(CF_BITMAP);
        end;
    end;
  except
    Result := False;
  end;
end;

function TibSHDataBlobForm.GetCanSelectAll: Boolean;
begin
  if IsDBGridSelected then
    Result := GetCanSave
  else
  begin
    Result := GetCanSave;
    if Result then
      case FBLOBEditorType of
{        betTEXT: ;
        betRTF: ;
        betSQL: inherited GetCanSelectAll;}
        betBMP: Result := False;
      end;
  end;
end;

function TibSHDataBlobForm.GetCanClearAll: Boolean;
begin
  if IsDBGridSelected then
  begin
    Result := False;
  end
  else
  begin
    Result := GetCanSave;
    if Result then
      case FBLOBEditorType of
        betTEXT: Result := not TextControl.Field.ReadOnly;
        betRTF: Result := not RTFControl.Field.ReadOnly;
//        betSQL: Result := inherited GetCanClearAll;
        betSQL: Result :=not SQLControl.Field.ReadOnly;

        betBMP: Result := (not FCurrentField.ReadOnly) and Assigned(ImageControl.Picture.Graphic);
      end;
  end;
end;

procedure TibSHDataBlobForm.Undo;
begin
  if GetCanUndo then
  begin
    if IsDBGridSelected then
      DBGrid.InplaceEditor.Undo
    else
    begin
      case FBLOBEditorType of
        betTEXT: TextControl.Undo;
        betRTF: RTFControl.Undo;
        betSQL: SQLControl.Undo;
        betBMP: ;
      end;
    end;
  end;
end;

procedure TibSHDataBlobForm.Redo;
begin
  if GetCanRedo then
  begin
    case FBLOBEditorType of
      betTEXT:  ;
      betRTF: ;
      betSQL: SQLControl.Redo;
      betBMP: ;
    end;
  end;
end;

procedure TibSHDataBlobForm.Cut;
begin
  if GetCanCut then
    if IsDBGridSelected then
      inherited
//      DBGrid.InplaceEditor.Perform(WM_CUT, 0, 0)
    else
    begin
      case FBLOBEditorType of
        betTEXT: TextControl.CutToClipboard;
        betRTF: RTFControl.CutToClipboard;
        betSQL: SQLControl.CutToClipboard;
        betBMP:
          begin
            Copy;
            ClearAll;
          end;
      end;
    end;
end;

procedure TibSHDataBlobForm.Copy;
var
  vFormat: Word;
  vData: THandle;
  vPalette: HPALETTE;
begin
  if GetCanCopy then
    if IsDBGridSelected then
    begin
      inherited
    end
    else
    begin
      case FBLOBEditorType of
        betTEXT: TextControl.CopyToClipboard;
        betRTF: RTFControl.CopyToClipboard;
        betSQL: SQLControl.CopyToClipboard;
        betBMP:
          begin
            ImageControl.Picture.Graphic.SaveToClipboardFormat(vFormat, vData, vPalette);
            ClipBoard.SetAsHandle(vFormat, vData);
          end;
      end;
    end;
end;

procedure TibSHDataBlobForm.Paste;
var
  vBLOBStream: TStream;
begin
  if GetCanPaste then
    if IsDBGridSelected then
    begin
      inherited
    end
    else
    begin
      case FBLOBEditorType of
        betTEXT: TextControl.PasteFromClipboard;
        betRTF: RTFControl.PasteFromClipboard;
        betSQL: SQLControl.PasteFromClipboard;
        betBMP:
          begin
            ImageControl.Picture.LoadFromClipBoardFormat(CF_BITMAP, ClipBoard.GetAsHandle(CF_BITMAP), 0);
            if not (Data.Dataset.Dataset.State in [dsEdit, dsInsert]) then
              Data.Dataset.Dataset.Edit;
            vBLOBStream := Data.Dataset.Dataset.CreateBlobStream(FCurrentField, bmWrite);
            try
              try
                ImageControl.Picture.Graphic.SaveToStream(vBLOBStream);
              except
                Designer.ShowMsg(Format('%s', ['Cannot save to stream.']), mtError);
              end;
              SafeShowPicture;
            finally
              vBLOBStream.Free;
            end;
          end;
      end;
    end;
end;

procedure TibSHDataBlobForm.SelectAll;
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
    begin
      case FBLOBEditorType of
        betTEXT: TextControl.SelectAll;
        betRTF: RTFControl.SelectAll;
        betSQL: SQLControl.SelectAll;
        betBMP: ;
      end;
    end;
end;

procedure TibSHDataBlobForm.ClearAll;
begin
  if GetCanClearAll then
  begin
    if not (Data.Dataset.Dataset.State in [dsEdit, dsInsert]) then
      Data.Dataset.Dataset.Edit;
    case FBLOBEditorType of
      betTEXT: TextControl.Clear;
      betRTF: RTFControl.Clear;
      betSQL: SQLControl.Clear;
      betBMP:
        begin
          if not (Data.Dataset.Dataset.State in [dsEdit, dsInsert]) then
            Data.Dataset.Dataset.Edit;
          FCurrentField.Clear;
          SafeShowPicture;        
        end;
    end;
  end;
end;

function TibSHDataBlobForm.GetCanFind: Boolean;
begin
  Result := Assigned(FCurrentField);
  if Result then
    case FBLOBEditorType of
      betTEXT: ;
      betRTF: ;
//      betSQL: inherited GetCanFind;
      betBMP: ;
    end;
end;

function TibSHDataBlobForm.GetCanReplace: Boolean;
begin
  Result := Assigned(FCurrentField);
  if Result then
    case FBLOBEditorType of
      betTEXT: ;
      betRTF: ;
//      betSQL: inherited GetCanReplace;
      betBMP: ;
    end;
end;

function TibSHDataBlobForm.GetCanSearchAgain: Boolean;
begin
  Result := Assigned(FCurrentField);
  if Result then
    case FBLOBEditorType of
      betTEXT: ;
      betRTF: ;
//      betSQL: inherited GetCanSearchAgain;
      betBMP: ;
    end;
end;

function TibSHDataBlobForm.GetCanSearchIncremental: Boolean;
begin
  Result := Assigned(FCurrentField);
  if Result then
    case FBLOBEditorType of
      betTEXT: ;
      betRTF: ;
//      betSQL: inherited GetCanSearchIncremental;
      betBMP: ;
    end;
end;

function TibSHDataBlobForm.GetCanGoToLineNumber: Boolean;
begin
  Result := Assigned(FCurrentField);
  if Result then
    case FBLOBEditorType of
      betTEXT: ;
      betRTF: ;
//      betSQL: inherited GetCanGoToLineNumber;
      betBMP: ;
    end;
end;

procedure TibSHDataBlobForm.Find;
begin
  case FBLOBEditorType of
    betTEXT: ;
    betRTF: ;
//    betSQL: inherited Find;
    betBMP: ;
  end;
end;

procedure TibSHDataBlobForm.Replace;
begin
  case FBLOBEditorType of
    betTEXT: ;
    betRTF: ;
//    betSQL: inherited Replace;
    betBMP: ;
  end;
end;

procedure TibSHDataBlobForm.SearchAgain;
begin
  case FBLOBEditorType of
    betTEXT: ;
    betRTF: ;
//    betSQL: inherited SearchAgain;
    betBMP: ;
  end;
end;

procedure TibSHDataBlobForm.SearchIncremental;
begin
  case FBLOBEditorType of
    betTEXT: ;
    betRTF: ;
//    betSQL: inherited SearchIncremental;
    betBMP: ;
  end;
end;

procedure TibSHDataBlobForm.GoToLineNumber;
begin
  case FBLOBEditorType of
    betTEXT: ;
    betRTF: ;
//    betSQL: inherited GoToLineNumber;
    betBMP: ;
  end;
end;

procedure TibSHDataBlobForm.SetDBGridOptions(ADBGrid: TComponent);
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

procedure TibSHDataBlobForm.DoOnPopupBlobMenu(Sender: TObject);
//var
//  vCurrentMenuItem: TMenuItem;
begin
  MenuItemByName(FBlobPopupMenu.Items, SOpenFile).Enabled := GetCanOpen;
  MenuItemByName(FBlobPopupMenu.Items, SSaveToFile).Enabled := GetCanSave;
  MenuItemByName(FBlobPopupMenu.Items, SCut).Enabled := GetCanCut;
  MenuItemByName(FBlobPopupMenu.Items, SCopy).Enabled := GetCanCopy;
  MenuItemByName(FBlobPopupMenu.Items, SPaste).Enabled := GetCanPaste;
    MenuItemByName(FBlobPopupMenu.Items, SUndo).Enabled := GetCanUndo;
    MenuItemByName(FBlobPopupMenu.Items, SRedo).Enabled := GetCanRedo;
    MenuItemByName(FBlobPopupMenu.Items, SSelectAll).Enabled := GetCanSelectAll;

  MenuItemByName(FBlobPopupMenu.Items, SPrint).Enabled := GetCanPrint;
//  vCurrentMenuItem := MenuItemByName(FBlobPopupMenu.Items, SOtherEdit);
//    MenuItemByName(vCurrentMenuItem, SUndo).Enabled := GetCanUndo;
//    MenuItemByName(vCurrentMenuItem, SRedo).Enabled := GetCanRedo;
//    MenuItemByName(vCurrentMenuItem, SSelectAll).Enabled := GetCanSelectAll;
end;

procedure TibSHDataBlobForm.FillBlobPopupMenu;
//var
//  vCurrentItem: TMenuItem;
begin
  AddMenuItem(FBlobPopupMenu.Items, SOpenFile, mnOpenFileClick, ShortCut(Ord('O'), [ssCtrl]));
  AddMenuItem(FBlobPopupMenu.Items, SSaveToFile, mnSaveToFileClick, ShortCut(Ord('S'), [ssCtrl]));
  AddMenuItem(FBlobPopupMenu.Items, '-', nil, 0, 21);
  AddMenuItem(FBlobPopupMenu.Items, SCut, mnCut, ShortCut(Ord('X'), [ssCtrl]));
  AddMenuItem(FBlobPopupMenu.Items, SCopy, mnCopy, ShortCut(Ord('C'), [ssCtrl]));
  AddMenuItem(FBlobPopupMenu.Items, SPaste, mnPaste, ShortCut(Ord('V'), [ssCtrl]));

    AddMenuItem(FBlobPopupMenu.Items, '-', nil, 0, 22);
    AddMenuItem(FBlobPopupMenu.Items, SUndo, mnUndo, ShortCut(Ord('Z'), [ssCtrl]));
    AddMenuItem(FBlobPopupMenu.Items, SRedo, mnRedo, ShortCut(Ord('Z'), [ssShift, ssCtrl]));
    AddMenuItem(FBlobPopupMenu.Items, '-', nil, 0, 23);
    AddMenuItem(FBlobPopupMenu.Items, SSelectAll, mnSelectAll, ShortCut(Ord('A'), [ssCtrl]));

  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 8);
  AddMenuItem(FBlobPopupMenu.Items, SPrint, mnPrintClick, ShortCut(Ord('P'), [ssCtrl]));

//  vCurrentItem := AddMenuItem(FBlobPopupMenu.Items, SOtherEdit);
//    AddMenuItem(vCurrentItem, SUndo, mnUndo, ShortCut(Ord('Z'), [ssCtrl]));
//    AddMenuItem(vCurrentItem, SRedo, mnRedo, ShortCut(Ord('Z'), [ssShift, ssCtrl]));
//    AddMenuItem(vCurrentItem, '-', nil, 0, 23);
//    AddMenuItem(vCurrentItem, SSelectAll, mnSelectAll, ShortCut(Ord('A'), [ssCtrl]));
end;

procedure TibSHDataBlobForm.OnFetchRecord(ADataset: IibSHDRVDataset);
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

procedure TibSHDataBlobForm.DoUpdateStatusBarByState(
  Changes: TSynStatusChanges);
begin
  if (FBLOBEditorType = betSQL) then
    inherited DoUpdateStatusBarByState(Changes);
end;

procedure TibSHDataBlobForm.DoUpdateStatusBar;
begin
  inherited DoUpdateStatusBar;
end;

procedure TibSHDataBlobForm.DoOnIdle;
begin
  inherited DoOnIdle;
//  tbCommit.Visible :=  (not AutoCommit);
//  tbRollback.Visible :=  (not AutoCommit);
//  ToolButton4.Visible := (not AutoCommit);
//  actPause.Enabled := GetCanPause;
//  actCommit.Enabled := GetCanCommit;
//  actRollback.Enabled := GetCanRollback;
//  actRefresh.Enabled := GetCanRefresh;
//  actFilter.Enabled := Assigned(Data) and Data.Dataset.Active;
  if (not GetCanCommit) then ClearEditor;
  DoUpdateStatusBar;
end;

function TibSHDataBlobForm.DoOnOptionsChanged: Boolean;
var
  vEditorGeneralOptions: ISHEditorGeneralOptions;
begin
  Result := inherited DoOnOptionsChanged;
  if Result and Supports(Designer.GetDemon(ISHEditorGeneralOptions), ISHEditorGeneralOptions, vEditorGeneralOptions) then
  begin
    TextControl.WordWrap := vEditorGeneralOptions.WordWrap;
    RTFControl.WordWrap := vEditorGeneralOptions.WordWrap;
  end;
end;

function TibSHDataBlobForm.GetCanDestroy: Boolean;
begin
  Result := True;
  if Supports(Component, IibSHSQLEditor) then
  begin
    if (not Designer.ExistsComponent(Component, SCallQueryResults)) and
      (not Designer.ExistsComponent(Component, SCallDataForm)) then
      Result := inherited GetCanDestroy;
  end
  else
  begin
    if (not Designer.ExistsComponent(Component, SCallData)) and
      (not Designer.ExistsComponent(Component, SCallDataForm)) then
      Result := inherited GetCanDestroy;
  end;
end;

procedure TibSHDataBlobForm.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FCurrentField) then
    ClearEditor;
end;

procedure TibSHDataBlobForm.BringToTop;
var
  vTestNode: PVirtualNode;
begin
  if Assigned(Data) then
    Data.Dataset.DatasetNotification := Self as IibDRVDatasetNotification;
  inherited BringToTop;
  if StatusBar.Panels.Count >= 2 then StatusBar.Panels[1].Width := 150;
  vTestNode := Tree.GetFirst;
  if not Assigned(vTestNode) then
    BuildTree;    
end;

procedure TibSHDataBlobForm.ShowResult(AEnableFetchEvent: Boolean);
begin
  inherited ShowResult(AEnableFetchEvent);
  BuildTree;
end;


procedure TibSHDataBlobForm.dsImageControlDataChange(Sender: TObject;
  Field: TField);
begin
  SafeShowPicture;
end;

procedure TibSHDataBlobForm.pmiHideMessageClick(Sender: TObject);
begin
  HideMessages;
end;

end.
