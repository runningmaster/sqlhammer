unit ibSHTableStatisticCalculator;

interface

uses
  Windows, Messages, SysUtils, Classes, Contnrs, 
  pFIBProps, FIBQuery, pFIBQuery, FIBDatabase, pFIBDatabase,
  FIBDataSet, pFIBDataSet, fib, ibase,

  ibSHTableStatisticClasses;

type

  TibBTTableStatisticCalculator = class(TComponent)
  private
    FCurrentStatisticList: TTablesStatisticList;
    FDeltaStatisticList: TTablesStatisticList;
    FDatabase: TpFIBDatabase;
//    FProcessing: Boolean;
    function GetDatabase: TpFIBDatabase;
    procedure SetDatabase(const Value: TpFIBDatabase);
    function GetCurrentStatisticList: TTablesStatisticList;
    function GetDeltaStatisticList: TTablesStatisticList;
  protected
    procedure FillTableNames;
    procedure InternalStartCounting(ATablesStatisticList: TTablesStatisticList);
    procedure NormilizeDelta;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure StartCounting;
    procedure CaclDelta;
    procedure SetNull;
    property CurrentStatisticList: TTablesStatisticList read GetCurrentStatisticList;
    property DeltaStatisticList: TTablesStatisticList read GetDeltaStatisticList;

    property Database: TpFIBDatabase read GetDatabase write SetDatabase;
  end;


implementation

uses Math;

{ TStatisticSnapshot }

procedure TibBTTableStatisticCalculator.CaclDelta;
var
  vTableStatistic: TTableStatistic;
  I: Integer;
begin
  InternalStartCounting(FCurrentStatisticList);
  FillTableNames;
  for I := 0 to FCurrentStatisticList.Count - 1 do
  begin
    vTableStatistic := FDeltaStatisticList.StatisticByRelationID[StrToInt(FCurrentStatisticList[I])];
    if not Assigned(vTableStatistic) then
    begin
      vTableStatistic := TTableStatistic.CreateAsClone(nil, FCurrentStatisticList.Statistics[I]);
      FDeltaStatisticList.AddObject(FCurrentStatisticList[I], vTableStatistic);
    end
    else
//      with FCurrentStatisticList.Statistics[I] do
      begin
        vTableStatistic.IdxReads := FCurrentStatisticList.Statistics[I].IdxReads - vTableStatistic.IdxReads;
        vTableStatistic.SeqReads := FCurrentStatisticList.Statistics[I].SeqReads - vTableStatistic.SeqReads;
        vTableStatistic.Inserts := FCurrentStatisticList.Statistics[I].Inserts - vTableStatistic.Inserts;
        vTableStatistic.Updates := FCurrentStatisticList.Statistics[I].Updates - vTableStatistic.Updates;
        vTableStatistic.Deletes := FCurrentStatisticList.Statistics[I].Deletes - vTableStatistic.Deletes;

        vTableStatistic.Backout := FCurrentStatisticList.Statistics[I].Backout - vTableStatistic.Backout;
        vTableStatistic.Expunge := FCurrentStatisticList.Statistics[I].Expunge - vTableStatistic.Expunge;
        vTableStatistic.Purge := FCurrentStatisticList.Statistics[I].Purge - vTableStatistic.Purge;

        vTableStatistic.TableName := FCurrentStatisticList.Statistics[I].TableName;
      end;
  end;
  FDeltaStatisticList.ClearNulls;
  NormilizeDelta;
//  FProcessing := False;
end;

constructor TibBTTableStatisticCalculator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCurrentStatisticList := TTablesStatisticList.Create;
  FDeltaStatisticList := TTablesStatisticList.Create;
//  FMaxDeltaValue := 0;
//  FMaxGarbageValue := 0;
//  FProcessing := False;
end;

destructor TibBTTableStatisticCalculator.Destroy;
begin
  FCurrentStatisticList.Free;
  FDeltaStatisticList.Free;
  inherited;
end;

