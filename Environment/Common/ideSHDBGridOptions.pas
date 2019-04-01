unit ideSHDBGridOptions;

interface

uses
  Windows, SysUtils, Classes, Graphics, StdCtrls, DesignIntf, TypInfo,
  SHDesignIntf, SHOptionsIntf;

type
  // D B G R I D  G E N E R A L ===============================================>
  TSHDBGridAllowedOperations = class;
  TSHDBGridAllowedSelections = class;
  TSHDBGridScrollBar = class;
  TSHDBGridOptions = class;
  TSHDBGridGeneralOptions = class(TSHComponentOptions, ISHDBGridGeneralOptions)
  private
    FAllowedOperations: TSHDBGridAllowedOperations;
    FAllowedSelections: TSHDBGridAllowedSelections;
    FAutoFitColWidths: Boolean;
    FDrawMemoText: Boolean;
    FFrozenCols: Integer;
    FHorzScrollBar: TSHDBGridScrollBar;
    FMinAutoFitWidth: Integer;
    FOptions: TSHDBGridOptions;
    FRowHeight: Integer;
    FRowLines: Integer;
    FRowSizingAllowed: Boolean;
    FTitleHeight: Integer;
    FToolTips: Boolean;
    FVertScrollBar: TSHDBGridScrollBar;
    // -> ISHDBGridGeneralOptions
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
  protected
    function GetCategory: string; override;
    procedure RestoreDefaults; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AllowedOperations: TSHDBGridAllowedOperations read FAllowedOperations write FAllowedOperations;
    property AllowedSelections: TSHDBGridAllowedSelections read FAllowedSelections write FAllowedSelections;
    property AutoFitColWidths: Boolean read FAutoFitColWidths write FAutoFitColWidths;
    property DrawMemoText: Boolean read FDrawMemoText write FDrawMemoText;
    property FrozenCols: Integer read FFrozenCols write FFrozenCols;
    property HorzScrollBar: TSHDBGridScrollBar read FHorzScrollBar write FHorzScrollBar;
    property MinAutoFitWidth: Integer read FMinAutoFitWidth write FMinAutoFitWidth;
    property Options: TSHDBGridOptions read FOptions write FOptions;
    property RowHeight: Integer read FRowHeight write FRowHeight;
    property RowLines: Integer read FRowLines write FRowLines;
    property RowSizingAllowed: Boolean read FRowSizingAllowed write FRowSizingAllowed;
    property TitleHeight: Integer read FTitleHeight write FTitleHeight;
    property ToolTips: Boolean read FToolTips write FToolTips;
    property VertScrollBar: TSHDBGridScrollBar read FVertScrollBar write FVertScrollBar;
  end;

  TSHDBGridAllowedOperations = class(TSHInterfacedPersistent, ISHDBGridAllowedOperations)
  private
    FInsert: Boolean;
    FUpdate: Boolean;
    FDelete: Boolean;
    FAppend: Boolean;
    // -> ISHDBGridAllowedOperations
    function GetInsert: Boolean;
    procedure SetInsert(Value: Boolean);
    function GetUpdate: Boolean;
    procedure SetUpdate(Value: Boolean);
    function GetDelete: Boolean;
    procedure SetDelete(Value: Boolean);
    function GetAppend: Boolean;
    procedure SetAppend(Value: Boolean);
  published
    property Insert: Boolean read FInsert write FInsert;
    property Update: Boolean read FUpdate write FUpdate;
    property Delete: Boolean read FDelete write FDelete;
    property Append: Boolean read FAppend write FAppend;
  end;

  TSHDBGridAllowedSelections = class(TSHInterfacedPersistent, ISHDBGridAllowedSelections)
  private
    FRecordBookmarks: Boolean;
    FRectangle: Boolean;
    FColumns: Boolean;
    FAll: Boolean;
    // -> ISHDBGridAllowedSelections
    function GetRecordBookmarks: Boolean;
    procedure SetRecordBookmarks(Value: Boolean);
    function GetRectangle: Boolean;
    procedure SetRectangle(Value: Boolean);
    function GetColumns: Boolean;
    procedure SetColumns(Value: Boolean);
    function GetAll: Boolean;
    procedure SetAll(Value: Boolean);    
  published
    property RecordBookmarks: Boolean read FRecordBookmarks write FRecordBookmarks;
    property Rectangle: Boolean read FRectangle write FRectangle;
    property Columns: Boolean read FColumns write FColumns;
    property All: Boolean read FAll write FAll;
  end;

  TSHDBGridScrollBar = class(TSHInterfacedPersistent, ISHDBGridScrollBar)
  private
    FTracking: Boolean;
    FVisible: Boolean;
    FVisibleMode: TSHDBGridScrollBarVisibleMode;
    // -> ISHDBGridScrollBar
    function GetTracking: Boolean;
    procedure SetTracking(Value: Boolean);
    function GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    function GetVisibleMode: TSHDBGridScrollBarVisibleMode;
    procedure SetVisibleMode(Value: TSHDBGridScrollBarVisibleMode);
  published
    property Tracking: Boolean read FTracking write FTracking;
    property Visible: Boolean read FVisible write FVisible;
    property VisibleMode: TSHDBGridScrollBarVisibleMode read FVisibleMode write FVisibleMode;
  end;

  TSHDBGridOptions = class(TSHInterfacedPersistent, ISHDBGridOptions)
  private
    FAlwaysShowEditor: Boolean;
    FAlwaysShowSelection: Boolean;
    FCancelOnExit: Boolean;
    FClearSelection: Boolean;
    FColLines: Boolean;
    FColumnResize: Boolean;
    FConfirmDelete: Boolean;
    FData3D: Boolean;
    FEditing: Boolean;
    FEnterAsTab: Boolean;
    FIncSearch: Boolean;
    FIndicator: Boolean;
    FFitRowHeightToText: Boolean;
    FFixed3D: Boolean;
    FFrozen3D: Boolean;
    FHighlightFocus: Boolean;
    FMultiSelect: Boolean;
    FPreferIncSearch: Boolean;
    FResizeWholeRightPart: Boolean;
    FRowHighlight: Boolean;
    FRowLines: Boolean;
    FRowSelect: Boolean;
    FTabs: Boolean;
    FTitles: Boolean;
    FTraceColSizing: Boolean;
    // -> ISHDBGridOptions
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
  published
    property AlwaysShowEditor: Boolean read FAlwaysShowEditor write FAlwaysShowEditor;
    property AlwaysShowSelection: Boolean read FAlwaysShowSelection write FAlwaysShowSelection;
    property CancelOnExit: Boolean read FCancelOnExit write FCancelOnExit;
    property ClearSelection: Boolean read FClearSelection write FClearSelection;
    property ColLines: Boolean read FColLines write FColLines;
    property ColumnResize: Boolean read FColumnResize write FColumnResize;
    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete;
    property Data3D: Boolean read FData3D write FData3D;
    property Editing: Boolean read FEditing write FEditing;
    property EnterAsTab: Boolean read FEnterAsTab write FEnterAsTab;
    property IncSearch: Boolean read FIncSearch write FIncSearch;
    property Indicator: Boolean read FIndicator write FIndicator;
    property FitRowHeightToText: Boolean read FFitRowHeightToText write FFitRowHeightToText;
    property Fixed3D: Boolean read FFixed3D write FFixed3D;
    property Frozen3D: Boolean read FFrozen3D write FFrozen3D;
    property HighlightFocus: Boolean read FHighlightFocus write FHighlightFocus;
    property MultiSelect: Boolean read FMultiSelect write FMultiSelect;
    property PreferIncSearch: Boolean read FPreferIncSearch write FPreferIncSearch;
    property ResizeWholeRightPart: Boolean read FResizeWholeRightPart write FResizeWholeRightPart;
    property RowHighlight: Boolean read FRowHighlight write FRowHighlight;
    property RowLines: Boolean read FRowLines write FRowLines;
    property RowSelect: Boolean read FRowSelect write FRowSelect;
    property Tabs: Boolean read FTabs write FTabs;
    property Titles: Boolean read FTitles write FTitles;
    property TraceColSizing: Boolean read FTraceColSizing write FTraceColSizing;
  end;

  // D B G R I D  D I S P L A Y ===============================================>
  TSHDBGridDisplayOptions = class(TSHComponentOptions, ISHDBGridDisplayOptions)
  private
    FLuminateSelection: Boolean;
    FStriped: Boolean;
    FFont: TFont;
    FTitleFont: TFont;
    procedure SetFont(Value: TFont);
    procedure SetTitleFont(Value: TFont);
    // -> ISHDBGridDisplayOptions
    function GetLuminateSelection: Boolean;
    procedure SetLuminateSelection(Value: Boolean);
    function GetStriped: Boolean;
    procedure SetStriped(Value: Boolean);
    function GetFont: TFont;
    //procedure SetFont(Value: TFont);
    function GetTitleFont: TFont;
    //procedure SetTitleFont(Value: TFont);
  protected
    function GetParentCategory: string; override;
    function GetCategory: string; override;
    procedure RestoreDefaults; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property LuminateSelection: Boolean read FLuminateSelection write FLuminateSelection;
    property Striped: Boolean read FStriped write FStriped;
    property Font: TFont read FFont write SetFont;
    property TitleFont: TFont read FTitleFont write SetTitleFont;
  end;

  // D B G R I D  C O L O R ===================================================>
  TSHDBGridColorOptions = class(TSHComponentOptions, ISHDBGridColorOptions)
  private
    FBackground: TColor;
    FFixed: TColor;
    FCurrentRow: TColor;
    FOddRow: TColor;
    FNullValue: TColor;
    // -> ISHDBGridColorOptions
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
  protected
    function GetParentCategory: string; override;
    function GetCategory: string; override;
    procedure RestoreDefaults; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Background: TColor read FBackground write FBackground;
    property Fixed: TColor read FFixed write FFixed;
    property CurrentRow: TColor read FCurrentRow write FCurrentRow;
    property OddRow: TColor read FOddRow write FOddRow;
    property NullValue: TColor read FNullValue write FNullValue;
  end;

  // D B G R I D  F O R M A T S ===============================================>
  TSHDBGridDisplayFormats = class;
  TSHDBGridEditFormats = class;
  TSHDBGridFormatOptions = class(TSHComponentOptions, ISHDBGridFormatOptions)
  private
    FDisplayFormats: TSHDBGridDisplayFormats;
    FEditFormats: TSHDBGridEditFormats;
    // -> ISHDBGridFormatOptions
    function GetDisplayFormats: ISHDBGridDisplayFormats;
    function GetEditFormats: ISHDBGridEditFormats;
  protected
    function GetParentCategory: string; override;
    function GetCategory: string; override;
    procedure RestoreDefaults; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DisplayFormats: TSHDBGridDisplayFormats read FDisplayFormats write FDisplayFormats;
    property EditFormats: TSHDBGridEditFormats read FEditFormats write FEditFormats;
  end;

  TSHDBGridDisplayFormats = class(TSHInterfacedPersistent, ISHDBGridDisplayFormats)
  private
    FStringFieldWidth: Integer;
    FIntegerField: string;
    FFloatField: string;
    FDateTimeField: string;
    FDateField: string;
    FTimeField: string;
    FNullValue: string;
    // -> ISHDBGridDisplayFormats
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
  published
    property StringFieldWidth: Integer read FStringFieldWidth write FStringFieldWidth;
    property IntegerField: string read FIntegerField write FIntegerField;
    property FloatField: string read FFloatField write FFloatField;
    property DateTimeField: string read FDateTimeField write FDateTimeField;
    property DateField: string read FDateField write FDateField;
    property TimeField: string read FTimeField write FTimeField;
    property NullValue: string read FNullValue write FNullValue;
  end;

  TSHDBGridEditFormats = class(TSHInterfacedPersistent, ISHDBGridEditFormats)
  private
    FIntegerField: string;
    FFloatField: string;
    // -> ISHDBGridEditFormats
    function GetIntegerField: string;
    procedure SetIntegerField(Value: string);
    function GetFloatField: string;
    procedure SetFloatField(Value: string);
  published
    property IntegerField: string read FIntegerField write FIntegerField;
    property FloatField: string read FFloatField write FFloatField;
  end;

