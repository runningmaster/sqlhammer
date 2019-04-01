unit ibSHObjectNamesManager;

interface

uses Classes, SysUtils, Forms, Graphics,
     SynCompletionProposal, Menus, Controls,
     SHDesignIntf, SHOptionsIntf, ibSHDesignIntf, ibSHConsts, ibSHMessages,
     SynEdit,
     pSHIntf, pSHCompletionProposal, pSHHighlighter, pSHSynEdit,
     pSHParametersHint, pSHCommon, pSHStrUtil, pSHSqlTxtRtns,
     ibSHRegExpesions;

type

  TibBTObjectNamesManager = class(TBTComponent, IpSHObjectNamesManager,
    IpSHCompletionProposalOptions, IpSHUserInputHistory)
  private
    FCodeNormalizer: IibSHCodeNormalizer;
    FEditorCodeInsightOptions: ISHEditorCodeInsightOptions;
    FEditorGeneralOptions: ISHEditorGeneralOptions;

    FHighlighter: TpSHHighlighter;
    FObjectNames: TStringList;
    FCompletionProposal: TpSHCompletionProposal;
    FDatabase: ISHRegistration;
    FCaseCode: TpSHCaseCode;
    FCaseSQLCode: TpSHCaseCode;
    FCompletionEnabled: Boolean;
    FCompletionExtended: Boolean;
    FParametersHint: TpSHParametersHint;
    FNativProposalFormKeyPress: TKeyPressEvent;

    procedure CatchCodeNormilizer;
    procedure CatchCodeInsightOptions;
    procedure CatchEditorGeneralOptions;
  protected
    function IsObjectName(const MayBe: string): Boolean;
    function IsCustomString(const MayBe: string): Boolean;
    function InternalDoCaseCode(const Value: string): string;
    procedure FormatCodeCompletion(Sender: TObject; var Value: string;
      Shift: TShiftState; Index: Integer; EndToken: Char);
    procedure ProposalFormKeyPress(Sender: TObject; var Key: Char);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    class function GetClassIIDClassFnc: TGUID; override;
    {IpSHUserInputHistory}
    function GetFindHistory: TStrings;
    function GetReplaceHistory: TStrings;
    function GetGotoLineNumberHistory: TStrings;
    function GetPromtOnReplace: Boolean;
    procedure SetPromtOnReplace(const Value: Boolean);

    procedure AddToFindHistory(const AString: string);
    procedure AddToReplaceHistory(const AString: string);
    procedure AddToGotoLineNumberHistory(const AString: string);
    {IpSHCompletionProposalOptions}
    function IpSHCompletionProposalOptions.GetEnabled = GetCompletionEnabled;
    procedure IpSHCompletionProposalOptions.SetEnabled = SetCompletionEnabled;
    function IpSHCompletionProposalOptions.GetExtended = GetCompletionExtended;
    procedure IpSHCompletionProposalOptions.SetExtended = SetCompletionExtended;
    function IpSHCompletionProposalOptions.GetLinesCount = GetCompletionLinesCount;
    procedure IpSHCompletionProposalOptions.SetLinesCount = SetCompletionLinesCount;
    function IpSHCompletionProposalOptions.GetWidth = GetCompletionWidth;
    procedure IpSHCompletionProposalOptions.SetWidth = SetCompletionWidth;

    function GetCompletionEnabled: Boolean;
    procedure SetCompletionEnabled(const Value: Boolean);
    function GetCompletionExtended: Boolean;
    procedure SetCompletionExtended(const Value: Boolean);
    function GetCompletionLinesCount: Integer;
    procedure SetCompletionLinesCount(const Value: Integer);
    function GetCompletionWidth: Integer;
    procedure SetCompletionWidth(const Value: Integer);

    {IpSHObjectNamesManager}
    function GetObjectNamesRetriever: IInterface;
    procedure SetObjectNamesRetriever(const Value: IInterface);
    function GetHighlighter: TComponent;
    function GetCompletionProposal: TComponent;
    function GetParametersHint: TComponent;
    function GetCaseCode: TpSHCaseCode;
    procedure SetCaseCode(const Value: TpSHCaseCode);
    function GetCaseSQLCode: TpSHCaseCode;
    procedure SetCaseSQLCode(const Value: TpSHCaseCode);
    //необходимость этого обработчика вызвана неэффективностью
    //предложенного в нативном компоненте метода определени€
    //принадлежности идентификатора к пространству имен объектов, котора€
    //выражаетс€ в крайне медленной работе со свойством TableNames,
    //особенно при наличии нескольких экземпл€ров Highlighter'а, а
    //также неудобством работы с этим свойством в услови€х сильной
    //динамичности списка объектов
    procedure LinkSearchNotify(Sender: TObject; MayBe: PChar;
      Position, Len: Integer; var TokenKind: TtkTokenKind);
    //в данном методе должно происходить наполнение списков
    //InsertList и ItemList
    //ранее и в стандартной поставке код размещалс€ в событии
    //OnExecute
    procedure ExecuteNotify(Kind: Integer; Sender: TObject;
      var CurrentInput: string; var x, y: Integer; var CanExecute: Boolean);
    procedure FindDeclaration(const AObjectName: string);
    //ƒл€ обслуживани€ ситуаций с квотированием и регистрозависимостью
    function IsIdentifiresEqual(Sender: TObject;
      AIdentifire1, AIdentifire2: string): Boolean;
      
    property ObjectNames: TStringList read FObjectNames write FObjectNames;
    {End of IpSHObjectNamesManager}
    
    property Highlighter: TpSHHighlighter read FHighlighter
      write FHighlighter;
    property CompletionProposal: TpSHCompletionProposal
      read FCompletionProposal write FCompletionProposal;
    property ParametersHint: TpSHParametersHint read FParametersHint
      write FParametersHint;

  end;

