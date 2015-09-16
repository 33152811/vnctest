object Form1: TForm1
  Left = 358
  Top = 295
  BorderStyle = bsDialog
  Caption = 'Delphi VNC Viewer'
  ClientHeight = 269
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 57
    Height = 15
    Caption = 'Host Addr:'
  end
  object Label2: TLabel
    Left = 16
    Top = 40
    Width = 54
    Height = 15
    Caption = 'Host Port:'
  end
  object Label3: TLabel
    Left = 16
    Top = 72
    Width = 59
    Height = 15
    Caption = 'Password:'
  end
  object Edit1: TEdit
    Left = 98
    Top = 7
    Width = 121
    Height = 23
    TabOrder = 0
    Text = '192.168.0.66'
  end
  object Edit2: TEdit
    Left = 98
    Top = 39
    Width = 121
    Height = 23
    TabOrder = 1
    Text = '5900'
  end
  object BitBtn1: TBitBtn
    Left = 236
    Top = 6
    Width = 75
    Height = 25
    Caption = '&Connect'
    Default = True
    TabOrder = 3
    OnClick = BitBtn1Click
  end
  object ListBox1: TListBox
    Left = 16
    Top = 166
    Width = 287
    Height = 89
    ItemHeight = 15
    TabOrder = 4
  end
  object BitBtn2: TBitBtn
    Left = 236
    Top = 38
    Width = 75
    Height = 25
    Caption = 'C&ancel'
    TabOrder = 5
    OnClick = BitBtn2Click
  end
  object Edit3: TEdit
    Left = 98
    Top = 71
    Width = 121
    Height = 23
    PasswordChar = '#'
    TabOrder = 2
    Text = '1234'
  end
  object BitBtn3: TBitBtn
    Left = 236
    Top = 70
    Width = 75
    Height = 25
    Caption = '&Options'
    TabOrder = 6
    OnClick = BitBtn3Click
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 105
    Width = 60
    Height = 17
    Caption = 'DSM'
    TabOrder = 7
    OnClick = CheckBox1Click
  end
  object ComboBox1: TComboBox
    Left = 98
    Top = 103
    Width = 124
    Height = 23
    Style = csDropDownList
    Enabled = False
    ItemHeight = 15
    TabOrder = 8
  end
  object CheckBox2: TCheckBox
    Left = 16
    Top = 139
    Width = 97
    Height = 17
    Caption = 'Repeater'
    TabOrder = 9
  end
  object Edit4: TEdit
    Left = 98
    Top = 135
    Width = 121
    Height = 23
    TabOrder = 10
    Text = '192.168.1.100:5901'
  end
  object PopupMenu1: TPopupMenu
    Left = 288
    Top = 104
    object N1: TMenuItem
      Caption = '-'
    end
    object Options1: TMenuItem
      Caption = 'Connection &Options'
      OnClick = Options1Click
    end
    object ConnectionInfomation1: TMenuItem
      Caption = 'Connection &Info'
      OnClick = ConnectionInfomation1Click
    end
    object RequestScreenRefresh1: TMenuItem
      Caption = '&Request Screen Refresh'
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mFullScreen: TMenuItem
      Caption = '&Full Screen'
      OnClick = mFullScreenClick
    end
    object NewConnection1: TMenuItem
      Caption = '&New Connection'
      OnClick = NewConnection1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object FileTransfer1: TMenuItem
      Caption = 'File Transfer'
      OnClick = FileTransfer1Click
    end
    object Chat1: TMenuItem
      Caption = 'Chat'
      OnClick = Chat1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object About1: TMenuItem
      Caption = '&About'
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 16
    Top = 40
  end
end
