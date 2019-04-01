unit ibSHUserManager;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDriverIntf, ibSHComponent, ibSHTool;

type
  TibSHUserManager = class(TibBTTool, IibSHUserManager, IibSHBranch, IfbSHBranch)
  private
    FIntDatabase: TComponent;
    FIntDatabaseIntf: IibSHDatabase;

    FServer: string;

    FUserNameList: TStrings;
    FFirstNameList: TStrings;
    FMiddleNameList: TStrings;
    FLastNameList: TStrings;
    FPasswordList: TStrings;
    function GetServer: string;
    procedure SetServer(Value: string);
    // IibSHUserManager
    procedure DisplayUsers;
    function GetUserCount: Integer;
    function GetUserName(AIndex: Integer): string;
    function GetFirstName(AIndex: Integer): string;
    function GetMiddleName(AIndex: Integer): string;
    function GetLastName(AIndex: Integer): string;
    function GetConnectCount(const UserName: string): Integer;
    function AddUser(const UserName, Password, FirstName, MiddleName, LastName: string): Boolean;
    function ModifyUser(const UserName, Password, FirstName, MiddleName, LastName: string): Boolean;
    function DeleteUser(const UserName: string): Boolean;
  protected
    procedure SetOwnerIID(Value: TGUID); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Server: string read GetServer write SetServer;
    property UserCount: Integer read GetUserCount;
  end;

  TibSHUserManagerFactory = class(TibBTToolFactory)
  end;

  TibSHUser = class(TibBTComponent, IibSHUser)
  private
    FUserName: string;
    FPassword: string;
    FFirstName: string;
    FMiddleName: string;
    FLastName: string;

    function GetUserName: string;
    procedure SetUserName(Value: string);
    function GetPassword: string;
    procedure SetPassword(Value: string);
    function GetFirstName: string;
    procedure SetFirstName(Value: string);
    function GetMiddleName: string;
    procedure SetMiddleName(Value: string);
    function GetLastName: string;
    procedure SetLastName(Value: string);
  published
    property UserName: string read GetUserName write SetUserName;
    property Password: string read GetPassword write SetPassword;
    property FirstName: string read GetFirstName write SetFirstName;
    property MiddleName: string read GetMiddleName write SetMiddleName;
    property LastName: string read GetLastName write SetLastName;
  end;

procedure Register;

implementation

uses
  ibSHConsts, ibSHSQLs, ibSHValues, ibSHPassword,
  ibSHUserManagerActions,
  ibSHUserManagerEditors;

procedure Register;
begin
  SHRegisterImage(GUIDToString(IibSHUserManager), 'UserManager.bmp');
  SHRegisterImage(GUIDToString(IibSHUser),        'User.bmp');

  SHRegisterImage(TibSHUserManagerPaletteAction.ClassName,          'UserManager.bmp');
  SHRegisterImage(TibSHUserManagerFormAction.ClassName,             'User.bmp');
  SHRegisterImage(TibSHUserManagerToolbarAction_Create.ClassName,   'Button_Create.bmp');
  SHRegisterImage(TibSHUserManagerToolbarAction_Alter.ClassName,    'Button_Alter.bmp');
  SHRegisterImage(TibSHUserManagerToolbarAction_Drop.ClassName,     'Button_Drop.bmp');
  SHRegisterImage(TibSHUserManagerToolbarAction_Refresh.ClassName,  'Button_Refresh.bmp');

  SHRegisterImage(SCallUsers, 'User.bmp');

  SHRegisterComponents([
    TibSHUserManager,
    TibSHUserManagerFactory,
    TibSHUser]);

  SHRegisterActions([
    // Palette
    TibSHUserManagerPaletteAction,
    // Forms
    TibSHUserManagerFormAction,
    // Toolbar
    TibSHUserManagerToolbarAction_Create,
    TibSHUserManagerToolbarAction_Alter,
    TibSHUserManagerToolbarAction_Drop,
    TibSHUserManagerToolbarAction_Refresh]);

  SHRegisterPropertyEditor(IUnknown, SCallAccessMode, TibBTAccessModePropEditor);
end;

{ TibSHUserManager }

constructor TibSHUserManager.Create(AOwner: TComponent);
var
  vComponentClass: TSHComponentClass;
begin
  inherited Create(AOwner);
  FUserNameList := TStringList.Create;
  FFirstNameList := TStringList.Create;
  FMiddleNameList := TStringList.Create;
  FLastNameList := TStringList.Create;
  FPasswordList := TStringList.Create;

  vComponentClass := Designer.GetComponent(IibSHDatabase);
  if Assigned(vComponentClass) then
  begin
    FIntDatabase := vComponentClass.Create(Self);
    Supports(FIntDatabase, IibSHDatabase, FIntDatabaseIntf);
  end;
end;

destructor TibSHUserManager.Destroy;
begin
  FUserNameList.Free;
  FFirstNameList.Free;
  FMiddleNameList.Free;
  FLastNameList.Free;
  FPasswordList.Free;

  FIntDatabaseIntf := nil;
  FreeAndNil(FIntDatabase);
  inherited Destroy;