implementation

procedure Register;
begin
  BTRegisterComponents([TibBTObjectNamesManager]);
end;

{ TibBTObjectNamesManager }

constructor TibBTObjectNamesManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Highlighter := TpSHHighlighter.Create(Self);
  Highlighter.SQLDialect := sqlInterbase;
  Highlighter.TableNameAttri.Foreground := clGreen;
  Highlighter.TableNameAttri.Style := [fsUnderline];
  Highlighter.ObjectNamesManager := Self as IpSHObjectNamesManager;

  CompletionProposal := TpSHCompletionProposal.Create(Application.MainForm); // Owner должен быть именно Application.MainForm!
  CompletionProposal.FreeNotification(Self);
  CompletionProposal.Options := CompletionProposal.Options + [scoUseInsertList, scoUsePrettyText];
  CompletionProposal.TriggerChars := '.';
  CompletionProposal.Columns.Add.BiggestWord := ' ' + SClassHintSystemTable;
  CompletionProposal.CompletionProposalOptions := Self;
  CompletionProposal.OnCodeCompletion := FormatCodeCompletion;
  FNativProposalFormKeyPress := CompletionProposal.OnKeyPress;
  CompletionProposal.OnKeyPress := ProposalFormKeyPress;

  FParametersHint := TpSHParametersHint.Create(Application.MainForm);
  FParametersHint.FreeNotification(Self);
  FParametersHint.ShortCut := ShortCut(Ord(' '), [ssShift, ssCtrl]);
  FParametersHint.Form.ClBackground := clInfoBk;
  FParametersHint.ProposalHintRetriever :=
    Designer.GetDemon(IpSHProposalHintRetriever) as IpSHProposalHintRetriever;
end;

destructor TibBTObjectNamesManager.Destroy;
begin
  Highlighter.Free;
  if Assigned(FCompletionProposal) then
    FCompletionProposal.Free;
  if Assigned(FParametersHint) then
    FParametersHint.Free;
// FParametersHint, FCompletionProposal может быть разрушеен (при выходе из программы) формой, на колторую положен, а именно Application.MainForm
  inherited;
end;

procedure TibBTObjectNamesManager.CatchCodeNormilizer;
var
  vDatabase: IibSHDatabase;
begin
  if not Assigned(FCodeNormalizer) then
    if Supports(FDatabase, IibSHDatabase, vDatabase) then
      if Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, FCodeNormalizer) then
        ReferenceInterface(FCodeNormalizer, opInsert);
end;

procedure TibBTObjectNamesManager.CatchCodeInsightOptions;
begin
  if not Assigned(FEditorCodeInsightOptions) then
    if Supports(Designer.GetDemon(ISHEditorCodeInsightOptions), ISHEditorCodeInsightOptions, FEditorCodeInsightOptions) then
      ReferenceInterface(FEditorCodeInsightOptions, opInsert);
