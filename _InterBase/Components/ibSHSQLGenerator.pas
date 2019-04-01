unit ibSHSQLGenerator;

interface

uses Classes, SysUtils,
     SHDesignIntf, ibSHDesignIntf, ibSHDriverIntf, ibSHSQLs, ibSHConsts,
     ibSHTxtRtns, pSHQStrings;

type
  TibBTSQLGenerator = class(TSHComponent, IibSHSQLGenerator)
  private
    FCodeNormalizer: IibSHCodeNormalizer;
    procedure CatchCodeNormalizer;
    function NormalizeName(AComponent: IInterface; const AName: string): string;
  protected
    {IibSHSQLGenerator}
    procedure SetAutoGenerateSQLsParams(AComponent: TSHComponent);
    procedure GenerateSQLs(AComponent: TSHComponent);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    class function GetClassIIDClassFnc: TGUID; override;

  end;

procedure Register;

implementation

procedure Register;
begin
  SHRegisterComponents([TibBTSQLGenerator]);
end;

{ TibBTSQLGenerator }

procedure TibBTSQLGenerator.CatchCodeNormalizer;
begin
  if not Assigned(FCodeNormalizer) then
    if Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, FCodeNormalizer) then
      ReferenceInterface(FCodeNormalizer, opInsert);
end;

function TibBTSQLGenerator.NormalizeName(AComponent: IInterface; const AName: string): string;
var
//  vRetriveDatabase: IibSHRetriveDatabase;
  vDatabase: IibSHDatabase;
begin
{
  CatchCodeNormalizer;
  if Assigned(FCodeNormalizer) and
    Supports(AComponent, IibSHRetriveDatabase, vRetriveDatabase) then
    Result := FCodeNormalizer.MetadataNameToSourceDDL(vRetriveDatabase.BTCLDatabase, AName)
  else
    Result := AName;
}
  CatchCodeNormalizer;
  if Assigned(FCodeNormalizer) and Supports(AComponent, IibSHDatabase, vDatabase) then
    Result := FCodeNormalizer.MetadataNameToSourceDDL(vDatabase, AName)
  else
    Result := AName;
end;

procedure TibBTSQLGenerator.SetAutoGenerateSQLsParams(
  AComponent: TSHComponent);
var
  vTableList: TStringList;
  S: string;
  I, J: Integer;
  vAllFieldsUsed: Boolean;
  vDatabase: IibSHDatabase;
  vData: IibSHData;
  function FieldCanBeKey(const AFieldName: string): Boolean;
  var
    I: Integer;
    S: string;
  begin
    Result := False;
    with AComponent as IibSHTable do
    begin
      for I := 0 to Pred(Fields.Count) do
      begin
//        S := GetField(I).Caption;
        S := Fields[I];
        if SameText(AFieldName, S) then
        begin
          Result := (GetField(I).ComputedSource.Count = 0) and
                     (GetField(I).FieldTypeID <> _BLOB);
          Break;
        end;
      end;
    end;
  end;
begin
  if Assigned(AComponent) and Supports(AComponent, IibSHData, vData) then
    if Supports(AComponent, IibSHSQLEditor) then
    begin
      if not vData.Dataset.Active then
      begin
        vTableList := TStringList.Create;
        try
          AllSQLTables(vData.Dataset.SelectSQL.Text, vTableList);
          if (vTableList.Count = 1) and (not vData.ReadOnly) then
          begin
            vData.Dataset.InsertSQL.Text := 'INSERT';
            vData.Dataset.UpdateSQL.Text := 'UPDATE';
            vData.Dataset.DeleteSQL.Text := 'DELETE';
            vData.Dataset.RefreshSQL.Text := 'SELECT';
            vData.Dataset.SetAutoGenerateSQLsParams(vTableList[0], EmptyStr, False)
          end
          else
          begin
            vData.Dataset.InsertSQL.Text := EmptyStr;
            vData.Dataset.UpdateSQL.Text := EmptyStr;
            vData.Dataset.DeleteSQL.Text := EmptyStr;
            vData.Dataset.RefreshSQL.Text := EmptyStr;
            vData.Dataset.SetAutoGenerateSQLsParams(EmptyStr, EmptyStr, False)
          end;
        finally
          vTableList.Free;
        end;
      end;
    end
    else
    if Supports(AComponent, IibSHTable) then
    with (AComponent as IibSHTable) do
    begin
      if not vData.Dataset.Active then
      begin
        vData.Dataset.InsertSQL.Text := 'INSERT';
        vData.Dataset.UpdateSQL.Text := 'UPDATE';
        vData.Dataset.DeleteSQL.Text := 'DELETE';
        vData.Dataset.RefreshSQL.Text := 'SELECT';
        if Supports(AComponent, IibSHDatabase, vDatabase) and
          (vDatabase.DatabaseAliasOptions.DML.UseDB_KEY or
           vDatabase.DatabaseAliasOptions.DML.ShowDB_KEY) then
        begin
          S := NormalizeName(AComponent, AComponent.Caption);
          vData.Dataset.SelectSQL.Text := Format(SSelectWithDB_KEYTemplate, [S, S]);
        end
        else
          vData.Dataset.SelectSQL.Text := Format(SSelectTemplate, [NormalizeName(AComponent, AComponent.Caption)]);
      end
      else
      begin
