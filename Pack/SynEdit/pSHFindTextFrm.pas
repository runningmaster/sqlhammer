unit pSHFindTextFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  pSHConsts, pSHIntf, pSHCommon, Buttons, Menus;

type

  TBTFindTextOption = (ftoCaseSencitive, ftoWholeWordsOnly, ftoRegularExpressions,
                       ftoFindInSelectedText, ftoBackwardDirection, ftoEntireScopOrigin,
                       ftoReplaceAll, ftoPromptOnReplace);

  TBTFindTextOptions = set of TBTFindTextOption;

type
  TpSHFindTextForm = class(TForm)
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
    lbFindText: TLabel;
    cbFindText: TComboBox;
    sbInsertRegExp: TSpeedButton;
    gbOptions: TGroupBox;
    rgDirection: TRadioGroup;
    rgScope: TRadioGroup;
    rgOrigin: TRadioGroup;
    cbCaseSensitive: TCheckBox;
    cbWholeWordsOnly: TCheckBox;
    cbRegularExpressions: TCheckBox;
    pmRegExpr: TPopupMenu;
    Beginofline1: TMenuItem;
    Endofline1: TMenuItem;
    Anyletterordigit1: TMenuItem;
    Anyletterordigit2: TMenuItem;
    NoreletternoredigitW1: TMenuItem;
    Anydigit1: TMenuItem;
    NotdigitD1: TMenuItem;
    Anyspace1: TMenuItem;
    NotspaceS1: TMenuItem;
    Edgeofwordb1: TMenuItem;
    NotedgeofwordB1: TMenuItem;
    Hexx001: TMenuItem;
    abt1: TMenuItem;
    Sybolset1: TMenuItem;
    Repiter1: TMenuItem;
    Zeroormoretimes1: TMenuItem;
    Oneormoretimes1: TMenuItem;
    Zerooronetimes1: TMenuItem;
    Exactlyntimesgreedyn1: TMenuItem;
    Notlessthenntimesgreedyn1: TMenuItem;
    Fromntomtimesgreedyn1: TMenuItem;
    Fromntomtimesgreedynm1: TMenuItem;
    Oneormoretimes2: TMenuItem;
    Zerooronetimes2: TMenuItem;
    Exactlyntimesgreedyn2: TMenuItem;
    Notlessthenntimesgreedyn2: TMenuItem;
    Fromntomtimesgreedynm2: TMenuItem;
    Variantgrouptemplate1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure cbRegularExpressionsClick(Sender: TObject);
    procedure sbInsertRegExpClick(Sender: TObject);
    procedure pmRegExprItemClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FShowIndent: Boolean;
    FFindReplaceHistory: IpSHUserInputHistory;
    function GetShowIndent: Boolean;
    procedure SetShowIndent(Value: Boolean);
    function GetFindText: string;
    procedure SetFindText(const Value: string);
    procedure SetFindReplaceHistory(const Value: IpSHUserInputHistory);
  protected
    function GetFindTextOptions: TBTFindTextOptions; virtual;
    procedure SetFindTextOptions(const Value: TBTFindTextOptions); virtual;
    procedure DoSaveSettings; virtual;
    procedure DoRestoreSettings; virtual;
  public
    { Public declarations }
    property ShowIndent: Boolean read GetShowIndent write SetShowIndent;

    property FindReplaceHistory: IpSHUserInputHistory
      read FFindReplaceHistory write SetFindReplaceHistory;
    property FindTextOptions: TBTFindTextOptions read GetFindTextOptions
      write SetFindTextOptions;
    property FindText: string read GetFindText write SetFindText;
  end;

var
  pSHFindTextForm: TpSHFindTextForm;

implementation

{$R *.dfm}

{ TBaseDialogForm }

procedure TpSHFindTextForm.FormCreate(Sender: TObject);
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

procedure TpSHFindTextForm.cbRegularExpressionsClick(Sender: TObject);
begin
  sbInsertRegExp.Enabled := cbRegularExpressions.Checked;
