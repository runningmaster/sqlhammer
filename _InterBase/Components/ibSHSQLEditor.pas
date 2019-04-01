unit ibSHSQLEditor;

interface

uses
  SysUtils, Classes, Contnrs, Dialogs, Types, Forms, Controls,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDriverIntf, ibSHMessages, ibSHTool, ibSHValues,
  pSHIntf, pSHSqlTxtRtns, pSHStrUtil;


type
  TibSHSQLEditor = class(TibBTTool, IibSHSQLEditor, IibSHDDLInfo,
    IibSHBranch, IfbSHBranch)
  private
    FSQL: TStrings;
    FDDL: TStrings;
    FAutoCommit: Boolean;
    FExecuteSelected: Boolean;
    FRetrievePlan: Boolean;
    FRetrieveStatistics: Boolean;
    FAfterExecute: string;
    FRecordCount: Integer;
    FResultType: string;
    FThreadResults: Boolean;
    FIsolationLevel: string;
    FTransactionParams: TStringList;
    FData: TSHComponent;
    function GetSQL: TStrings;
    procedure SetSQL(Value: TStrings);
    function GetDDL: TStrings;
    procedure SetDDL(Value: TStrings);
    {IibSHSQLEditor, IibSHDDLInfo}
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

    function GetData: IibSHData;
    function GetStatistics: IibSHStatistics;

  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
    procedure SetOwnerIID(Value: TGUID); override;
    function GetState: TSHDBComponentState;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    property ThreadResults: Boolean read GetThreadResults write SetThreadResults;
    property ResultType: string read GetResultType write SetResultType;
    property AfterExecute: string read GetAfterExecute write SetAfterExecute;

    property SQL: TStrings read GetSQL write SetSQL;
    property DDL: TStrings read GetDDL write SetDDL;
    property Data: IibSHData read GetData;
    property Statistics: IibSHStatistics read GetStatistics;
    property AutoCommit: Boolean read GetAutoCommit write SetAutoCommit;    
  published
    property RetrievePlan: Boolean read GetRetrievePlan write SetRetrievePlan;
    property RetrieveStatistics: Boolean read GetRetrieveStatistics write SetRetrieveStatistics;
//    property AutoCommit: Boolean read GetAutoCommit write SetAutoCommit;
    property ExecuteSelected: Boolean read GetExecuteSelected write SetExecuteSelected;
//    property ResultType: string read GetResultType write SetResultType;
//    property AfterExecute: string read GetAfterExecute write SetAfterExecute;
    property IsolationLevel: string read GetIsolationLevel write SetIsolationLevel;
    property TransactionParams: TStrings read GetTransactionParams write SetTransactionParams;
//    property ThreadResults: Boolean read GetThreadResults write SetThreadResults;
  end;

  TibSHSQLEditorFactory = class(TibBTToolFactory)
  end;

procedure Register();

implementation

uses
  ibSHConsts, ibSHSQLs,
  ibSHSQLEditorActions,
  ibSHSQLEditorEditors;

