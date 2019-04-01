unit ibSHCodeNormalizer;

interface

uses SysUtils,
     SHDesignIntf, SHOptionsIntf, ibSHDesignIntf, ibSHConsts,
     pSHIntf, pSHCommon,Classes;

type
  TibBTCodeNormalizer = class(TSHComponent, ISHDemon, IibSHCodeNormalizer)
  private
    FDatabase: IibSHDatabase;
    FKeywordsList: IibSHKeywordsList;
    function IsSQLDialect3Object(const AObjectName: string{; IsUserInput: Boolean}): Boolean;
    function IsSQLDialect1Compatible(const AObjectName: string): Boolean;
    function RetrieveKeywordsList: Boolean;

  protected
    {IibSHCodeNormalizer}
    function SourceDDLToMetadataName(const AObjectName: string): string;
    function MetadataNameToSourceDDL(const ADatabase: IibSHDatabase; const AObjectName: string): string;
    function MetadataNameToSourceDDLCase(const ADatabase: IibSHDatabase; const AObjectName: string): string;
    function InputValueToMetadata(const ADatabase: IibSHDatabase; const AObjectName: string): string;
    function InputValueToMetadataCheck(const ADatabase: IibSHDatabase; var AObjectName: string): Boolean;
    function CaseSQLKeyword(const AKeywordsString: string): string;
    function IsKeyword(const ADatabase: IibSHDatabase; const AKeyword: string): Boolean;
  public

    class function GetClassIIDClassFnc: TGUID; override;

  end;

implementation

procedure Register;
begin
  SHRegisterComponents([TibBTCodeNormalizer]);
end;

function ContainsNonIBStandardChars(const Str:string):boolean;
var
   i:integer;
begin
 Result:=False;
 for i:=1 to Length(Str) do
 begin
  Result:= ((Str[i]<'A') or (Str[i]>'Z')) and ((Str[i]<'0') or (Str[i]>'9')) and
   not (Str[i] in ['_','$']);
  if Result then
   Break
 end;
end;

{ TibBTObjectNameFormater }

function TibBTCodeNormalizer.IsSQLDialect3Object(
  const AObjectName: string{; IsUserInput: Boolean}): Boolean;
begin
{  if IsUserInput then
    Result := (FDatabase.SQLDialect > 2) and
              ((not IsSQLDialect1Compatible(AObjectName)) or
               (
                 (AObjectName <> AnsiUpperCase(AObjectName)) and
                 (not FDatabase.CapitalizeNames)
               )
               )
  else}
   Result := (Length(AObjectName)=0) or (FDatabase.SQLDialect > 2) and

              (((AObjectName[1]>='0') and (AObjectName[1]<='9')) or
                ContainsNonIBStandardChars(AObjectName) or
                  IsKeyword(FDatabase,AObjectName)
               ) ;
   
end;


