(*
  IDE  - SQLHammer Main Form
  SHCL - SQLHammer Component Library (SHDesignIntf.pas)
  +--------------------------------------------------------------------------+
  |  SQLHammer                            +------+                           |
  |                                       | SHCL |                           |
  |  +-----+   ISHDesigner            +------+ 2 |                           |
  |  | IDE |------------------------->| SHCL |-----+                         |
  |  |     |   ISHComponent           |    1 |SHCL | <= SQL Server Branches  |
  |  |     |<------------------------>|      |   3 |    -------------------  |
  |  +-----+ [ISHServer, ISHDatabase] +------+     |     <-> IxxSHIntefaces  |
  |                                         +------+                         |
  +--------------------------------------------------------------------------+
*)

unit SHDesignIntf;

interface

uses
  Windows, Classes, SysUtils, Controls, Forms, Dialogs, Menus, StdCtrls, Graphics,
  ComCtrls, ActnList, TypInfo,  Contnrs, DesignIntf, Types;


resourcestring
  SSHUnknownBranch     = 'Unknown';
  SSHCommonBranch      = 'Common';
  SSHInterBaseBranch   = 'InterBase';
  SSHFirebirdBranch    = 'Firebird';
  SSHMySQLBranch       = 'MySQL';
  SSHSybaseASEBranch   = 'Sybase ASE';
  SSHSybaseASABranch   = 'Sybase ASA';
  SSHOracleBranch      = 'Oracle';
  SSHMSSQLBranch       = 'MSSQL';
  SSHDB2Branch         = 'DB2';
  SSHInformixBranch    = 'Informix';
  SSHPostgreSQLBranch  = 'PostgreSQL';
  SSHIngresBranch      = 'Ingres';

type
  ISHDummy = interface
  ['{6C0BD55F-0D94-4104-9A68-0D34CF29855E}']
  end;

  // Common Branch
  ISHBranch = interface 
  ['{09825F11-1C1E-45DA-B9B9-BE4DBFF3DAFC}']
  end;

  // InterBase
  IibSHBranch = interface
  ['{F36C1C7F-21E9-425A-8FEA-16A9D311FFE7}']
  end;

  // Firebird
  IfbSHBranch = interface
  ['{3549FA43-20A1-436A-BA34-5118C91D1C86}']
  end;
  
  // MySQL
  ImySHBranch = interface
  ['{283BE397-898A-408C-9C65-FA59FBF664E0}']
  end;
  // Sybase ASE
  IseSHBranch = interface
  ['{6AF7A920-B25B-4783-8279-75ACA812ED94}']
  end;
  // Sybase ASA
  IsaSHBranch = interface
  ['{AAFE510B-4FCB-4432-91F8-6C8AE8563071}']
  end;
  // Oracle
  IorSHBranch = interface
  ['{0A81F9E4-F8F2-4F22-8327-407169B1E134}']
  end;
  // MSSQL
  ImsSHBranch = interface
  ['{687BFAD4-27E2-478D-B790-E67B72E4901C}']
  end;
  // DB2
  Idb2SHBranch = interface
  ['{36C5A0DC-2955-436A-9075-2CAA9E88EE40}']
  end;
  // Informix
  IifxSHBranch = interface
  ['{861D1E87-797A-4C41-92AF-2A7262AB2B69}']
  end;
  // PostgreSQL
  IpgSHBranch = interface
  ['{F92628B7-4A8E-49C7-B4A7-EF061C23DFD6}']
  end;
  // Ingres
  IingSHBranch = interface
  ['{AF33FAC1-B1D8-42A2-849B-5DF929DAC2AE}']
  end;

  TSHInterfacedPersistent = class(TPersistent)
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

  TSHOnTextNotify = procedure(Sender: TObject; const Text: String) of object;

{ TSHEvent
  Eng:
  Rus: Структура для передачи сообщений о событиях в системе }
  PSHEvent = ^TSHEvent;
  TSHEvent = packed record
    Event: Cardinal;
    case Integer of
      0: (
        WParam: Longint;
        LParam: Longint);
      1: (
        WParamLo: Word;
        WParamHi: Word;
        LParamLo: Word;
        LParamHi: Word);
  end;

{ TSHDBComponentState
  Eng:
  Rus: Состояние компонента, реализующего функциональность DB объектов
       csSource - объект вычитан из базы данных
       csCreate - объект будет создаваться
       csAlter - объект изменяется
       csRecreate - объект пересоздается
       csDrop - объект будет удален,
       csRelatedSource - объект вычитан + сопутствующие объекты
        }
  TSHDBComponentState = (csUnknown, csSource, csCreate, csAlter, csDrop, csRecreate,
   csRelatedSource
  );

{ ISHDesigner
  Eng:
  Rus: Основной интерфейс на SQLHammer IDE }
  ISHDesigner = interface;

  TSHAction = class;
  TSHActionClass = class of TSHAction;
  TSHComponent = class;
  TSHComponentClass = class of TSHComponent;
  TSHComponentForm = class;
  TSHComponentFormClass = class of TSHComponentForm;
  TSHComponentFactory = class;
  TSHComponentFactoryClass = class of TSHComponentFactory;
  TSHPropertyEditor = class;
  TSHPropertyEditorClass = class of TSHPropertyEditor;

{ ISHDemon
  Eng:
  Rus: Наличие этого интерфейса в классе вашего наследника от TSHComponent,
       скажет системе при регистрации такого класса, что надо незамедлительно
       создать экземпляр для этого класса и поместить в соответствующий список.
       Например, этот интерфейс применяется в TSHComponentFactory и TSHComponentOptions
       (и их наследниках соответственно), т.к. данные компоненты являются по сути
       "резидентными" компонентами - необходимо постоянное наличие готового
       экземпляра, чтобы к нему можно было обратиться в любое время, а также такие
       компоненты могут хранить в себе данные (например, списки экземпляров каких-либо
       пользовательских классов). Разрушение таких экземпляров система производит
       автоматически, при закрытии IDE. }
  ISHDemon = interface
  ['{045104B8-94D2-4408-B02F-7098D0F95C0A}']
  end;

{ ISHFileCommands
  Eng:
  Rus: Этот интерфейс реализуется по необходимости в наследниках TSHComponentForm,
       содержащих, например, текстовый редактор (или сетку). Интерфейс автоматически
       маппируется системой в соответсвующие итемы IDE.MainMenu.File. }
  ISHFileCommands = interface
  ['{BBE61773-16F6-4AB7-8BEF-C735AAF9EE73}']
    function GetCanNew: Boolean;
    function GetCanOpen: Boolean;
    function GetCanSave: Boolean;
    function GetCanSaveAs: Boolean;
    function GetCanPrint: Boolean;

    procedure New;
    procedure Open;
    procedure Save;
    procedure SaveAs;
    procedure Print;

    property CanNew: Boolean read GetCanNew;
    property CanOpen: Boolean read GetCanOpen;
    property CanSave: Boolean read GetCanSave;
    property CanSaveAs: Boolean read GetCanSaveAs;
    property CanPrint: Boolean read GetCanPrint;
  end;

{ ISHEditCommands
  Eng:
  Rus: Этот интерфейс реализуется по необходимости в наследниках TSHComponentForm,
       содержащих, например, текстовый редактор (или сетку). Интерфейс автоматически
       маппируется системой в соответсвующие итемы IDE.MainMenu.Edit. }
  ISHEditCommands = interface
  ['{505DEB0C-908F-471E-9458-420117FAC1C1}']
    function GetCanUndo: Boolean;
    function GetCanRedo: Boolean;
    function GetCanCut: Boolean;
    function GetCanCopy: Boolean;
    function GetCanPaste: Boolean;
    function GetCanSelectAll: Boolean;
    function GetCanClearAll: Boolean;

    procedure Undo;
    procedure Redo;
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure SelectAll;
    procedure ClearAll;

    property CanUndo: Boolean read GetCanUndo;
    property CanRedo: Boolean read GetCanRedo;
    property CanCut: Boolean read GetCanCut;
    property CanCopy: Boolean read GetCanCopy;
    property CanPaste: Boolean read GetCanPaste;
    property CanSelectAll: Boolean read GetCanSelectAll;
    property CanClearAll: Boolean read GetCanClearAll;
  end;

