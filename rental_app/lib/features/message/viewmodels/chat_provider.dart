import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_model.dart';

/// 聊天状态
class ChatState {
  final ChatSessionModel? chatSession;
  final bool isLoading;
  final String? error;
  final bool isSending;

  const ChatState({
    this.chatSession,
    this.isLoading = false,
    this.error,
    this.isSending = false,
  });

  /// 创建加载状态
  ChatState copyWithLoading() {
    return ChatState(
      chatSession: chatSession,
      isLoading: true,
      error: null,
      isSending: isSending,
    );
  }

  /// 创建发送中状态
  ChatState copyWithSending() {
    return ChatState(
      chatSession: chatSession,
      isLoading: isLoading,
      error: null,
      isSending: true,
    );
  }

  /// 创建错误状态
  ChatState copyWithError(String errorMessage) {
    return ChatState(
      chatSession: chatSession,
      isLoading: false,
      error: errorMessage,
      isSending: false,
    );
  }

  /// 更新聊天会话
  ChatState copyWithChatSession(ChatSessionModel session) {
    return ChatState(
      chatSession: session,
      isLoading: false,
      error: null,
      isSending: false,
    );
  }
}

/// 聊天状态管理者
class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState());

  /// 当前用户ID（模拟）
  final String _currentUserId = 'user1';

  /// 加载聊天会话
  Future<void> loadChatSession(String chatId) async {
    state = state.copyWithLoading();

    try {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));

      // 获取模拟数据
      final chatSession = _getMockChatSession(chatId);

      state = state.copyWithChatSession(chatSession);
    } catch (e) {
      state = state.copyWithError('加载聊天失败: ${e.toString()}');
    }
  }

  /// 发送消息
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || state.chatSession == null) return;

    state = state.copyWithSending();

    try {
      // 模拟网络请求
      await Future.delayed(const Duration(milliseconds: 500));

      // 创建新消息
      final newMessage = ChatItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _currentUserId,
        content: content,
        timestamp: DateTime.now(),
        isSentByMe: true,
      );

      // 添加消息到会话
      final updatedSession = state.chatSession!.addMessage(newMessage);

      state = state.copyWithChatSession(updatedSession);
    } catch (e) {
      state = state.copyWithError('发送消息失败: ${e.toString()}');
    }
  }

  /// 获取模拟聊天会话数据
  ChatSessionModel _getMockChatSession(String chatId) {
    final now = DateTime.now();

    switch (chatId) {
      case '1':
        return ChatSessionModel(
          id: '1',
          targetUserId: 'landlord1',
          targetUserName: '王房东（精装修一居室）',
          targetUserAvatar: 'assets/images/avatar_placeholder.png',
          relatedHouseId: '1',
          relatedHouseTitle: '精装修一居室',
          chatItems: [
            ChatItemModel(
              id: '1',
              senderId: 'landlord1',
              content: '您好，看到您对我的房源感兴趣，有什么问题可以问我。',
              timestamp: now.subtract(
                const Duration(days: 1, hours: 14, minutes: 30),
              ),
              isSentByMe: false,
            ),
            ChatItemModel(
              id: '2',
              senderId: _currentUserId,
              content: '您好，请问这个房源可以养宠物吗？',
              timestamp: now.subtract(
                const Duration(days: 1, hours: 14, minutes: 25),
              ),
              isSentByMe: true,
            ),
            ChatItemModel(
              id: '3',
              senderId: 'landlord1',
              content: '是可以的，但希望是小型宠物，比如猫咪或小型犬。',
              timestamp: now.subtract(
                const Duration(days: 1, hours: 14, minutes: 22),
              ),
              isSentByMe: false,
            ),
            ChatItemModel(
              id: '4',
              senderId: _currentUserId,
              content: '好的，没问题，我养的是一只小猫。请问最早什么时候可以看房？',
              timestamp: now.subtract(
                const Duration(days: 1, hours: 14, minutes: 20),
              ),
              isSentByMe: true,
            ),
            ChatItemModel(
              id: '5',
              senderId: 'landlord1',
              content: '今天下午或者明天上午都可以，您方便哪个时间？',
              timestamp: now.subtract(
                const Duration(days: 1, hours: 14, minutes: 15),
              ),
              isSentByMe: false,
            ),
            ChatItemModel(
              id: '6',
              senderId: _currentUserId,
              content: '今天下午3点可以吗？',
              timestamp: now.subtract(const Duration(hours: 8, minutes: 45)),
              isSentByMe: true,
            ),
            ChatItemModel(
              id: '7',
              senderId: 'landlord1',
              content: '可以的，我在房子等您，地址是朝阳区望京SOHO T1，到了小区门口给我打电话。',
              timestamp: now.subtract(const Duration(hours: 8, minutes: 40)),
              isSentByMe: false,
            ),
          ],
          lastUpdated: now.subtract(const Duration(hours: 8, minutes: 40)),
        );
      case '2':
        return ChatSessionModel(
          id: '2',
          targetUserId: 'landlord2',
          targetUserName: '李房东（阳光花园）',
          targetUserAvatar: 'assets/images/avatar_placeholder.png',
          relatedHouseId: '2',
          relatedHouseTitle: '阳光花园 两居室',
          chatItems: [
            ChatItemModel(
              id: '1',
              senderId: 'landlord2',
              content: '您好，感谢您对我们的房源感兴趣！',
              timestamp: now.subtract(const Duration(days: 2, hours: 16)),
              isSentByMe: false,
            ),
            ChatItemModel(
              id: '2',
              senderId: _currentUserId,
              content: '您好，我想了解一下这个小区的周边设施情况',
              timestamp: now.subtract(
                const Duration(days: 2, hours: 15, minutes: 50),
              ),
              isSentByMe: true,
            ),
            ChatItemModel(
              id: '3',
              senderId: 'landlord2',
              content: '小区周边200米内有超市、菜市场，500米内有三家银行，交通也很便利，距离地铁站只需步行8分钟。',
              timestamp: now.subtract(
                const Duration(days: 2, hours: 15, minutes: 45),
              ),
              isSentByMe: false,
            ),
            ChatItemModel(
              id: '4',
              senderId: _currentUserId,
              content: '听起来不错，谢谢您的介绍！我再考虑考虑。',
              timestamp: now.subtract(
                const Duration(days: 2, hours: 15, minutes: 40),
              ),
              isSentByMe: true,
            ),
            ChatItemModel(
              id: '5',
              senderId: 'landlord2',
              content: '您好，请问对我们的两居室还感兴趣吗？',
              timestamp: now.subtract(const Duration(days: 2, hours: 5)),
              isSentByMe: false,
            ),
          ],
          lastUpdated: now.subtract(const Duration(days: 2, hours: 5)),
        );
      case '3':
        return ChatSessionModel(
          id: '3',
          targetUserId: 'landlord3',
          targetUserName: '张房东（银河SOHO）',
          targetUserAvatar: 'assets/images/avatar_placeholder.png',
          relatedHouseId: '3',
          relatedHouseTitle: '合租·银河SOHO 3居室',
          chatItems: [
            ChatItemModel(
              id: '1',
              senderId: 'landlord3',
              content: '您好，这是银河SOHO的合租房源，您可以看一下。',
              timestamp: now.subtract(const Duration(days: 7)),
              isSentByMe: false,
            ),
            ChatItemModel(
              id: '2',
              senderId: _currentUserId,
              content: '您好，这个价格能再优惠一点吗？',
              timestamp: now.subtract(const Duration(days: 6, hours: 12)),
              isSentByMe: true,
            ),
            ChatItemModel(
              id: '3',
              senderId: 'landlord3',
              content: '已经给您降了200元，希望您能考虑一下。',
              timestamp: now.subtract(const Duration(days: 5)),
              isSentByMe: false,
            ),
          ],
          lastUpdated: now.subtract(const Duration(days: 5)),
        );
      default:
        throw Exception('找不到聊天记录');
    }
  }
}

/// 聊天状态提供者
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});
