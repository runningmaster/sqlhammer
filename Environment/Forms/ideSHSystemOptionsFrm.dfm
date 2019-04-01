object SystemOptionsForm: TSystemOptionsForm
  Left = 110
  Top = 107
  Width = 696
  Height = 480
  ActiveControl = PropInspector
  Caption = 'SystemOptionsForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 453
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object PropInspector: TELPropertyInspector
      Left = 1
      Top = 1
      Width = 686
      Height = 451
      SortType = stNone
      Splitter = 200
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 0
      OnFilterProp = PropInspectorFilterProp
      OnGetEditorClass = PropInspectorGetEditorClass
    end
  end
end
