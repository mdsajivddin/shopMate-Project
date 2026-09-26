import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                'Reset Password',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Enter the email associated with your account and we\'ll send an email with instructions to reset your password.',
                style: TextStyle(fontSize: 16.sp, color: AppTheme.textSecondary, height: 1.5),
              ),
              SizedBox(height: 40.h),
              const CustomTextField(
                hintText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: LucideIcons.mail,
              ),
              SizedBox(height: 32.h),
              CustomButton(
                text: 'Send Instructions',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OtpVerificationScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
