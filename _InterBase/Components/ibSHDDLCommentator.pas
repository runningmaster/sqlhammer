unit ibSHDDLCommentator;

interface

uses
  SysUtils, Classes, StrUtils,
  SHDesignIntf,
  ibSHDesignIntf, ibSHTool;

type
  TibSHDDLCommentator = class(TibBTTool, IibSHDDLCommentator, IibSHBranch, IfbSHBranch)
  private
    FMode: string;
    FGoNext: Boolean;
    function GetMode: string;
    procedure SetMode(Value: string);
    function GetGoNext: Boolean;
    procedure SetGoNext(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Mode: string read GetMode write SetMode;
    property GoNext: Boolean read GetGoNext write SetGoNext;
  end;

  TibSHDDLCommentatorFactory = class(TibBTToolFactory)
  end;

procedure Register;

implementation

uses
  ibSHConsts,
  ibSHDDLCommentatorActions,
  ibSHDDLCommentatorEditors;

procedure Register;
begin
  SHRegisterImage(GUIDToString(IibSHDDLCommentator), 'DDLCommentator.bmp');

  SHRegisterImage(TibSHDDLCommentatorPaletteAction.ClassName,          'DDLCommentator.bmp');
  SHRegisterImage(TibSHDDLCommentatorFormAction.ClassName,             'Form_Description.bmp');
  SHRegisterImage(TibSHDDLCommentatorToolbarAction_Run.ClassName,      'Button_Run.bmp');
  SHRegisterImage(TibSHDDLCommentatorToolbarAction_Pause.ClassName,    'Button_Stop.bmp');
  SHRegisterImage(TibSHDDLCommentatorToolbarAction_Refresh.ClassName, 'Button_Refresh.bmp');

  SHRegisterComponents([
    TibSHDDLCommentator,
    TibSHDDLCommentatorFactory]);

  SHRegisterActions([
    // Palette
    TibSHDDLCommentatorPaletteAction,
    // Forms
    TibSHDDLCommentatorFormAction,
    // Toolbar
    TibSHDDLCommentatorToolbarAction_Run,
//    TibSHDDLCommentatorToolbarAction_Pause,
    TibSHDDLCommentatorToolbarAction_Refresh]);

  SHRegisterPropertyEditor(IibSHDDLCommentator, 'Mode', TibSHDDLCommentatorModePropEditor);
end;

{ TibSHDDLCommentator }

constructor TibSHDDLCommentator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMode := CommentModes[0];
  FGoNext := True;
end;

destructor TibSHDDLCommentator.Destroy;
begin
  inherited Destroy;
end;

function TibSHDDLCommentator.GetMode: string;
begin
  Result := FMode;
end;

procedure TibSHDDLCommentator.SetMode(Value: string);
begin
  if FMode <> Value then
  begin
    FMode := Value;
    if Assigned(Designer.CurrentComponentForm) and
       AnsiContainsText(Designer.CurrentComponentForm.CallString, SCallDescriptions) then
      (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
  end;
end;

function TibSHDDLCommentator.GetGoNext: Boolean;
begin
  Result := FGoNext;
end;

procedure TibSHDDLCommentator.SetGoNext(Value: Boolean);
begin
  FGoNext := Value;
end;

initialization

  Register;
  
end.

