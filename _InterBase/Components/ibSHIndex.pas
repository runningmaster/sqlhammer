unit ibSHIndex;

interface

uses
  SysUtils, Classes, Controls, Forms, Dialogs,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;

type
  TibBTIndex = class(TibBTDBObject, IibSHIndex)
  private
    FIndexTypeID: Integer;
    FSortingID: Integer;
    FStatusID: Integer;
    FIndexType: string;
    FSorting: string;
    FTableName: string;
    FExpression: TStrings;
    FStatistics: string;
    FStatus: string;
    FIsConstraintIndex:boolean;
    function GetIndexTypeID: Integer;
    procedure SetIndexTypeID(Value: Integer);
    function GetSortingID: Integer;
    procedure SetSortingID(Value: Integer);
    function GetStatusID: Integer;
    procedure SetStatusID(Value: Integer);
    function GetIndexType: string;
    procedure SetIndexType(Value: string);
    function GetSorting: string;
    procedure SetSorting(Value: string);
    function GetTableName: string;
    procedure SetTableName(Value: string);
    function GetExpression: TStrings;
    procedure SetExpression(Value: TStrings);
    function GetStatus: string;
    procedure SetStatus(Value: string);
    function GetStatistics: string;
    procedure SetStatistics(Value: string);
    procedure SetIsConstraintIndex(const Value:boolean);
    function  GetIsConstraintIndex:boolean;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure RecountStatistics;

    property IndexTypeID: Integer read GetIndexTypeID write SetIndexTypeID;
    property SortingID: Integer read GetSortingID write SetSortingID;
    property StatusID: Integer read GetStatusID write SetStatusID;
  published
    property Description;
    property IndexType: string read GetIndexType {write SetIndexType};
    property Sorting: string read GetSorting {write SetSorting};
    property TableName: string read GetTableName {write SetTableName};
    property Fields;
//    property Expression: TStrings read GetExpression write SetExpression;
    property Status: string read GetStatus {write SetStatus};
    property Statistics: string read GetStatistics{ write SetStatistics};
  end;

implementation

uses
  ibSHConsts, ibSHSQLs, ibSHValues;

{ TibBTIndex }

constructor TibBTIndex.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FExpression := TStringList.Create;
end;

destructor TibBTIndex.Destroy;
begin
  FExpression.Free;
  inherited Destroy;
end;

procedure TibBTIndex.RecountStatistics;
var
  S, OldStatistics: string;
  vCodeNormalizer: IibSHCodeNormalizer;
begin
  S := Self.Caption;
  if Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer) then
    S := vCodeNormalizer.MetadataNameToSourceDDL(BTCLDatabase, S);

  try
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRWriteParams;
    OldStatistics := Statistics;
    BTCLDatabase.DRVQuery.ExecSQL(Format(FormatSQL(SQL_SET_STATISTICS), [S]), [], True);
  finally
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRReadParams;
    Refresh;
  end;

  Designer.ShowMsg(Format('OLD_STATISTICS:' + SLineBreak +
                          '%s' + SLineBreak + SLineBreak +
                          'NEW_STATISTICS:' + SLineBreak +
                          '%s', [OldStatistics, Statistics]), mtInformation);
end;

function TibBTIndex.GetIndexTypeID: Integer;
begin
  Result := FIndexTypeID;
end;

procedure TibBTIndex.SetIndexTypeID(Value: Integer);
begin
  FIndexTypeID := Value;
end;

function TibBTIndex.GetSortingID: Integer;
begin
  Result := FSortingID;
end;

procedure TibBTIndex.SetSortingID(Value: Integer);
begin
  FSortingID := Value;
end;

function TibBTIndex.GetStatusID: Integer;
begin
  Result := FStatusID;
end;

procedure TibBTIndex.SetStatusID(Value: Integer);
begin
  FStatusID := Value;
end;

function TibBTIndex.GetIndexType: string;
begin
  Result := FIndexType;
end;

procedure TibBTIndex.SetIndexType(Value: string);
begin
  FIndexType := Value;
end;

function TibBTIndex.GetSorting: string;
begin
  Result := FSorting;
end;

procedure TibBTIndex.SetSorting(Value: string);
begin
  FSorting := Value;
end;

function TibBTIndex.GetTableName: string;
begin
  Result := FTableName;
end;

procedure TibBTIndex.SetTableName(Value: string);
begin
  FTableName := Value;
end;

function TibBTIndex.GetExpression: TStrings;
begin
  Result := FExpression;
end;

procedure TibBTIndex.SetExpression(Value: TStrings);
begin
  FExpression.Assign(Value);
end;

function TibBTIndex.GetStatus: string;
begin
  Result := FStatus;
end;

procedure TibBTIndex.SetStatus(Value: string);
begin
  FStatus := Value;
end;

function TibBTIndex.GetStatistics: string;
begin
  Result := FStatistics;
end;

procedure TibBTIndex.SetStatistics(Value: string);
begin
  FStatistics := Value;
end;

function TibBTIndex.GetIsConstraintIndex: boolean;
begin
  Result:=FIsConstraintIndex
end;

procedure TibBTIndex.SetIsConstraintIndex(const Value: boolean);
begin
  FIsConstraintIndex:=Value;
end;

end.
