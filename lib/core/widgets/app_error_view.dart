import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../exceptions/app_exception.dart';

/// 统一错误视图组件
/// P1-2: 用于在各页面统一展示错误状态
class AppErrorView extends StatelessWidget {
  /// 错误标题
  final String title;

  /// 错误描述
  final String message;

  /// 错误图标
  final IconData icon;

  /// 图标颜色
  final Color? iconColor;

  /// 重试回调（如果为 null，不显示重试按钮）
  final VoidCallback? onRetry;

  /// 重试按钮文本
  final String retryText;

  /// 是否紧凑模式（用于列表项等小空间）
  final bool compact;

  const AppErrorView({
    super.key,
    required this.title,
    required this.message,
    this.icon = LucideIcons.alertCircle,
    this.iconColor,
    this.onRetry,
    this.retryText = '重试',
    this.compact = false,
  });

  /// 从 AppException 构建
  factory AppErrorView.fromException(
    AppException exception, {
    VoidCallback? onRetry,
    bool compact = false,
  }) {
    return AppErrorView(
      title: exception.title,
      message: exception.message,
      icon: _getIconForType(exception.type),
      iconColor: _getColorForType(exception.type),
      onRetry: exception.isRetryable ? onRetry : null,
      compact: compact,
    );
  }

  /// 从任意错误构建
  factory AppErrorView.fromError(
    dynamic error, {
    VoidCallback? onRetry,
    bool compact = false,
  }) {
    final exception = AppException.from(error);
    return AppErrorView.fromException(
      exception,
      onRetry: onRetry,
      compact: compact,
    );
  }

  /// 网络错误快捷构造
  factory AppErrorView.network({VoidCallback? onRetry, bool compact = false}) {
    return AppErrorView(
      title: '网络连接失败',
      message: '请检查网络设置后重试',
      icon: LucideIcons.wifiOff,
      iconColor: Colors.orange,
      onRetry: onRetry,
      compact: compact,
    );
  }

  /// 空数据状态（不是错误，但经常需要）
  factory AppErrorView.empty({
    String title = '暂无数据',
    String message = '这里还没有内容',
    IconData icon = LucideIcons.inbox,
    VoidCallback? onAction,
    String actionText = '刷新',
    bool compact = false,
  }) {
    return AppErrorView(
      title: title,
      message: message,
      icon: icon,
      iconColor: Colors.grey,
      onRetry: onAction,
      retryText: actionText,
      compact: compact,
    );
  }

  static IconData _getIconForType(AppExceptionType type) {
    switch (type) {
      case AppExceptionType.network:
        return LucideIcons.wifiOff;
      case AppExceptionType.unauthenticated:
        return LucideIcons.logIn;
      case AppExceptionType.permission:
        return LucideIcons.shieldOff;
      case AppExceptionType.notFound:
        return LucideIcons.searchX;
      case AppExceptionType.validation:
        return LucideIcons.alertTriangle;
      case AppExceptionType.server:
        return LucideIcons.serverOff;
      case AppExceptionType.timeout:
        return LucideIcons.clock;
      case AppExceptionType.cancelled:
        return LucideIcons.x;
      case AppExceptionType.unknown:
        return LucideIcons.alertCircle;
    }
  }

  static Color _getColorForType(AppExceptionType type) {
    switch (type) {
      case AppExceptionType.network:
      case AppExceptionType.timeout:
        return Colors.orange;
      case AppExceptionType.unauthenticated:
      case AppExceptionType.permission:
        return Colors.red;
      case AppExceptionType.notFound:
      case AppExceptionType.cancelled:
        return Colors.grey;
      case AppExceptionType.validation:
        return Colors.amber;
      case AppExceptionType.server:
      case AppExceptionType.unknown:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact(context);
    }
    return _buildFull(context);
  }

  Widget _buildFull(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: iconColor ?? Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(LucideIcons.rotateCw, size: 18),
                label: Text(retryText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
            color: iconColor ?? Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          if (onRetry != null)
            IconButton(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.rotateCw),
              tooltip: retryText,
            ),
        ],
      ),
    );
  }
}

/// 统一加载视图组件
class AppLoadingView extends StatelessWidget {
  final String? message;
  final bool compact;

  const AppLoadingView({
    super.key,
    this.message,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            if (message != null) ...[
              const SizedBox(width: 12),
              Text(message!, style: TextStyle(color: Colors.grey[600])),
            ],
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }
}

/// 统一空状态视图
class AppEmptyView extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;
  final bool compact;

  const AppEmptyView({
    super.key,
    this.title = '暂无数据',
    this.message = '这里还没有内容',
    this.icon = LucideIcons.inbox,
    this.onAction,
    this.actionText,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorView(
      title: title,
      message: message,
      icon: icon,
      iconColor: Colors.grey[400],
      onRetry: onAction,
      retryText: actionText ?? '刷新',
      compact: compact,
    );
  }
}
