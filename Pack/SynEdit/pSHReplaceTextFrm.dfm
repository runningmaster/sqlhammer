inherited pSHReplaceTextForm: TpSHReplaceTextForm
  Caption = 'Replace Text'
  ClientHeight = 305
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited bvlLeft: TBevel
    Height = 263
  end
  inherited bvlRight: TBevel
    Height = 263
  end
  inherited bvlBottom: TBevel
    Top = 267
  end
  inherited pnlOKCancelHelp: TPanel
    Top = 271
    inherited Panel6: TPanel
      Left = 80
      Width = 330
      inherited btnOK: TButton
        Left = 88
        Caption = 'Replace &All'
        Default = False
        ModalResult = 10
      end
      inherited btnCancel: TButton
        Left = 168
      end
      inherited btnHelp: TButton
        Left = 248
      end
      object Button1: TButton
        Left = 8
        Top = 4
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 3
      end
    end
  end
  inherited pnlClient: TPanel
    Height = 263
    inherited lbFindText: TLabel
      Width = 59
      Caption = '&Text to Find:'
      FocusControl = cbFindText
    end
    object Label1: TLabel [2]
      Left = 8
      Top = 37
      Width = 65
      Height = 13
      Caption = '&Replace with:'
      FocusControl = cbReplaceText
    end
    inherited gbOptions: TGroupBox
      Top = 62
      Height = 115
      TabOrder = 2
      object cbPromtOnReplace: TCheckBox
        Left = 8
        Top = 89
        Width = 180
        Height = 17
        Caption = '&Prompt on replace'
        TabOrder = 3
        OnClick = cbRegularExpressionsClick
      end
    end
    inherited rgDirection: TRadioGroup
      Top = 62
      Height = 115
      TabOrder = 3
    end
    inherited rgScope: TRadioGroup
      Top = 185
      TabOrder = 4
    end
    inherited rgOrigin: TRadioGroup
      Top = 185
      TabOrder = 5
    end
    object cbReplaceText: TComboBox
      Left = 80
      Top = 33
      Width = 285
      Height = 21
      ItemHeight = 13
      TabOrder = 1
    end
  end
end
