unit ibSHComponentFrm;

interface

uses
  Messages, SysUtils, Classes, Controls, Forms, ComCtrls, CommCtrl, ExtCtrls,
  Types, ActnList, Windows, Graphics, Dialogs, Menus, Clipbrd, FileCtrl, Printers,
  SynEdit, SynEditTypes, SynExportHTML, SynEditExport, SynExportRTF, SynEditKeyCmds,
  SHDesignIntf, SHOptionsIntf, SHEvents, ibSHDesignIntf,
  pSHIntf, pSHCommon, pSHSynEdit, ibSHConsts, ibSHMessages, SynEditPrint,SynEditTextBuffer;

type
  TibBTComponentForm = class(TSHComponentForm,  ISHFileCommands, ISHEditCommands, ISHSearchCommands, ISHRunCommands)
  private
    FFocusedControl: TWinControl;
    FEditor: TpSHSynEdit;
    FEditorMsg: TpSHSynEdit;
    FFlat: Boolean;
    FPageCtrl: TPageControl;
    FPageCtrlWndProc: TWndMethod;
    FErrorCoord: TBufferCoord;
    FCurrentLineColor: TColor;
    FErrorLineColor: TColor;
    FBlockErrorCoordReset: Boolean;
    procedure PageCtrlWndProc(var Message: TMessage);
    function GetEditor: TpSHSynEdit;
    procedure SetEditor(Value: TpSHSynEdit);
    function GetEditorMsg: TpSHSynEdit;
    procedure SetEditorMsg(Value: TpSHSynEdit);
    function GetFlat: Boolean;
    procedure SetFlat(Value: Boolean);
    function GetPageCtrl: TPageControl;
    procedure SetPageCtrl(Value: TPageControl);
    procedure WMMoving(var Message: TWMMoving); message WM_MOVING;
    procedure RegisterEditor(AEditor: TComponent);
    procedure SetErrorCoord(const Value: TBufferCoord);
  protected
    FSynEditPrint: TSynEditPrint;
    FPrintDialog: TPrintDialog;
    FCurrentFile: string;
    FSaveDialog: TSaveDialog;
    FOpenDialog: TOpenDialog;
    FExporterRTF: TSynExporterRTF;
    FExporterHTML: TSynExporterHTML;
    FEditorPopupMenu: TPopupMenu;
    FPreviosToggleCase: TpSHCaseCode;
    FDragPopUpMenu    :TPopupMenu;
    FDragMenuItem     :integer;
    procedure Resize; override;
    function GetCurrentFile: string; virtual;
    procedure RegisterEditors; virtual;
    procedure EditorMsgVisible(AShow: Boolean = True); virtual;
    function GetEditorMsgVisible: Boolean; virtual;
    procedure EditorMsgMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;

    { ISHFileCommands }
    function GetCanNew: Boolean; virtual;
    function GetCanOpen: Boolean; virtual;
    function GetCanSave: Boolean; virtual;
    function GetCanSaveAs: Boolean; virtual;
    function GetCanPrint: Boolean; virtual;

    procedure New; virtual;
    procedure Open; virtual;
    procedure Save; virtual;
    procedure SaveAs; virtual;
    procedure Print; virtual;

    { ISHEditCommands }
    function GetCanUndo: Boolean; virtual;
    function GetCanRedo: Boolean; virtual;
    function GetCanCut: Boolean; virtual;
    function GetCanCopy: Boolean; virtual;
    function GetCanPaste: Boolean; virtual;
    function GetCanSelectAll: Boolean; virtual;
    function GetCanClearAll: Boolean; virtual;

    procedure Undo; virtual;
    procedure Redo; virtual;
    procedure Cut; virtual;
    procedure Copy; virtual;
    procedure Paste; virtual;
    procedure SelectAll; virtual;
    procedure ClearAll; virtual;

    { ISHSearchCommands }
    function GetCanFind: Boolean; virtual;
    function GetCanReplace: Boolean; virtual;
    function GetCanSearchAgain: Boolean; virtual;
    function GetCanSearchIncremental: Boolean; virtual;
    function GetCanGoToLineNumber: Boolean; virtual;

    procedure Find; virtual;
    procedure Replace; virtual;
    procedure SearchAgain; virtual;
    procedure SearchIncremental; virtual;
    procedure GoToLineNumber; virtual;

    { ISHRunCommands }
    function GetCanRun: Boolean; virtual;
    function GetCanPause: Boolean; virtual;
    function GetCanCreate: Boolean; virtual;
    function GetCanAlter: Boolean; virtual;
    function GetCanClone: Boolean; virtual;
    function GetCanDrop: Boolean; virtual;
    function GetCanRecreate: Boolean; virtual;
    function GetCanDebug: Boolean; virtual;
    function GetCanCommit: Boolean; virtual;
    function GetCanRollback: Boolean; virtual;
    function GetCanRefresh: Boolean; virtual;

    procedure Run; virtual;
    procedure Pause; virtual;
    procedure ISHRunCommands.Create = ICreate;
    procedure ICreate; virtual;
    procedure Alter; virtual;
    procedure Clone; virtual;
    procedure Drop; virtual;
    procedure Recreate; virtual;
    procedure Debug; virtual;
    procedure Commit; virtual;
    procedure Rollback; virtual;
    procedure Refresh; virtual;
    procedure ShowHideRegion(AVisible: Boolean); virtual;


    procedure SetStatusBar(Value: TStatusBar); override;

    procedure DoOnIdle; virtual;
    function DoOnOptionsChanged: Boolean; virtual;
    procedure DoOnBeforeModalClose(Sender: TObject; var ModalResult: TModalResult;
      var Action: TCloseAction); virtual;
    procedure DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult); virtual;
    procedure DoUpdateStatusBarByState(Changes: TSynStatusChanges); virtual;
    procedure DoOnEditorStatusChange(Sender: TObject;
      Changes: TSynStatusChanges);
    procedure DoOnFindTextChange(Sender: TObject; AIsSearchIncremental: Boolean;
      const AText: string);
    procedure DoOnSpecialLineColors(Sender: TObject;
      Line: Integer; var Special: Boolean; var FG, BG: TColor); virtual;
//Drag
    procedure DoOnDragOver(Sender, Source: TObject;
     X, Y: Integer; State: TDragState; var Accept: Boolean);virtual;
    procedure DoOnDragDrop(Sender, Source: TObject; X, Y: Integer);virtual;



    procedure CheckFileInEditorModified; virtual;
    procedure DoSaveToFile(AFileName: string);
    procedure DoOpenFile(AFileName: string);
    procedure DoAfterLoadFile; virtual;
    procedure ShowFileName;
    function DoOnGetInitialDir: string; virtual;
    procedure AddToOpenedFileHistory(AFileName: string); virtual;
    function AddMenuItem(AParentMenuItems: TMenuItem; ACaption: string;
      AOnClick: TNotifyEvent = nil; AShortCut: TShortCut = 0;
      ATag: Integer = 0): TMenuItem;
    function MenuItemByName(AMenuItem: TMenuItem; ACaption: string;
      ATag: Integer = -1): TMenuItem;
    procedure FillPopupMenu; virtual;
    procedure DoOnPopup(Sender: TObject); virtual;
    //Popup menu methods
    procedure mnFindDeclarationClick(Sender: TObject);
    procedure mnOpenFileClick(Sender: TObject);
    procedure mnSaveToFileClick(Sender: TObject);
    procedure mnSaveAsToFileClick(Sender: TObject);
    procedure mnSaveAsToTemplateClick(Sender: TObject); virtual;    
    procedure mnCopyTextasRTFClick(Sender: TObject);
    procedure mnCopyTextasHTMLClick(Sender: TObject);
    procedure mnCopyTextasDelphiClick(Sender: TObject);
    procedure mnCut(Sender: TObject);
    procedure mnCopy(Sender: TObject);
    procedure mnPaste(Sender: TObject);
    procedure mnPasteDelphiString(Sender: TObject);    
    procedure mnUndo(Sender: TObject);
    procedure mnRedo(Sender: TObject);
    procedure mnClearAll(Sender: TObject);
    procedure mnSelectAll(Sender: TObject);
    procedure mnFind(Sender: TObject);
    procedure mnReplace(Sender: TObject);
    procedure mnSearchAgain(Sender: TObject);
    procedure mnIncrementalSearch(Sender: TObject);
    procedure mnGotoLineNumber(Sender: TObject);

    procedure mnToggleBookmarksClick(Sender: TObject);
    procedure mnGotoBookmarksClick(Sender: TObject);
    procedure mnCommentselectedClick(Sender: TObject);
    procedure mnCommentLineClick(Sender: TObject);
    procedure mnUncommentselectedClick(Sender: TObject);
    procedure mnToLowercaseClick(Sender: TObject);
    procedure mnToUppercaseClick(Sender: TObject);
    procedure mnToNamecaseClick(Sender: TObject);
    procedure mnInvertCaseClick(Sender: TObject);
    procedure mnToggleCaseClick(Sender: TObject);
    procedure mnPrintClick(Sender: TObject);
    procedure mnShowPropertiesClick(Sender: TObject);
    procedure mnShowHideMessagesClick(Sender: TObject);
    procedure mnOpenHistoryFileClick(Sender: TObject);

    procedure ToggleBookmark(ABookmarkNo: Integer);
    procedure GotoBookmark(ABookmarkNo: Integer);
    procedure CommentSelected;
    procedure UnCommentSelected;
    procedure CommentUnComment;
    procedure CommentUnCommentLine;
    procedure ConvertCase(ANewCase: TpSHCaseCode);
    procedure ShowProperties; virtual;

    property EditorPopupMenu: TPopupMenu read FEditorPopupMenu;
    property CurrentFile: string read GetCurrentFile write FCurrentFile;
  public
