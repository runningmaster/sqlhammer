unit ibSHDesignIntf;

interface

uses
  SysUtils, Classes, Graphics,
  SHDesignIntf, ibSHDriverIntf;

type
  { Common }
  IibSHDummy = interface(ISHDummy)
  ['{715D9CE4-9B25-4F5F-AFFE-835DD9D9AE47}']
  end;

  IibSHComponent = interface(ISHComponent)
  ['{2155CAD7-4EB7-4DC6-9B8D-56F502DAFE31}']
  end;

  IibSHDomain = interface;

  IibSHDDLGenerator = interface(ISHDDLGenerator)
  ['{3E3E1692-B175-4822-8FB2-E6E53E161F91}']
    function GetTerminator: string;
    procedure SetTerminator(Value: string);
    function GetUseFakeValues: Boolean;
    procedure SetUseFakeValues(Value: Boolean);

    procedure SetBasedOnDomain(ADRVQuery: IibSHDRVQuery; ADomain: IibSHDomain; const ACaption: string);

    property Terminator: string read GetTerminator write SetTerminator;
    property UseFakeValues: Boolean read GetUseFakeValues write SetUseFakeValues;
  end;

  IibBTTemplates = interface
   ['{89CB07B7-9B1D-4CA0-94A0-C941FDF52E11}']
   function GetCurrentTemplateFile:string;
   procedure SetCurrentTemplateFile(const FileName:string);

   property CurrentTemplateFile:string read GetCurrentTemplateFile write SetCurrentTemplateFile;
  end;


  IibSHSQLGenerator = interface
  ['{419BB04F-3A6D-4D5D-AD14-071EDCF55540}']

    procedure SetAutoGenerateSQLsParams(AComponent: TSHComponent);
    procedure GenerateSQLs(AComponent: TSHComponent);

  end;

  IibSHDDLParser = interface(ISHDDLParser)
  ['{C180D55D-58EE-4F39-816F-796AC618CFD8}']
    function GetSQLParserNotification: IibSHDRVSQLParserNotification;
    procedure SetSQLParserNotification(Value: IibSHDRVSQLParserNotification);

    property SQLParserNotification: IibSHDRVSQLParserNotification
      read GetSQLParserNotification write SetSQLParserNotification;    
  end;

  IibSHDDLCompiler = interface(ISHDDLCompiler)
  ['{1C859878-AB4D-48B9-AD83-21600031CF45}']
  end;

  IibSHServer = interface(ISHServer)
  ['{1A1FF139-B6AB-473E-8063-0E3608614D32}']
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
    function GetDataRootDirectory: string;

    function DRVNormalize(const DriverIID: TGUID): TGUID;
    function PrepareDRVService: Boolean;
