unit ibSHTXTLoaderFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, ComCtrls, ExtCtrls, StdCtrls, Menus;

type
  TibSHTXTLoaderForm = class(TibBTComponentForm)
    Panel1: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Panel2: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Image1: TImage;
    Panel6: TPanel;
    Panel7: TPanel;
    ProgressBar1: TProgressBar;
    Panel3: TPanel;
    Panel4: TPanel;
    pSHSynEdit1: TpSHSynEdit;
    Panel5: TPanel;
    pSHSynEdit2: TpSHSynEdit;
    Splitter1: TSplitter;
    PopupMenuMessage: TPopupMenu;
    pmiHideMessage: TMenuItem;
    Clear1: TMenuItem;
    procedure Panel1Resize(Sender: TObject);
    procedure pmiHideMessageClick(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
  private
    { Private declarations }
    FTXTLoaderIntf: IibSHTXTLoader;
    FRecordCount: Integer;
    function GetSaveFile: string;
    procedure OnTextNotify(Sender: TObject; const Text: String);
  protected
    procedure EditorMsgVisible(AShow: Boolean = True); override;
    { ISHFileCommands }
    function GetCanOpen: Boolean; override;
    procedure Open; override;

    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanPause: Boolean; override;
    function GetCanCommit: Boolean; override;
    function GetCanRollback: Boolean; override;

    procedure Run; override;
    procedure Pause; override;
    procedure Commit; override;
    procedure Rollback; override;

    function DoOnOptionsChanged: Boolean; override;
    function GetCanDestroy: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    property TXTLoader: IibSHTXTLoader read FTXTLoaderIntf;
  end;

var
  ibSHTXTLoaderForm: TibSHTXTLoaderForm;

implementation

uses
  ibSHconsts, ibSHMessages;

{$R *.dfm}

{ TibSHTXTLoaderForm }

constructor TibSHTXTLoaderForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHTXTLoader, FTXTLoaderIntf);
  Assert(TXTLoader <> nil, 'TXTLoader = nil');
  Assert(TXTLoader.BTCLDatabase <> nil, 'TXTLoader.BTCLDatabase = nil');

  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
  Editor.Lines.Add(Format('/* %s */', [SEnterYourDMLStatementImportCriteria]));

  EditorMsg := pSHSynEdit2;
  EditorMsg.Lines.Clear;
  EditorMsg.Parent.Height := Trunc(EditorMsg.Parent.Parent.ClientHeight * 2/3);
  EditorMsgVisible;
  FocusedControl := Editor;

  RegisterEditors;
//  ShowHideRegion(False);
  DoOnOptionsChanged;
//  Panel6.Caption := EmptyStr;
  TXTLoader.OnTextNotify := OnTextNotify;

  if FileExists(GetSaveFile) then ComboBox1.Items.LoadFromFile(GetSaveFile);
  ComboBox1.Text := SEnterYourFileImportCriteria;
end;

destructor TibSHTXTLoaderForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHTXTLoaderForm.EditorMsgVisible(AShow: Boolean = True);
begin
  if AShow then
  begin
    EditorMsg.Parent.Visible := True;
    Splitter1.Visible := True;
  end else
  begin
    EditorMsg.Parent.Visible := False;
    Splitter1.Visible := False;
  end;
end;

function TibSHTXTLoaderForm.GetCanOpen: Boolean;
begin
  Result := not TXTLoader.Active;
end;

procedure TibSHTXTLoaderForm.Open;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := Format('%s', [SOpenDialogTXTLoaderFilter]);
    if OpenDialog.Execute then
    begin
      ComboBox1.Text := OpenDialog.FileName;
      TXTLoader.FileName := ComboBox1.Text;
    end;
  finally
    FreeAndNil(OpenDialog);
  end;
end;

function TibSHTXTLoaderForm.GetCanRun: Boolean;
begin
  Result := not TXTLoader.Active and
            not AnsiSameText(ComboBox1.Text, SEnterYourFileImportCriteria) and
            (Length(ComboBox1.Text) > 0);
end;

function TibSHTXTLoaderForm.GetCanPause: Boolean;
begin
  Result := TXTLoader.Active;
end;

function TibSHTXTLoaderForm.GetCanCommit: Boolean;
begin
  Result := TXTLoader.InTransaction;
end;

function TibSHTXTLoaderForm.GetCanRollback: Boolean;
begin
  Result := TXTLoader.InTransaction;
end;