end;

function TibSHUserManager.GetServer: string;
begin
  if Assigned(BTCLServer) then
    Result := Format('%s (%s)  ', [BTCLServer.Caption, BTCLServer.CaptionExt]);
end;

procedure TibSHUserManager.SetServer(Value: string);
begin
  FServer := Value;
end;

procedure TibSHUserManager.SetOwnerIID(Value: TGUID);
begin
  inherited SetOwnerIID(Value);
  if Assigned(Designer.CurrentComponent) and Supports(Designer.CurrentComponent, IibSHUserManager) then
    if Assigned(Designer.CurrentComponentForm) and Supports(Designer.CurrentComponentForm, ISHRunCommands) then
      (Designer.CurrentComponentForm as ISHRunCommands).Refresh;
end;

procedure TibSHUserManager.DisplayUsers;
var
  I: Integer;
  DoSecurityConnect: Boolean;
begin
  DoSecurityConnect := False;

  FUserNameList.Clear;
  FFirstNameList.Clear;
  FMiddleNameList.Clear;
  FLastNameList.Clear;
  FPasswordList.Clear;

  if Assigned(BTCLServer) then
  begin
    if Assigned(FIntDatabaseIntf) then
    begin
      FIntDatabaseIntf.OwnerIID := BTCLServer.InstanceIID;
      FIntDatabaseIntf.Database := BTCLServer.SecurityDatabase;
      FIntDatabaseIntf.StillConnect := True;
    end;

    if BTCLServer.PrepareDRVService and BTCLServer.DRVService.Attach(stSecurityService) then
    begin
      try
        try
          BTCLServer.DRVService.DisplayUsers;
        except
          DoSecurityConnect := True;
        end;
        for I := 0 to Pred(BTCLServer.DRVService.UserCount) do
        begin
          FUserNameList.Add(BTCLServer.DRVService.GetUserName(I));
          FFirstNameList.Add(BTCLServer.DRVService.GetFirstName(I));
          FMiddleNameList.Add(BTCLServer.DRVService.GetMiddleName(I));
          FLastNameList.Add(BTCLServer.DRVService.GetLastName(I));
          FPasswordList.Add('');
        end;
      finally
        BTCLServer.DRVService.Detach;
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
              FUserNameList.Add(FIntDatabaseIntf.DRVQuery.GetFieldStrValue('USER_NAME'));
              FFirstNameList.Add(FIntDatabaseIntf.DRVQuery.GetFieldStrValue('FIRST_NAME'));
              FMiddleNameList.Add(FIntDatabaseIntf.DRVQuery.GetFieldStrValue('MIDDLE_NAME'));
              FLastNameList.Add(FIntDatabaseIntf.DRVQuery.GetFieldStrValue('LAST_NAME'));
              FPasswordList.Add(FIntDatabaseIntf.DRVQuery.GetFieldStrValue('PASSWD'));
              FIntDatabaseIntf.DRVQuery.Next;
            end;
      finally
        FIntDatabaseIntf.DRVQuery.Transaction.Commit;
        FIntDatabaseIntf.Disconnect;
      end;
    end;
  end;
end;

function TibSHUserManager.GetUserCount: Integer;
begin
  Result := FUserNameList.Count;
end;

function TibSHUserManager.GetUserName(AIndex: Integer): string;
begin
  Result := FUserNameList[AIndex];
end;

function TibSHUserManager.GetFirstName(AIndex: Integer): string;
begin
  Result := FFirstNameList[AIndex];
end;

function TibSHUserManager.GetMiddleName(AIndex: Integer): string;
begin
  Result := FMiddleNameList[AIndex];
end;

function TibSHUserManager.GetLastName(AIndex: Integer): string;
begin
  Result := FLastNameList[AIndex];
end;

