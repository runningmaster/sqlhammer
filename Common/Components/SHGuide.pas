unit SHGuide;

interface

uses
  SysUtils, Classes, Contnrs, Forms,
  // SQLHammer
  SHDesignIntf;

const
  SPageUseGuide          = 'Assistants';

  SClassHintWelcome      = 'Welcome';
  SClassHintUseGuide     = 'Users Guide';
  SClassHintDevGuide     = 'Developers Guide';
  SClassAssocGuide       = 'Assistant';

  SCallWelCome            = 'Welcome';
  SCallInformation       = 'Information';

  SSeeEditor             = 'See Editor';

type
  ISHGuide = interface
  ['{6AE600B3-1374-4FBA-A246-12BE8170D225}']
    function GetStartPage: string;

    property StartPage: string read GetStartPage;
  end;

  ISHWelcome = interface(ISHGuide)
  ['{2942F8EF-1D68-4972-984B-22529087BC85}']
  end;

  ISHUseGuide = interface(ISHGuide)
  ['{D10F616B-C27A-48D2-BA37-ABA851ED4E8D}']
  end;

  ISHDevGuide = interface(ISHGuide)
  ['{9AC6EFD2-BCA0-4E0D-8754-9D3708C2CB67}']
  end;

  TSHGuide = class(TSHComponent, ISHGuide, ISHBranch)
  private
    function GetStartPage: string;
  protected
    function GetBranchIID: TGUID; override;
    function GetCaptionExt: string; override;
    function GetCaptionPath: string; override;
  public
    class function GetHintClassFnc: string; override;
    class function GetAssociationClassFnc: string; override;

    property StartPage: string read GetStartPage;
  published
  end;

  TSHWelcome = class(TSHGuide, ISHWelcome)
  end;

  TSHUseGuide = class(TSHGuide, ISHUseGuide)
  end;

  TSHDevGuide = class(TSHGuide, ISHDevGuide)
  end;

  TSHGuideFactory = class(TSHComponentFactory)
  public
    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    function CreateComponent(const AOwnerIID, AClassIID: TGUID; const ACaption: string): TSHComponent; override;
    function DestroyComponent(AComponent: TSHComponent): Boolean; override;
  end;

procedure Register;

implementation

uses
  SHGuideFrm;

procedure Register;
begin
  SHRegisterComponents([TSHUseGuide, TSHDevGuide]);
  SHRegisterComponents([TSHGuideFactory, TSHWelcome]);
  SHRegisterComponentForm(ISHWelcome, SCallInformation, TSHGuideForm);
  SHRegisterComponentForm(ISHUseGuide, SCallInformation, TSHGuideForm);
  SHRegisterComponentForm(ISHDevGuide, SCallInformation, TSHGuideForm);
end;

{ TSHGuide }

class function TSHGuide.GetHintClassFnc: string;
begin
  if Supports(Self, ISHWelcome) then Result := Format('%s', [SClassHintWelcome]);
  if Supports(Self, ISHUseGuide) then Result := Format('%s', [SClassHintUseGuide]);
  if Supports(Self, ISHDevGuide) then Result := Format('%s', [SClassHintDevGuide]);
end;

class function TSHGuide.GetAssociationClassFnc: string;
begin
  Result := Format('%s', [SClassAssocGuide]);
end;

function TSHGuide.GetBranchIID: TGUID;
begin
  Result := ISHBranch;
end;

function TSHGuide.GetCaptionExt: string;
begin
  Result := Format('%s', [Caption]);
end;

function TSHGuide.GetCaptionPath: string;
begin
  Result := Format('%s\%s\%s', [SSHCommonBranch, SPageUseGuide, Caption]);
end;

function TSHGuide.GetStartPage: string;
begin
  if Supports(Self, ISHWelcome) then
    Result := Designer.GetApplicationPath + '..\Doc\Welcome\index.htm';
  if Supports(Self, ISHUseGuide) then
    Result := Designer.GetApplicationPath + '..\Doc\UseGuide\index.htm';
  if Supports(Self, ISHDevGuide) then
    Result := Designer.GetApplicationPath + '..\Doc\DevGuide\index.htm';
end;


{ TSHGuideFactory }

function GetHintLeftPart(const Hint: string; Separator: string = '|'): string;
var
  I: Integer;
begin
  Result := Hint;
  I := Pos(Separator, Hint);
  if I > 0 then Result := Copy(Hint, 0, I - 1);
end;

function TSHGuideFactory.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, ISHWelcome) or
            IsEqualGUID(AClassIID, ISHUseGuide) or
            IsEqualGUID(AClassIID, ISHDevGuide);
end;

function TSHGuideFactory.CreateComponent(const AOwnerIID, AClassIID: TGUID;
  const ACaption: string): TSHComponent;
begin
  Result := Designer.FindComponent(Designer.FindComponent(IUnknown, ISHBranch).InstanceIID, AClassIID);
  if not Assigned(Result) then
  begin
    Result := Designer.GetComponent(AClassIID).Create(nil);
    if Assigned(Designer.FindComponent(IUnknown, ISHBranch)) then
      Result.OwnerIID := Designer.FindComponent(IUnknown, ISHBranch).InstanceIID;
    Result.Caption := {GetHintLeftPart(}Designer.GetComponent(AClassIID).GetHintClassFnc{)};
  end;
  if Assigned(Result) then
  begin
    if Supports(Result, ISHUseGuide) then Designer.ChangeNotification(Result, SCallInformation, opInsert);
    if Supports(Result, ISHDevGuide) then Designer.ChangeNotification(Result, SCallInformation, opInsert);
  end;
end;

function TSHGuideFactory.DestroyComponent(AComponent: TSHComponent): Boolean;
begin
  Result := False;
  if Assigned(AComponent) then
  begin
    Result := Designer.ChangeNotification(AComponent, opRemove);
    if Result then FreeAndNil(AComponent);
  end;
end;

initialization

  Register;

end.
