unit ibSHPSQLDebuggerStatement;

interface

uses Classes, Variants, Contnrs, Types, SysUtils,
     pSHSqlTxtRtns,

     ibSHDriverIntf, ibSHDebuggerIntf, ibSHPSQLDebuggerTokenScaner;

type

  TibSHPSQLDebuggerStatement = class(TComponent, IibSHDebugStatement)
  private
    FDebuggerItem: IibSHPSQLDebuggerItem;

    FGroupStatementType: TibSHDebugGroupStatementType;
    FOperatorType: TibSHDebugOperatorType;
    FParentStatement: IibSHDebugStatement;
    FPriorStatement: IibSHDebugStatement;
    FNextStatement: IibSHDebugStatement;
    FErrorHandlerStatement: IibSHDebugStatement;
    FChildStatements: TComponentList;
    FBeginOfStatement: TPoint;
    FEndOfStatement: TPoint;
    FDataSetComponent: TComponent;
    FProcessor: IibSHPSQLProcessor;
    FVariableNames: TStrings;

    FCursorName: string;
    FOperatorText: string;
    FVariableName: string;
    FIsDynamicStatement:boolean;
    FibErrorCode:TibErrorCode;
    function  GetErrorHandlerStmt: IibSHDebugStatement;
    procedure SetErrorHandlerStmt(Value: IibSHDebugStatement);
    function  GetLastErrorCode:TibErrorCode;
    procedure  SetLastErrorCode(Value:TibErrorCode);


//    FEndStatement:IibSHDebugStatement;
    function GetTokenScaner: TibSHPSQLDebuggerTokenScaner;
    procedure SetVariableName(const Value: string);
    function GetIsDynamicStatement: boolean;
  protected
  { IibSHDebugStatement }
    function GetGroupStatementType: TibSHDebugGroupStatementType;
    procedure SetGroupStatementType(Value: TibSHDebugGroupStatementType);{?}
    function GetOperatorType: TibSHDebugOperatorType;
    procedure SetOperatorType(Value: TibSHDebugOperatorType);{?}
    function GetParentStatement: IibSHDebugStatement;
    procedure SetParentStatement(Value: IibSHDebugStatement);
    function GetPriorStatement: IibSHDebugStatement;
    procedure SetPriorStatement(Value: IibSHDebugStatement);
    function GetNextStatement: IibSHDebugStatement;
    procedure SetNextStatement(Value: IibSHDebugStatement);
    function GetChildStatements(Index: Integer): IibSHDebugStatement;
    function GetChildStatementsCount: Integer;
    function GetBeginOfStatement: TPoint;
    procedure SetBeginOfStatement(Value: TPoint);
    function GetEndOfStatement: TPoint;
    procedure SetEndOfStatement(Value: TPoint);
    function GetDataSet: IibSHDRVDataset;
    function GetProcessor: IibSHPSQLProcessor;
    procedure SetProcessor(Value: IibSHPSQLProcessor);
    function GetVariableNames: TStrings;
    function GetVariableName: string;
    function GetOperatorText: string;
    function GetUsesCursor: Boolean;
    function GetCursorName: string;

    function AddChildStatement(Value: TComponent): Integer;
    function RemoveChildStatement(Value: TComponent): Integer;
    function CanExecute(Value: Variant): Boolean;
    procedure Execute(Values: array of Variant; out Results: array of Variant);
    function Parse: Boolean;
  { End of IibSHDebugStatement }
    procedure ParsingError(AExpected, AFound: string);
    procedure StatementError(AMessage: string);

    function CopyToken(ABegin, AEnd: TPoint): string; // Посмотреть
    procedure ParseChild;
    procedure ParseNext;
    procedure ParseConditionTo(AIdentifier: string; BracketsAlways: Boolean = True);
    procedure ParseForSelect;
    function FormatDB_KEY(ASQLText: string): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    property GroupStatementType: TibSHDebugGroupStatementType
      read GetGroupStatementType write SetGroupStatementType;
    property OperatorType: TibSHDebugOperatorType
      read GetOperatorType write SetOperatorType;
    property ParentStatement: IibSHDebugStatement read GetParentStatement;
    property NextStatement: IibSHDebugStatement
      read GetNextStatement write SetNextStatement;
    property ChildStatements[Index: Integer]: IibSHDebugStatement
      read GetChildStatements;
    property ChildStatementsCount: Integer read GetChildStatementsCount;
    property BeginOfStatement: TPoint
      read GetBeginOfStatement write SetBeginOfStatement;
    property EndOfStatement: TPoint
      read GetEndOfStatement write SetEndOfStatement;

    property DataSet: IibSHDRVDataset read GetDataSet;
    property Processor: IibSHPSQLProcessor
      read GetProcessor write SetProcessor;
    property VariableNames: TStrings read GetVariableNames;
    property OperatorText: string read GetOperatorText;
    property VariableName: string read GetVariableName write SetVariableName;

    property TokenScaner: TibSHPSQLDebuggerTokenScaner read GetTokenScaner;
    property DebuggerItem: IibSHPSQLDebuggerItem read FDebuggerItem;
    property IsDynamicStatement:boolean read GetIsDynamicStatement;
  end;
  
var
   FEndStatement:IibSHDebugStatement=nil;

implementation

{ TibSHPSQLDebuggerStatement }

constructor TibSHPSQLDebuggerStatement.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FChildStatements := TComponentList.Create(False);
  FGroupStatementType := dgstEmpty;
  FOperatorType := dotEmpty;

  FDataSetComponent := nil;
  FProcessor := nil;
  FVariableNames := TStringList.Create;

  FCursorName := EmptyStr;
  FVariableName := EmptyStr;
  FOperatorText := EmptyStr;
  Supports(AOwner, IibSHPSQLDebuggerItem, FDebuggerItem);
end;

destructor TibSHPSQLDebuggerStatement.Destroy;
begin
  if Assigned(FDataSetComponent) then
    FreeAndNil(FDataSetComponent);
  FProcessor := nil;
  FVariableNames.Free;
  FDebuggerItem := nil;

  FChildStatements.Free;
  inherited;
end;

procedure TibSHPSQLDebuggerStatement.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if Assigned(FNextStatement) then
      if AComponent.IsImplementorOf(FNextStatement) then
        FNextStatement := nil;
    if Assigned(FParentStatement) then
      if AComponent.IsImplementorOf(FParentStatement) then
        FParentStatement := nil;
    if  Assigned(FErrorHandlerStatement) then
      if AComponent.IsImplementorOf(FErrorHandlerStatement) then
        FErrorHandlerStatement := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

function TibSHPSQLDebuggerStatement.GetTokenScaner: TibSHPSQLDebuggerTokenScaner;
begin
  Result := TibSHPSQLDebuggerTokenScaner(DebuggerItem.TokenScaner);
end;

