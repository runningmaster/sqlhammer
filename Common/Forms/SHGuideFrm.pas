unit SHGuideFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, ExtCtrls, SHDocVw,          z
  // SQLHammer
  SHDesignIntf;

type
  TSHGuideForm = class(TSHComponentForm)
    WebBrowser1: TWebBrowser;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ReceiveEvent(AEvent: TSHEvent): Boolean; override;
  end;

var
  SHGuideForm: TSHGuideForm;

implementation

uses
  SHGuide;

{$R *.dfm}

{ TBTGuideForm }

function TSHGuideForm.ReceiveEvent(AEvent: TSHEvent): Boolean;
begin
  Result := inherited ReceiveEvent(AEvent);
end;

procedure TSHGuideForm.FormShow(Sender: TObject);
var
  S: string;
begin
  if Supports(Component, ISHWelcome) then S := (Component as ISHWelcome).StartPage;
  if Supports(Component, ISHUseGuide) then S := (Component as ISHUseGuide).StartPage;
  if Supports(Component, ISHDevGuide) then S := (Component as ISHDevGuide).StartPage;

  WebBrowser1.Navigate(S);

  if Assigned(Parent) and (Parent is TPanel) then
    TPanel(Parent).BevelInner := bvNone;
end;

end.

