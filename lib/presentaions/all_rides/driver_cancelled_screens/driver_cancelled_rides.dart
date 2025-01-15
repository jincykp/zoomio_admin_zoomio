import 'package:flutter/material.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';

class DriverCancelledRideScreen extends StatelessWidget {
  const DriverCancelledRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return const Card(
          color: ThemeColors.primaryColor,
          child: ListTile(),
        );
      },
      itemCount: 3,
    );
  }
}