end;

procedure TibBTObjectNamesManager.CatchEditorGeneralOptions;
begin
  if not Assigned(FEditorGeneralOptions) then
    if Supports(Designer.GetDemon(ISHEditorGeneralOptions), ISHEditorGeneralOptions, FEditorGeneralOptions) then
      ReferenceInterface(FEditorGeneralOptions, opInsert);
end;

function TibBTObjectNamesManager.IsObjectName(
  const MayBe: string): Boolean;
var
  vMayBe: string;
begin
  Result := False;
  if not Assigned(FDatabase) then Exit;
  vMayBe := MayBe;
  CatchCodeNormilizer;
  if Assigned(FCodeNormalizer) then
    vMayBe := FCodeNormalizer.SourceDDLToMetadataName(MayBe)
  else
    vMayBe := MayBe;
  Result := FDatabase.GetObjectNameList.IndexOf(vMayBe) <> -1;;
end;

function TibBTObjectNamesManager.IsCustomString(
  const MayBe: string): Boolean;
var
  vMayBe: string;
begin
  Result := False;
  if not Assigned(FDatabase) then Exit;
  vMayBe := MayBe;
  CatchCodeNormilizer;
  if Assigned(FCodeNormalizer) then
    vMayBe := FCodeNormalizer.SourceDDLToMetadataName(MayBe)
  else
    vMayBe := MayBe;
  CatchCodeInsightOptions;
  if Assigned(FEditorCodeInsightOptions) then
    Result := FEditorCodeInsightOptions.CustomStrings.IndexOf(vMayBe) <> -1
  else
    Result := False;
end;

function TibBTObjectNamesManager.InternalDoCaseCode(const Value: string): string;
var
  vDatabase: IibSHDatabase;
begin
  CatchCodeNormilizer;
  if Assigned(FCodeNormalizer) and Supports(FDatabase, IibSHDatabase, vDatabase) then
    Result := FCodeNormalizer.MetadataNameToSourceDDLCase(vDatabase, Value)
  else
    Result := Value;
end;

procedure TibBTObjectNamesManager.FormatCodeCompletion(Sender: TObject;
  var Value: string; Shift: TShiftState; Index: Integer; EndToken: Char);
var
  vDatabase: IibSHDatabase;
  function IsKeyword(const MayBe: string): Boolean;
  var
    vKeywordsList: IibSHKeywordsList;
  begin
    with TpSHCompletionProposal(Sender) do
      if Assigned(TpSHSynEdit(Form.CurrentEditor).KeywordsManager) and
        Supports(TpSHSynEdit(Form.CurrentEditor).KeywordsManager, IibSHKeywordsList, vKeywordsList) then
        Result := (vKeywordsList.AllKeywordList.IndexOf(MayBe) <> -1)
      else
        Result := False;
  end;
begin
  if (Sender is TpSHCompletionProposal) and
     (TpSHCompletionProposal(Sender).Form.AssignedList.Count = 0) then
    Exit
  else
  begin
    if IsKeyword(Value) then
      Value := DoCaseCode(Value, FCaseSQLCode)
    else
    begin
      CatchCodeNormilizer;
      if Assigned(FCodeNormalizer) and Supports(FDatabase, IibSHDatabase, vDatabase) then
        Value := FCodeNormalizer.MetadataNameToSourceDDLCase(vDatabase, Value);
    end;
  end;
end;

procedure TibBTObjectNamesManager.ProposalFormKeyPress(Sender: TObject;
  var Key: Char);
var
  vKey: Char;
begin
  vKey := Key;
  if Assigned(FNativProposalFormKeyPress) then
    FNativProposalFormKeyPress(Sender, Key);
  if vKey = '.' then
  begin
    //ƒл€ того, что переформировалс€ список комплишена
    TpSHCompletionProposal(TComponent(Sender).Owner).ActivateCompletion(
      TSynEdit(TpSHCompletionProposal(TComponent(Sender).Owner).Form.CurrentEditor));
  end;
end;

class function TibBTObjectNamesManager.GetClassIIDClassFnc: TGUID;
begin
  Result := IpSHObjectNamesManager;
end;

