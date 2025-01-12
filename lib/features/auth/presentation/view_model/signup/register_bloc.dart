import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/features/auth/domain/use_case/create_user_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  // final LoginBloc _loginBloc;
  final CreateUserUsecase _createUserUsecase;
  RegisterBloc({
    // required LoginBloc loginBloc,
    required CreateUserUsecase createUserUsecase,
  })  :
        // _loginBloc = loginBloc,
        _createUserUsecase = createUserUsecase,
        super(RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterUserEvent);
    // on<NavigateLoginScreenEvent>(_onNavigateLoginScreenEvent);
  }

  Future<void> _onRegisterUserEvent(
      RegisterUserEvent event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    final newUser = await _createUserUsecase.call(
      CreateUserParams(
          fullName: event.fullName,
          email: event.email,
          password: event.password,
          phone: '',
          address: '',
          role: "User"),
    );
    newUser.fold(
        (failure) =>
            emit(state.copyWith(isLoading: false, error: failure.message)),
        (users) => emit(state.copyWith(isLoading: false, error: null)));
    emit(state.copyWith(isLoading: false, isSuccess: true));
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
