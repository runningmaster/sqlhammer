unit ibSHRegisterActions;

interface

uses
  SysUtils, Classes, Controls, Dialogs, StrUtils,
  SHDesignIntf, ibSHDesignIntf;

type
  IibSHRegisterServerAction = interface
  ['{596F42B0-5C53-482C-9A2A-540ED742978F}']
  end;
  IibSHRegisterDatabaseAction = interface
  ['{37FB7438-3281-4ECD-90FD-84EA7E63A9B4}']
  end;

  IibSHCloneServerAction = interface
  ['{A574050D-5B30-4B4E-AD3B-D706294D1748}']
  end;
  IibSHCloneDatabaseAction = interface
  ['{6BD1B818-D74A-4834-84D1-DF9612D4644E}']
  end;

  IibSHUnregisterServerAction = interface
  ['{9DE62BCE-0AA6-4A11-BBFF-7CD0C155B4E0}']
  end;
  IibSHUnregisterDatabaseAction = interface
  ['{CDDA0495-8C74-46F6-988D-8A804FABC2E4}']
  end;

  IibSHCreateDatabaseAction = interface
  ['{5D62554E-3032-40AD-8615-EBB5C2857772}']
  end;
  IibSHDropDatabaseAction = interface
  ['{A7DA1734-9C23-45A8-8BD6-903CD6C07115}']
  end;

  IibSHAliasInfoServerAction = interface
  ['{B16D8420-05AA-4B75-9852-8561FFCBF36D}']
  end;
  IibSHAliasInfoDatabaseAction = interface
  ['{BEE9C039-60E1-4640-AAEB-475168E9B4AD}']
  end;

  // Server Editor
  IibSHServerEditorRegisterDatabase = interface
  ['{F8866A8C-FEF3-4059-8153-605164E39E20}']
  end;
  IibSHServerEditorCreateDatabase = interface
  ['{772D970C-4AF3-4C7D-91AC-E0F9D8202004}']
  end;
  IibSHServerEditorClone = interface
  ['{A35CBB41-2ADA-4CC0-9276-D62796F91149}']
  end;
  IibSHServerEditorUnregister = interface
  ['{9F442F2B-54DE-4AF1-8342-D6B9C5348798}']
  end;
  IibSHServerEditorTestConnect = interface
  ['{7D8EA024-138B-4F95-88D6-15A2C291EBE6}']
  end;
  IibSHServerEditorRegInfo = interface
  ['{E388BECA-1A91-4937-8CD0-1DC0E50C446D}']
  end;

  // Database Editor
  IibSHDatabaseEditorConnect = interface
  ['{95A34CAC-5A56-4B7D-B548-AA21B9056020}']
  end;
  IibSHDatabaseEditorReconnect = interface
  ['{EBFC98BA-7ED8-4508-9828-628C5B951E2B}']
  end;
  IibSHDatabaseEditorDisconnect = interface
  ['{F67A9C92-79D2-4173-BC8C-8F714AA268F3}']
  end;
  IibSHDatabaseEditorRefresh = interface
  ['{264901AA-82A9-41DB-A4FB-CF8D40AE261E}']
  end;
  IibSHDatabaseEditorActiveUsers = interface
  ['{8B597B1A-5881-4647-94E1-B694E095ED5E}']
  end;
  IibSHDatabaseEditorOnline = interface
  ['{6A793041-083C-4896-8687-10E206185EE5}']
  end;
  IibSHDatabaseEditorShutdown = interface
  ['{DD31AA1F-0314-43B5-AAF8-4E15823E3498}']
  end;
  IibSHDatabaseEditorClone = interface
  ['{3F9EDB78-9E15-471C-8C69-51EAE5C7DF34}']
  end;
  IibSHDatabaseEditorUnregister = interface
  ['{6C8D988C-B50D-4991-96F5-D918B063F7D9}']
  end;
  IibSHDatabaseEditorDrop = interface
  ['{EEB974CB-866B-4CB6-8A2D-CE149952868C}']
  end;
  IibSHDatabaseEditorTestConnect = interface
  ['{9A0A489D-9D42-4E8F-A68E-15BD179485A6}']
  end;
  IibSHDatabaseEditorRegInfo = interface
  ['{74ED32E4-9921-4977-A0E5-F69176693B1D}']
  end;

  TibSHCustomRegAction = class(TSHAction)
  protected
    procedure CloneAssignServer(AClone, ATarget: TSHComponent);
    procedure CloneAssignDatabase(AClone, ATarget: TSHComponent);
    procedure RegisterServer(AClone: TSHComponent);
    procedure RegisterDatabase(AClone: TSHComponent);
    procedure UnregisterServer;
    procedure UnregisterDatabase;
    procedure CreateDatabase;
    procedure DropDatabase;

    procedure TestConnect;
    procedure ShowServerAliasInfo;
    procedure ShowDatabaseAliasInfo;
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;

    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHRegisterSeparatorAction = class(TibSHCustomRegAction)
  end;

  TibSHRegisterServerAction = class(TibSHCustomRegAction, IibSHRegisterServerAction)
  end;
  TibSHRegisterDatabaseAction = class(TibSHCustomRegAction, IibSHRegisterDatabaseAction)
  end;

  TibSHCloneServerAction = class(TibSHCustomRegAction, IibSHCloneServerAction)
  end;
  TibSHCloneDatabaseAction = class(TibSHCustomRegAction, IibSHCloneDatabaseAction)
  end;

  TibSHUnregisterServerAction = class(TibSHCustomRegAction, IibSHUnregisterServerAction)
  end;
  TibSHUnregisterDatabaseAction = class(TibSHCustomRegAction, IibSHUnregisterDatabaseAction)
  end;

  TibSHCreateDatabaseAction = class(TibSHCustomRegAction, IibSHCreateDatabaseAction)
  end;
  TibSHDropDatabaseAction = class(TibSHCustomRegAction, IibSHDropDatabaseAction)
  end;

  TibSHAliasInfoServerAction = class(TibSHCustomRegAction, IibSHAliasInfoServerAction)
  end;
  TibSHAliasInfoDatabaseAction = class(TibSHCustomRegAction, IibSHAliasInfoDatabaseAction)
  end;


  TibSHCustomServerRegEditorAction = class(TibSHCustomRegAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;

    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHServerSeparatorEditorAction = class(TibSHCustomServerRegEditorAction)
  end;

  TibSHCustomDatabaseRegEditorAction = class(TibSHCustomRegAction)
  private
    procedure ShowActiveUsers;
    procedure DatabaseOnline;
    procedure DatabaseShutdown;
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;

    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHDatabaseSeparatorEditorAction = class(TibSHCustomDatabaseRegEditorAction)
  end;

  // Server Editor
  TibSHServerEditorRegisterDatabase = class(TibSHCustomServerRegEditorAction, IibSHServerEditorRegisterDatabase)
  end;
  TibSHServerEditorCreateDatabase = class(TibSHCustomServerRegEditorAction, IibSHServerEditorCreateDatabase)
  end;
  TibSHServerEditorClone = class(TibSHCustomServerRegEditorAction, IibSHServerEditorClone)
  end;
  TibSHServerEditorUnregister = class(TibSHCustomServerRegEditorAction, IibSHServerEditorUnregister)
  end;
  TibSHServerEditorTestConnect = class(TibSHCustomServerRegEditorAction, IibSHServerEditorTestConnect)
  end;
  TibSHServerEditorRegInfo = class(TibSHCustomServerRegEditorAction, IibSHServerEditorRegInfo)
  end;

  // Database Editor
  TibSHDatabaseEditorConnect = class(TibSHCustomDatabaseRegEditorAction, IibSHDatabaseEditorConnect)
  end;
  TibSHDatabaseEditorReconnect = class(TibSHCustomDatabaseRegEditorAction, IibSHDatabaseEditorReconnect)
  end;
  TibSHDatabaseEditorDisconnect = class(TibSHCustomDatabaseRegEditorAction, IibSHDatabaseEditorDisconnect)
  end;
  TibSHDatabaseEditorRefresh = class(TibSHCustomDatabaseRegEditorAction, IibSHDatabaseEditorRefresh)
  end;
  TibSHDatabaseEditorActiveUsers = class(TibSHCustomDatabaseRegEditorAction, IibSHDatabaseEditorActiveUsers)
  end;
  TibSHDatabaseEditorOnline = class(TibSHCustomDatabaseRegEditorAction, IibSHDatabaseEditorOnline)
  end;
  TibSHDatabaseEditorShutdown = class(TibSHCustomDatabaseRegEditorAction, IibSHDatabaseEditorShutdown)
  end;
  TibSHDatabaseEditorClone = class(TibSHCustomDatabaseRegEditorAction, IibSHDatabaseEditorClone)
  end;
  TibSHDatabaseEditorUnregister = class(TibSHCustomDatabaseRegEditorAction, IibSHDatabaseEditorUnregister)
  end;
  TibSHDatabaseEditorDrop = class(TibSHCustomDatabaseRegEditorAction, IibSHDatabaseEditorDrop)
  end;
  TibSHDatabaseEditorTestConnect = class(TibSHCustomDatabaseRegEditorAction, IibSHDatabaseEditorTestConnect)
  end;
  TibSHDatabaseEditorRegInfo = class(TibSHCustomDatabaseRegEditorAction, IibSHDatabaseEditorRegInfo)
  end;

implementation

uses
  ibSHMessages, ibSHConsts, ibSHValues;

{ TibSHCustomRegAction }

constructor TibSHCustomRegAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallRegister;
  Caption := '-'; // separator

  if Supports(Self, IibSHRegisterServerAction) then Caption := Format('%s', ['Register Server']);
  if Supports(Self, IibSHRegisterDatabaseAction) then Caption := Format('%s', ['Register Database']);
  if Supports(Self, IibSHCloneServerAction) then Caption := Format('%s', ['Clone Server']);
  if Supports(Self, IibSHCloneDatabaseAction) then Caption := Format('%s', ['Clone Database']);
  if Supports(Self, IibSHUnregisterServerAction) then Caption := Format('%s', ['Unregister Server']);
  if Supports(Self, IibSHUnregisterDatabaseAction) then Caption := Format('%s', ['Unregister Database']);
  if Supports(Self, IibSHCreateDatabaseAction) then Caption := Format('%s', ['Create Database']);
  if Supports(Self, IibSHDropDatabaseAction) then Caption := Format('%s', ['Drop Database']);
  if Supports(Self, IibSHAliasInfoServerAction) then Caption := Format('%s', ['View Server Alias Info...']);
  if Supports(Self, IibSHAliasInfoDatabaseAction) then Caption := Format('%s', ['View Database Alias Info...']);
end;

function TibSHCustomRegAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHCustomRegAction.CloneAssignServer(AClone, ATarget: TSHComponent);
begin
  (ATarget as IibSHServer).Host := (AClone as IibSHServer).Host;
  (ATarget as IibSHServer).Alias := Format('%s CLONE', [(AClone as IibSHServer).Alias]);
  (ATarget as IibSHServer).Version := (AClone as IibSHServer).Version;
  (ATarget as IibSHServer).LongMetadataNames := (AClone as IibSHServer).LongMetadataNames;
  (ATarget as IibSHServer).ClientLibrary := (AClone as IibSHServer).ClientLibrary;
  (ATarget as IibSHServer).Protocol := (AClone as IibSHServer).Protocol;
  (ATarget as IibSHServer).Port := (AClone as IibSHServer).Port;
  (ATarget as IibSHServer).SecurityDatabase := (AClone as IibSHServer).SecurityDatabase;
  (ATarget as IibSHServer).UserName := (AClone as IibSHServer).UserName;
  (ATarget as IibSHServer).Password := (AClone as IibSHServer).Password;
  (ATarget as IibSHServer).Role := (AClone as IibSHServer).Role;
  (ATarget as IibSHServer).LoginPrompt := (AClone as IibSHServer).LoginPrompt;
  (ATarget as IibSHServer).Description := (AClone as IibSHServer).Description;
end;

procedure TibSHCustomRegAction.CloneAssignDatabase(AClone, ATarget: TSHComponent);
begin
  (ATarget as IibSHDatabase).OwnerIID := (AClone as IibSHDatabase).OwnerIID;
  (ATarget as IibSHDatabase).Database := (AClone as IibSHDatabase).Database;
  (ATarget as IibSHDatabase).Alias := Format('%s CLONE ', [(AClone as IibSHDatabase).Alias]);
  (ATarget as IibSHDatabase).PageSize := (AClone as IibSHDatabase).PageSize;
  (ATarget as IibSHDatabase).Charset := (AClone as IibSHDatabase).Charset;
  (ATarget as IibSHDatabase).SQLDialect := (AClone as IibSHDatabase).SQLDialect;
  (ATarget as IibSHDatabase).CapitalizeNames := (AClone as IibSHDatabase).CapitalizeNames;
  (ATarget as IibSHDatabase).AdditionalConnectParams.Assign((AClone as IibSHDatabase).AdditionalConnectParams);
  (ATarget as IibSHDatabase).UserName := (AClone as IibSHDatabase).UserName;
  (ATarget as IibSHDatabase).Password := (AClone as IibSHDatabase).Password;
  (ATarget as IibSHDatabase).Role := (AClone as IibSHDatabase).Role;
  (ATarget as IibSHDatabase).LoginPrompt := (AClone as IibSHDatabase).LoginPrompt;
  (ATarget as IibSHDatabase).Description := (AClone as IibSHDatabase).Description;

  //  TODO DatabaseAliasOptions ?
end;

procedure TibSHCustomRegAction.RegisterServer(AClone: TSHComponent);
var
  Connection: TSHComponent;
begin
  Connection := nil;
  Connection := Designer.GetComponent(IibSHServer).Create(nil);
  if Assigned(Connection) then
  begin
    Connection.OwnerIID := Designer.CurrentBranch.InstanceIID;
    if Assigned(AClone) then CloneAssignServer(AClone, Connection);

    Connection.Tag := 1; // rtServer
    if IsPositiveResult(Designer.ShowModal(Connection, SCallRegister)) then
    begin
      Designer.RegisterConnection(Connection);
      (Connection as ISHDataRootDirectory).CreateDirectory((Connection as ISHDataRootDirectory).DataRootDirectory);
      if Connection.Tag = 5 then RegisterDatabase(nil);
    end else
      FreeAndNil(Connection);
  end;

  if Assigned(Connection) then Connection.Tag := 0;
end;

procedure TibSHCustomRegAction.RegisterDatabase(AClone: TSHComponent);
var
  Connection: TSHComponent;
begin
  Connection := nil;

  if Assigned(AClone) and (AClone.Tag = 5) then
    Connection := AClone
  else
    Connection := Designer.GetComponent(IibSHDatabase).Create(nil);

  if Assigned(Connection) then
  begin
    if Assigned(AClone) and (AClone <> Connection) then
      CloneAssignDatabase(AClone, Connection)
    else
      if Assigned(Designer.CurrentServer) then
        Connection.OwnerIID := Designer.CurrentServer.InstanceIID;
        
    Connection.Tag := 2; // rtDatabase
    if IsPositiveResult(Designer.ShowModal(Connection, SCallRegister)) then
    begin
      Designer.RegisterConnection(Connection);
            (Connection as ISHDataRootDirectory).CreateDirectory((Connection as ISHDataRootDirectory).DataRootDirectory);
      if Connection.Tag = 5 then Designer.ConnectTo(Connection);
    end else
      FreeAndNil(Connection);
  end;

  if Assigned(Connection) then Connection.Tag := 0;
end;

procedure TibSHCustomRegAction.UnregisterServer;
var
  Connection: TSHComponent;
begin
  Connection := Designer.CurrentServer;
  if Designer.ShowMsg(Format(SUnregisterServer, [Connection.Caption]), mtConfirmation) then
  begin
    if Designer.UnregisterConnection(Connection) then
    begin
      (Connection as ISHDataRootDirectory).DeleteDirectory((Connection as ISHDataRootDirectory).DataRootDirectory);
      Designer.DestroyConnection(Connection);
    end;
  end;
end;

procedure TibSHCustomRegAction.UnregisterDatabase;
var
  Connection: TSHComponent;
begin
  Connection := Designer.CurrentDatabase;
  if Designer.ShowMsg(Format(SUnregisterDatabase, [Connection.Caption]), mtConfirmation) then
  begin
    if Designer.UnregisterConnection(Connection) then
    begin
      (Connection as ISHDataRootDirectory).DeleteDirectory((Connection as ISHDataRootDirectory).DataRootDirectory);
      Designer.DestroyConnection(Connection);
    end;
  end;
end;

procedure TibSHCustomRegAction.CreateDatabase;
var
  Connection: TSHComponent;
begin
  Connection := nil;
  Connection := Designer.GetComponent(IibSHDatabase).Create(nil);
  if Assigned(Connection) then
  begin
    if Assigned(Designer.CurrentServer) then Connection.OwnerIID := Designer.CurrentServer.InstanceIID;
    Connection.Tag := 3; // rtCreate
    Connection.MakePropertyVisible('PageSize');
    Connection.MakePropertyVisible('SQLDialect');
    Connection.MakePropertyInvisible('Alias');
    Connection.MakePropertyInvisible('Role');
    Connection.MakePropertyInvisible('LoginPrompt');
    Connection.MakePropertyInvisible('AdditionalConnectParams');
    Connection.MakePropertyInvisible('CapitalizeNames');
    Connection.MakePropertyInvisible('Description');
    Connection.MakePropertyInvisible('DatabaseAliasOptions');
    if IsPositiveResult(Designer.ShowModal(Connection, SCallRegister)) then
    begin
      (Connection as IibSHDatabase).CreateDatabase;
      if Connection.Tag = 5 then
      begin
        Connection.MakePropertyInvisible('PageSize');
        Connection.MakePropertyInvisible('SQLDialect');
        Connection.MakePropertyVisible('Alias');
        Connection.MakePropertyVisible('Role');
        Connection.MakePropertyVisible('LoginPrompt');
        Connection.MakePropertyVisible('AdditionalConnectParams');
        Connection.MakePropertyVisible('CapitalizeNames');
        Connection.MakePropertyVisible('Description');
        Connection.MakePropertyVisible('DatabaseAliasOptions');
        RegisterDatabase(Connection);
      end else
        FreeAndNil(Connection);
    end else
      FreeAndNil(Connection);
  end;
end;

procedure TibSHCustomRegAction.DropDatabase;
var
  Connection: TSHComponent;
begin
  Connection := Designer.CurrentDatabase;
  if Designer.ShowMsg(Format(SDropDatabase, [Connection.Caption]), mtConfirmation) then
  begin
    (Connection as IibSHDatabase).DropDatabase;
    if Designer.UnregisterConnection(Connection) then
    begin
      (Connection as ISHDataRootDirectory).DeleteDirectory((Connection as ISHDataRootDirectory).DataRootDirectory);
      Designer.DestroyConnection(Connection);
    end;
  end;
end;

procedure TibSHCustomRegAction.TestConnect;
var
  TestConnectionIntf: ISHTestConnection;
begin
  TestConnectionIntf := nil;

  if Self.SupportComponent(IibSHServer) then
    Supports(Designer.CurrentServer, ISHTestConnection, TestConnectionIntf);
  if Self.SupportComponent(IibSHDatabase) then
    Supports(Designer.CurrentDatabase, ISHTestConnection, TestConnectionIntf);

  if Assigned(TestConnectionIntf) and TestConnectionIntf.CanTestConnection then
    TestConnectionIntf.TestConnection;
end;

procedure TibSHCustomRegAction.ShowServerAliasInfo;
var
  RegistrationIntf: ISHRegistration;
begin
  Supports(Designer.CurrentServer, ISHRegistration, RegistrationIntf);
  if Assigned(RegistrationIntf) and RegistrationIntf.CanShowRegistrationInfo then
    RegistrationIntf.ShowRegistrationInfo;
end;

procedure TibSHCustomRegAction.ShowDatabaseAliasInfo;
var
  RegistrationIntf: ISHRegistration;
begin
  Supports(Designer.CurrentDatabase, ISHRegistration, RegistrationIntf);
  if Assigned(RegistrationIntf) and RegistrationIntf.CanShowRegistrationInfo then
    RegistrationIntf.ShowRegistrationInfo;
end;

procedure TibSHCustomRegAction.EventExecute(Sender: TObject);
begin
  if Supports(Self, IibSHRegisterServerAction) then RegisterServer(nil);
  if Supports(Self, IibSHRegisterDatabaseAction) then RegisterDatabase(nil);

  if Supports(Self, IibSHCloneServerAction) then RegisterServer(Designer.CurrentServer);
  if Supports(Self, IibSHCloneDatabaseAction) then RegisterDatabase(Designer.CurrentDatabase);

  if Supports(Self, IibSHUnregisterServerAction) then UnregisterServer;
  if Supports(Self, IibSHUnregisterDatabaseAction) then UnregisterDatabase;

  if Supports(Self, IibSHCreateDatabaseAction) then CreateDatabase;
  if Supports(Self, IibSHDropDatabaseAction) then DropDatabase;

  if Supports(Self, IibSHAliasInfoServerAction) then ShowServerAliasInfo;
  if Supports(Self, IibSHAliasInfoDatabaseAction) then ShowDatabaseAliasInfo;

  Designer.SaveRegisteredConnectionInfo;
end;

procedure TibSHCustomRegAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHCustomRegAction.EventUpdate(Sender: TObject);
begin
  if Supports(Self, IibSHRegisterServerAction) then
  begin
    Enabled := True;
    FDefault := Designer.ServerCount = 0;
  end;
  if Supports(Self, IibSHRegisterDatabaseAction) then
  begin
    Enabled := Designer.ServerCount > 0;
    FDefault := Enabled;
  end;

  if Supports(Self, IibSHCloneServerAction) then
    Enabled := Assigned(Designer.CurrentServer);
  if Supports(Self, IibSHCloneDatabaseAction) then
    Enabled := Assigned(Designer.CurrentDatabase);

  if Supports(Self, IibSHUnregisterServerAction) then
    Enabled := Assigned(Designer.CurrentServer) and not Designer.CurrentServerInUse;
  if Supports(Self, IibSHUnregisterDatabaseAction) then
    Enabled := Assigned(Designer.CurrentDatabase) and not Designer.CurrentDatabaseInUse;

  if Supports(Self, IibSHCreateDatabaseAction) then
    Enabled := Designer.ServerCount > 0;
  if Supports(Self, IibSHDropDatabaseAction) then
    Enabled := Assigned(Designer.CurrentDatabase) and not Designer.CurrentDatabaseInUse;

  if Supports(Self, IibSHAliasInfoServerAction) then
  begin
    Enabled := Assigned(Designer.CurrentServer);
    if Assigned(Designer.CurrentServer) then
    begin
      if Designer.CurrentServerInUse then
        Caption := Format('%s', ['View Server Alias Info...'])
      else
        Caption := Format('%s', ['Edit Server Alias Info...']);
    end;
  end;
  if Supports(Self, IibSHAliasInfoDatabaseAction) then
  begin
    Enabled := Assigned(Designer.CurrentDatabase);
    if Assigned(Designer.CurrentDatabase) then
    begin
      if Designer.CurrentDatabaseInUse then
        Caption := Format('%s', ['View Database Alias Info...'])
      else
        Caption := Format('%s', ['Edit Database Alias Info...']);
    end;  
  end;
end;


{ TibSHCustomServerRegEditorAction }

constructor TibSHCustomServerRegEditorAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallEditor;

  if Supports(Self, IibSHServerEditorRegisterDatabase) then Caption := Format('%s', ['Register Database']);
  if Supports(Self, IibSHServerEditorCreateDatabase) then Caption := Format('%s', ['Create Database']);
  if Supports(Self, IibSHServerEditorClone) then Caption := Format('%s', ['Clone Alias...']);
  if Supports(Self, IibSHServerEditorUnregister) then Caption := Format('%s', ['Unregister']);
  if Supports(Self, IibSHServerEditorTestConnect) then Caption := Format('%s', ['Test Connect']);
  if Supports(Self, IibSHServerEditorRegInfo) then Caption := Format('%s', ['Show Alias Info...']);
end;

function TibSHCustomServerRegEditorAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHServer, AClassIID);
end;

