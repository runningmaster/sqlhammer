object pSHGotoLineNumberForm: TpSHGotoLineNumberForm
  Left = 409
  Top = 148
  ActiveControl = cbLineNumber
  BorderStyle = bsDialog
  Caption = 'Go to Line Number'
  ClientHeight = 87
  ClientWidth = 272
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
    Height = 45
    Align = alLeft
    Shape = bsSpacer
  end
  object bvlTop: TBevel
    Left = 0
    Top = 0
    Width = 272
    Height = 4
    Align = alTop
    Shape = bsSpacer
  end
  object bvlRight: TBevel
    Left = 268
    Top = 4
    Width = 4
    Height = 45
    Align = alRight
    Shape = bsSpacer
  end
  object bvlBottom: TBevel
    Left = 0
    Top = 49
    Width = 272
    Height = 4
    Align = alBottom
    Shape = bsSpacer
  end
  object pnlOKCancelHelp: TPanel
    Left = 0
    Top = 53
    Width = 272
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 272
      Height = 2
      Align = alTop
      Shape = bsTopLine
    end
    object Panel6: TPanel
      Left = 23
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
    Width = 264
    Height = 45
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 108
      Height = 13
      Caption = '&Enter new line number:'
    end
    object cbLineNumber: TComboBox
      Left = 152
      Top = 12
      Width = 101
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
  end
end