function TibSHUserManager.GetConnectCount(const UserName: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  if Assigned(BTCLDatabase) then
  begin
    for I := 0 to Pred(BTCLDatabase.DRVQuery.Database.UserNames.Count) do
      if AnsiSameText(BTCLDatabase.DRVQuery.Database.UserNames[I], UserName) then
        Result := Result + 1;
  end;
end;

function TibSHUserManager.AddUser(const UserName, Password, FirstName, MiddleName, LastName: string): Boolean;
var
  DoSecurityConnect: Boolean;
begin
  Result := False;
  DoSecurityConnect := False;
  if Assigned(BTCLServer) then
  begin
    if BTCLServer.PrepareDRVService and BTCLServer.DRVService.Attach(stSecurityService) then
    begin
      try
        try
          Result := BTCLServer.DRVService.AddUser(UserName, Password, FirstName, MiddleName, LastName);
        except
          DoSecurityConnect := True;
        end;
      finally
        BTCLServer.DRVService.Detach;
      end;
    end else
      DoSecurityConnect := True;

    if DoSecurityConnect then
    begin
      try
        if FIntDatabaseIntf.Connect then
        begin
          FIntDatabaseIntf.DRVQuery.Transaction.Params.Text := TRWriteParams;
          Result := FIntDatabaseIntf.DRVQuery.ExecSQL(Format(FormatSQL(SQL_INSERT_SECURITY), [UserName, CreateInterbasePassword(Password), FirstName, MiddleName, LastName]), [], True);
        end;
      finally
        FIntDatabaseIntf.DRVQuery.Transaction.Params.Text := TRReadParams;
        FIntDatabaseIntf.Disconnect;
      end;
    end;

    FUserNameList.Add(UserName);
    FFirstNameList.Add(FirstName);
    FMiddleNameList.Add(MiddleName);
    FLastNameList.Add(LastName);
    FPasswordList.Add('');
  end;
end;

function TibSHUserManager.ModifyUser(const UserName, Password, FirstName, MiddleName, LastName: string): Boolean;
var
  I: Integer;
  DoSecurityConnect: Boolean;
begin
  Result := False;
  DoSecurityConnect := False;
  if Assigned(BTCLServer) then
  begin
    if BTCLServer.PrepareDRVService and BTCLServer.DRVService.Attach(stSecurityService) then
    begin
      try
        try
          Result := BTCLServer.DRVService.ModifyUser(UserName, Password, FirstName, MiddleName, LastName);
        except
          DoSecurityConnect := True;
        end;
      finally
        BTCLServer.DRVService.Detach;
      end;
    end else
      DoSecurityConnect := True;

    if DoSecurityConnect then
    begin
      try
        if FIntDatabaseIntf.Connect then
        begin
          FIntDatabaseIntf.DRVQuery.Transaction.Params.Text := TRWriteParams;
          Result := FIntDatabaseIntf.DRVQuery.ExecSQL(Format(FormatSQL(SQL_UPDATE_SECURITY), [CreateInterbasePassword(Password), FirstName, MiddleName, LastName, UserName]), [], True);
        end;
      finally
        FIntDatabaseIntf.DRVQuery.Transaction.Params.Text := TRReadParams;
        FIntDatabaseIntf.Disconnect;
      end;
    end;

    I := FUserNameList.IndexOfName(UserName);
    if I <> -1 then
    begin
      FFirstNameList[I] := FirstName;
      FMiddleNameList[I] := MiddleName;
      FLastNameList[I] := LastName;
    end;
  end;
end;

function TibSHUserManager.DeleteUser(const UserName: string): Boolean;
var
  I: Integer;
  DoSecurityConnect: Boolean;
begin
  Result := False;
  DoSecurityConnect := False;
  if Assigned(BTCLServer) then
  begin
    if BTCLServer.PrepareDRVService and BTCLServer.DRVService.Attach(stSecurityService) then
    begin
      try
        try
          Result := BTCLServer.DRVService.DeleteUser(UserName);
        except
          DoSecurityConnect := True;
        end;
      finally
        BTCLServer.DRVService.Detach;
      end;
    end else
      DoSecurityConnect := True;

    if DoSecurityConnect then
    begin
      try
        if FIntDatabaseIntf.Connect then
        begin
          FIntDatabaseIntf.DRVQuery.Transaction.Params.Text := TRWriteParams;
          Result := FIntDatabaseIntf.DRVQuery.ExecSQL(Format(FormatSQL(SQL_DELETE_SECURITY), [UserName]), [], True);
        end;
      finally
        FIntDatabaseIntf.DRVQuery.Transaction.Params.Text := TRReadParams;
        FIntDatabaseIntf.Disconnect;
      end;
    end;

    I := FUserNameList.IndexOfName(UserName);
    if I <> -1 then
    begin
      FUserNameList.Delete(I);
      FFirstNameList.Delete(I);
      FMiddleNameList.Delete(I);
      FLastNameList.Delete(I);
      FPasswordList.Delete(I);
    end;
  end;
end;

{ TibSHUser }

function TibSHUser.GetUserName: string;
begin
  Result := FUserName;
end;

procedure TibSHUser.SetUserName(Value: string);
begin
  FUserName := AnsiUpperCase(Value);
end;

function TibSHUser.GetPassword: string;
begin
  Result := FPassword;
end;

procedure TibSHUser.SetPassword(Value: string);
begin
  FPassword := Value;
end;

function TibSHUser.GetFirstName: string;
begin
  Result := FFirstName;
end;

procedure TibSHUser.SetFirstName(Value: string);
begin
  FFirstName := Value;
end;

function TibSHUser.GetMiddleName: string;
begin
  Result := FMiddleName;
end;

procedure TibSHUser.SetMiddleName(Value: string);
begin
  FMiddleName := Value;
end;

function TibSHUser.GetLastName: string;
begin
  Result := FLastName;
end;

procedure TibSHUser.SetLastName(Value: string);
begin
  FLastName := Value;
end;

initialization

  Register;

end.


