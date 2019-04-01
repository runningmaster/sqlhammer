unit ibSHDatabaseAliasOptions;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs, Graphics,
  SHDesignIntf, ibSHDesignIntf, ibSHConsts;

type
  TibSHDDLOptions = class;
  TibSHDMLOptions = class;
  TibSHNavigatorOptions = class;
  TibSHDatabaseAliasOptions = class(TSHInterfacedPersistent, IibSHDatabaseAliasOptions)
  private
    FNavigator: TibSHNavigatorOptions;
    FDDL: TibSHDDLOptions;
    FDML: TibSHDMLOptions;
    function GetDDL: IibSHDDLOptions;
    function GetDML: IibSHDMLOptions;
    function GetNavigator: IibSHNavigatorOptions;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Navigator: TibSHNavigatorOptions read FNavigator write FNavigator;
    property DDL: TibSHDDLOptions read FDDL write FDDL;
    property DML: TibSHDMLOptions read FDML write FDML;
  end;

  TibSHNavigatorOptions = class(TSHInterfacedPersistent, IibSHNavigatorOptions)
  private
    FFavoriteObjectNames: TStrings;
    FFavoriteObjectColor: TColor;
    FShowDomains: Boolean;
    FShowTables: Boolean;
    FShowViews: Boolean;
    FShowProcedures: Boolean;
    FShowTriggers: Boolean;
    FShowGenerators: Boolean;
    FShowExceptions: Boolean;
    FShowFunctions: Boolean;
    FShowFilters: Boolean;
    FShowRoles: Boolean;
    FShowIndices: Boolean;
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
  public
    constructor Create;
    destructor Destroy; override;
  published
    property FavoriteObjectNames: TStrings read GetFavoriteObjectNames write SetFavoriteObjectNames;
    property FavoriteObjectColor: TColor read FFavoriteObjectColor write FFavoriteObjectColor;
    property ShowDomains: Boolean read FShowDomains write FShowDomains;
    property ShowTables: Boolean read FShowTables write FShowTables;
    property ShowViews: Boolean read FShowViews write FShowViews;
    property ShowProcedures: Boolean read FShowProcedures write FShowProcedures;
    property ShowTriggers: Boolean read FShowTriggers write FShowTriggers;
    property ShowGenerators: Boolean read FShowGenerators write FShowGenerators;
    property ShowExceptions: Boolean read FShowExceptions write FShowExceptions;
    property ShowFunctions: Boolean read FShowFunctions write FShowFunctions;
    property ShowFilters: Boolean read FShowFilters write FShowFilters;
    property ShowRoles: Boolean read FShowRoles write FShowRoles;
    property ShowIndices: Boolean read FShowIndices write FShowIndices;    
  end;

  TibSHDDLOptions = class(TSHInterfacedPersistent, IibSHDDLOptions)
  private
    FAutoCommit: Boolean;
    FStartDomainForm: string;
    FStartTableForm: string;
    FStartIndexForm: string;
    FStartViewForm: string;
    FStartProcedureForm: string;
    FStartTriggerForm: string;
    FStartGeneratorForm: string;
    FStartExceptionForm: string;
    FStartFunctionForm: string;
    FStartFilterForm: string;
    FStartRoleForm: string;

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
  protected
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
  published
    property AutoCommit: Boolean read FAutoCommit write FAutoCommit;
  end;

  TibSHDMLOptions = class(TSHInterfacedPersistent, IibSHDMLOptions)
  private
    FAutoCommit: Boolean;
    FShowDB_KEY: Boolean;
    FUseDB_KEY: Boolean;
    FConfirmEndTransaction: string;
    FDefaultTransactionAction: string;
    FIsolationLevel: string;
    FTransactionParams: TStringList;
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
  public
    constructor Create;
    destructor Destroy; override;
  published
    property AutoCommit: Boolean read GetAutoCommit write SetAutoCommit;
    property ShowDB_KEY: Boolean read FShowDB_KEY write FShowDB_KEY;
    property UseDB_KEY: Boolean read FUseDB_KEY write FUseDB_KEY;
    property ConfirmEndTransaction: string read FConfirmEndTransaction write FConfirmEndTransaction;
    property DefaultTransactionAction: string read FDefaultTransactionAction write FDefaultTransactionAction;
    property IsolationLevel: string read GetIsolationLevel write SetIsolationLevel;
    property TransactionParams: TStrings read GetTransactionParams write SetTransactionParams;
  end;

  TibSHDatabaseAliasOptionsInt = class(TSHInterfacedPersistent, IibSHDatabaseAliasOptionsInt)
  private
    FFilterList: TStrings;
    FFilterIndex: Integer;

    FDMLHistoryActive: Boolean;
    FDMLHistoryMaxCount: Integer;
    FDMLHistorySelect: Boolean;
    FDMLHistoryInsert: Boolean;
    FDMLHistoryUpdate: Boolean;
    FDMLHistoryDelete: Boolean;
    FDMLHistoryExecute: Boolean;
    FDMLHistoryCrash: Boolean;

    FDDLHistoryActive: Boolean;

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
  public
    constructor Create;
    destructor Destroy; override;
  published
    property FilterList: TStrings read GetFilterList write SetFilterList;
    property FilterIndex: Integer read GetFilterIndex write SetFilterIndex;

    property DMLHistoryActive: Boolean read GetDMLHistoryActive
      write SetDMLHistoryActive default True;
    property DMLHistoryMaxCount: Integer read GetDMLHistoryMaxCount
      write SetDMLHistoryMaxCount default 0;
    property DMLHistorySelect: Boolean read GetDMLHistorySelect
      write SetDMLHistorySelect default True;
    property DMLHistoryInsert: Boolean read GetDMLHistoryInsert
      write SetDMLHistoryInsert default True;
    property DMLHistoryUpdate: Boolean read GetDMLHistoryUpdate
      write SetDMLHistoryUpdate default True;
    property DMLHistoryDelete: Boolean read GetDMLHistoryDelete
      write SetDMLHistoryDelete default True;
    property DMLHistoryExecute: Boolean read GetDMLHistoryExecute
      write SetDMLHistoryExecute default True;
    property DMLHistoryCrash: Boolean read GetDMLHistoryCrash
      write SetDMLHistoryCrash default False;

    property DDLHistoryActive: Boolean read GetDDLHistoryActive
      write SetDDLHistoryActive;      
  end;

