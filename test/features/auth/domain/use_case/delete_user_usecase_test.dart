import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/features/auth/domain/use_case/delete_user_usecase.dart';

import 'repository.mock.dart';
import 'token.mock.dart';

void main() {
  late MockUserRepository repository;
  late MockTokenSharedPrefs tokenSharedPrefs;
  late DeleteUserUsecase usecase;

  setUp(() {
    repository = MockUserRepository();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = DeleteUserUsecase(
        userRepository: repository, tokenSharedPrefs: tokenSharedPrefs);
  });

  const tUserId = '1';
  const token = 'token';
  const deleteUserParams = DeleteUserParams(userId: tUserId);

  test('Delete user using id', () async {
    // Arrange
    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => const Right(token));

    when(() => repository.deleteUser(any(), any()))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(deleteUserParams);

    // Assert
    expect(result, const Right(null));

    // Verify
    verify(() => tokenSharedPrefs.getToken()).called(1);
    verify(() => repository.deleteUser(tUserId, token)).called(1);

    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });
}
