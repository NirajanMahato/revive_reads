import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:revive_reads/features/auth/presentation/view/register_view.dart';

void main() {
  testWidgets('RegisterView should display input fields and register button', (tester) async {
    // Build the RegisterView widget
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterView(),
      ),
    );

    // Verify the presence of input fields and buttons
    expect(find.text('Register'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3)); // Name, Email, Password fields
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('Show error if sign up is pressed with empty fields', (tester) async {
    // Build the RegisterView widget
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterView(),
      ),
    );

    // Tap the Sign Up button
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();  // Wait for any animations or updates to complete

    // Verify error messages are displayed
    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('Allow user to enter name, email, and password', (tester) async {
    // Build the RegisterView widget
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterView(),
      ),
    );

    // Enter text into the input fields
    await tester.enterText(find.byType(TextFormField).at(0), 'Nirajan Mahato');
    await tester.enterText(find.byType(TextFormField).at(1), 'nirajan@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');

    // Verify that the entered text appears in the widgets
    expect(find.text('Nirajan Mahato'), findsOneWidget);
    expect(find.text('nirajan@gmail.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);
  });
}
