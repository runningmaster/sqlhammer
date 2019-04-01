unit ibSHDDLCompiler;

interface

uses
  SysUtils, Classes, Dialogs, Types,
  SynEditTypes,
  SHDesignIntf, SHOptionsIntf, pSHIntf,
  ibSHDesignIntf, ibSHDriverIntf, ibSHConsts, ibSHComponent;

type
  TibBTDDLCompiler = class(TibBTComponent, IibSHDDLCompiler)
  private
    FDDLParser: TComponent;
    FDRVQueryIntf: IibSHDRVQuery;
    FErrorText: string;
    FErrorLine: Integer;
    FErrorColumn: Integer;
    FDDLHistory: IibSHDDLHistory;
    function GetErrorCoord(AErrorText: string): TBufferCoord;
    function GetDDLHistory: IibSHDDLHistory;
  protected
    function GetDDLParser: ISHDDLParser;
    function GetErrorText: string;
    function GetErrorLine: Integer;
    function GetErrorColumn: Integer;
    procedure AddToHistory(AText: string);
    property DDLHistory: IibSHDDLHistory read GetDDLHistory;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function Compile(const Intf: IInterface; ADDL: string): Boolean;
    procedure AfterCommit(Sender: TObject; SenderClosing: Boolean = False);
    procedure AfterRollback(Sender: TObject; SenderClosing: Boolean = False);

    property DDLParser: ISHDDLParser read GetDDLParser;
    property DRVQuery: IibSHDRVQuery read FDRVQueryIntf;
  end;


implementation

{ TibBTDDLCompiler }

constructor TibBTDDLCompiler.Create(AOwner: TComponent);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner);
  vComponentClass := Designer.GetComponent(IibSHDDLParser);
  if Assigned(vComponentClass) then FDDLParser := vComponentClass.Create(nil);
end;

destructor TibBTDDLCompiler.Destroy;
begin
  FDRVQueryIntf := nil;
  FDDLParser.Free;
  inherited Destroy;
end;

procedure TibBTDDLCompiler.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent.IsImplementorOf(FDDLHistory) then FDDLHistory := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

function TibBTDDLCompiler.GetErrorCoord(AErrorText: string): TBufferCoord;
var
  vPos: Integer;
  vCoordString: string;
begin
  Result := TBufferCoord(Point(0, -1));
  vPos := Pos('- line ', AErrorText);
  if vPos = 0 then
  begin
    vPos := Pos('At line ', AErrorText);
    if vPos > 0 then
      Inc(vPos);
  end;
  if vPos > 0 then
  begin
    Inc(vPos, 7);
    vCoordString := EmptyStr;
    while (vPos < Length(AErrorText)) and (AErrorText[vPos] in Digits) do
    begin
      vCoordString := vCoordString + AErrorText[vPos];
      Result.Line := StrToIntDef(vCoordString, -1);
      Inc(vPos);
    end;
    vPos := Pos(', char ', AErrorText);
    if vPos = 0 then
    begin
      vPos := Pos(', column ', AErrorText);
      if vPos > 0 then
        Inc(vPos, 2);
    end;
    Inc(vPos, 7);
    vCoordString := EmptyStr;
    while (vPos < Length(AErrorText)) and (AErrorText[vPos] in Digits) do
    begin
      vCoordString := vCoordString + AErrorText[vPos];
      Result.Char := StrToIntDef(vCoordString, -1);
      Inc(vPos);
    end;
  end;
end;

function TibBTDDLCompiler.GetDDLHistory: IibSHDDLHistory;
var
  vHistoryComponent: TSHComponent;
  vHistoryComponentClass: TSHComponentClass;
  vSHSystemOptions: ISHSystemOptions;
