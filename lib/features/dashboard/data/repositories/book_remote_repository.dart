import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/core/network/network_connectivity.dart';
import 'package:revive_reads/features/dashboard/data/data_source/local_datasource/book_local_datasource.dart';
import 'package:revive_reads/features/dashboard/data/data_source/remote_datasource/book_remote_datasource.dart';
import 'package:revive_reads/features/dashboard/domain/entity/book_entity.dart';
import 'package:revive_reads/features/dashboard/domain/repositiry/book_repository.dart';

class BookRemoteRepository implements IBookRepository {
  final BookRemoteDataSource remoteDataSource;

  final BookLocalDataSource localDataSource;
  final NetworkConnectivity networkConnectivity;

  // Cache expiration time (e.g., 30 minutes)
  final Duration cacheExpiration = const Duration(minutes: 30);

  BookRemoteRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkConnectivity,
  });

  @override
  Future<Either<Failure, List<BookEntity>>> getAllBooks() async {
    // Check connectivity using NetworkConnectivity
    final networkStatus = await networkConnectivity.checkConnectivity();

    if (networkStatus == NetworkStatus.online) {
      try {
        // Fetch fresh data from API
        final bookModels = await remoteDataSource.getAllBooks();

        // Cache the data
        await localDataSource.cacheBooks(bookModels);

        // Return the data as entities
        final bookEntities =
            bookModels.map((model) => model.toEntity()).toList();
        return Right(bookEntities);
      } catch (e) {
        // If API call fails, try to get cached data
        return _getCachedBooks();
      }
    } else {
      // If offline, use cached data
      return _getCachedBooks();
    }
  }

  Future<Either<Failure, List<BookEntity>>> _getCachedBooks() async {
    try {
      // Check if we have cached books - add await here
      if (await localDataSource.hasBooks()) {
        // Check if cache is still valid
        final lastCachedTime = await localDataSource.getLastCachedTime();
        if (lastCachedTime != null &&
            DateTime.now().difference(lastCachedTime) <= cacheExpiration) {
          // Cache is valid, use it
          final bookModels = await localDataSource.getAllBooks();
          final bookEntities =
              bookModels.map((model) => model.toEntity()).toList();
          return Right(bookEntities);
        }
      }
      // No valid cache found
      return const Left(ApiFailure(message: 'No valid cached data available'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> searchBooks(String query) async {
    // Check connectivity using NetworkConnectivity
    final networkStatus = await networkConnectivity.checkConnectivity();

    if (networkStatus == NetworkStatus.online) {
      try {
        // Try to search via API
        final bookModels = await remoteDataSource.searchBooks(query);
        final bookEntities =
            bookModels.map((model) => model.toEntity()).toList();
        return Right(bookEntities);
      } catch (e) {
        // If API search fails, try local search
        try {
          final bookModels = await localDataSource.searchBooks(query);
          final bookEntities =
              bookModels.map((model) => model.toEntity()).toList();
          return Right(bookEntities);
        } catch (searchError) {
          return Left(ApiFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, use local search
      try {
        final bookModels = await localDataSource.searchBooks(query);
        final bookEntities =
            bookModels.map((model) => model.toEntity()).toList();
        return Right(bookEntities);
      } catch (e) {
        return const Left(ApiFailure(message: 'Cannot search while offline'));
      }
    }
  }
}
