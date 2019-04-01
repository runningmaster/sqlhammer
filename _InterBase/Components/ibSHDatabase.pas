unit ibSHDatabase;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs, Graphics, StrUtils, ExtCtrls,
  SHDesignIntf, TypInfo,
  ibSHDesignIntf, ibSHDriverIntf, ibSHComponent, ibSHDatabaseAliasOptions;

type
  TibSHDatabase = class(TibBTComponent, IibSHDatabase, ISHDatabase, ISHRegistration,
    ISHTestConnection, ISHDataRootDirectory, ISHNavigatorNotify,
    IibBTDataBaseExt
    )
  private
    FBTCLServer: IibSHServer;

    FDRVDatabase: TSHComponent;
    FDRVTransaction: TSHComponent;
    FDRVQuery: TSHComponent;
    // Блядство - FIBPlus не умеет работать со всеми версиями InterBase
    FDRVDatabase2: TSHComponent;
    FDRVTransaction2: TSHComponent;
    FDRVQuery2: TSHComponent;

    FServer: string;
    FDatabase: string;
    FAlias: string;
    FPageSize: string;
    FCharset: string;
    FSQLDialect: Integer;
    FUserName: string;
    FPassword: string;
    FRole: string;
    FLoginPrompt: Boolean;
    FAdditionalConnectParams: TStrings;
    FCapitalizeNames: Boolean;
    FDescription: string;
    FStillConnect: Boolean;
    FDatabaseAliasOptions: TibSHDatabaseAliasOptions;
    FDatabaseAliasOptionsInt: TibSHDatabaseAliasOptionsInt;

    FExistsPrecision: Boolean;
    FExistsProcParamDomains:Boolean;
    FDBCharset: string;
    FWasLostConnect: Boolean;
    FDirectoryIID: string;

    FClassIIDList: TStrings;
    FClassIIDList2: TStrings; // for Jumps
    FDomainList: TStrings;
    FSystemDomainList: TStrings;
    FTableList: TStrings;
    FSystemTableList: TStrings;
    FSystemTableTmpList: TStrings;
//Constraint*    FConstraintList: TStrings;
    FIndexList: TStrings;
    FViewList: TStrings;
    FProcedureList: TStrings;
    FTriggerList: TStrings;
    FGeneratorList: TStrings;
    FExceptionList: TStrings;
    FFunctionList: TStrings;
    FFilterList: TStrings;
    FRoleList: TStrings;
    FShadowList: TStrings;
    FAllNameList: TStrings;
    procedure CreateDRV;
    procedure FreeDRV;
    procedure PrepareDRVDatabase;
    procedure PrepareDBObjectLists;
    procedure CreateDatabase;
    procedure DropDatabase;
    function ExistsInDatabase(const AClassIID: TGUID; const ACaption: string): Boolean;
    function ChangeNameList(const AClassIID: TGUID; const ACaption: string; Operation: TOperation): Boolean;
    procedure OnLostConnect(Sender: TObject);
  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;

    function GetBranchIID: TGUID; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoOnApplyOptions; override;

    function GetBTCLServer: IibSHServer;
    procedure SetBTCLServer(const Value: IibSHServer);
    function GetDRVDatabase: IibSHDRVDatabase;
    function GetDRVTransaction: IibSHDRVTransaction;
    function GetDRVQuery: IibSHDRVQuery;

    function GetServer: string;
    procedure SetServer(Value: string);
    function GetDatabase: string;
    procedure SetDatabase(Value: string);
    function GetAlias: string;
    procedure SetAlias(Value: string);
    function GetPageSize: string;
    procedure SetPageSize(Value: string);
    function GetCharset: string;
    procedure SetCharset(Value: string);
    function GetSQLDialect: Integer;
    procedure SetSQLDialect(Value: Integer);
    function GetCapitalizeNames: Boolean;
    procedure SetCapitalizeNames(Value: Boolean);
    function GetAdditionalConnectParams: TStrings;
    procedure SetAdditionalConnectParams(Value: TStrings);
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
    function GetStillConnect: Boolean;
    procedure SetStillConnect(Value: Boolean);
    function GetDirectoryIID: string;
    procedure SetDirectoryIID(Value: string);
    function GetDatabaseAliasOptions: IibSHDatabaseAliasOptions;
    function GetExistsPrecision: Boolean;
    function GetExistsProcParamDomains: Boolean;
    function GetDBCharset: string;
    function GetWasLostConnect: Boolean;

    function GetCaption: string; override;
    function GetCaptionExt: string; override;
    procedure SetOwnerIID(Value: TGUID); override;

    // ISHDatabase
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

    // ISHTestConnection
    function GetCanTestConnection: Boolean;
    function TestConnection: Boolean;
    // ISHDataRootDirectory
    function GetDataRootDirectory: string;
    function CreateDirectory(const FileName: string): Boolean;
    function RenameDirectory(const OldName, NewName: string): Boolean;
    function DeleteDirectory(const FileName: string): Boolean;
    // ISHNavigatorNotify
    function GetFavoriteObjectNames: TStrings;
    function GetFavoriteObjectColor: TColor;
    function GetFilterList: TStrings;
    function GetFilterIndex: Integer;
    procedure SetFilterIndex(Value: Integer);


