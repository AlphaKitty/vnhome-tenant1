import 'package:flutter/material.dart';

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
  static const String contract = '/contract';
  static const String repair = '/repair';

  /// 获取所有路由配置
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // 具体路由实现将在创建视图后添加
      // splash: (context) => const SplashScreen(),
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
