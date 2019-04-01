unit ideSHNavigator;

interface

uses
  Windows, SysUtils, Classes, Controls, Graphics, Types, Forms, ComCtrls, Menus,
  Contnrs, StdCtrls, Buttons, ExtCtrls, ActnList,
  SHDesignIntf, SHOptionsIntf, ideSHDesignIntf;

type
  TideSHNavigator = class;

  TideSHNavBranchController = class
  private
    FOwner: TideSHNavigator;
    FBranchList: TObjectList;
    FButton: TToolButton;
    FMenu: TPopupMenu;
    FItemIndex: Integer;
    procedure SetButton(Value: TToolButton);
    procedure SetItemIndex(Value: Integer);
    function GetStartIndex: Integer;
    procedure SetStartIndex(Value: Integer);
    function GetCurrentBranch: TSHComponent;

    procedure ButtonClick(Sender: TObject);
    procedure MenuPopup(Sender: TObject);
    procedure MenuClick(Sender: TObject);
  protected
    procedure AddBranch(ABranch: TSHComponent);

    property Button: TToolButton read FButton write SetButton;
  public
    constructor Create(AOwner: TideSHNavigator);
    destructor Destroy; override;

    procedure SetBranchMenuItems(AMenuItem: TMenuItem);
    procedure SetBranchByIID(const ABranchIID: TGUID);

    property BranchList: TObjectList read FBranchList;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property StartIndex: Integer read GetStartIndex write SetStartIndex;
    property CurrentBranch: TSHComponent read GetCurrentBranch;
  end;

  TideSHNavGUIController = class
  private
    FOwner: TideSHNavigator;
    FButton: TToolButton;
    FLPanel: TPanel;
    FLSplitter: TSplitter;
    FRPanel: TPanel;
    FRSplitter: TSplitter;
    FLeftSide: Boolean;
    FTopSide: Boolean;
    procedure SetButton(Value: TToolButton);
    procedure SetLPanel(Value: TPanel);
    procedure SetLSplitter(Value: TSplitter);
    procedure SetRPanel(Value: TPanel);
    procedure SetRSplitter(Value: TSplitter);
    function GetLWidth: Integer;
    procedure SetLWidth(Value: Integer);
    function GetRWidth: Integer;
    procedure SetRWidth(Value: Integer);
    procedure SetLeftSide(Value: Boolean);
    procedure SetTopSide(Value: Boolean);
    function GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
  public
    constructor Create(AOwner: TideSHNavigator);
    destructor Destroy; override;

    procedure SetNavigatorPosition(Sender: TObject);
    procedure SetToolboxPosition(Sender: TObject);

    property Button: TToolButton read FButton write SetButton;
    property LPanel: TPanel read FLPanel write SetLPanel;
    property LSplitter: TSplitter read FLSplitter write SetLSplitter;
    property RPanel: TPanel read FRPanel write SetRPanel;
    property RSplitter: TSplitter read FRSplitter write SetRSplitter;
    property LWidth: Integer read GetLWidth write SetLWidth;
    property RWidth: Integer read GetRWidth write SetRWidth;
    property LeftSide: Boolean read FLeftSide write SetLeftSide;
    property TopSide: Boolean read FTopSide write SetTopSide;
    property Visible: Boolean read GetVisible write SetVisible;
  end;

  TideSHNavPageController = class
  private
    FOwner: TideSHNavigator;
    FBranchFormList: TObjectList;
  protected
    procedure AddBranchPage(ABranch: TSHComponent);
    procedure ReloadComponents;
    procedure ShowNecessaryForm;
    function GetNecessaryForm(ABranch: TSHComponent; Index: Integer): TForm;
    function GetNecessaryConnection(ABranch: TSHComponent): IideSHConnection;
    function GetCurrentConnection: IideSHConnection;
  public
    constructor Create(AOwner: TideSHNavigator);
    destructor Destroy; override;

    property BranchFormList: TObjectList read FBranchFormList;
  end;


  TideSHNavigator = class(TComponent, IideSHNavigator)
  private
    FBranchController: TideSHNavBranchController;
    FGUIController: TideSHNavGUIController;
    FPageController: TideSHNavPageController;
    function GetCurrentBranch: TSHComponent;
    function GetCurrentServer: TSHComponent;
    function GetCurrentDatabase: TSHComponent;
    function GetCurrentServerInUse: Boolean;
    function GetCurrentDatabaseInUse: Boolean;
    function GetServerCount: Integer;
    function GetDatabaseCount: Integer;
    function GetCanConnect: Boolean;
    function GetCanReconnect: Boolean;
    function GetCanDisconnect: Boolean;
    function GetCanDisconnectAll: Boolean;
    function GetCanRefresh: Boolean;
    function GetCanMoveUp: Boolean;
    function GetCanMoveDown: Boolean;
    function GetCanShowScheme: Boolean;
    function GetCanShowPalette: Boolean;
    function GetLoadingFromFile: Boolean;
    function GetToolbox: IideSHToolbox;
    function GetOptions: ISHSystemOptions;
    function GetConnectionBranch(AConnection: TSHComponent): TSHComponent;
    procedure SetBranchMenuItems(AMenuItem: TMenuItem);
    procedure SetRegistrationMenuItems(AMenuItem: TMenuItem);
    procedure SetConnectionMenuItems(AMenuItem: TMenuItem);
  protected
    property Options: ISHSystemOptions read GetOptions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { IideSHNavigator }

    function RegisterConnection(AConnection: TSHComponent): Boolean;   // регистрация соединения
    function UnregisterConnection(AConnection: TSHComponent): Boolean; // отрегистрация соединения
    function DestroyConnection(AConnection: TSHComponent): Boolean; // разрушение соединения
    function DisconnectAllConnections: Boolean; // отключить все коннекты

    function ConnectTo(AConnection: TSHComponent): Boolean;
    function ReconnectTo(AConnection: TSHComponent): Boolean;
    function DisconnectFrom(AConnection: TSHComponent): Boolean;
    procedure RefreshConnection(AConnection: TSHComponent);
    procedure ActivateConnection(AConnection: TSHComponent);
    function SynchronizeConnection(AConnection: TSHComponent; const AClassIID: TGUID;
      const ACaption: string; Operation: TOperation): Boolean;

    procedure Connect;
    procedure Reconnect;
    procedure Disconnect;
    function DisconnectAll: Boolean;
    procedure Refresh;

    procedure SaveRegisteredInfoToFile;  // сохранение регинфы в файл
    procedure LoadRegisteredInfoFromFile; // вычитка регинфы из файла

    procedure RecreatePalette;
    procedure RefreshPalette;
    procedure ShowScheme;
    procedure ShowPalette;

    property GUIController: TideSHNavGUIController read FGUIController;
    property BranchController: TideSHNavBranchController read FBranchController;
    property PageController: TideSHNavPageController read FPageController;

    property CurrentBranch: TSHComponent read GetCurrentBranch;
    property CurrentServer: TSHComponent read GetCurrentServer;
    property CurrentDatabase: TSHComponent read GetCurrentDatabase;
    property CurrentServerInUse: Boolean read GetCurrentServerInUse;
    property CurrentDatabaseInUse: Boolean read GetCurrentDatabaseInUse;
    property ServerCount: Integer read GetServerCount;
    property DatabaseCount: Integer read GetDatabaseCount;
    property CanConnect: Boolean read GetCanConnect;
    property CanReconnect: Boolean read GetCanReconnect;
    property CanDisconnect: Boolean read GetCanDisconnect;
    property CanDisconnectAll: Boolean read GetCanDisconnectAll;
    property CanRefresh: Boolean read GetCanRefresh;
    property CanMoveUp: Boolean read GetCanMoveUp;
    property CanMoveDown: Boolean read GetCanMoveDown;
    property LoadingFromFile: Boolean read GetLoadingFromFile;
  end;

