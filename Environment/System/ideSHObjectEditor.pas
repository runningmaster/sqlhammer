unit ideSHObjectEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, ComCtrls, CommCtrl,
  ExtCtrls, Types, Menus, Contnrs, Forms, StdCtrls, ToolWin, ActnList,
  SHDesignIntf, SHEvents, ideSHDesignIntf, ideSHObject,Dialogs;

type
  TideSHObjectEditor = class;

  TideSHJumpDescr = class
  private
    FFromOwnerIID: TGUID;
    FFromClassIID: TGUID;
    FFromCaption: string;
    FFromCaptionExt: string;
    FToOwnerIID: TGUID;
    FToClassIID: TGUID;
    FToCaption: string;
    FToCaptionExt: string;
  public
    property FromOwnerIID: TGUID read FFromOwnerIID write FFromOwnerIID;
    property FromClassIID: TGUID read FFromClassIID write FFromClassIID;
    property FromCaption: string read FFromCaption write FFromCaption;
    property FromCaptionExt: string read FFromCaptionExt write FFromCaptionExt;
    property ToOwnerIID: TGUID read FToOwnerIID write FToOwnerIID;
    property ToClassIID: TGUID read FToClassIID write FToClassIID;
    property ToCaption: string read FToCaption write FToCaption;
    property ToCaptionExt: string read FToCaptionExt write FToCaptionExt;
  end;

  TideSHComponentFrame = class;
  
  TideSHButtonFrame = class(TToolbar)
  private
    FComponentFrame: TideSHComponentFrame;
    FComponent: TSHComponent;
    FDropdownMenu: TPopupMenu;
    procedure SetComponent(Value: TSHComponent);
    procedure DropdownPopup(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function LoadActions(AClassIID: TGUID; ACallType: TSHActionCallType): Boolean;
    procedure UpdateToolbarActions;

    property ComponentFrame: TideSHComponentFrame read FComponentFrame write FComponentFrame;
    property Component: TSHComponent read FComponent write SetComponent;
    property DropdownMenu: TPopupMenu read FDropdownMenu;
  end;

  TideSHComponentFrame = class(TTabSheet)
  private
    FObjectEditor: TideSHObjectEditor;
    FButtonFrame: TideSHButtonFrame;
    FStartPage: Integer;
    FParentPanel: TPanel;
    FComponent: TSHComponent;
    FFormList: TObjectList;
    FCallStrings: TStrings;
    FCurrentForm: TSHComponentForm;
    FPageCtrl: TPageControl;
    FPageCtrlWndProc: TWndMethod;
    FLabelText: TLabel;
    FToolBar  :TToolBar;
    procedure PageCtrlWndProc(var Message: TMessage);
    procedure DoOnPageDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure DoOnPageDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure DoOnPageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CreateLevel1Page(AOwner: TComponent);
    function CreateLevel2Page(const CallString: string): Integer;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; AComponent: TSHComponent;
      ACallString: string; AObjectEditor: TideSHObjectEditor); reintroduce; overload;
    destructor Destroy; override;

    function IndexOf(const CallString: string): Integer;
    function Exists(const CallString: string): Boolean;
    function Add(const CallString: string): Boolean;
    function Remove(const CallString: string): Boolean;
    function CanDestroy(const CallString: string): Boolean;

    property ObjectEditor: TideSHObjectEditor read FObjectEditor;
    property ButtonFrame: TideSHButtonFrame read FButtonFrame;
    property ParentPanel: TPanel read FParentPanel;
    property Component: TSHComponent read FComponent;
    property FormList: TObjectList read FFormList;
    property CallStrings: TStrings read FCallStrings;
    property CurrentForm: TSHComponentForm read FCurrentForm write FCurrentForm;
    property PageCtrl: TPageControl read FPageCtrl;
    property LabelText: TLabel read FLabelText;
  end;

  TideSHFilterManager = class
  end;

  { TideSHObjectEditor }

  TideSHObjectEditor = class(TideBTObject, IideSHObjectEditor)
  private
    FStartPage: Integer;
    FMultiLine: Boolean;
    FFilterMode: Boolean;
    FJumpList: TObjectList;
    FCanUpdateToolbarActions: Boolean;
    function GetMultiLine: Boolean;
    procedure SetMultiLine(Value: Boolean);
    function GetFilterMode: Boolean;
    procedure SetFilterMode(Value: Boolean);
    function GetCurrentComponentForm: TSHComponentForm;
    function GetCurrentCallString: string;
    function GetCallStringCount: Integer;

    procedure CreateEditor;
    procedure ChangeEditor;
    procedure CreateComponentFrame(AOwner: TComponent;
      AComponent: TSHComponent; ACallString: string);

    function GetComponent(Index: Integer): TSHComponent;
    function GetCallStrings(Index: Integer): TStrings;
    procedure GetCaptionList(APopupMenu: TPopupMenu); overload;
    procedure GetCaptionList(AMenuItem: TMenuItem); overload;
    procedure GetBackList(APopupMenu: TPopupMenu);
    procedure GetForwardList(APopupMenu: TPopupMenu);
    function GetCanBrowseBack(AComponent: TSHComponent): Boolean;
    function GetCanBrowseForward(AComponent: TSHComponent): Boolean;
    procedure Jump(AFromComponent, AToComponent: TSHComponent);
    procedure JumpRemove(const AOwnerIID, AClassIID: TGUID; const ACaption: string);
    procedure BrowseBack;
    procedure BrowseForward;
    procedure BrowseNext;
    procedure BrowsePrevious;

    procedure DoOnClikCaptionItem(Sender: TObject);
    procedure DoOnClikBackItem(Sender: TObject);
    procedure DoOnClikForwardItem(Sender: TObject);

    procedure DoOnPageDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure DoOnPageDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure DoOnPageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DoOnDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
  protected
    function GetCurrentComponent: TSHComponent; override;

    function Exists(AComponent: TSHComponent): Boolean;  overload; override;
    function Add(AComponent: TSHComponent): Boolean; overload; override;
    function Remove(AComponent: TSHComponent): Boolean;  overload; override;

    function CanUpdateToolbarActions: Boolean;
    procedure UpdateToolbarActions;

    function IndexOf(AComponent: TSHComponent; const CallString: string): Integer;
    function Exists(AComponent: TSHComponent; const CallString: string): Boolean;  overload;
    function Add(AComponent: TSHComponent; const CallString: string): Boolean; overload;
    function Remove(AComponent: TSHComponent; const CallString: string): Boolean;  overload;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    property CurrentForm: TSHComponentForm read GetCurrentComponentForm;
  end;