//    constructor Create(AOwner: TComponent); overload; override;

    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); {reintroduce;} override;
    destructor Destroy; override;

    procedure BringToTop; override;
    function ReceiveEvent(AEvent: TSHEvent): Boolean; override;
    function GetErrorCoord(AErrorText: string): TBufferCoord;
    procedure SetFormSize(const H, W: Integer);

    procedure DoOnDragMenuClick(Sender:TObject);
    property FocusedControl: TWinControl read FFocusedControl write FFocusedControl;
    property EditorMsg: TpSHSynEdit read GetEditorMsg write SetEditorMsg;
    property Flat: Boolean read GetFlat write SetFlat;
    property PageCtrl: TPageControl read GetPageCtrl write SetPageCtrl;

    property ErrorCoord: TBufferCoord read FErrorCoord
      write SetErrorCoord;
    property ErrorLineColor: TColor read FErrorLineColor;
    property CurrentLineColor: TColor read FCurrentLineColor;
  published
    { Published declarations }
    property Editor: TpSHSynEdit read GetEditor write SetEditor;
  end;


implementation

{ TibBTComponentForm }

constructor TibBTComponentForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  I: Integer;
  mi:TMenuItem;
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  if Assigned(ModalForm) then
  begin
    SetFormSize(380, 420);
    ModalForm.OnBeforeModalClose := DoOnBeforeModalClose;
    ModalForm.OnAfterModalClose := DoOnAfterModalClose;
  end;
  Designer.AntiLargeFont(Self);

  for I := 0 to Pred(ComponentCount) do
  begin
    if Components[I] is TAction then
      with Components[I] as TAction do
      begin
        Hint := Caption;
        Enabled := False;
      end;
    if Components[I] is TToolButton then
      with Components[I] as TToolButton do  ShowHint := True;
  end;

  FErrorCoord.Char := -1;
  FErrorCoord.Line := -1;
  FBlockErrorCoordReset := False;

  FSaveDialog := TSaveDialog.Create(nil);
  FSaveDialog.DefaultExt := 'sql';
  FSaveDialog.Filter :=
    'SQL Files (*.sql)|*.sql|Text Files (*.txt)|*.txt|Rich Text (*.rtf)|*.rtf|HTML Document (*.htm,*.html)|*.htm;*.html|Any Files (*.*)|*.*';
  FSaveDialog.FilterIndex := 1;
  FSaveDialog.Options := [ofOverwritePrompt,ofEnableSizing];
  FSaveDialog.OptionsEx := [];
  FSaveDialog.Title := 'Save As';

  FOpenDialog := TOpenDialog.Create(nil);
  FOpenDialog.DefaultExt := 'sql';
  FOpenDialog.Filter := 'SQL Files (*.sql)|*.sql|Text Files (*.txt)|*.txt|Any Files (*.*)|*.*';
  FOpenDialog.FilterIndex := 1;
  FOpenDialog.Options := [ofExtensionDifferent,ofFileMustExist,ofEnableSizing];
  FOpenDialog.OptionsEx := [];
  FOpenDialog.Title := 'Open SQL File';
  FExporterRTF := TSynExporterRTF.Create(nil);
  FExporterHTML := TSynExporterHTML.Create(nil);
  FCurrentFile := '';

  FEditorPopupMenu := TPopupMenu.Create(nil);
  FEditorPopupMenu.OnPopup := DoOnPopup;
  FillPopupMenu;
  FPreviosToggleCase := ccToggle;
  FSynEditPrint := TSynEditPrint.Create(Self);
  FPrintDialog := TPrintDialog.Create(Self);
  FPrintDialog.Collate := True;
  FPrintDialog.MaxPage := 10000;
  FPrintDialog.Options := [poPageNums, poWarning];
  FDragPopUpMenu       :=TPopUpMenu.Create(Self);
  mi:=TMenuItem.Create(nil);
  mi.Caption:='Name';
  mi.Tag:=1;
  mi.OnClick:=DoOnDragMenuClick;
  FDragPopUpMenu.Items.Add(mi);
end;

destructor TibBTComponentForm.Destroy;
begin
  FEditorPopupMenu.Free;
  FExporterRTF.Free;
  FExporterHTML.Free;
  FSaveDialog.Free;
  FOpenDialog.Free;
  inherited Destroy;
end;

procedure TibBTComponentForm.PageCtrlWndProc(var Message: TMessage);
begin
  with Message do
    if Msg = TCM_ADJUSTRECT then
    begin
      FPageCtrlWndProc(Message);
      PRect(LParam)^.Left := 0;
      PRect(LParam)^.Right := FPageCtrl.Parent.ClientWidth;
      PRect(LParam)^.Top := PRect(LParam)^.Top - 3;
      PRect(LParam)^.Bottom := FPageCtrl.Parent.ClientHeight;
    end else
      FPageCtrlWndProc(Message);
end;

function TibBTComponentForm.GetEditor: TpSHSynEdit;
begin
  Result := FEditor;
end;

procedure TibBTComponentForm.SetEditor(Value: TpSHSynEdit);
begin
  if FEditor <> Value then
  begin
    if Assigned(FEditor) then
    begin
      FEditor.OnStatusChange := nil;
      FEditor.OnFindTextChange := nil;
      FEditor.OnSpecialLineColors := nil;
      FEditor.PopupMenu := nil;
      FEditor.OnDragDrop:= nil;
      FEditor.OnDragOver:=nil;
      FEditor.OnMouseMove:=nil;
    end;
    FEditor := Value;
    if Assigned(FEditor) then
    begin
      FEditor.OnStatusChange := DoOnEditorStatusChange;
      FEditor.OnFindTextChange := DoOnFindTextChange;
      FEditor.OnSpecialLineColors := DoOnSpecialLineColors;
      FEditor.PopupMenu := FEditorPopupMenu;
      FEditor.OnDragOver:= DoOnDragOver;
      FEditor.OnDragDrop:= DoOnDragDrop;
    end;
  end;
end;

function TibBTComponentForm.GetEditorMsg: TpSHSynEdit;
begin
  Result := FEditorMsg;
end;

procedure TibBTComponentForm.SetEditorMsg(Value: TpSHSynEdit);
begin
  FEditorMsg := Value;
  if Assigned(FEditorMsg) then
    FEditorMsg.OnMouseDown := EditorMsgMouseDown;
end;

function TibBTComponentForm.GetFlat: Boolean;
begin
  Result := FFlat;
end;

procedure TibBTComponentForm.SetFlat(Value: Boolean);
begin
  FFlat := Value;
  if FFlat then
  begin
    if Assigned(FPageCtrl) then
    begin
      FPageCtrlWndProc := FPageCtrl.WindowProc;
      FPageCtrl.WindowProc := PageCtrlWndProc;
    end;
  end else
  begin
    if Assigned(FPageCtrl) then
    begin
      FPageCtrlWndProc := FPageCtrl.WindowProc;
      FPageCtrl.WindowProc := FPageCtrlWndProc;
    end;
  end;
end;

function TibBTComponentForm.GetPageCtrl: TPageControl;
begin
  Result := FPageCtrl;
end;

procedure TibBTComponentForm.SetPageCtrl(Value: TPageControl);
begin
  FPageCtrl := Value;
end;

procedure TibBTComponentForm.WMMoving(var Message: TWMMoving);
begin
  inherited;//необходимо нотифицировать эдитор(?), для перемещения ProposalHint
end;

procedure TibBTComponentForm.RegisterEditor(AEditor: TComponent);
var
  vEditorRegistrator: IibSHEditorRegistrator;
  vBTCLDatabase: IibSHDatabase;
begin
  if Assigned(AEditor) and Supports(Component, IibSHDatabase, vBTCLDatabase) and
    Supports(Designer.GetDemon(IibSHEditorRegistrator), IibSHEditorRegistrator, vEditorRegistrator) then
    vEditorRegistrator.RegisterEditor(AEditor, vBTCLDatabase.BTCLServer, vBTCLDatabase);
end;

procedure TibBTComponentForm.SetErrorCoord(const Value: TBufferCoord);
begin
  if (FErrorCoord.Char <> Value.Char) or (FErrorCoord.Line <> Value.Line) then
  begin
    FErrorCoord := Value;
    if Assigned(Editor) then
    begin
      if (FErrorCoord.Char > 0) or (FErrorCoord.Line > -1) then
      begin
        FErrorCoord.Char := FErrorCoord.Char;
        FBlockErrorCoordReset := True;
        Editor.CaretXY := FErrorCoord;
        Editor.EnsureCursorPosVisibleEx(True);
        FBlockErrorCoordReset := False;
      end;
      Editor.Invalidate;
    end;
  end;
end;

procedure TibBTComponentForm.RegisterEditors;
begin
  RegisterEditor(FEditor);
end;

procedure TibBTComponentForm.EditorMsgVisible(AShow: Boolean = True);
begin
// Empty
end;

function TibBTComponentForm.GetEditorMsgVisible: Boolean;
begin
  if Assigned(EditorMsg) then
    Result := EditorMsg.Visible and Assigned(EditorMsg.Parent) and
      EditorMsg.Parent.Visible
  else
    Result := False;
end;

procedure TibBTComponentForm.EditorMsgMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

// Убрать нахер?

//  if Button = mbMiddle then
//  begin
//    if Assigned(FocusedControl) and FocusedControl.CanFocus then FocusedControl.SetFocus;
//    EditorMsgVisible(False);
//  end;
end;

procedure TibBTComponentForm.Resize;
begin
  inherited Resize;
  ShowFileName;
