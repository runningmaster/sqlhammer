unit ibSHDataReportFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHDataCustomFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TibSHDataReportForm = class(TibSHDataCustomForm)
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
  ibSHDataReportForm: TibSHDataReportForm;

implementation

{$R *.dfm}

{ TibSHDataReportForm }

constructor TibSHDataReportForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
end;

destructor TibSHDataReportForm.Destroy;
begin
  inherited Destroy;
end;

end.