implementation

uses
  ideSHMainFrm, ideSHConsts, ideSHSystem, ideSHSysUtils;

{ TideSHButtonFrame }

constructor TideSHButtonFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := AOwner as TWinControl;
  EdgeBorders := [];
  Images := MainForm.ImageList1;
  Flat := True;
  AutoSize := True;
  Wrapable := False;
  Align := alLeft;

  // Construct DropdownMenu
  FDropdownMenu := TPopupMenu.Create(nil);
  with FDropdownMenu do
  begin
    AutoHotkeys := maManual;
    Images := DesignerIntf.ImageList;
    OnPopup := DropdownPopup;
  end;
end;

destructor TideSHButtonFrame.Destroy;
begin
  while FDropdownMenu.Items.Count > 0 do FDropdownMenu.Items.Delete(0);
  FDropdownMenu.Free;
  inherited Destroy;
end;

procedure TideSHButtonFrame.SetComponent(Value: TSHComponent);
//var
//  NewItem: TMenuItem;
begin
  FComponent := Value;
  if Assigned(FComponent) then
  begin
//    NewItem := TMenuItem.Create(Self);
//    NewItem.Caption := Format('%s',['=== Registered Forms ===']);
//    DropdownMenu.Items.Add(NewItem);

    if not LoadActions(FComponent.ClassIID, actCallForm) then
    begin
//      NewItem := TMenuItem.Create(Self);
//      NewItem.Caption := Format('%s',['< No Forms >']);
//      DropdownMenu.Items.Add(NewItem);
    end;

    DropdownMenu.Items.Add(NewLine);

//    NewItem := TMenuItem.Create(Self);
//    NewItem.Caption := Format('%s',['=== Registered Editors ===']);
//    DropdownMenu.Items.Add(NewItem);

    if not LoadActions(FComponent.ClassIID, actCallEditor) then
    begin
//      NewItem := TMenuItem.Create(Self);
//      NewItem.Caption := Format('%s',['< No Editors >']);
//      DropdownMenu.Items.Add(NewItem);
    end;

    LoadActions(FComponent.ClassIID, actCallToolbar);

  end;
end;

procedure TideSHButtonFrame.DropdownPopup(Sender: TObject);
var
 I: Integer;
begin
  with Sender as TPopupMenu do
  begin
    for I := 0 to Pred(Items.Count) do
      if Assigned(Items[I].Action) then
      begin
        Items[I].Action.Update;
        Items[I].Default := TSHAction(Items[I].Action).Default;
      end;
  end;
end;

procedure TideSHButtonFrame.ButtonClick(Sender: TObject);
begin
  if (Sender is TToolButton) then TToolButton(Sender).CheckMenuDropdown;
end;

function TideSHButtonFrame.LoadActions(AClassIID: TGUID; ACallType: TSHActionCallType): Boolean;
var
  I: Integer;
  NewItem: TMenuItem;
begin
  Result := False;

  if (ACallType = actCallForm) or (ACallType = actCallEditor) then
  begin
//    if Assigned(NavigatorIntf) and Assigned(NavigatorIntf.Toolbox) then
//      NavigatorIntf.Toolbox._InspAddAction(nil);

    for I := 0 to Pred(DesignerIntf.ActionList.ActionCount) do
      if Supports(DesignerIntf.ActionList.Actions[I], ISHAction) and
         ((DesignerIntf.ActionList.Actions[I] as ISHAction).CallType = ACallType) and
         (DesignerIntf.ActionList.Actions[I] as ISHAction).SupportComponent(AClassIID) then
    begin
      DesignerIntf.ActionList.Actions[I].Update;
      if ACallType = actCallEditor then TAction(DesignerIntf.ActionList.Actions[I]).ImageIndex := IMG_COMPONENT_EDITOR;

      NewItem := TMenuItem.Create(Self);
      NewItem.Action := DesignerIntf.ActionList.Actions[I];
      NewItem.Default := (DesignerIntf.ActionList.Actions[I] as ISHAction).Default;
      DropdownMenu.Items.Add(NewItem);
      Result := True;

      if Assigned(NavigatorIntf) and Assigned(NavigatorIntf.Toolbox) then
        NavigatorIntf.Toolbox._InspAddAction(TSHAction(DesignerIntf.ActionList.Actions[I]));
    end;
  end;

  if (ACallType = actCallToolbar) then
  begin
    // Обратный проход из-за пиздоватизма нативного TToolBar
    for I := Pred(DesignerIntf.ActionList.ActionCount) downto 0 do
      if Supports(DesignerIntf.ActionList.Actions[I], ISHAction) and
         ((DesignerIntf.ActionList.Actions[I] as ISHAction).CallType = ACallType) and
         (DesignerIntf.ActionList.Actions[I] as ISHAction).SupportComponent(AClassIID) then
    begin
      DesignerIntf.ActionList.Actions[I].Update;

      with TToolButton.Create(Self) do
      begin
        Parent := Self;
        if TAction(DesignerIntf.ActionList.Actions[I]).Caption = '-' then
        begin
          Style := tbsSeparator;
          Width := 8;
        end;
        Action := DesignerIntf.ActionList.Actions[I];
        ShowHint := True;
      end;
      Result := True;
    end;

    // Construct Object Inspector Button and Separator
{
    with TToolButton.Create(Self) do
    begin
      Parent := Self;
      Width := 23;
      Enabled := False;
    end;
}
    with TToolButton.Create(Self) do
    begin
      Parent := Self;
      Style := tbsSeparator;
      Width := 8;
    end;

    with TToolButton.Create(Self) do
    begin
      Parent := Self;
      DropdownMenu := FDropdownMenu;
      Style := tbsDropDown;
      ImageIndex := 26;
      Hint := Format('%s', ['Registered Forms and Editors']);
      ShowHint := True;
      Width := 23;
      OnClick := ButtonClick;
    end;
  end;
end;

procedure TideSHButtonFrame.UpdateToolbarActions;
var
  I: Integer;
  SHAction: ISHAction;
