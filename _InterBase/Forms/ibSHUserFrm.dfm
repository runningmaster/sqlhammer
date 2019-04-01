object ibSHUserForm: TibSHUserForm
  Left = 192
  Top = 107
  Width = 340
  Height = 240
  ActiveControl = PropInspector
  Caption = 'ibSHUserForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 332
    Height = 213
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 0
    object PropInspector: TELPropertyInspector
      Left = 1
      Top = 1
      Width = 330
      Height = 211
      PropKinds = [pkProperties, pkReadOnly]
      SortType = stNone
      Splitter = 90
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 0
      OnFilterProp = PropInspectorFilterProp
      OnGetEditorClass = PropInspectorGetEditorClass
    end
  end
end
