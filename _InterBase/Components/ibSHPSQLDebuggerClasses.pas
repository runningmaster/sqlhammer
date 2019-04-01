unit ibSHPSQLDebuggerClasses;

interface

uses Classes, Variants, Contnrs;

type

  TVariableValueList = class(TStringList)
  private
    FDataTypes: TStringList;
    function GetValueByName(const AName: string): Variant;
    procedure SetValueByName(const AName: string; const Value: Variant);
    function GetValueByIndex(Index: Integer): Variant;
    procedure SetValueByIndex(Index: Integer; const Value: Variant);
    function GetDataTypeByName(const AName: string): string;
    function GetDataTypeByIndex(Index: Integer): string;

    function GetVarObject(const AName: string):TObject;
    procedure SetVarObject(const AName: string;VarObject:TObject);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignValues(Source: TVariableValueList);
    function AddObject(const S: string; AObject: TObject): Integer; override;
    function AddWithDataType(const AName, ADataType: string): Integer;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;



    property ValueByName[const AName: string]: Variant read GetValueByName
      write SetValueByName;
    property ValueByIndex[Index: Integer]: Variant read GetValueByIndex
      write SetValueByIndex;
    property DataTypeByName[const AName: string]: string read GetDataTypeByName;
    property DataTypeByIndex[Index: Integer]: string read GetDataTypeByIndex;
    property VarObject[const AName:string]:TObject read GetVarObject write SetVarObject;
  end;


implementation

uses SysUtils;

{ TVariableValueList }

constructor TVariableValueList.Create;
begin
  FDataTypes := TStringList.Create;
end;

destructor TVariableValueList.Destroy;
begin
  Clear;
  FDataTypes.Free;
  inherited Destroy;
end;

function TVariableValueList.GetValueByName(const AName: string): Variant;
var
  vIndex: Integer;
begin
  vIndex := IndexOf(AName);
  Assert((vIndex > -1) and (vIndex < Count), 'GetValueByName, Index out of bounds');
  if (vIndex > -1) and (vIndex < Count) then
    Result := PVariant(Objects[vIndex])^;
end;

procedure TVariableValueList.SetValueByName(const AName: string;
  const Value: Variant);
var
  vIndex: Integer;
begin
  vIndex := IndexOf(AName);
  Assert((vIndex > -1) and (vIndex < Count), 'SetValueByName, Index out of bounds');
  if (vIndex > -1) and (vIndex < Count) then
    PVariant(Objects[vIndex])^ := Value;
end;

function TVariableValueList.GetValueByIndex(Index: Integer): Variant;
begin
  Assert((Index > -1) and (Index < Count), 'GetValueByIndex, Index out of bounds');
  if (Index > -1) and (Index < Count) then
    Result := PVariant(Objects[Index])^;
end;

procedure TVariableValueList.SetValueByIndex(Index: Integer;
  const Value: Variant);
begin
  Assert((Index > -1) and (Index < Count), 'SetValueByIndex, Index out of bounds');
  if (Index > -1) and (Index < Count) then
    PVariant(Objects[Index])^ := Value;
end;

function TVariableValueList.GetDataTypeByName(const AName: string): string;
var
  vIndex: Integer;
begin
  vIndex := IndexOf(AName);
  Assert((vIndex > -1) and (vIndex < Count), 'GetDataTypeByName, Index out of bounds');
  if (vIndex > -1) and (vIndex < Count) then
    Result := FDataTypes[vIndex];
end;

function TVariableValueList.GetDataTypeByIndex(Index: Integer): string;
begin
  Assert((Index > -1) and (Index < Count), 'GetDataTypeByIndex, Index out of bounds');
  if (Index > -1) and (Index < Count) then
    Result := FDataTypes[Index];
end;

procedure TVariableValueList.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TVariableValueList then
    FDataTypes.Assign(TVariableValueList(Source).FDataTypes);
end;

procedure TVariableValueList.AssignValues(Source: TVariableValueList);
var
  I: Integer;
  vIndex: Integer;
begin
  for I := 0 to Pred(Count) do
  begin
    vIndex := Source.IndexOf(Strings[I]);
    if vIndex > -1 then
      ValueByIndex[I] := Source.ValueByIndex[vIndex];
  end;
end;


function TVariableValueList.AddObject(const S: string;
  AObject: TObject): Integer;
