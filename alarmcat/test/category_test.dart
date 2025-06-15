import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/alarm_category.dart';

void main() {
  group('AlarmCategory Model', () {
    test('should create with correct values', () {
      final category = AlarmCategory(
        name: 'Test',
        color: Colors.red,
        enabled: false,
      );
      expect(category.name, 'Test');
      expect(category.color, Colors.red);
      expect(category.enabled, false);
    });

    test('should toggle enabled property', () {
      final category = AlarmCategory(
        name: 'Toggle',
        color: Colors.green,
        enabled: false,
      );
      category.enabled = true;
      expect(category.enabled, true);
      category.enabled = false;
      expect(category.enabled, false);
    });
  });
}
