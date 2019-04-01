unit ibSHDDLFinder;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  IibServerSideSearch= interface
  ['{E16DE9AB-BE3C-4294-8714-988F1F210476}']
  // interface is visible in package Only
   function FindOnServerSide(const AClassIID: TGUID; var OutPutList:TStrings):boolean;
   procedure SetNeedUTFEncode(Value:boolean);
  end;

  TibBTLookIn = class;

  TibSHDDLFinder = class(TibBTTool, IibSHDDLFinder,IibServerSideSearch, IibSHBranch, IfbSHBranch)
  private
    FDDLGenerator: TComponent;
    FDDLGeneratorIntf: IibSHDDLGenerator;
    FLastSource: string;

    FActive: Boolean;
    FFindString: string;
    FCaseSensitive: Boolean;
    FWholeWordsOnly: Boolean;
    FRegularExpression: Boolean;
    FLookIn: TibBTLookIn;
    FFindObjects:TStrings;
    FNeedUTFEncode:boolean;
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetFindString: string;
    procedure SetFindString(Value: string);
    function GetCaseSensitive: Boolean;
    procedure SetCaseSensitive(Value: Boolean);
    function GetWholeWordsOnly: Boolean;
    procedure SetWholeWordsOnly(Value: Boolean);
    function GetRegularExpression: Boolean;
    procedure SetRegularExpression(Value: Boolean);
    function GetLookIn: IibSHLookIn;

    function Find(const ASource: string): Boolean;
    function FindIn(const AClassIID: TGUID; const ACaption: string): Boolean;

    function FindOnServerSide(const AClassIID: TGUID; var OutPutList:TStrings):boolean;
    procedure SetNeedUTFEncode(Value:boolean);

    function LastSource: string;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property DDLGenerator: IibSHDDLGenerator read FDDLGeneratorIntf;
    property Active: Boolean read GetActive write SetActive;
    property FindString: string read GetFindString write SetFindString;
  published
    property CaseSensitive: Boolean read GetCaseSensitive write SetCaseSensitive;
    property WholeWordsOnly: Boolean read GetWholeWordsOnly write SetWholeWordsOnly;
    property RegularExpression: Boolean read GetRegularExpression write SetRegularExpression;
    property LookIn: TibBTLookIn read FLookIn;
  end;

  TibSHDDLFinderFactory = class(TibBTToolFactory)
  end;

  TibBTLookIn = class(TSHInterfacedPersistent, IibSHLookIn)
  private
    FDomains: Boolean;
    FTables: Boolean;
    FConstraints: Boolean;
    FIndices: Boolean;
    FViews: Boolean;
    FProcedures: Boolean;
    FTriggers: Boolean;
    FGenerators: Boolean;
    FExceptions: Boolean;
    FFunctions: Boolean;
    FFilters: Boolean;
    FRoles: Boolean;
    function GetDomains: Boolean;
    procedure SetDomains(Value: Boolean);
    function GetTables: Boolean;
    procedure SetTables(Value: Boolean);
    function GetConstraints: Boolean;
    procedure SetConstraints(Value: Boolean);
    function GetIndices: Boolean;
    procedure SetIndices(Value: Boolean);
    function GetViews: Boolean;
    procedure SetViews(Value: Boolean);
    function GetProcedures: Boolean;
    procedure SetProcedures(Value: Boolean);
    function GetTriggers: Boolean;
    procedure SetTriggers(Value: Boolean);
    function GetGenerators: Boolean;
    procedure SetGenerators(Value: Boolean);
    function GetExceptions: Boolean;
    procedure SetExceptions(Value: Boolean);
    function GetFunctions: Boolean;
    procedure SetFunctions(Value: Boolean);
    function GetFilters: Boolean;
    procedure SetFilters(Value: Boolean);
    function GetRoles: Boolean;
    procedure SetRoles(Value: Boolean);
  published
    property Domains: Boolean read GetDomains write SetDomains;
    property Tables: Boolean read GetTables write SetTables;
//    property Constraints: Boolean read GetConstraints write SetConstraints;
    property Indices: Boolean read GetIndices write SetIndices;
    property Views: Boolean read GetViews write SetViews;
    property Procedures: Boolean read GetProcedures write SetProcedures;
    property Triggers: Boolean read GetTriggers write SetTriggers;
    property Generators: Boolean read GetGenerators write SetGenerators;
    property Exceptions: Boolean read GetExceptions write SetExceptions;
    property Functions: Boolean read GetFunctions write SetFunctions;
    property Filters: Boolean read GetFilters write SetFilters;
    property Roles: Boolean read GetRoles write SetRoles;
  end;

