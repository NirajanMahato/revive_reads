import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/features/auth/presentation/view/login_view.dart';
import 'package:revive_reads/features/auth/presentation/view_model/login/login_bloc.dart';

// UI testing

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockLoginBloc loginBloc;

  setUp(() {
    loginBloc = MockLoginBloc();
  });

  Widget loadLoginView() {
    return BlocProvider<LoginBloc>(
      create: (context) => loginBloc,
      child: MaterialApp(home: LoginView()),
    );
  }

  testWidgets('check for the text in button of the login UI', (tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    // find button by text
    final result = find.widgetWithText(ElevatedButton, 'Login');

    expect(result, findsOneWidget);
  });

  testWidgets('Check for the text in Login UI', (tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    final result = find.text('Login');

    expect(result, findsOneWidget);
  });

  testWidgets('Check for the email and password', (tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextField).at(0), 'nirajanmahato@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), 'pass123');

    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();

    expect(find.text('nirajanmahato@gmail.com'), findsOneWidget);
    expect(find.text('pass123'), findsOneWidget);
  });

  testWidgets('Check for the validator error', (tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    // Tap the ElevatedButton to trigger form validation
    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('Login success', (tester) async {
    when(() => loginBloc.state).thenReturn(const LoginState(
      isLoading: true,
      isSuccess: true,
    ));

    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(TextField).at(0), 'nirajanmahato@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), 'pass123');

    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();

    expect(loginBloc.state.isSuccess, true);
  });
}
