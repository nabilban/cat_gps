import 'package:cat_gps/mqtt/mqtt_manager.dart';
import 'package:cat_gps/mqtt/state/mqtt_app_state.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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
  Widget build(BuildContext context) {
    appState = Provider.of<MQTTAppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat GPS'),
        backgroundColor: Colors.yellow.shade200,
        actions: [
          IconButton.outlined(
              onPressed: () {
                configAndConnect();
              },
              icon: const Icon(Icons.widgets))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(-3.034442, 104.713087),
            initialZoom: 10,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.cat-gps.app',
            ),
            const MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(-3.034442, 104.713087),
                  width: 200,
                  height: 200,
                  child:
                      Icon(Icons.catching_pokemon, color: Colors.red, size: 25),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
