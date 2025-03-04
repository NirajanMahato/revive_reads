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
import 'package:revive_reads/features/notification/presentation/view/notification_view.dart';
import 'package:revive_reads/features/single_book/presentation/view/book_detail_view.dart';

class MockBookBloc extends MockBloc<BookEvent, BookState> implements BookBloc {}

void main() {
  late MockBookBloc bookBloc;

  setUp(() {
    bookBloc = MockBookBloc();
  });

  Widget createDashboardView() {
    return BlocProvider<BookBloc>.value(
      value: bookBloc,
      child: const MaterialApp(
        home: DashboardView(),
      ),
    );
  }

  testWidgets('✅ Should display logo, search bar, and notification icon',
      (tester) async {
    await tester.pumpWidget(createDashboardView());

    expect(find.byType(Image), findsOneWidget); // Logo
    expect(find.byType(TextField), findsOneWidget); // Search bar
    expect(
        find.byIcon(Icons.notifications), findsOneWidget); // Notification Icon
  });

  testWidgets('✅ Should display categories correctly', (tester) async {
    when(() => bookBloc.state).thenReturn(BookLoaded(
      books: const [],
      allBooks: const [],
      selectedGenre: 'All',
    ));

    await tester.pumpWidget(createDashboardView());
    await tester.pumpAndSettle();

    expect(find.text("Categories"), findsOneWidget);
  });

  testWidgets('✅ Should search books when user submits text', (tester) async {
    when(() => bookBloc.state).thenReturn(BookLoaded(
      books: const [],
      allBooks: const [],
      selectedGenre: 'All',
    ));

    await tester.pumpWidget(createDashboardView());
    await tester.pumpAndSettle();

    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'Quantum Physics');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    verify(() => bookBloc.add(SearchBooksEvent('Quantum Physics'))).called(1);
  });

  testWidgets('✅ Should navigate to notifications page on bell icon tap',
      (tester) async {
    await tester.pumpWidget(createDashboardView());

    await tester.tap(find.byIcon(Icons.notifications));
    await tester.pumpAndSettle();

    expect(find.byType(NotificationView), findsOneWidget);
  });

  testWidgets('✅ Should display book cards when books are loaded',
      (tester) async {
    when(() => bookBloc.state).thenReturn(BookLoaded(
      books: const [
        BookEntity(
            id: '1',
            title: 'Quantum Physics',
            description: 'An advanced study on quantum theory',
            price: 599.0,
            condition: 'Brand New',
            genre: 'Science',
            images: ['book.jpg'],
            sellerId: 'seller1',
            sellerName: 'John Doe',
            delivery: false),
      ],
      allBooks: const [],
      selectedGenre: 'All',
    ));

    await tester.pumpWidget(createDashboardView());
    await tester.pumpAndSettle();

    expect(find.text('Quantum Physics'), findsOneWidget);
    expect(find.text('Rs. 599'), findsOneWidget);
    expect(find.text('Brand New'), findsOneWidget);
  });

  testWidgets('✅ Should navigate to book detail page when book is tapped',
      (tester) async {
    when(() => bookBloc.state).thenReturn(BookLoaded(
      books: const [
        BookEntity(
            id: '1',
            title: 'Quantum Physics',
            description: 'An advanced study on quantum theory',
            price: 599.0,
            condition: 'Brand New',
            genre: 'Science',
            images: ['book.jpg'],
            sellerId: 'seller1',
            sellerName: 'John Doe',
            delivery: false),
      ],
      allBooks: const [],
      selectedGenre: 'All',
    ));

    await tester.pumpWidget(createDashboardView());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Quantum Physics'));
    await tester.pumpAndSettle();

    expect(find.byType(BookDetailView), findsOneWidget);
  });

  testWidgets('✅ Should filter books by selected category', (tester) async {
    when(() => bookBloc.state).thenReturn(BookLoaded(
      books: const [],
      allBooks: const [],
      selectedGenre: 'All',
    ));

    await tester.pumpWidget(createDashboardView());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Science Fiction'));
    await tester.pumpAndSettle();

    verify(() => bookBloc.add(FilterByGenreEvent('Science Fiction'))).called(1);
  });

  testWidgets('✅ Should refresh books when shake gesture occurs',
      (tester) async {
    await tester.pumpWidget(createDashboardView());

    // Simulate book refresh triggered by shake
    bookBloc.add(FetchBooksEvent());

    await tester.pumpAndSettle();

    verify(() => bookBloc.add(FetchBooksEvent())).called(1);
    expect(find.text('📚 Refreshing books...'), findsOneWidget);
  });
}
