object ibSHWizardFieldForm: TibSHWizardFieldForm
  Left = 0
  Top = 121
  Width = 792
  Height = 514
  Caption = 'ibSHWizardFieldForm'
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
    Width = 784
    Height = 487
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Definitions'
      object Bevel1: TBevel
        Left = 0
        Top = 0
        Width = 776
        Height = 4
        Align = alTop
        Shape = bsSpacer
      end
      object Panel1: TPanel
        Left = 0
        Top = 4
        Width = 776
        Height = 455
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
        object Label3: TLabel
          Left = 4
          Top = 44
          Width = 58
          Height = 13
          Caption = 'Table Name'
          Transparent = True
        end
        object Label2: TLabel
          Left = 244
          Top = 44
          Width = 47
          Height = 13
          Caption = 'Based On'
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
        end
        object ComboBox2: TComboBox
          Left = 244
          Top = 60
          Width = 110
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          OnChange = ComboBox2Change
          Items.Strings = (
            'DOMAIN'
            'DATATYPE'
            'COMPUTED')
        end
        object DomainPanel: TPanel
          Left = 4
          Top = 88
          Width = 350
          Height = 230
          TabOrder = 3
          object Label4: TLabel
            Left = 0
            Top = 0
            Width = 36
            Height = 13
            Caption = 'Domain'
            Transparent = True
          end
          object Label5: TLabel
            Left = 0
            Top = 40
            Width = 73
            Height = 13
            Caption = 'Domain Source'
            Transparent = True
          end
          object Label13: TLabel
            Left = 0
            Top = 180
            Width = 45
            Height = 13
            Caption = 'Null Type'
            Transparent = True
          end
          object Label11: TLabel
            Left = 78
            Top = 180
            Width = 88
            Height = 13
            Caption = 'Default Expression'
            Transparent = True
          end
          object Label9: TLabel
            Left = 237
            Top = 180
            Width = 32
            Height = 13
            Caption = 'Collate'
            Transparent = True
          end
          object ComboBox3: TComboBox
            Left = 0
            Top = 16
            Width = 350
            Height = 21
            Style = csDropDownList
            DropDownCount = 25
            ItemHeight = 13
            TabOrder = 0
            OnChange = ComboBox3Change
          end
          object Panel3: TPanel
            Left = 0
            Top = 56
            Width = 350
            Height = 120
            BevelInner = bvLowered
            BevelOuter = bvNone
            Caption = 'Panel3'
            TabOrder = 1
            object pSHSynEdit3: TpSHSynEdit
              Left = 1
              Top = 1
              Width = 348
              Height = 118
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
              ReadOnly = True
              BottomEdgeVisible = True
              BottomEdgeColor = clSilver
              ShowBeginEndRegions = False
            end
          end
          object ComboBox4: TComboBox
            Left = 0
            Top = 196
            Width = 72
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 2
          end
          object ComboBox5: TComboBox
            Left = 78
            Top = 196
            Width = 152
            Height = 21
            DropDownCount = 15
            ItemHeight = 13
            TabOrder = 3
            Text = 'ComboBox5'
          end
          object ComboBox6: TComboBox
            Left = 237
            Top = 196
            Width = 113
            Height = 21
            Style = csDropDownList
            DropDownCount = 15
            ItemHeight = 13
            TabOrder = 4
          end
        end
        object DatatypePanel: TPanel
          Left = 362
          Top = 88
          Width = 350
          Height = 230
          TabOrder = 4
          object Label6: TLabel
            Left = 0
            Top = 0
            Width = 50
            Height = 13
            Caption = 'Data Type'
            Transparent = True
          end
          object Label7: TLabel
            Left = 153
            Top = 0
            Width = 33
            Height = 13
            Caption = 'Length'
            Transparent = True
          end
          object Label8: TLabel
            Left = 242
            Top = 0
            Width = 43
            Height = 13
            Caption = 'Precision'
            Transparent = True
          end
          object Label10: TLabel
            Left = 301
            Top = 0
            Width = 27
            Height = 13
            Caption = 'Scale'
            Transparent = True
          end
          object Label12: TLabel
            Left = 0
            Top = 40
            Width = 46
            Height = 13
            Caption = 'Sub Type'
            Transparent = True
          end
          object Label14: TLabel
            Left = 78
            Top = 40
            Width = 65
            Height = 13
            Caption = 'Segment Size'
            Transparent = True
          end
          object Label15: TLabel
            Left = 153
            Top = 40
            Width = 150
            Height = 13
            Caption = 'Array Dimension: [x:y [, x1:y1 '#8230']]'
            Transparent = True
          end
          object Label16: TLabel
            Left = 0
            Top = 80
            Width = 36
            Height = 13
            Caption = 'Charset'
            Transparent = True
          end
          object Label17: TLabel
            Left = 153
            Top = 80
            Width = 32
            Height = 13
            Caption = 'Collate'
            Transparent = True
          end
          object Label18: TLabel
            Left = 0
            Top = 120
            Width = 45
            Height = 13
            Caption = 'Null Type'
            Transparent = True
          end
          object Label19: TLabel
            Left = 78
            Top = 120
            Width = 88
            Height = 13
            Caption = 'Default Expression'
            Transparent = True
          end
          object ComboBox7: TComboBox
            Left = 0
            Top = 16
            Width = 145
            Height = 21
            Style = csDropDownList
            DropDownCount = 15
            ItemHeight = 13
            TabOrder = 0
            OnChange = ComboBox7Change
          end
          object Edit2: TEdit
            Left = 153
            Top = 16
            Width = 80
            Height = 21
            TabOrder = 1
            Text = 'Edit2'
            OnKeyPress = Edit2KeyPress
          end
          object ComboBox8: TComboBox
            Left = 242
            Top = 16
            Width = 50
            Height = 21
            Style = csDropDownList
            DropDownCount = 18
            ItemHeight = 13
            TabOrder = 2
            Items.Strings = (
              '1'
              '2'
              '3'
              '4'
              '5'
              '6'
              '7'
              '8'
              '9'
              '10'
              '11'
              '12'
              '13'
              '14'
              '15'
              '16'
              '17'
              '18')
          end
          object ComboBox9: TComboBox
            Left = 301
            Top = 16
            Width = 49
            Height = 21
            Style = csDropDownList
            DropDownCount = 18
            ItemHeight = 13
            TabOrder = 3
            Items.Strings = (
              '0'
              '1'
              '2'
              '3'
              '4'
              '5'
              '6'
              '7'
              '8'
              '9'
              '10'
              '11'
              '12'
              '13'
              '14'
              '15'
              '16'
              '17'
              '18')
          end
          object ComboBox10: TComboBox
            Left = 0
            Top = 56
            Width = 72
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 4
            OnChange = ComboBox7Change
            Items.Strings = (
              'BINARY'
              'TEXT')
          end
          object Edit3: TEdit
            Left = 78
            Top = 56
            Width = 65
            Height = 21
            TabOrder = 5
            Text = 'Edit3'
            OnKeyPress = Edit2KeyPress
          end
          object Edit4: TEdit
            Left = 153
            Top = 56
            Width = 197
            Height = 21
            TabOrder = 6
            Text = 'Edit4'
          end
          object ComboBox11: TComboBox
            Left = 0
            Top = 96
            Width = 145
            Height = 21
            Style = csDropDownList
            DropDownCount = 25
            ItemHeight = 13
            TabOrder = 7
            OnChange = ComboBox11Change
          end
          object ComboBox12: TComboBox
            Left = 153
            Top = 96
            Width = 137
            Height = 21
            Style = csDropDownList
            DropDownCount = 15
            ItemHeight = 13
            TabOrder = 8
          end
          object ComboBox13: TComboBox
            Left = 0
            Top = 136
            Width = 72
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 9
          end
          object ComboBox14: TComboBox
            Left = 78
            Top = 136
            Width = 272
            Height = 21
            DropDownCount = 15
            ItemHeight = 13
            TabOrder = 10
            Text = 'ComboBox8'
          end
        end
        object ComputedPanel: TPanel
          Left = 356
          Top = 320
          Width = 350
          Height = 229
          TabOrder = 5
          object pSHSynEdit2: TpSHSynEdit
            Left = 1
            Top = 1
            Width = 348
            Height = 227
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
            ShowBeginEndRegions = False
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Description'
      ImageIndex = 1
      object Bevel2: TBevel
        Left = 0
        Top = 0
        Width = 790
        Height = 4
        Align = alTop
        Shape = bsSpacer
      end
      object Panel2: TPanel
        Left = 0
        Top = 4
        Width = 790
        Height = 455
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 0
        object pSHSynEdit1: TpSHSynEdit
          Left = 1
          Top = 1
          Width = 788
          Height = 453
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
          ShowBeginEndRegions = False
        end
      end
    end
  end
end
