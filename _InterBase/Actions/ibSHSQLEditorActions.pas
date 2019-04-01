unit ibSHSQLEditorActions;

interface

uses
  SysUtils, Classes, Dialogs, Menus,
  SHDesignIntf, ibSHDesignIntf;

type
  TibSHSQLEditorPaletteAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHSQLEditorFormAction = class(TSHAction)
  private
    function GetCallString: string;
    function GetComponentFormClass: TSHComponentFormClass;
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;

    property CallString: string read GetCallString;
    property ComponentFormClass: TSHComponentFormClass read GetComponentFormClass;
  end;

  TibSHSQLEditorToolbarAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibSHSQLEditorEditorAction = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  // Forms
  TibSHSQLEditorFormAction_SQLText = class(TibSHSQLEditorFormAction)
  end;
  TibSHSQLEditorFormAction_QueryResults = class(TibSHSQLEditorFormAction)
  end;
  TibSHSQLEditorFormAction_BlobEditor = class(TibSHSQLEditorFormAction)
  end;
  TibSHSQLEditorFormAction_DataForm = class(TibSHSQLEditorFormAction)
  end;
  TibSHSQLEditorFormAction_QueryStatistics = class(TibSHSQLEditorFormAction)
  end;
  TibSHSQLEditorFormAction_DDLText = class(TibSHSQLEditorFormAction)
  end;

  //Toolbar
  TibSHSQLEditorToolbarAction_PrevQuery = class(TibSHSQLEditorToolbarAction_)
  end;
  TibSHSQLEditorToolbarAction_NextQuery = class(TibSHSQLEditorToolbarAction_)
  end;
  TibSHSQLEditorToolbarAction_Run = class(TibSHSQLEditorToolbarAction_)
  end;
  TibSHSQLEditorToolbarAction_RunAndFetchAll = class(TibSHSQLEditorToolbarAction_)
  end;
  TibSHSQLEditorToolbarAction_Prepare = class(TibSHSQLEditorToolbarAction_)
  end;
  TibSHSQLEditorToolbarAction_EndTransactionSeparator = class(TibSHSQLEditorToolbarAction_)
  end;
  TibSHSQLEditorToolbarAction_Commit = class(TibSHSQLEditorToolbarAction_)
  end;
  TibSHSQLEditorToolbarAction_Rollback = class(TibSHSQLEditorToolbarAction_)
  end;

  //Editors
  TibSHSQLEditorEditorAction_LoadLastContext = class(TibSHSQLEditorEditorAction)
  end;
  TibSHSQLEditorEditorAction_RecordCount = class(TibSHSQLEditorEditorAction)
  end;
  TibSHSQLEditorEditorAction_CreateNew = class(TibSHSQLEditorEditorAction)
  end;

implementation

uses
  ibSHConsts,
  ibSHDDLFrm, ibSHDataGridFrm, ibSHDataBlobFrm, ibSHDataVCLFrm, ibSHSQLEditorFrm,
  ibSHStatisticsFrm;

{ TibSHSQLEditorPaletteAction }

constructor TibSHSQLEditorPaletteAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallPalette;
  Category := Format('%s', ['Tools']);
  Caption := Format('%s', ['SQL Editor']);
  ShortCut := TextToShortCut('Shift+Ctrl+F9');  
end;

function TibSHSQLEditorPaletteAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(IibSHBranch, AClassIID) or IsEqualGUID(IfbSHBranch, AClassIID);
end;

procedure TibSHSQLEditorPaletteAction.EventExecute(Sender: TObject);
begin
  Designer.CreateComponent(Designer.CurrentDatabase.InstanceIID, IibSHSQLEditor, EmptyStr);
end;

procedure TibSHSQLEditorPaletteAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHSQLEditorPaletteAction.EventUpdate(Sender: TObject);
begin
  Enabled := Assigned(Designer.CurrentDatabase) and
            (Designer.CurrentDatabase as ISHRegistration).Connected and
             SupportComponent(Designer.CurrentDatabase.BranchIID);
end;

{ TibSHSQLEditorFormAction }

constructor TibSHSQLEditorFormAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallForm;
  Caption := '-'; // separator

  Caption := CallString;
  SHRegisterComponentForm(IibSHSQLEditor, CallString, ComponentFormClass);
end;

function TibSHSQLEditorFormAction.GetCallString: string;
begin
  Result := EmptyStr;

  if Self is TibSHSQLEditorFormAction_SQLText then Result := SCallSQLText else
  if Self is TibSHSQLEditorFormAction_QueryResults then Result := SCallQueryResults else
  if Self is TibSHSQLEditorFormAction_BlobEditor then Result := SCallDataBLOB else
  if Self is TibSHSQLEditorFormAction_DataForm then Result := SCallDataForm else
  if Self is TibSHSQLEditorFormAction_QueryStatistics then Result := SCallQueryStatistics else
  if Self is TibSHSQLEditorFormAction_DDLText then Result := SCallDDLText;

