import 'package:flutter/material.dart';
import 'package:rental_app/core/design_tokens.dart';

/// 自定义应用栏组件
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onBackPressed;

  const AppBarWidget({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeLarge,
          fontWeight: FontWeight.bold,
          color: foregroundColor ?? theme.appBarTheme.foregroundColor,
        ),
      ),
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
              : null,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: 0,
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
