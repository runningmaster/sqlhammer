unit ibSHTXTLoader;

interface

uses
  SysUtils, Classes, StrUtils, Forms,
  SHDesignIntf, ibSHDesignIntf, ibSHDriverIntf, ibSHTool;

type
  TibSHTXTLoaderState = (lsStartField, lsScanField, lsScanQuoted, lsEndQuoted, lsError);

  TibSHTXTLoader = class(TibBTTool, IibSHTXTLoader, IibSHBranch, IfbSHBranch)
  private
    FDRVTransaction: TComponent;
    FDRVQuery: TComponent;

    FState: TibSHTXTLoaderState;
    FActive: Boolean;
    FFileName: string;
    FInsertSQL: TStrings;
    FErrorText: string;
    FDelimiter: string;
    FTrimValues: Boolean;
    FTrimLengths: Boolean;
    FAbortOnError: Boolean;
    FCommitEachLine: Boolean;
    FColumnCheckOnly: Integer;
    FVerbose: Boolean;
    FOnTextNotify: TSHOnTextNotify;
    FCurLineNumber: Integer;
    FErrorCount: Integer;
    FValues: TStrings;
    FLengths: TStrings;
    FStartTime: TDateTime;

    function GetDRVTransaction: IibSHDRVTransaction;
    function GetDRVQuery: IibSHDRVQuery;
    procedure CreateDRV;
    procedure FreeDRV;

    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetFileName: string;
    procedure SetFileName(Value: string);
    function GetDelimiter: string;
    procedure SetDelimiter(Value: string);
    function GetTrimValues: Boolean;
    procedure SetTrimValues(Value: Boolean);
    function GetTrimLengths: Boolean;
    procedure SetTrimLengths(Value: Boolean);
    function GetAbortOnError: Boolean;
    procedure SetAbortOnError(Value: Boolean);
    function GetCommitEachLine: Boolean;
    procedure SetCommitEachLine(Value: Boolean);
    function GetColumnCheckOnly: Integer;
    procedure SetColumnCheckOnly(Value: Integer);
    function GetVerbose: Boolean;
    procedure SetVerbose(Value: Boolean);
    function GetInsertSQL: TStrings;
    function GetErrorText: string;
    function GetOnTextNotify: TSHOnTextNotify;
    procedure SetOnTextNotify(Value: TSHOnTextNotify);
  protected
    procedure SetOwnerIID(Value: TGUID); override;
    procedure WriteMsg(const S: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetStringCount: Integer;
    function GetCurLineNumber: Integer;
    function Execute: Boolean;
    function InTransaction: Boolean;
    procedure Commit;
    procedure Rollback;

    function Prepare: Boolean;
    function StringToValues(const S: string; AValues: TStrings): Boolean;
    function ValuesToDatabase(AValues: TStrings): Boolean;
    procedure DisplayHeader;
    procedure DisplayFooter;

    property DRVTransaction: IibSHDRVTransaction read GetDRVTransaction;
    property DRVQuery: IibSHDRVQuery read GetDRVQuery;

    property Active: Boolean read GetActive write SetActive;
    property FileName: string read GetFileName write SetFileName;
    property InsertSQL: TStrings read GetInsertSQL;
    property ErrorText: string read GetErrorText;
    property OnTextNotify: TSHOnTextNotify read GetOnTextNotify write SetOnTextNotify;
  published
    property Delimiter: string read GetDelimiter write SetDelimiter;
    property TrimValues: Boolean read GetTrimValues write SetTrimValues;
    property TrimLengths: Boolean read GetTrimLengths write SetTrimLengths;
    property AbortOnError: Boolean read GetAbortOnError write SetAbortOnError;
    property CommitEachLine: Boolean read GetCommitEachLine write SetCommitEachLine;
    property ColumnCheckOnly: Integer read GetColumnCheckOnly write SetColumnCheckOnly;
    property Verbose: Boolean read GetVerbose write SetVerbose;
  end;

  TibSHTXTLoaderFactory = class(TibBTToolFactory)
  end;


procedure Register;

implementation

uses
  ibSHConsts,
  ibSHTXTLoaderActions,
  ibSHTXTLoaderEditors;

procedure Register;
begin
  SHRegisterImage(GUIDToString(IibSHTXTLoader), 'TXTLoader.bmp');

  SHRegisterImage(TibSHTXTLoaderPaletteAction.ClassName,          'TXTLoader.bmp');
  SHRegisterImage(TibSHTXTLoaderFormAction.ClassName,             'Form_DDLText.bmp');
  SHRegisterImage(TibSHTXTLoaderToolbarAction_Run.ClassName,      'Button_Run.bmp');
  SHRegisterImage(TibSHTXTLoaderToolbarAction_Commit.ClassName,   'Button_TrCommit.bmp');
  SHRegisterImage(TibSHTXTLoaderToolbarAction_Rollback.ClassName, 'Button_TrRollback.bmp');
  SHRegisterImage(TibSHTXTLoaderToolbarAction_Pause.ClassName,    'Button_Stop.bmp');
  SHRegisterImage(TibSHTXTLoaderToolbarAction_Open.ClassName,     'Button_Open.bmp');

  SHRegisterImage(SCallDMLStatement, 'Form_DDLText.bmp');

  SHRegisterComponents([
    TibSHTXTLoader,
    TibSHTXTLoaderFactory]);

  SHRegisterActions([
    // Palette
    TibSHTXTLoaderPaletteAction,
    // Forms
    TibSHTXTLoaderFormAction,
    // Toolbar
    TibSHTXTLoaderToolbarAction_Run,
    TibSHTXTLoaderToolbarAction_Pause,
    TibSHTXTLoaderToolbarAction_Commit,
    TibSHTXTLoaderToolbarAction_Rollback,
    TibSHTXTLoaderToolbarAction_Open]);

  SHRegisterPropertyEditor(IibSHTXTLoader, 'Delimiter', TibSHTXTLoaderDelimiterPropEditor);
end;

{ TibSHTXTLoader }

constructor TibSHTXTLoader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInsertSQL := TStringList.Create;
  FDelimiter := Delimiters[0];
  FTrimValues := True;
  FTrimLengths := True;
  FAbortOnError := True;

  FValues := TStringList.Create;
  FLengths := TStringList.Create;
  FStartTime := 0;
end;

destructor TibSHTXTLoader.Destroy;
begin
  FInsertSQL.Free;
  FValues.Free;
  FLengths.Free;
  FreeDRV;
  inherited Destroy;
end;

function TibSHTXTLoader.GetDRVTransaction: IibSHDRVTransaction;
begin
  Supports(FDRVTransaction, IibSHDRVTransaction, Result);
end;

function TibSHTXTLoader.GetDRVQuery: IibSHDRVQuery;
begin
  Supports(FDRVQuery, IibSHDRVQuery, Result);
end;

procedure TibSHTXTLoader.CreateDRV;
var
  vComponentClass: TSHComponentClass;
begin
  //
  // Получение реализации DRVTransaction
  //
  vComponentClass := Designer.GetComponent(BTCLDatabase.BTCLServer.DRVNormalize(IibSHDRVTransaction));
  if Assigned(vComponentClass) then FDRVTransaction := vComponentClass.Create(Self);
  Assert(DRVTransaction <> nil, 'DRVTransaction = nil');
  //
  // Получение реализации DRVQuery
  //
  vComponentClass := Designer.GetComponent(BTCLDatabase.BTCLServer.DRVNormalize(IibSHDRVQuery));
  if Assigned(vComponentClass) then FDRVQuery := vComponentClass.Create(Self);
  Assert(DRVQuery <> nil, 'DRVQuery = nil');
  //
  // Установка свойств DRVTransaction и DRVQuery
  //
  DRVTransaction.Params.Text := TRWriteParams;
  DRVTransaction.Database := BTCLDatabase.DRVQuery.Database;
  DRVQuery.Transaction := DRVTransaction;
  DRVQuery.Database := BTCLDatabase.DRVQuery.Database;
end;

procedure TibSHTXTLoader.FreeDRV;
begin
  FreeAndNil(FDRVTransaction);
  FreeAndNil(FDRVQuery);
end;

function TibSHTXTLoader.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure TibSHTXTLoader.SetActive(Value: Boolean);
begin
  if FActive and not Value then
    FErrorText := Format('Process stopped by user at %s', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', Now)]);
  FActive := Value;
end;

function TibSHTXTLoader.GetFileName: string;
begin
  Result := FFileName;
end;

procedure TibSHTXTLoader.SetFileName(Value: string);
begin
  FFileName := Value;
end;

function TibSHTXTLoader.GetDelimiter: string;
begin
  Result := FDelimiter;
end;

procedure TibSHTXTLoader.SetDelimiter(Value: string);
begin
  FDelimiter := Value;
end;

function TibSHTXTLoader.GetTrimValues: Boolean;
begin
  Result := FTrimValues;
end;

procedure TibSHTXTLoader.SetTrimValues(Value: Boolean);
begin
  FTrimValues := Value;
end;

function TibSHTXTLoader.GetTrimLengths: Boolean;
begin
  Result := FTrimLengths;
end;

procedure TibSHTXTLoader.SetTrimLengths(Value: Boolean);
begin
  FTrimLengths := Value;
end;

function TibSHTXTLoader.GetAbortOnError: Boolean;
begin
  Result := FAbortOnError;
end;

procedure TibSHTXTLoader.SetAbortOnError(Value: Boolean);
begin
  FAbortOnError := Value;
end;

function TibSHTXTLoader.GetCommitEachLine: Boolean;
begin
  Result := FCommitEachLine;
end;

procedure TibSHTXTLoader.SetCommitEachLine(Value: Boolean);
begin
  FCommitEachLine := Value;
  Designer.UpdateActions;
end;

function TibSHTXTLoader.GetColumnCheckOnly: Integer;
begin
  Result := FColumnCheckOnly;
end;

procedure TibSHTXTLoader.SetColumnCheckOnly(Value: Integer);
begin
  FColumnCheckOnly := Value;
end;

function TibSHTXTLoader.GetVerbose: Boolean;
begin
  Result := FVerbose;
end;

procedure TibSHTXTLoader.SetVerbose(Value: Boolean);
begin
  FVerbose := Value;
end;

function TibSHTXTLoader.GetInsertSQL: TStrings;
begin
  Result := FInsertSQL;
end;

function TibSHTXTLoader.GetErrorText: string;
begin
  Result := FErrorText;
end;

function TibSHTXTLoader.GetOnTextNotify: TSHOnTextNotify;
begin
  Result := FOnTextNotify;
end;

procedure TibSHTXTLoader.SetOnTextNotify(Value: TSHOnTextNotify);
begin
  FOnTextNotify := Value;
end;

procedure TibSHTXTLoader.SetOwnerIID(Value: TGUID);
begin
  inherited SetOwnerIID(Value);
  CreateDRV;
end;

procedure TibSHTXTLoader.WriteMsg(const S: string);
begin
  if Assigned(FOnTextNotify) then FOnTextNotify(Self, S);
end;

function TibSHTXTLoader.GetStringCount: Integer;
var
  Source: TextFile;
  S: string;
begin
  Result := 0;

  if Length(FileName) = 0 then
  begin
    FErrorText := Format('%s', ['File name in not defined']);
    Exit;
  end;

  AssignFile(Source, FileName);
  Reset(Source);

  try
    while not Eof(Source) do
    begin
      Readln(Source, S);
      Result := Result + 1;
    end;
  finally
    CloseFile(Source);
  end;
end;

function TibSHTXTLoader.GetCurLineNumber: Integer;
begin
  Result := FCurLineNumber;
end;

function TibSHTXTLoader.Execute: Boolean;
var
  Source: TextFile;
  S: string;
begin
  Result := False;
  DisplayHeader;
  FErrorText := EmptyStr;

  if Length(FileName) = 0 then
  begin
    FErrorText := Format('%s', ['File name in not defined']);
    Exit;
  end;

  if Length(FInsertSQL.Text) = 0 then
  begin
    FErrorText := Format('%s', ['DML statement for inserting in not defined']);
    Exit;
  end;

  Active := True;
  Designer.UpdateActions;
  AssignFile(Source, FileName);
  Reset(Source);

  try
    FCurLineNumber := 0;
    FErrorCount := 0;
    if Prepare then
    begin
      while not Eof(Source) and Active do
      begin
        FErrorText := EmptyStr;
        Readln(Source, S);
        FCurLineNumber := FCurLineNumber + 1;

        Result := StringToValues(S, FValues);
        if Result and (ColumnCheckOnly = 0) then Result := ValuesToDatabase(FValues);
        if not Result and AbortOnError then Break;

        if Verbose then WriteMsg(S);
        Application.ProcessMessages;
      end;
    end;
  finally
    CloseFile(Source);
    DisplayFooter;
    Active := False;
  end;
end;

function TibSHTXTLoader.InTransaction: Boolean;
begin
  Result := Assigned(DRVTransaction) and DRVTransaction.InTransaction;
end;

procedure TibSHTXTLoader.Commit;
begin
  if InTransaction then
  begin
    if DRVTransaction.Commit then
      WriteMsg(Format('%s', ['Transaction committed']))
    else
      WriteMsg(Format('Error: %s', [DRVTransaction.ErrorText]))
  end;
end;

procedure TibSHTXTLoader.Rollback;
begin
  if InTransaction then
  begin
    if DRVTransaction.Rollback then
      WriteMsg(Format('%s', ['Transaction rolled back']))
    else
      WriteMsg(Format('Error: %s', [DRVTransaction.ErrorText]))
  end;
end;

function TibSHTXTLoader.Prepare: Boolean;
var
  I: Integer;
  DRVParams: IibSHDRVParams;
begin
  FLengths.Clear;
  DRVTransaction.StartTransaction;
  DRVQuery.SQL.Text := '';
  DRVQuery.SQL.Text := InsertSQL.Text;

  Supports(DRVQuery, IibSHDRVParams, DRVParams);
  Result := Assigned(DRVParams) and DRVQuery.Prepare;
  if Result then
  begin
    for I := 0 to Pred(DRVParams.ParamCount) do
      FLengths.Add(IntToStr(DRVParams.GetParamSize(I)));
  end else
  begin
    FErrorCount := FErrorCount + 1;
    FErrorText := DRVQuery.ErrorText;
    WriteMsg(FErrorText);
    Application.ProcessMessages;
    DRVTransaction.Commit;
  end;
end;

function TibSHTXTLoader.StringToValues(const S: string; AValues: TStrings): Boolean;
var
  I: Integer;
  CurChar, Delim: Char;
  CurField: string;
begin
  AValues.Clear;
  FState := lsStartField;
  CurField := EmptyStr;

  Delim := Delimiter[1];
  if AnsiSameText(Delimiter, Delimiters[0]) then Delim := ',' else
  if AnsiSameText(Delimiter, Delimiters[1]) then Delim := ';' else
  if AnsiSameText(Delimiter, Delimiters[2]) or AnsiSameText(Delimiter, #9) then Delim := Char(9) else
  if AnsiSameText(Delimiter, Delimiters[3]) or AnsiSameText(Delimiter, #32) then Delim := Char(32);


  for I := 1 to Length(S) do
  begin
    CurChar := S[I];
    case FState of
      lsStartField:
      begin
        if (CurChar = '"') then
          FState := lsScanQuoted
        else
        if CurChar = Delim then
          AValues.Add(EmptyStr)
        else
        begin
          CurField := CurChar;
          FState := lsScanField;
        end;
      end;

      lsScanField:
      begin
        if CurChar = Delim then
        begin
          AValues.Add(CurField);
          CurField := EmptyStr;
          FState := lsStartField;
        end else
          CurField := CurField + CurChar;
      end;

      lsScanQuoted:
      begin
        if (CurChar = '"') and ((S[I + 1] = #13) or (S[I + 1] = #10) or (S[I + 1] = Delim) or (I = Length(S))) then
          FState := lsEndQuoted
        else
          CurField := CurField + CurChar;
      end;

      lsEndQuoted:
      begin
        if CurChar = Delim then
        begin
          AValues.Add(CurField);
          CurField := EmptyStr;
          FState := lsStartField;
        end else
          FState := lsError;
      end;

      lsError:
      begin
        Break;
      end;
    end;
  end;

  Result := (FState <> lsScanQuoted) or (FState <> lsError);
  if Result then
  begin
    if Length(CurField) > 0 then AValues.Add(CurField);
  end else
  begin
    FErrorCount := FErrorCount + 1;
    FErrorText := Format('Parsing error: %s', [S]);
    WriteMsg(FErrorText);
    Application.ProcessMessages;
  end;

  if Result and (ColumnCheckOnly > 0) then
  begin
    if AValues.Count <> ColumnCheckOnly then
    begin
      FErrorCount := FErrorCount + 1;
      FErrorText := Format('Parsing error: %s', [S]);
      WriteMsg(FErrorText);
      Application.ProcessMessages;
    end;
  end;
end;

function TibSHTXTLoader.ValuesToDatabase(AValues: TStrings): Boolean;
var
  I, L: Integer;
  S: string;
  pArray: array of Variant;
begin
  SetLength(pArray, AValues.Count);

  for I := 0 to Pred(AValues.Count) do
  begin
    S := AValues[I];
    if TrimLengths and (I < FLengths.Count) then
    begin
      L := StrToInt(FLengths[I]);
      if Length(S) > L then S := Copy(S, 1, L);
    end;
    if TrimValues then S := Trim(S);
    pArray[I] := S;
  end;

  Result := DRVQuery.ExecSQL(InsertSQL.Text, pArray, CommitEachLine);

  if not Result then
  begin
    FErrorCount := FErrorCount + 1;
    FErrorText := DRVQuery.ErrorText;
    WriteMsg(FErrorText);
    WriteMsg(Format('Values: %s', [AValues.CommaText]));
    Application.ProcessMessages;
  end;
end;

procedure TibSHTXTLoader.DisplayHeader;
begin
  FStartTime := Now;
  WriteMsg(EmptyStr);
  WriteMsg(Format('Process started at %s', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', FStartTime)]));
  WriteMsg(Format('FileName: %s', [FileName]));
  WriteMsg(EmptyStr);  
end;

procedure TibSHTXTLoader.DisplayFooter;
begin
  WriteMsg(EmptyStr);
  WriteMsg(Format('Process ended at %s', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', Now)]));
  WriteMsg(Format('Elapsed time %s', [FormatDateTime('hh:nn:ss.zzz', Now - FStartTime)]));
  WriteMsg(Format('Record count: %s', [FormatFloat('###,###,###,###', FCurLineNumber)]));
  WriteMsg(Format('Error count: %s', [FormatFloat('###,###,###,##0', FErrorCount)]));
end;

initialization

  Register;

end.





