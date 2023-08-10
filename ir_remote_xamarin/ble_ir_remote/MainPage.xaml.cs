using Plugin.BLE;
using Plugin.BLE.Abstractions;
using Plugin.BLE.Abstractions.Contracts;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace ble_ir_remote
{
    public partial class MainPage : ContentPage
    {
        IBluetoothLE ble;
        IAdapter adapter;
        ObservableCollection<IDevice> deviceList;

        public MainPage()
        {
            InitializeComponent();

            ble = CrossBluetoothLE.Current;
            adapter = CrossBluetoothLE.Current.Adapter;
            deviceList = new ObservableCollection<IDevice>();

            Devices_ListView.ItemsSource = deviceList;
        }

        private void OpenDeviceList(object sender, EventArgs e)
        {
            if (Devices_ListView.IsVisible == false)
            {
                Devices_ListView.IsVisible = true;
                ScanDevices();
            }
            else
            {
                Devices_ListView.IsVisible = false;
            }
        }

        private void Devices_ListView_ItemSelected(object sender, SelectedItemChangedEventArgs e)
        {
            var selectedDevice = (IDevice)e.SelectedItem;
            if (selectedDevice != null)
            {
                int retries = 3;
                ble.Adapter.ConnectToDeviceAsync(selectedDevice);
                while (ble.Adapter.ConnectedDevices.Count == 0 && retries-- >= 0)
                {
                    Thread.Sleep(100);
                }
                if(ble.Adapter.ConnectedDevices.Count == 0)
                {
                    // show toast
                }
                else
                {
                    Connection_Button.Text = selectedDevice.Name;
                }
                Devices_ListView.IsVisible = false;
            }
        }

        private async void ScanDevices()
        {
            deviceList.Clear();
            adapter.DeviceDiscovered += (s, a) =>
            {
                var bleIrUuid = new byte[] {0x00, 0x00, 0x14, 0x84, 0x12, 0x12, 0xef, 0xde,
                                    0x15, 0x23, 0x78, 0x5f, 0xea, 0xbc, 0xd1, 0x23 };
                var advRecord = a.Device.AdvertisementRecords;

                var uuidRec = advRecord.FirstOrDefault(r => r.Type == AdvertisementRecordType.UuidsComplete128Bit);

                if (uuidRec != null)
                {
                    if (uuidRec.Data.SequenceEqual(bleIrUuid))
                        deviceList.Add(a.Device);
                }
            };

            if (!adapter.IsScanning)
            {
                await adapter.StartScanningForDevicesAsync();
            }
        }

        private async void Button_Clicked(object sender, EventArgs e)
        {
            Button b = (Button)sender;
            var connDevice = adapter.ConnectedDevices[0]; // should only have one device for this appln

            var uid = Guid.Parse("00001484-1212-efde-1523-785feabcd123");
            var srv = await connDevice.GetServiceAsync(uid);
            //var services = await connDevice.GetServicesAsync();
            var characteristic = await srv.GetCharacteristicsAsync();
            var charFirst = characteristic.First();

            byte[] data = new byte[2];
            switch (b.AutomationId)
            {
                case "Power":
                    data[0] = 0x90;
                    data[1] = 0x0a;
                    await charFirst.WriteAsync(data);
                    break;
                case "VolUp":
                    data[0] = 0x90;
                    data[1] = 0x04;
                    await charFirst.WriteAsync(data);
                    break;
                case "VolDn":
                    data[0] = 0x90;
                    data[1] = 0x0c;
                    await charFirst.WriteAsync(data);
                    break;
                case "Mute":
                    data[0] = 0x90;
                    data[1] = 0x02;
                    await charFirst.WriteAsync(data);
                    break;
                default:
                    break;
            }
        }
    }
}
