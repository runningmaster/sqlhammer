unit ibSHDDLGenerator;

interface

uses
  SysUtils, Classes, Controls, Dialogs, StrUtils, DB,
  SHDesignIntf, ibSHDesignIntf, ibSHDriverIntf, ibSHComponent;

const                     
  SDDLOffset = '  ';
  SDDLTerminator = '^';

  DescrHeader: array[0..1] of string = (
    '/* Description ----------------------------------------------------------------%s',
    '----------------------------------------------------------------------------- */');

  DescrFooter: array[0..3] of string = (
    ' ',
    '/* Insert description ---------------------------------------------------------',
    '%s',
    '----------------------------------------------------------------------------- */');

  StatisticsFooter: array[0..3] of string = (
    ' ',
    '/* Statistics -----------------------------------------------------------------',
    '%s',
    '----------------------------------------------------------------------------- */');

  DeleteOld =
    '/* Delete OLD object -------------------------------------------------------- */';

  CreateNew =
    '/* Create NEW object -------------------------------------------------------- */';

  BeginRTFM =
    '/* RTFM --------------------------------------------------------------------- */';

  EndRTFM =
    '----------------------------------------------------------------------------- */';

type
  TibBTDDLGenerator = class(TibBTComponent, IibSHDDLGenerator,IibBTTemplates)
  private
    FTerminator: string;
    FUseFakeValues: Boolean;
    FDBObjectIntf: IibSHDBObject;
    FDRVQueryIntf: IibSHDRVQuery;
    FState: TSHDBComponentState;
    FVersion: string;
    FDialect: Integer;
    FExistsPrecision: Boolean;
    FExistsProcParamDomains: Boolean;

    FDBCharset: string;
    FDDL: TStrings;
    FCodeNormalizer: IibSHCodeNormalizer;

    FIntDRVTransaction: TComponent;
    FIntDRVTransactionIntf: IibSHDRVTransaction;
    FIntDRVQuery: TComponent;
    FIntDRVQueryIntf: IibSHDRVQuery;

    FDBDomainIntf: IibSHDomain;
    FDBTableIntf: IibSHTable;
    FDBFieldIntf: IibSHField;
    FDBConstraintIntf: IibSHConstraint;
    FDBIndexIntf: IibSHIndex;
    FDBViewIntf: IibSHView;
    FDBProcedureIntf: IibSHProcedure;
    FDBTriggerIntf: IibSHTrigger;
    FDBGeneratorIntf: IibSHGenerator;
    FDBExceptionIntf: IibSHException;
    FDBFunctionIntf: IibSHFunction;
    FDBFilterIntf: IibSHFilter;
    FDBRoleIntf: IibSHRole;
    FDBShadowIntf: IibSHShadow;

    FDBQueryIntf: IibSHQuery;
    FCurrentTemplateFile:string;
    function GetTerminator: string;
    procedure SetTerminator(Value: string);
    function GetUseFakeValues: Boolean;
    procedure SetUseFakeValues(Value: Boolean);
    procedure SetBasedOnDomain(ADRVQuery: IibSHDRVQuery; ADomain: IibSHDomain; const ACaption: string);
    procedure SetRealValues;
    function ReplaceNameConsts(const ADDLText, ACaption: string): string;
    procedure SetFakeValues(DDL: TStrings; FileName:string='');
    procedure SetDDLFromValues(DDL: TStrings);
    procedure SetAlterDDLNotSupported(DDL: TStrings);

    procedure SetSourceDDL(DDL: TStrings);
    procedure SetCreateDDL(DDL: TStrings);
    procedure SetAlterDDL(DDL: TStrings);
    procedure SetDropDDL(DDL: TStrings);
    procedure SetRecreateDDL(DDL: TStrings);

    procedure CreateIntDRV;
    procedure FreeIntDRV;
    function NormalizeName(const S: string): string;
    function NormalizeName2(const S: string;DB:IibSHDatabase=nil): string;
    function GetMaxStrLength(AStrings: TStrings): Integer;
    function SpaceGenerator(const MaxStrLength: Integer; const S: string): string;
(*    function IncludeDesciption(const ADDL: string): string; *)
(*    function ExcludeDesciption(const ADDL: string): string; *)
//IibBTTemplates
   function  GetCurrentTemplateFile:string;
   procedure SetCurrentTemplateFile(const FileName:string);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetDDLText(const Intf: IInterface): string; // <- Вход

    property DBObject: IibSHDBObject read FDBObjectIntf;
    property DRVQuery: IibSHDRVQuery read FDRVQueryIntf;
    property State: TSHDBComponentState read FState;
    property Version: string read FVersion;
    property Dialect: Integer read FDialect;
    property ExistsPrecision: Boolean read FExistsPrecision;
    property DBCharset: string read FDBCharset;
    property DDL: TStrings read FDDL;
    property CodeNormalizer: IibSHCodeNormalizer read FCodeNormalizer;

    property DBDomain: IibSHDomain read FDBDomainIntf;
    property DBTable: IibSHTable read FDBTableIntf;
    property DBField: IibSHField read FDBFieldIntf;
    property DBConstraint: IibSHConstraint read FDBConstraintIntf;
    property DBIndex: IibSHIndex read FDBIndexIntf;
    property DBView: IibSHView read FDBViewIntf;
    property DBProcedure: IibSHProcedure read FDBProcedureIntf;
    property DBTrigger: IibSHTrigger read FDBTriggerIntf;
    property DBGenerator: IibSHGenerator read FDBGeneratorIntf;
    property DBException: IibSHException read FDBExceptionIntf;
    property DBFunction: IibSHFunction read FDBFunctionIntf;
    property DBFilter: IibSHFilter read FDBFilterIntf;
    property DBRole: IibSHRole read FDBRoleIntf;
    property DBShadow: IibSHShadow read FDBShadowIntf;
    property DBQuery: IibSHQuery read FDBQueryIntf;
  end;

implementation

uses
  ibSHConsts, ibSHSQLs, ibSHMessages, ibSHValues;

{ TibBTDDLGenerator }

constructor TibBTDDLGenerator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTerminator := ';';
  FUseFakeValues := True;
  FDDL := TStringList.Create;
  Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, FCodeNormalizer);
end;

destructor TibBTDDLGenerator.Destroy;
begin
  FreeAndNil(FIntDRVTransaction);
  FreeAndNil(FIntDRVQuery);
  FDDL.Free;
  inherited Destroy;
end;

function TibBTDDLGenerator.GetDDLText(const Intf: IInterface): string;
var
   vDDL:TStrings;
begin
  vDDL:=TStringList.Create;
  try
    Supports(Intf, IibSHDBObject, FDBObjectIntf);
    FDRVQueryIntf    := DBObject.BTCLDatabase.DRVQuery;
    FState           := DBObject.State;
    FVersion         := DBObject.BTCLDatabase.BTCLServer.Version;
    FDialect         := DBObject.BTCLDatabase.SQLDialect;
    FExistsPrecision := DBObject.BTCLDatabase.ExistsPrecision;
    FExistsProcParamDomains:=DBObject.BTCLDatabase.ExistsProcParamDomains;

    FDBCharset  := DBObject.BTCLDatabase.DBCharset;

    CreateIntDRV;

    if not Supports(Intf, IibSHField, FDBFieldIntf) then
      Supports(Intf, IibSHDomain,FDBDomainIntf);

{    if Supports(Intf, IibSHDomain,FDBDomainIntf) then
    begin
      if Supports(Intf, IibSHField, FDBFieldIntf) then
        FDBDomainIntf:=nil;
    end;
 }

    Supports(Intf, IibSHTable, FDBTableIntf);
    Supports(Intf, IibSHConstraint, FDBConstraintIntf);
    Supports(Intf, IibSHIndex, FDBIndexIntf);
    Supports(Intf, IibSHView, FDBViewIntf);
    Supports(Intf, IibSHProcedure, FDBProcedureIntf);
    Supports(Intf, IibSHTrigger, FDBTriggerIntf);
    Supports(Intf, IibSHGenerator, FDBGeneratorIntf);
    Supports(Intf, IibSHException, FDBExceptionIntf);
    Supports(Intf, IibSHFunction, FDBFunctionIntf);
    Supports(Intf, IibSHFilter, FDBFilterIntf);
    Supports(Intf, IibSHRole, FDBRoleIntf);
    Supports(Intf, IibSHShadow, FDBShadowIntf);
    Supports(Intf, IibSHQuery, FDBQueryIntf);

//    DDL.Clear;
    if Assigned(DBProcedure) then DBProcedure.HeaderDDL.Clear;
    case State of
      csUnknown:  ;
      csSource,csRelatedSource:   SetSourceDDL(vDDL);
      csCreate:   SetCreateDDL(vDDL);
      csAlter:    SetAlterDDL(vDDL);
      csDrop:     SetDropDDL(vDDL);
      csRecreate: SetRecreateDDL(vDDL);
    end;

  //    SetDDLFromValues(DDL: TStrings);
  //    SetAlterDDLNotSupported(DDL: TStrings);

    Result := Trim(vDDL.Text);
//    if Length(Result) > 0 then
//    begin
  //    if State <> csDrop then Result := IncludeDesciption(Result);
//    end else
//      Result := '/* UNDER CONSTRUCTION */';

//    if (Result = 'User Cancel') or DBObject.BTCLDatabase.WasLostconnect then
//      Result := EmptyStr;


  finally
  //Buzz
  // Полная лажа. При рекурсивном  вызове все летит в тар-тарары.
  // Все треба переписать без глобальных полей.  Или создавать генератор по новой для каждого вызова
    vDDL.Free;
    FreeIntDRV;
    FDBObjectIntf := nil;
    FDRVQueryIntf := nil;

    FDBDomainIntf     := nil;
    FDBTableIntf      := nil;
    FDBFieldIntf      := nil;
    FDBConstraintIntf := nil;
    FDBIndexIntf      := nil;
    FDBViewIntf       := nil;
    FDBProcedureIntf  := nil;
    FDBTriggerIntf    := nil;
    FDBGeneratorIntf  := nil;
    FDBExceptionIntf  := nil;
    FDBFunctionIntf   := nil;
    FDBFilterIntf     := nil;
    FDBRoleIntf       := nil;
    FDBShadowIntf     := nil;
    FDBQueryIntf      := nil;
  end;
end;

procedure TibBTDDLGenerator.CreateIntDRV;
var
  vComponentClass: TSHComponentClass;
begin
  if not Assigned(FIntDRVTransaction) then
  begin
    vComponentClass := Designer.GetComponent(DBObject.BTCLDatabase.BTCLServer.DRVNormalize(IibSHDRVTransaction));
    if Assigned(vComponentClass) then
    begin
      FIntDRVTransaction := vComponentClass.Create(Self);
    end;
  end;
  if Assigned(FIntDRVTransaction) then
  begin
   Supports(FIntDRVTransaction, IibSHDRVTransaction, FIntDRVTransactionIntf);
   (FIntDRVTransaction as IibSHDRVTransaction).Params.Text := TRWriteParams;
  end;

  if not Assigned(FIntDRVQuery) then
  begin
    vComponentClass := Designer.GetComponent(DBObject.BTCLDatabase.BTCLServer.DRVNormalize(IibSHDRVQuery));
    if Assigned(vComponentClass) then
    begin
      FIntDRVQuery := vComponentClass.Create(Self);
    end;
  end;
  if Assigned(FIntDRVQuery) then
   Supports(FIntDRVQuery, IibSHDRVQuery, FIntDRVQueryIntf);

  if Assigned(FIntDRVTransaction) and Assigned(FIntDRVQuery) then
  begin
    FIntDRVTransactionIntf.Database := DBObject.BTCLDatabase.DRVQuery.Database;
    FIntDRVQueryIntf.Transaction := FIntDRVTransactionIntf;
    FIntDRVQueryIntf.Database := DBObject.BTCLDatabase.DRVQuery.Database;
  end;
end;

procedure TibBTDDLGenerator.FreeIntDRV;
begin
  if FIntDRVQueryIntf<>nil then
  begin
    FIntDRVQueryIntf.Transaction:=nil;
    FIntDRVQueryIntf.Database := nil;
  end;
  FIntDRVQueryIntf := nil;
  if FIntDRVTransactionIntf<>nil then
   FIntDRVTransactionIntf.Database := nil;
  FIntDRVTransactionIntf := nil;


{  FreeAndNil(FIntDRVTransaction);
  FreeAndNil(FIntDRVQuery);}
end;

function TibBTDDLGenerator.NormalizeName(const S: string): string;
begin
  Result := S;
  if Assigned(DBObject) then
  begin
//    if (State = csCreate) and (CompareStr(DBObject.Caption, Result) <> 0) then Exit;
//^^Buzz  непонятно что автор подразумевал этим произведением
// этот код дает ошибку при попытки добавить поле в таблицу с нестандартным именем. 
    if Assigned(CodeNormalizer) then
      Result := CodeNormalizer.MetadataNameToSourceDDL(DBObject.BTCLDatabase, Result);
  end;
end;

function TibBTDDLGenerator.NormalizeName2(const S: string;DB:IibSHDatabase=nil): string;
begin
  Result := S;
  if Assigned(DBObject) or Assigned(DB) then
  begin
    if not Assigned(DB) then
      DB:=DBObject.BTCLDatabase;
    if Assigned(CodeNormalizer) then
      Result := CodeNormalizer.MetadataNameToSourceDDL(DB, Result);
  end;
end;

function TibBTDDLGenerator.GetMaxStrLength(AStrings: TStrings): Integer;
var
  I: Integer;
  S: string;
begin
  Result := 0;
  // Вообще-то, правильнее рассчитывать через Canvas.TextWidth...
  for I := 0 to Pred(AStrings.Count) do
  begin
    S := NormalizeName(AStrings[I]);
    if Result < Length(S) then Result := Length(S);
  end;
end;

function TibBTDDLGenerator.SpaceGenerator(const MaxStrLength: Integer; const S: string): string;
{var
  I: Integer;}
begin
  if MaxStrLength<=Length(S) then
    Result := ' '
  else
  begin
    SetLength(Result,MaxStrLength - Length(S)+1);
    FillChar(Result[1],MaxStrLength - Length(S)+1,' ')
  end

{  Result := ' ';
  for I := 0 to Pred(MaxStrLength - Length(S)) do
    Result := Result + ' ';}
end;

(*
function TibBTDDLGenerator.IncludeDesciption(const ADDL: string): string;
var
  Description: string;
begin
  if Assigned(DBGenerator) or Assigned(DBRole) or Assigned(DBShadow) then
  begin
    Result := ADDL;
    Exit;
  end;
  case DBObject.State of
    csSource:
      begin
        if Length(DBObject.Description.Text) > 0 then
        begin
          Description := Format(FormatSQL(DescrHeader), [SLineBreak + TrimRight(DBObject.Description.Text)]);
          Result := Format('%s%s', [Description, ADDL]);
        end else
          Result := ADDL;
      end;
    csCreate, csAlter, csRecreate:
      begin
        Description := FormatSQL(DescrFooter);
        if Assigned(DBDomain)    then Description := Format(Description, [TrimRight(FormatSQL(SQL_SET_COMMENT_DOMAIN))]);
        if Assigned(DBTable)     then Description := Format(Description, [TrimRight(FormatSQL(SQL_SET_COMMENT_TABLE))]);
        if Assigned(DBIndex)     then Description := Format(Description, [TrimRight(FormatSQL(SQL_SET_COMMENT_INDEX))]);
        if Assigned(DBView)      then Description := Format(Description, [TrimRight(FormatSQL(SQL_SET_COMMENT_VIEW))]);
        if Assigned(DBProcedure) then Description := Format(Description, [TrimRight(FormatSQL(SQL_SET_COMMENT_PROCEDURE))]);
        if Assigned(DBTrigger)   then Description := Format(Description, [TrimRight(FormatSQL(SQL_SET_COMMENT_TRIGGER))]);
        if Assigned(DBException) then Description := Format(Description, [TrimRight(FormatSQL(SQL_SET_COMMENT_EXCEPTION))]);
        if Assigned(DBFunction)  then Description := Format(Description, [TrimRight(FormatSQL(SQL_SET_COMMENT_FUNCTION))]);
        if Assigned(DBFilter)    then Description := Format(Description, [TrimRight(FormatSQL(SQL_SET_COMMENT_FILTER))]);
        if Length(DBObject.Description.Text) = 0 then
          Description := Format(Description, ['<description>', DBObject.Caption])
        else
          Description := Format(Description, [TrimRight(DBObject.Description.Text), DBObject.Caption]);
        Result := Format('%s%s', [ADDL, SLineBreak + Description]);
      end;
  end;
end;
*)
(*
function TibBTDDLGenerator.ExcludeDesciption(const ADDL: string): string;
begin
  if Length(DBObject.Description.Text) > 0 then
    Result := AnsiReplaceText(ADDL, Format(FormatSQL(DescrHeader), [SLineBreak + TrimRight(DBObject.Description.Text)]), EmptyStr);
end;
*)

