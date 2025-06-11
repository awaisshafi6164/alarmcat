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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Theme.of(context).cardTheme.color, // Use theme color
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title1, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                Text(value1, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.deepPurple)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title2, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                Text(value2, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.deepPurple)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}