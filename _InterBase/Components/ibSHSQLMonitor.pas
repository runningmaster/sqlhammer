unit ibSHSQLMonitor;

interface

uses
  SysUtils, Classes, StrUtils,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDriverIntf, ibSHTool;

type
  TibSHSQLMonitor = class(TibBTTool, IibSHSQLMonitor)
  private
    FActive: Boolean;
    FPrepare: Boolean;
    FExecute: Boolean;
    FFetch: Boolean;
    FConnect: Boolean;
    FTransact: Boolean;
    FService: Boolean;
    FStmt: Boolean;
    FError: Boolean;
    FBlob: Boolean;
    FMisc: Boolean;
    FFilter: TStrings;
    FOnEvent: TibSHSQLMonitorEvent;
    FFIBMonitor: TComponent;
    FIBXMonitor: TComponent;
    FFIBMonitorIntf: IibSHDRVMonitor;
    FIBXMonitorIntf: IibSHDRVMonitor;
  protected
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetPrepare: Boolean;
    procedure SetPrepare(Value: Boolean);
    function GetExecute: Boolean;
    procedure SetExecute(Value: Boolean);
    function GetFetch: Boolean;
    procedure SetFetch(Value: Boolean);
    function GetConnect: Boolean;
    procedure SetConnect(Value: Boolean);
    function GetTransact: Boolean;
    procedure SetTransact(Value: Boolean);
    function GetService: Boolean;
    procedure SetService(Value: Boolean);
    function GetStmt: Boolean;
    procedure SetStmt(Value: Boolean);
    function GetError: Boolean;
    procedure SetError(Value: Boolean);
    function GetBlob: Boolean;
    procedure SetBlob(Value: Boolean);
    function GetMisc: Boolean;
    procedure SetMisc(Value: Boolean);
    function GetFilter: TStrings;
    procedure SetFilter(Value: TStrings);
    function GetOnEvent: TibSHSQLMonitorEvent;
    procedure SetOnEvent(Value: TibSHSQLMonitorEvent);

    procedure OnFIBSQL(EventText: String; EventTime: TDateTime);
    procedure OnIBXSQL(EventText: String; EventTime: TDateTime);
    procedure AddEvent(EventText: String; EventTime: TDateTime);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property FIBMonitor: IibSHDRVMonitor read FFIBMonitorIntf;
    property IBXMonitor: IibSHDRVMonitor read FIBXMonitorIntf;
    property Active: Boolean read GetActive write SetActive;
    property OnEvent: TibSHSQLMonitorEvent read FOnEvent write FOnEvent;

    property Prepare: Boolean read GetPrepare write SetPrepare;
    property Execute: Boolean read GetExecute write SetExecute;
    property Fetch: Boolean read GetFetch write SetFetch;
    property Connect: Boolean read GetConnect write SetConnect;
    property Transact: Boolean read GetTransact write SetTransact;
    property Service: Boolean read GetService write SetService;
    property Stmt: Boolean read GetStmt write SetStmt;
    property Error: Boolean read GetError write SetError;
    property Blob: Boolean read GetBlob write SetBlob;
    property Misc: Boolean read GetMisc write SetMisc;
    property Filter: TStrings read GetFilter write SetFilter;
  end;

  TibSHFIBMonitor = class(TibSHSQLMonitor, IibSHFIBMonitor, IibSHBranch, IfbSHBranch)
  published
    property Prepare;
    property Execute;
    property Fetch;
    property Connect;
    property Transact;
    property Service;
//    property Stmt;
//    property Error;
//    property Blob;
    property Misc;
    property Filter;
  end;

  TibSHIBXMonitor = class(TibSHSQLMonitor, IibSHIBXMonitor, IibSHBranch, IfbSHBranch)
  published
    property Prepare;
    property Execute;
    property Fetch;
    property Connect;
    property Transact;
    property Service;
    property Stmt;
    property Error;
    property Blob;
    property Misc;
    property Filter;    
  end;

  TibSHSQLMonitorFactory = class(TibBTToolFactory)
  end;

procedure Register;

implementation

uses
  ibSHConsts, ibSHSQLs,
  ibSHSQLMonitorActions,
  ibSHSQLMonitorEditors;

