unit MainGateForm;

interface

{$include rtcDeploy.inc}

{ This example demonstrates how to set up and use a TRtcHttpGateway component. }

uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,

  rtcInfo, rtcConn,

  rtcLog,
  rtcDataSrv,
  rtcHttpSrv,
  rtcGateSrv,
  rtcGateConst,

  ExtCtrls, Spin;

type
  TGateForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    shGateway: TShape;
    Label2: TLabel;
    Label3: TLabel;
    ePort: TEdit;
    btnStart: TButton;
    eSendSpeed: TSpinEdit;
    lblStatus: TLabel;
    lblConnect: TLabel;
    StatusTimer: TTimer;
    Label4: TLabel;
    Label5: TLabel;
    eRecvSpeed: TSpinEdit;
    Label6: TLabel;
    MyGate: TRtcHttpGateway;
    procedure btnStartClick(Sender: TObject);
    procedure MyGateListenStart(Sender: TRtcConnection);
    procedure MyGateListenStop(Sender: TRtcConnection);
    procedure MyGateListenError(Sender: TRtcConnection; E: Exception);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StatusTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GateForm: TGateForm;

implementation

{$R *.dfm}

procedure TGateForm.btnStartClick(Sender: TObject);
  begin
  if not MyGate.Active then
    begin
    SetupConnectionSpeed(eRecvSpeed.Value,eSendSpeed.Value);

    MyGate.GatePort:=ePort.Text;
    MyGate.Active:=True;
    end
  else
    MyGate.Active:=False;
  end;

procedure TGateForm.MyGateListenStart(Sender: TRtcConnection);
  begin
  if not Sender.inMainThread then
    Sender.Sync(MyGateListenStart)
  else
    begin
    shGateway.Brush.Color:=clGreen;
    lblStatus.Caption:='Listening on Port '+Sender.LocalPort;
    btnStart.Caption:='STOP';
    end;
  end;

procedure TGateForm.MyGateListenStop(Sender: TRtcConnection);
  begin
  if not Sender.inMainThread then
    Sender.Sync(MyGateListenStop)
  else
    begin
    shGateway.Brush.Color:=clRed;
    lblStatus.Caption:='Stopped listening';
    btnStart.Caption:='START';
    end;
  end;

procedure TGateForm.MyGateListenError(Sender: TRtcConnection; E: Exception);
  begin
  if not Sender.inMainThread then
    Sender.Sync(MyGateListenError,E)
  else
    lblStatus.Caption:=E.Message;
  end;

procedure TGateForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  begin
  MyGate.Active:=False;
  end;

procedure TGateForm.FormCreate(Sender: TObject);
  begin
  StatusTimer.Enabled:=True;
  end;

procedure TGateForm.FormDestroy(Sender: TObject);
  begin
  StatusTimer.Enabled:=False;
  end;

procedure TGateForm.StatusTimerTimer(Sender: TObject);
  begin
  lblConnect.Caption:=IntToStr(MyGate.Server.TotalConnectionCount);
  end;

{$IFDEF RtcDeploy}
type
  TForcedMemLeak=class(TObject);
initialization
// Force a Memory Leak to test Memory Leak reporting
TForcedMemLeak.Create;
{$ENDIF}
end.
