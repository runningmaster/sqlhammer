object ibSHDDLCommentatorForm: TibSHDDLCommentatorForm
  Left = 96
  Top = 107
  Width = 696
  Height = 480
  Caption = 'ibSHDDLCommentatorForm'
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
    Left = 220
    Top = 0
    Height = 453
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 220
    Height = 453
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object Tree: TVirtualStringTree
      Left = 0
      Top = 25
      Width = 220
      Height = 428
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
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning]
      TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
      TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
      TreeOptions.StringOptions = [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange]
      Columns = <
        item
          Position = 0
          Width = 220
          WideText = 'Name'
        end>
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 220
      Height = 25
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object chOnlyExistComment: TCheckBox
        Left = 3
        Top = 5
        Width = 209
        Height = 17
        Caption = 'Show objects which have description '
        TabOrder = 0
        OnClick = chOnlyExistCommentClick
      end
    end
  end
  object Panel2: TPanel
    Left = 223
    Top = 0
    Width = 465
    Height = 453
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pSHSynEdit1: TpSHSynEdit
      Left = 0
      Top = 17
      Width = 465
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
      ShowBeginEndRegions = False
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 465
      Height = 17
      Align = alTop
      Alignment = taLeftJustify
      Caption = '  Text'
      TabOrder = 0
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 273
    Top = 111
  end
end
