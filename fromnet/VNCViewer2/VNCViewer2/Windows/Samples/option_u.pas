unit option_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TOption_F = class(TForm)
    GroupBox1: TGroupBox;
    rgEncoding: TRadioGroup;
    chkBitColor: TCheckBox;
    GroupBox2: TGroupBox;
    chkViewOnly: TCheckBox;
    chkFullScreen: TCheckBox;
    chkStretch: TCheckBox;
    GroupBox3: TGroupBox;
    chkShared: TCheckBox;
    chkBell: TCheckBox;
    chkClipboard: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Option_F: TOption_F;

implementation

{$R *.dfm}

end.
