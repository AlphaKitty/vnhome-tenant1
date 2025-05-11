import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';
import 'package:rental_app/features/auth/viewmodels/auth_provider.dart';
import '../models/profile_item_model.dart';
import '../models/profile_stat_model.dart';
import '../viewmodels/profile_provider.dart';
import 'profile_menu_item_widget.dart';
import 'profile_stat_item_widget.dart';

/// 个人中心页面
class ProfileTabScreen extends ConsumerWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 顶部个人信息
          SliverToBoxAdapter(
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.only(
                top:
                    MediaQuery.of(context).padding.top +
                    DesignTokens.spacingLarge,
                bottom: DesignTokens.spacingLarge,
                left: DesignTokens.spacingLarge,
                right: DesignTokens.spacingLarge,
              ),
              child: Row(
                children: [
                  // 头像
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    backgroundImage:
                        user?.avatar != null
                            ? NetworkImage(user!.avatar!)
                            : null,
                    child:
                        user?.avatar == null
                            ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            )
                            : null,
                  ),
                  SizedBox(width: DesignTokens.spacingLarge),
                  // 用户信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.username ?? '游客',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: DesignTokens.spacingXSmall),
                        Text(
                          user?.phoneNumber ?? '点击登录',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 设置按钮
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      AppRouter.navigateTo(context, AppRouter.settings);
                    },
                  ),
                ],
              ),
            ),
          ),

          // 统计数据卡片
          SliverToBoxAdapter(
            child: Card(
              margin: EdgeInsets.all(DesignTokens.spacingMedium),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              ),
              child: SizedBox(
                height: 90,
                child:
                    profileState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                          children: _buildStatItems(
                            context,
                            profileState.stats,
                          ),
                        ),
              ),
            ),
          ),

          // 菜单列表
          SliverToBoxAdapter(
            child: Card(
              margin: EdgeInsets.all(DesignTokens.spacingMedium),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              ),
              child:
                  profileState.isLoading
                      ? const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      )
                      : Column(
                        children: _buildMenuItems(
                          context,
                          profileState.menuItems,
                          ref,
                        ),
                      ),
            ),
          ),

          // 退出登录按钮
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(DesignTokens.spacingLarge),
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutConfirmDialog(context, ref);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text('退出登录'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建统计项
  List<Widget> _buildStatItems(
    BuildContext context,
    List<ProfileStatModel> stats,
  ) {
    final result = <Widget>[];
    for (var i = 0; i < stats.length; i++) {
      final stat = stats[i];
      result.add(
        Expanded(
          child: ProfileStatItemWidget(
            title: stat.title,
            value: stat.value,
            showBorder: i > 0,
            onTap:
                stat.route != null
                    ? () => AppRouter.navigateTo(context, stat.route!)
                    : null,
          ),
        ),
      );
    }
    return result;
  }

  /// 构建菜单项
  List<Widget> _buildMenuItems(
    BuildContext context,
    List<ProfileItemModel> menuItems,
    WidgetRef ref,
  ) {
    return menuItems
        .map(
          (item) => ProfileMenuItemWidget(
            title: item.title,
            icon: item.icon,
            onTap:
                item.route != null
                    ? () => AppRouter.navigateTo(context, item.route!)
                    : item.onTap as VoidCallback?,
          ),
        )
        .toList();
  }

  /// 显示退出登录确认对话框
  void _showLogoutConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('确认退出'),
            content: const Text('确定要退出登录吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(profileProvider.notifier).logout();
                  AppRouter.navigateAndRemoveUntil(context, AppRouter.login);
                },
                child: const Text('确定'),
              ),
            ],
          ),
    );
  }
}
