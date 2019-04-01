unit ibSHDDLFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHDriverIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ExtCtrls, ToolWin, StdCtrls, SynEdit, SynEditTypes,
  pSHSynEdit, ActnList, AppEvnts, Menus, ComCtrls,ibSHValues;

type
  TibBTDDLMonitorState = (msRead, msWrite, msActive, msError);

  TibBTDDLForm = class(TibBTComponentForm, IibSHDDLForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    pSHSynEdit1: TpSHSynEdit;
    ApplicationEvents1: TApplicationEvents;
    pSHSynEdit2: TpSHSynEdit;
    PopupMenuMessage: TPopupMenu;
    pmiHideMessage: TMenuItem;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure pmiHideMessageClick(Sender: TObject);
  private
    { Private declarations }
    FLoading: Boolean;

    FDDLInfoIntf: IibSHDDLInfo;
    FDBObjectIntf: IibSHDBObject;
    FSQLEditorIntf: IibSHSQLEditor;

    FDDLGenerator: TComponent;
    FDDLGeneratorIntf: IibSHDDLGenerator;

    FDDLCompiler: TComponent;
    FDRVTransaction: TComponent;
    FDRVQuery: TComponent;
    FMsgPanel: TPanel;
    FMonitorState: TibBTDDLMonitorState;
    FSenderClosing: Boolean;

    FOnAfterRun: TNotifyEvent;
    FOnAfterCommit: TNotifyEvent;
    FOnAfterRollback: TNotifyEvent;

    function GetDDLCompiler: IibSHDDLCompiler;
    function GetDRVTransaction: IibSHDRVTransaction;
    function GetDRVQuery: IibSHDRVQuery;
    procedure CreateDRV;
    procedure FreeDRV;
    procedure SetMonitorState(Value: TibBTDDLMonitorState);
    procedure GutterDrawNotify(Sender: TObject; ALine: Integer; var ImageIndex: Integer);
  protected
    procedure EditorMsgVisible(AShow: Boolean = True); override;
    function GetTemplateDir:string;
    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanCreate: Boolean; override;
    function GetCanAlter: Boolean; override;
    function GetCanDrop: Boolean; override;
    function GetCanRecreate: Boolean; override;
    function GetCanCommit: Boolean; override;
    function GetCanRollback: Boolean; override;
    function GetCanRefresh: Boolean; override;

    procedure Run; override;
    procedure ICreate; override;
    procedure Alter; override;
    procedure Drop; override;
    procedure Recreate; override;
    procedure Commit; override;
    procedure Rollback; override;
    procedure Refresh; override;

    function DoOnOptionsChanged: Boolean; override;
    procedure DoOnIdle; override;
    function GetCanDestroy: Boolean; override;
    procedure mnSaveAsToTemplateClick(Sender: TObject); override;
    procedure DoSaveAsTemplate;
    { IibSHDDLForm }
    function GetDDLText: TStrings;
    procedure SetDDLText(Value: TStrings);
    procedure PrepareControls;
    procedure ShowDDLText;
    function GetOnAfterRun: TNotifyEvent;
    procedure SetOnAfterRun(Value: TNotifyEvent);
    function GetOnAfterCommit: TNotifyEvent;
    procedure SetOnAfterCommit(Value: TNotifyEvent);
    function GetOnAfterRollback: TNotifyEvent;
    procedure SetOnAfterRollback(Value: TNotifyEvent);


  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure BringToTop; override;

    property DDLInfo: IibSHDDLInfo read FDDLInfoIntf;
    property DBObject: IibSHDBObject read FDBObjectIntf;
    property SQLEditor: IibSHSQLEditor read FSQLEditorIntf;
    property DDLGenerator: IibSHDDLGenerator read FDDLGeneratorIntf;
    property DDLCompiler: IibSHDDLCompiler read GetDDLCompiler;
    property DRVTransaction: IibSHDRVTransaction read GetDRVTransaction;
    property DRVQuery: IibSHDRVQuery read GetDRVQuery;
    property MsgPanel: TPanel read FMsgPanel;
    property MonitorState: TibBTDDLMonitorState read FMonitorState write SetMonitorState;
  end;

  TibBTDDLFormAction_ = class(TSHAction)
  private
    procedure ExpandCollapseDomains;
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibBTDDLFormAction_Run = class(TibBTDDLFormAction_)
  end;
  TibBTDDLFormAction_Commit = class(TibBTDDLFormAction_)
  end;
  TibBTDDLFormAction_Rollback = class(TibBTDDLFormAction_)
  end;
  TibBTDDLFormAction_Refresh = class(TibBTDDLFormAction_)
  end;
  TibBTDDLFormAction_ExpandDomains = class(TibBTDDLFormAction_)
  end;
  TibBTDDLFormAction_SaveAsTemplate = class(TibBTDDLFormAction_)
  end;



var
  ibBTDDLForm: TibBTDDLForm;

procedure Register;

implementation

uses
  ibSHConsts, ibBTOpenTemplateFrm;

{$R *.dfm}

const
  img_info   = 7;
  img_warning = 8;
  img_error  = 9;

procedure Register;
begin
  SHRegisterImage(TibBTDDLFormAction_Run.ClassName,           'Button_Run.bmp');
  SHRegisterImage(TibBTDDLFormAction_Commit.ClassName,        'Button_TrCommit.bmp');
  SHRegisterImage(TibBTDDLFormAction_Rollback.ClassName,      'Button_TrRollback.bmp');
  SHRegisterImage(TibBTDDLFormAction_Refresh.ClassName,       'Button_Refresh.bmp');
  SHRegisterImage(TibBTDDLFormAction_ExpandDomains.ClassName, 'DomainDecoded.bmp');
  SHRegisterImage(TibBTDDLFormAction_SaveAsTemplate.ClassName, 'Button_SaveAs.bmp');


  SHRegisterActions([
    TibBTDDLFormAction_Run,
    TibBTDDLFormAction_Commit,
    TibBTDDLFormAction_Rollback,
    TibBTDDLFormAction_Refresh,
    TibBTDDLFormAction_ExpandDomains,
    TibBTDDLFormAction_SaveAsTemplate
    ]);
end;

{ TibBTDDLForm }

constructor TibBTDDLForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  vComponentClass: TSHComponentClass;
begin
  FLoading := True;
  inherited Create(AOwner, AParent, AComponent, ACallString);
  //
  // Снятие интерфейсов с компонента
  //
  Supports(Component, IibSHDDLInfo, FDDLInfoIntf);
  Supports(Component, IibSHDBObject, FDBObjectIntf);
  Supports(Component, IibSHSQLEditor, FSQLEditorIntf);
  Assert(DDLInfo <> nil, 'DDLInfo = nil');
  //
  // Установка состояния DB объекта в зависимости от CallString формы
  //
  if Assigned(DBObject) then
  begin
    if AnsiSameText(CallString, SCallSourceDDL) then
    begin
{     if Supports(DBObject, IibSHTable) or Supports(DBObject, IibSHView) then
       DBObject.State := csRelatedSource
     else}
      DBObject.State := csSource
    end
    else
    if AnsiSameText(CallString, SCallCreateDDL) then DBObject.State := csCreate else
    if AnsiSameText(CallString, SCallAlterDDL) then DBObject.State := csAlter else
    if AnsiSameText(CallString, SCallDropDDL) then DBObject.State := csDrop
    else
    if AnsiSameText(CallString, SCallRecreateDDL) then
     DBObject.State := csRecreate
  end;
  //
  // Инициализация полей
  //
  FSenderClosing := False;
  FMsgPanel := Panel2;

  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
  EditorMsg := pSHSynEdit2;
  EditorMsg.Lines.Clear;
  EditorMsg.OnGutterDraw := GutterDrawNotify;
  EditorMsg.GutterDrawer.ImageList := ImageList1;
  EditorMsg.GutterDrawer.Enabled := True;
  FocusedControl := Editor;
  //
  // Регистрация редактора
  //
  RegisterEditors;
  //
  // Создание драйверов
  //
  CreateDRV;
  //
  // Создание DDL компилятора
  //
  vComponentClass := Designer.Getcomponent(IibSHDDLCompiler);
  if Assigned(vComponentClass) then
  begin
    FDDLCompiler := vComponentClass.Create(nil);
    (FDDLCompiler as ISHComponent).OwnerIID := Component.OwnerIID;
  end;
  Assert(DDLCompiler <> nil, 'DDLCompiler = nil');
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
  // Инициализация интерфейсных элементов
  //
  PrepareControls;

  MenuItemByName(FEditorPopupMenu.Items,SSaveAsToTemplate,0).Visible:=True
end;

destructor TibBTDDLForm.Destroy;
begin
  if Assigned(DBObject) then DBObject.State := csUnknown;
  if Assigned(DDLInfo) and not DDLInfo.BTCLDatabase.WasLostConnect then Rollback;
  FDDLGeneratorIntf := nil;
  FDDLGenerator.Free;
  FDDLCompiler.Free;

  FDDLInfoIntf := nil;
  FDBObjectIntf := nil;
  FSQLEditorIntf := nil;
  FreeDRV;
  inherited Destroy;
end;

function TibBTDDLForm.GetTemplateDir:string;
begin
Result:=
 (Designer.GetDemon(DBObject.BranchIID) as ISHDataRootDirectory).DataRootDirectory+
               'Repository\DDL\'+GUIDToName(DBObject.ClassIID, 1)

end;

procedure TibBTDDLForm.BringToTop;
var
//  vCallString: string;
   ACaption:string;
   TemplateFile:string;
   CaptionDlg:string;
begin
  inherited BringToTop;
  //
  // Установка состояния DB объекта
  //
  if Assigned(DBObject) {and (DBObject.State <> csUnknown)} then
  begin
    if AnsiSameText(CallString, SCallSourceDDL) then
    begin
{     if Supports(DBObject, IibSHTable) or Supports(DBObject, IibSHView) then
       DBObject.State := csRelatedSource
     else                               }
      DBObject.State := csSource
    end
    else
    if AnsiSameText(CallString, SCallCreateDDL) then DBObject.State := csCreate else
    if AnsiSameText(CallString, SCallAlterDDL) then DBObject.State := csAlter else
    if AnsiSameText(CallString, SCallRecreateDDL) then DBObject.State := csRecreate else
    if AnsiSameText(CallString, SCallDropDDL) then DBObject.State := csDrop;
  end;

  //
  // Получение искомого текста в редактор
  //
  if FLoading then
  begin
    if Assigned(DBObject) then
    begin
      try
        if DBObject.State = csCreate then
        begin
        // Берется из шаблона. Кто бы мог подумать
//          vCallString := Format('DDL_WIZARD.%s', [AnsiUpperCase(Component.Association)]);
//          if Assigned(Designer.GetComponentForm(Component.ClassIID, vCallString)) then
//          begin
//            Designer.ShowModal(Component, vCallString);
//          end else
//          begin
            ACaption:=DBObject.Caption;
            if not Supports(DDLGenerator,IibBTTemplates) then
            begin
             if Designer.InputQuery(Format('%s', [SLoadingDefaultTemplate]), Format('%s', [SObjectNameNew]), ACaption{, False}) and (Length(ACaption) > 0) then
             DBObject.Caption:=ACaption;
            end
            else
            begin
              CaptionDlg:=Format(SCreateNewObjectPrompt,[GUIDToName(DBObject.ClassIID, 0)]);
              if GetNewObjectParams(CaptionDlg,
               GetTemplateDir,ACaption,TemplateFile)
              then
              begin
                DBObject.Caption:=ACaption;
                (DDLGenerator as IibBTTemplates).CurrentTemplateFile:=TemplateFile;
              end
              else
               (DDLGenerator as IibBTTemplates).CurrentTemplateFile:='';
            end;
            DDLInfo.DDL.Text := DDLGenerator.GetDDLText(DBObject);
            Designer.UpdateObjectInspector;
            Editor.Lines.AddStrings(DDLInfo.DDL);
//          end;
        end else
        begin
          DDLInfo.DDL.Text := DDLGenerator.GetDDLText(DBObject);
          Designer.UpdateObjectInspector;
          Editor.Lines.AddStrings(DDLInfo.DDL);
        end;
      finally
        FLoading := False;
      end;
    end;
  end;
end;

function TibBTDDLForm.GetDDLCompiler: IibSHDDLCompiler;
begin
  Supports(FDDLCompiler, IibSHDDLCompiler, Result);
end;

function TibBTDDLForm.GetDRVTransaction: IibSHDRVTransaction;
begin
  Supports(FDRVTransaction, IibSHDRVTransaction, Result);
end;

function TibBTDDLForm.GetDRVQuery: IibSHDRVQuery;
begin
  Supports(FDRVQuery, IibSHDRVQuery, Result);
end;

procedure TibBTDDLForm.CreateDRV;
var
  vComponentClass: TSHComponentClass;
begin
  //
  // Получение реализации DRVTransaction
  //
  vComponentClass := Designer.GetComponent(DDLInfo.BTCLDatabase.BTCLServer.DRVNormalize(IibSHDRVTransaction));
  if Assigned(vComponentClass) then FDRVTransaction := vComponentClass.Create(Self);
  Assert(DRVTransaction <> nil, 'DRVTransaction = nil');
  //
  // Получение реализации DRVQuery
  //
  vComponentClass := Designer.GetComponent(DDLInfo.BTCLDatabase.BTCLServer.DRVNormalize(IibSHDRVQuery));
  if Assigned(vComponentClass) then FDRVQuery := vComponentClass.Create(Self);
  Assert(DRVQuery <> nil, 'DRVQuery = nil');
  //
  // Установка свойств DRVTransaction и DRVQuery
  //
  DRVTransaction.Params.Text := TRWriteParams;
  DRVTransaction.Database := DDLInfo.BTCLDatabase.DRVQuery.Database;
  DRVQuery.Transaction := DRVTransaction;
  DRVQuery.Database := DDLInfo.BTCLDatabase.DRVQuery.Database;
end;

procedure TibBTDDLForm.FreeDRV;
begin
  FreeAndNil(FDRVTransaction);
  FreeAndNil(FDRVQuery);
end;

procedure TibBTDDLForm.SetMonitorState(Value: TibBTDDLMonitorState);
begin
  FMonitorState := Value;
  case FMonitorState of
    msRead:
      begin
        Editor.ReadOnly := True;
        Editor.Modified := False;
      end;
    msWrite:
      begin
        Editor.ReadOnly := False;
        Editor.Modified := False;
      end;
    msActive:
      begin
        Editor.ReadOnly := True;
      end;
    msError:
      begin
        Editor.ReadOnly := False;
//        Editor.Modified := False;
      end;
  end;
end;

procedure TibBTDDLForm.GutterDrawNotify(Sender: TObject; ALine: Integer;
  var ImageIndex: Integer);
begin
  if ALine = 0 then
  begin
    case MonitorState of
      msRead, msWrite, msActive: ImageIndex := img_info;
      msError: ImageIndex := img_error;
    end;
  end else
  begin
    if Pos('Commit or Rollback', EditorMsg.Lines[ALine]) > 0 then
      ImageIndex := img_warning;
  end;
end;

procedure TibBTDDLForm.EditorMsgVisible(AShow: Boolean = True);
begin
  if AShow then
  begin
    MsgPanel.Visible := True;
    Splitter1.Visible := True;
  end else
  begin
    MsgPanel.Visible := False;
    Splitter1.Visible := False;
  end;
end;

function TibBTDDLForm.GetCanRun: Boolean;
begin
  Result := not (csDestroying in ComponentState) and
            not Editor.ReadOnly and
            not Editor.IsEmpty and
            not GetCanCommit;
end;

function TibBTDDLForm.GetCanCreate: Boolean;
begin
  Result := Assigned(DBObject) and not DBObject.System and not (DBObject.State = csCreate);
end;

function TibBTDDLForm.GetCanAlter: Boolean;
begin
  Result := Assigned(DBObject) and not DBObject.System and not (DBObject.State = csCreate);
  if Result then
    Result :=  (not Supports(Component, IibSHConstraint)) and
               (not Supports(Component, IibSHView)) and
               (not Supports(Component, IibSHFunction)) and
               (not Supports(Component, IibSHFilter)) and
               (not Supports(Component, IibSHRole));
end;

function TibBTDDLForm.GetCanDrop: Boolean;
begin
  Result := Assigned(DBObject) and not DBObject.System and not (DBObject.State = csCreate);
end;

function TibBTDDLForm.GetCanRecreate: Boolean;
begin
  Result := Assigned(DBObject) and not DBObject.System and not (DBObject.State = csCreate);
end;

function TibBTDDLForm.GetCanCommit: Boolean;
begin
  Result := not (csDestroying in ComponentState) and
            Assigned(DRVTransaction) and DRVTransaction.InTransaction;
end;

function TibBTDDLForm.GetCanRollback: Boolean;
begin
  Result := GetCanCommit;
end;

function TibBTDDLForm.GetCanRefresh: Boolean;
begin
  Result := AnsiSameText(CallString, SCallSourceDDL);
end;

procedure TibBTDDLForm.Run;
begin
{ TODO -oBuzz : 
Эту хуйню надо убрать. Иначе ни хера не компилятся процедуры 
которые по каким-то причинам парсер разбирает неправильно }
  if Assigned(DBObject) and (DBObject.State = csDrop) and
     not Designer.ShowMsg(Format('DROP object "%s"?', [DBObject.Caption]), mtConfirmation) then Exit;

  EditorMsgVisible;
  if Assigned(DDLInfo) and DDLCompiler.Compile(DRVQuery, Editor.Lines.Text) then
  begin
    if DDLInfo.BTCLDatabase.DatabaseAliasOptions.DDL.AutoCommit then
    begin
      if Length(DDLCompiler.ErrorText) > 0 then
      begin
        MonitorState := msError;
        Rollback;
        ErrorCoord := TBufferCoord(Point(DDLCompiler.ErrorColumn, DDLCompiler.ErrorLine));
      end else
        Commit;
    end;

    if GetCanCommit then
    begin
      EditorMsg.Clear;
      EditorMsg.Lines.Add('Statement(s) successfully executed');
      EditorMsg.Lines.Add('Commit or Rollback active transaction...');
      MonitorState := msActive;
    end;

    if Assigned(FOnAfterRun) then FOnAfterRun(Self);
  end else
  begin
    if Length(DDLCompiler.ErrorText) > 0 then
    begin
      EditorMsg.Clear;
      Designer.TextToStrings(DDLCompiler.ErrorText, EditorMsg.Lines);
      MonitorState := msError;
      if DDLInfo.BTCLDatabase.DatabaseAliasOptions.DDL.AutoCommit then //Еманов
        Rollback;
      ErrorCoord := TBufferCoord(Point(DDLCompiler.ErrorColumn, DDLCompiler.ErrorLine));
    end;
  end;
end;

procedure TibBTDDLForm.ICreate;
begin
  Designer.CreateComponent(DBObject.OwnerIID, DBObject.ClassIID, EmptyStr);
end;

procedure TibBTDDLForm.Alter;
begin
  Designer.ChangeNotification(Component, SCallAlterDDL, opInsert);
end;

procedure TibBTDDLForm.Drop;
begin
  Designer.ChangeNotification(Component, SCallDropDDL, opInsert);
end;

procedure TibBTDDLForm.Recreate;
begin
  Designer.ChangeNotification(Component, SCallRecreateDDL, opInsert);
end;

procedure TibBTDDLForm.Commit;
begin
  DRVTransaction.Commit;
  //
  // Если произошла ошибка
  //
  if Length(DRVTransaction.ErrorText) > 0 then
  begin
    EditorMsg.Clear;
    Designer.TextToStrings(DRVTransaction.ErrorText, EditorMsg.Lines);
    MonitorState := msError;
    Rollback; // TODO: Еманов и Ded говорили, что надо опцию: Commit vs Rollback
    Exit;
  end;
  //
  // Если все хорошо, то
  //
  DDLCompiler.AfterCommit(Component, FSenderClosing);
  //
  // и отрабатываем визуальные элементы
  //
  EditorMsg.Clear;
  if DDLInfo.BTCLDatabase.DatabaseAliasOptions.DDL.AutoCommit then
    EditorMsg.Lines.Add('Statement(s) successfully executed and transaction committed')
  else
    EditorMsg.Lines.Add('Transaction committed.');

  MonitorState := msWrite;
  Editor.Invalidate;
  if DDLInfo.State = csAlter then EditorMsgVisible;
  if Assigned(FOnAfterCommit) then FOnAfterCommit(Self);
end;

procedure TibBTDDLForm.Rollback;
begin
  if Assigned(DRVTransaction) then
   DRVTransaction.Rollback;
  if not GetCanRollback then
  begin
    if MonitorState <> msError then
    begin
      EditorMsg.Clear;
      MonitorState := msWrite;
    end;
    EditorMsgVisible;
    if not (DDLCompiler.ErrorText = 'Invalid DDL statement') then
      EditorMsg.Lines.Add('Transaction rolled back.');
    DDLCompiler.AfterRollback(Component, FSenderClosing);
    if Assigned(FOnAfterRollback) then FOnAfterRollback(Self);
  end;
end;

procedure TibBTDDLForm.Refresh;
begin
(*
  // Только для SourceDDL
  if Assigned(DBObject) and not DBObject.Embedded then
  begin
    DBObject.Refresh;
    Editor.Lines.Clear;
    Editor.Lines.AddStrings(DBObject.SourceDDL);
    MonitorState := msRead;
  end;
*)
  if Assigned(DBObject) then
  begin
    if not DBObject.Embedded then
    begin
      DBObject.Refresh;
      Editor.Lines.Clear;
      Editor.Lines.AddStrings(DBObject.SourceDDL);
      MonitorState := msRead;
    end else
    begin
      case DBObject.State of
      csSource:;
      csCreate:
        begin
        //  if not DDLInfo.BTCLDatabase.DatabaseAliasOptions.DDL.AutoWizard then
        //  begin
            DDLInfo.DDL.Text := DDLGenerator.GetDDLText(DBObject);
            Editor.Lines.Clear;
            Editor.Lines.AddStrings(DDLInfo.DDL);
            Designer.UpdateObjectInspector;
            MonitorState := msRead;
        //  end else
            {Designer.E_xecuteEditor(Component, ISHDDLWizard)};
        end;
      csAlter, csDrop, csRecreate:
        begin
          DDLInfo.DDL.Text := DDLGenerator.GetDDLText(DBObject);
          Editor.Lines.Clear;
          Editor.Lines.AddStrings(DDLInfo.DDL);
          Designer.UpdateObjectInspector;
          MonitorState := msRead;
        end;
      end;
    end;
  end;

(*
        if DBObject.State = csCreate then
        begin
          vCallString := Format('DDL_WIZARD.%s', [AnsiUpperCase(Component.Association)]);
          if Assigned(Designer.GetComponentForm(Component.ClassIID, vCallString)) then
          begin
            Designer.ShowModal(Component, vCallString);
          end else
          begin
            DDLInfo.DDL.Text := DDLGenerator.GetDDLText(DBObject);
            Designer.UpdateObjectInspector;
            Editor.Lines.AddStrings(DDLInfo.DDL);
          end;
        end else
        begin
          DDLInfo.DDL.Text := DDLGenerator.GetDDLText(DBObject);
          Designer.UpdateObjectInspector;
          Editor.Lines.AddStrings(DDLInfo.DDL);
        end;
*)
end;

function TibBTDDLForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;

  EditorMsg.BottomEdgeVisible := True;
  EditorMsg.RightEdge := 0;
  EditorMsg.WordWrap := True;

  if Result then
    if GetCanRollback then Rollback;
end;

procedure TibBTDDLForm.DoOnIdle;
begin
  if not (csDestroying in Self.ComponentState) then
  begin
    // забыл на хуя это надо - разобраться
    if Assigned(DDLInfo) and
      Assigned(DDLInfo.BTCLDatabase) and
      DDLInfo.BTCLDatabase.WasLostConnect and
      (DDLInfo.State <> csSource) and
      (MonitorState <> msError) then
    begin
      MonitorState := msWrite;
      EditorMsg.Lines.Clear;
      EditorMsgVisible(False);
    end;
  end;
end;

procedure TibBTDDLForm.DoSaveAsTemplate;
var
   TemplateDir:string;
   TemplateBody:TStrings;
   ACaption:string;

begin
 if DBObject.Caption='' then
  Exit;
 ACaption:=DBObject.Caption;
 TemplateDir:=GetTemplateDir+'\';
 if DirectoryExists(TemplateDir) then
 if Designer.InputQuery(SInputTemplateName, Format('%s', [SObjectNameNew]), ACaption{, False}) and (Length(ACaption) > 0) then
 try
  TemplateBody:=TStringList.Create;
  TemplateBody.Text:=StringReplace(Editor.Text,DBObject.Caption,'{NAME}',[rfReplaceAll, rfIgnoreCase]);
  TemplateBody.SaveToFile(ChangeFileExt(TemplateDir+ACaption,'.txt'))
 finally
  TemplateBody.Free
 end
end;

procedure TibBTDDLForm.mnSaveAsToTemplateClick(Sender: TObject);
begin
 DoSaveAsTemplate
end;

function TibBTDDLForm.GetCanDestroy: Boolean;
var
  S: string;
begin
  Result := inherited GetCanDestroy;
  //
  // Если был обрыв коннекта, то тихо выходим
  //
  if Assigned(DDLInfo) and
     Assigned(DDLInfo.BTCLDatabase) and
     DDLInfo.BTCLDatabase.WasLostConnect then Exit;
  //
  // Если все в штате, то проверяем состояние
  //
  if Result then
  begin
    S := EmptyStr;
    //
    // Юзер модифицировал текст в редакторе
    //
    if Editor.Modified then
      S := '%s "%s"%sDDL text has been changed.%sShould these changes be compiled and committed?';
    //
    // Висит активная транзакция
    //
    if GetCanCommit then
      S := '%s "%s"%sTransaction is active.%sShould it be committed?';
    //
    // Объект был вызван как "создать новый" и забыт
    //
    if Assigned(DBObject) and not DBObject.Embedded and (DBObject.State = csCreate) and (MonitorState <> msError) and (Length(Editor.Text) > 0) then
      S := '%s "%s"%sObject is being created as the new one.%sShould it be compiled and committed?';
    //
    // Отрабатываем вопросы по состоянию с пользователем
    //
    if Length(S) > 0 then
    begin
      case Designer.ShowMsg(Format(S, [Component.Association, Component.Caption, SLineBreak, SLineBreak])) of
        IDCANCEL:
          Result := False;
        IDYES:
          begin
            FSenderClosing := True;
            try
              if GetCanRun then Run;
              if GetCanCommit then Commit;
            finally
              FSenderClosing := False;
            end;
            Result := not GetCanCommit and (MonitorState <> msError);
          end;
        IDNO:
          begin
            FSenderClosing := True;
            try
              if GetCanRollback then Rollback;
            finally
              FSenderClosing := False;
            end;
            Result := not GetCanRollback;
          end;
      end;
    end;
  end;
end;

function TibBTDDLForm.GetDDLText: TStrings;
begin
  Result := Editor.Lines;
end;

procedure TibBTDDLForm.SetDDLText(Value: TStrings);
begin
  Editor.Lines.Assign(Value);
end;

procedure TibBTDDLForm.PrepareControls;
begin
  DoOnOptionsChanged;

  EditorMsgVisible(False);

  if DDLInfo.State in [csSource{, csRelatedSource}] then
    MonitorState := msRead
  else
    MonitorState := msWrite;
end;

procedure TibBTDDLForm.ShowDDLText;
begin
  if Assigned(DDLInfo) then
  begin
    Editor.Lines.Clear;
    Editor.Lines.AddStrings(DDLInfo.DDL);
  end;
end;

function TibBTDDLForm.GetOnAfterRun: TNotifyEvent;
begin
  Result := FOnAfterRun;
end;

procedure TibBTDDLForm.SetOnAfterRun(Value: TNotifyEvent);
begin
  FOnAfterRun := Value;
end;

function TibBTDDLForm.GetOnAfterCommit: TNotifyEvent;
begin
  Result := FOnAfterCommit;
end;

procedure TibBTDDLForm.SetOnAfterCommit(Value: TNotifyEvent);
begin
  FOnAfterCommit := Value;
end;

function TibBTDDLForm.GetOnAfterRollback: TNotifyEvent;
begin
  Result := FOnAfterRollback;
end;

procedure TibBTDDLForm.SetOnAfterRollback(Value: TNotifyEvent);
begin
  FOnAfterRollback := Value;
end;

procedure TibBTDDLForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  DoOnIdle;
end;

procedure TibBTDDLForm.pmiHideMessageClick(Sender: TObject);
begin
  EditorMsgVisible(False);
end;

{ TibBTDDLFormAction_ }

constructor TibBTDDLFormAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;

  if Self is TibBTDDLFormAction_Run then Tag := 1;
  if Self is TibBTDDLFormAction_Commit then Tag := 2;
  if Self is TibBTDDLFormAction_Rollback then Tag := 3;
  if Self is TibBTDDLFormAction_Refresh then Tag := 4;
  if Self is TibBTDDLFormAction_ExpandDomains then Tag := 5;
  if Self is TibBTDDLFormAction_SaveAsTemplate then Tag := 6;


  case Tag of
    0: Caption := '-'; // separator
    1:
    begin
      Caption := Format('%s', ['Run']);
      ShortCut := TextToShortCut('Ctrl+Enter');
      SecondaryShortCuts.Add('F9');
    end;
    2:
    begin
      Caption := Format('%s', ['Commit']);
      ShortCut := TextToShortCut('Shift+Ctrl+C');
    end;
    3:
    begin
      Caption := Format('%s', ['Rollback']);
      ShortCut := TextToShortCut('Shift+Ctrl+R');
    end;
    4:
    begin
      Caption := Format('%s', ['Refresh']);
      ShortCut := TextToShortCut('F5');
    end;
    5: Caption := Format('%s', ['Expand/Collapse Domains']);
    6: Caption := Format('%s', ['Save As Template']);
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibBTDDLFormAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDomain) or
            IsEqualGUID(AClassIID, IibSHTable) or
            IsEqualGUID(AClassIID, IibSHConstraint) or
            IsEqualGUID(AClassIID, IibSHIndex) or
            IsEqualGUID(AClassIID, IibSHView) or
            IsEqualGUID(AClassIID, IibSHProcedure) or
            IsEqualGUID(AClassIID, IibSHTrigger) or
            IsEqualGUID(AClassIID, IibSHGenerator) or
            IsEqualGUID(AClassIID, IibSHException) or
            IsEqualGUID(AClassIID, IibSHFunction) or
            IsEqualGUID(AClassIID, IibSHFilter) or
            IsEqualGUID(AClassIID, IibSHRole) or
            IsEqualGUID(AClassIID, IibSHSystemDomain) or
            IsEqualGUID(AClassIID, IibSHSystemTable) or
            IsEqualGUID(AClassIID, IibSHSystemTableTmp) or

            IsEqualGUID(AClassIID, IibSHSQLEditor);
