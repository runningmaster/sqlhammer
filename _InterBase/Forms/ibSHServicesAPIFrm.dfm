object ibSHServicesAPIForm: TibSHServicesAPIForm
  Left = 198
  Top = 107
  Width = 696
  Height = 480
  ActiveControl = pSHSynEdit1
  Caption = 'ibSHServicesAPIForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 350
    Width = 688
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object Panel1: TPanel
    Left = 0
    Top = 137
    Width = 688
    Height = 213
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 2
    object pSHSynEdit1: TpSHSynEdit
      Left = 0
      Top = 0
      Width = 688
      Height = 213
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
      Options = [eoAutoIndent, eoDragDropEditing, eoGroupUndo, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoSpecialLineDefaultFg, eoTabsToSpaces, eoTrimTrailingSpaces]
      BottomEdgeVisible = True
      BottomEdgeColor = clSilver
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 353
    Width = 688
    Height = 100
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 3
    object pSHSynEdit2: TpSHSynEdit
      Tag = -1
      Left = 0
      Top = 0
      Width = 688
      Height = 100
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
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 49
    Align = alTop
    TabOrder = 0
    OnResize = Panel3Resize
    object Label1: TLabel
      Left = 12
      Top = 4
      Width = 49
      Height = 13
      Caption = 'Database:'
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
  object Panel6: TPanel
    Left = 0
    Top = 49
    Width = 688
    Height = 88
    Align = alTop
    TabOrder = 1
    OnResize = Panel6Resize
    object Label2: TLabel
      Left = 12
      Top = 4
      Width = 37
      Height = 13
      Caption = 'Source:'
    end
    object Label3: TLabel
      Left = 12
      Top = 44
      Width = 56
      Height = 13
      Caption = 'Destination:'
    end
    object ComboBox2: TComboBox
      Tag = 2
      Left = 12
      Top = 20
      Width = 250
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'ComboBox2'
      OnDropDown = ComboBox1Enter
      OnEnter = ComboBox1Enter
    end
    object ComboBox3: TComboBox
      Tag = 3
      Left = 12
      Top = 60
      Width = 250
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'ComboBox3'
      OnDropDown = ComboBox1Enter
      OnEnter = ComboBox1Enter
    end
  end
  object ImageList1: TImageList
    Left = 124
    Top = 124
    Bitmap = {
      494C010104000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000051527600151A6E000B116900080D64000D0D4D001D1E32005E5E
      6200000000000000000000000000000000000000000000000000000000000000
      000000B80000005E000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007088900060809000607880005070
      8000506070004058600040485000303840002030300020203000101820001010
      1000101020000000000000000000000000000000000000000000000000007377
      AA00090C810000008B0000008C0000008C0000008B000001870000037E000106
      5E001D1D31000000000000000000000000000000000000000000000000000000
      000000B8000000CD0000005E0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF9B9B00FF9B9B00FF9B9B00000000000000000000000000FF9B9B00FF9B
      9B00FF9B9B000000000000000000000000007088900090A0B00070B0D0000090
      D0000090D0000090D0000090C0001088C0001080B0001080B0002078A0002070
      90002048600000000000000000000000000000000000000000007271AC000303
      900000008C00000090000000900000009D00000090000000900000008C000003
      7F000000760015132D0000000000000000000000000000000000000000000000
      000000B8000000DC000000CD0000005E00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008800
      00008800000088000000FF9B9B00000000000000000088000000880000008800
      0000FF9B9B000000000000000000000000008088900080C0D00090A8B00080E0
      FF0060D0FF0050C8FF0050C8FF0040C0F00030B0F00030A8F00020A0E0001090
      D000206880005961670000000000000000000000000000000000040497000202
      8E004A4EC1001819A8000000AB000000AB000000AB0002029B00484BBD001112
      9A0000008C00000077002C2C3800000000000000000000000000000000000000
      000000B8000000E7000000DC000000CD0000005E000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000008090A00080D0F00090A8B00090C0
      D00070D8FF0060D0FF0060D0FF0050C8FF0050C0FF0040B8F00030B0F00030A8
      F0001088D000204860000000000000000000000000002325AE000000A5004444
      A800F0EFEF00C8CAEF001719B7000000AD000202AE00585ABD00F1F2F300BBBC
      DF000A0A920000008D0005085B00000000000000000000000000000000000000
      000000B8000000F1000000E7000000DC000000CD0000005E0000000000000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000008090A00080D8F00080C8E00090A8
      B00080E0FF0070D0FF0060D8FF0060D0FF0060D0FF0050C8FF0040C0F00040B8
      F00030B0F000206880006A8B9A0000000000000000000202A9000000AE002221
      A800B8B2B100F7F6F500C5C7EB001A1BB8006266CE00F5F6F000F1EFEC007174
      AD000404AA0000009600000082004F505B000000000000000000000000000000
      000000B8000000FC000000F1000000E7000000DC000000CD0000005E00000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000008098A00090E0F00090E0FF0090A8
      B00090B8C00070D8FF0060D8FF0060D8FF0060D8FF0060D0FF0050D0FF0050C8
      FF0040B8F00030A0E00049677700000000004C4DE6000000AE000000C5000000
      CD001C1CB700BCB5B400FBFBFA00DCDDF100F2F2F700F3F4ED006F71AE000303
      BD000000B0000000A90000009400302F4A000000000000000000000000000000
      000000B800000DFE0D0000FC000000F1000000E7000000DC000000CD0000005E
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000008098A00090E0F000A0E8FF0080C8
      E00090A8B00080E0FF0080E0FF0080E0FF0080E0FF0080E0FF0080E0FF0080E0
      FF0070D8FF0070D8FF0050A8D00087929D00181EC7000101C6000202D0000202
      D0000000CE002526BF00E7E3E700F8F8F800F9F9F900898ECA000404C9000000
      CA000000C6000000AF000000AC002D2857000000000000000000000000000000
      000000B8000017FF17000DFE0D0000FC000000F1000000E7000000DC000000AD
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B0000000000000000000000000090A0A000A0E8F000A0E8FF00A0E8
      FF0090B0C00090B0C00090A8B00090A8B00080A0B00080A0B0008098A0008098
      A0008090A0008090A0008088900070889000191FCE000C0CDA000909E5000505
      E6000202D3005E63D000F5F5F400F9F9F900F9F9F800C8CBF0001719CF000000
      CE000000CE000202C7000000AE00383759000000000000000000000000000000
      000000B8000027FF270017FF17000DFE0D0000FC000000F1000000AD00000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B0000000000000000000000000090A0B000A0E8F000A0F0FF00A0E8
      FF00A0E8FF0080D8FF0060D8FF0060D8FF0060D8FF0060D8FF0060D8FF0060D8
      FF00708890000000000000000000000000005051F1001212E5001717F4001111
      F3005E63D800F4F4F100F1F2EB008E93C400CFC9D100FBFAF900C5C7ED001B1B
      DA000707DE000202CD000A0DBC005B5B7A000000000000000000000000000000
      000000B8000031FF310027FF270017FF17000DFE0D0000AD0000000000000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B0000000000000000000000000090A0B000A0F0F000B0F0F000A0F0
      FF00A0E8FF00A0E8FF0070D8FF0090A0A0008098A0008098A0008090A0008090
      900070889000000000000000000000000000000000001D1DF4002626FE00545A
      D300F0F2E700F5EFEB006F70BB000404E8001F20C200B8B1B100F7F6F600C4C4
      ED001212E7000E0EDC000F11C300000000000000000000000000000000000000
      000000B8000041FF410031FF310027FF270000AD000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B0000000000000000000000000090A8B000A0D0E000B0F0F000B0F0
      F000A0F0FF00A0E8FF0090A0B000B3C9CE000000000000000000000000000000
      000000000000906850009068500090685000000000003A3AFA003A3AFF005254
      E700C2BAC0007270B9000707ED000000EF000000EE001B1CCD00A8A4A6007272
      B9001E1EF5001111E2003941AA00000000000000000000000000000000000000
      000000B800004CFE4C0041FF410000AD00000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000000000000090A8B00090A8B00090A8
      B00090A8B00090A8B000B6C5CA00000000000000000000000000000000000000
      00000000000000000000906850009068500000000000000000003D3DFE005555
      FF006161EB005454F9003232FD001E1EF8001D1DF8002E2EFC004748E9003C3C
      FB002929FF002223E50000000000000000000000000000000000000000000000
      000000B800005CFF5C0000AD0000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000000000000000000000000000FF6B6B00FE5151008800
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000090786000000000000000
      000000000000A090800000000000907860000000000000000000000000005050
      FF007676FF009595FF009191FF007B7BFF007676FF006262FF005959FF004141
      FF003133F2000000000000000000000000000000000000000000000000000000
      000000B8000000AD000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A0908000A088
      8000B09880000000000000000000000000000000000000000000000000000000
      00005A5AFF007676FF009595FF009696FF008383FF006262FF004747FF005352
      FA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007575FF005E5EFF005D5DFF00777BFA00000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFF80FF3FFFFFF0007E007
      F1FFF1C70007C003F0FFE1870003C001F07FE18700038001F03FE18700018000
      F01FE18700010000F00FE18700000000F00FE18700000000F01FE18700070000
      F03FE18700078001F07FE18700F88001F0FFE18781FCC003F1FFE38FFFBAE007
      F3FFFFFFFFC7F00FFFFFFFFFFFFFFC3F00000000000000000000000000000000
      000000000000}
  end
  object PopupMenuMessage: TPopupMenu
    AutoHotkeys = maManual
    Left = 132
    Top = 358
    object pmiHideMessage: TMenuItem
      Caption = 'Hide Message'
      OnClick = pmiHideMessageClick
    end
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 572
    Top = 36
    object GetDatabaseNameFromRegistrator1: TMenuItem
      Caption = 'Get Database Name From Navigator'
      Hint = 'Get Database Name From Navigator'
    end
    object GetDatabaseNameFromNavigator1: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Get Database Name From Registrator'
      Hint = 'Get Database Name From Registrator'
    end
  end
end