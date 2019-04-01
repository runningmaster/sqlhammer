unit pBTGridEhExt;

interface

uses
 Windows,Messages,SysUtils,Classes,Controls,Forms,DB,DBGridEh,GridsEh,TntStdCtrls;

 procedure PrepareDBGridEh(Grid:TDBGridEh);

implementation

var IsWinNT:boolean;
    IsWin2K:boolean;
    IsWinXP:boolean;

const
  WideNull = WideChar(#0);
  WideCR = WideChar(#13);
  WideLF = WideChar(#10);
  WideLineSeparator = WideChar(#2028);


procedure DrawTextW(DC: HDC; lpString: PWideChar; nCount: Integer; var lpRect: TRect; uFormat: Cardinal;
  AdjustRight: Boolean);

// This procedure implements a subset of Window's DrawText API for Unicode which is not available for
// Windows 9x. For a description of the parameters see DrawText in the online help.
// Supported flags are currently:
//   - DT_LEFT
//   - DT_TOP
//   - DT_CALCRECT
//   - DT_NOCLIP
//   - DT_RTLREADING
//   - DT_SINGLELINE
//   - DT_VCENTER
// Differences to the DrawTextW Windows API:
//   - The additional parameter AdjustRight determines whether to adjust the right border of the given rectangle to
//     accomodate the largest line in the text. It has only a meaning if also DT_CALCRECT is specified.

var
  Head, Tail: PWideChar;
  Size: TSize;
  MaxWidth: Integer;
  TextOutFlags: Integer;
  TextAlign,
  OldTextAlign: Cardinal;
  TM: TTextMetric;
  TextHeight: Integer;
  LineRect: TRect;
  TextPosY,
  TextPosX: Integer;

  CalculateRect: Boolean;

begin
  // Prepare some work variables.
  MaxWidth := 0;
  Head := lpString;
  GetTextMetrics(DC, TM);
  TextHeight := TM.tmHeight;
  if uFormat and DT_SINGLELINE <> 0 then
    LineRect := lpRect
  else
    LineRect := Rect(lpRect.Left, lpRect.Top, lpRect.Right, lpRect.Top + TextHeight);

  CalculateRect := uFormat and DT_CALCRECT <> 0;

  // Prepare text output.
  TextOutFlags := 0;
  if uFormat and DT_NOCLIP = 0 then
    TextOutFlags := TextOutFlags or ETO_CLIPPED;
  if uFormat and DT_RTLREADING <> 0 then
    TextOutFlags := TextOutFlags or ETO_RTLREADING;

  // Determine horizontal and vertical text alignment.
  OldTextAlign := GetTextAlign(DC);
  TextAlign := TA_LEFT or TA_TOP;
  TextPosX := lpRect.Left;       
  if uFormat and DT_RIGHT <> 0 then
  begin
    TextAlign := TextAlign or TA_RIGHT and not TA_LEFT;
    TextPosX := lpRect.Right;
  end
  else
    if uFormat and DT_CENTER <> 0 then
    begin
      TextAlign := TextAlign or TA_CENTER and not TA_LEFT;
      TextPosX := (lpRect.Left + lpRect.Right) div 2;
    end;

  TextPosY := lpRect.Top;
  if uFormat and DT_VCENTER <> 0 then
  begin
    // Note: vertical alignment does only work with single line text ouput!
    TextPosY := (lpRect.Top + lpRect.Bottom - TextHeight) div 2;
  end;
  SetTextAlign(DC, TextAlign);

  if uFormat and DT_SINGLELINE <> 0 then
  begin
    if CalculateRect then
    begin
      GetTextExtentPoint32W(DC, Head, nCount, Size);
      if Size.cx > MaxWidth then
        MaxWidth := Size.cx;
    end
    else
      ExtTextOutW(DC, TextPosX, TextPosY, TextOutFlags, @LineRect, Head, nCount, nil);
    OffsetRect(LineRect, 0, TextHeight);
  end
  else
  begin
    while (nCount > 0) and (Head^ <> WideNull) do
    begin
      Tail := Head;
      // Look for the end of the current line. A line is finished either by the string end or a line break.
      while (nCount > 0) and not (Tail^ in [WideNull, WideCR, WideLF]) and (Tail^ <> WideLineSeparator) do
      begin
        Inc(Tail);
        Dec(nCount);
      end;

      if CalculateRect then
      begin
        GetTextExtentPoint32W(DC, Head, Tail - Head, Size);
        if Size.cx > MaxWidth then
          MaxWidth := Size.cx;
      end
      else
        ExtTextOutW(DC, TextPosX, LineRect.Top, TextOutFlags, @LineRect, Head, Tail - Head, nil);
      OffsetRect(LineRect, 0, TextHeight);

      // Get out of the loop if the rectangle is filled up.
      if (nCount = 0) or (not CalculateRect and (LineRect.Top >= lpRect.Bottom)) then
        Break;

      if (nCount > 0) and (Tail^ = WideCR) or (Tail^ = WideLineSeparator) then
      begin
        Inc(Tail);
        Dec(nCount);
      end;

      if (nCount > 0) and (Tail^ = WideLF) then
      begin
        Inc(Tail);
        Dec(nCount);
      end;
      Head := Tail;
    end;
  end;

  SetTextAlign(DC, OldTextAlign);
  if CalculateRect then
  begin
    if AdjustRight then
      lpRect.Right := lpRect.Left + MaxWidth;
    lpRect.Bottom := LineRect.Top;
  end;
end;
    
type
    TFakeObj=class
      procedure DBGridEh1DrawDataCell(Sender: TObject;
       const Rect: TRect; Field: TField; State: TGridDrawState);
     end;


procedure TFakeObj.DBGridEh1DrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);
var
   DrawFormat: Cardinal;
   Text:WideString;
   R:TRect;
begin
// Показ уникод значений
 with TDBGridEh(Sender) do
 begin
  if (Field<>nil) and (Field is TWideStringField) and not Field.IsNull then
  begin
   TDBGridEh(Sender).DefaultDrawDataCell(Rect,nil,State);
   Text:=TWideStringField(Field).Value;
   case Field.Alignment of
    taLeftJustify: DrawFormat := DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX;
    taCenter     : DrawFormat := DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX;
    taRightJustify:     DrawFormat := DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX  ;
   else
    DrawFormat := DT_NOPREFIX or DT_VCENTER or DT_SINGLELINE;
   end;
   R:=Rect;
   Inc(R.Left,2);
   if IsWinNT then
    Windows.DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), R, DrawFormat)
   else
    DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), R, DrawFormat, False)
  end
  else
    TDBGridEh(Sender).DefaultDrawDataCell(Rect,Field,State);
 end;
