# Firebase Authentication 设置指南

本指南将帮助您配置 Firebase Authentication 以支持 Google、Apple 和邮箱登录。

## 已完成的工作

✅ 添加了必要的依赖包（google_sign_in, sign_in_with_apple）
✅ 创建了 AuthService 服务类
✅ 创建了登录界面（LoginScreen）
✅ 创建了注册界面（RegisterScreen）
✅ 更新了 main.dart 以处理认证状态

## Firebase Console 配置步骤

### 1. 启用认证方式

1. 访问 [Firebase Console](https://console.firebase.google.com/)
2. 选择您的项目
3. 进入 **Authentication** > **Sign-in method**
4. 启用以下登录方式：
   - **Email/Password**
   - **Google**
   - **Apple**（仅适用于 iOS/macOS）

### 2. Google 登录配置

#### Android 配置
1. 在 Firebase Console 中，下载 `google-services.json`
2. 确保文件已放置在 `android/app/` 目录下
3. 在 `android/app/build.gradle` 中添加 SHA-1 证书指纹：
   ```bash
   # 获取 SHA-1 证书指纹
   cd android
   ./gradlew signingReport
   ```
4. 将 SHA-1 添加到 Firebase Console > Project Settings > Your apps > Android app

#### iOS 配置
1. 在 Firebase Console 中，下载 `GoogleService-Info.plist`
2. 将文件添加到 Xcode 项目的 `Runner` 目录
3. 在 `ios/Runner/Info.plist` 中添加：
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleTypeRole</key>
       <string>Editor</string>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
       </array>
     </dict>
   </array>
   ```
   将 `YOUR-CLIENT-ID` 替换为 `GoogleService-Info.plist` 中的 `REVERSED_CLIENT_ID`

### 3. Apple 登录配置（仅 iOS/macOS）

#### iOS 配置
1. 在 Apple Developer 账户中：
   - 启用 **Sign in with Apple** capability
   - 配置 App ID 和 Service ID

2. 在 Xcode 中：
   - 打开 `ios/Runner.xcworkspace`
   - 选择 Runner target
   - 进入 **Signing & Capabilities**
   - 点击 **+ Capability**
   - 添加 **Sign in with Apple**

3. 在 Firebase Console 中：
   - 进入 Authentication > Sign-in method > Apple
   - 输入您的 Service ID
   - 上传 Apple 私钥

#### macOS 配置
1. 在 Xcode 中打开 `macos/Runner.xcworkspace`
2. 添加 **Sign in with Apple** capability
3. 在 `macos/Runner/DebugProfile.entitlements` 和 `Release.entitlements` 中添加：
   ```xml
   <key>com.apple.developer.applesignin</key>
   <array>
     <string>Default</string>
   </array>
   ```

### 4. 邮箱/密码登录配置

1. 在 Firebase Console 的 Authentication > Sign-in method 中
2. 启用 **Email/Password** 提供商
3. （可选）启用邮箱链接登录（无需密码）

## 安装依赖

运行以下命令安装新添加的依赖：

```bash
flutter pub get
```

## 测试认证流程

### 1. 运行应用
```bash
flutter run
```

### 2. 测试功能
- ✅ 邮箱注册
- ✅ 邮箱登录
- ✅ Google 登录
- ✅ Apple 登录（iOS/macOS）
- ✅ 忘记密码
- ✅ 退出登录

## 文件结构

```
lib/
├── services/
│   └── auth_service.dart          # 认证服务（Google, Apple, Email）
├── screens/
│   ├── login_screen.dart          # 登录界面
│   └── register_screen.dart       # 注册界面
└── main.dart                      # 包含 AuthWrapper 处理认证状态
```

## 使用 AuthService

```dart
import 'package:fylo/services/auth_service.dart';

final authService = AuthService();

// Google 登录
await authService.signInWithGoogle();

// Apple 登录
await authService.signInWithApple();

// 邮箱登录
await authService.signInWithEmailAndPassword(email, password);

// 邮箱注册
await authService.registerWithEmailAndPassword(email, password, name);

// 退出登录
await authService.signOut();

// 重置密码
await authService.sendPasswordResetEmail(email);
```

## 常见问题

### Google 登录失败
- 确保 SHA-1 证书已添加到 Firebase Console
- 检查 `google-services.json` 是否最新
- 验证包名是否匹配

### Apple 登录失败
- 确保在 Apple Developer 中启用了 Sign in with Apple
- 检查 Service ID 配置是否正确
- 验证 capability 是否已添加到 Xcode 项目

### 邮箱登录失败
- 检查 Firebase Console 中是否启用了 Email/Password
- 验证邮箱格式是否正确
- 确保密码至少 6 个字符

## 安全建议

1. **启用邮箱验证**：在 Firebase Console 中启用邮箱验证要求
2. **配置密码策略**：设置强密码要求
3. **启用多因素认证**：为敏感操作添加额外安全层
4. **监控认证活动**：定期检查 Firebase Console 中的认证日志

## 下一步

- [ ] 在 Firebase Console 中配置所有认证提供商
- [ ] 测试所有登录方式
- [ ] 配置邮箱模板（密码重置、验证等）
- [ ] 添加用户资料完善流程
- [ ] 实现社交账号关联功能
