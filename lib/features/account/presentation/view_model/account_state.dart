part of 'account_bloc.dart';

class AccountState extends Equatable {
  final UserEntity user;
  final bool isLoading;
  final String? error;

  const AccountState({
    required this.user,
    required this.isLoading,
    this.error,
  });

  factory AccountState.initial() {
    return const AccountState(
        user: UserEntity(
          fullName: '',
          email: '',
          password: '',
          phone: '',
          address: '',
          role: '',
          avatar: ''
        ),
        isLoading: false);
  }

  AccountState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
  }) {
    return AccountState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object> get props => [user, isLoading];
}
