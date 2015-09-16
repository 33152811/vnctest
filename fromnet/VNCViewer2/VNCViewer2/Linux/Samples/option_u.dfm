object Option_F: TOption_F
  Left = 251
  Top = 215
  Width = 445
  Height = 251
  HorzScrollBar.Range = 434
  VertScrollBar.Range = 241
  ActiveControl = rgEncoding
  Caption = 'Options'
  Color = clButton
  Font.CharSet = fcsLatin1
  Font.Color = clText
  Font.Height = 12
  Font.Name = 'Arial'
  Font.Pitch = fpVariable
  Font.Style = []
  ParentFont = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 20
  TextWidth = 7
  object GroupBox1: TGroupBox
    Left = 10
    Top = 8
    Width = 193
    Height = 191
    Caption = 'Format and Encoding'
    TabOrder = 0
    object rgEncoding: TRadioGroup
      Left = 15
      Top = 18
      Width = 161
      Height = 121
      Items.Strings = (
        'Hextile'
        'CoRRE'
        'RRE'
        'Copyrect'
        'RAW')
      Caption = 'Encoding'
      TabOrder = 0
    end
    object chkBitColor: TCheckBox
      Left = 16
      Top = 154
      Width = 129
      Height = 17
      Caption = 'Use 8-Bit Color'
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 214
    Top = 9
    Width = 219
    Height = 95
    Caption = 'Display'
    TabOrder = 1
    object chkViewOnly: TCheckBox
      Left = 13
      Top = 20
      Width = 193
      Height = 17
      Caption = 'View Only(Inputs Ignored)'
      TabOrder = 0
    end
    object chkFullScreen: TCheckBox
      Left = 13
      Top = 43
      Width = 193
      Height = 17
      Caption = 'Full-Screen Mode'
      TabOrder = 1
    end
    object chkStretch: TCheckBox
      Left = 13
      Top = 67
      Width = 193
      Height = 17
      Caption = 'Stretch'
      TabOrder = 2
    end
  end
  object GroupBox3: TGroupBox
    Left = 214
    Top = 105
    Width = 220
    Height = 95
    Caption = 'Misc'
    TabOrder = 2
    object chkShared: TCheckBox
      Left = 13
      Top = 20
      Width = 203
      Height = 17
      Caption = 'Shared(Don'#39't Disconnect others)'
      TabOrder = 0
    end
    object chkBell: TCheckBox
      Left = 13
      Top = 43
      Width = 203
      Height = 17
      Caption = 'Deiconify On Bell'
      TabOrder = 1
    end
    object chkClipboard: TCheckBox
      Left = 13
      Top = 67
      Width = 203
      Height = 17
      Caption = 'Disable Clipboard Transfer'
      TabOrder = 2
    end
  end
  object BitBtn1: TBitBtn
    Left = 145
    Top = 216
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 225
    Top = 216
    Width = 75
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
end
