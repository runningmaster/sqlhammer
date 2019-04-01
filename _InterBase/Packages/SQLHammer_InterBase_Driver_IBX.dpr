library SQLHammer_InterBase_Driver_IBX;

uses
  SysUtils,
  Classes,
  ibSHDriver_IBX in '..\Drivers\ibSHDriver_IBX.pas';

{$R *.res}

function GetSQLHammerLibraryDescription: PChar; stdcall;
const
  SLibraryDescription = 'SQLHammer IBX Implementation (SQLMonitor for IBX Applications)';
begin
  Result := PChar(SLibraryDescription);
end;

exports
  GetSQLHammerLibraryDescription;

begin
  IsMultiThread := True;
end.
