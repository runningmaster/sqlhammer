unit ibSHServicesAPIFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHDriverIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, ActnList, ImgList, SynEdit,
  pSHSynEdit, StdCtrls, Buttons, AppEvnts, Menus;

type
  TibSHServicesAPIForm = class(TibBTComponentForm)
    ImageList1: TImageList;
    Panel1: TPanel;
    pSHSynEdit1: TpSHSynEdit;
    Panel2: TPanel;
    pSHSynEdit2: TpSHSynEdit;
    Splitter1: TSplitter;
    Panel3: TPanel;
    ComboBox1: TComboBox;
    Panel6: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    PopupMenuMessage: TPopupMenu;
    pmiHideMessage: TMenuItem;
    PopupMenu1: TPopupMenu;
    GetDatabaseNameFromRegistrator1: TMenuItem;
    GetDatabaseNameFromNavigator1: TMenuItem;
    Label1: TLabel;
    procedure ComboBox1Enter(Sender: TObject);
    procedure pmiHideMessageClick(Sender: TObject);
    procedure Panel3Resize(Sender: TObject);
    procedure Panel6Resize(Sender: TObject);
  private
    { Private declarations }
    FServiceIntf: IibSHService;

    function GetSaveFile: string;
    function GetBackupSourceFile: string;
    function GetBackupDestFile: string;
    function GetRestoreSourceFile: string;
    function GetRestoreDestFile: string;
    procedure SetDatabaseNameNav;
    procedure SetDatabaseNameReg;
    procedure ShowDatabaseNameWindow;
    procedure HideDatabaseNameWindow;
    procedure ShowBackupRestoreWindow;
    procedure HideBackupRestoreWindow;
    procedure GutterDrawNotify(Sender: TObject; ALine: Integer; var ImageIndex: Integer);
    procedure OnTextNotify(Sender: TObject; const Text: String);
  protected
    procedure RegisterEditors; override;
    procedure EditorMsgVisible(AShow: Boolean = True); override;

    { ISHFileCommands }
    function GetCanOpen: Boolean; override;
    procedure Open; override;

    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanRefresh: Boolean; override;

    procedure Run; override;
    procedure Refresh; override;

    function DoOnOptionsChanged: Boolean; override;
    function GetCanDestroy: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    property Service: IibSHService read FServiceIntf;
  end;

var
  ibSHServicesAPIForm: TibSHServicesAPIForm;

implementation

uses
  ibSHconsts, ibSHMessages;

{$R *.dfm}

{ TibSHServicesForm }

constructor TibSHServicesAPIForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHService, FServiceIntf);


  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
  FocusedControl := Editor;

  EditorMsg := pSHSynEdit2;
  EditorMsg.Clear;
  EditorMsg.OnGutterDraw := GutterDrawNotify;
  EditorMsg.GutterDrawer.ImageList := ImageList1;
  EditorMsg.GutterDrawer.Enabled := True;

  RegisterEditors;

  DoOnOptionsChanged;
  HideDatabaseNameWindow;
  HideBackupRestoreWindow;
  EditorMsgVisible(False);

  if Supports(Component, IibSHDatabaseStatistics) then ShowDatabaseNameWindow;
  if Supports(Component, IibSHDatabaseValidation) then ShowDatabaseNameWindow;
  if Supports(Component, IibSHDatabaseSweep) then ShowDatabaseNameWindow;
  if Supports(Component, IibSHDatabaseMend) then ShowDatabaseNameWindow;
  if Supports(Component, IibSHTransactionRecovery) then ShowDatabaseNameWindow;
  if Supports(Component, IibSHDatabaseShutdown) then ShowDatabaseNameWindow;
  if Supports(Component, IibSHDatabaseOnline) then ShowDatabaseNameWindow;
  if Supports(Component, IibSHDatabaseBackup) then ShowBackupRestoreWindow;
  if Supports(Component, IibSHDatabaseRestore) then ShowBackupRestoreWindow;
  if Supports(Component, IibSHDatabaseProps) then ShowDatabaseNameWindow;

  if Panel3.Visible then
  begin
    if FileExists(GetSaveFile) then
      ComboBox1.Items.LoadFromFile(GetSaveFile);
  end;

  if Panel6.Visible then
  begin
    if Supports(Component, IibSHDatabaseBackup) then
    begin
      if FileExists(GetBackupSourceFile) then
        ComboBox2.Items.LoadFromFile(GetBackupSourceFile);
      if FileExists(GetBackupDestFile) then
        ComboBox3.Items.LoadFromFile(GetBackupDestFile);
    end;
    if Supports(Component, IibSHDatabaseRestore) then
    begin
      if FileExists(GetRestoreSourceFile) then
        ComboBox2.Items.LoadFromFile(GetRestoreSourceFile);
      if FileExists(GetRestoreDestFile) then
        ComboBox3.Items.LoadFromFile(GetRestoreDestFile);
    end;
  end;

  ComboBox1.Text := SEnterYourDatabaseName;
  if Supports(Component, IibSHDatabaseBackup) then
  begin
    ComboBox2.Text := SEnterYourDatabaseName;
    ComboBox3.Text := SEnterYourBackupDatabaseName;
  end;
  if Supports(Component, IibSHDatabaseRestore) then
  begin
    ComboBox2.Text := SEnterYourBackupDatabaseName;
    ComboBox3.Text := SEnterYourDatabaseName;
  end;

  SetDatabaseNameNav;