end;

function TibSHSQLEditorFormAction.GetComponentFormClass: TSHComponentFormClass;
begin
  Result := nil;

  if AnsiSameText(CallString, SCallSQLText) then Result := TibSHSQLEditorForm else
  if AnsiSameText(CallString, SCallQueryResults) then Result := TibSHDataGridForm else
  if AnsiSameText(CallString, SCallDataBLOB) then Result := TibSHDataBlobForm else
  if AnsiSameText(CallString, SCallDataForm) then Result := TibSHDataVCLForm else
  if AnsiSameText(CallString, SCallQueryStatistics) then Result := TibBTStatisticsForm else
  if AnsiSameText(CallString, SCallDDLText) then Result := TibBTDDLForm;
end;

function TibSHSQLEditorFormAction.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHSQLEditor);
end;

procedure TibSHSQLEditorFormAction.EventExecute(Sender: TObject);
begin
  Designer.ChangeNotification(Designer.CurrentComponent, CallString, opInsert);
end;

procedure TibSHSQLEditorFormAction.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibSHSQLEditorFormAction.EventUpdate(Sender: TObject);
begin
  FDefault := Assigned(Designer.CurrentComponentForm) and
              AnsiSameText(CallString, Designer.CurrentComponentForm.CallString);
end;

{ TibSHSQLEditorToolbarAction_ }

constructor TibSHSQLEditorToolbarAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;
  Caption := '-';

  if Self is TibSHSQLEditorToolbarAction_PrevQuery then Tag := 1;
  if Self is TibSHSQLEditorToolbarAction_NextQuery then Tag := 2;
  if Self is TibSHSQLEditorToolbarAction_Run then Tag := 3;
  if Self is TibSHSQLEditorToolbarAction_RunAndFetchAll then Tag := 4;
  if Self is TibSHSQLEditorToolbarAction_Prepare then Tag := 5;
  if Self is TibSHSQLEditorToolbarAction_EndTransactionSeparator then Tag := 6;
  if Self is TibSHSQLEditorToolbarAction_Commit then Tag := 7;
  if Self is TibSHSQLEditorToolbarAction_Rollback then Tag := 8;

  case Tag of
    1: Caption := Format('%s', ['Previous Query']);
    2: Caption := Format('%s', ['Next Query']);
    3:
    begin
      Caption := Format('%s', ['Run']);
      ShortCut := TextToShortCut('F9');
// Buzz Ctrl+Enter задействован на клавиатурный переход по линку      
//      SecondaryShortCuts.Add('F9');
    end;
    4: Caption := Format('%s', ['Run and Fetch All']);
    5:
    begin
      Caption := Format('%s', ['Prepare']);
      ShortCut := TextToShortCut('Ctrl+F9');
    end;
    6: ;
    7:
    begin
      Caption := Format('%s', ['Commit']);
      ShortCut := TextToShortCut('Shift+Ctrl+C');
    end;
    8:
    begin
      Caption := Format('%s', ['Rollback']);
      ShortCut := TextToShortCut('Shift+Ctrl+R');
    end;
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibSHSQLEditorToolbarAction_.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHSQLEditor);
end;

procedure TibSHSQLEditorToolbarAction_.EventExecute(Sender: TObject);
begin
  if Supports(Designer.CurrentComponentForm, IibSHSQLEditorForm) then
    case Tag of
      // PrevQuery
      1: (Designer.CurrentComponentForm as IibSHSQLEditorForm).PreviousQuery;
      // NextQuery
      2: (Designer.CurrentComponentForm as IibSHSQLEditorForm).NextQuery;
      // Run
      3: (Designer.CurrentComponentForm as ISHRunCommands).Run;
      // RunAndFetchAll
      4: (Designer.CurrentComponentForm as IibSHSQLEditorForm).RunAndFetchAll;
      // Prepare
      5: (Designer.CurrentComponentForm as IibSHSQLEditorForm).Prepare;
      // CommitRollbackSeparator
      6: ;
      // Commit
      7: (Designer.CurrentComponentForm as ISHRunCommands).Commit;
      // Rollback
      8: (Designer.CurrentComponentForm as ISHRunCommands).Rollback;
    end;
end;

procedure TibSHSQLEditorToolbarAction_.EventHint(var HintStr: String;
  var CanShow: Boolean);
begin
end;

procedure TibSHSQLEditorToolbarAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallSQLText) and
     Supports(Designer.CurrentComponentForm, IibSHSQLEditorForm) then
  begin
    case Tag of
      // Separator
      0:
      begin
        Visible := True;
      end;
      // PrevQuery
      1:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as IibSHSQLEditorForm).GetCanPreviousQuery;
      end;
      // NextQuery
      2:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as IibSHSQLEditorForm).GetCanNextQuery;
      end;
      // Run
      3:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).GetCanRun;
      end;
      // RunAndFetchAll
      4:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).GetCanRun;
      end;
      // Prepare
      5:
      begin
        Visible := True;
        Enabled := (Designer.CurrentComponentForm as IibSHSQLEditorForm).GetCanPrepare;
      end;
      // CommitRollbackSeparator
      6:
      begin
        Visible := (Designer.CurrentComponentForm as IibSHSQLEditorForm).GetCanEndTransaction;
      end;
      // Commit
      7:
      begin
        Visible := (Designer.CurrentComponentForm as IibSHSQLEditorForm).GetCanEndTransaction;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).GetCanCommit;
      end;
      // Rollback
      8:
      begin
        Visible := (Designer.CurrentComponentForm as IibSHSQLEditorForm).GetCanEndTransaction;
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).GetCanRollback;
      end;
    end;
  end else
    Visible := False;
end;

{ TibSHSQLEditorEditorAction }

constructor TibSHSQLEditorEditorAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallEditor;

  if Self is TibSHSQLEditorEditorAction_LoadLastContext then Tag := 1;
  if Self is TibSHSQLEditorEditorAction_RecordCount then Tag := 2;
  if Self is TibSHSQLEditorEditorAction_CreateNew then Tag := 3;

  case Tag of
    0: Caption := '-'; // separator
    1: Caption := SCallLoadLastContext;
    2: Caption := SCallRecordCount;
    3:
    begin
      Caption := SCallCreateNew;
      ShortCut := TextToShortCut('Shift+F4');
    end;
  end;
end;

function TibSHSQLEditorEditorAction.SupportComponent(
  const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHSQLEditor);
end;

procedure TibSHSQLEditorEditorAction.EventExecute(Sender: TObject);
var
  vComponent: TSHComponent;
begin
  if Supports(Designer.CurrentComponent, IibSHSQLEditor) then
    case Tag of
      // SCallLoadLastContext
      1:
      begin
        if Assigned(Designer.CurrentComponentForm) and
          not AnsiSameText(Designer.CurrentComponentForm.CallString, SCallSQLText) then
          Designer.ChangeNotification(Designer.CurrentComponent, SCallSQLText, opInsert);
        if Supports(Designer.CurrentComponentForm, IibSHSQLEditorForm) then
          (Designer.CurrentComponentForm as IibSHSQLEditorForm).LoadLastContext;
      end;
      // SCallRecordCount
      2:
      begin
        (Designer.CurrentComponent as IibSHSQLEditor).SetRecordCount;
        if (Length((Designer.CurrentComponent as IibSHSQLEditor).RecordCountFrmt) > 0) then
          Designer.ShowMsg(Format('Record Count: %s',
          [(Designer.CurrentComponent as IibSHSQLEditor).RecordCountFrmt]), mtInformation);
      end;
      // SCallCreateNew
      3:
      begin
        vComponent := Designer.CreateComponent(
                        Designer.CurrentComponent.OwnerIID,
                        Designer.CurrentComponent.ClassIID,
                        EmptyStr);
        Designer.ChangeNotification(vComponent, opInsert);
      end;
    end;
end;

procedure TibSHSQLEditorEditorAction.EventHint(var HintStr: String;
  var CanShow: Boolean);
begin
  CanShow := False;
  if Supports(Designer.CurrentComponent, IibSHSQLEditor) then
    case Tag of
      // SCallLoadLastContext
      1: ;
      // SCallRecordCount
      2:
      if (Length((Designer.CurrentComponent as IibSHSQLEditor).RecordCountFrmt) > 0) then
      begin
        HintStr := (Format('Last Record Count: %s',
          [(Designer.CurrentComponent as IibSHSQLEditor).RecordCountFrmt]));
        CanShow := True;
      end;
      3: ;
    end;
end;

procedure TibSHSQLEditorEditorAction.EventUpdate(Sender: TObject);
begin
  if Supports(Designer.CurrentComponent, IibSHSQLEditor) then
    case Tag of
      1: Enabled := True;
      2:
      Enabled := Assigned(Designer.CurrentComponentForm) and
        AnsiSameText(Designer.CurrentComponentForm.CallString, SCallSQLText);
      3:
      begin
        if Assigned(Designer.CurrentComponent) then
           Caption := Format('%s %s...', [SCallCreateNew, 'Editor']);
        Enabled := True;
      end;
    end;
end;

end.