{ ISHSearchCommands
  Eng:
  Rus: Этот интерфейс реализуется по необходимости в наследниках TSHComponentForm,
       содержащих, например, текстовый редактор (или сетку). Интерфейс автоматически
       маппируется системой в соответсвующие итемы IDE.MainMenu.Search. }
  ISHSearchCommands = interface
  ['{D1EC4507-892E-4FD9-BD49-1AF3D7656F54}']
    function GetCanFind: Boolean;
    function GetCanReplace: Boolean;
    function GetCanSearchAgain: Boolean;
    function GetCanSearchIncremental: Boolean;
    function GetCanGoToLineNumber: Boolean;

    procedure Find;
    procedure Replace;
    procedure SearchAgain;
    procedure SearchIncremental;
    procedure GoToLineNumber;

    property CanFind: Boolean read GetCanFind;
    property CanReplace: Boolean read GetCanReplace;
    property CanSearchAgain: Boolean read GetCanSearchAgain;
    property CanSearchIncremental: Boolean read GetCanSearchIncremental;
    property CanGoToLineNumber: Boolean read GetCanGoToLineNumber;
  end;

  ISHRunCommands = interface
  ['{10A1671C-D156-4D21-BB1F-B7F10B22EB42}']
    function GetCanRun: Boolean;
    function GetCanPause: Boolean;
    function GetCanCreate: Boolean;
    function GetCanAlter: Boolean;
    function GetCanClone: Boolean;
    function GetCanDrop: Boolean;
    function GetCanRecreate: Boolean;
    function GetCanDebug: Boolean;
    function GetCanCommit: Boolean;
    function GetCanRollback: Boolean;
    function GetCanRefresh: Boolean;

    procedure Run;
    procedure Pause;
    procedure Create;
    procedure Alter;
    procedure Clone;
    procedure Drop;
    procedure Recreate;
    procedure Debug;
    procedure Commit;
    procedure Rollback;
    procedure Refresh;

    procedure ShowHideRegion(AVisible: Boolean);

    property CanRun: Boolean read GetCanRun;
    property CanPause: Boolean read GetCanPause;
    property CanCreate: Boolean read GetCanCreate;
    property CanAlter: Boolean read GetCanAlter;
    property CanClone: Boolean read GetCanClone;
    property CanDrop: Boolean read GetCanDrop;
    property CanRecreate: Boolean read GetCanRecreate;
    property CanDebug: Boolean read GetCanDebug;
    property CanCommit: Boolean read GetCanCommit;
    property CanRollback: Boolean read GetCanRollback;
    property CanRefresh: Boolean read GetCanRefresh;
  end;

  IBTRegionForms = interface
  ['{524B6ACC-3EF3-460E-B606-B9FED5F6C8F8}']
    function  CanWorkWithRegion: Boolean;  
    procedure ShowHideRegion(AVisible: Boolean);
    function  GetRegionVisible: Boolean;
    property  RegionVisible: Boolean read GetRegionVisible;        
  end;

  ISHDDLGenerator = interface
  ['{DD8940C3-DFF0-4D45-82AA-5425D79A218A}']
    function GetDDLText(const Intf: IInterface): string;
  end;

  ISHDDLParser = interface
  ['{3580F053-8051-41BF-BD2C-FA7A3A7E4EFE}']
    function GetCount: Integer;
    function GetStatements(Index: Integer): string;
    function GetErrorText: string;
    function GetErrorLine: Integer;
    function GetErrorColumn: Integer;

    function Parse(const DDLText: string): Boolean;
    function StatementState(const Index: Integer): TSHDBComponentState;
    function StatementObjectType(const Index: Integer): TGUID;
    function StatementObjectName(const Index: Integer): string;
    function StatementsCoord(Index: Integer): TRect;
    function IsDataSQL(Index: Integer): Boolean;

    property Count: Integer read GetCount;
    property Statements[Index: Integer]: string read GetStatements;
    property ErrorText: string read GetErrorText;
    property ErrorLine: Integer read GetErrorLine;
    property ErrorColumn: Integer read GetErrorColumn;
  end;

  ISHDDLWizard = interface
  ['{43C9ED59-F2E6-478F-9F63-FC9507B0B5D3}']
  end;
  
  ISHDDLCompiler = interface
  ['{603FB93B-8336-4671-9614-2ECA606407A8}']
    function GetDDLParser: ISHDDLParser;
    function GetErrorText: string;
    function GetErrorLine: Integer;
    function GetErrorColumn: Integer;

    function Compile(const Intf: IInterface; DDLText: string): Boolean;
    procedure AfterCommit(Sender: TObject; SenderClosing: Boolean = False);
    procedure AfterRollback(Sender: TObject; SenderClosing: Boolean = False);

    property DDLParser: ISHDDLParser read GetDDLParser;
    property ErrorText: string read GetErrorText;
    property ErrorLine: Integer read GetErrorLine;
    property ErrorColumn: Integer read GetErrorColumn;
  end;

  ISHEventReceiver = interface  // deprecated !!!
  ['{91B3A8BB-CDA8-4192-9D68-7BF140820408}']
    function ReceiveEvent(AEvent: TSHEvent): Boolean;
  end;

  ISHDataRootDirectory = interface
  ['{A1B050A1-663E-48F8-A25B-8C96349DF7E7}']
    function GetDataRootDirectory: string;

    function CreateDirectory(const FileName: string): Boolean;
    function RenameDirectory(const OldName, NewName: string): Boolean;
    function DeleteDirectory(const FileName: string): Boolean;

    property DataRootDirectory: string read GetDataRootDirectory;
  end;

