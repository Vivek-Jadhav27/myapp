import 'package:flutter/material.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecases/usecase.dart';
import 'package:myapp/features/auth/domain/entities/app_user.dart';
import 'package:myapp/features/auth/domain/usecases/login_uc.dart';
import 'package:myapp/features/auth/domain/usecases/register_uc.dart';
import 'package:myapp/features/auth/domain/usecases/signout_uc.dart';

enum AuthState { initial, loading, authenticated, error }

class AuthNotifier extends ChangeNotifier {
  final LoginUC loginUC;
  final RegisterUC registerUC;
  final SignOutUC signOutUC;

  AuthNotifier({
    required this.loginUC,
    required this.registerUC,
    required this.signOutUC,
  });

  AuthState _state = AuthState.initial;
  AuthState get state => _state;

  Failure? _failure;
  Failure? get failure => _failure;

  AppUser? _user;
  AppUser? get user => _user;

  void _setState(AuthState state) {
    _state = state;
    notifyListeners();
  }

  void _setUser(AppUser user) {
    _user = user;
    _setState(AuthState.authenticated);
  }

  void _setFailure(Failure failure) {
    _failure = failure;
    _setState(AuthState.error);
  }

  Future<void> login(String email, String password) async {
    _setState(AuthState.loading);
    final result = await loginUC(LoginParams(email: email, password: password));
    result.fold((failure) => _setFailure(failure), (user) => _setUser(user));
  }

  Future<void> register(String email, String password) async {
    _setState(AuthState.loading);
    final result = await registerUC(
      RegisterParams(email: email, password: password),
    );
    result.fold((failure) => _setFailure(failure), (user) => _setUser(user));
  }

  Future<void> signOut() async {
    final result = await signOutUC(NoParams());
    result.fold((failure) => _setFailure(failure), (_) => _user = null);
    _setState(AuthState.initial);
  }
}
