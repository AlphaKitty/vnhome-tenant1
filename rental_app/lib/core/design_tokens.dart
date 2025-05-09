import 'package:flutter/material.dart';

/// 设计系统令牌，管理全局统一的样式变量
class DesignTokens {
  // 主要颜色
  static const Color primaryColor = Color(0xFF4A6EE0);
  static const Color secondaryColor = Color(0xFFF0F4FF);
  static const Color textColor = Color(0xFF333333);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color cardBackgroundColor = Color(0xFFF9F9F9);
  static const Color borderColor = Color(0xFFEAEAEA);

  // 深色主题颜色
  static const Color darkPrimaryColor = Color(0xFF5D7EFF);
  static const Color darkSecondaryColor = Color(0xFF2D3748);
  static const Color darkTextColor = Color(0xFFE2E8F0);
  static const Color darkBackgroundColor = Color(0xFF1A202C);
  static const Color darkCardBackgroundColor = Color(0xFF2D3748);
  static const Color darkBorderColor = Color(0xFF4A5568);

  // 功能性颜色
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);
  static const Color warningColor = Color(0xFFECC94B);
  static const Color infoColor = Color(0xFF3182CE);

  // 字体大小
  static const double fontSizeXSmall = 12.0; // 小标签、备注
  static const double fontSizeSmall = 14.0; // 次要文本
  static const double fontSizeMedium = 16.0; // 默认正文
  static const double fontSizeLarge = 18.0; // 小标题
  static const double fontSizeXLarge = 22.0; // 页面标题
  static const double fontSizeXXLarge = 28.0; // 大标题

  // 行高
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.6;
  static const double lineHeightRelaxed = 2.0;

  // 间距
  static const double spacingXXSmall = 2.0;
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;

  // 圆角
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 24.0;
  static const Radius circularRadiusSmall = Radius.circular(radiusSmall);
  static const Radius circularRadiusMedium = Radius.circular(radiusMedium);
  static const Radius circularRadiusLarge = Radius.circular(radiusLarge);
  static const Radius circularRadiusXLarge = Radius.circular(radiusXLarge);

  // 阴影
  static List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 5,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ];
}