{ ISHComponent
  Eng:
  Rus: САМЫЙ ГЛАВНЫЙ ИНТЕРФЕЙС СРЕДИ ВСЕХ ИНТЕРФЕЙСОВ СИСТЕМЫ.
       Реализован в TSHComponent - базовом компоненте для разработчиков
       компонентов-расширений к SQLHammer IDE. Отдает системе минимально
       необходимый минимум информации о зарегистрированном классе и
       его экземпляре (когда создан). }
  ISHComponent = interface
  ['{EBB47B00-428F-4A44-8359-1562EC4351F3}']
    function GetCaption: string;
    procedure SetCaption(Value: string);
    function GetCaptionExt: string;
    function GetCaptionPath: string;
    function GetHint: string;
    function GetAssociation: string;
    function GetBranchIID: TGUID;
    function GetClassIID: TGUID;
    function GetInstanceIID: TGUID;
    function GetOwnerIID: TGUID;
    procedure SetOwnerIID(Value: TGUID);
    function GetDesigner: ISHDesigner;

    procedure MakePropertyInvisible(const PropertyName: string);
    procedure MakePropertyVisible(const PropertyName: string);
    function CanShowProperty(const PropertyName: string): Boolean;
    function GetComponentFormIntf(const IID: TGUID; out Intf): Boolean;
    
    property Caption: string read GetCaption write SetCaption;
    property CaptionExt: string read GetCaptionExt;
    property CaptionPath: string read GetCaptionPath;
    property Hint: string read GetHint;
    property Association: string read GetAssociation;
    property BranchIID: TGUID read GetBranchIID;
    property ClassIID: TGUID read GetClassIID;
    property InstanceIID: TGUID read GetInstanceIID;
    property OwnerIID: TGUID read GetOwnerIID write SetOwnerIID;
    property Designer: ISHDesigner read GetDesigner;
  end;

  TSHActionCallType = (actCallRegister, actCallPalette,
    actCallForm, actCallEditor, actCallToolbar, actCallMenu);

  { ==========================================================================

    actCallRegister  SupportComponent(BranchGUID)     Connections.Registered
    actCallPalette   SupportComponent(BranchGUID)     Components.Registered
    actCallForm      SupportComponent(ComponentGUID)  Component.DropdownMenu
    actCallEditor    SupportComponent(ComponentGUID)  Component.DropdownMenu
    actCallToolbar   SupportComponent(ComponentGUID)  Component.Toolbar
    actCallMenu      Reserved                         IDE.MainMenu

    ========================================================================= }

  ISHAction = interface
  ['{59D86C93-4167-4D78-A70F-0EC7F361F538}']
    function GetCallType: TSHActionCallType;
    function GetDefault: Boolean;
    function GetDropdownMenu: TPopupMenu;
    function GetDesigner: ISHDesigner;

    procedure EnableShortCut;
    procedure DisableShortCut;

    function SupportComponent(const AClassIID: TGUID): Boolean;

    procedure EventExecute(Sender: TObject);
    procedure EventHint(var HintStr: String; var CanShow: Boolean);
    procedure EventUpdate(Sender: TObject);

    property CallType: TSHActionCallType read GetCallType;
    property Default: Boolean read GetDefault;
    property DropdownMenu: TPopupMenu read GetDropdownMenu;
    property Designer: ISHDesigner read GetDesigner;
  end;

  ISHTestConnection = interface
  ['{C0AF1DF8-5F1A-411A-8574-6DE3041E7F1C}']
    function GetCanTestConnection: Boolean;
    function TestConnection: Boolean;

    property CanTestConnection: Boolean read GetCanTestConnection;
  end;

  ISHDRVNativeDAC = interface
  ['{CA6BDB05-EC29-4F2C-B86B-94DEA06F4F2C}']
    function GetNativeDAC: TObject;
  end;

  TDynMethodResults=array of Variant;

  IBTDynamicMethod = interface
  //Buzz
   ['{DB64CDF7-38FF-437A-8065-82C5B6820720}']
   function DynMethodExist(const MethodName:string):boolean;
   function DynMethodExec(const MethodName:string; const Args: array of Variant):Variant;
   function DynMethodExecOut(const MethodName:string; const Args: array of Variant;
    var Results : TDynMethodResults
   ):Variant;
  end;

  ISHRegistration = interface(ISHComponent)
  ['{8135FB39-8061-4877-AA34-C9F52213377E}']
    function GetAlias: string;
    procedure SetAlias(Value: string);
    function GetConnectPath: string;
    function GetConnected: Boolean;
    function GetCanConnect: Boolean;
    function GetCanReconnect: Boolean;
    function GetCanDisconnect: Boolean;
    function GetCanShowRegistrationInfo: Boolean;

    function Connect: Boolean;
    function Reconnect: Boolean;
    function Disconnect: Boolean;
    procedure Refresh;

    function ShowRegistrationInfo: Boolean;

    procedure IDELoadFromFileNotify;
    // 'GUIDToString(IibSHTable)'
    function GetSchemeClassIIDList(WithSystem: Boolean = False): TStrings; overload;
    function GetSchemeClassIIDList(const AObjectName: string): TStrings; overload;
    function GetObjectNameList: TStrings; overload;
    function GetObjectNameList(const AClassIID: TGUID): TStrings; overload;

    property Alias: string read GetAlias write SetAlias;
    property ConnectPath: string read GetConnectPath;
    property Connected: Boolean read GetConnected;
    property CanConnect: Boolean read GetCanConnect;
    property CanReconnect: Boolean read GetCanReconnect;
    property CanDisconnect: Boolean read GetCanDisconnect;
    property CanShowRegistrationInfo: Boolean read GetCanShowRegistrationInfo;
  end;

  ISHNavigatorNotify = interface
  ['{E9E6F2EB-BAF9-489E-A532-F66A159FB6C7}']
    function GetFavoriteObjectNames: TStrings;
    function GetFavoriteObjectColor: TColor;
    function GetFilterList: TStrings;
    function GetFilterIndex: Integer;
    procedure SetFilterIndex(Value: Integer);

    property FavoriteObjectNames: TStrings read GetFavoriteObjectNames;
    property FavoriteObjectColor: TColor read GetFavoriteObjectColor;
    property FilterList: TStrings read GetFilterList;
    property FilterIndex: Integer read GetFilterIndex write SetFilterIndex;
  end;

{ ISHServer
  Eng:
  Rus: }
  ISHServer = interface(ISHRegistration)
  ['{E7D76BF8-0E72-42D0-94D5-048D1BA40B7B}']
  end;

{ ISHDatabase
  Eng:
  Rus: }
  ISHDatabase = interface(ISHRegistration)
  ['{763938CC-45DD-4722-847F-D3F58629D87C}']
  end;

{ ISHDBComponent
  Eng:
  Rus: }
  ISHDBComponent = interface(ISHComponent)
  ['{D5DAF1AC-4014-42D7-A4C4-756D48774C2D}']
    function GetSystem: Boolean;
    procedure SetSystem(Value: Boolean);
    function GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    function GetState: TSHDBComponentState;
    procedure SetState(Value: TSHDBComponentState);
    function GetEmbedded: Boolean;
    procedure SetEmbedded(Value: Boolean);

    function GetObjectName: string;
    procedure SetObjectName(Value: string);
    function GetDescription: TStrings;
    function GetSourceDDL: TStrings;
    function GetCreateDDL: TStrings;
    function GetAlterDDL: TStrings;
    function GetDropDDL: TStrings;
    function GetRecreateDDL: TStrings;

    procedure Refresh;

    property System: Boolean read GetSystem write SetSystem;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property State: TSHDBComponentState read GetState write SetState;
    property Embedded: Boolean read GetEmbedded write SetEmbedded;

    property ObjectName: string read GetObjectName write SetObjectName;
    property Description: TStrings read GetDescription;
    property SourceDDL: TStrings read GetSourceDDL;
    property CreateDDL: TStrings read GetCreateDDL;
    property AlterDDL: TStrings read GetAlterDDL;
    property DropDDL: TStrings read GetDropDDL;
    property RecreateDDL: TStrings read GetRecreateDDL;
  end;

{ ISHComponentOptions
  Eng:
  Rus: Интерфейс к компонентам-носителям опций. Реализован в TSHComponentOptions.
       На основе возвращаемых значений ParentCategory и Category в IDE строится
       дерево Environmentoptions. Свойство Visible управляет видимостью итема
       опций в упомянутом деревере. }
  ISHComponentOptions = interface
  ['{0221E3B4-9F3C-4849-A1E7-FA3BDEEA23E0}']
    function GetParentCategory: string;
    function GetCategory: string;
    function GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    function GetUseDefaultEditor: Boolean;

    procedure RestoreDefaults;

    property ParentCategory: string read GetParentCategory;
    property Category: string read GetCategory;
    property Visible: Boolean read GetVisible write SetVisible;
    property UseDefaultEditor: Boolean read GetUseDefaultEditor;
  end;

