unit ibSHInputParametersFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Contnrs,
  SHDesignIntf, ibSHDesignIntf, ibSHDriverIntf, TntStdCtrls,TntWideStrings,TntClasses;

type
  TibBTInputParametersForm = class(TSHComponentForm)
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    procedure InputEditChange(Sender: TObject);
  private
    function GetParams: IibSHDRVParams;
  private
    { Private declarations }
    FPriorCursor: TCursor;
    FEdits: TObjectList;
    FCheckBoxes: TObjectList;
    vPreparedParams:TStrings;    
    property Params: IibSHDRVParams read GetParams;
  protected
    { Protected declarations }
    procedure DoOnBeforeModalClose(Sender: TObject; var ModalResult: TModalResult;
      var Action: TCloseAction);
    procedure DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult);
    function  GetLastParamValue(const ParamName:string):variant;
    procedure SetLastParamValue(const ParamName:string;Value:variant);
    function  GetHistoryParamValues(const ParamName:string):TStrings;
    procedure SaveHistoryParamValues;    
    procedure LoadHistoryParamValues;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;
  end;

var
  ibBTInputParametersForm: TibBTInputParametersForm;

implementation

{$R *.dfm}

{ TibBTInputParametersForm }
var
        SessionParamValues:TStringList;

procedure StringsToWideStrings(Source:TStrings;Dest:TWideStrings);
var
  i:integer;
begin
  Dest.Clear;
  Dest.Capacity:=Source.Count;
  for i:=0 to Pred(Source.Count)do
  begin
    Dest.Add(UTF8Decode(Source[I]));
  end
end;

constructor TibBTInputParametersForm.Create(AOwner: TComponent;
  AParent: TWinControl; AComponent: TSHComponent; ACallString: string);
var
  I: Integer;
//  vEdit: TEdit;
  vEdit: TTntComboBox;
  vCheckBox: TCheckBox;
  vSQLHaveParamValue:boolean;
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  if SessionParamValues.Count=0 then
     LoadHistoryParamValues;

  FEdits := TObjectList.Create(False);
  FCheckBoxes := TObjectList.Create(False);
  vSQLHaveParamValue:=False;
  for I := 0 to Pred(Params.ParamCount) do
  begin
   vSQLHaveParamValue:=not Params.ParamIsNull[I];
   if vSQLHaveParamValue then
    Break;
  end;
  vPreparedParams:=TStringList.Create;
    for I := 0 to Pred(Params.ParamCount) do
    if vPreparedParams.IndexOf(Params.ParamName(I))=-1 then
    begin
      vPreparedParams.Add(Params.ParamName(I));
      with TBevel.Create(ScrollBox1) do
      begin
        Parent := ScrollBox1;
        Height := 2;
        Shape := bsBottomLine;
        Top := (I + 1)*41;
        Width := ScrollBox1.ClientWidth;
      end;
  //    vEdit := TEdit.Create(ScrollBox1);
      vEdit:= TTntComboBox.Create(ScrollBox1);
      vEdit.Parent:=ScrollBox1;
      FEdits.Add(vEdit);
      with vEdit do
      begin
        Name := 'Edit' + IntToStr(I);
        if not Params.ParamIsNull[I] then
        begin
          if vSQLHaveParamValue then
           Text := Params.ParamByIndex[I]
          else
           Text:=VarToWideStr(GetLastParamValue(Params.ParamName(I)))
        end
        else
        begin
          if vSQLHaveParamValue then
           Text:=''
          else
           Text:=VarToWideStr(GetLastParamValue(Params.ParamName(I)))
        end;
        if GetHistoryParamValues(Params.ParamName(I))<>nil then
         StringsToWideStrings(GetHistoryParamValues(Params.ParamName(I)),vEdit.Items);
