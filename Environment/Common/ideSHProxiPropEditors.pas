unit ideSHProxiPropEditors;

interface

uses
  DesignIntf, SysUtils, Classes, TypInfo, Controls, Graphics, ELPropInsp,
  SHDesignIntf;

type

  TSHELPropEditor = class(TELPropEditor, ISHPropertyEditorInfo,
    ISHProperty)
  private
    FUserEditor: TSHPropertyEditor;
    FUserEditorChecked: Boolean;
    function GetUserEditor: TSHPropertyEditor;
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { ISHPropertyEditorInfo }
    function ISHPropertyEditorInfo.GetInstance = IGetInstance;
    function IGetInstance: TObject;
    function ISHPropertyEditorInfo.GetPropInfo = IGetPropInfo;
    function IGetPropInfo: PPropInfo;
    function ISHPropertyEditorInfo.GetPropTypeInfo = IGetPropTypeInfo;
    function IGetPropTypeInfo: PTypeInfo;
    { ISHProperty }
    function ISHProperty.GetAttributes = IGetAttributes;
    function ISHProperty.GetValue = IGetValue;
    procedure ISHProperty.GetValues = IGetValues;
    procedure ISHProperty.SetValue = ISetValue;
    procedure ISHProperty.Edit = IEdit;
    function IGetAttributes: TPropertyAttributes;
    function IGetValue: string;
    procedure IGetValues(AValues: TStrings);
    procedure ISetValue(const Value: string);
    procedure IEdit;
    {override}
    function GetAttrs: TELPropAttrs; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
    property UserEditor: TSHPropertyEditor read GetUserEditor;
  public
    constructor Create(ADesigner: Pointer; APropCount: Integer); override;
    destructor Destroy; override;
  end;

  TSHELStringPropEditor = class(TELStringPropEditor, ISHPropertyEditorInfo,
    ISHProperty)
  private
    FUserEditor: TSHPropertyEditor;
    FUserEditorChecked: Boolean;
    function GetUserEditor: TSHPropertyEditor;
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { ISHPropertyEditorInfo }
    function ISHPropertyEditorInfo.GetInstance = IGetInstance;
    function IGetInstance: TObject;
    function ISHPropertyEditorInfo.GetPropInfo = IGetPropInfo;
    function IGetPropInfo: PPropInfo;
    function ISHPropertyEditorInfo.GetPropTypeInfo = IGetPropTypeInfo;
    function IGetPropTypeInfo: PTypeInfo;    
    { ISHProperty }
    function ISHProperty.GetAttributes = IGetAttributes;
    function ISHProperty.GetValue = IGetValue;
    procedure ISHProperty.GetValues = IGetValues;
    procedure ISHProperty.SetValue = ISetValue;
    procedure ISHProperty.Edit = IEdit;
    function IGetAttributes: TPropertyAttributes;
    function IGetValue: string;
    procedure IGetValues(AValues: TStrings);
    procedure ISetValue(const Value: string);
    procedure IEdit;
    {override}
    function GetAttrs: TELPropAttrs; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
    property UserEditor: TSHPropertyEditor read GetUserEditor;
  public
    constructor Create(ADesigner: Pointer; APropCount: Integer); override;
    destructor Destroy; override;
  end;

  TSHELStringsPropEditor = class(TELStringsPropEditor, ISHPropertyEditorInfo,
    ISHProperty)
  private
    FUserEditor: TSHPropertyEditor;
    FUserEditorChecked: Boolean;
    function GetUserEditor: TSHPropertyEditor;
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { ISHPropertyEditorInfo }
    function ISHPropertyEditorInfo.GetInstance = IGetInstance;
    function IGetInstance: TObject;
    function ISHPropertyEditorInfo.GetPropInfo = IGetPropInfo;
    function IGetPropInfo: PPropInfo;
    function ISHPropertyEditorInfo.GetPropTypeInfo = IGetPropTypeInfo;
    function IGetPropTypeInfo: PTypeInfo;    
    { ISHProperty }
    function ISHProperty.GetAttributes = IGetAttributes;
    function ISHProperty.GetValue = IGetValue;
    procedure ISHProperty.GetValues = IGetValues;
    procedure ISHProperty.SetValue = ISetValue;
    procedure ISHProperty.Edit = IEdit;
    function IGetAttributes: TPropertyAttributes;
    function IGetValue: string;
    procedure IGetValues(AValues: TStrings);
    procedure ISetValue(const Value: string);
    procedure IEdit;
    {override}
    function GetAttrs: TELPropAttrs; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
    property UserEditor: TSHPropertyEditor read GetUserEditor;
  public
    constructor Create(ADesigner: Pointer; APropCount: Integer); override;
    destructor Destroy; override;
  end;

  TSHELIntegerPropEditor = class(TELIntegerPropEditor, ISHPropertyEditorInfo,
    ISHProperty)
  private
    FUserEditor: TSHPropertyEditor;
    FUserEditorChecked: Boolean;
    function GetUserEditor: TSHPropertyEditor;
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { ISHPropertyEditorInfo }
    function ISHPropertyEditorInfo.GetInstance = IGetInstance;
    function IGetInstance: TObject;
    function ISHPropertyEditorInfo.GetPropInfo = IGetPropInfo;
    function IGetPropInfo: PPropInfo;
    function ISHPropertyEditorInfo.GetPropTypeInfo = IGetPropTypeInfo;
    function IGetPropTypeInfo: PTypeInfo;    
    { ISHProperty }
    function ISHProperty.GetAttributes = IGetAttributes;
    function ISHProperty.GetValue = IGetValue;
    procedure ISHProperty.GetValues = IGetValues;
    procedure ISHProperty.SetValue = ISetValue;
    procedure ISHProperty.Edit = IEdit;
    function IGetAttributes: TPropertyAttributes;
    function IGetValue: string;
    procedure IGetValues(AValues: TStrings);
    procedure ISetValue(const Value: string);
    procedure IEdit;
    {override}
    function GetAttrs: TELPropAttrs; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
    property UserEditor: TSHPropertyEditor read GetUserEditor;
  public
    constructor Create(ADesigner: Pointer; APropCount: Integer); override;
    destructor Destroy; override;
  end;

  TSHELClassPropEditor = class(TELClassPropEditor, ISHPropertyEditorInfo,
    ISHProperty)
  private
    FUserEditor: TSHPropertyEditor;
    FUserEditorChecked: Boolean;
    function GetUserEditor: TSHPropertyEditor;
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { ISHPropertyEditorInfo }
    function ISHPropertyEditorInfo.GetInstance = IGetInstance;
    function IGetInstance: TObject;
    function ISHPropertyEditorInfo.GetPropInfo = IGetPropInfo;
    function IGetPropInfo: PPropInfo;
    function ISHPropertyEditorInfo.GetPropTypeInfo = IGetPropTypeInfo;
    function IGetPropTypeInfo: PTypeInfo;    
    { ISHProperty }
    function ISHProperty.GetAttributes = IGetAttributes;
    function ISHProperty.GetValue = IGetValue;
    procedure ISHProperty.GetValues = IGetValues;
    procedure ISHProperty.SetValue = ISetValue;
    procedure ISHProperty.Edit = IEdit;
    function IGetAttributes: TPropertyAttributes;
    function IGetValue: string;
    procedure IGetValues(AValues: TStrings);
    procedure ISetValue(const Value: string);
    procedure IEdit;
    {override}
    function GetAttrs: TELPropAttrs; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
    property UserEditor: TSHPropertyEditor read GetUserEditor;
  public
    constructor Create(ADesigner: Pointer; APropCount: Integer); override;
    destructor Destroy; override;
  end;

  TSHELInt64PropEditor = class(TELInt64PropEditor, ISHPropertyEditorInfo,
    ISHProperty)
  private
    FUserEditor: TSHPropertyEditor;
    FUserEditorChecked: Boolean;
    function GetUserEditor: TSHPropertyEditor;
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { ISHPropertyEditorInfo }
    function ISHPropertyEditorInfo.GetInstance = IGetInstance;
    function IGetInstance: TObject;
    function ISHPropertyEditorInfo.GetPropInfo = IGetPropInfo;
    function IGetPropInfo: PPropInfo;
    function ISHPropertyEditorInfo.GetPropTypeInfo = IGetPropTypeInfo;
    function IGetPropTypeInfo: PTypeInfo;    
    { ISHProperty }
    function ISHProperty.GetAttributes = IGetAttributes;
    function ISHProperty.GetValue = IGetValue;
    procedure ISHProperty.GetValues = IGetValues;
    procedure ISHProperty.SetValue = ISetValue;
    procedure ISHProperty.Edit = IEdit;
    function IGetAttributes: TPropertyAttributes;
    function IGetValue: string;
    procedure IGetValues(AValues: TStrings);
    procedure ISetValue(const Value: string);
    procedure IEdit;
    {override}
    function GetAttrs: TELPropAttrs; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
    property UserEditor: TSHPropertyEditor read GetUserEditor;
  public
    constructor Create(ADesigner: Pointer; APropCount: Integer); override;
    destructor Destroy; override;
  end;

  TSHELComponentPropEditor = class(TELComponentPropEditor, ISHPropertyEditorInfo,
    ISHProperty)
  private
    FUserEditor: TSHPropertyEditor;
    FUserEditorChecked: Boolean;
    function GetUserEditor: TSHPropertyEditor;
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { ISHPropertyEditorInfo }
    function ISHPropertyEditorInfo.GetInstance = IGetInstance;
    function IGetInstance: TObject;
    function ISHPropertyEditorInfo.GetPropInfo = IGetPropInfo;
    function IGetPropInfo: PPropInfo;
    function ISHPropertyEditorInfo.GetPropTypeInfo = IGetPropTypeInfo;
    function IGetPropTypeInfo: PTypeInfo;    
    { ISHProperty }
    function ISHProperty.GetAttributes = IGetAttributes;
    function ISHProperty.GetValue = IGetValue;
    procedure ISHProperty.GetValues = IGetValues;
    procedure ISHProperty.SetValue = ISetValue;
    procedure ISHProperty.Edit = IEdit;
    function IGetAttributes: TPropertyAttributes;
    function IGetValue: string;
    procedure IGetValues(AValues: TStrings);
    procedure ISetValue(const Value: string);
    procedure IEdit;
    {override}
    function GetAttrs: TELPropAttrs; override;
    function GetValue: string; override;
    procedure GetValues(AValues: TStrings); override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
    property UserEditor: TSHPropertyEditor read GetUserEditor;
  public
    constructor Create(ADesigner: Pointer; APropCount: Integer); override;
    destructor Destroy; override;
  end;

  //Функцию необходимо использовать во всех TELInspector в событии
  //OnGetEditorClass, при добавлении нового класса прокси-эдитора (наследника
  //от нативного EL эдитра) эту функцию необходимо дорабатывать соответствующим
  //образом
  //такая необходость использования этого события вызвана невозможностью
  //зарегистрировать PropEditor на некоторые типы, например, множества,
  //простые типы
  function BTGetProxiEditorClass(APropertyInspector: TELPropertyInspector;
    AInstance: TPersistent; APropInfo: PPropInfo): TELPropEditorClass;

