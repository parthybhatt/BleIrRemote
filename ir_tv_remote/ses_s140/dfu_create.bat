@echo off
set "batch_path=%~dp0"
set "hex_relative_path=Output\Debug\Exe\"
set "hex_file_name=ir_tv_remote_s140.hex"
set "hex_absolute_path=%batch_path%%hex_relative_path%%hex_file_name%"
set "op_package_file=%batch_path%%hex_relative_path%dfu_package.zip"
set "nrfutil_file=C:\Users\bpart\AppData\Roaming\Python\Python38\Scripts\adafruit-nrfutil.exe"

if exist "%nrfutil_file%" (
    if exist "%hex_absolute_path%" (
        "%nrfutil_file%" dfu genpkg --dev-type 0x0052 --sd-req 0x0123 --application "%hex_absolute_path%" "%op_package_file%"
    ) else (
        echo "%hex_absolute_path%" file not found. Make sure to build the s140 project before running the script
    )
) else (
    echo "adafruit-nrfutil.exe" does not exist. Please follow readme file to learn how to install the utility
)
pause
