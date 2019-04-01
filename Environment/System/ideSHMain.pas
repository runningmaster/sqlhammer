unit ideSHMain;

interface

uses
  Windows, SysUtils, Classes,  Controls, Forms, Menus, ActnList,
  StdCtrls, ComCtrls, ExtCtrls, VirtualTrees,
  SHDesignIntf, SHDevelopIntf, SHOptionsIntf, ideSHDesignIntf;

type
  TideBTMain = class(TComponent, IideBTMain)
  private
    FClosePageTimerHandle: Word;

    function GetCanNew: Boolean;
    function GetCanOpen: Boolean;
    function GetCanSave: Boolean;
    function GetCanSaveAs: Boolean;
    function GetCanSaveAll: Boolean;
    function GetCanClose: Boolean;
    function GetCanClosePage: Boolean;
    function GetCanCloseAll: Boolean;
    function GetCanPrint: Boolean;
    function GetCanExit: Boolean;

    function GetCanUndo: Boolean;
    function GetCanRedo: Boolean;
    function GetCanCut: Boolean;
    function GetCanCopy: Boolean;
    function GetCanPaste: Boolean;
    function GetCanSelectAll: Boolean;
    function GetCanClearAll: Boolean;

    function GetCanFind: Boolean;
    function GetCanReplace: Boolean;
    function GetCanSearchAgain: Boolean;
    function GetCanSearchIncremental: Boolean;
    function GetCanGoToLineNumber: Boolean;

    function GetCanShowWindowList: Boolean;
    function GetCanShowObjectList: Boolean;
    function GetCanBrowseNext: Boolean;
    function GetCanBrowsePrevious: Boolean;
    function GetCanBrowseBack: Boolean;
    function GetCanBrowseForward: Boolean;

    function GetCanShowEnvironmentOptions: Boolean;
    function GetCanShowEnvironmentConfigurator: Boolean;

    function GetMainMenu: TMainMenu;
    function GetImageList: TImageList;
    function GetActionList: TActionList;

    procedure New;
    procedure Open;
    procedure Save;
    procedure SaveAs;
    procedure SaveAll;
    procedure Close;
    procedure ClosePage;
    procedure CloseAll;
    procedure Print;
    procedure Exit;

    procedure Undo;
    procedure Redo;
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure SelectAll;
    procedure ClearAll;

    procedure Find;
    procedure Replace;
    procedure SearchAgain;
    procedure SearchIncremental;
    procedure GoToLineNumber;

    procedure ShowWindowList;
    procedure ShowObjectList;
    procedure BrowseNext;
    procedure BrowsePrevious;
    procedure BrowseBack;
    procedure BrowseForward;

    procedure ShowEnvironmentOptionsProc(const IID: TGUID);
    procedure ShowEnvironmentOptions;
    procedure ShowEnvironmentConfigurator;

    procedure UnderConstruction;
    procedure NotSupported;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure StartClosePageTimer;
    procedure StopTimerClosePageTimer;
  end;

implementation

uses
  ideSHSysUtils, ideSHConsts, ideSHSystem,
  ideSHMainFrm,
  ideSHEnvironmentConfiguratorFrm, ideSHEnvironmentOptionsFrm,
  ideSHObjectListFrm,
  ideSHWindowListFrm;

{ TideBTMain }

constructor TideBTMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TideBTMain.Destroy;
begin
  inherited Destroy;
end;

procedure ClosePageObjectProc(Wnd: HWnd; Msg, TimerID, SysTime: Longint); stdcall;
begin
  Main.StopTimerClosePageTimer;
  if ObjectEditorIntf.CallStringCount > 1 then
    MegaEditorIntf.Remove(ObjectEditorIntf.CurrentComponent, ObjectEditorIntf.CurrentCallString)
  else
    ComponentFactoryIntf.DestroyComponent(ObjectEditorIntf.CurrentComponent);
end;

procedure TideBTMain.StartClosePageTimer;
begin
  StopTimerClosePageTimer;
  FClosePageTimerHandle := SetTimer(0, 0, 1, @ClosePageObjectProc);
end;

procedure TideBTMain.StopTimerClosePageTimer;
begin
  if FClosePageTimerHandle <> 0 then
  begin
    KillTimer(0, FClosePageTimerHandle);
    FClosePageTimerHandle := 0;
  end;
end;


function TideBTMain.GetCanNew: Boolean;
begin
  Result := Assigned(FileCommandsIntf) and FileCommandsIntf.CanNew;
end;

function TideBTMain.GetCanOpen: Boolean;
begin
  Result := Assigned(FileCommandsIntf) and FileCommandsIntf.CanOpen;
end;

function TideBTMain.GetCanSave: Boolean;
begin
  Result := Assigned(FileCommandsIntf) and FileCommandsIntf.CanSave;
end;

