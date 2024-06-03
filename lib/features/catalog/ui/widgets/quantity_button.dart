import 'package:flutter/material.dart';

import '../../../../core/theming/app_colors.dart';

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const QuantityButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onPressed == null ? Colors.grey.shade300 : AppColors.primary,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: onPressed == null ? Colors.grey : Colors.white,
        ),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }
}
