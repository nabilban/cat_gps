import 'package:latlong2/latlong.dart';

class GpsResponseModel {
  final String? id;
  final String? type;
  final bool status;
  final LatLng? latLng;
  final DateTime? timeStamp;

  GpsResponseModel({
    this.id,
    this.status = false,
    this.type,
    this.timeStamp,
    this.latLng,
  });

  factory GpsResponseModel.fromSuccessJson(Map<String, dynamic> map) {
    return GpsResponseModel(
      latLng: LatLng(map['data']['lat'], map['data']['lng']),
      id: map['id'],
      type: map['type'],
      status: map['status'],
      timeStamp: DateTime.now(),
    );
  }
  factory GpsResponseModel.fromFailedJson(Map<String, dynamic> map) {
    return GpsResponseModel(
      id: map['id'],
      type: map['type'],
      status: map['status'],
      timeStamp: DateTime.now(),
    );
  }
}
