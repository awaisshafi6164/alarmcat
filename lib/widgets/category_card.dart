import 'package:flutter/material.dart';
import '../models/alarm_category.dart';

class CategoryCard extends StatelessWidget {
  final AlarmCategory category;
  final VoidCallback onTap;
  final ValueChanged<bool>? onToggle;
  final int alarmCount;
  final bool isSelected;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.onToggle,
    required this.alarmCount,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine gradient based on category enabled state
    // Use category color but deeper for gradient effect
    final startColor = category.enabled
        ? category.color.withOpacity(0.85)
        : Colors.grey.withOpacity(0.3);
    final endColor = category.enabled
        ? category.color
        : Colors.grey.withOpacity(0.2);

    final textColor = category.enabled ? Colors.white : Colors.grey.shade400;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 4,
        ), // Added margin for spacing
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            if (category.enabled)
              BoxShadow(
                color: category.color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
          border: isSelected
              ? Border.all(color: Colors.white.withOpacity(0.8), width: 2)
              : null,
        ),
        child: Row(
          children: [
            // Icon / Emoji Area
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: category.emoji != null && category.emoji!.isNotEmpty
                  ? Text(category.emoji!, style: const TextStyle(fontSize: 22))
                  : Icon(
                      category.icon ?? Icons.label_outline,
                      color: Colors.white,
                      size: 24,
                    ),
            ),
            const SizedBox(width: 16),
            // Text Area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$alarmCount alarm${alarmCount == 1 ? '' : 's'}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            // Toggle Switch
            if (onToggle != null)
              Switch(
                value: category.enabled,
                activeColor: Colors.white,
                activeTrackColor: Colors.white.withOpacity(0.3),
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.black12,
                onChanged: onToggle,
              ),
          ],
        ),
      ),
    );
  }
}