implementation

function GetUserEditorClass(AInstance: TObject;
  const APropertyName: string): TSHPropertyEditorClass;
var
  I: Integer;
  vDesigner: ISHDesigner;

  ClassPtr: TClass;
  IntfTable: PInterfaceTable;
begin
  if SHSupports(ISHDesigner, vDesigner) then
  begin
    ClassPtr := AInstance.ClassType;
    while ClassPtr <> nil do
    begin
      IntfTable := ClassPtr.GetInterfaceTable;
      if IntfTable <> nil then
        for I := Pred(IntfTable.EntryCount) downto 0 do
        begin
          Result := vDesigner.GetPropertyEditor(IntfTable.Entries[I].IID, APropertyName);
          if Assigned(Result) then
            Exit;
        end;
      ClassPtr := ClassPtr.ClassParent;
    end;
  end;
  Result := nil;
end;

function BTGetProxiEditorClass(APropertyInspector: TELPropertyInspector;
  AInstance: TPersistent; APropInfo: PPropInfo): TELPropEditorClass;
var
  LTypeInfo: PTypeInfo;
  vIncludeProp: Boolean;
begin
  LTypeInfo := APropInfo.PropType^;

  if not (((pkProperties in APropertyInspector.PropKinds)
        and (LTypeInfo.Kind in tkProperties))
      or ((pkEvents in APropertyInspector.PropKinds)
        and (LTypeInfo.Kind in tkMethods)))
      or not Assigned(APropInfo.GetProc)
      or (not (pkReadOnly in APropertyInspector.PropKinds)
        and not Assigned(APropInfo.SetProc)
        and (APropInfo.PropType^.Kind <> tkClass))
  then
  begin
    Result := nil;
    Exit;
  end;

  if Assigned(APropertyInspector.OnFilterProp) then
  begin
    vIncludeProp := True;
    APropertyInspector.OnFilterProp(APropertyInspector, AInstance, APropInfo,
      vIncludeProp);
    if not vIncludeProp then
    begin
      Result := nil;
      Exit;
    end;
  end;
  Result := nil;

    if (LTypeInfo = TypeInfo(TComponentName))
       or (LTypeInfo = TypeInfo(TDate))
       or (LTypeInfo = TypeInfo(TTime))
       or (LTypeInfo = TypeInfo(TDateTime))
       or (LTypeInfo = TypeInfo(TCaption))
       or (LTypeInfo = TypeInfo(TColor))
       or (LTypeInfo = TypeInfo(TCursor))
       or (LTypeInfo = TypeInfo(TFontCharset))
       or (LTypeInfo = TypeInfo(TFontName))
       or (LTypeInfo = TypeInfo(TImeName))

       or (LTypeInfo = TypeInfo(TFont))
       or ((LTypeInfo.Kind = tkClass) and
         GetTypeData(LTypeInfo).ClassType.InheritsFrom(TFont))

       or (LTypeInfo = TypeInfo(TModalResult))
       or (LTypeInfo = TypeInfo(TPenStyle))
       or (LTypeInfo = TypeInfo(TBrushStyle))
       or (LTypeInfo = TypeInfo(TTabOrder))
       or (LTypeInfo = TypeInfo(TShortCut)) then
         Exit;

  case LTypeInfo.Kind of
    tkInteger:        Result := TSHELIntegerPropEditor;
