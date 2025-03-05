import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/account/domain/entity/account_entity.dart';
import 'package:revive_reads/features/account/domain/repository/account_repository.dart';
import 'package:revive_reads/features/account/domain/use_case/get_account_usecase.dart';

class GetAccountParams {
  final String userId;
  final String token;

  const GetAccountParams({required this.userId, required this.token});
}

class MockAccountRepository extends Mock implements IAccountRepository {}

void main() {
  late MockAccountRepository repository;
  late GetAccountUseCase usecase;

  setUp(() {
    repository = MockAccountRepository();
    usecase = GetAccountUseCase(repository);
  });

  const tUserId = '123';
  const tToken = 'valid_token';
  final tAccount = AccountEntity(
    id: '123',
    name: 'Nirajan Mahato',
    email: 'nirajanmahato44@gmail.com',
    phone: '9800000000',
    address: 'Kathmandu, Nepal',
    avatar: 'default_avatar.png',
    bookListings: const ['book1', 'book2'],
    favorites: const ['favBook1', 'favBook2'],
    status: 'Active',
    createdAt: DateTime(2024, 3, 15),
  );

  test('Should return [AccountEntity] when GetAccountUseCase is successful',
      () async {
    // Arrange
    when(() => repository.getAccount(any()))
        .thenAnswer((_) async => Right(tAccount));

    // Act
    final result = usecase;

    // Assert
    expect(result, Right(tAccount));
    verify(() => repository.getAccount(tUserId)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('Should return [Failure] when GetAccountUseCase fails', () async {
    // Arrange
    when(() => repository.getAccount(any())).thenAnswer((_) async =>
        const Left(ApiFailure(message: 'Failed to fetch account')));

    // Act
    final result = usecase;

    // Assert
    expect(result, const Left(ApiFailure(message: 'Failed to fetch account')));
    verify(() => repository.getAccount(tUserId)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