implementation

uses
  ideSHConsts, ideSHSystem, ideSHSysUtils,
  ideSHBaseDialogFrm,
  ideSHToolboxFrm,
  ideSHComponentPageFrm,
  ideSHConnectionPageFrm,
  ideSHConnectionObjectsPageFrm;


{ TideSHNavBranchController }

constructor TideSHNavBranchController.Create(AOwner: TideSHNavigator);
begin
  FOwner := AOwner;
  inherited Create;
  FBranchList := TObjectList.Create(False);
  FMenu := TPopupMenu.Create(nil);
  FMenu.AutoHotkeys := maManual;
  FMenu.Images := DesignerIntf.ImageList;
  FMenu.OnPopup := MenuPopup;
  FItemIndex := -1;
end;

destructor TideSHNavBranchController.Destroy;
begin
  FBranchList.Free;
  while FMenu.Items.Count > 0 do FMenu.Items.Delete(0);
  FMenu.Free;

  inherited Destroy;
end;

procedure TideSHNavBranchController.SetBranchMenuItems(AMenuItem: TMenuItem);
var
  I: Integer;
  Branch: TSHComponent;
  NewItem: TMenuItem;
begin
  AMenuItem.Insert(0, NewLine);
  for I := 0 to Pred(BranchList.Count) do
  begin
    Branch := TSHComponent(BranchList[I]);

    NewItem := TMenuItem.Create(nil);
    NewItem.Caption := Branch.CaptionExt;
    NewItem.ImageIndex := DesignerIntf.GetImageIndex(Branch.ClassIID);
    NewItem.Default := ItemIndex = I;
    NewItem.Tag := I;
    NewItem.OnClick := MenuClick;

    AMenuItem.Add(NewItem);
  end;
