inherited ObjectListForm: TObjectListForm
  Left = 296
  Top = 132
  ActiveControl = Edit1
  Caption = 'ObjectListForm'
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlClient: TPanel
    object Bevel4: TBevel
      Left = 0
      Top = 23
      Width = 494
      Height = 2
      Align = alTop
      Shape = bsSpacer
    end
    object Panel1: TPanel
      Left = 0
      Top = 25
      Width = 494
      Height = 300
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = 'Panel1'
      TabOrder = 1
      object Tree: TVirtualStringTree
        Left = 1
        Top = 1
        Width = 492
        Height = 298
        Align = alClient
        BorderStyle = bsNone
        ButtonFillMode = fmShaded
        Header.AutoSizeIndex = -1
        Header.Font.Charset = RUSSIAN_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
        Header.Style = hsFlatButtons
        HintAnimation = hatNone
        HintMode = hmTooltip
        IncrementalSearch = isAll
        Indent = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedSelection]
        TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
        Columns = <
          item
            Position = 0
            Width = 200
            WideText = 'Name'
          end
          item
            Position = 1
            Width = 292
            WideText = 'Type'
          end>
      end
    end
    object ToolBar1: TToolBar
      Left = 0
      Top = 0
      Width = 494
      Height = 23
      AutoSize = True
      ButtonHeight = 21
      Caption = 'ToolBar1'
      EdgeBorders = []
      TabOrder = 0
      OnResize = ToolBar1Resize
      object Edit1: TEdit
        Left = 0
        Top = 2
        Width = 121
        Height = 21
        TabOrder = 0
        OnChange = Edit1Change
      end
    end
  end
end