end;

function TpSHFindTextForm.GetShowIndent: Boolean;
begin
  Result := FShowIndent;
end;

procedure TpSHFindTextForm.SetShowIndent(Value: Boolean);
begin
  FShowIndent := Value;

  bvlLeft.Visible := FShowIndent;
  bvlTop.Visible := FShowIndent;
  bvlRight.Visible := FShowIndent;
end;

function TpSHFindTextForm.GetFindText: string;
begin
  Result := cbFindText.Text;
end;

procedure TpSHFindTextForm.SetFindText(const Value: string);
begin
  cbFindText.Text := Value;
end;

procedure TpSHFindTextForm.SetFindReplaceHistory(
  const Value: IpSHUserInputHistory);
begin
  if Assigned(Value) then
  begin
    FFindReplaceHistory := Value;
    DoRestoreSettings;
  end
  else
  begin
    DoSaveSettings;
    FFindReplaceHistory := Value;
  end;
end;

function TpSHFindTextForm.GetFindTextOptions: TBTFindTextOptions;
begin
  Result := [];
  if cbCaseSensitive.Checked then
    Include(Result, ftoCaseSencitive);
  if cbWholeWordsOnly.Checked then
    Include(Result, ftoWholeWordsOnly);
  if cbRegularExpressions.Checked then
    Include(Result, ftoRegularExpressions);
  if rgScope.ItemIndex = 1 then
    Include(Result, ftoFindInSelectedText);
  if rgDirection.ItemIndex = 1 then
    Include(Result, ftoBackwardDirection);
  if rgOrigin.ItemIndex = 1 then
    Include(Result, ftoEntireScopOrigin);
end;

procedure TpSHFindTextForm.SetFindTextOptions(
  const Value: TBTFindTextOptions);
begin
  if ftoCaseSencitive in Value then
    cbCaseSensitive.Checked := True
  else
    cbCaseSensitive.Checked := False;
  if ftoWholeWordsOnly in Value then
    cbWholeWordsOnly.Checked := True
  else
    cbWholeWordsOnly.Checked := False;
  if ftoRegularExpressions in Value then
    cbRegularExpressions.Checked := True
  else
    cbRegularExpressions.Checked := False;
  if ftoFindInSelectedText in Value then
    rgScope.ItemIndex := 1
  else
    rgScope.ItemIndex := 0;
  if ftoBackwardDirection in Value then
    rgDirection.ItemIndex := 1
  else
    rgDirection.ItemIndex := 0;
  if ftoEntireScopOrigin in Value then
    rgOrigin.ItemIndex := 1
  else
    rgOrigin.ItemIndex := 0;
end;

procedure TpSHFindTextForm.DoSaveSettings;
begin
  if ((ModalResult = mrOk) or (ModalResult = mrYesToAll)) and
     Assigned(FFindReplaceHistory) then
    FFindReplaceHistory.AddToFindHistory(FindText);
end;

procedure TpSHFindTextForm.DoRestoreSettings;
begin
  if Assigned(FFindReplaceHistory) then
    cbFindText.Items.Text := FFindReplaceHistory.FindHistory.Text
end;

procedure TpSHFindTextForm.sbInsertRegExpClick(Sender: TObject);
var
  P: TPoint;
begin
  P := ClientToScreen(Point(sbInsertRegExp.Left,
    sbInsertRegExp.Top + sbInsertRegExp.Height));
  pmRegExpr.Popup(P.X + 4, P.Y + 4);
end;

procedure TpSHFindTextForm.pmRegExprItemClick(Sender: TObject);
var
  S: string;
  I: Integer;
begin
  S := (Sender as TMenuItem).Caption;
  I := Pos('''', S);
  S := System.Copy(S, I + 1, MaxInt);
  I := Pos('''', S);
  S := System.Copy(S, 1, I - 1);
  cbFindText.Text := cbFindText.Text + S; 
end;

procedure TpSHFindTextForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  FindReplaceHistory := nil;
  CanClose := True;
end;

end.