//         vEdit.Items.AddStrings();
        Parent := ScrollBox1;
        Left := 220;
        Top := I * 41 + 8;
        Width := 290;
        OnChange := InputEditChange;
      end;
  //    if I = 0 then ActiveControl := vEdit;
      vCheckBox := TCheckBox.Create(ScrollBox1);
      FCheckBoxes.Add(vCheckBox);
      with vCheckBox do
      begin
        Name := 'CheckBox' + IntToStr(I);
        Parent := ScrollBox1;
        Left := 170;
        Top := I*41 + 10;
        Width := 45;
        Caption := 'Null';
        if vSQLHaveParamValue then
         Checked :=  Params.ParamIsNull[I]
        else
         Checked :=  VarIsNull(GetLastParamValue(Params.ParamName(I))) ;
  {      if Params.ParamIsNull[I] then
        begin
          Checked :=  not VarIsNull(GetLastParamValue(Params.ParamName(I))) ;
        end
        else
        begin
          Checked := False;
          if (J>=0) and  Boolean(SessionParamValues.Objects[J]) then
            Checked := True;
        end;}
        Font.Style := [fsBold];
        TabStop := False;
      end;
      with TLabel.Create(ScrollBox1) do
      begin
        Parent := ScrollBox1;
        AutoSize := False;
        WordWrap := True;
        Left := 4;
        Top := I*41 + 4;
        Width := 165;
        Height := 26;
        Caption := Params.ParamName(I);
      end;
   end;
  if Assigned(ModalForm) then
  begin
    ModalForm.OnBeforeModalClose := DoOnBeforeModalClose;
    ModalForm.OnAfterModalClose := DoOnAfterModalClose;
  end;
  FPriorCursor := Screen.Cursor;
  Screen.Cursor := crDefault;
end;

destructor TibBTInputParametersForm.Destroy;
begin
  FEdits.Free;
  FCheckBoxes.Free;
  vPreparedParams.Free;
  inherited;
end;

procedure TibBTInputParametersForm.DoOnBeforeModalClose(Sender: TObject;
  var ModalResult: TModalResult; var Action: TCloseAction);
begin
  //inherited DoOnBeforeModalClose(Sender, ModalResult, Action);
end;

procedure TibBTInputParametersForm.SaveHistoryParamValues;
var
  I: Integer;
  Path:string;
begin
     Path:=ExtractFilePath(Application.ExeName)+'..\Data\Environment\';
     ForceDirectories(Path);
     DeleteFile(Path+'\ParametersHistory.txt');
     Designer.SaveStringsToIni(Path+'\ParametersHistory.txt',
       'Parameters List',SessionParamValues,True);
     for I := 0 to SessionParamValues.Count - 1 do
      Designer.SaveStringsToIni(Path+'\ParametersHistory.txt',
        SessionParamValues[I],TStrings(SessionParamValues.Objects[I]),True);
end;


procedure TibBTInputParametersForm.LoadHistoryParamValues;
var
  I: Integer;
  Path:string;
begin
   for I:=Pred(SessionParamValues.count) downto 0 do
     SessionParamValues.Objects[i].Free;
   SessionParamValues.Clear;

     Path:=ExtractFilePath(Application.ExeName)+'..\Data\Environment\';
     ForceDirectories(Path);
     Designer.ReadStringsFromIni(Path+'\ParametersHistory.txt',
       'Parameters List',SessionParamValues);
     for I := 0 to SessionParamValues.Count - 1 do
     begin
      SessionParamValues.Objects[I]:=TStringList.Create;
      Designer.ReadStringsFromIni(Path+'\ParametersHistory.txt',
        SessionParamValues[I],TStrings(SessionParamValues.Objects[I]));
     end;
end;

procedure TibBTInputParametersForm.DoOnAfterModalClose(Sender: TObject; ModalResult: TModalResult);
var
  I: Integer;