end;

procedure TibBTDDLFormAction_.ExpandCollapseDomains;
begin
  (Designer.CurrentComponent as IibSHTable).DecodeDomains := not (Designer.CurrentComponent as IibSHTable).DecodeDomains;
  (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
  if (Designer.CurrentComponent as IibSHTable).DecodeDomains then
    (Designer.CurrentComponentForm as IibSHDDLForm).DDLText.Insert(0, '/* !!! ALL DOMAINS HAVE BEEN DECODED */');
end;

procedure TibBTDDLFormAction_.EventExecute(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) then 
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
    // Commit
    2: (Designer.CurrentComponentForm as ISHRunCommands).Commit;
    // Rollback
    3: (Designer.CurrentComponentForm as ISHRunCommands).Rollback;
    // Refresh
    4: begin
         (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
         if Supports(Designer.CurrentComponent, IibSHTable) and
           (Designer.CurrentComponent as IibSHTable).DecodeDomains then
         (Designer.CurrentComponentForm as IibSHDDLForm).DDLText.Insert(0, '/* !!! ALL DOMAINS HAVE BEEN DECODED */');
       end;
    // Expand Domains
    5: ExpandcollapseDomains;
    6: if Designer.CurrentComponentForm is TibBTDDLForm then
        TibBTDDLForm(Designer.CurrentComponentForm).DoSaveAsTemplate
  end;  
end;

procedure TibBTDDLFormAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibBTDDLFormAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     Supports(Designer.CurrentComponent, IibSHDDLInfo) and
     Supports(Designer.CurrentComponentForm, IibSHDDLForm) and
     (
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallSourceDDL) or
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallCreateDDL) or
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallAlterDDL) or
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallRecreateDDL) or
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallDropDDL) or

     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallDDLText)
     ) then
  begin
    case Tag of
      // Separator
      0:
      begin
        Visible := True;
      end;
      // Run
      1:
      begin
        Visible := not ((Designer.CurrentComponent as IibSHDDLInfo).State in [csSource{,csRelatedSource}]);
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRun;
      end;
      // Commit
      2:
      begin
        Visible := ((Designer.CurrentComponent as IibSHDDLInfo).State <> csSource) and
                   not (Designer.CurrentComponent as IibSHDDLInfo).BTCLDatabase.DatabaseAliasOptions.DDL.AutoCommit;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanCommit;
      end;
      // Rollback
      3:
      begin
        Visible := ((Designer.CurrentComponent as IibSHDDLInfo).State <> csSource) and
                   not (Designer.CurrentComponent as IibSHDDLInfo).BTCLDatabase.DatabaseAliasOptions.DDL.AutoCommit;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRollback;
      end;
      // Refresh
      4:
      begin
        Visible := (Designer.CurrentComponent as IibSHDDLInfo).State = csSource;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRefresh;
      end;
      // Expand Domains
      5:
      begin
        Visible := (Supports(Designer.CurrentComponent, IibSHTable) or
                    Supports(Designer.CurrentComponent, IibSHSystemTable) or
                    Supports(Designer.CurrentComponent, IibSHSystemTableTmp)) and
                   AnsiSameText(Designer.CurrentComponentForm.CallString, SCallSourceDDL);

        Enabled := True;
      end;
      6:
      begin
         Visible := (Designer.CurrentComponent as IibSHDDLInfo).State <> csCreate;
         Enabled := True;
      end;
    end;
  end else
    Visible := False;
end;

initialization

  Register;

end.
