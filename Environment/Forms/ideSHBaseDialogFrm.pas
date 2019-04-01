unit ideSHBaseDialogFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, AppEvnts,
  SHDesignIntf, SHOptionsIntf;

type
  TBaseDialogForm = class(TForm, ISHModalForm)
    pnlOK: TPanel;
    pnlOKCancelHelp: TPanel;
    pnlOKCancel: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    btnOK3: TButton;
    btnCancel2: TButton;
    btnHelp1: TButton;
    btnOK2: TButton;
    btnCancel1: TButton;
    btnOK1: TButton;
    bvlLeft: TBevel;
    bvlTop: TBevel;
    bvlRight: TBevel;
    bvlBottom: TBevel;
    pnlClient: TPanel;
    ApplicationEvents1: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FButtonsMode: TButtonsMode;
    FEnabledOK: Boolean;
    FCaptionOK: string;
    FCaptionCancel: string;
    FCaptionHelp: string;
    FShowIndent: Boolean;
    FDesigner: ISHDesigner;
    FOnBeforeModalClose: TBeforeModalClose;
    FOnAfterModalClose: TAfterModalClose;
    FComponentForm: TSHComponentForm;
    function GetButtonsMode: TButtonsMode;
    procedure SetButtonsMode(Value: TButtonsMode);
    function GetEnabledOK: Boolean;
    procedure SetEnabledOK(Value: Boolean);
    function GetCaptionOK: string;
    procedure SetCaptionOK(Value: string);
    function GetCaptionCancel: string;
    procedure SetCaptionCancel(Value: string);
    function GetCaptionHelp: string;
    procedure SetCaptionHelp(Value: string);
    function GetShowIndent: Boolean;
    procedure SetShowIndent(Value: Boolean);
    function GetModalResultCode: TModalResult;
    procedure SetModalResultCode(Value: TModalResult);
    function GetOnBeforeModalClose: TBeforeModalClose;
    procedure SetOnBeforeModalClose(Value: TBeforeModalClose);
    function GetOnAfterModalClose: TAfterModalClose;
    procedure SetOnAfterModalClose(Value: TAfterModalClose);
    procedure SetComponentForm(Value: TSHComponentForm);
  protected
    procedure DoSaveSettings; virtual;
    procedure DoRestoreSettings; virtual;
    procedure DoOnIdle; virtual;
  public
    { Public declarations }
    procedure SetFormSize(const H, W: Integer);

    property ButtonsMode: TButtonsMode read GetButtonsMode write SetButtonsMode;
    property CaptionOK: string read GetCaptionOK write SetCaptionOK;
    property CaptionCancel: string read GetCaptionCancel write SetCaptionCancel;
    property CaptionHelp: string read GetCaptionHelp write SetCaptionHelp;
    property ShowIndent: Boolean read GetShowIndent write SetShowIndent;
    property ModalResultCode: TModalResult read GetModalResultCode write SetModalResultCode;
    property Designer: ISHDesigner read FDesigner;
    property ComponentForm: TSHComponentForm read FComponentForm write SetComponentForm;
    property OnBeforeModalClose: TBeforeModalClose read GetOnBeforeModalClose write SetOnBeforeModalClose;
    property OnAfterModalClose: TAfterModalClose read GetOnAfterModalClose write SetOnAfterModalClose;
  end;

var
  BaseDialogForm: TBaseDialogForm;

implementation

uses
  ideSHConsts, ideSHSysUtils, ideSHSystem;

{$R *.dfm}

{ TBaseDialogForm }

function TBaseDialogForm.GetButtonsMode: TButtonsMode;
begin
  Result := FButtonsMode;
end;

procedure TBaseDialogForm.SetButtonsMode(Value: TButtonsMode);
begin
  FButtonsMode := Value;
  pnlOK.Visible := FButtonsMode = bmOK;
  pnlOKCancel.Visible := FButtonsMode = bmOKCancel;
  pnlOKCancelHelp.Visible := FButtonsMode = bmOKCancelHelp;
end;

function TBaseDialogForm.GetCaptionOK: string;
begin
  Result := FCaptionOK;
end;

procedure TBaseDialogForm.SetCaptionOK(Value: string);
begin
  FCaptionOK := Value;
  btnOK1.Caption := FCaptionOK;
  btnOK2.Caption := FCaptionOK;
  btnOK3.Caption := FCaptionOK;
end;

function TBaseDialogForm.GetEnabledOK: Boolean;
begin
  Result := FEnabledOK;
end;

procedure TBaseDialogForm.SetEnabledOK(Value: Boolean);
begin
  FEnabledOK := Value;
  btnOK1.Enabled := FEnabledOK;
  btnOK2.Enabled := FEnabledOK;
  btnOK3.Enabled := FEnabledOK;
end;

function TBaseDialogForm.GetCaptionCancel: string;
begin
  Result := FCaptionCancel;
end;

procedure TBaseDialogForm.SetCaptionCancel(Value: string);
begin
  FCaptionCancel := Value;
  btnCancel1.Caption := FCaptionCancel;
  btnCancel2.Caption := FCaptionCancel;
end;

function TBaseDialogForm.GetCaptionHelp: string;
begin
  Result := FCaptionHelp;
end;

