object ibSHWizardTriggerForm: TibSHWizardTriggerForm
  Left = 236
  Top = 198
  Width = 400
  Height = 250
  ActiveControl = Edit1
  Caption = 'ibSHWizardTriggerForm'
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
    Height = 223
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
        Height = 191
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
          Left = 274
          Top = 44
          Width = 30
          Height = 13
          Caption = 'Status'
          Transparent = True
        end
        object Label4: TLabel
          Left = 4
          Top = 84
          Width = 53
          Height = 13
          Caption = 'Type Prefix'
          Transparent = True
        end
        object Label5: TLabel
          Left = 94
          Top = 84
          Width = 53
          Height = 13
          Caption = 'Type Suffix'
          Transparent = True
        end
        object Label6: TLabel
          Left = 4
          Top = 124
          Width = 37
          Height = 13
          Caption = 'Position'
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
          Width = 260
          Height = 21
          Style = csDropDownList
          DropDownCount = 25
          ItemHeight = 13
          TabOrder = 1
        end
        object ComboBox2: TComboBox
          Left = 274
          Top = 60
          Width = 80
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
        end
        object ComboBox3: TComboBox
          Left = 4
          Top = 100
          Width = 80
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 3
        end
        object ComboBox4: TComboBox
          Left = 94
          Top = 100
          Width = 260
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 4
        end
        object Edit2: TEdit
          Left = 4
          Top = 140
          Width = 80
          Height = 21
          TabOrder = 5
          Text = 'Edit2'
          OnKeyPress = Edit2KeyPress
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
        Height = 191
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 0
        object pSHSynEdit1: TpSHSynEdit
          Left = 1
          Top = 1
          Width = 382
          Height = 189
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
