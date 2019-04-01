unit ibSHSQLPlayer;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibSHSQLPlayer = class(TibBTTool, IibSHSQLPlayer, IibSHBranch, IfbSHBranch)
  private
    FServer: string;
    FMode: string;
    FAbortOnError: Boolean;
    FAfterError: string;
    FAutoDDL: Boolean;
    FDefaultSQLDialect: Integer;
    FSignScript: Boolean;
    FLockModeChanging: Boolean;
    function GetServer: string;
    procedure SetServer(Value: string);
    function GetMode: string;
    procedure SetMode(Value: string);
    function GetAutoDDL: Boolean;
    procedure SetAutoDDL(Value: Boolean);
    function GetAbortOnError: Boolean;
    procedure SetAbortOnError(Value: Boolean);
    function GetAfterError: string;
    procedure SetAfterError(Value: string);
    function GetDefaultSQLDialect: Integer;
    procedure SetDefaultSQLDialect(Value: Integer);
    function GetSignScript: Boolean;
    procedure SetSignScript(Value: Boolean);
  protected
    FBTCLDatabaseInternal: IibSHDatabase;
    procedure SetOwnerIID(Value: TGUID); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Server: string read GetServer write SetServer;
    property Mode: string read GetMode write SetMode;
    property AutoDDL: Boolean read GetAutoDDL write SetAutoDDL;
    property AbortOnError: Boolean read GetAbortOnError write SetAbortOnError;
    property AfterError: string read GetAfterError write SetAfterError;
    property DefaultSQLDialect: Integer read GetDefaultSQLDialect write SetDefaultSQLDialect;
    property SignScript: Boolean read GetSignScript write SetSignScript;

  end;

  TibSHSQLPlayerFactory = class(TibBTToolFactory)
  end;

procedure Register();

implementation

uses
  ibSHConsts, ibSHSQLs,
  ibSHSQLPlayerActions,
  ibSHSQLPlayerEditors;

procedure Register();
begin
  SHRegisterImage(GUIDToString(IibSHSQLPlayer), 'SQLPlayer.bmp');

  SHRegisterImage(TibSHSQLPlayerPaletteAction.ClassName,             'SQLPlayer.bmp');
  SHRegisterImage(TibSHSQLPlayerFormAction.ClassName,                'Form_SQLText.bmp');
  SHRegisterImage(TibSHSQLPlayerToolbarAction_Run.ClassName,         'Button_Run.bmp');
  SHRegisterImage(TibSHSQLPlayerToolbarAction_RunCurrent.ClassName,     'Button_RunTrace.bmp');
  SHRegisterImage(TibSHSQLPlayerToolbarAction_RunFromCurrent.ClassName, 'Button_RunTraceAll.bmp');
  SHRegisterImage(TibSHSQLPlayerToolbarAction_Pause.ClassName,       'Button_Stop.bmp');
  SHRegisterImage(TibSHSQLPlayerToolbarAction_Region.ClassName,      'Button_Tree.bmp');
  SHRegisterImage(TibSHSQLPlayerToolbarAction_Refresh.ClassName,     'Button_Refresh.bmp');
  SHRegisterImage(TibSHSQLPlayerToolbarAction_Open.ClassName,        'Button_Open.bmp');
  SHRegisterImage(TibSHSQLPlayerToolbarAction_Save.ClassName,        'Button_Save.bmp');
  SHRegisterImage(TibSHSQLPlayerToolbarAction_SaveAs.ClassName,      'Button_SaveAs.bmp');
  SHRegisterImage(TibSHSQLPlayerToolbarAction_RunFromFile.ClassName, 'Button_RunFromFile1.bmp');
  SHRegisterImage(TibSHSQLPlayerEditorAction_CheckAll.ClassName,   'Button_Check.bmp');
  SHRegisterImage(TibSHSQLPlayerEditorAction_UnCheckAll.ClassName, 'Button_UnCheck.bmp');

  SHRegisterImage(SCallSQLStatements, 'Form_SQLText.bmp');

  SHRegisterComponents([TibSHSQLPlayer, TibSHSQLPlayerFactory]);

  SHRegisterActions([
    // Palette
    TibSHSQLPlayerPaletteAction,
    // Forms
    TibSHSQLPlayerFormAction,
    // Toolbar
    TibSHSQLPlayerToolbarAction_Run,
    TibSHSQLPlayerToolbarAction_RunFromFile,
    TibSHSQLPlayerToolbarAction_RunCurrent,
    TibSHSQLPlayerToolbarAction_RunFromCurrent,
    TibSHSQLPlayerToolbarAction_Pause,
    TibSHSQLPlayerToolbarAction_Region,
    TibSHSQLPlayerToolbarAction_Refresh,

    TibSHSQLPlayerEditorAction_CheckAll,
    TibSHSQLPlayerEditorAction_UnCheckAll,

    TibSHSQLPlayerToolbarAction_Open,
    TibSHSQLPlayerToolbarAction_Save,
    TibSHSQLPlayerToolbarAction_SaveAs,


    // Editors
    TibSHSQLPlayerEditorAction_SendToSQLPlayer]);

  SHRegisterPropertyEditor(IibSHSQLPlayer, SCallDefaultSQLDialect,
    TibSHDefaultSQLDialectPropEditor);
  SHRegisterPropertyEditor(IibSHSQLPlayer, SCallMode,
    TibSHSQLPlayerModePropEditor);
  SHRegisterPropertyEditor(IibSHSQLPlayer, SCallAfterError,
    TibSHSQLPlayerAfterErrorPropEditor);
