unit ibSHDriver_IBX;

interface

uses
  // Native Modules
  SysUtils, Classes, StrUtils,
  // SQLHammer Modules
  SHDesignIntf, ibSHDesignIntf, ibSHDriverIntf,
  // IBX Modules
  IB, IBSQLMonitor;

type
  TibBTDriver = class(TSHComponent, IibSHDRV)
  private
    FNativeDAC: TObject;
    FErrorText: string;
    function GetNativeDAC: TObject;
    procedure SetNativeDAC(Value: TObject);
    function GetErrorText: string;
    procedure SetErrorText(Value: string);
  public
    property NativeDAC: TObject read GetNativeDAC write SetNativeDAC;
    property ErrorText: string read GetErrorText write SetErrorText;
  end;

  TibBTDRVMonitor = class(TibBTDriver, IibSHDRVMonitor)
  private
    FIBXMonitor: TIBSQLMonitor;

    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetTracePrepare: Boolean;
    procedure SetTracePrepare(Value: Boolean);
    function GetTraceExecute: Boolean;
    procedure SetTraceExecute(Value: Boolean);
    function GetTraceFetch: Boolean;
    procedure SetTraceFetch(Value: Boolean);
    function GetTraceConnect: Boolean;
    procedure SetTraceConnect(Value: Boolean);
    function GetTraceTransact: Boolean;
    procedure SetTraceTransact(Value: Boolean);
    function GetTraceService: Boolean;
    procedure SetTraceService(Value: Boolean);
    function GetTraceStmt: Boolean;
    procedure SetTraceStmt(Value: Boolean);
    function GetTraceError: Boolean;
    procedure SetTraceError(Value: Boolean);
    function GetTraceBlob: Boolean;
    procedure SetTraceBlob(Value: Boolean);
    function GetTraceMisc: Boolean;
    procedure SetTraceMisc(Value: Boolean);
    function GetOnSQL: TibSHOnSQLNotify;
    procedure SetOnSQL(Value: TibSHOnSQLNotify);
  protected
    property IBXMonitor: TIBSQLMonitor read FIBXMonitor;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function GetClassIIDClassFnc: TGUID; override;

    property Active: Boolean read GetActive write SetActive;
    property TracePrepare: Boolean read GetTracePrepare write SetTracePrepare;
    property TraceExecute: Boolean read GetTraceExecute write SetTraceExecute;
    property TraceFetch: Boolean read GetTraceFetch write SetTraceFetch;
    property TraceConnect: Boolean read GetTraceConnect write SetTraceConnect;
    property TraceTransact: Boolean read GetTraceTransact write SetTraceTransact;
    property TraceService: Boolean read GetTraceService write SetTraceService;
    property TraceStmt: Boolean read GetTraceStmt write SetTraceStmt;
    property TraceError: Boolean read GetTraceError write SetTraceError;
    property TraceBlob: Boolean read GetTraceBlob write SetTraceBlob;
    property TraceMisc: Boolean read GetTraceMisc write SetTraceMisc;
    property OnSQL: TibSHOnSQLNotify read GetOnSQL write SetOnSQL;
  end;

implementation

{ TibBTDriver }

function TibBTDriver.GetNativeDAC: TObject;
begin
  Result := FNativeDAC;
end;

procedure TibBTDriver.SetNativeDAC(Value: TObject);
begin
  FNativeDAC := Value;
end;

function TibBTDriver.GetErrorText: string;
begin
  Result := FErrorText;
end;

procedure TibBTDriver.SetErrorText(Value: string);
  function FormatErrorMessage(const E: string): string;
  begin
    Result := AnsiReplaceText(E, ':' + sLineBreak, '');
    Result := AnsiReplaceText(Result, sLineBreak, '');
  end;
begin
  FErrorText := FormatErrorMessage(Value);
end;

{ TibBTDRVMonitor }

constructor TibBTDRVMonitor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIBXMonitor := TIBSQLMonitor.Create(nil);
  NativeDAC := FIBXMonitor;
  FIBXMonitor.Enabled := False;
//  FIBXMonitor.Enabled := True;

  FIBXMonitor.TraceFlags := [];
end;

destructor TibBTDRVMonitor.Destroy;
begin
  FIBXMonitor.Free;
  inherited Destroy;
end;

class function TibBTDRVMonitor.GetClassIIDClassFnc: TGUID;
begin
  Result := IibSHDRVMonitor_IBX;
end;

function TibBTDRVMonitor.GetActive: Boolean;
begin
  Result := FIBXMonitor.Enabled;
end;

procedure TibBTDRVMonitor.SetActive(Value: Boolean);
begin
  FIBXMonitor.Enabled := Value;
end;

function TibBTDRVMonitor.GetTracePrepare: Boolean;
begin
  Result := tfQPrepare in FIBXMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTracePrepare(Value: Boolean);
begin
  if Value then
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags + [tfQPrepare]
  else
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags - [tfQPrepare];
end;

function TibBTDRVMonitor.GetTraceExecute: Boolean;
begin
  Result := tfQExecute in FIBXMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceExecute(Value: Boolean);
begin
  if Value then
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags + [tfQExecute]
  else
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags - [tfQExecute];
end;

function TibBTDRVMonitor.GetTraceFetch: Boolean;
begin
  Result := tfQFetch in FIBXMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceFetch(Value: Boolean);
begin
  if Value then
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags + [tfQFetch]
  else
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags - [tfQFetch];
end;

function TibBTDRVMonitor.GetTraceConnect: Boolean;
begin
  Result := tfConnect in FIBXMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceConnect(Value: Boolean);
begin
  if Value then
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags + [tfConnect]
  else
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags - [tfConnect];
end;

function TibBTDRVMonitor.GetTraceTransact: Boolean;
begin
  Result := tfTransact in FIBXMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceTransact(Value: Boolean);
begin
  if Value then
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags + [tfTransact]
  else
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags - [tfTransact];
end;

function TibBTDRVMonitor.GetTraceService: Boolean;
begin
  Result := tfService in FIBXMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceService(Value: Boolean);
begin
  if Value then
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags + [tfService]
  else
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags - [tfService];
end;

function TibBTDRVMonitor.GetTraceStmt: Boolean;
begin
  Result := tfStmt in FIBXMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceStmt(Value: Boolean);
begin
  if Value then
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags + [tfStmt]
  else
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags - [tfStmt];
end;

function TibBTDRVMonitor.GetTraceError: Boolean;
begin
  Result := tfError in FIBXMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceError(Value: Boolean);
begin
  if Value then
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags + [tfError]
  else
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags - [tfError];
end;

function TibBTDRVMonitor.GetTraceBlob: Boolean;
begin
  Result := tfBlob in FIBXMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceBlob(Value: Boolean);
begin
  if Value then
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags + [tfBlob]
  else
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags - [tfBlob];
end;

function TibBTDRVMonitor.GetTraceMisc: Boolean;
begin
  Result := tfMisc in FIBXMonitor.TraceFlags;
end;

procedure TibBTDRVMonitor.SetTraceMisc(Value: Boolean);
begin
  if Value then
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags + [tfMisc]
  else
    FIBXMonitor.TraceFlags := FIBXMonitor.TraceFlags - [tfMisc];
end;

function TibBTDRVMonitor.GetOnSQL: TibSHOnSQLNotify;
begin
  Result := FIBXMonitor.OnSQL;
end;

procedure TibBTDRVMonitor.SetOnSQL(Value: TibSHOnSQLNotify);
begin
  FIBXMonitor.OnSQL := Value;
end;

initialization
  SHRegisterComponents([TibBTDRVMonitor]);
end.
