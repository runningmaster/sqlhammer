////////////////////////////////////////////////////////////////////////////////
//
//  ****************************************************************************
//  * Project   : Fangorn Wizards Lab Exstension Library v1.35
//  * Unit Name : FWHint
//  * Purpose   : Класс модифицирующий стандартный Hint вашего приложения
//  * Author    : Александр (Rouse_) Багель
//  * Copyright : c Fangorn Wizards Lab 1998 - 2005.
//  * Version   : 1.03
//  ****************************************************************************
//

unit FWHint;


interface

uses
  Classes, Windows, Graphics, Forms, Controls, Messages;

const
  A0: array[0..11] of array[0..1] of Integer =
    ((0,0),(0,6),(1,6),(1,3),(5,7),(6,7),(7,6),
     (7,5),(3,1),(6,1),(6,0),(0,0));
  A1: array[0..11] of array[0..1] of Integer =
    ((7,0),(7,6),(6,6),(6,3),(2,7),(1,7),(0,6),
     (0,5),(4,1),(1,1),(1,0),(7,0));
  A2: array[0..11] of array[0..1] of Integer =
    ((0,7),(0,1),(1,1),(1,4),(5,0),(6,0),(7,1),
     (7,2),(3,6),(6,6),(6,7),(0,7));
  A3: array[0..11] of array[0..1] of Integer =
    ((7,7),(7,1),(6,1),(6,4),(2,0),(1,0),(0,1),
     (0,2),(4,6),(1,6),(1,7),(7,7));

type
  TFWHint = class(TComponent)
  private
    FAbout: String;
    FArrowBkColor: TColor;
    FArrowColor: TColor;
    FArrowPos: Byte;
    FBkColor: TColor;
    FBorderColor: TColor;
    FFont: TFont;
    FHintPause: Integer;
    FHintHidePause: Integer;
    FMaxSize: Integer;
    FTransparent: Boolean;
    FTransparentValue: Byte;
    FUseUNICODE: Boolean;
    FUnicodeHint: WideString;
    FOnShowHint: TShowHintEvent;
    procedure SetPause(const Index, Value: Integer);
    procedure SetFont(Value: TFont);
    procedure SetColors(const Index: Integer; const Value: TColor);
  protected
    procedure ShowHint(var HintStr: string; var CanShow: Boolean;
      var HintInfo: THintInfo);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property About: String read FAbout write FAbout;
    property ColorArrow: TColor index 0 read FArrowColor write SetColors default clBlack;
    property ColorArrowBackground: TColor index 1 read FArrowBkColor write SetColors default $0053D2FF;
    property ColorBackground: TColor index 2 read FBkColor write SetColors default clWhite;
    property ColorBorder: TColor index 3 read FBorderColor write SetColors default clBlack;
    property HintPause: Integer index 0 read FHintPause write SetPause default 500;
    property HintHidePause: Integer index 1 read FHintHidePause write SetPause default 5000;
    property Font: TFont read FFont write SetFont;
    property MaxSize: Integer read FMaxSize write FMaxSize default 120;
    property Transparent: Boolean read FTransparent write FTransparent default True;
    property TransparentValue: Byte read  FTransparentValue write FTransparentValue default 200;
    property OnShowHint: TShowHintEvent read FOnShowHint write FOnShowHint;
  end;

  TFWHintWindow = class(THintWindow)
  private
    FHint: TFWHint;
    FBlend, FSRC: TBitmap;
  protected
    procedure CreateParams (var Params: TCreateParams); override;
    procedure Paint; override;
    procedure Erase(var Message: TMessage); message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ActivateHint (HintRect: TRect; const AHint: string); Override;
  end;

  TRGB = record
    B, G, R: Byte;
  end;
  PRGB = ^TRGB;

implementation

uses Types, TypInfo, Variants;

{ TFWHint }

