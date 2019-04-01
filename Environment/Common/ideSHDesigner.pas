unit ideSHDesigner;

interface

uses
  Windows, SysUtils, Classes, Controls, Contnrs, Forms, Dialogs, Menus, ActnList,
  StdCtrls, ComCtrls, TypInfo, ExtCtrls, Graphics,
  SHDesignIntf, SHDevelopIntf, SHEvents;

type
  TideBTDesigner = class(TComponent, ISHDesigner)
  private
    FPostEventEvent: TSHEvent;
    FTimerHandle: Word;
    FConnectTimer: TTimer;
    FLostConnectList: TObjectList;
    procedure ExecuteConnectTimer(Sender: TObject);

    function GetMainMenu: TMainMenu;
    function GetImageList: TImageList;
    function GetActionList: TActionList;
    function GetComponents: TComponentList;
    function GetComponentForms: TComponentList;

    function GetCurrentBranch: TSHComponent;
    function GetCurrentServer: TSHComponent;
    function GetCurrentDatabase: TSHComponent;
    function GetCurrentComponent: TSHComponent;
    function GetCurrentComponentForm: TSHComponentForm;
    function GetCurrentServerInUse: Boolean;
    function GetCurrentDatabaseInUse: Boolean;
    function GetServerCount: Integer;
    function GetDatabaseCount: Integer;

    function GetLoading: Boolean;

    function _GetProxiEditorClass(APropertyInspector: TObject; AInstance: TPersistent;
      APropInfo: PPropInfo): TObject;
    procedure UnderConstruction;
    procedure NotSupported;
    procedure AntiLargeFont(AComponent: TComponent);
    function GetApplicationPath: string;
    function GetFilePath(const FileName: string): string;
    function EncodeApplicationPath(const FileName: string): string;
    function DecodeApplicationPath(const FileName: string): string;
    procedure TextToStrings(AText: string; AList: TStrings;
      DoClear: Boolean = False; DoInsert: Boolean = False);
    function CheckPropValue(Value, Values: string): Boolean;
    function ShowMsg(const AMsg: string; DialogType: TMsgDlgType): Boolean; overload;
    function ShowMsg(const AMsg: string): Integer; overload;
    procedure AbortWithMsg(const AMsg: string = '');
    function InputQuery(const ACaption, APrompt: string;
      var Value: string; CancelBtn: Boolean = True; PswChar: Char = #0): Boolean;
    function InputBox(const ACaption, APrompt, ADefault: string;
      CancelBtn: Boolean = True; PswChar: Char = #0): string;
    procedure SaveRegisteredConnectionInfo;
    procedure ShowEnvironmentOptions; overload;
    procedure ShowEnvironmentOptions(const AClassIID: TGUID); overload;
    procedure UpdateObjectInspector;
    procedure UpdateActions;    
    function ShowModal(AComponent: TSHComponent; const CallString: string): TModalResult;
    function ExecuteExternalProcess(const CommandLine, WorkingDirectory: string): Integer;
    function RegExprMatch(const AExpression, ASource: string; CaseSensitive: Boolean): Boolean;

    function GetComponent(const AClassIID: TGUID): TSHComponentClass;
    function GetImageIndex(const AStringIID: string): Integer; overload;
    function GetImageIndex(const AClassIID: TGUID): Integer; overload;
    function GetCallStrings(const AClassIID: TGUID): TStrings;
    function GetComponentForm(const AClassIID: TGUID; const CallString: string): TSHComponentFormClass;
    function GetFactory(const AClassIID: TGUID): ISHComponentFactory;
    function GetOptions(const AClassIID: TGUID): ISHComponentOptions;
    function GetPropertyEditor(const AClassIID: TGUID; const PropertyName: string): TSHPropertyEditorClass;
    function GetDemon(const AClassIID: TGUID): TSHComponent;

    procedure ISHDesigner.FreeNotification = IFreeNotification;
    procedure IFreeNotification(AComponent: TComponent);

    function CreateComponent(const AOwnerIID, AClassIID: TGUID;
      const ACaption: string): TSHComponent;
    function DestroyComponent(AComponent: TSHComponent): Boolean;

    function FindComponent(const AInstanceIID: TGUID): TSHComponent; overload;
    function FindComponent(const AOwnerIID, AClassIID: TGUID): TSHComponent; overload;
    function FindComponent(const AOwnerIID, AClassIID: TGUID; const ACaption: string): TSHComponent; overload;

    procedure SendEvent(AEvent: TSHEvent);
    procedure PostEvent(AEvent: TSHEvent);

    procedure GetPropValues(Source: TPersistent; AParentName: string; AStrings: TStrings;
      PropNameList: TStrings = nil; Include: Boolean = True);
    procedure SetPropValues(Dest: TPersistent; AParentName: string; AStrings: TStrings;
      PropNameList: TStrings = nil; Include: Boolean = True);
    procedure WritePropValuesToFile(const FileName, Section: string;
      Source: TPersistent; PropNameList: TStrings = nil; Include: Boolean = True);
    procedure ReadPropValuesFromFile(const FileName, Section: string;
      Dest: TPersistent; PropNameList: TStrings = nil; Include: Boolean = True);

    function ExistsComponent(AComponent: TSHComponent): Boolean; overload;
    function ExistsComponent(AComponent: TSHComponent; const CallString: string): Boolean; overload;
    function ChangeNotification(AComponent: TSHComponent; Operation: TOperation): Boolean; overload;
    function ChangeNotification(AComponent: TSHComponent; const CallString: string; Operation: TOperation): Boolean; overload;

    function JumpTo(const AInstanceIID, AClassIID: TGUID; ACaption: string): Boolean;

    function RegisterConnection(AConnection: TSHComponent): Boolean;
    function UnregisterConnection(AConnection: TSHComponent): Boolean;
    function DestroyConnection(AConnection: TSHComponent): Boolean;
    function ConnectTo(AConnection: TSHComponent): Boolean;
    function ReconnectTo(AConnection: TSHComponent): Boolean;
    function DisconnectFrom(AConnection: TSHComponent): Boolean;
    procedure RefreshConnection(AConnection: TSHComponent);
    procedure RestoreConnection(AConnection: TSHComponent);
    function SynchronizeConnection(AConnection: TSHComponent; const AClassIID: TGUID;
      const ACaption: string; Operation: TOperation): Boolean;
//Buzz
    function GetLastDragObject:TDragObjectInfo;
    procedure SaveStringsToIni(const FileName, Section: string;Source:TStrings;EraseOldSection:boolean=True);
    procedure ReadStringsFromIni(const FileName, Section: string;Source:TStrings);

  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure StartTimerPostEvent;
    procedure StopTimerPostEvent;

    property PostEventEvent: TSHEvent read FPostEventEvent write FPostEventEvent;
  end;

implementation

uses
  ideSHConsts, ideSHMessages, ideSHSysUtils, ideSHSystem, ideSHStrUtil, ideSHRegExpr,
  ideSHBaseDialogFrm, ideSHProxiPropEditors, ideSHMainFrm,
  ideSHRestoreConnectionFrm, ELPropInsp;

var
  RegExpr: TRegExpr;

{ TideBTDesigner }

procedure PostEventProc(Wnd: HWnd; Msg, TimerID, SysTime: Longint); stdcall;
begin
  Designer.StopTimerPostEvent;
  Designer.SendEvent(Designer.PostEventEvent);
end;

procedure TideBTDesigner.StartTimerPostEvent;
begin
  StopTimerPostEvent;
  FTimerHandle := SetTimer(0, 0, 1, @PostEventProc);  
end;

procedure TideBTDesigner.StopTimerPostEvent;
begin
  if FTimerHandle <> 0 then
  begin
    KillTimer(0, FTimerHandle);
    FTimerHandle := 0;
  end;
end;

constructor TideBTDesigner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConnectTimer := TTimer.Create(nil);
  FConnectTimer.Enabled := False;
  FConnectTimer.Interval := 100;
  FConnectTimer.OnTimer := ExecuteConnectTimer;

  FLostConnectList := TObjectList.Create(False);
end;

destructor TideBTDesigner.Destroy;
begin
  FConnectTimer.Free;
  FLostConnectList.Free;
  inherited Destroy;
end;

procedure TideBTDesigner.ExecuteConnectTimer(Sender: TObject);
begin
  FConnectTimer.Enabled := False;
  if FLostConnectList.Count <> 0 then
  begin
    ideSHRestoreConnectionFrm.RestoreConnection(TSHComponent(FLostConnectList[0]));
    FLostConnectList.Delete(0);
    FConnectTimer.Enabled := FLostConnectList.Count <> 0;
  end;
end;

function TideBTDesigner.GetMainMenu: TMainMenu;
begin
  Result := nil;
  if Assigned(MainIntf) then
    Result := MainIntf.MainMenu;
end;

function TideBTDesigner.GetImageList: TImageList;
begin
  Result := nil;
  if Assigned(MainIntf) then
    Result := MainIntf.ImageList;
end;

function TideBTDesigner.GetActionList: TActionList;
begin
  Result := nil;
  if Assigned(MainIntf) then
    Result := MainIntf.ActionList;
end;

function TideBTDesigner.GetComponents: TComponentList;
begin
  Result := nil;
  if Assigned(ComponentFactoryIntf) then
    Result := ComponentFactoryIntf.Components;
end;

function TideBTDesigner.GetComponentForms: TComponentList;
begin
  Result := nil;
  if Assigned(ComponentFactoryIntf) then
    Result := ComponentFactoryIntf.ComponentForms;
end;

function TideBTDesigner.GetCurrentBranch: TSHComponent;
begin
  Result := nil;
  if Assigned(NavigatorIntf) then Result := NavigatorIntf.CurrentBranch;
end;

function TideBTDesigner.GetCurrentServer: TSHComponent;
begin
  Result := nil;
  if Assigned(NavigatorIntf) then Result := NavigatorIntf.CurrentServer;
end;

function TideBTDesigner.GetCurrentDatabase: TSHComponent;
begin
  Result := nil;
  if Assigned(NavigatorIntf) then Result := NavigatorIntf.CurrentDatabase;  
end;

function TideBTDesigner.GetCurrentComponent: TSHComponent;
begin
  Result := nil;
  if Assigned(ObjectEditorIntf) then Result := ObjectEditorIntf.CurrentComponent;
end;

function TideBTDesigner.GetCurrentComponentForm: TSHComponentForm;
begin
  Result := nil;
  if Assigned(ObjectEditorIntf) then Result := ObjectEditorIntf.CurrentComponentForm;
end;

function TideBTDesigner.GetCurrentServerInUse: Boolean;
begin
  Result := Assigned(NavigatorIntf) and NavigatorIntf.CurrentServerInUse;
end;

function TideBTDesigner.GetCurrentDatabaseInUse: Boolean;
begin
  Result := Assigned(NavigatorIntf) and NavigatorIntf.CurrentDatabaseInUse;
end;

function TideBTDesigner.GetServerCount: Integer;
begin
  Result := 0;
  if Assigned(NavigatorIntf) then Result := NavigatorIntf.ServerCount;
end;

function TideBTDesigner.GetDatabaseCount: Integer;
begin
  Result := 0;
  if Assigned(NavigatorIntf) then Result := NavigatorIntf.DatabaseCount;
end;

function TideBTDesigner.GetLoading: Boolean;
begin
  Result := Assigned(NavigatorIntf) and NavigatorIntf.LoadingFromFile;
end;

function TideBTDesigner._GetProxiEditorClass(APropertyInspector: TObject; AInstance: TPersistent;
  APropInfo: PPropInfo): TObject;
begin
  Result := nil;
  if APropertyInspector is TELPropertyInspector then
    Result := TObject(BTGetProxiEditorClass(TELPropertyInspector(APropertyInspector), AInstance, APropInfo));
end;

procedure TideBTDesigner.UnderConstruction;
begin
  if Assigned(MainIntf) then
    MainIntf.UnderConstruction;
end;

procedure TideBTDesigner.NotSupported;
begin
  if Assigned(MainIntf) then MainIntf.NotSupported;
end;

procedure TideBTDesigner.AntiLargeFont(AComponent: TComponent);
begin
  ideSHSysUtils.AntiLargeFont(AComponent);
end;

function TideBTDesigner.GetApplicationPath: string;
begin
  Result := ideSHSysUtils.GetAppPath;
end;

function TideBTDesigner.GetFilePath(const FileName: string): string;
begin
  Result := ideSHSysUtils.GetFilePath(FileName);
end;

function TideBTDesigner.EncodeApplicationPath(const FileName: string): string;
begin
  Result := ideSHSysUtils.EncodeAppPath(FileName);
end;

function TideBTDesigner.DecodeApplicationPath(const FileName: string): string;
begin
  Result := ideSHSysUtils.DecodeAppPath(FileName);
end;

procedure TideBTDesigner.TextToStrings(AText: string; AList: TStrings;
  DoClear: Boolean = False; DoInsert: Boolean = False);
begin
  ideSHSysUtils.TextToStrings(AText, AList, DoClear, DoInsert);
end;

function TideBTDesigner.CheckPropValue(Value, Values: string): Boolean;
var
  BegSub, EndSub: TCharSet;
begin
  BegSub := [' ', #13, #10, #9, '"'];
  EndSub := [' ', #13, #10, #9, '"'];
  Result := PosExtCI(Value, Values, BegSub, EndSub) > 0;
  if not Result then
    ShowMsg(Format(SInvalidPropValue, [Value]), mtError);
end;

function TideBTDesigner.ShowMsg(const AMsg: string; DialogType: TMsgDlgType): Boolean;
begin
  Result := ideSHSysUtils.ShowMsg(AMsg, DialogType);
end;

function TideBTDesigner.ShowMsg(const AMsg: string): Integer;
begin
  Result := ideSHSysUtils.ShowMsg(AMsg);
end;

procedure TideBTDesigner.AbortWithMsg(const AMsg: string = '');
begin
  ideSHSysUtils.AbortWithMsg(AMsg);
end;

function TideBTDesigner.InputQuery(const ACaption, APrompt: string;
  var Value: string; CancelBtn: Boolean = True; PswChar: Char = #0): Boolean;
begin
  Result := ideSHSysUtils.InputQueryExt(ACaption, APrompt, Value, CancelBtn, PswChar);
end;

function TideBTDesigner.InputBox(const ACaption, APrompt, ADefault: string;
  CancelBtn: Boolean = True; PswChar: Char = #0): string;
begin
  Result := ideSHSysUtils.InputBoxExt(ACaption, APrompt, ADefault, CancelBtn, PswChar);
end;

procedure TideBTDesigner.SaveRegisteredConnectionInfo;
begin
  if Assigned(NavigatorIntf) then NavigatorIntf.SaveRegisteredInfoToFile;
end;

procedure TideBTDesigner.ShowEnvironmentOptions;
begin
  if Assigned(MainIntf) then MainIntf.ShowEnvironmentOptions;
end;

procedure TideBTDesigner.ShowEnvironmentOptions(const AClassIID: TGUID);
begin
  if Assigned(MainIntf) then MainIntf.ShowEnvironmentOptionsProc(AClassIID);
end;

procedure TideBTDesigner.UpdateObjectInspector;
var
  vEvent: TSHEvent;
begin
  vEvent.Event := SHE_REFRESH_OBJECT_INSPECTOR;
  PostEvent(vEvent);
  if GetCurrentComponent <> nil then
    MainForm.Caption := Format('%s\%s', [SApplicationTitle, GetCurrentComponent.CaptionPath]);
end;

procedure TideBTDesigner.UpdateActions;
begin
  Application.ProcessMessages;
  MainForm.DoOnIdle;
  if Assigned(ObjectEditorIntf) and ObjectEditorIntf.CanUpdateToolbarActions then
    ObjectEditorIntf.UpdateToolbarActions;
end;

function TideBTDesigner.ShowModal(AComponent: TSHComponent; const CallString: string): TModalResult;
var
  ComponentForm: TSHComponentFormClass;
  DialogForm: TBaseDialogForm;
//  ModalForm: ISHModalForm;
begin
  Result := mrNone;
  if Assigned(AComponent) and (Length(CallString) > 0) then
  begin
    ComponentForm := GetComponentForm(AComponent.ClassIID, CallString);
    if Assigned(ComponentForm) then
    begin
      DialogForm := TBaseDialogForm.Create(Application);
      try
        DialogForm.ComponentForm := ComponentForm.Create(DialogForm, DialogForm.pnlClient, AComponent, CallString);
        Result := DialogForm.ShowModal;
        if Assigned(DialogForm.OnAfterModalClose) then
          DialogForm.OnAfterModalClose(DialogForm, Result);
      finally
        FreeAndNil(DialogForm);
      end;
    end;
  end;
end;

function TideBTDesigner.ExecuteExternalProcess(const CommandLine, WorkingDirectory: string): Integer;
begin
  Result := ideSHSysUtils.Execute(CommandLine, WorkingDirectory);
end;

function TideBTDesigner.RegExprMatch(const AExpression, ASource: string; CaseSensitive: Boolean): Boolean;
begin
  RegExpr.ModifierI := CaseSensitive;
  RegExpr.Expression := AExpression;
  Result := RegExpr.Exec(ASource);
end;

function TideBTDesigner.GetComponent(const AClassIID: TGUID): TSHComponentClass;
begin
  Result := nil;
  if Assigned(RegistryIntf) then Result := RegistryIntf.GetRegComponent(AClassIID);
end;

function TideBTDesigner.GetImageIndex(const AStringIID: string): Integer;
begin
  Result := IMG_DEFAULT;
  if Assigned(RegistryIntf) then Result := RegistryIntf.GetRegImageIndex(AStringIID);
end;

function TideBTDesigner.GetImageIndex(const AClassIID: TGUID): Integer;
begin
  Result := GetImageIndex(GUIDToString(AClassIID));
end;

function TideBTDesigner.GetCallStrings(const AClassIID: TGUID): TStrings;
begin
  Result := RegistryIntf.GetRegCallStrings(AClassIID);
end;

function TideBTDesigner.GetComponentForm(const AClassIID: TGUID;
  const CallString: string): TSHComponentFormClass;
begin
  Result := nil;
  if Assigned(RegistryIntf) then Result := RegistryIntf.GetRegComponentForm(AClassIID, CallString);
end;

function TideBTDesigner.GetPropertyEditor(const AClassIID: TGUID;
  const PropertyName: string): TSHPropertyEditorClass;
begin
  Result := nil;
  if Assigned(RegistryIntf) then Result := RegistryIntf.GetRegPropertyEditor(AClassIID, PropertyName);
end;

function TideBTDesigner.GetDemon(const AClassIID: TGUID): TSHComponent;
begin
  Result := nil;
  if Assigned(RegistryIntf) then Result := RegistryIntf.GetRegDemon(AClassIID);
end;

function TideBTDesigner.GetFactory(const AClassIID: TGUID): ISHComponentFactory;
begin
  if Assigned(RegistryIntf) then Result := RegistryIntf.GetRegComponentFactory(AClassIID);
end;

function TideBTDesigner.GetOptions(const AClassIID: TGUID): ISHComponentOptions;
begin
  if Assigned(RegistryIntf) then Result := RegistryIntf.GetRegComponentOptions(AClassIID);
end;

procedure TideBTDesigner.IFreeNotification(AComponent: TComponent);
begin
  if Supports(AComponent, ISHComponent) or Supports(AComponent, ISHComponentForm) then
  begin
    AComponent.FreeNotification(Self);

    if Supports(AComponent, ISHComponent) then
      ComponentFactoryIntf.Components.Add(AComponent);

    if Supports(AComponent, ISHComponentForm) then
      ComponentFactoryIntf.ComponentForms.Add(AComponent);
  end;
end;

procedure TideBTDesigner.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if Supports(AComponent, ISHComponent) then
      ComponentFactoryIntf.Components.Remove(AComponent);

    if Supports(AComponent, ISHComponentForm) then
      ComponentFactoryIntf.ComponentForms.Remove(AComponent);
  end;
  inherited Notification(AComponent, Operation);
end;

function TideBTDesigner.CreateComponent(const AOwnerIID, AClassIID: TGUID;
  const ACaption: string): TSHComponent;
begin
  Result := nil;
  if Assigned(ComponentFactoryIntf) then Result := ComponentFactoryIntf.CreateComponent(AOwnerIID, AClassIID, ACaption);
end;

function TideBTDesigner.DestroyComponent(AComponent: TSHComponent): Boolean;
begin
  Result := Assigned(ComponentFactoryIntf) and ComponentFactoryIntf.DestroyComponent(AComponent);
end;

function TideBTDesigner.FindComponent(const AInstanceIID: TGUID): TSHComponent;
begin
  Result := nil;
  if Assigned(ComponentFactoryIntf) then Result := ComponentFactoryIntf.FindComponent(AInstanceIID);
end;

function TideBTDesigner.FindComponent(const AOwnerIID, AClassIID: TGUID): TSHComponent;
begin
  Result := nil;
  if Assigned(ComponentFactoryIntf) then Result := ComponentFactoryIntf.FindComponent(AOwnerIID, AClassIID);
end;

function TideBTDesigner.FindComponent(const AOwnerIID, AClassIID: TGUID; const ACaption: string): TSHComponent;
begin
  Result := nil;
  if Assigned(ComponentFactoryIntf) then Result := ComponentFactoryIntf.FindComponent(AOwnerIID, AClassIID, ACaption);
end;

procedure TideBTDesigner.SendEvent(AEvent: TSHEvent);
var
  I: Integer;
  BTEventReceiverIntf: ISHEventReceiver;
begin
  if Assigned(ComponentFactoryIntf) then
    ComponentFactoryIntf.SendEvent(AEvent);

  for I := Pred(Screen.FormCount) downto 0 do
    if (not Supports(Screen.Forms[I], ISHComponentForm)) and
       Supports(Screen.Forms[I], ISHEventReceiver, BTEventReceiverIntf) then
    begin
      BTEventReceiverIntf.ReceiveEvent(AEvent);
    end;
end;

procedure TideBTDesigner.PostEvent(AEvent: TSHEvent);
begin
  PostEventEvent := AEvent;
  StartTimerPostEvent;
end;

procedure TideBTDesigner.GetPropValues(Source: TPersistent; AParentName: string; AStrings: TStrings;
  PropNameList: TStrings = nil; Include: Boolean = True);
begin
  ideSHSysUtils.GetPropValues(Source, AParentName, AStrings, PropNameList, Include);
end;

procedure TideBTDesigner.SetPropValues(Dest: TPersistent; AParentName: string; AStrings: TStrings;
  PropNameList: TStrings = nil; Include: Boolean = True);
begin
  ideSHSysUtils.SetPropValues(Dest, AParentName, AStrings, PropNameList, Include);
end;

procedure TideBTDesigner.WritePropValuesToFile(const FileName, Section: string;
  Source: TPersistent; PropNameList: TStrings = nil; Include: Boolean = True);
begin
  ideSHSysUtils.WritePropValuesToFile(FileName, Section, Source, PropNameList, Include);
end;

procedure TideBTDesigner.ReadPropValuesFromFile(const FileName, Section: string;
  Dest: TPersistent; PropNameList: TStrings = nil; Include: Boolean = True);
begin
  ideSHSysUtils.ReadPropValuesFromFile(FileName, Section, Dest, PropNameList, Include);
end;

function TideBTDesigner.ExistsComponent(AComponent: TSHComponent): Boolean;
begin
  Result := ExistsComponent(AComponent, EmptyStr);
end;

function TideBTDesigner.ExistsComponent(AComponent: TSHComponent; const CallString: string): Boolean;
begin
//  if Supports(AComponent, ISHRegistration) then
//    Result := BTRegistryExplorerIntf.Exists(AComponent)
//  else
  Result := False;
  if Assigned(MegaEditorIntf) then
    Result := MegaEditorIntf.Exists(AComponent, CallString);
end;

function TideBTDesigner.ChangeNotification(AComponent: TSHComponent; Operation: TOperation): Boolean;
begin
  Result := ChangeNotification(AComponent, EmptyStr, Operation);
end;

function TideBTDesigner.ChangeNotification(AComponent: TSHComponent; const CallString: string; Operation: TOperation): Boolean;
begin
  Result := False;
  case Operation of
    opInsert:
      if Supports(AComponent, ISHRegistration) then
      begin
        Result := Assigned(NavigatorIntf) and NavigatorIntf.RegisterConnection(AComponent);
      end else
      begin
        Result := MegaEditorIntf.Add(AComponent, CallString);
        if Result and (GetCurrentComponentForm <> nil) then GetCurrentComponentForm.BringToTop;
      end;
    opRemove:
      if Supports(AComponent, ISHRegistration) then
        Result := Assigned(NavigatorIntf) and NavigatorIntf.UnregisterConnection(AComponent)
      else
        Result := MegaEditorIntf.Remove(AComponent, CallString);
  end;
end;

function TideBTDesigner.JumpTo(const AInstanceIID, AClassIID: TGUID; ACaption: string): Boolean;
var
  vComponent, vOwner, vSource: TSHComponent;
  ISHDatabaseIntf: ISHDatabase;
  ClassIIDList: TStrings;
  I: Integer;
begin
  Result := False;
  ClassIIDList := TStringList.Create;
  try
    vComponent := FindComponent(AInstanceIID);
    if Assigned(vComponent) then
    begin
      vOwner := FindComponent(vComponent.OwnerIID);
      if IsEqualGUID(IUnknown, AClassIID) then
      begin
        if Supports(vOwner, ISHDatabase, ISHDatabaseIntf) then
          ClassIIDList.Assign(ISHDatabaseIntf.GetSchemeClassIIDList(ACaption));
      end else
        ClassIIDList.Add(GUIDToString(AClassIID));

      for I := Pred(ClassIIDList.Count) downto 0 do
      begin
        if Assigned(vOwner) then
          vSource := ComponentFactoryIntf.CreateComponent(vOwner.InstanceIID, StringToGUID(ClassIIDList[I]), ACaption)
        else
          vSource := ComponentFactoryIntf.CreateComponent(IUnknown, StringToGUID(ClassIIDList[I]), ACaption);
        Result := Assigned(vSource);
        if Result and Assigned(ObjectEditorIntf) then
          ObjectEditorIntf.Jump(vComponent, vSource);
      end;
    end;
  finally
    FreeAndNil(ClassIIDList);
  end;
//  BTComponentFactoryIntf.CreateComponent(OwnerIID, Data.ClassIID, Data.NormalText);
//  BTComponentFactoryIntf.CreateComponent(IUnknown, Data.ClassIID, EmptyStr);
end;

function TideBTDesigner.RegisterConnection(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(NavigatorIntf) and NavigatorIntf.RegisterConnection(AConnection);
end;

function TideBTDesigner.UnregisterConnection(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(NavigatorIntf) and NavigatorIntf.UnregisterConnection(AConnection);
end;

function TideBTDesigner.DestroyConnection(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(NavigatorIntf) and NavigatorIntf.DestroyConnection(AConnection);
end;

function TideBTDesigner.ConnectTo(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(NavigatorIntf) and NavigatorIntf.ConnectTo(AConnection);
end;

function TideBTDesigner.ReconnectTo(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(NavigatorIntf) and NavigatorIntf.ReconnectTo(AConnection);
end;

function TideBTDesigner.DisconnectFrom(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(NavigatorIntf) and NavigatorIntf.DisconnectFrom(AConnection);
end;

procedure TideBTDesigner.RefreshConnection(AConnection: TSHComponent);
begin
  if Assigned(NavigatorIntf) then NavigatorIntf.RefreshConnection(AConnection);
end;

procedure TideBTDesigner.RestoreConnection(AConnection: TSHComponent);
begin
  FLostConnectList.Add(AConnection);
  FConnectTimer.Enabled := True;
end;

function TideBTDesigner.SynchronizeConnection(AConnection: TSHComponent;
  const AClassIID: TGUID; const ACaption: string; Operation: TOperation): Boolean;
begin
  Result := Assigned(NavigatorIntf) and
    NavigatorIntf.SynchronizeConnection(AConnection, AClassIID, ACaption, Operation);
end;

function TideBTDesigner.GetLastDragObject: TDragObjectInfo;
begin
  Result:=LastDragObject
end;

procedure TideBTDesigner.ReadStringsFromIni(const FileName,
  Section: string; Source: TStrings);
begin
 LoadStringsFromFile(FileName,Section,Source)
end;

procedure TideBTDesigner.SaveStringsToIni(const FileName, Section: string;
  Source: TStrings; EraseOldSection: boolean);
begin
  SaveStringsToFile(FileName, Section,Source,EraseOldSection)
end;

initialization
  RegExpr := TRegExpr.Create;

finalization
  FreeAndNil(RegExpr);

end.


