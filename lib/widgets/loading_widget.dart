import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          if (message != null) ...[
            SizedBox(height: ResponsiveHelper.h(2)),
            Text(
              message!,
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(3.5),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
