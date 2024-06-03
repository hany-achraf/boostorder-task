import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class Themes {
  static ThemeData light = ThemeData.light(useMaterial3: false).copyWith(
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    colorScheme: const ColorScheme.light(primary: AppColors.primary),
    primaryColorDark: AppColors.primary,
    appBarTheme: ThemeData().appBarTheme.copyWith(
          elevation: 0,
          toolbarHeight: 70.h,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData.fallback().copyWith(
            color: Colors.white,
            size: 16.sp,
          ),
          actionsIconTheme: const IconThemeData.fallback().copyWith(
            color: Colors.white,
            size: 18.sp,
          ),
        ),
    textTheme: Typography.englishLike2018.apply(
      fontSizeFactor: 1.sp,
      bodyColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          fontSize: 14.sp,
        ),
      ),
    ),
    snackBarTheme: const SnackBarThemeData().copyWith(
      contentTextStyle: TextStyle(
        fontSize: 14.sp,
      ),
    ),
  );
}
