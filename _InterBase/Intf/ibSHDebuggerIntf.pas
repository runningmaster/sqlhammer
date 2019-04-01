unit ibSHDebuggerIntf;

interface

uses
  SysUtils, Classes, Graphics, Types,
  SHDesignIntf, ibSHDriverIntf;

type

  TibSHDebugGroupStatementType =
  (dgstEmpty,
   dgstProcedure, dgstTrigger, dgstSimple,
   dgstCondition, //dgstConditionClause, dgstConditionThenClause, dgstConditionElseClause,
//   dgstSimpleCase, dgstSearchedCase, dgstCaseConditionClause, dgstCaseWhenClause, dgstCaseElseClause,
//   dgstNullIf,
//   dgstCoalesce,
//   dgstIIF, dgstIIFConditionClause, dgstIIFConditionTrueClause, dgstIIFConditionFalseClause,//!!!
   dgstForSelectCycle, dgstWhileCycle,
   dgstErrorHandler);

   TibSHDebugOperatorType =
   (dotEmpty,
    dotLeave, dotExit, dotSuspend,

    dotExpression,
    dotSelect, {dotSelectInto, }dotExecuteProcedure,dotExecuteStatement,
    dotFunction,
    dotInsert, dotUpdate, dotDelete, dotException,dotLastEnd,dotFirstBegin

    ,dotOpenCursor,dotCloseCursor, dotFetchCursor,dotErrorHandler

   );

  IibSHPSQLProcessor = interface
  ['{C760EF1B-E1FA-42D0-9519-F488692647F8}']
    function GetCursor(AName: string): Variant;
    procedure SetCursor(AName: string; const Value: Variant);
    function GetVariable(AName: string): Variant;
    procedure SetVariable(AName: string; const Value: Variant);
    function CreateDataSet: TComponent;

    property Cursor[AName: string] : Variant read GetCursor write SetCursor;
    property Variable[AName: string] : Variant read GetVariable write SetVariable;
  end;

  IibSHDebugStatement = interface
  ['{7AD838AB-8266-44FD-AF06-7BE38C0CA6FF}']
    function GetGroupStatementType: TibSHDebugGroupStatementType;
    procedure SetGroupStatementType(Value: TibSHDebugGroupStatementType);{?}
    function GetOperatorType: TibSHDebugOperatorType;
    procedure SetOperatorType(Value: TibSHDebugOperatorType);{?}
    function GetParentStatement: IibSHDebugStatement;
    procedure SetParentStatement(Value: IibSHDebugStatement);
    function GetPriorStatement: IibSHDebugStatement;
    procedure SetPriorStatement(Value: IibSHDebugStatement);
    function GetNextStatement: IibSHDebugStatement;
    procedure SetNextStatement(Value: IibSHDebugStatement);
    function GetChildStatements(Index: Integer): IibSHDebugStatement;
    function GetChildStatementsCount: Integer;
    function GetBeginOfStatement: TPoint;
    procedure SetBeginOfStatement(Value: TPoint);
    function GetEndOfStatement: TPoint;
    procedure SetEndOfStatement(Value: TPoint);
    function GetDataSet: IibSHDRVDataset;
    function GetProcessor: IibSHPSQLProcessor;
    procedure SetProcessor(Value: IibSHPSQLProcessor);
    function GetVariableNames: TStrings;
    function GetVariableName: string;
    function GetOperatorText: string;
    function GetUsesCursor: Boolean;
    function GetCursorName: string;


    function AddChildStatement(Value: TComponent): Integer;
    function RemoveChildStatement(Value: TComponent): Integer;

    function  GetErrorHandlerStmt: IibSHDebugStatement;
    procedure SetErrorHandlerStmt(Value: IibSHDebugStatement);

    function  GetLastErrorCode:TibErrorCode;
    procedure  SetLastErrorCode(Value:TibErrorCode);    

    function CanExecute(Value: Variant): Boolean;
    procedure Execute(Values: array of Variant; out Results: array of Variant);
    function Parse: Boolean;
    function GetIsDynamicStatement:boolean;
    property GroupStatementType: TibSHDebugGroupStatementType
      read GetGroupStatementType write SetGroupStatementType;
    property OperatorType: TibSHDebugOperatorType
      read GetOperatorType write SetOperatorType;
    property ParentStatement: IibSHDebugStatement
      read GetParentStatement write SetParentStatement;
    property PriorStatement: IibSHDebugStatement
      read GetPriorStatement write SetPriorStatement;
    property NextStatement: IibSHDebugStatement
      read GetNextStatement write SetNextStatement;
    property ChildStatements[Index: Integer]: IibSHDebugStatement
      read GetChildStatements;
    property ChildStatementsCount: Integer read GetChildStatementsCount;
    property BeginOfStatement: TPoint
      read GetBeginOfStatement write SetBeginOfStatement;
    property EndOfStatement: TPoint
      read GetEndOfStatement write SetEndOfStatement;

    property DataSet: IibSHDRVDataset read GetDataSet;
    property Processor: IibSHPSQLProcessor
      read GetProcessor write SetProcessor;
    property VariableNames: TStrings read GetVariableNames;
    property VariableName: string read GetVariableName;
    property OperatorText: string read GetOperatorText;
    property UsesCursor: Boolean read GetUsesCursor;
    property CursorName: string read GetCursorName;
    property IsDynamicStatement:boolean read GetIsDynamicStatement;
    property  ErrorHandlerStmt: IibSHDebugStatement read GetErrorHandlerStmt write SetErrorHandlerStmt;
    property LastErrorCode:TibErrorCode read GetLastErrorCode write SetLastErrorCode; 
  end;

  IibSHPSQLDebuggerItem = interface
  ['{25F6FFA5-300A-4BEB-89EA-0B01CCF6C3F9}']
    function GetDebugObjectName: string;
    function GetObjectBody: TStrings;
    function GetDebugObjectType: TGUID;
    function GetParserPosition: TPoint;
    procedure SetParserPosition(Value: TPoint);
    function GetDRVDatabase: IibSHDRVDatabase;
    function GetDRVTransaction: IibSHDRVTransaction;
    {
    function GetParentDebugger: IibSHPSQLDebuggerItem;
    function GetChildDebuggers(Index: Integer): IibSHPSQLDebuggerItem;
    procedure SetChildDebuggers(Index: Integer; Value: IibSHPSQLDebuggerItem);
    function GetChildDebuggersCount: Integer;
    function GetEditor: Pointer;
    procedure SetEditor(Value: Pointer);
    }
    function GetFirstStatement: IibSHDebugStatement;
    function GetCurrentStatement: IibSHDebugStatement;
    procedure SetCurrentStatement(Value: IibSHDebugStatement);
    function GetInputParameters(Index: Integer): Variant;
    procedure SetInputParameters(Index: Integer; Value: Variant);
    function GetInputParametersCount: Integer;
    function GetOutputParameters(Index: Integer): Variant;
    procedure SetOutputParameters(Index: Integer; Value: Variant);
    function GetOutputParametersCount: Integer;
    function GetLocalVariables(Index: Integer): Variant;
    procedure SetLocalVariables(Index: Integer; Value: Variant);
    function GetLocalVariablesCount: Integer;
    function GetTokenScaner: TComponent;
    function GetServerException: Boolean;
    procedure SetServerException(Value: Boolean);

    procedure StatementFound(AStatement: IibSHDebugStatement);

    {
    function AddChildDebugger(Value: IibSHPSQLDebuggerItem): Integer;
    }
    function Parse: Boolean;
    procedure ClearStatementTree;

    property DebugObjectName: string read GetDebugObjectName;
    property ObjectBody: TStrings read GetObjectBody;
    property DebugObjectType: TGUID read GetDebugObjectType;
    property ParserPosition: TPoint read GetParserPosition write SetParserPosition;
    property DRVDatabase: IibSHDRVDatabase read GetDRVDatabase;
    property DRVTransaction: IibSHDRVTransaction read GetDRVTransaction;
    {
    property ParentDebugger: IibSHPSQLDebuggerItem read GetParentDebugger;
    property ChildDebuggers[Index: Integer]: IibSHPSQLDebuggerItem
      read GetChildDebuggers write SetChildDebuggers;
    property ChildDebuggersCount: Integer read GetChildDebuggersCount;
    property Editor: Pointer read GetEditor write SetEditor;
    }
    property FirstStatement: IibSHDebugStatement read GetFirstStatement;
    property CurrentStatement: IibSHDebugStatement
      read GetCurrentStatement write SetCurrentStatement;
    property InputParameters[Index: Integer]: Variant
      read GetInputParameters write SetInputParameters;
    property InputParametersCount: Integer read GetInputParametersCount;
    property OutputParameters[Index: Integer]: Variant
      read GetOutputParameters write SetOutputParameters;
    property OutputParametersCount: Integer read GetOutputParametersCount;
    property LocalVariables[Index: Integer]: Variant
      read GetLocalVariables write SetLocalVariables;
    property LocalVariablesCount: Integer read GetLocalVariablesCount;
    property TokenScaner: TComponent read GetTokenScaner;
    property ServerException: Boolean read GetServerException
      write SetServerException;
  end;

  IibSHPSQLDebuggerTrigger = interface(IibSHPSQLDebuggerItem)
  ['{9EEE7BC6-D614-42D9-8F49-0562D3E5D358}']
    procedure SetInputRow(DB_KEY: string);
  end;

implementation

end.