end;

function TibBTComponentForm.GetCurrentFile: string;
begin
  Result := FCurrentFile;
end;

procedure TibBTComponentForm.SetStatusBar(Value: TStatusBar);
begin
  inherited SetStatusBar(Value);
  
  if Assigned(StatusBar) then
  begin
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
//        with Add do ;
        with Add do Width := 150;
        with Add do Alignment := taLeftJustify;
      end;
    end;
  end;
end;

procedure TibBTComponentForm.DoOnIdle;
begin
// Empty
end;

function TibBTComponentForm.DoOnOptionsChanged: Boolean;
var
  vEditorColorOptions: ISHEditorColorOptions;
begin
  Result := True;
  RegisterEditors;
  if Assigned(Editor) and
    Supports(Designer.GetDemon(ISHEditorColorOptions), ISHEditorColorOptions, vEditorColorOptions) then
  begin
    FCurrentLineColor := vEditorColorOptions.CurrentLine;
    FErrorLineColor := vEditorColorOptions.ErrorLine;
  end;
end;

procedure TibBTComponentForm.DoOnBeforeModalClose(Sender: TObject; var ModalResult: TModalResult;
  var Action: TCloseAction);
begin
// Empty
end;

procedure TibBTComponentForm.DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult);
begin
// Empty
end;

procedure TibBTComponentForm.DoUpdateStatusBarByState(
  Changes: TSynStatusChanges);
begin
  if Assigned(StatusBar) and Assigned(Editor) and (StatusBar.Panels.Count > 2) then
  begin
    if Changes * [scCaretX, scCaretY] <> [] then
    begin
      StatusBar.Panels[0].Text := IntToStr(Editor.CaretY) + ':  ' + IntToStr(Editor.CaretX);
      if (not FBlockErrorCoordReset) and ((ErrorCoord.Char > 0) or (ErrorCoord.Line > -1)) then
        ErrorCoord := TBufferCoord(Point(0, -1));
    end;

//    if (Changes * [scModified] <> []) and
//       ((ErrorCoord.Char > 0) or (ErrorCoord.Line > -1)) then
//      ErrorCoord := TBufferCoord(Point(0, -1));


    if (Changes * [scAll, scModified] <> []) then
    begin
      if Editor.Modified then
        StatusBar.Panels[1].Text := Format(' Modified', [])                  //First space required!
      else
        StatusBar.Panels[1].Text := '';
    end;

    if Editor.ReadOnly then
    begin
      StatusBar.Panels[2].Text := ' Read only'                   //First space required!
    end else
    begin
//      if Changes * [scInsertMode] <> [] then
//      begin
        if Editor.InsertMode then
          StatusBar.Panels[2].Text := ' Insert'                  //First space required!
        else
          StatusBar.Panels[2].Text := ' Overwrite';              //First space required!;
//      end;
    end;

{    if  Editor.SelectionMode=smColumn then
     StatusBar.Panels[3].Text:=' Select columns'
    else
     StatusBar.Panels[3].Text:=' Select Lines';}
    ShowFileName;
  end;
end;

procedure TibBTComponentForm.DoOnEditorStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  DoUpdateStatusBarByState(Changes);
end;

procedure TibBTComponentForm.DoOnFindTextChange(Sender: TObject;
  AIsSearchIncremental: Boolean; const AText: string);
var
  vBufDesc: string;
begin
  if AIsSearchIncremental then
    vBufDesc := ' Inc.Search buffer: '
  else
    vBufDesc := ' Search buffer: ';
  if Assigned(StatusBar) and (StatusBar.Panels.Count > 3) then
  begin
    if (Length(AText) > 0) or AIsSearchIncremental then
      StatusBar.Panels[3].Text := Format(vBufDesc + '%s', [AText])
    else
      if (Pos(' Search buffer: ', StatusBar.Panels[3].Text) = 1) or
         (Pos(' Inc.Search buffer: ', StatusBar.Panels[3].Text) = 1) then
        StatusBar.Panels[3].Text := '';
  end;
end;

procedure TibBTComponentForm.DoOnSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
begin
  if FErrorCoord.Line = Line then
  begin
    FG := clWhite;
    BG := FErrorLineColor;
    Special := True;
  end;
end;

procedure TibBTComponentForm.CheckFileInEditorModified;
begin
  if Assigned(Editor) and Editor.Modified then
    if Designer.ShowMsg(SFileModified, mtConfirmation) then
      Save;
end;

procedure TibBTComponentForm.DoSaveToFile(AFileName: string);
var
  S: string;
begin
  if Assigned(Editor) then
  begin
    S := ExtractFileExt(AFileName);
    if AnsiSameText(S, '.rtf') then
    begin
      FExporterRTF.Highlighter := Editor.Highlighter;
      FExporterRTF.ExportAsText := False;
      FExporterRTF.ExportAll(Editor.Lines);
      FExporterRTF.SaveToFile(AFileName);
      FExporterRTF.Highlighter := nil;
    end
    else
    if AnsiSameText(S, '.htm') or AnsiSameText(S, '.html') then
    begin
      FExporterHTML.Highlighter := Editor.Highlighter;
      FExporterHTML.ExportAsText := True;
      FExporterHTML.ExportAll(Editor.Lines);
      FExporterHTML.SaveToFile(AFileName);
    end
    else
      Editor.Lines.SaveToFile(AFileName);
    Editor.Modified := False;
  end;
end;

procedure TibBTComponentForm.DoOpenFile(AFileName: string);
var
  vDoLoad: Boolean;
begin
  if GetCanOpen then
  begin
//    FFileWasLoaded := False;
    CheckFileInEditorModified;
    vDoLoad := Length(AFileName) > 0;

    if (not vDoLoad) then
    begin
      FOpenDialog.InitialDir := DoOnGetInitialDir;
      vDoLoad := FOpenDialog.Execute;
      Update;
      if vDoLoad then
        CurrentFile := FOpenDialog.FileName;
    end
    else
      CurrentFile := AFileName;
    if vDoLoad and (Length(CurrentFile) > 0) then
    begin
      Screen.Cursor := crHourGlass;
      try
        Editor.Lines.LoadFromFile(CurrentFile);
//        FFileWasLoaded := True;
        AddToOpenedFileHistory(CurrentFile);
        Editor.Modified := False;
      finally
        Screen.Cursor := crDefault;
      end;
      DoAfterLoadFile;
    end;
  end;
end;

procedure TibBTComponentForm.DoAfterLoadFile;
begin
//
end;

procedure TibBTComponentForm.ShowFileName;
var
  vFileName: string;
begin
  if Assigned(StatusBar) and (StatusBar.Panels.Count > 4) then
  begin
    vFileName := MinimizeName(' ' + CurrentFile, StatusBar.Canvas,
      StatusBar.Width
        - StatusBar.Panels[0].Width
        - StatusBar.Panels[1].Width
        - StatusBar.Panels[2].Width
        - StatusBar.Panels[3].Width);
    StatusBar.Panels[4].Text := vFileName;
  end;
end;

function TibBTComponentForm.DoOnGetInitialDir: string;
var
//  vDatabase: IibSHDatabase;
  vEditorGeneralOptions: ISHEditorGeneralOptions;
begin
  Result := EmptyStr;
(* dk: заремил 27.06.2004 по причине сноса проперти DatabaseAliaOptions.Paths
  if Assigned(Component) and Supports(Component, IibSHDatabase, vDatabase) then
    Result := vDatabase.DatabaseAliasOptions.Paths.ForSQLFiles
  else
*)
    if Supports(Designer.GetDemon(ISHEditorGeneralOptions), ISHEditorGeneralOptions, vEditorGeneralOptions) and
      (vEditorGeneralOptions.OpenedFilesHistory.Count > 0) then
      Result := ExtractFilePath(vEditorGeneralOptions.OpenedFilesHistory[0]);
end;

procedure TibBTComponentForm.AddToOpenedFileHistory(AFileName: string);
var
  vEditorGeneralOptions: ISHEditorGeneralOptions;
  I: Integer;
begin
  if Supports(Designer.GetDemon(ISHEditorGeneralOptions), ISHEditorGeneralOptions, vEditorGeneralOptions) then
  begin
    I := vEditorGeneralOptions.OpenedFilesHistory.IndexOf(AFileName);
    if I > 0 then
    begin
      vEditorGeneralOptions.OpenedFilesHistory.Delete(I);
      I := -1;
    end;
    if I = -1 then
      vEditorGeneralOptions.OpenedFilesHistory.Insert(0, CurrentFile);
    if vEditorGeneralOptions.OpenedFilesHistory.Count > 16 then
      for I := Pred(vEditorGeneralOptions.OpenedFilesHistory.Count) downto 15 do
        vEditorGeneralOptions.OpenedFilesHistory.Delete(I);
  end;
end;

function TibBTComponentForm.AddMenuItem(AParentMenuItems: TMenuItem;
  ACaption: string; AOnClick: TNotifyEvent; AShortCut: TShortCut;
  ATag: Integer): TMenuItem;
begin
    Result := TMenuItem.Create(AParentMenuItems);
    Result.Caption := ACaption;
    Result.AutoHotkeys := maAutomatic;
    Result.OnClick := AOnClick;
    Result.ShortCut := AShortCut;
    Result.Tag := ATag;
    AParentMenuItems.Add(Result);
end;

function TibBTComponentForm.MenuItemByName(AMenuItem: TMenuItem;
  ACaption: string; ATag: Integer): TMenuItem;
var
  I: Integer;
  vCaption: string;
