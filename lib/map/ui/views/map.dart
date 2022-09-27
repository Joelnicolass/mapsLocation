import 'package:emsa/map/BLoC/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatelessWidget {
  final LatLng initialLocation;

  const MapView({Key? key, required this.initialLocation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final CameraPosition initialCameraPosition =
        CameraPosition(target: initialLocation, zoom: 15);

    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.9,
      child: Listener(
        onPointerMove: (event) {
          mapBloc.add(StopFollowingUserEvent());
        },
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          compassEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,

          onMapCreated: (controller) =>
              mapBloc.add(OnMapInitialzedEvent(controller)),

          // TODO: Markers
          // TODO: polylines
          // TODO: Cuando se mueve el mapa
        ),
      ),
    );
  }
}