//    tkChar:           AEditorClass := TELCharPropEditor;
//    tkEnumeration:    AEditorClass := TELEnumPropEditor;
//    tkFloat:          AEditorClass := TELFloatPropEditor;
    tkString,
    tkLString,
    tkWString:        Result := TSHELStringPropEditor;
//    tkSet:            AEditorClass := TELSetPropEditor;
    tkClass:
      begin
        if (LTypeInfo = TypeInfo(TStrings))
            or GetTypeData(LTypeInfo).ClassType.InheritsFrom(TStrings) then
              Result := TSHELStringsPropEditor
        else
          if (LTypeInfo = TypeInfo(TComponent))
            or GetTypeData(LTypeInfo).ClassType.InheritsFrom(TComponent) then
            Result := TSHELComponentPropEditor
          else
            Result := TSHELClassPropEditor;
      end;
    tkMethod: Result := TSHELPropEditor;
//    tkVariant:        AEditorClass := TELVariantPropEditor;
    tkInt64:          Result := TSHELInt64PropEditor;
//    else
//                      AEditorClass := TELPropEditor;
  end;
end;

{ TSHELPropEditor }

constructor TSHELPropEditor.Create(ADesigner: Pointer;
  APropCount: Integer);
begin
  inherited;
  FUserEditorChecked := False;
  FUserEditor := nil;
end;

destructor TSHELPropEditor.Destroy;
begin
  if Assigned(FUserEditor) then
    FUserEditor.Free;
  inherited;
end;

procedure TSHELPropEditor.Edit;
begin
  if UserEditor <> nil then
    FUserEditor.Edit
  else
    inherited Edit;
end;

function TSHELPropEditor.GetAttrs: TELPropAttrs;
var
  UserAttributes: TPropertyAttributes;
  InheritedAttrs: TELPropAttrs;
begin
  if UserEditor <> nil then
  begin
    UserAttributes := FUserEditor.GetAttributes;
    InheritedAttrs := (inherited GetAttrs);
    Result := [];
    if paValueList in UserAttributes then
      Include(Result, praValueList);
    if paSubProperties in UserAttributes then
      Include(Result, praSubProperties);
    if paDialog in UserAttributes then
      Include(Result, praDialog);
    if paMultiSelect in UserAttributes then
      Include(Result, praMultiSelect);
    if paAutoUpdate in UserAttributes then
      Include(Result, praAutoUpdate);
    if paSortList in UserAttributes then
      Include(Result, praSortList);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paVolatileSubProperties in UserAttributes then
      Include(Result, praVolatileSubProperties);
    if paNotNestable in UserAttributes then
      Include(Result, praNotNestable);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if praOwnerDrawValues in InheritedAttrs then
      Include(Result, praOwnerDrawValues);
    if praComponentRef in InheritedAttrs then
      Include(Result, praComponentRef);
  end
  else
    Result := inherited GetAttrs;
end;

function TSHELPropEditor.GetUserEditor: TSHPropertyEditor;
var
  PropertyEditorClass: TSHPropertyEditorClass;
  vInstance: TObject;
begin
  Result := nil;
  if Assigned(FUserEditor) then
    Result := FUserEditor
  else
  begin
    vInstance := IGetInstance;
    if (not FUserEditorChecked) and Assigned(vInstance) then
    begin
      PropertyEditorClass :=
        GetUserEditorClass(vInstance, GetPropName);
      if Assigned(PropertyEditorClass) then
        FUserEditor := PropertyEditorClass.Create(Self);
      FUserEditorChecked := True;
    end;
  end;
end;

function TSHELPropEditor.GetValue: string;
begin
  if UserEditor <> nil then
    Result := FUserEditor.GetValue
  else
    Result := inherited GetValue;
end;

procedure TSHELPropEditor.GetValues(AValues: TStrings);
begin
  if UserEditor <> nil then
    FUserEditor.GetValues(AValues)
  else
    inherited GetValues(AValues);
end;

procedure TSHELPropEditor.IEdit;
begin
  inherited Edit;
end;

function TSHELPropEditor.IGetAttributes: TPropertyAttributes;
var
  InheritedAttrs: TELPropAttrs;
