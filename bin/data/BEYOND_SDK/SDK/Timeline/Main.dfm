object MainForm: TMainForm
  Left = 608
  Top = 389
  Width = 455
  Height = 233
  Caption = 'Timeline demo'
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
  object pnStatus: TPanel
    Left = 0
    Top = 155
    Width = 439
    Height = 20
    Align = alBottom
    Alignment = taRightJustify
    BevelOuter = bvLowered
    TabOrder = 0
  end
  object pnIN: TPanel
    Left = 0
    Top = 0
    Width = 439
    Height = 72
    Align = alTop
    TabOrder = 1
    object lblIn: TLabel
      Left = 120
      Top = 32
      Width = 187
      Height = 33
      Caption = '00:00:00:00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 72
    Width = 439
    Height = 41
    Align = alTop
    TabOrder = 2
    object sbPlay: TSpeedButton
      Left = 8
      Top = 8
      Width = 80
      Height = 25
      Caption = 'Play'
      OnClick = sbPlayClick
    end
    object sbStop: TSpeedButton
      Left = 96
      Top = 8
      Width = 80
      Height = 25
      Caption = 'Stop'
      OnClick = sbStopClick
    end
    object sbOnline: TSpeedButton
      Left = 272
      Top = 8
      Width = 80
      Height = 25
      AllowAllUp = True
      GroupIndex = 3
      Caption = 'Show it now'
      OnClick = sbOnlineClick
    end
    object sbRestart: TSpeedButton
      Left = 184
      Top = 8
      Width = 80
      Height = 25
      Caption = 'Restart'
      OnClick = sbRestartClick
    end
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
  object tmTimePos: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tmTimePosTimer
    Left = 8
    Top = 40
  end
end
