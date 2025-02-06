import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/features/auth/domain/entity/user_entity.dart';
import 'package:revive_reads/features/auth/domain/use_case/get_all_user_usecase.dart';

import 'repository.mock.dart';

void main() {
  late MockUserRepository repository;
  late GetAllUserUsecase usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = GetAllUserUsecase(userRepository: repository);
  });

  const tUser = UserEntity(
    userId: '1',
    fullName: 'fullName',
    email: 'email',
    password: 'password',
    phone: 'phone',
    address: 'address',
    role: 'user',
  );

  const tUser2 = UserEntity(
    userId: '2',
    fullName: 'fullName',
    email: 'email',
    password: 'password',
    phone: 'phone',
    address: 'address',
    role: 'user',
  );

  final tUsers = [tUser, tUser2];

  test('Should call the [UserRepo.GetAllUser]', () async {
    // Arrange
    when(() => repository.getAllUsers()).thenAnswer(
      (_) async => Right(tUsers),
    );

    // Act
    final result = await usecase();

    // Assert
    expect(result, Right(tUsers));

    // Verify
    verify(() => repository.getAllUsers()).called(1);
  });
}
