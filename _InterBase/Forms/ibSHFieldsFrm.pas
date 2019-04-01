unit ibSHFieldsFrm;

interface

uses
  SHDesignIntf, ibSHDesignIntf, ibSHTableObjectFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ToolWin, ComCtrls, ImgList, ActnList, StrUtils,
  SynEdit, pSHSynEdit,  AppEvnts, Menus, VirtualTrees, TypInfo;

type
  TibSHFieldsForm = class(TibSHTableForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    TreeObjects: TVirtualStringTree;
  private
    { Private declarations }
    FConstraints: TStrings;
  protected
    { Protected declarations }
    procedure DoOnGetData; override;  
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TWinControl;
      AComponent: TSHComponent; ACallString: string); override;
    destructor Destroy; override;
  end;

var
  ibSHFieldsForm: TibSHFieldsForm;

implementation

uses
  ibSHStrUtil;

{$R *.dfm}

{ TibSHFieldsForm }

constructor TibSHFieldsForm.Create(AOwner: TComponent; AParent: TWinControl;
  AComponent: TSHComponent; ACallString: string);
begin
  FConstraints := TStringList.Create;
  inherited Create(AOwner, AParent, AComponent, ACallString);
  MsgPanel := Panel2;
  MsgSplitter := Splitter1;
  Tree := TreeObjects;
  CreateDDLForm;
end;

destructor TibSHFieldsForm.Destroy;
begin
  FConstraints.Free;
  inherited Destroy;
end;

procedure TibSHFieldsForm.DoOnGetData;
var
  I, J: Integer;
  Default, NullType, Collate: string;
  OverloadDefault, OverloadNullType, OverloadCollate: Boolean;
  Node, Node2: PVirtualNode;
  NodeData, NodeData2: PTreeRec;
  BegSub, EndSub: TCharSet;
