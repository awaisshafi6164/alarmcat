import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:alarmcat/widgets/AlarmPermissionsWidget.dart'; // Update path if needed

import '../widgets/permission_widget.dart'; // Your reusable widget

class PermissionSettingsPage extends StatelessWidget {
  const PermissionSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final permissionsToShow = Permission.values.where((permission) {
      if (Platform.isIOS) {
        return permission == Permission.notification; // iOS: Notifications only
      } else {
        return permission == Permission.notification || // 🔔 Notifications
            permission == Permission.scheduleExactAlarm || // ⏰ Exact Alarms
            permission ==
                Permission.ignoreBatteryOptimizations || // 🔋 Background
            permission == Permission.accessNotificationPolicy; // 🔕 DND
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Permissions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AlarmPermissionsWidget(),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              ...permissionsToShow.map(
                (permission) => PermissionWidget(permission),
              ),
              const SizedBox(height: 24),
              Text(
                "These permissions are essential for alarm notifications and background operation.",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
