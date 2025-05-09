import 'package:flutter/material.dart';

/// 底部导航栏组件
class BottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const BottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabSelected,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜索'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '收藏'),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: '消息'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
      ],
    );
  }
}
