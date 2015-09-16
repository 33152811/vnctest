RealThinClient SDK - Starter edition
Copyright (c) 2004-2015 by Danijel Tkalcec

http://www.realthinclient.com

Starter edition is FREE for NON-COMMERCIAL use.

Starter edition has limitations, which do NOT apply to the full edition:

1) Starter edition does NOT include RTC SDK source code ("Lib" folder)

2) Starter edition if ONLY available for Delphi 7 and RAD Studio/Delphi 2007 - XE8

3) Starter edition can ONLY be used for compiling 32-bit Windows Applications. 
   There is no 64-bit nor cross-platform support in the Starter edition.

4) Starter edition is limited to maximum 10 (ten) active connections.
   Should more connection requests arrive, RTC SDK Starter edition will 
   raise an exception and refuse to accept (drop) the new connection.

All these limitations do NOT apply to the full RealThinClient version, which 
includes full RTC SDK source code, can be used with all Delphi versions from 
Delphi 7 up to the latest Delphi release, can handle thousands of active 
connections and compiles for Win32, Win64, MacOSX, iOS and Android platforms.

--------------------------------
********************************

1.) License Agreement

2.) Install RTC SDK components in Delphi

3.) Update RTC SDK components in Delphi

4.) Help

5.) Demos

6.) Support

********************************
--------------------------------

---------------------
1.) License Agreement
---------------------

Please read the RTC SDK License Agreement before using RTC SDK components.

You will find the RTC SDK License Agreement in the "License.txt" file.

--------------------------------
2.) INSTALL RTC SDK components in Delphi
--------------------------------

After you have unpacked the files in a folder of your choice and started Delphi, open the 

"SDKPackages_Main" Project Group, containing these 5 packages:
 
  rtcSDK.dpk       -> The main Package. Includes all Client and Server HTTP/S components.

  rtcSDK_DBA.dpk   -> Optional, includes "TRtcMemDataSet" and "TRtcDataSetMonitor" components.

  rtcSDK_DBCli.dpk -> Optional, includes the "TRtcClientDataSet" component.

  rtcSDK_Gate.dpk  -> Optional, includes "TRtcGateway", "TRtcHttpGateClient" and "TRtcGateClientLink" components.

  rtcSDK_RAW.dpk   -> Optional, includes raw low-level TCP/IP and UDP components.

Install the components in Delphi by using the "Install" button, or the "Install" menu option.
In older Delphi versions, you will see the "Install" button in the Project Manager window.
In newer Delphi versions, you will find the "Install" option if you right-click the package
file in the Project Manager accessed in the "View" drop-down menu.

When compiled and installed, you will see a message listing all components installed.

After that, you should add the path to the RTC SDK's "Lib" folder to "Library paths" in Delphi.

In older Delphi versions, the Library Path is located in the "Tools / Environment Options" menu.
Select the "Library" tab and add the full path to the RTC SDK's "Lib" folder to "Library path".

In newer Delphi versions, Library Paths are located in the "Tools / Options" menu. Select the 
"Environment Options / Delphi Options / Library" tree branch, where you will find the "Library Path" field.
There, you should click the "..." button next to "Library path" and add the path to the RTC SDK's "Lib" folder.

In Delphi XE2 and later, you will also see a "Selected Platform" drop-down menu. There, all the settings are separated 
by platforms, so you  will need to repeat the process for every platform you want to use the "RTC SDK" with. 

-------------------------------
3.) UPDATE RTC SDK components in Delphi
-------------------------------

Information about recent RTC SDK updates is in the "Updates*.txt" file(s).

To update RTC SDK components, before installing new RTC packages, it is 
adviseable to uninstall old RTC packages and delete the old BPL and DCP files:
  - rtcSDK.bpl & rtcSDK.dcp
  - rtcSDK_DBA.bpl & rtcSDK_DBA.dcp
  - rtcSDK_DBACli.bpl & rtcSDK_DBACli.dcp
  - rtcSDK_Gate.bpl & rtcSDK_Gate.dcp
  - rtcSDK_RAW.bpl & rtcSDK_RAW.dcp

To uninstall RTC SDK components, after you start Delphi, 
open the menu "Component / Install Packages ..." where you 
will see a list of all packages currently installed in your Delphi. 

Scroll down to find "RealThinClient SDK" and click on it (single click). 
When you select it, click the button "Remove" and Delphi will ask you 
if you want to remove this package. Clicking "Yes" will uninstall the RTC SDK.

After that, *close* Delphi and follow step (2) to install the new RTC SDK package.

NOTE: Uninstalling the RTC SDK package will also uninstall all packages which are 
using the RTC SDK (for example, rtcSDK_DBA, rtcSDK_RAW and "Nexus Portal" packages). 
So ... if you are using "Nexus Portal" or any other product using the RTC SDK, you will 
need to Build and Install all related packages again, after you reinstall the RTC SDK.

-------------
4.) Help
-------------

The best place to start learning about RTC SDK is the QuickStart guide. After going through the 
online lessons, you should also go through the QuickStart examples included in the RTC SDK package. 

When you are done examining QuickStart examples, I suggest browsing through the FAQ. Even if you won't
be reading all the articles, you should at least get the feeling about the information included there.

RTC SDK Demos are another good source of information, including a lot of examples and best practices 
for using the RealThinClient SDK. And the most extensive source of information on the RealThinClient SDK 
are Help files. Some of the information is spread across the files, but if you know which class you need, 
you will most likely be able to find what you are looking for.

When you start working on your project, the FAQ will come in handy when you have to do something 
specific (use Sessions, accept form post data, write and call remote functions, etc). The FAQ is 
continualy being extended, as more questions come in.

If you have a question for which you were unable to find the answer in the QuickStart guide, QuickStart 
examples or the FAQ … and searching through the Help files didn't give you the answers you need, don't 
hesitate to post your question(s) on Developer Support groups.

The latest Help file for Off-line viewing is in the "Help" folder:
- "Help\RTCSDK_Help.chm"

-------------------
5.) Demos
-------------------

You can find Demos using RTC SDK components in the "Demos" folder.
Simple Quick Start Examples are available in the "QuickStart" folder.

There are also 5 Project Groups which include all the Demos and Quick Start examples:

  * SDKDemos_VCL - Demos using the VCL and the rtcSDK.dpk
  * SDKDemos_VCL_DBA - Demos using the VCL with the rtcSDK.dpk and rtcSDK_DBA.dpk
  * SDKDemos_VCL_Gate - Demos using the VCL with the rtcSDK.dpk and rtcSDK_Gate.dpk

  * SDKDemos_FMX - Demos using FMX (Win,OSX,iOS) with the rtcSDK.dpk 
  * SDKDemos_FMX2 - Demos using FMX2 (Win,OSX,iOS,Android) with the rtcSDK.dpk 
  * SDKDemos_FMX_DBA - Demos using FMX (Win,OSX,iOS) with the rtcSDK.dpk and rtcSDK_DBA.dpk

  * SDKExamples_QuickStart_VCL - Short "QuickStart" examples using the VCL with the rtcSDK.dpk

For short descriptions of available demos and quick start examples, please find the 
"Readme_Demos.txt" file in the "Demos" folder, and "Readme_QuickStart.txt" file in the QuickStart folder.

-------------
6.) Support
-------------

The latest commercial RealThinClient SDK version with FULL SOURCE CODE and Technical Support
is available to all developers with an active RealThinClient subscription.

To order a RealThinClient subscription, please visit:
http://www.realthinclient.com