procedure Register;

implementation

procedure Register;
begin
  SHRegisterComponents([
    TSHDBGridGeneralOptions,
      TSHDBGridDisplayOptions,
      TSHDBGridColorOptions,
      TSHDBGridFormatOptions]);
end;

{ TSHDBGridGeneralOptions }

constructor TSHDBGridGeneralOptions.Create(AOwner: TComponent);
begin
  FAllowedOperations := TSHDBGridAllowedOperations.Create;
  FAllowedSelections := TSHDBGridAllowedSelections.Create;
  FHorzScrollBar := TSHDBGridScrollBar.Create;
  FOptions := TSHDBGridOptions.Create;
  FVertScrollBar := TSHDBGridScrollBar.Create;
  inherited Create(AOwner);
end;

destructor TSHDBGridGeneralOptions.Destroy;
begin
  FAllowedOperations.Free;
  FAllowedSelections.Free;
  FHorzScrollBar.Free;
  FOptions.Free;
  FVertScrollBar.Free;
  inherited Destroy;
end;

function TSHDBGridGeneralOptions.GetCategory: string;
begin
  Result := Format('%s', ['Grid']);
end;

procedure TSHDBGridGeneralOptions.RestoreDefaults;
begin
  AllowedOperations.Insert := True;
  AllowedOperations.Update := True;
  AllowedOperations.Delete := True;
  AllowedOperations.Append := True;
  AllowedSelections.RecordBookmarks := True;
  AllowedSelections.Rectangle := True;
  AllowedSelections.Columns := True;
  AllowedSelections.All := True;
  AutoFitColWidths := False;
  DrawMemoText := False;
  FrozenCols := 0;
  HorzScrollBar.Tracking := False;
  HorzScrollBar.Visible := True;
  HorzScrollBar.VisibleMode := Auto;
  MinAutoFitWidth := 0;
  Options.AlwaysShowEditor := False;
  Options.AlwaysShowSelection := True;
  Options.CancelOnExit := True;
  Options.ClearSelection := True;
  Options.ColLines := True;
  Options.ColumnResize := True;
  Options.ConfirmDelete := True;
  Options.Data3D := False;
  Options.Editing := True;
  Options.EnterAsTab := False;
  Options.IncSearch := False;
  Options.Indicator := True;
  Options.FitRowHeightToText := False;
  Options.Fixed3D := True;
  Options.Frozen3D := False;
  Options.HighlightFocus := True;
  Options.MultiSelect := False;
  Options.PreferIncSearch := False;
  Options.ResizeWholeRightPart := False;
  Options.RowHighlight := True;
  Options.RowLines := True;
  Options.RowSelect := False;
  Options.Tabs := False;
  Options.Titles := True;
  Options.TraceColSizing := False;
  RowHeight := 0;
  RowLines := 0;
  RowSizingAllowed := False;
  TitleHeight := 0;
  ToolTips := True;
  VertScrollBar.Tracking := False;
  VertScrollBar.Visible := True;
  VertScrollBar.VisibleMode := Auto;
