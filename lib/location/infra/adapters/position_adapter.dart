import 'package:emsa/location/domain/entities/position.dart';
import 'package:geolocator/geolocator.dart';

class PositionAdapter {
  static toGeolocatorPosition(DevicePosition position) {
    return Position(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  static toDevicePosition(Position position) {
    return DevicePosition(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
