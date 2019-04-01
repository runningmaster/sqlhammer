unit ibSHConsts;

interface

const

  ibdInterBase4  = 1;
  ibdInterBase5  = 2;
  ibdInterBase6  = 3;
  ibdInterBase65 = 4;
  ibdInterBase7  = 5;
  ibdInterBase75 = 6;
  ibdFirebird1   = 7;
  ibdFirebird15  = 8;
  ibdFirebird20  = 9;
  ibdInterbase2007=10;
  ibdFirebird21  = 11;  

  
const
  { DBObjects }
  SClassHintDomain                      = 'Domain';
  SClassHintTable                       = 'Table';
  SClassHintConstraint                  = 'Constraint';
  SClassHintIndex                       = 'Index';
  SClassHintView                        = 'View';
  SClassHintProcedure                   = 'Procedure';
  SClassHintTrigger                     = 'Trigger';
  SClassHintGenerator                   = 'Generator';
  SClassHintException                   = 'Exception';
  SClassHintFunction                    = 'Function';
  SClassHintFilter                      = 'Filter';
  SClassHintRole                        = 'Role';
  SClassHintShadow                      = 'Shadow';

  SClassHintSystemDomain                = 'System Domain';
  SClassHintSystemGeneratedDomain       = 'System Gen Domain';
  SClassHintSystemTable                 = 'System Table';
  SClassHintSystemGeneratedTrigger      = 'System Gen Trigger';
  SClassHintSystemGeneratedConstraint   = 'System Gen Constraint';

  SClassAssocDomain                     = 'Domain';
  SClassAssocTable                      = 'Table';
  SClassAssocConstraint                 = 'Constraint';
  SClassAssocIndex                      = 'Index';
  SClassAssocView                       = 'View';
  SClassAssocProcedure                  = 'Procedure';
  SClassAssocTrigger                    = 'Trigger';
  SClassAssocGenerator                  = 'Generator';
  SClassAssocException                  = 'Exception';
  SClassAssocFunction                   = 'Function';
  SClassAssocFilter                     = 'Filter';
  SClassAssocRole                       = 'Role';
  SClassAssocShadow                     = 'Shadow';

  SClassAssocSystemDomain               = 'System';
  SClassAssocSystemGeneratedDomain      = 'System';
  SClassAssocSystemTable                = 'System';
  SClassAssocSystemGeneratedTrigger     = 'System';
  SClassAssocSystemGeneratedConstraint  = 'System';

  SClassAssocField                      = 'Field';
  SClassAssocProcParam                  = 'Parameter';

  { Tools }
  SClassHintSQLEditor                   = 'SQL Editor';
  SClassHintDMLHistory                  = 'DML History';
  SClassHintDDLHistory                  = 'DDL History';
  SClassHintSQLPerformance              = 'SQL Performance';
  SClassHintSQLPlan                     = 'SQL Plan Analyzer';
  SClassHintSQLPlayer                   = 'SQL Player';
  SClassHintDMLExporter                = 'DML Exporter';
  SClassHintFIBMonitor                  = 'FIB Monitor';
  SClassHintIBXMonitor                  = 'IBX Monitor';
  SClassHintDDLGrantor                  = 'DDL Grantor';
  SClassHintUserManager                 = 'User Manager';
  SClassHintDDLCommentator              = 'DDL Commentator';
  SClassHintDDLDocumentor               = 'DDL Documentor';
  SClassHintDDLFinder                   = 'DDL Finder';
  SClassHintDDLExtractor                = 'DDL Extractor';
  SClassHintTXTLoader                   = 'TXT Loader';
  SClassHintBlobEditor                  = 'Blob Editor';
  SClassHintReportManager               = 'Report Manager';
  SClassHintDataGenerator               = 'Test Data Generator';
  SClassHintDBComparer                  = 'Database Comparer';
  SClassHintSecondaryFiles              = '2nd Files Manager';
  SClassHintCVSExchanger                = 'CVS Exchanger';
  SClassHintDBDesigner                  = 'Database Designer';
  SClassHintPSQLDebugger                 = 'PSQL Debugger';

  SClassAssocSQLEditor                  = 'Tool';
  SClassAssocDMLHistory                 = 'Tool';
  SClassAssocDDLHistory                 = 'Tool';
  SClassAssocSQLPerformance             = 'Tool';
  SClassAssocSQLPlan                    = 'Tool';
  SClassAssocSQLPlayer                  = 'Tool';
  SClassAssocDMLExporter                = 'Tool';
  SClassAssocFIBMonitor                 = 'Tool';
  SClassAssocIBXMonitor                 = 'Tool';
  SClassAssocDDLGrantor                 = 'Tool';
  SClassAssocUserManager                = 'Tool';
  SClassAssocDDLCommentator             = 'Tool';
  SClassAssocDDLDocumentor              = 'Tool';
  SClassAssocDDLFinder                 = 'Tool';
  SClassAssocDDLExtractor               = 'Tool';
  SClassAssocTXTLoader                  = 'Tool';
  SClassAssocBlobEditor                 = 'Tool';
  SClassAssocReportManager              = 'Tool';
  SClassAssocDataGenerator              = 'Tool';
  SClassAssocDBComparer                 = 'Tool';
  SClassAssocSecondaryFiles             = 'Tool';
  SClassAssocCVSExchanger               = 'Tool';
  SClassAssocDBDesigner                 = 'Tool';
  SClassAssocPSQLDebugger               = 'Tool';

  { Services}
  SClassHintServerProps                 = 'Server Properties';
  SClassHintServerLog                   = 'Server Log';
  SClassHintServerConfig                = 'Server Config';
  SClassHintServerLicense               = 'Server License';
  SClassHintDatabaseShutdown            = 'Database Shutdown';
  SClassHintDatabaseOnline              = 'Database Online';
  SClassHintDatabaseBackup              = 'Database Backup';
  SClassHintDatabaseRestore             = 'Database Restore';
  SClassHintDatabaseStatistics          = 'Database Statistics';
  SClassHintDatabaseValidation          = 'Database Validation';
  SClassHintDatabaseSweep               = 'Database Sweep';
  SClassHintDatabaseMend                = 'Database Mend';
  SClassHintTransactionRecovery         = 'Transaction Recovery ';
  SClassHintDatabaseProps               = 'Database Properties';

  SClassAssocServerProps                = 'Service';
  SClassAssocServerLog                  = 'Service';
  SClassAssocServerConfig               = 'Service';
  SClassAssocServerLicense              = 'Service';
  SClassAssocDatabaseShutdown           = 'Service';
  SClassAssocDatabaseOnline             = 'Service';
  SClassAssocDatabaseBackup             = 'Service';
  SClassAssocDatabaseRestore            = 'Service';
  SClassAssocDatabaseStatistics         = 'Service';
  SClassAssocDatabaseValidation         = 'Service';
  SClassAssocDatabaseSweep              = 'Service';
  SClassAssocDatabaseMend               = 'Service';
  SClassAssocTransactionRecovery        = 'Service';
  SClassAssocDatabaseProps              = 'Service';

  {Call Strings}
  SCallUnknown                          = 'Unknown ';
  SCallGUIMode                          = 'Mode';
  SCallRegister                         = 'Register';
  SCallRegisterInfo                     = 'Registration Information';
  SCallRegisterServer                   = 'Register Server';
  SCallRegisterDatabase                 = 'Register Database';
  SCallCreateDatabase                   = 'Create Database';
  SCallHost                             = 'Host';
  SCallServer                           = 'Server';
  SCallVersion                          = 'Version';
  SCallClientLibrary                    = 'ClientLibrary';
  SCallProtocol                         = 'Protocol';
  SCallDatabase                         = 'Database';
  SCallSecurityDatabase                 = 'SecurityDatabase';
  SCallPageSize                         = 'PageSize';
  SCallSQLDialect                       = 'SQLDialect';
  SCallPassword                         = 'Password';
  SCallInformation                      = 'Information';
  SCallDescription                      = 'Description';
  SCallDescriptions                     = 'Descriptions';
  SCallDependencies                     = 'Dependencies';
  SCallXHelp                            = 'Express Help';
  SCallUsedBy                           = 'UsedBy';
  SCallUses                             = 'Uses';
  SCallTRParams                         = 'TRParams';
  SCallBLR                              = 'BLR';
  SCallReferenceFields                  = 'ReferenceFields';
  SCallCheckSource                      = 'CheckSource';
  SCallSourceDDL                        = 'Source DDL';
  SCallCreateDDL                        = 'Create DDL';
  SCallAlterDDL                         = 'Alter DDL';
  SCallRecreateDDL                      = 'Recreate DDL';
  SCallDropDDL                          = 'Drop DDL';
  SCallScriptDDL                        = 'ScriptDDL';
  SCallCreate                           = 'Create';
  SCallAlter                            = 'Alter';
  SCallRecreate                         = 'Recreate';
  SCallFields                           = 'Fields';
  SCallConstraints                      = 'Constraints';
  SCallIndices                          = 'Indices';
  SCallTriggers                         = 'Triggers';
  SCallText                             = 'Text';
  SCallSQL                              = 'SQL';
  SCallSQLText                          = 'DML Statements';
  SCallDDL                              = 'DDL';
  SCallDDLText                          = 'DDL Statements';
  SCallResult                           = 'Result';
  SCallData                             = 'Data | Grid';
  SCallDataBLOB                         = 'Data | Blob';
  SCallDataForm                         = 'Data | Tree';
  SCallFieldOrder                       = 'Field Order';
  SCallFieldDescr                       = 'Field Descriptions';
  SCallParamDescr                       = 'Param Descriptions';
  SCallResultInGrid                     = 'ResultInGrid';
  SCallResultInText                     = 'Data | Text';
  SCallTXTLoader                        = 'TXT Loader';

  SCallStatistics                       = 'Statistics';
  SCallQueryResults                     = SCallData;
  SCallQueryStatistics                  = 'Statistics';
  SCallDMLHistory                       = 'DML History';
  SCallDDLHistory                       = 'DDL History';
  SCallSQLStatement                     = 'SQL Statement';
  SCallSQLStatements                    = 'SQL Statements';
  SCallDDLStatement                     = 'DDL Statement';
  SCallDDLStatements                    = 'DDL Statements';
  SCallDMLStatement                     = 'DML Statement';
  SCallDMLStatements                    = 'DML Statements';
  SCallPlayer                           = 'SQL Script';
  SCallTargetScript                     = 'Target Script';
  SCallMonitor                          = 'MonitorDDL';
  SCallFIBTrace                         = 'FIB Trace';
  SCallIBXTrace                         = 'IBX Trace';
  SCallUser                             = 'User';
  SCallUsers                            = 'Users';
  SCallSearchResults                    = 'Search Results';
  SCallServiceOutputs                   = 'Output';
  SCallAccessMode                       = 'AccessMode';
  SCallPrivileges                       = 'Privileges';
  SCallGrants                           = 'Grants';
  SCallFilter                           = 'Filter';
  SCallParams                           = 'Params';
  SCallReturns                          = 'Returns';
  SCallEngine                           = 'Engine';
  SCallDefaultSQLDialect                = 'DefaultSQLDialect';
  SCallAfterExecute                     = 'AfterExecute';
  SCallResultType                       = 'ResultType';
  SCallIsolationLevel                    = 'IsolationLevel';
  SCallPrivilegesFor                    = 'PrivilegesFor';
  SCallGrantsOn                         = 'GrantsOn';
  SCallDisplayGrants                    = 'Display';
  SCallTableName                        = 'TableName';
  SCallStatus                           = 'Status';
  SCallTypePrefix                       = 'TypePrefix';
  SCallTypeSuffix                       = 'TypeSuffix';
  SCallDefaultExpression                = 'DefaultExpression';
  SCallCheckConstraint                  = 'CheckConstraint';
  SCallComputedSource                   = 'ComputedSource';
  SCallArrayDim                         = 'ArrayDim';
  SCallDataType                         = 'DataType';
  SCallCharset                          = 'Charset';
  SCallAdditionalConnectParams          = 'AdditionalConnectParams';
  SCallCollate                          = 'Collate';
  SCallBlobSubType                      = 'SubType';
  SCallMechanism                        = 'Mechanism';
  SCallPrecision                        = 'Precision';
  SCallScale                            = 'Scale';
  SCallActiveUsers                      = 'Active Users';
  SCallInputParameters                  = 'Input Parameters';
  SCallStopAfter                        = 'StopAfter';
  SCallMode                             = 'Mode';
  SCallAfterError                    = 'AfterError';
  SCallGlobalAction                     = 'GlobalAction';
  SCallFixLimbo                         = 'FixLimbo';
  SCallTracing                          = 'Tracing';

  SCallFindInScheme                     = 'Find In Scheme';
  SCallCreateNew                        = 'Create New';
  SCallRecordCount                      = 'Record Count...';
  SCallChangeCount                      = 'Change Count...';
  SCallSetSatatistics                   = 'Recount Statistics';

  SCallLoadLastContext                  = 'Load Last Context';

  { Buttons }
  SBtnRegister                          = 'Register';
  SBtnCreate                            = 'Create';
  SBtnSave                              = 'Save';
  SBtnRegisterAfterRegister             = 'Register database alias after registering server alias';
  SBtnConnectAfterRegister              = 'Connect to database after registering database alias';
  SBtnRegisterAfterCreate               = 'Register database alias after creating database';
  SBtnGenerate                          = 'Generate';

  { Props }
  SSeeEditor                            = 'See Editor';
  SSeeEditorViewStr                     = '%s, %s';
  SSeeEditorViewInt                     = '%s, %d';
  SChangeCountView                      = '%d (%d left)';
  SEmpty                                = 'Empty';
  SUnknown                              = 'Unknown';
  SLocalhost                            = 'localhost';
  SDefaultPort                          = '3050';
  SDefaultUserName                      = 'SYSDBA';
  SDefaultPassword                      = 'masterkey';
  SPassword                             = 'Password';
  SPasswordMask                         = '********';
  SInputPassword                        = 'Input Password';
  SOpenDialogDatabaseFilter             = 'Database File (*.gdb; *.fdb; *.ib)|*.gdb; *.fdb; *.ib|All Files (*.*)|*.*';
  SOpenDialogDatabaseBackupFilter       = 'Database Backup File (*.gbk; *.fbk)|*.gbk; *.fbk|All Files (*.*)|*.*';
  SOpenDialogClientLibraryFilter        = 'Client Library (*.dll)|*.dll|All Files (*.*)|*.*';
  SOpenDialogSQLLogFilter               = 'SQL Log File (*.sql)|*.dll|All Files (*.*)|*.*';
  SOpenDialogTXTLoaderFilter            = 'CSV File (*.csv)|*.csv|TXT File (*.txt)|*.txt|All Files (*.*)|*.*';
  Sgds32                                = 'gds32.dll';
  Sfbclient                             = 'fbclient.dll';
  STypeAndObjects                       = 'Dependence Type and Objects';
  SEnterYourSearchCriteria              = 'Enter your search criteria to begin';
  SEnterYourDatabaseName                = 'Enter your database name to begin';
  SEnterYourBackupDatabaseName          = 'Enter your backup name to begin';
  SEnterYourFileImportCriteria          = 'Enter your file name to begin';
  SEnterYourDMLStatementImportCriteria  = 'Enter your INSERT INTO or EXECUTE statement to begin';

  { Component Editors }
  SRegisterServer                       = 'Register Server...';
  SRegisterDatabase                     = 'Register Database...';
  SCreateDatabase                       = 'Create Database...';
  SConnectToDatabase                    = 'Connect';
  SRefreshDatabase                      = 'Refresh';
  SDisconnectFromDatabase               = 'Disconnect';
  SReconnectToDatabase                  = 'Reconnect';
  SRegInfo                              = 'Registration Info...';
  STestConnection                       = 'Test Connection';  
  SShowActiveUsers                      = 'Active Users...';
  SUnregister                           = 'Unregister';

  SInterBase4x                          = 'InterBase 4.x';
  SInterBase5x                          = 'InterBase 5.x';
  SInterBase6x                          = 'InterBase 6.x';
  SInterBase65                          = 'InterBase 6.5';
  SInterBase70                          = 'InterBase 7.0';
  SInterBase71                          = 'InterBase 7.1';
  SInterBase75                          = 'InterBase 7.5';
  SInterBase2007                        = 'InterBase 2007';

  SFirebird1x                           = 'Firebird 1.0';
  SFirebird15                           = 'Firebird 1.5';
  SFirebird20                           = 'Firebird 2.0';
  SFirebird21                           = 'Firebird 2.1';

  ServerVersionsIB: array[0..7] of string = (
    SInterBase4x,
    SInterBase5x,
    SInterBase6x, SInterBase65,
    SInterBase70, SInterBase71, SInterBase75,
    SInterBase2007
  );

  ServerVersionsFB: array[0..3] of string = (
    SFirebird1x, SFirebird15,SFirebird20,SFirebird21);

  SUnchanged                            = 'Unchanged';
  S1024                                 = '1024';
  S2048                                 = '2048';
  S4096                                 = '4096';
  S8192                                 = '8192';
  S16384                                = '16384';

  PageSizes: array[0..5] of string = (SUnchanged,
    S1024, S2048, S4096, S8192, S16384);

  SSQLDialect1                          = '1';
  SSQLDialect2                          = '2';
  SSQLDialect3                          = '3';

  Dialects: array[0..1] of string = (
    SSQLDialect1, SSQLDialect3);
    
  Dialects2: array[0..2] of string = (
    SSQLDialect1, SSQLDialect2, SSQLDialect3);

  ObjectTypes: array[0..15, 0..1] of string = (
{0 }  ('Domain', 'Domains'),
{1 }  ('Table', 'Tables'),
{2 }  ('Index', 'Indices'),
{3 }  ('View', 'Views'),
{4 }  ('Procedure', 'Procedures'),
{5 }  ('Trigger', 'Triggers'),
{6 }  ('Generator', 'Generators'),
{7 }  ('Exception', 'Exceptions'),
{8 }  ('Function', 'Functions'),
{9 }  ('Filter', 'Filters'),
{10}  ('Role', 'Roles'),
{11}  ('Shadow', 'Shadows'),
{12}  ('Field', 'Fields'),
{13}  ('Constraint', 'Constraints'),
{14}  ('System Table', 'System Tables'),
{15}  ('System Table Tmp', 'System Tables Tmp'));
(*
//Temporary
{13}  ('System Domain', 'System Domains'),
{16}  ('System Generated Domain', 'System Generated Domains'),
{17}  ('System Generated Constraint', 'System Generated Constraints'),
{18}  ('System Generated Trigger', 'System Generated Triggers'),
{19}  ('SQL Editor', 'SQL Editors'),
{20}  ('SQL History', 'SQL Histories'),
{21}  ('SQL Performance', 'SQL Performances'),
{22}  ('SQL Plan Analyzer', 'SQL Plan Analyzers'),
{23}  ('SQL Script', 'SQL Scripts'),
{24}  ('SQL Monitor', 'SQL Monitors'),
{25}  ('Grant Manager', 'Grant Managers'),
{26}  ('User Manager', 'User Managers'),
{27}  ('Metadata Search', 'Metadata Searches'),
{28}  ('Metadata Extract', 'Metadata Extracts'),
{29}  ('BlobEditor', 'BlobEditors'),
{30}  ('DDL Documentor', 'DDL Documentors'),
{31}  ('Report Manager', 'Report Managers'),
{32}  ('Data Generator', 'Data Generators'),
{33}  ('DBComparer', 'DBComparers'),
{34}  ('Secondary Files', 'Secondary Files'),
{35}  ('CVS Exchanger', 'CVS Exchangers'),
{36}  ('DBDesigner', 'DBDesigners'));
*)

  _SMALLINT                             = 7;
  _INTEGER                              = 8;
  _BIGINT                               = 16;
  _BOOLEAN                              = 17;
  _FLOAT                                = 10;
  _DOUBLE                               = 27;
  _DATE                                 = 12;
  _TIME                                 = 13;
  _TIMESTAMP                            = 35;
  _CHAR                                 = 14;
  _VARCHAR                              = 37;
  _BLOB                                 = 261;
  _CSTRING                              = 40;
  _QUAD                                 = 9;

  DataTypes: array[0..4, 0..15] of string = (
{0 'All' }  ('SMALLINT', 'INTEGER',            'FLOAT', 'DOUBLE PRECISION', 'NUMERIC', 'DECIMAL', 'DATE', 'TIME', 'TIMESTAMP', 'CHAR', 'VARCHAR', 'BLOB', 'BIGINT', 'BOOLEAN', 'CSTRING', 'QUAD'),
{1 'D1'  }  ('SMALLINT', 'INTEGER',            'FLOAT', 'DOUBLE PRECISION', 'NUMERIC', 'DECIMAL', 'DATE',                      'CHAR', 'VARCHAR', 'BLOB', '', '', '', '', '', ''),
{2 'D3'  }  ('SMALLINT', 'INTEGER',            'FLOAT', 'DOUBLE PRECISION', 'NUMERIC', 'DECIMAL', 'DATE', 'TIME', 'TIMESTAMP', 'CHAR', 'VARCHAR', 'BLOB', '', '', '', ''),
{3 'IB7' }  ('SMALLINT', 'INTEGER', 'BOOLEAN', 'FLOAT', 'DOUBLE PRECISION', 'NUMERIC', 'DECIMAL', 'DATE', 'TIME', 'TIMESTAMP', 'CHAR', 'VARCHAR', 'BLOB', '', '', ''),
{4 'FB15'}  ('SMALLINT', 'INTEGER', 'BIGINT',  'FLOAT', 'DOUBLE PRECISION', 'NUMERIC', 'DECIMAL', 'DATE', 'TIME', 'TIMESTAMP', 'CHAR', 'VARCHAR', 'BLOB', '', '', ''));