{ ISHComponentFactory
  Eng:
  Rus: Интерфейс к компонентам, отвечающим за жизнь и смерть экземпляров
       наследников TSHComponent, а также за их поведение в системе в целом.
       Реализован в TISHComponentFactory. }
  ISHComponentFactory = interface
  ['{4B0D2BAF-9BEF-4ABC-8435-781B0C71205C}']
    function SupportComponent(const AClassIID: TGUID): Boolean;
    function CreateComponent(const AOwnerIID, AClassIID: TGUID;
      const ACaption: string): TSHComponent;
    function DestroyComponent(ACcomponent: TSHComponent): Boolean;
  end;

  TButtonsMode = (bmOK, bmOKCancel, bmOKCancelHelp);
  TBeforeModalClose = procedure(Sender: TObject; var ModalResult: TModalResult; var Action: TCloseAction) of object;
  TAfterModalClose = procedure(Sender: TObject; ModalResult: TModalResult) of object;

  ISHModalForm = interface
  ['{685C649B-BEFE-4328-9108-6E37A880B4EF}']
    function GetButtonsMode: TButtonsMode;
    procedure SetButtonsMode(Value: TButtonsMode);
    function GetEnabledOK: Boolean;
    procedure SetEnabledOK(Value: Boolean);
    function GetCaptionOK: string;
    procedure SetCaptionOK(Value: string);
    function GetCaptionCancel: string;
    procedure SetCaptionCancel(Value: string);
    function GetCaptionHelp: string;
    procedure SetCaptionHelp(Value: string);
    function GetShowIndent: Boolean;
    procedure SetShowIndent(Value: Boolean);
    function GetModalResultCode: TModalResult;
    procedure SetModalResultCode(Value: TModalResult);
    function GetOnBeforeModalClose: TBeforeModalClose;
    procedure SetOnBeforeModalClose(Value: TBeforeModalClose);
    function GetOnAfterModalClose: TAfterModalClose;
    procedure SetOnAfterModalClose(Value: TAfterModalClose);

    property ButtonsMode: TButtonsMode read GetButtonsMode write SetButtonsMode;
    property EnabledOK: Boolean read GetEnabledOK write SetEnabledOK;
    property CaptionOK: string read GetCaptionOK write SetCaptionOK;
    property CaptionCancel: string read GetCaptionCancel write SetCaptionCancel;
    property CaptionHelp: string read GetCaptionHelp write SetCaptionHelp;
    property ShowIndent: Boolean read GetShowIndent write SetShowIndent;
    property ModalResultCode: TModalResult read GetModalResultCode write SetModalResultCode;
    property OnBeforeModalClose: TBeforeModalClose read GetOnBeforeModalClose write SetOnBeforeModalClose;
    property OnAfterModalClose: TAfterModalClose read GetOnAfterModalClose write SetOnAfterModalClose;
  end;

  ISHComponentForm = interface
  ['{AF63C18A-BEED-4F19-A2B6-88E0714BA100}']
    function GetCanDestroy: Boolean;
    function GetModalForm: ISHModalForm;

    procedure BringToTop; // вызывается из IDE, когда форма стала активной.

    property CanDestroy: Boolean read GetCanDestroy;
    property ModalForm: ISHModalForm read GetModalForm;
  end;


  ISHComponentFormHide = interface
  ['{CC226FC2-8088-4BA5-A861-ACFC97FD5171}']
  end;

  ISHComponentFormCollection = interface
  ['{164C8EEF-FE2E-4644-8D67-81C717625DB3}']
    function GetComponentForms: TComponentList;

    procedure AddComponentForm(AForm: TComponent);
    procedure RemoveComponentForm(AForm: TComponent);
    function GetComponentFormIntf(const IID: TGUID; out Intf): Boolean;

    property ComponentForms: TComponentList read GetComponentForms;
  end;

  ISHProperty = interface
  ['{EF40123E-3ADA-4194-92C7-96CB82294826}']
    function GetFloatValue(AIndex: Integer): Extended;
    function GetInt64Value(AIndex: Integer): Int64;
    function GetOrdValue(AIndex: Integer): Longint;
    function GetStrValue(AIndex: Integer): string;
    function GetVarValue(AIndex: Integer): Variant;
    procedure SetFloatValue(Value: Extended);
    procedure SetInt64Value(Value: Int64);
    procedure SetOrdValue(Value: Longint);
    procedure SetStrValue(const Value: string);
    procedure SetVarValue(const Value: Variant);

    function GetAttributes: TPropertyAttributes;
    function GetValue: string;
    procedure GetValues(AValues: TStrings);
    procedure SetValue(const Value: string);
    procedure Edit;
  end;

  ISHPropertyEditorInfo = interface
  ['{B19A844A-3E47-4650-8BE7-D7FD8DCA0DBA}']
    function GetInstance: TObject;
    function GetPropName: string;
    function GetPropInfo: PPropInfo;
    function GetPropTypeInfo: PTypeInfo;
  end;

