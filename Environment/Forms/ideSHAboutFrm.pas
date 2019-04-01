unit ideSHAboutFrm;
                         
interface

{$I .inc}

uses
  SHDesignIntf,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ideSHBaseDialogFrm, StdCtrls, ExtCtrls, AppEvnts, jpeg;

type
  TAboutForm = class(TBaseDialogForm)
    Panel1: TPanel;
    Bevel4: TBevel;
    Label1: TLabel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Memo1: TMemo;
    Panel2: TPanel;
    Image1: TImage;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    lbVersion: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FIsAbout: Boolean;
    procedure SetIsAbout(Value: Boolean);
  public
    { Public declarations }
    property IsAbout: Boolean read FIsAbout write SetIsAbout;
  end;

//var
//  AboutForm: TAboutForm;

procedure ShowAboutForm;

implementation

uses
{$IFDEF USE_ASPROTECT}
  aspr_api,
{$ENDIF}
  ideSHConsts, ideSHSysUtils, ideSHSystem, sysSHVersionInfo;

{$R *.dfm}

{$IFDEF USE_ASPROTECT}
{$J+}
const
  AsprUserKey: PChar = nil;
  AsprUserName: PChar = nil;
  AsprTrialDaysTotal : DWORD = DWORD(-1);
  AsprTrialDaysLeft : DWORD = DWORD(-1);
{$ENDIF}

procedure ShowAboutForm;
var
  AboutForm: TAboutForm;
begin
  AboutForm := TAboutForm.Create(Application);
  AboutForm.IsAbout := True;
  try
    AboutForm.ShowModal;
  finally
    FreeAndNil(AboutForm);
  end;
end;

{ TAboutForm }

procedure TAboutForm.FormCreate(Sender: TObject);
begin        
  inherited;
  BorderStyle := bsDialog;
  Position := poScreenCenter;
  SetFormSize(380, 500);
  ButtonsMode := bmOK;

  Panel1.Color := clWhite;
  Panel2.Color := clWhite;
  lbVersion.Color := clWhite;
  Memo1.Color := clWhite;
end;                                                

procedure TAboutForm.SetIsAbout(Value: Boolean);
var
  S: string;
begin
  FIsAbout := Value;
  Memo1.Visible := False;

  Memo1.Lines.Clear;
  if FIsAbout then
  begin
    Caption := Format('%s', ['About']);
    Button1.Caption := Format('%s', ['Credits >>']);

    S:=VersionString(ParamStr(0));
    lbVersion.Text:=S;
{$IFDEF ENTERPRISE_EDITION}
//    S := Format('%s  %s', [SAppVersion, SAppEnterpriseEdition]);
//    S := Format('%s '#13#10' %s', [S, SAppEnterpriseEdition]);
    Label2.Caption:=SAppEnterpriseEdition;
  {$IFNDEF USE_ASPROTECT}
//    S := Format('%s  (Experimental)', [S]);
    Label2.Caption:=Label2.Caption+' (Experimental)';
  {$ENDIF}
{$ELSE}
//    S := Format('%s  %s', [SAppVersion, SAppCommunityEdition]);
//    S := Format('%s '#13#10' %s', [S, SAppCommunityEdition]);
    Label2.Caption:=SAppCommunityEdition;
{$ENDIF}

{$IFDEF USE_JCLDEBUG}
//    S := Format('%s  (DEBUG)', [S]);
    Label2.Caption:=Label2.Caption+' (DEBUG)';
{$ENDIF}

//    Memo1.Lines.Add(S);
    Memo1.Lines.Add('');


