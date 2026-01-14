/// API 配置
/// P1-1: 使用 --dart-define 注入敏感配置
/// 
/// 运行示例:
/// ```bash
/// flutter run --dart-define=GOOGLE_API_KEY=your_key_here
/// flutter build apk --dart-define=GOOGLE_API_KEY=your_key_here
/// ```
class ApiConfig {
  /// Google/Gemini API Key
  /// 通过 --dart-define=GOOGLE_API_KEY=xxx 注入
  static const String googleApiKey = String.fromEnvironment(
    'GOOGLE_API_KEY',
    defaultValue: '', // 生产环境不应有默认值
  );

  /// Gemini 模型名称
  static const String geminiModel = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-2.0-flash',
  );

  /// 检查必要的 API Key 是否已配置
  static bool get isConfigured => googleApiKey.isNotEmpty;

  /// 验证配置，抛出异常如果未配置
  static void validate() {
    if (googleApiKey.isEmpty) {
      throw StateError(
        'GOOGLE_API_KEY not configured. '
        'Run with: flutter run --dart-define=GOOGLE_API_KEY=your_key',
      );
    }
  }
}
