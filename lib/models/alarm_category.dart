import 'package:flutter/material.dart';

class AlarmCategory {
  String name; // Removed final
  IconData? icon; // Removed final
  String? emoji; // Removed final
  final Color color;
  bool enabled;

  AlarmCategory({
    required this.name,
    this.icon, // No longer required
    this.emoji,
    required this.color,
    this.enabled = true,
  });
}