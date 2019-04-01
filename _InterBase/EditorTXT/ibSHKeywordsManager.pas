unit ibSHKeywordsManager;

interface

uses Classes, Graphics, SysUtils, Forms, Contnrs,
     SHDesignIntf, ibSHDesignIntf, ibSHConsts,
     pSHIntf, pSHHighlighter;

type

  TibBTKeywordsManager = class(TSHComponent, IpSHKeywordsManager, IibSHKeywordsList)
  private
    FSubSQLDialect: TSQLSubDialect;
    FHighlighters: TObjectList;
    FDataTypeList: TStringList;
    FFunctionList: TStringList;
    FKeywordList: TStringList;
    FAllKeywordList: TStringList;
  protected
    function DataRootPath(ABranch: TGUID): string;
     {IpSHKeywordsManager}
    procedure InitializeKeywordLists(Sender: TObject;
      SubDialect: TSQLSubDialect;
      EnumerateKeywordsProc: TEnumerateKeywordsProc);
    procedure ChangeSubSQLDialectTo(ASubSQLDialect: TSQLSubDialect);
    procedure AddHighlighter(AHighlighter: TComponent);
    procedure RemoveHighlighter(AHighlighter: TComponent);
    function IsKeyword(AWord: string): Boolean;
    {IibSHKeywordsList}
    function GetFunctionList: TStrings;
    function GetDataTypeList: TStrings;
    function GetKeywordList: TStrings;
    function GetAllKeywordList: TStrings;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    class function GetClassIIDClassFnc: TGUID; override;
  end;

implementation

procedure Register;
begin
  SHRegisterComponents([TibBTKeywordsManager]);
end;

{ TibBTKeywordsManager }

type
  TKWType = (kwtUnknown, kwtDataTypes, kwtInternalFunctions, kwtKeyWords);

constructor TibBTKeywordsManager.Create(AOwner: TComponent);
begin
  inherited;
  FDataTypeList := TStringList.Create;
  FFunctionList := TStringList.Create;
  FKeywordList := TStringList.Create;
  FAllKeywordList := TStringList.Create;

  FHighlighters := TObjectList.Create;
  FHighlighters.OwnsObjects := False;
  FSubSQLDialect := -1;
end;

destructor TibBTKeywordsManager.Destroy;
begin
  FAllKeywordList.Free;
  FDataTypeList.Free;
  FFunctionList.Free;
  FKeywordList.Free;

  FHighlighters.Free;
  inherited;
end;

function TibBTKeywordsManager.DataRootPath(ABranch: TGUID): string;
var
  vDataRootDirectory: ISHDataRootDirectory;
begin
  Result := EmptyStr;
  if Supports(Designer.GetDemon(ABranch), ISHDataRootDirectory, vDataRootDirectory) then
    Result := vDataRootDirectory.DataRootDirectory;
end;

procedure TibBTKeywordsManager.InitializeKeywordLists(Sender: TObject;
  SubDialect: TSQLSubDialect;
  EnumerateKeywordsProc: TEnumerateKeywordsProc);
var
  KWFileName: string;
  CurrentKW: TStringList;
  vBranch: TGUID;
  function LoadKWStrings(AKWType: TKWType): string;
  var
    I: Integer;
    SList: TStrings;
  begin
    Result := '';
    case AKWType of
      kwtDataTypes: SList := FDataTypeList;
      kwtInternalFunctions: SList := FFunctionList;
      kwtKeyWords: SList := FKeywordList;
      else SList := nil;
    end;
    if Assigned(SList) then
      for I := 0 to SList.Count - 1 do
        Result := Result + ',' + SList.Names[I];
//        SHint := SList.ValueFromIndex[I];
//        FProposalKWItemList.Add(Format(sProposalTemplate,
//          [GetColorStringFor(AKWType), SType, SItem, SHint]));
//        FProposalKWInsertList.Add(SItem);
  end;
  procedure PharseList;
  var
    I: Integer;
    vPos: Integer;
    S: string;
    vKWType: TKWType;
  begin
    vKWType := kwtUnknown;
    for I := 0 to CurrentKW.Count - 1 do
    begin
      S := Trim(CurrentKW[I]);
      if (Length(S) > 0) and (S[1] <> ';') then
        if (S[1] = '[') and (S[Length(S)] = ']') then
        begin
          Delete(S, 1, 1);
          SetLength(S, Length(S)-1);
          if SameText(S, sSectionDataTypes) then
            vKWType := kwtDataTypes
          else
          if SameText(S, sSectionFunctions) then
            vKWType := kwtInternalFunctions
          else
          if SameText(S, sSectionKeyWords) then
            vKWType := kwtKeyWords
          else
            vKWType := kwtUnknown;
        end
        else
        begin
          case vKWType of
            kwtDataTypes: FDataTypeList.Add(S);
            kwtInternalFunctions: FFunctionList.Add(S);
            kwtKeyWords: FKeywordList.Add(S);
          end;
          S := Trim(CurrentKW.Names[I]);
          vPos := Pos(' ', S);
          if vPos > 0 then
          begin
            FAllKeywordList.Add(S);
            FAllKeywordList.Add(Copy(S, 1, vPos - 1));
            FAllKeywordList.Add(Copy(S, vPos + 1,  Length(S) - vPos));
          end
          else
            FAllKeywordList.Add(S);
        end;
    end;
  end;