{ ISHDesigner
  Eng:
  Rus: Основной интерфейс на SQLHammer IDE. Реализован там же. Каждый класс,
       отнаследованный от основных базовых классов будет иметь проперть Designer
       данного типа, что позволит в любой ситуации при необходимости вызывать
       функционал, реализованный на стороне IDE. Интерфейс изначально имеет
       склонность к расширению. Следите за изменениями. }


  TDragType =(dtObject,dtText);

  TDragObjectInfo= record
     ObjectName:string;
     ObjectClass:TGUID;
     DragType   :TDragType;
  end;

  ISHDesigner = interface
  ['{B87F2F50-4745-46BF-A9B4-C0E1A244F815}']
    function GetMainMenu: TMainMenu;
    function GetImageList: TImageList;
    function GetActionList: TActionList;
    function GetLoading: Boolean;

    function GetComponents: TComponentList;
    function GetComponentForms: TComponentList;

    function GetCurrentBranch: TSHComponent;
    function GetCurrentServer: TSHComponent;
    function GetCurrentDatabase: TSHComponent;
    function GetCurrentComponent: TSHComponent;
    function GetCurrentComponentForm: TSHComponentForm;
    function GetCurrentServerInUse: Boolean;
    function GetCurrentDatabaseInUse: Boolean;
    function GetServerCount: Integer;
    function GetDatabaseCount: Integer;

    function _GetProxiEditorClass(APropertyInspector: TObject;
      AInstance: TPersistent; APropInfo: PPropInfo): TObject;

    procedure UnderConstruction;
    procedure NotSupported;

    procedure AntiLargeFont(AComponent: TComponent);
    function GetApplicationPath: string;
    function GetFilePath(const FileName: string): string;
    function EncodeApplicationPath(const FileName: string): string;
    function DecodeApplicationPath(const FileName: string): string;
    procedure TextToStrings(AText: string; AList: TStrings;
      DoClear: Boolean = False; DoInsert: Boolean = False);
    function CheckPropValue(Value, Values: string): Boolean;
    function ShowMsg(const AMsg: string; DialogType: TMsgDlgType): Boolean; overload;
    function ShowMsg(const AMsg: string): Integer; overload;
    procedure AbortWithMsg(const AMsg: string = '');
    function InputQuery(const ACaption, APrompt: string;
      var Value: string; CancelBtn: Boolean = True; PswChar: Char = #0): Boolean;
    function InputBox(const ACaption, APrompt, ADefault: string;
      CancelBtn: Boolean = True; PswChar: Char = #0): string;
    procedure SaveRegisteredConnectionInfo;
    procedure ShowEnvironmentOptions; overload;
    procedure ShowEnvironmentOptions(const AClassIID: TGUID); overload;
    procedure UpdateObjectInspector;
    procedure UpdateActions;
    function ShowModal(AComponent: TSHComponent;
      const CallString: string): TModalResult;
    function ExecuteExternalProcess(const CommandLine,
      WorkingDirectory: string): Integer;
    function RegExprMatch(const AExpression, ASource: string;
      CaseSensitive: Boolean): Boolean;

    function GetComponent(const AClassIID: TGUID): TSHComponentClass;
    function GetImageIndex(const AStringIID: string): Integer; overload;
    function GetImageIndex(const AClassIID: TGUID): Integer; overload;
    function GetCallStrings(const AClassIID: TGUID): TStrings;
    function GetComponentForm(const AClassIID: TGUID;
      const CallString: string): TSHComponentFormClass;
    function GetPropertyEditor(const AClassIID: TGUID;
      const PropertyName: string): TSHPropertyEditorClass;
    function GetFactory(const AClassIID: TGUID): ISHComponentFactory;
    function GetOptions(const AClassIID: TGUID): ISHComponentOptions;
    function GetDemon(const AClassIID: TGUID): TSHComponent;

    procedure FreeNotification(AComponent: TComponent);
    function CreateComponent(const AOwnerIID, AClassIID: TGUID;
      const ACaption: string): TSHComponent;
    function DestroyComponent(AComponent: TSHComponent): Boolean;
    function FindComponent(const AInstanceIID: TGUID): TSHComponent; overload;
    function FindComponent(const AOwnerIID, AClassIID: TGUID): TSHComponent; overload;
    function FindComponent(const AOwnerIID, AClassIID: TGUID;
      const ACaption: string): TSHComponent; overload;

    procedure SendEvent(AEvent: TSHEvent); // deprecated
    procedure PostEvent(AEvent: TSHEvent); // deprecated

    procedure GetPropValues(Source: TPersistent; AParentName: string;
      AStrings: TStrings; PropNameList: TStrings = nil; Include: Boolean = True);
    procedure SetPropValues(Dest: TPersistent; AParentName: string;
      AStrings: TStrings; PropNameList: TStrings = nil; Include: Boolean = True);
    procedure WritePropValuesToFile(const FileName, Section: string;
      Source: TPersistent; PropNameList: TStrings = nil; Include: Boolean = True);
    procedure ReadPropValuesFromFile(const FileName, Section: string;
      Dest: TPersistent; PropNameList: TStrings = nil; Include: Boolean = True);

//Buzz
    procedure SaveStringsToIni(const FileName, Section: string;Source:TStrings;EraseOldSection:boolean=True);
    procedure ReadStringsFromIni(const FileName, Section: string;Source:TStrings);
//
    function ExistsComponent(AComponent: TSHComponent): Boolean; overload;
    function ExistsComponent(AComponent: TSHComponent;
      const CallString: string): Boolean; overload;
    function ChangeNotification(AComponent: TSHComponent;
      Operation: TOperation): Boolean; overload;
    function ChangeNotification(AComponent: TSHComponent;
      const CallString: string; Operation: TOperation): Boolean; overload;

    function JumpTo(const AInstanceIID, AClassIID: TGUID; ACaption: string): Boolean;

    function RegisterConnection(AConnection: TSHComponent): Boolean;
    function UnregisterConnection(AConnection: TSHComponent): Boolean;
    function DestroyConnection(AConnection: TSHComponent): Boolean;

    function ConnectTo(AConnection: TSHComponent): Boolean;
    function ReconnectTo(AConnection: TSHComponent): Boolean;
    function DisconnectFrom(AConnection: TSHComponent): Boolean;
    procedure RefreshConnection(AConnection: TSHComponent);
    procedure RestoreConnection(AConnection: TSHComponent);
    function SynchronizeConnection(AConnection: TSHComponent; const AClassIID: TGUID;
      const ACaption: string; Operation: TOperation): Boolean;

    function GetLastDragObject:TDragObjectInfo;

    // properties

    property MainMenu: TMainMenu read GetMainMenu;
    property ImageList: TImageList read GetImageList;
    property ActionList: TActionList read GetActionList;
    property Loading: Boolean read GetLoading;

    property Components: TComponentList read GetComponents;
    property ComponentForms: TComponentList read GetComponentForms;

    property CurrentBranch: TSHComponent read GetCurrentBranch;
    property CurrentServer: TSHComponent read GetCurrentServer;
    property CurrentDatabase: TSHComponent read GetCurrentDatabase;
    property CurrentComponent: TSHComponent read GetCurrentComponent;
    property CurrentComponentForm: TSHComponentForm read GetCurrentComponentForm;
    property CurrentServerInUse: Boolean read GetCurrentServerInUse;
    property CurrentDatabaseInUse: Boolean read GetCurrentDatabaseInUse;
    property ServerCount: Integer read GetServerCount;
    property DatabaseCount: Integer read GetDatabaseCount;
  end;


  TSHNotifyEvent = procedure(Sender: TObject) of object;

  ISHEventNotifier = interface
  ['{D32D1B5C-4927-4D0F-964A-E3610E86E633}']
    // TODO
  end;

  ISHDataSaver = interface
  ['{9AA3D5D5-669C-43D6-A0D1-A041D0FA2A02}']
    function SupportsExtentions: TStrings;
    function ExtentionDescriptions: TStrings;
    procedure SaveToFile(AComponent, ADataset, AGrid: TComponent; AFileName: string);
  end;

  ISHClipboardFormat = interface
  ['{15F11515-4B9C-48E0-AC57-2303F4723FC6}']
    procedure CutToClipboard(AComponent, ADataset, AGrid: TComponent);
    procedure CopyToClipboard(AComponent, ADataset, AGrid: TComponent);
    function PasteFromClipboard(AComponent, ADataset, AGrid: TComponent): Boolean;
  end;

{ Classes
}
  TSHAction = class(TAction, ISHAction)
  private
    FDesigner: ISHDesigner;
    FSavedShortCut: TShortCut;
    FSavedSecondaryShortCuts: TShortCutList;
    function GetCallType: TSHActionCallType;
    function GetDefault: Boolean;
    function GetDropdownMenu: TPopupMenu;
    function GetDesigner: ISHDesigner;

    procedure DoOnExecute(Sender: TObject);
    procedure DoOnHint(var HintStr: String; var CanShow: Boolean);
    procedure DoOnUpdate(Sender: TObject);

    procedure EnableShortCut;
    procedure DisableShortCut;
  protected
    FCallType: TSHActionCallType;
    FDefault: Boolean;
    FDropdownMenu: TPopupMenu;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function SupportComponent(const AClassIID: TGUID): Boolean; virtual;

    procedure EventExecute(Sender: TObject); virtual;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); virtual;
    procedure EventUpdate(Sender: TObject); virtual;

    property CallType: TSHActionCallType read GetCallType;
    property Default: Boolean read GetDefault;
    property DropdownMenu: TPopupMenu read GetDropdownMenu;
    property Designer: ISHDesigner read GetDesigner;
  end;

  TSHComponent = class(TComponent, ISHComponent, ISHEventReceiver,
    ISHComponentFormCollection)
  private
    FInstanceIID: TGUID;
    FOwnerIID: TGUID;
    FCaption: string;
    FDesigner: ISHDesigner;
    FInvisibleProps: TStrings;
    FComponentForms: TComponentList;
  protected
    function GetHint: string;
    function GetAssociation: string;
    function GetBranchIID: TGUID; virtual;
    function GetClassIID: TGUID;
    function GetInstanceIID: TGUID;
    function GetDesigner: ISHDesigner;
    function GetOwnerIID: TGUID;
    procedure SetOwnerIID(Value: TGUID); virtual;
    function GetComponentForms: TComponentList;

    function GetCaption: string; virtual;
    procedure SetCaption(Value: string); virtual;
    function GetCaptionExt: string; virtual;
    function GetCaptionPath: string; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function GetHintClassFnc: string; virtual;
    class function GetAssociationClassFnc: string; virtual;
    class function GetClassIIDClassFnc: TGUID; virtual;

    procedure MakePropertyInvisible(const PropertyName: string);
    procedure MakePropertyVisible(const PropertyName: string);

    function CanShowProperty(const PropertyName: string): Boolean; virtual;
    function ReceiveEvent(AEvent: TSHEvent): Boolean; virtual;

    procedure AddComponentForm(AForm: TComponent);
    procedure RemoveComponentForm(AForm: TComponent);
    function GetComponentFormIntf(const IID: TGUID; out Intf): Boolean;

    property Caption: string read GetCaption write SetCaption;
    property CaptionExt: string read GetCaptionExt;
    property CaptionPath: string read GetCaptionPath;
    property Hint: string read GetHint;
    property Association: string read GetAssociation;
    property BranchIID: TGUID read GetBranchIID;
    property ClassIID: TGUID read GetClassIID;
    property InstanceIID: TGUID read GetInstanceIID;
    property OwnerIID: TGUID read GetOwnerIID write SetOwnerIID;
    property Designer: ISHDesigner read GetDesigner;
    property ComponentForms: TComponentList read GetComponentForms;
  end;

  TSHComponentOptions = class(TSHComponent, ISHComponentOptions, ISHDemon)
  private
    FParentCategory: string;
    FCategory: string;
    FVisible: Boolean;
  protected
    function GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    function GetUseDefaultEditor: Boolean; virtual;
    function GetParentCategory: string; virtual;
    function GetCategory: string; virtual;
    procedure RestoreDefaults; virtual;
  public
    constructor Create(AOwner: TComponent); override;

    property ParentCategory: string read GetParentCategory;
    property Category: string read GetCategory;
    property Visible: Boolean read GetVisible write SetVisible;
  end;

  TSHComponentFactory = class(TSHComponent, ISHComponentFactory, ISHDemon)
  public
    function SupportComponent(const AClassIID: TGUID): Boolean; virtual;
    function CreateComponent(const AOwnerIID, AClassIID: TGUID;
      const ACaption: string): TSHComponent; virtual;
    function DestroyComponent(AComponent: TSHComponent): Boolean; virtual;
  end;

  TSHComponentForm = class(TForm, ISHComponentForm, ISHEventReceiver)
  private
    FEmbeddedParent: TWinControl;
    FEmbedded: Boolean;
    FCallString: string;
    FComponent: TSHComponent;
    FDesigner: ISHDesigner;
    FModalForm: ISHModalForm;
    FStatusBar: TStatusBar;
  protected
    function GetComponent: TSHComponent;
    function GetDesigner: ISHDesigner;
    function GetCanDestroy: Boolean; virtual;
    function GetModalForm: ISHModalForm;
    procedure SetStatusBar(Value: TStatusBar); virtual;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); reintroduce; overload; virtual;
    destructor Destroy; override;

    procedure BringToTop; virtual;
    function ReceiveEvent(AEvent: TSHEvent): Boolean; virtual;
  public
    property Embedded: Boolean read FEmbedded;
    property CallString: string read FCallString;
    property Component: TSHComponent read GetComponent;
    property Designer: ISHDesigner read GetDesigner;
    property CanDestroy: Boolean read GetCanDestroy;
    property ModalForm: ISHModalForm read GetModalForm;
    property StatusBar: TStatusBar read FStatusBar write SetStatusBar;
  end;

  TSHPropertyEditor = class
  private
    FPropertyEditor: ISHProperty;
    FPropertyEditorInfo: ISHPropertyEditorInfo;
    FComponent: TSHComponent;
    FDesigner: ISHDesigner;
    FReadOnly: Boolean;
    function GetInstance: TObject;              
    function GetPropName: string;
    function GetPropInfo: PPropInfo;
    function GetPropTypeInfo: PTypeInfo;
    function GetComponent: TSHComponent;
    function GetDesigner: ISHDesigner;
  public
    constructor Create(APropertyEditor: TObject); virtual;

    function GetFloatValue(AIndex: Integer): Extended;
    function GetInt64Value(AIndex: Integer): Int64;
    function GetOrdValue(AIndex: Integer): Longint;
    function GetStrValue(AIndex: Integer): string;
    function GetVarValue(AIndex: Integer): Variant;
    procedure SetFloatValue(Value: Extended);
    procedure SetInt64Value(Value: Int64);
    procedure SetOrdValue(Value: Longint);
    procedure SetStrValue(const Value: string);
    procedure SetVarValue(const Value: Variant);

    function GetAttributes: TPropertyAttributes; virtual;
    function GetValue: string; virtual;
    procedure GetValues(AValues: TStrings); virtual;
    procedure SetValue(const Value: string); virtual;
    function GetReadOnly: Boolean;
    procedure SetReadOnly(Value: Boolean);
    procedure Edit; virtual;
  public
    property Instance: TObject read GetInstance;
    property PropName: string read GetPropName;
    property PropInfo: PPropInfo read GetPropInfo;
    property PropTypeInfo: PTypeInfo read GetPropTypeInfo;
    property Value: string read GetValue write SetValue;
    property Component: TSHComponent read GetComponent;
    property Designer: ISHDesigner read GetDesigner;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  end;
{ ...
}

