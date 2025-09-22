import 'package:dartz/dartz.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/features/auth/data/datasources/auth_ds.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repo.dart';

import '../../domain/entities/app_user.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthDS authDS;

  AuthRepoImpl(this.authDS);

  @override
  Future<Either<Failure, AppUser>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authDS.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AppUser>> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authDS.registerWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authDS.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Stream<AppUser?> get user => authDS.user;
}