procedure TibSHPSQLDebuggerStatement.SetVariableName(const Value: string);
var
  vTokenScaner: TibSHPSQLDebuggerTokenScaner;
  vVariable: string;
begin
  if FVariableName <> Value then
  begin
    vTokenScaner := TibSHPSQLDebuggerTokenScaner.Create(nil);
    try
      FVariableName := Value;
      FVariableNames.Clear;
      if Length(FVariableName) > 0 then
      begin
        vTokenScaner.DDLText.Text := FVariableName;
        while vTokenScaner.Next and (Length(vTokenScaner.Token) > 0) do
        begin
          vVariable := vTokenScaner.Token;
          if (Length(vVariable) = 1) and (vVariable[1] in [',', '(', ')']) then
            Continue;
          if vVariable = ';' then Break;
          if vVariable[1]=':' then
            Delete(vVariable, 1, 1);
          vVariable := Trim(vVariable);
          if Length(vVariable) > 0 then
            FVariableNames.Add(vVariable);
        end;
      end;
    finally
      vTokenScaner.Free;
    end;
  end;
end;

function TibSHPSQLDebuggerStatement.GetGroupStatementType: TibSHDebugGroupStatementType;
begin
  Result := FGroupStatementType;
end;

procedure TibSHPSQLDebuggerStatement.SetGroupStatementType(
  Value: TibSHDebugGroupStatementType);
begin
  if FGroupStatementType <> Value then
  begin
    if (FGroupStatementType in [dgstForSelectCycle, dgstWhileCycle]) and
      Assigned(FDataSetComponent) then FreeAndNil(FDataSetComponent);
    FGroupStatementType := Value;
    if (FGroupStatementType in [dgstForSelectCycle, dgstWhileCycle]) and
      Assigned(Processor) then FDataSetComponent := Processor.CreateDataSet;
  end;
end;

function TibSHPSQLDebuggerStatement.GetOperatorType: TibSHDebugOperatorType;
begin
  Result := FOperatorType;
end;

procedure TibSHPSQLDebuggerStatement.SetOperatorType(
  Value: TibSHDebugOperatorType);
begin
  FOperatorType := Value;
end;

function TibSHPSQLDebuggerStatement.GetParentStatement: IibSHDebugStatement;
begin
  Result := FParentStatement;
end;

procedure TibSHPSQLDebuggerStatement.SetParentStatement(
  Value: IibSHDebugStatement);
begin
  if Assigned(FParentStatement) then
    ReferenceInterface(FParentStatement, opRemove);
  FParentStatement := Value;
  if Assigned(FParentStatement) then
    ReferenceInterface(FParentStatement, opInsert);  
end;

function TibSHPSQLDebuggerStatement.GetPriorStatement: IibSHDebugStatement;
begin
  Result := FPriorStatement;
end;

procedure TibSHPSQLDebuggerStatement.SetPriorStatement(
  Value: IibSHDebugStatement);
begin
  if Assigned(FPriorStatement) then
    ReferenceInterface(FPriorStatement, opRemove);
  FPriorStatement := Value;
  if Assigned(FPriorStatement) then
    ReferenceInterface(FPriorStatement, opInsert);  
end;

function TibSHPSQLDebuggerStatement.GetNextStatement: IibSHDebugStatement;
begin
  Result := FNextStatement;
end;

procedure TibSHPSQLDebuggerStatement.SetNextStatement(
  Value: IibSHDebugStatement);
begin
  FNextStatement := Value;
end;

function TibSHPSQLDebuggerStatement.GetChildStatements(
  Index: Integer): IibSHDebugStatement;
begin
  Assert((Index > -1) and (Index < FChildStatements.Count), 'TibSHPSQLDebuggerStatement.GetChildStatements - Index out of bounds');
  if (Index > -1) and (Index < FChildStatements.Count) then
    Supports(FChildStatements[Index], IibSHDebugStatement, Result);
end;

function TibSHPSQLDebuggerStatement.GetChildStatementsCount: Integer;
begin
  Result := FChildStatements.Count;
end;

function TibSHPSQLDebuggerStatement.GetBeginOfStatement: TPoint;
begin
  Result := FBeginOfStatement;
end;

procedure TibSHPSQLDebuggerStatement.SetBeginOfStatement(Value: TPoint);
begin
  FBeginOfStatement := Value;
end;

function TibSHPSQLDebuggerStatement.GetEndOfStatement: TPoint;
begin
  Result := FEndOfStatement;
end;

procedure TibSHPSQLDebuggerStatement.SetEndOfStatement(Value: TPoint);
begin
  FEndOfStatement := Value;
end;

function TibSHPSQLDebuggerStatement.GetDataSet: IibSHDRVDataset;
begin
  Supports(FDataSetComponent, IibSHDRVDataset, Result);
end;

function TibSHPSQLDebuggerStatement.GetProcessor: IibSHPSQLProcessor;
begin
  Result := FProcessor;
end;

procedure TibSHPSQLDebuggerStatement.SetProcessor(
  Value: IibSHPSQLProcessor);
begin
  FProcessor := Value;
end;

function TibSHPSQLDebuggerStatement.GetVariableNames: TStrings;
begin
  Result := FVariableNames;
end;

function TibSHPSQLDebuggerStatement.GetVariableName: string;
begin
  Result := FVariableName;
end;

function TibSHPSQLDebuggerStatement.GetOperatorText: string;
begin
  Result := FOperatorText;
end;

function TibSHPSQLDebuggerStatement.GetUsesCursor: Boolean;
begin
  Result := Length(FCursorName) > 0;
end;

function TibSHPSQLDebuggerStatement.GetCursorName: string;
begin
  Result := FCursorName;
end;

function TibSHPSQLDebuggerStatement.AddChildStatement(
  Value: TComponent): Integer;
begin
  Result := FChildStatements.Add(Value);
end;

function TibSHPSQLDebuggerStatement.RemoveChildStatement(
  Value: TComponent): Integer;
begin
  Result := FChildStatements.Remove(Value);
end;

function TibSHPSQLDebuggerStatement.CanExecute(Value: Variant): Boolean;
begin
  Result := False;
end;

procedure TibSHPSQLDebuggerStatement.Execute(Values: array of Variant;
  out Results: array of Variant);
begin
  
end;

