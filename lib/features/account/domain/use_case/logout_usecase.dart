import 'package:dartz/dartz.dart';
import 'package:revive_reads/app/shared_prefs/token_shared_prefs.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutUseCase {
  final TokenSharedPrefs tokenSharedPrefs;

  LogoutUseCase(this.tokenSharedPrefs);

  Future<Either<Failure, void>> call() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear all stored data
      return const Right(null);
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }
}
