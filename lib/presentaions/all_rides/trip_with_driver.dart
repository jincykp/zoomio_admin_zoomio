import 'package:zoomio_adminzoomio/presentaions/all_rides/trip_model.dart';
import 'package:zoomio_adminzoomio/presentaions/driver_screens/driver_profilemodel.dart';

class TripWithDriver {
  final Trip trip;
  final ProfileModel? driver;

  TripWithDriver({
    required this.trip,
    this.driver,
  });
}
