import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:revive_reads/features/single_book/domain/entity/book_detail_entity.dart';
import 'package:revive_reads/features/single_book/domain/use_case/get_book_detail_use_case.dart';

part 'book_detail_event.dart';
part 'book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  final GetBookDetailUseCase getBookDetailUseCase;

  BookDetailBloc(this.getBookDetailUseCase) : super(BookDetailInitial()) {
    on<FetchBookDetailEvent>((event, emit) async {
      emit(BookDetailLoading());

      final result = await getBookDetailUseCase(event.bookId);

      result.fold(
        (failure) => emit(BookDetailError(failure.message)),
        (bookDetail) => emit(BookDetailLoaded(bookDetail)),
      );
    });
  }
}