function TibSHPSQLDebuggerStatement.Parse: Boolean;
var
  vTempPosition: TPoint;

  procedure SetOpenCloseFetchCursor;
  begin
      FGroupStatementType := dgstEmpty;
      FBeginOfStatement := TokenScaner.TokenBegin;
      TokenScaner.Next;
      case TokenScaner.TokenType of
       ttIdentifier: FCursorName:=TokenScaner.Token;
      else
        ParsingError('Cursor identifier ', TokenScaner.Token);
      end;
      TokenScaner.Next;
      if OperatorType<>dotFetchCursor then
      begin
       if TokenScaner.Token <> ';' then
         ParsingError(';', TokenScaner.Token);
      end
      else
      begin
       if TokenScaner.Token <> 'INTO' then
         ParsingError('INTO', TokenScaner.Token);
        vTempPosition := Point(TokenScaner.TokenEnd.X+1, TokenScaner.TokenEnd.Y)   ;         
        while TokenScaner.Next do
        case TokenScaner.TokenType of
         ttSymbol:
         if TokenScaner.Token = ';' then
         begin
            FEndOfStatement := TokenScaner.TokenEnd;
            FEndOfStatement.X := FEndOfStatement.X - 1;
            VariableName := CopyToken(vTempPosition, FEndOfStatement);
            Break
         end;
        end;
      end;
      FEndOfStatement := TokenScaner.TokenEnd;
      FEndOfStatement.X := FEndOfStatement.X + 1;
      ParseNext;
      Result := True;             
  end;

  procedure SetException;
  begin
     FGroupStatementType := dgstEmpty;
     OperatorType := dotException;
     FBeginOfStatement := TokenScaner.TokenBegin;
     TokenScaner.Next;
     case TokenScaner.TokenType of
      ttIdentifier:
       FOperatorText:=TokenScaner.Token;
     end;
     if TokenScaner.Token<>';' then
     begin
      TokenScaner.Next;
      if TokenScaner.Token<>';' then
      begin
       VariableName := CopyToken(TokenScaner.TokenBegin, TokenScaner.TokenEnd);
       TokenScaner.Next;
      end;
     end;
     if TokenScaner.Token<>';' then
        ParsingError(';',TokenScaner.Token);

     ParseNext;        
  end;

  procedure SetSimpleStatement(const ReturningExistKey,KeyReturning:string);
  var
     ReturningExist:boolean;
  begin
      FGroupStatementType := dgstEmpty;
      ReturningExist:=False;
      FBeginOfStatement := TokenScaner.TokenBegin;
      while TokenScaner.Next do
      case TokenScaner.TokenType of
       ttSymbol:
        if TokenScaner.Token = ';' then
        begin
          FEndOfStatement := TokenScaner.TokenEnd;
