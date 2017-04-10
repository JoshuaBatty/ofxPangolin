object MainForm: TMainForm
  Left = 628
  Top = 249
  Width = 383
  Height = 541
  Caption = 'Kinect demo'
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
    Left = 16
    Top = 40
    Width = 329
    Height = 401
    OnMouseDown = pbMainMouseDown
    OnMouseMove = pbMainMouseMove
    OnMouseUp = pbMainMouseUp
    OnPaint = pbMainPaint
  end
  object pnStatus: TPanel
    Left = 0
    Top = 463
    Width = 367
    Height = 20
    Align = alBottom
    Alignment = taRightJustify
    BevelOuter = bvLowered
    TabOrder = 0
  end
  object MainMenu1: TMainMenu
    Left = 40
    Top = 8
    object Object1: TMenuItem
      Caption = 'Object'
      object mnFirst: TMenuItem
        Caption = 'First'
        Checked = True
        GroupIndex = 1
        RadioItem = True
        OnClick = mnFirstClick
      end
      object mnSecond: TMenuItem
        Caption = 'Second'
        GroupIndex = 1
        RadioItem = True
        OnClick = mnSecondClick
      end
    end
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
