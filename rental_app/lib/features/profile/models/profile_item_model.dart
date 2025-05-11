import 'package:flutter/material.dart';

/// 个人中心菜单项模型
class ProfileItemModel {
  final String id;
  final String title;
  final IconData icon;
  final String? route;
  final Function? onTap;

  ProfileItemModel({
    required this.id,
    required this.title,
    required this.icon,
    this.route,
    this.onTap,
  });
}
