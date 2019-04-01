unit ibSHValues;

interface

uses
  SysUtils, Classes, StrUtils,
  ibSHDesignIntf;


function FormatProps(const Args: array of string): string;

function GetGUIModes: string;

function FormatSQL(const SQL: array of string): string;
function IntToBoolean(const Value: Integer): Boolean;
function IntToBooleanInvers(const Value: Integer): Boolean;

// for Server
function GetServerVersionIB: string;
function GetServerVersionFB: string;
function GetProtocol: string;

// for Database
function GetDialect(With2: Boolean = False): string;
function GetPageSize: string;

// for Domain
function GetDomainList: string;
function GetDataTypeD1: string;   { IB5 and > with Dialect 1 }
function GetDataTypeD3: string;   { IB6 and > with Dialect 3 < IB7/FB15}
function GetDataTypeIB70: string;
function GetDataTypeFB15: string;

function GetFieldTypeID(const AType: string): Integer;

function Get_SMALLINT(var Precision: Integer; Scale, SubTypeID: Integer; Ext: Boolean = False): string;
function Get_INTEGER(var Precision: Integer; Scale, SubTypeID: Integer; Ext: Boolean = False): string;
function Get_BIGINT(var Precision: Integer; Scale, SubTypeID: Integer; Ext: Boolean = False): string;
function Get_BOOLEAN: string;
function Get_FLOAT(var Precision: Integer; Scale: Integer; Ext: Boolean = False): string;
function Get_DOUBLE(var Precision: Integer; Scale: Integer; Ext: Boolean = False): string;
function Get_DATE: string;
function Get_TIME: string;
function Get_TIMESTAMP(Dialect: Integer): string;
function Get_CHAR(Length: Integer; Ext: Boolean = False): string;
function Get_VARCHAR(Length: Integer; Ext: Boolean = False): string;
function Get_BLOB(const SubTypeID, SegmentSize: Integer; Ext: Boolean = False): string;
function Get_CSTRING(Length: Integer; Ext: Boolean = False): string;
function Get_QUAD: string;

function GetCharsetFB10: string;
function GetCharsetFromIDFB10(const CharsetID: Integer): string;
function GetIDFromCharsetFB10(const Charset: string): Integer;
function GetCollateFB10: string;
function GetCollateFromIDFB10(const CharsetID, CollateID: Integer): string; overload;
function GetCollateFromIDFB10(const CharsetID: Integer): string; overload;
function GetIDFromCollateFB10(const Charset, Collate: string): Integer;

function GetCharsetFB15: string;
function GetCharsetFromIDFB15(const CharsetID: Integer): string;
function GetIDFromCharsetFB15(const Charset: string): Integer;
function GetCollateFB15: string;
function GetCollateFromIDFB15(const CharsetID, CollateID: Integer): string; overload;
function GetCollateFromIDFB15(const CharsetID: Integer): string; overload;
function GetIDFromCollateFB15(const Charset, Collate: string): Integer;


function GetCharsetFB20: string;
function GetCharsetFB21: string;
function GetCharsetFromIDFB20(const CharsetID: Integer): string;
function GetCharsetFromIDFB21(const CharsetID: Integer): string;
function GetIDFromCharsetFB20(const Charset: string): Integer;
function GetIDFromCharsetFB21(const Charset: string): Integer;
function GetCollateFB20: string;
function GetCollateFB21: string;
function GetCollateFromIDFB20(const CharsetID, CollateID: Integer): string; overload;
function GetCollateFromIDFB20(const CharsetID: Integer): string; overload;
function GetIDFromCollateFB20(const Charset, Collate: string): Integer;

function GetCollateFromIDFB21(const CharsetID, CollateID: Integer): string; overload;
function GetCollateFromIDFB21(const CharsetID: Integer): string; overload;
function GetIDFromCollateFB21(const Charset, Collate: string): Integer;



function GetCharsetIB70: string;
function GetCharsetFromIDIB70(const CharsetID: Integer): string;
function GetIDFromCharsetIB70(const Charset: string): Integer;
function GetCollateIB70: string;
function GetCollateFromIDIB70(const CharsetID, CollateID: Integer): string; overload;
function GetCollateFromIDIB70(const CharsetID: Integer): string; overload;
function GetIDFromCollateIB70(const Charset, Collate: string): Integer;

function GetCharsetIB71: string;
function GetCharsetFromIDIB71(const CharsetID: Integer): string;
function GetIDFromCharsetIB71(const Charset: string): Integer;
function GetCollateIB71: string;
function GetCollateFromIDIB71(const CharsetID, CollateID: Integer): string; overload;
function GetCollateFromIDIB71(const CharsetID: Integer): string; overload;
function GetIDFromCollateIB71(const Charset, Collate: string): Integer;

function GetCharsetIB75: string;
function GetCharsetFromIDIB75(const CharsetID: Integer): string;
function GetIDFromCharsetIB75(const Charset: string): Integer;
function GetCollateIB75: string;
function GetCollateFromIDIB75(const CharsetID, CollateID: Integer): string; overload;
function GetCollateFromIDIB75(const CharsetID: Integer): string; overload;
function GetIDFromCollateIB75(const Charset, Collate: string): Integer;