begin
  InheritedAttrs := inherited GetAttrs;
  Result := [];
  if praValueList in InheritedAttrs then
    Include(Result, paValueList);
  if praSubProperties in InheritedAttrs then
    Include(Result, paSubProperties);
  if praDialog in InheritedAttrs then
    Include(Result, paDialog);
  if praMultiSelect in InheritedAttrs then
    Include(Result, paMultiSelect);
  if praAutoUpdate in InheritedAttrs then
    Include(Result, paAutoUpdate);
  if praSortList in InheritedAttrs then
    Include(Result, paSortList);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praVolatileSubProperties in InheritedAttrs then
    Include(Result, paVolatileSubProperties);
  if praNotNestable in InheritedAttrs then
    Include(Result, paNotNestable);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
end;

function TSHELPropEditor.IGetInstance: TObject;
begin
  Result := GetInstance(0);
end;

function TSHELPropEditor.IGetPropInfo: PPropInfo;
begin
  Result := GetPropInfo(0);
end;

function TSHELPropEditor.IGetPropTypeInfo: PTypeInfo;
begin
  Result := PropTypeInfo;
end;

function TSHELPropEditor.IGetValue: string;
begin
  Result := inherited GetValue;
end;

procedure TSHELPropEditor.IGetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
end;

procedure TSHELPropEditor.ISetValue(const Value: string);
begin
  inherited SetValue(Value);
end;

procedure TSHELPropEditor.SetValue(const Value: string);
begin
  if UserEditor <> nil then
    FUserEditor.SetValue(Value)
  else
    inherited SetValue(Value);
end;

function TSHELPropEditor.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TSHELPropEditor._AddRef: Integer;
begin
  Result := -1;
end;

function TSHELPropEditor._Release: Integer;
begin
  Result := -1;
end;

{ TSHELStringPropEditor }

constructor TSHELStringPropEditor.Create(ADesigner: Pointer;
  APropCount: Integer);
begin
  inherited;
  FUserEditorChecked := False;
  FUserEditor := nil;
end;

destructor TSHELStringPropEditor.Destroy;
begin
  if Assigned(FUserEditor) then
    FUserEditor.Free;
  inherited;
end;

procedure TSHELStringPropEditor.Edit;
begin
  if UserEditor <> nil then
    FUserEditor.Edit
  else
    inherited Edit;
end;

function TSHELStringPropEditor.GetAttrs: TELPropAttrs;
var
  UserAttributes: TPropertyAttributes;
  InheritedAttrs: TELPropAttrs;
begin
  if UserEditor <> nil then
  begin
    UserAttributes := FUserEditor.GetAttributes;
    InheritedAttrs := (inherited GetAttrs);
    Result := [];
    if paValueList in UserAttributes then
      Include(Result, praValueList);
    if paSubProperties in UserAttributes then
      Include(Result, praSubProperties);
    if paDialog in UserAttributes then
      Include(Result, praDialog);
    if paMultiSelect in UserAttributes then
      Include(Result, praMultiSelect);
    if paAutoUpdate in UserAttributes then
      Include(Result, praAutoUpdate);
    if paSortList in UserAttributes then
      Include(Result, praSortList);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paVolatileSubProperties in UserAttributes then
      Include(Result, praVolatileSubProperties);
    if paNotNestable in UserAttributes then
      Include(Result, praNotNestable);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);

    if praOwnerDrawValues in InheritedAttrs then
      Include(Result, praOwnerDrawValues);
    if praComponentRef in InheritedAttrs then
      Include(Result, praComponentRef);
  end
  else
    Result := inherited GetAttrs;
end;

function TSHELStringPropEditor.GetUserEditor: TSHPropertyEditor;
var
  PropertyEditorClass: TSHPropertyEditorClass;
  vInstance: TObject;
begin
  Result := nil;
  if Assigned(FUserEditor) then
    Result := FUserEditor
  else
  begin
    vInstance := IGetInstance;
    if (not FUserEditorChecked) and Assigned(vInstance) then
    begin
      PropertyEditorClass :=
        GetUserEditorClass(vInstance, GetPropName);
      if Assigned(PropertyEditorClass) then
        FUserEditor := PropertyEditorClass.Create(Self);
      FUserEditorChecked := True;
    end;
  end;
end;

function TSHELStringPropEditor.GetValue: string;
begin
  if UserEditor <> nil then
    Result := FUserEditor.GetValue
  else
    Result := inherited GetValue;
end;

procedure TSHELStringPropEditor.GetValues(AValues: TStrings);
begin
  if UserEditor <> nil then
    FUserEditor.GetValues(AValues)
  else
    inherited GetValues(AValues);
end;

procedure TSHELStringPropEditor.IEdit;
begin
  inherited Edit;
end;

function TSHELStringPropEditor.IGetAttributes: TPropertyAttributes;
var
  InheritedAttrs: TELPropAttrs;
begin
  InheritedAttrs := inherited GetAttrs;
  Result := [];
  if praValueList in InheritedAttrs then
    Include(Result, paValueList);
  if praSubProperties in InheritedAttrs then
    Include(Result, paSubProperties);
  if praDialog in InheritedAttrs then
    Include(Result, paDialog);
  if praMultiSelect in InheritedAttrs then
    Include(Result, paMultiSelect);
  if praAutoUpdate in InheritedAttrs then
    Include(Result, paAutoUpdate);
  if praSortList in InheritedAttrs then
    Include(Result, paSortList);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praVolatileSubProperties in InheritedAttrs then
    Include(Result, paVolatileSubProperties);
  if praNotNestable in InheritedAttrs then
    Include(Result, paNotNestable);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
end;

function TSHELStringPropEditor.IGetInstance: TObject;
begin
  Result := GetInstance(0);
end;

function TSHELStringPropEditor.IGetPropInfo: PPropInfo;
begin
  Result := GetPropInfo(0);
end;

function TSHELStringPropEditor.IGetPropTypeInfo: PTypeInfo;
begin
  Result := PropTypeInfo;
end;

function TSHELStringPropEditor.IGetValue: string;
begin
  Result := inherited GetValue;
end;

procedure TSHELStringPropEditor.IGetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
end;

procedure TSHELStringPropEditor.ISetValue(const Value: string);
begin
  inherited SetValue(Value);
end;

procedure TSHELStringPropEditor.SetValue(const Value: string);
begin
  if UserEditor <> nil then
    FUserEditor.SetValue(Value)
  else
    inherited SetValue(Value);
end;

