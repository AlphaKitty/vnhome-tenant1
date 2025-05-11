import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/routes/app_router.dart';
import 'package:rental_app/features/auth/viewmodels/auth_provider.dart';
import '../models/settings_item_model.dart';

/// 设置页面状态
class SettingsState {
  final List<SettingsGroupModel> settingsGroups;
  final bool isDarkMode;
  final String language;
  final bool isNotificationEnabled;
  final bool isLoading;
  final String? error;

  SettingsState({
    this.settingsGroups = const [],
    this.isDarkMode = false,
    this.language = 'zh_CN',
    this.isNotificationEnabled = true,
    this.isLoading = false,
    this.error,
  });

  /// 创建加载状态
  SettingsState copyWithLoading() {
    return SettingsState(
      settingsGroups: settingsGroups,
      isDarkMode: isDarkMode,
      language: language,
      isNotificationEnabled: isNotificationEnabled,
      isLoading: true,
      error: null,
    );
  }

  /// 创建加载完成状态
  SettingsState copyWithData({
    List<SettingsGroupModel>? settingsGroups,
    bool? isDarkMode,
    String? language,
    bool? isNotificationEnabled,
  }) {
    return SettingsState(
      settingsGroups: settingsGroups ?? this.settingsGroups,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
      isLoading: false,
      error: null,
    );
  }

  /// 创建错误状态
  SettingsState copyWithError(String errorMessage) {
    return SettingsState(
      settingsGroups: settingsGroups,
      isDarkMode: isDarkMode,
      language: language,
      isNotificationEnabled: isNotificationEnabled,
      isLoading: false,
      error: errorMessage,
    );
  }
}

/// 设置状态管理器
class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref ref;

  SettingsNotifier(this.ref) : super(SettingsState()) {
    // 初始化时加载数据
    loadSettingsData();
  }

  /// 加载设置数据
  Future<void> loadSettingsData() async {
    state = state.copyWithLoading();

    try {
      // 模拟从本地存储或API加载设置
      await Future.delayed(const Duration(milliseconds: 500));

      // 获取设置项分组
      final settingsGroups = _getSettingsGroups();

      state = state.copyWithData(settingsGroups: settingsGroups);
    } catch (e) {
      state = state.copyWithError('加载设置失败: ${e.toString()}');
    }
  }

  /// 获取设置项分组
  List<SettingsGroupModel> _getSettingsGroups() {
    return [
      // 个人信息设置
      SettingsGroupModel(
        id: 'personal',
        title: '个人信息',
        items: [
          SettingsItemModel(
            id: 'profile',
            title: '修改个人资料',
            icon: Icons.person,
            route: AppRouter.profileEdit,
          ),
          SettingsItemModel(
            id: 'password',
            title: '修改密码',
            icon: Icons.lock,
            route: AppRouter.passwordChange,
          ),
          SettingsItemModel(
            id: 'phone',
            title: '绑定手机号',
            icon: Icons.phone_android,
            route: AppRouter.phoneChange,
          ),
        ],
      ),

      // 应用设置
      SettingsGroupModel(
        id: 'app',
        title: '应用设置',
        items: [
          SettingsItemModel(
            id: 'darkMode',
            title: '夜间模式',
            icon: Icons.dark_mode,
            trailing: Switch(
              value: state.isDarkMode,
              onChanged: (value) => toggleDarkMode(value),
            ),
          ),
          SettingsItemModel(
            id: 'language',
            title: '语言',
            icon: Icons.language,
            trailing: const Text('简体中文 >'),
            onTap: () => _showLanguageSelector(),
          ),
          SettingsItemModel(
            id: 'notification',
            title: '消息通知',
            icon: Icons.notifications,
            trailing: Switch(
              value: state.isNotificationEnabled,
              onChanged: (value) => toggleNotification(value),
            ),
          ),
        ],
      ),

      // 支付与安全
      SettingsGroupModel(
        id: 'security',
        title: '支付与安全',
        items: [
          SettingsItemModel(
            id: 'paymentManage',
            title: '支付管理',
            icon: Icons.payment,
            route: AppRouter.paymentSecurity,
          ),
          SettingsItemModel(
            id: 'privacy',
            title: '隐私设置',
            icon: Icons.security,
            route: AppRouter.privacySettings,
          ),
        ],
      ),

      // 其他设置
      SettingsGroupModel(
        id: 'other',
        title: '其他',
        items: [
          SettingsItemModel(
            id: 'about',
            title: '关于我们',
            icon: Icons.info,
            route: AppRouter.aboutUs,
          ),
          SettingsItemModel(
            id: 'help',
            title: '帮助中心',
            icon: Icons.help,
            route: AppRouter.helpCenter,
          ),
          SettingsItemModel(
            id: 'agreement',
            title: '用户协议',
            icon: Icons.description,
            route: AppRouter.userAgreement,
          ),
          SettingsItemModel(
            id: 'logout',
            title: '退出登录',
            icon: Icons.logout,
            onTap: () => logout(),
          ),
        ],
      ),
    ];
  }

  /// 切换夜间模式
  void toggleDarkMode(bool value) {
    state = state.copyWithData(isDarkMode: value);
    // TODO: 实现主题切换逻辑
  }

  /// 切换消息通知
  void toggleNotification(bool value) {
    state = state.copyWithData(isNotificationEnabled: value);
    // TODO: 实现消息通知开关逻辑
  }

  /// 显示语言选择器
  void _showLanguageSelector() {
    // TODO: 实现语言选择逻辑
  }

  /// 退出登录
  void logout() {
    ref.read(authProvider.notifier).logout();
  }
}

/// 设置状态提供者
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier(ref);
  },
);
