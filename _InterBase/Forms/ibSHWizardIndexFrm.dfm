object ibSHWizardIndexForm: TibSHWizardIndexForm
  Left = 292
  Top = 179
  Width = 523
  Height = 418
  ActiveControl = Edit1
  Caption = 'ibSHWizardIndexForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 515
    Height = 391
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Definitions'
      object Bevel1: TBevel
        Left = 0
        Top = 0
        Width = 507
        Height = 4
        Align = alTop
        Shape = bsSpacer
      end
      object Panel1: TPanel
        Left = 0
        Top = 4
        Width = 507
        Height = 359
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Label1: TLabel
          Left = 4
          Top = 4
          Width = 28
          Height = 13
          Caption = 'Name'
          Transparent = True
        end
        object Label2: TLabel
          Left = 4
          Top = 44
          Width = 58
          Height = 13
          Caption = 'Table Name'
          Transparent = True
        end
        object Label3: TLabel
          Left = 244
          Top = 44
          Width = 30
          Height = 13
          Caption = 'Status'
          Transparent = True
        end
        object Label4: TLabel
          Left = 4
          Top = 260
          Width = 53
          Height = 13
          Caption = 'Index Type'
          Transparent = True
        end
        object Label5: TLabel
          Left = 185
          Top = 260
          Width = 33
          Height = 13
          Caption = 'Sorting'
          Transparent = True
        end
        object Edit1: TEdit
          Left = 4
          Top = 20
          Width = 350
          Height = 21
          TabOrder = 0
          Text = 'Edit1'
        end
        object ComboBox1: TComboBox
          Left = 4
          Top = 60
          Width = 230
          Height = 21
          Style = csDropDownList
          DropDownCount = 25
          ItemHeight = 13
          TabOrder = 1
          OnChange = ComboBox1Change
        end
        object ComboBox2: TComboBox
          Left = 244
          Top = 60
          Width = 110
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
        end
        object GroupBox1: TGroupBox
          Left = 4
          Top = 88
          Width = 500
          Height = 165
          Caption = ' Fields '
          TabOrder = 3
          object Label6: TLabel
            Left = 8
            Top = 16
            Width = 43
            Height = 13
            Caption = 'Available'
            Transparent = True
          end
          object Label7: TLabel
            Left = 239
            Top = 16
            Width = 41
            Height = 13
            Caption = 'Included'
            Transparent = True
          end
          object BitBtn1: TBitBtn
            Left = 467
            Top = 62
            Width = 25
            Height = 25
            TabOrder = 2
            OnClick = BitBtn1Click
            Glyph.Data = {
              36050000424D3605000000000000360400002800000010000000100000000100
              080000000000000100000000000000000000000100000000000080000000CD00
              0000E2000000F1000000FF000000FE0D0D00FF00FF0080808000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              000000000000000000000000000000000000000000000000000000000000A81D
              9600000000006499F8000000B100D021B10000000000841D96008806B100381E
              96009181F900A099F800FFFFFF00481E960082C8FC007813B100D821B1000000
              0000D3C7FC000000000000000000000000000000000000000000000000000000
              000000000000010000000A001400D821B100580054002355F9004C1E96000000
              00005DAC4F00241E9600D01B96000000000000ECFD00020000000000B1004500
              000000000A00481CF9001E0000000100000006C54E00B81D9600010101005020
              96009181F9005096F800FFFFFF00C41E96001AC54E00C41E960045C54E00B700
              00000200000040209600010000001800000000000000A81E9600420000000000
              00008C1E96000000000000000000000000000C00000002000000010196000815
              F90000ECFD00000000000300000026001A00D821B1007FFFFF0000000000D821
              B10005000000E5734E00E81E96000F584F008C01000000000000000000000000
              0000020000000000000000000000282096007FE94B0090E59600000000000000
              00001C20960002000000800000000000000000010000B02096003C38E100433A
              5C00315C430069703100626D70000000960078D0A00000000000281F96008806
              9600DC1F96009181F900A099F800FFFFFF00EC1F960082C8FC00D807960080D0
              A0000000000080D0A0003C38E100BC020D0000000000E0E8B00000009600981F
              96006253E100C362E2000000960000000000070000000000000001000000001F
              960007000000C362E200F8EBFD000000000080D0A000380000004AD0F8000000
              960007000000001F96009181F9004096F80001FFFF000C2096005C1F96000101
              0100242096009181F9005096F800FFFFFF003420960081E94900000096000000
              000080D0A000000000007C2096003C38E10028000000B83CF40001000000000A
              00000C00000000000000010000000F000000B67C460090E59600060606060606
              0606060606060606060606060606060606060606060606060606060606060606
              0707070707060606060606060606060000000000070606060606060606060605
              0302010007060606060606060606060405030200070606060606060606060604
              0404030007060606060606060606060404040400070606060606060606060604
              0404040007070706060606060604040404040404040406060606060606060404
              0404040404060606060606060606060404040404060606060606060606060606
              0404040606060606060606060606060606040606060606060606060606060606
              0606060606060606060606060606060606060606060606060606}
            Layout = blGlyphRight
          end
          object BitBtn2: TBitBtn
            Left = 467
            Top = 95
            Width = 25
            Height = 25
            TabOrder = 3
            OnClick = BitBtn2Click
            Glyph.Data = {
              36050000424D3605000000000000360400002800000010000000100000000100
              080000000000000100000000000000000000000100000000000080000000DC00
              0000EC000000FC000000FF000000FF00FF008080800000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              000000000000000000000000000000000000000000000000000000000000A81D
              9600000000006499F8000000B100D021B10000000000841D96008806B100381E
              96009181F900A099F800FFFFFF00481E960082C8FC007813B100D821B1000000
              0000D3C7FC000000000000000000000000000000000000000000000000000000
              000000000000010000000A001400D821B100580054002355F9004C1E96000000
              00005DAC4F00241E9600D01B96000000000000ECFD00020000000000B1004500
              000000000A00481CF9001E0000000100000006C54E00B81D9600010101005020
              96009181F9005096F800FFFFFF00C41E96001AC54E00C41E960045C54E00B700
              00000200000040209600010000001800000000000000A81E9600420000000000
              00008C1E96000000000000000000000000000C00000002000000010196000815
              F90000ECFD00000000000300000026001A00D821B1007FFFFF0000000000D821
              B10005000000E5734E00E81E96000F584F009C01000000000000000000000000
              0000020000000000000000000000282096007FE94B008081A100000000000000
              00001C20960002000000800000000000000000010000B02096003C38E100433A
              5C00315C430069703100626D700000009600C8FF960000000000281F96008806
              9600DC1F96009181F900A099F800FFFFFF00EC1F960082C8FC00D8079600D0FF
              960000000000D0FF96003C38E100BC020D0000000000E0E8B00000009600981F
              96006253E100C362E2000000960000000000070000000000000001000000001F
              960007000000C362E200F8EBFD0000000000D0FF9600380000004AD0F8000000
              960007000000001F96009181F9004096F80001FFFF000C2096005C1F96000101
              0100242096009181F9005096F800FFFFFF003420960081E94900000096000000
              0000D0FF9600000000007C2096003C38E10028000000B83CF400010000000D0F
              00000C00000000000000010000000F000000B67C46008081A100050505050505
              0505050505050505050505050505050505050505050505050505050505050505
              0505060505050505050505050505050505000606050505050505050505050505
              0404000606050505050505050505050404040400060605050505050505050404
              0404040400060605050505050504040404040400000005050505050505050504
              0404040006050505050505050505050404040400060505050505050505050504
              0404040006050505050505050505050404040300060505050505050505050504
              0403020006050505050505050505050403020100050505050505050505050505
              0505050505050505050505050505050505050505050505050505}
            Layout = blGlyphRight
          end
          object CheckListBox1: TCheckListBox
            Left = 8
            Top = 32
            Width = 220
            Height = 125
            OnClickCheck = CheckListBox1ClickCheck
            ItemHeight = 13
            Items.Strings = (
              'ID'
              'TEMP')
            TabOrder = 0
            OnDblClick = CheckListBox1DblClick
          end
          object ListBox1: TListBox
            Left = 239
            Top = 32
            Width = 220
            Height = 125
            ItemHeight = 13
            TabOrder = 1
          end
        end
        object ComboBox3: TComboBox
          Left = 4
          Top = 276
          Width = 170
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 4
        end
        object ComboBox4: TComboBox
          Left = 185
          Top = 276
          Width = 170
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 5
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Description'
      ImageIndex = 1
      object Bevel2: TBevel
        Left = 0
        Top = 0
        Width = 507
        Height = 4
        Align = alTop
        Shape = bsSpacer
      end
      object Panel2: TPanel
        Left = 0
        Top = 4
        Width = 507
        Height = 359
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 0
        object pSHSynEdit1: TpSHSynEdit
          Left = 1
          Top = 1
          Width = 505
          Height = 357
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
    end
  end
end
