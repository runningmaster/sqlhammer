unit ibSHServer;

interface

uses
  SysUtils, Classes, Controls, Forms, Dialogs, Graphics,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDriverIntf, ibSHComponent;

type
  TibSHServer = class(TibBTComponent, IibSHServer, ISHServer, ISHRegistration, ISHTestConnection, ISHDataRootDirectory)
  private
    FDRVService: TSHComponent;

    FHost: string;
    FAlias: string;
    FVersion: string;
    FClientLibrary: string;
    FProtocol: string;
    FPort: string;
    FUserName: string;
    FPassword: string;
    FRole: string;
    FLoginPrompt: Boolean;
    FLongMetadataNames: Boolean;
    FSecurityDatabase: string;
    FDescription: string;
    FDirectoryIID: string;
    FSchemeClassIIDList: TStrings;
    FInstanceName:string;
  protected
    function GetBranchIID: TGUID; override;
    procedure SetOwnerIID(Value: TGUID); override;
    procedure DoOnApplyOptions; override;

    function DRVNormalize(const DriverIID: TGUID): TGUID;
    function PrepareDRVService: Boolean;
    function GetDRVService: IibSHDRVService;

    function GetHost: string;
    procedure SetHost(Value: string);
    function GetAlias: string;
    procedure SetAlias(Value: string);
    function GetVersion: string;
    procedure SetVersion(Value: string);
    function SetLongMetadataNames: Boolean;
    procedure GetLongMetadataNames(Value: Boolean);
    function GetClientLibrary: string;
    procedure SetClientLibrary(Value: string);
    function GetProtocol: string;
    procedure SetProtocol(Value: string);
    function GetPort: string;
    procedure SetPort(Value: string);
    function GetSecurityDatabase: string;
    procedure SetSecurityDatabase(Value: string);
    function GetUserName: string;
    procedure SetUserName(Value: string);
    function GetPassword: string;
    procedure SetPassword(Value: string);
    function GetRole: string;
    procedure SetRole(Value: string);
    function GetLoginPrompt: Boolean;
    procedure SetLoginPrompt(Value: Boolean);
    function GetDescription: string;
    procedure SetDescription(Value: string);
    function GetConnectPath: string;
    function GetDirectoryIID: string;
    procedure SetDirectoryIID(Value: string);

    function GetCaption: string; override;
    function GetCaptionExt: string; override;
    // ISHServer
    function GetConnected: Boolean;
    function GetCanConnect: Boolean;
    function GetCanReconnect: Boolean;
    function GetCanDisconnect: Boolean;
    function GetCanShowRegistrationInfo: Boolean;

    function Connect: Boolean;
    function Reconnect: Boolean;
    function Disconnect: Boolean;
    procedure Refresh;

    function ShowRegistrationInfo: Boolean;

    procedure IDELoadFromFileNotify;
    function GetSchemeClassIIDList(WithSystem: Boolean = False): TStrings; overload;
    function GetSchemeClassIIDList(const AObjectName: string): TStrings; overload;
    function GetObjectNameList: TStrings; overload;
    function GetObjectNameList(const AClassIID: TGUID): TStrings; overload;

    function  GetInstanceName:string;
    procedure SetInstanceName(const Value:string);

    // ISHTestconnection
    function GetCanTestConnection: Boolean;
    function TestConnection: Boolean;
    // ISHDataRootDirectory
    function GetDataRootDirectory: string;
    function CreateDirectory(const FileName: string): Boolean;
    function RenameDirectory(const OldName, NewName: string): Boolean;
    function DeleteDirectory(const FileName: string): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property DRVService: IibSHDRVService read GetDRVService;
    property Connected: Boolean read GetConnected;
    property CanConnect: Boolean read GetCanConnect;
    property CanReconnect: Boolean read GetCanReconnect;
    property CanDisconnect: Boolean read GetCanDisconnect;
    property CanShowRegistrationInfo: Boolean read GetCanShowRegistrationInfo;
    property SchemeClassIIDList: TStrings read FSchemeClassIIDList;
  published
    property Host: string read GetHost write SetHost;
    property Alias: string read GetAlias write SetAlias;
    property Version: string read GetVersion write SetVersion;
    property LongMetadataNames: Boolean read SetLongMetadataNames write GetLongMetadataNames;
    property ClientLibrary: string read GetClientLibrary write SetClientLibrary;
    property Protocol: string read GetProtocol write SetProtocol;
    property Port: string read GetPort write SetPort;
    property SecurityDatabase: string read GetSecurityDatabase write SetSecurityDatabase;
    property UserName: string read GetUserName write SetUserName;
    property Password: string read GetPassword write SetPassword;
    property Role: string read GetRole write SetRole;
    property LoginPrompt: Boolean read GetLoginPrompt write SetLoginPrompt;
    property Description: string read GetDescription write SetDescription;
    property ConnectPath: string read GetConnectPath;
    property InstanceName: string read GetInstanceName write SetInstanceName; 
    // invisible
    property DirectoryIID: string read GetDirectoryIID write SetDirectoryIID;
  end;

  TfibSHServerOptions = class(TSHComponentOptions, IibSHServerOptions, IibSHDummy)
  private
    FHost: string;
    FVersion: string;
    FClientLibrary: string;
    FProtocol: string;
    FPort: string;
    FSecurityDatabase: string;
    FUserName: string;
    FPassword: string;
    FRole: string;
    FLoginPrompt: Boolean;
    FSaveResultFilterIndex: Integer;
  protected
    function GetHost: string;
    procedure SetHost(Value: string);
    function GetVersion: string;
    procedure SetVersion(Value: string);
    function GetClientLibrary: string;
    procedure SetClientLibrary(Value: string);
    function GetProtocol: string;
    procedure SetProtocol(Value: string);
    function GetPort: string;
    procedure SetPort(Value: string);
    function GetSecurityDatabase: string;
    procedure SetSecurityDatabase(Value: string);
    function GetUserName: string;
    procedure SetUserName(Value: string);
    function GetPassword: string;
    procedure SetPassword(Value: string);
    function GetRole: string;
    procedure SetRole(Value: string);
    function GetLoginPrompt: Boolean;
    procedure SetLoginPrompt(Value: Boolean);
    function GetSaveResultFilterIndex: Integer;
    procedure SetSaveResultFilterIndex(Value: Integer);

    function GetParentCategory: string; override;
    function GetCategory: string; override;
    procedure RestoreDefaults; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Host: string read FHost write FHost;
    property Version: string read FVersion write FVersion;
    property ClientLibrary: string read FClientLibrary write FClientLibrary;
    property Protocol: string read FProtocol write FProtocol;
    property Port: string read FPort write FPort;
    property SecurityDatabase: string read FSecurityDatabase write FSecurityDatabase;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
    property Role: string read FRole write FRole;
    property LoginPrompt: Boolean read GetLoginPrompt write SetLoginPrompt;
    //Invisible
    property SaveResultFilterIndex: Integer read GetSaveResultFilterIndex write SetSaveResultFilterIndex;
  end;

  TibSHServerOptions = class(TfibSHServerOptions, IibSHServerOptions, IibSHBranch)
  end;

  TfbSHServerOptions = class(TfibSHServerOptions, IfbSHServerOptions, IfbSHBranch)
  end;

