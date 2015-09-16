object Progress_F: TProgress_F
  Left = 319
  Top = 245
  BorderStyle = bsNone
  Caption = 'Progress_F'
  ClientHeight = 67
  ClientWidth = 388
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 388
    Height = 67
    Align = alClient
    TabOrder = 0
    object Gauge1: TGauge
      Left = 9
      Top = 22
      Width = 369
      Height = 20
      Progress = 0
    end
    object Label1: TLabel
      Left = 9
      Top = 45
      Width = 18
      Height = 13
      Caption = '0KB'
    end
    object Label2: TLabel
      Left = 9
      Top = 4
      Width = 31
      Height = 13
      Caption = 'Label2'
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 152
    Top = 16
  end
end
