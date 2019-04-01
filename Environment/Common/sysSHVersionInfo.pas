// Информация о версии (Version Info)
// Автор Rick Peterson
//
////////////////////////////////////////////////////
unit sysSHVersionInfo;
interface
uses Windows,TypInfo;

type
{$M+}
TVersionType=(vtCompanyName, vtFileDescription, vtFileVersion, vtInternalName,
              vtLegalCopyright,vtLegalTradeMark, vtOriginalFileName,
              vtProductName, vtProductVersion, vtComments);
{$M-}

  TVersionInfo = class
  private
   FVersionInfo : Array [0 .. ord(high(TVersionType))] of string;
   FModuleName  : string;
  protected
   function GetCompanyName: string;
   function GetFileDescription: string;
   function GetFileVersion: string;
   function GetInternalName: string;
   function GetLegalCopyright: string;
   function GetLegalTradeMark: string;
   function GetOriginalFileName: string;
   function GetProductName: string;
   function GetProductVersion: string;
   function GetComments: string;
   function GetVersionInfo(VersionType: TVersionType): string; virtual;
   procedure SetVersionInfo; virtual;
  public
   constructor Create(const AModuleName : string);
   destructor  Destroy ; override;
  published
   property CompanyName: string read GetCompanyName;
   property FileDescription: string read GetFileDescription;
   property FileVersion: string read GetFileVersion;
   property InternalName: string read GetInternalName;
   property LegalCopyright: string read GetLegalCopyright;
   property LegalTradeMark: string read GetLegalTradeMark;
   property OriginalFileName: string read GetOriginalFileName;
   property ProductName: string read GetProductName;
   property ProductVersion: string read GetProductVersion;
   property Comments: string read GetComments;
  end;

function  VersionString(const ModuleName:string):string;
  
implementation

function  VersionString(const ModuleName:string):string;
var
   vi:TVersionInfo;
begin
  vi:=TVersionInfo.Create(ModuleName);
  try
   Result:=vi.FileVersion;
  finally
   vi.Free
  end;
end;

constructor TVersionInfo.Create(const AModuleName : string);
begin
  inherited Create;
  FModuleName:=AModuleName;
  SetVersionInfo;
end;

function TVersionInfo.GetCompanyName: string;
begin
  Result := GeTVersionInfo(vtCompanyName);
end;

function TVersionInfo.GetFileDescription: string;
begin
  Result := GeTVersionInfo(vtFileDescription);
end;

function TVersionInfo.GetFileVersion: string;
begin
  Result := GeTVersionInfo(vtFileVersion);
end;

function TVersionInfo.GetInternalName: string;
begin
  Result := GeTVersionInfo(vtInternalName);
end;

function TVersionInfo.GetLegalCopyright: string;
begin
  Result := GeTVersionInfo(vtLegalCopyright);
end;

function TVersionInfo.GetLegalTradeMark: string;
begin
  Result := GeTVersionInfo(vtLegalTradeMark);
end;

function TVersionInfo.GetOriginalFileName: string;
begin
  Result := GeTVersionInfo(vtOriginalFileName);
end;

function TVersionInfo.GetProductName: string;
begin
  Result := GeTVersionInfo(vtProductName);
end;

function TVersionInfo.GetProductVersion: string;
begin
  Result := GeTVersionInfo(vtProductVersion);
end;

function TVersionInfo.GetComments: string;
begin
  Result := GeTVersionInfo(vtComments);
end;

function TVersionInfo.GeTVersionInfo(VersionType: TVersionType): string;
begin
  Result := FVersionInfo[ord(VersionType)];
end;

function _LangToHexStr(pbyteArray: PByte) : string;
Const HexChars : array [0..15] of char = '0123456789ABCDEF';
begin
   Result:='';
   inc(pbyteArray);
   Result := Result + HexChars[pbyteArray^ shr  4] + HexChars[pbyteArray^ and 15];
   dec(pbyteArray);
   Result := Result + HexChars[pbyteArray^ shr  4] + HexChars[pbyteArray^ and 15];
   inc(pbyteArray,3);
   Result := Result + HexChars[pbyteArray^ shr  4] + HexChars[pbyteArray^ and 15];
   dec(pbyteArray);
   Result := Result + HexChars[pbyteArray^ shr  4] + HexChars[pbyteArray^ and 15];
end;



procedure TVersionInfo.SeTVersionInfo;
var sVersionType : string;
    iAppSize, iLenOfValue, i: DWORD;
    pcValue: PChar;
    lang : string;
    pcBuf:PChar;
    FileName: string;    
begin
  FileName := FModuleName;
  UniqueString(FileName);

  iAppSize:=GetFileVersionInfoSize(PChar(FileName),iAppSize);
  if iAppSize > 0 then
  begin
   GetMem(pcBuf,iAppSize);
   try
     GetFileVersionInfo(PChar(FModuleName),0,iAppSize,pcBuf);
     pcValue:=nil;
     if VerQueryValue(pcBuf,PChar('VarFileInfo\Translation'), Pointer(pcValue),iLenOfValue) then
       lang:= _LangToHexStr(PByte(pcValue))
     else
      lang:='040904E4'; // Us English
     // Version Info
     for i := 0 to Ord(High(TVersionType)) do
     begin
      sVersionType := GetEnumName(TypeInfo(TVersionType),i);
      sVersionType := Copy(sVersionType,3,length(sVersionType));
      if  VerQueryValue(pcBuf,PChar('StringFileInfo\'+lang+'\'+sVersionType),
                        Pointer(pcValue),iLenOfValue) then
      begin
       FVersionInfo[i] :=pcValue;
      end;
     end;
    finally
     FreeMem(pcBuf)
    end;
  end;
end;

destructor TVersionInfo.Destroy;
begin
  Finalize(FVersionInfo);
  inherited;
end;

initialization

finalization
   
end.

