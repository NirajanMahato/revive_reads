import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/features/dashboard/domain/use_case/get_books_usecase.dart';
import 'package:revive_reads/features/dashboard/domain/use_case/search_books_usecase.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_event.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetBooksUseCase getBooksUseCase;
  final SearchBooksUseCase searchBooksUseCase;

  BookBloc({
    required this.getBooksUseCase,
    required this.searchBooksUseCase,
  }) : super(BookInitial()) {
    on<FetchBooksEvent>(_onFetchBooks);
    on<SearchBooksEvent>(_onSearchBooks);
  }

  void _onFetchBooks(FetchBooksEvent event, Emitter<BookState> emit) async {
    emit(BookLoading());
    final result = await getBooksUseCase();
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (books) => emit(BookLoaded(books)),
    );
  }

  void _onSearchBooks(SearchBooksEvent event, Emitter<BookState> emit) async {
    emit(BookLoading());
    final result = await searchBooksUseCase(event.query);
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (books) => emit(BookLoaded(books)),
    );
  }
}
