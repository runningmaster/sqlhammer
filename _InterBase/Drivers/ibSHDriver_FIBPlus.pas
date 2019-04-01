unit ibSHDriver_FIBPlus;

interface

//{$DEFINE TRIFONOV}
uses
  // Native Modules
  Windows, SysUtils, Classes, StrUtils, TypInfo, Dialogs, Controls, Types, Forms,
  // SQLHammer Modules IB_Intf
  SHDesignIntf, ibSHDriverIntf, ibSHTableStatisticCalculator,
  // FIBPlus Modules
  DB, fib, ibase, FIBDatabase, pFIBDatabase, pFIBQuery, FIBQuery, FIBDataSet, pFIBDataSet,
  FIBSQLMonitor, IB_Services, pFIBProps, pFibErrorHandler, SqlTxtRtns, StrUtil,
  pFIBDataInfo,pFIBCacheQueries,
    {$IFDEF  TRIFONOV}pFIBScript{$ELSE}pFIBScripter{$ENDIF};

type
  TibBTDriver = class(TSHComponent, IibSHDRV)
  private
    FNativeDAC: TObject;
    FFIBError: TpFibErrorHandler;
    FErrorText: string;
    FLastErrorCode:TibErrorCode;
    function GetNativeDAC: TObject;
    procedure SetNativeDAC(Value: TObject);
    function GetErrorText: string;
    procedure SetErrorText(Value: string);
    procedure ErrorEvent(Sender: TObject; ErrorValue: EFIBError; KindIBError: TKindIBError; var DoRaise: Boolean);
    function GetLastErrorCode:TibErrorCode;
  protected
    property FIBError: TpFibErrorHandler read FFIBError;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function GetClassIIDClassFnc: TGUID; override;

    property NativeDAC: TObject read GetNativeDAC write SetNativeDAC;
    property ErrorText: string read GetErrorText write SetErrorText;
  end;

  TibBTDRVDatabase = class(TibBTDriver, IibSHDRVDatabase,IibSHDRVDatabaseExt)
  private
    FFIBDatabase: TpFIBDatabase;
    FOnLostConnect: TNotifyEvent;
    procedure EndTrEvent(EndingTR: TFIBTransaction; Action: TTransactionAction; Force: Boolean);
    procedure LostConnectEvent(Database: TFIBDatabase; E: EFIBError; var Actions: TOnLostConnectActions);
    procedure DoOnErrorRestoreConnect(Database: TFIBDatabase; E: EFIBError; var Actions: TOnLostConnectActions);


    function GetDatabase: string;
    procedure SetDatabase(Value: string);
    function GetCharset: string;
    procedure SetCharset(Value: string);
    function GetUserName: string;
    procedure SetUserName(Value: string);
    function GetPassword: string;
    procedure SetPassword(Value: string);
    function GetRoleName: string;
    procedure SetRoleName(Value: string);
    function GetLoginPrompt: Boolean;
    procedure SetLoginPrompt(Value: Boolean);
    function GetOnLostConnect: TNotifyEvent;
    procedure SetOnLostConnect(Value: TNotifyEvent);
    function GetDBParams: TStrings;
    procedure SetDBParams(Value: TStrings);
    function GetClientLibrary: string;
    procedure SetClientLibrary(Value: string);
    function GetSQLDialect: Integer;
    procedure SetSQLDialect(Value: Integer);
    function GetCapitalizeNames: Boolean;
    procedure SetCapitalizeNames(Value: Boolean);
    function GetConnected: Boolean;
    procedure SetConnected(Value: Boolean);
    function GetUserNames: TStrings;
    function GetODSVersion: string;
    function GetPageSize: Integer;
    function GetAllocationPages: Integer;
    function GetPageBuffers: Integer;
    function GetSweepInterval: Integer;
    function GetForcedWrites: Boolean;
    function GetReadOnly: Boolean;
    function GetRecordCountSelect(const ForSQL:string):string;
  protected
    procedure DatabaseAfterDisconnect(Sender: TObject);

    property FIBDatabase: TpFIBDatabase read FFIBDatabase;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Connect: Boolean;
    function Reconnect: Boolean;
    function Disconnect: Boolean;
    procedure CreateDatabase;
    procedure DropDatabase;
    function TestConnection: Boolean;
    procedure ClearCache;
    function IsFirebirdConnect:boolean;
    function IsTableOrView(const ObjectName:string):boolean;    

    property Database: string read GetDatabase write SetDatabase;
    property Charset: string read GetCharset write SetCharset;
    property UserName: string read GetUserName write SetUserName;
    property Password: string read GetPassword write SetPassword;
    property RoleName: string read GetRoleName write SetRoleName;
    property LoginPrompt: Boolean read GetLoginPrompt write SetLoginPrompt;

    property OnLostConnect: TNotifyEvent read GetOnLostConnect write SetOnLostConnect;

    property DBParams: TStrings read GetDBParams write SetDBParams;
    property ClientLibrary: string read GetClientLibrary write SetClientLibrary;
    property SQLDialect: Integer read GetSQLDialect write SetSQLDialect;
    property CapitalizeNames: Boolean read GetCapitalizeNames write SetCapitalizeNames;
    property Connected: Boolean read GetConnected write SetConnected;
    property UserNames: TStrings read GetUserNames;

    property ODSVersion: string read GetODSVersion;
    property PageSize: Integer read GetPageSize;
    property AllocationPages: Integer read GetAllocationPages;
    property PageBuffers: Integer read GetPageBuffers;
    property SweepInterval: Integer read GetSweepInterval;
    property ForcedWrites: Boolean read GetForcedWrites;
    property ReadOnly: Boolean read GetReadOnly;
  end;

  TibBTDRVTransaction = class(TibBTDriver, IibSHDRVTransaction)
  private
    FFIBTransaction: TpFIBTransaction;
    FDRVDatabase: IibSHDRVDatabase;
    FTransactionNotification: IibSHDRVTransactionNotification;
    function GetDatabase: IibSHDRVDatabase;
    procedure SetDatabase(const Value: IibSHDRVDatabase);
    function GetParams: TStrings;
    procedure SetParams(Value: TStrings);
    function GetTransactionNotification: IibSHDRVTransactionNotification;
    procedure SetTransactionNotification(Value: IibSHDRVTransactionNotification);

    procedure DoEndTrEvent(EndingTR:TFIBTransaction; Action: TTransactionAction;
      Force: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    property FIBTransaction: TpFIBTransaction read FFIBTransaction;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function InTransaction: Boolean;
    procedure StartTransaction;
    function Commit: Boolean;
    function CommitRetaining: Boolean;
    function Rollback: Boolean;
    function RollbackRetaining: Boolean;

    property Database: IibSHDRVDatabase read GetDatabase write SetDatabase;
    property Params: TStrings read GetParams write SetParams;
  end;

  TibBTDRVQuery = class(TibBTDriver, IibSHDRVQuery, IibSHDRVParams, IibSHDRVExecTimeStatistics,
   IBTDynamicMethod
  )
  private
    FFIBQuery: TFIBQuery;
    FDRVDatabase: IibSHDRVDatabase;
    FDRVTransaction: IibSHDRVTransaction;
    FPrepareTime: Cardinal;
    function GetDatabase: IibSHDRVDatabase;
    procedure SetDatabase(const Value: IibSHDRVDatabase);
    function GetTransaction: IibSHDRVTransaction;
    procedure SetTransaction(const Value: IibSHDRVTransaction);
    function GetSQL: TStrings;
    procedure SetSQL(Value: TStrings);
    function GetParamCheck: Boolean;
    procedure SetParamCheck(Value: Boolean);
    function GetPlan: string;
    function GetActive: Boolean;
    function GetBof: Boolean;
    function GetEof: Boolean;
    function GetPrepared: Boolean;

    function GetParamByIndex(Index: Integer): Variant;
    procedure SetParamByIndex(Index: Integer; Value: Variant);
    function GetParamIsNull(Index: Integer): Boolean;
    procedure SetParamIsNull(Index: Integer; Value: Boolean);
    function GetParamCount: Integer;
    {IibSHDRVExecTimeStatistics}
    function GetPrepareTime: Cardinal;
    function GetExecuteTime: Cardinal;
    function GetFetchTime: Cardinal;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    property FIBQuery: TFIBQuery read FFIBQuery;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

 //IBTDynamicMethod
    function DynMethodExist(const MethodName:string):boolean;
    function DynMethodExec(const MethodName:string; const Args: array of Variant):Variant;
    function DynMethodExecOut(const MethodName:string; const Args: array of Variant;
     var Results : TDynMethodResults
    ):Variant;
 //End IBTDynamicMethod    

    function ParamExists(const ParamName: string): Boolean;
    function ParamName(ParamNo: Integer): string;
    function GetParamSize(const ParamName: string): Integer; overload;
    function GetParamSize(ParamNo: Integer): Integer; overload;
    function GetParamByName(const ParamName: string): Variant;
    procedure SetParamByName(const ParamName: string; Value: Variant);

    function ExecSQL(const SQLText: string; const AParams: array of Variant; AutoCommit: Boolean;KeepPrepared:boolean=False): Boolean;

    function Prepare: Boolean;
    function Execute: Boolean;
    procedure Next;
    procedure Close;

    function FieldExists(const FieldName: string): Boolean;
    function FieldName(FieldNo: Integer): string;
    function FieldIsBlob(FieldNo: Integer): Boolean;

    function GetFieldValue(const FieldName: string): Variant; overload;
    function GetFieldValue(FieldNo: Integer): Variant; overload;
    function GetFieldStrValue(const FieldName: string): string; overload;
    function GetFieldStrValue(FieldNo: Integer): string; overload;
    function GetFieldIntValue(const FieldName: string): Integer; overload;
    function GetFieldIntValue(FieldNo: Integer): Integer; overload;
    function GetFieldInt64Value(const FieldName: string): Int64; overload;
    function GetFieldInt64Value(FieldNo: Integer): Int64; overload;
    function GetFieldFloatValue(const FieldName: string): Double; overload;
    function GetFieldFloatValue(FieldNo: Integer): Double; overload;
    function GetFieldIsNull(const FieldName: string): Boolean; overload;
    function GetFieldIsNull(FieldNo: Integer): Boolean; overload;
    function GetFieldSize(const FieldName: string): Integer; overload;
    function GetFieldSize(FieldNo: Integer): Integer; overload;
    function GetFieldCount: Integer;
    function GetDebugFieldValue(Index:integer): Variant;
    
    property Database: IibSHDRVDatabase read GetDatabase write SetDatabase;
    property Transaction: IibSHDRVTransaction read GetTransaction write SetTransaction;
    property SQL: TStrings read GetSQL write SetSQL;
    property ParamCheck: Boolean read GetParamCheck write SetParamCheck;
    property Plan: string read GetPlan;
    property Active: Boolean read GetActive;
    property Bof: Boolean read GetBof;
    property Eof: Boolean read GetEof;
    property Prepared: Boolean read GetPrepared;

    property ParamByIndex[Index: Integer]: Variant read GetParamByIndex write SetParamByIndex;
    property ParamIsNull[Index: Integer]: Boolean read GetParamIsNull write SetParamIsNull;
    property ParamCount: Integer read GetParamCount;
  end;

  TBTpFIBDataset = class(TpFIBDataset)
  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
  end;

  TibBTDRVDataset = class(TibBTDriver, IibSHDRVDataset, IibSHDRVExecTimeStatistics, IibSHDRVParams,
   IBTDynamicMethod
  )
  private
    FFIBDataset: TpFIBDataset;
    FDRVDatabase: IibSHDRVDatabase;
    FDRVReadTransaction: IibSHDRVTransaction;
    FDRVWriteTransaction: IibSHDRVTransaction;
    FExecuteTime: Cardinal;
    FPrepareTime: Cardinal;
    FFetchTime: Cardinal;
    FDataModified: Boolean;
    FDatasetNotification: IibDRVDatasetNotification;
    FNeedMultyUpdateCheck: Boolean;

    FIsFetching: Boolean;
    FForceStopFetch: Boolean;
    FSysTimeBeforeRecordFetch: Cardinal;
    FRevertToDB_KEY: Boolean;
    function IsMultiRecordsAffect(ASQLText: string): Boolean;

    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetAutoCommit: Boolean;
    procedure SetAutoCommit(Value: Boolean);
    function GetDatabase: IibSHDRVDatabase;
    procedure SetDatabase(const Value: IibSHDRVDatabase);
    function GetReadTransaction: IibSHDRVTransaction;
    procedure SetReadTransaction(const Value: IibSHDRVTransaction);
    function GetWriteTransaction: IibSHDRVTransaction;
    procedure SetWriteTransaction(const Value: IibSHDRVTransaction);
    function GetSelectSQL: TStrings;
    procedure SetSelectSQL(Value: TStrings);
    function GetInsertSQL: TStrings;
    procedure SetInsertSQL(Value: TStrings);
    function GetUpdateSQL: TStrings;
    procedure SetUpdateSQL(Value: TStrings);
    function GetDeleteSQL: TStrings;
    procedure SetDeleteSQL(Value: TStrings);
    function GetRefreshSQL: TStrings;
    procedure SetRefreshSQL(Value: TStrings);
    function GetDataset: TDataset;
    function  GetPlan: string;
    function GetDataModified: Boolean;
    function GetIsFetching: Boolean;
    procedure SetIsFetching(Value: Boolean);
    function GetIsEmpty: Boolean;
    function GetFilter: string;
    procedure SetFilter(Value: string);
    function GetDatasetNotification: IibDRVDatasetNotification;
    procedure SetDatasetNotification(Value: IibDRVDatasetNotification);
    function GetPrepared: Boolean;

    function GetPrepareTime: Cardinal;
    function GetExecuteTime: Cardinal;
    function GetFetchTime: Cardinal;

    function GetParamByIndex(Index: Integer): Variant;
    procedure SetParamByIndex(Index: Integer; Value: Variant);
    function GetParamIsNull(Index: Integer): Boolean;
    procedure SetParamIsNull(Index: Integer; Value: Boolean);
    function GetParamCount: Integer;
    {Native dataset events}
    procedure BeforeFetchRecord(
      FromQuery: TFIBQuery; RecordNumber: Integer; var StopFetching: Boolean);
    procedure AfterFetchRecord(
      FromQuery: TFIBQuery; RecordNumber: Integer; var StopFetching: Boolean);

    procedure AfterCloseDataset(DataSet: TDataset);
    procedure AfterOpenDataset(DataSet: TDataset);
    procedure AfterDeleteDataset(DataSet: TDataset);
    procedure AfterInsertDataset(DataSet: TDataset);
    procedure AfterPost(DataSet: TDataSet);
    procedure BeforePost(DataSet: TDataSet);
    procedure BeforeDelete(DataSet: TDataSet);
    procedure TransactionEnded(Sender: TObject);
    procedure DoOnAnyError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure DoOnLockError(DataSet: TDataSet;
      LockError: TLockStatus; var ErrorMessage: String;
      var Action: TDataAction);
    procedure DoOnUpdateError(DataSet: TDataSet; E: EFIBError;
      UpdateKind: TUpdateKind; var UpdateAction: TFIBUpdateAction);
    function AllKeyModifiedFields(const TableName: string): string;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    property FIBDataset: TpFIBDataset read FFIBDataset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

 //IBTDynamicMethod
    function DynMethodExist(const MethodName:string):boolean;
    function DynMethodExec(const MethodName:string; const Args: array of Variant):Variant;
    function DynMethodExecOut(const MethodName:string; const Args: array of Variant;
     var Results : TDynMethodResults
    ):Variant;
 //End IBTDynamicMethod    
    

    function ParamExists(const ParamName: string): Boolean;
    function ParamName(ParamNo: Integer): string;
    function GetParamSize(const ParamName: string): Integer; overload;
    function GetParamSize(ParamNo: Integer): Integer; overload;
    function GetParamByName(const ParamName: string): Variant;
    procedure SetParamByName(const ParamName: string; Value: Variant);

    function  GetRelationTableName(FieldIndex: Integer):string;
    function  GetRelationFieldName(FieldIndex: Integer):string;
    function  GetDebugFieldValue(Index:integer): Variant;

    function Prepare: Boolean;
    procedure Open;
    procedure FetchAll;
    procedure Close;
    procedure CrearAllSQLs;
    procedure GenerateSQLs(const ATableName, AKeyFields: string; AllFieldsUsed: Boolean);
    procedure SetAutoGenerateSQLsParams(const ATableName, AKeyFields: string; AllFieldsUsed: Boolean);
    procedure DoSort(Fields: array of const; Ordering: array of Boolean);

    property Database: IibSHDRVDatabase read GetDatabase write SetDatabase;
    property ReadTransaction: IibSHDRVTransaction read GetReadTransaction write SetReadTransaction;
    property WriteTransaction: IibSHDRVTransaction read GetWriteTransaction write SetWriteTransaction;
    property SelectSQL: TStrings read GetSelectSQL write SetSelectSQL;
    property InsertSQL: TStrings read GetInsertSQL write SetInsertSQL;
    property UpdateSQL: TStrings read GetUpdateSQL write SetUpdateSQL;
    property DeleteSQL: TStrings read GetDeleteSQL write SetDeleteSQL;
    property RefreshSQL: TStrings read GetRefreshSQL write SetRefreshSQL;
    property Dataset: TDataset read GetDataset;
    property Prepared: Boolean read GetPrepared;

    property PrepareTime: Cardinal read GetPrepareTime;
    property ExecuteTime: Cardinal read GetExecuteTime;
    property FetchTime: Cardinal read GetFetchTime;

    property ParamByIndex[Index: Integer]: Variant read GetParamByIndex write SetParamByIndex;
    property ParamIsNull[Index: Integer]: Boolean read GetParamIsNull write SetParamIsNull;
    property ParamCount: Integer read GetParamCount;
  end;

  TibBTDRVMonitor = class(TibBTDriver, IibSHDRVMonitor)
  private
    FFIBMonitor: TFIBSQLMonitor;

    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetTracePrepare: Boolean;
    procedure SetTracePrepare(Value: Boolean);
    function GetTraceExecute: Boolean;
    procedure SetTraceExecute(Value: Boolean);
    function GetTraceFetch: Boolean;
    procedure SetTraceFetch(Value: Boolean);
    function GetTraceConnect: Boolean;
    procedure SetTraceConnect(Value: Boolean);
    function GetTraceTransact: Boolean;
    procedure SetTraceTransact(Value: Boolean);
    function GetTraceService: Boolean;
    procedure SetTraceService(Value: Boolean);
    function GetTraceStmt: Boolean;
    procedure SetTraceStmt(Value: Boolean);
    function GetTraceError: Boolean;
    procedure SetTraceError(Value: Boolean);
    function GetTraceBlob: Boolean;
    procedure SetTraceBlob(Value: Boolean);
    function GetTraceMisc: Boolean;
    procedure SetTraceMisc(Value: Boolean);
    function GetOnSQL: TibSHOnSQLNotify;
    procedure SetOnSQL(Value: TibSHOnSQLNotify);
  protected
    property FIBMonitor: TFIBSQLMonitor read FFIBMonitor;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Active: Boolean read GetActive write SetActive;
    property TracePrepare: Boolean read GetTracePrepare write SetTracePrepare;
    property TraceExecute: Boolean read GetTraceExecute write SetTraceExecute;
    property TraceFetch: Boolean read GetTraceFetch write SetTraceFetch;
    property TraceConnect: Boolean read GetTraceConnect write SetTraceConnect;
    property TraceTransact: Boolean read GetTraceTransact write SetTraceTransact;
    property TraceService: Boolean read GetTraceService write SetTraceService;
    property TraceStmt: Boolean read GetTraceStmt write SetTraceStmt;
    property TraceError: Boolean read GetTraceError write SetTraceError;
    property TraceBlob: Boolean read GetTraceBlob write SetTraceBlob;
    property TraceMisc: Boolean read GetTraceMisc write SetTraceMisc;
    property OnSQL: TibSHOnSQLNotify read GetOnSQL write SetOnSQL;
  end;

  TibBTDRVService = class(TibBTDriver, IibSHDRVService)
  private
    FServiceType: TibSHServiceType;
    FFIBCustomService: TpFIBCustomService;
    FConnectProtocol: string;
    FConnectPort: string;
    FConnectLibraryName: string;
    FConnectLoginPrompt: Boolean;
    FConnectUser: string;
    FConnectPassword: string;
    FConnectRole: string;
    FConnectServer: string;
    FConnectDatabase: string;
    function GetActive: Boolean;
    function GetServiceType: TibSHServiceType;
    function GetConnectProtocol: string;
    procedure SetConnectProtocol(Value: string);
    function GetConnectPort: string;
    procedure SetConnectPort(Value: string);
    function GetConnectLibraryName: string;
    procedure SetConnectLibraryName(Value: string);
    function GetConnectLoginPrompt: Boolean;
    procedure SetConnectLoginPrompt(Value: Boolean);
    function GetConnectUser: string;
    procedure SetConnectUser(Value: string);
    function GetConnectPassword: string;
    procedure SetConnectPassword(Value: string);
    function GetConnectRole: string;
    procedure SetConnectRole(Value: string);
    function GetConnectServer: string;
    procedure SetConnectServer(Value: string);
    function GetConnectDatabase: string;
    procedure SetConnectDatabase(Value: string);
  protected
    property FIBCustomService: TpFIBCustomService read FFIBCustomService;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Attach(AServiceType: TibSHServiceType; OnText: TSHOnTextNotify = nil): Boolean;
    function Detach: Boolean;

    // Server Users
    procedure DisplayUsers;
    function UserCount: Integer;
    function GetUserName(AIndex: Integer): string;
    function GetFirstName(AIndex: Integer): string;
    function GetMiddleName(AIndex: Integer): string;
    function GetLastName(AIndex: Integer): string;
    function AddUser(const UserName, Password, FirstName, MiddleName, LastName: string): Boolean;
    function DeleteUser(const UserName: string): Boolean;
    function ModifyUser(const UserName, Password, FirstName, MiddleName, LastName: string): Boolean;
    // Server Properties
    procedure DisplayLocationInfo;
    function GetBaseFileLocation: string;
    function GetLockFileLocation: string;
    function GetMessageFileLocation: string;
    function GetSecurityLocation: string;

    procedure DisplayServerInfo;
    function GetServerVersion: string;
    function GetServerImplementation: string;
    function GetServiceVersion: string;

    procedure DisplayDatabaseInfo;
    function GetNumberOfAttachments: string;
    function GetNumberOfDatabases: string;
    function GetDatabaseName(AIndex: Integer): string;

    procedure DisplayLicenseInfo;
    function GetLicensedUsers: string;
    function GetLicensedKeyCount: Integer;
    function GetLicensedKey(AIndex: Integer): string;
    function GetLicensedID(AIndex: Integer): string;
    function GetLicensedDesc(AIndex: Integer): string;

    procedure DisplayConfigInfo;
    function GetISCCFG_XXX_KEY(AKey: Integer): Integer;

    function DisplayServerLog: Boolean;
    function DisplayDatabaseStatistics(const AStopIndex: Integer; ATableName: string = ''): Boolean;
    function DisplayDatabaseValidation(const ARecordFragments, AReadOnly, AIgnoreChecksum, AKillShadows: Boolean): Boolean;
    function DisplayDatabaseSweep(const AIgnoreChecksum: Boolean): Boolean;
    function DisplayDatabaseMend(const AIgnoreChecksum: Boolean): Boolean;

    function DisplayLimboTransactions: Boolean;
    procedure FixLimboTransactionErrors;
    function GetLimboTransactionCount: Integer;
    function GetLimboTransactionMultiDatabase(const AIndex: Integer): Boolean;
    function GetLimboTransactionID(const AIndex: Integer): Integer;
    function GetLimboTransactionHostSite(const AIndex: Integer): string;
    function GetLimboTransactionRemoteSite(const AIndex: Integer): string;
    function GetLimboTransactionRemoteDatabasePath(const AIndex: Integer): string;
    function GetLimboTransactionState(const AIndex: Integer): string;
    function GetLimboTransactionAdvise(const AIndex: Integer): string;
    function GetLimboTransactionAction(const AIndex: Integer): string;

    function DisplayDatabaseOnline: Boolean;
    function DisplayDatabaseShutdown(const AModeIndex, ATimeout: Integer): Boolean;
    procedure SetPageBuffers(Value: Integer);
    procedure SetSQLDialect(Value: Integer);
    procedure SetSweepInterval(Value: Integer);
    procedure SetForcedWrites(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);

    function DisplayBackup(const ASourceFileList, ADestinationFileList: TStrings;
      const ATransportable, AMetadataOnly, ANoGarbageCollect, AIgnoreLimboTrans,
            AIgnoreChecksums, AOldMetadataDesc, AConvertExtTables, AVerbose: Boolean): Boolean;
    function DisplayRestore(const ASourceFileList, ADestinationFileList: TStrings;
      const APageSize: Integer;
      const AReplaceExisting, AMetadataOnly, ACommitEachTable, AWithoutShadow,
            ADeactivateIndexes, ANoValidityCheck, AUseAllSpace, AVerbose: Boolean): Boolean;

    property Active: Boolean read GetActive;
    property ServiceType: TibSHServiceType read GetServiceType;
    property ConnectProtocol: string read GetConnectProtocol write SetConnectProtocol;
    property ConnectPort: string read GetConnectPort write SetConnectPort;
    property ConnectLibraryName: string read GetConnectLibraryName write SetConnectLibraryName;
    property ConnectLoginPrompt: Boolean read GetConnectLoginPrompt write SetConnectLoginPrompt;
    property ConnectUser: string read GetConnectUser write SetConnectUser;
    property ConnectPassword: string read GetConnectPassword write SetConnectPassword;
    property ConnectRole: string read GetConnectRole write SetConnectRole;
    property ConnectServer: string read GetConnectServer write SetConnectServer;
    property ConnectDatabase: string read GetConnectDatabase write SetConnectDatabase;
  end;

  TibBTDRVSQLParser = class(TibBTDriver, IibSHDRVSQLParser)
  private
{$IFDEF  TRIFONOV}
    FFIBSQLParser: TpFIBSQLParser;
    FIsDataSQL: TList;
    FDDLCoord: TList;
    FDDLOperations: TStrings;
    FDDLObjectTypes: TStrings;
    FDDLObjectNames: TStrings;


{$ELSE}
    FScripter:TpFIBScripter;
{$ENDIF}
    FSQLParserNotification: IibSHDRVSQLParserNotification;



    vTmpStrings:TStringList;


{$IFDEF  TRIFONOV}
    procedure ClearCoord;
    procedure AddDDLCoord(ALeft, ATop, ARight, ABottom: Integer);
    procedure DDLReverseEngineering(Sender: TObject; AKind: TpFIBParseKind;const SQLText: string);
{$ENDIF}
  protected
{$IFDEF  TRIFONOV}
    property FIBSQLParser: TpFIBSQLParser read FFIBSQLParser;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    {IibSHDRVSQLParser}
    function GetScript: TStrings;
    function GetCount: Integer;
    function GetStatements(Index: Integer): string;
    function GetTerminator: string;
    procedure SetTerminator(const Value: string);
    function GetSQLParserNotification: IibSHDRVSQLParserNotification;
    procedure SetSQLParserNotification(Value: IibSHDRVSQLParserNotification);
    function Parse(const SQLText: string): Boolean; overload;
    function Parse: Boolean; overload;
    function StatementState(const Index: Integer): TSHDBComponentState;
    function StatementObjectType(const Index: Integer): TGUID;
    function StatementObjectName(const Index: Integer): string;
    function StatementsCoord(Index: Integer): TRect;
    function StatementOperationName(Index: Integer): string;
    function IsDataSQL(Index: Integer): Boolean;
  end;

  TibBTDRVPlayer = class(TibBTDriver, IibSHDRVPlayer)
  private
  {$IFDEF  TRIFONOV}
    FPlayer: TpFIBScript;
  {$ELSE}
    FPlayer:TpFIBScripter;
  {$ENDIF}
    FDRVDatabase: IibSHDRVDatabase;
    FDRVTransaction: IibSHDRVTransaction;
    FDRVSQLParser: IibSHDRVSQLParser;
    FDRVPlayerNotification: IibSHDRVPlayerNotification;
  protected
  {$IFDEF  TRIFONOV}
    procedure DoOnParse(Sender: TObject; AKind: TpFIBParseKind; const SQLText: string);
    procedure DoOnExecuteError(Sender: TObject; Error: string; SQLText: string;
      LineIndex: Integer; var Ignore: Boolean; var Action: TpFIBAfterError);
    procedure DoAfterExecute(Sender: TObject; AKind: TpFIBParseKind;
      ATokens: TStrings; ASQLText: string);
{$ELSE}
   procedure DoOnExecuteError(Sender: TObject; StatementNo: Integer;
    Line:Integer; Statement: TStrings; SQLCode: Integer; const Msg: string;
    var doRollBack:boolean;
    var Stop: Boolean);
   procedure DoOnStmntExecute(Sender: TObject;Line:Integer; StatementNo: Integer;  Desc:TStatementDesc;
    Statement: TStrings)    ;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    { IibSHDRVPlayer }
    function GetAutoDDL: Boolean;
    procedure SetAutoDDL(Value: Boolean);
    function GetScript: TStrings;
    function GetPaused: Boolean;
    procedure SetPaused(Value: Boolean);
    function GetDatabase: IibSHDRVDatabase;
    procedure SetDatabase(const Value: IibSHDRVDatabase);
    function GetTransaction: IibSHDRVTransaction;
    procedure SetTransaction(const Value: IibSHDRVTransaction);
    function GetSQLDialect: Integer;
    procedure SetSQLDialect(Value: Integer);
    function GetParser: IibSHDRVSQLParser;
    procedure SetParser(Value: IibSHDRVSQLParser);
    function GetPlayerNotification: IibSHDRVPlayerNotification;
    procedure SetPlayerNotification(Value: IibSHDRVPlayerNotification);
    function GetLineProceeding: Integer;
    function GetInputStringCount: Integer;
    function GetTerminator: string;
    procedure SetTerminator(const Value: string);
    procedure Execute;

  end;


  TibBTDRVStatistics = class(TibBTDriver, IibSHDRVStatistics)
  private
    FIdxReads: Integer;
    FSeqReads: Integer;
    FUpdates: Integer;
    FDeletes: Integer;
    FInserts: Integer;
    FFetches: Integer;
    FMarks: Integer;
    FReads: Integer;
    FWrites: Integer;
    FSnapshotTime: TDateTime;

    FDRVDatabase: IibSHDRVDatabase;
    FFIBDatabase: TpFIBDatabase;
    FTableStatistics: TibBTTableStatisticCalculator;
    function AllIdxReads: Integer;
    function AllSeqReads: Integer;
    function AllUpdates: Integer;
    function AllDeletes: Integer;
    function AllInserts: Integer;
  protected
    {IibSHDRVStatistics}
    function GetIdxReads: Integer;
    function GetSeqReads: Integer;
    function GetUpdates: Integer;
    function GetDeletes: Integer;
    function GetInserts: Integer;
    function GetAllFetches: Integer;
    function GetFetches: Integer;
    function GetAllMarks: Integer;
    function GetMarks: Integer;
    function GetAllReads: Integer;
    function GetReads: Integer;
    function GetAllWrites: Integer;
    function GetWrites: Integer;
    function GetTableStatistics(Index: Integer): IibSHDRVTableStatistics;
    function GetTablesCount: Integer;
    function GetSnapshotTime: TDateTime;
    function GetCurrentMemory: Integer;
    function GetMaxMemory: Integer;
    function GetNumBuffers: Integer;
    function GetDatabasePageSize: Integer;
    function GetDatabase: IibSHDRVDatabase;
    procedure SetDatabase(const Value: IibSHDRVDatabase);

    procedure StartCollection;
    procedure CalculateStatistics;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  end;

implementation

uses
  ibSHDesignIntf;

const
  SingularCheckSQL =
  'SELECT 1 FROM RDB$DATABASE D WHERE SINGULAR(%s)';
  SingularCheckSQLSubQuery =
  'SELECT %s.RDB$DB_KEY FROM %s';

{ TibBTDriver }

constructor TibBTDriver.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if not ErrorHandlerRegistered then
  begin
    FFIBError := TpFibErrorHandler.Create(nil);
    FFIBError.Options := [oeException, oeForeignKey, oeLostConnect, oeCheck, oeUniqueViolation];
    FFIBError.OnFIBErrorEvent := ErrorEvent;
  end;
end;

destructor TibBTDriver.Destroy;
begin
  FFIBError.Free;
  inherited Destroy;
end;

class function TibBTDriver.GetClassIIDClassFnc: TGUID;
begin
{$IFNDEF LONG_METADATA_NAMES}
  if Supports(Self, IibSHDRVDatabase) then Result := IibSHDRVDatabase_FIBPlus;
  if Supports(Self, IibSHDRVTransaction) then Result := IibSHDRVTransaction_FIBPlus;
  if Supports(Self, IibSHDRVQuery) then Result := IibSHDRVQuery_FIBPlus;
  if Supports(Self, IibSHDRVDataset) then Result := IibSHDRVDataset_FIBPlus;
  if Supports(Self, IibSHDRVMonitor) then Result := IibSHDRVMonitor_FIBPlus;
  if Supports(Self, IibSHDRVService) then Result := IibSHDRVService_FIBPLus;
  if Supports(Self, IibSHDRVSQLParser) then Result := IibSHDRVSQLParser_FIBPlus;
  if Supports(Self, IibSHDRVPlayer) then Result := IibSHDRVPlayer_FIBPlus;
  if Supports(Self, IibSHDRVStatistics) then Result := IibSHDRVStatistics_FIBPLus;
{$ELSE}
  if Supports(Self, IibSHDRVDatabase) then Result := IibSHDRVDatabase_FIBPlus68;
  if Supports(Self, IibSHDRVTransaction) then Result := IibSHDRVTransaction_FIBPlus68;
  if Supports(Self, IibSHDRVQuery) then Result := IibSHDRVQuery_FIBPlus68;
  if Supports(Self, IibSHDRVDataset) then Result := IibSHDRVDataset_FIBPlus68;
  if Supports(Self, IibSHDRVMonitor) then Result := IibSHDRVMonitor_FIBPlus68;
  if Supports(Self, IibSHDRVService) then Result := IibSHDRVService_FIBPLus68;
  if Supports(Self, IibSHDRVSQLParser) then Result := IibSHDRVSQLParser_FIBPlus68;
  if Supports(Self, IibSHDRVPlayer) then Result := IibSHDRVPlayer_FIBPlus68;
  if Supports(Self, IibSHDRVStatistics) then Result := IibSHDRVStatistics_FIBPLus68;
{$ENDIF}
//  if Supports(Self, IibSHDRVSQLParser) then Result := IibSHDRVSQLParser_IBX;
end;

function TibBTDriver.GetNativeDAC: TObject;
begin
  Result := FNativeDAC;
end;

procedure TibBTDriver.SetNativeDAC(Value: TObject);
begin
  FNativeDAC := Value;
end;

function TibBTDriver.GetErrorText: string;
begin
  Result := FErrorText;
end;

procedure TibBTDriver.SetErrorText(Value: string);
  function FormatErrorMessage(const E: string): string;
  const
    SignalStr = ':' + sLineBreak;
  var
    I: Integer;
  begin
    I := Pos(SignalStr, E);
    Result := E;
    if I > 0 then
      Delete(Result, 1, I + Length(SignalStr) - 1);
    Result := AnsiReplaceText(Result, SignalStr, '');
//    Result := AnsiReplaceText(Result, sLineBreak, ' ');
    if Pos('can''t format message', Result) > 0 then
    begin
      I := Pos('not found', Result);
      Result := Copy(Result, I + Length('not found.'), MaxInt);
    end;
  end;
begin
  FErrorText := FormatErrorMessage(Value);
end;

procedure TibBTDriver.ErrorEvent(Sender: TObject; ErrorValue: EFIBError;
  KindIBError: TKindIBError; var DoRaise: Boolean);
begin
  FLastErrorCode.SQLCode:=ErrorValue.SQLCode;
  FLastErrorCode.IBErrorCode:=ErrorValue.SQLCode;
  case KindIBError of
    keNoError, keException, keForeignKey: ;
    keLostConnect: DoRaise := False;
    keSecurity, keCheck, keUniqueViolation, keOther: ;
  end;
end;

function TibBTDriver.GetLastErrorCode: TibErrorCode;
begin
  Result:=FLastErrorCode
end;

{ TibBTDRVDatabase }

constructor TibBTDRVDatabase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFIBDatabase := TpFIBDatabase.Create(nil);
  NativeDAC := FFIBDatabase;

  FFIBDatabase.UseLoginPrompt := False;
  FFIBDatabase.AfterEndTransaction := EndTrEvent;
  FFIBDatabase.OnLostConnect := LostConnectEvent;
  FFIBDatabase.OnErrorRestoreConnect:= DoOnErrorRestoreConnect;
  FFIBDatabase.AfterDisconnect := DatabaseAfterDisconnect;
  FFIBDatabase.UseRepositories := [];
  FFIBDatabase.UseBlrToTextFilter:=True
end;

destructor TibBTDRVDatabase.Destroy;
begin
  FFIBDatabase.Free;
  inherited Destroy;
end;

procedure   CloseAllQueryHandles(EndingTR: TFIBTransaction) ;
var
 i:integer;
begin
  with EndingTR do
  for i :=0  to Pred(FIBBaseCount) do
  begin
    if (FIBBases[i].Owner is TFIBQuery) and (TFIBQuery(FIBBases[i].Owner).Tag=0) then
     TFIBQuery(FIBBases[i].Owner).FreeHandle
  end;
end;


procedure TibBTDRVDatabase.EndTrEvent(EndingTR: TFIBTransaction;
  Action: TTransactionAction; Force: Boolean);
begin
  if Action in [taCommit, taRollBack] then
   CloseAllQueryHandles(EndingTR);
end;

procedure TibBTDRVDatabase.DoOnErrorRestoreConnect(Database: TFIBDatabase; E: EFIBError; var Actions: TOnLostConnectActions);
begin
 ShowMessage('Restore Error '#13#10+ E.Message)
end;



procedure TibBTDRVDatabase.LostConnectEvent(Database: TFIBDatabase; E: EFIBError; var Actions: TOnLostConnectActions);
begin
  Actions := laIgnore;
//  Actions := laWaitRestore;
  if Assigned(FOnLostConnect) then FOnLostConnect(Self);
end;

function TibBTDRVDatabase.GetDatabase: string;
begin
  Result := FIBDatabase.DBName;
end;

procedure TibBTDRVDatabase.SetDatabase(Value: string);
begin
  FIBDatabase.DBName := Value;
end;

function TibBTDRVDatabase.GetCharset: string;
begin
  Result := FIBDatabase.ConnectParams.CharSet;
end;

procedure TibBTDRVDatabase.SetCharset(Value: string);
begin
  FIBDatabase.ConnectParams.CharSet := Value;
  //
//  ShowMessage(Value)
end;

function TibBTDRVDatabase.GetUserName: string;
begin
  Result := FIBDatabase.ConnectParams.UserName;
end;

procedure TibBTDRVDatabase.SetUserName(Value: string);
begin
  FIBDatabase.ConnectParams.UserName := Value;
end;

function TibBTDRVDatabase.GetPassword: string;
begin
  Result := FIBDatabase.ConnectParams.Password;
end;

procedure TibBTDRVDatabase.SetPassword(Value: string);
begin
  FIBDatabase.ConnectParams.Password := Value;
end;

function TibBTDRVDatabase.GetRoleName: string;
begin
  Result := FIBDatabase.ConnectParams.RoleName;
end;

procedure TibBTDRVDatabase.SetRoleName(Value: string);
begin
  FIBDatabase.ConnectParams.RoleName := Value;
end;

function TibBTDRVDatabase.GetLoginPrompt: Boolean;
begin
  Result := FIBDatabase.UseLoginPrompt;
end;

procedure TibBTDRVDatabase.SetLoginPrompt(Value: Boolean);
begin
  FIBDatabase.UseLoginPrompt := Value;
end;

function TibBTDRVDatabase.GetOnLostConnect: TNotifyEvent;
begin
  Result := FOnLostConnect;
end;

procedure TibBTDRVDatabase.SetOnLostConnect(Value: TNotifyEvent);
begin
  FOnLostConnect := Value;
end;

function TibBTDRVDatabase.GetDBParams: TStrings;
begin
  Result := FIBDatabase.DBParams;
end;

procedure TibBTDRVDatabase.SetDBParams(Value: TStrings);
begin
  FIBDatabase.DBParams.Assign(Value);
end;

function TibBTDRVDatabase.GetClientLibrary: string;
begin
  Result := FIBDatabase.LibraryName;
end;

procedure TibBTDRVDatabase.SetClientLibrary(Value: string);
begin
  FIBDatabase.LibraryName := Value;
end;

function TibBTDRVDatabase.GetSQLDialect: Integer;
begin
  Result := FIBDatabase.DBSQLDialect;
end;

procedure TibBTDRVDatabase.SetSQLDialect(Value: Integer);
begin
  FIBDatabase.SQLDialect := Value;
end;

function TibBTDRVDatabase.GetCapitalizeNames: Boolean;
begin
  Result := FIBDatabase.UpperOldNames;
end;

procedure TibBTDRVDatabase.SetCapitalizeNames(Value: Boolean);
begin
  FIBDatabase.UpperOldNames := Value;
end;

function TibBTDRVDatabase.GetConnected: Boolean;
begin
  Result := FIBDatabase.Connected;
end;

procedure TibBTDRVDatabase.SetConnected(Value: Boolean);
begin
  ErrorText := EmptyStr;
  try
    FIBDatabase.Connected := Value;
  except
    on E: Exception do
      ErrorText := E.Message;
  end;
end;

function TibBTDRVDatabase.GetUserNames: TStrings;
begin
  Result := FIBDatabase.UserNames;
end;

function TibBTDRVDatabase.GetODSVersion: string;
begin
  Result := Format('%d.%d', [FIBDatabase.ODSMajorVersion, FIBDatabase.ODSMinorVersion]);
end;

function TibBTDRVDatabase.GetPageSize: Integer;
begin
  Result := FIBDatabase.PageSize;
end;

function TibBTDRVDatabase.GetAllocationPages: Integer;
begin
  Result := FIBDatabase.Allocation;
end;

function TibBTDRVDatabase.GetPageBuffers: Integer;
begin
  Result := FIBDatabase.NumBuffers;
end;

function TibBTDRVDatabase.GetSweepInterval: Integer;
begin
  Result := FIBDatabase.SweepInterval;
end;

function TibBTDRVDatabase.GetForcedWrites: Boolean;
begin
  Result := FIBDatabase.ForcedWrites = 1;
end;

function TibBTDRVDatabase.GetReadOnly: Boolean;
begin
  Result := FIBDatabase.ReadOnly = 1;
end;

procedure TibBTDRVDatabase.DatabaseAfterDisconnect(Sender: TObject);
begin
  ListTableInfo.ClearForDataBase(FFIBDatabase);
  ListSPInfo.ClearSPInfo(FFIBDatabase);
end;

function TibBTDRVDatabase.Connect: Boolean;
begin
  Result := FIBDatabase.Connected;
  ErrorText := EmptyStr;
  try
    if not Result then
    begin
      FIBDatabase.Open;
      FIBDatabase.SQLDialect := FIBDatabase.DBSQLDialect;
      Result := FIBDatabase.Connected;
    end;
  except
    on E: Exception do
    begin
      ErrorText := E.Message;
      FIBDatabase.Connected := False;
      Result := FIBDatabase.Connected;
    end;
  end;
end;

type THackDB =class(TpFIBDatabase);

function TibBTDRVDatabase.Reconnect: Boolean;
begin
  THackDB(FFIBDatabase).CloseLostConnect;
//  FFIBDatabase.Connected:=False;
{  Disconnect;}
  Result := Connect;
end;

function TibBTDRVDatabase.Disconnect: Boolean;
begin
  Result := FIBDatabase.Connected;
  ErrorText := EmptyStr;
  try
    if Result then FIBDatabase.Close;
  except
    on E: Exception do
    begin
      ErrorText := E.Message;
      Result := not FIBDatabase.Connected;
    end;
  end;
end;

procedure TibBTDRVDatabase.CreateDatabase;
begin
  FIBDatabase.CreateDatabase;
end;

procedure TibBTDRVDatabase.DropDatabase;
begin
  FIBDatabase.DropDatabase;
end;

function TibBTDRVDatabase.TestConnection: Boolean;
begin
  Result := Connect;
  if Result then Disconnect;
end;

procedure TibBTDRVDatabase.ClearCache;
begin
  ListTableInfo.Clear;
  ListSPInfo.Clear;
end;

function TibBTDRVDatabase.GetRecordCountSelect(
  const ForSQL: string): string;
begin
 if Assigned(FIBDatabase) and FIBDatabase.IsFirebirdConnect and
  (FIBDatabase.ServerMajorVersion>=2)
 then
  Result:='Select Count(*) from ('+ForSQL+')'
 else
  if  (PosClause('DISTINCT',ForSQL)=0)
   and (PosClause('UNION',ForSQL)=0)
  then
   Result:=CountSelect(ForSQL)
  else
   Result:=''
end;

function TibBTDRVDatabase.IsFirebirdConnect: boolean;
begin
 if Assigned(FFIBDatabase) then
  Result:=FFIBDatabase.IsFirebirdConnect
 else
  Result:=False
end;

function TibBTDRVDatabase.IsTableOrView(const ObjectName: string): boolean;
begin
 if Assigned(FFIBDatabase) and FFIBDatabase.Connected then
   Result:=FFIBDatabase.QueryValue(
    'Select COUNT(*) from RDB$RELATIONS WHERE RDB$RELATION_NAME=:OName',0,
    [ObjectName]
   )>0
 else
  Result:=False
end;

{ TibBTDRVTransaction }

constructor TibBTDRVTransaction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFIBTransaction := TpFIBTransaction.Create(nil);
  NativeDAC := FFIBTransaction;

//  FFIBTransaction.TimeoutAction := TACommit;
  FFIBTransaction.TimeoutAction := TARollback;

  FFIBTransaction.TPBMode := tpbDefault;
  FFIBTransaction.TRParams.Clear;
  FFIBTransaction.TRParams.Add('write');
  FFIBTransaction.TRParams.Add('nowait');
  FFIBTransaction.TRParams.Add('rec_version');
  FFIBTransaction.TRParams.Add('read_committed');
  FFIBTransaction.AfterEnd := DoEndTrEvent;
end;

destructor TibBTDRVTransaction.Destroy;
begin
  FFIBTransaction.AfterEnd := nil;
  FFIBTransaction.Free;
  inherited Destroy;
end;

function TibBTDRVTransaction.GetDatabase: IibSHDRVDatabase;
begin
  Result := FDRVDatabase;
end;

procedure TibBTDRVTransaction.SetDatabase(const Value: IibSHDRVDatabase);
begin
  if FDRVDatabase <> Value then
  begin
//    if Assigned(FDRVDatabase) then FDRVDatabase := nil;
    ReferenceInterface(FDRVDatabase, opRemove);
    FDRVDatabase := Value;
    ReferenceInterface(FDRVDatabase, opInsert);
    if Assigned(Value) then
      FIBTransaction.DefaultDatabase := TpFIBDatabase(Value.GetNativeDAC)
    else
      FIBTransaction.DefaultDatabase := nil;
  end;
end;

function TibBTDRVTransaction.GetParams: TStrings;
begin
  Result := FFIBTransaction.TRParams;
end;

procedure TibBTDRVTransaction.SetParams(Value: TStrings);
begin
  FFIBTransaction.TRParams.Assign(Value);
end;

function TibBTDRVTransaction.GetTransactionNotification: IibSHDRVTransactionNotification;
begin
  Result := FTransactionNotification;
end;

procedure TibBTDRVTransaction.SetTransactionNotification(
  Value: IibSHDRVTransactionNotification);
begin
  if FTransactionNotification <> Value then
  begin
    ReferenceInterface(FTransactionNotification, opRemove);
    FTransactionNotification := Value;
    ReferenceInterface(FTransactionNotification, opInsert);
  end;
end;

procedure TibBTDRVTransaction.DoEndTrEvent(EndingTR: TFIBTransaction;
  Action: TTransactionAction; Force: Boolean);
var
  DRVTrAction: TibSHTransactionAction;
begin
  if Assigned(FTransactionNotification) then
  begin
    if Action in [TARollback, TARollbackRetaining] then
      DRVTrAction := shtaRollback
    else
      DRVTrAction := shtaCommit;
    FTransactionNotification.AfterEndTransaction(Self as IibSHDRVTransaction, DRVTrAction);
  end;
end;

procedure TibBTDRVTransaction.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent.IsImplementorOf(FDRVDatabase) then
    begin
      FDRVDatabase := nil;
      FIBTransaction.DefaultDatabase := nil;
    end else
    if AComponent.IsImplementorOf(FTransactionNotification) then FTransactionNotification := nil;
  end;
end;

function TibBTDRVTransaction.InTransaction: Boolean;
begin
  Result := FIBTransaction.InTransaction;
end;

procedure TibBTDRVTransaction.StartTransaction;
begin
  if Assigned(Database) and Database.Connected and not InTransaction then
    FIBTransaction.StartTransaction;
end;

function TibBTDRVTransaction.Commit: Boolean;
begin
  Result := Assigned(Database) and Database.Connected and InTransaction;
  ErrorText := EmptyStr;
  try
    if Result then FIBTransaction.Commit;
  except
    on E: Exception do
    begin
      ErrorText := E.Message;
      Result := False;
    end;
  end;
end;

function TibBTDRVTransaction.CommitRetaining: Boolean;
begin
  Result := Assigned(Database) and Database.Connected and InTransaction;
  ErrorText := EmptyStr;
  try
    if Result then FIBTransaction.CommitRetaining;
  except
    on E: Exception do
    begin
      ErrorText := E.Message;
      Result := False;
    end;
  end;
end;

function TibBTDRVTransaction.Rollback: Boolean;
begin
  Result := Assigned(Database) and Database.Connected and InTransaction;
  ErrorText := EmptyStr;
  try
    if Result then FIBTransaction.Rollback;
  except
    on E: Exception do
    begin
      ErrorText := E.Message;
      Result := False;
    end;
  end;
end;

function TibBTDRVTransaction.RollbackRetaining: Boolean;
begin
  Result := Assigned(Database) and Database.Connected and InTransaction;
  ErrorText := EmptyStr;  
  try
    if Result then FIBTransaction.RollbackRetaining;
  except
    on E: Exception do
    begin
      ErrorText := E.Message;
      Result := False;
    end;
  end;
end;

{ TibBTDRVQuery }

constructor TibBTDRVQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFIBQuery := TFIBQuery.Create(nil);
  NativeDAC := FFIBQuery;

  FFIBQuery.Options := [{qoStartTransaction, }qoTrimCharFields];
end;

destructor TibBTDRVQuery.Destroy;
begin
 if FFIBQuery.Tag=0 then
  FFIBQuery.Free
 else
  FreeQueryForUse(FFIBQuery);

//  FFIBQuery.Free;
  inherited Destroy;
end;

function TibBTDRVQuery.GetDatabase: IibSHDRVDatabase;
begin
  Result := FDRVDatabase;
end;

procedure TibBTDRVQuery.SetDatabase(const Value: IibSHDRVDatabase);
begin
  if FDRVDatabase <> Value then
  begin
//    if Assigned(FDRVDatabase) then FDRVDatabase := nil;
    ReferenceInterface(FDRVDatabase, opRemove);
    FDRVDatabase := Value;
    ReferenceInterface(FDRVDatabase, opInsert);
    if Assigned(Value) then
      FIBQuery.Database := TpFIBDatabase(Value.GetNativeDAC)
    else
      FIBQuery.Database := nil;
  end;
end;

function TibBTDRVQuery.GetTransaction: IibSHDRVTransaction;
begin
  Result := FDRVTransaction;
end;

procedure TibBTDRVQuery.SetTransaction(const Value: IibSHDRVTransaction);
begin
  if FDRVTransaction <> Value then
  begin
    if Assigned(FDRVTransaction) then FDRVTransaction := nil;
    ReferenceInterface(FDRVTransaction, opRemove);
    FDRVTransaction := Value;
    ReferenceInterface(FDRVTransaction, opInsert);
    if Assigned(Value) then
      FIBQuery.Transaction := TpFIBTransaction(Value.GetNativeDAC)
    else
      FIBQuery.Transaction := nil;
  end;
end;

function TibBTDRVQuery.GetSQL: TStrings;
begin
  Result := FIBQuery.SQL;
end;

procedure TibBTDRVQuery.SetSQL(Value: TStrings);
begin
 if FIBQuery.Tag=0 then
  FIBQuery.SQL.Assign(Value)
 else
 begin
     FreeQueryForUse(FIBQuery);
     FFIBQuery := TFIBQuery.Create(nil);
     FIBQuery.Database    := TpFIBDatabase(FDRVDatabase.GetNativeDAC);
     FIBQuery.Transaction := TpFIBTransaction(FDRVTransaction.GetNativeDAC);
     NativeDAC := FFIBQuery;
 end;

//  FIBQuery.SQL.Assign(Value);
end;

function TibBTDRVQuery.GetParamCheck: Boolean;
begin
  Result := FIBQuery.ParamCheck;
end;

procedure TibBTDRVQuery.SetParamCheck(Value: Boolean);
begin
  FIBQuery.ParamCheck := Value;
end;

function TibBTDRVQuery.GetPlan: string;
begin
  Result := EmptyStr;
  if Assigned(Database) and Database.Connected then
  begin
    ErrorText := EmptyStr;
    try
      Result := FIBQuery.Plan;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        Result := EmptyStr;
      end;
    end;
  end;
end;

function TibBTDRVQuery.GetActive: Boolean;
begin
  Result := FIBQuery.Open;
end;

function TibBTDRVQuery.GetBof: Boolean;
begin
  Result := FIBQuery.Bof;
end;

function TibBTDRVQuery.GetEof: Boolean;
begin
  Result := FIBQuery.Eof;
end;

function TibBTDRVQuery.GetPrepared: Boolean;
begin
  Result := FIBQuery.Prepared;
end;

function TibBTDRVQuery.GetParamByIndex(Index: Integer): Variant;
begin
  if (Index >= 0) and (Index < ParamCount) then
    Result := FIBQuery.Params[Index].Value
  else
    VarClear(Result);
end;

procedure TibBTDRVQuery.SetParamByIndex(Index: Integer; Value: Variant);
begin
  if (Index >= 0) and (Index < ParamCount) then
    FIBQuery.Params[Index].Value := Value;
end;

function TibBTDRVQuery.GetParamIsNull(Index: Integer): Boolean;
begin
  Result := True;
  if (Index >= 0) and (Index < ParamCount) then
    Result := FIBQuery.Params[Index].IsNull;
end;

procedure TibBTDRVQuery.SetParamIsNull(Index: Integer; Value: Boolean);
begin
  if (Index >= 0) and (Index < ParamCount) then
    FIBQuery.Params[Index].IsNull := Value;
end;

function TibBTDRVQuery.GetParamCount: Integer;
begin
  Result := FIBQuery.Params.Count;
end;

function TibBTDRVQuery.GetPrepareTime: Cardinal;
begin
  Result := FPrepareTime;
end;

function TibBTDRVQuery.GetExecuteTime: Cardinal;
begin
  Result := FIBQuery.CallTime;
end;

function TibBTDRVQuery.GetFetchTime: Cardinal;
begin
  Result := 0;
end;

procedure TibBTDRVQuery.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent.IsImplementorOf(FDRVDatabase) then FDRVDatabase := nil
    else
    if AComponent.IsImplementorOf(FDRVTransaction) then FDRVTransaction := nil;
  end;
end;

function TibBTDRVQuery.ParamExists(const ParamName: string): Boolean;
begin
  Result := FIBQuery.FindParam(ParamName) <> nil;
end;

function TibBTDRVQuery.ParamName(ParamNo: Integer): string;
begin
  if (ParamNo >= 0) and (ParamNo < ParamCount) then
    Result := FIBQuery.Params[ParamNo].Name
  else
    Result := EmptyStr;
end;

function TibBTDRVQuery.GetParamSize(const ParamName: string): Integer;
begin
  if ParamExists(ParamName) then
    Result := FIBQuery.ParamByName(ParamName).Size
  else
    Result := 0;
end;

function TibBTDRVQuery.GetParamSize(ParamNo: Integer): Integer;
begin
  if (ParamNo >= 0) and (ParamNo < ParamCount) then
    Result := FIBQuery.Params[ParamNo].Size
  else
    Result := 0;
end;

function TibBTDRVQuery.GetParamByName(const ParamName: string): Variant;
begin
  if ParamExists(ParamName) then
    Result := FIBQuery.ParamByName(ParamName).Value
  else
    VarClear(Result);
end;

procedure TibBTDRVQuery.SetParamByName(const ParamName: string; Value: Variant);
begin
  if ParamExists(ParamName) then
    FIBQuery.ParamByName(ParamName).Value := Value;
end;

function TibBTDRVQuery.ExecSQL(const SQLText: string; const AParams: array of Variant; AutoCommit: Boolean;KeepPrepared:boolean=False): Boolean;
var
  i: Integer;
  OldParamCheck: Boolean;
  FIBParser: TSQLParser;
begin
  FIBParser := TSQLParser.Create(SQLText);
  try
    Self.Close;
   if not KeepPrepared then
   begin
    if Assigned(FIBQuery) then
    if FIBQuery.Tag>0 then // Препарнутая
    begin
     FreeQueryForUse(FIBQuery);
     FFIBQuery := TFIBQuery.Create(nil);
     FIBQuery.Database    := TpFIBDatabase(FDRVDatabase.GetNativeDAC);
     FIBQuery.Transaction := TpFIBTransaction(FDRVTransaction.GetNativeDAC);
     NativeDAC := FFIBQuery;
    end ;
    with FIBQuery do
    begin
      Options := [qoTrimCharFields];    
      OldParamCheck := ParamCheck;
      if Length(SQLText) > 0 then
      begin
        ParamCheck := FIBParser.SQLKind <> skDDL;
        if (OldParamCheck <> ParamCheck) or (SQL.Text <> SQLText) then
        begin
          SQL.Clear;
          Params.Count := 0;
          SQL.Text := SQLText;
        end;
      end;
    end;
   end
   else
   begin
    if Assigned(FIBQuery) then
     if FIBQuery.Tag=0 then
      FIBQuery.Free
     else
      FreeQueryForUse(FFIBQuery);
     FFIBQuery:=GetQueryForUse(TFIBTransaction(FDRVTransaction.GetNativeDAC),SQLText);
     FFIBQuery.Options := [qoTrimCharFields];
     FFIBQuery.Tag:=1;
     NativeDAC := FFIBQuery;
   end;


    with FIBQuery do
    begin
      Self.Transaction.StartTransaction;

//      if Pred(Params.Count) > High(AParams) then
//      begin
//        ErrorText := Format('Number of parameters less than needed', []);
//        Result := False;
//        raise Exception.Create(ErrorText);
//      end;


      if Length(AParams) > 0 then
      begin
        for I := 0 to Pred(Params.Count) do
          if (I >= Low(AParams)) and (I <= High(AParams)) then
            Params[I].AsVariant := AParams[I];
      end;
      Result := Self.Execute;

      if Result then
      begin
        // Result := Open;
        if AutoCommit then
        begin
          Close;
          try
            if Transaction.InTransaction then Transaction.Commit;
            Result := True;
          except
            on E: Exception do
            begin
              ErrorText := E.Message;
              Result := False;
              Transaction.Active := False;
            end;
          end;
        end;
      end;// else
//        if Transaction.InTransaction then Transaction.Commit;
    end;
  finally
   if FIBQuery.Tag=0 then
    ParamCheck := OldParamCheck;
    FIBParser.Free;
  end;
end;

function TibBTDRVQuery.Prepare: Boolean;
begin
  Result := Assigned(Database) and Database.Connected;
  try
    if Result and not FIBQuery.Prepared then
    begin
      ErrorText := EmptyStr;
      FPrepareTime := GetTickCount;
      FIBQuery.Prepare;
      FPrepareTime := GetTickCount - FPrepareTime;
    end;
  except
    on E: Exception do
    begin
      ErrorText := E.Message;
      Result := False;
      FPrepareTime := 0;
    end;
  end;
end;

function TibBTDRVQuery.Execute: Boolean;
begin
  Result := Assigned(Database) and Database.Connected and Self.Prepare;
  try
    if Result then
    begin
      ErrorText := EmptyStr;
      FIBQuery.ExecQuery;
    end;
  except
    on E: Exception do
    begin
      if E is EFIBError then
      begin
       FLastErrorCode.SQLCode:=EFIBError(E).SQLCode;
       FLastErrorCode.IBErrorCode:=EFIBError(E).IBErrorCode;       
      end; 
      ErrorText := E.Message;
      Self.Close;
      Result := False;
    end;
  end;
end;

procedure TibBTDRVQuery.Next;
begin
  if Assigned(Database) and Database.Connected then
    FIBQuery.Next;
end;

procedure TibBTDRVQuery.Close;
begin
  if Assigned(Database) and Database.Connected and FIBQuery.Open then
  begin
     FFIBQuery.Close;
     if FFIBQuery.Tag>0 then
     begin
      FreeQueryForUse(FFIBQuery);
      FFIBQuery := TFIBQuery.Create(nil);
      FIBQuery.Database    := TpFIBDatabase(FDRVDatabase.GetNativeDAC);
      FIBQuery.Transaction := TpFIBTransaction(FDRVTransaction.GetNativeDAC);
      NativeDAC := FFIBQuery;
     end
  end
end;

function TibBTDRVQuery.FieldExists(const FieldName: string): Boolean;
begin
  Result := FIBQuery.FieldIndex[FieldName] >= 0;
end;

function TibBTDRVQuery.FieldName(FieldNo: Integer): string;
begin
  if (FieldNo >= 0) and (FieldNo < FIBQuery.FieldCount) then
    Result := FIBQuery.Fields[FieldNo].Name
  else
    Result := '';
end;

function TibBTDRVQuery.FieldIsBlob(FieldNo: Integer): Boolean;
begin
  if (FieldNo >= 0) and (FieldNo < FIBQuery.FieldCount) then
    Result := FIBQuery.Fields[FieldNo].IsBlob
  else
    Result := False;
end;

function TibBTDRVQuery.GetFieldValue(const FieldName: string): Variant;
begin
  if FieldExists(FieldName) then
    Result := FIBQuery.FieldByName(FieldName).Value
  else
    VarClear(Result);
end;

function TibBTDRVQuery.GetFieldValue(FieldNo: Integer): Variant;
begin
  if (FieldNo >= 0) and (FieldNo < FIBQuery.FieldCount) then
    Result := FIBQuery.Fields[FieldNo].Value
  else
    VarClear(Result);
end;

function TibBTDRVQuery.GetFieldStrValue(const FieldName: string): string;
begin
  if FieldExists(FieldName) then
    Result := FIBQuery.FieldByName(FieldName).AsString
  else
    Result := EmptyStr;
end;

function TibBTDRVQuery.GetFieldStrValue(FieldNo: Integer): string;
begin
  if (FieldNo >= 0) and (FieldNo < FIBQuery.FieldCount) then
    Result := FIBQuery.Fields[FieldNo].AsString
  else
    Result := EmptyStr;
end;

function TibBTDRVQuery.GetFieldIntValue(const FieldName: string): Integer;
begin
  if FieldExists(FieldName) then
    Result := FIBQuery.FieldByName(FieldName).AsInteger
  else
    Result := 0;
end;

function TibBTDRVQuery.GetFieldIntValue(FieldNo: Integer): Integer;
begin
  if (FieldNo >= 0) and (FieldNo < FIBQuery.FieldCount) then
    Result := FIBQuery.Fields[FieldNo].AsInteger
  else
    Result := 0;
end;

function TibBTDRVQuery.GetFieldInt64Value(const FieldName: string): Int64;
begin
  if FieldExists(FieldName) then
    Result := FIBQuery.FieldByName(FieldName).AsInt64
  else
    Result := 0;
end;

function TibBTDRVQuery.GetFieldInt64Value(FieldNo: Integer): Int64;
begin
  if (FieldNo >= 0) and (FieldNo < FIBQuery.FieldCount) then
    Result := FIBQuery.Fields[FieldNo].AsInt64
  else
    Result := 0;
end;

function TibBTDRVQuery.GetFieldFloatValue(const FieldName: string): Double;
begin
  if FieldExists(FieldName) then
    Result := FIBQuery.FieldByName(FieldName).AsFloat
  else
    Result := 0;
end;

function TibBTDRVQuery.GetFieldFloatValue(FieldNo: Integer): Double;
begin
  if (FieldNo >= 0) and (FieldNo < FIBQuery.FieldCount) then
    Result := FIBQuery.Fields[FieldNo].AsFloat
  else
    Result := 0;
end;

function TibBTDRVQuery.GetFieldIsNull(const FieldName: string): Boolean;
begin
  if FieldExists(FieldName) then
    Result := FIBQuery.FieldByName(FieldName).IsNull
  else
    Result := True;
end;

function TibBTDRVQuery.GetFieldIsNull(FieldNo: Integer): Boolean;
begin
  if (FieldNo >= 0) and (FieldNo < FIBQuery.FieldCount) then
    Result := FIBQuery.Fields[FieldNo].IsNull
  else
    Result := True;
end;

function TibBTDRVQuery.GetFieldSize(const FieldName: string): Integer;
begin
  if FieldExists(FieldName) then
    Result := FIBQuery.FieldByName(FieldName).Size
  else
    Result := 0;
end;

function TibBTDRVQuery.GetFieldSize(FieldNo: Integer): Integer;
begin
  if (FieldNo >= 0) and (FieldNo < FIBQuery.FieldCount) then
    Result := FIBQuery.Fields[FieldNo].Size
  else
    Result := 0;
end;

function TibBTDRVQuery.GetFieldCount: Integer;
begin
  Result := FIBQuery.FieldCount;
end;

 //IBTDynamicMethod
function TibBTDRVQuery.DynMethodExec(const MethodName: string;
  const Args: array of Variant): Variant;
var
   ar:TAllRowsAffected;
begin
  VarClear(Result);
  if (Length(MethodName)>0) and Assigned(FFIBQuery) then
  case MethodName[1] of
   'F' :if MethodName='FETCH_FIRST_RECORD' then
          FFIBQuery.GoToFirstRecordOnExecute:=Args[0];

   'R': if MethodName='ROWS_AFFECTED' then
        begin
          ar    :=FFIBQuery.AllRowsAffected;
          case FFIBQuery.SQLType of
           SQLSelect:Result := ar.Selects;
          else
           Result:=ar.Updates+ar.Deletes+ar.Inserts
          end
        end;
   'S': if MethodName='SETCURSORNAME' then
        begin
          FFIBQuery.CursorName:=Args[0]
        end;
  end
end;

//type TDynArray = array of Variant;

function TibBTDRVQuery.DynMethodExecOut(const MethodName: string;
  const Args: array of Variant; var Results: TDynMethodResults): Variant;
begin
  if (Length(MethodName)>0) and Assigned(FFIBQuery) then
  case MethodName[1] of
   'F' :if MethodName='FETCH_FIRST_RECORD' then
          FFIBQuery.GoToFirstRecordOnExecute:=Args[0];
   'R': if MethodName='ROWS_AFFECTED' then
        begin
          SetLength(Results,1);
          Results[0]:=FFIBQuery.RowsAffected
        end;
   'S': if MethodName='SETCURSORNAME' then
        begin
          SetLength(Results,1);        
          FFIBQuery.CursorName:=Args[0]
        end;
  end
end;

function TibBTDRVQuery.DynMethodExist(const MethodName: string): boolean;
begin
   Result:=False;
   if Length(MethodName)>0 then
   case MethodName[1] of
    'F':Result:= MethodName='FETCH_FIRST_RECORD';
    'R':Result:= MethodName='ROWS_AFFECTED';
    'S':Result:= MethodName='SETCURSORNAME';
   end
end;

 //end IBTDynamicMethod
 
function TibBTDRVQuery.GetDebugFieldValue(Index: integer): Variant;
var
  FReservedBuffer:string;
begin
  if Assigned(FFIBQuery) and (FFIBQuery.FieldCount>Index) then
  with FFIBQuery do
  case Fields[Index].SQLType of
   SQL_TEXT:  if Fields[Index].SqlName='DB_KEY' then
              begin
                 SetString(FReservedBuffer,Fields[Index].Data.sqldata,Fields[Index].Size);
                 Result:=FReservedBuffer;
              end
              else
                 Result:=Fields[Index].Value;
  else
    Result:=Fields[Index].Value
  end
  else
   VarClear(Result)
end;

{ TBTpFIBDataset }

function TBTpFIBDataset.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if IsEqualGUID(IID, IibSHDRVDataset) then
  begin
    if Supports(Owner, IibSHDRVDataset, Obj) then
      Result := S_OK
    else
      Result := E_NOINTERFACE;
  end else
    Result := inherited QueryInterface(IID, Obj);
end;

{ TibBTDRVDataset }

constructor TibBTDRVDataset.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  FFIBDataset := TpFIBDataset.Create(nil);
  FFIBDataset := TBTpFIBDataset.Create(Self);
  FFIBDataset.SQLScreenCursor := crHourGlass;

  NativeDAC := FFIBDataset;

  FFIBDataset.AutoCommit := True;
  FFIBDataset.AutoUpdateOptions.CanChangeSQLs := True;
  FFIBDataset.AutoUpdateOptions.WhenGetGenID := wgNever;
  FFIBDataset.AutoUpdateOptions.AutoReWriteSqls := True;
  FFIBDataset.AutoUpdateOptions.UpdateOnlyModifiedFields := True;
  FFIBDataset.DetailConditions := [];
  FFIBDataset.Options := [poTrimCharFields, poRefreshAfterPost, poStartTransaction, poNoForceIsNull];
  FFIBDataset.PrepareOptions := [pfImportDefaultValues, psUseLargeIntField];
  FDataModified := False;

  FFIBDataset.BeforeFetchRecord := BeforeFetchRecord;
  FFIBDataset.AfterFetchRecord := AfterFetchRecord;

  FFIBDataset.AfterClose := AfterCloseDataset; 
  FFIBDataset.AfterOpen := AfterOpenDataset;
  FFIBDataset.AfterDelete := AfterDeleteDataset;
  FFIBDataset.AfterInsert := AfterInsertDataset;
  FFIBDataset.AfterPost := AfterPost;
  FFIBDataset.BeforePost := BeforePost;
  FFIBDataset.BeforeDelete := BeforeDelete;
  FFIBDataset.TransactionEnded := TransactionEnded;

  FFIBDataset.OnDeleteError := DoOnAnyError;
  FFIBDataset.OnEditError := DoOnAnyError;
  FFIBDataset.OnLockError := DoOnLockError;
  FFIBDataset.OnPostError := DoOnAnyError;
  FFIBDataset.OnUpdateError := DoOnUpdateError;

  FNeedMultyUpdateCheck := False;
  FRevertToDB_KEY := False;
end;

destructor TibBTDRVDataset.Destroy;
begin
  FFIBDataset.Free;
  inherited Destroy;
end;

function TibBTDRVDataset.IsMultiRecordsAffect(ASQLText: string): Boolean;
var
  SQLText: string;
  SQLSubText: string;
  S: string;
  StartPos, EndPos: Integer;
  I: Integer;
  vQuery: TFIBQuery;
  vTableName: string;
begin
  Result := False;
  if (Length(ASQLText) > 0) then
  begin
    S := GetWhereClause(ASQLText, 1, StartPos, EndPos);
    vTableName :=
      EasyFormatIdentifier(FIBDataset.Database.SQLDialect,
                           FIBDataset.AutoUpdateOptions.UpdateTableName,
                           FIBDataset.Database.EasyFormatsStr);
    SQLSubText := Format(SingularCheckSQLSubQuery, [vTableName, vTableName]);
    if Length(S) > 0 then
      SQLSubText := AddToWhereClause(SQLSubText, S);
    SQLText := Format(SingularCheckSQL, [SQLSubText]);
    vQuery := TFIBQuery.Create(nil);
    try
      vQuery.Database := FIBDataset.Database;
      vQuery.Transaction := FIBDataset.Transaction;
      vQuery.Options := [qoStartTransaction];
      vQuery.SQL.Text := SQLText;
      for I := 0 to vQuery.Params.Count - 1 do
      begin
        S := vQuery.Params[I].Name;
        Delete(S, 1, 4);
        vQuery.Params[I].Value := FIBDataset.FieldByName(S).OldValue;
      end;
      vQuery.ExecQuery;
      Result := vQuery.Fields[0].AsInteger <> 1;
    finally
      vQuery.Free;
    end;
  end;
end;

function TibBTDRVDataset.GetActive: Boolean;
begin
  Result := FIBDataset.Active
end;

procedure TibBTDRVDataset.SetActive(Value: Boolean);
begin
  FIBDataset.Active := True;
end;

function TibBTDRVDataset.GetAutoCommit: Boolean;
begin
  Result := FIBDataset.AutoCommit;
end;

procedure TibBTDRVDataset.SetAutoCommit(Value: Boolean);
begin
  FIBDataset.AutoCommit := Value;
end;

function TibBTDRVDataset.GetDatabase: IibSHDRVDatabase;
begin
  Result := FDRVDatabase;
end;

procedure TibBTDRVDataset.SetDatabase(const Value: IibSHDRVDatabase);
begin
  if FDRVDatabase <> Value then
  begin
//    if Assigned(FDRVDatabase) then FDRVDatabase := nil;
    ReferenceInterface(FDRVDatabase, opRemove);
    FDRVDatabase := Value;
    ReferenceInterface(FDRVDatabase, opInsert);
    if Assigned(Value) then
      FIBDataset.Database := TpFIBDatabase(Value.GetNativeDAC)
    else
      FIBDataset.Database := nil;
  end;
end;

function TibBTDRVDataset.GetReadTransaction: IibSHDRVTransaction;
begin
  Result := FDRVReadTransaction;
end;

procedure TibBTDRVDataset.SetReadTransaction(const Value: IibSHDRVTransaction);
begin
  if FDRVReadTransaction <> Value then
  begin
    if Assigned(FDRVReadTransaction) then FDRVReadTransaction := nil;
    ReferenceInterface(FDRVReadTransaction, opRemove);
    FDRVReadTransaction := Value;
    ReferenceInterface(FDRVReadTransaction, opInsert);
    if Assigned(Value) then
      FIBDataset.Transaction := TpFIBTransaction(Value.GetNativeDAC)
    else
      FIBDataset.Transaction := nil;
  end;
end;

function TibBTDRVDataset.GetWriteTransaction: IibSHDRVTransaction;
begin
  Result := FDRVWriteTransaction;
end;

procedure TibBTDRVDataset.SetWriteTransaction(const Value: IibSHDRVTransaction);
begin
  if FDRVWriteTransaction <> Value then
  begin
    if Assigned(FDRVWriteTransaction) then FDRVWriteTransaction := nil;
    ReferenceInterface(FDRVWriteTransaction, opRemove);
    FDRVWriteTransaction := Value;
    ReferenceInterface(FDRVWriteTransaction, opInsert);
    if Assigned(Value) then
      FIBDataset.UpdateTransaction := TpFIBTransaction(Value.GetNativeDAC)
    else
      FIBDataset.UpdateTransaction := nil;
  end;
end;

function TibBTDRVDataset.GetSelectSQL: TStrings;
begin
  Result := FIBDataset.SelectSQL;
end;

procedure TibBTDRVDataset.SetSelectSQL(Value: TStrings);
begin
  FIBDataset.InsertSQL.Assign(Value);
end;

function TibBTDRVDataset.GetInsertSQL: TStrings;
begin
  Result := FIBDataset.InsertSQL;
end;

procedure TibBTDRVDataset.SetInsertSQL(Value: TStrings);
begin
  FIBDataset.InsertSQL.Assign(Value);
end;

function TibBTDRVDataset.GetUpdateSQL: TStrings;
begin
  Result := FIBDataset.UpdateSQL;
end;

procedure TibBTDRVDataset.SetUpdateSQL(Value: TStrings);
begin
  FIBDataset.UpdateSQL.Assign(Value);
end;

function TibBTDRVDataset.GetDeleteSQL: TStrings;
begin
  Result := FIBDataset.DeleteSQL;
end;

procedure TibBTDRVDataset.SetDeleteSQL(Value: TStrings);
begin
  FIBDataset.DeleteSQL.Assign(Value);
end;

function TibBTDRVDataset.GetRefreshSQL: TStrings;
begin
  Result := FIBDataset.RefreshSQL;
end;

procedure TibBTDRVDataset.SetRefreshSQL(Value: TStrings);
begin
  FIBDataset.RefreshSQL.Assign(Value);
end;

function TibBTDRVDataset.GetDataset: TDataset;
begin
  Result := FIBDataset;
end;

function TibBTDRVDataset.GetPlan: string;
begin
  Result := EmptyStr;
  if Assigned(Database) and Database.Connected then
  begin
    ErrorText := EmptyStr;
    try
      Result := FIBDataset.QSelect.Plan;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        Result := EmptyStr;
      end;
    end;
  end;
end;

function TibBTDRVDataset.GetDataModified: Boolean;
begin
  Result := FDataModified;
end;

function TibBTDRVDataset.GetIsFetching: Boolean;
begin
  Result := FIsFetching;
end;

procedure TibBTDRVDataset.SetIsFetching(Value: Boolean);
begin
  if (not Value) and FIsFetching  then
    FForceStopFetch := True;
end;

function TibBTDRVDataset.GetIsEmpty: Boolean;
begin
  Result := FIBDataset.IsEmpty;
end;

function TibBTDRVDataset.GetFilter: string;
begin
  Result := FIBDataset.Filter;
end;

procedure TibBTDRVDataset.SetFilter(Value: string);
begin
  FIBDataset.Filter := Value;
  FIBDataset.Filtered := Length(FIBDataset.Filter) > 0;
end;

function TibBTDRVDataset.GetDatasetNotification: IibDRVDatasetNotification;
begin
  Result := FDatasetNotification;
end;

procedure TibBTDRVDataset.SetDatasetNotification(
  Value: IibDRVDatasetNotification);
begin
  if FDatasetNotification <> Value then
  begin
    ReferenceInterface(FDatasetNotification, opRemove);
    FDatasetNotification := Value;
    ReferenceInterface(FDatasetNotification, opInsert);
  end;
end;

function TibBTDRVDataset.GetPrepared: Boolean;
begin
  Result := FIBDataset.Prepared;
end;

function TibBTDRVDataset.GetPrepareTime: Cardinal;
begin
  Result := FPrepareTime;
end;

function TibBTDRVDataset.GetExecuteTime: Cardinal;
begin
//  Result := FIBDataset.QSelect.CallTime;
  Result := FExecuteTime;
end;

function TibBTDRVDataset.GetFetchTime: Cardinal;
begin
  Result := FFetchTime;
end;

function TibBTDRVDataset.GetParamByIndex(Index: Integer): Variant;
begin
  if (Index >= 0) and (Index < ParamCount) then
    Result := FIBDataset.Params[Index].Value
  else
    VarClear(Result);
end;

procedure TibBTDRVDataset.SetParamByIndex(Index: Integer; Value: Variant);
begin
  if (Index >= 0) and (Index < ParamCount) then
    FIBDataset.Params[Index].Value := Value;
end;

function TibBTDRVDataset.GetParamIsNull(Index: Integer): Boolean;
begin
  Result := True;
  if (Index >= 0) and (Index < ParamCount) then
    Result := FIBDataset.Params[Index].IsNull;
end;

procedure TibBTDRVDataset.SetParamIsNull(Index: Integer; Value: Boolean);
begin
  if (Index >= 0) and (Index < ParamCount) then
    FIBDataset.Params[Index].IsNull := Value;
end;

function TibBTDRVDataset.GetParamCount: Integer;
begin
  Result := FIBDataset.Params.Count;
end;

procedure TibBTDRVDataset.BeforeFetchRecord(FromQuery: TFIBQuery;
  RecordNumber: Integer; var StopFetching: Boolean);
begin
  StopFetching := FForceStopFetch;
  FForceStopFetch := False;
  if StopFetching then
  begin
    FFIBDataset.EnableControls;
    Screen.Cursor := crDefault;
  end;
  FSysTimeBeforeRecordFetch := GetTickCount;
end;

procedure TibBTDRVDataset.AfterFetchRecord(FromQuery: TFIBQuery;
  RecordNumber: Integer; var StopFetching: Boolean);
begin
  if not FForceStopFetch then
  begin
    if not StopFetching then
    begin
      FIsFetching := True;
      FFetchTime := FFetchTime + GetTickCount - FSysTimeBeforeRecordFetch;
    end;    
  end
  else
  begin
    FIsFetching := False;
    StopFetching := True;
  end;

  if (RecordNumber mod 500 = 0) then
    if Assigned(FDatasetNotification) then
      FDatasetNotification.OnFetchRecord(Self as IibSHDRVDataset);

  FIsFetching := False;

//  StopFetching := FForceStopFetch;
//  FForceStopFetch := False;
  if StopFetching then
  begin
    FFIBDataset.EnableControls;
    Screen.Cursor := crDefault;
  end;
end;

procedure TibBTDRVDataset.AfterCloseDataset(DataSet: TDataset);
begin
  ListTableInfo.ClearForTable(FFIBDataset.AutoUpdateOptions.UpdateTableName);
end;

procedure TibBTDRVDataset.AfterOpenDataset(DataSet: TDataset);
begin
//  FFIBDataset.GenerateSQLs;
  FDataModified := False;
  if Assigned(FDatasetNotification) then
    FDatasetNotification.AfterOpen(Self);
end;

procedure TibBTDRVDataset.AfterDeleteDataset(DataSet: TDataset);
begin
  FDataModified := True;
end;

procedure TibBTDRVDataset.AfterInsertDataset(DataSet: TDataset);
begin
  FDataModified := True;
end;

procedure TibBTDRVDataset.AfterPost(DataSet: TDataSet);
begin
  FDataModified := True;
end;

procedure TibBTDRVDataset.BeforePost(DataSet: TDataSet);
var
  S: string;
  vRegenerateRefreshSQLText: Boolean;
begin
  if (DataSet.State in [dsEdit]) and FNeedMultyUpdateCheck and (Length(FIBDataset.UpdateSQL.Text) > 0) then
  begin
//    FFIBDataset.GenerateSQLs;
// Отключено здесь, т.к. сиквелы генерируються сразу после открытию датасета в IibSHData
//в частности, для генерации RefreshSQL
    if IsMultiRecordsAffect(FIBDataset.UpdateSQL.Text) then
    begin
      Designer.ShowMsg(Format('This update will affect more then one record'#13#10'Operation canceled', []), mtWarning);
      Abort;
    end;
  end;

  vRegenerateRefreshSQLText := False;
  if (FIBDataset.State in [dsInsert]) then
  begin
    S := CutTableName(FIBDataset.AutoUpdateOptions.UpdateTableName);
    //SetAutoGenerateSQLsParams(S, EmptyStr, False);
    FIBDataset.AutoUpdateOptions.KeyFields := AllKeyModifiedFields(S);
    vRegenerateRefreshSQLText := True;
    if (FIBDataset.AutoUpdateOptions.KeyFields = 'DB_KEY') then
      FRevertToDB_KEY := True;
  end
  else
    if FRevertToDB_KEY then
    begin
      FRevertToDB_KEY := False;
      FIBDataset.AutoUpdateOptions.KeyFields := 'DB_KEY';
      vRegenerateRefreshSQLText := True;
    end;
  if vRegenerateRefreshSQLText then
  begin
    S := FIBDataset.GenerateSQLText(FIBDataset.AutoUpdateOptions.UpdateTableName,
                                    FIBDataset.AutoUpdateOptions.KeyFields,
                                    skRefresh);
    if S <> FIBDataset.RefreshSQL.Text then
      FIBDataset.RefreshSQL.Text := S;
  end;
end;

procedure TibBTDRVDataset.BeforeDelete(DataSet: TDataSet);
begin
  if FNeedMultyUpdateCheck and (Length(FIBDataset.DeleteSQL.Text) > 0) then
  begin
//    FFIBDataset.GenerateSQLs;
// Отключено здесь, т.к. сиквелы генерируються сразу после открытию датасета в IibSHData
//в частности, для генерации RefreshSQL
    if IsMultiRecordsAffect(FIBDataset.DeleteSQL.Text) then
    begin
      Designer.ShowMsg(Format('This deletion will affect more then one record'#13#10'Operation canceled', []), mtWarning);
      Abort;
    end;
  end;
end;

procedure TibBTDRVDataset.TransactionEnded(Sender: TObject);
begin
  FDataModified := False;
end;

procedure TibBTDRVDataset.DoOnAnyError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  Action := daAbort;
  ErrorText := E.Message;
  if Assigned(FDatasetNotification) then
    FDatasetNotification.OnError(Self as IibSHDRVDataset);
end;

procedure TibBTDRVDataset.DoOnLockError(DataSet: TDataSet;
  LockError: TLockStatus; var ErrorMessage: String;
  var Action: TDataAction);
begin
  Action := daAbort;
  ErrorText := ErrorMessage;
  if Assigned(FDatasetNotification) then
    FDatasetNotification.OnError(Self as IibSHDRVDataset);
end;

procedure TibBTDRVDataset.DoOnUpdateError(DataSet: TDataSet; E: EFIBError;
  UpdateKind: TUpdateKind; var UpdateAction: TFIBUpdateAction);
begin
  UpdateAction := uaAbort;
  FErrorText := E.SQLMessage + E.IBMessage;
  if Assigned(FDatasetNotification) then
    FDatasetNotification.OnError(Self as IibSHDRVDataset);
end;

function TibBTDRVDataset.AllKeyModifiedFields(
  const TableName: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to Pred(FFIBDataset.FieldCount) do
   if (not FFIBDataset.Fields[i].IsBlob) and
     (FFIBDataset.Fields[i].FieldName <> 'DB_KEY') and
     (FFIBDataset.Fields[i].OldValue <> FFIBDataset.Fields[i].Value) then
    if FFIBDataset.GetRelationTableName(FFIBDataset.Fields[i])=TableName then
     Result := Result + iifStr(Length(Result) > 0, ';', '') + FFIBDataset.Fields[i].FieldName;
end;

procedure TibBTDRVDataset.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent.IsImplementorOf(FDRVDatabase) then FDRVDatabase := nil;
    if AComponent.IsImplementorOf(FDRVReadTransaction) then FDRVReadTransaction := nil;
    if AComponent.IsImplementorOf(FDRVWriteTransaction) then FDRVWriteTransaction := nil;
    if AComponent.IsImplementorOf(FDatasetNotification) then FDatasetNotification := nil;
  end;
end;

function TibBTDRVDataset.ParamExists(const ParamName: string): Boolean;
begin
  Result := FIBDataset.FindParam(ParamName) <> nil;
end;

function TibBTDRVDataset.ParamName(ParamNo: Integer): string;
begin
  if (ParamNo >= 0) and (ParamNo < ParamCount) then
    Result := FIBDataset.Params[ParamNo].Name
  else
    Result := EmptyStr;
end;

function TibBTDRVDataset.GetParamSize(const ParamName: string): Integer;
begin
  if ParamExists(ParamName) then
    Result := FIBDataset.ParamByName(ParamName).Size
  else
    Result := 0;
end;

function TibBTDRVDataset.GetParamSize(ParamNo: Integer): Integer;
begin
  if (ParamNo >= 0) and (ParamNo < ParamCount) then
    Result := FIBDataset.Params[ParamNo].Size
  else
    Result := 0;
end;

function TibBTDRVDataset.GetParamByName(const ParamName: string): Variant;
begin
  if ParamExists(ParamName) then
    Result := FIBDataset.ParamByName(ParamName).Value
  else
    VarClear(Result);
end;

procedure TibBTDRVDataset.SetParamByName(const ParamName: string; Value: Variant);
begin
  if ParamExists(ParamName) then
    FIBDataset.ParamByName(ParamName).Value := Value;
end;

function TibBTDRVDataset.GetRelationTableName(FieldIndex: Integer): string;
begin
  if (FieldIndex >= 0) and (FieldIndex < FFIBDataset.FieldCount) then
    Result := FFIBDataset.GetRelationTableName(FFIBDataset.Fields[FieldIndex]);
end;

function TibBTDRVDataset.GetRelationFieldName(FieldIndex: Integer): string;
begin
  if (FieldIndex >= 0) and (FieldIndex < FFIBDataset.FieldCount) then
    Result := FFIBDataset.GetRelationFieldName(FFIBDataset.Fields[FieldIndex]);
end;

function TibBTDRVDataset.Prepare: Boolean;
begin
  Result := False;
  if Assigned(Database) and Database.Connected then
  begin
    Result := FIBDataset.Prepared;
    if not Result then
    begin
      ErrorText := EmptyStr;
      try
        FPrepareTime := GetTickCount;
        FIBDataset.Prepare;
        FPrepareTime := GetTickCount - FPrepareTime;
        Result := True;
      except
        on E: Exception do
        begin
          ErrorText := E.Message;
          Result := False;
          FPrepareTime := 0;
        end;
      end;
    end;
  end;
end;

procedure TibBTDRVDataset.Open;
begin
  ErrorText := EmptyStr;
  SetFilter(EmptyStr);
  if not Prepared then Prepare;
  if Prepared and (Length(ErrorText) = 0) then
    try
      FFetchTime := 0;
      FExecuteTime := GetTickCount;
      FIBDataset.Open;
      FExecuteTime := GetTickCount - FExecuteTime;
//      FExecuteTime := FIBDataset.QSelect.CallTime;
    except
      on E: Exception do
      begin
        if E is EFIBError then
        begin
         FLastErrorCode.SQLCode:=EFIBError(E).SQLCode;
         FLastErrorCode.IBErrorCode:=EFIBError(E).IBErrorCode;
        end;
        ErrorText := E.Message;
        FExecuteTime := 0;
      end;
    end;
  // TODO статистика
end;

procedure TibBTDRVDataset.FetchAll;
begin
  FIBDataset.FetchAll;
end;

procedure TibBTDRVDataset.Close;
begin
  FIBDataset.Close;
  if FIBDataset.QSelect.CursorName<>'' then
  begin
   FIBDataset.QSelect.FreeHandle;
  end
end;

procedure TibBTDRVDataset.CrearAllSQLs;
begin
  FNeedMultyUpdateCheck := False;
  FIBDataset.InsertSQL.Clear;
  FIBDataset.UpdateSQL.Clear;
  FIBDataset.DeleteSQL.Clear;
  FIBDataset.AutoUpdateOptions.UpdateTableName := EmptyStr;
  FIBDataset.AutoUpdateOptions.KeyFields := EmptyStr;
end;

procedure TibBTDRVDataset.GenerateSQLs(const ATableName, AKeyFields: string;
  AllFieldsUsed: Boolean);
var
  vAlias: string;  
begin
  FNeedMultyUpdateCheck := False;
  FIBDataset.AutoUpdateOptions.UpdateTableName := EmptyStr;
  FIBDataset.AutoUpdateOptions.KeyFields := EmptyStr;
  if Length(ATableName) > 0 then
  begin
    vAlias := AliasForTable(FIBDataset.SQLs.SelectSQL.Text, ATableName);
    if (Length(vAlias) = 0) or AnsiSameStr(vAlias, ATableName) then vAlias := EmptyStr;
    if Length(vAlias) > 0 then
      FIBDataset.AutoUpdateOptions.UpdateTableName := ATableName + ' ' + vAlias
    else
      FIBDataset.AutoUpdateOptions.UpdateTableName := ATableName;
    FIBDataset.AutoUpdateOptions.KeyFields := EmptyStr;
    if (Length(AKeyFields) = 0) then
    begin
      FIBDataset.AutoUpdateOptions.KeyFields := FIBDataset.PrimaryKeyFields(ATableName);
      if Length(FIBDataset.AutoUpdateOptions.KeyFields) = 0 then
      begin
        FIBDataset.AutoUpdateOptions.KeyFields := FIBDataset.AllKeyFields(ATableName);
//        if Length(FIBDataset.AutoUpdateOptions.KeyFields) = 0 then
         FNeedMultyUpdateCheck := True;
//        else
//          Exit;
      end;
    end
    else
    begin
      FIBDataset.AutoUpdateOptions.KeyFields := AKeyFields;
      FNeedMultyUpdateCheck := AllFieldsUsed;
    end;
    try
      FIBDataset.AutoUpdateOptions.UpdateOnlyModifiedFields := False;
      FIBDataset.GenerateSQLs;
      FIBDataset.AutoUpdateOptions.UpdateOnlyModifiedFields := True;
    except
      if not FIBDataset.Active then
        CrearAllSQLs;
    end;
  end;
end;

procedure TibBTDRVDataset.SetAutoGenerateSQLsParams(const ATableName,
  AKeyFields: string; AllFieldsUsed: Boolean);
var
  vAlias: string;
begin
  FNeedMultyUpdateCheck := False;
  FIBDataset.AutoUpdateOptions.UpdateTableName := EmptyStr;
  FIBDataset.AutoUpdateOptions.KeyFields := EmptyStr;
  if Length(ATableName) > 0 then
  begin
    vAlias := AliasForTable(FIBDataset.SQLs.SelectSQL.Text, ATableName);
    if (Length(vAlias) = 0) or AnsiSameStr(vAlias, ATableName) then vAlias := EmptyStr;
    if Length(vAlias) > 0 then
      FIBDataset.AutoUpdateOptions.UpdateTableName := ATableName + ' ' + vAlias
    else
      FIBDataset.AutoUpdateOptions.UpdateTableName := ATableName;
    FIBDataset.AutoUpdateOptions.KeyFields := EmptyStr;
    if (Length(AKeyFields) = 0) then
    begin
      FIBDataset.AutoUpdateOptions.KeyFields := FIBDataset.PrimaryKeyFields(ATableName);
      if Length(FIBDataset.AutoUpdateOptions.KeyFields) = 0 then
      begin
        FIBDataset.AutoUpdateOptions.KeyFields := FIBDataset.AllKeyFields(ATableName);
//        if Length(FIBDataset.AutoUpdateOptions.KeyFields) > 0 then
//        if Length(FIBDataset.AutoUpdateOptions.KeyFields) = 0 then
        FNeedMultyUpdateCheck := True;
//        else
//          Exit;
      end;
    end
    else
    begin
      FIBDataset.AutoUpdateOptions.KeyFields := AKeyFields;
      FNeedMultyUpdateCheck := AllFieldsUsed;
    end;
  end;
end;

procedure TibBTDRVDataset.DoSort(Fields: array of const;
  Ordering: array of Boolean);
begin
  FFIBDataset.DoSort(Fields, Ordering);
end;



function TibBTDRVDataset.DynMethodExec(const MethodName: string;
  const Args: array of Variant): Variant;
begin
  VarClear(Result);
  if (Length(MethodName)>0) and Assigned(FFIBDataset) then
  case MethodName[1] of
   'R': if MethodName='ROWS_AFFECTED' then
        begin
          Result:=FFIBDataset.QSelect.RowsAffected
        end;
   'S': if MethodName='SETCURSORNAME' then
        begin
          FFIBDataset.QSelect.CursorName:=Args[0]
        end
        else
        if MethodName='SETUNIDIRECTIONAL' then
        begin
          FFIBDataset.UniDirectional:=Args[0]
        end;
        
  end
end;

function TibBTDRVDataset.DynMethodExecOut(const MethodName: string;
  const Args: array of Variant; var Results: TDynMethodResults): Variant;
begin
  if (Length(MethodName)>0) and Assigned(FFIBDataset) then
  case MethodName[1] of
   'R': if MethodName='ROWS_AFFECTED' then
        begin
          SetLength(Results,1);
          Results[0]:=FFIBDataset.QSelect.RowsAffected
        end;
   'S': if MethodName='SETCURSORNAME' then
        begin
          SetLength(Results,1);
          FFIBDataset.QSelect.CursorName:=Args[0]
        end
        else
        if MethodName='SETUNIDIRECTIONAL' then
        begin
          SetLength(Results,0);
          FFIBDataset.UniDirectional:=Args[0]
        end
  end
end;

function TibBTDRVDataset.DynMethodExist(const MethodName: string): boolean;
begin
   Result:=False;
   if Length(MethodName)>0 then
   case MethodName[1] of
    'R':Result:= MethodName='ROWS_AFFECTED';
    'S':Result:= (MethodName='SETCURSORNAME') or (MethodName='SETUNIDIRECTIONAL');
   end
end;

function TibBTDRVDataset.GetDebugFieldValue(Index: integer): Variant;
var
   FReservedBuffer:string;
begin
  if Assigned(FFIBDataset) and (FFIBDataset.FieldCount>Index) then
  with FFIBDataset do
  case Fields[Index].DataType of
   ftString:  if Fields[Index] is TFIBStringField then
              begin
                if TFIBStringField(Fields[Index]).IsDBKey then
                begin
                  SetLength(FReservedBuffer,Fields[Index].Size);
                  if not Fields[Index].GetData(@FReservedBuffer[1]) then
                     Result:=''
                  else
                  begin
                      Result:=FReservedBuffer
                  end
                end
                else
                 Result:=Fields[Index].Value;
              end
              else
               Result:=Fields[Index].Value;
   ftBlob,ftMemo:Result:=Fields[Index].Value;
  else
    Result:=Fields[Index].Value
  end
  else
   VarClear(Result)
end;


{ TibBTDRVMonitor }

constructor TibBTDRVMonitor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFIBMonitor := TFIBSQLMonitor.Create(nil);
  NativeDAC := FFIBMonitor;

  FFIBMonitor.Active := False;
  FFIBMonitor.TraceFlags := [];
end;

destructor TibBTDRVMonitor.Destroy;
begin
  FFIBMonitor.Free;
  inherited Destroy;
end;

function TibBTDRVMonitor.GetActive: Boolean;
begin
  Result := FIBMonitor.Active;
end;

procedure TibBTDRVMonitor.SetActive(Value: Boolean);
begin
  FIBMonitor.Active := Value;
end;

function TibBTDRVMonitor.GetTracePrepare: Boolean;
begin
  Result := tfQPrepare in FIBMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTracePrepare(Value: Boolean);
begin
  if Value then
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags + [tfQPrepare]
  else
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags - [tfQPrepare];
end;

function TibBTDRVMonitor.GetTraceExecute: Boolean;
begin
  Result := tfQExecute in FIBMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceExecute(Value: Boolean);
begin
  if Value then
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags + [tfQExecute]
  else
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags - [tfQExecute];
end;

function TibBTDRVMonitor.GetTraceFetch: Boolean;
begin
  Result := tfQFetch in FIBMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceFetch(Value: Boolean);
begin
  if Value then
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags + [tfQFetch]
  else
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags - [tfQFetch];
end;

function TibBTDRVMonitor.GetTraceConnect: Boolean;
begin
  Result := tfConnect in FIBMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceConnect(Value: Boolean);
begin
  if Value then
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags + [tfConnect]
  else
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags - [tfConnect];
end;

function TibBTDRVMonitor.GetTraceTransact: Boolean;
begin
  Result := tfTransact in FIBMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceTransact(Value: Boolean);
begin
  if Value then
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags + [tfTransact]
  else
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags - [tfTransact];
end;

function TibBTDRVMonitor.GetTraceService: Boolean;
begin
  Result := tfService in FIBMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceService(Value: Boolean);
begin
  if Value then
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags + [tfService]
  else
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags - [tfService];
end;

function TibBTDRVMonitor.GetTraceStmt: Boolean;
begin
  Result := False;
end;

procedure TibBTDRVMonitor.SetTraceStmt(Value: Boolean);
begin
//  Empty
end;

function TibBTDRVMonitor.GetTraceError: Boolean;
begin
  Result := False;
end;

procedure TibBTDRVMonitor.SetTraceError(Value: Boolean);
begin
// Empty
end;

function TibBTDRVMonitor.GetTraceBlob: Boolean;
begin
  Result := False;
end;

procedure TibBTDRVMonitor.SetTraceBlob(Value: Boolean);
begin
// Empty
end;

function TibBTDRVMonitor.GetTraceMisc: Boolean;
begin
  Result := tfMisc in FIBMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceMisc(Value: Boolean);
begin
  if Value then
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags + [tfMisc]
  else
    FIBMonitor.TraceFlags := FIBMonitor.TraceFlags - [tfMisc];
end;

function TibBTDRVMonitor.GetOnSQL: TibSHOnSQLNotify;
begin
  Result := FIBMonitor.OnSQL;
end;

procedure TibBTDRVMonitor.SetOnSQL(Value: TibSHOnSQLNotify);
begin
  FIBMonitor.OnSQL := Value;
end;

{ TibBTDRVService }

constructor TibBTDRVService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TibBTDRVService.Destroy;
begin
  if Assigned(FFIBCustomService) then
  begin
    if FFIBCustomService.Active then FFIBCustomService.Detach;
    FFIBCustomService.Free;
  end;
  inherited Destroy;
end;

function TibBTDRVService.GetActive: Boolean;
begin
  Result := Assigned(FIBCustomService) and FIBCustomService.Active;
end;

function TibBTDRVService.GetServiceType: TibSHServiceType;
begin
  Result := FServiceType;
end;

function TibBTDRVService.GetConnectProtocol: string;
begin
  Result := FConnectProtocol;
end;

procedure TibBTDRVService.SetConnectProtocol(Value: string);
begin
  FConnectProtocol := Value;
end;

function TibBTDRVService.GetConnectPort: string;
begin
  Result := FConnectPort;
end;

procedure TibBTDRVService.SetConnectPort(Value: string);
begin
  FConnectPort := Value;
end;

function TibBTDRVService.GetConnectLibraryName: string;
begin
  Result := FConnectLibraryName;
end;

procedure TibBTDRVService.SetConnectLibraryName(Value: string);
begin
  FConnectLibraryName := Value;
end;

function TibBTDRVService.GetConnectLoginPrompt: Boolean;
begin
  Result := FConnectLoginPrompt;
end;

procedure TibBTDRVService.SetConnectLoginPrompt(Value: Boolean);
begin
  FConnectLoginPrompt := Value;
end;

function TibBTDRVService.GetConnectUser: string;
begin
  Result := FConnectUser;
end;

procedure TibBTDRVService.SetConnectUser(Value: string);
begin
  FConnectUser := Value;
end;

function TibBTDRVService.GetConnectPassword: string;
begin
  Result := FConnectPassword;
end;

procedure TibBTDRVService.SetConnectPassword(Value: string);
begin
  FConnectPassword := Value;
end;

function TibBTDRVService.GetConnectRole: string;
begin
  Result := FConnectRole;
end;

procedure TibBTDRVService.SetConnectRole(Value: string);
begin
  FConnectRole := Value;
end;

function TibBTDRVService.GetConnectServer: string;
begin
  Result := FConnectServer;
end;

procedure TibBTDRVService.SetConnectServer(Value: string);
begin
  FConnectServer := Value;
end;

function TibBTDRVService.GetConnectDatabase: string;
begin
  Result := FConnectDatabase;
end;

procedure TibBTDRVService.SetConnectDatabase(Value: string);
begin
  FConnectDatabase := Value;
end;

function TibBTDRVService.Attach(AServiceType: TibSHServiceType; OnText: TSHOnTextNotify = nil): Boolean;
begin
  Result := False;

  FServiceType := AServiceType;
  case FServiceType of
    stServerProperties: FFIBCustomService := TpFIBServerProperties.Create(nil);
    stConfigService: FFIBCustomService := TpFIBConfigService.Create(nil);
    stLicensingService: FFIBCustomService := TpFIBLicensingService.Create(nil);
    stLogService: FFIBCustomService := TpFIBLogService.Create(nil);
    stStatisticalService: FFIBCustomService := TpFIBStatisticalService.Create(nil);
    stBackupService: FFIBCustomService := TpFIBBackupService.Create(nil);
    stRestoreService: FFIBCustomService := TpFIBRestoreService.Create(nil);
    stValidationService: FFIBCustomService := TpFIBValidationService.Create(nil);
    stSecurityService: FFIBCustomService := TpFIBSecurityService.Create(nil);
  end;

  if Assigned(FIBCustomService) then
  begin
    if Assigned(OnText) then
    begin
      if FIBCustomService is TpFIBConfigService then
        TpFIBConfigService(FIBCustomService).DatabaseName := ConnectDatabase;
      if FIBCustomService is TpFIBLogService then
        TpFIBLogService(FIBCustomService).OnTextNotify := OnText;
      if FIBCustomService is TpFIBStatisticalService then
      begin
        TpFIBStatisticalService(FIBCustomService).DatabaseName := ConnectDatabase;
        TpFIBStatisticalService(FIBCustomService).OnTextNotify := OnText;
      end;
      if FIBCustomService is TpFIBBackupService then
        TpFIBBackupService(FIBCustomService).OnTextNotify := OnText;
      if FIBCustomService is TpFIBRestoreService then
        TpFIBRestoreService(FIBCustomService).OnTextNotify := OnText;
      if FIBCustomService is TpFIBValidationService then
      begin
        TpFIBValidationService(FIBCustomService).DatabaseName := ConnectDatabase;
        TpFIBValidationService(FIBCustomService).OnTextNotify := OnText;
      end;
    end;

    if AnsiSameText(ConnectProtocol, 'TCP/IP') then FIBCustomService.Protocol := TCP;
    if AnsiSameText(ConnectProtocol, 'NamedPipe') then FIBCustomService.Protocol := NamedPipe;
    if AnsiSameText(ConnectProtocol, 'SPX') then FIBCustomService.Protocol := SPX;
    if AnsiSameText(ConnectProtocol, 'Local') then FIBCustomService.Protocol := Local;

    if not AnsiSameText(ConnectProtocol, 'Local') then
    begin
      FIBCustomService.ServerName := ConnectServer;
      if not AnsiSameText(ConnectPort, '3050') then
        FIBCustomService.ServerName := Format('%s/%s', [ConnectServer, ConnectPort]);
    end;

    FIBCustomService.LibraryName := ConnectLibraryName;

    FIBCustomService.Params.Clear;
    FIBCustomService.Params.Add(Format('user_name=%s', [ConnectUser]));
    FIBCustomService.Params.Add(Format('password=%s', [ConnectPassword]));
    FIBCustomService.Params.Add(Format('sql_role_name=%s', [ConnectRole]));
    FIBCustomService.LoginPrompt := ConnectLoginPrompt;

    try
      ErrorText := EmptyStr;
      FIBCustomService.Active := True;
      Result := FIBCustomService.Active;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        Result := False;
      end;
    end;

    if not Result then
      ErrorText := Format('Cannot attach to server "%s"%s%s', [FIBCustomService.ServerName, SLineBreak, ErrorText]);
  end;
end;

function TibBTDRVService.Detach: Boolean;
begin
  Result := False;
  if Assigned(FIBCustomService) and FIBCustomService.Active then
  begin
    FIBCustomService.Detach;
    if not FIBCustomService.Active then FreeAndNil(FFIBCustomService);
    Result := not Assigned(FIBCustomService);
  end;
end;

procedure TibBTDRVService.DisplayUsers;
begin
  if Active and (FFIBCustomService is TpFIBSecurityService) then
    TpFIBSecurityService(FFIBCustomService).DisplayUsers;
end;

function TibBTDRVService.UserCount: Integer;
begin
  Result := 0;
  if Active and (FFIBCustomService is TpFIBSecurityService) then
    Result := TpFIBSecurityService(FFIBCustomService).UserInfoCount;
end;

function TibBTDRVService.GetUserName(AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBSecurityService) then
    Result := TpFIBSecurityService(FFIBCustomService).UserInfo[AIndex].UserName;
end;

function TibBTDRVService.GetFirstName(AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBSecurityService) then
    Result := TpFIBSecurityService(FFIBCustomService).UserInfo[AIndex].FirstName;
end;

function TibBTDRVService.GetMiddleName(AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBSecurityService) then
    Result := TpFIBSecurityService(FFIBCustomService).UserInfo[AIndex].MiddleName;
end;

function TibBTDRVService.GetLastName(AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBSecurityService) then
    Result := TpFIBSecurityService(FFIBCustomService).UserInfo[AIndex].LastName;
end;

function TibBTDRVService.AddUser(const UserName, Password, FirstName, MiddleName, LastName: string): Boolean;
begin
  Result := False;
  if Active and (FFIBCustomService is TpFIBSecurityService) then
  begin
    TpFIBSecurityService(FFIBCustomService).UserName := UserName;
    TpFIBSecurityService(FFIBCustomService).Password := Password;
    TpFIBSecurityService(FFIBCustomService).FirstName := FirstName;
    TpFIBSecurityService(FFIBCustomService).MiddleName := MiddleName;
    TpFIBSecurityService(FFIBCustomService).LastName := LastName;
    TpFIBSecurityService(FFIBCustomService).AddUser;
    Result := True;    
  end;
end;

function TibBTDRVService.DeleteUser(const UserName: string): Boolean;
begin
  Result := False;
  if Active and (FFIBCustomService is TpFIBSecurityService) then
  begin
    TpFIBSecurityService(FFIBCustomService).UserName := UserName;
    TpFIBSecurityService(FFIBCustomService).DeleteUser;
    Result := True;
  end;
end;

function TibBTDRVService.ModifyUser(const UserName, Password, FirstName, MiddleName, LastName: string): Boolean;
begin
  Result := False;
  if Active and (FFIBCustomService is TpFIBSecurityService) then
  begin
    TpFIBSecurityService(FFIBCustomService).UserName := UserName;
    TpFIBSecurityService(FFIBCustomService).Password := Password;
    TpFIBSecurityService(FFIBCustomService).FirstName := FirstName;
    TpFIBSecurityService(FFIBCustomService).MiddleName := MiddleName;
    TpFIBSecurityService(FFIBCustomService).LastName := LastName;
    TpFIBSecurityService(FFIBCustomService).ModifyUser;
    Result := True;
  end;
end;

procedure TibBTDRVService.DisplayLocationInfo;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
  begin
    TpFIBServerProperties(FFIBCustomService).Options := [ConfigParameters];
    TpFIBServerProperties(FFIBCustomService).FetchConfigParams;
  end;
end;

function TibBTDRVService.GetBaseFileLocation: string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := TpFIBServerProperties(FFIBCustomService).ConfigParams.BaseLocation;
end;

function TibBTDRVService.GetLockFileLocation: string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := TpFIBServerProperties(FFIBCustomService).ConfigParams.LockFileLocation;
end;

function TibBTDRVService.GetMessageFileLocation: string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := TpFIBServerProperties(FFIBCustomService).ConfigParams.MessageFileLocation;
end;

function TibBTDRVService.GetSecurityLocation: string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := TpFIBServerProperties(FFIBCustomService).ConfigParams.SecurityDatabaseLocation;
end;

procedure TibBTDRVService.DisplayServerInfo;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
  begin
    TpFIBServerProperties(FFIBCustomService).Options := [Version];
    TpFIBServerProperties(FFIBCustomService).FetchVersionInfo;
  end;
end;

function TibBTDRVService.GetServerVersion: string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := TpFIBServerProperties(FFIBCustomService).VersionInfo.ServerVersion;
end;

function TibBTDRVService.GetServerImplementation: string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := TpFIBServerProperties(FFIBCustomService).VersionInfo.ServerImplementation;
end;

function TibBTDRVService.GetServiceVersion: string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := IntToStr(TpFIBServerProperties(FFIBCustomService).VersionInfo.ServiceVersion);
end;

procedure TibBTDRVService.DisplayDatabaseInfo;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
  begin
    TpFIBServerProperties(FFIBCustomService).Options := [Database];
    TpFIBServerProperties(FFIBCustomService).FetchDatabaseInfo;
  end;
end;

function TibBTDRVService.GetNumberOfAttachments: string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := IntToStr(TpFIBServerProperties(FFIBCustomService).DatabaseInfo.NoOfAttachments);
end;

function TibBTDRVService.GetNumberOfDatabases: string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := IntToStr(TpFIBServerProperties(FFIBCustomService).DatabaseInfo.NoOfDatabases);
end;

function TibBTDRVService.GetDatabaseName(AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := TpFIBServerProperties(FFIBCustomService).DatabaseInfo.DbName[AIndex];
end;

procedure TibBTDRVService.DisplayLicenseInfo;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
  begin
    TpFIBServerProperties(FFIBCustomService).Options := [License];
    TpFIBServerProperties(FFIBCustomService).FetchLicenseInfo;
  end;
end;

function TibBTDRVService.GetLicensedUsers: string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := IntToStr(TpFIBServerProperties(FFIBCustomService).LicenseInfo.LicensedUsers);
end;

function TibBTDRVService.GetLicensedKeyCount: Integer;
begin
  Result := 0;
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := High(TpFIBServerProperties(FFIBCustomService).LicenseInfo.Key);
end;

function TibBTDRVService.GetLicensedKey(AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := TpFIBServerProperties(FFIBCustomService).LicenseInfo.Key[AIndex];
end;

function TibBTDRVService.GetLicensedID(AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := TpFIBServerProperties(FFIBCustomService).LicenseInfo.ID[AIndex];
end;

function TibBTDRVService.GetLicensedDesc(AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    Result := TpFIBServerProperties(FFIBCustomService).LicenseInfo.Desc[AIndex];
end;

procedure TibBTDRVService.DisplayConfigInfo;
begin
  if Active and (FFIBCustomService is TpFIBServerProperties) then
  begin
    TpFIBServerProperties(FFIBCustomService).Options := [ConfigParameters];
    TpFIBServerProperties(FFIBCustomService).FetchConfigParams;
  end;
end;

function TibBTDRVService.GetISCCFG_XXX_KEY(AKey: Integer): Integer;
begin
  Result := 0;
  if Active and (FFIBCustomService is TpFIBServerProperties) then
    if AKey <= High(TpFIBServerProperties(FFIBCustomService).ConfigParams.ConfigFileData.ConfigFileValue) then
      Result := TpFIBServerProperties(FFIBCustomService).ConfigParams.ConfigFileData.ConfigFileValue[AKey];
end;

function TibBTDRVService.DisplayServerLog: Boolean;
begin
  Result := False;
  if Active and (FFIBCustomService is TpFIBLogService) then
  begin
    try
      ErrorText := EmptyStr;
      TpFIBLogService(FFIBCustomService).ServiceStart;
      Result := True;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        Result := False;
      end;
    end;
  end;
end;

function TibBTDRVService.DisplayDatabaseStatistics(const AStopIndex: Integer; ATableName: string = ''): Boolean;
begin
  Result := False;
  if Active and (FFIBCustomService is TpFIBStatisticalService) then
  begin
    case AStopIndex of
      0: TpFIBStatisticalService(FFIBCustomService).Options := [HeaderPages];
      1: TpFIBStatisticalService(FFIBCustomService).Options := [DbLog];
      2: TpFIBStatisticalService(FFIBCustomService).Options := [IndexPages];
      3: TpFIBStatisticalService(FFIBCustomService).Options := [DataPages];
      4: TpFIBStatisticalService(FFIBCustomService).Options := [SystemRelations];
      5: TpFIBStatisticalService(FFIBCustomService).Options := [RecordVersions];
      6: TpFIBStatisticalService(FFIBCustomService).Options := [StatTables];
    end;
    TpFIBStatisticalService(FFIBCustomService).TableNames := ATableName;
    try
      ErrorText := EmptyStr;
      TpFIBStatisticalService(FFIBCustomService).ServiceStart;
      Result := True;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        Result := False;
      end;
    end;
  end;
end;

function TibBTDRVService.DisplayDatabaseValidation(const ARecordFragments, AReadOnly, AIgnoreChecksum, AKillShadows: Boolean): Boolean;
var
  Options: TValidateOptions;
begin
  Result := False;
  Options := [];
  if Active and (FFIBCustomService is TpFIBValidationService) then
  begin
    Include(Options, ValidateDB);
    if ARecordFragments then Include(Options, ValidateFull);
    if AReadOnly then Include(Options, CheckDB);
    if AIgnoreChecksum then Include(Options, IgnoreChecksum);
    if AKillShadows then Include(Options, KillShadows);
    TpFIBValidationService(FFIBCustomService).Options := Options;
    try
      ErrorText := EmptyStr;
      TpFIBValidationService(FFIBCustomService).ServiceStart;
      Result := True;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        Result := False;
      end;
    end;
  end;
end;

function TibBTDRVService.DisplayDatabaseSweep(const AIgnoreChecksum: Boolean): Boolean;
var
  Options: TValidateOptions;
begin
  Result := False;
  Options := [];
  if Active and (FFIBCustomService is TpFIBValidationService) then
  begin
    Include(Options, SweepDB);
    if AIgnoreChecksum then Include(Options, IgnoreChecksum);
    TpFIBValidationService(FFIBCustomService).Options := Options;
    try
      ErrorText := EmptyStr;
      TpFIBValidationService(FFIBCustomService).ServiceStart;
      Result := True;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        Result := False;
      end;
    end;
  end;
end;

function TibBTDRVService.DisplayDatabaseMend(const AIgnoreChecksum: Boolean): Boolean;
var
  Options: TValidateOptions;
begin
  Result := False;
  Options := [];
  if Active and (FFIBCustomService is TpFIBValidationService) then
  begin
    Include(Options, MendDB);
    if AIgnoreChecksum then Include(Options, IgnoreChecksum);
    TpFIBValidationService(FFIBCustomService).Options := Options;
    try
      ErrorText := EmptyStr;
      TpFIBValidationService(FFIBCustomService).ServiceStart;
      Result := True;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        Result := False;
      end;
    end;
  end;
end;

function TibBTDRVService.DisplayLimboTransactions: Boolean;
begin
  Result := False;
  if Active and (FFIBCustomService is TpFIBValidationService) then
  begin
    TpFIBValidationService(FFIBCustomService).Options := [LimboTransactions];
    try
      ErrorText := EmptyStr;
      TpFIBValidationService(FFIBCustomService).ServiceStart;
//      TpFIBValidationService(FFIBCustomService).FetchLimboTransactionInfo;
      Result := True;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        Result := False;
      end;
    end;
  end;
end;

procedure TibBTDRVService.FixLimboTransactionErrors;
begin
  if Active and (FFIBCustomService is TpFIBValidationService) then
    TpFIBValidationService(FFIBCustomService).FixLimboTransactionErrors;
end;

function TibBTDRVService.GetLimboTransactionCount: Integer;
begin
  Result := 0;
  if Active and (FFIBCustomService is TpFIBValidationService) then
  begin
    Result := TpFIBValidationService(FFIBCustomService).LimboTransactionInfoCount;
    if Result = -1 then Result := 0;
  end;
end;

function TibBTDRVService.GetLimboTransactionMultiDatabase(const AIndex: Integer): Boolean;
begin
  Result := False;
  if Active and (FFIBCustomService is TpFIBValidationService) then
    Result := TpFIBValidationService(FFIBCustomService).LimboTransactionInfo[AIndex].MultiDatabase;
end;

function TibBTDRVService.GetLimboTransactionID(const AIndex: Integer): Integer;
begin
  Result := 0;
  if Active and (FFIBCustomService is TpFIBValidationService) then
    Result := TpFIBValidationService(FFIBCustomService).LimboTransactionInfo[AIndex].ID;
end;

function TibBTDRVService.GetLimboTransactionHostSite(const AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBValidationService) then
    Result := TpFIBValidationService(FFIBCustomService).LimboTransactionInfo[AIndex].HostSite;
end;

function TibBTDRVService.GetLimboTransactionRemoteSite(const AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBValidationService) then
    Result := TpFIBValidationService(FFIBCustomService).LimboTransactionInfo[AIndex].RemoteSite;
end;

function TibBTDRVService.GetLimboTransactionRemoteDatabasePath(const AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBValidationService) then
    Result := TpFIBValidationService(FFIBCustomService).LimboTransactionInfo[AIndex].RemoteDatabasePath;
end;

function TibBTDRVService.GetLimboTransactionState(const AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBValidationService) then
    case TpFIBValidationService(FFIBCustomService).LimboTransactionInfo[AIndex].State of
      LimboState: Result := 'Limbo';
      CommitState: Result := 'Commit';
      RollbackState: Result := 'Rollback';
      UnknownState: Result := 'Unknown';
    end;
end;

function TibBTDRVService.GetLimboTransactionAdvise(const AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBValidationService) then
    case TpFIBValidationService(FFIBCustomService).LimboTransactionInfo[AIndex].Advise of
      CommitAdvise: Result := 'Commit';
      RollbackAdvise: Result := 'Rollback';
      UnknownAdvise: Result := 'Unknown';
    end;
end;

function TibBTDRVService.GetLimboTransactionAction(const AIndex: Integer): string;
begin
  if Active and (FFIBCustomService is TpFIBValidationService) then
    case TpFIBValidationService(FFIBCustomService).LimboTransactionInfo[AIndex].Action of
      CommitAction: Result := 'Commit';
      RollbackAction: Result := 'Rollback';
    end;
end;

function TibBTDRVService.DisplayDatabaseOnline: Boolean;
begin
  Result := False;
  if Active and (FFIBCustomService is TpFIBConfigService) then
  begin
    try
      ErrorText := EmptyStr;
      TpFIBConfigService(FFIBCustomService).BringDatabaseOnline;
      Result := True;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        Result := False;
      end;
    end;
  end;
end;

function TibBTDRVService.DisplayDatabaseShutdown(const AModeIndex, ATimeout: Integer): Boolean;
begin
  Result := False;
  if Active and (FFIBCustomService is TpFIBConfigService) then
  begin
    try
      ErrorText := EmptyStr;
      case AModeIndex of
        0: TpFIBConfigService(FFIBCustomService).ShutdownDatabase(Forced, ATimeout);
        1: TpFIBConfigService(FFIBCustomService).ShutdownDatabase(DenyTransaction, ATimeout);
        2: TpFIBConfigService(FFIBCustomService).ShutdownDatabase(DenyAttachment, ATimeout);
      end;
      Result := True;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        Result := False;
      end;
    end;
  end;
end;

procedure TibBTDRVService.SetPageBuffers(Value: Integer);
begin
  if Active and (FFIBCustomService is TpFIBConfigService) then
    TpFIBConfigService(FFIBCustomService).SetPageBuffers(Value);
end;

procedure TibBTDRVService.SetSQLDialect(Value: Integer);
begin
  if Active and (FFIBCustomService is TpFIBConfigService) then
    TpFIBConfigService(FFIBCustomService).SetDBSqlDialect(Value);
end;

procedure TibBTDRVService.SetSweepInterval(Value: Integer);
begin
  if Active and (FFIBCustomService is TpFIBConfigService) then
    TpFIBConfigService(FFIBCustomService).SetSweepInterval(Value);
end;

procedure TibBTDRVService.SetForcedWrites(Value: Boolean);
begin
  if Active and (FFIBCustomService is TpFIBConfigService) then
    TpFIBConfigService(FFIBCustomService).SetAsyncMode(not Value);
end;

procedure TibBTDRVService.SetReadOnly(Value: Boolean);
begin
  if Active and (FFIBCustomService is TpFIBConfigService) then
    TpFIBConfigService(FFIBCustomService).SetReadOnly(Value);
end;

function TibBTDRVService.DisplayBackup(const ASourceFileList, ADestinationFileList: TStrings;
  const ATransportable, AMetadataOnly, ANoGarbageCollect, AIgnoreLimboTrans,
        AIgnoreChecksums, AOldMetadataDesc, AConvertExtTables, AVerbose: Boolean): Boolean;
var
  Options: TBackupOptions;
begin
  Result := False;
  Options := [];
  if Active and (FFIBCustomService is TpFIBBackupService) then
  begin
    try
      ErrorText := EmptyStr;
      TpFIBBackupService(FFIBCustomService).DatabaseName := Trim(ASourceFileList.Text);
      TpFIBBackupService(FFIBCustomService).BackupFile.Assign(ADestinationFileList);
      if not ATransportable then Include(Options, NonTransportable);
      if AMetadataOnly then Include(Options, MetadataOnly);
      if ANoGarbageCollect then Include(Options, NoGarbageCollection);
      if AIgnoreLimboTrans then Include(Options, IgnoreLimbo);
      if AIgnoreChecksums then Include(Options, IgnoreChecksums);
      if AOldMetadataDesc then Include(Options, OldMetadataDesc);
      if AConvertExtTables then Include(Options, ConvertExtTables);
      TpFIBBackupService(FFIBCustomService).Options := Options;
      TpFIBBackupService(FFIBCustomService).Verbose := AVerbose;
      TpFIBBackupService(FFIBCustomService).ServiceStart;
      Result := True;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        Result := False;
      end;
    end;
  end;
end;

function TibBTDRVService.DisplayRestore(const ASourceFileList, ADestinationFileList: TStrings;
  const APageSize: Integer;
  const AReplaceExisting, AMetadataOnly, ACommitEachTable, AWithoutShadow,
        ADeactivateIndexes, ANoValidityCheck, AUseAllSpace, AVerbose: Boolean): Boolean;
var
  Options: TRestoreOptions;
begin
  Result := False;
  Options := [];
  if Active and (FFIBCustomService is TpFIBRestoreService) then
  begin
    try
      ErrorText := EmptyStr;
      TpFIBRestoreService(FFIBCustomService).BackupFile.Assign(ASourceFileList);
      TpFIBRestoreService(FFIBCustomService).DatabaseName.Assign(ADestinationFileList);
      TpFIBRestoreService(FFIBCustomService).PageSize := APageSize;
      if AReplaceExisting then
        Include(Options, Replace)
      else
        Include(Options, CreateNewDB);
      if AMetadataOnly then
        Include(Options, OnlyMetadata);
      if ACommitEachTable then
        Include(Options, OneRelationAtATime);
      if AWithoutShadow then
        Include(Options, NoShadow);
      if ADeactivateIndexes then
        Include(Options, DeactivateIndexes);
      if ANoValidityCheck then
        Include(Options, NoValidityCheck);
      if AUseAllSpace then
        Include(Options, UseAllSpace);
      TpFIBRestoreService(FFIBCustomService).Options := Options;
      TpFIBRestoreService(FFIBCustomService).Verbose := AVerbose;
      TpFIBRestoreService(FFIBCustomService).ServiceStart;
      Result := True;
    except
      on E: Exception do
      begin
        ErrorText := E.Message;
        Result := False;
      end;
    end;
  end;
end;

{ TibBTDRVSQLParser }

constructor TibBTDRVSQLParser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

{$IFDEF  TRIFONOV}
  FFIBSQLParser := TpFIBSQLParser.Create(nil);
  FFIBSQLParser.OnParse := DDLReverseEngineering;
  NativeDAC := FFIBSQLParser;
  FIsDataSQL := TList.Create;
  FDDLCoord := TList.Create;
  FDDLOperations := TStringList.Create;
  FDDLObjectTypes := TStringList.Create;
  FDDLObjectNames := TStringList.Create;

{$ELSE}
  FScripter     := TpFIBScripter.Create(nil);
  NativeDAC := FScripter;
{$ENDIF}






  vTmpStrings:=TStringList.Create;
end;

destructor TibBTDRVSQLParser.Destroy;
begin
  vTmpStrings.Free;




{$IFDEF  TRIFONOV}
  FDDLOperations.Free;
  FDDLObjectTypes.Free;
  FDDLObjectNames.Free;

  ClearCoord;
  FIsDataSQL.Free;
  FDDLCoord.Free;
  FFIBSQLParser.Free;

{$ELSE}
  FScripter.Free;
{$ENDIF}
  NativeDAC := nil;
  inherited Destroy;
end;

procedure TibBTDRVSQLParser.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
    if AComponent.IsImplementorOf(FSQLParserNotification) then FSQLParserNotification := nil;
end;


{$IFDEF  TRIFONOV}
procedure TibBTDRVSQLParser.ClearCoord;
var
  I: Integer;
begin
  for I := 0 to Pred(FDDLCoord.Count) do
  begin
    if Assigned(FDDLCoord[I]) then
      Dispose(PRect(FDDLCoord[I]));
    FDDLCoord[I] := nil;
  end;
  FDDLCoord.Clear;
end;

procedure TibBTDRVSQLParser.AddDDLCoord(ALeft, ATop, ARight,
  ABottom: Integer);
var
  vCoord: PRect;
begin
  New(vCoord);
  vCoord^ := Rect(ALeft, ATop, ARight, ABottom);
  FDDLCoord.Add(vCoord);
end;
{$ENDIF}
{$IFDEF  TRIFONOV}
procedure TibBTDRVSQLParser.DDLReverseEngineering(Sender: TObject;
  AKind: TpFIBParseKind;const SQLText: string);
var
  Token0, Token1, Token2,
  Operation, ObjectType, ObjectName: string;
  vIsDataSQL: Boolean;
  vRight, vBottom: Integer;
begin
//  if AKind <> stmtDDL then Exit;
  // ---->
  vIsDataSQL := False;
  case AKind  of
    stmtDDL:
      begin
        Token0 := AnsiUpperCase(FIBSQLParser.CurrentTokens[0]);
        Token1 := AnsiUpperCase(FIBSQLParser.CurrentTokens[1]);
        Token2 := AnsiUpperCase(FIBSQLParser.CurrentTokens[2]);
        Operation := Token0;
        if Operation = 'DECLARE' then
        begin
          if Token1 = 'EXTERNAL' then
          begin
            ObjectType := Token2;
            ObjectName := FIBSQLParser.CurrentTokens[3];
          end else
          begin
            ObjectType := Token1;
            ObjectName := FIBSQLParser.CurrentTokens[2];
          end;
        end;

        if (Operation = 'CREATE') or (Operation = 'RECREATE') then
        begin
          if Token1 = 'UNIQUE' then
          begin
            if ((Token2 = 'ASC') OR (Token2 = 'ASCENDING')) OR
               ((Token2 = 'DESC') OR (Token2 = 'DESCENDING')) then
            begin
              ObjectType := AnsiUpperCase(FIBSQLParser.CurrentTokens[3]);
              ObjectName := FIBSQLParser.CurrentTokens[4];
            end else
            begin
              ObjectType := Token2;
              ObjectName := FIBSQLParser.CurrentTokens[3];
            end;
          end else
          begin
            if ((Token1 = 'ASC') OR (Token1 = 'ASCENDING')) OR
               ((Token1 = 'DESC') OR (Token1 = 'DESCENDING')) then
            begin
              ObjectType := Token2;
              ObjectName := FIBSQLParser.CurrentTokens[3];
            end else
            begin
              if (Token1 = 'OR') and (Token2 = 'ALTER') then
              begin
                ObjectType := AnsiUpperCase(FIBSQLParser.CurrentTokens[3]);
                ObjectName := FIBSQLParser.CurrentTokens[4];
              end else
              begin
                ObjectType := Token1;
                ObjectName := FIBSQLParser.CurrentTokens[2];
              end;
            end;
          end;
        end;

        if Operation = 'ALTER' then
        begin
          ObjectType := Token1;
          ObjectName := FIBSQLParser.CurrentTokens[2];
        end;

        if Operation = 'DROP' then
        begin
          if Token1 = 'EXTERNAL' then
          begin
            ObjectType := Token2;
            ObjectName := FIBSQLParser.CurrentTokens[3];
          end else
          begin
            ObjectType := Token1;
            ObjectName := FIBSQLParser.CurrentTokens[2];
          end;
        end;
        vIsDataSQL := True;
      end;
    stmtDML:
      begin
        Operation := AnsiUpperCase(FIBSQLParser.CurrentTokens[0]);
        ObjectType := EmptyStr;
        ObjectName := EmptyStr;
        vIsDataSQL := CompareStr(Operation, 'SELECT') <> 0;
        //vIsDataSQL := False;
      end;
    stmtSET:
      begin
        Operation := AnsiUpperCase(FIBSQLParser.CurrentTokens[0]);
        ObjectType := AnsiUpperCase(FIBSQLParser.CurrentTokens[1]);
        if AnsiSameText(ObjectType, 'STATISTICS') then
        begin
          ObjectName := AnsiUpperCase(FIBSQLParser.CurrentTokens[3]); // 'STATISTICS'
          vIsDataSQL := True;
        end
        else
        if AnsiSameText(ObjectType, 'SQL') then
        begin
          ObjectName := AnsiUpperCase(FIBSQLParser.CurrentTokens[3]); //'DIALECT'
          vIsDataSQL := False;
        end
        else
        begin
          ObjectName := AnsiUpperCase(FIBSQLParser.CurrentTokens[2]); //'AUTODDL', 'NAMES'
          vIsDataSQL := False;
        end;
      end;
    stmtCONNECT:
      begin
        Operation := AnsiUpperCase(FIBSQLParser.CurrentTokens[0]);
        ObjectType := 'DATABASE';
        ObjectName := FIBSQLParser.CurrentTokens[1];
        vIsDataSQL := False;
      end;
    stmtDrop, stmtALTER:
      begin
        Operation := AnsiUpperCase(FIBSQLParser.CurrentTokens[0]);
        ObjectType := AnsiUpperCase(FIBSQLParser.CurrentTokens[1]);
        ObjectName := 'DATABASE';
        vIsDataSQL := False;
      end;
    stmtCREATE:
      begin
        Operation := AnsiUpperCase(FIBSQLParser.CurrentTokens[0]);
        ObjectType := AnsiUpperCase(FIBSQLParser.CurrentTokens[1]);
        ObjectName := FIBSQLParser.CurrentTokens[2];
        vIsDataSQL := False;
      end;
    stmtINPUT, stmtUNK, stmtEMPTY, stmtERR:
      begin
        Operation := AnsiUpperCase(FIBSQLParser.CurrentTokens[0]);
        ObjectType := EmptyStr;
        ObjectName := EmptyStr;
        vIsDataSQL := False;
      end;
    stmtTERM:
      begin
        Operation := AnsiUpperCase(FIBSQLParser.CurrentTokens[0]);
        ObjectType := AnsiUpperCase(FIBSQLParser.CurrentTokens[1]);
        ObjectName := FIBSQLParser.CurrentTokens[2];
        vIsDataSQL := False;
      end;
    stmtCOMMIT, stmtROLLBACK:
      begin
        Operation := AnsiUpperCase(FIBSQLParser.CurrentTokens[0]);
        ObjectType := AnsiUpperCase(FIBSQLParser.CurrentTokens[0]);
        ObjectName := AnsiUpperCase(FIBSQLParser.CurrentTokens[0]);
        //vIsDataSQL := True;
        vIsDataSQL := False;
      end;
    stmtReconnect, stmtDisconnect:
      begin
        Operation := AnsiUpperCase(FIBSQLParser.CurrentTokens[0]);
        ObjectType := 'DATABASE';
        ObjectName := 'DATABASE';
        //vIsDataSQL := True;
        vIsDataSQL := False;
      end;
  end;//case

  FDDLOperations.Add(Operation);
  FDDLObjectTypes.Add(ObjectType);
//  FDDLObjectNames.Add(StripQuote(ObjectName));
  FDDLObjectNames.Add(ObjectName);
  if vIsDataSQL then
    FIsDataSQL.Add(Pointer(1))
  else
    FIsDataSQL.Add(Pointer(0));

  vBottom := FIBSQLParser.EndLine;
  while (vBottom > FIBSQLParser.CurrentLine) and
    (Length(FFIBSQLParser.Script[vBottom]) = 0) do
    Dec(vBottom);
  if FFIBSQLParser.Script[vBottom] = FFIBSQLParser.Terminator then
    Dec(vBottom);
  if Pos(FFIBSQLParser.Terminator, FFIBSQLParser.Script[vBottom]) > 0 then
    vRight := Length(TrimRight(FFIBSQLParser.Script[vBottom])) -
      Length(FFIBSQLParser.Terminator)
  else
    vRight := Length(TrimRight(FFIBSQLParser.Script[vBottom]));
  AddDDLCoord(1, FIBSQLParser.CurrentLine, vRight, vBottom);
  if Assigned(FSQLParserNotification) then FSQLParserNotification.OnParse(Self);
end;
{$ENDIF}

const
  QUOTE = '''';
  DBL_QUOTE = '"';

//function TibBTDRVSQLParser.StripQuote(const Text: string): string;
//begin
//  Result := Text;
//  if (Length(Result) > 0) and (Result[1] in [Quote, DBL_QUOTE]) then begin
//    Delete(Result, 1, 1);
//    Delete(Result, Length(Result), 1);
//  end;
//end;

function TibBTDRVSQLParser.GetScript: TStrings;
begin
{$IFDEF  TRIFONOV}
  Result := FFIBSQLParser.Script;
{$ELSE}
   Result :=FScripter.Script
{$ENDIF}    
end;

function TibBTDRVSQLParser.GetCount: Integer;
begin
{$IFDEF  TRIFONOV}
  Result := FDDLCoord.Count;
{$ELSE}
   Result := FScripter.StatementsCount
{$ENDIF}
end;

{$IFDEF  TRIFONOV}
function TibBTDRVSQLParser.GetStatements(Index: Integer): string;
var
  vCoord: TRect;
  I: Integer;
begin
  vCoord := StatementsCoord(Index);
  if vCoord.Top = vCoord.Bottom then
    Result := FastCopy(FFIBSQLParser.Script[vCoord.Top], vCoord.Left, vCoord.Right - vCoord.Left + 1)
  else
  begin
    Result := FastCopy(FFIBSQLParser.Script[vCoord.Top], vCoord.Left, Length(FFIBSQLParser.Script[vCoord.Top]) - vCoord.Left + 1) + sLineBreak;
    for I := Succ(vCoord.Top) to Pred(vCoord.Bottom) do
      Result := Result + FFIBSQLParser.Script[I] + sLineBreak;
    Result := Result + FastCopy(FFIBSQLParser.Script[vCoord.Bottom], 1, vCoord.Right);
  end;

end;
{$ELSE}
function TibBTDRVSQLParser.GetStatements(Index: Integer): string;
begin
  FScripter.GetStatement(Index+1,vTmpStrings);
  Result:=vTmpStrings.Text
end;
{$ENDIF}

function TibBTDRVSQLParser.GetTerminator: string;
begin
{$IFDEF  TRIFONOV}
  Result := FFIBSQLParser.Terminator;
{$ELSE}
  Result := ';'
{$ENDIF}
end;

procedure TibBTDRVSQLParser.SetTerminator(const Value: string);
begin
{$IFDEF  TRIFONOV}
  FFIBSQLParser.Terminator := Value;
{$ENDIF}  
end;

function TibBTDRVSQLParser.GetSQLParserNotification: IibSHDRVSQLParserNotification;
begin
  Result := FSQLParserNotification;
end;

procedure TibBTDRVSQLParser.SetSQLParserNotification(
  Value: IibSHDRVSQLParserNotification);
begin
  if FSQLParserNotification <> Value then
  begin
    ReferenceInterface(FSQLParserNotification, opRemove);
    FSQLParserNotification := Value;
    ReferenceInterface(FSQLParserNotification, opInsert);
  end;
end;

function TibBTDRVSQLParser.Parse(const SQLText: string): Boolean;
begin
  ErrorText := EmptyStr;

{$IFDEF  TRIFONOV}
  FDDLOperations.Clear;
  FDDLObjectTypes.Clear;
  FDDLObjectNames.Clear;

  ClearCoord;
  FIBSQLParser.Script.Text := SQLText;
  FIsDataSQL.Clear;  
{$ELSE}
  FScripter.Script.Text := SQLText;
{$ENDIF}
  try
{$IFDEF  TRIFONOV}
    FIBSQLParser.Parse;
    Result := FDDLCoord.Count > 0;
{$ELSE}
    FScripter.Parse;
    Result := FScripter.StatementsCount>0;    
{$ENDIF}


  except
    ErrorText := 'Parsing Error...';
    Result := False;
  end;
{$IFDEF  TRIFONOV}
  FFIBSQLParser.Script.Clear;
{$ENDIF}
end;

function TibBTDRVSQLParser.Parse: Boolean;
begin
  ErrorText := EmptyStr;


  try
{$IFDEF  TRIFONOV}
    FDDLOperations.Clear;
    FDDLObjectTypes.Clear;
    FDDLObjectNames.Clear;

   ClearCoord;
    FIsDataSQL.Clear;
    FIBSQLParser.Parse;
    Result := FDDLCoord.Count > 0;

{$ELSE}    
    FScripter.Parse;
    Result := FScripter.StatementsCount>0;
{$ENDIF}



  except
    ErrorText := 'Parsing Error...';
    Result := False;
  end;
{$IFDEF  TRIFONOV}
  FFIBSQLParser.Script.Clear;
{$ENDIF}
end;
{$IFDEF  TRIFONOV}
function TibBTDRVSQLParser.StatementState(const Index: Integer): TSHDBComponentState;
begin
  Assert((Index >= 0) and (Index < FDDLOperations.Count), 'StatementState');
  if (Index >= 0) and (Index < FDDLOperations.Count) then
  begin
    if FDDLOperations[Index] = 'DECLARE' then Result := csCreate else
    if FDDLOperations[Index] = 'CREATE' then Result := csCreate else
    if (FDDLOperations[Index] = 'ALTER') or
       (FDDLOperations[Index] = 'RECONNECT') or
       (FDDLOperations[Index] = 'DISCONNECT') or
       (FDDLOperations[Index] = 'CONNECT') then Result := csAlter else
    if FDDLOperations[Index] = 'RECREATE' then Result := csRecreate else
    if FDDLOperations[Index] = 'DROP' then Result := csDrop;
  end;
end;
{$ELSE}
function TibBTDRVSQLParser.StatementState(const Index: Integer): TSHDBComponentState;
begin
  Result := csUnknown;
  if (Index >= 0) and (Index < FScripter.StatementsCount) then
  case FScripter.GetStatement(Index+1,nil).smtType of
   sDrop:
    Result := csDrop;
   sCreate,sDeclare,sCreateDatabase:
    Result := csCreate;
   sAlter, sCommit,sRollBack,  sConnect,sDisconnect,sReconnect,
    sSetGenerator,sDescribe,sComment,sGrant:
    Result := csAlter;
   sRecreate:
    Result := csRecreate;
  end;
end;
{$ENDIF}

{$IFDEF  TRIFONOV}
function TibBTDRVSQLParser.StatementObjectType(const Index: Integer): TGUID;
begin
  Assert((Index >= 0) and (Index < FDDLObjectTypes.Count), 'StatementObjectType');
  if (Index >= 0) and (Index < FDDLObjectTypes.Count) then
  begin
    if FDDLObjectTypes[Index] = 'DOMAIN' then Result := IibSHDomain else
    if FDDLObjectTypes[Index] = 'TABLE' then Result := IibSHTable else
    if FDDLObjectTypes[Index] = 'INDEX' then Result := IibSHIndex else
    if FDDLObjectTypes[Index] = 'VIEW' then Result := IibSHView else
    if FDDLObjectTypes[Index] = 'PROCEDURE' then Result := IibSHProcedure else
    if FDDLObjectTypes[Index] = 'TRIGGER' then Result := IibSHTrigger else
    if FDDLObjectTypes[Index] = 'GENERATOR' then Result := IibSHGenerator else
    if FDDLObjectTypes[Index] = 'EXCEPTION' then Result := IibSHException else
    if FDDLObjectTypes[Index] = 'FUNCTION' then Result := IibSHFunction else
    if FDDLObjectTypes[Index] = 'FILTER' then Result := IibSHFilter else
    if FDDLObjectTypes[Index] = 'ROLE' then Result := IibSHRole else
    if FDDLObjectTypes[Index] = 'SHADOW' then Result := IibSHShadow else
    if FDDLObjectTypes[Index] = 'DATABASE' then Result := IibSHDatabase;
  end;

end;
{$ELSE}
function TibBTDRVSQLParser.StatementObjectType(const Index: Integer): TGUID;
begin
  Result := IUnknown;
  if (Index >= 0) and (Index < FScripter.StatementsCount) then
  case FScripter.GetStatement(Index+1,nil).objType of
   otDatabase: Result := IibSHDatabase ;
   otDomain: Result := IibSHDomain ;
   otTable : Result := IibSHTable  ;
   otView  : Result := IibSHView  ;
   otProcedure: Result := IibSHProcedure;
   otTrigger: Result := IibSHTrigger;
   otGenerator:Result := IibSHGenerator;
   otException:Result := IibSHException;
   otFunction :Result := IibSHFunction;
   otIndex    :Result := IibSHIndex;
   otFilter   :Result := IibSHFilter;
   otRole     :Result := IibSHRole;
  else
   if FScripter.GetStatement(Index+1,nil).smtType = sGrant then
     Result := IibSHGrant;
  end;
end;

{$ENDIF}

{$IFDEF  TRIFONOV}
function TibBTDRVSQLParser.StatementObjectName(const Index: Integer): string;
begin
  Assert((Index >= 0) and (Index < FDDLObjectNames.Count), 'StatementObjectName');
  if (Index >= 0) and (Index < FDDLObjectNames.Count) then
    Result := FDDLObjectNames[Index];
end;
{$ELSE}
function TibBTDRVSQLParser.StatementObjectName(const Index: Integer): string;
begin
  if (Index >= 0) and (Index < FScripter.StatementsCount) then
  begin
   Result:=FScripter.GetStatement(Index+1,nil).objName
  end
end;
{$ENDIF}

{$IFDEF  TRIFONOV}
function TibBTDRVSQLParser.StatementsCoord(Index: Integer): TRect;
begin
  Assert((Index >= 0) and (Index < FDDLCoord.Count), 'StatementsCoord');
  if (Index >= 0) and (Index < FDDLCoord.Count) then
    Result := PRect(FDDLCoord[Index])^;
end;
{$ELSE}
function TibBTDRVSQLParser.StatementsCoord(Index: Integer): TRect;
var
  sDesc:TStatementDesc;
begin
  if (Index >= 0) and (Index < FScripter.StatementsCount) then
  begin
   sDesc:=FScripter.GetStatement(Index+1,nil);
   Result:=Rect(sDesc.smdBegin.X,sDesc.smdBegin.Y,
           sDesc.smdEnd.X,sDesc.smdEnd.Y
   );
  end
end;

{$ENDIF}

{$IFDEF  TRIFONOV}
function TibBTDRVSQLParser.IsDataSQL(Index: Integer): Boolean;
begin
  Result := False;
  Assert((Index >= 0) and (Index < FIsDataSQL.Count), 'IsDataSQL');
  if (Index >= 0) and (Index < FIsDataSQL.Count) then
    Result := Integer(FIsDataSQL[Index]) = 1;
end;

{$ELSE}
function TibBTDRVSQLParser.IsDataSQL(Index: Integer): Boolean;
begin
  Assert((Index >= 0) and (Index < FScripter.StatementsCount), 'IsDataSQL');
  Result := not (FScripter.GetStatement(Index+1,nil).smtType in [sDML,sUnknown]);  
end;
{$ENDIF}

function TibBTDRVSQLParser.StatementOperationName(Index: Integer): string;
  {$IFNDEF  TRIFONOV}
var
  sDesc:TStatementDesc;
  {$ENDIF}
begin
  {$IFDEF  TRIFONOV}
  Assert((Index >= 0) and (Index < FDDLOperations.Count), 'StatementState');
  if (Index >= 0) and (Index < FDDLOperations.Count) then
  begin
    Result:=FDDLOperations[Index]
  end;
  {$ELSE}
    if (Index >= 0) and (Index < FScripter.StatementsCount) then
    begin
     sDesc:=FScripter.GetStatement(Index+1,nil);
     case sDesc.smtType of
      sDML: Result:='DML';
      sConnect:Result:='CONNECT';
      sDisconnect:Result:='DISCONNECT';
      sReconnect: Result:='RECONNECT';
      sCreateDatabase,sCreate:Result:='CREATE';
      sDropDatabase,sDrop:Result:='DROP';
      sRecreate : Result:='RECREATE';
      sCommit:Result:='COMMIT';
      sRollBack:Result:='ROLLBACK';
      sSet: Result:='SET';
      sSetGenerator:Result:='SETGENERATOR';
      sDeclare:Result:='DECLARE';
      sComment,sDescribe:Result:='COMMENT';
      sGrant :Result:='GRANT';
      sBatchStart :Result:='BATCH START';      
      sBatchExecute :Result:='BATCH EXECUTE';
      sRunFromFile:Result:='RUN FROM FILE';
     else
      Result:='UNKNOWN'
     end
    end;
  {$ENDIF}
end;

{ TibBTDRVStatistics }

function TibBTDRVStatistics.AllIdxReads: Integer;
var
  I: Integer;
begin
  Result := 0;
  if Assigned(FFIBDatabase) then
    for I := 0 to FFIBDatabase.ReadIdxCount.Count - 1 do
      Result := Result + StrToIntDef(FFIBDatabase.ReadIdxCount.ValueFromIndex[I], 0);
end;

function TibBTDRVStatistics.AllSeqReads: Integer;
var
  I: Integer;
begin
  Result := 0;
  if Assigned(FFIBDatabase) then
    for I := 0 to FFIBDatabase.ReadSeqCount.Count - 1 do
      Result := Result + StrToIntDef(FFIBDatabase.ReadSeqCount.ValueFromIndex[I], 0);
end;

function TibBTDRVStatistics.AllUpdates: Integer;
var
  I: Integer;
begin
  Result := 0;
  if Assigned(FFIBDatabase) then
    for I := 0 to FFIBDatabase.UpdateCount.Count - 1 do
      Result := Result + StrToIntDef(FFIBDatabase.UpdateCount.ValueFromIndex[I], 0);
end;

function TibBTDRVStatistics.AllDeletes: Integer;
var
  I: Integer;
begin
  Result := 0;
  if Assigned(FFIBDatabase) then
    for I := 0 to FFIBDatabase.DeleteCount.Count - 1 do
      Result := Result + StrToIntDef(FFIBDatabase.DeleteCount.ValueFromIndex[I], 0);
end;

function TibBTDRVStatistics.AllInserts: Integer;
var
  I: Integer;
begin
  Result := 0;
  if Assigned(FFIBDatabase) then
    for I := 0 to FFIBDatabase.InsertCount.Count - 1 do
      Result := Result + StrToIntDef(FFIBDatabase.InsertCount.ValueFromIndex[I], 0);
end;

function TibBTDRVStatistics.GetIdxReads: Integer;
begin
  Result := FIdxReads;
end;

function TibBTDRVStatistics.GetSeqReads: Integer;
begin
  Result := FSeqReads;
end;

function TibBTDRVStatistics.GetUpdates: Integer;
begin
  Result := FUpdates;
end;

function TibBTDRVStatistics.GetDeletes: Integer;
begin
  Result := FDeletes;
end;

function TibBTDRVStatistics.GetInserts: Integer;
begin
  Result := FInserts;
end;

function TibBTDRVStatistics.GetAllFetches: Integer;
begin
  Result := FFIBDatabase.Fetches;
end;

function TibBTDRVStatistics.GetFetches: Integer;
begin
  Result := FFetches;
end;

function TibBTDRVStatistics.GetAllMarks: Integer;
begin
  Result := FFIBDatabase.Marks;
end;

function TibBTDRVStatistics.GetMarks: Integer;
begin
  Result := FMarks;
end;

function TibBTDRVStatistics.GetAllReads: Integer;
begin
  Result := FFIBDatabase.Reads;
end;

function TibBTDRVStatistics.GetReads: Integer;
begin
  Result := FReads;
end;

function TibBTDRVStatistics.GetAllWrites: Integer;
begin
  Result := FFIBDatabase.Writes;
end;

function TibBTDRVStatistics.GetWrites: Integer;
begin
  Result := FWrites;
end;

function TibBTDRVStatistics.GetTableStatistics(
  Index: Integer): IibSHDRVTableStatistics;
begin
  Assert((Index >= 0) and (Index < FTableStatistics.DeltaStatisticList.Count), 'GetTableStatistics');
  Supports(FTableStatistics.DeltaStatisticList.Statistics[Index], IibSHDRVTableStatistics, Result);
end;

function TibBTDRVStatistics.GetTablesCount: Integer;
begin
  Result := FTableStatistics.DeltaStatisticList.Count;
end;

function TibBTDRVStatistics.GetSnapshotTime: TDateTime;
begin
  Result := FSnapshotTime;
end;

function TibBTDRVStatistics.GetCurrentMemory: Integer;
begin
  Result := FFIBDatabase.CurrentMemory;
end;

function TibBTDRVStatistics.GetMaxMemory: Integer;
begin
  Result := FFIBDatabase.MaxMemory;
end;

function TibBTDRVStatistics.GetNumBuffers: Integer;
begin
  Result := FFIBDatabase.NumBuffers;
end;

function TibBTDRVStatistics.GetDatabasePageSize: Integer;
begin
  Result := FFIBDatabase.PageSize;
end;

function TibBTDRVStatistics.GetDatabase: IibSHDRVDatabase;
begin
  Result := FDRVDatabase;
end;

procedure TibBTDRVStatistics.SetDatabase(const Value: IibSHDRVDatabase);
begin
  if FDRVDatabase <> Value then
  begin
//    if Assigned(FDRVDatabase) then FDRVDatabase := nil;
    ReferenceInterface(FDRVDatabase, opRemove);
    FDRVDatabase := Value;
    ReferenceInterface(FDRVDatabase, opInsert);
    if Assigned(Value) then
      FFIBDatabase := TpFIBDatabase(Value.GetNativeDAC)
    else
      FFIBDatabase := nil;
    FTableStatistics.Database := FFIBDatabase;  
  end;
end;

procedure TibBTDRVStatistics.StartCollection;
begin
  FTableStatistics.StartCounting;
  FIdxReads := AllIdxReads;
  FSeqReads := AllSeqReads;
  FUpdates := AllUpdates;
  FDeletes := AllDeletes;
  FInserts := AllInserts;
  if Assigned(FFIBDatabase) then
  begin
    FFetches := FFIBDatabase.Fetches;
    FMarks := FFIBDatabase.Marks;
    FReads := FFIBDatabase.Reads;
    FWrites := FFIBDatabase.Writes;
  end
  else
  begin
    FFetches := 0;
    FMarks := 0;
    FReads := 0;
    FWrites := 0;
  end;
end;

procedure TibBTDRVStatistics.CalculateStatistics;
begin
  FIdxReads := AllIdxReads - FIdxReads;
  FSeqReads := AllSeqReads - FSeqReads;
  FUpdates := AllUpdates - FUpdates;
  FDeletes := AllDeletes - FDeletes;
  FInserts := AllInserts - FInserts;
  if Assigned(FFIBDatabase) then
  begin
    FFetches := FFIBDatabase.Fetches - FFetches;
    FMarks := FFIBDatabase.Marks - FMarks;
    FReads := FFIBDatabase.Reads - FReads;
    FWrites := FFIBDatabase.Writes - FWrites;
  end;
  FTableStatistics.CaclDelta;
  FSnapshotTime := Now;
end;

constructor TibBTDRVStatistics.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTableStatistics := TibBTTableStatisticCalculator.Create(Self);
end;

destructor TibBTDRVStatistics.Destroy;
begin
  FTableStatistics.Free;
  inherited;
end;

procedure TibBTDRVStatistics.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent.IsImplementorOf(FDRVDatabase) then FDRVDatabase := nil;
  end;
end;

{ TibBTDRVPlayer }
{$IFDEF  TRIFONOV}
procedure TibBTDRVPlayer.DoOnParse(Sender: TObject;
  AKind: TpFIBParseKind; const SQLText: string);
begin

  if Assigned(FDRVPlayerNotification) then
    FDRVPlayerNotification.OnParse(Self as IibSHDRVPlayer, SQLText,
      FPlayer.SQLParser.CurrentLine);

end;

procedure TibBTDRVPlayer.DoOnExecuteError(Sender: TObject; Error,
  SQLText: string; LineIndex: Integer; var Ignore: Boolean;
  var Action: TpFIBAfterError);
var
  vDoAbort: Boolean;
  vDoRollback: Boolean;
begin
  vDoAbort := not Ignore;
  vDoRollback := Action = aeRollback;
  if Assigned(FDRVPlayerNotification) then
  begin
    FDRVPlayerNotification.OnError(Self as IibSHDRVPlayer, Error, SQLText,
      LineIndex, vDoAbort, vDoRollback);
    Ignore := not vDoAbort;
    if vDoRollback then
      Action := aeRollback
    else
      Action := aeCommit;
  end;
end;

procedure TibBTDRVPlayer.DoAfterExecute(Sender: TObject;
  AKind: TpFIBParseKind; ATokens: TStrings; ASQLText: string);
begin
  if Assigned(FDRVPlayerNotification) then
    if AKind = stmtDDL then //ускорим обработку немного отсечением пока ненужных
      FDRVPlayerNotification.AfterExecute(Self as IibSHDRVPlayer, ATokens, ASQLText);
end;
{$ELSE}

procedure TibBTDRVPlayer.DoOnExecuteError(Sender: TObject; StatementNo: Integer;
    Line:Integer; Statement: TStrings; SQLCode: Integer; const Msg: string;
    var doRollBack:boolean;
    var Stop: Boolean);
begin
  if Assigned(FDRVPlayerNotification) then
  begin
    FDRVPlayerNotification.OnError( Self as IibSHDRVPlayer,
      Msg, Statement.Text,Line, Stop, doRollBack);
  end;
end;

procedure TibBTDRVPlayer.DoOnStmntExecute(Sender: TObject;Line:Integer; StatementNo: Integer;  Desc:TStatementDesc;
    Statement: TStrings);
begin
  if Assigned(FDRVPlayerNotification) then
      FDRVPlayerNotification.BeforeExecuteStmnt(Self as IibSHDRVPlayer,
        StatementNo,Line
      );


//      FDRVPlayerNotification.AfterExecute(Self as IibSHDRVPlayer, nil,Statement.Text );
end;



{$ENDIF}



constructor TibBTDRVPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF  TRIFONOV}
   FPlayer := TpFIBScript.Create(nil);
   FPlayer.OnParse := DoOnParse;
   FPlayer.AfterExecute := DoAfterExecute;
   FPlayer.Statistics := False;
  {$ELSE}
  FPlayer:=TpFIBScripter.Create(nil);
  FPlayer.OnExecuteError := DoOnExecuteError;
  FPlayer.BeforeStatementExecute :=DoOnStmntExecute ;
  {$ENDIF}


  FDRVDatabase := nil;
// DEBUG  FPlayer.LastDDLQueryLog := 'c:\1.txt';
end;

destructor TibBTDRVPlayer.Destroy;
begin
  FPlayer.OnExecuteError := nil;
  {$IFDEF  TRIFONOV}
   FPlayer.OnParse := nil;
   FPlayer.AfterExecute := nil;
  {$ENDIF}

  FreeAndNil(FPlayer);
  inherited Destroy;
end;

procedure TibBTDRVPlayer.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent.IsImplementorOf(FDRVDatabase) then
    begin
      FDRVDatabase := nil;
      FPlayer.Database := nil;
    end else
    if AComponent.IsImplementorOf(FDRVTransaction) then
    begin
      FDRVTransaction := nil;
  {$IFDEF  TRIFONOV}
      FPlayer.Transaction := nil;
  {$ENDIF}
    end
    else
    if AComponent.IsImplementorOf(FDRVSQLParser) then
    begin
      FDRVSQLParser := nil;
  {$IFDEF  TRIFONOV}
      FPlayer.SQLParser := nil;
  {$ENDIF}
    end else
    if AComponent.IsImplementorOf(FDRVPlayerNotification) then
      FDRVPlayerNotification := nil;
  end;
end;

function TibBTDRVPlayer.GetAutoDDL: Boolean;
begin
  Result := FPlayer.AutoDDL;
end;

procedure TibBTDRVPlayer.SetAutoDDL(Value: Boolean);
begin
  FPlayer.AutoDDL := Value;
end;

function TibBTDRVPlayer.GetScript: TStrings;
begin
  Result := FPlayer.Script;
end;

function TibBTDRVPlayer.GetPaused: Boolean;
begin
  Result := FPlayer.Paused;
end;

procedure TibBTDRVPlayer.SetPaused(Value: Boolean);
begin
  FPlayer.Paused := Value;
end;

function TibBTDRVPlayer.GetDatabase: IibSHDRVDatabase;
begin
  Result := FDRVDatabase;
end;

procedure TibBTDRVPlayer.SetDatabase(const Value: IibSHDRVDatabase);
begin
  if FDRVDatabase <> Value then
  begin
    if Assigned(FDRVDatabase) then
      ReferenceInterface(FDRVDatabase, opRemove);
    FDRVDatabase := Value;
    if Assigned(FDRVDatabase) then
      ReferenceInterface(FDRVDatabase, opInsert);
    if Assigned(FDRVDatabase) then
      FPlayer.Database := TpFIBDatabase(FDRVDatabase.GetNativeDAC)
    else
      FPlayer.Database := nil;
  end;
end;

function TibBTDRVPlayer.GetTransaction: IibSHDRVTransaction;
begin
  Result := FDRVTransaction;
end;

procedure TibBTDRVPlayer.SetTransaction(
  const Value: IibSHDRVTransaction);
begin
  if FDRVTransaction <> Value then
  begin
    if Assigned(FDRVTransaction) then
      ReferenceInterface(FDRVTransaction, opRemove);
    FDRVTransaction := Value;
    if Assigned(FDRVTransaction) then
      ReferenceInterface(FDRVTransaction, opInsert);
  {$IFDEF  TRIFONOV}
    if Assigned(FDRVTransaction) then
      FPlayer.Transaction := TpFIBTransaction(FDRVTransaction.GetNativeDAC)
    else
      FPlayer.Transaction := nil;
  {$ENDIF}
  end;
end;

function TibBTDRVPlayer.GetSQLDialect: Integer;
begin
  {$IFDEF  TRIFONOV}
  Result := FPlayer.SQLDialect;
  {$ENDIF}
end;

procedure TibBTDRVPlayer.SetSQLDialect(Value: Integer);
begin
  {$IFDEF  TRIFONOV}
  FPlayer.SQLDialect := Value;
  {$ENDIF}    
end;

function TibBTDRVPlayer.GetParser: IibSHDRVSQLParser;
begin
  Result := FDRVSQLParser;
end;

procedure TibBTDRVPlayer.SetParser(Value: IibSHDRVSQLParser);
begin
  if FDRVSQLParser <> Value then
  begin
    ReferenceInterface(FDRVSQLParser, opRemove);
    FDRVSQLParser := Value;
    ReferenceInterface(FDRVSQLParser, opInsert);
{$IFDEF  TRIFONOV}
    if Assigned(Value) then
      FPlayer.SQLParser := TpFIBSQLParser(Value.GetNativeDAC)
    else
      FPlayer.SQLParser := nil;
{$ENDIF}

  end;
end;

function TibBTDRVPlayer.GetPlayerNotification: IibSHDRVPlayerNotification;
begin
  Result := FDRVPlayerNotification;
end;

procedure TibBTDRVPlayer.SetPlayerNotification(
  Value: IibSHDRVPlayerNotification);
begin
  if FDRVPlayerNotification <> Value then
  begin
    ReferenceInterface(FDRVPlayerNotification, opRemove);
    FDRVPlayerNotification := Value;
    ReferenceInterface(FDRVPlayerNotification, opInsert);
  end;
end;

function TibBTDRVPlayer.GetLineProceeding: Integer;
begin
  {$IFDEF  TRIFONOV}
   Result := FPlayer.LineProceeding;
  {$ELSE}
  
  {$ENDIF}
end;

function TibBTDRVPlayer.GetInputStringCount: Integer;
begin
  {$IFDEF  TRIFONOV}
  Result := FPlayer.InputStringCount;
  {$ENDIF}
end;

function TibBTDRVPlayer.GetTerminator: string;
begin
  {$IFDEF  TRIFONOV}
  Result := FPlayer.Terminator;
    {$ENDIF}
end;

procedure TibBTDRVPlayer.SetTerminator(const Value: string);
begin
  {$IFDEF  TRIFONOV}
  FPlayer.Terminator := Value;
    {$ENDIF}  
end;

procedure TibBTDRVPlayer.Execute;
begin
  try
    FPlayer.ExecuteScript;
  except
    on E: Exception do
     ErrorText := E.Message;
  end;
  FPlayer.Script.Clear;
end;

initialization
  SHRegisterComponents([
    TibBTDRVDatabase, TibBTDRVTransaction, TibBTDRVQuery, TibBTDRVDataset,
    TibBTDRVMonitor, TibBTDRVService,
    TibBTDRVSQLParser, TibBTDRVPlayer, TibBTDRVStatistics]);
end.

