import 'package:flutter/material.dart';
import '../models/alarm_category.dart'; // Import the AlarmCategory model

class CategoryCard extends StatelessWidget {
  final AlarmCategory category;
  final VoidCallback onTap;
  // final VoidCallback onLongPress; // Removed onLongPress
  final ValueChanged<bool> onToggle;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    // required this.onLongPress, // Removed onLongPress
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // onLongPress: onLongPress, // Removed onLongPress
      child: Container(
        // elevation: 0, // No longer a Card
        // color: Colors.transparent, // Container will be transparent by default
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Adjusted padding slightly for better spacing
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
          children: [
            Expanded(
              child: Opacity(
                opacity: category.enabled ? 1.0 : 0.5, // Dim content if not enabled
                child: Row(
                  children: [
                    if (category.emoji != null && category.emoji!.isNotEmpty)
                      Text(category.emoji!, style: TextStyle(fontSize: 22, color: category.color.withOpacity(0.9)))
                    else if (category.icon != null)
                      Icon(category.icon!, color: category.color, size: 26)
                    else
                      // Fallback if neither emoji nor icon is provided
                      Icon(Icons.label_outline, color: category.color, size: 26),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        category.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // const SizedBox(width: 8), // Spacing before alarm count
                    Text(
                      "0 alarms", // Placeholder
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10), // Spacing before switch
            Transform.scale(
              scale: 0.85, // Adjusted scale
              child: Switch(
                value: category.enabled,
                activeColor: Colors.blueGrey,
                onChanged: onToggle,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce tap area
              ),
            ),
          ],
        ),
      ),
    );
  }
}