function TSHELStringPropEditor.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TSHELStringPropEditor._AddRef: Integer;
begin
  Result := -1;
end;

function TSHELStringPropEditor._Release: Integer;
begin
  Result := -1;
end;

{ TSHELStringsPropEditor }

constructor TSHELStringsPropEditor.Create(ADesigner: Pointer;
  APropCount: Integer);
begin
  inherited;
  FUserEditorChecked := False;
  FUserEditor := nil;
end;

destructor TSHELStringsPropEditor.Destroy;
begin
  if Assigned(FUserEditor) then
    FUserEditor.Free;
  inherited;
end;

procedure TSHELStringsPropEditor.Edit;
begin
  if UserEditor <> nil then
    FUserEditor.Edit
  else
    inherited Edit;
end;

function TSHELStringsPropEditor.GetAttrs: TELPropAttrs;
var
  UserAttributes: TPropertyAttributes;
  InheritedAttrs: TELPropAttrs;
begin
  if UserEditor <> nil then
  begin
    UserAttributes := FUserEditor.GetAttributes;
    InheritedAttrs := (inherited GetAttrs);
    Result := [];
    if paValueList in UserAttributes then
      Include(Result, praValueList);
    if paSubProperties in UserAttributes then
      Include(Result, praSubProperties);
    if paDialog in UserAttributes then
      Include(Result, praDialog);
    if paMultiSelect in UserAttributes then
      Include(Result, praMultiSelect);
    if paAutoUpdate in UserAttributes then
      Include(Result, praAutoUpdate);
    if paSortList in UserAttributes then
      Include(Result, praSortList);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paVolatileSubProperties in UserAttributes then
      Include(Result, praVolatileSubProperties);
    if paNotNestable in UserAttributes then
      Include(Result, praNotNestable);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);

    if praOwnerDrawValues in InheritedAttrs then
      Include(Result, praOwnerDrawValues);
    if praComponentRef in InheritedAttrs then
      Include(Result, praComponentRef);
  end
  else
    Result := inherited GetAttrs;
end;

function TSHELStringsPropEditor.GetUserEditor: TSHPropertyEditor;
var
  PropertyEditorClass: TSHPropertyEditorClass;
  vInstance: TObject;
begin
  Result := nil;
  if Assigned(FUserEditor) then
    Result := FUserEditor
  else
  begin
    vInstance := IGetInstance;
    if (not FUserEditorChecked) and Assigned(vInstance) then
    begin
      PropertyEditorClass :=
        GetUserEditorClass(vInstance, GetPropName);
      if Assigned(PropertyEditorClass) then
        FUserEditor := PropertyEditorClass.Create(Self);
      FUserEditorChecked := True;
    end;
  end;
end;

function TSHELStringsPropEditor.GetValue: string;
begin
  if UserEditor <> nil then
    Result := FUserEditor.GetValue
  else
    Result := inherited GetValue;
end;

procedure TSHELStringsPropEditor.GetValues(AValues: TStrings);
begin
  if UserEditor <> nil then
    FUserEditor.GetValues(AValues)
  else
    inherited GetValues(AValues);
end;

procedure TSHELStringsPropEditor.IEdit;
begin
  inherited Edit;
end;

function TSHELStringsPropEditor.IGetAttributes: TPropertyAttributes;
var
  InheritedAttrs: TELPropAttrs;
begin
  InheritedAttrs := inherited GetAttrs;
  Result := [];
  if praValueList in InheritedAttrs then
    Include(Result, paValueList);
  if praSubProperties in InheritedAttrs then
    Include(Result, paSubProperties);
  if praDialog in InheritedAttrs then
    Include(Result, paDialog);
  if praMultiSelect in InheritedAttrs then
    Include(Result, paMultiSelect);
  if praAutoUpdate in InheritedAttrs then
    Include(Result, paAutoUpdate);
  if praSortList in InheritedAttrs then
    Include(Result, paSortList);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praVolatileSubProperties in InheritedAttrs then
    Include(Result, paVolatileSubProperties);
  if praNotNestable in InheritedAttrs then
    Include(Result, paNotNestable);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
end;

function TSHELStringsPropEditor.IGetInstance: TObject;
begin
  Result := GetInstance(0);
end;

function TSHELStringsPropEditor.IGetPropInfo: PPropInfo;
begin
  Result := GetPropInfo(0);
end;

function TSHELStringsPropEditor.IGetPropTypeInfo: PTypeInfo;
begin
  Result := PropTypeInfo;
end;

function TSHELStringsPropEditor.IGetValue: string;
begin
  Result := inherited GetValue;
end;

procedure TSHELStringsPropEditor.IGetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
end;

procedure TSHELStringsPropEditor.ISetValue(const Value: string);
begin
  inherited SetValue(Value);
end;

procedure TSHELStringsPropEditor.SetValue(const Value: string);
begin
  if UserEditor <> nil then
    FUserEditor.SetValue(Value)
  else
    inherited SetValue(Value);
end;

function TSHELStringsPropEditor.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TSHELStringsPropEditor._AddRef: Integer;
begin
  Result := -1;
end;

function TSHELStringsPropEditor._Release: Integer;
begin
  Result := -1;
end;

{ TSHELIntegerPropEditor }

constructor TSHELIntegerPropEditor.Create(ADesigner: Pointer;
  APropCount: Integer);
begin
  inherited;
  FUserEditorChecked := False;
  FUserEditor := nil;
end;

destructor TSHELIntegerPropEditor.Destroy;
begin
  if Assigned(FUserEditor) then
    FUserEditor.Free;
  inherited;
end;

procedure TSHELIntegerPropEditor.Edit;
begin
  if UserEditor <> nil then
    FUserEditor.Edit
  else
    inherited Edit;
end;

function TSHELIntegerPropEditor.GetAttrs: TELPropAttrs;
var
  UserAttributes: TPropertyAttributes;
  InheritedAttrs: TELPropAttrs;
