import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/features/auth/domain/entity/user_entity.dart';
import 'package:revive_reads/features/auth/domain/use_case/create_user_usecase.dart';

import 'repository.mock.dart';

void main() {
  late MockUserRepository repository;
  late CreateUserUsecase usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = CreateUserUsecase(userRepository: repository);
    registerFallbackValue(const UserEntity.empty());
  });

  const params = CreateUserParams.empty();

  test("Should call the [UserRepo.createUser]", () async {
    // Arrange
    when(() => repository.createUser(any())).thenAnswer(
      (_) async => const Right(null),
    );

    //Act
    final result = await usecase(params);

    // Assert
    expect(result, Right(null));

    // Verify
    verify(() => repository.createUser(any())).called(1);

    verifyNoMoreInteractions(repository);
  });
}