begin
  if not Assigned(FDDLHistory) then
  begin
    if not Supports(Designer.FindComponent(OwnerIID, IibSHDDLHistory), IibSHDDLHistory, FDDLHistory) then
    begin
      vHistoryComponentClass := Designer.GetComponent(IibSHDDLHistory);
      if Assigned(vHistoryComponentClass) then
      begin
        vHistoryComponent := vHistoryComponentClass.Create(nil);
        vHistoryComponent.OwnerIID := OwnerIID;
        if Supports(vHistoryComponent, IibSHDDLHistory, FDDLHistory) then
        begin
          if Assigned(FDDLHistory.BTCLDatabase) and
            Supports(Designer.GetOptions(ISHSystemOptions), ISHSystemOptions, vSHSystemOptions) and
            (not vSHSystemOptions.UseWorkspaces) then
            vHistoryComponent.Caption := Format('%s for %s', [Designer.GetComponent(IibSHDDLHistory).GetHintClassFnc, FDDLHistory.BTCLDatabase.Alias])
          else
            vHistoryComponent.Caption := Designer.GetComponent(IibSHDDLHistory).GetHintClassFnc;
        end;
      end;
    end;
    ReferenceInterface(FDDLHistory, opInsert);
  end;
  Result := FDDLHistory;
end;

function TibBTDDLCompiler.GetDDLParser: ISHDDLParser;
begin
  Supports(FDDLParser, IibSHDDLParser, Result);
end;

function TibBTDDLCompiler.GetErrorText: string;
begin
  Result := FErrorText;
end;

function TibBTDDLCompiler.GetErrorLine: Integer;
begin
  Result := FErrorLine;
end;

function TibBTDDLCompiler.GetErrorColumn: Integer;
begin
  Result := FErrorColumn;
end;

procedure TibBTDDLCompiler.AddToHistory(AText: string);
begin
  if Assigned(DDLHistory) then
    DDLHistory.AddStatement(AText);
end;

function TibBTDDLCompiler.Compile(const Intf: IInterface; ADDL: string): Boolean;
var
  I: Integer;
  vErrorCoord: TBufferCoord;
  s:string;
begin
  FErrorText := EmptyStr;
  FErrorLine := -1;
  FErrorColumn := -1;

  Supports(Intf, IibSHDRVQuery, FDRVQueryIntf);
  try
    Result := Assigned(DRVQuery) and (Length(ADDL) > 0) and DDLParser.Parse(ADDL);
    if Result then
    begin
      if DDLParser.Count > 0 then
      begin
        for I := 0 to Pred(DDLParser.Count) do
        begin
          if DDLParser.IsDataSQL(I) and Assigned(DRVQuery) then
          begin
            { DEPRECATED - DDL Form не обрабатывает в скрипте COMMIT, ROLLBACK, RECONNECT
            if (DDLParser.StatementState(I) = csUnknown) and
              SameText(DDLParser.StatementObjectName(I), 'COMMIT') then
            begin
              DRVQuery.Transaction.Commit;
              FErrorText := DRVQuery.Transaction.ErrorText;
              if Length(FErrorText) = 0 then
              begin
                if Assigned(DDLHistory) then DDLHistory.CommitNewStatements;
              end
              else
                if Assigned(DDLHistory) then DDLHistory.RollbackNewStatements;
            end else
              if (DDLParser.StatementState(I) = csUnknown) and
                SameText(DDLParser.StatementObjectName(I), 'ROLLBACK') then
              begin
                DRVQuery.Transaction.Rollback;
                FErrorText := DRVQuery.Transaction.ErrorText;
                if Assigned(DDLHistory) then DDLHistory.RollbackNewStatements;
              end else
                if (DDLParser.StatementState(I) = csUnknown) and
                  SameText(DDLParser.StatementObjectName(I), 'RECONNECT') then
                begin
                  if DRVQuery.Transaction.InTransaction then
                  begin
                    DRVQuery.Transaction.Rollback;
                    FErrorText := DRVQuery.Transaction.ErrorText;
                    if Assigned(DDLHistory) then DDLHistory.RollbackNewStatements;
                  end;

                  if Length(FErrorText) = 0 then
                  begin
                    DRVQuery.Database.Reconnect;
                    FErrorText := DRVQuery.Database.ErrorText;
                  end;
                end else

                begin}
            s:=  DDLParser.Statements[I];
            DRVQuery.ExecSQL(s, [], False);
            if Assigned(DRVQuery) then FErrorText := DRVQuery.ErrorText;
                {end;}

            Result := Length(FErrorText) = 0;
            if not Result then
            begin
              vErrorCoord := GetErrorCoord(FErrorText);
              if (vErrorCoord.Char <> 0) or (vErrorCoord.Line <> -1) then
              begin
                if (I >= 0) and (I < DDLParser.Count) then
                begin
                  if vErrorCoord.Line = 1 then
                    vErrorCoord.Char := vErrorCoord.Char + DDLParser.StatementsCoord(I).Left - 1;
                  vErrorCoord.Line := vErrorCoord.Line + DDLParser.StatementsCoord(I).Top;
                  FErrorLine := vErrorCoord.Line;
                  FErrorColumn := vErrorCoord.Char;
                end
                else
                begin
                  FErrorLine := 1;
                  FErrorColumn := 1;
                end;
              end;
              Break;
            end
            else
            begin
              AddToHistory(DDLParser.Statements[I]);
            end;
          end else
          begin
            Result := False;
            FErrorText := Format('Invalid DDL statement.', []);
          end;
        end
      end else
      begin
        Result := False;
        FErrorText := Format('Statement list is empty.', []);
      end;
    end else
      FErrorText := DDLParser.ErrorText;
  finally
    FDRVQueryIntf := nil;
  end;
