unit ideSHConsts;

interface

const

  IMG_DEFAULT             = 0;
  IMG_PACKAGE             = 89; // 62

  IMG_SERVER              = 87; // 69
  IMG_SERVER_CONNECTED    = 70;
  IMG_DATABASE            = 71;
  IMG_DATABASE_CONNECTED  = 72;

  IMG_FORM_SIMPLE         = 73;
  IMG_COMPONENT_EDITOR    = 74;

  IMG_DBSTATE_SOURCE      = 75;
  IMG_DBSTATE_ALTER       = 76;
  IMG_DBSTATE_RECREATE    = 77;
  IMG_DBSTATE_DROP        = 78;
  IMG_DBSTATE_CREATE      = 79;

  IMG_FORM_READY          = 80;
  IMG_FORM_LOADED         = 81;
  IMG_FORM_CURRENT        = 82;

  IMG_MEGA_EDITOR         = 84;

resourcestring
  {$I ..\..\.ver}
  SAppCommunityComment    = 'This software is licensed royalty free under the condition that users refer all functional issues to the development team';
  SAppEnterpriseComment   = '';

  SApplicationTitle    = 'BlazeTop';
  SProjectHomePage     = 'http://www.devrace.com';
  SProjectHomePage2    = 'http://www.blazetop.com';
  SProjectSupportAddr  = 'http://www.devrace.com/en/support/';
  SProjectForumEngPage = 'http://www.devrace.com/en/support/forum/list.php?FID=10';
  SProjectForumRusPage = 'http://www.devrace.com/ru/support/forum/list.php?FID=9';
  SProjectFeedbackAddr = 'http://www.devrace.com/en/support/ticket_list.php';

  SInterBaseHomePage   = 'http://www.borland.com/interbase/';
  SFirebirdHomePage    = 'http://www.firebirdsql.org';

  SFeedbackCaption  = 'BlazeTop Feedback';
  SFeedbackText     = 'Feedback Text Here';

  SCaptionButtonOK        = 'OK';
  SCaptionButtonCancel    = 'Cancel';
  SCaptionButtonHelp      = 'Help';
  SCaptionButtonSave      = 'Save';
  SCaptionButtonClose     = 'Close';
  SCaptionButtonRestore   = 'Restore';
  SCaptionButtonTerminate = 'Terminate';

  SWarning      = 'Warning';
  SError        = 'Error';
  SInformation  = 'Information';
  SConfirmation = 'Confirmation';
  SQuestion     = 'Question';

  SMemoryAvailable = 'Memory Available to Windows: %s KB';

  SDirRoot             = '..\';
  SDirBin              = '..\Bin\';
  SDirData             = '..\Data\';
  SDirImages           = '..\Data\Resources\Images\';
  SFileErrorLog        = '..\Data\Environment\ErrorLog.txt';
  SFileConfig          = '..\Data\Environment\Config.txt';
  SFileConfigBackup    = '..\Data\Environment\Config.old.txt';
  SFileAliases         = '..\Data\Environment\Aliases.txt';
  SFileAliasesBackup   = '..\Data\Environment\Aliases.old.txt';
  SFileEnvironment     = '..\Data\Environment\Options.txt';
  SFileForms           = '..\Data\Environment\Forms.txt';
  SPathKey             = '$(BLAZETOP)';

  SSectionLibraries  = 'LIBRARIES';
  SSectionPackages   = 'PACKAGES';
  SSectionOptions    = 'OPTIONS';
  SSectionSystem     = 'SYSTEM';
  SSectionForms      = 'FORMS';
  SSectionRegistries = 'REGISTRIES';

  SCaptionDialogOptions            = 'Environment Options';
  SCaptionDialogConfigurator       = 'Environment Configurator';
  SCaptionDialogInstallLibrary     = 'Install Libraries';
  SCaptionDialogInstallPackages    = 'Install Packages';
  SCaptionDialogDetailPackages     = 'Detail Packages Information';
  SCaptionDialogObjectList         = 'View Objects';
  SCaptionDialogComponentList      = 'Components';
  SCaptionDialogWindowList         = 'Window List';
  SCaptionDialogLostConnection     = 'Lost Connection';
  SCaptionDialogRestoreConnection  = 'Restore Connection';

  SNothingSelected = '(nothing selected)';
  SNone = '< none >';
  SUnknown = '< unknown >';
  SSubentryFrom = 'Please select a subentry from the list';
  SSystem = 'System';

  SRegistryLineBreak = #14#11;

implementation

end.