procedure TibSHCustomServerRegEditorAction.EventExecute(Sender: TObject);
begin
  if Supports(Self, IibSHServerEditorRegisterDatabase) then RegisterDatabase(nil);
  if Supports(Self, IibSHServerEditorCreateDatabase) then CreateDatabase;
  if Supports(Self, IibSHServerEditorClone) then RegisterServer(Designer.CurrentServer);
  if Supports(Self, IibSHServerEditorUnregister) then UnregisterServer;
  if Supports(Self, IibSHServerEditorTestConnect) then TestConnect;
  if Supports(Self, IibSHServerEditorRegInfo) then ShowServerAliasInfo;
end;

procedure TibSHCustomServerRegEditorAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHCustomServerRegEditorAction.EventUpdate(Sender: TObject);
begin
  if Supports(Self, IibSHServerEditorRegisterDatabase) then ;
  if Supports(Self, IibSHServerEditorCreateDatabase) then ;
  if Supports(Self, IibSHServerEditorClone) then ;
  if Supports(Self, IibSHServerEditorUnregister) then
    Visible := Assigned(Designer.CurrentServer) and not Designer.CurrentServerInUse;
  if Supports(Self, IibSHServerEditorTestConnect) then
    Visible := Assigned(Designer.CurrentServer) and not Designer.CurrentServerInUse;
  if Supports(Self, IibSHServerEditorRegInfo) then
  begin
    if Assigned(Designer.CurrentServer) then
    begin
      if Designer.CurrentServerInUse then
        Caption := Format('%s', ['View Alias Info...'])
      else
        Caption := Format('%s', ['Edit Alias Info...']);
    end;
  end;
