unit pSHIntf;

interface

uses Classes;

type

  TtkTokenKind = (tkComment, tkDatatype, tkDefaultPackage, tkException,
    tkFunction, tkIdentifier, tkKey, tkNull, tkNumber, tkSpace, tkPLSQL,
    tkSQLPlus, tkString, tkSymbol, tkTableName, tkUnknown, tkVariable,
    tkCustomStrings);                                                           //pavel

  TRangeState = (rsUnknown, rsComment, rsString);

  TProcTableProc = procedure of object;

  TEnumerateKeywordsProc = procedure(AKind: integer; KeywordList: string) of object;

  TSQLDialect = (sqlStandard, sqlInterbase, sqlMSSQL, sqlMySQL, sqlOracle,
    sqlSybase, sqlIngres, sqlMSSQL2K);                                         

  TSQLSubDialect = integer;

  TpSHHyperLinkRule = (hlrSingleClick, hlrCtrlClick, hlrDblClick);

  TpSHCaseCode = (ccLower, ccUpper, ccNameCase, ccFirstUpper, ccNone,
    ccInvert, ccToggle);

  TpSHNeedObjectType = (ntAll, ntDomain, ntTable, ntView, ntProcedure, ntTrigger,
    ntGenerator, ntException, ntFunction, ntFilter, ntRole, ntKeyWords,
    ntDataTypes, ntBuildInFunctions, ntField, ntVariable, ntCustomStrings,
    ntTableOrViewOrProcedure,ntTableOrView,ntFieldOrFunction,
    ntFieldOrVariableOrFunction, ntExecutable, ntReturningValues,ntDeclareVariables
  );

  TpSHNeedObjectTypes = Set of TpSHNeedObjectType;

(*const
  //InterBase subdialects {1..20}
  ibdInterBase4  = 1;
  ibdInterBase5  = 2;
  ibdInterBase6  = 3;
  ibdInterBase65 = 4;
  ibdInterBase7  = 5;
  ibdInterBase75 = 6;
  ibdFirebird1   = 7;
  ibdFirebird15  = 8;
  ibdFirebird20  = 9;
*)
 const
   ibdInterBase6  = 3; // Ключевой диалект для хайлайтера
  //MySQL subdialects {21..40}

  //Sybase dialects {41..60}

  //Oracle dialects {61..80}

type

  IpSHSynEditManager = interface
  ['{A07C3B09-3992-449A-8B8E-C7ACA6CECD2A}']

  end;

  //Предоставляет список объектов для подсветки
  IpSHObjectNamesManager = interface
  ['{89E0C14D-3871-4CBC-BAEA-8CFC0CCAD047}']
    {Highlighter methods group}
    //MayBe - начало слова
    //Position - положение слова от начала строки
    function GetObjectNamesRetriever: IInterface;
    procedure SetObjectNamesRetriever(const Value: IInterface);
    function GetHighlighter: TComponent;
    function GetCompletionProposal: TComponent;
    function GetParametersHint: TComponent;
    function GetCaseCode: TpSHCaseCode;
    procedure SetCaseCode(const Value: TpSHCaseCode);
    function GetCaseSQLCode: TpSHCaseCode;
    procedure SetCaseSQLCode(const Value: TpSHCaseCode);
    procedure LinkSearchNotify(Sender: TObject; MayBe: PChar;
      Position, Len: Integer; var TokenKind: TtkTokenKind);
    {Completion proposal methods group}
    procedure ExecuteNotify(Kind: Integer; Sender: TObject;
      var CurrentInput: string; var x, y: Integer; var CanExecute: Boolean);
    {Editor methods group}
    procedure FindDeclaration(const AObjectName: string);
    //Для обслуживания ситуаций с квотированием и регистрозависимостью
    function IsIdentifiresEqual(Sender: TObject;
      AIdentifire1, AIdentifire2: string): Boolean;
    property ObjectNamesRetriever: IInterface read GetObjectNamesRetriever
      write SetObjectNamesRetriever;
    property Highlighter: TComponent read GetHighlighter;
    property CompletionProposal: TComponent read GetCompletionProposal;
    property ParametersHint: TComponent read GetParametersHint;

    property CaseCode: TpSHCaseCode read GetCaseCode write SetCaseCode;
    property CaseSQLCode: TpSHCaseCode read GetCaseSQLCode write SetCaseSQLCode;
  end;

  //Предоставляет список ключевых слов в соответствии с выбранным
  //SQL диалектом и версией сервера
  IpSHKeywordsManager = interface
  ['{2A052CA8-BBFD-4BFE-9715-B132EF9E04EF}']

    procedure InitializeKeywordLists(Sender: TObject; SubDialect: TSQLSubDialect;
      EnumerateKeywordsProc: TEnumerateKeywordsProc);
    procedure ChangeSubSQLDialectTo(ASubSQLDialect: TSQLSubDialect);
    procedure AddHighlighter(AHighlighter: TComponent);
    procedure RemoveHighlighter(AHighlighter: TComponent);
    function IsKeyword(AWord: string): Boolean;

  end;

