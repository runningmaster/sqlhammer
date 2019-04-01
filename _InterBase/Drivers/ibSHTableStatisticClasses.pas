unit ibSHTableStatisticClasses;

interface

uses
  Classes, SysUtils,
  SHDesignIntf, ibSHDriverIntf;

type

  TTableStatistic = class(TSHComponent, IibSHDRVTableStatistics)
  private
    FTableName: string;

    FIdxReads: Integer;
    FSeqReads: Integer;
    FUpdates: Integer;
    FInserts: Integer;
    FDeletes: Integer;

    FBackout: Integer;
    FExpunge: Integer;
    FPurge: Integer;
  protected
    {IibSHDRVTableStatistic}
    function GetTableName: string;
    function GetIdxReads: Integer;
    function GetSeqReads: Integer;
    function GetUpdates: Integer;
    function GetInserts: Integer;
    function GetDeletes: Integer;
    function GetBackout: Integer;
    function GetExpunge: Integer;
    function GetPurge: Integer;
  public
   constructor Create(AOwner: TComponent); override;
   constructor CreateAsClone(AOwner: TComponent; ATableStatistic: TTableStatistic);
   procedure CopyFrom(ATableStatistic: TTableStatistic);
   procedure SetAllNull;
   function IsNull: Boolean;
   function IsGarbageNull: Boolean;
   function IsFullyNull: Boolean;
   property TableName: string read FTableName write FTableName;
   property IdxReads: Integer read FIdxReads write FIdxReads;
   property SeqReads: Integer read FSeqReads write FSeqReads;
   property Updates: Integer read FUpdates write FUpdates;
   property Inserts: Integer read FInserts write FInserts;
   property Deletes: Integer read FDeletes write FDeletes;

   property Backout: Integer read FBackout write FBackout;
   property Expunge: Integer read FExpunge write FExpunge;
   property Purge: Integer read FPurge write FPurge;
  end;

  TTablesStatisticList = class(TStringList)
  private
//    FLastUsedRelationID: Integer;
//    FLastUsedIndex: Integer;
    FMaxDeltaValue: Integer;
    FMaxGarbageValue: Integer;
    function GetStatistics(Index: Integer): TTableStatistic;
    function GetStatisticByRelationID(Index: Integer): TTableStatistic;
  protected
    function CompareStrings(const S1, S2: string): Integer; override;
    procedure CloneItem(const S: string; AObject: TTableStatistic);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const S: string): Integer; override;
    procedure Delete(Index: Integer); override;
    procedure Clear; override;
    procedure SetAllNull;
    procedure ClearNulls;
    function ForceTableStatistic(RelationID: string): TTableStatistic;
    procedure AssignClonedItems(ATablesStatisticList: TTablesStatisticList);

    procedure SortByPerformance;
    procedure SortByGarbageCollected;
    procedure Sort; override;
    function IsGarbageNull: Boolean;

    property Statistics[Index: Integer]: TTableStatistic read GetStatistics;
    property StatisticByRelationID[Index: Integer]: TTableStatistic read GetStatisticByRelationID;
    property MaxDeltaValue: Integer read FMaxDeltaValue write FMaxDeltaValue;
    property MaxGarbageValue: Integer read FMaxGarbageValue write FMaxGarbageValue;
  end;

implementation

{ TTableStatistic }

function TTableStatistic.GetTableName: string;
begin
  Result := FTableName;
end;

function TTableStatistic.GetIdxReads: Integer;
begin
  Result := FIdxReads;
end;

function TTableStatistic.GetSeqReads: Integer;
begin
  Result :=FSeqReads;
end;

function TTableStatistic.GetUpdates: Integer;
begin
  Result := FUpdates;
end;

function TTableStatistic.GetInserts: Integer;
begin
  Result := FInserts;
end;

function TTableStatistic.GetDeletes: Integer;
begin
  Result := FDeletes;
end;

function TTableStatistic.GetBackout: Integer;
begin
  Result := FBackout;
end;

