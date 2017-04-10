object MainForm: TMainForm
  Left = 610
  Top = 347
  Width = 455
  Height = 232
  Caption = 'Timecode demo'
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
    Top = 154
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
    object cbReadIn: TCheckBox
      Left = 8
      Top = 8
      Width = 201
      Height = 17
      Caption = 'Read incoming timecode of BEYOND'
      TabOrder = 0
      OnClick = cbReadInClick
    end
  end
  object pnOUT: TPanel
    Left = 0
    Top = 72
    Width = 439
    Height = 72
    Align = alTop
    TabOrder = 2
    object lblOut: TLabel
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
    object cbSendOut: TCheckBox
      Left = 8
      Top = 8
      Width = 225
      Height = 17
      Caption = 'Send timecode to BEYOND'
      TabOrder = 0
      OnClick = cbSendOutClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 400
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
    Left = 400
    Top = 40
  end
  object tmWork: TTimer
    Enabled = False
    Interval = 50
    OnTimer = tmWorkTimer
    Left = 400
    Top = 72
  end
end
