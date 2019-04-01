unit ideSHMegaEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, ComCtrls, CommCtrl,
  ExtCtrls, Types, Menus, Contnrs, Dialogs,
  SHDesignIntf, SHEvents, ideSHDesignIntf;

type
  TideBTMegaEditor = class(TComponent, IideBTMegaEditor)
  private
    FActive: Boolean;
    FMultiLine: Boolean;
    FFilterMode: Boolean;
    FEditorList: TObjectList;

    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetMultiLine: Boolean;
    procedure SetMultiLine(Value: Boolean);
    function GetFilterMode: Boolean;
    procedure SetFilterMode(Value: Boolean);

    function CreatePage(AComponent: TSHComponent): Boolean;
    function ShowPage(AIndex: Integer): Boolean;
    function DestroyPage(AIndex: Integer): Boolean;
    procedure PageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);

    function CreateEditor(AComponent: TSHComponent): Integer;

    procedure CreateSingleEditor;
    procedure DestroySingleEditor;

    function IndexOfEditor(AComponent: TSHComponent): Integer;
    function ExistsEditor(AComponent: TSHComponent): Boolean;
    function AddEditor(AComponent: TSHComponent): Boolean;
    function RemoveEditor(AComponent: TSHComponent): Boolean;
  private
    procedure GetCaptionList(APopupMenu: TPopupMenu);
    procedure DoOnClikCaptionItem(Sender: TObject);
    function Exists(AComponent: TSHComponent; const CallString: string): Boolean;
    function Add(AComponent: TSHComponent; const CallString: string): Boolean;
    function Remove(AComponent: TSHComponent; const CallString: string): Boolean;
    procedure Toggle(AIndex: Integer);
    function Close: Boolean;
    function CloseAll: Boolean;
    function ShowEditor(AComponent: TSHComponent): Boolean; overload;
    function ShowEditor(const AIndex: Integer): Boolean; overload;
    function DestroyEditor(const AIndex: Integer): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  ideSHMainFrm, ideSHConsts, ideSHSystem, ideSHSysUtils, ideSHObjectEditor;

{ TideBTMegaEditor }

constructor TideBTMegaEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEditorList := TObjectList.Create;
  FActive := True;
end;

destructor TideBTMegaEditor.Destroy;
begin
  FreeAndNil(FEditorList);
  inherited Destroy;
end;

