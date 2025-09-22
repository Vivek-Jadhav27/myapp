import 'package:dartz/dartz.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecases/usecase.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repo.dart';

class SignOutUC extends UseCase<void, NoParams> {
  final AuthRepo repository;

  SignOutUC(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.signOut();
  }
}
