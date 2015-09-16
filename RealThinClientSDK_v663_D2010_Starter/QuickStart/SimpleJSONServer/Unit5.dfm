object Form5: TForm5
  Left = 0
  Top = 0
  ActiveControl = bListen
  AutoSize = True
  BorderStyle = bsSingle
  Caption = 'Simple RTC JSON Server'
  ClientHeight = 187
  ClientWidth = 343
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object bListen: TButton
    Left = 263
    Top = 30
    Width = 80
    Height = 55
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'START'
    TabOrder = 0
    OnClick = bListenClick
  end
  object Memo1: TMemo
    Left = 0
    Top = 125
    Width = 343
    Height = 62
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Lines.Strings = (
      'Server is NOT running.'
      'Configure all parameters and press START.')
    ReadOnly = True
    TabOrder = 1
  end
  object ConfigPanel: TPanel
    Left = 0
    Top = 0
    Width = 259
    Height = 121
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    TabOrder = 2
    object Label1: TLabel
      Left = 107
      Top = 4
      Width = 57
      Height = 12
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Max Threads'
    end
    object Label2: TLabel
      Left = 192
      Top = 4
      Width = 61
      Height = 12
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Listening Port'
    end
    object xFileName: TLabel
      Left = 5
      Top = 78
      Width = 78
      Height = 12
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Request FileName'
    end
    object Label3: TLabel
      Left = 5
      Top = 98
      Width = 72
      Height = 12
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Response String'
    end
    object xMultiThreaded: TCheckBox
      Left = 6
      Top = 5
      Width = 97
      Height = 12
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Multi-Threaded'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object ePoolSize: TEdit
      Left = 107
      Top = 20
      Width = 73
      Height = 20
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 1
      Text = '50'
    end
    object ePort: TEdit
      Left = 192
      Top = 20
      Width = 61
      Height = 20
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 2
      Text = '80'
    end
    object xJSON: TCheckBox
      Left = 6
      Top = 41
      Width = 247
      Height = 12
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Generate JSON Results from RTC Objects on-the-fly'
      TabOrder = 3
    end
    object xBlocking: TCheckBox
      Left = 6
      Top = 23
      Width = 97
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Blocking WinSock'
      TabOrder = 4
    end
    object eFileName: TEdit
      Left = 87
      Top = 76
      Width = 166
      Height = 20
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 5
      Text = '/service/HelloWorld'
    end
    object eResponseText: TEdit
      Left = 87
      Top = 96
      Width = 166
      Height = 20
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 6
      Text = '[Hello World!]'
    end
    object xHeaders: TCheckBox
      Left = 5
      Top = 59
      Width = 247
      Height = 12
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Generate custom HTTP Headers for each Response'
      TabOrder = 7
    end
  end
end
