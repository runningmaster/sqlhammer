object ibSHDMLExporterForm: TibSHDMLExporterForm
  Left = 0
  Top = 164
  Width = 792
  Height = 479
  ActiveControl = pSHSynEdit1
  Caption = 'ibSHDMLExporterForm'
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
    Width = 784
    Height = 452
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 0
      Top = 250
      Width = 784
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 784
      Height = 250
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel3'
      TabOrder = 0
      object Tree: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 784
        Height = 250
        Align = alClient
        BorderStyle = bsNone
        ButtonFillMode = fmShaded
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoDblClickResize, hoShowHint, hoVisible, hoAutoSpring]
        Header.Style = hsFlatButtons
        HintAnimation = hatNone
        HintMode = hmTooltip
        IncrementalSearch = isAll
        Indent = 12
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus, toDisableAutoscrollOnEdit]
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
        Columns = <
          item
            Position = 0
            Width = 290
            WideText = 'Available Tables'
          end
          item
            Position = 1
            Width = 100
            WideText = 'Data Type'
          end
          item
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
            Position = 2
            Width = 23
            WideText = 'W'
            WideHint = 'WHERE clause fields'
          end
          item
            Position = 3
            Width = 220
            WideText = 'Additional Conditions'
          end
          item
            Position = 4
            Width = 170
            WideText = 'Destination'
          end>
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 253
      Width = 784
      Height = 175
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'Panel4'
      TabOrder = 1
      object pSHSynEdit1: TpSHSynEdit
        Left = 0
        Top = 0
        Width = 784
        Height = 175
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
    object Panel1: TPanel
      Left = 0
      Top = 428
      Width = 784
      Height = 24
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      OnResize = Panel1Resize
      object Bevel1: TBevel
        Left = 0
        Top = 0
        Width = 4
        Height = 24
        Align = alLeft
        Shape = bsSpacer
      end
      object Image1: TImage
        Left = 4
        Top = 0
        Width = 22
        Height = 24
        Align = alLeft
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
        Caption = 'Extracting ...'
        TabOrder = 0
      end
      object Panel7: TPanel
        Left = 174
        Top = 0
        Width = 610
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
  end
  object ImageList1: TImageList
    Left = 331
    Top = 57
    Bitmap = {
      494C010105000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000DCDCDC00DCDC
      DC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDC
      DC00DCDCDC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000040404000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DCDCDC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007C7C7C00040404000000
      0000000000000000000004040400000000000000000000000000000000000000
      0000DCDCDC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000040404000000
      0000000000000404040004040400040404000000000000000000000000000000
      0000DCDCDC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007C7C7C00040404000000
      0000040404000404040004040400040404000404040000000000000000000000
      0000DCDCDC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007C7C7C00040404000000
      0000040404000404040000000000040404000404040004040400000000000000
      0000DCDCDC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007C7C7C00040404000000
      0000040404000000000000000000000000000404040004040400040404000000
      0000DCDCDC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007C7C7C00040404000000
      0000000000000000000000000000000000000000000004040400040404000000
      0000DCDCDC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007C7C7C00040404000000
      0000000000000000000000000000000000000000000000000000040404000000
      0000DCDCDC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007C7C7C00040404000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DCDCDC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007C7C7C00040404000404
      0400040404000404040004040400040404000404040004040400040404000404
      0400DCDCDC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007C7C7C007C7C7C007C7C
      7C007C7C7C007C7C7C007C7C7C007C7C7C007C7C7C007C7C7C007C7C7C008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000B80000005E000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CC680200000000000000000000000000CC680200CC680200CC680200CC68
      0200CC6802000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000B8000000CD0000005E0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF9B9B00FF9B9B00FF9B9B00000000000000000000000000FF9B9B00FF9B
      9B00FF9B9B000000000000000000000000000000000000000000000000000000
      0000CC680200CC680200CC680200CD690400CC680200FFFFFF00FFFFFF00FFFF
      FF00CC6802000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000B8000000DC000000CD0000005E00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008800
      00008800000088000000FF9B9B00000000000000000088000000880000008800
      0000FF9B9B000000000000000000000000000000000000000000000000000000
      0000CC680200000000000000000000000000CC680200CC680200CC680200CC68
      0200CC6802000000000000000000000000000000000080808000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC0000000000000000000000000000000000000000000000000000000
      000000B8000000E7000000DC000000CD0000005E000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000000000000000000000000000000000
      0000CC6802000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0DCC0000000000000000000000000000000000000000000000000000000
      000000B8000000F1000000E7000000DC000000CD0000005E0000000000000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000000000000000000000000000000000
      0000CC680200000000000000000000000000CC680200CC680200CC680200CC68
      0200CC6802000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0DCC0000000000000000000000000000000000000000000000000000000
      000000B8000000FC000000F1000000E7000000DC000000CD0000005E00000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000000000000000000000000000000000
      0000CC680200CC680200CC680200CC680200CC680200FFFFFF00FFFFFF00FFFF
      FF00CC6802000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0DCC0000000000000000000000000000000000000000000000000000000
      000000B800000DFE0D0000FC000000F1000000E7000000DC000000CD0000005E
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000000000000000000000000000000000
      0000CC680200000000000000000000000000CC680200CC680200CC680200CC68
      0200CC6802000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0DCC0000000000000000000000000000000000000000000000000000000
      000000B8000017FF17000DFE0D0000FC000000F1000000E7000000DC000000AD
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000000000000000000000000000000000
      0000CC6802000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0DCC0000000000000000000000000000000000000000000000000000000
      000000B8000027FF270017FF17000DFE0D0000FC000000F1000000AD00000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000000000000000000000000000000000
      0000CC680200000000000000000000000000CC680200CC680200CC680200CC68
      0200CC6802000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0DCC0000000000000000000000000000000000000000000000000000000
      000000B8000031FF310027FF270017FF17000DFE0D0000AD0000000000000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000000000000000000000000000000000
      0000CC680200CC680200CC680200CC680200CC680200FFFFFF00FFFFFF00FFFF
      FF00CC6802000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0DCC0000000000000000000000000000000000000000000000000000000
      000000B8000041FF410031FF310027FF270000AD000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000000000000000000000000000000000
      0000CC680200000000000000000000000000CC680200CC680200CC680200CC68
      0200CC6802000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0DCC0000000000000000000000000000000000000000000000000000000
      000000B800004CFE4C0041FF410000AD00000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000FF9B9B000000000000000000FF6B6B00FE5151008800
      0000FF9B9B000000000000000000000000000000000000000000CC680200CC68
      0200CC680200CC680200CC680200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0DCC0000000000000000000000000000000000000000000000000000000
      000000B800005CFF5C0000AD0000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF6B
      6B00FE51510088000000000000000000000000000000FF6B6B00FE5151008800
      0000000000000000000000000000000000000000000000000000CC680200FFFF
      FF00FFFFFF00FFFFFF00CC680200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0DCC0000000000000000000000000000000000000000000000000000000
      000000B8000000AD000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CC680200CC68
      0200CC680200CC680200CC680200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFF000000000000FFFF000000000000
      FFFF00000000000080070000000000009FF70000000000009DF7000000000000
      98F7000000000000907700000000000092370000000000009717000000000000
      9F970000000000009FD70000000000009FF70000000000008007000000000000
      8007000000000000FFFF000000000000FFFFFFFFFFFFFFFFF3FFFFFFF707FFFF
      F1FFF1C7F007FFFFF0FFE187F7078007F07FE187F7FF9FF7F03FE187F7079FF7
      F01FE187F0079FF7F00FE187F7079FF7F00FE187F7FF9FF7F01FE187F7079FF7
      F03FE187F0079FF7F07FE187F7079FF7F0FFE187C1FF9FF7F1FFE38FC1FF8007
      F3FFFFFFC1FF8007FFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 305
    Top = 123
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'sql'
    Filter = 'SQL Files|*.sql'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'File for dumping'
    Left = 48
    Top = 86
  end
end