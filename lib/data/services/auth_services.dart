import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up method
  Future<String?> createAccountWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      print("User created successfully: ${userCredential.user?.email}");
      return "Sign-up successful";
    } on FirebaseAuthException catch (e) {
      // Log detailed Firebase error codes and messages
      print("Sign-up failed: Code - ${e.code}, Message - ${e.message}");
      throw Exception("Sign-up error: ${e.code} - ${e.message}");
    } catch (e) {
      // Log unexpected errors
      print("Unexpected error during sign-up: $e");
      throw Exception("An unexpected error occurred during sign-up.");
    }
  }

  // Sign in method
  Future<String?> loginAccountWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print("Login successful: ${userCredential.user?.email}");
      return "Login successful";
    } on FirebaseAuthException catch (e) {
      // Log detailed Firebase error codes and messages
      print("Login failed: Code - ${e.code}, Message - ${e.message}");
      throw Exception("Login error: ${e.code} - ${e.message}");
    } catch (e) {
      // Log unexpected errors
      print("Unexpected error during login: $e");
      throw Exception("An unexpected error occurred during login.");
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("Sign-out successful");
    } catch (e) {
      print("An unexpected error occurred during sign-out: $e");
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}
