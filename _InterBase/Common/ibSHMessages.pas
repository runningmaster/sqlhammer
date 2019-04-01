unit ibSHMessages;

interface

resourcestring

  SUnregisterServer = 'Unregister server alias "%s"?';
  SUnregisterDatabase = 'Unregister database alias "%s"?';
  SDropDatabase = 'Drop database "%s"?';
  SDeleteUser = 'Delete user "%s"?';
  SDriverIsNotInstalled = 'Driver is not installed';
  SServerTestConnectionOK = 'Test connect to server "%s" successfully passed';
  SServerTestConnectionNO = 'Test connect to server "%s" not passed (or Services API not found)' + SLineBreak + 'Detail information:' + SLineBreak + '----------------------------' + SLineBreak + '%s';
  SDatabaseTestConnectionOK = 'Test connect to database "%s" successfully passed';
  SDatabaseTestConnectionNO = 'Test connect to database "%s" not passed' + SLineBreak + 'Detail information:' + SLineBreak + '----------------------------' + SLineBreak + '%s';
  SDatabaseConnectNO = 'Can not connect to database "%s"' + SLineBreak + 'Detail information:' + SLineBreak + '----------------------------' + SLineBreak + '%s';
  SServerIsNotInterBase  = 'Current server is not Firebird/InterBase server. The operation is aborted';
  SDatabaseIsNotInterBase  = 'Current database is not Firebird/InterBase database or database is not connected. The operation is aborted';
  SApplicationNotFound = 'Application "%s" not found';
  SNoParametersExpected = '* No parameters expected *';
  SDDLStatementInput = 'You are trying to execute DDL statement.'#13#10'Please, use DDL editor for this purpose.'#13#10'Load DDL editor with current statement?';
  SReplaceEditorContextWorning = 'Do you realy want to replace existing SQL Editor context by saved?';
  SClearEditorContextWorning = 'Clear SQL Editor context?';
  SClearDMLHistoryWorning = 'Clear DML History for %s?';
  SClearDDLHistoryWorning = 'Clear DDL History for %s?';
  SCommitTransaction = 'Commit transaction?';
  SCloseResult = 'Close result?';
  SRollbackTransaction = 'Rollback transaction?';
  STransactionCommited = 'Transaction commited...';
  STransactionRolledBack = 'Transaction rolled back...';
  STransactionStarted= 'Transaction started (%s)';
  SNoExportersRegisted = 'Cannot save data couse of no dataexporters registed.';
  SSQLEditorTransactionActive = 'Please, end active transaction to change this property.';
  SNotSupported = 'Not supported yet.';
  SFileModified = 'File was modified. Save changes?';
  STextModified = 'Text was modified. Save changes?';
  SDataFetching = 'Fetching data in progress.' + SLineBreak + 'Stop fetch before closing editor.';
  SErrorPlanRetrieving = 'Error plan retrieving.';
//  SStatisticInserted = '%d record(s) was(were) inserted in %s';
//  SStatisticUpdated = '%d record(s) was(were) updated in %s';
//  SStatisticDeleted = '%d record(s) was(were) deleted from %s';
//  SStatisticIndexedRead = '%d indexed reads from %s';
//  SStatisticNonIndexedRead = '%d non-indexed reads from %s';
  SStatisticInserted = 'Inserts into %s: %s';
  SStatisticUpdated = 'Updates of %s: %s';
  SStatisticDeleted = 'Deletes from %s: %s';
  SStatisticIndexedRead = 'Indexed reads from %s: %s';
  SStatisticNonIndexedRead = 'Non-indexed reads from %s: %s';

  SMillisecondsFmt = ' %d ms';
  SSecondsFmt = ' %d s';
  SMinutesFmt = ' %d min';
  SHoursFmt = ' %d h';
  SDaysFmt = ' %d days';
  SPrepare = 'Prepare';
  SExecute = 'Execute';
  SFetch = 'Fetch';
  SStatistics = 'Statistics';

  SOperationsPerTable = 'Operations';
  SGarbageStatistics = 'Garbage collection';
  SStatisticsSummary = 'Statistics summary';
  SQueryTime = 'Time';
  SIndexedReads = '  indexed reads';
  SNonIndexedReads = '  non-indexed reads';
  SUpdates = '  updates';
  SDeletes = '  deletes';
  SInserts = '  inserts';
  SBackouts = '  backouts';
  SExpunges = '  expunges';
  SPurges = '  purges';

  SFileIOError = 'Unable to create/open file: %s!';

  //Player captions
  SUnknown   = 'Unknown';
  SDatabases = 'Databases';
  SDomains = 'Domains';
  STables = 'Tables';
  SViews = 'Views';
  SProcedures = 'Procedures';
  STriggers = 'Triggers';
  SGenerators = 'Generators';
  SExceptions = 'Exceptions';
  SFunctions = 'Functions';
  SRoles = 'Roles';
  SIndices = 'Indices';
  SDML     = 'DML';

  SStateSQL = 'SQL';
  SStateCreate = 'Create';
  SStateAlter = 'Alter';
  SStateDrop = 'Drop';
  SStateRecreate = 'Recreate';
  SStateConnect = 'Connect';
  SStateReConnect = 'Reconnect';
  SStateDisConnect = 'Disconnect';
  SStateGrant = 'Grant';
  SComment='Comment';

  SPlayerContainsDatabaseStats = 'SQL Script contains database manipulations statements'#13#10'and will be executed in additional connection.'#13#10'Continue with new connection?';
  SPlayerSuccess = 'SQL Script executed successfuly.';
  SPlayerError = 'SQL Script executed with errors.';
  SUncommitedChanges = 'There are uncommited changes.'#13#10'Commit them?';
  SPlayerTerminated = 'SQL Script terminated by user.';
  SPlayerStartedAt = 'SQL Script started at ';
  SPlayerTraceModeStartedAt = 'SQL Script Trace Mode started at ';
  SPlayerTerminatedAt = 'SQL Script terminated by user at ';
  SPlayerTerminatedAtLine = 'SQL Script terminated at Line N %d';
  SPlayerSuccessfulyExecutedAt = 'SQL Script successfuly executed at ';
  SPlayerExecutedWithErrorsAt = 'SQL Script executed with errors at ';
  SPlayerStatementExecutedWithErrorsAt = 'Statement executed with errors at ';
  SElapsedTime = 'Elapsed time ';
  SRuningScript = 'Running script...';
  SParsingScript = 'Parsing script...';
  SExtractorTmpBLOBFileUserNotification = '/* BT: The following temporary file with BLOB fields content will be automatically renamed and moved to the current directory after saving script output. */';

  //DML Exporter
  SLoadingTables = 'Loading Tables...';

implementation

end.

