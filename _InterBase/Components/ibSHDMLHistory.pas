unit ibSHDMLHistory;

interface

uses
  SysUtils, Classes,
  SHDesignIntf, SHOptionsIntf,
  pSHSqlTxtRtns, pSHQStrings,
  ibSHMessages, ibSHConsts, ibSHDesignIntf, ibSHTool, ibSHComponent, ibSHValues;

type
  TibSHDMLHistory = class(TibBTTool, IibSHDMLHistory, IibSHBranch, IfbSHBranch)
  private
    FItems: TStringList;
    FStatistic: TStringList;
    FStatementCRC: TList;
    FActive: Boolean;
    FMaxCount: Integer;
    FSelect: Boolean;
    FInsert: Boolean;
    FUpdate: Boolean;
    FDelete: Boolean;
    FExecute: Boolean;
    FCrash: Boolean;
  protected
    FSQLParser: TSQLParser;

    procedure SetOwnerIID(Value: TGUID); override;
    { IibSHDMLHistory }
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    function GetHistoryFileName: string;
    function GetMaxCount: Integer;
    procedure SetMaxCount(const Value: Integer);
    function GetSelect: Boolean;
    procedure SetSelect(const Value: Boolean);
    function GetInsert: Boolean;
    procedure SetInsert(const Value: Boolean);
    function GetUpdate: Boolean;
    procedure SetUpdate(const Value: Boolean);
    function GetDelete: Boolean;
    procedure SetDelete(const Value: Boolean);
    function GetExecute: Boolean;
    procedure SetExecute(const Value: Boolean);
    function GetCrash: Boolean;
    procedure SetCrash(const Value: Boolean);

    function Count: Integer;
    procedure Clear;
    function Statement(Index: Integer): string;
    function Item(Index: Integer): string;
    function Statistics(Index: Integer): string;
    function AddStatement(AStatement: string; AStatistics: IibSHStatistics): Integer;
    procedure DeleteStatement(AStatementNo: Integer);
    procedure LoadFromFile;
    procedure SaveToFile;
    function SQLTextDigest(AText: string): Int64;
    procedure AddSQLTextDigest(ADigest: Int64);
    procedure ClearDigestList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Active: Boolean read GetActive write SetActive;
    property MaxCount: Integer read GetMaxCount write SetMaxCount;
    property Select: Boolean read GetSelect write SetSelect;
    property Insert: Boolean read GetInsert write SetInsert;
    property Update: Boolean read GetUpdate write SetUpdate;
    property Delete: Boolean read GetDelete write SetDelete;
    property Execute: Boolean read GetExecute write SetExecute;
    property Crash: Boolean read GetCrash write SetCrash;
  end;

  TibSHDMLHistoryFactory = class(TibBTComponentFactory)
    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    function CreateComponent(const AOwnerIID, AClassIID: TGUID; const ACaption: string): TSHComponent; override;
  end;

procedure Register;

implementation

uses
  ibSHDMLHistoryActions,
  ibSHDMLHistoryEditors;

procedure Register;
begin
  SHRegisterImage(GUIDToString(IibSHDMLHistory), 'DMLHistory.bmp');

  SHRegisterImage(TibSHDMLHistoryPaletteAction.ClassName,         'DMLHistory.bmp');
  SHRegisterImage(TibSHDMLHistoryFormAction.ClassName,            'Form_DMLText.bmp');
  SHRegisterImage(TibSHDMLHistoryToolbarAction_Run.ClassName,     'Button_Run.bmp');
  SHRegisterImage(TibSHDMLHistoryToolbarAction_Pause.ClassName,   'Button_Stop.bmp');
  SHRegisterImage(TibSHDMLHistoryToolbarAction_Region.ClassName,  'Button_Tree.bmp');
  SHRegisterImage(TibSHDMLHistoryToolbarAction_Refresh.ClassName, 'Button_Refresh.bmp');
//  SHRegisterImage(TibSHDMLHistoryToolbarAction_Save.ClassName,    'Button_Save.bmp');

  SHRegisterImage(SCallDMLStatements, 'Form_DMLText.bmp');

  SHRegisterComponents([
    TibSHDMLHistory,
    TibSHDMLHistoryFactory]);

  SHRegisterActions([
    // Palette
    TibSHDMLHistoryPaletteAction,
    // Forms
    TibSHDMLHistoryFormAction,
    // Toolbar
    TibSHDMLHistoryToolbarAction_Run,
    TibSHDMLHistoryToolbarAction_Pause,
    TibSHDMLHistoryToolbarAction_Region,
    // Editors
    TibSHDMLHistoryEditorAction_SendToSQLEditor,
    TibSHDMLHistoryEditorAction_ShowDMLHistory]);
