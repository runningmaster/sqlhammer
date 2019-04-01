unit ibSHTool;

interface

uses
  SysUtils, Classes,
  SHDesignIntf, SHOptionsIntf,
  ibSHDesignIntf, ibSHConsts, ibSHComponent;

type
  TibBTTool = class(TibBTComponent, IibSHTool)
  private
  protected
    FBTCLServerIntf: IibSHServer;
    FBTCLDatabaseIntf: IibSHDatabase;
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
    function GetBTCLServer: IibSHServer;
    function GetBTCLDatabase: IibSHDatabase;

    function GetBranchIID: TGUID; override;
    function GetCaption: string; override;
    function GetCaptionExt: string; override;
    function GetCaptionPath: string; override;
    procedure SetOwnerIID(Value: TGUID); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function GetHintClassFnc: string; override;
    class function GetAssociationClassFnc: string; override;

    { properties }
    property BTCLServer: IibSHServer read GetBTCLServer;
    property BTCLDatabase: IibSHDatabase read GetBTCLDatabase;
  end;

  TibBTToolFactory = class(TibBTComponentFactory)
  private
    procedure CheckStart(const AOwnerIID, AClassIID: TGUID);
    function GetWantedOwnerIID(const AClassIID: TGUID): TGUID;
  protected
    procedure DoBeforeChangeNotification(var ACallString: string;
      AComponent: TSHComponent); virtual;
  public
    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    function CreateComponent(const AOwnerIID, AClassIID: TGUID;
      const ACaption: string): TSHComponent; override;
  end;

implementation

uses
  ibSHValues, ibSHMessages;

{ TibBTTool }

constructor TibBTTool.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TibBTTool.Destroy;
begin
  inherited Destroy;
end;

class function TibBTTool.GetHintClassFnc: string;
begin
  Result := inherited GetHintClassFnc;

  if Supports(Self, IibSHSQLEditor) then Result := SClassHintSQLEditor
  else
  if Supports(Self, IibSHDMLHistory) then Result := SClassHintDMLHistory
  else
  if Supports(Self, IibSHDDLHistory) then Result := SClassHintDDLHistory
  else
  if Supports(Self, IibSHSQLPerformance) then Result := SClassHintSQLPerformance
  else
  if Supports(Self, IibSHSQLPlan) then Result := SClassHintSQLPlan
  else
  if Supports(Self, IibSHSQLPlayer) then Result := SClassHintSQLPlayer
  else
  if Supports(Self, IibSHDMLExporter) then Result := SClassHintDMLExporter
  else
  if Supports(Self, IibSHFIBMonitor) then Result := SClassHintFIBMonitor
  else
  if Supports(Self, IibSHIBXMonitor) then Result := SClassHintIBXMonitor
  else
  if Supports(Self, IibSHDDLGrantor) then Result := SClassHintDDLGrantor
  else
  if Supports(Self, IibSHUserManager) then Result := SClassHintUserManager
  else
  if Supports(Self, IibSHDDLCommentator) then Result := SClassHintDDLCommentator
  else
  if Supports(Self, IibSHDDLDocumentor) then Result := SClassHintDDLDocumentor
  else
  if Supports(Self, IibSHDDLFinder) then Result := SClassHintDDLFinder
  else
  if Supports(Self, IibSHDDLExtractor) then Result := SClassHintDDLExtractor
  else
  if Supports(Self, IibSHTXTLoader) then Result := SClassHintTXTLoader
  else
  if Supports(Self, IibSHBlobEditor) then Result := SClassHintBlobEditor
  else
  if Supports(Self, IibSHDDLDocumentor) then Result := SClassHintDDLDocumentor
  else
  if Supports(Self, IibSHReportManager) then Result := SClassHintReportManager
  else
  if Supports(Self, IibSHDataGenerator) then Result := SClassHintDataGenerator
  else
  if Supports(Self, IibSHDBComparer) then Result := SClassHintDBComparer
  else
  if Supports(Self, IibSHSecondaryFiles) then Result := SClassHintSecondaryFiles
  else
  if Supports(Self, IibSHCVSExchanger) then Result := SClassHintCVSExchanger
  else
  if Supports(Self, IibSHDBDesigner) then Result := SClassHintDBDesigner
  else
  if Supports(Self, IibSHPSQLDebugger) then Result := SClassHintPSQLDebugger
  else
  // Services
  if Supports(Self, IibSHServerProps) then Result := SClassHintServerProps
  else
  if Supports(Self, IibSHServerLog) then Result := SClassHintServerLog
  else
  if Supports(Self, IibSHServerConfig) then Result := SClassHintServerConfig
  else
  if Supports(Self, IibSHServerLicense) then Result := SClassHintServerLicense
  else
  if Supports(Self, IibSHDatabaseShutdown) then Result := SClassHintDatabaseShutdown
  else
  if Supports(Self, IibSHDatabaseOnline) then Result := SClassHintDatabaseOnline
  else
  if Supports(Self, IibSHDatabaseBackup) then Result := SClassHintDatabaseBackup
  else
  if Supports(Self, IibSHDatabaseRestore) then Result := SClassHintDatabaseRestore
  else
  if Supports(Self, IibSHDatabaseStatistics) then Result := SClassHintDatabaseStatistics
  else
  if Supports(Self, IibSHDatabaseValidation) then Result := SClassHintDatabaseValidation
  else
  if Supports(Self, IibSHDatabaseSweep) then Result := SClassHintDatabaseSweep
  else
  if Supports(Self, IibSHDatabaseMend) then Result := SClassHintDatabaseMend
  else
  if Supports(Self, IibSHTransactionRecovery) then Result := SClassHintTransactionRecovery
  else
  if Supports(Self, IibSHDatabaseProps) then Result := SClassHintDatabaseProps;
