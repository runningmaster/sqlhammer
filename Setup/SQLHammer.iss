; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

;********************************************************************
; 0. ���������� <CVS_DIR>\Utils\*.bat (��� ���, ������� �������)
; 1. ���������� ����� ���������� ������ #define SQLHAMMER_OLD_VERSION
; 2. ���������� ����� ������� ������ #define SQLHAMMER_NEW_VERSION
; 3. ��������/�������� #define SQLHAMMER_ENTERPRISE_EDITION
; 4. ���������� ������ � OutputBaseFilename

#define OUT_DIR "..\\..\\SQLHAMMER.INST\"
#define CVS_DIR "C:\\SQLHAMMER.CVS\"
#define BIN_DIR "C:\\SQLHAMMER.BIN\"
#define SYS_DIR "C:\\WINDOWS\\system32\"
#define BOR_DIR "C:\\Program Files\\Borland\\Delphi7\"

#define SQLHAMMER_PUBLISHER "Devrace"
#define SQLHAMMER_COMMENT "RDDA IDE with OTA for Borland InterBase� and Firebird"
#define SQLHAMMER_URL "http://sqlhammer.com"
#define SQLHAMMER_MAIL "http://www.devrace.com/en/support/"
#define SQLHAMMER_VERSION "1.7"

; ! Editions
#define SQLHAMMER_ENTERPRISE_EDITION
  #ifndef SQLHAMMER_ENTERPRISE_EDITION
    #define SQLHAMMER_COMMUNITY_EDITION
  #endif
  
; ! Only update
;#define SQLHAMMER_DEBUG "(DEBUG)"

[Setup]
AppMutex=SQLHAMMER_RUNNING