implementation

{ TibSHDatabaseAliasOptions }

constructor TibSHDatabaseAliasOptions.Create;
begin
  inherited Create;
  FNavigator := TibSHNavigatorOptions.Create;
  FDDL := TibSHDDLOptions.Create;
  FDML := TibSHDMLOptions.Create;

  Navigator.FavoriteObjectColor := clBlue;
  Navigator.ShowDomains := True;
  Navigator.ShowTables := True;
  Navigator.ShowViews := True;
  Navigator.ShowProcedures := True;
  Navigator.ShowTriggers := True;
  Navigator.ShowGenerators := True;
  Navigator.ShowExceptions := True;
  Navigator.ShowFunctions := True;
  Navigator.ShowFilters := True;
  Navigator.ShowRoles := True;
  Navigator.ShowIndices := True;
  
  DDL.AutoCommit := True;
  DDL.StartDomainForm := SCallSourceDDL;
  DDL.StartTableForm := SCallSourceDDL;
  DDL.StartIndexForm := SCallSourceDDL;
  DDL.StartViewForm := SCallSourceDDL;
  DDL.StartProcedureForm := SCallSourceDDL;
  DDL.StartTriggerForm := SCallSourceDDL;
  DDL.StartGeneratorForm := SCallSourceDDL;
  DDL.StartExceptionForm := SCallSourceDDL;
  DDL.StartFunctionForm := SCallSourceDDL;
  DDL.StartFilterForm := SCallSourceDDL;
  DDL.StartRoleForm := SCallSourceDDL;


  DML.AutoCommit := False;
  DML.ShowDB_KEY := False;
  DML.UseDB_KEY := True;
  DML.ConfirmEndTransaction := ConfirmEndTransactions[0];
  DML.DefaultTransactionAction := DefaultTransactionActions[0];
  DML.IsolationLevel := IsolationLevels[1];
  DML.TransactionParams.Text := TransactionParamsCustomDefault;
end;

destructor TibSHDatabaseAliasOptions.Destroy;
begin
  FNavigator.Free;
  FDDL.Free;
  FDML.Free;
  inherited Destroy;
end;

function TibSHDatabaseAliasOptions.GetDDL: IibSHDDLOptions;
begin
  Supports(FDDL, IibSHDDLOptions, Result);
end;

function TibSHDatabaseAliasOptions.GetDML: IibSHDMLOptions;
begin
  Supports(FDML, IibSHDMLOptions, Result);