end;

class function TibBTTool.GetAssociationClassFnc: string;
begin
  Result := inherited GetAssociationClassFnc;

  if Supports(Self, IibSHSQLEditor) then Result := SClassAssocSQLEditor;
  if Supports(Self, IibSHDMLHistory) then Result := SClassAssocDMLHistory;
  if Supports(Self, IibSHDDLHistory) then Result := SClassAssocDDLHistory;
  if Supports(Self, IibSHSQLPerformance) then Result := SClassAssocSQLPerformance;
  if Supports(Self, IibSHSQLPlan) then Result := SClassAssocSQLPlan;
  if Supports(Self, IibSHSQLPlayer) then Result := SClassAssocSQLPlayer;
  if Supports(Self, IibSHDMLExporter) then Result := SClassAssocDMLExporter;
  if Supports(Self, IibSHFIBMonitor) then Result := SClassAssocFIBMonitor;
  if Supports(Self, IibSHIBXMonitor) then Result := SClassAssocIBXMonitor;
  if Supports(Self, IibSHDDLGrantor) then Result := SClassAssocDDLGrantor;
  if Supports(Self, IibSHUserManager) then Result := SClassAssocUserManager;
  if Supports(Self, IibSHDDLCommentator) then Result := SClassAssocDDLCommentator;
  if Supports(Self, IibSHDDLDocumentor) then Result := SClassAssocDDLDocumentor;
  if Supports(Self, IibSHDDLFinder) then Result := SClassAssocDDLFinder;
  if Supports(Self, IibSHDDLExtractor) then Result := SClassAssocDDLExtractor;
  if Supports(Self, IibSHTXTLoader) then Result := SClassAssocTXTLoader;
  if Supports(Self, IibSHBlobEditor) then Result := SClassAssocBlobEditor;
  if Supports(Self, IibSHDDLDocumentor) then Result := SClassAssocDDLDocumentor;
  if Supports(Self, IibSHReportManager) then Result := SClassAssocReportManager;
  if Supports(Self, IibSHDataGenerator) then Result := SClassAssocDataGenerator;
  if Supports(Self, IibSHDBComparer) then Result := SClassAssocDBComparer;
  if Supports(Self, IibSHSecondaryFiles) then Result := SClassAssocSecondaryFiles;
  if Supports(Self, IibSHCVSExchanger) then Result := SClassAssocCVSExchanger;
  if Supports(Self, IibSHDBDesigner) then Result := SClassAssocDBDesigner;
  if Supports(Self, IibSHPSQLDebugger) then Result := SClassAssocPSQLDebugger;

  // Services
  if Supports(Self, IibSHServerProps) then Result := SClassAssocServerProps;
  if Supports(Self, IibSHServerLog) then Result := SClassAssocServerLog;
  if Supports(Self, IibSHServerConfig) then Result := SClassAssocServerConfig;
  if Supports(Self, IibSHServerLicense) then Result := SClassAssocServerLicense;
  if Supports(Self, IibSHDatabaseShutdown) then Result := SClassAssocDatabaseShutdown;
  if Supports(Self, IibSHDatabaseOnline) then Result := SClassAssocDatabaseOnline;
  if Supports(Self, IibSHDatabaseBackup) then Result := SClassAssocDatabaseBackup;
  if Supports(Self, IibSHDatabaseRestore) then Result := SClassAssocDatabaseRestore;
  if Supports(Self, IibSHDatabaseStatistics) then Result := SClassAssocDatabaseStatistics;
  if Supports(Self, IibSHDatabaseValidation) then Result := SClassAssocDatabaseValidation;
  if Supports(Self, IibSHDatabaseSweep) then Result := SClassAssocDatabaseSweep;
  if Supports(Self, IibSHDatabaseMend) then Result := SClassAssocDatabaseMend;
  if Supports(Self, IibSHTransactionRecovery) then Result := SClassAssocTransactionRecovery;
  if Supports(Self, IibSHDatabaseProps) then Result := SClassAssocDatabaseProps;
