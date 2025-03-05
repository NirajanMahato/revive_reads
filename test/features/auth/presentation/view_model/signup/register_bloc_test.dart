import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:revive_reads/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:revive_reads/features/auth/presentation/view_model/signup/register_bloc.dart';

class MockCreateUserUsecase extends Mock implements CreateUserUsecase {}

class MockUploadImageUsecase extends Mock implements UploadImageUsecase {}

void main() {
  late MockCreateUserUsecase mockCreateUserUsecase;
  late MockUploadImageUsecase mockUploadImageUsecase;
  late RegisterBloc registerBloc;

  setUp(() {
    mockCreateUserUsecase = MockCreateUserUsecase();
    mockUploadImageUsecase = MockUploadImageUsecase();
    registerBloc = RegisterBloc(
      createUserUsecase: mockCreateUserUsecase,
      uploadImageUsecase: mockUploadImageUsecase,
    );
  });

  const tFullName = 'Test User';
  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  const tCreateUserParams = CreateUserParams(
    fullName: tFullName,
    email: tEmail,
    password: tPassword,
    phone: '',
    address: '',
    role: 'user',
    avatar: null,
  );

  group('RegisterBloc Tests', () {
    test('Initial state should be RegisterState.initial()', () {
      expect(registerBloc.state, RegisterState.initial());
    });

    blocTest<RegisterBloc, RegisterState>(
      'Should emit [RegisterLoading, RegisterSuccess] when user is successfully registered',
      build: () {
        when(() => mockCreateUserUsecase(any()))
            .thenAnswer((_) async => const Right(null));
        return registerBloc;
      },
      act: (bloc) => bloc.add(RegisterUserEvent(
        fullName: tFullName,
        email: tEmail,
        password: tPassword,
        avatar: null,
        context: FakeBuildContext(),
      )),
      expect: () => [
        RegisterState.initial().copyWith(isLoading: true, isRegistered: false),
        RegisterState.initial().copyWith(isLoading: false, isRegistered: true),
      ],
      verify: (_) {
        verify(() => mockCreateUserUsecase(tCreateUserParams)).called(1);
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'Should emit [RegisterLoading, RegisterFailure] when user registration fails',
      build: () {
        when(() => mockCreateUserUsecase(any()))
            .thenAnswer((_) async => const Left(ApiFailure(message: 'Registration Failed')));
        return registerBloc;
      },
      act: (bloc) => bloc.add(RegisterUserEvent(
        fullName: tFullName,
        email: tEmail,
        password: tPassword,
        avatar: null,
        context: FakeBuildContext(),
      )),
      expect: () => [
        RegisterState.initial().copyWith(isLoading: true, isRegistered: false),
        RegisterState.initial().copyWith(isLoading: false, isRegistered: false),
      ],
      verify: (_) {
        verify(() => mockCreateUserUsecase(tCreateUserParams)).called(1);
      },
    );
  });
}

/// Fake BuildContext for testing navigation
class FakeBuildContext extends Fake implements BuildContext {}
