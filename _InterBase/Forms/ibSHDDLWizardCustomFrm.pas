unit ibSHDDLWizardCustomFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, SynEdit, pSHSynEdit;

type
  TibSHDDLWizardCustomForm = class(TibBTComponentForm, ISHDDLWizard)
  private
    { Private declarations }
    FDBObjectIntf: IibSHDBObject;
    FDBState: TSHDBComponentState;
    FDDLInfoIntf: IibSHDDLInfo;
    FDDLFormIntf: IibSHDDLForm;
    FDDLGenerator: TComponent;
    FDDLGeneratorIntf: IibSHDDLGenerator;
    FTMPComponent: TComponent;
    FTMPObjectIntf: IibSHDBObject;
    FEditorDescr: TpSHSynEdit;
    FOutDDL: TStrings;
    procedure CreateOutputDDL;
  protected
    { Protected declarations }
    procedure DoOnBeforeModalClose(Sender: TObject; var ModalResult: TModalResult;
      var Action: TCloseAction); override;
    procedure DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult); override;

    procedure SetTMPDefinitions; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure InitPageCtrl(APageCtrl: TPageControl);
    procedure InitDescrEditor(AEditor: TpSHSynEdit; ARealDescr: Boolean = True);
    function NormalizeCaption(ACaption: string): string;
    function IsKeyword(const S: string): Boolean;

    property DBObject: IibSHDBObject read FDBObjectIntf;
    property DBState: TSHDBComponentState read FDBState;
    property DDLInfo: IibSHDDLInfo read FDDLInfoIntf;
    property DDLForm: IibSHDDLForm read FDDLFormIntf;
    property DDLGenerator: IibSHDDLGenerator read FDDLGeneratorIntf;
    property TMPComponent: TComponent read FTMPComponent;
    property TMPObject: IibSHDBObject read FTMPObjectIntf;
    property EditorDescr: TpSHSynEdit read FEditorDescr;
    property OutDDL: TStrings read FOutDDL;
  end;

implementation

uses
  ibSHValues;

{ TibSHDDLWizardCustomForm }

constructor TibSHDDLWizardCustomForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  vComponentClass: TSHComponentClass;
  S: string;
begin
  FOutDDL := TStringList.Create;
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHDBObject, FDBObjectIntf);
  Supports(Component, IibSHDDLInfo, FDDLInfoIntf);
  Supports(Designer.CurrentComponentForm, IibSHDDLForm, FDDLFormIntf);
  FDBState := DBObject.State;
  //
  // Установка Caption диалога
  //
  case DBObject.State of
    csCreate:   S := 'CREATE DDL';
    csAlter:    S := 'ALTER DDL';
    csDrop:     S := 'DROP DDL';
    csRecreate: S := 'RECREATE DDL';
  end;
  Caption := Format('%s [%s] \ %s', [AnsiUpperCase(GUIDToName(Component.ClassIID)), Component.Caption, S]);
  //
  // Создание DDL генератора
  //
  vComponentClass := Designer.GetComponent(IibSHDDLGenerator);
  if Assigned(vComponentClass) then
  begin
    FDDLGenerator := vComponentClass.Create(nil);
    Supports(FDDLGenerator, IibSHDDLGenerator, FDDLGeneratorIntf);
  end;
  Assert(DDLGenerator <> nil, 'DDLGenerator = nil');
  //
  // Создание TMP компонента для генерации с него искомого DDL
  //
  vComponentClass := Designer.GetComponent(Component.ClassIID);
  if Assigned(vComponentClass) then
  begin
    FTMPComponent := vComponentClass.Create(nil);
    Supports(FTMPComponent, IibSHDBObject, FTMPObjectIntf);
  end;
  Assert(TMPObject <> nil, 'TMPObject = nil');
  //
  // Копирование необходимых свойств из DBObject в TMPObject
  //
  TMPObject.OwnerIID := DBObject.OwnerIID;
  TMPObject.Caption := DBObject.Caption;
  TMPObject.ObjectName := DBObject.ObjectName;
  TMPObject.State := DBObject.State;
end;

destructor TibSHDDLWizardCustomForm.Destroy;
begin
  FOutDDL.Free;
  FDBObjectIntf := nil;
  FDDLInfoIntf := nil;
  FDDLFormIntf := nil;
  FDDLGeneratorIntf := nil;
  FDDLGenerator.Free;
  FTMPObjectIntf := nil;
  FTMPComponent.Free;
  inherited Destroy;
end;