function TibBTObjectNamesManager.GetFindHistory: TStrings;
begin
  CatchEditorGeneralOptions;
  if Assigned(FEditorGeneralOptions) then
    Result := FEditorGeneralOptions.FindTextHistory
  else
    Result := nil;
end;

function TibBTObjectNamesManager.GetReplaceHistory: TStrings;
begin
  CatchEditorGeneralOptions;
  if Assigned(FEditorGeneralOptions) then
    Result := FEditorGeneralOptions.ReplaceTextHistory
  else
    Result := nil;
end;

function TibBTObjectNamesManager.GetGotoLineNumberHistory: TStrings;
begin
  CatchEditorGeneralOptions;
  if Assigned(FEditorGeneralOptions) then
    Result := FEditorGeneralOptions.LineNumberHistory
  else
    Result := nil;
end;

function TibBTObjectNamesManager.GetPromtOnReplace: Boolean;
begin
  CatchEditorGeneralOptions;
  if Assigned(FEditorGeneralOptions) then
    Result := FEditorGeneralOptions.PromtOnReplace
  else
    Result := True;
end;

procedure TibBTObjectNamesManager.SetPromtOnReplace(const Value: Boolean);
begin
  CatchEditorGeneralOptions;
  if Assigned(FEditorGeneralOptions) then
    FEditorGeneralOptions.PromtOnReplace := Value; 
end;

procedure TibBTObjectNamesManager.AddToFindHistory(const AString: string);
begin
  CatchEditorGeneralOptions;
  if Assigned(FEditorGeneralOptions) then
    if FEditorGeneralOptions.FindTextHistory.IndexOf(AString) = -1 then
      FEditorGeneralOptions.FindTextHistory.Insert(0, AString);
end;

procedure TibBTObjectNamesManager.AddToReplaceHistory(
  const AString: string);
begin
  CatchEditorGeneralOptions;
  if Assigned(FEditorGeneralOptions) then
    if FEditorGeneralOptions.ReplaceTextHistory.IndexOf(AString) = -1 then
      FEditorGeneralOptions.ReplaceTextHistory.Insert(0, AString);
end;

procedure TibBTObjectNamesManager.AddToGotoLineNumberHistory(
  const AString: string);
begin
  CatchEditorGeneralOptions;
  if Assigned(FEditorGeneralOptions) then
    if FEditorGeneralOptions.LineNumberHistory.IndexOf(AString) = -1 then
      FEditorGeneralOptions.LineNumberHistory.Insert(0, AString);
end;

function TibBTObjectNamesManager.GetObjectNamesRetriever: IInterface;
begin
  Result := FDatabase;
end;

procedure TibBTObjectNamesManager.SetObjectNamesRetriever(
  const Value: IInterface);
begin
  ReferenceInterface(FDatabase, opRemove);
  if Supports(Value, ISHRegistration, FDatabase) then
    ReferenceInterface(FDatabase, opInsert);
end;

function TibBTObjectNamesManager.GetHighlighter: TComponent;
begin
  Result := FHighlighter;
end;

function TibBTObjectNamesManager.GetCompletionProposal: TComponent;
begin
  Result := FCompletionProposal;
end;

function TibBTObjectNamesManager.GetParametersHint: TComponent;
begin
  Result := FParametersHint;
end;

function TibBTObjectNamesManager.GetCaseCode: TpSHCaseCode;
begin
  Result := FCaseCode;
end;

procedure TibBTObjectNamesManager.SetCaseCode(const Value: TpSHCaseCode);
begin
  FCaseCode := Value;
end;

function TibBTObjectNamesManager.GetCaseSQLCode: TpSHCaseCode;
begin
  Result := FCaseSQLCode;
end;

procedure TibBTObjectNamesManager.SetCaseSQLCode(const Value: TpSHCaseCode);
begin
  FCaseSQLCode := Value;
end;

function TibBTObjectNamesManager.GetCompletionEnabled: Boolean;
begin
  Result := FCompletionEnabled;
end;

procedure TibBTObjectNamesManager.SetCompletionEnabled(
  const Value: Boolean);
begin
  FCompletionEnabled := Value;
end;

function TibBTObjectNamesManager.GetCompletionExtended: Boolean;
begin
  Result := FCompletionExtended;
end;

procedure TibBTObjectNamesManager.SetCompletionExtended(
  const Value: Boolean);
