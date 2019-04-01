unit ibSHDDLExtractor;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibSHDDLExtractor = class(TibBTTool, IibSHDDLExtractor, IibSHBranch, IfbSHBranch)
  private
    FDDLGenerator: TComponent;
    FDDLGeneratorIntf: IibSHDDLGenerator;
    FText: string;
    FStartTime: TDateTime;

    FPrimaryList: TStrings;
    FUniqueList: TStrings;
    FForeignList: TStrings;
    FCheckList: TStrings;
    FIndexList: TStrings;
    FComputedList: TStrings;
    FTriggerList: TStrings;
    FDescriptionList: TStrings;
    FGrantList: TStrings;

    FActive: Boolean;
    FMode: string;
    FHeader: string;
    FPassword: Boolean;
    FGeneratorValues: Boolean;
    FDescriptions: Boolean;
    FComputedSeparately: Boolean;
    FDecodeDomains: Boolean;
    FGrants: Boolean;
    FOwnerName: Boolean;
    FTerminator: string;
    FFinalCommit: Boolean;
    FOnTextNotify: TSHOnTextNotify;

    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetMode: string;
    procedure SetMode(Value: string);
    function GetHeader: string;
    procedure SetHeader(Value: string);
    function GetPassword: Boolean;
    procedure SetPassword(Value: Boolean);
    function GetGeneratorValues: Boolean;
    procedure SetGeneratorValues(Value: Boolean);
    function GetComputedSeparately: Boolean;
    procedure SetComputedSeparately(Value: Boolean);
    function GetDecodeDomains: Boolean;
    procedure SetDecodeDomains(Value: Boolean);
    function GetDescriptions: Boolean;
    procedure SetDescriptions(Value: Boolean);
    function GetGrants: Boolean;
    procedure SetGrants(Value: Boolean);
    function GetOwnerName: Boolean;
    procedure SetOwnerName(Value: Boolean);
    function GetTerminator: string;
    procedure SetTerminator(Value: string);
    function GetFinalCommit: Boolean;
    procedure SetFinalCommit(Value: Boolean);
    function GetOnTextNotify: TSHOnTextNotify;
    procedure SetOnTextNotify(Value: TSHOnTextNotify);

    procedure WriteString(const S: string; WithLineBreak: Boolean = True);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Prepare;
    procedure DisplayScriptHeader;
    procedure DisplayScriptFooter;
    procedure DisplayDialect;
    procedure DisplayNames;
    procedure DisplayDatabase;
    procedure DisplayConnect;
    procedure DisplayTerminatorStart;
    procedure DisplayTerminatorEnd;
    procedure DisplayCommitWork;
    procedure DisplayDBObject(const AClassIID: TGUID; const ACaption: string; Flag: Integer = -1);
    procedure DisplayGrants;

    function GetComputedList: TStrings;
    function GetPrimaryList: TStrings;
    function GetUniqueList: TStrings;
    function GetForeignList: TStrings;
    function GetCheckList: TStrings;
    function GetIndexList: TStrings;
    function GetTriggerList: TStrings;
    function GetDescriptionList: TStrings;
    function GetGrantList: TStrings;

    property DDLGenerator: IibSHDDLGenerator read FDDLGeneratorIntf;
    property Active: Boolean read GetActive write SetActive;
  published
    property Mode: string read GetMode write SetMode;
    property Header: string read GetHeader write SetHeader;
    property Password: Boolean read GetPassword write SetPassword;
    property GeneratorValues: Boolean read GetGeneratorValues write SetGeneratorValues;
    property ComputedSeparately: Boolean read GetComputedSeparately write SetComputedSeparately;
    property DecodeDomains: Boolean read GetDecodeDomains write SetDecodeDomains;
    property Descriptions: Boolean read GetDescriptions write SetDescriptions;
    property Grants: Boolean read GetGrants write SetGrants;
    property OwnerName: Boolean read GetOwnerName write SetOwnerName;
    property Terminator: string read GetTerminator write SetTerminator;
    property FinalCommit: Boolean read GetFinalCommit write SetFinalCommit;    
    property OnTextNotify: TSHOnTextNotify read GetOnTextNotify write SetOnTextNotify;
  end;

  TibSHDDLExtractorFactory = class(TibBTToolFactory)
  end;

procedure Register;

implementation

uses
  ibSHConsts, ibSHValues,
  ibSHDDLExtractorActions,
  ibSHDDLExtractorEditors;

