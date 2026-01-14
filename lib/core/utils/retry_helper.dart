import 'dart:async';
import 'package:flutter/foundation.dart';
import '../exceptions/app_exception.dart';

/// 重试配置
class RetryConfig {
  /// 最大重试次数
  final int maxAttempts;

  /// 初始延迟（毫秒）
  final int initialDelayMs;

  /// 延迟倍增因子（指数退避）
  final double backoffMultiplier;

  /// 最大延迟（毫秒）
  final int maxDelayMs;

  /// 是否可重试的判断函数
  final bool Function(dynamic error)? shouldRetry;

  const RetryConfig({
    this.maxAttempts = 3,
    this.initialDelayMs = 500,
    this.backoffMultiplier = 2.0,
    this.maxDelayMs = 10000,
    this.shouldRetry,
  });

  /// 默认配置
  static const RetryConfig defaultConfig = RetryConfig();

  /// 快速重试配置（较短延迟）
  static const RetryConfig fast = RetryConfig(
    maxAttempts: 3,
    initialDelayMs: 200,
    backoffMultiplier: 1.5,
    maxDelayMs: 2000,
  );

  /// 耐心重试配置（较长延迟）
  static const RetryConfig patient = RetryConfig(
    maxAttempts: 5,
    initialDelayMs: 1000,
    backoffMultiplier: 2.0,
    maxDelayMs: 30000,
  );
}

/// 重试帮助类
/// P1-5: 提供统一的重试机制
class RetryHelper {
  /// 执行带重试的异步操作
  /// 
  /// 示例:
  /// ```dart
  /// final result = await RetryHelper.retry(
  ///   () => api.fetchData(),
  ///   config: RetryConfig.fast,
  /// );
  /// ```
  static Future<T> retry<T>(
    Future<T> Function() operation, {
    RetryConfig config = RetryConfig.defaultConfig,
    void Function(int attempt, dynamic error, Duration nextDelay)? onRetry,
  }) async {
    int attempt = 0;
    int delayMs = config.initialDelayMs;

    while (true) {
      attempt++;
      try {
        return await operation();
      } catch (e, s) {
        // 检查是否应该重试
        final shouldRetry = _shouldRetry(e, config);
        final hasMoreAttempts = attempt < config.maxAttempts;

        if (!shouldRetry || !hasMoreAttempts) {
          // 不再重试，抛出异常
          if (e is AppException) {
            rethrow;
          }
          throw AppException.from(e, s);
        }

        // 计算下次延迟
        final nextDelay = Duration(milliseconds: delayMs);
        
        // 回调
        onRetry?.call(attempt, e, nextDelay);
        debugPrint('RetryHelper: Attempt $attempt failed, retrying in ${delayMs}ms...');

        // 等待
        await Future.delayed(nextDelay);

        // 更新延迟（指数退避）
        delayMs = (delayMs * config.backoffMultiplier).round();
        if (delayMs > config.maxDelayMs) {
          delayMs = config.maxDelayMs;
        }
      }
    }
  }

  /// 判断错误是否应该重试
  static bool _shouldRetry(dynamic error, RetryConfig config) {
    // 自定义判断函数
    if (config.shouldRetry != null) {
      return config.shouldRetry!(error);
    }

    // AppException 检查
    if (error is AppException) {
      return error.isRetryable;
    }

    // 字符串检查常见的可重试错误
    final errorString = error.toString().toLowerCase();
    return errorString.contains('timeout') ||
        errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('unavailable') ||
        errorString.contains('deadline');
  }

  /// 带超时的操作执行
  static Future<T> withTimeout<T>(
    Future<T> Function() operation, {
    Duration timeout = const Duration(seconds: 30),
    String? timeoutMessage,
  }) async {
    try {
      return await operation().timeout(timeout);
    } on TimeoutException {
      throw AppException.timeout(timeoutMessage ?? '操作超时，请重试');
    }
  }

  /// 带重试和超时的操作执行
  static Future<T> retryWithTimeout<T>(
    Future<T> Function() operation, {
    RetryConfig config = RetryConfig.defaultConfig,
    Duration timeout = const Duration(seconds: 30),
    void Function(int attempt, dynamic error, Duration nextDelay)? onRetry,
  }) {
    return retry(
      () => withTimeout(operation, timeout: timeout),
      config: config,
      onRetry: onRetry,
    );
  }
}

/// 适合重试的操作类型
/// 
/// ✅ 适合重试的操作：
/// - 读取数据（list / fetch / get）
/// - 搜索操作
/// - 刷新操作
/// 
/// ❌ 不适合重试的操作：
/// - 支付 / 扣款
/// - 创建订单
/// - 发送消息（可能重复）
/// - 删除操作
/// - 任何有副作用的写入操作
/// 
/// 对于写入操作，应该使用幂等性设计或手动重试（让用户确认）
class RetryableOperations {
  /// 判断操作名称是否适合自动重试
  static bool isAutoRetryable(String operationName) {
    final lower = operationName.toLowerCase();
    
    // 不适合自动重试的操作
    if (lower.contains('create') ||
        lower.contains('delete') ||
        lower.contains('remove') ||
        lower.contains('pay') ||
        lower.contains('send') ||
        lower.contains('submit') ||
        lower.contains('order') ||
        lower.contains('purchase')) {
      return false;
    }
    
    // 适合自动重试的操作
    return lower.contains('get') ||
        lower.contains('fetch') ||
        lower.contains('list') ||
        lower.contains('search') ||
        lower.contains('load') ||
        lower.contains('refresh');
  }
}
