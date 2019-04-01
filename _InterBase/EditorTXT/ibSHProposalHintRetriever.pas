unit ibSHProposalHintRetriever;

interface

uses  Classes, SysUtils,
      SHDesignIntf, ibSHDesignIntf, ibSHSQLs, ibSHValues, ibSHConsts,
      ibSHMessages, pSHIntf;

type

  TibBTProposalHintRetriever = class(TSHComponent, IpSHProposalHintRetriever, ISHDemon)
  private
    FCodeNormalizer: IibSHCodeNormalizer;
    FPriorDatabase: IInterface;
    FPriorObjectName: string;
    FPriorHint: string;
    FPriorResult: Boolean;
    FPriorIsReturningValuesSection: Boolean;
    function NormilizeName(const AObjectName: string): string;
  public
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    class function GetClassIIDClassFnc: TGUID; override;

    {IpSHProposalHintRetriever}
    procedure AfterCompile(Sender: TObject);
    function GetHint(const AObjectName: string; var AHint: string;
      IsReturningValuesSection: Boolean): Boolean;
  end;


implementation

procedure Register;
begin
  SHRegisterComponents([TibBTProposalHintRetriever]);
end;

{ TibBTProposalHintRetriever }

function TibBTProposalHintRetriever.NormilizeName(
  const AObjectName: string): string;
begin
  if not Assigned(FCodeNormalizer) then
    if Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, FCodeNormalizer) then
      ReferenceInterface(FCodeNormalizer, opInsert);
  if Assigned(FCodeNormalizer) then
    Result := FCodeNormalizer.SourceDDLToMetadataName(AObjectName)
  else
    Result := AObjectName;
end;

procedure TibBTProposalHintRetriever.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent.IsImplementorOf(FCodeNormalizer) then
      FCodeNormalizer := nil;
    if AComponent.IsImplementorOf(FPriorDatabase) then
      FPriorDatabase := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

class function TibBTProposalHintRetriever.GetClassIIDClassFnc: TGUID;
begin
  Result := IpSHProposalHintRetriever;
end;

procedure TibBTProposalHintRetriever.AfterCompile(Sender: TObject);
begin
  //
  // В Sender приезжает экземпляр TibBTDBObject
  //
  ReferenceInterface(FPriorDatabase, opRemove);
  FPriorDatabase := nil;
  FPriorObjectName := '';
  FPriorHint := '';
  FPriorResult := False;
  FPriorIsReturningValuesSection := False;
end;

function TibBTProposalHintRetriever.GetHint(const AObjectName: string;
  var AHint: string; IsReturningValuesSection: Boolean): Boolean;
var
  vDatabase: IibSHDatabase;
  vObjectGUID: TGUID;
  vClassIIDList: TStrings;
  vIsReturningValuesSection: Integer;
  vSQL_TEXT: string;
  vComponentClass: TSHComponentClass;
  vDomain: IibSHDomain;
  vFunction: IibSHFunction;
  vDDLGenerator: IibSHDDLGenerator;
  vDomainComponent: TSHComponent;
  vFunctionComponent: TSHComponent;
  vDDLGeneratorComponent: TSHComponent;
  vObjectName: string;
  I: Integer;