implementation

uses
  ibSHConsts, ibSHMessages;

{ TibSHServer }

constructor TibSHServer.Create(AOwner: TComponent);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner);
  FDirectoryIID := GUIDToString(InstanceIID);
  FSchemeClassIIDList := TStringList.Create;

  vComponentClass := Designer.GetComponent(IibSHDRVService_FIBPlus);
  if Assigned(vComponentClass) then FDRVService := vComponentClass.Create(nil);

  Version := Format('%s', [SFirebird15]);
  ClientLibrary := Format('%s', [Sgds32]);

  Protocol := Format('%s', [STCPIP]);
  Port := Format('%s', [SDefaultPort]);
  UserName := Format('%s', [SDefaultUserName]);
  Password := Format('%s', [SDefaultPassword]);

  MakePropertyInvisible('LongMetadataNames');
  MakePropertyInvisible('InstanceName');

  MakePropertyInvisible('DirectoryIID');
end;

destructor TibSHServer.Destroy;
begin
  FSchemeClassIIDList.Free;
  FDRVService.Free;
  inherited Destroy;
end;

function TibSHServer.GetBranchIID: TGUID;
begin
  Result := inherited GetBranchIID;
  if Assigned(Designer.FindComponent(OwnerIID)) then
    Result := Designer.FindComponent(OwnerIID).BranchIID;
end;

procedure TibSHServer.SetOwnerIID(Value: TGUID);
begin
  inherited SetOwnerIID(Value);
  DoOnApplyOptions;
end;

procedure TibSHServer.DoOnApplyOptions;
var
  Options: IibSHServerOptions;
