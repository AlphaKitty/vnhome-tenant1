import 'package:flutter/material.dart';
import 'package:rental_app/features/auth/views/login_screen.dart';
import 'package:rental_app/features/contract/views/contract_detail_screen.dart';
import 'package:rental_app/features/favorite/views/favorite_tab_screen.dart';
import 'package:rental_app/features/home/views/home_screen.dart';
import 'package:rental_app/features/house/views/house_detail_screen.dart';
import 'package:rental_app/features/message/views/chat_detail_screen.dart';
import 'package:rental_app/features/message/views/message_tab_screen.dart';
import 'package:rental_app/features/payment/views/payment_contract_screen.dart';
import 'package:rental_app/features/payment/views/payment_detail_screen.dart';
import 'package:rental_app/features/payment/views/payment_record_screen.dart';
import 'package:rental_app/features/profile/views/profile_tab_screen.dart';
import 'package:rental_app/features/repair/views/repair_service_screen.dart';
import 'package:rental_app/features/search/views/search_tab_screen.dart';
import 'package:rental_app/features/settings/views/settings_screen.dart';
import 'package:rental_app/features/settings/views/profile_edit_screen.dart';
import 'package:rental_app/features/settings/views/password_change_screen.dart';
import 'package:rental_app/features/customer_service/views/customer_service_screen.dart';
import 'package:rental_app/features/customer_service/views/faq_screen.dart';
import 'package:rental_app/features/customer_service/views/contact_support_screen.dart';
import 'package:rental_app/features/customer_service/views/feedback_screen.dart';
import 'app_router.dart';

/// 路由配置实现
class AppRouterConfig {
  /// 获取所有路由配置
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRouter.login: (context) => const LoginScreen(),
      AppRouter.home: (context) => const HomeScreen(),
      AppRouter.profile: (context) => const ProfileTabScreen(),
      AppRouter.search: (context) => const SearchTabScreen(),
      AppRouter.message: (context) => const MessageTabScreen(),
      AppRouter.favorite: (context) => const FavoriteTabScreen(),
      AppRouter.payment: (context) => const PaymentRecordScreen(),
      AppRouter.contract: (context) => const PaymentContractScreen(),
      AppRouter.repair: (context) => const RepairServiceScreen(),
      AppRouter.contractDetail: (context) => const ContractDetailScreen(),

      // 设置相关路由
      AppRouter.settings: (context) => const SettingsScreen(),
      AppRouter.profileEdit: (context) => const ProfileEditScreen(),
      AppRouter.passwordChange: (context) => const PasswordChangeScreen(),

      // 客服中心相关路由
      AppRouter.customerService: (context) => const CustomerServiceScreen(),
      AppRouter.faq: (context) => const FaqScreen(),
      AppRouter.contactSupport: (context) => const ContactSupportScreen(),
      AppRouter.feedback: (context) => const FeedbackScreen(),

      AppRouter.paymentDetail: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as String?;
        if (args == null) {
          return const Scaffold(body: Center(child: Text('支付ID不能为空')));
        }
        return PaymentDetailScreen(paymentId: args);
      },
      AppRouter.chat: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as String?;
        if (args == null) {
          return const Scaffold(body: Center(child: Text('聊天ID不能为空')));
        }
        return ChatDetailScreen(chatId: args);
      },
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
