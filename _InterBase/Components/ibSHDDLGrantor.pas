unit ibSHDDLGrantor;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDriverIntf, ibSHTool;

type
  TibSHDDLGrantor = class(TibBTTool, IibSHDDLGrantor, IibSHBranch, IfbSHBranch)
  private
    FIntDatabase: TComponent;
    FIntDatabaseIntf: IibSHDatabase;
    FPrivilegesFor: string;
    FGrantsOn: string;
    FDisplay: string;
    FShowSystemTables: Boolean;
    FIncludeFields: Boolean;

    FUnionUsers: TStrings;
    FAbsentUsers: TStrings;

    FSelectG: TStrings;
    FUpdateG: TStrings;
    FDeleteG: TStrings;
    FInsertG: TStrings;
    FReferenceG: TStrings;
    FExecuteG: TStrings;

    FSelectGO: TStrings;
    FUpdateGO: TStrings;
    FDeleteGO: TStrings;
    FInsertGO: TStrings;
    FReferenceGO: TStrings;
    FExecuteGO: TStrings;

    function GetPrivilegesFor: string;
    procedure SetPrivilegesFor(Value: string);
    function GetGrantsOn: string;
    procedure SetGrantsOn(Value: string);
    function GetDisplay: string;
    procedure SetDisplay(Value: string);
    function GetShowSystemTables: Boolean;
    procedure SetShowSystemTables(Value: Boolean);
    function GetIncludeFields: Boolean;
    procedure SetIncludeFields(Value: Boolean);

    procedure ClearLists;
    procedure SortLists;
    function GetUnionUsers: TStrings;
    function GetAbsentUsers: TStrings;
    procedure ExtractGrants(const AClassIID: TGUID; const ACaption: string);
    function GetGrantSelectIndex(const ACaption: string): Integer;
    function GetGrantUpdateIndex(const ACaption: string): Integer;
    function GetGrantDeleteIndex(const ACaption: string): Integer;
    function GetGrantInsertIndex(const ACaption: string): Integer;
    function GetGrantReferenceIndex(const ACaption: string): Integer;
    function GetGrantExecuteIndex(const ACaption: string): Integer;
    function IsGranted(const ACaption: string): Boolean;

    function GetNormalizeName(const ACaption: string): string;
    function GetPrivilegesForName(const AClassIID: TGUID; const ACaption: string): string;
    function GrantTable(const AClassIID: TGUID; const Privilege, OnObject, ToObject: string; WGO: Boolean): Boolean;
    function GrantTableField(const AClassIID: TGUID; const Privilege, OnField, OnObject, ToObject: string; WGO: Boolean): Boolean;
    function GrantProcedure(const AClassIID: TGUID; const OnObject, ToObject: string; WGO: Boolean): Boolean;
    function RevokeTable(const AClassIID: TGUID; const Privilege, OnObject, FromObject: string; WGO: Boolean): Boolean;
    function RevokeTableField(const AClassIID: TGUID; const Privilege, OnField, OnObject, FromObject: string; WGO: Boolean): Boolean;
    function RevokeProcedure(const AClassIID: TGUID; const OnObject, FromObject: string; WGO: Boolean): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property PrivilegesFor: string read GetPrivilegesFor write SetPrivilegesFor;
    property GrantsOn: string read GetGrantsOn write SetGrantsOn;
    property Display: string read GetDisplay write SetDisplay;
    property ShowSystemTables: Boolean read GetShowSystemTables write SetShowSystemTables;
    property IncludeFields: Boolean read GetIncludeFields write SetIncludeFields;
  end;

  TibSHDDLGrantorFactory = class(TibBTToolFactory)
  end;

  TibSHGrant = class(TSHComponent, IibSHGrant)
  end;

  TibSHGrantWGO = class(TSHComponent, IibSHGrantWGO)
  end;

procedure Register;

implementation

uses
  ibSHConsts, ibSHSQLs, ibSHValues,
  ibSHDDLGrantorActions,
  ibSHDDLGrantorEditors;