begin
  if IsEqualGUID(BranchIID, IibSHBranch) then
    Supports(Designer.GetOptions(IibSHServerOptions), IibSHServerOptions, Options);
  if IsEqualGUID(BranchIID, IfbSHBranch) then
    Supports(Designer.GetOptions(IfbSHServerOptions), IibSHServerOptions, Options);
  if Assigned(Options) then
  begin
    Host := Options.Host;
    Version := Options.Version;
    ClientLibrary := Options.ClientLibrary;
    Protocol := Options.Protocol;
    Port := Options.Port;
    SecurityDatabase := Options.SecurityDatabase;
    UserName := Options.UserName;
    Password := Options.Password;
    Role := Options.Role;
    LoginPrompt := Options.LoginPrompt;
  end;
  Options := nil;
end;

function TibSHServer.GetDRVService: IibSHDRVService;
begin
  Supports(FDRVService, IibSHDRVService, Result);
end;

function TibSHServer.DRVNormalize(const DriverIID: TGUID): TGUID;
begin
  Result := DriverIID;
  if not LongMetadataNames then
  begin
    if IsEqualGUID(DriverIID, IibSHDRVDatabase) then Result := IibSHDRVDatabase_FIBPlus;
    if IsEqualGUID(DriverIID, IibSHDRVTransaction) then Result := IibSHDRVTransaction_FIBPlus;
    if IsEqualGUID(DriverIID, IibSHDRVQuery) then Result := IibSHDRVQuery_FIBPlus;
    if IsEqualGUID(DriverIID, IibSHDRVDataset) then Result := IibSHDRVDataset_FIBPlus;
    if IsEqualGUID(DriverIID, IibSHDRVMonitor) then Result := IibSHDRVMonitor_FIBPlus;
    if IsEqualGUID(DriverIID, IibSHDRVSQLParser) then Result := IibSHDRVSQLParser_FIBPlus;
    if IsEqualGUID(DriverIID, IibSHDRVPlayer) then Result := IibSHDRVPlayer_FIBPlus;
    if IsEqualGUID(DriverIID, IibSHDRVStatistics) then Result := IibSHDRVStatistics_FIBPlus;

//    if IsEqualGUID(DriverIID, IibSHDRVService) then Result := IibSHDRVService_FIBPLus;
  end else
  begin
    if IsEqualGUID(DriverIID, IibSHDRVDatabase) then Result := IibSHDRVDatabase_FIBPlus68;
    if IsEqualGUID(DriverIID, IibSHDRVTransaction) then Result := IibSHDRVTransaction_FIBPlus68;
    if IsEqualGUID(DriverIID, IibSHDRVQuery) then Result := IibSHDRVQuery_FIBPlus68;
    if IsEqualGUID(DriverIID, IibSHDRVDataset) then Result := IibSHDRVDataset_FIBPlus68;
    if IsEqualGUID(DriverIID, IibSHDRVMonitor) then Result := IibSHDRVMonitor_FIBPlus68;
    if IsEqualGUID(DriverIID, IibSHDRVSQLParser) then Result := IibSHDRVSQLParser_FIBPlus68;
    if IsEqualGUID(DriverIID, IibSHDRVPlayer) then Result := IibSHDRVPlayer_FIBPlus68;
    if IsEqualGUID(DriverIID, IibSHDRVStatistics) then Result := IibSHDRVStatistics_FIBPlus68;
  end;
end;

function TibSHServer.PrepareDRVService: Boolean;
begin
  Result := Assigned(DRVService);
  if Result then
  begin
    DRVService.ConnectProtocol := Protocol;
    DRVService.ConnectPort := Port;
    DRVService.ConnectLibraryName := ClientLibrary;
    DRVService.ConnectLoginPrompt := LoginPrompt;
    DRVService.ConnectUser := UserName;
    DRVService.ConnectPassword := Password;
    DRVService.ConnectRole := Role;
    DRVService.ConnectServer := Host;
    DRVService.ConnectDatabase := EmptyStr;
  end;
end;

function TibSHServer.GetHost: string;
begin
  Result := FHost;
end;

procedure TibSHServer.SetHost(Value: string);
begin
  FHost := Value;
  if Length(Alias) = 0 then Alias := FHost;
end;

function TibSHServer.GetAlias: string;
begin
  Result := FAlias;
end;

procedure TibSHServer.SetAlias(Value: string);
begin
  FAlias := Value;
end;