procedure Register;
begin
  SHRegisterImage(GUIDToString(IibSHSQLMonitor), 'SQLMonitor.bmp');
  SHRegisterImage(GUIDToString(IibSHFIBMonitor), 'SQLMonitorFIB.bmp');
  SHRegisterImage(GUIDToString(IibSHIBXMonitor), 'SQLMonitorIBX.bmp');

  SHRegisterImage(TibSHSQLMonitorPaletteAction_FIB.ClassName,    'SQLMonitorFIB.bmp');
  SHRegisterImage(TibSHSQLMonitorPaletteAction_IBX.ClassName,    'SQLMonitorIBX.bmp');
  SHRegisterImage(TibSHSQLMonitorFormAction.ClassName,           'Form_SQLText.bmp');
  SHRegisterImage(TibSHSQLMonitorToolbarAction_Run.ClassName,    'Button_Run.bmp');
  SHRegisterImage(TibSHSQLMonitorToolbarAction_Pause.ClassName,  'Button_Stop.bmp');
  SHRegisterImage(TibSHSQLMonitorToolbarAction_Region.ClassName, 'Button_Tree.bmp');
  SHRegisterImage(TibSHSQLMonitorToolbarAction_2App.ClassName,   'Button_Arrow_Right.bmp');

  SHRegisterImage(SCallFIBTrace, 'Form_SQLText.bmp');
  SHRegisterImage(SCallIBXTrace, 'Form_SQLText.bmp');

  SHRegisterComponents([
    TibSHFIBMonitor,
    TibSHIBXMonitor,
    TibSHSQLMonitorFactory]);

  SHRegisterActions([
    // Palette
    TibSHSQLMonitorPaletteAction_FIB,
    TibSHSQLMonitorPaletteAction_IBX,
    // Forms
    TibSHSQLMonitorFormAction,
    // Toolbars
    TibSHSQLMonitorToolbarAction_Run,
    TibSHSQLMonitorToolbarAction_Pause,
    TibSHSQLMonitorToolbarAction_Region,
    TibSHSQLMonitorToolbarAction_2App]);

  SHRegisterPropertyEditor(IibSHFIBMonitor, SCallFilter, TibSHSQLMonitorFilterPropEditor);
  SHRegisterPropertyEditor(IibSHIBXMonitor, SCallFilter, TibSHSQLMonitorFilterPropEditor);
end;

{ TibSHSQLMonitor }

constructor TibSHSQLMonitor.Create(AOwner: TComponent);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner);
  FFilter := TStringList.Create;

  if Supports(Self, IibSHFIBMonitor) then
  begin
    vComponentClass := Designer.GetComponent(IibSHDRVMonitor_FIBPlus);
    if Assigned(vComponentClass) then
    begin
      FFIBMonitor := vComponentClass.Create(nil);
      Supports(FFIBMonitor, IibSHDRVMonitor, FFIBMonitorIntf);
    end;
  end;

  if Supports(Self, IibSHIBXMonitor) then
  begin
    vComponentClass := Designer.GetComponent(IibSHDRVMonitor_IBX);
    if Assigned(vComponentClass) then
    begin
      FIBXMonitor := vComponentClass.Create(nil);
      Supports(FIBXMonitor, IibSHDRVMonitor, FIBXMonitorIntf);
    end;
  end;

  if Assigned(FIBMonitor) then FIBMonitor.OnSQL := OnFIBSQL;
  if Assigned(IBXMonitor) then IBXMonitor.OnSQL := OnIBXSQL;

  Execute := True;
  Connect := True;
  Transact := True;
end;

destructor TibSHSQLMonitor.Destroy;
begin
  FFilter.Free;
  Active := False;
  FFIBMonitorIntf := nil;
  FIBXMonitorIntf := nil;
  FFIBMonitor.Free;
  FIBXMonitor.Free;
  inherited Destroy;
end;

function TibSHSQLMonitor.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure TibSHSQLMonitor.SetActive(Value: Boolean);
begin
  FActive := Value;
  if Assigned(FIBMonitor) then FIBMonitor.Active := FActive;
  if Assigned(IBXMonitor) then IBXMonitor.Active := FActive;
end;

function TibSHSQLMonitor.GetPrepare: Boolean;
begin
  Result := FPrepare;
end;

procedure TibSHSQLMonitor.SetPrepare(Value: Boolean);
begin
  FPrepare := Value;
  if Assigned(FIBMonitor) then FIBMonitor.TracePrepare := FPrepare;
  if Assigned(IBXMonitor) then IBXMonitor.TracePrepare := FPrepare;
end;

function TibSHSQLMonitor.GetExecute: Boolean;
begin
  Result := FExecute;
end;

procedure TibSHSQLMonitor.SetExecute(Value: Boolean);
begin
  FExecute := Value;
  if Assigned(FIBMonitor) then FIBMonitor.TraceExecute := FExecute;
  if Assigned(IBXMonitor) then IBXMonitor.TraceExecute := FExecute;
end;

function TibSHSQLMonitor.GetFetch: Boolean;
begin
  Result := FFetch;
end;

procedure TibSHSQLMonitor.SetFetch(Value: Boolean);
begin
  FFetch := Value;
  if Assigned(FIBMonitor) then FIBMonitor.TraceFetch := FFetch;
  if Assigned(IBXMonitor) then IBXMonitor.TraceFetch := FFetch;
end;

function TibSHSQLMonitor.GetConnect: Boolean;
begin
  Result := FConnect;
end;