begin
  Result := nil;
  vCaption := StringReplace(ACaption, '&', '', [rfReplaceAll, rfIgnoreCase]);
  for I := 0 to AMenuItem.Count - 1 do
  begin
    if AnsiSameText(StringReplace(AMenuItem.Items[I].Caption, '&', '', [rfReplaceAll, rfIgnoreCase]), vCaption) and
      ((ATag = -1) or (AMenuItem.Items[I].Tag = ATag)) then
    begin
      Result := AMenuItem.Items[I];
      Break;
    end
    else
      if AMenuItem.Items[I].Count > 0 then
      begin
        Result := MenuItemByName(AMenuItem.Items[I], ACaption, ATag);
        if Assigned(Result) then
          Break;
      end;
  end;
end;


procedure TibBTComponentForm.FillPopupMenu;
var
  vCurrentItem: TMenuItem;
begin
  AddMenuItem(FEditorPopupMenu.Items, SFindDeclaration, mnFindDeclarationClick);
  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 0);

  AddMenuItem(FEditorPopupMenu.Items, SOpenFile, mnOpenFileClick, ShortCut(Ord('O'), [ssCtrl]));
  AddMenuItem(FEditorPopupMenu.Items, SSaveToFile, mnSaveToFileClick, ShortCut(Ord('S'), [ssCtrl]));
  AddMenuItem(FEditorPopupMenu.Items, SSaveAsToFile, mnSaveAsToFileClick);
  AddMenuItem(FEditorPopupMenu.Items, SSaveAsToTemplate, mnSaveAsToTemplateClick).Visible:=False;  
  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 21);

//  AddMenuItem(FEditorPopupMenu.Items, SCopyTextAsRTF, mnCopyTextasRTFClick, 24663).Visible := False;
//  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 2).Visible := False;
  AddMenuItem(FEditorPopupMenu.Items, SCut, mnCut, ShortCut(Ord('X'), [ssCtrl]));
  AddMenuItem(FEditorPopupMenu.Items, SCopy, mnCopy, ShortCut(Ord('C'), [ssCtrl]));
  AddMenuItem(FEditorPopupMenu.Items, SPaste, mnPaste, ShortCut(Ord('V'), [ssCtrl]));
  vCurrentItem := AddMenuItem(FEditorPopupMenu.Items, SSpecialPaste, nil, 0);
  AddMenuItem(vCurrentItem, SPasteDelphiString, mnPasteDelphiString);

  vCurrentItem := AddMenuItem(FEditorPopupMenu.Items, SOtherEdit);
    AddMenuItem(vCurrentItem, SUndo, mnUndo, ShortCut(Ord('Z'), [ssCtrl]));
    AddMenuItem(vCurrentItem, SRedo, mnRedo, ShortCut(Ord('Z'), [ssShift, ssCtrl]));
    AddMenuItem(vCurrentItem, '-', nil, 0, 23);
    AddMenuItem(vCurrentItem, SSelectAll, mnSelectAll, ShortCut(Ord('A'), [ssCtrl]));
    AddMenuItem(vCurrentItem, SClearAll, mnClearAll, ShortCut(VK_DELETE, [ssCtrl]));

    AddMenuItem(vCurrentItem, '-', nil, 0, 2);
    AddMenuItem(vCurrentItem, SCopyTextAsRTF, mnCopyTextasRTFClick, 24663);
    AddMenuItem(vCurrentItem, SCopyTextAsHTML, mnCopyTextasHTMLClick);
    AddMenuItem(vCurrentItem, SCopyTextAsDelphiString, mnCopyTextasDelphiClick);



  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 7);



  AddMenuItem(FEditorPopupMenu.Items, SFind, mnFind, ShortCut(Ord('F'), [ssCtrl]));
  AddMenuItem(FEditorPopupMenu.Items, SReplace, mnReplace, ShortCut(Ord('R'), [ssCtrl]));
  AddMenuItem(FEditorPopupMenu.Items, SSearchAgain, mnSearchAgain, ShortCut(VK_F3, []));
  vCurrentItem := AddMenuItem(FEditorPopupMenu.Items, SOtherSearch);
    AddMenuItem(vCurrentItem, SIncrementalSearch, mnIncrementalSearch, ShortCut(Ord('E'), [ssCtrl]));
    AddMenuItem(vCurrentItem, SGotoLineNumber, mnGotoLineNumber, ShortCut(Ord('G'), [ssAlt]));
  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 22);

  vCurrentItem := AddMenuItem(FEditorPopupMenu.Items, SToggleBookMark);
    AddMenuItem(vCurrentItem, SBookMark0, mnToggleBookmarksClick, 0, 0);
    AddMenuItem(vCurrentItem, SBookMark1, mnToggleBookmarksClick, 0, 1);
    AddMenuItem(vCurrentItem, SBookMark2, mnToggleBookmarksClick, 0, 2);
    AddMenuItem(vCurrentItem, SBookMark3, mnToggleBookmarksClick, 0, 3);
    AddMenuItem(vCurrentItem, SBookMark4, mnToggleBookmarksClick, 0, 4);
    AddMenuItem(vCurrentItem, SBookMark5, mnToggleBookmarksClick, 0, 5);
    AddMenuItem(vCurrentItem, SBookMark6, mnToggleBookmarksClick, 0, 6);
    AddMenuItem(vCurrentItem, SBookMark7, mnToggleBookmarksClick, 0, 7);
    AddMenuItem(vCurrentItem, SBookMark8, mnToggleBookmarksClick, 0, 8);
    AddMenuItem(vCurrentItem, SBookMark9, mnToggleBookmarksClick, 0, 9);
  vCurrentItem := AddMenuItem(FEditorPopupMenu.Items, SGotoBookMark);
    AddMenuItem(vCurrentItem, SBookMark0, mnGotoBookmarksClick, 0, 0);
    AddMenuItem(vCurrentItem, SBookMark1, mnGotoBookmarksClick, 0, 1);
    AddMenuItem(vCurrentItem, SBookMark2, mnGotoBookmarksClick, 0, 2);
    AddMenuItem(vCurrentItem, SBookMark3, mnGotoBookmarksClick, 0, 3);
    AddMenuItem(vCurrentItem, SBookMark4, mnGotoBookmarksClick, 0, 4);
    AddMenuItem(vCurrentItem, SBookMark5, mnGotoBookmarksClick, 0, 5);
    AddMenuItem(vCurrentItem, SBookMark6, mnGotoBookmarksClick, 0, 6);
    AddMenuItem(vCurrentItem, SBookMark7, mnGotoBookmarksClick, 0, 7);
    AddMenuItem(vCurrentItem, SBookMark8, mnGotoBookmarksClick, 0, 8);
    AddMenuItem(vCurrentItem, SBookMark9, mnGotoBookmarksClick, 0, 9);
  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 3);
  AddMenuItem(FEditorPopupMenu.Items, SCommentSelected, mnCommentselectedClick, 24687);
  AddMenuItem(FEditorPopupMenu.Items, SCommentLine, mnCommentLineClick, 16495);

  vCurrentItem := AddMenuItem(FEditorPopupMenu.Items, SConvertCharcase);
    AddMenuItem(vCurrentItem, SToLowercase, mnToLowercaseClick, 32808);
    AddMenuItem(vCurrentItem, SToUppercase, mnToUppercaseClick, 32806);
    AddMenuItem(vCurrentItem, SToNamecase, mnToNamecaseClick);
    AddMenuItem(vCurrentItem, '-', nil, 0, 4);
    AddMenuItem(vCurrentItem, SInvertCase, mnInvertCaseClick);
    AddMenuItem(vCurrentItem, SToggleCase, mnToggleCaseClick, 8306);
  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 5);
  AddMenuItem(FEditorPopupMenu.Items, SPrint, mnPrintClick);
  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 6);
  AddMenuItem(FEditorPopupMenu.Items, SShowMessages, mnShowHideMessagesClick);
  AddMenuItem(FEditorPopupMenu.Items, '-', nil, 0, 7);
  AddMenuItem(FEditorPopupMenu.Items, SProperties, mnShowPropertiesClick);
end;

procedure TibBTComponentForm.DoOnPopup(Sender: TObject);
var
  vCurrentMenuItem: TMenuItem;
  vCanShowItem: Boolean;
  vDatabase: IibSHDatabase;
  I: Integer;
  function BookMarkExists(ABookmark: Integer): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to Pred(Editor.Marks.Count) do
    begin
      Result := Editor.Marks[I].IsBookmark and Editor.Marks[I].Visible and
        (Editor.Marks[I].BookmarkNumber = ABookmark);
      if Result then Break;
    end;
  end;
