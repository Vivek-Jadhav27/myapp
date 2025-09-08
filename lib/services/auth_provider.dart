
import 'package:flutter/material.dart';
import 'package:myapp/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _auth = AuthService();

  bool _loading = false;
  String _error = '';

  bool get loading => _loading;
  String get error => _error;

  void _setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _setError('');
    _setLoading(true);
    try {
      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
      _setLoading(false);
      if (result == null) {
        _setError('Could not sign in with those credentials');
        return false;
      }
      return true;
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setError('');
    _setLoading(true);
    try {
      dynamic result = await _auth.registerWithEmailAndPassword(name, email, password);
      _setLoading(false);
      if (result == null) {
        _setError('Please supply a valid email');
        return false;
      }
      return true;
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred: $e');
      return false;
    }
  }
}
