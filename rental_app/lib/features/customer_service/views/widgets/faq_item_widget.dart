import 'package:flutter/material.dart';
import 'package:rental_app/core/design_tokens.dart';
import '../../models/support_item_model.dart';

/// 常见问题项组件
class FaqItemWidget extends StatelessWidget {
  final FaqItemModel faq;
  final Function(String, bool) onExpansionChanged;

  const FaqItemWidget({
    super.key,
    required this.faq,
    required this.onExpansionChanged,
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
      child: ExpansionTile(
        initiallyExpanded: faq.isExpanded,
        onExpansionChanged: (expanded) {
          onExpansionChanged(faq.id, expanded);
        },
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:
                faq.isExpanded
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'Q',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMedium,
                fontWeight: FontWeight.bold,
                color:
                    faq.isExpanded
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        title: Text(
          faq.question,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: DesignTokens.spacingXLarge,
              right: DesignTokens.spacingMedium,
              bottom: DesignTokens.spacingMedium,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: DesignTokens.spacingSmall),
                Expanded(
                  child: Text(
                    faq.answer,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeSmall,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
