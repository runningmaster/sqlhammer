unit pSHGotoLineNumberFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  pSHConsts, pSHIntf, pSHCommon;

type
  TpSHGotoLineNumberForm = class(TForm)
    pnlOKCancelHelp: TPanel;
    Bevel1: TBevel;
    Panel6: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    bvlLeft: TBevel;
    bvlTop: TBevel;
    bvlRight: TBevel;
    bvlBottom: TBevel;
    pnlClient: TPanel;
    cbLineNumber: TComboBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FShowIndent: Boolean;
    FGotoLineNumberHistory: IpSHUserInputHistory;
    FGotoLineNumberValue: Integer;
    FMaxLineNumber: Integer;
    function GetShowIndent: Boolean;
    procedure SetShowIndent(Value: Boolean);
    procedure SetGotoLineNumberHistory(const Value: IpSHUserInputHistory);
  protected
    procedure DoSaveSettings;
    procedure DoRestoreSettings;
  public
    { Public declarations }
    property ShowIndent: Boolean read GetShowIndent write SetShowIndent;

    property GotoLineNumberHistory: IpSHUserInputHistory
      read FGotoLineNumberHistory write SetGotoLineNumberHistory;
    property MaxLineNumber: Integer read FMaxLineNumber write FMaxLineNumber;
    property GotoLineNumberValue: Integer read FGotoLineNumberValue;
  end;

var
  pSHGotoLineNumberForm: TpSHGotoLineNumberForm;

implementation

{$R *.dfm}

{ TpSHGotoLineNumberForm }

procedure TpSHGotoLineNumberForm.FormCreate(Sender: TObject);
begin
  AntiLargeFont(Self);
  BorderIcons := [biSystemMenu];
  Position := poScreenCenter;

  pnlClient.Caption := '';

//  CaptionOK := Format('%s', [SCaptionButtonOK]);
//  CaptionCancel := Format('%s', [SCaptionButtonCancel]);
//  CaptionHelp := Format('%s', [SCaptionButtonHelp]);
  ShowIndent := True;

end;

procedure TpSHGotoLineNumberForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  S: string;
begin
  if ModalResult = mrOK then
  begin
    S := cbLineNumber.Text;
    FGotoLineNumberValue := StrToIntDef(S, 0);
    if (not ((FGotoLineNumberValue >= 1) and
             (FGotoLineNumberValue <= MaxLineNumber))) then
    begin
      MessageDlg(Format(SLineNumberOutOfRange, [MaxLineNumber]), mtWarning,
        [mbOK], 0);
      CanClose := False;
    end
    else
    begin
      DoSaveSettings;
      GotoLineNumberHistory := nil;
    end;
  end;
end;

function TpSHGotoLineNumberForm.GetShowIndent: Boolean;
begin
  Result := FShowIndent;
end;

procedure TpSHGotoLineNumberForm.SetShowIndent(Value: Boolean);
begin
  FShowIndent := Value;

  bvlLeft.Visible := FShowIndent;
  bvlTop.Visible := FShowIndent;
  bvlRight.Visible := FShowIndent;
end;

procedure TpSHGotoLineNumberForm.SetGotoLineNumberHistory(
  const Value: IpSHUserInputHistory);
begin
  FGotoLineNumberHistory := Value;
  DoRestoreSettings;
end;

procedure TpSHGotoLineNumberForm.DoSaveSettings;
begin
  if Assigned(FGotoLineNumberHistory) then
    FGotoLineNumberHistory.AddToGotoLineNumberHistory(IntToStr(GotoLineNumberValue));
end;

procedure TpSHGotoLineNumberForm.DoRestoreSettings;
begin
  if Assigned(FGotoLineNumberHistory) then
  begin
    cbLineNumber.Items.Text := FGotoLineNumberHistory.GotoLineNumberHistory.Text;
    if FGotoLineNumberHistory.GotoLineNumberHistory.Count > 0 then
      cbLineNumber.ItemIndex := 0;
  end;
end;

end.
