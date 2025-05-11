import 'package:flutter/material.dart';
import 'package:rental_app/core/design_tokens.dart';
import '../models/settings_item_model.dart';

/// 设置项组件
class SettingsItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SettingsItemWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacingMedium),
        child: Row(
          children: [
            // 图标
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
            ),
            SizedBox(width: DesignTokens.spacingMedium),

            // 标题
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // 尾部组件（箭头或开关）
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
          ],
        ),
      ),
    );
  }
}
