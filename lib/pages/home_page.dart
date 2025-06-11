import 'package:flutter/material.dart';
import '../models/alarm_category.dart';
import 'settings_page.dart';
import 'add_alarm_page.dart';
import 'category_detail_page.dart';
import '../widgets/info_card.dart';
import '../widgets/category_card.dart';

// Moved the initial categories list here, as it's primarily used by HomePage
final List<AlarmCategory> initialCategories = [
  AlarmCategory(name: 'Gym', icon: Icons.fitness_center, color: Colors.deepPurple),
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
  List<AlarmCategory> categories = initialCategories.map((c) => AlarmCategory(
    name: c.name,
    icon: c.icon,
    color: c.color,
    enabled: c.enabled,
  )).toList();

  AlarmCategory? selectedCategory;

  int get activeAlarms => 0; // Placeholder for actual alarm count
  int get categoryCount => categories.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Cat'), // Style defined in theme
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // Color from theme
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
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Organize your day with style",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            InfoCard(
              title1: "Active Alarms",
              value1: "$activeAlarms",
              title2: "Categories",
              value2: "$categoryCount",
            ),
            const SizedBox(height: 24),
            Text(
              "Categories",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, idx) {
                  final cat = categories[idx];
                  return Padding(
                    padding: EdgeInsets.only(right: idx == categories.length - 1 ? 0 : 8),
                    child: CategoryCard(
                      category: cat,
                      onTap: () {
                        setState(() {
                          selectedCategory = cat;
                        });
                      },
                      onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryDetailPage(category: cat),
                          ),
                        );
                      },
                      onToggle: (val) {
                        setState(() => cat.enabled = val);
                        // TODO: Implement logic to toggle all alarms within this category
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Category Alarms",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (selectedCategory != null)
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: Theme.of(context).cardTheme.shape,
                  color: Theme.of(context).cardTheme.color,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: selectedCategory!.color.withOpacity(0.15),
                            radius: 32,
                            child: Icon(selectedCategory!.icon, color: selectedCategory!.color, size: 36),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            selectedCategory!.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No Alarms Yet",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.black54),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Tap the + button to create your first alarm.",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black45),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
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