//  Path:string;
begin
  Screen.Cursor := FPriorCursor;
  if ModalResult = mrOk then
  begin
    try
     for I := 0 to vPreparedParams.Count - 1 do
     begin
        if TCheckBox(FCheckBoxes[I]).Checked then
          Params.SetParamByName(vPreparedParams[I],Null)
        else
          Params.SetParamByName(vPreparedParams[I],TTntComboBox(FEdits[I]).Text);

       if TCheckBox(FCheckBoxes[I]).Checked then
        SetLastParamValue(vPreparedParams[I], null)
       else
        SetLastParamValue(vPreparedParams[I], TTntComboBox(FEdits[I]).Text)
     end;

     SaveHistoryParamValues;


{      for I := 0 to Params.ParamCount - 1 do
      begin
        if TCheckBox(FCheckBoxes[I]).Checked then
          Params.ParamIsNull[I] := True
        else
          Params.ParamByIndex[I] := TTntComboBox(FEdits[I]).Text;
       if TCheckBox(FCheckBoxes[I]).Checked then
        SetLastParamValue(Params.ParamName(I), null)
       else
        SetLastParamValue(Params.ParamName(I), TTntComboBox(FEdits[I]).Text)
      end;}
    except
      on E: Exception do
      begin
        Designer.ShowMsg(E.Message, mtError);
      end;
    end;
  end;
end;

procedure TibBTInputParametersForm.InputEditChange(Sender: TObject);
var
  EditIndex: Integer;
begin
  if Length((Sender as TTntComboBox).Text) > 0 then
  begin
    EditIndex := StrToInt(copy((Sender as TTntComboBox).Name, 5, MaxInt));
    if TCheckBox(FCheckBoxes[EditIndex]).Checked then
      TCheckBox(FCheckBoxes[EditIndex]).Checked := False;
  end;
end;

function TibBTInputParametersForm.GetParams: IibSHDRVParams;
begin
  if Assigned(Component) then
    Result := (Component as IibSHInputParameters).Params;
end;

function TibBTInputParametersForm.GetLastParamValue(
  const ParamName: string): variant;
var
 J:integer;
begin
  J:=SessionParamValues.IndexOf(ParamName);
  if (J<0) then
      Result:=null
  else
  if TStrings(SessionParamValues.Objects[J]).Count=0 then
      Result:=null
  else
  if Boolean(TStrings(SessionParamValues.Objects[J]).Objects[0]) then
     Result:=null
  else
     Result:=UTF8Decode(TStrings(SessionParamValues.Objects[J])[0])
end;

procedure TibBTInputParametersForm.SetLastParamValue(
  const ParamName: string; Value: variant);
var
 J:integer;
 History :TStrings;
begin
   if SessionParamValues.Find(ParamName,J) then
    History:=TStrings(SessionParamValues.Objects[J])
   else
   begin
    History:=TStringList.Create;
    SessionParamValues.AddObject(ParamName,History)
   end;
   J:=History.IndexOf(UTF8Encode(VarToWideStr(Value)));
   if J>=0 then
    History.Delete(J);
   History.InsertObject(0,UTF8Encode(VarToWideStr(Value)),TObject(VarIsNull(Value)));
   if History.Count>10 then
    History.Delete(History.Count-1)
end;

function TibBTInputParametersForm.GetHistoryParamValues(
  const ParamName: string): TStrings;
var
 J:integer;
begin
  J:=SessionParamValues.IndexOf(ParamName);
  if (J<0) then
      Result:=nil
  else
   Result:=TStrings(SessionParamValues.Objects[J])
end;



procedure FreeParamsHistory;
var
 j:integer;
begin
 for j:=Pred(SessionParamValues.count) downto 0 do
  SessionParamValues.Objects[j].Free;
 SessionParamValues.Free;
end;

initialization
 SessionParamValues:=TStringList.Create;
 SessionParamValues.Sorted:=True;
 SessionParamValues.Duplicates:=dupIgnore
finalization
 FreeParamsHistory
end.


