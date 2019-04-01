object ibSHUserManagerForm: TibSHUserManagerForm
  Left = 263
  Top = 162
  Width = 696
  Height = 480
  ActiveControl = Tree
  Caption = 'ibSHUserManagerForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Tree: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 688
    Height = 453
    Align = alClient
    BorderStyle = bsNone
    ButtonFillMode = fmShaded
    Header.AutoSizeIndex = 1
    Header.Font.Charset = RUSSIAN_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    Header.Style = hsFlatButtons
    HintAnimation = hatNone
    HintMode = hmTooltip
    IncrementalSearch = isAll
    Indent = 0
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
        Width = 25
        WideText = '#'
      end
      item
        Position = 1
        Width = 200
        WideText = 'User Name'
      end
      item
        Position = 2
        Width = 120
        WideText = 'First Name'
      end
      item
        Position = 3
        Width = 120
        WideText = 'Middle Name'
      end
      item
        Position = 4
        Width = 120
        WideText = 'Last Name'
      end
      item
        Position = 5
        Width = 30
        WideText = 'AC'
      end>
  end
end
