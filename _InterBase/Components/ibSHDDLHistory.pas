unit ibSHDDLHistory;

interface

uses
  SysUtils, Classes,
  SHDesignIntf, SHOptionsIntf,
  pSHSqlTxtRtns, pSHStrUtil,
  ibSHMessages, ibSHConsts, ibSHDesignIntf, ibSHTool, ibSHComponent, ibSHValues;

type
  TibSHDDLHistory = class(TibBTTool, IibSHDDLHistory, IibSHBranch, IfbSHBranch)
  private
    FItems: TStringList;
    FNewItems: TStringList;
    FActive: Boolean;
  protected
    procedure  SetOwnerIID(Value: TGUID); override;
    { IibSHDDLHistory }
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    function GetHistoryFileName: string;
    function Count: Integer;
    procedure Clear;
    function Statement(Index: Integer): string;
    function Item(Index: Integer): string;
    function AddStatement(AStatement: string): Integer;
    procedure CommitNewStatements;
    procedure RollbackNewStatements;
    procedure LoadFromFile;
    procedure SaveToFile;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Active: Boolean read GetActive write SetActive;
  end;

  TibSHDDLHistoryFactory = class(TibBTComponentFactory)
    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    function CreateComponent(const AOwnerIID, AClassIID: TGUID; const ACaption: string): TSHComponent; override;
  end;

procedure Register;

implementation

uses
  ibSHDDLHistoryActions,
  ibSHDDLHistoryEditors;

procedure Register;
begin
  SHRegisterImage(GUIDToString(IibSHDDLHistory), 'DDLHistory.bmp');

  SHRegisterImage(TibSHDDLHistoryPaletteAction.ClassName,         'DDLHistory.bmp');
  SHRegisterImage(TibSHDDLHistoryFormAction.ClassName,            'Form_DDLText.bmp');
  SHRegisterImage(TibSHDDLHistoryToolbarAction_Run.ClassName,     'Button_Run.bmp');
  SHRegisterImage(TibSHDDLHistoryToolbarAction_Pause.ClassName,   'Button_Stop.bmp');
  SHRegisterImage(TibSHDDLHistoryToolbarAction_Region.ClassName,  'Button_Tree.bmp');
  SHRegisterImage(TibSHDDLHistoryToolbarAction_Refresh.ClassName, 'Button_Refresh.bmp');
  SHRegisterImage(TibSHDDLHistoryToolbarAction_Save.ClassName,    'Button_Save.bmp');

  SHRegisterImage(SCallDDLStatements, 'Form_DDLText.bmp');

  SHRegisterComponents([
    TibSHDDLHistory,
    TibSHDDLHistoryFactory]);

  SHRegisterActions([
    // Palette
    TibSHDDLHistoryPaletteAction,
    // Forms
    TibSHDDLHistoryFormAction,
    // Toolbar
    TibSHDDLHistoryToolbarAction_Run,
    TibSHDDLHistoryToolbarAction_Pause,
    TibSHDDLHistoryToolbarAction_Region,
    TibSHDDLHistoryToolbarAction_Refresh,
    TibSHDDLHistoryToolbarAction_Save,
    // Editors
    TibSHDDLHistoryEditorAction_SendToSQLEditor,
    TibSHDDLHistoryEditorAction_ShowDDLHistory]);
end;

{ TibSHDDLHistory }

constructor TibSHDDLHistory.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  FItems := TStringList.Create;
  FNewItems := TStringList.Create;
end;

destructor TibSHDDLHistory.Destroy;
begin
  FItems.Free;
  FNewItems.Free;
  inherited;
end;

procedure TibSHDDLHistory.SetOwnerIID(Value: TGUID);
var
  vDatabaseAliasOptionsInt: IibSHDatabaseAliasOptionsInt;
begin
  if not IsEqualGUID(OwnerIID, Value) then
  begin
    inherited SetOwnerIID(Value);
    if Supports(BTCLDatabase, IibSHDatabaseAliasOptionsInt, vDatabaseAliasOptionsInt) then
      Active := vDatabaseAliasOptionsInt.DDLHistoryActive
    else
      Active := True;
    LoadFromFile;
  end;