end;

function TibBTTool.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if IsEqualGUID(IID, IibSHDatabase) then
  begin
    IInterface(Obj) := FBTCLDatabaseIntf;
    if Pointer(Obj) <> nil then
      Result := S_OK
    else
      Result := E_NOINTERFACE;
  end else
    Result := inherited QueryInterface(IID, Obj);
end;

function TibBTTool.GetBTCLServer: IibSHServer;
begin
  Result := FBTCLServerIntf;
end;

function TibBTTool.GetBTCLDatabase: IibSHDatabase;
begin
  Result := FBTCLDatabaseIntf;
end;

function TibBTTool.GetBranchIID: TGUID;
begin
  Result := inherited GetBranchIID;
  if not Assigned(BTCLDatabase) then
  begin
    if Assigned(Designer.FindComponent(OwnerIID)) then
      Result := Designer.FindComponent(OwnerIID).BranchIID;
  end else
    Result := BTCLDatabase.BranchIID;
end;

function TibBTTool.GetCaption: string;
begin
  Result := inherited GetCaption;
end;
{

begin

  
  if Assigned(BTCLDatabase) and not SHSystemOptions.UseWorkspaces then
    Result := Format('%s : %s', [Caption, BTCLDatabase.Alias]);

}
function TibBTTool.GetCaptionExt: string;
var
  SHSystemOptions: ISHSystemOptions;
begin
  Result := Format('%s', [Caption]);

  Supports(Designer.GetOptions(ISHSystemOptions), ISHSystemOptions, SHSystemOptions);
  if Assigned(BTCLDatabase) and Assigned(SHSystemOptions) and not SHSystemOptions.UseWorkspaces then
    Result := Format('%s : %s', [Result, BTCLDatabase.Alias]);

//  if Supports(Self, IibSHUserManager) then
//  begin
//    if Assigned(BTCLServer) and Assigned(SHSystemOptions) and not SHSystemOptions.UseWorkspaces then
//      Result := Format('%s : %s', [Caption, BTCLServer.Alias]);
//    if Assigned(BTCLDatabase) and Assigned(SHSystemOptions) and not SHSystemOptions.UseWorkspaces then
//      Result := Format('%s : %s', [Result, BTCLDatabase.Alias]);
//  end;

//  if Supports(Self, IibSHService) then
//    if Assigned(BTCLServer) and Assigned(SHSystemOptions) and not SHSystemOptions.UseWorkspaces  then
//      Result := Format('%s : %s', [Caption, BTCLServer.Alias]);

  if Supports(Self, IibSHSQLPlayer) then
  begin
    if Assigned(BTCLDatabase) and Assigned(SHSystemOptions) and not SHSystemOptions.UseWorkspaces  then
      Result := Format('%s : %s', [Caption, BTCLDatabase.Alias]);
//    if Assigned(BTCLServer) and Assigned(SHSystemOptions) and not SHSystemOptions.UseWorkspaces  then
//      Result := Format('%s : %s', [Caption, BTCLServer.Alias]);
  end;

  SHSystemOptions := nil;
end;

function TibBTTool.GetCaptionPath: string;
var
  BranchName, ServerAlias, DatabaseAlias: string;
