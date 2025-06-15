// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:alarmcat/main.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Count the number of '0' widgets before tapping
    final zeroBefore = find.text('0');
    final zeroCountBefore = tester.widgetList(zeroBefore).length;

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Count the number of '0' and '1' widgets after tapping
    final zeroAfter = find.text('0');
    final oneAfter = find.text('1');
    final zeroCountAfter = tester.widgetList(zeroAfter).length;
    final oneCountAfter = tester.widgetList(oneAfter).length;

    // At least one '0' should be replaced by '1'
    expect(oneCountAfter, greaterThan(0));
    expect(zeroCountAfter, lessThan(zeroCountBefore));
  });
}