procedure Register();
begin
  SHRegisterImage(GUIDToString(IibSHSQLEditor), 'SQLEditor.bmp');
  SHRegisterImage(TibSHSQLEditorPaletteAction.ClassName, 'SQLEditor.bmp');

  SHRegisterImage(TibSHSQLEditorFormAction_SQLText.ClassName,         'Form_DMLText.bmp');
  SHRegisterImage(TibSHSQLEditorFormAction_QueryResults.ClassName,    'Form_Data_Grid.bmp');
  SHRegisterImage(TibSHSQLEditorFormAction_BlobEditor.ClassName,      'Form_Data_Blob.bmp');
  SHRegisterImage(TibSHSQLEditorFormAction_DataForm.ClassName,        'Form_Data_VCL.bmp');
  SHRegisterImage(TibSHSQLEditorFormAction_QueryStatistics.ClassName, 'Form_QueryStatistics.bmp');
  SHRegisterImage(TibSHSQLEditorFormAction_DDLText.ClassName,         'Form_DDLText.bmp');

  SHRegisterImage(TibSHSQLEditorToolbarAction_PrevQuery.ClassName,      'Button_Query_Prev.bmp');
  SHRegisterImage(TibSHSQLEditorToolbarAction_NextQuery.ClassName,      'Button_Query_Next.bmp');
  SHRegisterImage(TibSHSQLEditorToolbarAction_Run.ClassName,            'Button_Run.bmp');
  SHRegisterImage(TibSHSQLEditorToolbarAction_RunAndFetchAll.ClassName, 'Button_RunAndFetch.bmp');
  SHRegisterImage(TibSHSQLEditorToolbarAction_Prepare.ClassName,        'Button_RunPrepare.bmp');
  SHRegisterImage(TibSHSQLEditorToolbarAction_Commit.ClassName,         'Button_TrCommit.bmp');
  SHRegisterImage(TibSHSQLEditorToolbarAction_Rollback.ClassName,       'Button_TrRollback.bmp');

  SHRegisterImage(SCallStatistics, 'Form_QueryStatistics.bmp');

  SHRegisterComponents([
    TibSHSQLEditor,
    TibSHSQLEditorFactory]);

  SHRegisterActions([
    TibSHSQLEditorPaletteAction,

    TibSHSQLEditorFormAction_SQLText,
    TibSHSQLEditorFormAction_QueryResults,
    TibSHSQLEditorFormAction_DataForm,
    TibSHSQLEditorFormAction_BlobEditor,
    TibSHSQLEditorFormAction_QueryStatistics,
    TibSHSQLEditorFormAction_DDLText,

//    TibSHSQLEditorToolbarAction_,
    TibSHSQLEditorToolbarAction_Run,
    TibSHSQLEditorToolbarAction_RunAndFetchAll,
//    TibSHSQLEditorToolbarAction_,
    TibSHSQLEditorToolbarAction_Prepare,
//    TibSHSQLEditorToolbarAction_EndTransactionSeparator,
    TibSHSQLEditorToolbarAction_Commit,
    TibSHSQLEditorToolbarAction_Rollback,
    TibSHSQLEditorToolbarAction_PrevQuery,
    TibSHSQLEditorToolbarAction_NextQuery]);

  SHRegisterActions([
    TibSHSQLEditorEditorAction_LoadLastContext,
    TibSHSQLEditorEditorAction_RecordCount,
    TibSHSQLEditorEditorAction_CreateNew]);

  SHRegisterPropertyEditor(IibSHSQLEditor, SCallAfterExecute, TibBTAfterExecutePropEditor);
  SHRegisterPropertyEditor(IibSHSQLEditor, SCallResultType, TibBTResultTypePropEditor);
  SHRegisterPropertyEditor(IibSHSQLEditor, SCallIsolationLevel, TibBTIsolationLevelPropEditor);
end;

{ TibSHSQLEditor }

constructor TibSHSQLEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSQL := TStringList.Create;
  FDDL := TStringList.Create;
  FExecuteSelected := True;
  FRetrievePlan := True;
  FRetrieveStatistics := True;
  FAfterExecute :=  Format('%s', [AfterExecutes[1]]);
  FResultType := Format('%s', [ResultTypes[0]]);
  FTransactionParams := TStringList.Create;
  FRecordCount := -2;
end;

destructor TibSHSQLEditor.Destroy;
begin
  FSQL.Free;
  FDDL.Free;
  if Assigned(FData) then FData.Free;
  inherited Destroy;
end;

function TibSHSQLEditor.GetSQL: TStrings;
begin
  Result := FSQL;
end;

procedure TibSHSQLEditor.SetSQL(Value: TStrings);
begin
  FSQL.Assign(Value);
end;

function TibSHSQLEditor.GetDDL: TStrings;
begin
  Result := FDDL;
end;

procedure TibSHSQLEditor.SetDDL(Value: TStrings);
begin
  FDDL.Assign(Value);
end;

function TibSHSQLEditor.GetAutoCommit: Boolean;
begin
  Result := FAutoCommit;
end;

procedure TibSHSQLEditor.SetAutoCommit(Value: Boolean);
var
  I: Integer;
  vSQLEditorForm: IibSHSQLEditorForm;
  vMsg: string;
