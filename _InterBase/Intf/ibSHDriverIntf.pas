unit ibSHDriverIntf;

interface

uses
  SHDesignIntf,
  SysUtils, Classes, DB, Graphics, Types;

type
  TibErrorCode= record
   SQLCode    :Integer;
   IBErrorCode:Integer;
  end;

  IibSHDRV = interface(ISHDRVNativeDAC)
  ['{98EFE313-1125-4220-9BDE-E95ADEA8EEB5}']
    function GetErrorText: string;
    function GetLastErrorCode:TibErrorCode;

    property ErrorText: string read GetErrorText;
    property LastErrorCode:TibErrorCode read GetLastErrorCode;
  end;

  IibSHDRVDatabase = interface(IibSHDRV)
  ['{86D7A41A-2CA0-4AEA-BF0F-CA5C4C4AD343}']
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

    function Connect: Boolean;
    function Reconnect: Boolean;
    function Disconnect: Boolean;
    procedure CreateDatabase;
    procedure DropDatabase;
    function TestConnection: Boolean;
    procedure ClearCache;
    function IsFirebirdConnect:boolean;


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

    // for Services
    property ODSVersion: string read GetODSVersion;
    property PageSize: Integer read GetPageSize;
    property AllocationPages: Integer read GetAllocationPages;
    property PageBuffers: Integer read GetPageBuffers;
    property SweepInterval: Integer read GetSweepInterval;
    property ForcedWrites: Boolean read GetForcedWrites;
    property ReadOnly: Boolean read GetReadOnly;
  end;

  IibSHDRVQuery = interface;
  
  IibSHDRVDatabaseExt= interface
   ['{C43EC85D-4954-47CE-A2E6-E5CEEE424DB3}']
   //Buzz
     function GetRecordCountSelect(const ForSQL:string):string;
     function IsTableOrView(const ObjectName:string):boolean;
  end;

  IibSHDRVTransactionNotification = interface;

  IibSHDRVTransaction = interface(IibSHDRV)
  ['{49FD11E9-6F83-4278-AFCF-16B0612C139A}']
    function GetNativeDAC: TObject;
    function GetDatabase: IibSHDRVDatabase;
    procedure SetDatabase(const Value: IibSHDRVDatabase);
    function GetParams: TStrings;
    procedure SetParams(Value: TStrings);
    function GetTransactionNotification: IibSHDRVTransactionNotification;
    procedure SetTransactionNotification(Value: IibSHDRVTransactionNotification);

    function InTransaction: Boolean;
    procedure StartTransaction;
    function Commit: Boolean;
    function CommitRetaining: Boolean;
    function Rollback: Boolean;
    function RollbackRetaining: Boolean;

    property Database: IibSHDRVDatabase read GetDatabase write SetDatabase;
    property Params: TStrings read GetParams write SetParams;
    property TransactionNotification: IibSHDRVTransactionNotification
      read GetTransactionNotification write SetTransactionNotification;
  end;

  TibSHTransactionAction  = (shtaRollback, shtaCommit);

  IibSHDRVTransactionNotification = interface
  ['{E36EB3DF-182E-43EA-8E18-DA078E313122}']
    procedure AfterEndTransaction(ATransaction: IibSHDRVTransaction;
      ATransactionAction: TibSHTransactionAction);
  end;


  IibSHDRVQuery = interface(IibSHDRV)
  ['{F7E49604-F184-49B9-908F-62B7020FC520}']
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

    function ExecSQL(const SQLText: string; const AParams: array of Variant; AutoCommit: Boolean; KeepPrepared:boolean=False ): Boolean;