end;

procedure TibBTDDLCompiler.AfterCommit(Sender: TObject; SenderClosing: Boolean = False);
var
  I: Integer;
  DDLInfo: IibSHDDLInfo;
  DBObject: IibSHDBObject;
  DBFactory: IibSHDBObjectFactory;
  ProposalHintRetriever: IpSHProposalHintRetriever;
  RunCommands: ISHRunCommands;

  SHIndex: IibSHIndex;
  SHTrigger: IibSHTrigger;
  TableName: string;
  TableForm: string;
  Table: TSHComponent;
  DBTable: IibSHTable;
  DBView: IibSHView;

  function GetNormalizeName(const ACaption: string): string;
  var
    vCodeNormalizer: IibSHCodeNormalizer;
  begin
    Result := ACaption;
    if Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer) then
      Result := vCodeNormalizer.InputValueToMetadata(DDLInfo.BTCLDatabase, Result);
  end;

begin
  TableName := EmptyStr;
  TableForm := EmptyStr;
  //
  // Получаем DDLInfo интерфейс объекта
  //
  Supports(Sender, IibSHDDLInfo, DDLInfo);
  Assert(DDLInfo <> nil, 'DDLCompiler.AfterCommit: DDLInfo = nil');
  //
  // Получаем DB интерфейс объекта (только от редакторов DB объектов)
  //
  Supports(Sender, IibSHDBObject, DBObject);
  Supports(Sender, IibSHIndex, SHIndex);
  Supports(Sender, IibSHTrigger, SHTrigger);
  //
  // Синхронизируем внутренние списки имен BTCLDatabase
  //
  for I := 0 to Pred(DDLParser.Count) do
    case DDLParser.StatementState(I) of
      csCreate: DDLInfo.BTCLDatabase.ChangeNameList(DDLParser.StatementObjectType(I), GetNormalizeName(DDLParser.StatementObjectName(I)), opInsert);
      csDrop: DDLInfo.BTCLDatabase.ChangeNameList(DDLParser.StatementObjectType(I), GetNormalizeName(DDLParser.StatementObjectName(I)), opRemove);
    end;
  //
  // Отработка рефреша SourceDDL при ALTER DB объекта
  //
  if Assigned(DBObject) and (DBObject.State = csAlter) and not DBObject.Embedded then
  begin
    for I := 0 to Pred((Sender as TSHComponent).ComponentForms.Count) do
    begin
      RunCommands := nil;
      Supports((Sender as TSHComponent).ComponentForms[I], ISHRunCommands, RunCommands);
      if AnsiSameText(TSHComponentForm((Sender as TSHComponent).ComponentForms[I]).CallString, SCallSourceDDL) then
            if Assigned(RunCommands) and RunCommands.CanRefresh then RunCommands.Refresh;
    end;
  end;
  //
  // Синхронизация ограничений, индексов и триггеров с оной таблицей
  //
  if Assigned(SHIndex ) then
  begin
    TableName := SHIndex.TableName;
    TableForm := SCallIndices;
  end;

  if Assigned(SHTrigger) then
  begin
    TableName := SHTrigger.TableName;
    TableForm := SCallTriggers;
  end;

  if (Length(TableName) > 0) and not DBObject.Embedded then
  begin
    Table := Designer.FindComponent(DBObject.OwnerIID, IibSHTable, TableName);
    if not Assigned(Table) and Assigned(SHTrigger) then
      Table := Designer.FindComponent(DBObject.OwnerIID, IibSHView, TableName);

    if Assigned(Table) then
      for I := 0 to Pred(Table.ComponentForms.Count) do
      begin
        RunCommands := nil;
        Supports(Table.ComponentForms[I], ISHRunCommands, RunCommands);
        if AnsiSameText(TSHComponentForm(Table.ComponentForms[I]).CallString, TableForm) then
          if Assigned(RunCommands) and RunCommands.CanRefresh then RunCommands.Refresh;
      end;
  end;
  //
  // Удаление из IDE индексов и триггеров для таблицы, при удалении оной, если те были загружены
  //
  if Assigned(DBObject) and (DBObject.State = csDrop) and Supports(Sender, IibSHTable, DBTable) then
  begin
    for I := 0 to Pred(DBTable.Indices.Count) do
      if Designer.DestroyComponent(Designer.FindComponent(DBObject.OwnerIID, IibSHIndex, DBTable.Indices[I])) then
        DBObject.BTCLDatabase.ChangeNameList(IibSHIndex, DBTable.Indices[I], opRemove);
    for I := 0 to Pred(DBTable.Triggers.Count) do
      if Designer.DestroyComponent(Designer.FindComponent(DBObject.OwnerIID, IibSHTrigger, DBTable.Triggers[I])) then
        DBObject.BTCLDatabase.ChangeNameList(IibSHTrigger, DBTable.Triggers[I], opRemove);
  end;
  //
  // Удаление из IDE триггеров для вьюхи, при удалении оной, если те были загружены
  //
  if Assigned(DBObject) and (DBObject.State = csDrop) and Supports(Sender, IibSHView, DBView) then
  begin
    for I := 0 to Pred(DBView.Triggers.Count) do
      if Designer.DestroyComponent(Designer.FindComponent(DBObject.OwnerIID, IibSHTrigger, DBView.Triggers[I])) then
        DBObject.BTCLDatabase.ChangeNameList(IibSHTrigger, DBView.Triggers[I], opRemove);
  end;
  //
  // Отработка переоткрытия DB объектов
  //
  if Assigned(DBObject) and not SenderClosing and Supports(Designer.GetFactory(IibSHDBObject), IibSHDBObjectFactory, DBFactory) then
  begin
    if not DBObject.Embedded then
      case DBObject.State of
        csCreate, csRecreate:
          for I := 0 to Pred(DDLParser.Count) do
              if (DDLParser.StatementState(I) = csCreate) and
                 IsEqualGUID(DBObject.ClassIID, DDLParser.StatementObjectType(I)) then
              begin
                DBFactory.SuspendedDestroyCreateComponent(Sender as TSHComponent, DBObject.BTCLDatabase.InstanceIID, DBObject.ClassIID, GetNormalizeName(DDLParser.StatementObjectName(I)));
                Break;
              end;
        csDrop:
          DBFactory.SuspendedDestroyCreateComponent(Sender as TSHComponent, IUnknown, IUnknown, EmptyStr);
      end;
    //
    // Чтобы не выпадал вопрос из GetCanDestroy() DB объекта
    //
    if SenderClosing or ((DBObject.State = csCreate) or (DBObject.State = csRecreate)) then
      DBObject.State := csUnknown;
      
    if DBObject.Embedded then DBObject.State := csSource;
  end;
  //
  // Очищаем плюсовый кеш метаданных
  //
  DDLInfo.BTCLDatabase.DRVDatabase.ClearCache;
  //
  // Нотифицируем механизм получения выпадающих значений в текстовых редакторах
  //
  if Supports(Designer.GetDemon(IpSHProposalHintRetriever), IpSHProposalHintRetriever, ProposalHintRetriever) then
    ProposalHintRetriever.AfterCompile(Sender);
  //
  // Нотифицируем DDL историю для сохранения и отображения в редакторе выполненных
  // стейтментов
  //
  if Assigned(DDLHistory) then DDLHistory.CommitNewStatements;
end;

procedure TibBTDDLCompiler.AfterRollback(Sender: TObject; SenderClosing: Boolean = False);
begin
  //
  // Нотифицируем DDL историю для отмены сохранения и отображения в редакторе
  // не подтвержденных стейтментов
  //
  if Assigned(DDLHistory) then DDLHistory.RollbackNewStatements;
end;

end.

