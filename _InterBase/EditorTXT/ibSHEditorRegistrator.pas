unit ibSHEditorRegistrator;

interface

uses Classes, SysUtils, Contnrs, Dialogs,
     SynEdit, SynEditTypes, SynCompletionProposal,
     SHDesignIntf, SHOptionsIntf, SHEvents, ibSHDesignIntf, ibSHConsts,
     pSHIntf, pSHSynEdit, pSHHighlighter, pSHCompletionProposal,
     pSHAutoComplete, pSHParametersHint;

type
  TibBTEditorRegistrator = class(TSHComponent, ISHDemon, IibSHEditorRegistrator)
  private
    FServers: TComponentList;
    FKeywordsManagers: TComponentList;
    FDefaultObjectNamesManagers: TComponentList;
    FEditors: TComponentList;
    {Options}
    FEditorGeneralOptions: ISHEditorGeneralOptions;
    FEditorDisplayOptions: ISHEditorDisplayOptions;
    FEditorColorOptions: ISHEditorColorOptions;
    FEditorCodeInsightOptions: ISHEditorCodeInsightOptions;

    FDatabases: TComponentList;
    FObjectNamesManagers: TComponentList;
    function ExtractComponent(Carrier: IInterface; var AComponent: TComponent): Boolean;
    function GetSubSQLDialect(AServer: IibSHServer): TSQLSubDialect;
    procedure CatchDemons;
    procedure FreeDemons;
    procedure DoApplyEditorOptions(AEditor: TpSHSynEdit);
    procedure DoApplyHighlighterOptions(AHighlighter: TpSHHighlighter);
    procedure DoApplyCompletionProposalOptions(ACompletionProposal: TpSHCompletionProposal);
    procedure DoApplyParametersHintOptions(AParametersHint: TpSHParametersHint);
    procedure DoOnOptionsChanged;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    class function GetClassIIDClassFnc: TGUID; override;

    function ReceiveEvent(AEvent: TSHEvent): Boolean; override;

    function RegisterServer(AServer: IInterface): Integer;
    function RegisterDatabase(ADatabase: IInterface): Integer;

    {IibSHEditorRegistrator}
    procedure AfterChangeServerVersion(Sender: TObject);
    procedure RegisterEditor(AEditor: TComponent; AServer, ADatabase: IInterface);

    function GetKeywordsManager(AServer: IInterface): IInterface;
    function GetObjectNameManager(AServer, ADatabase: IInterface): IInterface;
  end;

implementation

uses SynEditHighlighter, ibSHSimpleFieldListRetriever;

procedure Register;
begin
  SHRegisterComponents([TibBTEditorRegistrator]);
end;

{ TibBTEditorRegistrator }

constructor TibBTEditorRegistrator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FServers := TComponentList.Create;
  FServers.OwnsObjects := False;
  FKeywordsManagers := TComponentList.Create;
  FKeywordsManagers.OwnsObjects := True;
  FDefaultObjectNamesManagers := TComponentList.Create;
  FDefaultObjectNamesManagers.OwnsObjects := True;
  FEditors := TComponentList.Create;
  FEditors.OwnsObjects := False;

  FDatabases := TComponentList.Create;
  FDatabases.OwnsObjects := False;
  FObjectNamesManagers := TComponentList.Create;
  FObjectNamesManagers.OwnsObjects := True;
end;

destructor TibBTEditorRegistrator.Destroy;
begin
  FObjectNamesManagers.Free;
  FDatabases.Free;

  FEditors.Free;
  FDefaultObjectNamesManagers.Free;
  FKeywordsManagers.Free;
  FServers.Free;
  inherited;
end;

function TibBTEditorRegistrator.ExtractComponent(Carrier: IInterface;
  var AComponent: TComponent): Boolean;
var
  ComponentRef: IInterfaceComponentReference;
begin
  Result := Assigned(Carrier) and
    Supports(Carrier, IInterfaceComponentReference, ComponentRef);
  if Result then
    AComponent := ComponentRef.GetComponent
  else
    AComponent := nil;
end;