//        vData.Dataset.InsertSQL.Text := 'INSERT';
//        vData.Dataset.UpdateSQL.Text := 'UPDATE';
//        vData.Dataset.DeleteSQL.Text := 'DELETE';
//        vData.Dataset.RefreshSQL.Text := 'SELECT';
        if Supports(AComponent, IibSHDatabase, vDatabase) and
          vDatabase.DatabaseAliasOptions.DML.UseDB_KEY then
          vData.Dataset.SetAutoGenerateSQLsParams(NormalizeName(AComponent, AComponent.Caption), 'DB_KEY', False)
        else
        begin
          S := EmptyStr;
          vAllFieldsUsed := False;
          //Первичные ключи
          if Constraints.Count > 0 then
            for I := 0 to Constraints.Count - 1 do
              if SameText(GetConstraint(I).ConstraintType, ConstraintTypes[0])  then
              begin
                for J := 0 to Pred(GetConstraint(I).Fields.Count) do
                  if FieldCanBeKey(GetConstraint(I).Fields[J]) then
                    S := S + NormalizeName(AComponent, GetConstraint(I).Fields[J]) + ';';
                Break;
              end;
          //Уникальные индексы
          if (Length(S) = 0) and (Constraints.Count > 0) then
            for I := 0 to Constraints.Count - 1 do
              if SameText(GetConstraint(I).ConstraintType, ConstraintTypes[1])  then
              begin
                for J := 0 to Pred(GetConstraint(I).Fields.Count) do
                  if FieldCanBeKey(GetConstraint(I).Fields[J]) then
                    S := S + NormalizeName(AComponent, GetConstraint(I).Fields[J]) + ';';
                Break;
              end;
          //Полный фарш
          if Length(S) = 0 then
          begin
            for I := 0 to Pred(Fields.Count) do
              if (GetField(I).ComputedSource.Count = 0) and
                 (GetField(I).FieldTypeID <> _BLOB) then
                S := S + NormalizeName(AComponent, Fields[I]) + ';';
            vAllFieldsUsed := Length(S) > 0;
          end;
          if Length(S) > 0 then
          begin
            Delete(S, Length(S), 1);
            vData.Dataset.SetAutoGenerateSQLsParams(NormalizeName(AComponent, AComponent.Caption), S, vAllFieldsUsed);
          end
          else
            vData.Dataset.SetAutoGenerateSQLsParams(EmptyStr, EmptyStr, False);
        end;
      end;
    end
    else
    if Supports(AComponent, IibSHView) then
    with AComponent as IibSHView do
    begin
      if not vData.Dataset.Active then
      begin
        vData.Dataset.InsertSQL.Text := 'INSERT';
        vData.Dataset.UpdateSQL.Text := 'UPDATE';
        vData.Dataset.DeleteSQL.Text := 'DELETE';
        vData.Dataset.RefreshSQL.Text := 'SELECT';      
        if Supports(AComponent, IibSHDatabase, vDatabase) and
          (vDatabase.DatabaseAliasOptions.DML.UseDB_KEY or
           vDatabase.DatabaseAliasOptions.DML.ShowDB_KEY) then
        begin
          S := NormalizeName(AComponent, AComponent.Caption);
          vData.Dataset.SelectSQL.Text := Format(SSelectWithDB_KEYTemplate, [S, S]);
        end
        else
          vData.Dataset.SelectSQL.Text := Format(SSelectTemplate, [NormalizeName(AComponent, AComponent.Caption)]);
      end
      else
      begin
