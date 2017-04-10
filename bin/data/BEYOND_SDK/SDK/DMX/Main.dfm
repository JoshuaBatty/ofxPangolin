object MainForm: TMainForm
  Left = 581
  Top = 359
  Width = 801
  Height = 297
  Caption = 'DMX demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    785
    239)
  PixelsPerInch = 96
  TextHeight = 13
  object pnStatus: TPanel
    Left = 0
    Top = 219
    Width = 785
    Height = 20
    Align = alBottom
    Alignment = taRightJustify
    BevelOuter = bvLowered
    TabOrder = 0
  end
  object sbMain: TScrollBar
    Left = 8
    Top = 8
    Width = 17
    Height = 201
    Anchors = [akLeft, akTop, akBottom]
    Kind = sbVertical
    Max = 255
    PageSize = 0
    Position = 255
    TabOrder = 1
    OnChange = sbMainChange
  end
  object MainMenu1: TMainMenu
    Left = 40
    Top = 8
    object Help1: TMenuItem
      Caption = 'Help'
      object mnStartBEYOND: TMenuItem
        Caption = 'Start BEYOND...'
        OnClick = mnStartBEYONDClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnAbout: TMenuItem
        Caption = 'About...'
        OnClick = mnAboutClick
      end
    end
  end
  object tmStatus: TTimer
    Enabled = False
    OnTimer = tmStatusTimer
    Left = 8
    Top = 8
  end
end
