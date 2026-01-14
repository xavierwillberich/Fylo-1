import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/user.dart' as app_models;
import 'firebase_service.dart';

/// AuthService - 单例模式
/// 统一管理认证状态，提供 currentUserId 获取方法
class AuthService {
  // ============================================
  // 单例模式
  // ============================================
  static final AuthService _instance = AuthService._internal();
  static AuthService get instance => _instance;
  factory AuthService() => _instance;
  AuthService._internal();

  // ============================================
  // 依赖
  // ============================================
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseService _firebaseService = FirebaseService();

  // ============================================
  // 用户状态访问器
  // ============================================
  
  /// 当前 Firebase Auth 用户（可能为 null）
  firebase_auth.User? get currentUser => _auth.currentUser;

  /// 当前用户 ID（可能为 null）
  /// 推荐用法：在需要用户 ID 时使用此属性
  String? get currentUserId => _auth.currentUser?.uid;

  /// 当前用户 ID（非空，未登录时抛异常）
  /// 仅在确认已登录的页面使用
  String get requireCurrentUserId {
    final uid = currentUserId;
    if (uid == null) {
      throw StateError('User not authenticated. Use currentUserId for nullable access.');
    }
    return uid;
  }

  /// 认证状态变化流
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  // ============================================
  // 登录方法
  // ============================================

  /// Google 登录
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
      
      // 确保用户文档存在
      await _ensureUserDocumentExists(userCredential.user);
      
      return userCredential;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  /// Apple 登录
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
      
      // 确保用户文档存在
      await _ensureUserDocumentExists(
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

  /// Email 登录
  /// P0-3 修复：登录后确保用户文档存在
  Future<firebase_auth.UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // ✅ P0-3 修复：确保用户文档存在
      await _ensureUserDocumentExists(userCredential.user);
      
      return userCredential;
    } catch (e) {
      throw Exception('Email sign in failed: $e');
    }
  }

  /// Email 注册
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
      
      // 确保用户文档存在
      await _ensureUserDocumentExists(userCredential.user, displayName: name);
      
      return userCredential;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// 发送密码重置邮件
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // ============================================
  // 登出方法
  // ============================================

  /// 安全登出
  /// P0-5 修复：登出前更新在线状态
  Future<void> signOut() async {
    try {
      final uid = currentUserId;
      
      // Step 1: 更新在线状态（在登出前执行，因为登出后无权限）
      if (uid != null) {
        try {
          await _firebaseService.updateUserOnlineStatus(uid, false);
        } catch (e) {
          // 状态更新失败不阻塞登出流程
          // ignore: avoid_print
          print('Warning: Failed to update online status: $e');
        }
      }
      
      // Step 2: 登出 Firebase Auth 和第三方登录
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      
    } catch (e) {
      // 即使更新状态失败，也要尝试登出
      try {
        await _auth.signOut();
        await _googleSignIn.signOut();
      } catch (_) {}
      
      throw Exception('Sign out failed: $e');
    }
  }

  // ============================================
  // 用户文档管理
  // ============================================

  /// 确保用户文档存在
  /// P0-3: 登录后调用，避免用户文档不存在导致的问题
  Future<void> _ensureUserDocumentExists(
    firebase_auth.User? user, {
    String? displayName,
    String? appleFullName,
  }) async {
    if (user == null) return;

    final existingUser = await _firebaseService.getUser(user.uid);
    
    if (existingUser == null) {
      // 用户文档不存在，创建新文档
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
      // 用户文档已存在，更新在线状态
      await _firebaseService.updateUserOnlineStatus(user.uid, true);
    }
  }

  /// 生成用户名
  String _generateUsername(String name, String? email) {
    final baseName = name.toLowerCase().replaceAll(' ', '_').replaceAll(RegExp(r'[^a-z0-9_]'), '');
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    return '$baseName$timestamp';
  }

  // ============================================
  // 账户管理
  // ============================================

  /// 删除账户
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user != null) {
        // 可选：删除用户 Firestore 文档
        // await _firebaseService.deleteUser(user.uid);
        await user.delete();
      }
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }

  /// 更新邮箱
  Future<void> updateEmail(String newEmail) async {
    try {
      await currentUser?.verifyBeforeUpdateEmail(newEmail);
    } catch (e) {
      throw Exception('Email update failed: $e');
    }
  }

  /// 更新密码
  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Password update failed: $e');
    }
  }

  /// 重新认证（敏感操作前需要）
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
