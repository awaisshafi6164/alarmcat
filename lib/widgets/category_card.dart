import 'package:flutter/material.dart';
import '../models/alarm_category.dart'; // Import the AlarmCategory model

class CategoryCard extends StatelessWidget {
  final AlarmCategory category;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onToggle;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.onLongPress,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 0, // Cards within the horizontal list can have less elevation
        color: Theme.of(context).cardTheme.color,
        shape: Theme.of(context).cardTheme.shape,
        child: Container(
          width: 110,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, color: category.color, size: 28), // Slightly larger icon
              const SizedBox(height: 6),
              Text(
                category.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: category.color,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // Handle long category names
              ),
              const SizedBox(height: 4),
              Text(
                "0 alarms", // Placeholder
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: category.color.withOpacity(0.8),
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
              Transform.scale( // Scale down the switch slightly
                scale: 0.8,
                child: Switch(
                  value: category.enabled,
                  activeColor: category.color,
                  onChanged: onToggle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}