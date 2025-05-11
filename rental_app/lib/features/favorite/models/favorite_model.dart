import 'package:rental_app/features/house/models/house_model.dart';

/// 收藏记录类型枚举
enum FavoriteRecordType {
  /// 收藏房源
  favorite,

  /// 浏览记录
  history,
}

/// 收藏/浏览记录模型
class FavoriteRecordModel {
  final String id;
  final String houseId;
  final DateTime timestamp;
  final FavoriteRecordType type;
  final HouseModel house;

  const FavoriteRecordModel({
    required this.id,
    required this.houseId,
    required this.timestamp,
    required this.type,
    required this.house,
  });

  /// 从JSON映射创建记录模型
  factory FavoriteRecordModel.fromJson(
    Map<String, dynamic> json,
    HouseModel house,
  ) {
    return FavoriteRecordModel(
      id: json['id'] as String,
      houseId: json['houseId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type:
          json['type'] == 'favorite'
              ? FavoriteRecordType.favorite
              : FavoriteRecordType.history,
      house: house,
    );
  }

  /// 转换为JSON映射
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'houseId': houseId,
      'timestamp': timestamp.toIso8601String(),
      'type': type == FavoriteRecordType.favorite ? 'favorite' : 'history',
    };
  }

  /// 创建记录副本
  FavoriteRecordModel copyWith({
    String? id,
    String? houseId,
    DateTime? timestamp,
    FavoriteRecordType? type,
    HouseModel? house,
  }) {
    return FavoriteRecordModel(
      id: id ?? this.id,
      houseId: houseId ?? this.houseId,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      house: house ?? this.house,
    );
  }

  /// 创建一个更新时间的副本
  FavoriteRecordModel withUpdatedTimestamp() {
    return copyWith(timestamp: DateTime.now());
  }
}