procedure Register;
begin
  SHRegisterImage(GUIDToString(IibSHDDLExtractor), 'DDLExtractor.bmp');

  SHRegisterImage(TibSHDDLExtractorPaletteAction.ClassName,        'DDLExtractor.bmp');
  SHRegisterImage(TibSHDDLExtractorFormAction.ClassName,           'Form_DDLText.bmp');
  SHRegisterImage(TibSHDDLExtractorToolbarAction_Run.ClassName,    'Button_Run.bmp');
  SHRegisterImage(TibSHDDLExtractorToolbarAction_Pause.ClassName,  'Button_Stop.bmp');
  SHRegisterImage(TibSHDDLExtractorToolbarAction_SaveAs.ClassName, 'Button_SaveAs.bmp');
  SHRegisterImage(TibSHDDLExtractorToolbarAction_Region.ClassName, 'Button_Tree.bmp');
  
  SHRegisterImage(SCallTargetScript, 'Form_DDLText.bmp');

  SHRegisterComponents([
    TibSHDDLExtractor,
    TibSHDDLExtractorFactory]);

  SHRegisterActions([
    // Palette
    TibSHDDLExtractorPaletteAction,
    // Forms
    TibSHDDLExtractorFormAction,
    // Toolbar
    TibSHDDLExtractorToolbarAction_Run,
    TibSHDDLExtractorToolbarAction_Pause,
    TibSHDDLExtractorToolbarAction_SaveAs,
    TibSHDDLExtractorToolbarAction_Region
    ]);

  SHRegisterPropertyEditor(IibSHDDLExtractor, 'Mode', TibSHDDLExtractorModePropEditor);
  SHRegisterPropertyEditor(IibSHDDLExtractor, 'Header', TibSHDDLExtractorHeaderPropEditor);
end;

{ TibSHDDLExtractor }

constructor TibSHDDLExtractor.Create(AOwner: TComponent);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner);
  FText := EmptyStr;
  FStartTime := 0;

  FComputedList := TStringList.Create;
  FPrimaryList := TStringList.Create;
  FUniqueList := TStringList.Create;
  FForeignList := TStringList.Create;
  FCheckList := TStringList.Create;
  FIndexList := TStringList.Create;
  FTriggerList := TStringList.Create;
  FDescriptionList := TStringList.Create;
  FGrantList := TStringList.Create;

  FMode := ExtractModes[0]; {All Objects}
  FHeader := ExtractHeaders[0]; {Create}
  FPassword := True;
//  FGeneratorValues := False;
  FGeneratorValues := True; 
  FDescriptions := False;
  FComputedSeparately := False;
  FDecodeDomains := False;
  FGrants := False;
  FOwnerName := False;
  FTerminator := '^';
  FFinalCommit := True;

  vComponentClass := Designer.GetComponent(IibSHDDLGenerator);
  if Assigned(vComponentClass) then
  begin
    FDDLGenerator := vComponentClass.Create(nil);
    Supports(FDDLGenerator, IibSHDDLGenerator, FDDLGeneratorIntf);
  end;
  Assert(DDLGenerator <> nil, 'DDLGenerator = nil');
end;

destructor TibSHDDLExtractor.Destroy;
begin
  FComputedList.Free;
  FPrimaryList.Free;
  FUniqueList.Free;
  FForeignList.Free;
  FCheckList.Free;
  FIndexList.Free;
  FTriggerList.Free;
  FDescriptionList.Free;
  FGrantList.Free;

  FDDLGeneratorIntf := nil;
  FDDLGenerator.Free;
  inherited Destroy;
end;

function TibSHDDLExtractor.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure TibSHDDLExtractor.SetActive(Value: Boolean);
begin
  FActive := Value;
end;

function TibSHDDLExtractor.GetMode: string;
begin
  Result := FMode;
end;

procedure TibSHDDLExtractor.SetMode(Value: string);
begin
  if FMode <> Value then
  begin
    if Value = ExtractModes[0] {All Objects} then
    begin
      FinalCommit := True;
    end;

    if Value = ExtractModes[1] {By Objects} then
    begin
      FinalCommit := False;
    end;

//    if Value = ExtractModes[2] {Table Packages} then
//    begin
//      FinalCommit := False;
//      // TODO
//    end;

    Designer.UpdateObjectInspector;
    FMode := Value;
  end;
end;

function TibSHDDLExtractor.GetHeader: string;
begin
  Result := FHeader;
