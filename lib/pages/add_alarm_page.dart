import 'package:flutter/material.dart';
import '../models/alarm_category.dart';
import '../pages/home_page.dart'; // Import initialCategories

class AddAlarmPage extends StatefulWidget {
  const AddAlarmPage({super.key});

  @override
  State<AddAlarmPage> createState() => _AddAlarmPageState();
}

class _AddAlarmPageState extends State<AddAlarmPage> {
  TimeOfDay? selectedTime;
  String label = '';
  AlarmCategory? selectedCategory;
  List<String> repeatDays = [];
  String ringtone = 'Default';
  bool vibration = true;
  bool oneTime = false;
  bool preAlarm = false;
  String snooze = '5 minutes';
  String note = '';

  final List<String> allDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> snoozeOptions = ['5 minutes', '10 minutes', '15 minutes'];
  final List<String> ringtones = ['Default', 'Beep', 'Melody']; // Placeholder ringtones

  @override
  void initState() {
    super.initState();
    // Initialize selectedCategory with the first category as a default, or null
    selectedCategory = initialCategories.isNotEmpty ? initialCategories.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Use theme background
      appBar: AppBar(
        title: Text('Add New Alarm', style: Theme.of(context).appBarTheme.titleTextStyle), // Consistent title style
        iconTheme: Theme.of(context).appBarTheme.iconTheme, // Consistent icon color
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Picker
            Text('Time', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime ?? TimeOfDay.now(),
                );
                if (picked != null) setState(() => selectedTime = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      selectedTime != null
                          ? selectedTime!.format(context)
                          : '--:--',
                      style: Theme.of(context).textTheme.headlineSmall, // Use a larger text style
                    ),
                    const Spacer(),
                    const Icon(Icons.access_time, color: Colors.deepPurple),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Label
            Text('Label', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Wake up, Prayer time, Gym...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              onChanged: (v) => label = v,
            ),
            const SizedBox(height: 24),

            // Category
            Text('Category', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<AlarmCategory>(
              value: selectedCategory,
              hint: const Text('Choose category'),
              items: initialCategories.map((cat) { // Use initialCategories from home_page
                return DropdownMenuItem(
                  value: cat,
                  child: Row(
                    children: [
                      Icon(cat.icon, color: cat.color),
                      const SizedBox(width: 8),
                      Text(cat.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (cat) => setState(() => selectedCategory = cat),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),

            // Repeat Days
            Text('Repeat Days', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8, // Added runSpacing for better layout on multiple lines
              children: allDays.map((day) {
                final selected = repeatDays.contains(day);
                return ChoiceChip(
                  label: Text(day, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: selected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color)),
                  selected: selected,
                  selectedColor: Colors.deepPurple,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        repeatDays.add(day);
                      } else {
                        repeatDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Ringtone
            Text('Ringtone', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: ringtone,
              items: ringtones.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (val) => setState(() => ringtone = val ?? 'Default'),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),

            // Vibration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Vibration', style: Theme.of(context).textTheme.titleLarge),
                Switch(
                  value: vibration,
                  onChanged: (val) => setState(() => vibration = val), // Active color from theme's switchTheme
                ),
              ],
            ),
            const SizedBox(height: 8),

            // One-time alarm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('One-time alarm', style: Theme.of(context).textTheme.titleLarge),
                Switch(
                  value: oneTime,
                  onChanged: (val) => setState(() => oneTime = val),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Pre-alarm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pre-alarm', style: Theme.of(context).textTheme.titleLarge),
                Switch(
                  value: preAlarm,
                  onChanged: (val) => setState(() => preAlarm = val),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Snooze duration
            Text('Snooze duration (minutes)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: snooze,
              items: snoozeOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => snooze = val ?? '5 minutes'),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),

            // Note
            Text('Note (optional)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Add a note...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              onChanged: (v) => note = v,
            ),
            const SizedBox(height: 32),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // Use Expanded for buttons to fill space better
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      side: const BorderSide(color: Colors.deepPurple),
                      padding: const EdgeInsets.symmetric(vertical: 14), // Removed horizontal padding
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      // TODO: Save alarm logic
                      Navigator.pop(context);
                    },
                    child: const Text('Add Alarm', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}