object BaseDialogForm: TBaseDialogForm
  Left = 192
  Top = 107
  Width = 510
  Height = 480
  Caption = 'BaseDialogForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object bvlLeft: TBevel
    Left = 0
    Top = 4
    Width = 4
    Height = 325
    Align = alLeft
    Shape = bsSpacer
  end
  object bvlTop: TBevel
    Left = 0
    Top = 0
    Width = 502
    Height = 4
    Align = alTop
    Shape = bsSpacer
  end
  object bvlRight: TBevel
    Left = 498
    Top = 4
    Width = 4
    Height = 325
    Align = alRight
    Shape = bsSpacer
  end
  object bvlBottom: TBevel
    Left = 0
    Top = 329
    Width = 502
    Height = 4
    Align = alBottom
    Shape = bsSpacer
  end
  object pnlOK: TPanel
    Left = 0
    Top = 413
    Width = 502
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Bevel3: TBevel
      Left = 0
      Top = 0
      Width = 502
      Height = 2
      Align = alTop
      Shape = bsTopLine
    end
    object Panel4: TPanel
      Left = 412
      Top = 2
      Width = 90
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnOK1: TButton
        Left = 8
        Top = 6
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
    end
  end
  object pnlOKCancelHelp: TPanel
    Left = 0
    Top = 333
    Width = 502
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 502
      Height = 2
      Align = alTop
      Shape = bsTopLine
    end
    object Panel6: TPanel
      Left = 253
      Top = 2
      Width = 249
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnOK3: TButton
        Left = 8
        Top = 6
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel2: TButton
        Left = 88
        Top = 6
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
      object btnHelp1: TButton
        Left = 168
        Top = 6
        Width = 75
        Height = 25
        Caption = 'Help'
        TabOrder = 2
      end
    end
  end
  object pnlOKCancel: TPanel
    Left = 0
    Top = 373
    Width = 502
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object Bevel2: TBevel
      Left = 0
      Top = 0
      Width = 502
      Height = 2
      Align = alTop
      Shape = bsTopLine
    end
    object Panel5: TPanel
      Left = 332
      Top = 2
      Width = 170
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnOK2: TButton
        Left = 8
        Top = 6
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel1: TButton
        Left = 88
        Top = 6
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object pnlClient: TPanel
    Left = 4
    Top = 4
    Width = 494
    Height = 325
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlClient'
    TabOrder = 0
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 120
    Top = 56
  end
end
