import 'package:flutter/material.dart';
import 'package:zoomio_adminzoomio/data/services/auth_services.dart';
import 'package:zoomio_adminzoomio/presentaions/home_screen.dart';

class SignInProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _signInMessage;

  bool get isLoading => _isLoading;
  String? get signInMessage => _signInMessage;

  /// Handles sign-in logic
  Future<void> handleLogin(
      String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final message = await _authService.loginAccountWithEmail(email, password);
      _signInMessage = message;

      print(message); // Log the success message

      if (message == "Login successful") {
        // Navigate to the home screen if login is successful
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } else {
        // Show error message in SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? "An unknown error occurred")),
        );
      }
    } catch (e) {
      print("Error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: ${e.toString()}")),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
