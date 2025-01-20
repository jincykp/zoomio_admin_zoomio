import 'package:flutter/material.dart';

class StatisticsCard extends StatelessWidget {
  final String title;
  final String amount;
  final String subtitle;
  final Color backgroundColor;
  final IconData icon;

  const StatisticsCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.backgroundColor,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 8), // Reduced vertical padding
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(icon, size: 18), // Further reduced icon size
                  ],
                ),
                const SizedBox(height: 2), // Minimal spacing
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    amount,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Further reduced font size
                    ),
                  ),
                ),
                const SizedBox(height: 2), // Minimal spacing
                Text(
                  subtitle,
                  style: const TextStyle(
                    //color: Colors.black54,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
