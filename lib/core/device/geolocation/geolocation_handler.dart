import 'dart:async';

import 'package:emsa/location/domain/entities/position.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorHandler {
  static Future<bool> gpsIsEnabled() async {
    final bool isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    return isGpsEnabled;
  }

  static Future<StreamSubscription?> getGpsServiceSubscription(callback) async {
    StreamSubscription? gpsServiceSubscription =
        Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = (event.index == 1) ? true : false;
      callback(isEnabled);
    });

    return gpsServiceSubscription;
  }

  static Future<Position> getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    return position;
  }

  static StreamSubscription<Position>? getPositionStream(callback) {
    StreamSubscription<Position>? positionStream =
        Geolocator.getPositionStream().listen((event) {
      final position = event;
      callback(position);
    });

    return positionStream;
  }
}
