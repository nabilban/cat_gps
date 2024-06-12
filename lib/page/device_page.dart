import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key, required this.device});
  final String device;

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  List<String> deviceHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDeviceHistory();
  }

  void getDeviceHistory() async {
    try {
      final response = await Dio()
          .get('https://gps.nabilban.lol/api/gps-data?id=${widget.device}');
      setState(() {
        isLoading = false;
        deviceHistory = List<String>.from(response.data);
        print('print $deviceHistory');
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
        title: Text('${widget.device} history'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('This is the history of ${widget.device} : '),
          Expanded(
            child: ListView.builder(
              itemCount: deviceHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text('Location $index'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Latitude: ${deviceHistory[index]}'),
                        Text('Longitude: ${deviceHistory[index]}'),
                        Text('Time: ${deviceHistory[index]}'),
                      ],
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
