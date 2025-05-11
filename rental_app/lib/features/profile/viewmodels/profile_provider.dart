import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/routes/app_router.dart';
import 'package:rental_app/features/auth/viewmodels/auth_provider.dart';
import '../models/profile_item_model.dart';
import '../models/profile_stat_model.dart';

/// 个人中心状态
class ProfileState {
  final List<ProfileStatModel> stats;
  final List<ProfileItemModel> menuItems;
  final bool isLoading;
  final String? error;

  ProfileState({
    this.stats = const [],
    this.menuItems = const [],
    this.isLoading = false,
    this.error,
  });

  /// 创建加载状态
  ProfileState copyWithLoading() {
    return ProfileState(
      stats: stats,
      menuItems: menuItems,
      isLoading: true,
      error: null,
    );
  }

  /// 创建加载完成状态
  ProfileState copyWithData({
    List<ProfileStatModel>? stats,
    List<ProfileItemModel>? menuItems,
  }) {
    return ProfileState(
      stats: stats ?? this.stats,
      menuItems: menuItems ?? this.menuItems,
      isLoading: false,
      error: null,
    );
  }

  /// 创建错误状态
  ProfileState copyWithError(String errorMessage) {
    return ProfileState(
      stats: stats,
      menuItems: menuItems,
      isLoading: false,
      error: errorMessage,
    );
  }
}

/// 个人中心状态管理器
class ProfileNotifier extends StateNotifier<ProfileState> {
  final Ref ref;

  ProfileNotifier(this.ref) : super(ProfileState()) {
    // 初始化时加载数据
    loadProfileData();
  }

  /// 加载个人中心数据
  Future<void> loadProfileData() async {
    state = state.copyWithLoading();

    try {
      // 模拟网络请求加载数据
      await Future.delayed(const Duration(milliseconds: 500));

      // 获取统计数据
      final stats = _getProfileStats();

      // 获取菜单项
      final menuItems = _getProfileMenuItems();

      state = state.copyWithData(stats: stats, menuItems: menuItems);
    } catch (e) {
      state = state.copyWithError('加载数据失败: ${e.toString()}');
    }
  }

  /// 获取统计数据
  List<ProfileStatModel> _getProfileStats() {
    return [
      ProfileStatModel(
        id: 'favorites',
        title: '我的收藏',
        value: '3',
        route: AppRouter.favorite,
      ),
      ProfileStatModel(
        id: 'viewingRecords',
        title: '看房记录',
        value: '2',
        route: AppRouter.home, // 临时路由
      ),
      ProfileStatModel(
        id: 'payments',
        title: '支付记录',
        value: '7',
        route: AppRouter.payment,
      ),
    ];
  }

  /// 获取菜单项
  List<ProfileItemModel> _getProfileMenuItems() {
    return [
      ProfileItemModel(
        id: 'payment',
        title: '支付与合同',
        icon: Icons.file_copy,
        route: AppRouter.contract,
      ),
      ProfileItemModel(
        id: 'favorites',
        title: '我的收藏',
        icon: Icons.favorite,
        route: AppRouter.favorite,
      ),
      ProfileItemModel(
        id: 'appointments',
        title: '看房预约',
        icon: Icons.calendar_today,
        route: AppRouter.home, // 临时路由
      ),
      ProfileItemModel(
        id: 'repair',
        title: '报修服务',
        icon: Icons.build,
        route: AppRouter.repair,
      ),
      ProfileItemModel(
        id: 'payments',
        title: '支付记录',
        icon: Icons.payment,
        route: AppRouter.payment,
      ),
      ProfileItemModel(
        id: 'settings',
        title: '设置',
        icon: Icons.settings,
        route: AppRouter.settings,
      ),
      ProfileItemModel(
        id: 'customerService',
        title: '客服中心',
        icon: Icons.headset_mic,
        route: AppRouter.customerService,
      ),
    ];
  }

  /// 退出登录
  void logout() {
    ref.read(authProvider.notifier).logout();
  }
}

/// 个人中心状态提供者
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier(ref);
});
