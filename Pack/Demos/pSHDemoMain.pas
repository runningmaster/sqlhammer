unit pSHDemoMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, pSHSynEdit, SynEditHighlighter, pSHHighlighter,
  StdCtrls, SynCompletionProposal, pSHCompletionProposal, AppEvnts,
  CheckLst, Grids, DBGridEh, pSHAutoComplete, addBTAutoComplete,
  addBTCompletionProposal, addBTHighlighter, addBTSynEdit;

type
  TpSHDemoMainForm = class(TForm)
    addBTHighlighter1: TaddBTHighlighter;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Memo1: TMemo;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    Button2: TButton;
    DBGridEh1: TDBGridEh;
    addBTCompletionProposal1: TaddBTCompletionProposal;
    addBTSynEdit1: TaddBTSynEdit;
    addBTAutoComplete1: TaddBTAutoComplete;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    procedure DoOnChange(SubDialect: Integer);
    procedure UpdateTableNames;
  public
    { Public declarations }
  end;

var
  pSHDemoMainForm: TpSHDemoMainForm;

implementation

uses ibBTObjectNamesManager, pSHIntf;

var
  ObjectNamesManager: TibBTObjectNamesManager;
  KeywordsManager: TibBTKeywordsManager;

{$R *.dfm}

procedure TpSHDemoMainForm.FormCreate(Sender: TObject);
begin
  ObjectNamesManager := TibBTObjectNamesManager.Create(nil);
  KeywordsManager := TibBTKeywordsManager.Create(nil);
  addBTHighlighter1.KeywordsManager := KeywordsManager as IaddBTKeywordsManager;
  addBTHighlighter1.ObjectNamesManager := ObjectNamesManager as IaddBTObjectNamesManager;
  addBTSynEdit1.CompletionProposal := addBTCompletionProposal1;
  addBTAutoComplete1.LoadFromFile(ExtractFilePath(Application.ExeName) + 'InterBaseKeyboardTemplates.txt');
  addBTAutoComplete1.AddEditor(addBTSynEdit1);
  UpdateTableNames;
  DoOnChange(1);
end;

procedure TpSHDemoMainForm.FormDestroy(Sender: TObject);
begin
  addBTHighlighter1.KeywordsManager := nil;
  addBTHighlighter1.ObjectNamesManager := nil;
  ObjectNamesManager.Free;
  KeywordsManager.Free;
end;

procedure TpSHDemoMainForm.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex < 7 then
    DoOnChange(ComboBox1.ItemIndex + 1);
end;

procedure TpSHDemoMainForm.DoOnChange(SubDialect: Integer);
begin
  addBTHighlighter1.SQLSubDialect := SubDialect;
end;

procedure TpSHDemoMainForm.Button1Click(Sender: TObject);
begin
  UpdateTableNames;
end;

procedure TpSHDemoMainForm.UpdateTableNames;
begin
  ObjectNamesManager.ObjectNames.Assign(Memo1.Lines);
end;

procedure TpSHDemoMainForm.Button2Click(Sender: TObject);
var
  I: Integer;
begin
  Label3.Caption := addBTSynEdit1.GetTokenAt(addBTSynEdit1.CaretXY, I);
end;

end.
