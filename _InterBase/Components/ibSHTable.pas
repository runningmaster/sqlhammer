unit ibSHTable;

interface

uses
  SysUtils, Classes, Controls, Contnrs, Forms,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;

type
  TibBTTable = class(TibBTDBObject, IibSHTable)
  private
    FDecodeDomains: Boolean;
    FWithoutComputed: Boolean;
    FRecordCount: Integer;
    FChangeCount: Integer;
    FFieldList: TComponentList;
    FConstraintList: TComponentList;
    FIndexList: TComponentList;
    FTriggerList: TComponentList;
    FData: TSHComponent;
    FExternalFile:string;

    function GetDecodeDomains: Boolean;
    procedure SetDecodeDomains(Value: Boolean);
    function GetWithoutComputed: Boolean;
    procedure SetWithoutComputed(Value: Boolean);
    function GetRecordCountFrmt: string;
    function GetChangeCountFrmt: string;
    function GetField(Index: Integer): IibSHField;
    function GetConstraint(Index: Integer): IibSHConstraint;
    function GetIndex(Index: Integer): IibSHIndex;
    function GetTrigger(Index: Integer): IibSHTrigger;
    procedure SetRecordCount;
    procedure SetChangeCount;
    function GetData: IibSHData;
    function GetExternalFile: string;
    procedure SetExternalFile(const Value: string);
  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
    procedure SetOwnerIID(Value: TGUID); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Refresh; override;
    
    property DecodeDomains: Boolean read GetDecodeDomains write SetDecodeDomains;
    property WithoutComputed: Boolean read GetWithoutComputed write SetWithoutComputed;
    property RecordCountFrmt: string read GetRecordCountFrmt;
    property ChangeCountFrmt: string read GetChangeCountFrmt;
    property Data: IibSHData read GetData;
  published
    property Description;
    property Fields;
    property Constraints;
    property Indices;
    property Triggers;
    property OwnerName;
  end;

  TibBTSystemTable = class(TibBTTable, IibSHSystemTable)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TibBTSystemTableTmp = class(TibBTSystemTable, IibSHSystemTableTmp)
  end;

implementation

uses
  ibSHConsts, ibSHSQLs, ibSHValues;

{ TibBTTable }

constructor TibBTTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDecodeDomains := False;
  FWithoutComputed := False;
  FRecordCount := -1;
  FChangeCount := -1;
  FFieldList := TComponentList.Create;
  FConstraintList := TComponentList.Create;
  FIndexList := TComponentList.Create;
  FTriggerList := TComponentList.Create;
end;

destructor TibBTTable.Destroy;
begin
  if Assigned(FData) then FData.Free;
  FFieldList.Free;
  FConstraintList.Free;
  FIndexList.Free;
  FTriggerList.Free;
  inherited Destroy;
end;

procedure TibBTTable.Refresh;
begin
  FFieldList.Clear;
  FConstraintList.Clear;
  FIndexList.Clear;
  FTriggerList.Clear;
  inherited Refresh;
end;

function TibBTTable.GetDecodeDomains: Boolean;
begin
  Result := FDecodeDomains;
end;

procedure TibBTTable.SetDecodeDomains(Value: Boolean);
begin
  FDecodeDomains := Value;
end;

function TibBTTable.GetWithoutComputed: Boolean;
begin
  Result := FWithoutComputed;
end;

procedure TibBTTable.SetWithoutComputed(Value: Boolean);
begin
  FWithoutComputed := Value;
end;

function TibBTTable.GetRecordCountFrmt: string;
begin
  case FRecordCount of
    -1: Result := Format('%s', [EmptyStr]);
     0: Result := Format('%s', [SEmpty]);
     else
        Result := FormatFloat('###,###,###,###', FRecordCount);
  end;
end;

function TibBTTable.GetChangeCountFrmt: string;
begin
  case FChangeCount of
    -1: Result := Format('%s', [EmptyStr]);
     else
        Result := Format('%d (%d left)', [FChangeCount, 255 - FChangeCount]);
  end;
end;

