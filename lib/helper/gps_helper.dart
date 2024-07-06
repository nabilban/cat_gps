import 'package:cat_gps/mqtt/model/gps_response_model.dart';
import 'package:cat_gps/widget/devices_widget.dart';
import 'package:flutter/material.dart';

class GPSHelper {
  static DeviceStatus getStatus(GpsResponseModel gps) {
    if (gps.status) {
      return DeviceStatus.connected;
    }
    if (DateTime.now().difference(gps.timeStamp!).inMinutes < 1) {
      return DeviceStatus.lost;
    }
    return DeviceStatus.disconnect;
  }

  static Widget connectionStatus(GpsResponseModel gps) {
    switch (GPSHelper.getStatus(gps)) {
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
