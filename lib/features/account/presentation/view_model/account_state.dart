part of 'account_bloc.dart';

class AccountState extends Equatable {
  final AccountEntity? account;
  final bool isLoading;
  final String? error;
  final bool isLoggedOut;

  const AccountState({
    this.account,
    required this.isLoading,
    this.error,
    this.isLoggedOut = false,
  });

  factory AccountState.initial() {
    return const AccountState(
      isLoading: false,
    );
  }

  AccountState copyWith({
    AccountEntity? account,
    bool? isLoading,
    String? error,
  }) {
    return AccountState(
      account: account ?? this.account,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [account, isLoading, error];
}