function TibBTEditorRegistrator.GetSubSQLDialect(AServer: IibSHServer): TSQLSubDialect;
begin
  with AServer do
  begin
    if AnsiSameText(Version, SInterBase4x) then Result := ibdInterBase4 else
    if AnsiSameText(Version, SInterBase5x) then Result := ibdInterBase5 else
    if AnsiSameText(Version, SInterBase6x) then Result := ibdInterBase6 else
    if AnsiSameText(Version, SInterBase65) then Result := ibdInterBase65 else
    if AnsiSameText(Version, SInterBase70) then Result := ibdInterBase7 else
    if AnsiSameText(Version, SInterBase71) then Result := ibdInterBase7 else
    if AnsiSameText(Version, SInterBase75) then Result := ibdInterBase75 else
    if AnsiSameText(Version, SFirebird1x) then Result := ibdFirebird1 else
    if AnsiSameText(Version, SFirebird15) then Result := ibdFirebird15 else
    if AnsiSameText(Version, SFirebird20) then Result := ibdFirebird20 else
    if AnsiSameText(Version, SInterBase2007) then Result := ibdInterbase2007 else
    if AnsiSameText(Version, SFirebird21) then Result := ibdFirebird21 else
      Result := 0;
  end;
end;

procedure TibBTEditorRegistrator.CatchDemons;
begin
  Supports(Designer.GetDemon(ISHEditorGeneralOptions), ISHEditorGeneralOptions, FEditorGeneralOptions);
  Supports(Designer.GetDemon(ISHEditorDisplayOptions), ISHEditorDisplayOptions, FEditorDisplayOptions);
  Supports(Designer.GetDemon(ISHEditorColorOptions), ISHEditorColorOptions, FEditorColorOptions);
  Supports(Designer.GetDemon(ISHEditorCodeInsightOptions), ISHEditorCodeInsightOptions, FEditorCodeInsightOptions);
end;

procedure TibBTEditorRegistrator.FreeDemons;
begin
  if Assigned(FEditorGeneralOptions) then
    FEditorGeneralOptions := nil;
  if Assigned(FEditorDisplayOptions) then
    FEditorDisplayOptions := nil;
  if Assigned(FEditorColorOptions) then
    FEditorColorOptions := nil;
  if Assigned(FEditorCodeInsightOptions) then
    FEditorCodeInsightOptions := nil;
end;


procedure TibBTEditorRegistrator.DoApplyEditorOptions(AEditor: TpSHSynEdit);
  function CaretTypeConv(AOptionCaret: TSHEditorCaretType): TSynEditCaretType;
  begin
    case AOptionCaret of
      VerticalLine: Result := ctVerticalLine;
      HorizontalLine: Result := ctHorizontalLine;
      HalfBlock: Result := ctHalfBlock;
      Block: Result := ctBlock;
      else
         Result := ctVerticalLine;
    end;
  end;
begin
  if Assigned(FEditorGeneralOptions) then
  begin
     if Supports(FEditorCodeInsightOptions,IEditorCodeInsightOptionsExt) then
      AEditor.ShowBeginEndRegions:=
      (FEditorCodeInsightOptions as IEditorCodeInsightOptionsExt).GetShowBeginEndRegions;

    AEditor.HideSelection := FEditorGeneralOptions.HideSelection;
    AEditor.InsertCaret := CaretTypeConv(FEditorGeneralOptions.InsertCaret);
    AEditor.InsertMode := FEditorGeneralOptions.InsertMode;
    AEditor.MaxScrollWidth := FEditorGeneralOptions.MaxLineWidth;
    AEditor.MaxUndo := FEditorGeneralOptions.MaxUndo;
    case FEditorGeneralOptions.OpenLink of
      SingleClick: AEditor.HyperLinkRule := hlrSingleClick;
      CtrlClick: AEditor.HyperLinkRule := hlrCtrlClick;
      DblClick: AEditor.HyperLinkRule := hlrDblClick;
    end;
    AEditor.Options := [eoRightMouseMovesCursor];
    if FEditorGeneralOptions.Options.AltSetsColumnMode then
      AEditor.Options := AEditor.Options + [eoAltSetsColumnMode];
    if FEditorGeneralOptions.Options.AutoIndent then
      AEditor.Options := AEditor.Options + [eoAutoIndent];
    if FEditorGeneralOptions.Options.AutoSizeMaxLeftChar then
      AEditor.Options := AEditor.Options + [eoAutoSizeMaxScrollWidth];
    if FEditorGeneralOptions.Options.DisableScrollArrows then
      AEditor.Options := AEditor.Options + [eoDisableScrollArrows];
    if FEditorGeneralOptions.Options.DragDropEditing then
      AEditor.Options := AEditor.Options + [eoDragDropEditing];