function TibSHServer.GetVersion: string;
begin
  Result := FVersion;
end;

procedure TibSHServer.SetVersion(Value: string);
var
  EditorRegistrator: IibSHEditorRegistrator;
begin
  if (not Connected) and (FVersion <> Value) then
  begin
    FVersion := Value;
    //
    // ќтрабатываем сокрытие пропертей по версии сервера
    //
    if AnsiSameText(FVersion, SInterBase2007) then
      MakePropertyVisible('InstanceName')
    else
    begin
      MakePropertyInvisible('InstanceName');
      InstanceName := '';
    end;
    if AnsiSameText(FVersion, SInterBase70) or
       AnsiSameText(FVersion, SInterBase71) or
       AnsiSameText(FVersion, SInterBase75) or
       AnsiSameText(FVersion, SInterBase2007)
    then
    begin
      MakePropertyInvisible('Port');    
//      MakePropertyVisible('LongMetadataNames');
      MakePropertyInvisible('LongMetadataNames');
      LongMetadataNames:=True;
    end
    else
    begin
      MakePropertyInvisible('LongMetadataNames');
      LongMetadataNames := False;
    end;
    //
    // Ќотифицируем механизм регистрации текстовых редакторов о смене версии сервера
    //
    if Supports(Designer.GetDemon(IibSHEditorRegistrator), IibSHEditorRegistrator, EditorRegistrator) then
      EditorRegistrator.AfterChangeServerVersion(Self);
  end;
end;

function TibSHServer.SetLongMetadataNames: Boolean;
begin
  Result := FLongMetadataNames;
end;

procedure TibSHServer.GetLongMetadataNames(Value: Boolean);
begin
  FLongMetadataNames := Value;
end;

function TibSHServer.GetClientLibrary: string;
begin
  Result := FClientLibrary;
end;

procedure TibSHServer.SetClientLibrary(Value: string);
begin
  FClientLibrary := Value;
end;

function TibSHServer.GetProtocol: string;
begin
  Result := FProtocol;
end;

procedure TibSHServer.SetProtocol(Value: string);
begin
  FProtocol := Value;
end;

function TibSHServer.GetPort: string;
begin
  Result := FPort;
end;

procedure TibSHServer.SetPort(Value: string);
begin
  FPort := Value;
end;

function TibSHServer.GetSecurityDatabase: string;
begin
  Result := FSecurityDatabase;
end;

procedure TibSHServer.SetSecurityDatabase(Value: string);
begin
  FSecurityDatabase := Value;
end;

function TibSHServer.GetUserName: string;
begin
  Result := FUserName;
end;

procedure TibSHServer.SetUserName(Value: string);
begin
  FUserName := Value;
end;

function TibSHServer.GetPassword: string;
begin
  Result := FPassword;
end;

procedure TibSHServer.SetPassword(Value: string);
begin
  FPassword := Value;
end;

function TibSHServer.GetRole: string;
begin
  Result := FRole;
end;

procedure TibSHServer.SetRole(Value: string);
begin
  FRole := Value;
end;

function TibSHServer.GetLoginPrompt: Boolean;
begin
  Result := FLoginPrompt;
end;

procedure TibSHServer.SetLoginPrompt(Value: Boolean);
begin
  FLoginPrompt := Value;
end;

function TibSHServer.GetDescription: string;
begin
  Result := FDescription;
end;

procedure TibSHServer.SetDescription(Value: string);
begin
  FDescription := Value;
end;

