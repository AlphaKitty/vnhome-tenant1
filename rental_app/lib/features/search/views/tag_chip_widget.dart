import 'package:flutter/material.dart';
import 'package:rental_app/core/design_tokens.dart';

/// 标签选择组件
class TagChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TagChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMedium,
          vertical: DesignTokens.spacingXSmall,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeSmall,
            color: isSelected ? Colors.white : theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
