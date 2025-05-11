import 'package:flutter/material.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';

/// 客服支持项目组件
class SupportItemWidget extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final VoidCallback? onTap;

  const SupportItemWidget({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: DesignTokens.spacingSmall,
        horizontal: DesignTokens.spacingMedium,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spacingMedium),
          child: Row(
            children: [
              // 图标
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    DesignTokens.radiusMedium,
                  ),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
              SizedBox(width: DesignTokens.spacingMedium),

              // 标题和描述
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (description != null) ...[
                      SizedBox(height: 4),
                      Text(
                        description!,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSmall,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // 箭头
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
