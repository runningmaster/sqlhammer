unit ibSHSQLEditorFrm;

interface

uses
  SHDesignIntf, SHOptionsIntf, SHEvents, ibSHDesignIntf, ibSHDriverIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, AppEvnts, ImgList, Menus,
  SynEdit, SynEditKeyCmds, SynEditTypes,
  pSHSynEdit, ActnList, pSHIntf, pSHSqlTxtRtns, pSHStrUtil,VirtualTrees;

type
  TibSHSQLEditorForm = class(TibBTComponentForm, IibSHSQLEditorForm)
    Panel2: TPanel;
    pSHSynEdit2: TpSHSynEdit;
    Splitter1: TSplitter;
    Panel1: TPanel;
    pSHSynEdit1: TpSHSynEdit;
    ImageList1: TImageList;
    PopupMenuMessage: TPopupMenu;
    pmiHideMessage: TMenuItem;
    function SQLEditorLastContextFileName: string;
    procedure pSHSynEdit1ProcessUserCommand(Sender: TObject;
      var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure pmiHideMessageClick(Sender: TObject);
  private
    { Private declarations }
    FSQLParser: TSQLParser;
    FDRVQuery: TComponent;
    FNeedFecthAll: Boolean;
    FDMLHistoryComponent: TSHComponent;
    FDMLHistory: IibSHDMLHistory;
    FCurrentStatementNo: Integer;
    FImageIndexMsg: Integer;
    FDisableAllActions: Boolean;
    FSuppressPlan: Boolean;
    procedure GutterDrawNotify(Sender: TObject; ALine: Integer; var ImageIndex: Integer);
    procedure SaveEditorContext;
    procedure AddToHistory(AText: string);
    function GetBTCLDatabase: IibSHDatabase;
    function GetSQLEditorIntf: IibSHSQLEditor;
    function GetDRVQuery: IibSHDRVQuery;
    function GetData: IibSHData;
    function GetStatistics: IibSHStatistics;
    function GetDMLHistory: IibSHDMLHistory;
    function GetDisableAllActions: Boolean;
  protected
    procedure EditorMsgVisible(AShow: Boolean = True); override;

    function ConfirmEndTransaction: Boolean;
    function DoOnOptionsChanged: Boolean; override;
    procedure DoOnIdle; override;
    function GetCanDestroy: Boolean; override;
    { ISHFileCommands }
//    function GetCanOpen: Boolean; virtual;
//    function GetCanSave: Boolean; virtual;
//    function GetCanSaveAs: Boolean; virtual;

//    procedure Open; virtual;
//    procedure Save; virtual;
//    procedure SaveAs; virtual;

    { ISHEditCommands }
    procedure ClearAll; override;

    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanPause: Boolean; override;
    function GetCanCommit: Boolean; override;
    function GetCanRollback: Boolean; override;

    procedure Run; override;
    procedure Pause; override;
    procedure Commit; override;
    procedure Rollback; override;

    {IibSHSQLEditorForm}
    function GetSQLText: string;
    procedure ShowPlan;
    procedure ShowTransactionCommited;
    procedure ShowTransactionRolledBack;
    procedure ShowStatistics;
    procedure ClearMessages;
    procedure InsertStatement(AText: string);
    procedure LoadLastContext;

    function GetCanPreviousQuery: Boolean;
    function GetCanNextQuery: Boolean;
    function GetCanPrepare: Boolean;
    function GetCanEndTransaction: Boolean;

    procedure PreviousQuery;
    procedure NextQuery;
    procedure RunAndFetchAll;
    procedure IibSHSQLEditorForm.Prepare = IPrepare;
    procedure IPrepare;

  public
    procedure Prepare(ForceShowPlan: Boolean = False);
    function PrepareQuery(const AText: string; ForceShowPlan: Boolean = False): Boolean;
    procedure RunQuery(const AText: string);

    property DRVQuery: IibSHDRVQuery read GetDRVQuery;
    property DisableAllActions: Boolean read GetDisableAllActions write FDisableAllActions;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure AddToResultEdit(AText: string);

    property SQLEditor: IibSHSQLEditor read GetSQLEditorIntf;
    property DMLHistory: IibSHDMLHistory read GetDMLHistory;
    property BTCLDatabase: IibSHDatabase read GetBTCLDatabase;
    property Data: IibSHData read GetData;
    property Statistics: IibSHStatistics read GetStatistics;
  end;
var
  ibSHSQLEditorForm: TibSHSQLEditorForm;

implementation

uses
  ibSHConsts, ibSHMessages, ibSHValues;

{$R *.dfm}

const
  img_success = 0;
  img_error   = 1;

{ TibSHSQLEditorForm }

constructor TibSHSQLEditorForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  EditorMsg := pSHSynEdit2;
  EditorMsg.Lines.Clear;
  EditorMsg.OnGutterDraw := GutterDrawNotify;
  EditorMsg.GutterDrawer.ImageList := ImageList1;
  EditorMsg.GutterDrawer.Enabled := True;
  FImageIndexMsg := img_success;

  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
  FocusedControl := Editor;

  RegisterEditors;
  EditorMsgVisible(False);
  DoOnOptionsChanged;
  FSQLParser := TSQLParser.Create;

  if Assigned(BTCLDatabase) and Assigned(Data) then
  begin
    vComponentClass := Designer.GetComponent(BTCLDatabase.BTCLServer.DRVNormalize(IibSHDRVQuery));
    if Assigned(vComponentClass) then
    begin
      FDRVQuery := vComponentClass.Create(Self);
      DRVQuery.Database := BTCLDatabase.DRVQuery.Database;
      DRVQuery.Transaction := Data.Transaction;
    end;
  end;
  with Editor.Keystrokes do
      AddKey(ecpSHUserFirst + 1, VK_F9, [ssCtrl]);
  if Assigned(DMLHistory) then
    FCurrentStatementNo := DMLHistory.Count
  else
    FCurrentStatementNo := -1;

  FDMLHistory := nil;
  FDMLHistoryComponent := nil;
  FSuppressPlan := False;
end;

destructor TibSHSQLEditorForm.Destroy;
begin
  if Assigned(FDMLHistory) then
  begin
    FDMLHistory.SaveToFile;
    if not Assigned(Designer.GetComponentForm(IibSHDMLHistoryForm, SCallDMLStatements)) and
      Assigned(FDMLHistoryComponent) then
    begin
      Designer.ChangeNotification(FDMLHistoryComponent, opRemove);
      FDMLHistoryComponent.Free;
    end;
  end;
  if Assigned(FDRVQuery) then
    FDRVQuery.Free;
  SaveEditorContext;
  FSQLParser.Free;
  inherited Destroy;
end;

procedure TibSHSQLEditorForm.GutterDrawNotify(Sender: TObject; ALine: Integer;
  var ImageIndex: Integer);
begin
  if ALine = 0 then ImageIndex := FImageIndexMsg;
end;

procedure TibSHSQLEditorForm.SaveEditorContext;
var
  vFileName: string;
begin
  vFileName := SQLEditorLastContextFileName;
  if Assigned(BTCLDatabase) and  Assigned(Editor) and
     (not Editor.IsEmpty) and (Length(vFileName) > 0) then
    try
      Editor.Lines.SaveToFile(vFileName);
    except
    end;
end;

procedure TibSHSQLEditorForm.AddToHistory(AText: string);
begin
  if Assigned(DMLHistory) then
    FCurrentStatementNo := DMLHistory.AddStatement(AText, Statistics);
end;

function TibSHSQLEditorForm.GetBTCLDatabase: IibSHDatabase;
begin
  Supports(Component, IibSHDatabase, Result);
end;

function TibSHSQLEditorForm.GetSQLEditorIntf: IibSHSQLEditor;
begin
  Supports(Component, IibSHSQLEditor, Result);
end;

function TibSHSQLEditorForm.GetDRVQuery: IibSHDRVQuery;
begin
  Supports(FDRVQuery, IibSHDRVQuery, Result);
end;

function TibSHSQLEditorForm.GetData: IibSHData;
begin
  Supports(Component, IibSHData, Result);
end;

function TibSHSQLEditorForm.GetStatistics: IibSHStatistics;
begin
  Supports(Component, IibSHStatistics, Result);
end;

function TibSHSQLEditorForm.GetDMLHistory: IibSHDMLHistory;
var
  vHistoryComponentClass: TSHComponentClass;
  vSHSystemOptions: ISHSystemOptions;
begin
  if not Assigned(FDMLHistory) then
  begin
    if not Supports(Designer.FindComponent(Component.OwnerIID, IibSHDMLHistory), IibSHDMLHistory, FDMLHistory) then
    begin
      vHistoryComponentClass := Designer.GetComponent(IibSHDMLHistory);
      if Assigned(vHistoryComponentClass) then
      begin
        FDMLHistoryComponent := vHistoryComponentClass.Create(nil);
        FreeNotification(FDMLHistoryComponent);
        FDMLHistoryComponent.OwnerIID := Component.OwnerIID;
        FDMLHistoryComponent.Caption := vHistoryComponentClass.GetHintClassFnc;
        if Assigned(BTCLDatabase) and
          Supports(Designer.GetOptions(ISHSystemOptions), ISHSystemOptions, vSHSystemOptions) and
          not vSHSystemOptions.UseWorkspaces then
          FDMLHistoryComponent.Caption := Format('%s for %s', [FDMLHistoryComponent.Caption, BTCLDatabase.Alias]);
        Supports(FDMLHistoryComponent, IibSHDMLHistory, FDMLHistory);
      end;
    end;
    ReferenceInterface(FDMLHistory, opInsert);
  end;
  Result := FDMLHistory;
end;

function TibSHSQLEditorForm.GetDisableAllActions: Boolean;
begin
  Result := FDisableAllActions or
    (Assigned(SQLEditor) and (not SQLEditor.AutoCommit) and
    Assigned(Data) and Assigned(Data.Dataset) and Data.Dataset.IsFetching);
end;

procedure TibSHSQLEditorForm.EditorMsgVisible(AShow: Boolean = True);
begin
  Panel2.Visible := AShow;
  Splitter1.Visible := AShow;
  if AShow and Assigned(StatusBar) then
    StatusBar.Top := Self.Height;
end;

function TibSHSQLEditorForm.ConfirmEndTransaction: Boolean;
begin
  Result := Assigned(BTCLDatabase) and
            Assigned(Data) and
            (
             (SameText(BTCLDatabase.DatabaseAliasOptions.DML.ConfirmEndTransaction, ConfirmEndTransactions[0]) and
             Assigned(Data.Dataset) and Data.Dataset.DataModified)
             or
             (SameText(BTCLDatabase.DatabaseAliasOptions.DML.ConfirmEndTransaction, ConfirmEndTransactions[1]))
            );
end;

function TibSHSQLEditorForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
  if Result and Assigned(EditorMsg) then EditorMsg.ReadOnly := True;
end;

procedure TibSHSQLEditorForm.DoOnIdle;
begin

end;

function TibSHSQLEditorForm.GetCanDestroy: Boolean;
var
  vMsgText: string;
  procedure DoTransactionAction;
  begin
    if Data.Transaction.InTransaction then
    begin
      if SameText(BTCLDatabase.DatabaseAliasOptions.DML.DefaultTransactionAction, DefaultTransactionActions[0]) then
        Commit
      else
        Rollback;
    end;
  end;
  procedure DoTransactionInvertAction;
  begin
    if Data.Transaction.InTransaction then
    begin
      if SameText(BTCLDatabase.DatabaseAliasOptions.DML.DefaultTransactionAction, DefaultTransactionActions[0]) then
        Rollback
      else
        Commit;
    end;
  end;

begin
  Result := inherited GetCanDestroy;
  if (not Assigned(BTCLDatabase)) or BTCLDatabase.WasLostconnect then Exit;
  if Result and Assigned(Data) then
  begin
    if Assigned(Data.Dataset) and Data.Dataset.Active and Data.Dataset.IsFetching then
    begin
      Result := False;
      Designer.ShowMsg(SDataFetching, mtInformation);
      Exit;
    end;
    if not SQLEditor.AutoCommit then
    begin
      if Data.Transaction.InTransaction then
      begin
        if ConfirmEndTransaction then
        begin
          if SameText(BTCLDatabase.DatabaseAliasOptions.DML.DefaultTransactionAction, DefaultTransactionActions[0]) then
            vMsgText := SCommitTransaction
          else
            vMsgText := SRollbackTransaction;
          case Designer.ShowMsg(vMsgText) of
            ID_YES: DoTransactionAction;
            ID_NO: DoTransactionInvertAction;
            else
              Result := False;
          end;
        end
        else
          DoTransactionAction;
      end;
    end
    else
      Commit;
  end;
end;

procedure TibSHSQLEditorForm.ClearAll;
begin
  if not pSHSynEdit1.IsEmpty then
    if not Designer.ShowMsg(SClearEditorContextWorning, mtConfirmation) then Exit;
  if Assigned(Editor) then
  begin
    Editor.Clear;
    Editor.Modified := False;
  end;
end;

function TibSHSQLEditorForm.GetCanRun: Boolean;
begin
  Result := (not DisableAllActions) and
    Assigned(Editor) and (not Editor.IsEmpty) and
    Assigned(SQLEditor) and Assigned(SQLEditor.BTCLDatabase) and
    (not SQLEditor.BTCLDatabase.WasLostConnect);
end;

function TibSHSQLEditorForm.GetCanPause: Boolean;
begin
  Result := False;
end;

function TibSHSQLEditorForm.GetCanCommit: Boolean;
begin
  Result := Assigned(Data) and Data.Transaction.InTransaction and not SQLEditor.AutoCommit;
end;

function TibSHSQLEditorForm.GetCanRollback: Boolean;
begin
  Result := Assigned(Data) and Data.Transaction.InTransaction and not SQLEditor.AutoCommit;
end;

procedure TibSHSQLEditorForm.Run;
begin
  if Assigned(Editor) and Assigned(SQLEditor) and
    Assigned(SQLEditor.BTCLDatabase) and (not SQLEditor.BTCLDatabase.WasLostConnect) then
    with Editor do
    begin
      FNeedFecthAll := False;
      if SelAvail and SQLEditor.ExecuteSelected then
        RunQuery(SelText)
      else
        RunQuery(Text);
    end;
end;

procedure TibSHSQLEditorForm.Pause;
begin
//Do nothing
end;

procedure TibSHSQLEditorForm.Commit;
begin
  if Assigned(Data) and Data.Transaction.InTransaction then
  begin
    Data.Transaction.Commit;
    ShowTransactionCommited;
  end;
end;

procedure TibSHSQLEditorForm.Rollback;
begin
  if Assigned(Data) and Data.Transaction.InTransaction then
  begin
    Data.Transaction.Rollback;
    ShowTransactionRolledBack;
  end;
end;

function TibSHSQLEditorForm.GetSQLText: string;
begin
  Result := EmptyStr;
  if Assigned(Editor) and Assigned(SQLEditor) and
    Assigned(SQLEditor.BTCLDatabase) and (not SQLEditor.BTCLDatabase.WasLostConnect) then
    with Editor do
    begin
      if SelAvail and SQLEditor.ExecuteSelected then
        Result := SelText
      else
        Result := Text;
    end;
end;

procedure TibSHSQLEditorForm.ShowPlan;
begin
  if not FSuppressPlan then
  begin
    AddToResultEdit(EmptyStr);
    if Assigned(Data) and Assigned(Data.Dataset) and
      Assigned(SQLEditor) and SQLEditor.RetrievePlan then
      AddToResultEdit(Data.Dataset.Plan);
    Application.ProcessMessages;
  end;
end;

procedure TibSHSQLEditorForm.ShowTransactionCommited;
begin
  if Assigned(SQLEditor) then
  begin
    if SQLEditor.AutoCommit and (EditorMsg.Lines.Count > 0)  then
      Designer.TextToStrings(sLineBreak + STransactionCommited, EditorMsg.Lines)
    else
      Designer.TextToStrings(STransactionCommited, EditorMsg.Lines, True);
    FImageIndexMsg := img_success;
  end;
end;

procedure TibSHSQLEditorForm.ShowTransactionRolledBack;
begin
  if Assigned(SQLEditor) then
  begin
    if SQLEditor.AutoCommit and (Length(EditorMsg.Lines.Text) > 0)  then
      Designer.TextToStrings(sLineBreak + STransactionRolledBack, EditorMsg.Lines)
    else
      Designer.TextToStrings(STransactionRolledBack, EditorMsg.Lines, True);
    FImageIndexMsg := img_success;
  end;
end;

procedure TibSHSQLEditorForm.ShowStatistics;
var
  I: Integer;
  vRunCommands: ISHRunCommands;
begin
  if Assigned(EditorMsg) and Assigned(SQLEditor) and
    SQLEditor.RetrieveStatistics and Assigned(BTCLDatabase) and
    (not BTCLDatabase.WasLostConnect) and Assigned(Data) and
    {Data.Dataset.Active and} Assigned(Statistics) then
  begin
    AddToResultEdit(Statistics.TableStatisticsStr(False));
//    Designer.TextToStrings(Statistics.TableStatisticsStr(False), EditorMsg.Lines);
    AddToResultEdit(Statistics.ExecuteTimeStatisticsStr);
//    Designer.TextToStrings(Statistics.ExecuteTimeStatisticsStr, EditorMsg.Lines);
    for I := 0 to Pred(Component.ComponentForms.Count) do
      if Supports(Component.ComponentForms[I], IibSHStatisticsForm) then
      begin
        if Supports(Component.ComponentForms[I], ISHRunCommands, vRunCommands) and
          vRunCommands.CanRefresh then
          vRunCommands.Refresh;
        Break;
      end;
  end;
end;

procedure TibSHSQLEditorForm.ClearMessages;
begin
  Designer.TextToStrings(EmptyStr, EditorMsg.Lines, True);
end;

procedure TibSHSQLEditorForm.InsertStatement(AText: string);
var
  vLinesBefore, vLinesInserted: Integer;
  vText: string;
begin
  if Assigned(Editor) then
  begin
    vLinesBefore := Editor.Lines.Count;
    Editor.BeginUpdate;
    vText := TrimRight(AText) + sLineBreak;
    if vLinesBefore > 0 then
      vText := vText + sLineBreak;
    Designer.TextToStrings(vText, Editor.Lines, False, True);
    Editor.BlockBegin := TBufferCoord(Point(1, 1));
    vLinesInserted := Editor.Lines.Count - vLinesBefore;
    if vLinesBefore > 0 then
      Editor.BlockEnd := TBufferCoord(Point(Length(Editor.Lines[vLinesInserted - 2]) + 1, vLinesInserted - 1))
    else
      Editor.BlockEnd := TBufferCoord(Point(Length(Editor.Lines[vLinesInserted - 1]) + 1, vLinesInserted));
    Editor.EndUpdate;
    Editor.TopLine := 1;
  end;
end;

procedure TibSHSQLEditorForm.LoadLastContext;
var
  vFileName: string;
begin
  vFileName := SQLEditorLastContextFileName;
  if Assigned(BTCLDatabase) and Assigned(Editor) and (Length(vFileName) > 0) and
    FileExists(vFileName) then
  begin
    if not Editor.IsEmpty then
      if not Designer.ShowMsg(SReplaceEditorContextWorning, mtConfirmation) then Exit;
    Editor.Lines.LoadFromFile(vFileName);
    Editor.Modified := False;
    Editor.SetFocus;
  end;
end;

function TibSHSQLEditorForm.GetCanPreviousQuery: Boolean;
begin
  Result := (not DisableAllActions) and
    Assigned(DMLHistory) and
    (FCurrentStatementNo > 0) and
    (DMLHistory.Count > 0) and
    (FCurrentStatementNo <= DMLHistory.Count);
end;

function TibSHSQLEditorForm.GetCanNextQuery: Boolean;
begin
  Result := (not DisableAllActions) and
    Assigned(DMLHistory) and
    (FCurrentStatementNo >= 0) and
    (FCurrentStatementNo < Pred(DMLHistory.Count));
end;

function TibSHSQLEditorForm.GetCanPrepare: Boolean;
begin
  Result := (not DisableAllActions) and Assigned(Editor) and (not Editor.IsEmpty);
end;

function TibSHSQLEditorForm.GetCanEndTransaction: Boolean;
begin
  Result := (not DisableAllActions) and Assigned(SQLEditor) and (not SQLEditor.AutoCommit);
end;

procedure TibSHSQLEditorForm.PreviousQuery;
begin
  if GetCanPreviousQuery then
  begin
    Dec(FCurrentStatementNo);
    Designer.TextToStrings(TrimRight(DMLHistory.Statement(FCurrentStatementNo)) + sLineBreak, Editor.Lines, True);
  end;
end;

procedure TibSHSQLEditorForm.NextQuery;
begin
  if GetCanNextQuery then
  begin
    Inc(FCurrentStatementNo);
    Designer.TextToStrings(TrimRight(DMLHistory.Statement(FCurrentStatementNo)) + sLineBreak, Editor.Lines, True);
  end;
end;

procedure TibSHSQLEditorForm.RunAndFetchAll;
begin
  if GetCanRun then
    with Editor do
    begin
      FNeedFecthAll := True;
      if SelAvail and SQLEditor.ExecuteSelected then
        RunQuery(SelText)
      else
        RunQuery(Text);
    end;
end;

procedure TibSHSQLEditorForm.IPrepare;
begin
  ClearMessages;
  Prepare(True);
end;

procedure TibSHSQLEditorForm.Prepare(ForceShowPlan: Boolean = False);
begin
  if Assigned(Editor) and Assigned(SQLEditor) and
    Assigned(SQLEditor.BTCLDatabase) and (not SQLEditor.BTCLDatabase.WasLostConnect) then
    with Editor do
      if SelAvail and SQLEditor.ExecuteSelected then
        PrepareQuery(SelText, ForceShowPlan)
      else
        PrepareQuery(Text, ForceShowPlan);
end;

function TibSHSQLEditorForm.PrepareQuery(const AText: string; ForceShowPlan: Boolean = False): Boolean;
var
  vPlan: string;
  vDatabase: IibSHDatabase;
  vBaseErrorCoord: TBufferCoord;
begin
  Result := False;
  if Supports(Component, IibSHDatabase, vDatabase) then
    with vDatabase.DRVQuery do
    begin
      SQL.Text := AText;
      try
        Transaction.StartTransaction;
        try
          Result := Prepare;
        finally
          Screen.Cursor := crDefault;
        end;
        if not Result then
        begin
          vBaseErrorCoord := GetErrorCoord(ErrorText);
          if SQLEditor.ExecuteSelected and Editor.SelAvail then
          begin
            vBaseErrorCoord.Char := vBaseErrorCoord.Char + Editor.BlockBegin.Char - 1;
            vBaseErrorCoord.Line := vBaseErrorCoord.Line + Editor.BlockBegin.Line - 1;
          end;
          ErrorCoord := vBaseErrorCoord;
          AddToResultEdit(ErrorText);
          FImageIndexMsg := img_error;
        end
        else
        begin
          AddToResultEdit(EmptyStr);
          if Assigned(SQLEditor) and (SQLEditor.RetrievePlan or ForceShowPlan) then
          begin
            vPlan := Plan;
            if Length(vPlan) > 0 then
              AddToResultEdit(vPlan)
            else
              if Length(ErrorText) > 0 then
              begin
                AddToResultEdit(ErrorText);
                FImageIndexMsg :=  img_error;
              end;
          end;
        end;
      finally
        Transaction.Commit;
      end;
    end;
end;

procedure TibSHSQLEditorForm.RunQuery(const AText: string);
var
  vRetrieveStatistics: Boolean;
  vBaseErrorCoord: TBufferCoord;
  vDDLForm: IibSHDDLForm;
  PsewdoSQLText: string;
  I: Integer;
  vIsSetStatistic: Boolean;
  vIndexName: string;
  vPrevStatisticValue: double;
  vFormatSettings: TFormatSettings;
  vDBTransactionParams: string;

  function InputParameters(ADRVQuery: IibSHDRVQuery): Boolean;
  var
    vDRVParams: IibSHDRVParams;
    vInputParameters: IibSHInputParameters;
    vComponentClass: TSHComponentClass;
    vComponent: TSHComponent;
  begin
    Result := False;
    vComponentClass := Designer.GetComponent(IibSHInputParameters);
    if Assigned(vComponentClass) and Supports(ADRVQuery, IibSHDRVParams, vDRVParams) then
    begin
      vComponent := vComponentClass.Create(nil);
      try
        if Supports(vComponent, IibSHInputParameters, vInputParameters) then
        begin
          Result := vInputParameters.InputParameters(vDRVParams);
          vInputParameters := nil;
        end;
      finally
        FreeAndNil(vComponent);
      end;
      vDRVParams := nil;
    end;
  end;
begin
  ClearMessages;
  FSuppressPlan := False;
  DisableAllActions := True;
  try
    FSQLParser.SQLText := AText;
    if FSQLParser.SQLKind = skDDL then
    begin
      if Designer.ShowMsg(SDDLStatementInput) = IDYES then
      begin
        with Component as IibSHDDLInfo do
        begin
          DDL.Text := AText;
        end;
        Designer.ChangeNotification(Component, SCallDDLText, opInsert);
        if Designer.ExistsComponent(Component, SCallDDLText) then
          if Component.GetComponentFormIntf(IibSHDDLForm, vDDLForm) then
            vDDLForm.ShowDDLText;
      end;
    end
    else
    if (FSQLParser.SQLKind in [skSelect,skExecuteBlock]) then
    begin
      if Assigned(Data) then
      begin
        Data.Close;
        Data.ReadOnly := False;
        Data.Dataset.SelectSQL.Text := AText;
        vRetrieveStatistics := Assigned(Statistics) and Assigned(SQLEditor) and SQLEditor.RetrieveStatistics;
        if vRetrieveStatistics then
          Statistics.StartCollection;
        if Data.Open then
        begin
          Designer.ChangeNotification(Component, SCallQueryResults, opInsert);
          if FNeedFecthAll then
          begin
            Application.ProcessMessages;
            Data.FetchAll;
          end;
          if vRetrieveStatistics and (Length(Data.ErrorText) = 0) then
          begin
            Statistics.CalculateStatistics;
            if Supports(Data.Dataset, IibSHDRVExecTimeStatistics) then
              Statistics.DRVTimeStatistics := Data.Dataset as IibSHDRVExecTimeStatistics;
            ShowStatistics;
          end;
          AddToHistory(AText);
        end
        else
        begin
          if Length(Data.ErrorText) > 0 then
          begin
            vBaseErrorCoord := GetErrorCoord(Data.ErrorText);
            if SQLEditor.ExecuteSelected and Editor.SelAvail then
            begin
              vBaseErrorCoord.Char := vBaseErrorCoord.Char + Editor.BlockBegin.Char - 1;
              vBaseErrorCoord.Line := vBaseErrorCoord.Line + Editor.BlockBegin.Line - 1;
            end;
            ErrorCoord := vBaseErrorCoord;
            AddToResultEdit(Data.ErrorText);
            FImageIndexMsg := img_error;
            if DMLHistory.Crash then
              AddToHistory(AText + #13#10#13#10 + Data.ErrorText);
          end
          else
            if DMLHistory.Crash then
              AddToHistory(AText);

        end;
      end;
    end
    else
    begin
      DRVQuery.SQL.Text := AText;
      if not DRVQuery.Transaction.InTransaction then
      begin
        DRVQuery.Transaction.Params.Text := GetTransactionParams(SQLEditor.IsolationLevel, SQLEditor.TransactionParams.Text);
        DRVQuery.Transaction.StartTransaction;
      end;
      Screen.Cursor := crHourGlass;

// Õíÿ
      vIsSetStatistic :=
        (UpperCase(ExtractWord(1, AText, [' ',#13,#9,#10])) = 'SET') and
        (UpperCase(ExtractWord(2, AText, [' ',#13,#9,#10])) = 'STATISTICS');
      if vIsSetStatistic then
      begin
        vIndexName := ExtractWord(4, AText, [' ',#13,#9,#10]);
        vIsSetStatistic := Length(vIndexName) > 0;
      end;
      if vIsSetStatistic then
      begin
        BTCLDatabase.DRVQuery.ExecSQL('SELECT IDX.RDB$STATISTICS AS OLD_STATISTICS FROM RDB$INDICES IDX WHERE IDX.RDB$INDEX_NAME = :INDEX_NAME', [vIndexName], False);
        vPrevStatisticValue := BTCLDatabase.DRVQuery.GetFieldFloatValue(0);
        if BTCLDatabase.DRVQuery.Transaction.InTransaction then
          BTCLDatabase.DRVQuery.Transaction.Commit;
        vDBTransactionParams := BTCLDatabase.DRVQuery.Transaction.Params.Text;
        BTCLDatabase.DRVQuery.Transaction.Params.Text := TRWriteParams;
        BTCLDatabase.DRVQuery.SQL.Text := AText;
        if not BTCLDatabase.DRVQuery.Transaction.InTransaction then
          BTCLDatabase.DRVQuery.Transaction.StartTransaction;
        Screen.Cursor := crHourGlass;
        BTCLDatabase.DRVQuery.Execute;
        if BTCLDatabase.DRVQuery.Transaction.InTransaction then
          BTCLDatabase.DRVQuery.Transaction.Commit;
        BTCLDatabase.DRVQuery.Transaction.Params.Text := vDBTransactionParams;
        if (Length(BTCLDatabase.DRVQuery.ErrorText) = 0) and (not BTCLDatabase.WasLostConnect) then
        begin
          vFormatSettings.DecimalSeparator := Char('.');
          PsewdoSQLText :=
            Format('SELECT %s AS OLD_STATISTICS, IDX.RDB$STATISTICS AS NEW_STATISTICS FROM RDB$INDICES IDX WHERE IDX.RDB$INDEX_NAME = ''%s''',
            [FormatFloat('', vPrevStatisticValue, vFormatSettings), vIndexName]);
          Data.Close;
          Data.ReadOnly := True;
          Data.Dataset.SelectSQL.Text := PsewdoSQLText;
          FSuppressPlan := True;
          if Data.Open then
            Designer.ChangeNotification(Component, SCallQueryResults, opInsert);
          FSuppressPlan := False;
        end;
      end
      else
      begin
        if Assigned(SQLEditor) and SQLEditor.RetrievePlan then
        begin
          try
            if DRVQuery.Prepare then
              AddToResultEdit(DRVQuery.Plan);
          except
            AddToResultEdit(SErrorPlanRetrieving);
          end;
        end
        else
          AddToResultEdit(EmptyStr);
        Application.ProcessMessages;
        try
          if InputParameters(DRVQuery) then
          begin
            vRetrieveStatistics := SQLEditor.RetrieveStatistics;
            if vRetrieveStatistics then
              Statistics.StartCollection;
            Screen.Cursor := crHourGlass;
            DRVQuery.Execute;
            if vRetrieveStatistics and (Length(DRVQuery.ErrorText) = 0) then
            begin
              Statistics.CalculateStatistics;
              if Supports(DRVQuery, IibSHDRVExecTimeStatistics) then
                Statistics.DRVTimeStatistics := DRVQuery as IibSHDRVExecTimeStatistics;
              ShowStatistics;
            end;
          end;
        finally
          Screen.Cursor := crDefault;
        end;
        if Length(DRVQuery.ErrorText) > 0 then
        begin
          vBaseErrorCoord := GetErrorCoord(DRVQuery.ErrorText);
          if SQLEditor.ExecuteSelected and Editor.SelAvail then
          begin
            vBaseErrorCoord.Char := vBaseErrorCoord.Char + Editor.BlockBegin.Char - 1;
            vBaseErrorCoord.Line := vBaseErrorCoord.Line + Editor.BlockBegin.Line - 1;
          end;
          ErrorCoord := vBaseErrorCoord;
          AddToResultEdit(DRVQuery.ErrorText);
          FImageIndexMsg := img_error;
          if DMLHistory.Crash then
            AddToHistory(AText + #13#10#13#10 + DRVQuery.ErrorText );
        end
        else
          AddToHistory(AText);

        if (Length(DRVQuery.ErrorText) = 0) and (not BTCLDatabase.WasLostConnect) then
        begin
          PsewdoSQLText := EmptyStr;
          for I := 0 to Pred(DRVQuery.GetFieldCount) do
            if not DRVQuery.FieldIsBlob(I) then
              PsewdoSQLText := PsewdoSQLText + Format('''%s'' AS "%s", ', [DRVQuery.GetFieldStrValue(I), DRVQuery.FieldName(I)])
            else
              PsewdoSQLText := PsewdoSQLText + Format('''%s'' AS "%s", ', ['[BLOB]', DRVQuery.FieldName(I)]);
          if Length(PsewdoSQLText) > 0 then
          begin
              Delete(PsewdoSQLText, Length(PsewdoSQLText) - 1, 2);
            PsewdoSQLText := Format('SELECT %s FROM RDB$DATABASE', [PsewdoSQLText]);
            Data.Close;
            Data.ReadOnly := True;
            Data.Dataset.SelectSQL.Text := PsewdoSQLText;
            FSuppressPlan := True;
            if Data.Open then
              Designer.ChangeNotification(Component, SCallQueryResults, opInsert);
            FSuppressPlan := False;
          end;
        end;
      end;
      if SQLEditor.AutoCommit and (DRVQuery.GetFieldCount = 0) then
        Commit;
    end;
  finally
    DisableAllActions := False;
    Screen.Cursor := crDefault;
  end;
end;

procedure TibSHSQLEditorForm.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent.IsImplementorOf(FDMLHistory) then FDMLHistory := nil;
    if AComponent = FDMLHistoryComponent then FDMLHistoryComponent := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TibSHSQLEditorForm.AddToResultEdit(AText: string);
begin
  if Assigned(EditorMsg) then
  begin
    FImageIndexMsg := img_success;
    if (Length(AText) > 0) and (Length(EditorMsg.Lines.Text) > 0) then
      Designer.TextToStrings(sLineBreak, EditorMsg.Lines);
    Designer.TextToStrings(AText, EditorMsg.Lines);
    if Length(AText) > 0 then
      EditorMsgVisible;
  end;
end;

{ Actions }

function TibSHSQLEditorForm.SQLEditorLastContextFileName: string;
var
  vDataRootDirectory: ISHDataRootDirectory;
  vDir: string;
begin
  Result := EmptyStr;
  if Supports(BTCLDatabase, ISHDataRootDirectory, vDataRootDirectory) then
  begin
    vDir := vDataRootDirectory.DataRootDirectory;
    if SysUtils.DirectoryExists(vDir) then
    begin
      Result := vDir + SQLEditorLastContextFile;
      vDir := ExtractFilePath(Result);
      if not SysUtils.DirectoryExists(vDir) then
        ForceDirectories(vDir);
    end;
  end;
end;

procedure TibSHSQLEditorForm.pSHSynEdit1ProcessUserCommand(
  Sender: TObject; var Command: TSynEditorCommand; var AChar: Char;
  Data: Pointer);
begin
  if Command = ecpSHUserFirst + 1 then
  begin
    ClearMessages;
    Prepare;
  end;
end;

procedure TibSHSQLEditorForm.pmiHideMessageClick(Sender: TObject);
begin
  EditorMsgVisible(False);
end;

end.