// -> SQLHammer supports interface function -------------------------------------
type
  TSHRegisterInterfaceProc = procedure(const Intf: IInterface;
    const Description: string);
  TSHSupportsFunc = function(const IID: TGUID; out Intf;
    const Description: string): Boolean;

var
  SHRegisterInterfaceProc: TSHRegisterInterfaceProc = nil;
  SHSupportsFunc: TSHSupportsFunc = nil;

procedure SHRegisterInterface(const Intf: IInterface); overload;
procedure SHRegisterInterface(const Intf: IInterface;
  const Description: string); overload;
function SHSupports(const IID: TGUID; out Intf): Boolean; overload;
function SHSupports(const IID: TGUID; out Intf;
  const Description: string): Boolean; overload;
(*
  var
    vDesigner: ISHDesigner;

      ...

    if SHSupports(ISHDesigner, vDesigner) then
    begin
      ...
    end;
*)

// -> SQLHammer Register Procedures ---------------------------------------------
type
  TSHRegisterActionsProc = procedure(ActionClasses: array of TSHActionClass);
  TSHRegisterComponentsProc = procedure(ComponentClasses: array of TSHComponentClass);
  TSHRegisterPropertyEditorProc = procedure(const ClassIID: TGUID;
    const PropertyName: string; PropertyEditor: TSHPropertyEditorClass);
  TSHRegisterComponentFormProc = procedure(const ClassIID: TGUID;
    const CallString: string; ComponentForm: TSHComponentFormClass);
  TSHRegisterImageProc = procedure(const StringIID, FileName: string);

procedure SHRegisterActions(ActionClasses: array of TSHActionClass);
procedure SHRegisterComponents(ComponentClasses: array of TSHComponentClass);
procedure SHRegisterPropertyEditor(const ClassIID: TGUID;
  const PropertyName: string; PropertyEditor: TSHPropertyEditorClass);
procedure SHRegisterComponentForm(const ClassIID: TGUID;
  const CallString: string; ComponentForm: TSHComponentFormClass);
procedure SHRegisterImage(const StringIID, FileName: string);

var
  SHRegisterActionsProc: TSHRegisterActionsProc;
  SHRegisterComponentsProc: TSHRegisterComponentsProc;
  SHRegisterPropertyEditorProc: TSHRegisterPropertyEditorProc;
  SHRegisterComponentFormProc: TSHRegisterComponentFormProc;
  SHRegisterImageProc: TSHRegisterImageProc;



var
  LastDragObject:TDragObjectInfo;
  
implementation


{ TSHInterfacedPersistent }

function TSHInterfacedPersistent.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then Result := S_OK else Result := E_NOINTERFACE;
end;

function TSHInterfacedPersistent._AddRef: Integer;
begin
  Result := -1;
end;

function TSHInterfacedPersistent._Release: Integer;
begin
  Result := -1;
end;

{ TSHAction }

constructor TSHAction.Create(AOwner: TComponent);
begin
  SHSupports(ISHDesigner, FDesigner);
  inherited Create(AOwner);
  FSavedSecondaryShortCuts := TShortCutList.Create;
  FCallType := actCallPalette;
  ImageIndex := 0;

  Self.OnExecute := DoOnExecute;
  Self.OnHint := DoOnHint;
  Self.OnUpdate := DoOnUpdate;

  // ! SHRegisterImage(ActionClassName) for action *must be* before SHRegisterAction()
  if Assigned(FDesigner) then
    ImageIndex := FDesigner.GetImageIndex(ClassName);
