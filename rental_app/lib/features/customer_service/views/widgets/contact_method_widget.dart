import 'package:flutter/material.dart';
import 'package:rental_app/core/design_tokens.dart';
import '../../models/support_item_model.dart';

/// 联系方式组件
class ContactMethodWidget extends StatelessWidget {
  final ContactMethodModel contact;

  const ContactMethodWidget({super.key, required this.contact});

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
        onTap: contact.onTap != null ? () => contact.onTap!() : null,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spacingMedium),
          child: Row(
            children: [
              // 图标
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    DesignTokens.radiusMedium,
                  ),
                ),
                child: Icon(
                  contact.icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: DesignTokens.spacingMedium),

              // 标题和值
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.title,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeSmall,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      contact.value,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeMedium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // 操作按钮
              if (contact.onTap != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(
                      DesignTokens.radiusSmall,
                    ),
                  ),
                  child: const Text(
                    '复制',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
