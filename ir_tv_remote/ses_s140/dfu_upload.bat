@echo off
set "batch_path=%~dp0"
set "hex_relative_path=Output\Debug\Exe\"
set "op_package_file=%batch_path%%hex_relative_path%dfu_package.zip"
set "nrfutil_file=C:\Users\bpart\AppData\Roaming\Python\Python38\Scripts\adafruit-nrfutil.exe"

@echo off
echo Please note that having multple COM port devices can have unknown behaviour.
echo Please disconnect all other COM port devices other than your BLE device.

for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "com_number=%%i"

if "%com_number%"=="" (
    set /p com_number="Failed to detect COM port. Enter the COM port number: "
)

set com_port=COM%com_number%

echo Checking status for %com_port%...

mode %com_port% | find /i "%com_port%" >nul

if %errorlevel% equ 0 (
    echo The COM port %com_port% is available.

    if exist "%nrfutil_file%" (
        if exist "%op_package_file%" (
            "%nrfutil_file%" --verbose dfu serial -pkg "%op_package_file%" -p %com_port% -b 115200 --singlebank
        ) else (
            echo "%op_package_file%" file not found. Make sure to build the s140 project before running the script
        )
    ) else (
        echo "adafruit-nrfutil.exe" does not exist. Please follow readme file to learn how to install the utility
    )
) else (
  echo The COM port %com_port% is not available.
)

pause