end;

destructor TSHAction.Destroy;
begin
  FSavedSecondaryShortCuts.Free;
  inherited Destroy;
end;

function TSHAction.GetCallType: TSHActionCallType;
begin
  Result := FCallType;
end;

function TSHAction.GetDefault: Boolean;
begin
  Result := FDefault;
end;

function TSHAction.GetDropdownMenu: TPopupMenu;
begin
  Result := FDropdownMenu;
end;

function TSHAction.GetDesigner: ISHDesigner;
begin
  Result := FDesigner;
end;

procedure TSHAction.DoOnExecute(Sender: TObject);
begin
//  try
  EventExecute(Sender);
//  except
//  Designer.ShowMsg(Self.ClassName);
//  end;
end;

procedure TSHAction.DoOnHint(var HintStr: String; var CanShow: Boolean);
begin
  EventHint(HintStr, CanShow);
end;

procedure TSHAction.DoOnUpdate(Sender: TObject);
begin
  EventUpdate(Sender);
end;

procedure TSHAction.EnableShortCut;
begin
  ShortCut := FSavedShortCut;

  if not Visible then
    ShortCut := TextToShortCut(EmptyStr);

  if FSavedSecondaryShortCuts.Count > 0 then
    SecondaryShortCuts.Assign(FSavedSecondaryShortCuts);

  if not Visible then
    SecondaryShortCuts.Clear;
end;

procedure TSHAction.DisableShortCut;
begin
  if ShortCut <> 0 then
  begin
    if FSavedShortCut = 0 then FSavedShortCut := ShortCut;
    ShortCut := TextToShortCut(EmptyStr);
    Enabled := False;
  end;

  if SecondaryShortCuts.Count > 0 then
  begin
    FSavedSecondaryShortCuts.Assign(SecondaryShortCuts);
    SecondaryShortCuts.Clear;
    Enabled := False;
  end;
end;

procedure TSHAction.EventExecute(Sender: TObject);
begin
end;

procedure TSHAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TSHAction.EventUpdate(Sender: TObject);
begin
end;

function TSHAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := False;
  // Intended for descendents to implement
end;

{ TSHComponent }

constructor TSHComponent.Create(AOwner: TComponent);
begin
  CreateGUID(FInstanceIID);
  FOwnerIID := IUnknown;
  SHSupports(ISHDesigner, FDesigner);
  inherited Create(AOwner);
  FInvisibleProps := TStringList.Create;
  if Assigned(FDesigner) then FDesigner.FreeNotification(Self);
  MakePropertyInvisible('Name');
  MakePropertyInvisible('Tag');
  FComponentForms := TComponentList.Create(False);
end;

destructor TSHComponent.Destroy;
begin
  FInvisibleProps.Free;
  FComponentForms.Free;
  inherited Destroy;
end;

function TSHComponent.GetInstanceIID: TGUID;
begin
  Result := FInstanceIID;
end;

function TSHComponent.GetDesigner: ISHDesigner;
begin
  Result := FDesigner;
end;

function TSHComponent.GetOwnerIID: TGUID;
begin
  Result := FOwnerIID;
end;

procedure TSHComponent.SetOwnerIID(Value: TGUID);
begin
  FOwnerIID := Value;
end;

function TSHComponent.GetComponentForms: TComponentList;
begin
  Result := FComponentForms;
end;

class function TSHComponent.GetHintClassFnc: string;
begin
  Result := Format('Create New %s', [ClassName]);
end;

class function TSHComponent.GetAssociationClassFnc: string;
begin
  Result := EmptyStr;
end;

class function TSHComponent.GetClassIIDClassFnc: TGUID;
var
  IntfTable: PInterfaceTable;
begin
  Result := IUnknown;
  IntfTable := Self.GetInterfaceTable;
  if Assigned(IntfTable) then
    Result := IntfTable.Entries[Pred(IntfTable.EntryCount)].IID;
end;

function TSHComponent.GetCaption: string;
begin
  Result := FCaption;
end;

procedure TSHComponent.SetCaption(Value: string);
begin
  FCaption := Value;
end;

function TSHComponent.GetCaptionExt: string;
begin
  Result := Format('%s : %s', [Caption, 'Database Alias']);
end;

function TSHComponent.GetCaptionPath: string;
begin
  Result := Format('BranchName\ServerAlias\DatabaseAlias\%s', [Caption]);
end;

procedure TSHComponent.MakePropertyInvisible(const PropertyName: string);
begin
  if CanShowProperty(PropertyName) then
    FInvisibleProps.Add(PropertyName);
end;

procedure TSHComponent.MakePropertyVisible(const PropertyName: string);
begin
  if not CanShowProperty(PropertyName) then
     FInvisibleProps.Delete(FInvisibleProps.IndexOf(PropertyName));
end;

function TSHComponent.CanShowProperty(const PropertyName: string): Boolean;
begin
  Result := FInvisibleProps.IndexOf(PropertyName) = -1;
end;

function TSHComponent.ReceiveEvent(AEvent: TSHEvent): Boolean;
begin
  Result := True;
end;

procedure TSHComponent.AddComponentForm(AForm: TComponent);
begin
  FComponentForms.Add(AForm);
end;

procedure TSHComponent.RemoveComponentForm(AForm: TComponent);
begin
  FComponentForms.Remove(AForm);
end;

function TSHComponent.GetComponentFormIntf(const IID: TGUID; out Intf): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Pred(FComponentForms.Count) do
  begin
    Result := Supports(FComponentForms[I], IID, Intf);
    if Result then Break;
  end;
end;

function TSHComponent.GetHint: string;
begin
  Result := GetHintClassFnc;
end;

function TSHComponent.GetAssociation: string;
begin
  Result := GetAssociationClassFnc;
end;

function TSHComponent.GetBranchIID: TGUID;
begin
  Result := IUnknown; // <- *must* change
end;

function TSHComponent.GetClassIID: TGUID;
begin
  Result := GetClassIIDClassFnc;
end;

{ TSHComponentOptions }

constructor TSHComponentOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Intended for descendents to implement
  FParentCategory := EmptyStr;
  FCategory := Format('%s', ['Category Name']);
  FVisible := True;
  RestoreDefaults;
end;

function TSHComponentOptions.GetVisible: Boolean;
begin
  Result := FVisible;
end;

procedure TSHComponentOptions.SetVisible(Value: Boolean);
begin
  FVisible := Value;
end;

function TSHComponentOptions.GetUseDefaultEditor: Boolean;
begin
  Result := True;
end;

function TSHComponentOptions.GetParentCategory: string;
begin
  Result := FParentCategory;
end;

function TSHComponentOptions.GetCategory: string;
begin
  Result := FCategory;
end;

procedure TSHComponentOptions.RestoreDefaults;
begin
  // Intended for descendents to implement
end;

{ TSHComponentFactory }

function TSHComponentFactory.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := False;
  // Intended for descendents to implement
end;

function TSHComponentFactory.CreateComponent(const AOwnerIID, AClassIID: TGUID;
  const ACaption: string): TSHComponent;
begin
  Result := nil;
  // Intended for descendents to implement
end;

function TSHComponentFactory.DestroyComponent(AComponent: TSHComponent): Boolean;
begin
  Result := False;
  // Intended for descendents to implement
end;

{ TSHComponentForm }

constructor TSHComponentForm.Create(AOwner: TComponent);
begin
  FEmbedded := False;
  SHSupports(ISHDesigner, FDesigner);
  inherited Create(AOwner);
  if Assigned(FDesigner) then FDesigner.FreeNotification(Self);
end;