begin
  for I := 0 to Pred(DesignerIntf.ActionList.ActionCount) do
    if Supports(DesignerIntf.ActionList.Actions[I], ISHAction, SHAction) and
      ((SHAction.CallType = actCallForm) or (SHAction.CallType = actCallEditor) or
       (SHAction.CallType = actCallToolbar)) then
       SHAction.DisableShortCut;

  for I := 0 to Pred(ButtonCount) do
    if Assigned(Buttons[I].Action) and Supports(Buttons[I].Action, ISHAction, SHAction) then
    begin
      Buttons[I].Action.Update;
      SHAction.EnableShortCut;      
    end;

  Application.ProcessMessages;
  if Assigned(NavigatorIntf) and Assigned(NavigatorIntf.Toolbox) then
    NavigatorIntf.Toolbox._InspUpdateNodes;
end;

{ TideSHComponentFrame }

constructor TideSHComponentFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

constructor TideSHComponentFrame.Create(AOwner: TComponent;
  AComponent: TSHComponent; ACallString: string; AObjectEditor: TideSHObjectEditor);
begin
  FObjectEditor := AObjectEditor;
  FComponent := AComponent;
  FFormList := TObjectList.Create;
  FCallStrings := TStringList.Create;
  inherited Create(AOwner);

  // Construct Inspector
  if Assigned(NavigatorIntf) and Assigned(NavigatorIntf.Toolbox) then
  begin
    NavigatorIntf.Toolbox._InspCreateForm(FComponent);
    NavigatorIntf.Toolbox._InspShowForm(FComponent);
  end;
  // Construct Page
  CreateLevel1Page(AOwner);
  Add(ACallString);
end;

destructor TideSHComponentFrame.Destroy;
begin
  if Assigned(NavigatorIntf) and Assigned(NavigatorIntf.Toolbox) then
  begin
    NavigatorIntf.Toolbox._InspHideForm(FComponent);
    NavigatorIntf.Toolbox._InspDestroyForm(FComponent);
  end;
  FObjectEditor := nil;
  FComponent := nil;
  FFormList.Free;
  FCallStrings.Free;
  inherited Destroy;
end;

procedure TideSHComponentFrame.PageCtrlWndProc(var Message: TMessage);
begin
  with Message do
    if Msg = TCM_ADJUSTRECT then
    begin
      FPageCtrlWndProc(Message);
      PRect(LParam)^.Left := 0;
      PRect(LParam)^.Right := FPageCtrl.Parent.ClientWidth;
      PRect(LParam)^.Top := PRect(LParam)^.Top - 3;
      PRect(LParam)^.Bottom := FPageCtrl.Parent.ClientHeight;
    end else
      FPageCtrlWndProc(Message);
end;

procedure TideSHComponentFrame.DoOnPageDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  OldIndex: Integer;
  NewIndex: Integer;
  Tab: TTabSheet;
begin
  OldIndex := PageCtrl.ActivePageIndex;
  NewIndex := PageCtrl.IndexOfTabAt(X, Y);
  Tab := PageCtrl.ActivePage;
  Tab.PageIndex := NewIndex;
  FormList.Move(OldIndex, NewIndex);
  CallStrings.Move(OldIndex, NewIndex);
end;

procedure TideSHComponentFrame.DoOnPageDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  NewIndex: Integer;
begin
  NewIndex := PageCtrl.IndexOfTabAt(X, Y);
  Accept := (NewIndex <> -1);
end;

procedure TideSHComponentFrame.DoOnPageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  NewIndex: Integer;
  P: TPoint;
  WindowLocked: Boolean;
begin
  P.X := X;
  P.Y := Y;

  if Button = mbLeft then
  begin
    NewIndex := PageCtrl.IndexOfTabAt(X, Y);
    if NewIndex > -1 then
    begin
      PageCtrl.BeginDrag(False);
      FStartPage := NewIndex;
      CurrentForm := TSHComponentForm(FormList[PageCtrl.ActivePageIndex]);
      Application.ProcessMessages;
      ObjectEditor.ChangeEditor;
    end;
  end;

  if (Button = mbRight) or (Button = mbMiddle) then
  begin
    NewIndex := PageCtrl.IndexOfTabAt(X, Y);
    if (NewIndex > -1) and (NewIndex <> PageCtrl.ActivePageIndex) then
    begin

      WindowLocked := LockWindowUpdate(GetDesktopWindow);
      try
        PageCtrl.ActivePageIndex := NewIndex;
      finally
        if WindowLocked then LockWindowUpdate(0);
      end;

      Application.ProcessMessages;
      if PageCtrl.PageCount > 0 then
      begin
        CurrentForm := TSHComponentForm(FormList[PageCtrl.ActivePageIndex]);
        ObjectEditor.ChangeEditor;
      end;
    end;

    P := PageCtrl.ClientToScreen(P);

    if Button = mbRight then MainForm.PopupMenuOE2.Popup(P.X, P.Y);

    if Button = mbMiddle then
    begin
      if ObjectEditorIntf.CallStringCount > 1 then
        MegaEditorIntf.Remove(ObjectEditorIntf.CurrentComponent, ObjectEditorIntf.CurrentCallString)
      else
        ComponentFactoryIntf.DestroyComponent(ObjectEditorIntf.CurrentComponent);
    end;
  end;
end;

procedure TideSHComponentFrame.CreateLevel1Page(AOwner: TComponent);
var
  NewIndex: Integer;
  Panel, BasePanel: TPanel;
  Bevel: TBevel;
//  Toolbar: TToolBar;
begin
  NewIndex := TPageControl(AOwner).ActivePageIndex;
  Caption := Format('%s', [FComponent.Caption]);
  PageControl := TPageControl(AOwner);
  Parent := TWinControl(AOwner);
  Font := TPageControl(AOwner).Font;
  PageIndex := Succ(NewIndex);
  ImageIndex := FComponent.Designer.GetImageIndex(FComponent.ClassIID);
  TPageControl(AOwner).ActivePageIndex := PageIndex;

  // Construct Bevel
  Bevel := TBevel.Create(Self);
  with Bevel do
  begin
    Parent := Self;
    Align := alTop;
    Height := 4;
    Shape := bsSpacer;
  end;

  // Construct Base Panel
  BasePanel := TPanel.Create(Self);
  with BasePanel do
  begin
    Parent := Self as TWinControl;
    Align := alClient;
    BevelInner := bvNone;
    BevelOuter := bvNone;
  end;

  // Construct Top Panel
  Panel := TPanel.Create(BasePanel);
  with Panel do
  begin
    Parent := BasePanel;
    Align := alTop;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    Height := 24;
  end;


  // Construct ToolBar
  FToolbar := TToolbar.Create(Panel);
  with FToolbar do
  begin
    Parent := Panel;
    Align := alRight;
    EdgeBorders := [];
    Images := MainForm.ImageList1;
    Flat := True;
    AutoSize := True;
    Wrapable := False;
    with TToolButton.Create(FToolbar) do
    begin
      Parent := FToolbar;
      Action := MainForm.actClosePage;
      ShowHint := True;
      Width := 23;
    end;
  end;

  FButtonFrame := TideSHButtonFrame.Create(Panel);
  FButtonFrame.ComponentFrame := Self;
  FButtonFrame.Component := FComponent;