end;

procedure TideSHNavBranchController.SetBranchByIID(const ABranchIID: TGUID);
var
  I, J: Integer;
begin
  J := -1;
  for I := 0 to Pred(BranchList.Count) do
    if IsEqualGUID(TSHComponent(BranchList[I]).BranchIID, ABranchIID) then
    begin
      J := I;
      Break;
    end;

  if I <> -1 then
  begin
    ItemIndex := J;
    StartIndex := ItemIndex;
  end;
end;

procedure TideSHNavBranchController.SetButton(Value: TToolButton);
begin
  if FButton <> Value then
  begin
    FButton := Value;

    FButton.DropdownMenu := FMenu;
    FButton.Style := tbsDropDown;
    FButton.ImageIndex := 0;
    FButton.ShowHint := True;
    FButton.OnClick := ButtonClick;
  end;
end;

procedure TideSHNavBranchController.SetItemIndex(Value: Integer);
begin
  if (Value >= 0) and (Value <= Pred(BranchList.Count)) then
    if FItemIndex <> Value then
    begin
      FItemIndex := Value;
      if FItemIndex = -1 then
      begin
        Button.Enabled := False;
        Button.ImageIndex := 0;
        Button.Hint := Format('%s: %s', ['Current Branch', SNothingSelected]);
      end else
      begin
        Button.Enabled := True;
        Button.ImageIndex := DesignerIntf.GetImageIndex(TSHComponent(BranchList[ItemIndex]).ClassIID);
        Button.Hint := Format('%s: %s', ['Current Branch', TSHComponent(BranchList[ItemIndex]).CaptionExt]);
      end;
      FOwner.PageController.ShowNecessaryForm;
      Button.Invalidate;
    end;
end;

function TideSHNavBranchController.GetStartIndex: Integer;
begin
  Result := FOwner.Options.StartBranch;
end;

procedure TideSHNavBranchController.SetStartIndex(Value: Integer);
begin
  FOwner.Options.StartBranch := Value;
