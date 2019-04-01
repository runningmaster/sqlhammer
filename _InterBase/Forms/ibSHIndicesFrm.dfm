object ibBTIndicesForm: TibBTIndicesForm
  Left = 206
  Top = 110
  Width = 696
  Height = 480
  ActiveControl = TreeObjects
  Caption = 'ibBTIndicesForm'
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
    Top = 0
    Width = 688
    Height = 350
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object TreeObjects: TVirtualStringTree
      Left = 0
      Top = 0
      Width = 688
      Height = 350
      Align = alClient
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      Header.AutoSizeIndex = -1
      Header.Font.Charset = RUSSIAN_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = 1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
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
      TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
      TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
      TreeOptions.StringOptions = [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange]
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
          Width = 150
          WideText = 'Fields or Expression'
        end
        item
          Position = 3
          Width = 60
          WideText = 'Status'
        end
        item
          Position = 4
          Width = 60
          WideText = 'Type'
        end
        item
          Position = 5
          Width = 80
          WideText = 'Sorting'
        end
        item
          Position = 6
          Width = 133
          WideText = 'Statistics'
        end>
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
    TabOrder = 1
  end
end