begin
  if FSubSQLDialect <> SubDialect then
  begin
    FSubSQLDialect := SubDialect;
    case SubDialect of
      ibdInterBase6, ibdInterBase65:
        begin
          vBranch := IibSHBranch;
          KWFileName := InterBase6KWFileName;
        end;
      ibdInterBase7:
        begin
          vBranch := IibSHBranch;
          KWFileName := InterBase7KWFileName;
        end;
      ibdInterBase75:
        begin
          vBranch := IibSHBranch;
          KWFileName := InterBase75KWFileName;
        end;
      ibdFirebird1:
        begin
          vBranch := IfbSHBranch;
          KWFileName := Firebird1KWFileName;
        end;
      ibdFirebird15:
        begin
          vBranch := IfbSHBranch;
          KWFileName := Firebird15KWFileName;
        end;
      ibdFirebird20:
        begin
          vBranch := IfbSHBranch;
          KWFileName := Firebird20KWFileName;
        end;
      ibdInterBase2007:
        begin
          vBranch := IibSHBranch;
          KWFileName := InterBase2007KWFileName;
        end;
      ibdFirebird21:
        begin
          vBranch := IfbSHBranch;
          KWFileName := Firebird21KWFileName;
        end;

      else
      begin
        vBranch := IibSHBranch;
        KWFileName := '';
      end;
    end;
    FDataTypeList.Clear;
    FFunctionList.Clear;
    FKeywordList.Clear;
    FAllKeywordList.Clear;
    FAllKeywordList.Sorted := False;
    CurrentKW := TStringList.Create;

    try
//      if FileExists(DataRootPath(vBranch) + InterBaseDefaultKWFileName) then
      //Дефолтный файл для Firebird грузится из "основной" ветки InterBase
      if FileExists(DataRootPath(IibSHBranch) + InterBaseDefaultKWFileName) then
      begin
        CurrentKW.LoadFromFile(DataRootPath(IibSHBranch) + InterBaseDefaultKWFileName);
        PharseList;
      end;
      if (Length(KWFileName) > 0) and
        FileExists(DataRootPath(vBranch) + KWFileName) then
      begin
        CurrentKW.LoadFromFile(DataRootPath(vBranch) + KWFileName);
        PharseList;
      end;
    finally
      CurrentKW.Free;
    end;
    FDataTypeList.Sort;
    FFunctionList.Sort;
    FKeywordList.Sort;
    FAllKeywordList.Sorted := True;
    EnumerateKeywordsProc(Ord(tkDatatype), LoadKWStrings(kwtDataTypes));
    EnumerateKeywordsProc(Ord(tkFunction), LoadKWStrings(kwtInternalFunctions));
    EnumerateKeywordsProc(Ord(tkKey), LoadKWStrings(kwtKeyWords));
  end
  else
  begin
    EnumerateKeywordsProc(Ord(tkDatatype), LoadKWStrings(kwtDataTypes));
    EnumerateKeywordsProc(Ord(tkFunction), LoadKWStrings(kwtInternalFunctions));
    EnumerateKeywordsProc(Ord(tkKey), LoadKWStrings(kwtKeyWords));
  end;
end;

procedure TibBTKeywordsManager.ChangeSubSQLDialectTo(
  ASubSQLDialect: TSQLSubDialect);
var
  I: Integer;
begin
  for I := 0 to FHighlighters.Count - 1 do
    if FHighlighters[I] is TpSHHighlighter then
      TpSHHighlighter(FHighlighters[I]).SQLSubDialect := ASubSQLDialect;
end;

procedure TibBTKeywordsManager.AddHighlighter(AHighlighter: TComponent);
begin
  if (FHighlighters.IndexOf(AHighlighter) = -1) and
    (AHighlighter is TpSHHighlighter) then
  begin
    FHighlighters.Add(AHighlighter);
    AHighlighter.FreeNotification(Self);
  end;
end;

procedure TibBTKeywordsManager.RemoveHighlighter(AHighlighter: TComponent);
var
  I: Integer;
begin
  I := FHighlighters.IndexOf(AHighlighter);
  if I <> -1 then
    FHighlighters.Delete(I);
end;

function TibBTKeywordsManager.IsKeyword(AWord: string): Boolean;
var
  Index:Integer;
begin
//  Result := FAllKeywordList.IndexOf(AnsiUpperCase(AWord)) > -1;
  Result := FAllKeywordList.Find(AWord,Index) 
end;

function TibBTKeywordsManager.GetFunctionList: TStrings;
begin
  Result := FFunctionList;
end;

function TibBTKeywordsManager.GetDataTypeList: TStrings;
begin
  Result := FDataTypeList;
end;

function TibBTKeywordsManager.GetKeywordList: TStrings;
begin
  Result := FKeywordList;
end;

function TibBTKeywordsManager.GetAllKeywordList: TStrings;
begin
  Result := FAllKeywordList;
end;

procedure TibBTKeywordsManager.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
    RemoveHighlighter(AComponent);
  inherited Notification(AComponent, Operation);
end;

class function TibBTKeywordsManager.GetClassIIDClassFnc: TGUID;
begin
  Result := IpSHKeywordsManager;
end;

initialization

  Register;

end.

