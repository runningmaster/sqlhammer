unit ideSHRegistry;

interface

uses
  Windows, SysUtils, Classes, Contnrs, Dialogs, Graphics, StrUtils, ActnList,
  SHDesignIntf, SHDevelopIntf,
  ideSHDesignIntf;

procedure ideBTRegisterActions(ActionClasses: array of TSHActionClass);
procedure ideBTRegisterComponents(ComponentClasses: array of TSHComponentClass);
procedure ideBTRegisterComponentForm(const ClassIID: TGUID; const CallString: string; ComponentForm: TSHComponentFormClass);
procedure ideBTRegisterPropertyEditor(const ClassIID: TGUID; const PropertyName: string; PropertyEditor: TSHPropertyEditorClass);
procedure ideBTRegisterImage(const StringIID, FileName: string);
procedure ideBTRegisterInterface(const Intf: IInterface; const Description: string);
function ideBTSupportInterface(const IID: TGUID; out Intf; const Description: string): Boolean;

type
  TRegLibraryDescr = class
  private
    FDescription: string;
    FFileName: string;
    FModuleHandle: HModule;
  public
    property Description: string read FDescription write FDescription;
    property FileName: string read FFileName write FFileName;
    property ModuleHandle: HModule read FModuleHandle write FModuleHandle;
  end;

  TRegPackageDescr = class
  private
    FDescription: string;
    FFileName: string;
    FModuleHandle: HModule;
  public
    property Description: string read FDescription write FDescription;
    property FileName: string read FFileName write FFileName;
    property ModuleHandle: HModule read FModuleHandle write FModuleHandle;
  end;

  TRegComponentDescr = class
  private
    FComponentClass: TSHComponentClass;
  public
    property ComponentClass: TSHComponentClass read FComponentClass write FComponentClass;
  end;

  TRegComponentFormDescr = class
  private
    FClassIID: TGUID;
    FCallString: string;
    FComponentForm: TSHComponentFormClass;
  public
    property ClassIID: TGUID read FClassIID write FClassIID;
    property CallString: string read FCallString write FCallString;
    property ComponentForm: TSHComponentFormClass read FComponentForm write FComponentForm;
  end;

  TRegPropertyEditorDescr = class
  private
    FClassIID: TGUID;
    FPropertyName: string;
    FPropertyEditor: TSHPropertyEditorClass;
  public
    property ClassIID: TGUID read FClassIID write FClassIID;
    property PropertyName: string read FPropertyName write FPropertyName;
    property PropertyEditor: TSHPropertyEditorClass read FPropertyEditor write FPropertyEditor;
  end;

  TideBTRegistry = class(TComponent, IideBTRegistry)
  private
    FLibraryList: TObjectList;
    FPackageList: TObjectList;

    FInterfaceList: TInterfaceList;
    FInterfaceDescrList: TStrings;

    FBranchList: TComponentList;
    FComponentList: TObjectList;
    FPropertyEditorList: TObjectList;
    FComponentFormList: TObjectList;
    FDemonList: TComponentList;
    FImageFileList: TStrings;
    FImageIIDList: TStrings;

    FCallStringList: TStrings;
    FPropSavedList: TStrings;

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
    function GetRegBranchInfo(Index: Integer): ISHBranchInfo; overload;
    function GetRegBranchInfo(const BranchIID: TGUID): ISHBranchInfo; overload;
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


    function IndexOfLibrary(const FileName: string): Integer;
    function ExistsLibrary(const FileName: string): Boolean;
    function AddLibrary(const FileName: string): HModule;
    procedure RemoveLibrary(const FileName: string);

    function IndexOfPackage(const FileName: string): Integer;
    function ExistsPackage(const FileName: string): Boolean;
    function AddPackage(const FileName: string): HModule;
    procedure RemovePackage(const FileName: string);

    function IndexOfComponent(ComponentClass: TSHComponentClass): Integer;
    function ExistsComponent(ComponentClass: TSHComponentClass): Boolean;
    procedure AddComponent(ComponentClass: TSHComponentClass);
//    procedure RemoveComponent(ComponentClass: TSHComponentClass);

    function IndexOfComponentForm(const ClassIID: TGUID;
      const CallString: string; ComponentForm: TSHComponentFormClass): Integer;
    function ExistsComponentForm(const ClassIID: TGUID;
      const CallString: string; ComponentForm: TSHComponentFormClass): Boolean;
    procedure AddComponentForm(const ClassIID: TGUID;
      const CallString: string; ComponentForm: TSHComponentFormClass);
//    procedure RemoveComponentForm(const ClassIID: TGUID;
//      const CallString: string; ComponentForm: TSHComponentFormClass);

    function IndexOfPropertyEditor(const ClassIID: TGUID;
      const PropertyName: string; PropertyEditor: TSHPropertyEditorClass): Integer;
    function ExistsPropertyEditor(const ClassIID: TGUID;
      const PropertyName: string; PropertyEditor: TSHPropertyEditorClass): Boolean;
    procedure AddPropertyEditor(const ClassIID: TGUID;
      const PropertyName: string; PropertyEditor: TSHPropertyEditorClass);
//    procedure RemovePropertyEditor(const ClassIID: TGUID;
//      const PropertyName: string; PropertyEditor: TSHPropertyEditorClass);

//    function IndexOfInterface(const Intf: IInterface;
//      const Description: string): Integer;
//    function ExistsInterface(const Intf: IInterface;
//      const Description: string): Boolean;
    procedure AddInterface(const Intf: IInterface;
      const Description: string);
