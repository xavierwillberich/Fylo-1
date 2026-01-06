import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            Container(
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
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