//IibBTDataBaseExt

    procedure GetObjectsHaveComment(ClassObject:TGUID;Results:TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property BTCLServer: IibSHServer read GetBTCLServer write SetBTCLServer;
    property DRVDatabase: IibSHDRVDatabase read GetDRVDatabase;
    property DRVTransaction: IibSHDRVTransaction read GetDRVTransaction;
    property DRVQuery: IibSHDRVQuery read GetDRVQuery;

    property StillConnect: Boolean read GetStillConnect write SetStillConnect;
    property Connected: Boolean read GetConnected;
    property CanConnect: Boolean read GetCanConnect;
    property CanReconnect: Boolean read GetCanReconnect;
    property CanDisconnect: Boolean read GetCanDisconnect;
    property CanShowRegistrationInfo: Boolean read GetCanShowRegistrationInfo;

    property ClassIIDList: TStrings read FClassIIDList;
    property ClassIIDList2: TStrings read FClassIIDList2;
    property SystemDomainList: TStrings read FSystemDomainList;
    property DomainList: TStrings read FDomainList;
    property TableList: TStrings read FTableList;
    property SystemTableList: TStrings read FSystemTableList;
    property SystemTableTmpList: TStrings read FSystemTableTmpList;
//Constraint*    property ConstraintList: TStrings read FConstraintList;
    property IndexList: TStrings read FIndexList;
    property ViewList: TStrings read FViewList;
    property ProcedureList: TStrings read FProcedureList;
    property TriggerList: TStrings read FTriggerList;
    property GeneratorList: TStrings read FGeneratorList;
    property ExceptionList: TStrings read FExceptionList;
    property FunctionList: TStrings read FFunctionList;
    property FilterList: TStrings read FFilterList;
    property RoleList: TStrings read FRoleList;
    property ShadowList: TStrings read FShadowList;
    property AllNameList: TStrings read FAllNameList;
    property ExistsPrecision: Boolean read GetExistsPrecision;
    property WasLostConnect: Boolean read GetWasLostConnect;
  published
    property Server: string read  GetServer write SetServer;
    property Database: string read GetDatabase write SetDatabase;
    property Alias: string read GetAlias write SetAlias;
    property PageSize: string read GetPageSize write SetPageSize;
    property Charset: string read GetCharset write SetCharset;
    property DBCharset: string read GetDBCharset;
    property SQLDialect: Integer read GetSQLDialect write SetSQLDialect;
    property CapitalizeNames: Boolean read GetCapitalizeNames
      write SetCapitalizeNames;
    property AdditionalConnectParams: TStrings read GetAdditionalConnectParams
      write SetAdditionalConnectParams;
    property UserName: string read GetUserName write SetUserName;
    property Password: string read GetPassword write SetPassword;
    property Role: string read GetRole write SetRole;
    property LoginPrompt: Boolean read GetLoginPrompt write SetLoginPrompt;
    property Description: string read GetDescription write SetDescription;
    property ConnectPath: string read GetConnectPath;
    property DatabaseAliasOptions: TibSHDatabaseAliasOptions read FDatabaseAliasOptions
      write FDatabaseAliasOptions;
    // invisible
    property DatabaseAliasOptionsInt: TibSHDatabaseAliasOptionsInt read FDatabaseAliasOptionsInt
      write FDatabaseAliasOptionsInt;
    property DirectoryIID: string read GetDirectoryIID write SetDirectoryIID;
  end;

  TfibSHDatabaseOptions = class(TSHComponentOptions, IibSHDatabaseOptions, IibSHDummy)
  private
    FCharset: string;
    FCapitalizeNames: Boolean;
  protected
    function GetCharset: string;
    procedure SetCharset(Value: string);
    function GetCapitalizeNames: Boolean;
    procedure SetCapitalizeNames(Value: Boolean);

    function GetParentCategory: string; override;
    function GetCategory: string; override;
    procedure RestoreDefaults; override;
  published
    property Charset: string read FCharset write FCharset;
    property CapitalizeNames: Boolean read FCapitalizeNames write FCapitalizeNames;
  end;

  TibSHDatabaseOptions = class(TfibSHDatabaseOptions, IibSHDatabaseOptions, IibSHBranch)
  end;

  TfbSHDatabaseOptions = class(TfibSHDatabaseOptions, IfbSHDatabaseOptions, IfbSHBranch)
  end;

implementation

uses
  ibSHValues, ibSHSQLs, ibSHConsts, ibSHMessages;

{ TibSHDatabase }

constructor TibSHDatabase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAdditionalConnectParams := TStringList.Create;
  FDirectoryIID := GUIDToString(InstanceIID);
  FDatabaseAliasOptions := TibSHDatabaseAliasOptions.Create;
  FDatabaseAliasOptionsInt := TibSHDatabaseAliasOptionsInt.Create;

  PageSize := Format('%s', [S4096]);
  Charset := CharsetsAndCollatesFB10[0, 0];
  UserName := Format('%s', [SDefaultUserName]);
  Password := Format('%s', [SDefaultPassword]);
  SQLDialect := 3;
  CapitalizeNames := True;

  MakePropertyInvisible('DBCharset');
  MakePropertyInvisible('SQLDialect');
  MakePropertyInvisible('PageSize');
  MakePropertyInvisible('CapitalizeNames');
  MakePropertyInvisible('DirectoryIID');
  MakePropertyInvisible('DatabaseAliasOptionsInt');

  FClassIIDList := TStringList.Create;
  FClassIIDList2 := TStringList.Create;
  FDomainList := TStringList.Create;
  FSystemDomainList := TStringList.Create;
  FTableList := TStringList.Create;
  FSystemTableList := TStringList.Create;
  FSystemTableTmpList := TStringList.Create;
//Constraint*  FConstraintList := TStringList.Create;
  FIndexList := TStringList.Create;
  FViewList := TStringList.Create;
  FProcedureList := TStringList.Create;
  FTriggerList := TStringList.Create;
  FGeneratorList := TStringList.Create;
  FExceptionList := TStringList.Create;
  FFunctionList := TStringList.Create;
  FFilterList := TStringList.Create;
  FRoleList := TStringList.Create;
  FShadowList := TStringList.Create;
  FAllNameList := TStringList.Create;

  CreateDRV;
end;

destructor TibSHDatabase.Destroy;
begin
  FAdditionalConnectParams.Free;
  FDatabaseAliasOptionsInt.Free;
  FDatabaseAliasOptions.Free;

  FBTCLServer := nil;
  FClassIIDList.Free;
  FClassIIDList2.Free;
  FDomainList.Free;
  FSystemDomainList.Free;
  FTableList.Free;
  FSystemTableList.Free;
  FSystemTableTmpList.Free;
//Constraint*  FConstraintList.Free;
  FIndexList.Free;
  FViewList.Free;
  FProcedureList.Free;
  FTriggerList.Free;
  FGeneratorList.Free;
  FExceptionList.Free;
  FFunctionList.Free;
  FFilterList.Free;
  FRoleList.Free;
  FShadowList.Free;
  FAllNameList.Free;

  FreeDRV;
  inherited Destroy;
end;

procedure TibSHDatabase.CreateDRV;
var
  vComponentClass: TSHComponentClass;
begin
  if not Assigned(DRVDatabase) then
  begin
    // FIBPlus
    vComponentClass := Designer.GetComponent(IibSHDRVDatabase_FIBPlus);
    if Assigned(vComponentClass) then FDRVDatabase := vComponentClass.Create(Self);
    vComponentClass := Designer.GetComponent(IibSHDRVTransaction_FIBPlus);
    if Assigned(vComponentClass) then FDRVTransaction := vComponentClass.Create(Self);
    vComponentClass := Designer.GetComponent(IibSHDRVQuery_FIBPlus);
    if Assigned(vComponentClass) then FDRVQuery := vComponentClass.Create(Self);
    // FIBPlus68
    vComponentClass := Designer.GetComponent(IibSHDRVDatabase_FIBPlus68);
    if Assigned(vComponentClass) then FDRVDatabase2 := vComponentClass.Create(Self);
    vComponentClass := Designer.GetComponent(IibSHDRVTransaction_FIBPlus68);
    if Assigned(vComponentClass) then FDRVTransaction2 := vComponentClass.Create(Self);
    vComponentClass := Designer.GetComponent(IibSHDRVQuery_FIBPlus68);
    if Assigned(vComponentClass) then FDRVQuery2 := vComponentClass.Create(Self);

    if Assigned(FDRVDatabase) and Assigned(FDRVTransaction) and Assigned(FDRVQuery) then
    begin
      (FDRVTransaction as IibSHDRVTransaction).Database := FDRVDatabase as IibSHDRVDatabase;
      (FDRVTransaction as IibSHDRVTransaction).Params.Text := TRReadParams;
      (FDRVQuery as IibSHDRVQuery).Database := FDRVDatabase as IibSHDRVDatabase;
      (FDRVQuery as IibSHDRVQuery).Transaction := FDRVTransaction as IibSHDRVTransaction;
     end;

    if Assigned(FDRVDatabase2) and Assigned(FDRVTransaction2) and Assigned(FDRVQuery2) then
    begin
      (FDRVTransaction2 as IibSHDRVTransaction).Database := FDRVDatabase2 as IibSHDRVDatabase;
      (FDRVTransaction2 as IibSHDRVTransaction).Params.Text := TRReadParams;
      (FDRVQuery2 as IibSHDRVQuery).Database := FDRVDatabase2 as IibSHDRVDatabase;
      (FDRVQuery2 as IibSHDRVQuery).Transaction := FDRVTransaction2 as IibSHDRVTransaction;
    end;
  end;
end;

procedure TibSHDatabase.FreeDRV;
begin
  if Assigned(DRVDatabase) then
  begin
    if DRVTransaction.InTransaction then DRVTransaction.Rollback;
    if DRVDatabase.Connected then DRVDatabase.Disconnect;
    FreeAndNil(FDRVTransaction);
    FreeAndNil(FDRVQuery);
    FreeAndNil(FDRVDatabase);

    FreeAndNil(FDRVTransaction2);
    FreeAndNil(FDRVQuery2);
    FreeAndNil(FDRVDatabase2);
  end;
end;

procedure TibSHDatabase.PrepareDRVDatabase;
begin
  if Assigned(DRVDatabase) then
  begin
    DRVDatabase.DBParams.Clear;
    DRVDatabase.Database := Self.ConnectPath;
    DRVDatabase.Charset := Self.Charset;
    DRVDatabase.UserName := Self.UserName;
    DRVDatabase.Password := Self.Password;
    DRVDatabase.RoleName := Self.Role;
    DRVDatabase.LoginPrompt := Self.LoginPrompt;
    DRVDatabase.ClientLibrary := Self.BTCLServer.ClientLibrary;
    DRVDatabase.CapitalizeNames := Self.CapitalizeNames;
    DRVDatabase.DBParams.AddStrings(Self.AdditionalConnectParams);
    DRVDatabase.OnLostConnect := OnLostConnect;
    if Assigned(BTCLServer) then
     if  (BTCLServer.Version=SInterBase2007)
      and (BTCLServer.InstanceName<>'')
     then
      DRVDatabase.DBParams.Add('instance_name='+BTCLServer.InstanceName);
  end;
end;

procedure TibSHDatabase.PrepareDBObjectLists;

  procedure FillList(AList: TStrings; const SQL: string);
  begin
    AList.Clear;
    TStringList(AList).Sorted := False;
    if DRVQuery.ExecSQL(SQL, [], False) then
    begin
      while not DRVQuery.Eof do
      begin
        if DRVQuery.GetFieldCount>1 then
          AList.AddObject(DRVQuery.GetFieldStrValue(0),TObject(DRVQuery.GetFieldIntValue(1)))
        else
         AList.Add(DRVQuery.GetFieldStrValue(0));
        AllNameList.Add(DRVQuery.GetFieldStrValue(0));
        DRVQuery.Next;
      end;
    end;
    TStringList(AList).Sorted := True;
  end;

begin
  if Assigned(DRVDatabase) then
  begin
    SQLDialect := DRVDatabase.SQLDialect;

    if DRVQuery.ExecSQL(FormatSQL(SQL_EXISTS_PRECISION), [], False) then
      FExistsPrecision := DRVQuery.GetFieldIntValue(0) = 1;

    if DRVQuery.ExecSQL(FormatSQL(SQL_EXISTS_PROC_PARAMDOMAINS), [], False) then
      FExistsProcParamDomains := DRVQuery.GetFieldIntValue(0) = 1;

    if DRVQuery.ExecSQL(FormatSQL(SQL_GET_DB_CHARSET), [], False) then
      FDBCharset := DRVQuery.GetFieldStrValue(0);

    if Length(FDBCharset) = 0 then FDBCharset := CharsetsAndCollatesFB10[0, 0];

    AllNameList.Clear;
    TStringList(AllNameList).Sorted := False;
    if not StillConnect then
    begin
      FillList(DomainList, FormatSQL(SQL_GET_DOMAIN_NAME_LIST));
      FillList(SystemDomainList, FormatSQL(SQL_GET_SYSTEM_DOMAIN_NAME_LIST));
      FillList(TableList, FormatSQL(SQL_GET_TABLE_NAME_LIST));
      FillList(SystemTableList, FormatSQL(SQL_GET_SYSTEM_TABLE_NAME_LIST));
      FillList(SystemTableTmpList, FormatSQL(SQL_GET_SYSTEM_TABLE_TMP_NAME_LIST));
//Constraint*      FillList(ConstraintList, FormatSQL(SQL_GET_CONSTRAINT_NAME_LIST));
      FillList(IndexList, FormatSQL(SQL_GET_INDEX_NAME_LIST));
      FillList(ViewList, FormatSQL(SQL_GET_VIEW_NAME_LIST));
      FillList(ProcedureList, FormatSQL(SQL_GET_PROCEDURE_NAME_LIST));
      FillList(TriggerList, FormatSQL(SQL_GET_TRIGGER_NAME_LIST));
      FillList(GeneratorList, FormatSQL(SQL_GET_GENERATOR_NAME_LIST));
      FillList(ExceptionList, FormatSQL(SQL_GET_EXCEPTION_NAME_LIST));
      FillList(FunctionList, FormatSQL(SQL_GET_FUNCTION_NAME_LIST));
      FillList(FilterList, FormatSQL(SQL_GET_FILTER_NAME_LIST));
      FillList(RoleList, FormatSQL(SQL_GET_ROLE_NAME_LIST));
      FillList(ShadowList, FormatSQL(SQL_GET_SHADOW_NAME_LIST));
    end;
    TStringList(AllNameList).Sorted := True;

    DRVQuery.Transaction.Commit;
  end;
end;

procedure TibSHDatabase.CreateDatabase;
begin
  if Assigned(DRVDatabase) then
  begin
    DRVDatabase.Database := ConnectPath;
    DRVDatabase.SQLDialect := SQLDialect;
    DRVDatabase.ClientLibrary := BTCLServer.ClientLibrary;
    DRVDatabase.DBParams.Clear;
    DRVDatabase.DBParams.Add(Format(FormatSQL(SQL_CREATE_DATABASE_PARAMS), [UserName, Password, PageSize, Charset]));
    try
      Screen.Cursor := crHourGlass;
      DRVDatabase.CreateDatabase;
      if DRVDatabase.Connected then
        DRVDatabase.Disconnect;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TibSHDatabase.DropDatabase;
begin
  if Assigned(DRVDatabase) then
  begin
    PrepareDRVDatabase;
    if not DRVDatabase.Connected then DRVDatabase.Connect;
    DRVDatabase.DropDatabase;
    if DRVDatabase.Connected then DRVDatabase.Disconnect;
  end;
end;

function TibSHDatabase.ExistsInDatabase(const AClassIID: TGUID; const ACaption: string): Boolean;
var
  SQL: string;
begin
  Result := False;
  if IsEqualGUID(AClassIID, IibSHDomain)     then SQL := FormatSQL(SQL_EXISTS_DOMAIN_NAME) else
  if IsEqualGUID(AClassIID, IibSHTable)      then SQL := FormatSQL(SQL_EXISTS_TABLE_NAME) else
//Constraint*  if IsEqualGUID(AClassIID, IibSHConstraint) then SQL := FormatSQL(SQL_EXISTS_CONSTRAINT_NAME);
  if IsEqualGUID(AClassIID, IibSHView)       then SQL := FormatSQL(SQL_EXISTS_VIEW_NAME) else
  if IsEqualGUID(AClassIID, IibSHProcedure)  then SQL := FormatSQL(SQL_EXISTS_PROCEDURE_NAME) else
  if IsEqualGUID(AClassIID, IibSHTrigger)    then SQL := FormatSQL(SQL_EXISTS_TRIGGER_NAME) else
  if IsEqualGUID(AClassIID, IibSHGenerator)  then SQL := FormatSQL(SQL_EXISTS_GENERATOR_NAME) else
  if IsEqualGUID(AClassIID, IibSHException)  then SQL := FormatSQL(SQL_EXISTS_EXCEPTION_NAME) else
  if IsEqualGUID(AClassIID, IibSHFunction)   then SQL := FormatSQL(SQL_EXISTS_FUNCTION_NAME) else
  if IsEqualGUID(AClassIID, IibSHFilter)     then SQL := FormatSQL(SQL_EXISTS_FILTER_NAME) else
  if IsEqualGUID(AClassIID, IibSHRole)       then SQL := FormatSQL(SQL_EXISTS_ROLE_NAME) else
  if IsEqualGUID(AClassIID, IibSHIndex)      then SQL := FormatSQL(SQL_EXISTS_INDEX_NAME) else
  if IsEqualGUID(AClassIID, IibSHShadow)     then SQL := FormatSQL(SQL_EXISTS_SHADOW_NAME);

  if DRVQuery.ExecSQL(FormatSQL(SQL), [ACaption], False) then
    Result := DRVQuery.GetFieldIntValue(0) = 1;
  DRVQuery.Transaction.Commit;
end;

function TibSHDatabase.ChangeNameList(const AClassIID: TGUID; const ACaption: string;
  Operation: TOperation): Boolean;

  procedure ChangeNameList(AStrings: TStrings);
  var
    I: Integer;
  begin
    case Operation of
      opInsert:
        begin
          AStrings.Add(ACaption);
          Result := True;
          AllNameList.Add(ACaption);
        end;
      opRemove:
        begin
          I := AStrings.IndexOf(ACaption);
          if I <> -1 then
          begin
            AStrings.Delete(I);
            Result := True;
          end;
          I := AllNameList.IndexOf(ACaption);
          if I <> -1 then AllNameList.Delete(I);
        end;
    end;
  end;

begin
  Result := False;
  case Operation of
    opInsert: if not ExistsInDatabase(AClassIID, ACaption) then Exit;
    opRemove: if     ExistsInDatabase(AClassIID, ACaption) then Exit;
  end;

  if not Result then
  begin
    if IsEqualGUID(AClassIID, IibSHDomain) then ChangeNameList(DomainList)
     else
    if IsEqualGUID(AClassIID, IibSHTable) then ChangeNameList(TableList)
     else
  //Constraint*  if not Result and IsEqualGUID(AClassIID, IibSHConstraint) then ChangeNameList(ConstraintList);
    if IsEqualGUID(AClassIID, IibSHView) then ChangeNameList(ViewList)
     else
    if IsEqualGUID(AClassIID, IibSHProcedure) then ChangeNameList(ProcedureList)
     else
    if IsEqualGUID(AClassIID, IibSHTrigger) then ChangeNameList(TriggerList)
     else
    if IsEqualGUID(AClassIID, IibSHGenerator) then ChangeNameList(GeneratorList)
     else
    if IsEqualGUID(AClassIID, IibSHException) then ChangeNameList(ExceptionList)
     else
    if IsEqualGUID(AClassIID, IibSHFunction) then ChangeNameList(FunctionList)
     else
    if IsEqualGUID(AClassIID, IibSHFilter) then ChangeNameList(FilterList)
     else
    if IsEqualGUID(AClassIID, IibSHRole) then ChangeNameList(RoleList)
     else
    if IsEqualGUID(AClassIID, IibSHIndex) then ChangeNameList(IndexList)
     else
    if IsEqualGUID(AClassIID, IibSHShadow) then ChangeNameList(ShadowList);
  end;
  if Result then
    Result := Designer.SynchronizeConnection(Self, AClassIID, ACaption, Operation);
end;

procedure TibSHDatabase.OnLostConnect(Sender: TObject);
begin
  if not FWasLostConnect then FWasLostConnect := True;
  if FWasLostConnect and not StillConnect then
  begin
    try
    Designer.RestoreConnection(Self);
    if Assigned(DRVDatabase) then DRVDatabase.ClearCache;
    finally
      FWasLostConnect := False;
    end;
  end;
end;

function TibSHDatabase.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if IsEqualGUID(IID, IibSHDatabaseAliasOptionsInt) then
  begin
    if Supports(FDatabaseAliasOptionsInt, IibSHDatabaseAliasOptionsInt, Obj) then
      Result := S_OK
    else
      Result := E_NOINTERFACE;
  end else
    Result := inherited QueryInterface(IID, Obj);
end;

function TibSHDatabase.GetBranchIID: TGUID;
begin
  Result := inherited GetBranchIID;
  if Assigned(BTCLServer) then Result := BTCLServer.BranchIID;
end;

procedure TibSHDatabase.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Assigned(BTCLServer) and AComponent.IsImplementorOf(BTCLServer) then
    BTCLServer := nil;
end;

procedure TibSHDatabase.DoOnApplyOptions;
var
  Options: IibSHDatabaseOptions;
begin
  Options := nil;
  if IsEqualGUID(BranchIID, IibSHBranch) then
    Supports(Designer.GetOptions(IibSHDatabaseOptions), IibSHDatabaseOptions, Options)
  else  
  if IsEqualGUID(BranchIID, IfbSHBranch) then
    Supports(Designer.GetOptions(IfbSHDatabaseOptions), IibSHDatabaseOptions, Options);

  if Assigned(Options) then
  begin
    Charset := Options.Charset;
    CapitalizeNames := Options.CapitalizeNames;
  end;
  Options := nil;
end;

function TibSHDatabase.GetBTCLServer: IibSHServer;
begin
  Result := FBTCLServer;
end;

procedure TibSHDatabase.SetBTCLServer(const Value: IibSHServer);
begin
  if FBTCLServer <> Value then
  begin
    ReferenceInterface(FBTCLServer, opRemove);
    FBTCLServer := Value;
    ReferenceInterface(FBTCLServer, opInsert);

    if Assigned(FBTCLServer) then
    begin
      Server := Format('%s %s  ', [FBTCLServer.Caption, FBTCLServer.CaptionExt]);
      UserName := FBTCLServer.UserName;
      Password := FBTCLServer.Password;
      Role := FBTCLServer.Role;
      LoginPrompt := FBTCLServer.LoginPrompt;
      if AnsiSameText(BTCLServer.Version, SInterBase4x) or
         AnsiSameText(BTCLServer.Version, SInterBase5x) then
      begin
        if not CanShowProperty('PageSize') then MakePropertyInvisible('CapitalizeNames');
        CapitalizeNames := True;
        SQLDialect := 1;
      end else
      begin
        if not CanShowProperty('PageSize') then MakePropertyVisible('CapitalizeNames');
        CapitalizeNames := True;
      end;
    end;
  end;
end;

function TibSHDatabase.GetDRVDatabase: IibSHDRVDatabase;
begin
  Result := nil;
  if Assigned(BTCLServer) then
  begin
    if not BTCLServer.LongMetadataNames then
      Supports(FDRVDatabase, IibSHDRVDatabase, Result)
    else
      Supports(FDRVDatabase2, IibSHDRVDatabase, Result);
  end;
end;

function TibSHDatabase.GetDRVTransaction: IibSHDRVTransaction;
begin
  Result := nil;
  if Assigned(BTCLServer) then
  begin
    if not BTCLServer.LongMetadataNames then
      Supports(FDRVTransaction, IibSHDRVTransaction, Result)
    else
      Supports(FDRVTransaction2, IibSHDRVTransaction, Result);
  end;
end;

function TibSHDatabase.GetDRVQuery: IibSHDRVQuery;
begin
  Result := nil;
  if Assigned(BTCLServer) then
  begin
    if not BTCLServer.LongMetadataNames then
      Supports(FDRVQuery, IibSHDRVQuery, Result)
    else
      Supports(FDRVQuery2, IibSHDRVQuery, Result);
  end;
end;

function TibSHDatabase.GetServer: string;
begin
  if Assigned(BTCLServer) then
    Result := Format('%s (%s)  ', [BTCLServer.Caption, BTCLServer.CaptionExt]);
end;

procedure TibSHDatabase.SetServer(Value: string);
begin
  FServer := Value;
end;

function TibSHDatabase.GetDatabase: string;
begin
  Result := FDatabase;
end;

procedure TibSHDatabase.SetDatabase(Value: string);
var
  DefaultExt: string;
begin
  FDatabase := Value;
  if Length(Alias) = 0 then
  begin
    if not Designer.Loading then
    begin
      Alias := ExtractFileName(AnsiReplaceText(FDatabase, '/', '\'));
      if Pos('.', Alias) <> 0 then Alias := Copy(Alias, 1, Pos('.', Alias) - 1);
    end;
    if CanShowProperty('PageSize') then
    begin
      if Length(ExtractFileExt(FDatabase)) = 0 then
      begin
        DefaultExt := 'gdb';
        if Assigned(BTCLServer) then
        begin
          if AnsiSameText(BTCLServer.Version, SInterBase70) or
             AnsiSameText(BTCLServer.Version, SInterBase71) or
             AnsiSameText(BTCLServer.Version, SInterBase75) then DefaultExt := 'ib';

          if AnsiSameText(BTCLServer.Version, SFirebird15) or
             AnsiSameText(BTCLServer.Version, SFirebird20) then DefaultExt := 'fdb';
        end;
        FDatabase := Format('%s.%s', [FDatabase, DefaultExt]);
      end;
    end;
  end;
end;

function TibSHDatabase.GetAlias: string;
begin
  Result := FAlias;
end;

procedure TibSHDatabase.SetAlias(Value: string);
begin
  FAlias := Value;
end;

function TibSHDatabase.GetPageSize: string;
begin
  Result := FPageSize;
end;

procedure TibSHDatabase.SetPageSize(Value: string);
begin
  FPageSize := Value;
end;

function TibSHDatabase.GetCharset: string;
begin
  Result := FCharset;
end;

procedure TibSHDatabase.SetCharset(Value: string);
begin
  FCharset := Value;
end;

function TibSHDatabase.GetSQLDialect: Integer;
begin
  Result := FSQLDialect;
end;

procedure TibSHDatabase.SetSQLDialect(Value: Integer);
begin
  FSQLDialect := Value;
  if FSQLDialect = 1 then CapitalizeNames := True;
end;

function TibSHDatabase.GetCapitalizeNames: Boolean;
begin
  Result := FCapitalizeNames;
end;

procedure TibSHDatabase.SetCapitalizeNames(Value: Boolean);
begin
  FCapitalizeNames := Value;
end;

function TibSHDatabase.GetAdditionalConnectParams: TStrings;
begin
  Result := FAdditionalConnectParams;
end;

procedure TibSHDatabase.SetAdditionalConnectParams(Value: TStrings);
begin
  FAdditionalConnectParams.Assign(Value);
end;

function TibSHDatabase.GetUserName: string;
begin
  Result := FUserName;
end;

procedure TibSHDatabase.SetUserName(Value: string);
begin
  FUserName := Value;
end;

function TibSHDatabase.GetPassword: string;
begin
  Result := FPassword;
end;

procedure TibSHDatabase.SetPassword(Value: string);
begin
  FPassword := Value;
end;

function TibSHDatabase.GetRole: string;
begin
  Result := FRole;
end;

procedure TibSHDatabase.SetRole(Value: string);
begin
  FRole := Value;
end;

function TibSHDatabase.GetLoginPrompt: Boolean;
begin
  Result := FLoginPrompt;
end;

procedure TibSHDatabase.SetLoginPrompt(Value: Boolean);
begin
  FLoginPrompt := Value;
end;

function TibSHDatabase.GetDescription: string;
begin
  Result := FDescription;
end;

procedure TibSHDatabase.SetDescription(Value: string);
begin
  FDescription := Value;
end;

function TibSHDatabase.GetConnectPath: string;
begin
  Result := EmptyStr;
  if Assigned(BTCLServer) then
  begin
    if AnsiSameText(BTCLServer.Protocol, STCPIP) then
      Result := Format('%s%s', [BTCLServer.ConnectPath, Database]);

    if AnsiSameText(BTCLServer.Protocol, SNamedPipe) then
      Result := Format('%s%s',[BTCLServer.ConnectPath, Database]);

    if AnsiSameText(BTCLServer.Protocol, SSPX) then
      Result := Format('%s%s',[BTCLServer.ConnectPath, Database]);

    if AnsiSameText(BTCLServer.Protocol, SLocal) then
      Result := Format('%s',[Database]);
  end;
end;

function TibSHDatabase.GetStillConnect: Boolean;
begin
  Result := FStillConnect;
end;

procedure TibSHDatabase.SetStillConnect(Value: Boolean);
begin
  FStillConnect := Value;
end;

function TibSHDatabase.GetDirectoryIID: string;
begin
  Result := FDirectoryIID;
end;

procedure TibSHDatabase.SetDirectoryIID(Value: string);
begin
  FDirectoryIID := Value;
end;

function TibSHDatabase.GetDatabaseAliasOptions: IibSHDatabaseAliasOptions;
begin
  Supports(DatabaseAliasOptions, IibSHDatabaseAliasOptions, Result);
end;

function TibSHDatabase.GetExistsPrecision: Boolean;
begin
  Result := FExistsPrecision;
end;

function TibSHDatabase.GetDBCharset: string;
begin
  Result := FDBCharset;
end;

function TibSHDatabase.GetWasLostConnect: Boolean;
begin
  Result := FWasLostConnect;
end;

function TibSHDatabase.GetCaption: string;
begin
  Result := Alias;
end;

function TibSHDatabase.GetCaptionExt: string;
begin
  if Connected then
    Result := Format('Dialect %d, %s, %s', [SQLDialect, DBCharset, Database])
  else
    Result := Format('%s', [Database])
end;

procedure TibSHDatabase.SetOwnerIID(Value: TGUID);
var
  I: Integer;
  ibBTServerIntf: IibSHServer;
begin
  if not IsEqualGUID(OwnerIID, Value) then
  begin
    BTCLServer := nil;
    for I := 0 to Pred(Designer.Components.Count) do
      if Supports(Designer.Components[I], IibSHServer, ibBTServerIntf) and
         IsEqualGUID(ibBTServerIntf.InstanceIID, Value) then
      begin
        BTCLServer := ibBTServerIntf;
        DoOnApplyOptions;
        Break;
      end;
    inherited SetOwnerIID(Value);
  end;
end;

function TibSHDatabase.GetConnected: Boolean;
begin
  Result := Assigned(DRVDatabase) and DRVDatabase.Connected;
end;

function TibSHDatabase.GetCanConnect: Boolean;
begin
  Result := not Connected;
end;

function TibSHDatabase.GetCanReconnect: Boolean;
begin
  Result := Connected;
end;

function TibSHDatabase.GetCanDisconnect: Boolean;
begin
  Result := Connected;
end;

function TibSHDatabase.GetCanShowRegistrationInfo: Boolean;
begin
  Result := True;
end;

function TibSHDatabase.Connect: Boolean;
begin
  Result := CanConnect;
  if Result and Assigned(BTCLServer) and Assigned(DRVDatabase) then
  begin
    PrepareDRVDatabase;
    DRVDatabase.Connect;
    Result := DRVDatabase.Connected;
    if Result then
    begin
      PrepareDBObjectLists;
      MakePropertyVisible('DBCharset');
      MakePropertyVisible('SQLDialect');
    end else
      Designer.ShowMsg(Format(SDatabaseConnectNO, [Self.ConnectPath, DRVDatabase.ErrorText]), mtWarning);
  end else
  begin
    if not Assigned(DRVDatabase) then
      Designer.ShowMsg(Format(SDatabaseConnectNO, [Self.ConnectPath, SDriverIsNotInstalled]), mtWarning);
  end;
end;

function TibSHDatabase.Reconnect: Boolean;
begin
  Result := CanReconnect;
  if Result then Result := Assigned(DRVDatabase) and DRVDatabase.Reconnect;
end;

function TibSHDatabase.Disconnect: Boolean;
begin
  Result := CanDisconnect;
  if Result and Assigned(DRVDatabase) then
  begin
    DRVDatabase.Disconnect;
    FExistsPrecision := False;
    MakePropertyInvisible('DBCharset');
    MakePropertyInvisible('SQLDialect');
  end;
  Result := not Connected;
end;

procedure TibSHDatabase.Refresh;
begin
  PrepareDBObjectLists;
end;

function TibSHDatabase.ShowRegistrationInfo: Boolean;
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

procedure TibSHDatabase.IDELoadFromFileNotify;
begin
  CreateDirectory(GetDataRootDirectory);
end;

function TibSHDatabase.GetSchemeClassIIDList(WithSystem: Boolean = False): TStrings;
var
  Index: Integer;
  SFmt: string;
begin
  Index := 1;
  SFmt := '%s|%s';
  ClassIIDList.Clear;

  if WithSystem then
  begin
    ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHSystemTable), GUIDToName(IibSHSystemTable, Index)]));
    if Assigned(BTCLServer) and
       AnsiSameText(BTCLServer.Version, SInterBase70) or
       AnsiSameText(BTCLServer.Version, SInterBase71) or
       AnsiSameText(BTCLServer.Version, SInterBase75) then
      ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHSystemTableTmp), GUIDToName(IibSHSystemTableTmp, Index)]));
  end else
  begin
    if DatabaseAliasOptions.Navigator.ShowDomains then
      ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHDomain), GUIDToName(IibSHDomain, Index)]));
    if DatabaseAliasOptions.Navigator.ShowTables then
      ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHTable), GUIDToName(IibSHTable, Index)]));

    //Constraint*  if DatabaseAliasOptions.Navigator.ShowConstraints then
    //Constraint*    ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHConstraint), GUIDToName(IibSHConstraint, Index)]));
    if DatabaseAliasOptions.Navigator.ShowViews then
      ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHView), GUIDToName(IibSHView, Index)]));
    if DatabaseAliasOptions.Navigator.ShowProcedures then
      ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHProcedure), GUIDToName(IibSHProcedure, Index)]));
    if DatabaseAliasOptions.Navigator.ShowTriggers then
      ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHTrigger), GUIDToName(IibSHTrigger, Index)]));
    if DatabaseAliasOptions.Navigator.ShowGenerators then
      ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHGenerator), GUIDToName(IibSHGenerator, Index)]));
    if DatabaseAliasOptions.Navigator.ShowExceptions then
      ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHException), GUIDToName(IibSHException, Index)]));
    if DatabaseAliasOptions.Navigator.ShowFunctions then
      ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHFunction), GUIDToName(IibSHFunction, Index)]));
    if DatabaseAliasOptions.Navigator.ShowFilters then
      ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHFilter), GUIDToName(IibSHFilter, Index)]));
    if DatabaseAliasOptions.Navigator.ShowRoles and Assigned(BTCLServer) and not AnsiSameText(BTCLServer.Version, SInterBase4x) then
      ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHRole), GUIDToName(IibSHRole, Index)]));
    if DatabaseAliasOptions.Navigator.ShowIndices then
      ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHIndex), GUIDToName(IibSHIndex, Index)]));
      
    //  if DatabaseAliasOptions.Navigator.ShowShadows then
    //    ClassIIDList.Add(Format(SFmt, [GUIDToString(IibSHShadow), GUIDToName(IibSHShadow, Index)]));
  end;
  Result := ClassIIDList;
