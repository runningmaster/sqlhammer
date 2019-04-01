unit ibSHUserFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ELPropInsp, ExtCtrls, TypInfo;

type
  TibSHUserForm = class(TibBTComponentForm)
    Panel1: TPanel;
    PropInspector: TELPropertyInspector;
    procedure PropInspectorFilterProp(Sender: TObject;
      AInstance: TPersistent; APropInfo: PPropInfo;
      var AIncludeProp: Boolean);
    procedure PropInspectorGetEditorClass(Sender: TObject;
      AInstance: TPersistent; APropInfo: PPropInfo;
      var AEditorClass: TELPropEditorClass);
  private
    { Private declarations }
    FUserIntf: IibSHUser;
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

    property User: IibSHUser read FUserIntf;
  end;

var
  ibSHUserForm: TibSHUserForm;

implementation

{$R *.dfm}

{ TibSHUserForm }

constructor TibSHUserForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHUser, FUserIntf);
  DoShowProps(PropInspector, Component);
  if Assigned(ModalForm) then
  begin
    SetFormSize(240, 340);
    if Component.CanShowProperty('UserName') then
      Caption := Format('%s', ['Add New User'])
    else
      Caption := Format('Modify User "%s"', [User.UserName]);
  end;
end;

destructor TibSHUserForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHUserForm.DoShowProps(AInspector: TELPropertyInspector; APersistent: TPersistent);
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

procedure TibSHUserForm.DoOnIdle;
begin
end;

procedure TibSHUserForm.DoOnBeforeModalClose(Sender: TObject; var ModalResult: TModalResult;
  var Action: TCloseAction);
begin
  if ModalResult = mrOK then
    PropInspector.Perform(CM_EXIT, 0, 0);
end;

procedure TibSHUserForm.DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult);
begin
  inherited DoOnAfterModalClose(Sender, ModalResult);
end;

function TibSHUserForm.ReceiveEvent(AEvent: TSHEvent): Boolean;
begin
  case AEvent.Event of
    SHE_REFRESH_OBJECT_INSPECTOR: PropInspector.UpdateItems;
  end;
  Result := True;
end;

procedure TibSHUserForm.PropInspectorFilterProp(Sender: TObject;
  AInstance: TPersistent; APropInfo: PPropInfo; var AIncludeProp: Boolean);
begin
  AIncludeProp := Assigned(Component) and Component.CanShowProperty(APropInfo.Name);
end;

procedure TibSHUserForm.PropInspectorGetEditorClass(Sender: TObject;
  AInstance: TPersistent; APropInfo: PPropInfo;
  var AEditorClass: TELPropEditorClass);
begin
  AEditorClass := TELPropEditorClass(Designer._GetProxiEditorClass(
    TELPropertyInspector(Sender), AInstance, APropInfo));
end;

end.
