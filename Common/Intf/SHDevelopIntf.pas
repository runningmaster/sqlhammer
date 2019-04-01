unit SHDevelopIntf;

interface

uses
  Classes, SysUtils;

type
  ISHBranchInfo = interface
  ['{A4E9B90B-25F8-4155-B45C-1FE1F0FEF587}']
    function GetBranchIID: TGUID;
    function GetBranchName: string;

    property BranchIID: TGUID read GetBranchIID;
    property BranchName: string read GetBranchName;
  end;

  IibSHBranchInfo = interface(ISHBranchInfo)
  ['{4D4F5FE1-7915-4B90-9DE7-FACB8BAC6803}']
  end;

  IseSHBranchInfo = interface(ISHBranchInfo)
  ['{0F972677-0D0F-492A-B3A2-638E2085D603}']
  end;

implementation

end.