function GetBlobSubType: string;
function BlobSubTypeToID(const SubType: string): Integer;
function IDToBlobSubType(const SubTypeID: Integer): string;
function GetPrecision: string;
function GetScale: string;
function GetNullType: string;

// for Index
function GetSorting: string;
function GetIndexType: string;

// for Constraint
function GetConstraintType: string;
function GetConstraintRule: string;

// for Trigger
function GetTableList: string;
function GetStatus: string;
function GetTypePrefix: string;
function GetTypeSuffixIB: string;   { IB, FB 1.0 }
function GetTypeSuffixFB: string;   { YA, FB 1.5 }

function GetTypePrefixFB21: string;
function GetTypeSuffixFB21: string;   
// for UDF
function GetMechanism: string;

// for SQL Editor
function GetAfterExecute: string;
function GetResultType: string;
function GetIsolationLevel: string;
function GetTransactionParams(AIsolationLevel, ATransactionParams: string): string;

// for SQL Player
function GetDefaultSQLDialect: string;

// for Grant Manager
function GetPrivilegesFor: string;
function GetGrantsOn: string;
function GetDisplayGrants: string;

// for User Manager
function GetAccessMode: string;

// for DML Optoions
function GetConfirmEndTransaction: string;
function GetDefaultTransactionAction: string;

function GUIDToName(const ClassIID: TGUID; Index: Integer = 0): string;
function GetHintLeftPart(const Hint: string; Separator: string = '|'): string;
function GetHintRightPart(const Hint: string; Separator: string = '|'): string;
function IsSystemDomain(const S: string): Boolean;
function IsSystemIndex(const S: string): Boolean;

//Data transformation
function msToStr(AMiliseconds: Integer): string;

//Files routins
function AddToTextFile(const AFileName, AText: string): Boolean;

// for Services
function GetStopAfter: string;
function GetShutdownMode: string;
function GetGlobalAction: string;

implementation

uses
  ibSHConsts, ibSHMessages;

function FormatProps(const Args: array of string): string;
var
  I: Integer;
  Values: TStrings;
begin
  Values := TStringList.Create;
  try
    for I := Low(Args) to High(Args) do
      if Length(Args[I]) > 0 then Values.Add(Args[I]);
    Result := Values.Text;
  finally
    Values.Free;
  end;
end;

function GetGUIModes: string;
begin
  Result := FormatProps(GUIModes);
end;

function FormatSQL(const SQL: array of string): string;
begin
  Result := FormatProps(SQL);
end;

function IntToBoolean(const Value: Integer): Boolean;
begin
  Result := Value <> 0;
end;

function IntToBooleanInvers(const Value: Integer): Boolean;
begin
  Result := not IntToBoolean(Value);
end;

function GetServerVersionIB: string;
begin
  Result := FormatProps(ServerVersionsIB);
end;

function GetServerVersionFB: string;
begin
  Result := FormatProps(ServerVersionsFB);
end;

function GetProtocol: string;
begin
  Result := FormatProps(Protocols);
end;

function GetDialect(With2: Boolean = False): string;
begin
  if With2 then
    Result := FormatProps(Dialects2)
  else
    Result := FormatProps(Dialects);
end;

function GetPageSize: string;
begin
  Result := FormatProps(PageSizes);
end;

function GetDomainList: string;
begin
  Result := EmptyStr;
  // TODO прямо из редактора надо заполнить, потянувшись куда следует
end;

function GetDataTypeD1: string;
begin
  Result := FormatProps(DataTypes[1]);
end;

function GetDataTypeD3: string;
begin
  Result := FormatProps(DataTypes[2]);
end;

function GetDataTypeIB70: string;
begin
  Result := FormatProps(DataTypes[3]);
end;

function GetFieldTypeID(const AType: string): Integer;
begin
  Result := 0;
  if AnsiContainsText(AType, 'SMALLINT') then Result := _SMALLINT;
  if AnsiContainsText(AType, 'INTEGER') then Result := _INTEGER;
  if AnsiContainsText(AType, 'BIGINT') then Result := _BIGINT;
  if AnsiContainsText(AType, 'BOOLEAN') then Result := _BOOLEAN;
  if AnsiContainsText(AType, 'FLOAT') then Result := _FLOAT;
  if AnsiContainsText(AType, 'DOUBLE') then Result := _DOUBLE;
  if AnsiContainsText(AType, 'NUMERIC') then Result := _DOUBLE; //
  if AnsiContainsText(AType, 'DECIMAL') then Result := _DOUBLE; //
  if AnsiContainsText(AType, 'DATE') then Result := _DATE;
  if AnsiContainsText(AType, 'TIME') then Result := _TIME;
  if AnsiContainsText(AType, 'TIMESTAMP') then Result := _TIMESTAMP;
  if AnsiContainsText(AType, 'CHAR') then Result := _CHAR;
  if AnsiContainsText(AType, 'VARCHAR') then Result := _VARCHAR;
  if AnsiContainsText(AType, 'BLOB') then Result := _BLOB;
  if AnsiContainsText(AType, 'CSTRING') then Result := _CSTRING;
  if AnsiContainsText(AType, 'QUAD') then Result := _QUAD;
