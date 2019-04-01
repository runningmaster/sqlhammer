object ibSHWizardDomainForm: TibSHWizardDomainForm
  Left = 192
  Top = 107
  Width = 400
  Height = 420
  ActiveControl = Edit1
  Caption = 'ibSHWizardDomainForm'
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
    Width = 392
    Height = 393
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Definitions'
      object Bevel1: TBevel
        Left = 0
        Top = 0
        Width = 384
        Height = 4
        Align = alTop
        Shape = bsSpacer
      end
      object Panel1: TPanel
        Left = 0
        Top = 4
        Width = 384
        Height = 361
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
          Width = 50
          Height = 13
          Caption = 'Data Type'
          Transparent = True
        end
        object Label3: TLabel
          Left = 157
          Top = 44
          Width = 33
          Height = 13
          Caption = 'Length'
          Transparent = True
        end
        object Label4: TLabel
          Left = 246
          Top = 44
          Width = 43
          Height = 13
          Caption = 'Precision'
          Transparent = True
        end
        object Label5: TLabel
          Left = 305
          Top = 44
          Width = 27
          Height = 13
          Caption = 'Scale'
          Transparent = True
        end
        object Label6: TLabel
          Left = 4
          Top = 84
          Width = 46
          Height = 13
          Caption = 'Sub Type'
          Transparent = True
        end
        object Label7: TLabel
          Left = 82
          Top = 84
          Width = 65
          Height = 13
          Caption = 'Segment Size'
          Transparent = True
        end
        object Label8: TLabel
          Left = 4
          Top = 124
          Width = 36
          Height = 13
          Caption = 'Charset'
          Transparent = True
        end
        object Label9: TLabel
          Left = 159
          Top = 124
          Width = 32
          Height = 13
          Caption = 'Collate'
          Transparent = True
        end
        object Label10: TLabel
          Left = 157
          Top = 84
          Width = 150
          Height = 13
          Caption = 'Array Dimension: [x:y [, x1:y1 '#8230']]'
          Transparent = True
        end
        object Label11: TLabel
          Left = 82
          Top = 164
          Width = 88
          Height = 13
          Caption = 'Default Expression'
          Transparent = True
        end
        object Label12: TLabel
          Left = 4
          Top = 206
          Width = 201
          Height = 13
          Caption = 'Check Constraint: without keyword '#39'check'#39
          Transparent = True
        end
        object Label13: TLabel
          Left = 4
          Top = 164
          Width = 45
          Height = 13
          Caption = 'Null Type'
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
          Width = 145
          Height = 21
          Style = csDropDownList
          DropDownCount = 15
          ItemHeight = 13
          TabOrder = 1
          OnChange = ComboBox1Change
        end
        object Edit2: TEdit
          Left = 157
          Top = 60
          Width = 80
          Height = 21
          TabOrder = 2
          Text = 'Edit2'
          OnKeyPress = Edit2KeyPress
        end
        object ComboBox2: TComboBox
          Left = 246
          Top = 60
          Width = 50
          Height = 21
          Style = csDropDownList
          DropDownCount = 18
          ItemHeight = 13
          TabOrder = 3
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
        object ComboBox3: TComboBox
          Left = 305
          Top = 60
          Width = 50
          Height = 21
          Style = csDropDownList
          DropDownCount = 18
          ItemHeight = 13
          TabOrder = 4
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
        object ComboBox4: TComboBox
          Left = 4
          Top = 100
          Width = 72
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 5
          OnChange = ComboBox1Change
          Items.Strings = (
            'BINARY'
            'TEXT')
        end
        object Edit3: TEdit
          Left = 82
          Top = 100
          Width = 65
          Height = 21
          TabOrder = 6
          Text = 'Edit3'
          OnKeyPress = Edit2KeyPress
        end
        object ComboBox5: TComboBox
          Left = 4
          Top = 140
          Width = 145
          Height = 21
          Style = csDropDownList
          DropDownCount = 25
          ItemHeight = 13
          TabOrder = 8
          OnChange = ComboBox5Change
        end
        object ComboBox6: TComboBox
          Left = 159
          Top = 140
          Width = 137
          Height = 21
          Style = csDropDownList
          DropDownCount = 15
          ItemHeight = 13
          TabOrder = 9
        end
        object Edit4: TEdit
          Left = 157
          Top = 100
          Width = 198
          Height = 21
          TabOrder = 7
          Text = 'Edit4'
        end
        object ComboBox7: TComboBox
          Left = 4
          Top = 180
          Width = 72
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 10
        end
        object Panel3: TPanel
          Left = 4
          Top = 222
          Width = 350
          Height = 135
          BevelInner = bvLowered
          BevelOuter = bvNone
          Caption = 'Panel3'
          TabOrder = 12
          object pSHSynEdit2: TpSHSynEdit
            Left = 1
            Top = 1
            Width = 348
            Height = 133
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
        object ComboBox8: TComboBox
          Left = 82
          Top = 180
          Width = 273
          Height = 21
          DropDownCount = 15
          ItemHeight = 13
          TabOrder = 11
          Text = 'ComboBox8'
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Description'
      ImageIndex = 1
      object Bevel2: TBevel
        Left = 0
        Top = 0
        Width = 384
        Height = 4
        Align = alTop
        Shape = bsSpacer
      end
      object Panel2: TPanel
        Left = 0
        Top = 4
        Width = 384
        Height = 361
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 0
        object pSHSynEdit1: TpSHSynEdit
          Left = 1
          Top = 1
          Width = 382
          Height = 359
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
