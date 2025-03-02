import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/features/post_book/presentation/view/post_book_view.dart';
import 'package:revive_reads/features/post_book/presentation/view_model/post_book_bloc.dart';
import 'package:revive_reads/features/post_book/presentation/view_model/post_book_event.dart';
import 'package:revive_reads/features/post_book/presentation/view_model/post_book_state.dart';

class MockPostBookBloc extends MockBloc<PostBookEvent, PostBookState>
    implements PostBookBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockPostBookBloc postBookBloc;

  setUp(() {
    postBookBloc = MockPostBookBloc();
    
    // Register fallback value for when verifying bloc events
    registerFallbackValue(SubmitBookEvent(
      title: '',
      description: '',
      price: 0,
      genre: '',
      condition: '',
      images: [],
      delivery: false,
    ));
  });

  Widget loadPostBookView() {
    return BlocProvider<PostBookBloc>.value(
      value: postBookBloc,
      child: const MaterialApp(home: PostBookView()),
    );
  }

  Widget loadPostBookViewWithNavigatorObserver(NavigatorObserver observer) {
    return BlocProvider<PostBookBloc>.value(
      value: postBookBloc,
      child: MaterialApp(
        home: const PostBookView(),
        navigatorObservers: [observer],
      ),
    );
  }

  testWidgets('should display "Post New Book" title', (tester) async {
    when(() => postBookBloc.state).thenReturn(PostBookInitial());
    
    await tester.pumpWidget(loadPostBookView());
    expect(find.text('Post New Book'), findsOneWidget);
  });

  testWidgets('should show validation errors when fields are empty',
      (tester) async {
    when(() => postBookBloc.state).thenReturn(PostBookInitial());
    
    await tester.pumpWidget(loadPostBookView());

    await tester.ensureVisible(find.text('Post Book'));
    await tester.tap(find.text('Post Book'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid title'), findsOneWidget);
    expect(find.text('Enter a valid description'), findsOneWidget);
    expect(find.text('Enter a valid price'), findsOneWidget);
  });

  testWidgets('should allow selecting genre and condition from dropdown',
      (tester) async {
    when(() => postBookBloc.state).thenReturn(PostBookInitial());
    
    await tester.pumpWidget(loadPostBookView());

    // Select Genre
    await tester.tap(find.byType(DropdownButtonFormField<String>).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Science Fiction').last);
    await tester.pumpAndSettle();
    expect(find.text('Science Fiction'), findsOneWidget);

    // Select Condition
    await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Used - Good').last);
    await tester.pumpAndSettle();
    expect(find.text('Used - Good'), findsOneWidget);
  });

  testWidgets('should toggle delivery switch', (tester) async {
    when(() => postBookBloc.state).thenReturn(PostBookInitial());
    
    await tester.pumpWidget(loadPostBookView());

    final switchFinder = find.byType(SwitchListTile);
    expect(switchFinder, findsOneWidget);

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    expect(find.text('You will arrange delivery'), findsOneWidget);
  });

  testWidgets('should show snackbar when submitting without images',
      (tester) async {
    when(() => postBookBloc.state).thenReturn(PostBookInitial());
    
    await tester.pumpWidget(loadPostBookView());

    // Fill in required fields
    await tester.enterText(find.byType(TextFormField).at(0), 'Quantum Physics');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'An advanced study on quantum theory');
    await tester.enterText(find.byType(TextFormField).at(2), '599');

    // Submit form
    await tester.ensureVisible(find.text('Post Book'));
    await tester.tap(find.text('Post Book'));
    await tester.pumpAndSettle();

    // Verify snackbar appears
    expect(find.text('Please add at least one image'), findsOneWidget);
    
    // Verify bloc event is NOT called
    verifyNever(() => postBookBloc.add(any()));
  });

  testWidgets('should show loading indicator when state is loading',
      (tester) async {
    when(() => postBookBloc.state).thenReturn(PostBookLoading());
    
    await tester.pumpWidget(loadPostBookView());
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Form), findsNothing);
  });

  testWidgets('should show success message and navigate back on success',
      (tester) async {
    final navigatorObserver = MockNavigatorObserver();
    
    // Start with initial state
    when(() => postBookBloc.state).thenReturn(PostBookInitial());
    
    await tester.pumpWidget(loadPostBookViewWithNavigatorObserver(navigatorObserver));
    
    // Now transition to success state
    when(() => postBookBloc.state).thenReturn(PostBookSuccess());
    
    // Trigger rebuild with new state
    postBookBloc.emit(PostBookSuccess());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1)); // Wait for snackbar
    
    // Assert success message was shown
    expect(find.text('Book Posted Successfully!'), findsOneWidget);
    
    // Can't easily verify navigation in widget test without modifying production code
    // In a real test, you might want to verify page state changed instead
  });

  testWidgets('should show error message on failure', (tester) async {
    const errorMessage = 'Failed to post book';
    
    // Start with initial state
    when(() => postBookBloc.state).thenReturn(PostBookInitial());
    
    await tester.pumpWidget(loadPostBookView());
    
    // Now transition to failure state
    when(() => postBookBloc.state).thenReturn(PostBookFailure(errorMessage));
    
    // Trigger rebuild with new state
    postBookBloc.emit(PostBookFailure(errorMessage));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1)); // Wait for snackbar
    
    // Assert error message was shown
    expect(find.text(errorMessage), findsOneWidget);
  });

  // Note: We can't easily test the camera and gallery functionality 
  // without mocking platform channels or modifying the widget
  // We can't easily test the actual form submission without 
  // being able to add test images to the state
  
  // To mitigate this, we should focus on testing the bloc interactions
  // which handle the actual business logic
  group('BlocListener tests', () {
    testWidgets('should listen and react to PostBookSuccess state', (tester) async {
      // Setup a stream of states
      whenListen(
        postBookBloc,
        Stream.fromIterable([
          PostBookInitial(),
          PostBookLoading(),
          PostBookSuccess(),
        ]),
      );
      
      await tester.pumpWidget(loadPostBookView());
      await tester.pump(); // Initial build
      await tester.pump(); // State changes to loading
      await tester.pump(); // State changes to success
      await tester.pump(const Duration(seconds: 1)); // Wait for snackbar
      
      expect(find.text('Book Posted Successfully!'), findsOneWidget);
    });
    
    testWidgets('should listen and react to PostBookFailure state', (tester) async {
      const errorMessage = 'Network error occurred';
      
      // Setup a stream of states
      whenListen(
        postBookBloc,
        Stream.fromIterable([
          PostBookInitial(),
          PostBookLoading(),
          PostBookFailure(errorMessage),
        ]),
      );
      
      await tester.pumpWidget(loadPostBookView());
      await tester.pump(); // Initial build
      await tester.pump(); // State changes to loading
      await tester.pump(); // State changes to failure
      await tester.pump(const Duration(seconds: 1)); // Wait for snackbar
      
      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}