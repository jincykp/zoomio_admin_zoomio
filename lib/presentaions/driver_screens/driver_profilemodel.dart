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
    };
  }
}
