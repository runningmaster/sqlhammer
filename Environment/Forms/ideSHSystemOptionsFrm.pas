unit ideSHSystemOptionsFrm;

interface

uses
  SHDesignIntf, SHEvents,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ELPropInsp, ExtCtrls, TypInfo;

type
  TSystemOptionsForm = class(TSHComponentForm)
    Panel1: TPanel;
    PropInspector: TELPropertyInspector;
    procedure PropInspectorFilterProp(Sender: TObject;
      AInstance: TPersistent; APropInfo: PPropInfo;
      var AIncludeProp: Boolean);
    procedure PropInspectorGetEditorClass(Sender: TObject;
      AInstance: TPersistent; APropInfo: PPropInfo;
      var AEditorClass: TELPropEditorClass);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure DoShowProps(AInspector: TELPropertyInspector; APersistent: TPersistent);
  public
    { Public declarations }
    { ISHEventReceiver }
    function ReceiveEvent(AEvent: TSHEvent): Boolean; override;
  end;

var
  SystemOptionsForm: TSystemOptionsForm;

implementation

uses
  ideSHProxiPropEditors;

{$R *.dfm}

{ TSystemOptionsForm }

function TSystemOptionsForm.ReceiveEvent(AEvent: TSHEvent): Boolean;
begin
  case AEvent.Event of
    SHE_OPTIONS_DEFAULTS_RESTORED,
    SHE_REFRESH_OBJECT_INSPECTOR: PropInspector.UpdateItems;
  end;
  Result := True;
end;

procedure TSystemOptionsForm.FormCreate(Sender: TObject);
begin
  if Assigned(Component) then DoShowProps(PropInspector, Component);
end;

procedure TSystemOptionsForm.FormDestroy(Sender: TObject);
begin
  PropInspector.Perform(CM_EXIT, 0, 0);
end;

procedure TSystemOptionsForm.DoShowProps(AInspector: TELPropertyInspector;
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

procedure TSystemOptionsForm.PropInspectorFilterProp(
  Sender: TObject; AInstance: TPersistent; APropInfo: PPropInfo;
  var AIncludeProp: Boolean);
begin
  if Assigned(Component) and not (AInstance is TFont) then
    AIncludeProp := Component.CanShowProperty(APropInfo.Name);
end;

procedure TSystemOptionsForm.PropInspectorGetEditorClass(Sender: TObject;
  AInstance: TPersistent; APropInfo: PPropInfo;
  var AEditorClass: TELPropEditorClass);
begin
  AEditorClass := BTGetProxiEditorClass(TELPropertyInspector(Sender),
    AInstance, APropInfo);
end;

end.
 
