
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/app_user.dart';
import 'package:myapp/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  AppUser? _user;
  bool _loading = false;
  String _error = '';

  AppUser? get user => _user;
  bool get loading => _loading;
  String get error => _error;

  AuthProvider() {
    _authService.user.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    _loading = true;
    _error = '';
    notifyListeners();
    try {
      _user = await _authService.signInWithEmailAndPassword(email, password);
      if (_user == null) {
        _error = 'Invalid email or password.';
      }
    } catch (e) {
      _error = 'An unknown error occurred.';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    _loading = true;
    _error = '';
    notifyListeners();
    try {
      _user = await _authService.registerWithEmailAndPassword(name, email, password);
    } on FirebaseAuthException catch (e) {
      // Use the specific error message from Firebase
      _error = e.message ?? 'An unknown error occurred during registration.';
    } catch (e) {
      _error = 'An unknown error occurred.';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
