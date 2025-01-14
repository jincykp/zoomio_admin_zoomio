import 'package:zoomio_adminzoomio/presentaions/all_rides/trip_model.dart';
import 'package:zoomio_adminzoomio/presentaions/driver_screens/driver_profilemodel.dart';
import 'package:zoomio_adminzoomio/presentaions/user_screens/user_model.dart';

class EnhancedTrip extends Trip {
  final UserModel? userDetails;
  final ProfileModel? driverDetails;

  EnhancedTrip({
    required Trip trip,
    this.userDetails,
    this.driverDetails,
  }) : super(
          tripId: trip.tripId,
          pickupLocation: trip.pickupLocation,
          dropOffLocation: trip.dropOffLocation,
          status: trip.status,
          totalPrice: trip.totalPrice,
          timestamp: trip.timestamp,
          userId: trip.userId,
          driverId: trip.driverId,
          vehicleDetails: trip.vehicleDetails,
        );
}
