{
  @exclude

  @html(<b>)
  StreamSec SSL Plug-in Registration
  @html(</b>)
  - Copyright 2004-2013 (c) RealThinClient.com (http://www.realthinclient.com)
  - Copyright (c) Henrick Hellstrom
  @html(<br><br>)
}
unit rtcSTMTRegister;

interface

uses
  Classes, SysUtils,

  // RTC SDK
  rtcPlugins,
  rtcSTMTPlugin;

procedure Register;

implementation

procedure Register;
  begin
  RegisterComponents('RTC Server',[TRtcSTMTServerPlugin]);
  RegisterComponents('RTC Client',[TRtcSTMTClientPlugin]);
  end;

end.