//IB2007    
    function  GetInstanceName:string;
    procedure SetInstanceName(const Value:string);

    property DRVService: IibSHDRVService read GetDRVService;


    property Host: string read GetHost write SetHost;
    property Alias: string read GetAlias write SetAlias;
    property Version: string read GetVersion write SetVersion;
    property LongMetadataNames: Boolean read SetLongMetadataNames
      write GetLongMetadataNames;
    property ClientLibrary: string read GetClientLibrary write SetClientLibrary;
    property Protocol: string read GetProtocol write SetProtocol;
    property Port: string read GetPort write SetPort;
    property SecurityDatabase: string read GetSecurityDatabase
      write SetSecurityDatabase;
    property UserName: string read GetUserName write SetUserName;
    property Password: string read GetPassword write SetPassword;
    property Role: string read GetRole write SetRole;
    property LoginPrompt: Boolean read GetLoginPrompt write SetLoginPrompt;
    property Description: string read GetDescription write SetDescription;
    property DataRootDirectory: string read GetDataRootDirectory;
    property InstanceName:string read GetInstanceName write SetInstanceName;
  end;

  IibSHDatabaseAliasOptions = interface;
  IibSHDatabase = interface(ISHDatabase)
  ['{EDFEA11D-6E23-4835-A350-3DFB5C55BBD9}']
    function GetBTCLServer: IibSHServer;
    function GetDRVDatabase: IibSHDRVDatabase;
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
    function GetStillConnect: Boolean;
    procedure SetStillConnect(Value: Boolean);
    function GetDatabaseAliasOptions: IibSHDatabaseAliasOptions;
    function GetExistsPrecision: Boolean;
    function GetDBCharset: string;
    function GetWasLostconnect: Boolean;
    function GetDataRootDirectory: string;
    function GetExistsProcParamDomains: Boolean;


    procedure CreateDatabase;
    procedure DropDatabase;
    function ExistsInDatabase(const AClassIID: TGUID; const ACaption: string): Boolean;
    function ChangeNameList(const AClassIID: TGUID; const ACaption: string;
      Operation: TOperation): Boolean;

    property BTCLServer: IibSHServer read GetBTCLServer;
    property DRVDatabase: IibSHDRVDatabase read GetDRVDatabase;
    property DRVQuery: IibSHDRVQuery read GetDRVQuery;

    property Server: string read  GetServer write SetServer;
    property Database: string read GetDatabase write SetDatabase;
    property Alias: string read GetAlias write SetAlias;
    property PageSize: string read GetPageSize write SetPageSize;
    property Charset: string read GetCharset write SetCharset;
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
    property StillConnect: Boolean read GetStillConnect write SetStillConnect;
    property DatabaseAliasOptions: IibSHDatabaseAliasOptions read GetDatabaseAliasOptions;
    property ExistsPrecision: Boolean read GetExistsPrecision;
    property DBCharset: string read GetDBCharset;
    property WasLostConnect: Boolean read GetWasLostConnect;
    property DataRootDirectory: string read GetDataRootDirectory;
    property ExistsProcParamDomains:boolean read GetExistsProcParamDomains;
  end;

  IibBTDataBaseExt= interface
  ['{1461C2F1-42CA-4DFF-99C0-E9E92C509036}']
   //Buzz
     procedure GetObjectsHaveComment(ClassObject:TGUID;Results:TStrings);
  end;

  IibSHCodeNormalizer = interface
  ['{B9814849-1E21-4E41-A1ED-190425A645D4}']
    //функция принимает название объекта в виде, в котором оно хранится в системных таблицах БД
    //и преобразовывает к виду, в котором должен его написать пользователь в редакторе
    function SourceDDLToMetadataName(const AObjectName: string): string;
    //функция принимает название объекта в виде, в котором оно хранится в системных таблицах БД
    //и преобразовывает к виду, в котором должен его написать пользователь в редакторе
    //(и в котором оно хранится в исходных DDL текстах объектов)
    function MetadataNameToSourceDDL(const ADatabase: IibSHDatabase; const AObjectName: string): string;
    function MetadataNameToSourceDDLCase(const ADatabase: IibSHDatabase; const AObjectName: string): string;
    //функция принимает название объекта таким, как его написал пользователь
    //и приводит его к виду, в котором оно хранится в системных таблицах БД
    //бывшая InputValueToCaption
    function InputValueToMetadata(const ADatabase: IibSHDatabase; const AObjectName: string): string;
    function InputValueToMetadataCheck(const ADatabase: IibSHDatabase; var AObjectName: string): Boolean;
    //функция преобразует регистр ключевых слов, использующихся для
    //формирования DDL объектов
    function CaseSQLKeyword(const AKeywordsString: string): string;
    // проверка на наличие слова, как ключевого
    function IsKeyword(const ADatabase: IibSHDatabase; const AKeyword: string): Boolean;
  end;

  IibSHDBObjectFactory = interface(ISHComponentFactory)
  ['{F8EB73CA-878D-4675-889A-5F4633EF3FC8}']
    //
    // Отложенное разрушение и создание нового компонента (Create/Recreate и Drop в IDE)
    //
    procedure SuspendedDestroyCreateComponent(OldComponent: TSHComponent;
      const NewOwnerIID, NewClassIID: TGUID; const NewCaption: string);
  end;

  { DBObjects }
  IibSHDBObject = interface(ISHDBComponent)
  ['{3983FDB0-20BA-4E66-836D-9AE55E827539}']
    function GetBTCLDatabase: IibSHDatabase;

    function GetOwnerName: string;
    procedure SetOwnerName(Value: string);
    function GetParams: TStrings;
    function GetReturns: TStrings;
    function GetBodyText: TStrings;
    function GetBLR: TStrings;
    function GetFields: TStrings;
    function GetConstraints: TStrings;
    function GetIndices: TStrings;
    function GetTriggers: TStrings;
    function GetGrants: TStrings;
    function GetTRParams: TStrings;

    function GetDescriptionText: string;
    function GetDescriptionStatement(AsParam: Boolean): string;
    procedure SetDescription;
    procedure FormGrants;

    property BTCLDatabase: IibSHDatabase read GetBTCLDatabase;

    property OwnerName: string read GetOwnerName write SetOwnerName;
    property Params: TStrings read GetParams;
    property Returns: TStrings read GetReturns;
    property BodyText: TStrings read GetBodyText;
    property BLR: TStrings read GetBLR;
    property Fields: TStrings read GetFields;
    property Constraints: TStrings read GetConstraints;
    property Indices: TStrings read GetIndices;
    property Triggers: TStrings read GetTriggers;
    property Grants: TStrings read GetGrants;
    property TRParams: TStrings read GetTRParams;
  end;

  IibSHDomain = interface(IibSHDBObject)
  ['{EC361E00-8CA5-4652-8D82-F0C91CDE8E8F}']
    function GetFieldTypeID: Integer;
    procedure SetFieldTypeID(Value: Integer);
    function GetSubTypeID: Integer;
    procedure SetSubTypeID(Value: Integer);
    function GetCharsetID: Integer;
    procedure SetCharsetID(Value: Integer);
    function GetCollateID: Integer;
    procedure SetCollateID(Value: Integer);
    function GetArrayDimID: Integer;
    procedure SetArrayDimID(Value: Integer);

    function GetDataType: string;
    procedure SetDataType(Value: string);
    function GetDataTypeExt: string;
    procedure SetDataTypeExt(Value: string);
    function GetDataTypeField: string;
    procedure SetDataTypeField(Value: string);
    function GetDataTypeFieldExt: string;
    procedure SetDataTypeFieldExt(Value: string);
    function GetLength: Integer;
    procedure SetLength(Value: Integer);
    function GetPrecision: Integer;
    procedure SetPrecision(Value: Integer);
    function GetScale: Integer;
    procedure SetScale(Value: Integer);
    function GetNotNull: Boolean;
    procedure SetNotNull(Value: Boolean);
    function GetNullType: string;
    procedure SetNullType(Value: string);
    function GetSubType: string;
    procedure SetSubType(Value: string);
    function GetSegmentSize: Integer;
    procedure SetSegmentSize(Value: Integer);
    function GetCharset: string;
    procedure SetCharset(Value: string);
    function GetCollate: string;
    procedure SetCollate(Value: string);
    function GetDefaultExpression: TStrings;
    procedure SetDefaultExpression(Value: TStrings);
    function GetCheckConstraint: TStrings;
    procedure SetCheckConstraint(Value: TStrings);
    function GetArrayDim: string;
    procedure SetArrayDim(Value: string);
    // For Fields
    function GetDomain: string;
    procedure SetDomain(Value: string);
    function GetTableName: string;
    procedure SetTableName(Value: string);
    function GetFieldDefault: TStrings;
    procedure SetFieldDefault(Value: TStrings);
    function GetFieldNotNull: Boolean;
    procedure SetFieldNotNull(Value: Boolean);
    function GetFieldNullType: string;
    procedure SetFieldNullType(Value: string);
    function GetFieldCollateID: Integer;
    procedure SetFieldCollateID(Value: Integer);
    function GetFieldCollate: string;
    procedure SetFieldCollate(Value: string);
    function GetComputedSource: TStrings;
    procedure SetComputedSource(Value: TStrings);
    // Other (for ibSHDDLGenerator)
    function GetUseCustomValues: Boolean;
    procedure SetUseCustomValues(Value: Boolean);
    function GetNameWasChanged: Boolean;
    procedure SetNameWasChanged(Value: Boolean);
    function GetDataTypeWasChanged: Boolean;
    procedure SetDataTypeWasChanged(Value: Boolean);
    function GetDefaultWasChanged: Boolean;
    procedure SetDefaultWasChanged(Value: Boolean);
    function GetCheckWasChanged: Boolean;
    procedure SetCheckWasChanged(Value: Boolean);
    function GetNullTypeWasChanged: Boolean;
    procedure SetNullTypeWasChanged(Value: Boolean);
    function GetCollateWasChanged: Boolean;
    procedure SetCollateWasChanged(Value: Boolean);


    property FieldTypeID: Integer read GetFieldTypeID write SetFieldTypeID;
    property SubTypeID: Integer read GetSubTypeID write SetSubTypeID;
    property CharsetID: Integer read GetCharsetID write SetCharsetID;
    property CollateID: Integer read GetCollateID write SetCollateID;
    property ArrayDimID: Integer read GetArrayDimID write SetArrayDimID;

    property DataType: string read GetDataType write SetDataType;
    property DataTypeExt: string read GetDataTypeExt write SetDataTypeExt;
    property DataTypeField: string read GetDataTypeField write SetDataTypeField;
    property DataTypeFieldExt: string read GetDataTypeFieldExt write SetDataTypeFieldExt; {decode domains :)}
    property Length: Integer read GetLength write SetLength;
    property Precision: Integer read GetPrecision write SetPrecision;
    property Scale: Integer read GetScale write SetScale;
    property NotNull: Boolean read GetNotNull write SetNotNull;
    property NullType: string read GetNullType write SetNullType;
    property SubType: string read GetSubType write SetSubType;
    property SegmentSize: Integer read GetSegmentSize write SetSegmentSize;
    property Charset: string read GetCharset write SetCharset;
    property Collate: string read GetCollate write SetCollate;
    property DefaultExpression: TStrings read GetDefaultExpression write SetDefaultExpression;
    property CheckConstraint: TStrings read GetCheckConstraint write SetCheckConstraint;
    property ArrayDim: string read GetArrayDim write SetArrayDim;
    // For Fields
    property Domain: string read GetDomain write SetDomain;
    property TableName: string read GetTableName write SetTableName;
    property FieldDefault: TStrings read GetFieldDefault write SetFieldDefault;
    property FieldNotNull: Boolean read GetFieldNotNull write SetFieldNotNull;
    property FieldNullType: string read GetFieldNullType write SetFieldNullType;
    property FieldCollateID: Integer read GetFieldCollateID write SetFieldCollateID;
    property FieldCollate: string read GetFieldCollate write SetFieldCollate;
    property ComputedSource: TStrings read GetComputedSource write SetComputedSource;
    // Other (for ibSHDDLGenerator)
    property UseCustomValues: Boolean read GetUseCustomValues write SetUseCustomValues;
    property NameWasChanged: Boolean read GetNameWasChanged write SetNameWasChanged;
    property DataTypeWasChanged: Boolean read GetDataTypeWasChanged write SetDataTypeWasChanged;
    property DefaultWasChanged: Boolean read GetDefaultWasChanged write SetDefaultWasChanged;
    property CheckWasChanged: Boolean read GetCheckWasChanged write SetCheckWasChanged;
    property NullTypeWasChanged: Boolean read GetNullTypeWasChanged write SetNullTypeWasChanged;
    property CollateWasChanged: Boolean read GetCollateWasChanged write SetCollateWasChanged;
  end;

  IibSHSystemDomain = interface(IibSHDomain)
  ['{5DCB98BF-E848-447A-A10E-92F1CE2DDD0E}']
  end;

  IibSHSystemGeneratedDomain = interface(IibSHDomain)
  ['{7A01A180-215D-4479-B36C-52F5DE7861B2}']
  end;

  IibSHField = interface(IibSHDomain)
  ['{F347B4BE-4902-4554-9FF5-0D635CD70724}']
  end;

  IibSHConstraint = interface(IibSHDBObject)
  ['{903FA616-0C7A-4DE5-A4F9-720F21AA6547}']
    function GetConstraintType: string;
    procedure SetConstraintType(Value: string);
    function GetTableName: string;
    procedure SetTableName(Value: string);
    function GetReferenceTable: string;
    procedure SetReferenceTable(Value: string);
    function GetReferenceFields: TStrings;
    procedure SetReferenceFields(Value: TStrings);
    function GetOnUpdateRule: string;
    procedure SetOnUpdateRule(Value: string);
    function GetOnDeleteRule: string;
    procedure SetOnDeleteRule(Value: string);
    function GetIndexName: string;
    procedure SetIndexName(Value: string);
    function GetIndexSorting: string;
    procedure SetIndexSorting(Value: string);
    function GetCheckSource: TStrings;
    procedure SetCheckSource(Value: TStrings);

    property ConstraintType: string read GetConstraintType write SetConstraintType;
    property TableName: string read GetTableName write SetTableName;
    property ReferenceTable: string read GetReferenceTable write SetReferenceTable;
    property ReferenceFields: TStrings read GetReferenceFields write SetReferenceFields;
    property OnUpdateRule: string read GetOnUpdateRule write SetOnUpdateRule;
    property OnDeleteRule: string read GetOnDeleteRule write SetOnDeleteRule;
    property IndexName: string read GetIndexName write SetIndexName;
    property IndexSorting: string read GetIndexSorting write SetIndexSorting;
    property CheckSource: TStrings read GetCheckSource write SetCheckSource;
  end;

  IibSHSystemGeneratedConstraint = interface(IibSHConstraint)
  ['{A07F035A-9471-48D7-9E13-2DD0EFAEBDA8}']
  end;

  IibSHIndex = interface(IibSHDBObject)
  ['{C4C5A61B-A51E-4F80-A4DA-F7BCE4B4615F}']
    function GetIndexTypeID: Integer;
    procedure SetIndexTypeID(Value: Integer);
    function GetSortingID: Integer;
    procedure SetSortingID(Value: Integer);
    function GetStatusID: Integer;
    procedure SetStatusID(Value: Integer);

    function GetIndexType: string;
    procedure SetIndexType(Value: string);
    function GetSorting: string;
    procedure SetSorting(Value: string);
    function GetTableName: string;
    procedure SetTableName(Value: string);
    function GetExpression: TStrings;
    procedure SetExpression(Value: TStrings);
    function GetStatus: string;
    procedure SetStatus(Value: string);
    function GetStatistics: string;
    procedure SetStatistics(Value: string);

    procedure RecountStatistics;
    procedure SetIsConstraintIndex(const Value:boolean);
    function  GetIsConstraintIndex:boolean;

    property IndexTypeID: Integer read GetIndexTypeID write SetIndexTypeID;
    property SortingID: Integer read GetSortingID write SetSortingID;
    property StatusID: Integer read GetStatusID write SetStatusID;


    property IndexType: string read GetIndexType write SetIndexType;
    property Sorting: string read GetSorting write SetSorting;
    property TableName: string read GetTableName write SetTableName;
    property Expression: TStrings read GetExpression write SetExpression;
    property Status: string read GetStatus write SetStatus;
    property Statistics: string read GetStatistics write SetStatistics;
    property IsConstraintIndex:boolean read GetIsConstraintIndex write SetIsConstraintIndex;
  end;

  IibSHTrigger = interface;

  IibSHTable = interface(IibSHDBObject)
  ['{E811EC57-F0EC-45AB-8BFA-58028E875FCA}']
    function GetDecodeDomains: Boolean;
    procedure SetDecodeDomains(Value: Boolean);
    function GetWithoutComputed: Boolean;
    procedure SetWithoutComputed(Value: Boolean);
    function GetRecordCountFrmt: string;
    function GetChangeCountFrmt: string;

    function GetExternalFile: string;
    procedure SetExternalFile(const Value: string);

    function GetField(Index: Integer): IibSHField;
    function GetConstraint(Index: Integer): IibSHConstraint;
    function GetIndex(Index: Integer): IibSHIndex;
    function GetTrigger(Index: Integer): IibSHTrigger;
    procedure SetRecordCount;
    procedure SetChangeCount;

    property DecodeDomains: Boolean read GetDecodeDomains write SetDecodeDomains;
    property WithoutComputed: Boolean read GetWithoutComputed write SetWithoutComputed;
    property RecordCountFrmt: string read GetRecordCountFrmt;
    property ChangeCountFrmt: string read GetChangeCountFrmt;
    property ExternalFile   : string read GetExternalFile; 
  end;

  IibSHSystemTable = interface(IibSHTable)
  ['{5F94ACEF-37BD-48B2-B762-1FBA420F1184}']
  end;

  IibSHSystemTableTmp = interface(IibSHTable)
  ['{9F487B77-EABA-4D51-AEF6-53EDC4C5D33F}']
  end;

  IibSHView = interface(IibSHDBObject)
  ['{B577D723-A56C-41D5-B00C-CCF0309EA763}']
    function GetField(Index: Integer): IibSHField;
    function GetTrigger(Index: Integer): IibSHTrigger;
    function GetRecordCountFrmt: string;
    procedure SetRecordCount;

    property RecordCountFrmt: string read GetRecordCountFrmt;
  end;

  IibSHProcParam = interface(IibSHDomain)
  ['{67C3D531-0C2A-4475-BFC9-B6CD7E3C18D2}']
  end;

  IibSHProcedure = interface(IibSHDBObject)
  ['{2769981B-AB6D-4F38-87AC-7C414166C212}']
    function GetCanExecute: Boolean;
    function GetParamsExt: TStrings;
    function GetReturnsExt: TStrings;
    function GetHeaderDDL: TStrings;

    function GetParam(Index: Integer): IibSHProcParam;
    function GetReturn(Index: Integer): IibSHProcParam;
    procedure Execute;

    property CanExecute: Boolean read GetCanExecute;
    property ParamsExt: TStrings read GetParamsExt;
    property ReturnsExt: TStrings read GetReturnsExt;
    property HeaderDDL: TStrings read GetHeaderDDL;
  end;

  IibSHTrigger = interface(IibSHDBObject)
  ['{CA484F4C-1E7D-4909-8808-C795F20769E7}']
    function GetTableName: string;
    procedure SetTableName(Value: string);
    function GetStatus: string;
    procedure SetStatus(Value: string);
    function GetTypePrefix: string;
    procedure SetTypePrefix(Value: string);
    function GetTypeSuffix: string;
    procedure SetTypeSuffix(Value: string);
    function GetPosition: Integer;
    procedure SetPosition(Value: Integer);

    property TableName: string read GetTableName write SetTableName;
    property Status: string read GetStatus write SetStatus;
    property TypePrefix: string read GetTypePrefix write SetTypePrefix;
    property TypeSuffix: string read GetTypeSuffix write SetTypeSuffix;
    property Position: Integer read GetPosition write SetPosition;
  end;

  IibSHSystemGeneratedTrigger = interface(IibSHTrigger)
  ['{7527B15D-14C5-422B-9356-18CD3AB48291}']
  end;

  IibSHGenerator = interface(IibSHDBObject)
  ['{541922B1-AE56-4C07-AF09-A477875C29CB}']
    function GetShowSetClause: Boolean;
    procedure SetShowSetClause(Value: Boolean);
    function GetValue: Integer;
    procedure SetValue(Value: Integer);

    property ShowSetClause: Boolean read GetShowSetClause write SetShowSetClause;
    property Value: Integer read GetValue write SetValue;
  end;

  IibSHException = interface(IibSHDBObject)
  ['{F66EAE2B-24BD-4FDE-996B-8A2AC3F14D9D}']
    function GetText: string;
    procedure SetText(Value: string);
    function GetNumber: Integer;
    procedure SetNumber(Value: Integer);

    property Text: string read GetText write SetText;
    property Number: Integer read GetNumber write SetNumber;
  end;

  IibSHFuncParam = interface(IibSHDomain)
  ['{D433EFA2-38AB-44CD-A57D-836FADBC86A4}']
  end;

  IibSHFunction = interface(IibSHDBObject)
  ['{EFF0E79D-6D87-491F-8594-F0D706BBE819}']
    function GetEntryPoint: string;
    procedure SetEntryPoint(Value: string);
    function GetModuleName: string;
    procedure SetModuleName(Value: string);
    function GetReturnsArgument: Integer;
    procedure SetReturnsArgument(Value: Integer);

    function GetParam(Index: Integer): IibSHFuncParam;

    property EntryPoint: string read GetEntryPoint write SetEntryPoint;
    property ModuleName: string read GetModuleName write SetModuleName;
    property ReturnsArgument: Integer read GetReturnsArgument
      write SetReturnsArgument;
  end;

  IibSHFilter = interface(IibSHDBObject)
  ['{0A2D14C5-E4A9-4990-892B-ECA8E2D27C3A}']
    function GetInputType: Integer;
    procedure SetInputType(Value: Integer);
    function GetOutputType: Integer;
    procedure SetOutputType(Value: Integer);
    function GetEntryPoint: string;
    procedure SetEntryPoint(Value: string);
    function GetModuleName: string;
    procedure SetModuleName(Value: string);
    
    property InputType: Integer read GetInputType write SetInputType;
    property OutputType: Integer read GetOutputType write SetOutputType;
    property EntryPoint: string read GetEntryPoint write SetEntryPoint;
    property ModuleName: string read GetModuleName write SetModuleName;
  end;

  IibSHRole = interface(IibSHDBObject)
  ['{600ABCE2-E93A-459F-A7AB-E8F081C9D6BE}']
  end;

  IibSHShadow = interface(IibSHDBObject)
  ['{DF446552-BA17-4C01-A267-F1FD846078DD}']
    function GetShadowMode: string;
    procedure SetShadowMode(Value: string);
    function GetShadowType: string;
    procedure SetShadowType(Value: string);
    function GetFileName: string;
    procedure SetFileName(Value: string);
    function GetSecondaryFiles: string;
    procedure SetSecondaryFiles(Value: string);

    property ShadowMode: string read GetShadowMode write SetShadowMode;
    property ShadowType: string read GetShadowType write SetShadowType;
    property FileName: string read GetFileName write SetFileName;
    property SecondaryFiles: string read GetSecondaryFiles write SetSecondaryFiles;
  end;

  { Tools }
  IibSHTool = interface(IibSHComponent)
  ['{CEF3550A-CF00-458B-A163-A6B9EBB68073}']
    function GetBTCLServer: IibSHServer;
    function GetBTCLDatabase: IibSHDatabase;

    property BTCLServer: IibSHServer read GetBTCLServer;
    property BTCLDatabase: IibSHDatabase read GetBTCLDatabase;
  end;

  IibSHStatistics = interface
  ['{09520F3B-32D2-4D4B-BA26-E79745B08B4F}']
    function GetDatabase: IibSHDatabase;
    procedure SetDatabase(const Value: IibSHDatabase);
    function GetDRVStatistics: IibSHDRVStatistics;
    function GetDRVTimeStatistics: IibSHDRVExecTimeStatistics;
    procedure SetDRVTimeStatistics(const Value: IibSHDRVExecTimeStatistics);

    function TableStatisticsStr(AIncludeSystemTables: Boolean): string;
    function ExecuteTimeStatisticsStr: string;

    procedure StartCollection;
    procedure CalculateStatistics;

    property Database: IibSHDatabase read GetDatabase write SetDatabase;
    property DRVStatistics: IibSHDRVStatistics read GetDRVStatistics;
    property DRVTimeStatistics: IibSHDRVExecTimeStatistics read GetDRVTimeStatistics
      write SetDRVTimeStatistics;

  end;

  IibSHSQLEditor = interface(IibSHTool)
  ['{FF095100-C03B-4637-9C44-41E9EC1BEA47}']
    function GetAutoCommit: Boolean;
    procedure SetAutoCommit(Value: Boolean);
    function GetExecuteSelected: Boolean;
    procedure SetExecuteSelected(Value: Boolean);
    function GetRetrievePlan: Boolean;
    procedure SetRetrievePlan(Value: Boolean);
    function GetRetrieveStatistics: Boolean;
    procedure SetRetrieveStatistics(Value: Boolean);
    function GetAfterExecute: string;
    procedure SetAfterExecute(Value: string);
    function GetRecordCountFrmt: string;
    function GetResultType: string;
    procedure SetResultType(Value: string);
    function GetThreadResults: Boolean;
    procedure SetThreadResults(Value: Boolean);
    function GetIsolationLevel: string;
    procedure SetIsolationLevel(Value: string);
    function GetTransactionParams: TStrings;
    procedure SetTransactionParams(Value: TStrings);

    procedure SetRecordCount;
    
    property AutoCommit: Boolean read GetAutoCommit write SetAutoCommit;
    property ExecuteSelected: Boolean read GetExecuteSelected write SetExecuteSelected;
    property RetrievePlan: Boolean read GetRetrievePlan write SetRetrievePlan;
    property RetrieveStatistics: Boolean read GetRetrieveStatistics write SetRetrieveStatistics;
    property AfterExecute: string read GetAfterExecute write SetAfterExecute;
    property RecordCountFrmt: string read GetRecordCountFrmt;
    property ResultType: string read GetResultType write SetResultType;
    property ThreadResults: Boolean read GetThreadResults write SetThreadResults;
    property IsolationLevel: string read GetIsolationLevel write SetIsolationLevel;
    property TransactionParams: TStrings read GetTransactionParams write SetTransactionParams;

  end;

  IibSHInputParameters = interface
  ['{288F8014-162D-4D1B-93CA-4566F5A3B88A}']
    function GetParams: IibSHDRVParams;
    function InputParameters(AParams: IibSHDRVParams): Boolean;

    property Params: IibSHDRVParams read GetParams;
  end;

  IibSHData = interface
  ['{D58CB2AF-BAF6-4C73-9FA9-7B4813A8C141}']
    function GetTransaction: IibSHDRVTransaction;
    function GetDataset: IibSHDRVDataset;
    function GetErrorText: string;
    function GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);

    function Prepare: Boolean;
    function Open: Boolean;
    procedure FetchAll;
    procedure Close;
    procedure Commit;
    procedure Rollback;

    property Transaction: IibSHDRVTransaction read GetTransaction;
    property Dataset: IibSHDRVDataset read GetDataset;
    property ErrorText: string read GetErrorText;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  end;

  { Psewdo DBObject }

  IibSHQuery = interface(IibSHDBObject)
  ['{24551BC4-99C7-4077-A489-F56348BA742E}']
    function GetData: IibSHData;
    procedure SetData(Value: IibSHData);

    function GetField(Index: Integer): IibSHField;

    property Data: IibSHData read GetData write SetData;
  end;

  IibSHDMLHistory = interface(IibSHTool)
  ['{5D78199A-267F-4125-AE59-3EF341A2D2F0}']

    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    function GetHistoryFileName: string;
    function GetMaxCount: Integer;
    procedure SetMaxCount(const Value: Integer);
    function GetSelect: Boolean;
    procedure SetSelect(const Value: Boolean);
    function GetInsert: Boolean;
    procedure SetInsert(const Value: Boolean);
    function GetUpdate: Boolean;
    procedure SetUpdate(const Value: Boolean);
    function GetDelete: Boolean;
    procedure SetDelete(const Value: Boolean);
    function GetExecute: Boolean;
    procedure SetExecute(const Value: Boolean);
    function GetCrash: Boolean;
    procedure SetCrash(const Value: Boolean);

    function Count: Integer;
    procedure Clear;
    function Statement(Index: Integer): string;
    function Item(Index: Integer): string;
    function Statistics(Index: Integer): string;
    function AddStatement(AStatement: string; AStatistics: IibSHStatistics): Integer;
    procedure DeleteStatement(AStatementNo: Integer);
    procedure LoadFromFile;
    procedure SaveToFile;

    property Active: Boolean read GetActive write SetActive;
    property MaxCount: Integer read GetMaxCount write SetMaxCount;
    property Select: Boolean read GetSelect write SetSelect;
    property Insert: Boolean read GetInsert write SetInsert;
    property Update: Boolean read GetUpdate write SetUpdate;
    property Delete: Boolean read GetDelete write SetDelete;
    property Execute: Boolean read GetExecute write SetExecute;
    property Crash: Boolean read GetCrash write SetCrash;
  end;

  IibSHDDLHistory = interface(IibSHTool)
  ['{10C78888-44DB-4117-B123-052199CE07FD}']

    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    function GetHistoryFileName: string;

    function Count: Integer;
    procedure Clear;
    function Statement(Index: Integer): string;
    function Item(Index: Integer): string;
    function AddStatement(AStatement: string): Integer;
    procedure CommitNewStatements;
    procedure RollbackNewStatements;    
    procedure LoadFromFile;
    procedure SaveToFile;

    property Active: Boolean read GetActive write SetActive;
  end;

  IibSHSQLPerformance = interface(IibSHTool)
  ['{5BA6C2E7-63B3-4A59-A03E-767E053A993C}']
  end;

  IibSHSQLPlan = interface(IibSHTool)
  ['{291E635D-A239-4B77-A90C-6DE99B081D53}']
  end;

  IibSHSQLPlayer = interface(IibSHTool)
  ['{CEDED95A-F963-4F3E-A99B-B96E0B418474}']
    function GetServer: string;
    procedure SetServer(Value: string);
    function GetMode: string;
    procedure SetMode(Value: string);
    function GetAutoDDL: Boolean;
    procedure SetAutoDDL(Value: Boolean);
    function GetAbortOnError: Boolean;
    procedure SetAbortOnError(Value: Boolean);
    function GetAfterError: string;
    procedure SetAfterError(Value: string);
    function GetDefaultSQLDialect: Integer;
    procedure SetDefaultSQLDialect(Value: Integer);
    function GetSignScript: Boolean;
    procedure SetSignScript(Value: Boolean);

    property Server: string read GetServer write SetServer;
    property Mode: string read GetMode write SetMode;
    property AutoDDL: Boolean read GetAutoDDL write SetAutoDDL;
    property AbortOnError: Boolean read GetAbortOnError write SetAbortOnError;
    property AfterError: string read GetAfterError write SetAfterError;
    property DefaultSQLDialect: Integer read GetDefaultSQLDialect write SetDefaultSQLDialect;
    property SignScript: Boolean read GetSignScript write SetSignScript;

  end;

  IibSHDMLExporterFactory = interface(ISHComponentFactory)
  ['{E82413B4-5CEB-4890-9DEF-E081778AFAD8}']
    //
    // Свойства для инициализации аналогичных свойств компонента
    //
    function GetData: IibSHData;
    procedure SetData(Value: IibSHData);
    function GetMode: string;
    procedure SetMode(Value: string);
    function GetTablesForDumping: TStrings;
    procedure SetTablesForDumping(Value: TStrings);

    procedure SuspendedDestroyComponent(AComponent: TSHComponent);

    property Data: IibSHData read GetData write SetData;
    property Mode: string read GetMode write SetMode;
    property TablesForDumping: TStrings read GetTablesForDumping
      write SetTablesForDumping;

  end;

  IibSHDMLExporter = interface(IibSHTool)
  ['{ACD94134-D1A5-427E-AC7F-BEE935C34071}']
    function GetData: IibSHData;
    procedure SetData(Value: IibSHData);
    function GetMode: string;
    procedure SetMode(Value: string);
    function GetTablesForDumping: TStrings;
    procedure SetTablesForDumping(Value: TStrings);
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetOutput: string;
    procedure SetOutput(Value: string);
    function GetStatementType: string;
    procedure SetStatementType(Value: string);
    function GetHeader: Boolean;
    procedure SetHeader(Value: Boolean);
    function GetPassword: Boolean;
    procedure SetPassword(Value: Boolean);
    function GetCommitAfter: Integer;
    procedure SetCommitAfter(Value: Integer);
    function GetCommitEachTable: Boolean;
    procedure SetCommitEachTable(Value: Boolean);
    function GetDateFormat: string;
    procedure SetDateFormat(Value: string);
    function GetTimeFormat: string;
    procedure SetTimeFormat(Value: string);
    function GetUseDateTimeANSIPrefix: Boolean;
    procedure SetUseDateTimeANSIPrefix(Value: Boolean);
    function GetNonPrintChar2Space: Boolean;
    procedure SetNonPrintChar2Space(Value: Boolean);
    function  GetUseExecuteBlock:boolean;
    procedure SetUseExecuteBlock(Value:boolean);

    property Data: IibSHData read GetData write SetData;
    property Mode: string read GetMode write SetMode;
    property TablesForDumping: TStrings read GetTablesForDumping
      write SetTablesForDumping;
    property Active: Boolean read GetActive write SetActive;

    property Output: string read GetOutput write SetOutput;
    property StatementType: string read GetStatementType write SetStatementType;
    property Header: Boolean read GetHeader write SetHeader;
    property Password: Boolean read GetPassword write SetPassword;
    property CommitAfter: Integer read GetCommitAfter write SetCommitAfter;
    property CommitEachTable: Boolean read GetCommitEachTable write SetCommitEachTable;

    property DateFormat: string read GetDateFormat write SetDateFormat;
    property TimeFormat: string read GetTimeFormat write SetTimeFormat;
    property UseDateTimeANSIPrefix: Boolean read GetUseDateTimeANSIPrefix
      write SetUseDateTimeANSIPrefix;
    property NonPrintChar2Space: Boolean read GetNonPrintChar2Space
      write SetNonPrintChar2Space;
    property UseExecuteBlock:boolean read GetUseExecuteBlock write SetUseExecuteBlock;

  end;

  TibSHSQLMonitorEvent = procedure(ApplicationName, OperationName, ObjectName, LongTime, ShortTime, SQLText: string) of object;

  IibSHSQLMonitor = interface(IibSHTool)
  ['{05A40F9C-68C8-4037-9C83-B8335013E23F}']
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetPrepare: Boolean;
    procedure SetPrepare(Value: Boolean);
    function GetExecute: Boolean;
    procedure SetExecute(Value: Boolean);
    function GetFetch: Boolean;
    procedure SetFetch(Value: Boolean);
    function GetConnect: Boolean;
    procedure SetConnect(Value: Boolean);
    function GetTransact: Boolean;
    procedure SetTransact(Value: Boolean);
    function GetService: Boolean;
    procedure SetService(Value: Boolean);
    function GetStmt: Boolean;
    procedure SetStmt(Value: Boolean);
    function GetError: Boolean;
    procedure SetError(Value: Boolean);
    function GetBlob: Boolean;
    procedure SetBlob(Value: Boolean);
    function GetMisc: Boolean;
    procedure SetMisc(Value: Boolean);
    function GetFilter: TStrings;
    procedure SetFilter(Value: TStrings);

    function GetOnEvent: TibSHSQLMonitorEvent;
    procedure SetOnEvent(Value: TibSHSQLMonitorEvent);

    property Active: Boolean read GetActive write SetActive;
    property Prepare: Boolean read GetPrepare write SetPrepare;
    property Execute: Boolean read GetExecute write SetExecute;
    property Fetch: Boolean read GetFetch write SetFetch;
    property Connect: Boolean read GetConnect write SetConnect;
    property Transact: Boolean read GetTransact write SetTransact;
    property Service: Boolean read GetService write SetService;
    property Stmt: Boolean read GetStmt write SetStmt;
    property Error: Boolean read GetError write SetError;
    property Blob: Boolean read GetBlob write SetBlob;
    property Misc: Boolean read GetMisc write SetMisc;
    property Filter: TStrings read GetFilter write SetFilter;

    property OnEvent: TibSHSQLMonitorEvent read GetOnEvent write SetOnEvent;
  end;

  IibSHFIBMonitor = interface(IibSHSQLMonitor)
  ['{C6C66A3A-B515-4893-B1B1-AB3811567DC9}']
  end;

  IibSHIBXMonitor = interface(IibSHSQLMonitor)
  ['{73EBB6C1-3BEA-464C-ABC2-1FD362F602B2}']
  end;

  IibSHDDLGrantor = interface(IibSHTool)
  ['{C86278F9-A4DB-402A-8B6A-B342A39346D3}']
    function GetPrivilegesFor: string;
    procedure SetPrivilegesFor(Value: string);
    function GetGrantsOn: string;
    procedure SetGrantsOn(Value: string);
    function GetDisplay: string;
    procedure SetDisplay(Value: string);
    function GetShowSystemTables: Boolean;
    procedure SetShowSystemTables(Value: Boolean);
    function GetIncludeFields: Boolean;
    procedure SetIncludeFields(Value: Boolean);

    function GetUnionUsers: TStrings;
    function GetAbsentUsers: TStrings;
    procedure ExtractGrants(const AClassIID: TGUID; const ACaption: string);
    function GetGrantSelectIndex(const ACaption: string): Integer;
    function GetGrantUpdateIndex(const ACaption: string): Integer;
    function GetGrantDeleteIndex(const ACaption: string): Integer;
    function GetGrantInsertIndex(const ACaption: string): Integer;
    function GetGrantReferenceIndex(const ACaption: string): Integer;
    function GetGrantExecuteIndex(const ACaption: string): Integer;
    function IsGranted(const ACaption: string): Boolean;

    function GrantTable(const AClassIID: TGUID; const Privilege, OnObject, ToObject: string; WGO: Boolean): Boolean;
    function GrantTableField(const AClassIID: TGUID; const Privilege, OnField, OnObject, ToObject: string; WGO: Boolean): Boolean;
    function GrantProcedure(const AClassIID: TGUID; const OnObject, ToObject: string; WGO: Boolean): Boolean;
    function RevokeTable(const AClassIID: TGUID; const Privilege, OnObject, FromObject: string; WGO: Boolean): Boolean;
    function RevokeTableField(const AClassIID: TGUID; const Privilege, OnField, OnObject, FromObject: string; WGO: Boolean): Boolean;
    function RevokeProcedure(const AClassIID: TGUID; const OnObject, FromObject: string; WGO: Boolean): Boolean;

    property PrivilegesFor: string read GetPrivilegesFor write SetPrivilegesFor;
    property GrantsOn: string read GetGrantsOn write SetGrantsOn;
    property Display: string read GetDisplay write SetDisplay;
    property ShowSystemTables: Boolean read GetShowSystemTables write SetShowSystemTables;
    property IncludeFields: Boolean read GetIncludeFields write SetIncludeFields;
  end;

  IibSHGrant = interface
  ['{8EC9F4D2-6BE1-4FC8-B5C0-951D07759925}']
  end;

  IibSHGrantWGO = interface
  ['{810472C3-93B7-42D3-9182-278C30FD608C}']
  end;

  IibSHUser = interface
  ['{25F094D4-53CE-481A-A2DF-35D4BD56CA23}']
    function GetUserName: string;
    procedure SetUserName(Value: string);
    function GetPassword: string;
    procedure SetPassword(Value: string);
    function GetFirstName: string;
    procedure SetFirstName(Value: string);
    function GetMiddleName: string;
    procedure SetMiddleName(Value: string);
    function GetLastName: string;
    procedure SetLastName(Value: string);

    property UserName: string read GetUserName write SetUserName;
    property Password: string read GetPassword write SetPassword;
    property FirstName: string read GetFirstName write SetFirstName;
    property MiddleName: string read GetMiddleName write SetMiddleName;
    property LastName: string read GetLastName write SetLastName;
  end;

  IibSHUserManager = interface(IibSHTool)
  ['{F04A5F0F-BA09-496A-B6F4-CAE6A77496FB}']
    procedure DisplayUsers;

    function GetUserCount: Integer;
    function GetUserName(AIndex: Integer): string;
    function GetFirstName(AIndex: Integer): string;
    function GetMiddleName(AIndex: Integer): string;
    function GetLastName(AIndex: Integer): string;
    function GetConnectCount(const UserName: string): Integer;
    
    function AddUser(const UserName, Password, FirstName, MiddleName, LastName: string): Boolean;
    function ModifyUser(const UserName, Password, FirstName, MiddleName, LastName: string): Boolean;
    function DeleteUser(const UserName: string): Boolean;
  end;

  IibSHLookIn = interface
  ['{53D67FF9-2FE4-4B17-8992-45079D7C5026}']
    function GetDomains: Boolean;
    procedure SetDomains(Value: Boolean);
    function GetTables: Boolean;
    procedure SetTables(Value: Boolean);
    function GetConstraints: Boolean;
    procedure SetConstraints(Value: Boolean);
    function GetIndices: Boolean;
    procedure SetIndices(Value: Boolean);
    function GetViews: Boolean;
    procedure SetViews(Value: Boolean);
    function GetProcedures: Boolean;
    procedure SetProcedures(Value: Boolean);
    function GetTriggers: Boolean;
    procedure SetTriggers(Value: Boolean);
    function GetGenerators: Boolean;
    procedure SetGenerators(Value: Boolean);
    function GetExceptions: Boolean;
    procedure SetExceptions(Value: Boolean);
    function GetFunctions: Boolean;
    procedure SetFunctions(Value: Boolean);
    function GetFilters: Boolean;
    procedure SetFilters(Value: Boolean);
    function GetRoles: Boolean;
    procedure SetRoles(Value: Boolean);

    property Domains: Boolean read GetDomains write SetDomains;
    property Tables: Boolean read GetTables write SetTables;
    property Constraints: Boolean read GetConstraints write SetConstraints;
    property Indices: Boolean read GetIndices write SetIndices;
    property Views: Boolean read GetViews write SetViews;
    property Procedures: Boolean read GetProcedures write SetProcedures;
    property Triggers: Boolean read GetTriggers write SetTriggers;
    property Generators: Boolean read GetGenerators write SetGenerators;
    property Exceptions: Boolean read GetExceptions write SetExceptions;
    property Functions: Boolean read GetFunctions write SetFunctions;
    property Filters: Boolean read GetFilters write SetFilters;
    property Roles: Boolean read GetRoles write SetRoles;
  end;

  IibSHDDLCommentator = interface(IibSHTool)
  ['{600FAFBF-C868-43E2-8029-FE7BB56498B6}']
    function GetMode: string;
    procedure SetMode(Value: string);
    function GetGoNext: Boolean;
    procedure SetGoNext(Value: Boolean);

    property Mode: string read GetMode write SetMode;
    property GoNext: Boolean read GetGoNext write SetGoNext;
  end;

  IibSHDDLDocumentor = interface(IibSHTool)
  ['{143A5606-8C20-4A25-AD60-3B40BCDFEFBC}']
  end;

  IibSHDDLFinder = interface(IibSHTool)
  ['{F742FE83-424E-4ACC-9C29-2A03561C4A85}']
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetFindString: string;
    procedure SetFindString(Value: string);
    function GetCaseSensitive: Boolean;
    procedure SetCaseSensitive(Value: Boolean);
    function GetWholeWordsOnly: Boolean;
    procedure SetWholeWordsOnly(Value: Boolean);
    function GetRegularExpression: Boolean;
    procedure SetRegularExpression(Value: Boolean);
    function GetLookIn: IibSHLookIn;

    function Find(const ASource: string): Boolean;
    function FindIn(const AClassIID: TGUID; const ACaption: string): Boolean;
    function LastSource: string;

    property Active: Boolean read GetActive write SetActive;
    property FindString: string read GetFindString write SetFindString;
    property CaseSensitive: Boolean read GetCaseSensitive write SetCaseSensitive;
    property WholeWordsOnly: Boolean read GetWholeWordsOnly write SetWholeWordsOnly;
    property RegularExpression: Boolean read GetRegularExpression write SetRegularExpression;
    property LookIn: IibSHLookIn read GetLookIn;
  end;

  IibSHDDLExtractor = interface(IibSHTool)
  ['{69B6954D-56BE-471F-880C-9A303C59BB1C}']
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetMode: string;
    procedure SetMode(Value: string);
    function GetHeader: string;
    procedure SetHeader(Value: string);
    function GetPassword: Boolean;
    procedure SetPassword(Value: Boolean);
    function GetGeneratorValues: Boolean;
    procedure SetGeneratorValues(Value: Boolean);
    function GetComputedSeparately: Boolean;
    procedure SetComputedSeparately(Value: Boolean);
    function GetDecodeDomains: Boolean;
    procedure SetDecodeDomains(Value: Boolean);
    function GetDescriptions: Boolean;
    procedure SetDescriptions(Value: Boolean);
    function GetGrants: Boolean;
    procedure SetGrants(Value: Boolean);
    function GetOwnerName: Boolean;
    procedure SetOwnerName(Value: Boolean);
    function GetTerminator: string;
    procedure SetTerminator(Value: string);
    function GetFinalCommit: Boolean;
    procedure SetFinalCommit(Value: Boolean);
    function GetOnTextNotify: TSHOnTextNotify;
    procedure SetOnTextNotify(Value: TSHOnTextNotify);

    procedure Prepare;
    procedure DisplayScriptHeader;
    procedure DisplayScriptFooter;
    procedure DisplayDialect;
    procedure DisplayNames;
    procedure DisplayDatabase;
    procedure DisplayConnect;
    procedure DisplayTerminatorStart;
    procedure DisplayTerminatorEnd;
    procedure DisplayCommitWork;
    // Flag: Procedure Headers(0)
    procedure DisplayDBObject(const AClassIID: TGUID; const ACaption: string; Flag: Integer = -1);
    procedure DisplayGrants;

    function GetComputedList: TStrings;
    function GetPrimaryList: TStrings;
    function GetUniqueList: TStrings;
    function GetForeignList: TStrings;
    function GetCheckList: TStrings;
    function GetIndexList: TStrings;
    function GetTriggerList: TStrings;
    function GetDescriptionList: TStrings;
    function GetGrantList: TStrings;

    property Active: Boolean read GetActive write SetActive;
    property Mode: string read GetMode write SetMode;
    property Header: string read GetHeader write SetHeader;
    property Password: Boolean read GetPassword write SetPassword;
    property GeneratorValues: Boolean read GetGeneratorValues write SetGeneratorValues;
    property ComputedSeparately: Boolean read GetComputedSeparately write SetComputedSeparately;
    property DecodeDomains: Boolean read GetDecodeDomains write SetDecodeDomains;
    property Descriptions: Boolean read GetDescriptions write SetDescriptions;
    property Grants: Boolean read GetGrants write SetGrants;
    property OwnerName: Boolean read GetOwnerName write SetOwnerName;
    property Terminator: string read GetTerminator write SetTerminator;
    property FinalCommit: Boolean read GetFinalCommit write SetFinalCommit;
    property OnTextNotify: TSHOnTextNotify read GetOnTextNotify write SetOnTextNotify;
  end;

  IibSHTXTLoader = interface(IibSHTool)
  ['{F85E41EE-5F60-4526-9626-B742335363D5}']
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetFileName: string;
    procedure SetFileName(Value: string);
    function GetInsertSQL: TStrings;
    function GetErrorText: string;
    function GetDelimiter: string;
    procedure SetDelimiter(Value: string);
    function GetTrimValues: Boolean;
    procedure SetTrimValues(Value: Boolean);
    function GetTrimLengths: Boolean;
    procedure SetTrimLengths(Value: Boolean);
    function GetAbortOnError: Boolean;
    procedure SetAbortOnError(Value: Boolean);
    function GetCommitEachLine: Boolean;
    procedure SetCommitEachLine(Value: Boolean);
    function GetColumnCheckOnly: Integer;
    procedure SetColumnCheckOnly(Value: Integer);
    function GetVerbose: Boolean;
    procedure SetVerbose(Value: Boolean);
    function GetOnTextNotify: TSHOnTextNotify;
    procedure SetOnTextNotify(Value: TSHOnTextNotify);

    function GetStringCount: Integer;
    function GetCurLineNumber: Integer;
    function Execute: Boolean;
    function InTransaction: Boolean;
    procedure Commit;
    procedure Rollback;

    property Active: Boolean read GetActive write SetActive;
    property FileName: string read GetFileName write SetFileName;
    property InsertSQL: TStrings read GetInsertSQL;
    property ErrorText: string read GetErrorText;
    property Delimiter: string read GetDelimiter write SetDelimiter;
    property TrimValues: Boolean read GetTrimValues write SetTrimValues;
    property TrimLengths: Boolean read GetTrimLengths write SetTrimLengths;
    property AbortOnError: Boolean read GetAbortOnError write SetAbortOnError;
    property CommitEachLine: Boolean read GetCommitEachLine write SetCommitEachLine;
    property ColumnCheckOnly: Integer read GetColumnCheckOnly write SetColumnCheckOnly;

    property Verbose: Boolean read GetVerbose write SetVerbose;
    property OnTextNotify: TSHOnTextNotify read GetOnTextNotify write SetOnTextNotify;
  end;

  IibSHBlobEditor = interface(IibSHTool)
  ['{BABD6B0C-0B13-4B95-BF0D-347378DAF95C}']
  end;

  IibSHReportManager = interface(IibSHTool)
  ['{843AADA5-B58F-45E2-B273-C081617CABCC}']
  end;

  IibSHDataGenerator = interface(IibSHTool)
  ['{165B0809-52A1-450F-B3F8-9A4692FE6A1F}']
  end;

  IibSHDBComparer = interface(IibSHTool)
  ['{E776498E-2CB1-4D3D-858F-96DA53B5B3C2}']
  end;

  IibSHSecondaryFiles = interface(IibSHTool)
  ['{6E318C61-6AA4-4986-91A6-C001CC654605}']
  end;

  IibSHCVSExchanger = interface(IibSHTool)
  ['{9235C797-D904-4441-A5AF-7C1D3BC00BB6}']
  end;

  IibSHDBDesigner = interface(IibSHTool)
  ['{19EDD484-65CB-4BE1-8032-B57DD73C0C26}']
  end;

  { Services }
  IibSHService = interface(IibSHTool)
  ['{72065280-AF55-4AF7-8131-83522224A36D}']
    function GetDRVService: IibSHDRVService;
    function GetDatabaseName: string;
    procedure SetDatabaseName(Value: string);
    function GetErrorText: string;
    procedure SetErrorText(Value: string);
    function GetOnTextNotify: TSHOnTextNotify;
    procedure SetOnTextNotify(Value: TSHOnTextNotify);

    function Execute: Boolean;

    property DRVService: IibSHDRVService read GetDRVService;
    property DatabaseName: string read GetDatabaseName write SetDatabaseName;
    property ErrorText: string read GetErrorText write SetErrorText;
    property OnTextNotify: TSHOnTextNotify read GetOnTextNotify write SetOnTextNotify;
  end;

  IibSHServerProps = interface(IibSHService)
  ['{AF50436C-FBA5-41DA-9DFC-8188D0BAE4A5}']
  end;

  IibSHServerLog = interface(IibSHService)
  ['{CACE0E68-401C-4D73-BCC4-1D655641807C}']
  end;

  IibSHServerConfig = interface(IibSHService)
  ['{5322517F-A114-4CD3-A643-A3841F0147B7}']
  end;

  IibSHServerLicense = interface(IibSHService)
  ['{FCEDDD13-B1A0-4781-8620-2C5FE17411A7}']
  end;

  IibSHDatabaseShutdown = interface(IibSHService)
  ['{2E8A3AA4-9871-43E0-99EE-53EF7A33BD0A}']
  end;

  IibSHDatabaseOnline = interface(IibSHService)
  ['{4E8122EA-4F3F-43B3-9DFF-6C5EB9CF5F48}']
  end;

  IibSHBackupRestoreService = interface(IibSHService)
  ['{79A37CE0-EB23-4AF7-B45E-A51E73AA6C1A}']
    function GetSourceFileList: TStrings;
    function GetDestinationFileList: TStrings;

    property SourceFileList: TStrings read GetSourceFileList;
    property DestinationFileList: TStrings read GetDestinationFileList;
  end;

  IibSHDatabaseBackup = interface(IibSHService)
  ['{B4B3A02A-D464-44BD-B04B-88B29C5D43F5}']
  end;

  IibSHDatabaseRestore = interface(IibSHService)
  ['{68A91EFA-A07C-494D-96CA-DEF67D975D65}']
  end;

  IibSHDatabaseStatistics = interface(IibSHService)
  ['{86645FA0-2737-4535-A58B-A7423BD6CF16}']
  end;

  IibSHDatabaseValidation = interface(IibSHService)
  ['{B3824F7D-FA57-42C1-BBA5-42125E241DB4}']
  end;

  IibSHDatabaseSweep = interface(IibSHService)
  ['{909AB7EA-2C47-4FF4-BF6A-2EDA95C05A89}']
  end;

  IibSHDatabaseMend = interface(IibSHService)
  ['{6DF8DEB0-4F66-4AB2-841B-4173A8543A1D}']
  end;

  IibSHTransactionRecovery = interface(IibSHService)
  ['{BAC20386-E0C1-4CED-B271-B4873E18BC37}']
  end;

  IibSHDatabaseProps = interface(IibSHService)
  ['{8E238E00-5498-4DA3-9F1D-40DE7FF87475}']
  end;

  { Options }

  IibSHOptions = interface(ISHComponentOptions)
  ['{0EBB91E9-C010-420C-A0DA-8B2F2FF8E32C}']
  end;

  IfbSHOptions = interface(ISHComponentOptions)
  ['{11D79503-51A7-4E14-9FB7-BC081CC34A1C}']
  end;

  IibSHServerOptions = interface(ISHComponentOptions)
  ['{7554712C-3010-40E2-90A2-1EF55F50693A}']
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

    property Host: string read GetHost write SetHost;
    property Version: string read GetVersion write SetVersion;
    property ClientLibrary: string read GetClientLibrary write SetClientLibrary;
    property Protocol: string read GetProtocol write SetProtocol;
    property Port: string read GetPort write SetPort;
    property SecurityDatabase: string read GetSecurityDatabase write SetSecurityDatabase;
    property UserName: string read GetUserName write SetUserName;
    property Password: string read GetPassword write SetPassword;
    property Role: string read GetRole write SetRole;
    property LoginPrompt: Boolean read GetLoginPrompt write SetLoginPrompt;
    //Invisible
    //DataForm
    property SaveResultFilterIndex: Integer read GetSaveResultFilterIndex write SetSaveResultFilterIndex;
  end;

  IfbSHServerOptions = interface
  ['{E8FAA97F-F3A8-44D9-BAA1-3A9B8D0D1652}']
  end;

  IibSHDatabaseOptions = interface(ISHComponentOptions)
  ['{B59C248C-7DC2-4FF0-9BA0-2C2DD216A564}']
    function GetCharset: string;
    procedure SetCharset(Value: string);
    function GetCapitalizeNames: Boolean;
    procedure SetCapitalizeNames(Value: Boolean);

    property Charset: string read GetCharset write SetCharset;
    property CapitalizeNames: Boolean read GetCapitalizeNames write SetCapitalizeNames;
  end;

  IfbSHDatabaseOptions = interface
  ['{02A2F059-8913-44D0-9520-4DCAE1833071}']
  end;

