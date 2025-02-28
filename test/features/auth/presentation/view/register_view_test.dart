import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/core/common/widgets/custom_elevated_button.dart';
import 'package:revive_reads/core/common/widgets/custom_text_field.dart';
import 'package:revive_reads/features/auth/presentation/view/register_view.dart';
import 'package:revive_reads/features/auth/presentation/view_model/signup/register_bloc.dart';

class MockRegisterBloc extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterBloc {}

void main() {
  late MockRegisterBloc registerBloc;

  setUp(() {
    registerBloc = MockRegisterBloc();
  });

  Widget loadRegisterView() {
    return BlocProvider(
      create: (context) => registerBloc,
      child: const MaterialApp(home: RegisterView()),
    );
  }

  testWidgets('shows validation error for empty fields', (tester) async {
    await tester.pumpWidget(loadRegisterView());

    // Tap the "Sign Up" button without filling the fields
    await tester.tap(find.byType(CustomElevatedButton));
    await tester.pumpAndSettle();

    // Verify the error messages are shown for the empty fields
    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('shows profile image modal when profile picture is tapped',
      (tester) async {
    await tester.pumpWidget(loadRegisterView());

    // Tap the profile image to show the modal
    await tester.tap(find.byType(CircleAvatar));
    await tester.pumpAndSettle();

    // Verify the modal is displayed with the correct options
    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
  });

  testWidgets('selecting an image updates the profile picture', (tester) async {
    await tester.pumpWidget(loadRegisterView());

    // Tap the profile image to show the modal
    await tester.tap(find.byType(CircleAvatar));
    await tester.pumpAndSettle();

    // Tap the 'Gallery' option (simulating the image selection)
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();

    // Verify that the image picker method was called and profile image is updated
    verify(() => registerBloc.add(LoadImage(file: any()))).called(1);
  });

  testWidgets('submitting the form triggers the RegisterUserEvent',
      (tester) async {
    // Set up mock data
    final mockState = RegisterState(
        isLoading: true,
        isRegistered: false,
        isImageUploaded: true,
        imageName: 'test_image.jpg');
    when(() => registerBloc.state).thenReturn(mockState);

    // Provide data in the form fields
    await tester.pumpWidget(loadRegisterView());

    // Enter text into form fields
    await tester.enterText(
        find.byType(CustomTextField).at(0), 'Nirajan Mahato');
    await tester.enterText(
        find.byType(CustomTextField).at(1), 'nirajanmahato44@gmail.com');
    await tester.enterText(find.byType(CustomTextField).at(2), 'pass123');

    // Simulate selecting a profile picture (assuming image is selected)
    await tester.tap(find.byType(CircleAvatar));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();

    // Tap the "Sign Up" button
    await tester.tap(find.byType(CustomElevatedButton));
    await tester.pumpAndSettle();

    // Verify that RegisterUserEvent was triggered
    verify(() => registerBloc.add(RegisterUserEvent(
          context: any(named: 'context'),
          fullName: 'Nirajan Mahato',
          email: 'nirajanmahato44@gmail.com',
          password: 'pass123',
          avatar: 'test_image.jpg',
        ))).called(1);
  });
}