end;

function Get_SMALLINT(var Precision: Integer; Scale, SubTypeID: Integer; Ext: Boolean = False): string;
begin
  Result := DataTypes[0, 0];
  if (Precision > 0) or (Scale > 0) then
  begin
    if Precision <= 0 then Precision := 4;
    if SubTypeID <> 2 then Result := DataTypes[0, 4] else Result := DataTypes[0, 5];
    if Ext then Result := Format('%s(%d,%d)',[Result, Precision, Scale]);
  end;
end;

function Get_INTEGER(var Precision: Integer; Scale, SubTypeID: Integer; Ext: Boolean = False): string;
begin
  Result := DataTypes[0, 1];
  if (Precision > 0) or (Scale > 0) then
  begin
    if Precision <= 0 then Precision := 9;
    if SubTypeID <> 2 then Result := DataTypes[0, 4] else Result := DataTypes[0, 5];
    if Ext then Result := Format('%s(%d,%d)',[Result, Precision, Scale]);
  end;
end;

function Get_BIGINT(var Precision: Integer; Scale, SubTypeID: Integer; Ext: Boolean = False): string;
begin
  Result := DataTypes[0, 12];
  if (Precision > 0) or (SubTypeID = 2) then
  begin
    if Precision <= 0 then Precision := 18;
    if SubTypeID <> 2 then Result := DataTypes[0, 4] else Result := DataTypes[0, 5];
    if Ext then Result := Format('%s(%d,%d)',[Result, Precision, Scale]);
  end;
end;

function Get_BOOLEAN: string;
begin
  Result := DataTypes[0, 13];
end;

function Get_FLOAT(var Precision: Integer; Scale: Integer; Ext: Boolean = False): string;
begin
  Result := DataTypes[0, 2];
  if Scale > 0 then
  begin
    Precision := 9;
    Result := DataTypes[0, 4];
    if Ext then Result := Format('%s(%d,%d)',[Result, Precision, Scale]);
  end;
end;

function Get_DOUBLE(var Precision: Integer; Scale: Integer; Ext: Boolean = False): string;
begin
  Result := DataTypes[0, 3];
  if Scale > 0 then
  begin
    Precision := 15;
    Result := DataTypes[0, 4];
    if Ext then Result := Format('%s(%d,%d)',[Result, Precision, Scale]);
  end;
end;

function Get_DATE: string;
begin
  Result := DataTypes[0, 6];
end;

function Get_TIME: string;
begin
  Result := DataTypes[0, 7];
end;

function Get_TIMESTAMP(Dialect: Integer): string;
begin
  Result := DataTypes[0, 8];
  if Dialect < 3 then Result := DataTypes[0, 6];
end;

function Get_CHAR(Length: Integer; Ext: Boolean = False): string;
begin
  Result := DataTypes[0, 9];
  if Ext then Result := Format('%s(%d)', [Result, Length]);
end;

function Get_VARCHAR(Length: Integer; Ext: Boolean = False): string;
begin
  Result := DataTypes[0, 10];
  if Ext then Result := Format('%s(%d)', [Result, Length]);
end;

function Get_BLOB(const SubTypeID, SegmentSize: Integer; Ext: Boolean = False): string;
begin
  Result := DataTypes[0, 11];
  if Ext then
  begin
    //  BLOB [SUB_TYPE {int | subtype_name}] [SEGMENT SIZE int]
    if not ((SubTypeID = 0) and (SegmentSize = 0)) then
    begin
      Result := Format('%s SUB_TYPE %d', [Result, {IDToBlobSubType(}SubTypeID{)}]);
      if SegmentSize > 0 then
        Result := Format('%s SEGMENT SIZE %d', [Result, SegmentSize]);
    end;
//    if SegmentSize > 0 then
//      Result := Format('%s(%d, %d)', [Result, SegmentSize, SubTypeID])
//    else
//    begin
//      if (System.Length(IDToBlobSubType(SubTypeID)) > 0) then
//        Result := Format('%s SUB_TYPE %s', [Result, IDToBlobSubType(SubTypeID)])
//      else
//        Result := Format('%s SUB_TYPE %d', [Result, SubTypeID]);
//    end;
  end;
end;

function Get_CSTRING(Length: Integer; Ext: Boolean = False): string;
begin
  Result := DataTypes[0, 14];
  if Ext then Result := Format('%s(%d)', [Result, Length]);
end;

function Get_QUAD: string;
begin
  Result := DataTypes[0, 15];
end;

function GetCharsetFB10: string;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesFB10) to High(CharsetsAndCollatesFB10) do
    if Length(CharsetsAndCollatesFB10[I, 0]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesFB10[I, 0];
  Result := Trim(Result);
end;

function GetCharsetFromIDFB10(const CharsetID: Integer): string;
begin
  Result := CharsetsAndCollatesFB10[CharsetID, 0];
end;

function GetIDFromCharsetFB10(const Charset: string): Integer;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesFB10) to High(CharsetsAndCollatesFB10) do
  begin
    Result := I;
    if AnsiSameText(CharsetsAndCollatesFB10[I, 0], Charset) then Break;
  end;
end;

function GetCollateFB10: string;
var
  I, J: Integer;