procedure TBaseDialogForm.SetCaptionHelp(Value: string);
begin
  FCaptionHelp := Value;
  btnHelp1.Caption := FCaptionHelp;
end;

procedure TBaseDialogForm.FormCreate(Sender: TObject);
begin
  AntiLargeFont(Self);
  BorderIcons := [biSystemMenu];
  Position := poScreenCenter;
  SHSupports(ISHDesigner, FDesigner);
  
  DoRestoreSettings;
  BorderStyle := bsSizeable;

  pnlClient.Caption := EmptyStr;

  ButtonsMode := bmOKCancel;
  CaptionOK := Format('%s', [SCaptionButtonOK]);
  CaptionCancel := Format('%s', [SCaptionButtonCancel]);
  CaptionHelp := Format('%s', [SCaptionButtonHelp]);
  ShowIndent := True;
end;

procedure TBaseDialogForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  vModalResult: TModalResult;
begin
  vModalResult := ModalResult;
  try
    if Assigned(ComponentForm) and Assigned(FOnBeforeModalClose) then
      FOnBeforeModalClose(Sender, vModalResult, Action);
  finally
    ModalResult := vModalResult;
  end;
  DoSaveSettings;
end;

function TBaseDialogForm.GetShowIndent: Boolean;
begin
  Result := FShowIndent;
end;

procedure TBaseDialogForm.SetShowIndent(Value: Boolean);
begin
  FShowIndent := Value;

  bvlLeft.Visible := FShowIndent;
  bvlTop.Visible := FShowIndent;
  bvlRight.Visible := FShowIndent;
end;

function TBaseDialogForm.GetModalResultCode: TModalResult;
begin
  Result := ModalResult;
end;

procedure TBaseDialogForm.SetModalResultCode(Value: TModalResult);
begin
  ModalResult := Value;
end;

function TBaseDialogForm.GetOnBeforeModalClose: TBeforeModalClose;
begin
  Result := FOnBeforeModalClose;
end;

procedure TBaseDialogForm.SetOnBeforeModalClose(Value: TBeforeModalClose);
begin
  FOnBeforeModalClose := Value;
end;

function TBaseDialogForm.GetOnAfterModalClose: TAfterModalClose;
begin
  Result := FOnAfterModalClose;
end;

procedure TBaseDialogForm.SetOnAfterModalClose(Value: TAfterModalClose);
begin
  FOnAfterModalClose := Value;
end;

procedure TBaseDialogForm.SetComponentForm(Value: TSHComponentForm);
begin
  FComponentForm := Value;
  if Assigned(FComponentForm) then
  begin
    Caption := FComponentForm.Caption;
    DoRestoreSettings;
    FComponentForm.Show;
  end;
end;

procedure TBaseDialogForm.SetFormSize(const H, W: Integer);
begin
  Self.Height := H;
  Self.Width := W;
end;

procedure TBaseDialogForm.DoSaveSettings;
var
  TmpList: TStringList;
begin
  TmpList := TStringList.Create;
  TmpList.Add('Width');
  TmpList.Add('Height');
  try
    if Assigned(ComponentForm) then
    begin
      ComponentForm.Align := alNone;
      ComponentForm.Height := Self.Height;
      ComponentForm.Width := Self.Width;
      WritePropValuesToFile(GetFilePath(SFileForms), SSectionForms, ComponentForm, TmpList);
    end else
      WritePropValuesToFile(GetFilePath(SFileForms), SSectionForms, Self, TmpList);
  finally
    TmpList.Free;
  end;
end;

procedure TBaseDialogForm.DoRestoreSettings;
var
  TmpList: TStringList;
  H1, W1, H2, W2: Integer;
begin
  TmpList := TStringList.Create;
  TmpList.Add('Width');
  TmpList.Add('Height');
  try
    if Assigned(ComponentForm) then
    begin
      ComponentForm.Align := alNone;

      H1 := ComponentForm.Height;
      W1 := ComponentForm.Width;
      ReadPropValuesFromFile(GetFilePath(SFileForms), SSectionForms, ComponentForm, TmpList);
      H2 := ComponentForm.Height;
      W2 := ComponentForm.Width;

      Self.Width := ComponentForm.Width;
      if (H1 = H2) and (W1 = W2) then
        Self.Height := FComponentForm.Height + bvlBottom.Height + pnlOK.Height
      else
        Self.Height := ComponentForm.Height;

      ComponentForm.Align := alClient;
    end else
      ReadPropValuesFromFile(GetFilePath(SFileForms), SSectionForms, Self, TmpList);
  finally
    TmpList.Free;
  end;
end;

procedure TBaseDialogForm.DoOnIdle;
begin
// Empty
end;

procedure TBaseDialogForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  DoOnIdle;
end;

procedure TBaseDialogForm.FormActivate(Sender: TObject);
begin
  if Assigned(ComponentForm) then
  begin
    FComponentForm.BringToTop;
    if Assigned(ComponentForm.ActiveControl) and ComponentForm.ActiveControl.CanFocus then
      FComponentForm.ActiveControl.SetFocus;
  end;
end;

procedure TBaseDialogForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(ComponentForm) then
    if (Key = VK_RETURN) and (ssCtrl in Shift) then ModalResult := mrOK;
end;

end.


