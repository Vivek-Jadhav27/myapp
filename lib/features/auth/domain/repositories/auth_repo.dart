import 'package:dartz/dartz.dart';
import 'package:myapp/core/error/failure.dart';

import '../entities/app_user.dart';

abstract class AuthRepo {
  Future<Either<Failure, AppUser>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, AppUser>> registerWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> signOut();
  Stream<AppUser?> get user;
}