begin
  for I := Low(CharsetsAndCollatesFB10) to High(CharsetsAndCollatesFB10) do
    for J := Low(CharsetsAndCollatesFB10[I]) to High(CharsetsAndCollatesFB10[I]) do
    if Length(CharsetsAndCollatesFB10[I, J]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesFB10[I, J];
  Result := Trim(Result);
end;

function GetCollateFromIDFB10(const CharsetID, CollateID: Integer): string;
begin
  Result := CharsetsAndCollatesFB10[CharsetID, CollateID];
  // 'BORLAND''S BUG' with COllateID = 13
  case CollateID of
    14: Result := CharsetsAndCollatesFB10[CharsetID, 13];
    15: Result := CharsetsAndCollatesFB10[CharsetID, 14];
  end;
end;

function GetCollateFromIDFB10(const CharsetID: Integer): string;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesFB10[CharsetID]) to High(CharsetsAndCollatesFB10[CharsetID]) do
    if Length(CharsetsAndCollatesFB10[CharsetID, I]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesFB10[CharsetID, I];
  Result := Trim(Result);
end;

function GetIDFromCollateFB10(const Charset, Collate: string): Integer;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesFB10[GetIDFromCharsetFB10(Charset)]) to High(CharsetsAndCollatesFB10[GetIDFromCharsetFB10(Charset)]) do
  begin
    Result := I;
    if AnsiSameText(CharsetsAndCollatesFB10[GetIDFromCharsetFB10(Charset), I], Collate) then Break;
  end;
end;

function GetDataTypeFB15: string;
begin
  Result := FormatProps(DataTypes[4]);
end;

//FB1.5
function GetCharsetFB15: string;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesFB15) to High(CharsetsAndCollatesFB15) do
    if Length(CharsetsAndCollatesFB15[I, 0]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesFB15[I, 0];
  Result := Trim(Result);
end;

function GetCharsetFromIDFB15(const CharsetID: Integer): string;
begin
  Result := CharsetsAndCollatesFB15[CharsetID, 0];
end;

function GetIDFromCharsetFB15(const Charset: string): Integer;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesFB15) to High(CharsetsAndCollatesFB15) do
  begin
    Result := I;
    if AnsiSameText(CharsetsAndCollatesFB15[I, 0], Charset) then Break;
  end;
end;

function GetCollateFB15: string;
var
  I, J: Integer;
begin
  for I := Low(CharsetsAndCollatesFB15) to High(CharsetsAndCollatesFB15) do
    for J := Low(CharsetsAndCollatesFB15[I]) to High(CharsetsAndCollatesFB15[I]) do
    if Length(CharsetsAndCollatesFB15[I, J]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesFB15[I, J];
  Result := Trim(Result);
end;

function GetCollateFromIDFB15(const CharsetID, CollateID: Integer): string;
begin
  Result := CharsetsAndCollatesFB15[CharsetID, CollateID];
  // 'BORLAND''S BUG' with COllateID = 13
  case CollateID of
    14: Result := CharsetsAndCollatesFB15[CharsetID, 13];
    15: Result := CharsetsAndCollatesFB15[CharsetID, 14];
  end;
end;

function GetCollateFromIDFB15(const CharsetID: Integer): string;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesFB15[CharsetID]) to High(CharsetsAndCollatesFB15[CharsetID]) do
    if Length(CharsetsAndCollatesFB15[CharsetID, I]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesFB15[CharsetID, I];
  Result := Trim(Result);
end;

function GetIDFromCollateFB15(const Charset, Collate: string): Integer;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesFB15[GetIDFromCharsetFB15(Charset)]) to High(CharsetsAndCollatesFB15[GetIDFromCharsetFB15(Charset)]) do
  begin
    Result := I;
    if AnsiSameText(CharsetsAndCollatesFB15[GetIDFromCharsetFB15(Charset), I], Collate) then Break;
  end;
end;
// End FB1.5

//FB2
function GetCharsetFB20: string;
var
  I: Integer;
begin
  Result :='';
  for I := Low(CharsetsAndCollatesFB20) to High(CharsetsAndCollatesFB20) do
    if Length(CharsetsAndCollatesFB20[I, 0]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesFB20[I, 0];
  Result := Trim(Result);
end;

function GetCharsetFB21: string;
var
  I: Integer;
begin
  Result :='';
  for I := Low(CharsetsAndCollatesFB21) to High(CharsetsAndCollatesFB21) do
    if Length(CharsetsAndCollatesFB21[I, 0]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesFB21[I, 0];
  Result := Trim(Result);
end;

function GetCharsetFromIDFB20(const CharsetID: Integer): string;
begin
  Result := CharsetsAndCollatesFB20[CharsetID, 0];
end;

function GetCharsetFromIDFB21(const CharsetID: Integer): string;
begin
  Result := CharsetsAndCollatesFB21[CharsetID, 0];
end;

function GetIDFromCharsetFB20(const Charset: string): Integer;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesFB20) to High(CharsetsAndCollatesFB20) do
  begin
    Result := I;
    if AnsiSameText(CharsetsAndCollatesFB20[I, 0], Charset) then Break;
  end;
end;

function GetIDFromCharsetFB21(const Charset: string): Integer;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesFB21) to High(CharsetsAndCollatesFB21) do
  begin
    Result := I;
    if AnsiSameText(CharsetsAndCollatesFB21[I, 0], Charset) then Break;
  end;