begin
  if UserEditor <> nil then
  begin
    UserAttributes := FUserEditor.GetAttributes;
    InheritedAttrs := (inherited GetAttrs);
    Result := [];
    if paValueList in UserAttributes then
      Include(Result, praValueList);
    if paSubProperties in UserAttributes then
      Include(Result, praSubProperties);
    if paDialog in UserAttributes then
      Include(Result, praDialog);
    if paMultiSelect in UserAttributes then
      Include(Result, praMultiSelect);
    if paAutoUpdate in UserAttributes then
      Include(Result, praAutoUpdate);
    if paSortList in UserAttributes then
      Include(Result, praSortList);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paVolatileSubProperties in UserAttributes then
      Include(Result, praVolatileSubProperties);
    if paNotNestable in UserAttributes then
      Include(Result, praNotNestable);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);

    if praOwnerDrawValues in InheritedAttrs then
      Include(Result, praOwnerDrawValues);
    if praComponentRef in InheritedAttrs then
      Include(Result, praComponentRef);
  end
  else
    Result := inherited GetAttrs;
end;

function TSHELIntegerPropEditor.GetUserEditor: TSHPropertyEditor;
var
  PropertyEditorClass: TSHPropertyEditorClass;
  vInstance: TObject;
begin
  Result := nil;
  if Assigned(FUserEditor) then
    Result := FUserEditor
  else
  begin
    vInstance := IGetInstance;
    if (not FUserEditorChecked) and Assigned(vInstance) then
    begin
      PropertyEditorClass :=
        GetUserEditorClass(vInstance, GetPropName);
      if Assigned(PropertyEditorClass) then
        FUserEditor := PropertyEditorClass.Create(Self);
      FUserEditorChecked := True;
    end;
  end;
end;

function TSHELIntegerPropEditor.GetValue: string;
begin
  if UserEditor <> nil then
    Result := FUserEditor.GetValue
  else
    Result := inherited GetValue;
end;

procedure TSHELIntegerPropEditor.GetValues(AValues: TStrings);
begin
  if UserEditor <> nil then
    FUserEditor.GetValues(AValues)
  else
    inherited GetValues(AValues);
end;

procedure TSHELIntegerPropEditor.IEdit;
begin
  inherited Edit;
end;

function TSHELIntegerPropEditor.IGetAttributes: TPropertyAttributes;
var
  InheritedAttrs: TELPropAttrs;
begin
  InheritedAttrs := inherited GetAttrs;
  Result := [];
  if praValueList in InheritedAttrs then
    Include(Result, paValueList);
  if praSubProperties in InheritedAttrs then
    Include(Result, paSubProperties);
  if praDialog in InheritedAttrs then
    Include(Result, paDialog);
  if praMultiSelect in InheritedAttrs then
    Include(Result, paMultiSelect);
  if praAutoUpdate in InheritedAttrs then
    Include(Result, paAutoUpdate);
  if praSortList in InheritedAttrs then
    Include(Result, paSortList);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praVolatileSubProperties in InheritedAttrs then
    Include(Result, paVolatileSubProperties);
  if praNotNestable in InheritedAttrs then
    Include(Result, paNotNestable);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
end;

function TSHELIntegerPropEditor.IGetInstance: TObject;
begin
  Result := GetInstance(0);
end;

function TSHELIntegerPropEditor.IGetPropInfo: PPropInfo;
begin
  Result := GetPropInfo(0);
end;

function TSHELIntegerPropEditor.IGetPropTypeInfo: PTypeInfo;
begin
  Result := PropTypeInfo;
end;

function TSHELIntegerPropEditor.IGetValue: string;
begin
  Result := inherited GetValue;
end;

procedure TSHELIntegerPropEditor.IGetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
end;

procedure TSHELIntegerPropEditor.ISetValue(const Value: string);
begin
  inherited SetValue(Value);
end;

procedure TSHELIntegerPropEditor.SetValue(const Value: string);
begin
  if UserEditor <> nil then
    FUserEditor.SetValue(Value)
  else
    inherited SetValue(Value);
end;

function TSHELIntegerPropEditor.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TSHELIntegerPropEditor._AddRef: Integer;
begin
  Result := -1;
end;

function TSHELIntegerPropEditor._Release: Integer;
begin
  Result := -1;
end;

{ TSHELClassPropEditor }

constructor TSHELClassPropEditor.Create(ADesigner: Pointer;
  APropCount: Integer);
begin
  inherited;
  FUserEditorChecked := False;
  FUserEditor := nil;
end;

destructor TSHELClassPropEditor.Destroy;
begin
  if Assigned(FUserEditor) then
    FUserEditor.Free;
  inherited;
end;

procedure TSHELClassPropEditor.Edit;
begin
  if UserEditor <> nil then
    FUserEditor.Edit
  else
    inherited Edit;
end;

function TSHELClassPropEditor.GetAttrs: TELPropAttrs;
var
  UserAttributes: TPropertyAttributes;
  InheritedAttrs: TELPropAttrs;
begin
  if UserEditor <> nil then
  begin
    UserAttributes := FUserEditor.GetAttributes;
    InheritedAttrs := (inherited GetAttrs);
    Result := [];
    if paValueList in UserAttributes then
      Include(Result, praValueList);
    if paSubProperties in UserAttributes then
      Include(Result, praSubProperties);
    if paDialog in UserAttributes then
      Include(Result, praDialog);
    if paMultiSelect in UserAttributes then
      Include(Result, praMultiSelect);
    if paAutoUpdate in UserAttributes then
      Include(Result, praAutoUpdate);
    if paSortList in UserAttributes then
      Include(Result, praSortList);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paVolatileSubProperties in UserAttributes then
      Include(Result, praVolatileSubProperties);
    if paNotNestable in UserAttributes then
      Include(Result, praNotNestable);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);

    if praOwnerDrawValues in InheritedAttrs then
      Include(Result, praOwnerDrawValues);
    if praComponentRef in InheritedAttrs then
      Include(Result, praComponentRef);
  end
  else
    Result := inherited GetAttrs;
end;

function TSHELClassPropEditor.GetUserEditor: TSHPropertyEditor;
var
  PropertyEditorClass: TSHPropertyEditorClass;
  vInstance: TObject;
begin
  Result := nil;
  if Assigned(FUserEditor) then
    Result := FUserEditor
  else
  begin
    vInstance := IGetInstance;
    if (not FUserEditorChecked) and Assigned(vInstance) then
    begin
      PropertyEditorClass :=
        GetUserEditorClass(vInstance, GetPropName);
      if Assigned(PropertyEditorClass) then
        FUserEditor := PropertyEditorClass.Create(Self);
      FUserEditorChecked := True;
    end;
  end;