function TibBTDDLGenerator.GetTerminator: string;
begin
  Result := FTerminator;
end;

procedure TibBTDDLGenerator.SetTerminator(Value: string);
begin
  FTerminator := Value;
end;

function TibBTDDLGenerator.GetUseFakeValues: Boolean;
begin
  Result := FUseFakeValues;
end;

procedure TibBTDDLGenerator.SetUseFakeValues(Value: Boolean);
begin
  FUseFakeValues := Value;
end;

procedure TibBTDDLGenerator.SetBasedOnDomain(ADRVQuery: IibSHDRVQuery; ADomain: IibSHDomain; const ACaption: string);
var
  S,S1: string;
  Precision: Integer;
  BasedOnDomain, NeedCharset: Boolean;
  vForceInitDRV:boolean;
begin
  ADomain.Caption := ACaption;
  ADomain.ObjectName := ACaption;
  if ADRVQuery.FieldExists('DESCRIPTION') then
    ADomain.Description.Text := Trim(ADRVQuery.GetFieldStrValue('DESCRIPTION'));
  if ADRVQuery.FieldExists('FIELD_TYPE_ID') then
    ADomain.FieldTypeID := ADRVQuery.GetFieldIntValue('FIELD_TYPE_ID');
  if ADRVQuery.FieldExists('SUB_TYPE_ID') then
    ADomain.SubTypeID := ADRVQuery.GetFieldIntValue('SUB_TYPE_ID');
  if ADRVQuery.FieldExists('CHARSET_ID') then
    ADomain.CharsetID := ADRVQuery.GetFieldIntValue('CHARSET_ID');
  if ADRVQuery.FieldExists('COLLATE_ID') then
    ADomain.CollateID := ADRVQuery.GetFieldIntValue('COLLATE_ID');
  if ADRVQuery.FieldExists('ARRAY_DIM') then
    ADomain.ArrayDimID := ADRVQuery.GetFieldIntValue('ARRAY_DIM');
  if ADRVQuery.FieldExists('NOT_NULL') then
    ADomain.NotNull := ADRVQuery.GetFieldIntValue('NOT_NULL') = 1;

  if ADRVQuery.FieldExists('DEFAULT_SOURCE') then
    ADomain.DefaultExpression.Text := Trim(ADRVQuery.GetFieldStrValue('DEFAULT_SOURCE'))
  else
  if ADRVQuery.FieldExists('DEFAULT_EXPRESSION') then
    ADomain.DefaultExpression.Text := Trim(AnsiReplaceText(ADRVQuery.GetFieldStrValue('DEFAULT_EXPRESSION'), 'DEFAULT', ''))
  else
    ADomain.DefaultExpression.Text := '';

  if ADRVQuery.FieldExists('DEFAULT_SOURCE_OVER') then
   ADomain.DefaultExpression.Text := Trim(ADRVQuery.GetFieldStrValue('DEFAULT_SOURCE_OVER'));
   
  if ADRVQuery.FieldExists('LENGTH_') then
  begin
    ADomain.Length := ADRVQuery.GetFieldIntValue('LENGTH_');
    if ADRVQuery.FieldExists('SYSTEM_FLAG') and
      (ADRVQuery.GetFieldIntValue('SYSTEM_FLAG') = 1) and
      ADRVQuery.FieldExists('FIELD_LENGTH_') then
        ADomain.Length := ADRVQuery.GetFieldIntValue('FIELD_LENGTH_');
  end;
  if ADRVQuery.FieldExists('PRECISION_') then
    {ADomain.}Precision := ADRVQuery.GetFieldIntValue('PRECISION_');
  if ADRVQuery.FieldExists('SCALE') then
    ADomain.Scale := ADRVQuery.GetFieldIntValue('SCALE') * (-1);
  if ADRVQuery.FieldExists('SEGMENT_SIZE') then
    ADomain.SegmentSize := ADRVQuery.GetFieldIntValue('SEGMENT_SIZE');
  if ADRVQuery.FieldExists('CHECK_CONSTRAINT') then
  begin
    ADomain.CheckConstraint.Text := Trim(AnsiReplaceText(ADRVQuery.GetFieldStrValue('CHECK_CONSTRAINT'), 'CHECK', ''));
    ADomain.CheckConstraint.Text := AnsiMidStr(Trim(ADomain.CheckConstraint.Text), 2, Length(Trim(ADomain.CheckConstraint.Text)) - 2);
  end;
  if ADRVQuery.FieldExists('COMPUTED_SOURCE') then
    ADomain.ComputedSource.Text := Trim(ADRVQuery.GetFieldStrValue('COMPUTED_SOURCE'));
  if ADRVQuery.FieldExists('F_BASED_ON_DOMAIN') then
    ADomain.Domain := ADRVQuery.GetFieldStrValue('F_BASED_ON_DOMAIN');

//  if ADRVQuery.FieldExists('F_FIELD_NAME') then
  if ADRVQuery.FieldExists('F_TABLE_NAME') then
    ADomain.TableName := ADRVQuery.GetFieldStrValue('F_TABLE_NAME');

  if Assigned(DBProcedure) then ADomain.TableName := DBProcedure.Caption;

  if ADRVQuery.FieldExists('F_DESCRIPTION') then
    ADomain.Description.Text := Trim(ADRVQuery.GetFieldStrValue('F_DESCRIPTION'));
  if ADRVQuery.FieldExists('F_NOT_NULL') then
    ADomain.FieldNotNull := ADRVQuery.GetFieldIntValue('F_NOT_NULL') = 1;
  if ADRVQuery.FieldExists('F_DEFAULT_EXPRESSION') then
    ADomain.FieldDefault.Text := Trim(AnsiReplaceText(ADRVQuery.GetFieldStrValue('F_DEFAULT_EXPRESSION'), 'DEFAULT', ''));
  ADomain.FieldCollateID := -1;
  if ADRVQuery.FieldExists('F_COLLATE_ID') and not ADRVQuery.GetFieldIsNull('F_COLLATE_ID') and Assigned(DBTable) then
    ADomain.FieldCollateID := ADRVQuery.GetFieldIntValue('F_COLLATE_ID');

    if (ADomain.ArrayDimID > 0) and (ADomain.Domain<>'') then
    begin
{ TODO -oBuzz -cProposal : Все-таки вытащить размеры аррай поля }
    //Buzz
     vForceInitDRV:=FIntDRVQueryIntf=nil;
     if vForceInitDRV then
     begin
      Supports(ADomain, IibSHDBObject, FDBObjectIntf);
      CreateIntDRV;
     end;
    //Buzz
    try
      if Length(ADomain.Domain) > 0 then S := ADomain.Domain else S := ADomain.Caption;
      S1:=FormatSQL(SQL_GET_DIMENSIONS);
      if FIntDRVQueryIntf.ExecSQL(S1, [S], False,True) then
      begin
        while not FIntDRVQueryIntf.Eof do
        begin
          if System.Length(ADomain.ArrayDim) > 0 then ADomain.ArrayDim := Format('%s, ', [ADomain.ArrayDim]);
          ADomain.ArrayDim := Format('%s%s:%s', [ADomain.ArrayDim, FIntDRVQueryIntf.GetFieldStrValue('LOWER_BOUND'), FIntDRVQueryIntf.GetFieldStrValue('UPPER_BOUND')]);
          FIntDRVQueryIntf.Next;
        end;
      end;
      ADomain.ArrayDim := Format('[%s]', [ADomain.ArrayDim]);
      FIntDRVQueryIntf.Close;
      FIntDRVQueryIntf.Transaction.Commit;
     finally
      if vForceInitDRV then
      begin
       FreeIntDRV;
       FDBObjectIntf:=nil
      end
     end ;
    end;

  if ADomain.NotNull then
    ADomain.NullType := NullTypes[1]
  else
    ADomain.NullType := '';

  if ADomain.FieldNotNull then
    ADomain.FieldNullType := NullTypes[1]
  else
    ADomain.FieldNullType := '';
    
  ADomain.SubType := IDToBlobSubType(ADomain.SubTypeID);

  if SameText(Version, SInterBase4x) or
     SameText(Version, SInterBase5x) or
     SameText(Version, SInterBase6x) or
     SameText(Version, SInterBase65) or
     SameText(Version, SFirebird1x) then
  begin
    ADomain.Charset := GetCharsetFromIDFB10(ADomain.CharsetID);
    ADomain.Collate := GetCollateFromIDFB10(ADomain.CharsetID, ADomain.CollateID);
    if ADomain.FieldCollateID <> -1 then
      ADomain.FieldCollate := GetCollateFromIDFB10(ADomain.CharsetID, ADomain.FieldCollateID);
  end
  else
  if SameText(Version, SFirebird15) then
  begin
    ADomain.Charset := GetCharsetFromIDFB15(ADomain.CharsetID);
    ADomain.Collate := GetCollateFromIDFB15(ADomain.CharsetID, ADomain.CollateID);
    if ADomain.FieldCollateID <> -1 then
      ADomain.FieldCollate := GetCollateFromIDFB15(ADomain.CharsetID, ADomain.FieldCollateID);
  end
  else
  if SameText(Version, SFirebird20) then
  begin
    ADomain.Charset := GetCharsetFromIDFB20(ADomain.CharsetID);
    ADomain.Collate := GetCollateFromIDFB20(ADomain.CharsetID, ADomain.CollateID);
    if ADomain.FieldCollateID <> -1 then
      ADomain.FieldCollate := GetCollateFromIDFB20(ADomain.CharsetID, ADomain.FieldCollateID);
  end
  else
  if SameText(Version, SFirebird21) then
  begin
    ADomain.Charset := GetCharsetFromIDFB21(ADomain.CharsetID);
    ADomain.Collate := GetCollateFromIDFB21(ADomain.CharsetID, ADomain.CollateID);
    if ADomain.FieldCollateID <> -1 then
      ADomain.FieldCollate := GetCollateFromIDFB21(ADomain.CharsetID, ADomain.FieldCollateID);
  end
  else
  if SameText(Version, SInterBase70) then
  begin
    ADomain.Charset := GetCharsetFromIDIB70(ADomain.CharsetID);
    ADomain.Collate := GetCollateFromIDIB70(ADomain.CharsetID, ADomain.CollateID);
    if ADomain.FieldCollateID <> -1 then
      ADomain.FieldCollate := GetCollateFromIDIB70(ADomain.CharsetID, ADomain.FieldCollateID);
  end
  else
  if SameText(Version, SInterBase71) then
  begin
    ADomain.Charset := GetCharsetFromIDIB71(ADomain.CharsetID);
    ADomain.Collate := GetCollateFromIDIB71(ADomain.CharsetID, ADomain.CollateID);
    if ADomain.FieldCollateID <> -1 then
      ADomain.FieldCollate := GetCollateFromIDIB71(ADomain.CharsetID, ADomain.FieldCollateID);
  end
  else
  if SameText(Version, SInterBase75) or SameText(Version, SInterBase2007) then
  begin
    ADomain.Charset := GetCharsetFromIDIB75(ADomain.CharsetID);
    ADomain.Collate := GetCollateFromIDIB75(ADomain.CharsetID, ADomain.CollateID);
    if ADomain.FieldCollateID <> -1 then
      ADomain.FieldCollate := GetCollateFromIDIB75(ADomain.CharsetID, ADomain.FieldCollateID);
  end;

  case ADomain.FieldTypeID of
    _SMALLINT:
      begin
        ADomain.DataType := Get_SMALLINT({ADomain.}Precision, ADomain.Scale, ADomain.SubTypeID);
        ADomain.DataTypeExt := Get_SMALLINT({ADomain.}Precision, ADomain.Scale, ADomain.SubTypeID, True);
      end;
    _INTEGER:
      begin
        ADomain.DataType := Get_INTEGER({ADomain.}Precision, ADomain.Scale, ADomain.SubTypeID);
        ADomain.DataTypeExt := Get_INTEGER({ADomain.}Precision, ADomain.Scale, ADomain.SubTypeID, True);
      end;
    _BIGINT:
      begin
        ADomain.DataType := Get_BIGINT({ADomain.}Precision, ADomain.Scale, ADomain.SubTypeID);
        ADomain.DataTypeExt := Get_BIGINT({ADomain.}Precision, ADomain.Scale, ADomain.SubTypeID, True);
      end;
    _BOOLEAN:
      begin
        ADomain.DataType := Get_BOOLEAN;
        ADomain.DataTypeExt := Get_BOOLEAN;
      end;
    _FLOAT:
      begin
        ADomain.DataType := Get_FLOAT({ADomain.}Precision, ADomain.Scale);
        ADomain.DataTypeExt := Get_FLOAT({ADomain.}Precision, ADomain.Scale, True);
      end;
    _DOUBLE:
      begin
        ADomain.DataType := Get_DOUBLE({ADomain.}Precision, ADomain.Scale);
        ADomain.DataTypeExt := Get_DOUBLE({ADomain.}Precision, ADomain.Scale, True);
      end;
    _DATE:
      begin
        ADomain.DataType := Get_DATE;
        ADomain.DataTypeExt := Get_DATE;
      end;
    _TIME:
      begin
        ADomain.DataType := Get_TIME;
        ADomain.DataTypeExt := Get_TIME;
      end;
    _TIMESTAMP:
      begin
        ADomain.DataType := Get_TIMESTAMP(Dialect);
        ADomain.DataTypeExt := Get_TIMESTAMP(Dialect);
      end;
    _CHAR:
      begin
        ADomain.DataType := Get_CHAR(ADomain.Length);
        ADomain.DataTypeExt := Get_CHAR(ADomain.Length, True);
      end;
    _VARCHAR:
      begin
        ADomain.DataType := Get_VARCHAR(ADomain.Length);
        ADomain.DataTypeExt := Get_VARCHAR(ADomain.Length, True);
      end;
    _BLOB:
      begin
        ADomain.DataType := Get_BLOB(ADomain.SubTypeID, ADomain.SegmentSize);
        ADomain.DataTypeExt := Get_BLOB(ADomain.SubTypeID, ADomain.SegmentSize, True);

        if (ADomain.SubTypeID <> 1) then ADomain.Charset := EmptyStr;
        ADomain.Collate := EmptyStr
      end;
    _CSTRING:
      begin
        ADomain.DataType := Get_CSTRING(ADomain.Length);
        ADomain.DataTypeExt := Get_CSTRING(ADomain.Length, True);
      end;
    _QUAD:
      begin
         ADomain.DataType := Get_QUAD;
         ADomain.DataTypeExt := Get_QUAD;
      end;
  end;
  ADomain.Precision := Precision;

  // For Fields
  BasedOnDomain := not IsSystemDomain(ADomain.Domain); // Pos('RDB$', ADomain.Domain) = 0;
  NeedCharset := not AnsiSameText(ADomain.Charset, DBCharset);



  ADomain.DataTypeField := Format('%s', [ADomain.DataTypeExt]);
  ADomain.DataTypeFieldExt := Format('%s', [ADomain.DataTypeExt]);
  case ADomain.FieldTypeID of
    _SMALLINT, _INTEGER, _BIGINT, _BOOLEAN, _FLOAT, _DOUBLE,
    _DATE, _TIME, _TIMESTAMP,
    _CHAR, _VARCHAR:
      begin
        if Length(ADomain.ArrayDim) > 0 then
        begin
          ADomain.DataTypeField := Format('%s %s', [ADomain.DataTypeField, ADomain.ArrayDim]);
          ADomain.DataTypeFieldExt := Format('%s %s', [ADomain.DataTypeFieldExt, ADomain.ArrayDim]);
        end;
      end;
  end;
  case ADomain.FieldTypeID of
    _CHAR, _VARCHAR:
      if NeedCharset then
      begin
        ADomain.DataTypeField := Format('%s CHARACTER SET %s', [ADomain.DataTypeField, ADomain.Charset]);
        ADomain.DataTypeFieldExt := Format('%s CHARACTER SET %s', [ADomain.DataTypeFieldExt, ADomain.Charset]);
      end;
   _BLOB:
      if NeedCharset and (ADomain.SubTypeID = 1) then
      begin
        ADomain.DataTypeField := Format('%s CHARACTER SET %s', [ADomain.DataTypeField, ADomain.Charset]);
        ADomain.DataTypeFieldExt := Format('%s CHARACTER SET %s', [ADomain.DataTypeFieldExt, ADomain.Charset]);
      end;
  end;

  if BasedOnDomain and (ADomain.Domain<>'') then
  begin
   if not ADRVQuery.FieldExists('MECHANIZM') or (ADRVQuery.GetFieldIntValue('MECHANIZM')=0) then
    ADomain.DataTypeField := Format('%s', [NormalizeName(ADomain.Domain)])
   else
    ADomain.DataTypeField := Format('TYPE OF %s', [NormalizeName(ADomain.Domain)])
  end
  else
    ADomain.DataTypeField := ADomain.DataTypeExt;

  // DecodeDomains
  if Assigned(DBTable) and not DBTable.DecodeDomains and BasedOnDomain then
    ADomain.DataTypeFieldExt := Format('%s', [NormalizeName(ADomain.Domain)]);


  if Length(ADomain.FieldDefault.Text) > 0 then
  begin
    ADomain.DataTypeField := Format('%s DEFAULT %s', [ADomain.DataTypeField, Trim(ADomain.FieldDefault.Text)]);
    ADomain.DataTypeFieldExt := Format('%s DEFAULT %s', [ADomain.DataTypeFieldExt, Trim(ADomain.FieldDefault.Text)]);
  end;

  // DecodeDomains
  if Assigned(DBTable) and DBTable.DecodeDomains and (Length(ADomain.FieldDefault.Text) = 0) then
  begin
    if Length(ADomain.DefaultExpression.Text) > 0 then
      ADomain.DataTypeFieldExt := Format('%s DEFAULT %s', [ADomain.DataTypeFieldExt, Trim(ADomain.DefaultExpression.Text)]);
  end;

  if ADomain.FieldNotNull then
    ADomain.DataTypeField := Format('%s %s', [ADomain.DataTypeField, ADomain.FieldNullType]);

  // DecodeDomains
  if Assigned(DBTable) and DBTable.DecodeDomains {and not ADomain.FieldNotNull} then
  begin
    if ADomain.NotNull then
      ADomain.DataTypeFieldExt := Format('%s %s', [ADomain.DataTypeFieldExt, ADomain.NullType])
    else
    begin
      if ADomain.FieldNotNull then
        ADomain.DataTypeFieldExt := Format('%s %s', [ADomain.DataTypeFieldExt, ADomain.FieldNullType]);
    end;
  end;

  // DecodeDomains
  if Assigned(DBTable) and DBTable.DecodeDomains and (Length(ADomain.CheckConstraint.Text) > 0) then
    ADomain.DataTypeFieldExt := Format('%s CHECK (%s)', [ADomain.DataTypeFieldExt, Trim(AnsiReplaceText(ADomain.CheckConstraint.Text, 'VALUE', NormalizeName(ACaption)))]);

  case ADomain.FieldTypeID of
    _CHAR, _VARCHAR:
      begin
        if not BasedOnDomain then
        begin
          if ADomain.FieldCollateID = -1 then
          begin
            if not AnsiSameText(ADomain.Charset, ADomain.Collate) then
              ADomain.DataTypeField := Format('%s COLLATE %s', [ADomain.DataTypeField, ADomain.FieldCollate]);
          end else
          begin
            if not AnsiSameText(ADomain.Charset, ADomain.FieldCollate) then
              ADomain.DataTypeField := Format('%s COLLATE %s', [ADomain.DataTypeField, ADomain.FieldCollate]);
          end;
          // DecodeDomains
          if Assigned(DBTable) and DBTable.DecodeDomains then
            if (Length(ADomain.Collate) > 0) and not AnsiSameText(ADomain.Charset, ADomain.Collate) then
              ADomain.DataTypeFieldExt := Format('%s COLLATE %s', [ADomain.DataTypeFieldExt, ADomain.Collate]);
        end;
        if BasedOnDomain and (ADomain.FieldCollateID <> - 1) {and (AnsiSameText(ADomain.Collate, ADomain.FieldCollate) <> 0)} then
          ADomain.DataTypeField := Format('%s COLLATE %s', [ADomain.DataTypeField, ADomain.FieldCollate]);
      end;
  end;

  if Length(ADomain.ComputedSource.Text) > 0 then
  begin
    ADomain.DataTypeField := Format('COMPUTED BY %s', [Trim(ADomain.ComputedSource.Text)]);
    ADomain.DataTypeFieldExt := Format('COMPUTED BY %s', [Trim(ADomain.ComputedSource.Text)]);
  end;

  if (ADomain.DataType = 'SMALLINT') or
     (ADomain.DataType = 'INTEGER') or
     (ADomain.DataType = 'BOOLEAN') or
     (ADomain.DataType = 'BIGINT') or
     (ADomain.DataType = 'FLOAT') or
     (ADomain.DataType = 'DOUBLE PRECISION') or
     (ADomain.DataType = 'DATE') or
     (ADomain.DataType = 'TIME') or
     (ADomain.DataType = 'TIMESTAMP') or
     (ADomain.DataType = 'NUMERIC') or
     (ADomain.DataType = 'DECIMAL') or
     (Length(ADomain.ComputedSource.Text) > 0) then
  begin
    ADomain.Charset := '';
    ADomain.Collate := '';
  end;
