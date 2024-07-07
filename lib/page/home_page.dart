import 'package:cat_gps/mqtt/mqtt_manager.dart';
import 'package:cat_gps/mqtt/state/mqtt_app_state.dart';
import 'package:cat_gps/page/select_device_page.dart';
import 'package:cat_gps/widget/device_info_dialog.dart';
import 'package:cat_gps/widget/devices_widget.dart';
import 'package:cat_gps/widget/pulse_animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  late MQTTManager manager;
  late MQTTAppState appState;
  final MapController mapController = MapController();
  bool shouldRestart = false;

  void configAndConnect() {
    manager = MQTTManager(
        host: 'broker.mqtt-dashboard.com',
        topic: 'cat-gps',
        identifier: const Uuid().v1(),
        state: appState);
    manager.initializeMQTTClient();
    manager.connect();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => configAndConnect());
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<MQTTAppState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(shouldRestart ? 'Please Restart' : 'GPS Kucing 😸'),
        actions: [
          Row(
            children: [
              const Text('status: '),
              Consumer<MQTTAppState>(
                builder: (context, state, widget) {
                  return Text(
                    state.getAppConnectionState.toString().split('.').last,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  manager.connect();
                },
              ),
            ],
          ),
        ],
      ),
      body: Consumer<MQTTAppState>(builder: (context, state, widget) {
        return Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: const MapOptions(
                initialCenter: LatLng(-3.034442, 104.713087),
                initialZoom: 10,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.cat-gps.app',
                ),
                if (state.gpsHistory.isNotEmpty)
                  MarkerLayer(
                    markers: state.gpsHistory
                        .map(
                          (e) => Marker(
                            rotate: true,
                            width: 100,
                            height: 50,
                            point: e.latLng!,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          DeviceInfoDialog(device: e),
                                    );
                                  },
                                  child: const PulseAnimatedWidget(
                                    icon: Text(
                                      '😸',
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Text(e.id ?? 'unknown'),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
            Positioned(
              top: 10,
              left: 10,
              child: DevicesWidget(
                onPresssed: (device) {
                  if (device.latLng != null) {
                    return mapController.move(device.latLng!, 20);
                  }
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FilledButton(
        child: const Text(
          'Select Device',
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectDevicePage(),
            ),
          );
        },
      ),
    );
  }
}
