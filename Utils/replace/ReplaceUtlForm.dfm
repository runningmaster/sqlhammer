object Form1: TForm1
  Left = 318
  Top = 177
  Width = 600
  Height = 501
  Caption = 'ReplaceUtl'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 592
    Height = 432
    ActivePage = tsFiles
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    MultiLine = True
    ParentFont = False
    TabOrder = 0
    TabPosition = tpLeft
    object tsFiles: TTabSheet
      Caption = 'Files'
      ImageIndex = 2
      object PageControl2: TPageControl
        Left = 0
        Top = 81
        Width = 564
        Height = 343
        ActivePage = tsFilesTypes
        Align = alClient
        TabOrder = 0
        object tsFilesTypes: TTabSheet
          Caption = 'Files Types'
          object lbFilesTypes: TListBox
            Left = 0
            Top = 0
            Width = 556
            Height = 312
            Align = alClient
            ItemHeight = 16
            PopupMenu = pmFilesTypes
            TabOrder = 0
          end
        end
        object tsFilesList: TTabSheet
          Caption = 'Files List'
          ImageIndex = 1
          object lbFiles: TListBox
            Left = 0
            Top = 0
            Width = 556
            Height = 312
            Align = alClient
            ItemHeight = 16
            PopupMenu = pmFilesList
            TabOrder = 0
          end
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 564
        Height = 81
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          564
          81)
        object chbScanSubFolders: TCheckBox
          Left = 8
          Top = 56
          Width = 177
          Height = 17
          Caption = 'Scan Subfolders'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = DoSchemaChange
        end
        object ledRootPath: TLabeledEdit
          Left = 8
          Top = 24
          Width = 517
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 21
          EditLabel.Height = 16
          EditLabel.Caption = 'Dir'
          EditLabel.Font.Charset = DEFAULT_CHARSET
          EditLabel.Font.Color = clWindowText
          EditLabel.Font.Height = -13
          EditLabel.Font.Name = 'MS Sans Serif'
          EditLabel.Font.Style = [fsBold]
          EditLabel.ParentFont = False
          TabOrder = 2
          OnChange = DoSchemaChange
        end
        object btnBrowse: TButton
          Left = 533
          Top = 24
          Width = 25
          Height = 25
          Caption = '...'
          TabOrder = 1
          OnClick = btnBrowseClick
        end
      end
    end
    object tsRules: TTabSheet
      Caption = 'Rules'
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 564
        Height = 424
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
        OnChange = DoSchemaChange
      end
    end
    object tsReplace: TTabSheet
      Caption = 'Replace'
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 564
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
      end
      object Memo1: TMemo
        Left = 0
        Top = 41
        Width = 564
        Height = 383
        Align = alClient
        Lines.Strings = (
          '')
        ScrollBars = ssBoth
        TabOrder = 1
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 432
    Width = 592
    Height = 23
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    Visible = False
    object ProgressBar1: TProgressBar
      Left = 23
      Top = 5
      Width = 568
      Height = 15
      TabOrder = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 64
    Top = 128
    object miSchema: TMenuItem
      Caption = 'Schema'
      object New1: TMenuItem
        Action = acSchemaNew
      end
      object Load1: TMenuItem
        Action = acSchemaLoad
      end
      object Save1: TMenuItem
        Action = acSchemaSave
      end
      object SaveAs1: TMenuItem
        Action = acSchemaSaveAs
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = acSchemaExit
      end
    end
    object Files1: TMenuItem
      Caption = 'Files'
      object AddFilesTypes1: TMenuItem
        Action = acFilesAddFilesTypes
      end
      object DeleteType1: TMenuItem
        Action = acFilesDelFileType
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object acFilesAddFile1: TMenuItem
        Action = acFilesAddFiles
      end
      object acFilesDeleteFile1: TMenuItem
        Action = acFilesDeleteFile
      end
    end
    object miRules: TMenuItem
      Caption = 'Rules'
      object AutoCreate1: TMenuItem
        Action = acRulesAddRules
      end
      object DeleteRule1: TMenuItem
        Action = acRulesDeleteRule
      end
    end
    object miReplace: TMenuItem
      Caption = 'Replace'
      object DoIt1: TMenuItem
        Action = acReplaceDoIt
      end
    end
  end
  object ActionList1: TActionList
    Left = 328
    Top = 128
    object acSchemaNew: TAction
      Caption = 'New Schema'
      ShortCut = 16462
      OnExecute = acSchemaNewExecute
    end
    object acSchemaLoad: TAction
      Caption = 'Load Schema'
      ShortCut = 16460
      OnExecute = acSchemaLoadExecute
    end
    object acSchemaSave: TAction
      Caption = 'Save Schema'
      ShortCut = 16467
      OnExecute = acSchemaSaveExecute
    end
    object acSchemaSaveAs: TAction
      Caption = 'Save Schema As'
      ShortCut = 24659
      OnExecute = acSchemaSaveAsExecute
    end
    object acSchemaExit: TAction
      Caption = 'Exit'
      ShortCut = 27
      OnExecute = acSchemaExitExecute
    end
    object acFilesAddFilesTypes: TAction
      Caption = 'Add Files Types'
      OnExecute = acFilesAddFilesTypesExecute
    end
    object acFilesDelFileType: TAction
      Caption = 'Delete File Type'
      OnExecute = acFilesDelFileTypeExecute
    end
    object acFilesAddFiles: TAction
      Caption = 'Add Files'
      OnExecute = acFilesAddFilesExecute
    end
    object acFilesDeleteFile: TAction
      Caption = 'Delete File'
      OnExecute = acFilesDeleteFileExecute
    end
    object acRulesAddRules: TAction
      Caption = 'Add Rules'
      ShortCut = 16451
      OnExecute = acRulesAddRulesExecute
    end
    object acRulesDeleteRule: TAction
      Caption = 'Delete Rule'
      OnExecute = acRulesDeleteRuleExecute
    end
    object acReplaceDoIt: TAction
      Caption = 'Do It!'
      ShortCut = 16466
      OnExecute = acReplaceDoItExecute
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'rcf'
    Filter = 'Replace Schemas Files (*.rsf)|*.rsf'
    Left = 400
    Top = 128
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'rcf'
    Filter = 'Replace Schemas Files (*.rsf)|*.rsf'
    Left = 480
    Top = 128
  end
  object pmFilesTypes: TPopupMenu
    Left = 64
    Top = 192
    object AddFilesTypes2: TMenuItem
      Action = acFilesAddFilesTypes
    end
    object DeleteType2: TMenuItem
      Action = acFilesDelFileType
    end
  end
  object pmFilesList: TPopupMenu
    Left = 128
    Top = 192
    object AddFiles1: TMenuItem
      Action = acFilesAddFiles
    end
    object DeleteFile1: TMenuItem
      Action = acFilesDeleteFile
    end
  end
end
