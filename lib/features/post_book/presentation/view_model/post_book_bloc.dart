import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/features/post_book/domain/entity/post_book_entity.dart';
import 'package:revive_reads/features/post_book/domain/use_case/post_book_usecase.dart';
import 'package:revive_reads/app/shared_prefs/token_shared_prefs.dart';
import 'post_book_event.dart';
import 'post_book_state.dart';

class PostBookBloc extends Bloc<PostBookEvent, PostBookState> {
  final PostBookUseCase postBookUseCase;
  final TokenSharedPrefs tokenSharedPrefs;

  PostBookBloc(this.postBookUseCase, this.tokenSharedPrefs) : super(PostBookInitial()) {
    on<SubmitBookEvent>((event, emit) async {
      emit(PostBookLoading());

      // Retrieve token from shared preferences
      final tokenResult = await tokenSharedPrefs.getToken();
      String token = '';
      tokenResult.fold(
        (failure) => emit(PostBookFailure('Failed to retrieve token: ${failure.message}')),
        (retrievedToken) => token = retrievedToken,
      );

      if (token.isEmpty) {
        emit(PostBookFailure('User not logged in. Please log in first.'));
        return;
      }

      // Convert SubmitBookEvent to PostBookEntity
      final postBookEntity = PostBookEntity(
        title: event.title,
        description: event.description,
        price: event.price,
        genre: event.genre,
        condition: event.condition,
        images: event.images,
        delivery: event.delivery,
      );

      // Call UseCase with the token
      final result = await postBookUseCase.call(postBookEntity, token);

      result.fold(
        (failure) => emit(PostBookFailure(failure.message)),
        (_) => emit(PostBookSuccess()),
      );
    });
  }
}
