import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';
import 'package:rental_app/features/auth/viewmodels/auth_provider.dart';
import '../viewmodels/settings_provider.dart';
import 'settings_group_widget.dart';
import 'widgets/settings_header_widget.dart';

/// 设置主屏幕
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(title: const Text('设置'), elevation: 0),
      body:
          settingsState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : settingsState.error != null
              ? _buildErrorWidget(context, settingsState.error!, ref)
              : _buildSettingsContent(context, settingsState, user),
    );
  }

  /// 构建设置内容
  Widget _buildSettingsContent(
    BuildContext context,
    SettingsState state,
    user,
  ) {
    return ListView(
      padding: EdgeInsets.only(
        top: DesignTokens.spacingMedium,
        bottom: DesignTokens.spacingXLarge,
      ),
      children: [
        // 头部信息
        Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingMedium),
          child: SettingsHeaderWidget(
            title: '个人设置',
            subtitle:
                user?.username != null ? '当前登录账号: ${user.username}' : '您尚未登录',
            icon: Icons.settings,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.1),
            iconColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: DesignTokens.spacingLarge),

        // 设置分组列表
        ...state.settingsGroups
            .map(
              (group) =>
                  SettingsGroupWidget(title: group.title, items: group.items),
            )
            .toList(),
      ],
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
              ref.read(settingsProvider.notifier).loadSettingsData();
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}
