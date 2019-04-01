inherited EnvironmentOptionsForm: TEnvironmentOptionsForm
  Left = 282
  Top = 212
  Caption = 'EnvironmentOptionsForm'
  OldCreateOrder = True
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlClient: TPanel
    object Splitter1: TSplitter
      Left = 220
      Top = 0
      Height = 325
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 220
      Height = 325
      Align = alLeft
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = 'Panel1'
      TabOrder = 0
      object Tree: TVirtualStringTree
        Left = 1
        Top = 1
        Width = 218
        Height = 323
        Align = alClient
        BorderStyle = bsNone
        ButtonFillMode = fmShaded
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
        Indent = 12
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toRightClickSelect]
        OnFocusChanged = TreeFocusChanged
        OnFreeNode = TreeFreeNode
        OnGetText = TreeGetText
        OnPaintText = TreePaintText
        OnGetImageIndex = TreeGetImageIndex
        OnGetNodeDataSize = TreeGetNodeDataSize
        OnGetPopupMenu = TreeGetPopupMenu
        Columns = <>
      end
    end
    object pnlComponentForm: TPanel
      Left = 223
      Top = 0
      Width = 271
      Height = 325
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnlComponentForm'
      TabOrder = 1
    end
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 120
    Top = 100
    object RestoreDefaults1: TMenuItem
      Caption = 'Restore Defaults'
      OnClick = RestoreDefaults1Click
    end
  end
end