end;

procedure TibBTDDLGenerator.SetRealValues;
const
  sh: array [0..2] of Integer = (1, 3, 5);
var
  I: Integer;
  SQL: string;
  // For Trigger
  Active, TriggerTypeID: Integer;
  vSuf, vDelim: string;
  // For Function
  ReturnsParamPos, Mechanism: Integer;
  RefConstraint, RefIndex: string;
  // For Query
  varDomain: IibSHDomain;
  varPrecision: Integer;
  MaxStrLength:Integer;
  S :String;
  S1:String;
begin
  if Assigned(DBDomain) then
  begin
    if not ExistsPrecision then
      SQL := FormatSQL(SQL_INIT_DOMAIN1)
    else
      SQL := FormatSQL(SQL_INIT_DOMAIN3);


     if DRVQuery.ExecSQL(SQL, [DBDomain.Caption], False,True) then
     begin
      DBDomain.ObjectName := DBDomain.Caption;
      SetBasedOnDomain(DRVQuery, DBDomain as IibSHDomain, DBDomain.Caption);
     end;
     DRVQuery.Transaction.Commit;
  end
  else
  if Assigned(DBTable) then
  begin
    if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_TABLE), [DBTable.Caption], False,True) then
    begin
      DBTable.ObjectName := DBTable.Caption;
      DBTable.OwnerName := DRVQuery.GetFieldStrValue('OWNER_NAME');
      DBTable.Description.Text := Trim(DRVQuery.GetFieldStrValue('DESCRIPTION'));
      DBTable.SetExternalFile(DRVQuery.GetFieldStrValue('EXTERNAL_FILE'));
      DBTable.Triggers.Clear;
      if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_TABLE_TRIGGERS), [DBTable.Caption], False,True) then
      begin
        while not DRVQuery.Eof do
        begin
          DBTable.Triggers.Add(DRVQuery.GetFieldStrValue('TRIGGER_NAME'));
          DRVQuery.Next;
        end;
      end;

      DBTable.Constraints.Clear;
      if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_TABLE_CONSTRAINTS_PRIMARY), [DBTable.Caption], False,True) then
      begin
        while not DRVQuery.Eof do
        begin
          DBTable.Constraints.Add(DRVQuery.GetFieldStrValue('CONSTRAINT_NAME'));
          DRVQuery.Next;
        end;
      end;

      if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_TABLE_CONSTRAINTS_UNIQUE), [DBTable.Caption], False,True) then
      begin
        while not DRVQuery.Eof do
        begin
          DBTable.Constraints.Add(DRVQuery.GetFieldStrValue('CONSTRAINT_NAME'));
          DRVQuery.Next;
        end;
      end;

      if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_TABLE_CONSTRAINTS_FOREIGN), [DBTable.Caption], False,True) then
      begin
        while not DRVQuery.Eof do
        begin
          DBTable.Constraints.Add(DRVQuery.GetFieldStrValue('CONSTRAINT_NAME'));
          DRVQuery.Next;
        end;
      end;

      if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_TABLE_CONSTRAINTS_CHECK), [DBTable.Caption], False,True) then
      begin
        while not DRVQuery.Eof do
        begin
          DBTable.Constraints.Add(DRVQuery.GetFieldStrValue('CONSTRAINT_NAME'));
          DRVQuery.Next;
        end;
      end;

      DBTable.Indices.Clear;
      if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_TABLE_INDICES), [DBTable.Caption], False,True) then
      begin
        while not DRVQuery.Eof do
        begin
          DBTable.Indices.Add(DRVQuery.GetFieldStrValue('INDEX_NAME'));
          DRVQuery.Next;
        end;
      end;

      if not ExistsPrecision then
        SQL := FormatSQL(SQL_INIT_TABLE_FIELDS1)
      else
        SQL := FormatSQL(SQL_INIT_TABLE_FIELDS3);

      DBTable.Fields.Clear;
      if DRVQuery.ExecSQL(FormatSQL(SQL), [DBTable.Caption], False,True) then
      begin
        while not DRVQuery.Eof do
        begin
          if DBTable.WithoutComputed and DRVQuery.FieldExists('COMPUTED_SOURCE') and
             (Length(Trim(DRVQuery.GetFieldStrValue('COMPUTED_SOURCE'))) > 0) then
          begin
           // skip
           DRVQuery.Next;
           Continue;
          end;

          DBTable.Fields.Add(DRVQuery.GetFieldStrValue('F_FIELD_NAME'));
          SetBasedOnDomain(DRVQuery,
            DBTable.GetField(Pred(DBTable.Fields.Count)) as IibSHDomain,
            DRVQuery.GetFieldStrValue('F_FIELD_NAME'));
          DRVQuery.Next;
        end;
      end;

    end;
    DRVQuery.Transaction.Commit;
  end
  else
  if Assigned(DBField) then
  begin
  end
  else
  if Assigned(DBConstraint) then
  begin
    if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_CONSTRAINT), [DBConstraint.Caption], False,True) then
    begin
      DBConstraint.ObjectName     := DBConstraint.Caption;
      DBConstraint.ConstraintType := DRVQuery.GetFieldStrValue('CONSTRAINT_TYPE');
      DBConstraint.TableName      := DRVQuery.GetFieldStrValue('TABLE_NAME');
      DBConstraint.IndexName      := DRVQuery.GetFieldStrValue('INDEX_NAME');

      if Length(DBConstraint.IndexName) > 0 then
      begin
        if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_CONSTRAINT_INDEX), [DBConstraint.IndexName], False,True) then
        DBConstraint.IndexSorting := Sortings[DRVQuery.GetFieldIntValue('ASCENDING_')];
      end;

      if SameText(DBConstraint.ConstraintType, 'PRIMARY KEY') or
         SameText(DBConstraint.ConstraintType, 'UNIQUE') then
      begin
        DBConstraint.Fields.Clear;
        if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_CONSTRAINT_FIELDS), [DBConstraint.IndexName], False,True) then
        begin
          while not DRVQuery.Eof do
          begin
            DBConstraint.Fields.Add(DRVQuery.GetFieldStrValue('FIELD_NAME'));
            DRVQuery.Next;
          end;
        end;
        DBConstraint.MakePropertyInvisible('ReferenceTable');
        DBConstraint.MakePropertyInvisible('ReferenceFields');
        DBConstraint.MakePropertyInvisible('OnDeleteRule');
        DBConstraint.MakePropertyInvisible('OnUpdateRule');
        DBConstraint.MakePropertyInvisible('CheckSource');
      end
      else
      if SameText(DBConstraint.ConstraintType, 'FOREIGN KEY') then
      begin
        DBConstraint.Fields.Clear;
        if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_CONSTRAINT_FIELDS), [DBConstraint.IndexName], False,True) then
        begin
          while not DRVQuery.Eof do
          begin
            DBConstraint.Fields.Add(DRVQuery.GetFieldStrValue('FIELD_NAME'));
            DRVQuery.Next;
          end;
        end;

        if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_CONSTRAINT_REFERENCE), [DBConstraint.Caption], False,True) then
        begin
          RefConstraint := DRVQuery.GetFieldStrValue('CONST_NAME_UQ');
          DBConstraint.OnUpdateRule := DRVQuery.GetFieldStrValue('UPDATE_RULE');
          if SameText(DBConstraint.OnUpdateRule, 'RESTRICT') then DBConstraint.OnUpdateRule := ConstraintRules[0];
          DBConstraint.OnDeleteRule := DRVQuery.GetFieldStrValue('DELETE_RULE');
          if SameText(DBConstraint.OnDeleteRule, 'RESTRICT') then DBConstraint.OnDeleteRule := ConstraintRules[0];
        end;

        if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_CONSTRAINT), [RefConstraint], False,True) then
        begin
          DBConstraint.ReferenceTable := DRVQuery.GetFieldStrValue('TABLE_NAME');
          RefIndex                    := DRVQuery.GetFieldStrValue('INDEX_NAME')
        end;

        DBConstraint.ReferenceFields.Clear;
        if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_CONSTRAINT_FIELDS), [RefIndex], False,True) then
        begin
          while not DRVQuery.Eof do
          begin
            DBConstraint.ReferenceFields.Add(DRVQuery.GetFieldStrValue('FIELD_NAME'));
            DRVQuery.Next;
          end;
        end;
        DBConstraint.MakePropertyInvisible('CheckSource');
      end
      else
      if SameText(DBConstraint.ConstraintType, 'CHECK') then
      begin
        if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_CONSTRAINT_CHECK), [DBConstraint.Caption], False,True) then
          DBConstraint.CheckSource.Text := TrimRight(DRVQuery.GetFieldStrValue('SOURCE'));
        DBConstraint.Fields.Text := DBConstraint.CheckSource.Text;
        DBConstraint.Fields.Text := Trim(AnsiReplaceText(DBConstraint.Fields.Text, 'CHECK', ''));
        DBConstraint.Fields.Text := AnsiMidStr(Trim(DBConstraint.Fields.Text), 2, Length(Trim(DBConstraint.Fields.Text)) - 2);
        DBConstraint.CheckSource.Text := DBConstraint.Fields.Text;
        DBConstraint.Fields.Clear;

        DBConstraint.MakePropertyInvisible('Fields');
        DBConstraint.MakePropertyInvisible('ReferenceTable');
        DBConstraint.MakePropertyInvisible('ReferenceFields');
        DBConstraint.MakePropertyInvisible('OnUpdateRule');
        DBConstraint.MakePropertyInvisible('OnDeleteRule');
        DBConstraint.MakePropertyInvisible('IndexName');
        DBConstraint.MakePropertyInvisible('IndexSorting');
      end;

      DRVQuery.Transaction.Commit;
    end;
  end
  else
  if Assigned(DBIndex) then
  begin
    if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_INDEX), [DBIndex.Caption], False,True) then
    begin
      DBIndex.ObjectName       := DBIndex.Caption;
      DBIndex.IndexTypeID      := DRVQuery.GetFieldIntValue('UNIQUE_FLAG');
      DBIndex.SortingID        := DRVQuery.GetFieldIntValue('ASCENDING_');
      DBIndex.StatusID         := DRVQuery.GetFieldIntValue('IN_ACTIVE');
      DBIndex.TableName        := DRVQuery.GetFieldStrValue('TABLE_NAME');
      DBIndex.Expression.Text  := Trim(DRVQuery.GetFieldStrValue('EXPRESSION_SOURCE'));
      DBIndex.Description.Text := Trim(DRVQuery.GetFieldStrValue('DESCRIPTION'));
      DBIndex.Statistics       := FloatToStrF(DRVQuery.GetFieldFloatValue('STATISTIC'), ffNumber, 15, 15);
      if DRVQuery.ExecSQL(FormatSQL(SQL_IS_CONSTRAINT_INDEX), [DBIndex.Caption], False,True) then
        DBIndex.IsConstraintIndex:=DRVQuery.GetFieldIntValue(0)>0
      else
        DBIndex.IsConstraintIndex:=False;


      DBIndex.IndexType := IndexTypes[DBIndex.IndexTypeID];
      DBIndex.Sorting := Sortings[DBIndex.SortingID];
      DBIndex.Status := Statuses[DBIndex.StatusID];

      DBIndex.Fields.Clear;
      if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_INDEX_FIELDS), [DBIndex.Caption], False,True) then
      begin
        while not DRVQuery.Eof do
        begin
          DBIndex.Fields.Add(DRVQuery.GetFieldStrValue('FIELD_NAME'));
          DRVQuery.Next;
        end;
      end;
      DRVQuery.Transaction.Commit;
    end;
  end
  else
  if Assigned(DBView) then
  begin
    if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_VIEW), [DBView.Caption], False,True) then
    begin
      DBView.ObjectName       := DBView.Caption;
      DBView.OwnerName        := DRVQuery.GetFieldStrValue('OWNER_NAME');
      DBView.BodyText.Text    := TrimRight(DRVQuery.GetFieldStrValue('SOURCE'));
      DBView.Description.Text := Trim(DRVQuery.GetFieldStrValue('DESCRIPTION'));

      if not ExistsPrecision then
        SQL := FormatSQL(SQL_INIT_TABLE_FIELDS1)
      else
        SQL := FormatSQL(SQL_INIT_TABLE_FIELDS3);

      DBView.Fields.Clear;
      if DRVQuery.ExecSQL(FormatSQL(SQL), [DBView.Caption], False,True) then
      begin
        while not DRVQuery.Eof do
        begin
          DBView.Fields.Add(DRVQuery.GetFieldStrValue('F_FIELD_NAME'));
          SetBasedOnDomain(DRVQuery,
            DBView.GetField(Pred(DBView.Fields.Count)) as IibSHDomain,
            DRVQuery.GetFieldStrValue('F_FIELD_NAME'));
          DRVQuery.Next;
        end;
      end;

      DBView.Triggers.Clear;
      if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_TABLE_TRIGGERS), [DBView.Caption], False,True) then
      begin
        while not DRVQuery.Eof do
        begin
          DBView.Triggers.Add(DRVQuery.GetFieldStrValue('TRIGGER_NAME'));
          DRVQuery.Next;
        end;
      end;
      DRVQuery.Transaction.Commit;
    end;
  end
  else
  if Assigned(DBProcedure) then
  begin
    if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_PROCEDURE), [DBProcedure.Caption], False,True) then
    begin
      DBProcedure.ObjectName       := DBProcedure.Caption;
      DBProcedure.OwnerName        := DRVQuery.GetFieldStrValue('OWNER_NAME');
      DBProcedure.BodyText.Text    := TrimRight(DRVQuery.GetFieldStrValue('SOURCE'));
      DBProcedure.Description.Text := Trim(DRVQuery.GetFieldStrValue('DESCRIPTION'));

      if not ExistsPrecision then
        SQL := FormatSQL(SQL_INIT_PROCEDURE_PARAMS1)
      else
      if not FExistsProcParamDomains then
        SQL := FormatSQL(SQL_INIT_PROCEDURE_PARAMS3)
      else
        SQL := FormatSQL(SQL_INIT_PROCEDURE_PARAMS4);

      DBProcedure.Params.Clear;
      DBProcedure.ParamsExt.Clear;
      if DRVQuery.ExecSQL(SQL, [DBProcedure.Caption, 0], False,True) then
      begin
        while not DRVQuery.Eof do
        begin
          DBProcedure.Params.Add(DRVQuery.GetFieldStrValue('PARAMETER_NAME'));
          SetBasedOnDomain(DRVQuery,
            DBProcedure.GetParam(Pred(DBProcedure.Params.Count)) as IibSHDomain,
            DRVQuery.GetFieldStrValue('PARAMETER_NAME')
          );
          DRVQuery.Next;
        end;
      end;

      DBProcedure.Returns.Clear;
      DBProcedure.ReturnsExt.Clear;
      if DRVQuery.ExecSQL(SQL, [DBProcedure.Caption, 1], False,True) then
      begin
        while not DRVQuery.Eof do
        begin
          DBProcedure.Returns.Add(DRVQuery.GetFieldStrValue('PARAMETER_NAME'));
          SetBasedOnDomain(DRVQuery,
            DBProcedure.GetReturn(Pred(DBProcedure.Returns.Count)) as IibSHDomain,
            DRVQuery.GetFieldStrValue('PARAMETER_NAME'));
          DRVQuery.Next;
        end;
      end;
      DRVQuery.Transaction.Commit;
    end;

    MaxStrLength := GetMaxStrLength(DBProcedure.Params);

    for I := 0 to Pred(DBProcedure.Params.Count) do
    with DBProcedure do
    begin
      S:=GetParam(I).DataTypeField;
      S1:=NormalizeName(Params[I]);
      S:=Trim(Format('%s %s %s %s',[S1, SpaceGenerator(MaxStrLength, S1),S , Trim(GetParam(I).DefaultExpression.Text)]));
      if I <> Pred(DBProcedure.Params.Count) then
        ParamsExt.Add(S+',')
      else
        ParamsExt.Add(S);
    end;

    MaxStrLength := GetMaxStrLength(DBProcedure.Returns);
    for I := 0 to Pred(DBProcedure.Returns.Count) do
    with DBProcedure do
    begin
      S:=GetReturn(I).DataTypeField;
      S1:=NormalizeName(Returns[I]);
      S:=Trim(Format('%s %s %s %s',[S1,SpaceGenerator(MaxStrLength, S1) ,S , Trim(GetReturn(I).DefaultExpression.Text)]));
      if I <> Pred(DBProcedure.Returns.Count) then
       DBProcedure.ReturnsExt.Add(S+',')
      else
       DBProcedure.ReturnsExt.Add(S)
    end;
  end
  else
  if Assigned(DBTrigger) then
  begin
    if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_TRIGGER), [DBTrigger.Caption], False,True) then
    begin
      DBTrigger.ObjectName       := DBTrigger.Caption;
      DBTrigger.TableName        := DRVQuery.GetFieldStrValue('TABLE_NAME');
      DBTrigger.Position         := DRVQuery.GetFieldIntValue('POSITION1');
      DBTrigger.BodyText.Text    := TrimRight(DRVQuery.GetFieldStrValue('SOURCE'));
      DBTrigger.Description.Text := Trim(DRVQuery.GetFieldStrValue('DESCRIPTION'));
      Active                     := DRVQuery.GetFieldIntValue('IN_ACTIVE');
      TriggerTypeID              := DRVQuery.GetFieldIntValue('TRIGGER_TYPE_ID');
      DRVQuery.Transaction.Commit;

      if IntToBooleanInvers(Active) then DBTrigger.Status := Statuses[0] else DBTrigger.Status := Statuses[1];
      vSuf := '';
      vDelim := '';

      if (Length(DBTrigger.TableName)=0) then
      begin
        DBTrigger.TypePrefix := 'ON';
        case  Byte(TriggerTypeID) of
         0:vSuf :=' CONNECT ';
         1:vSuf :=' DISCONNECT ';
         2:vSuf :=' TRANSACTION START ';
         3:vSuf :=' TRANSACTION COMMIT ';
         4:vSuf :=' TRANSACTION ROLLBACK ';
        end
      end
      else
      begin
       DBTrigger.TypePrefix := TypePrefixes[(TriggerTypeID + 1) and 1];
       for I := 0 to 2 do
        case (((TriggerTypeID + 1) shr sh[I]) and 3) of
          1: begin
               vSuf := 'INSERT';
               vDelim := ' OR ';
             end;
          2: begin
               if System.Length(vSuf) > 0 then
                 vSuf := vSuf + vDelim + 'UPDATE'
               else
               begin
                 vSuf := 'UPDATE';
                 vDelim := ' OR ';
               end;
             end;
          3: begin
               if System.Length(vSuf) > 0 then
                 vSuf := vSuf + vDelim + 'DELETE'
               else
                 vSuf := 'DELETE';
             end;
        end;
      end;
      DBTrigger.TypeSuffix := vSuf;
    end;
  end
  else
  if Assigned(DBGenerator) then
  begin
    if DRVQuery.ExecSQL(Format(FormatSQL(SQL_INIT_GENERATOR), [NormalizeName(DBGenerator.Caption)]), [], False) then
    begin
      DBGenerator.ObjectName := DBGenerator.Caption;
      DBGenerator.Value := DRVQuery.GetFieldInt64Value(0);
      DRVQuery.Transaction.Commit;
    end;
  end
  else
  if Assigned(DBException) then
  begin
    if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_EXCEPTION), [DBException.Caption], False,True) then
    begin
      DBException.ObjectName       := DBException.Caption;
      DBException.Text             := DRVQuery.GetFieldStrValue('TEXT');
      DBException.Number           := DRVQuery.GetFieldIntValue('NUMBER_');
      DBException.Description.Text := Trim(DRVQuery.GetFieldStrValue('DESCRIPTION'));
      DRVQuery.Transaction.Commit;
    end;
  end
  else
  if Assigned(DBFunction) then
  begin
    I := 0;
    if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_FUNCTION), [DBFunction.Caption], False,True) then
    begin
      DBFunction.ObjectName       := DBFunction.Caption;
      DBFunction.EntryPoint       := DRVQuery.GetFieldStrValue('ENTRYPOINT');
      DBFunction.ModuleName       := DRVQuery.GetFieldStrValue('MODULENAME');
      DBFunction.Description.Text := Trim(DRVQuery.GetFieldStrValue('DESCRIPTION'));
      ReturnsParamPos             := DRVQuery.GetFieldIntValue('RETURN_ARGUMENT');
      DBFunction.ReturnsArgument  := ReturnsParamPos;

      if not ExistsPrecision then
        SQL := FormatSQL(SQL_INIT_FUNCTION_ARGUMENTS1)
      else
        SQL := FormatSQL(SQL_INIT_FUNCTION_ARGUMENTS3);

      DBFunction.Params.Clear;
      DBFunction.Returns.Clear;
      if DRVQuery.ExecSQL(SQL, [DBFunction.Caption], False,True) then
      begin
        while not DRVQuery.Eof do
        begin
          DBFunction.Params.Add(' ');
          SetBasedOnDomain(DRVQuery,
            DBFunction.GetParam(Pred(DBFunction.Params.Count)) as IibSHDomain,
            EmptyStr);
          DBFunction.Params[I] := DBFunction.GetParam(I).DataTypeExt;

          Mechanism := DRVQuery.GetFieldIntValue('MECHANISM');

          case Mechanism of
           -1: DBFunction.Params[I] := Format('%s %s', [DBFunction.Params[I], 'FREE_IT']);
            0: DBFunction.Params[I] := Format('%s %s', [DBFunction.Params[I], 'BY VALUE']);
            2: DBFunction.Params[I] := Format('%s %s', [DBFunction.Params[I], 'BY DESCRIPTOR']);
          end;

          Inc(I);
          DRVQuery.Next;
        end;
      end;

      DRVQuery.Transaction.Commit;

      if ReturnsParamPos = 0 then
      begin
        DBFunction.Returns.Add(DBFunction.Params[0]);
        DBFunction.Params.Delete(0);
      end else
        DBFunction.Returns.Add(Format('PARAMETER %d', [DBFunction.ReturnsArgument]));

    end;
  end
  else
  if Assigned(DBFilter) then
  begin
    if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_FILTER), [DBFilter.Caption], False,True) then
    begin
      DBFilter.ObjectName       := DBFilter.Caption;
      DBFilter.InputType        := DRVQuery.GetFieldIntValue('INPUT_SUB_TYPE');
      DBFilter.OutputType       := DRVQuery.GetFieldIntValue('OUTPUT_SUB_TYPE');
      DBFilter.EntryPoint       := DRVQuery.GetFieldStrValue('ENTRYPOINT');
      DBFilter.ModuleName       := DRVQuery.GetFieldStrValue('MODULENAME');
      DBFilter.Description.Text := Trim(DRVQuery.GetFieldStrValue('DESCRIPTION'));
      DRVQuery.Transaction.Commit;
    end;
  end
  else
  if Assigned(DBRole) then
  begin
    if DRVQuery.ExecSQL(FormatSQL(SQL_INIT_ROLE), [DBRole.Caption], False,True) then
    begin
      DBRole.ObjectName := DBRole.Caption;
      DBRole.OwnerName  := DRVQuery.GetFieldStrValue('OWNER_NAME');
      DRVQuery.Transaction.Commit;
    end;
  end
  else
  if Assigned(DBShadow) then
  begin
  end
  else
  if Assigned(DBQuery) and Assigned(DBQuery.Data) then
  begin
    DBQuery.ObjectName := 'EMPTY';;
    DBQuery.OwnerName := 'EMPTY';
    DBQuery.Description.Text := 'EMPTY';

    if not ExistsPrecision then
      SQL := FormatSQL(SQL_INIT_QUERY_FIELDS1)
    else
      SQL := FormatSQL(SQL_INIT_QUERY_FIELDS3);

    DBQuery.Fields.Clear;
    for I := 0 to Pred(DBQuery.Data.Dataset.Dataset.FieldCount) do
    begin
      //if DBQuery.Data.Dataset.GetRelationFieldName(I) = 'DB_KEY' then Continue;
      if (DBQuery.Data.Dataset.Dataset.Fields[I].FieldKind <> fkCalculated) and
        (Length(Trim(DBQuery.Data.Dataset.GetRelationTableName(I))) > 0) then
      begin
        if DRVQuery.ExecSQL(FormatSQL(SQL),
          [DBQuery.Data.Dataset.GetRelationTableName(I),
           DBQuery.Data.Dataset.GetRelationFieldName(I)], False,True) then
        begin
          DBQuery.Fields.Add(DBQuery.Data.Dataset.Dataset.Fields[I].FieldName);
          SetBasedOnDomain(DRVQuery,
            DBQuery.GetField(Pred(DBQuery.Fields.Count)) as IibSHDomain,
            DRVQuery.GetFieldStrValue('F_FIELD_NAME'));
        end
      end
      else
      begin
        DBQuery.Fields.Add(DBQuery.Data.Dataset.Dataset.Fields[I].FieldName);
        varDomain := DBQuery.GetField(Pred(DBQuery.Fields.Count)) as IibSHDomain;
        varPrecision := 0;
        with varDomain do
          case DBQuery.Data.Dataset.Dataset.Fields[I].DataType of
            ftSmallint:
              begin
                Scale := 0;
                SubTypeID := 0;
                DataType := Get_SMALLINT(varPrecision, Scale, SubTypeID);
                DataTypeExt := Get_SMALLINT(varPrecision, Scale, SubTypeID);
              end;
            ftInteger, ftWord, ftAutoInc:
              begin
                Scale := 0;
                SubTypeID := 0;
                DataType := Get_INTEGER(varPrecision, Scale, SubTypeID);
                DataTypeExt := Get_INTEGER(varPrecision, Scale, SubTypeID);
              end;
            ftLargeint:
              begin
                Scale := 0;
                SubTypeID := 0;
                DataType := Get_BIGINT(varPrecision, Scale, SubTypeID);
                DataTypeExt := Get_BIGINT(varPrecision, Scale, SubTypeID);
              end;
            ftBoolean:
              begin
                DataType := Get_BOOLEAN;
                DataTypeExt := Get_BOOLEAN;
              end;
            ftFloat:
              begin
                if DBQuery.Data.Dataset.Dataset.Fields[I].Size > 9 then
                begin
                  Scale := 9;
                  DataType := Get_FLOAT(varPrecision, Scale, False);
                  DataTypeExt := Get_FLOAT(varPrecision, Scale, True);
                end
                else
                begin
                  varPrecision := (DBQuery.Data.Dataset.Dataset.Fields[I] as TFloatField).Precision;
                  Scale := DBQuery.Data.Dataset.Dataset.Fields[I].Size;
                  DataType := Get_FLOAT(varPrecision, Scale);
                  DataTypeExt := Get_FLOAT(varPrecision, Scale, True);
                end;
              end;
            ftBCD, ftFMTBcd:
              begin
                varPrecision := (DBQuery.Data.Dataset.Dataset.Fields[I] as TBCDField).Precision;
                Scale := DBQuery.Data.Dataset.Dataset.Fields[I].Size;
                DataType := Get_DOUBLE(varPrecision, Scale);
                DataTypeExt := Get_DOUBLE(varPrecision, Scale, True);
              end;
            ftDate:
              begin
                DataType := Get_DATE;
                DataTypeExt := Get_DATE;
              end;
            ftTime:
              begin
                DataType := Get_TIME;
                DataTypeExt := Get_TIME;
              end;
            ftDateTime, ftTimeStamp:
              begin
                DataType := Get_TIMESTAMP(Dialect);
                DataTypeExt := Get_TIMESTAMP(Dialect);
              end;
            (*_CHAR:
              begin
                ADomain.DataType := Get_CHAR(ADomain.Length);
                ADomain.DataTypeExt := Get_CHAR(ADomain.Length, True);
              end;*)
            ftString:
              begin
                Length := (DBQuery.Data.Dataset.Dataset.Fields[I] as TStringField).Size;
                DataType := Get_VARCHAR(Length);
                DataTypeExt := Get_VARCHAR(Length, True);
              end;
            ftMemo:
              begin
                SubTypeID := 1;
                SegmentSize := 0;
                DataType := Get_BLOB(SubTypeID, SegmentSize);
                DataTypeExt := Get_BLOB(SubTypeID, SegmentSize, True);
                Charset := EmptyStr;
                Collate := EmptyStr
              end;
            ftBlob, ftGraphic, ftFmtMemo:
              begin
                SubTypeID := 0;
                SegmentSize := 0;
                DataType := Get_BLOB(SubTypeID, SegmentSize);
                DataTypeExt := Get_BLOB(SubTypeID, SegmentSize, True);
                Charset := EmptyStr;
                Collate := EmptyStr
              end;
            (*_CSTRING:
              begin
                ADomain.DataType := Get_CSTRING(ADomain.Length);
                ADomain.DataTypeExt := Get_CSTRING(ADomain.Length, True);
              end;
            _QUAD:
              begin
                 ADomain.DataType := Get_QUAD;
                 ADomain.DataTypeExt := Get_QUAD;
              end;*)
              ftUnknown, ftCurrency,
              ftBytes, ftVarBytes,
              ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftFixedChar, ftWideString,
              ftADT, ftArray, ftReference, ftDataSet, ftOraBlob, ftOraClob,
              ftVariant, ftInterface, ftIDispatch, ftGuid:
              begin
                 DataType := 'UNKNOWN';
                 DataTypeExt := 'UNKNOWN';
              end;
          end;
      end;
    end;
    DRVQuery.Transaction.Commit;
  end;
