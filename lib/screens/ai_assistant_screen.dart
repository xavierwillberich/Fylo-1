import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/event.dart';
import '../services/firebase_service.dart';
import '../config/api_config.dart';

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<Map<String, dynamic>>? suggestedActivities;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.suggestedActivities,
  });
}

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseService _firebaseService = FirebaseService();
  final List<Message> _messages = [];
  bool _isLoading = false;
  late GenerativeModel _model;
  late ChatSession _chatSession;
  List<Event> _firebaseActivities = [];

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    // P1-1: 检查 API Key 配置
    if (!ApiConfig.isConfigured) {
      _messages.add(
        Message(
          text: '⚠️ AI 助手未配置。请联系管理员设置 API Key。',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      setState(() {});
      return;
    }

    _model = GenerativeModel(
      model: ApiConfig.geminiModel,
      apiKey: ApiConfig.googleApiKey,
      systemInstruction: Content.text('''你是Fylo应用的AI助手。你的职责是帮助用户创建和发现活动。

当用户想要创建活动时，你应该：
1. 询问活动的基本信息（名称、类型、时间、地点）
2. 询问参与人数和难度等级
3. 提供一个总结，然后建议用户确认创建

当用户想要发现活动时，你应该：
1. 了解他们的兴趣和偏好
2. 推荐相关的活动
3. 提供活动的详细信息

始终保持友好和有帮助的态度。使用表情符号使对话更有趣。
回应应该简洁但有信息量。'''),
    );
    
    _chatSession = _model.startChat();
    _loadFirebaseActivities();
    
    _messages.add(
      Message(
        text: '你好！👋 我是Fylo AI助手。我可以帮你创建新活动或发现有趣的活动。你想做什么呢？',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    final userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      _messages.add(
        Message(
          text: userMessage,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = true;
    });

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 800), () {
      _processUserMessage(userMessage);
    });
  }

  Future<void> _processUserMessage(String message) async {
    try {
      String enhancedMessage = message;
      
      if (message.toLowerCase().contains('发现') || 
          message.toLowerCase().contains('推荐') ||
          message.toLowerCase().contains('找活动') ||
          message.toLowerCase().contains('搜索')) {
        
        if (_firebaseActivities.isNotEmpty) {
          final activitiesContext = _firebaseActivities.take(5).map((event) {
            return '- ${event.title} (${event.category}, ${event.location}, ${event.month} ${event.date} ${event.time}, ${event.participants}人参加)';
          }).join('\n');
          
          enhancedMessage = '$message\n\n当前可用的活动：\n$activitiesContext';
        }
      }

      final response = await _chatSession.sendMessage(
        Content.text(enhancedMessage),
      );

      final responseText = response.text ?? '抱歉，我无法生成响应。请重试。';

      List<Map<String, dynamic>>? suggestedActivities;
      
      if (message.toLowerCase().contains('发现') || 
          message.toLowerCase().contains('推荐') ||
          message.toLowerCase().contains('找活动')) {
        suggestedActivities = _generateSuggestedActivities();
      }

      if (mounted) {
        setState(() {
          _messages.add(
            Message(
              text: responseText,
              isUser: false,
              timestamp: DateTime.now(),
              suggestedActivities: suggestedActivities,
            ),
          );
          _isLoading = false;
        });

        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            Message(
              text: '抱歉，发生了一个错误：${e.toString()}\n请检查你的网络连接并重试。',
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadFirebaseActivities() async {
    try {
      final activities = await _firebaseService.getAllEvents();
      if (mounted) {
        setState(() {
          _firebaseActivities = activities;
        });
      }
    } catch (e) {
      debugPrint('Error loading Firebase activities: $e');
    }
  }

  List<Map<String, dynamic>> _generateSuggestedActivities() {
    if (_firebaseActivities.isEmpty) {
      return [
        {
          'title': '周末篮球友谊赛',
          'category': '运动',
          'location': '市体育馆',
          'time': '周六 14:00',
          'participants': 12,
          'level': '中级',
        },
        {
          'title': '咖啡馆读书会',
          'category': '社交',
          'location': '星巴克（中心店）',
          'time': '周日 10:00',
          'participants': 8,
          'level': '初级',
        },
        {
          'title': '瑜伽课程',
          'category': '健身',
          'location': '瑜伽馆',
          'time': '周五 19:00',
          'participants': 15,
          'level': '初级',
        },
      ];
    }

    return _firebaseActivities.take(5).map((event) {
      String proficiencyText = '';
      switch (event.proficiency) {
        case ProficiencyLevel.beginner:
          proficiencyText = '初级';
          break;
        case ProficiencyLevel.intermediate:
          proficiencyText = '中级';
          break;
        case ProficiencyLevel.advanced:
          proficiencyText = '高级';
          break;
        case ProficiencyLevel.expert:
          proficiencyText = '专家';
          break;
      }

      return {
        'title': event.title,
        'category': event.category,
        'location': event.location,
        'time': '${event.month} ${event.date} ${event.time}',
        'participants': event.participants,
        'level': proficiencyText,
        'eventId': event.id,
      };
    }).toList();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _quickAction(String action) {
    _messageController.text = action;
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D2D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    LucideIcons.x,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const Text(
                  'AI助手',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _messages.clear();
                    });
                    _initializeChat();
                  },
                  child: Icon(
                    LucideIcons.refreshCw,
                    color: Colors.white.withOpacity(0.6),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2D2D2D),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: _messages.isEmpty
                  ? Center(
                      child: Text(
                        '开始聊天',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI正在思考...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_messages.length <= 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickActionButton('创建活动', () => _quickAction('我想创建一个新活动')),
                        _buildQuickActionButton('发现活动', () => _quickAction('推荐一些有趣的活动')),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _messageController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: '输入消息...',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFF9333EA),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: message.isUser ? const Color(0xFF9333EA) : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.white.withOpacity(0.9),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          if (message.suggestedActivities != null && message.suggestedActivities!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: message.suggestedActivities!
                    .map((activity) => _buildActivityCard(activity))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  activity['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF9333EA).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  activity['category'] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9333EA),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(LucideIcons.mapPin, size: 14, color: Colors.white.withOpacity(0.6)),
              const SizedBox(width: 4),
              Text(
                activity['location'] ?? '',
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(LucideIcons.clock, size: 14, color: Colors.white.withOpacity(0.6)),
              const SizedBox(width: 4),
              Text(
                activity['time'] ?? '',
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.users, size: 14, color: Colors.white.withOpacity(0.6)),
                  const SizedBox(width: 4),
                  Text(
                    '${activity['participants']}人',
                    style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('已加入 ${activity['title']}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9333EA),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '加入',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
