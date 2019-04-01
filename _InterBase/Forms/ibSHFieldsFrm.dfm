object ibSHFieldsForm: TibSHFieldsForm
  Left = 122
  Top = 158
  Width = 696
  Height = 480
  ActiveControl = TreeObjects
  Caption = 'ibSHFieldsForm'
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
      TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
      TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
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
          Width = 55
          WideText = 'Constr'
        end
        item
          Position = 3
          Width = 110
          WideText = 'Data Type'
        end
        item
          Position = 4
          Width = 110
          WideText = 'Domain'
        end
        item
          Position = 5
          Width = 90
          WideText = 'Default Expr'
        end
        item
          Position = 6
          Width = 65
          WideText = 'Null Type'
        end
        item
          Position = 7
          Width = 70
          WideText = 'Charset'
        end
        item
          Position = 8
          Width = 70
          WideText = 'Collate'
        end
        item
          Position = 9
          WideText = 'Array'
        end
        item
          Position = 10
          Width = 140
          WideText = 'Computed Source'
        end
        item
          Position = 11
          Width = 140
          WideText = 'Domain Check'
        end
        item
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
          Position = 12
          Width = 150
          WideText = 'Description'
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
    TabOrder = 1
  end
end