end;

function TSHDBGridGeneralOptions.GetAllowedOperations: ISHDBGridAllowedOperations;
begin
  Supports(AllowedOperations, ISHDBGridAllowedOperations, Result);
end;

function TSHDBGridGeneralOptions.GetAllowedSelections: ISHDBGridAllowedSelections;
begin
  Supports(AllowedSelections, ISHDBGridAllowedSelections, Result);
end;

function TSHDBGridGeneralOptions.GetAutoFitColWidths: Boolean;
begin
  Result := AutoFitColWidths;
end;

procedure TSHDBGridGeneralOptions.SetAutoFitColWidths(Value: Boolean);
begin
  AutoFitColWidths := Value;
end;

function TSHDBGridGeneralOptions.GetDrawMemoText: Boolean;
begin
  Result := DrawMemoText;
end;

procedure TSHDBGridGeneralOptions.SetDrawMemoText(Value: Boolean);
begin
  DrawMemoText := Value;
end;

function TSHDBGridGeneralOptions.GetFrozenCols: Integer;
begin
  Result := FrozenCols;
end;

procedure TSHDBGridGeneralOptions.SetFrozenCols(Value: Integer);
begin
  FrozenCols := Value;
end;

function TSHDBGridGeneralOptions.GetHorzScrollBar: ISHDBGridScrollBar;
begin
  Supports(HorzScrollBar, ISHDBGridScrollBar, Result);
