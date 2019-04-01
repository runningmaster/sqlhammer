{$I ibSHBranch.inc}
unit ibSHBranchInfo;

interface

uses
  SysUtils,
  SHDesignIntf, SHDevelopIntf,
  ibSHDesignIntf, ibSHComponent;

type
  TfibBTBranchInfo = class(TibBTComponent, ISHBranchInfo, IibSHBranchInfo, ISHDemon, ISHDataRootDirectory)
  protected
    function GetBranchIID: TGUID; override;
    function GetBranchName: string;

    function GetCaption: string; override;
    function GetCaptionExt: string; override;

    { ISHDataRootDirectory }
    function GetDataRootDirectory: string;
    function CreateDirectory(const FileName: string): Boolean;
    function RenameDirectory(const OldName, NewName: string): Boolean;
    function DeleteDirectory(const FileName: string): Boolean;
  public
    class function GetHintClassFnc: string; override;
    class function GetAssociationClassFnc: string; override;
    class function GetClassIIDClassFnc: TGUID; override;
  end;

  TibBTBranchInfo = class(TfibBTBranchInfo, IibSHBranch)
  end;

  TfbBTBranchInfo = class(TfibBTBranchInfo, IfbSHBranch)
  end;

procedure Register;

implementation

uses
  ibSHConsts,
  ibSHCommonEditors,
  ibSHDDLParser,
  ibSHOptions;

procedure Register;
begin
  SHRegisterComponents([
  {$IFNDEF ONLY_INTERBASE} TfbBTBranchInfo,TfbBTOptions, {$ENDIF}
  {$IFNDEF ONLY_FIREBIRD}TibBTBranchInfo, TibBTOptions,{$ENDIF}
                         TibBTDDLParser]);
{$IFNDEF ONLY_FIREBIRD}
  SHRegisterImage(GUIDToString(IibSHBranch), 'InterBase.bmp');
  SHRegisterImage(GUIDToString(IibSHOptions), 'InterBase.bmp');
{$ENDIF}
{$IFNDEF ONLY_INTERBASE}
  SHRegisterImage(GUIDToString(IfbSHBranch), 'Firebird.bmp');
  SHRegisterImage(GUIDToString(IfbSHOptions), 'Firebird.bmp');
{$ENDIF}
//  SHRegisterImage(GUIDToString(IibSHOptions), 'InterBase.bmp');
//  SHRegisterImage(GUIDToString(IfbSHOptions), 'Firebird.bmp');

  SHRegisterImage(SCallData,     'Form_Data_Grid.bmp');
  SHRegisterImage(SCallDataForm, 'Form_Data_VCL.bmp');
  SHRegisterImage(SCallDataBlob, 'Form_Data_Blob.bmp');
  SHRegisterImage(SCallSQLText,  'Form_DMLText.bmp');
  SHRegisterImage(SCallDDLText,  'Form_DDLText.bmp');
end;

{ TfibBTBranchInfo }

class function TfibBTBranchInfo.GetHintClassFnc: string;
begin
  Result := inherited GetHintClassFnc;
  if Supports(Self, IfbSHBranch) then Result := Format('%s', [SSHFirebirdBranch])
  else
  if Supports(Self, IibSHBranch) then Result := Format('%s', [SSHInterbaseBranch]);
end;

class function TfibBTBranchInfo.GetAssociationClassFnc: string;
begin
  Result := GetHintClassFnc;
end;

class function TfibBTBranchInfo.GetClassIIDClassFnc: TGUID;
begin
  if Supports(Self, IfbSHBranch) then Result := IfbSHBranch;
  if Supports(Self, IibSHBranch) then Result := IibSHBranch;
end;

function TfibBTBranchInfo.GetBranchIID: TGUID;
begin
  Result := GetClassIIDClassFnc;
end;

function TfibBTBranchInfo.GetBranchName: string;
begin
  Result := GetHintClassFnc;
end;

function TfibBTBranchInfo.GetCaption: string;
begin
  Result := GetBranchName;
end;

function TfibBTBranchInfo.GetCaptionExt: string;
begin
  Result := Format('%s SQL Server', [Caption]);
end;

function TfibBTBranchInfo.GetDataRootDirectory: string;
begin
  if Supports(Self, IfbSHBranch) then
    Result := IncludeTrailingPathDelimiter(Format('%s..\Data\%s', [Designer.GetApplicationPath, Hint]));
  if Supports(Self, IibSHBranch) then
    Result := IncludeTrailingPathDelimiter(Format('%s..\Data\%s', [Designer.GetApplicationPath, Hint]));
end;

function TfibBTBranchInfo.CreateDirectory(const FileName: string): Boolean;
begin
  Result := False;
end;

function TfibBTBranchInfo.RenameDirectory(const OldName, NewName: string): Boolean;
begin
  Result := False;
end;

function TfibBTBranchInfo.DeleteDirectory(const FileName: string): Boolean;
begin
  Result := False;
end;

initialization

  Register;

end.
