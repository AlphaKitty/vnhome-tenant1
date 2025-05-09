import 'package:flutter/material.dart';
import 'package:rental_app/features/auth/views/login_screen.dart';
import 'package:rental_app/features/home/views/home_screen.dart';
import 'package:rental_app/features/house/views/house_detail_screen.dart';
import 'app_router.dart';

/// 路由配置实现
class AppRouterConfig {
  /// 获取所有路由配置
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRouter.login: (context) => const LoginScreen(),
      AppRouter.home: (context) => const HomeScreen(),
      AppRouter.houseDetail: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as String?;
        if (args == null) {
          return const Scaffold(body: Center(child: Text('房源ID不能为空')));
        }
        return HouseDetailScreen(houseId: args);
      },
    };
  }

  /// 处理未知路由
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder:
          (context) => Scaffold(
            appBar: AppBar(title: const Text('页面不存在')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    '找不到请求的页面',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '路径: ${settings.name}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRouter.home,
                          (route) => false,
                        ),
                    child: const Text('返回首页'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
