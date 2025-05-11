import 'package:flutter/material.dart';
import 'package:rental_app/core/design_tokens.dart';

/// 设置页面头部组件
class SettingsHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;

  const SettingsHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(DesignTokens.spacingLarge),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      child: Row(
        children: [
          // 图标
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor ?? theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(width: DesignTokens.spacingMedium),

          // 标题和副标题
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: DesignTokens.spacingXSmall),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeSmall,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
