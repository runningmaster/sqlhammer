unit ideSHSysUtils;

interface

uses
  Windows, SysUtils, Classes, Forms, Dialogs, Graphics, TypInfo, Mapi, IniFiles,
  Controls, ComCtrls, ExtCtrls, StdCtrls, Consts,
  ideSHConsts, ideSHMessages;

procedure UnderConstruction;
procedure NotSupported;

function ShowMsg(const AMsg: string; DialogType: TMsgDlgType; ACaptionBox: string = ''; AFlags: Integer = 0): Boolean; overload;
function ShowMsg(const AMsg: string): Integer; overload;
procedure AbortWithMsg(const AMsg: string = '');
function InputQueryExt(const ACaption, APrompt: string;
  var Value: string; CancelBtn: Boolean = True; PswChar: Char = #0): Boolean;
function InputBoxExt(const ACaption, APrompt, ADefault: string;
  CancelBtn: Boolean = True; PswChar: Char = #0): string;
function StrToMailBody(const S: string): string;

function GetNextItem(AIndex, ACount: Integer): Integer;

function GetProductName: string;
function GetCopyright: string;
function GetOSVersion: string;
function GetAvailMemory: string;

function GetDxColor: TColor;
function GetAppPath: string;
function GetDirPath(const DirName: string): string;
function GetFilePath(const FileName: string): string;
function EncodeAppPath(const FileName: string): string;
function DecodeAppPath(const FileName: string): string;

procedure FileCopy(const SourceFileName, TargetFileName: string);
procedure BackupConfigFile(const CurrentFileName, BackupFileName: string);
procedure ForceConfigFile(const FileName: string);
procedure EraseSectionInFile(const FileName, Section: string);
procedure DeleteKeyInFile(const FileName, Section, Ident: String);
procedure SaveStringsToFile(const FileName, Section: string; Source: TStrings; aEraseSection:boolean=False );
function LoadStringsFromFile(const FileName, Section: string; Dest: TStrings): Boolean;
procedure GetPropValues(Source: TPersistent; AParentName: string; AStrings: TStrings;
  PropNameList: TStrings = nil; Include: Boolean = True);
procedure SetPropValues(Dest: TPersistent; AParentName: string; AStrings: TStrings;
  PropNameList: TStrings = nil; Include: Boolean = True);
procedure WritePropValuesToFile(const FileName, Section: string;
  Source: TPersistent; PropNameList: TStrings = nil; Include: Boolean = True);


procedure ReadPropValuesFromFile(const FileName, Section: string;
  Dest: TPersistent; PropNameList: TStrings = nil; Include: Boolean = True);

function Execute(const CommandLine, WorkingDirectory: string): Integer;  
function SendMail(ARecepients, ASubject, AMessage, AFiles: string): Integer;

function GetHintLeftPart(const Hint: string; Separator: string = '|'): string;
function GetHintRightPart(const Hint: string; Separator: string = '|'): string;

procedure AntiLargeFont(AComponent: TComponent);
procedure TextToStrings(const AText: string; AList: TStrings;
  DoClear: Boolean = False; DoInsert: Boolean = False);

implementation

uses StrUtils;

procedure UnderConstruction;
begin
  ShowMsg(Format('%s', [SUnderConstruction]), mtWarning);
end;

procedure NotSupported;
begin
  ShowMsg(Format('%s', [SNotSupported]), mtWarning);
end;

function ShowMsg(const AMsg: string; DialogType: TMsgDlgType; ACaptionBox: string = ''; AFlags: Integer = 0): Boolean;
var
  CaptionBox: string;
  MessageText, MessageCaption: PChar;
  Flags: Integer;
begin
  Flags := 0;
  case DialogType of
    mtWarning:
      begin
        CaptionBox := sWarning;
        Flags := MB_OK + MB_ICONWARNING;
      end;
    mtError:
      begin
        CaptionBox := sError;
        Flags := MB_OK + MB_ICONERROR;
      end;
    mtInformation:
      begin
        CaptionBox := sInformation;
        Flags := MB_OK + MB_ICONINFORMATION;
      end;
    mtConfirmation:
      begin
        CaptionBox := sConfirmation;
        Flags := MB_OKCANCEL + MB_ICONQUESTION;
      end;
    mtCustom: ;
  end;

  MessageText := PChar(AMsg);
  if Length(ACaptionBox) > 0 then CaptionBox := ACaptionBox;
  if AFlags > 0 then Flags := AFlags;
  MessageCaption := PChar(CaptionBox);

  with Application do
  begin
    NormalizeTopMosts;
    Result := MessageBox(MessageText, MessageCaption, Flags) = IDOK;
    RestoreTopMosts;
  end;
end;

function ShowMsg(const AMsg: string): Integer;
var
  CaptionBox: string;
  MessageText, MessageCaption: PChar;
  Flags: Integer;
begin
  CaptionBox := sQuestion;
  Flags := MB_YESNOCANCEL + MB_ICONQUESTION;

  MessageText := PChar(AMsg);
  MessageCaption := PChar(CaptionBox);

  with Application do
  begin
    NormalizeTopMosts;
    Result := MessageBox(MessageText, MessageCaption, Flags);
    RestoreTopMosts;
  end
end;

procedure AbortWithMsg(const AMsg: string = '');
begin
  if Length(AMsg) > 0  then ShowMsg(AMsg, mtWarning);
  SysUtils.Abort;
end;

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function InputQueryExt(const ACaption, APrompt: string;
  var Value: string; CancelBtn: Boolean = True; PswChar: Char = #0): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  SysMenu: HMENU;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := APrompt;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        PasswordChar := PswChar;
        Text := Value;
        SelectAll;
      end;
      ButtonTop := Edit.Top + Edit.Height + 15;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := SMsgDlgOK;
        ModalResult := mrOk;
        Default := True;
        if not CancelBtn then
        begin
          SysMenu := GetSystemMenu(Form.Handle, False);
          Windows.EnableMenuItem(SysMenu, SC_CLOSE, MF_DISABLED or MF_GRAYED);
          SetBounds(Edit.Width div 2 - (ButtonWidth div 2) + 8, ButtonTop, ButtonWidth, ButtonHeight);
          Form.ClientHeight := Top + Height + 13;
        end else
          SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth, ButtonHeight);
      end;

      if CancelBtn then
        with TButton.Create(Form) do
        begin
          Parent := Form;
          Caption := SMsgDlgCancel;
          ModalResult := mrCancel;
          Cancel := True;
          SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
            ButtonWidth, ButtonHeight);
          Form.ClientHeight := Top + Height + 13;
        end;

      if ShowModal = mrOk then
      begin
        Value := Edit.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;

function InputBoxExt(const ACaption, APrompt, ADefault: string;
  CancelBtn: Boolean = True; PswChar: Char = #0): string;
begin
  Result := ADefault;
  InputQueryExt(ACaption, APrompt, Result, CancelBtn, PswChar);
end;

function StrToMailBody(const S: string): string;
begin
  Result := AnsiReplaceStr(S, ' ', '%20');
  Result := AnsiReplaceStr(Result, SLineBreak, '%0D');
end;

function GetNextItem(AIndex, ACount: Integer): Integer;
begin
  Result := -1;
  if AIndex > 0 then Result := AIndex - 1
  else
    if ACount > 0 then Result := AIndex;
end;

function GetProductName: string;
begin
  Result := Format('%s', ['BlazeTop']);
end;

function GetCopyright: string;
begin
  Result := Format('%s', ['Copyright (c) 2006-2007 Devrace']);
end;

function GetOSVersion: string;
begin
  case Win32Platform of
    VER_PLATFORM_WIN32_WINDOWS: Result := Format('Windows 95/98/ME %s', [Win32CSDVersion]);
    VER_PLATFORM_WIN32_NT:
      begin
        case Win32MajorVersion of
          4: Result := Format('Windows %s %d.%d', ['NT', Win32MajorVersion, Win32MinorVersion]);
          5: Result := Format('Windows %s', ['2000']);
          6: Result := Format('Windows %s', ['XP']);
        end;
        Result := Format(Result + ' (Build %d %s)', [Win32BuildNumber, Win32CSDVersion]);
      end;
  end;
end;

function GetAvailMemory: string;
var
  FMemory: _MEMORYSTATUS;
begin
  GlobalMemoryStatus(FMemory);
  Result := Format(SMemoryAvailable, [FormatFloat('###,###,###,###', FMemory.dwTotalPhys div 1024)]);
end;

function GetDxColor: TColor;
const
  DxDelta: Integer = 20;
var
  R, G, B: Integer;
begin
  Result := GetSysColor(COLOR_BTNFACE);
  R := GetRValue(Result) + DxDelta;
  if R > 255 then R := 255;
  G := GetGValue(Result) + DxDelta;
  if G > 255 then G := 255;
  B := GetBValue(Result) + DxDelta;
  if B > 255 then B := 255;

  Result := RGB(R, G, B);
end;

function GetAppPath: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
end;

function GetDirPath(const DirName: string): string;
begin
  Result := IncludeTrailingPathDelimiter(GetAppPath) + DirName;
end;

function GetFilePath(const FileName: string): string;
begin
  Result := IncludeTrailingPathDelimiter(GetAppPath) + FileName;
end;

function EncodeAppPath(const FileName: string): string;
var
  I: Integer;
  S: string;
begin
  I := 0;
  S := GetAppPath;
  S := Copy(S, 1, Length(S) - (Length(SDirBin) - Length(SDirRoot) + 1));
  Result := '';
  while I < Length(FileName) do
  begin
    Inc(I);
    Result := Result + FileName[I];
    if CompareStr(Result, S) = 0 then
      Result := SPathKey;
  end;
end;

function DecodeAppPath(const FileName: string): string;
var
  I: Integer;
  S: string;
begin
  I := 0;
  S := GetAppPath;
  S := Copy(S, 1, Length(S) - (Length(SDirBin) - Length(SDirRoot) + 1));
  Result := '';
  while I < Length(FileName) do
  begin
    Inc(I);
    Result := Result + FileName[I];
    if CompareStr(Result, SPathKey) = 0 then
      Result := S;
  end;
end;

procedure FileCopy(const SourceFileName, TargetFileName: string);
var
  SourceStream, TargetStream: TFileStream;
begin
  SourceStream := TFileStream.Create(SourceFileName, fmOpenRead or fmShareDenyNone);
  try
    TargetStream := TFileStream.Create(TargetFileName, fmCreate);
    try
      TargetStream.CopyFrom(SourceStream, SourceStream.Size);
    finally
      TargetStream.Free;
    end;
  finally
    SourceStream.Free;
  end;
end;

procedure BackupConfigFile(const CurrentFileName, BackupFileName: string);
begin
  if FileExists(CurrentFileName) then
  begin
    if FileExists(BackupFileName) then DeleteFile(BackupFileName);
    FileCopy(CurrentFileName, BackupFileName);
  end;
end;

procedure ForceConfigFile(const FileName: string);
var
  IniFile: TIniFile;
  Dir: string;
begin
  Dir:=ExtractFilePath(FileName);
  if not DirectoryExists(Dir) then
   ForceDirectories(Dir);         // Инакше будет бить ошибу 217
  IniFile := TIniFile.Create(FileName);
  try
    IniFile.WriteString('WARNING', 'README', 'DO NOT EDIT THIS FILE MANUALY');
  finally
    IniFile.Free;
  end;
end;

procedure EraseSectionInFile(const FileName, Section: string);
var
  IniFile: TMemIniFile;
begin
  IniFile := TMemIniFile.Create(FileName);
  try
    IniFile.EraseSection(Section);
  finally
    IniFile.UpdateFile;
    IniFile.Free;
  end;
end;

procedure DeleteKeyInFile(const FileName, Section, Ident: String);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FileName);
  try
    IniFile.DeleteKey(Section, Ident);
  finally
    IniFile.Free;
  end;
end;


type THackMemIniFile=class(TCustomIniFile)
     private
      FSections: TStringList;
     end;

procedure SaveStringsToFile(const FileName, Section: string; Source: TStrings;aEraseSection:boolean=False);
var
  IniFile: TMemIniFile;
  i,j:Integer;
  Podstava:boolean;
begin
  IniFile := TMemIniFile.Create(FileName);
  Podstava:=False;  
  if aEraseSection then
   IniFile.EraseSection(Section);
  try
  //Buzz:  Делаем очень подлый хак.  Зато шустрей не бывает
  // Да и с точки зрения порчи файла гораздо более устойчивей чем было.
   I:=THackMemIniFile(iniFile).FSections.IndexOf(Section);
   if I<0 then
   begin
    // Если секции не было или она удалена, то все пофиг
    Podstava:=True;
    I:=THackMemIniFile(iniFile).FSections.AddObject(Section, Source)
   end
   else
   begin
     for J := 0 to Pred(Source.Count) do
      IniFile.WriteString(Section, Source.Names[J], Source.ValueFromIndex[J]);
   end;
   IniFile.UpdateFile;
  finally
   if Podstava then
    THackMemIniFile(iniFile).FSections.Delete(i);
   //  чтоб при разрушении  объекта не свалиться
   // Поскольку мы подсунули свой TStrings  и он не должен быть разрушет

    FreeAndNil(IniFile);
  end;
end;

(* Old implementation

Buzz: Очень медленно и очень дерьмово

procedure SaveStringsToFile(const FileName, Section: string; Source: TStrings; aEraseSection:boolean=False );
var
  IniFile: TIniFile;
  I: Integer;
begin
  IniFile := TIniFile.Create(FileName);
  try
    for I := 0 to Pred(Source.Count) do
      IniFile.WriteString(Section, Source.Names[I], Source.ValueFromIndex[I]);
  finally
    FreeAndNil(IniFile);
  end;
end;
*)

(* Old implementation
function LoadStringsFromFile(const FileName, Section: string; Dest: TStrings): Boolean;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FileName);
  try
    Result := IniFile.SectionExists(Section);
    if Result then
      IniFile.ReadSectionValues(Section, Dest);
  finally
    FreeAndNil(IniFile);
  end;
end;
*)