//    procedure RemoveInterface(const Intf: IInterface;
//      const Description: string);

    procedure RegisterLibrary(const FileName: string);
    procedure UnRegisterLibrary(const FileName: string);

    procedure RegisterPackage(const FileName: string);
    procedure UnRegisterPackage(const FileName: string);

    procedure RegisterComponents(ComponentClasses: array of TSHComponentClass);
    procedure RegisterComponentForm(const ClassIID: TGUID;
      const CallString: string; ComponentForm: TSHComponentFormClass);
    procedure RegisterPropertyEditor(const ClassIID: TGUID;
      const PropertyName: string; PropertyEditor: TSHPropertyEditorClass);
    procedure RegisterImage(const StringIID, FileName: string);
    procedure RegisterInterface(const Intf: IInterface;
      const Description: string);

    procedure LoadLibrariesFromFile;
    procedure SaveLibrariesToFile;
    function InitializeLibraryA(const FileName: string): HModule;
//    procedure InitializeLibraries;
    function GetLibraryDescription(ModuleHandle: HModule): string;

    procedure LoadPackagesFromFile;
    procedure SavePackagesToFile;
    function InitializePackageA(const FileName: string): HModule;
//    procedure InitializePackages;

//    procedure LoadImagesFromModule(Module: HModule);

    procedure LoadOptionsFromFile;
    procedure SaveOptionsToFile;
    procedure LoadOptionsFromList;
    procedure SaveOptionsToList;

    procedure LoadImagesFromFile;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  ideSHSplashFrm, ideSHMainFrm,
  ideSHConsts, ideSHMessages, ideSHSysUtils, ideSHSystem,
  SysConst;


procedure ideBTRegisterActions(ActionClasses: array of TSHActionClass);
var
  I: Integer;
  Action: TSHAction;
begin
  for I := Low(ActionClasses) to High(ActionClasses) do
    if Assigned(ActionClasses[I]) then
    begin
      Action := ActionClasses[I].Create(MainForm);
      Action.ActionList := MainForm.ActionList1;
    end;
end;

procedure ideBTRegisterComponents(ComponentClasses: array of TSHComponentClass);
begin
  if Assigned(RegistryIntf) then RegistryIntf.RegisterComponents(ComponentClasses);
end;

procedure ideBTRegisterComponentForm(const ClassIID: TGUID;
  const CallString: string; ComponentForm: TSHComponentFormClass);
begin
  if Assigned(RegistryIntf) then RegistryIntf.RegisterComponentForm(ClassIID, CallString, ComponentForm);
end;

procedure ideBTRegisterPropertyEditor(const ClassIID: TGUID;
  const PropertyName: string; PropertyEditor: TSHPropertyEditorClass);
begin
  if Assigned(RegistryIntf) then RegistryIntf.RegisterPropertyEditor(ClassIID, PropertyName, PropertyEditor);
end;

procedure ideBTRegisterImage(const StringIID, FileName: string);
begin
  if Assigned(RegistryIntf) then RegistryIntf.RegisterImage(StringIID, FileName);
end;

procedure ideBTRegisterInterface(const Intf: IInterface;
  const Description: string);
begin
  if Assigned(RegistryIntf) then RegistryIntf.RegisterInterface(Intf, Description);
end;

function ideBTSupportInterface(const IID: TGUID; out Intf;
  const Description: string): Boolean;
begin
  Result := Assigned(RegistryIntf) and RegistryIntf.SupportInterface(IID, Intf, Description);
end;

//function ForEachModule(HInstance: Longint; Data: Pointer): Boolean;
//type
//  TPackageLoad = procedure;
//var
//  PackageLoad: TPackageLoad;
//begin
//  @PackageLoad := GetProcAddress(HInstance, 'Initialize'); //Do not localize
//  if Assigned(PackageLoad) then
//  begin
//    InitializePackage(HInstance);
//    Registry.LoadImagesFromModule(HInstance);
//  end;
//  Result := True;
//end;

procedure _InitializePackage(Module: HMODULE);
begin
  try
    InitializePackage(Module);
  except
    FreeLibrary(Module);
    raise;
  end;
end;

function _GetPackageDescription(Module: HMODULE): string;
var
  ResInfo: HRSRC;
  ResData: HGLOBAL;
begin
  ResInfo := FindResource(Module, 'DESCRIPTION', RT_RCDATA);
  if ResInfo <> 0 then
  begin
    ResData := LoadResource(Module, ResInfo);
    if ResData <> 0 then
    try
      Result := PWideChar(LockResource(ResData));
      UnlockResource(ResData);
    finally
      FreeResource(ResData);
    end;
  end;
end;

function _ModuleIsPackage(Module: HMODULE): Boolean;
type
  TPackageLoad = procedure;
var
  PackageLoad: TPackageLoad;
begin
  @PackageLoad := GetProcAddress(Module, 'Initialize'); //Do not localize
  Result := Assigned(PackageLoad);
end;

function _ModuleIsSQLHammerPackage(Module: HMODULE): Boolean;
begin
  Result := Pos(AnsiUpperCase('BlazeTop'), AnsiUpperCase(_GetPackageDescription(Module))) = 1;
end;

function _ModuleDontInit(CurModule: PLibModule): Boolean;
begin
  Result := CurModule.Reserved <> - 100;
end;

procedure _InitializePackages;
var
  CurModule: PLibModule;
  ModuleList: TList;
  I: Integer;