//  ----------------------------------------------------------------------------
  IibSHDDLOptions = interface
  ['{44676723-368A-4FE2-9CA0-D2CC4321F4AA}']
    function GetAutoCommit: Boolean;
    procedure SetAutoCommit(Value: Boolean);
    function GetStartDomainForm: string;
    procedure SetStartDomainForm(Value: string);
    function GetStartTableForm: string;
    procedure SetStartTableForm(Value: string);
    function GetStartIndexForm: string;
    procedure SetStartIndexForm(Value: string);
    function GetStartViewForm: string;
    procedure SetStartViewForm(Value: string);
    function GetStartProcedureForm: string;
    procedure SetStartProcedureForm(Value: string);
    function GetStartTriggerForm: string;
    procedure SetStartTriggerForm(Value: string);
    function GetStartGeneratorForm: string;
    procedure SetStartGeneratorForm(Value: string);
    function GetStartExceptionForm: string;
    procedure SetStartExceptionForm(Value: string);
    function GetStartFunctionForm: string;
    procedure SetStartFunctionForm(Value: string);
    function GetStartFilterForm: string;
    procedure SetStartFilterForm(Value: string);
    function GetStartRoleForm: string;
    procedure SetStartRoleForm(Value: string);

    property AutoCommit: Boolean read GetAutoCommit write SetAutoCommit;
    property StartDomainForm: string read GetStartDomainForm write SetStartDomainForm;
    property StartTableForm: string read GetStartTableForm write SetStartTableForm;
    property StartIndexForm: string read GetStartIndexForm write SetStartIndexForm;
    property StartViewForm: string read GetStartViewForm write SetStartViewForm;
    property StartProcedureForm: string read GetStartProcedureForm write SetStartProcedureForm;
    property StartTriggerForm: string read GetStartTriggerForm write SetStartTriggerForm;
    property StartGeneratorForm: string read GetStartGeneratorForm write SetStartGeneratorForm;
    property StartExceptionForm: string read GetStartExceptionForm write SetStartExceptionForm;
    property StartFunctionForm: string read GetStartFunctionForm write SetStartFunctionForm;
    property StartFilterForm: string read GetStartFilterForm write SetStartFilterForm;
    property StartRoleForm: string read GetStartRoleForm write SetStartRoleForm;
  end;

  IibSHDMLOptions = interface
  ['{BE067240-AE3A-4EE3-BB83-F4178C74688D}']
    function GetAutoCommit: Boolean;
    procedure SetAutoCommit(Value: Boolean);
    function GetShowDB_KEY: Boolean;
    procedure SetShowDB_KEY(Value: Boolean);
    function GetUseDB_KEY: Boolean;
    procedure SetUseDB_KEY(Value: Boolean);
    function GetConfirmEndTransaction: string;
    procedure SetConfirmEndTransaction(Value: string);
    function GetDefaultTransactionAction: string;
    procedure SetDefaultTransactionAction(Value: string);
    function GetIsolationLevel: string;
    procedure SetIsolationLevel(Value: string);
    function GetTransactionParams: TStrings;
    procedure SetTransactionParams(Value: TStrings);

    property AutoCommit: Boolean read GetAutoCommit write SetAutoCommit;
    property ShowDB_KEY: Boolean read GetShowDB_KEY write SetShowDB_KEY;
    property UseDB_KEY: Boolean read GetUseDB_KEY write SetUseDB_KEY;
    property ConfirmEndTransaction: string read GetConfirmEndTransaction write SetConfirmEndTransaction;
    property DefaultTransactionAction: string read GetDefaultTransactionAction write SetDefaultTransactionAction;
    property IsolationLevel: string read GetIsolationLevel write SetIsolationLevel;
    property TransactionParams: TStrings read GetTransactionParams write SetTransactionParams;
  end;

  IibSHNavigatorOptions = interface
  ['{2CB5DCEE-E7B0-4F43-ADA7-E99444066966}']
    function GetFavoriteObjectNames: TStrings;
    procedure SetFavoriteObjectNames(Value: TStrings);
    function GetFavoriteObjectColor: TColor;
    procedure SetFavoriteObjectColor(Value: TColor);
    function GetShowDomains: Boolean;
    procedure SetShowDomains(Value: Boolean);
    function GetShowTables: Boolean;
    procedure SetShowTables(Value: Boolean);
    function GetShowViews: Boolean;
    procedure SetShowViews(Value: Boolean);
    function GetShowProcedures: Boolean;
    procedure SetShowProcedures(Value: Boolean);
    function GetShowTriggers: Boolean;
    procedure SetShowTriggers(Value: Boolean);
    function GetShowGenerators: Boolean;
    procedure SetShowGenerators(Value: Boolean);
    function GetShowExceptions: Boolean;
    procedure SetShowExceptions(Value: Boolean);
    function GetShowFunctions: Boolean;
    procedure SetShowFunctions(Value: Boolean);
    function GetShowFilters: Boolean;
    procedure SetShowFilters(Value: Boolean);
    function GetShowRoles: Boolean;
    procedure SetShowRoles(Value: Boolean);
    function GetShowIndices: Boolean;
    procedure SetShowIndices(Value: Boolean);

    property FavoriteObjectNames: TStrings read GetFavoriteObjectNames write SetFavoriteObjectNames;
    property FavoriteObjectColor: TColor read GetFavoriteObjectColor write SetFavoriteObjectColor;
    property ShowDomains: Boolean read GetShowDomains write SetShowDomains;
    property ShowTables: Boolean read GetShowTables write SetShowTables;
    property ShowViews: Boolean read GetShowViews write SetShowViews;
    property ShowProcedures: Boolean read GetShowProcedures write SetShowProcedures;
    property ShowTriggers: Boolean read GetShowTriggers write SetShowTriggers;
    property ShowGenerators: Boolean read GetShowGenerators write SetShowGenerators;
    property ShowExceptions: Boolean read GetShowExceptions write SetShowExceptions;
    property ShowFunctions: Boolean read GetShowFunctions write SetShowFunctions;
    property ShowFilters: Boolean read GetShowFilters write SetShowFilters;
    property ShowRoles: Boolean read GetShowRoles write SetShowRoles;
    property ShowIndices: Boolean read GetShowIndices write SetShowIndices;    
  end;

  IibSHDatabaseAliasOptions = interface
  ['{EBE8842E-19C1-4C41-B9FF-2A93B7823129}']
    function GetDDL: IibSHDDLOptions;
    function GetDML: IibSHDMLOptions;
    function GetNavigator: IibSHNavigatorOptions;

    property DDL: IibSHDDLOptions read GetDDL;
    property DML: IibSHDMLOptions read GetDML;
    property Navigator: IibSHNavigatorOptions read GetNavigator;
  end;

  IibSHDatabaseAliasOptionsInt = interface
  ['{929467CA-A5B2-45EF-8C10-9272DE2960D6}']
    function GetFilterList: TStrings;
    procedure SetFilterList(Value: TStrings);
    function GetFilterIndex: Integer;
    procedure SetFilterIndex(Value: Integer);

    function GetDMLHistoryActive: Boolean;
    procedure SetDMLHistoryActive(const Value: Boolean);
    function GetDMLHistoryMaxCount: Integer;
    procedure SetDMLHistoryMaxCount(const Value: Integer);
    function GetDMLHistorySelect: Boolean;
    procedure SetDMLHistorySelect(const Value: Boolean);
    function GetDMLHistoryInsert: Boolean;
    procedure SetDMLHistoryInsert(const Value: Boolean);
    function GetDMLHistoryUpdate: Boolean;
    procedure SetDMLHistoryUpdate(const Value: Boolean);
    function GetDMLHistoryDelete: Boolean;
    procedure SetDMLHistoryDelete(const Value: Boolean);
    function GetDMLHistoryExecute: Boolean;
    procedure SetDMLHistoryExecute(const Value: Boolean);
    function GetDMLHistoryCrash: Boolean;
    procedure SetDMLHistoryCrash(const Value: Boolean);

    function GetDDLHistoryActive: Boolean;
    procedure SetDDLHistoryActive(const Value: Boolean);

    //For Database Alias Filter
    property FilterList: TStrings read GetFilterList write SetFilterList;
    property FilterIndex: Integer read GetFilterIndex write SetFilterIndex;

    //For DML History
    property DMLHistoryActive: Boolean read GetDMLHistoryActive
      write SetDMLHistoryActive;
    property DMLHistoryMaxCount: Integer read GetDMLHistoryMaxCount
      write SetDMLHistoryMaxCount;
    property DMLHistorySelect: Boolean read GetDMLHistorySelect
      write SetDMLHistorySelect;
    property DMLHistoryInsert: Boolean read GetDMLHistoryInsert
      write SetDMLHistoryInsert;
    property DMLHistoryUpdate: Boolean read GetDMLHistoryUpdate
      write SetDMLHistoryUpdate;
    property DMLHistoryDelete: Boolean read GetDMLHistoryDelete
      write SetDMLHistoryDelete;
    property DMLHistoryExecute: Boolean read GetDMLHistoryExecute
      write SetDMLHistoryExecute;
    property DMLHistoryCrash: Boolean read GetDMLHistoryCrash
      write SetDMLHistoryCrash;
    //For DDL History
    property DDLHistoryActive: Boolean read GetDDLHistoryActive
      write SetDDLHistoryActive;
  end;  
