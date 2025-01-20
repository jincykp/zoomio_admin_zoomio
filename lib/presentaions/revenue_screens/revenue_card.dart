import 'package:flutter/material.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';

class RevenueCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;

  const RevenueCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                Icon(icon, color: ThemeColors.primaryColor),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '₹${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ThemeColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