end;

function TSHDBGridGeneralOptions.GetMinAutoFitWidth: Integer;
begin
  Result := MinAutoFitWidth;
end;

procedure TSHDBGridGeneralOptions.SetMinAutoFitWidth(Value: Integer);
begin
  MinAutoFitWidth := Value;
end;

function TSHDBGridGeneralOptions.GetOptions: ISHDBGridOptions;
begin
  Supports(Options, ISHDBGridOptions, Result);
end;

function TSHDBGridGeneralOptions.GetRowHeight: Integer;
begin
  Result := RowHeight;
end;

procedure TSHDBGridGeneralOptions.SetRowHeight(Value: Integer);
begin
  RowHeight := Value;
end;

function TSHDBGridGeneralOptions.GetRowLines: Integer;
begin
  Result :=RowLines ;
end;

procedure TSHDBGridGeneralOptions.SetRowLines(Value: Integer);
begin
  RowLines := Value;
end;

function TSHDBGridGeneralOptions.GetRowSizingAllowed: Boolean;
begin
  Result := RowSizingAllowed;
end;

procedure TSHDBGridGeneralOptions.SetRowSizingAllowed(Value: Boolean);
begin
  RowSizingAllowed := Value;
end;

function TSHDBGridGeneralOptions.GetTitleHeight: Integer;
begin
  Result := TitleHeight;