begin
  FCompletionExtended := Value;
end;

function TibBTObjectNamesManager.GetCompletionLinesCount: Integer;
begin
  CatchCodeInsightOptions;
  if Assigned(FEditorCodeInsightOptions) then
    Result := FEditorCodeInsightOptions.WindowLineCount
  else
    Result := 8;
end;

procedure TibBTObjectNamesManager.SetCompletionLinesCount(
  const Value: Integer);
begin
  CatchCodeInsightOptions;
  if Assigned(FEditorCodeInsightOptions) then
    FEditorCodeInsightOptions.WindowLineCount := Value;
end;

function TibBTObjectNamesManager.GetCompletionWidth: Integer;
begin
  CatchCodeInsightOptions;
  if Assigned(FEditorCodeInsightOptions) then
    Result := FEditorCodeInsightOptions.WindowWidth
  else
    Result := 200;
end;

procedure TibBTObjectNamesManager.SetCompletionWidth(const Value: Integer);
begin
  CatchCodeInsightOptions;
  if Assigned(FEditorCodeInsightOptions) then
    FEditorCodeInsightOptions.WindowWidth := Value;
end;

procedure TibBTObjectNamesManager.LinkSearchNotify(Sender: TObject;
  MayBe: PChar; Position, Len: Integer; var TokenKind: TtkTokenKind);
var
  s: string;
begin
  case TokenKind of
    tkIdentifier:
      begin
        SetString(s, MayBe, Len);
        if IsObjectName(s) then
          TokenKind := tkTableName
        else
          if IsCustomString(s) then
            TokenKind := tkCustomStrings;
      end;
    tkString:     //Interbase only
      begin
        //начало серверо зависимого кода обработки имени объекта до его проверки
        //дл€ третьего диалекта IB - названи€ объектов могут быть в кавычках
        SetString(s, MayBe, Len);
        if (s[1] = '"') and (s[Len] = '"') then
          if IsObjectName(s) then
            TokenKind := tkTableName;
      end;
  end;
end;

procedure TibBTObjectNamesManager.ExecuteNotify(Kind: Integer;
  Sender: TObject; var CurrentInput: string; var x, y: Integer;
  var CanExecute: Boolean);
