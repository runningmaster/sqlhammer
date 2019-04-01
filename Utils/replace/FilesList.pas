unit FilesList;

interface

uses Classes, SysUtils;

type

  TFilesList = class;

  TFileListOption = (floRecursive);
  TFileListOptions = set of TFileListOption;

  TFileInfo = class
  private
    FSize: Integer;
    FAttr: Integer;
    FPath: String;
    FName: String;
    FOwner: TFilesList;
    function GetFullPath: String;
  public
    property Owner: TFilesList read FOwner;
    property Name: String read FName;
    property Path: String read FPath;
    property Attr: Integer read FAttr;
    property Size: Integer read FSize;
    property FullPath: String read GetFullPath;
  end;

  TFileListOnFileEvent = procedure (FileInfo: TFileInfo; var AddToList: Boolean) of Object;

  TFilesList = class
  private
    FFiles: TList;
    FFolders: TList;
    FRoot: String;
    FMask: String;
    FOnFile: TFileListOnFileEvent;
    function GetFiles(Index: Integer): TFileInfo;
    function GetFolders(Index: Integer): TFilesList;
    procedure AddFile(FileName, Path: String; Attr: Integer; Size: Integer);
    procedure AddFolder(FilesList: TFilesList);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Scan(RootPath, Mask: String; Recursive: Boolean = False);
    function FilesCount: Integer;
    function FoldersCount: Integer;
    procedure Clear;

    property Files[Index: Integer]: TFileInfo read GetFiles; default;
    property Folders[Index: Integer]: TFilesList read GetFolders;
    property Root: String read FRoot;
    property Mask: String read FMask;
    property OnFile: TFileListOnFileEvent read FOnFile;
  end;

implementation

{ TFileInfo }

function TFileInfo.GetFullPath: String;
begin
  Result := FPath + FName;
end;

{ TFilesList }

function TFilesList.FilesCount: Integer;
begin
  Result := FFiles.Count;
end;

constructor TFilesList.Create;
begin
  inherited Create;
  FFiles := TList.Create;
  FFolders := TList.Create;
end;

destructor TFilesList.Destroy;
begin
  Clear;
  FFiles.Free;
  FFolders.Free;
  inherited Destroy;
end;

function TFilesList.GetFiles(Index: Integer): TFileInfo;
begin
  Result := TFileInfo(FFiles.Items[Index]);
end;

procedure TFilesList.Clear;
var i: Integer;
begin
  for i := 0 to FilesCount - 1 do
    TFileInfo(FFiles.Items[i]).Free;
  FFiles.Clear;
  for i := 0 to FoldersCount - 1 do
    TFilesList(FFolders.Items[i]).Free;
  FFolders.Clear;
end;

{$WARNINGS OFF}
procedure TFilesList.Scan(RootPath, Mask: String; Recursive: Boolean = False);
const
  Attr = faAnyFile - faVolumeID - faHidden - faSysFile - faSymLink;
var
  SearchRec: TSearchRec; res: Integer; Item: TFilesList;
begin
  if Copy(RootPath, Length(RootPath), 1) <> '\' then
    RootPath := RootPath + '\';
  FRoot := RootPath;
  FMask := Mask;
  res := FindFirst(RootPath + Mask, Attr, SearchRec);
  while res = 0 do
  begin
    if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
    begin
      if (SearchRec.Attr and faDirectory) = 0 then
        AddFile(SearchRec.Name, RootPath, SearchRec.Attr, SearchRec.Size)
      else
        if Recursive then
        begin
          Item := TFilesList.Create;
          Item.Scan(RootPath + SearchRec.Name + '\', Mask, Recursive);
          if Item.FoldersCount + Item.FilesCount > 0 then
            AddFolder(Item)
          else
            Item.Free;
        end;
    end;
    res := FindNext(SearchRec);
  end;
end;
{$WARNINGS ON}

function TFilesList.GetFolders(Index: Integer): TFilesList;
begin
  Result := TFilesList(FFolders.Items[Index]);
end;

function TFilesList.FoldersCount: Integer;
begin
  Result := FFolders.Count;
end;

procedure TFilesList.AddFile(FileName, Path: String; Attr, Size: Integer);
var Item: TFileInfo; var AddToList: Boolean;
begin
  AddToList := True;
  Item := TFileInfo.Create;
  try
    Item.FOwner := Self;
    Item.FName := FileName;
    Item.FPath := Path;
    Item.FAttr := Attr;
    Item.FSize := Size;
    if Assigned(FOnFile) then
      FOnFile(Item, AddToList);
  finally
    if AddToList then
      FFiles.Add(Item)
    else
      Item.Free;
  end;
end;

procedure TFilesList.AddFolder(FilesList: TFilesList);
begin
  FFolders.Add(FilesList);
end;

end.
