unit ibSHFieldListRetriever;

interface

uses  Classes, SysUtils,
      SHDesignIntf, ibSHDesignIntf, ibSHValues, ibSHSQLs,
      pSHIntf;

type

  TibBTFieldListRetriever = class(TSHComponent, IpSHFieldListRetriever, ISHDemon)
  private
    FDatabase: IibSHDatabase;
    function GetDatabase: IInterface;
    procedure SetDatabase(const Value: IInterface);
  protected
  public
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    class function GetClassIIDClassFnc: TGUID; override;
    function GetFieldList(const AObjectName: string; AList: TStrings): Boolean;
    property Database: IInterface read GetDatabase write SetDatabase;
  end;

implementation

procedure Register;
begin
  SHRegisterComponents([TibBTFieldListRetriever]);
end;

{ TibBTFieldListRetriever }

function TibBTFieldListRetriever.GetDatabase: IInterface;
begin
  Result := FDatabase;
end;

procedure TibBTFieldListRetriever.SetDatabase(
  const Value: IInterface);
begin
  ReferenceInterface(FDatabase, opRemove);
  if Supports(Value, IibSHDatabase, FDatabase) then
    ReferenceInterface(FDatabase, opInsert);
end;

procedure TibBTFieldListRetriever.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent.IsImplementorOf(FDatabase) then
      FDatabase := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

class function TibBTFieldListRetriever.GetClassIIDClassFnc: TGUID;
begin
  Result := IpSHFieldListRetriever;
end;

function TibBTFieldListRetriever.GetFieldList(
  const AObjectName: string; AList: TStrings): Boolean;
var
  vClassIIDList: TStrings;
  vDesigner: ISHDesigner;
  vObjectName: string;
  vObjectIID: TGUID;
  vSQL_TEXT: string;
  vComponentClass: TSHComponentClass;
  vDomain: IibSHDomain;
  vDDLGenerator: IibSHDDLGenerator;
  vDomainComponent: TSHComponent;
  vDDLGeneratorComponent: TSHComponent;
  vCodeNormalizer: IibSHCodeNormalizer;
  
  function NormalizeName(const AName: string): string;
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
    vObjectName := AObjectName;
    vClassIIDList := FDatabase.GetSchemeClassIIDList(vObjectName);
    if vClassIIDList.Count > 0 then
    begin
      Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer);
      vObjectIID := StringToGUID(vClassIIDList[0]);
      if IsEqualGUID(vObjectIID, IibSHView) then
      begin
        vSQL_TEXT := FormatSQL(SQL_GET_VIEW_FIELDS);
        if FDatabase.DRVQuery.ExecSQL(vSQL_TEXT, [vObjectName], False,True) then
        begin
          AList.Clear;
          while not FDatabase.DRVQuery.Eof do
          begin
            AList.Add(NormalizeName(FDatabase.DRVQuery.GetFieldStrValue(0)) + '=');
            FDatabase.DRVQuery.Next;
          end;
          FDatabase.DRVQuery.Transaction.Commit;
        end;
      end
      else
      begin
        if not FDatabase.ExistsPrecision then
        begin
          if IsEqualGUID(vObjectIID, IibSHTable) or
            IsEqualGUID(vObjectIID, IibSHSystemTable) then vSQL_TEXT := FormatSQL(SQL_GET_TABLE_FIELDS1) else
          if IsEqualGUID(vObjectIID, IibSHProcedure) then vSQL_TEXT := FormatSQL(SQL_GET_OUT_PROCEDURE_PARAMS1) else Exit;
        end
        else
        begin
          if IsEqualGUID(vObjectIID, IibSHTable) or
            IsEqualGUID(vObjectIID, IibSHSystemTable) then vSQL_TEXT := FormatSQL(SQL_GET_TABLE_FIELDS3) else
          if IsEqualGUID(vObjectIID, IibSHProcedure) then vSQL_TEXT := FormatSQL(SQL_GET_OUT_PROCEDURE_PARAMS3) else Exit;
        end;
        if SHSupports(ISHDesigner, vDesigner) then
        begin
          vDDLGeneratorComponent := nil;
          vDomainComponent := nil;
          vComponentClass := vDesigner.GetComponent(IibSHDDLGenerator);
          if Assigned(vComponentClass) then
            vDDLGeneratorComponent := vComponentClass.Create(nil);
          try
            vComponentClass := vDesigner.GetComponent(IibSHDomain);
            if Assigned(vComponentClass) then
            begin
              vDomainComponent := vComponentClass.Create(nil);
              vDomainComponent.OwnerIID := FDatabase.InstanceIID;
            end;
            try
              if Assigned(vDDLGeneratorComponent) and
                 Assigned(vDomainComponent) and
                 Supports(vDDLGeneratorComponent, IibSHDDLGenerator, vDDLGenerator) and
                 Supports(vDomainComponent, IibSHDomain, vDomain) and
                 FDatabase.DRVQuery.ExecSQL(vSQL_TEXT, [vObjectName], False,True) then
              begin
                AList.Clear;
                vDDLGenerator.GetDDLText(vDomain);
                while not FDatabase.DRVQuery.Eof do
                begin
                  vDDLGenerator.SetBasedOnDomain(FDatabase.DRVQuery, vDomain, 'Domain');
                  AList.Add(NormalizeName(FDatabase.DRVQuery.GetFieldStrValue(0)) + '=  ' + vDomain.DataTypeExt);
                  FDatabase.DRVQuery.Next;
                end;
                FDatabase.DRVQuery.Transaction.Commit;
              end;
            finally
              vDomain := nil;
              if Assigned(vDomainComponent) then
                vDomainComponent.Free;
            end;
          finally
            vDDLGeneratorComponent := nil;
            if Assigned(vDDLGeneratorComponent) then
              vDDLGeneratorComponent.Free;
          end;
        end;
      end;
    end;
  end;
end;

initialization

  Register;

end.

