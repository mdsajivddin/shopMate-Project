import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your password must be at least 8 characters long and include a mix of letters, numbers, and symbols.',
              style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary, height: 1.5),
            ),
            SizedBox(height: 32.h),
            CustomTextField(
              hintText: 'Current Password',
              isPassword: true,
              prefixIcon: LucideIcons.lock,
              suffixIcon: Icon(LucideIcons.eye, color: AppTheme.textSecondary, size: 20.sp),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              hintText: 'New Password',
              isPassword: true,
              prefixIcon: LucideIcons.lock,
              suffixIcon: Icon(LucideIcons.eye, color: AppTheme.textSecondary, size: 20.sp),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              hintText: 'Confirm New Password',
              isPassword: true,
              prefixIcon: LucideIcons.lock,
              suffixIcon: Icon(LucideIcons.eye, color: AppTheme.textSecondary, size: 20.sp),
            ),
            SizedBox(height: 40.h),
            CustomButton(
              text: 'Update Password',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Password changed successfully!'),
                    backgroundColor: AppTheme.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                );
                Future.delayed(const Duration(seconds: 1), () {
                  if (context.mounted) Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
