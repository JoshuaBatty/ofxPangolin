object MainForm: TMainForm
  Left = 663
  Top = 345
  Width = 286
  Height = 314
  Caption = 'MIDI IN of BEYOND'
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
  object lblCmd: TLabel
    Left = 8
    Top = 48
    Width = 31
    Height = 13
    Caption = 'lblCmd'
  end
  object lblData1: TLabel
    Left = 8
    Top = 88
    Width = 39
    Height = 13
    Caption = 'lblData1'
  end
  object lblData2: TLabel
    Left = 8
    Top = 128
    Width = 39
    Height = 13
    Caption = 'lblData2'
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 34
    Height = 13
    Caption = 'Device'
  end
  object pnStatus: TPanel
    Left = 0
    Top = 236
    Width = 270
    Height = 20
    Align = alBottom
    Alignment = taRightJustify
    BevelOuter = bvLowered
    TabOrder = 0
  end
  object sbCmd: TScrollBar
    Left = 8
    Top = 64
    Width = 257
    Height = 17
    Max = 255
    Min = 128
    PageSize = 0
    Position = 128
    TabOrder = 1
    OnChange = sbCmdChange
  end
  object sbData1: TScrollBar
    Left = 8
    Top = 104
    Width = 257
    Height = 17
    Max = 127
    PageSize = 0
    TabOrder = 2
    OnChange = sbCmdChange
  end
  object sbData2: TScrollBar
    Left = 8
    Top = 144
    Width = 257
    Height = 17
    Max = 127
    PageSize = 0
    TabOrder = 3
    OnChange = sbCmdChange
  end
  object cbDevice: TComboBox
    Left = 8
    Top = 24
    Width = 257
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 4
    Text = 'As MIDI IN 1'
    Items.Strings = (
      'As MIDI IN 1'
      'As MIDI IN 2'
      'As MIDI IN 3'
      'As MIDI IN 4')
  end
  object cbOnsend: TCheckBox
    Left = 8
    Top = 176
    Width = 249
    Height = 17
    Caption = 'Send on slider change'
    TabOrder = 5
  end
  object bbSend: TButton
    Left = 8
    Top = 200
    Width = 257
    Height = 25
    Caption = 'Send to BEYOND'
    TabOrder = 6
    OnClick = bbSendClick
  end
  object MainMenu1: TMainMenu
    Left = 184
    Top = 176
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
    Left = 152
    Top = 176
  end
end
