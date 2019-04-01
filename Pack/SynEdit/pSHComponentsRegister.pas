unit pSHComponentsRegister;

interface

uses Classes,
     pSHHighlighter, pSHSynEdit, pSHDBSynEdit, pSHCompletionProposal,
     pSHAutoComplete, pSHNetscapeSplitter;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SQLHammer', [TpSHSynEdit, TpSHDBSynEdit, TpSHHighlighter,
    TpSHCompletionProposal, TpSHAutoComplete, TpSHNetscapeSplitter]);
end;

end.