//  ShowMessage(FComponent.ClassName);
  // Construct Client Panel
  Panel := TPanel.Create(BasePanel);
  with Panel do
  begin
    Parent := BasePanel;
    Align := alClient;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    Height := 24;
  end;

  // Construct Parent Panel
  FParentPanel := TPanel.Create(Panel);
  with FParentPanel do
  begin
    Parent := Panel;
    ParentFont := False;
    Font.Style := [];
    Align := alClient;
    BevelInner := bvLowered;
    BevelOuter := bvNone;
  end;

  // Construct PageControl 2
  FPageCtrl := TPageControl.Create(FParentPanel);
  with FPageCtrl do
  begin
    Parent := FParentPanel;
    Align := alClient;
    HotTrack := True;
    Images := PageControl.Images;
    TabStop := False;
    OnDragDrop := DoOnPageDragDrop;
    OnDragOver := DoOnPageDragOver;
    OnMouseDown := DoOnPageMouseDown;
  end;
  
  FPageCtrlWndProc := FPageCtrl.WindowProc;
  FPageCtrl.WindowProc := PageCtrlWndProc;
end;

function TideSHComponentFrame.CreateLevel2Page(const CallString: string): Integer;
var
  NewIndex: Integer;
  Page: TTabSheet;
  Bevel: TBevel;
  Panel: TPanel;
begin
  NewIndex := FPageCtrl.ActivePageIndex;
  Page := TTabSheet.Create(FPageCtrl);
  Page.Caption := Format('%s', [CallString]);
  Page.Parent := TWinControl(FPageCtrl);
  Page.PageControl := FPageCtrl;
  Page.Font := FPageCtrl.Font;
  Page.PageIndex := Succ(NewIndex);
  Page.ImageIndex := FComponent.Designer.GetImageIndex(CallString);
  FPageCtrl.ActivePageIndex := Page.PageIndex;
  Result := Page.PageIndex;

  Bevel := TBevel.Create(Page);
  Bevel.Parent := Page;
  Bevel.Align := alTop;
  Bevel.Height := 4;
  Bevel.Shape := bsSpacer;

  Panel := TPanel.Create(Page);
  Panel.Parent := Page;
  Panel.Align := alClient;
  Panel.BevelInner := bvLowered;
  Panel.BevelOuter := bvNone;

  FParentPanel := Panel;
end;

function TideSHComponentFrame.IndexOf(const CallString: string): Integer;
begin
  Result := CallStrings.IndexOf(CallString);
end;

function TideSHComponentFrame.Exists(const CallString: string): Boolean;
begin
  Result := IndexOf(CallString) <> -1;
end;

function TideSHComponentFrame.Add(const CallString: string): Boolean;
var
  ComponentFormClass: TSHComponentFormClass;
  ComponentForm: TSHComponentForm;
  I: Integer;
  StatusBar: TStatusBar;
  WindowLocked: Boolean;
begin
  Result := Exists(CallString);
  if Length(CallString) = 0  then Exit;

  if not Result then
  begin
    ComponentFormClass := Component.Designer.GetComponentForm(FComponent.ClassIID, CallString);
    if Assigned(ComponentFormClass) then
    begin
      I := CreateLevel2Page(CallString);
      ComponentForm := ComponentFormClass.Create(ParentPanel, ParentPanel, Component, CallString);

      StatusBar := TStatusBar.Create(ComponentForm);
      StatusBar.Parent := ComponentForm;
      StatusBar.Top := ComponentForm.Height;
      ComponentForm.StatusBar := StatusBar;

      FormList.Insert(I, ComponentForm);
      CallStrings.Insert(I, CallString);
      CurrentForm := TSHComponentForm(FormList[I]);


      CurrentForm.Show;
    end;
  end else
  begin
    I := CallStrings.IndexOf(CallString);
    CurrentForm := TSHComponentForm(FormList[I]);
    if Assigned(PageCtrl) then
    begin
      WindowLocked := LockWindowUpdate(GetDesktopWindow);
      try
        PageCtrl.ActivePageIndex := I;
      finally
        if WindowLocked then LockWindowUpdate(0);
      end;
    end;
    CurrentForm.BringToFront;
  end;
end;

function TideSHComponentFrame.Remove(const CallString: string): Boolean;
var
  CallStringIndex: Integer;
  I: Integer;
begin
  if Length(CallString) > 0 then
  begin
    CallStringIndex := CallStrings.IndexOf(CallString);
    Result := CallStringIndex <> -1;
    if Result then
    begin
      Add(CallStrings[CallStringIndex]);
      Result := TSHComponentForm(FormList[CallStringIndex]).CanDestroy;
      if not Result then Exit;

      CurrentForm := nil;
      Supports(CurrentForm, ISHFileCommands, FileCommandsIntf);
      Supports(CurrentForm, ISHEditCommands, EditCommandsIntf);
      Supports(CurrentForm, ISHSearchCommands, SearchCommandsIntf);
      Supports(CurrentForm, ISHRunCommands, RunCommandsIntf);

      FormList.Delete(CallStringIndex);
      CallStrings.Delete(CallStringIndex);
      if Assigned(PageCtrl) then
      begin
        PageCtrl.Pages[CallStringIndex].Free;
        if PageCtrl.PageCount > 0 then
          PageCtrl.ActivePageIndex := GetNextItem(CallStringIndex, PageCtrl.PageCount);
      end;
      if FormList.Count > 0 then
        CurrentForm := TSHComponentForm(FormList[GetNextItem(CallStringIndex, FormList.Count)]);
    end;
  end else
  begin
    Result := True;
    for I := Pred(FormList.Count) downto 0 do
    begin
      Add(CallStrings[I]);
      Result := TSHComponentForm(FormList[I]).CanDestroy;
      if not Result then Break;

      CurrentForm := nil;
      Supports(CurrentForm, ISHFileCommands, FileCommandsIntf);
      Supports(CurrentForm, ISHEditCommands, EditCommandsIntf);
      Supports(CurrentForm, ISHSearchCommands, SearchCommandsIntf);
      Supports(CurrentForm, ISHRunCommands, RunCommandsIntf);

      FormList.Delete(I);
      CallStrings.Delete(I);

      if Assigned(PageCtrl) then
      begin
        PageCtrl.Pages[I].Free;