//    if FEditorGeneralOptions.Options.DragDropEditing then
    if FEditorGeneralOptions.Options.EnhanceHomeKey then
      AEditor.Options := AEditor.Options + [eoEnhanceHomeKey];
    if FEditorGeneralOptions.Options.GroupUndo then
      AEditor.Options := AEditor.Options + [eoGroupUndo];
    if FEditorGeneralOptions.Options.HalfPageScroll then
      AEditor.Options := AEditor.Options + [eoHalfPageScroll];
    if FEditorGeneralOptions.Options.HideShowScrollbars then
      AEditor.Options := AEditor.Options + [eoHideShowScrollbars];
    if FEditorGeneralOptions.Options.KeepCaretX then
      AEditor.Options := AEditor.Options + [eoKeepCaretX];
    if FEditorGeneralOptions.Options.NoCaret then
      AEditor.Options := AEditor.Options + [eoNoCaret];
    if FEditorGeneralOptions.Options.NoSelection then
      AEditor.Options := AEditor.Options + [eoNoSelection];
    if FEditorGeneralOptions.Options.ScrollByOneLess then
      AEditor.Options := AEditor.Options + [eoScrollByOneLess];
    if FEditorGeneralOptions.Options.ScrollHintFollows then
      AEditor.Options := AEditor.Options + [eoScrollHintFollows];
    if FEditorGeneralOptions.Options.ScrollPastEof then
      AEditor.Options := AEditor.Options + [eoScrollPastEof];
    if FEditorGeneralOptions.Options.ScrollPastEol then
      AEditor.Options := AEditor.Options + [eoScrollPastEol];
    if FEditorGeneralOptions.Options.ShowScrollHint then
      AEditor.Options := AEditor.Options + [eoShowScrollHint];
    //eoShowSpecialChars
    if FEditorGeneralOptions.Options.SmartTabDelete then
      AEditor.Options := AEditor.Options + [eoSmartTabDelete];
    if FEditorGeneralOptions.Options.SmartTabs then
      AEditor.Options := AEditor.Options + [eoSmartTabs];
    //eoSpecialLineDefaultFg
    if FEditorGeneralOptions.Options.TabIndent then
      AEditor.Options := AEditor.Options + [eoTabIndent];
    if FEditorGeneralOptions.Options.TabsToSpaces then
      AEditor.Options := AEditor.Options + [eoTabsToSpaces];
    if FEditorGeneralOptions.Options.TrimTrailingSpaces then
      AEditor.Options := AEditor.Options + [eoTrimTrailingSpaces];
    AEditor.OverwriteCaret := CaretTypeConv(FEditorGeneralOptions.OverwriteCaret);
    case FEditorGeneralOptions.ScrollHintFormat of
      TopLineOnly: AEditor.ScrollHintFormat := shfTopLineOnly;
      TopToBottom: AEditor.ScrollHintFormat := shfTopToBottom;
    end;
    AEditor.ScrollBars := FEditorGeneralOptions.ScrollBars;
    case FEditorGeneralOptions.SelectionMode of
      Normal: AEditor.SelectionMode := smNormal;
      Line: AEditor.SelectionMode := smLine;
      Column: AEditor.SelectionMode := smColumn;
    end;
    AEditor.TabWidth := FEditorGeneralOptions.TabWidth;
    AEditor.WantReturns := FEditorGeneralOptions.WantReturns;
    AEditor.WantTabs := FEditorGeneralOptions.WantTabs;
    AEditor.WordWrap := FEditorGeneralOptions.WordWrap;
  end;
{!!!!!!!!!

//   Invisible
  OpenedFilesHistory               для run-time сохранения
  DemoLines                        для run-time сохранения
}
  if Assigned(FEditorDisplayOptions) then
  begin
    AEditor.Font.Assign(FEditorDisplayOptions.Font);
    AEditor.Gutter.AutoSize := FEditorDisplayOptions.Gutter.AutoSize;
    AEditor.Gutter.DigitCount := FEditorDisplayOptions.Gutter.DigitCount;
    AEditor.Gutter.Font.Assign(FEditorDisplayOptions.Gutter.Font);
    AEditor.Gutter.LeadingZeros := FEditorDisplayOptions.Gutter.LeadingZeros;
    AEditor.Gutter.LeftOffset := FEditorDisplayOptions.Gutter.LeftOffset;
    AEditor.Gutter.RightOffset := FEditorDisplayOptions.Gutter.RightOffset;
    AEditor.Gutter.ShowLineNumbers := FEditorDisplayOptions.Gutter.ShowLineNumbers;
    AEditor.Gutter.UseFontStyle := FEditorDisplayOptions.Gutter.UseFontStyle;
    AEditor.Gutter.Visible := FEditorDisplayOptions.Gutter.Visible;
    AEditor.Gutter.Width := FEditorDisplayOptions.Gutter.Width;
    AEditor.Gutter.ZeroStart := FEditorDisplayOptions.Gutter.ZeroStart;
    if not FEditorDisplayOptions.Margin.RightEdgeVisible then
      AEditor.RightEdge := 0
    else
      AEditor.RightEdge := FEditorDisplayOptions.Margin.RightEdgeWidth;
    AEditor.BottomEdgeVisible := FEditorDisplayOptions.Margin.BottomEdgeVisible;
  end;
  if Assigned(FEditorColorOptions) then
  begin
    AEditor.Color := FEditorColorOptions.Background;
    AEditor.Gutter.Color := FEditorColorOptions.Gutter;
    AEditor.RightEdgeColor := FEditorColorOptions.RightEdge;
    AEditor.BottomEdgeColor := FEditorColorOptions.BottomEdge;
    AEditor.ActiveLineColor := FEditorColorOptions.CurrentLine;
    AEditor.ScrollHintColor := FEditorColorOptions.ScrollHint;
    AEditor.SelectedColor.Background := FEditorColorOptions.Selected.Background;
    AEditor.SelectedColor.Foreground := FEditorColorOptions.Selected.Foreground;
  end;
