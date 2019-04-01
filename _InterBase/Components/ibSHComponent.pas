unit ibSHComponent;

interface

uses
  Windows, SysUtils, Classes, Contnrs,
  SHDesignIntf, SHDevelopIntf,
  ibSHDesignIntf;


type
  TibBTComponent = class(TSHComponent, IibSHComponent, IibSHDummy)
  protected
    function GetBranchIID: TGUID; override;
    function GetCaptionPath: string; override;

    procedure DoOnApplyOptions; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TibBTComponentFactory = class(TSHComponentFactory)
  public
    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    function CreateComponent(const AOwnerIID, AClassIID: TGUID; const ACaption: string): TSHComponent; override;
    function DestroyComponent(AComponent: TSHComponent): Boolean; override;
  end;

implementation

uses
  ibSHConsts, ibSHValues;

{ TibBTComponent }

constructor TibBTComponent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TibBTComponent.Destroy;
begin
  inherited Destroy;
end;

function TibBTComponent.GetBranchIID: TGUID;
begin
  Result := inherited GetBranchIID;
  if Supports(Self, IibSHBranch) then Result := IibSHBranch
  else
  if Supports(Self, IfbSHBranch) then Result := IfbSHBranch;
end;

function TibBTComponent.GetCaptionPath: string;
var
  BranchName, ServerAlias, DatabaseAlias: string;
  DBObject: IibSHDBObject;
begin
  if IsEqualGUID(BranchIID, IibSHBranch) then BranchName := SSHInterBaseBranch
  else
  if IsEqualGUID(BranchIID, IfbSHBranch) then BranchName := SSHFirebirdBranch;

  ServerAlias := 'ServerAlias';
  DatabaseAlias := 'DatabaseAlias';

  if Supports(Self, IibSHDBObject, DBObject) then
  begin
    if Assigned(DBObject.BTCLDatabase) then
      DatabaseAlias := DBObject.BTCLDatabase.Alias;
    if Assigned(DBObject.BTCLDatabase.BTCLServer) then
      ServerAlias := DBObject.BTCLDatabase.BTCLServer.Alias;
  end;

  Result := Format('%s\%s\%s\%s\%s', [BranchName, ServerAlias, DatabaseAlias, GUIDToName(Self.ClassIID, 1), Self.Caption]);
end;

procedure TibBTComponent.DoOnApplyOptions;
begin
// Empty
end;

{ TibBTComponentFactory }

function TibBTComponentFactory.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := False;
end;

function TibBTComponentFactory.CreateComponent(const AOwnerIID, AClassIID: TGUID;
  const ACaption: string): TSHComponent;
begin
  Result := Designer.FindComponent(AOwnerIID, AClassIID, ACaption);
  if not Assigned(Result) then
    Result := Designer.GetComponent(AClassIID).Create(nil);
end;

function TibBTComponentFactory.DestroyComponent(AComponent: TSHComponent): Boolean;
begin
  Result := Assigned(AComponent) and Designer.ChangeNotification(AComponent, opRemove);
  if Result then FreeAndNil(AComponent);
end;

end.
