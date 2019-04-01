unit ibSHOptions;

interface

uses
  SysUtils, Classes, Graphics, DesignIntf,
  SHDesignIntf, ibSHDesignIntf;

type
  TfibBTOptions = class(TSHComponentOptions, IibSHOptions)
  private
  protected
    function GetCategory: string; override;
    function GetUseDefaultEditor: Boolean; override;
    procedure RestoreDefaults; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    class function GetClassIIDClassFnc: TGUID; override;
  published
  end;

  TibBTOptions = class(TfibBTOptions, IibSHDummy, IibSHBranch)
  end;

  TfbBTOptions = class(TfibBTOptions, IibSHDummy, IfbSHBranch)
  end;

implementation

uses
  ibSHConsts, ibSHValues;

{ TfibBTOptions }

constructor TfibBTOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TfibBTOptions.Destroy;
begin
  inherited Destroy;
end;

class function TfibBTOptions.GetClassIIDClassFnc: TGUID;
begin
  if Supports(Self, IfbSHBranch) then Result := IfbSHOptions;
  if Supports(Self, IibSHBranch) then Result := IibSHOptions;
end;

function TfibBTOptions.GetCategory: string;
begin
  if Supports(Self, IibSHBranch) then Result := Format('%s', [SibOptionsCategory]);
  if Supports(Self, IfbSHBranch) then Result := Format('%s', [SfbOptionsCategory]);
end;

function TfibBTOptions.GetUseDefaultEditor: Boolean;
begin
  Result := False;
end;

procedure TfibBTOptions.RestoreDefaults;
begin
end;

end.