end;

procedure TibBTEditorRegistrator.DoApplyHighlighterOptions(
  AHighlighter: TpSHHighlighter);
  procedure FontAttrConv(AFontAttr: TSynHighlighterAttributes; AColorAttr: ISHEditorColorAttr);
  begin
    AFontAttr.Style := AColorAttr.Style;
    AFontAttr.Background := AColorAttr.Background;
    AFontAttr.Foreground := AColorAttr.Foreground;
  end;

begin
  if Assigned(FEditorGeneralOptions) then
    AHighlighter.Enabled := FEditorGeneralOptions.UseHighlight;
  if Assigned(FEditorColorOptions) then
  begin
    with AHighlighter do
    begin
      {!!!!!!}
//      FEditorColorOptions.
      FontAttrConv(CommentAttri, FEditorColorOptions.CommentAttr);
      FontAttrConv(CustomStringsAttri, FEditorColorOptions.CustomStringAttr);
      FontAttrConv(DataTypeAttri, FEditorColorOptions.DataTypeAttr);
      FontAttrConv(IdentifierAttri, FEditorColorOptions.IdentifierAttr);
      FontAttrConv(FunctionAttri, FEditorColorOptions.FunctionAttr);
      FontAttrConv(TableNameAttri, FEditorColorOptions.LinkAttr);
      FontAttrConv(NumberAttri, FEditorColorOptions.NumberAttr);
      FontAttrConv(KeyAttri, FEditorColorOptions.SQLKeywordAttr);
      FontAttrConv(StringAttri, FEditorColorOptions.StringAttr);
      {!!!!!!}
//      FontAttrConv(StringDblQuotedAttri, FEditorColorOptions.StringDblQuotedAttr);
      FontAttrConv(SymbolAttri, FEditorColorOptions.SymbolAttr);
      FontAttrConv(VariableAttri, FEditorColorOptions.VariableAttr);
      FontAttrConv(WrongSymbolAttri, FEditorColorOptions.WrongSymbolAttr);
    end;
  end;