end;

function TibSHDatabase.GetSchemeClassIIDList(const AObjectName: string): TStrings;
begin
  ClassIIDList2.Clear;
  if DomainList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHDomain)) else
  if SystemDomainList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHSystemDomain)) else
  if TableList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHTable)) else
//Constraint*  if ConstraintList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHConstraint));
  if ViewList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHView)) else
  if ProcedureList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHProcedure)) else
  if TriggerList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHTrigger)) else
  if GeneratorList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHGenerator)) else
  if ExceptionList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHException)) else
  if FunctionList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHFunction)) else
  if FilterList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHFilter)) else
  if RoleList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHRole)) else
  if SystemTableList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHSystemTable)) else
  if IndexList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHIndex)) else
  if ShadowList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHShadow)) else
  if SystemTableTmpList.IndexOf(AObjectName) <> -1 then ClassIIDList2.Add(GUIDToString(IibSHSystemTableTmp));
  Result := ClassIIDList2;
end;

function TibSHDatabase.GetObjectNameList: TStrings;
begin
  Result := AllNameList;
end;

function TibSHDatabase.GetObjectNameList(const AClassIID: TGUID): TStrings;
begin
  Result := nil;
  if IsEqualGUID(AClassIID, IibSHProcedure) then Result := ProcedureList else
  if IsEqualGUID(AClassIID, IibSHTable) then Result := TableList else
  if IsEqualGUID(AClassIID, IibSHView) then Result := ViewList else
  if IsEqualGUID(AClassIID, IibSHDomain) then Result := DomainList else
  if IsEqualGUID(AClassIID, IibSHSystemDomain) then Result := SystemDomainList else
  if IsEqualGUID(AClassIID, IibSHFunction) then Result := FunctionList else
  if IsEqualGUID(AClassIID, IibSHFilter) then Result := FilterList else
  if IsEqualGUID(AClassIID, IibSHException) then Result := ExceptionList else
