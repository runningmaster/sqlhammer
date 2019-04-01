object pSHFindTextForm: TpSHFindTextForm
  Left = 394
  Top = 148
  ActiveControl = cbFindText
  BorderStyle = bsDialog
  Caption = 'Find Text'
  ClientHeight = 291
  ClientWidth = 410
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object bvlLeft: TBevel
    Left = 0
    Top = 4
    Width = 4
    Height = 249
    Align = alLeft
    Shape = bsSpacer
  end
  object bvlTop: TBevel
    Left = 0
    Top = 0
    Width = 410
    Height = 4
    Align = alTop
    Shape = bsSpacer
  end
  object bvlRight: TBevel
    Left = 406
    Top = 4
    Width = 4
    Height = 249
    Align = alRight
    Shape = bsSpacer
  end
  object bvlBottom: TBevel
    Left = 0
    Top = 253
    Width = 410
    Height = 4
    Align = alBottom
    Shape = bsSpacer
  end
  object pnlOKCancelHelp: TPanel
    Left = 0
    Top = 257
    Width = 410
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 410
      Height = 2
      Align = alTop
      Shape = bsTopLine
    end
    object Panel6: TPanel
      Left = 161
      Top = 2
      Width = 249
      Height = 32
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnOK: TButton
        Left = 8
        Top = 4
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel: TButton
        Left = 88
        Top = 4
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
      object btnHelp: TButton
        Left = 168
        Top = 4
        Width = 75
        Height = 25
        Caption = 'Help'
        TabOrder = 2
      end
    end
  end
  object pnlClient: TPanel
    Left = 4
    Top = 4
    Width = 402
    Height = 249
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lbFindText: TLabel
      Left = 8
      Top = 8
      Width = 56
      Height = 13
      Caption = '&Text to Find'
    end
    object sbInsertRegExp: TSpeedButton
      Left = 368
      Top = 4
      Width = 23
      Height = 22
      Caption = '<<'
      Enabled = False
      PopupMenu = pmRegExpr
      OnClick = sbInsertRegExpClick
    end
    object cbFindText: TComboBox
      Left = 80
      Top = 4
      Width = 285
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
    object gbOptions: TGroupBox
      Left = 4
      Top = 33
      Width = 194
      Height = 91
      Caption = ' Options '
      TabOrder = 1
      object cbCaseSensitive: TCheckBox
        Left = 8
        Top = 19
        Width = 180
        Height = 17
        Caption = '&Case sensitive'
        TabOrder = 0
      end
      object cbWholeWordsOnly: TCheckBox
        Left = 8
        Top = 42
        Width = 180
        Height = 17
        Caption = '&Whole words only'
        TabOrder = 1
      end
      object cbRegularExpressions: TCheckBox
        Left = 8
        Top = 65
        Width = 180
        Height = 17
        Caption = '&Regular expressions'
        TabOrder = 2
        OnClick = cbRegularExpressionsClick
      end
    end
    object rgDirection: TRadioGroup
      Left = 204
      Top = 33
      Width = 194
      Height = 91
      Caption = ' Direction '
      Ctl3D = True
      ItemIndex = 0
      Items.Strings = (
        'Forwar&d'
        '&Backward')
      ParentCtl3D = False
      TabOrder = 2
    end
    object rgScope: TRadioGroup
      Left = 4
      Top = 132
      Width = 194
      Height = 66
      Caption = ' Scope '
      ItemIndex = 0
      Items.Strings = (
        '&Global'
        '&Selected text')
      TabOrder = 3
    end
    object rgOrigin: TRadioGroup
      Left = 204
      Top = 132
      Width = 194
      Height = 66
      Caption = ' Origin '
      ItemIndex = 0
      Items.Strings = (
        '&Global'
        '&Selected text')
      TabOrder = 4
    end
  end
  object pmRegExpr: TPopupMenu
    Left = 332
    Top = 80
    object Beginofline1: TMenuItem
      Caption = 'Begin of line '#39'^'#39
      OnClick = pmRegExprItemClick
    end
    object Endofline1: TMenuItem
      Caption = 'End of line '#39'$'#39
      OnClick = pmRegExprItemClick
    end
    object Anyletterordigit1: TMenuItem
      Caption = 'Any symbol '#39'.'#39
      OnClick = pmRegExprItemClick
    end
    object Anyletterordigit2: TMenuItem
      Caption = 'Any letter or digit '#39'\w'#39
      OnClick = pmRegExprItemClick
    end
    object NoreletternoredigitW1: TMenuItem
      Caption = 'Nore letter nore digit '#39'\W'#39
      OnClick = pmRegExprItemClick
    end
    object Anydigit1: TMenuItem
      Caption = 'Any digit '#39'\d'#39
      OnClick = pmRegExprItemClick
    end
    object NotdigitD1: TMenuItem
      Caption = 'Not digit '#39'\D'#39
      OnClick = pmRegExprItemClick
    end
    object Anyspace1: TMenuItem
      Caption = 'Any space [ \t\n\r\f] '#39'\s'#39
      OnClick = pmRegExprItemClick
    end
    object NotspaceS1: TMenuItem
      Caption = 'Not space '#39'\S'#39
      OnClick = pmRegExprItemClick
    end
    object Edgeofwordb1: TMenuItem
      Caption = 'Edge of word '#39'\b'#39
      OnClick = pmRegExprItemClick
    end
    object NotedgeofwordB1: TMenuItem
      Caption = 'Not edge of word '#39'\B'#39
      OnClick = pmRegExprItemClick
    end
    object Hexx001: TMenuItem
      Caption = 'Hex '#39'\x00'#39
      OnClick = pmRegExprItemClick
    end
    object abt1: TMenuItem
      Caption = 'Tab '#39'\t'#39
      OnClick = pmRegExprItemClick
    end
    object Sybolset1: TMenuItem
      Caption = 'Symbol set '#39'[a-zA-Z]'#39
      OnClick = pmRegExprItemClick
    end
    object Repiter1: TMenuItem
      Caption = 'Repeaters '
      object Zeroormoretimes1: TMenuItem
        Caption = 'Zero or more times (greedy) '#39'*'#39
        OnClick = pmRegExprItemClick
      end
      object Oneormoretimes1: TMenuItem
        Caption = 'One or more times (greedy) '#39'+'#39
        OnClick = pmRegExprItemClick
      end
      object Zerooronetimes1: TMenuItem
        Caption = 'Zero or one times (greedy) '#39'?'#39
        OnClick = pmRegExprItemClick
      end
      object Exactlyntimesgreedyn1: TMenuItem
        Caption = 'Exactly n times (greedy) '#39'{n}'#39
        OnClick = pmRegExprItemClick
      end
      object Notlessthenntimesgreedyn1: TMenuItem
        Caption = 'Not less then n times (greedy) '#39'{n,}'#39
        OnClick = pmRegExprItemClick
      end
      object Fromntomtimesgreedyn1: TMenuItem
        Caption = 'From n to m times (greedy) '#39'{n,m}'#39
        OnClick = pmRegExprItemClick
      end
      object Fromntomtimesgreedynm1: TMenuItem
        Caption = 'Zero or more times '#39'*?'#39
        OnClick = pmRegExprItemClick
      end
      object Oneormoretimes2: TMenuItem
        Caption = 'One or more times '#39'+?'#39
        OnClick = pmRegExprItemClick
      end
      object Zerooronetimes2: TMenuItem
        Caption = 'Zero or one times '#39'??'#39
        OnClick = pmRegExprItemClick
      end
      object Exactlyntimesgreedyn2: TMenuItem
        Caption = 'Exactly n times '#39'{n}?'#39
        OnClick = pmRegExprItemClick
      end
      object Notlessthenntimesgreedyn2: TMenuItem
        Caption = 'Not less then n times (greedy) '#39'{n,}?'#39
        OnClick = pmRegExprItemClick
      end
      object Fromntomtimesgreedynm2: TMenuItem
        Caption = 'From n to m times (greedy) '#39'{n,m}?'#39
        OnClick = pmRegExprItemClick
      end
    end
    object Variantgrouptemplate1: TMenuItem
      Caption = 'Variant group template '#39'(|)'#39
      OnClick = pmRegExprItemClick
    end
  end
end