function TideBTMain.GetCanSaveAs: Boolean;
begin
  Result := Assigned(FileCommandsIntf) and FileCommandsIntf.CanSaveAs;
end;

function TideBTMain.GetCanSaveAll: Boolean;
begin
  Result := GetCanClose;
end;

function TideBTMain.GetCanClose: Boolean;
begin
  Result := Assigned(ObjectEditorIntf) and ObjectEditorIntf.Enabled;
end;

function TideBTMain.GetCanClosePage: Boolean;
begin
  Result := GetCanClose;
end;

function TideBTMain.GetCanCloseAll: Boolean;
begin
  Result := GetCanClose;
end;

function TideBTMain.GetCanPrint: Boolean;
begin
  Result := Assigned(FileCommandsIntf) and FileCommandsIntf.CanPrint;
end;

function TideBTMain.GetCanExit: Boolean;
begin
  Result := True;
end;

function TideBTMain.GetCanUndo: Boolean;
begin
  Result := Assigned(EditCommandsIntf) and EditCommandsIntf.CanUndo;
end;

function TideBTMain.GetCanRedo: Boolean;
begin
  Result := Assigned(EditCommandsIntf) and EditCommandsIntf.CanRedo;
end;

function TideBTMain.GetCanCut: Boolean;
begin
  Result := Assigned(EditCommandsIntf) and EditCommandsIntf.CanCut;
end;

function TideBTMain.GetCanCopy: Boolean;
begin
  Result := Assigned(EditCommandsIntf) and EditCommandsIntf.CanCopy;
end;

function TideBTMain.GetCanPaste: Boolean;
begin
  Result := Assigned(EditCommandsIntf) and EditCommandsIntf.CanPaste;
end;

function TideBTMain.GetCanSelectAll: Boolean;
begin
  Result := Assigned(EditCommandsIntf) and EditCommandsIntf.CanSelectAll;
end;

function TideBTMain.GetCanClearAll: Boolean;
begin
  Result := Assigned(EditCommandsIntf) and EditCommandsIntf.CanClearAll;
end;

function TideBTMain.GetCanFind: Boolean;
begin
  Result := Assigned(SearchCommandsIntf) and SearchCommandsIntf.CanFind;
end;

function TideBTMain.GetCanReplace: Boolean;
begin
  Result := Assigned(SearchCommandsIntf) and SearchCommandsIntf.CanReplace;
end;

function TideBTMain.GetCanSearchAgain: Boolean;
begin
  Result := Assigned(SearchCommandsIntf) and SearchCommandsIntf.CanSearchAgain;
end;

function TideBTMain.GetCanSearchIncremental: Boolean;
begin
  Result := Assigned(SearchCommandsIntf) and SearchCommandsIntf.CanSearchIncremental;
end;

function TideBTMain.GetCanGoToLineNumber: Boolean;
begin
  Result := Assigned(SearchCommandsIntf) and SearchCommandsIntf.CanGoToLineNumber;
end;

function TideBTMain.GetCanShowWindowList: Boolean;
begin
  Result := GetCanClose;
end;

function TideBTMain.GetCanShowObjectList: Boolean;
begin
  Result := Assigned(NavigatorIntf) and Assigned(NavigatorIntf.CurrentDatabase) and
            (NavigatorIntf.CurrentDatabase as ISHRegistration).Connected;
end;

function TideBTMain.GetCanBrowseNext;
begin
  Result := Assigned(ObjectEditorIntf) and Assigned(ObjectEditorIntf.CurrentComponent);
end;

function TideBTMain.GetCanBrowsePrevious;
begin
  Result := Assigned(ObjectEditorIntf) and Assigned(ObjectEditorIntf.CurrentComponent);
end;

function TideBTMain.GetCanBrowseBack: Boolean;
begin
  Result := Assigned(ObjectEditorIntf) and ObjectEditorIntf.GetCanBrowseBack(ObjectEditorIntf.CurrentComponent);
end;

function TideBTMain.GetCanBrowseForward: Boolean;
begin
  Result := Assigned(ObjectEditorIntf) and ObjectEditorIntf.GetCanBrowseForward(ObjectEditorIntf.CurrentComponent);
end;

function TideBTMain.GetCanShowEnvironmentOptions: Boolean;
begin
  Result := True;
end;

function TideBTMain.GetCanShowEnvironmentConfigurator: Boolean;
begin
  Result := True;
end;


function TideBTMain.GetMainMenu: TMainMenu;
begin
  Result := MainForm.MainMenu1;
end;

function TideBTMain.GetImageList: TImageList;
begin
  Result := MainForm.ImageList1;
end;

function TideBTMain.GetActionList: TActionList;
begin
  Result := MainForm.ActionList1;
end;

procedure TideBTMain.New;
begin
  if GetCanNew then FileCommandsIntf.New;
end;

