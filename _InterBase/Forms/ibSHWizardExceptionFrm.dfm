object ibSHWizardExceptionForm: TibSHWizardExceptionForm
  Left = 192
  Top = 107
  Width = 400
  Height = 250
  ActiveControl = Edit1
  Caption = 'ibSHWizardExceptionForm'
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
          Width = 21
          Height = 13
          Caption = 'Text'
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
        object Panel3: TPanel
          Left = 4
          Top = 60
          Width = 350
          Height = 100
          BevelInner = bvLowered
          BevelOuter = bvNone
          Caption = 'Panel3'
          TabOrder = 1
          object pSHSynEdit2: TpSHSynEdit
            Left = 1
            Top = 1
            Width = 348
            Height = 98
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
            WordWrap = True
            BottomEdgeVisible = True
            BottomEdgeColor = clSilver
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
