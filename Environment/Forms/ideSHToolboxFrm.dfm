object ToolboxForm: TToolboxForm
  Left = 110
  Top = 209
  Width = 696
  Height = 480
  Caption = 'ToolboxForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pSHNetscapeSplitter1: TpSHNetscapeSplitter
    Left = 0
    Top = 43
    Width = 688
    Height = 10
    Cursor = crVSplit
    Align = alBottom
    MinSize = 1
    OnMoved = pSHNetscapeSplitter1Moved
    Maximized = False
    Minimized = False
    ButtonCursor = crDefault
    ArrowColor = clBlack
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 43
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = '(nothing selected)'
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 53
    Width = 688
    Height = 400
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    Caption = '(nothing selected)'
    TabOrder = 1
  end
end
