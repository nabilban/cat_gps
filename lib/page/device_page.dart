import 'package:cat_gps/model/gps_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key, required this.device});
  final String device;

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  List<GpsDetail> deviceHistory = [];
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
        deviceHistory = List<GpsDetail>.from(
          response.data.map(
            (item) => GpsDetail(
              id: item['id'] as String,
              latlng: LatLng(
                item['data']['lat'] as double,
                item['data']['lng'] as double,
              ),
              timeStamp: DateTime.parse(item['data']['timestamp']),
            ),
          ),
        );
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
          Expanded(
            child: ListView.builder(
              itemCount: deviceHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Location $index'),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Latitude: ${deviceHistory[index].latlng.latitude}'),
                        Text(
                            'Longitude: ${deviceHistory[index].latlng.longitude}'),
                        Text('Time: ${deviceHistory[index].timeStamp}'),
                      ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
