unit ibSHProcedure;

interface

uses
  SysUtils, Classes, Contnrs, Menus,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;

type
  TibBTProcedure = class(TibBTDBObject, IibSHProcedure)
  private
    FParamsExt: TStrings;
    FReturnsExt: TStrings;
    FHeaderDDL: TStrings;
    FParamList: TComponentList;
    FReturnList: TComponentList;
    function GetCanExecute: Boolean;
    function GetParamsExt: TStrings;
    function GetReturnsExt: TStrings;
    function GetHeaderDDL: TStrings;
    function GetParam(Index: Integer): IibSHProcParam;
    function GetReturn(Index: Integer): IibSHProcParam;
    procedure Execute;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Refresh; override;

    property CanExecute: Boolean read GetCanExecute;
    property ParamsExt: TStrings read GetParamsExt;
    property ReturnsExt: TStrings read GetReturnsExt;
    property HeaderDDL: TStrings read GetHeaderDDL;
  published
    property Description;
    property Params;
    property Returns;
    property OwnerName;
  end;

  TibSHProcedureToolbarAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHProcedureToolbarAction_Execute = class(TibSHProcedureToolbarAction)
  end;

implementation

uses
  ibSHConsts, ibSHSQLs, ActnList;

{ TibBTProcedure }

constructor TibBTProcedure.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParamsExt := TStringList.Create;
  FReturnsExt := TStringList.Create;
  FHeaderDDL := TStringList.Create;
  FParamList := TComponentList.Create;
  FReturnList := TComponentList.Create;
end;

destructor TibBTProcedure.Destroy;
begin
  FParamsExt.Free;
  FReturnsExt.Free;
  FHeaderDDL.Free;
  FParamList.Free;
  FReturnList.Free;
  inherited Destroy;
end;

procedure TibBTProcedure.Refresh;
begin
  FParamsExt.Clear;
  FReturnsExt.Clear;
  FParamList.Clear;
  FReturnList.Clear;
  inherited Refresh;
end;

function TibBTProcedure.GetCanExecute: Boolean;
begin
  Result := State in [csSource, csAlter];
end;

function TibBTProcedure.GetParamsExt: TStrings;
begin
  Result := FParamsExt;
end;

function TibBTProcedure.GetReturnsExt: TStrings;
begin
  Result := FReturnsExt;
end;

function TibBTProcedure.GetHeaderDDL: TStrings;
begin
  Result := FHeaderDDL;
end;

function TibBTProcedure.GetParam(Index: Integer): IibSHProcParam;
begin
  Assert(Index <= Pred(Params.Count), 'Index out of bounds');
  Supports(CreateParam(FParamList, IibSHProcParam, Index), IibSHProcParam, Result);
end;

function TibBTProcedure.GetReturn(Index: Integer): IibSHProcParam;
begin
  Assert(Index <= Pred(Returns.Count), 'Index out of bounds');
  Supports(CreateParam(FReturnList, IibSHProcParam, Index), IibSHProcParam, Result);
end;

procedure TibBTProcedure.Execute;
var
  vCodeNormalizer: IibSHCodeNormalizer;
  vExecutionSQL: string;
  S: string;
  I: Integer;
  vComponent: TSHComponent;
  vSQLEditorForm: IibSHSQLEditorForm;
  function GetNormalizeName(const ACaption: string): string;
  begin
    if Assigned(vCodeNormalizer) then
      Result := vCodeNormalizer.MetadataNameToSourceDDL(BTCLDatabase, ACaption)
    else
      Result := ACaption;
  end;
begin
  if CanExecute and Assigned(Designer.CurrentComponent) then
  begin
    Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer);
    if Params.Count > 0 then
    begin
      for I := 0 to Pred(Params.Count) do
       S := S + Format(':%s, ' , [GetNormalizeName(Params[I])]);
      Delete(S, Length(S) - 1, 2);
      vExecutionSQL := Format('%s(%s)', [GetNormalizeName(Caption), S]);
    end
    else
      vExecutionSQL := GetNormalizeName(Caption);
    if Returns.Count > 0 then
      vExecutionSQL := Format('SELECT * FROM %s', [vExecutionSQL])
    else
      vExecutionSQL := Format('EXECUTE PROCEDURE %s', [vExecutionSQL]);

    vComponent := Designer.FindComponent(Designer.CurrentComponent.OwnerIID, IibSHSQLEditor);
    if not Assigned(vComponent) then
      vComponent := Designer.CreateComponent(Designer.CurrentComponent.OwnerIID, IibSHSQLEditor, '');
    if Assigned(vComponent) then
    begin
      Designer.ChangeNotification(vComponent, SCallSQLText, opInsert);
      if vComponent.GetComponentFormIntf(IibSHSQLEditorForm, vSQLEditorForm) then
      begin
        vSQLEditorForm.InsertStatement(vExecutionSQL);
        Designer.JumpTo(InstanceIID, IibSHSQLEditor, vComponent.Caption);
      end;
    end;
  end;
end;

{ TibSHProcedureToolbarAction }

constructor TibSHProcedureToolbarAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  if Self is TibSHProcedureToolbarAction_Execute then Tag := 1;

  case Tag of
    1:
      begin
        Caption := Format('%s', ['Execute Procedure']);
        ShortCut := TextToShortCut('Ctrl+F9');
      end;
  end;
  if Tag <> 0 then Hint := Caption;
end;

function TibSHProcedureToolbarAction.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHProcedure);
end;

procedure TibSHProcedureToolbarAction.EventExecute(Sender: TObject);
begin
  case Tag of
    // Execute
    1: if Supports(Designer.CurrentComponent, IibSHProcedure) and
         (Designer.CurrentComponent as IibSHProcedure).CanExecute then
         (Designer.CurrentComponent as IibSHProcedure).Execute;
  end;
end;

procedure TibSHProcedureToolbarAction.EventHint(var HintStr: String;
  var CanShow: Boolean);
begin
end;

procedure TibSHProcedureToolbarAction.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     Supports(Designer.CurrentComponent, IibSHProcedure) and
     (AnsiSameText(Designer.CurrentComponentForm.CallString, SCallSourceDDL) or
      AnsiSameText(Designer.CurrentComponentForm.CallString, SCallAlterDDL)) then
  begin
    Visible := True;
    case Tag of
      // Execute
      1: Enabled := (Designer.CurrentComponent as IibSHProcedure).CanExecute;
    end;
  end else
  begin
    Visible := False;
    Enabled := False;
  end;
end;

end.

