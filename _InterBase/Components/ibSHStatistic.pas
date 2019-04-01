unit ibSHStatistic;

interface

uses
  Classes, SysUtils,
  SHDesignIntf, ibSHDesignIntf, ibSHDriverIntf, ibSHMessages, ibSHValues;

type
  TibBTStatistics = class(TSHComponent, IibSHStatistics)
  private
    FDatabase: IibSHDatabase;
    FDRVStatistics: TSHComponent;
    FTimeStatistics: IibSHDRVExecTimeStatistics;
  protected
    {IibSHStatistic}
    function GetDatabase: IibSHDatabase;
    procedure SetDatabase(const Value: IibSHDatabase);
    function GetDRVStatistics: IibSHDRVStatistics;
    function GetDRVTimeStatistics: IibSHDRVExecTimeStatistics;
    procedure SetDRVTimeStatistics(const Value: IibSHDRVExecTimeStatistics);

    function TableStatisticsStr(AIncludeSystemTables: Boolean): string;
    function ExecuteTimeStatisticsStr: string;

    procedure StartCollection;
    procedure CalculateStatistics;
  public
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    property Statistics: IibSHDRVStatistics read GetDRVStatistics;

  end;



implementation

procedure Register;
begin
  SHRegisterComponents([TibBTStatistics]);
end;

{ TibBTStatistic }

function TibBTStatistics.GetDatabase: IibSHDatabase;
begin
  Result := FDatabase;
end;

procedure TibBTStatistics.SetDatabase(const Value: IibSHDatabase);
var
  vComponentClass: TSHComponentClass;
begin
  if FDatabase <> Value then
  begin
    ReferenceInterface(FDatabase, opRemove);
    if Assigned(FDRVStatistics) then FDRVStatistics.Free;
    FDatabase := Value;
    if Assigned(FDatabase) and Assigned(FDatabase.BTCLServer) then
    begin
      ReferenceInterface(FDatabase, opInsert);
      vComponentClass := Designer.GetComponent(FDatabase.BTCLServer.DRVNormalize(IibSHDRVStatistics));
      if Assigned(vComponentClass) then
        FDRVStatistics := vComponentClass.Create(Self);
      Statistics.Database := FDatabase.DRVQuery.Database;
    end;
  end;
end;

function TibBTStatistics.GetDRVStatistics: IibSHDRVStatistics;
begin
  Supports(FDRVStatistics, IibSHDRVStatistics, Result);
end;

function TibBTStatistics.GetDRVTimeStatistics: IibSHDRVExecTimeStatistics;
begin
  Result := FTimeStatistics;
end;

procedure TibBTStatistics.SetDRVTimeStatistics(
  const Value: IibSHDRVExecTimeStatistics);
begin
  if FTimeStatistics <> Value then
  begin
    ReferenceInterface(FTimeStatistics, opRemove);
    FTimeStatistics := Value;
    ReferenceInterface(FTimeStatistics, opInsert);
  end;
end;

function TibBTStatistics.TableStatisticsStr(
  AIncludeSystemTables: Boolean): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Pred(Statistics.TablesCount) do
  begin
    if (not AIncludeSystemTables) and (Pos('RDB$', Statistics.TableStatistics[I].TableName) = 1) then Continue;
    if (Statistics.TableStatistics[I].Inserts > 0) then
      Result := Result + Format(SStatisticInserted, [Statistics.TableStatistics[I].TableName, FormatFloat('###,###,###,###', Statistics.TableStatistics[I].Inserts)]) + sLineBreak;
  end;

  for I := 0 to Pred(Statistics.TablesCount) do
  begin
    if (not AIncludeSystemTables) and (Pos('RDB$', Statistics.TableStatistics[I].TableName) = 1) then Continue;
    if Statistics.TableStatistics[I].Updates > 0 then
      Result := Result + Format(SStatisticUpdated, [Statistics.TableStatistics[I].TableName, FormatFloat('###,###,###,###', Statistics.TableStatistics[I].Updates)]) + sLineBreak;
  end;
  for I := 0 to Pred(Statistics.TablesCount) do
  begin
    if (not AIncludeSystemTables) and (Pos('RDB$', Statistics.TableStatistics[I].TableName) = 1) then Continue;
    if Statistics.TableStatistics[I].Deletes > 0 then
      Result := Result + Format(SStatisticDeleted, [Statistics.TableStatistics[I].TableName, FormatFloat('###,###,###,###', Statistics.TableStatistics[I].Deletes)]) + sLineBreak;
  end;
  {
  for I := 0 to Pred(Statistics.TablesCount) do
  begin
    if (not AIncludeSystemTables) and (Pos('RDB$', Statistics.TableStatistics[I].TableName) = 1) then Continue;
    if Statistics.TableStatistics[I].IdxReads > 0 then
      Result := Result + Format(SStatisticIndexedRead, [Statistics.TableStatistics[I].TableName, FormatFloat('###,###,###,###', Statistics.TableStatistics[I].IdxReads)]) + sLineBreak;
  end;
  for I := 0 to Pred(Statistics.TablesCount) do
  begin
    if (not AIncludeSystemTables) and (Pos('RDB$', Statistics.TableStatistics[I].TableName) = 1) then Continue;
    if Statistics.TableStatistics[I].SeqReads > 0 then
      Result := Result + Format(SStatisticNonIndexedRead, [Statistics.TableStatistics[I].TableName, FormatFloat('###,###,###,###', Statistics.TableStatistics[I].SeqReads)]) + sLineBreak;
  end;
  Result := TrimRight(Result);
  }
//  if Length(Result) > 0 then Result := sLineBreak + Result;
end;

function TibBTStatistics.ExecuteTimeStatisticsStr: string;
begin
  Result := '';
  if Assigned(FTimeStatistics) then
  begin
    {
    Result := Result + SPrepare + ':' + msToStr(FTimeStatistics.PrepareTime) + sLineBreak;
    Result := Result + SExecute + ':' + msToStr(FTimeStatistics.ExecuteTime) + sLineBreak;
    Result := Result + SFetch + ':' + msToStr(FTimeStatistics.FetchTime);
    }
    Result := Result + SPrepare + ':' + msToStr(FTimeStatistics.PrepareTime) + '  ';
    Result := Result + SExecute + ':' + msToStr(FTimeStatistics.ExecuteTime) + '  ';
    Result := Result + SFetch + ':' + msToStr(FTimeStatistics.FetchTime);
  end;
end;

procedure TibBTStatistics.StartCollection;
begin
  Statistics.StartCollection;
end;

procedure TibBTStatistics.CalculateStatistics;
begin
  Statistics.CalculateStatistics;
end;

procedure TibBTStatistics.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent.IsImplementorOf(FDatabase) then FDatabase := nil;
    if AComponent.IsImplementorOf(FTimeStatistics) then FTimeStatistics := nil;
  end;
end;

initialization

  Register;

end.
 
