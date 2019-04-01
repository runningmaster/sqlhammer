unit ibSHDDLGeneratorFrm;

interface

uses
  SHDesignIntf, SHEvents, ibSHDesignIntf, ibSHComponentFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Grids, ELPropInsp, ToolWin, SynEdit,
  pSHSynEdit, StdCtrls, ImgList;

type
  TibBTDDLGeneratorForm = class(TibBTComponentForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Panel2: TPanel;
    PropInspector: TELPropertyInspector;
    ControlBar1: TControlBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    pSHSynEdit1: TpSHSynEdit;
    ComboBox1: TComboBox;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ImageList1: TImageList;
    procedure ControlBar1Resize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;
  end;

var
  ibBTDDLGeneratorForm: TibBTDDLGeneratorForm;

implementation

uses
  ibSHConsts;

{$R *.dfm}

{ TibBTDDLGeneratorForm }

constructor TibBTDDLGeneratorForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  inherited Create(AOwner, AParent, AComponent, ACallString);
  PageCtrl := PageControl1;
  PageCtrl.ActivePageIndex := 0;
  Flat := True;
  if Assigned(ModalForm) then ModalForm.CaptionOK := Format('%s', [SBtnGenerate]);
  Caption := Format('%s New %s', [CallString, Component.Association]);
  Editor := pSHSynEdit1;
  RegisterEditors;
  Editor.Lines.Clear;
  Editor.Lines.Add('Template...');
  Editor.Font.Name := 'Courier New';
  Editor.Font.Size := 10;
end;

destructor TibBTDDLGeneratorForm.Destroy;
begin
  inherited Destroy;
end;

procedure TibBTDDLGeneratorForm.ControlBar1Resize(Sender: TObject);
begin
  ToolBar1.Width := ToolBar1.Parent.ClientWidth;
  ComboBox1.Width := ComboBox1.Parent.ClientWidth - (ToolButton3.Left + ToolButton3.Width);
end;

end.
