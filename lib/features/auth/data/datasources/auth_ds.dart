import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/features/auth/data/models/app_user_model.dart';

abstract class AuthDS {
  Future<AppUserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<AppUserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Stream<AppUserModel?> get user;
}

class AuthDSImpl extends AuthDS {
  final FirebaseAuth _firebaseAuth;

  AuthDSImpl(this._firebaseAuth);

  @override
  Future<AppUserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user == null) {
        throw ServerException('User not found');
      }
      return AppUserModel.fromFirebaseUser(result.user!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'An error occurred');
    }
  }

  @override
  Future<AppUserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user == null) {
        throw ServerException('User not created');
      }
      return AppUserModel.fromFirebaseUser(result.user!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'An error occurred');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<AppUserModel?> get user =>
      _firebaseAuth.authStateChanges().map((firebaseUser) {
        if (firebaseUser == null) {
          return null;
        }
        return AppUserModel.fromFirebaseUser(firebaseUser);
      });
}
