object pSHDemoMainForm: TpSHDemoMainForm
  Left = 182
  Top = 163
  Width = 696
  Height = 480
  Caption = 'pSHDemoMainForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 480
    Top = 16
    Width = 149
    Height = 13
    Caption = 'Select SQL Dialect to Highlight:'
  end
  object Label2: TLabel
    Left = 484
    Top = 68
    Width = 61
    Height = 13
    Caption = 'Table names'
  end
  object Label3: TLabel
    Left = 484
    Top = 340
    Width = 32
    Height = 13
    Caption = 'Label3'
  end
  object ComboBox1: TComboBox
    Left = 480
    Top = 36
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = 'InterBase 4'
    OnChange = ComboBox1Change
    Items.Strings = (
      'InterBase 4'
      'InterBase 5'
      'InterBase 6'
      'InterBase 6.5'
      'InterBase 7'
      'Firebird 1'
      'Firebird 1.5'
      '')
  end
  object Memo1: TMemo
    Left = 480
    Top = 88
    Width = 165
    Height = 141
    Lines.Strings = (
      'M_DRUGS'
      'O_ORGANIZATION'
      'PS_PROPOSE')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 480
    Top = 236
    Width = 75
    Height = 25
    Caption = 'Update'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 480
    Top = 300
    Width = 97
    Height = 25
    Caption = 'Word at cursor'
    TabOrder = 3
    OnClick = Button2Click
  end
  object DBGridEh1: TDBGridEh
    Left = 584
    Top = 260
    Width = 320
    Height = 120
    Hint = 'htContext'
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        EditButtons = <>
        Footers = <>
      end>
  end
  object addBTSynEdit1: TaddBTSynEdit
    Left = 16
    Top = 8
    Width = 405
    Height = 401
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 5
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Highlighter = addBTHighlighter1
    Lines.Strings = (
      'FIRST'
      'BOOLEAN'
      'SELECT'
      'ROWS'
      'SAVEPOINT'
      'CURRENT_CONNECTION'
      ''
      'SELECT * FROM M_DRUGS'
      ''
      'SELECT P.IS'
      'FROM PS_PROPOSE P'
      '')
    BottomEdgeVisible = True
    BottomEdgeColor = clSilver
  end
  object addBTHighlighter1: TaddBTHighlighter
    DefaultFilter = 'SQL Files (*.sql)|*.sql'
    CustomStringsAttri.Background = clNone
    CustomStringsAttri.Foreground = clNone
    CustomStringsAttri.Style = [fsBold]
    TableNameAttri.Foreground = clBlue
    TableNameAttri.Style = [fsBold]
    SQLDialect = sqlInterbase
    SQLSubDialect = 3
    Left = 636
    Top = 36
  end
  object addBTCompletionProposal1: TaddBTCompletionProposal
    Options = [scoLimitToMatchedText, scoUseInsertList, scoUsePrettyText, scoEndCharCompletion, scoCompleteWithTab, scoCompleteWithEnter]
    EndOfTokenChr = '()[]. '
    TriggerChars = '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <
      item
        BiggestWord = 'CONSTRUCTOR'
      end>
    ItemHeight = 16
    ShortCut = 16416
    Left = 480
    Top = 376
  end
  object addBTAutoComplete1: TaddBTAutoComplete
    CaseSQLCode = ccLower
    EndOfTokenChr = '()[]. '
    ShortCut = 8224
    Left = 452
    Top = 248
  end
end
