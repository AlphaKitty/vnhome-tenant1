/// 报修类型枚举
enum RepairType {
  /// 水暖问题
  plumbing,

  /// 电路问题
  electrical,

  /// 门锁问题
  lock,

  /// 空调问题
  airConditioner,

  /// 网络问题
  network,

  /// 其他问题
  other,
}

/// 报修状态枚举
enum RepairStatus {
  /// 待处理
  pending,

  /// 处理中
  processing,

  /// 已完成
  completed,

  /// 已取消
  cancelled,
}

/// 报修记录模型
class RepairModel {
  final String id;
  final String houseId;
  final String houseName;
  final String description;
  final RepairType type;
  final RepairStatus status;
  final DateTime submitTime;
  final DateTime? expectedTime;
  final List<String> imageUrls;
  final String? remark;

  const RepairModel({
    required this.id,
    required this.houseId,
    required this.houseName,
    required this.description,
    required this.type,
    required this.status,
    required this.submitTime,
    this.expectedTime,
    this.imageUrls = const [],
    this.remark,
  });

  /// 从JSON映射创建报修记录模型
  factory RepairModel.fromJson(Map<String, dynamic> json) {
    return RepairModel(
      id: json['id'] as String,
      houseId: json['houseId'] as String,
      houseName: json['houseName'] as String,
      description: json['description'] as String,
      type: _parseRepairType(json['type'] as String),
      status: _parseRepairStatus(json['status'] as String),
      submitTime: DateTime.parse(json['submitTime'] as String),
      expectedTime:
          json['expectedTime'] != null
              ? DateTime.parse(json['expectedTime'] as String)
              : null,
      imageUrls:
          (json['imageUrls'] as List?)?.map((e) => e as String).toList() ?? [],
      remark: json['remark'] as String?,
    );
  }

  /// 解析报修类型
  static RepairType _parseRepairType(String typeStr) {
    switch (typeStr) {
      case 'plumbing':
        return RepairType.plumbing;
      case 'electrical':
        return RepairType.electrical;
      case 'lock':
        return RepairType.lock;
      case 'airConditioner':
        return RepairType.airConditioner;
      case 'network':
        return RepairType.network;
      case 'other':
      default:
        return RepairType.other;
    }
  }

  /// 解析报修状态
  static RepairStatus _parseRepairStatus(String statusStr) {
    switch (statusStr) {
      case 'pending':
        return RepairStatus.pending;
      case 'processing':
        return RepairStatus.processing;
      case 'completed':
        return RepairStatus.completed;
      case 'cancelled':
        return RepairStatus.cancelled;
      default:
        return RepairStatus.pending;
    }
  }

  /// 转换为JSON映射
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'houseId': houseId,
      'houseName': houseName,
      'description': description,
      'type': _repairTypeToString(type),
      'status': _repairStatusToString(status),
      'submitTime': submitTime.toIso8601String(),
      'expectedTime': expectedTime?.toIso8601String(),
      'imageUrls': imageUrls,
      'remark': remark,
    };
  }

  /// 将报修类型转换为字符串
  static String _repairTypeToString(RepairType type) {
    switch (type) {
      case RepairType.plumbing:
        return 'plumbing';
      case RepairType.electrical:
        return 'electrical';
      case RepairType.lock:
        return 'lock';
      case RepairType.airConditioner:
        return 'airConditioner';
      case RepairType.network:
        return 'network';
      case RepairType.other:
        return 'other';
    }
  }

  /// 将报修状态转换为字符串
  static String _repairStatusToString(RepairStatus status) {
    switch (status) {
      case RepairStatus.pending:
        return 'pending';
      case RepairStatus.processing:
        return 'processing';
      case RepairStatus.completed:
        return 'completed';
      case RepairStatus.cancelled:
        return 'cancelled';
    }
  }

  /// 创建一个报修记录副本
  RepairModel copyWith({
    String? id,
    String? houseId,
    String? houseName,
    String? description,
    RepairType? type,
    RepairStatus? status,
    DateTime? submitTime,
    DateTime? expectedTime,
    List<String>? imageUrls,
    String? remark,
  }) {
    return RepairModel(
      id: id ?? this.id,
      houseId: houseId ?? this.houseId,
      houseName: houseName ?? this.houseName,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      submitTime: submitTime ?? this.submitTime,
      expectedTime: expectedTime ?? this.expectedTime,
      imageUrls: imageUrls ?? this.imageUrls,
      remark: remark ?? this.remark,
    );
  }
}