end;

function TibSHDDLHistory.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure TibSHDDLHistory.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;

function TibSHDDLHistory.GetHistoryFileName: string;
var
  vDir: string;
begin
  Result := EmptyStr;
  if Assigned(BTCLDatabase) then
  begin
    vDir := BTCLDatabase.DataRootDirectory;
    if SysUtils.DirectoryExists(vDir) then
      Result := vDir + DDLHistoryFile;
    vDir := ExtractFilePath(Result);
    if not SysUtils.DirectoryExists(vDir) then
      ForceDirectories(vDir);
  end;
end;

function TibSHDDLHistory.Count: Integer;
begin
  Result := FItems.Count;
end;

procedure TibSHDDLHistory.Clear;
var
  I: Integer;
  vDDLHistoryForm: IibSHDDLHistoryForm;
begin
  FItems.Clear;
  SaveToFile;
  for I := 0 to Pred(ComponentForms.Count) do
    if Supports(ComponentForms[I], IibSHDDLHistoryForm, vDDLHistoryForm) then
    begin
      vDDLHistoryForm.FillEditor;
    end;
end;

function TibSHDDLHistory.Statement(Index: Integer): string;
var
  vPosFirstLineEnd: Integer;
begin
  Result := EmptyStr;
  if (Index >= 0) and (Index < Count) then
  begin
    vPosFirstLineEnd := Pos(sLineBreak, FItems[Index]);
    if vPosFirstLineEnd > 0 then
      Result := Copy(FItems[Index], vPosFirstLineEnd + Length(sLineBreak), MaxInt);
  end;
end;

function TibSHDDLHistory.Item(Index: Integer): string;
begin
  Result := EmptyStr;
  if (Index >= 0) and (Index < Count) then
    Result := FItems[Index];
end;

function TibSHDDLHistory.AddStatement(AStatement: string): Integer;
var
  vItem: string;
//  I: Integer;
//  vDDLHistoryForm: IibSHDDLHistoryForm;
  vFirstWord: string;
  vSecondWord: string;
  vStatement: string;
begin
  Result := -1;
  if Active then
  begin
    vStatement := Trim(AStatement);
    vFirstWord := ExtractWord(1, vStatement, CharsAfterClause);
    vSecondWord := ExtractWord(2, vStatement, CharsAfterClause);
    if (not SameText(vFirstWord, 'DROP')) and
      (SameText(vSecondWord, 'PROCEDURE') or SameText(vSecondWord, 'TRIGGER')) then
    begin
      while (Length(vStatement) > 0) and (vStatement[Length(vStatement)] in [';', '^']) do
        Delete(vStatement, Length(vStatement), 1);
      vStatement := Format('SET TERM ^ ;' + sLineBreak + sLineBreak + '%s^' + sLineBreak + sLineBreak + 'SET TERM ; ^', [vStatement]);
    end
    else
      if (Length(vStatement) > 0) and (vStatement[Length(vStatement)] <> ';') then
        vStatement := vStatement + ';';

    vItem := Format(sHistorySQLHeader + sHistorySQLHeaderSuf, [DateTimeToStr(Now)]) +
             sLineBreak +
             vStatement +
             sLineBreak + sLineBreak;
//    Result := FItems.Add(vItem);
    Result := FNewItems.Add(vItem);
//    for I := 0 to Pred(ComponentForms.Count) do
//      if Supports(ComponentForms[I], IibSHDDLHistoryForm, vDDLHistoryForm) then
//      begin
//        vDDLHistoryForm.ChangeNotification;
//        Break;
//      end;
    //≈сли есть форма, то она, проверив ручные изменени€ сама добавит новый сиквел к файлу истории
    //≈сли формы нет, добавл€ем сиквел здесь к файлу истории
//    if not Assigned(vDDLHistoryForm) then
//    begin
//      vFileName := GetHistoryFileName;
//      if Length(vFileName) > 0 then
//        AddToTextFile(vFileName, vItem);
//    end;
  end;
end;

procedure TibSHDDLHistory.CommitNewStatements;
var
  I: Integer;
  vDDLHistoryForm: IibSHDDLHistoryForm;
  vFileName: string;