procedure TibSHSQLMonitor.SetConnect(Value: Boolean);
begin
  FConnect := Value;
  if Assigned(FIBMonitor) then FIBMonitor.TraceConnect := FConnect;
  if Assigned(IBXMonitor) then IBXMonitor.TraceConnect := FConnect;
end;

function TibSHSQLMonitor.GetTransact: Boolean;
begin
  Result := FTransact;
end;

procedure TibSHSQLMonitor.SetTransact(Value: Boolean);
begin
  FTransact := Value;
  if Assigned(FIBMonitor) then FIBMonitor.TraceTransact := FTransact;
  if Assigned(IBXMonitor) then IBXMonitor.TraceTransact := FTransact;
end;

function TibSHSQLMonitor.GetService: Boolean;
begin
  Result := FService;
end;

procedure TibSHSQLMonitor.SetService(Value: Boolean);
begin
  FService := Value;
  if Assigned(FIBMonitor) then FIBMonitor.TraceService := FService;
  if Assigned(IBXMonitor) then IBXMonitor.TraceService := FService;
end;

function TibSHSQLMonitor.GetStmt: Boolean;
begin
  Result := FStmt;
end;

procedure TibSHSQLMonitor.SetStmt(Value: Boolean);
begin
  FStmt := Value;
  if Assigned(FIBMonitor) then FIBMonitor.TraceStmt := FStmt;
  if Assigned(IBXMonitor) then IBXMonitor.TraceStmt := FStmt;
end;

function TibSHSQLMonitor.GetError: Boolean;
begin
  Result := FError;
end;

procedure TibSHSQLMonitor.SetError(Value: Boolean);
begin
  FError := Value;
  if Assigned(FIBMonitor) then FIBMonitor.TraceError := FError;
  if Assigned(IBXMonitor) then IBXMonitor.TraceError := FError;
end;

function TibSHSQLMonitor.GetBlob: Boolean;
begin
  Result := FBlob;
end;

procedure TibSHSQLMonitor.SetBlob(Value: Boolean);
begin
  FBlob := Value;
  if Assigned(FIBMonitor) then FIBMonitor.TraceBlob := FBlob;
  if Assigned(IBXMonitor) then IBXMonitor.TraceBlob := FBlob;
end;

function TibSHSQLMonitor.GetMisc: Boolean;
begin
  Result := FMisc;
end;

procedure TibSHSQLMonitor.SetMisc(Value: Boolean);
begin
  FMisc := Value;
  if Assigned(FIBMonitor) then FIBMonitor.TraceMisc := FMisc;
  if Assigned(IBXMonitor) then IBXMonitor.TraceMisc := FMisc;
end;

function TibSHSQLMonitor.GetFilter: TStrings;
begin
  Result := FFilter;
end;

procedure TibSHSQLMonitor.SetFilter(Value: TStrings);
begin
  FFilter.Assign(Value);
end;

function TibSHSQLMonitor.GetOnEvent: TibSHSQLMonitorEvent;
begin
  Result := FOnEvent;
end;

procedure TibSHSQLMonitor.SetOnEvent(Value: TibSHSQLMonitorEvent);
begin
  FOnEvent := Value;
end;

procedure TibSHSQLMonitor.OnFIBSQL(EventText: String; EventTime: TDateTime);
begin
  AddEvent(EventText, EventTime);
end;

procedure TibSHSQLMonitor.OnIBXSQL(EventText: String; EventTime: TDateTime);
begin
  AddEvent(EventText, EventTime);
end;

procedure TibSHSQLMonitor.AddEvent(EventText: String; EventTime: TDateTime);
var
  vAppName, vOperation, vObject, vSQL: string;
begin
  if Active then
  begin

    vAppName := Trim(Copy(EventText, Pos(':', EventText) + 2, Pos(']', EventText) - Length('[Application: ') - 3));
    if Pos('.exe', vAppName) <> Length(vAppName) - 4 then vAppName := AnsiReplaceText(vAppName, '.exe', '');
    vObject := Trim(Copy(EventText, Pos(']', EventText) + 1, PosEx(':', EventText, (Pos(']', EventText))) - Pos(']', EventText) - 1));
    vOperation := Trim(Copy(EventText, PosEx(':', EventText, Pos(':', EventText) + 1) + 3, (PosEx(']', EventText, Pos(']', EventText) + 1)) - (PosEx('[', EventText, Pos('[', EventText) + 1)) - 1 ));

    vSQL := Trim(Copy(EventText, {|} PosEx(']', EventText, Pos(']', EventText) + 1) + 1, {|} MaxInt));

//    if Length(vObject) = 0 then vObject := Format('%s.InternalComponent', [vAppName]);
    if Assigned(FOnEvent) then
      FOnEvent(vAppName, vOperation, vObject,
        FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', EventTime),
        FormatDateTime('hh:nn:ss.zzz', EventTime),
        vSQL);
  end;
end;

initialization

  Register;

end.