begin
  if IsEqualGUID(BranchIID, IibSHBranch) then BranchName := SSHInterBaseBranch
  else
  if IsEqualGUID(BranchIID, IfbSHBranch) then BranchName := SSHFirebirdBranch;

  ServerAlias := 'ServerAlias';
  DatabaseAlias := 'DatabaseAlias';

  if not (Supports(Self, IibSHFIBMonitor) or Supports(Self, IibSHIBXMonitor) or Supports(Self, IibSHSQLPlayer)) then
  begin
    if Assigned(BTCLDatabase) then
    begin
      DatabaseAlias := BTCLDatabase.Alias;
      if Assigned(BTCLDatabase.BTCLServer) then
        ServerAlias := BTCLDatabase.BTCLServer.Alias;
    end;
    Result := Format('%s\%s\%s\%s', [BranchName, ServerAlias, DatabaseAlias, Self.Caption]);

    if Supports(Self, IibSHUserManager) then
    begin
      if Assigned(BTCLServer) then
        ServerAlias := BTCLServer.Alias;
      if not Assigned(BTCLDatabase) then
        Result := Format('%s\%s\%s', [BranchName, ServerAlias, Self.Caption]);
    end;

    if Supports(Self, IibSHService) then
    begin
      if Assigned(BTCLServer) then
        ServerAlias := BTCLServer.Alias;
      if not Assigned(BTCLDatabase) then
        Result := Format('%s\%s\%s', [BranchName, ServerAlias, Self.Caption]);
    end;
  end else
  if Supports(Self, IibSHSQLPlayer) then
  begin
    if Assigned(BTCLDatabase) then
    begin
      DatabaseAlias := BTCLDatabase.Alias;
      if Assigned(BTCLDatabase.BTCLServer) then
        ServerAlias := BTCLDatabase.BTCLServer.Alias;
      Result := Format('%s\%s\%s\%s', [BranchName, ServerAlias, DatabaseAlias, Self.Caption]);
    end else
    if Assigned(BTCLServer) then
    begin
      ServerAlias := BTCLServer.Alias;
      Result := Format('%s\%s\%s', [BranchName, ServerAlias, Self.Caption]);
    end else
      Result := Format('%s', [Caption]);
  end else
    Result := Format('%s\%s', [BranchName, Self.Caption]);
end;

procedure TibBTTool.SetOwnerIID(Value: TGUID);
begin
  if not (Supports(Self, IibSHFIBMonitor) or Supports(Self, IibSHIBXMonitor) or Supports(Self, IibSHSQLPlayer)) then
  begin
    if not IsEqualGUID(OwnerIID, Value) then
      Supports(Designer.FindComponent(Value), IibSHDatabase, FBTCLDatabaseIntf);

    if Supports(Self, IibSHUserManager) then
    begin
      if Assigned(FBTCLDatabaseIntf) then
        FBTCLServerIntf := FBTCLDatabaseIntf.BTCLServer
      else
        Supports(Designer.FindComponent(Value), IibSHServer, FBTCLServerIntf)
    end;

    if Supports(Self, IibSHService) then
      Supports(Designer.FindComponent(Value), IibSHServer, FBTCLServerIntf)
  end;

  inherited SetOwnerIID(Value);
end;

{ TibBTToolFactory }

procedure TibBTToolFactory.CheckStart(const AOwnerIID, AClassIID: TGUID);
var
  BTCLServer: IibSHServer;
  BTCLDatabase: IibSHDatabase;
