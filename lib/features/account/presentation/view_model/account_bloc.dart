import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:revive_reads/features/account/domain/entity/account_entity.dart';
import 'package:revive_reads/features/account/domain/use_case/get_account_usecase.dart';
import 'package:revive_reads/features/account/domain/use_case/logout_usecase.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetAccountUseCase _getAccountUseCase;
  final LogoutUseCase _logoutUseCase;

  AccountBloc({
    required GetAccountUseCase getAccountUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _getAccountUseCase = getAccountUseCase,
        _logoutUseCase = logoutUseCase,
        super(AccountState.initial()) {
    on<LoadAccount>(_onLoadAccount);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadAccount(
      LoadAccount event, Emitter<AccountState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getAccountUseCase.call(event.userId);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (account) => emit(state.copyWith(
        isLoading: false,
        account: account,
        error: null,
      )),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _logoutUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (_) => emit(const AccountState(
        isLoading: false,
        isLoggedOut: true,
      )),
    );
  }
}