procedure TibSHTXTLoaderForm.Run;
begin
  if TXTLoader.InTransaction then
    if not Designer.ShowMsg(Format('%s', ['Previous transaction is active. Continue?']), mtConfirmation) then Exit;
    
  TXTLoader.InsertSQL.Assign(Editor.Lines);
  TXTLoader.FileName := ComboBox1.Text;
  if ComboBox1.Items.IndexOf(TXTLoader.FileName) <> -1 then
    ComboBox1.Items.Delete(ComboBox1.Items.IndexOf(TXTLoader.FileName));
  ComboBox1.Items.Insert(0, TXTLoader.FileName);
  ComboBox1.Text := TXTLoader.FileName;
  ComboBox1.Items.SaveToFile(GetSaveFile);
  if not TXTLoader.InTransaction then EditorMsg.Clear;
  EditorMsg.Parent.Height := Trunc(EditorMsg.Parent.Parent.ClientHeight * 2/3);
  EditorMsgVisible;
  FRecordCount := TXTLoader.GetStringCount;
  if TXTLoader.Verbose then Panel2.Visible := True;
  try
    Screen.Cursor := crHourGlass;
    TXTLoader.Execute;
  finally
    Panel2.Visible := False;
    Screen.Cursor := crDefault;
  end;
end;

procedure TibSHTXTLoaderForm.Pause;
begin
  TXTLoader.Active := False;
  Panel2.Visible := False;
  Screen.Cursor := crDefault;
end;

procedure TibSHTXTLoaderForm.Commit;
begin
  TXTLoader.Commit;
end;

procedure TibSHTXTLoaderForm.Rollback;
begin
  TXTLoader.Rollback;
end;

function TibSHTXTLoaderForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;

  EditorMsg.BottomEdgeVisible := True;
  EditorMsg.RightEdge := 0;
  EditorMsg.WantReturns := False;
  EditorMsg.WordWrap := False;
end;

function TibSHTXTLoaderForm.GetCanDestroy: Boolean;
begin
  Result := inherited GetCanDestroy;
  if TXTLoader.BTCLDatabase.WasLostConnect then Exit;

  if TXTLoader.Active then Designer.ShowMsg(Format('Import process is running...', []), mtInformation);
  Result := Assigned(TXTLoader) and not TXTLoader.Active;

  if TXTLoader.InTransaction then
  begin
    case Designer.ShowMsg(Format('%s', ['Transaction is active. Should it be committed?'])) of
      IDCANCEL:
      begin
        Result := False;
      end;

      IDYES:
      begin
        TXTLoader.Commit;
        Result := not TXTLoader.InTransaction;
      end;

      IDNO:
      begin
        TXTLoader.Rollback;
        Result := not TXTLoader.InTransaction;
      end;
    end;
  end;
end;

function TibSHTXTLoaderForm.GetSaveFile: string;
begin
  Result := Format('%s%s', [TXTLoader.BTCLDatabase.DataRootDirectory, STXTLoaderFile]);
  if not SysUtils.DirectoryExists(ExtractFilePath(Result)) then
    ForceDirectories(ExtractFilePath(Result));
end;

procedure TibSHTXTLoaderForm.OnTextNotify(Sender: TObject; const Text: String);
begin
  if Pos(SLineBreak, Text) > 0 then
    Designer.TextToStrings(Text, EditorMsg.Lines)
  else
    EditorMsg.Lines.Add(Text);
  EditorMsg.CaretY := EditorMsg.Lines.Count;
  ProgressBar1.Position := 100 * TXTLoader.GetCurLineNumber div FRecordCount;
end;

procedure TibSHTXTLoaderForm.Panel1Resize(Sender: TObject);
begin
  ComboBox1.Width := ComboBox1.Parent.ClientWidth - ComboBox1.Left * 2;
  ProgressBar1.Width := ProgressBar1.Parent.ClientWidth - 8;
end;

procedure TibSHTXTLoaderForm.pmiHideMessageClick(Sender: TObject);
begin
  EditorMsgVisible(False);  
end;

procedure TibSHTXTLoaderForm.Clear1Click(Sender: TObject);
begin
  EditorMsg.ClearAll;
end;

procedure TibSHTXTLoaderForm.Panel2Resize(Sender: TObject);
begin
  ProgressBar1.Width := ProgressBar1.Parent.ClientWidth - 8;
end;

procedure TibSHTXTLoaderForm.ComboBox1Enter(Sender: TObject);
begin
  if AnsiSameText(ComboBox1.Text, SEnterYourFileImportCriteria) then
  begin
    ComboBox1.Text := ' ';
    ComboBox1.Text := EmptyStr;
    ComboBox1.Invalidate;
    ComboBox1.Repaint;
  end;
end;

end.