procedure Register;
begin
  SHRegisterImage(GUIDToString(IibSHDDLGrantor), 'GrantWGO.bmp');
  SHRegisterImage(GUIDToString(IibSHGrant),      'Grant.bmp');
  SHRegisterImage(GUIDToString(IibSHGrantWGO),   'GrantWGO.bmp');
  SHRegisterImage(GUIDToString(IibSHUser),       'User.bmp');

  SHRegisterImage(TibSHDDLGrantorPaletteAction.ClassName,         'GrantWGO.bmp');
  SHRegisterImage(TibSHDDLGrantorFormAction.ClassName,            'Form_Privileges.bmp');
  SHRegisterImage(TibSHDDLGrantorToolbarAction_Run.ClassName,     'Button_Run.bmp');
  SHRegisterImage(TibSHDDLGrantorToolbarAction_Pause.ClassName,   'Button_Stop.bmp');
  SHRegisterImage(TibSHDDLGrantorToolbarAction_Refresh.ClassName, 'Button_Refresh.bmp');

  SHRegisterImage(SCallPrivileges, 'Form_Privileges.bmp');

  SHRegisterComponents([
    TibSHDDLGrantor,
    TibSHDDLGrantorFactory,
    TibSHGrant,
    TibSHGrantWGO]);

  SHRegisterActions([
    // Palette
    TibSHDDLGrantorPaletteAction,
    // Forms
    TibSHDDLGrantorFormAction,
    // Toolbar
    TibSHDDLGrantorToolbarAction_Run,
//    TibSHDDLGrantorToolbarAction_Pause,
    TibSHDDLGrantorToolbarAction_Refresh]);

  SHRegisterPropertyEditor(IibSHDDLGrantor, SCallPrivilegesFor, TibSHDDLGrantorPrivilegesForPropEditor);
  SHRegisterPropertyEditor(IibSHDDLGrantor, SCallGrantsOn, TibSHDDLGrantorGrantsOnPropEditor);
  SHRegisterPropertyEditor(IibSHDDLGrantor, SCallDisplayGrants, TibSHDDLGrantorDisplayPropEditor);
end;

{ TibSHDDLGrantor }

constructor TibSHDDLGrantor.Create(AOwner: TComponent);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner);
  FPrivilegesFor := Format('%s', [PrivilegeTypes[4]]);
  FGrantsOn := Format('%s', [GrantTypes[0]]);
  FDisplay := Format('%s', [DisplayGrants[0]]);

  FUnionUsers := TStringList.Create;
  FAbsentUsers := TStringList.Create;

  FSelectG := TStringList.Create;
  FUpdateG := TStringList.Create;
  FDeleteG := TStringList.Create;
  FInsertG := TStringList.Create;
  FReferenceG := TStringList.Create;
  FExecuteG := TStringList.Create;

  FSelectGO := TStringList.Create;
  FUpdateGO := TStringList.Create;
  FDeleteGO := TStringList.Create;
  FInsertGO := TStringList.Create;
  FReferenceGO := TStringList.Create;
  FExecuteGO := TStringList.Create;

  vComponentClass := Designer.GetComponent(IibSHDatabase);
  if Assigned(vComponentClass) then
  begin
    FIntDatabase := vComponentClass.Create(Self);
    Supports(FIntDatabase, IibSHDatabase, FIntDatabaseIntf);
  end;
end;

destructor TibSHDDLGrantor.Destroy;
begin
  FUnionUsers.Free;
  FAbsentUsers.Free;

  FSelectG.Free;
  FUpdateG.Free;
  FDeleteG.Free;
  FInsertG.Free;
  FReferenceG.Free;
  FExecuteG.Free;

  FSelectGO.Free;
  FUpdateGO.Free;
  FDeleteGO.Free;
  FInsertGO.Free;
  FReferenceGO.Free;
  FExecuteGO.Free;

  FIntDatabaseIntf := nil;
  FreeAndNil(FIntDatabase);

  inherited Destroy;
end;

function TibSHDDLGrantor.GetPrivilegesFor: string;
begin
  Result := FPrivilegesFor;
end;

procedure TibSHDDLGrantor.SetPrivilegesFor(Value: string);
var
  vForm: IibSHDDLGrantorForm;
begin
  if FPrivilegesFor <> Value then
  begin
    FPrivilegesFor := Value;
    if GetComponentFormIntf(IibSHDDLGrantorForm, vForm) then
      vForm.RefreshPrivilegesForTree;
  end;
end;

function TibSHDDLGrantor.GetGrantsOn: string;
begin
  Result := FGrantsOn;
end;

procedure TibSHDDLGrantor.SetGrantsOn(Value: string);
var
  vForm: IibSHDDLGrantorForm;
