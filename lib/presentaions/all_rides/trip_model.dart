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

  // Constructor for Trip
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

  // Factory constructor to create a Trip object from a JSON map
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

  // Method to convert a Trip object to JSON format
  Map<String, dynamic> toJson() {
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
    };
  }

  // CopyWith method to create a new instance with modified values
  Trip copyWith({
    String? tripId,
    String? pickupLocation,
    String? dropOffLocation,
    String? status,
    double? totalPrice,
    String? timestamp,
    String? userId,
    String? driverId,
    Map<String, dynamic>? vehicleDetails,
  }) {
    return Trip(
      tripId: tripId ?? this.tripId,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropOffLocation: dropOffLocation ?? this.dropOffLocation,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      driverId: driverId ?? this.driverId,
      vehicleDetails: vehicleDetails ?? this.vehicleDetails,
    );
  }
}
