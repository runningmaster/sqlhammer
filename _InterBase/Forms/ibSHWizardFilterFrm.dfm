object ibSHWizardFilterForm: TibSHWizardFilterForm
  Left = 256
  Top = 193
  Width = 696
  Height = 480
  ActiveControl = Edit1
  Caption = 'ibSHWizardFilterForm'
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
    Width = 688
    Height = 453
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Definitions'
      object Bevel1: TBevel
        Left = 0
        Top = 0
        Width = 680
        Height = 4
        Align = alTop
        Shape = bsSpacer
      end
      object Panel1: TPanel
        Left = 0
        Top = 4
        Width = 680
        Height = 421
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
          Width = 51
          Height = 13
          Caption = 'Input Type'
          Transparent = True
        end
        object Label3: TLabel
          Left = 185
          Top = 44
          Width = 59
          Height = 13
          Caption = 'Output Type'
          Transparent = True
        end
        object Label4: TLabel
          Left = 4
          Top = 84
          Width = 51
          Height = 13
          Caption = 'Entry Point'
          Transparent = True
        end
        object Label5: TLabel
          Left = 185
          Top = 84
          Width = 66
          Height = 13
          Caption = 'Module Name'
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
        object Edit2: TEdit
          Left = 4
          Top = 60
          Width = 170
          Height = 21
          TabOrder = 1
          Text = 'Edit2'
          OnKeyPress = Edit2KeyPress
        end
        object Edit3: TEdit
          Left = 185
          Top = 60
          Width = 170
          Height = 21
          TabOrder = 2
          Text = 'Edit2'
          OnKeyPress = Edit2KeyPress
        end
        object Edit4: TEdit
          Left = 4
          Top = 100
          Width = 170
          Height = 21
          TabOrder = 3
          Text = 'Edit4'
        end
        object Edit5: TEdit
          Left = 185
          Top = 100
          Width = 170
          Height = 21
          TabOrder = 4
          Text = 'Edit5'
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Description'
      ImageIndex = 1
      object Bevel2: TBevel
        Left = 0
        Top = 0
        Width = 680
        Height = 4
        Align = alTop
        Shape = bsSpacer
      end
      object Panel2: TPanel
        Left = 0
        Top = 4
        Width = 680
        Height = 421
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 0
        object pSHSynEdit1: TpSHSynEdit
          Left = 1
          Top = 1
          Width = 678
          Height = 419
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