end;

{ TibSHCustomDatabaseRegEditorAction }

constructor TibSHCustomDatabaseRegEditorAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallEditor;

  if Supports(Self, IibSHDatabaseEditorConnect) then Caption := Format('%s', ['Connect']);
  if Supports(Self, IibSHDatabaseEditorReconnect) then Caption := Format('%s', ['Reconnect']);
  if Supports(Self, IibSHDatabaseEditorDisconnect) then Caption := Format('%s', ['Disconnect']);
  if Supports(Self, IibSHDatabaseEditorRefresh) then Caption := Format('%s', ['Refresh']);
  if Supports(Self, IibSHDatabaseEditorActiveUsers) then Caption := Format('%s', ['Active Users...']);
  if Supports(Self, IibSHDatabaseEditorOnline) then Caption := Format('%s', ['Online']);
  if Supports(Self, IibSHDatabaseEditorShutdown) then Caption := Format('%s', ['Shutdown']);
  if Supports(Self, IibSHDatabaseEditorClone) then Caption := Format('%s', ['Clone Alias...']);
  if Supports(Self, IibSHDatabaseEditorUnregister) then Caption := Format('%s', ['Unregister']);
  if Supports(Self, IibSHDatabaseEditorDrop) then Caption := Format('%s', ['Drop']);
  if Supports(Self, IibSHDatabaseEditorTestConnect) then Caption := Format('%s', ['Test Connect']);
  if Supports(Self, IibSHDatabaseEditorRegInfo) then Caption := Format('%s', ['Show Alias Info...']);