begin
  ModuleList := TList.Create;

  try
    CurModule := LibModuleList;
    while CurModule <> nil do
    begin
      if _ModuleIsPackage(CurModule.Instance) and
         _ModuleIsSQLHammerPackage(CurModule.Instance) and
         _ModuleDontInit(CurModule) then ModuleList.Add(CurModule);
      CurModule := CurModule.Next;
    end;

    for I := Pred(ModuleList.Count) downto 0 do
    begin
      CurModule := ModuleList[I];
      _InitializePackage(CurModule.Instance);
   //   Registry.LoadImagesFromModule(CurModule.Instance);
      CurModule.Reserved := -100;
    end;
  finally
    ModuleList.Free;
  end;
end;

function _LoadPackage(const Name: string): HMODULE;
begin
  Result := SafeLoadLibrary(Name);
  if Result = 0 then
    raise EPackageError.CreateResFmt(@sErrorLoadingPackage, [Name, SysErrorMessage(GetLastError)]);
end;

{ TideBTRegistry }

constructor TideBTRegistry.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPackageList := TObjectList.Create;
  FLibraryList := TObjectList.Create;
  FInterfaceList := TInterfaceList.Create;
  FInterfaceDescrList := TStringList.Create;
  FBranchList := TComponentList.Create(False);
  FComponentList := TObjectList.Create;
  FPropertyEditorList := TObjectList.Create;
  FComponentFormList := TObjectList.Create;
  FDemonList := TComponentList.Create;
  FImageFileList := TStringList.Create;
  FImageIIDList := TStringList.Create;
  FCallStringList := TStringList.Create;
  FPropSavedList := TStringList.Create;

  (FImageFileList as TStringList).Sorted := True;
  (FImageIIDList as TStringList).Sorted := True;
end;

destructor TideBTRegistry.Destroy;
begin
  FLibraryList.Free;
  FPackageList.Free;
  FInterfaceList := nil;
  FInterfaceDescrList.Free;
  FBranchList.Free;
  FComponentList.Free;
  FPropertyEditorList.Free;
  FComponentFormList.Free;
  FDemonList.Free;
  FImageFileList.Free;
  FImageIIDList.Free;
  FCallStringList.Free;
  FPropSavedList.Free;
  inherited Destroy;
end;
function TideBTRegistry.GetRegLibraryCount: Integer;
begin
  Result := FLibraryList.Count;
end;

function TideBTRegistry.GetRegPackageCount: Integer;
begin
  Result := FPackageList.Count;
end;

function TideBTRegistry.GetRegComponentCount: Integer;
begin
  Result := FComponentList.Count;
end;

function TideBTRegistry.GetRegComponentFormCount: Integer;
begin
  Result := FComponentFormList.Count;
end;

function TideBTRegistry.GetRegPropertyEditorCount: Integer;
begin
  Result := FPropertyEditorList.Count;
end;

function TideBTRegistry.GetRegInterfaceCount: Integer;
begin
  Result := FInterfaceList.Count;
end;

function TideBTRegistry.GetRegDemonCount: Integer;
begin
  Result := FDemonList.Count;
end;

function TideBTRegistry.GetRegLibraryDescription(Index: Integer): string;
begin
  Result := TRegLibraryDescr(FLibraryList[Index]).Description;
end;

function TideBTRegistry.GetRegLibraryFileName(Index: Integer): string;
begin
  Result := TRegLibraryDescr(FLibraryList[Index]).FileName;
end;

function TideBTRegistry.GetRegLibraryName(Index: Integer): string;
begin
  Result := ExtractFileName(TRegLibraryDescr(FLibraryList[Index]).FileName);
end;

function TideBTRegistry.GetRegPackageDescription(Index: Integer): string;
begin
  Result := TRegPackageDescr(FPackageList[Index]).Description;
end;

function TideBTRegistry.GetRegPackageFileName(Index: Integer): string;
begin
  Result := TRegPackageDescr(FPackageList[Index]).FileName;
end;

function TideBTRegistry.GetRegPackageName(Index: Integer): string;
begin
  Result := ExtractFileName(TRegPackageDescr(FPackageList[Index]).FileName);
end;

function TideBTRegistry.GetRegBranchList: TComponentList;
begin
  Result := FBranchList;
end;

function TideBTRegistry.GetRegBranchInfo(Index: Integer): ISHBranchInfo;
begin
  Supports(FBranchList[Index], ISHBranchInfo, Result);
end;

function TideBTRegistry.GetRegBranchInfo(const BranchIID: TGUID): ISHBranchInfo;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(FBranchList.Count) do
   if IsEqualGUID(TSHComponent(FBranchList[I]).ClassIID, BranchIID) then
   begin
     Result := GetRegBranchInfo(I);
     Break;
   end;
end;

function TideBTRegistry.GetRegBranchInfo(const BranchName: string): ISHBranchInfo;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(FBranchList.Count) do
   if AnsiSameText(GetRegBranchInfo(I).BranchName, BranchName) then
   begin
     Result := GetRegBranchInfo(I);
     Break;
   end;
end;

function TideBTRegistry.GetRegComponentClass(Index: Integer): TSHComponentClass;
begin
  Result := TRegComponentDescr(FComponentList[Index]).ComponentClass;
end;

function TideBTRegistry.GetRegComponentHint(Index: Integer): string;
begin
  Result := TRegComponentDescr(FComponentList[Index]).ComponentClass.GetHintClassFnc;
end;

