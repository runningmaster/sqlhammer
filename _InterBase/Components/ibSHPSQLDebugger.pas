unit ibSHPSQLDebugger;

interface

uses
  SysUtils, Classes, StrUtils,
  SHDesignIntf, SHEvents, SHOptionsIntf,
  ibSHDesignIntf, ibSHDriverIntf, ibSHComponent, ibSHTool, ibSHConsts,
  ibSHDebuggerIntf;

type
  TibSHPSQLDebugger = class(TibBTTool, IibSHPSQLDebugger, IibSHDDLInfo, IibSHBranch, IfbSHBranch)
  private
    FDebugComponent: TSHComponent;
    FParentDebugger: IibSHPSQLDebugger;
    FDRVTransactionComponent: TSHComponent;
    FDRVTransaction: IibSHDRVTransaction;
    FDebugDDL: TStrings;

  protected
    { IibSHPSQLDebugger }
    function GetDebugComponent: TSHComponent;
    function GetDRVTransaction: IibSHDRVTransaction;
    function GetParentDebugger: IibSHPSQLDebugger;
    procedure Debug(AParentDebugger: IibSHPSQLDebugger; AClassIID: TGUID; ACaption: string);
    { End of IibSHPSQLDebugger }

    { IibSHDDLInfo }
    function GetDDL: TStrings;
    function GetBTCLDatabase: IibSHDatabase;
    function GetState: TSHDBComponentState;

    procedure CreateDRV;
    procedure FreeDRV;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    property DebugComponent: TSHComponent read GetDebugComponent;
    property DRVTransaction: IibSHDRVTransaction read GetDRVTransaction;
    property ParentDebugger: IibSHPSQLDebugger read GetParentDebugger;

  end;

  TibSHPSQLDebuggerFactory = class(TibBTToolFactory)
  end;

procedure Register;

implementation

uses ibSHPSQLDebuggerActions;

procedure Register;
begin
  SHRegisterImage(GUIDToString(IibSHPSQLDebugger), 'PSQLDebugger.bmp');

  SHRegisterImage(SCallTracing, 'Form_PSQLDebugger.bmp');
  SHRegisterImage(TibSHPSQLDebuggerFormAction.ClassName,                     'Form_PSQLDebugger.bmp');

  SHRegisterImage(TibSHPSQLDebuggerToolbarAction_SetParameters.ClassName,    'Button_SetParameters.bmp');
  SHRegisterImage(TibSHPSQLDebuggerToolbarAction_TraceInto.ClassName,        'Button_TraceInto.bmp');
  SHRegisterImage(TibSHPSQLDebuggerToolbarAction_StepOver.ClassName,         'Button_StepOver.bmp');
  SHRegisterImage(TibSHPSQLDebuggerToolbarAction_SkipStatement.ClassName,    'Button_SkipStatement.bmp');
  SHRegisterImage(TibSHPSQLDebuggerToolbarAction_RunToCursor.ClassName,      'Button_RunToCursor.bmp');

  SHRegisterImage(TibSHPSQLDebuggerToolbarAction_ToggleBreakpoint.ClassName, 'Button_Breakpoint.bmp');
  SHRegisterImage(TibSHPSQLDebuggerToolbarAction_AddWatch.ClassName,         'Button_AddWatch.bmp');
  SHRegisterImage(TibSHPSQLDebuggerToolbarAction_Reset.ClassName,            'Button_Reset.bmp');

  SHRegisterImage(TibSHPSQLDebuggerToolbarAction_Run.ClassName,              'Button_Run.bmp');
  SHRegisterImage(TibSHPSQLDebuggerToolbarAction_Pause.ClassName,            'Button_Stop.bmp');
  SHRegisterImage(TibSHPSQLDebuggerToolbarAction_ModifyVarValues.ClassName,  'Button_Evaluate.bmp');

  SHRegisterImage(TibSHSendToPSQLDebuggerToolbarAction.ClassName,            'PSQLDebugger.bmp');

  SHRegisterComponents([
    TibSHPSQLDebugger,
    TibSHPSQLDebuggerFactory]);

  SHRegisterActions([
    // Palette
    //TibSHPSQLDebuggerPaletteAction - на хуй не нужен типа
    // Forms
    TibSHPSQLDebuggerFormAction,
    // Toolbar
    TibSHPSQLDebuggerToolbarAction_SetParameters,
    TibSHPSQLDebuggerToolbarAction_TraceInto,
    TibSHPSQLDebuggerToolbarAction_StepOver,
    TibSHPSQLDebuggerToolbarAction_SkipStatement,
    TibSHPSQLDebuggerToolbarAction_RunToCursor,

    TibSHPSQLDebuggerToolbarAction_ToggleBreakpoint,
    TibSHPSQLDebuggerToolbarAction_AddWatch,
    TibSHPSQLDebuggerToolbarAction_ModifyVarValues,
    TibSHPSQLDebuggerToolbarAction_Reset,

    TibSHPSQLDebuggerToolbarAction_Run,
    TibSHPSQLDebuggerToolbarAction_Pause,


    TibSHSendToPSQLDebuggerToolbarAction
    // Editors

    ]);

