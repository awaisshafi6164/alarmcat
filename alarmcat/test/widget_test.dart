import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/widgets/alarm_card.dart';
import '../../lib/widgets/category_card.dart';
import '../../lib/models/alarm_category.dart';

void main() {
  testWidgets('AlarmCard shows correct label', (WidgetTester tester) async {
    const alarmLabel = 'Morning Alarm';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AlarmCard(
            label: alarmLabel,
            time: '07:00',
            repeatDays: 'Mon,Tue,Wed',
            enabled: true,
            onToggle: (v) {},
            ringtone: 'default',
            vibration: false,
            oneTime: false,
            preAlarm: false,
            snooze: '5',
            note: '',
          ),
        ),
      ),
    );
    expect(find.text(alarmLabel.toUpperCase()), findsOneWidget);
  });

  testWidgets('CategoryCard shows correct name', (WidgetTester tester) async {
    final category = AlarmCategory(
      name: 'Work',
      color: Colors.blue,
      enabled: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoryCard(
            category: category,
            onTap: () {},
            onToggle: (v) {},
            alarmCount: 1,
          ),
        ),
      ),
    );
    expect(find.text('Work'), findsOneWidget);
  });
}
