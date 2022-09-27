import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:emsa/core/device/geolocation/geolocation_handler.dart';
import 'package:emsa/core/device/permission/permission_handler.dart';
import 'package:equatable/equatable.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSubscription;

  GpsBloc()
      : super(const GpsState(
          isGpsEnabled: false,
          isGpsPermissionGranted: false,
        )) {
    on<GpsAndPermissionEvent>(_onGpsAndPermissionEvent);

    _init();
  }

  void _onGpsAndPermissionEvent(
      GpsAndPermissionEvent event, Emitter<GpsState> emit) {
    emit(state.copyWith(
      isGpsEnabled: event.isGpsEnabled,
      isGpsPermissionGranted: event.isGpsPermissionGranted,
    ));
  }

  Future<void> _init() async {
    final gpsStatus =
        await Future.wait([_checkGpsStatus(), _checkGpsPermission()]);

    add(GpsAndPermissionEvent(
        isGpsEnabled: gpsStatus[0], isGpsPermissionGranted: gpsStatus[1]));
  }

  Future<bool> _checkGpsStatus() async {
    gpsServiceSubscription = await GeolocatorHandler.getGpsServiceSubscription(
      (isEnabled) => add(GpsAndPermissionEvent(
          isGpsEnabled: isEnabled,
          isGpsPermissionGranted: state.isGpsPermissionGranted)),
    );

    final bool isGpsEnabled = await GeolocatorHandler.gpsIsEnabled();

    return isGpsEnabled;
  }

  Future<bool> _checkGpsPermission() async {
    return await PermissionDevice.locationIsGranted();
  }

  Future<void> askGpsAcces() async {
    PermissionDevice.locationRequest(
      () => add(GpsAndPermissionEvent(
          isGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: true)),
      () => add(GpsAndPermissionEvent(
          isGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: false)),
    );
  }

  @override
  Future<void> close() {
    gpsServiceSubscription?.cancel();

    return super.close();
  }
}
