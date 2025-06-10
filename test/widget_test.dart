// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharify/main.dart';

void main() {
  testWidgets('App should render without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title appears
    expect(find.text('Sharify'), findsOneWidget);
  });
}