procedure TibBTTableStatisticCalculator.Notification(
  AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
//  if Operation = opRemove then
//  begin
//    if AComponent = FDatabase then FDatabase := nil;
//  end;
end;

procedure TibBTTableStatisticCalculator.FillTableNames;
var
  I: Integer;
begin
  if Assigned(Database) then
    for I := 0 to FCurrentStatisticList.Count - 1 do
      with FCurrentStatisticList.Statistics[I] do
        if TableName = '' then
          TableName := Trim(Database.QueryValue('SELECT RDB$RELATION_NAME FROM RDB$RELATIONS WHERE RDB$RELATION_ID = :RELATION_ID', 0, [FCurrentStatisticList[I]]));
end;

function TibBTTableStatisticCalculator.GetCurrentStatisticList: TTablesStatisticList;
begin
  Result := FCurrentStatisticList;
end;

function TibBTTableStatisticCalculator.GetDatabase: TpFIBDatabase;
begin
  Result := FDatabase;
end;

procedure TibBTTableStatisticCalculator.SetDatabase(
  const Value: TpFIBDatabase);
begin
  if FDatabase <> Value then
  begin
//    RemoveFreeNotification(FDatabase);
    FDatabase := Value;
//    FreeNotification(FDatabase);
  end;
end;

function TibBTTableStatisticCalculator.GetDeltaStatisticList: TTablesStatisticList;
begin
//  if FProcessing then CaclDelta;
  Result := FDeltaStatisticList;
end;

procedure TibBTTableStatisticCalculator.InternalStartCounting(
  ATablesStatisticList: TTablesStatisticList);
var
  I: Integer;
  vRelationID: string;
  vOperationCount: Integer;
  procedure PharseRecord(const ARec: string);
  var
    P: Integer;
  begin
    P := AnsiPos('=', ARec);
    if P <> 0 then
    begin
      vRelationID := copy(ARec, 1, P - 1);
      vOperationCount := StrToInt(copy(ARec, P + 1, MaxInt));
    end
    else
    begin
      vRelationID := '-1';
      vOperationCount := 0;
    end
  end;
begin
  ATablesStatisticList.SetAllNull;
  if not Assigned(Database) then Exit;
  for I := 0 to Database.UpdateCount.Count - 1 do
  begin
    PharseRecord(Database.UpdateCount[I]);
    ATablesStatisticList.ForceTableStatistic(vRelationID).Updates := vOperationCount;
  end;
  for I := 0 to Database.DeleteCount.Count - 1 do
  begin
    PharseRecord(Database.DeleteCount[I]);
    ATablesStatisticList.ForceTableStatistic(vRelationID).Deletes := vOperationCount;
  end;
  for I := 0 to Database.InsertCount.Count - 1 do
  begin
    PharseRecord(Database.InsertCount[I]);
    ATablesStatisticList.ForceTableStatistic(vRelationID).Inserts := vOperationCount;
  end;
  for I := 0 to Database.ReadIdxCount.Count - 1 do
  begin
    PharseRecord(Database.ReadIdxCount[I]);
    ATablesStatisticList.ForceTableStatistic(vRelationID).IdxReads := vOperationCount;
  end;
  for I := 0 to Database.ReadSeqCount.Count - 1 do
  begin
    PharseRecord(Database.ReadSeqCount[I]);
    ATablesStatisticList.ForceTableStatistic(vRelationID).SeqReads := vOperationCount;
  end;

  for I := 0 to Database.BackoutCount.Count - 1 do
  begin
    PharseRecord(Database.BackoutCount[I]);
    ATablesStatisticList.ForceTableStatistic(vRelationID).Backout := vOperationCount;
  end;
  for I := 0 to Database.ExpungeCount.Count - 1 do
  begin
    PharseRecord(Database.ExpungeCount[I]);
    ATablesStatisticList.ForceTableStatistic(vRelationID).Expunge := vOperationCount;
  end;
  for I := 0 to Database.PurgeCount.Count - 1 do
  begin
    PharseRecord(Database.PurgeCount[I]);
    ATablesStatisticList.ForceTableStatistic(vRelationID).Purge := vOperationCount;
  end;
  ATablesStatisticList.ClearNulls;
end;

procedure TibBTTableStatisticCalculator.NormilizeDelta;
var
  I: Integer;
  MaxValue: Integer;
  MaxGarpage: Integer;
begin
  MaxValue := 0;
  MaxGarpage := 0;
  for I := 0 to FDeltaStatisticList.Count - 1 do
  begin
    with FDeltaStatisticList.Statistics[I] do
    begin
//      if not (Owner as TBTCustomDatabase).ShowSystemObjects then
//         if Pos('RDB$', TableName) = 1 then continue;
      MaxValue := Max(MaxValue, IdxReads);
      MaxValue := Max(MaxValue, SeqReads);
      MaxValue := Max(MaxValue, Updates);
      MaxValue := Max(MaxValue, Inserts);
      MaxValue := Max(MaxValue, Deletes);

      MaxGarpage := Max(MaxGarpage, Backout);
      MaxGarpage := Max(MaxGarpage, Expunge);
      MaxGarpage := Max(MaxGarpage, Purge);
    end;
  end;

  FDeltaStatisticList.MaxDeltaValue := MaxValue;
  FDeltaStatisticList.MaxGarbageValue := MaxGarpage;
//  FMaxDeltaValue := MaxValue;
//  FMaxGarbageValue := MaxGarpage;
{
  for I := 0 to FDeltaStatisticList.Count - 1 do
    with FDeltaStatisticList.Statistics[I] do
    begin
      IdxReads := Round(100*(IdxReads/MaxValue));
      SeqReads := Round(100*(SeqReads/MaxValue));
      Updates := Round(100*(Updates/MaxValue));
      Inserts := Round(100*(Inserts/MaxValue));
      Deletes := Round(100*(Deletes/MaxValue));
    end;
}
end;

procedure TibBTTableStatisticCalculator.SetNull;
begin
//  FProcessing := False;
  FCurrentStatisticList.SetAllNull;
  FDeltaStatisticList.SetAllNull;
end;

procedure TibBTTableStatisticCalculator.StartCounting;
begin
  InternalStartCounting(FDeltaStatisticList);
end;



end.
