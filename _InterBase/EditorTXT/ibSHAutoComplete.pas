unit ibSHAutoComplete;

interface

uses Classes, Forms, SysUtils,
     SHDesignIntf, SHOptionsIntf, SHEvents, ibSHDesignIntf, ibSHConsts,
     pSHIntf, pSHAutoComplete;

type
   TibBTAutoComplete = class(TSHComponent, ISHDemon, IpSHAutoComplete, IibSHAutoComplete)
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
  SHRegisterComponents([TibBTAutoComplete]);
end;

constructor TibBTAutoComplete.Create(AOwner: TComponent);
var
  vDataRootDirectory: ISHDataRootDirectory;
begin
  inherited Create(AOwner);
  FAutoComplete := TpSHAutoComplete.Create(nil);

  if Supports(Designer.GetDemon(IibSHBranch), ISHDataRootDirectory, vDataRootDirectory) and
    FileExists(vDataRootDirectory.DataRootDirectory + InterBaseKeyboardTemplatesFileName) then
    FAutoComplete.LoadFromFile(vDataRootDirectory.DataRootDirectory + InterBaseKeyboardTemplatesFileName);
  DoOnOptionsChanged;
end;

destructor TibBTAutoComplete.Destroy;
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

procedure TibBTAutoComplete.DoOnOptionsChanged;
var
  vEditorCodeInsightOptions: ISHEditorCodeInsightOptions;
begin
  if Supports(Designer.GetDemon(ISHEditorCodeInsightOptions), ISHEditorCodeInsightOptions, vEditorCodeInsightOptions) then
  begin
    FAutoComplete.CaseSQLCode := CodeCaseConv(vEditorCodeInsightOptions.CaseSQLKeywords);
  end;
end;

function TibBTAutoComplete.GetAutoComplete: TComponent;
begin
  Result := FAutoComplete;
end;

class function TibBTAutoComplete.GetClassIIDClassFnc: TGUID;
begin
  Result := IibSHAutoComplete;
end;

function TibBTAutoComplete.ReceiveEvent(AEvent: TSHEvent): Boolean;
begin
  with AEvent do
    case Event of
      SHE_OPTIONS_CHANGED: DoOnOptionsChanged;
    end;
  Result := inherited ReceiveEvent(AEvent);
end;

initialization

  Register;

end.
