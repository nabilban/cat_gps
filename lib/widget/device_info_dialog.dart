import 'package:cat_gps/helper/gps_helper.dart';
import 'package:cat_gps/mqtt/model/gps_response_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeviceInfoDialog extends StatelessWidget {
  const DeviceInfoDialog({super.key, required this.device});

  final GpsResponseModel device;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          GPSHelper.connectionStatus(device),
          SizedBox(width: 8),
          Text(
            device.id ?? 'unknown',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Latitude'),
                  Text('Longitude'),
                  Text('Status'),
                  Text('Last Seen'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(' : ${device.latLng?.latitude ?? 0}'),
                  Text(' : ${device.latLng?.longitude ?? 0}'),
                  Text(' : ${GPSHelper.getStatus(device).name}'),
                  Text(
                      ' : ${device.timeStamp != null ? DateFormat('dd-MM-yyyy HH:mm:ss').format(device.timeStamp!) : '-'}'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close')),
          )
        ],
      ),
    );
  }
}
