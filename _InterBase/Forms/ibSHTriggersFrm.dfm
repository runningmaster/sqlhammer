object ibBTTriggersForm: TibBTTriggersForm
  Left = 155
  Top = 116
  Width = 663
  Height = 480
  ActiveControl = TreeObjects
  Caption = 'ibBTTriggersForm'
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
    Width = 655
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 655
    Height = 350
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object TreeObjects: TVirtualStringTree
      Left = 0
      Top = 0
      Width = 655
      Height = 350
      Align = alClient
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      Header.AutoSizeIndex = 4
      Header.Font.Charset = RUSSIAN_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = 1
      Header.Options = [hoColumnResize, hoDrag, hoVisible]
      Header.Style = hsFlatButtons
      HintAnimation = hatNone
      HintMode = hmTooltip
      IncrementalSearch = isAll
      Indent = 12
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSpanColumns, toAutoTristateTracking, toAutoDeleteMovedNodes]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning]
      TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
      TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
      Columns = <
        item
          Position = 0
          Width = 25
          WideText = '#'
        end
        item
          Position = 1
          Width = 180
          WideText = 'Name'
        end
        item
          Position = 2
          Width = 70
          WideText = 'Status'
        end
        item
          Position = 3
          Width = 75
          WideText = 'Type Prefix'
        end
        item
          Position = 4
          Width = 255
          WideText = 'Type Suffix'
        end
        item
          Position = 5
          WideText = 'Position'
        end>
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 353
    Width = 655
    Height = 100
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
  end
end