end;

procedure TSHDBGridGeneralOptions.SetTitleHeight(Value: Integer);
begin
  TitleHeight := Value;
end;

function TSHDBGridGeneralOptions.GetToolTips: Boolean;
begin
  Result := ToolTips;
end;

procedure TSHDBGridGeneralOptions.SetToolTips(Value: Boolean);
begin
  ToolTips := Value;
end;

function TSHDBGridGeneralOptions.GetVertScrollBar: ISHDBGridScrollBar;
begin
  Supports(VertScrollBar, ISHDBGridScrollBar, Result);
end;

{ TSHDBGridAllowedOperations }

function TSHDBGridAllowedOperations.GetInsert: Boolean;
begin
  Result := Insert;
end;

procedure TSHDBGridAllowedOperations.SetInsert(Value: Boolean);
begin
  Insert := Value;
end;

function TSHDBGridAllowedOperations.GetUpdate: Boolean;
begin
  Result := Update;
end;

procedure TSHDBGridAllowedOperations.SetUpdate(Value: Boolean);
begin
  Update := Value;
end;

function TSHDBGridAllowedOperations.GetDelete: Boolean;
begin
  Result := Delete;
end;

procedure TSHDBGridAllowedOperations.SetDelete(Value: Boolean);
begin
  Delete := Value;
end;

function TSHDBGridAllowedOperations.GetAppend: Boolean;
begin
  Result := Append;
end;

procedure TSHDBGridAllowedOperations.SetAppend(Value: Boolean);
begin
  Append := Value;
end;

{ TSHDBGridAllowedSelections }

function TSHDBGridAllowedSelections.GetRecordBookmarks: Boolean;
begin
  Result := RecordBookmarks;
end;

procedure TSHDBGridAllowedSelections.SetRecordBookmarks(Value: Boolean);
begin
  RecordBookmarks := Value;
end;

function TSHDBGridAllowedSelections.GetRectangle: Boolean;
begin
  Result := Rectangle;
end;

procedure TSHDBGridAllowedSelections.SetRectangle(Value: Boolean);
begin
  Rectangle := Value;
end;

function TSHDBGridAllowedSelections.GetColumns: Boolean;
begin
  Result := Columns;
end;

procedure TSHDBGridAllowedSelections.SetColumns(Value: Boolean);
begin
  Columns := Value;
end;

function TSHDBGridAllowedSelections.GetAll: Boolean;
begin
  Result := All;
end;

procedure TSHDBGridAllowedSelections.SetAll(Value: Boolean);
begin
  All := Value;
end;

{ TSHDBGridScrollBar }

function TSHDBGridScrollBar.GetTracking: Boolean;
begin
  Result := Tracking;
end;

procedure TSHDBGridScrollBar.SetTracking(Value: Boolean);
begin
  Tracking := Value;
end;

function TSHDBGridScrollBar.GetVisible: Boolean;
begin
  Result := Visible;
end;

procedure TSHDBGridScrollBar.SetVisible(Value: Boolean);
begin
  Visible := Value;
end;

function TSHDBGridScrollBar.GetVisibleMode: TSHDBGridScrollBarVisibleMode;
begin
  Result := VisibleMode;
end;

procedure TSHDBGridScrollBar.SetVisibleMode(Value: TSHDBGridScrollBarVisibleMode);
begin
  VisibleMode := Value;
end;

{ TSHDBGridOptions }

function TSHDBGridOptions.GetAlwaysShowEditor: Boolean;
begin
  Result := AlwaysShowEditor;
end;

procedure TSHDBGridOptions.SetAlwaysShowEditor(Value: Boolean);
begin
  AlwaysShowEditor := Value;
end;

function TSHDBGridOptions.GetAlwaysShowSelection: Boolean;
begin
  Result := AlwaysShowSelection;
end;

procedure TSHDBGridOptions.SetAlwaysShowSelection(Value: Boolean);
begin
  AlwaysShowSelection := Value;
end;

function TSHDBGridOptions.GetCancelOnExit: Boolean;
begin
  Result := CancelOnExit;
