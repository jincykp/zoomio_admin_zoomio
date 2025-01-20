import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String? id;
  final String? driverId;
  final String name;
  final int age;
  final String contactNumber;
  final String? gender;
  final String? vehiclePreference;
  final int experienceYears;
  final String? profileImageUrl;
  final String? licenseImageUrl;
  final bool isOnline;
  // New fields for cancellation tracking
  final int cancelCount;
  final DateTime? lastCancellationDate;
  final bool isBlocked;
  final DateTime? blockedAt;
  final String? blockReason;

  ProfileModel({
    this.id,
    this.driverId,
    required this.name,
    required this.age,
    required this.contactNumber,
    this.gender,
    this.vehiclePreference,
    required this.experienceYears,
    this.profileImageUrl,
    this.licenseImageUrl,
    required this.isOnline,
    this.cancelCount = 0,
    this.lastCancellationDate,
    this.isBlocked = false,
    this.blockedAt,
    this.blockReason,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String?,
      driverId: map['userId'] as String?,
      name: map['name'] as String,
      age: map['age'] as int,
      contactNumber: map['contactNumber'] as String,
      gender: map['gender'] as String?,
      vehiclePreference: map['vehiclePreference'] as String?,
      experienceYears: map['experienceYears'] as int,
      profileImageUrl: map['profileImageUrl'] as String?,
      licenseImageUrl: map['licenseImageUrl'] as String?,
      isOnline: map['isOnline'] as bool,
      // Parse new fields
      cancelCount: map['cancelCount'] as int? ?? 0,
      lastCancellationDate: map['lastCancellationDate'] != null
          ? (map['lastCancellationDate'] as Timestamp).toDate()
          : null,
      isBlocked: map['isBlocked'] as bool? ?? false,
      blockedAt: map['blockedAt'] != null
          ? (map['blockedAt'] as Timestamp).toDate()
          : null,
      blockReason: map['blockReason'] as String?,
    );
  }

  factory ProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProfileModel.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? driverId,
      'userId': driverId ?? id,
      'name': name,
      'age': age,
      'contactNumber': contactNumber,
      'gender': gender,
      'vehiclePreference': vehiclePreference,
      'experienceYears': experienceYears,
      'profileImageUrl': profileImageUrl,
      'licenseImageUrl': licenseImageUrl,
      'isOnline': isOnline,
      // Add new fields
      'cancelCount': cancelCount,
      'lastCancellationDate': lastCancellationDate != null
          ? Timestamp.fromDate(lastCancellationDate!)
          : null,
      'isBlocked': isBlocked,
      'blockedAt': blockedAt != null ? Timestamp.fromDate(blockedAt!) : null,
      'blockReason': blockReason,
    };
  }

  // Helper method to check if cancellation count should be reset
  bool shouldResetCancelCount() {
    if (lastCancellationDate == null) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastCancel = DateTime(lastCancellationDate!.year,
        lastCancellationDate!.month, lastCancellationDate!.day);

    return !lastCancel.isAtSameMomentAs(today);
  }

  // Create a copy of the model with updated fields
  ProfileModel copyWith({
    String? id,
    String? driverId,
    String? name,
    int? age,
    String? contactNumber,
    String? gender,
    String? vehiclePreference,
    int? experienceYears,
    String? profileImageUrl,
    String? licenseImageUrl,
    bool? isOnline,
    int? cancelCount,
    DateTime? lastCancellationDate,
    bool? isBlocked,
    DateTime? blockedAt,
    String? blockReason,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      name: name ?? this.name,
      age: age ?? this.age,
      contactNumber: contactNumber ?? this.contactNumber,
      gender: gender ?? this.gender,
      vehiclePreference: vehiclePreference ?? this.vehiclePreference,
      experienceYears: experienceYears ?? this.experienceYears,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      licenseImageUrl: licenseImageUrl ?? this.licenseImageUrl,
      isOnline: isOnline ?? this.isOnline,
      cancelCount: cancelCount ?? this.cancelCount,
      lastCancellationDate: lastCancellationDate ?? this.lastCancellationDate,
      isBlocked: isBlocked ?? this.isBlocked,
      blockedAt: blockedAt ?? this.blockedAt,
      blockReason: blockReason ?? this.blockReason,
    );
  }

  // Helper method to increment cancellation count
  ProfileModel incrementCancelCount() {
    final now = DateTime.now();
    int newCount = shouldResetCancelCount() ? 1 : cancelCount + 1;
    bool shouldBlock = newCount >= 3;

    return copyWith(
      cancelCount: newCount,
      lastCancellationDate: now,
      isBlocked: shouldBlock ? true : isBlocked,
      blockedAt: shouldBlock ? now : blockedAt,
      blockReason:
          shouldBlock ? 'Exceeded daily cancellation limit' : blockReason,
    );
  }
}