//  ----------------------------------------------------------------------------

  {Editor}
  IibSHKeywordsList = interface
  ['{F3C2E68C-D9CA-461E-A11A-7CA9342E7D9A}']
    function GetFunctionList: TStrings;
    function GetDataTypeList: TStrings;
    function GetKeywordList: TStrings;
    function GetAllKeywordList: TStrings;

    property FunctionList: TStrings read GetFunctionList;
    property DataTypeList: TStrings read GetDataTypeList;
    property KeywordList: TStrings read GetKeywordList;
    property AllKeywordList: TStrings read GetAllKeywordList;
  end;

  IibSHEditorRegistrator = interface
  ['{92F3E712-E2FC-4567-8055-0918B185813A}']
    procedure AfterChangeServerVersion(Sender: TObject);
    procedure RegisterEditor(AEditor: TComponent; AServer, ADatabase: IInterface);
    function GetKeywordsManager(AServer: IInterface): IInterface;
    function GetObjectNameManager(AServer, ADatabase: IInterface): IInterface;
  end;

  IibSHAutoComplete = interface
  ['{863802AC-7F9A-4455-A32C-F851C87B10AB}']

  end;

  IibSHAutoReplace = interface
  ['{01F48236-59F6-4E9B-A6E5-92731F28E57D}']

  end;

  IibCustomStrings = interface
  ['{3F7CDD61-27E8-4EA6-B6FA-93726E5FDFEE}']

  end;

