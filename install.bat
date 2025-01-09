@echo off

set exe_name=shutter.exe
set target_dir="C:\Program Files\Shutter"

if not exist "%target_dir%" (
    mkdir "%target_dir%"
)

copy "%~dp0%exe_name%" "%target_dir%\%exe_name%"

set service_name=ShutterService
set exe_path=%target_dir%\%exe_name%

sc create "%service_name%" binPath= "\"%exe_path%\"" start=auto
sc description "%service_name%" "Shutter Service"
sc start "%service_name%"

echo TAAMDIR!
pause