end;

function TideSHNavBranchController.GetCurrentBranch: TSHComponent;
begin
  Result := nil;
  if (ItemIndex >= 0) and (ItemIndex <= Pred(BranchList.Count)) then
    Result := TSHComponent(BranchList[ItemIndex]);
end;

procedure TideSHNavBranchController.ButtonClick(Sender: TObject);
begin
  if (Sender is TToolButton) then TToolButton(Sender).CheckMenuDropdown;
end;

procedure TideSHNavBranchController.MenuPopup(Sender: TObject);
var
  I: Integer;
  Branch: TSHComponent;
  NewItem: TMenuItem;
begin
  while FMenu.Items.Count > 0 do FMenu.Items.Delete(0);

  for I := 0 to Pred(BranchList.Count) do
  begin
    Branch := TSHComponent(BranchList[I]);

    NewItem := TMenuItem.Create(nil);
    NewItem.Caption := Branch.CaptionExt;
    NewItem.ImageIndex := DesignerIntf.GetImageIndex(Branch.ClassIID);
    NewItem.Default := ItemIndex = I;
    NewItem.Tag := I;
    NewItem.OnClick := MenuClick;

    FMenu.Items.Add(NewItem);
  end;
end;

procedure TideSHNavBranchController.MenuClick(Sender: TObject);
begin
  if (Sender is TMenuItem) and (ItemIndex <> TMenuItem(Sender).Tag) then
  begin
    ItemIndex := TMenuItem(Sender).Tag;
    StartIndex := ItemIndex;
  end;
end;

procedure TideSHNavBranchController.AddBranch(ABranch: TSHComponent);
begin
  if BranchList.IndexOf(ABranch) = -1 then
  begin
    ItemIndex := BranchList.Add(ABranch);
    FOwner.PageController.AddBranchPage(ABranch);
  end;
end;

{ TideSHNavGUIController }

constructor TideSHNavGUIController.Create(AOwner: TideSHNavigator);
begin
  FOwner := AOwner;
  inherited Create;
end;

destructor TideSHNavGUIController.Destroy;
begin
  inherited Destroy;
end;

procedure TideSHNavGUIController.SetButton(Value: TToolButton);
begin
  FButton := Value;
  FOwner.BranchController.Button := FButton;
end;

procedure TideSHNavGUIController.SetLPanel(Value: TPanel);
begin
  FLPanel := Value;
  if Assigned(FLPanel) then FLPanel.Caption := EmptyStr;
end;

procedure TideSHNavGUIController.SetLSplitter(Value: TSplitter);
begin
  FLSplitter := Value;
end;

procedure TideSHNavGUIController.SetRPanel(Value: TPanel);
begin
  FRPanel := Value;
  if Assigned(FRPanel) then FRPanel.Caption := EmptyStr;
end;

procedure TideSHNavGUIController.SetRSplitter(Value: TSplitter);
begin
  FRSplitter := Value;
end;

function TideSHNavGUIController.GetLWidth: Integer;
begin
  Result := LPanel.Width;
end;

procedure TideSHNavGUIController.SetLWidth(Value: Integer);
begin
  LPanel.Width := Value;
end;

function TideSHNavGUIController.GetRWidth: Integer;
begin
  Result := RPanel.Width;
end;

procedure TideSHNavGUIController.SetRWidth(Value: Integer);
begin
  RPanel.Width := Value;
end;

procedure TideSHNavGUIController.SetLeftSide(Value: Boolean);
var
  I: Integer;
begin
  FLeftSide := Value;
  for I := 0 to Pred(FOwner.PageController.BranchFormList.Count) do
  begin
    if FLeftSide then
    begin
      case TSHComponentForm(FOwner.PageController.BranchFormList[I]).Tag of
        0: TSHComponentForm(FOwner.PageController.BranchFormList[I]).Parent := LPanel;
        1: TSHComponentForm(FOwner.PageController.BranchFormList[I]).Parent := RPanel;
      end;
    end else
    begin
      case TSHComponentForm(FOwner.PageController.BranchFormList[I]).Tag of
        0: TSHComponentForm(FOwner.PageController.BranchFormList[I]).Parent := RPanel;
        1: TSHComponentForm(FOwner.PageController.BranchFormList[I]).Parent := LPanel;
      end;
    end;
  end;

{
  if Value then
  begin
    LPanel.Align := alLeft;
    LSplitter.Align := alLeft;
  end else
  begin
    LPanel.Align := alRight;
    LSplitter.Align := alRight;
  end;
}
  if Assigned(SystemOptionsIntf) then SystemOptionsIntf.NavigatorLeft := Value;
end;

procedure TideSHNavGUIController.SetTopSide(Value: Boolean);
var
  I: Integer;
begin
  FTopSide := Value;
  for I := 0 to Pred(FOwner.PageController.BranchFormList.Count) do
    case TSHComponentForm(FOwner.PageController.BranchFormList[I]).Tag of
      1: TToolboxForm(FOwner.PageController.BranchFormList[I]).SetToolboxPosition(FTopSide);
    end;
  if Assigned(SystemOptionsIntf) then SystemOptionsIntf.ToolboxTop := Value;
end;

function TideSHNavGUIController.GetVisible: Boolean;
begin
  Result := LPanel.Visible;
end;

procedure TideSHNavGUIController.SetVisible(Value: Boolean);
begin
  if Value then
  begin
    LSplitter.Visible := not Value;
    LPanel.Visible := not Value;

    RPanel.Visible := not Value;
    RSplitter.Visible := not Value;    
  end else
  begin
    LPanel.Visible := not Value;
    LSplitter.Visible := not Value;

    RPanel.Visible := not Value;
    RSplitter.Visible := not Value;
    RPanel.Left := RSplitter.Left + 100;
  end;
end;

procedure TideSHNavGUIController.SetNavigatorPosition(Sender: TObject);
begin
  LeftSide := not LeftSide;
end;

procedure TideSHNavGUIController.SetToolboxPosition(Sender: TObject);
begin
  TopSide := not TopSide;
end;

{ TideSHNavPageController }

constructor TideSHNavPageController.Create(AOwner: TideSHNavigator);
begin
  FOwner := AOwner;
  inherited Create;
  FBranchFormList := TObjectList.Create;
end;

destructor TideSHNavPageController.Destroy;
begin
  FBranchFormList.Free;
  inherited Destroy;
end;

procedure TideSHNavPageController.AddBranchPage(ABranch: TSHComponent);
begin
  // регистратор + навигатор
  BranchFormList.Add(
    TConnectionPageForm.Create(FOwner.GUIController.LPanel,
                               FOwner.GUIController.LPanel,
                               ABranch,
                               EmptyStr));
  TForm(BranchFormList.Last).Tag  := 0;

  // палитра
  BranchFormList.Add(
    TToolboxForm.Create(FOwner.GUIController.RPanel,
                              FOwner.GUIController.RPanel,
                              ABranch,
                              EmptyStr));
  TForm(BranchFormList.Last).Tag  := 1;

  ShowNecessaryForm;
end;

procedure TideSHNavPageController.ReloadComponents;
var
  I: Integer;
begin
  for I := 0 to Pred(BranchFormList.Count) do
    if BranchFormList[I] is TToolboxForm then
      TToolboxForm(BranchFormList[I]).ReloadComponents;
end;

procedure TideSHNavPageController.ShowNecessaryForm;
var
  I: Integer;
begin
  for I := 0 to Pred(BranchFormList.Count) do
    if (TSHComponentForm(BranchFormList[I]).Component = FOwner.BranchController.CurrentBranch) {and
       (TSHComponentForm(BranchFormList[I]).Tag = FOwner.GUIController.PageControl.ActivePageIndex)} then
  begin
    TSHComponentForm(BranchFormList[I]).Show;
    TSHComponentForm(BranchFormList[I]).BringToTop;
  end;
