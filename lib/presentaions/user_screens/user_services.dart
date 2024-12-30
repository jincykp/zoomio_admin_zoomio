import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoomio_adminzoomio/presentaions/user_screens/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all authenticated users
  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception("Error fetching users: $e");
    }
  }
}