end;

{ TibSHDMLHistory }

constructor TibSHDMLHistory.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TStringList.Create;
  FStatistic := TStringList.Create;
  FStatementCRC := TList.Create;
  FActive := True;
  FSQLParser := TSQLParser.Create;
end;

destructor TibSHDMLHistory.Destroy;
var
  vDatabaseAliasOptionsInt: IibSHDatabaseAliasOptionsInt;
begin
  if Supports(BTCLDatabase, IibSHDatabaseAliasOptionsInt, vDatabaseAliasOptionsInt) then
  begin
    vDatabaseAliasOptionsInt.DMLHistoryActive := Active;
    vDatabaseAliasOptionsInt.DMLHistoryMaxCount := MaxCount;
    vDatabaseAliasOptionsInt.DMLHistorySelect := Select;
    vDatabaseAliasOptionsInt.DMLHistoryInsert := Insert;
    vDatabaseAliasOptionsInt.DMLHistoryUpdate := Update;
    vDatabaseAliasOptionsInt.DMLHistoryDelete := Delete;
    vDatabaseAliasOptionsInt.DMLHistoryExecute := Execute;
    vDatabaseAliasOptionsInt.DMLHistoryCrash := Crash;
  end;
//  SaveToFile;
  FSQLParser.Free;
  FStatistic.Free;
  FItems.Free;
  ClearDigestList;
  FStatementCRC.Free;
  inherited Destroy;
end;

procedure TibSHDMLHistory.SetOwnerIID(Value: TGUID);
var
  vDatabaseAliasOptionsInt: IibSHDatabaseAliasOptionsInt;
begin
  if not IsEqualGUID(OwnerIID, Value) then
  begin
    inherited SetOwnerIID(Value);
    if Supports(BTCLDatabase, IibSHDatabaseAliasOptionsInt, vDatabaseAliasOptionsInt) then
    begin
      Active := vDatabaseAliasOptionsInt.DMLHistoryActive;
      MaxCount := vDatabaseAliasOptionsInt.DMLHistoryMaxCount;
      Select := vDatabaseAliasOptionsInt.DMLHistorySelect;
      Insert := vDatabaseAliasOptionsInt.DMLHistoryInsert;
      Update := vDatabaseAliasOptionsInt.DMLHistoryUpdate;
      Delete := vDatabaseAliasOptionsInt.DMLHistoryDelete;
      Execute := vDatabaseAliasOptionsInt.DMLHistoryExecute;
      Crash := vDatabaseAliasOptionsInt.DMLHistoryCrash;
    end
    else
    begin
      Active := True;
      MaxCount := 0;
      Select := True;
      Insert := True;
      Update := True;
      Delete := True;
      Execute := True;
      Crash := True;
    end;
    LoadFromFile;
  end;
end;

function TibSHDMLHistory.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure TibSHDMLHistory.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;

function TibSHDMLHistory.GetHistoryFileName: string;
var
  vDir: string;
  vOldDir: string;
  vOldFile: string;
begin
  Result := EmptyStr;
  if Assigned(BTCLDatabase) then
  begin
    vDir := BTCLDatabase.DataRootDirectory;
    if SysUtils.DirectoryExists(vDir) then
      Result := vDir + DMLHistoryFile;
    vDir := ExtractFilePath(Result);
    if not SysUtils.DirectoryExists(vDir) then
    begin
      ForceDirectories(vDir);
      //Перенос старых данных
      vOldFile := BTCLDatabase.DataRootDirectory + SQLHistoryFile;
      vOldDir := ExtractFilePath(vOldFile);
      if SysUtils.DirectoryExists(vOldDir) and FileExists(vOldFile) then
      begin
        RenameFile(vOldFile, Result);
        RemoveDir(vOldDir);
      end;
    end;
  end;
end;

function TibSHDMLHistory.GetMaxCount: Integer;
begin
  Result := FMaxCount;
end;

procedure TibSHDMLHistory.SetMaxCount(const Value: Integer);
begin
  FMaxCount := Value;