begin
  Result := False;
  if Supports(Designer.CurrentComponent, IibSHDatabase, vDatabase) then
  begin
    vObjectName := NormilizeName(AObjectName);
    if (FPriorDatabase = vDatabase) and
       (FPriorIsReturningValuesSection = IsReturningValuesSection) and
       SameText(vObjectName, FPriorObjectName) then
    begin
      Result := FPriorResult;
      AHint := FPriorHint;
    end
    else
    begin
      if FPriorDatabase <> vDatabase then
      begin
        ReferenceInterface(FPriorDatabase, opRemove);
        FPriorDatabase := nil;
        FPriorDatabase := vDatabase;
        ReferenceInterface(FPriorDatabase, opInsert);
      end;
      FPriorObjectName := vObjectName;
      FPriorIsReturningValuesSection := IsReturningValuesSection;

      vClassIIDList := vDatabase.GetSchemeClassIIDList(vObjectName);
      if vClassIIDList.Count > 0 then
      begin
        vObjectGUID := StringToGUID(vClassIIDList[0]);
        if IsEqualGUID(vObjectGUID, IibSHProcedure) then
        begin
          if IsReturningValuesSection then
            vIsReturningValuesSection := 1
          else
            vIsReturningValuesSection := 0;
          if not vDatabase.ExistsPrecision then
            vSQL_TEXT := FormatSQL(SQL_GET_PROCEDURE_PARAMS1)
          else
            vSQL_TEXT := FormatSQL(SQL_GET_PROCEDURE_PARAMS3);
          vDDLGeneratorComponent := nil;
          vDomainComponent := nil;
          vComponentClass := Designer.GetComponent(IibSHDDLGenerator);
          if Assigned(vComponentClass) then
            vDDLGeneratorComponent := vComponentClass.Create(nil);
          try
            vComponentClass := Designer.GetComponent(IibSHDomain);
            if Assigned(vComponentClass) then
            begin
              vDomainComponent := vComponentClass.Create(nil);
              vDomainComponent.OwnerIID := vDatabase.InstanceIID;
            end;
            try
              if Assigned(vDDLGeneratorComponent) and
                 Assigned(vDomainComponent) and
                 Supports(vDDLGeneratorComponent, IibSHDDLGenerator, vDDLGenerator) and
                 Supports(vDomainComponent, IibSHDomain, vDomain) and
                 vDatabase.DRVQuery.ExecSQL(vSQL_TEXT, [AObjectName, vIsReturningValuesSection], False) then
              begin
                AHint := '';
                vDDLGenerator.GetDDLText(vDomain);
                while not vDatabase.DRVQuery.Eof do
                begin
                  vDDLGenerator.SetBasedOnDomain(vDatabase.DRVQuery, vDomain, 'Domain');
                  if vDomain.DataType = 'BLOB' then
                    AHint := AHint + Format(SParametersHintTemplate, [vDatabase.DRVQuery.GetFieldStrValue(0) + '  ' + vDomain.DataType])
                  else
                    AHint := AHint + Format(SParametersHintTemplate, [vDatabase.DRVQuery.GetFieldStrValue(0) + '  ' + vDomain.DataTypeExt]);
                  vDatabase.DRVQuery.Next;
                end;
                vDatabase.DRVQuery.Transaction.Commit;
                if Length(AHint) = 0 then
                  AHint := Format(SParametersHintTemplate, [SNoParametersExpected]);
                Delete(AHint, Length(AHint) - 4, 5);
                AHint := AHint + '"';
                Result := True;
              end;
            finally
              if Assigned(vDomain) then
                vDomain := nil;
              if Assigned(vDomainComponent) then
                vDomainComponent.Free;
            end;
          finally
            if Assigned(vDDLGenerator) then
              vDDLGenerator := nil;
            if Assigned(vDDLGeneratorComponent) then
              vDDLGeneratorComponent.Free;
          end;
        end
        else
        if IsEqualGUID(vObjectGUID, IibSHFunction) then
        begin
          vDDLGeneratorComponent := nil;
          vFunctionComponent := nil;
          vComponentClass := Designer.GetComponent(IibSHDDLGenerator);
          if Assigned(vComponentClass) then
            vDDLGeneratorComponent := vComponentClass.Create(nil);
          try
            vComponentClass := Designer.GetComponent(IibSHFunction);
            if Assigned(vComponentClass) then
            begin
              vFunctionComponent := vComponentClass.Create(nil);
              vFunctionComponent.OwnerIID := vDatabase.InstanceIID;
            end;
            try
              if Assigned(vDDLGeneratorComponent) and
                 Assigned(vFunctionComponent) and
                 Supports(vDDLGeneratorComponent, IibSHDDLGenerator, vDDLGenerator) and
                 Supports(vFunctionComponent, IibSHFunction, vFunction)