function LoadStringsFromFile(const FileName, Section: string; Dest: TStrings): Boolean;
var
  F: System.TextFile;
  S: string;
  Correct: Boolean;
  SectionStr:String;
begin
  AssignFile(F, FileName);
  Reset(F);
  Correct := False;
  SectionStr:=AnsiUpperCase(Format('[%s]', [Section]));
  try
    while not SeekEof(F) do
    begin
      Readln(F, S);
      Correct := AnsiUpperCase(S) = SectionStr;
      if Correct then Break;
    end;

    S := EmptyStr;

    if Correct then
      while not SeekEof(F) do
      begin
        Readln(F, S);
        if Pos('[', S) = 1 then Break; 
        Dest.Add(S)
      end;
  finally
    CloseFile(F);
  end;
end;

procedure GetPropValues(Source: TPersistent; AParentName: string; AStrings: TStrings;
  PropNameList: TStrings = nil; Include: Boolean = True);

  function ComparePropName(const APropName: string): Boolean;
  begin
    Result := True;
    if Assigned(PropNameList) and Include then
      Result := PropNameList.IndexOf(APropName) <> -1;
    if Assigned(PropNameList) and not Include then
      Result := PropNameList.IndexOf(APropName) = -1;
    if Result and not (Source is TFont) then
      Result := not ((APropName = 'Name') or (APropName = 'Tag'));
  end;

