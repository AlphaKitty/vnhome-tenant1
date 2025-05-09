import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

/// 认证状态
class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.user,
    this.isLoading = false,
    this.error,
  });

  /// 创建加载状态
  AuthState copyWithLoading() {
    return AuthState(
      isAuthenticated: isAuthenticated,
      user: user,
      isLoading: true,
      error: null,
    );
  }

  /// 创建错误状态
  AuthState copyWithError(String errorMessage) {
    return AuthState(
      isAuthenticated: isAuthenticated,
      user: user,
      isLoading: false,
      error: errorMessage,
    );
  }

  /// 创建认证成功状态
  AuthState copyWithAuthenticated(UserModel user) {
    return AuthState(
      isAuthenticated: true,
      user: user,
      isLoading: false,
      error: null,
    );
  }

  /// 创建登出状态
  AuthState copyWithLoggedOut() {
    return AuthState(
      isAuthenticated: false,
      user: null,
      isLoading: false,
      error: null,
    );
  }
}

/// 认证状态管理器
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  /// 登录方法
  Future<void> login(String username, String password) async {
    // 设置为加载状态
    state = state.copyWithLoading();

    try {
      // 在实际应用中，这里会调用API进行身份验证
      // 现在为了演示，使用模拟数据
      await Future.delayed(const Duration(seconds: 2)); // 模拟网络请求

      if (username == '1' && password == '1') {
        // 登录成功
        final user = UserModel(
          id: '1',
          username: username,
          phoneNumber: '138****6789',
          avatar: null,
        );
        state = state.copyWithAuthenticated(user);
      } else {
        // 登录失败
        state = state.copyWithError('用户名或密码错误');
      }
    } catch (e) {
      // 处理异常
      state = state.copyWithError('登录失败: ${e.toString()}');
    }
  }

  /// 登出方法
  void logout() {
    state = state.copyWithLoggedOut();
  }

  /// 重置错误状态
  void resetError() {
    if (state.error != null) {
      state = AuthState(
        isAuthenticated: state.isAuthenticated,
        user: state.user,
        isLoading: false,
        error: null,
      );
    }
  }
}

/// 认证状态提供者
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