end;

destructor TibSHServicesAPIForm.Destroy;
begin
  inherited Destroy;
end;

function TibSHServicesAPIForm.GetSaveFile: string;
begin
  Result := Format('%s%s', [Service.BTCLServer.DataRootDirectory, SServicesFile]);
  if not SysUtils.DirectoryExists(ExtractFilePath(Result)) then
    ForceDirectories(ExtractFilePath(Result));
end;

function TibSHServicesAPIForm.GetBackupSourceFile: string;
begin
  Result := Format('%s%s', [Service.BTCLServer.DataRootDirectory, SBackupSourceFile]);
  if not SysUtils.DirectoryExists(ExtractFilePath(Result)) then
    ForceDirectories(ExtractFilePath(Result));
end;

function TibSHServicesAPIForm.GetBackupDestFile: string;
begin
  Result := Format('%s%s', [Service.BTCLServer.DataRootDirectory, SBackupDestinationFile]);
  if not SysUtils.DirectoryExists(ExtractFilePath(Result)) then
    ForceDirectories(ExtractFilePath(Result));
end;

function TibSHServicesAPIForm.GetRestoreSourceFile: string;
begin
  Result := Format('%s%s', [Service.BTCLServer.DataRootDirectory, SRestoreSourceFile]);
  if not SysUtils.DirectoryExists(ExtractFilePath(Result)) then
    ForceDirectories(ExtractFilePath(Result));
end;

function TibSHServicesAPIForm.GetRestoreDestFile: string;
begin
  Result := Format('%s%s', [Service.BTCLServer.DataRootDirectory, SRestoreDestinationFile]);
  if not SysUtils.DirectoryExists(ExtractFilePath(Result)) then
    ForceDirectories(ExtractFilePath(Result));
end;

procedure TibSHServicesAPIForm.SetDatabaseNameNav;
var
  BTCLDatabase: IibSHDatabase;
  S: string;
  I: Integer;
begin
  if Supports(Designer.CurrentDatabase, IibSHDatabase, BTCLDatabase) then
  begin
    S := BTCLDatabase.Database;
    if not Supports(Component, IibSHDatabaseBackup) then
    begin
      I := ComboBox1.Items.IndexOf(S);
      if I <> -1 then ComboBox1.Items.Delete(I);
      ComboBox1.Items.Insert(0, S);
      ComboBox1.ItemIndex := 0;
    end else
    begin
      I := ComboBox2.Items.IndexOf(S);
      if I <> -1 then ComboBox2.Items.Delete(I);
      ComboBox2.Items.Insert(0, S);
      ComboBox2.ItemIndex := 0;
    end;
  end;
end;

procedure TibSHServicesAPIForm.SetDatabaseNameReg;
var
  BTCLDatabase: IibSHDatabase;
  S: string;
  I: Integer;
begin
  if Supports(Designer.CurrentDatabase, IibSHDatabase, BTCLDatabase) then
  begin
    S := BTCLDatabase.Database;
    if not Supports(Component, IibSHDatabaseBackup) then
    begin
      I := ComboBox1.Items.IndexOf(S);
      if I <> -1 then ComboBox1.Items.Delete(I);
      ComboBox1.Items.Insert(0, S);
      ComboBox1.ItemIndex := 0;
    end else
    begin
      I := ComboBox2.Items.IndexOf(S);
      if I <> -1 then ComboBox2.Items.Delete(I);
      ComboBox2.Items.Insert(0, S);
      ComboBox2.ItemIndex := 0;
    end;
  end;
