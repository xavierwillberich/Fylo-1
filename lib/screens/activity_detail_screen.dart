import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/event.dart';

class ActivityDetailScreen extends StatefulWidget {
  final Event event;

  const ActivityDetailScreen({
    super.key,
    required this.event,
  });

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  int currentImageIndex = 0;
  double swipeOffset = 0;
  bool isDragging = false;

  String _generateActivityId() {
    final categoryPrefix = widget.event.category.substring(0, 3).toUpperCase();
    return '$categoryPrefix-${widget.event.id.toString().padLeft(4, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final activityId = _generateActivityId();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Gradient Header with Activity ID
              SliverToBoxAdapter(
                child: Container(
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
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // Header Bar
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              const Text(
                                'Activity Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                        ),
                        // Activity ID Badge
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    LucideIcons.hash,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    activityId,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'monospace',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Hero Image
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Transform.translate(
                    offset: const Offset(0, -16),
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: PageView.builder(
                              itemCount: widget.event.images.length,
                              onPageChanged: (index) {
                                setState(() {
                                  currentImageIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return CachedNetworkImage(
                                  imageUrl: widget.event.images[index],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                              ),
                            ),
                          ),
                          // Image indicators
                          if (widget.event.images.length > 1)
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Row(
                                children: List.generate(
                                  widget.event.images.length,
                                  (index) => Container(
                                    margin: const EdgeInsets.only(left: 6),
                                    width: index == currentImageIndex ? 24 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: index == currentImageIndex
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          // Title on image
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Text(
                              widget.event.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Content Section
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Date and Location Section
                    _buildSection(
                      'Date and Location',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF6B7280)),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.event.dayOfWeek}, ${widget.event.date} ${widget.event.month}',
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(LucideIcons.clock, size: 16, color: Color(0xFF6B7280)),
                              const SizedBox(width: 8),
                              Text(
                                widget.event.time,
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(LucideIcons.mapPin, size: 16, color: Color(0xFF6B7280)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.event.location,
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 40),

                    // Details Section
                    _buildSection(
                      'Details',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildBadge(activityId, LucideIcons.hash),
                              _buildBadge(widget.event.category, null),
                              if (widget.event.recruiting)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Recruiting',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (widget.event.description != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              widget.event.description!,
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const Divider(height: 40),

                    // Key Information
                    _buildInfoRow(
                      LucideIcons.dollarSign,
                      'Budget per person',
                      '\$${widget.event.budget}',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      LucideIcons.users,
                      'Participants',
                      '${widget.event.participants} people',
                    ),

                    const Divider(height: 40),

                    // Host Section
                    _buildSection(
                      'Host',
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Alice Chen',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Event Organizer',
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 40),

                    // Participants Section
                    if (widget.event.attendeeAvatars != null &&
                        widget.event.attendeeAvatars!.isNotEmpty)
                      _buildSection(
                        '${widget.event.participants} Going',
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 56,
                              child: Stack(
                                children: List.generate(
                                  widget.event.attendeeAvatars!.length > 4
                                      ? 5
                                      : widget.event.attendeeAvatars!.length,
                                  (index) {
                                    if (index == 4) {
                                      return Positioned(
                                        left: index * 40.0,
                                        child: Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF6B7280),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 4,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '+${widget.event.participants - 4}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return Positioned(
                                      left: index * 40.0,
                                      child: Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 4,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            widget.event.attendeeAvatars![index],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '曾根悠一, Harry Singh, chaitra nagaraj, Shourya, and 8 more',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ]),
                ),
              ),
            ],
          ),

          // Fixed Bottom Swipe-to-Join
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      swipeOffset = (swipeOffset + details.delta.dx).clamp(0.0, 280.0);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (swipeOffset > 200) {
                      setState(() {
                        swipeOffset = 280;
                      });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.event.recruiting
                                  ? 'Successfully Joined Activity!'
                                  : 'Join Request Sent!',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        setState(() {
                          swipeOffset = 0;
                        });
                      });
                    } else {
                      setState(() {
                        swipeOffset = 0;
                      });
                    }
                  },
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[50]!,
                          Colors.grey[100]!,
                        ],
                      ),
                      border: Border.all(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        // Success fill
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: swipeOffset,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4ADE80),
                                Color(0xFF22C55E),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        // Slider thumb
                        Positioned(
                          left: swipeOffset,
                          top: 8,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                swipeOffset > 200 ? '✓' : '→',
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                        // Text instruction
                        if (swipeOffset < 100)
                          Center(
                            child: Text(
                              widget.event.recruiting
                                  ? 'Slide to Join Activity'
                                  : 'Slide to Request to Join',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        // Success text
                        if (swipeOffset > 180)
                          const Center(
                            child: Text(
                              'Joining...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildBadge(String text, IconData? icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        border: Border.all(
          color: const Color(0xFFD1D5DB),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: const Color(0xFF6B7280)),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF6B7280)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 15,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
