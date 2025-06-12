import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title1;
  final String value1;
  final String title2;
  final String value2;

  const InfoCard({
    super.key,
    required this.title1,
    required this.value1,
    required this.title2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // Slightly more elevation for a bit of pop
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Softer corners
      color: Theme.of(context).colorScheme.surface, // Use surface color from theme
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22), // Adjusted padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoItem(
              context,
              icon: Icons.alarm_on, // Icon for active alarms
              iconColor: Colors.blueAccent.shade400,
              title: title1,
              value: value1,
              valueColor: Colors.blueAccent.shade700,
            ),
            // VerticalDivider(width: 1, thickness: 1, indent: 8, endIndent: 8, color: Colors.grey.shade300), // Optional divider
            _buildInfoItem(
              context,
              icon: Icons.category_outlined, // Icon for categories
              iconColor: Colors.green.shade400,
              title: title2,
              value: value2,
              valueColor: Colors.green.shade700,
              crossAxisAlignment: CrossAxisAlignment.end, // Align text to the right for the second item
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, {required IconData icon, required Color iconColor, required String title, required String value, required Color valueColor, CrossAxisAlignment? crossAxisAlignment}) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 6),
            Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: valueColor, fontWeight: FontWeight.w600)),
      ],
    );
  }
}