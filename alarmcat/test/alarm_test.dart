import 'package:flutter_test/flutter_test.dart';
import 'package:alarmcat/models/alarm.dart';

void main() {
  group('Alarm Model Tests', () {
    test('Alarm should initialize with correct values', () {
      final alarm = Alarm(
        time: DateTime.now(),
        label: 'Test Alarm',
        category: 'Default',
        sound: 'default_sound.mp3',
        vibrationPattern: [100, 200, 100],
        snoozeDuration: Duration(minutes: 10),
        notes: 'This is a test alarm',
      );

      expect(alarm.label, 'Test Alarm');
      expect(alarm.category, 'Default');
      expect(alarm.sound, 'default_sound.mp3');
      expect(alarm.vibrationPattern, [100, 200, 100]);
      expect(alarm.snoozeDuration, Duration(minutes: 10));
      expect(alarm.notes, 'This is a test alarm');
    });

    test('Alarm should toggle active status', () {
      final alarm = Alarm(
        time: DateTime.now(),
        label: 'Test Alarm',
        category: 'Default',
        sound: 'default_sound.mp3',
        vibrationPattern: [100, 200, 100],
        snoozeDuration: Duration(minutes: 10),
        notes: 'This is a test alarm',
      );

      alarm.toggleActive();
      expect(alarm.isActive, true);

      alarm.toggleActive();
      expect(alarm.isActive, false);
    });
  });
}