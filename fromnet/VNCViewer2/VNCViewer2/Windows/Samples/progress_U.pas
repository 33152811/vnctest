unit progress_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Gauges, StdCtrls;

type
  TProgress_F = class(TForm)
    Panel1: TPanel;
    Gauge1: TGauge;
    Label1: TLabel;
    Timer1: TTimer;
    Label2: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Counter:Integer;
  end;

var
  Progress_F: TProgress_F;

implementation

{$R *.dfm}

procedure TProgress_F.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=false;
end;

procedure TProgress_F.FormShow(Sender: TObject);
begin
  Timer1.Enabled:=true;
  Counter:=1;
end;

procedure TProgress_F.Timer1Timer(Sender: TObject);
begin
  inc(Counter);
end;

end.
