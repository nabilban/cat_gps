import 'package:cat_gps/page/device_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SelectDevicePage extends StatefulWidget {
  const SelectDevicePage({super.key});

  @override
  State<SelectDevicePage> createState() => _SelectDevicePageState();
}

class _SelectDevicePageState extends State<SelectDevicePage> {
  List<String> devices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  Future<void> fetchDevices() async {
    try {
      final response = await Dio().get('https://gps.nabilban.lol/api/devices/');
      setState(() {
        isLoading = false;
        devices = List<String>.from(response.data);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade200,
        title: const Text('Select Device'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select a device to track :',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  if (devices.isEmpty)
                    const Text('No devices found')
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(
                                "Device Name : ${devices[index]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DevicePage(
                                      device: devices[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
