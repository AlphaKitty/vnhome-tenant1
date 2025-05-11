import 'package:flutter/material.dart';
import 'package:rental_app/core/design_tokens.dart';

/// 个人中心统计项小部件
class ProfileStatItemWidget extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;
  final bool showBorder;

  const ProfileStatItemWidget({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingMedium),
        decoration: BoxDecoration(
          border:
              showBorder
                  ? Border(
                    left: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  )
                  : null,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: DesignTokens.fontSizeLarge,
              ),
            ),
            SizedBox(height: DesignTokens.spacingXXSmall),
            Text(
              title,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXSmall,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