end;

{ TibBTSQLScript }

constructor TibSHSQLPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMode := PlayerModes[0];
  FAutoDDL := True;
  FAbortOnError := True;
  FDefaultSQLDialect := 3;
  FSignScript := True;
  FLockModeChanging := False;
  MakePropertyVisible('AfterError');
  FAfterError := PlayerAfterErrors[1];
end;

destructor TibSHSQLPlayer.Destroy;
begin
  inherited Destroy;
end;

function TibSHSQLPlayer.GetServer: string;
begin
  if Assigned(BTCLServer) then
    Result := Format('%s (%s)  ', [BTCLServer.Caption, BTCLServer.CaptionExt]);
end;

procedure TibSHSQLPlayer.SetServer(Value: string);
begin
  if AnsiSameText(FMode, PlayerModes[0]) then
    FServer := Value;
end;

function TibSHSQLPlayer.GetAutoDDL: Boolean;
begin
  Result := FAutoDDL;
end;

function TibSHSQLPlayer.GetMode: string;
begin
  Result := FMode;
end;

procedure TibSHSQLPlayer.SetMode(Value: string);
var
  vPlayerForm: IibSHSQLPlayerForm;
begin
  if not FLockModeChanging then
  begin
    try
      FLockModeChanging := True;
      if (FMode <> Value) then
      begin
        FMode := Value;
//        Designer.UpdateObjectInspector;
        if GetComponentFormIntf(IibSHSQLPlayerForm, vPlayerForm) then
        begin
          if AnsiSameText(PlayerModes[1], FMode) then
          begin
            if not vPlayerForm.ChangeNotification then
            begin
              FMode := PlayerModes[0];
              vPlayerForm.ChangeNotification;
            end;
          end
          else
            vPlayerForm.ChangeNotification;
        end;
      end;
    finally
      FLockModeChanging := False;
    end;
  end;
  Designer.UpdateActions;
end;

procedure TibSHSQLPlayer.SetAutoDDL(Value: Boolean);
begin
  FAutoDDL := Value;
end;

function TibSHSQLPlayer.GetAbortOnError: Boolean;
begin
  Result := FAbortOnError;
end;

procedure TibSHSQLPlayer.SetAbortOnError(Value: Boolean);
begin
  FAbortOnError := Value;
  if FAbortOnError then
    MakePropertyVisible('AfterError')
  else
    MakePropertyInvisible('AfterError');
  Designer.UpdateObjectInspector;  
end;

function TibSHSQLPlayer.GetAfterError: string;
begin
  Result := FAfterError;
end;

procedure TibSHSQLPlayer.SetAfterError(Value: string);
begin
  FAfterError := Value;
end;

function TibSHSQLPlayer.GetDefaultSQLDialect: Integer;
begin
  Result := FDefaultSQLDialect;
end;

procedure TibSHSQLPlayer.SetDefaultSQLDialect(Value: Integer);
begin
  FDefaultSQLDialect := Value;
end;

function TibSHSQLPlayer.GetSignScript: Boolean;
begin
  Result := FSignScript;
end;

procedure TibSHSQLPlayer.SetSignScript(Value: Boolean);
begin
  FSignScript := Value;
end;

procedure TibSHSQLPlayer.SetOwnerIID(Value: TGUID);
begin
  if AnsiSameText(FMode, PlayerModes[0]) then
  begin
    if not IsEqualGUID(OwnerIID, Value) then
    begin
      if Supports(Designer.FindComponent(Value), IibSHDatabase, FBTCLDatabaseIntf) then
      begin
        FBTCLServerIntf := FBTCLDatabaseIntf.BTCLServer;
        MakePropertyInvisible('Server');
      end
      else
      begin
        Supports(Designer.FindComponent(Value), IibSHServer, FBTCLServerIntf);
        FBTCLDatabaseIntf := nil;
        MakePropertyVisible('Server');
      end;
    end;
    inherited SetOwnerIID(Value);
  end;  
end;



initialization

  Register;

end.



