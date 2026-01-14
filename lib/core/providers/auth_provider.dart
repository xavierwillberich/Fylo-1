import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../services/auth_service.dart';
import '../../models/user.dart';
import '../../services/firebase_service.dart';

/// 认证状态枚举
enum AuthStatus {
  /// 初始化中/加载中
  loading,

  /// 已认证
  authenticated,

  /// 未认证
  unauthenticated,

  /// 错误状态
  error,
}

/// 认证状态 Provider
/// P1-3: 统一管理认证状态，供全局使用
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  final FirebaseService _firebaseService = FirebaseService();

  // 状态
  AuthStatus _status = AuthStatus.loading;
  String? _userId;
  User? _currentUser;
  String? _errorMessage;

  // 订阅
  StreamSubscription<firebase_auth.User?>? _authSubscription;

  // ============================================
  // Getters
  // ============================================

  /// 当前认证状态
  AuthStatus get status => _status;

  /// 当前用户 ID（可能为 null）
  String? get userId => _userId;

  /// 当前用户 ID（非空，未登录时抛异常）
  /// 仅在确认已登录的页面使用
  String get requireUserId {
    if (_userId == null) {
      throw StateError('User not authenticated');
    }
    return _userId!;
  }

  /// 当前用户资料
  User? get currentUser => _currentUser;

  /// 错误信息
  String? get errorMessage => _errorMessage;

  /// 是否已登录
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// 是否正在加载
  bool get isLoading => _status == AuthStatus.loading;

  // ============================================
  // 初始化
  // ============================================

  AuthProvider() {
    _initialize();
  }

  void _initialize() {
    _status = AuthStatus.loading;
    notifyListeners();

    // 监听 Firebase Auth 状态变化
    _authSubscription = _authService.authStateChanges.listen(
      _onAuthStateChanged,
      onError: _onAuthError,
    );
  }

  Future<void> _onAuthStateChanged(firebase_auth.User? firebaseUser) async {
    if (firebaseUser == null) {
      // 未登录
      _userId = null;
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
    } else {
      // 已登录
      _userId = firebaseUser.uid;
      _status = AuthStatus.authenticated;

      // 异步加载用户资料（不阻塞 UI）
      _loadUserProfile(firebaseUser.uid);
    }
    _errorMessage = null;
    notifyListeners();
  }

  void _onAuthError(dynamic error) {
    _status = AuthStatus.error;
    _errorMessage = error.toString();
    _userId = null;
    _currentUser = null;
    notifyListeners();
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final user = await _firebaseService.getUser(userId);
      if (_userId == userId) {
        // 确保仍是当前用户
        _currentUser = user;
        notifyListeners();
      }
    } catch (e) {
      // 用户资料加载失败不影响认证状态
      debugPrint('Failed to load user profile: $e');
    }
  }

  // ============================================
  // 公开方法
  // ============================================

  /// 刷新用户资料
  Future<void> refreshUserProfile() async {
    if (_userId != null) {
      await _loadUserProfile(_userId!);
    }
  }

  /// 重试初始化
  void retry() {
    _authSubscription?.cancel();
    _initialize();
  }

  // ============================================
  // 生命周期
  // ============================================

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