//Constraint*  if IsEqualGUID(AClassIID, IibSHConstraint) then Result := ConstraintList;
  if IsEqualGUID(AClassIID, IibSHGenerator) then Result := GeneratorList else
  if IsEqualGUID(AClassIID, IibSHSystemTable) then Result := SystemTableList else
  if IsEqualGUID(AClassIID, IibSHTrigger) then Result := TriggerList else
  if IsEqualGUID(AClassIID, IibSHRole) then Result := RoleList else
  if IsEqualGUID(AClassIID, IibSHIndex) then Result := IndexList else
  if IsEqualGUID(AClassIID, IibSHSystemTableTmp) then Result := SystemTableTmpList else
  if IsEqualGUID(AClassIID, IibSHShadow) then Result := ShadowList;
end;

function TibSHDatabase.GetCanTestConnection: Boolean;
begin
  Result := not CanShowProperty('PageSize') and Assigned(BTCLServer) and
                (Length(Database) > 0) and not Connected;
end;

function TibSHDatabase.TestConnection: Boolean;
var
  Msg: string;
  MsgType: TMsgDlgType;
begin
  Result := GetCanTestConnection;

  if Result then
  begin
    try
      Screen.Cursor := crHourGlass;
      PrepareDRVDatabase;
      try
        Result := Assigned(DRVDatabase) and DRVDatabase.TestConnection;
      except
        Result := False;
      end;
    finally
      Screen.Cursor := crDefault;
    end;

    if Result then
    begin
      Msg := Format(SDatabaseTestConnectionOK, [Self.ConnectPath]);
      MsgType := mtInformation;
    end else
    begin
      if Assigned(DRVDatabase) then
        Msg := Format(SDatabaseTestConnectionNO, [Self.ConnectPath, DRVDatabase.ErrorText])
      else
        Msg := Format(SDatabaseTestConnectionNO, [Self.ConnectPath, SDriverIsNotInstalled]);
      MsgType := mtWarning;
   end;

    Designer.ShowMsg(Msg, MsgType);
  end;
