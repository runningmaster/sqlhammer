unit ideSHSplashFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, jpeg, IniFiles;

type
  TSplashForm = class(TForm)
    bvlTop: TBevel;
    bvlLeft: TBevel;
    bvlRight: TBevel;
    bvlBottom: TBevel;
    Panel1: TPanel;
    Label1: TLabel;
    Bevel1: TBevel;
    Panel2: TPanel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Panel3: TPanel;
    Image1: TImage;
    Timer1: TTimer;
    Panel4: TPanel;
    Memo1: TMemo;
    Panel5: TPanel;
    ProgressBar1: TProgressBar;
    Panel6: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }

    procedure SplashTrace(const AText: string);
    procedure SplashTraceDone;
  end;

procedure CreateSplashForm;
procedure ShowSplashForm;
procedure DestroySplashForm;

var
  SplashForm: TSplashForm;
  I, Count: Integer;

implementation

{$R *.dfm}

function CanShowSplash: Boolean; // !!! HACK
var
  IniFile: TIniFile;
  FileName: string;
begin
  FileName := Format('%s..\Data\Environment\Options.txt', [IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))]);
  IniFile := TIniFile.Create(FileName);
  try
    Result := StrToBool(IniFile.ReadString('OPTIONS', 'TideSHSystemOptions.ShowSplashWindow', 'True'));
  finally
    IniFile.Free;
  end;
end;

procedure CreateSplashForm;
begin
  I := 0;
  Count := 5;
  if CanShowSplash then
  begin
    SplashForm := TSplashForm.Create(Application);
    SplashForm.Panel1.Color := clWhite;
    SplashForm.Panel2.Color := clWhite;
    SplashForm.Panel3.Color := clWhite;
    SplashForm.Panel5.Color := clWhite;
    SplashForm.Panel6.Color := clWhite;
    SplashForm.Memo1.Color := clWhite;
  end;
end;

procedure ShowSplashForm;
begin
  if Assigned(SplashForm) then
  begin
    SplashForm.SplashTrace('Initialize...');
    SplashForm.Show;
    SplashForm.SplashTraceDone;
    Application.ProcessMessages;
    SplashForm.Invalidate;
    Application.ProcessMessages;
  end;
end;

procedure DestroySplashForm;
begin
  if Assigned(SplashForm) then
  begin
    SplashForm.Free;
    SplashForm := nil;
  end;
end;

{ TBTSplashForm }

procedure TSplashForm.SplashTrace(const AText: string);
begin
  Memo1.Lines.Add(Format('%s', [AText]));
  Application.ProcessMessages;  
end;

procedure TSplashForm.SplashTraceDone;
begin
  Memo1.Lines[Pred(Memo1.Lines.Count)] := Format('%s done', [Memo1.Lines[Pred(Memo1.Lines.Count)]]);
//  ProgressBar1.Position := ProgressBar1.Position + 10;
  ProgressBar1.Position := 100 * I div Count;
  I := I + 1;
  Application.ProcessMessages;
end;

initialization
{
  if CanShowSplash then
  begin

  end;
}  
end.
