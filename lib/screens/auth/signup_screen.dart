import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Join us and start shopping premium collections.',
                style: TextStyle(fontSize: 16.sp, color: AppTheme.textSecondary),
              ),
              SizedBox(height: 40.h),
              const CustomTextField(
                hintText: 'Full Name',
                prefixIcon: LucideIcons.user,
              ),
              SizedBox(height: 16.h),
              const CustomTextField(
                hintText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: LucideIcons.mail,
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                hintText: 'Password',
                isPassword: true,
                prefixIcon: LucideIcons.lock,
                suffixIcon: Icon(LucideIcons.eye, color: AppTheme.textSecondary, size: 20.sp),
              ),
              SizedBox(height: 32.h),
              CustomButton(
                text: 'Sign Up',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: TextStyle(color: AppTheme.textSecondary, fontSize: 14.sp)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