//        vData.Dataset.InsertSQL.Text := 'INSERT';
//        vData.Dataset.UpdateSQL.Text := 'UPDATE';
//        vData.Dataset.DeleteSQL.Text := 'DELETE';
//        vData.Dataset.RefreshSQL.Text := 'SELECT';
        if Supports(AComponent, IibSHDatabase, vDatabase) and
          vDatabase.DatabaseAliasOptions.DML.UseDB_KEY then
          vData.Dataset.SetAutoGenerateSQLsParams(NormalizeName(AComponent, AComponent.Caption), 'DB_KEY', False)
        else
        begin
          S := EmptyStr;
          //Полный фарш
          if Length(S) = 0 then
            for I := 0 to Pred(Fields.Count) do
              if (GetField(I).FieldTypeID <> _BLOB) then
                S := S + NormalizeName(AComponent, Fields[I]) + ';';
          if Length(S) > 0 then
          begin
            Delete(S, Length(S), 1);
            vData.Dataset.SetAutoGenerateSQLsParams(NormalizeName(AComponent, AComponent.Caption), S, True);
          end
          else
            vData.Dataset.SetAutoGenerateSQLsParams(EmptyStr, EmptyStr, False);
        end;
      end;
    end
    else
    if Supports(AComponent, IibSHProcedure) then
    begin
      vData.Dataset.SelectSQL.Text := Format(SSelectTemplate,
        [NormalizeName(AComponent, (AComponent as IibSHProcedure).Caption)]);
    end;
end;

procedure TibBTSQLGenerator.GenerateSQLs(AComponent: TSHComponent);
var
  vTableList: TStringList;
  S: string;
  I, J: Integer;
  vAllFieldsUsed: Boolean;
  vDatabase: IibSHDatabase;
  vData: IibSHData;
  function FieldCanBeKey(const AFieldName: string): Boolean;
  var
    I: Integer;
    S: string;
  begin
    Result := False;
    with AComponent as IibSHTable do
    begin
      for I := 0 to Pred(Fields.Count) do
      begin
//        S := GetField(I).Caption;
        S := Fields[I];
        if SameText(AFieldName, S) then
        begin
          Result := (GetField(I).ComputedSource.Count = 0) and
                     (GetField(I).FieldTypeID <> _BLOB);
          Break;
        end;
      end;
    end;
  end;
begin
  if Assigned(AComponent) and Supports(AComponent, IibSHData, vData) then
    if Supports(AComponent, IibSHSQLEditor) then
    begin
      if vData.Dataset.Active then
      begin
        vTableList := TStringList.Create;
        try
