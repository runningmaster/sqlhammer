object ibSHDataBlobForm: TibSHDataBlobForm
  Left = 96
  Top = 112
  Width = 696
  Height = 480
  ActiveControl = DBGridEh1
  Caption = 'ibSHDataBlobForm'
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
    Top = 100
    Width = 688
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Splitter3: TSplitter
    Left = 0
    Top = 350
    Width = 688
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object Panel1: TPanel
    Left = 0
    Top = 24
    Width = 688
    Height = 76
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    Constraints.MinHeight = 50
    TabOrder = 0
    object DBGridEh1: TDBGridEh
      Left = 0
      Top = 0
      Width = 688
      Height = 76
      Align = alClient
      BorderStyle = bsNone
      ColumnDefValues.Title.TitleButton = True
      DataSource = dsGrid
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 103
    Width = 688
    Height = 247
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 200
      Top = 0
      Height = 247
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 200
      Height = 247
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel3'
      TabOrder = 0
      object Tree: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 200
        Height = 247
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
            Width = 200
            WideText = 'BLOB Fields'
          end>
      end
    end
    object Panel4: TPanel
      Left = 203
      Top = 0
      Width = 485
      Height = 247
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Field not selected'
      TabOrder = 1
      object TEXTPanel: TPanel
        Left = 16
        Top = 36
        Width = 185
        Height = 41
        BevelOuter = bvNone
        Caption = 'TEXTPanel'
        TabOrder = 1
        object TextControl: TDBMemo
          Left = 0
          Top = 0
          Width = 185
          Height = 41
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Ctl3D = False
          DataSource = dsTextControl
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 0
          OnChange = AnyControlChange
        end
      end
      object RTFPanel: TPanel
        Left = 16
        Top = 84
        Width = 185
        Height = 41
        BevelOuter = bvNone
        Caption = 'RTFPanel'
        TabOrder = 2
        object RTFControl: TDBRichEdit
          Left = 0
          Top = 0
          Width = 185
          Height = 41
          Align = alClient
          BorderStyle = bsNone
          DataSource = dsRTFControl
          ScrollBars = ssBoth
          TabOrder = 0
          OnChange = AnyControlChange
        end
      end
      object SQLPanel: TPanel
        Left = 16
        Top = 132
        Width = 185
        Height = 41
        BevelOuter = bvNone
        Caption = 'SQLPanel'
        TabOrder = 3
        object SQLControl: TpSHDBSynEdit
          Left = 0
          Top = 0
          Width = 185
          Height = 41
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
            'SQLControl')
          ReadOnly = True
          BottomEdgeVisible = True
          BottomEdgeColor = clSilver
          ShowBeginEndRegions = False
          DataSource = dsSQLControl
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 485
        Height = 17
        Align = alTop
        Alignment = taLeftJustify
        Caption = '  Value'
        TabOrder = 0
      end
      object ImagePanel: TScrollBox
        Left = 16
        Top = 185
        Width = 185
        Height = 41
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        BorderStyle = bsNone
        TabOrder = 4
        object ImageControl: TImage
          Left = 0
          Top = 0
          Width = 185
          Height = 41
          Align = alClient
          AutoSize = True
          Center = True
        end
      end
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 24
    Align = alTop
    TabOrder = 2
    object ToolBar1: TToolBar
      Left = 1
      Top = 1
      Width = 686
      Height = 22
      AutoSize = True
      Caption = 'ToolBar1'
      EdgeBorders = []
      Flat = True
      Images = ImageList1
      TabOrder = 0
      Wrapable = False
      object DBNavigator1: TDBNavigator
        Left = 0
        Top = 0
        Width = 240
        Height = 22
        Flat = True
        Hints.Strings = (
          'First record'
          'Prior record'
          'Next record'
          'Last record'
          'Insert record'
          'Delete record'
          'Edit record'
          'Post edit'
          'Cancel edit'
          'Refresh current row')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object ToolButton1: TToolButton
        Left = 240
        Top = 0
        Width = 8
        Caption = 'ToolButton1'
        Style = tbsSeparator
      end
      object ComboBox1: TComboBox
        Left = 248
        Top = 0
        Width = 100
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = ComboBox1Change
        Items.Strings = (
          'TEXT'
          'RTF'
          'SQL'
          'PICTURE')
      end
    end
  end
  object Panel7: TPanel
    Left = 0
    Top = 353
    Width = 688
    Height = 100
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 3
    object pSHSynEdit2: TpSHSynEdit
      Tag = -1
      Left = 0
      Top = 0
      Width = 688
      Height = 100
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      PopupMenu = PopupMenuMessage
      TabOrder = 0
      BorderStyle = bsNone
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Options = [eoAutoIndent, eoDragDropEditing, eoGroupUndo, eoHideShowScrollbars, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoSpecialLineDefaultFg, eoTabsToSpaces, eoTrimTrailingSpaces]
      ReadOnly = True
      RightEdge = 0
      WordWrap = True
      BottomEdgeVisible = False
      BottomEdgeColor = clSilver
      ShowBeginEndRegions = False
    end
  end
  object dsTextControl: TDataSource
    Left = 416
    Top = 140
  end
  object dsGrid: TDataSource
    Left = 244
    Top = 61
  end
  object dsRTFControl: TDataSource
    Left = 420
    Top = 192
  end
  object dsSQLControl: TDataSource
    Left = 424
    Top = 236
  end
  object ImageList1: TImageList
    Left = 104
    Top = 94
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      00000000000000000000000000000000000000000000A5BDC40066626800655D
      6600655D6600675E6700665E6700665E6700665E6700665E6700655D6600665E
      6700665E6700675C610082433A00000000000000000000000000000000000000
      00000000000051527600151A6E000B116900080D64000D0D4D001D1E32005E5E
      6200000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A97E6000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000068DBF50004B7E30001BBE60001BB
      E60001BBE60005B4E10003BFE70010AED60004BBE50001BCE70001BBE60004B3
      DF0001BCE60002BEE6004A575E00000000000000000000000000000000007377
      AA00090C810000008B0000008C0000008C0000008B000001870000037E000106
      5E001D1D31000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8936F00CD976D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000055D6F80000C2EA0003DBFC0000DC
      FD0000DCFD0000E0FE00125D7200582E370048A6C00000E0FD0000DCFD0000DC
      FD0003E5FC0000CCF2004F6670000000000000000000000000007271AC000303
      900000008C00000090000000900000009D00000090000000900000008C000003
      7F000000760015132D0000000000000000000000000000000000000000000000
      000000000000000000000000000098674B00E7BE9800CC99710094796F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000008C4EA0003E4FB0000DF
      FF0000DEFF0000E2FF000C4657002307080028788B0000E3FF0000DEFF0001E2
      FF000DEFFD000BCBE80093716300000000000000000000000000040497000202
      8E004A4EC1001819A8000000AB000000AB000000AB0002029B00484BBD001112
      9A0000008C00000077002C2C3800000000000000000000000000000000000000
      000000000000A9806500B48C6B00C5A28700EBC49D00D4AB8900996747007944
      31008B7060000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000044D9F10001D9F80001E5
      FE0000DEFF0000DFFF0002DEF20002BFCC0001E6F80000DFFF0000DEFF000BF1
      FF0003E3FF00308FA2000000000000000000000000002325AE000000A5004444
      A800F0EFEF00C8CAEF001719B7000000AD000202AE00585ABD00F1F2F300BBBC
      DF000A0A920000008D0005085B0000000000000000000000000000000000C7A2
      8700D5B09100DFBEA200EBCCA700F8D5B200FEDFBE00F3CFAE00E0BC9F00D1A8
      8700A47458007A3E2D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000008D6F60001EE
      FE0001E2FF0000DFFF0000EAFE00336B770000ECFF0000E1FF0003EDFF0015F4
      FF0007D6EC008F756C000000000000000000000000000202A9000000AE002221
      A800B8B2B100F7F6F500C5C7EB001A1BB8006266CE00F5F6F000F1EFEC007174
      AD000404AA0000009600000082004F505B000000000000000000C6B29C00E6C8
      A900FBDDBE00FAE2C000A9674D00C6633400C9673900C3774E00FADAB900F6D5
      AE00DDBB9D00BD8A670068484000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000046DBF10003DC
      FA0001EFFF0000EDFF0008DCEC003536470001E8F80000E6FF0010F6FF0003E7
      FF00338899000000000000000000000000004C4DE6000000AE000000C5000000
      CD001C1CB700BCB5B400FBFBFA00DCDDF100F2F2F700F3F4ED006F71AE000303
      BD000000B0000000A90000009400302F4A0000000000CFBAA300E7CFBA00FEE8
      D100FFE7CE00FFE9CE00EBD8B800852D0C0089331500F0E0C000FFE3C800FFDF
      BE00F9D9B900DFBEA100A97053009B837A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000BD8
      F70001F1FE0000ECFF000AC9D10072444A0007DBE60003EBFF0010F9FF0006DB
      EF008C766D00000000000000000000000000181EC7000101C6000202D0000202
      D0000000CE002526BF00E7E3E700F8F8F800F9F9F900898ECA000404C9000000
      CA000000C6000000AF000000AC002D285700CFBAA300DBC8B700FCE9D700FFE9
      D300FFEBD500FFE8D100EDDEBF0095340A008F361800F8E7C800FFE6CC00FFE5
      CA00FFE5CC00F1D6BB00D7B69900804B3C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003CE2
      FB0004F0FE0005F9FF000D8DA6005524250013BBCF000CF9FF0008EEFF003090
      9E0000000000000000000000000000000000191FCE000C0CDA000909E5000505
      E6000202D3005E63D000F5F5F400F9F9F900F9F9F800C8CBF0001719CF000000
      CE000000CE000202C7000000AE0038375900DBC8B700EDDCD000FFEFDF00FFEF
      DE00FFEEDC00FFEEDC00EDDDCA00842D0D009B3A1800F7E9CD00FFE8D000FFE7
      CE00FFE7CE00FFE6CD00E8CFB7008A6059000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000008E1FD0010FBFF000E3B3F003B00070025687C0011FDFF0006E5EF008E6B
      5C00000000000000000000000000000000005051F1001212E5001717F4001111
      F3005E63D800F4F4F100F1F2EB008E93C400CFC9D100FBFAF900C5C7ED001B1B
      DA000707DE000202CD000A0DBC005B5B7A00DBC8B700F2E4DC00FFF2E500FFF1
      E200FFF1E200FFF2E500ECE0D2009533090096381900F7E9DA00FFEEDC00FFED
      D900FFECD700FFECD900ECD5BF008B635D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003DE4FC000BF3FD0006414700290106002E6F760007F9FF002BACAA000000
      000000000000000000000000000000000000000000001D1DF4002626FE00545A
      D300F0F2E700F5EFEB006F70BB000404E8001F20C200B8B1B100F7F6F600C4C4
      ED001212E7000E0EDC000F11C30000000000DBD1CE00F4E7E000FFF9F000FFF6
      EE00FFF6EE00F7E9E000A05941008D2C0C0083311E00F6EAE100FFF0E000FFEF
      DE00FFEFDF00FEF7E100F0DCC400977D6F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000007E6FD000DE9F1000AB7BA0011F0F50006ECF3007C6860000000
      000000000000000000000000000000000000000000003A3AFA003A3AFF005254
      E700C2BAC0007270B9000707ED000000EF000000EE001B1CCD00A8A4A6007272
      B9001E1EF5001111E2003941AA0000000000E0D6D400EDE2DF00FBFAF700FFF8
      F100FFF8F000FCFAF200E5DCDA00E6D9D600E6D4CC00FDF5EE00FFF5EA00FFF4
      E800FFF3E700FDF5EC00EADACC00D7B699000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003CE6F50007F8FE0019FEFF0011FDFF002AABAD00000000000000
      00000000000000000000000000000000000000000000000000003D3DFE005555
      FF006161EB005454F9003232FD001E1EF8001D1DF8002E2EFC004748E9003C3C
      FB002929FF002223E5000000000000000000E7E0DE00E7E4E100F6F0F000F9F7
      F700FFFCF600FFFAF700F1E8E400C3785800DBA07C00FCF8F200FFF7F000FEF8
      F100FBF9F600F7F1E700D5C4B700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000006F4FE002CFEFF0009EDF3007D6B6400000000000000
      0000000000000000000000000000000000000000000000000000000000005050
      FF007676FF009595FF009191FF007B7BFF007676FF006262FF005959FF004141
      FF003133F20000000000000000000000000000000000E7E0DE00EEE9E700F8F5
      F500F8F8F700F8F8F700D3BFBB006E1B0B00762F2000F0EAE500FAF9F800FAF9
      F800FAF5F300EDE1DA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000043F9FE0009F9FF004BD6D60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005A5AFF007676FF009595FF009696FF008383FF006262FF004747FF005352
      FA00000000000000000000000000000000000000000000000000E7E0DE00F1EE
      EE00F7F7F700F7F8F700F4F3F200C4B1AD00DAD1CA00F9FAF900FDFAFA00F5F3
      F000E7E0DE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A7FEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007575FF005E5EFF005D5DFF00777BFA00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E7E0DE00EEE9E700EEE9E700EEE9E700EEE9E700EEE9E700F2E9E7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF008001F80FFFBF00000001E007FF3F0000
      0001C003FE1F00008001C001F807000080038001E0030000C0038000C0010000
      C007000080000000E007000000000000E00F000000000000F00F000000000000
      F01F800100000000F81F800100000000F83FC00300010000FC3FE00780030000
      FC7FF00FC0070000FEFFFC3FF01F000000000000000000000000000000000000
      000000000000}
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 132
    Top = 94
  end
  object sdGrid: TSaveDialog
    DefaultExt = '*.xls'
    FileName = 'File1'
    Filter = 
      'Text files (*.txt)|*.txt|Comma separated values (*.csv)|*.csv|HT' +
      'ML file (*.htm)|*.htm|Rich Text Format (*.rtf)|*.rtf|Microsoft E' +
      'xcel Workbook (*.xls)|*.xls'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save Data'
    Left = 103
    Top = 122
  end
  object PrintDBGridEh1: TPrintDBGridEh
    DBGridEh = DBGridEh1
    Options = [pghFitGridToPageWidth, pghColored, pghRowAutoStretch, pghFitingByColWidths, pghOptimalColWidths]
    PageFooter.Font.Charset = DEFAULT_CHARSET
    PageFooter.Font.Color = clWindowText
    PageFooter.Font.Height = -11
    PageFooter.Font.Name = 'MS Sans Serif'
    PageFooter.Font.Style = []
    PageHeader.Font.Charset = DEFAULT_CHARSET
    PageHeader.Font.Color = clWindowText
    PageHeader.Font.Height = -11
    PageHeader.Font.Name = 'MS Sans Serif'
    PageHeader.Font.Style = []
    Units = MM
    Left = 160
    Top = 122
  end
  object PrintDBGridEh2: TPrintDBGridEh
    Options = [pghFitGridToPageWidth, pghColored, pghRowAutoStretch, pghFitingByColWidths, pghOptimalColWidths]
    PageFooter.Font.Charset = DEFAULT_CHARSET
    PageFooter.Font.Color = clWindowText
    PageFooter.Font.Height = -11
    PageFooter.Font.Name = 'MS Sans Serif'
    PageFooter.Font.Style = []
    PageHeader.Font.Charset = DEFAULT_CHARSET
    PageHeader.Font.Color = clWindowText
    PageHeader.Font.Height = -11
    PageHeader.Font.Name = 'MS Sans Serif'
    PageHeader.Font.Style = []
    Units = MM
    Left = 132
    Top = 122
  end
  object dsImageControl: TDataSource
    OnDataChange = dsImageControlDataChange
    Left = 424
    Top = 340
  end
  object odText: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt'
    Title = 'Open file'
    Left = 104
    Top = 149
  end
  object odRTF: TOpenDialog
    DefaultExt = 'rtf'
    Filter = 'RTF Files (*.rtf)|*.rtf'
    Title = 'Open file'
    Left = 104
    Top = 177
  end
  object odImage: TOpenPictureDialog
    DefaultExt = 'bmp'
    Title = 'Open file'
    Left = 104
    Top = 205
  end
  object sdText: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt'
    Title = 'Save file'
    Left = 132
    Top = 149
  end
  object sdRTF: TSaveDialog
    DefaultExt = 'rtf'
    Filter = 'RTF Files (*.rtf)|*.rtf'
    Title = 'Save file'
    Left = 132
    Top = 177
  end
  object sdImage: TSavePictureDialog
    DefaultExt = 'bmp'
    Title = 'Save file'
    Left = 132
    Top = 205
  end
  object PopupMenuMessage: TPopupMenu
    Left = 132
    Top = 354
    object pmiHideMessage: TMenuItem
      Caption = 'Hide Message'
      OnClick = pmiHideMessageClick
    end
  end
end
