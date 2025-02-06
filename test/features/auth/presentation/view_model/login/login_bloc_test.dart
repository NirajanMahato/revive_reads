import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/core/common/snackbar/my_snackbar.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/auth/domain/use_case/login_usecase.dart';
import 'package:revive_reads/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:revive_reads/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:revive_reads/features/home/presentation/view_model/home_cubit.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterBloc extends Mock implements RegisterBloc {}

class MockHomeCubit extends Mock implements HomeCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late LoginUsecase loginUsecase;
  late RegisterBloc registerBloc;
  late HomeCubit homeCubit;
  late LoginBloc loginBloc;
  late MockNavigatorObserver mockNavigatorObserver;
  late MockBuildContext mockContext;

  setUp(() {
    loginUsecase = MockLoginUsecase();
    registerBloc = MockRegisterBloc();
    homeCubit = MockHomeCubit();
    mockNavigatorObserver = MockNavigatorObserver();
    mockContext = MockBuildContext();

    registerFallbackValue(const LoginParams(email: '', password: ''));

    loginBloc = LoginBloc(
      registerBloc: registerBloc,
      homeCubit: homeCubit,
      loginUsecase: loginUsecase,
    );
  });

  group('LoginBloc', () {
    const email = 'test@example.com';
    const password = 'password123';
    const token = 'mockToken';
    const failureMessage = 'Invalid credentials';

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginSuccess] when login is successful',
      build: () {
        when(() => loginUsecase.call(any()))
            .thenAnswer((_) async => const Right(token));
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginUserEvent(
        email: email,
        password: password,
        context: mockContext,
      )),
      expect: () => [
        LoginState.initial().copyWith(isLoading: true),
        LoginState.initial().copyWith(isLoading: false, isSuccess: true),
      ],
      verify: (_) {
        verify(() => loginUsecase.call(
            const LoginParams(email: email, password: password))).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginFailure] when login fails',
      build: () {
        when(() => loginUsecase.call(any())).thenAnswer(
            (_) async => const Left(ApiFailure(message: failureMessage)));
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginUserEvent(
        email: email,
        password: password,
        context: mockContext,
      )),
      expect: () => [
        LoginState.initial().copyWith(isLoading: true),
        LoginState.initial().copyWith(isLoading: false, isSuccess: false),
      ],
      verify: (_) {
        verify(() => loginUsecase.call(
            const LoginParams(email: email, password: password))).called(1);
        verify(() => showMySnackBar(
            context: mockContext,
            message: failureMessage,
            color: Colors.red)).called(1);
      },
    );
  });
}
