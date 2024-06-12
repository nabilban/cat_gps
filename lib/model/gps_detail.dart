import 'package:latlong2/latlong.dart';

class GpsDetail {
  final String id;
  final LatLng latlng;
  final DateTime timeStamp;

  GpsDetail({
    required this.latlng,
    required this.id,
    required this.timeStamp,
  });
}
