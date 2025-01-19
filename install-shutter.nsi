!define SERVICE_NAME "ShutterService"
!define EXE_NAME "shutter.exe"
!define CONFIG_NAME "config.json"

Name "Shutter Service Installer"
OutFile "ShutterInstaller.exe"
InstallDir "$PROGRAMFILES\Shutter"
RequestExecutionLevel admin

Section "Install Service"
    SetOutPath "$INSTDIR"
    File "${EXE_NAME}"
    File "${CONFIG_NAME}"
    
    ExecWait 'sc create ${SERVICE_NAME} binPath="$INSTDIR\${EXE_NAME}" start=auto type=own'
    ExecWait 'sc description ${SERVICE_NAME} "Shutter Service"'
    ExecWait 'sc start ${SERVICE_NAME}'
SectionEnd

Section "Uninstall"
    ExecWait 'sc stop ${SERVICE_NAME}'
    ExecWait 'sc delete ${SERVICE_NAME}'
    RMDir /r "$INSTDIR"
SectionEnd

Section -"Write Uninstaller"
    WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd
