import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:revive_reads/app/shared_prefs/token_shared_prefs.dart';
import 'package:revive_reads/app/usecase/usecase.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/auth/domain/repository/user_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  const LoginParams.initial()
      : email = '',
        password = '';

  @override
  List<Object?> get props => [email, password];
}

class LoginUsecase implements UsecaseWithParams<String, LoginParams> {
  final IUserRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  LoginUsecase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return repository.loginUser(params.email, params.password).then((value) {
      return value.fold(
        (failure) => Left(failure),
        (loginResponse) async {
          final String id = loginResponse['id'] ?? ''; // Ensure non-null value
          final String token =
              loginResponse['token'] ?? ''; // Ensure non-null value

          await tokenSharedPrefs.saveIdAndToken(id, token);

          tokenSharedPrefs.getToken().then((value) => print("Token: $value"));
          tokenSharedPrefs
              .getUserId()
              .then((value) => print("User ID: $value"));

          return Right(token);
        },
      );
    });
  }
}