begin
  if FGrantsOn <> Value then
  begin
    FGrantsOn := Value;
    if GetComponentFormIntf(IibSHDDLGrantorForm, vForm) then
      vForm.RefreshGrantsOnTree;
    if (FGrantsOn = GrantTypes[0]) or (FGrantsOn = GrantTypes[1]) then
    begin
      MakePropertyVisible('SystemTables');
      MakePropertyVisible('TableFields');
    end else
    begin
      MakePropertyInvisible('SystemTables');
      MakePropertyInvisible('TableFields');
    end;
    Designer.UpdateObjectInspector;
  end;
end;

function TibSHDDLGrantor.GetDisplay: string;
begin
  Result := FDisplay;
end;

procedure TibSHDDLGrantor.SetDisplay(Value: string);
var
  vForm: IibSHDDLGrantorForm;
begin
  if FDisplay <> Value then
  begin
    FDisplay := Value;
    if GetComponentFormIntf(IibSHDDLGrantorForm, vForm) then
      vForm.RefreshGrantsOnTree;
  end;
end;

function TibSHDDLGrantor.GetShowSystemTables: Boolean;
begin
  Result := FShowSystemTables;
end;

procedure TibSHDDLGrantor.SetShowSystemTables(Value: Boolean);
var
  vForm: IibSHDDLGrantorForm;
begin
  if FShowSystemTables <> Value then
  begin
    FShowSystemTables := Value;
    if (GrantsOn = GrantTypes[0]) or (GrantsOn = GrantTypes[1]) then
      if GetComponentFormIntf(IibSHDDLGrantorForm, vForm) then
        vForm.RefreshGrantsOnTree;
  end;
end;

function TibSHDDLGrantor.GetIncludeFields: Boolean;
begin
  Result := FIncludeFields;
end;

procedure TibSHDDLGrantor.SetIncludeFields(Value: Boolean);
var
  vForm: IibSHDDLGrantorForm;
begin
  if FIncludeFields <> Value then
  begin
    FIncludeFields := Value;
    if (GrantsOn = GrantTypes[0]) or (GrantsOn = GrantTypes[1]) or (GrantsOn = GrantTypes[2]) then
      if GetComponentFormIntf(IibSHDDLGrantorForm, vForm) then
        vForm.RefreshGrantsOnTree;
  end;
end;

procedure TibSHDDLGrantor.ClearLists;
begin
  FSelectG.Clear;
  FUpdateG.Clear;
  FDeleteG.Clear;
  FInsertG.Clear;
  FReferenceG.Clear;
  FExecuteG.Clear;

  FSelectGO.Clear;
  FUpdateGO.Clear;
  FDeleteGO.Clear;
  FInsertGO.Clear;
  FReferenceGO.Clear;
  FExecuteGO.Clear;

  TStringList(FSelectG).Sorted := False;
  TStringList(FUpdateG).Sorted := False;
  TStringList(FDeleteG).Sorted := False;
  TStringList(FInsertG).Sorted := False;
  TStringList(FReferenceG).Sorted := False;
  TStringList(FExecuteG).Sorted := False;

  TStringList(FSelectGO).Sorted := False;
  TStringList(FUpdateGO).Sorted := False;
  TStringList(FDeleteGO).Sorted := False;
  TStringList(FInsertGO).Sorted := False;
  TStringList(FReferenceGO).Sorted := False;
  TStringList(FExecuteGO).Sorted := False;
end;

procedure TibSHDDLGrantor.SortLists;
begin
  TStringList(FSelectG).Sort;
  TStringList(FUpdateG).Sort;
  TStringList(FDeleteG).Sort;
  TStringList(FInsertG).Sort;
  TStringList(FReferenceG).Sort;
  TStringList(FExecuteG).Sort;

  TStringList(FSelectGO).Sort;
  TStringList(FUpdateGO).Sort;
  TStringList(FDeleteGO).Sort;
  TStringList(FInsertGO).Sort;
  TStringList(FReferenceGO).Sort;
  TStringList(FExecuteGO).Sort;
end;

function TibSHDDLGrantor.GetUnionUsers: TStrings;
var
  I: Integer;
  DoSecurityConnect: Boolean;
