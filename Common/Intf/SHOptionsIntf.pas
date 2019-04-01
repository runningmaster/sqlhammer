unit SHOptionsIntf;

interface

uses
  SysUtils, Classes, Graphics, StdCtrls,
  // SQLHammer
  SHDesignIntf;

type
  // System ->
  ISHSystemOptions = interface(ISHComponentOptions)
  ['{8F0FFA69-1AC6-4132-BF3B-452EB24C2B7F}']
    function GetStartBranch: Integer;
    procedure SetStartBranch(Value: Integer);
    function GetShowSplashWindow: Boolean;
    procedure SetShowSplashWindow(Value: Boolean);
    function GetUseWorkspaces: Boolean;
    procedure SetUseWorkspaces(Value: Boolean);
    function GetExternalDiffPath: string;
    procedure SetExternalDiffPath(Value: string);
    function GetExternalDiffParams: string;
    procedure SetExternalDiffParams(Value: string);
    function GetWarningOnExit: Boolean;
    procedure SetWarningOnExit(Value: Boolean);

    function GetLeftWidth: Integer;
    procedure SetLeftWidth(Value: Integer);
    function GetRightWidth: Integer;
    procedure SetRightWidth(Value: Integer);
    function GetIDE1Height: Integer;
    procedure SetIDE1Height(Value: Integer);
    function GetIDE2Height: Integer;
    procedure SetIDE2Height(Value: Integer);
    function GetIDE3Height: Integer;
    procedure SetIDE3Height(Value: Integer);
    function GetNavigatorLeft: Boolean;
    procedure SetNavigatorLeft(Value: Boolean);
    function GetToolboxTop: Boolean;
    procedure SetToolboxTop(Value: Boolean);
    function GetStartPage: Integer;
    procedure SetStartPage(Value: Integer);
    function GetMultilineMode: Boolean;
    procedure SetMultilineMode(Value: Boolean);
    function GetFilterMode: Boolean;
    procedure SetFilterMode(Value: Boolean);

    property ShowSplashWindow: Boolean read GetShowSplashWindow write SetShowSplashWindow;
    property UseWorkspaces: Boolean read GetUseWorkspaces write SetUseWorkspaces;
    property ExternalDiffPath: string read GetExternalDiffPath write SetExternalDiffPath;
    property ExternalDiffParams: string read GetExternalDiffParams write SetExternalDiffParams;
    property WarningOnExit: Boolean read GetWarningOnExit write SetWarningOnExit;

    {Invisible}
    property StartBranch: Integer read GetStartBranch write SetStartBranch;
    property LeftWidth: Integer read GetLeftWidth write SetLeftWidth;
    property RightWidth: Integer read GetRightWidth write SetRightWidth;
    property IDE1Height: Integer read GetIDE1Height write SetIDE1Height;
    property IDE2Height: Integer read GetIDE2Height write SetIDE2Height;
    property IDE3Height: Integer read GetIDE3Height write SetIDE3Height;
    property NavigatorLeft: Boolean read GetNavigatorLeft write SetNavigatorLeft;
    property ToolboxTop: Boolean read GetToolboxTop write SetToolboxTop;
    property StartPage: Integer read GetStartPage write SetStartPage;
    property MultilineMode: Boolean read GetMultilineMode write SetMultilineMode;
    property FilterMode: Boolean read GetFilterMode write SetFilterMode;
  end;

  // Editor ->
  TSHEditorCaretType = (VerticalLine, HorizontalLine, HalfBlock, Block);
  TSHEditorLinkOption = (SingleClick, CtrlClick, DblClick);
  TSHEditorScrollHintFormat = (TopLineOnly, TopToBottom);
  TSHEditorSelectionMode = (Normal, Line, Column);
  ISHEditorOptions = interface;
  ISHEditorGeneralOptions = interface(ISHComponentOptions)
  ['{8B111A9D-394D-4F8F-A014-BCA6D817BD61}']
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

    property HideSelection: Boolean read GetHideSelection write SetHideSelection;
    property UseHighlight: Boolean read GetUseHighlight write SetUseHighlight;
    property InsertCaret: TSHEditorCaretType read GetInsertCaret write SetInsertCaret;
    property InsertMode: Boolean read GetInsertMode write SetInsertMode;
    property MaxLineWidth: Integer read GetMaxLineWidth write SetMaxLineWidth;
    property MaxUndo: Integer read GetMaxUndo write SetMaxUndo;
    property OpenLink: TSHEditorLinkOption read GetOpenLink write SetOpenLink;
    property Options: ISHEditorOptions read GetOptions;
    property OverwriteCaret: TSHEditorCaretType read GetOverwriteCaret write SetOverwriteCaret;
    property ScrollHintFormat: TSHEditorScrollHintFormat read GetScrollHintFormat write SetScrollHintFormat;
    property ScrollBars: TScrollStyle read GetScrollBars write SetScrollBars;
    property SelectionMode: TSHEditorSelectionMode read GetSelectionMode write SetSelectionMode;
    property TabWidth: Integer read GetTabWidth write SetTabWidth;
    property WantReturns: Boolean read GetWantReturns write SetWantReturns;
    property WantTabs: Boolean read GetWantTabs write SetWantTabs;
    property WordWrap: Boolean read GetWordWrap write SetWordWrap;

    { Invisible }
    property OpenedFilesHistory: TStrings read GetOpenedFilesHistory;
    property FindTextHistory: TStrings read GetFindTextHistory;
    property ReplaceTextHistory: TStrings read GetReplaceTextHistory;
    property LineNumberHistory: TStrings read GetLineNumberHistory;
    property DemoLines: TStrings read GetDemoLines;
    property PromtOnReplace: Boolean read GetPromtOnReplace write SetPromtOnReplace;
  end;

  ISHEditorOptions = interface
  ['{6C086418-9B91-4DD8-A9A8-8F8DCEAFA6E5}']
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

    property AltSetsColumnMode: Boolean read GetAltSetsColumnMode write SetAltSetsColumnMode;
    property AutoIndent: Boolean read GetAutoIndent write SetAutoIndent;
    property AutoSizeMaxLeftChar: Boolean read GetAutoSizeMaxLeftChar write SetAutoSizeMaxLeftChar;
    property DisableScrollArrows: Boolean read GetDisableScrollArrows write SetDisableScrollArrows;
    property DragDropEditing: Boolean read GetDragDropEditing write SetDragDropEditing;
    property EnhanceHomeKey: Boolean read GetEnhanceHomeKey write SetEnhanceHomeKey;
    property GroupUndo: Boolean read GetGroupUndo write SetGroupUndo;
    property HalfPageScroll: Boolean read GetHalfPageScroll write SetHalfPageScroll;
    property HideShowScrollbars: Boolean read GetHideShowScrollbars write SetHideShowScrollbars;
    property KeepCaretX: Boolean read GetKeepCaretX write SetKeepCaretX;
    property NoCaret: Boolean read GetNoCaret write SetNoCaret;
    property NoSelection: Boolean read GetNoSelection write SetNoSelection;
    property ScrollByOneLess: Boolean read GetScrollByOneLess write SetScrollByOneLess;
    property ScrollHintFollows: Boolean read GetScrollHintFollows write SetScrollHintFollows;
    property ScrollPastEof: Boolean read GetScrollPastEof write SetScrollPastEof;
    property ScrollPastEol: Boolean read GetScrollPastEol write SetScrollPastEol;
    property ShowScrollHint: Boolean read GetShowScrollHint write SetShowScrollHint;
    property SmartTabDelete: Boolean read GetSmartTabDelete write SetSmartTabDelete;
    property SmartTabs: Boolean read GetSmartTabs write SetSmartTabs;
    property TabIndent: Boolean read GetTabIndent write SetTabIndent;
    property TabsToSpaces: Boolean read GetTabsToSpaces write SetTabsToSpaces;
    property TrimTrailingSpaces: Boolean read GetTrimTrailingSpaces write SetTrimTrailingSpaces;
  end;

  ISHEditorGutter = interface;
  ISHEditorMargin = interface;
  ISHEditorDisplayOptions = interface(ISHComponentOptions)
  ['{B0C98531-C37F-4A62-8690-1AD57607858B}']
    function GetFont: TFont;
    procedure SetFont(Value: TFont);
    function GetGutter: ISHEditorGutter;
    function GetMargin: ISHEditorMargin;

    property Font: TFont read GetFont write SetFont;
    property Gutter: ISHEditorGutter read GetGutter;
    property Margin: ISHEditorMargin read GetMargin;
  end;

  ISHEditorGutter = interface
  ['{50E59981-2292-457B-8A25-81E4D6C733D1}']
    function GetAutoSize: Boolean;
    procedure SetAutoSize(Value: Boolean);
    function GetDigitCount: Integer;
    procedure SetDigitCount(Value: Integer);
    function GetFont: TFont;
    procedure SetFont(Value: TFont);
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

    property AutoSize: Boolean read GetAutoSize write SetAutoSize;
    property DigitCount: Integer read GetDigitCount write SetDigitCount;
    property Font: TFont read GetFont write SetFont;
    property LeadingZeros: Boolean read GetLeadingZeros write SetLeadingZeros;
    property LeftOffset: Integer read GetLeftOffset write SetLeftOffset;
    property RightOffset: Integer read GetRightOffset write SetRightOffset;
    property ShowLineNumbers: Boolean read GetShowLineNumbers write SetShowLineNumbers;
    property UseFontStyle: Boolean read GetUseFontStyle write SetUseFontStyle;
    property Visible: Boolean read GetVisible write SetVisible;
    property Width: Integer read GetWidth write SetWidth;
    property ZeroStart: Boolean read GetZeroStart write SetZeroStart;
  end;

  ISHEditorMargin = interface
  ['{923EEB68-AF96-4099-8429-6C5B018E2A83}']
    function GetRightEdgeVisible: Boolean;
    procedure SetRightEdgeVisible(Value: Boolean);
    function GetRightEdgeWidth: Integer;
    procedure SetRightEdgeWidth(Value: Integer);
    function GetBottomEdgeVisible: Boolean;
    procedure SetBottomEdgeVisible(Value: Boolean);

    property RightEdgeVisible: Boolean read GetRightEdgeVisible write SetRightEdgeVisible;
    property RightEdgeWidth: Integer read GetRightEdgeWidth write SetRightEdgeWidth;
    property BottomEdgeVisible: Boolean read GetBottomEdgeVisible write SetBottomEdgeVisible;
  end;

  ISHEditorColor = interface;
  ISHEditorColorAttr = interface;
  ISHEditorColorOptions = interface(ISHComponentOptions)
  ['{58B3B67F-C65F-4404-A74F-6F82F4F18F86}']
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

    property Background: TColor read GetBackground write SetBackground;
    property Gutter: TColor read GetGutter write SetGutter;
    property RightEdge: TColor read GetRightEdge write SetRightEdge;
    property BottomEdge: TColor read GetBottomEdge write SetBottomEdge;
    property CurrentLine: TColor read GetCurrentLine write SetCurrentLine;
    property ErrorLine: TColor read GetErrorLine write SetErrorLine;
    property ScrollHint: TColor read GetScrollHint write SetScrollHint;
    property Selected: ISHEditorColor read GetSelected;
    property CommentAttr: ISHEditorColorAttr read GetCommentAttr;
    property CustomStringAttr: ISHEditorColorAttr read GetCustomStringAttr;
    property DataTypeAttr: ISHEditorColorAttr read GetDataTypeAttr;
    property IdentifierAttr: ISHEditorColorAttr read GetIdentifierAttr;
    property FunctionAttr: ISHEditorColorAttr read GetFunctionAttr;
    property LinkAttr: ISHEditorColorAttr read GetLinkAttr;
    property NumberAttr: ISHEditorColorAttr read GetNumberAttr;
    property SQLKeywordAttr: ISHEditorColorAttr read GetSQLKeywordAttr;
    property StringAttr: ISHEditorColorAttr read GetStringAttr;
    property StringDblQuotedAttr: ISHEditorColorAttr read GetStringDblQuotedAttr;
    property SymbolAttr: ISHEditorColorAttr read GetSymbolAttr;
    property VariableAttr: ISHEditorColorAttr read GetVariableAttr;
    property WrongSymbolAttr: ISHEditorColorAttr read GetWrongSymbolAttr;
  end;


  ISHEditorColor = interface
  ['{7D4BFE88-C414-4A8F-A903-D4DE6623EBE6}']
    function GetForeground: TColor;
    procedure SetForeground(Value: TColor);
    function GetBackground: TColor;
    procedure SetBackground(Value: TColor);

    property Foreground: TColor read GetForeground write SetForeground;
    property Background: TColor read GetBackground write SetBackground;
  end;

  ISHEditorColorAttr = interface(ISHEditorColor)
  ['{13D4A45B-151D-4B5A-896F-B5DBBAAB3AB7}']
    function GetStyle: TFontStyles;
    procedure SetStyle(Value: TFontStyles);

    property Style: TFontStyles read GetStyle write SetStyle;
  end;

  TSHEditorCaseCode = (Lower, Upper, NameCase, FirstUpper, None, Invert, Toggle);
  ISHEditorCodeInsightOptions = interface(ISHComponentOptions)
  ['{5ED7677A-0ACA-4718-A15C-E95C0228A9B6}']
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

    property CodeCompletion: Boolean read GetCodeCompletion write SetCodeCompletion;
    property CodeParameters: Boolean read GetCodeParameters write SetCodeParameters;
    property CaseCode: TSHEditorCaseCode read GetCaseCode write SetCaseCode;
    property CaseSQLKeywords: TSHEditorCaseCode read GetCaseSQLKeywords write SetCaseSQLKeywords;
    property CustomStrings: TStrings read GetCustomStrings;
    property Delay: Integer read GetDelay write SetDelay;
    { Invisible }
    property WindowLineCount: Integer read GetWindowLineCount write SetWindowLineCount;
    property WindowWidth: Integer read GetWindowWidth write SetWindowWidth;
  end;

  IEditorCodeInsightOptionsExt =interface
  ['{26AA3F44-F109-486B-BAC7-D152CA3F07B8}']
   function GetShowBeginEndRegions:boolean;
   procedure SetShowBeginEndRegions(const Value:boolean);   
  end;
  // DBGrid ->
  ISHDBGridAllowedOperations = interface;
  ISHDBGridAllowedSelections = interface;
  ISHDBGridScrollBar = interface;
  ISHDBGridOptions = interface;
  ISHDBGridGeneralOptions = interface(ISHComponentOptions)
  ['{40F3DF8D-976B-4840-B8D7-1F1A4A711E63}']
    function GetAllowedOperations: ISHDBGridAllowedOperations;
    function GetAllowedSelections: ISHDBGridAllowedSelections;
    function GetAutoFitColWidths: Boolean;
    procedure SetAutoFitColWidths(Value: Boolean);
    function GetDrawMemoText: Boolean;
    procedure SetDrawMemoText(Value: Boolean);
    function GetFrozenCols: Integer;
    procedure SetFrozenCols(Value: Integer);
    function GetHorzScrollBar: ISHDBGridScrollBar;
    function GetMinAutoFitWidth: Integer;
    procedure SetMinAutoFitWidth(Value: Integer);
    function GetOptions: ISHDBGridOptions;
    function GetRowHeight: Integer;
    procedure SetRowHeight(Value: Integer);
    function GetRowLines: Integer;
    procedure SetRowLines(Value: Integer);
    function GetRowSizingAllowed: Boolean;
    procedure SetRowSizingAllowed(Value: Boolean);
    function GetTitleHeight: Integer;
    procedure SetTitleHeight(Value: Integer);
    function GetToolTips: Boolean;
    procedure SetToolTips(Value: Boolean);
    function GetVertScrollBar: ISHDBGridScrollBar;

    property AllowedOperations: ISHDBGridAllowedOperations read GetAllowedOperations;
    property AllowedSelections: ISHDBGridAllowedSelections read GetAllowedSelections;
    property AutoFitColWidths: Boolean read GetAutoFitColWidths write SetAutoFitColWidths;
    property DrawMemoText: Boolean read GetDrawMemoText write SetDrawMemoText;
    property FrozenCols: Integer read GetFrozenCols write SetFrozenCols;
    property HorzScrollBar: ISHDBGridScrollBar read GetHorzScrollBar;
    property MinAutoFitWidth: Integer read GetMinAutoFitWidth write SetMinAutoFitWidth;
    property Options: ISHDBGridOptions read GetOptions;
    property RowHeight: Integer read GetRowHeight write SetRowHeight;
    property RowLines: Integer read GetRowLines write SetRowLines;
    property RowSizingAllowed: Boolean read GetRowSizingAllowed write SetRowSizingAllowed;
    property TitleHeight: Integer read GetTitleHeight write SetTitleHeight;
    property ToolTips: Boolean read GetToolTips write SetToolTips;
    property VertScrollBar: ISHDBGridScrollBar read GetVertScrollBar;
  end;
  
  ISHDBGridAllowedOperations = interface
  ['{31B0A303-BEB1-4A27-9AAD-5B526B2C8498}']
    function GetInsert: Boolean;
    procedure SetInsert(Value: Boolean);
    function GetUpdate: Boolean;
    procedure SetUpdate(Value: Boolean);
    function GetDelete: Boolean;
    procedure SetDelete(Value: Boolean);
    function GetAppend: Boolean;
    procedure SetAppend(Value: Boolean);

    property Insert: Boolean read GetInsert write SetInsert;
    property Update: Boolean read GetUpdate write SetUpdate;
    property Delete: Boolean read GetDelete write SetDelete;
    property Append: Boolean read GetAppend write SetAppend;
  end;

  ISHDBGridAllowedSelections = interface
  ['{A6FB56C7-E843-484F-B555-2FA61AAD9030}']
    function GetRecordBookmarks: Boolean;
    procedure SetRecordBookmarks(Value: Boolean);
    function GetRectangle: Boolean;
    procedure SetRectangle(Value: Boolean);
    function GetColumns: Boolean;
    procedure SetColumns(Value: Boolean);
    function GetAll: Boolean;
    procedure SetAll(Value: Boolean);

    property RecordBookmarks: Boolean read GetRecordBookmarks write SetRecordBookmarks;
    property Rectangle: Boolean read GetRectangle write SetRectangle;
    property Columns: Boolean read GetColumns write SetColumns;
    property All: Boolean read GetAll write SetAll;
  end;

  TSHDBGridScrollBarVisibleMode = (Always, Never, Auto);
  ISHDBGridScrollBar = interface
  ['{2D9E677A-DBAC-4032-AA56-9698F4CD0C85}']
    function GetTracking: Boolean;
    procedure SetTracking(Value: Boolean);
    function GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    function GetVisibleMode: TSHDBGridScrollBarVisibleMode;
    procedure SetVisibleMode(Value: TSHDBGridScrollBarVisibleMode);

    property Tracking: Boolean read GetTracking write SetTracking;
    property Visible: Boolean read GetVisible write SetVisible;
    property VisibleMode: TSHDBGridScrollBarVisibleMode read GetVisibleMode write SetVisibleMode;
  end;

  ISHDBGridOptions = interface
  ['{C7181E03-C0BC-4BE5-BAAB-794FC10366E8}']
    function GetAlwaysShowEditor: Boolean;
    procedure SetAlwaysShowEditor(Value: Boolean);
    function GetAlwaysShowSelection: Boolean;
    procedure SetAlwaysShowSelection(Value: Boolean);
    function GetCancelOnExit: Boolean;
    procedure SetCancelOnExit(Value: Boolean);
    function GetClearSelection: Boolean;
    procedure SetClearSelection(Value: Boolean);
    function GetColLines: Boolean;
    procedure SetColLines(Value: Boolean);
    function GetColumnResize: Boolean;
    procedure SetColumnResize(Value: Boolean);
    function GetConfirmDelete: Boolean;
    procedure SetConfirmDelete(Value: Boolean);
    function GetData3D: Boolean;
    procedure SetData3D(Value: Boolean);
    function GetEditing: Boolean;
    procedure SetEditing(Value: Boolean);
    function GetEnterAsTab: Boolean;
    procedure SetEnterAsTab(Value: Boolean);
    function GetIncSearch: Boolean;
    procedure SetIncSearch(Value: Boolean);
    function GetIndicator: Boolean;
    procedure SetIndicator(Value: Boolean);
    function GetFitRowHeightToText: Boolean;
    procedure SetFitRowHeightToText(Value: Boolean);
    function GetFixed3D: Boolean;
    procedure SetFixed3D(Value: Boolean);
    function GetFrozen3D: Boolean;
    procedure SetFrozen3D(Value: Boolean);
    function GetHighlightFocus: Boolean;
    procedure SetHighlightFocus(Value: Boolean);
    function GetMultiSelect: Boolean;
    procedure SetMultiSelect(Value: Boolean);
    function GetPreferIncSearch: Boolean;
    procedure SetPreferIncSearch(Value: Boolean);
    function GetResizeWholeRightPart: Boolean;
    procedure SetResizeWholeRightPart(Value: Boolean);
    function GetRowHighlight: Boolean;
    procedure SetRowHighlight(Value: Boolean);
    function GetRowLines: Boolean;
    procedure SetRowLines(Value: Boolean);
    function GetRowSelect: Boolean;
    procedure SetRowSelect(Value: Boolean);
    function GetTabs: Boolean;
    procedure SetTabs(Value: Boolean);
    function GetTitles: Boolean;
    procedure SetTitles(Value: Boolean);
    function GetTraceColSizing: Boolean;
    procedure SetTraceColSizing(Value: Boolean);

    property AlwaysShowEditor: Boolean read GetAlwaysShowEditor write SetAlwaysShowEditor;
    property AlwaysShowSelection: Boolean read GetAlwaysShowSelection write SetAlwaysShowSelection;
    property CancelOnExit: Boolean read GetCancelOnExit write SetCancelOnExit;
    property ClearSelection: Boolean read GetClearSelection write SetClearSelection;
    property ColLines: Boolean read GetColLines write SetColLines;
    property ColumnResize: Boolean read GetColumnResize write SetColumnResize;
    property ConfirmDelete: Boolean read GetConfirmDelete write SetConfirmDelete;
    property Data3D: Boolean read GetData3D write SetData3D;
    property Editing: Boolean read GetEditing write SetEditing;
    property EnterAsTab: Boolean read GetEnterAsTab write SetEnterAsTab;
    property IncSearch: Boolean read GetIncSearch write SetIncSearch;
    property Indicator: Boolean read GetIndicator write SetIndicator;
    property FitRowHeightToText: Boolean read GetFitRowHeightToText write SetFitRowHeightToText;
    property Fixed3D: Boolean read GetFixed3D write SetFixed3D;
    property Frozen3D: Boolean read GetFrozen3D write SetFrozen3D;
    property HighlightFocus: Boolean read GetHighlightFocus write SetHighlightFocus;
    property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
    property PreferIncSearch: Boolean read GetPreferIncSearch write SetPreferIncSearch;
    property ResizeWholeRightPart: Boolean read GetResizeWholeRightPart write SetResizeWholeRightPart;
    property RowHighlight: Boolean read GetRowHighlight write SetRowHighlight;
    property RowLines: Boolean read GetRowLines write SetRowLines;
    property RowSelect: Boolean read GetRowSelect write SetRowSelect;
    property Tabs: Boolean read GetTabs write SetTabs;
    property Titles: Boolean read GetTitles write SetTitles;
    property TraceColSizing: Boolean read GetTraceColSizing write SetTraceColSizing;
  end;

  ISHDBGridDisplayOptions = interface(ISHComponentOptions)
  ['{15BC2CAB-7B77-4568-B2E3-A9072B32B479}']
    function GetLuminateSelection: Boolean;
    procedure SetLuminateSelection(Value: Boolean);
    function GetStriped: Boolean;
    procedure SetStriped(Value: Boolean);
    function GetFont: TFont;
    procedure SetFont(Value: TFont);
    function GetTitleFont: TFont;
    procedure SetTitleFont(Value: TFont);

    property LuminateSelection: Boolean read GetLuminateSelection write SetLuminateSelection;
    property Striped: Boolean read GetStriped write SetStriped;
    property Font: TFont read GetFont write SetFont;
    property TitleFont: TFont read GetTitleFont write SetTitleFont;
  end;

  ISHDBGridColorOptions = interface(ISHComponentOptions)
  ['{DE1AB5C8-B795-4A32-9B15-B489363AABCC}']
    function GetBackground: TColor;
    procedure SetBackground(Value: TColor);
    function GetFixed: TColor;
    procedure SetFixed(Value: TColor);
    function GetCurrentRow: TColor;
    procedure SetCurrentRow(Value: TColor);
    function GetOddRow: TColor;
    procedure SetOddRow(Value: TColor);
    function GetNullValue: TColor;
    procedure SetNullValue(Value: TColor);

    property Background: TColor read GetBackground write SetBackground;
    property Fixed: TColor read GetFixed write SetFixed;
    property CurrentRow: TColor read GetCurrentRow write SetCurrentRow;
    property OddRow: TColor read GetOddRow write SetOddRow;
    property NullValue: TColor read GetNullValue write SetNullValue;
  end;

  ISHDBGridDisplayFormats = interface;
  ISHDBGridEditFormats = interface;
  ISHDBGridFormatOptions = interface(ISHComponentOptions)
  ['{ADEE178C-054C-444A-9F40-A03141DB7CB5}']
    function GetDisplayFormats: ISHDBGridDisplayFormats;
    function GetEditFormats: ISHDBGridEditFormats;

    property DisplayFormats: ISHDBGridDisplayFormats read GetDisplayFormats;
    property EditFormats: ISHDBGridEditFormats read GetEditFormats;
  end;

  ISHDBGridDisplayFormats = interface
  ['{BBBFC0A3-C87D-44E5-972A-695FADCFC918}']
    function GetStringFieldWidth: Integer;
    procedure SetStringFieldWidth(Value: Integer);
    function GetIntegerField: string;
    procedure SetIntegerField(Value: string);
    function GetFloatField: string;
    procedure SetFloatField(Value: string);
    function GetDateTimeField: string;
    procedure SetDateTimeField(Value: string);
    function GetDateField: string;
    procedure SetDateField(Value: string);
    function GetTimeField: string;
    procedure SetTimeField(Value: string);
    function GetNullValue: string;
    procedure SetNullValue(Value: string);

    property StringFieldWidth: Integer read GetStringFieldWidth write SetStringFieldWidth;
    property IntegerField: string read GetIntegerField write SetIntegerField;
    property FloatField: string read GetFloatField write SetFloatField;
    property DateTimeField: string read GetDateTimeField write SetDateTimeField;
    property DateField: string read GetDateField write SetDateField;
    property TimeField: string read GetTimeField write SetTimeField;
    property NullValue: string read GetNullValue write SetNullValue;
  end;

  ISHDBGridEditFormats = interface
  ['{0A2C1361-1901-47DE-B1B7-567409F69B5F}']
    function GetIntegerField: string;
    procedure SetIntegerField(Value: string);
    function GetFloatField: string;
    procedure SetFloatField(Value: string);

    property IntegerField: string read GetIntegerField write SetIntegerField;
    property FloatField: string read GetFloatField write SetFloatField;
  end;

implementation

end.  
  
  
  
  
  
  