end;

function TibSHDatabase.GetDataRootDirectory: string;
begin
  if Assigned(BTCLServer) then
    Result := IncludeTrailingPathDelimiter(Format('%s\Databases\%s.%s', [BTCLServer.DataRootDirectory, Alias, DirectoryIID]));
end;

function TibSHDatabase.CreateDirectory(const FileName: string): Boolean;
begin
  Result := not SysUtils.DirectoryExists(FileName) and ForceDirectories(FileName);
end;

function TibSHDatabase.RenameDirectory(const OldName, NewName: string): Boolean;
begin
  Result := SysUtils.DirectoryExists(OldName) and RenameFile(OldName, NewName);
end;

function TibSHDatabase.DeleteDirectory(const FileName: string): Boolean;
begin
  Alias := Format('#.Unregistered.%s', [Alias]);
  Result := RenameDirectory(FileName, GetDataRootDirectory);
end;

function TibSHDatabase.GetFavoriteObjectNames: TStrings;
begin
  Result := DatabaseAliasOptions.Navigator.FavoriteObjectNames;
end;

function TibSHDatabase.GetFavoriteObjectColor: TColor;
begin
  Result := DatabaseAliasOptions.Navigator.FavoriteObjectColor;
end;

function TibSHDatabase.GetFilterList: TStrings;
begin
  Result := DatabaseAliasOptionsInt.FilterList;