begin
  for I := 0 to Pred(FNewItems.Count) do
    FItems.Add(FNewItems[I]);
  if GetComponentFormIntf(IibSHDDLHistoryForm, vDDLHistoryForm) then
    vDDLHistoryForm.ChangeNotification
  else
  //≈сли есть форма, то она, проверив ручные изменени€ сама добавит новый сиквел к файлу истории
  //≈сли формы нет, добавл€ем сиквелы здесь к файлу истории
  begin
    vFileName := GetHistoryFileName;
    if Length(vFileName) > 0 then
      for I := 0 to Pred(FNewItems.Count) do
        AddToTextFile(vFileName, FNewItems[I]);
  end;
  FNewItems.Clear;
end;

procedure TibSHDDLHistory.RollbackNewStatements;
begin
  FNewItems.Clear;
end;

procedure TibSHDDLHistory.LoadFromFile;
var
  vFileName: string;
  vTextFile: TextFile;
  vItem: TStringList;
  S: string;
begin
  vFileName := GetHistoryFileName;
  if FileExists(vFileName) then
  begin
    FItems.Clear;
    vItem := TStringList.Create;
    try
      AssignFile(vTextFile, vFileName);
      try
        Reset(vTextFile);
        while not Eof(vTextFile) do
        begin
          Readln(vTextFile, S);
          if Pos(sHistorySQLHeader, S) > 0 then
          begin
            if vItem.Count = 0 then vItem.Add(S)
            else
            begin
              FItems.Add(vItem.Text);
              vItem.Clear;
              vItem.Add(S)
            end;
          end
          else
            if vItem.Count > 0 then
              vItem.Add(S);
        end;
        if vItem.Count > 0 then
          FItems.Add(vItem.Text);
      finally
        CloseFile(vTextFile);
      end;
    finally
      vItem.Free;
    end;
  end;
end;

procedure TibSHDDLHistory.SaveToFile;
var
  I: Integer;
  vFileName: string;
  vTextFile: TextFile;
  vSaved: Boolean;
begin
  vSaved := False;
  for I := 0 to Pred(ComponentForms.Count) do
    if Supports(ComponentForms[I], IibSHDDLHistoryForm) and
      Supports(ComponentForms[I], ISHFileCommands) then
    begin
      (ComponentForms[I] as ISHFileCommands).Save;
      vSaved := True;
    end;

  if (not vSaved) then
  begin
    if (Count > 0) then
    begin
      vFileName := GetHistoryFileName;
      if Length(vFileName) > 0 then
      begin
        AssignFile(vTextFile, vFileName);
        try
          Rewrite(vTextFile);
          for I := 0 to Pred(Count) do
            Writeln(vTextFile, FItems[I]);
        finally
          CloseFile(vTextFile);
        end;
      end;
    end
    else
    begin
      vFileName := GetHistoryFileName;
      if (Length(vFileName) > 0) and FileExists(vFileName) then
        DeleteFile(vFileName);
    end;
  end;  
end;

{ TibSHDDLHistoryFactory }

function TibSHDDLHistoryFactory.CreateComponent(const AOwnerIID,
  AClassIID: TGUID; const ACaption: string): TSHComponent;
var
  BTCLDatabase: IibSHDatabase;
  vSHSystemOptions: ISHSystemOptions;
begin
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
        (not vSHSystemOptions.UseWorkspaces) then
        Result.Caption := Format('%s for %s', [Result.Caption, BTCLDatabase.Alias]);
    end;
    Designer.ChangeNotification(Result, SCallDDLStatements, opInsert);
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
          (not vSHSystemOptions.UseWorkspaces) then
          Result.Caption := Format('%s for %s', [Result.Caption, BTCLDatabase.Alias]);
      end;
      Designer.ChangeNotification(Result, SCallDDLStatements, opInsert);
    end
    else
      Designer.AbortWithMsg(Format('%s', [SDatabaseIsNotInterBase]));
  end;
end;

function TibSHDDLHistoryFactory.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDDLHistory);
end;

initialization

  Register;

end.

