import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:emsa/location/BLoC/location_bloc.dart';
import 'package:emsa/map/themes/uber.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  late StreamSubscription _positionStreamSubscription;

  GoogleMapController? _mapController;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitialzedEvent>(_onInitMap);
    on<StopFollowingUserEvent>(_stopFollowingUser);
    on<StartFollowingUserEvent>(_startFollowingUser);

    _initListenerUserPosition();
  }

  void _onInitMap(OnMapInitialzedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));

    emit(state.copyWith(isMapInitialized: true));
  }

  void _stopFollowingUser(
      StopFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: false));
  }

  void _startFollowingUser(
      StartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));

    if (locationBloc.state.lastKnownLocation == null) return;
    moveCamera(locationBloc.state.lastKnownLocation!);
  }

  void _initListenerUserPosition() {
    _positionStreamSubscription = locationBloc.stream.listen((locationState) {
      if (!state.isFollowingUser) return;
      if (!locationState.followingUser) return;
      if (locationState.lastKnownLocation == null) return;

      moveCamera(locationState.lastKnownLocation!);
    });
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    _positionStreamSubscription.cancel();
    return super.close();
  }
}
