unit ibSHView;

interface

uses
  SysUtils, Classes, Controls, Contnrs, Forms,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;

type
  TibBTView = class(TibBTDBObject, IibSHView)
  private
    FFieldList: TComponentList;
    FTriggerList: TComponentList;
    FRecordCount: Integer;
    FData: TSHComponent;
    function GetField(Index: Integer): IibSHField;
    function GetTrigger(Index: Integer): IibSHTrigger;
    function GetRecordCountFrmt: string;
    procedure SetRecordCount;
    function GetData: IibSHData;
  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
    procedure SetOwnerIID(Value: TGUID); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Refresh; override;
    property RecordCountFrmt: string read GetRecordCountFrmt;
    property Data: IibSHData read GetData;
  published
    property Description;
    property Fields;
    property Triggers;
    property OwnerName;
  end;

implementation

uses
  ibSHConsts, ibSHSQLs, ibSHValues;

{ TibBTView }

function TibBTView.GetField(Index: Integer): IibSHField;
begin
  Assert(Index <= Pred(Fields.Count), 'Index out of bounds');
  Supports(CreateParam(FFieldList, IibSHField, Index), IibSHField, Result);
end;

function TibBTView.GetTrigger(Index: Integer): IibSHTrigger;
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

function TibBTView.GetRecordCountFrmt: string;
begin
  case FRecordCount of
    -1: Result := Format('%s', [EmptyStr]);
     0: Result := Format('%s', [SEmpty]);
     else
        Result := FormatFloat('###,###,###,###', FRecordCount);
  end;
end;

procedure TibBTView.SetRecordCount;
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

function TibBTView.GetData: IibSHData;
begin
  Supports(FData, IibSHData, Result);
end;

function TibBTView.QueryInterface(const IID: TGUID; out Obj): HResult;
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

procedure TibBTView.SetOwnerIID(Value: TGUID);
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

constructor TibBTView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFieldList := TComponentList.Create;
  FTriggerList := TComponentList.Create;
  FRecordCount := -1;
end;

destructor TibBTView.Destroy;
begin
  if Assigned(FData) then FData.Free;
  FFieldList.Free;
  FTriggerList.Free;
  inherited Destroy;
end;

procedure TibBTView.Refresh;
begin
  FFieldList.Clear;
  FTriggerList.Clear;
  inherited Refresh;
end;



end.