end;

function TideSHNavPageController.GetNecessaryForm(ABranch: TSHComponent; Index: Integer): TForm;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(BranchFormList.Count) do
    if (TSHComponentForm(BranchFormList[I]).Component = ABranch) and
       (TSHComponentForm(BranchFormList[I]).Tag = Index) then
    begin
      Result := TForm(BranchFormList[I]);
      Exit
    end
end;

function TideSHNavPageController.GetNecessaryConnection(ABranch: TSHComponent): IideSHConnection;
var
  I: Integer;
begin
  for I := 0 to Pred(BranchFormList.Count) do
    if (TSHComponentForm(BranchFormList[I]).Component = ABranch) and
       (TSHComponentForm(BranchFormList[I]).Tag = 0) then
    begin
         Supports(BranchFormList[I], IideSHConnection, Result);
         if Assigned(Result) then
          Exit;
    end
end;

function TideSHNavPageController.GetCurrentConnection: IideSHConnection;
var
  I: Integer;
begin
  for I := 0 to Pred(BranchFormList.Count) do
    if (TSHComponentForm(BranchFormList[I]).Component = FOwner.BranchController.CurrentBranch) and
       (TSHComponentForm(BranchFormList[I]).Tag = 0) then
         Supports(BranchFormList[I], IideSHConnection, Result);
end;

{ TideSHNavigator }

constructor TideSHNavigator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBranchController := TideSHNavBranchController.Create(Self);
  FGUIController := TideSHNavGUIController.Create(Self);
  FPageController := TideSHNavPageController.Create(Self);
  Supports(Self, IideSHNavigator, NavigatorIntf);
end;

destructor TideSHNavigator.Destroy;
begin
  NavigatorIntf := nil;
  FBranchController.Free;
  FGUIController.Free;
  FPageController.Free;
  inherited Destroy;
end;

function TideSHNavigator.GetCurrentBranch: TSHComponent;
begin
  Result := BranchController.CurrentBranch;
end;

function TideSHNavigator.GetCurrentServer: TSHComponent;
begin
  Result := nil;
  if Assigned(BranchController.CurrentBranch) then
    Result := PageController.GetCurrentConnection.CurrentServer;
end;

function TideSHNavigator.GetCurrentDatabase: TSHComponent;
begin
  Result := nil;
  if Assigned(BranchController.CurrentBranch) then
    Result := PageController.GetCurrentConnection.CurrentDatabase;
end;

function TideSHNavigator.GetCurrentServerInUse: Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetCurrentConnection.CurrentServerInUse;
end;

function TideSHNavigator.GetCurrentDatabaseInUse: Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetCurrentConnection.CurrentDatabaseInUse;
end;

function TideSHNavigator.GetServerCount: Integer;
begin
  Result := 0;
  if Assigned(BranchController.CurrentBranch) then
    Result := PageController.GetCurrentConnection.ServerCount;
end;

function TideSHNavigator.GetDatabaseCount: Integer;
begin
  Result := 0;
  if Assigned(BranchController.CurrentBranch) then
    Result := PageController.GetCurrentConnection.DatabaseCount;
end;

function TideSHNavigator.GetCanConnect: Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetCurrentConnection.CanConnect;
end;

function TideSHNavigator.GetCanReconnect: Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetCurrentConnection.CanReconnect;
end;

function TideSHNavigator.GetCanDisconnect: Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetCurrentConnection.CanDisconnect;
end;

function TideSHNavigator.GetCanDisconnectAll: Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetCurrentConnection.CanDisconnectAll;
end;

function TideSHNavigator.GetCanRefresh: Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetCurrentConnection.CanRefresh;
end;

function TideSHNavigator.GetCanMoveUp: Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetCurrentConnection.CanMoveUp;
end;