end;

function TibSHDatabaseAliasOptions.GetNavigator: IibSHNavigatorOptions;
begin
  Supports(FNavigator, IibSHNavigatorOptions, Result);
end;

{ TibSHNavigatorOptions }

constructor TibSHNavigatorOptions.Create;
begin
  inherited Create;
  FFavoriteObjectNames := TStringList.Create;
end;

destructor TibSHNavigatorOptions.Destroy;
begin
  FFavoriteObjectNames.Free;
  inherited Destroy;
end;

function TibSHNavigatorOptions.GetFavoriteObjectNames: TStrings;
begin
  Result := FFavoriteObjectNames;
end;

procedure TibSHNavigatorOptions.SetFavoriteObjectNames(Value: TStrings);
begin
  TStringList(FFavoriteObjectNames).Sorted := False;
  FFavoriteObjectNames.Assign(Value);
  TStringList(FFavoriteObjectNames).Sorted := True;
end;

function TibSHNavigatorOptions.GetFavoriteObjectColor: TColor;
begin
  Result := FavoriteObjectColor;
end;

procedure TibSHNavigatorOptions.SetFavoriteObjectColor(Value: TColor);
begin
  FavoriteObjectColor := Value;
end;

function TibSHNavigatorOptions.GetShowDomains: Boolean;
begin
  Result := ShowDomains;
end;

procedure TibSHNavigatorOptions.SetShowDomains(Value: Boolean);
begin
  ShowDomains := Value;
end;

function TibSHNavigatorOptions.GetShowTables: Boolean;
begin
  Result := ShowTables;
end;

procedure TibSHNavigatorOptions.SetShowTables(Value: Boolean);
begin
  ShowTables := Value;
end;

function TibSHNavigatorOptions.GetShowViews: Boolean;
begin
  Result := ShowViews;
end;

procedure TibSHNavigatorOptions.SetShowViews(Value: Boolean);
begin
  ShowViews := Value;
end;

function TibSHNavigatorOptions.GetShowProcedures: Boolean;
begin
  Result := ShowProcedures;
end;

procedure TibSHNavigatorOptions.SetShowProcedures(Value: Boolean);
begin
  ShowProcedures := Value;
end;

function TibSHNavigatorOptions.GetShowTriggers: Boolean;
begin
  Result := ShowTriggers;
end;

procedure TibSHNavigatorOptions.SetShowTriggers(Value: Boolean);
begin
  ShowTriggers := Value;
end;

function TibSHNavigatorOptions.GetShowGenerators: Boolean;
begin
  Result := ShowGenerators;
end;

procedure TibSHNavigatorOptions.SetShowGenerators(Value: Boolean);
begin
  ShowGenerators := Value;
end;

function TibSHNavigatorOptions.GetShowExceptions: Boolean;
begin
  Result := ShowExceptions;
end;

procedure TibSHNavigatorOptions.SetShowExceptions(Value: Boolean);
begin
  ShowExceptions := Value;
end;

function TibSHNavigatorOptions.GetShowFunctions: Boolean;
begin
  Result := ShowFunctions;
end;

procedure TibSHNavigatorOptions.SetShowFunctions(Value: Boolean);
begin
  ShowFunctions := Value;
end;

function TibSHNavigatorOptions.GetShowFilters: Boolean;
begin
  Result := ShowFilters;
end;

procedure TibSHNavigatorOptions.SetShowFilters(Value: Boolean);
begin
  ShowFilters := Value;
end;

function TibSHNavigatorOptions.GetShowRoles: Boolean;
begin
  Result := ShowRoles;
end;

procedure TibSHNavigatorOptions.SetShowRoles(Value: Boolean);
begin
  ShowRoles := Value;
end;

function TibSHNavigatorOptions.GetShowIndices: Boolean;
begin
  Result := ShowIndices;
end;

procedure TibSHNavigatorOptions.SetShowIndices(Value: Boolean);
begin
  ShowIndices := Value;
end;

{ TibSHDDLOptions }

function TibSHDDLOptions.GetAutoCommit: Boolean;
begin
  Result := AutoCommit;
end;

procedure TibSHDDLOptions.SetAutoCommit(Value: Boolean);
begin
  AutoCommit := Value;
end;

function TibSHDDLOptions.GetStartDomainForm: string;
begin
  Result := FStartDomainForm;
end;

