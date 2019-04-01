object ibBTRegisterForm: TibBTRegisterForm
  Left = 122
  Top = 117
  Width = 696
  Height = 480
  ActiveControl = PropInspector
  Caption = 'ibBTRegisterForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 409
    Width = 688
    Height = 4
    Align = alBottom
    Shape = bsSpacer
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 409
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 0
    object PropInspector: TELPropertyInspector
      Left = 1
      Top = 1
      Width = 686
      Height = 407
      PropKinds = [pkProperties, pkReadOnly]
      SortType = stNone
      Splitter = 160
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 0
      OnFilterProp = PropInspectorFilterProp
      OnGetEditorClass = PropInspectorGetEditorClass
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 413
    Width = 688
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    OnResize = Panel2Resize
    object CheckBox1: TCheckBox
      Left = 110
      Top = 11
      Width = 97
      Height = 17
      Caption = 'CheckBox1'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object Button1: TButton
      Left = 0
      Top = 7
      Width = 90
      Height = 25
      Caption = 'Test Connect'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 108
    Top = 152
  end
end