end;

function TibBTDDLGenerator.ReplaceNameConsts(const ADDLText, ACaption: string): string;
var
  FileName: string;
  ConstList: TStrings;
  I: Integer;
  S: string;
begin
  FileName := Format('%s%s\ObjectNameRtns.txt', [(Designer.GetDemon(DBObject.BranchIID) as ISHDataRootDirectory).DataRootDirectory, 'Repository\DDL']);
  ConstList := TStringList.Create;
  try
    if FileExists(FileName) then
    begin
      ConstList.LoadFromFile(FileName);
      Result := AnsiReplaceText(ADDLText, '{NAME}', NormalizeName(ACaption));
      if Assigned(DBTable) then
      begin
        if Pos('{TABLE_NAME}', Result) > 0 then
          Result := AnsiReplaceText(Result, '{TABLE_NAME}', NormalizeName(ACaption));
        for I := 0 to Pred(ConstList.Count) do
        begin
          S := ConstList.Names[I];
          if Pos(S, Result) > 0 then
            Result := AnsiReplaceText(Result, S, NormalizeName2(AnsiReplaceText(ConstList.ValueFromIndex[I], '{TABLE_NAME}', ACaption)));
        end;
      end;

      if Assigned(DBField) then
      begin
        if (Pos('{TABLE_NAME}', Result) > 0) and (Length(DBField.TableName) > 0) then
          Result := AnsiReplaceText(Result, '{TABLE_NAME}', NormalizeName(DBField.TableName));
        for I := 0 to Pred(ConstList.Count) do
        begin
          S := ConstList.Names[I];
          if Pos(S, Result) > 0 then
          begin
            if Length(DBField.TableName) > 0 then
              Result := AnsiReplaceText(Result, S, NormalizeName2(AnsiReplaceText(ConstList.ValueFromIndex[I], '{TABLE_NAME}', DBField.TableName)))
            else
              Result := AnsiReplaceText(Result, S, ConstList.ValueFromIndex[I]);
          end;
        end;          
      end;

      if Assigned(DBConstraint) then
      begin
        if (Pos('{TABLE_NAME}', Result) > 0) and (Length(DBConstraint.TableName) > 0) then
          Result := AnsiReplaceText(Result, '{TABLE_NAME}', NormalizeName(DBConstraint.TableName));
        for I := 0 to Pred(ConstList.Count) do
        begin
          S := ConstList.Names[I];
          if Pos(S, Result) > 0 then
          begin
            if Length(DBConstraint.TableName) > 0 then
              Result := AnsiReplaceText(Result, S, NormalizeName2(AnsiReplaceText(ConstList.ValueFromIndex[I], '{TABLE_NAME}', DBConstraint.TableName)))
            else
              Result := AnsiReplaceText(Result, S, ConstList.ValueFromIndex[I]);
          end;
        end;          
      end;

      if Assigned(DBIndex) then
      begin
        if (Pos('{TABLE_NAME}', Result) > 0) and (Length(DBIndex.TableName) > 0) then
          Result := AnsiReplaceText(Result, '{TABLE_NAME}', NormalizeName(DBIndex.TableName));
        for I := 0 to Pred(ConstList.Count) do
        begin
          S := ConstList.Names[I];
          if Pos(S, Result) > 0 then
          begin
            if Length(DBIndex.TableName) > 0 then
              Result := AnsiReplaceText(Result, S, NormalizeName2(AnsiReplaceText(ConstList.ValueFromIndex[I], '{TABLE_NAME}', DBIndex.TableName)))
            else
              Result := AnsiReplaceText(Result, S, ConstList.ValueFromIndex[I]);
          end;
        end;           
      end;

      if Assigned(DBTrigger) then
      begin
        if (Pos('{TABLE_NAME}', Result) > 0) and (Length(DBTrigger.TableName) > 0) then
          Result := AnsiReplaceText(Result, '{TABLE_NAME}', NormalizeName(DBTrigger.TableName));
        for I := 0 to Pred(ConstList.Count) do
        begin
          S := ConstList.Names[I];
          if Pos(S, Result) > 0 then
          begin
            if Length(DBTrigger.TableName) > 0 then
              Result := AnsiReplaceText(Result, S, NormalizeName2(AnsiReplaceText(ConstList.ValueFromIndex[I], '{TABLE_NAME}', DBTrigger.TableName)))
            else
              Result := AnsiReplaceText(Result, S, ConstList.ValueFromIndex[I]);
          end;
        end;
      end;
    end;
  finally
    ConstList.Free;
  end;
