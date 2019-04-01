inherited RestoreConnectionForm: TRestoreConnectionForm
  Width = 401
  Height = 342
  ActiveControl = Memo1
  Caption = 'RestoreConnectionForm'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited bvlLeft: TBevel
    Height = 187
  end
  inherited bvlTop: TBevel
    Width = 393
  end
  inherited bvlRight: TBevel
    Left = 389
    Height = 187
  end
  inherited bvlBottom: TBevel
    Top = 191
    Width = 393
  end
  inherited pnlOK: TPanel
    Top = 275
    Width = 393
    inherited Bevel3: TBevel
      Width = 393
    end
    inherited Panel4: TPanel
      Left = 303
    end
  end
  inherited pnlOKCancelHelp: TPanel
    Top = 195
    Width = 393
    inherited Bevel1: TBevel
      Width = 393
    end
    inherited Panel6: TPanel
      Left = 144
    end
  end
  inherited pnlOKCancel: TPanel
    Top = 235
    Width = 393
    inherited Bevel2: TBevel
      Width = 393
    end
    inherited Panel5: TPanel
      Left = 223
    end
  end
  inherited pnlClient: TPanel
    Width = 385
    Height = 187
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 385
      Height = 44
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Image1: TImage
        Left = 4
        Top = 4
        Width = 32
        Height = 32
        AutoSize = True
        Picture.Data = {
          055449636F6E0000010001002020100000000000E80200001600000028000000
          2000000040000000010004000000000080020000000000000000000000000000
          0000000000000000000080000080000000808000800000008000800080800000
          80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
          FFFFFF0000000777777777777777777777777700000077777777777777777777
          777777700030000000000000000000000007777703BBBBBBBBBBBBBBBBBBBBBB
          BB8077773BBBBBBBBBBBBBBBBBBBBBBBBBB807773BBBBBBBBBBBBBBBBBBBBBBB
          BBBB07773BBBBBBBBBBBB8008BBBBBBBBBBB07703BBBBBBBBBBBB0000BBBBBBB
          BBB8077003BBBBBBBBBBB0000BBBBBBBBBB0770003BBBBBBBBBBB8008BBBBBBB
          BB807700003BBBBBBBBBBBBBBBBBBBBBBB077000003BBBBBBBBBBB0BBBBBBBBB
          B80770000003BBBBBBBBB808BBBBBBBBB07700000003BBBBBBBBB303BBBBBBBB
          8077000000003BBBBBBBB000BBBBBBBB0770000000003BBBBBBB80008BBBBBB8
          07700000000003BBBBBB30000BBBBBB077000000000003BBBBBB00000BBBBB80
          770000000000003BBBBB00000BBBBB07700000000000003BBBBB00000BBBB807
          7000000000000003BBBB00000BBBB0770000000000000003BBBB00000BBB8077
          00000000000000003BBB80008BBB077000000000000000003BBBBBBBBBB80770
          000000000000000003BBBBBBBBB07700000000000000000003BBBBBBBB807700
          0000000000000000003BBBBBBB0770000000000000000000003BBBBBB8077000
          00000000000000000003BBBBB077000000000000000000000003BBBB80700000
          000000000000000000003BB80000000000000000000000000000033300000000
          00000000F8000003F0000001C000000080000000000000000000000000000001
          000000018000000380000003C0000007C0000007E000000FE000000FF000001F
          F000001FF800003FF800003FFC00007FFC00007FFE0000FFFE0000FFFF0001FF
          FF0001FFFF8003FFFF8003FFFFC007FFFFC007FFFFE00FFFFFE01FFFFFF07FFF
          FFF8FFFF}
        Transparent = True
      end
      object Label1: TLabel
        Left = 48
        Top = 14
        Width = 157
        Height = 13
        Caption = 'Connection was lost to database:'
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 44
      Width = 385
      Height = 143
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 1
      object Memo1: TMemo
        Left = 1
        Top = 1
        Width = 383
        Height = 141
        TabStop = False
        Align = alClient
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  inherited ApplicationEvents1: TApplicationEvents
    Left = 168
    Top = 164
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 200
    Top = 164
  end
end
