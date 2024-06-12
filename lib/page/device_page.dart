import 'package:cat_gps/model/gps_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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

  final MapController mapController = MapController();

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
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(-3.034442, 104.713087),
          initialZoom: 20,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.cat-gps.app',
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: deviceHistory.map((e) => e.latlng).toList(),
                strokeWidth: 3,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
