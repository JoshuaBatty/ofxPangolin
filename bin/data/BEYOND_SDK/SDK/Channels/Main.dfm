object MainForm: TMainForm
  Left = 591
  Top = 351
  Width = 450
  Height = 417
  Caption = 'Channels demo'
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
    434
    359)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 129
    Height = 13
    Caption = 'First 10 BEYOND Channels'
  end
  object Label2: TLabel
    Left = 8
    Top = 288
    Width = 418
    Height = 42
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'HINT: Start BEYOND, open Channels tab on the right. Once you mov' +
      'e the slider int this paplication, channel in BEYOND will follow' +
      ' the value.'
    WordWrap = True
  end
  object pnStatus: TPanel
    Left = 0
    Top = 339
    Width = 434
    Height = 20
    Align = alBottom
    Alignment = taRightJustify
    BevelOuter = bvLowered
    TabOrder = 0
  end
  object sb0: TScrollBar
    Left = 8
    Top = 32
    Width = 418
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Max = 1000
    PageSize = 0
    TabOrder = 1
    OnChange = sb0Change
  end
  object sb1: TScrollBar
    Tag = 1
    Left = 8
    Top = 56
    Width = 418
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Max = 1000
    PageSize = 0
    TabOrder = 2
    OnChange = sb0Change
  end
  object sb2: TScrollBar
    Tag = 2
    Left = 8
    Top = 80
    Width = 418
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Max = 1000
    PageSize = 0
    TabOrder = 3
    OnChange = sb0Change
  end
  object sb3: TScrollBar
    Tag = 3
    Left = 8
    Top = 104
    Width = 418
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Max = 1000
    PageSize = 0
    TabOrder = 4
    OnChange = sb0Change
  end
  object sb4: TScrollBar
    Tag = 4
    Left = 8
    Top = 128
    Width = 418
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Max = 1000
    PageSize = 0
    TabOrder = 5
    OnChange = sb0Change
  end
  object sb5: TScrollBar
    Tag = 5
    Left = 8
    Top = 160
    Width = 418
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Max = 1000
    PageSize = 0
    TabOrder = 6
    OnChange = sb0Change
  end
  object sb6: TScrollBar
    Tag = 6
    Left = 8
    Top = 184
    Width = 418
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Max = 1000
    PageSize = 0
    TabOrder = 7
    OnChange = sb0Change
  end
  object sb7: TScrollBar
    Tag = 7
    Left = 8
    Top = 208
    Width = 418
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Max = 1000
    PageSize = 0
    TabOrder = 8
    OnChange = sb0Change
  end
  object sb8: TScrollBar
    Tag = 8
    Left = 8
    Top = 232
    Width = 418
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Max = 1000
    PageSize = 0
    TabOrder = 9
    OnChange = sb0Change
  end
  object sb9: TScrollBar
    Tag = 9
    Left = 8
    Top = 256
    Width = 418
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Max = 1000
    PageSize = 0
    TabOrder = 10
    OnChange = sb0Change
  end
  object MainMenu1: TMainMenu
    Left = 200
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
    Left = 168
    Top = 8
  end
end
