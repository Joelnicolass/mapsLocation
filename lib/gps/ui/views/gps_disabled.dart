import 'package:emsa/core/common/global/globals.dart';
import 'package:emsa/gps/BLoC/gps_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GPSDisabledView extends StatelessWidget {
  const GPSDisabledView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(Globals.GPS_DISABLED_TEXT_ESP),
        ElevatedButton(
          onPressed: () {
            context.read<GpsBloc>().askGpsAcces();
          },
          child: const Text(Globals.GPS_PERMISSION_TEXT_ESP),
        ),
      ],
    );
  }
}