end;

procedure TSHDBGridOptions.SetCancelOnExit(Value: Boolean);
begin
  CancelOnExit := Value;
end;

function TSHDBGridOptions.GetClearSelection: Boolean;
begin
  Result := ClearSelection;
end;

procedure TSHDBGridOptions.SetClearSelection(Value: Boolean);
begin
  ClearSelection := Value;
end;

function TSHDBGridOptions.GetColLines: Boolean;
begin
  Result := ColLines;
end;

procedure TSHDBGridOptions.SetColLines(Value: Boolean);
begin
  ColLines := Value;
end;

function TSHDBGridOptions.GetColumnResize: Boolean;
begin
  Result := ColumnResize;
end;

procedure TSHDBGridOptions.SetColumnResize(Value: Boolean);
begin
  ColumnResize := Value;
end;

function TSHDBGridOptions.GetConfirmDelete: Boolean;
begin
  Result := ConfirmDelete;
end;

procedure TSHDBGridOptions.SetConfirmDelete(Value: Boolean);
begin
  ConfirmDelete := Value;
end;

function TSHDBGridOptions.GetData3D: Boolean;
begin
  Result := Data3D;
end;

procedure TSHDBGridOptions.SetData3D(Value: Boolean);
begin
  Data3D := Value;
end;

function TSHDBGridOptions.GetEditing: Boolean;
begin
  Result := Editing;
end;

procedure TSHDBGridOptions.SetEditing(Value: Boolean);
begin
  Editing := Value;
end;

function TSHDBGridOptions.GetEnterAsTab: Boolean;
begin
  Result := EnterAsTab;
end;

procedure TSHDBGridOptions.SetEnterAsTab(Value: Boolean);
begin
  EnterAsTab := Value;
end;

function TSHDBGridOptions.GetIncSearch: Boolean;
begin
  Result := IncSearch;
end;

procedure TSHDBGridOptions.SetIncSearch(Value: Boolean);
begin
  IncSearch := Value;
end;

function TSHDBGridOptions.GetIndicator: Boolean;
begin
  Result := Indicator;
end;

procedure TSHDBGridOptions.SetIndicator(Value: Boolean);
begin
  Indicator := Value;
end;

function TSHDBGridOptions.GetFitRowHeightToText: Boolean;
begin
  Result := FitRowHeightToText;
end;

procedure TSHDBGridOptions.SetFitRowHeightToText(Value: Boolean);
begin
  FitRowHeightToText := Value;
end;

function TSHDBGridOptions.GetFixed3D: Boolean;
begin
  Result := Fixed3D;
end;

procedure TSHDBGridOptions.SetFixed3D(Value: Boolean);
begin
  Fixed3D := Value;
end;

function TSHDBGridOptions.GetFrozen3D: Boolean;
begin
  Result := Frozen3D;
end;

procedure TSHDBGridOptions.SetFrozen3D(Value: Boolean);
begin
  Frozen3D := Value;
end;

function TSHDBGridOptions.GetHighlightFocus: Boolean;
begin
  Result := HighlightFocus;
end;

procedure TSHDBGridOptions.SetHighlightFocus(Value: Boolean);
begin
  HighlightFocus := Value;
end;

function TSHDBGridOptions.GetMultiSelect: Boolean;
begin
  Result := MultiSelect;
end;

procedure TSHDBGridOptions.SetMultiSelect(Value: Boolean);
begin
  MultiSelect := Value;
end;

function TSHDBGridOptions.GetPreferIncSearch: Boolean;
begin
  Result := PreferIncSearch;
end;

procedure TSHDBGridOptions.SetPreferIncSearch(Value: Boolean);
begin
  PreferIncSearch := Value;
end;

function TSHDBGridOptions.GetResizeWholeRightPart: Boolean;
begin
  Result := ResizeWholeRightPart;
end;

procedure TSHDBGridOptions.SetResizeWholeRightPart(Value: Boolean);
begin
  ResizeWholeRightPart := Value;
end;

function TSHDBGridOptions.GetRowHighlight: Boolean;
begin
  Result := RowHighlight;
end;

procedure TSHDBGridOptions.SetRowHighlight(Value: Boolean);
begin
  RowHighlight := Value;
end;

function TSHDBGridOptions.GetRowLines: Boolean;
begin
  Result := RowLines;
end;

procedure TSHDBGridOptions.SetRowLines(Value: Boolean);
begin
  RowLines := Value;
