import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(LucideIcons.camera, color: Colors.white, size: 16.sp),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
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
            const CustomTextField(
              hintText: 'Phone Number',
              keyboardType: TextInputType.phone,
              prefixIcon: LucideIcons.phone,
            ),
            SizedBox(height: 32.h),
            CustomButton(
              text: 'Save Changes',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Profile updated successfully!'),
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
