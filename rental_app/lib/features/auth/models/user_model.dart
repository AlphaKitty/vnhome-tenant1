/// 用户模型类
class UserModel {
  final String id;
  final String username;
  final String? phoneNumber;
  final String? avatar;
  final String? email;

  UserModel({
    required this.id,
    required this.username,
    this.phoneNumber,
    this.avatar,
    this.email,
  });

  /// 从JSON映射创建用户模型
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      avatar: json['avatar'] as String?,
      email: json['email'] as String?,
    );
  }

  /// 转换为JSON映射
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
      'email': email,
    };
  }

  /// 创建用户模型的副本
  UserModel copyWith({
    String? id,
    String? username,
    String? phoneNumber,
    String? avatar,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
    );
  }
}
