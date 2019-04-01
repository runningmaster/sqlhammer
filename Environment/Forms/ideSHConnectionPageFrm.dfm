object ConnectionPageForm: TConnectionPageForm
  Left = 196
  Top = 200
  Width = 596
  Height = 480
  ActiveControl = Tree
  Caption = 'ConnectionPageForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 588
    Height = 2
    Align = alTop
    Shape = bsSpacer
  end
  object Bevel2: TBevel
    Left = 0
    Top = 25
    Width = 588
    Height = 2
    Align = alTop
    Shape = bsSpacer
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 2
    Width = 588
    Height = 23
    AutoSize = True
    ButtonHeight = 23
    Caption = 'ToolBar1'
    EdgeBorders = []
    Flat = True
    Images = MainForm.ImageList1
    TabOrder = 0
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Hint = 'Registration Info'
      DropdownMenu = PopupMenu1
      ImageIndex = 67
      ParentShowHint = False
      ShowHint = True
      Style = tbsDropDown
      OnClick = ToolButton1Click
    end
    object ToolButton2: TToolButton
      Left = 36
      Top = 0
      Action = MainForm.actConnect
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton3: TToolButton
      Left = 59
      Top = 0
      Action = MainForm.actReconnect
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton4: TToolButton
      Left = 82
      Top = 0
      Action = MainForm.actDisconnect
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton5: TToolButton
      Left = 105
      Top = 0
      Action = MainForm.actDisconnectAll
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton6: TToolButton
      Left = 128
      Top = 0
      Action = MainForm.actUpdate
      ParentShowHint = False
      ShowHint = True
    end
  end
  object Panel0: TPanel
    Left = 0
    Top = 27
    Width = 588
    Height = 426
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel0'
    TabOrder = 1
    object pSHNetscapeSplitter1: TpSHNetscapeSplitter
      Left = 0
      Top = 200
      Width = 588
      Height = 10
      Cursor = crVSplit
      Align = alTop
      MinSize = 75
      OnMoved = pSHNetscapeSplitter1Moved
      Maximized = False
      Minimized = False
      ButtonCursor = crDefault
      ArrowColor = clBlack
    end
    object Panel2: TPanel
      Left = 0
      Top = 210
      Width = 588
      Height = 216
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = '(nothing selected)'
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 588
      Height = 200
      Align = alTop
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = 'Panel1'
      TabOrder = 1
      object Tree: TVirtualStringTree
        Left = 1
        Top = 21
        Width = 586
        Height = 178
        Align = alClient
        BorderStyle = bsNone
        ButtonFillMode = fmShaded
        CheckImageKind = ckXP
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.MainColumn = -1
        Header.Options = [hoColumnResize, hoDrag]
        HintAnimation = hatNone
        HintMode = hmHint
        IncrementalSearch = isAll
        Indent = 12
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus]
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
        TreeOptions.StringOptions = [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange]
        Columns = <>
      end
      object Panel3: TPanel
        Left = 1
        Top = 1
        Width = 586
        Height = 20
        Align = alTop
        Alignment = taLeftJustify
        Caption = ' Navigator'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Images = MainForm.ImageList1
    Left = 8
    Top = 56
    object est1: TMenuItem
      Caption = 'Test'
    end
  end
  object ActionList1: TActionList
    Images = MainForm.ImageList1
    Left = 176
    Top = 50
  end
  object PopupMenu2: TPopupMenu
    Images = MainForm.ImageList1
    Left = 8
    Top = 88
  end
end