procedure TibSHDDLOptions.SetStartDomainForm(Value: string);
begin
  FStartDomainForm := Value;
end;

function TibSHDDLOptions.GetStartTableForm: string;
begin
  Result := FStartTableForm;
end;

procedure TibSHDDLOptions.SetStartTableForm(Value: string);
begin
  FStartTableForm := Value;
end;

function TibSHDDLOptions.GetStartIndexForm: string;
begin
  Result := FStartIndexForm;
end;

procedure TibSHDDLOptions.SetStartIndexForm(Value: string);
begin
  FStartIndexForm := Value;
end;

function TibSHDDLOptions.GetStartViewForm: string;
begin
  Result := FStartViewForm;
end;

procedure TibSHDDLOptions.SetStartViewForm(Value: string);
begin
  FStartViewForm := Value;
end;

function TibSHDDLOptions.GetStartProcedureForm: string;
begin
  Result := FStartProcedureForm;
end;

procedure TibSHDDLOptions.SetStartProcedureForm(Value: string);
begin
  FStartProcedureForm := Value;
end;

function TibSHDDLOptions.GetStartTriggerForm: string;
begin
  Result := FStartTriggerForm;
end;

procedure TibSHDDLOptions.SetStartTriggerForm(Value: string);
begin
  FStartTriggerForm := Value;
end;

function TibSHDDLOptions.GetStartGeneratorForm: string;
begin
  Result := FStartGeneratorForm;
end;

procedure TibSHDDLOptions.SetStartGeneratorForm(Value: string);
begin
  FStartGeneratorForm := Value;
end;

function TibSHDDLOptions.GetStartExceptionForm: string;
begin
  Result := FStartExceptionForm;
end;

procedure TibSHDDLOptions.SetStartExceptionForm(Value: string);
begin
  FStartExceptionForm := Value;
end;

function TibSHDDLOptions.GetStartFunctionForm: string;
begin
  Result := FStartFunctionForm;
end;

procedure TibSHDDLOptions.SetStartFunctionForm(Value: string);
begin
  FStartFunctionForm := Value;
end;

function TibSHDDLOptions.GetStartFilterForm: string;
begin
  Result := FStartFilterForm;
end;

procedure TibSHDDLOptions.SetStartFilterForm(Value: string);
begin
  FStartFilterForm := Value;
end;

function TibSHDDLOptions.GetStartRoleForm: string;
begin
  Result := FStartRoleForm;
end;

procedure TibSHDDLOptions.SetStartRoleForm(Value: string);
begin
  FStartRoleForm := Value;
end;

{ TibSHDMLOptions }

function TibSHDMLOptions.GetAutoCommit: Boolean;
begin
  Result := FAutoCommit;
end;

procedure TibSHDMLOptions.SetAutoCommit(Value: Boolean);
begin
  FAutoCommit := Value;
end;

function TibSHDMLOptions.GetShowDB_KEY: Boolean;
begin
  Result := ShowDB_KEY;
end;

procedure TibSHDMLOptions.SetShowDB_KEY(Value: Boolean);
begin
  ShowDB_KEY := Value;
end;

function TibSHDMLOptions.GetUseDB_KEY: Boolean;
begin
  Result := UseDB_KEY;
end;

procedure TibSHDMLOptions.SetUseDB_KEY(Value: Boolean);
begin
  UseDB_KEY := Value;
end;

function TibSHDMLOptions.GetConfirmEndTransaction: string;
begin
  Result := ConfirmEndTransaction;
end;

procedure TibSHDMLOptions.SetConfirmEndTransaction(Value: string);
begin
  ConfirmEndTransaction := Value;
end;

function TibSHDMLOptions.GetDefaultTransactionAction: string;
begin
  Result := DefaultTransactionAction;
end;

procedure TibSHDMLOptions.SetDefaultTransactionAction(Value: string);
begin
  DefaultTransactionAction := Value;
end;

function TibSHDMLOptions.GetIsolationLevel: string;
begin
  Result := FIsolationLevel;
end;

procedure TibSHDMLOptions.SetIsolationLevel(Value: string);
begin
  FIsolationLevel := Value;
end;

function TibSHDMLOptions.GetTransactionParams: TStrings;
begin
  Result := FTransactionParams;
end;

procedure TibSHDMLOptions.SetTransactionParams(Value: TStrings);
begin
  FTransactionParams.Assign(Value);
end;

constructor TibSHDMLOptions.Create;
begin
  inherited Create;
  FTransactionParams := TStringList.Create;