begin
  if IsEqualGUID(AClassIID, IibSHFIBMonitor) or IsEqualGUID(AClassIID, IibSHIBXMonitor) then
  begin
  end else
  if IsEqualGUID(AClassIID, IibSHSQLPlayer) then
  begin
    if Assigned(Designer.CurrentServer) then
      Supports(Designer.CurrentServer, IibSHServer, BTCLServer)
    else
      Supports(Designer.CurrentServer, IibSHServer, BTCLServer);

    Supports(Designer.CurrentDatabase, IibSHDatabase, BTCLDatabase);

    if (not Assigned(BTCLServer)) and (not Assigned(BTCLDatabase)) and IsEqualGUID(AOwnerIID, IUnknown) then
      Designer.AbortWithMsg(Format('%s', [SServerIsNotInterBase]));
  end else
  if IsEqualGUID(AClassIID, IibSHUserManager) or
  // Services
     IsEqualGUID(AClassIID, IibSHServerProps) or
     IsEqualGUID(AClassIID, IibSHServerLog) or
     IsEqualGUID(AClassIID, IibSHServerConfig) or
     IsEqualGUID(AClassIID, IibSHServerLicense) or
     IsEqualGUID(AClassIID, IibSHDatabaseShutdown) or
     IsEqualGUID(AClassIID, IibSHDatabaseOnline) or
     IsEqualGUID(AClassIID, IibSHDatabaseBackup) or
     IsEqualGUID(AClassIID, IibSHDatabaseRestore) or
     IsEqualGUID(AClassIID, IibSHDatabaseStatistics) or
     IsEqualGUID(AClassIID, IibSHDatabaseValidation) or
     IsEqualGUID(AClassIID, IibSHDatabaseSweep) or
     IsEqualGUID(AClassIID, IibSHDatabaseMend) or
     IsEqualGUID(AClassIID, IibSHTransactionRecovery) or
     IsEqualGUID(AClassIID, IibSHDatabaseProps) then
  begin
    if Assigned(Designer.CurrentServer) then
      Supports(Designer.CurrentServer, IibSHServer, BTCLServer)
    else
      Supports(Designer.CurrentServer, IibSHServer, BTCLServer);

    if not Assigned(BTCLServer) and IsEqualGUID(AOwnerIID, IUnknown) then
      Designer.AbortWithMsg(Format('%s', [SServerIsNotInterBase]));
  end;

  if IsEqualGUID(AClassIID, IibSHSQLEditor)  or
     IsEqualGUID(AClassIID, IibSHDMLExporter) or
     IsEqualGUID(AClassIID, IibSHDDLGrantor) or
     IsEqualGUID(AClassIID, IibSHDDLCommentator) or
     IsEqualGUID(AClassIID, IibSHDDLDocumentor) or
     IsEqualGUID(AClassIID, IibSHDDLFinder) or
     IsEqualGUID(AClassIID, IibSHDDLExtractor) or
     IsEqualGUID(AClassIID, IibSHTXTLoader) or
     IsEqualGUID(AClassIID, IibSHPSQLDebugger) then
  begin
    Supports(Designer.CurrentDatabase, IibSHDatabase, BTCLDatabase);
    if not Assigned(BTCLDatabase) and IsEqualGUID(AOwnerIID, IUnknown) then
      Designer.AbortWithMsg(Format('%s', [SDatabaseIsNotInterBase]));
  end;
end;

function TibBTToolFactory.GetWantedOwnerIID(const AClassIID: TGUID): TGUID;
begin
  Result := Designer.CurrentBranch.InstanceIID;

  if IsEqualGUID(AClassIID, IibSHFIBMonitor) or IsEqualGUID(AClassIID, IibSHIBXMonitor) then
  begin
  end else
  if IsEqualGUID(AClassIID, IibSHSQLPlayer) then
  begin
    if Assigned(Designer.CurrentDatabase) and Designer.CurrentDatabaseInUse then
    begin
      Result := Designer.CurrentDatabase.InstanceIID
    end else
    begin
      if Assigned(Designer.CurrentServer) then
        Result := Designer.CurrentServer.InstanceIID;
    end;
  end else

  if IsEqualGUID(AClassIID, IibSHSQLEditor)  or
     IsEqualGUID(AClassIID, IibSHDMLHistory) or
     IsEqualGUID(AClassIID, IibSHDMLExporter) or
     IsEqualGUID(AClassIID, IibSHDDLGrantor) or
     IsEqualGUID(AClassIID, IibSHDDLCommentator) or
     IsEqualGUID(AClassIID, IibSHDDLDocumentor) or
     IsEqualGUID(AClassIID, IibSHDDLFinder) or
     IsEqualGUID(AClassIID, IibSHDDLExtractor) or
     IsEqualGUID(AClassIID, IibSHTXTLoader) or
     IsEqualGUID(AClassIID, IibSHPSQLDebugger) then
  begin
    Result := Designer.CurrentDatabase.InstanceIID;
  end;

  // Services
  if IsEqualGUID(AClassIID, IibSHUserManager) or
     IsEqualGUID(AClassIID, IibSHServerProps) or
     IsEqualGUID(AClassIID, IibSHServerLog) or
     IsEqualGUID(AClassIID, IibSHServerConfig) or
     IsEqualGUID(AClassIID, IibSHServerLicense) or
     IsEqualGUID(AClassIID, IibSHDatabaseShutdown) or
     IsEqualGUID(AClassIID, IibSHDatabaseOnline) or
     IsEqualGUID(AClassIID, IibSHDatabaseBackup) or
     IsEqualGUID(AClassIID, IibSHDatabaseRestore) or
     IsEqualGUID(AClassIID, IibSHDatabaseStatistics) or
     IsEqualGUID(AClassIID, IibSHDatabaseValidation) or
     IsEqualGUID(AClassIID, IibSHDatabaseSweep) or
     IsEqualGUID(AClassIID, IibSHDatabaseMend) or
     IsEqualGUID(AClassIID, IibSHTransactionRecovery) or
     IsEqualGUID(AClassIID, IibSHDatabaseProps) then
  begin
