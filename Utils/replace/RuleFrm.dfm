object RuleForm: TRuleForm
  Left = 294
  Top = 221
  BorderStyle = bsDialog
  Caption = 'Create Replace Rule'
  ClientHeight = 139
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  DesignSize = (
    342
    139)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 171
    Top = 105
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 259
    Top = 105
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object ledFrom: TLabeledEdit
    Left = 8
    Top = 24
    Width = 326
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 36
    EditLabel.Height = 16
    EditLabel.Caption = 'From'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -13
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    TabOrder = 0
  end
  object ledTo: TLabeledEdit
    Left = 8
    Top = 72
    Width = 326
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 20
    EditLabel.Height = 16
    EditLabel.Caption = 'To'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -13
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    TabOrder = 1
  end
  object chbWholeWords: TCheckBox
    Left = 8
    Top = 108
    Width = 129
    Height = 17
    Caption = 'Whole Words'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    State = cbChecked
    TabOrder = 4
  end
end
