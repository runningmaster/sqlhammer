object ibSHDDLExtractorForm: TibSHDDLExtractorForm
  Left = 96
  Top = 107
  Width = 696
  Height = 480
  ActiveControl = pSHSynEdit1
  Caption = 'TibSHDDLExtractorForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 38
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 1
    Visible = False
    object ComboBox1: TComboBox
      Left = 12
      Top = 8
      Width = 200
      Height = 21
      AutoComplete = False
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 38
    Width = 688
    Height = 391
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 200
      Top = 0
      Height = 391
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 200
      Height = 391
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel3'
      TabOrder = 0
      object Tree: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 200
        Height = 391
        Align = alClient
        BorderStyle = bsNone
        ButtonFillMode = fmShaded
        Header.AutoSizeIndex = -1
        Header.Font.Charset = RUSSIAN_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.MainColumn = -1
        Header.Options = [hoColumnResize, hoDrag]
        Header.Style = hsFlatButtons
        HintAnimation = hatNone
        HintMode = hmTooltip
        IncrementalSearch = isAll
        Indent = 12
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus]
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
        TreeOptions.StringOptions = [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange]
        Columns = <>
      end
    end
    object Panel4: TPanel
      Left = 203
      Top = 0
      Width = 485
      Height = 391
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel4'
      TabOrder = 1
      object pSHSynEdit1: TpSHSynEdit
        Left = 0
        Top = 0
        Width = 485
        Height = 391
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
        BottomEdgeVisible = True
        BottomEdgeColor = clSilver
        ShowBeginEndRegions = False
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 429
    Width = 688
    Height = 24
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel5'
    TabOrder = 0
    Visible = False
    OnResize = Panel5Resize
    object Image1: TImage
      Left = 4
      Top = 0
      Width = 22
      Height = 24
      Align = alLeft
    end
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 4
      Height = 24
      Align = alLeft
      Shape = bsSpacer
    end
    object Bevel2: TBevel
      Left = 26
      Top = 0
      Width = 8
      Height = 24
      Align = alLeft
      Shape = bsSpacer
    end
    object Panel6: TPanel
      Left = 34
      Top = 0
      Width = 140
      Height = 24
      Align = alLeft
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = 'Extracting procedures...'
      TabOrder = 0
    end
    object Panel7: TPanel
      Left = 174
      Top = 0
      Width = 514
      Height = 24
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object ProgressBar1: TProgressBar
        Left = 0
        Top = 5
        Width = 150
        Height = 16
        Smooth = True
        TabOrder = 0
      end
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 305
    Top = 123
  end
end
