import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alarmcat/widgets/alarm_tile.dart';
import 'package:alarmcat/widgets/category_tile.dart';
import 'package:alarmcat/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays alarm tiles', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));

    expect(find.byType(AlarmTile), findsWidgets);
  });

  testWidgets('HomeScreen displays category tiles', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));

    expect(find.byType(CategoryTile), findsWidgets);
  });

  testWidgets('AlarmTile shows correct label', (WidgetTester tester) async {
    const alarmLabel = 'Morning Alarm';
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AlarmTile(label: alarmLabel),
      ),
    ));

    expect(find.text(alarmLabel), findsOneWidget);
  });

  testWidgets('CategoryTile shows correct name', (WidgetTester tester) async {
    const categoryName = 'Work';
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CategoryTile(name: categoryName),
      ),
    ));

    expect(find.text(categoryName), findsOneWidget);
  });
}