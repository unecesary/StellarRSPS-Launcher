[Setup]
AppName=StakeScape Launcher
AppPublisher=StakeScape
UninstallDisplayName=StakeScape
AppVersion=${project.version}
AppSupportURL=https://stakescape.org/
DefaultDirName={localappdata}\Stakescape

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=x86 x64
PrivilegesRequired=lowest

WizardSmallImageFile=${basedir}/app_small.bmp
WizardImageFile=${basedir}/left.bmp
SetupIconFile=${basedir}/app.ico
UninstallDisplayIcon={app}\StakeScape.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${basedir}
OutputBaseFilename=StakeScapeSetup32

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${basedir}\app.ico"; DestDir: "{app}"
Source: "${basedir}\left.bmp"; DestDir: "{app}"
Source: "${basedir}\app_small.bmp"; DestDir: "{app}"
Source: "${basedir}\native-win32\StakeScape.exe"; DestDir: "{app}"
Source: "${basedir}\native-win32\StakeScape.jar"; DestDir: "{app}"
Source: "${basedir}\native\build32\Release\launcher_x86.dll"; DestDir: "{app}"
Source: "${basedir}\native-win32\config.json"; DestDir: "{app}"
Source: "${basedir}\native-win32\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs

[Icons]
; start menu
Name: "{userprograms}\Stakescape"; Filename: "{app}\StakeScape.exe"
Name: "{userdesktop}\Stakescape"; Filename: "{app}\StakeScape.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\StakeScape.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\StakeScape.exe"; Description: "&Open StakeScape"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.stakescape\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Code]
#include "upgrade.pas"