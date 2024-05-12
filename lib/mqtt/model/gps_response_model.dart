import 'dart:convert';

import 'package:latlong2/latlong.dart';

class GpsResponseModel {
  final String? id;
  final String? type;
  final LatLng latLng;

  GpsResponseModel(
    this.latLng, {
    this.id,
    this.type,
  });

  factory GpsResponseModel.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return GpsResponseModel(
      LatLng(map['data']['lat'], map['data']['lng']),
      id: map['id'],
      type: map['type'],
    );
  }
}
