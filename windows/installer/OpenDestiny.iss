#ifndef MyAppName
  #define MyAppName "OpenDestiny"
#endif

#ifndef MyAppVersion
  #define MyAppVersion "0.3.0"
#endif

#ifndef MyAppPublisher
  #define MyAppPublisher "RedSC1"
#endif

#ifndef MyAppURL
  #define MyAppURL "https://github.com/RedSC1/opendestiny-flutter"
#endif

#ifndef MyAppExeName
  #define MyAppExeName "opendestiny.exe"
#endif

#ifndef MyAppSourceDir
  #define MyAppSourceDir "..\..\build\windows\x64\runner\Release"
#endif

#ifndef MyOutputDir
  #define MyOutputDir "..\..\dist"
#endif

[Setup]
AppId={{E8D5D2D6-9D1B-4A35-BB7E-4A8E7B8D46E2}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={localappdata}\Programs\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir={#MyOutputDir}
OutputBaseFilename=OpenDestiny-windows-setup
SetupIconFile=..\runner\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\{#MyAppExeName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#MyAppSourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; Flags: nowait postinstall skipifsilent