begin
  if FAutoCommit <> Value then
  begin
    if Data.Transaction.InTransaction then
    begin
      if Data.Dataset.Active then
        vMsg := SCloseResult
      else
        vMsg := SCommitTransaction;
      if Designer.ShowMsg(vMsg, mtConfirmation) then
      begin
        Data.Transaction.Commit;
        for I := 0 to Pred(ComponentForms.Count) do
          if Supports(ComponentForms[I], IibSHSQLEditorForm, vSQLEditorForm) then
          begin
            vSQLEditorForm.ShowTransactionCommited;
            Break;
          end;
      end
      else
        Exit;
    end;
    if Value then
    begin
      MakePropertyInvisible('IsolationLevel');
      MakePropertyInvisible('TransactionParams');
    end
    else
    begin
      MakePropertyVisible('IsolationLevel');
      if AnsiSameText(IsolationLevel, IsolationLevels[4]) then
        MakePropertyVisible('TransactionParams');
    end;
    FAutoCommit := Value;
    Designer.UpdateObjectInspector;
  end;
end;

function TibSHSQLEditor.GetExecuteSelected: Boolean; deprecated;
begin
  Result := FExecuteSelected;
end;

procedure TibSHSQLEditor.SetExecuteSelected(Value: Boolean); deprecated;
begin
  FExecuteSelected := Value;
end;

function TibSHSQLEditor.GetRetrievePlan: Boolean;
begin
  Result := FRetrievePlan;
end;

procedure TibSHSQLEditor.SetRetrievePlan(Value: Boolean);
begin
  FRetrievePlan := Value;
end;

function TibSHSQLEditor.GetAfterExecute: string;
begin
  Result := FAfterExecute;
end;

function TibSHSQLEditor.GetRetrieveStatistics: Boolean;
begin
  Result := FRetrieveStatistics;
end;

procedure TibSHSQLEditor.SetRetrieveStatistics(Value: Boolean);
begin
  FRetrieveStatistics := Value and Assigned(Statistics);
end;

procedure TibSHSQLEditor.SetAfterExecute(Value: string);
begin
  FAfterExecute := Value;
end;

function TibSHSQLEditor.GetRecordCountFrmt: string;
begin
  case FRecordCount of
    -2: Result := EmptyStr;
    -1: Result := Format('%s', [SCantCountRecords]);
     0: Result := Format('%s', [SEmpty]);
     else
        Result := FormatFloat('###,###,###,###', FRecordCount);
  end;
end;

function TibSHSQLEditor.GetResultType: string;
begin
  Result := FResultType;
end;

procedure TibSHSQLEditor.SetResultType(Value: string);
begin
  FResultType := Value;
end;

function TibSHSQLEditor.GetThreadResults: Boolean;
begin
  Result := FThreadResults;
end;

procedure TibSHSQLEditor.SetThreadResults(Value: Boolean);
begin
  FThreadResults := Value;
end;

function TibSHSQLEditor.GetIsolationLevel: string;
begin
  Result := FIsolationLevel;
end;

procedure TibSHSQLEditor.SetIsolationLevel(Value: string);
begin
  if not AnsiSameText(FIsolationLevel, Value) then
  begin
    if not AnsiSameText(Value, IsolationLevels[4]) then
    begin
      MakePropertyInvisible('TransactionParams');
    end
    else
    begin
      MakePropertyVisible('TransactionParams');
    end;
    FIsolationLevel := Value;
    Designer.UpdateObjectInspector;
  end;
end;

function TibSHSQLEditor.GetTransactionParams: TStrings;
begin
  Result := FTransactionParams;
end;

procedure TibSHSQLEditor.SetTransactionParams(Value: TStrings);
begin
  if Assigned(Value) and  not AnsiSameText(FTransactionParams.Text, Value.Text) then
    FTransactionParams.Assign(Value);
end;

procedure TibSHSQLEditor.SetRecordCount;
var
  vSQLEditorForm: IibSHSQLEditorForm;
  vSQLText: string;
  vFromClauseCoord: TPoint;
  S: string;

  vDRVParams: IibSHDRVParams;
  vInputParameters: IibSHInputParameters;
  vCanContinue: Boolean;
  vComponentClass: TSHComponentClass;
  vComponent: TSHComponent;
