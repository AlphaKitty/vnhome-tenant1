import 'package:flutter/material.dart';
import 'package:rental_app/core/design_tokens.dart';

/// 个人中心菜单项小部件
class ProfileMenuItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const ProfileMenuItemWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: DesignTokens.spacingMedium,
          horizontal: DesignTokens.spacingMedium,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            SizedBox(width: DesignTokens.spacingMedium),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeMedium,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}