begin
  BegSub := ['.', '+', ')', '(', '*', '/', '|', ',', '=', '>', '<', '-', '!', '^', '~', ',', ';', ' ', #13, #10, #9, '"'];
  EndSub := ['.', '+', ')', '(', '*', '/', '|', ',', '=', '>', '<', '-', '!', '^', '~', ',', ';', ' ', #13, #10, #9, '"'];
  Tree.BeginUpdate;
  Tree.Indent := 0;
  Tree.Clear;
  if Assigned(Editor) then Editor.Clear;

  if Assigned(DBTable) then
  begin
    for I := 0 to Pred(DBTable.Fields.Count) do
    begin
      OverloadDefault := Length(Trim(DBTable.GetField(I).FieldDefault.Text)) > 0;
      if OverloadDefault then
        Default := Trim(DBTable.GetField(I).FieldDefault.Text)
      else
        Default := Trim(DBTable.GetField(I).DefaultExpression.Text);

      OverloadNullType := DBTable.GetField(I).FieldNotNull;
      if OverloadNullType then
        NullType := DBTable.GetField(I).FieldNullType
      else
        NullType := DBTable.GetField(I).NullType;

      OverloadCollate := Length(DBTable.GetField(I).FieldCollate) > 0;
      if OverloadCollate then
        Collate := DBTable.GetField(I).FieldCollate
      else
        Collate := DBTable.GetField(I).Collate;

      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.Number := IntToStr(I + 1);
      NodeData.ImageIndex := -1; // Designer.GetImageIndex(IibSHField);
      NodeData.Name := DBTable.Fields[I];
      NodeData.DataType := DBTable.GetField(I).DataTypeExt;
      NodeData.Domain := DBTable.GetField(I).Domain;
      NodeData.DefaultExpression := Default;
      NodeData.NullType := NullType;
      NodeData.Charset := DBTable.GetField(I).Charset;
      NodeData.Collate := Collate;
      NodeData.ArrayDim := DBTable.GetField(I).ArrayDim;
      NodeData.DomainCheck := Trim(DBTable.GetField(I).CheckConstraint.Text);
      NodeData.ComputedSource := Trim(DBTable.GetField(I).ComputedSource.Text);
      NodeData.Description := Trim(DBTable.GetField(I).Description.Text);
      NodeData.Source := Trim(DBTable.GetField(I).SourceDDL.Text);
      NodeData.OverloadDefault := OverloadDefault;
      NodeData.OverloadNullType := OverloadNullType;
      NodeData.OverloadCollate := OverloadCollate;

      if Length(NodeData.Description) > 0 then
      begin
        Tree.Indent := 12;
        for J := 0 to Pred(DBTable.GetField(I).Description.Count) do
        begin
          Node2 := Tree.AddChild(Node);
          NodeData2 := Tree.GetNodeData(Node2);
          NodeData2.Name := DBTable.GetField(I).Description[J];
          NodeData2.Source := NodeData.Source;
        end;
      end;

      FConstraints.Clear;
      for J := 0 to Pred(DBTable.Constraints.Count) do
      begin
        if DBTable.GetConstraint(J).ConstraintType = 'PRIMARY KEY' then
          if DBTable.GetConstraint(J).Fields.IndexOf(NodeData.Name) <> -1 then
            if FConstraints.IndexOf('PK') = -1 then FConstraints.Add('PK');
        if DBTable.GetConstraint(J).ConstraintType = 'UNIQUE' then
          if DBTable.GetConstraint(J).Fields.IndexOf(NodeData.Name) <> -1 then
            if FConstraints.IndexOf('UNQ') = -1 then FConstraints.Add('UNQ');
        if DBTable.GetConstraint(J).ConstraintType = 'FOREIGN KEY' then
          if DBTable.GetConstraint(J).Fields.IndexOf(NodeData.Name) <> -1 then
            if FConstraints.IndexOf('FK') = -1 then FConstraints.Add('FK');
        if DBTable.GetConstraint(J).ConstraintType = 'CHECK' then
          if PosExtCI(NodeData.Name, DBTable.GetConstraint(J).CheckSource.Text, BegSub, EndSub) > 0 then
            if FConstraints.IndexOf('CHK') = -1 then FConstraints.Add('CHK');
      end;

      for J := 0 to Pred(DBTable.Indices.Count) do
      begin
        if Pos('RDB$', DBTable.GetIndex(J).Caption) = 0 then
          if DBTable.GetIndex(J).Fields.IndexOf(NodeData.Name) <> -1 then
            if FConstraints.IndexOf('I') = -1 then FConstraints.Add('I');
      end;
      if FConstraints.Count > 0 then NodeData.Constraints := AnsiReplaceText(FConstraints.CommaText, ',', ', ');
    end;
  end;

  if Assigned(DBView) then
  begin
    for I := 0 to Pred(DBView.Fields.Count) do
    begin
      OverloadDefault := Length(Trim(DBView.GetField(I).FieldDefault.Text)) > 0;
      if OverloadDefault then
        Default := Trim(DBView.GetField(I).FieldDefault.Text)
      else
        Default := Trim(DBView.GetField(I).DefaultExpression.Text);

      OverloadNullType := DBView.GetField(I).FieldNotNull;
      if OverloadNullType then
        NullType := DBView.GetField(I).FieldNullType
      else
        NullType := DBView.GetField(I).NullType;

      OverloadCollate := Length(DBView.GetField(I).FieldCollate) > 0;
      if OverloadCollate then
        Collate := DBView.GetField(I).FieldCollate
      else
        Collate := DBView.GetField(I).Collate;

      Node := Tree.AddChild(nil);
      NodeData := Tree.GetNodeData(Node);
      NodeData.Number := IntToStr(I + 1);
      NodeData.ImageIndex := -1; // Designer.GetImageIndex(IibSHField);
      NodeData.Name := DBView.Fields[I];
      NodeData.DataType := DBView.GetField(I).DataTypeExt;
      NodeData.Domain := DBView.GetField(I).Domain;
      NodeData.DefaultExpression := Default;
      NodeData.NullType := NullType;
      NodeData.Charset := DBView.GetField(I).Charset;
      NodeData.Collate := Collate;
      NodeData.ArrayDim := DBView.GetField(I).ArrayDim;
      NodeData.DomainCheck := Trim(DBView.GetField(I).CheckConstraint.Text);
      NodeData.ComputedSource := Trim(DBView.GetField(I).ComputedSource.Text);
      NodeData.Description := Trim(DBView.GetField(I).Description.Text);
      NodeData.Source := Trim(DBView.GetField(I).SourceDDL.Text);
      NodeData.OverloadDefault := OverloadDefault;
      NodeData.OverloadNullType := OverloadNullType;
      NodeData.OverloadCollate := OverloadCollate;
      if Length(NodeData.Description) > 0 then
      begin
        Tree.Indent := 12;
        for J := 0 to Pred(DBView.GetField(I).Description.Count) do
        begin
          Node2 := Tree.AddChild(Node);
          NodeData2 := Tree.GetNodeData(Node2);
          NodeData2.Name := DBView.GetField(I).Description[J];
          NodeData2.Source := NodeData.Source;
        end;
      end;
    end;
  end;

  Node := Tree.GetFirst;
  if Assigned(Node) then
  begin
    Tree.FocusedNode := Node;
    Tree.Selected[Tree.FocusedNode] := True;
  end;
  Tree.EndUpdate;
end;

end.

