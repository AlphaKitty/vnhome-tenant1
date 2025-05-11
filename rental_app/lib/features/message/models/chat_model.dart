/// 聊天消息项模型
class ChatItemModel {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isSentByMe;

  const ChatItemModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.isSentByMe,
  });

  /// 从JSON创建聊天项
  factory ChatItemModel.fromJson(
    Map<String, dynamic> json,
    String currentUserId,
  ) {
    final senderId = json['senderId'] as String;
    return ChatItemModel(
      id: json['id'] as String,
      senderId: senderId,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isSentByMe: senderId == currentUserId,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// 聊天会话模型
class ChatSessionModel {
  final String id;
  final String targetUserId;
  final String targetUserName;
  final String targetUserAvatar;
  final String? relatedHouseId;
  final String? relatedHouseTitle;
  final List<ChatItemModel> chatItems;
  final DateTime lastUpdated;

  const ChatSessionModel({
    required this.id,
    required this.targetUserId,
    required this.targetUserName,
    required this.targetUserAvatar,
    this.relatedHouseId,
    this.relatedHouseTitle,
    this.chatItems = const [],
    required this.lastUpdated,
  });

  /// 从JSON创建聊天会话
  factory ChatSessionModel.fromJson(
    Map<String, dynamic> json,
    String currentUserId,
  ) {
    return ChatSessionModel(
      id: json['id'] as String,
      targetUserId: json['targetUserId'] as String,
      targetUserName: json['targetUserName'] as String,
      targetUserAvatar: json['targetUserAvatar'] as String,
      relatedHouseId: json['relatedHouseId'] as String?,
      relatedHouseTitle: json['relatedHouseTitle'] as String?,
      chatItems:
          (json['chatItems'] as List<dynamic>?)
              ?.map(
                (e) => ChatItemModel.fromJson(
                  e as Map<String, dynamic>,
                  currentUserId,
                ),
              )
              .toList() ??
          const [],
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'targetUserId': targetUserId,
      'targetUserName': targetUserName,
      'targetUserAvatar': targetUserAvatar,
      'relatedHouseId': relatedHouseId,
      'relatedHouseTitle': relatedHouseTitle,
      'chatItems': chatItems.map((e) => e.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// 添加新消息
  ChatSessionModel addMessage(ChatItemModel message) {
    return ChatSessionModel(
      id: id,
      targetUserId: targetUserId,
      targetUserName: targetUserName,
      targetUserAvatar: targetUserAvatar,
      relatedHouseId: relatedHouseId,
      relatedHouseTitle: relatedHouseTitle,
      chatItems: [...chatItems, message],
      lastUpdated: DateTime.now(),
    );
  }

  /// 获取最后一条消息
  ChatItemModel? get lastMessage {
    if (chatItems.isEmpty) return null;
    return chatItems.last;
  }

  /// 获取未读消息数量
  int getUnreadCount(String currentUserId) {
    return chatItems.where((e) => e.senderId != currentUserId).length;
  }
}
