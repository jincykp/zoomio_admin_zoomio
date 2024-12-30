import 'package:flutter/material.dart';
import 'package:zoomio_adminzoomio/data/services/auth_services.dart';
import 'package:zoomio_adminzoomio/presentaions/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _signUpMessage;

  bool get isLoading => _isLoading;
  String? get signUpMessage => _signUpMessage;

  /// Handles sign-up logic
  Future<void> handleSignUp(
      String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final message =
          await _authService.createAccountWithEmail(email, password);
      _signUpMessage = message;

      print(message); // Log the success message

      if (message == "Sign-up successful") {
        // Save login status to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);

        // Navigate to HomeScreen after successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? "An unknown error occurred")),
        );
      }
    } catch (e) {
      print("Error during sign-up: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: ${e.toString()}")),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
