import 'package:flutter/material.dart';
import '../models/alarm_category.dart';
import '../services/database_helper.dart';

class AddAlarmPage extends StatefulWidget {
  final bool isEdit;
  final int? id; // Add this line for alarm ID
  final String? label;
  final String? time;
  final String? category;
  final String? days;
  final String? ringtone;
  final bool? vibration;
  final bool? oneTime;
  final bool? preAlarm;
  final String? snooze;
  final String? note;
  const AddAlarmPage({
    super.key,
    this.isEdit = false,
    this.id, // Add this line
    this.label,
    this.time,
    this.category,
    this.days,
    this.ringtone,
    this.vibration,
    this.oneTime,
    this.preAlarm,
    this.snooze,
    this.note,
  });

  @override
  State<AddAlarmPage> createState() => _AddAlarmPageState();
}

class _AddAlarmPageState extends State<AddAlarmPage> {
  TimeOfDay? selectedTime;
  late String label;
  late TextEditingController labelController;
  AlarmCategory? selectedCategory;
  List<AlarmCategory> categories = [];
  late List<String> repeatDays;
  late String ringtone;
  late bool vibration;
  late bool oneTime;
  late bool preAlarm;
  late String snooze;
  late String note;

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
    print(
      '[AddAlarmPage] InitState - isEdit: ${widget.isEdit}, ID: ${widget.id}',
    );
    print('[AddAlarmPage] InitState - Alarm details:');
    print('  Label: ${widget.label}');
    print('  Time: ${widget.time}');
    print('  Category: ${widget.category}');
    print('  Days: ${widget.days}');

    label = widget.label ?? '';
    labelController = TextEditingController(text: label);
    ringtone = widget.ringtone ?? 'Default';
    vibration = widget.vibration ?? true;
    oneTime = widget.oneTime ?? false;
    preAlarm = widget.preAlarm ?? false;
    snooze = widget.snooze ?? '5 minutes';
    note = widget.note ?? '';
    if (widget.days != null && widget.days!.isNotEmpty) {
      // When editing: use the days from the existing alarm
      repeatDays = widget.days!
          .split(',')
          .map((d) => d.trim())
          .where((d) => allDays.contains(d))
          .toList();
    } else {
      // For new alarms: start with no days selected
      repeatDays = [];
    }
    if (widget.time != null && widget.time!.isNotEmpty) {
      // Try parsing both 24h and 12h formats
      String timeStr = widget.time!;
      // Remove any AM/PM if present
      timeStr = timeStr.replaceAll(RegExp(r'[^0-9:]'), '');
      final parts = timeStr.split(":");
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          selectedTime = TimeOfDay(hour: hour, minute: minute);
        }
      }
    }
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
      if (widget.category != null && widget.category!.isNotEmpty) {
        selectedCategory = categories.firstWhere(
          (cat) => cat.name == widget.category,
          orElse: () => categories.first,
        );
      } else {
        selectedCategory = categories.isNotEmpty ? categories.first : null;
      }
    });
  }

  // 3. When adding an alarm, set enabled: 1
  Future<bool> _addAlarmToDb() async {
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
      return false;
    }

    try {
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
      print('[AddAlarmPage] Created new alarm with ID: $id');
      print('[AddAlarmPage] Alarm data: $alarmData');
      return true;
    } catch (e) {
      print('[AddAlarmPage] Error creating alarm: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error creating alarm. Please try again.'),
        ),
      );
      return false;
    }
  }

  Future<bool> _updateAlarmInDb() async {
    if (selectedTime == null ||
        selectedCategory == null ||
        label.trim().isEmpty ||
        widget.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all required fields: Time, Label, Category.',
          ),
        ),
      );
      return false;
    }

    final db = await DatabaseHelper().db;

    // First verify the alarm exists
    final List<Map<String, dynamic>> existing = await db.query(
      'alarms',
      where: 'id = ?',
      whereArgs: [widget.id],
      limit: 1,
    );

    if (existing.isEmpty) {
      print('[AddAlarmPage] Error: Alarm with ID ${widget.id} not found');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Alarm not found. Please try again.'),
        ),
      );
      return false;
    }

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
      'enabled': existing.first['enabled'] ?? 1, // Preserve the enabled state
    };

    try {
      final rowsAffected = await db.update(
        'alarms',
        alarmData,
        where: 'id = ?',
        whereArgs: [widget.id],
      );

      if (rowsAffected > 0) {
        print(
          '[AddAlarmPage] Successfully updated alarm with ID: ${widget.id}',
        );
        print('[AddAlarmPage] Updated alarm data: $alarmData');
        return true;
      } else {
        print(
          '[AddAlarmPage] Error: No rows were updated for ID: ${widget.id}',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error updating alarm. Please try again.'),
          ),
        );
        return false;
      }
    } catch (e) {
      print('[AddAlarmPage] Error updating alarm: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating alarm. Please try again.'),
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // Use theme background
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Alarm' : 'Add New Alarm',
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
              controller: labelController,
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
                        if (!repeatDays.contains(day)) repeatDays.add(day);
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
              controller: TextEditingController(text: note),
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
                      bool success = false;

                      // Debug info before operation
                      print('[AddAlarmPage] Save button pressed');
                      print('  isEdit: ${widget.isEdit}');
                      print('  ID: ${widget.id}');
                      print('  Label: $label');
                      print('  Time: ${selectedTime?.format(context)}');
                      print('  Category: ${selectedCategory?.name}');

                      // Validate fields first
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

                      // Handle edit vs add
                      if (widget.isEdit == true) {
                        if (widget.id == null) {
                          print(
                            '[AddAlarmPage] Error: Edit mode but no ID provided',
                          );
                          return;
                        }
                        success = await _updateAlarmInDb();
                      } else {
                        success = await _addAlarmToDb();
                      }

                      // Debug info after operation
                      if (success) {
                        print('[AddAlarmPage] Operation successful');
                        if (widget.isEdit) {
                          print('  Updated alarm ID: ${widget.id}');
                        }
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context, true);
                        }
                      } else {
                        print('[AddAlarmPage] Operation failed');
                      }
                    },
                    child: Text(
                      widget.isEdit ? 'Edit Alarm' : 'Add Alarm',
                      style: const TextStyle(
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