end;

function TibSHCustomDatabaseRegEditorAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHDatabase, AClassIID);
end;

procedure TibSHCustomDatabaseRegEditorAction.ShowActiveUsers;
begin
  if Assigned(Designer.CurrentDatabase) then
    Designer.ShowModal(Designer.CurrentDatabase, SCallActiveUsers);
end;

procedure TibSHCustomDatabaseRegEditorAction.DatabaseOnline;
begin
  Designer.UnderConstruction;
end;

procedure TibSHCustomDatabaseRegEditorAction.DatabaseShutdown;
begin
  Designer.UnderConstruction;
end;

procedure TibSHCustomDatabaseRegEditorAction.EventExecute(Sender: TObject);
begin
  if Supports(Self, IibSHDatabaseEditorConnect) then Designer.ConnectTo(Designer.CurrentDatabase);
  if Supports(Self, IibSHDatabaseEditorReconnect) then Designer.ReconnectTo(Designer.CurrentDatabase);
  if Supports(Self, IibSHDatabaseEditorDisconnect) then Designer.DisconnectFrom(Designer.CurrentDatabase);
  if Supports(Self, IibSHDatabaseEditorRefresh) then Designer.RefreshConnection(Designer.CurrentDatabase);
  if Supports(Self, IibSHDatabaseEditorActiveUsers) then ShowActiveUsers;
  if Supports(Self, IibSHDatabaseEditorOnline) then DatabaseOnline;
  if Supports(Self, IibSHDatabaseEditorShutdown) then DatabaseShutdown;
  if Supports(Self, IibSHDatabaseEditorClone) then RegisterDatabase(Designer.CurrentDatabase);
  if Supports(Self, IibSHDatabaseEditorUnregister) then UnregisterDatabase;
  if Supports(Self, IibSHDatabaseEditorDrop) then DropDatabase;
  if Supports(Self, IibSHDatabaseEditorTestConnect) then TestConnect;
  if Supports(Self, IibSHDatabaseEditorRegInfo) then ShowDatabaseAliasInfo;