var
  I: Integer;
  PropList: PPropList;
  ClassTypeInfo: PTypeInfo;
  ClassTypeData: PTypeData;
  PropName: string;
  PropKind: TTypeKind;
  PropWrite: Boolean;
  ObjectProp: TObject;
  S: string;
begin
  if not Assigned(Source) then Exit;

  ClassTypeInfo := Source.ClassInfo;
  ClassTypeData := GetTypeData(ClassTypeInfo);
  if ClassTypeData.PropCount > 0 then
  begin
    GetMem(PropList, SizeOf(PPropInfo) * ClassTypeData.PropCount);
    try
      GetPropInfos(Source.ClassInfo, PropList);
      SortPropList(PropList, ClassTypeData.PropCount);
      for I := 0 to Pred(ClassTypeData.PropCount) do
      begin
        PropName := PropList[I]^.Name;
        PropKind := PropList[I]^.PropType^.Kind;
        PropWrite := Assigned(PropList[I]^.SetProc);
        if ComparePropName(PropName) and (PropKind in tkProperties) and PropWrite then
        begin
          if PropKind = tkClass then
          begin
            ObjectProp := GetObjectProp(Source, PropName);
            if ObjectProp is TStrings then
            begin
//              AStrings.Add(Format('%s.%s=%s', [AParentName, PropName, TStrings(ObjectProp).CommaText]))
              S := TStrings(ObjectProp).Text;
              S := StringReplace(S, sLineBreak, SRegistryLineBreak, [rfReplaceAll, rfIgnoreCase]);
              AStrings.Add(Format('%s.%s=%s', [AParentName, PropName, S]))
            end
            else
              if ObjectProp is TPersistent then
                GetPropValues(TPersistent(ObjectProp), Format('%s.%s', [AParentName, PropName]), AStrings, PropNameList, Include);
          end;

          if PropKind <> tkClass then
            AStrings.Add(Format('%s.%s=%s', [AParentName, PropName, GetPropValue(Source, PropName, True)]));
        end;
      end;
    finally
      FreeMem(PropList, SizeOf(PPropInfo) * ClassTypeData.PropCount)
    end;
  end;
