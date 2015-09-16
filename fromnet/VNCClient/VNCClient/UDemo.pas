unit UDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, ExtCtrls, IdAntiFreezeBase, IdAntiFreeze, ComCtrls;

type
  PIXEL_FORMAT = packed record
    BitsPerPixel: byte;
    depth: byte;
    BigEndianFlag: byte;
    TrueColourFlag: byte;
    RedMax: short;
    GreenMax: short;
    BlueMax: short;
    RedShift: byte;
    GreenBlue: byte;
    BlueShift: byte;
    Padding: Array[0..2] of byte;
  end;

  Tviewer_frm = class(TForm)
    RFBClient: TIdTCPClient;
    IdAntiFreeze1: TIdAntiFreeze;
    StatusBar1: TStatusBar;
    procedure RFBClientConnected(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FrameBufferWidth,
    FrameBufferHeight: short;
    ServerPixelFormat: PIXEL_FORMAT;


    function GetProtocolVersion: boolean;
    procedure SendProtocolVersion;
    function Authentication: boolean;
    procedure ClientInitialization;
    procedure ServerInitialization;
    procedure SetPixelFormat;
    procedure SetEncodings;
    procedure FrameBufferUpdateRequest(Full: boolean);
    procedure PointerEvent(Button: TShiftState; X, Y: integer);
    procedure ExecuteServerCommand(cmd: byte);
    { server }
    procedure FrameBufferUpdate;
  public
    { Public declarations }
  end;

   procedure deskey(key: pChar; edf: short); stdcall; external 'des.dll';
   procedure des(inblock, outblock: pChar); stdcall; external 'des.dll';

var
  viewer_frm: Tviewer_frm;

implementation

uses logon_frmU;

{$R *.dfm}

const
  ProtocolVersion = 'RFB 003.003';
  CHALLENGESIZE = 16;
  EN0: short = 0;
  EN1: short = 1;

  function vncEncryptBytes(base: string; passwd: string; mode: short): string;
  var
    key, bytes, response: pChar;
    i: integer;
  begin
    key := StrAlloc((CHALLENGESIZE div 2) + 1);
    response := StrAlloc(CHALLENGESIZE + 1);
    try
      for i := 0 to 7 do
      begin
        if (i < length(passwd)) then
          key[i] := passwd[i + 1]
        else
          key[i] := #0;
      end;
      if length(passwd)>8 then
        Key[8] := #0;
        
      deskey(key, mode);

      bytes := pChar(base);
      i := 0;
      while (i < CHALLENGESIZE) do
      begin
        des(bytes + i, response + i);
        inc(i, 8);
      end;
      Result := response;
      SetLength(Result, CHALLENGESIZE);
    finally
      StrDispose(response);
      StrDispose(key);
    end;
  end;

  function vncEncrypt(base: string; passwd: string): string;
  begin
    Result := vncEncryptBytes(base, passwd, EN0);
  end;

  function vncDecrypt(base: string; passwd: string): string;
  begin
    Result := vncEncryptBytes(base, passwd, EN1);
  end;

function Tviewer_frm.Authentication: boolean;
var
  AuthenticationSheme, Status, l: integer;
  msg : string;
  Response, Challenge, PassWord: string;
begin
  Result := FALSE;
  AuthenticationSheme := RFBClient.ReadInteger;

  case AuthenticationSheme of
    0 : { connection failed }
         begin
           l := RFBClient.ReadInteger;
           msg := RFBClient.ReadString(l);
           Showmessage(msg);
         end;
    1 : { no authentication }
         begin
           Result := TRUE;
         end;
    2 : { VNC authentication }
         begin
           Challenge := RFBClient.ReadString(CHALLENGESIZE);
           PassWord := logon_frm.password_edit.text;

           Response := vncEncrypt(Challenge, PassWord);
           RFBClient.WriteBuffer(Response[1], Length(Response), TRUE);

           Status := RFBClient.ReadInteger;
           //showmessage(inttostr(status));
           case Status of
             0 : { OK } Result := TRUE;
             1 : { failed } Result := FALSE;
             2 : { too many } Result := FALSE;
           end;
         end;
  end;
end;

function Tviewer_frm.GetProtocolVersion: boolean;
var
  pv: string;
begin
  Result := FALSE;
  pv := RFBClient.ReadLn(#10);
  Result := CompareText(pv, ProtocolVersion)=0;
end;

procedure Tviewer_frm.SendProtocolVersion;
var
  buff: pChar;
  l: integer;
begin
  //RFBClient.Write(ProtocolVersion + #10);
  buff := pChar(ProtocolVersion + #10);
  l := StrLen(buff);
  RFBClient.WriteBuffer(buff^, l, TRUE);
end;

procedure Tviewer_frm.RFBClientConnected(Sender: TObject);
var
  cmd: byte;
begin
  logon_frm.hide;
   viewer_frm.Show;
  if GetProtocolVersion then
  begin
    SendProtocolVersion;
    if Authentication then
    begin
      ClientInitialization;
      ServerInitialization;
      SetPixelFormat;
      SetEncodings;
      FrameBufferUpdateRequest(TRUE);
      while RFBClient.Connected do
      begin
        RFBClient. ReadBuffer(cmd, 1);
        ExecuteServerCommand(cmd);
        FrameBufferUpdateRequest(TRUE);
        Application.ProcessMessages;
      end;
    end;
  end;
end;

procedure Tviewer_frm.ClientInitialization;
var
  sharedflag: byte;
begin
  sharedflag := 1;
  RFBClient.WriteBuffer(sharedflag, 1, TRUE);
end;

procedure Tviewer_frm.ServerInitialization;
var
  l: integer;
  name: string;                      TIdTCPClient.
begin
  FrameBufferWidth := RFBClient. ReadSmallInt;
  FrameBufferHeight := RFBClient.ReadSmallInt;
  RFBClient.ReadBuffer(ServerPixelFormat, SizeOf(PIXEL_FORMAT));
  l := RFBClient.ReadInteger;
  name := RFBClient.ReadString(l);
  Caption := 'Connected with ' + name;
end;

procedure Tviewer_frm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   try
  if RFBClient.Connected then
    RFBClient.Disconnect;
    except

    end;
    logon_frm.Close;
end;

procedure Tviewer_frm.SetPixelFormat;
begin

end;

procedure Tviewer_frm.SetEncodings;
const
  SetEncodings: byte=2;
var
  NumberOfEncodings: short;
begin
  RFBClient.WriteBuffer(SetEncodings, 1, TRUE);
  RFBClient.WriteBuffer(SetEncodings, 1, TRUE);
  NumberOfEncodings := 1;
  RFBClient.WriteSmallInt(NumberOfEncodings);
  RFBClient.WriteInteger(0);
end;

procedure Tviewer_frm.ExecuteServerCommand(cmd: byte);
begin
  case cmd of
    0: FrameBufferUpdate;
    //1: nop;
    2: beep;
  end;
end;

procedure Tviewer_frm.FrameBufferUpdateRequest(Full: boolean);
var
  Command,
  incremental: byte;
  BufferX,
  BufferY,
  BufferWidth,
  BufferHeight: short;
begin
  Command := 3;
  incremental := 0;
  BufferX := 0;
  BufferY := 0;
  BufferWidth := FrameBufferWidth;
  BufferHeight := FrameBufferHeight;
  viewer_frm.Width:= bufferwidth;
  viewer_frm.Height:= bufferheight+35+statusbar1.Height;
 // Image1.Picture.Bitmap.Width := BufferWidth;
  //Image1.Picture.Bitmap.Height := BufferHeight;

  RFBClient.WriteBuffer(Command, 1, TRUE);
  if Full then
    RFBClient.WriteBuffer(incremental, 1, TRUE)
  else
    RFBClient.WriteBuffer(incremental, 0, TRUE);
  RFBClient.WriteBuffer(BufferX, 2, TRUE);
  RFBClient.WriteBuffer(BufferY, 2, TRUE);
  RFBClient.WriteBuffer(BufferWidth, 2, TRUE);
  RFBClient.WriteBuffer(BufferHeight, 2, TRUE);
end;

procedure Tviewer_frm.FrameBufferUpdate;
type
  RECT_DATA = packed record
    X, Y, W, H: short;
    encoding: integer;
  end;

var
  padding: byte;
  NumRect: short;
  RectData: RECT_DATA;
  NumPixels, NumBytes,  i: integer;
  buffer: pChar;
  bmp: TBitmap;
begin
  RFBClient.ReadBuffer(padding, 1);
  NumRect := RFBClient.ReadSmallInt;
  for i:=1 to NumRect do
  begin
    RectData.X := RFBClient.ReadSmallInt;
    RectData.Y := RFBClient.ReadSmallInt;
    RectData.W := RFBClient.ReadSmallInt;
    RectData.H := RFBClient.ReadSmallInt;
    RectData.encoding := RFBClient.ReadInteger;
    statusbar1.Panels[0].Text := format('%d,%d,%d,%d - %d', [RectData.X,RectData.Y,RectData.W,RectData.H, RectData.encoding]);
    case RectData.encoding of
      0: begin { raw encoding }
           NumPixels := RectData.W * RectData.H;
           NumBytes := (NumPixels * ServerPixelFormat.BitsPerPixel) div 8;
           GetMem(buffer, NumBytes + 1);
           try
             bmp := TBitmap.Create;
             try
               bmp.Width := RectData.W;
               bmp.Height := RectData.H;
               bmp.HandleType := bmDIB;
               case ServerPixelFormat.BitsPerPixel of
                 1 : bmp.PixelFormat := pf1bit;
                 4 : bmp.PixelFormat := pf4bit;
                 8 : bmp.PixelFormat := pf8Bit;
                 15 : bmp.PixelFormat := pf15Bit;
                 16 : bmp.PixelFormat := pf16Bit;
                 24 : bmp.PixelFormat := pf24Bit;
                 32 : bmp.PixelFormat := pf32Bit;
               end;
               RFBClient.ReadBuffer(buffer^, NumBytes);
               SetBitmapBits(bmp.Handle, NumBytes, buffer);
              viewer_frm.Canvas.Draw(0,0,bmp);

              // paintbox1.Canvas.Draw(0,0,bmp);
              // paintbox1.Refresh;
              // Image1.picture.Bitmap.Assign(bmp);
               //Image1.Repaint;
             finally
               bmp.Free;
             end;
           finally
             FreeMem(buffer);
           end;
         end;
      1: begin

         end;
      2: begin

         end;
      4: begin

         end;
      5: begin

         end;
    end;
    //RFBClient.ReadBuffer(RectData, SizeOf(RECT_DATA));
  end
end;

procedure Tviewer_frm.PointerEvent(Button: TShiftState; X, Y: integer);
var
  PointerEventCommand,
  ButtonMask: byte;
  XX, YY: short;
begin
  if not RFBClient.connected then
    exit;

  PointerEventCommand := 5;
  ButtonMask := 0;
  XX := ((((X and $FF) shl 8) or ((X shr 8) and $FF)));
  YY := ((((Y and $FF) shl 8) or ((Y shr 8) and $FF)));
  if ssLeft in Button then
    ButtonMask := 1;
  if ssRight in Button then
    ButtonMask := 4;
  RFBClient.WriteBuffer(PointerEventCommand, 1);
  RFBClient.WriteBuffer(ButtonMask, 1);
  RFBClient.WriteBuffer(XX, 2);
  RFBClient.WriteBuffer(YY, 2, TRUE);

  statusbar1.Panels[2].text := format('%d,%d -%d', [XX,YY,ButtonMask]);
end;

procedure Tviewer_frm.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  PointerEvent(Shift, X, Y);
end;

procedure Tviewer_frm.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PointerEvent(Shift, X, Y);
end;

procedure Tviewer_frm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  PointerEvent(Shift, X, Y);
end;

procedure Tviewer_frm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
PointerEvent(Shift, X, Y);
end;

end.
