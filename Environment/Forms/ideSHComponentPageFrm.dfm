object ComponentPageForm: TComponentPageForm
  Left = 312
  Top = 143
  Width = 494
  Height = 480
  Hint = 'Component Palette'
  Caption = 'Palette'
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
    Width = 486
    Height = 453
    Align = alClient
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Tree: TVirtualStringTree
      Left = 0
      Top = 20
      Width = 486
      Height = 433
      Align = alClient
      BorderStyle = bsNone
      ButtonFillMode = fmShaded
      CheckImageKind = ckXP
      Color = clBtnFace
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoColumnResize, hoDrag]
      HintAnimation = hatNone
      HintMode = hmTooltip
      IncrementalSearch = isAll
      Indent = 12
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
      TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
      TreeOptions.StringOptions = [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange]
      Columns = <>
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 486
      Height = 20
      Align = alTop
      Alignment = taLeftJustify
      Caption = ' Toolbox'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 192
    Top = 86
    object CreateInstance1: TMenuItem
      Caption = 'Create Instance'
      ShortCut = 13
      OnClick = CreateInstance1Click
    end
  end
end
