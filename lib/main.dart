import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/firebase_options.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/completed_ride_screens/completed_trip_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/driver_cancelled_screens/driver_cancelled_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/user_cancelled_screens/user_cancelled_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/driver_screens/fetching_driver_services.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/signin_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/signup_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/theme_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/vehicle_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/signup_screen/sign_up.dart';
import 'package:zoomio_adminzoomio/presentaions/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoomio_adminzoomio/presentaions/home_screen.dart';
import 'package:zoomio_adminzoomio/presentaions/user_screens/user_provider.dart'; // Import the HomeScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<VehicleProvider>(
            create: (_) => VehicleProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<SignUpProvider>(create: (_) => SignUpProvider()),
        ChangeNotifierProvider<SignInProvider>(create: (_) => SignInProvider()),
        ChangeNotifierProvider(create: (_) => DriverAdminProvider()),
        ChangeNotifierProvider(create: (_) => UserAdminProvider()),
        ChangeNotifierProvider(create: (context) => TripProvider()),
        ChangeNotifierProvider(create: (context) => CancelledTripProvider()),
        ChangeNotifierProvider(create: (context) => DriverCancelledProvider()),
        // Add other providers here if needed  CancelledTripProvider DriverCancelledProvider
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider
                .themeMode, // Use the theme mode from ThemeProvider
            home: FutureBuilder(
              future: _checkLoginStatus(),
              builder: (context, snapshot) {
                // Check if the login status has been loaded
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen(); // Show splash screen while loading
                }
                // If the user is logged in, navigate to HomeScreen, otherwise SignInScreen
                if (snapshot.hasData && snapshot.data == true) {
                  return const HomeScreen(); // Navigate to HomeScreen if logged in
                } else {
                  return SignUpScreen(); // Navigate to SignInScreen if not logged in
                }
              },
            ),
          );
        },
      ),
    );
  }

  // Check the login status from SharedPreferences
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn =
        prefs.getBool('isLoggedIn') ?? false; // Default to false if not set
    return isLoggedIn;
  }
}