//          FOperatorText := CopyToken(FBeginOfStatement, FEndOfStatement);
          if Length(FOperatorText) = 0 then
          begin
            FOperatorText := CopyToken(FBeginOfStatement, FEndOfStatement);
          end
          else
          begin
            VariableName := CopyToken(vTempPosition, FEndOfStatement);
          end;

          FEndOfStatement.X := FEndOfStatement.X + 1;
          Break;
        end;
       ttIdentifier:
        if TokenScaner.UpperToken = ReturningExistKey then
         ReturningExist:=True
        else
        if ReturningExist and (TokenScaner.UpperToken = KeyReturning) then
        begin
          FOperatorText := CopyToken(FBeginOfStatement, Point(TokenScaner.TokenBegin.X-1, TokenScaner.TokenBegin.Y));
          vTempPosition := Point(TokenScaner.TokenEnd.X+1, TokenScaner.TokenEnd.Y)   ;
        end;

      end;

      if TokenScaner.Token <> ';' then
        ParsingError(';', TokenScaner.Token);
      ParseNext;
      Result := True;
  end;

  function AdjustFuncParam(const Func:string):string;
  var
   i,j,L:integer;
   NeedVar:boolean;
  begin
    L:=Length(Func);
    SetLength(Result,L);
    NeedVar:=False;      J:=1;
    for i:=1 to Length(Func) do
    begin
      case Func[i] of
       '(',',': NeedVar:=True;
      else
       if NeedVar then
       if  not (Func[i] in ['+','-']) then
       begin
        if not (Func[i] in ['0'..'1','.',':','''']) then
        begin
         if J>L then
          SetLength(Result,J);
         Result[J]:=':';
         Inc(J)
        end;
        NeedVar:=False
       end
      end;
      if J>L then
       SetLength(Result,J);
      Result[J]:=Func[i];
      Inc(J);
    end;
  end;

  procedure SetFunction;
  begin
      FGroupStatementType := dgstEmpty;
      FBeginOfStatement := vTempPosition;
      while TokenScaner.Next do
      case TokenScaner.TokenType of
       ttSymbol:
        if TokenScaner.Token = ';' then
        begin
          FEndOfStatement := TokenScaner.TokenEnd;
          Dec(FEndOfStatement.X);
          FOperatorText :='SELECT '+
           AdjustFuncParam(CopyToken(vTempPosition, FEndOfStatement))+
          'FROM RDB$DATABASE'
          ;
          Inc(FEndOfStatement.X,2);
          FEndOfStatement.X := FEndOfStatement.X + 1;
          Break;
        end;
      end;

      if TokenScaner.Token <> ';' then
        ParsingError(';', TokenScaner.Token);


      ParseNext;
      Result := True;
  end;

  procedure SetCursorStatement(const KeyReturning:string);
  type
    TCursorStatementClauses = (ccStatement, ccWhere, ccReturning);
//DELETE or Update only    
  var
    vPosition: TCursorStatementClauses;
    vEnd: TPoint;
//    vCursorReplacement: string;
    vReturningExist:boolean;
  begin
     FGroupStatementType := dgstEmpty;
     FBeginOfStatement := TokenScaner.TokenBegin;
     vPosition := ccStatement;
     vReturningExist:=False;
     while TokenScaner.Next do
      case TokenScaner.TokenType of
      ttSymbol:
        if TokenScaner.Token = ';' then
        begin
          FEndOfStatement := TokenScaner.TokenEnd;
          if Length(FOperatorText) = 0 then
          begin
            FOperatorText := CopyToken(FBeginOfStatement, FEndOfStatement);
          end
          else
          begin
            VariableName := CopyToken(vTempPosition, FEndOfStatement);
          end;
          FEndOfStatement.X := FEndOfStatement.X + 1;
          Break;
        end;
      ttIdentifier:
        case vPosition of
          ccStatement:
            begin
              if TokenScaner.UpperToken = 'WHERE' then
              begin
                vPosition := ccWhere;
                vEnd := TokenScaner.TokenEnd;
              end
              else
              if TokenScaner.UpperToken = 'RETURNING' then
               vReturningExist:=True
              else
              if vReturningExist and (TokenScaner.UpperToken = KeyReturning) then
              begin
                FOperatorText := CopyToken(FBeginOfStatement, Point(TokenScaner.TokenBegin.X-1, TokenScaner.TokenBegin.Y));
                vTempPosition := Point(TokenScaner.TokenEnd.X+1, TokenScaner.TokenEnd.Y)   ;
              end              
            end;
          ccWhere:
            begin
              if TokenScaner.UpperToken = 'CURRENT' then
              begin
                if TokenScaner.Next and
                  (TokenScaner.UpperToken = 'OF') and
                  TokenScaner.Next then
                begin
//                  FCursorName := TokenScaner.Token;
                  vEnd:=TokenScaner.TokenEnd;
                  FOperatorText := CopyToken(FBeginOfStatement, vEnd);
                  if TokenScaner.Next and (TokenScaner.Token = ';') then
                    FEndOfStatement := Point(TokenScaner.TokenEnd.X + 1, TokenScaner.TokenEnd.Y);                  
{                  vCursorReplacement := FormatDB_KEY(Copy(FOperatorText, 1, Length(FOperatorText) - 5));
                  FOperatorText := Format('%s %s = :%s', [FOperatorText, vCursorReplacement, FCursorName]);
                  if TokenScaner.Next and (TokenScaner.Token = ';') then
                    FEndOfStatement := Point(TokenScaner.TokenEnd.X + 1, TokenScaner.TokenEnd.Y);}
                  Break;                                       
                end
                else
                  StatementError('Unexpected end of command.');
              end
              else
                vPosition := ccReturning;
            end;
            ccReturning:
            begin
              if TokenScaner.UpperToken = KeyReturning then
              begin
                FOperatorText := CopyToken(FBeginOfStatement, Point(TokenScaner.TokenBegin.X-1, TokenScaner.TokenBegin.Y));
                vTempPosition := Point(TokenScaner.TokenEnd.X+1, TokenScaner.TokenEnd.Y)   ;
              end
            end;
        end;
       end;
      if TokenScaner.Token <> ';' then
        ParsingError(';', TokenScaner.Token);
      ParseNext;
      Result := True;
  end;

  procedure SetReturningStatement(const AKeyWord: string;aBegin:PPoint=nil );
  begin
      FGroupStatementType := dgstEmpty;
      if aBegin=nil then
       FBeginOfStatement := TokenScaner.TokenBegin
      else
       FBeginOfStatement := aBegin^;
      while TokenScaner.Next do
      case TokenScaner.TokenType of
       ttIdentifier:
        if TokenScaner.UpperToken = AKeyWord then
        begin
          FOperatorText := CopyToken(FBeginOfStatement, Point(TokenScaner.TokenBegin.X-1, TokenScaner.TokenBegin.Y));
          vTempPosition := Point(TokenScaner.TokenEnd.X+1, TokenScaner.TokenEnd.Y)   ;
        end;
       ttSymbol:
        if TokenScaner.Token = ';' then
        begin
          FEndOfStatement := TokenScaner.TokenEnd;
          if Length(FOperatorText) = 0 then
          begin
            FOperatorText := CopyToken(FBeginOfStatement, FEndOfStatement);
          end
          else
          begin
            VariableName := CopyToken(vTempPosition, FEndOfStatement);
          end;
          FEndOfStatement.X := FEndOfStatement.X + 1;
          Break;
        end;
      end;
      if TokenScaner.Token <> ';' then
        ParsingError(';', TokenScaner.Token);
      ParseNext;
      Result := True;
  end;


var
   vCurToken:string;
   vSuccess :boolean;
   vBeginStatement:TPoint;
begin
  Result := False;
  if TokenScaner.Next then
  begin
    while TokenScaner.TokenType <> ttIdentifier do
      if not TokenScaner.Next then Exit;
    //Групповые операторы
//    vCurToken:=UpperCase(TokenScaner.Token);
    vCurToken:=TokenScaner.UpperToken;
    vSuccess :=False;
    if Length(vCurToken)>0 then
    case vCurToken[1] of
     'B':if vCurToken='BEGIN' then
         begin
          GroupStatementType := dgstSimple;
          if  OperatorType<>dotFirstBegin then
           OperatorType := dotEmpty;
          FBeginOfStatement := TokenScaner.TokenBegin;
          if Self.GetParentStatement=nil then
           DebuggerItem.StatementFound(Self);        // Первый begin
          ParseChild;
          TokenScaner.Next;
          if (TokenScaner.UpperToken <> 'END') then
            ParsingError('END', TokenScaner.Token);
          FEndOfStatement := TokenScaner.TokenEnd;
          FEndOfStatement.X := FEndOfStatement.X + 1;
          ParseNext;
          Result := True;
          vSuccess :=True;
         end
         else
         if vCurToken = 'BREAK' then
          begin
            GroupStatementType := dgstEmpty;
            OperatorType := dotLeave;
            FBeginOfStatement := TokenScaner.TokenBegin;
            FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
            TokenScaner.Next;
            ParseNext;
            Result := True;
            vSuccess :=True;
          end;

     'C': if vCurToken='CLOSE' then
          begin
           GroupStatementType := dgstEmpty;
           OperatorType := dotCloseCursor;
           SetOpenCloseFetchCursor;
           vSuccess :=True;
           Result := True;           
          end;

     'D': if vCurToken= 'DELETE' then
          begin
           GroupStatementType := dgstEmpty;
           OperatorType := dotDelete;
           SetCursorStatement('INTO');
           vSuccess :=True;
          end;

     'E':if vCurToken='END' then
         begin
           FBeginOfStatement := TokenScaner.TokenBegin;
           FEndOfStatement := TokenScaner.TokenEnd;
           FEndOfStatement.X := FEndOfStatement.X + 1;

//           if (ParentStatement=nil) or (ParentStatement.ParentStatement=nil)
           if (ParentStatement=nil) or  (ParentStatement.OperatorType=dotFirstBegin) 
           then // Последний end
           begin
//            ParentStatement.AddChildStatement(Self);
            FEndStatement:=Self;
            Result:=True;
            OperatorType :=  dotLastEnd;
           end;


           TokenScaner.MoveBack;
           vSuccess :=True;
         end
         else
         if vCurToken='EXIT' then
         begin
            GroupStatementType := dgstEmpty;
            OperatorType := dotExit;
            FBeginOfStatement := TokenScaner.TokenBegin;
            FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
            TokenScaner.Next;
            ParseNext;
            Result := True;
            vSuccess :=True;
         end
         else
         if vCurToken= 'EXECUTE' then
         begin
          FBeginOfStatement := TokenScaner.TokenBegin;
          GroupStatementType := dgstEmpty;
          vBeginStatement:=TokenScaner.TokenBegin;
          TokenScaner.Next;
          if (TokenScaner.UpperToken = 'PROCEDURE') then
          begin
            OperatorType := dotExecuteProcedure;
            SetReturningStatement('RETURNING_VALUES',@vBeginStatement);
          end
          else
          if (TokenScaner.UpperToken = 'STATEMENT') then
          begin
            OperatorType := dotExecuteStatement;
            TokenScaner.Next;            
            SetReturningStatement('INTO');
          end
          else
           ParsingError('STATEMENT', TokenScaner.Token);
          FEndOfStatement := TokenScaner.TokenEnd;
          FEndOfStatement.X := FEndOfStatement.X + 1;
          vSuccess :=True;
          Result:=True;          
         end
         else
          if vCurToken= 'EXCEPTION' then
          begin
            SetException;
            vSuccess :=True;
            Result:=True;            
          end;
     'F':if vCurToken='FOR' then
         begin
            GroupStatementType := dgstForSelectCycle;
            OperatorType := dotSelect;
            FBeginOfStatement := TokenScaner.TokenBegin;
            ParseForSelect;
            FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
            ParseNext;
            Result := True;
            vSuccess :=True;
         end
         else
         if vCurToken='FETCH' then
         begin
          GroupStatementType := dgstEmpty;
          OperatorType := dotFetchCursor;
          SetOpenCloseFetchCursor;
          vSuccess :=True;
          Result := True;          
         end;

     'I':if vCurToken='IF' then
         begin
          GroupStatementType := dgstCondition;
          OperatorType := dotEmpty;
          FBeginOfStatement := TokenScaner.TokenBegin;
          ParseConditionTo('THEN');
    //      FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
          ParseChild; //THEN
          if TokenScaner.Next then
          begin
            if (TokenScaner.UpperToken = 'ELSE') then
              ParseChild //ELSE
            else
              TokenScaner.MoveBack;
          end;
          FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
          ParseNext;
          Result := True;
          vSuccess :=True;
         end
         else
          if vCurToken='INSERT' then
          begin
            GroupStatementType := dgstEmpty;
            OperatorType := dotInsert;
            SetSimpleStatement('RETURNING','INTO');
            vSuccess :=True;
            Result := True;            
          end;


      'L':if vCurToken = 'LEAVE' then
          begin
            GroupStatementType := dgstEmpty;
            OperatorType := dotLeave;
            FBeginOfStatement := TokenScaner.TokenBegin;
            FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
            TokenScaner.Next;
            ParseNext;
            Result := True;
            vSuccess :=True;            
          end;
      'M':if vCurToken = 'MERGE' then
          begin
            GroupStatementType := dgstEmpty;
            OperatorType := dotUpdate;
            SetCursorStatement('');
            vSuccess :=True;
            Result := True;
          end;
      'W':if vCurToken='WHILE' then
          begin
            GroupStatementType := dgstWhileCycle;
            OperatorType := dotEmpty;
            FBeginOfStatement := TokenScaner.TokenBegin;
            ParseConditionTo('DO');
            ParseChild;
            FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
            ParseNext;
            Result := True;
            vSuccess :=True;
          end
          else
          if vCurToken = 'WHEN' then
          begin
            GroupStatementType := dgstErrorHandler;
//            OperatorType := dotEmpty;
            OperatorType := dotErrorHandler;
            FBeginOfStatement := TokenScaner.TokenBegin;
            ParseConditionTo('DO', False);
            if Assigned(FParentStatement) and not Assigned(FParentStatement.ErrorHandlerStmt)  then
             FParentStatement.ErrorHandlerStmt:=Self;
            ParseChild;
            FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
            ParseNext;
            Result := True;
            vSuccess :=True;
          end
          else
          if vCurToken = 'WITH' then
          begin
            GroupStatementType := dgstEmpty;
            OperatorType := dotSelect;
            SetReturningStatement('INTO');
            vSuccess :=True;
          end;

     'S':
          if vCurToken =  'SUSPEND' then
          begin
            GroupStatementType := dgstEmpty;
            OperatorType := dotSuspend;
            FBeginOfStatement := TokenScaner.TokenBegin;
            FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
            TokenScaner.Next;
            ParseNext;
            Result := True;
            vSuccess :=True;
          end
          else
          if vCurToken = 'SELECT' then
          begin
            GroupStatementType := dgstEmpty;
            OperatorType := dotSelect;
            SetReturningStatement('INTO');
            vSuccess :=True;
            Result:=True;
          end;
      'U':
        if vCurToken = 'UPDATE' then
        begin
          GroupStatementType := dgstEmpty;
          OperatorType := dotUpdate;
          SetCursorStatement('INTO');
          vSuccess :=True;
          Result:=True
        end;
      'O':
        if vCurToken = 'OPEN' then
        begin
          GroupStatementType := dgstEmpty;
          OperatorType := dotOpenCursor;
          SetOpenCloseFetchCursor;
          vSuccess :=True;
          Result:=True
        end;
      'P':
          if vCurToken = 'POST_EVENT' then
          begin
            GroupStatementType := dgstEmpty;
            OperatorType := dotEmpty;
            vSuccess :=True;
            Result:=True;
            FBeginOfStatement := TokenScaner.TokenBegin;
            FEndOfStatement := TokenScaner.TokenEnd;
            TokenScaner.Next;                        
            ParseNext
          end;

     end; //end case

     if not vSuccess then
     begin
      GroupStatementType := dgstEmpty;
      OperatorType := dotExpression;
      FVariableName := TokenScaner.Token;
      vTempPosition:=TokenScaner.TokenBegin;

      TokenScaner.Next;
      if TokenScaner.Token = '=' then
        SetSimpleStatement('','')
      else
      if TokenScaner.Token = '.' then
      begin
        TokenScaner.Next;
        FVariableName := '.' + TokenScaner.Token;
        TokenScaner.Next;
        if TokenScaner.Token = '=' then
          SetSimpleStatement('','')
        else
        begin
          FVariableName := EmptyStr;
          raise Exception.Create('Parsing Error! Unknown statement: ' + FVariableName + ' ' + TokenScaner.Token);
        end
      end
      else
      if TokenScaner.Token = '(' then
      begin
        OperatorType := dotFunction;
        SetFunction;
        Result :=True;
      end
      else
      begin
        FVariableName := EmptyStr;
        raise Exception.Create('Parsing Error! Unknown statement: ' + FVariableName + ' ' + TokenScaner.Token);
      end;
     end;
///=========
{    if AnsiUpperCase(TokenScaner.Token) = 'END' then
    begin
      TokenScaner.MoveBack;
    end
    else
    if AnsiUpperCase(TokenScaner.Token) = 'BEGIN' then
    begin
      GroupStatementType := dgstSimple;
      OperatorType := dotEmpty;
      FBeginOfStatement := TokenScaner.TokenBegin;
      ParseChild;
      TokenScaner.Next;
      if (AnsiUpperCase(TokenScaner.Token) <> 'END') then
        ParsingError('END', TokenScaner.Token);
      FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
      ParseNext;
      Result := True;
    end
    else
    if AnsiUpperCase(TokenScaner.Token) = 'IF' then
    begin
      GroupStatementType := dgstCondition;
      OperatorType := dotEmpty;
      FBeginOfStatement := TokenScaner.TokenBegin;
      ParseConditionTo('THEN');
//      FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
      ParseChild; //THEN
      if TokenScaner.Next then
      begin
        if (AnsiUpperCase(TokenScaner.Token) = 'ELSE') then
          ParseChild //ELSE
        else
          TokenScaner.MoveBack;
      end;
      FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
      ParseNext;
      Result := True;
    end
    else
    if AnsiUpperCase(TokenScaner.Token) = 'FOR' then
    begin
      GroupStatementType := dgstForSelectCycle;
      OperatorType := dotSelect;
      FBeginOfStatement := TokenScaner.TokenBegin;
      ParseForSelect;
      FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
      ParseNext;
      Result := True;
    end
    else
    if AnsiUpperCase(TokenScaner.Token) = 'WHILE' then
    begin
      GroupStatementType := dgstWhileCycle;
      OperatorType := dotEmpty;
      FBeginOfStatement := TokenScaner.TokenBegin;
      ParseConditionTo('DO');
      ParseChild;
      FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
      ParseNext;
      Result := True;
    end
    else
    if AnsiUpperCase(TokenScaner.Token) = 'WHEN' then
    begin
      GroupStatementType := dgstErrorHandler;
      OperatorType := dotEmpty;
      FBeginOfStatement := TokenScaner.TokenBegin;
      ParseConditionTo('DO', False);
      ParseChild;
      FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
      ParseNext;
      Result := True;
    end
    else
    if AnsiUpperCase(TokenScaner.Token) = 'LEAVE' then
    begin
      GroupStatementType := dgstEmpty;
      OperatorType := dotLeave;
      FBeginOfStatement := TokenScaner.TokenBegin;
      FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
      TokenScaner.Next;
      ParseNext;
      Result := True;
    end
    else
    if AnsiUpperCase(TokenScaner.Token) = 'EXIT' then
    begin
      GroupStatementType := dgstEmpty;
      OperatorType := dotExit;
      FBeginOfStatement := TokenScaner.TokenBegin;
      FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
      TokenScaner.Next;
      ParseNext;
      Result := True;
    end
    else
    if AnsiUpperCase(TokenScaner.Token) = 'SUSPEND' then
    begin
      GroupStatementType := dgstEmpty;
      OperatorType := dotSuspend;
      FBeginOfStatement := TokenScaner.TokenBegin;
      FEndOfStatement := TokenScaner.TokenEnd; FEndOfStatement.X := FEndOfStatement.X + 1;
      TokenScaner.Next;
      ParseNext;
      Result := True;
    end
    else
    if AnsiUpperCase(TokenScaner.Token) = 'SELECT' then
    begin
      GroupStatementType := dgstEmpty;
      OperatorType := dotSelect;
      SetReturningStatement('INTO');
    end
    else
    (*   ??????? что-то проебано?
    if AnsiUpperCase(TokenScaner.Token) = 'SELECT' then
    begin
      FOperatorType := dotSelect;
      SetSimpleStatement;
    end
    else
    *)
    if AnsiUpperCase(TokenScaner.Token) = 'EXECUTE' then
    begin
      GroupStatementType := dgstEmpty;
      OperatorType := dotExecuteProcedure;
      SetReturningStatement('RETURNING_VALUES');
    end
    else
    if AnsiUpperCase(TokenScaner.Token) = 'INSERT' then
    begin
      GroupStatementType := dgstEmpty;
      OperatorType := dotInsert;
      SetSimpleStatement;
    end
    else
    if AnsiUpperCase(TokenScaner.Token) = 'UPDATE' then
    begin
      GroupStatementType := dgstEmpty;
      OperatorType := dotUpdate;
      SetCursorStatement;
    end
    else
    if AnsiUpperCase(TokenScaner.Token) = 'DELETE' then
    begin
      GroupStatementType := dgstEmpty;
      OperatorType := dotDelete;
      SetCursorStatement;
    end
    else
    if AnsiUpperCase(TokenScaner.Token) = 'EXCEPTION' then
    begin
      GroupStatementType := dgstEmpty;
      OperatorType := dotException;
      SetSimpleStatement;
    end
    else
    begin
      GroupStatementType := dgstEmpty;
      OperatorType := dotExpression;
      FVariableName := TokenScaner.Token;
      TokenScaner.Next;
      if TokenScaner.Token = '=' then
        SetSimpleStatement
      else
      if TokenScaner.Token = '.' then
      begin
        TokenScaner.Next;
        FVariableName := '.' + TokenScaner.Token;
        TokenScaner.Next;
        if TokenScaner.Token = '=' then
          SetSimpleStatement
        else
        begin
          FVariableName := EmptyStr;
          raise Exception.Create('Parsing Error! Unknown statement: ' + FVariableName + ' ' + TokenScaner.Token);
        end
      end
      else
      begin
        FVariableName := EmptyStr;
        raise Exception.Create('Parsing Error! Unknown statement: ' + FVariableName + ' ' + TokenScaner.Token);
      end;
    end}
  end;
end;

procedure TibSHPSQLDebuggerStatement.ParsingError(AExpected, AFound: string);
begin
  raise Exception.Create(Format('Parsing Error: Expected: %s, found: %s', [AExpected, AFound]));
end;

procedure TibSHPSQLDebuggerStatement.StatementError(AMessage: string);
begin
  raise Exception.Create(Format('%s', [AMessage]));
end;

function TibSHPSQLDebuggerStatement.CopyToken(ABegin,
  AEnd: TPoint): string;
var
  I: Integer;
  S: string;
begin
  Result := EmptyStr;
  if ABegin.Y = AEnd.Y then
  begin
    Result := Copy(TokenScaner.DDLText[ABegin.Y],
      ABegin.X, AEnd.X - ABegin.X + 1);
  end
  else
  begin
    for I := ABegin.Y to AEnd.Y do
    begin
      if I = ABegin.Y then
        S := Copy(TokenScaner.DDLText[I], ABegin.X, Length(TokenScaner.DDLText[I]) - ABegin.X + 1)
      else
      if I = AEnd.Y then
        S := Copy(TokenScaner.DDLText[I], 1, AEnd.X)
      else
        S := TokenScaner.DDLText[I];
      if Length(Result) = 0 then
        Result := S
      else
        Result := Result + #13#10 + S;
    end;
  end;
end;

procedure TibSHPSQLDebuggerStatement.ParseChild;
var
  vStatementComponent: TComponent;
  vStatement: IibSHDebugStatement;
begin
  vStatementComponent := TibSHPSQLDebuggerStatement.Create(Owner);
  if Supports(vStatementComponent, IibSHDebugStatement, vStatement) then
  begin
    vStatement.Processor := GetProcessor;
    vStatement.ParentStatement := Self as IibSHDebugStatement;
    if vStatement.Parse then
    begin
      AddChildStatement(vStatementComponent);
      if (vStatement.GroupStatementType <> dgstSimple) then
       DebuggerItem.StatementFound(vStatement);
    end
    else
    begin
      vStatement := nil;
      vStatementComponent.Free;
    end
  end
  else
    vStatementComponent.Free;
end;

procedure TibSHPSQLDebuggerStatement.ParseNext;
var
  vStatementComponent: TComponent;
begin
//  if  (GetPriorStatement = nil) or
//    (not (GetPriorStatement.GroupStatementType in [dgstCondition, dgstForSelectCycle, dgstWhileCycle, dgstErrorHandler])) then
  if  (GetParentStatement = nil) or
    (not (GetParentStatement.GroupStatementType in [dgstCondition, dgstForSelectCycle, dgstWhileCycle, dgstErrorHandler])) then
  begin
    vStatementComponent := TibSHPSQLDebuggerStatement.Create(Owner);
    if Supports(vStatementComponent, IibSHDebugStatement, FNextStatement) then
    begin
      FNextStatement.Processor := GetProcessor;
      FNextStatement.PriorStatement := Self as IibSHDebugStatement;
      FNextStatement.ParentStatement := ParentStatement;
      if not FNextStatement.Parse then
      begin
        FNextStatement := nil;
        vStatementComponent.Free;
      end
      else
        DebuggerItem.StatementFound(FNextStatement);
    end
    else
      vStatementComponent.Free;
  end;
end;

procedure TibSHPSQLDebuggerStatement.ParseConditionTo(AIdentifier: string; BracketsAlways: Boolean = True);
var
  vConditionBegin: TPoint;
  vConditionEnd: TPoint;
  vOpenedBrackets, vClosedBrackets: Integer;
  vResultFlag: Boolean;
begin
  if BracketsAlways then
  begin
    TokenScaner.Next;
    if TokenScaner.Token = '(' then
      vConditionBegin := TokenScaner.TokenBegin
    else
      ParsingError('(', TokenScaner.Token);

    vResultFlag := False;
    vOpenedBrackets := 1;
    vClosedBrackets := 0;
    while TokenScaner.Next do
    begin
      if TokenScaner.Token = '(' then
        Inc(vOpenedBrackets)
      else
      if TokenScaner.Token = ')' then
        Inc(vClosedBrackets);
      if vOpenedBrackets = vClosedBrackets then
      begin
        vConditionEnd := TokenScaner.TokenBegin;
  //      vConditionEnd.X := vConditionEnd.X + 1;
        vResultFlag := True;
        Break;
      end;
    end;
    if not vResultFlag then
      ParsingError(')', TokenScaner.Token);
    FOperatorText := CopyToken(vConditionBegin, vConditionEnd);

    TokenScaner.Next;

    if AnsiUpperCase(TokenScaner.Token) <> AIdentifier then
      ParsingError(AIdentifier, TokenScaner.Token);
  end
  else
  begin
    TokenScaner.Next;
    vConditionBegin := TokenScaner.TokenBegin;
    vResultFlag := False;
    while TokenScaner.Next do
      if TokenScaner.UpperToken = AIdentifier then
      begin
        vResultFlag := True;
        vConditionEnd := TokenScaner.TokenBegin;
        vConditionEnd.X := vConditionEnd.X - 1;
        Break;
      end;
    if not vResultFlag then
      ParsingError(AIdentifier, TokenScaner.Token);
    FOperatorText := CopyToken(vConditionBegin, vConditionEnd);  
  end
end;

{
Не требуется, т.к. выполняется целиком ударом об пенек
procedure TibSHPSQLDebuggerStatement.ParseCaseCondition;
var
  vBegin: TPoint;
  vEnd: TPoint;
  vOpenedBrackets, vClosedBrackets: Integer;
  vResultFlag: Boolean;
begin
  TokenScaner.Next;
  vBegin := TokenScaner.TokenBegin;
  if AnsiUpperCase(TokenScaner.Token) = 'WHEN' then
  begin
    FGroupStatementType := dgstSearchedCase;
    TokenScaner.MoveBack;
    ParseChild;
  end
  else
  begin
    FGroupStatementType := dgstSimpleCase;
    vResultFlag := False;
    while TokenScaner.Next do
      if AnsiUpperCase(TokenScaner.Token) = 'WHEN' then
      begin
        vResultFlag := True;
        vEnd := TokenScaner.TokenBegin; vEnd.X := vEnd.X - 1;
        FOperatorText := CopyToken((vBegin, vEnd);
        TokenScaner.MoveBack;
        Break;
      end;
    if not vResultFlag then
      ParsingError('WHEN', TokenScaner.Token);
    ParseChild;
  end;
end;
}

procedure TibSHPSQLDebuggerStatement.ParseForSelect;
type
  TForSelectClauses = (fcNone, fcStatement, fcInto, fcAsCursor,fcExecuteStatement);
var
  vBegin: TPoint;
  vPosition: TForSelectClauses;
  vOperatorText, vVariablesNames: string;
//  vDB_KEYField, vDB_KEYParameter: string;
//  I: Integer;
begin
  vPosition := fcNone;
  TokenScaner.Next;
  if TokenScaner.UpperToken <> 'SELECT' then
  begin
    if TokenScaner.UpperToken <> 'EXECUTE' then
     ParsingError('SELECT or EXECUTE STATEMENT', TokenScaner.Token)
    else
    begin
     TokenScaner.Next;
     if TokenScaner.UpperToken <> 'STATEMENT' then
      ParsingError('STATEMENT', TokenScaner.Token)
     else
     begin
      vPosition := fcExecuteStatement;
      FIsDynamicStatement:=True;
      TokenScaner.Next;
     end
    end
  end
  else
    vPosition := fcStatement;
  vBegin := TokenScaner.TokenBegin;

  while TokenScaner.Next do
  begin
    case vPosition of
      fcStatement,fcExecuteStatement:
        begin
          if TokenScaner.UpperToken = 'INTO' then
          begin
            vOperatorText := CopyToken(vBegin, Point(TokenScaner.TokenBegin.X-1, TokenScaner.TokenBegin.Y));
            vBegin := Point(TokenScaner.TokenEnd.X+1, TokenScaner.TokenEnd.Y);
            vPosition := fcInto;
          end
        end;
      fcInto:
        begin
          if TokenScaner.UpperToken = 'DO' then
          begin
            vVariablesNames := CopyToken(vBegin, Point(TokenScaner.TokenBegin.X-1, TokenScaner.TokenBegin.Y));
            Break;
          end
          else
          if TokenScaner.UpperToken = 'AS' then
          begin
            vVariablesNames := CopyToken(vBegin, Point(TokenScaner.TokenBegin.X-1, TokenScaner.TokenBegin.Y));
            if TokenScaner.Next and (TokenScaner.UpperToken = 'CURSOR') then
              vPosition := fcAsCursor
            else
              ParsingError('CURSOR', TokenScaner.Token);
          end
        end;
      fcAsCursor:
        begin
          FCursorName := Trim(TokenScaner.Token);
          if (not TokenScaner.Next) or (TokenScaner.UpperToken <> 'DO') then
            ParsingError('DO', TokenScaner.Token);
          Break;  
        end;
    end;
  end;
  case vPosition of
    fcNone: ParsingError('FOR SELECT... statement', 'Nothing');
    fcStatement,fcExecuteStatement: ParsingError('INTO', TokenScaner.Token);
    fcInto:
      begin
        if Length(vVariablesNames) = 0 then ParsingError('DO or AS CURSOR', TokenScaner.Token);
        FOperatorText := vOperatorText;
        vVariablesNames := CopyToken(vBegin, Point(TokenScaner.TokenBegin.X-1, TokenScaner.TokenBegin.Y));        
        VariableName := vVariablesNames;
      end;
    fcAsCursor:
      begin
         FOperatorText:=vOperatorText+' FOR UPDATE ';
         VariableName := vVariablesNames;
{        vDB_KEYField := FormatDB_KEY(vOperatorText);
        vDB_KEYField := Format(' %s,', [vDB_KEYField]);
        System.Insert(vDB_KEYField, vOperatorText, 7);
        FOperatorText := vOperatorText;
        VariableName := vVariablesNames;
        I := 0;
        vDB_KEYParameter := Format('%s', [FCursorName]);
        while FVariableNames.IndexOf(AnsiUpperCase(vDB_KEYParameter)) > -1 do
        begin
          Inc(I);
          vDB_KEYParameter := Format('%s_%d', [FCursorName, I]);
        end;
        VariableName := ':' + vDB_KEYParameter + ', ' + VariableName;}
      end;
  end;
  ParseChild;
end;

function TibSHPSQLDebuggerStatement.FormatDB_KEY(ASQLText: string): string;
var
  vTables: TStrings;
  vAlias: string;
begin
  vTables := TStringList.Create;
  try
    AllSQLTables(ASQLText, vTables, True, True);
    if vTables.Count = 1 then
    begin
      vAlias := CutAlias(vTables[0]);
      if Length(vAlias) > 0 then
        Result := Format('%s.RDB$DB_KEY', [vAlias])
      else
        Result := 'RDB$DB_KEY';
    end
    else
      StatementError('Wrong cursor! More then one table found.');
  finally
    vTables.Free;
  end;
end;


function TibSHPSQLDebuggerStatement.GetIsDynamicStatement: boolean;
begin
 Result:=FIsDynamicStatement
end;

function TibSHPSQLDebuggerStatement.GetErrorHandlerStmt: IibSHDebugStatement;
begin
 Result:=FErrorHandlerStatement
end;

procedure TibSHPSQLDebuggerStatement.SetErrorHandlerStmt(
  Value: IibSHDebugStatement);
begin
 FErrorHandlerStatement:=Value
end;

function TibSHPSQLDebuggerStatement.GetLastErrorCode: TibErrorCode;
begin
 Result:=FibErrorCode
end;

procedure TibSHPSQLDebuggerStatement.SetLastErrorCode(Value: TibErrorCode);
begin
 FibErrorCode.SQLCode:=Value.SQLCode;
 FibErrorCode.IBErrorCode:=Value.IBErrorCode;
end;

end.


////////////////////////////////////////////////////////////////////////////
////////////////////

1. вложенные циклы

  for select ...
  do begin
    ...
    for select ...
    do begin
      ...
      if (...) then leave;
    end
    ...
  end

  !!! инструкция leave приводит к выходу из процедуры, а в Yaffil это должно
работать как break в паскале
////////////////////////////////////////////////////////////////////////////
////////////////////


3. курсоры в хранимых процедурах

   for select ...
   as cursor QQQ
   do begin
     ...
     update ...
     where current of QQQ;
     ...
   end

   !!! на строчке current of QQQ выдается ошибка что-то типа "...курсор QQQ
не определен..."

////////////////////////////////////////////////////////////////////////////
////////////////////

4. В Expert.18 не понималась функция ROWS_AFFECTED из дятла, совсем не
понималась. Сейчас (в .25) компилируется, но не работает в отладчике

////////////////////////////////////////////////////////////////////////////
////////////////////



CREATE PROCEDURE TEST
RETURNS (
    NAME VARCHAR(40))
AS
  declare variable A integer = -1;
  declare variable B integer = -1;
begin
  for select ID from T1 into :A
  as cursor QQ
  do begin
   for select ID from T2 into :B
   as cursor QW
   do begin
     update T2
     set ID = :B
     where current of QW;
     if (A=B) then leave;
   end
 end
 if (ROWS_AFFECTED = 1) then exit;
end








  procedure SetCursorStatement;
  type
    TCursorStatementClauses = (ccStatement, ccWhere, ccEnd);
  var
    vPosition: TCursorStatementClauses;
    vEnd: TPoint;
    vCursorReplacement: string;
  begin
      FGroupStatementType := dgstEmpty;
      FBeginOfStatement := TokenScaner.TokenBegin;
      vPosition := ccStatement;
      while TokenScaner.Next do
        case vPosition of
          ccStatement:
            begin
              if TokenScaner.UpperToken = 'WHERE' then
              begin
                vPosition := ccWhere;
                vEnd := TokenScaner.TokenEnd;
              end
              else
              if TokenScaner.Token = ';' then
              begin
                FEndOfStatement := TokenScaner.TokenEnd;
                FOperatorText := CopyToken(FBeginOfStatement, FEndOfStatement);
                FEndOfStatement.X := FEndOfStatement.X + 1;
                Break;
              end;
            end;
          ccWhere:
            begin
              if TokenScaner.UpperToken = 'CURRENT' then
              begin
                if TokenScaner.Next and
                  (TokenScaner.UpperToken = 'OF') and
                  TokenScaner.Next then
                begin
                  FCursorName := TokenScaner.Token;
                  FOperatorText := CopyToken(FBeginOfStatement, vEnd);
                  vCursorReplacement := FormatDB_KEY(Copy(FOperatorText, 1, Length(FOperatorText) - 5));
                  FOperatorText := Format('%s %s = :%s', [FOperatorText, vCursorReplacement, FCursorName]);
                  if TokenScaner.Next and (TokenScaner.Token = ';') then
                    FEndOfStatement := Point(TokenScaner.TokenEnd.X + 1, TokenScaner.TokenEnd.Y);
                  Break;
                end
                else
                  StatementError('Unexpected end of command.');
              end
              else
                vPosition := ccEnd;
            end;
          ccEnd:
            begin
              if TokenScaner.Token = ';' then
              begin
                FEndOfStatement := TokenScaner.TokenEnd;
                FOperatorText := CopyToken(FBeginOfStatement, FEndOfStatement);
                FEndOfStatement.X := FEndOfStatement.X + 1;
                Break;
              end;
            end;
        end;
      if TokenScaner.Token <> ';' then
        ParsingError(';', TokenScaner.Token);
      ParseNext;
      Result := True;
  end;

