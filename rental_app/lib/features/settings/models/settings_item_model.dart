import 'package:flutter/material.dart';

/// 设置项模型
class SettingsItemModel {
  final String id;
  final String title;
  final IconData icon;
  final String? route;
  final Function? onTap;
  final Widget? trailing;

  SettingsItemModel({
    required this.id,
    required this.title,
    required this.icon,
    this.route,
    this.onTap,
    this.trailing,
  });
}

/// 设置分组模型
class SettingsGroupModel {
  final String id;
  final String title;
  final List<SettingsItemModel> items;

  SettingsGroupModel({
    required this.id,
    required this.title,
    required this.items,
  });
}
