unit ibSHData;

interface

uses
  Classes, SysUtils, Forms, Controls,
  SHDesignIntf, ibSHDesignIntf, ibSHDriverIntf, ibSHMessages, ibSHConsts,
  ibSHValues;

type
  TibBTData = class(TSHComponent, IibSHData{, IibSHStatistics})
  private
    FDRVReadTransaction: TSHComponent;
    FDRVWriteTransaction: TSHComponent;
    FDRVDataset: TSHComponent;
    FStatistics: TSHComponent;
    FSQLGenerator: TSHComponent;
    FErrorText: string;
    FReadOnly: Boolean;
    procedure CreateDRV;
    procedure FreeDRV;
    function GetDatabase: IibSHDatabase;
    function GetWriteTransaction: IibSHDRVTransaction;
    function GetSQLGenerator: IibSHSQLGenerator;
    function GetAutoCommit: Boolean;
    function GetSQLEditor: IibSHSQLEditor;
    function GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);
  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
    { IibSHData }
    function GetTransaction: IibSHDRVTransaction;
    function GetDataset: IibSHDRVDataset;
    function GetErrorText: string;

    function Prepare: Boolean;
    function Open: Boolean;
    procedure FetchAll;
    procedure Close;
    procedure Commit;
    procedure Rollback;
    {IibSHStatisticsCollection}
    function GetStatistics: IibSHStatistics;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Database: IibSHDatabase read GetDatabase;
    property ReadTransaction: IibSHDRVTransaction read GetTransaction;
    property WriteTransaction: IibSHDRVTransaction read GetWriteTransaction;
    property Dataset: IibSHDRVDataset read GetDataset;
    property Statistics: IibSHStatistics read GetStatistics;

    property SQLGenerator: IibSHSQLGenerator read GetSQLGenerator;
    property SQLEditor: IibSHSQLEditor read GetSQLEditor;
    property AutoCommit: Boolean read GetAutoCommit;
  end;

implementation

{ TibBTData }

procedure Register;
begin
  SHRegisterComponents([TibBTData]);
end;

constructor TibBTData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateDRV;
  FReadOnly := False;
end;

destructor TibBTData.Destroy;
begin
  FreeDRV;
  inherited Destroy;
end;

procedure TibBTData.CreateDRV;
var
  vComponentClass: TSHComponentClass;
begin
  vComponentClass := Designer.GetComponent(IibSHSQLGenerator);
  if Assigned(vComponentClass) then FSQLGenerator := vComponentClass.Create(nil);
  if Assigned(Database) and Assigned(Database.BTCLServer) then
  begin
    vComponentClass := Designer.GetComponent(Database.BTCLServer.DRVNormalize(IibSHDRVTransaction));
    if Assigned(vComponentClass) then
    begin
      FDRVReadTransaction := vComponentClass.Create(Self);
      ReadTransaction.Params.Text := TRWriteParams;
      ReadTransaction.Database := Database.DRVQuery.Database;
      FDRVWriteTransaction := vComponentClass.Create(Self);
      WriteTransaction.Params.Text := TRWriteParams;
      WriteTransaction.Database := Database.DRVQuery.Database;
    end;
    vComponentClass := Designer.GetComponent(Database.BTCLServer.DRVNormalize(IibSHDRVDataset));
    if Assigned(vComponentClass) then
    begin
      FDRVDataset := vComponentClass.Create(Self);
      Dataset.Database := Database.DRVQuery.Database;
      Dataset.ReadTransaction := ReadTransaction;
    end;
    vComponentClass := Designer.GetComponent(IibSHStatistics);
    if Assigned(vComponentClass) then
    begin
      FStatistics := vComponentClass.Create(Self);
      Statistics.Database := Database;
      if Supports(Dataset, IibSHDRVExecTimeStatistics) then
        Statistics.DRVTimeStatistics := Dataset as IibSHDRVExecTimeStatistics;
    end;
  end;
end;

procedure TibBTData.FreeDRV;
begin
  if Assigned(FDRVReadTransaction) then FDRVReadTransaction.Free;
  if Assigned(FDRVWriteTransaction) then FDRVWriteTransaction.Free;
  if Assigned(FDRVDataset) then FDRVDataset.Free;
  if Assigned(FStatistics) then FStatistics.Free;
  if Assigned(FSQLGenerator) then FSQLGenerator.Free;
end;

function TibBTData.GetDatabase: IibSHDatabase;
begin
  Supports(Owner, IibSHDatabase, Result);
end;

function TibBTData.GetWriteTransaction: IibSHDRVTransaction;
begin
  Supports(FDRVWriteTransaction, IibSHDRVTransaction, Result);
end;

function TibBTData.GetSQLGenerator: IibSHSQLGenerator;
begin
  Supports(FSQLGenerator, IibSHSQLGenerator, Result);
end;

