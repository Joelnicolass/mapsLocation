import 'package:emsa/gps/BLoC/gps_bloc.dart';
import 'package:emsa/gps/ui/views/gps_disabled.dart';
import 'package:emsa/map/ui/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GPSScreen extends StatelessWidget {
  const GPSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GpsBloc, GpsState>(
      builder: (_, gps) {
        if (gps.isReady) {
          return MapScreen();
        }
        return const GPSDisabledView();
      },
    );
  }
}