end;

procedure TibBTEditorRegistrator.DoApplyCompletionProposalOptions(
  ACompletionProposal: TpSHCompletionProposal);
begin
  if Assigned(FEditorCodeInsightOptions) then
  begin

    ACompletionProposal.TimerInterval := FEditorCodeInsightOptions.Delay;
    ACompletionProposal.Form.ClSelect := FEditorColorOptions.Selected.Background;
    ACompletionProposal.Form.ClSelectedText := FEditorColorOptions.Selected.Foreground;
  end;
{
ISHEditorCodeInsightOptions
  CodeParameters                   для пропозала
  }
end;

procedure TibBTEditorRegistrator.DoApplyParametersHintOptions(
  AParametersHint: TpSHParametersHint);
begin
  if Assigned(FEditorCodeInsightOptions) then
  begin
    if FEditorCodeInsightOptions.Delay > 0 then
    begin
      AParametersHint.Options := AParametersHint.Options + [scoUseBuiltInTimer];
      AParametersHint.TimerInterval := FEditorCodeInsightOptions.Delay;
    end
    else
      AParametersHint.Options := AParametersHint.Options - [scoUseBuiltInTimer];
  end;
end;

function CodeCaseConv(AEditorCaseCode: TSHEditorCaseCode): TpSHCaseCode;
begin
  case AEditorCaseCode of
    Lower: Result := ccLower;
    Upper: Result := ccUpper;
    NameCase: Result := ccNameCase;
    FirstUpper: Result := ccFirstUpper;
    None: Result := ccNone;
    Invert: Result := ccInvert;
    Toggle: Result := ccToggle;
    else
      Result := ccUpper;
  end;
end;

procedure TibBTEditorRegistrator.DoOnOptionsChanged;
var
  I: Integer;
  vObjectNamesManager: IpSHObjectNamesManager;
  procedure SetOptionsToObjectNameManager(AObjectNamesManager: IpSHObjectNamesManager);
  var
    vCompletionProposalOptions: IpSHCompletionProposalOptions;
  begin
    DoApplyHighlighterOptions(TpSHHighlighter(AObjectNamesManager.Highlighter));
    DoApplyCompletionProposalOptions(TpSHCompletionProposal(AObjectNamesManager.CompletionProposal));
    DoApplyParametersHintOptions(TpSHParametersHint(AObjectNamesManager.ParametersHint));
    if Assigned(FEditorCodeInsightOptions) then
    begin
      AObjectNamesManager.CaseCode := CodeCaseConv(FEditorCodeInsightOptions.CaseCode);
      AObjectNamesManager.CaseSQLCode := CodeCaseConv(FEditorCodeInsightOptions.CaseSQLKeywords);
      if Supports(AObjectNamesManager, IpSHCompletionProposalOptions, vCompletionProposalOptions) then
      begin
        vCompletionProposalOptions.Enabled := FEditorCodeInsightOptions.CodeCompletion;
//        vCompletionProposalOptions.Extended := FEditorCodeInsightOptions.CodeCompletionExt;
      end;
    end;
  end;
begin
  inherited;
  CatchDemons;
  try
    for I := 0 to FEditors.Count - 1 do
      DoApplyEditorOptions(TpSHSynEdit(FEditors[I]));
    for I := 0 to FObjectNamesManagers.Count - 1 do
      if Supports(FObjectNamesManagers[I], IpSHObjectNamesManager, vObjectNamesManager) then
        SetOptionsToObjectNameManager(vObjectNamesManager);
    for I := 0 to FDefaultObjectNamesManagers.Count - 1 do
      if Supports(FDefaultObjectNamesManagers[I], IpSHObjectNamesManager, vObjectNamesManager) then
        SetOptionsToObjectNameManager(vObjectNamesManager);
  finally
    FreeDemons;
  end;
end;

