[Setup]
AppName=Defiled Launcher
AppPublisher=Defiled
UninstallDisplayName=Defiled
AppVersion=${project.version}
AppSupportURL=https://Defiled.net/
DefaultDirName={localappdata}\Defiled

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=x86 x64
PrivilegesRequired=lowest

WizardSmallImageFile=${basedir}/app_small.bmp
WizardImageFile=${basedir}/left.bmp
SetupIconFile=${basedir}/app.ico
UninstallDisplayIcon={app}\Defiled.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${basedir}
OutputBaseFilename=DefiledSetup32

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${basedir}\app.ico"; DestDir: "{app}"
Source: "${basedir}\left.bmp"; DestDir: "{app}"
Source: "${basedir}\app_small.bmp"; DestDir: "{app}"
Source: "${basedir}\native-win32\Defiled.exe"; DestDir: "{app}"
Source: "${basedir}\native-win32\Defiled.jar"; DestDir: "{app}"
Source: "${basedir}\native\build32\Release\launcher_x86.dll"; DestDir: "{app}"
Source: "${basedir}\native-win32\config.json"; DestDir: "{app}"
Source: "${basedir}\native-win32\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs

[Icons]
; start menu
Name: "{userprograms}\Defiled"; Filename: "{app}\Defiled.exe"
Name: "{userdesktop}\Defiled"; Filename: "{app}\Defiled.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\Defiled.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\Defiled.exe"; Description: "&Open Defiled"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.runelite\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Code]
#include "upgrade.pas"