(*
  IibSHSQLInfo = interface
  ['{71A0DEF6-C7C7-45D8-B1C8-9F3FB0671470}']
    function GetSQL: TStrings;
    function GetBTCLDatabase: IibSHDatabase;
    function GetResultType: string;
    function GetTransaction: IibSHDRVTransaction;
    function GetDataset: IibSHDRVDataset;
    procedure SetDataset(Value: IibSHDRVDataset);

    property SQL: TStrings read GetSQL;
    property BTCLDatabase: IibSHDatabase read GetBTCLDatabase;
    property ResultType: string read GetResultType;
    property Transaction: IibSHDRVTransaction read GetTransaction;
    property Dataset: IibSHDRVDataset read GetDataset write SetDataset;
  end;
*)
  IibSHDDLInfo = interface
  ['{65A0BEA3-7541-40B2-AC5C-BDE75B41E2F4}']
    function GetDDL: TStrings;
    function GetBTCLDatabase: IibSHDatabase;
    function GetState: TSHDBComponentState;

    property DDL: TStrings read GetDDL;
    property BTCLDatabase: IibSHDatabase read GetBTCLDatabase;
    property State: TSHDBComponentState read GetState;
  end;

  TibSHDependenceType = (dtUsedBy, dtUses);

  IibSHDependencies = interface
  ['{74B5799D-25DD-4E99-82BA-CC795C59E166}']
    procedure Execute(AType: TibSHDependenceType; const BTCLDatabase: IibSHDatabase;
      const AClassIID: TGUID; const ACaption: string; AOwnerCaption: string = '');
    function GetObjectNames(const AClassIID: TGUID; AOwnerCaption: string = ''): TStrings;
    function IsEmpty: Boolean;
  end;

  IibSHPSQLDebugger = interface
  ['{C09789E6-ECED-4619-AB84-0C9F6FE5ACA9}']
    function GetDebugComponent: TSHComponent;
    function GetDRVTransaction: IibSHDRVTransaction;
    function GetParentDebugger: IibSHPSQLDebugger;

    procedure Debug(AParentDebugger: IibSHPSQLDebugger; AClassIID: TGUID; ACaption: string);

    property DebugComponent: TSHComponent read GetDebugComponent;
    property DRVTransaction: IibSHDRVTransaction read GetDRVTransaction;
    property ParentDebugger: IibSHPSQLDebugger read GetParentDebugger;
  end;