//    function ExecSQL(const SQLText: string; const AParams: array of Variant; AutoCommit: Boolean): Boolean;

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
  end;


  IibDRVDatasetNotification = interface;

  IibSHDRVDataset = interface(IibSHDRV)
  ['{EE948FF6-D1EC-4946-8911-BA60C964AAEC}']
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
    function GetPlan: string;
    function GetDataModified: Boolean;
    function GetDatasetNotification: IibDRVDatasetNotification;
    procedure SetDatasetNotification(Value: IibDRVDatasetNotification);
    function GetIsFetching: Boolean;
    procedure SetIsFetching(Value: Boolean);
    function GetIsEmpty: Boolean;
    function GetFilter: string;
    procedure SetFilter(Value: string);

    function  GetRelationTableName(FieldIndex: Integer):string;
    function  GetRelationFieldName(FieldIndex: Integer):string;

    function Prepare: Boolean;
    procedure Open;
    procedure FetchAll;
    procedure Close;
    procedure CrearAllSQLs;
    procedure GenerateSQLs(const ATableName, AKeyFields: string; AllFieldsUsed: Boolean);
    procedure SetAutoGenerateSQLsParams(const ATableName, AKeyFields: string; AllFieldsUsed: Boolean);
    procedure DoSort(Fields: array of const; Ordering: array of Boolean);
    function GetDebugFieldValue(Index:integer): Variant;
    property Active: Boolean read GetActive write SetActive;
    property AutoCommit: Boolean read GetAutoCommit write SetAutoCommit;
    property Database: IibSHDRVDatabase read GetDatabase write SetDatabase;
    property ReadTransaction: IibSHDRVTransaction read GetReadTransaction write SetReadTransaction;
    property WriteTransaction: IibSHDRVTransaction read GetWriteTransaction write SetWriteTransaction;
    property SelectSQL: TStrings read GetSelectSQL write SetSelectSQL;
    property InsertSQL: TStrings read GetInsertSQL write SetInsertSQL;
    property UpdateSQL: TStrings read GetUpdateSQL write SetUpdateSQL;
    property DeleteSQL: TStrings read GetDeleteSQL write SetDeleteSQL;
    property RefreshSQL: TStrings read GetRefreshSQL write SetRefreshSQL;
    property Dataset: TDataset read GetDataset;
    property Plan: string read GetPlan;
    property DataModified: Boolean read GetDataModified;
    property IsFetching: Boolean read GetIsFetching write SetIsFetching;
    property IsEmpty: Boolean read GetIsEmpty;
    property Filter: string read GetFilter write SetFilter;

    property DatasetNotification: IibDRVDatasetNotification
      read GetDatasetNotification
      write SetDatasetNotification;
  end;

  IibDRVDatasetNotification = interface
  ['{C1793100-6553-489E-AB82-31B5691AAA0F}']

    procedure AfterOpen(ADataset: IibSHDRVDataset);
    procedure OnFetchRecord(ADataset: IibSHDRVDataset);
    procedure OnError(ADataset: IibSHDRVDataset);

  end;

  TibSHOnSQLNotify = procedure (EventText: String; EventTime: TDateTime) of object;

  IibSHDRVMonitor = interface(IibSHDRV)
  ['{7CC54C4F-5F1A-49FF-9281-CB485EA64005}']
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

  IibSHDRVSQLParserNotification = interface;

  IibSHDRVSQLParser = interface(IibSHDRV)
  ['{EB0EE766-2DB5-441D-9B19-2E741803EE5D}']
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

    property Script: TStrings read GetScript;
    property Count: Integer read GetCount;
    property Statements[Index: Integer]: string read GetStatements;
    property Terminator: string read GetTerminator write SetTerminator;

    property SQLParserNotification: IibSHDRVSQLParserNotification
      read GetSQLParserNotification write SetSQLParserNotification;

  end;

  IibSHDRVSQLParserNotification = interface
  ['{85110C56-F6C8-4445-BF22-D39E68FC36E7}']
    procedure OnParse(ASQLParser: IibSHDRVSQLParser);
  end;

  IibSHDRVPlayerNotification = interface;

  IibSHDRVPlayer = interface(IibSHDRV)
  ['{4E45A517-151C-4784-BD78-CE41C0CACD35}']

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

    property AutoDDL: Boolean read GetAutoDDL write SetAutoDDL;
    property Script: TStrings read GetScript;
    property Paused: Boolean read GetPaused write SetPaused;
    property Database: IibSHDRVDatabase read GetDatabase write SetDatabase;
    property Transaction: IibSHDRVTransaction read GetTransaction
      write SetTransaction;
    property SQLDialect: Integer read GetSQLDialect write SetSQLDialect;

    property Parser: IibSHDRVSQLParser read GetParser write SetParser;

    property PlayerNotification: IibSHDRVPlayerNotification
      read GetPlayerNotification write SetPlayerNotification;
    property LineProceeding: Integer read GetLineProceeding;
    property InputStringCount: Integer read GetInputStringCount;
    property Terminator: string read GetTerminator write SetTerminator;

  end;

  IibSHDRVPlayerNotification = interface
  ['{A0C61F2B-9981-4578-BFC7-497B36F41A3D}']
    procedure OnParse(APlayer: IibSHDRVPlayer;const ASQLText: string;
      ALineIndex: Integer);
    procedure OnError(APlayer: IibSHDRVPlayer; const AError: string;
      const ASQLText: string; ALineIndex: Integer; var DoAbort: Boolean;
      var DoRollbackOnError: Boolean);
    procedure AfterExecute(APlayer: IibSHDRVPlayer; ATokens: TStrings;
      const ASQLText: string);

    procedure BeforeExecuteStmnt(APlayer: IibSHDRVPlayer;
     StmntNo:integer;AScriptLine: Integer
    );

  end;


  TibSHServiceType = (stUnknown, stServerProperties, stConfigService, stLicensingService,
                      stLogService, stStatisticalService, stBackupService,
                      stRestoreService, stValidationService, stSecurityService);

  IibSHDRVService = interface(IibSHDRV)
  ['{BE2EA9C1-22B4-47E4-AE4D-F06EA39B2DC1}']
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
    function GetISCCFG_XXX_KEY(AKey: Integer): Integer; // Look "Server configuration key values" in ibase.pas

    // Server Log
    function DisplayServerLog: Boolean;
    // Database Statistics
    // AStopIndex = { 0 (Header Page) | 1 (Log Pages) | 2 (Index Pages) | 3 (Data Pages) | 4 (System Relations)}
    function DisplayDatabaseStatistics(const AStopIndex: Integer; ATableName: string = ''): Boolean;
    // Database Validations
    function DisplayDatabaseValidation(const ARecordFragments, AReadOnly, AIgnoreChecksum, AKillShadows: Boolean): Boolean;
    function DisplayDatabaseSweep(const AIgnoreChecksum: Boolean): Boolean;
    function DisplayDatabaseMend(const AIgnoreChecksum: Boolean): Boolean;
    function DisplayLimboTransactions: Boolean;
    function GetLimboTransactionCount: Integer;
    function GetLimboTransactionMultiDatabase(const AIndex: Integer): Boolean;
    function GetLimboTransactionID(const AIndex: Integer): Integer;
    function GetLimboTransactionHostSite(const AIndex: Integer): string;
    function GetLimboTransactionRemoteSite(const AIndex: Integer): string;
    function GetLimboTransactionRemoteDatabasePath(const AIndex: Integer): string;
    function GetLimboTransactionState(const AIndex: Integer): string;
    function GetLimboTransactionAdvise(const AIndex: Integer): string;
    function GetLimboTransactionAction(const AIndex: Integer): string;

    // Database Online
    function DisplayDatabaseOnline: Boolean;
    // Database Shutdown
    // AModeIndex = { 0 (Forced) | 1 (DenyTransaction) | 2 (DenyAttachment) }
    function DisplayDatabaseShutdown(const AModeIndex, ATimeout: Integer): Boolean;
    // Database Backup
    function DisplayBackup(const ASourceFileList, ADestinationFileList: TStrings;
      const ATransportable, AMetadataOnly, ANoGarbageCollect, AIgnoreLimboTrans,
      AIgnoreChecksums, AOldMetadataDesc, AConvertExtTables, AVerbose: Boolean): Boolean;
    // Database Restore
    function DisplayRestore(const ASourceFileList, ADestinationFileList: TStrings;
      const APageSize: Integer;
      const AReplaceExisting, AMetadataOnly, ACommitEachTable, AWithoutShadow,
      ADeactivateIndexes, ANoValidityCheck, AUseAllSpace, AVerbose: Boolean): Boolean;
    // Database Properties
    procedure SetPageBuffers(Value: Integer);
    procedure SetSQLDialect(Value: Integer);
    procedure SetSweepInterval(Value: Integer);
    procedure SetForcedWrites(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);

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

  IibSHDRVParams = interface
  ['{4098C522-09B8-41FF-AE70-8CD433FAE991}']
    function GetParamByIndex(Index: Integer): Variant;
    procedure SetParamByIndex(Index: Integer; Value: Variant);
    function GetParamIsNull(Index: Integer): Boolean;
    procedure SetParamIsNull(Index: Integer; Value: Boolean);
    function GetParamCount: Integer;

    function ParamExists(const ParamName: string): Boolean;
    function ParamName(ParamNo: Integer): string;
    function GetParamSize(const ParamName: string): Integer; overload;
    function GetParamSize(ParamNo: Integer): Integer; overload;
    function GetParamByName(const ParamName: string): Variant;
    procedure SetParamByName(const ParamName: string; Value: Variant);

    property ParamByIndex[Index: Integer]: Variant read GetParamByIndex write SetParamByIndex;
    property ParamIsNull[Index: Integer]: Boolean read GetParamIsNull write SetParamIsNull;
    property ParamCount: Integer read GetParamCount;
  end;

  IibSHDRVExecTimeStatistics = interface
  ['{E29DB38E-A88E-4452-9814-9B2284D15AB6}']
    function GetPrepareTime: Cardinal;
    function GetExecuteTime: Cardinal;
    function GetFetchTime: Cardinal;

    property PrepareTime: Cardinal read GetPrepareTime;
    property ExecuteTime: Cardinal read GetExecuteTime;
    property FetchTime: Cardinal read GetFetchTime;
  end;

  IibSHDRVTableStatistics = interface
  ['{BD0D09F4-C0A8-4CC5-AFFA-7DD0622DAE7C}']
    function GetTableName: string;
    function GetIdxReads: Integer;
    function GetSeqReads: Integer;
    function GetUpdates: Integer;
    function GetInserts: Integer;
    function GetDeletes: Integer;
    function GetBackout: Integer;
    function GetExpunge: Integer;
    function GetPurge: Integer;

    property TableName: string read GetTableName;
    property IdxReads: Integer read GetIdxReads;
    property SeqReads: Integer read GetSeqReads;
    property Updates: Integer read GetUpdates;
    property Inserts: Integer read GetInserts;
    property Deletes: Integer read GetDeletes;

    property Backout: Integer read GetBackout;
    property Expunge: Integer read GetExpunge;
    property Purge: Integer read GetPurge;
  end;

  IibSHDRVStatistics = interface(IibSHDRV)
  ['{12C20D76-0200-4334-A4C2-A98C655F64E8}']
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

    property IdxReads: Integer read GetIdxReads;
    property SeqReads: Integer read GetSeqReads;
    property Updates: Integer read GetUpdates;
    property Deletes: Integer read GetDeletes;
    property Inserts: Integer read GetInserts;
    property AllFetches: Integer read GetAllFetches;
    property Fetches: Integer read GetFetches;
    property AllMarks: Integer read GetAllMarks;
    property Marks: Integer read GetMarks;
    property AllReads: Integer read GetAllReads;
    property Reads: Integer read GetReads;
    property AllWrites: Integer read GetAllWrites;
    property Writes: Integer read GetWrites;
    property TableStatistics[Index: Integer]: IibSHDRVTableStatistics read GetTableStatistics;
    property TablesCount: Integer read GetTablesCount;
    property SnapshotTime: TDateTime read GetSnapshotTime;

    property CurrentMemory: Integer read GetCurrentMemory;
    property MaxMemory: Integer read GetMaxMemory;
    property NumBuffers: Integer read GetNumBuffers;
    property DatabasePageSize: Integer read GetDatabasePageSize;

    property Database: IibSHDRVDatabase read GetDatabase write SetDatabase;
  end;

  IibSHDRVDatabase_FIBPlus = interface(IibSHDRVDatabase)
  ['{314488D2-EF47-417F-8701-5CB6CD75A737}']
  end;

  IibSHDRVTransaction_FIBPlus = interface(IibSHDRVTransaction)
  ['{E43739F3-C63A-4A84-80D0-8AA44C9A8BC0}']
  end;

  IibSHDRVQuery_FIBPlus = interface(IibSHDRVQuery)
  ['{7D90548B-714C-444A-9C44-6A45B77F2E52}']
  end;

  IibSHDRVDataset_FIBPlus = interface(IibSHDRVDataset)
  ['{93EDEE15-D234-4D57-B02E-3C077C13A453}']
  end;

  IibSHDRVMonitor_FIBPlus = interface(IibSHDRVMonitor)
  ['{05549889-7EF9-4410-9D0B-77F3A18F8D6A}']
  end;

  IibSHDRVService_FIBPLus = interface(IibSHDRVService)
  ['{5FF3A6CF-CFE9-4E53-A11B-C363ADEAA479}']
  end;

  IibSHDRVDatabase_FIBPlus68 = interface(IibSHDRVDatabase)
  ['{3BB5B212-0374-4529-A8F5-4065B9B9F561}']
  end;

  IibSHDRVTransaction_FIBPlus68 = interface(IibSHDRVTransaction)
  ['{42763643-3BE6-4ABB-8EB6-B5A89903D3FF}']
  end;

  IibSHDRVQuery_FIBPlus68 = interface(IibSHDRVQuery)
  ['{688C077E-4044-46DA-803A-1E45BCB5720E}']
  end;

  IibSHDRVDataset_FIBPlus68 = interface(IibSHDRVDataset)
  ['{4049B56F-BD1C-465E-BE2F-067A8A7042F3}']
  end;

  IibSHDRVMonitor_FIBPlus68 = interface(IibSHDRVMonitor)
  ['{2D3A7681-0896-446F-A33D-2DB63D493A1F}']
  end;

  IibSHDRVService_FIBPlus68 = interface(IibSHDRVService)
  ['{3F0B07E2-C18A-41C8-B7FA-1E941AD6F78A}']
  end;

  IibSHDRVMonitor_IBX = interface(IibSHDRVMonitor)
  ['{89EC6331-73ED-472C-9D0D-A5DA26B12C18}']
  end;

