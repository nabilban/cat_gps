import 'package:cat_gps/mqtt/model/gps_response_model.dart';
import 'package:cat_gps/mqtt/state/mqtt_app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum DeviceStatus { connected, disconnect, lost }

class DevicesWidget extends StatelessWidget {
  const DevicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MQTTAppState>(
      builder: (context, state, child) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: state.gpsDevices.map((device) {
              return ElevatedButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _connectionStatus(device),
                    const SizedBox(width: 8),
                    Text(device.id ?? 'unknown', style: _textStyle()),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  TextStyle _textStyle() => const TextStyle(fontSize: 16);

  DeviceStatus _getStatus(GpsResponseModel gps) {
    if (gps.status) {
      return DeviceStatus.connected;
    }
    if (DateTime.now().difference(gps.timeStamp!).inMinutes < 1) {
      return DeviceStatus.lost;
    }
    return DeviceStatus.disconnect;
  }

  Widget _connectionStatus(GpsResponseModel gps) {
    switch (_getStatus(gps)) {
      case DeviceStatus.connected:
        return const Text('🟢');
      case DeviceStatus.disconnect:
        return const Text('🔴');
      case DeviceStatus.lost:
        return const Text('🟡');
      default:
        return const Text('🟠');
    }
  }
}
