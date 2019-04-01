unit ibSHSimpleFieldListRetriever;

interface

uses  Classes, SysUtils,
      SHDesignIntf, ibSHDesignIntf, ibSHValues, ibSHSQLs,
      pSHIntf;

type

  TibBTSimpleFieldListRetriever = class(TComponent, IpSHFieldListRetriever)
  private
    FDatabase: IibSHDatabase;
    function GetDatabase: IInterface;
    procedure SetDatabase(const Value: IInterface);
  protected
  public
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetFieldList(const AObjectName: string; AList: TStrings): Boolean;
    property Database: IInterface read GetDatabase write SetDatabase;
  end;

implementation

{ TibBTSimpleFieldListRetriever }

function TibBTSimpleFieldListRetriever.GetDatabase: IInterface;
begin
  Result := FDatabase;
end;

procedure TibBTSimpleFieldListRetriever.SetDatabase(
  const Value: IInterface);
begin
  if Supports(Value, IibSHDatabase, FDatabase) then
    ReferenceInterface(FDatabase, opInsert);
end;

function TibBTSimpleFieldListRetriever.GetFieldList(
  const AObjectName: string; AList: TStrings): Boolean;
var
  vClassIIDList: TStrings;
  vDesigner: ISHDesigner;
  vObjectName: string;
  vCodeNormalizer: IibSHCodeNormalizer;
  vObjectIID: TGUID;
  vSQL_TEXT: string;
  function NormalizeName(AName: string): string;
  begin
    if Assigned(vCodeNormalizer) then
      Result := vCodeNormalizer.MetadataNameToSourceDDLCase(FDatabase, AName)
    else
      Result := AName;
  end;
begin
  Result := False;
  if Assigned(FDatabase) then
  begin
    if SHSupports(ISHDesigner, vDesigner) and
      Supports(vDesigner.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer) then
        vObjectName := vCodeNormalizer.SourceDDLToMetadataName(AObjectName)
    else
      vObjectName := AObjectName;
    vClassIIDList := FDatabase.GetSchemeClassIIDList(vObjectName);
    if vClassIIDList.Count > 0 then
    begin
      vObjectIID := StringToGUID(vClassIIDList[0]);
      if IsEqualGUID(vObjectIID, IibSHTable) or
        IsEqualGUID(vObjectIID, IibSHSystemTable) then vSQL_TEXT := FormatSQL(SQL_GET_TABLE_FIELDS) else
      if IsEqualGUID(vObjectIID, IibSHView) then vSQL_TEXT := FormatSQL(SQL_GET_VIEW_FIELDS) else
      if IsEqualGUID(vObjectIID, IibSHProcedure) then vSQL_TEXT := FormatSQL(SQL_GET_PROCEDURE_PARAMS) else Exit;
      if FDatabase.DRVQuery.ExecSQL(vSQL_TEXT, [vObjectName], False) then
      begin
        AList.Clear;
        while not FDatabase.DRVQuery.Eof do
        begin
          AList.Add(NormalizeName(FDatabase.DRVQuery.GetFieldStrValue(0)));
          FDatabase.DRVQuery.Next;
        end;
        FDatabase.DRVQuery.Transaction.Commit;
      end;
    end;
  end;
end;

procedure TibBTSimpleFieldListRetriever.Notification(
  AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent.IsImplementorOf(FDatabase) then
      FDatabase := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

end.
 
