// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_2/main.dart';

// Mock HTTP Client
class MockClient extends Mock implements http.Client {}

void main() {
  testWidgets('Profile App shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that splash screen is displayed
    expect(find.text('Profile App'), findsOneWidget);
    expect(find.text('Memuat profil pengguna...'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    
    // Verify that CircularProgressIndicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  
  testWidgets('Profile App navigates to profile page after delay', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify we're on splash screen
    expect(find.text('Profile App'), findsOneWidget);
    
    // Fast-forward time to trigger navigation
    await tester.pump(Duration(seconds: 3));
    await tester.pumpAndSettle(); // Wait for animations to complete
    
    // Verify profile page is displayed (should still show CircularProgressIndicator while loading)
    expect(find.text('Profil Pengguna'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}