function TibSHServer.GetConnectPath: string;
begin
  Result := Host;

  if AnsiSameText(Protocol, STCPIP) then
  begin
    if AnsiSameText(Port, '3050') then
      Result := Format('%s:', [Host])
    else
      Result := Format('%s/%s:', [Host, Port]);
  end;

  if AnsiSameText(Protocol, SNamedPipe) then
    Result := Format('\\%s\',[Host]);

  if AnsiSameText(Protocol, SSPX) then
    Result := Format('%s@',[host]);

  if AnsiSameText(Protocol, SLocal) then
    Result := Format('%s',[EmptyStr]);
end;

function TibSHServer.GetDirectoryIID: string;
begin
  Result := FDirectoryIID;
end;

procedure TibSHServer.SetDirectoryIID(Value: string);
begin
  FDirectoryIID := Value;
end;

function TibSHServer.GetCaption: string;
begin
  Result := Format('%s', [Alias]);
end;

function TibSHServer.GetCaptionExt: string;
begin
  Result := Format('%s, %s, %s', [ConnectPath, Version, ClientLibrary]);
end;

function TibSHServer.GetConnected: Boolean;
//var
//  I: Integer;
//  ibBTDatabaseIntf: IibSHDatabase;
begin
  Result := False;
(*
  if Assigned(Designer) then
    for I := 0 to Pred(Designer.Components.Count) do
      if (Supports(Designer.Components[I], IibSHDatabase, ibBTDatabaseIntf) and
         IsEqualGUID(ibBTDatabaseIntf.BranchIID, Self.BranchIID) and
         IsEqualGUID(ibBTDatabaseIntf.OwnerIID, Self.InstanceIID) and
         ibBTDatabaseIntf.Connected) or

         (not Supports(Designer.Components[I], IibSHDatabase) and IsEqualGUID(TSHComponent(Designer.Components[I]).OwnerIID, InstanceIID)) then
      begin
        Result := True;
        Break;
      end;
*)      
end;

function TibSHServer.GetCanConnect: Boolean;
begin
  Result := False;
end;

function TibSHServer.GetCanReconnect: Boolean;
begin
  Result := False;
end;

function TibSHServer.GetCanDisconnect: Boolean;
begin
  Result := False;
end;

function TibSHServer.GetCanShowRegistrationInfo: Boolean;
begin
  Result := True;
end;

function TibSHServer.ShowRegistrationInfo: Boolean;
var
  OldDataRootDirectory: string;
begin
  Result := False;
  OldDataRootDirectory := GetDataRootDirectory;
  Self.Tag := 4;
  try
    if IsPositiveResult(Designer.ShowModal(Self, SCallRegister)) then
    begin
      if not AnsiSameText(OldDataRootDirectory, GetDataRootDirectory) then
        RenameDirectory(OldDataRootDirectory, GetDataRootDirectory);
      Designer.SaveRegisteredConnectionInfo;
      Result := True;
    end;
  finally
    Self.Tag := 0;
  end;
end;

procedure TibSHServer.IDELoadFromFileNotify;
begin
  CreateDirectory(GetDataRootDirectory);
end;

function TibSHServer.GetSchemeClassIIDList(WithSystem: Boolean = False): TStrings;
begin
  Result := SchemeClassIIDList;
end;

function TibSHServer.GetSchemeClassIIDList(const AObjectName: string): TStrings;
begin
  Result := SchemeClassIIDList;
end;

function TibSHServer.GetObjectNameList: TStrings;
begin
  Result := nil;
end;

function TibSHServer.GetObjectNameList(const AClassIID: TGUID): TStrings;
begin
  Result := nil;
end;

function TibSHServer.Connect: Boolean;
begin
  Result := CanConnect;
end;

function TibSHServer.Reconnect: Boolean;
begin
  Result := CanReconnect;
end;

function TibSHServer.Disconnect: Boolean;
begin
  Result := not Connected;
end;

procedure TibSHServer.Refresh;
begin
//Empty
end;

function TibSHServer.GetCanTestConnection: Boolean;
begin
  Result := not Connected;
end;

function TibSHServer.TestConnection: Boolean;
var
  Msg: string;
  MsgType: TMsgDlgType;
begin
  Result := GetCanTestConnection;

  if Result then
  begin
    try
      Screen.Cursor := crHourGlass;
      try
        Result := PrepareDRVService and DRVService.Attach(stBackupService);
      except
        Result := False;
      end;
    finally
      if Assigned(DRVService) then DRVService.Detach;
      Screen.Cursor := crDefault;
    end;

    if Result then
    begin
      Msg := Format(SServerTestConnectionOK, [Self.CaptionExt]);
      MsgType := mtInformation;
    end else
    begin
      if Assigned(DRVService) then
        Msg := Format(SServerTestConnectionNO, [Self.CaptionExt, DRVService.ErrorText])
      else
        Msg := Format(SServerTestConnectionNO, [Self.CaptionExt, SDriverIsNotInstalled]);
      MsgType := mtWarning;
    end;

    Designer.ShowMsg(Msg, MsgType);
  end;
end;

function TibSHServer.GetDataRootDirectory: string;
var
  vDataRootDirectory: ISHDataRootDirectory;
begin
  if Supports(Designer.GetDemon(BranchIID), ISHDataRootDirectory, vDataRootDirectory) then
    Result := IncludeTrailingPathDelimiter(Format('%sServers\%s.%s', [vDataRootDirectory.DataRootDirectory, Alias, DirectoryIID]));
end;

function TibSHServer.CreateDirectory(const FileName: string): Boolean;
begin
  Result := not SysUtils.DirectoryExists(FileName) and ForceDirectories(FileName);
end;

function TibSHServer.RenameDirectory(const OldName, NewName: string): Boolean;
begin
  Result := SysUtils.DirectoryExists(OldName) and RenameFile(OldName, NewName);
end;

function TibSHServer.DeleteDirectory(const FileName: string): Boolean;
begin
  Alias := Format('#.Unregistered.%s', [Alias]);
  Result := RenameDirectory(FileName, GetDataRootDirectory);
end;

function TibSHServer.GetInstanceName: string;
begin
 Result:= FInstanceName;
end;

procedure TibSHServer.SetInstanceName(const Value: string);
begin
 FInstanceName:=Value
end;

{ TfibSHServerOptions }

function TfibSHServerOptions.GetParentCategory: string;
begin
  if Supports(Self, IibSHBranch) then Result := Format('%s', [SibOptionsCategory]);
  if Supports(Self, IfbSHBranch) then Result := Format('%s', [SfbOptionsCategory]);
end;

function TfibSHServerOptions.GetCategory: string;
begin
  Result := Format('%s', [SServerOptionsCategory]);
end;

procedure TfibSHServerOptions.RestoreDefaults;
begin
  Host := EmptyStr;
  if Supports(Self, IibSHBranch) then Version := SInterBase75;
  if Supports(Self, IfbSHBranch) then Version := SFirebird20;
  if Supports(Self, IibSHBranch) then ClientLibrary := Sgds32;
  if Supports(Self, IfbSHBranch) then ClientLibrary := Sfbclient;
  Protocol := Protocols[0];
  Port := SDefaultPort;
  SecurityDatabase := EmptyStr;
  UserName := SDefaultUserName;
  Password := SDefaultPassword;
  Role := EmptyStr;
  LoginPrompt := False;
end;

constructor TfibSHServerOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSaveResultFilterIndex := 0;
  MakePropertyInvisible('SaveResultFilterIndex');
end;

function TfibSHServerOptions.GetHost: string;
begin
  Result := Host;
end;

procedure TfibSHServerOptions.SetHost(Value: string);
begin
  Host := Value;
end;

function TfibSHServerOptions.GetVersion: string;
begin
  Result := Version;
end;

procedure TfibSHServerOptions.SetVersion(Value: string);
begin
  Version := Value;
end;

function TfibSHServerOptions.GetClientLibrary: string;
begin
  Result := ClientLibrary;
end;

procedure TfibSHServerOptions.SetClientLibrary(Value: string);
begin
  ClientLibrary := Value;
end;

function TfibSHServerOptions.GetProtocol: string;
begin
  Result := Protocol;
end;

procedure TfibSHServerOptions.SetProtocol(Value: string);
begin
  Protocol := Value;
end;

function TfibSHServerOptions.GetPort: string;
begin
  Result := Port;
end;

procedure TfibSHServerOptions.SetPort(Value: string);
begin
  Port := Value;
end;

function TfibSHServerOptions.GetSecurityDatabase: string;
begin
  Result := SecurityDatabase;
end;

procedure TfibSHServerOptions.SetSecurityDatabase(Value: string);
begin
  SecurityDatabase := Value;
end;

function TfibSHServerOptions.GetUserName: string;
begin
  Result := UserName;
end;

procedure TfibSHServerOptions.SetUserName(Value: string);
begin
  UserName := Value;
end;

function TfibSHServerOptions.GetPassword: string;
begin
  Result := Password;
end;

procedure TfibSHServerOptions.SetPassword(Value: string);
begin
  Password := Value;
end;

function TfibSHServerOptions.GetRole: string;
begin
  Result := Role;
end;

procedure TfibSHServerOptions.SetRole(Value: string);
begin
  Role := Value;
end;

function TfibSHServerOptions.GetLoginPrompt: Boolean;
begin
  Result := FLoginPrompt;
end;

procedure TfibSHServerOptions.SetLoginPrompt(Value: Boolean);
begin
  FLoginPrompt := Value;
end;

function TfibSHServerOptions.GetSaveResultFilterIndex: Integer;
begin
  Result := FSaveResultFilterIndex;
end;

procedure TfibSHServerOptions.SetSaveResultFilterIndex(Value: Integer);
begin
  FSaveResultFilterIndex := Value;
end;


end.


