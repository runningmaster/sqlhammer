unit ibSHDataTextFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDataCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TibSHDataTextForm = class(TibSHDataCustomForm)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;
  end;

var
  ibSHDataTextForm: TibSHDataTextForm;

implementation

{$R *.dfm}

{ TibSHDataTextForm }

constructor TibSHDataTextForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
end;

destructor TibSHDataTextForm.Destroy;
begin
  inherited Destroy;
end;

end.
