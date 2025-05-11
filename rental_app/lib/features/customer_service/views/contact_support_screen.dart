import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import '../viewmodels/customer_service_provider.dart';
import 'widgets/contact_method_widget.dart';

/// 联系客服页面
class ContactSupportScreen extends ConsumerWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customerServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('联系客服'), elevation: 0),
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
      padding: EdgeInsets.all(DesignTokens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部图片
          Center(
            child: Container(
              width: 200,
              height: 200,
              margin: EdgeInsets.symmetric(vertical: DesignTokens.spacingLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.support_agent,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          // 标题
          Center(
            child: Text(
              '我们随时为您服务',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: DesignTokens.spacingSmall),

          // 副标题
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingLarge,
              ),
              child: Text(
                '如果您有任何问题或需要帮助，请通过以下方式联系我们',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeSmall,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ),
          ),
          SizedBox(height: DesignTokens.spacingXLarge),

          // 联系方式标题
          Padding(
            padding: EdgeInsets.only(
              left: DesignTokens.spacingMedium,
              bottom: DesignTokens.spacingMedium,
            ),
            child: Text(
              '联系方式',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 联系方式列表
          ...state.contactMethods.map((contact) {
            return ContactMethodWidget(contact: contact);
          }).toList(),

          SizedBox(height: DesignTokens.spacingXLarge),

          // 在线客服按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: 实现在线客服聊天功能
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('正在为您接入在线客服...')));
              },
              icon: const Icon(Icons.chat),
              label: const Text('在线客服'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: DesignTokens.spacingMedium,
                ),
              ),
            ),
          ),
          SizedBox(height: DesignTokens.spacingMedium),

          // 服务时间提示
          Center(
            child: Text(
              '客服服务时间：周一至周日 9:00-20:00',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXSmall,
                color: Colors.grey.shade500,
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
