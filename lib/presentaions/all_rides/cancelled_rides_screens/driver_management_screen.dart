import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/cancelled_rides_screens/driver_management_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';

class DriverManagementScreen extends StatelessWidget {
  const DriverManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.primaryColor,
        title: const Text(
          'Driver Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<DriverState>().resetDailyCancellations(),
            tooltip: 'Reset Daily Cancellations',
          ),
        ],
      ),
      body: Consumer<DriverState>(
        builder: (context, driverState, child) {
          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: driverState.driversStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading driver data...'),
                    ],
                  ),
                );
              }

              final drivers = snapshot.data!;

              if (drivers.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.no_accounts,
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      Text('No drivers found'),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: drivers.length,
                itemBuilder: (context, index) {
                  final driver = drivers[index];
                  final driverName = driver['name'] ?? 'Unknown';
                  final driverPhone = driver['contactNumber'] ?? 'N/A';
                  final cancelCount = driver['dailyCancellations'] ?? 0;
                  final isBlocked = driver['isBlocked'] ?? false;
                  final blockTimestamp = driver['lastBlockUpdate'];
                  final totalCancellations = driver['totalCancellations'] ?? 0;
                  final driverId = driver['id'];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isBlocked
                            ? Colors.red.shade200
                            : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      driverName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      driverPhone,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildStatusChip(isBlocked),
                                  ],
                                ),
                              ),
                              _buildActionButton(context, driverState, driverId,
                                  isBlocked, driverName),
                            ],
                          ),
                          const Divider(height: 24),
                          _buildStatisticsSection(
                            cancelCount: cancelCount,
                            totalCancellations: totalCancellations,
                          ),
                          if (isBlocked && blockTimestamp != null) ...[
                            const SizedBox(height: 16),
                            _buildBlockInfo(blockTimestamp),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(bool isBlocked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isBlocked
            ? const Color.fromARGB(255, 214, 174, 180)
            : Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBlocked ? Colors.red.shade200 : Colors.green.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBlocked ? Icons.block : Icons.check_circle,
            size: 16,
            color:
                isBlocked ? ThemeColors.alertColor : ThemeColors.successColor,
          ),
          const SizedBox(width: 6),
          Text(
            isBlocked ? 'BLOCKED' : 'ACTIVE',
            style: TextStyle(
              color: isBlocked ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, DriverState driverState,
      String driverId, bool isBlocked, String driverName) {
    return ElevatedButton.icon(
      onPressed: () => _showBlockConfirmationDialog(
          context, driverState, driverId, isBlocked, driverName),
      style: ElevatedButton.styleFrom(
        backgroundColor: isBlocked ? Colors.green.shade50 : Colors.red.shade50,
        foregroundColor: isBlocked ? Colors.green : Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: Icon(isBlocked ? Icons.lock_open : Icons.lock),
      label: Text(isBlocked ? 'Unblock' : 'Block'),
    );
  }

  void _showBlockConfirmationDialog(
      BuildContext context,
      DriverState driverState,
      String driverId,
      bool isBlocked,
      String driverName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(isBlocked ? 'Unblock Driver' : 'Block Driver'),
          content: Text(isBlocked
              ? 'Are you sure you want to unblock $driverName?'
              : 'Are you sure you want to block $driverName? This will prevent them from receiving rides.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isBlocked ? Colors.green : Colors.red,
              ),
              child: Text(isBlocked ? 'Unblock' : 'Block'),
              onPressed: () {
                // Close the dialog first
                Navigator.of(dialogContext).pop();

                // Perform the block/unblock action
                driverState.toggleDriverBlock(driverId, isBlocked);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatisticsSection({
    required int cancelCount,
    required int totalCancellations,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cancellation Statistics',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Today\'s Cancellations',
                  cancelCount,
                  //  subtitle: '',
                ),
              ),
              const SizedBox(
                width: 1,
                height: 40,
              ),
              Expanded(
                child: _buildStatItem(
                  'Total Cancellations',
                  totalCancellations,
                  subtitle: 'All time',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    int value, {
    String? subtitle,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: value >= 2 ? Colors.red : null,
          ),
        ),
      ],
    );
  }

  Widget _buildBlockInfo(int timestamp) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 16, color: Colors.red),
          const SizedBox(width: 8),
          Text(
            'Blocked on: ${DateFormat.yMd().add_jm().format(
                  DateTime.fromMillisecondsSinceEpoch(timestamp),
                )}',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