procedure Register;

implementation

uses
  ibSHConsts, ibSHStrUtil,
  ibSHDDLFinderActions,
  ibSHDDLFinderEditors;

procedure Register;
begin
  SHRegisterImage(GUIDToString(IibSHDDLFinder),   'DDLFinder.bmp');

  SHRegisterImage(TibSHDDLFinderPaletteAction.ClassName,            'DDLFinder.bmp');
  SHRegisterImage(TibSHDDLFinderFormAction.ClassName,               'Form_Search_Results.bmp');
  SHRegisterImage(TibSHDDLFinderToolbarAction_Run.ClassName,        'Button_Run.bmp');
  SHRegisterImage(TibSHDDLFinderToolbarAction_Pause.ClassName,      'Button_Stop.bmp');
  SHRegisterImage(TibSHDDLFinderToolbarAction_NextResult.ClassName, 'Button_Arrow_Down.bmp');
  SHRegisterImage(TibSHDDLFinderToolbarAction_PrevResult.ClassName, 'Button_Arrow_Top.bmp');

  SHRegisterImage(SCallSearchResults, 'Form_Search_Results.bmp');

  SHRegisterComponents([
    TibSHDDLFinder,
    TibSHDDLFinderFactory]);

  SHRegisterActions([
    // Palette
    TibSHDDLFinderPaletteAction,
    // Forms
    TibSHDDLFinderFormAction,
    // Toolbar
    TibSHDDLFinderToolbarAction_Run,
    TibSHDDLFinderToolbarAction_Pause,
    TibSHDDLFinderToolbarAction_NextResult,
    TibSHDDLFinderToolbarAction_PrevResult]);

  SHRegisterPropertyEditor(IibSHDDLFinder, 'LookIn', TibBTLookInPropEditor);
end;

{ TibSHDDLFinder }

constructor TibSHDDLFinder.Create(AOwner: TComponent);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner);
  FFindObjects:=TStringList.Create;
  FLookIn := TibBTLookIn.Create;
  FLookIn.Views := True;
  FLookIn.Procedures := True;
  FLookIn.Triggers := True;
  vComponentClass := Designer.GetComponent(IibSHDDLGenerator);
  if Assigned(vComponentClass) then
  begin
    FDDLGenerator := vComponentClass.Create(nil);
    Supports(FDDLGenerator, IibSHDDLGenerator, FDDLGeneratorIntf);
  end;
end;

destructor TibSHDDLFinder.Destroy;
begin
  FFindObjects.Free;
  FLookIn.Free;
  FDDLGeneratorIntf := nil;
  FDDLGenerator.Free;
  inherited Destroy;
end;

function TibSHDDLFinder.Find(const ASource: string): Boolean;
var
  S1, S2: string;
  BegSub, EndSub: TCharSet;