function TTableStatistic.GetExpunge: Integer;
begin
  Result := FExpunge;
end;

function TTableStatistic.GetPurge: Integer;
begin
  Result := FPurge;
end;

procedure TTableStatistic.CopyFrom(ATableStatistic: TTableStatistic);
begin
  FSeqReads := ATableStatistic.SeqReads;
  FIdxReads := ATableStatistic.IdxReads;
  FInserts := ATableStatistic.Inserts;
  FDeletes := ATableStatistic.Deletes;
  FTableName := ATableStatistic.TableName;

  FBackout := ATableStatistic.Backout;
  FExpunge := ATableStatistic.Expunge;
  FPurge := ATableStatistic.Purge;
end;

constructor TTableStatistic.Create(AOwner: TComponent);
begin
  inherited;
  SetAllNull;
  FTableName := '';
end;

constructor TTableStatistic.CreateAsClone(AOwner: TComponent; ATableStatistic: TTableStatistic);
begin
  inherited Create(AOwner);
  FSeqReads := ATableStatistic.SeqReads;
  FIdxReads := ATableStatistic.IdxReads;
  FUpdates := ATableStatistic.Updates;
  FInserts := ATableStatistic.Inserts;
  FDeletes := ATableStatistic.Deletes;
  FTableName := ATableStatistic.TableName;
  FBackout := ATableStatistic.Backout;
  FExpunge := ATableStatistic.Expunge;
  FPurge := ATableStatistic.Purge;
end;

function TTableStatistic.IsFullyNull: Boolean;
begin
  Result := IsGarbageNull and IsNull;
end;

function TTableStatistic.IsGarbageNull: Boolean;
begin
  Result := ((FExpunge = 0) and
             (FBackout = 0) and
             (FPurge = 0))
end;

function TTableStatistic.IsNull: Boolean;
begin
  Result := ((FSeqReads = 0) and
             (FIdxReads = 0) and
             (FInserts = 0) and
             (FDeletes = 0) and
             (FUpdates = 0))
end;

procedure TTableStatistic.SetAllNull;
begin
  FSeqReads := 0;
  FIdxReads := 0;
  FInserts := 0;
  FDeletes := 0;
  FUpdates := 0;

  FBackout := 0;
  FExpunge := 0;
  FPurge := 0;
end;

{ TTablesStatisticList }

function TTablesStatisticList.Add(const S: string): Integer;
begin
  Result := AddObject(S, TTableStatistic.Create(nil));
end;

procedure TTablesStatisticList.AssignClonedItems(
  ATablesStatisticList: TTablesStatisticList);
var
  I: Integer;
begin
  Clear;
  for I := 0 to ATablesStatisticList.Count -1 do
    CloneItem(ATablesStatisticList[I], ATablesStatisticList.Statistics[I]);
  FMaxDeltaValue := ATablesStatisticList.MaxDeltaValue;
  FMaxGarbageValue := ATablesStatisticList.MaxGarbageValue;
end;

procedure TTablesStatisticList.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Statistics[I].Free;
  inherited Clear;
end;

procedure TTablesStatisticList.ClearNulls;
var
  I: Integer;
begin
  for I := (Count - 1) downto 0 do
    if Statistics[I].IsFullyNull then
      Delete(I);
end;

procedure TTablesStatisticList.CloneItem(const S: string;
  AObject: TTableStatistic);
var
  vTableStatistic: TTableStatistic;
begin
  vTableStatistic := TTableStatistic.CreateAsClone(nil, AObject);
  AddObject(S, vTableStatistic);
end;

function TTablesStatisticList.CompareStrings(const S1,
  S2: string): Integer;
begin
  Result := inherited CompareStrings(S1, S2);
end;

constructor TTablesStatisticList.Create;
begin
  inherited Create;
//  FLastUsedRelationID := -1;
//  FLastUsedIndex := -1;
  FMaxDeltaValue := 0;
  FMaxGarbageValue := 0;
end;

procedure TTablesStatisticList.Delete(Index: Integer);
begin
  TTableStatistic(Objects[Index]).Free;
  inherited Delete(Index);
