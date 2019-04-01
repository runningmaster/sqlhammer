unit ibSHDDLParser;

interface

uses
  SysUtils, Classes, Types,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDriverIntf, ibSHComponent;

type
  TibBTDDLParser = class(TibBTComponent, IibSHDDLParser)
  private
    FDRVSQLParser: TComponent;
    FDRVSQLParserIntf: IibSHDRVSQLParser;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    {IibSHDDLParser}
    function GetCount: Integer;
    function GetStatements(Index: Integer): string;
    function GetSQLParserNotification: IibSHDRVSQLParserNotification;
    procedure SetSQLParserNotification(Value: IibSHDRVSQLParserNotification);
    function GetErrorText: string;
    function GetErrorLine: Integer;
    function GetErrorColumn: Integer;

    function Parse(const DDLText: string): Boolean;
    function StatementState(const Index: Integer): TSHDBComponentState;
    function StatementObjectType(const Index: Integer): TGUID;
    function StatementObjectName(const Index: Integer): string;
    function StatementsCoord(Index: Integer): TRect;
    function IsDataSQL(Index: Integer): Boolean;

    property DRVSQLParser: IibSHDRVSQLParser read FDRVSQLParserIntf;
  end;

implementation

{ TibBTDDLParser }

constructor TibBTDDLParser.Create(AOwner: TComponent);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner);
  vComponentClass := Designer.GetComponent(IibSHDRVSQLParser_FIBPlus);
  if Assigned(vComponentClass) then
  begin
    FDRVSQLParser := vComponentClass.Create(nil);
    Supports(FDRVSQLParser, IibSHDRVSQLParser, FDRVSQLParserIntf);
  end;
  Assert(Assigned(DRVSQLParser), 'DRVSQLParser = nil');
end;

destructor TibBTDDLParser.Destroy;
begin
  FDRVSQLParserIntf := nil;
  FDRVSQLParser.Free;
  inherited Destroy;
end;

function TibBTDDLParser.GetCount: Integer;
begin
  Result := DRVSQLParser.Count;
end;

function TibBTDDLParser.GetStatements(Index: Integer): string;
begin
//  Result := DRVSQLParser.Statements;
  Result := DRVSQLParser.Statements[Index];
end;

function TibBTDDLParser.GetSQLParserNotification: IibSHDRVSQLParserNotification;
begin
  Result := DRVSQLParser.SQLParserNotification;
end;

procedure TibBTDDLParser.SetSQLParserNotification(
  Value: IibSHDRVSQLParserNotification);
begin
  DRVSQLParser.SQLParserNotification := Value;
end;

function TibBTDDLParser.GetErrorText: string;
begin
  Result := DRVSQLParser.ErrorText;
end;

function TibBTDDLParser.GetErrorLine: Integer;
begin
  Result := -1;
end;

function TibBTDDLParser.GetErrorColumn: Integer;
begin
  Result := -1;
end;

function TibBTDDLParser.Parse(const DDLText: string): Boolean;
begin
  Result := DRVSQLParser.Parse(DDLText);
end;

function TibBTDDLParser.StatementState(const Index: Integer): TSHDBComponentState;
begin
  Result := DRVSQLParser.StatementState(Index);
end;

function TibBTDDLParser.StatementObjectType(const Index: Integer): TGUID;
begin
  Result := DRVSQLParser.StatementObjectType(Index);
end;

function TibBTDDLParser.StatementObjectName(const Index: Integer): string;
begin
  Result := DRVSQLParser.StatementObjectName(Index);
end;

function TibBTDDLParser.StatementsCoord(Index: Integer): TRect;
begin
  Result := DRVSQLParser.StatementsCoord(Index);
end;

function TibBTDDLParser.IsDataSQL(Index: Integer): Boolean;
begin
  Result := DRVSQLParser.IsDataSQL(Index);
end;

end.