procedure TibBTEditorRegistrator.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
  procedure RemoveEditorLinks;
  begin
    if AComponent is TpSHSynEdit then
    begin
      TpSHSynEdit(AComponent).Highlighter := nil;
      TpSHSynEdit(AComponent).CompletionProposal := nil;
      TpSHSynEdit(AComponent).ParametersHint := nil;
      TpSHSynEdit(AComponent).UserInputHistory := nil;
    end;  
  end;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    I := FServers.IndexOf(AComponent);
    if I <> -1 then
    begin
      FServers.Delete(I);
      FKeywordsManagers.Delete(I);
      FDefaultObjectNamesManagers.Delete(I);
    end;
    I := FDatabases.IndexOf(AComponent);
    if I <> -1 then
    begin
      FDatabases.Delete(I);
      FObjectNamesManagers.Delete(I);
    end;
    FEditors.Remove(AComponent);
//    I := FEditors.IndexOf(AComponent);
//    if I <> -1 then
//    begin
//      RemoveEditorLinks;
//      FEditors.Delete(I);

//    end;
  end;
end;

class function TibBTEditorRegistrator.GetClassIIDClassFnc: TGUID;
begin
  Result := IibSHEditorRegistrator;
end;

function TibBTEditorRegistrator.ReceiveEvent(AEvent: TSHEvent): Boolean;
begin
  with AEvent do
    case Event of
      SHE_OPTIONS_CHANGED: DoOnOptionsChanged;
    end;
  Result := inherited ReceiveEvent(AEvent);
end;

function TibBTEditorRegistrator.RegisterServer(AServer: IInterface): Integer;
var
  vComponent: TComponent;
  vComponentClass: TSHComponentClass;
  vKeywordsManager: IpSHKeywordsManager;
  vObjectNamesManager: IpSHObjectNamesManager;
  vCompletionProposalOptions: IpSHCompletionProposalOptions;
  vBTCLServer: IibSHServer;
begin
//  if ExtractComponent(AServer, vComponent) then
//  begin
    ExtractComponent(AServer, vComponent);
    Result := FServers.IndexOf(vComponent);
    if Result = -1 then
    begin
      Result := FServers.Add(vComponent);
      if Assigned(vComponent) then
        vComponent.FreeNotification(Self);
      vComponentClass := Designer.GetComponent(IpSHKeywordsManager);
      if Assigned(vComponentClass) then
        FKeywordsManagers.Add(vComponentClass.Create(nil))
      else
        FKeywordsManagers.Add(nil);
      vComponentClass := Designer.GetComponent(IpSHObjectNamesManager);
      if Assigned(vComponentClass) then
        FDefaultObjectNamesManagers.Add(vComponentClass.Create(nil))
      else
        FDefaultObjectNamesManagers.Add(nil);
      if Supports(FDefaultObjectNamesManagers[Result], IpSHObjectNamesManager, vObjectNamesManager) then
      begin
        CatchDemons;
        try
          DoApplyHighlighterOptions(TpSHHighlighter(vObjectNamesManager.Highlighter));
          DoApplyCompletionProposalOptions(TpSHCompletionProposal(vObjectNamesManager.CompletionProposal));
          if Assigned(FEditorCodeInsightOptions) then
          begin
            vObjectNamesManager.CaseCode := CodeCaseConv(FEditorCodeInsightOptions.CaseCode);
            vObjectNamesManager.CaseSQLCode := CodeCaseConv(FEditorCodeInsightOptions.CaseSQLKeywords);
            if Supports(FDefaultObjectNamesManagers[Result], IpSHCompletionProposalOptions, vCompletionProposalOptions) then
            begin
              vCompletionProposalOptions.Enabled := FEditorCodeInsightOptions.CodeCompletion;
//              vCompletionProposalOptions.Extended := FEditorCodeInsightOptions.CodeCompletionExt;
            end;
          end;
        finally
          FreeDemons;
        end;  
        if Supports(AServer, IibSHServer, vBTCLServer) then
          (vObjectNamesManager.Highlighter as TpSHHighlighter).SQLSubDialect := GetSubSQLDialect(vBTCLServer)
        else
          (vObjectNamesManager.Highlighter as TpSHHighlighter).SQLSubDialect := ibdInterBase5;

        if Supports(FKeywordsManagers[Result], IpSHKeywordsManager, vKeywordsManager) then
          (vObjectNamesManager.Highlighter as TpSHHighlighter).KeywordsManager := vKeywordsManager;
      end;
    end;
//  end
//  else
//    Result := -1;
end;

