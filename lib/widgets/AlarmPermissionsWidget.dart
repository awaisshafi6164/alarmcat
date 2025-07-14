import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPermissionsWidget extends StatefulWidget {
  const AlarmPermissionsWidget({super.key});

  @override
  State<AlarmPermissionsWidget> createState() => _AlarmPermissionsWidgetState();
}

class _AlarmPermissionsWidgetState extends State<AlarmPermissionsWidget> {
  PermissionStatus _notificationStatus = PermissionStatus.denied;
  PermissionStatus _alarmStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _checkStatuses();
  }

  Future<void> _checkStatuses() async {
    final notifStatus = await Permission.notification.status;
    final alarmStatus = await Permission.scheduleExactAlarm.status;

    setState(() {
      _notificationStatus = notifStatus;
      _alarmStatus = alarmStatus;
    });
  }

  Future<void> _requestNotificationPermission() async {
    final result = await Permission.notification.request();
    setState(() => _notificationStatus = result);
  }

  Future<void> _requestAlarmPermission() async {
    final result = await Permission.scheduleExactAlarm.request();
    setState(() => _alarmStatus = result);
  }

  Widget _buildPermissionTile(
    String name,
    PermissionStatus status,
    VoidCallback onRequest,
  ) {
    Color color;
    switch (status) {
      case PermissionStatus.granted:
        color = Colors.green;
        break;
      case PermissionStatus.denied:
        color = Colors.red;
        break;
      case PermissionStatus.permanentlyDenied:
        color = Colors.grey;
        break;
      default:
        color = Colors.orange;
    }

    return ListTile(
      title: Text(name),
      subtitle: Text(status.toString(), style: TextStyle(color: color)),
      trailing: ElevatedButton(
        onPressed: onRequest,
        child: const Text('Request'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPermissionTile(
          'Notification Permission',
          _notificationStatus,
          _requestNotificationPermission,
        ),
        _buildPermissionTile(
          'Exact Alarm Permission',
          _alarmStatus,
          _requestAlarmPermission,
        ),
      ],
    );
  }
}
