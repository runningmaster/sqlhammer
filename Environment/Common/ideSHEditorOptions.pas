unit ideSHEditorOptions;

interface

uses
  Windows, SysUtils, Classes, Graphics, StdCtrls, DesignIntf, TypInfo,
  SHDesignIntf, SHOptionsIntf;

type
  // E D I T O R  G E N E R A L ===============================================>
  TSHEditorOptions = class;
  TSHEditorGeneralOptions = class(TSHComponentOptions, ISHEditorGeneralOptions)
  private
    FHideSelection: Boolean;
    FInsertCaret: TSHEditorCaretType;
    FInsertMode: Boolean;
    FMaxLineWidth: Integer;
    FMaxUndo: Integer;
    FOpenLink: TSHEditorLinkOption;
    FOptions: TSHEditorOptions;
    FOverwriteCaret: TSHEditorCaretType;
    FScrollHintFormat: TSHEditorScrollHintFormat;
    FScrollBars: TScrollStyle;
    FSelectionMode: TSHEditorSelectionMode;
    FTabWidth: Integer;
    FUseHighlight: Boolean;
    FWantReturns: Boolean;
    FWantTabs: Boolean;
    FWordWrap: Boolean;
    { Invisible }
    FOpenedFilesHistory: TStrings;
    FFindTextHistory: TStrings;
    FReplaceTextHistory: TStrings;
    FLineNumberHistory: TStrings;
    FDemoLines: TStrings;
    FPromtOnReplace: Boolean;
    // -> ISHEditorGeneralOptions
    function GetHideSelection: Boolean;
    procedure SetHideSelection(Value: Boolean);
    function GetUseHighlight: Boolean;
    procedure SetUseHighlight(Value: Boolean);
    function GetInsertCaret: TSHEditorCaretType;
    procedure SetInsertCaret(Value: TSHEditorCaretType);
    function GetInsertMode: Boolean;
    procedure SetInsertMode(Value: Boolean);
    function GetMaxLineWidth: Integer;
    procedure SetMaxLineWidth(Value: Integer);
    function GetMaxUndo: Integer;
    procedure SetMaxUndo(Value: Integer);
    function GetOpenLink: TSHEditorLinkOption;
    procedure SetOpenLink(Value: TSHEditorLinkOption);
    function GetOptions: ISHEditorOptions;
    function GetOverwriteCaret: TSHEditorCaretType;
    procedure SetOverwriteCaret(Value: TSHEditorCaretType);
    function GetScrollHintFormat: TSHEditorScrollHintFormat;
    procedure SetScrollHintFormat(Value: TSHEditorScrollHintFormat);
    function GetScrollBars: TScrollStyle;
    procedure SetScrollBars(Value: TScrollStyle);
    function GetSelectionMode: TSHEditorSelectionMode;
    procedure SetSelectionMode(Value: TSHEditorSelectionMode);
    function GetTabWidth: Integer;
    procedure SetTabWidth(Value: Integer);
    function GetWantReturns: Boolean;
    procedure SetWantReturns(Value: Boolean);
    function GetWantTabs: Boolean;
    procedure SetWantTabs(Value: Boolean);
    function GetWordWrap: Boolean;
    procedure SetWordWrap(Value: Boolean);
    function GetOpenedFilesHistory: TStrings;
    function GetFindTextHistory: TStrings;
    function GetReplaceTextHistory: TStrings;
    function GetLineNumberHistory: TStrings;
    function GetDemoLines: TStrings;
    function GetPromtOnReplace: Boolean;
    procedure SetPromtOnReplace(Value: Boolean);
  protected
    function GetCategory: string; override;
    procedure RestoreDefaults; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property HideSelection: Boolean read FHideSelection write FHideSelection;
    property InsertCaret: TSHEditorCaretType read FInsertCaret write FInsertCaret;
    property InsertMode: Boolean read FInsertMode write FInsertMode;
    property MaxLineWidth: Integer read FMaxLineWidth write FMaxLineWidth;
    property MaxUndo: Integer read FMaxUndo write FMaxUndo;
    property OpenLink: TSHEditorLinkOption read FOpenLink write FOpenLink;
    property Options: TSHEditorOptions read FOptions write FOptions;
    property OverwriteCaret: TSHEditorCaretType read FOverwriteCaret write FOverwriteCaret;
    property ScrollHintFormat: TSHEditorScrollHintFormat read FScrollHintFormat write FScrollHintFormat;
    property ScrollBars: TScrollStyle read FScrollBars write FScrollBars;
    property SelectionMode: TSHEditorSelectionMode read FSelectionMode write FSelectionMode;
    property TabWidth: Integer read FTabWidth write FTabWidth;
    property UseHighlight: Boolean read FUseHighlight write FUseHighlight;
    property WantReturns: Boolean read FWantReturns write FWantReturns;
    property WantTabs: Boolean read FWantTabs write FWantTabs;
    property WordWrap: Boolean read FWordWrap write FWordWrap;

    { Invisible }
    property OpenedFilesHistory: TStrings read FOpenedFilesHistory write FOpenedFilesHistory;
    property FindTextHistory: TStrings read FFindTextHistory write FFindTextHistory;
    property ReplaceTextHistory: TStrings read FReplaceTextHistory write FReplaceTextHistory;
    property LineNumberHistory: TStrings read FLineNumberHistory write FLineNumberHistory;
    property DemoLines: TStrings read FDemoLines write FDemoLines;
    property PromtOnReplace: Boolean read FPromtOnReplace write FPromtOnReplace;
  end;

  TSHEditorOptions = class(TSHInterfacedPersistent, ISHEditorOptions)
  private
    FAltSetsColumnMode: Boolean;
    FAutoIndent: Boolean;
    FAutoSizeMaxLeftChar: Boolean;
    FDisableScrollArrows: Boolean;
    FDragDropEditing: Boolean;
    FEnhanceHomeKey: Boolean;
    FGroupUndo: Boolean;
    FHalfPageScroll: Boolean;
    FHideShowScrollbars: Boolean;
    FKeepCaretX: Boolean;
    FNoCaret: Boolean;
    FNoSelection: Boolean;
    FScrollByOneLess: Boolean;
    FScrollHintFollows: Boolean;
    FScrollPastEof: Boolean;
    FScrollPastEol: Boolean;
    FShowScrollHint: Boolean;
    FSmartTabDelete: Boolean;
    FSmartTabs: Boolean;
    FTabIndent: Boolean;
    FTabsToSpaces: Boolean;
    FTrimTrailingSpaces: Boolean;
    // -> ISHEditorOptions
    function GetAltSetsColumnMode: Boolean;
    procedure SetAltSetsColumnMode(Value: Boolean);
    function GetAutoIndent: Boolean;
    procedure SetAutoIndent(Value: Boolean);
    function GetAutoSizeMaxLeftChar: Boolean;
    procedure SetAutoSizeMaxLeftChar(Value: Boolean);
    function GetDisableScrollArrows: Boolean;
    procedure SetDisableScrollArrows(Value: Boolean);
    function GetDragDropEditing: Boolean;
    procedure SetDragDropEditing(Value: Boolean);
    function GetEnhanceHomeKey: Boolean;
    procedure SetEnhanceHomeKey(Value: Boolean);
    function GetGroupUndo: Boolean;
    procedure SetGroupUndo(Value: Boolean);
    function GetHalfPageScroll: Boolean;
    procedure SetHalfPageScroll(Value: Boolean);
    function GetHideShowScrollbars: Boolean;
    procedure SetHideShowScrollbars(Value: Boolean);
    function GetKeepCaretX: Boolean;
    procedure SetKeepCaretX(Value: Boolean);
    function GetNoCaret: Boolean;
    procedure SetNoCaret(Value: Boolean);
    function GetNoSelection: Boolean;
    procedure SetNoSelection(Value: Boolean);
    function GetScrollByOneLess: Boolean;
    procedure SetScrollByOneLess(Value: Boolean);
    function GetScrollHintFollows: Boolean;
    procedure SetScrollHintFollows(Value: Boolean);
    function GetScrollPastEof: Boolean;
    procedure SetScrollPastEof(Value: Boolean);
    function GetScrollPastEol: Boolean;
    procedure SetScrollPastEol(Value: Boolean);
    function GetShowScrollHint: Boolean;
    procedure SetShowScrollHint(Value: Boolean);
    function GetSmartTabDelete: Boolean;
    procedure SetSmartTabDelete(Value: Boolean);
    function GetSmartTabs: Boolean;
    procedure SetSmartTabs(Value: Boolean);
    function GetTabIndent: Boolean;
    procedure SetTabIndent(Value: Boolean);
    function GetTabsToSpaces: Boolean;
    procedure SetTabsToSpaces(Value: Boolean);
    function GetTrimTrailingSpaces: Boolean;
    procedure SetTrimTrailingSpaces(Value: Boolean);
  published
    property AltSetsColumnMode: Boolean read FAltSetsColumnMode write FAltSetsColumnMode;
    property AutoIndent: Boolean read FAutoIndent write FAutoIndent;
    property AutoSizeMaxLeftChar: Boolean read FAutoSizeMaxLeftChar write FAutoSizeMaxLeftChar;
    property DisableScrollArrows: Boolean read FDisableScrollArrows write FDisableScrollArrows;
    property DragDropEditing: Boolean read FDragDropEditing write FDragDropEditing;
    property EnhanceHomeKey: Boolean read FEnhanceHomeKey write FEnhanceHomeKey;
    property GroupUndo: Boolean read FGroupUndo write FGroupUndo;
    property HalfPageScroll: Boolean read FHalfPageScroll write FHalfPageScroll;
    property HideShowScrollbars: Boolean read FHideShowScrollbars write FHideShowScrollbars;
    property KeepCaretX: Boolean read FKeepCaretX write FKeepCaretX;
    property NoCaret: Boolean read FNoCaret write FNoCaret;
    property NoSelection: Boolean read FNoSelection write FNoSelection;
    property ScrollByOneLess: Boolean read FScrollByOneLess write FScrollByOneLess;
    property ScrollHintFollows: Boolean read FScrollHintFollows write FScrollHintFollows;
    property ScrollPastEof: Boolean read FScrollPastEof write FScrollPastEof;
    property ScrollPastEol: Boolean read FScrollPastEol write FScrollPastEol;
    property ShowScrollHint: Boolean read FShowScrollHint write FShowScrollHint;
    property SmartTabDelete: Boolean read FSmartTabDelete write FSmartTabDelete;
    property SmartTabs: Boolean read FSmartTabs write FSmartTabs;
    property TabIndent: Boolean read FTabIndent write FTabIndent;
    property TabsToSpaces: Boolean read FTabsToSpaces write FTabsToSpaces;
    property TrimTrailingSpaces: Boolean read FTrimTrailingSpaces write FTrimTrailingSpaces;
  end;

  // E D I T O R  D I S P L A Y ===============================================>
  TSHEditorGutter = class;
  TSHEditorMargin = class;
  TSHEditorDisplayOptions = class(TSHComponentOptions, ISHEditorDisplayOptions)
  private
    FFont: TFont;
    FGutter: TSHEditorGutter;
    FMargin: TSHEditorMargin;
    procedure SetFont(Value: TFont);
    // -> ISHEditorDisplayOptions
    function GetFont: TFont;
    //procedure SetFont(Value: TFont);
    function GetGutter: ISHEditorGutter;
    function GetMargin: ISHEditorMargin;
  protected
    function GetParentCategory: string; override;
    function GetCategory: string; override;
    procedure RestoreDefaults; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Font: TFont read FFont write SetFont;
    property Gutter: TSHEditorGutter read FGutter write FGutter;
    property Margin: TSHEditorMargin read FMargin write FMargin;
  end;

  TSHEditorGutter = class(TSHInterfacedPersistent, ISHEditorGutter)
  private
    FAutoSize: Boolean;
    FDigitCount: Integer;
    FFont: TFont;
    FLeadingZeros: Boolean;
    FLeftOffset: Integer;
    FRightOffset: Integer;
    FShowLineNumbers: Boolean;
    FUseFontStyle: Boolean;
    FVisible: Boolean;
    FWidth: Integer;
    FZeroStart: Boolean;
    procedure SetFont(Value: TFont);
    // -> ISHEditorGutter
    function GetAutoSize: Boolean;
    procedure SetAutoSize(Value: Boolean);
    function GetDigitCount: Integer;
    procedure SetDigitCount(Value: Integer);
    function GetFont: TFont;
    //procedure SetFont(Value: TFont);
    function GetLeadingZeros: Boolean;
    procedure SetLeadingZeros(Value: Boolean);
    function GetLeftOffset: Integer;
    procedure SetLeftOffset(Value: Integer);
    function GetRightOffset: Integer;
    procedure SetRightOffset(Value: Integer);
    function GetShowLineNumbers: Boolean;
    procedure SetShowLineNumbers(Value: Boolean);
    function GetUseFontStyle: Boolean;
    procedure SetUseFontStyle(Value: Boolean);
    function GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    function GetWidth: Integer;
    procedure SetWidth(Value: Integer);
    function GetZeroStart: Boolean;
    procedure SetZeroStart(Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
  published
    property AutoSize: Boolean read FAutoSize write FAutoSize;
    property DigitCount: Integer read FDigitCount write FDigitCount;
    property Font: TFont read FFont write SetFont;
    property LeadingZeros: Boolean read FLeadingZeros write FLeadingZeros;
    property LeftOffset: Integer read FLeftOffset write FLeftOffset;
    property RightOffset: Integer read FRightOffset write FRightOffset;
    property ShowLineNumbers: Boolean read FShowLineNumbers write FShowLineNumbers;
    property UseFontStyle: Boolean read FUseFontStyle write FUseFontStyle;
    property Visible: Boolean read FVisible write FVisible;
    property Width: Integer read FWidth write FWidth;
    property ZeroStart: Boolean read FZeroStart write FZeroStart;
  end;

  TSHEditorMargin = class(TSHInterfacedPersistent, ISHEditorMargin)
  private
    FRightEdgeVisible: Boolean;
    FRightEdgeWidth: Integer;
    FBottomEdgeVisible: Boolean;
    // -> ISHEditorMargin
    function GetRightEdgeVisible: Boolean;
    procedure SetRightEdgeVisible(Value: Boolean);
    function GetRightEdgeWidth: Integer;
    procedure SetRightEdgeWidth(Value: Integer);
    function GetBottomEdgeVisible: Boolean;
    procedure SetBottomEdgeVisible(Value: Boolean);
  published
    property RightEdgeVisible: Boolean read FRightEdgeVisible write FRightEdgeVisible;
    property RightEdgeWidth: Integer read FRightEdgeWidth write FRightEdgeWidth;
    property BottomEdgeVisible: Boolean read FBottomEdgeVisible write FBottomEdgeVisible;
  end;

  // E D I T O R  C O L O R ===================================================>
  TSHEditorColor = class;
  TSHEditorColorAttr = class;
  TSHEditorColorOptions = class(TSHComponentOptions, ISHEditorColorOptions)
  private
    FBackground: TColor;
    FGutter: TColor;
    FRightEdge: TColor;
    FBottomEdge: TColor;
    FCurrentLine: TColor;
    FErrorLine: TColor;
    FScrollHint: TColor;
    FSelected: TSHEditorColor;
    FCommentAttr: TSHEditorColorAttr;
    FCustomStringAttr: TSHEditorColorAttr;
    FDataTypeAttr: TSHEditorColorAttr;
    FIdentifierAttr: TSHEditorColorAttr;
    FFunctionAttr: TSHEditorColorAttr;
    FLinkAttr: TSHEditorColorAttr;
    FNumberAttr: TSHEditorColorAttr;
    FSQLKeywordAttr: TSHEditorColorAttr;
    FStringAttr: TSHEditorColorAttr;
    FStringDblQuotedAttr: TSHEditorColorAttr;
    FSymbolAttr: TSHEditorColorAttr;
    FVariableAttr: TSHEditorColorAttr;
    FWrongSymbolAttr: TSHEditorColorAttr;
    // -> ISHEditorColorOptions
    function GetBackground: TColor;
    procedure SetBackground(Value: TColor);
    function GetGutter: TColor;
    procedure SetGutter(Value: TColor);
    function GetRightEdge: TColor;
    procedure SetRightEdge(Value: TColor);
    function GetBottomEdge: TColor;
    procedure SetBottomEdge(Value: TColor);
    function GetCurrentLine: TColor;
    procedure SetCurrentLine(Value: TColor);
    function GetErrorLine: TColor;
    procedure SetErrorLine(Value: TColor);
    function GetScrollHint: TColor;
    procedure SetScrollHint(Value: TColor);
    function GetSelected: ISHEditorColor;
    function GetCommentAttr: ISHEditorColorAttr;
    function GetCustomStringAttr: ISHEditorColorAttr;
    function GetDataTypeAttr: ISHEditorColorAttr;
    function GetIdentifierAttr: ISHEditorColorAttr;
    function GetFunctionAttr: ISHEditorColorAttr;
    function GetLinkAttr: ISHEditorColorAttr;
    function GetNumberAttr: ISHEditorColorAttr;
    function GetSQLKeywordAttr: ISHEditorColorAttr;
    function GetStringAttr: ISHEditorColorAttr;
    function GetStringDblQuotedAttr: ISHEditorColorAttr;
    function GetSymbolAttr: ISHEditorColorAttr;
    function GetVariableAttr: ISHEditorColorAttr;
    function GetWrongSymbolAttr: ISHEditorColorAttr;
  protected
    function GetParentCategory: string; override;
    function GetCategory: string; override;
    procedure RestoreDefaults; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Background: TColor read FBackground write FBackground;
    property Gutter: TColor read FGutter write FGutter;
    property RightEdge: TColor read FRightEdge write FRightEdge;
    property BottomEdge: TColor read FBottomEdge write FBottomEdge;
    property CurrentLine: TColor read FCurrentLine write FCurrentLine;
    property ErrorLine: TColor read FErrorLine write FErrorLine;
    property ScrollHint: TColor read FScrollHint write FScrollHint;
    property Selected: TSHEditorColor read FSelected write FSelected;
    property CommentAttr: TSHEditorColorAttr read FCommentAttr write FCommentAttr;
    property CustomStringAttr: TSHEditorColorAttr read FCustomStringAttr write FCustomStringAttr;
    property DataTypeAttr: TSHEditorColorAttr read FDataTypeAttr write FDataTypeAttr;
    property IdentifierAttr: TSHEditorColorAttr read FIdentifierAttr write FIdentifierAttr;
    property FunctionAttr: TSHEditorColorAttr read FFunctionAttr write FFunctionAttr;
    property LinkAttr: TSHEditorColorAttr read FLinkAttr write FLinkAttr;
    property NumberAttr: TSHEditorColorAttr read FNumberAttr write FNumberAttr;
    property SQLKeywordAttr: TSHEditorColorAttr read FSQLKeywordAttr write FSQLKeywordAttr;
    property StringAttr: TSHEditorColorAttr read FStringAttr write FStringAttr;
    property StringDblQuotedAttr: TSHEditorColorAttr read FStringDblQuotedAttr write FStringDblQuotedAttr;
    property SymbolAttr: TSHEditorColorAttr read FSymbolAttr write FSymbolAttr;
    property VariableAttr: TSHEditorColorAttr read FVariableAttr write FVariableAttr;
    property WrongSymbolAttr: TSHEditorColorAttr read FWrongSymbolAttr write FWrongSymbolAttr;
  end;

  TSHEditorColor = class(TSHInterfacedPersistent, ISHEditorColor)
  private
    FForeground: TColor;
    FBackground: TColor;
  protected
    // -> ISHEditorColor
    function GetForeground: TColor;
    procedure SetForeground(Value: TColor);
    function GetBackground: TColor;
    procedure SetBackground(Value: TColor);
  published
    property Foreground: TColor read FForeground write FForeground;
    property Background: TColor read FBackground write FBackground;
  end;

  TSHEditorColorAttr = class(TSHEditorColor, ISHEditorColorAttr)
  private
    FStyle: TFontStyles;
    // -> ISHEditorColorAttr
    function GetStyle: TFontStyles;
    procedure SetStyle(Value: TFontStyles);
  published
    property Style: TFontStyles read FStyle write FStyle;
  end;

  // E D I T O R  C O D E I N S I G H T =======================================>
  TSHEditorCodeInsightOptions = class(TSHComponentOptions, ISHEditorCodeInsightOptions,
   IEditorCodeInsightOptionsExt
  )
  private
    FCodeCompletion: Boolean;
    FCodeParameters: Boolean;
    FCaseCode: TSHEditorCaseCode;
    FCaseSQLKeywords: TSHEditorCaseCode;
    FCustomStrings: TStrings;
    FDelay: Integer;
    { Invisible }
    FWindowLineCount: Integer;
    FWindowWidth: Integer;
    //Buzz
    FShowBeginEndRegions:boolean;
    // -> ISHEditorCodeInsightOptions
    function GetCodeCompletion: Boolean;
    procedure SetCodeCompletion(Value: Boolean);
    function GetCodeParameters: Boolean;
    procedure SetCodeParameters(Value: Boolean);
    function GetCaseCode: TSHEditorCaseCode;
    procedure SetCaseCode(Value: TSHEditorCaseCode);
    function GetCaseSQLKeywords: TSHEditorCaseCode;
    procedure SetCaseSQLKeywords(Value: TSHEditorCaseCode);
    function GetCustomStrings: TStrings;
    function GetDelay: Integer;
    procedure SetDelay(Value: Integer);

    function GetWindowLineCount: Integer;
    procedure SetWindowLineCount(Value: Integer);
    function GetWindowWidth: Integer;
    procedure SetWindowWidth(Value: Integer);
    procedure SetCustomStrings(const Value: TStrings);
    function  GetShowBeginEndRegions:boolean;
    procedure SetShowBeginEndRegions(const Value:boolean);

  protected
    function GetParentCategory: string; override;
    function GetCategory: string; override;
    procedure RestoreDefaults; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property CodeCompletion: Boolean read FCodeCompletion write FCodeCompletion;
    property CodeParameters: Boolean read FCodeParameters write FCodeParameters;
    property CaseCode: TSHEditorCaseCode read FCaseCode write FCaseCode;
    property CaseSQLKeywords: TSHEditorCaseCode read FCaseSQLKeywords write FCaseSQLKeywords;
    property CustomStrings: TStrings read FCustomStrings write SetCustomStrings;
    property Delay: Integer read FDelay write FDelay;
    property ShowBeginEndRegions:boolean read FShowBeginEndRegions write FShowBeginEndRegions default True;
    { Invisible }
    property WindowLineCount: Integer read FWindowLineCount write FWindowLineCount;
    property WindowWidth: Integer read FWindowWidth write FWindowWidth ;
  end;

procedure Register;

implementation

procedure Register;
begin
  SHRegisterComponents([
    TSHEditorGeneralOptions,
      TSHEditorDisplayOptions,
      TSHEditorColorOptions,
      TSHEditorCodeInsightOptions]);
end;

{ TSHEditorGeneralOptions }

constructor TSHEditorGeneralOptions.Create(AOwner: TComponent);
begin
  FOptions := TSHEditorOptions.Create;
  { Invisible }
  FOpenedFilesHistory := TStringList.Create;
  FFindTextHistory := TStringList.Create;
  FReplaceTextHistory := TStringList.Create;
  FLineNumberHistory := TStringList.Create;
  FDemoLines := TStringList.Create;
  inherited Create(AOwner);
//  Expanded := False;
  MakePropertyInvisible('OpenedFilesHistory');
  MakePropertyInvisible('FindTextHistory');
  MakePropertyInvisible('ReplaceTextHistory');
  MakePropertyInvisible('LineNumberHistory');
  MakePropertyInvisible('DemoLines');
  MakePropertyInvisible('PromtOnReplace');
end;

destructor TSHEditorGeneralOptions.Destroy;
begin
  FOptions.Free;
  { Invisible }
  FOpenedFilesHistory.Free;
  FFindTextHistory.Free;
  FReplaceTextHistory.Free;
  FLineNumberHistory.Free;
  FDemoLines.Free;
  inherited Destroy;
end;

function TSHEditorGeneralOptions.GetCategory: string;
begin
  Result := Format('%s', ['Editor']);
end;

procedure TSHEditorGeneralOptions.RestoreDefaults;
begin
  HideSelection := False;
  InsertCaret := VerticalLine;
  InsertMode := True;
  MaxLineWidth := 1000;
  MaxUndo := 50;
  OpenLink := DblClick;
  Options.AltSetsColumnMode := False;
  Options.AutoIndent := True;
  Options.AutoSizeMaxLeftChar := False;
  Options.DisableScrollArrows := False;
  Options.DragDropEditing := True;
  Options.EnhanceHomeKey := False;
  Options.GroupUndo := True;
  Options.HalfPageScroll := False;
  Options.HideShowScrollbars := False;
  Options.KeepCaretX := False;
  Options.NoCaret := False;
  Options.NoSelection := False;
  Options.ScrollByOneLess := False;
  Options.ScrollHintFollows := False;
  Options.ScrollPastEof := False;
  Options.ScrollPastEol := True;
  Options.ShowScrollHint := False;
  Options.SmartTabDelete := False;
  Options.SmartTabs := False;
  Options.TabIndent := False;
  Options.TabsToSpaces := True;
  Options.TrimTrailingSpaces := True;
  OverwriteCaret := Block;
  ScrollHintFormat := TopLineOnly;
  ScrollBars := ssBoth;
  SelectionMode := Normal;
  TabWidth := 2;
  UseHighlight := True;
  WantReturns := True;
  WantTabs := True;
end;

function TSHEditorGeneralOptions.GetHideSelection: Boolean;
begin
  Result := HideSelection;
end;

procedure TSHEditorGeneralOptions.SetHideSelection(Value: Boolean);
begin
  HideSelection := Value;
end;

function TSHEditorGeneralOptions.GetUseHighlight: Boolean;
begin
  Result := UseHighlight;
end;

procedure TSHEditorGeneralOptions.SetUseHighlight(Value: Boolean);
begin
  UseHighlight := Value;
end;

function TSHEditorGeneralOptions.GetInsertCaret: TSHEditorCaretType;
begin
  Result := InsertCaret;
end;

procedure TSHEditorGeneralOptions.SetInsertCaret(Value: TSHEditorCaretType);
begin
  InsertCaret := Value;
end;

function TSHEditorGeneralOptions.GetInsertMode: Boolean;
begin
  Result := InsertMode;
end;

procedure TSHEditorGeneralOptions.SetInsertMode(Value: Boolean);
begin
  InsertMode := Value;
end;

function TSHEditorGeneralOptions.GetMaxLineWidth: Integer;
begin
  Result := MaxLineWidth;
end;

procedure TSHEditorGeneralOptions.SetMaxLineWidth(Value: Integer);
begin
  MaxLineWidth := Value;
end;

function TSHEditorGeneralOptions.GetMaxUndo: Integer;
begin
  Result := MaxUndo;
end;

procedure TSHEditorGeneralOptions.SetMaxUndo(Value: Integer);
begin
  MaxUndo := Value;
end;

function TSHEditorGeneralOptions.GetOpenLink: TSHEditorLinkOption;
begin
  Result := OpenLink;
end;

procedure TSHEditorGeneralOptions.SetOpenLink(Value: TSHEditorLinkOption);
begin
  OpenLink := Value;
end;

function TSHEditorGeneralOptions.GetOptions: ISHEditorOptions;
begin
  Supports(Options, ISHEditorOptions, Result);
end;

function TSHEditorGeneralOptions.GetOverwriteCaret: TSHEditorCaretType;
begin
  Result := OverwriteCaret;
end;

procedure TSHEditorGeneralOptions.SetOverwriteCaret(Value: TSHEditorCaretType);
begin
  OverwriteCaret := Value;
end;

function TSHEditorGeneralOptions.GetScrollHintFormat: TSHEditorScrollHintFormat;
begin
  Result := ScrollHintFormat;
end;

procedure TSHEditorGeneralOptions.SetScrollHintFormat(Value: TSHEditorScrollHintFormat);
begin
  ScrollHintFormat := Value;
end;

function TSHEditorGeneralOptions.GetScrollBars: TScrollStyle;
begin
  Result := ScrollBars;
end;

procedure TSHEditorGeneralOptions.SetScrollBars(Value: TScrollStyle);
begin
  ScrollBars := Value;
end;

function TSHEditorGeneralOptions.GetSelectionMode: TSHEditorSelectionMode;
begin
  Result := SelectionMode;
end;

procedure TSHEditorGeneralOptions.SetSelectionMode(Value: TSHEditorSelectionMode);
begin
  SelectionMode := Value;
end;

function TSHEditorGeneralOptions.GetTabWidth: Integer;
begin
  Result := TabWidth;
end;

procedure TSHEditorGeneralOptions.SetTabWidth(Value: Integer);
begin
  TabWidth := Value;
end;

function TSHEditorGeneralOptions.GetWantReturns: Boolean;
begin
  Result := WantReturns;
end;

procedure TSHEditorGeneralOptions.SetWantReturns(Value: Boolean);
begin
  WantReturns := Value;
end;

function TSHEditorGeneralOptions.GetWantTabs: Boolean;
begin
  Result := WantTabs;
end;

procedure TSHEditorGeneralOptions.SetWantTabs(Value: Boolean);
begin
  WantTabs := Value;
end;

function TSHEditorGeneralOptions.GetWordWrap: Boolean;
begin
  Result := WordWrap;
end;

procedure TSHEditorGeneralOptions.SetWordWrap(Value: Boolean);
begin
  WordWrap := Value;
end;

function TSHEditorGeneralOptions.GetOpenedFilesHistory: TStrings;
begin
  Result := OpenedFilesHistory;
end;

function TSHEditorGeneralOptions.GetFindTextHistory: TStrings;
begin
  Result := FindTextHistory;
end;

function TSHEditorGeneralOptions.GetReplaceTextHistory: TStrings;
begin
  Result := ReplaceTextHistory;
end;

function TSHEditorGeneralOptions.GetLineNumberHistory: TStrings;
begin
  Result := LineNumberHistory;
end;

function TSHEditorGeneralOptions.GetDemoLines: TStrings;
begin
  Result := DemoLines;
end;

function TSHEditorGeneralOptions.GetPromtOnReplace: Boolean;
begin
  Result := PromtOnReplace;
end;

procedure TSHEditorGeneralOptions.SetPromtOnReplace(Value: Boolean);
begin
  PromtOnReplace := Value;
end;

{ TSHEditorOptions }

function TSHEditorOptions.GetAltSetsColumnMode: Boolean;
begin
  Result := AltSetsColumnMode;
end;

procedure TSHEditorOptions.SetAltSetsColumnMode(Value: Boolean);
begin
  AltSetsColumnMode := Value;
end;

function TSHEditorOptions.GetAutoIndent: Boolean;
begin
  Result := AutoIndent;
end;

procedure TSHEditorOptions.SetAutoIndent(Value: Boolean);
begin
  AutoIndent := Value;
end;

function TSHEditorOptions.GetAutoSizeMaxLeftChar: Boolean;
begin
  Result := AutoSizeMaxLeftChar;
end;

procedure TSHEditorOptions.SetAutoSizeMaxLeftChar(Value: Boolean);
begin
  AutoSizeMaxLeftChar := Value;
end;

function TSHEditorOptions.GetDisableScrollArrows: Boolean;
begin
  Result := DisableScrollArrows;
end;

procedure TSHEditorOptions.SetDisableScrollArrows(Value: Boolean);
begin
  DisableScrollArrows := Value;
end;

function TSHEditorOptions.GetDragDropEditing: Boolean;
begin
  Result := DragDropEditing;
end;

procedure TSHEditorOptions.SetDragDropEditing(Value: Boolean);
begin
  DragDropEditing := Value;
end;

function TSHEditorOptions.GetEnhanceHomeKey: Boolean;
begin
  Result := EnhanceHomeKey;
end;

procedure TSHEditorOptions.SetEnhanceHomeKey(Value: Boolean);
begin
  EnhanceHomeKey := Value;
end;

function TSHEditorOptions.GetGroupUndo: Boolean;
begin
  Result := GroupUndo;
end;

procedure TSHEditorOptions.SetGroupUndo(Value: Boolean);
begin
  GroupUndo := Value;
end;

function TSHEditorOptions.GetHalfPageScroll: Boolean;
begin
  Result := HalfPageScroll;
end;

procedure TSHEditorOptions.SetHalfPageScroll(Value: Boolean);
begin
  HalfPageScroll := Value;
end;

function TSHEditorOptions.GetHideShowScrollbars: Boolean;
begin
  Result := HideShowScrollbars;
end;

procedure TSHEditorOptions.SetHideShowScrollbars(Value: Boolean);
begin
  HideShowScrollbars := Value;
end;

function TSHEditorOptions.GetKeepCaretX: Boolean;
begin
  Result := KeepCaretX;
end;

procedure TSHEditorOptions.SetKeepCaretX(Value: Boolean);
begin
  KeepCaretX := Value;
end;

function TSHEditorOptions.GetNoCaret: Boolean;
begin
  Result := NoCaret;
end;

procedure TSHEditorOptions.SetNoCaret(Value: Boolean);
begin
  NoCaret := Value;
end;

function TSHEditorOptions.GetNoSelection: Boolean;
begin
  Result := NoSelection;
end;

procedure TSHEditorOptions.SetNoSelection(Value: Boolean);
begin
  NoSelection := Value;
end;

function TSHEditorOptions.GetScrollByOneLess: Boolean;
begin
  Result := ScrollByOneLess;
end;

procedure TSHEditorOptions.SetScrollByOneLess(Value: Boolean);
begin
  ScrollByOneLess := Value;
end;

function TSHEditorOptions.GetScrollHintFollows: Boolean;
begin
  Result := ScrollHintFollows;
end;

procedure TSHEditorOptions.SetScrollHintFollows(Value: Boolean);
begin
  ScrollHintFollows := Value;
end;

function TSHEditorOptions.GetScrollPastEof: Boolean;
begin
  Result := ScrollPastEof;
end;

procedure TSHEditorOptions.SetScrollPastEof(Value: Boolean);
begin
  ScrollPastEof := Value;
end;

function TSHEditorOptions.GetScrollPastEol: Boolean;
begin
  Result := ScrollPastEol;
end;

procedure TSHEditorOptions.SetScrollPastEol(Value: Boolean);
begin
  ScrollPastEol := Value;
end;

function TSHEditorOptions.GetShowScrollHint: Boolean;
begin
  Result := ShowScrollHint;
end;

procedure TSHEditorOptions.SetShowScrollHint(Value: Boolean);
begin
  ShowScrollHint := Value;
end;

function TSHEditorOptions.GetSmartTabDelete: Boolean;
begin
  Result := SmartTabDelete;
end;

procedure TSHEditorOptions.SetSmartTabDelete(Value: Boolean);
begin
  SmartTabDelete := Value;
end;

function TSHEditorOptions.GetSmartTabs: Boolean;
begin
  Result := SmartTabs;
end;

procedure TSHEditorOptions.SetSmartTabs(Value: Boolean);
begin
  SmartTabs := Value;
end;

function TSHEditorOptions.GetTabIndent: Boolean;
begin
  Result := TabIndent;
end;

procedure TSHEditorOptions.SetTabIndent(Value: Boolean);
begin
  TabIndent := Value;
end;

function TSHEditorOptions.GetTabsToSpaces: Boolean;
begin
  Result := TabsToSpaces;
end;

procedure TSHEditorOptions.SetTabsToSpaces(Value: Boolean);
begin
  TabsToSpaces := Value;
end;

function TSHEditorOptions.GetTrimTrailingSpaces: Boolean;
begin
  Result := TrimTrailingSpaces;
end;

procedure TSHEditorOptions.SetTrimTrailingSpaces(Value: Boolean);
begin
  TrimTrailingSpaces := Value;
end;

{ TSHEditorDisplayOptions }

constructor TSHEditorDisplayOptions.Create(AOwner: TComponent);
begin
  FFont := TFont.Create;
  FGutter := TSHEditorGutter.Create;
  FMargin := TSHEditorMargin.Create;
  inherited Create(AOwner);
end;

destructor TSHEditorDisplayOptions.Destroy;
begin
  FFont.Free;
  FGutter.Free;
  FMargin.Free;
  inherited Destroy;
end;

function TSHEditorDisplayOptions.GetParentCategory: string;
begin
  Result := Format('%s', ['Editor']);
end;

function TSHEditorDisplayOptions.GetCategory: string;
begin
  Result := Format('%s', ['Display']);
end;

procedure TSHEditorDisplayOptions.RestoreDefaults;
begin
  Font.Charset := 1;
  Font.Color := clWindowText;
  Font.Height := -13;
  Font.Name := 'Courier New';
  Font.Pitch := fpDefault;
  Font.Size := 10;
  Font.Style := [];

  Gutter.AutoSize := False;
  Gutter.DigitCount := 4;
  Gutter.Font.Charset := 1;
  Gutter.Font.Color := clWindowText;
  Gutter.Font.Height := -11;
  Gutter.Font.Name := 'Tahoma';
  Gutter.Font.Pitch := fpDefault;
  Gutter.Font.Size := 8;
  Gutter.Font.Style := [];
  Gutter.LeadingZeros := False;
  Gutter.LeftOffset := 16;
  Gutter.RightOffset := 2;
  Gutter.ShowLineNumbers := False;
  Gutter.UseFontStyle := True;
  Gutter.Visible := True;
  Gutter.Width := 30;
  Gutter.ZeroStart := False;

  Margin.BottomEdgeVisible := True;
  Margin.RightEdgeVisible := True;
  Margin.RightEdgeWidth := 80;
end;

procedure TSHEditorDisplayOptions.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

function TSHEditorDisplayOptions.GetFont: TFont;
begin
  Result := Font;
end;

//procedure SetFont(Value: TFont);

function TSHEditorDisplayOptions.GetGutter: ISHEditorGutter;
begin
  Supports(Gutter, ISHEditorGutter, Result);
end;

function TSHEditorDisplayOptions.GetMargin: ISHEditorMargin;
begin
  Supports(Margin, ISHEditorMargin, Result);
end;

{ TSHEditorGutter }

constructor TSHEditorGutter.Create;
begin
  inherited Create;
  FFont := TFont.Create;
end;

destructor TSHEditorGutter.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TSHEditorGutter.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

function TSHEditorGutter.GetAutoSize: Boolean;
begin
  Result := AutoSize;
end;

procedure TSHEditorGutter.SetAutoSize(Value: Boolean);
begin
  AutoSize := Value;
end;

function TSHEditorGutter.GetDigitCount: Integer;
begin
  Result := DigitCount;
end;

procedure TSHEditorGutter.SetDigitCount(Value: Integer);
begin
  DigitCount := Value;
end;

function TSHEditorGutter.GetFont: TFont;
begin
  Result := Font;
end;

//procedure SetFont(Value: TFont);

function TSHEditorGutter.GetLeadingZeros: Boolean;
begin
  Result := LeadingZeros;
end;

procedure TSHEditorGutter.SetLeadingZeros(Value: Boolean);
begin
  LeadingZeros := Value;
end;

function TSHEditorGutter.GetLeftOffset: Integer;
begin
  Result := LeftOffset;
end;

procedure TSHEditorGutter.SetLeftOffset(Value: Integer);
begin
  LeftOffset := Value;
end;

function TSHEditorGutter.GetRightOffset: Integer;
begin
  Result := RightOffset;
end;

procedure TSHEditorGutter.SetRightOffset(Value: Integer);
begin
  RightOffset := Value;
end;

function TSHEditorGutter.GetShowLineNumbers: Boolean;
begin
  Result := ShowLineNumbers;
end;

procedure TSHEditorGutter.SetShowLineNumbers(Value: Boolean);
begin
  ShowLineNumbers := Value;
end;

function TSHEditorGutter.GetUseFontStyle: Boolean;
begin
  Result := UseFontStyle;
end;

procedure TSHEditorGutter.SetUseFontStyle(Value: Boolean);
begin
  UseFontStyle := Value;
end;

function TSHEditorGutter.GetVisible: Boolean;
begin
  Result := Visible;
end;

procedure TSHEditorGutter.SetVisible(Value: Boolean);
begin
  Visible := Value;
end;

function TSHEditorGutter.GetWidth: Integer;
begin
  Result := Width;
end;

procedure TSHEditorGutter.SetWidth(Value: Integer);
begin
  Width := Value;
end;

function TSHEditorGutter.GetZeroStart: Boolean;
begin
  Result := ZeroStart;
end;

procedure TSHEditorGutter.SetZeroStart(Value: Boolean);
begin
  ZeroStart := Value;
end;

{ TSHEditorMargin }

function TSHEditorMargin.GetRightEdgeVisible: Boolean;
begin
  Result := RightEdgeVisible;
end;

procedure TSHEditorMargin.SetRightEdgeVisible(Value: Boolean);
begin
  RightEdgeVisible := Value;
end;

function TSHEditorMargin.GetRightEdgeWidth: Integer;
begin
  Result := RightEdgeWidth;
end;

procedure TSHEditorMargin.SetRightEdgeWidth(Value: Integer);
begin
  RightEdgeWidth := Value;
end;

function TSHEditorMargin.GetBottomEdgeVisible: Boolean;
begin
  Result := BottomEdgeVisible;
end;

procedure TSHEditorMargin.SetBottomEdgeVisible(Value: Boolean);
begin
  BottomEdgeVisible := Value;
end;

{ TSHEditorColorOptions }

constructor TSHEditorColorOptions.Create(AOwner: TComponent);
begin
  FSelected := TSHEditorColor.Create;
  FCommentAttr := TSHEditorColorAttr.Create;
  FCustomStringAttr := TSHEditorColorAttr.Create;
  FDataTypeAttr := TSHEditorColorAttr.Create;
  FIdentifierAttr := TSHEditorColorAttr.Create;
  FFunctionAttr := TSHEditorColorAttr.Create;
  FLinkAttr := TSHEditorColorAttr.Create;
  FNumberAttr := TSHEditorColorAttr.Create;
  FSQLKeywordAttr := TSHEditorColorAttr.Create;
  FStringAttr := TSHEditorColorAttr.Create;
  FStringDblQuotedAttr := TSHEditorColorAttr.Create;
  FSymbolAttr := TSHEditorColorAttr.Create;
  FVariableAttr := TSHEditorColorAttr.Create;
  FWrongSymbolAttr := TSHEditorColorAttr.Create;
  inherited Create(AOwner);
end;

destructor TSHEditorColorOptions.Destroy;
begin
  FSelected.Free;
  FCommentAttr.Free;
  FCustomStringAttr.Free;
  FDataTypeAttr.Free;
  FIdentifierAttr.Free;
  FFunctionAttr.Free;
  FLinkAttr.Free;
  FNumberAttr.Free;
  FSQLKeywordAttr.Free;
  FStringAttr.Free;
  FStringDblQuotedAttr.Free;
  FSymbolAttr.Free;
  FVariableAttr.Free;
  FWrongSymbolAttr.Free;
  inherited Destroy;
end;

function TSHEditorColorOptions.GetParentCategory: string;
begin
  Result := Format('%s', ['Editor']);
end;

function TSHEditorColorOptions.GetCategory: string;
begin
  Result := Format('%s', ['Color and Style']);
end;

procedure TSHEditorColorOptions.RestoreDefaults;
begin
  Background := clWindow;
  Gutter := clBtnFace;
  RightEdge := clSilver;
  BottomEdge := clSilver;
  CurrentLine := RGB(250, 255, 230); //clNone;
  ErrorLine := clMaroon;

  ScrollHint := clInfoBk;
  Selected.Foreground := clHighLightText;
  Selected.Background := RGB(132, 145, 180); //clHighLight;

  CommentAttr.Foreground := clSilver;
  CommentAttr.Background := clNone;
  CommentAttr.Style := [fsBold];

  CustomStringAttr.Foreground := clBtnFace;
  CustomStringAttr.Background := clNone;
  CustomStringAttr.Style := [fsBold];

  DataTypeAttr.Foreground := clBlack;
  DataTypeAttr.Background := clNone;
  DataTypeAttr.Style := [fsBold];

  IdentifierAttr.Foreground := clBlue;
  IdentifierAttr.Background := clNone;
  IdentifierAttr.Style := [fsBold];

  FunctionAttr.Foreground := clBlack;
  FunctionAttr.Background := clNone;
  FunctionAttr.Style := [fsBold];

  LinkAttr.Foreground := clGreen;
  LinkAttr.Background := clNone;
  LinkAttr.Style := [fsBold, fsUnderline];

  NumberAttr.Foreground := clTeal;
  NumberAttr.Background := clNone;
  NumberAttr.Style := [fsBold];

  SQLKeywordAttr.Foreground := clBlack;
  SQLKeywordAttr.Background := clNone;
  SQLKeywordAttr.Style := [fsBold];

  StringAttr.Foreground := clPurple;
  StringAttr.Background := clNone;
  StringAttr.Style := [fsBold];

  StringDblQuotedAttr.Foreground := clPurple;
  StringDblQuotedAttr.Background := clNone;
  StringDblQuotedAttr.Style := [fsBold];

  SymbolAttr.Foreground := clBlack;
  SymbolAttr.Background := clNone;
  SymbolAttr.Style := [fsBold];

  VariableAttr.Foreground := clBackground;
  VariableAttr.Background := clNone;
  VariableAttr.Style := [fsBold];

  WrongSymbolAttr.Foreground := clYellow;
  WrongSymbolAttr.Background := clRed;
  WrongSymbolAttr.Style := [fsBold];
end;

function TSHEditorColorOptions.GetBackground: TColor;
begin
  Result := Background;
end;

procedure TSHEditorColorOptions.SetBackground(Value: TColor);
begin
  Background := Value;
end;

function TSHEditorColorOptions.GetGutter: TColor;
begin
  Result := Gutter;
end;

procedure TSHEditorColorOptions.SetGutter(Value: TColor);
begin
  Gutter := Value;
end;

function TSHEditorColorOptions.GetRightEdge: TColor;
begin
  Result := RightEdge;
end;

procedure TSHEditorColorOptions.SetRightEdge(Value: TColor);
begin
  RightEdge := Value;
end;

function TSHEditorColorOptions.GetBottomEdge: TColor;
begin
  Result := BottomEdge;
end;

procedure TSHEditorColorOptions.SetBottomEdge(Value: TColor);
begin
  BottomEdge := Value;
end;

function TSHEditorColorOptions.GetCurrentLine: TColor;
begin
  Result := CurrentLine;
end;

procedure TSHEditorColorOptions.SetCurrentLine(Value: TColor);
begin
 CurrentLine  := Value;
end;

function TSHEditorColorOptions.GetErrorLine: TColor;
begin
  Result := ErrorLine;
end;

procedure TSHEditorColorOptions.SetErrorLine(Value: TColor);
begin
  ErrorLine := Value;
end;

function TSHEditorColorOptions.GetScrollHint: TColor;
begin
  Result := ScrollHint;
end;

procedure TSHEditorColorOptions.SetScrollHint(Value: TColor);
begin
  ScrollHint := Value;
end;

function TSHEditorColorOptions.GetSelected: ISHEditorColor;
begin
  Supports(Selected, ISHEditorColor, Result);
end;

function TSHEditorColorOptions.GetCommentAttr: ISHEditorColorAttr;
begin
  Supports(CommentAttr, ISHEditorColorAttr, Result);
end;

function TSHEditorColorOptions.GetCustomStringAttr: ISHEditorColorAttr;
begin
  Supports(CustomStringAttr, ISHEditorColorAttr, Result);
end;

function TSHEditorColorOptions.GetDataTypeAttr: ISHEditorColorAttr;
begin
  Supports(DataTypeAttr, ISHEditorColorAttr, Result);
end;

function TSHEditorColorOptions.GetIdentifierAttr: ISHEditorColorAttr;
begin
  Supports(IdentifierAttr, ISHEditorColorAttr, Result);
end;

function TSHEditorColorOptions.GetFunctionAttr: ISHEditorColorAttr;
begin
  Supports(FunctionAttr, ISHEditorColorAttr, Result);
end;

function TSHEditorColorOptions.GetLinkAttr: ISHEditorColorAttr;
begin
  Supports(LinkAttr, ISHEditorColorAttr, Result);
end;

function TSHEditorColorOptions.GetNumberAttr: ISHEditorColorAttr;
begin
  Supports(NumberAttr, ISHEditorColorAttr, Result);
end;

function TSHEditorColorOptions.GetSQLKeywordAttr: ISHEditorColorAttr;
begin
  Supports(SQLKeywordAttr, ISHEditorColorAttr, Result);
end;

function TSHEditorColorOptions.GetStringAttr: ISHEditorColorAttr;
begin
  Supports(StringAttr, ISHEditorColorAttr, Result);
end;

function TSHEditorColorOptions.GetStringDblQuotedAttr: ISHEditorColorAttr;
begin
  Supports(StringDblQuotedAttr, ISHEditorColorAttr, Result);
end;

function TSHEditorColorOptions.GetSymbolAttr: ISHEditorColorAttr;
begin
  Supports(SymbolAttr, ISHEditorColorAttr, Result);
end;

function TSHEditorColorOptions.GetVariableAttr: ISHEditorColorAttr;
begin
  Supports(VariableAttr, ISHEditorColorAttr, Result);
end;

function TSHEditorColorOptions.GetWrongSymbolAttr: ISHEditorColorAttr;
begin
  Supports(WrongSymbolAttr, ISHEditorColorAttr, Result);
end;

{ TSHEditorColor }

function TSHEditorColor.GetForeground: TColor;
begin
  Result := Foreground;
end;

procedure TSHEditorColor.SetForeground(Value: TColor);
begin
  Foreground := Value;
end;

function TSHEditorColor.GetBackground: TColor;
begin
  Result := Background;
end;

procedure TSHEditorColor.SetBackground(Value: TColor);
begin
  Background := Value;
end;

{ TSHEditorColorAttr }

function TSHEditorColorAttr.GetStyle: TFontStyles;
begin
  Result := Style;
end;

procedure TSHEditorColorAttr.SetStyle(Value: TFontStyles);
begin
  Style := Value;
end;

{ TSHEditorCodeInsightOptions }

constructor TSHEditorCodeInsightOptions.Create(AOwner: TComponent);
begin
  FCustomStrings := TStringList.Create;
  TStringList(FCustomStrings).Sorted := True;
  inherited Create(AOwner);
  FShowBeginEndRegions:=True;
  MakePropertyInvisible('WindowLineCount');
  MakePropertyInvisible('WindowWidth');
end;

destructor TSHEditorCodeInsightOptions.Destroy;
begin
  FCustomStrings.Free;
  inherited Destroy;
end;

function TSHEditorCodeInsightOptions.GetParentCategory: string;
begin
  Result := Format('%s', ['Editor']);
end;

function TSHEditorCodeInsightOptions.GetCategory: string;
begin
  Result := Format('%s', ['Code Insight']);
end;

procedure TSHEditorCodeInsightOptions.RestoreDefaults;
begin
  CodeCompletion := True;
  CodeParameters := True;
  CaseCode := Upper;
  CaseSQLKeywords := Upper;
  Delay := 1000;
  WindowLineCount := 12;
  WindowWidth := 300;
  FShowBeginEndRegions:=True;
end;

function TSHEditorCodeInsightOptions.GetCodeCompletion: Boolean;
begin
  Result := CodeCompletion;
end;

procedure TSHEditorCodeInsightOptions.SetCodeCompletion(Value: Boolean);
begin
  CodeCompletion := Value;
end;

function TSHEditorCodeInsightOptions.GetCodeParameters: Boolean;
begin
  Result := CodeParameters;
end;

procedure TSHEditorCodeInsightOptions.SetCodeParameters(Value: Boolean);
begin
  CodeParameters := Value;
end;

function TSHEditorCodeInsightOptions.GetCaseCode: TSHEditorCaseCode;
begin
  Result := CaseCode;
end;

procedure TSHEditorCodeInsightOptions.SetCaseCode(Value: TSHEditorCaseCode);
begin
  CaseCode := Value;
end;

function TSHEditorCodeInsightOptions.GetCaseSQLKeywords: TSHEditorCaseCode;
begin
  Result := CaseSQLKeywords;
end;

procedure TSHEditorCodeInsightOptions.SetCaseSQLKeywords(Value: TSHEditorCaseCode);
begin
  CaseSQLKeywords := Value;
end;

function TSHEditorCodeInsightOptions.GetCustomStrings: TStrings;
begin
  Result := CustomStrings;
end;

function TSHEditorCodeInsightOptions.GetDelay: Integer;
begin
  Result := Delay;
end;

procedure TSHEditorCodeInsightOptions.SetDelay(Value: Integer);
begin
  Delay := Value;
end;

function TSHEditorCodeInsightOptions.GetWindowLineCount: Integer;
begin
  Result := WindowLineCount;
end;

procedure TSHEditorCodeInsightOptions.SetWindowLineCount(Value: Integer);
begin
  WindowLineCount := Value;
end;

function TSHEditorCodeInsightOptions.GetWindowWidth: Integer;
begin
  Result := WindowWidth;
end;

procedure TSHEditorCodeInsightOptions.SetWindowWidth(Value: Integer);
begin
  WindowWidth := Value;
end;

procedure TSHEditorCodeInsightOptions.SetCustomStrings(
  const Value: TStrings);
begin
  FCustomStrings.Assign(Value);
end;

function TSHEditorCodeInsightOptions.GetShowBeginEndRegions: boolean;
begin
  Result:=FShowBeginEndRegions
end;

procedure TSHEditorCodeInsightOptions.SetShowBeginEndRegions(
  const Value: boolean);
begin
 FShowBeginEndRegions:=Value
end;

end.