function TibBTCodeNormalizer.IsSQLDialect1Compatible(
  const AObjectName: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  if Length(AObjectName)  > 0 then
  begin
    if (AObjectName[1]>='0') and (AObjectName[1]<='9')then
        Result := False
    else
    begin
        for I := 1 to Length(AObjectName) do
//          if not (AObjectName[I] in AvalibleChars) then

         if ((AObjectName[I]<'A') or (AObjectName[I]>'Z')) and    // Несколько лучше оптимизируется
            ((AObjectName[I]<'a') or (AObjectName[I]>'z')) and
            ((AObjectName[I]<'0') or (AObjectName[I]>'9')) and
            not (AObjectName[I] in ['_','$'])
         then
          begin
            Result := False;
            Break;
          end;
      if Result then
       Result:= not IsKeyword(FDatabase,AObjectName)
    end;
  end;
end;

function TibBTCodeNormalizer.RetrieveKeywordsList: Boolean;
var
  vEditorRegistrator: IibSHEditorRegistrator;
begin
  if Supports(Designer.GetDemon(IibSHEditorRegistrator), IibSHEditorRegistrator, vEditorRegistrator) then
    Result := Supports(vEditorRegistrator.GetKeywordsManager(FDatabase.BTCLServer), IibSHKeywordsList, FKeywordsList)
  else
    Result := False;
end;

function TibBTCodeNormalizer.SourceDDLToMetadataName(
  const AObjectName: string): string;
var
  L: Integer;
begin
 L := Length(AObjectName);
  if (L > 1) and (AObjectName[1] = '"') and (AObjectName[L] = '"')  then
  begin
    Result:=AObjectName;
    SetLength(Result,Length(Result)-1);
    Delete(Result, 1, 1);
  end
  else
    Result := Trim(UpperCase(AObjectName));

{  L := Length(AObjectName);
  if (L > 1) and
     (AObjectName[1] = '"') and
     (AObjectName[L] = '"') then
  begin
    Result := copy(AObjectName, 2, L - 2);
//    Delete(Result, L, 1);
//    Delete(Result, 1, 1);
  end else
    Result := Trim(AnsiUpperCase(AObjectName));
 }   
end;

function TibBTCodeNormalizer.MetadataNameToSourceDDL(
  const ADatabase: IibSHDatabase; const AObjectName: string): string;
begin
  if Supports(ADatabase, IibSHDatabase, FDatabase) and
    RetrieveKeywordsList then
  begin
    try
      if IsSQLDialect3Object(AObjectName) then
        Result := Format('%s%s%s', [sQuotation, AObjectName, sQuotation])
      else
      begin
        if FDatabase.CapitalizeNames then
          Result := AnsiUpperCase(AObjectName)
        else
          Result := AObjectName;
      end;
    finally
      if Assigned(FKeywordsList) then
        FKeywordsList := nil;
      if Assigned(FDatabase) then
        FDatabase := nil;
    end;
  end;
end;

function TibBTCodeNormalizer.MetadataNameToSourceDDLCase(
  const ADatabase: IibSHDatabase; const AObjectName: string): string;
var
  vEditorCodeInsightOptions: ISHEditorCodeInsightOptions;
  posPoint: integer;
begin
  if Supports(ADatabase, IibSHDatabase, FDatabase) and
    RetrieveKeywordsList then
  begin
    try
      if IsSQLDialect3Object(AObjectName) then
      begin
        if (Length(AObjectName)>0) and
         ((AObjectName[1]=SQuotation)or (AObjectName[Length(AObjectName)]=SQuotation)  )
        then
         Result :=AObjectName
        else
        begin

// Надеюсь что долбоебов которые будут делать названия со скобами в конце не найдется
          if (Length(AObjectName)<3) or (AObjectName[Length(AObjectName)]<>')') or
           (AObjectName[Length(AObjectName)-1]<>'(')
          then
          begin
            posPoint:=Pos('.',AObjectName);
            if (posPoint=0) or (Pos('.',Copy(AObjectName,posPoint+1,MaxInt))>0) then
             Result := Format('%s%s%s', [sQuotation, AObjectName, sQuotation])
            else
            begin
            //Ровно одна точка. Может быть разделителем между алиасом таблицы и поля
             if IsSQLDialect3Object(Copy(AObjectName,1,posPoint-1)) or
                IsSQLDialect3Object(Copy(AObjectName,posPoint+1,MaxInt))
             then
              Result := Format('%s%s%s', [sQuotation, AObjectName, sQuotation])
             else
              Result :=AObjectName
            end
          end
          else
          if IsSQLDialect3Object(Copy(AObjectName,1,Length(AObjectName)-2)) then
           Result := Format('%s%s%s', [sQuotation, Copy(AObjectName,1,Length(AObjectName)-2), sQuotation])+'()'
          else
           Result :=AObjectName
        end
      end
      else
      begin
        if Supports(Designer.GetDemon(ISHEditorCodeInsightOptions), ISHEditorCodeInsightOptions, vEditorCodeInsightOptions) then
        begin
          Result := DoCaseCode(AObjectName, TpSHCaseCode(Ord(vEditorCodeInsightOptions.CaseCode)))
        end
        else
          Result := AObjectName;
      end;
    finally
      if Assigned(FKeywordsList) then
        FKeywordsList := nil;
      if Assigned(FDatabase) then
        FDatabase := nil;
    end;
  end;
end;

function TibBTCodeNormalizer.InputValueToMetadata(
  const ADatabase: IibSHDatabase; const AObjectName: string): string;
begin
  Result := AObjectName;
  if Supports(ADatabase, IibSHDatabase, FDatabase)
    and    RetrieveKeywordsList // Buzz: На хера?
  then
  begin
    try
      if Length(Result) > 0 then
      begin
        if (FDatabase.SQLDialect > 2) then
        begin
          if (Result[1] = '"') and (Result[Length(Result)] = '"') then
          begin
            Delete(Result, 1, 1);
            if Length(Result) > 0 then
              if Result[Length(Result)] = '"' then
                SetLength(Result, Length(Result)-1)
          end
          else
            if FDatabase.CapitalizeNames and IsSQLDialect1Compatible(Result) then
              Result := UpperCase(Result);
        end
        else
        begin
          if IsSQLDialect1Compatible(Result) then
            Result := UpperCase(Result);
        end;
      end;
    finally
      if Assigned(FKeywordsList) then
        FKeywordsList := nil;
      if Assigned(FDatabase) then
        FDatabase := nil;
    end;
  end;
end;

function TibBTCodeNormalizer.InputValueToMetadataCheck(
  const ADatabase: IibSHDatabase; var AObjectName: string): Boolean;
begin
  if Supports(ADatabase, IibSHDatabase, FDatabase) and
    RetrieveKeywordsList then
  begin
    try
      if Length(AObjectName) > 0 then
      begin
        if (FDatabase.SQLDialect > 2) then
        begin
          if (AObjectName[1] = '"') and (AObjectName[Length(AObjectName)] = '"') then
          begin
            Delete(AObjectName, 1, 1);
            if Length(AObjectName) > 0 then
              if AObjectName[Length(AObjectName)] = '"' then
                Delete(AObjectName, Length(AObjectName), 1);
          end
          else
            if FDatabase.CapitalizeNames and IsSQLDialect1Compatible(AObjectName) then
              AObjectName := UpperCase(AObjectName);
          Result := True;
        end
        else
        begin
          Result := IsSQLDialect1Compatible(AObjectName);
          if Result then
            AObjectName := UpperCase(AObjectName);
        end;
      end
      else
        Result := True;
    finally
      if Assigned(FKeywordsList) then
        FKeywordsList := nil;
      if Assigned(FDatabase) then
        FDatabase := nil;
    end;
  end
  else
    Result := False;
end;

function TibBTCodeNormalizer.CaseSQLKeyword(
  const AKeywordsString: string): string;
var
  vEditorCodeInsightOptions: ISHEditorCodeInsightOptions;
begin
  if Supports(Designer.GetDemon(ISHEditorCodeInsightOptions), ISHEditorCodeInsightOptions, vEditorCodeInsightOptions) then
    Result := DoCaseCode(AKeywordsString, TpSHCaseCode(Ord(vEditorCodeInsightOptions.CaseSQLKeywords)))
  else
    Result := AKeywordsString;
end;

function TibBTCodeNormalizer.IsKeyword(const ADatabase: IibSHDatabase; const AKeyword: string): Boolean;
var
   vDB:IibSHDatabase;
   vKW:IibSHKeywordsList;
begin
  vDB:=FDataBase;
  vKW:=FKeywordsList;
  Result := Supports(ADatabase, IibSHDatabase,FDataBase) and RetrieveKeywordsList;
  try
    if Result then
    begin
  //      Result := FKeywordsList.AllKeywordList.IndexOf(AKeyword) <> -1;
  //^^^ За IndexOf в уже отсортированном списке убивать надо. Там же около 500 строк.
          Result := (FKeywordsList as IpSHKeywordsManager).IsKeyword(AKeyword)
    end;
  finally
    FDataBase:=vDB;
    FKeywordsList := vKW;
  end;
end;

class function TibBTCodeNormalizer.GetClassIIDClassFnc: TGUID;
begin
  Result := IibSHCodeNormalizer;
end;

initialization

  Register;

end.