//          AllSQLTables(vData.Dataset.SelectSQL.Text, vTableList);

          AllTables(vData.Dataset.SelectSQL.Text, vTableList);
          if (vTableList.Count = 1) and (not vData.ReadOnly) and
          (
           not Supports(vData.Dataset.Database,IibSHDRVDatabaseExt)
           or (vData.Dataset.Database as IibSHDRVDatabaseExt).IsTableOrView(vTableList[0])
           )
          then
          begin
{            vData.Dataset.InsertSQL.Text := 'INSERT';
            vData.Dataset.UpdateSQL.Text := 'UPDATE';
            vData.Dataset.DeleteSQL.Text := 'DELETE';
            vData.Dataset.RefreshSQL.Text := 'SELECT'; }
            vData.Dataset.InsertSQL.Text := EmptyStr;
            vData.Dataset.UpdateSQL.Text := EmptyStr;
            vData.Dataset.DeleteSQL.Text := EmptyStr;
            vData.Dataset.RefreshSQL.Text := EmptyStr;

            vData.Dataset.GenerateSQLs(vTableList[0], EmptyStr, False)
          end
          else
          begin
            vData.Dataset.InsertSQL.Text := EmptyStr;
            vData.Dataset.UpdateSQL.Text := EmptyStr;
            vData.Dataset.DeleteSQL.Text := EmptyStr;
            vData.Dataset.RefreshSQL.Text := EmptyStr;
            vData.Dataset.GenerateSQLs(EmptyStr, EmptyStr, False)
          end;
        finally
          vTableList.Free;
        end;
      end;
    end
    else
    if Supports(AComponent, IibSHTable) then
    with (AComponent as IibSHTable) do
    begin
      if not vData.Dataset.Active then
      begin
        if Supports(AComponent, IibSHDatabase, vDatabase) and
          (vDatabase.DatabaseAliasOptions.DML.UseDB_KEY or
           vDatabase.DatabaseAliasOptions.DML.ShowDB_KEY) then
        begin
          S := NormalizeName(AComponent, AComponent.Caption);
          vData.Dataset.SelectSQL.Text := Format(SSelectWithDB_KEYTemplate, [S, S]);
        end
        else
          vData.Dataset.SelectSQL.Text := Format(SSelectTemplate, [NormalizeName(AComponent, AComponent.Caption)]);
      end
      else
      begin
        vData.Dataset.InsertSQL.Text := 'INSERT';
        vData.Dataset.UpdateSQL.Text := 'UPDATE';
        vData.Dataset.DeleteSQL.Text := 'DELETE';
        vData.Dataset.RefreshSQL.Text := 'SELECT';
        if Supports(AComponent, IibSHDatabase, vDatabase) and
          vDatabase.DatabaseAliasOptions.DML.UseDB_KEY then
          vData.Dataset.GenerateSQLs(NormalizeName(AComponent, AComponent.Caption), 'DB_KEY', False)
        else
        begin
          S := EmptyStr;
          vAllFieldsUsed := False;
          //Первичные ключи
          if Constraints.Count > 0 then
            for I := 0 to Constraints.Count - 1 do
              if SameText(GetConstraint(I).ConstraintType, ConstraintTypes[0])  then
              begin
                for J := 0 to Pred(GetConstraint(I).Fields.Count) do
                  if FieldCanBeKey(GetConstraint(I).Fields[J]) then
                    S := S + NormalizeName(AComponent, GetConstraint(I).Fields[J]) + ';';
                Break;
              end;
          //Уникальные индексы
          if (Length(S) = 0) and (Constraints.Count > 0) then
            for I := 0 to Constraints.Count - 1 do
              if SameText(GetConstraint(I).ConstraintType, ConstraintTypes[1])  then
              begin
                for J := 0 to Pred(GetConstraint(I).Fields.Count) do
                  if FieldCanBeKey(GetConstraint(I).Fields[J]) then
                    S := S + NormalizeName(AComponent, GetConstraint(I).Fields[J]) + ';';
                Break;
              end;
          //Полный фарш
          if Length(S) = 0 then
          begin
            for I := 0 to Pred(Fields.Count) do
              if (GetField(I).ComputedSource.Count = 0) and
                 (GetField(I).FieldTypeID <> _BLOB) then
                S := S + NormalizeName(AComponent, Fields[I]) + ';';
            vAllFieldsUsed := Length(S) > 0;
          end;
          if Length(S) > 0 then
          begin
            Delete(S, Length(S), 1);
            vData.Dataset.GenerateSQLs(NormalizeName(AComponent, AComponent.Caption), S, vAllFieldsUsed);
          end
          else
  //          vData.Dataset.SetAutoGenerateSQLsParams(EmptyStr, EmptyStr, False);
            vData.Dataset.GenerateSQLs(EmptyStr, EmptyStr, False);
        end;
      end;
    end
    else
    if Supports(AComponent, IibSHView) then
    with AComponent as IibSHView do
    begin
      if not vData.Dataset.Active then
      begin
        if Supports(AComponent, IibSHDatabase, vDatabase) and
          (vDatabase.DatabaseAliasOptions.DML.UseDB_KEY or
           vDatabase.DatabaseAliasOptions.DML.ShowDB_KEY) then
        begin
          S := NormalizeName(AComponent, AComponent.Caption);
          vData.Dataset.SelectSQL.Text := Format(SSelectWithDB_KEYTemplate, [S, S]);
        end
        else
          vData.Dataset.SelectSQL.Text := Format(SSelectTemplate, [NormalizeName(AComponent, AComponent.Caption)]);
      end
      else
      begin
        vData.Dataset.InsertSQL.Text := 'INSERT';
        vData.Dataset.UpdateSQL.Text := 'UPDATE';
        vData.Dataset.DeleteSQL.Text := 'DELETE';
        vData.Dataset.RefreshSQL.Text := 'SELECT';
        if Supports(AComponent, IibSHDatabase, vDatabase) and
          vDatabase.DatabaseAliasOptions.DML.UseDB_KEY then
          vData.Dataset.GenerateSQLs(NormalizeName(AComponent, AComponent.Caption), 'DB_KEY', False)
        else
        begin
          S := EmptyStr;
          //Полный фарш
          if Length(S) = 0 then
            for I := 0 to Pred(Fields.Count) do
              if (GetField(I).FieldTypeID <> _BLOB) then
                S := S + NormalizeName(AComponent, Fields[I]) + ';';
          if Length(S) > 0 then
          begin
            Delete(S, Length(S), 1);
            vData.Dataset.GenerateSQLs(NormalizeName(AComponent, AComponent.Caption), S, True);
          end
          else
  //          vData.Dataset.SetAutoGenerateSQLsParams(EmptyStr, EmptyStr, False);
            vData.Dataset.GenerateSQLs(EmptyStr, EmptyStr, False);
        end;
      end;
    end
    else
    if Supports(AComponent, IibSHProcedure) then
    begin
      vData.Dataset.SelectSQL.Text := Format(SSelectTemplate,
        [NormalizeName(AComponent, (AComponent as IibSHProcedure).Caption)]);
    end;
end;

constructor TibBTSQLGenerator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TibBTSQLGenerator.Destroy;
begin
  inherited;
end;

procedure TibBTSQLGenerator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent.IsImplementorOf(FCodeNormalizer) then
      FCodeNormalizer := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

class function TibBTSQLGenerator.GetClassIIDClassFnc: TGUID;
begin
  Result := IibSHSQLGenerator;
end;

initialization

  Register;

end.
