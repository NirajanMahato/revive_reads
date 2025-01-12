part of 'register_bloc.dart';

class RegisterState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  RegisterState({
    required this.isLoading,
    required this.isSuccess,
    this.error,
  });

  RegisterState.initial()
      : isLoading = false,
        isSuccess = false,
        error = null;

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}