end;

function TibSHDatabase.GetFilterIndex: Integer;
begin
  Result := DatabaseAliasOptionsInt.FilterIndex;
end;

procedure TibSHDatabase.SetFilterIndex(Value: Integer);
begin
  DatabaseAliasOptionsInt.FilterIndex := Value;
end;

//IibBTDataBaseExt

procedure TibSHDatabase.GetObjectsHaveComment(ClassObject: TGUID;
  Results: TStrings);
var
   SQLText:string;
   FieldReturns:integer;
begin
 FieldReturns:=1;
 if Results=nil then
  Exit;
 SQLText:='';
 if IsEqualGUID(ClassObject,IibSHDomain) then
   SQLText:=SQL_GET_DOMAINS_WITH_COMMENTS
 else
 if IsEqualGUID(ClassObject,IibSHField) then
 begin
  SQLText:=SQL_GET_FIELDS_WITH_COMMENTS;
  FieldReturns:=2
 end
 else
 if IsEqualGUID(ClassObject,IibSHTable) then
  SQLText:=SQL_GET_TABLES_WITH_COMMENTS
 else
 if IsEqualGUID(ClassObject,IibSHView) then
  SQLText:=SQL_GET_VIEWS_WITH_COMMENTS
 else
 if IsEqualGUID(ClassObject,IibSHTrigger) then
   SQLText:=SQL_GET_TRIGGERS_WITH_COMMENTS
 else
 if IsEqualGUID(ClassObject,IibSHProcedure) then
  SQLText:=SQL_GET_PROCEDURES_WITH_COMMENTS
 else
 if IsEqualGUID(ClassObject,IibSHFunction) then
  SQLText:=SQL_GET_FUNCTIONS_WITH_COMMENTS
 else
 if IsEqualGUID(ClassObject,IibSHException) then
  SQLText:=SQL_GET_EXCEPTIONS_WITH_COMMENTS
 else
 if IsEqualGUID(ClassObject,IibSHProcParam) then
 begin
  SQLText:=SQL_GET_PROCPARAMS_WITH_COMMENTS;
  FieldReturns:=2
 end ;

 Results.Clear;
 if Length(SQLText)=0 then
  Exit;

 if DRVQuery.ExecSQL(SQLText, [], False) then
 while not DRVQuery.Eof do
 begin
     case FieldReturns of
      1:  Results.Add(DRVQuery.GetFieldStrValue(0));
      2:  Results.Add(DRVQuery.GetFieldStrValue(0)+'#BT#'+DRVQuery.GetFieldStrValue(1));
     end;
     DRVQuery.Next;
 end;
end;

function TibSHDatabase.GetExistsProcParamDomains: Boolean;
begin
    Result := FExistsProcParamDomains;
end;

{ TfibSHDatabaseOptions }

function TfibSHDatabaseOptions.GetParentCategory: string;
begin
  if Supports(Self, IibSHBranch) then Result := Format('%s', [SibOptionsCategory]);
  if Supports(Self, IfbSHBranch) then Result := Format('%s', [SfbOptionsCategory]);
end;

function TfibSHDatabaseOptions.GetCategory: string;
begin
  Result := Format('%s', [SDatabaseOptionsCategory]);
end;

procedure TfibSHDatabaseOptions.RestoreDefaults;
begin
  Charset := CharsetsAndCollatesFB10[0, 0];
  CapitalizeNames := True;
end;

function TfibSHDatabaseOptions.GetCharset: string;
begin
  Result := Charset;
end;

procedure TfibSHDatabaseOptions.SetCharset(Value: string);
begin
  Charset := Value;
end;

function TfibSHDatabaseOptions.GetCapitalizeNames: Boolean;
begin
  Result := CapitalizeNames;
end;

procedure TfibSHDatabaseOptions.SetCapitalizeNames(Value: Boolean);
begin
  CapitalizeNames := Value;
end;

end.