function TideSHNavigator.GetCanMoveDown: Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetCurrentConnection.CanMoveDown;
end;

function TideSHNavigator.GetCanShowScheme: Boolean;
begin
  Result := Assigned(CurrentDatabase) and (CurrentDatabase as ISHRegistration).Connected;
end;

function TideSHNavigator.GetCanShowPalette: Boolean;
begin
  Result := Assigned(CurrentServer);
end;

function TideSHNavigator.GetLoadingFromFile: Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetCurrentConnection.LoadingFromFile;
end;

function TideSHNavigator.GetToolbox: IideSHToolbox;
begin
  Supports(PageController.GetNecessaryForm(BranchController.CurrentBranch, 1), IideSHToolbox, Result);
end;

function TideSHNavigator.GetOptions: ISHSystemOptions;
begin
  Result := SystemOptionsIntf;
end;

function TideSHNavigator.GetConnectionBranch(AConnection: TSHComponent): TSHComponent;
begin
  Result := nil;
  if Assigned(AConnection) then
    Result := DesignerIntf.FindComponent(IUnknown, AConnection.BranchIID);
end;

procedure TideSHNavigator.SetBranchMenuItems(AMenuItem: TMenuItem);
begin
  BranchController.SetBranchMenuItems(AMenuItem);
end;

procedure TideSHNavigator.SetRegistrationMenuItems(AMenuItem: TMenuItem);
begin
  if Assigned(BranchController.CurrentBranch) and
     Assigned(PageController.GetNecessaryConnection(BranchController.CurrentBranch)) then
    PageController.GetNecessaryConnection(BranchController.CurrentBranch).SetRegistrationMenuItems(AMenuItem);
end;

procedure TideSHNavigator.SetConnectionMenuItems(AMenuItem: TMenuItem);
begin
  if Assigned(BranchController.CurrentBranch) and
     Assigned(PageController.GetNecessaryConnection(BranchController.CurrentBranch)) then
  PageController.GetNecessaryConnection(BranchController.CurrentBranch).SetConnectionMenuItems(AMenuItem);
end;