end;

procedure TibSHCustomDatabaseRegEditorAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHCustomDatabaseRegEditorAction.EventUpdate(Sender: TObject);
begin
  if Supports(Self, IibSHDatabaseEditorConnect) then
  begin
    Visible := Assigned(Designer.CurrentDatabase) and not Designer.CurrentDatabaseInUse;
    FDefault := Visible;
  end;

  if Supports(Self, IibSHDatabaseEditorReconnect) then
    Visible := Assigned(Designer.CurrentDatabase) and Designer.CurrentDatabaseInUse;

  if Supports(Self, IibSHDatabaseEditorDisconnect) then
  begin
    Visible := Assigned(Designer.CurrentDatabase) and Designer.CurrentDatabaseInUse;
    FDefault := Visible;
  end;

  if Supports(Self, IibSHDatabaseEditorRefresh) then
    Visible := Assigned(Designer.CurrentDatabase) and Designer.CurrentDatabaseInUse;
  if Supports(Self, IibSHDatabaseEditorActiveUsers) then
    Visible := Assigned(Designer.CurrentDatabase) and Designer.CurrentDatabaseInUse;
  if Supports(Self, IibSHDatabaseEditorOnline) then
    Visible := Assigned(Designer.CurrentDatabase) and not Designer.CurrentDatabaseInUse;
  if Supports(Self, IibSHDatabaseEditorShutdown) then
    Visible := Assigned(Designer.CurrentDatabase) and not Designer.CurrentDatabaseInUse;
  if Supports(Self, IibSHDatabaseEditorClone) then
    ;
  if Supports(Self, IibSHDatabaseEditorUnregister) then
    Visible := Assigned(Designer.CurrentDatabase) and not Designer.CurrentDatabaseInUse;
  if Supports(Self, IibSHDatabaseEditorDrop) then
    Visible := Assigned(Designer.CurrentDatabase) and not Designer.CurrentDatabaseInUse;
  if Supports(Self, IibSHDatabaseEditorTestConnect) then
    Visible := Assigned(Designer.CurrentDatabase) and not Designer.CurrentDatabaseInUse;

  if Supports(Self, IibSHDatabaseEditorRegInfo) then
  begin
    if Assigned(Designer.CurrentDatabase) then
    begin
      if Designer.CurrentDatabaseInUse then
        Caption := Format('%s', ['View Alias Info...'])
      else
        Caption := Format('%s', ['Edit Alias Info...']);
    end;
  end;
end;

end.