end;

function TibSHDMLHistory.GetSelect: Boolean;
begin
  Result := FSelect;
end;

procedure TibSHDMLHistory.SetSelect(const Value: Boolean);
begin
  FSelect := Value;
end;

function TibSHDMLHistory.GetInsert: Boolean;
begin
  Result := FInsert;
end;

procedure TibSHDMLHistory.SetInsert(const Value: Boolean);
begin
  FInsert := Value;
end;

function TibSHDMLHistory.GetUpdate: Boolean;
begin
  Result := FUpdate;
end;

procedure TibSHDMLHistory.SetUpdate(const Value: Boolean);
begin
  FUpdate := Value;
end;

function TibSHDMLHistory.GetDelete: Boolean;
begin
  Result := FDelete;
end;

procedure TibSHDMLHistory.SetDelete(const Value: Boolean);
begin
  FDelete := Value;
end;

function TibSHDMLHistory.GetExecute: Boolean;
begin
  Result := FExecute;
end;

procedure TibSHDMLHistory.SetExecute(const Value: Boolean);
begin
  FExecute := Value;
end;

function TibSHDMLHistory.GetCrash: Boolean;
begin
  Result := FCrash;
end;

procedure TibSHDMLHistory.SetCrash(const Value: Boolean);
begin
  FCrash := Value;
end;

function TibSHDMLHistory.Count: Integer;
begin
  Result := FItems.Count;
end;

procedure TibSHDMLHistory.Clear;
var
  I: Integer;
  vDMLHistoryForm: IibSHDMLHistoryForm;
begin
  FItems.Clear;
  FStatistic.Clear;
  ClearDigestList;
  FStatementCRC.Clear;
  SaveToFile;
  for I := 0 to Pred(ComponentForms.Count) do
    if Supports(ComponentForms[I], IibSHDMLHistoryForm, vDMLHistoryForm) then
    begin
      vDMLHistoryForm.FillEditor;
    end;
end;

