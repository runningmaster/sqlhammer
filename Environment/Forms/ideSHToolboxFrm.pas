unit ideSHToolboxFrm;

interface

uses
  SHDesignIntf, ideSHDesignIntf,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Contnrs, pSHNetscapeSplitter;

type
  TToolboxForm = class(TSHComponentForm, IideSHToolbox)
    Panel1: TPanel;
    pSHNetscapeSplitter1: TpSHNetscapeSplitter;
    Panel2: TPanel;
    procedure pSHNetscapeSplitter1Moved(Sender: TObject);
  private
    { Private declarations }
    FPalette: TForm;
    FInspList: TObjectList;
    FInspector: TForm;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    procedure ReloadComponents;
    procedure InvalidateComponents;
    procedure SetToolboxPosition(ToBottom: Boolean);

    procedure _InspCreateForm(AComponent: TSHComponent);
    function _InspFindForm(AComponent: TSHComponent): TSHComponentForm;
    procedure _InspDestroyForm(AComponent: TSHComponent);
    procedure _InspHideForm(AComponent: TSHComponent);
    procedure _InspShowForm(AComponent: TSHComponent);
    procedure _InspRefreshForm(AComponent: TSHComponent);
    procedure _InspPrepareForm(AComponent: TSHComponent);
    procedure _InspAddAction(AAction: TSHAction);
    procedure _InspUpdateNodes;
  end;

var
  ToolboxForm: TToolboxForm;

implementation

uses
  ideSHConsts, ideSHSystem, ideSHSysUtils,
  ideSHComponentPageFrm,
  ideSHObjectInspectorFrm;

{$R *.dfm}

{ TToolboxForm }

constructor TToolboxForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  FPalette := TComponentPageForm.Create(Panel1, Panel1, Component, EmptyStr);
  FPalette.Visible := True;
  FInspList := TObjectList.Create;
  if Assigned(SystemOptionsIntf) then Panel2.Height := SystemOptionsIntf.IDE2Height;  
end;

destructor TToolboxForm.Destroy;
begin
  FPalette.Free;
  FInspector := nil;
  FInspList.Free;
  inherited Destroy;
end;

procedure TToolboxForm.ReloadComponents;
begin
  if Assigned(FPalette) then TComponentPageForm(FPalette).ReloadComponents;
end;

procedure TToolboxForm.InvalidateComponents;
begin
  if Assigned(FPalette) then TComponentPageForm(FPalette).Tree.Invalidate;
end;

procedure TToolboxForm.SetToolboxPosition(ToBottom: Boolean);
begin
  if ToBottom then
  begin
    pSHNetscapeSplitter1.Align := alNone;
    Panel2.Align := alBottom;
    Panel2.TabOrder := 1;
    pSHNetscapeSplitter1.Align := alBottom;
    Panel1.Align := alClient;
    Panel1.TabOrder := 0;
  end else
  begin
    pSHNetscapeSplitter1.Align := alNone;
    Panel2.Align := alTop;
    Panel2.TabOrder := 0;
    pSHNetscapeSplitter1.Align := alTop;
    Panel1.Align := alClient;
    Panel1.TabOrder := 1;
  end;
end;

procedure TToolboxForm._InspCreateForm(AComponent: TSHComponent);
begin
  FInspList.Add(TObjectInspectorForm.Create(Panel2, Panel2, AComponent, EmptyStr));
  if FInspList.Count > 0 then Panel2.BevelInner := bvNone;
end;

function TToolboxForm._InspFindForm(AComponent: TSHComponent): TSHComponentForm;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(FInspList.Count) do
  begin
    if TSHComponentForm(FInspList[I]).Component = AComponent then
    begin
      Result := TSHComponentForm(FInspList[I]);
      Break;
    end;
  end;
end;

procedure TToolboxForm._InspDestroyForm(AComponent: TSHComponent);
var
  Form: TForm;
begin
  Form := _InspFindForm(AComponent);
  if Assigned(Form) then
  begin
    FInspector := nil;
    FInspList.Remove(Form);
    if FInspList.Count = 0 then Panel2.BevelInner := bvLowered;
  end;
end;

procedure TToolboxForm._InspHideForm(AComponent: TSHComponent);
var
  Form: TForm;
begin
  Form := _InspFindForm(AComponent);
  if Assigned(Form) then Form.Hide;
end;

procedure TToolboxForm._InspShowForm(AComponent: TSHComponent);
var
  Form: TForm;
  I: Integer;
  WindowLocked: Boolean;
begin
  Form := _InspFindForm(AComponent);
  if Assigned(Form) then
  begin
    WindowLocked := LockWindowUpdate(GetDesktopWindow);
    try
      FInspector := Form;
      Form.Show;
      for I := 0 to Pred(FInspList.Count) do
        if TSHComponentForm(FInspList[I]).Component <> AComponent then
          TSHComponentForm(FInspList[I]).Hide;
    finally
      if WindowLocked then LockWindowUpdate(0);
    end;
  end;
end;

procedure TToolboxForm._InspRefreshForm(AComponent: TSHComponent);
begin

end;

procedure TToolboxForm._InspPrepareForm(AComponent: TSHComponent);
begin

end;

procedure TToolboxForm._InspAddAction(AAction: TSHAction);
begin
  if Assigned(FInspector) then
    TObjectInspectorForm(FInspector).AddAction(AAction);
end;

procedure TToolboxForm._InspUpdateNodes;
begin
  if Assigned(FInspector) then
    TObjectInspectorForm(FInspector).UpdateNodes;
end;

procedure TToolboxForm.pSHNetscapeSplitter1Moved(Sender: TObject);
begin
  if Assigned(SystemOptionsIntf) then SystemOptionsIntf.IDE2Height := Panel2.Height;
end;

end.