end;

var
  FakeObj:TFakeObj;
  
 procedure PrepareDBGridEh(Grid:TDBGridEh);
 begin
  Grid.OnDrawDataCell:=FakeObj.DBGridEh1DrawDataCell
 end;
// Cut from RxLib

{ SetVirtualMethodAddress procedure. Destroy destructor has index 0,
  first user defined virtual method has index 1. }

type
  PPointer = ^Pointer;

function GetVirtualMethodAddress(AClass: TClass; AIndex: Integer): Pointer;
var
  Table: PPointer;
begin
  Table := PPointer(AClass);
  Inc(Table, AIndex - 1);
  Result := Table^;
end;

function SetVirtualMethodAddress(AClass: TClass; AIndex: Integer;
  NewAddress: Pointer): Pointer;
{$IFDEF WIN32}
const
  PageSize = SizeOf(Pointer);
{$ENDIF}
var
  Table: PPointer;
{$IFDEF WIN32}
  SaveFlag: DWORD;
{$ELSE}
  Block: Pointer;
{$ENDIF}
begin
  Table := PPointer(AClass);
  Inc(Table, AIndex - 1);
  Result := Table^;
{$IFDEF WIN32}
  if VirtualProtect(Table, PageSize, PAGE_EXECUTE_READWRITE, @SaveFlag) then
  try
    Table^ := NewAddress;
  finally
    VirtualProtect(Table, PageSize, SaveFlag, @SaveFlag);
  end;
{$ELSE}
  PtrRec(Block).Ofs := PtrRec(Table).Ofs;
  PtrRec(Block).Seg := AllocCSToDSAlias(PtrRec(Table).Seg);
  try
    PPointer(Block)^ := NewAddress;
  finally
    FreeSelector(PtrRec(Block).Seg);
  end;
{$ENDIF}
end;

function FindVirtualMethodIndex(AClass: TClass; MethodAddr: Pointer): Integer;
begin
  Result := 0;
  repeat
    Inc(Result);
  until (GetVirtualMethodAddress(AClass, Result) = MethodAddr);
end;
/// end RX

type THackDBGridEh = class (TDBGridEh)
                     protected
                       procedure ShowEditor; override;
                     end;

     TWideEditor  = class(TTntEdit)
     private
      FGrid: THackDBGridEh;
      FOldValue:WideString;
      procedure InternalMove(const Loc: TRect; Redraw: Boolean);
     protected
      procedure BoundsChanged; virtual;
      procedure Hide;
      procedure KeyDown(var Key: Word; Shift: TShiftState); override;
      procedure KeyPress(var Key: Char); override;      
      procedure DoExit; override;
      procedure DoOnChange(Sender:TObject);
     public
      procedure Invalidate; reintroduce;
      function Visible: Boolean;
     end;

var
    SavedShowEditorMethod:Pointer;

procedure HookGridEditor;
var
  I: Integer;
  Addr: Pointer;
begin
  I := FindVirtualMethodIndex(THackDBGridEh, @THackDBGridEh.ShowEditor);
  try
    Addr :=@THackDBGridEh.ShowEditor;
    SavedShowEditorMethod:=SetVirtualMethodAddress(TDBGridEh, I, Addr);
  except
    raise;
  end;
end;

