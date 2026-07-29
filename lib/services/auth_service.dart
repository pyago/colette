import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../config/admin_config.dart';
import '../config/firebase_config.dart';

class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
  });

  final String uid;
  final String email;
  final String? displayName;

  bool get isAdmin => AdminConfig.isAdmin(email);
}

/// Auth facade. Uses Firebase when enabled; otherwise a local preview session.
class AuthService extends ChangeNotifier {
  AuthService() {
    if (FirebaseConfig.enabled) {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        _user = user == null
            ? null
            : AppUser(
                uid: user.uid,
                email: user.email ?? '',
                displayName: user.displayName,
              );
        notifyListeners();
      });
    }
  }

  AppUser? _user;
  AppUser? get user => _user;
  bool get isSignedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;

  Future<void> signInWithGoogle() => _oauth(GoogleAuthProvider());

  Future<void> signInWithFacebook() => _oauth(FacebookAuthProvider());

  Future<void> signInWithGithub() => _oauth(GithubAuthProvider());

  Future<void> signInWithApple() => _oauth(AppleAuthProvider());

  Future<void> _oauth(AuthProvider provider) async {
    if (!FirebaseConfig.enabled) {
      throw StateError(
        'Firebase is not configured yet. Run flutterfire configure and set '
        'FirebaseConfig.enabled = true.',
      );
    }
    await FirebaseAuth.instance.signInWithPopup(provider);
  }

  Future<void> signInWithEmail(String email, String password) async {
    if (!FirebaseConfig.enabled) {
      _localSignIn(email, displayName: email.split('@').first);
      return;
    }
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    if (!FirebaseConfig.enabled) {
      _localSignIn(email, displayName: displayName ?? email.split('@').first);
      return;
    }
    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (displayName != null && displayName.isNotEmpty) {
      await cred.user?.updateDisplayName(displayName);
    }
  }

  void _localSignIn(String email, {String? displayName}) {
    _user = AppUser(
      uid: 'local-${email.toLowerCase()}',
      email: email.trim(),
      displayName: displayName,
    );
    notifyListeners();
  }

  /// Preview-only helper so admin UI can be exercised before Firebase is live.
  Future<void> previewAsAdmin() async {
    _localSignIn(
      'paul.yago@gmail.com',
      displayName: 'Paul (preview admin)',
    );
  }

  Future<void> signOut() async {
    if (FirebaseConfig.enabled) {
      await FirebaseAuth.instance.signOut();
    }
    _user = null;
    notifyListeners();
  }
}
