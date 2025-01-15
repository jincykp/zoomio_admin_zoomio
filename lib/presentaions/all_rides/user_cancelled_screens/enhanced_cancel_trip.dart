import 'package:zoomio_adminzoomio/presentaions/all_rides/trip_model.dart';
import 'package:zoomio_adminzoomio/presentaions/driver_screens/driver_profilemodel.dart';
import 'package:zoomio_adminzoomio/presentaions/user_screens/user_model.dart';

class EnhancedCancelledTrip extends Trip {
  final UserModel? userDetails;
  final ProfileModel? driverDetails;
  final List<String> cancellationReasons;
  final String otherReason;
  final int cancelledAt;

  EnhancedCancelledTrip({
    required Trip trip,
    this.userDetails,
    this.driverDetails,
    required this.cancellationReasons,
    required this.otherReason,
    required this.cancelledAt,
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

  /// Factory constructor to create an EnhancedCancelledTrip from an existing Trip
  factory EnhancedCancelledTrip.fromTrip({
    required Trip trip,
    required UserModel? userDetails,
    required ProfileModel? driverDetails,
    required Map<String, dynamic> cancellationData,
  }) {
    // Handle reasonsList conversion safely
    List<String> parseReasonsList(dynamic reasonsData) {
      if (reasonsData is List) {
        return reasonsData.map((e) => e.toString()).toList();
      } else if (reasonsData is Map) {
        return reasonsData.values.map((e) => e.toString()).toList();
      }
      return [];
    }

    // Handle cancelledAt timestamp conversion safely
    int parseCancelledAt(dynamic cancelledAtData) {
      print(
          'CancelledAt data: $cancelledAtData (${cancelledAtData.runtimeType})');
      try {
        if (cancelledAtData == null) {
          return trip.timestamp as int; // Ensure this cast is safe
        }

        if (cancelledAtData is int) {
          return cancelledAtData;
        }

        if (cancelledAtData is String) {
          return int.tryParse(cancelledAtData) ?? trip.timestamp as int;
        }

        if (cancelledAtData is double) {
          return cancelledAtData.toInt();
        }

        return trip.timestamp as int;
      } catch (e) {
        print('Error parsing cancelledAt: $e');
        return trip.timestamp as int;
      }
    }

    return EnhancedCancelledTrip(
      trip: trip,
      userDetails: userDetails,
      driverDetails: driverDetails,
      cancellationReasons: parseReasonsList(cancellationData['reasonsList']),
      otherReason: cancellationData['otherReason']?.toString() ?? '',
      cancelledAt: parseCancelledAt(cancellationData['cancelledAt']),
    );
  }

  /// Get formatted cancellation time
  String get formattedCancelTime {
    return DateTime.fromMillisecondsSinceEpoch(cancelledAt).toString();
  }

  /// Helper method to check if the trip was cancelled by the user
  bool get isCancelledByUser => status.toLowerCase() == 'customer_cancelled';

  /// Get all reasons, including 'otherReason' if present
  List<String> get allReasons {
    final reasons = List<String>.from(cancellationReasons);
    if (otherReason.isNotEmpty) {
      reasons.add(otherReason);
    }
    return reasons;
  }

  /// Get time difference between trip creation and cancellation
  Duration get timeToCancellation {
    int parseToInt(dynamic value) {
      if (value is int) {
        return value;
      } else if (value is String) {
        return int.tryParse(value) ?? 0; // Try parsing the string
      } else if (value is double) {
        return value.toInt(); // Convert double to int
      } else {
        return 0; // Default fallback
      }
    }

    final startTime = parseToInt(timestamp);
    final endTime = parseToInt(cancelledAt);

    return Duration(milliseconds: endTime - startTime);
  }

  /// Helper method to get formatted wait time
  String get formattedWaitTime {
    final duration = timeToCancellation;
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Create a map of the enhanced trip data
  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'pickupLocation': pickupLocation,
      'dropOffLocation': dropOffLocation,
      'status': status,
      'totalPrice': totalPrice,
      'timestamp': timestamp,
      'userId': userId,
      'driverId': driverId,
      'vehicleDetails': vehicleDetails,
      'cancellationReasons': cancellationReasons,
      'otherReason': otherReason,
      'cancelledAt': cancelledAt,
      'userDetails': userDetails != null
          ? {
              'id': userDetails!.id,
              'email': userDetails!.email,
              'displayName': userDetails!.displayName,
              'phone': userDetails!.phone,
              'photoUrl': userDetails!.photoUrl,
            }
          : null,
      'driverDetails': driverDetails != null
          ? {
              'id': driverDetails!.id,
              'name': driverDetails!.name,
              'contactNumber': driverDetails!.contactNumber,
              'vehiclePreference': driverDetails!.vehiclePreference,
              'profileImageUrl': driverDetails!.profileImageUrl,
              'isOnline': driverDetails!.isOnline,
            }
          : null,
    };
  }

  @override
  String toString() {
    return 'EnhancedCancelledTrip('
        'tripId: $tripId, '
        'user: ${userDetails?.displayName}, '
        'driver: ${driverDetails?.name}, '
        'cancelled: $formattedCancelTime, '
        'reasons: $allReasons)';
  }
}
