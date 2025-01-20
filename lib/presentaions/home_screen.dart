import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/block_driver_screen.dart/block_the_driver.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/tab_controller_screen.dart';
import 'package:zoomio_adminzoomio/presentaions/driver_screens/drivers_list.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/theme_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/revenue_screens/revenue_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/revenue_screens/revenue_screen.dart';
import 'package:zoomio_adminzoomio/presentaions/revenue_screens/statistics_card.dart';
import 'package:zoomio_adminzoomio/presentaions/signup_screen/sign.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';
import 'package:zoomio_adminzoomio/presentaions/user_screens/user_list.dart';
import 'package:zoomio_adminzoomio/presentaions/vehicle/add_vehicle.dart';
import 'package:zoomio_adminzoomio/presentaions/vehicle/default_tabbar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      context.read<RevenueProvider>().fetchData();
      context.read<RevenueProvider>().startRealtimeUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // foregroundColor: ThemeColors.textColor,
        backgroundColor: ThemeColors.primaryColor,
        title: const Center(child: Text("Statistics Overview")),
      ),
      drawer: Drawer(
        child: ListView.separated(
          itemBuilder: (context, index) {
            final items = [
              {'icon': Icons.dashboard, 'title': 'Dash Board'},
              {'icon': Icons.person, 'title': 'Users'},
              {'icon': Icons.group, 'title': 'Drivers'},
              {'icon': Icons.bike_scooter, 'title': 'Vehicles'},
              {'icon': Icons.emoji_transportation, 'title': 'All rides'},
              {'icon': Icons.attach_money, 'title': 'Revenue'},
              {'icon': Icons.cancel, 'title': 'Cancelled Rides'},
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
              onTap: () => _handleItemTap(context, index),
            );
          },
          separatorBuilder: (context, index) =>
              const Divider(), // Add Divider between items
          itemCount: 9, // Number of list items
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<RevenueProvider>(
          builder: (context, revenueProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      StatisticsCard(
                        title: 'Daily Earnings',
                        amount:
                            '₹${revenueProvider.dailyRevenue.toStringAsFixed(2)}',
                        subtitle: '${revenueProvider.dailyTrips} rides',
                        backgroundColor: Colors.blue[100]!,
                        icon: Icons.today,
                      ),
                      StatisticsCard(
                        title: 'Weekly Earnings',
                        amount:
                            '₹${revenueProvider.weeklyRevenue.toStringAsFixed(2)}',
                        subtitle: '${revenueProvider.weeklyTrips} rides',
                        backgroundColor: Colors.green[100]!,
                        icon: Icons.calendar_view_week,
                      ),
                      StatisticsCard(
                        title: 'Monthly Earnings',
                        amount:
                            '₹${revenueProvider.monthlyRevenue.toStringAsFixed(2)}',
                        subtitle: '${revenueProvider.monthlyTrips} rides',
                        backgroundColor: Colors.orange[100]!,
                        icon: Icons.calendar_month,
                      ),
                      StatisticsCard(
                        title: 'Average Per Ride',
                        amount:
                            '₹${_calculateAverage(revenueProvider.monthlyRevenue, revenueProvider.monthlyTrips)}',
                        subtitle: 'This month',
                        backgroundColor: Colors.purple[100]!,
                        icon: Icons.auto_graph,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
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

  String _calculateAverage(double total, int count) {
    if (count == 0) return '0.00';
    return (total / count).toStringAsFixed(2);
  }

  // Handling the onTap event for the Drawer items
  void _handleItemTap(BuildContext context, int index) {
    switch (index) {
      case 0:
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RideScreen()));
        break;
      case 5:
        Navigator.push(context,
            (MaterialPageRoute(builder: (context) => const RevenueScreen())));
        break;
      case 6:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DriverManagementScreen()));
        break;
      case 7:
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        break;
      case 8:
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

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
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
