unit ibSHRegisterFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, TypInfo, AppEvnts, ELPropInsp;

type
  TRegisterType = (rtUnknown, rtServer, rtDatabase, rtCreate, rtInfo);

  TibBTRegisterForm = class(TibBTComponentForm)
    Panel1: TPanel;
    Panel2: TPanel;
    CheckBox1: TCheckBox;
    PropInspector: TELPropertyInspector;
    Bevel1: TBevel;
    Button1: TButton;
    ApplicationEvents1: TApplicationEvents;
    procedure PropInspectorFilterProp(Sender: TObject;
      AInstance: TPersistent; APropInfo: PPropInfo;
      var AIncludeProp: Boolean);
    procedure PropInspectorGetEditorClass(Sender: TObject;
      AInstance: TPersistent; APropInfo: PPropInfo;
      var AEditorClass: TELPropEditorClass);
    procedure Panel2Resize(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FPropSavedList: TStrings;
    FRegisterType: TRegisterType;
    FTestConnection: ISHTestConnection;
    procedure DoShowProps(AInspector: TELPropertyInspector; APersistent: TPersistent);
  protected
    procedure DoOnIdle; override;
    procedure DoOnBeforeModalClose(Sender: TObject; var ModalResult: TModalResult;
      var Action: TCloseAction); override;
    procedure DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    function ReceiveEvent(AEvent: TSHEvent): Boolean; override;
  end;

var
  ibBTRegisterForm: TibBTRegisterForm;

implementation

uses
  ibSHConsts;

{$R *.dfm}

{ TibBTRegisterForm }

constructor TibBTRegisterForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  FPropSavedList := TStringList.Create;
  FRegisterType := TRegisterType(Component.Tag);
  Supports(Component, ISHTestConnection, FTestConnection);
  DoShowProps(PropInspector, Component);
  Designer.GetPropValues(Component, Component.ClassName, FPropSavedList);
  if Assigned(ModalForm) then
  begin
//    ModalForm.EnabledOK := False;
    SetFormSize(380, 440);
    if Assigned(Parent) and (Parent is TPanel) then TPanel(Parent).BevelInner := bvNone;
    case FRegisterType of
      rtServer: ModalForm.CaptionOK := Format('%s', [SBtnRegister]);
      rtDatabase: ModalForm.CaptionOK := Format('%s', [SBtnRegister]);
      rtCreate: ModalForm.CaptionOK := Format('%s', [SBtnCreate]);
      rtInfo: ModalForm.CaptionOK := Format('%s', [SBtnSave]);
    end;
  end;

  case FRegisterType of
    rtServer:
      begin
        Caption := Format('%s', [SCallRegisterServer]);
        CheckBox1.Caption := Format('%s', [SBtnRegisterAfterRegister]);
      end;
    rtDatabase:
      begin
        Caption := Format('%s', [SCallRegisterDatabase]);
        CheckBox1.Caption := Format('%s', [SBtnConnectAfterRegister]);
        CheckBox1.Checked := False;
      end;
    rtCreate:
      begin
        Caption := Format('%s', [SCallCreateDatabase]);
        CheckBox1.Caption := Format('%s', [SBtnRegisterAfterCreate]);
      end;
    rtInfo:
      begin
        Caption := Format('%s', [SCallRegisterInfo]);
        CheckBox1.Visible := False;
      end;
  end;

  if FRegisterType = rtInfo then
  begin
    if Supports(Component, ISHServer) then PropInspector.ReadOnly := Designer.CurrentServerInUse;
    if Supports(Component, ISHDatabase) then PropInspector.ReadOnly := Designer.CurrentDatabaseInUse;
    Panel2.Visible := not PropInspector.ReadOnly;
  end;
end;

destructor TibBTRegisterForm.Destroy;
begin
  FPropSavedList.Free;
  inherited Destroy;
end;

procedure TibBTRegisterForm.DoShowProps(AInspector: TELPropertyInspector;
  APersistent: TPersistent);
var
  AList: TList;
begin
  AList := TList.Create;
  try
    if Assigned(AInspector) then
      with AInspector do
      begin
        BeginUpdate;
        if Assigned(APersistent) then
        begin
          AList.Add(APersistent);
          Objects.SetObjects(AList);
        end else
          Objects.Clear;
        EndUpdate;
      end;
  finally
    AList.Free;
  end;
end;

function TibBTRegisterForm.ReceiveEvent(AEvent: TSHEvent): Boolean;
begin
  case AEvent.Event of
    SHE_REFRESH_OBJECT_INSPECTOR: PropInspector.UpdateItems;
  end;
  Result := True;
end;

procedure TibBTRegisterForm.DoOnIdle;
begin
  if not (csDestroying in Self.ComponentState) then
  begin
    Button1.Enabled := FTestConnection.CanTestConnection;
    if Assigned(ModalForm) then
    begin
      case FRegisterType of
        rtServer, rtDatabase: ModalForm.EnabledOK := True;
        rtCreate: ModalForm.EnabledOK := True;
        rtInfo: ModalForm.EnabledOK := True;
      end;
    end;
  end;
end;

procedure TibBTRegisterForm.DoOnBeforeModalClose(Sender: TObject; var ModalResult: TModalResult;
  var Action: TCloseAction);
begin
  if ModalResult = mrOK then
  begin
    PropInspector.Perform(CM_EXIT, 0, 0);
    if CheckBox1.Checked then Component.Tag := 5;
  end else
    Designer.SetPropValues(Component, Component.ClassName, FPropSavedList);
end;

procedure TibBTRegisterForm.DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult);
begin
  inherited DoOnAfterModalClose(Sender, ModalResult);
end;

procedure TibBTRegisterForm.PropInspectorFilterProp(Sender: TObject;
  AInstance: TPersistent; APropInfo: PPropInfo; var AIncludeProp: Boolean);
begin
  AIncludeProp := Assigned(Component) and Component.CanShowProperty(APropInfo.Name);
end;

procedure TibBTRegisterForm.PropInspectorGetEditorClass(
  Sender: TObject; AInstance: TPersistent; APropInfo: PPropInfo;
  var AEditorClass: TELPropEditorClass);
begin
  AEditorClass := TELPropEditorClass(Designer._GetProxiEditorClass(
    TELPropertyInspector(Sender), AInstance, APropInfo));
end;

procedure TibBTRegisterForm.Panel2Resize(Sender: TObject);
begin
  CheckBox1.Width := CheckBox1.Parent.ClientWidth;
end;

procedure TibBTRegisterForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  DoOnIdle;
end;

procedure TibBTRegisterForm.Button1Click(Sender: TObject);
begin
  if Assigned(FTestConnection) and FTestConnection.CanTestConnection then
    FTestConnection.TestConnection;
end;

end.