var
  vObjectName: string;
  vTrigger: IibSHTrigger;
  vFieldListRetriever: IpSHFieldListRetriever;
  FieldList: TStringList;
  I: Integer;
  vColor: string;
  vType: string;
  vDatabase: IibSHDatabase;
  function GetColorStringFor(ForObjectType: TGUID): string;
  begin
    if IsEqualGUID(ForObjectType, IibSHField) then Result := ColorToString(clBlue) else
    if IsEqualGUID(ForObjectType, IibSHProcParam) then Result := ColorToString(clBlue) else

    if IsEqualGUID(ForObjectType, IibSHDomain)      then Result := ColorToString(clOlive) else
    if IsEqualGUID(ForObjectType, IibSHTable)       then Result := ColorToString(clBlue) else
    if IsEqualGUID(ForObjectType, IibSHView)        then Result := ColorToString(clNavy) else
    if IsEqualGUID(ForObjectType, IibSHProcedure)   then Result := ColorToString(clTeal) else
    if IsEqualGUID(ForObjectType, IibSHProcParam)   then Result := ColorToString(clTeal) else
    if IsEqualGUID(ForObjectType, IibSHTrigger)     then Result := ColorToString(clPurple) else
    if IsEqualGUID(ForObjectType, IibSHGenerator)   then Result := ColorToString(clGreen) else
    if IsEqualGUID(ForObjectType, IibSHException)   then Result := ColorToString(clRed) else
    if IsEqualGUID(ForObjectType, IibSHFunction)    then Result := ColorToString(clMaroon) else
    if IsEqualGUID(ForObjectType, IibSHFilter)      then Result := ColorToString(clMaroon) else
    if IsEqualGUID(ForObjectType, IibSHRole)        then Result := ColorToString(clBlack) else
    if IsEqualGUID(ForObjectType, IibCustomStrings) then Result := ColorToString(clGray) else
      Result := ColorToString(clBlack);
  end;
  function IsPublishedObjectType(AObjectGUID: TGUID): Boolean;
  begin
    Result := not IsEqualGUID(AObjectGUID, IibSHTrigger);
  end;
  function GetObjectTypeDescription(AObjectGUID: TGUID): string;
  var
    vComponentClass: TBTComponentClass;
  begin
    vComponentClass := Designer.GetComponent(AObjectGUID);
    if Assigned(vComponentClass) then
      Result := {AnsiLowerCase(}vComponentClass.GetAssociationClassFnc{)}
    else
      Result := SObjectName;
  end;
  procedure AddObjectNames(AObjectGUID: TGUID);
  var
    CurrentList: TStrings;
    I: Integer;
    vType: string;
    vColor: string;
    S: string;
  begin
    if Assigned(FDatabase) and IsPublishedObjectType(AObjectGUID) then
    begin
      vType := GetObjectTypeDescription(AObjectGUID);
      vColor :=  GetColorStringFor(AObjectGUID);
      CurrentList := FDatabase.GetObjectNameList(AObjectGUID);
      for I := 0 to CurrentList.Count - 1 do
      with TpSHCompletionProposal(Sender) do
      begin
        S := InternalDoCaseCode(CurrentList[I]);
        ItemList.Add(Format(sProposalTemplate, [vColor, vType, S, '']));
        InsertList.Add(CurrentList[I]);
      end;
    end;
  end;
  procedure AddCustomStrings;
  var
    CurrentList: TStrings;
    I: Integer;
    vType: string;
    vColor: string;
    S: string;
  begin
    vType := SCustomString;
    vColor :=  GetColorStringFor(IibCustomStrings);
    CatchCodeInsightOptions;
    if Assigned(FEditorCodeInsightOptions) then
    begin
      CurrentList := FEditorCodeInsightOptions.CustomStrings;
      for I := 0 to CurrentList.Count - 1 do
      with TpSHCompletionProposal(Sender) do
      begin
        S := InternalDoCaseCode(CurrentList[I]);
        ItemList.Add(Format(sProposalTemplate, [vColor, vType, S, '']));
        InsertList.Add(CurrentList[I]);
      end;
    end;
  end;
  procedure AddKeywords(AObjectGUID: TGUID);
  var
    CurrentList: TStrings;
    I: Integer;
    vType: string;
    vColor: string;
    vItem, vHint: string;
    vKeywordsList: IibSHKeywordsList;
  begin
    with TpSHCompletionProposal(Sender) do
      if Assigned(TpSHSynEdit(Form.CurrentEditor).KeywordsManager) and
        Supports(TpSHSynEdit(Form.CurrentEditor).KeywordsManager, IibSHKeywordsList, vKeywordsList) then
      begin
        if IsEqualGUID(AObjectGUID, IibSHFunction) then
        begin
          vType := SBuilInFunction;
          CurrentList := vKeywordsList.FunctionList;
        end
        else
        if IsEqualGUID(AObjectGUID, IibSHDomain) then
        begin
          vType := SDataType;
          CurrentList := vKeywordsList.DataTypeList;
        end
        else
        begin
          vType := SKeyWord;
          CurrentList := vKeywordsList.KeywordList;
        end;
        vColor :=  GetColorStringFor(AObjectGUID);
        for I := 0 to CurrentList.Count - 1 do
        with TpSHCompletionProposal(Sender) do
        begin
          vItem := DoCaseCode(CurrentList.Names[I], FCaseSQLCode);
          vHint := CurrentList.ValueFromIndex[I];
          ItemList.Add(Format(sProposalTemplate, [vColor, vType, vItem, vHint]));
          InsertList.Add(CurrentList.Names[I]);
        end;
      end;
  end;
  function FindTableNameForTrigger: string;
  var
    vBody: string;
    vPosBegin, vPosEnd: Integer;
  begin
    Result := EmptyStr;
    with TpSHCompletionProposal(Sender) do
    begin
      vBody := Form.CurrentEditor.Lines.Text;
      vPosBegin := PosExtCI('FOR', vBody, CharsAfterClause, CharsAfterClause);
      if vPosBegin > 0 then
      begin
        Inc(vPosBegin, 4);
        while (I <= Length(vBody)) and (vBody[vPosBegin] in CharsAfterClause) do Inc(vPosBegin);
        if vPosBegin <= Length(vBody) then
        begin
          vPosEnd := vPosBegin + 1;
          if vBody[vPosBegin] = '"' then
          begin
            while (vPosEnd <= Length(vBody)) and (vBody[vPosEnd] <> '"') do Inc(vPosEnd);
            Inc(vPosEnd);
          end
          else
            while (vPosEnd <= Length(vBody)) and (not (vBody[vPosEnd] in CharsAfterClause)) do Inc(vPosEnd);
          Result := Copy(vBody, vPosBegin, vPosEnd - vPosBegin);
          CatchCodeNormilizer;
          if Assigned(FCodeNormalizer) then
            Result := FCodeNormalizer.SourceDDLToMetadataName(Result);

        end;
      end;
    end;
  end;
  procedure AddVariables;
  var
    vInputList, vOutPutList, vLocalList: TStringList;
    I: Integer;
  begin
    vInputList := TStringList.Create;
    vOutPutList := TStringList.Create;
    vLocalList := TStringList.Create;
    try
      with TpSHCompletionProposal(Sender) do
      begin
        ParseProcParams(Form.CurrentEditor.Lines, vInputList, vOutPutList, vLocalList);
        vColor := GetColorStringFor(IibSHProcParam);
