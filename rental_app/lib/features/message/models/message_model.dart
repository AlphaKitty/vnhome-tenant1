/// 消息类型枚举
enum MessageType {
  /// 系统通知
  system,

  /// 聊天消息
  chat,
}

/// 消息基础模型
abstract class BaseMessageModel {
  final String id;
  final DateTime timestamp;
  final bool isRead;
  final MessageType type;

  const BaseMessageModel({
    required this.id,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

/// 系统消息模型
class SystemMessageModel extends BaseMessageModel {
  final String title;
  final String content;
  final String? iconName;
  final String? actionText;
  final String? actionRoute;

  const SystemMessageModel({
    required super.id,
    required super.timestamp,
    required this.title,
    required this.content,
    this.iconName,
    this.actionText,
    this.actionRoute,
    super.isRead = false,
  }) : super(type: MessageType.system);

  /// 从JSON创建系统消息模型
  factory SystemMessageModel.fromJson(Map<String, dynamic> json) {
    return SystemMessageModel(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      title: json['title'] as String,
      content: json['content'] as String,
      iconName: json['iconName'] as String?,
      actionText: json['actionText'] as String?,
      actionRoute: json['actionRoute'] as String?,
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': 'system',
      'title': title,
      'content': content,
      'iconName': iconName,
      'actionText': actionText,
      'actionRoute': actionRoute,
      'isRead': isRead,
    };
  }

  /// 创建已读状态的消息副本
  SystemMessageModel markAsRead() {
    return SystemMessageModel(
      id: id,
      timestamp: timestamp,
      title: title,
      content: content,
      iconName: iconName,
      actionText: actionText,
      actionRoute: actionRoute,
      isRead: true,
    );
  }
}

/// 聊天消息模型
class ChatMessageModel extends BaseMessageModel {
  final String senderId;
  final String receiverId;
  final String senderName;
  final String senderAvatar;
  final String content;
  final String? relatedHouseId;
  final String? relatedHouseTitle;
  final int unreadCount;

  const ChatMessageModel({
    required super.id,
    required super.timestamp,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    this.relatedHouseId,
    this.relatedHouseTitle,
    this.unreadCount = 0,
    super.isRead = false,
  }) : super(type: MessageType.chat);

  /// 从JSON创建聊天消息模型
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String,
      content: json['content'] as String,
      relatedHouseId: json['relatedHouseId'] as String?,
      relatedHouseTitle: json['relatedHouseTitle'] as String?,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': 'chat',
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'content': content,
      'relatedHouseId': relatedHouseId,
      'relatedHouseTitle': relatedHouseTitle,
      'unreadCount': unreadCount,
      'isRead': isRead,
    };
  }

  /// 创建已读状态的消息副本
  ChatMessageModel markAsRead() {
    return ChatMessageModel(
      id: id,
      timestamp: timestamp,
      senderId: senderId,
      receiverId: receiverId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      content: content,
      relatedHouseId: relatedHouseId,
      relatedHouseTitle: relatedHouseTitle,
      unreadCount: 0,
      isRead: true,
    );
  }

  /// 更新未读消息数量
  ChatMessageModel updateUnreadCount(int count) {
    return ChatMessageModel(
      id: id,
      timestamp: timestamp,
      senderId: senderId,
      receiverId: receiverId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      content: content,
      relatedHouseId: relatedHouseId,
      relatedHouseTitle: relatedHouseTitle,
      unreadCount: count,
      isRead: isRead,
    );
  }
}
