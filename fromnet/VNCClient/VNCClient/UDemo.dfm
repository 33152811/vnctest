object viewer_frm: Tviewer_frm
  Left = 232
  Top = 131
  Caption = 'viewer_frm'
  ClientHeight = 176
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 14
  object StatusBar1: TStatusBar
    Left = 0
    Top = 157
    Width = 321
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 50
      end
      item
        Width = 150
      end>
    ExplicitTop = 162
    ExplicitWidth = 329
  end
  object RFBClient: TIdTCPClient
    OnConnected = RFBClientConnected
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 5900
    ReadTimeout = 0
    Left = 8
    Top = 8
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 48
    Top = 8
  end
end
