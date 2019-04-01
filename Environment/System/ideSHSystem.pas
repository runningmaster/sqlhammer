unit ideSHSystem;

interface

uses
  Classes, SysUtils,
  SHDesignIntf, SHOptionsIntf,
  ideSHDesignIntf, ideSHMain, ideSHRegistry, ideSHDesigner,
  ideSHMegaEditor, ideSHComponentFactory;

{ ћега√лобальные переменные
}
var
  Registry: TideBTRegistry;
  Main: TideBTMain;
  MegaEditor: TideBTMegaEditor;
  ComponentFactory: TideSHComponentFactory;
  Designer: TideBTDesigner;

  NavigatorIntf: IideSHNavigator;

  RegistryIntf: IideBTRegistry;
  MainIntf: IideBTMain;
  ObjectEditorIntf: IideSHObjectEditor;
  MegaEditorIntf: IideBTMegaEditor;
  ComponentFactoryIntf: IideSHComponentFactory;
  DesignerIntf: ISHDesigner;

  SystemOptionsIntf: ISHSystemOptions;

  FileCommandsIntf: ISHFileCommands;
  EditCommandsIntf: ISHEditCommands;
  SearchCommandsIntf: ISHSearchCommands;
  RunCommandsIntf: ISHRunCommands;

implementation

end.