end;

procedure TibSHDDLExtractor.SetHeader(Value: string);
begin
  if FHeader <> Value then
  begin
    if Value = ExtractHeaders[2] {None} then
      MakePropertyInvisible('Password')
    else
      MakePropertyVisible('Password');

    Designer.UpdateObjectInspector;
    FHeader := Value;
  end;
end;

function TibSHDDLExtractor.GetPassword: Boolean;
begin
  Result := FPassword;
end;

procedure TibSHDDLExtractor.SetPassword(Value: Boolean);
begin
  FPassword := Value;
end;

function TibSHDDLExtractor.GetGeneratorValues: Boolean;
begin
  Result := FGeneratorValues;
end;

procedure TibSHDDLExtractor.SetGeneratorValues(Value: Boolean);
begin
  FGeneratorValues := Value;
end;

function TibSHDDLExtractor.GetComputedSeparately: Boolean;
begin
  Result := FComputedSeparately;
end;

procedure TibSHDDLExtractor.SetComputedSeparately(Value: Boolean);
begin
  FComputedSeparately := Value;
end;

function TibSHDDLExtractor.GetDecodeDomains: Boolean;
begin
  Result := FDecodeDomains;
end;

procedure TibSHDDLExtractor.SetDecodeDomains(Value: Boolean);
begin
  FDecodeDomains := Value;
end;

function TibSHDDLExtractor.GetDescriptions: Boolean;
begin
  Result := FDescriptions;
end;

procedure TibSHDDLExtractor.SetDescriptions(Value: Boolean);
begin
  FDescriptions := Value;
end;

function TibSHDDLExtractor.GetGrants: Boolean;
begin
  Result := FGrants;
end;

procedure TibSHDDLExtractor.SetGrants(Value: Boolean);
begin
  FGrants := Value;
end;

function TibSHDDLExtractor.GetOwnerName: Boolean;
begin
  Result := FOwnerName;
end;

procedure TibSHDDLExtractor.SetOwnerName(Value: Boolean);
begin
  FOwnerName := Value;
end;

function TibSHDDLExtractor.GetTerminator: string;
begin
  Result := FTerminator;
end;

procedure TibSHDDLExtractor.SetTerminator(Value: string);
begin
  FTerminator := Value;
end;

function TibSHDDLExtractor.GetFinalCommit: Boolean;
begin
  Result := FFinalCommit;
end;

procedure TibSHDDLExtractor.SetFinalCommit(Value: Boolean);
begin
  FFinalCommit := Value;
end;

function TibSHDDLExtractor.GetOnTextNotify: TSHOnTextNotify;
begin
  Result := FOnTextNotify;
end;

procedure TibSHDDLExtractor.SetOnTextNotify(Value: TSHOnTextNotify);
begin
  FOnTextNotify := Value;
end;

procedure TibSHDDLExtractor.WriteString(const S: string; WithLineBreak: Boolean = True);
begin
  if Assigned(FOnTextNotify) then
  begin
    if WithLineBreak then FOnTextNotify(Self, EmptyStr);
    FOnTextNotify(Self, S);
  end;
end;

procedure TibSHDDLExtractor.Prepare;
begin
  FComputedList.Clear;
  FPrimaryList.Clear;
  FUniqueList.Clear;
  FForeignList.Clear;
  FCheckList.Clear;
  FIndexList.Clear;
  FTriggerList.Clear;     
  FDescriptionList.Clear;
  FGrantList.Clear;
end;

