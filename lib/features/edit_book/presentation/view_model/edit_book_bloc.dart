import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/app/shared_prefs/token_shared_prefs.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/edit_book/domain/use_case/update_book_usecase.dart';
import 'package:revive_reads/features/edit_book/presentation/view_model/edit_book_event.dart';
import 'package:revive_reads/features/edit_book/presentation/view_model/edit_book_state.dart';
import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';

class EditBookBloc extends Bloc<EditBookEvent, EditBookState> {
  final UpdateBookUseCase updateBookUseCase;
  final TokenSharedPrefs tokenSharedPrefs;

  EditBookBloc({
    required this.updateBookUseCase,
    required this.tokenSharedPrefs,
  }) : super(EditBookInitial()) {
    on<UpdateBookEvent>(_onUpdateBook);
  }

  Future<void> _onUpdateBook(
    UpdateBookEvent event,
    Emitter<EditBookState> emit,
  ) async {
    emit(EditBookLoading());

    final tokenResult = await tokenSharedPrefs.getToken();

    final result = await tokenResult.fold(
      (failure) async {
        return Left<Failure, MyBookEntity>(failure);
      },
      (token) async {
        // Await the use case result
        return await updateBookUseCase(
          event.bookId,
          event.title,
          event.description,
          event.price,
          event.genre,
          event.condition,
          event.delivery,
          event.newImages,
          event.existingImages,
          token,
        );
      },
    );

    result.fold(
      (failure) => emit(EditBookFailure(failure.message)),
      (updatedBook) => emit(EditBookSuccess(updatedBook)),
    );
  }
}
