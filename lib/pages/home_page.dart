import 'package:flutter/material.dart';
import '../models/alarm_category.dart';
import 'settings_page.dart';
import 'add_alarm_page.dart';
import 'category_detail_page.dart';
import '../widgets/info_card.dart';
import '../widgets/category_card.dart';
import '../widgets/add_category_dialog.dart'; // Updated import path if it was different
import 'dart:math'; // For random color
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'package:flutter_slidable/flutter_slidable.dart'; // Import Slidable

// Moved the initial categories list here, as it's primarily used by HomePage
final List<AlarmCategory> initialCategories = [
  AlarmCategory(
    name: 'All Alarms',
    icon: Icons.list_alt_outlined,
    color: Colors.orange.shade700,
  ), // Default first category
  AlarmCategory(
    name: 'Gym',
    icon: Icons.fitness_center,
    color: Colors.deepPurple,
  ),
  AlarmCategory(name: 'Namaz', icon: Icons.mosque, color: Colors.green),
  AlarmCategory(name: 'Drink', icon: Icons.local_drink, color: Colors.teal),
  AlarmCategory(name: 'Custom', icon: Icons.category, color: Colors.blueGrey),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Make a deep copy to allow independent state management for toggling
  List<AlarmCategory> categories = initialCategories
      .map(
        (c) => AlarmCategory(
          name: c.name,
          icon: c.icon,
          emoji: c.emoji,
          color: c.color,
          enabled: c.enabled,
        ),
      )
      .toList();

  int get activeAlarms => 0; // Placeholder for actual alarm count
  int get categoryCount => categories.length;
  AlarmCategory? selectedCategory;

  @override
  void initState() {
    super.initState();
    // Select the first category by default if the list is not empty
    if (categories.isNotEmpty) {
      selectedCategory = categories.first;
    }
  }

  void _showAddCategoryDialog({AlarmCategory? categoryToEdit}) {
    // Add optional parameter
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCategoryDialog(
          existingCategory: categoryToEdit, // Pass the category to edit
          onCategoryAdded: (name, emoji) {
            setState(() {
              if (categoryToEdit != null) {
                // Editing existing category
                categoryToEdit.name = name;
                categoryToEdit.emoji = emoji;
                // Update icon based on emoji presence
                categoryToEdit.icon =
                    emoji == null && categoryToEdit.icon == null
                    ? Icons
                          .label_important_outline // Default if no emoji and no previous icon
                    : (emoji != null
                          ? null
                          : categoryToEdit
                                .icon); // Clear icon if emoji is set, else keep old icon
                if (selectedCategory == categoryToEdit) {
                  selectedCategory =
                      categoryToEdit; // Ensure selectedCategory reflects changes
                }
              } else {
                // Adding new category
                final newCategory = AlarmCategory(
                  name: name,
                  emoji: emoji,
                  icon: emoji == null ? Icons.label_important_outline : null,
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                  enabled: true,
                );
                categories.add(newCategory);
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Cat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          // <-- Added
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Organize your day with style",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              InfoCard(
                title1: "Active Alarms",
                value1: "$activeAlarms",
                title2: "Categories",
                value2: "$categoryCount",
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.7),
                    ),
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Swipe a category from right to left for options (Settings, Edit, Delete).',
                          ),
                          duration: Duration(seconds: 5),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Dynamically adjust height: grow with categories, max 200
              LayoutBuilder(
                builder: (context, constraints) {
                  // Each item is about 56px + divider, plus some padding
                  final itemHeight = 56.0 + 8.0; // Card + padding
                  final addButtonHeight = 48.0;
                  final totalHeight =
                      (categories.length * itemHeight) +
                      addButtonHeight +
                      24.0; // 24 for top/bottom padding
                  final cardHeight = totalHeight.clamp(120.0, 200.0);

                  return SizedBox(
                    height: cardHeight,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView.separated(
                        itemCount: categories.length + 1,
                        physics:
                            categories.length * itemHeight + addButtonHeight >
                                200
                            ? const AlwaysScrollableScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, idx) =>
                            idx < categories.length - 1
                            ? const Divider(
                                height: 1,
                                thickness: 1,
                                indent: 16,
                                endIndent: 16,
                              )
                            : const SizedBox.shrink(),
                        itemBuilder: (context, idx) {
                          if (idx == categories.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextButton.icon(
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                ),
                                label: const Text("Add New Category"),
                                onPressed: _showAddCategoryDialog,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                ),
                              ),
                            );
                          } else {
                            final categoryItem = categories[idx];
                            final bool isSelected =
                                selectedCategory == categoryItem;
                            return Slidable(
                              key: ValueKey(
                                '${categoryItem.name}_${categoryItem.color}',
                              ),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) =>
                                        _showAddCategoryDialog(
                                          categoryToEdit: categoryItem,
                                        ),
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      setState(() {
                                        categories.removeAt(idx);
                                        if (selectedCategory == categoryItem) {
                                          selectedCategory =
                                              categories.isNotEmpty
                                              ? categories.first
                                              : null;
                                        }
                                      });
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CategoryDetailPage(
                                            category: categoryItem,
                                          ),
                                        ),
                                      );
                                    },
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    icon: Icons.settings,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    border: isSelected
                                        ? Border(
                                            left: BorderSide(
                                              color: Colors.green.shade600,
                                              width: 4.0,
                                            ),
                                          )
                                        : null,
                                  ),
                                  child: CategoryCard(
                                    category: categoryItem,
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = categoryItem;
                                      });
                                    },
                                    onToggle: (val) {
                                      setState(
                                        () => categoryItem.enabled = val,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                "Category Alarms",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (selectedCategory != null)
                SingleChildScrollView(
                  // <-- Added for category alarms
                  child: Card(
                    elevation: 2,
                    shape: Theme.of(context).cardTheme.shape,
                    color: Theme.of(context).cardTheme.color,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              selectedCategory!.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: ClipRect(
                                child: Transform.scale(
                                  scale: 2.0,
                                  child: Lottie.asset(
                                    'assets/lottie/empty_state_animation.json',
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.hourglass_empty,
                                        size: 100,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No alarms in \"${selectedCategory!.name}\" yet.\nTap the '+' button to add one!",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.black45),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 14),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAlarmPage()),
          );
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