constructor TFWHint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHintPause := 500;
  FHintHidePause := 5000;
  FArrowBkColor := $0053D2FF;
  FArrowColor := clBlack;
  FBkColor := clWhite;
  FBorderColor := clBlack;
  FTransparent := True;
  FTransparentValue := 200;
  FMaxSize := 120;
  if not (csDesigning in ComponentState) then
  begin
    with Application do
    begin
      HintWindowClass := TFWHintWindow;
      HintShortPause :=  25;
      HintPause := 500;
      HintHidePause := 5000;
    end;
    Application.OnShowHint := ShowHint;
  end;
  FFont := TFont.Create;
end;

destructor TFWHint.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TFWHint.ShowHint(var HintStr: string; var CanShow: Boolean;
  var HintInfo: THintInfo);
begin
  FArrowPos := 0;
  with HintInfo.HintPos do
  begin
    if X > Screen.Width div 2 then Inc(FArrowPos);
    if Y > Screen.Height div 2 then Inc(FArrowPos, 2);
  end;
  if Assigned(FOnShowHint) then
    FOnShowHint(HintStr, CanShow, HintInfo);
end;

procedure TFWHint.SetColors(const Index: Integer; const Value: TColor);
begin
  case Index of
    0: FArrowColor := Value;
    1: FArrowBkColor := Value;
    2: FBkColor := Value;
    3: FBorderColor := Value;
  end;
end;

procedure TFWHint.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TFWHint.SetPause(const Index, Value: Integer);
begin
  case Index of
    0: FHintPause := Value;
    1: FHintHidePause := Value;
  end;
  if not (csDesigning in ComponentState) then
    with Application do
    begin
      OnShowHint := Self.ShowHint;
      HintPause := FHintPause;
      HintHidePause := FHintHidePause;
    end;
end;

{ TFWHintWindow }

procedure TFWHintWindow.ActivateHint(HintRect: TRect; const AHint: string);
var
  I: Integer;
  P: TPoint;
  HintControl: TControl;
  Info: PPropInfo;
begin
  FHint := nil;
  with Application.MainForm do
  begin
    for I:= 0 to ComponentCount - 1 do
      if Components[I] is TFWHint then
      begin
        FHint := TFWHint(Components[I]);
        Break;
      end;
  end;
  if not Assigned(FHint) then Exit;

  // Вот тут подрубаем поддержку UNICODE
  // Сначала смотрим, над каким компонентом находимся...
  FHint.FUnicodeHint := '';
  FHint.FUseUNICODE := False;
  GetCursorPos(P);
  HintControl := Screen.ActiveForm.ControlAtPos(
    Screen.ActiveForm.ScreenToClient(P), True, True);
  // Смотрим, какой тип у него имеет св-во Hint
  if HintControl <> nil then
  begin
    Info := GetPropInfo(HintControl, 'Hint');
    if Info <> nil then
      FHint.FUseUNICODE := Info^.PropType^.Kind = tkWString;
    if FHint.FUseUNICODE then
    begin
      FHint.Font.Assign(Screen.ActiveForm.Font);
      FHint.FUnicodeHint := VarToWideStr(GetPropValue(HintControl, 'Hint'));
    end;
  end;

  Caption := AHint;
  Canvas.Font := FHint.Font;
  FSRC.Canvas.Font := FHint.Font;

  if FHint.FUseUNICODE then
    DrawTextW(Canvas.Handle, PWChar(FHint.FUnicodeHint),
      Length(FHint.FUnicodeHint), HintRect, DT_CALCRECT or DT_NOPREFIX)
  else
    DrawText(Canvas.Handle, PChar(Caption), Length(Caption),
      HintRect, DT_CALCRECT or DT_NOPREFIX);

  if HintRect.Right - HintRect.Left > FHint.FMaxSize then
  begin
    HintRect.Right := HintRect.Left + FHint.FMaxSize;
    HintRect.Bottom := HintRect.Top + 1;
    
    if FHint.FUseUNICODE then
      DrawTextW(Canvas.Handle, PWChar(FHint.FUnicodeHint),
        Length(FHint.FUnicodeHint), HintRect, DT_CALCRECT or DT_WORDBREAK or DT_NOPREFIX)
    else
      DrawText(Canvas.Handle, PChar(Caption), Length(Caption),
        HintRect, DT_CALCRECT or DT_WORDBREAK or DT_NOPREFIX);
  end;
  GetCursorPos(P);
  case FHint.FArrowPos of
    0: OffsetRect(HintRect, (P.X + 12) - HintRect.Left,
      (P.Y + 12) - HintRect.Top);
    1: OffsetRect(HintRect, (P.X - 28) - HintRect.Right,
      (P.Y + 8) - HintRect.Top);
    2: OffsetRect(HintRect, (P.X + 8) - HintRect.Left,
      (P.Y - 8) - HintRect.Bottom);
    3: OffsetRect(HintRect, (P.X - 28) - HintRect.Right,
      (P.Y - 8) - HintRect.Bottom);
  end;
  Top := HintRect.Top;
  Left := HintRect.Left;
  Width := HintRect.Right- HintRect.Left + 24;
  Height := HintRect.Bottom - HintRect.Top + 4;
  FBlend.Width := Width;
  FBlend.Height := Height;
  FSRC.Width := Width;
  FSRC.Height := Height;
  if FHint.FTransparent then
    BitBlt(FBlend.Canvas.Handle, 0, 0, Width, Height,
      GetWindowDC(GetDesktopWindow), HintRect.Left, HintRect.Top, SRCCOPY);
  SetWindowPos(Handle, HWND_TOPMOST, Left, Top,
    0, 0, SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);
