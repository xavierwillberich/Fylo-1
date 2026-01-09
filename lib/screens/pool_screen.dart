import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/post.dart';
import '../data/sample_data.dart';
import '../widgets/post_card.dart';
import '../widgets/gradient_header.dart';

class PoolScreen extends StatefulWidget {
  const PoolScreen({super.key});

  @override
  State<PoolScreen> createState() => _PoolScreenState();
}

class _PoolScreenState extends State<PoolScreen> {
  String activeTab = 'Worldwide';
  final List<String> tabs = ['Following', 'Worldwide', 'Nearby'];
  List<Post> posts = SampleData.getPosts();

  void toggleLike(int postId) {
    setState(() {
      final index = posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        posts[index] = Post(
          id: posts[index].id,
          user: posts[index].user,
          content: posts[index].content,
          timestamp: posts[index].timestamp,
          likes: posts[index].isLiked ? posts[index].likes - 1 : posts[index].likes + 1,
          comments: posts[index].comments,
          shares: posts[index].shares,
          isLiked: !posts[index].isLiked,
          isFollowing: posts[index].isFollowing,
          relatedActivity: posts[index].relatedActivity,
        );
      }
    });
  }

  void toggleFollow(int postId) {
    setState(() {
      final index = posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        posts[index] = Post(
          id: posts[index].id,
          user: posts[index].user,
          content: posts[index].content,
          timestamp: posts[index].timestamp,
          likes: posts[index].likes,
          comments: posts[index].comments,
          shares: posts[index].shares,
          isLiked: posts[index].isLiked,
          isFollowing: !posts[index].isFollowing,
          relatedActivity: posts[index].relatedActivity,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          GradientHeader(
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
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 20, bottom: 100),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostCard(
                    post: post,
                    onLike: () => toggleLike(post.id),
                    onComment: () {},
                    onShare: () {},
                    onFollow: () => toggleFollow(post.id),
                  );
                },
            ),
          ),
        ],
      ),
    );
  }
}
