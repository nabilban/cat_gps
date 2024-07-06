import 'package:cat_gps/model/date_filter.dart';
import 'package:cat_gps/model/gps_detail.dart';
import 'package:cat_gps/widget/app_date_picker.dart';
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

  DateTime startedDate = DateTime.now().subtract(const Duration(hours: 1));

  final MapController mapController = MapController();

  DateFilter? datefilter;

  @override
  void initState() {
    super.initState();
    getDeviceHistory();
  }

  void getDeviceHistory() async {
    try {
      final response = await Dio().get(
        'https://gps2.nabilban.lol/api/gps-data?id=${widget.device}&start=${datefilter?.startDate.toIso8601String()}&end=${datefilter?.endDate.toIso8601String()}',
      );
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('${widget.device} history'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              final DateFilter data = await showDialog(
                context: context,
                builder: (context) {
                  return const AppDatePicker();
                },
              );
              setState(
                () {
                  datefilter = data;
                },
              );
              getDeviceHistory();
            },
          )
        ],
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