function TideBTMegaEditor.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure TideBTMegaEditor.SetActive(Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    if Value then
    begin
      MainForm.pnlHost.Color := clBtnFace;
      MainForm.pnlHost.BevelInner := bvNone;
      MainForm.PageControl1.Font.Style := [fsBold];
      MainForm.PageControl1.OnMouseDown := PageMouseDown;
      MainForm.PageControl1.OnDrawTab := DrawTab;
      MainForm.PageControl1.OwnerDraw := True;
      if Assigned(SystemOptionsIntf) and SystemOptionsIntf.UseWorkspaces then
        MainForm.PageControl1.Visible := True;
    end else
    begin
      MainForm.pnlHost.Color := clBtnFace; // clAppWorkSpace;
      MainForm.pnlHost.BevelInner := bvLowered;
      MainForm.PageControl1.OnChange := nil;
      MainForm.PageControl1.OnDrawTab := nil;
      MainForm.PageControl1.OwnerDraw := False;
      MainForm.PageControl1.Visible := False;
    end;
  end;
end;

function TideBTMegaEditor.GetMultiLine: Boolean;
begin
  Result := FMultiLine;
end;

procedure TideBTMegaEditor.SetMultiLine(Value: Boolean);
var
  I: Integer;
  vObjectEditorIntf: IideSHObjectEditor;
begin
  FMultiLine := Value;
  for I := 0 to Pred(FEditorList.Count) do
    if Supports(FEditorList[I], IideSHObjectEditor, vObjectEditorIntf) then
      vObjectEditorIntf.MultiLine := FMultiLine;
end;

function TideBTMegaEditor.GetFilterMode: Boolean;
begin
  Result := FFilterMode;
end;

procedure TideBTMegaEditor.SetFilterMode(Value: Boolean);
var
  I: Integer;
  vObjectEditorIntf: IideSHObjectEditor;
begin
  FFilterMode := Value;
  MainForm.TabSet1.Visible := FFilterMode;
  for I := 0 to Pred(FEditorList.Count) do
    if Supports(FEditorList[I], IideSHObjectEditor, vObjectEditorIntf) then
      vObjectEditorIntf.FilterMode := FFilterMode;
end;

function TideBTMegaEditor.CreatePage(AComponent: TSHComponent): Boolean;
var
  NewIndex: Integer;
  PageControl: TPageControl;
  Page: TTabSheet;
begin
  PageControl := MainForm.PageControl1;
  Result := Assigned(AComponent);
  if Result then
  begin
    NewIndex := Pred(PageControl.PageCount) + 1{ActivePageIndex};
    Page := TTabSheet.Create(PageControl);

    if Supports(AComponent, ISHDatabase) then
    begin
//      Page.Caption := Format('%s\%s\..', [(DesignerIntf.FindComponent(AComponent.OwnerIID) as ISHServer).Alias, AComponent.Caption])
      Page.Caption := Format('%s', [AComponent.Caption]);
      Page.ImageIndex := IMG_DATABASE; //DesignerIntf.GetImageIndex(AComponent.ClassIID);
    end else
    begin
      Page.Caption := Format('%s ', [AComponent.Caption]);
      Page.ImageIndex := IMG_SERVER; //DesignerIntf.GetImageIndex(AComponent.ClassIID);
    end;

    Page.Parent := PageControl;
    Page.PageControl := PageControl;
    Page.Font := PageControl.Font;
    Page.PageIndex := NewIndex;
    Page.Tag := Integer(AComponent);
    PageControl.ActivePageIndex := Page.PageIndex;
  end;
end;

function TideBTMegaEditor.ShowPage(AIndex: Integer): Boolean;
begin
  Result := Pred(MainForm.PageControl1.PageCount) >= AIndex;
  if Result then
  begin
    MainForm.PageControl1.ActivePageIndex := AIndex;
    MainForm.PageControl1.Width := MainForm.PageControl1.Width + 1; // хак перерисовки
    MainForm.PageControl1.Width := MainForm.PageControl1.Width - 1; // хак перерисовки
    if Supports(TSHComponent(MainForm.PageControl1.ActivePage.Tag), ISHDatabase) and Assigned(NavigatorIntf) then
        NavigatorIntf.ActivateConnection(TSHComponent(MainForm.PageControl1.ActivePage.Tag));
  end;
end;

function TideBTMegaEditor.DestroyPage(AIndex: Integer): Boolean;
begin
  Result := Pred(MainForm.PageControl1.PageCount) >= AIndex;
  if Result then
  begin
    MainForm.PageControl1.Pages[AIndex].Free;
  end;
//    MainForm.PageControl1.ActivePage.Free;
end;

procedure TideBTMegaEditor.PageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  NewIndex: Integer;
  P: TPoint;
begin
  P.X := X;
  P.Y := Y;

  if Button = mbLeft then
  begin
    NewIndex := MainForm.PageControl1.IndexOfTabAt(X, Y);
    if NewIndex > -1 then ShowEditor(NewIndex);
  end;

  if (Button = mbRight) or (Button = mbMiddle) then
  begin
    NewIndex := MainForm.PageControl1.IndexOfTabAt(X, Y);
    if (NewIndex > -1) and (NewIndex <> MainForm.PageControl1.ActivePageIndex) then
    begin
      MainForm.PageControl1.ActivePageIndex := NewIndex;
      if MainForm.PageControl1.PageCount > 0 then ShowEditor(NewIndex);
    end;

    P := MainForm.PageControl1.ClientToScreen(P);

    if Button = mbRight then MainForm.PopupMenuOE0.Popup(P.X, P.Y);
    if Button = mbMiddle then Close;
  end;
end;

procedure TideBTMegaEditor.DrawTab(Control: TCustomTabControl; TabIndex: Integer;
  const Rect: TRect; Active: Boolean);
var
  S: string;
  I: Integer;
begin
  S := MainForm.PageControl1.Pages[TabIndex].Caption;
  I := MainForm.PageControl1.Pages[TabIndex].ImageIndex;
  with Control.Canvas do
  begin
    FillRect(Rect);
    DesignerIntf.ImageList.Draw(Control.Canvas, Rect.Left + 2, Rect.Top, I);
    if Active then Font.Style := [fsBold] else Font.Style := [];
    if I <> -1 then
      TextOut(Rect.Left + 24, (Rect.Top + Rect.Bottom - TextHeight(S)) div 2, S)
    else
      TextOut((Rect.Left + Rect.Right - TextWidth(S)) div 2, (Rect.Top + Rect.Bottom - TextHeight(S)) div 2, S)
  end;
end;

function TideBTMegaEditor.CreateEditor(AComponent: TSHComponent): Integer;
var
  vObjectEditorIntf: IideSHObjectEditor;
begin
  Result := FEditorList.Add(TideSHObjectEditor.Create(nil));
  if (FEditorList[Result] is TComponent) then TComponent(FEditorList[Result]).Tag := Integer(AComponent);
  if Supports(FEditorList[Pred(FEditorList.Count)], IideSHObjectEditor, vObjectEditorIntf) then
  begin
    vObjectEditorIntf.CreateEditor;
    vObjectEditorIntf.MultiLine := FMultiLine;
    CreatePage(AComponent);
  end;
end;

procedure TideBTMegaEditor.CreateSingleEditor;
var
  WindowLocked: Boolean;
begin
  if FEditorList.Count = 0 then
  begin
    FEditorList.Add(TideSHObjectEditor.Create(nil));
    if Supports(FEditorList[0], IideSHObjectEditor, ObjectEditorIntf) then
    begin
      ObjectEditorIntf.CreateEditor;
      ObjectEditorIntf.MultiLine := FMultiLine;
      WindowLocked := LockWindowUpdate(GetDesktopWindow);
      try
        ObjectEditorIntf.PageCtrl.BringToFront;
      finally
        if WindowLocked then LockWindowUpdate(0);
      end;
      ObjectEditorIntf.ChangeEditor;
      SetActive(True);
    end;
  end;
end;

procedure TideBTMegaEditor.DestroySingleEditor;
begin
  if FEditorList.Count = 1 then
  begin
    ObjectEditorIntf := nil;
    FEditorList.Delete(0);
    SetActive(False);
  end;
end;

function TideBTMegaEditor.IndexOfEditor(AComponent: TSHComponent): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(FEditorList.Count) do
    if (FEditorList[I] is TComponent) and (TComponent(FEditorList[I]).Tag = Integer(AComponent)) then
    begin
      Result := I;
      Break;
    end;
end;

function TideBTMegaEditor.ExistsEditor(AComponent: TSHComponent): Boolean;
begin
  Result := IndexOfEditor(AComponent) <> -1;
end;

function TideBTMegaEditor.AddEditor(AComponent: TSHComponent): Boolean;
var
  I: Integer;
begin
  I := IndexOfEditor(AComponent);
  Result := I = -1;
  if Result then
  begin
    I := CreateEditor(AComponent);
    ShowEditor(I);
  end;
  if (FEditorList.Count > 0) and (TSHComponent(MainForm.PageControl1.ActivePage.Tag) <> AComponent) then ShowEditor(I);
  if FEditorList.Count > 0 then SetActive(True);
end;

function TideBTMegaEditor.RemoveEditor(AComponent: TSHComponent): Boolean;
var
  I: Integer;
begin
  I := IndexOfEditor(AComponent);
  Result := I <> -1;
  if Result then DestroyEditor(I);

  if FEditorList.Count > 0 then ShowEditor(GetNextItem(I, FEditorList.Count));
  if FEditorList.Count = 0 then SetActive(False);
end;

procedure TideBTMegaEditor.GetCaptionList(APopupMenu: TPopupMenu);
var
  I: Integer;
  PageControl: TPageControl;
  NewItem: TMenuItem;
begin
  PageControl := MainForm.PageControl1;

  while APopupMenu.Items.Count > 0 do
    APopupMenu.Items.Delete(0);

  if Assigned(SystemOptionsIntf) and SystemOptionsIntf.UseWorkspaces then
    for I := 0 to Pred(PageControl.PageCount) do
    begin
      NewItem := TMenuItem.Create(nil);
      NewItem.Caption := PageControl.Pages[I].Caption;
      NewItem.OnClick := DoOnClikCaptionItem;
      NewItem.ImageIndex := PageControl.Pages[I].ImageIndex;
      NewItem.Tag := I;
      NewItem.Default := PageControl.ActivePageIndex = I;
      NewItem.ImageIndex := 85;
      APopupMenu.Items.Add(NewItem);
    end;
end;

procedure TideBTMegaEditor.DoOnClikCaptionItem(Sender: TObject);
begin
  ShowEditor(TMenuItem(Sender).Tag);
end;

function TideBTMegaEditor.Exists(AComponent: TSHComponent; const CallString: string): Boolean;
var
  I: Integer;
  vObjectEditorIntf: IideSHObjectEditor;
begin
  Result := False;
  for I := 0 to Pred(FEditorList.Count) do
  begin
    Result := Supports(FEditorList[I], IideSHObjectEditor, vObjectEditorIntf) and
              vObjectEditorIntf.Exists(AComponent, CallString);
    if Result then Break;          
  end;
end;

function TideBTMegaEditor.Add(AComponent: TSHComponent; const CallString: string): Boolean;
var
  vComponent: TSHComponent;
begin
  Result := Assigned(AComponent);
  if Result then
  begin
    if Assigned(SystemOptionsIntf) and SystemOptionsIntf.UseWorkspaces then
    begin
      vComponent := DesignerIntf.FindComponent(AComponent.OwnerIID);
      // -> добавлено для сбора NonDatabaseContext в сепаратный редактор
      if not Supports(vComponent, ISHDatabase) then vComponent := DesignerIntf.FindComponent(IUnknown, AComponent.BranchIID);
      // <-
      if Assigned(vComponent) then AddEditor(vComponent);
    end else
      CreateSingleEditor;

    if Assigned(ObjectEditorIntf) then
    begin
      Result := ObjectEditorIntf.Add(AComponent, CallString);
    end;
  end;
end;

function TideBTMegaEditor.Remove(AComponent: TSHComponent; const CallString: string): Boolean;
var
  vComponent: TSHComponent;
begin
  vComponent := nil;
  Result := Assigned(AComponent);
  if Result then
  begin
    if Assigned(SystemOptionsIntf) and SystemOptionsIntf.UseWorkspaces then
    begin
      vComponent := DesignerIntf.FindComponent(AComponent.OwnerIID);
      // -> добавлено для сбора NonDatabaseContext в сепаратный редактор
      if not Supports(vComponent, ISHDatabase) then vComponent := DesignerIntf.FindComponent(IUnknown, AComponent.BranchIID);
      // <-
      if Assigned(vComponent) then AddEditor(vComponent);
    end;

    if Assigned(ObjectEditorIntf) then
    begin
      Result := ObjectEditorIntf.Remove(AComponent, CallString);
      if (ObjectEditorIntf.PageCtrl.PageCount = 0) then
      begin
        if Assigned(SystemOptionsIntf) and SystemOptionsIntf.UseWorkspaces then
        begin
          if ExistsEditor(vComponent) then RemoveEditor(vComponent);
        end else
          DestroySingleEditor;
      end;
    end;
  end;
end;

procedure TideBTMegaEditor.Toggle(AIndex: Integer);
begin
  ShowEditor(AIndex);
end;

function TideBTMegaEditor.Close: Boolean;
var
  I: Integer;
begin
  Result := True;
  I := MainForm.PageControl1.PageCount;
  while Assigned(ObjectEditorIntf) and (ObjectEditorIntf.PageCtrl.PageCount <> 0) and (I = MainForm.PageControl1.PageCount) do
    if not ComponentFactoryIntf.DestroyComponent(ObjectEditorIntf.CurrentComponent) then
    begin
      Result := False;
      Break;
    end;
end;

function TideBTMegaEditor.CloseAll: Boolean;
begin
  while Assigned(ObjectEditorIntf) and (ObjectEditorIntf.PageCtrl.PageCount <> 0) do
    if not ComponentFactoryIntf.DestroyComponent(ObjectEditorIntf.CurrentComponent) then
      Break;

  Result := FEditorList.Count = 0;
end;

function TideBTMegaEditor.ShowEditor(AComponent: TSHComponent): Boolean;
begin
  Result := ExistsEditor(AComponent);
  if Result then AddEditor(AComponent);
end;

function TideBTMegaEditor.ShowEditor(const AIndex: Integer): Boolean;
var
  WindowLocked: Boolean;
begin
  Result := Pred(FEditorList.Count) >= AIndex;
  if Result and Supports(FEditorList[AIndex], IideSHObjectEditor, ObjectEditorIntf) then
  begin
    ShowPage(AIndex);
    WindowLocked := LockWindowUpdate(GetDesktopWindow);
    try
      ObjectEditorIntf.PageCtrl.BringToFront;
    finally
      if WindowLocked then LockWindowUpdate(0);
    end;
    ObjectEditorIntf.ChangeEditor;
  end;
end;

function TideBTMegaEditor.DestroyEditor(const AIndex: Integer): Boolean;
begin
  Result := Pred(FEditorList.Count) >= AIndex;
  if Result then
  begin
    DestroyPage(AIndex);
    ObjectEditorIntf := nil;
    FEditorList.Delete(AIndex);
  end;
end;

end.