//        vType := GetObjectTypeDescription(IibSHProcParam);
        for I := 0 to vInputList.Count - 1 do
        begin
          ItemList.Add(Format(sProposalTemplate, [vColor, SProcParamInput, InternalDoCaseCode(Trim(vInputList.Names[I])), vInputList.ValueFromIndex[I]]));
          InsertList.Add(Trim(vInputList.Names[I]));
        end;
        for I := 0 to vOutPutList.Count - 1 do
        begin
          ItemList.Add(Format(sProposalTemplate, [vColor, SProcParamOutput, InternalDoCaseCode(Trim(vOutPutList.Names[I])), vOutPutList.ValueFromIndex[I]]));
          InsertList.Add(Trim(vOutPutList.Names[I]));
        end;
        for I := 0 to vLocalList.Count - 1 do
        begin
          ItemList.Add(Format(sProposalTemplate, [vColor, SProcParamLocal, InternalDoCaseCode(Trim(vLocalList.Names[I])), vLocalList.ValueFromIndex[I]]));
          InsertList.Add(Trim(vLocalList.Names[I]));
        end;
      end;
    finally
      vInputList.Free;
      vOutPutList.Free;
      vLocalList.Free;
    end;
  end;
begin
  if FCompletionEnabled then
  begin
    with TpSHCompletionProposal(Sender) do
    begin
      ItemList.Clear;
      InsertList.Clear;
      if (TpSHCompletionProposal(Sender).NeedObjectType = ntVariable) and
         (not (Supports(Designer.CurrentComponent, IibSHProcedure) or
          Supports(Designer.CurrentComponent, IibSHTrigger))) then
         NeedObjectType := ntAll;
      case NeedObjectType of

        ntAll:
          begin
              AddKeywords(IibSHDomain);
              AddKeywords(IibSHFunction);
              AddKeywords(IUnknown);

              AddObjectNames(IibSHDomain);
              AddObjectNames(IibSHTable);
              AddObjectNames(IibSHIndex);
              AddObjectNames(IibSHView);
              AddObjectNames(IibSHProcedure);
              AddObjectNames(IibSHTrigger);
              AddObjectNames(IibSHGenerator);
              AddObjectNames(IibSHException);
              AddObjectNames(IibSHFunction);
              AddObjectNames(IibSHFilter);
              AddObjectNames(IibSHRole);
              AddObjectNames(IibSHSystemTable);
              AddCustomStrings;
              if Supports(Designer.CurrentComponent, IibSHTrigger) or
                 Supports(Designer.CurrentComponent, IibSHProcedure) then
                AddVariables;  
          end;
        ntKeyWords: AddKeywords(IUnknown);
        ntDataTypes: AddKeywords(IibSHDomain);
        ntBuildInFunctions: AddKeywords(IibSHFunction);
        ntDomain:
          begin
            AddObjectNames(IibSHDomain);
            AddKeywords(IibSHDomain);
          end;
        ntTable: AddObjectNames(IibSHTable);
        ntView: AddObjectNames(IibSHView);
        ntProcedure: AddObjectNames(IibSHProcedure);
        ntTrigger: AddObjectNames(IibSHTrigger);
        ntGenerator: AddObjectNames(IibSHGenerator);
        ntException: AddObjectNames(IibSHException);
        ntFunction:
          begin
            AddObjectNames(IibSHFunction);
            AddKeywords(IibSHFunction);
          end;
        ntFilter: AddObjectNames(IibSHFilter);
        ntRole: AddObjectNames(IibSHRole);
        ntField:
          begin
            ItemList.Clear;
            InsertList.Clear;
            if ((AnsiUpperCase(CurrentInput) = 'NEW') or
                (AnsiUpperCase(CurrentInput) = 'OLD')) and
                Supports(Designer.CurrentComponent, IibSHTrigger, vTrigger) then
              begin
                if vTrigger.State = csCreate then
                  vObjectName := FindTableNameForTrigger
                else
                  vObjectName := vTrigger.TableName;
              end
            else
            begin
              CatchCodeNormilizer;
              if Assigned(FCodeNormalizer) then
                vObjectName := FCodeNormalizer.SourceDDLToMetadataName(CurrentInput)
              else
                vObjectName := CurrentInput;
            end;
            FieldList := TStringList.Create;
            try
              if Supports(Designer.GetDemon(IpSHFieldListRetriever), IpSHFieldListRetriever, vFieldListRetriever) and
                 Supports(Designer.CurrentComponent, IibSHDatabase, vDatabase) then
              begin
                vFieldListRetriever.Database := vDatabase;
                vFieldListRetriever.GetFieldList(vObjectName, FieldList);
                vColor := GetColorStringFor(IibSHField);
                vType := GetObjectTypeDescription(IibSHField);
                for I := 0 to FieldList.Count - 1 do
                begin
                  ItemList.Add(Format(sProposalTemplate, [vColor, vType, InternalDoCaseCode(FieldList.Names[I]), FieldList.ValueFromIndex[I]]));
                  InsertList.Add(FieldList.Names[I]);
                end;
              end;
            finally
              FieldList.Free;
            end;
            CurrentInput := TpSHSynEdit(Form.CurrentEditor).GetWordAtRowCol(TpSHSynEdit(Form.CurrentEditor).CaretXY);
          end;
        ntVariable:
          begin
            ItemList.Clear;
            InsertList.Clear;
            AddVariables;
            CompletionStart := CompletionStart + 1;
            CurrentInput := TpSHSynEdit(Form.CurrentEditor).GetWordAtRowCol(TpSHSynEdit(Form.CurrentEditor).CaretXY);
          end;
      end;
    end;
    CanExecute := True;
  end
  else
    CanExecute := False;