begin
  DoSecurityConnect := False;
  if FUnionUsers.Count = 0 then
  begin
    if Assigned(BTCLDatabase) then
    begin
      if Assigned(FIntDatabaseIntf) then
      begin
        FIntDatabaseIntf.OwnerIID := BTCLDatabase.OwnerIID;
        FIntDatabaseIntf.Database := BTCLDatabase.BTCLServer.SecurityDatabase;
        FIntDatabaseIntf.StillConnect := True;
      end;

      if BTCLDatabase.BTCLServer.PrepareDRVService and BTCLDatabase.BTCLServer.DRVService.Attach(stSecurityService) then
      begin
        try
          try
            BTCLDatabase.BTCLServer.DRVService.DisplayUsers;
          except
            DoSecurityConnect := True;
          end;
          for I := 0 to Pred(BTCLDatabase.BTCLServer.DRVService.UserCount) do
            FUnionUsers.Add(BTCLDatabase.BTCLServer.DRVService.GetUserName(I));
        finally
          BTCLDatabase.BTCLServer.DRVService.Detach;
        end;
      end else
        DoSecurityConnect := True;

      if DoSecurityConnect then
      begin
        try
          if FIntDatabaseIntf.Connect then
            if FIntDatabaseIntf.DRVQuery.ExecSQL(FormatSQL(SQL_GET_USERS_FROM_SECURITY), [], False) then
              while not FIntDatabaseIntf.DRVQuery.Eof do
              begin
                FUnionUsers.Add(FIntDatabaseIntf.DRVQuery.GetFieldStrValue('USER_NAME'));
                FIntDatabaseIntf.DRVQuery.Next;
              end;
        finally
          FIntDatabaseIntf.DRVQuery.Transaction.Commit;
          FIntDatabaseIntf.Disconnect;
        end;
      end;

      if BTCLDatabase.DRVQuery.ExecSQL(FormatSQL(SQL_GET_USERS_FROM_PRIVILEGES), [], False) then
      begin
        while not BTCLDatabase.DRVQuery.Eof do
        begin
          if FUnionUsers.IndexOf(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME')) = - 1 then
          begin
            if FUnionUsers.IndexOf(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME')) = -1 then
            begin
              FUnionUsers.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'));
              if BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME') <> 'PUBLIC' then
                FAbsentUsers.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('USER_NAME'));
            end;
          end;
          BTCLDatabase.DRVQuery.Next;
        end;
      end;
      BTCLDatabase.DRVQuery.Transaction.Commit;
    end;
  end;
  TStringList(FUnionUsers).Sort;
  TStringList(FAbsentUsers).Sort;
  Result := FUnionUsers;
end;

function TibSHDDLGrantor.GetAbsentUsers: TStrings;
begin
  Result := FAbsentUsers;
end;

procedure TibSHDDLGrantor.ExtractGrants(const AClassIID: TGUID; const ACaption: string);
var
  SQL: string;
begin
  SQL := EmptyStr;
  ClearLists;

  if IsEqualGUID(AClassIID, IibSHView) then SQL := FormatSQL(SQL_GET_GRANTS_ON_FOR_VIEW);
  if IsEqualGUID(AClassIID, IibSHProcedure) then SQL := FormatSQL(SQL_GET_GRANTS_ON_FOR_PROCEDURE);
  if IsEqualGUID(AClassIID, IibSHTrigger) then SQL := FormatSQL(SQL_GET_GRANTS_ON_FOR_TRIGGER);
  if IsEqualGUID(AClassIID, IibSHRole) then SQL := FormatSQL(SQL_GET_GRANTS_ON_FOR_ROLE);
  if IsEqualGUID(AClassIID, IibSHUser) then SQL := FormatSQL(SQL_GET_GRANTS_ON_FOR_USER);

  if not Assigned(BTCLDatabase) or (Length(ACaption) = 0) or (Length(SQL) = 0) then Exit;
  if BTCLDatabase.DRVQuery.ExecSQL(SQL, [ACaption], False) then
  begin
    while not BTCLDatabase.DRVQuery.Eof do
    begin
      if BTCLDatabase.DRVQuery.GetFieldIntValue('GRANT_OPTION') <> 1 then
      begin
        if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'S' then
          FSelectG.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'));

        if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'U' then
          if Length(BTCLDatabase.DRVQuery.GetFieldStrValue('FIELD_NAME')) > 0 then
            FUpdateG.Add(Format('%s.%s', [BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'), BTCLDatabase.DRVQuery.GetFieldStrValue('FIELD_NAME')]))
          else
            FUpdateG.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'));

        if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'D' then
          FDeleteG.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'));

        if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'I' then
          FInsertG.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'));

        if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'R' then
          if Length(BTCLDatabase.DRVQuery.GetFieldStrValue('FIELD_NAME')) > 0 then
            FReferenceG.Add(Format('%s.%s', [BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'), BTCLDatabase.DRVQuery.GetFieldStrValue('FIELD_NAME')]))
          else
            FReferenceG.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'));

        if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'X' then
          FExecuteG.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'));
      end else
      begin
        if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'S' then
          FSelectGO.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'));

        if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'U' then
          if Length(BTCLDatabase.DRVQuery.GetFieldStrValue('FIELD_NAME')) > 0 then
            FUpdateGO.Add(Format('%s.%s', [BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'), BTCLDatabase.DRVQuery.GetFieldStrValue('FIELD_NAME')]))
          else
            FUpdateGO.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'));

        if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'D' then
          FDeleteGO.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'));

        if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'I' then
          FInsertGO.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'));

        if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'R' then
          if Length(BTCLDatabase.DRVQuery.GetFieldStrValue('FIELD_NAME')) > 0 then
            FReferenceGO.Add(Format('%s.%s', [BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'), BTCLDatabase.DRVQuery.GetFieldStrValue('FIELD_NAME')]))
          else
            FReferenceGO.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'));

        if BTCLDatabase.DRVQuery.GetFieldStrValue('PRIVILEGE') = 'X' then
          FExecuteGO.Add(BTCLDatabase.DRVQuery.GetFieldStrValue('OBJECT_NAME'));
      end;
      BTCLDatabase.DRVQuery.Next;
    end;
  end;
  BTCLDatabase.DRVQuery.Transaction.Commit;
  SortLists;
end;

function TibSHDDLGrantor.GetGrantSelectIndex(const ACaption: string): Integer;
begin
  Result := -1;
  if FSelectG.IndexOf(ACaption) <> -1 then Result := 0 else
  if FSelectGO.IndexOf(ACaption) <> -1 then Result := 1;
end;

function TibSHDDLGrantor.GetGrantUpdateIndex(const ACaption: string): Integer;
begin
  Result := -1;
  if FUpdateG.IndexOf(ACaption) <> -1 then Result := 0 else
  if FUpdateGO.IndexOf(ACaption) <> -1 then Result := 1;
end;

function TibSHDDLGrantor.GetGrantDeleteIndex(const ACaption: string): Integer;
begin
  Result := -1;
  if FDeleteG.IndexOf(ACaption) <> -1 then Result := 0 else
  if FDeleteGO.IndexOf(ACaption) <> -1 then Result := 1;
end;

function TibSHDDLGrantor.GetGrantInsertIndex(const ACaption: string): Integer;
begin
  Result := -1;
  if FInsertG.IndexOf(ACaption) <> -1 then Result := 0 else
  if FInsertGO.IndexOf(ACaption) <> -1 then Result := 1;
end;

function TibSHDDLGrantor.GetGrantReferenceIndex(const ACaption: string): Integer;
begin
  Result := -1;
  if FReferenceG.IndexOf(ACaption) <> -1 then Result := 0 else
  if FReferenceGO.IndexOf(ACaption) <> -1 then Result := 1;
end;

function TibSHDDLGrantor.GetGrantExecuteIndex(const ACaption: string): Integer;
begin
  Result := -1;
  if FExecuteG.IndexOf(ACaption) <> -1 then Result := 0 else
  if FExecuteGO.IndexOf(ACaption) <> -1 then Result := 1;
  Result := Result;
end;

function TibSHDDLGrantor.IsGranted(const ACaption: string): Boolean;
begin
  Result :=
    (GetGrantSelectIndex(ACaption) <> -1) or
    (GetGrantUpdateIndex(ACaption) <> -1) or
    (GetGrantDeleteIndex(ACaption) <> -1) or
    (GetGrantInsertIndex(ACaption) <> -1) or
    (GetGrantReferenceIndex(ACaption) <> -1) or
    (GetGrantExecuteIndex(ACaption) <> -1);
end;

function TibSHDDLGrantor.GetNormalizeName(const ACaption: string): string;
var
  vCodeNormalizer: IibSHCodeNormalizer;
begin
  Result := ACaption;
  if Supports(Designer.GetDemon(IibSHCodeNormalizer), IibSHCodeNormalizer, vCodeNormalizer) then
    Result := vCodeNormalizer.MetadataNameToSourceDDL(BTCLDatabase, Result);
end;

function TibSHDDLGrantor.GetPrivilegesForName(const AClassIID: TGUID; const ACaption: string): string;
begin
  if IsEqualGUID(AClassIID, IibSHView) then Result := Format('VIEW %s', [GetNormalizeName(ACaption)]);
  if IsEqualGUID(AClassIID, IibSHProcedure) then Result := Format('PROCEDURE %s', [GetNormalizeName(ACaption)]);
  if IsEqualGUID(AClassIID, IibSHTrigger) then Result := Format('TRIGGER %s', [GetNormalizeName(ACaption)]);
  if IsEqualGUID(AClassIID, IibSHRole) then Result := Format('%s', [GetNormalizeName(ACaption)]);
  if IsEqualGUID(AClassIID, IibSHUser) then
  begin
    if AnsiSameText(ACaption, 'PUBLIC') then
      Result := Format('PUBLIC', [])
    else
      Result := Format('USER %s', [GetNormalizeName(ACaption)]);
  end;
end;

function TibSHDDLGrantor.GrantTable(const AClassIID: TGUID; const Privilege, OnObject, ToObject: string; WGO: Boolean): Boolean;
var
  S1, S2, SQL: string;
  I: Integer;
begin
  S1 := GetNormalizeName(OnObject);
  S2 := GetPrivilegesForName(AClassIID, ToObject);
  if not WGO then SQL := FormatSQL(SQL_GRANT_TABLE) else SQL := FormatSQL(SQL_GRANT_TABLE_WGO);
  try
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRWriteParams;
    Result := BTCLDatabase.DRVQuery.ExecSQL(Format(SQL, [Privilege, S1, S2]), [], True);
    if Result then
    begin
      if not WGO then
      begin
        if AnsiUpperCase(Privilege) = 'SELECT' then
        begin
          I := FSelectG.IndexOf(OnObject);
          if I = -1 then FSelectG.Add(OnObject);
        end;
        if AnsiUpperCase(Privilege) = 'UPDATE' then
        begin
          I := FUpdateG.IndexOf(OnObject);
          if I = -1 then FUpdateG.Add(OnObject);
        end;
        if AnsiUpperCase(Privilege) = 'DELETE' then
        begin
          I := FDeleteG.IndexOf(OnObject);
          if I = -1 then FDeleteG.Add(OnObject);
        end;
        if AnsiUpperCase(Privilege) = 'INSERT' then
        begin
          I := FInsertG.IndexOf(OnObject);
          if I = -1 then FInsertG.Add(OnObject);
        end;
        if AnsiUpperCase(Privilege) = 'REFERENCES' then
        begin
          I := FReferenceG.IndexOf(OnObject);
          if I = -1 then FReferenceG.Add(OnObject);
        end;
      end else
      begin
        if AnsiUpperCase(Privilege) = 'SELECT' then
        begin
          I := FSelectGO.IndexOf(OnObject);
          if I = -1 then FSelectGO.Add(OnObject);
        end;
        if AnsiUpperCase(Privilege) = 'UPDATE' then
        begin
          I := FUpdateGO.IndexOf(OnObject);
          if I = -1 then FUpdateGO.Add(OnObject);
        end;
        if AnsiUpperCase(Privilege) = 'DELETE' then
        begin
          I := FDeleteGO.IndexOf(OnObject);
          if I = -1 then FDeleteGO.Add(OnObject);
        end;
        if AnsiUpperCase(Privilege) = 'INSERT' then
        begin
          I := FInsertGO.IndexOf(OnObject);
          if I = -1 then FInsertGO.Add(OnObject);
        end;
        if AnsiUpperCase(Privilege) = 'REFERENCES' then
        begin
          I := FReferenceGO.IndexOf(OnObject);
          if I = -1 then FReferenceGO.Add(OnObject);
        end;
      end;
    end;
  finally
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRReadParams;
  end;
end;

function TibSHDDLGrantor.GrantTableField(const AClassIID: TGUID; const Privilege, OnField, OnObject, ToObject: string; WGO: Boolean): Boolean;
var
  S0, S1, S2, SQL: string;
  I: Integer;
begin
  S0 := GetNormalizeName(OnField);
  S1 := GetNormalizeName(OnObject);
  S2 := GetPrivilegesForName(AClassIID, ToObject);

  if not WGO then SQL := FormatSQL(SQL_GRANT_TABLE_FIELD) else SQL := FormatSQL(SQL_GRANT_TABLE_FIELD_WGO);

  try
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRWriteParams;
    Result := BTCLDatabase.DRVQuery.ExecSQL(Format(SQL, [Privilege, S0, S1, S2]), [], True);
    if Result then
    begin
      if not WGO then
      begin
        if AnsiUpperCase(Privilege) = 'UPDATE' then
        begin
          I := FUpdateG.IndexOf(Format('%s.%s', [OnObject, OnField]));
          if I = -1 then FUpdateG.Add(Format('%s.%s', [OnObject, OnField]));
        end;
        if AnsiUpperCase(Privilege) = 'REFERENCES' then
        begin
          I := FReferenceG.IndexOf(Format('%s.%s', [OnObject, OnField]));
          if I = -1 then FReferenceG.Add(Format('%s.%s', [OnObject, OnField]));
        end;
      end else
      begin
        if AnsiUpperCase(Privilege) = 'UPDATE' then
        begin
          I := FUpdateGO.IndexOf(Format('%s.%s', [OnObject, OnField]));
          if I = -1 then FUpdateGO.Add(Format('%s.%s', [OnObject, OnField]));
        end;
        if AnsiUpperCase(Privilege) = 'REFERENCES' then
        begin
          I := FReferenceGO.IndexOf(Format('%s.%s', [OnObject, OnField]));
          if I = -1 then FReferenceGO.Add(Format('%s.%s', [OnObject, OnField]));
        end;
      end;
    end;
  finally
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRReadParams;
  end;
end;

function TibSHDDLGrantor.GrantProcedure(const AClassIID: TGUID; const OnObject, ToObject: string; WGO: Boolean): Boolean;
var
  S1, S2, SQL: string;
  I: Integer;
begin
  S1 := GetNormalizeName(OnObject);
  S2 := GetPrivilegesForName(AClassIID, ToObject);

  if not WGO then SQL := FormatSQL(SQL_GRANT_PROCEDURE) else SQL := FormatSQL(SQL_GRANT_PROCEDURE_WGO);

  try
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRWriteParams;
    Result := BTCLDatabase.DRVQuery.ExecSQL(Format(SQL, [S1, S2]), [], True);
    if Result then
    begin
      if not WGO then
      begin
        I := FExecuteG.IndexOf(OnObject);
        if I = -1 then FExecuteG.Add(OnObject);
      end else
      begin
        I := FExecuteGO.IndexOf(OnObject);
        if I = -1 then FExecuteGO.Add(OnObject);
      end;
    end;
  finally
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRReadParams;
  end;
end;

function TibSHDDLGrantor.RevokeTable(const AClassIID: TGUID; const Privilege, OnObject, FromObject: string; WGO: Boolean): Boolean;
var
  S1, S2, SQL: string;
  I: Integer;
begin
  S1 := GetNormalizeName(OnObject);
  S2 := GetPrivilegesForName(AClassIID, FromObject);

  if not WGO then SQL := FormatSQL(SQL_REVOKE_TABLE) else SQL := FormatSQL(SQL_REVOKE_TABLE_WGO);

  try
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRWriteParams;
    Result := BTCLDatabase.DRVQuery.ExecSQL(Format(SQL, [Privilege, S1, S2]), [], True);
    if Result then
    begin
      if AnsiUpperCase(Privilege) = 'SELECT' then
      begin
        I := FSelectG.IndexOf(OnObject);
        if I <> -1 then FSelectG.Delete(I);
        I := FSelectGO.IndexOf(OnObject);
        if I <> -1 then FSelectGO.Delete(I);
      end;
      if AnsiUpperCase(Privilege) = 'UPDATE' then
      begin
        I := FUpdateG.IndexOf(OnObject);
        if I <> -1 then FUpdateG.Delete(I);
        I := FUpdateGO.IndexOf(OnObject);
        if I <> -1 then FUpdateGO.Delete(I);
      end;
      if AnsiUpperCase(Privilege) = 'DELETE' then
      begin
        I := FDeleteG.IndexOf(OnObject);
        if I <> -1 then FDeleteG.Delete(I);
        I := FDeleteGO.IndexOf(OnObject);
        if I <> -1 then FDeleteGO.Delete(I);
      end;
      if AnsiUpperCase(Privilege) = 'INSERT' then
      begin
        I := FInsertG.IndexOf(OnObject);
        if I <> -1 then FInsertG.Delete(I);
        I := FInsertGO.IndexOf(OnObject);
        if I <> -1 then FInsertGO.Delete(I);
      end;
      if AnsiUpperCase(Privilege) = 'REFERENCES' then
      begin
        I := FReferenceG.IndexOf(OnObject);
        if I <> -1 then FReferenceG.Delete(I);
        I := FReferenceGO.IndexOf(OnObject);
        if I <> -1 then FReferenceGO.Delete(I);
      end;

      if WGO then
      begin
        if AnsiUpperCase(Privilege) = 'SELECT' then
        begin
          I := FSelectG.IndexOf(OnObject);
          if I = -1 then FSelectG.Add(OnObject);
        end;
        if AnsiUpperCase(Privilege) = 'UPDATE' then
        begin
          I := FUpdateG.IndexOf(OnObject);
          if I = -1 then FUpdateG.Add(OnObject);
        end;
        if AnsiUpperCase(Privilege) = 'DELETE' then
        begin
          I := FDeleteG.IndexOf(OnObject);
          if I = -1 then FDeleteG.Add(OnObject);
        end;
        if AnsiUpperCase(Privilege) = 'INSERT' then
        begin
          I := FInsertG.IndexOf(OnObject);
          if I = -1 then FInsertG.Add(OnObject);
        end;
        if AnsiUpperCase(Privilege) = 'REFERENCES' then
        begin
          I := FReferenceG.IndexOf(OnObject);
          if I = -1 then FReferenceG.Add(OnObject);
        end;
      end;
    end;
  finally
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRReadParams;
  end;
end;

function TibSHDDLGrantor.RevokeTableField(const AClassIID: TGUID; const Privilege, OnField, OnObject, FromObject: string; WGO: Boolean): Boolean;
var
  S0, S1, S2, SQL: string;
  I: Integer;
begin
  S0 := GetNormalizeName(OnField);
  S1 := GetNormalizeName(OnObject);
  S2 := GetPrivilegesForName(AClassIID, FromObject);

  if not WGO then SQL := FormatSQL(SQL_REVOKE_TABLE_FIELD) else SQL := FormatSQL(SQL_REVOKE_TABLE_FIELD_WGO);

  try
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRWriteParams;
    Result := BTCLDatabase.DRVQuery.ExecSQL(Format(SQL, [Privilege, S0, S1, S2]), [], True);
    if Result then
    begin
      if AnsiUpperCase(Privilege) = 'UPDATE' then
      begin
        I := FUpdateG.IndexOf(Format('%s.%s', [OnObject, OnField]));
        if I <> -1 then FUpdateG.Delete(I);
        I := FUpdateGO.IndexOf(Format('%s.%s', [OnObject, OnField]));
        if I <> -1 then FUpdateGO.Delete(I);
      end;
      if AnsiUpperCase(Privilege) = 'REFERENCES' then
      begin
        I := FReferenceG.IndexOf(Format('%s.%s', [OnObject, OnField]));
        if I <> -1 then FReferenceG.Delete(I);
        I := FReferenceGO.IndexOf(Format('%s.%s', [OnObject, OnField]));
        if I <> -1 then FReferenceGO.Delete(I);
      end;

      if WGO then
      begin
        if AnsiUpperCase(Privilege) = 'UPDATE' then
        begin
          I := FUpdateG.IndexOf(Format('%s.%s', [OnObject, OnField]));
          if I = -1 then FUpdateG.Add(Format('%s.%s', [OnObject, OnField]));
        end;
        if AnsiUpperCase(Privilege) = 'REFERENCES' then
        begin
          I := FReferenceG.IndexOf(Format('%s.%s', [OnObject, OnField]));
          if I = -1 then FReferenceG.Add(Format('%s.%s', [OnObject, OnField]));
        end;
      end;
    end;
  finally
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRReadParams;
  end;
end;

function TibSHDDLGrantor.RevokeProcedure(const AClassIID: TGUID; const OnObject, FromObject: string; WGO: Boolean): Boolean;
var
  S1, S2, SQL: string;
  I: Integer;
begin
  S1 := GetNormalizeName(OnObject);
  S2 := GetPrivilegesForName(AClassIID, FromObject);

  if not WGO then SQL := FormatSQL(SQL_REVOKE_PROCEDURE) else SQL := FormatSQL(SQL_REVOKE_PROCEDURE_WGO);

  try
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRWriteParams;
    Result := BTCLDatabase.DRVQuery.ExecSQL(Format(SQL, [S1, S2]), [], True);
    if Result then
    begin
      I := FExecuteG.IndexOf(OnObject);
      if I <> -1 then FExecuteG.Delete(I);
      I := FExecuteGO.IndexOf(OnObject);
      if I <> -1 then FExecuteGO.Delete(I);
      if WGO then
      begin
        I := FExecuteG.IndexOf(OnObject);
        if I = -1 then FExecuteG.Add(OnObject);
      end;
    end;
  finally
    BTCLDatabase.DRVQuery.Transaction.Params.Text := TRReadParams;
  end;
end;


initialization

  Register;

end.