end;

procedure SetPropValues(Dest: TPersistent; AParentName: string; AStrings: TStrings;
  PropNameList: TStrings = nil; Include: Boolean = True);

  function ComparePropName(const APropName: string): Boolean;
  begin
    Result := True;
    if Assigned(PropNameList) and Include then
      Result := PropNameList.IndexOf(APropName) <> -1;
    if Assigned(PropNameList) and not Include then
      Result := PropNameList.IndexOf(APropName) = -1;
    if Result and not (Dest is TFont) then
      Result := not ((APropName = 'Name') or (APropName = 'Tag'));
  end;

var
  I: Integer;
  PropList: PPropList;
  ClassTypeInfo: PTypeInfo;
  ClassTypeData: PTypeData;
  PropName: string;
  PropKind: TTypeKind;
  PropWrite: Boolean;
  ObjectProp: TObject;
  S: string;
  vPropIndex: Integer;
begin
  if not Assigned(Dest) then Exit;

  ClassTypeInfo := Dest.ClassInfo;
  ClassTypeData := GetTypeData(ClassTypeInfo);
  if ClassTypeData.PropCount > 0 then
  begin
    GetMem(PropList, SizeOf(PPropInfo) * ClassTypeData.PropCount);
    try
      GetPropInfos(Dest.ClassInfo, PropList);
      SortPropList(PropList, ClassTypeData.PropCount);
      for I := 0 to Pred(ClassTypeData.PropCount) do
      begin
        PropName := PropList[I]^.Name;
        PropKind := PropList[I]^.PropType^.Kind;
        PropWrite := Assigned(PropList[I]^.SetProc);
        if ComparePropName(PropName) and (PropKind in tkProperties) and PropWrite then
        begin
          if PropKind = tkClass then
          begin
            ObjectProp := GetObjectProp(Dest, PropName);
            if ObjectProp is TStrings then
            begin
              vPropIndex := AStrings.IndexOfName(Format('%s.%s', [AParentName, PropName]));
              if vPropIndex <> -1 then
              begin
