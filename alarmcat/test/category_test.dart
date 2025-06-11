import 'package:flutter_test/flutter_test.dart';
import 'package:alarmcat/models/category.dart';

void main() {
  group('Category Model Tests', () {
    test('Category should be created with correct properties', () {
      final category = Category(
        name: 'Work',
        isEnabled: true,
        ringtone: 'default_ringtone.mp3',
        vibrationPattern: [100, 200, 100],
        snoozeDuration: 10,
      );

      expect(category.name, 'Work');
      expect(category.isEnabled, true);
      expect(category.ringtone, 'default_ringtone.mp3');
      expect(category.vibrationPattern, [100, 200, 100]);
      expect(category.snoozeDuration, 10);
    });

    test('Category toggling should work correctly', () {
      final category = Category(
        name: 'Personal',
        isEnabled: false,
      );

      category.toggle();
      expect(category.isEnabled, true);

      category.toggle();
      expect(category.isEnabled, false);
    });

    test('Category settings should be updated correctly', () {
      final category = Category(
        name: 'Fitness',
        isEnabled: true,
        ringtone: 'fitness_ringtone.mp3',
        vibrationPattern: [300, 100, 300],
        snoozeDuration: 5,
      );

      category.updateSettings(
        ringtone: 'new_fitness_ringtone.mp3',
        vibrationPattern: [200, 200, 200],
        snoozeDuration: 15,
      );

      expect(category.ringtone, 'new_fitness_ringtone.mp3');
      expect(category.vibrationPattern, [200, 200, 200]);
      expect(category.snoozeDuration, 15);
    });
  });
}