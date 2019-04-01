unit ibSHRegister;

interface

uses
  SysUtils, Classes, Controls, Forms, Dialogs,
  SHDesignIntf, SHDevelopIntf,
  ibSHDesignIntf, ibSHDriverIntf, ibSHComponent;

type
  TibBTRegisterFactory = class(TibBTComponentFactory)
  public
    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    function CreateComponent(const AOwnerIID, AClassIID: TGUID; const ACaption: string): TSHComponent; override;
    function DestroyComponent(AComponent: TSHComponent): Boolean; override;
  end;

procedure Register();

implementation

uses
  ibSHConsts, ibSHMessages,
  ibSHServer, ibSHDatabase,
  ibSHRegisterActions,
  ibSHRegisterEditors,
  ibSHRegisterFrm,
  ibSHUserConnectedFrm;

procedure Register();
begin
  SHRegisterImage(GUIDToString(IibSHServer),          'Server.bmp');
//  SHRegisterImage(GUIDToString(IfbSHServer),          'Server.bmp');

  SHRegisterImage(GUIDToString(IibSHDatabase),        'Database.bmp');
//  SHRegisterImage(GUIDToString(IfbSHDatabase),        'Database.bmp');

  SHRegisterImage(GUIDToString(IibSHServerOptions),   'Server.bmp');
  SHRegisterImage(GUIDToString(IfbSHServerOptions),   'Server.bmp');

  SHRegisterImage(GUIDToString(IibSHDatabaseOptions), 'Database.bmp');
  SHRegisterImage(GUIDToString(IfbSHDatabaseOptions), 'Database.bmp');

  SHRegisterImage(TibSHRegisterServerAction.ClassName,         'ServerRegister.bmp');
  SHRegisterImage(TibSHRegisterDatabaseAction.ClassName,       'DatabaseRegister.bmp');
  SHRegisterImage(TibSHCloneServerAction.ClassName,            'ServerClone.bmp');
  SHRegisterImage(TibSHCloneDatabaseAction.ClassName,          'DatabaseClone.bmp');
  SHRegisterImage(TibSHUnregisterServerAction.ClassName,       'ServerUnregister.bmp');
  SHRegisterImage(TibSHUnregisterDatabaseAction.ClassName,     'DatabaseUnregister.bmp');
  SHRegisterImage(TibSHCreateDatabaseAction.ClassName,         'DatabaseCreate.bmp');
  SHRegisterImage(TibSHDropDatabaseAction.ClassName,           'DatabaseDrop.bmp');
  SHRegisterImage(TibSHAliasInfoServerAction.ClassName,        'ServerInfo.bmp');
  SHRegisterImage(TibSHAliasInfoDatabaseAction.ClassName,      'DatabaseInfo.bmp');

  SHRegisterImage(TibSHServerEditorRegisterDatabase.ClassName, 'DatabaseRegister.bmp');
  SHRegisterImage(TibSHServerEditorCreateDatabase.ClassName,   'DatabaseCreate.bmp');
  SHRegisterImage(TibSHServerEditorClone.ClassName,            'ServerClone.bmp');
  SHRegisterImage(TibSHServerEditorUnregister.ClassName,       'ServerUnregister.bmp');
  SHRegisterImage(TibSHServerEditorTestConnect.ClassName,      'Button_ConnectTest.bmp');
  SHRegisterImage(TibSHServerEditorRegInfo.ClassName,          'ServerInfo.bmp');

  SHRegisterImage(TibSHDatabaseEditorConnect.ClassName,        'Button_Connect.bmp');
  SHRegisterImage(TibSHDatabaseEditorReconnect.ClassName,      'Button_Reconnect.bmp');
  SHRegisterImage(TibSHDatabaseEditorDisconnect.ClassName,     'Button_Disconnect.bmp');
  SHRegisterImage(TibSHDatabaseEditorRefresh.ClassName,        'Button_Refresh.bmp');
  SHRegisterImage(TibSHDatabaseEditorActiveUsers.ClassName,    'User.bmp');
  SHRegisterImage(TibSHDatabaseEditorOnline.ClassName,         'Online.bmp');
  SHRegisterImage(TibSHDatabaseEditorShutdown.ClassName,       'Shutdown.bmp');
  SHRegisterImage(TibSHDatabaseEditorClone.ClassName,          'DatabaseClone.bmp');
  SHRegisterImage(TibSHDatabaseEditorUnregister.ClassName,     'DatabaseUnregister.bmp');
  SHRegisterImage(TibSHDatabaseEditorDrop.ClassName,           'DatabaseDrop.bmp');
  SHRegisterImage(TibSHDatabaseEditorTestConnect.ClassName,    'Button_ConnectTest.bmp');
  SHRegisterImage(TibSHDatabaseEditorRegInfo.ClassName,        'DatabaseInfo.bmp');

  SHRegisterActions([ // Common Register
    TibSHRegisterServerAction,
    TibSHRegisterDatabaseAction,
    {-}  TibSHRegisterSeparatorAction,
    TibSHCloneServerAction,
    TibSHCloneDatabaseAction,
    {-}  TibSHRegisterSeparatorAction,
    TibSHUnregisterServerAction,
    TibSHUnregisterDatabaseAction,
    {-}  TibSHRegisterSeparatorAction,
    TibSHCreateDatabaseAction,
    TibSHDropDatabaseAction,
    {-}  TibSHRegisterSeparatorAction,
    TibSHAliasInfoServerAction,
    TibSHAliasInfoDatabaseAction]);

  SHRegisterActions([ // Server
    TibSHServerEditorRegisterDatabase,
    TibSHServerEditorCreateDatabase,
    {-}  TibSHServerSeparatorEditorAction,
    TibSHServerEditorClone,
    TibSHServerEditorUnregister,
    {-}  TibSHServerSeparatorEditorAction,
    TibSHServerEditorTestConnect,    
    TibSHServerEditorRegInfo]);

  SHRegisterActions([ // Database
    TibSHDatabaseEditorConnect,
    TibSHDatabaseEditorReconnect,
    TibSHDatabaseEditorDisconnect,
    TibSHDatabaseEditorRefresh,
    {-}  TibSHDatabaseSeparatorEditorAction,
    TibSHDatabaseEditorActiveUsers,
    {-}  TibSHDatabaseSeparatorEditorAction,
    TibSHDatabaseEditorOnline,
    TibSHDatabaseEditorShutdown,
    {-}  TibSHDatabaseSeparatorEditorAction,
    TibSHDatabaseEditorClone,
    TibSHDatabaseEditorUnregister,
    TibSHDatabaseEditorDrop,
    {-}  TibSHDatabaseSeparatorEditorAction,
    TibSHDatabaseEditorTestConnect,
    TibSHDatabaseEditorRegInfo]);



  SHRegisterComponents([TibSHServer, TibSHDatabase]);
  SHRegisterComponents([TibBTRegisterFactory]);
  SHRegisterComponents([TibSHServerOptions, TfbSHServerOptions,
    TibSHDatabaseOptions, TfbSHDatabaseOptions]);

  SHRegisterPropertyEditor(IibSHServer, SCallHost, TibBTHostPropEditor);
  SHRegisterPropertyEditor(IibSHDummy, SCallVersion, TibSHServerVersionPropEditor);
  SHRegisterPropertyEditor(IibSHDummy, SCallClientLibrary, TibBTClientLibraryPropEditor);
  SHRegisterPropertyEditor(IibSHDummy, SCallProtocol, TibBTProtocolPropEditor);
  SHRegisterPropertyEditor(IibSHDummy, SCallSecurityDatabase, TibSHDatabasePropEditor);
  SHRegisterPropertyEditor(IibSHDummy, SCallPassword, TibBTPasswordPropEditor);

  SHRegisterPropertyEditor(IibSHDummy, SCallServer, TibSHServerPropEditor);
  SHRegisterPropertyEditor(IibSHDatabase, SCallDatabase, TibSHDatabasePropEditor);
  SHRegisterPropertyEditor(IibSHDatabase, SCallPageSize, TibBTPageSizePropEditor);
  SHRegisterPropertyEditor(IibSHDatabase, SCallSQLDialect, TibBTSQLDialectPropEditor);
  SHRegisterPropertyEditor(IibSHDummy, SCallCharset, TibBTCharsetPropEditor);
  SHRegisterPropertyEditor(IibSHDatabase, SCallCharset, TibBTCharsetPropEditor);
  SHRegisterPropertyEditor(IibSHDatabase, SCallAdditionalConnectParams, TibBTAdditionalConnectParamsPropEditor);

  SHRegisterPropertyEditor(IibSHDatabase, 'DatabaseAliasOptions', TibSHDatabaseAliasOptionsPropEditor);
  SHRegisterPropertyEditor(IibSHDatabaseAliasOptions, 'Navigator', TibSHDatabaseAliasOptionsPropEditor);
  SHRegisterPropertyEditor(IibSHDatabaseAliasOptions, 'DDL', TibSHDatabaseAliasOptionsPropEditor);
  SHRegisterPropertyEditor(IibSHDatabaseAliasOptions, 'DML', TibSHDatabaseAliasOptionsPropEditor);

  SHRegisterPropertyEditor(IibSHDDLOptions, 'StartDomainForm', TibBTStartFromPropEditor);
  SHRegisterPropertyEditor(IibSHDDLOptions, 'StartTableForm', TibBTStartFromPropEditor);
  SHRegisterPropertyEditor(IibSHDDLOptions, 'StartIndexForm', TibBTStartFromPropEditor);
  SHRegisterPropertyEditor(IibSHDDLOptions, 'StartViewForm', TibBTStartFromPropEditor);
  SHRegisterPropertyEditor(IibSHDDLOptions, 'StartProcedureForm', TibBTStartFromPropEditor);
  SHRegisterPropertyEditor(IibSHDDLOptions, 'StartTriggerForm', TibBTStartFromPropEditor);
  SHRegisterPropertyEditor(IibSHDDLOptions, 'StartGeneratorForm', TibBTStartFromPropEditor);
  SHRegisterPropertyEditor(IibSHDDLOptions, 'StartExceptionForm', TibBTStartFromPropEditor);
  SHRegisterPropertyEditor(IibSHDDLOptions, 'StartFunctionForm', TibBTStartFromPropEditor);
  SHRegisterPropertyEditor(IibSHDDLOptions, 'StartFilterForm', TibBTStartFromPropEditor);
  SHRegisterPropertyEditor(IibSHDDLOptions, 'StartRoleForm', TibBTStartFromPropEditor);

  SHRegisterPropertyEditor(IibSHDMLOptions, 'ConfirmEndTransaction', TibBTConfirmEndTransaction);
  SHRegisterPropertyEditor(IibSHDMLOptions, 'DefaultTransactionAction', TibBTDefaultTransactionAction);
  SHRegisterPropertyEditor(IibSHDMLOptions, 'IsolationLevel', TibBTIsolationLevelPropEditor);

  SHRegisterComponentForm(IibSHDummy, SCallRegister, TibBTRegisterForm);
  SHRegisterComponentForm(IibSHDummy, SCallActiveUsers, TibSHUserConnectedForm);
end;

{ TibBTRegisterFactory }

function TibBTRegisterFactory.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHBranch) or IsEqualGUID(AClassIID, IfbSHBranch);
end;

function TibBTRegisterFactory.CreateComponent(const AOwnerIID, AClassIID: TGUID; const ACaption: string): TSHComponent;
begin
  Result := nil;

  if IsEqualGUID(AClassIID, ISHServer) then
  begin
    Result := Designer.GetComponent(IibSHServer).Create(nil);
    Result.OwnerIID := AOwnerIID;
    Designer.ChangeNotification(Result, opInsert);
  end;

  if IsEqualGUID(AClassIID, ISHDatabase) then
  begin
    Result := Designer.GetComponent(IibSHDatabase).Create(nil);
    if not IsEqualGUID(AOwnerIID, IUnknown) then Result.OwnerIID := AOwnerIID;
    Designer.ChangeNotification(Result, opInsert);
  end;
end;

function TibBTRegisterFactory.DestroyComponent(AComponent: TSHComponent): Boolean;
begin
  Result := Designer.ChangeNotification(AComponent, opRemove);
  if Result then FreeAndNil(AComponent);
end;

initialization

  Register;

end.