begin
  BegSub := ['+', ')', '(', '*', '/', '|', ',', '=', '>', '<', '-', '!', '^', '~', ',', ';', ' ', #13, #10, #9, '"'];
  EndSub := ['+', ')', '(', '*', '/', '|', ',', '=', '>', '<', '-', '!', '^', '~', ',', ';', ' ', #13, #10, #9, '"'];
  S1 := FindString;
  S2 := ASource;

  if not CaseSensitive then
  begin
    S1 := AnsiUpperCase(S1);
    S2 := AnsiUpperCase(S2);
  end;

  if RegularExpression then
  begin
    Result := Designer.RegExprMatch(S1, S2, CaseSensitive);
    Exit;
  end;

  if WholeWordsOnly then
    Result := PosExt(S1, S2, BegSub, EndSub) > 0
  else
    Result := Pos(S1, S2) > 0;

end;

function TibSHDDLFinder.FindIn(const AClassIID: TGUID; const ACaption: string): Boolean;
var
  vComponentClass: TSHComponentClass;
  vComponent: TSHComponent;
  DBObject: IibSHDBObject;
begin
  Result := False;
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
          FLastSource := DDLGenerator.GetDDLText(DBObject);
          Result := Find(FLastSource);
      end;
    finally
      DBObject := nil;
      FreeAndNil(vComponent);
    end;
  end;
end;

function TibSHDDLFinder.LastSource: string;
begin
  Result := FLastSource;
end;

function TibSHDDLFinder.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure TibSHDDLFinder.SetActive(Value: Boolean);
begin
  FActive := Value;
end;

function TibSHDDLFinder.GetFindString: string;
begin
  Result := FFindString;
end;

procedure TibSHDDLFinder.SetFindString(Value: string);
begin
  FFindString := Value;
end;

function TibSHDDLFinder.GetCaseSensitive: Boolean;
begin
  Result := FCaseSensitive;
end;

procedure TibSHDDLFinder.SetCaseSensitive(Value: Boolean);
begin
  FCaseSensitive := Value;
end;

function TibSHDDLFinder.GetWholeWordsOnly: Boolean;
begin
  Result := FWholeWordsOnly;
end;

procedure TibSHDDLFinder.SetWholeWordsOnly(Value: Boolean);
begin
  FWholeWordsOnly := Value;
end;

function TibSHDDLFinder.GetRegularExpression: Boolean;
begin
  Result := FRegularExpression;
end;

procedure TibSHDDLFinder.SetRegularExpression(Value: Boolean);
begin
  FRegularExpression := Value;
end;

function TibSHDDLFinder.GetLookIn: IibSHLookIn;
begin
  Supports(LookIn, IibSHLookIn, Result);
end;


function TibSHDDLFinder.FindOnServerSide(const AClassIID: TGUID; var OutPutList:TStrings):boolean;
const
   cSearchSQL:array[0..7] of string =('SELECT  PR.rdb$procedure_name '+
                 'FROM RDB$PROCEDURES PR '+
                 'WHERE cast(PR.RDB$PROCEDURE_SOURCE as '+
                 ' blob sub_type text character set NONE)  containing :s '+
                 'or PR.rdb$procedure_name containing :s '+
                 'UNION '+
                 'SELECT  PAR.rdb$procedure_name '+
                 'FROM RDB$PROCEDURE_PARAMETERS PAR '+
                 'WHERE RDB$PARAMETER_NAME containing :s '+
                 'ORDER BY 1',

'  Select distinct r.rdb$relation_name'#$D#$A+
'from rdb$relations R'#$D#$A+
'join  rdb$relation_fields f on f.rdb$relation_name=r.rdb$relation_name'#$D#$A+
'Where R.RDB$SYSTEM_FLAG=0 and '#$D#$A+'not r.rdb$view_blr  is null and '#$D#$A+
'((cast(r.rdb$view_source as blob sub_type text character set NONE)containing :s) or'#$D#$A+
'(r.rdb$relation_name containing :s)'#$D#$A+
'or  f.rdb$field_name containing :S)'#$D#$A+
'order by 1',



'Select  t.rdb$trigger_name '#13#10+
'from rdb$triggers t'#13#10+
'where RDB$SYSTEM_FLAG=0 and '#13#10+
'cast(t.rdb$trigger_source as blob sub_type text character set NONE)  containing :s'#13#10+
'or t.rdb$trigger_name containing :s' ,

'Select distinct r.rdb$relation_name '#13#10+
'from rdb$relations R '#13#10+
'join  rdb$relation_fields f on f.rdb$relation_name=r.rdb$relation_name'#13#10+
'Where R.RDB$SYSTEM_FLAG=0 and r.rdb$view_source is  null and'#13#10+
'((r.rdb$relation_name containing :s)'#13#10+
'or  f.rdb$field_name containing :S'#13#10+
'or  f.rdb$field_source containing :S)'#$D#$A+
'order by 1',

'SELECT RDB$GENERATOR_NAME FROM RDB$GENERATORS'#13#10+
'WHERE RDB$SYSTEM_FLAG IS NULL'#13#10+
'and    RDB$GENERATOR_NAME containing :s' ,

'SELECT RDB$EXCEPTION_NAME'#13#10+
'FROM RDB$EXCEPTIONS'#13#10+
'where RDB$SYSTEM_FLAG IS NOT NULL and'#13#10+
'(RDB$EXCEPTION_NAME containing :s or RDB$MESSAGE  containing :s )' ,

'SELECT  r.rdb$function_name'#13#10+
'FROM rdb$functions  r'#13#10+
'where r.rdb$system_flag is  null'#13#10+
'and (r.rdb$function_name containing :s or r.rdb$module_name  containing :s'#13#10+
' or r.rdb$entrypoint containing :s  )' ,

'Select RDB$FIELD_NAME from RDB$FIELDS '#13#10+
'WHERE (rdb$system_flag is  null or rdb$system_flag=0) and '#13#10+
'RDB$FIELD_NAME containing :s'
 );
var
  i:byte;
  SearchStr:string;
begin
 Result:=not RegularExpression;
 if not Result then
  Exit;
 OutPutList:=FFindObjects;
 FFindObjects.Clear;
 if  IsEqualGUID(AClassIID,IibSHProcedure) then
 begin
  i:=0;
  Result:=True;
 end
 else
 if  IsEqualGUID(AClassIID,IibSHView) then
 begin
  i:=1;
  Result:=True;
 end
 else
 if  IsEqualGUID(AClassIID,IibSHTrigger) then
 begin
  i:=2;
  Result:=True;
 end
 else
 if  IsEqualGUID(AClassIID,IibSHTable) then
 begin
  i:=3;
  Result:=True;
 end
 else
 if  IsEqualGUID(AClassIID, IibSHGenerator) then
 begin
  i:=4;
  Result:=True;
 end
 else
 if  IsEqualGUID(AClassIID, IibSHException) then
 begin
  i:=5;
  Result:=True;
 end
 else
 if  IsEqualGUID(AClassIID, IibSHFunction) then
 begin
  i:=6;
  Result:=True;
 end
 else
 if  IsEqualGUID(AClassIID, IibSHDomain) then
 begin
  i:=7;
  Result:=True;
 end
 else
 begin
   Result:=False;
   Exit
 end;
 if Result then
 begin
  if not BTCLDatabase.DRVQuery.Transaction.InTransaction then
    BTCLDatabase.DRVQuery.Transaction.StartTransaction;
  if FNeedUTFEncode then
    SearchStr:=UTF8Encode(FindString)
  else
   SearchStr:=FindString;
  BTCLDatabase.DRVQuery.ExecSQL(cSearchSQL[i],[SearchStr],False);
  while not BTCLDatabase.DRVQuery.Eof do
  begin
   FFindObjects.Add(Trim(BTCLDatabase.DRVQuery.GetFieldValue(0)));
   BTCLDatabase.DRVQuery.Next
  end;
  BTCLDatabase.DRVQuery.Transaction.Commit
 end
end;

procedure TibSHDDLFinder.SetNeedUTFEncode(Value: boolean);
begin
 FNeedUTFEncode:=Value
end;

{ TibBTLookIn }

function TibBTLookIn.GetDomains: Boolean;
begin
  Result := FDomains;
end;

procedure TibBTLookIn.SetDomains(Value: Boolean);
begin
  FDomains := Value;
end;

function TibBTLookIn.GetTables: Boolean;
begin
  Result := FTables;
end;

procedure TibBTLookIn.SetTables(Value: Boolean);
begin
  FTables := Value;
end;

function TibBTLookIn.GetConstraints: Boolean;
begin
  Result := FConstraints;
end;

procedure TibBTLookIn.SetConstraints(Value: Boolean);
begin
  FConstraints := Value;
end;

function TibBTLookIn.GetIndices: Boolean;
begin
  Result := FIndices;
end;

procedure TibBTLookIn.SetIndices(Value: Boolean);
begin
  FIndices := Value;
end;

function TibBTLookIn.GetViews: Boolean;
begin
  Result := FViews;
end;

procedure TibBTLookIn.SetViews(Value: Boolean);
begin
  FViews := Value;
end;

function TibBTLookIn.GetProcedures: Boolean;
begin
  Result := FProcedures;
end;

procedure TibBTLookIn.SetProcedures(Value: Boolean);
begin
  FProcedures := Value;
end;

function TibBTLookIn.GetTriggers: Boolean;
begin
  Result := FTriggers;
end;

procedure TibBTLookIn.SetTriggers(Value: Boolean);
begin
  FTriggers := Value;
end;

function TibBTLookIn.GetGenerators: Boolean;
begin
  Result := FGenerators;
end;

procedure TibBTLookIn.SetGenerators(Value: Boolean);
begin
  FGenerators := Value;
end;

function TibBTLookIn.GetExceptions: Boolean;
begin
  Result := FExceptions;
end;

procedure TibBTLookIn.SetExceptions(Value: Boolean);
begin
  FExceptions := Value;
end;

function TibBTLookIn.GetFunctions: Boolean;
begin
  Result := FFunctions;
end;

procedure TibBTLookIn.SetFunctions(Value: Boolean);
begin
  FFunctions := Value;
end;

function TibBTLookIn.GetFilters: Boolean;
begin
  Result := FFilters;
end;

procedure TibBTLookIn.SetFilters(Value: Boolean);
begin
  FFilters := Value;
end;

function TibBTLookIn.GetRoles: Boolean;
begin
  Result := FRoles;
end;

procedure TibBTLookIn.SetRoles(Value: Boolean);
begin
  FRoles := Value;
end;

initialization

  Register;

end.