//                 and
//                 vDatabase.DRVQuery.ExecSQL(vSQL_TEXT, [AObjectName], False)
                 then
              begin
                AHint := '';
                vFunction.State := csSource;
                vFunction.Caption := AObjectName;
                vDDLGenerator.GetDDLText(vFunction);
                if vFunction.ReturnsArgument = 0 then
                  for I := 1 to vFunction.Params.Count do
                    AHint := AHint + Format(SParametersHintTemplate, [Trim(vFunction.GetParam(I).DataTypeExt)])
                else
                  for I := 0 to vFunction.Params.Count - 1 do
                    if ((I + 1) <> vFunction.ReturnsArgument) then
                      AHint := AHint + Format(SParametersHintTemplate, [Trim(vFunction.GetParam(I).DataTypeExt)]);
                if Length(AHint) = 0 then
                  AHint := Format(SParametersHintTemplate, [SNoParametersExpected]);
                Delete(AHint, Length(AHint) - 4, 5);
                AHint := AHint + '"';
                Result := True;
              end;
            finally
              if Assigned(vFunction) then
                vFunction := nil;
              if Assigned(vFunctionComponent) then
                vFunctionComponent.Free;
            end;
          finally
            if Assigned(vDDLGenerator) then
              vDDLGenerator := nil;
            if Assigned(vDDLGeneratorComponent) then
              vDDLGeneratorComponent.Free;
          end;
        end
        else
        if IsEqualGUID(vObjectGUID, IibSHTable) then
        begin
          if not vDatabase.ExistsPrecision then
            vSQL_TEXT := FormatSQL(SQL_GET_TABLE_FIELDS1)
          else
            vSQL_TEXT := FormatSQL(SQL_GET_TABLE_FIELDS3);
          vDDLGeneratorComponent := nil;
          vDomainComponent := nil;
          vComponentClass := Designer.GetComponent(IibSHDDLGenerator);
          if Assigned(vComponentClass) then
            vDDLGeneratorComponent := vComponentClass.Create(nil);
          try
            vComponentClass := Designer.GetComponent(IibSHDomain);
            if Assigned(vComponentClass) then
            begin
              vDomainComponent := vComponentClass.Create(nil);
              vDomainComponent.OwnerIID := vDatabase.InstanceIID;
            end;
            try
              if Assigned(vDDLGeneratorComponent) and
                 Assigned(vDomainComponent) and
                 Supports(vDDLGeneratorComponent, IibSHDDLGenerator, vDDLGenerator) and
                 Supports(vDomainComponent, IibSHDomain, vDomain) and
                 vDatabase.DRVQuery.ExecSQL(vSQL_TEXT, [AObjectName], False) then
              begin
                AHint := '';
                vDDLGenerator.GetDDLText(vDomain);
                while not vDatabase.DRVQuery.Eof do
                begin
                  vDDLGenerator.SetBasedOnDomain(vDatabase.DRVQuery, vDomain, 'Domain');
                  if vDomain.DataType = 'BLOB' then
                    AHint := AHint + Format(SParametersHintTemplate, [vDatabase.DRVQuery.GetFieldStrValue(0) + '  ' + vDomain.DataType])
                  else
                    AHint := AHint + Format(SParametersHintTemplate, [vDatabase.DRVQuery.GetFieldStrValue(0) + '  ' + vDomain.DataTypeExt]);
                  vDatabase.DRVQuery.Next;
                end;
                vDatabase.DRVQuery.Transaction.Commit;
                if Length(AHint) = 0 then
                  AHint := Format(SParametersHintTemplate, [SNoParametersExpected]);
                Delete(AHint, Length(AHint) - 4, 5);
                AHint := AHint + '"';
                Result := True;
              end;
            finally
              if Assigned(vDomain) then
                vDomain := nil;
              if Assigned(vDomainComponent) then
                vDomainComponent.Free;
            end;
          finally
            if Assigned(vDDLGenerator) then
              vDDLGenerator := nil;
            if Assigned(vDDLGeneratorComponent) then
              vDDLGeneratorComponent.Free;
          end;
        end;

      end;
      FPriorHint := AHint;
      FPriorResult := Result;
    end;//not equal prior
  end;
end;

initialization

  Register;

end.
