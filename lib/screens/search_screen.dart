import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/post.dart';
import '../models/event.dart';
import '../services/firebase_service.dart';
import '../services/auth_service.dart';
import '../widgets/post_card.dart';
import '../core/widgets/app_error_view.dart';
import '../core/exceptions/app_exception.dart';
import 'activity_detail_screen.dart';

/// 搜索页面
/// 支持搜索帖子和活动
/// 
/// 优化：
/// - debounce 300ms 避免频繁请求
/// - 限制 events 拉取量（200）
/// - 统一错误文案
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  // Debounce timer
  Timer? _debounceTimer;
  static const _debounceDuration = Duration(milliseconds: 300);

  bool _isLoading = false;
  String? _error;
  List<Post> _postResults = [];
  List<Event> _eventResults = [];
  String _searchQuery = '';

  // 用户偏好
  Set<String> _likedPostIds = {};
  Set<String> _followingUserIds = {};

  String? get _currentUserId => AuthService.instance.currentUserId;

  final List<Map<String, dynamic>> trendingSearches = [
    {'icon': LucideIcons.trendingUp, 'text': 'Hiking', 'trend': '+120%'},
    {'icon': LucideIcons.trendingUp, 'text': 'Board Games', 'trend': '+85%'},
    {'icon': LucideIcons.trendingUp, 'text': 'Coffee Chat', 'trend': '+64%'},
    {'icon': LucideIcons.hash, 'text': 'TRI-', 'trend': '+52%'},
    {'icon': LucideIcons.trendingUp, 'text': 'Mount Rainier', 'trend': '+43%'},
    {'icon': LucideIcons.trendingUp, 'text': 'Seattle', 'trend': '+38%'},
    {'icon': LucideIcons.trendingUp, 'text': 'Weekend', 'trend': '+29%'},
    {'icon': LucideIcons.trendingUp, 'text': 'Beginner', 'trend': '+21%'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  /// 优化：使用 debounce 避免频繁请求
  void _onSearchChanged() {
    final query = _searchController.text.trim();

    // 取消之前的 timer
    _debounceTimer?.cancel();

    if (query.isEmpty && _searchQuery.isNotEmpty) {
      setState(() {
        _searchQuery = '';
        _postResults = [];
        _eventResults = [];
        _error = null;
      });
      return;
    }

    if (query.length >= 2 && query != _searchQuery) {
      // 设置 debounce
      _debounceTimer = Timer(_debounceDuration, () {
        _performSearch(query);
      });
    }
  }

  Future<void> _loadUserPreferences() async {
    final uid = _currentUserId;
    if (uid == null) return;

    try {
      final likedStream = _firebaseService.getLikedPostIdsStream(uid);
      final followingStream = _firebaseService.getFollowingUserIdsStream(uid);

      likedStream.first.then((value) {
        if (mounted) setState(() => _likedPostIds = value);
      });
      followingStream.first.then((value) {
        if (mounted) setState(() => _followingUserIds = value);
      });
    } catch (_) {}
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _searchQuery = query;
    });

    try {
      // 优化：并行获取帖子和活动，限制数量
      final results = await Future.wait([
        _firebaseService.getRecentPosts(limit: 100),
        _firebaseService.getRecentEvents(limit: 200), // 优化：使用限制版本
      ]);

      final allPosts = results[0] as List<Post>;
      final allEvents = results[1] as List<Event>;

      final queryLower = query.toLowerCase();

      // 客户端过滤帖子
      final filteredPosts = allPosts.where((post) {
        return post.content.text.toLowerCase().contains(queryLower) ||
            post.user.name.toLowerCase().contains(queryLower) ||
            post.user.username.toLowerCase().contains(queryLower) ||
            (post.relatedActivity?.title.toLowerCase().contains(queryLower) ??
                false);
      }).toList();

      // 客户端过滤活动
      final filteredEvents = allEvents.where((event) {
        return event.title.toLowerCase().contains(queryLower) ||
            event.description.toLowerCase().contains(queryLower) ||
            event.location.toLowerCase().contains(queryLower) ||
            event.category.toLowerCase().contains(queryLower);
      }).toList();

      if (mounted) {
        setState(() {
          _postResults = filteredPosts;
          _eventResults = filteredEvents;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AppException.fromError(e).userMessage;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF9333EA),
            Color(0xFFEC4899),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Search',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search activities, locations, ID...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                  prefixIcon: const Icon(
                    LucideIcons.search,
                    color: Colors.white,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(LucideIcons.x, color: Colors.white),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                              _postResults = [];
                              _eventResults = [];
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().length >= 2) {
                    _debounceTimer?.cancel();
                    _performSearch(value.trim());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // 未搜索时显示 trending
    if (_searchQuery.isEmpty) {
      return _buildTrending();
    }

    // 加载中
    if (_isLoading) {
      return const AppLoadingView(message: '搜索中...');
    }

    // 错误
    if (_error != null) {
      return AppErrorView(
        title: '搜索失败',
        message: _error!,
        icon: LucideIcons.alertCircle,
        onRetry: () => _performSearch(_searchQuery),
      );
    }

    // 无结果
    if (_postResults.isEmpty && _eventResults.isEmpty) {
      return const AppEmptyView(
        title: '未找到结果',
        message: '尝试其他关键词',
        icon: LucideIcons.searchX,
      );
    }

    // 显示结果
    return _buildResults();
  }

  Widget _buildTrending() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Row(
          children: [
            Icon(
              LucideIcons.trendingUp,
              color: Color(0xFFF97316),
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Trending Searches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemCount: trendingSearches.length,
          itemBuilder: (context, index) {
            final search = trendingSearches[index];
            return GestureDetector(
              onTap: () {
                _searchController.text = search['text'];
                _debounceTimer?.cancel();
                _performSearch(search['text']);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      search['icon'],
                      color: const Color(0xFFF97316),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        search['text'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        search['trend'],
                        style: const TextStyle(
                          color: Color(0xFFF97316),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          '仅搜索最近内容',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildResults() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // 活动结果
        if (_eventResults.isNotEmpty) ...[
          Row(
            children: [
              const Icon(
                LucideIcons.calendar,
                color: Color(0xFF9333EA),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Activities (${_eventResults.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...(_eventResults.take(5).map((event) => _buildEventCard(event))),
          if (_eventResults.length > 5)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '还有 ${_eventResults.length - 5} 个活动...',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 20),
        ],

        // 帖子结果
        if (_postResults.isNotEmpty) ...[
          Row(
            children: [
              const Icon(
                LucideIcons.fileText,
                color: Color(0xFF9333EA),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Posts (${_postResults.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...(_postResults.take(10).map((post) {
            // 应用偏好状态
            final enrichedPost = post.copyWith(
              isLiked: _likedPostIds.contains(post.id.toString()),
              isFollowing: post.userId.isNotEmpty &&
                  _followingUserIds.contains(post.userId),
            );
            return PostCard(
              post: enrichedPost,
              onLike: () => _handleLike(post),
              onComment: () => _showComingSoon('评论'),
              onShare: () => _showComingSoon('分享'),
              onFollow: () => _handleFollow(post),
            );
          })),
          if (_postResults.length > 10)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '还有 ${_postResults.length - 10} 个帖子...',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
        ],

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildEventCard(Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ActivityDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 日期卡片
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.date,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    event.month,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.mapPin,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLike(Post post) async {
    final uid = _currentUserId;
    if (uid == null) {
      _showComingSoon('登录后才能点赞');
      return;
    }

    final postIdStr = post.id.toString();
    final shouldLike = !_likedPostIds.contains(postIdStr);

    setState(() {
      if (shouldLike) {
        _likedPostIds.add(postIdStr);
      } else {
        _likedPostIds.remove(postIdStr);
      }
    });

    try {
      await _firebaseService.toggleLikePostId(
        currentUid: uid,
        postId: postIdStr,
        shouldLike: shouldLike,
      );
    } catch (e) {
      // 回滚
      setState(() {
        if (shouldLike) {
          _likedPostIds.remove(postIdStr);
        } else {
          _likedPostIds.add(postIdStr);
        }
      });
      if (mounted) {
        _showErrorSnackBar(e);
      }
    }
  }

  Future<void> _handleFollow(Post post) async {
    final uid = _currentUserId;
    if (uid == null || post.userId.isEmpty) return;
    if (post.userId == uid) return;

    final shouldFollow = !_followingUserIds.contains(post.userId);

    setState(() {
      if (shouldFollow) {
        _followingUserIds.add(post.userId);
      } else {
        _followingUserIds.remove(post.userId);
      }
    });

    try {
      await _firebaseService.toggleFollowUserId(
        currentUid: uid,
        targetUserId: post.userId,
        shouldFollow: shouldFollow,
      );
    } catch (e) {
      // 回滚
      setState(() {
        if (shouldFollow) {
          _followingUserIds.remove(post.userId);
        } else {
          _followingUserIds.add(post.userId);
        }
      });
      if (mounted) {
        _showErrorSnackBar(e);
      }
    }
  }

  void _showErrorSnackBar(dynamic error) {
    final message = AppException.fromError(error).userMessage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature 功能即将上线'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
