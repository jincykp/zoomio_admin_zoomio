import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoomio_adminzoomio/presentaions/signup_screen/sign.dart';
import 'package:zoomio_adminzoomio/presentaions/signup_screen/sign_up.dart';
import 'package:zoomio_adminzoomio/presentaions/home_screen.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeColors.primaryColor,
      body: Center(
        child: Text(
          "zoomio",
          style: TextStyle(
            fontSize: screenWidth * 0.1,
            fontFamily: "FamilyGuy",
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) return; // Prevent navigation if the widget is unmounted

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isLoggedIn ? const HomeScreen() : const SignInScreen(),
      ),
    );
  }
}
