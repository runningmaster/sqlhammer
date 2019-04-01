unit ibSHServicesAPI;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDriverIntf, ibSHTool;

type
  TibSHService = class(TibBTTool, IibSHService, IibSHBranch, IfbSHBranch)
  private
    FDatabaseName: string;
    FErrorText: string;
    FServer: string;
    FUserName: string;
    FPassword: string;
    function GetServer: string;
    procedure SetServer(Value: string);
    function GetUserName: string;
    procedure SetUserName(Value: string);
    function GetPassword: string;
    procedure SetPassword(Value: string);
    procedure WriteString(S: string);
  protected
    FOnTextNotify: TSHOnTextNotify;
    procedure SetOwnerIID(Value: TGUID); override;
    function GetDRVService: IibSHDRVService;
    function GetDatabaseName: string;
    procedure SetDatabaseName(Value: string);
    function GetErrorText: string;
    procedure SetErrorText(Value: string);
    function GetOnTextNotify: TSHOnTextNotify;
    procedure SetOnTextNotify(Value: TSHOnTextNotify);

    function Execute: Boolean; virtual;
    function InternalExecute: Boolean; virtual;
  public
    property DRVService: IibSHDRVService read GetDRVService;
    property DatabaseName: string read GetDatabaseName write SetDatabaseName;
    property ErrorText: string read GetErrorText write SetErrorText;
    property OnTextNotify: TSHOnTextNotify read GetOnTextNotify write SetOnTextNotify;
  published
    property Server: string read GetServer write SetServer;
    property UserName: string read GetUserName write SetUserName;
    property Password: string read  GetPassword write SetPassword;
  end;

  TibSHServerProps = class(TibSHService, IibSHServerProps, IibSHBranch, IfbSHBranch)
  private
    FLocationInfo: Boolean;
    FVersionInfo: Boolean;
    FDatabaseInfo: Boolean;
    FLicenseInfo: Boolean;
    FConfigInfo: Boolean;

    function GetLocationInfo: Boolean;
    procedure SetLocationInfo(Value: Boolean);
    function GetVersionInfo: Boolean;
    procedure SetVersionInfo(Value: Boolean);
    function GetDatabaseInfo: Boolean;
    procedure SetDatabaseInfo(Value: Boolean);
    function GetLicenseInfo: Boolean;
    procedure SetLicenseInfo(Value: Boolean);
    function GetConfigInfo: Boolean;
    procedure SetConfigInfo(Value: Boolean);
  protected
    function InternalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property LocationInfo: Boolean read GetLocationInfo write SetLocationInfo;
    property VersionInfo: Boolean read GetVersionInfo write SetVersionInfo;
    property DatabaseInfo: Boolean read GetDatabaseInfo write SetDatabaseInfo;
    property LicenseInfo: Boolean read GetLicenseInfo write SetLicenseInfo;
    property ConfigInfo: Boolean read GetConfigInfo write SetConfigInfo;
  end;

  TibSHServerLog = class(TibSHService, IibSHServerLog, IibSHBranch, IfbSHBranch)
  protected
    function InternalExecute: Boolean; override;
  end;

  TibSHServerConfig = class(TibSHService, IibSHServerConfig, IibSHBranch, IfbSHBranch)
  end;

  TibSHServerLicense = class(TibSHService, IibSHServerLicense, IibSHBranch, IfbSHBranch)
  end;

  TibSHDatabaseShutdown = class(TibSHService, IibSHDatabaseShutdown, IibSHBranch, IfbSHBranch)
  private
    FMode: string;
    FTimeout: Integer;
    function GetMode: string;
    procedure SetMode(Value: string);
    function GetTimeout: Integer;
    procedure SetTimeout(Value: Integer);
    function CloseAllDatabases: Boolean;
  protected
    function InternalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Mode: string read GetMode write SetMode;
    property Timeout: Integer read GetTimeout write SetTimeout;
  end;


  TibSHDatabaseOnline = class(TibSHService, IibSHDatabaseOnline, IibSHBranch, IfbSHBranch)
  protected
    function InternalExecute: Boolean; override;
  end;

  TibSHBackupRestoreService = class(TibSHService, IibSHBackupRestoreService)
  private
    FSourceFileList: TStrings;
    FDestinationFileList: TStrings;
    FVerbose: Boolean;
    function GetSourceFileList: TStrings;
    function GetDestinationFileList: TStrings;
    function GetVerbose: Boolean;
    procedure SetVerbose(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property SourceFileList: TStrings read GetSourceFileList;
    property DestinationFileList: TStrings read GetDestinationFileList;
    property Verbose: Boolean read GetVerbose write SetVerbose;
  end;

  TibSHDatabaseBackup = class(TibSHBackupRestoreService, IibSHDatabaseBackup, IibSHBranch, IfbSHBranch)
  private
    FTransportable: Boolean;
    FMetadataOnly: Boolean;
    FNoGarbageCollect: Boolean;
    FIgnoreLimboTrans: Boolean;
    FIgnoreChecksums: Boolean;
    FOldMetadataDesc: Boolean;
    FConvertExtTables: Boolean;

    function GetTransportable: Boolean;
    procedure SetTransportable(Value: Boolean);
    function GetMetadataOnly: Boolean;
    procedure SetMetadataOnly(Value: Boolean);
    function GetNoGarbageCollect: Boolean;
    procedure SetNoGarbageCollect(Value: Boolean);
    function GetIgnoreLimboTrans: Boolean;
    procedure SetIgnoreLimboTrans(Value: Boolean);
    function GetIgnoreChecksums: Boolean;
    procedure SetIgnoreChecksums(Value: Boolean);
    function GetOldMetadataDesc: Boolean;
    procedure SetOldMetadataDesc(Value: Boolean);
    function GetConvertExtTables: Boolean;
    procedure SetConvertExtTables(Value: Boolean);
  protected
    function InternalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Transportable: Boolean read GetTransportable write SetTransportable;
    property MetadataOnly: Boolean read GetMetadataOnly write SetMetadataOnly;
    property NoGarbageCollect: Boolean read GetNoGarbageCollect write SetNoGarbageCollect;
    property IgnoreLimboTrans: Boolean read GetIgnoreLimboTrans write SetIgnoreLimboTrans;
    property IgnoreChecksums: Boolean read GetIgnoreChecksums write SetIgnoreChecksums;
    property OldMetadataDesc: Boolean read GetOldMetadataDesc write SetOldMetadataDesc;
    property ConvertExtTables: Boolean read GetConvertExtTables write SetConvertExtTables;
    property Verbose;
  end;

  TibSHDatabaseRestore = class(TibSHBackupRestoreService, IibSHDatabaseRestore, IibSHBranch, IfbSHBranch)
  private
    FPageSize: string;
    FReplaceExisting: Boolean;
    FMetadataOnly: Boolean;
    FCommitEachTable: Boolean;
    FWithoutShadow: Boolean;
    FDeactivateIndexes: Boolean;
    FNoValidityCheck: Boolean;
    FUseAllSpace: Boolean;

    function GetPageSize: string;
    procedure SetPageSize(Value: string);
    function GetReplaceExisting: Boolean;
    procedure SetReplaceExisting(Value: Boolean);
    function GetMetadataOnly: Boolean;
    procedure SetMetadataOnly(Value: Boolean);
    function GetCommitEachTable: Boolean;
    procedure SetCommitEachTable(Value: Boolean);
    function GetWithoutShadow: Boolean;
    procedure SetWithoutShadow(Value: Boolean);
    function GetDeactivateIndexes: Boolean;
    procedure SetDeactivateIndexes(Value: Boolean);
    function GetNoValidityCheck: Boolean;
    procedure SetNoValidityCheck(Value: Boolean);
    function GetUseAllSpace: Boolean;
    procedure SetUseAllSpace(Value: Boolean);
  protected
    function InternalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property PageSize: string read GetPageSize write SetPageSize;
    property ReplaceExisting: Boolean read GetReplaceExisting write SetReplaceExisting;
    property MetadataOnly: Boolean read GetMetadataOnly write SetMetadataOnly;
    property CommitEachTable: Boolean read GetCommitEachTable write SetCommitEachTable;
    property WithoutShadow: Boolean read GetWithoutShadow write SetWithoutShadow;
    property DeactivateIndexes: Boolean read GetDeactivateIndexes write SetDeactivateIndexes;
    property NoValidityCheck: Boolean read GetNoValidityCheck write SetNoValidityCheck;
    property UseAllSpace: Boolean read GetUseAllSpace write SetUseAllSpace;
    property Verbose;
  end;

  TibSHDatabaseStatistics = class(TibSHService, IibSHDatabaseStatistics, IibSHBranch, IfbSHBranch)
  private
    FStopAfter: string;
    FTableName: string;
    function GetStopAfter: string;
    procedure SetStopAfter(Value: string);
    function GetTableName: string;
    procedure SetTableName(Value: string);
  protected
    function InternalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property StopAfter: string read GetStopAfter write SetStopAfter;
    property TableName: string read GetTableName write SetTableName;
  end;

  TibSHDatabaseValidation = class(TibSHService, IibSHDatabaseValidation, IibSHBranch, IfbSHBranch)
  private
    FRecordFragments: Boolean;
    FIgnoreChecksum: Boolean;
    FReadOnly: Boolean;
    FKillShadows: Boolean;
    function GetRecordFragments: Boolean;
    procedure SetRecordFragments(Value: Boolean);
    function GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    function GetIgnoreChecksum: Boolean;
    procedure SetIgnoreChecksum(Value: Boolean);
    function GetKillShadows: Boolean;
    procedure SetKillShadows(Value: Boolean);
  protected
    function InternalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property RecordFragments: Boolean read GetRecordFragments write SetRecordFragments;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property IgnoreChecksum: Boolean read GetIgnoreChecksum write SetIgnoreChecksum;
    property KillShadows: Boolean read GetKillShadows write SetKillShadows;
  end;

  TibSHDatabaseSweep = class(TibSHService, IibSHDatabaseSweep, IibSHBranch, IfbSHBranch)
  private
    FIgnoreChecksum: Boolean;
    function GetIgnoreChecksum: Boolean;
    procedure SetIgnoreChecksum(Value: Boolean);
  protected
    function InternalExecute: Boolean; override;
  published
    property IgnoreChecksum: Boolean read GetIgnoreChecksum write SetIgnoreChecksum;
  end;

  TibSHDatabaseMend = class(TibSHService, IibSHDatabaseMend, IibSHBranch, IfbSHBranch)
  private
    FIgnoreChecksum: Boolean;
    function GetIgnoreChecksum: Boolean;
    procedure SetIgnoreChecksum(Value: Boolean);
  protected
    function InternalExecute: Boolean; override;
  published
    property IgnoreChecksum: Boolean read GetIgnoreChecksum write SetIgnoreChecksum;
  end;

  TibSHTransactionRecovery = class(TibSHService, IibSHTransactionRecovery, IibSHBranch, IfbSHBranch)
  private
    FGlobalAction: string;
    FFixLimbo: string;
    function GetGlobalAction: string;
    procedure SetGlobalAction(Value: string);
  protected
    function InternalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property GlobalAction: string read GetGlobalAction write SetGlobalAction;
    property FixLimbo: string read FFixLimbo;
  end;

  TibSHDatabaseProps = class(TibSHService, IibSHDatabaseProps, IibSHBranch, IfbSHBranch)
  private
    FIntDatabase: TComponent;
    FIntDatabaseIntf: IibSHDatabase;

    FODSVersion: string;
    FCharset: string;
    FPageSize: string;
    FActiveUsers: TStrings;
    FSweepInterval: Integer;
    FForcedWrites: Boolean;
    FReadOnly: Boolean;
    FSQLDialect: string;
    FPageBuffers: Integer;

    function GetODSVersion: string;
//    procedure SetODSVersion(Value: string);
    function GetCharset: string;
//    procedure SetCharset(Value: string);
    function GetPageSize: string;
//    procedure SetPageSize(Value: string);
    function GetActiveUsers: TStrings;
    function GetSweepInterval: Integer;
    procedure SetSweepInterval(Value: Integer);
    function GetForcedWrites: Boolean;
    procedure SetForcedWrites(Value: Boolean);
    function GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    function GetSQLDialect: string;
    procedure SetSQLDialect(Value: string);
    function GetPageBuffers: Integer;
    procedure SetPageBuffers(Value: Integer);
  protected
    function InternalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property ActiveUsers: TStrings read GetActiveUsers;
  published
    property ODSVersion: string read GetODSVersion;// write SetODSVersion;
    property Charset: string read GetCharset;// write SetCharset;
    property PageSize: string read GetPageSize;// write SetPageSize;
    property PageBuffers: Integer read GetPageBuffers write SetPageBuffers;
    property SQLDialect: string read GetSQLDialect write SetSQLDialect;
    property SweepInterval: Integer read GetSweepInterval write SetSweepInterval;
    property ForcedWrites: Boolean read GetForcedWrites write SetForcedWrites;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  end;

  TibSHServicesFactory = class(TibBTToolFactory)
  end;

procedure Register;

implementation

uses
  ibSHConsts, ibSHValues,
  ibSHServicesAPIActions,
  ibSHServicesAPIEditors;

procedure Register;
begin
  SHRegisterImage(GUIDToString(IibSHServerProps),         'ServerProps.bmp');
  SHRegisterImage(GUIDToString(IibSHServerLog),           'Log.bmp');
  SHRegisterImage(GUIDToString(IibSHServerConfig),        'Server.bmp');
  SHRegisterImage(GUIDToString(IibSHServerLicense),       'Server.bmp');
  SHRegisterImage(GUIDToString(IibSHDatabaseShutdown),    'Shutdown.bmp');
  SHRegisterImage(GUIDToString(IibSHDatabaseOnline),      'Online.bmp');
  SHRegisterImage(GUIDToString(IibSHDatabaseBackup),      'Backup.bmp');
  SHRegisterImage(GUIDToString(IibSHDatabaseRestore),     'Restore.bmp');
  SHRegisterImage(GUIDToString(IibSHDatabaseStatistics),  'Statistics.bmp');
  SHRegisterImage(GUIDToString(IibSHDatabaseProps),       'DatabaseProps.bmp');
  SHRegisterImage(GUIDToString(IibSHDatabaseValidation),  'Validation.bmp');
  SHRegisterImage(GUIDToString(IibSHDatabaseSweep),       'Sweep.bmp');
  SHRegisterImage(GUIDToString(IibSHDatabaseMend),        'Mend.bmp');
  SHRegisterImage(GUIDToString(IibSHTransactionRecovery), 'TrRecovery.bmp');


  SHRegisterImage(TibSHServerLogPaletteAction.ClassName,          'Log.bmp');
  SHRegisterImage(TibSHServerPropsPaletteAction.ClassName,        'ServerProps.bmp');
  SHRegisterImage(TibSHDatabasePropsPaletteAction.ClassName,      'DatabaseProps.bmp');
  SHRegisterImage(TibSHDatabaseStatisticsPaletteAction.ClassName, 'Statistics.bmp');
  SHRegisterImage(TibSHDatabaseShutdownPaletteAction.ClassName,   'Shutdown.bmp');
  SHRegisterImage(TibSHDatabaseOnlinePaletteAction.ClassName,     'Online.bmp');
  SHRegisterImage(TibSHDatabaseBackupPaletteAction.ClassName,     'Backup.bmp');
  SHRegisterImage(TibSHDatabaseRestorePaletteAction.ClassName,    'Restore.bmp');
  SHRegisterImage(TibSHDatabaseValidationPaletteAction.ClassName, 'Validation.bmp');
  SHRegisterImage(TibSHDatabaseSweepPaletteAction.ClassName,      'Sweep.bmp');
  SHRegisterImage(TibSHDatabaseMendPaletteAction.ClassName,       'Mend.bmp');

  SHRegisterImage(TibSHServiceFormAction.ClassName,               'Form_Output.bmp');
  SHRegisterImage(TibSHServiceToolbarAction_Run.ClassName,        'Button_Run.bmp');
  SHRegisterImage(TibSHServiceToolbarAction_Open.ClassName,       'Button_Open.bmp');
  SHRegisterImage(TibSHServiceToolbarAction_Save.ClassName,       'Button_Save.bmp');


  SHRegisterImage(SCallServiceOutputs,  'Form_Output.bmp');



  SHRegisterComponents([
    TibSHServerLog,
    TibSHServerProps,
    TibSHDatabaseProps,
    TibSHDatabaseStatistics,
    TibSHDatabaseShutdown,
    TibSHDatabaseOnline,
    TibSHDatabaseBackup,
    TibSHDatabaseRestore,
    TibSHDatabaseValidation,
    TibSHDatabaseSweep,
    TibSHDatabaseMend,
//    TibSHTransactionRecovery,
    TibSHServicesFactory]);

  SHRegisterActions([
    TibSHServerLogPaletteAction,
    TibSHServerPropsPaletteAction,
    TibSHDatabasePropsPaletteAction,
    TibSHDatabaseStatisticsPaletteAction,
    TibSHDatabaseShutdownPaletteAction,
    TibSHDatabaseOnlinePaletteAction,
    TibSHDatabaseBackupPaletteAction,
    TibSHDatabaseRestorePaletteAction,
    TibSHDatabaseValidationPaletteAction,
    TibSHDatabaseSweepPaletteAction,
    TibSHDatabaseMendPaletteAction,
    {TibSHTransactionRecoveryPaletteAction}
    TibSHServiceFormAction,
    TibSHServiceToolbarAction_Run,
    TibSHServiceToolbarAction_Open,
    TibSHServiceToolbarAction_Save]);

  SHRegisterPropertyEditor(IibSHService, SCallStopAfter, TibSHServicesStopAfterPropEditor);
  SHRegisterPropertyEditor(IibSHService, SCallMode, TibSHServicesShutdownModePropEditor);
  SHRegisterPropertyEditor(IibSHService, SCallPageSize, TibSHServicesPageSizePropEditor);
  SHRegisterPropertyEditor(IibSHService, SCallCharset, TibSHServicesCharsetPropEditor);
  SHRegisterPropertyEditor(IibSHService, SCallSQLDialect, TibSHServicesSQLDialectPropEditor);
  SHRegisterPropertyEditor(IibSHService, SCallGlobalAction, TibSHServicesGlobalActionPropEditor);
  SHRegisterPropertyEditor(IibSHService, SCallFixLimbo, TibSHServicesFixLimboPropEditor);
end;

{ TibSHService }

function TibSHService.GetServer: string;
begin
  if Assigned(BTCLServer) then
    Result := Format('%s (%s)  ', [BTCLServer.Caption, BTCLServer.CaptionExt]);
end;

procedure TibSHService.SetServer(Value: string);
begin
  FServer := Value;
end;

function TibSHService.GetUserName: string;
begin
  Result := FUserName;
end;

procedure TibSHService.SetUserName(Value: string);
begin
  FUserName := Value;
end;

function TibSHService.GetPassword: string;
begin
  Result := FPassword;
end;

procedure TibSHService.SetPassword(Value: string);
begin
  FPassword := Value;
end;

function TibSHService.GetOnTextNotify: TSHOnTextNotify;
begin
  Result := FOnTextNotify;
end;

procedure TibSHService.SetOnTextNotify(Value: TSHOnTextNotify);
begin
  FOnTextNotify := Value;
end;

procedure TibSHService.SetOwnerIID(Value: TGUID);
begin
  inherited SetOwnerIID(Value);
  if Assigned(BTCLServer) then
  begin
    UserName := BTCLServer.UserName;
    Password := BTCLServer.Password;
  end;
end;

function TibSHService.GetDRVService: IibSHDRVService;
begin
  if Assigned(BTCLServer) then
    Result := BTCLServer.DRVService;
end;

function TibSHService.GetDatabaseName: string;
begin
  Result := FDatabaseName;
end;

procedure TibSHService.SetDatabaseName(Value: string);
begin
  FDatabaseName := Value;
end;

function TibSHService.GetErrorText: string;
begin
  Result := FErrorText;
end;

procedure TibSHService.SetErrorText(Value: string);
begin
  FErrorText := Value;
  if Length(FErrorText) > 0 then
  begin
    WriteString(' ');
    WriteString(Format('BT: ERROR', []));
  end;
end;

procedure TibSHService.WriteString(S: string);
begin
  if Assigned(FOnTextNotify) then FOnTextNotify(Self, S);
end;

function TibSHService.Execute: Boolean;
var
  StartTime: TDateTime;
begin
  ErrorText := EmptyStr;
  Result := Assigned(BTCLServer);
  if Result then
  begin
    StartTime := Now;
    WriteString(Format('BT: Attach to server "%s"', [BTCLServer.Host]));
    WriteString(Format('BT: Service started at %s', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', StartTime)]));
    try
      Tag := 0; // for Validation check and Transaction Recovery
      Result := InternalExecute;
    finally
      Tag := 0; // for Validation check and Transaction Recovery
    end;
    WriteString(' ');
    WriteString(Format('BT: Service ended at %s', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', Now)]));
    WriteString(Format('BT: Detach from server "%s"', [BTCLServer.Host]));
    WriteString(Format('BT: Elapsed time %s', [FormatDateTime('hh:nn:ss.zzz', Now - StartTime)]));
    WriteString(' ');
  end;
end;

function TibSHService.InternalExecute: Boolean;
begin
  Result := Assigned(DRVService) and BTCLServer.PrepareDRVService;
  if Result then
  begin
    DRVService.ConnectUser := UserName;
    DRVService.ConnectPassword := Password;  
  end;
end;

{ TibSHServerProps }

constructor TibSHServerProps.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLocationInfo := True;
  FVersionInfo := True;
  FDatabaseInfo := True;
end;

destructor TibSHServerProps.Destroy;
begin
  inherited Destroy;
end;

function TibSHServerProps.GetLocationInfo: Boolean;
begin
  Result := FLocationInfo;
end;

procedure TibSHServerProps.SetLocationInfo(Value: Boolean);
begin
  FLocationInfo := Value;
end;

function TibSHServerProps.GetVersionInfo: Boolean;
begin
  Result := FVersionInfo;
end;

procedure TibSHServerProps.SetVersionInfo(Value: Boolean);
begin
  FVersionInfo := Value;
end;

function TibSHServerProps.GetDatabaseInfo: Boolean;
begin
  Result := FDatabaseInfo;
end;

procedure TibSHServerProps.SetDatabaseInfo(Value: Boolean);
begin
  FDatabaseInfo := Value;
end;

function TibSHServerProps.GetLicenseInfo: Boolean;
begin
  Result := FLicenseInfo;
end;

procedure TibSHServerProps.SetLicenseInfo(Value: Boolean);
begin
  FLicenseInfo := Value;
end;

function TibSHServerProps.GetConfigInfo: Boolean;
begin
  Result := FConfigInfo;
end;

procedure TibSHServerProps.SetConfigInfo(Value: Boolean);
begin
  FConfigInfo := Value;
end;

function TibSHServerProps.InternalExecute: Boolean;
var
  I: Integer;
begin
  Result := inherited InternalExecute;
  if Result then
  begin
    try
      Screen.Cursor := crHourGlass;
      Result := DRVService.Attach(stServerProperties, OnTextNotify);
      if Result then
      begin
        if LocationInfo then
        begin
          DRVService.DisplayLocationInfo;
          WriteString(EmptyStr);
          WriteString('[Location Info]');
          WriteString(Format('Base File             = %s', [DRVService.GetBaseFileLocation]));
          WriteString(Format('Lock File             = %s', [DRVService.GetLockFileLocation]));
          WriteString(Format('Message File          = %s', [DRVService.GetMessageFileLocation]));
          WriteString(Format('Security Database     = %s', [DRVService.GetSecurityLocation]));
        end;

        if VersionInfo then
        begin
          DRVService.DisplayServerInfo;
          WriteString(EmptyStr);
          WriteString('[Version Info]');
          WriteString(Format('Server Version        = %s', [DRVService.GetServerVersion]));
          WriteString(Format('Server Implementation = %s', [DRVService.GetServerImplementation]));
          WriteString(Format('Service Version       = %s', [DRVService.GetServiceVersion]));
        end;

        if DatabaseInfo then
        begin
          WriteString(EmptyStr);
          WriteString('[Database Info]');
          DRVService.DisplayDatabaseInfo;
          WriteString(Format('Number Of Attachments = %s', [DRVService.GetNumberOfAttachments]));
          WriteString(Format('Number Of Databases   = %s', [DRVService.GetNumberOfDatabases]));
          WriteString(Format('Attached Databases    = ', []));
          for I := 0 to StrToInt(DRVService.GetNumberOfDatabases) - 1 do
            WriteString(Format('  %s', [DRVService.GetDatabaseName(I)]));
        end;

        if LicenseInfo then
        begin
          WriteString(EmptyStr);
          WriteString('[License Info]');
          try
            DRVService.DisplayLicenseInfo;
            WriteString(Format('Licensed Users   = %s', [DRVService.GetLicensedUsers]));
            WriteString(Format('Key, ID and Desc = ', []));
            for I := 0 to DRVService.GetLicensedKeyCount do
            begin
              WriteString(Format('  %s', [DRVService.GetLicensedKey(I)]));
              WriteString(Format('  %s', [DRVService.GetLicensedID(I)]));
              WriteString(Format('  %s', [DRVService.GetLicensedDesc(I)]));
              WriteString(Format('  %s', [' ']));
            end;
          except
            WriteString(Format('Cannot get licensing info for current server', []));
          end;
         end;

        if ConfigInfo then
        begin
          WriteString(EmptyStr);
          WriteString('[Config Info]');
          try
            DRVService.DisplayConfigInfo;
            WriteString(Format('LOCKMEM_KEY       = %d', [DRVService.GetISCCFG_XXX_KEY(0)]));
            WriteString(Format('LOCKSEM_KEY       = %d', [DRVService.GetISCCFG_XXX_KEY(1)]));
            WriteString(Format('LOCKSIG_KEY       = %d', [DRVService.GetISCCFG_XXX_KEY(2)]));
            WriteString(Format('EVNTMEM_KEY       = %d', [DRVService.GetISCCFG_XXX_KEY(3)]));
            WriteString(Format('DBCACHE_KEY       = %d', [DRVService.GetISCCFG_XXX_KEY(4)]));
            WriteString(Format('PRIORITY_KEY      = %d', [DRVService.GetISCCFG_XXX_KEY(5)]));
            WriteString(Format('IPCMAP_KEY        = %d', [DRVService.GetISCCFG_XXX_KEY(6)]));
            WriteString(Format('MEMMIN_KEY        = %d', [DRVService.GetISCCFG_XXX_KEY(7)]));
            WriteString(Format('MEMMAX_KEY        = %d', [DRVService.GetISCCFG_XXX_KEY(8)]));
            WriteString(Format('LOCKORDER_KEY     = %d', [DRVService.GetISCCFG_XXX_KEY(9)]));
            WriteString(Format('ANYLOCKMEM_KEY    = %d', [DRVService.GetISCCFG_XXX_KEY(10)]));
            WriteString(Format('ANYLOCKSEM_KEY    = %d', [DRVService.GetISCCFG_XXX_KEY(11)]));
            WriteString(Format('ANYLOCKSIG_KEY    = %d', [DRVService.GetISCCFG_XXX_KEY(12)]));
            WriteString(Format('ANYEVNTMEM_KEY    = %d', [DRVService.GetISCCFG_XXX_KEY(13)]));
            WriteString(Format('LOCKHASH_KEY      = %d', [DRVService.GetISCCFG_XXX_KEY(14)]));
            WriteString(Format('DEADLOCK_KEY      = %d', [DRVService.GetISCCFG_XXX_KEY(15)]));
            WriteString(Format('LOCKSPIN_KEY      = %d', [DRVService.GetISCCFG_XXX_KEY(16)]));
            WriteString(Format('CONN_TIMEOUT_KEY  = %d', [DRVService.GetISCCFG_XXX_KEY(17)]));
            WriteString(Format('DUMMY_INTRVL_KEY  = %d', [DRVService.GetISCCFG_XXX_KEY(18)]));
            WriteString(Format('TRACE_POOLS_KEY   = %d', [DRVService.GetISCCFG_XXX_KEY(19)]));
            WriteString(Format('REMOTE_BUFFER_KEY = %d', [DRVService.GetISCCFG_XXX_KEY(20)]));
            WriteString(Format('CPU_AFFINITY_KEY  = %d', [DRVService.GetISCCFG_XXX_KEY(21)]));
            WriteString(Format('SWEEP_QUANTUM_KEY = %d', [DRVService.GetISCCFG_XXX_KEY(22)]));
            WriteString(Format('USER_QUANTUM_KEY  = %d', [DRVService.GetISCCFG_XXX_KEY(23)]));
            WriteString(Format('SLEEP_TIME_KEY    = %d', [DRVService.GetISCCFG_XXX_KEY(24)]));
            WriteString(Format('MAX_THREADS_KEY   = %d', [DRVService.GetISCCFG_XXX_KEY(25)]));
            WriteString(Format('ADMIN_DB_KEY      = %d', [DRVService.GetISCCFG_XXX_KEY(26)]));
            WriteString(Format('USE_SANCTUARY_KEY = %d', [DRVService.GetISCCFG_XXX_KEY(27)]));
          except
            WriteString(Format('Not Supported', []));
          end;
        end;
      end;
    finally
      DRVService.Detach;
      Screen.Cursor := crDefault;
    end;

    if not Result and Assigned(DRVService) then
      ErrorText := DRVService.ErrorText;
  end;
end;

{ TibSHServerLog }

function TibSHServerLog.InternalExecute: Boolean;
begin
  Result := inherited InternalExecute;
  if Result then
  begin
    try
      Screen.Cursor := crHourGlass;
      Result := DRVService.Attach(stLogService, OnTextNotify);
      if Result then
      begin
        WriteString(' ');
        Result := DRVService.DisplayServerLog;
      end;
    finally
      DRVService.Detach;
      Screen.Cursor := crDefault;
    end;

    if not Result and Assigned(DRVService) then
      ErrorText := DRVService.ErrorText;
  end;
end;

{ TibSHServerConfig }

{ TibSHServerLicense }

{ TibSHDatabaseShutdown }

constructor TibSHDatabaseShutdown.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMode := ShutdownModes[0];
  FTimeout := 0;
end;

destructor TibSHDatabaseShutdown.Destroy;
begin
  inherited Destroy;
end;

function TibSHDatabaseShutdown.GetMode: string;
begin
  Result := FMode;
end;

procedure TibSHDatabaseShutdown.SetMode(Value: string);
begin
  FMode := Value;
end;

function TibSHDatabaseShutdown.GetTimeout: Integer;
begin
  Result := FTimeout;
end;

procedure TibSHDatabaseShutdown.SetTimeout(Value: Integer);
begin
  FTimeout := Value;
end;

function TibSHDatabaseShutdown.CloseAllDatabases: Boolean;
var
  I: Integer;
  BTCLDatabase: IibSHDatabase;
begin
  Result := True;
  for I := Pred(Designer.Components.Count) downto 0 do
    if Supports(Designer.Components[I], IibSHDatabase, BTCLDatabase) and
       AnsiSameText(BTCLDatabase.Database, DatabaseName) and
       BTCLDatabase.Connected then
      Result := Designer.DisconnectFrom(TSHComponent(Designer.Components[I]));
end;

function TibSHDatabaseShutdown.InternalExecute: Boolean;
begin
  Result := inherited InternalExecute;
  if Result then
  begin
    try
      Screen.Cursor := crHourGlass;
      DRVService.ConnectDatabase := DatabaseName;
      Result := DRVService.Attach(stConfigService, OnTextNotify);
      if Result then
      begin
        if CloseAllDatabases then
        begin
          WriteString(' ');
          WriteString(Format('BT: Database shutdown process is running...', []));
          // Forced
          if AnsiSameText(Mode, ShutdownModes[0]) then
            Result := DRVService.DisplayDatabaseShutdown(0, Timeout);
          // Deny Transaction
          if AnsiSameText(Mode, ShutdownModes[1]) then
            Result := DRVService.DisplayDatabaseShutdown(1, Timeout);
          // Deny Attachment
          if AnsiSameText(Mode, ShutdownModes[2]) then
            Result := DRVService.DisplayDatabaseShutdown(2, Timeout);
          if Result then
          begin
            WriteString(Format('BT: Database shutdown completed successfully', []));
            WriteString(Format('BT: The database has been shut down and is currently in single-user mode', []));
          end;
        end;
      end;
    finally
      DRVService.Detach;
      Screen.Cursor := crDefault;
    end;

    if not Result and Assigned(DRVService) then
      ErrorText := DRVService.ErrorText;
  end;
end;

{ TibSHDatabaseOnline }

function TibSHDatabaseOnline.InternalExecute: Boolean;
begin
  Result := inherited InternalExecute;
  if Result then
  begin
    try
      Screen.Cursor := crHourGlass;
      DRVService.ConnectDatabase := DatabaseName;
      Result := DRVService.Attach(stConfigService, OnTextNotify);
      if Result then
      begin
        WriteString(' ');
        WriteString(Format('BT: Database restart process is running...', []));
        Result := DRVService.DisplayDatabaseOnline;
        if Result then
        begin
          WriteString(Format('BT: Database restart completed successfully', []));
          WriteString(Format('BT: The database has been restarted and is currently in online', []));          
        end;
      end;
    finally
      DRVService.Detach;
      Screen.Cursor := crDefault;
    end;

    if not Result and Assigned(DRVService) then
      ErrorText := DRVService.ErrorText;
  end;
end;

{ TibSHBackupRestoreService }

constructor TibSHBackupRestoreService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSourceFileList := TStringList.Create;
  FDestinationFileList := TStringList.Create;
  FVerbose := False;
end;

destructor TibSHBackupRestoreService.Destroy;
begin
  FSourceFileList.Free;
  FDestinationFileList.Free;
  inherited Destroy;
end;

function TibSHBackupRestoreService.GetSourceFileList: TStrings;
begin
  Result := FSourceFileList;
end;

function TibSHBackupRestoreService.GetDestinationFileList: TStrings;
begin
  Result := FDestinationFileList;
end;

function TibSHBackupRestoreService.GetVerbose: Boolean;
begin
  Result := FVerbose;
end;

procedure TibSHBackupRestoreService.SetVerbose(Value: Boolean);
begin
  FVerbose := Value;
end;

{ TibSHDatabaseBackup }

constructor TibSHDatabaseBackup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTransportable := True;
end;

destructor TibSHDatabaseBackup.Destroy;
begin
  inherited Destroy;
end;

function TibSHDatabaseBackup.GetTransportable: Boolean;
begin
  Result := FTransportable;
end;

procedure TibSHDatabaseBackup.SetTransportable(Value: Boolean);
begin
  FTransportable := Value;
end;

function TibSHDatabaseBackup.GetMetadataOnly: Boolean;
begin
  Result := FMetadataOnly;
end;

procedure TibSHDatabaseBackup.SetMetadataOnly(Value: Boolean);
begin
  FMetadataOnly := Value;
end;

function TibSHDatabaseBackup.GetNoGarbageCollect: Boolean;
begin
  Result := FNoGarbageCollect;
end;

procedure TibSHDatabaseBackup.SetNoGarbageCollect(Value: Boolean);
begin
  FNoGarbageCollect := Value;
end;

function TibSHDatabaseBackup.GetIgnoreLimboTrans: Boolean;
begin
  Result := FIgnoreLimboTrans;
end;

procedure TibSHDatabaseBackup.SetIgnoreLimboTrans(Value: Boolean);
begin
  FIgnoreLimboTrans := Value;
end;

function TibSHDatabaseBackup.GetIgnoreChecksums: Boolean;
begin
  Result := FIgnoreChecksums;
end;

procedure TibSHDatabaseBackup.SetIgnoreChecksums(Value: Boolean);
begin
  FIgnoreChecksums := Value;
end;

function TibSHDatabaseBackup.GetOldMetadataDesc: Boolean;
begin
  Result := FOldMetadataDesc;
end;

procedure TibSHDatabaseBackup.SetOldMetadataDesc(Value: Boolean);
begin
  FOldMetadataDesc := Value;
end;

function TibSHDatabaseBackup.GetConvertExtTables: Boolean;
begin
  Result := FConvertExtTables;
end;

procedure TibSHDatabaseBackup.SetConvertExtTables(Value: Boolean);
begin
  FConvertExtTables := Value;
end;

function TibSHDatabaseBackup.InternalExecute: Boolean;
begin
  Result := inherited InternalExecute;
  if Result then
  begin
    try
      Screen.Cursor := crHourGlass;
      DRVService.ConnectDatabase := DatabaseName;
      Result := DRVService.Attach(stBackupService, OnTextNotify);
      if Result then
      begin
        WriteString(' ');
        WriteString(Format('BT: Database backup process is running...', []));
        Result := DRVService.DisplayBackup(
          SourceFileList,
          DestinationFileList,
          Transportable,
          MetadataOnly,
          NoGarbageCollect,
          IgnoreLimboTrans,
          IgnoreChecksums,
          OldMetadataDesc,
          ConvertExtTables,
          Verbose);
        if Result then
          WriteString(Format('BT: Database backup completed successfully', []));
      end;
    finally
      DRVService.Detach;
      Screen.Cursor := crDefault;
    end;
    if not Result and Assigned(DRVService) then
      ErrorText := DRVService.ErrorText;
  end;
end;

{ TibSHDatabaseRestore }

constructor TibSHDatabaseRestore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPageSize := Format('%s', [SUnchanged]);
end;

destructor TibSHDatabaseRestore.Destroy;
begin
  inherited Destroy;
end;

function TibSHDatabaseRestore.GetPageSize: string;
begin
  Result := FPageSize;
end;

procedure TibSHDatabaseRestore.SetPageSize(Value: string);
begin
  FPageSize := Value;
end;

function TibSHDatabaseRestore.GetReplaceExisting: Boolean;
begin
  Result := FReplaceExisting;
end;

procedure TibSHDatabaseRestore.SetReplaceExisting(Value: Boolean);
begin
  FReplaceExisting := Value;
end;

function TibSHDatabaseRestore.GetMetadataOnly: Boolean;
begin
  Result := FMetadataOnly;
end;

procedure TibSHDatabaseRestore.SetMetadataOnly(Value: Boolean);
begin
  FMetadataOnly := Value;
end;

function TibSHDatabaseRestore.GetCommitEachTable: Boolean;
begin
  Result := FCommitEachTable;
end;

procedure TibSHDatabaseRestore.SetCommitEachTable(Value: Boolean);
begin
  FCommitEachTable := Value;
end;

function TibSHDatabaseRestore.GetWithoutShadow: Boolean;
begin
  Result := FWithoutShadow;
end;

procedure TibSHDatabaseRestore.SetWithoutShadow(Value: Boolean);
begin
  FWithoutShadow := Value;
end;

function TibSHDatabaseRestore.GetDeactivateIndexes: Boolean;
begin
  Result := FDeactivateIndexes;
end;

procedure TibSHDatabaseRestore.SetDeactivateIndexes(Value: Boolean);
begin
  FDeactivateIndexes := Value;
end;

function TibSHDatabaseRestore.GetNoValidityCheck: Boolean;
begin
  Result := FNoValidityCheck;
end;

procedure TibSHDatabaseRestore.SetNoValidityCheck(Value: Boolean);
begin
  FNoValidityCheck := Value;
end;

function TibSHDatabaseRestore.GetUseAllSpace: Boolean;
begin
  Result := FUseAllSpace;
end;

procedure TibSHDatabaseRestore.SetUseAllSpace(Value: Boolean);
begin
  FUseAllSpace := Value;
end;

function TibSHDatabaseRestore.InternalExecute: Boolean;
var
    vPageSize:integer;
begin
  Result := inherited InternalExecute;
  if Result then
  begin
    try
     vPageSize:=StrToIntDef(PageSize,0);
    except
     vPageSize:=0
    end;
    try
      Screen.Cursor := crHourGlass;
      DRVService.ConnectDatabase := DatabaseName;
      Result := DRVService.Attach(stRestoreService, OnTextNotify);
      if Result then
      begin
        WriteString(' ');
        WriteString(Format('BT: Database restore process is running...', []));
        Result := DRVService.DisplayRestore(
          SourceFileList,
          DestinationFileList,
          vPageSize,
          ReplaceExisting,
          MetadataOnly,
          CommitEachTable,
          WithoutShadow,
          DeactivateIndexes,
          NoValidityCheck,
          UseAllSpace,
          Verbose);
        if Result then
          WriteString(Format('BT: Database restore completed successfully', []));
      end;
    finally
      DRVService.Detach;
      Screen.Cursor := crDefault;
    end;
    if not Result and Assigned(DRVService) then
      ErrorText := DRVService.ErrorText;
  end;
end;

{ TibSHDatabaseStatistics }

constructor TibSHDatabaseStatistics.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStopAfter := StopAfters[0];
  MakePropertyInvisible('TableName');
end;

destructor TibSHDatabaseStatistics.Destroy;
begin
  inherited Destroy;
end;

function TibSHDatabaseStatistics.GetStopAfter: string;
begin
  Result := FStopAfter;
end;

procedure TibSHDatabaseStatistics.SetStopAfter(Value: string);
begin
  FStopAfter := Value;
  if AnsiSameText(FStopAfter, StopAfters[6]) then
    MakePropertyVisible('TableName')
  else
    MakePropertyInvisible('TableName');
  Designer.UpdateObjectInspector;
end;

function TibSHDatabaseStatistics.GetTableName: string;
begin
  Result := FTableName;
end;

procedure TibSHDatabaseStatistics.SetTableName(Value: string);
begin
  FTableName := Value;
end;

function TibSHDatabaseStatistics.InternalExecute: Boolean;
begin
  Result := inherited InternalExecute;
  if Result then
  begin
    try
      Screen.Cursor := crHourGlass;
      DRVService.ConnectDatabase := DatabaseName;
      Result := DRVService.Attach(stStatisticalService, OnTextNotify);
      if Result then
      begin
        // HeaderPage
        if AnsiSameText(StopAfter, StopAfters[0]) then
          Result := DRVService.DisplayDatabaseStatistics(0);
        // LogPages
        if AnsiSameText(StopAfter, StopAfters[1]) then
          Result := DRVService.DisplayDatabaseStatistics(1);
        // IndexPages
        if AnsiSameText(StopAfter, StopAfters[2]) then
          Result := DRVService.DisplayDatabaseStatistics(2);
        // DataPages
        if AnsiSameText(StopAfter, StopAfters[3]) then
          Result := DRVService.DisplayDatabaseStatistics(3);
        // SystemRelations
        if AnsiSameText(StopAfter, StopAfters[4]) then
          Result := DRVService.DisplayDatabaseStatistics(4);
        // RecordVersions
        if AnsiSameText(StopAfter, StopAfters[5]) then
          Result := DRVService.DisplayDatabaseStatistics(5);
        // StatTables
        if AnsiSameText(StopAfter, StopAfters[6]) then
          Result := DRVService.DisplayDatabaseStatistics(6, TableName);
      end;
    finally
      DRVService.Detach;
      Screen.Cursor := crDefault;
    end;

    if not Result and Assigned(DRVService) then
      ErrorText := DRVService.ErrorText;
  end;
end;

{ TibSHDatabaseValidation }

constructor TibSHDatabaseValidation.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TibSHDatabaseValidation.Destroy;
begin
  inherited Destroy;
end;

function TibSHDatabaseValidation.GetRecordFragments: Boolean;
begin
  Result := FRecordFragments;
end;

procedure TibSHDatabaseValidation.SetRecordFragments(Value: Boolean);
begin
  FRecordFragments := Value;
end;

function TibSHDatabaseValidation.GetReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

procedure TibSHDatabaseValidation.SetReadOnly(Value: Boolean);
begin
  FReadOnly := Value;
end;

function TibSHDatabaseValidation.GetIgnoreChecksum: Boolean;
begin
  Result := FIgnoreChecksum;
end;

procedure TibSHDatabaseValidation.SetIgnoreChecksum(Value: Boolean);
begin
  FIgnoreChecksum := Value;
end;

function TibSHDatabaseValidation.GetKillShadows: Boolean;
begin
  Result := FKillShadows;
end;

procedure TibSHDatabaseValidation.SetKillShadows(Value: Boolean);
begin
  FKillShadows := Value;
end;

function TibSHDatabaseValidation.InternalExecute: Boolean;
begin
  Result := inherited InternalExecute;
  if Result then
  begin
    try
      Screen.Cursor := crHourGlass;
      DRVService.ConnectDatabase := DatabaseName;
      Result := DRVService.Attach(stValidationService, OnTextNotify);
      if Result then
      begin
        WriteString(' ');
        WriteString(Format('BT: Database validation process is running...', []));
        Result := DRVService.DisplayDatabaseValidation(
          RecordFragments,
          ReadOnly,
          IgnoreChecksum,
          KillShadows);
        if Result then
        begin
          WriteString(Format('BT: Database validation process completed successfully', []));
          if Tag = 4 then
            WriteString(Format('BT: No database validation errors were found', []));
        end;
      end;
    finally
      DRVService.Detach;
      Screen.Cursor := crDefault;
    end;

    if not Result and Assigned(DRVService) then
      ErrorText := DRVService.ErrorText;
  end;
end;

{ TibSHDatabaseSweep }

function TibSHDatabaseSweep.GetIgnoreChecksum: Boolean;
begin
  Result := FIgnoreChecksum;
end;

procedure TibSHDatabaseSweep.SetIgnoreChecksum(Value: Boolean);
begin
  FIgnoreChecksum := Value;
end;

function TibSHDatabaseSweep.InternalExecute: Boolean;
begin
  Result := inherited InternalExecute;
  if Result then
  begin
    try
      Screen.Cursor := crHourGlass;
      DRVService.ConnectDatabase := DatabaseName;
      Result := DRVService.Attach(stValidationService, OnTextNotify);
      if Result then
      begin
        WriteString(' ');
        WriteString(Format('BT: Database sweep process is running...', []));
        Result := DRVService.DisplayDatabaseSweep(IgnoreChecksum);
        if Result then
          WriteString(Format('BT: Database sweep completed successfully', []));
      end;
    finally
      DRVService.Detach;
      Screen.Cursor := crDefault;
    end;

    if not Result and Assigned(DRVService) then
      ErrorText := DRVService.ErrorText;
  end;
end;

{ TibSHDatabaseMend }

function TibSHDatabaseMend.GetIgnoreChecksum: Boolean;
begin
  Result := FIgnoreChecksum;
end;

procedure TibSHDatabaseMend.SetIgnoreChecksum(Value: Boolean);
begin
  FIgnoreChecksum := Value;
end;

function TibSHDatabaseMend.InternalExecute: Boolean;
begin
  Result := inherited InternalExecute;
  if Result then
  begin
    try
      Screen.Cursor := crHourGlass;
      DRVService.ConnectDatabase := DatabaseName;
      Result := DRVService.Attach(stValidationService, OnTextNotify);
      if Result then
      begin
        WriteString(' ');
        WriteString(Format('BT: Database mend process is running...', []));
        Result := DRVService.DisplayDatabaseMend(IgnoreChecksum);
        if Result then
          WriteString(Format('BT: Database mend completed successfully', []));
      end;
    finally
      DRVService.Detach;
      Screen.Cursor := crDefault;
    end;

    if not Result and Assigned(DRVService) then
      ErrorText := DRVService.ErrorText;
  end;
end;

{ TibSHTransactionRecovery }

constructor TibSHTransactionRecovery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGlobalAction := GlobalActions[0];
end;

destructor TibSHTransactionRecovery.Destroy;
begin
  inherited Destroy;
end;

function TibSHTransactionRecovery.GetGlobalAction: string;
begin
  Result := FGlobalAction;
end;

procedure TibSHTransactionRecovery.SetGlobalAction(Value: string);
begin
  FGlobalAction := Value;
end;

function TibSHTransactionRecovery.InternalExecute: Boolean;
var
  I: Integer;
begin
  Result := inherited InternalExecute;
  if Result then
  begin
    try
      Screen.Cursor := crHourGlass;
      DRVService.ConnectDatabase := DatabaseName;
      Result := DRVService.Attach(stValidationService, OnTextNotify);
      if Result then
      begin
        WriteString(' ');
        WriteString(Format('BT: Database find limbo transactions process is running...', []));
        Result := DRVService.DisplayLimboTransactions;
        if Result then
        begin
          for I := 0 to Pred(DRVService.GetLimboTransactionCount) do
          begin
            WriteString(Format('MultiDatabase      = %s', [BoolToStr(DRVService.GetLimboTransactionMultiDatabase(I), True)]));
            WriteString(Format('TransactionID      = %d', [DRVService.GetLimboTransactionID(I)]));
            WriteString(Format('HostSite           = %s', [DRVService.GetLimboTransactionHostSite(I)]));
            WriteString(Format('RemoteSite         = %s', [DRVService.GetLimboTransactionRemoteSite(I)]));
            WriteString(Format('RemoteDatabasePath = %s', [DRVService.GetLimboTransactionRemoteDatabasePath(I)]));
            WriteString(Format('State              = %s', [DRVService.GetLimboTransactionState(I)]));
            WriteString(Format('Advise             = %s', [DRVService.GetLimboTransactionAdvise(I)]));
            WriteString(Format('Action             = %s', [DRVService.GetLimboTransactionAction(I)]));
            WriteString(EmptyStr);
          end;
          WriteString(Format('BT: Database find limbo transactions completed successfully', []));
          if DRVService.GetLimboTransactionCount = 0 then
            WriteString(Format('BT: No pending transactions were found', []));
        end;

        // No pending transactions were found
      end;
    finally
      DRVService.Detach;
      Screen.Cursor := crDefault;
    end;

    if not Result and Assigned(DRVService) then
      ErrorText := DRVService.ErrorText;
  end;
end;

{ TibSHDatabaseProps }

constructor TibSHDatabaseProps.Create(AOwner: TComponent);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner);
  FActiveUsers := TStringList.Create;
  vComponentClass := Designer.GetComponent(IibSHDatabase);
  if Assigned(vComponentClass) then
  begin
    FIntDatabase := vComponentClass.Create(Self);
    Supports(FIntDatabase, IibSHDatabase, FIntDatabaseIntf);
  end;

  MakePropertyInvisible('ODSVersion');
  MakePropertyInvisible('Charset');
  MakePropertyInvisible('PageSize');
  MakePropertyInvisible('SweepInterval');
  MakePropertyInvisible('ForcedWrites');
  MakePropertyInvisible('ReadOnly');
  MakePropertyInvisible('SQLDialect');
  MakePropertyInvisible('PageBuffers');
end;

destructor TibSHDatabaseProps.Destroy;
begin
  FActiveUsers.Free;
  FIntDatabaseIntf := nil;
  FreeAndNil(FIntDatabase);
  inherited Destroy;
end;

function TibSHDatabaseProps.GetODSVersion: string;
begin
  Result := FODSVersion;
end;

//procedure TibSHDatabaseProps.SetODSVersion(Value: string);
//begin
//  FODSVersion := Value;
//end;

function TibSHDatabaseProps.GetCharset: string;
begin
  Result := FCharset;
end;

//procedure TibSHDatabaseProps.SetCharset(Value: string);
//begin
//  FCharset := Value;
//end;

function TibSHDatabaseProps.GetPageSize: string;
begin
  Result := FPageSize;
end;

//procedure TibSHDatabaseProps.SetPageSize(Value: string);
//begin
//  FPageSize := Value;
//end;

function TibSHDatabaseProps.GetActiveUsers: TStrings;
begin
  Result := FActiveUsers;
end;

function TibSHDatabaseProps.GetSweepInterval: Integer;
begin
  Result := FSweepInterval;
end;

procedure TibSHDatabaseProps.SetSweepInterval(Value: Integer);
begin
  if FSweepInterval <> Value then
  begin
    FSweepInterval := Value;
    try
      DRVService.ConnectDatabase := DatabaseName;
      if DRVService.Attach(stConfigService, OnTextNotify) then
        DRVService.SetSweepInterval(FSweepInterval);
    finally
      DRVService.Detach;
    end;
  end;
end;

function TibSHDatabaseProps.GetForcedWrites: Boolean;
begin
  Result := FForcedWrites;
end;

procedure TibSHDatabaseProps.SetForcedWrites(Value: Boolean);
begin
  if FForcedWrites <> Value then
  begin
    FForcedWrites := Value;
    try
      DRVService.ConnectDatabase := DatabaseName;
      if DRVService.Attach(stConfigService, OnTextNotify) then
        DRVService.SetForcedWrites(FForcedWrites);
    finally
      DRVService.Detach;
    end;
  end;
end;

function TibSHDatabaseProps.GetReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

procedure TibSHDatabaseProps.SetReadOnly(Value: Boolean);
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;
    try
      DRVService.ConnectDatabase := DatabaseName;
      if DRVService.Attach(stConfigService, OnTextNotify) then
        DRVService.SetReadOnly(FReadOnly);
    finally
      DRVService.Detach;
    end;
  end;
end;

function TibSHDatabaseProps.GetSQLDialect: string;
begin
  Result := FSQLDialect;
end;

procedure TibSHDatabaseProps.SetSQLDialect(Value: string);
begin
  if FSQLDialect <> Value then
  begin
    FSQLDialect := Value;
    try
      DRVService.ConnectDatabase := DatabaseName;
      if DRVService.Attach(stConfigService, OnTextNotify) then
        DRVService.SetSQLDialect(StrToInt(FSQLDialect));
    finally
      DRVService.Detach;
    end;
  end;
end;

function TibSHDatabaseProps.GetPageBuffers: Integer;
begin
  Result := FPageBuffers;
end;

procedure TibSHDatabaseProps.SetPageBuffers(Value: Integer);
begin
  if FPageBuffers <> Value then
  begin
    FPageBuffers := Value;
    try
      DRVService.ConnectDatabase := DatabaseName;
      if DRVService.Attach(stConfigService, OnTextNotify) then
        DRVService.SetPageBuffers(FPageBuffers);
    finally
      DRVService.Detach;
    end;
  end;
end;

function TibSHDatabaseProps.InternalExecute: Boolean;
var
  I: Integer;
begin
  Result := inherited InternalExecute;
  MakePropertyInvisible('ODSVersion');
  MakePropertyInvisible('Charset');
  MakePropertyInvisible('PageSize');
  MakePropertyInvisible('SweepInterval');
  MakePropertyInvisible('ForcedWrites');
  MakePropertyInvisible('ReadOnly');
  MakePropertyInvisible('SQLDialect');
  MakePropertyInvisible('PageBuffers');
  Designer.UpdateObjectInspector;

  if Assigned(FIntDatabaseIntf) then
  begin
    FIntDatabaseIntf.OwnerIID := BTCLServer.InstanceIID;
    FIntDatabaseIntf.Database := DatabaseName;
    FIntDatabaseIntf.StillConnect := True;
  end;

  if Result then
  begin
    try
      Screen.Cursor := crHourGlass;
      DRVService.ConnectDatabase := DatabaseName;
      Result := DRVService.Attach(stConfigService, OnTextNotify);
      if Result then
      begin
        Result := Assigned(FIntDatabaseIntf) and FIntDatabaseIntf.Connect;
        if Result then
        begin
          FODSVersion := FIntDatabaseIntf.DRVQuery.Database.ODSVersion;
          FPageSize := IntToStr(FIntDatabaseIntf.DRVQuery.Database.PageSize);
          FPageBuffers := FIntDatabaseIntf.DRVQuery.Database.PageBuffers;
          FSweepInterval := FIntDatabaseIntf.DRVQuery.Database.SweepInterval;
          FForcedWrites := FIntDatabaseIntf.DRVQuery.Database.ForcedWrites;
          FReadOnly := FIntDatabaseIntf.DRVQuery.Database.ReadOnly;
          FCharset := FIntDatabaseIntf.DBCharset;// .DRVQuery.Database.Charset;
          FSQLDialect := IntToStr(FIntDatabaseIntf.DRVQuery.Database.SQLDialect);
          FActiveUsers.Assign(FIntDatabaseIntf.DRVQuery.Database.UserNames);

          WriteString(Format(' ', []));
          WriteString(Format('ODSVersion    = %s', [ODSVersion]));
          WriteString(Format('Charset       = %s', [Charset]));
          WriteString(Format('PageSize      = %s', [PageSize]));
          WriteString(Format('PageBuffers   = %d', [PageBuffers]));
          WriteString(Format('SQLDialect    = %s', [SQLDialect]));
          WriteString(Format('SweepInterval = %d', [SweepInterval]));
          WriteString(Format('ForcedWrites  = %s', [BoolToStr(ForcedWrites, True)]));
          WriteString(Format('ReadOnly      = %s', [BoolToStr(ReadOnly, True)]));
          WriteString(Format('Active Users  = ', []));
          for I := 0 to Pred(ActiveUsers.Count) do
            WriteString(Format('  %s', [ActiveUsers[I]]));

          MakePropertyVisible('ODSVersion');
          MakePropertyVisible('Charset');
          MakePropertyVisible('PageSize');
          MakePropertyVisible('SweepInterval');
          MakePropertyVisible('ForcedWrites');
          MakePropertyVisible('ReadOnly');
          MakePropertyVisible('SQLDialect');
          MakePropertyVisible('PageBuffers');
          Designer.UpdateObjectInspector;
        end;
      end;
    finally
      DRVService.Detach;
      FIntDatabaseIntf.Disconnect;
      Screen.Cursor := crDefault;
    end;

    if not Result and Assigned(DRVService) then
    begin
      if Length(FIntDatabaseIntf.DRVQuery.Database.ErrorText) > 0 then
        ErrorText := FIntDatabaseIntf.DRVQuery.Database.ErrorText
      else
        ErrorText := DRVService.ErrorText;
    end;
  end;
end;

initialization

  Register;

end.

