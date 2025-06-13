import 'package:flutter/material.dart';
import '../models/alarm_category.dart';
import 'settings_page.dart';
import 'add_alarm_page.dart';
import 'category_detail_page.dart';
import '../widgets/info_card.dart';
import '../widgets/category_card.dart';
import '../widgets/add_category_dialog.dart';
import 'dart:math';
import 'package:lottie/lottie.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../services/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AlarmCategory> categories = [];
  AlarmCategory? selectedCategory;

  List<Map<String, dynamic>> alarms = [];

  int get activeAlarms => alarms.where((a) => (a['enabled'] ?? 1) == 1).length;
  int get activeCategories => categories.where((c) => c.enabled).length;
  int get totalCategories => categories.length;

  @override
  void initState() {
    super.initState();
    _loadCategoriesFromDb();
    _loadAlarmsFromDb();
  }

  Future<void> _loadCategoriesFromDb() async {
    final db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    final loaded = maps
        .map(
          (map) => AlarmCategory(
            name: map['name'],
            emoji: map['emoji'],
            icon: null, // You can add icon logic if you store it
            color: Colors.primaries[map['id'] % Colors.primaries.length],
            enabled: map['enabled'] == 1,
          ),
        )
        .toList();
    loaded.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    ); // Sort ascending by name
    setState(() {
      categories = loaded;
      selectedCategory = categories.isNotEmpty ? categories.first : null;
    });
  }

  Future<void> _loadAlarmsFromDb() async {
    final db = await DatabaseHelper().db;
    alarms = await db.query('alarms');
    setState(() {});
  }

  Future<void> _updateCategoryEnabledInDb(int idx, bool enabled) async {
    final db = await DatabaseHelper().db;
    final category = categories[idx];
    await db.update(
      'categories',
      {'enabled': enabled ? 1 : 0},
      where: 'name = ?',
      whereArgs: [category.name],
    );
    await _loadCategoriesFromDb();
  }

  Future<void> _updateAlarmEnabledInDb(int alarmId, bool enabled) async {
    final db = await DatabaseHelper().db;
    await db.update(
      'alarms',
      {'enabled': enabled ? 1 : 0},
      where: 'id = ?',
      whereArgs: [alarmId],
    );
    await _loadAlarmsFromDb();
  }

  void _showAddCategoryDialog({AlarmCategory? categoryToEdit}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCategoryDialog(
          existingCategory: categoryToEdit,
          onCategoryAdded: (name, emoji) async {
            await _loadCategoriesFromDb();
            await _loadAlarmsFromDb(); // Also reload alarms to reflect category label changes
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
                value2: "${activeCategories}/${totalCategories}",
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
                        itemCount:
                            categories.length +
                            2, // +1 for All Alarms, +1 for Add New Category
                        physics:
                            categories.length * itemHeight + addButtonHeight >
                                200
                            ? const AlwaysScrollableScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, idx) {
                          // Divider only between real categories (not after All Alarms)
                          if (idx == 0) {
                            return const SizedBox.shrink();
                          }
                          // Show divider after every category, including after last, but not after Add New Category
                          if (idx <= categories.length) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 56.0,
                              ), // 40 for icon + 16 for sr no + padding
                              child: const Divider(
                                height: 1,
                                thickness: 1,
                                // indent: 16, // Remove indent, use left padding instead
                                endIndent: 16,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        itemBuilder: (context, idx) {
                          if (idx == 0) {
                            // All Alarms pseudo-category
                            return InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                setState(() {
                                  selectedCategory = null;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selectedCategory == null
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.alarm,
                                      color: Colors.deepPurple,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'All Alarms',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple.withOpacity(
                                          0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${alarms.length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (idx == categories.length + 1) {
                            // Add New Category button
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
                            final categoryItem = categories[idx - 1];
                            final int srNo = idx;
                            // Count alarms for this category
                            final int alarmCount = alarms
                                .where(
                                  (alarm) =>
                                      alarm['category'] == categoryItem.name,
                                )
                                .length;
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
                                        categories.removeAt(idx - 1);
                                      });
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      setState(() {
                                        // open category detail page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CategoryDetailPage(
                                              category: categoryItem,
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    icon: Icons.settings,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 12.0,
                                    ),
                                    child: Text(
                                      '$srNo',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                  Expanded(
                                    child: CategoryCard(
                                      category: categoryItem,
                                      alarmCount: alarmCount,
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = categoryItem;
                                        });
                                      },
                                      onToggle: (val) async {
                                        await _updateCategoryEnabledInDb(
                                          idx - 1,
                                          val,
                                        );
                                      },
                                    ),
                                  ),
                                ],
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
              if (selectedCategory == null)
                (alarms.isNotEmpty)
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: alarms.length,
                        itemBuilder: (context, idx) {
                          final alarm = alarms[idx];
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.alarm),
                              title: Text(alarm['label'] ?? ''),
                              subtitle: Text('Time: \t${alarm['time']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(alarm['repeatDays'] ?? ''),
                                  const SizedBox(width: 8),
                                  Switch(
                                    value: (alarm['enabled'] ?? 1) == 1,
                                    onChanged: (val) async {
                                      await _updateAlarmEnabledInDb(
                                        alarm['id'],
                                        val,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Card(
                        elevation: 2,
                        shape: Theme.of(context).cardTheme.shape,
                        color: Theme.of(context).cardTheme.color,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "No alarms yet. Tap the '+' button to add one!",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.black45),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
              if (selectedCategory != null)
                (alarms
                        .where(
                          (alarm) =>
                              alarm['category'] == selectedCategory!.name,
                        )
                        .isNotEmpty)
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: alarms
                            .where(
                              (alarm) =>
                                  alarm['category'] == selectedCategory!.name,
                            )
                            .length,
                        itemBuilder: (context, idx) {
                          final alarm = alarms
                              .where(
                                (alarm) =>
                                    alarm['category'] == selectedCategory!.name,
                              )
                              .toList()[idx];
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.alarm),
                              title: Text(alarm['label'] ?? ''),
                              subtitle: Text('Time: \t${alarm['time']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(alarm['repeatDays'] ?? ''),
                                  const SizedBox(width: 8),
                                  Switch(
                                    value: (alarm['enabled'] ?? 1) == 1,
                                    onChanged: (val) async {
                                      await _updateAlarmEnabledInDb(
                                        alarm['id'],
                                        val,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Card(
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
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAlarmPage()),
          );
          if (result == true) {
            await _loadAlarmsFromDb();
            await _loadCategoriesFromDb(); // Also reload categories
            setState(() {});
          }
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