end;

procedure TibBTObjectNamesManager.FindDeclaration(
  const AObjectName: string);
begin
  CatchCodeNormilizer;
  if Assigned(FCodeNormalizer) then
    Designer.JumpTo(Designer.CurrentComponent.InstanceIID, IUnknown, FCodeNormalizer.SourceDDLToMetadataName(AObjectName))
  else
    Designer.JumpTo(Designer.CurrentComponent.InstanceIID, IUnknown, AObjectName);
end;

function TibBTObjectNamesManager.IsIdentifiresEqual(Sender: TObject;
  AIdentifire1, AIdentifire2: string): Boolean;
var
  S1, S2: string;
begin
  CatchCodeNormilizer;
  if Assigned(FCodeNormalizer) then
  begin
    S1 := FCodeNormalizer.SourceDDLToMetadataName(AIdentifire1);
    S2 := FCodeNormalizer.SourceDDLToMetadataName(AIdentifire2);
    Result := CompareText(S1, S2) = 0;
  end
  else
    Result := CompareText(AIdentifire1, AIdentifire2) = 0;
end;

procedure TibBTObjectNamesManager.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent = FCompletionProposal then
      CompletionProposal := nil;
    if AComponent = FParametersHint then
      FParametersHint := nil;
    if AComponent.IsImplementorOf(FCodeNormalizer) then
      FCodeNormalizer := nil;
    if AComponent.IsImplementorOf(FEditorCodeInsightOptions) then
      FEditorCodeInsightOptions := nil;
    if AComponent.IsImplementorOf(FEditorGeneralOptions) then
      FEditorGeneralOptions := nil;
    if AComponent.IsImplementorOf(FDatabase) then
      FDatabase := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

initialization

  Register;

end.