function TideSHNavigator.RegisterConnection(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetNecessaryConnection(GetConnectionBranch(AConnection)).RegisterConnection(AConnection);
end;

function TideSHNavigator.UnregisterConnection(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetNecessaryConnection(GetConnectionBranch(AConnection)).UnregisterConnection(AConnection);
end;

function TideSHNavigator.DestroyConnection(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetNecessaryConnection(GetConnectionBranch(AConnection)).DestroyConnection(AConnection);
end;

function TideSHNavigator.DisconnectAllConnections: Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to Pred(BranchController.BranchList.Count) do
  begin
    Result := PageController.GetNecessaryConnection(TSHComponent(BranchController.BranchList[I])).DisconnectAll;
    Application.ProcessMessages;
    if not Result then Break;
  end;
end;

function TideSHNavigator.ConnectTo(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetNecessaryConnection(GetConnectionBranch(AConnection)).ConnectTo(AConnection);
end;

function TideSHNavigator.ReconnectTo(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetNecessaryConnection(GetConnectionBranch(AConnection)).ReconnectTo(AConnection);
end;

function TideSHNavigator.DisconnectFrom(AConnection: TSHComponent): Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetNecessaryConnection(GetConnectionBranch(AConnection)).DisconnectFrom(AConnection);
end;

procedure TideSHNavigator.RefreshConnection(AConnection: TSHComponent);
begin
  if Assigned(BranchController.CurrentBranch) then
    PageController.GetNecessaryConnection(GetConnectionBranch(AConnection)).RefreshConnection(AConnection);
end;

procedure TideSHNavigator.ActivateConnection(AConnection: TSHComponent);
begin
  if Assigned(BranchController.CurrentBranch) then
  begin
    BranchController.SetBranchByIID(AConnection.BranchIID);
    if (AConnection as ISHRegistration).Connected then
      PageController.GetNecessaryConnection(GetConnectionBranch(AConnection)).ActivateConnection(AConnection);
  end;
end;

function TideSHNavigator.SynchronizeConnection(AConnection: TSHComponent; const AClassIID: TGUID;
  const ACaption: string; Operation: TOperation): Boolean;
begin
  Result := Assigned(BranchController.CurrentBranch) and
    PageController.GetNecessaryConnection(GetConnectionBranch(AConnection)).SynchronizeConnection(AConnection, AClassIID, ACaption, Operation);
  if Result and (Operation = opRemove) then
    ObjectEditorIntf.JumpRemove(AConnection.InstanceIID, AClassIID, ACaption);  
end;

procedure TideSHNavigator.Connect;
begin
  PageController.GetCurrentConnection.Connect;
end;

procedure TideSHNavigator.Reconnect;
begin
  PageController.GetCurrentConnection.Reconnect;
end;

procedure TideSHNavigator.Disconnect;
begin
  PageController.GetCurrentConnection.Disconnect;
end;

function TideSHNavigator.DisconnectAll: Boolean;
begin
 Result := PageController.GetCurrentConnection.DisconnectAll;
end;

procedure TideSHNavigator.Refresh;
begin
  PageController.GetCurrentConnection.Refresh;
end;

procedure TideSHNavigator.SaveRegisteredInfoToFile;
var
  I: Integer;
begin
  for I := 0 to Pred(BranchController.BranchList.Count) do
    PageController.GetNecessaryConnection(TSHComponent(BranchController.BranchList[I])).SaveToFile;
end;

procedure TideSHNavigator.LoadRegisteredInfoFromFile;
var
  I: Integer;
begin
  for I := 0 to Pred(BranchController.BranchList.Count) do
    PageController.GetNecessaryConnection(TSHComponent(BranchController.BranchList[I])).LoadFromFile;
end;

procedure TideSHNavigator.RecreatePalette;
var
  I: Integer;
begin
  for I := 0 to Pred(RegistryIntf.GetRegBranchList.Count) do
    BranchController.AddBranch(TSHComponent(RegistryIntf.GetRegBranchList[I]));

  PageController.ReloadComponents;
  BranchController.ItemIndex := Options.StartBranch;
end;

procedure TideSHNavigator.RefreshPalette;
var
  I: Integer;
begin
  for I := 0 to Pred(PageController.BranchFormList.Count) do
    if PageController.BranchFormList[I] is TToolboxForm then
      TToolboxForm(PageController.BranchFormList[I]).InvalidateComponents;
end;

procedure TideSHNavigator.ShowScheme;
var
  DialogForm: TBaseDialogForm;
begin
  DialogForm := TBaseDialogForm.Create(Application);
  try
    DialogForm.ComponentForm := TConnectionObjectsPageForm.Create(DialogForm, DialogForm.pnlClient, CurrentDatabase, '%s\Scheme Objects');
    DialogForm.ShowModal;
    if Assigned(DialogForm.OnAfterModalClose) then
      DialogForm.OnAfterModalClose(DialogForm, DialogForm.ModalResult);
  finally
    FreeAndNil(DialogForm);
  end;
end;

procedure TideSHNavigator.ShowPalette;
var
  DialogForm: TBaseDialogForm;
begin
  DialogForm := TBaseDialogForm.Create(Application);
  try
    DialogForm.ComponentForm := TComponentPageForm.Create(DialogForm, DialogForm.pnlClient, CurrentBranch, '%s\Component List ');
    (DialogForm.ComponentForm as TComponentPageForm).ReloadComponents;
    DialogForm.ShowModal;
    if Assigned(DialogForm.OnAfterModalClose) then
      DialogForm.OnAfterModalClose(DialogForm, DialogForm.ModalResult);    
  finally
    FreeAndNil(DialogForm);
  end;
end;

end.



