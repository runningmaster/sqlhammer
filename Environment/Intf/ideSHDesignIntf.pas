unit ideSHDesignIntf;

interface

uses
  SysUtils, Classes, Controls, Contnrs, StdCtrls, ComCtrls, Menus, ActnList,
  SHDesignIntf, SHDevelopIntf;

type
  IideBTMain = interface
  ['{55860B04-61BF-42FC-9D5A-F8321A8BA0F5}']
    { Functions for MainMenu properties
    }
    function GetCanNew: Boolean;
    function GetCanOpen: Boolean;
    function GetCanSave: Boolean;
    function GetCanSaveAs: Boolean;
    function GetCanSaveAll: Boolean;
    function GetCanClose: Boolean;
    function GetCanClosePage: Boolean;
    function GetCanCloseAll: Boolean;
    function GetCanPrint: Boolean;
    function GetCanExit: Boolean;

    function GetCanUndo: Boolean;
    function GetCanRedo: Boolean;
    function GetCanCut: Boolean;
    function GetCanCopy: Boolean;
    function GetCanPaste: Boolean;
    function GetCanSelectAll: Boolean;
    function GetCanClearAll: Boolean;

    function GetCanFind: Boolean;
    function GetCanReplace: Boolean;
    function GetCanSearchAgain: Boolean;
    function GetCanSearchIncremental: Boolean;
    function GetCanGoToLineNumber: Boolean;

    function GetCanShowWindowList: Boolean;
    function GetCanShowObjectList: Boolean;
    function GetCanBrowseNext: Boolean;
    function GetCanBrowsePrevious: Boolean;
    function GetCanBrowseBack: Boolean;
    function GetCanBrowseForward: Boolean;

    function GetCanShowEnvironmentOptions: Boolean;
    function GetCanShowEnvironmentConfigurator: Boolean;

    { Functions for misc properties
    }

    function GetMainMenu: TMainMenu;
    function GetImageList: TImageList;
    function GetActionList: TActionList;

    { Procedures for MainMenu properties
    }
    procedure New;
    procedure Open;
    procedure Save;
    procedure SaveAs;
    procedure SaveAll;
    procedure Close;
    procedure ClosePage;
    procedure CloseAll;
    procedure Print;
    procedure Exit;

    procedure Undo;
    procedure Redo;
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure SelectAll;
    procedure ClearAll;

    procedure Find;
    procedure Replace;
    procedure SearchAgain;
    procedure SearchIncremental;
    procedure GoToLineNumber;

    procedure ShowWindowList;
    procedure ShowObjectList;
    procedure BrowseNext;
    procedure BrowsePrevious;
    procedure BrowseBack;
    procedure BrowseForward;

    procedure ShowEnvironmentOptionsProc(const IID: TGUID);
    procedure ShowEnvironmentOptions;
    procedure ShowEnvironmentConfigurator;

    procedure UnderConstruction;
    procedure NotSupported;

    { MainMenu properties
    }
    // File
    property CanNew: Boolean read GetCanNew;
    property CanOpen: Boolean read GetCanOpen;
    property CanSave: Boolean read GetCanSave;
    property CanSaveAs: Boolean read GetCanSaveAs;
    property CanSaveAll: Boolean read GetCanSaveAll;
    property CanClose: Boolean read GetCanClose;
    property CanClosePage: Boolean read GetCanClosePage;
    property CanCloseAll: Boolean read GetCanCloseAll;
    property CanPrint: Boolean read GetCanPrint;
    property CanExit: Boolean read GetCanExit;
    // Edit
    property CanUndo: Boolean read GetCanUndo;
    property CanRedo: Boolean read GetCanRedo;
    property CanCut: Boolean read GetCanCut;
    property CanCopy: Boolean read GetCanCopy;
    property CanPaste: Boolean read GetCanPaste;
    property CanSelectAll: Boolean read GetCanSelectAll;
    property CanClearAll: Boolean read GetCanClearAll;
    // Search
    property CanFind: Boolean read GetCanFind;
    property CanReplace: Boolean read GetCanReplace;
    property CanSearchAgain: Boolean read GetCanSearchAgain;
    property CanSearchIncremental: Boolean read GetCanSearchIncremental;
    property CanGoToLineNumber: Boolean read GetCanGoToLineNumber;
    // View
    property CanShowWindowList: Boolean read GetCanShowWindowList;
    property CanShowObjectList: Boolean read GetCanShowObjectList;
    property CanBrowseNext: Boolean read GetCanBrowseNext;
    property CanBrowsePrevious: Boolean read GetCanBrowsePrevious;
    property CanBrowseBack: Boolean read GetCanBrowseBack;
    property CanBrowseForward: Boolean read GetCanBrowseForward;
    // Project
    // Tools
    property CanShowEnvironmentOptions: Boolean read GetCanShowEnvironmentOptions;
    property CanShowEnvironmentConfigurator: Boolean read GetCanShowEnvironmentConfigurator;
    // Window

    { Misc properties
    }
    property MainMenu: TMainMenu read GetMainMenu;
    property ImageList: TImageList read GetImageList;
    property ActionList: TActionList read GetActionList;
  end;

  IideBTRegistry = interface
  ['{42F7A7E7-E84F-4D07-AB7F-25CDBEDBD152}']
    function GetRegLibraryCount: Integer;
    function GetRegPackageCount: Integer;
    function GetRegComponentCount: Integer;
    function GetRegComponentFormCount: Integer;
    function GetRegPropertyEditorCount: Integer;
    function GetRegInterfaceCount: Integer;
    function GetRegDemonCount: Integer;

    function GetRegLibraryDescription(Index: Integer): string;
    function GetRegLibraryFileName(Index: Integer): string;
    function GetRegLibraryName(Index: Integer): string;

    function GetRegPackageDescription(Index: Integer): string;
    function GetRegPackageFileName(Index: Integer): string;
    function GetRegPackageName(Index: Integer): string;

    function GetRegBranchList: TComponentList;
    function GetRegBranchInfo(Index: Integer): ISHBranchInfo;  overload;
    function GetRegBranchInfo(const BranchIID: TGUID): ISHBranchInfo;  overload;
    function GetRegBranchInfo(const BranchName: string): ISHBranchInfo;  overload;

    function GetRegComponentClass(Index: Integer): TSHComponentClass;
    function GetRegComponentHint(Index: Integer): string;
    function GetRegComponentAssociation(Index: Integer): string;
    function GetRegComponentClassIID(Index: Integer): TGUID;

    function SupportInterface(const IID: TGUID; out Intf;
      const Description: string): Boolean;

    function GetRegDemon(Index: Integer): TSHComponent; overload;
    function GetRegDemon(const ClassIID: TGUID): TSHComponent; overload;

    function GetRegComponent(const ClassIID: TGUID): TSHComponentClass;
    function GetRegImageIndex(const AStringIID: string): Integer;
    function GetRegCallStrings(const AClassIID: TGUID): TStrings;
    function GetRegComponentForm(const ClassIID: TGUID;
      const CallString: string): TSHComponentFormClass;
    function GetRegComponentFactory(const ClassIID: TGUID): ISHComponentFactory; overload;
    function GetRegComponentFactory(const ClassIID, BranchIID: TGUID): ISHComponentFactory; overload;
    function GetRegComponentOptions(const ClassIID: TGUID): ISHComponentOptions;
    function GetRegPropertyEditor(const ClassIID: TGUID;
      const PropertyName: string): TSHPropertyEditorClass;


    procedure RegisterLibrary(const FileName: string);
    procedure UnRegisterLibrary(const FileName: string);
    function ExistsLibrary(const FileName: string): Boolean;
    procedure LoadLibrariesFromFile;
    procedure SaveLibrariesToFile;

    procedure RegisterPackage(const FileName: string);
    procedure UnRegisterPackage(const FileName: string);
    function ExistsPackage(const FileName: string): Boolean;
    procedure LoadPackagesFromFile;
    procedure SavePackagesToFile;

    procedure LoadOptionsFromFile;
    procedure SaveOptionsToFile;
    procedure LoadOptionsFromList;
    procedure SaveOptionsToList;

    procedure LoadImagesFromFile;

    procedure RegisterComponents(ComponentClasses: array of TSHComponentClass);
    procedure RegisterComponentForm(const ClassIID: TGUID;
      const CallString: string; ComponentForm: TSHComponentFormClass);
    procedure RegisterPropertyEditor(const ClassIID: TGUID;
      const PropertyName: string; PropertyEditor: TSHPropertyEditorClass);
    procedure RegisterImage(const StringIID, FileName: string);  
    procedure RegisterInterface(const Intf: IInterface;
      const Description: string);

    property RegLibraryCount: Integer read GetRegLibraryCount;
    property RegPackageCount: Integer read GetRegPackageCount;
    property RegComponentCount: Integer read GetRegComponentCount;
    property RegComponentFormCount: Integer read GetRegComponentFormCount;
    property RegPropertyEditorCount: Integer read GetRegPropertyEditorCount;
    property RegInterfaceCount: Integer read GetRegInterfaceCount;
    property RegDemonCount: Integer read GetRegDemonCount;
  end;

  IideSHComponentFactory = interface
  ['{E367E5E0-F0B2-435F-9F44-5B3763C0D4AB}']
    function GetComponents: TComponentList;
    function GetComponentForms: TComponentList;

    function CreateComponent(const OwnerIID, ClassIID: TGUID;
      const ACaption: string): TSHComponent;
    function DestroyComponent(AComponent: TSHComponent): Boolean;
    function FindComponent(const InstanceIID: TGUID): TSHComponent; overload;
    function FindComponent(const OwnerIID, ClassIID: TGUID): TSHComponent; overload;
    function FindComponent(const OwnerIID, ClassIID: TGUID; const ACaption: string): TSHComponent; overload;
    procedure SendEvent(Event: TSHEvent);

    property Components: TComponentList read GetComponents;
    property ComponentForms: TComponentList read GetComponentForms;
  end;

  IideBTObject = interface
  ['{54FB0BCA-568C-49CF-82C4-7F337511AC45}']
    function GetCurrentComponent: TSHComponent;
    function GetEnabled: Boolean;
    procedure SetEnabled(Value: Boolean);
    function GetFlat: Boolean;
    procedure SetFlat(Value: Boolean);
    function GetPageCtrl: TPageControl;
    procedure SetPageCtrl(Value: TPageControl);

    function Exists(AComponent: TSHComponent): Boolean;
    function Add(AComponent: TSHComponent): Boolean;
    function Remove(AComponent: TSHComponent): Boolean;

    property CurrentComponent: TSHComponent read GetCurrentComponent;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Flat: Boolean read GetFlat write SetFlat;
    property PageCtrl: TPageControl read GetPageCtrl write SetPageCtrl;
  end;

  IideSHConnection = interface
  ['{07662AB0-C7B1-4F22-A6F3-37F97837FA35}']
    function GetCanConnect: Boolean;
    function GetCanReconnect: Boolean;
    function GetCanDisconnect: Boolean;
    function GetCanDisconnectAll: Boolean;
    function GetCanRefresh: Boolean;
    function GetCanMoveUp: Boolean;
    function GetCanMoveDown: Boolean;
    function GetLoadingFromFile: Boolean;

    function GetCurrentServer: TSHComponent;
    function GetCurrentDatabase: TSHComponent;
    function GetCurrentServerInUse: Boolean;
    function GetCurrentDatabaseInUse: Boolean;
    function GetServerCount: Integer;
    function GetDatabaseCount: Integer;
    
    procedure Connect;
    procedure Reconnect;
    procedure Disconnect;
    function DisconnectAll: Boolean;
    procedure Refresh;
    procedure MoveUp;
    procedure MoveDown;

    function FindConnection(AConnection: TSHComponent): Boolean;
    function RegisterConnection(AConnection: TSHComponent): Boolean;
    function UnregisterConnection(AConnection: TSHComponent): Boolean;
    function DestroyConnection(AConnection: TSHComponent): Boolean;
    
    function ConnectTo(AConnection: TSHComponent): Boolean;
    function ReconnectTo(AConnection: TSHComponent): Boolean;
    function DisconnectFrom(AConnection: TSHComponent): Boolean;
    procedure RefreshConnection(AConnection: TSHComponent);
    procedure ActivateConnection(AConnection: TSHComponent);
    function SynchronizeConnection(AConnection: TSHComponent; const AClassIID: TGUID;
      const ACaption: string; Operation: TOperation): Boolean;

    procedure SetRegistrationMenuItems(AMenuItem: TMenuItem);
    procedure SetConnectionMenuItems(AMenuItem: TMenuItem);

    procedure SaveToFile;
    procedure LoadFromFile;

    property CanConnect: Boolean read GetCanConnect;
    property CanReconnect: Boolean read GetCanReconnect;
    property CanDisconnect: Boolean read GetCanDisconnect;
    property CanDisconnectAll: Boolean read GetCanDisconnectAll;
    property CanRefresh: Boolean read GetCanRefresh;
    property CanMoveUp: Boolean read GetCanMoveUp;
    property CanMoveDown: Boolean read GetCanMoveDown;
    property LoadingFromFile: Boolean read GetLoadingFromFile;

    property CurrentServer: TSHComponent read GetCurrentServer;
    property CurrentDatabase: TSHComponent read GetCurrentDatabase;
    property CurrentServerInUse: Boolean read GetCurrentServerInUse;
    property CurrentDatabaseInUse: Boolean read GetCurrentDatabaseInUse;
    property ServerCount: Integer read GetServerCount;
    property DatabaseCount: Integer read GetDatabaseCount;
  end;

  IideSHToolbox = interface
  ['{7BC789C7-8F20-4D83-ACF2-75F3346883F1}']
    procedure ReloadComponents;
    procedure InvalidateComponents;

    procedure _InspCreateForm(AComponent: TSHComponent);
    function _InspFindForm(AComponent: TSHComponent): TSHComponentForm;
    procedure _InspDestroyForm(AComponent: TSHComponent);
    procedure _InspHideForm(AComponent: TSHComponent);
    procedure _InspShowForm(AComponent: TSHComponent);
    procedure _InspRefreshForm(AComponent: TSHComponent);
    procedure _InspPrepareForm(AComponent: TSHComponent);
    procedure _InspAddAction(AAction: TSHAction);
    procedure _InspUpdateNodes;    
  end;

  IideSHNavigator = interface
  ['{59A1DAEF-DB97-49B8-B32E-ADFDE8A05FC7}']
    function GetCurrentBranch: TSHComponent;
    function GetCurrentServer: TSHComponent;
    function GetCurrentDatabase: TSHComponent;
    function GetCurrentServerInUse: Boolean;
    function GetCurrentDatabaseInUse: Boolean;
    function GetServerCount: Integer;
    function GetDatabaseCount: Integer;
    function GetCanConnect: Boolean;
    function GetCanReconnect: Boolean;
    function GetCanDisconnect: Boolean;
    function GetCanDisconnectAll: Boolean;
    function GetCanRefresh: Boolean;
    function GetCanMoveUp: Boolean;
    function GetCanMoveDown: Boolean;
    function GetCanShowScheme: Boolean;
    function GetCanShowPalette: Boolean;
    function GetLoadingFromFile: Boolean;
    function GetToolbox: IideSHToolbox;

    procedure SetBranchMenuItems(AMenuItem: TMenuItem);
    procedure SetRegistrationMenuItems(AMenuItem: TMenuItem);
    procedure SetConnectionMenuItems(AMenuItem: TMenuItem);

    function RegisterConnection(AConnection: TSHComponent): Boolean;   // регистрация соединения
    function UnregisterConnection(AConnection: TSHComponent): Boolean; // отрегистрация соединения
    function DestroyConnection(AConnection: TSHComponent): Boolean; // разрушение соединения
    function DisconnectAllConnections: Boolean; // отключить все коннекты

    function ConnectTo(AConnection: TSHComponent): Boolean;
    function ReconnectTo(AConnection: TSHComponent): Boolean;
    function DisconnectFrom(AConnection: TSHComponent): Boolean;
    procedure RefreshConnection(AConnection: TSHComponent);
    procedure ActivateConnection(AConnection: TSHComponent);
    function SynchronizeConnection(AConnection: TSHComponent; const AClassIID: TGUID;
      const ACaption: string; Operation: TOperation): Boolean;

    procedure Connect;
    procedure Reconnect;
    procedure Disconnect;
    function DisconnectAll: Boolean;
    procedure Refresh;

    procedure SaveRegisteredInfoToFile;   // сохранение регинфы в файл
    procedure LoadRegisteredInfoFromFile; // вычитка регинфы из файла

    procedure RecreatePalette;
    procedure RefreshPalette;
    procedure ShowScheme;
    procedure ShowPalette;

    property CurrentBranch: TSHComponent read GetCurrentBranch;
    property CurrentServer: TSHComponent read GetCurrentServer;
    property CurrentDatabase: TSHComponent read GetCurrentDatabase;
    property CurrentServerInUse: Boolean read GetCurrentServerInUse;
    property CurrentDatabaseInUse: Boolean read GetCurrentDatabaseInUse;
    property ServerCount: Integer read GetServerCount;
    property DatabaseCount: Integer read GetDatabaseCount;
    property CanConnect: Boolean read GetCanConnect;
    property CanReconnect: Boolean read GetCanReconnect;
    property CanDisconnect: Boolean read GetCanDisconnect;
    property CanDisconnectAll: Boolean read GetCanDisconnectAll;
    property CanRefresh: Boolean read GetCanRefresh;
    property CanMoveUp: Boolean read GetCanMoveUp;
    property CanMoveDown: Boolean read GetCanMoveDown;
    property CanShowScheme: Boolean read GetCanShowScheme;
    property CanShowPalette: Boolean read GetCanShowPalette;
    property LoadingFromFile: Boolean read GetLoadingFromFile;
    property Toolbox: IideSHToolbox read GetToolbox;
  end;

  IideBTBaseForm = interface
  ['{4E34ADD2-C09B-4EAA-A853-294C42E5E6E0}']
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetCurrentComponent: TSHComponent;

    function Exists(AComponent: TSHComponent): Boolean;
    function Add(AComponent: TSHComponent): Boolean;
    function Remove(AComponent: TSHComponent): Boolean;

    property Active: Boolean read GetActive write SetActive;
    property CurrentComponent: TSHComponent read GetCurrentComponent;
  end;

  IideBTRegistratorForm = interface(IideBTBaseForm)
  ['{996F56F6-76A0-432E-911F-5886F0FD6826}']
    function GetLoading: Boolean;
    function GetCurrentServer: TSHComponent;
    function GetCurrentDatabase: TSHComponent;
    function GetCanMoveUp: Boolean;
    function GetCanMoveDown: Boolean;

    procedure MoveUp;
    procedure MoveDown;
    procedure SaveToFile;
    procedure LoadFromFile;
    function ExistsConnected: Boolean;
    function DisconnectAll: Boolean;

    property Loading: Boolean read GetLoading;
    property CurrentServer: TSHComponent read GetCurrentServer;
    property CurrentDatabase: TSHComponent read GetCurrentDatabase;
    property CanMoveUp: Boolean read GetCanMoveUp;
    property CanMoveDown: Boolean read GetCanMoveDown;
  end;

  IideBTNavigatorForm = interface(IideBTBaseForm)
  ['{BD8046BC-40CB-4E8C-8664-DD6F03F9565B}']
    function GetCurrentServer: TSHComponent;
    function GetCurrentDatabase: TSHComponent;

    function SynchronizeConnection(const AOwnerIID, AClassIID: TGUID;
      const ACaption: string; Operation: TOperation): Boolean;
    procedure Refresh(AComponent: TSHComponent);

    property CurrentServer: TSHComponent read GetCurrentServer;
    property CurrentDatabase: TSHComponent read GetCurrentDatabase;
  end;

  IideSHObjectEditor = interface(IideBTObject)
  ['{441B05B0-57FD-4422-97F8-263805B9B2BE}']
    function GetMultiLine: Boolean;
    procedure SetMultiLine(Value: Boolean);
    function GetFilterMode: Boolean;
    procedure SetFilterMode(Value: Boolean);
    function GetCurrentComponentForm: TSHComponentForm;
    function GetCurrentCallString: string;
    function GetCallStringCount: Integer;
    
    procedure CreateEditor;
    procedure ChangeEditor;
    function GetComponent(Index: Integer): TSHComponent;
    function GetCallStrings(Index: Integer): TStrings;
    procedure GetCaptionList(APopupMenu: TPopupMenu); overload;
    procedure GetCaptionList(AMenuItem: TMenuItem); overload;
    procedure GetBackList(APopupMenu: TPopupMenu);
    procedure GetForwardList(APopupMenu: TPopupMenu);
    function GetCanBrowseBack(AComponent: TSHComponent): Boolean;
    function GetCanBrowseForward(AComponent: TSHComponent): Boolean;
    procedure Jump(AFromComponent, AToComponent: TSHComponent);
    procedure JumpRemove(const AOwnerIID, AClassIID: TGUID; const ACaption: string);
    procedure BrowseNext;
    procedure BrowsePrevious;
    procedure BrowseBack;
    procedure BrowseForward;

    function Exists(AComponent: TSHComponent; const CallString: string = ''): Boolean; overload;
    function Add(AComponent: TSHComponent; const CallString: string = ''): Boolean; overload;
    function Remove(AComponent: TSHComponent; const CallString: string = ''): Boolean; overload;

    function CanUpdateToolbarActions: Boolean;
    procedure UpdateToolbarActions;

    property MultiLine: Boolean read GetMultiLine write SetMultiLine;
    property FilterMode: Boolean read GetFilterMode write SetFilterMode;
    property CurrentComponentForm: TSHComponentForm read GetCurrentComponentForm;
    property CurrentCallString: string read GetCurrentCallString;
    property CallStringCount: Integer read GetCallStringCount;
  end;


  IideBTMegaEditor = interface
  ['{D80700B7-3CBC-4378-A0F0-97DB50000CC9}']
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetMultiLine: Boolean;
    procedure SetMultiLine(Value: Boolean);
    function GetFilterMode: Boolean;
    procedure SetFilterMode(Value: Boolean);

    procedure GetCaptionList(APopupMenu: TPopupMenu);
    function Exists(AComponent: TSHComponent; const CallString: string): Boolean;
    function Add(AComponent: TSHComponent; const CallString: string): Boolean;
    function Remove(AComponent: TSHComponent; const CallString: string): Boolean;
    procedure Toggle(AIndex: Integer);
    function Close: Boolean;
    function CloseAll: Boolean;
    function ShowEditor(AComponent: TSHComponent): Boolean; overload;
    function ShowEditor(const AIndex: Integer): Boolean; overload;
    function DestroyEditor(const AIndex: Integer): Boolean;

    property Active: Boolean read GetActive write SetActive;
    property MultiLine: Boolean read GetMultiLine write SetMultiLine;
    property FilterMode: Boolean read GetFilterMode write SetFilterMode;
  end;

implementation

end.






