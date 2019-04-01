object ConnectionObjectsPageForm: TConnectionObjectsPageForm
  Left = 292
  Top = 125
  Width = 500
  Height = 480
  Caption = 'ConnectionObjectsPageForm'
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
    Width = 492
    Height = 453
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 492
      Height = 453
      ActivePage = tsScheme
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HotTrack = True
      ParentFont = False
      TabOrder = 0
      TabStop = False
      object tsScheme: TTabSheet
        Caption = 'Scheme'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        object Bevel1: TBevel
          Left = 0
          Top = 0
          Width = 484
          Height = 4
          Align = alTop
          Shape = bsSpacer
        end
        object Bevel8: TBevel
          Left = 0
          Top = 26
          Width = 484
          Height = 4
          Align = alTop
          Shape = bsSpacer
        end
        object Panel2: TPanel
          Left = 0
          Top = 30
          Width = 484
          Height = 395
          Align = alClient
          BevelInner = bvLowered
          BevelOuter = bvNone
          Caption = 'Panel1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object VirtualStringTree1: TVirtualStringTree
            Left = 1
            Top = 1
            Width = 482
            Height = 393
            Align = alClient
            BorderStyle = bsNone
            ButtonFillMode = fmShaded
            CheckImageKind = ckXP
            DragType = dtVCL
            DrawSelectionMode = smBlendedRectangle
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
            Indent = 12
            ParentFont = False
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
        end
        object ToolBar2: TToolBar
          Left = 0
          Top = 4
          Width = 484
          Height = 22
          AutoSize = True
          Caption = 'ToolBar2'
          EdgeBorders = []
          Flat = True
          TabOrder = 0
        end
      end
      object tsSystem: TTabSheet
        Caption = 'System'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ImageIndex = 1
        ParentFont = False
        object Bevel2: TBevel
          Left = 0
          Top = 0
          Width = 484
          Height = 4
          Align = alTop
          Shape = bsSpacer
        end
        object Bevel9: TBevel
          Left = 0
          Top = 26
          Width = 484
          Height = 4
          Align = alTop
          Shape = bsSpacer
        end
        object Panel3: TPanel
          Left = 0
          Top = 30
          Width = 484
          Height = 395
          Align = alClient
          BevelInner = bvLowered
          BevelOuter = bvNone
          Caption = 'Panel1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object VirtualStringTree2: TVirtualStringTree
            Left = 1
            Top = 1
            Width = 482
            Height = 393
            Align = alClient
            BorderStyle = bsNone
            ButtonFillMode = fmShaded
            CheckImageKind = ckXP
            DragType = dtVCL
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
            TabOrder = 0
            TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus]
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
            TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
            TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
            TreeOptions.StringOptions = [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange]
            Columns = <>
          end
        end
        object ToolBar3: TToolBar
          Left = 0
          Top = 4
          Width = 484
          Height = 22
          AutoSize = True
          Caption = 'ToolBar2'
          EdgeBorders = []
          Flat = True
          TabOrder = 0
        end
      end
      object tsFilter: TTabSheet
        Caption = 'Filter'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ImageIndex = 2
        ParentFont = False
        object Bevel3: TBevel
          Left = 0
          Top = 26
          Width = 484
          Height = 4
          Align = alTop
          Shape = bsSpacer
        end
        object Bevel7: TBevel
          Left = 0
          Top = 0
          Width = 484
          Height = 4
          Align = alTop
          Shape = bsSpacer
        end
        object Panel4: TPanel
          Left = 0
          Top = 30
          Width = 484
          Height = 395
          Align = alClient
          BevelInner = bvLowered
          BevelOuter = bvNone
          Caption = 'Panel1'
          TabOrder = 1
          object VirtualStringTree3: TVirtualStringTree
            Left = 1
            Top = 1
            Width = 482
            Height = 393
            Align = alClient
            BorderStyle = bsNone
            ButtonFillMode = fmShaded
            CheckImageKind = ckXP
            DragType = dtVCL
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
            TabOrder = 0
            TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus]
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
            TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
            TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
            TreeOptions.StringOptions = [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange]
            Columns = <>
          end
        end
        object ToolBar1: TToolBar
          Left = 0
          Top = 4
          Width = 484
          Height = 22
          AutoSize = True
          Caption = 'ToolBar1'
          EdgeBorders = []
          Flat = True
          Images = ImageList1
          TabOrder = 0
          OnResize = ToolBar1Resize
          object ComboBox1: TComboBox
            Left = 0
            Top = 0
            Width = 145
            Height = 21
            AutoComplete = False
            ItemHeight = 0
            TabOrder = 0
            Text = 'ComboBox1'
          end
        end
      end
      object tsInfo: TTabSheet
        Caption = 'Info'
        ImageIndex = 8
        object Bevel12: TBevel
          Left = 0
          Top = 0
          Width = 484
          Height = 4
          Align = alTop
          Shape = bsSpacer
        end
        object Panel8: TPanel
          Left = 0
          Top = 4
          Width = 484
          Height = 421
          Align = alClient
          BevelInner = bvLowered
          BevelOuter = bvNone
          Caption = 'Panel2'
          Constraints.MinHeight = 50
          TabOrder = 0
          object PropInspector: TELPropertyInspector
            Left = 1
            Top = 1
            Width = 482
            Height = 419
            PropKinds = [pkProperties, pkReadOnly]
            ReadOnly = True
            DefaultPropName = 'Alias'
            SortType = stNone
            Splitter = 90
            Align = alClient
            BorderStyle = bsNone
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            OnFilterProp = PropInspectorFilterProp
            OnGetEditorClass = PropInspectorGetEditorClass
          end
        end
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 204
    Top = 61
    object est1: TMenuItem
      Caption = 'Test'
    end
  end
  object ImageList1: TImageList
    Left = 244
    Top = 69
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000006600000066000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000006600000066000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000007790E0060F898000099000000660000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000007790E0060F898000099000000660000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000007790E0060F898000099000000660000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000007790E0060F898000099000000660000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E4E4FF009090FE000000FF000000FF009090FE00E4E4FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000007790E0060F898000099000000660000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009090FE00FFFFFF006666FF006666FF00FFFFFF009090FE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000007790E0060F898000099000000660000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF006666FF00FFFFFF00FFFFFF006666FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000007790E003CCC6B0026B9400000660000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF006666FF00FFFFFF00FFFFFF006666FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000007790E0043DC79002DC85D001CB53A000BA71800006600000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000007790E009090FE00FFFFFF006666FF006666FF00FFFFFF009090FE000066
      0000000000000000000000000000000000000000000000000000000000000000
      000007790E0054ED89003ED774002BC3560019B2320008A10F00009900000066
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000779
      0E0068FF9F00E4E4FF009090FE000000FF000000FF009090FE00E4E4FF000099
      0000006600000000000000000000000000000000000000000000000000000779
      0E0068FF9F0054ED89003ED774002BC3560017B22E0005A10A00009900000099
      0000006600000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000007790E0050E3
      810044D370002FB552001FA43E00129723000B8C0B000184000001840000008D
      0000008D0000006600000000000000000000000000000000000007790E0050E3
      810044D370002FB552001FA43E00129723000B8C0B000184000001840000008D
      0000008D00000066000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000007790E000B800F002780
      010027800100058F130042AF540054D8D70000D1D9000E99970036AB4E0037BA
      51002DAB45000F931D0000660000000000000000000007790E000B800F002780
      010027800100058F130042AF540054D8D70000D1D9000E99970036AB4E0037BA
      51002DAB45000F931D0000660000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000007790E00007900008DA00C00F0B3
      3800EDAB220095A5170017BC3E0070DE990051F0FF0000E1FF001BAFB7005AE0
      8F0044E16C0091D4B200239933000066000007790E00007900008DA00C00F0B3
      3800EDAB220095A5170017BC3E0070DE990051F0FF0000E1FF001BAFB7005AE0
      8F0044E16C0091D4B20023993300006600000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000007790E00E0B87B00F6EA
      B200EDD87C00DBA11700006E0A000066000061A3680051F0FF00007A6A00005F
      00005E8A5F00F97AF70056255300000000000000000007790E00E0B87B00F6EA
      B200EDD87C00DBA11700006E0A000066000061A3680051F0FF00007A6A00005F
      00005E8A5F00F97AF70056255300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E0C4A300FFFF
      F200F4E5A500DCA8230000000000000000000000000000000000000000000000
      0000FBAAFB00FF09FF00BD00BD00920492000000000000000000E0C4A300FFFF
      F200F4E5A500DCA8230000000000000000000000000000000000000000000000
      0000FBAAFB00FF09FF00BD00BD00920492000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D0B4
      8B00D1AA5B000000000000000000000000000000000000000000000000000000
      0000FBAAFB00FB48FB00A202A20000000000000000000000000000000000D0B4
      8B00D1AA5B000000000000000000000000000000000000000000000000000000
      0000FBAAFB00FB48FB00A202A200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FBAAFB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FBAAFB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FE7FFE7F00000000FC3FFC3F00000000
      FC3FFC3F00000000F81FFC3F00000000F81FFC3F00000000F81FFC3F00000000
      F81FF81F00000000F00FF00F00000000E007E00700000000C003C00300000000
      800180010000000000000000000000008001800100000000C3F0C3F000000000
      E7F1E7F100000000FFFBFFFB0000000000000000000000000000000000000000
      000000000000}
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2
    OnTimer = Timer1Timer
    Left = 188
    Top = 102
  end
end
