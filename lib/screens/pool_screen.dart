import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/post.dart';
import '../services/firebase_service.dart';
import '../services/auth_service.dart';
import '../widgets/post_card.dart';
import '../widgets/gradient_header.dart';
import '../core/widgets/app_error_view.dart';
import '../core/exceptions/app_exception.dart';

/// Discover 页面 - 帖子发现流
/// 支持 Following / Worldwide 两个 tab
/// Like/Follow 使用用户偏好存储（遵守 firestore.rules）
///
/// 优化：
/// - 去除 build 副作用：不在 StreamBuilder.builder 中修改状态
/// - 添加下拉刷新
/// - 统一错误文案
class PoolScreen extends StatefulWidget {
  const PoolScreen({super.key});

  @override
  State<PoolScreen> createState() => _PoolScreenState();
}

class _PoolScreenState extends State<PoolScreen> {
  String activeTab = 'Worldwide';
  final List<String> tabs = ['Following', 'Worldwide'];
  final FirebaseService _firebaseService = FirebaseService();

  // 用户偏好状态（仅用于乐观更新）
  Set<String> _optimisticLikedPostIds = {};
  Set<String> _optimisticFollowingUserIds = {};

  // 用于强制刷新 stream 的 key
  int _refreshKey = 0;

  String? get _currentUserId => AuthService.instance.currentUserId;

  @override
  Widget build(BuildContext context) {
    // 未登录时显示提示
    if (_currentUserId == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: Column(
          children: [
            _buildHeader(),
            const Expanded(
              child: AppErrorView(
                title: '请先登录',
                message: '登录后即可浏览和发现精彩内容',
                icon: LucideIcons.logIn,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return GradientHeader(
      height: 140,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: tabs.map((tab) {
                final isActive = tab == activeTab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        activeTab = tab;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Text(
                        tab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isActive
                              ? const Color(0xFF9333EA)
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final uid = _currentUserId!;

    // 使用嵌套 StreamBuilder 组合三个流
    // 优化：不在 builder 中修改状态，使用局部变量
    return StreamBuilder<Set<String>>(
      key: ValueKey('liked_$_refreshKey'),
      stream: _firebaseService.getLikedPostIdsStream(uid),
      builder: (context, likedSnapshot) {
        // 优化：使用局部变量，优先使用 snapshot 数据，fallback 到乐观更新
        final likedIds = likedSnapshot.data ?? _optimisticLikedPostIds;

        return StreamBuilder<Set<String>>(
          key: ValueKey('following_$_refreshKey'),
          stream: _firebaseService.getFollowingUserIdsStream(uid),
          builder: (context, followingSnapshot) {
            final followingIds =
                followingSnapshot.data ?? _optimisticFollowingUserIds;

            return StreamBuilder<List<Post>>(
              key: ValueKey('posts_$_refreshKey'),
              stream: _firebaseService.getWorldwidePostsStream(),
              builder: (context, postsSnapshot) {
                // Loading 状态
                if (postsSnapshot.connectionState == ConnectionState.waiting &&
                    !postsSnapshot.hasData) {
                  return const AppLoadingView(message: '加载中...');
                }

                // Error 状态
                if (postsSnapshot.hasError) {
                  return AppErrorView.fromError(
                    postsSnapshot.error,
                    onRetry: _handleRefresh,
                  );
                }

                // 获取帖子
                var posts = postsSnapshot.data ?? [];

                // 根据 tab 过滤
                if (activeTab == 'Following') {
                  posts = posts
                      .where(
                        (post) =>
                            post.userId.isNotEmpty &&
                            followingIds.contains(post.userId),
                      )
                      .toList();

                  // Following tab 下没有关注任何人
                  if (posts.isEmpty && followingIds.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: const AppEmptyView(
                            title: '还没有关注任何人',
                            message: '去 Worldwide 发现感兴趣的用户并关注他们吧！',
                            icon: LucideIcons.userPlus,
                          ),
                        ),
                      ),
                    );
                  }

                  // Following tab 下关注的人没有发帖
                  if (posts.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: const AppEmptyView(
                            title: '暂无动态',
                            message: '你关注的用户还没有发布内容',
                            icon: LucideIcons.inbox,
                          ),
                        ),
                      ),
                    );
                  }
                }

                // Worldwide tab 下没有帖子
                if (posts.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: const AppEmptyView(
                          title: '暂无帖子',
                          message: '成为第一个发布内容的人吧！',
                          icon: LucideIcons.fileText,
                        ),
                      ),
                    ),
                  );
                }

                // 应用偏好状态到每个帖子（使用局部变量，无副作用）
                final enrichedPosts = posts.map((post) {
                  return post.copyWith(
                    isLiked: likedIds.contains(post.id.toString()),
                    isFollowing:
                        post.userId.isNotEmpty &&
                        followingIds.contains(post.userId),
                  );
                }).toList();

                return RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 20, bottom: 100),
                    itemCount: enrichedPosts.length,
                    itemBuilder: (context, index) {
                      final post = enrichedPosts[index];
                      return PostCard(
                        post: post,
                        onLike: () => _handleLike(post, likedIds),
                        onComment: () => _handleComment(),
                        onShare: () => _handleShare(),
                        onFollow: () => _handleFollow(post, followingIds),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  /// 下拉刷新
  Future<void> _handleRefresh() async {
    setState(() {
      _refreshKey++;
    });
    // 等待一小段时间让 stream 重新连接
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// 处理点赞（乐观更新 + 写入偏好）
  Future<void> _handleLike(Post post, Set<String> currentLikedIds) async {
    final uid = _currentUserId;
    if (uid == null) return;

    final postIdStr = post.id.toString();
    final shouldLike = !currentLikedIds.contains(postIdStr);

    // 乐观更新（修改本地状态用于下次渲染 fallback）
    setState(() {
      _optimisticLikedPostIds = Set.from(currentLikedIds);
      if (shouldLike) {
        _optimisticLikedPostIds.add(postIdStr);
      } else {
        _optimisticLikedPostIds.remove(postIdStr);
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
          _optimisticLikedPostIds.remove(postIdStr);
        } else {
          _optimisticLikedPostIds.add(postIdStr);
        }
      });
      if (mounted) {
        _showErrorSnackBar(e);
      }
    }
  }

  /// 处理关注（乐观更新 + 写入偏好）
  Future<void> _handleFollow(Post post, Set<String> currentFollowingIds) async {
    final uid = _currentUserId;
    if (uid == null || post.userId.isEmpty) return;

    // 不能关注自己
    if (post.userId == uid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('不能关注自己')));
      return;
    }

    final shouldFollow = !currentFollowingIds.contains(post.userId);

    // 乐观更新
    setState(() {
      _optimisticFollowingUserIds = Set.from(currentFollowingIds);
      if (shouldFollow) {
        _optimisticFollowingUserIds.add(post.userId);
      } else {
        _optimisticFollowingUserIds.remove(post.userId);
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
          _optimisticFollowingUserIds.remove(post.userId);
        } else {
          _optimisticFollowingUserIds.add(post.userId);
        }
      });
      if (mounted) {
        _showErrorSnackBar(e);
      }
    }
  }

  /// 统一错误提示（使用 AppException 转换为用户可读文案）
  void _showErrorSnackBar(dynamic error) {
    final message = AppException.fromError(error).userMessage;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// 处理评论（暂未实现）
  void _handleComment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('评论功能即将上线'), duration: Duration(seconds: 1)),
    );
  }

  /// 处理分享（暂未实现）
  void _handleShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('分享功能即将上线'), duration: Duration(seconds: 1)),
    );
  }
}