//    if Assigned(Designer.CurrentDatabase) then
//      Result := Designer.CurrentDatabase.OwnerIID
//    else
//      Result := Designer.CurrentServer.InstanceIID;
    if Assigned(Designer.CurrentServer) then
      Result := Designer.CurrentServer.InstanceIID;
//    else
//      if Assigned(Designer.CurrentServer) then
//       Result := Designer.CurrentServer.InstanceIID;
  end;
end;

procedure TibBTToolFactory.DoBeforeChangeNotification(
  var ACallString: string; AComponent: TSHComponent);
begin
// Do nothing
end;

function TibBTToolFactory.SupportComponent(const AClassIID: TGUID): Boolean;
begin
    Result :=
      IsEqualGUID(AClassIID, IibSHSQLEditor) or
//      IsEqualGUID(AClassIID, IibSHSQLHistory) or
      IsEqualGUID(AClassIID, IibSHSQLPerformance) or
      IsEqualGUID(AClassIID, IibSHSQLPlan) or
      IsEqualGUID(AClassIID, IibSHSQLPlayer) or
//      IsEqualGUID(AClassIID, IibSHDMLExporter) or
      IsEqualGUID(AClassIID, IibSHFIBMonitor) or
      IsEqualGUID(AClassIID, IibSHIBXMonitor) or
      IsEqualGUID(AClassIID, IibSHDDLGrantor) or
      IsEqualGUID(AClassIID, IibSHUserManager) or
      IsEqualGUID(AClassIID, IibSHDDLCommentator) or
      IsEqualGUID(AClassIID, IibSHDDLDocumentor) or
      IsEqualGUID(AClassIID, IibSHDDLFinder) or
      IsEqualGUID(AClassIID, IibSHDDLExtractor) or
      IsEqualGUID(AClassIID, IibSHTXTLoader) or
      IsEqualGUID(AClassIID, IibSHPSQLDebugger) or
      IsEqualGUID(AClassIID, IibSHBlobEditor) or
      IsEqualGUID(AClassIID, IibSHDDLDocumentor) or
      IsEqualGUID(AClassIID, IibSHReportManager) or
      IsEqualGUID(AClassIID, IibSHDataGenerator) or
      IsEqualGUID(AClassIID, IibSHDBComparer) or
      IsEqualGUID(AClassIID, IibSHSecondaryFiles) or
      IsEqualGUID(AClassIID, IibSHCVSExchanger) or
      IsEqualGUID(AClassIID, IibSHDBDesigner) or
      // Services
      IsEqualGUID(AClassIID, IibSHServerProps) or
      IsEqualGUID(AClassIID, IibSHServerLog) or
      IsEqualGUID(AClassIID, IibSHServerConfig) or
      IsEqualGUID(AClassIID, IibSHServerLicense) or
      IsEqualGUID(AClassIID, IibSHDatabaseShutdown) or
      IsEqualGUID(AClassIID, IibSHDatabaseOnline) or
      IsEqualGUID(AClassIID, IibSHDatabaseBackup) or
      IsEqualGUID(AClassIID, IibSHDatabaseRestore) or
      IsEqualGUID(AClassIID, IibSHDatabaseStatistics) or
      IsEqualGUID(AClassIID, IibSHDatabaseValidation) or
      IsEqualGUID(AClassIID, IibSHDatabaseSweep) or
      IsEqualGUID(AClassIID, IibSHDatabaseMend) or
      IsEqualGUID(AClassIID, IibSHTransactionRecovery) or
      IsEqualGUID(AClassIID, IibSHDatabaseProps);
