class ProfileModel {
  final String? id; // Nullable ID for Firestore documents
  final String? driverId; // Link with Firebase Authentication
  final String name;
  final int age;
  final String contactNumber;
  final String? gender; // Added gender
  final String? vehiclePreference;
  final int experienceYears;
  final String? profileImageUrl;
  final String? licenseImageUrl;
  final bool isOnline; // Added online status

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

  // Factory method to create an instance from a Map
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
      isOnline: map['isOnline'] as bool, // Fetch online status
    );
  }

  // Convert the ProfileModel to a Map
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
      'isOnline': isOnline, // Add online status
    };
  }

  // CopyWith method for updating the model
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
    );
  }
}
