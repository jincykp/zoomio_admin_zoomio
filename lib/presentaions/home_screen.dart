import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/driver_screens/drivers_list.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/theme_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/signup_screen/sign.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';
import 'package:zoomio_adminzoomio/presentaions/user_screens/user_list.dart';
import 'package:zoomio_adminzoomio/presentaions/vehicle/add_vehicle.dart';
import 'package:zoomio_adminzoomio/presentaions/vehicle/default_tabbar_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // foregroundColor: ThemeColors.textColor,
        backgroundColor: ThemeColors.primaryColor,
        title: const Center(child: Text("Home Page")),
      ),
      drawer: Drawer(
        child: ListView.separated(
          itemBuilder: (context, index) {
            final items = [
              {'icon': Icons.dashboard, 'title': 'Dash Board'},
              {'icon': Icons.person, 'title': 'Users'},
              {'icon': Icons.group, 'title': 'Drivers'},
              {'icon': Icons.bike_scooter, 'title': 'Vehicles'},
              {'icon': Icons.attach_money, 'title': 'Revenue'},
              {'icon': Icons.emoji_transportation, 'title': 'All rides'},
              {'icon': Icons.dark_mode, 'title': 'Theme'},
              {'icon': Icons.logout_outlined, 'title': 'log out'},
            ];

            return ListTile(
              leading: Icon(
                items[index]['icon'] as IconData,
                color: ThemeColors.primaryColor,
              ),
              title: Text(
                items[index]['title'] as String,
                style: const TextStyle(color: ThemeColors.primaryColor),
              ),
              onTap: () {
                _handleItemTap(context, index);
              },
            );
          },
          separatorBuilder: (context, index) =>
              const Divider(), // Add Divider between items
          itemCount: 8, // Number of list items
        ),
      ),
      // Adding the FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Define what happens when the button is pressed
          _onFabPressed(context);
        },
        backgroundColor: ThemeColors.primaryColor, // Custom color for the FAB
        child: const Icon(
          Icons.add,
        ), // Icon for the FAB
      ),
    );
  }

  // Handling the onTap event for the Drawer items
  void _handleItemTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UsersListScreen()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DriversListScreen()));
        break;
      case 3:
        Navigator.push(
            context,
            (MaterialPageRoute(
                builder: (context) => const DefaultTabbarScreen())));
        break;
      case 4:
        Navigator.pushNamed(context, '/revenue');
        break;
      case 5:
        Navigator.pushNamed(context, '/allRides');
        break;
      case 6:
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        break;
      case 7:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Logout Confirmation",
                style: GoogleFonts.alikeAngular(fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Are you sure you want to logout?",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    // Perform logout logic here (e.g., FirebaseAuth sign out)
                    // await auth.signOut();
                    // Navigate to the sign-in screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ),
                    );
                  },
                  child: const Text("Logout"),
                ),
              ],
            );
          },
        );
        break;
    }
  }

  // Defining the action for the FloatingActionButton
  void _onFabPressed(BuildContext context) {
    // For example, navigate to a new screen or open a dialog
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VehicleAddScreen())); // Replace with your desired route
  }
}
