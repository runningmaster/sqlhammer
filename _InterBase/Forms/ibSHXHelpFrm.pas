unit ibSHXHelpFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, StdCtrls, ComCtrls;

type
  TibSHXHelpForm = class(TibBTComponentForm)
    reHelpContext: TRichEdit;
  private
    { Private declarations }
  protected
    procedure LoadContextHelp;
    function DoOnOptionsChanged: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;
  end;

var
  ibSHXHelpForm: TibSHXHelpForm;

implementation

{$R *.dfm}

{ TibSHXHelpForm }

constructor TibSHXHelpForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);

//  Editor := pSHSynEdit1;
//  Editor.Lines.Clear;
//  Editor.Lines.Add(Format('Context help for "%s" component', [Component.Hint]));
//  Editor.Lines.Add('Sorry,... coming soon. Under construction.');
//  FocusedControl := Editor;
  DoOnOptionsChanged;
//  LoadContextHelp;
end;

destructor TibSHXHelpForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibSHXHelpForm.LoadContextHelp;
const
  FILE_EXT = 'SQLHammer*.rtf';
var
  vDocumentationDir: string;

  SearchRec: TSearchRec;
  FileAttrs: Integer;
  procedure ForceCloseAllBrackets(AStrings: TStrings);
  var
    S: string;
    vOpenedBrackets, vClosedBrackets: Cardinal;
    I: Integer;
  begin
    vOpenedBrackets := 0;
    vClosedBrackets := 0;
    S := AStrings.Text;
    for I := 1 to Length(S) do
      if S[I] = '{' then
      begin
        if not ((I > 1) and (S[I-1] = '\')) then
          Inc(vOpenedBrackets);
      end else
      if S[I] = '}' then
      begin
        if not ((I > 1) and (S[I-1] = '\')) then
        begin
          Inc(vClosedBrackets);
          if vClosedBrackets > vOpenedBrackets then
          begin
            AStrings.Insert(0, '{');
            Inc(vOpenedBrackets);
          end;
        end;
      end;
    if vOpenedBrackets > vClosedBrackets then
      for I := 1 to vOpenedBrackets - vClosedBrackets do
        AStrings.Add('}')
    else
    if vOpenedBrackets < vClosedBrackets then
      for I := 1 to vClosedBrackets - vOpenedBrackets do
        AStrings.Insert(0, '{');
  end;
  function GetUserManualTempFileName(APrefix: string): string;
  var
    vTempPath: PChar;
    vTempFile: PChar;
    vNeedPath: Cardinal;
  begin
    vTempPath := StrAlloc(MAX_PATH + 1);
    vTempFile := StrAlloc(MAX_PATH + MAX_PATH + 1);
    try
      vNeedPath := GetTempPath(MAX_PATH, vTempPath);
      if vNeedPath > MAX_PATH then
      begin
        StrDispose(vTempPath);
        vTempPath := StrAlloc(vNeedPath + 1);
        GetTempPath(vNeedPath, vTempPath);
      end;
      GetTempFileName(vTempPath, PChar(APrefix), 0, vTempFile);
      SetString(Result, vTempFile, StrLen(vTempFile));
      DeleteFile(Result);
    finally
      StrDispose(vTempPath);
      StrDispose(vTempFile);
    end;
  end;
  function LoadContextHelpFromFile(AFileName: string): Boolean;
  var
    F: TextFile;
    vComponentHelp: TStringList;
    vBody: TStringList;
    S: string;
    vHeaderLoaded: Boolean;
    vPos: Integer;
    vStartFinded: Boolean;
    vForceDeleteParagraph: Boolean;
    vSearchIdentifire: string;
    vFileName: string;
  begin
    Result := False;
    vHeaderLoaded := False;
    vStartFinded := False;
    vForceDeleteParagraph := False;
    vSearchIdentifire := GUIDToString(Component.ClassIID);
    if Length(vSearchIdentifire) > 1 then
    begin
      Delete(vSearchIdentifire, 1, 1);
      Delete(vSearchIdentifire, Length(vSearchIdentifire), 1);
    end;
    AssignFile(F, AFileName);
    vComponentHelp := TStringList.Create;
    vBody := TStringList.Create;
    try
      Reset(F);
      while not EOF(F) do
      begin
        ReadLn(F, S);
        if not vHeaderLoaded then
        begin
          vPos := Pos('{\info', S);
          if vPos = 0 then
            vComponentHelp.Add(S)
          else
          begin
            vComponentHelp.Add(System.Copy(S, 1, vPos - 1));
            vHeaderLoaded := True;
          end;
        end
        else
        begin
          vPos := Pos(vSearchIdentifire, S);
          if vPos > 0 then
          begin
            if not vStartFinded then
            begin
             vPos := vPos + Length(vSearchIdentifire) + 2;
             vStartFinded := True;
             S := System.Copy(S, vPos, MaxInt);
             vPos := Pos('\par', S);
             if vPos > 0 then
             begin
               Delete(S, vPos, Length('\par'));
               vForceDeleteParagraph := False;
             end
             else
               vForceDeleteParagraph := True;

             vBody.Add(S);
            end
            else
            begin
              vPos := vPos - 2;
              vBody.Add(System.Copy(S, 1, vPos - 1));
              Break;
            end;
          end
          else
            if vStartFinded then
            begin
              if vForceDeleteParagraph then
              begin
                 vPos := Pos('\par', S);
                 if vPos > 0 then
                 begin
                   Delete(S, vPos, Length('\par'));
                   vForceDeleteParagraph := False;
                 end;
              end;
              vBody.Add(S);
            end;
        end;
      end;
      if vBody.Count > 0 then
      begin
        vFileName := GetUserManualTempFileName('sha');
        ForceCloseAllBrackets(vBody);
        vComponentHelp.SaveToFile('c:\1.txt');
        vComponentHelp.AddStrings(vBody);
        vComponentHelp.Add('}');
        vComponentHelp.SaveToFile('c:\2.txt');
        vComponentHelp.SaveToFile(vFileName);
        reHelpContext.PlainText := False;
        reHelpContext.Lines.LoadFromFile(vFileName);
        DeleteFile(vFileName);
        Result := True;
      end;
    finally
      CloseFile(F);
      vComponentHelp.Free;
      vBody.Free;
    end;
  end;
  function GetUserManualDir: string;
  begin
    Result := IncludeTrailingPathDelimiter(Designer.GetApplicationPath) + '..\Data\Resources\Documentation\';
  end;
begin
  if Assigned(Component) and (not IsEqualGUID(Component.ClassIID, IUnknown)) then
  begin
    vDocumentationDir := GetUserManualDir;
    if DirectoryExists(vDocumentationDir) then
    begin
      FileAttrs := 0;
      if FindFirst(Format('%s%s', [vDocumentationDir, FILE_EXT]), FileAttrs, SearchRec) = 0 then
      begin
        repeat
          if LoadContextHelpFromFile(Format('%s%s', [vDocumentationDir, SearchRec.Name])) then Break;
        until FindNext(SearchRec) <> 0;
        FindClose(SearchRec);
      end;
    end;
  end;
end;

function TibSHXHelpForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
  if Result and Assigned(Editor) then
  begin
    Editor.Highlighter := nil;
    // Принудительная установка фонта
    Editor.Font.Charset := 1;
    Editor.Font.Color := clWindowText;
    Editor.Font.Height := -13;
    Editor.Font.Name := 'Courier New';
    Editor.Font.Pitch := fpDefault;
    Editor.Font.Size := 10;
    Editor.Font.Style := [];
    
    Editor.ReadOnly := True;
  end;
end;

end.
 
 
 
