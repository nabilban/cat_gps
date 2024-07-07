import 'dart:convert';
import 'dart:developer';

import 'package:cat_gps/mqtt/model/gps_response_model.dart';
import 'package:flutter/cupertino.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class MQTTAppState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;

  final List<GpsResponseModel> _gpsHistory = [];
  final List<GpsResponseModel> _gpsStatuses = [];

  void handleReceiveMessage(String message) {
    final messageJson = jsonDecode(message);
    if (messageJson['type'] == 'gps') {
      if (messageJson['status']) {
        handleSuccessMessage(messageJson);
      } else {
        handleFailedMessage(messageJson);
      }
    }
  }

  void handleSuccessMessage(Map<String, dynamic> messageJson) {
    final gpsResponseModel = GpsResponseModel.fromSuccessJson(messageJson);
    _gpsHistory.removeWhere((element) => element.id == gpsResponseModel.id);
    _gpsHistory.add(gpsResponseModel);
    _gpsStatuses.removeWhere((element) => element.id == gpsResponseModel.id);
    _gpsStatuses.add(gpsResponseModel);
    notifyListeners();
  }

  void handleFailedMessage(Map<String, dynamic> messageJson) {
    final gpsResponseModel = GpsResponseModel.fromFailedJson(messageJson);
    _gpsStatuses.removeWhere((element) => element.id == gpsResponseModel.id);
    _gpsStatuses.add(gpsResponseModel);
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  List<GpsResponseModel> get gpsHistory => _gpsHistory;
  List<GpsResponseModel> get gpsDevices => _gpsStatuses;

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
}
