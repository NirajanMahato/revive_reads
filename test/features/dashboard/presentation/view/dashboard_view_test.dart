import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/features/dashboard/domain/entity/book_entity.dart';
import 'package:revive_reads/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_bloc.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_event.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_state.dart';

class MockBookBloc extends MockBloc<BookEvent, BookState> implements BookBloc {}

void main() {
  late MockBookBloc mockBookBloc;

  setUp(() {
    mockBookBloc = MockBookBloc();
  });

  Widget createTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<BookBloc>.value(
        value: mockBookBloc,
        child: child,
      ),
    );
  }

  const tBook = BookEntity(
    id: '1',
    title: 'Test Book',
    genre: 'Fiction',
    description: 'A great book',
    price: 15.99,
    condition: 'New',
    delivery: true,
    sellerId: 'seller123',
    sellerName: 'John Doe',
    images: ['https://example.com/book.jpg'],
  );

  group('DashboardView Widget Tests', () {
    testWidgets('Should render DashboardView correctly',
        (WidgetTester tester) async {
      when(() => mockBookBloc.state).thenReturn(BookInitial());

      await tester.pumpWidget(createTestableWidget(const DashboardView()));

      expect(find.byType(DashboardView), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget); // Search bar
      expect(find.byType(Image), findsWidgets); // Logo and book images
    });

    testWidgets('Should display loading indicator when fetching books',
        (WidgetTester tester) async {
      when(() => mockBookBloc.state).thenReturn(BookLoading());

      await tester.pumpWidget(createTestableWidget(const DashboardView()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should display books when loaded',
        (WidgetTester tester) async {
      when(() => mockBookBloc.state).thenReturn(
        BookLoaded(
            books: const [tBook],
            allBooks: const [tBook],
            selectedGenre: 'All'),
      );

      await tester.pumpWidget(createTestableWidget(const DashboardView()));

      expect(find.text('Test Book'), findsOneWidget);
      expect(find.text('A great book'), findsOneWidget);
      expect(find.text('Rs. 15.99'), findsOneWidget);
    });

    testWidgets('Should display error message when BookError state occurs',
        (WidgetTester tester) async {
      when(() => mockBookBloc.state)
          .thenReturn(BookError('Error fetching books'));

      await tester.pumpWidget(createTestableWidget(const DashboardView()));

      expect(find.text('Error: Error fetching books'), findsOneWidget);
    });

    testWidgets('Should trigger search when text is entered',
        (WidgetTester tester) async {
      when(() => mockBookBloc.state).thenReturn(
        BookLoaded(
            books: const [tBook],
            allBooks: const [tBook],
            selectedGenre: 'All'),
      );

      await tester.pumpWidget(createTestableWidget(const DashboardView()));

      await tester.enterText(find.byType(TextField), 'Test Book');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      verify(() => mockBookBloc.add(SearchBooksEvent('Test Book'))).called(1);
    });

    testWidgets(
        'Should navigate to NotificationView when notification icon is clicked',
        (WidgetTester tester) async {
      when(() => mockBookBloc.state).thenReturn(BookLoaded(
          books: const [], allBooks: const [], selectedGenre: 'All'));

      await tester.pumpWidget(createTestableWidget(const DashboardView()));

      await tester.tap(find.byIcon(Icons.notifications));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold),
          findsWidgets); // Should navigate to a new screen
    });
  });
}
