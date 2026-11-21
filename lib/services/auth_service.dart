import 'dart:async';

class UserModel {
  final String uid;
  final String email;
  final String displayName;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
  });
}

class AuthService {
  UserModel? _currentUser = const UserModel(
    uid: 'u_123',
    email: 'mehersoula1032@gmail.com',
    displayName: 'Exploitation AgriSmart',
  );

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  final StreamController<UserModel?> _authStateController =
      StreamController<UserModel?>.broadcast();

  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Veuillez remplir tous les champs');
    }

    if (!email.contains('@')) {
      throw Exception('Format d\'adresse email invalide');
    }

    if (password.length < 4) {
      throw Exception('Le mot de passe doit contenir au moins 4 caractères');
    }

    _currentUser = UserModel(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email.trim(),
      displayName: email.split('@').first,
    );

    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Veuillez remplir tous les champs');
    }

    _currentUser = UserModel(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email.trim(),
      displayName: name.trim().isEmpty ? email.split('@').first : name.trim(),
    );

    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (email.trim().isEmpty || !email.contains('@')) {
      throw Exception('Veuillez saisir une adresse email valide');
    }

    // Email reset request successfully triggered
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _authStateController.add(null);
  }
}
