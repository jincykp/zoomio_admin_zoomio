import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoomio_adminzoomio/presentaions/home_screen.dart';

class LoginProvider extends ChangeNotifier {
  final String adminName = "admin";
  final String adminPassword = "1234";
  bool isLoading = false;
  String? loginMessage;

  LoginProvider() {
    setPredefinedCredentials();
  }

  // Store the predefined admin credentials in SharedPreferences
  Future<void> setPredefinedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adminname', adminName);
    await prefs.setString('adminPassword', adminPassword);
  }

  // Validate entered admin credentials with the stored ones
  Future<bool> validateAdminCredentials(
      String enteredName, String enteredPassword) async {
    final prefs = await SharedPreferences.getInstance();
    String? storedName = prefs.getString('adminname');
    String? storedPassword = prefs.getString('adminPassword');
    return storedName == enteredName && storedPassword == enteredPassword;
  }

  // Handle the login process
  Future<void> handleLogin(
      String enteredName, String enteredPassword, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    bool isValid = await validateAdminCredentials(
        enteredName.trim(), enteredPassword.trim());

    isLoading = false;

    if (isValid) {
      loginMessage = "Login successful";
      notifyListeners();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      loginMessage = "Invalid admin name and password";
    }

    notifyListeners();
  }
}
