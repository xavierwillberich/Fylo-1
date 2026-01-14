import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/firebase_service.dart';
import '../widgets/post_card.dart';
import '../widgets/gradient_header.dart';

class PoolScreen extends StatefulWidget {
  const PoolScreen({super.key});

  @override
  State<PoolScreen> createState() => _PoolScreenState();
}

class _PoolScreenState extends State<PoolScreen> {
  String activeTab = 'Worldwide';
  final List<String> tabs = ['Following', 'Worldwide'];
  final FirebaseService _firebaseService = FirebaseService();

  void toggleLike(int postId, bool isLiked, int currentLikes) {
    final newLikeCount = isLiked ? currentLikes - 1 : currentLikes + 1;
    _firebaseService.togglePostLike(postId, !isLiked, newLikeCount);
  }

  void toggleFollow(int postId, bool isFollowing) {
    _firebaseService.toggleFollowUser(postId, !isFollowing);
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
            child: StreamBuilder<List<Post>>(
              stream: _firebaseService.getPostsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final posts = snapshot.data ?? [];

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 20, bottom: 100),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(
                      post: post,
                      onLike: () =>
                          toggleLike(post.id, post.isLiked, post.likes),
                      onComment: () {},
                      onShare: () {},
                      onFollow: () => toggleFollow(post.id, post.isFollowing),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
