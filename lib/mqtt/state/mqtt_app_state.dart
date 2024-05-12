import 'package:cat_gps/mqtt/model/gps_response_model.dart';
import 'package:flutter/cupertino.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class MQTTAppState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;

  final List<GpsResponseModel> _gpsHistory = [];

  void addGpsHistory(String message) {
    print('hello');
    final gpsResponseModel = GpsResponseModel.fromJson(message);
    _gpsHistory.add(gpsResponseModel);
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  List<GpsResponseModel> get gpsHistory => _gpsHistory;

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
}
