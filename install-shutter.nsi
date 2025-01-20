!define SERVICE_NAME "ShutterService"
!define EXE_NAME "shutter.exe"
!define CONFIG_NAME "config.json"

Name "Shutter Service Installer"
OutFile "ShutterInstaller.exe"
InstallDir "$PROGRAMFILES\Shutter"
RequestExecutionLevel admin

Section "Install Service"
    DetailPrint "Setting output path..."
    SetOutPath "$INSTDIR"
    
    DetailPrint "Copying files..."
    File "${EXE_NAME}"
    File "${CONFIG_NAME}"
    
    DetailPrint "Creating service..."
    ExecWait 'sc create ${SERVICE_NAME} binPath="$INSTDIR\${EXE_NAME}" start=auto type=own'
    
    DetailPrint "Setting service description..."
    ExecWait 'sc description ${SERVICE_NAME} "Shutter Service"'
    
    DetailPrint "Starting service..."
    ExecWait 'sc start ${SERVICE_NAME}'
SectionEnd

Section "Uninstall"
    DetailPrint "Stopping service..."
    ExecWait 'sc stop ${SERVICE_NAME}'
    
    DetailPrint "Waiting for service to stop..."
    Sleep 5000
    
    DetailPrint "Deleting service..."
    ExecWait 'sc delete ${SERVICE_NAME}'
    
    DetailPrint "Removing files and directory..."
    Delete "$INSTDIR\${EXE_NAME}"
    Delete "$INSTDIR\${CONFIG_NAME}"
    Delete "$INSTDIR\Uninstall.exe"
    RMDir "$INSTDIR"
    
    DetailPrint "Verifying removal..."
    retry:
    IfFileExists "$INSTDIR\${EXE_NAME}" notDeleted
    IfFileExists "$INSTDIR\${CONFIG_NAME}" notDeleted
    IfFileExists "$INSTDIR\Uninstall.exe" notDeleted
    IfFileExists "$INSTDIR" notDeleted
    Goto done
    
    notDeleted:
    DetailPrint "Files or directory not deleted, retrying..."
    DetailPrint "Stopping service..."
    ExecWait 'sc stop ${SERVICE_NAME}'
    DetailPrint "Waiting for service to stop..."
    Sleep 5000
    DetailPrint "Deleting service..."
    ExecWait 'sc delete ${SERVICE_NAME}'
    Delete "$INSTDIR\${EXE_NAME}"
    Delete "$INSTDIR\${CONFIG_NAME}"
    Delete "$INSTDIR\Uninstall.exe"
    RMDir "$INSTDIR"
    Sleep 1000
    Goto retry
    
    done:
    DetailPrint "Uninstallation complete."
SectionEnd

Section -"Write Uninstaller"
    WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd
