import 'package:flutter/material.dart';

class AlarmCategory {
  final String name;
  final IconData icon;
  final Color color;
  bool enabled;

  AlarmCategory({
    required this.name,
    required this.icon,
    required this.color,
    this.enabled = true,
  });
}