#ifdef SQLHAMMER_ENTERPRISE_EDITION
  AppId=Devrace SQLHammer 1 EE
  DefaultDirName={pf}\Devrace\SQLHammer EE
  DefaultGroupName=SQLHammer EE
  LicenseFile={#CVS_DIR}\Setup\License_EE.txt
  #ifdef SQLHAMMER_DEBUG
  OutputBaseFilename=SQLHammer EE Debug 1.7
  #else
  OutputBaseFilename=SQLHammer EE Setup 1.7
  #endif
#else
  AppId=Devrace SQLHammer 1 CE
  DefaultDirName={pf}\Devrace\SQLHammer CE
  DefaultGroupName=SQLHammer CE
  LicenseFile={#CVS_DIR}\Setup\License_CE.txt
  #ifdef SQLHAMMER_DEBUG
  OutputBaseFilename=SQLHammer CE Debug 1.7
  #else
  OutputBaseFilename=SQLHammer CE Setup 1.7
  #endif
#endif

AppName={code:GetAppName}
AppVerName={code:GetAppNewVerName}
AppVersion={#SQLHAMMER_VERSION}
AppPublisher={#SQLHAMMER_PUBLISHER}
;AppReadmeFile=
AppComments={#SQLHAMMER_COMMENT}
AppContact={#SQLHAMMER_MAIL}
AppPublisherURL={#SQLHAMMER_URL}
AppSupportURL={#SQLHAMMER_URL}
AppUpdatesURL={#SQLHAMMER_URL}

VersionInfoCompany={#SQLHAMMER_PUBLISHER}
VersionInfoDescription={#SQLHAMMER_COMMENT}
VersionInfoTextVersion={#SQLHAMMER_VERSION}
VersionInfoVersion={#SQLHAMMER_VERSION}

AllowNoIcons=yes
Compression=lzma/ultra
InternalCompressLevel=ultra
SolidCompression=yes

WizardImageFile={#CVS_DIR}\Setup\Images\164_314_256.bmp
WizardSmallImageFile={#CVS_DIR}\Setup\Images\55_55_256.bmp
SetupIconFile={#CVS_DIR}\Setup\Images\Setup.ico
UninstallDisplayIcon={app}\Bin\SQLHammer32.exe
OutputDir={#OUT_DIR}

[Messages]
BeveledLabel={#SQLHAMMER_PUBLISHER}

[Tasks]
Name: "desktopicon";     Description: "{cm:CreateDesktopIcon}";     GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "pt"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "ca"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "cs"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "da"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl"
Name: "hu"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "no"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "pl"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "pt"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "sl"; MessagesFile: "compiler:Languages\Slovenian.isl"

[Dirs]
Name: "{app}\Bin"
Name: "{app}\Data"
Name: "{app}\Data\Environment"
Name: "{app}\Data\Resources\Images\"

Name: "{app}\Data\Firebird"
Name: "{app}\Data\Firebird\Keywords"
Name: "{app}\Data\Firebird\Repository"
Name: "{app}\Data\Firebird\Repository\DDL"
Name: "{app}\Data\Firebird\Repository\DDL\Domains"
Name: "{app}\Data\Firebird\Repository\DDL\Tables"
Name: "{app}\Data\Firebird\Repository\DDL\Fields"
Name: "{app}\Data\Firebird\Repository\DDL\Indices"
Name: "{app}\Data\Firebird\Repository\DDL\Constraints"
Name: "{app}\Data\Firebird\Repository\DDL\Views"
Name: "{app}\Data\Firebird\Repository\DDL\Procedures"
Name: "{app}\Data\Firebird\Repository\DDL\Triggers"
Name: "{app}\Data\Firebird\Repository\DDL\Generators"
Name: "{app}\Data\Firebird\Repository\DDL\Exceptions"
Name: "{app}\Data\Firebird\Repository\DDL\Functions"
Name: "{app}\Data\Firebird\Repository\DDL\Filters"
Name: "{app}\Data\Firebird\Repository\DDL\Roles"

Name: "{app}\Data\InterBase"
Name: "{app}\Data\InterBase\Keywords"
Name: "{app}\Data\InterBase\Repository"
Name: "{app}\Data\InterBase\Repository\DDL"
Name: "{app}\Data\InterBase\Repository\DDL\Domains"
Name: "{app}\Data\InterBase\Repository\DDL\Tables"
Name: "{app}\Data\InterBase\Repository\DDL\Fields"
Name: "{app}\Data\InterBase\Repository\DDL\Indices"
Name: "{app}\Data\InterBase\Repository\DDL\Constraints"
Name: "{app}\Data\InterBase\Repository\DDL\Views"
Name: "{app}\Data\InterBase\Repository\DDL\Procedures"
Name: "{app}\Data\InterBase\Repository\DDL\Triggers"
Name: "{app}\Data\InterBase\Repository\DDL\Generators"
Name: "{app}\Data\InterBase\Repository\DDL\Exceptions"
Name: "{app}\Data\InterBase\Repository\DDL\Functions"
Name: "{app}\Data\InterBase\Repository\DDL\Filters"
Name: "{app}\Data\InterBase\Repository\DDL\Roles"
;Name: "{app}\Demos"
;Name: "{app}\Demos\FishFact"
;Name: "{app}\Doc"
;Name: "{app}\Doc\DevGuide"
;Name: "{app}\Doc\UseGuide"
;Name: "{app}\Doc\Welcome"
;Name: "{app}\Help"
Name: "{app}\Intf"
;Name: "{app}\Intl"
;Name: "{app}\Lib"
Name: "{app}\Packages"

[InstallDelete]
;Type: files; Name: "{app}\License.txt"
;Type: files; Name: "{app}\Bin\SQLHammer_Common_Guide.bpl"
;Type: files; Name: "{app}\Bin\SQLHammer_Common_Demo.bpl"
;Type: files; Name: "{app}\Bin\SQLHammer_InterBase_DDLGoogler.bpl"
;Type: files; Name: "{app}\Bin\SQLHammer_InterBase_DMLDumper.bpl"
;Type: files; Name: "{app}\Bin\SQLHammer_InterBase_SQLHistory.bpl"
;Type: files; Name: "{app}\Bin\SQLHammer_InterBase_SQLScripter.bpl"
;Type: files; Name: "{app}\Bin\SQLHammer_InterBase_Services.bpl"
;Type: files; Name: "{app}\Bin\SQLHammer_InterBase_DMLExtractor.bpl"
;Type: files; Name: "{app}\Bin\SQLHammer_InterBase_Assistants.bpl"

[Files]
; >> Setup files
Source: "{#CVS_DIR}\Setup\File_Id.diz";        DestDir: "{app}"; Flags: ignoreversion
;Source: "{#CVS_DIR}\Setup\ChangeLog.txt";      DestDir: "{app}"; Flags: ignoreversion
Source: "{#CVS_DIR}\Setup\Readme.txt";         DestDir: "{app}"; Flags: ignoreversion
;isreadme
#ifdef SQLHAMMER_ENTERPRISE_EDITION
; >> Config files
  Source: "{#CVS_DIR}\Setup\Config.txt"; DestDir: "{app}\Data\Environment"; Flags: ignoreversion
  Source: "{#CVS_DIR}\Setup\Order.txt";        DestDir: "{app}"; Flags: ignoreversion
  Source: "{#CVS_DIR}\Setup\License_EE.txt";   DestDir: "{app}"; Flags: ignoreversion
#else
  Source: "{#CVS_DIR}\Setup\License_CE.txt";   DestDir: "{app}"; Flags: ignoreversion
#endif


; >> Images files
Source: "{#BIN_DIR}\Data\Resources\Images\*.bmp"; DestDir: "{app}\Data\Resources\Images\"; Flags: ignoreversion

; >> Repository\DDL files (InterBase)
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHConstraintDefault.txt";  DestDir: "{app}\Data\Firebird\Repository\DDL\Constraints";  DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHDomainDefault.txt";      DestDir: "{app}\Data\Firebird\Repository\DDL\Domains";      DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHExceptionDefault.txt";   DestDir: "{app}\Data\Firebird\Repository\DDL\Exceptions";   DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHFieldDefault.txt";       DestDir: "{app}\Data\Firebird\Repository\DDL\Fields";       DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHFilterDefault.txt";      DestDir: "{app}\Data\Firebird\Repository\DDL\Filters";      DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHFunctionDefault.txt";    DestDir: "{app}\Data\Firebird\Repository\DDL\Functions";    DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHGeneratorDefault.txt";   DestDir: "{app}\Data\Firebird\Repository\DDL\Generators";   DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHIndexDefault.txt";       DestDir: "{app}\Data\Firebird\Repository\DDL\Indices";      DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHProcedureDefault.txt";   DestDir: "{app}\Data\Firebird\Repository\DDL\Procedures";   DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHRoleDefault.txt";        DestDir: "{app}\Data\Firebird\Repository\DDL\Roles";        DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHTableDefault.txt";       DestDir: "{app}\Data\Firebird\Repository\DDL\Tables";       DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHTriggerDefault.txt";     DestDir: "{app}\Data\Firebird\Repository\DDL\Triggers";     DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHViewDefault.txt";        DestDir: "{app}\Data\Firebird\Repository\DDL\Views";        DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHObjectNameRtns.txt";     DestDir: "{app}\Data\Firebird\Repository\DDL";              DestName: "ObjectNameRtns.txt"; Flags: ignoreversion

; >> Repository\DDL files (Firebird)
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHConstraintDefault.txt";  DestDir: "{app}\Data\InterBase\Repository\DDL\Constraints"; DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHDomainDefault.txt";      DestDir: "{app}\Data\InterBase\Repository\DDL\Domains";     DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHExceptionDefault.txt";   DestDir: "{app}\Data\InterBase\Repository\DDL\Exceptions";  DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHFieldDefault.txt";       DestDir: "{app}\Data\InterBase\Repository\DDL\Fields";      DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHFilterDefault.txt";      DestDir: "{app}\Data\InterBase\Repository\DDL\Filters";     DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHFunctionDefault.txt";    DestDir: "{app}\Data\InterBase\Repository\DDL\Functions";   DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHGeneratorDefault.txt";   DestDir: "{app}\Data\InterBase\Repository\DDL\Generators";  DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHIndexDefault.txt";       DestDir: "{app}\Data\InterBase\Repository\DDL\Indices";     DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHProcedureDefault.txt";   DestDir: "{app}\Data\InterBase\Repository\DDL\Procedures";  DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHRoleDefault.txt";        DestDir: "{app}\Data\InterBase\Repository\DDL\Roles";       DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHTableDefault.txt";       DestDir: "{app}\Data\InterBase\Repository\DDL\Tables";      DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHTriggerDefault.txt";     DestDir: "{app}\Data\InterBase\Repository\DDL\Triggers";    DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHViewDefault.txt";        DestDir: "{app}\Data\InterBase\Repository\DDL\Views";       DestName: "Default.txt";        Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Templates\ibSHObjectNameRtns.txt";     DestDir: "{app}\Data\InterBase\Repository\DDL";             DestName: "ObjectNameRtns.txt"; Flags: ignoreversion

; >> Bin files
Source: "{#BIN_DIR}\Bin\SQLHammer32.exe";                            DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_Common_Package.bpl";               DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_Common_Design.bpl";                DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_Common_Develop.bpl";               DestDir: "{app}\Bin"; Flags: ignoreversion
;Source: "{#BIN_DIR}\Bin\SQLHammer_Common_Guide.bpl";                 DestDir: "{app}\Bin"; Flags: ignoreversion
;Source: "{#BIN_DIR}\Bin\SQLHammer_Common_Demo.bpl";                  DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_Common_DataExport.bpl";            DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_Design.bpl";             DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_Common.bpl";             DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_Driver_FIBPlus.dll";     DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_Driver_FIBPlus_LM.dll";  DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_Driver_IBX.dll";         DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_Connections.bpl";        DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_DDLObjects.bpl";         DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_DDLWizards.bpl";         DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_SQLEditor.bpl";          DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_DMLHistory.bpl";         DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_DDLHistory.bpl";         DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_DDLFinder.bpl";          DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_SQLPlayer.bpl";          DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_SQLMonitor.bpl";         DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_DDLExtractor.bpl";       DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_DMLExporter.bpl";        DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_UserManager.bpl";        DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_ServicesAPI.bpl";        DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_ExpressHelp.bpl";        DestDir: "{app}\Bin"; Flags: ignoreversion

#ifdef SQLHAMMER_ENTERPRISE_EDITION
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_DDLGrantor.bpl";         DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_DDLCommentator.bpl";     DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BIN_DIR}\Bin\SQLHammer_InterBase_TXTLoader.bpl";          DestDir: "{app}\Bin"; Flags: ignoreversion
#endif

; >> VCL files
Source: "{#SYS_DIR}\rtl70.bpl";                         DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#SYS_DIR}\vcl70.bpl";                         DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#SYS_DIR}\vclx70.bpl";                        DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#SYS_DIR}\vcljpg70.bpl";                      DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#SYS_DIR}\vclactnband70.bpl";                 DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#SYS_DIR}\dbrtl70.bpl";                       DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#SYS_DIR}\vclie70.bpl";                       DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#SYS_DIR}\vcldb70.bpl";                       DestDir: "{app}\Bin"; Flags: ignoreversion
;Source: "{#SYS_DIR}\bdertl70.bpl";                      DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BOR_DIR}\Bin\designide70.bpl";               DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BOR_DIR}\Projects\Bpl\VirtualTreesD7.bpl";   DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BOR_DIR}\Projects\Bpl\SynEdit_R7.bpl";       DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BOR_DIR}\Projects\Bpl\ExtLib_D7.bpl";        DestDir: "{app}\Bin"; Flags: ignoreversion
Source: "{#BOR_DIR}\Projects\Bpl\EhLib70.bpl";          DestDir: "{app}\Bin"; Flags: ignoreversion

#ifdef SQLHAMMER_DEBUG
Source: "{#BOR_DIR}\Projects\Bpl\DJcl70.bpl";           DestDir: "{app}\Bin"; Flags: ignoreversion
#endif

; >> Keywords files (Firebird)
Source: "{#CVS_DIR}\Pack\Keywords\Firebird_Keywords_10.txt";             DestDir: "{app}\Data\Firebird\Keywords\"; Flags: ignoreversion
Source: "{#CVS_DIR}\Pack\Keywords\Firebird_Keywords_15.txt";             DestDir: "{app}\Data\Firebird\Keywords\"; Flags: ignoreversion

; >> Keywords files (InterBase)
Source: "{#CVS_DIR}\Pack\Keywords\InterBase_Auto_Replace.txt";           DestDir: "{app}\Data\InterBase\Keywords\"; Flags: ignoreversion
Source: "{#CVS_DIR}\Pack\Keywords\InterBase_Keyboards_Templates.txt";    DestDir: "{app}\Data\InterBase\Keywords\"; Flags: ignoreversion
Source: "{#CVS_DIR}\Pack\Keywords\InterBase_Keywords_50.txt";            DestDir: "{app}\Data\InterBase\Keywords\"; Flags: ignoreversion
Source: "{#CVS_DIR}\Pack\Keywords\InterBase_Keywords_60.txt";            DestDir: "{app}\Data\InterBase\Keywords\"; Flags: ignoreversion
Source: "{#CVS_DIR}\Pack\Keywords\InterBase_Keywords_70.txt";            DestDir: "{app}\Data\InterBase\Keywords\"; Flags: ignoreversion
Source: "{#CVS_DIR}\Pack\Keywords\InterBase_Keywords_75.txt";            DestDir: "{app}\Data\InterBase\Keywords\"; Flags: ignoreversion

; >> Demos files
;Source: "{#CVS_DIR}\Demos\FishFact\*"; DestDir: "{app}\Demos\FishFact"; Flags: ignoreversion

; >> Intf files (Common)
Source: "{#CVS_DIR}\Common\Intf\SHDesignIntf.pas";                DestDir: "{app}\Intf";     Flags: ignoreversion
Source: "{#CVS_DIR}\Common\Intf\SHEvents.pas";                    DestDir: "{app}\Intf";     Flags: ignoreversion
Source: "{#CVS_DIR}\Common\Intf\SHOptionsIntf.pas";               DestDir: "{app}\Intf";     Flags: ignoreversion
Source: "{#CVS_DIR}\Common\Packages\SQLHammer_Common_Design.cfg"; DestDir: "{app}\Packages"; Flags: ignoreversion
Source: "{#CVS_DIR}\Common\Packages\SQLHammer_Common_Design.dof"; DestDir: "{app}\Packages"; Flags: ignoreversion
Source: "{#CVS_DIR}\Common\Packages\SQLHammer_Common_Design.dpk"; DestDir: "{app}\Packages"; Flags: ignoreversion
Source: "{#CVS_DIR}\Common\Packages\SQLHammer_Common_Design.res"; DestDir: "{app}\Packages"; Flags: ignoreversion

; >> Intf files (InterBase/Firebird)
Source: "{#CVS_DIR}\_InterBase\Intf\ibSHDesignIntf.pas";                 DestDir: "{app}\Intf";     Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Intf\ibSHDriverIntf.pas";                 DestDir: "{app}\Intf";     Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Packages\SQLHammer_InterBase_Design.cfg"; DestDir: "{app}\Packages"; Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Packages\SQLHammer_InterBase_Design.dof"; DestDir: "{app}\Packages"; Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Packages\SQLHammer_InterBase_Design.dpk"; DestDir: "{app}\Packages"; Flags: ignoreversion
Source: "{#CVS_DIR}\_InterBase\Packages\SQLHammer_InterBase_Design.res"; DestDir: "{app}\Packages"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[INI]
Filename: "{app}\SQLHammer.url"; Section: "InternetShortcut"; Key: "URL"; String: {#SQLHAMMER_URL}

[Icons]
Name: "{group}\SQLHammer";                                                 Filename: "{app}\Bin\SQLHammer32.exe";
Name: "{group}\{cm:ProgramOnTheWeb,SQLHammer}";                            Filename: "{app}\SQLHammer.url"
Name: "{group}\{cm:UninstallProgram,SQLHammer}";                           Filename: "{uninstallexe}"
Name: "{userdesktop}\SQLHammer";                                           Filename: "{app}\Bin\SQLHammer32.exe"; Tasks: desktopicon; WorkingDir: "{app}\Bin\"
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\SQLHammer";  Filename: "{app}\Bin\SQLHammer32.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\Bin\SQLHammer32.exe"; Description: "{cm:LaunchProgram,SQLHammer}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: files; Name: "{app}\SQLHammer.url"

[Code]
function GetAppNewVerName(DummyParam: string): string;
begin
  #ifdef SQLHAMMER_ENTERPRISE_EDITION
  Result := Format('Devrace SQLHammer %s Enterprise Edition', ['{#SQLHAMMER_VERSION}']);
  #else
  Result := Format('Devrace SQLHammer %s Community Edition', ['{#SQLHAMMER_VERSION}']);
  #endif
end;

function GetAppName(DummyParam: string): string;
begin
  #ifndef SQLHAMMER_DEBUG
  Result := GetAppNewVerName('DummyParam');
  #else
  Result := Format('%s (DEBUG)', [GetAppNewVerName('DummyParam')]);
  #endif
end;
