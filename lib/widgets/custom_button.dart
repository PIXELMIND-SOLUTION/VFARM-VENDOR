import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final button = isOutlined
        ? OutlinedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: icon != null
                ? Icon(icon, size: ResponsiveHelper.sp(5))
                : const SizedBox.shrink(),
            label: isLoading
                ? SizedBox(
                    height: ResponsiveHelper.sp(5),
                    width: ResponsiveHelper.sp(5),
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.sp(4),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            style: OutlinedButton.styleFrom(
              foregroundColor: textColor ?? AppColors.primary,
              side: BorderSide(color: backgroundColor ?? AppColors.primary),
              minimumSize: Size(
                width ?? ResponsiveHelper.w(90),
                height ?? ResponsiveHelper.h(6),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        : ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: icon != null
                ? Icon(icon, size: ResponsiveHelper.sp(5))
                : const SizedBox.shrink(),
            label: isLoading
                ? SizedBox(
                    height: ResponsiveHelper.sp(5),
                    width: ResponsiveHelper.sp(5),
                    child: const CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.sp(4),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? AppColors.primary,
              foregroundColor: textColor ?? Colors.white,
              minimumSize: Size(
                width ?? ResponsiveHelper.w(90),
                height ?? ResponsiveHelper.h(6),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

    return button;
  }
}
