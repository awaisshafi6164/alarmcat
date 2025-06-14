import 'package:flutter/material.dart';
import '../models/alarm_category.dart';
import '../services/database_helper.dart';

class AddAlarmPage extends StatefulWidget {
  const AddAlarmPage({super.key});

  @override
  State<AddAlarmPage> createState() => _AddAlarmPageState();
}

class _AddAlarmPageState extends State<AddAlarmPage> {
  TimeOfDay? selectedTime;
  String label = '';
  AlarmCategory? selectedCategory;
  List<AlarmCategory> categories = [];
  List<String> repeatDays = [];
  String ringtone = 'Default';
  bool vibration = true;
  bool oneTime = false;
  bool preAlarm = false;
  String snooze = '5 minutes';
  String note = '';

  final List<String> allDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  final List<String> snoozeOptions = ['5 minutes', '10 minutes', '15 minutes'];
  final List<String> ringtones = [
    'Default',
    'Beep',
    'Melody',
  ]; // Placeholder ringtones

  @override
  void initState() {
    super.initState();
    _loadCategoriesFromDb();
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
    loaded.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    setState(() {
      categories = loaded;
      selectedCategory = categories.isNotEmpty ? categories.first : null;
    });
  }

  // 3. When adding an alarm, set enabled: 1
  Future<void> _addAlarmToDb() async {
    if (selectedTime == null ||
        selectedCategory == null ||
        label.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all required fields: Time, Label, Category.',
          ),
        ),
      );
      return;
    }
    final db = await DatabaseHelper().db;
    final alarmData = {
      'time': selectedTime!.format(context),
      'label': label,
      'category': selectedCategory?.name ?? '',
      'repeatDays': repeatDays.join(','),
      'ringtone': ringtone,
      'vibration': vibration ? 1 : 0,
      'oneTime': oneTime ? 1 : 0,
      'preAlarm': preAlarm ? 1 : 0,
      'snooze': snooze,
      'note': note,
      'enabled': 1,
    };
    final id = await db.insert('alarms', alarmData);
    print('[AddAlarmPage] Added alarm to DB: id=$id, data=$alarmData');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // Use theme background
      appBar: AppBar(
        title: Text(
          'Add New Alarm',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ), // Consistent title style
        iconTheme: Theme.of(
          context,
        ).appBarTheme.iconTheme, // Consistent icon color
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
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
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
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall, // Use a larger text style
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onChanged: (v) => label = v,
            ),
            const SizedBox(height: 24),

            // Category
            Text('Category', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: DropdownButtonFormField<AlarmCategory>(
                value: selectedCategory,
                hint: const Text('Choose category'),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.deepPurple,
                ),
                dropdownColor: Colors.white,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.deepPurple.shade700,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 10,
                  ),
                  isDense: true,
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Row(
                      children: [
                        if (cat.emoji != null && cat.emoji!.isNotEmpty)
                          Text(
                            cat.emoji!,
                            style: const TextStyle(fontSize: 20),
                          ),
                        if (cat.emoji == null || cat.emoji!.isEmpty)
                          Icon(
                            Icons.category_outlined,
                            color: cat.color,
                            size: 22,
                          ),
                        const SizedBox(width: 8),
                        Text(
                          cat.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (cat) => setState(() => selectedCategory = cat),
              ),
            ),
            const SizedBox(height: 24),

            // Repeat Days
            Text('Repeat Days', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing:
                  8, // Added runSpacing for better layout on multiple lines
              children: allDays.map((day) {
                final selected = repeatDays.contains(day);
                return ChoiceChip(
                  label: Text(
                    day,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selected
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
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
              items: ringtones
                  .map(
                    (r) => DropdownMenuItem(
                      value: r,
                      child: Text(
                        r,
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => ringtone = val ?? 'Default'),
              decoration: InputDecoration(
                // labelText: 'Select Ringtone',
                labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              iconSize: 28,
              dropdownColor: Colors.grey[50],
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
            ),
            const SizedBox(height: 24),

            // Vibration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vibration',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Switch(
                  value: vibration,
                  onChanged: (val) => setState(
                    () => vibration = val,
                  ), // Active color from theme's switchTheme
                ),
              ],
            ),
            const SizedBox(height: 8),

            // One-time alarm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'One-time alarm',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
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
                Text(
                  'Pre-alarm',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Switch(
                  value: preAlarm,
                  onChanged: (val) => setState(() => preAlarm = val),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Snooze duration
            Text(
              'Snooze duration (minutes)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: snooze,
              items: snoozeOptions
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) => setState(() => snooze = val ?? '5 minutes'),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Note
            Text(
              'Note (optional)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Add a note...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onChanged: (v) => note = v,
            ),
            const SizedBox(height: 32),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // Use Expanded for buttons to fill space better
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      side: const BorderSide(color: Colors.deepPurple),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ), // Removed horizontal padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      await _addAlarmToDb();
                      if (selectedTime != null &&
                          selectedCategory != null &&
                          label.trim().isNotEmpty &&
                          Navigator.canPop(context)) {
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text(
                      'Add Alarm',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
