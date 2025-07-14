import 'package:flutter/material.dart';

import 'permission_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'), // Style defined in theme
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.color_lens), // Consistent icon
            title: Text(
              'Theme & Personalization',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              // TODO: Implement theme settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.alarm), // Consistent icon
            title: Text(
              'Permissions',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PermissionSettingsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_upload), // Consistent icon
            title: Text(
              'Cloud Backup & Sync',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Icon(Icons.lock, color: Colors.amber[700]),
            onTap: () {
              // TODO: Premium feature
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('About', style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'AlarmCat',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.alarm),
                children: [
                  const Text('AlarmCat helps you manage alarms by category.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
