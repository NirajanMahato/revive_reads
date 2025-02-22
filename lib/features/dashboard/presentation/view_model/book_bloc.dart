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

  Future<void> _onFetchBooks(FetchBooksEvent event, Emitter<BookState> emit) async {
    emit(BookLoading());
    final result = await getBooksUseCase();
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (books) => emit(BookLoaded(books)),
    );
  }

  Future<void> _onSearchBooks(SearchBooksEvent event, Emitter<BookState> emit) async {
    emit(BookLoading());
    final result = await getBooksUseCase();
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (books) {
        final filteredBooks = books.where(
          (book) => book.title.toLowerCase().contains(event.query.toLowerCase()),
        ).toList();
        emit(BookLoaded(filteredBooks));
      },
    );
  }

  Future<void> _onFilterByGenre(FilterByGenreEvent event, Emitter<BookState> emit) async {
    emit(BookLoading());
    final result = await getBooksUseCase();
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (books) {
        final filteredBooks = books.where(
          (book) => book.genre.toLowerCase() == event.genre.toLowerCase(),
        ).toList();
        emit(BookLoaded(filteredBooks));
      },
    );
  }
}