procedure TibSHDDLWizardCustomForm.InitPageCtrl(APageCtrl: TPageControl);
begin
  PageCtrl := APageCtrl;
  PageCtrl.ActivePageIndex := 0;
  PageCtrl.TabStop := False;
  PageCtrl.HotTrack := True;
  PageCtrl.Images := Designer.ImageList;
  PageCtrl.Pages[0].ImageIndex := Designer.GetImageIndex(DBObject.ClassIID);
  PageCtrl.Pages[1].ImageIndex := -1;
  Flat := True;
  PageCtrl.Pages[1].TabVisible := (DBState = csCreate) and (Component.Tag = 0);
end;

procedure TibSHDDLWizardCustomForm.InitDescrEditor(AEditor: TpSHSynEdit;
  ARealDescr: Boolean = True);
begin
  AEditor.Lines.Clear;
  AEditor.Highlighter := nil;
  // Принудительная установка фонта
  AEditor.Font.Charset := 1;
  AEditor.Font.Color := clWindowText;
  AEditor.Font.Height := -13;
  AEditor.Font.Name := 'Courier New';
  AEditor.Font.Pitch := fpDefault;
  AEditor.Font.Size := 10;
  AEditor.Font.Style := [];

  if ARealDescr then
  begin
    FEditorDescr := AEditor;
    FEditorDescr.Lines.AddStrings(DBObject.Description);
  end;
end;

function TibSHDDLWizardCustomForm.NormalizeCaption(ACaption: string): string;
var
  vCodeNormalizer: IibSHCodeNormalizer;
begin
  Result := ACaption;
  if Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer) then
    Result := vCodeNormalizer.InputValueToMetadata(DBObject.BTCLDatabase, Result);
end;

function TibSHDDLWizardCustomForm.IsKeyword(const S: string): Boolean;
var
  vCodeNormalizer: IibSHCodeNormalizer;
begin
  Result := Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer);
  if Result then
    Result := vCodeNormalizer.IsKeyword(DBObject.BTCLDatabase, S);
end;

procedure TibSHDDLWizardCustomForm.DoOnBeforeModalClose(Sender: TObject; var ModalResult: TModalResult;
  var Action: TCloseAction);
begin
//  if ModalResult <> mrOK then
//  begin
//    if DBObject.Embedded then
//      if (DDLForm as ISHRunCommands).CanPause then (DDLForm as ISHRunCommands).Pause;
//  end else
//    CreateOutputDDL;
end;

procedure TibSHDDLWizardCustomForm.DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult);
begin
  if ModalResult = mrOK then CreateOutputDDL;
end;

procedure TibSHDDLWizardCustomForm.SetTMPDefinitions;
begin
// Empty
end;

procedure TibSHDDLWizardCustomForm.CreateOutputDDL;
begin
  OutDDL.Clear;
  //
  // Для RECREATE предварительно получаем DROP DDL из текущего объекта
  //
//  if DBState = csRecreate then
//  begin
//    try
//      OutDDL.Add('/* Delete OLD object -------------------------------------------------------- */');
//      DBObject.State := csDrop;
//      DDLGenerator.UseFakeValues := False;
//      Designer.TextToStrings(DDLGenerator.GetDDLText(DBObject), OutDDL);
//      OutDDL.Add('');
//      OutDDL.Add('/* Create NEW object -------------------------------------------------------- */');
//    finally
//      DBObject.State := DBState;
//      DDLGenerator.UseFakeValues := True;
//    end;
//  end;
  //
  // Заполнение значениями свойств TMPObject (virtual) для генерации DDL
  //
  SetTMPDefinitions;
  //
  // Если RECREATE, то отдельно получаем CREATE DDL
  //
  if (DBState = csCreate) or (DBState = csRecreate) then
  begin
    try
//      TMPObject.State := csCreate;
      DDLGenerator.UseFakeValues := False;
      Designer.TextToStrings(DDLGenerator.GetDDLText(TMPObject), OutDDL);
    finally
      DDLGenerator.UseFakeValues := True;
//      TMPObject.State := DBState;
    end;
  end;

  if DBState = csAlter then
    Designer.TextToStrings(DDLGenerator.GetDDLText(TMPObject), OutDDL);

  if Assigned(DDLInfo) then
  begin
    DDLInfo.DDL.Clear;
    DDLInfo.DDL.AddStrings(OutDDL);
  end;

  case Component.Tag of
    0: DDLForm.ShowDDLText;                     // DBObjects
    100: DDLForm.DDLText.Assign(OutDDL);        // SQLEditor
//    200: begin                                  // SQLPlayer
//           DDLForm.DDLText.Add('');
//           DDLForm.DDLText.AddStrings(OutDDL);
//         end;
  end;
  //
  // Установка Descriptions
  //
  if Assigned(EditorDescr) and EditorDescr.Modified then
    DBObject.Description.Assign(EditorDescr.Lines);
end;

end.
