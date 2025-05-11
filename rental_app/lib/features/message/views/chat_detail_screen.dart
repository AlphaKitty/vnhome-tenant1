import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';
import '../models/chat_model.dart';
import '../viewmodels/chat_provider.dart';

/// 聊天详情页面
class ChatDetailScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 加载聊天会话
    Future.microtask(() => _loadChatSession());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// 加载聊天会话数据
  Future<void> _loadChatSession() async {
    await ref.read(chatProvider.notifier).loadChatSession(widget.chatId);

    // 在数据加载完成后，滚动到最后一条消息
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 发送消息
  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();
    await ref.read(chatProvider.notifier).sendMessage(message);

    // 发送消息后滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final chatSession = chatState.chatSession;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title:
            chatSession != null
                ? Text(chatSession.targetUserName)
                : const Text('聊天详情'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // 显示更多选项
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('更多操作功能开发中')));
            },
          ),
        ],
      ),
      body:
          chatState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : chatState.error != null
              ? _buildErrorView(chatState.error!)
              : chatSession == null
              ? const Center(child: Text('会话不存在'))
              : Column(
                children: [
                  // 聊天内容区域
                  Expanded(child: _buildChatContent(chatSession)),

                  // 输入框区域
                  _buildInputField(chatState.isSending),
                ],
              ),
    );
  }

  /// 构建聊天内容区域
  Widget _buildChatContent(ChatSessionModel chatSession) {
    if (chatSession.chatItems.isEmpty) {
      return Center(
        child: Text(
          '暂无聊天记录',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeMedium,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    // 按日期分组
    final groupedMessages = _groupMessagesByDate(chatSession.chatItems);

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(DesignTokens.spacingMedium),
      itemCount: groupedMessages.length,
      itemBuilder: (context, index) {
        final group = groupedMessages[index];
        return Column(
          children: [
            // 日期分隔线
            _buildDateSeparator(group.date),

            // 该日期下的消息列表
            ...group.messages.map((message) => _buildMessageItem(message)),
          ],
        );
      },
    );
  }

  /// 构建日期分隔线
  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    String dateText;
    if (messageDate == today) {
      dateText = '今天';
    } else if (messageDate == yesterday) {
      dateText = '昨天';
    } else {
      dateText =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingMedium),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingSmall,
            ),
            child: Text(
              dateText,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXSmall,
                color: Colors.grey[500],
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  /// 构建单条消息项
  Widget _buildMessageItem(ChatItemModel message) {
    final theme = Theme.of(context);

    // 根据是否是自己发送的消息，调整布局和样式
    if (message.isSentByMe) {
      return Padding(
        padding: EdgeInsets.only(bottom: DesignTokens.spacingMedium),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 消息气泡
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: DesignTokens.circularRadiusMedium,
                    topRight: DesignTokens.circularRadiusSmall,
                    bottomLeft: DesignTokens.circularRadiusMedium,
                    bottomRight: DesignTokens.circularRadiusMedium,
                  ),
                ),
                padding: EdgeInsets.all(DesignTokens.spacingMedium),
                child: Text(
                  message.content,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

            // 用户头像
            SizedBox(width: DesignTokens.spacingSmall),
            CircleAvatar(
              radius: 20,
              backgroundColor: theme.primaryColor.withOpacity(0.2),
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
      );
    } else {
      // 对方发送的消息
      return Padding(
        padding: EdgeInsets.only(bottom: DesignTokens.spacingMedium),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户头像
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                ref
                        .read(chatProvider)
                        .chatSession
                        ?.targetUserName
                        .substring(0, 1) ??
                    '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // 消息气泡
            SizedBox(width: DesignTokens.spacingSmall),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                    topLeft: DesignTokens.circularRadiusSmall,
                    topRight: DesignTokens.circularRadiusMedium,
                    bottomLeft: DesignTokens.circularRadiusMedium,
                    bottomRight: DesignTokens.circularRadiusMedium,
                  ),
                ),
                padding: EdgeInsets.all(DesignTokens.spacingMedium),
                child: Text(
                  message.content,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  /// 构建输入框区域
  Widget _buildInputField(bool isSending) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(DesignTokens.spacingMedium),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          // 添加按钮
          Icon(Icons.add_circle, color: Colors.grey[600], size: 28),
          SizedBox(width: DesignTokens.spacingSmall),

          // 输入框
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: '输入消息...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    DesignTokens.radiusMedium,
                  ),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMedium,
                  vertical: DesignTokens.spacingSmall,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: DesignTokens.spacingSmall),

          // 发送按钮
          IconButton(
            onPressed: isSending ? null : _sendMessage,
            icon: Icon(
              Icons.send,
              color: isSending ? Colors.grey : theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建错误视图
  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
          SizedBox(height: DesignTokens.spacingMedium),
          Text(
            '加载失败',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: DesignTokens.spacingSmall),
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeSmall,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: DesignTokens.spacingMedium),
          ElevatedButton(onPressed: _loadChatSession, child: const Text('重试')),
        ],
      ),
    );
  }

  /// 按日期分组消息
  List<MessageGroup> _groupMessagesByDate(List<ChatItemModel> messages) {
    final groups = <MessageGroup>[];

    // 按日期分组
    for (final message in messages) {
      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      // 查找是否已有该日期的分组
      final existingGroup =
          groups
              .where(
                (g) =>
                    g.date.year == messageDate.year &&
                    g.date.month == messageDate.month &&
                    g.date.day == messageDate.day,
              )
              .toList();

      if (existingGroup.isEmpty) {
        // 创建新分组
        groups.add(MessageGroup(date: messageDate, messages: [message]));
      } else {
        // 添加到现有分组
        existingGroup.first.messages.add(message);
      }
    }

    // 按日期排序
    groups.sort((a, b) => a.date.compareTo(b.date));

    return groups;
  }
}

/// 消息分组类
class MessageGroup {
  final DateTime date;
  final List<ChatItemModel> messages;

  MessageGroup({required this.date, required this.messages});
}
