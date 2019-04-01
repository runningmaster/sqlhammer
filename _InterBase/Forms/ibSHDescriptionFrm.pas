unit ibSHDescriptionFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHDriverIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, Dialogs, SynEdit, pSHSynEdit, ActnList, ImgList, ComCtrls,
  ToolWin, AppEvnts, Menus;

type
  TibBTDescriptionForm = class(TibBTComponentForm)
    pSHSynEdit1: TpSHSynEdit;
  private
    { Private declarations }
    FDBObjectIntf: IibSHDBObject;
  protected
    { ISHRunCommands }
    function GetCanRun: Boolean; override;

    procedure Run; override;

    function DoOnOptionsChanged: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;

    property DBObject: IibSHDBObject read FDBObjectIntf;
  end;

  TibBTDescriptionFormAction_ = class(TSHAction)
  public
    constructor Create(AOwner: TComponent); override;

    function SupportComponent(const AClassIID: TGUID): Boolean; override;
    procedure EventExecute(Sender: TObject); override;
    procedure EventHint(var HintStr: String; var CanShow: Boolean); override;
    procedure EventUpdate(Sender: TObject); override;
  end;

  TibBTDescriptionFormAction_Run = class(TibBTDescriptionFormAction_)
  end;

var
  ibBTDescriptionForm: TibBTDescriptionForm;

procedure Register;

implementation

uses
  ibSHConsts;

{$R *.dfm}

procedure Register;
begin
  SHRegisterImage(TibBTDescriptionFormAction_Run.ClassName,      'Button_Run.bmp');
  SHRegisterActions([
    TibBTDescriptionFormAction_Run]);
end;

{ TibBTDescriptionForm }

constructor TibBTDescriptionForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  Supports(Component, IibSHDBObject, FDBObjectIntf);
  Assert(DBObject <> nil, 'DBObject = nil');

  Editor := pSHSynEdit1;
  Editor.Lines.Clear;
  Editor.Lines.AddStrings(DBObject.Description);
  FocusedControl := Editor;

  DoOnOptionsChanged;
end;

destructor TibBTDescriptionForm.Destroy;
begin
  if GetCanRun then Run;
  inherited Destroy;
end;

function TibBTDescriptionForm.GetCanRun: Boolean;
begin
  Result := Assigned(Editor) and Editor.Modified;
end;

procedure TibBTDescriptionForm.Run;
begin
  DBObject.Description.Assign(Editor.Lines);
  DBObject.SetDescription;
  Editor.Modified := False;
  Designer.UpdateObjectInspector;
end;

function TibBTDescriptionForm.DoOnOptionsChanged: Boolean;
begin
  Result := inherited DoOnOptionsChanged;
  if Result and Assigned(Editor) then
  begin
    Editor.Highlighter := nil;
    // Принудительная установка фонта
    Editor.Font.Charset := 1;
    Editor.Font.Color := clWindowText;
    Editor.Font.Height := -13;
    Editor.Font.Name := 'Courier New';
    Editor.Font.Pitch := fpDefault;
    Editor.Font.Size := 10;
    Editor.Font.Style := [];
  end;
end;

{ TibBTDescriptionFormAction_ }

constructor TibBTDescriptionFormAction_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallType := actCallToolbar;

  if Self is TibBTDescriptionFormAction_Run then Tag := 1;

  case Tag of
    0: Caption := '-'; // separator
    1:
    begin
      Caption := Format('%s', ['Run']);
      ShortCut := TextToShortCut('Ctrl+Enter');
      SecondaryShortCuts.Add('F9');      
    end;
  end;

  if Tag <> 0 then Hint := Caption;
end;

function TibBTDescriptionFormAction_.SupportComponent(const AClassIID: TGUID): Boolean;
begin
  Result := IsEqualGUID(AClassIID, IibSHDomain) or
            IsEqualGUID(AClassIID, IibSHTable) or
            //IsEqualGUID(AClassIID, IibSHConstraint) or
            IsEqualGUID(AClassIID, IibSHIndex) or
            IsEqualGUID(AClassIID, IibSHView) or
            IsEqualGUID(AClassIID, IibSHProcedure) or
            IsEqualGUID(AClassIID, IibSHTrigger) or
            //IsEqualGUID(AClassIID, IibSHGenerator) or
            IsEqualGUID(AClassIID, IibSHException) or
            IsEqualGUID(AClassIID, IibSHFunction) or
            IsEqualGUID(AClassIID, IibSHFilter) or
            IsEqualGUID(AClassIID, IibSHRole) or
            //IsEqualGUID(AClassIID, IibSHSystemDomain) or
            IsEqualGUID(AClassIID, IibSHSystemTable) or
            IsEqualGUID(AClassIID, IibSHSystemTableTmp);
end;

procedure TibBTDescriptionFormAction_.EventExecute(Sender: TObject);
begin
  case Tag of
    // Run
    1: (Designer.CurrentComponentForm as ISHRunCommands).Run;
  end;
end;

procedure TibBTDescriptionFormAction_.EventHint(var HintStr: String; var CanShow: Boolean);
begin
end;

procedure TibBTDescriptionFormAction_.EventUpdate(Sender: TObject);
begin
  if Assigned(Designer.CurrentComponentForm) and
     AnsiSameText(Designer.CurrentComponentForm.CallString, SCallDescription) then
  begin
    case Tag of
      // Separator
      0:
      begin
        Visible := True;
      end;
      // Run
      1:
      begin
        Visible := True;      
        Enabled := (Designer.CurrentComponentForm as ISHRunCommands).CanRun;
      end;
    end;
  end else
    Visible := False;
end;

initialization

  Register;

end.
