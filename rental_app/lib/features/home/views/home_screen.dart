import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/features/favorite/views/favorite_tab_screen.dart';
import 'package:rental_app/features/message/views/message_tab_screen.dart';
import 'package:rental_app/features/profile/views/profile_tab_screen.dart';
import 'package:rental_app/features/search/views/search_tab_screen.dart';
import 'package:rental_app/shared/widgets/bottom_nav_bar_widget.dart';
import '../viewmodels/bottom_nav_provider.dart';
import 'home_tab_screen.dart';

/// 主页面容器
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    // 根据当前索引返回对应的页面
    Widget getScreen(int index) {
      switch (index) {
        case 0:
          return const HomeTabScreen();
        case 1:
          return const SearchTabScreen();
        case 2:
          return const FavoriteTabScreen();
        case 3:
          return const MessageTabScreen();
        case 4:
          return const ProfileTabScreen();
        default:
          return const HomeTabScreen();
      }
    }

    return Scaffold(
      body: getScreen(currentIndex),
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: currentIndex,
        onTabSelected: (index) {
          ref.read(bottomNavProvider.notifier).setIndex(index);
        },
      ),
    );
  }
}

/// 临时占位页面
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '$title功能正在开发中...',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
