
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;

  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider() {
    _user = _authService.currentUser;

    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get userEmail => _user?.email ?? '';
  String get displayName => _user?.displayName ?? '';

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await _authService.signIn(
        email: email,
        password: password,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _getFirebaseError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _getFirebaseError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.sendPasswordResetEmail(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _getFirebaseError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  String _getFirebaseError(Object error) {
    final message = error.toString();

    if (message.contains('email-already-in-use')) {
      return 'Cette adresse email est déjà utilisée.';
    }
    if (message.contains('invalid-email')) {
      return 'Adresse email invalide.';
    }
    if (message.contains('weak-password')) {
      return 'Le mot de passe doit contenir au moins 6 caractères.';
    }
    if (message.contains('user-not-found') ||
        message.contains('wrong-password') ||
        message.contains('invalid-credential')) {
      return 'Email ou mot de passe incorrect.';
    }
    if (message.contains('network-request-failed')) {
      return 'Vérifiez votre connexion Internet.';
    }

    return message.replaceAll('Exception: ', '');
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
