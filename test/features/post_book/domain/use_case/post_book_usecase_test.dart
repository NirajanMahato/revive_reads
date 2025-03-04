import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/post_book/domain/entity/post_book_entity.dart';
import 'package:revive_reads/features/post_book/domain/repository/post_book_repository.dart';
import 'package:revive_reads/features/post_book/domain/use_case/post_book_usecase.dart';

// Mock Repository
class MockPostBookRepository extends Mock implements IPostBookRepository {}

void main() {
  late PostBookUseCase usecase;
  late MockPostBookRepository mockRepository;

  setUp(() {
    mockRepository = MockPostBookRepository();
    usecase = PostBookUseCase(mockRepository);
  });

  final book = PostBookEntity(
    title: "Test Book",
    description: "This is a test book",
    price: 500,
    genre: "Fiction",
    condition: "Like New",
    images: ["test_image.jpg"],
    delivery: true,
  );

  const token = "mock_token";

  test("should call the repository to post a book and return success", () async {
    // Arrange
    when(() => mockRepository.postBook(any(), any()))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(book, token);

    // Assert
    expect(result, const Right(null));
    verify(() => mockRepository.postBook(book, token)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test("should return an API failure when repository fails", () async {
    // Arrange
    when(() => mockRepository.postBook(any(), any()))
        .thenAnswer((_) async => Left(ApiFailure(message: "Server Error")));

    // Act
    final result = await usecase(book, token);

    // Assert
    expect(result, isA<Left<Failure, void>>());
    verify(() => mockRepository.postBook(book, token)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
