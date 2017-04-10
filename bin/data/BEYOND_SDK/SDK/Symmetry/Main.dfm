object MainForm: TMainForm
  Left = 555
  Top = 435
  Width = 455
  Height = 400
  Caption = 'Symmetry'
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
  PixelsPerInch = 96
  TextHeight = 13
  object pbMain: TPaintBox
    Left = 72
    Top = 24
    Width = 105
    Height = 105
    OnMouseDown = pbMainMouseDown
    OnMouseMove = pbMainMouseMove
    OnPaint = pbMainPaint
  end
  object pnStatus: TPanel
    Left = 0
    Top = 322
    Width = 439
    Height = 20
    Align = alBottom
    Alignment = taRightJustify
    BevelOuter = bvLowered
    TabOrder = 0
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
  object tmAction: TTimer
    Interval = 50
    Left = 8
    Top = 40
  end
end
