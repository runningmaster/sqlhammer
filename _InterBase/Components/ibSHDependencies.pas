unit ibSHDependencies;

interface

uses
  SysUtils, Classes, StrUtils, Contnrs,
  SHDesignIntf, ibSHDesignIntf, ibSHDriverIntf, ibSHComponent;

type
  TibBTDependenceDescr = class
  private
    FObjectType: Integer;
    FObjectName: string;
    FFieldName: string;
  public
    property ObjectType: Integer read FObjectType write FObjectType;
    property ObjectName: string read FObjectName write FObjectName;
    property FieldName: string read FFieldName write FFieldName;
  end;

  TibBTDependencies = class(TibBTComponent, IibSHDependencies)
  private
    FDependenceList: TObjectList;
    FResultList: TStrings;
    procedure Execute(AType: TibSHDependenceType; const BTCLDatabase: IibSHDatabase;
      const AClassIID: TGUID; const ACaption: string; AOwnerCaption: string = '');
    function GetObjectNames(const AClassIID: TGUID; AOwnerCaption: string = ''): TStrings;
    function IsEmpty: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  ibSHConsts, ibSHSQLs, ibSHValues, ibSHStrUtil;

{ TibBTDependencies }

constructor TibBTDependencies.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDependenceList := TObjectList.Create;
  FResultList := TStringList.Create;
end;

destructor TibBTDependencies.Destroy;
begin
  FDependenceList.Free;
  FResultList.Free;
  inherited Destroy;
end;

procedure TibBTDependencies.Execute(AType: TibSHDependenceType; const BTCLDatabase: IibSHDatabase;
  const AClassIID: TGUID; const ACaption: string; AOwnerCaption: string = '');
var
  SQL: string;
  DependenceDescr: TibBTDependenceDescr;
  BegSub, EndSub: TCharSet;
  GeneratorID: string;