procedure UnHookGridEditor;
var
  MethodIndex: Integer;
begin
  if Assigned(SavedShowEditorMethod) then begin
    MethodIndex := FindVirtualMethodIndex(THackDBGridEh, @THackDBGridEh.ShowEditor);
    SetVirtualMethodAddress(TDBGridEh, MethodIndex, SavedShowEditorMethod);
    SavedShowEditorMethod := nil;
  end;
end;
{ THackDBGridEh }



procedure THackDBGridEh.ShowEditor;
var
   CurRect:TRect;
   FEdit:TWideEditor;
begin
  if FilterEditMode then
    StopEditFilter;
  if (SelectedField=nil) or (SelectedField.DataType<>ftWideString) then
   inherited
  else
  begin
   FEdit:=TWideEditor(FindComponent('WideEditor'));
   if not Assigned(FEdit) then
   begin
    FEdit:=TWideEditor.Create(Self);
    FEdit.Parent:=Self;
    FEdit.Name:='WideEditor';
    FEdit.BorderStyle:=bsNone;
    FEdit.FGrid:=Self;
    TTntEdit(FEdit).Visible:=False;
    TTntEdit(FEdit).OnChange:=FEdit.DoOnChange;
   end;
   FEdit.FOldValue :=TWideStringField(SelectedField).Value;
   FEdit.Text:=FEdit.FOldValue ;

   FEdit.Parent:=Self;
   CurRect:=CellRect(Col, Row);
   FEdit.InternalMove(CurRect,True);
  end;
end;

{ TWideEditor }

procedure TWideEditor.BoundsChanged;
var
  R: TRect;
begin
  R := Rect(2, 2, Width - 2, Height);
//  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@R));
  SendMessage(Handle, EM_SETRECTNP, 0, Integer(@R));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TWideEditor.DoExit;
begin
  if ( FGrid.DataLink.DataSet.State in [dsEdit,dsInsert]) then
   TWideStringField(FGrid.SelectedField).Value:=Text;
  Hide;
  inherited;
end;

procedure TWideEditor.DoOnChange(Sender: TObject);
begin
  if FOldValue<>Text then
  begin
   if not( FGrid.DataLink.DataSet.State in [dsEdit,dsInsert]) then
    FGrid.DataLink.Edit;
    TWideStringField(FGrid.SelectedField).Value:=Text;
  end;
end;

procedure TWideEditor.Hide;
begin
  if HandleAllocated and IsWindowVisible(Handle) then
  begin
    Invalidate;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOZORDER or
      SWP_NOREDRAW);
    if Focused then Windows.SetFocus(FGrid.Handle);
  end;
end;

procedure TWideEditor.InternalMove(const Loc: TRect; Redraw: Boolean);
begin
  if IsRectEmpty(Loc) then Hide
  else
  begin
    CreateHandle;
    Redraw := Redraw or not IsWindowVisible(Handle);
    Invalidate;
    with Loc do
      SetWindowPos(Handle, HWND_TOP, Left, Top, Right - Left, Bottom - Top,
        SWP_SHOWWINDOW or SWP_NOREDRAW);
    BoundsChanged;
    if Redraw then Invalidate;
    if FGrid.Focused then
      Windows.SetFocus(Handle);
  end;
end;

procedure TWideEditor.Invalidate;
var
  Cur: TRect;
begin
  ValidateRect(Handle, nil);
  InvalidateRect(Handle, nil, True);
  Windows.GetClientRect(Handle, Cur);
  MapWindowPoints(Handle, FGrid.Handle, Cur, 2);
  ValidateRect(FGrid.Handle, @Cur);
  InvalidateRect(FGrid.Handle, @Cur, False);
end;

procedure TWideEditor.KeyDown(var Key: Word; Shift: TShiftState);
  procedure SendToParent;
  begin
    FGrid.KeyDown(Key, Shift);
    Key := 0;
  end;
begin
  inherited;
  case Key of
   VK_RETURN:
   begin
    Hide;
    SendToParent;
   end;
   VK_ESCAPE:
    begin
     if ( FGrid.DataLink.DataSet.State in [dsEdit,dsInsert]) then
     begin
         Text:=FOldValue
     end ;
     Hide
    end;
   VK_UP,VK_DOWN:
   begin
     Hide;
     SendToParent;     
   end;
  end
end;

procedure TWideEditor.KeyPress(var Key: Char);
begin
  inherited;
end;

function TWideEditor.Visible: Boolean;
begin
  Result := IsWindowVisible(Handle);
end;

initialization
  IsWinNT := (Win32Platform and VER_PLATFORM_WIN32_NT) <> 0;
  IsWin2K := (Win32MajorVersion = 5) and (Win32MinorVersion = 0);
  IsWinXP := (Win32MajorVersion = 5) and (Win32MinorVersion = 1);


  SavedShowEditorMethod := nil;  
  HookGridEditor;
  FakeObj:=TFakeObj.Create;
finalization
  UnHookGridEditor;
  FakeObj.Free
end.


