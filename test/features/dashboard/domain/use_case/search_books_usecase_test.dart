import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/dashboard/domain/entity/book_entity.dart';
import 'package:revive_reads/features/dashboard/domain/repositiry/book_repository.dart';
import 'package:revive_reads/features/dashboard/domain/use_case/search_books_usecase.dart';

// Mock Repository
class MockBookRepository extends Mock implements IBookRepository {}

void main() {
  late MockBookRepository mockBookRepository;
  late SearchBooksUseCase searchBooksUseCase;

  setUp(() {
    mockBookRepository = MockBookRepository();
    searchBooksUseCase = SearchBooksUseCase(mockBookRepository);
  });

  const tQuery = 'fiction';

  const tBook1 = BookEntity(
    id: '1',
    title: 'Fictional Book 1',
    genre: 'Fiction',
    description: 'A great fictional book',
    price: 10.99,
    condition: 'New',
    delivery: true,
    sellerId: 'seller123',
    sellerName: 'John Doe',
    images: ['https://example.com/book1.jpg'],
  );

  const tBook2 = BookEntity(
    id: '2',
    title: 'Fictional Book 2',
    genre: 'Fiction',
    description: 'A thrilling fictional story',
    price: 12.50,
    condition: 'Used',
    delivery: false,
    sellerId: 'seller456',
    sellerName: 'Jane Smith',
    images: ['https://example.com/book2.jpg'],
  );

  final tBooks = [tBook1, tBook2];

  test('Should call repository to search books and return a list of books', () async {
    // Arrange
    when(() => mockBookRepository.searchBooks(any()))
        .thenAnswer((_) async => Right(tBooks));

    // Act
    final result = await searchBooksUseCase(tQuery);

    // Assert
    expect(result, Right(tBooks));
    verify(() => mockBookRepository.searchBooks(tQuery)).called(1);
    verifyNoMoreInteractions(mockBookRepository);
  });

  test('Should return a Failure when repository fails to search books', () async {
    // Arrange
    when(() => mockBookRepository.searchBooks(any()))
        .thenAnswer((_) async => const Left(ApiFailure(message: 'Failed to search')));

    // Act
    final result = await searchBooksUseCase(tQuery);

    // Assert
    expect(result, const Left(ApiFailure(message: 'Failed to search')));
    verify(() => mockBookRepository.searchBooks(tQuery)).called(1);
    verifyNoMoreInteractions(mockBookRepository);
  });
}
