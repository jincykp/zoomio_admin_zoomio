import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/revenue_screens/revenue_card.dart';
import 'package:zoomio_adminzoomio/presentaions/revenue_screens/revenue_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/revenue_screens/stats_card.dart';
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    StatsCard(
                      title: 'Today\'s Stats',
                      mainValue: '₹${provider.dailyRevenue.toStringAsFixed(2)}',
                      subValue: provider.dailyTrips.toString(),
                      icon: Icons.today,
                    ),
                    StatsCard(
                      title: 'Weekly Stats',
                      mainValue:
                          '₹${provider.weeklyRevenue.toStringAsFixed(2)}',
                      subValue: provider.weeklyTrips.toString(),
                      icon: Icons.calendar_view_week,
                    ),
                    StatsCard(
                      title: 'Monthly Stats',
                      mainValue:
                          '₹${provider.monthlyRevenue.toStringAsFixed(2)}',
                      subValue: provider.monthlyTrips.toString(),
                      icon: Icons.calendar_month,
                    ),
                    // Summary Card
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Trip Summary',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildTripSummary('Daily', provider.dailyTrips),
                                _buildTripSummary(
                                    'Weekly', provider.weeklyTrips),
                                _buildTripSummary(
                                    'Monthly', provider.monthlyTrips),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildTripSummary(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ThemeColors.primaryColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
