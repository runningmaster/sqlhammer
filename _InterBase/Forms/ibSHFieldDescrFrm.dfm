object ibSHFieldDescrForm: TibSHFieldDescrForm
  Left = 122
  Top = 107
  Width = 696
  Height = 480
  Caption = 'ibSHFieldDescrForm'
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
    Left = 200
    Top = 0
    Height = 453
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 200
    Height = 453
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object Tree: TVirtualStringTree
      Left = 0
      Top = 0
      Width = 200
      Height = 453
      Align = alClient
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      Header.AutoSizeIndex = -1
      Header.Font.Charset = RUSSIAN_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
      Header.Style = hsFlatButtons
      HintAnimation = hatNone
      HintMode = hmTooltip
      IncrementalSearch = isAll
      Indent = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning]
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
          Width = 175
          WideText = 'Name'
        end>
    end
  end
  object Panel2: TPanel
    Left = 203
    Top = 0
    Width = 485
    Height = 453
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pSHSynEdit1: TpSHSynEdit
      Left = 0
      Top = 17
      Width = 485
      Height = 436
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      TabOrder = 1
      BorderStyle = bsNone
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Lines.Strings = (
        'pSHSynEdit1')
      BottomEdgeVisible = True
      BottomEdgeColor = clSilver
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 485
      Height = 17
      Align = alTop
      Alignment = taLeftJustify
      Caption = '  Text'
      TabOrder = 0
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 403
    Top = 104
  end
end