function TibBTData.GetAutoCommit: Boolean;
begin
  if Assigned(SQLEditor) then
    Result := SQLEditor.AutoCommit
  else
    Result := False;
end;

function TibBTData.GetSQLEditor: IibSHSQLEditor;
begin
  Supports(Owner, IibSHSQLEditor, Result);
end;

function TibBTData.GetReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

procedure TibBTData.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
end;

function TibBTData.GetDataset: IibSHDRVDataset;
begin
  Supports(FDRVDataset, IibSHDRVDataset, Result);
end;

function TibBTData.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if IsEqualGUID(IID, IibSHStatistics) then
  begin
    IInterface(Obj) := Statistics;
    if Pointer(Obj) <> nil then
      Result := S_OK
    else
      Result := E_NOINTERFACE;
  end
  else
    Result := inherited QueryInterface(IID, Obj);
end;

function TibBTData.GetTransaction: IibSHDRVTransaction;
begin
  Supports(FDRVReadTransaction, IibSHDRVTransaction, Result);
end;

function TibBTData.GetErrorText: string;
begin
  Result := FErrorText;
end;

function TibBTData.Prepare: Boolean;
var
  I: Integer;
  vSQLEditorForm: IibSHSQLEditorForm;
begin
  Result := True;
  FErrorText := EmptyStr;
  if not Dataset.Prepare then
  begin
    FErrorText := Dataset.ErrorText;
    Result := False;
  end
  else
    if Supports(Owner, IibSHSQLEditor) then
      for I := 0 to Pred((Owner as TSHComponent).ComponentForms.Count) do
        if Supports((Owner as TSHComponent).ComponentForms[I], IibSHSQLEditorForm, vSQLEditorForm) then
        begin
          vSQLEditorForm.ShowPlan;
          Break;
        end;
end;

function TibBTData.Open: Boolean;
var
  vDRVParams: IibSHDRVParams;
  vInputParameters: IibSHInputParameters;
  vCanContinue: Boolean;
  vComponentClass: TSHComponentClass;
  vComponent: TSHComponent;
begin
  Result := False;
  FErrorText := EmptyStr;
  if Assigned(Database) and Assigned(SQLGenerator) then
  begin
    if Database.WasLostConnect then Exit;
    Dataset.Close;
    SQLGenerator.SetAutoGenerateSQLsParams(TSHComponent(Owner));
    //этот вызвов необходим для генерации SELECT для таблицы
    //и для установки параметров автогенерации
    if not ReadTransaction.InTransaction then
    begin
      if AutoCommit then
      begin
        ReadTransaction.Params.Text := TRWriteParams;
        Dataset.WriteTransaction := WriteTransaction;
        Dataset.AutoCommit := True;
      end
      else
      begin
        if Assigned(SQLEditor) then
          ReadTransaction.Params.Text := GetTransactionParams(SQLEditor.IsolationLevel, SQLEditor.TransactionParams.Text);
        Dataset.WriteTransaction := ReadTransaction;
        Dataset.AutoCommit := False;
      end;
      Dataset.ReadTransaction.StartTransaction;
    end;
    try
      if Prepare then
      //В принципе Prepare до ввода параметров не нужно, но это страховка от глюков Буза, есои сиквел окажеться некорректным
      begin
        vCanContinue := True;
        vComponentClass := Designer.GetComponent(IibSHInputParameters);
        if Assigned(vComponentClass) and Supports(Dataset, IibSHDRVParams, vDRVParams) then
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
//          FEnabledFetchEvent := True;
          Screen.Cursor := crHourGlass;
          Dataset.Open;
          FErrorText := Dataset.ErrorText;
          Result := not (Length(Dataset.ErrorText) > 0);
          if Result then
            SQLGenerator.GenerateSQLs(TSHComponent(Owner));
            //этот вызов необходим для генерации RefreshSQL

            //т.к. в BeforePost, BeforeDelete нужно иметь
            //--валидные сиквела  Update и Delete для производства корректной
            //--проверки на MultiUpdate и MultiDelete,
            //--а автогенерация срабатывает после вызова BeforePost, BeforeDelete :(
          Result := Result and (not Database.WasLostConnect);
        end;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TibBTData.FetchAll;
begin
  Dataset.FetchAll;
end;

procedure TibBTData.Close;
begin
  FErrorText := EmptyStr;
  Dataset.Close;
end;

procedure TibBTData.Commit;
begin
  FErrorText := EmptyStr;
  ReadTransaction.Commit;
  FErrorText := ReadTransaction.ErrorText;
end;

procedure TibBTData.Rollback;
begin
  FErrorText := EmptyStr;
  ReadTransaction.Rollback;
  FErrorText := ReadTransaction.ErrorText;
end;

function TibBTData.GetStatistics: IibSHStatistics;
begin
  Supports(FStatistics, IibSHStatistics, Result);
end;

initialization

  Register;

end.
