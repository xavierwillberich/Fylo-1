import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/user.dart' as app_models;
import 'firebase_service.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseService _firebaseService = FirebaseService();

  firebase_auth.User? get currentUser => _auth.currentUser;

  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  Future<firebase_auth.UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      
      await _createOrUpdateUserProfile(userCredential.user);
      
      return userCredential;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  Future<firebase_auth.UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = firebase_auth.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);
      
      await _createOrUpdateUserProfile(
        userCredential.user,
        appleFullName: appleCredential.givenName != null && appleCredential.familyName != null
            ? '${appleCredential.givenName} ${appleCredential.familyName}'
            : null,
      );
      
      return userCredential;
    } catch (e) {
      throw Exception('Apple sign in failed: $e');
    }
  }

  Future<firebase_auth.UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      throw Exception('Email sign in failed: $e');
    }
  }

  Future<firebase_auth.UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      
      await _createOrUpdateUserProfile(userCredential.user, displayName: name);
      
      return userCredential;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  Future<void> _createOrUpdateUserProfile(
    firebase_auth.User? user, {
    String? displayName,
    String? appleFullName,
  }) async {
    if (user == null) return;

    final existingUser = await _firebaseService.getUser(user.uid);
    
    if (existingUser == null) {
      final name = appleFullName ?? displayName ?? user.displayName ?? 'User';
      final username = _generateUsername(name, user.email);
      
      final newUser = app_models.User(
        id: user.uid,
        name: name,
        username: username,
        avatar: user.photoURL ?? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=9333EA&color=fff',
        bio: null,
        location: null,
        isOnline: true,
        lastSeen: DateTime.now(),
        interests: [],
      );
      
      await _firebaseService.addUser(newUser);
    } else {
      await _firebaseService.updateUserOnlineStatus(user.uid, true);
    }
  }

  String _generateUsername(String name, String? email) {
    final baseName = name.toLowerCase().replaceAll(' ', '_');
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    return '$baseName$timestamp';
  }

  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      await currentUser?.verifyBeforeUpdateEmail(newEmail);
    } catch (e) {
      throw Exception('Email update failed: $e');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Password update failed: $e');
    }
  }

  Future<void> reauthenticateWithCredential(String email, String password) async {
    try {
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser?.reauthenticateWithCredential(credential);
    } catch (e) {
      throw Exception('Reauthentication failed: $e');
    }
  }
}