function TideBTRegistry.GetRegComponentAssociation(Index: Integer): string;
begin
  Result := TRegComponentDescr(FComponentList[Index]).ComponentClass.GetAssociationClassFnc;
end;

function TideBTRegistry.GetRegComponentClassIID(Index: Integer): TGUID;
begin
  Result := TRegComponentDescr(FComponentList[Index]).ComponentClass.GetClassIIDClassFnc;
end;

function TideBTRegistry.SupportInterface(const IID: TGUID; out Intf;
  const Description: string): Boolean;
var
  I: Integer;
begin
  Result := False;

  for I := Pred(FInterfaceList.Count) downto 0 do
  begin
    Result := Supports(FInterfaceList.Items[I], IID, Intf);
    if Result then
      if AnsiSameText(FInterfaceDescrList[I], Description) then Break;
  end;
end;

function TideBTRegistry.GetRegDemon(Index: Integer): TSHComponent;
begin
  Result := TSHComponent(FDemonList[Index]);
end;

function TideBTRegistry.GetRegDemon(const ClassIID: TGUID): TSHComponent;
var
  I: Integer;
begin
  Result := nil;
  for I := Pred(FDemonList.Count) downto 0 do
  begin
    if IsEqualGUID(TSHComponent(FDemonList[I]).ClassIID, ClassIID) then
      Result := FDemonList[I] as TSHComponent;
    if Assigned(Result) then
      Break;
  end;
end;

function TideBTRegistry.GetRegComponent(const ClassIID: TGUID): TSHComponentClass;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(FComponentList.Count) do
    if IsEqualGUID(TRegComponentDescr(FComponentList[I]).ComponentClass.GetClassIIDClassFnc, ClassIID) then
    begin
      Result := TRegComponentDescr(FComponentList[I]).ComponentClass;
      Break;
    end;
end;

function TideBTRegistry.GetRegImageIndex(const AStringIID: string): Integer;
var
  I: Integer;
begin
  Result := IMG_DEFAULT;
  I := FImageIIDList.IndexOf(AnsiUpperCase(AStringIID));
  if I <> -1 then
    Result := Integer(FImageIIDList.Objects[I]);
end;

function TideBTRegistry.GetRegCallStrings(const AClassIID: TGUID): TStrings;
var
  I: Integer;
begin
  FCallStringList.Clear;
  for I := Pred(FComponentFormList.Count) downto  0 do
    if IsEqualGUID(TRegComponentFormDescr(FComponentFormList[I]).ClassIID, AClassIID) then
      if FCallStringList.IndexOf(TRegComponentFormDescr(FComponentFormList[I]).CallString) = -1 then
        FCallStringList.Add(TRegComponentFormDescr(FComponentFormList[I]).CallString);
  Result := FCallStringList;
end;

function TideBTRegistry.GetRegComponentForm(const ClassIID: TGUID;
  const CallString: string): TSHComponentFormClass;
var
  I, J: Integer;
  ClassPtr: TClass;
  IntfTable: PInterfaceTable;
begin
  Result := nil;
  ClassPtr := GetRegComponent(ClassIID);
  while Assigned(ClassPtr) do
  begin
    IntfTable := ClassPtr.GetInterfaceTable;
    if Assigned(IntfTable) then
    begin
      for I := Pred(IntfTable.EntryCount) downto 0 do
      begin
          for J := Pred(FComponentFormList.Count) downto 0 do
            if IsEqualGUID(TRegComponentFormDescr(FComponentFormList[J]).ClassIID, IntfTable.Entries[I].IID) and
               AnsiSameText(TRegComponentFormDescr(FComponentFormList[J]).CallString, CallString) then
            begin
              Result := TRegComponentFormDescr(FComponentFormList[J]).ComponentForm;
              Exit;
            end;
      end;
    end;
    ClassPtr := ClassPtr.ClassParent;
  end;
end;

function TideBTRegistry.GetRegComponentFactory(const ClassIID: TGUID): ISHComponentFactory;
var
  I: Integer;
begin
  Result := nil;
  for I := Pred(FDemonList.Count) downto 0 do
  begin
    Supports(FDemonList[I], ISHComponentFactory, Result);
    if Assigned(Result) then
      if Result.SupportComponent(ClassIID) then
        Break;

    Result := nil;
  end;
end;

function TideBTRegistry.GetRegComponentFactory(const ClassIID, BranchIID: TGUID): ISHComponentFactory;
var
  I: Integer;
begin
  Result := nil;
  for I := Pred(FDemonList.Count) downto 0 do
  begin
    if (FDemonList[I] is TSHComponent) and IsEqualGUID(TSHComponent(FDemonList[I]).BranchIID, BranchIID) then
      Supports(FDemonList[I], ISHComponentFactory, Result);
    if Assigned(Result) then
      if Result.SupportComponent(ClassIID) then
        Break;

    Result := nil;
  end;
end;

function TideBTRegistry.GetRegComponentOptions(const ClassIID: TGUID): ISHComponentOptions;
var
  I: Integer;
begin
  Result := nil;
  for I := Pred(FDemonList.Count) downto 0 do
  begin
    if IsEqualGUID(TSHComponent(FDemonList[I]).ClassIID, ClassIID) then
      Supports(FDemonList[I], ClassIID, Result);
    if Assigned(Result) then
      Break;
  end;
end;

function TideBTRegistry.GetRegPropertyEditor(const ClassIID: TGUID;
  const PropertyName: string): TSHPropertyEditorClass;