(*
{GENERATOR_NAME}=GEN_{TABLE_NAME}_ID
{TRIGGER_NAME}=TR_{TABLE_NAME}_BI
{PRIMARY_KEY_NAME}=PK_{TABLE_NAME}
{FOREIGN_KEY_NAME}=FK_{TABLE_NAME}
{UNIQUE_NAME}=UNQ_{TABLE_NAME}
{CHECK_NAME}=CHK_{TABLE_NAME}
{INDEX_NAME}=IDX_{TABLE_NAME}
*)
end;

procedure TibBTDDLGenerator.SetFakeValues(DDL: TStrings; FileName:string='');
var
  ACaption: string;
begin
  if FileName='' then
   FileName :=
    Format('%s%s\%s\Default.txt',
     [(Designer.GetDemon(DBObject.BranchIID) as ISHDataRootDirectory).DataRootDirectory,
    'Repository\DDL',
     GUIDToName(DBObject.ClassIID, 1)]
    )
  else
   FileName :=
    Format('%s%s\%s\'+FileName,
     [(Designer.GetDemon(DBObject.BranchIID) as ISHDataRootDirectory).DataRootDirectory,
    'Repository\DDL',
     GUIDToName(DBObject.ClassIID, 1)]
    );

  if State = csCreate then
    if FileExists(FileName) then
    begin
      ACaption := DBObject.Caption;
      DDL.LoadFromFile(FileName);
      if (Pos('{NAME}', DDL.Text) > 0) then
      begin
// Buzz
//if Designer.InputQuery(Format('%s', [SLoadingDefaultTemplate]), Format('%s', [SObjectNameNew]), ACaption{, False}) and (Length(ACaption) > 0) then
        begin
          if Assigned(CodeNormalizer) then ACaption := CodeNormalizer.InputValueToMetadata(DBObject.BTCLDatabase, ACaption);
          DBObject.Caption := ACaption;
        end;// else
         // DDL.Clear;
      end;
      if Length(DDL.Text) > 0 then DDL.Text := ReplaceNameConsts(DDL.Text, ACaption);
    end;
end;

procedure TibBTDDLGenerator.SetDDLFromValues(DDL: TStrings);
var
  I, MaxStrLength: Integer;
  S: string;
  S1, C1: string;
  B,B1,B2:Boolean;
  vTable:IibSHTable;
  iField:IibSHField;
