/// 个人中心统计数据模型
class ProfileStatModel {
  final String id;
  final String title;
  final String value;
  final String? route;

  ProfileStatModel({
    required this.id,
    required this.title,
    required this.value,
    this.route,
  });
}
