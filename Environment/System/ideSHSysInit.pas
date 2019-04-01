unit ideSHSysInit;

interface

uses
  Classes, SysUtils,
  SHDesignIntf, SHDevelopIntf,
  ideSHDesignIntf, ideSHConsts, ideSHSystem, ideSHSysUtils, ideSHMain,
  ideSHRegistry, ideSHDesigner,
  ideSHMegaEditor, ideSHComponentFactory;

type
  TSHBranchInfo = class(TSHComponent, ISHDemon, ISHBranchInfo, ISHBranch)
  private
    function GetBranchName: string;
  protected
    function GetBranchIID: TGUID; override;
    function GetCaption: string; override;
    function GetCaptionExt: string; override;
  public
    class function GetHintClassFnc: string; override;
    class function GetAssociationClassFnc: string; override;
    class function GetClassIIDClassFnc: TGUID; override;
  end;

procedure GlobalFinalization;

implementation

{ TSHBranchInfo }

class function TSHBranchInfo.GetHintClassFnc: string;
begin
  Result := Format('%s', [SSHCommonBranch])
end;

class function TSHBranchInfo.GetAssociationClassFnc: string;
begin
  Result := GetHintClassFnc;
end;

class function TSHBranchInfo.GetClassIIDClassFnc: TGUID;
begin
  Result := ISHBranch;
end;

function TSHBranchInfo.GetBranchIID: TGUID;
begin
  Result := ISHBranch;
end;

function TSHBranchInfo.GetCaption: string;
begin
  Result := GetBranchName;
end;

function TSHBranchInfo.GetCaptionExt: string;
begin
  Result := Format('%s Information', [Caption]);
end;

function TSHBranchInfo.GetBranchName: string;
begin
  Result := GetHintClassFnc;
end;

procedure GlobalFinalization;
begin

{ Обниливание МегаГлобальных переменных системы и освобождение
}
  RegistryIntf := nil;
  { TODO -oBuzz -cСреда : Почему то стало бить АВ. Разобраться }
//  FreeAndNil(Registry);

  ObjectEditorIntf := nil;
  MegaEditorIntf := nil;
  MainIntf := nil;

  ComponentFactoryIntf := nil;
  DesignerIntf := nil;


  FreeAndNil(Designer);
  FreeAndNil(ComponentFactory);
  FreeAndNil(MegaEditor);
  FreeAndNil(Main);
end;

initialization
{ Архивирование конфига
}

  ideSHSysUtils.BackupConfigFile(ideSHSysUtils.GetFilePath(SFileConfig), ideSHSysUtils.GetFilePath(SFileConfigBackup));
  ideSHSysUtils.BackupConfigFile(ideSHSysUtils.GetFilePath(SFileAliases), ideSHSysUtils.GetFilePath(SFileAliasesBackup));
  ideSHSysUtils.ForceConfigFile(ideSHSysUtils.GetFilePath(SFileConfig));
  ideSHSysUtils.ForceConfigFile(ideSHSysUtils.GetFilePath(SFileAliases));
  ideSHSysUtils.ForceConfigFile(ideSHSysUtils.GetFilePath(SFileEnvironment));
  ideSHSysUtils.ForceConfigFile(ideSHSysUtils.GetFilePath(SFileForms));

{ Инициализация папок
}
  ForceDirectories(ideSHSysUtils.GetDirPath(SDirData));

{ Инициализация BTDesignIntf
}

  SHRegisterInterfaceProc := @ideBTRegisterInterface;
  SHSupportsFunc := @ideBTSupportInterface;

  SHRegisterActionsProc := @ideBTRegisterActions;
  SHRegisterComponentsProc := @ideBTRegisterComponents;
  SHRegisterPropertyEditorProc := @ideBTRegisterPropertyEditor;
  SHRegisterComponentFormProc := @ideBTRegisterComponentForm;
  SHRegisterImageProc := @ideBTRegisterImage;
  
{ Инициализация Мегаглобальных переменных системы
}
  Registry := TideBTRegistry.Create(nil);
  Main := TideBTMain.Create(nil);
  MegaEditor := TideBTMegaEditor.Create(nil);
  ComponentFactory := TideSHComponentFactory.Create(nil);
  Designer := TideBTDesigner.Create(nil);

  Supports(Registry, IideBTRegistry, RegistryIntf);
  Supports(Main, IideBTMain, MainIntf);
  Supports(MegaEditor, IideBTMegaEditor, MegaEditorIntf);
  Supports(ComponentFactory, IideSHComponentFactory, ComponentFactoryIntf);
  Supports(Designer, ISHDesigner, DesignerIntf);

  if Assigned(DesignerIntf) then
  begin
    SHRegisterInterface(DesignerIntf);
    //SHDesignIntf.SHRegisterComponents([TSHBranchInfo]);
  end;

finalization
  GlobalFinalization;

end.