constructor TSHComponentForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  FEmbeddedParent := AParent;
  FEmbedded := Assigned(FEmbeddedParent);
  FComponent := AComponent;
  FCallString := ACallString;
  SHSupports(ISHDesigner, FDesigner);
  inherited Create(AOwner);
  if Assigned(FDesigner) then FDesigner.FreeNotification(Self);
  if Assigned(Component) then Component.AddComponentForm(Self);
  if Assigned(Parent) and Assigned(Parent.Parent) then
    Supports(Parent.Parent, ISHModalForm, FModalForm);
end;

destructor TSHComponentForm.Destroy;
begin
  try
  if Assigned(Component)  and not (csDestroying in Component.ComponentState)
   then Component.RemoveComponentForm(Self);
  inherited Destroy;
  except
    Designer.ShowMsg(CallString);
  end;
end;

procedure TSHComponentForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if FEmbedded then Params.Style := Params.Style or WS_CHILD;
end;

procedure TSHComponentForm.Loaded;
begin
  inherited Loaded;
  if FEmbedded then
  begin
    Align := alClient;
    BorderStyle := bsNone;
    BorderIcons := [];
    Parent := FEmbeddedParent;
    Position := poDefault;
  end;
end;

function TSHComponentForm.GetComponent: TSHComponent;
begin
  Result := FComponent;
end;

function TSHComponentForm.GetDesigner: ISHDesigner;
begin
  Result := FDesigner;
end;

function TSHComponentForm.GetCanDestroy: Boolean;
begin
  Result := True;
end;

function TSHComponentForm.GetModalForm: ISHModalForm;
begin
  Result := FModalForm;
end;

procedure TSHComponentForm.SetStatusBar(Value: TStatusBar);
begin
  FStatusBar := Value;
end;

procedure TSHComponentForm.BringToTop;
begin
// Empty
end;

function TSHComponentForm.ReceiveEvent(AEvent: TSHEvent): Boolean;
begin
  Result := True;
end;

{ TSHPropertyEditor }

constructor TSHPropertyEditor.Create(APropertyEditor: TObject);
begin
  inherited Create;
  Supports(APropertyEditor, ISHProperty, FPropertyEditor);
  Supports(APropertyEditor, ISHPropertyEditorInfo, FPropertyEditorInfo);

  if Assigned(Instance) and (Instance is TSHComponent) then
    FComponent := TSHComponent(Instance);
  SHSupports(ISHDesigner, FDesigner);
end;

procedure TSHPropertyEditor.Edit;
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  FPropertyEditor.Edit;
end;

function TSHPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  Result := FPropertyEditor.GetAttributes;
  if ReadOnly then Result := Result + [paReadOnly];
end;

function TSHPropertyEditor.GetFloatValue(AIndex: Integer): Extended;
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  Result := FPropertyEditor.GetFloatValue(AIndex);
end;

function TSHPropertyEditor.GetInstance: TObject;
begin
  Assert(Assigned(FPropertyEditorInfo), 'FPropertyEditorInfo = nil');
  Result := FPropertyEditorInfo.GetInstance;
end;

function TSHPropertyEditor.GetInt64Value(AIndex: Integer): Int64;
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  Result := FPropertyEditor.GetInt64Value(AIndex);
end;

function TSHPropertyEditor.GetOrdValue(AIndex: Integer): Longint;
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  Result := FPropertyEditor.GetOrdValue(AIndex);
end;

function TSHPropertyEditor.GetPropName: string;
begin
  Assert(Assigned(FPropertyEditorInfo), 'FPropertyEditorInfo = nil');
  Result := FPropertyEditorInfo.GetPropName;
end;

function TSHPropertyEditor.GetPropInfo: PPropInfo;
begin
  Assert(Assigned(FPropertyEditorInfo), 'FPropertyEditorInfo = nil');
  Result := FPropertyEditorInfo.GetPropInfo;
end;

function TSHPropertyEditor.GetPropTypeInfo: PTypeInfo;
begin
  Assert(Assigned(FPropertyEditorInfo), 'FPropertyEditorInfo = nil');
  Result := FPropertyEditorInfo.GetPropTypeInfo;
end;

function TSHPropertyEditor.GetComponent: TSHComponent;
begin
  Result := FComponent;
end;

function TSHPropertyEditor.GetDesigner: ISHDesigner;
begin
  Result := FDesigner;
end;

function TSHPropertyEditor.GetStrValue(AIndex: Integer): string;
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  Result := FPropertyEditor.GetStrValue(AIndex);
end;

function TSHPropertyEditor.GetValue: string;
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  Result := FPropertyEditor.GetValue;
end;

procedure TSHPropertyEditor.GetValues(AValues: TStrings);
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  FPropertyEditor.GetValues(AValues);
end;

function TSHPropertyEditor.GetVarValue(AIndex: Integer): Variant;
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  Result := FPropertyEditor.GetVarValue(AIndex);
end;

procedure TSHPropertyEditor.SetFloatValue(Value: Extended);
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  FPropertyEditor.SetFloatValue(Value);
end;

procedure TSHPropertyEditor.SetInt64Value(Value: Int64);
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  FPropertyEditor.SetInt64Value(Value);
end;

procedure TSHPropertyEditor.SetOrdValue(Value: Integer);
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  FPropertyEditor.SetOrdValue(Value);
end;

procedure TSHPropertyEditor.SetStrValue(const Value: string);
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  FPropertyEditor.SetStrValue(Value);
end;

procedure TSHPropertyEditor.SetValue(const Value: string);
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  FPropertyEditor.SetValue(Value);
end;

procedure TSHPropertyEditor.SetVarValue(const Value: Variant);
begin
  Assert(Assigned(FPropertyEditor), 'FPropertyEditor = nil');
  FPropertyEditor.SetVarValue(Value);
end;

function TSHPropertyEditor.GetReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

procedure TSHPropertyEditor.SetReadOnly(Value: Boolean);
begin
  FReadOnly := Value;
end;

{ ... }

procedure SHRegisterInterface(const Intf: IInterface);
begin
  if Assigned(SHRegisterInterfaceProc) then
    SHRegisterInterfaceProc(Intf, EmptyStr);
end;

procedure SHRegisterInterface(const Intf: IInterface; const Description: string);
begin
  if Assigned(SHRegisterInterfaceProc) then
    SHRegisterInterfaceProc(Intf, Description);
end;

function SHSupports(const IID: TGUID; out Intf): Boolean;
begin
  Result := Assigned(SHSupportsFunc) and SHSupportsFunc(IID, Intf, EmptyStr);
end;

function SHSupports(const IID: TGUID; out Intf; const Description: string): Boolean;
begin
  Result := Assigned(SHSupportsFunc) and SHSupportsFunc(IID, Intf, Description);
end;

procedure SHRegisterActions(ActionClasses: array of TSHActionClass);
begin
  if Assigned(SHRegisterActionsProc) then
    SHRegisterActionsProc(ActionClasses);
end;

procedure SHRegisterComponents(ComponentClasses: array of TSHComponentClass);
begin
  if Assigned(SHRegisterComponentsProc) then
    SHRegisterComponentsProc(ComponentClasses);
end;

procedure SHRegisterPropertyEditor(const ClassIID: TGUID;
    const PropertyName: string; PropertyEditor: TSHPropertyEditorClass);
begin
  if Assigned(SHRegisterPropertyEditorProc) then
    SHRegisterPropertyEditorProc(ClassIID, PropertyName, PropertyEditor);
end;

procedure SHRegisterComponentForm(const ClassIID: TGUID;
  const CallString: string; ComponentForm: TSHComponentFormClass);
begin
  if Assigned(SHRegisterComponentFormProc) then
    SHRegisterComponentFormProc(ClassIID, CallString, ComponentForm);
end;

procedure SHRegisterImage(const StringIID, FileName: string);
begin
  if Assigned(SHRegisterImageProc) then
    SHRegisterImageProc(StringIID, FileName);
end;

end.







