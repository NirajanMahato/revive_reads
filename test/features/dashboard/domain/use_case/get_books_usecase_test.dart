import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/dashboard/domain/entity/book_entity.dart';
import 'package:revive_reads/features/dashboard/domain/repositiry/book_repository.dart';
import 'package:revive_reads/features/dashboard/domain/use_case/get_books_usecase.dart';

// Mock Repository
class MockBookRepository extends Mock implements IBookRepository {}

void main() {
  late MockBookRepository mockBookRepository;
  late GetBooksUseCase usecase;

  setUp(() {
    mockBookRepository = MockBookRepository();
    usecase = GetBooksUseCase(mockBookRepository);
  });

  const tBook1 = BookEntity(
    id: '1',
    title: 'Book Title 1',
    genre: 'Fiction',
    description: 'A great fictional book',
    price: 15.99,
    condition: 'New',
    delivery: true,
    sellerId: 'seller123',
    sellerName: 'John Doe',
    images: ['https://example.com/book1.jpg'],
  );

  const tBook2 = BookEntity(
    id: '2',
    title: 'Book Title 2',
    genre: 'Mystery',
    description: 'A thrilling mystery book',
    price: 12.50,
    condition: 'Used',
    delivery: false,
    sellerId: 'seller456',
    sellerName: 'Jane Smith',
    images: ['https://example.com/book2.jpg', 'https://example.com/book2_2.jpg'],
  );

  final tBooks = [tBook1, tBook2];

  test('Should call the repository and return a list of books', () async {
    // Arrange
    when(() => mockBookRepository.getAllBooks())
        .thenAnswer((_) async => Right(tBooks));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Right(tBooks));

    // Verify interactions
    verify(() => mockBookRepository.getAllBooks()).called(1);
    verifyNoMoreInteractions(mockBookRepository);
  });

  test('Should return a Failure when repository fails', () async {
    // Arrange
    when(() => mockBookRepository.getAllBooks())
        .thenAnswer((_) async => const Left(ApiFailure(message: 'Failed to load books')));

    // Act
    final result = await usecase();

    // Assert
    expect(result, const Left(ApiFailure(message: 'Failed to load books')));

    // Verify interactions
    verify(() => mockBookRepository.getAllBooks()).called(1);
    verifyNoMoreInteractions(mockBookRepository);
  });
}