begin

  FRecordCount := -1;
  if GetComponentFormIntf(IibSHSQLEditorForm, vSQLEditorForm) then
  begin
    vSQLText := vSQLEditorForm.SQLText;

    if Supports(BTCLDatabase.DRVDatabase,IibSHDRVDatabaseExt) then
     s:= (BTCLDatabase.DRVDatabase as IibSHDRVDatabaseExt).GetRecordCountSelect(vSQLText)
    else
    begin
     if (Length(vSQLText) > 0) and
      (PosExtCI('DISTINCT', vSQLText, CharsBeforeClause,CharsAfterClause) = 0)
      and
     (PosExtCI('UNION', vSQLText, CharsBeforeClause,CharsAfterClause) = 0)
     then
     begin
      vFromClauseCoord := DispositionFrom(vSQLText);
      S := Copy(vSQLText, vFromClauseCoord.X, MaxInt);
      S :=Format(FormatSQL(SQL_GET_RECORD_COUNT_FROM_SQL_TEXT), [S]);
     end
     else
      s:='';
    end;
    if S<>'' then
    begin
      BTCLDatabase.DRVQuery.SQL.Text :=S;
      vComponentClass := Designer.GetComponent(IibSHInputParameters);
      vCanContinue := False;
      if Assigned(vComponentClass) and Supports(BTCLDatabase.DRVQuery, IibSHDRVParams, vDRVParams) then
      begin
        vComponent := vComponentClass.Create(nil);
        try
          if Supports(vComponent, IibSHInputParameters, vInputParameters) then
          begin
            vCanContinue := vInputParameters.InputParameters(vDRVParams);
            vInputParameters := nil;
          end;
        finally
          FreeAndNil(vComponent);
        end;
        vDRVParams := nil;
      end;
      if vCanContinue then
      begin
        try
          Screen.Cursor := crHourGlass;
          //if BTCLDatabase.DRVQuery.ExecSQL(, [], False) then
          if not BTCLDatabase.DRVQuery.Transaction.InTransaction then
            BTCLDatabase.DRVQuery.Transaction.StartTransaction;
          BTCLDatabase.DRVQuery.Execute;
          FRecordCount := BTCLDatabase.DRVQuery.GetFieldIntValue(0);
        finally
          BTCLDatabase.DRVQuery.Transaction.Commit;
          Screen.Cursor := crDefault;
        end;
      end;
    end;
  end;
end;

function TibSHSQLEditor.GetData: IibSHData;
begin
  Supports(FData, IibSHData, Result);
end;

function TibSHSQLEditor.GetStatistics: IibSHStatistics;
begin
  Supports(FData, IibSHStatistics, Result);
end;

function TibSHSQLEditor.QueryInterface(const IID: TGUID; out Obj): HResult;
var
  vStatistics: IibSHStatistics;
begin
  if IsEqualGUID(IID, IibSHStatistics) and Assigned(Data)  then
  begin
    if Supports(Data, IibSHStatistics, vStatistics) then
      IInterface(Obj) := vStatistics;
    if Pointer(Obj) <> nil then
      Result := S_OK
    else
      Result := E_NOINTERFACE;
  end
  else
  if IsEqualGUID(IID, IibSHData) and Assigned(Data)  then
  begin
    IInterface(Obj) := Data;
    if Pointer(Obj) <> nil then
      Result := S_OK
    else
      Result := E_NOINTERFACE;
  end
  else
    Result := inherited QueryInterface(IID, Obj);
end;

procedure TibSHSQLEditor.SetOwnerIID(Value: TGUID);
var
  vComponentClass: TSHComponentClass;
begin
  if not IsEqualGUID(OwnerIID, Value) then
  begin
    inherited SetOwnerIID(Value);
    if Assigned(BTCLDatabase) then
    begin
      if Assigned(FData) then FData.Free;
      vComponentClass := Designer.GetComponent(IibSHData);
      if Assigned(vComponentClass) then
        FData := vComponentClass.Create(Self);
      AutoCommit := BTCLDatabase.DatabaseAliasOptions.DML.AutoCommit;
      IsolationLevel := BTCLDatabase.DatabaseAliasOptions.DML.IsolationLevel;
      TransactionParams := BTCLDatabase.DatabaseAliasOptions.DML.TransactionParams;
    end;
  end;
end;


function TibSHSQLEditor.GetState: TSHDBComponentState;
begin
  Result := csAlter;
end;

procedure TibSHSQLEditor.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;

initialization

  Register;

end.