function TibBTEditorRegistrator.RegisterDatabase(ADatabase: IInterface): Integer;
var
  vComponent: TComponent;
  vComponentClass: TSHComponentClass;
  vObjectNamesManager: IpSHObjectNamesManager;
  vKeywordsManager: IpSHKeywordsManager;
  vCompletionProposalOptions: IpSHCompletionProposalOptions;
  vBTCLServer: IibSHServer;
  vBTCLDatabase: IibSHDatabase;
begin
//  if ExtractComponent(ADatabase, vComponent) then
//  begin
    ExtractComponent(ADatabase, vComponent);
    Result := FDatabases.IndexOf(vComponent);
    if Result = -1 then
    begin
      Result := FDatabases.Add(vComponent);
      if Assigned(vComponent) then
        vComponent.FreeNotification(Self);
      vComponentClass := Designer.GetComponent(IpSHObjectNamesManager);
      if Assigned(vComponentClass) then
        FObjectNamesManagers.Add(vComponentClass.Create(nil))
      else
        FObjectNamesManagers.Add(nil);
      if Supports(FObjectNamesManagers[Result], IpSHObjectNamesManager, vObjectNamesManager) then
        vObjectNamesManager.ObjectNamesRetriever := ADatabase;
//      if Supports(vComponent, IibSHDatabase, vBTCLDatabase) and
//         Supports(GetKeywordsManager(vBTCLDatabase.BTCLServer),
//           IpSHKeywordsManager, vKeywordsManager) and
//         Assigned(vObjectNamesManager) then
      if Supports(vComponent, IibSHDatabase, vBTCLDatabase) then
        Supports(GetKeywordsManager(vBTCLDatabase.BTCLServer), IpSHKeywordsManager, vKeywordsManager)
      else
        Supports(GetKeywordsManager(nil), IpSHKeywordsManager, vKeywordsManager);

      if Assigned(vObjectNamesManager) and Assigned(vKeywordsManager) then
      begin
        CatchDemons;
        try
          DoApplyHighlighterOptions(TpSHHighlighter(vObjectNamesManager.Highlighter));
          DoApplyCompletionProposalOptions(TpSHCompletionProposal(vObjectNamesManager.CompletionProposal));
          if Assigned(FEditorCodeInsightOptions) then
          begin
            vObjectNamesManager.CaseCode := CodeCaseConv(FEditorCodeInsightOptions.CaseCode);
            vObjectNamesManager.CaseSQLCode := CodeCaseConv(FEditorCodeInsightOptions.CaseSQLKeywords);
            if Supports(FObjectNamesManagers[Result], IpSHCompletionProposalOptions, vCompletionProposalOptions) then
            begin
              vCompletionProposalOptions.Enabled := FEditorCodeInsightOptions.CodeCompletion;
//              vCompletionProposalOptions.Extended := FEditorCodeInsightOptions.CodeCompletionExt;
            end;
          end;
        finally
          FreeDemons;
        end;        
        if Assigned(vBTCLDatabase) and Supports(vBTCLDatabase.BTCLServer, IibSHServer, vBTCLServer) then
          (vObjectNamesManager.Highlighter as TpSHHighlighter).SQLSubDialect := GetSubSQLDialect(vBTCLServer)
        else
          (vObjectNamesManager.Highlighter as TpSHHighlighter).SQLSubDialect := ibdInterBase5;
        (vObjectNamesManager.Highlighter as TpSHHighlighter).KeywordsManager := vKeywordsManager;
      end;
    end;
//  end
//  else
//    Result := -1;
end;

procedure TibBTEditorRegistrator.AfterChangeServerVersion(Sender: TObject);
var
  vServer: IibSHServer;
  vKeywordsManager: IpSHKeywordsManager;
  I: Integer;
begin
  //
  // В Sender приезжает экземпляр TibSHServer
  //
  I := FServers.IndexOf(Sender as TComponent);
  if (I <> -1) and
     Supports(Sender, IibSHServer, vServer) and
     Supports(FKeywordsManagers[I], IpSHKeywordsManager, vKeywordsManager) then
       vKeywordsManager.ChangeSubSQLDialectTo(GetSubSQLDialect(vServer));
end;

procedure TibBTEditorRegistrator.RegisterEditor(AEditor: TComponent;
  AServer, ADatabase: IInterface);