end;

function GetCollateFB20: string;
var
  I, J: Integer;
begin
  for I := Low(CharsetsAndCollatesFB20) to High(CharsetsAndCollatesFB20) do
    for J := Low(CharsetsAndCollatesFB20[I]) to High(CharsetsAndCollatesFB20[I]) do
    if Length(CharsetsAndCollatesFB20[I, J]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesFB20[I, J];
  Result := Trim(Result);
end;

function GetCollateFB21: string;
var
  I, J: Integer;
begin
  for I := Low(CharsetsAndCollatesFB21) to High(CharsetsAndCollatesFB21) do
    for J := Low(CharsetsAndCollatesFB21[I]) to High(CharsetsAndCollatesFB21[I]) do
    if Length(CharsetsAndCollatesFB21[I, J]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesFB21[I, J];
  Result := Trim(Result);
end;

function GetCollateFromIDFB20(const CharsetID, CollateID: Integer): string;
begin
  Result := CharsetsAndCollatesFB20[CharsetID, CollateID];
  // 'BORLAND''S BUG' with COllateID = 13
  case CollateID of
    14: Result := CharsetsAndCollatesFB20[CharsetID, 13];
    15: Result := CharsetsAndCollatesFB20[CharsetID, 14];
  end;
end;

function GetCollateFromIDFB20(const CharsetID: Integer): string;
var
  I: Integer;
begin
  Result :=''; 
  for I := Low(CharsetsAndCollatesFB20[CharsetID]) to High(CharsetsAndCollatesFB20[CharsetID]) do
    if Length(CharsetsAndCollatesFB20[CharsetID, I]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesFB20[CharsetID, I];
  Result := Trim(Result);
end;

function GetIDFromCollateFB20(const Charset, Collate: string): Integer;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesFB20[GetIDFromCharsetFB20(Charset)]) to High(CharsetsAndCollatesFB20[GetIDFromCharsetFB20(Charset)]) do
  begin
    Result := I;
    if AnsiSameText(CharsetsAndCollatesFB20[GetIDFromCharsetFB20(Charset), I], Collate) then Break;
  end;
end;

//End FB2

function GetCollateFromIDFB21(const CharsetID, CollateID: Integer): string;
begin

  // 'BORLAND''S BUG' with COllateID = 13
  case CollateID of
    14: Result := CharsetsAndCollatesFB21[CharsetID, 13];
    15: Result := CharsetsAndCollatesFB21[CharsetID, 14];
  else
   Result := CharsetsAndCollatesFB21[CharsetID, CollateID];  
  end;
end;


function GetCollateFromIDFB21(const CharsetID: Integer): string;
var
  I: Integer;
begin
  Result :=''; 
  for I := Low(CharsetsAndCollatesFB21[CharsetID]) to High(CharsetsAndCollatesFB21[CharsetID]) do
    if Length(CharsetsAndCollatesFB21[CharsetID, I]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesFB21[CharsetID, I];
  Result := Trim(Result);
end;

function GetIDFromCollateFB21(const Charset, Collate: string): Integer;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesFB21[GetIDFromCharsetFB20(Charset)]) to High(CharsetsAndCollatesFB21[GetIDFromCharsetFB21(Charset)]) do
  begin
    Result := I;
    if AnsiSameText(CharsetsAndCollatesFB21[GetIDFromCharsetFB21(Charset), I], Collate) then
     Break;
  end;
end;

// End FB21

function GetCharsetIB70: string;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesIB70) to High(CharsetsAndCollatesIB70) do
    if Length(CharsetsAndCollatesIB70[I, 0]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesIB70[I, 0];
  Result := Trim(Result);
end;

function GetCharsetFromIDIB70(const CharsetID: Integer): string;
begin
  Result := CharsetsAndCollatesIB70[CharsetID, 0];
end;

function GetIDFromCharsetIB70(const Charset: string): Integer;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesIB70) to High(CharsetsAndCollatesIB70) do
  begin
    Result := I;
    if AnsiSameText(CharsetsAndCollatesIB70[I, 0], Charset) then Break;
  end;
end;

function GetCollateIB70: string;
var
  I, J: Integer;
begin
  for I := Low(CharsetsAndCollatesIB70) to High(CharsetsAndCollatesIB70) do
    for J := Low(CharsetsAndCollatesIB70[I]) to High(CharsetsAndCollatesIB70[I]) do
    if Length(CharsetsAndCollatesIB70[I, J]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesIB70[I, J];
  Result := Trim(Result);
end;

function GetCollateFromIDIB70(const CharsetID, CollateID: Integer): string;
begin
  Result := CharsetsAndCollatesIB70[CharsetID, CollateID];
  // 'BORLAND''S BUG' with COllateID = 13
  case CollateID of
    14: Result := CharsetsAndCollatesIB70[CharsetID, 13];
    15: Result := CharsetsAndCollatesIB70[CharsetID, 14];
  end;
end;

function GetCollateFromIDIB70(const CharsetID: Integer): string;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesIB70[CharsetID]) to High(CharsetsAndCollatesIB70[CharsetID]) do
    if Length(CharsetsAndCollatesIB70[CharsetID, I]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesIB70[CharsetID, I];
  Result := Trim(Result);
end;

function GetIDFromCollateIB70(const Charset, Collate: string): Integer;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesIB70[GetIDFromCharsetIB70(Charset)]) to High(CharsetsAndCollatesIB70[GetIDFromCharsetIB70(Charset)]) do
  begin
    Result := I;
    if AnsiSameText(CharsetsAndCollatesIB70[GetIDFromCharsetIB70(Charset), I], Collate) then Break;
  end;
end;


function GetCharsetIB71: string;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesIB71) to High(CharsetsAndCollatesIB71) do
    if Length(CharsetsAndCollatesIB71[I, 0]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesIB71[I, 0];
  Result := Trim(Result);
end;

function GetCharsetFromIDIB71(const CharsetID: Integer): string;
begin
  Result := CharsetsAndCollatesIB71[CharsetID, 0];
end;

function GetIDFromCharsetIB71(const Charset: string): Integer;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesIB71) to High(CharsetsAndCollatesIB71) do
  begin
    Result := I;
    if AnsiSameText(CharsetsAndCollatesIB71[I, 0], Charset) then Break;
  end;