//        if PageCtrl.PageCount > 0 then
//          PageCtrl.ActivePageIndex := GetNextItem(I, PageCtrl.PageCount);
      end;

    end;
  end;
end;

function TideSHComponentFrame.CanDestroy(const CallString: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  if Length(CallString) = 0 then Exit;
  for I := 0 to Pred(FormList.Count) do
  begin
    Result := TSHComponentForm(FormList[I]).CanDestroy;
    if not Result then Break;
  end;
end;

(* < ====================================================================== > *)

{ TideSHObjectEditor }

constructor TideSHObjectEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FJumpList := TObjectList.Create;
end;

destructor TideSHObjectEditor.Destroy;
begin
  if Assigned(PageCtrl) then PageCtrl.Free;
  FJumpList.Free;
  inherited Destroy;
end;

procedure TideSHObjectEditor.CreateEditor;
begin
  PageCtrl := TPageControl.Create(MainForm.pnlHost{pnlClient});
  PageCtrl.Parent := MainForm.pnlHost;
  PageCtrl.Align := alClient;
  PageCtrl.Visible := True;
  PageCtrl.HotTrack := True;
  PageCtrl.TabStop := False;
  PageCtrl.MultiLine := FMultiLine;

  PageCtrl.Font.Style := [fsBold];
  PageCtrl.OnDragDrop := DoOnPageDragDrop;
  PageCtrl.OnDragOver := DoOnPageDragOver;
  PageCtrl.OnMouseDown := DoOnPageMouseDown;
  PageCtrl.OnDrawTab := DoOnDrawTab;
  PageCtrl.OwnerDraw := True;

  if Assigned(MainIntf) then PageCtrl.Images := MainIntf.ImageList;
  Flat := True;
end;

procedure TideSHObjectEditor.ChangeEditor;
begin
  Application.ProcessMessages;
  FCanUpdateToolbarActions := False;
  try
    if Assigned(CurrentComponent) then
      Application.Title := Format('[%s] - %s', [CurrentComponent.Caption, SApplicationTitle])
    else
      Application.Title := Format('%s', [SApplicationTitle]);

    Supports(CurrentForm, ISHFileCommands, FileCommandsIntf);
    Supports(CurrentForm, ISHEditCommands, EditCommandsIntf);
    Supports(CurrentForm, ISHSearchCommands, SearchCommandsIntf);
    Supports(CurrentForm, ISHRunCommands, RunCommandsIntf);

    if Assigned(CurrentForm) then
    begin
      CurrentForm.BringToTop;
      MainForm.Caption := Format('%s\%s', [SApplicationTitle, CurrentComponent.CaptionPath]);
    end else
      MainForm.Caption := Format('%s', [SApplicationTitle]);

   Application.ProcessMessages;
   if Assigned(CurrentComponent) then
     if Assigned(NavigatorIntf) and Assigned(NavigatorIntf.Toolbox) then
       NavigatorIntf.Toolbox._InspShowForm(CurrentComponent);

    {if CanUpdateToolbarActions then}
   UpdateToolbarActions;
   PageCtrl.Width := PageCtrl.Width + 1; // хак перерисовки
   PageCtrl.Width := PageCtrl.Width - 1; // хак перерисовки
  finally
    FCanUpdateToolbarActions := True;
  end;
end;

function TideSHObjectEditor.GetCurrentComponent: TSHComponent;
begin
  Result := nil;
  if (PageCtrl.PageCount > 0) and not (csDestroying in ComponentState) then
    if Assigned(PageCtrl.ActivePage) then
      Result := TideSHComponentFrame(PageCtrl.ActivePage).Component;
end;

function TideSHObjectEditor.GetMultiLine: Boolean;
begin
  Result := FMultiLine;
end;

procedure TideSHObjectEditor.SetMultiLine(Value: Boolean);
begin
  FMultiLine := Value;
  if Assigned(PageCtrl) then PageCtrl.MultiLine := FMultiLine;
end;

function TideSHObjectEditor.GetFilterMode: Boolean;
begin
  Result := FFilterMode;
end;

procedure TideSHObjectEditor.SetFilterMode(Value: Boolean);
begin
  FFilterMode := Value;
end;

function TideSHObjectEditor.GetCurrentComponentForm: TSHComponentForm;
begin
  Result := nil;
  if (PageCtrl.PageCount > 0) and not (csDestroying in ComponentState) then
      Result := TideSHComponentFrame(PageCtrl.ActivePage).CurrentForm;
end;

function TideSHObjectEditor.GetCurrentCallString: string;
begin
  if PageCtrl.PageCount > 0 then
    if Assigned(TideSHComponentFrame(PageCtrl.ActivePage).CurrentForm) then
      Result := TideSHComponentFrame(PageCtrl.ActivePage).CurrentForm.CallString;
end;

function TideSHObjectEditor.GetCallStringCount: Integer;
begin
  Result := TideSHComponentFrame(PageCtrl.ActivePage).CallStrings.Count;
end;

procedure TideSHObjectEditor.CreateComponentFrame(AOwner: TComponent;
  AComponent: TSHComponent; ACallString: string);
begin
  TideSHComponentFrame.Create(AOwner, AComponent, ACallString, Self);
end;

function TideSHObjectEditor.GetComponent(Index: Integer): TSHComponent;
begin
  Result := TideSHComponentFrame(PageCtrl.Pages[Index]).Component;
end;

function TideSHObjectEditor.GetCallStrings(Index: Integer): TStrings;
begin
  Result := TideSHComponentFrame(PageCtrl.Pages[Index]).CallStrings;
end;

procedure TideSHObjectEditor.GetCaptionList(APopupMenu: TPopupMenu);
var
  I: Integer;
  NewItem: TMenuItem;
begin
  while APopupMenu.Items.Count > 0 do
    APopupMenu.Items.Delete(0);

  for I := 0 to Pred(PageCtrl.PageCount) do
  begin
    NewItem := TMenuItem.Create(nil);
    NewItem.Caption := TideSHComponentFrame(PageCtrl.Pages[I]).Component.CaptionExt;
    NewItem.OnClick := DoOnClikCaptionItem;
    NewItem.ImageIndex := PageCtrl.Pages[I].ImageIndex;
    NewItem.Tag := I;
    NewItem.Default := PageCtrl.ActivePageIndex = I;
//    if NewItem.Checked then NewItem.ImageIndex := -1;
    APopupMenu.Items.Add(NewItem);
  end;
  // --
  APopupMenu.Items.Add(NewLine);
  NewItem := TMenuItem.Create(nil);
  if Assigned(SystemOptionsIntf) and SystemOptionsIntf.UseWorkspaces then
    NewItem.Action := MainForm.actCloseWorkspace
  else
    NewItem.Action := MainForm.actCloseAll;
  APopupMenu.Items.Add(NewItem);
end;

procedure TideSHObjectEditor.GetCaptionList(AMenuItem: TMenuItem);
var
  I: Integer;
  NewItem: TMenuItem;
begin
//  while AMenuItem.Count <> (-1) * AMenuItem.Tag do
//    AMenuItem.Delete(Pred(AMenuItem.Count));

//  while APopupMenu.Items.Count > 0 do
//    APopupMenu.Items.Delete(0);

  for I := Pred(PageCtrl.PageCount) downto 0 do
  begin
    NewItem := TMenuItem.Create(nil);
    NewItem.Caption := TideSHComponentFrame(PageCtrl.Pages[I]).Component.CaptionExt;
    NewItem.OnClick := DoOnClikCaptionItem;
    NewItem.ImageIndex := PageCtrl.Pages[I].ImageIndex;
    NewItem.Tag := I;
    NewItem.Default := PageCtrl.ActivePageIndex = I;
//    if NewItem.Checked then NewItem.ImageIndex := -1;
    AMenuItem.Insert(0, NewItem);
  end;
end;

procedure TideSHObjectEditor.GetBackList(APopupMenu: TPopupMenu);
var
  I: Integer;
  NewItem: TMenuItem;
begin
  while APopupMenu.Items.Count > 0 do
    APopupMenu.Items.Delete(0);

  for I := Pred(FJumpList.Count) downto 0 do
  begin
    if IsEqualGUID(TideSHJumpDescr(FJumpList[I]).ToOwnerIID, GetCurrentComponent.OwnerIID) and
       IsEqualGUID(TideSHJumpDescr(FJumpList[I]).ToClassIID, GetCurrentComponent.ClassIID) and
       (CompareStr(TideSHJumpDescr(FJumpList[I]).ToCaption, GetCurrentComponent.Caption) = 0) then
    begin
      NewItem := TMenuItem.Create(nil);
      NewItem.Caption := TideSHJumpDescr(FJumpList[I]).FromCaptionExt;
      NewItem.OnClick := DoOnClikBackItem;
      NewItem.ImageIndex := DesignerIntf.GetImageIndex(TideSHJumpDescr(FJumpList[I]).FromClassIID);
      NewItem.Tag := I;
      APopupMenu.Items.Add(NewItem);
    end;
  end;
end;

procedure TideSHObjectEditor.GetForwardList(APopupMenu: TPopupMenu);
var
  I: Integer;
  NewItem: TMenuItem;
begin
  while APopupMenu.Items.Count > 0 do
    APopupMenu.Items.Delete(0);

  for I := Pred(FJumpList.Count) downto 0 do
  begin
    if IsEqualGUID(TideSHJumpDescr(FJumpList[I]).FromOwnerIID, GetCurrentComponent.OwnerIID) and
       IsEqualGUID(TideSHJumpDescr(FJumpList[I]).FromClassIID, GetCurrentComponent.ClassIID) and
       (CompareStr(TideSHJumpDescr(FJumpList[I]).FromCaption, GetCurrentComponent.Caption) = 0) then
    begin
      NewItem := TMenuItem.Create(nil);
      NewItem.Caption := TideSHJumpDescr(FJumpList[I]).ToCaptionExt;
      NewItem.OnClick := DoOnClikForwardItem;
      NewItem.ImageIndex := DesignerIntf.GetImageIndex(TideSHJumpDescr(FJumpList[I]).ToClassIID);
      NewItem.Tag := I;
      APopupMenu.Items.Add(NewItem);
    end;
  end;
end;

function TideSHObjectEditor.GetCanBrowseBack(AComponent: TSHComponent): Boolean;
var
  I: Integer;
begin
  Result := False;
  if PageCtrl.PageCount > 0 then
    for I := Pred(FJumpList.Count) downto 0 do
      if IsEqualGUID(TideSHJumpDescr(FJumpList[I]).ToOwnerIID, AComponent.OwnerIID) and
         IsEqualGUID(TideSHJumpDescr(FJumpList[I]).ToClassIID, AComponent.ClassIID) and
         (CompareStr(TideSHJumpDescr(FJumpList[I]).ToCaption, AComponent.Caption) = 0) then
      begin
        Result := True;
        Break;
      end;
end;

function TideSHObjectEditor.GetCanBrowseForward(AComponent: TSHComponent): Boolean;
var
  I: Integer;
begin
  Result := False;
  if PageCtrl.PageCount > 0 then
    for I := Pred(FJumpList.Count) downto 0 do
      if IsEqualGUID(TideSHJumpDescr(FJumpList[I]).FromOwnerIID, AComponent.OwnerIID) and
         IsEqualGUID(TideSHJumpDescr(FJumpList[I]).FromClassIID, AComponent.ClassIID) and
         (CompareStr(TideSHJumpDescr(FJumpList[I]).FromCaption, AComponent.Caption) = 0) then
      begin
        Result := True;
        Break;
      end;
end;

procedure TideSHObjectEditor.Jump(AFromComponent, AToComponent: TSHComponent);
var
  I: Integer;
  vJump: TideSHJumpDescr;
begin
  if IsEqualGUID(AFromComponent.InstanceIID, AToComponent.InstanceIID) then Exit;
  
  for I := 0 to Pred(FJumpList.Count) do
  begin
    vJump := TideSHJumpDescr(FJumpList[I]);
    if IsEqualGUID(vJump.FromOwnerIID, AFromComponent.OwnerIID) and
       IsEqualGUID(vJump.FromClassIID, AFromComponent.ClassIID) and
       (CompareStr(vJump.FromCaption, AFromComponent.Caption) = 0) and
//       (CompareStr(vJump.FromCaptionExt, AFromComponent.CaptionExt) = 0) and
       IsEqualGUID(vJump.ToOwnerIID, AToComponent.OwnerIID) and
       IsEqualGUID(vJump.ToClassIID, AToComponent.ClassIID) and
       (CompareStr(vJump.ToCaption, AToComponent.Caption) = 0) then
//       (CompareStr(vJump.ToCaptionExt, AToComponent.CaptionExt) = 0) then
    begin
      FJumpList.Delete(I);
      Break;
    end;
  end;

  vJump := nil;

  if not Assigned(vJump) then
  begin
    vJump := TideSHJumpDescr.Create;
    vJump.FromOwnerIID := AFromComponent.OwnerIID;
    vJump.FromClassIID := AFromComponent.ClassIID;
    vJump.FromCaption := AFromComponent.Caption;
    vJump.FromCaptionExt := AFromComponent.CaptionExt;
    vJump.ToOwnerIID := AToComponent.OwnerIID;
    vJump.ToClassIID := AToComponent.ClassIID;
    vJump.ToCaption := AToComponent.Caption;
    vJump.ToCaptionExt := AToComponent.CaptionExt;
    FJumpList.Add(vJump);
  end;
end;

procedure TideSHObjectEditor.JumpRemove(const AOwnerIID, AClassIID: TGUID; const ACaption: string);
var
  I: Integer;
  vJump: TideSHJumpDescr;
begin
  for I := Pred(FJumpList.Count) downto 0 do
  begin
    vJump := TideSHJumpDescr(FJumpList[I]);
    if (
        IsEqualGUID(vJump.FromOwnerIID, AOwnerIID) and
        IsEqualGUID(vJump.FromClassIID, AClassIID) and
        (CompareStr(vJump.FromCaption, ACaption) = 0)
       ) or
       (
        IsEqualGUID(vJump.ToOwnerIID, AOwnerIID) and
        IsEqualGUID(vJump.ToClassIID, AClassIID) and
        (CompareStr(vJump.ToCaption, ACaption) = 0)
       ) then
    begin
      FJumpList.Delete(I);
    end;
  end;
end;

procedure TideSHObjectEditor.BrowseNext;
var
  NewIndex: Integer;
begin
  if PageCtrl.ActivePageIndex < Pred(PageCtrl.PageCount) then
    NewIndex := Succ(PageCtrl.ActivePageIndex)
  else
    NewIndex := 0;
  Add(GetComponent(NewIndex));
end;

procedure TideSHObjectEditor.BrowsePrevious;
var
  NewIndex: Integer;
begin
  if PageCtrl.ActivePageIndex > 0 then
    NewIndex := PageCtrl.ActivePageIndex - 1
  else
    NewIndex := Pred(PageCtrl.PageCount);
  Add(GetComponent(NewIndex));
end;

procedure TideSHObjectEditor.BrowseBack;
var
  I: Integer;
begin
  for I := Pred(FJumpList.Count) downto 0 do
    if IsEqualGUID(TideSHJumpDescr(FJumpList[I]).ToOwnerIID, GetCurrentComponent.OwnerIID) and
       IsEqualGUID(TideSHJumpDescr(FJumpList[I]).ToClassIID, GetCurrentComponent.ClassIID) and
       (CompareStr(TideSHJumpDescr(FJumpList[I]).ToCaption, GetCurrentComponent.Caption) = 0) then
    begin
      DesignerIntf.CreateComponent(
        TideSHJumpDescr(FJumpList[I]).FromOwnerIID,
        TideSHJumpDescr(FJumpList[I]).FromClassIID,
        TideSHJumpDescr(FJumpList[I]).FromCaption);
      Break;
    end;
end;

procedure TideSHObjectEditor.BrowseForward;
var
  I: Integer;
begin
  for I := Pred(FJumpList.Count) downto 0 do
    if IsEqualGUID(TideSHJumpDescr(FJumpList[I]).FromOwnerIID, GetCurrentComponent.OwnerIID) and
       IsEqualGUID(TideSHJumpDescr(FJumpList[I]).FromClassIID, GetCurrentComponent.ClassIID) and
       (CompareStr(TideSHJumpDescr(FJumpList[I]).FromCaption, GetCurrentComponent.Caption) = 0) then
    begin
      DesignerIntf.CreateComponent(
        TideSHJumpDescr(FJumpList[I]).ToOwnerIID,
        TideSHJumpDescr(FJumpList[I]).ToClassIID,
        TideSHJumpDescr(FJumpList[I]).ToCaption);
      Break;
    end;
end;

procedure TideSHObjectEditor.DoOnClikCaptionItem(Sender: TObject);
begin
  Add(GetComponent(TMenuItem(Sender).Tag));
end;

procedure TideSHObjectEditor.DoOnClikBackItem(Sender: TObject);
begin
  DesignerIntf.CreateComponent(
    TideSHJumpDescr(FJumpList[TMenuItem(Sender).Tag]).FromOwnerIID,
    TideSHJumpDescr(FJumpList[TMenuItem(Sender).Tag]).FromClassIID,
    TideSHJumpDescr(FJumpList[TMenuItem(Sender).Tag]).FromCaption);
end;

procedure TideSHObjectEditor.DoOnClikForwardItem(Sender: TObject);
begin
  DesignerIntf.CreateComponent(
    TideSHJumpDescr(FJumpList[TMenuItem(Sender).Tag]).ToOwnerIID,
    TideSHJumpDescr(FJumpList[TMenuItem(Sender).Tag]).ToClassIID,
    TideSHJumpDescr(FJumpList[TMenuItem(Sender).Tag]).ToCaption);
end;

procedure TideSHObjectEditor.DoOnPageDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  NewIndex: Integer;
  Tab: TTabSheet;
begin
  NewIndex := PageCtrl.IndexOfTabAt(X, Y);
  Tab := PageCtrl.ActivePage;
  Tab.PageIndex := NewIndex;
end;

procedure TideSHObjectEditor.DoOnPageDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  NewIndex: Integer;
begin
  NewIndex := PageCtrl.IndexOfTabAt(X, Y);
  Accept := (NewIndex <> -1);
end;

procedure TideSHObjectEditor.DoOnPageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  NewIndex: Integer;
  P: TPoint;
  WindowLocked: Boolean;
begin
  P.X := X;
  P.Y := Y;

  if Button = mbLeft then
  begin
    NewIndex := PageCtrl.IndexOfTabAt(X, Y);
    if NewIndex > -1 then
    begin
      PageCtrl.BeginDrag(False);
      FStartPage := NewIndex;
      ChangeEditor;
    end;
  end;

  if (Button = mbRight) or (Button = mbMiddle) then
  begin
    NewIndex := PageCtrl.IndexOfTabAt(X, Y);
    if (NewIndex > -1) and (NewIndex <> PageCtrl.ActivePageIndex) then
    begin
      WindowLocked := LockWindowUpdate(GetDesktopWindow);
      try
        PageCtrl.ActivePageIndex := NewIndex;
      finally
        if WindowLocked then LockWindowUpdate(0);
      end;

      if PageCtrl.PageCount > 0 then
      begin
        ChangeEditor;
      end;
    end;

    P := PageCtrl.ClientToScreen(P);

    if Button = mbRight then MainForm.PopupMenuOE1.Popup(P.X, P.Y);
    if Button = mbMiddle then MainIntf.Close;
  end;
end;

procedure TideSHObjectEditor.DoOnDrawTab(Control: TCustomTabControl; TabIndex: Integer;
  const Rect: TRect; Active: Boolean);
var
  S: string;
  I: Integer;
begin
  S := PageCtrl.Pages[TabIndex].Caption;
  I := PageCtrl.Pages[TabIndex].ImageIndex;
  with Control.Canvas do
  begin
    FillRect(Rect);
    DesignerIntf.ImageList.Draw(Control.Canvas, Rect.Left + 8, (Rect.Top + Rect.Bottom - 14) div 2, I);
    if Active then Font.Style := [fsBold] else Font.Style := [];
    TextOut(Rect.Left + 28, (Rect.Top + Rect.Bottom - TextHeight(S)) div 2, S)
  end;
end;

function TideSHObjectEditor.Exists(AComponent: TSHComponent): Boolean;
begin
  Result := Exists(AComponent, EmptyStr);
end;

function TideSHObjectEditor.Add(AComponent: TSHComponent): Boolean;
begin
  Result := Add(AComponent, EmptyStr);
end;

function TideSHObjectEditor.Remove(AComponent: TSHComponent): Boolean;
begin
  Result := Remove(AComponent, EmptyStr);
end;

function TideSHObjectEditor.CanUpdateToolbarActions: Boolean;
begin
  Result := FCanUpdateToolbarActions;
end;

procedure TideSHObjectEditor.UpdateToolbarActions;
begin
  if Assigned(CurrentComponent) and Assigned(CurrentForm) then
    TideSHComponentFrame(PageCtrl.ActivePage).ButtonFrame.UpdateToolbarActions;
end;

function TideSHObjectEditor.IndexOf(AComponent: TSHComponent; const CallString: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(PageCtrl.PageCount) do
    if (PageCtrl.Pages[I] is TideSHComponentFrame) and
       (TideSHComponentFrame(PageCtrl.Pages[I]).Component = AComponent) then
    begin
      if Length(CallString) = 0 then
      begin
        Result := I;
      end else
      begin
        if TideSHComponentFrame(PageCtrl.Pages[I]).Exists(CallString) then
          Result := I;
      end;
      if Result <> - I then Break;
    end;
end;

function TideSHObjectEditor.Exists(AComponent: TSHComponent;
  const CallString: string): Boolean;
begin
  Result := IndexOf(AComponent, CallString) <> -1;
end;

function TideSHObjectEditor.Add(AComponent: TSHComponent;
  const CallString: string): Boolean;
var
  WindowLocked: Boolean;
begin
  Result := Exists(AComponent, EmptyStr);

  if Result then
  begin
    WindowLocked := LockWindowUpdate(GetDesktopWindow);
    try
      PageCtrl.ActivePageIndex := IndexOf(AComponent, EmptyStr);
    finally
      if WindowLocked then LockWindowUpdate(0);
    end;
    Result := TideSHComponentFrame(PageCtrl.ActivePage).Add(CallString);
  end else
  begin
    CreateComponentFrame(PageCtrl, AComponent, CallString);
    Result := Assigned(CurrentForm);
  end;

  ChangeEditor;
  Self.Enabled := Assigned(PageCtrl) and (PageCtrl.PageCount > 0);
end;

function TideSHObjectEditor.Remove(AComponent: TSHComponent;
  const CallString: string): Boolean;
var
  CallStringIndex, Count: Integer;  // cur
  WindowLocked: Boolean;
begin
  CallStringIndex := IndexOf(AComponent, CallString);
  Result := CallStringIndex <> -1;

  if Result then
  begin
    WindowLocked := LockWindowUpdate(GetDesktopWindow);
    try
      PageCtrl.ActivePageIndex := CallStringIndex;
    finally
      if WindowLocked then LockWindowUpdate(0);
    end;

    TideSHComponentFrame(PageCtrl.ActivePage).Add(CallString);
    Count := TideSHComponentFrame(PageCtrl.ActivePage).FormList.Count;
    Result := TideSHComponentFrame(PageCtrl.ActivePage).Remove(CallString);
    if not Result then Exit;

    if TideSHComponentFrame(PageCtrl.ActivePage).FormList.Count = 0 then PageCtrl.ActivePage.Free;

    if PageCtrl.PageCount > 0 then
    begin
      if (Count = 1) or (CallString = EmptyStr) then
      begin
        WindowLocked := LockWindowUpdate(GetDesktopWindow);
        try
          PageCtrl.ActivePageIndex := GetNextItem(CallStringIndex, PageCtrl.PageCount);
        finally
          if WindowLocked then LockWindowUpdate(0);
        end;
      end;

      if Assigned(TideSHComponentFrame(PageCtrl.ActivePage).CurrentForm) then
        Add(CurrentComponent, TideSHComponentFrame(PageCtrl.ActivePage).CurrentForm.CallString);
    end else
      ChangeEditor;
  end;

  Self.Enabled := Assigned(PageCtrl) and (PageCtrl.PageCount > 0);
end;

end.


