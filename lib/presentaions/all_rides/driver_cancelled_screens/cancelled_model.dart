class DriverCancelledBooking {
  final String bookingId;
  final String driverId;
  final int cancelledAt;
  final Map<String, dynamic>? driverDetails;
  final Map<String, dynamic>? userDetails;
  final String? pickupLocation;
  final String? dropOffLocation;
  final double totalPrice;

  DriverCancelledBooking({
    required this.bookingId,
    required this.driverId,
    required this.cancelledAt,
    this.driverDetails,
    this.userDetails,
    this.pickupLocation,
    this.dropOffLocation,
    required this.totalPrice,
  });

  factory DriverCancelledBooking.fromJson(Map<String, dynamic> json) {
    return DriverCancelledBooking(
      bookingId: json['bookingId'] as String,
      driverId: json['driverId'] as String,
      cancelledAt: json['cancelledAt'] as int,
      driverDetails: json['driverDetails'] as Map<String, dynamic>?,
      userDetails: json['userDetails'] as Map<String, dynamic>?,
      pickupLocation: json['pickupLocation'] as String?,
      dropOffLocation: json['dropOffLocation'] as String?,
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }
}
