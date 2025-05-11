import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';
import '../models/message_model.dart';
import '../viewmodels/message_provider.dart';
import 'chat_detail_screen.dart';

/// 消息中心标签页
class MessageTabScreen extends ConsumerStatefulWidget {
  const MessageTabScreen({super.key});

  @override
  ConsumerState<MessageTabScreen> createState() => _MessageTabScreenState();
}

class _MessageTabScreenState extends ConsumerState<MessageTabScreen> {
  @override
  void initState() {
    super.initState();
    // 加载消息数据
    Future.microtask(() => ref.read(messageProvider.notifier).loadMessages());
  }

  @override
  Widget build(BuildContext context) {
    final messageState = ref.watch(messageProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('消息中心'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // 显示更多选项
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('更多操作功能开发中')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 消息类型选择按钮
          Padding(
            padding: EdgeInsets.all(DesignTokens.spacingMedium),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () => ref
                            .read(messageProvider.notifier)
                            .selectTab(MessageTabOption.system),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          messageState.selectedTab == MessageTabOption.system
                              ? theme.primaryColor
                              : theme.cardColor,
                      foregroundColor:
                          messageState.selectedTab == MessageTabOption.system
                              ? Colors.white
                              : theme.textTheme.bodyLarge?.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusSmall,
                        ),
                        side: BorderSide(
                          color:
                              messageState.selectedTab ==
                                      MessageTabOption.system
                                  ? Colors.transparent
                                  : theme.dividerColor,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: DesignTokens.spacingSmall,
                      ),
                    ),
                    child: const Text('系统通知'),
                  ),
                ),
                SizedBox(width: DesignTokens.spacingMedium),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () => ref
                            .read(messageProvider.notifier)
                            .selectTab(MessageTabOption.chat),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          messageState.selectedTab == MessageTabOption.chat
                              ? theme.primaryColor
                              : theme.cardColor,
                      foregroundColor:
                          messageState.selectedTab == MessageTabOption.chat
                              ? Colors.white
                              : theme.textTheme.bodyLarge?.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusSmall,
                        ),
                        side: BorderSide(
                          color:
                              messageState.selectedTab == MessageTabOption.chat
                                  ? Colors.transparent
                                  : theme.dividerColor,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: DesignTokens.spacingSmall,
                      ),
                    ),
                    child: const Text('房东消息'),
                  ),
                ),
              ],
            ),
          ),

          // 消息内容区域
          Expanded(
            child:
                messageState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : messageState.error != null
                    ? _buildErrorView(messageState.error!)
                    : messageState.selectedTab == MessageTabOption.system
                    ? _buildSystemMessageList(messageState)
                    : _buildChatMessageList(messageState),
          ),
        ],
      ),
    );
  }

  /// 构建系统消息列表
  Widget _buildSystemMessageList(MessageState state) {
    if (state.systemMessages.isEmpty) {
      return _buildEmptyView('暂无系统通知');
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: state.systemMessages.length,
      itemBuilder: (context, index) {
        final message = state.systemMessages[index];
        return _buildSystemMessageItem(message);
      },
    );
  }

  /// 构建聊天消息列表
  Widget _buildChatMessageList(MessageState state) {
    if (state.chatMessages.isEmpty) {
      return _buildEmptyView('暂无聊天消息');
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: state.chatMessages.length,
      itemBuilder: (context, index) {
        final message = state.chatMessages[index];
        return _buildChatMessageItem(message);
      },
    );
  }

  /// 构建空消息视图
  Widget _buildEmptyView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.message, size: 80, color: Colors.grey[400]),
          SizedBox(height: DesignTokens.spacingMedium),
          Text(
            message,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMedium,
              color: Colors.grey[600],
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
          ElevatedButton(
            onPressed: () => ref.read(messageProvider.notifier).loadMessages(),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  /// 构建系统消息项
  Widget _buildSystemMessageItem(SystemMessageModel message) {
    final theme = Theme.of(context);

    // 根据消息类型选择图标
    IconData iconData;
    Color iconColor;

    switch (message.iconName) {
      case 'bell':
        iconData = Icons.notifications;
        iconColor = Colors.orange;
        break;
      case 'check-circle':
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case 'home':
        iconData = Icons.home;
        iconColor = theme.primaryColor;
        break;
      default:
        iconData = Icons.message;
        iconColor = theme.primaryColor;
    }

    // 格式化日期时间
    final now = DateTime.now();
    final difference = now.difference(message.timestamp);
    String formattedTime;

    if (difference.inDays > 0) {
      formattedTime = '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      formattedTime = '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      formattedTime = '${difference.inMinutes}分钟前';
    } else {
      formattedTime = '刚刚';
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor, width: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(DesignTokens.spacingMedium),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(iconData, color: iconColor, size: 30),
        ),
        title: Padding(
          padding: EdgeInsets.only(bottom: DesignTokens.spacingXSmall),
          child: Text(
            message.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: DesignTokens.fontSizeMedium,
            ),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeSmall,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: DesignTokens.spacingXSmall),
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXSmall,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing:
            message.isRead
                ? null
                : Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
        onTap: () {
          if (!message.isRead) {
            ref
                .read(messageProvider.notifier)
                .markSystemMessageAsRead(message.id);
          }

          // 如果有操作路由，则导航到指定页面
          if (message.actionRoute != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('导航到: ${message.actionRoute}')),
            );
          }
        },
      ),
    );
  }

  /// 构建聊天消息项
  Widget _buildChatMessageItem(ChatMessageModel message) {
    final theme = Theme.of(context);

    // 格式化日期时间
    final now = DateTime.now();
    final difference = now.difference(message.timestamp);
    String formattedTime;

    if (difference.inDays > 0) {
      formattedTime = '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      formattedTime = '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      formattedTime = '${difference.inMinutes}分钟前';
    } else {
      formattedTime = '刚刚';
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor, width: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(DesignTokens.spacingMedium),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade300,
          child: Text(
            message.senderName.substring(0, 1),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(bottom: DesignTokens.spacingXSmall),
          child: Text(
            message.senderName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: DesignTokens.fontSizeMedium,
            ),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeSmall,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: DesignTokens.spacingXSmall),
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXSmall,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing:
            message.unreadCount > 0
                ? Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingSmall,
                    vertical: DesignTokens.spacingXXSmall,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message.unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : null,
        onTap: () {
          if (!message.isRead) {
            ref
                .read(messageProvider.notifier)
                .markChatMessageAsRead(message.id);
          }
          // 导航到聊天详情页面
          AppRouter.navigateTo(context, AppRouter.chat, arguments: message.id);
        },
      ),
    );
  }
}
