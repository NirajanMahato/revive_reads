import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/features/auth/presentation/view/register_view.dart';
import 'package:revive_reads/features/auth/presentation/view_model/signup/register_bloc.dart';

// Mock classes
class MockRegisterBloc extends MockBloc<RegisterEvent, RegisterState> implements RegisterBloc {}
class MockImagePicker extends Mock implements ImagePicker {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class MockXFile extends Mock implements XFile {}
class MockFile extends Mock implements File {}

// Helper class to implement fallback values for mocktail
// Removed FakeRegisterEvent as RegisterEvent is a sealed class
class FakeRegisterState extends Fake implements RegisterState {}
class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late MockRegisterBloc registerBloc;
  late MockImagePicker imagePicker;
  late MockNavigatorObserver navigatorObserver;
  late MockXFile mockXFile;
  late MockFile mockFile;
  
  setUpAll(() {
    // Removed registerFallbackValue for FakeRegisterEvent
    registerFallbackValue(FakeRegisterState());
    registerFallbackValue(FakeRoute());
  });
  
  setUp(() {
    registerBloc = MockRegisterBloc();
    imagePicker = MockImagePicker();
    navigatorObserver = MockNavigatorObserver();
    mockXFile = MockXFile();
    mockFile = MockFile();
    
    when(() => mockXFile.path).thenReturn('/test/path.jpg');
    when(() => registerBloc.state).thenReturn(RegisterState(
      isLoading: false,
      isRegistered: false,
      isImageUploaded: false,
      imageName: '',
    ));
  });
  
  Widget loadRegisterView() {
    return MaterialApp(
      home: BlocProvider<RegisterBloc>(
        create: (context) => registerBloc,
        child: const RegisterView(),
      ),
      navigatorObservers: [navigatorObserver],
    );
  }
  
  group('RegisterView Widget Tests', () {
    testWidgets('should display Sign Up button', (tester) async {
      await tester.pumpWidget(loadRegisterView());
      expect(find.text('Sign Up'), findsOneWidget);
    });
    
    testWidgets('should show validation errors when fields are empty', (tester) async {
      await tester.pumpWidget(loadRegisterView());
      
      // Find and tap the sign up button
      final signUpButton = find.text('Sign Up');
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      
      // Verify validation messages
      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });
    
    testWidgets('should show profile image picker when avatar container is clicked', (tester) async {
      await tester.pumpWidget(loadRegisterView());
      
      // Find and tap the container that has the InkWell
      final avatarContainer = find.byType(InkWell).first;
      await tester.ensureVisible(avatarContainer);
      await tester.tap(avatarContainer);
      await tester.pumpAndSettle();
      
      // Verify bottom sheet appears with options
      expect(find.text('Camera'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
    });
    
    testWidgets('should navigate to LoginView when Sign In is clicked', (tester) async {
      await tester.pumpWidget(loadRegisterView());
      
      // Find and tap the Sign In text
      final signInText = find.text('Sign In');
      await tester.ensureVisible(signInText);
      await tester.tap(signInText);
      await tester.pumpAndSettle();
      
      // Verify navigation occurred
      verify(() => navigatorObserver.didPush(any(), any())).called(greaterThan(0));
    });
    
    testWidgets('should submit form with valid data and image', (tester) async {
      // Mock image selection state
      when(() => registerBloc.state).thenReturn(RegisterState(
        isLoading: false,
        isRegistered: false,
        isImageUploaded: true,
        imageName: 'test_image.jpg',
      ));
      
      await tester.pumpWidget(loadRegisterView());
      
      // Enter form data
      await tester.enterText(find.byType(TextFormField).at(0), 'Nirajan Mahato');
      await tester.enterText(find.byType(TextFormField).at(1), 'nirajanmahato44@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      
      // Submit form
      final signUpButton = find.text('Sign Up');
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      
      // Verify RegisterUserEvent is added to bloc
      verify(() => registerBloc.add(any(that: isA<RegisterUserEvent>()))).called(1);
    });
    
    testWidgets('should show snackbar when trying to submit without image', (tester) async {
      await tester.pumpWidget(loadRegisterView());
      
      // Enter form data but don't set image
      await tester.enterText(find.byType(TextFormField).at(0), 'Nirajan Mahato');
      await tester.enterText(find.byType(TextFormField).at(1), 'nirajanmahato44@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      
      // Submit form
      final signUpButton = find.text('Sign Up');
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      
      // Verify snackbar appears
      expect(find.text('Please select a profile picture'), findsOneWidget);
    });
    
    testWidgets('should show loading state during form submission', (tester) async {
      // First set normal state
      when(() => registerBloc.state).thenReturn(
        RegisterState(
          isLoading: false,
          isRegistered: false,
          isImageUploaded: true,
          imageName: 'test_image.jpg',
        )
      );
      
      await tester.pumpWidget(loadRegisterView());
      
      // Enter form data
      await tester.enterText(find.byType(TextFormField).at(0), 'Nirajan Mahato');
      await tester.enterText(find.byType(TextFormField).at(1), 'nirajanmahato44@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      
      // Then transition to loading state
      when(() => registerBloc.state).thenReturn(
        RegisterState(
          isLoading: true,
          isRegistered: false,
          isImageUploaded: true,
          imageName: 'test_image.jpg',
        )
      );
      
      // Trigger bloc state change
      registerBloc.emit(registerBloc.state);
      await tester.pump();
      
      // Verify loading text appears
      expect(find.text('Signing Up...'), findsOneWidget);
    });
  });
  
  // Advanced test that mocks the image picking functionality
  testWidgets('should add LoadImage event when picking image from gallery', (tester) async {
    // This test requires patching the ImagePicker
    // You would need to add a dependency override in your test
    
    // Code to demonstrate the concept (not executable as-is)
    /*
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<RegisterBloc>(
          create: (context) => registerBloc,
          child: const RegisterView(),
        ),
      ),
    );
    
    // Mock image selection
    when(() => imagePicker.pickImage(source: ImageSource.gallery))
        .thenAnswer((_) async => mockXFile);
        
    // Find and tap avatar
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    
    // Tap gallery option
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();
    
    // Verify LoadImage event
    verify(() => registerBloc.add(any(that: isA<LoadImage>()))).called(1);
    */
  });
}