//                TStrings(ObjectProp).CommaText := AStrings.Values[Format('%s.%s', [AParentName, PropName])];
                S := AStrings.ValueFromIndex[vPropIndex];
                S := StringReplace(S, SRegistryLineBreak, sLineBreak, [rfReplaceAll, rfIgnoreCase]);
                TStrings(ObjectProp).Text := S;
              end;
            end else
              if ObjectProp is TPersistent then
                SetPropValues(TPersistent(ObjectProp), Format('%s.%s', [AParentName, PropName]), AStrings, PropNameList, Include);
          end;

          if PropKind <> tkClass then
          begin
            vPropIndex := AStrings.IndexOfName(Format('%s.%s', [AParentName, PropName]));
            if vPropIndex <> -1 then
              SetPropValue(Dest, PropName, AStrings.ValueFromIndex[vPropIndex]);
          end;
        end;
      end;
    finally
      FreeMem(PropList, SizeOf(PPropInfo) * ClassTypeData.PropCount)
    end;
  end;
end;



procedure WritePropValuesToFile(const FileName, Section: string;
  Source: TPersistent; PropNameList: TStrings = nil; Include: Boolean = True);
var
  PropNameValues: TStrings;
begin
  PropNameValues := TStringList.Create;
  try
    GetPropValues(Source, Source.ClassName, PropNameValues, PropNameList, Include);
    SaveStringsToFile(FileName, Section, PropNameValues);
  finally
    FreeAndNil(PropNameValues);
  end;