procedure TideBTMain.Open;
begin
  if GetCanOpen then FileCommandsIntf.Open;
end;

procedure TideBTMain.Save;
begin
  if GetCanSave then FileCommandsIntf.Save;
end;

procedure TideBTMain.SaveAs;
begin
  if GetCanSaveAs then FileCommandsIntf.SaveAs;
end;

procedure TideBTMain.SaveAll;
begin
  if GetCanSaveAll then UnderConstruction;
end;

procedure TideBTMain.Close;
begin
  if GetCanClose then
    ComponentFactoryIntf.DestroyComponent(ObjectEditorIntf.CurrentComponent);
// StartClosePageTimer;
end;

procedure TideBTMain.ClosePage;
begin
  if GetCanClose then StartClosePageTimer;
end;

procedure TideBTMain.CloseAll;
begin
  if GetCanCloseAll then
    while Assigned(ObjectEditorIntf) and (ObjectEditorIntf.PageCtrl.PageCount <> 0) do
      if not ComponentFactoryIntf.DestroyComponent(ObjectEditorIntf.CurrentComponent) then
        Break;
end;

procedure TideBTMain.Print;
begin
  if GetCanPrint then FileCommandsIntf.Print;
end;

procedure TideBTMain.Exit;
begin
  if GetCanExit then MainForm.Close;
end;

procedure TideBTMain.Undo;
begin
  if GetCanUndo then EditCommandsIntf.Undo;
end;

procedure TideBTMain.Redo;
begin
  if GetCanRedo then EditCommandsIntf.Redo;
end;

procedure TideBTMain.Cut;
begin
  if GetCanCut then EditCommandsIntf.Cut;
end;

procedure TideBTMain.Copy;
begin
  if GetCanCopy then EditCommandsIntf.Copy;
end;

procedure TideBTMain.Paste;
begin
  if GetCanPaste then EditCommandsIntf.Paste;
end;

procedure TideBTMain.SelectAll;
begin
  if GetCanSelectAll then EditCommandsIntf.SelectAll;
end;

procedure TideBTMain.ClearAll;
begin
  if GetCanClearAll then EditCommandsIntf.ClearAll;
end;

procedure TideBTMain.Find;
begin
  if GetCanFind then SearchCommandsIntf.Find;
end;

procedure TideBTMain.Replace;
begin
  if GetCanReplace then SearchCommandsIntf.Replace;
end;

procedure TideBTMain.SearchAgain;
begin
  if GetCanSearchAgain then SearchCommandsIntf.SearchAgain;
end;

procedure TideBTMain.SearchIncremental;
begin
  if GetCanSearchIncremental then SearchCommandsIntf.SearchIncremental;
end;

procedure TideBTMain.GoToLineNumber;
begin
  if GetCanGoToLineNumber then SearchCommandsIntf.GoToLineNumber;
end;

procedure TideBTMain.ShowWindowList;
begin
  if GetCanShowWindowList then ShowWindowListForm;
end;

procedure TideBTMain.ShowObjectList;
begin
  if GetCanShowObjectList then ideSHObjectListFrm.ShowObjectListForm;
end;

procedure TideBTMain.BrowseNext;
begin
  if GetCanBrowseNext then ObjectEditorIntf.BrowseNext;
end;

procedure TideBTMain.BrowsePrevious;
begin
  if GetCanBrowsePrevious then ObjectEditorIntf.BrowsePrevious;
end;

procedure TideBTMain.BrowseBack;
begin
  if GetCanBrowseBack then ObjectEditorIntf.BrowseBack;
end;

procedure TideBTMain.BrowseForward;
begin
  if GetCanBrowseForward then ObjectEditorIntf.BrowseForward;
end;

procedure TideBTMain.ShowEnvironmentOptionsProc(const IID: TGUID);
begin
  EnvironmentOptionsForm := TEnvironmentOptionsForm.Create(Application);
  try
    EnvironmentOptionsForm.RecreateOptionList(IID);
    EnvironmentOptionsForm.ShowModal;
  finally
    FreeAndNil(EnvironmentOptionsForm);
  end;
end;

procedure TideBTMain.ShowEnvironmentOptions;
begin
  if GetCanShowEnvironmentOptions then
    ShowEnvironmentOptionsProc(IUnknown);
end;

procedure TideBTMain.ShowEnvironmentConfigurator;
begin
  EnvironmentConfiguratorForm := TEnvironmentConfiguratorForm.Create(Application);
  try
    EnvironmentConfiguratorForm.ShowModal;
  finally
    FreeAndNil(EnvironmentConfiguratorForm);
  end;
end;

procedure TideBTMain.UnderConstruction;
begin
  ideSHSysUtils.UnderConstruction;
end;

procedure TideBTMain.NotSupported;
begin
  ideSHSysUtils.NotSupported;
end;

end.
