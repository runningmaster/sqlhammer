unit pSHCommon;

interface

uses Classes, SysUtils, Windows, Forms, Controls, TypInfo, Graphics, ComCtrls,
     ExtCtrls,
     pSHIntf;

function DoCaseCode(const Value: string;
  ACodeCase: TpSHCaseCode): string;

procedure AntiLargeFont(AComponent: TComponent);

implementation

function DoCaseCode(const Value: string;
  ACodeCase: TpSHCaseCode): string;
var
  I: Integer;
  vNextPossible: Boolean;
begin
    Result := Value;
    case ACodeCase of
      ccUpper: Result := AnsiUpperCase(Result);
      ccLower: Result := AnsiLowerCase(Result);
      ccFirstUpper:
        begin
          if Length(Result) > 1 then
            Result := AnsiUpperCase(copy(Result, 1, 1)) + AnsiLowerCase(copy(Result, 2, Length(Result)))
          else
            Result := AnsiUpperCase(Result);
        end;
      ccNameCase:
        begin
          if length(Result) > 1 then
          begin
            vNextPossible := True;
            for I := 1 to Length(Result) do
            begin
              case Result[I] of
                ' ', '_': vNextPossible := True;
                else
                begin
                  if vNextPossible then
                  begin
                    vNextPossible := False;
                    Result[I] := Char(CharUpper(pointer(Result[I])));
                  end
                  else
                    Result[I] := Char(CharLower(pointer(Result[I])));
                end;
              end;
            end;
          end;
        end;
      ccInvert:
        begin
          for I := 1 to Length(Result) do
            if Result[I] = Char(CharLower(pointer(Result[I]))) then
              Result[I] := Char(CharUpper(pointer(Result[I])))
            else
              Result[I] := Char(CharLower(pointer(Result[I])));
        end;
    end;
end;

procedure AntiLargeFont(AComponent: TComponent);
var
  I: Integer;
  FontName: string;
begin
  FontName := 'Tahoma';
  if AComponent is TForm then TForm(AComponent).Scaled := False;

  for I := 0 to Pred(AComponent.ComponentCount) do
  begin
    if (AComponent.Components[I] is TControl) and IsPublishedProp(AComponent.Components[I], 'Font') then
      if TControl(AComponent.Components[I]).Tag <> -1 then
        TFont(GetObjectProp(AComponent.Components[I], 'Font')).Name := FontName;
    if (AComponent.Components[I] is TControl) and IsPublishedProp(AComponent.Components[I], 'TitleFont') then
      if TControl(AComponent.Components[I]).Tag <> -1 then
        TFont(GetObjectProp(AComponent.Components[I], 'TitleFont')).Name := FontName;
    if (AComponent.Components[I] is TComponent) then
      AntiLargeFont(AComponent.Components[I] as TComponent);

    if Screen.PixelsPerInch > 96 then
    begin
      if (AComponent.Components[I] is TToolBar) then
        TToolBar(AComponent.Components[I]).AutoSize := False;
      if (AComponent.Components[I] is TControlBar) then
        TControlBar(AComponent.Components[I]).RowSize := 32;
    end;
  end;
end;

end.
