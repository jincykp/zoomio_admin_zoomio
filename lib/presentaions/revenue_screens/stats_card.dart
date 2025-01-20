import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String mainValue;
  final String? subValue;
  final String? subLabel;
  final IconData icon;

  const StatsCard({
    Key? key,
    required this.title,
    required this.mainValue,
    this.subValue,
    this.subLabel,
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
              mainValue,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ThemeColors.primaryColor,
              ),
            ),
            if (subValue != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    subLabel ?? 'Trips: ',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    subValue!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
