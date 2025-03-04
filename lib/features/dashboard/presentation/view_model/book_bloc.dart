import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/app/shared_prefs/token_shared_prefs.dart';
import 'package:revive_reads/features/dashboard/domain/use_case/favorite_usecase.dart';
import 'package:revive_reads/features/dashboard/domain/use_case/get_books_usecase.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_event.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetBooksUseCase getBooksUseCase;
  final AddToFavoritesUseCase addToFavoritesUseCase;
  final RemoveFromFavoritesUseCase removeFromFavoritesUseCase;
  final TokenSharedPrefs tokenSharedPrefs;

  BookBloc({
    required this.getBooksUseCase,
    required this.addToFavoritesUseCase,
    required this.removeFromFavoritesUseCase,
    required this.tokenSharedPrefs,
  }) : super(BookInitial()) {
    on<FetchBooksEvent>(_onFetchBooks);
    on<SearchBooksEvent>(_onSearchBooks);
    on<FilterByGenreEvent>(_onFilterByGenre);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
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
        isOffline: false,
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
        favoriteBookIds: currentState.favoriteBookIds,
        isOffline: currentState.isOffline,
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
            isOffline: false,
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
          favoriteBookIds: currentState.favoriteBookIds,
          isOffline: currentState.isOffline,
        ));
      } else {
        final filteredBooks = allBooks
            .where((book) => book.genre == event.genre)
            .toList();
        emit(BookLoaded(
          books: filteredBooks,
          allBooks: allBooks,
          selectedGenre: event.genre,
          favoriteBookIds: currentState.favoriteBookIds,
          isOffline: currentState.isOffline,
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
              isOffline: false,
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
              isOffline: false,
            ));
          }
        },
      );
    }
  }

  void _onToggleFavorite(
      ToggleFavoriteEvent event, Emitter<BookState> emit) async {
    if (state is BookLoaded) {
      final currentState = state as BookLoaded;
      final tokenResult = await tokenSharedPrefs.getToken();

      tokenResult.fold(
        (failure) => emit(BookError('Failed to get token')),
        (token) async {
          final result = event.isFavorite
              ? await addToFavoritesUseCase(event.bookId, token)
              : await removeFromFavoritesUseCase(event.bookId, token);

          result.fold(
            (failure) {
              emit(BookError(failure.message));
              emit(currentState); // Maintain the current state after error
            },
            (_) {
              final newFavorites =
                  Set<String>.from(currentState.favoriteBookIds);
              if (event.isFavorite) {
                newFavorites.add(event.bookId);
                emit(FavoriteActionSuccess('Book added to favorites'));
              } else {
                newFavorites.remove(event.bookId);
                emit(FavoriteActionSuccess('Book removed from favorites'));
              }

              // Emit updated state after success message
              emit(BookLoaded(
                books: currentState.books,
                allBooks: currentState.allBooks,
                selectedGenre: currentState.selectedGenre,
                favoriteBookIds: newFavorites,
                isOffline: currentState.isOffline,
              ));
            },
          );
        },
      );
    }
  }
}