end;

function GetCollateIB71: string;
var
  I, J: Integer;
begin
  for I := Low(CharsetsAndCollatesIB71) to High(CharsetsAndCollatesIB71) do
    for J := Low(CharsetsAndCollatesIB71[I]) to High(CharsetsAndCollatesIB71[I]) do
    if Length(CharsetsAndCollatesIB71[I, J]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesIB71[I, J];
  Result := Trim(Result);
end;

function GetCollateFromIDIB71(const CharsetID, CollateID: Integer): string;
begin
  Result := CharsetsAndCollatesIB71[CharsetID, CollateID];
  // 'BORLAND''S BUG' with COllateID = 13
  case CollateID of
    14: Result := CharsetsAndCollatesIB71[CharsetID, 13];
    15: Result := CharsetsAndCollatesIB71[CharsetID, 14];
  end;
end;

function GetCollateFromIDIB71(const CharsetID: Integer): string;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesIB71[CharsetID]) to High(CharsetsAndCollatesIB71[CharsetID]) do
    if Length(CharsetsAndCollatesIB71[CharsetID, I]) > 0 then
      Result := Result + sLineBreak + CharsetsAndCollatesIB71[CharsetID, I];
  Result := Trim(Result);
end;

function GetIDFromCollateIB71(const Charset, Collate: string): Integer;
var
  I: Integer;
begin
  for I := Low(CharsetsAndCollatesIB71[GetIDFromCharsetIB71(Charset)]) to High(CharsetsAndCollatesIB71[GetIDFromCharsetIB71(Charset)]) do
  begin
    Result := I;
    if AnsiSameText(CharsetsAndCollatesIB71[GetIDFromCharsetIB71(Charset), I], Collate) then Break;
  end;
end;

function GetCharsetIB75: string;
begin
  Result := GetCharsetIB71;
end;

function GetCharsetFromIDIB75(const CharsetID: Integer): string;
begin
  Result := GetCharsetFromIDIB71(CharsetID);
end;

function GetIDFromCharsetIB75(const Charset: string): Integer;
begin
  Result := GetIDFromCharsetIB71(Charset);
end;

function GetCollateIB75: string;
begin
  Result := GetCollateIB71;
end;

function GetCollateFromIDIB75(const CharsetID, CollateID: Integer): string;
begin
  Result := GetCollateFromIDIB71(CharsetID, CollateID);
  // 'BORLAND''S BUG' with COllateID = 13
  case CollateID of
    14: Result := GetCollateFromIDIB71(CharsetID, 13);
    15: Result := GetCollateFromIDIB71(CharsetID, 14);
  end;
end;

function GetCollateFromIDIB75(const CharsetID: Integer): string;
begin
  Result := GetCollateFromIDIB71(CharsetID);
end;

function GetIDFromCollateIB75(const Charset, Collate: string): Integer;
begin
  Result := GetIDFromCollateIB71(Charset, Collate);
end;


function GetBlobSubType: string;
begin
  Result := FormatProps(BlobSubTypes);
end;

function BlobSubTypeToID(const SubType: string): Integer;
var
  I: Integer;
begin
  for I := Low(BlobSubTypes) to High(BlobSubTypes) do
  begin
    Result := I;
    if AnsiSameText(BlobSubTypes[I], SubType) then Break;
  end;
end;

function IDToBlobSubType(const SubTypeID: Integer): string;
begin
  Result := BlobSubTypes[SubTypeID];
end;

function GetPrecision: string;
begin
  Result := FormatProps(Precisions);
end;

function GetScale: string;
begin
  Result := FormatProps(Scales);
end;

function GetNullType: string;
begin
  Result := FormatProps(NullTypes);
end;

function GetSorting: string;
begin
  Result := FormatProps(Sortings);
end;

function GetIndexType: string;
begin
  Result := FormatProps(IndexTypes);