//  IibSHDRVSQLParser_IBX = interface(IibSHDRVSQLParser)
//  ['{08B7AB43-AAF8-4EA4-A6AE-B3681456A5CD}']
//  end;

  IibSHDRVSQLParser_FIBPlus = interface(IibSHDRVSQLParser)
  ['{3DCD4565-B0AD-4D2D-AFBA-261BCE90DDA2}']
  end;

  IibSHDRVSQLParser_FIBPlus68 = interface(IibSHDRVSQLParser)
  ['{E806620E-A425-48F4-B320-9CE619AA95A8}']
  end;

  IibSHDRVPlayer_FIBPlus = interface(IibSHDRVPlayer)
  ['{A656547A-6FC4-4FA7-B549-9820AB4E0304}']
  end;

  IibSHDRVPlayer_FIBPlus68 = interface(IibSHDRVPlayer)
  ['{9CADD7EF-758B-4747-8B3A-9A38FA1B5101}']
  end;

  IibSHDRVStatistics_FIBPlus = interface(IibSHDRVStatistics)
  ['{9756CD2B-5DA6-44D4-BD4F-107003B82D5D}']
  end;

  IibSHDRVStatistics_FIBPlus68 = interface(IibSHDRVStatistics)
  ['{B8B51A8B-1A9E-4BAB-A7F9-F4947B210F00}']
  end;


implementation

end.
