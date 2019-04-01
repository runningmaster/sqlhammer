unit ibSHPSQLDebuggerFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHDriverIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ExtCtrls, ToolWin, StdCtrls, CommCtrl,
  SynEdit, SynEditTypes, Grids, DBGridEh,
  pSHSynEdit, ActnList, AppEvnts, Menus, ComCtrls, VirtualTrees,
  StrUtils,

  pSHIntf, ibSHDebuggerIntf, ibSHPSQLDebuggerClasses, ibSHPSQLDebuggerTokenScaner,
  ibSHPSQLDebuggerStatement;

type
  TibPSQLVariableType = (vtNone, vtInputParameter, vtReturnParameter,
    vtLocalVariable, vtTableField);

  TRunStateValue=(rsReturnValuesChanged,rsSuspendCommandExist,
   rsRun, rsServerError,rsInCatch,rsEndDebug
  );
  TRunState = set of TRunStateValue;

  TibSHPSQLDebuggerForm = class(TibBTComponentForm, IibSHPSQLDebuggerForm,
    IibSHPSQLDebuggerItem, IibSHPSQLProcessor)
    Panel1: TPanel;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    pSHSynEdit1: TpSHSynEdit;
    PopupMenuMessage: TPopupMenu;
    pmiHideMessage: TMenuItem;
    Tree: TVirtualStringTree;
    Splitter2: TSplitter;
    MsgPageControl: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    tsTraceLog: TTabSheet;
    tsResult: TTabSheet;
    WatchesTree: TVirtualStringTree;
    BreakpointsTree: TVirtualStringTree;
    TraceEditor: TpSHSynEdit;
    ResultTree: TVirtualStringTree;
    pmWatch: TPopupMenu;
    DeleteWatch1: TMenuItem;
    AddWatch1: TMenuItem;
    EditWatch1: TMenuItem;
    pmBreak: TPopupMenu;
    DeleteBreakPoint1: TMenuItem;
    EditBreakPoint1: TMenuItem;
    procedure pmiHideMessageClick(Sender: TObject);
    procedure pSHSynEdit1GutterClick(Sender: TObject; Button: TMouseButton;
      X, Y, Line: Integer; Mark: TSynEditMark);
    procedure ResultTreeGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    { Result Tree}
    procedure ResultTreeFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure ResultTreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure ResultTreeIncrementalSearch(Sender: TBaseVirtualTree;
      Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
    procedure pSHSynEdit1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure WatchesTreeGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure WatchesTreeFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure WatchesTreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure WatchesTreeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DeleteWatch1Click(Sender: TObject);
    procedure BreakpointsTreeFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure BreakpointsTreeGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure BreakpointsTreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure BreakpointsTreeDblClick(Sender: TObject);
    procedure AddWatch1Click(Sender: TObject);
    procedure EditWatch1Click(Sender: TObject);
    procedure WatchesTreeChecked(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure BreakpointsTreeChecked(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure WatchesTreeDblClick(Sender: TObject);
    procedure EditBreakPoint1Click(Sender: TObject);
    procedure DeleteBreakPoint1Click(Sender: TObject);
    { End of Result Tree Events}
      
  private
    { Private declarations }
    FRunState: TRunState;
    FTempBreakLine:integer;
    FDDLInfoIntf: IibSHDDLInfo;
    FSQLEditorIntf: IibSHSQLEditor;

    FDDLGenerator: TComponent;
    FDDLGeneratorIntf: IibSHDDLGenerator;

    FDRVQuery: TComponent;
    FCursors: TVariableValueList;


    FDebugerObjectParams: TVariableValueList;
    FDebugerObjectReturns: TVariableValueList;
    FDebugerObjectVariables: TVariableValueList;
    FDebugerObjectFields: TVariableValueList; //For triggers support
    FBreakpoints: TList;
    FLastErrorMsg:string;

    FPageCtrlWndProc: TWndMethod;
    { Fields for IibSHPSQLDebuggerItem }
    FParserPosition: TPoint;
    FFirstStatement: IibSHDebugStatement;
    FLastStatement : IibSHDebugStatement;
    FCurrentStatement: IibSHDebugStatement;

    FTokenScaner: TibSHPSQLDebuggerTokenScaner;
    FServerException: Boolean;
    FCodeNormalizer: IibSHCodeNormalizer;
    FPaused  :boolean;
    vTableComponent: TSHComponent;
    { End of Fields for IibSHPSQLDebuggerItem }

    FExceptionName:string;
    procedure PageCtrlWndProc(var Message: TMessage);

    function GetDRVTransaction: IibSHDRVTransaction;
    function GetDRVQuery: IibSHDRVQuery;
    procedure CreateDRV;
    procedure FreeDRV;
    procedure GutterDrawNotify(Sender: TObject; ALine: Integer; var ImageIndex: Integer);
    function GetDDLCompiler: IibSHDDLCompiler;
    function GetBTCLDatabase: IibSHDatabase;
    function GetPSQLDebugger: IibSHPSQLDebugger;
    function GetDBObject: IibSHDBObject;
    function GetDBProcedure: IibSHProcedure;
    function GetDBTrigger: IibSHTrigger;
    function GetDataType(AName: string): string;
    function GetCursorIndex(AName: string): Integer;
    { IibSHPSQLProcessor }
    function GetCursor(AName: string): Variant;
    procedure SetCursor(AName: string; const Value: Variant);
    function GetVariable(AName: string): Variant;
    procedure SetVariable(AName: string; const Value: Variant);
    function CreateDataSet: TComponent;
    { End of IibSHPSQLProcessor }
  protected
    function StringsToEditorCoord(APoint: TPoint): TBufferCoord;
    procedure EditorMsgVisible(AShow: Boolean = True); override;
    function GetWordAtMouse(Sender:TpSHSynEdit):string;
    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanPause: Boolean; override;

    function GetCanRefresh: Boolean; override;

    procedure Run; override;
    procedure Pause; override;
    

    { IibSHPSQLDebuggerForm }
    function GetCanAddWatch: Boolean;
    function GetCanReset: Boolean;
    function GetCanRunToCursor: Boolean;
    function GetCanSetParameters: Boolean;
    function GetCanSkipStatement: Boolean;
    function GetCanStepOver: Boolean;
    function GetCanToggleBreakpoint: Boolean;
    function GetCanTraceInto: Boolean;
    function GetCanModifyVarValues: Boolean;
    
    function ChangeNotification: Boolean;

    procedure AddWatch;
    procedure DeleteWatch;
    procedure Reset;
    procedure RunToCursor;
    procedure SetParameters;
    procedure SkipStatement;
    procedure StepOver;
    procedure ToggleBreakpoint;
    procedure TraceInto;
    procedure ModifyVarValues;    
    { End of IibSHPSQLDebuggerForm }

    { IibSHPSQLDebuggerItem }
    function GetDebugObjectName: string;
    function GetObjectBody: TStrings;
    function GetDebugObjectType: TGUID;
    function GetParserPosition: TPoint;
    procedure SetParserPosition(Value: TPoint);
    function GetDRVDatabase: IibSHDRVDatabase;
    function IibSHPSQLDebuggerItem.GetDRVTransaction = IGetDRVTransaction;
    function IGetDRVTransaction: IibSHDRVTransaction;
    {
    function GetParentDebugger: IibSHPSQLDebuggerItem;
    function GetChildDebuggers(Index: Integer): IibSHPSQLDebuggerItem;
    procedure SetChildDebuggers(Index: Integer; Value: IibSHPSQLDebuggerItem);
    function GetChildDebuggersCount: Integer;
    function GetEditor: Pointer;
    procedure SetEditor(Value: Pointer);
    }
    function GetFirstStatement: IibSHDebugStatement;
    function GetCurrentStatement: IibSHDebugStatement;
    procedure SetCurrentStatement(Value: IibSHDebugStatement);
    function GetInputParameters(Index: Integer): Variant;
    procedure SetInputParameters(Index: Integer; Value: Variant);
    function GetInputParametersCount: Integer;
    function GetOutputParameters(Index: Integer): Variant;
    procedure SetOutputParameters(Index: Integer; Value: Variant);
    function GetOutputParametersCount: Integer;
    function GetLocalVariables(Index: Integer): Variant;
    procedure SetLocalVariables(Index: Integer; Value: Variant);
    function GetLocalVariablesCount: Integer;
    function GetTokenScaner: TComponent;
    function GetServerException: Boolean;
    procedure SetServerException(Value: Boolean);
    procedure StatementFound(AStatement: IibSHDebugStatement);

    {
    function AddChildDebugger(Value: IibSHPSQLDebuggerItem): Integer;
    }
    function Parse: Boolean;
    procedure ClearStatementTree;
    { End of IibSHPSQLDebuggerItem}

    // Main functionality
    function RunCurrent(ACurrentStatement: IibSHDebugStatement): IibSHDebugStatement;
    function GetNextStatement(ACurrentStatement: IibSHDebugStatement): IibSHDebugStatement;
    function GetChildStatement(ACurrentStatement: IibSHDebugStatement): IibSHDebugStatement;
    procedure DoSuspend(IsDirectCommand:boolean);
    procedure ShowStatement(AStatement: string);
    procedure ShowTraceMsg(AMsg: string);
    procedure ShowErrorMsg(AMsg: string);
    procedure UpdateWatches;
    procedure ExecuteExpression(ACurrentStatement: IibSHDebugStatement);
    function  ExecuteStringExpression(const Expression:string;IsCondition:boolean=False;MayBeBoolean :boolean =True):variant; // for Watch and Break
    procedure ExecuteSelect(ACurrentStatement: IibSHDebugStatement);
    procedure ExecuteFunction(ACurrentStatement: IibSHDebugStatement);    
    procedure ExecuteProcedure(ACurrentStatement: IibSHDebugStatement);
    function  PrepareDynStatementString(const DynStatement:string):string;
    procedure ExecuteStatement(ACurrentStatement: IibSHDebugStatement);
    function ExecuteCommon(ACurrentStatement: IibSHDebugStatement; AOverrideStatement: string; UseReplacement: Boolean): Variant;
    procedure ExecuteSimple(ACurrentStatement: IibSHDebugStatement);
    function ExecuteCondition(ACurrentStatement: IibSHDebugStatement): Boolean;
    function ExecuteCircle(ACurrentStatement: IibSHDebugStatement): Boolean;
    function ExecuteErrorHandler(ACurrentStatement: IibSHDebugStatement): Boolean;
    procedure  ExecuteException(ACurrentStatement: IibSHDebugStatement);
    procedure DoCursorOperation(ACurrentStatement: IibSHDebugStatement);

    procedure ExecutionError(AMsg: string);
    function NormalizeName(const AName: string): string;
    function ReplaceParametersInExpression(AStatement: string; AReplaceAll: Boolean = False;DoCast:boolean=True): string;
    function NormalizeParametersInExpression(AStatement: string; AReplaceAll: Boolean = False): string;
    procedure DispositionVariable(AVariableName: string; var VariableType: TibPSQLVariableType; var Index: Integer);
    function ValueToStringCast(AValue: Variant; ADataType: string): string;
    // End of Main functionality

    procedure DoOnSpecialLineColors(Sender: TObject;
      Line: Integer; var Special: Boolean; var FG, BG: TColor); override;
    function DoOnOptionsChanged: Boolean; override;
    function GetCanDestroy: Boolean; override;

    procedure SetTreeEvents;

    procedure OutputDebug;
    procedure LoadObject;
    procedure PrepareResultTree;
    //BreakPoint support
    procedure InternalToggleBreakpoint(ALine: Integer);
    procedure RemoveFromBreakPointList(ALine: Integer; FromTree:boolean=False);
    function IndexInBreakPointList(ALine: Integer):Integer;
    procedure ClearBreakPass;



    property Variable[AName: string] : Variant read GetVariable write SetVariable;
//    property Cursor[AName: string] : Variant read GetCursor write SetCursor;
    property DataType[AName: string] : string read GetDataType;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure BringToTop; override;

    function DebugValue(const Statement:string):string;
    procedure AddWatchExpression(const Expression:string);
    
    property BTCLDatabase: IibSHDatabase read GetBTCLDatabase;
    property DDLInfo: IibSHDDLInfo read FDDLInfoIntf;
    property SQLEditor: IibSHSQLEditor read FSQLEditorIntf;
    property DDLGenerator: IibSHDDLGenerator read FDDLGeneratorIntf;
    property DDLCompiler: IibSHDDLCompiler read GetDDLCompiler;
    property DRVTransaction: IibSHDRVTransaction read GetDRVTransaction;
    property DRVQuery: IibSHDRVQuery read GetDRVQuery;

    property PSQLDebugger: IibSHPSQLDebugger read GetPSQLDebugger;
    property DBObject: IibSHDBObject read GetDBObject;
    property DBProcedure: IibSHProcedure read GetDBProcedure;
    property DBTrigger: IibSHTrigger read GetDBTrigger;
    property CurrentStatement: IibSHDebugStatement read FCurrentStatement
      write SetCurrentStatement;
  end;

  PResultTreeRec = ^TResultTreeRec;
  TResultTreeRec = record
    FieldValues: TStrings;
  end;

  PWatchTreeRec = ^TWatchTreeRec;
  TWatchTreeRec  = record
    WatchName: string;
    Value    : string;
    Enabled  : boolean;
  end;

  PBreekPointTreeRec = ^TBreekPointTreeRec;
  TBreekPointTreeRec  = record
    Line     : Integer;
    PassCount: Integer;
    Condition: string;
    Enabled  : boolean;

    FCounter   : Integer;
  end;

var
  ibSHPSQLDebuggerForm: TibSHPSQLDebuggerForm;

implementation

uses
  ibSHConsts, ibSHRegExpesions, DB, ibBTBreakEditor,
  ibSHPSQLDebuggerActions, ibBTModifyVarDebugValue,ib_errors;

{$R *.dfm}

const
  img_info   = 7;
  img_warning = 8;
  img_error  = 9;
  img_current = 11;
  img_statement = 12;
  img_breakpoint = 13;
  img_current_breakpoint = 14;

var
     DebugHint:THintWindow;

function RevealHint (Control: TControl;const HintText:string ): THintWindow;
var
 ShortHint: string;
 HintPos: TPoint;
 HintBox: TRect;
begin
{ Создаем окно: }
 if not Assigned(DebugHint) then
  DebugHint:=THintWindow.Create(Control);

 Result :=DebugHint;
 Result.Color:=$00D9FFFF;
// ShortHint := Copy(HintText,1,1255);
 ShortHint :=HintText;
{ Вычисляем месторасположение и размер окна подсказки }
 GetCursorPos(HintPos);
 HintPos.Y:=HintPos.Y+10;
{ HintPos := Control.ClientOrigin;
 Inc(HintPos.Y, Control.Height + 6);// Позиция хинта}
 HintBox := Bounds(0, 0, Screen.Width, 0);
 DrawText(Result.Canvas.Handle,  PChar(ShortHint) , -1, HintBox,
  DT_CALCRECT or DT_LEFT or DT_WORDBREAK or DT_NOPREFIX
 );
 OffsetRect(HintBox, HintPos.X, HintPos.Y);
 Inc(HintBox.Right, 6);
 Inc(HintBox.Bottom, 2);
{ Теперь показываем окно: }
 Result.ActivateHint(HintBox, ShortHint);
end; {RevealHint}


procedure RemoveHint (var Hint: THintWindow);
{----------------------------------------------------------------}
{ Освобождаем дескриптор окна всплывающей подсказки, выведенной }
{ предыдущим RevealHint.                     }
{----------------------------------------------------------------}
begin
 if Assigned(Hint) then
 begin
  Hint.ReleaseHandle;
  Hint.Free;
  Hint := nil;
 end;
end;

function MakeLastErrorCode(aSQLCode,aIBCode:integer):TibErrorCode;
begin
 Result.SQLCode:=aSQLCode;
 Result.IBErrorCode:=aIBCode;
end;

{ TibBTDDLForm }

constructor TibSHPSQLDebuggerForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  FPageCtrlWndProc := MsgPageControl.WindowProc;
//  MsgPageControl.WindowProc := PageCtrlWndProc;

  //
  // Снятие интерфейсов с компонента
  //
  Supports(Component, IibSHDDLInfo, FDDLInfoIntf);
  Supports(Component, IibSHSQLEditor, FSQLEditorIntf);
  Assert(DDLInfo <> nil, 'DDLInfo = nil');
  //
  // Инициализация полей
  //
  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
  EditorMsg := TraceEditor;
  EditorMsg.Lines.Clear;
  {
  EditorMsg.OnGutterDraw := GutterDrawNotify;
  EditorMsg.GutterDrawer.ImageList := ImageList1;
  EditorMsg.GutterDrawer.Enabled := True;
  }
  Editor.OnGutterDraw := GutterDrawNotify;
  Editor.GutterDrawer.ImageList := ImageList1;
  Editor.GutterDrawer.Enabled := True;

  FocusedControl := Editor;
  //
  // Регистрация редактора
  //
  RegisterEditors;
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
  // Внутренние переменные
  //
  FCursors := TVariableValueList.Create;
  FDebugerObjectParams := TVariableValueList.Create;
  FDebugerObjectReturns := TVariableValueList.Create;
  FDebugerObjectVariables := TVariableValueList.Create;
  FDebugerObjectFields := TVariableValueList.Create;
  FTokenScaner := TibSHPSQLDebuggerTokenScaner.Create(Self);
  FBreakpoints := TList.Create;
  FDRVQuery := nil;
  FServerException := False;

  SetTreeEvents;
end;

destructor TibSHPSQLDebuggerForm.Destroy;
begin
  if not BTCLDatabase.WasLostConnect then Rollback;
  FDDLGeneratorIntf := nil;
  FDDLGenerator.Free;

  FDDLInfoIntf := nil;
  FSQLEditorIntf := nil;
  FreeDRV;
  FBreakpoints.Free;
  FDebugerObjectVariables.Free;
  FDebugerObjectReturns.Free;
  FDebugerObjectParams.Free;
  FCursors.Free;
  ClearStatementTree;
  if Assigned(vTableComponent) then
     FreeAndNil(vTableComponent);
  inherited Destroy;
end;

procedure TibSHPSQLDebuggerForm.BringToTop;
begin
  inherited BringToTop;
end;


procedure TibSHPSQLDebuggerForm.ResultTreeFreeNode(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PResultTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
  begin
    Data.FieldValues.Free;
//    Finalize(Data^);
  end;
end;

procedure TibSHPSQLDebuggerForm.ResultTreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PResultTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) and (TextType = ttNormal) and
    (Column >= 0) and (Column < Data.FieldValues.Count)  then
    CellText := Data.FieldValues[Column];
end;

procedure TibSHPSQLDebuggerForm.ResultTreeIncrementalSearch(
  Sender: TBaseVirtualTree; Node: PVirtualNode;
  const SearchText: WideString; var Result: Integer);
var
  Data: PResultTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if (Tree.FocusedColumn >= 0) and (Tree.FocusedColumn < Data.FieldValues.Count) then
    if Pos(AnsiUpperCase(SearchText), AnsiUpperCase(Data.FieldValues[Tree.FocusedColumn])) <> 1 then Result := 1;
end;

procedure TibSHPSQLDebuggerForm.PageCtrlWndProc(var Message: TMessage);
begin
  with Message do
    if Msg = TCM_ADJUSTRECT then
    begin
      FPageCtrlWndProc(Message);
      PRect(LParam)^.Left := 0;
      PRect(LParam)^.Right := MsgPageControl.Parent.ClientWidth;
      PRect(LParam)^.Top := PRect(LParam)^.Top - 3;
      PRect(LParam)^.Bottom := MsgPageControl.Parent.ClientHeight;
    end else
      FPageCtrlWndProc(Message);
end;

function TibSHPSQLDebuggerForm.GetDRVTransaction: IibSHDRVTransaction;
begin
  if Assigned(PSQLDebugger) then
    Result := PSQLDebugger.DRVTransaction
  else
    Result :=  nil;
end;

function TibSHPSQLDebuggerForm.GetDRVQuery: IibSHDRVQuery;
begin
  Supports(FDRVQuery, IibSHDRVQuery, Result);
end;

procedure TibSHPSQLDebuggerForm.CreateDRV;
var
  vComponentClass: TSHComponentClass;
begin
  if not Assigned(DRVQuery) then
  begin
    //
    // Получение реализации DRVQuery
    //
    vComponentClass := Designer.GetComponent(BTCLDatabase.BTCLServer.DRVNormalize(IibSHDRVQuery));
    if Assigned(vComponentClass) then FDRVQuery := vComponentClass.Create(Self);
    Assert(DRVQuery <> nil, 'DRVQuery = nil');
  end;
  //
  // Установка свойств DRVTransaction и DRVQuery
  //
  DRVQuery.Transaction := DRVTransaction;
  DRVQuery.Database := BTCLDatabase.DRVQuery.Database;
end;

procedure TibSHPSQLDebuggerForm.FreeDRV;
begin
  if Assigned(FDRVQuery) then
    FreeAndNil(FDRVQuery);
end;

procedure TibSHPSQLDebuggerForm.GutterDrawNotify(Sender: TObject; ALine: Integer;
  var ImageIndex: Integer);
var
  vMarks: TSynEditMarks;
  I: Integer;
  vIsCurrent: Boolean;
  vIsBreakpoint: Boolean;
begin
  //GutterDrawNotify не в координатах эдитора, а в номерах строк!!!
  Editor.Marks.GetMarksForLine(ALine + 1, vMarks);
  ImageIndex := -1;
  vIsCurrent := False;
  vIsBreakpoint := False;
  for I := 1 to MAX_MARKS do
  begin
    if Assigned(vMarks[I]) then
      if (not vMarks[I].IsBookmark) then
      begin
        if vMarks[I].ImageIndex = img_statement then
          ImageIndex := img_statement
        else
        if vMarks[I].ImageIndex = img_breakpoint then
          vIsBreakpoint := True
        else
        if vMarks[I].ImageIndex = img_current then
          vIsCurrent := True
      end;
  end;
  if vIsBreakpoint and vIsCurrent then
    ImageIndex := img_current_breakpoint
  else
  if vIsBreakpoint then
    ImageIndex := img_breakpoint
  else
  if (vIsCurrent) and not (rsRun in FRunState) then
    ImageIndex := img_current;
  {
  if ALine = 0 then
  begin

  end else
  begin
    if Pos('Commit or Rollback', EditorMsg.Lines[ALine]) > 0 then
      ImageIndex := img_warning;
  end;
  }
end;

function TibSHPSQLDebuggerForm.GetDDLCompiler: IibSHDDLCompiler;
begin

end;

function TibSHPSQLDebuggerForm.GetBTCLDatabase: IibSHDatabase;
begin
  Supports(Component, IibSHDatabase, Result);
end;

function TibSHPSQLDebuggerForm.GetPSQLDebugger: IibSHPSQLDebugger;
begin
  Supports(Component, IibSHPSQLDebugger, Result);
end;

function TibSHPSQLDebuggerForm.GetDBObject: IibSHDBObject;
begin
  if Assigned(PSQLDebugger) then
    Supports(PSQLDebugger.DebugComponent, IibSHDBObject, Result)
end;

function TibSHPSQLDebuggerForm.GetDBProcedure: IibSHProcedure;
begin
  if Assigned(PSQLDebugger) then
    Supports(PSQLDebugger.DebugComponent, IibSHProcedure, Result)
end;

function TibSHPSQLDebuggerForm.GetDBTrigger: IibSHTrigger;
begin
  if Assigned(PSQLDebugger) then
    Supports(PSQLDebugger.DebugComponent, IibSHTrigger, Result)
end;

function TibSHPSQLDebuggerForm.GetDataType(AName: string): string;
var
  vVariableType: TibPSQLVariableType;
  vIndex: Integer;
begin
  Result := EmptyStr;
  DispositionVariable(AName, vVariableType, vIndex);
  if vVariableType <> vtNone then
  begin
    case vVariableType of
      vtInputParameter: Result := FDebugerObjectParams.DataTypeByIndex[vIndex];
      vtReturnParameter: Result := FDebugerObjectReturns.DataTypeByIndex[vIndex];
      vtLocalVariable: Result := FDebugerObjectVariables.DataTypeByIndex[vIndex];
      vtTableField: Result := FDebugerObjectFields.DataTypeByIndex[vIndex];
    end;
  end;
end;

function TibSHPSQLDebuggerForm.GetCursorIndex(AName: string): Integer;
begin
  Result := FCursors.IndexOf(AName);
  if Result = -1 then
    Result := FCursors.AddWithDataType(AName, 'CHAR(8)');
end;

function TibSHPSQLDebuggerForm.GetCursor(AName: string): Variant;
begin
  Result := FCursors.ValueByIndex[GetCursorIndex(AName)];
end;

procedure TibSHPSQLDebuggerForm.SetCursor(AName: string;
  const Value: Variant);
begin
  FCursors.ValueByIndex[GetCursorIndex(AName)] := Value;
end;

function TibSHPSQLDebuggerForm.GetVariable(AName: string): Variant;
var
  vVariableType: TibPSQLVariableType;
  vIndex: Integer;
begin
  VarClear(Result);
  DispositionVariable(AName, vVariableType, vIndex);
  if vVariableType <> vtNone then
  begin
    case vVariableType of
      vtInputParameter: Result := FDebugerObjectParams.ValueByIndex[vIndex];
      vtReturnParameter: Result := FDebugerObjectReturns.ValueByIndex[vIndex];
      vtLocalVariable: Result := FDebugerObjectVariables.ValueByIndex[vIndex];
      vtTableField: Result := FDebugerObjectFields.ValueByIndex[vIndex];
    end;
  end
  else
   Result := VarArrayOf([null,null])
end;

procedure TibSHPSQLDebuggerForm.SetVariable(AName: string;
  const Value: Variant);
var
  vVariableType: TibPSQLVariableType;
  vIndex: Integer;
begin
  DispositionVariable(AName, vVariableType, vIndex);
  if (vVariableType <> vtNone) and (vIndex > -1) then
  begin
    case vVariableType of
      vtInputParameter: FDebugerObjectParams.ValueByIndex[vIndex] := Value;
      vtReturnParameter:
      begin
       FDebugerObjectReturns.ValueByIndex[vIndex] := Value;
       Include(FRunState,rsReturnValuesChanged);
      end;
      vtLocalVariable: FDebugerObjectVariables.ValueByIndex[vIndex] := Value;
      vtTableField: FDebugerObjectFields.ValueByIndex[vIndex] := Value;
    end;
  end;
end;

function TibSHPSQLDebuggerForm.CreateDataSet: TComponent;
var
  vComponentClass: TSHComponentClass;
  vDRVDataSet: IibSHDRVDataset;
begin
  Result := nil;
  vComponentClass := Designer.GetComponent(BTCLDatabase.BTCLServer.DRVNormalize(IibSHDRVDataSet));
  if Assigned(vComponentClass) then
  begin
    Result := vComponentClass.Create(nil);
    if Supports(Result, IibSHDRVDataSet, vDRVDataSet) then
    begin
      vDRVDataSet.ReadTransaction := DRVTransaction;
      vDRVDataSet.WriteTransaction := DRVTransaction;
      vDRVDataSet.Database := BTCLDatabase.DRVQuery.Database;
    end
    else
      FreeAndNil(Result);
  end;
end;


function TibSHPSQLDebuggerForm.StringsToEditorCoord(
  APoint: TPoint): TBufferCoord;
begin
  Result := TBufferCoord(Point(APoint.X, APoint.Y + 1));
end;

procedure TibSHPSQLDebuggerForm.EditorMsgVisible(AShow: Boolean = True);
begin
  if AShow then
  begin
    Splitter1.Visible := True;
    MsgPageControl.Visible := True;
  end else
  begin
    MsgPageControl.Visible := False;
    Splitter1.Visible := False;
  end;
end;

function TibSHPSQLDebuggerForm.GetCanRun: Boolean;
begin
  Result := not (rsRun in FRunState)
end;

function TibSHPSQLDebuggerForm.GetCanPause: Boolean;
begin
    Result:=  (rsRun in FRunState)
end;

function TibSHPSQLDebuggerForm.GetCanRefresh: Boolean;
begin
  Result := False;
end;

procedure TibSHPSQLDebuggerForm.Pause;
begin
 if rsRun in FRunState then
   FPaused:=True
end;

procedure TibSHPSQLDebuggerForm.Run;
var
   vIsFirstRunStatement:boolean;
   BreakIndex:integer;
   breaked:boolean;
begin
  inherited;
  Include(FRunState,rsRun);
  Designer.UpdateActions;
  vIsFirstRunStatement:=True;
  FPaused  :=False;
{  BtnRun.Enabled    :=False;
  BtnPause.Enabled  :=True;}
  try
   try
    While
     (FCurrentStatement<>nil) and not (rsServerError in FRunState) and
     (  vIsFirstRunStatement or
       (FTempBreakLine<>FCurrentStatement.BeginOfStatement.Y+1)
      )
    do
    begin
     vIsFirstRunStatement:=False;
     StepOver;
     if FCurrentStatement<>nil then
     begin
       BreakIndex:=IndexInBreakPointList(FCurrentStatement.BeginOfStatement.Y+1);
       if (BreakIndex>=0) then
       with      PBreekPointTreeRec(FBreakpoints[BreakIndex])^ do
       if Enabled then
       begin
         if (PassCount>0) or (Condition<>'') then
         begin
           if  (Condition<>'') then
             breaked:= ExecuteStringExpression(Condition,True)
           else
             breaked:=True;
           if breaked then
            if PassCount<=0 then
             Break
            else
            begin
               Inc(FCounter);
               if FCounter=PassCount then
               begin
                FCounter:=0;
                Break;
               end
            end
         end
         else
           Break    ;
       end;
       Application.ProcessMessages;
       if FPaused then
       begin
        Break
       end;
     end
    end;
    if rsServerError in FRunState then
     raise Exception.Create(FLastErrorMsg);
   except
    if FCurrentStatement<>nil then
    begin
      Editor.InvalidateLine(FCurrentStatement.BeginOfStatement.Y + 1);
      Editor.CaretY:=FCurrentStatement.BeginOfStatement.Y + 1;
      Editor.EnsureCursorPosVisible;
    end;
    raise;
   end;
  finally
   FTempBreakLine:=-1;
   Exclude(FRunState,rsRun);
   Exclude(FRunState,rsServerError);
   Exclude(FRunState,rsInCatch);

   if FPaused and (FCurrentStatement<>nil) then
   begin
    Editor.InvalidateLine(FCurrentStatement.BeginOfStatement.Y + 1);
    Editor.CaretY:=FCurrentStatement.BeginOfStatement.Y + 1;
    Editor.EnsureCursorPosVisible;
    FPaused:=False
   end

  end
//  OutputDebug;
end;

function TibSHPSQLDebuggerForm.GetCanAddWatch: Boolean;
begin
  Result := not (rsRun in FRunState)
end;

function TibSHPSQLDebuggerForm.GetCanReset: Boolean;
begin
  Result := True
end;

function TibSHPSQLDebuggerForm.GetCanRunToCursor: Boolean;
begin
  Result := not (rsRun in FRunState)
end;

function TibSHPSQLDebuggerForm.GetCanSetParameters: Boolean;
begin
  Result := not (rsRun in FRunState)
  //Result := FFirstStatement = FCurrentStatement;  ?
end;

function TibSHPSQLDebuggerForm.GetCanSkipStatement: Boolean;
begin
 Result:=False
end;

function TibSHPSQLDebuggerForm.GetCanStepOver: Boolean;
begin
  Result := Assigned(FCurrentStatement) and
     not (rsRun in FRunState)
  ;
end;

function TibSHPSQLDebuggerForm.GetCanToggleBreakpoint: Boolean;
begin
  Result := Assigned(Editor) and Assigned(DBObject);//Не делаем полной проверки для экономии ресурса
end;

function TibSHPSQLDebuggerForm.GetCanTraceInto: Boolean;
begin
  Result:=False
end;

function TibSHPSQLDebuggerForm.ChangeNotification: Boolean;
begin
  LoadObject;
  Result:=True
end;

function TibSHPSQLDebuggerForm.DebugValue(const Statement:string):string;
var
  VarName  :string;
  VarValue :Variant;
  OldState:TRunState;
begin
   VarName:=Statement;
   VarValue:=GetVariable(VarName);
   OldState:=FRunState;
   try
     if VarIsArray(VarValue) then // Сигнал что переменной не существует
     begin
      VarValue:=ExecuteStringExpression(Statement);
      if VarIsEmpty(VarValue) then
       Result:='Can''t calculate expression'
      else
      if VarIsNull(VarValue) then
       Result:='NULL'
      else
       Result:=VarToStr(VarValue)
     end
     else
     if VarIsEmpty(VarValue) then
       Result:='unAssigned'
     else
     if VarIsNull(VarValue) then
       Result:='NULL'
     else
     case VarType(VarValue) of
      varOleStr,  varString :     Result:=''''+VarToStr(VarValue)+'''';
     else
       Result:=VarToStr(VarValue)
     end;
   finally
    FRunState:=OldState
   end;
end;

procedure TibSHPSQLDebuggerForm.AddWatch;
begin
  if Editor.SelText='' then
   AddWatchExpression(Editor.WordAtCaret)
  else
   AddWatchExpression(Editor.SelText)
end;

procedure TibSHPSQLDebuggerForm.AddWatchExpression(const Expression:string);
var
  Node: PVirtualNode;
  NodeData:PWatchTreeRec;
begin
   if Length(Expression)=0 then
    Exit;
   Node   := WatchesTree.AddChild(nil);
   Node.CheckType :=ctCheckBox;
   Node.CheckState:=csCheckedNormal;
   NodeData:= WatchesTree.GetNodeData(Node);
   NodeData.WatchName := Expression;
   NodeData.Value     := DebugValue(Expression);
   NodeData.Enabled   := True
end;

procedure TibSHPSQLDebuggerForm.DeleteWatch;
begin
 if WatchesTree.FocusedNode<>nil then
  WatchesTree.DeleteNode(WatchesTree.FocusedNode,False);
end;


procedure TibSHPSQLDebuggerForm.Reset;
var
  vOldInputVariableList: TVariableValueList;
begin
  if    rsRun in FRunState then
   FPaused:=True;
  FServerException := False;
  if Assigned(DRVQuery) then
   if DRVQuery.Transaction.InTransaction then
     DRVQuery.Transaction.Rollback;
  vOldInputVariableList := TVariableValueList.Create;
  try
    vOldInputVariableList.Assign(FDebugerObjectParams);
    FDebugerObjectParams.Clear;
    FDebugerObjectReturns.Clear;
    FDebugerObjectVariables.Clear;
    FDebugerObjectFields.Clear;
    ClearStatementTree;
    LoadObject;
    FDebugerObjectParams.AssignValues(vOldInputVariableList);
  finally
    vOldInputVariableList.Free;
    ClearBreakPass;
  end;
end;

procedure TibSHPSQLDebuggerForm.RunToCursor;
begin
  FTempBreakLine:=Editor.CaretY;
  try
   Run
  finally
   FTempBreakLine:=-1
  end;
end;

procedure TibSHPSQLDebuggerForm.SetParameters;
var
  vCodeNormalizer: IibSHCodeNormalizer;
  vExecutionSQL: string;
  S: string;
  I: Integer;
  function GetNormalizeName(const ACaption: string): string;
  begin
    if Assigned(vCodeNormalizer) then
      Result := vCodeNormalizer.MetadataNameToSourceDDL(BTCLDatabase, ACaption)
    else
      Result := ACaption;
  end;
  function InputParameters(ADRVQuery: IibSHDRVQuery): Boolean;
  var
    vDRVParams: IibSHDRVParams;
    vInputParameters: IibSHInputParameters;
    vComponentClass: TSHComponentClass;
    vComponent: TSHComponent;
    I: Integer;
  begin
    Result := False;
    vComponentClass := Designer.GetComponent(IibSHInputParameters);
    if Assigned(vComponentClass) and Supports(ADRVQuery, IibSHDRVParams, vDRVParams) then
    begin
      for I := 0 to Pred(FDebugerObjectParams.Count) do
      begin
        if vDRVParams.ParamExists(FDebugerObjectParams[I]) then
          vDRVParams.SetParamByName(FDebugerObjectParams[I], FDebugerObjectParams.ValueByIndex[I]);
      end;
      vComponent := vComponentClass.Create(nil);
      try
        if Supports(vComponent, IibSHInputParameters, vInputParameters) then
        begin
          Result := vInputParameters.InputParameters(vDRVParams);
          vInputParameters := nil;
        end;
      finally
        FreeAndNil(vComponent);
      end;
      if Result then
        for I := 0 to Pred(FDebugerObjectParams.Count) do
        begin
          if vDRVParams.ParamExists(FDebugerObjectParams[I]) then
            FDebugerObjectParams.ValueByIndex[I] := vDRVParams.ParamByIndex[I];
        end;
      vDRVParams := nil;
    end;
  end;
begin
  if GetCanSetParameters then
  begin
    Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer);
    if FDebugerObjectParams.Count > 0 then
    begin
      for I := 0 to Pred(FDebugerObjectParams.Count) do
       S := S + Format(':%s, ' , [GetNormalizeName(FDebugerObjectParams[I])]);
      Delete(S, Length(S) - 1, 2);
      vExecutionSQL := Format('%s(%s)', [GetNormalizeName(DBProcedure.Caption), S]);
    end
    else
      vExecutionSQL := GetNormalizeName(DBProcedure.Caption);
    if FDebugerObjectReturns.Count > 0 then
      vExecutionSQL := Format('SELECT * FROM %s', [vExecutionSQL])
    else
      vExecutionSQL := Format('EXECUTE PROCEDURE %s', [vExecutionSQL]);

    if DRVQuery.Active then DRVQuery.Close;
    DRVQuery.SQL.Text := vExecutionSQL;
    InputParameters(DRVQuery);
  end;
end;

procedure TibSHPSQLDebuggerForm.SkipStatement;
begin

end;


function  GetNextWhenStatement(curStmt:IibSHDebugStatement):IibSHDebugStatement;
var
   iTemp:IibSHDebugStatement;

function WhenStmtIsValid(whStmt:IibSHDebugStatement):boolean;
var
   chTemp:IibSHDebugStatement;
begin
 Result:=True;
 chTemp:=curStmt.ParentStatement;
 while Assigned(chTemp) and Result do
 begin
   Result:=chTemp<>whStmt;
   chTemp:=chTemp.ParentStatement;
 end;
 
end;

begin
      Result:=nil;
      if curStmt.OperatorType=dotLastEnd then Exit; 
      iTemp:=curStmt.ParentStatement;
      while Assigned(iTemp) and not Assigned(Result) do
      begin
       Result:=iTemp.ErrorHandlerStmt;
       if Assigned(Result) then
        if not   WhenStmtIsValid(Result) then
          Result:=nil;
       iTemp:=iTemp.ParentStatement;
      end;
end;

procedure TibSHPSQLDebuggerForm.StepOver;
var
   NStatement:IibSHDebugStatement;



 procedure RaiseException(doRaise:boolean) ;
 begin
   if rsInCatch in FRunState then Exit;

       Editor.InvalidateLine(FCurrentStatement.BeginOfStatement.Y + 1);
       Editor.CaretY:=FCurrentStatement.BeginOfStatement.Y + 1;
       Editor.EnsureCursorPosVisible;
       if doRaise then
        raise   Exception.Create(
         'SQLCODE='+IntToStr(CurrentStatement.LastErrorCode.SQLCode)+#13#10+
         'GDSCODE='+IntToStr(CurrentStatement.LastErrorCode.IBErrorCode)+#13#10+
         FLastErrorMsg
        )
       else
        MessageDlg(
         'SQLCODE='+IntToStr(CurrentStatement.LastErrorCode.SQLCode)+#13#10+
         'GDSCODE='+IntToStr(CurrentStatement.LastErrorCode.IBErrorCode)+#13#10+
          FLastErrorMsg
        ,
          mtError,[mbOK],-1
        );

 end;

begin
  if Assigned(CurrentStatement) and not (CurrentStatement.OperatorType in [dotLastEnd{,dotExit}]) then
  begin
    NStatement       := RunCurrent(CurrentStatement);
    if ( rsServerError in FRunState) then
    begin

      SetLocalVariables(FDebugerObjectVariables.IndexOf('SQLCODE'),CurrentStatement.LastErrorCode.SQLCode); //SQLCODE
      SetLocalVariables(FDebugerObjectVariables.IndexOf('GDSCODE'),CurrentStatement.LastErrorCode.IBErrorCode); //GDSCODE



       if not Assigned(NStatement) then
         NStatement  := GetNextWhenStatement(CurrentStatement)
       else
       begin
        if  (NStatement.OperatorType<>dotErrorHandler) then
         NStatement  :=  GetNextWhenStatement(NStatement)
       end;
//       if CurrentStatement.OperatorType=dotErrorHandler then


       if Assigned(NStatement) then
       begin
        RaiseException(False);
        Include(FRunState,rsInCatch);
        NStatement.LastErrorCode:=CurrentStatement.LastErrorCode;
       end
       else
         RaiseException(True);
       CurrentStatement:=NStatement

    end
    else
    if  Assigned(NStatement) and (NStatement.OperatorType=dotErrorHandler) then
     CurrentStatement := GetNextStatement(NStatement.ParentStatement)
    else
     CurrentStatement := NStatement;
    if CurrentStatement=nil then
    begin
//     CurrentStatement:=FFirstStatement.ChildStatements[FFirstStatement.ChildStatementsCount-1]
     CurrentStatement:=FLastStatement;
     Editor.CaretY:=CurrentStatement.BeginOfStatement.Y+1;
     Editor.EnsureCursorPosVisible
    end
    else
    if not (rsRun in FRunState) then
    begin
     Editor.CaretY:=CurrentStatement.BeginOfStatement.Y+1;
     Editor.EnsureCursorPosVisible
    end;
  end
  else
  if not Assigned(CurrentStatement)  or (CurrentStatement.OperatorType=dotLastEnd) then
  begin
   CurrentStatement:=nil;
   DoSuspend(False);
   FRunState:=[];
   Include(FRunState,rsEndDebug);
   ClearBreakPass;
  end
end;

procedure TibSHPSQLDebuggerForm.ToggleBreakpoint;
begin
  InternalToggleBreakpoint(Editor.CaretY);
end;

procedure TibSHPSQLDebuggerForm.TraceInto;
begin

end;

{ IibSHPSQLDebuggerItem }

function TibSHPSQLDebuggerForm.GetDebugObjectName: string;
begin
  if Assigned(DBObject) then
    Result := DBObject.ObjectName
  else
    Result := EmptyStr;
end;

function TibSHPSQLDebuggerForm.GetObjectBody: TStrings;
begin
  Result := DDLInfo.DDL;
end;

function TibSHPSQLDebuggerForm.GetDebugObjectType: TGUID;
begin
  if Assigned(PSQLDebugger) and Assigned(PSQLDebugger.DebugComponent) then
    Result := PSQLDebugger.DebugComponent.ClassIID
  else
    Result := IUnknown;
end;

function TibSHPSQLDebuggerForm.GetParserPosition: TPoint;
begin
  Result := FParserPosition;
end;

procedure TibSHPSQLDebuggerForm.SetParserPosition(Value: TPoint);
begin
  FParserPosition := Value;
end;

function TibSHPSQLDebuggerForm.GetDRVDatabase: IibSHDRVDatabase;
begin
  Result := DRVTransaction.Database;
end;

function TibSHPSQLDebuggerForm.IGetDRVTransaction: IibSHDRVTransaction;
begin
  Result := DRVTransaction;
end;
{
function TibSHPSQLDebuggerForm.GetParentDebugger: IibSHPSQLDebuggerItem;
begin

end;

function TibSHPSQLDebuggerForm.GetChildDebuggers(
  Index: Integer): IibSHPSQLDebuggerItem;
begin

end;

procedure TibSHPSQLDebuggerForm.SetChildDebuggers(Index: Integer;
  Value: IibSHPSQLDebuggerItem);
begin

end;

function TibSHPSQLDebuggerForm.GetChildDebuggersCount: Integer;
begin

end;

function TibSHPSQLDebuggerForm.GetEditor: Pointer;
begin

end;

procedure TibSHPSQLDebuggerForm.SetEditor(Value: Pointer);
begin

end;
}
function TibSHPSQLDebuggerForm.GetFirstStatement: IibSHDebugStatement;
begin
  Result := FFirstStatement;
end;

function TibSHPSQLDebuggerForm.GetCurrentStatement: IibSHDebugStatement;
begin
  Result := FCurrentStatement;
end;

procedure TibSHPSQLDebuggerForm.SetCurrentStatement(
  Value: IibSHDebugStatement);
var
  vMarks: TSynEditMarks;
  vSynEditMark: TSynEditMark;
  I: Integer;
begin
  if FCurrentStatement <> Value then
  begin
    if Assigned(FCurrentStatement) then
    begin
      vSynEditMark := nil;
      Editor.Marks.GetMarksForLine(FCurrentStatement.BeginOfStatement.Y + 1, vMarks);
      for I := 1 to MAX_MARKS do
      begin
        if Assigned(vMarks[I]) then
          if (not vMarks[I].IsBookmark) then
            if vMarks[I].ImageIndex = img_current then
            begin
              vSynEditMark := vMarks[I];
              Break;
            end;
      end;
      if Assigned(vSynEditMark) then
        Editor.Marks.Remove(vSynEditMark);
      Editor.InvalidateLine(FCurrentStatement.BeginOfStatement.Y + 1);
    end;  

    FCurrentStatement := Value;

    if Assigned(FCurrentStatement) then
    begin
      vSynEditMark := TSynEditMark.Create(Editor);
      vSynEditMark.Line := FCurrentStatement.BeginOfStatement.Y + 1;
      vSynEditMark.Char := 1;
      vSynEditMark.ImageIndex := img_current;
      vSynEditMark.Visible := True;
      vSynEditMark.InternalImage := False;
      vSynEditMark.BookmarkNumber := -1;
      Editor.Marks.Add(vSynEditMark);
      Editor.InvalidateLine(FCurrentStatement.BeginOfStatement.Y + 1);
    end;
  end;
end;

function TibSHPSQLDebuggerForm.GetInputParameters(Index: Integer): Variant;
begin
  Result := FDebugerObjectParams.ValueByIndex[Index];
end;

procedure TibSHPSQLDebuggerForm.SetInputParameters(Index: Integer;
  Value: Variant);
begin
  FDebugerObjectParams.ValueByIndex[Index] := Value;
end;

function TibSHPSQLDebuggerForm.GetInputParametersCount: Integer;
begin
  Result := FDebugerObjectParams.Count;
end;

function TibSHPSQLDebuggerForm.GetOutputParameters(
  Index: Integer): Variant;
begin
  Result := FDebugerObjectReturns.ValueByIndex[Index];
end;

procedure TibSHPSQLDebuggerForm.SetOutputParameters(Index: Integer;
  Value: Variant);
begin
  FDebugerObjectReturns.ValueByIndex[Index] := Value;
end;

function TibSHPSQLDebuggerForm.GetOutputParametersCount: Integer;
begin
  Result := FDebugerObjectReturns.Count;
end;

function TibSHPSQLDebuggerForm.GetLocalVariables(Index: Integer): Variant;
begin
  Result := FDebugerObjectVariables.ValueByIndex[Index];
end;

procedure TibSHPSQLDebuggerForm.SetLocalVariables(Index: Integer;
  Value: Variant);
begin
  FDebugerObjectVariables.ValueByIndex[Index] := Value;
end;

function TibSHPSQLDebuggerForm.GetLocalVariablesCount: Integer;
begin
  Result := FDebugerObjectVariables.Count;
end;

function TibSHPSQLDebuggerForm.GetTokenScaner: TComponent;
begin
  Result := FTokenScaner;
end;

function TibSHPSQLDebuggerForm.GetServerException: Boolean;
begin
  Result := FServerException;
end;

procedure TibSHPSQLDebuggerForm.SetServerException(Value: Boolean);
begin
  FServerException := Value;
end;

procedure TibSHPSQLDebuggerForm.StatementFound(
  AStatement: IibSHDebugStatement);
var
  vSynEditMark: TSynEditMark;
begin
//  if (AStatement.GroupStatementType <> dgstSimple) then
//Собственно не его собачье дело фильтровать
  begin
    vSynEditMark := TSynEditMark.Create(Editor);
    vSynEditMark.Line := AStatement.BeginOfStatement.Y + 1;
    vSynEditMark.Char := 1;
    vSynEditMark.ImageIndex := img_statement;
    vSynEditMark.Visible := True;
    vSynEditMark.InternalImage := False;
    vSynEditMark.BookmarkNumber := -1;
    Editor.Marks.Add(vSynEditMark);
  end
{  else
   vSynEditMark:=nil}
end;

{
function TibSHPSQLDebuggerForm.AddChildDebugger(
  Value: IibSHPSQLDebuggerItem): Integer;
begin

end;
}

function TibSHPSQLDebuggerForm.Parse: Boolean;
var
//  vNext: Boolean;
  vFirstStatementComponent: TComponent;
begin

  Result := False;
  FParserPosition := Point(1, 0);
  //Пропускаем заголовок объекта
  while FTokenScaner.Next do
//    if (FTokenScaner.TokenType = ttIdentifier) and (UpperCase(FTokenScaner.Token) = 'BEGIN') then
    if (FTokenScaner.UpperToken = 'BEGIN') then
      Break;

  FTokenScaner.MoveBack;

  vFirstStatementComponent := TibSHPSQLDebuggerStatement.Create(Self);
  if Supports(vFirstStatementComponent, IibSHDebugStatement, FFirstStatement) then
  begin
    FFirstStatement.Processor := Self as IibSHPSQLProcessor;
    FFirstStatement.OperatorType:= dotFirstBegin;
    Result := FFirstStatement.Parse;
    FLastStatement:=FEndStatement;
    FEndStatement:=nil
  end;
{  if FFirstStatement.ChildStatementsCount > 0 then
    CurrentStatement := FFirstStatement.ChildStatements[0]
  else            }

    CurrentStatement := FFirstStatement;

  {
  if (FTokenScaner.TokenType = ttIdentifier) and (AnsiUpperCase(FTokenScaner.Token) = 'BEGIN') then
  begin
    Editor.BeginUpdate;
    Editor.BlockBegin := StringsToEditorCoord(FTokenScaner.TokenBegin);
    Editor.BlockEnd := StringsToEditorCoord(FTokenScaner.TokenEnd);
    Editor.EndUpdate;
  end;
  }
end;

procedure TibSHPSQLDebuggerForm.ClearStatementTree;
var
  I: Integer;
  vComponent: TComponent;
begin
  FFirstStatement := nil;
  CurrentStatement := nil;
  FLastStatement := nil;
// Опасная вещь
  for I := Pred(ComponentCount) downto 0 do
    if Supports(Components[I], IibSHDebugStatement) then
    begin
      vComponent := Components[I];
      RemoveComponent(vComponent);
      FreeAndNil(vComponent);
    end;
end;

{ End of IibSHPSQLDebuggerItem}

function TibSHPSQLDebuggerForm.RunCurrent(
  ACurrentStatement: IibSHDebugStatement): IibSHDebugStatement;
  function IIF(AStatement1, AStatement2: IibSHDebugStatement): IibSHDebugStatement;
  begin
    if Assigned(AStatement1) then
      Result := AStatement1
    else
      Result := AStatement2;
  end;
begin
  case ACurrentStatement.GroupStatementType of
    dgstEmpty:
      case ACurrentStatement.OperatorType OF
        dotEmpty: Result := GetNextStatement(ACurrentStatement);
        dotLeave:
          begin
            Result := ACurrentStatement;
            while not (Result.GroupStatementType in [dgstForSelectCycle, dgstWhileCycle]) do
            begin
              Result := Result.ParentStatement;
              Assert(Assigned(Result), 'Cannt''t find outer circle');
            end;
            Result := GetNextStatement(Result);
          end;
        dotExit:
          begin
            DoSuspend(False);
            Result := nil;
          end;
        dotSuspend:
          begin
            DoSuspend(True);
            Result := GetNextStatement(ACurrentStatement);
          end;
        dotExpression:
          begin
            ExecuteExpression(ACurrentStatement);
            if not (rsServerError in FRunState) then
            begin
             UpdateWatches;
             Result := GetNextStatement(ACurrentStatement);
            end
          end;
        dotSelect:
          begin
            ExecuteSelect(ACurrentStatement);
            if not (rsServerError in FRunState) then
            begin
             UpdateWatches;
             Result := GetNextStatement(ACurrentStatement);
            end
          end;
        dotFunction:
          begin
            ExecuteFunction(ACurrentStatement);
            if not (rsServerError in FRunState) then
            begin
             UpdateWatches;
             Result := GetNextStatement(ACurrentStatement);
            end
          end;

        dotExecuteProcedure:
          begin
            ExecuteProcedure(ACurrentStatement);
            if not (rsServerError in FRunState) then
            begin
             UpdateWatches;
             Result := GetNextStatement(ACurrentStatement);
            end
          end;
        dotExecuteStatement:
          begin
            ExecuteStatement(ACurrentStatement);
            if not (rsServerError in FRunState) then
            begin
             UpdateWatches;
             Result := GetNextStatement(ACurrentStatement);
            end 
          end;
        dotInsert:
          begin
            ExecuteSimple(ACurrentStatement);
            if not (rsServerError in FRunState) then
            begin
             UpdateWatches;
             Result := GetNextStatement(ACurrentStatement);
            end
          end;
        dotUpdate:
          begin
            ExecuteSimple(ACurrentStatement);
            if not (rsServerError in FRunState) then
            begin
             UpdateWatches;
             Result := GetNextStatement(ACurrentStatement);
            end

          end;
        dotDelete:
          begin
            ExecuteSimple(ACurrentStatement);
            if not (rsServerError in FRunState) then
            begin
             UpdateWatches;
             Result := GetNextStatement(ACurrentStatement);
            end

          end;
        dotException:
          begin
              ExecuteException(ACurrentStatement);
 //            ExecuteSimple(ACurrentStatement);

//            Result := FFirstStatement;
          end;
        dotOpenCursor,dotCloseCursor,dotFetchCursor:
          begin
            DoCursorOperation(ACurrentStatement);
            if not (rsServerError in FRunState) then
            begin
             UpdateWatches;
             Result := GetNextStatement(ACurrentStatement);
            end
          end;
      else
          Result := GetNextStatement(ACurrentStatement);
      end;
    dgstSimple: //BEGIN...END
      begin
        if Assigned(GetChildStatement(ACurrentStatement)) then
          Result := GetChildStatement(ACurrentStatement)
        else
          Result := GetNextStatement(ACurrentStatement);
      end;
    dgstCondition: //IF
      begin
        if ExecuteCondition(ACurrentStatement) then
        begin
          Result := GetChildStatement(ACurrentStatement);
          if not Assigned(Result) then
            Result := GetNextStatement(ACurrentStatement);
        end
        else
        begin
          if ACurrentStatement.ChildStatementsCount = 2 then
          begin
            Result := ACurrentStatement.ChildStatements[1];
            if Result.GroupStatementType = dgstSimple then
          end
          else
            Result := GetNextStatement(ACurrentStatement);
        end;
      end;
    dgstForSelectCycle:
      begin
        //!!!
        if ExecuteCircle(ACurrentStatement) then
        begin
          Result := GetChildStatement(ACurrentStatement);
          if not Assigned(Result) then
            Result := GetNextStatement(ACurrentStatement);
        end
        else
        if Length(ACurrentStatement.DataSet.ErrorText)=0 then
        begin
            Result := GetNextStatement(ACurrentStatement);
        end
        else
        begin
          Result:=ACurrentStatement;
          Include(FRunState,rsServerError);
          FLastErrorMsg:=     ACurrentStatement.DataSet.ErrorText;
        end;
      end;
    dgstWhileCycle:
      begin
      //!!!
        if ExecuteCircle(ACurrentStatement) then
        begin
          Result := GetChildStatement(ACurrentStatement);
          if not Assigned(Result) then
            Result := GetNextStatement(ACurrentStatement);
        end
        else
            Result := GetNextStatement(ACurrentStatement);
      end;
    dgstErrorHandler:
      begin
        if not (rsServerError in FRunState) then
          Result := GetNextStatement(ACurrentStatement)
        else
        if     ExecuteErrorHandler(ACurrentStatement) then
        begin
         Exclude(FRunState,rsServerError);
         Exclude(FRunState,rsInCatch);
         if Assigned(GetChildStatement(ACurrentStatement)) then
          Result := GetChildStatement(ACurrentStatement)
        end
        else
          Result := GetNextStatement(ACurrentStatement);
      end;
  end;
  OutputDebug;//!!!!!!!!!!!!!!!

end;

function TibSHPSQLDebuggerForm.GetNextStatement(
  ACurrentStatement: IibSHDebugStatement): IibSHDebugStatement;
begin
  Result := ACurrentStatement;
  while Assigned(Result) and (not Assigned(Result.NextStatement))  do
  begin
    Result := Result.ParentStatement;
//Buzz
    if Assigned(Result) and (Result.GroupStatementType in [dgstForSelectCycle, dgstWhileCycle]) then
     Exit 
  end;
  if Assigned(Result) then
  begin
    if Result.GroupStatementType in [dgstForSelectCycle, dgstWhileCycle] then
    begin
    //!!!
      Result := Result.NextStatement;    
    end
    else
      Result := Result.NextStatement;
    if Assigned(Result) and (Result.GroupStatementType = dgstSimple) then
    begin
      Result := GetChildStatement(Result);
      if not Assigned(Result) then
        Result := GetNextStatement(Result);
    end;
  end;
end;

function TibSHPSQLDebuggerForm.GetChildStatement(
  ACurrentStatement: IibSHDebugStatement): IibSHDebugStatement;
var
  vCurrentStatement: IibSHDebugStatement;
begin
  if ACurrentStatement.ChildStatementsCount > 0 then
    Result := ACurrentStatement.ChildStatements[0]
  else
    Result := nil;
  vCurrentStatement := Result;
  while Assigned(vCurrentStatement) and (Result.GroupStatementType = dgstSimple) do
  begin
    vCurrentStatement := GetChildStatement(vCurrentStatement);
    if not Assigned(vCurrentStatement) then
      vCurrentStatement := GetNextStatement(vCurrentStatement);
  end;
end;

procedure TibSHPSQLDebuggerForm.DoSuspend(IsDirectCommand:boolean);
var
  Node: PVirtualNode;
  NodeData: PResultTreeRec;
  I: Integer;
  Tree:TVirtualStringTree;
begin
  //!!!
  if IsDirectCommand then
   Include(FRunState,rsSuspendCommandExist)
  else
  if (rsSuspendCommandExist in FRunState) then
   Exit
  else
  if not (rsReturnValuesChanged in FRunState)  then
   Exit;

  Tree:=ResultTree;
  Tree.BeginUpdate;
  try
    Node := Tree.AddChild(nil);
    NodeData := Tree.GetNodeData(Node);
    NodeData.FieldValues := TStringList.Create;
    for I := 0 to Pred(FDebugerObjectReturns.Count) do
     if VarIsNull(FDebugerObjectReturns.ValueByIndex[I]) then
      NodeData.FieldValues.Add('NULL')
     else
      NodeData.FieldValues.Add(VarToStr(FDebugerObjectReturns.ValueByIndex[I]));
//    MsgPageControl.ActivePage := tsResult;
    Tree.Selected[Node] := True;
    Tree.FocusedNode := Node;
  finally
    Tree.EndUpdate;
  end;
end;

procedure TibSHPSQLDebuggerForm.ShowStatement(AStatement: string);
begin
  if Length(AStatement) > 0 then
  begin
//    MsgPageControl.ActivePage := tsTraceLog;
    Designer.TextToStrings(AStatement, TraceEditor.Lines, True);
  end;
end;

procedure TibSHPSQLDebuggerForm.ShowTraceMsg(AMsg: string);
begin
  if Length(AMsg) > 0 then
  begin
//    MsgPageControl.ActivePage := tsTraceLog;
    Designer.TextToStrings(AMsg, TraceEditor.Lines);
  end;
end;

procedure TibSHPSQLDebuggerForm.ShowErrorMsg(AMsg: string);
begin
  if Length(AMsg) > 0 then
  begin
//    MsgPageControl.ActivePage := tsTraceLog;
    Designer.TextToStrings(#13#10'/* Server error message: */'#13#10, TraceEditor.Lines);
    Designer.TextToStrings(AMsg, TraceEditor.Lines);
    ErrorCoord := GetErrorCoord(AMsg);
  end;
end;

procedure TibSHPSQLDebuggerForm.UpdateWatches;
var

  Node:PVirtualNode;
  Data: PWatchTreeRec;

begin
   Node:=WatchesTree.GetFirstChild(WatchesTree.RootNode);
   while Assigned(Node) do
   begin
    Data:=WatchesTree.GetNodeData(Node);
    if Data.Enabled then
     Data.Value:=DebugValue(Data.WatchName)
    else
     Data.Value:='Disabled';
    Node:=WatchesTree.GetNextSibling(Node);
   end;
   WatchesTree.Refresh

end;

function IsBoolean(const Expression:string):boolean;
var
  i:integer;
  InQuote:boolean;
begin
  Result:=True;
  InQuote:=False;
  for i:=1 to Length(Expression) do
    case Expression[i] of
     '''': InQuote:= not InQuote;
    else
     if not InQuote then
     case Expression[i] of
      '=','<','>','!','~': Exit;
      'A','a':{AND}
        if (i>1) and (Expression[i-1] in [' ',')',#9,#13,#10]) then
         if (i<Length(Expression)-2) and (Expression[i+1] in ['N','n']) and (Expression[i+2] in ['D','d']) then
                if (Expression[i+3] in [' ','(',#9,#13,#10]) then
                   Exit;
      'N','n':{NOT}
        if (i>1) and (Expression[i-1] in [' ',')',#9,#13,#10]) then
         if (i<Length(Expression)-2) and (Expression[i+1] in ['O','o']) and (Expression[i+2] in ['T','t']) then
                if (Expression[i+3] in [' ','(',#9,#13,#10]) then
                   Exit;

      'O','o': {OR}
        if (i>1) and (Expression[i-1] in [' ',')',#9,#13,#10]) then
         if (i<Length(Expression)-1) and (Expression[i+1] in ['R','r']) then
                if (Expression[i+2] in [' ','(',#9,#13,#10]) then
                   Exit;
     end
    end;
  Result:=False;
end;

function  TibSHPSQLDebuggerForm.ExecuteStringExpression(const Expression:string;IsCondition:boolean=False;MayBeBoolean :boolean =True):variant;
const
  FakeTemplate = 'SELECT'#13#10'%s'#13#10'FROM RDB$DATABASE';
  TemplateCondition='SELECT 1 FROM RDB$DATABASE'#13#10'WHERE %s';
var
  vExpression : string;
begin
    VarClear(Result);
    if Length(Expression)=0 then
     Exit;
    vExpression := ReplaceParametersInExpression(Expression, True);
    if Length(vExpression)=0 then
     Exit;
    if vExpression[Length(vExpression)]=';' then
     SetLength(vExpression,Length(vExpression)-1);
    if IsCondition then
     DRVQuery.SQL.Text := Format(TemplateCondition, [vExpression])
    else
    if MayBeBoolean and  IsBoolean(vExpression) then
    begin
     IsCondition:=True;
     DRVQuery.SQL.Text := Format(TemplateCondition, [vExpression]);
    end
    else
     DRVQuery.SQL.Text := Format(FakeTemplate, [vExpression]);

    try
      ShowStatement(DRVQuery.SQL.Text);
      if not DRVQuery.Transaction.InTransaction then
        DRVQuery.Transaction.StartTransaction;
      if DRVQuery.Prepare then
      begin
        ShowTraceMsg(#13#10'/* Statement plan: */'#13#10);
        ShowTraceMsg(DRVQuery.Plan);
        if DRVQuery.Execute then
        begin
          Result:=DRVQuery.GetFieldValue(0);
          if IsCondition then
           Result:= not  VarIsNull(Result) ;

          DRVQuery.Close;
        end;
      end;
      if Length(DRVQuery.ErrorText) > 0 then
      begin
      if Assigned(CurrentStatement) then
        CurrentStatement.LastErrorCode:=DRVQuery.LastErrorCode;
        Include(FRunState,rsServerError);

        ShowErrorMsg(DRVQuery.ErrorText);
        FLastErrorMsg:=DRVQuery.ErrorText;
      end
    except
      if Length(DRVQuery.ErrorText) > 0 then
      begin
       if Assigned(CurrentStatement) then
        CurrentStatement.LastErrorCode:=DRVQuery.LastErrorCode;
        Include(FRunState,rsServerError);

        ShowErrorMsg(DRVQuery.ErrorText);
        FLastErrorMsg:=DRVQuery.ErrorText;
      end
    end;
end;


procedure TibSHPSQLDebuggerForm.ExecuteExpression(ACurrentStatement: IibSHDebugStatement);
const
  FakeTemlate = 'SELECT'#13#10'CAST(%s AS %s)'#13#10'FROM RDB$DATABASE';
var
  vPos: Integer;
  vExpression: string;
  vVariableType: TibPSQLVariableType;
  vIndex: Integer;
  vDataType: string;
begin
  if not Assigned(ACurrentStatement) then
   Exit;
  //vDataType := DataType[AVaribleName];
  DispositionVariable(ACurrentStatement.VariableName, vVariableType, vIndex);
  if (vVariableType <> vtNone) and (vIndex > -1) then
  begin
    case vVariableType of
      vtInputParameter: vDataType := FDebugerObjectParams.DataTypeByIndex[vIndex];
      vtReturnParameter: vDataType := FDebugerObjectReturns.DataTypeByIndex[vIndex];
      vtLocalVariable: vDataType := FDebugerObjectVariables.DataTypeByIndex[vIndex];
      vtTableField: vDataType := FDebugerObjectFields.DataTypeByIndex[vIndex];
    end;
    vExpression := ACurrentStatement.OperatorText;
    vPos := Pos('=', vExpression);
    vExpression := Trim(System.Copy(vExpression, vPos + 1, Length(vExpression) - vPos));
    if (Length(vExpression) > 0) and (vExpression[Length(vExpression)] = ';') then
      vExpression := Trim(System.Copy(vExpression, 1, Length(vExpression) - 1));
    vExpression := ReplaceParametersInExpression(vExpression, True);
    DRVQuery.SQL.Text := Format(FakeTemlate, [vExpression, vDataType]);
    try
      ShowStatement(DRVQuery.SQL.Text);
      if not DRVQuery.Transaction.InTransaction then
        DRVQuery.Transaction.StartTransaction;
      if DRVQuery.Prepare then
      begin
        ShowTraceMsg(#13#10'/* Statement plan: */'#13#10);
        ShowTraceMsg(DRVQuery.Plan);
        if DRVQuery.Execute then
        begin
          case vVariableType of
            vtInputParameter: FDebugerObjectParams.ValueByIndex[vIndex] := DRVQuery.GetFieldValue(0);
            vtReturnParameter:
            begin
             FDebugerObjectReturns.ValueByIndex[vIndex] := DRVQuery.GetFieldValue(0);
             Include(FRunState,rsReturnValuesChanged);
            end;
            vtLocalVariable: FDebugerObjectVariables.ValueByIndex[vIndex] := DRVQuery.GetFieldValue(0);
            vtTableField: FDebugerObjectFields.ValueByIndex[vIndex] := DRVQuery.GetFieldValue(0);
          end;
          DRVQuery.Close;
        end;
      end;
      if Length(DRVQuery.ErrorText) > 0 then
      begin
        ShowErrorMsg(DRVQuery.ErrorText);
        CurrentStatement.LastErrorCode:=DRVQuery.LastErrorCode;
        Include(FRunState,rsServerError);
        FLastErrorMsg:=DRVQuery.ErrorText;
      end
    except
      if Length(DRVQuery.ErrorText) > 0 then
      begin
        CurrentStatement.LastErrorCode:=DRVQuery.LastErrorCode;      
        ShowErrorMsg(DRVQuery.ErrorText);
        Include(FRunState,rsServerError);
        FLastErrorMsg:=DRVQuery.ErrorText;                
      end
    end;
  end
  else
    ExecutionError(Format('Unknown variable: %s', [ACurrentStatement.VariableName]));
end;

procedure TibSHPSQLDebuggerForm.ExecuteSelect(ACurrentStatement: IibSHDebugStatement);
begin
  ExecuteCommon(ACurrentStatement, EmptyStr, True);
  if GetLocalVariables(FDebugerObjectVariables.IndexOf('ROW_COUNT'))>1 then
   MessageDlg('Multiply rows in singleton select',mtWarning,[mbOK],-1)
end;

procedure TibSHPSQLDebuggerForm.ExecuteFunction(ACurrentStatement: IibSHDebugStatement);
begin
  ExecuteCommon(ACurrentStatement, EmptyStr, True);
end;

procedure TibSHPSQLDebuggerForm.ExecuteProcedure(ACurrentStatement: IibSHDebugStatement);
var
   vnOperator:string;
begin
//!!!
  vnOperator:=NormalizeParametersInExpression(ACurrentStatement.OperatorText,True);
// Из-за того что параметры в сп можно передавать без двоеточия
  ExecuteCommon(ACurrentStatement, vnOperator, False);
end;

type
   TStateSt=(sExpression,sInQuotation,sConcat);

function  TibSHPSQLDebuggerForm.PrepareDynStatementString(const DynStatement:string):string;
var
  vnOperator:string;
  i,L:integer;
  State:TStateSt;
  CurString:string;
  BrInExpression:integer;
  quoteInExpression:integer;
procedure AddCurString;
begin
 Result:=Result+CurString;
 CurString:=''
end;

begin
  vnOperator:=  ReplaceParametersInExpression(DynStatement,True,False);
//  SetLength(Result,Length(vnOperator));
  L:=1;          i:=1;
  State:=sConcat;
  CurString:='';
  BrInExpression:=0;
  quoteInExpression:=0;

  while i<= Length(vnOperator) do
  begin
   case State of
    sConcat:
    case vnOperator[i] of
     ' ',#9,#13,#10,'|': Inc(i);
     '''': begin
            State:=sInQuotation;
            Inc(i)
           end;

    else
      State:=sExpression;
      CurString:=CurString+vnOperator[i];
      Inc(i)
    end;
    sInQuotation:
    case vnOperator[i] of
     '''': if  (Length(vnOperator)=i) or (vnOperator[i+1]<>'''') then
           begin
            State:=sConcat;
            AddCurString;
            Inc(i)
           end
           else
           begin
              CurString:=CurString+vnOperator[i];
              Inc(i,2)
           end;
           // Отработать несколько кавычек

    else
     CurString:=CurString+vnOperator[i];
     if i=Length(vnOperator) then
      AddCurString;
     Inc(i)
    end;
    sExpression:
     case vnOperator[i] of
      '|': if (Length(vnOperator)>i) and (vnOperator[i+1]='|')
            and (BrInExpression=0) then
           begin
             State:=sConcat;
             Inc(i,2);
             if Length(CurString)>0 then
             begin
              CurString:=ExecuteStringExpression(CurString,False,False); // Здесь вычислить экспрессион
              AddCurString
             end;
           end
           else
           begin
              CurString:=CurString+vnOperator[i];
              Inc(i)
           end;
      '''':
      begin
        quoteInExpression:=1-quoteInExpression;
        CurString:=CurString+vnOperator[i];
        if i=Length(vnOperator) then
        begin
         CurString:=ExecuteStringExpression(CurString,False,False); // Здесь вычислить экспрессион
         AddCurString
        end;
        Inc(i);
      end;
      '(':
      begin
        CurString:=CurString+vnOperator[i];
        if quoteInExpression=0 then
         Inc(BrInExpression);
        Inc(i)
      end;
      ')':
      begin
        CurString:=CurString+vnOperator[i];
        if quoteInExpression=0 then
         Dec(BrInExpression);
        if i=Length(vnOperator) then
        begin
         CurString:=ExecuteStringExpression(CurString,False,False); // Здесь вычислить экспрессион
         AddCurString
        end;
        Inc(i)
      end;
     else
       CurString:=CurString+vnOperator[i];
       if i=Length(vnOperator) then
       begin
        CurString:=ExecuteStringExpression(CurString,False,False); // Здесь вычислить экспрессион
        AddCurString
       end;
       Inc(i);
     end;
   end;
  end
end;


{
function  TibSHPSQLDebuggerForm.PrepareDynStatementString(const DynStatement:string):string;
var
  vnOperator:string;
  i,L:integer;
  InQuote:boolean;
begin
  vnOperator:=  ReplaceParametersInExpression(DynStatement,True,False);
  SetLength(Result,Length(vnOperator));
  L:=1;
  InQuote:=False;
  for i:=1 to Length(vnOperator) do
  begin
    case vnOperator[i] of
     '''': begin
            if InQuote then
            begin
             if i=Length(vnOperator) then
              InQuote:=not InQuote
             else
               if vnOperator[i+1]='''' then
               begin
                 Result[L]:=vnOperator[i];
                 Inc(L)
               end
               else
               if i=1 then
                InQuote:=not InQuote
               else
               if vnOperator[i-1]<>'''' then
                InQuote:=not InQuote               
            end
            else
             InQuote:=not InQuote
           end;
    else
       if InQuote then
       begin
         Result[L]:=vnOperator[i];
         Inc(L)
       end;
    end;
  end;
  SetLength(Result,L-1);
end;
}
procedure TibSHPSQLDebuggerForm.ExecuteStatement(ACurrentStatement: IibSHDebugStatement);
var
 vnOperator:string;
begin
  vnOperator:=PrepareDynStatementString(ACurrentStatement.OperatorText);
  ExecuteCommon(ACurrentStatement, vnOperator, False);
  SetLocalVariables(FDebugerObjectVariables.IndexOf('ROW_COUNT'),0); //ROW_COUNT
end;

procedure TibSHPSQLDebuggerForm.DoCursorOperation(ACurrentStatement: IibSHDebugStatement);
var
  vDRVParams: IibSHDRVParams;
  vDRVQuery : IibSHDRVQuery;
  vComponentClass: TSHComponentClass;
  QryObject : TObject;
  vBaseStatement: string;
  I: Integer;
  IDM:IBTDynamicMethod;
begin
  QryObject:=nil;
  case ACurrentStatement.OperatorType of
   dotOpenCursor:
   begin
    vComponentClass := Designer.GetComponent(BTCLDatabase.BTCLServer.DRVNormalize(IibSHDRVQuery));
    if Assigned(vComponentClass) then
    begin
     QryObject := vComponentClass.Create(Self);
     FDebugerObjectVariables.VarObject[ACurrentStatement.CursorName]:=QryObject;
     Supports(QryObject,IibSHDRVQuery,vDRVQuery);
     if Assigned(vDRVQuery) then
     begin
      vDRVQuery.Transaction :=DRVTransaction;
      vDRVQuery.Database := BTCLDatabase.DRVQuery.Database;
      vDRVQuery.SQL.Text := Variable[ACurrentStatement.CursorName];

      if Supports(vDRVQuery, IibSHDRVParams, vDRVParams) then
       for I := 0 to Pred(vDRVParams.ParamCount) do
        vDRVParams.ParamByIndex[I] := Variable[vDRVParams.ParamName(I)];
      try
        ShowStatement(vDRVQuery.SQL.Text);
        if not vDRVQuery.Transaction.InTransaction then
         vDRVQuery.Transaction.StartTransaction;

        if  Supports(vDRVQuery,IBTDynamicMethod,IDM)
        then
        begin
         IDM.DynMethodExec('SETCURSORNAME',[ACurrentStatement.CursorName]);
         IDM.DynMethodExec('FETCH_FIRST_RECORD',[False]);
        end;
        if vDRVQuery.Prepare then
        begin
          ShowTraceMsg(#13#10'/* Statement plan: */'#13#10);
          ShowTraceMsg(vDRVQuery.Plan);
          if vDRVQuery.Execute then
          begin
           if Supports(vDRVQuery,IBTDynamicMethod,IDM) and IDM.DynMethodExist('ROWS_AFFECTED') then
             SetLocalVariables(FDebugerObjectVariables.IndexOf('ROW_COUNT'),IDM.DynMethodExec('ROWS_AFFECTED',[]));
          end;
        end
        else
      except
        if Assigned(vDRVQuery) then
          if Length(vDRVQuery.ErrorText) > 0 then
          begin
           ShowErrorMsg(vDRVQuery.ErrorText);
           Include(FRunState,rsServerError);
           CurrentStatement.LastErrorCode:=DRVQuery.LastErrorCode;
           FLastErrorMsg:=vDRVQuery.ErrorText;
          end
      end
     end;
    end
   end;
   dotCloseCursor:
   begin
     QryObject:=FDebugerObjectVariables.VarObject[ACurrentStatement.CursorName];
     Supports(QryObject,IibSHDRVQuery,vDRVQuery);
     if Assigned(vDRVQuery) then
      vDRVQuery.Close;
     SetLocalVariables(FDebugerObjectVariables.IndexOf('ROW_COUNT'),0);
   end;
   dotFetchCursor:
   begin
     QryObject:=FDebugerObjectVariables.VarObject[ACurrentStatement.CursorName];
     Supports(QryObject,IibSHDRVQuery,vDRVQuery);
     if Assigned(vDRVQuery) then
     begin
      vDRVQuery.Next;
      if vDRVQuery.Eof then
        SetLocalVariables(FDebugerObjectVariables.IndexOf('ROW_COUNT'),0)
      else
      begin
        for I := 0 to Pred(vDRVQuery.GetFieldCount) do
        begin
            if I < ACurrentStatement.VariableNames.Count then
             Variable[ACurrentStatement.VariableNames[I]] := vDRVQuery.GetDebugFieldValue(I);
        end;
        SetLocalVariables(FDebugerObjectVariables.IndexOf('ROW_COUNT'),1);
      end
     end
   end;
  end;

  if not Assigned(vDRVQuery) then
    raise Exception.Create('Can''t found query for cursor "'+ACurrentStatement.CursorName+'"');



(*

  try
    ShowStatement(DRVQuery.SQL.Text);
    if not DRVQuery.Transaction.InTransaction then
      DRVQuery.Transaction.StartTransaction;
    if DRVQuery.Prepare then
    begin
      ShowTraceMsg(#13#10'/* Statement plan: */'#13#10);
      ShowTraceMsg(DRVQuery.Plan);
      if DRVQuery.Execute then
      begin

        if Supports(DRVQuery,IBTDynamicMethod,IDM) and IDM.DynMethodExist('ROWS_AFFECTED') then
         SetLocalVariables(FDebugerObjectVariables.IndexOf('ROW_COUNT'),IDM.DynMethodExec('ROWS_AFFECTED',[]));

//         SetLocalVariables('ROW_COUNT',IDM.DynMethodExec('ROWS_AFFECTED',[]));

        if ACurrentStatement.VariableNames.Count > 0 then
//SP ??
        if not DRVQuery.Eof  or (CurrentStatement.OperatorType in [dotExecuteProcedure,dotUpdate,dotInsert,dotDelete])
        then
          for I := 0 to Pred(DRVQuery.GetFieldCount) do
          begin
            if I < ACurrentStatement.VariableNames.Count then
             Variable[ACurrentStatement.VariableNames[I]] := DRVQuery.GetDebugFieldValue(I);
//              Variable[ACurrentStatement.VariableNames[I]] := DRVQuery.GetFieldValue(I);
          end;
        if DRVQuery.GetFieldCount>0 then
          Result := DRVQuery.GetFieldValue(0);
        DRVQuery.Close;
      end;
    end;
    if Length(DRVQuery.ErrorText) > 0 then
    begin
      ShowErrorMsg(DRVQuery.ErrorText);
      Include(FRunState,rsServerError);
      FLastErrorMsg:=DRVQuery.ErrorText;
    end
  except
    if Length(DRVQuery.ErrorText) > 0 then
    begin
      ShowErrorMsg(DRVQuery.ErrorText);
      Include(FRunState,rsServerError);
      FLastErrorMsg:=DRVQuery.ErrorText;            
    end
  end;
  *)
end;


function TibSHPSQLDebuggerForm.ExecuteCommon(
  ACurrentStatement: IibSHDebugStatement; AOverrideStatement: string;
  UseReplacement: Boolean): Variant;
var
  vDRVParams: IibSHDRVParams;
  vBaseStatement, vStatement: string;
  I: Integer;
  IDM:IBTDynamicMethod;
begin
  VarClear(Result);
  if Length(AOverrideStatement) > 0 then
    vBaseStatement := AOverrideStatement
  else
    vBaseStatement := ACurrentStatement.OperatorText;

  if UseReplacement then
    vStatement := ReplaceParametersInExpression(vBaseStatement,ACurrentStatement.OperatorType=dotFunction)
  else
   vStatement := vBaseStatement;

  if Assigned(DBTrigger) then
   vStatement :=NormalizeParametersInExpression(vStatement,True);


  DRVQuery.SQL.Text := vStatement;
  if Supports(DRVQuery, IibSHDRVParams, vDRVParams) then
    for I := 0 to Pred(vDRVParams.ParamCount) do
      vDRVParams.ParamByIndex[I] := Variable[vDRVParams.ParamName(I)];

  try
    ShowStatement(DRVQuery.SQL.Text);
    if not DRVQuery.Transaction.InTransaction then
      DRVQuery.Transaction.StartTransaction;
    if DRVQuery.Prepare then
    begin
      ShowTraceMsg(#13#10'/* Statement plan: */'#13#10);
      ShowTraceMsg(DRVQuery.Plan);
      if DRVQuery.Execute then
      begin

        if Supports(DRVQuery,IBTDynamicMethod,IDM) and IDM.DynMethodExist('ROWS_AFFECTED') then
         SetLocalVariables(FDebugerObjectVariables.IndexOf('ROW_COUNT'),IDM.DynMethodExec('ROWS_AFFECTED',[]));

//         SetLocalVariables('ROW_COUNT',IDM.DynMethodExec('ROWS_AFFECTED',[]));

        if ACurrentStatement.VariableNames.Count > 0 then
//SP ??
        if not DRVQuery.Eof  or (CurrentStatement.OperatorType in [dotExecuteProcedure,dotUpdate,dotInsert,dotDelete])
        then
          for I := 0 to Pred(DRVQuery.GetFieldCount) do
          begin
            if I < ACurrentStatement.VariableNames.Count then
             Variable[ACurrentStatement.VariableNames[I]] := DRVQuery.GetDebugFieldValue(I);
//              Variable[ACurrentStatement.VariableNames[I]] := DRVQuery.GetFieldValue(I);
          end;
        if DRVQuery.GetFieldCount>0 then
          Result := DRVQuery.GetFieldValue(0);
        DRVQuery.Close;
      end;
    end;
    if Length(DRVQuery.ErrorText) > 0 then
    begin
      ACurrentStatement.LastErrorCode:=DRVQuery.LastErrorCode;
      ShowErrorMsg(DRVQuery.ErrorText);
      Include(FRunState,rsServerError);
      FLastErrorMsg:=DRVQuery.ErrorText;
    end
  except
    if Length(DRVQuery.ErrorText) > 0 then
    begin
      ACurrentStatement.LastErrorCode:=DRVQuery.LastErrorCode;    
      ShowErrorMsg(DRVQuery.ErrorText);
      Include(FRunState,rsServerError);
      FLastErrorMsg:=DRVQuery.ErrorText;            
    end
  end;
end;

procedure TibSHPSQLDebuggerForm.ExecuteSimple(ACurrentStatement: IibSHDebugStatement);
begin
  ExecuteCommon(ACurrentStatement, EmptyStr, False);
end;

const
  FakeTemlate = 'SELECT 1 FROM RDB$DATABASE'#13#10'WHERE %s';

function TibSHPSQLDebuggerForm.ExecuteCondition(
  ACurrentStatement: IibSHDebugStatement): Boolean;
var
  vStatement: string;
begin
  vStatement := ReplaceParametersInExpression(ACurrentStatement.OperatorText,True);
  vStatement := Format(FakeTemlate, [vStatement]);
//  vStatement := Format(FakeTemlate, [ACurrentStatement.OperatorText]);
  Result := ExecuteCommon(ACurrentStatement, vStatement, False) = 1;
end;

function TibSHPSQLDebuggerForm.ExecuteCircle(
  ACurrentStatement: IibSHDebugStatement): Boolean;
var
  I: Integer;
  vStatement: string;
  vDRVParams: IibSHDRVParams;
  IDM:IBTDynamicMethod;
begin
  if (ACurrentStatement.GroupStatementType in [dgstForSelectCycle, dgstWhileCycle]) and
    Assigned(ACurrentStatement.DataSet) then
  begin
    if ACurrentStatement.DataSet.Active then
    begin
      ACurrentStatement.DataSet.Dataset.Next;
      Result := not ACurrentStatement.DataSet.Dataset.Eof;
      if not Result then
        ACurrentStatement.DataSet.Close;
    end
    else
    begin
      if  ACurrentStatement.IsDynamicStatement then
       vStatement:=PrepareDynStatementString(ACurrentStatement.OperatorText)
      else
       vStatement :=ACurrentStatement.OperatorText;
      vStatement := ReplaceParametersInExpression(vStatement, ACurrentStatement.GroupStatementType=dgstWhileCycle);
      if ACurrentStatement.GroupStatementType=dgstWhileCycle then
       vStatement := Format(FakeTemlate, [vStatement]);
      ACurrentStatement.DataSet.SelectSQL.Text := vStatement;
      if Supports(ACurrentStatement.DataSet, IibSHDRVParams, vDRVParams) then
        for I := 0 to Pred(vDRVParams.ParamCount) do
          vDRVParams.ParamByIndex[I] := Variable[vDRVParams.ParamName(I)];
      try
        ShowStatement(ACurrentStatement.DataSet.SelectSQL.Text);
        if not ACurrentStatement.DataSet.ReadTransaction.InTransaction then
          ACurrentStatement.DataSet.ReadTransaction.StartTransaction;

        if (ACurrentStatement.CursorName<>'') and
          Supports(ACurrentStatement.DataSet,IBTDynamicMethod,IDM)
        then
         IDM.DynMethodExec('SETCURSORNAME',[ACurrentStatement.CursorName]);

        if ACurrentStatement.DataSet.Prepare then
        begin
          ShowTraceMsg(#13#10'/* Statement plan: */'#13#10);
          ShowTraceMsg(ACurrentStatement.DataSet.Plan);
          ACurrentStatement.DataSet.Open;
        end;
        if Length(ACurrentStatement.DataSet.ErrorText) > 0 then
        begin
          Include(FRunState,rsServerError);
          ShowErrorMsg(ACurrentStatement.DataSet.ErrorText);
          FLastErrorMsg:=ACurrentStatement.DataSet.ErrorText;
          ACurrentStatement.LastErrorCode:=ACurrentStatement.DataSet.LastErrorCode;
          Result := False;
        end
        else
          Result := not ACurrentStatement.DataSet.IsEmpty;
        if ACurrentStatement.GroupStatementType=dgstWhileCycle then
        begin
            ACurrentStatement.DataSet.Close
        end
      except
        Result := False;
        if Length(ACurrentStatement.DataSet.ErrorText) > 0 then
        begin
          ShowErrorMsg(ACurrentStatement.DataSet.ErrorText);
          Include(FRunState,rsServerError);
          FLastErrorMsg:=ACurrentStatement.DataSet.ErrorText;
          ACurrentStatement.LastErrorCode:=ACurrentStatement.DataSet.LastErrorCode;          
        end
      end;
    end;
    if Result then
    begin
      if ACurrentStatement.VariableNames.Count > 0 then
        for I := 0 to Pred(ACurrentStatement.DataSet.DataSet.FieldCount) do
        begin
{          if I < ACurrentStatement.VariableNames.Count then
            Variable[ACurrentStatement.VariableNames[I]] := ACurrentStatement.DataSet.DataSet.Fields[I].Value;}
           if I < ACurrentStatement.VariableNames.Count then
            Variable[ACurrentStatement.VariableNames[I]] := ACurrentStatement.DataSet.GetDebugFieldValue(I);
        end;
    end;
  end;
end;

procedure TibSHPSQLDebuggerForm.ExecutionError(AMsg: string);
begin
  raise Exception.Create(Format('Execution Error: %s', [AMsg]));
end;

function TibSHPSQLDebuggerForm.NormalizeName(const AName: string): string;
begin
  if (Assigned(FCodeNormalizer) and Supports(FCodeNormalizer, IibSHCodeNormalizer)) or
     Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, FCodeNormalizer) then
    Result := FCodeNormalizer.SourceDDLToMetadataName(AName)
  else
    Result := AName;
end;

function TibSHPSQLDebuggerForm.NormalizeParametersInExpression(AStatement: string; AReplaceAll: Boolean = False): string;
//const
//  SymbolsChar = [#0,#10,#13,{#39,}'=','>','<','-','|','+','/','&', '^', '%', '*', '!','{', '}', ',','.',';', '?', '(', ')', '[', ']', '~', '#'];
var
  vTokenScaner: TibSHPSQLDebuggerTokenScaner;
  vInSelectClause: Integer;
  vToken: string;
  S: string;
  vPreviosTokenEnd: TPoint;

  vEditorRegistrator: IibSHEditorRegistrator;
  vKeywordsManager: IpSHKeywordsManager;
  vObjectNamesManager: IpSHObjectNamesManager;
  vTokenKind: TtkTokenKind;
  procedure CopySpaces;
  var
    S: string;
    I: Integer;
  begin
     //Т.к. основной разбор идет по токеном и пробелы, переводы строк при этом
     //пропускаются, то эта процедура необходима, чтобы показать пользователю
     //пробелы и пропущенные переводы строк 
     S := EmptyStr;
     if vPreviosTokenEnd.Y <> vTokenScaner.TokenBegin.Y then
     begin
       for I := vPreviosTokenEnd.Y to vTokenScaner.TokenBegin.Y do
       begin
         if I = vPreviosTokenEnd.Y then
           S := S + System.Copy(vTokenScaner.DDLText[I], vPreviosTokenEnd.X + 1, Length(vTokenScaner.DDLText[I]) - vPreviosTokenEnd.X) + #13#10
         else
         if I = vTokenScaner.TokenBegin.Y then
           S := S + System.Copy(vTokenScaner.DDLText[I], 1, vTokenScaner.TokenBegin.X - 1)
         else
           S := S + vTokenScaner.DDLText[I] + #13#10
       end;
     end
     else
       S := System.Copy(vTokenScaner.DDLText[vTokenScaner.TokenBegin.Y], vPreviosTokenEnd.X + 1, vTokenScaner.TokenBegin.X - vPreviosTokenEnd.X - 1);
     Result := Result + S;
  end;

  procedure ReplaceVariableByNorma;
  var
    vVariableType: TibPSQLVariableType;
    vIndex: Integer;
    vValue: Variant;
    vDataType: string;
  begin
    DispositionVariable(vToken, vVariableType, vIndex);
    if vVariableType = vtNone then
      Result := Result + vToken
    else
    begin
      if vVariableType in  [vtInputParameter,vtReturnParameter,vtLocalVariable] then
       Result := Result + ':'+vToken
      else
       Result := Result + vToken      
    end;
  end;

begin
  vInSelectClause := 0;
  if Supports(Designer.GetDemon(IibSHEditorRegistrator), IibSHEditorRegistrator, vEditorRegistrator) and
    Supports(vEditorRegistrator.GetKeywordsManager(BTCLDatabase.BTCLServer), IpSHKeywordsManager, vKeywordsManager) and
    Supports(vEditorRegistrator.GetObjectNameManager(BTCLDatabase.BTCLServer, BTCLDatabase), IpSHObjectNamesManager, vObjectNamesManager) then
  begin
    Result := EmptyStr;
    vPreviosTokenEnd := Point(0, 0);
    vTokenScaner := TibSHPSQLDebuggerTokenScaner.Create(nil);
    try
      vTokenScaner.DDLText.Text := AStatement;
      while vTokenScaner.Next and (Length(vTokenScaner.Token) > 0) do
      begin
        if (vTokenScaner.TokenType in [ttUnknown, ttString, ttSymbol, ttNumeric]) and (vTokenScaner.Token[1] <> ':') then
        begin
          CopySpaces;
          Result := Result + vTokenScaner.Token;
          vPreviosTokenEnd := vTokenScaner.TokenEnd;
        end
        else
        begin
          //ttIdentifier, ttD3Identifier
//          vToken := UpperCase(vTokenScaner.Token);
          vToken := vTokenScaner.UpperToken;
          if AReplaceAll or (vInSelectClause > 0)  then
          begin
            if vKeywordsManager.IsKeyword(vToken) then
            begin
              if vToken = 'SELECT' then
                Inc(vInSelectClause)
              else
              if vToken = 'EXTRACT' then
                Inc(vInSelectClause)
              else
              if vToken = 'FROM' then
                Dec(vInSelectClause);
              CopySpaces;
              Result := Result + vTokenScaner.Token;
              vPreviosTokenEnd := vTokenScaner.TokenEnd;
            end
            else
            begin
              CopySpaces;
              vPreviosTokenEnd := vTokenScaner.TokenEnd;
              if AReplaceAll and (vInSelectClause <= 0) then
              begin
                vTokenKind := tkIdentifier;
                vObjectNamesManager.LinkSearchNotify(Self, PChar(vToken), 0, Length(vToken), vTokenKind);
                if vTokenKind = tkTableName then
                begin
                  S := vTokenScaner.Token;
                  vTokenScaner.Next;
                  if vTokenScaner.Token <> '(' then
                    ReplaceVariableByNorma
                  else
                    Result := Result + S;
//                  vTokenScaner.MoveBack;
//Buzz ^^^  циклит при execute procedure newprocedure
// Т.е. неясно на хера вообще надоть
                end
                else
                  ReplaceVariableByNorma;
              end
              else
                Result := Result + vToken;
            end;
          end
          else    //AReplaceAll or vInSelectClause
          begin
            if vKeywordsManager.IsKeyword(vToken) then
            begin
              if vToken = 'SELECT' then
                Inc(vInSelectClause)
              else
              if vToken = 'FROM' then
                Dec(vInSelectClause);
            end;
            CopySpaces;
            Result := Result + vTokenScaner.Token;
            vPreviosTokenEnd := vTokenScaner.TokenEnd;
          end;
        end;
      end; //while
    finally
      vTokenScaner.Free;
    end;
  end;
end;


function TibSHPSQLDebuggerForm.ReplaceParametersInExpression(AStatement: string; AReplaceAll: Boolean = False;
  DoCast:boolean=True
): string;
//const
//  SymbolsChar = [#0,#10,#13,{#39,}'=','>','<','-','|','+','/','&', '^', '%', '*', '!','{', '}', ',','.',';', '?', '(', ')', '[', ']', '~', '#'];
var
  vTokenScaner: TibSHPSQLDebuggerTokenScaner;
  vInSelectClause: Integer;
  vToken: string;
  S: string;
  vPreviosTokenEnd: TPoint;

  vEditorRegistrator: IibSHEditorRegistrator;
  vKeywordsManager: IpSHKeywordsManager;
  vObjectNamesManager: IpSHObjectNamesManager;
  vTokenKind: TtkTokenKind;
  procedure CopySpaces;
  var
    S: string;
    I: Integer;
  begin
     //Т.к. основной разбор идет по токеном и пробелы, переводы строк при этом
     //пропускаются, то эта процедура необходима, чтобы показать пользователю
     //пробелы и пропущенные переводы строк
     S := EmptyStr;
     if vPreviosTokenEnd.Y <> vTokenScaner.TokenBegin.Y then
     begin
       for I := vPreviosTokenEnd.Y to vTokenScaner.TokenBegin.Y do
       begin
         if I = vPreviosTokenEnd.Y then
           S := S + System.Copy(vTokenScaner.DDLText[I], vPreviosTokenEnd.X + 1, Length(vTokenScaner.DDLText[I]) - vPreviosTokenEnd.X) + #13#10
         else
         if I = vTokenScaner.TokenBegin.Y then
           S := S + System.Copy(vTokenScaner.DDLText[I], 1, vTokenScaner.TokenBegin.X - 1)
         else
           S := S + vTokenScaner.DDLText[I] + #13#10
       end;
     end
     else
       S := System.Copy(vTokenScaner.DDLText[vTokenScaner.TokenBegin.Y], vPreviosTokenEnd.X + 1, vTokenScaner.TokenBegin.X - vPreviosTokenEnd.X - 1);
     Result := Result + S;
  end;
  procedure ReplaceVariableByValue;
  var
    vVariableType: TibPSQLVariableType;
    vIndex: Integer;
    vValue: Variant;
    vDataType: string;
  begin
    DispositionVariable(vToken, vVariableType, vIndex);
    if vVariableType = vtNone then
      Result := Result + vToken
    else
    begin
      case vVariableType of
        vtInputParameter:
          begin
            vValue := FDebugerObjectParams.ValueByIndex[vIndex];
            vDataType := FDebugerObjectParams.DataTypeByIndex[vIndex];
          end;
        vtReturnParameter:
          begin
            vValue := FDebugerObjectReturns.ValueByIndex[vIndex];
            vDataType := FDebugerObjectReturns.DataTypeByIndex[vIndex];
          end;
        vtLocalVariable:
          begin
            vValue := FDebugerObjectVariables.ValueByIndex[vIndex];
            vDataType := FDebugerObjectVariables.DataTypeByIndex[vIndex];
          end;
        vtTableField:
          begin
            vValue := FDebugerObjectFields.ValueByIndex[vIndex];
            vDataType := FDebugerObjectFields.DataTypeByIndex[vIndex];
          end;
      end;
      if DoCast then
      begin
       Result := Result +

       ValueToStringCast(vValue, vDataType)
      end
      else
      if VarIsNull(vValue) then
       Result := Result +'NULL'
      else
      begin
       Result := Result +''''+StringReplace(VarToStr(vValue),'''','''''',[rfReplaceAll])+'''';
      end;
    end;
//    Result:=StringReplace(Result,'''','''''',[rfReplaceAll])
  end;
begin
  vInSelectClause := 0;
  if Supports(Designer.GetDemon(IibSHEditorRegistrator), IibSHEditorRegistrator, vEditorRegistrator) and
    Supports(vEditorRegistrator.GetKeywordsManager(BTCLDatabase.BTCLServer), IpSHKeywordsManager, vKeywordsManager) and
    Supports(vEditorRegistrator.GetObjectNameManager(BTCLDatabase.BTCLServer, BTCLDatabase), IpSHObjectNamesManager, vObjectNamesManager) then
  begin
    Result := EmptyStr;
    vPreviosTokenEnd := Point(0, 0);
    vTokenScaner := TibSHPSQLDebuggerTokenScaner.Create(nil);
    try
      vTokenScaner.DDLText.Text := AStatement;
      while vTokenScaner.Next and (Length(vTokenScaner.Token) > 0) do
      begin
        if (vTokenScaner.TokenType in [ttUnknown, ttString, ttSymbol, ttNumeric]) and (vTokenScaner.Token[1] <> ':') then
        begin
          CopySpaces;
          Result := Result + vTokenScaner.Token;
          vPreviosTokenEnd := vTokenScaner.TokenEnd;
        end
        else
        begin
          //ttIdentifier, ttD3Identifier
//          vToken := UpperCase(vTokenScaner.Token);
          vToken := vTokenScaner.UpperToken;
          if AReplaceAll or (vInSelectClause > 0) or (vToken[1] = ':') then
          begin
            if vToken[1] = ':' then
            begin
              if Length(vToken) = 1 then
              begin
                CopySpaces;
                vPreviosTokenEnd := vTokenScaner.TokenEnd;
                Result := Result + ' ';
                vTokenScaner.Next;
//                vToken := UpperCase(vTokenScaner.Token);
                vToken := vTokenScaner.UpperToken;
              end
              else
                vToken := System.Copy(vToken, 2, Length(vToken) - 1);
              CopySpaces;
              ReplaceVariableByValue;
              vPreviosTokenEnd := vTokenScaner.TokenEnd;
            end
            //пропускаем ключевые слова
            else
            if vKeywordsManager.IsKeyword(vToken) and (vToken<>'ROW_COUNT')
             and (vToken<>'SQLCODE')and (vToken<>'GDSCODE') 
            then
            begin
              if vToken = 'SELECT' then
                Inc(vInSelectClause)
              else
              if vToken = 'EXTRACT' then
                Inc(vInSelectClause)
              else
              if vToken = 'FROM' then
                Dec(vInSelectClause);
              CopySpaces;
              Result := Result + vTokenScaner.Token;
              vPreviosTokenEnd := vTokenScaner.TokenEnd;
            end
            else
            begin
              CopySpaces;
              vPreviosTokenEnd := vTokenScaner.TokenEnd;
              if AReplaceAll and (vInSelectClause <= 0) then
              begin
                vTokenKind := tkIdentifier;
                vObjectNamesManager.LinkSearchNotify(Self, PChar(vToken), 0, Length(vToken), vTokenKind);
                if vTokenKind = tkTableName then
                begin
                  S := vTokenScaner.Token;
                  vTokenScaner.Next;
                  if vTokenScaner.Token <> '(' then
                    ReplaceVariableByValue
                  else
                    Result := Result + S;
//                  vTokenScaner.MoveBack;
                end
                else
                  ReplaceVariableByValue;
              end
              else
                Result := Result + vToken; 
            end;
          end
          else    //AReplaceAll or vInSelectClause
          begin
            if vKeywordsManager.IsKeyword(vToken) then
            begin
              if vToken = 'SELECT' then
                Inc(vInSelectClause)
              else
              if vToken = 'FROM' then
                Dec(vInSelectClause);
            end;
            CopySpaces;
            Result := Result + vTokenScaner.Token;
            vPreviosTokenEnd := vTokenScaner.TokenEnd;
          end;
        end;
      end; //while
    finally
      vTokenScaner.Free;
    end;
  end;
end;

procedure TibSHPSQLDebuggerForm.DispositionVariable(AVariableName: string;
  var VariableType: TibPSQLVariableType; var Index: Integer);
var
  vVariableName: string;
begin
  //если триггер
{  if Assigned(DBTrigger) then
    vVariableName := AnsiUpperCase(Trim(AVariableName));
  if Assigned(DBTrigger) and
    ((Pos('NEW.', vVariableName) = 1) or (Pos('OLD.', vVariableName) = 1)) then
  begin
    vVariableName := System.Copy(AVariableName, 5, Length(AVariableName) - 4);
    vVariableName := NormalizeName(vVariableName);
    Index := FDebugerObjectFields.IndexOf(vVariableName);
    if Index > -1 then
      VariableType := vtTableField
    else
      VariableType := vtNone;
  end
  else}
  //ищем по всем переменным
  begin
    vVariableName := NormalizeName(AVariableName);
    Index := FDebugerObjectParams.IndexOf(vVariableName);
    if Index > -1 then
      VariableType := vtInputParameter
    else
    begin
      Index := FDebugerObjectReturns.IndexOf(vVariableName);
      if Index > -1 then
        VariableType := vtReturnParameter
      else
      begin
        Index := FDebugerObjectVariables.IndexOf(vVariableName);
        if Index > -1 then
          VariableType := vtLocalVariable
        else
          VariableType := vtNone;
      end;
    end;
  end;
end;

function TibSHPSQLDebuggerForm.ValueToStringCast(AValue: Variant;
  ADataType: string): string;
begin
{
+BLOB=
++CHAR=
++CHARACTER=
++DATE=
++DECIMAL=
++DOUBLE=
++DOUBLE PRECISION=
++FLOAT=
++INTEGER=
++NUMERIC=
++SMALLINT=
++TIME=
++TIMESTAMP=
++VARCHAR=
++CSTRING=

+BOOLEAN=

++BIGINT=
}

  if VarIsClear(AValue) or VarIsNull(AValue) then
    Result := 'NULL'
  else
  if (ADataType = 'DATE') then
  begin
    if VarIsType(AValue, [varDate, varDouble]) then
      Result := Format('''%s''',[FormatDateTime('DD-MMM-YY', AValue)])
    else
      Result := Format('''%s''', [AValue]);
  end
  else
  if (ADataType = 'TIMESTAMP') then
  begin
    if VarIsType(AValue, [varDate, varDouble]) then
      Result := Format('''%s''',[FormatDateTime('DD.MM.YYYY HH:MM:SS', AValue)])
    else
      Result := Format('''%s''', [AValue]);
  end
  else
  if (ADataType = 'TIME') then
  begin
    if VarIsType(AValue, [varDate, varDouble]) then
      Result := Format('''%s''',[FormatDateTime('HH:MM:SS', AValue)])
    else
      Result := Format('''%s''', [AValue]);
  end
  else
  if (ADataType = 'CHAR') or
    (ADataType = 'CHAR') or
    (ADataType = 'CHARACTER') or
    (ADataType = 'CHARACTER') or
    (ADataType = 'VARCHAR') or
    (ADataType = 'CSTRING') then
  begin
    Result := Format('''%s''', [AValue]);
  end
  else
  if (ADataType = 'DECIMAL') or
    (ADataType = 'DOUBLE PRECISION') or
    (ADataType = 'NUMERIC') or
    (ADataType = 'FLOAT') then
  begin
    Result := Format('%s', [AnsiReplaceStr(AValue, ',', '.')]);
  end
  else
  if (ADataType = 'INTEGER')  or
     (ADataType =  'SMALLINT') or
     (ADataType = 'BIGINT') then
  begin
    Result := Format('%s', [AValue]);
  end
  else
  if (ADataType = 'BOOLEAN') then
  begin
    Result := Format('%s', [AValue]);
  end
  else
  begin
    Result:=StringReplace(AValue,'''','''''',[rfReplaceAll]);
    Result := Format('''%s''', [Result]);
  end;
  Result := Format('(CAST(%s AS %s))', [Result, ADataType]);
end;

procedure TibSHPSQLDebuggerForm.DoOnSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
var BreakIndex:Integer;  
begin
  if Assigned(FCurrentStatement) and (FCurrentStatement.BeginOfStatement.Y + 1 = Line)
  and not ( rsRun in FRunState)
  then
  begin
    FG := clWhite;
    BG := CurrentLineColor;
    Special := True;
  end
  else
  begin
   BreakIndex:=IndexInBreakPointList(Line);
   if BreakIndex>=0 then
    begin
      FG := clWhite;
      if PBreekPointTreeRec(FBreakpoints[BreakIndex])^.Enabled then
       BG := clRed
      else
       BG := clLime;      
      Special := True;
    end
    else
      inherited DoOnSpecialLineColors(Sender, Line, Special, FG, BG);
  end
end;

function TibSHPSQLDebuggerForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
//  Editor.ReadOnly := True;
end;

function TibSHPSQLDebuggerForm.GetCanDestroy: Boolean;
begin
  Result := inherited GetCanDestroy;
end;

procedure TibSHPSQLDebuggerForm.SetTreeEvents;
begin
  // ResultTree Events
  Tree.OnGetNodeDataSize := ResultTreeGetNodeDataSize;
  Tree.OnFreeNode := ResultTreeFreeNode;
  Tree.OnGetText := ResultTreeGetText;
  Tree.OnIncrementalSearch := ResultTreeIncrementalSearch;
  // End of ResultTree Events
end;

procedure TibSHPSQLDebuggerForm.OutputDebug;
begin
{  DebugMsg.Clear;
  for I := 0 to Pred(FDebugerObjectParams.Count) do
    DebugMsg.Lines.Add(Format('Parameter: %s'#9#9'Value: %s', [FDebugerObjectParams[I], FDebugerObjectParams.ValueByIndex[I]]));
  for I := 0 to Pred(FDebugerObjectReturns.Count) do
    DebugMsg.Lines.Add(Format('Returns: %s'#9#9'Value: %s', [FDebugerObjectReturns[I], FDebugerObjectReturns.ValueByIndex[I]]));
  for I := 0 to Pred(FDebugerObjectVariables.Count) do
    DebugMsg.Lines.Add(Format('Variable: %s'#9#9'Value: %s', [FDebugerObjectVariables[I], FDebugerObjectVariables.ValueByIndex[I]]));
 }

end;

procedure TibSHPSQLDebuggerForm.LoadObject;
var
  I: Integer;
  vParamList, vReturnsList: TStringList;
  vVariableList: TStringList;
  IField:IIbSHField;
begin
  FRunState:=[];
  DDLInfo.DDL.Text := DDLGenerator.GetDDLText(DBObject);
  Editor.Lines.Clear;
  Editor.Lines.AddStrings(DDLInfo.DDL);
  vParamList := TStringList.Create;
  vReturnsList := TStringList.Create;
  vVariableList := TStringList.Create;
  try
    ParseProcParams(DDLInfo.DDL, vParamList, vReturnsList, vVariableList);
      for I := 0 to Pred(vParamList.Count) do
      FDebugerObjectParams.AddWithDataType(NormalizeName(Trim(vParamList.Names[I])), Trim(vParamList.ValueFromIndex[I]));
    for I := 0 to Pred(vReturnsList.Count) do
      FDebugerObjectReturns.AddWithDataType(NormalizeName(Trim(vReturnsList.Names[I])), Trim(vReturnsList.ValueFromIndex[I]));
    for I := 0 to Pred(vVariableList.Count) do
      FDebugerObjectVariables.AddWithDataType(
       NormalizeName(Trim(vVariableList.Names[I])), Trim(vVariableList.ValueFromIndex[I])
      );
    if Assigned(DBTrigger) then
    begin
      if not Assigned(vTableComponent) then
      begin
        vTableComponent:=Designer.GetComponent(IibSHTable).Create(nil);
        Designer.Components.Remove(vTableComponent);       
      end;
      if Assigned(vTableComponent) then
      try
        vTableComponent.Caption := DBTrigger.TableName;
        vTableComponent .OwnerIID := DBTrigger.OwnerIID;
        (vTableComponent as IibSHDBObject).State:= csSource;
        (vTableComponent as IibSHDBObject).Refresh;
        for i:=0 to   (vTableComponent as IibSHTable).Fields.Count-1 do
        begin
         IField:=(vTableComponent as IibSHTable).GetField(i);
         FDebugerObjectVariables.AddWithDataType(NormalizeName('NEW.'+(vTableComponent as IibSHTable).Fields[i]),IField.DataTypeExt);
         FDebugerObjectVariables.AddWithDataType(NormalizeName('OLD.'+(vTableComponent as IibSHTable).Fields[i]),IField.DataTypeExt);
        end;
      finally
 //      Designer.Components.Remove(vTableComponent);
//       FreeAndNil(vTableComponent)
      end;
    end;

     FDebugerObjectVariables.AddWithDataType('ROW_COUNT', 'INTEGER=0');
     FDebugerObjectVariables.AddWithDataType('SQLCODE', 'INTEGER=0');
     FDebugerObjectVariables.AddWithDataType('GDSCODE', 'INTEGER=0');          
  finally
    vParamList.Free;
    vReturnsList.Free;
    vVariableList.Free;
  end;
  PrepareResultTree;
  FTokenScaner.Reset;
  FTokenScaner.DDLText := DDLInfo.DDL;
  OutputDebug;

  Parse;
//  FreeDRV;
//^^^^^^^^^AV при Reset
  CreateDRV;
end;

procedure TibSHPSQLDebuggerForm.PrepareResultTree;
var
  I: Integer;
  vFont: TFont;
begin
  if Assigned(DBProcedure) and (FDebugerObjectReturns.Count > 0) then
  begin
    tsResult.Visible := True;
    vFont := TFont.Create;
    try
      vFont.Assign(ResultTree.Font);
      ResultTree.Font.Assign(ResultTree.Header.Font);
      ResultTree.Header.Columns.Clear;
      ResultTree.Clear;
      for I := 0 to Pred(FDebugerObjectReturns.Count) do
      begin
        with ResultTree.Header.Columns.Add do
        begin
          Options := [coAllowClick,coEnabled,coParentBidiMode,coParentColor,coResizable,coShowDropMark,coVisible];
          Text := FDebugerObjectReturns[I];
          Width := ResultTree.Canvas.TextWidth(Text) + 14;
          if Width < 50 then Width := 50;
        end;
      end;
    finally
      ResultTree.Font.Assign(vFont);
      vFont.Free;
    end;
  end
  else
  begin
    tsResult.Visible := False;
    ResultTree.Header.Columns.Clear;
  end;
  ResultTree.Align:=alClient;
end;


function TibSHPSQLDebuggerForm.IndexInBreakPointList(ALine: Integer):Integer;
var
    i:integer;
begin
   for i:=0 to Pred(FBreakpoints.Count) do
    if PBreekPointTreeRec(FBreakpoints[i])^.Line=ALine then
    begin
     Result:=i;
     Exit;
    end;
  Result:=-1;
end;

procedure TibSHPSQLDebuggerForm.ClearBreakPass;
var
    i:integer;
begin
   for i:=0 to Pred(FBreakpoints.Count) do
   begin
     PBreekPointTreeRec(FBreakpoints[i])^.FCounter:=0
   end;
end;


procedure TibSHPSQLDebuggerForm.RemoveFromBreakPointList(ALine: Integer;FromTree:boolean=False);
var
    i:integer;
    Node:PVirtualNode;
    NodeData:Pointer;
begin
    i:=IndexInBreakPointList(Aline);
    if i>-1 then
    begin
     Node:=BreakpointsTree.GetFirstChild(nil);
     while Assigned(Node) do
     begin
      NodeData:=BreakpointsTree.GetNodeData(Node);
      if  Assigned(NodeData) and (Pointer(NodeData^)=FBreakpoints[i]) then
      begin
       BreakpointsTree.DeleteNode(Node);
       Break
      end;
      Node:=BreakpointsTree.GetNextSibling(Node);
     end;

     Finalize(PBreekPointTreeRec(FBreakpoints[i])^);
     Dispose(PBreekPointTreeRec(FBreakpoints[i]));
     FBreakpoints.Delete(i);
    end;
//    Editor.Invalidate
end;

procedure TibSHPSQLDebuggerForm.InternalToggleBreakpoint(ALine: Integer);
var
  vMarks: TSynEditMarks;
  vBreakPointMark: TSynEditMark;
  I: Integer;
  vCanAddBreakPoint: Boolean;
  BreakPointData:PBreekPointTreeRec;
  Node: PVirtualNode;
  NodeData:Pointer;
begin
  if GetCanToggleBreakpoint then
  begin
    Editor.Marks.GetMarksForLine(ALine, vMarks);
    vBreakPointMark := nil;
    vCanAddBreakPoint := False;
    for I := 1 to MAX_MARKS do
    begin
      if Assigned(vMarks[I]) then
      begin
        if not vCanAddBreakPoint then
          vCanAddBreakPoint := vMarks[I].ImageIndex = img_statement;
        if vMarks[I].ImageIndex = img_breakpoint then
          vBreakPointMark := vMarks[I];
        if vCanAddBreakPoint and Assigned(vBreakPointMark) then
          Break;
      end;
    end;
    if Assigned(vBreakPointMark) then
    begin
//      FBreakpoints.Remove(Pointer(ALine));
      RemoveFromBreakPointList(ALine);
      Editor.Marks.Remove(vBreakPointMark);
//^^^^^^^ Такое ощущение что здесь vBreakPointMark дестроится
//      vBreakPointMark.Free;
// Почему то бьет AV
    end
    else
    if vCanAddBreakPoint then
    begin
      vBreakPointMark := TSynEditMark.Create(Editor);
      vBreakPointMark.Line := ALine;
      vBreakPointMark.Char := 1;
      vBreakPointMark.ImageIndex := img_breakpoint;
      vBreakPointMark.Visible := True;
      vBreakPointMark.InternalImage := False;
      vBreakPointMark.BookmarkNumber := -1;
      Editor.Marks.Add(vBreakPointMark);
{##}
      BreakPointData:=AllocMem(SizeOf(TBreekPointTreeRec));
      BreakPointData.Line:=ALine;
      BreakPointData.Condition:='';
      BreakPointData.PassCount:=0;
      BreakPointData.Enabled  :=True;
      FBreakpoints.Add(BreakPointData);
      Node:=BreakpointsTree.AddChild(nil,BreakPointData);
      Node.CheckType :=ctCheckBox;
      Node.CheckState:=csCheckedNormal;
      BreakpointsTree.Refresh
{##}
//      FBreakpoints.Add(Pointer(ALine));
    end;
    Editor.InvalidateLine(ALine);
  end;
end;

procedure TibSHPSQLDebuggerForm.pmiHideMessageClick(Sender: TObject);
begin
  EditorMsgVisible(False);
end;

procedure TibSHPSQLDebuggerForm.pSHSynEdit1GutterClick(Sender: TObject;
  Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
begin
  InternalToggleBreakpoint(Line);
end;

procedure TibSHPSQLDebuggerForm.ResultTreeGetNodeDataSize(
  Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TResultTreeRec);
end;

procedure TibSHPSQLDebuggerForm.pSHSynEdit1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  VarName  :string;
  VarValue :Variant;
begin
   VarName:=GetWordAtMouse(TpSHSynEdit(Sender));
   VarValue:=GetVariable(VarName);
   if VarIsArray(VarValue) then // Сигнал что переменной не существует
     RemoveHint(DebugHint)
   else
    RevealHint(TpSHSynEdit(Sender),VarName+' ='+DebugValue(VarName))
end;

function TibSHPSQLDebuggerForm.GetWordAtMouse(Sender: TpSHSynEdit): string;
var
  Pt: TBufferCoord;
begin
  Sender.GetPositionOfMouse(Pt);
  Result :=Sender.GetWordAtRowCol(Pt)
end;

procedure TibSHPSQLDebuggerForm.WatchesTreeGetNodeDataSize(
  Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
 NodeDataSize:=SizeOf(TWatchTreeRec)
end;

procedure TibSHPSQLDebuggerForm.WatchesTreeFreeNode(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var
   Data:PWatchTreeRec;
begin
   Data := Sender.GetNodeData(Node);
   if Assigned(Data) then
    Finalize(Data^);
end;

procedure TibSHPSQLDebuggerForm.WatchesTreeGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
var
  Data: PWatchTreeRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) and (TextType = ttNormal) then
    case Column of
     0: CellText := Data.WatchName;
     1: CellText := Data.Value;
    end;
end;

procedure TibSHPSQLDebuggerForm.WatchesTreeKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 case Key of
  VK_DELETE:DeleteWatch
 end;
end;

procedure TibSHPSQLDebuggerForm.DeleteWatch1Click(Sender: TObject);
begin
 DeleteWatch
end;

procedure TibSHPSQLDebuggerForm.BreakpointsTreeFreeNode(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var
   Data:Pointer;
begin
   Data := Sender.GetNodeData(Node);
   if Assigned(Data) then
   begin
//    Dispose(Data);
//     RemoveFromBreakPointList(PBreekPointTreeRec(Data^)^.Line,True);
//     Dispose(Data);
   end
end;

procedure TibSHPSQLDebuggerForm.BreakpointsTreeGetNodeDataSize(
  Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
 NodeDataSize:=SizeOf(Pointer)
end;

procedure TibSHPSQLDebuggerForm.BreakpointsTreeGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
var
  Data: Pointer;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) and (TextType = ttNormal) then
    case Column of
     0: CellText := '';
     1: CellText := IntToStr(PBreekPointTreeRec(Data^)^.Line);
     2: CellText := IntToStr(PBreekPointTreeRec(Data^)^.PassCount);
     3: CellText := PBreekPointTreeRec(Data^)^.Condition;
    end;
end;

procedure TibSHPSQLDebuggerForm.BreakpointsTreeDblClick(Sender: TObject);
var
  Data: Pointer;
begin
  if BreakpointsTree.FocusedNode<>nil then
  begin
    Data := BreakpointsTree.GetNodeData(BreakpointsTree.FocusedNode);
    if Assigned(Data) then
    begin
      Editor.CaretY:= PBreekPointTreeRec(Data^)^.Line;
      Editor.EnsureCursorPosVisible;
      Editor.SetFocus
    end    
  end;  
end;

procedure TibSHPSQLDebuggerForm.AddWatch1Click(Sender: TObject);
var
  Expression:string;
begin
   Expression:='';
   if InputQuery('Watch Properties','Expression',Expression) then
   AddWatchExpression(Expression)
end;

procedure TibSHPSQLDebuggerForm.EditWatch1Click(Sender: TObject);
var
  Expression:string;
  Node: PVirtualNode;
  NodeData:PWatchTreeRec;

begin
   Node:=WatchesTree.FocusedNode;
   if Assigned(Node) then
   begin
     NodeData:= WatchesTree.GetNodeData(Node);
     if Assigned(NodeData) then
     begin
       Expression:=NodeData.WatchName;
       if InputQuery('Watch Properties','Expression',Expression) then
       begin
        NodeData.WatchName:=Expression;
        NodeData.Value    := DebugValue(Expression);
        WatchesTree.Refresh
       end;
     end
   end;
end;

procedure TibSHPSQLDebuggerForm.WatchesTreeChecked(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NodeData:PWatchTreeRec;
begin
//
 NodeData:= WatchesTree.GetNodeData(Node);
 if Node.CheckState=csCheckedNormal then
 begin
   NodeData.Enabled:=True;
   NodeData.Value     := DebugValue(NodeData.WatchName);
 end
 else
 begin
   NodeData.Enabled:=False;
   NodeData.Value     := '<Disabled>';
 end;
end;

procedure TibSHPSQLDebuggerForm.BreakpointsTreeChecked(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: Pointer;
begin
//
 Data := Sender.GetNodeData(Node);
 PBreekPointTreeRec(Data^)^.Enabled:=Node.CheckState=csCheckedNormal;
 Editor.Invalidate
end;

procedure TibSHPSQLDebuggerForm.WatchesTreeDblClick(Sender: TObject);
begin
 EditWatch1Click(nil)
end;

procedure TibSHPSQLDebuggerForm.EditBreakPoint1Click(Sender: TObject);
var
  Data: Pointer;
begin
 if BreakpointsTree.FocusedNode<>nil then
 begin
  Data := BreakpointsTree.GetNodeData(BreakpointsTree.FocusedNode);
  if Assigned(Data) then
  begin
   ChangeBreakPointProps(PBreekPointTreeRec(Data^)^.PassCount,
    PBreekPointTreeRec(Data^)^.Condition);
   BreakpointsTree.Refresh
  end
 end

end;

procedure TibSHPSQLDebuggerForm.DeleteBreakPoint1Click(Sender: TObject);
var
  Data: Pointer;
begin
 with BreakpointsTree do
 if FocusedNode<>nil then
 begin
  Data := GetNodeData(FocusedNode);
  if Assigned(Data) then
  begin
   InternalToggleBreakpoint(PBreekPointTreeRec(Data^)^.Line)
//   RemoveFromBreakPointList(PBreekPointTreeRec(Data^)^.Line)
  end;
 end
end;


function TibSHPSQLDebuggerForm.GetCanModifyVarValues: Boolean;
begin
  Result:=not (rsRun in FRunState)
end;

procedure TibSHPSQLDebuggerForm.ModifyVarValues;
var
   Expression:string;
begin
  if Editor.SelText='' then
   Expression:=Editor.WordAtCaret
  else
   Expression:=Editor.SelText;

  ShowModifyVarDebugValues(Self,Expression)
end;

procedure  TibSHPSQLDebuggerForm.ExecuteException(ACurrentStatement: IibSHDebugStatement);
begin
 if ACurrentStatement.OperatorType=dotException then
 begin
  Include(FRunState,rsServerError);
  FServerException:=True;
  if Length(ACurrentStatement.OperatorText)>0 then
  begin
   FExceptionName:=ACurrentStatement.OperatorText;
   FLastErrorMsg :='EXCEPTION '+FExceptionName;
   if ACurrentStatement.VariableName<>'' then
    FLastErrorMsg :=FLastErrorMsg +#13#10+'Error Text: "'+ACurrentStatement.VariableName+'"'
  end  
 end;
end;

type
TState=(sNormal,sInQuote,sInDoubleQuote);

function GetWhenCondition(const aConditions:string; var aPosition:integer):string;
var
   i:integer;
   f:boolean;
   State:TState;
begin
  Result:=''; f:=False;
  State:=sNormal;

  i:=aPosition;
  while   i<Length(aConditions) do
  case State of
   sNormal:
     begin
       case aConditions[i] of
       ',': begin
             f:=True;
             Break
        end;
        '''': State:=sInQuote;
        '"': State:=sInDoubleQuote;
       end;
      Inc(i);
     end; //sNormal
   sInQuote:
     begin
      if aConditions[i]='''' then
        State:=sNormal;
      Inc(i);
     end;
   sInDoubleQuote:
     begin
      if aConditions[i]='"' then
        State:=sNormal;
      Inc(i);
     end
  end;
  if f  or (i=Length(aConditions)) then
  begin
   if f then
    Result:=Trim(System.Copy(aConditions,aPosition,i-aPosition))
   else
    Result:=Trim(System.Copy(aConditions,aPosition,i));
   aPosition:=i+1;
  end

end;

function TibSHPSQLDebuggerForm.ExecuteErrorHandler(
  ACurrentStatement: IibSHDebugStatement): Boolean;

 Function IsUserException(const aExceptionName:string) :boolean;
 begin
  Result:=UpperCase(FExceptionName)=UpperCase(aExceptionName)
 end;

 Function IsOurGDSCodeError(const aCodeError:string) :boolean;
 begin
   Result:=ACurrentStatement.LastErrorCode.IBErrorCode=
    GetGDSErrorCode(aCodeError)
 end;


 Function IsOurCodeError(const aCodeError:string) :boolean;
 var
   s:string;
 begin
   s:=IntToStr(ACurrentStatement.LastErrorCode.SQLCode);
   Result:=s=Trim(aCodeError)
 end;

var
   CurCondition:string;
   Position:integer;
begin
 Result:=False;
 if ACurrentStatement.OperatorType=dotErrorHandler then
 begin
   Position:=1;
   CurCondition:=GetWhenCondition(ACurrentStatement.OperatorText,Position);
   while Length(CurCondition) >0 do
   begin
     case CurCondition[1] of
      'A','a': if (Length(CurCondition)>3) and
             (CurCondition[2] in ['N','n']) and
             (CurCondition[3] in ['Y','y']) and
             (CurCondition[4] =' ') then
           begin
             Result:=True
           end
           else
             ExecutionError('Unknown EXCEPTION name "'+CurCondition+'"')  ;
    'G','g': if (Length(CurCondition)>7) and
             (CurCondition[2] in ['D','d']) and
             (CurCondition[3] in ['S','s']) and
             (CurCondition[4] in ['C','c']) and
             (CurCondition[5] in ['O','o']) and
             (CurCondition[6] in ['D','d']) and
             (CurCondition[7] in ['E','e']) and
             (CurCondition[8] =' ') then
           begin
             Result:=IsOurGDSCodeError(System.Copy(CurCondition,9,MaxInt))
           end
           else
             ExecutionError('Unknown EXCEPTION name "'+CurCondition+'"')  ;

      'E','e': if (Length(CurCondition)>9) and
             (CurCondition[2] in ['X','x']) and
             (CurCondition[3] in ['C','c']) and
             (CurCondition[4] in ['E','e']) and
             (CurCondition[5] in ['P','p']) and
             (CurCondition[6] in ['T','t']) and
             (CurCondition[7] in ['I','i']) and
             (CurCondition[8] in ['O','o']) and
             (CurCondition[9] in ['N','N']) and
             (CurCondition[10] =' ') then
           begin
             Result:=IsUserException(Trim(System.Copy(CurCondition,11,MaxInt)));
           end
           else
             ExecutionError('Unknown EXCEPTION name "'+CurCondition+'"')  ;
   'S','s': if (Length(CurCondition)>7) and
             (CurCondition[2] in ['Q','q']) and
             (CurCondition[3] in ['L','l']) and
             (CurCondition[4] in ['C','c']) and
             (CurCondition[5] in ['O','o']) and
             (CurCondition[6] in ['D','d']) and
             (CurCondition[7] in ['E','e']) and
             (CurCondition[8] =' ') then
           begin
             Result:=IsOurCodeError(System.Copy(CurCondition,9,MaxInt))
           end
           else
             ExecutionError('Unknown EXCEPTION name "'+CurCondition+'"')  ;
     else
             ExecutionError('Unknown EXCEPTION name "'+CurCondition+'"')  ;


     end;
     if Result then
       Exit;
     CurCondition:=GetWhenCondition(ACurrentStatement.OperatorText,Position);
   end;
{
 case ACurrentStatement.OperatorText[1] of
  'A','a': if (Length(ACurrentStatement.OperatorText)>3) and
             (ACurrentStatement.OperatorText[2] in ['N','n']) and
             (ACurrentStatement.OperatorText[3] in ['Y','y']) and
             (ACurrentStatement.OperatorText[4] =' ') then
           begin
             Result:=True
           end
           else
             ExecutionError('Unknown EXCEPTION name "'+ACurrentStatement.OperatorText+'"')  ;
   'E','e': if (Length(ACurrentStatement.OperatorText)>9) and
             (ACurrentStatement.OperatorText[2] in ['X','x']) and
             (ACurrentStatement.OperatorText[3] in ['C','c']) and
             (ACurrentStatement.OperatorText[4] in ['E','e']) and
             (ACurrentStatement.OperatorText[5] in ['P','p']) and
             (ACurrentStatement.OperatorText[6] in ['T','t']) and
             (ACurrentStatement.OperatorText[7] in ['I','i']) and
             (ACurrentStatement.OperatorText[8] in ['O','o']) and
             (ACurrentStatement.OperatorText[9] in ['N','N']) and
             (ACurrentStatement.OperatorText[10] =' ') then
           begin
             Result:=IsUserException(Trim(System.Copy(ACurrentStatement.OperatorText,11,MaxInt)));
           end
           else
             ExecutionError('Unknown EXCEPTION name "'+ACurrentStatement.OperatorText+'"')  ;


   'S','s': if (Length(ACurrentStatement.OperatorText)>7) and
             (ACurrentStatement.OperatorText[2] in ['Q','q']) and
             (ACurrentStatement.OperatorText[3] in ['L','l']) and
             (ACurrentStatement.OperatorText[4] in ['C','c']) and
             (ACurrentStatement.OperatorText[5] in ['O','o']) and
             (ACurrentStatement.OperatorText[6] in ['D','d']) and
             (ACurrentStatement.OperatorText[7] in ['E','e']) and
             (ACurrentStatement.OperatorText[8] =' ') then
           begin
             Result:=IsOurCodeError(System.Copy(ACurrentStatement.OperatorText,9,MaxInt))
           end
           else
             ExecutionError('Unknown EXCEPTION name "'+ACurrentStatement.OperatorText+'"')  ;
 else
             ExecutionError('Unknown EXCEPTION name "'+ACurrentStatement.OperatorText+'"')  ;

 end;}
 end
end;

end.



