# Fylo 环境配置指南

## 敏感配置说明

本项目使用 `--dart-define` 注入敏感配置（如 API Key），避免在代码中硬编码。

## 必要的配置项

| 变量名 | 说明 | 获取方式 |
|--------|------|----------|
| `GOOGLE_API_KEY` | Gemini AI API Key | [Google AI Studio](https://aistudio.google.com/app/apikey) |
| `GEMINI_MODEL` | Gemini 模型名（可选） | 默认 `gemini-2.0-flash` |

## 本地开发

### 方式 1：命令行直接传入

```bash
flutter run --dart-define=GOOGLE_API_KEY=your_key_here
```

### 方式 2：使用环境变量文件（推荐）

1. 创建 `.env.local` 文件（已在 .gitignore 中）：

```bash
export GOOGLE_API_KEY=your_key_here
export GEMINI_MODEL=gemini-2.0-flash
```

2. 运行时加载：

```bash
source .env.local && flutter run \
  --dart-define=GOOGLE_API_KEY=$GOOGLE_API_KEY \
  --dart-define=GEMINI_MODEL=$GEMINI_MODEL
```

### 方式 3：VS Code / Cursor 配置

在 `.vscode/launch.json` 中添加：

```json
{
  "configurations": [
    {
      "name": "Flutter",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=GOOGLE_API_KEY=your_key_here"
      ]
    }
  ]
}
```

## 构建发布版本

### Android APK

```bash
flutter build apk --dart-define=GOOGLE_API_KEY=$GOOGLE_API_KEY
```

### Android App Bundle

```bash
flutter build appbundle --dart-define=GOOGLE_API_KEY=$GOOGLE_API_KEY
```

### iOS

```bash
flutter build ios --dart-define=GOOGLE_API_KEY=$GOOGLE_API_KEY
```

### Web

```bash
flutter build web --dart-define=GOOGLE_API_KEY=$GOOGLE_API_KEY
```

## CI/CD 集成

### GitHub Actions 示例

```yaml
- name: Build APK
  run: |
    flutter build apk \
      --dart-define=GOOGLE_API_KEY=${{ secrets.GOOGLE_API_KEY }}
```

### Codemagic 示例

在环境变量中设置 `GOOGLE_API_KEY`，然后在 build script 中：

```bash
flutter build apk --dart-define=GOOGLE_API_KEY=$GOOGLE_API_KEY
```

## Google Cloud Console API Key 限制

为了安全，请在 [Google Cloud Console](https://console.cloud.google.com/apis/credentials) 设置以下限制：

### Android

- **应用限制**: Android apps
- **Package name**: `com.example.fylo`（替换为实际包名）
- **SHA-1 指纹**: 从 `keytool` 或 Firebase Console 获取

### iOS

- **应用限制**: iOS apps
- **Bundle ID**: `com.example.fylo`（替换为实际 Bundle ID）

### Web

- **应用限制**: HTTP referrers
- **允许的来源**:
  - `https://your-domain.com/*`
  - `http://localhost:*`（仅开发环境）

## 故障排查

如果 AI 助手显示"未配置"，请检查：

1. 是否传入了 `--dart-define=GOOGLE_API_KEY=xxx`
2. API Key 是否有效（在 Google AI Studio 测试）
3. API Key 是否有正确的 API 权限