begin
  if Assigned(Editor) then
  begin
    if Supports(Component, IibSHDatabase, vDatabase) and (not vDatabase.Connected) then
      vCanShowItem := False
    else
      vCanShowItem := Editor.CanJumpAtCursor;
    MenuItemByName(FEditorPopupMenu.Items, SFindDeclaration).Visible := vCanShowItem;
    MenuItemByName(FEditorPopupMenu.Items, '-', 0).Visible := vCanShowItem;

    MenuItemByName(FEditorPopupMenu.Items, SOpenFile).Enabled := GetCanOpen;
    MenuItemByName(FEditorPopupMenu.Items, SSaveToFile).Enabled := GetCanSave;
    MenuItemByName(FEditorPopupMenu.Items, SSaveAsToFile).Enabled := GetCanSaveAs;
    vCurrentMenuItem := MenuItemByName(FEditorPopupMenu.Items, SOtherEdit);
      MenuItemByName(vCurrentMenuItem, SUndo).Enabled := GetCanUndo;
      MenuItemByName(vCurrentMenuItem, SRedo).Enabled := GetCanRedo;
      MenuItemByName(vCurrentMenuItem, SSelectAll).Enabled := GetCanSelectAll;
      MenuItemByName(vCurrentMenuItem, SClearAll).Enabled := GetCanClearAll;
    MenuItemByName(FEditorPopupMenu.Items, SFind).Enabled := GetCanFind;
    MenuItemByName(FEditorPopupMenu.Items, SReplace).Enabled := GetCanReplace;
    MenuItemByName(FEditorPopupMenu.Items, SSearchAgain).Enabled := GetCanSearchAgain;
    vCurrentMenuItem := MenuItemByName(FEditorPopupMenu.Items, SOtherSearch);
      MenuItemByName(vCurrentMenuItem, SIncrementalSearch).Enabled := GetCanSearchIncremental;
      MenuItemByName(vCurrentMenuItem, SGotoLineNumber).Enabled := GetCanGoToLineNumber;

    MenuItemByName(FEditorPopupMenu.Items, SCopyTextAsRTF).Enabled := Assigned(Editor) and (not Editor.IsEmpty);
    MenuItemByName(FEditorPopupMenu.Items, SCopyTextAsDelphiString).Enabled := GetCanCopy;
    
    MenuItemByName(FEditorPopupMenu.Items, SCut).Enabled := GetCanCut;
    MenuItemByName(FEditorPopupMenu.Items, SCopy).Enabled := GetCanCopy;
    MenuItemByName(FEditorPopupMenu.Items, SPaste).Enabled := GetCanPaste;
    vCurrentMenuItem := MenuItemByName(FEditorPopupMenu.Items, SToggleBookMark);
    MenuItemByName(vCurrentMenuItem, SBookMark0).Checked := BookMarkExists(0);
    MenuItemByName(vCurrentMenuItem, SBookMark1).Checked := BookMarkExists(1);
    MenuItemByName(vCurrentMenuItem, SBookMark2).Checked := BookMarkExists(2);
    MenuItemByName(vCurrentMenuItem, SBookMark3).Checked := BookMarkExists(3);
    MenuItemByName(vCurrentMenuItem, SBookMark4).Checked := BookMarkExists(4);
    MenuItemByName(vCurrentMenuItem, SBookMark5).Checked := BookMarkExists(5);
    MenuItemByName(vCurrentMenuItem, SBookMark6).Checked := BookMarkExists(6);
    MenuItemByName(vCurrentMenuItem, SBookMark7).Checked := BookMarkExists(7);
    MenuItemByName(vCurrentMenuItem, SBookMark8).Checked := BookMarkExists(8);
    MenuItemByName(vCurrentMenuItem, SBookMark9).Checked := BookMarkExists(9);
    vCurrentMenuItem := MenuItemByName(FEditorPopupMenu.Items, SGotoBookMark);
    MenuItemByName(vCurrentMenuItem, SBookMark0).Enabled := BookMarkExists(0);
    MenuItemByName(vCurrentMenuItem, SBookMark1).Enabled := BookMarkExists(1);
    MenuItemByName(vCurrentMenuItem, SBookMark2).Enabled := BookMarkExists(2);
    MenuItemByName(vCurrentMenuItem, SBookMark3).Enabled := BookMarkExists(3);
    MenuItemByName(vCurrentMenuItem, SBookMark4).Enabled := BookMarkExists(4);
    MenuItemByName(vCurrentMenuItem, SBookMark5).Enabled := BookMarkExists(5);
    MenuItemByName(vCurrentMenuItem, SBookMark6).Enabled := BookMarkExists(6);
    MenuItemByName(vCurrentMenuItem, SBookMark7).Enabled := BookMarkExists(7);
    MenuItemByName(vCurrentMenuItem, SBookMark8).Enabled := BookMarkExists(8);
    MenuItemByName(vCurrentMenuItem, SBookMark9).Enabled := BookMarkExists(9);

    MenuItemByName(FEditorPopupMenu.Items, SCommentSelected).Enabled := Editor.SelAvail and (not Editor.ReadOnly);
    MenuItemByName(FEditorPopupMenu.Items, SCommentLine).Enabled :=
      (Editor.CaretY <= Editor.Lines.Count) and (Length(Editor.Lines[Editor.CaretY - 1]) > 0) and (not Editor.ReadOnly);
    if (not Editor.ReadOnly) and
       ((Length(Editor.WordAtCursor) > 0)  or
       (Editor.SelAvail and (Length(Trim(Editor.SelText)) > 0)))  then
    begin
      MenuItemByName(FEditorPopupMenu.Items, SConvertCharcase).Enabled := True;

      MenuItemByName(FEditorPopupMenu.Items, SToLowercase).Enabled := True;
      MenuItemByName(FEditorPopupMenu.Items, SToUppercase).Enabled := True;
      MenuItemByName(FEditorPopupMenu.Items, SToNamecase).Enabled := True;
      MenuItemByName(FEditorPopupMenu.Items, SInvertCase).Enabled := True;
      MenuItemByName(FEditorPopupMenu.Items, SToggleCase).Enabled := True;
    end
    else
    begin
      MenuItemByName(FEditorPopupMenu.Items, SConvertCharcase).Enabled := False;

      MenuItemByName(FEditorPopupMenu.Items, SToLowercase).Enabled := False;
      MenuItemByName(FEditorPopupMenu.Items, SToUppercase).Enabled := False;
      MenuItemByName(FEditorPopupMenu.Items, SToNamecase).Enabled := False;
      MenuItemByName(FEditorPopupMenu.Items, SInvertCase).Enabled := False;
      MenuItemByName(FEditorPopupMenu.Items, SToggleCase).Enabled := False;
    end;
    MenuItemByName(FEditorPopupMenu.Items, SPrint).Enabled := GetCanPrint;

    vCurrentMenuItem := MenuItemByName(FEditorPopupMenu.Items, SShowMessages);
    if not Assigned(vCurrentMenuItem) then
      vCurrentMenuItem := MenuItemByName(FEditorPopupMenu.Items, SHideMessages);

    if Assigned(vCurrentMenuItem) then
    begin
      if Assigned(EditorMsg) then
      begin
        if GetEditorMsgVisible then
          vCurrentMenuItem.Caption := SHideMessages
        else
          vCurrentMenuItem.Caption := SShowMessages;
      end
      else
      begin
        vCurrentMenuItem.Visible := False;
        vCurrentMenuItem := MenuItemByName(FEditorPopupMenu.Items, '-', 7);
        if Assigned(vCurrentMenuItem) then
          vCurrentMenuItem.Visible := False;
      end;
    end;

    for I := 0 to FEditorPopupMenu.Items.Count - 1 do
      FEditorPopupMenu.Items[I].RethinkHotkeys;
  end;
end;

procedure TibBTComponentForm.mnFindDeclarationClick(Sender: TObject);
var
  S: string;
  vCodeNormalizer: IibSHCodeNormalizer;
begin
  if Assigned(Editor) and Assigned(Component) and Editor.CanJump(S, Editor.CaretXY) then
  begin
    if Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer) then
      S := vCodeNormalizer.SourceDDLToMetadataName(S);
    Designer.JumpTo(Component.InstanceIID, IUnknown, S);
  end;
end;

procedure TibBTComponentForm.mnOpenFileClick(Sender: TObject);
begin
  Open;
end;

procedure TibBTComponentForm.mnSaveToFileClick(Sender: TObject);
begin
  Save;
end;

procedure TibBTComponentForm.mnSaveAsToFileClick(Sender: TObject);
begin
  SaveAs;
end;

procedure TibBTComponentForm.mnSaveAsToTemplateClick(Sender: TObject);
begin

end;

procedure TibBTComponentForm.mnCopyTextasRTFClick(Sender: TObject);
begin
  if Assigned(Editor) then
  begin
    FExporterRTF.Highlighter := Editor.Highlighter;
    FExporterRTF.ExportAsText := False;
    FExporterRTF.ExportAll(Editor.Lines);
    FExporterRTF.CopyToClipboard;
    FExporterRTF.Highlighter := nil;
  end;
end;

procedure TibBTComponentForm.mnCopyTextasHTMLClick(Sender: TObject);
begin
  if Assigned(Editor) then
  begin
    FExporterHTML.Highlighter := Editor.Highlighter;
    FExporterHTML.Highlighter.Name:='SQL';    
    FExporterHTML.ExportAsText := TRUE;
    FExporterHTML.CreateHTMLFragment := False;
    FExporterHTML.ExportAll(Editor.Lines);
    FExporterHTML.CopyToClipboard;
    FExporterHTML.Highlighter := nil;
  end;
end;

procedure TibBTComponentForm.mnCopyTextasDelphiClick(Sender: TObject);
var
  s,s1:string;
  i:integer;
