class Trip {
  final String tripId;
  final String pickupLocation;
  final String dropOffLocation;
  final String status;
  final double totalPrice;
  final String timestamp;
  final Map<String, dynamic>? vehicleDetails;
  final String userId;
  final String? driverId;

  Trip({
    required this.tripId,
    required this.pickupLocation,
    required this.dropOffLocation,
    required this.status,
    required this.totalPrice,
    required this.timestamp,
    required this.userId,
    this.driverId,
    this.vehicleDetails,
  });

  factory Trip.fromJson(Map<dynamic, dynamic> json, String id) {
    return Trip(
      tripId: id,
      pickupLocation: json['pickupLocation']?.toString() ?? 'Not Provided',
      dropOffLocation: json['dropOffLocation']?.toString() ?? 'Not Provided',
      status: json['status']?.toString() ?? 'Unknown',
      totalPrice: (json['totalPrice'] is num)
          ? (json['totalPrice'] as num).toDouble()
          : 0.0,
      timestamp: json['timestamp']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      driverId: json['driverId']?.toString(),
      vehicleDetails: json['vehicleDetails'] is Map
          ? Map<String, dynamic>.from(json['vehicleDetails'] as Map)
          : null,
    );
  }
}