end;

destructor TibSHDMLOptions.Destroy;
begin
  FTransactionParams.Free;
  inherited;
end;

{ TibSHDatabaseAliasOptionsInt }

constructor TibSHDatabaseAliasOptionsInt.Create;
begin
  inherited Create;
  FFilterList := TStringList.Create;
  FFilterIndex := -1;

  FDMLHistoryActive := True;
  FDMLHistoryMaxCount := 0;
  FDMLHistorySelect := True;
  FDMLHistoryInsert := True;
  FDMLHistoryUpdate := True;
  FDMLHistoryDelete := True;
  FDMLHistoryExecute := True;

  FDDLHistoryActive := True;
end;

destructor TibSHDatabaseAliasOptionsInt.Destroy;
begin
  FFilterList.Free;
  inherited Destroy;
end;

function TibSHDatabaseAliasOptionsInt.GetFilterList: TStrings;
begin
  Result := FFilterList;
end;

procedure TibSHDatabaseAliasOptionsInt.SetFilterList(Value: TStrings);
begin
  FFilterList.Assign(Value);
end;

function TibSHDatabaseAliasOptionsInt.GetFilterIndex: Integer;
begin
  Result := FFilterIndex;
end;

procedure TibSHDatabaseAliasOptionsInt.SetFilterIndex(Value: Integer);
begin
  FFilterIndex := Value;
end;

function TibSHDatabaseAliasOptionsInt.GetDMLHistoryActive: Boolean;
begin
  Result := FDMLHistoryActive;
end;

procedure TibSHDatabaseAliasOptionsInt.SetDMLHistoryActive(
  const Value: Boolean);
begin
  FDMLHistoryActive := Value;
end;

function TibSHDatabaseAliasOptionsInt.GetDMLHistoryMaxCount: Integer;
begin
  Result := FDMLHistoryMaxCount;
end;

procedure TibSHDatabaseAliasOptionsInt.SetDMLHistoryMaxCount(
  const Value: Integer);
begin
  FDMLHistoryMaxCount := Value;
end;

function TibSHDatabaseAliasOptionsInt.GetDMLHistorySelect: Boolean;
begin
  Result := FDMLHistorySelect;
end;

procedure TibSHDatabaseAliasOptionsInt.SetDMLHistorySelect(
  const Value: Boolean);
begin
  FDMLHistorySelect := Value;
end;

function TibSHDatabaseAliasOptionsInt.GetDMLHistoryInsert: Boolean;
begin
  Result := FDMLHistoryInsert;
end;

procedure TibSHDatabaseAliasOptionsInt.SetDMLHistoryInsert(
  const Value: Boolean);
begin
  FDMLHistoryInsert := Value;
end;

function TibSHDatabaseAliasOptionsInt.GetDMLHistoryUpdate: Boolean;
begin
  Result := FDMLHistoryUpdate;
end;

procedure TibSHDatabaseAliasOptionsInt.SetDMLHistoryUpdate(
  const Value: Boolean);
begin
  FDMLHistoryUpdate := Value;
end;

function TibSHDatabaseAliasOptionsInt.GetDMLHistoryDelete: Boolean;
begin
  Result := FDMLHistoryDelete;
end;

procedure TibSHDatabaseAliasOptionsInt.SetDMLHistoryDelete(
  const Value: Boolean);
begin
  FDMLHistoryDelete := Value;
end;

function TibSHDatabaseAliasOptionsInt.GetDMLHistoryExecute: Boolean;
begin
  Result := FDMLHistoryExecute;
end;

procedure TibSHDatabaseAliasOptionsInt.SetDMLHistoryExecute(
  const Value: Boolean);
begin
  FDMLHistoryExecute := Value;
end;

function TibSHDatabaseAliasOptionsInt.GetDMLHistoryCrash: Boolean;
begin
  Result := FDMLHistoryCrash;
end;

procedure TibSHDatabaseAliasOptionsInt.SetDMLHistoryCrash(
  const Value: Boolean);
begin
  FDMLHistoryCrash := Value;
end;

function TibSHDatabaseAliasOptionsInt.GetDDLHistoryActive: Boolean;
begin
  Result := FDDLHistoryActive;
end;

procedure TibSHDatabaseAliasOptionsInt.SetDDLHistoryActive(
  const Value: Boolean);
begin
  FDDLHistoryActive := Value;
end;

end.
