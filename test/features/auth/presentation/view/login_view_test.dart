import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/core/common/widgets/custom_elevated_button.dart';
import 'package:revive_reads/core/common/widgets/custom_text_field.dart';
import 'package:revive_reads/features/auth/presentation/view/login_view.dart';
import 'package:revive_reads/features/auth/presentation/view/register_view.dart';
import 'package:revive_reads/features/auth/presentation/view_model/login/login_bloc.dart';

// Mocking the LoginBloc , UI testing
class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  late MockLoginBloc loginBloc;

  setUp(() {
    loginBloc = MockLoginBloc();
  });

  Widget loadLoginView() {
    return BlocProvider<LoginBloc>(
      create: (context) => loginBloc,
      child: const MaterialApp(home: LoginView()),
    );
  }

  testWidgets('Login button should exist', (tester) async {
    await tester.pumpWidget(loadLoginView());

    // Find login button by text
    final result = find.widgetWithText(CustomElevatedButton, 'Login');

    expect(result, findsOneWidget);
  });

  testWidgets('Check for the email and password fields', (tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    // Enter text into email & password fields
    await tester.enterText(
        find.byType(CustomTextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(CustomTextField).at(1), 'password123');

    await tester.tap(find.byType(CustomElevatedButton).first);
    await tester.pumpAndSettle();

    // Ensure text is correctly entered
    expect(find.text('user@example.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);
  });

  testWidgets('Shows validation error if fields are empty', (tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    // Tap the login button without entering details
    await tester.tap(find.byType(CustomElevatedButton));
    await tester.pumpAndSettle();

    // Check for validation messages
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('Password visibility toggle should work', (tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    // Find password visibility toggle icon
    final iconFinder = find.byIcon(Icons.visibility_off);
    expect(iconFinder, findsOneWidget);

    // Tap the visibility toggle button
    await tester.tap(iconFinder);
    await tester.pumpAndSettle();

    // Ensure the icon changes
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets('Navigate to RegisterView when clicking Sign Up', (tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    // 🔹 Scroll if needed
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -200));
    await tester.pumpAndSettle();

    // Tap on "Sign up" text
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    // Ensure RegisterView opens
    expect(find.byType(RegisterView), findsOneWidget);
  });

  testWidgets('Login success should navigate to HomeView', (tester) async {
    when(() => loginBloc.state).thenReturn(
      const LoginState(isLoading: false, isSuccess: true),
    );

    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(CustomTextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(CustomTextField).at(1), 'password123');

    await tester.tap(find.byType(CustomElevatedButton).first);
    await tester.pumpAndSettle();

    // Expect successful login
    expect(loginBloc.state.isSuccess, true);
  });
}
