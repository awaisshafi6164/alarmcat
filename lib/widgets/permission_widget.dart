import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionWidget extends StatefulWidget {
  const PermissionWidget(this.permission, {super.key});

  final Permission permission;

  @override
  State<PermissionWidget> createState() => _PermissionWidgetState();
}

class _PermissionWidgetState extends State<PermissionWidget> {
  PermissionStatus _status = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final status = await widget.permission.status;
    setState(() => _status = status);
  }

  Future<void> _requestPermission() async {
    final result = await widget.permission.request();
    setState(() => _status = result);
  }

  Future<void> _checkServiceStatus(BuildContext context) async {
    if (widget.permission is PermissionWithService) {
      final serviceStatus =
          await (widget.permission as PermissionWithService).serviceStatus;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Service status: $serviceStatus')));
    }
  }

  Color _getStatusColor(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.permanentlyDenied:
        return Colors.grey;
      case PermissionStatus.restricted:
        return Colors.orange;
      case PermissionStatus.limited:
        return Colors.orange;
      default:
        return Colors.black45;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.permission.toString().split('.').last),
      subtitle: Text(
        _status.toString().split('.').last,
        style: TextStyle(color: _getStatusColor(_status)),
      ),
      trailing: ElevatedButton(
        onPressed: _requestPermission,
        child: const Text("Request"),
      ),
      onTap: () => _checkServiceStatus(context),
    );
  }
}
