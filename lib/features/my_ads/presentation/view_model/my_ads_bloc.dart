import 'package:bloc/bloc.dart';
import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';
import 'package:revive_reads/features/my_ads/domain/use_case/delete_book_usecase.dart';
import 'package:revive_reads/features/my_ads/domain/use_case/get_user_books_usecase.dart';
import 'package:revive_reads/features/my_ads/domain/use_case/mark_as_sold_usecase.dart';
import 'package:revive_reads/features/my_ads/presentation/view_model/my_ads_event.dart';
import 'package:revive_reads/features/my_ads/presentation/view_model/my_ads_state.dart';

class MyAdsBloc extends Bloc<MyAdsEvent, MyAdsState> {
  final GetUserBooksUseCase getUserBooksUseCase;
  final DeleteBookUseCase deleteBookUseCase;
  final MarkAsSoldUseCase markAsSoldUseCase;

  MyAdsBloc({
    required this.getUserBooksUseCase,
    required this.deleteBookUseCase,
    required this.markAsSoldUseCase,
  }) : super(MyAdsInitial()) {
    on<FetchUserBooksEvent>(_onFetchUserBooks);
    on<DeleteBookEvent>(_onDeleteBook);
    on<MarkBookAsSoldEvent>(_onMarkAsSold);
  }

  Future<void> _onFetchUserBooks(
    FetchUserBooksEvent event,
    Emitter<MyAdsState> emit,
  ) async {
    try {
      emit(MyAdsLoading());
      final result = await getUserBooksUseCase();
      result.fold(
        (failure) => emit(MyAdsError(failure.message)),
        (books) =>
            emit(MyAdsLoaded(books.where((book) => book != null).toList())),
      );
    } catch (e) {
      emit(MyAdsError('Failed to fetch books: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteBook(
    DeleteBookEvent event,
    Emitter<MyAdsState> emit,
  ) async {
    final currentState = state;
    if (currentState is MyAdsLoaded) {
      emit(MyAdsLoading());
      final result = await deleteBookUseCase(event.bookId);
      result.fold(
        (failure) {
          emit(MyAdsError(failure.message));
          emit(currentState); // Revert to previous state
        },
        (_) {
          emit(MyAdsActionSuccess('Book deleted successfully'));
          emit(MyAdsLoaded(
            currentState.books
                .where((book) => book.id != event.bookId)
                .toList(),
          ));
        },
      );
    }
  }

  Future<void> _onMarkAsSold(
    MarkBookAsSoldEvent event,
    Emitter<MyAdsState> emit,
  ) async {
    final currentState = state;
    if (currentState is MyAdsLoaded) {
      emit(MyAdsLoading());
      final result = await markAsSoldUseCase(event.bookId);
      result.fold(
        (failure) {
          emit(MyAdsError(failure.message));
          emit(currentState); // Revert to previous state
        },
        (_) {
          emit(MyAdsActionSuccess('Book marked as sold'));
          emit(MyAdsLoaded(
            currentState.books.map((book) {
              if (book.id == event.bookId) {
                return MyBookEntity(
                  id: book.id,
                  title: book.title,
                  description: book.description,
                  price: book.price,
                  condition: book.condition,
                  images: book.images,
                  genre: book.genre,
                  delivery: book.delivery,
                  status: book.status,
                  sold: true,
                  createdAt: book.createdAt,
                );
              }
              return book;
            }).toList(),
          ));
        },
      );
    }
  }
}
