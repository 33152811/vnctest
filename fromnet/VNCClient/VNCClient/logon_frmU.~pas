unit logon_frmU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  Tlogon_frm = class(TForm)
    GroupBox1: TGroupBox;
    host_edit: TEdit;
    GroupBox2: TGroupBox;
    password_edit: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  logon_frm: Tlogon_frm;

implementation

uses UDemo;

{$R *.dfm}

procedure Tlogon_frm.BitBtn1Click(Sender: TObject);
begin
with viewer_frm.RFBClient do
     begin
          Host := host_edit.text;
          connect;


     end;
   
end;

procedure Tlogon_frm.BitBtn2Click(Sender: TObject);
begin
self.close;
end;

end.


end;

