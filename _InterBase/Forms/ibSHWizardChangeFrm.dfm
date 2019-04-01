object ibSHWizardChangeForm: TibSHWizardChangeForm
  Left = 192
  Top = 107
  Width = 322
  Height = 194
  ActiveControl = RadioGroup1
  Caption = 'ibSHWizardChangeForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup1: TRadioGroup
    Left = 0
    Top = 0
    Width = 314
    Height = 167
    Align = alClient
    Caption = ' DB Object Types '
    Columns = 3
    Items.Strings = (
      'Domain'
      'Table'
      'Field'
      'Constraint'
      'Index'
      'View'
      'Procedure'
      'Trigger'
      'Generator'
      'Exception'
      'Function'
      'Filter'
      'Role')
    TabOrder = 0
    OnClick = RadioGroup1Click
  end
end
