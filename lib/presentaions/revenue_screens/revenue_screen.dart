import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/revenue_screens/revenue_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RevenueProvider>().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.primaryColor,
        title: const Text('Earnings & Trips'),
      ),
      body: Consumer<RevenueProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () => provider.fetchData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Earnings Split Description
                    Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Earnings Split',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSplitLabel('Driver', '40%'),
                                _buildSplitLabel('Company', '60%'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Stats Sections
                    _buildEarningsSection(
                      'Today\'s Stats',
                      provider.dailyRevenue,
                      provider.dailyDriverEarnings,
                      provider.dailyAdminEarnings,
                      provider.dailyTrips,
                      Icons.today,
                    ),

                    _buildEarningsSection(
                      'Weekly Stats',
                      provider.weeklyRevenue,
                      provider.weeklyDriverEarnings,
                      provider.weeklyAdminEarnings,
                      provider.weeklyTrips,
                      Icons.calendar_view_week,
                    ),

                    _buildEarningsSection(
                      'Monthly Stats',
                      provider.monthlyRevenue,
                      provider.monthlyDriverEarnings,
                      provider.monthlyAdminEarnings,
                      provider.monthlyTrips,
                      Icons.calendar_month,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSplitLabel(String label, String percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label ($percentage)',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEarningsSection(
    String title,
    double totalRevenue,
    double driverEarnings,
    double adminEarnings,
    int trips,
    IconData icon,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(icon, color: ThemeColors.primaryColor, size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildEarningColumn(
                          'Total', '₹${totalRevenue.toStringAsFixed(2)}',
                          isTotal: true),
                      SizedBox(width: constraints.maxWidth * 0.1),
                      _buildEarningColumn(
                          'Driver', '₹${driverEarnings.toStringAsFixed(2)}'),
                      SizedBox(width: constraints.maxWidth * 0.1),
                      _buildEarningColumn(
                          'Company', '₹${adminEarnings.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$trips Trips',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEarningColumn(String label, String value,
      {bool isTotal = false}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? ThemeColors.primaryColor : Colors.black87,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
