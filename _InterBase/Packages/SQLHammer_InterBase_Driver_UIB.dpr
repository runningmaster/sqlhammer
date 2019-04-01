library SQLHammer_InterBase_Driver_UIB;

uses
  SysUtils,
  Classes,
  ibSHDriver_UIB in '..\Drivers\ibSHDriver_UIB.pas';

{$R *.res}

function GetSQLHammerLibraryDescription: PChar; stdcall;
const
  SLibraryDescription = 'SQLHammer Unified InterBase Implementation (SQLParser)';
begin
  Result := PChar(SLibraryDescription);
end;

exports
  GetSQLHammerLibraryDescription;

begin
  IsMultiThread := True;
end.
