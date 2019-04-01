unit ibSHStatisticsFrm;

interface

uses

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, VirtualTrees, ImgList,
  ExtCtrls, Math, Clipbrd,
  SHDesignIntf, ibSHDesignIntf, ibSHDriverIntf, ibSHComponentFrm, ibSHMessages, ibSHConsts,
  ibSHValues, SynEdit, pSHSynEdit, ComCtrls, Menus;

type
  TStatisticNodeType = (ptRoot, ptCommon, ptTabelName, ptOperation);
  TStatisticKind = (pkIdxReads, pkSeqReads, pkUpdates, pkDeletes, pkInserts,
                     pkBackoutCount, pkExpunge, pkPurge);


  PStatisticRec = ^TStatisticRec;
  TStatisticRec = record
    NodeType: TStatisticNodeType;
    StatisticKind: TStatisticKind;
    Text: string;
    Value: string;
    IntValue: Integer;
    ImageIndex: Integer;
  end;

  TibBTStatisticsForm = class(TibBTComponentForm, ISHRunCommands, ISHEditCommands,
    IibSHStatisticsForm)
    vtStatistic: TVirtualDrawTree;
    ImageList1: TImageList;
    Panel4: TPanel;
    pSHSynEdit2: TpSHSynEdit;
    Splitter2: TSplitter;
    PopupMenuMessage: TPopupMenu;
    pmiHideMessage: TMenuItem;
    procedure vtStatisticHeaderClick(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure vtStatisticFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure vtStatisticGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vtStatisticGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure vtStatisticDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure pmiHideMessageClick(Sender: TObject);
  private
    FCurrentMaxValue: Integer;
    function GetStatistics: IibSHStatistics;
    function GetShowSysTables: Boolean;
    procedure ShowMessages;
    procedure HideMessages;
    procedure GutterDrawNotify(Sender: TObject; ALine: Integer; var ImageIndex: Integer);
  protected
    { ISHRunCommands }
    function GetCanRun: Boolean; override;
    function GetCanPause: Boolean; override;
    function GetCanCreate: Boolean; override;
    function GetCanAlter: Boolean; override;
    function GetCanClone: Boolean; override;
    function GetCanDrop: Boolean; override;
    function GetCanRecreate: Boolean; override;
    function GetCanDebug: Boolean; override;
    function GetCanCommit: Boolean; override;
    function GetCanRollback: Boolean; override;
    function GetCanRefresh: Boolean; override;
    procedure Run; override;
    procedure Pause; override;
    procedure ISHRunCommands.Create = ICreate;
    procedure ICreate; override;
    procedure Alter; override;
    procedure Clone; override;
    procedure Drop; override;
    procedure Recreate; override;
    procedure Debug; override;
    procedure Commit; override;
    procedure Rollback; override;
    procedure Refresh; override;
    { ISHEditCommands }
    function GetCanUndo: Boolean; override;
    function GetCanRedo: Boolean; override;
    function GetCanCut: Boolean; override;
    function GetCanCopy: Boolean; override;
    function GetCanPaste: Boolean; override;
    function GetCanSelectAll: Boolean; override;
    function GetCanClearAll: Boolean; override;

    procedure Undo; override;
    procedure Redo; override;
    procedure Cut; override;
    procedure Copy; override;
    procedure Paste; override;
    procedure SelectAll; override;
    procedure ClearAll; override;

    procedure FillTree;

    property Statistics: IibSHStatistics read GetStatistics;
    property ShowSysTables: Boolean read GetShowSysTables;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    property CurrentMaxValue: Integer read FCurrentMaxValue write FCurrentMaxValue;
  end;

var
  ibBTStatisticsForm: TibBTStatisticsForm;

implementation

{$R *.dfm}

{ TibBTStatisticsForm }

constructor TibBTStatisticsForm.Create(AOwner: TComponent;
  AParent: TWinControl; AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  ImageList1.AddImage(Designer.ImageList, Designer.GetImageIndex(IibSHTable));
  Editor := pSHSynEdit2;
  Editor.Lines.Clear;
  Editor.OnGutterDraw := GutterDrawNotify;
  Editor.GutterDrawer.ImageList := ImageList1;
  Editor.GutterDrawer.Enabled := True;
  RegisterEditors;
  FillTree;
  FocusedControl := vtStatistic;
end;

function TibBTStatisticsForm.GetStatistics: IibSHStatistics;
begin
  Supports(Component, IibSHStatistics, Result);
end;

function TibBTStatisticsForm.GetShowSysTables: Boolean;
begin
  Result := False;
end;

procedure TibBTStatisticsForm.ShowMessages;
begin
  Panel4.Visible := True;
  Splitter2.Visible := True;
end;

procedure TibBTStatisticsForm.HideMessages;
begin
  Panel4.Visible := False;
  Splitter2.Visible := False;
end;

procedure TibBTStatisticsForm.GutterDrawNotify(Sender: TObject; ALine: Integer;
  var ImageIndex: Integer);
begin
  if ALine = 0 then ImageIndex := 2;
end;

function TibBTStatisticsForm.GetCanRun: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanPause: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanCreate: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanAlter: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanClone: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanDrop: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanRecreate: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanDebug: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanCommit: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanRollback: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanRefresh: Boolean;
begin
    Result := Assigned(Statistics) and Assigned(Statistics.Database) and
      (not Statistics.Database.WasLostConnect);
end;

procedure TibBTStatisticsForm.Run;
begin
//
end;

procedure TibBTStatisticsForm.Pause;
begin
//
end;

procedure TibBTStatisticsForm.ICreate;
begin
//
end;

procedure TibBTStatisticsForm.Alter;
begin
//
end;

procedure TibBTStatisticsForm.Clone;
begin
//
end;

procedure TibBTStatisticsForm.Drop;
begin
//
end;

procedure TibBTStatisticsForm.Recreate;
begin
//
end;

procedure TibBTStatisticsForm.Debug;
begin
//
end;

procedure TibBTStatisticsForm.Commit;
begin
//
end;

procedure TibBTStatisticsForm.Rollback;
begin
//
end;

procedure TibBTStatisticsForm.Refresh;
begin
  FillTree;
end;

function TibBTStatisticsForm.GetCanUndo: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanRedo: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanCut: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanCopy: Boolean;
begin
  Result := True;
end;

function TibBTStatisticsForm.GetCanPaste: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanSelectAll: Boolean;
begin
  Result := False;
end;

function TibBTStatisticsForm.GetCanClearAll: Boolean;
begin
  Result := False;
end;

procedure TibBTStatisticsForm.Undo;
begin
//
end;

procedure TibBTStatisticsForm.Redo;
begin
//
end;

procedure TibBTStatisticsForm.Cut;
begin
//
end;

procedure TibBTStatisticsForm.Copy;
var
  vStrToCopy: string;
  vShowGarbageStatistic: Boolean;
  I: Integer;
  vDataset: IibSHDRVDataset;
  vQuery: IibSHDRVQuery;
  S: string;
begin
  vStrToCopy := EmptyStr;
  if Assigned(Statistics) then
  begin
    if Supports(Statistics.DRVTimeStatistics, IibSHDRVDataset, vDataset) then
    begin
      S := vDataset.SelectSQL.Text;
      if Length(S) > 0 then vStrToCopy := vStrToCopy + S + sLineBreak + sLineBreak;
      {
      if vDataset.Active then
        try
          vStrToCopy := vStrToCopy + vDataset.Plan  + sLineBreak + sLineBreak;
        except
        end;
      }  
    end
    else
    if Supports(Statistics.DRVTimeStatistics, IibSHDRVQuery, vQuery) then
    begin
      S := vQuery.SQL.Text;
      if Length(S) > 0 then vStrToCopy := vStrToCopy + S + sLineBreak + sLineBreak;
      {
      if vQuery.Prepared then
        try
          vStrToCopy := vStrToCopy + vQuery.Plan + sLineBreak + sLineBreak;
        except
        end;
      }  
    end;

    vStrToCopy := vStrToCopy + SOperationsPerTable + sLineBreak;
    with Statistics.DRVStatistics do
    begin
      for I := 0 to Pred(TablesCount) do
      begin
        if not ShowSysTables then
          if Pos('RDB$', TableStatistics[I].TableName) = 1 then continue;
        if (not (TableStatistics[I].IdxReads + TableStatistics[I].SeqReads +
                 TableStatistics[I].Inserts + TableStatistics[I].Updates+
                 TableStatistics[I].Deletes = 0)) then
        begin
          vStrToCopy := vStrToCopy + TableStatistics[I].TableName + sLineBreak;
          if TableStatistics[I].SeqReads > 0 then
            vStrToCopy := vStrToCopy +
              FormatFloat('###,###,###,###,##0', TableStatistics[I].SeqReads) +
              SNonIndexedReads + sLineBreak;
          if TableStatistics[I].IdxReads > 0 then
            vStrToCopy := vStrToCopy +
              FormatFloat('###,###,###,###,##0', TableStatistics[I].IdxReads) +
              SIndexedReads + sLineBreak;
          if TableStatistics[I].Inserts > 0 then
            vStrToCopy := vStrToCopy +
              FormatFloat('###,###,###,###,##0', TableStatistics[I].Inserts) +
              SInserts + sLineBreak;
          if TableStatistics[I].Updates > 0 then
            vStrToCopy := vStrToCopy +
              FormatFloat('###,###,###,###,##0', TableStatistics[I].Updates) +
              SUpdates + sLineBreak;
          if TableStatistics[I].Deletes > 0 then
            vStrToCopy := vStrToCopy +
              FormatFloat('###,###,###,###,##0', TableStatistics[I].Deletes) +
              SDeletes + sLineBreak;
        end;
      end;
// Garbage collection statistic - никогда ничего не показывает ???
      vShowGarbageStatistic := False;
      for I := 0 to Pred(TablesCount) do
        if (TableStatistics[I].Backout + TableStatistics[I].Expunge +
            TableStatistics[I].Purge > 0) then
        begin
          vShowGarbageStatistic := True;
          Break;
        end;
      if vShowGarbageStatistic then
      begin
        vStrToCopy := vStrToCopy + SGarbageStatistics + sLineBreak;
        for I := 0 to Pred(TablesCount) do
        begin
          if not ShowSysTables then
            if Pos('RDB$', TableStatistics[I].TableName) = 1 then continue;
          if (not (TableStatistics[I].Backout + TableStatistics[I].Expunge +
                   TableStatistics[I].Purge = 0)) then
          begin
            vStrToCopy := vStrToCopy + TableStatistics[I].TableName + sLineBreak;
            if TableStatistics[I].Backout > 0 then
            vStrToCopy := vStrToCopy +
              FormatFloat('###,###,###,###,##0', TableStatistics[I].Backout) +
              SBackouts + sLineBreak;
            if TableStatistics[I].Expunge > 0 then
            vStrToCopy := vStrToCopy +
              FormatFloat('###,###,###,###,##0', TableStatistics[I].Expunge) +
              SExpunges + sLineBreak;
            if TableStatistics[I].Purge > 0 then
            vStrToCopy := vStrToCopy +
              FormatFloat('###,###,###,###,##0', TableStatistics[I].Purge) +
              SPurges + sLineBreak;
          end;
        end;
      end;
    end;

    if Assigned(Statistics.DRVTimeStatistics) then
    with Statistics.DRVTimeStatistics do
    begin
      vStrToCopy := vStrToCopy + SQueryTime + sLineBreak;
      vStrToCopy := vStrToCopy + SPrepare + ':' +  msToStr(PrepareTime) + sLineBreak;
      vStrToCopy := vStrToCopy + SExecute + ':' +  msToStr(ExecuteTime) + sLineBreak;
      vStrToCopy := vStrToCopy + SFetch + ':' +  msToStr(FetchTime) + sLineBreak;
    end;
  end;
  if Length(vStrToCopy) > 0 then
    Clipboard.AsText := vStrToCopy;
end;

procedure TibBTStatisticsForm.Paste;
begin
//
end;

procedure TibBTStatisticsForm.SelectAll;
begin
//
end;

procedure TibBTStatisticsForm.ClearAll;
begin
//
end;

procedure TibBTStatisticsForm.FillTree;
var
  Level_0: PVirtualNode;
  Level_1: PVirtualNode;
  Level_2: PVirtualNode;
  Data: PStatisticRec;
  I: Integer;
  vShowGarbageStatistic: Boolean;
  vDataSet: IibSHDRVDataset;
  vQuery: IibSHDRVQuery;
  vTemp: Integer;
begin
  with vtStatistic do
  begin
    BeginUpdate;
    HideMessages;
    vtStatistic.Clear;
    if Assigned(Statistics) then
    begin
      if Assigned(Statistics.DRVTimeStatistics) then
      with Statistics.DRVTimeStatistics do
      begin
        if Assigned(Editor) then
        begin
          if Supports(Statistics.DRVTimeStatistics, IibSHDRVDataset, vDataSet) then
          begin
            Designer.TextToStrings(vDataSet.SelectSQL.Text, Editor.Lines, True);
            ShowMessages;
          end
          else
          if Supports(Statistics.DRVTimeStatistics, IibSHDRVQuery, vQuery) then
          begin
            Designer.TextToStrings(vQuery.SQL.Text, Editor.Lines, True);
            ShowMessages;
          end;
        end;

        Level_0 := AddChild(nil);
        Data := GetNodeData(Level_0);
        Data.Text := SQueryTime;
        Data.Value := '';
        Data.NodeType := ptRoot;
        Data.ImageIndex := 1;

        Level_1 := AddChild(Level_0);
        Data := GetNodeData(Level_1);
        Data.Text := SPrepare;
        Data.Value := msToStr(PrepareTime);
        Data.IntValue := PrepareTime;
        Data.NodeType := ptCommon;
        Data.ImageIndex := -1;

        Level_1 := AddChild(Level_0);
        Data := GetNodeData(Level_1);
        Data.Text := SExecute;
        Data.Value := msToStr(ExecuteTime);
        Data.IntValue := ExecuteTime;
        Data.NodeType := ptCommon;
        Data.ImageIndex := -1;

        Level_1 := AddChild(Level_0);
        Data := GetNodeData(Level_1);
        Data.Text := SFetch;
        Data.Value := msToStr(FetchTime);
        Data.IntValue := FetchTime;
        Data.NodeType := ptCommon;
        Data.ImageIndex := -1;
      end;

    // Operations
      Level_0 := AddChild(nil);
      Data := GetNodeData(Level_0);
      Data.Text := SOperationsPerTable;
      Data.Value := '';
      Data.NodeType := ptRoot;
      Data.ImageIndex := 0;
      with Statistics.DRVStatistics do
      begin
        CurrentMaxValue := 0;
//        SortByPerformance;
        for I := 0 to Pred(TablesCount) do
        begin
          if not ShowSysTables then
            if Pos('RDB$', TableStatistics[I].TableName) = 1 then continue;
          if (not (TableStatistics[I].IdxReads + TableStatistics[I].SeqReads +
                   TableStatistics[I].Inserts + TableStatistics[I].Updates+
                   TableStatistics[I].Deletes = 0)) then
          begin
            Level_1 := AddChild(Level_0);
            Data := GetNodeData(Level_1);
            Data.Text := TableStatistics[I].TableName;
            Data.Value := '';
            Data.NodeType := ptTabelName;
            Data.ImageIndex := Pred(ImageList1.Count);
            if TableStatistics[I].SeqReads > 0 then
            begin
              Level_2 := AddChild(Level_1);
              Data := GetNodeData(Level_2);
              Data.Text := '';
              Data.Value := FormatFloat('###,###,###,###,##0', TableStatistics[I].SeqReads);
              Data.IntValue := TableStatistics[I].SeqReads;
              if Data.IntValue > CurrentMaxValue then CurrentMaxValue := Data.IntValue;
              Data.NodeType := ptOperation;
              Data.StatisticKind := pkSeqReads;
              Data.ImageIndex := -1;
            end;

            if TableStatistics[I].IdxReads > 0 then
            begin
              Level_2 := AddChild(Level_1);
              Data := GetNodeData(Level_2);
              Data.Text := '';
              Data.Value := FormatFloat('###,###,###,###,##0', TableStatistics[I].IdxReads);
              Data.IntValue := TableStatistics[I].IdxReads;
              if Data.IntValue > CurrentMaxValue then CurrentMaxValue := Data.IntValue;
              Data.NodeType := ptOperation;
              Data.StatisticKind := pkIdxReads;
              Data.ImageIndex := -1;
            end;

            if TableStatistics[I].Inserts > 0 then
            begin
              Level_2 := AddChild(Level_1);
              Data := GetNodeData(Level_2);
              Data.Text := '';
              Data.Value := FormatFloat('###,###,###,###,##0', TableStatistics[I].Inserts);
              Data.IntValue := TableStatistics[I].Inserts;
              if Data.IntValue > CurrentMaxValue then CurrentMaxValue := Data.IntValue;
              Data.NodeType := ptOperation;
              Data.StatisticKind := pkInserts;
              Data.ImageIndex := -1;
            end;

            if TableStatistics[I].Updates > 0 then
            begin
              Level_2 := AddChild(Level_1);
              Data := GetNodeData(Level_2);
              Data.Text := '';
              Data.Value := FormatFloat('###,###,###,###,##0', TableStatistics[I].Updates);
              Data.IntValue := TableStatistics[I].Updates;
              if Data.IntValue > CurrentMaxValue then CurrentMaxValue := Data.IntValue;
              Data.NodeType := ptOperation;
              Data.StatisticKind := pkUpdates;
              Data.ImageIndex := -1;
            end;

            if TableStatistics[I].Deletes > 0 then
            begin
              Level_2 := AddChild(Level_1);
              Data := GetNodeData(Level_2);
              Data.Text := '';
              Data.Value := FormatFloat('###,###,###,###,##0', TableStatistics[I].Deletes);
              Data.IntValue := TableStatistics[I].Deletes;
              if Data.IntValue > CurrentMaxValue then CurrentMaxValue := Data.IntValue;
              Data.NodeType := ptOperation;
              Data.StatisticKind := pkDeletes;
              Data.ImageIndex := -1;
            end;
            Expanded[Level_1] := True;
          end;
        end;
        // Garbage collection statistic - никогда ничего не показывает ???
        vShowGarbageStatistic := False;
        for I := 0 to Pred(TablesCount) do
          if (TableStatistics[I].Backout + TableStatistics[I].Expunge +
              TableStatistics[I].Purge > 0) then
          begin
            vShowGarbageStatistic := True;
            Break;
          end;
        if vShowGarbageStatistic then
        begin
          Level_0 := AddChild(nil);
          Data := GetNodeData(Level_0);
          Data.Text := SGarbageStatistics;
          Data.Value := '';
          Data.NodeType := ptRoot;
          Data.ImageIndex := -1;
//          SortByGarbageCollected;
          for I := 0 to Pred(TablesCount) do
          begin
            if not ShowSysTables then
              if Pos('RDB$', TableStatistics[I].TableName) = 1 then continue;
            if (not (TableStatistics[I].Backout + TableStatistics[I].Expunge +
                     TableStatistics[I].Purge = 0)) then
            begin
              Level_1 := AddChild(Level_0);
              Data := GetNodeData(Level_1);
              Data.Text := TableStatistics[I].TableName;
              Data.Value := '';
              Data.NodeType := ptTabelName;
              Data.ImageIndex := Pred(ImageList1.Count);

              if TableStatistics[I].Backout > 0 then
              begin
                Level_2 := AddChild(Level_1);
                Data := GetNodeData(Level_2);
                Data.Text := '';
                Data.Value := FormatFloat('###,###,###,###,##0', TableStatistics[I].Backout);
                Data.IntValue := TableStatistics[I].Backout;
                if Data.IntValue > CurrentMaxValue then CurrentMaxValue := Data.IntValue;
                Data.NodeType := ptOperation;
                Data.StatisticKind := pkBackoutCount;
                Data.ImageIndex := -1;
              end;

              if TableStatistics[I].Expunge > 0 then
              begin
                Level_2 := AddChild(Level_1);
                Data := GetNodeData(Level_2);
                Data.Text := '';
                Data.Value := FormatFloat('###,###,###,###,##0', TableStatistics[I].Expunge);
                Data.IntValue := TableStatistics[I].Expunge;
                if Data.IntValue > CurrentMaxValue then CurrentMaxValue := Data.IntValue;
                Data.NodeType := ptOperation;
                Data.StatisticKind := pkExpunge;
                Data.ImageIndex := -1;
              end;

              if TableStatistics[I].Purge > 0 then
              begin
                Level_2 := AddChild(Level_1);
                Data := GetNodeData(Level_2);
                Data.Text := '';
                Data.Value := FormatFloat('###,###,###,###,##0', TableStatistics[I].Purge);
                Data.IntValue := TableStatistics[I].Purge;
                if Data.IntValue > CurrentMaxValue then CurrentMaxValue := Data.IntValue;
                Data.NodeType := ptOperation;
                Data.StatisticKind := pkPurge;
                Data.ImageIndex := -1;
              end;
              Expanded[Level_1] := True;
            end;
          end;
        end;


//        (*
//        if Assigned(vDatabaseStatistic) and Assigned(vDatabase) then
//        with vDatabase, vDatabaseStatistic do
        begin
         {Memory}
          //Level_1 := AddChild(Level_0);
          Level_1 := AddChild(nil);
          Data := GetNodeData(Level_1);
          Data.Text := Format('Memory', []);
          Data.Value := '';
          //Data.NodeType := ptCommon;
          Data.NodeType := ptRoot;
          Data.ImageIndex := -1;

          Level_2 := AddChild(Level_1);
          Data := GetNodeData(Level_2);
          Data.Text := Format('Currently in use', []);
          Data.IntValue := CurrentMemory;
          Data.Value := FormatFloat('###,###,###,###,##0', Data.IntValue) + ' bytes';
          Data.NodeType := ptCommon;
          Data.ImageIndex := -1;

          Level_2 := AddChild(Level_1);
          Data := GetNodeData(Level_2);
          Data.Text := Format('Maximum used since the first attachment', []);
          Data.IntValue := MaxMemory;
          Data.Value := FormatFloat('###,###,###,###,##0', Data.IntValue) + ' bytes';
          Data.NodeType := ptCommon;
          Data.ImageIndex := -1;

          Level_2 := AddChild(Level_1);
          Data := GetNodeData(Level_2);
          Data.Text := Format('Buffers currently allocated', []);
          Data.IntValue := NumBuffers;
          vTemp := Data.IntValue;
          Data.Value := FormatFloat('###,###,###,###,##0', Data.IntValue) + ' pages';
          Data.NodeType := ptCommon;
          Data.ImageIndex := -1;

          Level_2 := AddChild(Level_1);
          Data := GetNodeData(Level_2);
          Data.Text := Format('Buffers currently allocated', []);
          Data.IntValue := vTemp * DatabasePageSize;
          Data.Value := FormatFloat('###,###,###,###,##0', Data.IntValue) + ' bytes';
          Data.NodeType := ptCommon;
          Data.ImageIndex := -1;
         {Operations}
          //Level_1 := AddChild(Level_0);
          Level_1 := AddChild(nil);
          Data := GetNodeData(Level_1);
          Data.Text := Format('Pages', []);
          Data.Value := '';
          //Data.NodeType := ptCommon;
          Data.NodeType := ptRoot;
          Data.ImageIndex := -1;

          Level_2 := AddChild(Level_1);
          Data := GetNodeData(Level_2);
          Data.Text := Format('Fetches (Reads from memory buffer)', []);
          Data.IntValue := Fetches;
          Data.Value := FormatFloat('###,###,###,###,##0', Data.IntValue) + ' pages';
          Data.NodeType := ptCommon;
          Data.ImageIndex := -1;

          Level_2 := AddChild(Level_1);
          Data := GetNodeData(Level_2);
          Data.Text := Format('Reads from memory buffer since the server started', []);
          Data.IntValue := AllFetches;
          Data.Value := FormatFloat('###,###,###,###,##0', Data.IntValue) + ' pages';
          Data.NodeType := ptCommon;
          Data.ImageIndex := -1;

          Level_2 := AddChild(Level_1);
          Data := GetNodeData(Level_2);
          Data.Text := Format('Marks (Writes to memory buffer)', []);
          Data.IntValue := Marks;
          Data.Value := FormatFloat('###,###,###,###,##0', Data.IntValue) + ' pages';
          Data.NodeType := ptCommon;
          Data.ImageIndex := -1;

          Level_2 := AddChild(Level_1);
          Data := GetNodeData(Level_2);
          Data.Text := Format('Writes to memory buffer since the server started', []);
          Data.IntValue := AllMarks;
          Data.Value := FormatFloat('###,###,###,###,##0', Data.IntValue) + ' pages';
          Data.NodeType := ptCommon;
          Data.ImageIndex := -1;

          Level_2 := AddChild(Level_1);
          Data := GetNodeData(Level_2);
          Data.Text := Format('Reads from database', []);
          Data.IntValue := Reads;
          Data.Value := FormatFloat('###,###,###,###,##0', Data.IntValue) + ' pages';
          Data.NodeType := ptCommon;
          Data.ImageIndex := -1;

          Level_2 := AddChild(Level_1);
          Data := GetNodeData(Level_2);
          Data.Text := Format('Reads from database since the server started', []);
          Data.IntValue := AllReads;
          Data.Value := FormatFloat('###,###,###,###,##0', Data.IntValue) + ' pages';
          Data.NodeType := ptCommon;
          Data.ImageIndex := -1;

          Level_2 := AddChild(Level_1);
          Data := GetNodeData(Level_2);
          Data.Text := Format('Writes to database', []);
          Data.IntValue := Writes;
          Data.Value := FormatFloat('###,###,###,###,##0', Data.IntValue) + ' pages';
          Data.NodeType := ptCommon;
          Data.ImageIndex := -1;

          Level_2 := AddChild(Level_1);
          Data := GetNodeData(Level_2);
          Data.Text := Format('Writes to database since the server started', []);
          Data.IntValue := AllWrites;
          Data.Value := FormatFloat('###,###,###,###,##0', Data.IntValue) + ' pages';
          Data.NodeType := ptCommon;
          Data.ImageIndex := -1;

        end;
//        *)
      end;
    end;
    FullExpand;
    EndUpdate;
  end;
end;


procedure TibBTStatisticsForm.vtStatisticHeaderClick(
  Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Column = 0 then
    with vtStatistic do
    begin
      BeginUpdate;
      if Tag = 0 then
      begin
        FullExpand;
        Tag := 1;
      end
      else
      begin
        FullCollapse;
        Tag := 0;
      end;
      EndUpdate;
    end;
end;

procedure TibBTStatisticsForm.vtStatisticFreeNode(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PStatisticRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    Finalize(Data^);
end;

procedure TibBTStatisticsForm.vtStatisticGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PStatisticRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
//    if (Kind = ikNormal) or (Kind = ikSelected) then
      case Column of
        0: ImageIndex := Data.ImageIndex;
        1: ImageIndex := -1;
      end;
end;

procedure TibBTStatisticsForm.vtStatisticGetNodeDataSize(
  Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TStatisticRec);
end;

procedure TibBTStatisticsForm.vtStatisticDrawNode(
  Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
var
  Data: PStatisticRec;
  X: Integer;
  XX: Double;
//  TW: Integer;
//  TH: Integer;
  S: WideString;
  R: TRect;
  vLegend: string;
  procedure NodeOutText(AText: string);
  begin
    S := AText;
    with Sender as TVirtualDrawTree, PaintInfo do
      if Length(S) > 0 then
      begin
        with R do
        begin
          if (NodeWidth - 2 * Margin) > (Right - Left) then
            S := ShortenString(Canvas.Handle, S, Right - Left, False);
        end;
        DrawTextW(Canvas.Handle, PWideChar(S), Length(S), R, DT_TOP or DT_LEFT or DT_VCENTER or DT_SINGLELINE, False);
      end;
  end;
begin
  with Sender as TVirtualDrawTree, PaintInfo do
  begin

    Data := Sender.GetNodeData(Node);
    if ((Node = FocusedNode) and (Sender as TVirtualDrawTree).Focused) then
      Canvas.Font.Color := clHighlightText
    else
//      if (Data.Attributes and SFGAO_COMPRESSED) <> 0 then
//        Canvas.Font.Color := clBlue
//      else
        Canvas.Font.Color := clWindowText;

    SetBKMode(Canvas.Handle, TRANSPARENT);

    R := ContentRect;
    R.Right := R.Right - 1;
//    InflateRect(R, -TextMargin, 0);
//    Dec(R.Right);
//    Dec(R.Bottom);
    S := '';
    case Column of
      1:
        begin
          Canvas.Brush.Color := clWindow;
          if ((Node = FocusedNode) and (Sender as TVirtualDrawTree).Focused) then
            Canvas.Font.Color := clHighlightText
          else
            Canvas.Font.Color := clWindowText;
          SetBKMode(Canvas.Handle, TRANSPARENT);
          vLegend := EmptyStr;
          if Data.NodeType = ptOperation then
          begin
            case Data.StatisticKind of
              pkIdxReads: vLegend := SIndexedReads;
              pkSeqReads: vLegend := SNonIndexedReads;
              pkUpdates: vLegend := SUpdates;
              pkDeletes: vLegend := SDeletes;
              pkInserts: vLegend := SInserts;
              pkBackoutCount: vLegend := SBackouts;
              pkExpunge: vLegend := SExpunges;
              pkPurge: vLegend := SPurges;
            end;
          end;
          NodeOutText(Data.Value + vLegend);
        end;
      0:
        begin
          case Data.NodeType of
            ptRoot:
              begin
//                Canvas.Font.Style := Canvas.Font.Style + [fsBold];
                Canvas.Brush.Color := clWindow;
                NodeOutText(Data.Text);
//                Canvas.Font.Style := Canvas.Font.Style - [fsBold];
              end;
            ptCommon:
              begin
                Canvas.Brush.Color := clWindow;
                NodeOutText(Data.Text);
              end;
            ptTabelName:
              begin
                Canvas.Brush.Color := clWindow;
                NodeOutText(Data.Text);
              end;
            ptOperation:
              begin
                Canvas.Brush.Style := bsSolid;
                Canvas.Pen.Style := psSolid;
                Canvas.Pen.Color := clBlack;
                case Data.StatisticKind of
                  pkIdxReads: Canvas.Brush.Color := clBlue;
                  pkSeqReads: Canvas.Brush.Color := clRed;
                  pkInserts: Canvas.Brush.Color := clAqua;
                  pkUpdates: Canvas.Brush.Color := clYellow;
                  pkDeletes: Canvas.Brush.Color := clGray;
                end;
                R.Left := R.Left - 1;
                R.Top := R.Top + 1;
                R.Bottom := R.Bottom - 1;
                X := R.Right - R.Left;
                if CurrentMaxValue <> 0 then
                begin
                  XX := Min(0.01 * CurrentMaxValue, 5);
                  XX := Max(XX, Data.IntValue)/CurrentMaxValue;
                  XX := X*XX;
                  X := X - Round(XX);
  //                X := X - Round(X * (Data.IntValue/CurrentMaxValue));
                  R.Right := R.Right - X;
                  if ((R.Right - R.Left) < 1) then
                    R.Right := R.Left + 1;

                  Canvas.FillRect(R);
                  Canvas.Rectangle(R);
                end;

                {
                R := ContentRect;
                TW := Canvas.TextWidth(Data.Value);
                TH := Canvas.TextHeight(Data.Value);
                R.Top :=
                Canvas.TextOut();
                }
              end;
          end;
        end;
    end;
  end;
end;

procedure TibBTStatisticsForm.pmiHideMessageClick(Sender: TObject);
begin
  HideMessages;
end;

end.
