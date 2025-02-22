import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/features/dashboard/domain/use_case/get_books_usecase.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_event.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetBooksUseCase getBooksUseCase;

  BookBloc({required this.getBooksUseCase}) : super(BookInitial()) {
    on<FetchBooksEvent>(_onFetchBooks);
    on<SearchBooksEvent>(_onSearchBooks);
    on<FilterByGenreEvent>(_onFilterByGenre);
  }

  Future<void> _onFetchBooks(
      FetchBooksEvent event, Emitter<BookState> emit) async {
    emit(BookLoading());
    final result = await getBooksUseCase();
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (books) => emit(BookLoaded(
        books: books,
        allBooks: books,
        selectedGenre: 'All',
      )),
    );
  }

  Future<void> _onSearchBooks(
      SearchBooksEvent event, Emitter<BookState> emit) async {
    if (state is BookLoaded) {
      final currentState = state as BookLoaded;
      final allBooks = currentState.allBooks;

      final filteredBooks = allBooks
          .where((book) =>
              book.title.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(BookLoaded(
        books: filteredBooks,
        allBooks: allBooks,
        selectedGenre: currentState.selectedGenre,
      ));
    } else {
      final result = await getBooksUseCase();
      result.fold(
        (failure) => emit(BookError(failure.message)),
        (books) {
          final filteredBooks = books
              .where((book) =>
                  book.title.toLowerCase().contains(event.query.toLowerCase()))
              .toList();
          emit(BookLoaded(
            books: filteredBooks,
            allBooks: books,
            selectedGenre: 'All',
          ));
        },
      );
    }
  }

  Future<void> _onFilterByGenre(
      FilterByGenreEvent event, Emitter<BookState> emit) async {
    if (state is BookLoaded) {
      final currentState = state as BookLoaded;
      final allBooks = currentState.allBooks;

      if (event.genre == 'All') {
        emit(BookLoaded(
          books: allBooks,
          allBooks: allBooks,
          selectedGenre: 'All',
        ));
      } else {
        final filteredBooks = allBooks
            .where((book) =>
                book.genre == event.genre) // Note: removed toLowerCase()
            .toList();
        emit(BookLoaded(
          books: filteredBooks,
          allBooks: allBooks,
          selectedGenre: event.genre,
        ));
      }
    } else {
      final result = await getBooksUseCase();
      result.fold(
        (failure) => emit(BookError(failure.message)),
        (books) {
          if (event.genre == 'All') {
            emit(BookLoaded(
              books: books,
              allBooks: books,
              selectedGenre: 'All',
            ));
          } else {
            final filteredBooks = books
                .where((book) =>
                    book.genre.toLowerCase() == event.genre.toLowerCase())
                .toList();
            emit(BookLoaded(
              books: filteredBooks,
              allBooks: books,
              selectedGenre: event.genre,
            ));
          }
        },
      );
    }
  }
}
