object ibSHDDLGrantorForm: TibSHDDLGrantorForm
  Left = 230
  Top = 208
  Width = 776
  Height = 481
  Caption = 'ibSHDDLGrantorForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 0
    Top = 338
    Width = 768
    Height = 2
    Align = alBottom
    Shape = bsSpacer
  end
  object Panel3: TPanel
    Left = 0
    Top = 360
    Width = 768
    Height = 70
    Align = alBottom
    TabOrder = 1
    OnResize = Panel7Resize
    object RadioGroup1: TRadioGroup
      Left = 4
      Top = 4
      Width = 80
      Height = 60
      Caption = ' Type '
      ItemIndex = 0
      Items.Strings = (
        'Grant'
        'Revoke')
      TabOrder = 0
    end
    object GroupBox1: TGroupBox
      Left = 182
      Top = 4
      Width = 350
      Height = 60
      Caption = ' Privileges '
      TabOrder = 2
      object Bevel1: TBevel
        Left = 229
        Top = 21
        Width = 104
        Height = 29
        Shape = bsFrame
      end
      object CheckBoxSelect: TCheckBox
        Left = 8
        Top = 16
        Width = 70
        Height = 17
        Caption = 'Select'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object CheckBoxDelete: TCheckBox
        Left = 8
        Top = 37
        Width = 70
        Height = 17
        Caption = 'Delete'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object CheckBoxUpdate: TCheckBox
        Left = 76
        Top = 37
        Width = 70
        Height = 17
        Caption = 'Update'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object CheckBoxInsert: TCheckBox
        Left = 76
        Top = 16
        Width = 70
        Height = 17
        Caption = 'Insert'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object CheckBoxReference: TCheckBox
        Left = 140
        Top = 16
        Width = 80
        Height = 17
        Caption = 'References'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
      object CheckBoxExecute: TCheckBox
        Left = 140
        Top = 37
        Width = 70
        Height = 17
        Caption = 'Execute'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
      object CheckBoxGrantOption: TCheckBox
        Left = 240
        Top = 27
        Width = 87
        Height = 17
        Caption = 'Grant Option'
        TabOrder = 6
      end
    end
    object RadioGroup2: TRadioGroup
      Left = 92
      Top = 4
      Width = 80
      Height = 60
      Caption = ' Range '
      ItemIndex = 1
      Items.Strings = (
        'All'
        'Current')
      TabOrder = 1
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 768
    Height = 338
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel4'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 220
      Top = 0
      Height = 338
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 220
      Height = 338
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel1'
      TabOrder = 0
      object PrivilegesForTree: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 220
        Height = 338
        Align = alClient
        BorderStyle = bsNone
        ButtonFillMode = fmShaded
        Header.AutoSizeIndex = -1
        Header.Font.Charset = RUSSIAN_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoDrag, hoVisible]
        Header.Style = hsFlatButtons
        HintAnimation = hatNone
        HintMode = hmTooltip
        IncrementalSearch = isAll
        Indent = 4
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
        TreeOptions.StringOptions = [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange]
        Columns = <
          item
            Position = 0
            Width = 220
            WideText = 'Privileges For'
          end>
      end
    end
    object Panel2: TPanel
      Left = 223
      Top = 0
      Width = 545
      Height = 338
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 1
      object GrantsOnTree: TVirtualStringTree
        Tag = 1
        Left = 0
        Top = 0
        Width = 545
        Height = 338
        Align = alClient
        BorderStyle = bsNone
        ButtonFillMode = fmShaded
        Header.AutoSizeIndex = 0
        Header.Font.Charset = RUSSIAN_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoDrag, hoShowHint, hoVisible]
        Header.Style = hsFlatButtons
        HintAnimation = hatNone
        HintMode = hmTooltip
        IncrementalSearch = isAll
        Indent = 12
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
        TreeOptions.StringOptions = [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange]
        Columns = <
          item
            Position = 0
            Width = 395
            WideText = 'Grants On'
          end
          item
            Position = 1
            Width = 25
            WideText = 'S'
            WideHint = 'Select'
          end
          item
            Position = 2
            Width = 25
            WideText = 'D'
            WideHint = 'Delete'
          end
          item
            Position = 3
            Width = 25
            WideText = 'I'
            WideHint = 'Insert'
          end
          item
            Position = 4
            Width = 25
            WideText = 'U'
            WideHint = 'Update'
          end
          item
            Position = 5
            Width = 25
            WideText = 'R'
            WideHint = 'References'
          end
          item
            Position = 6
            Width = 25
            WideText = 'E'
            WideHint = 'Execute'
          end>
      end
    end
  end
  object Panel7: TPanel
    Left = 0
    Top = 430
    Width = 768
    Height = 24
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    OnResize = Panel7Resize
    object ProgressBar1: TProgressBar
      Left = 8
      Top = 4
      Width = 150
      Height = 16
      Smooth = True
      TabOrder = 0
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 340
    Width = 768
    Height = 20
    Align = alBottom
    Alignment = taLeftJustify
    Caption = '  Run Options'
    TabOrder = 2
  end
end