end;

function TSHDBGridOptions.GetRowSelect: Boolean;
begin
  Result := RowSelect;
end;

procedure TSHDBGridOptions.SetRowSelect(Value: Boolean);
begin
  RowSelect := Value;
end;

function TSHDBGridOptions.GetTabs: Boolean;
begin
  Result := Tabs;
end;

procedure TSHDBGridOptions.SetTabs(Value: Boolean);
begin
  Tabs := Value;
end;

function TSHDBGridOptions.GetTitles: Boolean;
begin
  Result := Titles;
end;

procedure TSHDBGridOptions.SetTitles(Value: Boolean);
begin
  Titles := Value;
end;

function TSHDBGridOptions.GetTraceColSizing: Boolean;
begin
  Result := TraceColSizing;
end;

procedure TSHDBGridOptions.SetTraceColSizing(Value: Boolean);
begin
  TraceColSizing := Value;
end;

{ TSHDBGridDisplayOptions }

constructor TSHDBGridDisplayOptions.Create(AOwner: TComponent);
begin
  FFont := TFont.Create;
  FTitleFont := TFont.Create;
  inherited Create(AOwner);
end;

destructor TSHDBGridDisplayOptions.Destroy;
begin
  FFont.Free;
  FTitleFont.Free;
  inherited Destroy;
end;

function TSHDBGridDisplayOptions.GetParentCategory: string;
begin
  Result := Format('%s', ['Grid']);
end;

function TSHDBGridDisplayOptions.GetCategory: string;
begin
  Result := Format('%s', ['Display']);
end;

procedure TSHDBGridDisplayOptions.RestoreDefaults;
begin
  LuminateSelection := True;
  Striped := False;
  Font.Charset := 1;
  Font.Color := clWindowText;
  Font.Height := -11;
  Font.Name := 'Tahoma';
  Font.Pitch := fpDefault;
  Font.Size := 8;
  Font.Style := [];
  TitleFont.Charset := 1;
  TitleFont.Color := clWindowText;
  TitleFont.Height := -11;
  TitleFont.Name := 'Tahoma';
  TitleFont.Pitch := fpDefault;
  TitleFont.Size := 8;
  TitleFont.Style := [];
end;

procedure TSHDBGridDisplayOptions.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TSHDBGridDisplayOptions.SetTitleFont(Value: TFont);
begin
  FTitleFont.Assign(Value);
end;

function TSHDBGridDisplayOptions.GetLuminateSelection: Boolean;
begin
  Result := LuminateSelection;
end;

procedure TSHDBGridDisplayOptions.SetLuminateSelection(Value: Boolean);
begin
  LuminateSelection := Value;
end;

function TSHDBGridDisplayOptions.GetStriped: Boolean;
begin
  Result := Striped;
end;

procedure TSHDBGridDisplayOptions.SetStriped(Value: Boolean);
begin
  Striped := Value;
end;

function TSHDBGridDisplayOptions.GetFont: TFont;
begin
  Result := Font;
end;

//procedure SetFont(Value: TFont);

function TSHDBGridDisplayOptions.GetTitleFont: TFont;
begin
  Result := TitleFont;
end;

//procedure SetTitleFont(Value: TFont);

{ TSHDBGridColorOptions }

constructor TSHDBGridColorOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TSHDBGridColorOptions.Destroy;
begin
  inherited Destroy;
end;

function TSHDBGridColorOptions.GetParentCategory: string;
begin
  Result := Format('%s', ['Grid']);
end;

function TSHDBGridColorOptions.GetCategory: string;
begin
  Result := Format('%s', ['Color']);
end;

procedure TSHDBGridColorOptions.RestoreDefaults;
begin
  Background := clWindow;
  Fixed := clBtnFace;
  CurrentRow := clHighlight;
//  OddRow := cl3DLight;
  OddRow := RGB(244, 246, 255);
  NullValue := clGray;
end;

function TSHDBGridColorOptions.GetBackground: TColor;
begin
  Result := Background;
end;

procedure TSHDBGridColorOptions.SetBackground(Value: TColor);
begin
  Background := Value;
end;

function TSHDBGridColorOptions.GetFixed: TColor;
begin
  Result := Fixed;
end;

procedure TSHDBGridColorOptions.SetFixed(Value: TColor);
begin
  Fixed := Value;
end;

function TSHDBGridColorOptions.GetCurrentRow: TColor;
begin
  Result := CurrentRow;
end;