end;

{ TibSHDebugger }

constructor TibSHPSQLDebugger.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDebugComponent := nil;
  FDebugDDL := TStringList.Create;
end;

destructor TibSHPSQLDebugger.Destroy;
begin
  FDebugDDL.Free;
  if Assigned(FDebugComponent) then
    FreeAndNil(FDebugComponent);
//  FDebugComponent.Free;
  inherited;
end;

function TibSHPSQLDebugger.GetDebugComponent: TSHComponent;
begin
  Result := FDebugComponent;
end;

function TibSHPSQLDebugger.GetDRVTransaction: IibSHDRVTransaction;
begin
  Result := FDRVTransaction;
end;

function TibSHPSQLDebugger.GetParentDebugger: IibSHPSQLDebugger;
begin
  Result := FParentDebugger;
end;

procedure TibSHPSQLDebugger.Debug(AParentDebugger: IibSHPSQLDebugger; AClassIID: TGUID; ACaption: string);
var
  vPSQLDebuggerForm: IibSHPSQLDebuggerForm;
begin
  if not Assigned(FDebugComponent) and
    (Length(ACaption) > 0) and
    (
      IsEqualGUID(AClassIID, IibSHProcedure) or
      IsEqualGUID(AClassIID, IibSHTrigger)
    ) then
  begin
//    FDebugComponent := Designer.CreateComponent(OwnerIID, AClassIID, ACaption);
    if Assigned(AParentDebugger) then
    begin
      if Assigned(FParentDebugger) then
      begin
        FreeDRV;
        ReferenceInterface(FParentDebugger, opRemove);
      end;
      FParentDebugger := AParentDebugger;
      ReferenceInterface(FParentDebugger, opInsert);
      FDRVTransaction := FParentDebugger.DRVTransaction;
    end
    else
      CreateDRV;

    FDebugComponent := Designer.GetComponent(AClassIID).Create(nil);
    Designer.Components.Remove(FDebugComponent);
    FDebugComponent.OwnerIID := OwnerIID;
    FDebugComponent.Caption := ACaption;
    (FDebugComponent as IibSHDBObject).State := csSource;

    if not GetComponentFormIntf(IibSHPSQLDebuggerForm, vPSQLDebuggerForm) then
      Designer.ChangeNotification(Self, SCallTracing, opInsert);
    if GetComponentFormIntf(IibSHPSQLDebuggerForm, vPSQLDebuggerForm) then
      vPSQLDebuggerForm.ChangeNotification;

    Designer.UpdateActions;
  end;
end;

function TibSHPSQLDebugger.GetDDL: TStrings;
begin
  Result := FDebugDDL;
end;

function TibSHPSQLDebugger.GetBTCLDatabase: IibSHDatabase;
begin
  Result := BTCLDatabase;
end;

function TibSHPSQLDebugger.GetState: TSHDBComponentState;
begin
  Result := csSource;
end;

procedure TibSHPSQLDebugger.CreateDRV;
var
  vComponentClass: TSHComponentClass;
begin
  vComponentClass := Designer.GetComponent(BTCLDatabase.BTCLServer.DRVNormalize(IibSHDRVTransaction));
  if Assigned(vComponentClass) then
  begin
    FDRVTransactionComponent := vComponentClass.Create(Self);
    Supports(FDRVTransactionComponent, IibSHDRVTransaction, FDRVTransaction);

    DRVTransaction.Params.Text := TransactionParamsSnapshot;
    DRVTransaction.Database := BTCLDatabase.DRVQuery.Database;

  end;
  Assert(DRVTransaction <> nil, 'DRVTransaction = nil');
end;

procedure TibSHPSQLDebugger.FreeDRV;
begin
  if Assigned(FDRVTransactionComponent) then
  begin
    FDRVTransaction := nil;
    FreeAndNil(FDRVTransactionComponent);
  end;
end;

procedure TibSHPSQLDebugger.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if Assigned(FParentDebugger) and AComponent.IsImplementorOf(FParentDebugger) then
    begin
      FParentDebugger := nil;
      if Assigned(FDRVTransaction) then
        FDRVTransaction := nil;
    end;
  end;
  inherited Notification(AComponent, Operation);
end;

initialization

  Register;

end.


