import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoomio_adminzoomio/presentaions/user_screens/user_model.dart';

class UserAdminProvider with ChangeNotifier {
  List<UserModel> _users = [];

  List<UserModel> get users => _users;

  Future<void> fetchUsers() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      _users = querySnapshot.docs
          .map((doc) =>
              UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      notifyListeners(); // Notify UI of changes
    } catch (error) {
      print('Error fetching users: $error');
      throw error;
    }
  }
}
