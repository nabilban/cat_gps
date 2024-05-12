import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mqtt_client/mqtt_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat GPS'),
        backgroundColor: Colors.yellow.shade200,
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
              userAgentPackageName: 'com.example.app',
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