end;

destructor TTablesStatisticList.Destroy;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Statistics[I].Free;
  inherited Destroy;
end;

function TTablesStatisticList.ForceTableStatistic(
  RelationID: string): TTableStatistic;
begin
  Result := StatisticByRelationID[StrToInt(RelationID)];
  if not Assigned(Result) then
    Result := Statistics[Add(RelationID)];
end;

function TTablesStatisticList.GetStatisticByRelationID(
  Index: Integer): TTableStatistic;
var
  I: Integer;
begin
//  if Index <> FLastUsedRelationID then
//  begin
//    FLastUsedRelationID := Index;
//    FLastUsedIndex := IndexOf(IntToStr(FLastUsedRelationID));
//  end;
//  if FLastUsedIndex <> -1 then
//    Result := Statistics[FLastUsedIndex]
//  else
//    Result := nil;
  I := IndexOf(IntToStr(Index));
  if I <> -1 then
    Result := Statistics[I]
  else
    Result := nil;
end;

function TTablesStatisticList.GetStatistics(
  Index: Integer): TTableStatistic;
begin
  if ((Index > -1) and (Index < Count)) then
    Result := TTableStatistic(Objects[Index])
  else
   Result := nil;
end;

function TTablesStatisticList.IsGarbageNull: Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to Count - 1 do
  begin
    Result := Statistics[I].IsGarbageNull;
    if Result then Exit;
  end;
end;

procedure TTablesStatisticList.SetAllNull;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Statistics[I].SetAllNull;
end;

function TablesStatisticListCompareStrings(List: TStringList; Index1, Index2: Integer): Integer;
begin
  with TTablesStatisticList(List) do
    Result := CompareStrings(Statistics[Index1].TableName,
                             Statistics[Index2].TableName);
end;

procedure TTablesStatisticList.Sort;
begin
  CustomSort(TablesStatisticListCompareStrings);
end;

function IntSortByGarbageCollected(List: TStringList; Index1, Index2: Integer): Integer;
var
  Val1, Val2: Integer;
begin
  with TTablesStatisticList(List).Statistics[Index1] do
    Val1 := Backout + Expunge + Purge;
  with TTablesStatisticList(List).Statistics[Index2] do
    Val2 := Backout + Expunge + Purge;
  if Val1 < Val2 then
    Result := 1
  else
    if Val1 > Val2 then
      Result := -1
    else
    begin
      if TTablesStatisticList(List).Statistics[Index1].TableName <
           TTablesStatisticList(List).Statistics[Index2].TableName then
        Result := -1
      else
        if TTablesStatisticList(List).Statistics[Index1].TableName >
             TTablesStatisticList(List).Statistics[Index2].TableName then
          Result := 1
        else
          Result := 0;
    end;
end;

procedure TTablesStatisticList.SortByGarbageCollected;
begin
  CustomSort(IntSortByGarbageCollected);
end;

function IntSortByStatistic(List: TStringList; Index1, Index2: Integer): Integer;
var
  Val1, Val2: Integer;
begin
  with TTablesStatisticList(List).Statistics[Index1] do
    Val1 := IdxReads + SeqReads + Inserts + Updates + Deletes;
  with TTablesStatisticList(List).Statistics[Index2] do
    Val2 := IdxReads + SeqReads + Inserts + Updates + Deletes;
  if Val1 < Val2 then
    Result := 1
  else
    if Val1 > Val2 then
      Result := -1
    else
    begin
      if TTablesStatisticList(List).Statistics[Index1].TableName <
           TTablesStatisticList(List).Statistics[Index2].TableName then
        Result := -1
      else
        if TTablesStatisticList(List).Statistics[Index1].TableName >
             TTablesStatisticList(List).Statistics[Index2].TableName then
          Result := 1
        else
          Result := 0;
    end;
end;

procedure TTablesStatisticList.SortByPerformance;
begin
  CustomSort(IntSortByStatistic);
end;

end.
