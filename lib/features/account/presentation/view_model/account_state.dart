part of 'account_bloc.dart';

class AccountState extends Equatable {
  final bool isLoading;
  final AccountEntity? account;
  final String? error;
  final bool isLoggedOut;
  final bool isProfileUpdated;

  const AccountState({
    this.isLoading = false,
    this.account,
    this.error,
    this.isLoggedOut = false,
    this.isProfileUpdated = false,
  });

  factory AccountState.initial() => const AccountState();

  AccountState copyWith({
    bool? isLoading,
    AccountEntity? account,
    String? error,
    bool? isLoggedOut,
    bool? isProfileUpdated,
  }) {
    return AccountState(
      isLoading: isLoading ?? this.isLoading,
      account: account ?? this.account,
      error: error,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
      isProfileUpdated: isProfileUpdated ?? this.isProfileUpdated,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        account,
        error,
        isLoggedOut,
        isProfileUpdated,
      ];
}
