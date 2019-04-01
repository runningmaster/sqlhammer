unit ideSHRestoreConnectionFrm;

interface

uses
  SHDesignIntf,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ideSHBaseDialogFrm, AppEvnts, StdCtrls, ExtCtrls;


type
  TRestoreConnectionForm = class(TBaseDialogForm)
    Timer1: TTimer;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Panel2: TPanel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  RestoreConnectionForm: TRestoreConnectionForm;

procedure RestoreConnection(ADatabase: TSHComponent);

implementation

uses
  ideSHSystem, ideSHConsts;

{$R *.dfm}

procedure RestoreConnection(ADatabase: TSHComponent);
var
  RestoreConnectionForm: TRestoreConnectionForm;
  ISHDatabaseIntf: ISHDatabase;
  Reconnect: Boolean;
begin
  RestoreConnectionForm := TRestoreConnectionForm.Create(Application);
  try
    if Supports(ADatabase, ISHDatabase, ISHDatabaseIntf) then
    begin
      RestoreConnectionForm.Memo1.Lines.Add(ISHDatabaseIntf.Caption);
      RestoreConnectionForm.Memo1.Lines.Add(ISHDatabaseIntf.ConnectPath);
      RestoreConnectionForm.Memo1.Lines.Add(SLineBreak);

      RestoreConnectionForm.Memo1.Lines.Add(Format('%s', ['Please, choose your preferable action:']));
      RestoreConnectionForm.Memo1.Lines.Add(Format('%s', ['1. Restore connection']));
      RestoreConnectionForm.Memo1.Lines.Add(Format('%s', ['2. Close connections and all linked objects']));
    end;
    Reconnect := IsPositiveResult(RestoreConnectionForm.ShowModal);
  finally
    FreeAndNil(RestoreConnectionForm);
  end;

  if Reconnect then
  begin
    if not DesignerIntf.ReconnectTo(ADatabase) then
    begin
      DesignerIntf.ShowMsg(Format('%s%s%s', ['It''s impossible to reconnect to database', SLineBreak, 'The connection will be closed']), mtWarning);
      DesignerIntf.DisconnectFrom(ADatabase);
    end;
  end else
    DesignerIntf.DisconnectFrom(ADatabase);
end;

procedure TRestoreConnectionForm.FormCreate(Sender: TObject);
begin
  SetFormSize(340, 420);
  Position := poScreenCenter;
  inherited;
  ButtonsMode := bmOKCancel;
  Caption := Format('%s', [SCaptionDialogLostConnection]);
  CaptionOK := Format('%s', [SCaptionButtonRestore]);
  CaptionCancel := Format('%s', [SCaptionButtonClose]);
end;

procedure TRestoreConnectionForm.Timer1Timer(Sender: TObject);
begin
  inherited;
  Image1.Visible := not Image1.Visible;
end;

end.
