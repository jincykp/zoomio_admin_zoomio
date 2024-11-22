import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/firebase_options.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/signin_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/theme_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/vehicle_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/splash_screen.dart';

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
          create: (_) => VehicleProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider())
        // Add other providers here if needed
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            //theme: ThemeData.light(), // Define the light theme
            darkTheme: ThemeData.dark(), // Define the dark theme
            themeMode: themeProvider
                .themeMode, // Use the theme mode from ThemeProvider
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