//'_MONEY', '_NMONEY', 'PARAMETER', 'INT64', 'LARGEINT'

  STCPIP                                = 'TCP/IP';
  SNamedPipe                            = 'NamedPipe';
  SSPX                                  = 'SPX';
  SLocal                                = 'Local';

  Protocols: array[0..3] of string = (
    STCPIP, SNamedPipe, SSPX, SLocal);

  Precisions: array[0..17] of string = (
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14',
    '15', '16', '17', '18');

  Scales: array[0..18] of string = (
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14',
    '15', '16', '17', '18');

  BlobSubTypes: array[0..5] of string = (
    'BINARY', 'TEXT', 'BLR', 'ACL', '', '');

  CharsetsAndCollatesFB10: array[0..57, 0..14] of string = (
{0 }	('NONE',        '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{1 }	('OCTETS',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{2 }	('ASCII',       '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{3 }	('UNICODE_FSS', '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{4 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{5 }	('SJIS_0208',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{6 }	('EUCJ_0208',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{7 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{8 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{9 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{10}	('DOS437',      'PDOX_ASCII',     'PDOX_INTL',   'PDOX_SWEDFIN', 'DB_DEU437', 'DB_ESP437',   'DB_FIN437', 'DB_FRA437', 'DB_ITA437', 'DB_NLD437', 'DB_SVE437', 'DB_UK437', 'DB_US437', '',      ''     ),
{11}	('DOS850',      'DB_FRC850',      'DB_DEU850',   'DB_ESP850',    'DB_FRA850', 'DB_ITA850',   'DB_NLD850', 'DB_PTB850', 'DB_SVE850', 'DB_UK850',  'DB_US850',  '',         '',         '',      ''     ),
{12}	('DOS865',      'PDOX_NORDAN4',   'DB_DAN865',   'DB_NOR865',    '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{13}	('DOS860',      'DB_PTG860',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{14}	('DOS863',      'DB_FRC863',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{15}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{16}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{17}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{18}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{19}	('NEXT',        'NXT_US',         'NXT_DEU',     'NXT_FRA',      'NXT_ITA',   'NXT_ESP',     '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{20}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{21}	('ISO8859_1',   'DA_DA',          'DU_NL',       'FI_FI',        'FR_FR',     'FR_CA',       'DE_DE',     'IS_IS',     'IT_IT',     'NO_NO',     'ES_ES',     'SV_SV',    'EN_UK',    'EN_US', 'PT_PT'),
{22}	('ISO8859_2',   'CS_CZ',          '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{23}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{24}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{25}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{26}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{27}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{28}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{29}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{30}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{31}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{32}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{33}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{34}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{35}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{36}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{37}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{38}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{39}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{40}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{41}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{42}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{43}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{44}	('KSC_5601',    'KSC_DICTIONARY', '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{45}	('DOS852',      'DB_CSY',         'DB_PLK',      'DB_SLO',       'PDOX_CSY',  'PDOX_PLK',    'PDOX_HUN',  'PDOX_SLO',  '',          '',          '',          '',         '',         '',      ''     ),
{46}	('DOS857',      'DB_TRK',         '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{47}	('DOS861',      'PDOX_ISL',       '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{48}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{49}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{50}	('CYRL',        'DB_RUS',         'PDOX_CYRL',   '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{51}	('WIN1250',     'PXW_CSY',        'PXW_HUNDC',   'PXW_PLK',      'PXW_SLOV',  'PXW_HUN',     '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{52}	('WIN1251',     'PXW_CYRL',       '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{53}	('WIN1252',     'PXW_INTL',       'PXW_INTL850', 'PXW_NORDAN4',  'PXW_SPAN',  'PXW_SWEDFIN', '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{54}	('WIN1253',     'PXW_GREEK',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{55}	('WIN1254',     'PXW_TURK',       '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{56}	('BIG_5',       '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{57}	('GB_2312',     '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ));

  CharsetsAndCollatesFB15: array[0..60, 0..14] of string = (
{0 }  ('NONE',        '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{1 }  ('OCTETS',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{2 }  ('ASCII',       '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{3 }  ('UNICODE_FSS', '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{4 }  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{5 }  ('SJIS_0208',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{6 }  ('EUCJ_0208',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{7 }  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{8 }  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{9 }  ('DOS737',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{10}  ('DOS437',      'PDOX_ASCII',     'PDOX_INTL',   'PDOX_SWEDFIN', 'DB_DEU437', 'DB_ESP437',   'DB_FIN437', 'DB_FRA437', 'DB_ITA437', 'DB_NLD437', 'DB_SVE437', 'DB_UK437', 'DB_US437', '',      ''     ),
{11}  ('DOS850',      'DB_FRC850',      'DB_DEU850',   'DB_ESP850',    'DB_FRA850', 'DB_ITA850',   'DB_NLD850', 'DB_PTB850', 'DB_SVE850', 'DB_UK850',  'DB_US850',  '',         '',         '',      ''     ),
{12}  ('DOS865',      'PDOX_NORDAN4',   'DB_DAN865',   'DB_NOR865',    '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{13}  ('DOS860',      'DB_PTG860',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{14}  ('DOS863',      'DB_FRC863',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{15}  ('DOS775',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{16}  ('DOS858',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{17}  ('DOS862',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{18}  ('DOS864',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{19}  ('NEXT',        'NXT_US',         'NXT_DEU',     'NXT_FRA',      'NXT_ITA',   'NXT_ESP',     '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{20}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{21}  ('ISO8859_1',   'DA_DA',          'DU_NL',       'FI_FI',        'FR_FR',     'FR_CA',       'DE_DE',     'IS_IS',     'IT_IT',     'NO_NO',     'ES_ES',     'SV_SV',    'EN_UK',    'EN_US', 'PT_PT'),
{22}  ('ISO8859_2',   'CS_CZ',          'ISO_HUN',     '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{23}  ('ISO8859_3',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{24}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{25}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{26}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{27}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{28}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{29}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{30}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{31}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{32}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{33}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{34}  ('ISO8859_4',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{35}  ('ISO8859_5',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{36}  ('ISO8859_6',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{37}  ('ISO8859_7',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{38}  ('ISO8859_8',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{39}  ('ISO8859_9',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{40}  ('ISO8859_13',  'LT_LT', {1.5.1}  '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{41}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{42}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{43}  ('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{44}  ('KSC_5601',    'KSC_DICTIONARY', '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{45}  ('DOS852',      'DB_CSY',         'DB_PLK',      'DB_SLO',       'PDOX_CSY',  'PDOX_PLK',    'PDOX_HUN',  'PDOX_SLO',  '',          '',          '',          '',         '',         '',      ''     ),
{46}  ('DOS857',      'DB_TRK',         '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{47}  ('DOS861',      'PDOX_ISL',       '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{48}  ('DOS866',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{49}  ('DOS869',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{50}  ('CYRL',        'DB_RUS',         'PDOX_CYRL',   '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{51}  ('WIN1250',     'PXW_CSY',        'PXW_HUNDC',   'PXW_PLK',      'PXW_SLOV',  'PXW_HUN',     '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{52}  ('WIN1251',     'PXW_CYRL',       'WIN1251_UA',  '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{53}  ('WIN1252',     'PXW_INTL',       'PXW_INTL850', 'PXW_NORDAN4',  'PXW_SPAN',  'PXW_SWEDFIN', '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{54}  ('WIN1253',     'PXW_GREEK',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{55}  ('WIN1254',     'PXW_TURK',       '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{56}  ('BIG_5',       '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{57}  ('GB_2312',     '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{58}  ('WIN1255',     '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{59}  ('WIN1256',     '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{60}  ('WIN1257',     '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ));

  CharsetsAndCollatesFB20: array[0..65, 0..14] of string = (
{0 }	('NONE',        '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{1 }	('OCTETS',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{2 }	('ASCII',       '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{3 }	('UNICODE_FSS', '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{4 }	('UTF8',        'UCS_BASIC',      'UNICODE',     '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{5 }	('SJIS_0208',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{6 }	('EUCJ_0208',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{7 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{8 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{9 }	('DOS737',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{10}	('DOS437',      'PDOX_ASCII',     'PDOX_INTL',   'PDOX_SWEDFIN', 'DB_DEU437', 'DB_ESP437',  'DB_FIN437',  'DB_FRA437', 'DB_ITA437', 'DB_NLD437', 'DB_SVE437', 'DB_UK437', 'DB_US437', '',      ''     ),
{11}	('DOS850',      'DB_FRC850',      'DB_DEU850',   'DB_ESP850',    'DB_FRA850', 'DB_ITA850',  'DB_NLD850',  'DB_PTB850', 'DB_SVE850', 'DB_UK850',  'DB_US850',  '',         '',         '',      ''     ),
{12}	('DOS865',      'PDOX_NORDAN4',   'DB_DAN865',   'DB_NOR865',    '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{13}	('DOS860',      'DB_PTG860',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{14}	('DOS863',      'DB_FRC863',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{15}	('DOS775',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{16}	('DOS858',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{17}	('DOS862',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{18}	('DOS864',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{19}	('NEXT',        'NXT_US',         'NXT_DEU',     'NXT_FRA',      'NXT_ITA',   'NXT_ESP',     '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{20}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{21}	('ISO8859_1',   'DA_DA',          'DU_NL',       'FI_FI',        'FR_FR',     'FR_CA',       'DE_DE',     'IS_IS',     'IT_IT',     'NO_NO',     'ES_ES',     'SV_SV',    'EN_UK',    'EN_US', 'PT_PT'),
{22}	('ISO8859_2',   'CS_CZ',          'ISO_HUN',     '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{23}	('ISO8859_3',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{24}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{25}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{26}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{27}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{28}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{29}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{30}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{31}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{32}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{33}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{34}	('ISO8859_4',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{35}	('ISO8859_5',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{36}	('ISO8859_6',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{37}	('ISO8859_7',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{38}	('ISO8859_8',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{39}	('ISO8859_9',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{40}	('ISO8859_13',  '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{41}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{42}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{43}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{44}	('KSC_5601',    'KSC_DICTIONARY', '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{45}	('DOS852',      'DB_CSY',         'DB_PLK',      'DB_SLO',       'PDOX_CSY',  'PDOX_PLK',    'PDOX_HUN',  'PDOX_SLO',  '',          '',          '',          '',         '',         '',      ''     ),
{46}	('DOS857',      'DB_TRK',         '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{47}	('DOS861',      'PDOX_ISL',       '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{48}	('DOS866',       '',              '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{49}	('DOS869',       '',              '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{50}	('CYRL',        'DB_RUS',         'PDOX_CYRL',   '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{51}	('WIN1250',     'PXW_CSY',        'PXW_HUNDC',   'PXW_PLK',      'PXW_SLOV',  'PXW_HUN',     'BS_BA',     'WIN_CZ',    'WIN_CZ_CI_AI',          '',          '',          '',         '',         '',      ''     ),
{52}	('WIN1251',     'PXW_CYRL',       'WIN1251_UA',  '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{53}	('WIN1252',     'PXW_INTL',       'PXW_INTL850', 'PXW_NORDAN4',  'PXW_SPAN',  'PXW_SWEDFIN', 'WIN_PTBR',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{54}	('WIN1253',     'PXW_GREEK',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{55}	('WIN1254',     'PXW_TURK',    '', '',            '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{56}  ('BIG_5',       '',          '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{57}  ('GB_2312',     '',        '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{58}  ('WIN1255',     '',        '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{59}  ('WIN1256',     'WIN1256',        '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{60}  ('WIN1257',     'WIN1257_EE',  'WIN1257_LT',   'WIN1257_LV', '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{61}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{62}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{63}	('KOI8R',       'KOI8R_RU',          '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{64}	('KOI8U',       'KOI8R_UA',          '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{65}	('WIN1258',     'WIN1258',          '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     )
);


  CharsetsAndCollatesFB21: array[0..67, 0..14] of string = (
{0 }	('NONE',        '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{1 }	('OCTETS',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{2 }	('ASCII',       '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{3 }	('UNICODE_FSS', '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{4 }	('UTF8',        'UCS_BASIC',      'UNICODE',     '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{5 }	('SJIS_0208',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{6 }	('EUCJ_0208',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{7 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{8 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{9 }	('DOS737',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{10}	('DOS437',      'PDOX_ASCII',     'PDOX_INTL',   'PDOX_SWEDFIN', 'DB_DEU437', 'DB_ESP437',  'DB_FIN437',  'DB_FRA437', 'DB_ITA437', 'DB_NLD437', 'DB_SVE437', 'DB_UK437', 'DB_US437', '',      ''     ),
{11}	('DOS850',      'DB_FRC850',      'DB_DEU850',   'DB_ESP850',    'DB_FRA850', 'DB_ITA850',  'DB_NLD850',  'DB_PTB850', 'DB_SVE850', 'DB_UK850',  'DB_US850',  '',         '',         '',      ''     ),
{12}	('DOS865',      'PDOX_NORDAN4',   'DB_DAN865',   'DB_NOR865',    '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{13}	('DOS860',      'DB_PTG860',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{14}	('DOS863',      'DB_FRC863',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{15}	('DOS775',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{16}	('DOS858',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{17}	('DOS862',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{18}	('DOS864',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{19}	('NEXT',        'NXT_US',         'NXT_DEU',     'NXT_FRA',      'NXT_ITA',   'NXT_ESP',     '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{20}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{21}	('ISO8859_1',   'DA_DA',          'DU_NL',       'FI_FI',        'FR_FR',     'FR_CA',       'DE_DE',     'IS_IS',     'IT_IT',     'NO_NO',     'ES_ES',     'SV_SV',    'EN_UK',    'EN_US', 'PT_PT'),
{22}	('ISO8859_2',   'CS_CZ',          'ISO_HUN',     '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{23}	('ISO8859_3',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{24}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{25}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{26}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{27}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{28}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{29}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{30}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{31}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{32}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{33}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{34}	('ISO8859_4',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{35}	('ISO8859_5',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{36}	('ISO8859_6',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{37}	('ISO8859_7',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{38}	('ISO8859_8',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{39}	('ISO8859_9',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{40}	('ISO8859_13',  '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{41}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{42}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{43}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{44}	('KSC_5601',    'KSC_DICTIONARY', '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{45}	('DOS852',      'DB_CSY',         'DB_PLK',      'DB_SLO',       'PDOX_CSY',  'PDOX_PLK',    'PDOX_HUN',  'PDOX_SLO',  '',          '',          '',          '',         '',         '',      ''     ),
{46}	('DOS857',      'DB_TRK',         '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{47}	('DOS861',      'PDOX_ISL',       '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{48}	('DOS866',       '',              '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{49}	('DOS869',       '',              '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{50}	('CYRL',        'DB_RUS',         'PDOX_CYRL',   '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{51}	('WIN1250',     'PXW_CSY',        'PXW_HUNDC',   'PXW_PLK',      'PXW_SLOV',  'PXW_HUN',     'BS_BA',     'WIN_CZ',    'WIN_CZ_CI_AI',          '',          '',          '',         '',         '',      ''     ),
{52}	('WIN1251',     'PXW_CYRL',       'WIN1251_UA',  '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{53}	('WIN1252',     'PXW_INTL',       'PXW_INTL850', 'PXW_NORDAN4',  'PXW_SPAN',  'PXW_SWEDFIN', 'WIN_PTBR',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{54}	('WIN1253',     'PXW_GREEK',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{55}	('WIN1254',     'PXW_TURK',    '', '',            '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{56}  ('BIG_5',       '',          '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{57}  ('GB_2312',     '',        '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{58}  ('WIN1255',     '',        '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{59}  ('WIN1256',     'WIN1256',        '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{60}  ('WIN1257',     'WIN1257_EE',  'WIN1257_LT',   'WIN1257_LV', '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{61}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{62}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{63}	('KOI8R',       'KOI8R_RU',          '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{64}	('KOI8U',       'KOI8R_UA',          '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{65}	('WIN1258',     'WIN1258',          '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{66}	('TIS620',     'TIS620',          '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{67}	('GBK',     'GBK',          '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     )
);


  CharsetsAndCollatesIB70: array[0..57, 0..14] of string = (
{0 }	('NONE',        '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{1 }	('OCTETS',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{2 }	('ASCII',       '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{3 }	('UNICODE_FSS', '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{4 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{5 }	('SJIS_0208',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{6 }	('EUCJ_0208',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{7 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{8 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{9 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{10}	('DOS437',      'PDOX_ASCII',     'PDOX_INTL',   'PDOX_SWEDFIN', 'DB_DEU437', 'DB_ESP437',   'DB_FIN437', 'DB_FRA437', 'DB_ITA437', 'DB_NLD437', 'DB_SVE437', 'DB_UK437', 'DB_US437', '',      ''     ),
{11}	('DOS850',      'DB_FRC850',      'DB_DEU850',   'DB_ESP850',    'DB_FRA850', 'DB_ITA850',   'DB_NLD850', 'DB_PTB850', 'DB_SVE850', 'DB_UK850', 'DB_US850',   '',         '',         '',      ''     ),
{12}	('DOS865',      'PDOX_NORDAN4',   'DB_DAN865',   'DB_NOR865',    '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{13}	('DOS860',      'DB_PTG860',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{14}	('DOS863',      'DB_FRC863',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{15}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{16}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{17}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{18}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{19}	('NEXT',        'NXT_US',         'NXT_DEU',     'NXT_FRA',      'NXT_ITA',   'NXT_ESP',     '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{20}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{21}	('ISO8859_1',   'DA_DA',          'DU_NL',       'FI_FI',        'FR_FR',     'FR_CA',       'DE_DE',     'IS_IS',     'IT_IT',     'NO_NO',     'ES_ES',     'SV_SV',    'EN_UK',    'EN_US', 'PT_PT'),
{22}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{23}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{24}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{25}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{26}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{27}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{28}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{29}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{30}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{31}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{32}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{33}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{34}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{35}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{36}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{37}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{38}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{39}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{40}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{41}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{42}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{43}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{44}	('KSC_5601',    'KSC_DICTIONARY', '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{45}	('DOS852',      'DB_CSY',         'DB_PLK',      'DB_SLO',      'PDOX_CSY',   'PDOX_PLK',    'PDOX_HUN',  'PDOX_SLO',  '',          '',          '',          '',         '',         '',      ''     ),
{46}	('DOS857',      'DB_TRK',         '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{47}	('DOS861',      'PDOX_ISL',       '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{48}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{49}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{50}	('CYRL',        'DB_RUS',         'PDOX_CYRL',   '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{51}	('WIN1250',     'PXW_CSY',        'PXW_HUNDC',   'PXW_PLK',     'PXW_SLOV',   '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{52}	('WIN1251',     'PXW_CYRL',       '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{53}	('WIN1252',     'PXW_INTL',       'PXW_INTL850', 'PXW_NORDAN4', 'PXW_SPAN',   'PXW_SWEDFIN', '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{54}	('WIN1253',     'PXW_GREEK',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{55}	('WIN1254',     'PXW_TURK',       '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{56}	('BIG_5',       '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{57}	('GB_2312',     '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ));

  CharsetsAndCollatesIB71: array[0..58, 0..14] of string = (
{0 }	('NONE',        '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{1 }	('OCTETS',      '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{2 }	('ASCII',       '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{3 }	('UNICODE_FSS', '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{4 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{5 }	('SJIS_0208',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{6 }	('EUCJ_0208',   '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{7 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{8 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{9 }	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{10}	('DOS437',      'PDOX_ASCII',     'PDOX_INTL',   'PDOX_SWEDFIN', 'DB_DEU437', 'DB_ESP437',   'DB_FIN437', 'DB_FRA437', 'DB_ITA437', 'DB_NLD437', 'DB_SVE437', 'DB_UK437', 'DB_US437', '',      ''     ),
{11}	('DOS850',      'DB_FRC850',      'DB_DEU850',   'DB_ESP850',    'DB_FRA850', 'DB_ITA850',   'DB_NLD850', 'DB_PTB850', 'DB_SVE850', 'DB_UK850', 'DB_US850',   '',         '',         '',      ''     ),
{12}	('DOS865',      'PDOX_NORDAN4',   'DB_DAN865',   'DB_NOR865',    '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{13}	('DOS860',      'DB_PTG860',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{14}	('DOS863',      'DB_FRC863',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{15}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{16}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{17}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{18}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{19}	('NEXT',        'NXT_US',         'NXT_DEU',     'NXT_FRA',      'NXT_ITA',   'NXT_ESP',     '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{20}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{21}	('ISO8859_1',   'DA_DA',          'DU_NL',       'FI_FI',        'FR_FR',     'FR_CA',       'DE_DE',     'IS_IS',     'IT_IT',     'NO_NO',     'ES_ES',     'SV_SV',    'EN_UK',    'EN_US', 'PT_PT'),
{22}	('ISO8859_2',   'CS_CZ',          '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{23}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{24}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{25}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{26}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{27}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{28}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{29}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{30}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{31}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{32}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{33}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{34}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{35}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{36}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{37}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{38}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{39}	('ISO8859_15',  '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{40}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{41}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{42}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{43}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{44}	('KSC_5601',    'KSC_DICTIONARY', '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{45}	('DOS852',      'DB_CSY',         'DB_PLK',      'DB_SLO',      'PDOX_CSY',   'PDOX_PLK',    'PDOX_HUN',  'PDOX_SLO',  '',          '',          '',          '',         '',         '',      ''     ),
{46}	('DOS857',      'DB_TRK',         '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{47}	('DOS861',      'PDOX_ISL',       '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{48}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{49}	('',            '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{50}	('CYRL',        'DB_RUS',         'PDOX_CYRL',   '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{51}	('WIN1250',     'PXW_CSY',        'PXW_HUNDC',   'PXW_PLK',     'PXW_SLOV',   '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{52}	('WIN1251',     'PXW_CYRL',       '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{53}	('WIN1252',     'PXW_INTL',       'PXW_INTL850', 'PXW_NORDAN4', 'PXW_SPAN',   'PXW_SWEDFIN', '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{54}	('WIN1253',     'PXW_GREEK',      '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{55}	('WIN1254',     'PXW_TURK',       '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{56}	('BIG_5',       '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{57}	('GB_2312',     '',               '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ),
{58}	('KOI8R',       'RU_RU',          '',            '',             '',          '',            '',          '',          '',          '',          '',          '',         '',         '',      ''     ));


(*
CREATE PROCEDURE MAKE_CHARSET_COLLATIONS_ARRAY
RETURNS (
    I INTEGER,
    RESULT VARCHAR(1024))
AS
DECLARE VARIABLE V_COUNT INTEGER;
DECLARE VARIABLE V_COLLATION_NAME VARCHAR(15);
BEGIN
  SELECT MAX(RDB$CHARACTER_SET_ID) FROM RDB$CHARACTER_SETS INTO :V_COUNT;

  I = 0;
  WHILE (I <= :V_COUNT) DO
  BEGIN
    RESULT = '';
    FOR SELECT COL.RDB$COLLATION_NAME
        FROM RDB$COLLATIONS COL
        WHERE COL.RDB$CHARACTER_SET_ID = :I
        ORDER BY COL.RDB$COLLATION_ID
        INTO :V_COLLATION_NAME
    DO
    BEGIN
      RESULT =  :RESULT || '''' ||  :V_COLLATION_NAME || ''', ' ;
    END
    IF (:RESULT = '') THEN RESULT = '''''';
    SUSPEND;
    I  = I + 1;
  END
END
*)

  NullTypes: array[0..1] of string = (
    ' ', 'NOT NULL');

  ConstraintTypes: array[0..3] of string = (
    'PRIMARY KEY', 'UNIQUE', 'FOREIGN KEY', 'CHECK');

  ConstraintRules: array[0..3] of string = (
    'NO ACTION', 'CASCADE', 'SET DEFAULT', 'SET NULL');
    
  Mechanisms: array[0..2] of string = (
     'BY VALUE', 'BY REFERENCE', 'BY DESCRIPTOR'{, 'PARAMETER', 'FREE_IT'});

  Sortings: array[0..1] of string = (
    'ASCENDING', 'DESCENDING');

  IndexTypes: array[0..1] of string = (
    ' ', 'UNIQUE');

  Statuses: array[0..1] of string = (
    'ACTIVE', 'INACTIVE');

  TypePrefixes: array[0..1] of string = (
    'BEFORE', 'AFTER');

  TypePrefixesFB21: array[0..2] of string = (
    'BEFORE', 'AFTER','ON');

  TypeSuffixesIB: array[0..2] of string = (
    'INSERT', 'UPDATE', 'DELETE');

  TypeSuffixesFB: array[0..6] of string = (
    'INSERT', 'UPDATE', 'DELETE',
    'INSERT OR UPDATE', 'INSERT OR DELETE', 'INSERT OR UPDATE OR DELETE', 'UPDATE OR DELETE');

  TypeSuffixesFB21: array[0..11] of string = (
    'INSERT', 'UPDATE', 'DELETE',
    'INSERT OR UPDATE', 'INSERT OR DELETE', 'INSERT OR UPDATE OR DELETE', 'UPDATE OR DELETE',
    'CONNECT','DISCONNECT','TRANSACTION START','TRANSACTION COMMIT','TRANSACTION ROLLBACK'
  );


  Views: array[0..5] of string = (
    'Text', 'Grid', 'DB Grid', 'Tree', 'Master DDL', 'Text DDL');

  AfterExecutes: array[0..2] of string = (
    'None', 'Result', 'Performance');

  ResultTypes: array[0..1] of string = (
    'Grid', 'Text');

  IsolationLevels: array[0..4] of string = (
    'Snapshot', 'Read Commited', 'Read-Only Table Stability', 'Read-Write Table Stability', 'Custom');

  AccessModes: array[0..1] of string = (
    'Services API', 'Direct Access');

  ConfirmEndTransactions: array[0..2] of string = (
    'DataModified', 'Always', 'Never');

  DefaultTransactionActions: array[0..1] of string = (
    'Commit', 'Rollback');

  PrivilegeTypes: array[0..4] of string = (
    'Views', 'Procedures', 'Triggers', 'Roles', 'Users');

  GrantTypes: array[0..3] of string = (
    'All', 'Tables', 'Views', 'Procedures');

  DisplayGrants: array[0..2] of string = (
    'All', 'Granted', 'Non-Granted');

  StopAfters: array[0..6] of string = (
    'Header Page', 'Log Pages', 'Index Pages', 'Data Pages', 'System Relations', 'Record Versions', 'Stat Tables');

  ShutdownModes: array[0..2] of string = (
    'Forced', 'Deny Transaction', 'Deny Attachment');

  GlobalActions: array[0..3] of string = (
    'Commit', 'Rollback', 'Recover Two Phase', 'No Action');

  CommentModes: array[0..9] of string = (
    'All Objects', 'Domains', 'Tables', 'Indices', 'Views', 'Procedures', 'Triggers', 'Exceptions', 'Functions', 'Filters' );

  ExtractModes: array[0..1] of string = (
    'All Objects', 'By Objects'{, 'Table Packages'});

  Delimiters: array[0..3] of string = (
    'Comma', 'Semicolon', 'Tab', 'Space');

  ExtractHeaders: array[0..2] of string = (
    'Create', 'Connect', 'None');

  ExtractorOutputs: array[0..1] of string = (
    'Screen', 'File');
  DMLExporterModes: array[0..1] of string = (
    'Tables', 'Query');
  ExtractorStatementType: array[0..3] of string = (
    'INSERT', 'UPDATE', 'DELETE', 'EXECUTE');
  PlayerModes: array[0..1] of string = (
    'Classic', 'Trace');
  PlayerAfterErrors: array[0..1] of string = (
    'Commit', 'Rollback');

  TRReadParams = 'read' + sLineBreak + 'nowait' + sLineBreak + 'rec_version' + sLineBreak + 'read_committed';
  TRWriteParams = 'write' + sLineBreak + 'nowait' + sLineBreak + 'rec_version' + sLineBreak + 'read_committed';

  TransactionParamsSnapshot = 'write' + sLineBreak + 'nowait' + sLineBreak + 'concurrency';
  TransactionParamsReadCommited = 'write' + sLineBreak + 'nowait' + sLineBreak  + 'rec_version' + sLineBreak + 'read_committed';
  TransactionParamsReadOnlyTableStability = 'read' + sLineBreak + 'nowait' + sLineBreak  + 'consistency';
  TransactionParamsReadWriteTableStability = 'write' + sLineBreak + 'nowait' + sLineBreak  + 'consistency';
  TransactionParamsCustomDefault = TransactionParamsReadCommited;


  // DDL
  S1Quote     = '''';
  S2Quote     = '"';
  S2LineBreak = SLineBreak + SLineBreak;
  SEnd        = ';';
  SLoadingDefaultTemplate = 'Loading Default Template';
  SInputTemplateName      = 'Input template name';
  SObjectNameNew = 'Change Default Name';
  SObjectName = 'Object Name';
  SCreateNewObjectPrompt ='Create new %s';

  // Options
  SibOptionsCategory = 'InterBase';
  SfbOptionsCategory = 'Firebird';
  SServerOptionsCategory = 'Server Default';
  SDatabaseOptionsCategory = 'Database Default';
  SDBObjectOptionsCategory = 'DB Objects';

  GUIModes: array[0..1] of string = (
    'Console', 'Àdvanced');

  { Editors managers }

  SSectionFunctions    = 'FUNCTIONS';
  SSectionKeyWords     = 'KEYWORDS';
  SSectionDataTypes    = 'DATA_TYPES';

  SBuilInFunction      = 'Function';
  SKeyWord             = 'SQL';
  SDataType            = 'Data Type';
  SCustomString        = 'Custom';
//  SProcParamInput      = 'Input';
//  SProcParamOutput     = 'Output';
  SProcParamInput      = 'Param';
  SProcParamOutput     = 'Return';
  SProcParamLocal      = 'Variable';

  SObjectNameForEditor = 'Name';

  SProposalTemplate    = '\color{%s} %s\color{clBlack} \column{}\style{+B}%s\style{-B} \color{clGray}%s';
  SParametersHintTemplate = '"%s, ", ';

  InterBaseDefaultKWFileName = 'Keywords\InterBase_Keywords_50.txt';
  InterBase6KWFileName = 'Keywords\InterBase_Keywords_60.txt';
  InterBase7KWFileName = 'Keywords\InterBase_Keywords_70.txt';
  InterBase75KWFileName = 'Keywords\InterBase_Keywords_75.txt';
  InterBase2007KWFileName = 'Keywords\InterBase_Keywords_2007.txt';

  Firebird1KWFileName = 'Keywords\Firebird_Keywords_10.txt';
  Firebird15KWFileName = 'Keywords\Firebird_Keywords_15.txt';
  Firebird20KWFileName = 'Keywords\Firebird_Keywords_20.txt';
  Firebird21KWFileName = 'Keywords\Firebird_Keywords_21.txt';

  InterBaseKeyboardTemplatesFileName = 'Keywords\InterBase_Keyboards_Templates.txt';
  InterBaseAutoReplaceFileName = 'Keywords\InterBase_Auto_Replace.txt';

  {Other managers}

  Digits: set of Char = ['1'..'9','0'];
  AvalibleChars: set of Char = ['$', '_', 'a'..'z','A'..'Z','1'..'9','0'];
  SQuotation: Char = '"';
  SExportExtentionTemplate = '%s (*%s)|*%s';


  { DDL Finder }
  SDDLFinderFile = 'DDLFinder\DDLFinder.txt';
  { TXT Loader }
  STXTLoaderFile = 'TXTLoader\TXTLoader.txt';
  { Services }
  SServicesFile = 'Services\Services.txt';
  SBackupSourceFile =  'Services\BackupSource.txt';
  SBackupDestinationFile =  'Services\BackupDestination.txt';
  SRestoreSourceFile =  'Services\RestoreSource.txt';
  SRestoreDestinationFile =  'Services\RestoreDestination.txt';

  {SQL Editor}
  SQLEditorLastContextFile = 'SQLEditor\SQLEditor.txt';                         //do not localize
  SCantCountRecords = 'Can''t count records';
  {DML History}
  SQLHistoryFile = 'SQLHistory\SQLHistory.txt';
  DMLHistoryFile = 'DMLHistory\DMLHistory.txt';
  DDLHistoryFile = 'DDLHistory\DDLHistory.sql';

  sHistorySQLHeader = '/* >> Timestamp: ';                                      //do not localize
  sHistorySQLHeaderSuf = '%s */';                                               //do not localize
  sHistoryStatisticsHeader = '/* Statistics: */';                               //do not localize

  SHistoryPrepare = 'PREPARE';                                                  //do not localize
  SHistoryExecute = 'EXECUTE';                                                  //do not localize
  SHistoryFetch = 'FETCH';                                                      //do not localize
  SHistoryIndexedReads = 'IDX_READS';                                           //do not localize
  SHistoryNonIndexedReads = 'NON_IDX_READS';                                    //do not localize
  SHistoryUpdates = 'UPDATES';                                                  //do not localize
  SHistoryDeletes = 'DELETES';                                                  //do not localize
  SHistoryInserts = 'INSERTS';                                                  //do not localize
  SHistorySQLTextDigest  = 'SQL_TEXT_DIGEST';                                   //do not localize

  {SQL Player}
  SErrorMessagesHeader = '>>>> Error ocured in statement at line ';             //do not localize
  SErrorMessagesHeaderSuf = '%d with message:'#13#10#13#10'%s'#13#10#13#10;     //do not localize


  {Editor menu}

  SFindDeclaration = 'Find Dec&laration';
  SOpenFile = 'Open';
  SReOpenFile = 'Reopen File';
  SSaveToFile = 'Save';
  SSaveAsToFile = 'Save As';
  SSaveAsToTemplate       = 'Save as template DDL';

  SOtherEdit = 'Other Edit';
    SUndo = 'Undo';
    SRedo = 'Redo';
    SSelectAll = 'Select All';
    SClearAll = 'Clear All';
  SFind = 'Find';
  SReplace = 'Replace';
  SSearchAgain = 'Search Again';
  SOtherSearch = 'Other Search';
    SIncrementalSearch = 'Incremental Search';
    SGotoLineNumber = 'Go to Line Number...'; 
  SCopyTextAsRTF = '&Copy Text as RTF';
  SCopyTextAsHTML = '&Copy Text as HTML';
  SCopyTextAsDelphiString = '&Copy Text as Delphi string';

  SCopyTextAsCBString = '&Copy Text as CBuilder string';    
  SCut = 'C&ut';
  SCopy = 'Co&py';
  SPaste = 'P&aste';
  SSpecialPaste = 'Special P&aste';
  SPasteDelphiString='Paste DelphiString';
  SToggleBookMark = '&Toggle Bookmarks';
  SBookMark0 = 'Bookmark &0';
  SBookMark1 = 'Bookmark &1';
  SBookMark2 = 'Bookmark &2';
  SBookMark3 = 'Bookmark &3';
  SBookMark4 = 'Bookmark &4';
  SBookMark5 = 'Bookmark &5';
  SBookMark6 = 'Bookmark &6';
  SBookMark7 = 'Bookmark &7';
  SBookMark8 = 'Bookmark &8';
  SBookMark9 = 'Bookmark &9';
  SGotoBookMark = '&Goto Bookmarks';
  SCommentSelected = 'Co&mment/Uncomment selected';
  SCommentLine = 'Comment/Uncomment Line';
  SUnCommentSelected = 'Uncomment selected';
  SConvertCharcase = 'C&onvert Charcase';
  SToLowercase = 'To &Lowercase';
  SToUppercase = 'To Uppercase';
  SToNamecase = 'To &Namecase';
  SInvertCase = '&Invert Case';
  SToggleCase = '&Toggle Case';
  SPrint = 'Print';
  SShowMessages = 'Show Messages';
  SHideMessages = 'Hide Messages';
  SProperties = 'P&roperties';

  SShowDMLHistory = 'Show DML History';
  SShowDDLHistory = 'Show DDL History';
//  SSendToSQLEditor = 'Send To S&QLEditor';
  SSendToSQLEditor = 'Send to SQL Editor';
  SDeleteCurrentHistoryStatement = 'Delete Statement';
  SSendToSQLPlayer = 'Send to SQL Player';
  SExportIntoScript = 'Export into Script';

implementation

(* ShortCuts for Editors

Ctrl + Alt + D            - List of Domains
Ctrl + Alt + T            - List of Tables
Ctrl + Alt + V            - List of Views
Ctrl + Alt + M            - List of Triggers
Ctrl + Alt + P            - List of Procedures
Ctrl + Alt + G            - List of Generators
Ctrl + Alt + E            - List of Exceptions
Ctrl + Alt + F            - List of Functions
Ctrl + Alt + R            - List of Roles

Ctrl + F                  - Search
F3                        - Search Again
Ctrl + R                  - Replace
Ctrl + E                  - Incremental Search
Alt + G                   - Go to Line Number
Shift + Ctrl + Enter      - JumpToLink

Alt + Down                - ToLowerCase
Alt + Up                  - ToUpperCase
Shift + F3                - ToggleCase
Shift + Crtl + W          - Coty Text as RTF

Shift + Ctrl + /          - Comment Block
Ctrl + /                  - Comment Line
Ctrl + D                  - Duplicate Selected Block or Line
Ctrl + W                  - Selected word

ArrowUp                   - Up
Shift + ArrowUp           - Select Up
Ctrl + ArrowUp            - Scroll Up
ArrowDown                 - Down
Shift + ArrowDown         - Select Down
Ctrl + ArrowDown          - Scroll Down
ArrowLeft                 - Left
Shift + ArrowLeft         - Select Left Char
Ctrl + ArrowLeft          - Word Left
Shift + Ctrl + ArrowLeft  - Select Word Left
ArrowRight                - Right
Shift + ArrowRight        - Select Right Char
Ctrl + ArrowRight         - Word Right
Shift + Ctrl + ArrowRight - Select Word Right
PgDn                      - Goto Page Down
Shift + PgDn              - Select To PageDown
Ctrl + PgDn               - Goto Page Bottom
Shift + Ctrl + PgDn       - Select To Page Bottom
PgUp                      - PageUp
Shift + PgUp              - Select To PageUp
Ctrl + PgUp               - Goto Page Top
Shift + Ctrl + PgUp       - Select To Page Top
Home                      - Goto Line Start
Shift + Home              - Select To LineStart
Ctrl + Home               - Goto Editor Top
Shift + Ctrl + Home       - Select To Editor Top
End                       - Goto Line End
Shift + End               - Select To LineEnd
Ctrl + End                - Goto Editor Bottom
Shift + Ctrl + End        - Select To Editor Bottom
Ins                       - Toggle Mode Insert/Override
Ctrl + Ins                - Copy
Shift + Del               - Cut
Shift + Ins               - Insert
Del                       - Delete Char
Backspace                 - Delete Last Char
Shift + Backspace         - Delete Last Char
Ctrl + Backspace          - Delete Last Word
Alt + Backspace           - Undo
Ctrl + Alt + Backspace    - Redo
Enter                     - Line Break
Shift + Enter             - LineBreak
Tab                       - Tab
Shift + Tab               - Shift Tab
F1                        - Context Help
Ctrl + A                  - Select All
Ctrl + C                  - Copy
Ctrl + V                  - Paste
Ctrl + X                  - Cut
Shift + Ctrl + I          - Block Indent
Shift + Ctrl + U          - Block UnIndent
Ctrl + M, Enter           - LineBreak
Ctrl + N                  - Insert Line
Ctrl + T                  - Delete Word
Ctrl + Y                  - Delete Line
Shift + Ctrl + Y          - Delete To EOL
Ctrl + Z                  - Undo
Shift + Ctrl + Z          - Redo
Ctrl + <Digit>            - Goto Marker
Shift + Ctrl + <Digit>    - Set Marker
Shift + Ctrl + N          - Switch To Normal Select Mode
Shift + Ctrl + C          - Switch To Column Select Mode
Shift + Ctrl + L          - Switch To Line Select Mode
Shift + Ctrl + B          - Find Matching Bracket

*)

end.

