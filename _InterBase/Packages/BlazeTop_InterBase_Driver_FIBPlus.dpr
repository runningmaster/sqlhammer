library BlazeTop_InterBase_Driver_FIBPlus;

uses
  SysUtils,
  Classes,
  ibSHDriver_FIBPlus in '..\Drivers\ibSHDriver_FIBPlus.pas',
  ibSHTableStatisticCalculator in '..\Drivers\ibSHTableStatisticCalculator.pas',
  ibSHTableStatisticClasses in '..\Drivers\ibSHTableStatisticClasses.pas',
  pFIBScript in '..\Drivers\pFIBScript.pas';

{$R *.res}

function GetSQLHammerLibraryDescription: PChar; stdcall;
const
  SLibraryDescription = 'BlazeTop FIBPlus Implementation';
begin
  Result := PChar(SLibraryDescription);
end;

exports
  GetSQLHammerLibraryDescription;

begin
  IsMultiThread := True;
end.

