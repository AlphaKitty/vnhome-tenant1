import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 底部导航状态管理
class BottomNavNotifier extends StateNotifier<int> {
  BottomNavNotifier() : super(0);

  /// 更新当前选中的底部导航项
  void setIndex(int index) {
    state = index;
  }
}

/// 底部导航提供者
final bottomNavProvider = StateNotifierProvider<BottomNavNotifier, int>((ref) {
  return BottomNavNotifier();
});
