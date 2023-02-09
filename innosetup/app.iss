[Setup]
AppName=Yanille Launcher
AppPublisher=Yanille
UninstallDisplayName=Yanille
AppVersion=${project.version}
AppSupportURL=https://Yanille.org/
DefaultDirName={localappdata}\Yanille

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=x64
PrivilegesRequired=lowest

WizardSmallImageFile=${basedir}/app_small.bmp
WizardImageFile=${basedir}/left.bmp
SetupIconFile=${basedir}/app.ico
UninstallDisplayIcon={app}\Yanille.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${basedir}
OutputBaseFilename=YanilleSetup64

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${basedir}\app.ico"; DestDir: "{app}"
Source: "${basedir}\left.bmp"; DestDir: "{app}"
Source: "${basedir}\app_small.bmp"; DestDir: "{app}"
Source: "${basedir}\native-win64\Yanille.exe"; DestDir: "{app}"
Source: "${basedir}\native-win64\Yanille.jar"; DestDir: "{app}"
Source: "${basedir}\native\build64\Release\launcher_amd64.dll"; DestDir: "{app}"
Source: "${basedir}\native-win64\config.json"; DestDir: "{app}"
Source: "${basedir}\native-win64\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs

[Icons]
; start menu
Name: "{userprograms}\Yanille"; Filename: "{app}\Yanille.exe"
Name: "{userdesktop}\Yanille"; Filename: "{app}\Yanille.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\Yanille.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\Yanille.exe"; Description: "&Open Yanille"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.Yanille\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Code]
#include "upgrade.pas"