end;

function GetConstraintType: string;
begin
  Result := FormatProps(ConstraintTypes);
end;

function GetConstraintRule: string;
begin
  Result := FormatProps(ConstraintRules);
end;

function GetTableList: string;
begin
  Result := EmptyStr;
  // TODO прямо из редактора надо заполнить, потянувшись куда следует
end;

function GetStatus: string;
begin
  Result := FormatProps(Statuses);
end;

function GetTypePrefix: string;
begin
  Result := FormatProps(TypePrefixes);
end;

function GetTypePrefixFB21: string;
begin
  Result := FormatProps(TypePrefixesFB21);
end;

function GetTypeSuffixFB21: string;
begin
  Result := FormatProps(TypeSuffixesFB21);
end;


function GetTypeSuffixIB: string;
begin
  Result := FormatProps(TypeSuffixesIB);
end;

function GetTypeSuffixFB: string;
begin
  Result := FormatProps(TypeSuffixesFB);
end;

function GetMechanism: string;
begin
  Result := FormatProps(Mechanisms);
end;

function GetAfterExecute: string;
begin
  Result := FormatProps(AfterExecutes);
end;

function GetResultType: string;
begin
  Result := FormatProps(ResultTypes);
end;

function GetIsolationLevel: string;
begin
  Result := FormatProps(IsolationLevels);
end;

function GetTransactionParams(AIsolationLevel, ATransactionParams: string): string;
begin
  if AnsiSameText(AIsolationLevel, IsolationLevels[0]) then
    Result := TransactionParamsSnapshot
  else
  if AnsiSameText(AIsolationLevel, IsolationLevels[1]) then
    Result := TransactionParamsReadCommited
  else
  if AnsiSameText(AIsolationLevel, IsolationLevels[2]) then
    Result := TransactionParamsReadOnlyTableStability
  else
  if AnsiSameText(AIsolationLevel, IsolationLevels[3]) then
    Result := TransactionParamsReadWriteTableStability
  else
    Result := ATransactionParams;
end;

function GetDefaultSQLDialect: string;
begin
  Result := GetDialect;
end;

function GetPrivilegesFor: string;
begin
  Result := FormatProps(PrivilegeTypes);
end;

function GetGrantsOn: string;
begin
  Result := FormatProps(GrantTypes);
end;

function GetDisplayGrants: string;
begin
  Result := FormatProps(DisplayGrants);
end;

function GetAccessMode: string;
begin
  Result := FormatProps(AccessModes);
end;

function GetConfirmEndTransaction: string;
begin
  Result := FormatProps(ConfirmEndTransactions);
end;

function GetDefaultTransactionAction: string;
begin
  Result := FormatProps(DefaultTransactionActions);
end;

function GUIDToName(const ClassIID: TGUID; Index: Integer = 0): string;
begin
  if (Index = 0) or (Index = 1) then
  begin
    if IsEqualGUID(ClassIID, IibSHDomain) then Result := ObjectTypes[0, Index]
    else
    if IsEqualGUID(ClassIID, IibSHTable) then Result := ObjectTypes[1, Index]
    else
    if IsEqualGUID(ClassIID, IibSHIndex) then Result := ObjectTypes[2, Index]
    else
    if IsEqualGUID(ClassIID, IibSHView) then Result := ObjectTypes[3, Index]
    else
    if IsEqualGUID(ClassIID, IibSHProcedure) then Result := ObjectTypes[4, Index]
    else
    if IsEqualGUID(ClassIID, IibSHTrigger) then Result := ObjectTypes[5, Index]
    else
    if IsEqualGUID(ClassIID, IibSHGenerator) then Result := ObjectTypes[6, Index]
    else
    if IsEqualGUID(ClassIID, IibSHException) then Result := ObjectTypes[7, Index]
    else
    if IsEqualGUID(ClassIID, IibSHFunction) then Result := ObjectTypes[8, Index]
    else
    if IsEqualGUID(ClassIID, IibSHFilter) then Result := ObjectTypes[9, Index]
    else
    if IsEqualGUID(ClassIID, IibSHRole) then Result := ObjectTypes[10, Index]
    else
    if IsEqualGUID(ClassIID, IibSHShadow) then Result := ObjectTypes[11, Index]
    else
    if IsEqualGUID(ClassIID, IibSHField) then Result := ObjectTypes[12, Index]
    else
    if IsEqualGUID(ClassIID, IibSHConstraint) then Result := ObjectTypes[13, Index]
    else
    if IsEqualGUID(ClassIID, IibSHSystemTable) then Result := ObjectTypes[14, Index]
    else
    if IsEqualGUID(ClassIID, IibSHSystemTableTmp) then Result := ObjectTypes[15, Index];