//  IpSHExecutableCommandManager = interface
//  ['{E17B4562-BC64-4201-862E-5FB950F97167}']

//    procedure RunQuery(const AText: string);
//    procedure PrepareQuery(const AText: string);
//  end;

  IpSHUserInputHistory = interface
  ['{A49E5F9A-1FB4-4D58-8C76-385512DB7974}']

    function GetFindHistory: TStrings;
    function GetReplaceHistory: TStrings;
    function GetGotoLineNumberHistory: TStrings;
    function GetPromtOnReplace: Boolean;
    procedure SetPromtOnReplace(const Value: Boolean);

    procedure AddToFindHistory(const AString: string);
    procedure AddToReplaceHistory(const AString: string);
    procedure AddToGotoLineNumberHistory(const AString: string);

    property FindHistory: TStrings read GetFindHistory;
    property ReplaceHistory: TStrings read GetReplaceHistory;
    property GotoLineNumberHistory: TStrings
      read GetGotoLineNumberHistory;
    property PromtOnReplace: Boolean read GetPromtOnReplace
      write SetPromtOnReplace;
  end;

  IpSHAutoComplete = interface
  ['{3919CBDD-C590-4D04-B5E2-C64DBEC5B5DB}']
    function GetAutoComplete: TComponent;
  end;

  IpSHFieldListRetriever = interface
  ['{5F9F29D9-5F55-496B-97B3-D616DE6C81A1}']
    function GetDatabase: IInterface;
    procedure SetDatabase(const Value: IInterface);
    function GetFieldList(const AObjectName: string; AList: TStrings): Boolean;
    property Database: IInterface read GetDatabase write SetDatabase;
  end;

  IpSHCompletionProposalOptions = interface
  ['{223F197A-4E6C-40C0-8988-F78F8FE78F81}']
    function GetEnabled: Boolean;
    procedure SetEnabled(const Value: Boolean);
    function GetExtended: Boolean;
    procedure SetExtended(const Value: Boolean);
//    function GetCodeParametersEnabled: Boolean;
//    procedure SetCodeParametersEnabled(const Value: Boolean);
    function GetLinesCount: Integer;
    procedure SetLinesCount(const Value: Integer);
    function GetWidth: Integer;
    procedure SetWidth(const Value: Integer);

    property Enabled: Boolean read GetEnabled
      write SetEnabled;
    property Extended: Boolean read GetExtended
      write SetExtended;
//    property CodeParametersEnabled: Boolean read GetCodeParametersEnabled
//      write SetCodeParametersEnabled;
    property LinesCount: Integer read GetLinesCount
      write SetLinesCount;
    property Width: Integer read GetWidth
      write SetWidth;
  end;

  IpSHProposalHintRetriever = interface
  ['{D8F5951E-FA0B-41D1-B370-6A9645AE4C12}']

    procedure AfterCompile(Sender: TObject);
    function GetHint(const AObjectName: string; var AHint: string;
      IsReturningValuesSection: Boolean): Boolean;

  end;

implementation


end.
