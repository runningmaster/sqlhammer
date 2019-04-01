unit ideSHSystemOptions;

interface

uses
  SysUtils, Classes, Dialogs, Graphics, DesignIntf, VirtualTrees,
  SHDesignIntf, SHOptionsIntf;

type
  TideSHSystemOptions = class(TSHComponentOptions, ISHSystemOptions)
  private
    FStartBranch: Integer;
    FUseWorkspaces: Boolean;
    FExternalDiffPath: string;
    FExternalDiffParams: string;
    FShowSplashWindow: Boolean;
    FWarningOnExit: Boolean;

    FLeftWidth: Integer;
    FRightWidth: Integer;
    FIDE1Height: Integer;
    FIDE2Height: Integer;
    FIDE3Height: Integer;
    FNavigatorLeft: Boolean;
    FToolboxTop: Boolean;
    FStartPage: Integer;
    FMultilineMode: Boolean;
    FFilterMode: Boolean;

    function GetStartBranch: Integer;
    procedure SetStartBranch(Value: Integer);
    function GetShowSplashWindow: Boolean;
    procedure SetShowSplashWindow(Value: Boolean);
    function GetUseWorkspaces: Boolean;
    procedure SetUseWorkspaces(Value: Boolean);
    function GetExternalDiffPath: string;
    procedure SetExternalDiffPath(Value: string);
    function GetExternalDiffParams: string;
    procedure SetExternalDiffParams(Value: string);
    function GetWarningOnExit: Boolean;
    procedure SetWarningOnExit(Value: Boolean);

    function GetLeftWidth: Integer;
    procedure SetLeftWidth(Value: Integer);
    function GetRightWidth: Integer;
    procedure SetRightWidth(Value: Integer);
    function GetIDE1Height: Integer;
    procedure SetIDE1Height(Value: Integer);
    function GetIDE2Height: Integer;
    procedure SetIDE2Height(Value: Integer);
    function GetIDE3Height: Integer;
    procedure SetIDE3Height(Value: Integer);
    function GetNavigatorLeft: Boolean;
    procedure SetNavigatorLeft(Value: Boolean);
    function GetToolboxTop: Boolean;
    procedure SetToolboxTop(Value: Boolean);
    function GetStartPage: Integer;
    procedure SetStartPage(Value: Integer);
    function GetMultilineMode: Boolean;
    procedure SetMultilineMode(Value: Boolean);
    function GetFilterMode: Boolean;
    procedure SetFilterMode(Value: Boolean);
  protected
    function GetCategory: string; override;
    procedure RestoreDefaults; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property ExternalDiffPath: string read GetExternalDiffPath write SetExternalDiffPath;
    property ExternalDiffParams: string read GetExternalDiffParams write SetExternalDiffParams;
  published
    property ShowSplashWindow: Boolean read GetShowSplashWindow write SetShowSplashWindow;
    property UseWorkspaces: Boolean read GetUseWorkspaces write SetUseWorkspaces;
    property WarningOnExit: Boolean read GetWarningOnExit write SetWarningOnExit;

    {Invisible}
    property StartBranch: Integer read GetStartBranch write SetStartBranch;
    property LeftWidth: Integer read GetLeftWidth write SetLeftWidth;
    property RightWidth: Integer read GetRightWidth write SetRightWidth;
    property IDE1Height: Integer read GetIDE1Height write SetIDE1Height;
    property IDE2Height: Integer read GetIDE2Height write SetIDE2Height;
    property IDE3Height: Integer read GetIDE3Height write SetIDE3Height;
    property NavigatorLeft: Boolean read GetNavigatorLeft write SetNavigatorLeft;
    property ToolboxTop: Boolean read GetToolboxTop write SetToolboxTop;
    property StartPage: Integer read GetStartPage write SetStartPage;
    property MultilineMode: Boolean read GetMultilineMode write SetMultilineMode;
    property FilterMode: Boolean read GetFilterMode write SetFilterMode;
  end;

  TideSHExternalDiffPathPropEditor = class(TSHPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

implementation

uses
  ideSHConsts, ideSHSystem, ideSHMainFrm;

{ TideSHSystemOptions }

constructor TideSHSystemOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  MakePropertyInvisible('StartBranch');
  MakePropertyInvisible('LeftWidth');
  MakePropertyInvisible('RightWidth');
  MakePropertyInvisible('IDE1Height');
  MakePropertyInvisible('IDE2Height');
  MakePropertyInvisible('IDE3Height');
  MakePropertyInvisible('NavigatorLeft');
  MakePropertyInvisible('ToolboxTop');
  MakePropertyInvisible('StartPage');
  MakePropertyInvisible('MultilineMode');
  MakePropertyInvisible('FilterMode');

  FLeftWidth := 165;
  FRightWidth := 145;
  FIDE1Height := 160;
  FIDE2Height := 400;
  FIDE3Height := 200;
  FNavigatorLeft := True;
  FToolboxTop := True;
  FMultilineMode := False;
  FFilterMode := False;
end;

destructor TideSHSystemOptions.Destroy;
begin
  inherited Destroy;
end;

function TideSHSystemOptions.GetCategory: string;
begin
  Result := Format('%s', [SSystem]);
end;

procedure TideSHSystemOptions.RestoreDefaults;
begin
  FShowSplashWindow := True;
  FUseWorkspaces := True;
  FExternalDiffPath := EmptyStr;
  FExternalDiffParams := '%File1% %File2%';
  FWarningOnExit := True;
end;

function TideSHSystemOptions.GetStartBranch: Integer;
begin
  Result := FStartBranch;
end;

procedure TideSHSystemOptions.SetStartBranch(Value: Integer);
begin
  FStartBranch := Value;
end;

function TideSHSystemOptions.GetShowSplashWindow: Boolean;
begin
  Result := FShowSplashWindow;
end;

procedure TideSHSystemOptions.SetShowSplashWindow(Value: Boolean);
begin
  FShowSplashWindow := Value;
end;

function TideSHSystemOptions.GetUseWorkspaces: Boolean;
begin
  Result := FUseWorkspaces;
end;

procedure TideSHSystemOptions.SetUseWorkspaces(Value: Boolean);
begin
  if FUseWorkspaces <> Value then
  begin
    if not Assigned(Designer.CurrentComponent) then
      FUseWorkspaces := Value
    else
      Designer.ShowMsg(Format('%s', ['Object Editor must be empty']), mtInformation);
  end;
end;

function TideSHSystemOptions.GetExternalDiffPath: string;
begin
  Result := FExternalDiffPath;
end;

procedure TideSHSystemOptions.SetExternalDiffPath(Value: string);
begin
  FExternalDiffPath := Value;
end;

function TideSHSystemOptions.GetExternalDiffParams: string;
begin
  Result := FExternalDiffParams;
end;

procedure TideSHSystemOptions.SetExternalDiffParams(Value: string);
begin
  FExternalDiffParams := Value;
end;

function TideSHSystemOptions.GetWarningOnExit: Boolean;
begin
  Result := FWarningOnExit;
end;

procedure TideSHSystemOptions.SetWarningOnExit(Value: Boolean);
begin
  FWarningOnExit := Value;
end;

function TideSHSystemOptions.GetLeftWidth: Integer;
begin
  Result := FLeftWidth;
end;

procedure TideSHSystemOptions.SetLeftWidth(Value: Integer);
begin
  FLeftWidth := Value;
end;

function TideSHSystemOptions.GetRightWidth: Integer;
begin
  Result := FRightWidth;
end;

procedure TideSHSystemOptions.SetRightWidth(Value: Integer);
begin
  FRightWidth := Value;
end;

function TideSHSystemOptions.GetIDE1Height: Integer;
begin
  Result := FIDE1Height;
end;

procedure TideSHSystemOptions.SetIDE1Height(Value: Integer);
begin
  FIDE1Height := Value;
end;

function TideSHSystemOptions.GetIDE2Height: Integer;
begin
  Result := FIDE2Height;
end;

procedure TideSHSystemOptions.SetIDE2Height(Value: Integer);
begin
  FIDE2Height := Value;
end;

function TideSHSystemOptions.GetIDE3Height: Integer;
begin
  Result := FIDE3Height;
end;

procedure TideSHSystemOptions.SetIDE3Height(Value: Integer);
begin
  FIDE3Height := Value;
end;

function TideSHSystemOptions.GetNavigatorLeft: Boolean;
begin
  Result := FNavigatorLeft;
end;

procedure TideSHSystemOptions.SetNavigatorLeft(Value: Boolean);
begin
  FNavigatorLeft := Value;
end;

function TideSHSystemOptions.GetToolboxTop: Boolean;
begin
  Result := FToolboxTop;
end;

procedure TideSHSystemOptions.SetToolboxTop(Value: Boolean);
begin
  FToolboxTop := Value;
end;

function TideSHSystemOptions.GetStartPage: Integer;
begin
  Result := FStartPage;
end;

procedure TideSHSystemOptions.SetStartPage(Value: Integer);
begin
  FStartPage := Value;
end;

function TideSHSystemOptions.GetMultilineMode: Boolean;
begin
  Result := FMultilineMode;
end;

procedure TideSHSystemOptions.SetMultilineMode(Value: Boolean);
begin
  FMultilineMode := Value;
end;

function TideSHSystemOptions.GetFilterMode: Boolean;
begin
  Result := FFilterMode;
end;

procedure TideSHSystemOptions.SetFilterMode(Value: Boolean);
begin
  FFilterMode := Value;
end;

{ TideSHExternalDiffPathPropEditor }

function TideSHExternalDiffPathPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TideSHExternalDiffPathPropEditor.Edit;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := 'Executables (*.exe; *.bat; *.cmd)|*.exe; *.bat; *.cmd|All Files (*.*)|*.*';
    if OpenDialog.Execute then SetStrValue(OpenDialog.FileName);
  finally
    FreeAndNil(OpenDialog);
  end;
end;

end.







