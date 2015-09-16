object Chat_F: TChat_F
  Left = 448
  Top = 238
  Width = 513
  Height = 371
  Caption = 'Chat'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    505
    344)
  PixelsPerInch = 96
  TextHeight = 15
  object edtMsg: TRichEdit
    Left = 0
    Top = 8
    Width = 500
    Height = 269
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object EdtMsgSend: TMemo
    Left = 0
    Top = 283
    Width = 418
    Height = 57
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    OnKeyPress = EdtMsgSendKeyPress
  end
  object btnSend: TButton
    Left = 425
    Top = 283
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Send'
    Default = True
    TabOrder = 2
    OnClick = btnSendClick
  end
  object btnClose: TButton
    Left = 426
    Top = 313
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
end
