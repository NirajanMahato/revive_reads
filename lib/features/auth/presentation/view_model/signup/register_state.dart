part of 'register_bloc.dart';

class RegisterState {
  final bool isLoading;
  final bool isImageUploaded;
  final bool isRegistered;
  final String? imageName;
  final String? error;

  RegisterState({
    required this.isLoading,
    required this.isImageUploaded,
    required this.isRegistered,
    this.imageName,
    this.error,
  });

  RegisterState.initial()
      : isLoading = false,
        isImageUploaded = false,
        isRegistered = false,
        imageName = null,
        error = null;

  RegisterState copyWith({
    bool? isLoading,
    bool? isImageUploaded,
    bool? isRegistered,
    String? imageName,
    String? error,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isImageUploaded: isImageUploaded ?? this.isImageUploaded,
      isRegistered: isRegistered ?? this.isRegistered,
      imageName: imageName ?? this.imageName,
      error: error,
    );
  }
}
