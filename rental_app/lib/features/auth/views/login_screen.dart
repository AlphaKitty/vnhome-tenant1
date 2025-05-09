import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_app/core/design_tokens.dart';
import 'package:rental_app/core/routes/app_router.dart';
import '../viewmodels/auth_provider.dart';

/// 登录页面
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // 如果登录成功，跳转到首页
    ref.listen<AuthState>(authProvider, (previous, current) {
      if (current.isAuthenticated) {
        AppRouter.navigateAndRemoveUntil(context, AppRouter.home);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('账号登录'), centerTitle: true),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(DesignTokens.spacingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo或应用标题
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: DesignTokens.spacingXLarge,
                    ),
                    child: Text(
                      '租房APP',
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: DesignTokens.spacingLarge),

                  // 用户名输入框
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: '用户名',
                      hintText: '请输入用户名/手机号',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入用户名';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: DesignTokens.spacingLarge),

                  // 密码输入框
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: '密码',
                      hintText: '请输入密码',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入密码';
                      }
                      return null;
                    },
                  ),

                  // 错误信息
                  if (authState.error != null)
                    Padding(
                      padding: EdgeInsets.only(top: DesignTokens.spacingMedium),
                      child: Text(
                        authState.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: DesignTokens.fontSizeSmall,
                        ),
                      ),
                    ),

                  SizedBox(height: DesignTokens.spacingXLarge),

                  // 登录按钮
                  ElevatedButton(
                    onPressed:
                        authState.isLoading
                            ? null
                            : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                ref
                                    .read(authProvider.notifier)
                                    .login(
                                      _usernameController.text,
                                      _passwordController.text,
                                    );
                              }
                            },
                    child:
                        authState.isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text('登录'),
                  ),

                  SizedBox(height: DesignTokens.spacingMedium),

                  // 注册和忘记密码
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          // 跳转到注册页面
                        },
                        child: const Text('注册账号'),
                      ),
                      TextButton(
                        onPressed: () {
                          // 跳转到忘记密码页面
                        },
                        child: const Text('忘记密码？'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
