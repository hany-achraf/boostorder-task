import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoImageOrErrorLoading extends StatelessWidget {
  const NoImageOrErrorLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.w,
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: 48.sp,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}