begin
  BegSub := ['+', ')', '(', '*', '/', '|', ',', '=', '>', '<', '-', '!', '^', '~', ',', ';', ' ', #13, #10, #9, '"'];
  EndSub := ['+', ')', '(', '*', '/', '|', ',', '=', '>', '<', '-', '!', '^', '~', ',', ';', ' ', #13, #10, #9, '"'];

  if AnsiSameText(BTCLDatabase.BTCLServer.Version, SInterBase70) or
     AnsiSameText(BTCLDatabase.BTCLServer.Version, SInterBase71) or
     AnsiSameText(BTCLDatabase.BTCLServer.Version, SInterBase75) or
     AnsiSameText(BTCLDatabase.BTCLServer.Version, SInterBase2007)    
  then
    GeneratorID := '11'
  else
    GeneratorID := '14';

  if IsEqualGUID(AClassIID, IibSHDomain) or IsEqualGUID(AClassIID, IibSHSystemDomain) then
    case AType of
      dtUsedBy: SQL := FormatSQL(SQL_GET_DOMAIN_USED_BY);
      dtUses:;
    end
  else
  if IsEqualGUID(AClassIID, IibSHTable) or IsEqualGUID(AClassIID, IibSHSystemTable) or IsEqualGUID(AClassIID, IibSHSystemTableTmp) then
    case AType of
      dtUsedBy: SQL := FormatSQL(SQL_GET_TABLE_USED_BY);
      dtUses:   SQL := FormatSQL(SQL_GET_TABLE_USES);
    end
  else
  if IsEqualGUID(AClassIID, IibSHField) then
  { TODO : Разобраться с зависимостями полей }
    case AType of
      dtUsedBy: SQL := Format(FormatSQL(SQL_GET_FIELD_USED_BY), [AOwnerCaption, ACaption, AOwnerCaption, ACaption, AOwnerCaption, ACaption, AOwnerCaption, ACaption]);
      dtUses:
        SQL:= Format(FormatSQL(SQL_GET_FIELD_USES),
        [AOwnerCaption, ACaption, AOwnerCaption, ACaption,
        AOwnerCaption, ACaption, AOwnerCaption, ACaption]);

      
    end
  else
  if IsEqualGUID(AClassIID, IibSHConstraint) then
    case AType of
      dtUsedBy:;
      dtUses:;
    end
  else
  if IsEqualGUID(AClassIID, IibSHIndex) then
    case AType of
      dtUsedBy:;
      dtUses:;
    end
  else
  if IsEqualGUID(AClassIID, IibSHView) then
    case AType of
      dtUsedBy: SQL := FormatSQL(SQL_GET_VIEW_USED_BY);
      dtUses: SQL := FormatSQL(SQL_GET_VIEW_USES);
    end
  else
  if IsEqualGUID(AClassIID, IibSHProcedure) then
    case AType of
      dtUsedBy: SQL := FormatSQL(SQL_GET_PROCEDURE_USED_BY);
      dtUses: SQL := FormatSQL(SQL_GET_PROCEDURE_USES);
    end
  else
  if IsEqualGUID(AClassIID, IibSHTrigger) then
    case AType of
      dtUsedBy:;
      dtUses: SQL := FormatSQL(SQL_GET_TRIGGER_USES);
    end
  else
  if IsEqualGUID(AClassIID, IibSHGenerator) then
    case AType of
      dtUsedBy: SQL := Format(FormatSQL(SQL_GET_GENERATOR_USED_BY), [GeneratorID]);
      dtUses:;
    end
  else
  if IsEqualGUID(AClassIID, IibSHException) then
    case AType of
      dtUsedBy: SQL := FormatSQL(SQL_GET_EXCEPTION_USED_BY);
      dtUses:;
    end
  else
  if IsEqualGUID(AClassIID, IibSHFunction) then
    case AType of
      dtUsedBy: SQL := FormatSQL(SQL_GET_FUNCTION_USED_BY);
      dtUses:;
    end
  else
  if IsEqualGUID(AClassIID, IibSHFilter) then
    case AType of
      dtUsedBy: SQL := FormatSQL(SQL_GET_FILTER_USED_BY);
      dtUses:;
    end;

  FDependenceList.Clear;
  if Length(SQL) = 0 then Exit;
  if BTCLDatabase.DRVQuery.ExecSQL(SQL, [ACaption], False, not IsEqualGUID(AClassIID, IibSHField)) then
  begin
    while not BTCLDatabase.DRVQuery.Eof do
    begin
      DependenceDescr := TibBTDependenceDescr.Create;
      DependenceDescr.ObjectType := BTCLDatabase.DRVQuery.GetFieldIntValue(0);
      DependenceDescr.ObjectName := BTCLDatabase.DRVQuery.GetFieldStrValue(1);
      DependenceDescr.FieldName := BTCLDatabase.DRVQuery.GetFieldStrValue(2);
      FDependenceList.Add(DependenceDescr);
      BTCLDatabase.DRVQuery.Next;
    end;
  end;



  if IsEqualGUID(AClassIID, IibSHFunction) or IsEqualGUID(AClassIID, IibSHFilter) or
     (IsEqualGUID(AClassIID, IibSHGenerator) and (GeneratorID = '11')) then
  begin
    SQL := FormatSQL(SQL_GET_FUNCTION_USED_BY2);
    if BTCLDatabase.DRVQuery.ExecSQL(SQL, [ACaption], False,True) then
    begin
      while not BTCLDatabase.DRVQuery.Eof do
      begin
        if PosExtCI(ACaption, BTCLDatabase.DRVQuery.GetFieldStrValue(3), BegSub, EndSub) > 0 then
        begin
          DependenceDescr := TibBTDependenceDescr.Create;
          DependenceDescr.ObjectType := BTCLDatabase.DRVQuery.GetFieldIntValue(0);
          DependenceDescr.ObjectName := BTCLDatabase.DRVQuery.GetFieldStrValue(1);
          DependenceDescr.FieldName := BTCLDatabase.DRVQuery.GetFieldStrValue(2);
          FDependenceList.Add(DependenceDescr);
        end;
        BTCLDatabase.DRVQuery.Next;
      end;
    end;

    if not BTCLDatabase.DRVDatabase.IsFirebirdConnect then
    begin
      SQL := FormatSQL(SQL_GET_FUNCTION_USED_BY3);
      if BTCLDatabase.DRVQuery.ExecSQL(SQL, [ACaption], False,True) then
      begin
        while not BTCLDatabase.DRVQuery.Eof do
        begin
          if PosExtCI(ACaption, BTCLDatabase.DRVQuery.GetFieldStrValue(3), BegSub, EndSub) > 0 then
          begin
            DependenceDescr := TibBTDependenceDescr.Create;
            DependenceDescr.ObjectType := BTCLDatabase.DRVQuery.GetFieldIntValue(0);
            DependenceDescr.ObjectName := BTCLDatabase.DRVQuery.GetFieldStrValue(1);
            DependenceDescr.FieldName := BTCLDatabase.DRVQuery.GetFieldStrValue(2);
            FDependenceList.Add(DependenceDescr);
          end;
          BTCLDatabase.DRVQuery.Next;
        end;
      end;
    end
  end;

  BTCLDatabase.DRVQuery.Transaction.Commit;
end;

function TibBTDependencies.IsEmpty: Boolean;
begin
  Result := FDependenceList.Count = 0;
end;

function TibBTDependencies.GetObjectNames(const AClassIID: TGUID; AOwnerCaption: string = ''): TStrings;
var
  I, J: Integer;
  DependenceDescr: TibBTDependenceDescr;
begin
  FResultList.Clear;
  J := -1;
  if IsEqualGUID(AClassIID, IibSHTable) then J := 0;
  if IsEqualGUID(AClassIID, IibSHField) then J := 9;
  if IsEqualGUID(AClassIID, IibSHDomain) then J := 9;  
  if IsEqualGUID(AClassIID, IibSHConstraint) then J := 4;
  if IsEqualGUID(AClassIID, IibSHIndex) then J := 10;
  if IsEqualGUID(AClassIID, IibSHView) then J := 1;
  if IsEqualGUID(AClassIID, IibSHProcedure) then J := 5;
  if IsEqualGUID(AClassIID, IibSHTrigger) then J := 2;
  if IsEqualGUID(AClassIID, IibSHGenerator) then J := 14;
  if IsEqualGUID(AClassIID, IibSHException) then J := 7;
  if IsEqualGUID(AClassIID, IibSHFunction) then J := 15;
  if IsEqualGUID(AClassIID, IibSHFilter) then J := 16;

  for I := 0 to Pred(FDependenceList.Count) do 
  begin
    DependenceDescr := TibBTDependenceDescr(FDependenceList[I]);
    if DependenceDescr.ObjectType = J then
    begin
      if Length(AOwnerCaption) > 0 then
      begin
        if AnsiSameText(DependenceDescr.ObjectName, AOwnerCaption) and
           (Length(Trim(DependenceDescr.FieldName)) > 0) then
          if FResultList.IndexOf(DependenceDescr.FieldName) = -1 then
            FResultList.Add(DependenceDescr.FieldName);
      end else
      begin
        if FResultList.IndexOf(DependenceDescr.ObjectName) = -1 then
          FResultList.Add(DependenceDescr.ObjectName);
      end;
    end;
  end;

  if FResultList.Count > 0 then TStringList(FResultList).Sort;
  Result := FResultList;
end;

end.
