import 'package:cat_gps/mqtt/mqtt_manager.dart';
import 'package:cat_gps/mqtt/state/mqtt_app_state.dart';
import 'package:cat_gps/page/select_device_page.dart';
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
    Future.delayed(const Duration(seconds: 3), () => configAndConnect());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<MQTTAppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat GPS'),
        backgroundColor: Colors.yellow.shade200,
        actions: [
          Row(
            children: [
              const Text('Connection: '),
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
        return Container(
          padding: const EdgeInsets.all(10),
          child: FlutterMap(
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
                          point: e.latLng,
                          width: 200,
                          height: 200,
                          child: const Icon(Icons.catching_pokemon,
                              color: Colors.red, size: 25),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        );
      }),
      floatingActionButton: FilledButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.yellow.shade200),
        ),
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
