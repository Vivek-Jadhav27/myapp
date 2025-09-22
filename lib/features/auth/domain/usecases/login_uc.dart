import 'package:dartz/dartz.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecases/usecase.dart';
import 'package:myapp/features/auth/domain/entities/app_user.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repo.dart';

class LoginUC extends UseCase<AppUser, LoginParams> {
  final AuthRepo repository;

  LoginUC(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(LoginParams params) {
    return repository.loginWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}
