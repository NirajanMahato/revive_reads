import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/dashboard/domain/repositiry/favorite_repository.dart';
import 'package:revive_reads/features/dashboard/domain/use_case/favorite_usecase.dart';

// Mock Repository
class MockFavoriteRepository extends Mock implements IFavoriteRepository {}

void main() {
  late MockFavoriteRepository mockRepository;
  late AddToFavoritesUseCase addToFavoritesUseCase;
  late RemoveFromFavoritesUseCase removeFromFavoritesUseCase;

  setUp(() {
    mockRepository = MockFavoriteRepository();
    addToFavoritesUseCase = AddToFavoritesUseCase(mockRepository);
    removeFromFavoritesUseCase = RemoveFromFavoritesUseCase(mockRepository);
  });

  const tBookId = 'book123';
  const tToken = 'valid_token';

  group('AddToFavoritesUseCase', () {
    test('Should call repository to add a book to favorites', () async {
      // Arrange
      when(() => mockRepository.addToFavorites(any(), any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await addToFavoritesUseCase(tBookId, tToken);

      // Assert
      expect(result, const Right(null));
      verify(() => mockRepository.addToFavorites(tBookId, tToken)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('Should return a Failure when repository fails to add', () async {
      // Arrange
      when(() => mockRepository.addToFavorites(any(), any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Failed to add')));

      // Act
      final result = await addToFavoritesUseCase(tBookId, tToken);

      // Assert
      expect(result, const Left(ApiFailure(message: 'Failed to add')));
      verify(() => mockRepository.addToFavorites(tBookId, tToken)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('RemoveFromFavoritesUseCase', () {
    test('Should call repository to remove a book from favorites', () async {
      // Arrange
      when(() => mockRepository.removeFromFavorites(any(), any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await removeFromFavoritesUseCase(tBookId, tToken);

      // Assert
      expect(result, const Right(null));
      verify(() => mockRepository.removeFromFavorites(tBookId, tToken)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('Should return a Failure when repository fails to remove', () async {
      // Arrange
      when(() => mockRepository.removeFromFavorites(any(), any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Failed to remove')));

      // Act
      final result = await removeFromFavoritesUseCase(tBookId, tToken);

      // Assert
      expect(result, const Left(ApiFailure(message: 'Failed to remove')));
      verify(() => mockRepository.removeFromFavorites(tBookId, tToken)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
