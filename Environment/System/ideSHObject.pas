unit ideSHObject;

interface

uses
  Messages, SysUtils, Classes, Controls, Graphics, ComCtrls, CommCtrl, ExtCtrls,
  Types, VirtualTrees,
  SHDesignIntf, ideSHDesignIntf;

type
  TideBTObject = class(TComponent, IideBTObject)
  private
    FEnabled: Boolean;
    FFlat: Boolean;
    FPageCtrl: TPageControl;
    FPageCtrlWndProc: TWndMethod;
    FTree: TVirtualStringTree;
    procedure PageCtrlWndProc(var Message: TMessage);
  protected
    function GetCurrentComponent: TSHComponent; virtual;
    function GetEnabled: Boolean;
    procedure SetEnabled(Value: Boolean); virtual;
    function GetFlat: Boolean;
    procedure SetFlat(Value: Boolean);
    function GetPageCtrl: TPageControl;
    procedure SetPageCtrl(Value: TPageControl);

    function Exists(AComponent: TSHComponent): Boolean; virtual;
    function Add(AComponent: TSHComponent): Boolean; virtual;
    function Remove(AComponent: TSHComponent): Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property CurrentComponent: TSHComponent read GetCurrentComponent;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Flat: Boolean read GetFlat write SetFlat;
    property PageCtrl: TPageControl read GetPageCtrl write SetPageCtrl;
    property Tree: TVirtualStringTree read FTree write FTree;
  end;

implementation

{ TideBTObject }

constructor TideBTObject.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TideBTObject.Destroy;
begin
  inherited Destroy;
end;

procedure TideBTObject.PageCtrlWndProc(var Message: TMessage);
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

function TideBTObject.GetCurrentComponent: TSHComponent;
begin
  Result := nil;
end;

function TideBTObject.GetEnabled: Boolean;
begin
  Result := FEnabled;
end;

function TideBTObject.GetFlat: Boolean;
begin
  Result := FFlat;
end;

procedure TideBTObject.SetFlat(Value: Boolean);
begin
  FFlat := Value;
  if FFlat then
  begin
    if Assigned(FPageCtrl) then
    begin
      FPageCtrlWndProc := FPageCtrl.WindowProc;
      FPageCtrl.WindowProc := PageCtrlWndProc;
    end;
  end else
  begin
    if Assigned(FPageCtrl) then
    begin
      FPageCtrlWndProc := FPageCtrl.WindowProc;
      FPageCtrl.WindowProc := FPageCtrlWndProc;
    end;
  end;
end;

function TideBTObject.GetPageCtrl: TPageControl;
begin
  Result := FPageCtrl;
end;

procedure TideBTObject.SetPageCtrl(Value: TPageControl);
begin
  FPageCtrl := Value;
end;

procedure TideBTObject.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
end;

function TideBTObject.Exists(AComponent: TSHComponent): Boolean;
begin
  Result := False;
end;

function TideBTObject.Add(AComponent: TSHComponent): Boolean;
begin
  Result := False;
end;

function TideBTObject.Remove(AComponent: TSHComponent): Boolean;
begin
  Result := False;
end;

end.
