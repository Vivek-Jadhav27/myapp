import 'package:dartz/dartz.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecases/usecase.dart';
import 'package:myapp/features/auth/domain/entities/app_user.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repo.dart';

class RegisterUC extends UseCase<AppUser, RegisterParams> {
  final AuthRepo repository;

  RegisterUC(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(RegisterParams params) {
    return repository.registerWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}
