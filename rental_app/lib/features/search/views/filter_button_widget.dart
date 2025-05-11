import 'package:flutter/material.dart';
import 'package:rental_app/core/design_tokens.dart';

/// 筛选按钮组件
class FilterButtonWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showBorder;

  const FilterButtonWidget({
    super.key,
    required this.title,
    this.isSelected = false,
    required this.onTap,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingSmall),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  isSelected ? theme.colorScheme.primary : theme.dividerColor,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
            color:
                isSelected
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : theme.cardColor,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeSmall,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color:
                  isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
