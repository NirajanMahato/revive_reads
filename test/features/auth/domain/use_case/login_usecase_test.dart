import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/auth/domain/use_case/login_usecase.dart';

import 'repository.mock.dart';
import 'token.mock.dart';

void main() {
  late MockUserRepository repository;
  late MockTokenSharedPrefs tokenSharedPrefs;
  late LoginUsecase usecase;

  setUp(() {
    repository = MockUserRepository();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = LoginUsecase(repository, tokenSharedPrefs);
  });

  test('Should call the [AuthRepo.login] with correct username and password',
      () async {
    when(() => repository.loginUser(any(), any()))
        .thenAnswer((invocation) async {
      final email = invocation.positionalArguments[0] as String;
      final password = invocation.positionalArguments[1] as String;
      if (email == 'nirajan' && password == 'nirajan123') {
        return Future.value(const Right('token'));
      } else {
        return Future.value(
            const Left(ApiFailure(message: 'Invalid email or password')));
      }
    });
    when(() => tokenSharedPrefs.saveToken(any())).thenAnswer(
      (_) async => const Right(null),
    );
    final result = await usecase(const LoginParams(
      email: 'nirajan',
      password: 'nirajan123',
    ));

    expect(result, const Right('token'));

    verify(() => repository.loginUser(any(), any())).called(1);
    verify(() => tokenSharedPrefs.saveToken(any())).called(1);

    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });
  tearDown(() {
    reset(repository);
    reset(tokenSharedPrefs);
  });
}