end;

procedure ReadPropValuesFromFile(const FileName, Section: string;
  Dest: TPersistent; PropNameList: TStrings = nil; Include: Boolean = True);
var
  PropNameValues: TStrings;
begin
  PropNameValues := TStringList.Create;
  try
    LoadStringsFromFile(FileName, Section, PropNameValues);
    SetPropValues(Dest, Dest.ClassName, PropNameValues, PropNameList, Include);
  finally
    FreeAndNil(PropNameValues);
  end;
end;

//  ShowMessage(IntToStr(Execute('C:\Programs\AraxisMerge\Merge.exe D:\Programs\WinMerge\1.pas D:\Programs\WinMerge\2.pas', ExtractFilePath(ParamStr(0)))));
// From JvUtils.pas
function Execute(const CommandLine, WorkingDirectory: string): Integer;
var
  R: Boolean;
  ProcessInformation: TProcessInformation;
  StartupInfo: TStartupInfo;
  ExCode: THandle;
begin
  Result := 0;
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_SHOW;
  end;
  R := CreateProcess(
    nil, // Pointer to name of executable module
    PChar(CommandLine), // Pointer to command line string
    nil, // Pointer to process security attributes
    nil, // Pointer to thread security attributes
    False, // handle inheritance flag
    0, // creation flags
    nil, // Pointer to new environment block
    PChar(WorkingDirectory), // Pointer to current directory name
    StartupInfo, // Pointer to STARTUPINFO
    ProcessInformation); // Pointer to PROCESS_INFORMATION
  if R then
    while (GetExitCodeProcess(ProcessInformation.hProcess, ExCode) and
      (ExCode = STILL_ACTIVE)) do
      Application.ProcessMessages
  else
    Result := GetLastError;
end;

function SendMail(ARecepients, ASubject, AMessage, AFiles: string): Integer;
var
  Msg: MapiMessage;
  DFile, CFile: MapiFileDesc;
  ToRec: MapiRecipDesc;
  Flags: Cardinal;
