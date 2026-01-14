import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onFollow;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildUserAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      post.timestamp,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onFollow,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: post.isFollowing
                        ? Colors.grey[200]
                        : const Color(0xFF9333EA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    post.isFollowing ? 'Following' : 'Follow',
                    style: TextStyle(
                      color: post.isFollowing
                          ? Colors.grey[700]
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.content.text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF1F2937),
            ),
          ),
          if (post.content.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildPostImage(post.content.images.first),
            ),
          ],
          if (post.relatedActivity != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildActivityImage(post.relatedActivity!.image),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.relatedActivity!.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          post.relatedActivity!.activityId,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
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
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              _buildActionButton(
                icon: post.isLiked ? LucideIcons.heart : LucideIcons.heart,
                label: '${post.likes}',
                onTap: onLike,
                isActive: post.isLiked,
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                icon: LucideIcons.messageCircle,
                label: '${post.comments}',
                onTap: onComment,
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                icon: LucideIcons.share2,
                label: '${post.shares}',
                onTap: onShare,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建用户头像，处理 avatar 为空/无效时的兜底
  /// 优化：使用 uri.isAbsolute 判断，增加 errorWidget
  Widget _buildUserAvatar() {
    final avatar = post.user.avatar;
    final name = post.user.name;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    // 优化：更稳的 URL 判断
    final uri = Uri.tryParse(avatar);
    if (avatar.isNotEmpty && uri != null && uri.isAbsolute) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatar,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          placeholder: (_, __) => _buildFallbackAvatar(initial),
          errorWidget: (_, __, ___) => _buildFallbackAvatar(initial),
        ),
      );
    }

    return _buildFallbackAvatar(initial);
  }

  /// 兜底头像：渐变背景 + 首字母
  Widget _buildFallbackAvatar(String initial) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// 构建帖子图片，增加 placeholder 和 errorWidget
  Widget _buildPostImage(String imageUrl) {
    final uri = Uri.tryParse(imageUrl);
    if (imageUrl.isEmpty || uri == null || !uri.isAbsolute) {
      return _buildImagePlaceholder(height: 200);
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => _buildImagePlaceholder(height: 200),
      errorWidget: (_, __, ___) => _buildImagePlaceholder(height: 200, isError: true),
    );
  }

  /// 构建关联活动图片
  Widget _buildActivityImage(String imageUrl) {
    final uri = Uri.tryParse(imageUrl);
    if (imageUrl.isEmpty || uri == null || !uri.isAbsolute) {
      return _buildImagePlaceholder(width: 50, height: 50);
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      placeholder: (_, __) => _buildImagePlaceholder(width: 50, height: 50),
      errorWidget: (_, __, ___) => _buildImagePlaceholder(width: 50, height: 50, isError: true),
    );
  }

  /// 图片占位符
  Widget _buildImagePlaceholder({double? width, double height = 200, bool isError = false}) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          isError ? LucideIcons.imageOff : LucideIcons.image,
          color: Colors.grey[400],
          size: height > 100 ? 40 : 20,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFEE2E2) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
