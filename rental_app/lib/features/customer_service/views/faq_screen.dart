import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import '../viewmodels/customer_service_provider.dart';
import 'widgets/faq_item_widget.dart';

/// 常见问题页面
class FaqScreen extends ConsumerWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customerServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('常见问题'), elevation: 0),
      body:
          state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.error != null
              ? _buildErrorWidget(context, state.error!, ref)
              : _buildContent(context, state, ref),
    );
  }

  /// 构建内容
  Widget _buildContent(
    BuildContext context,
    CustomerServiceState state,
    WidgetRef ref,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部提示
          Container(
            margin: EdgeInsets.all(DesignTokens.spacingMedium),
            padding: EdgeInsets.all(DesignTokens.spacingMedium),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: DesignTokens.spacingSmall),
                Expanded(
                  child: Text(
                    '以下是我们整理的常见问题，如果没有找到您需要的答案，请直接联系客服',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: DesignTokens.fontSizeSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: DesignTokens.spacingSmall),

          // 常见问题列表
          ...state.faqItems.map((faq) {
            return FaqItemWidget(
              faq: faq,
              onExpansionChanged: (id, expanded) {
                ref
                    .read(customerServiceProvider.notifier)
                    .toggleFaqExpansion(id, expanded);
              },
            );
          }).toList(),

          SizedBox(height: DesignTokens.spacingLarge),

          // 底部联系客服提示
          Center(
            child: Padding(
              padding: EdgeInsets.all(DesignTokens.spacingMedium),
              child: Column(
                children: [
                  Text(
                    '没有找到您想要的答案？',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeSmall,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: DesignTokens.spacingSmall),
                  ElevatedButton.icon(
                    onPressed: () {
                      // 跳转到联系客服页面
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.support_agent),
                    label: const Text('联系客服'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建错误提示
  Widget _buildErrorWidget(BuildContext context, String error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: DesignTokens.errorColor,
            size: 48,
          ),
          SizedBox(height: DesignTokens.spacingMedium),
          Text(error),
          SizedBox(height: DesignTokens.spacingLarge),
          ElevatedButton(
            onPressed: () {
              ref.read(customerServiceProvider.notifier).loadData();
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}
