import 'package:flutter/material.dart';
import 'package:rental_app/core/design_tokens.dart';
import '../models/settings_item_model.dart';
import 'settings_item_widget.dart';

/// 设置分组组件
class SettingsGroupWidget extends StatelessWidget {
  final String title;
  final List<SettingsItemModel> items;

  const SettingsGroupWidget({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 分组标题
        Padding(
          padding: EdgeInsets.only(
            left: DesignTokens.spacingMedium,
            top: DesignTokens.spacingMedium,
            bottom: DesignTokens.spacingSmall,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeSmall,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
        ),

        // 分组卡片
        Card(
          margin: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMedium,
            vertical: DesignTokens.spacingSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          ),
          elevation: 0,
          child: Column(children: _buildSettingsItems(items)),
        ),
      ],
    );
  }

  /// 构建设置项列表
  List<Widget> _buildSettingsItems(List<SettingsItemModel> items) {
    final result = <Widget>[];

    for (var i = 0; i < items.length; i++) {
      final item = items[i];

      // 添加设置项
      result.add(
        SettingsItemWidget(
          title: item.title,
          icon: item.icon,
          onTap: item.onTap != null ? () => item.onTap!() : null,
          trailing: item.trailing,
        ),
      );

      // 除了最后一项外，添加分隔线
      if (i < items.length - 1) {
        result.add(
          Divider(
            height: 1,
            indent: DesignTokens.spacingXLarge,
            endIndent: DesignTokens.spacingMedium,
          ),
        );
      }
    }

    return result;
  }
}
