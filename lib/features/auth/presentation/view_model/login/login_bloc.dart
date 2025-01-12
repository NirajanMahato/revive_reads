import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:revive_reads/features/home/presentation/view_model/home_cubit.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RegisterBloc _registerBloc;
  final HomeCubit _homeCubit;
  LoginBloc({
    required RegisterBloc registerBloc,
    required HomeCubit homeCubit,
  })  : _registerBloc = registerBloc,
        _homeCubit = homeCubit,
        super(LoginState.initial()) {
    on<NavigateHomeScreenEvent>(_onNavigateHomeScreenEvent);
    on<NavigateRegisterScreenEvent>(_onNavigateRegisterScreenEvent);
  }

  Future<void> _onNavigateHomeScreenEvent(
      NavigateHomeScreenEvent event, Emitter<LoginState> emit) async {
    Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _homeCubit,
          child: event.destination,
        ),
      ),
    );
  }

  Future<void> _onNavigateRegisterScreenEvent(
      NavigateRegisterScreenEvent event, Emitter<LoginState> emit) async {
    Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _registerBloc,
          child: event.destination,
        ),
      ),
    );
  }
}
