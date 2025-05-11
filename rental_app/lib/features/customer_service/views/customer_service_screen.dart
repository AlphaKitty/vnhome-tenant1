import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';
import '../viewmodels/customer_service_provider.dart';
import 'widgets/support_item_widget.dart';
import 'widgets/faq_item_widget.dart';
import 'widgets/contact_method_widget.dart';

/// 客服中心主屏幕
class CustomerServiceScreen extends ConsumerWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customerServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('客服中心'), elevation: 0),
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
          // 顶部客服按钮组
          _buildSupportItems(context, state, ref),
          SizedBox(height: DesignTokens.spacingMedium),

          // 联系方式
          Padding(
            padding: EdgeInsets.only(
              left: DesignTokens.spacingLarge,
              top: DesignTokens.spacingMedium,
              bottom: DesignTokens.spacingSmall,
            ),
            child: Text(
              '联系方式',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildContactMethods(context, state),
          SizedBox(height: DesignTokens.spacingMedium),

          // 常见问题
          Padding(
            padding: EdgeInsets.only(
              left: DesignTokens.spacingLarge,
              top: DesignTokens.spacingMedium,
              bottom: DesignTokens.spacingSmall,
            ),
            child: Text(
              '常见问题',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildFaqItems(context, state, ref),
          SizedBox(height: DesignTokens.spacingLarge),
        ],
      ),
    );
  }

  /// 构建支持项目
  Widget _buildSupportItems(
    BuildContext context,
    CustomerServiceState state,
    WidgetRef ref,
  ) {
    return Column(
      children:
          state.supportItems.map((item) {
            return SupportItemWidget(
              title: item.title,
              description: item.description,
              icon: item.icon,
              onTap:
                  item.route != null
                      ? () => AppRouter.navigateTo(context, item.route!)
                      : item.onTap != null
                      ? () => item.onTap!()
                      : null,
            );
          }).toList(),
    );
  }

  /// 构建联系方式
  Widget _buildContactMethods(
    BuildContext context,
    CustomerServiceState state,
  ) {
    return Column(
      children:
          state.contactMethods.map((contact) {
            return ContactMethodWidget(contact: contact);
          }).toList(),
    );
  }

  /// 构建常见问题
  Widget _buildFaqItems(
    BuildContext context,
    CustomerServiceState state,
    WidgetRef ref,
  ) {
    return Column(
      children:
          state.faqItems.map((faq) {
            return FaqItemWidget(
              faq: faq,
              onExpansionChanged: (id, expanded) {
                ref
                    .read(customerServiceProvider.notifier)
                    .toggleFaqExpansion(id, expanded);
              },
            );
          }).toList(),
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