function TibSHDMLHistory.Statement(Index: Integer): string;
//var
//  vStatement: TStringList;
//  I: Integer;
begin
  Result := EmptyStr;
  if (Index >= 0) and (Index < Count) then
  begin
    Result := FItems[Index];
    System.Delete(Result, 1, Pos(#13#10,Result) + 1);
  end;  
  {
  Result := EmptyStr;
  if (Index >= 0) and (Index < Count) then
  begin
    vStatement := TStringList.Create;
    try
      vStatement.Text := FItems[Index];
      if vStatement.Count > 1 then
      begin
        vStatement.Delete(0);
        I := 0;
        while (I < vStatement.Count) and (Pos(sHistoryStatisticsHeader, vStatement[I]) = 0) do Inc(I);
        while (I < vStatement.Count) do vStatement.Delete(I);
        Result := vStatement.Text;
      end;
    finally
      vStatement.Free;
    end;
  end;
  }
end;

function TibSHDMLHistory.Item(Index: Integer): string;
//var
//  vStatement: TStringList;
//  I: Integer;
begin
  Result := EmptyStr;
  if (Index >= 0) and (Index < Count) then
    Result := FItems[Index];
  {
  Result := EmptyStr;
  if (Index >= 0) and (Index < Count) then
  begin
    vStatement := TStringList.Create;
    try
      vStatement.Text := FItems[Index];
      if vStatement.Count > 1 then
      begin
        I := 1;
        while (I < vStatement.Count) and (Pos(sHistoryStatisticsHeader, vStatement[I]) = 0) do Inc(I);
        while (I < vStatement.Count) do vStatement.Delete(I);
        Result := vStatement.Text;
      end;
    finally
      vStatement.Free;
    end;
  end;
  }
end;

function TibSHDMLHistory.Statistics(Index: Integer): string;
//var
//  vStatement: TStringList;
//  I: Integer;
begin
  Result := EmptyStr;
  if (Index >= 0) and (Index < Count) then
  begin
    Result := FStatistic[Index];
    System.Delete(Result, 1, Pos(#13#10,Result) + 1);
  end;  
  {
  Result := EmptyStr;
  if (Index >= 0) and (Index < Count) then
  begin
    vStatement := TStringList.Create;
    try
      vStatement.Text := FItems[Index];
      if vStatement.Count > 1 then
      begin
        I := 0;
        while (I < vStatement.Count) and (Pos(sHistoryStatisticsHeader, vStatement[I]) = 0) do vStatement.Delete(0);
        vStatement.Delete(0);
        Result := vStatement.Text;
      end;
    finally
      vStatement.Free;
    end;
  end;
  }
end;

function TibSHDMLHistory.AddStatement(AStatement: string;
  AStatistics: IibSHStatistics): Integer;
var
  vItem: string;
  vFileName: string;
  vStatistic: string;
  vDMLHistoryForm: IibSHDMLHistoryForm;
  vDigest: Int64;
  vExistingIndex: Integer;
  I: Integer;
  function TrimLeftEpmtyStr(AString: string): string;
  var
    vStrList: TStringList;
  begin
    vStrList := TStringList.Create;
    Result := AString;
    try
      vStrList.Text := AString;
      while (vStrList.Count > 0) and (Length(vStrList[0]) = 0) do
        vStrList.Delete(0);
      Result := TrimRight(vStrList.Text);
    finally
      vStrList.Free;
    end;
  end;
begin
  Result := -1;
  if Active then
  begin
    FSQLParser.SQLText := AStatement;
    if ((FSQLParser.SQLKind = skSelect) and (not Select)) or
       ((FSQLParser.SQLKind = skInsert) and (not Insert)) or
       ((FSQLParser.SQLKind = skUpdate) and (not Update)) or
       ((FSQLParser.SQLKind = skDelete) and (not Delete)) or
       ((FSQLParser.SQLKind = skExecuteProc) and (not Execute)) then Exit;  //!!!
    vDigest := SQLTextDigest(AStatement);
    vExistingIndex := -1;
    for I := Pred(FStatementCRC.Count) downto 0 do
    begin
      if vDigest = PInt64(FStatementCRC[I])^ then
      begin
        vExistingIndex := I;
        Break;
      end;
    end;
    vItem := Format(sHistorySQLHeader + sHistorySQLHeaderSuf, [DateTimeToStr(Now)]) +
             sLineBreak +
             TrimLeftEpmtyStr(AStatement) +
             sLineBreak + sLineBreak;

    vStatistic := EmptyStr;
    if Assigned(AStatistics) then
    begin
      vStatistic := sHistoryStatisticsHeader + sLineBreak;
      if Assigned(AStatistics.DRVTimeStatistics) then
      begin
        vStatistic := vStatistic + Format(SHistoryExecute + '=%d' + sLineBreak, [AStatistics.DRVTimeStatistics.ExecuteTime]);
        vStatistic := vStatistic + Format(SHistoryPrepare + '=%d' + sLineBreak, [AStatistics.DRVTimeStatistics.PrepareTime]);
        vStatistic := vStatistic + Format(SHistoryFetch + '=%d' + sLineBreak, [AStatistics.DRVTimeStatistics.FetchTime]);
      end;
      vStatistic := vStatistic + Format(SHistoryIndexedReads + '=%d' + sLineBreak, [AStatistics.DRVStatistics.IdxReads]);
      vStatistic := vStatistic + Format(SHistoryNonIndexedReads + '=%d' + sLineBreak, [AStatistics.DRVStatistics.SeqReads]);
      vStatistic := vStatistic + Format(SHistoryInserts + '=%d' + sLineBreak, [AStatistics.DRVStatistics.Inserts]);
      vStatistic := vStatistic + Format(SHistoryUpdates + '=%d' + sLineBreak, [AStatistics.DRVStatistics.Updates]);
      vStatistic := vStatistic + Format(SHistoryDeletes + '=%d' + sLineBreak, [AStatistics.DRVStatistics.Deletes]);
    end;

    if vExistingIndex > -1 then
    begin
      FStatistic.Delete(vExistingIndex);
      FItems.Delete(vExistingIndex);
      Dispose(PInt64(FStatementCRC[vExistingIndex]));
      FStatementCRC.Delete(vExistingIndex);
    end;
    AddSQLTextDigest(vDigest);
    FStatistic.Add(vStatistic);
    Result := FItems.Add(vItem);

    vItem := FItems[Result] + FStatistic[Result] + sLineBreak +
      Format(SHistorySQLTextDigest + '=%d', [PInt64(FStatementCRC[Result])^]) + sLineBreak;
    vFileName := GetHistoryFileName;
    AddToTextFile(vFileName, vItem);

    if GetComponentFormIntf(IibSHDMLHistoryForm, vDMLHistoryForm) then
      vDMLHistoryForm.ChangeNotification(vExistingIndex, opInsert);
  end;
end;

procedure TibSHDMLHistory.DeleteStatement(AStatementNo: Integer);
var
  vDMLHistoryForm: IibSHDMLHistoryForm;
begin
  if (AStatementNo >= 0) and (AStatementNo < FItems.Count) then
  begin
    FStatistic.Delete(AStatementNo);
    FItems.Delete(AStatementNo);
    Dispose(PInt64(FStatementCRC[AStatementNo]));
    FStatementCRC.Delete(AStatementNo);
    if GetComponentFormIntf(IibSHDMLHistoryForm, vDMLHistoryForm) then
      vDMLHistoryForm.ChangeNotification(AStatementNo, opRemove);
  end;
end;

procedure TibSHDMLHistory.LoadFromFile;
var
  vFileName: string;
  vTextFile: TextFile;
  vItem: TStringList;
  vStatistic: TStringList;
  S: string;
  vCurrent: Integer;
  vStatisticIndex: Integer;
  vDigestIndex: Integer;
  procedure SetItem;
  var
    I: Integer;
    vCurrentDiget: Int64;
  begin
    if vItem.Count > 0 then
    begin
      if vDigestIndex > -1 then
      begin
        vCurrentDiget := StrToInt64Def(vItem.ValueFromIndex[vDigestIndex], 0);
        AddSQLTextDigest(vCurrentDiget);
        vItem.Delete(vDigestIndex);
      end
      else
      begin
        vCurrentDiget := SQLTextDigest(Statement(Pred(FItems.Count)));
        AddSQLTextDigest(vCurrentDiget);
      end;

      if vStatisticIndex > -1 then
        for I := vStatisticIndex to Pred(vItem.Count) do
          vStatistic.Add(vItem[I]);
      while Pred(vItem.Count) >= vStatisticIndex do
        vItem.Delete(Pred(vItem.Count));
      FItems.Add(vItem.Text);
      FStatistic.Add(vStatistic.Text);

      if vCurrentDiget <> 0 then
        for I := Pred(Pred(FStatementCRC.Count)) downto 0 do //Pred(Pred - Пропускаем только что вставленный!
        begin
          if vCurrentDiget = PInt64(FStatementCRC[I])^ then
          begin
            FItems.Delete(I);
            FStatistic.Delete(I);
            Dispose(PInt64(FStatementCRC[I]));
            FStatementCRC.Delete(I);
            Break;
          end;
        end;
    end;    
  end;
begin
  vFileName := GetHistoryFileName;
  if FileExists(vFileName) then
  begin
    FItems.Clear;
    vItem := TStringList.Create;
    vStatistic := TStringList.Create;
    try
      AssignFile(vTextFile, vFileName);
      try
        Reset(vTextFile);
        vStatisticIndex := -1;
        vDigestIndex := -1;
        while not Eof(vTextFile) do
        begin
          Readln(vTextFile, S);
          if Pos(sHistorySQLHeader, S) > 0 then
          begin
            if vItem.Count = 0 then vItem.Add(S)
            else
            begin
              SetItem;
//              FItems.Add(vItem.Text);
              vItem.Clear;
              vStatistic.Clear;
              vStatisticIndex := -1;
              vDigestIndex := -1;
              vItem.Add(S)
            end;
          end
          else
          begin
            vCurrent := vItem.Add(S);
            if Pos(sHistoryStatisticsHeader, S) > 0 then
              vStatisticIndex := vCurrent
            else
            if Pos(SHistorySQLTextDigest, S) > 0 then
              vDigestIndex := vCurrent;
          end;
        end;
        SetItem;
      finally
        CloseFile(vTextFile);
      end;
    finally
      vItem.Free;
      vStatistic.Free;
    end;

    //Обеспечиваем чистку "лишних" сиквелов - сжатие файла необходимо, т.к.
    //автозапись каждого сиквела не удаляет предыдущие выполения
    SaveToFile;
  end;
end;

procedure TibSHDMLHistory.SaveToFile;
var
  vStartSavingFrom: Integer;
  I: Integer;
  vFileName: string;
  vTextFile: TextFile;
begin
  if Count > 0 then
  begin
    vFileName := GetHistoryFileName;
    if Length(vFileName) > 0 then
    begin
      AssignFile(vTextFile, vFileName);
      try
        Rewrite(vTextFile);
        if (MaxCount = 0) or (Count < MaxCount) then
          vStartSavingFrom := 0
        else
          vStartSavingFrom := Count - MaxCount;

        for I := vStartSavingFrom to Pred(Count) do
          Writeln(vTextFile,
            FItems[I] + FStatistic[I] + sLineBreak +
            Format(SHistorySQLTextDigest + '=%d', [PInt64(FStatementCRC[I])^])
            );
      finally
        CloseFile(vTextFile);
      end;
    end;
  end
  else
  begin
    vFileName := GetHistoryFileName;
    if (Length(vFileName) > 0) and FileExists(vFileName) then
      RenameFile(vFileName, vFileName + '.bak');
//      DeleteFile(vFileName);
  end;
end;

function TibSHDMLHistory.SQLTextDigest(AText: string): Int64;
type
  PInt64 = ^Int64;
var
  NormSQL: string;
  Digest: TSHA1Digest;
begin
  NormalizeSQLText(AText, '@', NormSQL);
  Q_SHA1(Trim(NormSQL), Digest);
  Result := PInt64(@Digest)^;
end;

procedure TibSHDMLHistory.AddSQLTextDigest(ADigest: Int64);
var
  vDigest: PInt64;
begin
  New(vDigest);
  vDigest^ := ADigest;
  FStatementCRC.Add(vDigest);
end;

procedure TibSHDMLHistory.ClearDigestList;
var
  I: Integer;
begin
  for I := 0 to Pred(FStatementCRC.Count) do
    Dispose(PInt64(FStatementCRC[I]));
end;

{ TibSHDMLHistoryFactory }

function TibSHDMLHistoryFactory.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDMLHistory);
end;

function TibSHDMLHistoryFactory.CreateComponent(const AOwnerIID,
  AClassIID: TGUID; const ACaption: string): TSHComponent;
var
  BTCLDatabase: IibSHDatabase;
  vSHSystemOptions: ISHSystemOptions;
begin
  Result := nil;
  if IsEqualGUID(AOwnerIID, IUnknown) then
  begin
    Supports(Designer.CurrentDatabase, IibSHDatabase, BTCLDatabase);
    if not Assigned(BTCLDatabase) and IsEqualGUID(AOwnerIID, IUnknown) and (Length(ACaption) = 0) then
      Designer.AbortWithMsg(Format('%s', [SDatabaseIsNotInterBase]));
    Result := Designer.FindComponent(Designer.CurrentDatabase.InstanceIID, AClassIID);
    if not Assigned(Result) then
    begin
      Result := Designer.GetComponent(AClassIID).Create(nil);
      Result.OwnerIID := Designer.CurrentDatabase.InstanceIID;
      Result.Caption := Designer.GetComponent(AClassIID).GetHintClassFnc;
      if Assigned(BTCLDatabase) and
        Supports(Designer.GetOptions(ISHSystemOptions), ISHSystemOptions, vSHSystemOptions) and
        not vSHSystemOptions.UseWorkspaces then
        Result.Caption := Format('%s for %s', [Result.Caption, BTCLDatabase.Alias]);
    end;
    Designer.ChangeNotification(Result, SCallDMLStatements, opInsert)
  end
  else
  begin
    if Supports(Designer.FindComponent(AOwnerIID), IibSHDatabase, BTCLDatabase) then
    begin
      Result := Designer.FindComponent(AOwnerIID, AClassIID);
      if not Assigned(Result) then
      begin
        Result := Designer.GetComponent(AClassIID).Create(nil);
        Result.OwnerIID := AOwnerIID;
        Result.Caption := Designer.GetComponent(AClassIID).GetHintClassFnc;
        if Assigned(BTCLDatabase) and
          Supports(Designer.GetOptions(ISHSystemOptions), ISHSystemOptions, vSHSystemOptions) and
          not vSHSystemOptions.UseWorkspaces then
          Result.Caption := Format('%s for %s', [Result.Caption, BTCLDatabase.Alias]);
      end;
      Designer.ChangeNotification(Result, SCallDMLStatements, opInsert);
    end
    else
      Designer.AbortWithMsg(Format('%s', [SDatabaseIsNotInterBase]));
  end;
end;

initialization

  Register;

end.