begin
  ToRec.ulReserved := 0;
  ToRec.ulRecipClass := 0;
  ToRec.lpszName := PChar('');
  ToRec.lpszAddress := Pchar(ARecepients);
  ToRec.ulRecipClass := MAPI_TO;
  ToRec.ulEIDSize := 0;

  DFile.ulReserved := 0;
  DFile.flFlags := 0;
  DFile.nPosition := $FFFFFFFF;

  DFile.lpszPathName := PChar(AFiles);
  DFile.lpszFileName := nil;
  DFile.lpFileType := nil;

  CFile.ulReserved := 0;
  CFile.flFlags := 0;
  CFile.nPosition := $FFFFFFFF;
  CFile.lpszPathName := '';
  CFile.lpszFileName := nil;
  CFile.lpFileType := nil;

  Msg.ulReserved := 0;
  Msg.lpszSubject := PChar(ASubject);
  Msg.lpszNoteText := PChar(AMessage);
  Msg.lpszMessageType := nil;
  Msg.lpszDateReceived := nil;
  Msg.lpszConversationID := nil;
  Msg.flFlags := 0;
  Msg.lpOriginator := nil;
  Msg.nRecipCount := 1;
  Msg.lpRecips := @ToRec;
  Msg.nFileCount := 0;
  Msg.lpFiles := @CFile;
  Flags := MAPI_LOGON_UI or MAPI_NEW_SESSION;
  Flags := Flags or MAPI_DIALOG;
  Result := MAPISendMail(0, 0, Msg, Flags, 0);
end;

function GetHintLeftPart(const Hint: string; Separator: string = '|'): string;
var
  I: Integer;
begin
  Result := Hint;
  I := Pos(Separator, Hint);
  if I > 0 then Result := Copy(Hint, 0, I - 1);
end;

function GetHintRightPart(const Hint: string; Separator: string = '|'): string;
var
  I: Integer;
begin
  Result := EmptyStr;
  I := Pos(Separator, Hint);
  if I > 0 then Result := Copy(Hint, I + 1, Length(Hint) - I);
end;

procedure AntiLargeFont(AComponent: TComponent);
var
  I: Integer;
  FontName: string;
begin
  FontName := 'Tahoma';
  if AComponent is TForm then TForm(AComponent).Scaled := False;

  for I := 0 to Pred(AComponent.ComponentCount) do
  begin
    if (AComponent.Components[I] is TControl) and IsPublishedProp(AComponent.Components[I], 'Font') then
      if TControl(AComponent.Components[I]).Tag <> -1 then
        TFont(GetObjectProp(AComponent.Components[I], 'Font')).Name := FontName;
    if (AComponent.Components[I] is TControl) and IsPublishedProp(AComponent.Components[I], 'TitleFont') then
      if TControl(AComponent.Components[I]).Tag <> -1 then
        TFont(GetObjectProp(AComponent.Components[I], 'TitleFont')).Name := FontName;
    if (AComponent.Components[I] is TComponent) then
      AntiLargeFont(AComponent.Components[I] as TComponent);

    if Screen.PixelsPerInch > 96 then
    begin
      if (AComponent.Components[I] is TToolBar) then
        TToolBar(AComponent.Components[I]).AutoSize := False;
      if (AComponent.Components[I] is TControlBar) then
        TControlBar(AComponent.Components[I]).RowSize := 32;
    end;
  end;
end;

procedure TextToStrings(const AText: string; AList: TStrings;
  DoClear: Boolean = False; DoInsert: Boolean = False);
var
  P, Start, BeginStr: PChar;
  S: string;
begin
  with AList do
  begin
    BeginUpdate;
    try
      if DoClear then Clear;
      P := Pointer(AText);
      if DoInsert then
      begin
        BeginStr := P;
        Inc(P, Length(AText) - 1);
        if P <> nil then
          while P > BeginStr do
          begin
            if P^ = #10 then Dec(P);
            if P^ = #13 then Dec(P);
            Start := P;
            while not (P^ in [#0, #10, #13]) do Dec(P);
            SetString(S, P + 1, Start - P);
            Insert(0, S);
          end;
      end
      else
      begin
        if P <> nil then
          while P^ <> #0 do
          begin
            Start := P;
            while not (P^ in [#0, #10, #13]) do Inc(P);
            SetString(S, Start, P - Start);
            Add(S);
            if P^ = #13 then Inc(P);
            if P^ = #10 then Inc(P);
          end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

end.

