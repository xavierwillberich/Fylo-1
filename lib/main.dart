import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home_screen.dart';
import 'screens/pool_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/login_screen.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FyloApp());
}

class FyloApp extends StatelessWidget {
  const FyloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fylo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9333EA),
          primary: const Color(0xFF9333EA),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    PoolScreen(),
    MessagesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: Border(top: BorderSide(color: Colors.grey[100]!, width: 1)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(LucideIcons.home, 'Home', 0),
                _buildNavItem(LucideIcons.radio, 'Discover', 1),
                _buildNavItem(LucideIcons.messageSquare, 'Chat', 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFFEDE9FE), Color(0xFFFCE7F3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF9333EA)
                    : const Color(0xFF6B7280),
                size: 24,
                fill: isSelected ? 1.0 : 0.0,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF9333EA)
                      : const Color(0xFF6B7280),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// P0-4 修复：AuthWrapper 支持 4 种状态
/// - loading: 等待认证状态
/// - error: 认证服务异常
/// - authenticated: 已登录
/// - unauthenticated: 未登录
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // 使用单例
  final _authService = AuthService.instance;

  // 超时计时器
  Timer? _timeoutTimer;
  bool _isTimeout = false;

  // 超时时间（秒）
  static const int _timeoutSeconds = 5;

  @override
  void initState() {
    super.initState();
    _startTimeoutTimer();
  }

  void _startTimeoutTimer() {
    _timeoutTimer?.cancel();
    _isTimeout = false;
    _timeoutTimer = Timer(const Duration(seconds: _timeoutSeconds), () {
      if (mounted) {
        setState(() => _isTimeout = true);
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // ========== 状态 1: Loading ==========
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 超时后显示重试选项
          if (_isTimeout) {
            return _buildErrorScreen(
              title: '连接超时',
              message: '无法连接到服务器，请检查网络后重试',
              onRetry: () {
                setState(() {
                  _startTimeoutTimer();
                });
              },
            );
          }
          return _buildLoadingScreen();
        }

        // ========== 状态 2: Error ==========
        if (snapshot.hasError) {
          return _buildErrorScreen(
            title: '出错了',
            message: '认证服务异常，请稍后重试',
            onRetry: () {
              setState(() {
                _startTimeoutTimer();
              });
            },
          );
        }

        // ========== 状态 3: Authenticated ==========
        if (snapshot.hasData && snapshot.data != null) {
          // 取消超时计时器
          _timeoutTimer?.cancel();
          return const MainScreen();
        }

        // ========== 状态 4: Unauthenticated ==========
        _timeoutTimer?.cancel();
        return const LoginScreen();
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF9333EA), Color(0xFFEC4899)],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                '正在加载...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen({
    required String title,
    required String message,
    required VoidCallback onRetry,
  }) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                LucideIcons.alertCircle,
                size: 64,
                color: Color(0xFFEF4444),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9333EA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