{$IFDEF USE_ASPROTECT}
{$I ..\ASProtect\aspr_crypt_begin3.inc}
  SetLength(s,5);
  GetLocaleInfo(GetSystemDefaultLCID,LOCALE_IDEFAULTANSICODEPAGE,PChar(s),5);
  s:=PChar(s);
{$I ..\ASProtect\aspr_crypt_end3.inc}  
  if s='1251' then
  begin
  Memo1.Lines.Add('ѕользователи с установленной в системе кодовой страницей WIN1251');
  Memo1.Lines.Add('имеют право на бесплатное использование BlazeTop. ћы стараемс€');
  Memo1.Lines.Add('поддерживать наших коллег из стран бывшего —оюза :), и надеемс€, что в');
  Memo1.Lines.Add('свою очередь, вы поддержите наш продукт своими советами и иде€ми!');
  end
  else
  begin
    Memo1.Lines.Add('Registration:');
    GetRegistrationInformation(0,AsprUserKey, AsprUserName);
    if (AsprUserKey <> nil) and (StrLen(AsprUserKey) > 0) then
    begin
      {$I ..\ASProtect\aspr_crypt_begin1.inc}
      Memo1.Lines.Add(Format('  Name = %s', [AnsiString(AsprUserName)]));
      Memo1.Lines.Add(Format('  Key = %s', [AnsiString(AsprUserKey)]));
      {$I ..\ASProtect\aspr_crypt_end1.inc}
    end else
    begin
      if GetTrialDays(0,AsprTrialDaysTotal, AsprTrialDaysLeft) then
      begin
        if AsprTrialDaysLeft <> 0 then
        begin
          Memo1.Lines.Add(Format('Unregistered trial version', []));
          Memo1.Lines.Add(Format('You have %s day(s) left', [IntToStr(AsprTrialDaysLeft)]));
        end else
          Memo1.Lines.Add(Format('TRIAL EXPIRED!', []));
      end;
    end;
  end;
{$ELSE}
    Memo1.Lines.Add(SAppCommunityComment);
{$ENDIF}



    Memo1.Lines.Add('');
    Memo1.Lines.Add(Format('%s', [SProjectHomePage2]));
    Memo1.Lines.Add(Format('%s', [SProjectHomePage]));
    Memo1.Lines.Add(Format('%s', [SProjectSupportAddr]));
    Memo1.Lines.Add('');
  end else
  begin
    Caption := Format('%s', ['Credits']);
    Button1.Caption := Format('%s', ['<< About']);

    Memo1.Lines.Add('Developers:');
    Memo1.Lines.Add('  Dmitriy Kovalenko, mailto:runningmaster@gmail.com');
    Memo1.Lines.Add('  Pavel Shibanov');
    Memo1.Lines.Add('');

    Memo1.Lines.Add('The Field Test Heroes:');
    Memo1.Lines.Add('  Dumitru Condrea');
    Memo1.Lines.Add('  Nikolai Voynov');
    Memo1.Lines.Add('  Arioch');
    Memo1.Lines.Add('  Roman Babenko');
    Memo1.Lines.Add('');

    Memo1.Lines.Add('Tools and Components:');
    Memo1.Lines.Add('  Inno Setup, http://www.jrsoftware.org/');
    Memo1.Lines.Add('  Virtual TreeView, http://www.delphi-gems.com/VirtualTreeview/');
    Memo1.Lines.Add('  Tnt Delphi UNICODE Controls, http://www.tntware.com/delphicontrols/unicode/');    
    Memo1.Lines.Add('  SynEdit, http://synedit.sourceforge.net/');
    Memo1.Lines.Add('  EhLib, http://www.ehlib.com/');
    Memo1.Lines.Add('  FIBPlus, http://www.fibplus.com/');
{$IFDEF USE_JCLDEBUG}
    Memo1.Lines.Add('  JCL (JclDebug), http://www.delphi-jedi.org/');
{$ENDIF}
    Memo1.Lines.Add('  IBX');
    Memo1.Lines.Add('');
  end;
  Memo1.Visible := True;

end;

procedure TAboutForm.Button1Click(Sender: TObject);
begin
  IsAbout := not IsAbout;
end;

end.

