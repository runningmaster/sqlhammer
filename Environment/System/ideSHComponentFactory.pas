unit ideSHComponentFactory;

interface

uses
  SysUtils, Classes, Dialogs, Contnrs, Menus,
  SHDesignIntf, ideSHDesignIntf;

type
  TideSHComponentFactory = class(TComponent, IideSHComponentFactory)
  private
    FComponentList: TComponentList;
    FComponentFormList: TComponentList;

    function GetComponents: TComponentList;
    function GetComponentForms: TComponentList;

    function CreateComponent(const OwnerIID, ClassIID: TGUID;
      const ACaption: string): TSHComponent;
    function DestroyComponent(AComponent: TSHComponent): Boolean;
    function FindComponent(const InstanceIID: TGUID): TSHComponent; overload;
    function FindComponent(const OwnerIID, ClassIID: TGUID): TSHComponent; overload;
    function FindComponent(const OwnerIID, ClassIID: TGUID; const ACaption: string): TSHComponent; overload;
    procedure SendEvent(Event: TSHEvent);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  ideSHSysUtils, ideSHSystem, ideSHMessages, ideSHMainFrm;

{ TideSHComponentFactory }

constructor TideSHComponentFactory.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComponentList := TComponentList.Create(False);
  FComponentFormList := TComponentList.Create(False);
end;

destructor TideSHComponentFactory.Destroy;
begin
  FComponentList.Free;
  FComponentFormList.Free;
  inherited Destroy;
end;

function TideSHComponentFactory.GetComponents: TComponentList;
begin
  Result := FComponentList;
end;

function TideSHComponentFactory.GetComponentForms: TComponentList;
begin
  Result := FComponentFormList;
end;

function TideSHComponentFactory.CreateComponent(const OwnerIID, ClassIID: TGUID;
  const ACaption: string): TSHComponent;
var
  SHComponentFactoryIntf: ISHComponentFactory;
begin
  Result := nil;
  if IsEqualGUID(ClassIID, ISHServer) or (IsEqualGUID(ClassIID, ISHDatabase)) then
    SHComponentFactoryIntf := RegistryIntf.GetRegComponentFactory(StringToGUID(ACaption))
  else
    SHComponentFactoryIntf := RegistryIntf.GetRegComponentFactory(ClassIID);

  if Assigned(SHComponentFactoryIntf) then
  begin
    Result := SHComponentFactoryIntf.CreateComponent(OwnerIID, ClassIID, ACaption);
  end else
  begin
    if Assigned(RegistryIntf.GetRegComponent(ClassIID)) then
      ideSHSysUtils.ShowMsg(Format(SCantFindComponentFactory, [RegistryIntf.GetRegComponent(ClassIID).ClassName, GUIDToString(ClassIID)]), mtWarning);
  end;
end;

function TideSHComponentFactory.DestroyComponent(AComponent: TSHComponent): Boolean;
var
  SHComponentFactoryIntf: ISHComponentFactory;
begin
  Result := False;
  if Assigned(AComponent) then
  begin
    SHComponentFactoryIntf := RegistryIntf.GetRegComponentFactory(AComponent.ClassIID);
    if Assigned(SHComponentFactoryIntf) then
    begin
      Result := SHComponentFactoryIntf.DestroyComponent(AComponent);
    end else
      ideSHSysUtils.ShowMsg(Format(SCantFindComponentFactory, [AComponent.ClassName, GUIDToString(AComponent.ClassIID)]), mtWarning);
  end;
end;

function TideSHComponentFactory.FindComponent(const InstanceIID: TGUID): TSHComponent;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(FComponentList.Count) do
    if (FComponentList[I] is TSHComponent) and
        IsEqualGUID(TSHComponent(FComponentList[I]).InstanceIID, InstanceIID) then
    begin
      Result := TSHComponent(FComponentList[I]);
      Break;
    end;
end;

function TideSHComponentFactory.FindComponent(const OwnerIID, ClassIID: TGUID): TSHComponent;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(FComponentList.Count) do
    if (FComponentList[I] is TSHComponent) and
        IsEqualGUID(TSHComponent(FComponentList[I]).OwnerIID, OwnerIID) and
        IsEqualGUID(TSHComponent(FComponentList[I]).ClassIID, ClassIID) then
    begin
      Result := TSHComponent(FComponentList[I]);
      Break;
    end;
end;

function TideSHComponentFactory.FindComponent(const OwnerIID, ClassIID: TGUID; const ACaption: string): TSHComponent;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(FComponentList.Count) do
    if (FComponentList[I] is TSHComponent) and
        IsEqualGUID(TSHComponent(FComponentList[I]).OwnerIID, OwnerIID) and
        IsEqualGUID(TSHComponent(FComponentList[I]).ClassIID, ClassIID) and
        (CompareStr(TSHComponent(FComponentList[I]).Caption, ACaption) = 0) then
    begin
      Result := TSHComponent(FComponentList[I]);
      Break;
    end;
end;

procedure TideSHComponentFactory.SendEvent(Event: TSHEvent);
var
  I: Integer;
  BTEventReceiverIntf: ISHEventReceiver;
begin
  for I := Pred(FComponentList.Count) downto 0 do
    if Supports(FComponentList[I], ISHEventReceiver, BTEventReceiverIntf) then
      BTEventReceiverIntf.ReceiveEvent(Event);

  for I := Pred(FComponentFormList.Count) downto 0 do
    if Supports(FComponentFormList[I], ISHEventReceiver, BTEventReceiverIntf) then
      BTEventReceiverIntf.ReceiveEvent(Event);
end;

end.
