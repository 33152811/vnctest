object Viewer_F: TViewer_F
  Left = 558
  Top = 251
  Width = 490
  Height = 357
  Caption = 'Viewer_F'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Viewer: TDelphiVNCViewer
    Left = 0
    Top = 0
    Width = 482
    Height = 330
    Cursor = crCross
    align = alClient
    Color = clBlack
    Port = 0
    ShareDesktop = False
    PixelFormat = VNCAuto
    FrameUpdateDelay = 1
    EnableBell = False
    Display = 0
    AutoScroll = True
    Codec = vncHextile
    TransferKeys = True
    TransferLocalClipboard = True
    TransferMouse = True
    TransferServerClipBoard = True
    RequestFreames = True
    Stretch = False
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 200
    Top = 176
  end
end
