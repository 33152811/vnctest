unit Chat_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,VNCViewer;

type
  TChat_F = class(TForm)
    edtMsg: TRichEdit;
    EdtMsgSend: TMemo;
    btnSend: TButton;
    btnClose: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSendClick(Sender: TObject);
    procedure EdtMsgSendKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    Viewer:TDelphiVNCViewer;
    { Public declarations }
  end;

var
  Chat_F: TChat_F;

implementation

{$R *.dfm}

procedure TChat_F.FormShow(Sender: TObject);
begin
  if Assigned(Viewer) then
  begin
    Viewer.SendTextChatRequest(CHAT_OPEN);
  end;
end;

procedure TChat_F.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TChat_F.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(Viewer) then
    Viewer.SendTextChatRequest(CHAT_CLOSE);
end;

procedure TChat_F.btnSendClick(Sender: TObject);
var
  OldStart:Integer;
begin
  if Assigned(Viewer) then
  begin
    EdtMsg.SelStart:=99999999;
    Viewer.SendLocalText(EdtMsgSend.Lines.Text+#13#10);
    OldStart:=EdtMsg.SelStart;
    EdtMsg.Lines.Add('Local:'+EdtMsgSend.Lines.Text);
    EdtMsg.SelStart:=OldStart;
    EdtMsg.SelLength:=Length('Local:'+EdtMsgSend.Lines.Text);
    EdtMsg.SelAttributes.Color:=clred;
    EdtMsg.SelLength:=0;
    EdtMsg.SelStart:=99999999;
    EdtMsgSend.Lines.Text:='';
    EdtMsgSend.SetFocus;
  end;
end;

procedure TChat_F.EdtMsgSendKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  begin
    Key:=#0;
    btnSend.Click;
  end;
end;

end.