procedure TibSHDDLExtractor.DisplayScriptHeader;
begin
  FStartTime := Now;
  FText := Format('/* BT: DDL Extractor started at %s                       */', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', FStartTime)]);
  WriteString(FText, False);
end;

procedure TibSHDDLExtractor.DisplayScriptFooter;
begin
  FText := Format('/* BT: DDL Extractor ended at %s                         */', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', Now)]);
  WriteString(FText);
  FText := Format('/* BT: Elapsed time %s                                              */', [FormatDateTime('hh:nn:ss.zzz', Now - FStartTime)]);
  WriteString(FText, False);
  WriteString(EmptyStr);
end;

procedure TibSHDDLExtractor.DisplayDialect;
begin
  if Assigned(BTCLDatabase) then
  begin
    Assert(BTCLDatabase.DRVDatabase <> nil, 'BTCLDatabase.DRVDatabase = nil');
    FText := Format('SET SQL DIALECT %d;', [BTCLDatabase.DRVDatabase.SQLDialect]);
    WriteString(FText);
  end;
end;

procedure TibSHDDLExtractor.DisplayNames;
begin
  if Assigned(BTCLDatabase) then
  begin
    Assert(BTCLDatabase.DRVDatabase <> nil, 'BTCLDatabase.DRVDatabase = nil');
    FText := Format('SET NAMES %s;', [BTCLDatabase.DBCharset]);
    WriteString(FText);
  end;
end;

procedure TibSHDDLExtractor.DisplayDatabase;
var
  ConnectPath, UserName, UserPassword, PageSize, Charset: string;
begin
  if Assigned(BTCLDatabase) then
  begin
    ConnectPath := BTCLDatabase.ConnectPath;
    UserName := BTCLDatabase.UserName;
    if Password then UserPassword := BTCLDatabase.Password else UserPassword := 'Enter your password here';
    PageSize := IntToStr(BTCLDatabase.DRVDatabase.PageSize);
    Charset := BTCLDatabase.DBCharset;// DRVDatabase.Charset;

    FText := Format('CREATE DATABASE ''%s''', [ConnectPath]);
    WriteString(FText);
    FText := Format('USER ''%s'' PASSWORD ''%s''', [UserName, UserPassword]);
    WriteString(FText, False);
    FText := Format('PAGE_SIZE %s', [PageSize]);
    WriteString(FText, False);
    FText := Format('DEFAULT CHARACTER SET %s;', [Charset]);
    WriteString(FText, False);
  end;
end;

procedure TibSHDDLExtractor.DisplayConnect;
var
  ConnectPath, UserName, UserPassword: string;
begin
  if Assigned(BTCLDatabase) then
  begin
    ConnectPath := BTCLDatabase.ConnectPath;
    UserName := BTCLDatabase.UserName;
    if Password then UserPassword := BTCLDatabase.Password else UserPassword := 'Enter your password here';
    FText := Format('CONNECT ''%s'' USER ''%s'' PASSWORD ''%s'';', [ConnectPath, UserName, UserPassword]);
    WriteString(FText);
  end;
end;

procedure TibSHDDLExtractor.DisplayTerminatorStart;
begin
  if Assigned(BTCLDatabase) and (Length(FTerminator) > 0) then
  begin
    FText := Format('SET TERM %s ;', [FTerminator]);
    WriteString(FText);
  end;
end;

procedure TibSHDDLExtractor.DisplayTerminatorEnd;
begin
  if Assigned(BTCLDatabase) and (Length(FTerminator) > 0) then
  begin
    FText := Format('SET TERM ; %s', [FTerminator]);
    WriteString(FText);
  end;
end;

procedure TibSHDDLExtractor.DisplayCommitWork;
begin
  if Assigned(BTCLDatabase) then
  begin
    FText := Format('COMMIT WORK;', []);
    WriteString(FText);
  end;
end;

procedure TibSHDDLExtractor.DisplayDBObject(const AClassIID: TGUID; const ACaption: string; Flag: Integer = -1);
var
  vComponentClass: TSHComponentClass;
  vComponent: TSHComponent;
  I: Integer;
  DBObject: IibSHDBObject;
  DBDomain: IibSHDomain;
  DBGenerator: IibSHGenerator;
  DBProcedure: IibSHProcedure;
  DBTable: IibSHTable;
  DBView: IibSHView;
  DBIndex: IibSHIndex;
  DBConstraint: IibSHConstraint;
  DBTrigger: IibSHTrigger;
  DBField: IibSHField;
  DBParameter: IibSHProcParam;
  s:string;
begin
// Flag: Procedure,Trigger  Headers(0) PK(1) UNQ(2) FK(3) CHK(4)

  vComponentClass := Designer.GetComponent(AClassIID);
  if Assigned(vComponentClass) then
  begin
    vComponent := vComponentClass.Create(nil);
    try
      Supports(vComponent, IibSHDBObject, DBObject);
      if Assigned(DBObject) and Assigned(DDLGenerator) then
      begin
        DBObject.Caption := ACaption;
        DBObject.OwnerIID := Self.OwnerIID;
        DBObject.State := csSource;
        DDLGenerator.SetUseFakeValues(False);
        if Supports(vComponent, IibSHTable, DBTable) then
          DBTable.DecodeDomains := DecodeDomains
        else
        if Supports(vComponent, IibSHGenerator, DBGenerator) then
          DBGenerator.ShowSetClause := GeneratorValues
        else
        if Supports(vComponent, IibSHProcedure) or Supports(vComponent, IibSHTrigger) then
          if Length(FTerminator) > 0 then DDLGenerator.Terminator := FTerminator;

//        FText := Format('%s', [DDLGenerator.GetDDLText(DBObject)]);
        FText := DDLGenerator.GetDDLText(DBObject);

        if Supports(vComponent, IibSHTrigger, DBTrigger) then
        begin
          if Flag<>-1 then
          begin
            if Flag = 0 then
            begin
              DBObject.State := csCreate;
              // Создание пустого триггера для вьюхи
              FText := DDLGenerator.GetDDLText(DBObject);
              FText :=
               StringReplace(FText,'/* <trigger_body> */','POST_EVENT ''BT$ Empty trigger '';',[]);
              if OwnerName then
                FText := Format('/* %s: %s, Owner: %s */%s' + FText, [GUIDToName(DBObject.ClassIID), DBObject.Caption, DBObject.OwnerName, SLineBreak]);
            end
            else
            begin
             // Заполнение тела триггера для вьюхи
              DBObject.State := csAlter;
              FText := Format('%s', [DDLGenerator.GetDDLText(DBObject)]);
            end;
          end
        end
        else
        if Supports(vComponent, IibSHProcedure, DBProcedure) then
        begin
          if Flag = 0 then
          begin
//            FText := Format('%s', [Trim(DBProcedure.HeaderDDL.Text)]);
            FText := DBProcedure.HeaderDDL.Text;
            if OwnerName then
              FText := Format('/* %s: %s, Owner: %s */%s' + FText, [GUIDToName(DBObject.ClassIID), DBObject.Caption, DBObject.OwnerName, SLineBreak]);
          end else
          begin
            DBObject.State := csAlter;
//            FText := Format('%s', [DDLGenerator.GetDDLText(DBObject)]);
            FText :=DDLGenerator.GetDDLText(DBObject)
          end;
        end
        else
         if Supports(vComponent, IibSHTable) or Supports(vComponent, IibSHView) or Supports(vComponent, IibSHRole) then
         begin
          if OwnerName then
            FText := Format('/* %s: %s, Owner: %s */%s' + FText, [GUIDToName(DBObject.ClassIID), DBObject.Caption, DBObject.OwnerName, SLineBreak]);
         end;

        if Supports(vComponent, IibSHTable, DBTable) then
        begin
          for I := 0 to Pred(DBTable.Constraints.Count) do
          begin
            DBConstraint := DBTable.GetConstraint(I);
            s:=DBConstraint.ConstraintType;
            if Length(s)>0 then
            case s[1] of
             'C','c':
              if SameText(s, 'CHECK') then
                FCheckList.Add(Trim(DBConstraint.SourceDDL.Text));
             'F','f':
               if SameText(s, 'FOREIGN KEY') then
                 FForeignList.Add(Trim(DBConstraint.SourceDDL.Text));
             'P','p': if SameText(s, 'PRIMARY KEY') then
                       FPrimaryList.Add(Trim(DBConstraint.SourceDDL.Text));
             'U','u': if SameText(s, 'UNIQUE') then
                        FUniqueList.Add(Trim(DBConstraint.SourceDDL.Text));
           end
          end;


          if ComputedSeparately then
          begin
            for I := 0 to Pred(DBTable.Fields.Count) do
            begin
              DBField := DBTable.GetField(I);
              if Length(DBField.ComputedSource.Text) > 0 then
                FComputedList.Add(Trim(DBField.SourceDDL.Text));
            end;
            DBTable.WithoutComputed := True;
            // -> в DBTable.Refresh идет очистка списков,
            //    если предварительно не обнилить переменные, то на выходе AV
            DBField := nil;
            DBConstraint := nil;
            DBIndex := nil;
            DBTrigger := nil;
            // <-
            DBTable.Refresh;
            FText := Trim(DBTable.SourceDDL.Text);
          end;
        end;

        // Выгрузка грантов
        if Grants and (Flag <> 0) then
        begin
          DBObject.FormGrants;
          if DBObject.Grants.Count > 0 then
          begin
            FGrantList.Add(Format('/* Grants for %s: %s */', [GUIDToName(DBObject.ClassIID), DBObject.Caption]));
            FGrantList.Add(EmptyStr);
            for I := 0 to Pred(DBObject.Grants.Count) do
              FGrantList.Add(DBObject.Grants[I]);
            FGrantList.Add(EmptyStr);  
          end;
        end;

        // Выгрузка дескрипшенов
        if Descriptions and (Flag <> 0) then
        begin
          Supports(vComponent, IibSHDomain, DBDomain);

          if Length(DBObject.Description.Text) > 0 then
          begin
            FDescriptionList.Add(Format('/* Description for %s: %s */', [GUIDToName(DBObject.ClassIID), DBObject.Caption]));
            FDescriptionList.Add(DBObject.GetDescriptionStatement(False));
          end;

          if Supports(vComponent, IibSHTable, DBTable) then
          begin
            for I := 0 to Pred(DBTable.Fields.Count) do
            begin
              DBField := DBTable.GetField(I);
              if Length(DBField.Description.Text) > 0 then
              begin
                FDescriptionList.Add(Format('/* Description for %s Field: %s.%s*/', [GUIDToName(DBObject.ClassIID), DBObject.Caption, DBTable.Fields[I]]));
                FDescriptionList.Add(DBField.GetDescriptionStatement(False));
              end;
            end;
          end;

          if Supports(vComponent, IibSHView, DBView) then
          begin
            for I := 0 to Pred(DBView.Fields.Count) do
            begin
              DBField := DBView.GetField(I);
              if Length(DBField.Description.Text) > 0 then
              begin
                FDescriptionList.Add(Format('/* Description for %s Field: %s.%s*/', [GUIDToName(DBObject.ClassIID), DBObject.Caption, DBView.Fields[I]]));
                FDescriptionList.Add(DBField.GetDescriptionStatement(False));
              end;
            end;
          end;

          if Supports(vComponent, IibSHProcedure, DBProcedure) then
          begin
            for I := 0 to Pred(DBProcedure.Params.Count) do
            begin
              DBParameter := DBProcedure.GetParam(I);
              if Length(DBParameter.Description.Text) > 0 then
              begin
                FDescriptionList.Add(Format('/* Description for %s Input Parameter: %s.%s*/', [GUIDToName(DBObject.ClassIID), DBObject.Caption, DBProcedure.Params[I]]));
                FDescriptionList.Add(DBParameter.GetDescriptionStatement(False));
              end;
            end;

            for I := 0 to Pred(DBProcedure.Returns.Count) do
            begin
              DBParameter := DBProcedure.GetReturn(I);
              if Length(DBParameter.Description.Text) > 0 then
              begin
                FDescriptionList.Add(Format('/* Description for %s Output Parameter: %s.%s*/', [GUIDToName(DBObject.ClassIID), DBObject.Caption, DBProcedure.Returns[I]]));
                FDescriptionList.Add(DBParameter.GetDescriptionStatement(False));
              end;
            end;
          end;
        end;

        WriteString(FText);
      end;
    finally
      DBDomain := nil;
      DBGenerator := nil;
      DBParameter := nil;
      DBProcedure := nil;
      DBField := nil;
      DBConstraint := nil;
      DBIndex := nil;
      DBTrigger := nil;
      DBTable := nil;
      DBView := nil;
      DBObject := nil;
      FreeAndNil(vComponent);
      DDLGenerator.Terminator := ';';
    end;
  end;
end;

procedure TibSHDDLExtractor.DisplayGrants;
begin
end;

function TibSHDDLExtractor.GetComputedList: TStrings;
begin
  Result := FComputedList;
end;

function TibSHDDLExtractor.GetPrimaryList: TStrings;
begin
  Result := FPrimaryList;
end;

function TibSHDDLExtractor.GetUniqueList: TStrings;
begin
  Result := FUniqueList;
end;

function TibSHDDLExtractor.GetForeignList: TStrings;
begin
  Result := FForeignList;
end;

function TibSHDDLExtractor.GetCheckList: TStrings;
begin
  Result := FCheckList;
end;

function TibSHDDLExtractor.GetIndexList: TStrings;
begin
  Result := FIndexList;
end;

function TibSHDDLExtractor.GetTriggerList: TStrings;
begin
  Result := FTriggerList;
end;

function TibSHDDLExtractor.GetDescriptionList: TStrings;
begin
  Result := FDescriptionList;
end;

function TibSHDDLExtractor.GetGrantList: TStrings;
begin
  Result := FGrantList;
end;

initialization

  Register;

end.