begin
  s:=Editor.SelText;
  s1:='''';
  for i:=1 to Length(s) do
  begin
    if s[i] = #13 then
    begin
     s1:=s1+''''+'#$D#$A+'+#13#10'''';
    end
    else
    if (s[i]='''') then
     s1:=s1+s[i]+s[i]
    else
    if s[i]<>#10 then
      s1:=s1+s[i]
  end;
  s1:=s1+'''';
  Clipboard.AsText:=s1
end;

procedure TibBTComponentForm.mnCut(Sender: TObject);
begin
  Cut;
end;

procedure TibBTComponentForm.mnCopy(Sender: TObject);
begin
  Copy;
end;

procedure TibBTComponentForm.mnPasteDelphiString(Sender: TObject);
var
   s,s1:string;
   i:integer;
   State:integer;
begin
   s:=Clipboard.AsText;   s1:='';
   State:=0;
   i:=1;
   while i<=Length(s) do
   begin
    case s[i] of
     '''':  if State<>1 then
            begin
             if (i<Length(s)) and (s[i+1]<>'''')  and
             ( (i=1) or (s[i-1]<>''''))
             then
              State:=1  // InQuote
            end
            else
            begin
             if (i<Length(s)) and (s[i+1]<>'''') then
              State:=0
             else
             if i<>Length(s) then
              s1:=s1+'''';
            end;
    '+': if State=1 then
            s1:=s1+s[i];
    '#': if State=1 then
            s1:=s1+s[i]
         else
         if i<Length(s)-1 then
          if (s[i+1]='$') then
           if  (s[i+2]='D') then
           begin
             s1:=s1+#13;
             Inc(i,2)
           end
           else
           if  (s[i+2]='A') then
           begin
             s1:=s1+#10;
             Inc(i,2)
           end;
     #13,#10:;

    else
         s1:=s1+s[i]
    end;
    Inc(i)
   end;
   try
    ClipBoard.AsText:=s1;
    Paste;
   finally
    ClipBoard.AsText:=s
   end

end;

procedure TibBTComponentForm.mnPaste(Sender: TObject);
begin
  Paste;
end;

procedure TibBTComponentForm.mnUndo(Sender: TObject);
begin
  Undo;
end;

procedure TibBTComponentForm.mnRedo(Sender: TObject);
begin
  Redo;
end;

procedure TibBTComponentForm.mnClearAll(Sender: TObject);
begin
  ClearAll;
end;

procedure TibBTComponentForm.mnSelectAll(Sender: TObject);
begin
  SelectAll;
end;

procedure TibBTComponentForm.mnFind(Sender: TObject);
begin
  Find;
end;

procedure TibBTComponentForm.mnReplace(Sender: TObject);
begin
  Replace;
end;

procedure TibBTComponentForm.mnSearchAgain(Sender: TObject);
begin
  SearchAgain;
end;

procedure TibBTComponentForm.mnIncrementalSearch(Sender: TObject);
begin
  SearchIncremental;
end;

procedure TibBTComponentForm.mnGotoLineNumber(Sender: TObject);
begin
  GoToLineNumber;
end;

procedure TibBTComponentForm.mnToggleBookmarksClick(Sender: TObject);
begin
  ToggleBookmark((Sender as TMenuItem).Tag);
end;

procedure TibBTComponentForm.mnGotoBookmarksClick(Sender: TObject);
begin
  GotoBookmark((Sender as TMenuItem).Tag);
end;

procedure TibBTComponentForm.mnCommentselectedClick(Sender: TObject);
begin
  CommentUnComment;
end;

procedure TibBTComponentForm.mnCommentLineClick(Sender: TObject);
begin
  CommentUnCommentLine;
end;

procedure TibBTComponentForm.mnUncommentselectedClick(Sender: TObject);
begin
  UnCommentSelected;
end;

procedure TibBTComponentForm.mnToLowercaseClick(Sender: TObject);
begin
  ConvertCase(ccLower);
end;

procedure TibBTComponentForm.mnToUppercaseClick(Sender: TObject);
begin
  ConvertCase(ccUpper);
end;

procedure TibBTComponentForm.mnToNamecaseClick(Sender: TObject);
begin
  ConvertCase(ccNameCase);
end;

procedure TibBTComponentForm.mnInvertCaseClick(Sender: TObject);
begin
  ConvertCase(ccInvert);
end;

procedure TibBTComponentForm.mnToggleCaseClick(Sender: TObject);
begin
  ConvertCase(ccToggle);
end;

procedure TibBTComponentForm.mnPrintClick(Sender: TObject);
begin
  if GetCanPrint then
    Print;
end;

procedure TibBTComponentForm.mnShowPropertiesClick(Sender: TObject);
begin
  ShowProperties;
end;

procedure TibBTComponentForm.mnShowHideMessagesClick(Sender: TObject);
begin
  EditorMsgVisible(not GetEditorMsgVisible);
end;

procedure TibBTComponentForm.mnOpenHistoryFileClick(Sender: TObject);
var
  vFileNo: Integer;
  vEditorGeneralOptions: ISHEditorGeneralOptions;
begin
  vFileNo := (Sender as TComponent).Tag;
  if Supports(Designer.GetDemon(ISHEditorGeneralOptions), ISHEditorGeneralOptions, vEditorGeneralOptions) and
     (vFileNo >= 0) and
     (vFileNo < vEditorGeneralOptions.OpenedFilesHistory.Count) then
     DoOpenFile(vEditorGeneralOptions.OpenedFilesHistory[vFileNo]);
end;

procedure TibBTComponentForm.ToggleBookmark(ABookmarkNo: Integer);
var
  vPriorBookmarkLine: Integer;
  function GetBookmarkLine(ABookmark: Integer): Integer;
  var
    I: Integer;
  begin
    Result := -1;
    for I := 0 to Pred(Editor.Marks.Count) do
    begin
      if Editor.Marks[I].IsBookmark and Editor.Marks[I].Visible and
        (Editor.Marks[I].BookmarkNumber = ABookmark) then
      begin
        Result := Editor.Marks[I].Line;
        Break;
      end;
    end;
  end;
begin
  if Assigned(Editor) then
  begin
    vPriorBookmarkLine := GetBookmarkLine(ABookmarkNo);
    if vPriorBookmarkLine = Editor.CaretY then
      Editor.ClearBookMark(ABookmarkNo)
    else
      Editor.SetBookMark(ABookmarkNo, Editor.CaretX, Editor.CaretY);
  end;
end;

procedure TibBTComponentForm.GotoBookmark(ABookmarkNo: Integer);
begin
  if Assigned(Editor) then
    Editor.GotoBookMark(ABookmarkNo);
end;

function GetUncommentedBlock(StartPos:integer;const SQLText:string):TPoint;
var
   i:integer;
   StartPosCommented:boolean;
begin
 Result:=Point(StartPos,Length(SQLText));
 StartPosCommented :=(StartPos<Length(SQLText)) and (SQLText[StartPos]='/') and (SQLText[StartPos+1]='*') ;
 if StartPosCommented then
 begin
   Inc(StartPos,2);
   while StartPos<Length(SQLText) do
   begin
    if (SQLText[StartPos]='*') and (SQLText[StartPos+1]='/') then
    begin
     Inc(StartPos,2);
     Result:=GetUncommentedBlock(StartPos,SQLText);
     Exit;
    end;
    Inc(StartPos)
   end;
 end;

 for i:=StartPos to Result.Y-1 do
 begin
  if  (SQLText[i]='/') and (SQLText[i+1]='*') then
    Result.Y:=i-1
 end;
end;



procedure TibBTComponentForm.CommentSelected;
var
   S:string;
   curBlock:TPoint;
begin
  if Assigned(Editor) then
  begin
    S:=Editor.SelText;
    curBlock:=GetUncommentedBlock(1,S);
    while curBlock.X<Length(S) do
    begin
     Insert('/*{BT} ',S,curBlock.X);
     curBlock.X:=curBlock.Y+7;
     if curBlock.X<Length(S) then
      Insert(' {BT}*/',S,curBlock.X)
     else
      S:=S+' {BT}*/';
     Inc(curBlock.X,8);
     curBlock:=GetUncommentedBlock(curBlock.X,S);
    end;
    Editor.SelText := S;
//    Editor.SelText := '/*{BT}' + Editor.SelText + '{BT}*/';
  end;
end;

procedure TibBTComponentForm.UnCommentSelected;
var
  S: string;
  I: Integer;
  L: Integer;
begin
  if Assigned(Editor) then
  begin
    S := Editor.SelText;
    I := 1;
    L := Length(S) - 5;
    while I<L do
    begin
      while (I < L) and (S[I] in [' ', #9, #13, #10]) do Inc(I);
      if (S[I] = '/') and (S[I + 1] = '*') and (S[I + 2]='{')
       and (S[I + 3]='B') and (S[I + 4]='T') and (S[I + 5]='}')
      then
      begin
        Dec(L,6);
        System.Delete(S, I, 6);
      end
      else
      if (S[I] = '{') and (S[I + 1] = 'B') and (S[I + 2]='T')
       and (S[I + 3]='}') and (S[I + 4]='*') and (S[I + 5]='/')
      then
      begin
        Dec(L,6);
        System.Delete(S, I, 6);
      end
      else
       Inc(I)
    end;
    Editor.SelText := S;
  end  
end;


procedure TibBTComponentForm.CommentUnComment;
var
  S: string;
  L: Integer;
begin
  if Assigned(Editor) then
  begin
    if Editor.SelAvail then
    begin
      S := Trim(Editor.SelText);
      L := Length(S);
      if L >= 4 then
      begin
        if (Pos('/*', S) = 1) and
           (S[L] = '/') and
           (S[L-1] = '*') then
          UnCommentSelected
        else
          CommentSelected;
      end;
    end;
  end;
end;

procedure TibBTComponentForm.CommentUnCommentLine;
var
  S: string;
  PriorCaret: TBufferCoord;
begin
  if Assigned(Editor) then
  begin
    S := Editor.Lines[Editor.CaretY-1];
    if Length(S) > 0 then
    begin
      PriorCaret := Editor.CaretXY;
      Editor.BeginUpdate;
      Editor.CaretX := 1;
      Editor.BlockBegin := TBufferCoord(Point(1, Editor.CaretY));
      if Pos('--', S) = 1 then
      begin
        Editor.BlockEnd := TBufferCoord(Point(3, Editor.CaretY));
        Editor.SelText := '';
      end
      else
      begin
        Editor.BlockEnd := TBufferCoord(Point(1, Editor.CaretY));
        Editor.SelText := '--';
      end;
      Editor.EndUpdate;
      Editor.CaretXY := PriorCaret;
    end;
    Editor.CaretY := Editor.CaretY + 1;
  end;
end;

procedure TibBTComponentForm.ConvertCase(ANewCase: TpSHCaseCode);
var
  vTextToConvert: string;
  vCurrentPosition: Integer;
  vRestorePosition: Boolean;
  vBlockBegin: TBufferCoord;
  vBlockEnd: TBufferCoord;
begin
  if Assigned(Editor) then
  begin
    with Editor do
    begin
      vCurrentPosition := CaretX;
      if Length(SelText) = 0 then
      begin
        BlockBegin := WordStart;
        BlockEnd := WordEnd;
        vRestorePosition := True;
      end
      else
      begin
        vBlockBegin := BlockBegin;
        vBlockEnd := BlockEnd;
        vRestorePosition := False;
      end;
      vTextToConvert := SelText;
      if Length(vTextToConvert) > 0 then
      begin
        case ANewCase of
          ccToggle:
            begin
              if FPreviosToggleCase = ccToggle then
                FPreviosToggleCase := ccLower
              else
              begin
                Inc(FPreviosToggleCase);
                if FPreviosToggleCase >= ccNone then
                  FPreviosToggleCase := ccLower;
              end;
            end;
            else
              FPreviosToggleCase := ANewCase;
        end;
        vTextToConvert := DoCaseCode(vTextToConvert, FPreviosToggleCase);
        SelText := vTextToConvert;
      end;
      if vRestorePosition then
        CaretX := vCurrentPosition
      else
      begin
        BlockBegin := vBlockBegin;
        BlockEnd := vBlockEnd;
      end;
    end;
  end;
end;

procedure TibBTComponentForm.ShowProperties;
begin
  if Assigned(Editor) then
    Designer.ShowEnvironmentOptions(ISHEditorGeneralOptions);
end;

procedure TibBTComponentForm.BringToTop;
begin
  //
  // Установка неизвестного состояния для DBObjects
  //
  if Supports(Component, ISHDBComponent) and not Assigned(ModalForm) then
    (Component as ISHDBComponent).State := csUnknown;
  //
  // Обновление статусбара
  //
  if Assigned(StatusBar) and Assigned(Editor) then
  begin
    DoUpdateStatusBarByState([scCaretX, scCaretY, scAll, scModified, scReadOnly, scInsertMode]);
    DoOnFindTextChange(Editor, Editor.IsSearchIncremental, Editor.FindText);
  end;
  //
  // Установка фокуса при старте и переключении в IDE
  //
  if Assigned(FocusedControl) and FocusedControl.CanFocus then FocusedControl.SetFocus;
end;

function TibBTComponentForm.ReceiveEvent(AEvent: TSHEvent): Boolean;
begin
  Result := inherited ReceiveEvent(AEvent);
  if Result then
    case AEvent.Event of
      SHE_OPTIONS_CHANGED: DoOnOptionsChanged;
    end;
  Result := True;
end;

function TibBTComponentForm.GetErrorCoord(
  AErrorText: string): TBufferCoord;
var
  vPos: Integer;
  vCoordString: string;
begin
  Result := TBufferCoord(Point(1, 1));
  vPos := Pos('- line ', AErrorText);
  if vPos = 0 then
  begin
    vPos := Pos('At line ', AErrorText);
    if vPos > 0 then
      Inc(vPos);
  end;
  if vPos > 0 then
  begin
    Inc(vPos, 7);
    vCoordString := EmptyStr;
    while (vPos < Length(AErrorText)) and (AErrorText[vPos] in Digits) do
    begin
      vCoordString := vCoordString + AErrorText[vPos];
      Result.Line := StrToIntDef(vCoordString, -1);
      Inc(vPos);
    end;
    vPos := Pos(', char ', AErrorText);
    if vPos = 0 then
    begin
      vPos := Pos(', column ', AErrorText);
      if vPos > 0 then
        Inc(vPos, 2);
    end;
    Inc(vPos, 7);
    vCoordString := EmptyStr;
    while (vPos < Length(AErrorText)) and (AErrorText[vPos] in Digits) do
    begin
      vCoordString := vCoordString + AErrorText[vPos];
      Result.Char := StrToIntDef(vCoordString, -1);
      Inc(vPos);
    end;
  end;
end;

procedure TibBTComponentForm.SetFormSize(const H, W: Integer);
begin
  Self.Height := H;
  Self.Width := W;
end;

{ TibBTComponentForm.ISHFileCommands }

function TibBTComponentForm.GetCanNew: Boolean;
begin
//  Result := Assigned(Editor) and Editor.CanNew;
  Result := False;
end;

function TibBTComponentForm.GetCanOpen: Boolean;
begin
  Result := Assigned(Editor) and not Editor.ReadOnly;
end;

function TibBTComponentForm.GetCanSave: Boolean;
begin
  Result := Assigned(Editor); 
//  Result := Assigned(Editor) and (Length(CurrentFile) > 0);
//  Result := Assigned(Editor) and not Editor.IsEmpty;
//  Result := Assigned(Editor) and (Editor.Modified or (Editor.ReadOnly and (not Editor.IsEmpty)));
end;

function TibBTComponentForm.GetCanSaveAs: Boolean;
begin
//  Result := Assigned(Editor) and not Editor.IsEmpty;
  Result := Assigned(Editor);
end;

function TibBTComponentForm.GetCanPrint: Boolean;
begin
  Result := (Assigned(EditorMsg) or Assigned(Editor)) and
    (not Printer.Printing);
end;

procedure TibBTComponentForm.New;
begin
  if not GetCanNew then Exit;
end;

procedure TibBTComponentForm.Open;
begin
  if GetCanOpen then
    DoOpenFile(EmptyStr);
  ShowFileName;  
end;

procedure TibBTComponentForm.Save;
begin
  if GetCanSave then
  begin
    if Length(CurrentFile) > 0 then
    begin
      Screen.Cursor := crHourGlass;
      try
        DoSaveToFile(CurrentFile);
      finally
        Screen.Cursor := crDefault;
      end;
    end else
      SaveAs;
  end;
end;

procedure TibBTComponentForm.SaveAs;
begin
  if GetCanSaveAs then
  begin
    if Length(CurrentFile) > 0 then
      FSaveDialog.FileName := CurrentFile
    else
      FSaveDialog.FileName := DoOnGetInitialDir + Component.Caption;
    if FSaveDialog.Execute then
    begin
      CurrentFile := FSaveDialog.FileName;
      Screen.Cursor := crHourGlass;
      try
        DoSaveToFile(CurrentFile);
      finally
        Screen.Cursor := crDefault;
      end;
    end;
    ShowFileName;
  end;
end;

procedure TibBTComponentForm.Print;
var
  vEditorToPrint: TpSHSynEdit;
  sEditorTitle: string;
  sMessgesTitle: string;
begin
  if GetCanPrint then
  begin
    FSynEditPrint.Header.Clear;
    if Length(CurrentFile) > 0 then
      sEditorTitle := Format('%s.%s: %s', [Component.Caption, CallString, ExtractFileName(CurrentFile)])
    else
      sEditorTitle := Format('%s.%s', [Component.Caption, CallString]);
    sMessgesTitle := Format('%s.%s: messages', [Component.Caption, CallString]);

    if Assigned(EditorMsg) and Assigned(Editor) then
    begin
      if EditorMsg.Focused then
      begin
        vEditorToPrint := EditorMsg;
        FSynEditPrint.Header.Add(sMessgesTitle, FSynEditPrint.Header.DefaultFont, taCenter, 1);
        FSynEditPrint.Title := sMessgesTitle;
      end
      else
      begin
        vEditorToPrint := Editor;
        FSynEditPrint.Header.Add(sEditorTitle, FSynEditPrint.Header.DefaultFont, taCenter, 1);
        FSynEditPrint.Title := sEditorTitle;
      end;
    end
    else
    if Assigned(Editor) then
    begin
      vEditorToPrint := Editor;
      FSynEditPrint.Header.Add(sEditorTitle, FSynEditPrint.Header.DefaultFont, taCenter, 1);
      FSynEditPrint.Title := sEditorTitle;
    end
    else
    if Assigned(EditorMsg) then
    begin
      vEditorToPrint := EditorMsg;
      FSynEditPrint.Header.Add(sMessgesTitle, FSynEditPrint.Header.DefaultFont, taCenter, 1);
      FSynEditPrint.Title := sMessgesTitle;
    end
    else
      vEditorToPrint := nil;
    if Assigned(vEditorToPrint) and FPrintDialog.Execute then
    begin
      FSynEditPrint.SynEdit := vEditorToPrint;
      FSynEditPrint.Copies := FPrintDialog.Copies;
      try
        if (FPrintDialog.FromPage <> 0) or
          (FPrintDialog.ToPage <> 0) then
          FSynEditPrint.PrintRange(FPrintDialog.FromPage, FPrintDialog.ToPage)
        else
          FSynEditPrint.Print;
      except
        Printer.Abort;
      end;
    end;
  end;
end;

{ TibBTComponentForm.ISHEditCommands }

function TibBTComponentForm.GetCanUndo: Boolean;
begin
  Result := Assigned(Editor) and Editor.CanUndo;
end;

function TibBTComponentForm.GetCanRedo: Boolean;
begin
  Result := Assigned(Editor) and Editor.CanRedo;
end;

function TibBTComponentForm.GetCanCut: Boolean;
begin
  Result := Assigned(Editor) and Editor.SelAvail and (not Editor.ReadOnly);
end;

function TibBTComponentForm.GetCanCopy: Boolean;
begin
  if Assigned(EditorMsg) and EditorMsg.Focused then
    Result := EditorMsg.SelAvail
  else
    Result := Assigned(Editor) and Editor.SelAvail;
end;

function TibBTComponentForm.GetCanPaste: Boolean;
begin
  Result := Assigned(Editor) and Editor.CanPaste and (not Editor.ReadOnly);
end;

function TibBTComponentForm.GetCanSelectAll: Boolean;
begin
  if Assigned(EditorMsg) and EditorMsg.Focused then
    Result := not EditorMsg.IsEmpty
  else
    Result := Assigned(Editor) and not Editor.IsEmpty;
end;

function TibBTComponentForm.GetCanClearAll: Boolean;
begin
  Result := Assigned(Editor) and (not Editor.IsEmpty) and (not Editor.ReadOnly);
end;

procedure TibBTComponentForm.Undo;
begin
  if GetCanUndo then Editor.Undo;
end;

procedure TibBTComponentForm.Redo;
begin
  if GetCanRedo then Editor.Redo;
end;

procedure TibBTComponentForm.Cut;
begin
  if GetCanCut then
    try
      Screen.Cursor := crHourGlass;
      Editor.CutToClipboard;
    finally
      Screen.Cursor := crDefault;
    end;
end;

procedure TibBTComponentForm.Copy;
begin
  if GetCanCopy then
    try
      Screen.Cursor := crHourGlass;
      if Assigned(EditorMsg) and EditorMsg.Focused then
        EditorMsg.CopyToClipboard
      else
        Editor.CopyToClipboard;
    finally
      Screen.Cursor := crDefault;
    end;
end;

procedure TibBTComponentForm.Paste;
begin
  if GetCanPaste then
    try
      Screen.Cursor := crHourGlass;
      Editor.PasteFromClipboard;
    finally
      Screen.Cursor := crDefault;
    end;
end;

procedure TibBTComponentForm.SelectAll;
begin
  if GetCanSelectAll then
  begin
    if Assigned(EditorMsg) and EditorMsg.Focused then
      EditorMsg.SelectAll
    else
      Editor.SelectAll;
  end;
end;

procedure TibBTComponentForm.ClearAll;
begin
  if GetCanClearAll then
  begin
    Screen.Cursor := crHourGlass;
    try
      Editor.SelectAll;
      Editor.SelText := EmptyStr;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;


{ TibBTComponentForm.ISHSearchCommands }

function TibBTComponentForm.GetCanFind: Boolean;
begin
  Result := Assigned(Editor) and not Editor.IsEmpty;;
end;

function TibBTComponentForm.GetCanReplace: Boolean;
begin
  Result := GetCanFind and Assigned(Editor) and not Editor.ReadOnly;
end;

function TibBTComponentForm.GetCanSearchAgain: Boolean;
begin
  Result := GetCanFind;
end;

function TibBTComponentForm.GetCanSearchIncremental: Boolean;
begin
  Result := GetCanFind;
end;

function TibBTComponentForm.GetCanGoToLineNumber: Boolean;
begin
  Result := GetCanFind;
end;

procedure TibBTComponentForm.Find;
begin
  if GetCanFind then Editor.Find;
end;

procedure TibBTComponentForm.Replace;
begin
  if GetCanReplace then Editor.Replace;
end;

procedure TibBTComponentForm.SearchAgain;
begin
  if GetCanSearchAgain then Editor.SearchAgain;
end;

procedure TibBTComponentForm.SearchIncremental;
begin
  if GetCanSearchIncremental then Editor.SearchIncremental;
end;

procedure TibBTComponentForm.GoToLineNumber;
begin
  if GetCanGoToLineNumber then Editor.GoToLineNumber;
end;


{ TibBTComponentForm.ISHRunCommands }

function TibBTComponentForm.GetCanRun: Boolean;
begin
  Result := False;
end;

function TibBTComponentForm.GetCanPause: Boolean;
begin
  Result := False;
end;

function TibBTComponentForm.GetCanCreate: Boolean;
begin
  Result := False;
end;

function TibBTComponentForm.GetCanAlter: Boolean;
begin
  Result := False;
end;

function TibBTComponentForm.GetCanClone: Boolean;
begin
  Result := False;
end;

function TibBTComponentForm.GetCanDrop: Boolean;
begin
  Result := False;
end;

function TibBTComponentForm.GetCanRecreate: Boolean;
begin
  Result := False;
end;

function TibBTComponentForm.GetCanDebug: Boolean;
begin
  Result := False;
end;

function TibBTComponentForm.GetCanCommit: Boolean;
begin
  Result := False;
end;

function TibBTComponentForm.GetCanRollback: Boolean;
begin
  Result := False;
end;

function TibBTComponentForm.GetCanRefresh: Boolean;
begin
  Result := False;
end;

procedure TibBTComponentForm.Run;
begin
// Empty
end;

procedure TibBTComponentForm.Pause;
begin
// Empty
end;

procedure TibBTComponentForm.ICreate;
begin
// Empty
end;

procedure TibBTComponentForm.Alter;
begin
// Empty
end;

procedure TibBTComponentForm.Clone;
begin
// Empty
end;

procedure TibBTComponentForm.Drop;
begin
// Empty
end;

procedure TibBTComponentForm.Recreate;
begin
// Empty
end;

procedure TibBTComponentForm.Debug;
begin
// Empty
end;

procedure TibBTComponentForm.Commit;
begin
// Empty
end;

procedure TibBTComponentForm.Rollback;
begin
// Empty
end;

procedure TibBTComponentForm.Refresh;
begin
// Empty
end;

procedure TibBTComponentForm.ShowHideRegion(AVisible: Boolean);
begin
// Empty
end;

procedure TibBTComponentForm.DoOnDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  C: TDisplayCoord;
  bc:TBufferCoord;
begin
 if Sender is TSynEdit then
 begin
  Accept:=not TSynEdit(Sender).ReadOnly;
  if Accept then
   with TSynEdit(Sender) do
   begin
    C := TSynEdit(Sender).PixelsToNearestRowColumn( X, Y );
    bc:=DisplayToBufferPos(C);
    CaretXY:=bc;
    SetFocus
   end
 end
 else
  Accept:=False
end;

procedure TibBTComponentForm.DoOnDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  bc,bc1:TBufferCoord;
  s:string;
  L:Integer;
  P:TPoint;
  DrText:string;

function GetGenIdText(const aGenName:string):string;
var
   s:string;
   X,Y:integer;
begin
   with TpSHSynEdit(Sender) do
   begin
    Y:=bc.Line-1;
    X:=bc.Char;
    if Y>=Lines.Count then
    begin
     Result:='GEN_ID('+aGenName+',1)';
     Exit;
    end;
    s:=Lines[Y];
    if X>Length(s) then
     X:=Length(s);
    while (X>0) and (s[X] in [#9,' ',#0]) do
     Dec(X);
    if X=0 then
     Result:='GEN_ID('+aGenName+',1)'
    else
    if s[X]<>'(' then
     Result:='GEN_ID('+aGenName+',1)'
    else
    begin
     Dec(X);
     while (X>0) and (s[X] in [#9,' ']) do
      Dec(X);
     if X<6 then
      Result:='GEN_ID('+aGenName+',1)'
     else
     begin
      if (s[X] in ['D','d'])   and
         (s[X-1] in ['I','i']) and
         (s[X-2] in ['_'])  and
         (s[X-3] in ['N','n'])  and
         (s[X-4] in ['E','e'])  and
         (s[X-5] in ['G','g'])
     then
        Result:=aGenName
     else
      Result:='GEN_ID('+aGenName+',1)'
     end
    end

  end
end;
var
       vCodeNormalizer: IibSHCodeNormalizer;
       vBTCLDatabase  : IibSHDatabase;
begin
 if Sender is TpSHSynEdit then
 with Designer.GetLastDragObject do
 begin
     P:=ClientToScreen(Point(X,Y));
     FDragMenuItem:=-1;
{     FDragPopUpMenu.Popup(p.X,p.y);
     if FDragMenuItem=-1 then
      Exit;}
     with TpSHSynEdit(Sender) do
     begin
       bc:=DisplayToBufferPos(PixelsToNearestRowColumn( X, Y ));
       CaretXY:=bc;
       bc:=CaretXY; //Для гарантированного попадания в пределы существующего текста


       bc1:=bc;

       if Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer)
        and   Supports(Component, IibSHDatabase, vBTCLDatabase) 
       then
        DrText:= vCodeNormalizer.MetadataNameToSourceDDL(vBTCLDatabase,ObjectName)
       else
        DrText:=ObjectName;
       if IsEqualGUID(ObjectClass,iibSHGenerator) then
        DrText:=GetGenIdText(DrText);
       bc1.Char:=bc1.Char+Length(DrText);

       BeginUndoBlock;
       try
         s:=Lines[bc.Line-1];
         L:=Length(s);
         if L< bc.Char-1 then
         begin
          SetLength(S,bc.Char-1);
          FillChar(S[L+1],bc.Char-L-1,' ');
         end;
         s:=
          System.Copy(s,1,bc.Char-1)+DrText+
           System.Copy(s,bc.Char,MaxInt);
         with TSynEdit(Sender) do
         begin
          UndoList.AddChange(crDragDropInsert,bc,bc1,
           '',smNormal
          );
          Lines[bc.Line-1]:=s;
          CaretXY:=bc1;
         end     ;
       finally
        EndUndoBlock;
        SetFocus
       end;
     end;
 end

end;




procedure TibBTComponentForm.DoOnDragMenuClick(Sender: TObject);
begin
  FDragMenuItem:=TMenuItem(Sender).Tag
end;

end.