var
  vNewValue: PVariant;
  vOldValue: PVariant;
begin
  Result := Count;
  New(vNewValue);
  if Assigned(AObject) then
  begin
    vOldValue := PVariant(AObject);
    VarCopy(vNewValue^, vOldValue^);
  end;
  InsertItem(Result, S, pointer(vNewValue));
//  PutObject(Result, pointer(vNewValue));
end;


function TVariableValueList.AddWithDataType(const AName,
  ADataType: string): Integer;
var
  vDataType: string;
  vValue: string;
  vEqPos: Integer;

begin
  Result := Add(AName);
  if (Length(ADataType)>0) and (ADataType[1]='"') then
   vDataType:=ADataType
  else
   vDataType:=UpperCase(ADataType);

  if (Copy(vDataType,1,11)='CURSOR FOR ') then
  begin
      FDataTypes.Add('CURSOR');
      vValue:=Copy(ADataType,13,MaxInt);
      SetLength(vValue,Length(vValue)-1);
      vValue:=Trim(vValue);
      vDataType:=Copy(vValue,Length(vValue)-6,MaxInt);
      if UpperCase(Copy(vValue,Length(vValue)-6,MaxInt))<>' UPDATE' then
      begin
       if UpperCase(Copy(vValue,Length(vValue)-4,MaxInt))<>' LOCK' then
        ValueByIndex[Result]:=vValue+ ' FOR UPDATE'
       else
        ValueByIndex[Result]:=vValue
      end  
      else
       ValueByIndex[Result]:=vValue
  end
  else
  begin
  //Обработка инициализации переменной в Firebird (f.e. DECLARE VARIABLE VAR_I INTEGER = 0;)
   vEqPos := Pos('=', ADataType);
   if vEqPos > 0 then 
   begin
      vDataType := Trim(Copy(ADataType, 1, vEqPos - 1));
      if (Length(vDataType)>0) and (vDataType[1]<>'"') then
       vDataType:=UpperCase(vDataType);
     
      FDataTypes.Add(vDataType);
      vValue := Trim(Copy(ADataType, vEqPos + 1, Length(ADataType) - vEqPos));
      if Length(vValue) > 0 then
      begin
        if (vValue[1] in ['N','n']) and (UpperCase(vValue)='NULL')  then
        ValueByIndex[Result] := null
        else
        if (Length(vValue) > 1) and (vValue[1] = '''') and (vValue[Length(vValue)] = '''') then
        begin
          if (Length(vValue) = 2) then
            ValueByIndex[Result] := EmptyStr
          else
            ValueByIndex[Result] := Copy(vValue, 2, Length(vValue) - 2);
        end
        else
        if Pos('.', vValue) > 0 then
          ValueByIndex[Result] := StrToFloatDef(vValue, 0)
        else
          ValueByIndex[Result] := StrToIntDef(vValue, 0)
      end
    end
    else
     FDataTypes.Add(vDataType);
  end
end;

procedure TVariableValueList.Clear;
var
  I: Integer;
begin
  for I := Pred(Count) downto 0 do
    if Objects[I] <> nil then
      Dispose(PVariant(Objects[I]));

  for I := Pred(FDataTypes.Count) downto 0 do
  if FDataTypes.Objects[I]<>nil then
  begin
   FDataTypes.Objects[I].Free;
  end;
  FDataTypes.Clear;
  inherited Clear;
end;

procedure TVariableValueList.Delete(Index: Integer);
begin
  Assert((Index > -1) and (Index < Count), 'Delete, Index out of bounds');
  if (Index > -1) and (Index < Count) then
    Dispose(PVariant(Objects[Index]));
  inherited Delete(Index);
end;

function TVariableValueList.GetVarObject(const AName: string): TObject;
var
    Index:integer;
begin
   Index:=IndexOf(AName);
   if Index>-1 then
    Result:=FDataTypes.Objects[Index]
   else
    raise Exception.Create('Variable "'+AName+'" don''t exist');
end;

procedure TVariableValueList.SetVarObject(const AName: string;
  VarObject: TObject);
var
    Index:integer;
begin
   Index:=IndexOf(AName);
   if Index>-1 then
    FDataTypes.Objects[Index]:=VarObject
   else
    raise Exception.Create('Variable "'+AName+'" don''t exist');
end;

end.