var
  I: Integer;
begin
  Result := nil;
  for I := Pred(FPropertyEditorList.Count) downto 0 do
    if IsEqualGUID(TRegPropertyEditorDescr(FPropertyEditorList[I]).ClassIID, ClassIID) and
       AnsiSameText(TRegPropertyEditorDescr(FPropertyEditorList[I]).PropertyName, PropertyName) then
    begin
      Result := TRegPropertyEditorDescr(FPropertyEditorList[I]).PropertyEditor;
      Break;
    end;
end;

function TideBTRegistry.IndexOfPackage(const FileName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(FPackageList.Count) do
    if AnsiSameText(ExtractFileName(TRegPackageDescr(FPackageList[I]).FileName), ExtractFileName(FileName)) then
    begin
      Result := I;
      Break;
    end;
end;

function TideBTRegistry.ExistsPackage(const FileName: string): Boolean;
begin
  Result := IndexOfPackage(FileName) <> -1;
end;

function TideBTRegistry.AddPackage(const FileName: string): HModule;
var
  RegPackageDescr: TRegPackageDescr;
begin
  Result := 0;
  if not ExistsPackage(FileName) then
  begin
    Result := InitializePackageA(FileName);
    if Result <> 0 then
    begin
      RegPackageDescr := TRegPackageDescr.Create;
      RegPackageDescr.FileName := FileName;
      RegPackageDescr.Description := SysUtils.GetPackageDescription(PChar(FileName));
      RegPackageDescr.ModuleHandle := Result;
      FPackageList.Add(RegPackageDescr);
      if Assigned(SplashForm) then SplashForm.SplashTrace(RegPackageDescr.Description);
    end;
  end;
end;

procedure TideBTRegistry.RemovePackage(const FileName: string);
var
  I: Integer;
begin
  I := IndexOfPackage(FileName);
  if I <> -1 then FPackageList.Delete(I);
end;

function TideBTRegistry.IndexOfLibrary(const FileName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(FLibraryList.Count) do
    if AnsiSameText(ExtractFileName(TRegLibraryDescr(FLibraryList[I]).FileName), ExtractFileName(FileName)) then
    begin
      Result := I;
      Break;
    end;
end;

function TideBTRegistry.ExistsLibrary(const FileName: string): Boolean;
begin
  Result := IndexOfLibrary(FileName) <> -1;
end;

function TideBTRegistry.AddLibrary(const FileName: string): HModule;
var
  RegLibraryDescr: TRegLibraryDescr;
begin
  Result := 0;
  if not ExistsLibrary(FileName) then
  begin
    Result := InitializeLibraryA(FileName);
    if Result <> 0 then
    begin
      RegLibraryDescr := TRegLibraryDescr.Create;
      RegLibraryDescr.FileName := FileName;
      RegLibraryDescr.Description := GetLibraryDescription(Result);
      RegLibraryDescr.ModuleHandle := Result;
      FLibraryList.Add(RegLibraryDescr);
      if Assigned(SplashForm) then SplashForm.SplashTrace(RegLibraryDescr.Description);
//      if Assigned(BTSplashForm) then BTSplashForm.SplashTraceDone;
    end;
  end;
end;

procedure TideBTRegistry.RemoveLibrary(const FileName: string);
var
  I: Integer;
begin
  I := IndexOfLibrary(FileName);
  if I <> -1 then FLibraryList.Delete(I);
end;

function TideBTRegistry.IndexOfComponent(ComponentClass: TSHComponentClass): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(FComponentList.Count) do
    if TRegComponentDescr(FComponentList[I]).ComponentClass = ComponentClass then
    begin
      Result := I;
      Break;
    end;
end;

function TideBTRegistry.ExistsComponent(ComponentClass: TSHComponentClass): Boolean;
begin
  if Supports(ComponentClass, ISHDRVNativeDAC) then
    Result := False
  else
    Result := IndexOfComponent(ComponentClass) <> -1;
end;

procedure TideBTRegistry.AddComponent(ComponentClass: TSHComponentClass);
var
  RegComponentDescr: TRegComponentDescr;
begin
  if not ExistsComponent(ComponentClass) then
  begin
    RegComponentDescr := TRegComponentDescr.Create;
    RegComponentDescr.ComponentClass := ComponentClass;
    FComponentList.Add(RegComponentDescr);
  end;
end;

//procedure TideBTRegistry.RemoveComponent(ComponentClass: TSHComponentClass);
//var
//  I: Integer;
//begin
//  I := IndexOfComponent(ComponentClass);
//  if I <> -1 then FComponentList.Delete(I);
//end;

function TideBTRegistry.IndexOfComponentForm(const ClassIID: TGUID;
  const CallString: string; ComponentForm: TSHComponentFormClass): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(FComponentFormList.Count) do
    if IsEqualGUID(TRegComponentFormDescr(FComponentFormList[I]).ClassIID, ClassIID) and
       AnsiSameText(TRegComponentFormDescr(FComponentFormList[I]).CallString, CallString) and
      (TRegComponentFormDescr(FComponentFormList[I]).ComponentForm = ComponentForm) then
    begin
      Result := I;
      Break;
    end;
end;

function TideBTRegistry.ExistsComponentForm(const ClassIID: TGUID;
  const CallString: string; ComponentForm: TSHComponentFormClass): Boolean;
begin
  Result := IndexOfComponentForm(ClassIID, CallString, ComponentForm) <> -1;
end;

procedure TideBTRegistry.AddComponentForm(const ClassIID: TGUID;
  const CallString: string; ComponentForm: TSHComponentFormClass);
var
  RegComponentFormDescr: TRegComponentFormDescr;
begin
  if not ExistsComponentForm(ClassIID, CallString, ComponentForm) then
  begin
    RegComponentFormDescr := TRegComponentFormDescr.Create;
    RegComponentFormDescr.ClassIID := ClassIID;
    RegComponentFormDescr.CallString := CallString;
    RegComponentFormDescr.ComponentForm := ComponentForm;
    FComponentFormList.Add(RegComponentFormDescr);
  end;
end;

//procedure TideBTRegistry.RemoveComponentForm(const ClassIID: TGUID;
//  const CallString: string; ComponentForm: TSHComponentFormClass);
//var
//  I: Integer;
//begin
//  I := IndexOfComponentForm(ClassIID, CallString, ComponentForm);
//  if I <> -1 then FComponentFormList.Delete(I);
//end;

function TideBTRegistry.IndexOfPropertyEditor(const ClassIID: TGUID;
  const PropertyName: string; PropertyEditor: TSHPropertyEditorClass): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(FPropertyEditorList.Count) do
    if IsEqualGUID(TRegPropertyEditorDescr(FPropertyEditorList[I]).ClassIID, ClassIID) and
       AnsiSameText(TRegPropertyEditorDescr(FPropertyEditorList[I]).PropertyName, PropertyName) and
      (TRegPropertyEditorDescr(FPropertyEditorList[I]).PropertyEditor = PropertyEditor) then
    begin
      Result := I;
      Break;
    end;
end;

function TideBTRegistry.ExistsPropertyEditor(const ClassIID: TGUID;
  const PropertyName: string; PropertyEditor: TSHPropertyEditorClass): Boolean;
begin
  Result := IndexOfPropertyEditor(ClassIID, PropertyName, PropertyEditor) <> -1;
end;

procedure TideBTRegistry.AddPropertyEditor(const ClassIID: TGUID;
  const PropertyName: string; PropertyEditor: TSHPropertyEditorClass);
var
  RegPropertyEditorDescr: TRegPropertyEditorDescr;
begin
  if not ExistsPropertyEditor(ClassIID, PropertyName, PropertyEditor) then
  begin
    RegPropertyEditorDescr := TRegPropertyEditorDescr.Create;
    RegPropertyEditorDescr.ClassIID := ClassIID;
    RegPropertyEditorDescr.PropertyName := PropertyName;
    RegPropertyEditorDescr.PropertyEditor := PropertyEditor;
    FPropertyEditorList.Add(RegPropertyEditorDescr);
  end;
end;

//procedure TideBTRegistry.RemovePropertyEditor(const ClassIID: TGUID;
//  const PropertyName: string; PropertyEditor: TSHPropertyEditorClass);
//var
//  I: Integer;
//begin
//  I := IndexOfPropertyEditor(ClassIID, PropertyName, PropertyEditor);
//  if I <> -1 then FPropertyEditorList.Delete(I)
//end;

//function TideBTRegistry.IndexOfInterface(const Intf: IInterface;
//  const Description: string): Integer;
//begin
//  Result := FInterfaceDescrList.IndexOf(Description);
//end;

//function TideBTRegistry.ExistsInterface(const Intf: IInterface;
//  const Description: string): Boolean;
//begin
//  Result := IndexOfInterface(Intf, Description) <> -1;
//end;

procedure TideBTRegistry.AddInterface(const Intf: IInterface;
  const Description: string);
begin
//  if not ExistsInterface(Intf, Description) then
  FInterfaceDescrList.Insert(FInterfaceList.Add(Intf), Description);
end;

//procedure TideBTRegistry.RemoveInterface(const Intf: IInterface;
//  const Description: string);
//var
//  I: Integer;
//begin
//  I := IndexOfInterface(Intf, Description);
//  if I <> -1 then
//  begin
//    FInterfaceList.Delete(I);
//    FInterfaceDescrList.Delete(I);
//  end;
//end;

procedure TideBTRegistry.RegisterLibrary(const FileName: string);
begin
  AddLibrary(FileName);
end;

procedure TideBTRegistry.UnRegisterLibrary(const FileName: string);
begin
  RemoveLibrary(FileName);
end;

procedure TideBTRegistry.RegisterPackage(const FileName: string);
begin
  AddPackage(FileName);
  _InitializePackages;
end;

procedure TideBTRegistry.UnRegisterPackage(const FileName: string);
begin
  RemovePackage(FileName);
end;

procedure TideBTRegistry.RegisterComponents(ComponentClasses: array of TSHComponentClass);
var
  I: Integer;
begin
  for I := Low(ComponentClasses) to High(ComponentClasses) do
  begin
    if Assigned(ComponentClasses[I]) then
    begin
      if not ExistsComponent(ComponentClasses[I]) then
      begin
        AddComponent(ComponentClasses[I]);
        if Supports(ComponentClasses[I], ISHDemon) then FDemonList.Add(ComponentClasses[I].Create(nil));
       if Supports(ComponentClasses[I], ISHBranchInfo) then
            FBranchList.Insert(0, FDemonList.Last);
      end;
    end;
  end;
end;

procedure TideBTRegistry.RegisterComponentForm(const ClassIID: TGUID;
  const CallString: string; ComponentForm: TSHComponentFormClass);
begin
  AddComponentForm(ClassIID, CallString, ComponentForm);
end;

procedure TideBTRegistry.RegisterPropertyEditor(const ClassIID: TGUID;
  const PropertyName: string; PropertyEditor: TSHPropertyEditorClass);
begin
  AddPropertyEditor(ClassIID, PropertyName, PropertyEditor);
end;

procedure TideBTRegistry.RegisterImage(const StringIID, FileName: string);
var
  I: Integer;
begin
//  I := FImageIIDList.IndexOf(AnsiUpperCase(StringIID));
//  if I <> -1 then FImageIIDList.Delete(I);

  I := FImageFileList.IndexOf(AnsiUpperCase(FileName));
  if I <> -1 then
    FImageIIDList.AddObject(AnsiUpperCase(StringIID), TObject(FImageFileList.Objects[I]));
end;

procedure TideBTRegistry.RegisterInterface(const Intf: IInterface;
  const Description: string);
begin
  AddInterface(Intf, Description);
end;

procedure TideBTRegistry.LoadLibrariesFromFile;
var
  TmpList: TStringList;
  I{, J}: Integer;
  f :string;
begin
  TmpList := TStringList.Create;
  try
    f :=GetFilePath(SFileConfig);
    if FileExists(f) then
    begin
      LoadStringsFromFile(f, SSectionLibraries, TmpList);
      FLibraryList.Clear;
      for I := 0 to Pred(TmpList.Count) do
      begin
        try
        {J := }AddLibrary(DecodeAppPath(TmpList.Values[TmpList.Names[I]]));
//        if J = 0 then DeleteKeyInFile(SFileConfig, SSectionLibraries, TmpList.Names[I]);
        except
          Continue;
        end;
      end;
    end;
  finally
    TmpList.Free;
  end;
end;

procedure TideBTRegistry.SaveLibrariesToFile;
var
  TmpList: TStringList;
  I: Integer;
  f:string;
begin
  TmpList := TStringList.Create;
  try
    f:=GetFilePath(SFileConfig);
    for I := 0 to Pred(FLibraryList.Count) do
      TmpList.Add(Format('%s=%s', [TRegLibraryDescr(FLibraryList[I]).Description, EncodeAppPath(TRegLibraryDescr(FLibraryList[I]).FileName)]));
    SaveStringsToFile(f, SSectionLibraries, TmpList,True);
  finally
    TmpList.Free;
  end;
end;

function TideBTRegistry.GetLibraryDescription(ModuleHandle: HModule): string;
type
  TLibraryDescription = function(): PChar;
var
  Description: TLibraryDescription;
begin
  @Description := GetProcAddress(ModuleHandle, 'GetSQLHammerLibraryDescription');
  if Assigned(Description) then
    Result := AnsiString(Description);
  if Length(Result)  = 0 then
    Result := Format('%s', [SNone]);
end;

function TideBTRegistry.InitializeLibraryA(const FileName: string): HModule;
begin
  Result := 0;
  try
    Result := LoadLibrary(PChar(FileName));
    if Pos(UpperCase('BlazeTop'), AnsiUpperCase(GetLibraryDescription(Result))) = 0 then
      ShowMsg(Format(SLibraryCantLoad, [FileName]) + sLineBreak + SMustBeDescription, mtWarning);
  except
    ShowMsg(Format(SLibraryCantLoad, [FileName]), mtError);
  end;
end;

//procedure TideBTRegistry.InitializeLibraries;
//begin
// TODO
//end;

procedure TideBTRegistry.LoadPackagesFromFile;
var
  TmpList: TStringList;
  I{, J}: Integer;
  f:string;
begin
  TmpList := TStringList.Create;
  try
    f:=GetFilePath(SFileConfig);
    if FileExists(f) then
    begin
      LoadStringsFromFile(f, SSectionPackages, TmpList);
      FPackageList.Clear;
      for I := 0 to Pred(TmpList.Count) do
      begin
        try
        {J := }AddPackage(DecodeAppPath(TmpList.Values[TmpList.Names[I]]));
//        if J = 0 then DeleteKeyInFile(SFileConfig, SSectionPackages, TmpList.Names[I]);
        except
          Continue;
        end;
      end;



      if Assigned(SplashForm) then SplashForm.SplashTrace('');
      if Assigned(SplashForm) then SplashForm.SplashTrace('Initializing Packages...');
      _InitializePackages;
      if Assigned(SplashForm) then SplashForm.SplashTraceDone;
    end;
  finally
    TmpList.Free;
  end;
end;

procedure TideBTRegistry.SavePackagesToFile;
var
  TmpList: TStringList;
  I: Integer;
  f:string;
begin
  TmpList := TStringList.Create;
  try
    f:=GetFilePath(SFileConfig);
    for I := 0 to Pred(FPackageList.Count) do
      TmpList.Add(Format('%s=%s', [TRegPackageDescr(FPackageList[I]).Description, EncodeAppPath(TRegPackageDescr(FPackageList[I]).FileName)]));
    SaveStringsToFile(f, SSectionPackages, TmpList,True);
  finally
    TmpList.Free;
  end;
end;

function TideBTRegistry.InitializePackageA(const FileName: string): HModule;
begin
  Result := Pos(AnsiUpperCase('BlazeTop'), AnsiUpperCase(SysUtils.GetPackageDescription(PChar(FileName))));
  if Result = 0 then
  begin
    ShowMsg(Format(SPackageCantLoad, [FileName]) + sLineBreak + SMustBeDescription, mtWarning);
    Exit;
  end;

  Result := _LoadPackage(FileName);
end;

//procedure TideBTRegistry.InitializePackages;
//begin
//  EnumModules(ForEachModule, nil);
//end;

(*
procedure TideBTRegistry.LoadImagesFromModule(Module: HModule);
//var
//  I: Integer;
//  Bmp: TBitmap;
//  Pixel: Integer;
begin

//Pixel := Bmp.Canvas.ClipRect.Top - Bmp.Canvas.ClipRect.Bottom;
  Pixel := 15;
  if Assigned(MainIntf) then
  begin
    Bmp := TBitmap.Create;
    try
      //
      // Загрузка глифов для компонентов
      //
      for I := 0 to Pred(FComponentList.Count) do
      begin
        if TRegComponentDescr(FComponentList[I]).ImageIndex = IMG_DEFAULT then
        begin
          Bmp.Handle := LoadBitmap(Module, PChar(AnsiUpperCase(TRegComponentDescr(FComponentList[I]).ComponentClass.ClassName)));
          if Bmp.Handle <> 0 then
            TRegComponentDescr(FComponentList[I]).ImageIndex := MainIntf.ImageList.AddMasked(Bmp, Bmp.Canvas.Pixels[0, Pixel]);
        end;
      end;
      //
      // Загрузка глифов для форм
      //
      for I := 0 to Pred(FComponentFormList.Count) do
      begin
        if TRegComponentFormDescr(FComponentFormList[I]).ImageIndex = IMG_FORM_SIMPLE then
        begin
          Bmp.Handle := LoadBitmap(Module, PChar('FORM_' + AnsiUpperCase(AnsiReplaceText(TRegComponentFormDescr(FComponentFormList[I]).CallString, ' ', '_'))));
          if Bmp.Handle <> 0 then
            TRegComponentFormDescr(FComponentFormList[I]).ImageIndex := MainIntf.ImageList.AddMasked(Bmp, Bmp.Canvas.Pixels[0, Pixel]);
        end;
      end;

      //
      // Загрузка глифов для акшенов
      //
      for I := 0 to Pred(MainForm.ActionList1.ActionCount) do
      begin
        if TAction(MainForm.ActionList1.Actions[I]).ImageIndex = IMG_DEFAULT then
        begin
          Bmp.Handle := LoadBitmap(Module, PChar(AnsiUpperCase(MainForm.ActionList1.Actions[I].ClassName)));
          if Bmp.Handle <> 0 then
            TAction(MainForm.ActionList1.Actions[I]).ImageIndex := MainIntf.ImageList.AddMasked(Bmp, Bmp.Canvas.Pixels[0, Pixel]);
        end;
      end;

    finally
      Bmp.Free;
    end;
  end;
end;
*)

procedure TideBTRegistry.LoadOptionsFromFile;
var
  I: Integer;
  f:string;
begin
  f:=GetFilePath(SFileEnvironment);
  for I := 0 to Pred(FDemonList.Count) do
    if Supports(FDemonList[I], ISHComponentOptions) then
      ReadPropValuesFromFile(f, SSectionOptions, FDemonList[I]);
end;

procedure TideBTRegistry.SaveOptionsToFile;
var
  I: Integer;
  f:string;
  PropNameValues:TStrings;
begin
  f:=GetFilePath(SFileEnvironment);
  PropNameValues := TStringList.Create;
  try
   for I := 0 to Pred(FDemonList.Count) do
    if Supports(FDemonList[I], ISHComponentOptions) then
      GetPropValues(FDemonList[I], FDemonList[I].ClassName, PropNameValues);
   SaveStringsToFile(f, SSectionOptions, PropNameValues,True);   
  finally
    FreeAndNil(PropNameValues);
  end;

end;

procedure TideBTRegistry.LoadOptionsFromList;
var
  I: Integer;
begin
  for I := 0 to Pred(FDemonList.Count) do
    if Supports(FDemonList[I], ISHComponentOptions) then
      SetPropValues(FDemonList[I], FDemonList[I].ClassName, FPropSavedList);
end;

procedure TideBTRegistry.SaveOptionsToList;
var
  I: Integer;
begin
  FPropSavedList.Clear;
  for I := 0 to Pred(FDemonList.Count) do
    if Supports(FDemonList[I], ISHComponentOptions) then
      GetPropValues(FDemonList[I], FDemonList[I].ClassName, FPropSavedList);
end;

procedure TideBTRegistry.LoadImagesFromFile;
const
  FILE_EXT = '*.bmp';
var
  SearchRec: TSearchRec;
  FileAttrs: Integer;
  Bmp: TBitmap;
  Pixel: Integer;
begin
  if SysUtils.DirectoryExists(GetDirPath(SDirImages)) then
  begin
    FileAttrs := 0;
    Bmp := TBitmap.Create;
    Pixel := 15;
    try
      if FindFirst(Format('%s%s', [GetDirPath(SDirImages), FILE_EXT]), FileAttrs, SearchRec) = 0 then
      begin
        repeat
          Bmp.LoadFromFile(Format('%s%s', [GetDirPath(SDirImages), SearchRec.Name]));
          if Bmp.Handle <> 0 then
            FImageFileList.AddObject(AnsiUpperCase(SearchRec.Name), TObject(MainIntf.ImageList.AddMasked(Bmp, Bmp.Canvas.Pixels[0, Pixel])));
        until FindNext(SearchRec) <> 0;
        FindClose(SearchRec);
      end;
    finally
      Bmp.Free;
    end;
  end;
end;

end.