// ComponentForm Interfaces

  IibSHDDLForm = interface(ISHComponentForm)
  ['{0827E71A-4092-413D-B492-E7635EEFF74A}']
    function GetDDLText: TStrings;
    procedure SetDDLText(Value: TStrings);
    function GetOnAfterRun: TNotifyEvent;
    procedure SetOnAfterRun(Value: TNotifyEvent);
    function GetOnAfterCommit: TNotifyEvent;
    procedure SetOnAfterCommit(Value: TNotifyEvent);
    function GetOnAfterRollback: TNotifyEvent;
    procedure SetOnAfterRollback(Value: TNotifyEvent);

    procedure PrepareControls;
    procedure ShowDDLText;

    property DDLText: TStrings read GetDDLText write SetDDLText;
    property OnAfterRun: TNotifyEvent read GetOnAfterRun write SetOnAfterRun;
    property OnAfterCommit: TNotifyEvent read GetOnAfterCommit write SetOnAfterCommit;
    property OnAfterRollback: TNotifyEvent read GetOnAfterRollback write SetOnAfterRollback;
  end;

  IibSHTableForm = interface(ISHComponentForm)
  ['{1CF92A26-33A4-47FE-A4C5-60DA5A8C7576}']
    function GetDBComponent: TSHComponent;

    property DBComponent: TSHComponent read GetDBComponent;
  end;

  IibSHFieldOrderForm = interface(ISHComponentForm)
  ['{BC7DD945-4E9B-4B3C-8EF5-816B775FE7DF}']
    function GetCanMoveUp: Boolean;
    function GetCanMoveDown: Boolean;

    procedure MoveUp;
    procedure MoveDown;

    property CanMoveUp: Boolean read GetCanMoveUp;
    property CanMoveDown: Boolean read GetCanMoveDown;
  end;

  IibSHDDLFinderForm = interface(ISHComponentForm)
  ['{69F2CDED-F120-4487-A8A8-E1A6BDEA4ACD}']
    function GetCanShowNextResult: Boolean;
    function GetCanShowPrevResult: Boolean;

    procedure ShowNextResult;
    procedure ShowPrevResult;

    property CanShowNextResult: Boolean read GetCanShowNextResult;
    property CanShowPrevResult: Boolean read GetCanShowPrevResult;
  end;

  IibSHDDLGrantorForm = interface(ISHComponentForm)
  ['{5F480382-A026-4AEC-BA0F-DE23E684A78A}']
    procedure RefreshPrivilegesForTree;
    procedure RefreshGrantsOnTree;
  end;

  IibSHSQLEditorForm = interface(ISHComponentForm)
  ['{5A59E816-B8DB-469A-AB3D-6A74B5CE97C7}']
    function GetSQLText: string;
    procedure ShowPlan;
    procedure ShowTransactionCommited;
    procedure ShowTransactionRolledBack;
    procedure ShowStatistics;
    procedure ClearMessages;
    procedure InsertStatement(AText: string);
    procedure LoadLastContext;

    function GetCanPreviousQuery: Boolean;
    function GetCanNextQuery: Boolean;
    function GetCanPrepare: Boolean;
    function GetCanEndTransaction: Boolean;

    procedure PreviousQuery;
    procedure NextQuery;
    procedure RunAndFetchAll;
    procedure Prepare;

    property SQLText: string read GetSQLText;
  end;

  TibSHImageFormat = (imUnknown, imBitmap, imJPEG, imWMF, imEMF, imICO);

  IibSHDataCustomForm = interface(ISHComponentForm)
  ['{0E32EE91-9EF0-4EA3-A424-B245234F3609}']
    function GetImageStreamFormat(AStream: TStream): TibSHImageFormat;
    function GetCanFilter: Boolean;
    function GetFiltered: Boolean;
    procedure SetFiltered(Value: Boolean);
    function GetAutoCommit: Boolean;

    procedure AddToResultEdit(AText: string; DoClear: Boolean = True);
    procedure SetDBGridOptions(ADBGrid: TComponent);

    property CanFilter: Boolean read GetCanFilter;
    property Filtered: Boolean read GetFiltered write SetFiltered;
    property AutoCommit: Boolean read GetAutoCommit;
  end;

  IibSHDataVCLForm = interface(ISHComponentForm)
  ['{7A2E7DD3-8B3B-46C7-AB4B-C870C68E20F0}']
    function GetAutoAdjustNodeHeight: Boolean;
    procedure SetAutoAdjustNodeHeight(Value: Boolean);
    function GetCanSelectNextField: Boolean;
    function GetCanSelectPreviousField: Boolean;

    procedure SelectNextField;
    procedure SelectPreviouField;

    property AutoAdjustNodeHeight: Boolean read GetAutoAdjustNodeHeight
      write SetAutoAdjustNodeHeight;
    property CanSelectNextField: Boolean read GetCanSelectNextField;
    property CanSelectPreviousField: Boolean read GetCanSelectPreviousField;
  end;

  IibSHSQLPlayerForm = interface(ISHComponentForm)
  ['{D822F7E6-A064-432C-84D3-D9D9BE40FDCB}']
    function GetCanRunCurrent: Boolean;
    function GetCanRunFromCurrent: Boolean;
    function GetCanRunFromFile: Boolean;
    function GetRegionVisible: Boolean;


    function ChangeNotification: Boolean;
    procedure CheckAll;
    procedure UnCheckAll;
    procedure InsertScript(AText: string);
    procedure RunCurrent;
    procedure RunFromCurrent;
    procedure RunFromFile;

    property CanRunCurrent: Boolean read GetCanRunCurrent;
    property CanRunFromCurrent: Boolean read GetCanRunFromCurrent;
    property CanRunFromFile: Boolean read GetCanRunFromFile;
    property RegionVisible: Boolean read GetRegionVisible;
  end;

  IibSHSQLMonitorForm = interface(ISHComponentForm)
  ['{8FED1B58-444C-4D2D-AE86-5736A09777E9}']
    function CanJumpToApplication: Boolean;
    procedure JumpToApplication;
  end;

  IibSHStatisticsForm = interface(ISHComponentForm)
  ['{04B710E0-23BA-41BA-97D0-80CD938F8C8F}']
  end;

  IibSHDMLHistoryForm = interface(ISHComponentForm)
  ['{A313ACC8-CFCF-4BFF-9801-555CBE0073C5}']
    function GetRegionVisible: Boolean;
    procedure FillEditor;
    procedure ChangeNotification(AOldItem: Integer; Operation: TOperation);
    function GetCanSendToSQLEditor: Boolean;
    procedure SendToSQLEditor;

    property RegionVisible: Boolean read GetRegionVisible;
  end;

  IibSHDDLHistoryForm = interface(ISHComponentForm)
  ['{F3792938-57F4-46EC-B611-7BB622738EDB}']
    function GetRegionVisible: Boolean;
    procedure FillEditor;
    procedure ChangeNotification;
    function GetCanSendToSQLPlayer: Boolean;
    procedure SendToSQLPlayer;
    function GetCanSendToSQLEditor: Boolean;
    procedure SendToSQLEditor;

    property RegionVisible: Boolean read GetRegionVisible;
  end;

  IibSHDMLExporterForm = interface(ISHComponentForm)
  ['{131962AA-B737-4693-852D-F9D0B717C72C}']
    function GetCanMoveDown: Boolean;
    function GetCanMoveUp: Boolean;

    procedure UpdateTree;
    procedure CheckAll;
    procedure UnCheckAll;
    procedure MoveDown;
    procedure MoveUp;    
    property CanMoveDown: Boolean read GetCanMoveDown;
    property CanMoveUp: Boolean read GetCanMoveUp;
  end;

  IibSHPSQLDebuggerForm = interface(ISHComponentForm)
  ['{49780B97-45EA-4FB0-88C9-847F0D9BE52E}']
    function GetCanAddWatch: Boolean;
    function GetCanReset: Boolean;
    function GetCanRunToCursor: Boolean;
    function GetCanSetParameters: Boolean;
    function GetCanSkipStatement: Boolean;
    function GetCanStepOver: Boolean;
    function GetCanToggleBreakpoint: Boolean;
    function GetCanTraceInto: Boolean;
    function GetCanModifyVarValues: Boolean;

    function ChangeNotification: Boolean;

    procedure AddWatch;
    procedure Reset;
    procedure RunToCursor;
    procedure SetParameters;
    procedure SkipStatement;
    procedure StepOver;
    procedure ToggleBreakpoint;
    procedure ModifyVarValues;
    procedure TraceInto;

    property CanAddWatch: Boolean read GetCanAddWatch;
    property CanReset: Boolean read GetCanReset;
    property CanRunToCursor: Boolean read GetCanRunToCursor;
    property CanSetParameters: Boolean read GetCanSetParameters;
    property CanSkipStatement: Boolean read GetCanSkipStatement;
    property CanStepOver: Boolean read GetCanStepOver;
    property CanToggleBreakpoint: Boolean read GetCanToggleBreakpoint;
    property CanTraceInto: Boolean read GetCanTraceInto;

  end;

implementation

end.







