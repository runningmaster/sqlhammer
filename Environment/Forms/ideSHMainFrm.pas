unit ideSHMainFrm;

interface
     
{$I .inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, StdCtrls, ExtCtrls, ToolWin, ActnList, TypInfo,
  VirtualTrees, CommCtrl, ELPropInsp, AppEvnts, Buttons, ImgList, Grids, ShellAPI,
  Contnrs,
  SHDesignIntf, SHOptionsIntf, SHEvents, ideSHDesignIntf, ideSHSystemOptions,
  ideSHNavigator, jpeg, StdActns, pSHNetscapeSplitter, Tabs;

type
  TMainForm = class(TForm, ISHEventReceiver)
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    ActionList1: TActionList;
    mmiNavigator: TMenuItem;
    mmiSearch: TMenuItem;
    mmiView: TMenuItem;
    mmiWindow: TMenuItem;
    mmiHelp: TMenuItem;
    actUndo: TAction;
    actRedo: TAction;
    actCut: TAction;
    actCopy: TAction;
    actPaste: TAction;
    actSelectAll: TAction;
    actFind: TAction;
    actReplace: TAction;
    actSearchAgain: TAction;
    actSearchIncremental: TAction;
    actGoToLineNumber: TAction;
    actExit: TAction;
    actShowOptions: TAction;
    actShowHelpTopics: TAction;
    ApplicationEvents1: TApplicationEvents;
    ImageList1: TImageList;
    actNew: TAction;
    actOpen: TAction;
    actSave: TAction;
    actSaveAs: TAction;
    actSaveAll: TAction;
    actClose: TAction;
    actCloseAll: TAction;
    actPrint: TAction;
    mmiNew: TMenuItem;
    mmiOpen: TMenuItem;
    mmiSave: TMenuItem;
    mmiSaveAs: TMenuItem;
    mmiSaveAll: TMenuItem;
    mmiClose: TMenuItem;
    mmiCloseAll: TMenuItem;
    mmiPrint: TMenuItem;
    mmiExit: TMenuItem;
    N3: TMenuItem;
    mmiEdit: TMenuItem;
    mmiUndo: TMenuItem;
    mmiRedo: TMenuItem;
    N5: TMenuItem;
    mmiCut: TMenuItem;
    mmiCopy: TMenuItem;
    mmiPaste: TMenuItem;
    mmiSelectAll: TMenuItem;
    mmiFind: TMenuItem;
    mmiReplace: TMenuItem;
    mmiSearchAgain: TMenuItem;
    mmiSearchIncremental: TMenuItem;
    N6: TMenuItem;
    mmiGoToLineNumber: TMenuItem;
    actShowWindowList: TAction;
    actBrowseBack: TAction;
    actBrowseForward: TAction;
    mmiShowWindowList: TMenuItem;
    actShowHomePage: TAction;
    actShowForums: TAction;
    actShowForumEng: TAction;
    actShowForumRus: TAction;
    actShowFeedback: TAction;
    actShowAbout: TAction;
    mmiShowHelpTopics: TMenuItem;
    mmiShowHomePage: TMenuItem;
    mmiShowNewsGroups: TMenuItem;
    mmiShowNewsGroupsEng: TMenuItem;
    mmiShowNewsGroupsRus: TMenuItem;
    mmiShowFeedback: TMenuItem;
    mmiShowAbout: TMenuItem;
    actShowConfigurator: TAction;
    mmiShowEnvironmentOptions: TMenuItem;
    mmiShowEnvironmentConfigurator: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    actShowObjectList: TAction;
    mmiShowObjectList: TMenuItem;
    PopupMenuOE1: TPopupMenu;
    Close1: TMenuItem;
    actConnect: TAction;
    actReconnect: TAction;
    actDisconnect: TAction;
    actClearAll: TAction;
    ClearAll1: TMenuItem;
    actMoveUp: TAction;
    actMoveDown: TAction;
    actDisconnectAll: TAction;
    N1: TMenuItem;
    actMultilineMode: TAction;
    mmiMultilineMode: TMenuItem;
    actViewFullScreen: TAction;
    mmiFullScreen: TMenuItem;
    actUpdate: TAction;
    N11: TMenuItem;
    Panel1: TPanel;
    pnlClient: TPanel;
    pnlHost: TPanel;
    actBrowseNext: TAction;
    actBrowsePrevious: TAction;
    N2: TMenuItem;
    PopupMenuOE2: TPopupMenu;
    Close2: TMenuItem;
    N4: TMenuItem;
    PopupMenuOE0: TPopupMenu;
    CloseAll1: TMenuItem;
    PopupMenuME: TPopupMenu;
    N15: TMenuItem;
    mmiBranch: TMenuItem;
    mmiRegistration: TMenuItem;
    mmiConnection: TMenuItem;
    N17: TMenuItem;
    Connect1: TMenuItem;
    Reconnect1: TMenuItem;
    Disconnect1: TMenuItem;
    DisconnectAll1: TMenuItem;
    N18: TMenuItem;
    RefreshConnection1: TMenuItem;
    actShowComponentList: TAction;
    mmiComponentList: TMenuItem;
    actShowObjectTree: TAction;
    mmiShowObjectTree: TMenuItem;
    N9: TMenuItem;
    actCloseWorkspace: TAction;
    CloseContextObjects1: TMenuItem;
    Bevel3: TBevel;
    pnlTop: TPanel;
    ToolBar2: TToolBar;
    ToolButton9: TToolButton;
    ToolButton2: TToolButton;
    ToolButton23: TToolButton;
    ToolButton30: TToolButton;
    ToolButton4: TToolButton;
    ToolButton31: TToolButton;
    pnlPage: TPanel;
    Panel4: TPanel;
    PageControl1: TPageControl;
    ToolBar1: TToolBar;
    ToolBar3: TToolBar;
    ToolButton10: TToolButton;
    Panel7: TPanel;
    Bevel1: TBevel;
    pnlRight: TPanel;
    pnlLeft: TPanel;
    actClosePage: TAction;
    N10: TMenuItem;
    mmiNavigatorLeft: TMenuItem;
    pSHNetscapeSplitter1: TpSHNetscapeSplitter;
    pSHNetscapeSplitter2: TpSHNetscapeSplitter;
    mmiToolboxTop: TMenuItem;
    TabSet1: TTabSet;
    actFilterMode: TAction;
    ToolButton1: TToolButton;
    mmiFilterMode: TMenuItem;
    Timer1: TTimer;
    actRegistration: TAction;
    Registration1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure actNewExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actSaveAllExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actCloseAllExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actUndoExecute(Sender: TObject);
    procedure actRedoExecute(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actReplaceExecute(Sender: TObject);
    procedure actSearchAgainExecute(Sender: TObject);
    procedure actSearchIncrementalExecute(Sender: TObject);
    procedure actGoToLineNumberExecute(Sender: TObject);
    procedure actShowWindowListExecute(Sender: TObject);
    procedure actShowObjectListExecute(Sender: TObject);
    procedure actBrowseBackExecute(Sender: TObject);
    procedure actBrowseForwardExecute(Sender: TObject);
    procedure actShowOptionsExecute(Sender: TObject);
    procedure actShowConfiguratorExecute(Sender: TObject);
    procedure actShowHelpTopicsExecute(Sender: TObject);
    procedure actShowHomePageExecute(Sender: TObject);
    procedure actShowForumsExecute(Sender: TObject);
    procedure actShowForumEngExecute(Sender: TObject);
    procedure actShowForumRusExecute(Sender: TObject);
    procedure actShowFeedbackExecute(Sender: TObject);
    procedure actShowAboutExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure PopupMenu3Popup(Sender: TObject);
    procedure actConnectExecute(Sender: TObject);
    procedure actReconnectExecute(Sender: TObject);
    procedure actDisconnectExecute(Sender: TObject);
    procedure actClearAllExecute(Sender: TObject);
    procedure actMoveUpExecute(Sender: TObject);
    procedure actMoveDownExecute(Sender: TObject);
    procedure Activate1Click(Sender: TObject);
    procedure Close3Click(Sender: TObject);
    procedure actDisconnectAllExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actMultilineModeExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actViewFullScreenExecute(Sender: TObject);
    procedure actUpdateExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actBrowseNextExecute(Sender: TObject);
    procedure actBrowsePreviousExecute(Sender: TObject);
    procedure mmiWindowClick(Sender: TObject);
    procedure Close2Click(Sender: TObject);
    procedure CloseAll1Click(Sender: TObject);
    procedure PopupMenuMEPopup(Sender: TObject);
    procedure mmiNavigatorClick(Sender: TObject);
    procedure actShowComponentListExecute(Sender: TObject);
    procedure actShowObjectTreeExecute(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure actCloseWorkspaceExecute(Sender: TObject);
    procedure actClosePageExecute(Sender: TObject);
    procedure mmiViewClick(Sender: TObject);
    procedure actFilterModeExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure actRegistrationExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FNavigator: TideSHNavigator;
    {$IFDEF USE_JCLDEBUG}
    procedure LogException(ExceptObj: TObject; ExceptAddr: Pointer; IsOS: Boolean);
    {$ENDIF}
    procedure SplashTrace(const AText: string);
    procedure SplashTraceDone;
    procedure DoPrepareGUI;
    procedure DoGetOptions;
    procedure DoApplyOptions;
    procedure LoadProfile;
  public
    { Public declarations }
    procedure DoOnIdle;

    { ISHEventReceiver }
    function ReceiveEvent(AEvent: TSHEvent): Boolean;

    procedure MultilineMode;
    procedure FilterMode;

    property Navigator: TideSHNavigator read FNavigator;
  end;

var
  MainForm: TMainForm;

implementation

uses
{$IFDEF USE_ASPROTECT}
  aspr_api,
{$ENDIF}
{$IFDEF USE_JCLDEBUG}
  JclDebug, JclHookExcept,
{$ENDIF}
  ideSHSplashFrm, ideSHRegistrationFrm,
  ideSHSystem, ideSHSysUtils, ideSHConsts, ideSHSystemOptionsFrm,
  ideSHEditorOptions, ideSHDBGridOptions, ideSHAboutFrm, Math, StrUtils;

{$R *.dfm}

{$IFDEF USE_ASPROTECT}
{$J+}
const
  AsprUserKey: PChar = nil;
  AsprUserName: PChar = nil;
{$ENDIF}
{ TMainForm }

{$IFDEF USE_JCLDEBUG}
procedure TMainForm.LogException(ExceptObj: TObject; ExceptAddr: Pointer; IsOS: Boolean);
var
  S: string;
  S1:string;
  Log: TFileStream;
  ModInfo: TJclLocationInfo;
begin
  if ExceptObj is Exception then
  begin
    ModInfo := GetLocationInfo(ExceptAddr);
    S := Format(
         SLineBreak +
         'ERROR ========================================================================>' + SLineBreak +
         'BlazeTop %s' + SLineBreak +
         'Please send this info at <support@devrace.com> !!!' + SLineBreak +
         '  DateTime: %s' + SLineBreak +
         '  Exception: %s' + SLineBreak +
         '  IsOS: %s' + SLineBreak +
         '  Message: %s' + SLineBreak +
         '  Address: $%p' + SLineBreak +
         '  Module: %s' + SLineBreak +
         '  Unit: %s' + SLineBreak +
         '  Procedure: %s' + SLineBreak +
         '  Line: %d' + SLineBreak +
         SLineBreak,
         [
         Format('%s  %s', [SAppVersion, SAppCommunityEdition]),
         FormatDateTime('ddd mmm dd hh:nn:ss yyyy', Now),
         ExceptObj.ClassName,
         BoolToStr(IsOS, True),
         Exception(ExceptObj).Message,
         ModInfo.Address,
         ModInfo.UnitName,
         ModInfo.SourceName,
         ModInfo.ProcedureName,
         ModInfo.LineNumber
         ]);

    S1:=GetFilePath(SFileErrorLog);
    if FileExists(S1) then
      Log := TFileStream.Create(S1, fmOpenReadWrite or fmShareDenyNone)
    else
      Log := TFileStream.Create(S1, fmCreate or fmShareDenyNone);

    try
      Log.Seek(0, soFromEnd);
      Log.WriteBuffer(Pointer(S)^, Length(S));
    finally
      Log.Free;
    end;

//    if not ExceptObj.ClassNameIs('EFIBInterBaseError') then
//      if ShowMsg(Format('%s%s%sSEND BUG REPORT TO METADATAFORGE SUPPORT?', [S, SLineBreak, SLineBreak]), mtCustom, 'BlazeTop ErrorLog Notification', MB_OKCANCEL + MB_ICONERROR) then
//        ShellExecute(0, nil, PChar(Format('%s=%s', ['mailto:support@metadataforge.com?subject=!!!%20MEGABUG&body', StrToMailBody(S)])), nil, nil, SW_RESTORE);
  end;
end;
{$ENDIF}

procedure TMainForm.MultiLineMode;
begin
  if Assigned(MegaEditorIntf) then
    MegaEditorIntf.MultiLine := actMultilineMode.Checked;
end;

procedure TMainForm.FilterMode;
begin
  if Assigned(MegaEditorIntf) then
    MegaEditorIntf.FilterMode := actFilterMode.Checked;
end;

procedure TMainForm.SplashTrace(const AText: string);
begin
  if Assigned(SplashForm) then SplashForm.SplashTrace(AText);
end;

procedure TMainForm.SplashTraceDone;
begin
  if Assigned(SplashForm) then SplashForm.SplashTraceDone;
end;

procedure TMainForm.DoPrepareGUI;
var
  I: Integer;
begin
  Application.Title := Format('%s', [SApplicationTitle]);

  for I := 0 to Pred(ComponentCount) do
  begin
    if Components[I] is TPanel then
      with Components[I] as TPanel do
      begin
        Width := Width + 1;
        Width := Width - 1;
        Caption := EmptyStr;
      end;
    if Components[I] is TPageControl then
      with Components[I] as TPageControl do
      begin
        HotTrack := True;
        TabStop := False;
      end;
    if Components[I] is TAction then
      with Components[I] as TAction do
        if Hint = '' then Hint := Caption;
    if Components[I] is TToolButton then
      with Components[I] as TToolButton do
        ShowHint := True;
  end;
end;

procedure TMainForm.DoOnIdle;
begin
  if not (csDestroying in Self.ComponentState) then
  begin
    // File
    actNew.Enabled := Assigned(MainIntf) and MainIntf.CanNew;
    actOpen.Enabled := Assigned(MainIntf) and MainIntf.CanOpen;
    actSave.Enabled := Assigned(MainIntf) and MainIntf.CanSave;
    actSaveAs.Enabled := Assigned(MainIntf) and MainIntf.CanSaveAs;
    actSaveAll.Enabled := Assigned(MainIntf) and MainIntf.CanSaveAll;
    actClose.Enabled := Assigned(MainIntf) and MainIntf.CanClose;
    actCloseWorkspace.Visible := Assigned(MegaEditorIntf) and MegaEditorIntf.Active and Assigned(SystemOptionsIntf) and SystemOptionsIntf.UseWorkspaces;
    actCloseAll.Enabled := Assigned(MainIntf) and MainIntf.CanCloseAll;
    actPrint.Enabled := Assigned(MainIntf) and MainIntf.CanPrint;
    actExit.Enabled := Assigned(MainIntf) and MainIntf.CanExit;
    // Edit
    actUndo.Enabled := Assigned(MainIntf) and MainIntf.CanUndo;
    actRedo.Enabled := Assigned(MainIntf) and MainIntf.CanRedo;
    actCut.Enabled := Assigned(MainIntf) and MainIntf.CanCut;
    actCopy.Enabled := Assigned(MainIntf) and MainIntf.CanCopy;
    actPaste.Enabled := Assigned(MainIntf) and MainIntf.CanPaste;
    actSelectAll.Enabled := Assigned(MainIntf) and MainIntf.CanSelectAll;
    actClearAll.Enabled := Assigned(MainIntf) and MainIntf.CanClearAll;
    // Search
    actFind.Enabled := Assigned(MainIntf) and MainIntf.CanFind;
    actReplace.Enabled := Assigned(MainIntf) and MainIntf.CanReplace;
    actSearchAgain.Enabled := Assigned(MainIntf) and MainIntf.CanSearchAgain;
    actSearchIncremental.Enabled := Assigned(MainIntf) and MainIntf.CanSearchIncremental;
    actGoToLineNumber.Enabled := Assigned(MainIntf) and MainIntf.CanGoToLineNumber;
    // View
    actShowObjectList.Enabled := Assigned(MainIntf) and MainIntf.CanShowObjectList;
    actShowObjectTree.Enabled := Assigned(NavigatorIntf) and NavigatorIntf.CanShowScheme;
    actShowComponentList.Enabled := Assigned(NavigatorIntf) and NavigatorIntf.CanShowPalette;
    actShowWindowList.Enabled := Assigned(MainIntf) and MainIntf.CanShowWindowList;
    actBrowseNext.Enabled := Assigned(MainIntf) and MainIntf.CanBrowseNext;
    actBrowsePrevious.Enabled := Assigned(MainIntf) and MainIntf.CanBrowsePrevious;
    actBrowseBack.Enabled := Assigned(MainIntf) and MainIntf.CanBrowseBack;
    actBrowseForward.Enabled := Assigned(MainIntf) and MainIntf.CanBrowseForward;
    // Project
    actConnect.Enabled := Assigned(NavigatorIntf) and NavigatorIntf.CanConnect;
    actReconnect.Enabled := Assigned(NavigatorIntf) and NavigatorIntf.CanReconnect;
    actDisconnect.Enabled := Assigned(NavigatorIntf) and NavigatorIntf.CanDisconnect;
    actDisconnectAll.Enabled := Assigned(NavigatorIntf) and NavigatorIntf.CanDisconnectAll;
    actUpdate.Enabled := Assigned(NavigatorIntf) and NavigatorIntf.CanRefresh;
    actMoveUp.Enabled := Assigned(NavigatorIntf) and NavigatorIntf.CanMoveUp;
    actMoveDown.Enabled := Assigned(NavigatorIntf) and NavigatorIntf.CanMoveDown;
    // Tools
    actShowOptions.Enabled := Assigned(MainIntf) and MainIntf.CanShowEnvironmentOptions;
    actShowConfigurator.Enabled := Assigned(MainIntf) and MainIntf.CanShowEnvironmentConfigurator;
    // Window
  end;
end;

procedure TMainForm.DoGetOptions;
begin
  if Assigned(SystemOptionsIntf) then
  begin
    actMultilineMode.Checked := SystemOptionsIntf.MultilineMode;
    if Assigned(MegaEditorIntf) then
      MegaEditorIntf.MultiLine := SystemOptionsIntf.MultilineMode;

    actFilterMode.Checked := SystemOptionsIntf.FilterMode;
    if Assigned(MegaEditorIntf) then
      MegaEditorIntf.FilterMode := SystemOptionsIntf.FilterMode;

    Navigator.GUIController.LWidth := SystemOptionsIntf.LeftWidth;
    Navigator.GUIController.RWidth := SystemOptionsIntf.RightWidth;
    Navigator.GUIController.LeftSide := SystemOptionsIntf.NavigatorLeft;
    Navigator.GUIController.TopSide := SystemOptionsIntf.ToolboxTop;
  end;
end;

procedure TMainForm.DoApplyOptions;
var
  Options: ISHSystemOptions;
begin
  if Supports(DesignerIntf.GetOptions(ISHSystemOptions), ISHSystemOptions, Options) then
  begin
    if Assigned(MegaEditorIntf) then MegaEditorIntf.MultiLine := Options.MultilineMode;
    if Assigned(MegaEditorIntf) then MegaEditorIntf.FilterMode := Options.FilterMode;
  end;
  Options := nil;
end;

procedure TMainForm.LoadProfile;
begin
  CreateSplashForm;
  ShowSplashForm;
  try
   // pnlClient.Align := alClient;
    SplashTrace('Prepare IDE components...');
    if Assigned(MegaEditorIntf) then MegaEditorIntf.Active := False;

    SplashTraceDone;
    if Assigned(RegistryIntf) then
    begin
      SplashTrace('Loading registered images...');
      RegistryIntf.LoadImagesFromFile;
      SplashTraceDone;

      SplashTrace('');
      SplashTrace('Loading registered drivers:');
      RegistryIntf.LoadLibrariesFromFile;
//      SplashTraceDone;
      SplashTrace('');
      SplashTrace('Loading system options...');
      SHRegisterComponents([TideSHSystemOptions]);
      ideSHEditorOptions.Register;
      ideSHDBGridOptions.Register;
      SHRegisterPropertyEditor(ISHSystemOptions, 'ExternalDiffPath', TideSHExternalDiffPathPropEditor);
      SHRegisterComponentForm(ISHSystemOptions, SSystem, TSystemOptionsForm);

      SHRegisterImage(GUIDToString(ISHSystemOptions), 'System.bmp');

      SHRegisterImage(GUIDToString(ISHEditorGeneralOptions), 'Editor.bmp');
      SHRegisterImage(GUIDToString(ISHEditorDisplayOptions), 'Display.bmp');
      SHRegisterImage(GUIDToString(ISHEditorColorOptions), 'Color.bmp');
      SHRegisterImage(GUIDToString(ISHEditorCodeInsightOptions), 'CodeInsight.bmp');

      SHRegisterImage(GUIDToString(ISHDBGridGeneralOptions), 'Grid.bmp');
      SHRegisterImage(GUIDToString(ISHDBGridDisplayOptions), 'Display.bmp');
      SHRegisterImage(GUIDToString(ISHDBGridColorOptions), 'Color.bmp');
      SHRegisterImage(GUIDToString(ISHDBGridFormatOptions), 'Format.bmp');

      SplashTraceDone;
      SplashTrace('');
      SplashTrace('Loading registered packages:');
      RegistryIntf.LoadPackagesFromFile;
//      SplashTraceDone;
      SplashTrace('Loading environment options...');
      RegistryIntf.LoadOptionsFromFile;
      Supports(DesignerIntf.GetOptions(ISHSystemOptions), ISHSystemOptions, SystemOptionsIntf);
      if Assigned(SystemOptionsIntf) then ; // TODO - панель слева/справа
      SplashTraceDone;
    end;

    SplashTrace('Creating Tool Palette...');
    if Assigned(NavigatorIntf) then NavigatorIntf.RecreatePalette;
    SplashTraceDone;

    SplashTrace('Loading registered aliases...');
    DoApplyOptions;
    if Assigned(NavigatorIntf) then NavigatorIntf.LoadRegisteredInfoFromFile;
    DoGetOptions;
    SplashTraceDone;

  finally
    SplashTrace('Run...');
    SplashTraceDone;
    DestroySplashForm;
  end;

  mmiFullScreen.ImageIndex := -1;
  mmiMultiLineMode.ImageIndex := -1;
  mmiFilterMode.ImageIndex := -1;

//  DesignerIntf.ChangeNotification(DesignerIntf.CreateComponent(ISHBranch, StringToGUID('{2942F8EF-1D68-4972-984B-22529087BC85}'), ''), 'Information', opInsert)
end;

function TMainForm.ReceiveEvent(AEvent: TSHEvent): Boolean;
begin
  case AEvent.Event of
    SHE_OPTIONS_CHANGED: DoApplyOptions;
  end;
  Result := True;
end;

const

  AsprTrialDaysTotal : DWORD = DWORD(-1);
  AsprTrialDaysLeft : DWORD = DWORD(-1);



procedure TMainForm.FormCreate(Sender: TObject);
{$IFDEF USE_ASPROTECT}
var
  S:string;
{$ENDIF}
begin
{$IFDEF USE_JCLDEBUG}
  JclAddExceptNotifier(Self.LogException);
{$ENDIF}
  CreateMutex(nil, False, 'BLAZETOP_RUNNING');

 actRegistration.Visible := False;
{$IFDEF USE_ASPROTECT}
{$I ..\ASProtect\aspr_crypt_begin2.inc}
  SetLength(s,5);
  GetLocaleInfo(GetSystemDefaultLCID,LOCALE_IDEFAULTANSICODEPAGE,PChar(s),5);
  s:=PChar(s);
  GetRegistrationInformation(0,AsprUserKey, AsprUserName);
  actRegistration.Visible := (s<>'1251') and
    not ((AsprUserKey <> nil) and (StrLen(AsprUserKey) > 0));
  if actRegistration.Visible then
  begin
   if not GetTrialDays(0,AsprTrialDaysTotal, AsprTrialDaysLeft) or


     (AsprTrialDaysLeft =0) then
    begin
      ShowMessage('Sorry, but your '+IntToStr(AsprTrialDaysTotal)+'-day trial has expired ! '#13#0+
      'Please, register your copy at http://www.BlazeTop.com'
      );
      Application.Terminate
    end;
  end;

{$I ..\ASProtect\aspr_crypt_end2.inc}
{$ENDIF}

  Self.Menu := nil;
  FNavigator := TideSHNavigator.Create(nil);
  with Navigator.GUIController do
  begin
    Button := ToolButton10;
    LPanel := pnlLeft;
    LSplitter := pSHNetscapeSplitter1;
    RPanel := pnlRight;
    RSplitter := pSHNetscapeSplitter2;
  end;

  AntiLargeFont(Self);
  DoPrepareGUI;
  if Assigned(MegaEditorIntf) then MegaEditorIntf.Active := False;

end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FNavigator.Free;
{$IFDEF USE_JCLDEBUG}
  JclRemoveExceptNotifier(Self.LogException);
{$ENDIF}
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
//var
//  vAction: TAction;
begin
//  while ActionList1.ActionCount <> 0 do
//  begin
//    vAction := TAction(ActionList1.Actions[Pred(ActionList1.ActionCount)]);
//    FreeAndNil(vAction);
//  end;

  if Assigned(MegaEditorIntf) then MegaEditorIntf.Active := False;

  if Assigned(SystemOptionsIntf) then
  begin
    SystemOptionsIntf.LeftWidth := Navigator.GUIController.LWidth;
    SystemOptionsIntf.RightWidth := Navigator.GUIController.RWidth;
    SystemOptionsIntf.NavigatorLeft := Navigator.GUIController.LeftSide;
    SystemOptionsIntf.ToolboxTop := Navigator.GUIController.TopSide
  end;

  if Assigned(RegistryIntf) then RegistryIntf.SaveOptionsToFile;
  if Assigned(NavigatorIntf) then NavigatorIntf.SaveRegisteredInfoToFile;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  if Assigned(SystemOptionsIntf) and SystemOptionsIntf.WarningOnExit then
  begin
    if ShowMsg('This will end your BlazeTop session', mtWarning, '', MB_OKCANCEL + MB_ICONWARNING) then
      CanClose := Assigned(NavigatorIntf) and NavigatorIntf.DisconnectAllConnections;
  end else
    CanClose := Assigned(NavigatorIntf) and NavigatorIntf.DisconnectAllConnections;

  if CanClose then
    CanClose := Assigned(MegaEditorIntf) and MegaEditorIntf.CloseAll;
end;

procedure TMainForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  DoOnIdle;
end;

procedure TMainForm.actNewExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.New;
end;

procedure TMainForm.actOpenExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.Open;
end;

procedure TMainForm.actSaveExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.Save;
end;

procedure TMainForm.actSaveAsExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.SaveAs;
end;

procedure TMainForm.actSaveAllExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.SaveAll;
end;

procedure TMainForm.actCloseExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.Close;
end;

procedure TMainForm.actClosePageExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.ClosePage;
end;

procedure TMainForm.actCloseWorkspaceExecute(Sender: TObject);
begin
  if Assigned(MegaEditorIntf) then MegaEditorIntf.Close;
end;

procedure TMainForm.actCloseAllExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.CloseAll;
end;

procedure TMainForm.actPrintExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.Print;
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.Exit;
end;

procedure TMainForm.actUndoExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.Undo;
end;

procedure TMainForm.actRedoExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.Redo;
end;

procedure TMainForm.actCutExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.Cut;
end;

procedure TMainForm.actCopyExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.Copy;
end;

procedure TMainForm.actPasteExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.Paste;
end;

procedure TMainForm.actSelectAllExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.SelectAll;
end;

procedure TMainForm.actClearAllExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.ClearAll;
end;

procedure TMainForm.actFindExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.Find;
end;

procedure TMainForm.actReplaceExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.Replace;
end;

procedure TMainForm.actSearchAgainExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.SearchAgain;
end;

procedure TMainForm.actSearchIncrementalExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.SearchIncremental;
end;

procedure TMainForm.actGoToLineNumberExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.GoToLineNumber;
end;

procedure TMainForm.actViewFullScreenExecute(Sender: TObject);
begin
  Navigator.GUIController.Visible := TAction(Sender).Checked;
end;

procedure TMainForm.actShowWindowListExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.ShowWindowList;
end;

procedure TMainForm.actShowObjectListExecute(Sender: TObject);
begin
// DEBUG
//  ShowMessage(Screen.ActiveControl.Name);
  if Assigned(MainIntf) then MainIntf.ShowObjectList;
end;

procedure TMainForm.actShowObjectTreeExecute(Sender: TObject);
begin
  if Assigned(NavigatorIntf) then NavigatorIntf.ShowScheme;
end;

procedure TMainForm.actShowComponentListExecute(Sender: TObject);
begin
  if Assigned(NavigatorIntf) then NavigatorIntf.ShowPalette;
end;

procedure TMainForm.actBrowseNextExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.BrowseNext;
end;

procedure TMainForm.actBrowsePreviousExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.BrowsePrevious;
end;

procedure TMainForm.actBrowseBackExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.BrowseBack;
end;

procedure TMainForm.actBrowseForwardExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.BrowseForward;
end;

procedure TMainForm.actMultilineModeExecute(Sender: TObject);
begin
  SystemOptionsIntf.MultilineMode := actMultilineMode.Checked;
  MultilineMode;
end;

procedure TMainForm.actFilterModeExecute(Sender: TObject);
begin
  SystemOptionsIntf.FilterMode := actFilterMode.Checked;
  FilterMode;
end;

procedure TMainForm.actShowOptionsExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.ShowEnvironmentOptions;
end;

procedure TMainForm.actShowConfiguratorExecute(Sender: TObject);
begin
  if Assigned(MainIntf) then MainIntf.ShowEnvironmentConfigurator;
end;

procedure TMainForm.actShowHelpTopicsExecute(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TMainForm.actShowHomePageExecute(Sender: TObject);
begin
  ShellExecute(0, nil, PChar(SProjectHomePage2), nil, nil, SW_RESTORE);
end;

procedure TMainForm.actShowForumsExecute(Sender: TObject);
begin
// Empty
end;

procedure TMainForm.actShowForumEngExecute(Sender: TObject);
begin
  ShellExecute(0, nil, PChar(SProjectForumEngPage), nil, nil, SW_RESTORE);
end;

procedure TMainForm.actShowForumRusExecute(Sender: TObject);
begin
  ShellExecute(0, nil, PChar(SProjectForumRusPage), nil, nil, SW_RESTORE);
end;

procedure TMainForm.actShowFeedbackExecute(Sender: TObject);
begin
  ShellExecute(0, nil, PChar(SProjectFeedbackAddr), nil, nil, SW_RESTORE);
end;

procedure TMainForm.actShowAboutExecute(Sender: TObject);
begin
  ideSHAboutFrm.ShowAboutForm;
end;

procedure TMainForm.actConnectExecute(Sender: TObject);
begin
  if Assigned(NavigatorIntf) then NavigatorIntf.Connect;
end;

procedure TMainForm.actUpdateExecute(Sender: TObject);
begin
  if Assigned(NavigatorIntf) then NavigatorIntf.Refresh;
end;

procedure TMainForm.actReconnectExecute(Sender: TObject);
begin
  if Assigned(NavigatorIntf) then NavigatorIntf.Reconnect;
end;

procedure TMainForm.actDisconnectExecute(Sender: TObject);
begin
  if Assigned(NavigatorIntf) then NavigatorIntf.Disconnect;
end;

procedure TMainForm.actDisconnectAllExecute(Sender: TObject);
begin
  if Assigned(NavigatorIntf) and ShowMsg(Format('%s', ['Disconnect from all opened connections?']), mtConfirmation) then
    NavigatorIntf.DisconnectAll;
end;

procedure TMainForm.actMoveUpExecute(Sender: TObject);
begin
//  if Assigned(NavigatorIntf) then NavigatorIntf.MoveUp;
end;

procedure TMainForm.actMoveDownExecute(Sender: TObject);
begin
//  if Assigned(NavigatorIntf) then NavigatorIntf.MoveDown;
end;

procedure TMainForm.PopupMenu1Popup(Sender: TObject);
begin
  if Assigned(ObjectEditorIntf) then
    ObjectEditorIntf.GetCaptionList(Sender as TPopupMenu);
end;

procedure TMainForm.PopupMenu2Popup(Sender: TObject);
begin
  if Assigned(ObjectEditorIntf) then
    ObjectEditorIntf.GetBackList(Sender as TPopupMenu);
end;

procedure TMainForm.PopupMenu3Popup(Sender: TObject);
begin
  if Assigned(ObjectEditorIntf) then
    ObjectEditorIntf.GetForwardList(Sender as TPopupMenu);
end;

procedure TMainForm.Activate1Click(Sender: TObject);
begin
  DesignerIntf.UnderConstruction;
end;

procedure TMainForm.Close3Click(Sender: TObject);
begin
  DesignerIntf.UnderConstruction;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(MegaEditorIntf) and Assigned(ObjectEditorIntf) then
  begin
    if (ssAlt in Shift) and (Key in [Ord('1')..Ord('9')]) then
      case Key of
        Ord('1'): MegaEditorIntf.Toggle(0);
        Ord('2'): MegaEditorIntf.Toggle(1);
        Ord('3'): MegaEditorIntf.Toggle(2);
        Ord('4'): MegaEditorIntf.Toggle(3);
        Ord('5'): MegaEditorIntf.Toggle(4);
        Ord('6'): MegaEditorIntf.Toggle(5);
        Ord('7'): MegaEditorIntf.Toggle(6);
        Ord('8'): MegaEditorIntf.Toggle(7);
        Ord('9'): MegaEditorIntf.Toggle(8);
      end;
  end;
end;

procedure TMainForm.mmiViewClick(Sender: TObject);
begin
  if Navigator.GUIController.LeftSide then
  begin
    mmiNavigatorLeft.Caption := Format('%s', ['Move Navigator To The Right']);
    mmiNavigatorLeft.ImageIndex := 91;
  end else
  begin
    mmiNavigatorLeft.Caption := Format('%s', ['Move Navigator To The Left']);
    mmiNavigatorLeft.ImageIndex := 90;
  end;
  mmiNavigatorLeft.OnClick := Navigator.GUIController.SetNavigatorPosition;

  if Navigator.GUIController.TopSide then
  begin
    mmiToolboxTop.Caption := Format('%s', ['Move Toolbox To The Bottom']);
    mmiToolboxTop.ImageIndex := 97;
  end else
  begin
    mmiToolboxTop.Caption := Format('%s', ['Move Toolbox To The Top']);
    mmiToolboxTop.ImageIndex := 96;
  end;
  mmiToolboxTop.OnClick := Navigator.GUIController.SetToolboxPosition;
end;

procedure TMainForm.mmiWindowClick(Sender: TObject);
begin
  with Sender as TMenuItem do
    while Count <> (-1) * Tag do
      Delete(0{Pred(Count)});

  if Assigned(ObjectEditorIntf) then
    ObjectEditorIntf.GetCaptionList(Sender as TMenuItem);
end;

procedure TMainForm.Close2Click(Sender: TObject);
begin
  actClosePage.Execute;
end;

procedure TMainForm.CloseAll1Click(Sender: TObject);
begin
  MegaEditorIntf.Close;
end;

procedure TMainForm.PopupMenuMEPopup(Sender: TObject);
begin
  if Assigned(MegaEditorIntf) then
    MegaEditorIntf.GetCaptionList(Sender as TPopupMenu);
end;

procedure TMainForm.mmiNavigatorClick(Sender: TObject);
begin
  with mmiBranch do
    while Count <> 0 do
      Delete(0);
  with mmiRegistration do
    while Count <> 0 do
      Delete(0);
  with mmiConnection do
    while Count <> 0 do
      Delete(0);

  if Assigned(NavigatorIntf) then
  begin
    NavigatorIntf.SetBranchMenuItems(mmiBranch);
    NavigatorIntf.SetRegistrationMenuItems(mmiRegistration);
    NavigatorIntf.SetConnectionMenuItems(mmiConnection);
  end;
end;

procedure TMainForm.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
//var
//  ControlUnderMouse: TWinControl;
begin
(*
  if Msg.message = WM_MOUSEWHEEL then
  begin
    ShowMessage('Msg.hwnd:' + FindControl(Msg.hwnd).ClassName);
    ControlUnderMouse := FindVCLWindow(Mouse.CursorPos);
    ShowMessage('ControlUnderMouse:' + ControlUnderMouse.ClassName);
{
    if Assigned(ControlUnderMouse) and (Screen.ActiveControl.Handle <> ControlUnderMouse.Handle) then
    begin
      ShowMessage(ControlUnderMouse.ClassName);
      if not AnsiContainsText(ControlUnderMouse.ClassName, 'SynEdit') then
      begin
        Msg.hwnd := ControlUnderMouse.Handle;
        Msg.message := CM_MOUSEWHEEL;
        //ControlUnderMouse.Perform(CM_MOUSEWHEEL, Msg.WParam, Msg.LParam);
        Handled := False;
      end else
      begin
        ControlUnderMouse.Perform(WM_MOUSEWHEEL, Msg.WParam, Msg.LParam);
        Handled := True;
      end;
    end;
}
  end;
*)  
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Enabled := False;
  pnlHost.Caption := 'Initialize...';
  pnlHost.Font.Style := [fsBold];
  Application.ProcessMessages;
  pnlLeft.Width := 10;
  pnlRight.Width := 10;
  Application.ProcessMessages;
  try
    LoadProfile;
  finally
    pnlHost.Caption := '';
    pnlHost.Font.Style := [];
    Enabled := True;
  end;
end;

procedure TMainForm.actRegistrationExecute(Sender: TObject);
begin
  RegistrationForm := TRegistrationForm.Create(Application);
  try
    RegistrationForm.ShowModal;
  finally
    FreeAndNil(RegistrationForm);
  end;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
(*  
 *)
end;

initialization

{$IFDEF USE_JCLDEBUG}
   JclStartExceptionTracking;
   JclTrackExceptionsFromLibraries;
{$ENDIF}

finalization
end.