var
  vObjectNamesManager: IpSHObjectNamesManager;
  vAutoCompleteReplace: IpSHAutoComplete;
  I: Integer;
  vFieldListRetriever: TibBTSimpleFieldListRetriever;
  procedure SetEditorLinks;
  var
    vUserInputHistory: IpSHUserInputHistory;
    vUseHighlight: Boolean;
  begin

    vUseHighlight := True;
    if Supports(Designer.GetDemon(ISHEditorGeneralOptions), ISHEditorGeneralOptions, FEditorGeneralOptions) then
    begin
      vUseHighlight := FEditorGeneralOptions.UseHighlight;
      FreeDemons;
    end;
    if vUseHighlight then
      TpSHSynEdit(AEditor).Highlighter :=
        vObjectNamesManager.Highlighter as TpSHHighlighter
    else
      TpSHSynEdit(AEditor).Highlighter := nil;
    TpSHSynEdit(AEditor).CompletionProposal :=
      vObjectNamesManager.CompletionProposal as TpSHCompletionProposal;
    TpSHSynEdit(AEditor).ParametersHint :=
      vObjectNamesManager.ParametersHint as TpSHParametersHint;
    if Supports(vObjectNamesManager, IpSHUserInputHistory, vUserInputHistory) then
      TpSHSynEdit(AEditor).UserInputHistory := vUserInputHistory;
  end;
  procedure RemoveEditorLinks;
  begin
    TpSHSynEdit(AEditor).Highlighter := nil;
    TpSHSynEdit(AEditor).CompletionProposal := nil;
    TpSHSynEdit(AEditor).ParametersHint := nil;
    TpSHSynEdit(AEditor).UserInputHistory := nil;
  end;
begin
  if Assigned(AEditor) then
  begin
    if FEditors.IndexOf(AEditor) = -1 then
    begin
      FEditors.Add(AEditor);
      CatchDemons;
      try
        DoApplyEditorOptions(TpSHSynEdit(AEditor));
      finally
        FreeDemons;
      end;
      AEditor.FreeNotification(Self);
    end;
    if Supports(Designer.GetDemon(IibSHAutoComplete), IpSHAutoComplete, vAutoCompleteReplace) then
    begin
      vFieldListRetriever := TibBTSimpleFieldListRetriever.Create(nil);
      vFieldListRetriever.Database := ADatabase;
      TpSHAutoComplete(vAutoCompleteReplace.GetAutoComplete).AddEditor(TpSHSynEdit(AEditor), vFieldListRetriever);
    end;
    if Supports(Designer.GetDemon(IibSHAutoReplace), IpSHAutoComplete, vAutoCompleteReplace) then
      TpSHAutoComplete(vAutoCompleteReplace.GetAutoComplete).AddEditor(TpSHSynEdit(AEditor));
    I := RegisterDatabase(ADatabase);
    if (I <> -1) and
      Supports(FObjectNamesManagers[I], IpSHObjectNamesManager, vObjectNamesManager) then
      SetEditorLinks
    else
    begin
      I := RegisterServer(AServer);
      if (I <> -1) and
        Supports(FDefaultObjectNamesManagers[I], IpSHObjectNamesManager, vObjectNamesManager) then
        SetEditorLinks
      else
        RemoveEditorLinks;
    end;
  end;
end;

function TibBTEditorRegistrator.GetKeywordsManager(
  AServer: IInterface): IInterface;
var
  I: Integer;
begin
  Result := nil;
  I := RegisterServer(AServer);
  if I <> -1 then
    Supports(FKeywordsManagers[I], IpSHKeywordsManager, Result);
end;

function TibBTEditorRegistrator.GetObjectNameManager(AServer,
  ADatabase: IInterface): IInterface;
var
  I: Integer;
begin
  Result := nil;
  I := RegisterDatabase(ADatabase);
  if I <> -1 then
    Supports(FObjectNamesManagers[I], IpSHObjectNamesManager, Result);
  if not Assigned(Result) then
  begin
    I := RegisterServer(AServer);
    if I <> -1 then
      Supports(FDefaultObjectNamesManagers[I], IpSHObjectNamesManager, Result);
  end;
end;

initialization

  Register;

end.