end;

constructor TFWHintWindow.Create(AOwner: TComponent);
begin
  inherited;
  FBlend := TBitmap.Create;
  FSRC := TBitmap.Create;
  FBlend.PixelFormat := pf24bit;
  FSRC.PixelFormat := pf24bit;
end;

procedure TFWHintWindow.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style - WS_BORDER;
  ControlStyle := [csOpaque]; 
end;

destructor TFWHintWindow.Destroy;
begin
  FBlend.Free;
  FSRC.Free;
  inherited;
end;

procedure TFWHintWindow.Erase(var Message: TMessage);
begin
  Message.Result := 0;
end;

procedure TFWHintWindow.Paint;

  function BLimit(B: Integer): Byte;
  begin
    if B < 0 then
      Result := 0
    else
      if B > 255 then
        Result := 255
      else
        Result := B;
  end;

var
  TmpRect: TRect;
  Arrow: array[0..11] of TPoint;
  I, Q: Integer;
  SRC, DEST: PRGB;
  NeedArrow: Boolean;
begin
  if not Assigned(FHint) then Exit;
  NeedArrow := True;
  with FSRC.Canvas do
  begin
    Brush.Color := FHint.FBkColor;
    Pen.Color := FHint.FBorderColor;
    Rectangle(GetClientRect);
    Pen.Color := FHint.Font.Color;
  end;
  case FHint.FArrowPos of
    0, 2:
    begin
      TmpRect := Rect(20, 2, Width, Height);

      if FHint.FUseUNICODE then
        DrawTextW(FSRC.Canvas.Handle, PWChar(FHint.FUnicodeHint),
          Length(FHint.FUnicodeHint), TmpRect, DT_WORDBREAK or DT_NOPREFIX)
      else
        DrawText(FSRC.Canvas.Handle, PChar(Caption), Length(Caption),
          TmpRect, DT_WORDBREAK or DT_NOPREFIX);

      TmpRect := Rect(1, 1, 15, Height - 1);
      FSRC.Canvas.Brush.Color := FHint.FArrowBkColor;
      FSRC.Canvas.FillRect(TmpRect);
      if FHint.FArrowPos = 0 then
      begin         
        {if Assigned(FHint.FCustomArrows.FLeftTop) then
        begin
          BitBlt(FSRC.Canvas.Handle, 2, 2, 12, 12,
            FHint.FCustomArrows.FLeftTop.Canvas.Handle,
            0, 0, SRCCOPY);
          NeedArrow := False;
        end
        else}
        for I:= 0 to 11 do
          Arrow[I] := Point(A0[I,0] + 3, A0[I, 1] + 3);
      end
      else
      begin
        {if Assigned(FHint.FCustomArrows.FLeftBottom) then
        begin
          BitBlt(FSRC.Canvas.Handle, 2, Height - 14, 12, 12,
            FHint.FCustomArrows.FLeftBottom.Canvas.Handle,
            0, 0, SRCCOPY);
          NeedArrow := False;
        end
        else }
        for I:= 0 to 11 do
          Arrow[I] := Point(A2[I,0] + 3, A2[I, 1] + Height - 10);
      end;
    end;
    1, 3:
    begin
      TmpRect := Rect(2, 2, Width - 20, Height);

      if FHint.FUseUNICODE then
        DrawTextW(FSRC.Canvas.Handle, PWChar(FHint.FUnicodeHint),
          Length(FHint.FUnicodeHint), TmpRect, DT_WORDBREAK or DT_NOPREFIX)
      else
        DrawText(FSRC.Canvas.Handle, PChar(Caption), Length(Caption),
          TmpRect, DT_WORDBREAK or DT_NOPREFIX);

      TmpRect := Rect(Width - 14, 1, Width - 1, Height - 1);
      FSRC.Canvas.Brush.Color := FHint.FArrowBkColor;
      FSRC.Canvas.FillRect(TmpRect);
      if FHint.FArrowPos = 1 then
      begin
        {if Assigned(FHint.FCustomArrows.FRightTop) then
        begin
          BitBlt(FSRC.Canvas.Handle, Width - 14, 2, 12, 12,
            FHint.FCustomArrows.FRightTop.Canvas.Handle,
            0, 0, SRCCOPY);
          NeedArrow := False;
        end
        else}
        for I:= 0 to 11 do
          Arrow[I] := Point(A1[I,0] + Width - 11, A1[I, 1] + 3)
      end
      else
      begin
        {if Assigned(FHint.FCustomArrows.FRightBottom) then
        begin
          BitBlt(FSRC.Canvas.Handle, Width - 14, Height - 14, 12, 12,
            FHint.FCustomArrows.FRightBottom.Canvas.Handle,
            0, 0, SRCCOPY);
          NeedArrow := False;
        end
        else}
        for I:= 0 to 11 do
          Arrow[I] := Point(A3[I,0] + Width - 11, A3[I, 1] + Height - 10);
      end;
    end;
  end;

  if NeedArrow then
  begin
    FSRC.Canvas.Brush.Color := FHint.FArrowColor;
    FSRC.Canvas.Pen.Color := FHint.FArrowColor; // Исправление ошибки
    FSRC.Canvas.Polygon(Arrow);
  end;

  if FHint.FTransparent then
  begin
    for I:= 0 to Height - 1 do
    begin
      DEST := FBlend.ScanLine[I];
      SRC := FSRC.ScanLine[I];
      for Q:= 0 to Width - 1 do
      begin
        SRC^.R := BLimit(MulDiv(SRC^.R,  FHint.FTransparentValue, 255)
          + MulDiv(DEST^.R, 255 - FHint.FTransparentValue, 255));
        SRC^.G := BLimit(MulDiv(SRC^.G, FHint.FTransparentValue, 255)
          + MulDiv(DEST^.G, 255 - FHint.FTransparentValue, 255));
        SRC^.B := BLimit(MulDiv(SRC^.B, FHint.FTransparentValue, 255)
          + MulDiv(DEST^.B, 255 - FHint.FTransparentValue, 255));
        Inc(DEST);
        Inc(SRC);
      end;
    end;
  end;
  BitBlt(Canvas.Handle, 0, 0, Width, Height, FSRC.Canvas.Handle, 0, 0, SRCCOPY);
end;

end.