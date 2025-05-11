import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';

/// 消息类型选项
enum MessageTabOption {
  /// 系统通知
  system,

  /// 聊天消息
  chat,
}

/// 消息状态
class MessageState {
  final List<SystemMessageModel> systemMessages;
  final List<ChatMessageModel> chatMessages;
  final MessageTabOption selectedTab;
  final bool isLoading;
  final String? error;

  const MessageState({
    this.systemMessages = const [],
    this.chatMessages = const [],
    this.selectedTab = MessageTabOption.system,
    this.isLoading = false,
    this.error,
  });

  /// 创建加载状态
  MessageState copyWithLoading() {
    return MessageState(
      systemMessages: systemMessages,
      chatMessages: chatMessages,
      selectedTab: selectedTab,
      isLoading: true,
      error: null,
    );
  }

  /// 创建错误状态
  MessageState copyWithError(String errorMessage) {
    return MessageState(
      systemMessages: systemMessages,
      chatMessages: chatMessages,
      selectedTab: selectedTab,
      isLoading: false,
      error: errorMessage,
    );
  }

  /// 更新消息列表
  MessageState copyWithMessages({
    List<SystemMessageModel>? systemMessages,
    List<ChatMessageModel>? chatMessages,
  }) {
    return MessageState(
      systemMessages: systemMessages ?? this.systemMessages,
      chatMessages: chatMessages ?? this.chatMessages,
      selectedTab: selectedTab,
      isLoading: false,
      error: null,
    );
  }

  /// 更新选中的标签
  MessageState copyWithSelectedTab(MessageTabOption tab) {
    return MessageState(
      systemMessages: systemMessages,
      chatMessages: chatMessages,
      selectedTab: tab,
      isLoading: isLoading,
      error: error,
    );
  }

  /// 将系统消息标记为已读
  MessageState markSystemMessageAsRead(String messageId) {
    final updatedMessages =
        systemMessages.map((message) {
          if (message.id == messageId && !message.isRead) {
            return message.markAsRead();
          }
          return message;
        }).toList();

    return copyWithMessages(systemMessages: updatedMessages);
  }

  /// 将聊天消息标记为已读
  MessageState markChatMessageAsRead(String messageId) {
    final updatedMessages =
        chatMessages.map((message) {
          if (message.id == messageId && !message.isRead) {
            return message.markAsRead();
          }
          return message;
        }).toList();

    return copyWithMessages(chatMessages: updatedMessages);
  }

  /// 获取未读系统消息数量
  int get unreadSystemMessageCount {
    return systemMessages.where((message) => !message.isRead).length;
  }

  /// 获取未读聊天消息数量
  int get unreadChatMessageCount {
    return chatMessages.fold<int>(
      0,
      (sum, message) => sum + (message.isRead ? 0 : message.unreadCount),
    );
  }

  /// 获取总未读消息数量
  int get totalUnreadCount {
    return unreadSystemMessageCount + unreadChatMessageCount;
  }
}

/// 消息状态提供者
class MessageNotifier extends StateNotifier<MessageState> {
  MessageNotifier() : super(const MessageState());

  /// 加载消息
  Future<void> loadMessages() async {
    state = state.copyWithLoading();

    try {
      // 模拟网络请求延迟
      await Future.delayed(const Duration(seconds: 1));

      // 获取模拟数据
      final systemMessages = _getMockSystemMessages();
      final chatMessages = _getMockChatMessages();

      state = state.copyWithMessages(
        systemMessages: systemMessages,
        chatMessages: chatMessages,
      );
    } catch (e) {
      state = state.copyWithError('加载消息失败: ${e.toString()}');
    }
  }

  /// 切换消息类型标签
  void selectTab(MessageTabOption tab) {
    state = state.copyWithSelectedTab(tab);
  }

  /// 将系统消息标记为已读
  void markSystemMessageAsRead(String messageId) {
    state = state.markSystemMessageAsRead(messageId);
  }

  /// 将聊天消息标记为已读
  void markChatMessageAsRead(String messageId) {
    state = state.markChatMessageAsRead(messageId);
  }

  /// 获取模拟系统消息
  List<SystemMessageModel> _getMockSystemMessages() {
    final now = DateTime.now();
    return [
      SystemMessageModel(
        id: '1',
        timestamp: now.subtract(const Duration(hours: 2)),
        title: '租金缴纳提醒',
        content: '您的房租将于3天后到期，请及时缴纳。',
        iconName: 'bell',
        actionText: '立即支付',
        actionRoute: '/payment',
      ),
      SystemMessageModel(
        id: '2',
        timestamp: now.subtract(const Duration(days: 1, hours: 8, minutes: 30)),
        title: '看房申请已通过',
        content: '您申请看望的房源"精装修一居室"已通过房东审核，请准时前往。',
        iconName: 'check-circle',
      ),
      SystemMessageModel(
        id: '3',
        timestamp: now.subtract(const Duration(days: 2)),
        title: '新房源上线通知',
        content: '您关注的区域有3套新房源上线，快去看看吧！',
        iconName: 'home',
      ),
    ];
  }

  /// 获取模拟聊天消息
  List<ChatMessageModel> _getMockChatMessages() {
    final now = DateTime.now();
    return [
      ChatMessageModel(
        id: '1',
        timestamp: now.subtract(const Duration(minutes: 15)),
        senderId: 'landlord1',
        receiverId: 'user1',
        senderName: '王房东（精装修一居室）',
        senderAvatar: 'assets/images/avatar_placeholder.png',
        content: '可以的，我在房子等您，地址是朝阳区望京SOHO T1，到了小区门口给我打电话。',
        relatedHouseId: '1',
        relatedHouseTitle: '精装修一居室',
        unreadCount: 1,
      ),
      ChatMessageModel(
        id: '2',
        timestamp: now.subtract(const Duration(days: 2, hours: 5)),
        senderId: 'landlord2',
        receiverId: 'user1',
        senderName: '李房东（阳光花园）',
        senderAvatar: 'assets/images/avatar_placeholder.png',
        content: '您好，请问对我们的两居室还感兴趣吗？',
        relatedHouseId: '2',
        relatedHouseTitle: '阳光花园 两居室',
        unreadCount: 1,
      ),
      ChatMessageModel(
        id: '3',
        timestamp: now.subtract(const Duration(days: 5)),
        senderId: 'landlord3',
        receiverId: 'user1',
        senderName: '张房东（银河SOHO）',
        senderAvatar: 'assets/images/avatar_placeholder.png',
        content: '已经给您降了200元，希望您能考虑一下。',
        relatedHouseId: '3',
        relatedHouseTitle: '合租·银河SOHO 3居室',
      ),
    ];
  }
}

/// 消息状态提供者
final messageProvider = StateNotifierProvider<MessageNotifier, MessageState>((
  ref,
) {
  return MessageNotifier();
});
