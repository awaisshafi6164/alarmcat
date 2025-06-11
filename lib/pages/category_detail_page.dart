import 'package:flutter/material.dart';
import '../models/alarm_category.dart';

class CategoryDetailPage extends StatelessWidget {
  final AlarmCategory category;
  const CategoryDetailPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${category.name} Settings'),
        backgroundColor: category.color, // AppBar color dynamically changes with category
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.music_note),
            title: Text('Ringtone/Sound', style: Theme.of(context).textTheme.bodyMedium),
            subtitle: Text('Default', style: Theme.of(context).textTheme.bodySmall),
            onTap: () {
              // TODO: Implement ringtone picker
            },
          ),
          ListTile(
            leading: const Icon(Icons.vibration),
            title: Text('Vibration Pattern', style: Theme.of(context).textTheme.bodyMedium),
            subtitle: Text('Standard', style: Theme.of(context).textTheme.bodySmall),
            onTap: () {
              // TODO: Implement vibration pattern picker
            },
          ),
          ListTile(
            leading: const Icon(Icons.snooze),
            title: Text('Snooze Duration', style: Theme.of(context).textTheme.bodyMedium),
            subtitle: Text('5 minutes', style: Theme.of(context).textTheme.bodySmall),
            onTap: () {
              // TODO: Implement snooze duration picker
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.wb_sunny), // Changed icon for Gentle Wake-up
            title: Text('Gentle Wake-up', style: Theme.of(context).textTheme.bodyMedium),
            trailing: Icon(Icons.lock, color: Colors.amber[700]),
            onTap: () {
              // TODO: Premium feature
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: Text('Pre-alarms/Reminders', style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              // TODO: Implement pre-alarm/reminder
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: Text('One-time Alarms', style: Theme.of(context).textTheme.bodyMedium),
            subtitle: Text('Delete after dismiss', style: Theme.of(context).textTheme.bodySmall),
            onTap: () {
              // TODO: Implement one-time alarm logic
            },
          ),
          ListTile(
            leading: const Icon(Icons.note),
            title: Text('Notes/Reminders', style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              // TODO: Implement notes/reminders
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cloud_upload), // More specific icon for cloud sync
            title: Text('Cloud Backup & Sync', style: Theme.of(context).textTheme.bodyMedium),
            trailing: Icon(Icons.lock, color: Colors.amber[700]),
            onTap: () {
              // TODO: Premium feature
            },
          ),
          ListTile(
            leading: const Icon(Icons.widgets),
            title: Text('Widgets', style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              // TODO: Implement widgets
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens), // More specific icon for theme
            title: Text('Theme/Personalization', style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              // TODO: Implement theme/personalization
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text('Location Based Alarms', style: Theme.of(context).textTheme.bodyMedium),
            trailing: Icon(Icons.lock, color: Colors.amber[700]),
            onTap: () {
              // TODO: Premium feature
            },
          ),
          ListTile(
            leading: const Icon(Icons.wb_cloudy), // More generic cloud icon for weather
            title: Text('Weather Integration', style: Theme.of(context).textTheme.bodyMedium),
            trailing: Icon(Icons.lock, color: Colors.amber[700]),
            onTap: () {
              // TODO: Premium feature
            },
          ),
          ListTile(
            leading: const Icon(Icons.music_note), // Using music_note again, or a spotify icon
            title: Text('Spotify/Music Service Integration', style: Theme.of(context).textTheme.bodyMedium),
            trailing: Icon(Icons.lock, color: Colors.amber[700]),
            onTap: () {
              // TODO: Premium feature
            },
          ),
        ],
      ),
    );
  }
}