import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/auth/domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({required super.uid, super.email,super.name});

  factory AppUserModel.fromFirebaseUser(User user) {
    return AppUserModel(uid: user.uid, email: user.email, name: user.displayName);
  }
}
