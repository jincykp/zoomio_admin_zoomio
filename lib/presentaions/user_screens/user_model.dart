class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl; // Added photoUrl field

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl, // Include photoUrl in the constructor
  });

  // Create UserModel from a map with optional photoUrl
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      photoUrl: map['photoUrl'], // Map the photoUrl from Firestore
    );
  }

  // Getter for photoUrl (this will be used in the UI)
  String? get profileImageUrl => photoUrl;
}
