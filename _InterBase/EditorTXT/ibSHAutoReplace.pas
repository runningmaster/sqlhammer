unit ibSHAutoReplace;

interface

uses Classes, Forms, SysUtils, Menus,
     SHDesignIntf, SHOptionsIntf, SHEvents, ibSHDesignIntf, ibSHConsts,
     pSHIntf, pSHAutoComplete;

type
   TibBTAutoReplace = class(TSHComponent, ISHDemon, IpSHAutoComplete, IibSHAutoReplace)
   private
    FAutoComplete: TpSHAutoComplete;
    procedure DoOnOptionsChanged;
   protected
     {IpSHAutoComplete}
     function GetAutoComplete: TComponent;
   public
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
     class function GetClassIIDClassFnc: TGUID; override;
     function ReceiveEvent(AEvent: TSHEvent): Boolean; override;

     property AutoComplete: TpSHAutoComplete read FAutoComplete;
   published
   end;

implementation

procedure Register;
begin
  SHRegisterComponents([TibBTAutoReplace]);
end;

constructor TibBTAutoReplace.Create(AOwner: TComponent);
var
  vDataRootDirectory: ISHDataRootDirectory;
begin
  inherited Create(AOwner);
  FAutoComplete := TpSHAutoComplete.Create(nil);
  FAutoComplete.ShortCut := Menus.ShortCut(Ord(' '), []);
  if Supports(Designer.GetDemon(IibSHBranch), ISHDataRootDirectory, vDataRootDirectory) and
    FileExists(vDataRootDirectory.DataRootDirectory + InterBaseAutoReplaceFileName) then
    FAutoComplete.LoadFromFile(vDataRootDirectory.DataRootDirectory + InterBaseAutoReplaceFileName);
  DoOnOptionsChanged;
end;

destructor TibBTAutoReplace.Destroy;
begin
  FAutoComplete.Free;
  inherited;
end;

function CodeCaseConv(AEditorCaseCode: TSHEditorCaseCode): TpSHCaseCode;
begin
  case AEditorCaseCode of
    Lower: Result := ccLower;
    Upper: Result := ccUpper;
    NameCase: Result := ccNameCase;
    FirstUpper: Result := ccFirstUpper;
    None: Result := ccNone;
    Invert: Result := ccInvert;
    Toggle: Result := ccToggle;
    else
      Result := ccUpper;
  end;
end;

procedure TibBTAutoReplace.DoOnOptionsChanged;
var
  vEditorCodeInsightOptions: ISHEditorCodeInsightOptions;
begin
  if Supports(Designer.GetDemon(ISHEditorCodeInsightOptions), ISHEditorCodeInsightOptions, vEditorCodeInsightOptions) then
  begin
    FAutoComplete.CaseSQLCode := CodeCaseConv(vEditorCodeInsightOptions.CaseSQLKeywords);
  end;
end;

class function TibBTAutoReplace.GetClassIIDClassFnc: TGUID;
begin
  Result := IibSHAutoReplace;
end;

function TibBTAutoReplace.ReceiveEvent(AEvent: TSHEvent): Boolean;
begin
  with AEvent do
    case Event of
      SHE_OPTIONS_CHANGED: DoOnOptionsChanged;
    end;
  Result := inherited ReceiveEvent(AEvent);
end;

function TibBTAutoReplace.GetAutoComplete: TComponent;
begin
  Result := FAutoComplete;
end;

initialization

  Register;

end.
