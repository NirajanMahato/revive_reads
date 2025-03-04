import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/features/single_book/domain/entity/book_detail_entity.dart';
import 'package:revive_reads/features/single_book/presentation/view/book_detail_view.dart';
import 'package:revive_reads/features/single_book/presentation/view_model/book_detail_bloc.dart';

class MockBookDetailBloc extends MockBloc<BookDetailEvent, BookDetailState>
    implements BookDetailBloc {}

void main() {
  late MockBookDetailBloc bookDetailBloc;
  const bookId = "1";

  final bookDetail = BookDetailEntity(
    id: bookId,
    title: "Quantum Physics",
    description: "An advanced study on quantum theory",
    genre: "Science",
    price: 599.0,
    condition: "Brand New",
    images: ["book.jpg"],
    postedDate: DateTime.now(),
    sellerName: "John Doe",
    sellerEmail: "johndoe@gmail.com",
    sellerAvatar: "default_avatar.png",
    sellerAddress: "Kathmandu, Nepal",
  );

  setUp(() {
    bookDetailBloc = MockBookDetailBloc();
  });

  Widget createBookDetailView() {
    return BlocProvider<BookDetailBloc>.value(
      value: bookDetailBloc,
      child: const MaterialApp(
        home: BookDetailView(bookId: bookId),
      ),
    );
  }

  testWidgets('Should show loading indicator while fetching book details',
      (tester) async {
    when(() => bookDetailBloc.state).thenReturn(BookDetailLoading());

    await tester.pumpWidget(createBookDetailView());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should display book details when loaded', (tester) async {
    when(() => bookDetailBloc.state).thenReturn(BookDetailLoaded(bookDetail));

    await tester.pumpWidget(createBookDetailView());
    await tester.pumpAndSettle();

    expect(find.text("Quantum Physics"), findsOneWidget);
    expect(find.text("Genre: Science"), findsOneWidget);
    expect(find.text("An advanced study on quantum theory"), findsOneWidget);
    expect(find.text("Rs. 599.00"), findsOneWidget);
    expect(find.text("Brand New"), findsOneWidget);
    expect(find.text("Seller Information"), findsOneWidget);
    expect(find.text("John Doe"), findsOneWidget);
    expect(find.text("johndoe@gmail.com"), findsOneWidget);
    expect(find.text("Location: Kathmandu, Nepal"), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  testWidgets('Should display error message when API call fails',
      (tester) async {
    when(() => bookDetailBloc.state)
        .thenReturn(const BookDetailError("Failed to fetch book details"));

    await tester.pumpWidget(createBookDetailView());
    await tester.pumpAndSettle();

    expect(find.text("Error: Failed to fetch book details"), findsOneWidget);
  });

  testWidgets('Should call FetchBookDetailEvent when screen loads',
      (tester) async {
    when(() => bookDetailBloc.state).thenReturn(BookDetailLoading());

    await tester.pumpWidget(createBookDetailView());
    await tester.pumpAndSettle();

    verify(() => bookDetailBloc.add(const FetchBookDetailEvent(bookId)))
        .called(1);
  });

  testWidgets('Should tap Save button', (tester) async {
    when(() => bookDetailBloc.state).thenReturn(BookDetailLoaded(bookDetail));

    await tester.pumpWidget(createBookDetailView());
    await tester.pumpAndSettle();

    final saveButton = find.widgetWithText(ElevatedButton, "Save");
    expect(saveButton, findsOneWidget);

    await tester.tap(saveButton);
    await tester.pumpAndSettle();
  });

  testWidgets('Should tap Chat Now button', (tester) async {
    when(() => bookDetailBloc.state).thenReturn(BookDetailLoaded(bookDetail));

    await tester.pumpWidget(createBookDetailView());
    await tester.pumpAndSettle();

    final chatButton = find.widgetWithText(ElevatedButton, "Chat Now");
    expect(chatButton, findsOneWidget);

    await tester.tap(chatButton);
    await tester.pumpAndSettle();
  });
}