function TibBTTable.GetField(Index: Integer): IibSHField;
begin
  Assert(Index <= Pred(Fields.Count), 'Index out of bounds');
  Supports(CreateParam(FFieldList, IibSHField, Index), IibSHField, Result);
end;

function TibBTTable.GetConstraint(Index: Integer): IibSHConstraint;
begin
  Assert(Index <= Pred(Constraints.Count), 'Index out of bounds');
  Supports(CreateParam(FConstraintList, IibSHConstraint, Index), IibSHConstraint, Result);
  if Assigned(Result) and (Result.State = csUnknown) then
  begin
    Result.Caption := Constraints[Index];
    Result.State := csSource;
    Result.TableName := Self.Caption;
    Result.SourceDDL.Text := DDLGenerator.GetDDLText(Result);
  end;  
end;

function TibBTTable.GetIndex(Index: Integer): IibSHIndex;
begin
  Assert(Index <= Pred(Indices.Count), 'Index out of bounds');
  Supports(CreateParam(FIndexList, IibSHIndex, Index), IibSHIndex, Result);
  if Assigned(Result) and (Result.State = csUnknown) then
  begin
    Result.Caption := Indices[Index];
    Result.State := csSource;
    Result.SourceDDL.Text := DDLGenerator.GetDDLText(Result);
  end;
end;

function TibBTTable.GetTrigger(Index: Integer): IibSHTrigger;
begin
  Assert(Index <= Pred(Triggers.Count), 'Index out of bounds');
  Supports(CreateParam(FTriggerList, IibSHTrigger, Index), IibSHTrigger, Result);
  if Assigned(Result) and (Result.State = csUnknown) then
  begin
    Result.Caption := Triggers[Index];
    Result.State := csSource;
    Result.SourceDDL.Text := DDLGenerator.GetDDLText(Result);
  end;
end;

procedure TibBTTable.SetRecordCount;
var
  S: string;
  vCodeNormalizer: IibSHCodeNormalizer;
begin
  S := Self.Caption;
  if Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer) then
    S := vCodeNormalizer.MetadataNameToSourceDDL(BTCLDatabase, S);
  try
    Screen.Cursor := crHourGlass;
    if BTCLDatabase.DRVQuery.ExecSQL(Format(FormatSQL(SQL_GET_RECORD_COUNT), [S]), [], False) then
      FRecordCount := BTCLDatabase.DRVQuery.GetFieldIntValue(0);
  finally
    BTCLDatabase.DRVQuery.Transaction.Commit;
    Screen.Cursor := crDefault;
  end;
end;

procedure TibBTTable.SetChangeCount;
var
  S: string;
  vCodeNormalizer: IibSHCodeNormalizer;
begin
  S := Self.Caption;
  if Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer) then
    S := vCodeNormalizer.MetadataNameToSourceDDL(BTCLDatabase, S);
  try
    Screen.Cursor := crHourGlass;
    if BTCLDatabase.DRVQuery.ExecSQL(FormatSQL(SQL_GET_CHANGE_COUNT), [S], False) then
      FChangeCount := BTCLDatabase.DRVQuery.GetFieldIntValue(0);
  finally
    BTCLDatabase.DRVQuery.Transaction.Commit;
    Screen.Cursor := crDefault;
  end;
end;

function TibBTTable.GetData: IibSHData;
begin
  Supports(FData, IibSHData, Result);
end;

function TibBTTable.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if IsEqualGUID(IID, IibSHData) then
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

procedure TibBTTable.SetOwnerIID(Value: TGUID);
var
  vComponentClass: TSHComponentClass;
begin
  if not IsEqualGUID(OwnerIID, Value) then
  begin
    inherited SetOwnerIID(Value);
    if Assigned(FData) then FData.Free;
    vComponentClass := Designer.GetComponent(IibSHData);
    if Assigned(vComponentClass) then
      FData := vComponentClass.Create(Self);
  end;
end;

function TibBTTable.GetExternalFile: string;
begin
 Result:=FExternalFile
end;

procedure TibBTTable.SetExternalFile(const Value: string);
begin
 FExternalFile:=Value
end;

{ TibBTSystemTable }

constructor TibBTSystemTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  System := True;
end;

end.

