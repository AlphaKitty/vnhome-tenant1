import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/routes/app_router.dart';
import 'package:rental_app/core/routes/app_router_config.dart';
import 'package:rental_app/core/theme/app_theme.dart';
import 'package:rental_app/core/theme/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: RentalApp()));
}

/// 应用主入口
class RentalApp extends ConsumerWidget {
  const RentalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 获取当前主题模式
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: '租房APP',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      initialRoute: AppRouter.login, // 设置初始路由为登录页
      routes: AppRouterConfig.getRoutes(),
      onUnknownRoute: AppRouterConfig.onUnknownRoute,
      debugShowCheckedModeBanner: false, // 去除调试标记
    );
  }
}