end;
{
      Alias := ExtractFileName(AnsiReplaceText(FDatabase, '/', '\'));
      if Pos('.', Alias) <> 0 then Alias := Copy(Alias, 1, Pos('.', Alias) - 1);
}
procedure TibSHServicesAPIForm.ShowDatabaseNameWindow;
begin
  Panel3.Visible := True;
end;

procedure TibSHServicesAPIForm.HideDatabaseNameWindow;
begin
  Panel3.Visible := False;
end;

procedure TibSHServicesAPIForm.ShowBackupRestoreWindow;
begin
  Panel6.Visible := True;
end;

procedure TibSHServicesAPIForm.HideBackupRestoreWindow;
begin
  Panel6.Visible := False;
end;

procedure TibSHServicesAPIForm.GutterDrawNotify(Sender: TObject; ALine: Integer;
  var ImageIndex: Integer);
begin
  if ALine = 0 then ImageIndex := 3;
end;

procedure TibSHServicesAPIForm.OnTextNotify(Sender: TObject; const Text: String);
begin
  Component.Tag := Component.Tag + 1;
  Editor.Lines.Add(Text);
  Editor.CaretY := Pred(Editor.Lines.Count);
  Application.ProcessMessages;
end;

procedure TibSHServicesAPIForm.RegisterEditors;
var
  vEditorRegistrator: IibSHEditorRegistrator;
begin
  if Supports(Designer.GetDemon(IibSHEditorRegistrator), IibSHEditorRegistrator, vEditorRegistrator) then
    vEditorRegistrator.RegisterEditor(Editor, Service.BTCLServer, Service.BTCLDatabase);
end;

procedure TibSHServicesAPIForm.EditorMsgVisible(AShow: Boolean = True);
begin
  Panel2.Visible := AShow;
  Splitter1.Visible := AShow;
end;

function TibSHServicesAPIForm.GetCanOpen: Boolean;
begin
  Result := Panel3.Visible or Panel6.Visible;
end;

procedure TibSHServicesAPIForm.Open;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    if Supports(Component, IibSHDatabaseRestore) then
      OpenDialog.Filter := Format('%s', [SOpenDialogDatabaseBackupFilter])
    else
      OpenDialog.Filter := Format('%s', [SOpenDialogDatabaseFilter]);

    if OpenDialog.Execute then
    begin
      if Supports(Component, IibSHBackupRestoreService) then
      begin
        if Supports(Component, IibSHDatabaseBackup) then
          ComboBox2.Text := OpenDialog.FileName;
        if Supports(Component, IibSHDatabaseRestore) then
          ComboBox2.Text := OpenDialog.FileName;
      end else
        ComboBox1.Text := OpenDialog.FileName;
    end;
  finally
    FreeAndNil(OpenDialog);
  end;
end;

function TibSHServicesAPIForm.GetCanRun: Boolean;
var
  ResultSource, ResultDest: Boolean;
begin
  Result := True;
  if Panel3.Visible then
  begin
    Result := Assigned(Service) and
              not AnsiSameText(ComboBox1.Text, SEnterYourDatabaseName) and
              (Length(ComboBox1.Text) > 0);
  end;
  if Panel6.Visible then
  begin
    ResultSource := (Assigned(Service) and
               not AnsiSameText(ComboBox2.Text, SEnterYourDatabaseName) and
               not AnsiSameText(ComboBox2.Text, SEnterYourBackupDatabaseName) and
              (Length(ComboBox2.Text) > 0));

    ResultDest := (Assigned(Service) and
              not AnsiSameText(ComboBox3.Text, SEnterYourDatabaseName) and
              not AnsiSameText(ComboBox3.Text, SEnterYourBackupDatabaseName) and
              (Length(ComboBox3.Text) > 0));
    Result := ResultSource and ResultDest;
  end;
end;

function TibSHServicesAPIForm.GetCanRefresh: Boolean;
begin
  Result := False;
end;

procedure TibSHServicesAPIForm.Run;
var
  S1, S2, S3: string;
begin
  if Assigned(Service) then
  begin
    Editor.Clear;
    EditorMsgVisible(False);
    S1 := ComboBox1.Text;
    S2 := ComboBox2.Text;
    S3 := ComboBox3.Text;
    Service.DatabaseName := S1;
    Service.OnTextNotify := OnTextNotify;
    if Supports(Component, IibSHDatabaseBackup) or Supports(Component, IibSHDatabaseRestore) then
    begin
      (Component as IibSHBackupRestoreService).SourceFileList.CommaText := S2;
      (Component as IibSHBackupRestoreService).DestinationFileList.CommaText := S3;
    end;

    Designer.UpdateActions;
    Application.ProcessMessages;
    if not Service.Execute then
    begin
      EditorMsgVisible;
      Designer.TextToStrings(Service.ErrorText, EditorMsg.Lines, True);
    end else
    begin
      if Panel3.Visible then
      begin
        if ComboBox1.Items.IndexOf(S1) <> -1 then
          ComboBox1.Items.Delete(ComboBox1.Items.IndexOf(S1));
        ComboBox1.Items.Insert(0, S1);
        ComboBox1.ItemIndex := 0;
        ComboBox1.Items.SaveToFile(GetSaveFile);
      end;

      if Panel6.Visible then
      begin
        if Supports(Component, IibSHDatabaseBackup) then
        begin
          if ComboBox2.Items.IndexOf(S2) <> -1 then
            ComboBox2.Items.Delete(ComboBox2.Items.IndexOf(S2));
          ComboBox2.Items.Insert(0, S2);
          ComboBox2.ItemIndex := 0;
          ComboBox2.Items.SaveToFile(GetBackupSourceFile);

          if ComboBox3.Items.IndexOf(S3) <> -1 then
            ComboBox3.Items.Delete(ComboBox3.Items.IndexOf(S3));
          ComboBox3.Items.Insert(0, S3);
          ComboBox3.ItemIndex := 0;
          ComboBox3.Items.SaveToFile(GetBackupDestFile);
        end;
        
        if Supports(Component, IibSHDatabaseRestore) then
        begin
          if ComboBox2.Items.IndexOf(S2) <> -1 then
            ComboBox2.Items.Delete(ComboBox2.Items.IndexOf(S2));
          ComboBox2.Items.Insert(0, S2);
          ComboBox2.ItemIndex := 0;
          ComboBox2.Items.SaveToFile(GetRestoreSourceFile);

          if ComboBox3.Items.IndexOf(S3) <> -1 then
            ComboBox3.Items.Delete(ComboBox3.Items.IndexOf(S3));
          ComboBox3.Items.Insert(0, S3);
          ComboBox3.ItemIndex := 0;
          ComboBox3.Items.SaveToFile(GetRestoreDestFile);
        end;
      end;
    end;
  end;
end;

procedure TibSHServicesAPIForm.Refresh;
begin
end;

function TibSHServicesAPIForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
  if Result and Assigned(Editor) then
  begin
    Editor.ReadOnly := True;
    Editor.Options := Editor.Options + [eoScrollPastEof];
    Editor.Highlighter := nil;
    // Принудительная установка фонта
    Editor.Font.Charset := 1;
    Editor.Font.Color := clWindowText;
    Editor.Font.Height := -13;
    Editor.Font.Name := 'Courier New';
    Editor.Font.Pitch := fpDefault;
    Editor.Font.Size := 10;
    Editor.Font.Style := [];
  end;
end;

function TibSHServicesAPIForm.GetCanDestroy: Boolean;
begin
  Result := inherited GetCanDestroy;
  //Service.DRVService.
end;

procedure TibSHServicesAPIForm.ComboBox1Enter(Sender: TObject);
begin
  if Sender is TComboBox then
  begin
    if AnsiSameText(TComboBox(Sender).Text, SEnterYourDatabaseName) or
       AnsiSameText(TComboBox(Sender).Text, SEnterYourBackupDatabaseName) then
    begin
      TComboBox(Sender).Text := ' ';
      TComboBox(Sender).Text := EmptyStr;
      TComboBox(Sender).Invalidate;
      TComboBox(Sender).Repaint;
    end;
  end;
end;

procedure TibSHServicesAPIForm.pmiHideMessageClick(Sender: TObject);
begin
  EditorMsgVisible(False);
end;

procedure TibSHServicesAPIForm.Panel3Resize(Sender: TObject);
begin
  ComboBox1.Width := ComboBox1.Parent.ClientWidth - ComboBox1.Left * 2;
end;

procedure TibSHServicesAPIForm.Panel6Resize(Sender: TObject);
begin
  ComboBox2.Width := ComboBox2.Parent.ClientWidth - ComboBox2.Left * 2;
  ComboBox3.Width := ComboBox3.Parent.ClientWidth - ComboBox3.Left * 2;
end;

end.


