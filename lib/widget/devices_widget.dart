import 'package:cat_gps/helper/gps_helper.dart';
import 'package:cat_gps/mqtt/model/gps_response_model.dart';
import 'package:cat_gps/mqtt/state/mqtt_app_state.dart';
import 'package:cat_gps/widget/device_info_dialog.dart';
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
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => DeviceInfoDialog(device: device));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GPSHelper.connectionStatus(device),
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
}

class GpsHelper {}
