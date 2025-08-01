# BleIrRemote
Infrared Remote for Sony Bravia TV to connect with phone Via Bluetooth and control traditional(NonSmart) TV using phone app

***Note from developer: I do intend to come back and fix the issues but until I can make time for that some day, you may consider this project as abandoned.***

Hardware required:
- pca10040 (For development and debugging)
    - [Ordering link](https://www.mouser.com/ProductDetail/Nordic-Semiconductor/NRF52-DK?qs=79dOc3%2F91%2FccrafuGv4fOw%3D%3D)
    - [Documentation link](https://developer.nordicsemi.com/nRF_Connect_SDK/doc/1.2.1/zephyr/boards/arm/nrf52_pca10040/doc/index.html)
- Seeed Studio XIAO nrf52840
    - [Ordering link](https://www.seeedstudio.com/Seeed-XIAO-BLE-nRF52840-p-5201.html)
    - [Documentation link](https://wiki.seeedstudio.com/XIAO_BLE/)
- LiPo Battery
    - [Ordering link](https://www.amazon.com/dp/B095W4HS75)
- Resistor 200 Ohm
- 3D printer (Not necessary but if you are interested in creating an enclosure for the setup. Refer to Readme for mechanical section)

Softwares required:
- [Segger Embedded Studio V6.30](https://www.segger.com/downloads/embedded-studio/)
- [python 3.8.10](https://www.python.org/downloads/release/python-3810/)
- [adafruit-nrfutil](https://github.com/adafruit/Adafruit_nRF52_nrfutil)
- [Visual Studio 2022](https://visualstudio.microsoft.com/downloads/)
- [Visual Studio package Plugin.BLE v2.1.3](https://www.nuget.org/packages/Plugin.BLE/#supportedframeworks-body-tab)

3D print specs:
- Slicer: Cura
- Design software: Fusion 360
- Printer: Ender 3 Neo
- Infill: 20%

Note about mechanical assembly:
I apologize for poor documentation for mechanical assembly. I hope the images explain a little more about how it is assembled.
I wanted to keep the unit as compact as possible. Hence, I sqeezed in a resistor on the wire that connects the IR led to the GPIO of nrf52840 board.

Known issues:
- Board suddenly stops responding the app and the app needs to be restarted sometimes. If the board needs a reset, the hole on the top can be used to access the reset button on the XIAO board.