procedure TSHDBGridColorOptions.SetCurrentRow(Value: TColor);
begin
  CurrentRow := Value;
end;

function TSHDBGridColorOptions.GetOddRow: TColor;
begin
  Result := OddRow;
end;

procedure TSHDBGridColorOptions.SetOddRow(Value: TColor);
begin
  OddRow := Value;
end;

function TSHDBGridColorOptions.GetNullValue: TColor;
begin
  Result := NullValue;
end;

procedure TSHDBGridColorOptions.SetNullValue(Value: TColor);
begin
  NullValue := Value;
end;

{ TSHDBGridFormatOptions }

constructor TSHDBGridFormatOptions.Create(AOwner: TComponent);
begin
  FDisplayFormats := TSHDBGridDisplayFormats.Create;
  FEditFormats := TSHDBGridEditFormats.Create;
  inherited Create(AOwner);
end;

destructor TSHDBGridFormatOptions.Destroy;
begin
  FDisplayFormats.Free;
  FEditFormats.Free;
  inherited Destroy;
end;

function TSHDBGridFormatOptions.GetParentCategory: string;
begin
  Result := Format('%s', ['Grid']);
end;

function TSHDBGridFormatOptions.GetCategory: string;
begin
  Result := Format('%s', ['Formats']);
end;

procedure TSHDBGridFormatOptions.RestoreDefaults;
begin
  DisplayFormats.StringFieldWidth := 150;
  DisplayFormats.IntegerField := '#,###,##0';
  DisplayFormats.FloatField := '#,###,##0.00';
  DisplayFormats.DateTimeField := 'dd.mm.yyyy hh:mm';
  DisplayFormats.DateField := 'dd.mm.yyyy';
  DisplayFormats.TimeField := 'hh:mm:ss';
  DisplayFormats.NullValue := '(NULL)';

  EditFormats.IntegerField := '#';
  EditFormats.FloatField := '0.##';
end;

function TSHDBGridFormatOptions.GetDisplayFormats: ISHDBGridDisplayFormats;
begin
  Supports(DisplayFormats, ISHDBGridDisplayFormats, Result);
end;

function TSHDBGridFormatOptions.GetEditFormats: ISHDBGridEditFormats;
begin
  Supports(EditFormats, ISHDBGridEditFormats, Result);
end;

{ TSHDBGridDisplayFormats }

function TSHDBGridDisplayFormats.GetStringFieldWidth: Integer;
begin
  Result := StringFieldWidth;
end;

procedure TSHDBGridDisplayFormats.SetStringFieldWidth(Value: Integer);
begin
  StringFieldWidth := Value;
end;

function TSHDBGridDisplayFormats.GetIntegerField: string;
begin
  Result := IntegerField;
end;

procedure TSHDBGridDisplayFormats.SetIntegerField(Value: string);
begin
  IntegerField := Value;
end;

function TSHDBGridDisplayFormats.GetFloatField: string;
begin
  Result := FloatField;
end;

procedure TSHDBGridDisplayFormats.SetFloatField(Value: string);
begin
  FloatField := Value;
end;

function TSHDBGridDisplayFormats.GetDateTimeField: string;
begin
  Result := DateTimeField;
end;

procedure TSHDBGridDisplayFormats.SetDateTimeField(Value: string);
begin
  DateTimeField := Value;
end;

function TSHDBGridDisplayFormats.GetDateField: string;
begin
  Result := DateField;
end;

procedure TSHDBGridDisplayFormats.SetDateField(Value: string);
begin
  DateField := Value;
end;

function TSHDBGridDisplayFormats.GetTimeField: string;
begin
  Result := TimeField;
end;

procedure TSHDBGridDisplayFormats.SetTimeField(Value: string);
begin
  TimeField := Value;
end;

function TSHDBGridDisplayFormats.GetNullValue: string;
begin
  Result := NullValue;
end;

procedure TSHDBGridDisplayFormats.SetNullValue(Value: string);
begin
  NullValue := Value;
end;

{ TSHDBGridEditFormats }

function TSHDBGridEditFormats.GetIntegerField: string;
begin
  Result := IntegerField;
end;

procedure TSHDBGridEditFormats.SetIntegerField(Value: string);
begin
  IntegerField := Value;
end;

function TSHDBGridEditFormats.GetFloatField: string;
begin
  Result := FloatField;
end;

procedure TSHDBGridEditFormats.SetFloatField(Value: string);
begin
  FloatField := Value;
end;

end.