(*
    if IsEqualGUID(ClassIID, IibSHSystemDomain) then Result := ObjectTypes[13, Index];
    if IsEqualGUID(ClassIID, IibSHSystemGeneratedDomain) then Result := ObjectTypes[16, Index];
    if IsEqualGUID(ClassIID, IibSHSystemGeneratedConstraint) then Result := ObjectTypes[17, Index];
    if IsEqualGUID(ClassIID, IibSHSystemGeneratedTrigger) then Result := ObjectTypes[18, Index];
    if IsEqualGUID(ClassIID, IibSHSQLEditor) then Result := ObjectTypes[19, Index];
    if IsEqualGUID(ClassIID, IibSHSQLHistory) then Result := ObjectTypes[20, Index];
    if IsEqualGUID(ClassIID, IibSHSQLPerformance) then Result := ObjectTypes[21, Index];
    if IsEqualGUID(ClassIID, IibSHSQLPlan) then Result := ObjectTypes[22, Index];
    if IsEqualGUID(ClassIID, IibSHSQLScript) then Result := ObjectTypes[23, Index];
    if IsEqualGUID(ClassIID, IibSHSQLMonitor) then Result := ObjectTypes[24, Index];
    if IsEqualGUID(ClassIID, IibSHDDLGrantor) then Result := ObjectTypes[25, Index];
    if IsEqualGUID(ClassIID, IibSHUserManager) then Result := ObjectTypes[26, Index];
    if IsEqualGUID(ClassIID, IibSHMetadataSearch) then Result := ObjectTypes[27, Index];
    if IsEqualGUID(ClassIID, IibSHMetadataExtract) then Result := ObjectTypes[28, Index];
    if IsEqualGUID(ClassIID, IibSHBlobEditor) then Result := ObjectTypes[29, Index];
    if IsEqualGUID(ClassIID, IibSHDDLDocumentor) then Result := ObjectTypes[30, Index];
    if IsEqualGUID(ClassIID, IibSHReportManager) then Result := ObjectTypes[31, Index];
    if IsEqualGUID(ClassIID, IibSHDataGenerator) then Result := ObjectTypes[32, Index];
    if IsEqualGUID(ClassIID, IibSHDBComparer) then Result := ObjectTypes[33, Index];
    if IsEqualGUID(ClassIID, IibSHSecondaryFiles) then Result := ObjectTypes[34, Index];
    if IsEqualGUID(ClassIID, IibSHCVSExchanger) then Result := ObjectTypes[35, Index];
    if IsEqualGUID(ClassIID, IibSHDBDesigner) then Result := ObjectTypes[36, Index];
*)
  end else
    Result := 'SUnknown';
end;

function GetHintLeftPart(const Hint: string; Separator: string = '|'): string;
var
  I: Integer;
begin
  Result := Hint;
  I := Pos(Separator, Hint);
  if I > 0 then Result := Copy(Hint, 0, I - 1);
end;

function GetHintRightPart(const Hint: string; Separator: string = '|'): string;
var
  I: Integer;
begin
  Result := EmptyStr;
  I := Pos(Separator, Hint);
  if I > 0 then Result := Copy(Hint, I + 1, Length(Hint) - I);
end;

function IsSystemDomain(const S: string): Boolean;
begin
  Result := False;
  if Pos('RDB$', S) = 1 then
    Result := S[5] in ['1','2','3','4','5','6','7','8', '9', '0'];
end;

function IsSystemIndex(const S: string): Boolean;
begin
  Result := False;
  if Pos('RDB$', S) = 1 then
    Result := (S[5] in ['1','2','3','4','5','6','7','8', '9', '0']) or
              (Pos('RDB$PRIMARY', S) = 1) or
              (Pos('RDB$FOREIGN', S) = 1) or
              (Pos('RDB$INDEX_', S) = 1);
end;

function msToStr(AMiliseconds: Integer): string;
var
  vRemainder: Integer;
  ms, s, min, h, d: Integer;
begin
  vRemainder := AMiliseconds;
  ms := vRemainder mod 1000;
  vRemainder := vRemainder div 1000;
  s := vRemainder mod 60;
  vRemainder := vRemainder div 60;
  min := vRemainder mod 60;
  vRemainder := vRemainder div 60;
  h := vRemainder mod 24;
  vRemainder := vRemainder div 24;
  d := vRemainder;
  Result := Format(SMillisecondsFmt, [ms]);
  if s <> 0 then
    Result := Format(SSecondsFmt, [s]) + Result;
  if min <> 0 then
    Result := Format(SMinutesFmt, [min]) + Result;
  if h <> 0 then
    Result := Format(SHoursFmt, [h]) + Result;
  if d <> 0 then
    Result := Format(SDaysFmt, [d]) + Result;
end;

function AddToTextFile(const AFileName, AText: string): Boolean;
var
  vLogFile: TFileStream;
begin
  try
    if FileExists(AFileName) then
      vLogFile := TFileStream.Create(AFileName, fmOpenReadWrite or fmShareDenyNone)
    else
      vLogFile := TFileStream.Create(AFileName, fmCreate or fmShareDenyNone);
    with vLogFile do
    begin
      try
        Seek(0, soFromEnd);
        WriteBuffer(AText[1], Length(AText));
        Result := True;
      finally
        Free;
      end;
    end;
  except
    Result := False;
  end;
end;

function GetStopAfter: string;
begin
  Result := FormatProps(StopAfters);
end;

function GetShutdownMode: string;
begin
  Result := FormatProps(ShutdownModes);
end;

function GetGlobalAction: string;
begin
  Result := FormatProps(GlobalActions);
end;

end.