end;

function TibBTToolFactory.CreateComponent(const AOwnerIID, AClassIID: TGUID;
  const ACaption: string): TSHComponent;
var
  I: Integer;
  OldCaption, NewCaption, CallString: string;
begin
  if Length(ACaption) = 0 then CheckStart(AOwnerIID, AClassIID);

  Result := inherited CreateComponent(AOwnerIID, AClassIID, ACaption);

  if Assigned(Result) then
  begin
    // получение названия
    if Length(ACaption) = 0 then
    begin
      if not IsEqualGUID(AOwnerIID, IUnknown) then
        Result.OwnerIID := AOwnerIID
      else
        Result.OwnerIID := GetWantedOwnerIID(AClassIID);
      I := 1;
      OldCaption := {GetHintLeftPart(}Designer.GetComponent(AClassIID).GetHintClassFnc{)};
      NewCaption := Format('%s %d', [OldCaption, I]);
      while Assigned(Designer.FindComponent(Result.OwnerIID, AClassIID, NewCaption)) do
      begin
        Inc(I);
        NewCaption := Format('%s %d', [OldCaption, I]);
      end;
      Result.Caption := NewCaption;
    end else
    begin
      Result.OwnerIID := AOwnerIID;
      Result.Caption := ACaption;
    end;

    // подготовка к отправке в IDE
    if Supports(Result, IibSHSQLEditor) then CallString := SCallSQLText;
    if Supports(Result, IibSHSQLPlayer) then CallString := SCallSQLStatements;
    if Supports(Result, IibSHDMLExporter) then CallString := SCallTargetScript;
    if Supports(Result, IibSHFIBMonitor) then CallString := SCallFIBTrace;
    if Supports(Result, IibSHIBXMonitor) then CallString := SCallIBXTrace;
    if Supports(Result, IibSHDDLGrantor) then CallString := SCallPrivileges;
    if Supports(Result, IibSHUserManager) then CallString := SCallUsers;
    if Supports(Result, IibSHDDLCommentator) then CallString := SCallDescriptions;
    if Supports(Result, IibSHDDLDocumentor) then CallString:= SCallDescriptions;
    if Supports(Result, IibSHDDLFinder) then CallString := SCallSearchResults;
    if Supports(Result, IibSHDDLExtractor) then CallString := SCallTargetScript;
    if Supports(Result, IibSHTXTLoader) then CallString := SCallDMLStatement;
    if Supports(Result, IibSHPSQLDebugger) then CallString := SCallTracing;
    // Services
    if Supports(Result, IibSHServerProps) then CallString := SCallServiceOutputs;
    if Supports(Result, IibSHServerLog) then CallString := SCallServiceOutputs;
    if Supports(Result, IibSHServerConfig) then CallString := SCallServiceOutputs;
    if Supports(Result, IibSHServerLicense) then CallString := SCallServiceOutputs;
    if Supports(Result, IibSHDatabaseShutdown) then CallString := SCallServiceOutputs;
    if Supports(Result, IibSHDatabaseOnline) then CallString := SCallServiceOutputs;
    if Supports(Result, IibSHDatabaseBackup) then CallString := SCallServiceOutputs;
    if Supports(Result, IibSHDatabaseRestore) then CallString := SCallServiceOutputs;
    if Supports(Result, IibSHDatabaseStatistics) then CallString := SCallServiceOutputs;
    if Supports(Result, IibSHDatabaseValidation) then CallString := SCallServiceOutputs;
    if Supports(Result, IibSHDatabaseSweep) then CallString := SCallServiceOutputs;
    if Supports(Result, IibSHDatabaseMend) then CallString := SCallServiceOutputs;
    if Supports(Result, IibSHTransactionRecovery) then CallString := SCallServiceOutputs;
    if Supports(Result, IibSHDatabaseProps) then CallString := SCallServiceOutputs;

    if Length(CallString) = 0 then CallString := SCallUnknown;
    DoBeforeChangeNotification(CallString, Result);

    if Designer.ExistsComponent(Result) then
      Designer.ChangeNotification(Result, opInsert)
    else
      Designer.ChangeNotification(Result, CallString, opInsert);
  end;
end;


end.





