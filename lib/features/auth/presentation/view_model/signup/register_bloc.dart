import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/core/common/snackbar/my_snackbar.dart';
import 'package:revive_reads/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:revive_reads/features/auth/domain/use_case/upload_image_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final CreateUserUsecase _createUserUsecase;
  final UploadImageUsecase _uploadImageUsecase;

  RegisterBloc({
    required CreateUserUsecase createUserUsecase,
    required UploadImageUsecase uploadImageUsecase,
  })  : _createUserUsecase = createUserUsecase,
        _uploadImageUsecase = uploadImageUsecase,
        super(RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterUserEvent);
    on<LoadImage>(_onLoadImage);
  }

  Future<void> _onRegisterUserEvent(
      RegisterUserEvent event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(isLoading: true, isRegistered: false));

    final newUser = await _createUserUsecase.call(
      CreateUserParams(
          fullName: event.fullName,
          email: event.email,
          password: event.password,
          phone: '',
          address: '',
          avatar: event.avatar,
          role: "user"),
    );
    newUser.fold(
      (l) => emit(state.copyWith(isLoading: false, isRegistered: false)),
      (r) {
        emit(state.copyWith(isLoading: false, isRegistered: true));
        showMySnackBar(
            context: event.context, message: "Registration Successful");
      },
    );
  }

  void _onLoadImage(
    LoadImage event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _uploadImageUsecase.call(
      UploadImageParams(
        file: event.file,
      ),
    );

    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isImageUploaded: false)),
      (r) {
        emit(state.copyWith(
            isLoading: false, isImageUploaded: true, imageName: r));
      },
    );
  }

// // Handle NavigateLoginScreenEvent
//   Future<void> _onNavigateLoginScreenEvent(
//       NavigateLoginScreenEvent event, Emitter<RegisterState> emit) async {
//     Navigator.push(
//       event.context,
//       MaterialPageRoute(
//         builder: (context) => BlocProvider.value(
//           value: _loginBloc,
//           child: event.destination,
//         ),
//       ),
//     );
//   }
}