begin
(*  Код переехал в DDLForm
  if (State = csCreate) or (State = csRecreate) then
  begin
    // здесь(?) проверить на наличие зарегистрированного визивинг редактора
    case State of
      csCreate:   C := SChangeDefaultName;
      csRecreate: C := SChangeCurrentName;
    end;
    S := DBObject.Caption;
    if Designer.InputQuery(Format('%s', [C]), Format('%s', [SObjectNameNew]), S{, False}) and (Length(S) > 0) then
    begin
      if Assigned(CodeNormalizer) then S := CodeNormalizer.InputValueToMetadata(DBObject.BTCLDatabase, S);
      DBObject.Caption := S;
    end else
    begin
      DDL.Text := 'User Cancel'; // do not localize
      Exit;
    end;
  end;
*)

  if Assigned(DBDomain) then
  begin
    if DBDomain.UseCustomValues then
    begin
      DBDomain.DataTypeExt := DBDomain.DataType;
      DBDomain.FieldTypeID := GetFieldTypeID(DBDomain.DataType);


      if AnsiContainsText(DBDomain.DataType, 'NUMERIC') or AnsiContainsText(DBDomain.DataType, 'DECIMAL') then
        DBDomain.DataTypeExt := Format('%s(%d, %d)', [DBDomain.DataType, DBDomain.Precision, DBDomain.Scale])
      else
      if AnsiContainsText(DBDomain.DataType, 'CHAR') or AnsiContainsText(DBDomain.DataType, 'VARCHAR') then
        DBDomain.DataTypeExt := Format('%s(%d)', [DBDomain.DataType, DBDomain.Length])
      else
      if AnsiContainsText(DBDomain.DataType, 'BLOB') then
        DBDomain.DataTypeExt := Format('%s SUB_TYPE %d SEGMENT SIZE %d', [DBDomain.DataType, BlobSubTypeToID(DBDomain.SubType), DBDomain.SegmentSize]);
    end;

    case State of
      csSource, csCreate, csRecreate:
        begin
          DDL.Add(Format('CREATE DOMAIN %s AS', [NormalizeName(DBDomain.Caption)]));
          DDL.Add(DBDomain.DataTypeExt);

          case DBDomain.FieldTypeID of
            _SMALLINT, _INTEGER, _BIGINT, _BOOLEAN, _FLOAT, _DOUBLE,
            _DATE,  _TIME,  _TIMESTAMP,
            _CHAR,  _VARCHAR:
                if Length(DBDomain.ArrayDim) > 0 then
                  DDL.Strings[Pred(DDL.Count)] := Format('%s %s', [DDL.Strings[Pred(DDL.Count)], DBDomain.ArrayDim]);
          end;

          case DBDomain.FieldTypeID of
            _CHAR,  _VARCHAR:
              begin
                if (Length(DBDomain.Charset) > 0) and (not AnsiSameText(DBDomain.Charset, DBCharset) or  not AnsiSameText(DBDomain.Charset, DBDomain.Collate)) then
                  DDL.Strings[Pred(DDL.Count)] := Format('%s CHARACTER SET %s', [DDL.Strings[Pred(DDL.Count)], DBDomain.Charset]);
              end;
            _BLOB:
              begin
                if AnsiSameText(DBDomain.SubType, BlobSubTypes[1]) and (Length(DBDomain.Charset) > 0) and not AnsiSameText(DBDomain.Charset, DBCharset) then
                  DDL.Strings[Pred(DDL.Count)] := Format('%s CHARACTER SET %s', [DDL.Strings[Pred(DDL.Count)], DBDomain.Charset]);
              end;
          end;

          if Length(DBDomain.DefaultExpression.Text) > 0 then
            case State of
              csSource, csCreate, csRecreate:
                DDL.Add(Format('DEFAULT %s', [Trim(DBDomain.DefaultExpression.Text)]));
              csAlter:;
            end;

          if System.Length(DBDomain.NullType) > 0 then
            DDL.Add(DBDomain.NullType);

          if Length(DBDomain.CheckConstraint.Text) > 0 then
            case State of
              csSource, csCreate, csRecreate:
                DDL.Add(Format('CHECK (%s)', [Trim(DBDomain.CheckConstraint.Text)]));
              csAlter:;
            end;

          case DBDomain.FieldTypeID of
            _CHAR, _VARCHAR:
              if (Length(DBDomain.Collate) > 0) and  not AnsiSameText(DBDomain.Charset, DBDomain.Collate) then
                DDL.Add(Format('COLLATE %s', [DBDomain.Collate]));
          end;

          DDL.Strings[Pred(DDL.Count)] := DDL.Strings[Pred(DDL.Count)] + FTerminator;

          if (DBDomain.DataType = 'SMALLINT') or
             (DBDomain.DataType = 'INTEGER') or
             (DBDomain.DataType = 'BOOLEAN') or
             (DBDomain.DataType = 'BIGINT') or
             (DBDomain.DataType = 'FLOAT') or
             (DBDomain.DataType = 'DOUBLE PRECISION') or
             (DBDomain.DataType = 'DATE') or
             (DBDomain.DataType = 'TIME') or
             (DBDomain.DataType = 'TIMESTAMP') then
          begin
            DBDomain.MakePropertyInvisible('Length');
            DBDomain.MakePropertyInvisible('Precision');
            DBDomain.MakePropertyInvisible('Scale');
            DBDomain.MakePropertyInvisible('Charset');
            DBDomain.MakePropertyInvisible('Collate');
            DBDomain.MakePropertyInvisible('SubType');
            DBDomain.MakePropertyInvisible('SegmentSize');
          end
          else
          if (DBDomain.DataType = 'NUMERIC') or
             (DBDomain.DataType = 'DECIMAL') then
          begin
            DBDomain.MakePropertyInvisible('Length');
            DBDomain.MakePropertyInvisible('Charset');
            DBDomain.MakePropertyInvisible('Collate');
            DBDomain.MakePropertyInvisible('SubType');
            DBDomain.MakePropertyInvisible('SegmentSize');
          end
          else
          if (DBDomain.DataType = 'CHAR') or
             (DBDomain.DataType = 'VARCHAR') then
          begin
            DBDomain.MakePropertyInvisible('Precision');
            DBDomain.MakePropertyInvisible('Scale');
            DBDomain.MakePropertyInvisible('SubType');
            DBDomain.MakePropertyInvisible('SegmentSize');
          end
          else
          if (DBDomain.DataType = 'BLOB') then
          begin
            DBDomain.MakePropertyInvisible('Length');
            DBDomain.MakePropertyInvisible('Precision');
            DBDomain.MakePropertyInvisible('Scale');
            if DBDomain.SubTypeID <> 1 then
              DBDomain.MakePropertyInvisible('Charset');
            DBDomain.MakePropertyInvisible('Collate');
            DBDomain.MakePropertyInvisible('ArrayDim');
          end;
        end;
      csAlter:
        begin
         if DBDomain.UseCustomValues then
         begin
          if DBDomain.NameWasChanged or DBDomain.DataTypeWasChanged or
             DBDomain.DefaultWasChanged or DBDomain.CheckWasChanged then
          begin
            DDL.Add(Format('ALTER DOMAIN %s', [NormalizeName(DBDomain.ObjectName)]));
            // SetFakeValues
            if DBDomain.NameWasChanged then
            begin
              DDL.Add(Format('TO %s', [NormalizeName(DBDomain.Caption)]));
            end;
            if DBDomain.DataTypeWasChanged then
            begin
              DDL.Add(Format('TYPE %s', [DBDomain.DataTypeExt]));
            end;
            if DBDomain.DefaultWasChanged then
            begin
              if Length(Trim(DBDomain.DefaultExpression.Text)) > 0 then
                DDL.Add(Format('SET DEFAULT %s', [Trim(DBDomain.DefaultExpression.Text)]))
              else
                DDL.Add(Format('DROP DEFAULT', []));
            end;
            if DBDomain.CheckWasChanged then
            begin
              DDL.Add(Format('DROP CONSTRAINT', []));
              DDL.Add(FTerminator);
              if Length(Trim(DBDomain.CheckConstraint.Text)) > 0 then
              begin
                DDL.Add('');
                DDL.Add(Format('ALTER DOMAIN %s', [NormalizeName(DBDomain.ObjectName)]));
                DDL.Add(Format('ADD CONSTRAINT CHECK (%s)', [Trim(DBDomain.CheckConstraint.Text)]));
                DDL.Add(FTerminator);
              end;
            end else
              DDL.Add(FTerminator);
          end;

          if DBDomain.NullTypeWasChanged then
          begin
            if Length(DDL.Text) > 0 then DDL.Add('');
            if Length(DBDomain.NullType) > 0 then
            begin
              DDL.Add(Format('UPDATE RDB$FIELDS F', []));
              DDL.Add(Format('SET F.RDB$NULL_FLAG = 1 /* <- NOT NULL */', []));
              DDL.Add(Format('WHERE F.RDB$FIELD_NAME = ''%s''', [DBDomain.ObjectName]));
              DDL.Add(FTerminator);
            end else
            begin
              DDL.Add(Format('UPDATE RDB$FIELDS F', []));
              DDL.Add(Format('SET F.RDB$NULL_FLAG = NULL', []));
              DDL.Add(Format('WHERE F.RDB$FIELD_NAME = ''%s''', [DBDomain.ObjectName]));
              DDL.Add(FTerminator);
            end;
          end;

          if DBDomain.CollateWasChanged then
          begin
            if Length(DDL.Text) > 0 then DDL.Add('');
            DDL.Add(Format('UPDATE RDB$FIELDS F', []));
            DDL.Add(Format('SET F.RDB$COLLATION_ID = %d /* <- %s */', [DBDomain.CollateID, DBDomain.Collate]));
            DDL.Add(Format('WHERE F.RDB$FIELD_NAME = ''%s''', [DBDomain.ObjectName]));
            DDL.Add(FTerminator);
          end;
       end
       else
       begin


          DDL.Add(Format('ALTER DOMAIN %s', [NormalizeName(DBDomain.Caption)]));
            DDL.Add('/* TO <new_domain_name> TYPE <data_type> */');
            DDL.Add('/*DROP DEFAULT*/');
            DDL.Add('/* SET DEFAULT {literal | NULL | USER} */');

            DDL.Add('/*DROP CONSTRAINT*/');
            DDL.Add('/* ADD CONSTRAINT CHECK (VALUE <operator> <val> | IS [NOT] NULL) */');

          DDL.Add(FTerminator);
        end
       end;
    end;
  end
  else

  if Assigned(DBTable) then
  begin
    case State of
      csSource, csCreate, csRecreate,csRelatedSource:
        begin
          MaxStrLength := GetMaxStrLength(DBTable.Fields);
          if Length(DBTable.ExternalFile)>0 then
           DDL.Add(Format('CREATE TABLE %s EXTERNAL %s(', [NormalizeName(DBTable.Caption),''''+DBTable.ExternalFile+'''']))
          else
           DDL.Add(Format('CREATE TABLE %s(', [NormalizeName(DBTable.Caption)]));          
          if (State=csCreate) and (DBTable.Fields.Count=0) then
          begin
           DDL.Add('   <field_def>,');
           DDL.Add('  <field_def>...');
//           DDL.Add('/*  ADD CONSTRAINT <constraint_def> */');
          end
          else
            for I := 0 to Pred(DBTable.Fields.Count) do
            begin
              S:=NormalizeName(DBTable.Fields[I]);
              iField:=DBTable.GetField(I);
              if (State in [csSource,csRelatedSource]) and DBTable.DecodeDomains then
              begin
                if I <> Pred(DBTable.Fields.Count) then
                  DDL.Add(Format(SDDLOffset + '%s%s%s,', [S, SpaceGenerator(MaxStrLength, S), iField.DataTypeFieldExt]))
                else
                  DDL.Add(Format(SDDLOffset + '%s%s%s', [S, SpaceGenerator(MaxStrLength, S), iField.DataTypeFieldExt]));

              end else
              begin
                if I <> Pred(DBTable.Fields.Count) then
                  DDL.Add(Format(SDDLOffset + '%s%s%s,', [S, SpaceGenerator(MaxStrLength, S), iField.DataTypeField]))
                else
                  DDL.Add(Format(SDDLOffset + '%s%s%s', [S, SpaceGenerator(MaxStrLength, S), iField.DataTypeField]));
              end;

            // SourceDDL for Field (!!!)
            iField.SourceDDL.Text := Format('ALTER TABLE %s ADD %s%s %s%s', [NormalizeName(iField.TableName), SLineBreak, s, iField.DataTypeField, FTerminator]);
          end;
          DDL.Add(')' + FTerminator);


          { TODO : DDL таблицы }
          vTable:=DBTable;
//          if State=csRelatedSource then
          if State in [csRecreate,csRelatedSource] then
          begin
            if vTable.Constraints.Count>0 then
            begin
              B:=True; B1:=True; B2:=True;
              for I:=0 to Pred(vTable.Constraints.Count) do
              begin
               if vTable.GetConstraint(I).ConstraintType='PRIMARY KEY' then
               begin
                DDL.Add('');
                DDL.Add('/*********************************************************************************/');
                DDL.Add('/*                  Primary Keys                                           */');
                DDL.Add('/*********************************************************************************/');
                DDL.Add('');

               end
               else
               if vTable.GetConstraint(I).ConstraintType='UNIQUE' then
               begin
                if B then
                begin
                  DDL.Add('');
                  DDL.Add('/*********************************************************************************/');
                  DDL.Add('/*                          Unique constraints                                   */');
                  DDL.Add('/*********************************************************************************/');
                  DDL.Add('');
                 B:=False
                end;
               end
               else
               if vTable.GetConstraint(I).ConstraintType='FOREIGN KEY' then
               begin
                 if B1 then
                 begin
                  DDL.Add('');
                  DDL.Add('/*********************************************************************************/');
                  DDL.Add('/*                          Foreign Keys                                        */');
                  DDL.Add('/*********************************************************************************/');
                  DDL.Add('');
                  B1:=False
                 end
               end
               else
               if vTable.GetConstraint(I).ConstraintType='CHECK' then
               begin
                 if B2 then
                 begin
                  DDL.Add('');
                  DDL.Add('/*********************************************************************************/');
                  DDL.Add('/*                          Check  constraints                                   */');
                  DDL.Add('/*********************************************************************************/');
                  DDL.Add('');
                  B2:=False
                 end
               end;
                DDL.AddStrings( vTable.GetConstraint(I).SourceDDL);
              end;
            end;
            if vTable.Indices.Count>0 then
            begin
              B:=True;
              for I:=0 to Pred(vTable.Indices.Count) do
              if not vTable.GetIndex(I).IsConstraintIndex then
              begin
                if B then
                begin
                  B:=False;
                  DDL.Add('');
                  DDL.Add('/*********************************************************************************/');
                  DDL.Add('/*                         Indices                                               */');
                  DDL.Add('/*********************************************************************************/');
                  DDL.Add('');
                end;
                DDL.AddStrings( vTable.GetIndex(I).SourceDDL);
              end;
            end;
            if vTable.Triggers.Count>0 then
            begin
              DDL.Add('');
              FTerminator:='^';
              DDL.Add('SET TERM ^ ;');
              DDL.Add('');

              DDL.Add('');
              DDL.Add('/*********************************************************************************/');
              DDL.Add('/*                            Triggers                                           */');
              DDL.Add('/*********************************************************************************/');
              DDL.Add('');

              for I:=0 to Pred(vTable.Triggers.Count) do
              begin
               DDL.AddStrings( vTable.GetTrigger(I).SourceDDL );
               DDL[DDL.Count-1]:=FTerminator;
               DDL.Add('');
              end;
            end;

            B:=False;
            B:=(vTable.Description.Count>0);
            if not B then
             For I:=0 to Pred(vTable.Fields.Count) do
              if vTable.GetField(i).Description.Count>0 then
              begin
                B:=True;
                Break
              end;
            if B then
            begin
              DDL.Add('');
              DDL.Add('/*********************************************************************************/');
              DDL.Add('/*                            Descriptions                                       */');
              DDL.Add('/*********************************************************************************/');
              DDL.Add('');
              if vTable.Description.Count>0 then
               DDL.Add(vTable.GetDescriptionStatement(False));

              for I:=0 to Pred(vTable.Fields.Count) do
              if vTable.GetField(i).Description.Count>0 then
              begin
                DDL.Add(vTable.GetField(i).GetDescriptionStatement(False));
                DDL.Add('');                
              end;

            end;

            vTable:=nil;
            FTerminator:=';'
          end;
        end;
      csAlter:
        begin
          DDL.Add(Format('ALTER TABLE %s', [NormalizeName(DBTable.Caption)]));
          DDL.Add('  ADD <field_def>,');
          DDL.Add('  ADD <field_def>...');
          DDL.Add('/*  ADD CONSTRAINT <constraint_def> */');
          DDL.Add('/*  DROP <field_name> */');
          DDL.Add('/*  DROP CONSTRAINT <constraint_name> */');
          DDL.Add(FTerminator);
        end;
    end;
  end;

  if Assigned(DBField) then
  begin
    case State of
      csSource, csCreate, csRecreate:
        begin
          if DBField.UseCustomValues then
          begin
//
            DDL.Add(Format('ALTER TABLE %s ADD', [NormalizeName(DBField.TableName)]));
            // Domain
            if Length(DBField.Domain) > 0 then
            begin
              DDL.Add(Format('%s %s', [NormalizeName(DBField.Caption), DBField.Domain]));
              if Length(DBField.FieldDefault.Text) > 0 then
                DDL.Add(Format('DEFAULT %s', [Trim(DBField.FieldDefault.Text)]));
              if Length(DBField.FieldNullType) > 0 then
                DDL.Add(Format('%s', [DBField.FieldNullType]));
              if Length(DBField.FieldCollate) > 0 then
                DDL.Add(Format('COLLATE %s', [DBField.FieldCollate]));
              DDL.Strings[Pred(DDL.Count)] := DDL.Strings[Pred(DDL.Count)] + FTerminator;
              Exit;
            end;
            // DataType
            if Length(DBField.DataType) > 0 then
            begin
              DBField.DataTypeExt := DBField.DataType;
              DBField.FieldTypeID := GetFieldTypeID(DBField.DataType);

              if AnsiContainsText(DBField.DataType, 'NUMERIC') or AnsiContainsText(DBField.DataType, 'DECIMAL') then
                DBField.DataTypeExt := Format('%s(%d, %d)', [DBField.DataType, DBField.Precision, DBField.Scale])
              else
              if AnsiContainsText(DBField.DataType, 'CHAR') or AnsiContainsText(DBField.DataType, 'VARCHAR') then
                DBField.DataTypeExt := Format('%s(%d)', [DBField.DataType, DBField.Length])
              else  
              if AnsiContainsText(DBField.DataType, 'BLOB') then
                DBField.DataTypeExt := Format('%s SUB_TYPE %d SEGMENT SIZE %d', [DBField.DataType, BlobSubTypeToID(DBField.SubType), DBField.SegmentSize]);

              DDL.Add(Format('%s %s', [NormalizeName(DBField.Caption), DBField.DataTypeExt]));

              case DBField.FieldTypeID of
                _SMALLINT, _INTEGER, _BIGINT, _BOOLEAN, _FLOAT, _DOUBLE,
                _DATE,  _TIME,  _TIMESTAMP,
                _CHAR,  _VARCHAR:
                    if Length(DBField.ArrayDim) > 0 then
                      DDL.Strings[Pred(DDL.Count)] := Format('%s %s', [DDL.Strings[Pred(DDL.Count)], DBField.ArrayDim]);
              end;

              case DBField.FieldTypeID of
                _CHAR,  _VARCHAR:
                  begin
                    if (Length(DBField.Charset) > 0) and (not AnsiSameText(DBField.Charset, DBCharset) or not AnsiSameText(DBField.Charset, DBField.Collate)) then
                      DDL.Strings[Pred(DDL.Count)] := Format('%s CHARACTER SET %s', [DDL.Strings[Pred(DDL.Count)], DBField.Charset]);
                  end;
                _BLOB:
                  begin
                    if AnsiSameText(DBField.SubType, BlobSubTypes[1]) and (Length(DBField.Charset) > 0) and not AnsiSameText(DBField.Charset, DBCharset) then
                      DDL.Strings[Pred(DDL.Count)] := Format('%s CHARACTER SET %s', [DDL.Strings[Pred(DDL.Count)], DBField.Charset]);
                  end;
              end;

              if Length(DBField.DefaultExpression.Text) > 0 then
                case State of
                  csSource, csCreate, csRecreate:
                    DDL.Add(Format('DEFAULT %s', [Trim(DBField.DefaultExpression.Text)]));
                  csAlter:;
                end;

              if System.Length(DBField.NullType) > 0 then
                DDL.Add(DBField.NullType);


              case DBField.FieldTypeID of
                _CHAR, _VARCHAR:
                  if (Length(DBField.Collate) > 0) and not AnsiSameText(DBField.Charset, DBField.Collate) then
                    DDL.Add(Format('COLLATE %s', [DBField.Collate]));
              end;

              DDL.Strings[Pred(DDL.Count)] := DDL.Strings[Pred(DDL.Count)] + FTerminator;
              Exit;
            end;
            // Computed
            if DBField.ComputedSource.Count > 0 then
            begin
              DDL.Add(Format('%s COMPUTED BY (%s)', [NormalizeName(DBField.Caption), Trim(DBField.ComputedSource.Text)]));
              DDL.Strings[Pred(DDL.Count)] := DDL.Strings[Pred(DDL.Count)] + FTerminator;
              Exit;
            end;
          end else
            DDL.AddStrings(DBField.SourceDDL);
        end;
      csAlter:
        begin
          if AnsiContainsText(Version, SInterBase4x) or
             AnsiContainsText(Version, SInterBase5x) then
          begin
//            DDL.Add(DeleteOld);
//            SetDropDDL(DDL);
//            DDL.Add('');
//            DDL.Add(CreateNew);
//            SetDDLFromValues(DDL);
          end else
          begin
            DDL.Add(Format('ALTER TABLE %s ALTER COLUMN', [NormalizeName(DBField.TableName)]));
            DDL.Add(Format('%s', [NormalizeName(DBField.Caption)]));
            DDL.Add('TO new_col_name');
            DDL.Add('/* TYPE new_col_datatype */');
            DDL.Add(FTerminator);
          end;
        end;
    end;
  end;

  if Assigned(DBConstraint) then
  begin
    case State of
      csSource, csCreate, csRecreate:
        begin
          if (DBConstraint.ConstraintType='PRIMARY KEY') or
             (DBConstraint.ConstraintType='UNIQUE') then
          begin
            for I := 0 to Pred(DBConstraint.Fields.Count) do
            begin
              if Length(S1) > 0 then
                S1 := Format('%s, %s', [S1, NormalizeName(DBConstraint.Fields[I])])
              else
                S1 := NormalizeName(DBConstraint.Fields[I]);
            end;
            S1 := '('+S1+')';
          end
          else
          if DBConstraint.ConstraintType='FOREIGN KEY' then
          begin
            for I := 0 to Pred(DBConstraint.Fields.Count) do
            begin
              if Length(S1) > 0 then
                S1 := Format('%s, %s', [S1, NormalizeName(DBConstraint.Fields[I])])
              else
                S1 := NormalizeName(DBConstraint.Fields[I]);
            end;
            S1 := '('+S1+')';

            for I := 0 to Pred(DBConstraint.ReferenceFields.Count) do
            begin
              if Length(C1) > 0 then
                C1 := Format('%s, %s', [C1, NormalizeName(DBConstraint.ReferenceFields[I])])
              else
                C1 := NormalizeName(DBConstraint.ReferenceFields[I]);
            end;
            C1 := '('+C1+')';

            S1 := Format('%s REFERENCES %s %s', [S1, NormalizeName(DBConstraint.ReferenceTable), C1]);
            if not SameText(DBConstraint.OnDeleteRule, 'NO ACTION') then
              S1 := Format('%s %sON DELETE %s', [S1, SLineBreak, DBConstraint.OnDeleteRule]);
            if not SameText(DBConstraint.OnUpdateRule, 'NO ACTION') then
              S1 := Format('%s %sON UPDATE %s', [S1, SLineBreak, DBConstraint.OnUpdateRule]);
          end
          else
          if DBConstraint.ConstraintType='CHECK' then
          begin
            S1 := '('+Trim(DBConstraint.CheckSource.Text)+')';
          end else
          begin
            if (Length(DBConstraint.IndexName) > 0) and
               (DBConstraint.IndexName <> DBConstraint.Caption) and
               not IsSystemIndex(DBConstraint.IndexName) then
            begin
              S1 := Format('%s %sUSING', [S1, SLineBreak]);
              if DBConstraint.IndexSorting<> 'ASCENDING' then
                S1 := Format('%s %s', [S1, 'DESCENDING']);
              S1 := Format('%s INDEX %s', [S1, DBConstraint.IndexName]);
            end;
          end;

          if Pos('INTEG_', DBConstraint.Caption) <> 1 then
            DDL.Add(Format('ALTER TABLE %s ADD CONSTRAINT%s%s', [NormalizeName(DBConstraint.TableName), SLineBreak, NormalizeName(DBConstraint.Caption)]))
          else
            DDL.Add(Format('ALTER TABLE %s ADD', [NormalizeName(DBConstraint.TableName)]));

          DDL.Add(Format('%s %s%s', [DBConstraint.ConstraintType, S1, FTerminator]));
        end;
    end;
  end;

  if Assigned(DBIndex) then
  begin
    case State of
      csSource, csCreate, csRecreate:
        begin
          if Length(DBIndex.IndexType) > 0 then S := Trim(DBIndex.IndexType);
          if AnsiSameText(DBIndex.Sorting, Sortings[1]) then S := Format('%s %s', [S, DBIndex.Sorting]);
          if Length(S) > 0 then
            DDL.Add(Format('CREATE %s INDEX %s', [S, NormalizeName(DBIndex.Caption)]))
          else
            DDL.Add(Format('CREATE INDEX %s', [NormalizeName(DBIndex.Caption)]));
//          S := AnsiReplaceStr(AnsiReplaceStr(DBIndex.Fields.CommaText, '"', ''), ',',', ');
          S := EmptyStr;
          if DBIndex.Fields.Count>0 then
          begin
            for I := 0 to Pred(DBIndex.Fields.Count) do
            begin
              if Length(S) > 0 then
                S := Format('%s, %s', [S, NormalizeName(DBIndex.Fields[I])])
              else
                S := Format('%s', [NormalizeName(DBIndex.Fields[I])]);
            end;
            DDL.Add(Format('ON %s (%s)%s', [NormalizeName(DBIndex.TableName), S, FTerminator]));
          end
          else
          begin
           S:=TrimRight(DBIndex.Expression.Text);
           DDL.Add(Format('ON %s COMPUTED BY %s %s', [NormalizeName(DBIndex.TableName), S, FTerminator]));
          end
          
        end;
      csAlter:
        begin
          if SameText(DBIndex.Status, Statuses[0]) then
            DDL.Add(Format('ALTER INDEX %s %s%s', [NormalizeName(DBIndex.Caption), Statuses[1], FTerminator]))
          else
            DDL.Add(Format('ALTER INDEX %s %s%s', [NormalizeName(DBIndex.Caption), Statuses[0], FTerminator]));
        end;
    end;
  end;

  if Assigned(DBView) then
  begin
    if State = csCreate then
    begin
      DBView.Fields.Add('view_cols');
    end;
    
    if DBView.Fields.Count > 0 then
    begin
      DDL.Add(Format('CREATE VIEW %s (', [NormalizeName(DBView.Caption)]));
      for I := 0 to Pred(DBView.Fields.Count) do
      begin
        if I <> Pred(DBView.Fields.Count) then
          DDL.Add(Format(SDDLOffset + '%s,', [NormalizeName(DBView.Fields[I])]))
        else
          DDL.Add(Format(SDDLOffset + '%s', [NormalizeName(DBView.Fields[I])]));
      end;
      DDL.Add(')');
    end else
      DDL.Add(Format('CREATE VIEW %s', [NormalizeName(DBView.Caption)]));
    DDL.Add('AS');
    if Length(DBView.BodyText.Text) > 0 then
      if Length(Trim(DBView.BodyText[0])) = 0 then DBView.BodyText.Delete(0);

    if State = csCreate then
    begin
      DBView.BodyText.Add(SDDLOffset + '/* <select> */');
    end;
    DDL.AddStrings(DBView.BodyText);
    DDL.Add(FTerminator);

    if State in  [csRelatedSource,csRecreate] then
    begin
            if DBView.Triggers.Count>0 then
            begin
              DDL.Add('');
              FTerminator:='^';
              DDL.Add('SET TERM ^ ;');
              DDL.Add('');


              DDL.Add('');
              DDL.Add('/*********************************************************************************/');
              DDL.Add('/*                            Triggers                                           */');
              DDL.Add('/*********************************************************************************/');
              DDL.Add('');

              for I:=0 to Pred(DBView.Triggers.Count) do
              begin
               DDL.AddStrings( DBView.GetTrigger(I).SourceDDL );
               DDL[DDL.Count-1]:=FTerminator;
               DDL.Add('');
              end;
            end;

    end
  end;

  if Assigned(DBProcedure) then
  begin
    if DBProcedure.ParamsExt.Count > 0 then
    begin
      case State of
        csSource, csCreate, csRecreate:
          DDL.Add(Format('CREATE PROCEDURE %s (', [NormalizeName(DBProcedure.Caption)]));
        csAlter:
          DDL.Add(Format('ALTER PROCEDURE %s (', [NormalizeName(DBProcedure.Caption)]));
      end;
      for I := 0 to Pred(DBProcedure.ParamsExt.Count) do
        DDL.Add(SDDLOffset + DBProcedure.ParamsExt[I]);
      DDL.Add(')');
    end else
    begin
      case State of
        csSource, csCreate, csRecreate:
          DDL.Add(Format('CREATE PROCEDURE %s', [NormalizeName(DBProcedure.Caption)]));
        csAlter:
          DDL.Add(Format('ALTER PROCEDURE %s', [NormalizeName(DBProcedure.Caption)]));
      end;
    end;

    if DBProcedure.ReturnsExt.Count > 0 then
    begin
      DDL.Add('RETURNS (');
      for I := 0 to Pred(DBProcedure.ReturnsExt.Count) do
        DDL.Add(SDDLOffset + DBProcedure.ReturnsExt[I]);
      DDL.Add(')');
    end;
    DDL.Add('AS');

    DBProcedure.HeaderDDL.Assign(DDL);
    DBProcedure.HeaderDDL.Add('BEGIN');
    DBProcedure.HeaderDDL.Add(Format(SDDLOffset +'SUSPEND;', []));
    DBProcedure.HeaderDDL.Add('END');
    DBProcedure.HeaderDDL.Add(FTerminator);

    if Length(DBProcedure.BodyText.Text) > 0 then
      if Length(Trim(DBProcedure.BodyText[0])) = 0 then DBProcedure.BodyText.Delete(0);

    if State = csCreate then
    begin
      DBProcedure.BodyText.Add('BEGIN');
      DBProcedure.BodyText.Add(SDDLOffset + '/* <procedure_body> */');
      DBProcedure.BodyText.Add('END');
    end;
    
    DDL.AddStrings(DBProcedure.BodyText);
    DDL.Add(FTerminator);
  end;

  if Assigned(DBTrigger) then
  begin
    case State of
      csSource, csCreate, csRecreate:
       if Length(DBTrigger.TableName)>0 then
        DDL.Add(Format('CREATE TRIGGER %s FOR %s', [NormalizeName(DBTrigger.Caption), NormalizeName(DBTrigger.TableName)]))
       else
        DDL.Add(Format('CREATE TRIGGER %s ', [NormalizeName(DBTrigger.Caption)]));
      csAlter:
        DDL.Add(Format('ALTER TRIGGER %s', [NormalizeName(DBTrigger.Caption)]));
    end;
    DDL.Add(Format('%s %s %s POSITION %d', [DBTrigger.Status, DBTrigger.TypePrefix, DBTrigger.TypeSuffix, DBTrigger.Position]));

    if State = csCreate then
    begin
      DBTrigger.BodyText.Clear;
      DBTrigger.BodyText.Add('AS');
      DBTrigger.BodyText.Add('BEGIN');
      DBTrigger.BodyText.Add(SDDLOffset + '/* <trigger_body> */');
      DBTrigger.BodyText.Add('END');
    end
    else
    if DBTrigger.BodyText.Count > 0 then
      if Length(Trim(DBTrigger.BodyText[0])) = 0 then
        DBTrigger.BodyText.Delete(0);

    DDL.AddStrings(DBTrigger.BodyText);
    DDL.Add(FTerminator);
  end;

  if Assigned(DBGenerator) then
  begin
    case State of
      csSource, csCreate, csRecreate:
        DDL.Add(Format('CREATE GENERATOR %s%s', [NormalizeName(DBGenerator.Caption), FTerminator]));
    end;
    if DBGenerator.ShowSetClause then
      DDL.Add(Format('SET GENERATOR %s TO %d%s', [NormalizeName(DBGenerator.Caption), DBGenerator.Value, FTerminator]));
  end;

  if Assigned(DBException) then
  begin
    case State of
      csSource, csCreate, csRecreate:
        DDL.Add(Format('CREATE EXCEPTION %s', [NormalizeName(DBException.Caption)]));
      csAlter:
        DDL.Add(Format('ALTER EXCEPTION %s', [NormalizeName(DBException.Caption)]));
    end;
    DDL.Add(Format('''%s''%s', [AnsiReplaceText(DBException.Text, '''', ''''''), FTerminator]));
  end;                                   

  if Assigned(DBFunction) then
  begin
    DDL.Add(Format('DECLARE EXTERNAL FUNCTION %s', [NormalizeName(DBFunction.Caption)]));
    for I := 0 to Pred(DBFunction.Params.Count) do
    begin
      if I <> Pred(DBFunction.Params.Count) then
        DDL.Add(Format(SDDLOffset + '%s,', [DBFunction.Params[I]]))
      else
        DDL.Add(Format(SDDLOffset + '%s', [DBFunction.Params[I]]));
    end;
    DDL.Add('RETURNS');
    for I := 0 to Pred(DBFunction.Returns.Count) do
    begin
      if I <> Pred(DBFunction.Returns.Count) then
        DDL.Add(Format(SDDLOffset + '%s,', [DBFunction.Returns[I]]))
      else
        DDL.Add(Format(SDDLOffset + '%s', [DBFunction.Returns[I]]));
    end;
    DDL.Add(Format('ENTRY_POINT ''%s'' MODULE_NAME ''%s''%s', [DBFunction.EntryPoint, DBFunction.ModuleName, FTerminator]));
  end;

  if Assigned(DBFilter) then
  begin
    DDL.Add(Format('DECLARE FILTER %s', [NormalizeName(DBFilter.Caption)]));
    DDL.Add(Format(SDDLOffset + 'INPUT_TYPE %d', [DBFilter.InputType]));
    DDL.Add(Format(SDDLOffset + 'OUTPUT_TYPE %d', [DBFilter.OutputType]));
    DDL.Add(Format('ENTRY_POINT ''%s'' MODULE_NAME ''%s''%s', [DBFilter.EntryPoint, DBFilter.ModuleName, FTerminator]));
  end;

  if Assigned(DBRole) then
  begin
    DDL.Add(Format('CREATE ROLE %s%s', [NormalizeName(DBRole.Caption), FTerminator]));
  end;

  if Assigned(DBShadow) then
  begin
  end;

  if Assigned(DBQuery) then
  begin
  end;
end;

procedure TibBTDDLGenerator.SetAlterDDLNotSupported(DDL: TStrings);
var
  S: string;
begin
  if Assigned(DBField)      then S := 'FIELD';
  if Assigned(DBConstraint) then S := 'CONSTRAINT';
  if Assigned(DBView)       then S := 'VIEW';
  if Assigned(DBFunction)   then S := 'EXTERNAL FUNCTION';
  if Assigned(DBFilter)     then S := 'FILTER';
  if Assigned(DBRole)       then S := 'ROLE';
  if Assigned(DBShadow)     then S := 'SHADOW';

  if Length(S) > 0 then
  begin
    DDL.Add('/*');
    DDL.Add(Format('This server does not support "ALTER %s" DDL statement,', [S]));
    DDL.Add('try to use "Recreate" action');
    DDL.Add('*/');
  end;
end;

procedure TibBTDDLGenerator.SetSourceDDL(DDL: TStrings);
begin
  SetRealValues;
  SetDDLFromValues(DDL);
end;

procedure TibBTDDLGenerator.SetCreateDDL(DDL: TStrings);
begin
  if FUseFakeValues then SetFakeValues(DDL, FCurrentTemplateFile) else SetDDLFromValues(DDL);
end;

procedure TibBTDDLGenerator.SetAlterDDL(DDL: TStrings);
begin
  if Assigned(DBDomain)     then SetDDLFromValues(DDL)
  else
  if Assigned(DBTable)      then SetDDLFromValues(DDL)
  else
  if Assigned(DBField)      then SetDDLFromValues(DDL)
  else
  if Assigned(DBConstraint) then SetAlterDDLNotSupported(DDL)
  else
  if Assigned(DBIndex)      then SetDDLFromValues(DDL)
  else
  if Assigned(DBView)       then SetAlterDDLNotSupported(DDL)
  else
  if Assigned(DBProcedure)  then SetDDLFromValues(DDL)
  else
  if Assigned(DBTrigger)    then SetDDLFromValues(DDL)
  else
  if Assigned(DBGenerator)  then SetDDLFromValues(DDL)
  else
  if Assigned(DBException)  then SetDDLFromValues(DDL)
  else
  if Assigned(DBFunction)   then SetAlterDDLNotSupported(DDL)
  else
  if Assigned(DBFilter)     then SetAlterDDLNotSupported(DDL)
  else
  if Assigned(DBRole)       then SetAlterDDLNotSupported(DDL)
  else
  if Assigned(DBShadow)     then SetAlterDDLNotSupported(DDL);
end;

procedure TibBTDDLGenerator.SetDropDDL(DDL: TStrings);
var
  S: string;
begin
  if Assigned(DBDomain)     then S := 'DOMAIN'
  else
  if Assigned(DBTable)      then S := 'TABLE'
  else
  if Assigned(DBField)      then S := NormalizeName(DBField.ObjectName)
  else
  if Assigned(DBConstraint) then S := 'CONSTRAINT'
  else
  if Assigned(DBIndex)      then S := 'INDEX'
  else
  if Assigned(DBView)       then S := 'VIEW'
  else
  if Assigned(DBProcedure)  then S := 'PROCEDURE'
  else
  if Assigned(DBTrigger)    then S := 'TRIGGER'
  else
  if Assigned(DBGenerator)  then S := 'GENERATOR'
  else
  if Assigned(DBException)  then S := 'EXCEPTION'
  else
  if Assigned(DBFunction)   then S := 'EXTERNAL FUNCTION'
  else
  if Assigned(DBFilter)     then S := 'FILTER'
  else
  if Assigned(DBRole)       then S := 'ROLE'
  else
  if Assigned(DBShadow)     then S := 'SHADOW';

  

  if Assigned(DBField) then
    S := Format('DROP %s' + FTerminator, [S])
  else
    S := Format('DROP %s %s' + FTerminator, [S, '%s']);

  if Assigned(DBGenerator) then
  begin
    if not (SameText(Version, SFirebird1x) or SameText(Version, SFirebird15)
     or SameText(Version, SFirebird20) or SameText(Version, SFirebird21))
    then
      S := 'DELETE FROM RDB$GENERATORS G WHERE G.RDB$GENERATOR_NAME = ''%s''' + FTerminator;
  end;

  if Assigned(DBField) then
    S := Format('ALTER TABLE %s %s', [NormalizeName(DBField.TableName), S]);

  if Assigned(DBConstraint) then
    S := Format('ALTER TABLE %s %s', [NormalizeName(DBConstraint.TableName), S]);

  DDL.Add(Format(S, [NormalizeName(DBObject.ObjectName)]));
end;

procedure RemoveDouble(List:TStrings);
var
   i:integer;
   j:integer;
begin
   i:=Pred(List.Count);
   while i>0 do
   begin
    j:=i-1;
    while j<i do
    begin
      j:=List.IndexOf(List[i]);
      if i<>j then
      begin
       List.Delete(j);
       Dec(i)
      end
    end;
    Dec(i)
   end;
end;

procedure FillViewsUsedByView(const ViewName:string; Query:IibSHDRVQuery; Results:TStrings);
var
    CurView:string;
    StartIndexInList:integer;
    EndIndexInList  :integer;
begin
 Query.Close;
 StartIndexInList:=Results.Count;
 if Query.ExecSQL(SQL_VIEWS_USED_BY,[ViewName],False,True) then
 while not Query.Eof do
 begin
  CurView:=Query.GetFieldStrValue(0);
  Results.Add(CurView);
  Query.Next
 end;

 EndIndexInList:=Results.Count;
 while StartIndexInList< EndIndexInList do
 begin
  FillViewsUsedByView(Results[StartIndexInList],Query,Results);
  Inc(StartIndexInList)
 end;
end;

function MakeIn(List:TStrings;const AddStr:string ):string;
var
 i:integer;
begin
 Result:='('''+AddStr+''',';
 for i:=0 to Pred(List.Count) do
  Result:=Result+''''+List[i]+''',';
 Result[Length(Result)]:=')'; 
end;

procedure TibBTDDLGenerator.SetRecreateDDL(DDL: TStrings);
var
   rDescriptions:TStringList;
   rProcedures:TStringList;
   rTriggers  :TStringList;
   rViews     :TStringList;
   rViewTriggers:TStringList;
   rConstraints:TStringList;
   DeleteOldDDL:TStrings;
   DDLCreateViews:TStrings;
   iv:IibSHView;
   iv1:IibSHView;
   ip:IibSHProcedure;
   it:IIbSHTrigger;
   ic:IibSHConstraint;
   i:integer;
   vComponentClass: TSHComponentClass;
   vComponent:TComponent;
   s:String;
   CurTerm:Char;

procedure SaveDescriptions(DBObject:IibSHDBObject);
var
  i:integer;
begin
  if DBObject.Description.Count>0 then
  begin
   rDescriptions.Add('');
   Designer.TextToStrings(DBObject.GetDescriptionStatement(False),rDescriptions);  
  end;
  if Supports(DBObject,IibSHView) then
  with (DBObject as IibSHView) do
  for i:=0 to Pred(Fields.Count) do
   if GetField(i).Description.Count>0 then
   begin
     rDescriptions.Add('');
     Designer.TextToStrings(GetField(i).GetDescriptionStatement(False),rDescriptions);
   end;
end;

begin
  if not Assigned(DBView) then
  begin
    DDL.Add(DeleteOld);
    SetDropDDL(DDL);
    DDL.Add('');
    DDL.Add(CreateNew);
    SetDDLFromValues(DDL);
  end
  else
  begin
// Вьюхи блин
   rProcedures:=TStringList.Create;
   rTriggers  :=TStringList.Create;
   rViews     :=TStringList.Create;
   DeleteOldDDL:=TStringList.Create;
   DDLCreateViews:=TStringList.Create;
   rViewTriggers:=TStringList.Create;
   rConstraints:=TStringList.Create;
   rDescriptions:=TStringList.Create;
   try
    FillViewsUsedByView(DBView.Caption,DRVQuery,rViews);
    RemoveDouble(rViews);
    s:=MakeIn(rViews,DBView.Caption);
    if not DRVQuery.ExecSQL(SQL_GET_VIEW_USED_BY1,[s,s],False,False)
     or DRVQuery.Eof
    then
    begin
      DDL.Add(DeleteOld);
      SetDropDDL(DDL);
      DDL.Add('');
      DDL.Add(CreateNew);
      SetDDLFromValues(DDL);
      SaveDescriptions(DBView);

      for I:=0 to Pred(DBView.Triggers.Count) do
      begin
         it:=DBView.GetTrigger(I);
         it.Refresh;
         SaveDescriptions(it);
      end;
      
      if rDescriptions.Count>0 then
      begin
        DDL.Add('/*********************************************************************************/');
        DDL.Add('/*                                    Restore Comments                           */');
        DDL.Add('/*********************************************************************************/');
        DDL.Add('');
        if FTerminator='^' then
         DDL.Add('SET TERM ; ^');
        DDL.AddStrings(rDescriptions);
      end;
      Exit;
    end;
// Здесь мы окончательно поняли что есть зависимости
    CurTerm:=';'    ;
    DBView.State:=csSource;
    rViewTriggers.Assign(DBView.Triggers);
    FState:=csSource;
    iv:=DBView;
    SetUseFakeValues(False);
   DDLCreateViews.Add('/*********************************************************************************/');
   DDLCreateViews.Add('/*                  Restore dependence Views                                     */');
   DDLCreateViews.Add('/*********************************************************************************/');
   DDLCreateViews.Add('');
    SetDDLFromValues(DDLCreateViews);
    SaveDescriptions(iv);


    while not DRVQuery.Eof do
    begin
     case DRVQuery.GetFieldValue(0) of
      2: if rTriggers.IndexOf(DRVQuery.GetFieldStrValue(1))=-1 then
          rTriggers.Add(DRVQuery.GetFieldStrValue(1));
      5: if rProcedures.IndexOf(DRVQuery.GetFieldStrValue(1))=-1 then
          rProcedures.Add(DRVQuery.GetFieldStrValue(1));
      7: if rConstraints.IndexOf(DRVQuery.GetFieldStrValue(1))=-1 then
           rConstraints.Add(DRVQuery.GetFieldStrValue(1));
     end;
     DRVQuery.Next;
    end;



    if rProcedures.Count>0 then
    begin
     DeleteOldDDL.Add('/*********************************************************************************/');
     DeleteOldDDL.Add('/*                  Clear dependence procedures                                  */');
     DeleteOldDDL.Add('/*********************************************************************************/');
     DeleteOldDDL.Add('SET TERM  ^ ;');
     CurTerm:='^'  ;
     FTerminator:=CurTerm;
     DDL.Add('/*********************************************************************************/');
     DDL.Add('/*                          Restore dependence procedures                        */');
     DDL.Add('/*********************************************************************************/');
     DDL.Add('');

     vComponentClass := Designer.GetComponent(IibSHProcedure);
     if Assigned(vComponentClass) then
     begin
      vComponent:=vComponentClass.Create(Self);
      Supports(vComponent,IibSHProcedure,ip);
      try
        ip.OwnerIID:=iv.OwnerIID;
        for i:=0 to Pred(rProcedures.Count) do
        begin
         ip.Caption:=TrimRight(rProcedures[i]);
         ip.State:=csSource;
         S := GetDDLText(ip);
         s:=ip.HeaderDDL.Text;
         s:=StringReplace(s,'CREATE','ALTER',[]);
         Designer.TextToStrings(s,DeleteOldDDL);
    // ^^^^^^^^^^Обнуляем процедуры
         ip.State:=csAlter;
         s:=GetDDLText(ip);
         Designer.TextToStrings(s,DDL);
    // ^^^^^^^^^^Восстанавливаем процедуры
        end
      finally
       ip:=nil;
       vComponent.Free;
      end;
     end; // Конец обработки процедур
    end;
    if rTriggers.Count>0 then
    begin
     DeleteOldDDL.Add('/*********************************************************************************/');
     DeleteOldDDL.Add('/*                  Clear dependence triggers                                    */');
     DeleteOldDDL.Add('/*********************************************************************************/');
     DeleteOldDDL.Add('');
     if CurTerm<>'^' then
     begin
      DeleteOldDDL.Add('SET TERM  ^ ;');
      CurTerm:='^';
     end;

     DDL.Add('/*********************************************************************************/');
     DDL.Add('/*                   Restore dependence triggers                                 */');
     DDL.Add('/*********************************************************************************/');
     DDL.Add('');
     FTerminator:='^';

     vComponentClass := Designer.GetComponent(IibSHTrigger);
     if Assigned(vComponentClass) then
     begin
      vComponent:=vComponentClass.Create(Self);
      Supports(vComponent,IibSHTrigger,it);
      try
        it.OwnerIID:=iv.OwnerIID;
        for i:=0 to Pred(rTriggers.Count) do
        begin
         DeleteOldDDL.Add('ALTER TRIGGER '+NormalizeName2(TrimRight(rTriggers[i]),it.BTCLDatabase) );
         DeleteOldDDL.Add('AS ');
         DeleteOldDDL.Add('BEGIN ');
         DeleteOldDDL.Add('  /**/ ');
         DeleteOldDDL.Add('END');
         DeleteOldDDL.Add('^');
         DeleteOldDDL.Add('');
    // ^^^^^^^^^^Обнуляем триггера
         it.Caption:=TrimRight(rTriggers[i]);
         it.State:=csAlter;
         it.Refresh;
         s:=GetDDLText(it);
         Designer.TextToStrings(s,DDL);
    // ^^^^^^^^^^Восстанавливаем триггера
        end
      finally
       it:=nil;
       vComponent.Free;
      end;
     end
    end; // Конец обработки триггеров


    if rConstraints.Count>0 then
    begin
     DeleteOldDDL.Add('/*********************************************************************************/');
     DeleteOldDDL.Add('/*                  Drop dependence constraint                                  */');
     DeleteOldDDL.Add('/*********************************************************************************/');
     DDL.Add('/*********************************************************************************/');
     DDL.Add('/*                  Restore dependence constraint                                */');
     DDL.Add('/*********************************************************************************/');

     if CurTerm='^' then
     begin
       CurTerm:=';';
       FTerminator:=';';
       DeleteOldDDL.Add('SET TERM ; ^');
       DDL.Add('SET TERM ; ^');
     end;


     vComponentClass := Designer.GetComponent(IibSHConstraint);
     if Assigned(vComponentClass) then
     begin
      vComponent:=vComponentClass.Create(Self);
      Supports(vComponent,IibSHConstraint,ic);
      try
       ic.OwnerIID:=iv.OwnerIID;
       for i:=0 to Pred(rConstraints.Count) do
       begin
         ic.Caption:=TrimRight(rConstraints[i]);
         ic.Refresh;
         ic.State:=csDrop;
         S := GetDDLText(ic);
         Designer.TextToStrings(s,DeleteOldDDL);
         ic.State:=csSource;
         S := GetDDLText(ic);
         Designer.TextToStrings(s,DDL);
       end;
      finally
       ic:=nil;
       vComponent.Free;
      end;
     end;
    end; // Конец обработки констрэйнтов
   

   DeleteOldDDL.Add('/*********************************************************************************/');
   DeleteOldDDL.Add('/*                  Clear dependence Views                                       */');
   DeleteOldDDL.Add('/*********************************************************************************/');
   DeleteOldDDL.Add(' ');
   if CurTerm='^' then
    DeleteOldDDL.Add('SET TERM ; ^');
   DeleteOldDDL.Add(' ');
   for i:=Pred(rViews.Count) downto 0 do
   begin
      DeleteOldDDL.Add('DROP VIEW '+NormalizeName2(TrimRight(rViews[i]),iv.BTCLDatabase)+ ';');
   end;
   DeleteOldDDL.Add('DROP VIEW '+NormalizeName2(iv.Caption,iv.BTCLDatabase)+ ';');
   DeleteOldDDL.Add(' ');


   if rViews.Count>0 then
   begin
     FTerminator:=';'      ;
     vComponentClass := Designer.GetComponent(IibSHView);
     if Assigned(vComponentClass) then
     begin
       vComponent:=vComponentClass.Create(Self);
       Supports(vComponent,IibSHView,iv1);
      try
        iv1.OwnerIID:=iv.OwnerIID;
       iv1.State:=csSource;
       for i:=0 to Pred(rViews.Count) do
       begin
          iv1.Caption:=TrimRight(rViews[i]);
          s:=GetDDLText(iv1);
          DDLCreateViews.Add('');
          Designer.TextToStrings(s,DDLCreateViews);
          rViewTriggers.AddStrings(iv1.Triggers);
          SaveDescriptions(iv1);
       end;
      finally
        iv1:=nil;
        vComponent.Free;
      end
     end
   end;

   if rViewTriggers.Count>0 then
   begin
     vComponentClass := Designer.GetComponent(IibSHTrigger);
     if Assigned(vComponentClass) then
     begin
      vComponent:=vComponentClass.Create(Self);
      Supports(vComponent,IibSHTrigger,it);
      try
        it.OwnerIID:=iv.OwnerIID;
       DDLCreateViews.Add('');

       DDLCreateViews.Add('/*********************************************************************************/');
       DDLCreateViews.Add('/*                  Create empty view triggers                                   */');
       DDLCreateViews.Add('/*********************************************************************************/');
       DDLCreateViews.Add('');

       DDLCreateViews.Add('SET TERM ^ ;');
       FTerminator:='^';
       for i:=0 to Pred(rViewTriggers.Count) do
       begin
         it.Caption:=TrimRight(rViewTriggers[i]);
         it.Refresh;
         it.State:=csCreate;
         s:=GetDDLText(it);
         Designer.TextToStrings(s,DDLCreateViews);
         SaveDescriptions(it);
       end;

       DDLCreateViews.Add('');
       DDLCreateViews.Add('/*********************************************************************************/');
       DDLCreateViews.Add('/*                  Restore view triggers                                        */');
       DDLCreateViews.Add('/*********************************************************************************/');
       DDLCreateViews.Add('');
       
       for i:=0 to Pred(rViewTriggers.Count) do
       begin
         it.Caption:=TrimRight(rViewTriggers[i]);
         it.State:=csAlter;
         it.Refresh;
         s:=GetDDLText(it);
         Designer.TextToStrings(s,DDLCreateViews);
       end;

      finally
       it:=nil;
       vComponent.Free
      end;
     end
   end;

   DDLCreateViews.AddStrings(DDL);
   DeleteOldDDL.AddStrings(DDLCreateViews);
   DDL.Assign(DeleteOldDDL);

   if rDescriptions.Count>0 then
   begin
    DDL.Add('/*********************************************************************************/');
    DDL.Add('/*                                    Restore Comments                           */');
    DDL.Add('/*********************************************************************************/');
    DDL.Add('');
    DDL.Add('SET TERM ; ^');
    DDL.AddStrings(rDescriptions)
   end
   finally
    rConstraints.Free;
    rDescriptions.Free;
    rViewTriggers.Free;
    rProcedures.Free;
    rTriggers  .Free;
    rViews     .Free;
    DeleteOldDDL.Free;
    DDLCreateViews.Free;
    if Assigned(DRVQuery) then
    begin
      DRVQuery.Close;
      if DRVQuery.Transaction.InTransaction then
       DRVQuery.Transaction.Commit
    end
   end;
  end;
end;

{
    ShadowMode
    ShadowType
    FileName
    SecondaryFiles
}

function TibBTDDLGenerator.GetCurrentTemplateFile: string;
begin
 Result:=FCurrentTemplateFile
end;

procedure TibBTDDLGenerator.SetCurrentTemplateFile(const FileName: string);
begin
 FCurrentTemplateFile:=FileName
end;

end.
