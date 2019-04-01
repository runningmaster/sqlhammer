object Form1: TForm1
  Left = 296
  Top = 204
  Width = 404
  Height = 175
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Make!'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 220
    Top = 16
    Width = 75
    Height = 25
    Caption = 'ReMake!'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 36
    Top = 88
    Width = 185
    Height = 25
    Caption = 'Make autocompletion'
    TabOrder = 2
    OnClick = Button3Click
  end
end