end;

function TSHELClassPropEditor.GetValue: string;
begin
  if UserEditor <> nil then
    Result := FUserEditor.GetValue
  else
    Result := inherited GetValue;
end;

procedure TSHELClassPropEditor.GetValues(AValues: TStrings);
begin
  if UserEditor <> nil then
    FUserEditor.GetValues(AValues)
  else
    inherited GetValues(AValues);
end;

procedure TSHELClassPropEditor.IEdit;
begin
  inherited Edit;
end;

function TSHELClassPropEditor.IGetAttributes: TPropertyAttributes;
var
  InheritedAttrs: TELPropAttrs;
begin
  InheritedAttrs := inherited GetAttrs;
  Result := [];
  if praValueList in InheritedAttrs then
    Include(Result, paValueList);
  if praSubProperties in InheritedAttrs then
    Include(Result, paSubProperties);
  if praDialog in InheritedAttrs then
    Include(Result, paDialog);
  if praMultiSelect in InheritedAttrs then
    Include(Result, paMultiSelect);
  if praAutoUpdate in InheritedAttrs then
    Include(Result, paAutoUpdate);
  if praSortList in InheritedAttrs then
    Include(Result, paSortList);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praVolatileSubProperties in InheritedAttrs then
    Include(Result, paVolatileSubProperties);
  if praNotNestable in InheritedAttrs then
    Include(Result, paNotNestable);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
end;

function TSHELClassPropEditor.IGetInstance: TObject;
begin
  Result := GetInstance(0);
end;

function TSHELClassPropEditor.IGetPropInfo: PPropInfo;
begin
  Result := GetPropInfo(0);
end;

function TSHELClassPropEditor.IGetPropTypeInfo: PTypeInfo;
begin
  Result := PropTypeInfo;
end;

function TSHELClassPropEditor.IGetValue: string;
begin
  Result := inherited GetValue;
end;

procedure TSHELClassPropEditor.IGetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
end;

procedure TSHELClassPropEditor.ISetValue(const Value: string);
begin
  inherited SetValue(Value);
end;

procedure TSHELClassPropEditor.SetValue(const Value: string);
begin
  if UserEditor <> nil then
    FUserEditor.SetValue(Value)
  else
    inherited SetValue(Value);
end;

function TSHELClassPropEditor.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TSHELClassPropEditor._AddRef: Integer;
begin
  Result := -1;
end;

function TSHELClassPropEditor._Release: Integer;
begin
  Result := -1;
end;

{ TSHELInt64PropEditor }

constructor TSHELInt64PropEditor.Create(ADesigner: Pointer;
  APropCount: Integer);
begin
  inherited;
  FUserEditorChecked := False;
  FUserEditor := nil;
end;

destructor TSHELInt64PropEditor.Destroy;
begin
  if Assigned(FUserEditor) then
    FUserEditor.Free;
  inherited;
end;

procedure TSHELInt64PropEditor.Edit;
begin
  if UserEditor <> nil then
    FUserEditor.Edit
  else
    inherited Edit;
end;

function TSHELInt64PropEditor.GetAttrs: TELPropAttrs;
var
  UserAttributes: TPropertyAttributes;
  InheritedAttrs: TELPropAttrs;
begin
  if UserEditor <> nil then
  begin
    UserAttributes := FUserEditor.GetAttributes;
    InheritedAttrs := (inherited GetAttrs);
    Result := [];
    if paValueList in UserAttributes then
      Include(Result, praValueList);
    if paSubProperties in UserAttributes then
      Include(Result, praSubProperties);
    if paDialog in UserAttributes then
      Include(Result, praDialog);
    if paMultiSelect in UserAttributes then
      Include(Result, praMultiSelect);
    if paAutoUpdate in UserAttributes then
      Include(Result, praAutoUpdate);
    if paSortList in UserAttributes then
      Include(Result, praSortList);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paVolatileSubProperties in UserAttributes then
      Include(Result, praVolatileSubProperties);
    if paNotNestable in UserAttributes then
      Include(Result, praNotNestable);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);

    if praOwnerDrawValues in InheritedAttrs then
      Include(Result, praOwnerDrawValues);
    if praComponentRef in InheritedAttrs then
      Include(Result, praComponentRef);
  end
  else
    Result := inherited GetAttrs;
end;

function TSHELInt64PropEditor.GetUserEditor: TSHPropertyEditor;
var
  PropertyEditorClass: TSHPropertyEditorClass;
  vInstance: TObject;
begin
  Result := nil;
  if Assigned(FUserEditor) then
    Result := FUserEditor
  else
  begin
    vInstance := IGetInstance;
    if (not FUserEditorChecked) and Assigned(vInstance) then
    begin
      PropertyEditorClass :=
        GetUserEditorClass(vInstance, GetPropName);
      if Assigned(PropertyEditorClass) then
        FUserEditor := PropertyEditorClass.Create(Self);
      FUserEditorChecked := True;
    end;
  end;
end;

function TSHELInt64PropEditor.GetValue: string;
begin
  if UserEditor <> nil then
    Result := FUserEditor.GetValue
  else
    Result := inherited GetValue;
end;

procedure TSHELInt64PropEditor.GetValues(AValues: TStrings);
begin
  if UserEditor <> nil then
    FUserEditor.GetValues(AValues)
  else
    inherited GetValues(AValues);
end;

procedure TSHELInt64PropEditor.IEdit;
begin
  inherited Edit;
end;

function TSHELInt64PropEditor.IGetAttributes: TPropertyAttributes;
var
  InheritedAttrs: TELPropAttrs;
begin
  InheritedAttrs := inherited GetAttrs;
  Result := [];
  if praValueList in InheritedAttrs then
    Include(Result, paValueList);
  if praSubProperties in InheritedAttrs then
    Include(Result, paSubProperties);
  if praDialog in InheritedAttrs then
    Include(Result, paDialog);
  if praMultiSelect in InheritedAttrs then
    Include(Result, paMultiSelect);
  if praAutoUpdate in InheritedAttrs then
    Include(Result, paAutoUpdate);
  if praSortList in InheritedAttrs then
    Include(Result, paSortList);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praVolatileSubProperties in InheritedAttrs then
    Include(Result, paVolatileSubProperties);
  if praNotNestable in InheritedAttrs then
    Include(Result, paNotNestable);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
