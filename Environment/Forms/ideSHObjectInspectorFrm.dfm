object ObjectInspectorForm: TObjectInspectorForm
  Left = 441
  Top = 227
  Width = 310
  Height = 442
  Hint = 'Object Inspector'
  ActiveControl = Tree
  BorderStyle = bsSizeToolWin
  Caption = 'Object Inspector'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 302
    Height = 415
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pSHNetscapeSplitter1: TpSHNetscapeSplitter
      Left = 0
      Top = 212
      Width = 302
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      MinSize = 1
      OnMoved = pSHNetscapeSplitter1Moved
      Maximized = False
      Minimized = False
      ButtonCursor = crDefault
      ShowButton = False
      ArrowColor = clBlack
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 302
      Height = 212
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 0
      object Tree: TVirtualStringTree
        Left = 1
        Top = 21
        Width = 300
        Height = 190
        Align = alClient
        BorderStyle = bsNone
        ButtonFillMode = fmShaded
        CheckImageKind = ckXP
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
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
        Indent = 4
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus]
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
        TreeOptions.StringOptions = [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange]
        Columns = <>
      end
      object Panel1: TPanel
        Left = 1
        Top = 1
        Width = 300
        Height = 20
        Align = alTop
        Alignment = taLeftJustify
        Caption = ' Inspector'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
    object Panel5: TPanel
      Left = 0
      Top = 215
      Width = 302
      Height = 200
      Align = alBottom
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = 'Panel5'
      TabOrder = 1
      object PropInspector: TELPropertyInspector
        Left = 1
        Top = 21
        Width = 300
        Height = 178
        PropKinds = [pkProperties, pkReadOnly]
        SortType = stNone
        Splitter = 80
        Align = alClient
        BorderStyle = bsNone
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        OnFilterProp = PropInspectorFilterProp
        OnGetEditorClass = PropInspectorGetEditorClass
      end
      object Panel4: TPanel
        Left = 1
        Top = 1
        Width = 300
        Height = 20
        Align = alTop
        Alignment = taLeftJustify
        Caption = ' Properties'
        TabOrder = 1
      end
    end
  end
end
