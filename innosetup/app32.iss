[Setup]
AppName=StellarRSPS Launcher
AppPublisher=StellarRSPS
UninstallDisplayName=StellarRSPS
AppVersion=${project.version}
AppSupportURL=https://StellarRSPS.org/
DefaultDirName={localappdata}\StellarRSPS

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=x86 x64
PrivilegesRequired=lowest

WizardSmallImageFile=${basedir}/app_small.bmp
WizardImageFile=${basedir}/left.bmp
SetupIconFile=${basedir}/app.ico
UninstallDisplayIcon={app}\StellarRSPS.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${basedir}
OutputBaseFilename=StellarRSPSSetup32

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${basedir}\app.ico"; DestDir: "{app}"
Source: "${basedir}\left.bmp"; DestDir: "{app}"
Source: "${basedir}\app_small.bmp"; DestDir: "{app}"
Source: "${basedir}\native-win32\StellarRSPS.exe"; DestDir: "{app}"
Source: "${basedir}\native-win32\StellarRSPS.jar"; DestDir: "{app}"
Source: "${basedir}\native\build32\Release\launcher_x86.dll"; DestDir: "{app}"
Source: "${basedir}\native-win32\config.json"; DestDir: "{app}"
Source: "${basedir}\native-win32\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs

[Icons]
; start menu
Name: "{userprograms}\StellarRSPS"; Filename: "{app}\StellarRSPS.exe"
Name: "{userdesktop}\StellarRSPS"; Filename: "{app}\StellarRSPS.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\StellarRSPS.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\StellarRSPS.exe"; Description: "&Open StellarRSPS"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.StellarRSPS\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Code]
#include "upgrade.pas"