end;

function TSHELInt64PropEditor.IGetInstance: TObject;
begin
  Result := GetInstance(0);
end;

function TSHELInt64PropEditor.IGetPropInfo: PPropInfo;
begin
  Result := GetPropInfo(0);
end;

function TSHELInt64PropEditor.IGetPropTypeInfo: PTypeInfo;
begin
  Result := PropTypeInfo;
end;

function TSHELInt64PropEditor.IGetValue: string;
begin
  Result := inherited GetValue;
end;

procedure TSHELInt64PropEditor.IGetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
end;

procedure TSHELInt64PropEditor.ISetValue(const Value: string);
begin
  inherited SetValue(Value);
end;

procedure TSHELInt64PropEditor.SetValue(const Value: string);
begin
  if UserEditor <> nil then
    FUserEditor.SetValue(Value)
  else
    inherited SetValue(Value);
end;

function TSHELInt64PropEditor.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TSHELInt64PropEditor._AddRef: Integer;
begin
  Result := -1;
end;

function TSHELInt64PropEditor._Release: Integer;
begin
  Result := -1;
end;

{ TSHELComponentPropEditor }

constructor TSHELComponentPropEditor.Create(ADesigner: Pointer;
  APropCount: Integer);
begin
  inherited;
  FUserEditorChecked := False;
  FUserEditor := nil;
end;

destructor TSHELComponentPropEditor.Destroy;
begin
  if Assigned(FUserEditor) then
    FUserEditor.Free;
  inherited;
end;

procedure TSHELComponentPropEditor.Edit;
begin
  if UserEditor <> nil then
    FUserEditor.Edit
  else
    inherited Edit;
end;

function TSHELComponentPropEditor.GetAttrs: TELPropAttrs;
var
  UserAttributes: TPropertyAttributes;
  InheritedAttrs: TELPropAttrs;
begin
  if UserEditor <> nil then
  begin
    UserAttributes := FUserEditor.GetAttributes;
    InheritedAttrs := (inherited GetAttrs);
    Result := [];
    if paValueList in UserAttributes then
      Include(Result, praValueList);
    if paSubProperties in UserAttributes then
      Include(Result, praSubProperties);
    if paDialog in UserAttributes then
      Include(Result, praDialog);
    if paMultiSelect in UserAttributes then
      Include(Result, praMultiSelect);
    if paAutoUpdate in UserAttributes then
      Include(Result, praAutoUpdate);
    if paSortList in UserAttributes then
      Include(Result, praSortList);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paVolatileSubProperties in UserAttributes then
      Include(Result, praVolatileSubProperties);
    if paNotNestable in UserAttributes then
      Include(Result, praNotNestable);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);
    if paReadOnly in UserAttributes then
      Include(Result, praReadOnly);

    if praOwnerDrawValues in InheritedAttrs then
      Include(Result, praOwnerDrawValues);
    if praComponentRef in InheritedAttrs then
      Include(Result, praComponentRef);
  end
  else
    Result := inherited GetAttrs;
end;

function TSHELComponentPropEditor.GetUserEditor: TSHPropertyEditor;
var
  PropertyEditorClass: TSHPropertyEditorClass;
  vInstance: TObject;
begin
  Result := nil;
  if Assigned(FUserEditor) then
    Result := FUserEditor
  else
  begin
    vInstance := IGetInstance;
    if (not FUserEditorChecked) and Assigned(vInstance) then
    begin
      PropertyEditorClass :=
        GetUserEditorClass(vInstance, GetPropName);
      if Assigned(PropertyEditorClass) then
        FUserEditor := PropertyEditorClass.Create(Self);
      FUserEditorChecked := True;
    end;
  end;
end;

function TSHELComponentPropEditor.GetValue: string;
begin
  if UserEditor <> nil then
    Result := FUserEditor.GetValue
  else
    Result := inherited GetValue;
end;

procedure TSHELComponentPropEditor.GetValues(AValues: TStrings);
begin
  if UserEditor <> nil then
    FUserEditor.GetValues(AValues)
  else
    inherited GetValues(AValues);
end;

procedure TSHELComponentPropEditor.IEdit;
begin
  inherited Edit;
end;

function TSHELComponentPropEditor.IGetAttributes: TPropertyAttributes;
var
  InheritedAttrs: TELPropAttrs;
begin
  InheritedAttrs := inherited GetAttrs;
  Result := [];
  if praValueList in InheritedAttrs then
    Include(Result, paValueList);
  if praSubProperties in InheritedAttrs then
    Include(Result, paSubProperties);
  if praDialog in InheritedAttrs then
    Include(Result, paDialog);
  if praMultiSelect in InheritedAttrs then
    Include(Result, paMultiSelect);
  if praAutoUpdate in InheritedAttrs then
    Include(Result, paAutoUpdate);
  if praSortList in InheritedAttrs then
    Include(Result, paSortList);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praVolatileSubProperties in InheritedAttrs then
    Include(Result, paVolatileSubProperties);
  if praNotNestable in InheritedAttrs then
    Include(Result, paNotNestable);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
  if praReadOnly in InheritedAttrs then
    Include(Result, paReadOnly);
end;

function TSHELComponentPropEditor.IGetInstance: TObject;
begin
  Result := GetInstance(0);
end;

function TSHELComponentPropEditor.IGetPropInfo: PPropInfo;
begin
  Result := GetPropInfo(0);
end;

function TSHELComponentPropEditor.IGetPropTypeInfo: PTypeInfo;
begin
  Result := PropTypeInfo;
end;

function TSHELComponentPropEditor.IGetValue: string;
begin
  Result := inherited GetValue;
end;

procedure TSHELComponentPropEditor.IGetValues(AValues: TStrings);
begin
  inherited GetValues(AValues);
end;

procedure TSHELComponentPropEditor.ISetValue(const Value: string);
begin
  inherited SetValue(Value);
end;

procedure TSHELComponentPropEditor.SetValue(const Value: string);
begin
  if UserEditor <> nil then
    FUserEditor.SetValue(Value)
  else
    inherited SetValue(Value);
end;

function TSHELComponentPropEditor.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TSHELComponentPropEditor._AddRef: Integer;
begin
  Result := -1;
end;

function TSHELComponentPropEditor._Release: Integer;
begin
  Result := -1;
end;

end.

