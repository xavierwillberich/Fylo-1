import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// 应用异常类型枚举
enum AppExceptionType {
  /// 网络错误（无网络、超时等）
  network,

  /// 认证错误（未登录、token 过期等）
  unauthenticated,

  /// 权限错误（无权访问资源）
  permission,

  /// 资源未找到
  notFound,

  /// 验证错误（输入不合法）
  validation,

  /// 服务器错误
  server,

  /// 超时
  timeout,

  /// 取消操作
  cancelled,

  /// 未知错误
  unknown,
}

/// 统一应用异常
/// P1-2: 用于在 UI 层统一处理和展示错误
class AppException implements Exception {
  final AppExceptionType type;
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.type,
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  /// 是否可重试
  bool get isRetryable {
    switch (type) {
      case AppExceptionType.network:
      case AppExceptionType.timeout:
      case AppExceptionType.server:
        return true;
      case AppExceptionType.unauthenticated:
      case AppExceptionType.permission:
      case AppExceptionType.notFound:
      case AppExceptionType.validation:
      case AppExceptionType.cancelled:
      case AppExceptionType.unknown:
        return false;
    }
  }

  /// 用户友好的标题
  String get title {
    switch (type) {
      case AppExceptionType.network:
        return '网络连接失败';
      case AppExceptionType.unauthenticated:
        return '请先登录';
      case AppExceptionType.permission:
        return '没有权限';
      case AppExceptionType.notFound:
        return '未找到';
      case AppExceptionType.validation:
        return '输入错误';
      case AppExceptionType.server:
        return '服务器错误';
      case AppExceptionType.timeout:
        return '请求超时';
      case AppExceptionType.cancelled:
        return '操作已取消';
      case AppExceptionType.unknown:
        return '出错了';
    }
  }

  @override
  String toString() => 'AppException($type): $message';

  // ============================================
  // 工厂方法：从各种异常转换
  // ============================================

  /// 从 FirebaseAuthException 转换
  factory AppException.fromFirebaseAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AppException(
          type: AppExceptionType.notFound,
          message: '未找到该用户账号',
          code: e.code,
          originalError: e,
        );
      case 'wrong-password':
        return AppException(
          type: AppExceptionType.validation,
          message: '密码错误',
          code: e.code,
          originalError: e,
        );
      case 'invalid-email':
        return AppException(
          type: AppExceptionType.validation,
          message: '邮箱格式不正确',
          code: e.code,
          originalError: e,
        );
      case 'user-disabled':
        return AppException(
          type: AppExceptionType.permission,
          message: '该账户已被禁用',
          code: e.code,
          originalError: e,
        );
      case 'too-many-requests':
        return AppException(
          type: AppExceptionType.server,
          message: '请求过于频繁，请稍后再试',
          code: e.code,
          originalError: e,
        );
      case 'network-request-failed':
        return AppException(
          type: AppExceptionType.network,
          message: '网络连接失败，请检查网络',
          code: e.code,
          originalError: e,
        );
      case 'email-already-in-use':
        return AppException(
          type: AppExceptionType.validation,
          message: '该邮箱已被注册',
          code: e.code,
          originalError: e,
        );
      case 'weak-password':
        return AppException(
          type: AppExceptionType.validation,
          message: '密码强度不够',
          code: e.code,
          originalError: e,
        );
      case 'requires-recent-login':
        return AppException(
          type: AppExceptionType.unauthenticated,
          message: '请重新登录后再试',
          code: e.code,
          originalError: e,
        );
      default:
        return AppException(
          type: AppExceptionType.unknown,
          message: e.message ?? '认证失败',
          code: e.code,
          originalError: e,
        );
    }
  }

  /// 从 FirebaseException 转换
  factory AppException.fromFirestore(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return AppException(
          type: AppExceptionType.permission,
          message: '没有权限访问此数据',
          code: e.code,
          originalError: e,
        );
      case 'not-found':
        return AppException(
          type: AppExceptionType.notFound,
          message: '请求的数据不存在',
          code: e.code,
          originalError: e,
        );
      case 'unavailable':
        return AppException(
          type: AppExceptionType.server,
          message: '服务暂时不可用，请稍后再试',
          code: e.code,
          originalError: e,
        );
      case 'deadline-exceeded':
        return AppException(
          type: AppExceptionType.timeout,
          message: '请求超时，请检查网络',
          code: e.code,
          originalError: e,
        );
      case 'cancelled':
        return AppException(
          type: AppExceptionType.cancelled,
          message: '操作已取消',
          code: e.code,
          originalError: e,
        );
      case 'unauthenticated':
        return AppException(
          type: AppExceptionType.unauthenticated,
          message: '请先登录',
          code: e.code,
          originalError: e,
        );
      default:
        return AppException(
          type: AppExceptionType.unknown,
          message: e.message ?? '数据操作失败',
          code: e.code,
          originalError: e,
        );
    }
  }

  /// 从任意异常转换
  factory AppException.from(dynamic error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return error;
    }

    if (error is FirebaseAuthException) {
      return AppException.fromFirebaseAuth(error);
    }

    if (error is FirebaseException) {
      return AppException.fromFirestore(error);
    }

    // 检查常见的网络错误
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('socketexception') ||
        errorString.contains('connection refused') ||
        errorString.contains('network is unreachable') ||
        errorString.contains('no internet')) {
      return AppException(
        type: AppExceptionType.network,
        message: '网络连接失败，请检查网络设置',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('timeout')) {
      return AppException(
        type: AppExceptionType.timeout,
        message: '请求超时，请稍后重试',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    return AppException(
      type: AppExceptionType.unknown,
      message: error.toString(),
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// 网络错误
  factory AppException.network([String? message]) => AppException(
        type: AppExceptionType.network,
        message: message ?? '网络连接失败',
      );

  /// 未认证错误
  factory AppException.unauthenticated([String? message]) => AppException(
        type: AppExceptionType.unauthenticated,
        message: message ?? '请先登录',
      );

  /// 权限错误
  factory AppException.permission([String? message]) => AppException(
        type: AppExceptionType.permission,
        message: message ?? '没有权限访问',
      );

  /// 超时错误
  factory AppException.timeout([String? message]) => AppException(
        type: AppExceptionType.timeout,
        message: message ?? '请求超时',
      );
}
