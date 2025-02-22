import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:revive_reads/features/auth/domain/entity/user_entity.dart';
import 'package:revive_reads/features/auth/domain/use_case/get_user_by_id_usecase.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetUserByIdUsecase _getUserByIdUsecase;

  AccountBloc({required GetUserByIdUsecase getUserByIdUsecase})
      : _getUserByIdUsecase = getUserByIdUsecase,
        super(AccountState.initial()) {
    on<LoadUser>(_onLoadUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<AccountState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getUserByIdUsecase.call(event.userId);

    if (result.isLeft()) {
      // Handle the failure case properly
      final failure = result.fold((failure) => failure, (user) => null);
      emit(state.copyWith(
        isLoading: false,
        error: failure?.message ?? 'Unknown error occurred',
      ));
    } else {
      // Handle success (Right) case
      final userData = result.fold((failure) => null, (user) => user);
      emit(state.copyWith(
        isLoading: false,
        user: userData,
        error: null,
      ));
    }
  }
}
