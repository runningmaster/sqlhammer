object ibSHTXTLoaderForm: TibSHTXTLoaderForm
  Left = 122
  Top = 107
  Width = 696
  Height = 480
  Caption = 'ibSHTXTLoaderForm'
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
    Width = 688
    Height = 49
    Align = alTop
    TabOrder = 0
    OnResize = Panel1Resize
    object Label1: TLabel
      Left = 12
      Top = 4
      Width = 50
      Height = 13
      Caption = 'File Name:'
    end
    object ComboBox1: TComboBox
      Tag = 1
      Left = 12
      Top = 20
      Width = 200
      Height = 21
      AutoComplete = False
      ItemHeight = 13
      TabOrder = 0
      OnDropDown = ComboBox1Enter
      OnEnter = ComboBox1Enter
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 429
    Width = 688
    Height = 24
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    OnResize = Panel2Resize
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 4
      Height = 24
      Align = alLeft
      Shape = bsSpacer
    end
    object Bevel2: TBevel
      Left = 26
      Top = 0
      Width = 8
      Height = 24
      Align = alLeft
      Shape = bsSpacer
    end
    object Image1: TImage
      Left = 4
      Top = 0
      Width = 22
      Height = 24
      Align = alLeft
    end
    object Panel6: TPanel
      Left = 34
      Top = 0
      Width = 140
      Height = 24
      Align = alLeft
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = 'Loading text lines...'
      TabOrder = 0
    end
    object Panel7: TPanel
      Left = 174
      Top = 0
      Width = 514
      Height = 24
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object ProgressBar1: TProgressBar
        Left = 0
        Top = 5
        Width = 150
        Height = 16
        Smooth = True
        TabOrder = 0
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 49
    Width = 688
    Height = 380
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel3'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 0
      Top = 285
      Width = 688
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 688
      Height = 285
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel3'
      TabOrder = 0
      object pSHSynEdit1: TpSHSynEdit
        Left = 0
        Top = 0
        Width = 688
        Height = 285
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        BorderStyle = bsNone
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Lines.Strings = (
          'pSHSynEdit1')
        BottomEdgeVisible = True
        BottomEdgeColor = clSilver
      end
    end
    object Panel5: TPanel
      Left = 0
      Top = 288
      Width = 688
      Height = 92
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'Panel5'
      TabOrder = 1
      object pSHSynEdit2: TpSHSynEdit
        Tag = -1
        Left = 0
        Top = 0
        Width = 688
        Height = 92
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        PopupMenu = PopupMenuMessage
        TabOrder = 0
        BorderStyle = bsNone
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Options = [eoAutoIndent, eoDragDropEditing, eoGroupUndo, eoHideShowScrollbars, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoSpecialLineDefaultFg, eoTabsToSpaces, eoTrimTrailingSpaces]
        ReadOnly = True
        WordWrap = True
        BottomEdgeVisible = True
        BottomEdgeColor = clSilver
      end
    end
  end
  object PopupMenuMessage: TPopupMenu
    Left = 132
    Top = 358
    object pmiHideMessage: TMenuItem
      Caption = 'Hide Message'
      OnClick = pmiHideMessageClick
    end
    object Clear1: TMenuItem
      Caption = 'Clear'
      OnClick = Clear1Click
    end
  end
end
