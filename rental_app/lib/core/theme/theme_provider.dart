import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';

/// 主题模式状态
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  /// 切换主题
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  /// 设置亮色主题
  void setLightTheme() {
    state = ThemeMode.light;
  }

  /// 设置暗色主题
  void setDarkTheme() {
    state = ThemeMode.dark;
  }
}

/// 主题模式提供者
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

/// 当前主题数据提供者
final currentThemeProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == ThemeMode.light
      ? AppTheme.lightTheme
      : AppTheme.darkTheme;
});
