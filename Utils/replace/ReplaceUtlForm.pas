unit ReplaceUtlForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ActnList, Menus, ComCtrls, IniFiles, Mask,
  MaskUtils, FileCtrl;

type



  TForm1 = class(TForm)
    PageControl1: TPageControl;
    tsRules: TTabSheet;
    Memo2: TMemo;
    tsReplace: TTabSheet;
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    miSchema: TMenuItem;
    Load1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ActionList1: TActionList;
    acSchemaLoad: TAction;
    acSchemaExit: TAction;
    acSchemaSave: TAction;
    acSchemaSaveAs: TAction;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    miRules: TMenuItem;
    AutoCreate1: TMenuItem;
    tsFiles: TTabSheet;
    Memo1: TMemo;
    miReplace: TMenuItem;
    acReplaceDoIt: TAction;
    DoIt1: TMenuItem;
    acSchemaNew: TAction;
    acRulesAddRules: TAction;
    New1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    Files1: TMenuItem;
    acFilesAddFilesTypes: TAction;
    AddFilesTypes1: TMenuItem;
    acFilesDelFileType: TAction;
    acRulesDeleteRule: TAction;
    PageControl2: TPageControl;
    tsFilesTypes: TTabSheet;
    tsFilesList: TTabSheet;
    Panel3: TPanel;
    chbScanSubFolders: TCheckBox;
    ledRootPath: TLabeledEdit;
    lbFilesTypes: TListBox;
    DeleteType1: TMenuItem;
    DeleteRule1: TMenuItem;
    N2: TMenuItem;
    acFilesAddFiles: TAction;
    acFilesDeleteFile: TAction;
    acFilesAddFile1: TMenuItem;
    acFilesDeleteFile1: TMenuItem;
    btnBrowse: TButton;
    pmFilesTypes: TPopupMenu;
    AddFilesTypes2: TMenuItem;
    DeleteType2: TMenuItem;
    lbFiles: TListBox;
    pmFilesList: TPopupMenu;
    AddFiles1: TMenuItem;
    DeleteFile1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acSchemaLoadExecute(Sender: TObject);
    procedure acSchemaExitExecute(Sender: TObject);
    procedure acSchemaNewExecute(Sender: TObject);
    procedure DoSchemaChange(Sender: TObject);
    procedure acSchemaSaveExecute(Sender: TObject);
    procedure acSchemaSaveAsExecute(Sender: TObject);
    procedure acRulesAddRulesExecute(Sender: TObject);
    procedure acReplaceDoItExecute(Sender: TObject);
    procedure acFilesAddFilesTypesExecute(Sender: TObject);
    procedure acRulesDeleteRuleExecute(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure acFilesDelFileTypeExecute(Sender: TObject);
    procedure acFilesAddFilesExecute(Sender: TObject);
    procedure acFilesDeleteFileExecute(Sender: TObject);
  private
    { Private declarations }
    fl: TStringList;
    AllowList: TStringList;
    DenyList: TStringList;
    SchemaChanged: Boolean;
    SchemaName: String;
  public
    procedure SchemaLoadFromFile(FileName: String);
    procedure SchemaSaveToFile(FileName: String);
    procedure SchemaClear;
    procedure FormatCaption;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses RuleFrm, Math, FilesList, StrUtils;

{$R *.dfm}

function ReplaceStr(Str, s1, s2: String): String;
var i: Integer; s: String;
begin
  s := str;
  Result := '';
  i := Pos(s1, Str);
  while i > 0 do
  begin
    Result := Result + Copy(Str, 1, i - 1) + s2;
    Delete(Str, 1, i-1+Length(s1));
    i := Pos(s1, Str);
  end;
  Result := Result + Str;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
//  Edit1.Text := 'B'+ 'T';
//  Edit2.Text := 'S'+ 'H';
  PageControl1.ActivePage := tsFiles;
  PageControl2.ActivePage := tsFilesTypes;

  fl := TStringList.Create;
  AllowList := TStringList.Create;
  DenyList := TStringList.Create;

  fl.Add('.pas');
  fl.Add('.dfm');
  fl.Add('.dpr');
  fl.Add('.cfg');
  fl.Add('.bpg');

  acSchemaNew.Execute;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  fl.Free;
  AllowList.Free;
  DenyList.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
(*

  function ReplaceLine(Str, s1, s2: String): String;
  var i,k, ind: Integer; s: String; leks: TStringList;
  begin
    Result := Str;
    // Если нечего менять - не тратим время
    k := Pos(s1, Str);
    if k = 0 then
      Exit;
    // иначе
    leks := TStringList.Create;
    try
      // разбиваем на лексемы
      s := '';
      for i := 1 to Length(Str) do
      begin
        if (Str[i] in ['A'..'Z','a'..'z','А'..'Я','а'..'я','_']) then
          s := s + Str[i]
        else
          if s <> '' then
          begin
            leks.Add(s);
            s := '';
          end
      end;
      if s <> '' then leks.Add(s);
      // проверяем каждую лексему на наличие искомого шаблона
      for i := 0 to leks.Count - 1 do
      begin
        if Pos(s1, leks[i]) = 0 then Continue;
        if DenyList.IndexOfName(leks[i]) = -1 then
        begin
          ind := AllowList.IndexOfName(leks[i]);
          if ind = -1 then
          begin
            if CheckBox2.Checked then
              ind := AllowList.Add(leks[i]+'='+ReplaceStr(leks[i], s1, s2))
            else
            // Запросить возможность автозамены
            case Application.MessageBox(PChar(Format('Разрешить автозамену "%s" -> "%s" ?',[leks[i], ReplaceStr(leks[i], s1, s2)])), 'Создание правила автозамены', MB_YESNOCANCEL) of
              IDYES:
                ind := AllowList.Add(leks[i]+'='+ReplaceStr(leks[i], s1, s2));
              IDNO:
                DenyList.Add(leks[i]+'='+ReplaceStr(leks[i], s1, s2));
              IDCANCEL: Abort;
            end;
          end;
          if (ind <> -1) and (not CheckBox2.Checked) then
            Result := ReplaceStr(Result, AllowList.Names[ind], AllowList.Values[AllowList.Names[ind]]);
        end;
      end;
    finally
      leks.Free;
    end;
  end;

  procedure ReplaceDirFiles(DirPath, Mask: String; Recursive: Boolean);
  var sr: TSearchRec; res, i: Integer; sl: TStringList;
      FileChanged: Boolean; _s: String;
  begin
    sl := TStringList.Create;
    try
      res := FindFirst(DirPath + Mask, faAnyFile, sr);
      while res = 0 do
      begin
        if (sr.Name <> '.') and (sr.Name <> '..') then
        begin
          if (sr.Attr and faDirectory) = faDirectory then
          begin
            if Recursive then
              ReplaceDirFiles(DirPath + sr.Name + '\', Mask, Recursive);
          end
          else
          begin
            if fl.IndexOf(LowerCase(ExtractFileExt(sr.Name))) <> -1 then
            begin
              sl.LoadFromFile(DirPath + sr.Name);

{ Алгоритм
  Каждую строку разбивать на лексемы (слова)
  если слово содержит элемент замены

}
              // разбивать строку на стринги,
              // ввести списки разрещенных и запрещенных замен
              FileChanged := False;
              for i := 0 to sl.Count - 1 do
              begin
                _s := ReplaceLine(sl[i], Edit1.Text, Edit2.Text);
                if (_s <> sl[i]) and (not CheckBox2.Checked) then
                begin
                  sl[i] := _s;
                  FileChanged := True;
                end;
              end;
              if (not CheckBox2.Checked) and FileChanged then
              begin
                sl.SaveToFile(DirPath + sr.Name);
                Memo1.Lines.Add('файл перезаписан '+DirPath + sr.Name);
              end
              else
                Memo1.Lines.Add('файл обработан '+DirPath + sr.Name);
            end;

            if ReplaceStr(sr.Name, Edit1.Text, Edit2.Text) <> sr.Name then
            begin
              RenameFile(DirPath + sr.Name, DirPath + ReplaceStr(sr.Name, Edit1.Text, Edit2.Text));
              Memo1.Lines.Add('файл переименован '+sr.Name+ ' -> ' + ReplaceStr(sr.Name, Edit1.Text, Edit2.Text));
            end;
          end;
        end;
        res := FindNext(sr);
      end;
      FindClose(sr);
    finally
      sl.Free;
    end;
  end;
*)
begin
(*  if FileExists('AllowList.txt') then
    AllowList.LoadFromFile('AllowList.txt');
  if FileExists('DenyList.txt') then
    DenyList.LoadFromFile('DenyList.txt');

  ReplaceDirFiles(ledRootPath.Text, '*.*', chbScanSubFolders.Checked);

  AllowList.Sort;
  AllowList.SaveToFile('AllowList.txt');
  DenyList.Sort;
  DenyList.SaveToFile('DenyList.txt');*)
end;

procedure TForm1.FormatCaption;
begin
  if not SchemaChanged then
  begin
    if SchemaName <> '' then
      Caption := Application.Title + ' - ' + SchemaName
    else
      Caption := Application.Title;
  end
  else
  begin
    if SchemaName <> '' then
      Caption := Application.Title + ' - ' + SchemaName + '(Unsaved)'
    else
      Caption := Application.Title + ' - (Unsaved)'
  end
end;

procedure TForm1.acSchemaNewExecute(Sender: TObject);
var Cap: String;
begin
  if SchemaName = '' then
    Cap := 'Save changes to schema ?'
  else
    Cap := 'Save changes to schema ' + SchemaName + '?';
  // Новая схема - удалить старую схему, если изменялась
  if SchemaChanged then
    case Application.MessageBox(PAnsiChar(Cap), 'Confirm', MB_YESNOCANCEL) of
      IDYES: acSchemaSave.Execute;
      IDCANCEL: Abort;
    end;
  SchemaClear;
end;

procedure TForm1.acSchemaLoadExecute(Sender: TObject);
begin
  // Загрузка схемы (inifile)
  OpenDialog1.InitialDir := ExtractFileDir(Application.ExeName);
  if OpenDialog1.Execute then
    SchemaLoadFromFile(OpenDialog1.FileName);
end;


procedure TForm1.DoSchemaChange(Sender: TObject);
begin
  SchemaChanged := True;
  FormatCaption;
end;

procedure TForm1.acSchemaSaveExecute(Sender: TObject);
begin
  //
  if SchemaName = '' then
    acSchemaSaveAs.Execute
  else
    SchemaSaveToFile(ExtractFileDir(Application.ExeName)+'\' + SchemaName);
end;

procedure TForm1.acSchemaSaveAsExecute(Sender: TObject);
begin
  // Сохранение схемы
  SaveDialog1.InitialDir := ExtractFileDir(Application.ExeName);
  if SaveDialog1.Execute then
    SchemaSaveToFile(SaveDialog1.FileName);
end;

procedure TForm1.acRulesAddRulesExecute(Sender: TObject);

  function FindAndCreateRule(Str, s1, s2: String; Strings: TStrings): String;
  var i,k, ind: Integer; s: String; leks: TStringList;
  begin
    Result := Str;
    // Если нечего менять - не тратим время
    k := Pos(s1, Str);
    if k = 0 then
      Exit;
    // иначе
    leks := TStringList.Create;
    try
      // разбиваем на лексемы
      s := '';
      for i := 1 to Length(Str) do
      begin
        if (Str[i] in ['A'..'Z','a'..'z','А'..'Я','а'..'я','_']) then
          s := s + Str[i]
        else
          if s <> '' then
          begin
            leks.Add(s);
            s := '';
          end
      end;
      if s <> '' then leks.Add(s);
      // проверяем каждую лексему на наличие искомого шаблона
      for i := 0 to leks.Count - 1 do
      begin
        if Pos(s1, leks[i]) = 0 then Continue;

        ind := Strings.IndexOfName(leks[i]);
        if ind = -1 then
          Strings.Add(leks[i]+'='+ReplaceStr(leks[i], s1, s2))
      end;
    finally
      leks.Free;
    end;
  end;

var _From, _To, _s: string; _WholeWords: Boolean;
   sl: TStringList; i, j: Integer;
begin
  // Создание правил замены
  {Алгоритм
   Пользователь вводит шаблоны поиска и замены
  }

  PageControl1.ActivePage := tsRules;
  if GetRuleDef(_From, _To, _WholeWords) then
  begin
    if _WholeWords then
    begin
      If Memo2.Lines.IndexOfName(_From) = -1 then
        Memo2.Lines.Add(_From + '=' + _To)
      else
        raise Exception.Create('Rule for replace from '''+_From+''' already exists!');
    end
    else
    begin
      // проверить задан ли путь для сканирования
      if lbFiles.Items.Count = 0 then
        raise Exception.Create('Files List is Empty!');
      sl := TStringList.Create;
      try
        for i := 0 to lbFiles.Items.Count - 1 do
        begin

          sl.LoadFromFile(lbFiles.Items[i]);
          for j := 0 to sl.Count - 1 do
            _s := FindAndCreateRule(sl[j], _From, _To, Memo2.Lines);

        end;
        sl.Assign(Memo2.Lines);
        sl.Sort;
        Memo2.Lines.Assign(sl);
      finally
        sl.Free;
      end;
    end;
  end;
end;

procedure TForm1.acSchemaExitExecute(Sender: TObject);
begin
  // Выход из программы
  acSchemaNew.Execute;
  Close;
end;

procedure TForm1.SchemaLoadFromFile(FileName: String);
var ini: TIniFile; i: Integer; sl: TStringList;
begin
  ini := TIniFile.Create(FileName);
  try
    ledRootPath.Text := ini.ReadString('Paths', 'RootPath', '');
    chbScanSubFolders.Checked := ini.ReadBool('Paths', 'ScanSubFolders', False);
    ini.ReadSectionValues('AllowList', Memo2.Lines);

{    with lbFiles do
    begin
      ReadSectionValues('Files', Items);
      for i := 0 to Items.Count - 1 do
        Items[i] := Copy(Items[i], 1, Length(Items[i])-1);
    end;}

    sl := TStringList.Create;
    try
      lbFiles.Clear;
      sl.LoadFromFile(FileName);
      i := sl.IndexOf('[Files]');
      if i > -1 then
      begin
        Inc(i);
        while (i < sl.Count) and (sl[i][1] <> '[') and (sl[i][1] <> ' ') do
        begin
          lbFiles.Items.Add(Copy(sl[i], 1, Length(sl[i])-1));
          Inc(i);
        end;
      end;
    finally
      sl.Free;
    end;

    with lbFilesTypes do
    begin
      ini.ReadSectionValues('FileTypes', Items);
      for i := 0 to Items.Count - 1 do
        Items[i] := Copy(Items[i], 1, Length(Items[i])-1);
    end;
    PageControl1.ActivePage := tsFiles;
    PageControl2.ActivePage := tsFilesTypes;
  finally
    ini.Free;
  end;
  SchemaName := ExtractFileName(FileName);
  SchemaChanged := False;
  FormatCaption;
end;

procedure TForm1.SchemaSaveToFile(FileName: String);
var ini: TIniFile; i: Integer;
begin
  ini := TIniFile.Create(FileName);
  try
    ini.WriteString('Paths', 'RootPath', ledRootPath.Text);
    ini.WriteBool('Paths', 'ScanSubFolders', chbScanSubFolders.Checked);
    ini.EraseSection('AllowList');
    ProgressBar1.Max := Memo2.Lines.Count;
    ProgressBar1.Min := 0;
    Panel2.Visible := True;
    for i := 0 to Memo2.Lines.Count - 1 do
    begin
      ini.WriteString('AllowList', Memo2.Lines.Names[i], Copy(Memo2.Lines[i], Length(Memo2.Lines.Names[i])+2, 255));
      ProgressBar1.Position := i+1;
      Application.ProcessMessages;
    end;

    ini.EraseSection('FileTypes');
    ProgressBar1.Max := lbFilesTypes.Items.Count;
    ProgressBar1.Min := 0;
    Panel2.Visible := True;
    for i := 0 to lbFilesTypes.Items.Count - 1 do
    begin
      ini.WriteString('FileTypes', lbFilesTypes.Items[i], '');
      ProgressBar1.Position := i+1;
      Application.ProcessMessages;
    end;

    ini.EraseSection('Files');
    ProgressBar1.Max := lbFiles.Items.Count;
    ProgressBar1.Min := 0;
    Panel2.Visible := True;
    for i := 0 to lbFiles.Items.Count - 1 do
    begin
      ini.WriteString('Files', lbFiles.Items[i], '');
      ProgressBar1.Position := i+1;
      Application.ProcessMessages;
    end;
  finally
    ini.Free;
    Panel2.Visible := False;
  end;
  SchemaChanged := False;
  SchemaName := ExtractFileName(FileName);
  FormatCaption;
end;

procedure TForm1.SchemaClear;
begin
  Memo1.Clear;
  Memo2.Clear;
  lbFilesTypes.Clear;
  lbFiles.Clear;
  ledRootPath.Clear;
  chbScanSubFolders.Checked := False;
  PageControl1.ActivePageIndex := 0;

  SchemaChanged := False;
  SchemaName := '';
  FormatCaption;
end;

procedure TForm1.acFilesAddFilesTypesExecute(Sender: TObject);

  function AddFileTypes(FilesList: TFilesList; Strings: TStrings): Integer;
  var i: Integer; FileExt: String;
  begin
    Result := 0;
    for i := 0 to FilesList.FilesCount - 1 do
    begin
      FileExt := AnsiLowerCase(ExtractFileExt(FilesList[i].Name));
      if Strings.IndexOf(FileExt) = -1 then
      begin
        Strings.Add(FileExt);
        Result := Result + 1;
      end;
    end;
    for i := 0 to FilesList.FoldersCount - 1 do
      Result := Result + AddFileTypes(FilesList.Folders[i], Strings);
  end;

var FilesList: TFilesList;
begin
  // сканирование типов файлов
  // просканировать путь (если задано - то рекурсивно)
  FilesList := TFilesList.Create;
  try
    FilesList.Scan(ledRootPath.Text, '*.*', chbScanSubFolders.Checked);
    if AddFileTypes(FilesList, lbFilesTypes.Items) > 0 then
    begin
      SchemaChanged := True;
      FormatCaption;
    end;
  finally
    FilesList.Free;
  end;
end;

procedure TForm1.acRulesDeleteRuleExecute(Sender: TObject);
begin
  // Delete rule


end;

procedure TForm1.btnBrowseClick(Sender: TObject);
var Dir: String;
begin
  if SelectDirectory('', '', Dir) then
  begin
    if Copy(Dir, Length(Dir), 1) <> '\' then
      Dir := Dir + '\';
    ledRootPath.Text := Dir;
  end;
end;

procedure TForm1.acFilesDelFileTypeExecute(Sender: TObject);
var Index: Integer;
begin
  //
  with lbFilesTypes do
  begin
    Index := ItemIndex;
    if Index = -1 then Exit;
    Items.Delete(Index);
    if Count > Index then
      ItemIndex := Index
    else
      ItemIndex := Index - 1;
  end;
  SchemaChanged := True;
  FormatCaption;
end;

procedure TForm1.acFilesAddFilesExecute(Sender: TObject);

  function AddFiles(FilesList: TFilesList; Strings, Strings2: TStrings): Integer;
  var i: Integer; FileExt: String;
  begin
    Result := 0;
    for i := 0 to FilesList.FilesCount - 1 do
    begin
      FileExt := AnsiLowerCase(ExtractFileExt(FilesList[i].Name));
      if (Strings2.IndexOf(FileExt) <> -1) or (Strings2.Count = 0) then
        if Strings.IndexOf(FilesList[i].FullPath) = -1 then
        begin
          Strings.Add(FilesList[i].FullPath);
          Result := Result + 1;
        end;
    end;
    for i := 0 to FilesList.FoldersCount - 1 do
      Result := Result + AddFiles(FilesList.Folders[i], Strings, Strings2);
  end;


var FilesList: TFilesList;
begin
  // Добавляем файлы
  PageControl2.ActivePage := tsFilesList;
  // сканируем все файлы
  FilesList := TFilesList.Create;
  try
    FilesList.Scan(ledRootPath.Text, '*.*', chbScanSubFolders.Checked);
    if AddFiles(FilesList, lbFiles.Items, lbFilesTypes.Items) > 0 then
    begin
      SchemaChanged := True;
      FormatCaption;
    end;
  finally
    FilesList.Free;
  end;

end;

procedure TForm1.acFilesDeleteFileExecute(Sender: TObject);
var Index: Integer;
begin
  with lbFiles do
  begin
    Index := ItemIndex;
    if Index = -1 then Exit;
    Items.Delete(Index);
    if Count > Index then
      ItemIndex := Index
    else
      ItemIndex := Index - 1;
  end;
  SchemaChanged := True;
  FormatCaption;
end;

procedure TForm1.acReplaceDoItExecute(Sender: TObject);

  function FindAndReplace(Strings, Rules: TStrings): Boolean;
  var i,j,k: Integer; s: String; 
  begin
    Result := False;

    for i := 0 to Strings.Count - 1 do
    begin
      for j := 0 to Rules.Count - 1 do
      begin
        k := Pos(Rules.Names[j], Strings[i]);
        if k <> 0 then
        begin
//        s := AnsiReplaceText(Strings[i], Rules.Names[j], Rules.Values[Rules.Names[j]]);  // case ignore function
          s := AnsiReplaceStr(Strings[i], Rules.Names[j], Rules.Values[Rules.Names[j]]);
          if CompareStr(Strings[i], s) <> 0 then
          begin
            Strings[i] := s;
            Result := True;
          end;
        end;
      end;
    end;  
  end;

var i: Integer; sl: TStringList;
begin
  // Замена по всем файлам из списка
  PageControl1.ActivePage := tsReplace;
  ProgressBar1.Position := 0;
  ProgressBar1.Max := lbFiles.Items.Count;
  Panel2.Visible := True;
  sl := TStringList.Create;
  try
    for i := 0 to lbFiles.Items.Count - 1 do
    begin
      sl.LoadFromFile(lbFiles.Items[i]);

      // автозамена по ранее заготовленным шаблонам
      if FindAndReplace(sl, Memo2.Lines) then
      begin
        sl.SaveToFile(lbFiles.Items[i]);
        // добавить запись в лог о сохранении файла
        Memo1.Lines.Add(Format('File %s changed and saved',[lbFiles.Items[i]]));
      end;

      ProgressBar1.Position := ProgressBar1.Position + 1;
      Application.ProcessMessages;
    end;
  finally
    sl.Free;
    Panel2.Visible := False;
  end;
end;

end.
