import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Password',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your new password must be different from previous used passwords.',
                style: TextStyle(fontSize: 16.sp, color: AppTheme.textSecondary, height: 1.5),
              ),
              SizedBox(height: 40.h),
              CustomTextField(
                hintText: 'New Password',
                isPassword: true,
                prefixIcon: LucideIcons.lock,
                suffixIcon: Icon(LucideIcons.eye, color: AppTheme.textSecondary, size: 20.sp),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                hintText: 'Confirm Password',
                isPassword: true,
                prefixIcon: LucideIcons.lock,
                suffixIcon: Icon(LucideIcons.eye, color: AppTheme.textSecondary, size: 20.sp),
              ),
              SizedBox(height: 40.h),
              CustomButton(
                text: 'Reset Password',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Password reset successfully!'),
                      backgroundColor: AppTheme.primaryColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 1), () {
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
