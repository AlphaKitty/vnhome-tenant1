import 'package:flutter/material.dart';
import 'package:rental_app/features/settings/views/profile_edit_screen.dart';
import 'package:rental_app/features/settings/views/settings_screen.dart';

/// 应用路由管理
class AppRouter {
  /// 路由名称定义
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String search = '/search';
  static const String houseDetail = '/house-detail';
  static const String favorite = '/favorite';
  static const String message = '/message';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String payment = '/payment';
  static const String paymentDetail = '/payment-detail';
  static const String contract = '/contract';
  static const String contractDetail = '/contract-detail';
  static const String repair = '/repair';

  // 设置相关路由
  static const String settings = '/settings';
  static const String profileEdit = '/settings/profile-edit';
  static const String passwordChange = '/settings/password-change';
  static const String phoneChange = '/settings/phone-change';
  static const String paymentSecurity = '/settings/payment-security';
  static const String privacySettings = '/settings/privacy';
  static const String aboutUs = '/settings/about';
  static const String helpCenter = '/settings/help';
  static const String userAgreement = '/settings/agreement';

  // 客服中心相关路由
  static const String customerService = '/customer-service';
  static const String contactSupport = '/customer-service/contact';
  static const String faq = '/customer-service/faq';
  static const String feedback = '/customer-service/feedback';

  /// 获取所有路由配置
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // 具体路由实现将在创建视图后添加
      // splash: (context) => const SplashScreen(),

      // 设置相关路由
      settings: (context) => const SettingsScreen(),
      profileEdit: (context) => const ProfileEditScreen(),
      // 其他设置子页面路由将在实现后添加
    };
  }

  /// 跳转到指定页面
  static Future<T?> navigateTo<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  /// 替换当前页面
  static Future<T?> navigateReplace<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, dynamic>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// 清除所有页面并跳转
  static Future<T?> navigateAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  /// 返回上一页
  static void goBack<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }
}
